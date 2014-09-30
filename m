Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaI3Gbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:31:32 -0400
Received: from mail-bl2on0085.outbound.protection.outlook.com ([65.55.169.85]:32655
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751131AbaI3Gba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:31:30 -0400
X-Greylist: delayed 2011 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Sep 2014 02:31:29 EDT
From: <hliang1025@gmail.com>
To: <peppe.cavallaro@st.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <adi-linux-docs@lists.sourceforge.net>,
        Hao Liang <hliang1025@gmail.com>
Subject: [PATCH] net: ethernet : stmicro: fixed power suspend and resume failure in stmmac driver
Date: Tue, 30 Sep 2014 13:55:34 +0800
Message-ID: <1412056534-7995-1-git-send-email-hliang1025@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130565302762701242;(52f37747-95c3-483a-bd05-08d153b03fac);()
X-Forefront-Antispam-Report: CIP:137.71.25.57;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(2351001)(55446002)(77156001)(110136001)(104166001)(50466002)(229853001)(102836001)(4396001)(87792001)(50986999)(120916001)(61266001)(50226001)(48376002)(107046002)(47776003)(85306004)(89996001)(87936001)(21056001)(99396003)(105596002)(64706001)(33646002)(88136002)(19580405001)(19580395003)(31966008)(93916002)(73392002)(62966002)(81442002)(73972006)(36756003)(46102003)(6806004)(95666004)(80022003)(86362001)(92726001)(44976005)(20776003)(85852003)(82202001)(86152002)(106466001)(92566001)(87286001)(10300001)(83322999);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB1015;H:nwd2mta2.analog.com;FPR:;MLV:sfv;PTR:nwd2mail11.analog.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB1015;
X-Forefront-PRVS: 0350D7A55D
Authentication-Results: spf=softfail (sender IP is 137.71.25.57)
 smtp.mailfrom=hliang1025@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hao Liang <hliang1025@gmail.com>

This is the fix for a power management issue caused by suspend and resume function in stmmac_main.c.
After enable CONFIG_DEBUG_ATOMIC_SLEEP which enable sleep-inside atomic section checking, power
managemet can not work normally. Board couldn't wakeup successfully after suspend. Command
"echo mem > /sys/power/state" suspend the board.

In suspend and resume function of stmmac driver, there are some sleep-inside function in atomic section
created by spin lock. These functions will causes system warnings and wakeup issue when enable
CONFIG_DEBUG_ATOMIC_SLEEP.

This bug was fixed by:
* replace some sleep function with non-sleep function
  clk_disable_unprepare -> clk_disable ...
* decrease the atomic area created by spin lock function. The original atomic area in resume function is
too large.

Signed-off-by: Hao Liang <hliang1025@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6e6ee22..2effbfe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2924,9 +2924,8 @@ int stmmac_suspend(struct net_device *ndev)
 	if (priv->phydev)
 		phy_stop(priv->phydev);
 
-	spin_lock_irqsave(&priv->lock, flags);
-
 	netif_device_detach(ndev);
+
 	netif_stop_queue(ndev);
 
 	napi_disable(&priv->napi);
@@ -2935,6 +2934,8 @@ int stmmac_suspend(struct net_device *ndev)
 	priv->hw->dma->stop_tx(priv->ioaddr);
 	priv->hw->dma->stop_rx(priv->ioaddr);
 
+	spin_lock_irqsave(&priv->lock, flags);
+
 	stmmac_clear_descriptors(priv);
 
 	/* Enable Power down mode by programming the PMT regs */
@@ -2945,7 +2946,7 @@ int stmmac_suspend(struct net_device *ndev)
 		stmmac_set_mac(priv->ioaddr, false);
 		pinctrl_pm_select_sleep_state(priv->device);
 		/* Disable clock in case of PWM is off */
-		clk_disable_unprepare(priv->stmmac_clk);
+		clk_disable(priv->stmmac_clk);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -2977,12 +2978,14 @@ int stmmac_resume(struct net_device *ndev)
 	} else {
 		pinctrl_pm_select_default_state(priv->device);
 		/* enable the clk prevously disabled */
-		clk_prepare_enable(priv->stmmac_clk);
+		clk_enable(priv->stmmac_clk);
 		/* reset the phy so that it's ready */
 		if (priv->mii)
 			stmmac_mdio_reset(priv->mii);
 	}
 
+	spin_unlock_irqrestore(&priv->lock, flags);
+
 	netif_device_attach(ndev);
 
 	stmmac_hw_setup(ndev);
@@ -2991,8 +2994,6 @@ int stmmac_resume(struct net_device *ndev)
 
 	netif_start_queue(ndev);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	if (priv->phydev)
 		phy_start(priv->phydev);
 
-- 
1.7.9.5

