Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab3CLKpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:45:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50411 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932519Ab3CLKp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:45:29 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 10/12] USB: ehci-omap: Add device tree support and binding information
Date: Tue, 12 Mar 2013 12:44:48 +0200
Message-ID: <1363085090-24676-11-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363085090-24676-1-git-send-email-rogerq@ti.com>
References: <1363085090-24676-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows the OMAP EHCI controller to be specified via device tree.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 .../devicetree/bindings/usb/ehci-omap.txt          |   32 +++++++++++++++++
 drivers/usb/host/ehci-omap.c                       |   37 +++++++++++++++++++-
 2 files changed, 68 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/ehci-omap.txt

diff --git a/Documentation/devicetree/bindings/usb/ehci-omap.txt b/Documentation/devicetree/bindings/usb/ehci-omap.txt
new file mode 100644
index 0000000..485a9a1
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ehci-omap.txt
@@ -0,0 +1,32 @@
+OMAP HS USB EHCI controller
+
+This device is usually the child of the omap-usb-host
+Documentation/devicetree/bindings/mfd/omap-usb-host.txt
+
+Required properties:
+
+- compatible: should be "ti,ehci-omap"
+- reg: should contain one register range i.e. start and length
+- interrupts: description of the interrupt line
+
+Optional properties:
+
+- phys: list of phandles to PHY nodes.
+  This property is required if at least one of the ports are in
+  PHY mode i.e. OMAP_EHCI_PORT_MODE_PHY
+
+To specify the port mode, see
+Documentation/devicetree/bindings/mfd/omap-usb-host.txt
+
+Example for OMAP4:
+
+usbhsehci: ehci@4a064c00 {
+	compatible = "ti,ehci-omap", "usb-ehci";
+	reg = <0x4a064c00 0x400>;
+	interrupts = <0 77 0x4>;
+};
+
+&usbhsehci {
+	phys = <&hsusb1_phy 0 &hsusb3_phy>;
+};
+
diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 7d05cce..45cd01e 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -48,6 +48,8 @@
 #include <linux/clk.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
+#include <linux/of.h>
+#include <linux/dma-mapping.h>
 
 #include "ehci.h"
 
@@ -121,6 +123,8 @@ static const struct ehci_driver_overrides ehci_omap_overrides __initdata = {
 	.extra_priv_size = sizeof(struct omap_hcd),
 };
 
+static u64 omap_ehci_dma_mask = DMA_BIT_MASK(32);
+
 /**
  * ehci_hcd_omap_probe - initialize TI-based HCDs
  *
@@ -148,6 +152,17 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	/* For DT boot, get platform data from parent. i.e. usbhshost */
+	if (dev->of_node) {
+		pdata = dev->parent->platform_data;
+		dev->platform_data = pdata;
+	}
+
+	if (!pdata) {
+		dev_err(dev, "Missing platform data\n");
+		return -ENODEV;
+	}
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(dev, "EHCI irq failed\n");
@@ -159,6 +174,14 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
 
+	/*
+	 * Right now device-tree probed devices don't get dma_mask set.
+	 * Since shared usb code relies on it, set it here for now.
+	 * Once we have dma capability bindings this can go away.
+	 */
+	if (!pdev->dev.dma_mask)
+		pdev->dev.dma_mask = &omap_ehci_dma_mask;
+
 	hcd = usb_create_hcd(&ehci_omap_hc_driver, dev,
 			dev_name(dev));
 	if (!hcd) {
@@ -183,7 +206,10 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 			continue;
 
 		/* get the PHY device */
-		phy = devm_usb_get_phy_dev(dev, i);
+		if (dev->of_node)
+			phy = devm_usb_get_phy_by_phandle(dev, "phys", i);
+		else
+			phy = devm_usb_get_phy_dev(dev, i);
 		if (IS_ERR(phy) || !phy) {
 			ret = IS_ERR(phy) ? PTR_ERR(phy) : -ENODEV;
 			dev_err(dev, "Can't get PHY device for port %d: %d\n",
@@ -273,6 +299,13 @@ static void ehci_hcd_omap_shutdown(struct platform_device *pdev)
 		hcd->driver->shutdown(hcd);
 }
 
+static const struct of_device_id omap_ehci_dt_ids[] = {
+	{ .compatible = "ti,ehci-omap" },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, omap_ehci_dt_ids);
+
 static struct platform_driver ehci_hcd_omap_driver = {
 	.probe			= ehci_hcd_omap_probe,
 	.remove			= ehci_hcd_omap_remove,
@@ -281,6 +314,7 @@ static struct platform_driver ehci_hcd_omap_driver = {
 	/*.resume		= ehci_hcd_omap_resume, */
 	.driver = {
 		.name		= hcd_name,
+		.of_match_table = of_match_ptr(omap_ehci_dt_ids),
 	}
 };
 
@@ -307,6 +341,7 @@ module_exit(ehci_omap_cleanup);
 MODULE_ALIAS("platform:ehci-omap");
 MODULE_AUTHOR("Texas Instruments, Inc.");
 MODULE_AUTHOR("Felipe Balbi <felipe.balbi@nokia.com>");
+MODULE_AUTHOR("Roger Quadros <rogerq@ti.com>");
 
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
-- 
1.7.4.1

