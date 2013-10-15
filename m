Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab3JOT5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:57:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45586 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759606Ab3JOTzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:55:31 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <grant.likely@linaro.org>,
        <s.nawrocki@samsung.com>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v2 2/7] usb: dwc3: adapt dwc3 core to use Generic PHY Framework
Date: Wed, 16 Oct 2013 01:24:12 +0530
Message-ID: <1381866857-3861-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1381866857-3861-1-git-send-email-kishon@ti.com>
References: <1381866857-3861-1-git-send-email-kishon@ti.com>
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
 drivers/usb/dwc3/core.c                        |   52 ++++++++++++++++++++++++
 drivers/usb/dwc3/core.h                        |    7 ++++
 drivers/usb/dwc3/platform_data.h               |    2 +
 5 files changed, 66 insertions(+), 2 deletions(-)

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
index cb91d70..28bfa5b 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -82,6 +82,12 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
 
 	usb_phy_init(dwc->usb2_phy);
 	usb_phy_init(dwc->usb3_phy);
+
+	if (dwc->usb2_generic_phy)
+		phy_init(dwc->usb2_generic_phy);
+	if (dwc->usb3_generic_phy)
+		phy_init(dwc->usb3_generic_phy);
+
 	mdelay(100);
 
 	/* Clear USB3 PHY reset */
@@ -343,6 +349,11 @@ static void dwc3_core_exit(struct dwc3 *dwc)
 {
 	usb_phy_shutdown(dwc->usb2_phy);
 	usb_phy_shutdown(dwc->usb3_phy);
+
+	if (dwc->usb2_generic_phy)
+		phy_power_off(dwc->usb2_generic_phy);
+	if (dwc->usb3_generic_phy)
+		phy_power_off(dwc->usb3_generic_phy);
 }
 
 #define DWC3_ALIGN_MASK		(16 - 1)
@@ -439,6 +450,26 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->usb3_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
 	}
 
+	count = of_property_match_string(node, "phy-names", "usb2-phy");
+	if (count >= 0 || (pdata && pdata->usb2_generic_phy)) {
+		dwc->usb2_generic_phy = devm_phy_get(dev, "usb2-phy");
+		if (IS_ERR(dwc->usb2_generic_phy)) {
+			dev_err(dev, "no usb2 phy configured yet");
+			return PTR_ERR(dwc->usb2_generic_phy);
+		}
+		dwc->usb2_phy = NULL;
+	}
+
+	count = of_property_match_string(node, "phy-names", "usb3-phy");
+	if (count >= 0 || (pdata && pdata->usb3_generic_phy)) {
+		dwc->usb3_generic_phy = devm_phy_get(dev, "usb3-phy");
+		if (IS_ERR(dwc->usb3_generic_phy)) {
+			dev_err(dev, "no usb3 phy configured yet");
+			return PTR_ERR(dwc->usb3_generic_phy);
+		}
+		dwc->usb3_phy = NULL;
+	}
+
 	/* default to superspeed if no maximum_speed passed */
 	if (dwc->maximum_speed == USB_SPEED_UNKNOWN)
 		dwc->maximum_speed = USB_SPEED_SUPER;
@@ -462,6 +493,11 @@ static int dwc3_probe(struct platform_device *pdev)
 	usb_phy_set_suspend(dwc->usb2_phy, 0);
 	usb_phy_set_suspend(dwc->usb3_phy, 0);
 
+	if (dwc->usb2_generic_phy)
+		phy_power_on(dwc->usb2_generic_phy);
+	if (dwc->usb3_generic_phy)
+		phy_power_on(dwc->usb3_generic_phy);
+
 	spin_lock_init(&dwc->lock);
 	platform_set_drvdata(pdev, dwc);
 
@@ -588,6 +624,11 @@ static int dwc3_remove(struct platform_device *pdev)
 	usb_phy_set_suspend(dwc->usb2_phy, 1);
 	usb_phy_set_suspend(dwc->usb3_phy, 1);
 
+	if (dwc->usb2_generic_phy)
+		phy_power_off(dwc->usb2_generic_phy);
+	if (dwc->usb3_generic_phy)
+		phy_power_off(dwc->usb3_generic_phy);
+
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
@@ -685,6 +726,11 @@ static int dwc3_suspend(struct device *dev)
 	usb_phy_shutdown(dwc->usb3_phy);
 	usb_phy_shutdown(dwc->usb2_phy);
 
+	if (dwc->usb2_generic_phy)
+		phy_exit(dwc->usb2_generic_phy);
+	if (dwc->usb3_generic_phy)
+		phy_exit(dwc->usb3_generic_phy);
+
 	return 0;
 }
 
@@ -695,6 +741,12 @@ static int dwc3_resume(struct device *dev)
 
 	usb_phy_init(dwc->usb3_phy);
 	usb_phy_init(dwc->usb2_phy);
+
+	if (dwc->usb2_generic_phy)
+		phy_init(dwc->usb2_generic_phy);
+	if (dwc->usb3_generic_phy)
+		phy_init(dwc->usb3_generic_phy);
+
 	msleep(100);
 
 	spin_lock_irqsave(&dwc->lock, flags);
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index f8af8d4..01ec7d7 100644
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
@@ -613,6 +615,8 @@ struct dwc3_scratchpad_array {
  * @dr_mode: requested mode of operation
  * @usb2_phy: pointer to USB2 PHY
  * @usb3_phy: pointer to USB3 PHY
+ * @usb2_generic_phy: pointer to USB2 PHY
+ * @usb3_generic_phy: pointer to USB3 PHY
  * @dcfg: saved contents of DCFG register
  * @gctl: saved contents of GCTL register
  * @is_selfpowered: true when we are selfpowered
@@ -665,6 +669,9 @@ struct dwc3 {
 	struct usb_phy		*usb2_phy;
 	struct usb_phy		*usb3_phy;
 
+	struct phy		*usb2_generic_phy;
+	struct phy		*usb3_generic_phy;
+
 	void __iomem		*regs;
 	size_t			regs_size;
 
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 49ffa6d..fc62a0f 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -26,4 +26,6 @@ struct dwc3_platform_data {
 	bool tx_fifo_resize;
 	bool usb2_phy;
 	bool usb3_phy;
+	bool usb2_generic_phy;
+	bool usb3_generic_phy;
 };
-- 
1.7.10.4

