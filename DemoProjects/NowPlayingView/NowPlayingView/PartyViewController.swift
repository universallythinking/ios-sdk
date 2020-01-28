//
//  PartyViewController.swift
//  SPTLoginSampleAppSwift
//
//  Created by Benjamin Barnett on 1/25/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class PartyViewController: UIViewController, WKNavigationDelegate {
    
    var partyName = ""
    open lazy var webView: WKWebView = {
        DispatchQueue.main.sync {
            return WKWebView()
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    func setupWebViews() {
        webView = WKWebView()
        let webProcessPool = WKProcessPool()
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.processPool = webProcessPool
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), configuration: webViewConfig)
        webView.navigationDelegate = self
        self.tabBarController!.tabBar.isHidden=true
        addWebView()
        /*
        let webViewPlayerConfig = WKWebViewConfiguration()
        webViewPlayerConfig.processPool = webProcessPool
        webViewPlayer = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), configuration: webViewPlayerConfig)
        */
    }
    
    func addWebView() {
     /*
        let urlStringPlayer = "https://swaggerwebplayer.herokuapp.com/indexTest.html";
        let requestPlayer = URLRequest(url:URL(string: urlStringPlayer)!)
        webViewPlayer.load(requestPlayer)
        self.view.addSubview(webViewPlayer)
        let urlString = "https://paywallios.herokuapp.com/authIOS";
        let request = URLRequest(url:URL(string: urlString)!)
        //webView.load(request)
     */
        let url = Bundle.main.url(forResource: "app4", withExtension: "html", subdirectory: "public")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
        self.view.addSubview(webView)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var url = ""
        let vc = ViewController()
        if navigationAction.request.url?.absoluteString != nil {
            let currentUrl = navigationAction.request.url!.absoluteString
            if (urlContains(str: "getRolling:::", url: currentUrl)) {
                url = navigationAction.request.url!.absoluteString
                let partyNameParsed = url.components(separatedBy: ":::")
                partyName = partyNameParsed[1]
                findParty()
            } else if (urlContains(str: "prev", url: currentUrl)) {
                vc.skipPrevious()
            } else if (urlContains(str: "pause", url: currentUrl)) {
                vc.playPause()
            } else if (urlContains(str: "/song/", url: currentUrl)) {
                url = navigationAction.request.url!.absoluteString
                let str = url.components(separatedBy: "/song/")
                let song = str[1].components(separatedBy: ":::")[0]
                vc.playSong(song: song)
            } else if (urlContains(str: "terminate", url: currentUrl)) {

            } else if (urlContains(str: "softterminate", url: currentUrl)) {

            }
        }
        decisionHandler(.allow)
    }
    
    
    func urlContains(str: String, url: String) -> Bool {
        return url.range(of: str) != nil
    }
    
    func getUrl() -> String {
        return webView.url!.absoluteString
    }
    
    func findParty() {
        let url = Bundle.main.url(forResource: "find", withExtension: "html", subdirectory: "public")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url);
        webView.load(request)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.findPartyWithCode), userInfo: nil, repeats: false)
    }
    
    @objc func findPartyWithCode() {
        let findParty = "findParty('" + partyName + "')"
        webView.evaluateJavaScript(findParty, completionHandler: nil)
    }
    
    @objc func increment() {
        let increment = "increment(1)"
        webView.evaluateJavaScript(increment, completionHandler: nil)
    }
    
}
