Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaIXNsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:48:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55836 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbaIXNr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:47:57 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/22] usb: phy: twl4030-usb: Move code from twl4030_phy_power to the runtime PM calls
Date: Wed, 24 Sep 2014 19:17:10 +0530
Message-ID: <1411566440-19169-13-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411566440-19169-1-git-send-email-kishon@ti.com>
References: <1411566440-19169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

We don't need twl4030_phy_power() any longer now that we have
the runtime PM calls. Let's get rid of it as it's confusing.
No functional changes, just move the code and use res instead
of ret as we are not returning that value.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-twl4030-usb.c |   72 ++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 41 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index a292db0..519cc90 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -383,45 +383,6 @@ static void __twl4030_phy_power(struct twl4030_usb *twl, int on)
 	WARN_ON(twl4030_usb_write_verify(twl, PHY_PWR_CTRL, pwr) < 0);
 }
 
-static void twl4030_phy_power(struct twl4030_usb *twl, int on)
-{
-	int ret;
-
-	if (on) {
-		ret = regulator_enable(twl->usb3v1);
-		if (ret)
-			dev_err(twl->dev, "Failed to enable usb3v1\n");
-
-		ret = regulator_enable(twl->usb1v8);
-		if (ret)
-			dev_err(twl->dev, "Failed to enable usb1v8\n");
-
-		/*
-		 * Disabling usb3v1 regulator (= writing 0 to VUSB3V1_DEV_GRP
-		 * in twl4030) resets the VUSB_DEDICATED2 register. This reset
-		 * enables VUSB3V1_SLEEP bit that remaps usb3v1 ACTIVE state to
-		 * SLEEP. We work around this by clearing the bit after usv3v1
-		 * is re-activated. This ensures that VUSB3V1 is really active.
-		 */
-		twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB_DEDICATED2);
-
-		ret = regulator_enable(twl->usb1v5);
-		if (ret)
-			dev_err(twl->dev, "Failed to enable usb1v5\n");
-
-		__twl4030_phy_power(twl, 1);
-		twl4030_usb_write(twl, PHY_CLK_CTRL,
-				  twl4030_usb_read(twl, PHY_CLK_CTRL) |
-					(PHY_CLK_CTRL_CLOCKGATING_EN |
-						PHY_CLK_CTRL_CLK32K_EN));
-	} else {
-		__twl4030_phy_power(twl, 0);
-		regulator_disable(twl->usb1v5);
-		regulator_disable(twl->usb1v8);
-		regulator_disable(twl->usb3v1);
-	}
-}
-
 static int twl4030_usb_runtime_suspend(struct device *dev)
 {
 	struct twl4030_usb *twl = dev_get_drvdata(dev);
@@ -430,7 +391,10 @@ static int twl4030_usb_runtime_suspend(struct device *dev)
 	if (twl->asleep)
 		return 0;
 
-	twl4030_phy_power(twl, 0);
+	__twl4030_phy_power(twl, 0);
+	regulator_disable(twl->usb1v5);
+	regulator_disable(twl->usb1v8);
+	regulator_disable(twl->usb3v1);
 	twl->asleep = 1;
 
 	return 0;
@@ -439,12 +403,38 @@ static int twl4030_usb_runtime_suspend(struct device *dev)
 static int twl4030_usb_runtime_resume(struct device *dev)
 {
 	struct twl4030_usb *twl = dev_get_drvdata(dev);
+	int res;
 
 	dev_dbg(twl->dev, "%s\n", __func__);
 	if (!twl->asleep)
 		return 0;
 
-	twl4030_phy_power(twl, 1);
+	res = regulator_enable(twl->usb3v1);
+	if (res)
+		dev_err(twl->dev, "Failed to enable usb3v1\n");
+
+	res = regulator_enable(twl->usb1v8);
+	if (res)
+		dev_err(twl->dev, "Failed to enable usb1v8\n");
+
+	/*
+	 * Disabling usb3v1 regulator (= writing 0 to VUSB3V1_DEV_GRP
+	 * in twl4030) resets the VUSB_DEDICATED2 register. This reset
+	 * enables VUSB3V1_SLEEP bit that remaps usb3v1 ACTIVE state to
+	 * SLEEP. We work around this by clearing the bit after usv3v1
+	 * is re-activated. This ensures that VUSB3V1 is really active.
+	 */
+	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB_DEDICATED2);
+
+	res = regulator_enable(twl->usb1v5);
+	if (res)
+		dev_err(twl->dev, "Failed to enable usb1v5\n");
+
+	__twl4030_phy_power(twl, 1);
+	twl4030_usb_write(twl, PHY_CLK_CTRL,
+			  twl4030_usb_read(twl, PHY_CLK_CTRL) |
+			  (PHY_CLK_CTRL_CLOCKGATING_EN |
+			   PHY_CLK_CTRL_CLK32K_EN));
 	twl->asleep = 0;
 
 	return 0;
-- 
1.7.9.5

