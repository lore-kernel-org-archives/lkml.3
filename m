Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaCCLjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:39:31 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53486 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbaCCLj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:39:26 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <george.cherian@ti.com>,
        <heikki.krogerus@linux.intel.com>, <rogerq@ti.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: [PATCH v5 2/6] usb: dwc3: adapt dwc3 core to use Generic PHY Framework
Date: Mon, 3 Mar 2014 17:08:11 +0530
Message-ID: <1393846695-14644-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393846695-14644-1-git-send-email-kishon@ti.com>
References: <1393846695-14644-1-git-send-email-kishon@ti.com>
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
 Documentation/devicetree/bindings/usb/dwc3.txt |    6 +-
 drivers/usb/dwc3/core.c                        |   86 +++++++++++++++++++++---
 drivers/usb/dwc3/core.h                        |    7 ++
 3 files changed, 89 insertions(+), 10 deletions(-)

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
index 225a4d6..497234a 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -61,9 +61,10 @@ void dwc3_set_mode(struct dwc3 *dwc, u32 mode)
  * dwc3_core_soft_reset - Issues core soft reset and PHY reset
  * @dwc: pointer to our context structure
  */
-static void dwc3_core_soft_reset(struct dwc3 *dwc)
+static int dwc3_core_soft_reset(struct dwc3 *dwc)
 {
 	u32		reg;
+	int		ret;
 
 	/* Before Resetting PHY, put Core in Reset */
 	reg = dwc3_readl(dwc->regs, DWC3_GCTL);
@@ -82,6 +83,15 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
 
 	usb_phy_init(dwc->usb2_phy);
 	usb_phy_init(dwc->usb3_phy);
+	ret = phy_init(dwc->usb2_generic_phy);
+	if (ret < 0)
+		return ret;
+
+	ret = phy_init(dwc->usb3_generic_phy);
+	if (ret < 0) {
+		phy_exit(dwc->usb2_generic_phy);
+		return ret;
+	}
 	mdelay(100);
 
 	/* Clear USB3 PHY reset */
@@ -100,6 +110,8 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
 	reg = dwc3_readl(dwc->regs, DWC3_GCTL);
 	reg &= ~DWC3_GCTL_CORESOFTRESET;
 	dwc3_writel(dwc->regs, DWC3_GCTL, reg);
+
+	return 0;
 }
 
 /**
@@ -381,7 +393,9 @@ static int dwc3_core_init(struct dwc3 *dwc)
 		cpu_relax();
 	} while (true);
 
-	dwc3_core_soft_reset(dwc);
+	ret = dwc3_core_soft_reset(dwc);
+	if (ret)
+		goto err0;
 
 	reg = dwc3_readl(dwc->regs, DWC3_GCTL);
 	reg &= ~DWC3_GCTL_SCALEDOWN_MASK;
@@ -446,6 +460,8 @@ err2:
 err1:
 	usb_phy_shutdown(dwc->usb2_phy);
 	usb_phy_shutdown(dwc->usb3_phy);
+	phy_exit(dwc->usb2_generic_phy);
+	phy_exit(dwc->usb3_generic_phy);
 
 err0:
 	return ret;
@@ -453,14 +469,12 @@ err0:
 
 static void dwc3_core_exit(struct dwc3 *dwc)
 {
-	if (!IS_ERR(dwc->usb2_phy))
-		usb_phy_shutdown(dwc->usb2_phy);
-	if (!IS_ERR(dwc->usb3_phy))
-		usb_phy_shutdown(dwc->usb3_phy);
-
 	dwc3_free_scratch_buffers(dwc);
 	usb_phy_shutdown(dwc->usb2_phy);
 	usb_phy_shutdown(dwc->usb3_phy);
+	phy_exit(dwc->usb2_generic_phy);
+	phy_exit(dwc->usb3_generic_phy);
+
 }
 
 #define DWC3_ALIGN_MASK		(16 - 1)
@@ -551,6 +565,32 @@ static int dwc3_probe(struct platform_device *pdev)
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
@@ -607,11 +647,18 @@ static int dwc3_probe(struct platform_device *pdev)
 
 	usb_phy_set_suspend(dwc->usb2_phy, 0);
 	usb_phy_set_suspend(dwc->usb3_phy, 0);
+	ret = phy_power_on(dwc->usb2_generic_phy);
+	if (ret < 0)
+		goto err1;
+
+	ret = phy_power_on(dwc->usb3_generic_phy);
+	if (ret < 0)
+		goto err_usb2phy_power;
 
 	ret = dwc3_event_buffers_setup(dwc);
 	if (ret) {
 		dev_err(dwc->dev, "failed to setup event buffers\n");
-		goto err1;
+		goto err_usb3phy_power;
 	}
 
 	switch (dwc->dr_mode) {
@@ -680,6 +727,12 @@ err3:
 err2:
 	dwc3_event_buffers_cleanup(dwc);
 
+err_usb3phy_power:
+	phy_power_off(dwc->usb3_generic_phy);
+
+err_usb2phy_power:
+	phy_power_off(dwc->usb2_generic_phy);
+
 err1:
 	usb_phy_set_suspend(dwc->usb2_phy, 1);
 	usb_phy_set_suspend(dwc->usb3_phy, 1);
@@ -697,6 +750,8 @@ static int dwc3_remove(struct platform_device *pdev)
 
 	usb_phy_set_suspend(dwc->usb2_phy, 1);
 	usb_phy_set_suspend(dwc->usb3_phy, 1);
+	phy_power_off(dwc->usb2_generic_phy);
+	phy_power_off(dwc->usb3_generic_phy);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -794,6 +849,8 @@ static int dwc3_suspend(struct device *dev)
 
 	usb_phy_shutdown(dwc->usb3_phy);
 	usb_phy_shutdown(dwc->usb2_phy);
+	phy_exit(dwc->usb2_generic_phy);
+	phy_exit(dwc->usb3_generic_phy);
 
 	return 0;
 }
@@ -802,9 +859,17 @@ static int dwc3_resume(struct device *dev)
 {
 	struct dwc3	*dwc = dev_get_drvdata(dev);
 	unsigned long	flags;
+	int		ret;
 
 	usb_phy_init(dwc->usb3_phy);
 	usb_phy_init(dwc->usb2_phy);
+	ret = phy_init(dwc->usb2_generic_phy);
+	if (ret < 0)
+		return ret;
+
+	ret = phy_init(dwc->usb3_generic_phy);
+	if (ret < 0)
+		goto err_usb2phy_init;
 
 	spin_lock_irqsave(&dwc->lock, flags);
 
@@ -828,6 +893,11 @@ static int dwc3_resume(struct device *dev)
 	pm_runtime_enable(dev);
 
 	return 0;
+
+err_usb2phy_init:
+	phy_exit(dwc->usb2_generic_phy);
+
+	return ret;
 }
 
 static const struct dev_pm_ops dwc3_dev_pm_ops = {
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 00b0578..def4ebd 100644
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
@@ -619,6 +621,8 @@ struct dwc3_scratchpad_array {
  * @dr_mode: requested mode of operation
  * @usb2_phy: pointer to USB2 PHY
  * @usb3_phy: pointer to USB3 PHY
+ * @usb2_generic_phy: pointer to USB2 PHY
+ * @usb3_generic_phy: pointer to USB3 PHY
  * @dcfg: saved contents of DCFG register
  * @gctl: saved contents of GCTL register
  * @isoch_delay: wValue from Set Isochronous Delay request;
@@ -679,6 +683,9 @@ struct dwc3 {
 	struct usb_phy		*usb2_phy;
 	struct usb_phy		*usb3_phy;
 
+	struct phy		*usb2_generic_phy;
+	struct phy		*usb3_generic_phy;
+
 	void __iomem		*regs;
 	size_t			regs_size;
 
-- 
1.7.9.5

