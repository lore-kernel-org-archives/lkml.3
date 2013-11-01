Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3KATsC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:48:02 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41693 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab3KATqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:46:22 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v2 5/9] usb: gadget: s3c-hsotg: enable generic phy support
Date: Fri,  1 Nov 2013 15:45:54 -0400
Message-Id: <1383335158-19730-6-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383335158-19730-1-git-send-email-matt.porter@linaro.org>
References: <1383335158-19730-1-git-send-email-matt.porter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for the generic PHY subsystem. Generic PHY
support is probed and then the driver falls back to checking
for an old style USB PHY and pdata if not found.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
---
 drivers/usb/gadget/s3c-hsotg.c | 54 ++++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 3e0c124..f97978b 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -34,6 +34,7 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 #include <linux/usb/phy.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_data/s3c-hsotg.h>
 
 #include "s3c-hsotg.h"
@@ -131,7 +132,8 @@ struct s3c_hsotg_ep {
  * struct s3c_hsotg - driver state.
  * @dev: The parent device supplied to the probe function
  * @driver: USB gadget driver
- * @phy: The otg phy transceiver structure for phy control.
+ * @phy: The otg phy transceiver structure for old USB phy control.
+ * @gphy: The otg phy transceiver structure for generic phy control.
  * @plat: The platform specific configuration data. This can be removed once
  * all SoCs support usb transceiver.
  * @regs: The memory area mapped for accessing registers.
@@ -154,6 +156,7 @@ struct s3c_hsotg {
 	struct device		 *dev;
 	struct usb_gadget_driver *driver;
 	struct usb_phy		*phy;
+	struct phy		*gphy;
 	struct s3c_hsotg_plat	 *plat;
 
 	spinlock_t              lock;
@@ -2820,9 +2823,12 @@ static void s3c_hsotg_phy_enable(struct s3c_hsotg *hsotg)
 
 	dev_dbg(hsotg->dev, "pdev 0x%p\n", pdev);
 
-	if (hsotg->phy)
+	if (hsotg->gphy) {
+		phy_init(hsotg->gphy);
+		phy_power_on(hsotg->gphy);
+	} else if (hsotg->phy) {
 		usb_phy_init(hsotg->phy);
-	else if (hsotg->plat->phy_init)
+	} else if (hsotg->plat->phy_init)
 		hsotg->plat->phy_init(pdev, hsotg->plat->phy_type);
 }
 
@@ -2837,9 +2843,12 @@ static void s3c_hsotg_phy_disable(struct s3c_hsotg *hsotg)
 {
 	struct platform_device *pdev = to_platform_device(hsotg->dev);
 
-	if (hsotg->phy)
+	if (hsotg->gphy) {
+		phy_power_off(hsotg->gphy);
+		phy_exit(hsotg->gphy);
+	} else if (hsotg->phy) {
 		usb_phy_shutdown(hsotg->phy);
-	else if (hsotg->plat->phy_exit)
+	} else if (hsotg->plat->phy_exit)
 		hsotg->plat->phy_exit(pdev, hsotg->plat->phy_type);
 }
 
@@ -3446,6 +3455,7 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 {
 	struct s3c_hsotg_plat *plat = dev_get_platdata(&pdev->dev);
 	struct usb_phy *phy;
+	struct phy *gphy;
 	struct device *dev = &pdev->dev;
 	struct s3c_hsotg_ep *eps;
 	struct s3c_hsotg *hsotg;
@@ -3460,19 +3470,27 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
-	if (IS_ERR(phy)) {
-		/* Fallback for pdata */
-		plat = dev_get_platdata(&pdev->dev);
-		if (!plat) {
-			dev_err(&pdev->dev, "no platform data or transceiver defined\n");
-			return -EPROBE_DEFER;
-		} else {
-			hsotg->plat = plat;
-		}
-	} else {
-		hsotg->phy = phy;
-	}
+	/*
+	 * Attempt to find a generic PHY, then look for an old style
+	 *  USB PHY, finally fall back to pdata
+	 */
+	gphy = devm_phy_get(dev, "usb2-phy");
+	if (IS_ERR(gphy)) {
+		phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+		if (IS_ERR(phy)) {
+			/* Fallback for pdata */
+			plat = dev_get_platdata(&pdev->dev);
+			if (!plat) {
+				dev_err(&pdev->dev,
+					"no platform data or transceiver defined\n");
+				return -EPROBE_DEFER;
+			} else {
+				hsotg->plat = plat;
+			}
+		} else
+			hsotg->phy = phy;
+	} else
+		hsotg->gphy = gphy;
 
 	hsotg->dev = dev;
 
-- 
1.8.4

