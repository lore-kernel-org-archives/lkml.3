Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaLEMxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:53:07 -0500
Received: from lucky1.263xmail.com ([211.157.147.131]:50752 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaLEMxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:53:03 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <0e08369f35f5b4f7a36a7cc1ddd45c69>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Yunzhi Li <lyz@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: olof@lixom.net, huangtao@rock-chips.com, ulrich.prinz@googlemail.com,
        zyw@rock-chips.com, cf@rock-chips.com,
        linux-rockchip@lists.infradead.org, Yunzhi Li <lyz@rock-chips.com>,
        Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] usb: dwc2: Add generic PHY framework support for dwc2 usb controler platform driver.
Date: Fri,  5 Dec 2014 20:52:19 +0800
Message-Id: <1417783941-2418-4-git-send-email-lyz@rock-chips.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1417783941-2418-1-git-send-email-lyz@rock-chips.com>
References: <1417783941-2418-1-git-send-email-lyz@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get PHY parameters from devicetree and power off usb PHY during
system suspend.

Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
---

 drivers/usb/dwc2/gadget.c   | 33 ++++++++++++---------------------
 drivers/usb/dwc2/platform.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 200168e..2601c61 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3410,8 +3410,6 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
 {
 	struct device *dev = hsotg->dev;
 	struct s3c_hsotg_plat *plat = dev->platform_data;
-	struct phy *phy;
-	struct usb_phy *uphy;
 	struct s3c_hsotg_ep *eps;
 	int epnum;
 	int ret;
@@ -3421,30 +3419,23 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
 	hsotg->phyif = GUSBCFG_PHYIF16;
 
 	/*
-	 * Attempt to find a generic PHY, then look for an old style
-	 * USB PHY, finally fall back to pdata
+	 * If platform probe couldn't find a generic PHY or an old style
+	 * USB PHY, fall back to pdata
 	 */
-	phy = devm_phy_get(dev, "usb2-phy");
-	if (IS_ERR(phy)) {
-		uphy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
-		if (IS_ERR(uphy)) {
-			/* Fallback for pdata */
-			plat = dev_get_platdata(dev);
-			if (!plat) {
-				dev_err(dev,
-				"no platform data or transceiver defined\n");
-				return -EPROBE_DEFER;
-			}
-			hsotg->plat = plat;
-		} else
-			hsotg->uphy = uphy;
-	} else {
-		hsotg->phy = phy;
+	if (IS_ERR_OR_NULL(hsotg->phy) && IS_ERR_OR_NULL(hsotg->uphy)) {
+		plat = dev_get_platdata(dev);
+		if (!plat) {
+			dev_err(dev,
+			"no platform data or transceiver defined\n");
+			return -EPROBE_DEFER;
+		}
+		hsotg->plat = plat;
+	} else if (hsotg->phy) {
 		/*
 		 * If using the generic PHY framework, check if the PHY bus
 		 * width is 8-bit and set the phyif appropriately.
 		 */
-		if (phy_get_bus_width(phy) == 8)
+		if (phy_get_bus_width(hsotg->phy) == 8)
 			hsotg->phyif = GUSBCFG_PHYIF8;
 	}
 
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 6a795aa..739d14f 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -155,6 +155,8 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	struct dwc2_core_params defparams;
 	struct dwc2_hsotg *hsotg;
 	struct resource *res;
+	struct phy *phy;
+	struct usb_phy *uphy;
 	int retval;
 	int irq;
 
@@ -212,6 +214,24 @@ static int dwc2_driver_probe(struct platform_device *dev)
 
 	hsotg->dr_mode = of_usb_get_dr_mode(dev->dev.of_node);
 
+	/*
+	 * Attempt to find a generic PHY, then look for an old style
+	 * USB PHY
+	 */
+	phy = devm_phy_get(&dev->dev, "usb2-phy");
+	if (IS_ERR(phy)) {
+		hsotg->phy = NULL;
+		uphy = devm_usb_get_phy(&dev->dev, USB_PHY_TYPE_USB2);
+		if (IS_ERR(uphy))
+			hsotg->uphy = NULL;
+		else
+			hsotg->uphy = uphy;
+	} else {
+		hsotg->phy = phy;
+		phy_power_on(hsotg->phy);
+		phy_init(hsotg->phy);
+	}
+
 	spin_lock_init(&hsotg->lock);
 	mutex_init(&hsotg->init_mutex);
 	retval = dwc2_gadget_init(hsotg, irq);
@@ -233,6 +253,14 @@ static int __maybe_unused dwc2_suspend(struct device *dev)
 
 	if (dwc2_is_device_mode(dwc2))
 		ret = s3c_hsotg_suspend(dwc2);
+	else {
+		if (dwc2->lx_state == DWC2_L0)
+			return 0;
+		if (dwc2->phy) {
+			phy_exit(dwc2->phy);
+			phy_power_off(dwc2->phy);
+		}
+	}
 	return ret;
 }
 
@@ -243,6 +271,12 @@ static int __maybe_unused dwc2_resume(struct device *dev)
 
 	if (dwc2_is_device_mode(dwc2))
 		ret = s3c_hsotg_resume(dwc2);
+	else {
+		if (dwc2->phy) {
+			phy_power_on(dwc2->phy);
+			phy_init(dwc2->phy);
+		}
+	}
 	return ret;
 }
 
-- 
2.0.0


