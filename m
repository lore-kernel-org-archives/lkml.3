Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab3FZJ3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:29:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47230 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab3FZJ3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:29:21 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH] usb: dwc3: core: continue probe even if usb3 phy is not available
Date: Wed, 26 Jun 2013 14:59:14 +0530
Message-ID: <1372238954-29047-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There can be configurations in which DWC3 is hoooked up only to USB2 PHY.
In such cases we should not return -EPROBE_DEFER, rather continue probe
even if there is no USB3 PHY.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/core.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index c35d49d..d5e6f3e 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -100,7 +100,9 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
 
 	usb_phy_init(dwc->usb2_phy);
-	usb_phy_init(dwc->usb3_phy);
+
+	if (dwc->usb3_phy)
+		usb_phy_init(dwc->usb3_phy);
 	mdelay(100);
 
 	/* Clear USB3 PHY reset */
@@ -360,7 +362,9 @@ err0:
 static void dwc3_core_exit(struct dwc3 *dwc)
 {
 	usb_phy_shutdown(dwc->usb2_phy);
-	usb_phy_shutdown(dwc->usb3_phy);
+
+	if (dwc->usb3_phy)
+		usb_phy_shutdown(dwc->usb3_phy);
 }
 
 #define DWC3_ALIGN_MASK		(16 - 1)
@@ -460,12 +464,19 @@ static int dwc3_probe(struct platform_device *pdev)
 		if (ret == -ENXIO)
 			return ret;
 
+		/*
+		 * In  some cases we wont have a USB3 PHY, in such cases
+		 * if we return EPROBE_DEFER we would never complete the
+		 * probe. Just print error and continue.
+		 */
 		dev_err(dev, "no usb3 phy configured\n");
-		return -EPROBE_DEFER;
+		dwc->usb3_phy = NULL;
 	}
 
 	usb_phy_set_suspend(dwc->usb2_phy, 0);
-	usb_phy_set_suspend(dwc->usb3_phy, 0);
+
+	if (dwc->usb3_phy)
+		usb_phy_set_suspend(dwc->usb3_phy, 0);
 
 	spin_lock_init(&dwc->lock);
 	platform_set_drvdata(pdev, dwc);
@@ -604,7 +615,9 @@ static int dwc3_remove(struct platform_device *pdev)
 	struct dwc3	*dwc = platform_get_drvdata(pdev);
 
 	usb_phy_set_suspend(dwc->usb2_phy, 1);
-	usb_phy_set_suspend(dwc->usb3_phy, 1);
+
+	if (dwc->usb3_phy)
+		usb_phy_set_suspend(dwc->usb3_phy, 1);
 
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -700,7 +713,9 @@ static int dwc3_suspend(struct device *dev)
 	dwc->gctl = dwc3_readl(dwc->regs, DWC3_GCTL);
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
-	usb_phy_shutdown(dwc->usb3_phy);
+	if (dwc->usb3_phy)
+		usb_phy_shutdown(dwc->usb3_phy);
+
 	usb_phy_shutdown(dwc->usb2_phy);
 
 	return 0;
@@ -711,7 +726,9 @@ static int dwc3_resume(struct device *dev)
 	struct dwc3	*dwc = dev_get_drvdata(dev);
 	unsigned long	flags;
 
-	usb_phy_init(dwc->usb3_phy);
+	if (dwc->usb3_phy)
+		usb_phy_init(dwc->usb3_phy);
+
 	usb_phy_init(dwc->usb2_phy);
 	msleep(100);
 
-- 
1.8.1.4

