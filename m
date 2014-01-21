Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaAUKMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:12:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37009 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbaAUKM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:12:26 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <george.cherian@ti.com>, <heikki.krogerus@linux.intel.com>,
        <rogerq@ti.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH v4 2/2] usb: dwc3: adapt dwc3 core to use Generic PHY Framework
Date: Tue, 21 Jan 2014 15:41:39 +0530
Message-ID: <1390299099-14764-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1390299099-14764-1-git-send-email-kishon@ti.com>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
 <1390299099-14764-1-git-send-email-kishon@ti.com>
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
Changes from v3:
* avoided using quirks

 Documentation/devicetree/bindings/usb/dwc3.txt |    6 ++-
 drivers/usb/dwc3/core.c                        |   60 ++++++++++++++++++++++++
 drivers/usb/dwc3/core.h                        |    7 +++
 3 files changed, 71 insertions(+), 2 deletions(-)

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
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index e009d4e..036d589 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -82,6 +82,11 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
 
 	usb_phy_init(dwc->usb2_phy);
 	usb_phy_init(dwc->usb3_phy);
+	if (dwc->usb2_generic_phy)
+		phy_init(dwc->usb2_generic_phy);
+	if (dwc->usb3_generic_phy)
+		phy_init(dwc->usb3_generic_phy);
+
 	mdelay(100);
 
 	/* Clear USB3 PHY reset */
@@ -343,6 +348,11 @@ static void dwc3_core_exit(struct dwc3 *dwc)
 {
 	usb_phy_shutdown(dwc->usb2_phy);
 	usb_phy_shutdown(dwc->usb3_phy);
+	if (dwc->usb2_generic_phy)
+		phy_exit(dwc->usb2_generic_phy);
+	if (dwc->usb3_generic_phy)
+		phy_exit(dwc->usb3_generic_phy);
+
 }
 
 #define DWC3_ALIGN_MASK		(16 - 1)
@@ -433,6 +443,32 @@ static int dwc3_probe(struct platform_device *pdev)
 		}
 	}
 
+	dwc->usb2_generic_phy = devm_phy_get(dev, "usb2-phy");
+	if (IS_ERR(dwc->usb2_generic_phy)) {
+		ret = PTR_ERR(dwc->usb2_generic_phy);
+		if (ret == -ENOSYS || ret == -ENODEV) {
+			dwc->usb2_generic_phy = NULL;
+		} else if (ret == -EPROBE_DEFER) {
+			return ret;
+		} else {
+			dev_err(dev, "no usb2 phy configured\n");
+			return ret;
+		}
+	}
+
+	dwc->usb3_generic_phy = devm_phy_get(dev, "usb3-phy");
+	if (IS_ERR(dwc->usb3_generic_phy)) {
+		ret = PTR_ERR(dwc->usb3_generic_phy);
+		if (ret == -ENOSYS || ret == -ENODEV) {
+			dwc->usb3_generic_phy = NULL;
+		} else if (ret == -EPROBE_DEFER) {
+			return ret;
+		} else {
+			dev_err(dev, "no usb3 phy configured\n");
+			return ret;
+		}
+	}
+
 	dwc->xhci_resources[0].start = res->start;
 	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
 					DWC3_XHCI_REGS_END;
@@ -482,6 +518,11 @@ static int dwc3_probe(struct platform_device *pdev)
 	usb_phy_set_suspend(dwc->usb2_phy, 0);
 	usb_phy_set_suspend(dwc->usb3_phy, 0);
 
+	if (dwc->usb2_generic_phy)
+		phy_power_on(dwc->usb2_generic_phy);
+	if (dwc->usb3_generic_phy)
+		phy_power_on(dwc->usb3_generic_phy);
+
 	ret = dwc3_event_buffers_setup(dwc);
 	if (ret) {
 		dev_err(dwc->dev, "failed to setup event buffers\n");
@@ -565,6 +606,10 @@ err2:
 err1:
 	usb_phy_set_suspend(dwc->usb2_phy, 1);
 	usb_phy_set_suspend(dwc->usb3_phy, 1);
+	if (dwc->usb2_generic_phy)
+		phy_power_off(dwc->usb2_generic_phy);
+	if (dwc->usb3_generic_phy)
+		phy_power_off(dwc->usb3_generic_phy);
 	dwc3_core_exit(dwc);
 
 err0:
@@ -580,6 +625,11 @@ static int dwc3_remove(struct platform_device *pdev)
 	usb_phy_set_suspend(dwc->usb2_phy, 1);
 	usb_phy_set_suspend(dwc->usb3_phy, 1);
 
+	if (dwc->usb2_generic_phy)
+		phy_power_off(dwc->usb2_generic_phy);
+	if (dwc->usb3_generic_phy)
+		phy_power_off(dwc->usb3_generic_phy);
+
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
@@ -677,6 +727,11 @@ static int dwc3_suspend(struct device *dev)
 	usb_phy_shutdown(dwc->usb3_phy);
 	usb_phy_shutdown(dwc->usb2_phy);
 
+	if (dwc->usb2_generic_phy)
+		phy_exit(dwc->usb2_generic_phy);
+	if (dwc->usb3_generic_phy)
+		phy_exit(dwc->usb3_generic_phy);
+
 	return 0;
 }
 
@@ -688,6 +743,11 @@ static int dwc3_resume(struct device *dev)
 	usb_phy_init(dwc->usb3_phy);
 	usb_phy_init(dwc->usb2_phy);
 
+	if (dwc->usb2_generic_phy)
+		phy_init(dwc->usb2_generic_phy);
+	if (dwc->usb3_generic_phy)
+		phy_init(dwc->usb3_generic_phy);
+
 	spin_lock_irqsave(&dwc->lock, flags);
 
 	dwc3_writel(dwc->regs, DWC3_GCTL, dwc->gctl);
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
 
-- 
1.7.10.4

