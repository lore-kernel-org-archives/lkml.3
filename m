Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3LQTo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:44:57 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:39362 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3LQTm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:42:58 -0500
From: Matt Porter <mporter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v7 5/9] usb: gadget: s3c-hsotg: enable generic phy support
Date: Tue, 17 Dec 2013 14:42:32 -0500
Message-Id: <1387309356-17195-6-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1387309356-17195-1-git-send-email-mporter@linaro.org>
References: <1387309356-17195-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for the generic PHY subsystem. Generic PHY
support is probed and then the driver falls back to checking
for an old style USB PHY and pdata if not found.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
 drivers/usb/gadget/s3c-hsotg.c | 55 ++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index cbfbf41..8f9bcdb 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -30,6 +30,8 @@
 #include <linux/clk.h>
 #include <linux/regulator/consumer.h>
 #include <linux/of_platform.h>
+#include <linux/phy/phy.h>
+#include <linux/usb/phy.h>
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
@@ -138,6 +140,7 @@ struct s3c_hsotg_ep {
  * @dev: The parent device supplied to the probe function
  * @driver: USB gadget driver
  * @phy: The otg phy transceiver structure for phy control.
+ * @uphy: The otg phy transceiver structure for old USB phy control.
  * @plat: The platform specific configuration data. This can be removed once
  * all SoCs support usb transceiver.
  * @regs: The memory area mapped for accessing registers.
@@ -159,7 +162,8 @@ struct s3c_hsotg_ep {
 struct s3c_hsotg {
 	struct device		 *dev;
 	struct usb_gadget_driver *driver;
-	struct usb_phy		*phy;
+	struct phy		 *phy;
+	struct usb_phy		 *uphy;
 	struct s3c_hsotg_plat	 *plat;
 
 	spinlock_t              lock;
@@ -2901,8 +2905,11 @@ static void s3c_hsotg_phy_enable(struct s3c_hsotg *hsotg)
 
 	dev_dbg(hsotg->dev, "pdev 0x%p\n", pdev);
 
-	if (hsotg->phy)
-		usb_phy_init(hsotg->phy);
+	if (hsotg->phy) {
+		phy_init(hsotg->phy);
+		phy_power_on(hsotg->phy);
+	} else if (hsotg->uphy)
+		usb_phy_init(hsotg->uphy);
 	else if (hsotg->plat->phy_init)
 		hsotg->plat->phy_init(pdev, hsotg->plat->phy_type);
 }
@@ -2918,8 +2925,11 @@ static void s3c_hsotg_phy_disable(struct s3c_hsotg *hsotg)
 {
 	struct platform_device *pdev = to_platform_device(hsotg->dev);
 
-	if (hsotg->phy)
-		usb_phy_shutdown(hsotg->phy);
+	if (hsotg->phy) {
+		phy_power_off(hsotg->phy);
+		phy_exit(hsotg->phy);
+	} else if (hsotg->uphy)
+		usb_phy_shutdown(hsotg->uphy);
 	else if (hsotg->plat->phy_exit)
 		hsotg->plat->phy_exit(pdev, hsotg->plat->phy_type);
 }
@@ -3526,7 +3536,8 @@ static void s3c_hsotg_delete_debug(struct s3c_hsotg *hsotg)
 static int s3c_hsotg_probe(struct platform_device *pdev)
 {
 	struct s3c_hsotg_plat *plat = dev_get_platdata(&pdev->dev);
-	struct usb_phy *phy;
+	struct phy *phy;
+	struct usb_phy *uphy;
 	struct device *dev = &pdev->dev;
 	struct s3c_hsotg_ep *eps;
 	struct s3c_hsotg *hsotg;
@@ -3541,19 +3552,26 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+	/*
+	 * Attempt to find a generic PHY, then look for an old style
+	 * USB PHY, finally fall back to pdata
+	 */
+	phy = devm_phy_get(&pdev->dev, "usb2-phy");
 	if (IS_ERR(phy)) {
-		/* Fallback for pdata */
-		plat = dev_get_platdata(&pdev->dev);
-		if (!plat) {
-			dev_err(&pdev->dev, "no platform data or transceiver defined\n");
-			return -EPROBE_DEFER;
-		} else {
+		uphy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+		if (IS_ERR(uphy)) {
+			/* Fallback for pdata */
+			plat = dev_get_platdata(&pdev->dev);
+			if (!plat) {
+				dev_err(&pdev->dev,
+				"no platform data or transceiver defined\n");
+				return -EPROBE_DEFER;
+			}
 			hsotg->plat = plat;
-		}
-	} else {
+		} else
+			hsotg->uphy = uphy;
+	} else
 		hsotg->phy = phy;
-	}
 
 	hsotg->dev = dev;
 
@@ -3620,6 +3638,9 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 		goto err_supplies;
 	}
 
+	if (hsotg->phy)
+		phy_init(hsotg->phy);
+
 	/* usb phy enable */
 	s3c_hsotg_phy_enable(hsotg);
 
@@ -3713,6 +3734,8 @@ static int s3c_hsotg_remove(struct platform_device *pdev)
 	}
 
 	s3c_hsotg_phy_disable(hsotg);
+	if (hsotg->phy)
+		phy_exit(hsotg->phy);
 	clk_disable_unprepare(hsotg->clk);
 
 	return 0;
-- 
1.8.4

