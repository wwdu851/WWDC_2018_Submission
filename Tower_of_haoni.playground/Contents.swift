import UIKit
import PlaygroundSupport
import AVFoundation
//: Welcome to Tower of Hanoi
//: ---------------
//: Tower of Hanoi is a math game originated from three towers with 64 golden rings with different sizes in a temple in India. At first, all rings were stacked from largest to smallest, where the smallest ring is on the top, and the largest is in the bottom. According to the legend, the world would be ended when all 64 rings are moved from the first tower to the third tower with three following rules:
//: 1. Only one ring could be moved at one time
//: 2. The ring could no be stacked on a ring that is smaller than itself
//: 3. Moves could be performed by moving a ring from the top ring of a certain tower to the top of another tower.
//:
//: This playground is an Swift version of Tower of Hanoi. You can play around with it. You will win the game if you move all the discs to the column on the right. In the default mode, you can use:
//: * ![UpIcon](upwardArrowSmall.png) to pick up a disc from a tower
//: * ![DownIcon](downwardArrowSmall.png) to drop down a disc to a tower
//:
//: The AI mode is here when you want Swift to perform the magic of solving Tower of Hanoi. Please allow AI to calculate for a few seconds as the number of layers increases.
//:
//: Fun fact: It actually takes about 585 billion years to finish the original one.
//:
//: Have Fun!
class MyViewController : UIViewController {
//: With the consideration of performing visualization with shorter calculation speed, the maximum number of pieces for AI to solve is preset to 7. Changing this number to numbers larger than 7 would enable the AI to perform visulization for games with more pieces. With that said, please allow the AI to take more time to perform the calculation.
    var AIUpperBoundForSolving = 7
    
    var player:AVAudioPlayer?
    var numberOfPieces = 5
    var AISpeed = 0.5
    let plusButton = UIButton(frame: CGRect(x: 170, y: 85, width: 50, height: 50))
    let minusButton = UIButton(frame: CGRect(x: 30, y: 85, width: 50, height: 50))
    let resetButton = UIButton(frame: CGRect(x: 230, y: 85, width: 115, height: 50))
    let numberOfPieceDisplay = UILabel(frame: CGRect(x: 88, y: 100, width: 74, height: 20))
    let leftButton = UIButton(frame: CGRect(x: 37.5, y: 170, width: 50, height: 50))
    let middleButton = UIButton(frame: CGRect(x: 162.5, y: 170, width: 50, height: 50))
    let rightButton = UIButton(frame: CGRect(x: 287.5, y: 170, width: 50, height: 50))
    let base = UIView(frame: CGRect(x: 0, y: 500, width: 375, height: 20))
    let leftcolumn = UIView(frame: CGRect(x: 52.5, y: 300, width: 20, height: 200))
    let middlecolumn = UIView(frame: CGRect(x: 177.5, y: 300, width: 20, height: 200))
    let rightcolumn = UIView(frame: CGRect(x: 302.5, y: 300, width: 20, height: 200))
    let pieceCache = UIView(frame: CGRect(x: 0, y: 250, width: 375, height: 30))
    let AISpeedButton = UIButton(frame: CGRect(x: 30, y: 540, width: 150, height: 50))
    let AIStart = UIButton(frame: CGRect(x: 195, y: 540, width: 150, height: 50))
    let musicButton = UIButton(frame: CGRect(x: 30, y: 600, width: 315, height: 50))
    let availableColor = [#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1),#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1),#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1),#colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1),#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1058823529, alpha: 1),#colorLiteral(red: 0.176470592617989, green: 0.498039215803146, blue: 0.756862759590149, alpha: 1.0),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
    var AICounter = 0
    
    //: Background Calculation
    var leftPieceArray = [Int]()
    var middlePieceArray = [Int]()
    var rightPieceArray = [Int]()
    var leftSteps = [[Int]]()
    var middleSteps = [[Int]]()
    var rightSteps = [[Int]]()
    var currentLiftedPiece = 1000
    var stepCount = 0
    var stepCounterForAI = 0
    var timer:Timer?
    

    override func loadView() {
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 375, height: 900)
        let buttonList = [leftButton,middleButton,rightButton]
        let columnList = [leftcolumn,middlecolumn,rightcolumn]
        let label = UILabel()
        
        
        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        label.frame = CGRect(x: 0, y: 0, width: 375, height: 50)
        label.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        label.textAlignment = .center
        label.text = "Tower of Hanoi"
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        base.backgroundColor = #colorLiteral(red: 0.5999328494, green: 0.6000387073, blue: 0.5999261737, alpha: 1)
        
        
        loadGame(PieceNum: numberOfPieces)
        middleButton.isEnabled = false
        rightButton.isEnabled = false

        
        numberOfPieceDisplay.text = "\(numberOfPieces) Layers"
        numberOfPieceDisplay.textAlignment = .center
        plusButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        minusButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        plusButton.layer.cornerRadius = 5
        minusButton.layer.cornerRadius = 5
        plusButton.setTitle("+", for: .normal)
        minusButton.setTitle("-", for: .normal)
        AISpeedButton.setTitle("Speed Up AI", for: .normal)
        AIStart.setTitle("Solve by AI", for: .normal)
        plusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        minusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        AISpeedButton.layer.cornerRadius = 5
        AIStart.layer.cornerRadius = 5
        AISpeedButton.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        AIStart.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        AISpeedButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        AIStart.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.textAlignment = .center
        resetButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        resetButton.layer.cornerRadius = 5
        musicButton.layer.cornerRadius = 5
        musicButton.setTitle("Turn Off Background Music", for: .normal)
        musicButton.titleLabel?.textAlignment = .center
        musicButton.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        musicButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        view.addSubview(resetButton)
        view.addSubview(AISpeedButton)
        view.addSubview(numberOfPieceDisplay)
        view.addSubview(plusButton)
        view.addSubview(minusButton)
        view.addSubview(AIStart)
        view.addSubview(musicButton)
        
        for button in buttonList{
            button.setImage(UIImage(named: "upwardArrow"), for: .normal)
            view.addSubview(button)
        }
        for column in columnList{
            column.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            view.addSubview(column)
        }
        for index in leftPieceArray{
            view.addSubview(renderVisualPiece(pieceParam: index, column: 1, row: index))
        }
        
        view.addSubview(label)
        view.addSubview(base)
        view.addSubview(pieceCache)
        
        
        leftButton.addTarget(self, action: #selector(leftButtonAction(sender:)), for: .touchUpInside)
        middleButton.addTarget(self, action: #selector(middleButtonAction(sender:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonAction(sender:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonAction(sender:)), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonAction(sender:)), for: .touchUpInside)
        AISpeedButton.addTarget(self, action: #selector(changeAISpeed(sender:)), for: .touchUpInside)
        AIStart.addTarget(self, action: #selector(printSolve(sender:)), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonAction(sender:)), for: .touchUpInside)
        musicButton.addTarget(self, action: #selector(changeVolume(sender:)), for: .touchUpInside)
        playMusic()
        self.view = view
    }
    
    // Music Stack
    
    func playMusic(){
        let url = Bundle.main.url(forResource: "background_music", withExtension: "m4a")
        do{
            try player = AVAudioPlayer(contentsOf: url!)
            player?.prepareToPlay()
            player?.play()
            player?.volume = 0.5
            player?.numberOfLoops = -1
        }catch{
            print("error")
        }
    }
    
    @objc func changeVolume(sender:UIButton){
        if sender.titleLabel!.text == "Turn Off Background Music"{
            player?.volume = 0.0
            sender.setTitle("Turn On Background Music", for: .normal)
        }else{
            player?.volume = 0.5
            sender.setTitle("Turn Off Background Music", for: .normal)
        }
    }
    
    
    // Game Stack
    func renderVisualPiece (pieceParam:Int,column:Int,row:Int) -> UIView{
        let xCoodinate = ((column - 1) * 125) + 5 * (pieceParam - 1)
        let yCoordinate = 480 - ((row - 1) * 20)
        let height = 20
        let width = 125 - ((pieceParam - 1) * 10)
        let color = availableColor[pieceParam - 1]
        let piece = CGRect(x: xCoodinate, y: yCoordinate, width: width, height: height)
        let pieceView = UIView(frame: piece)
        pieceView.backgroundColor = color
        return pieceView
    }
    
    func renderRawPiece (pieceParam:Int){
        let v = UIView(frame: CGRect(x: 125 + (pieceParam - 1) * 5, y: 0, width: 125 - (pieceParam - 1) * 10, height: 20))
        v.backgroundColor = availableColor[pieceParam - 1]
        
        pieceCache.addSubview(v)
    }
    
    func loadGame(PieceNum:Int){
        for p in 0...(PieceNum - 1){
            self.leftPieceArray.append(p + 1)
        }
    }
    
    func generalButtonAction(button:UIButton,column:Int){
        let buttonList = [leftButton,middleButton,rightButton]
        if button.currentImage == UIImage(named: "upwardArrow"){
            switch column{
            case 0:
                renderRawPiece(pieceParam: leftPieceArray.last!)
                for sub in self.view.subviews{
                    if sub.backgroundColor == availableColor[leftPieceArray.last! - 1]{
                        sub.removeFromSuperview()
                    }
                }
                currentLiftedPiece = leftPieceArray.last!
                leftPieceArray.removeLast()
            case 1:
                renderRawPiece(pieceParam: middlePieceArray.last!)
                for sub in self.view.subviews{
                    if sub.backgroundColor == availableColor[middlePieceArray.last! - 1]{
                        sub.removeFromSuperview()
                    }
                }
                currentLiftedPiece = middlePieceArray.last!
                middlePieceArray.removeLast()
            case 2:
                renderRawPiece(pieceParam: rightPieceArray.last!)
                for sub in self.view.subviews{
                    if sub.backgroundColor == availableColor[rightPieceArray.last! - 1]{
                        sub.removeFromSuperview()
                    }
                }
                currentLiftedPiece = rightPieceArray.last!
                rightPieceArray.removeLast()
            default:
                break
            }
            for b in buttonList{
                b.isEnabled = true
            }
            if leftPieceArray.count > 0{
                if leftPieceArray.last! > currentLiftedPiece{
                    leftButton.isEnabled = false
                }
            }

            if middlePieceArray.count > 0{
                if middlePieceArray.last! > currentLiftedPiece{
                    middleButton.isEnabled = false
                }
            }

            if rightPieceArray.count > 0{
                if rightPieceArray.last! > currentLiftedPiece{
                    rightButton.isEnabled = false
                }
            }
        }else{
            stepCount += 1
            switch column{
            case 0:
                leftPieceArray.append(currentLiftedPiece)
                view.addSubview(renderVisualPiece(pieceParam: currentLiftedPiece, column: 1, row: leftPieceArray.count))
                currentLiftedPiece = 1000
            case 1:
                middlePieceArray.append(currentLiftedPiece)
                view.addSubview(renderVisualPiece(pieceParam: currentLiftedPiece, column: 2, row: middlePieceArray.count))
                currentLiftedPiece = 1000
            case 2:
                rightPieceArray.append(currentLiftedPiece)
                view.addSubview(renderVisualPiece(pieceParam: currentLiftedPiece, column: 3, row: rightPieceArray.count))
                currentLiftedPiece = 1000
            default:
                break
            }
            for subviewInCache in pieceCache.subviews{
                subviewInCache.removeFromSuperview()
            }
            
            for button in buttonList{
                button.isEnabled = true
            }
          
            if leftPieceArray.count == 0{
                leftButton.isEnabled = false
            }
            if middlePieceArray.count == 0{
                middleButton.isEnabled = false
            }
            if rightPieceArray.count == 0{
                rightButton.isEnabled = false
            }
            checkCompletion()
            
        }
        for button in buttonList{
            if button.currentImage == UIImage(named: "upwardArrow"){
                button.setImage(UIImage(named: "downwardArrow"), for: .normal)
            }else{
                button.setImage(UIImage(named: "upwardArrow"), for: .normal)
            }
        }
        
        
        
        
    }
    
    @objc func leftButtonAction(sender:UIButton){
        generalButtonAction(button: sender, column: 0)
    }
    
    @objc func middleButtonAction(sender:UIButton){
        generalButtonAction(button: sender, column: 1)
    }
    
    @objc func rightButtonAction(sender:UIButton){
        generalButtonAction(button: sender, column: 2)
    }

    func asyncAIShowStep(){
        self.timer = Timer.scheduledTimer(withTimeInterval: AISpeed, repeats: true, block: { (t) in
            
            if self.AICounter < self.leftSteps.count{
                self.updateDisplay(left: self.leftSteps[self.AICounter], middle: self.middleSteps[self.AICounter], right: self.rightSteps[self.AICounter])
                self.AICounter += 1
            }else{
                self.timer?.invalidate()
                self.AICounter = 0
            }
            
        })
    }
    
    func updateDisplay(left:Array<Int>,middle:Array<Int>,right:Array<Int>){
            for s in self.view.subviews{
                if let c = s.backgroundColor{
                    if self.availableColor.contains(c){
                        s.removeFromSuperview()
                    }
                }
            }
            var counter = 1
            if left.count > 0{
                for p in left{
                    self.view.addSubview(renderVisualPiece(pieceParam: p, column: 1, row: counter))
                    counter += 1
                }
                counter = 1
            }
            if middle.count > 0{
                for q in middle{
                    self.view.addSubview(renderVisualPiece(pieceParam: q, column: 2, row: counter))
                    counter += 1
                }
                counter = 1
            }
            if right.count > 0{
                for w in right{
                    self.view.addSubview(renderVisualPiece(pieceParam: w, column: 3, row: counter))
                    counter += 1
                }
                counter = 1
            }
    }
    
    @objc func plusButtonAction(sender:UIButton){
        plusMinusPiece(pm: 1)
    }
    
    @objc func minusButtonAction(sender:UIButton){
        plusMinusPiece(pm: 0)
    }
    
    func plusMinusPiece(pm:Int){
        minusButton.isEnabled = true
        plusButton.isEnabled = true
        if pm == 0{
            if self.numberOfPieces > 1{
                self.numberOfPieces -= 1
            }
            if self.numberOfPieces == 0{
                minusButton.isEnabled = false
            }
            self.resetGame()
        }else{
            if self.numberOfPieces < 10{
                self.numberOfPieces += 1
            }
            if self.numberOfPieces == 10{
                plusButton.isEnabled = false
            }
            self.resetGame()
        }
        if numberOfPieces > AIUpperBoundForSolving{
            AISpeedButton.isEnabled = false
            AISpeedButton.backgroundColor = #colorLiteral(red: 0.5999328494, green: 0.6000387073, blue: 0.5999261737, alpha: 1)
            AIStart.isEnabled = false
            AIStart.backgroundColor = #colorLiteral(red: 0.5999328494, green: 0.6000387073, blue: 0.5999261737, alpha: 1)
        }else{
            AISpeedButton.isEnabled = true
            AISpeedButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            AIStart.isEnabled = true
            AIStart.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        }
        self.numberOfPieceDisplay.text = "\(numberOfPieces) Layers"
    }
    
    
    func checkCompletion(){
        var successArray = [Int]()
        for index in 1...numberOfPieces{
            successArray.append(index)
        }
        if rightPieceArray == successArray {
            rightButton.isEnabled = false
            let alert = UIAlertController(title: "Wow!", message: "You successfully moved the Tower of Hanoi with \(stepCount) steps! Congratulations!", preferredStyle: .alert)
            let reset = UIAlertAction(title: "Reset", style: .destructive, handler: { (action) in
                self.resetGame()
            })
            let action = UIAlertAction(title: "Done", style: .default, handler: nil)
            alert.addAction(reset)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func resetGame(){
        let buttonList = [leftButton,middleButton,rightButton]
        self.timer?.invalidate()
        leftPieceArray = [Int]()
        middlePieceArray = [Int]()
        rightPieceArray = [Int]()
        leftSteps = [[Int]]()
        middleSteps = [[Int]]()
        rightSteps = [[Int]]()
        currentLiftedPiece = 1000
        stepCount = 0
        
        loadGame(PieceNum: numberOfPieces)
        for b in buttonList{
            b.setImage(UIImage(named:"upwardArrow"), for: .normal)
        }
        
        for v in self.view.subviews{
            if let c = v.backgroundColor{
                if availableColor.contains(c){
                v.removeFromSuperview()
                }
            }
        }
        for anotherV in self.pieceCache.subviews{
            anotherV.removeFromSuperview()
        }
        for index in leftPieceArray{
            view.addSubview(renderVisualPiece(pieceParam: index, column: 1, row: index))
        }
        
        
        
        leftButton.isEnabled = true
        middleButton.isEnabled = false
        rightButton.isEnabled = false
        
    }
    
    @objc func resetButtonAction(sender:UIButton){
        self.resetGame()
    }
    
    // AI Stack
    
    @objc func changeAISpeed(sender:UIButton){
        timer?.invalidate()
        resetGame()
        leftButton.isEnabled = false
        if AISpeed == 0.5{
            AISpeedButton.setTitle("Slow Down AI", for: .normal)
            AISpeed = 0.1
            solve(layer: numberOfPieces, left: 0, middle: 1, right: 2)
            asyncAIShowStep()
        }else{
            AISpeedButton.setTitle("Speed Up AI", for: .normal)
            AISpeed = 0.5
            solve(layer: numberOfPieces, left: 0, middle: 1, right: 2)
            asyncAIShowStep()
        }
    }
    
    func move(from:Int,to:Int){
        var popped = 1000
        switch from{
        case 0:
            popped = leftPieceArray.popLast()!
        case 1:
            popped = middlePieceArray.popLast()!
        case 2:
            popped = rightPieceArray.popLast()!
        default:
            break
        }
        switch to{
        case 0:
            leftPieceArray.append(popped)
        case 1:
            middlePieceArray.append(popped)
        case 2:
            rightPieceArray.append(popped)
        default:
            break
        }
        leftSteps.append(leftPieceArray)
        middleSteps.append(middlePieceArray)
        rightSteps.append(rightPieceArray)
    }
    
    func solve(layer:Int,left:Int,middle:Int,right:Int){
        if layer == 1{
            move(from: left, to: right)
        }else{
            solve(layer: layer - 1, left: left, middle: right, right: middle)
            solve(layer: 1, left: left, middle: middle, right: right)
            solve(layer: layer - 1, left: middle, middle: left, right: right)
        }
    }
    
    @objc func printSolve(sender:UIButton){
        resetGame()
        solve(layer: numberOfPieces, left: 0, middle: 1, right: 2)
        leftButton.isEnabled = false
        asyncAIShowStep()
    }
    
}

PlaygroundPage.current.liveView = MyViewController()

// Created By Weiran Du
