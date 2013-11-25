Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3KYKDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:03:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48349 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab3KYKDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:03:00 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: [PATCH v3 05/10] usb: dwc3: adapt dwc3 core to use Generic PHY Framework
Date: Mon, 25 Nov 2013 15:31:25 +0530
Message-ID: <1385373690-12170-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385373690-12170-1-git-send-email-kishon@ti.com>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapted dwc3 core to use the Generic PHY Framework. So for init, exit,
power_on and power_off the following APIs are used phy_init(), phy_exit(),
phy_power_on() and phy_power_off().

However using the old USB phy library wont be removed till the PHYs of all
other SoC's using dwc3 core is adapted to the Generic PHY Framework.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/usb/dwc3.txt |    6 ++-
 drivers/usb/dwc3/Kconfig                       |    1 +
 drivers/usb/dwc3/core.c                        |   66 +++++++++++++++++++++---
 drivers/usb/dwc3/core.h                        |    7 +++
 4 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
index e807635..471366d 100644
--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -6,11 +6,13 @@ Required properties:
  - compatible: must be "snps,dwc3"
  - reg : Address and length of the register set for the device
  - interrupts: Interrupts used by the dwc3 controller.
+
+Optional properties:
  - usb-phy : array of phandle for the PHY device.  The first element
    in the array is expected to be a handle to the USB2/HS PHY and
    the second element is expected to be a handle to the USB3/SS PHY
-
-Optional properties:
+ - phys: from the *Generic PHY* bindings
+ - phy-names: from the *Generic PHY* bindings
  - tx-fifo-resize: determines if the FIFO *has* to be reallocated.
 
 This is usually a subnode to DWC3 glue to which it is connected.
diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 8e385b4..64eed6f 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -2,6 +2,7 @@ config USB_DWC3
 	tristate "DesignWare USB3 DRD Core Support"
 	depends on (USB || USB_GADGET) && HAS_DMA
 	select USB_PHY
+	select GENERIC_PHY
 	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
 	help
 	  Say Y or M here if your system has a Dual Role SuperSpeed
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index f20f4a1..628b372 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -85,6 +85,12 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
 		usb_phy_init(dwc->usb2_phy);
 	if (!IS_ERR(dwc->usb3_phy))
 		usb_phy_init(dwc->usb3_phy);
+
+	if (!IS_ERR(dwc->usb2_generic_phy))
+		phy_init(dwc->usb2_generic_phy);
+	if (!IS_ERR(dwc->usb3_generic_phy))
+		phy_init(dwc->usb3_generic_phy);
+
 	mdelay(100);
 
 	/* Clear USB3 PHY reset */
@@ -348,6 +354,12 @@ static void dwc3_core_exit(struct dwc3 *dwc)
 		usb_phy_shutdown(dwc->usb2_phy);
 	if (!IS_ERR(dwc->usb3_phy))
 		usb_phy_shutdown(dwc->usb3_phy);
+
+	if (!IS_ERR(dwc->usb2_generic_phy))
+		phy_power_off(dwc->usb2_generic_phy);
+	if (!IS_ERR(dwc->usb3_generic_phy))
+		phy_power_off(dwc->usb3_generic_phy);
+
 }
 
 #define DWC3_ALIGN_MASK		(16 - 1)
@@ -417,26 +429,34 @@ static int dwc3_probe(struct platform_device *pdev)
 		if (dwc_data)
 			dwc->quirks = dwc_data->quirks;
 
-		if (!(dwc->quirks & DWC3_QUIRK_NO_USB2_PHY))
+		if (!(dwc->quirks & DWC3_QUIRK_NO_USB2_PHY)) {
+			dwc->usb2_generic_phy = devm_phy_get(dev, "usb2-phy");
 			dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev,
 				"usb-phy", 0);
+		}
 
-		if (!(dwc->quirks & DWC3_QUIRK_NO_USB3_PHY))
+		if (!(dwc->quirks & DWC3_QUIRK_NO_USB3_PHY)) {
+			dwc->usb3_generic_phy = devm_phy_get(dev, "usb3-phy");
 			dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev,
 				"usb-phy", 1);
+		}
 
 		dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
 		dwc->dr_mode = of_usb_get_dr_mode(node);
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
 
-		if (!(pdata->quirks & DWC3_QUIRK_NO_USB2_PHY))
+		if (!(pdata->quirks & DWC3_QUIRK_NO_USB2_PHY)) {
+			dwc->usb2_generic_phy = devm_phy_get(dev, "usb2-phy");
 			dwc->usb2_phy = devm_usb_get_phy(dev,
 				USB_PHY_TYPE_USB2);
+		}
 
-		if (!(pdata->quirks & DWC3_QUIRK_NO_USB3_PHY))
+		if (!(pdata->quirks & DWC3_QUIRK_NO_USB3_PHY)) {
+			dwc->usb3_generic_phy = devm_phy_get(dev, "usb3-phy");
 			dwc->usb3_phy = devm_usb_get_phy(dev,
 				USB_PHY_TYPE_USB3);
+		}
 
 		dwc->needs_fifo_resize = pdata->tx_fifo_resize;
 		dwc->dr_mode = pdata->dr_mode;
@@ -445,14 +465,20 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->usb3_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
 	}
 
-	if (IS_ERR(dwc->usb2_phy)) {
+	if (IS_ERR(dwc->usb2_phy) && IS_ERR(dwc->usb2_generic_phy)) {
 		dev_err(dev, "usb2 phy not found\n");
-		return PTR_ERR(dwc->usb2_phy);
+		if (PTR_ERR(dwc->usb2_generic_phy) == -EPROBE_DEFER ||
+			PTR_ERR(dwc->usb2_phy) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		return -ENODEV;
 	}
 
-	if (IS_ERR(dwc->usb3_phy)) {
+	if (IS_ERR(dwc->usb3_phy) && IS_ERR(dwc->usb3_generic_phy)) {
 		dev_err(dev, "usb3 phy not found\n");
-		return PTR_ERR(dwc->usb3_phy);
+		if (PTR_ERR(dwc->usb3_generic_phy) == -EPROBE_DEFER ||
+			PTR_ERR(dwc->usb3_phy) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		return -ENODEV;
 	}
 
 	/* default to superspeed if no maximum_speed passed */
@@ -510,6 +536,11 @@ static int dwc3_probe(struct platform_device *pdev)
 	if (!IS_ERR(dwc->usb3_phy))
 		usb_phy_set_suspend(dwc->usb3_phy, 0);
 
+	if (!IS_ERR(dwc->usb2_generic_phy))
+		phy_power_on(dwc->usb2_generic_phy);
+	if (!IS_ERR(dwc->usb3_generic_phy))
+		phy_power_on(dwc->usb3_generic_phy);
+
 	ret = dwc3_event_buffers_setup(dwc);
 	if (ret) {
 		dev_err(dwc->dev, "failed to setup event buffers\n");
@@ -595,6 +626,10 @@ err1:
 		usb_phy_set_suspend(dwc->usb2_phy, 1);
 	if (!IS_ERR(dwc->usb3_phy))
 		usb_phy_set_suspend(dwc->usb3_phy, 1);
+	if (!IS_ERR(dwc->usb2_generic_phy))
+		phy_power_off(dwc->usb2_generic_phy);
+	if (!IS_ERR(dwc->usb3_generic_phy))
+		phy_power_off(dwc->usb3_generic_phy);
 	dwc3_core_exit(dwc);
 
 err0:
@@ -612,6 +647,11 @@ static int dwc3_remove(struct platform_device *pdev)
 	if (!IS_ERR(dwc->usb3_phy))
 		usb_phy_set_suspend(dwc->usb3_phy, 1);
 
+	if (!IS_ERR(dwc->usb2_generic_phy))
+		phy_power_off(dwc->usb2_generic_phy);
+	if (!IS_ERR(dwc->usb3_generic_phy))
+		phy_power_off(dwc->usb3_generic_phy);
+
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
@@ -711,6 +751,11 @@ static int dwc3_suspend(struct device *dev)
 	if (!IS_ERR(dwc->usb2_phy))
 		usb_phy_shutdown(dwc->usb2_phy);
 
+	if (!IS_ERR(dwc->usb2_generic_phy))
+		phy_exit(dwc->usb2_generic_phy);
+	if (!IS_ERR(dwc->usb3_generic_phy))
+		phy_exit(dwc->usb3_generic_phy);
+
 	return 0;
 }
 
@@ -724,6 +769,11 @@ static int dwc3_resume(struct device *dev)
 	if (!IS_ERR(dwc->usb2_phy))
 		usb_phy_init(dwc->usb2_phy);
 
+	if (!IS_ERR(dwc->usb2_generic_phy))
+		phy_init(dwc->usb2_generic_phy);
+	if (!IS_ERR(dwc->usb3_generic_phy))
+		phy_init(dwc->usb3_generic_phy);
+
 	spin_lock_irqsave(&dwc->lock, flags);
 
 	dwc3_writel(dwc->regs, DWC3_GCTL, dwc->gctl);
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 1e11dd1..dd284ab 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -31,6 +31,8 @@
 #include <linux/usb/gadget.h>
 #include <linux/usb/otg.h>
 
+#include <linux/phy/phy.h>
+
 /* Global constants */
 #define DWC3_EP0_BOUNCE_SIZE	512
 #define DWC3_ENDPOINTS_NUM	32
@@ -617,6 +619,8 @@ struct dwc3_scratchpad_array {
  * @dr_mode: requested mode of operation
  * @usb2_phy: pointer to USB2 PHY
  * @usb3_phy: pointer to USB3 PHY
+ * @usb2_generic_phy: pointer to USB2 PHY
+ * @usb3_generic_phy: pointer to USB3 PHY
  * @dcfg: saved contents of DCFG register
  * @gctl: saved contents of GCTL register
  * @is_selfpowered: true when we are selfpowered
@@ -670,6 +674,9 @@ struct dwc3 {
 	struct usb_phy		*usb2_phy;
 	struct usb_phy		*usb3_phy;
 
+	struct phy		*usb2_generic_phy;
+	struct phy		*usb3_generic_phy;
+
 	void __iomem		*regs;
 	size_t			regs_size;
 
-- 
1.7.10.4

