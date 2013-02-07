Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab3BGQDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:03:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43468 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab3BGQD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:03:28 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <b-cousson@ti.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <linux@arm.linux.org.uk>, <kishon@ti.com>,
        <mark.rutland@arm.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 07/14] USB: ohci-omap3: Add device tree support and binding information
Date: Thu, 7 Feb 2013 18:02:47 +0200
Message-ID: <1360252974-7912-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1360252974-7912-1-git-send-email-rogerq@ti.com>
References: <1360252974-7912-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows the OHCI controller found in OMAP3 and later chips to
be specified via device tree.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 .../devicetree/bindings/usb/omap3-ohci.txt         |   17 +++++++++++++++++
 drivers/usb/host/ohci-omap3.c                      |   19 +++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/omap3-ohci.txt

diff --git a/Documentation/devicetree/bindings/usb/omap3-ohci.txt b/Documentation/devicetree/bindings/usb/omap3-ohci.txt
new file mode 100644
index 0000000..ad2ace0
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/omap3-ohci.txt
@@ -0,0 +1,17 @@
+OMAP HS USB OHCI controller (OMAP3 and later)
+
+Required properties:
+
+- compatible: should be "ti,ohci-omap3"
+- reg: should contain one register range i.e. start and length
+- interrupt-parent: phandle to the interrupt controller
+- interrupts: description of the interrupt line
+
+Example for OMAP4:
+
+usbhsohci: ohci@4a064800 {
+	compatible = "ti,ohci-omap3", "usb-ohci";
+	reg = <0x4a064800 0x400>;
+	interrupt-parent = <&gic>;
+	interrupts = <0 76 0x4>;
+};
diff --git a/drivers/usb/host/ohci-omap3.c b/drivers/usb/host/ohci-omap3.c
index 5ed28c5..ddfc314 100644
--- a/drivers/usb/host/ohci-omap3.c
+++ b/drivers/usb/host/ohci-omap3.c
@@ -31,6 +31,8 @@
 
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/of.h>
+#include <linux/dma-mapping.h>
 
 /*-------------------------------------------------------------------------*/
 
@@ -112,6 +114,8 @@ static const struct hc_driver ohci_omap3_hc_driver = {
 
 /*-------------------------------------------------------------------------*/
 
+static u64 omap_ohci_dma_mask = DMA_BIT_MASK(32);
+
 /*
  * configure so an HC device and id are always provided
  * always called with process context; sleeping is OK
@@ -159,6 +163,13 @@ static int ohci_hcd_omap3_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	/*
+	 * Right now device-tree probed devices don't get dma_mask set.
+	 * Since shared usb code relies on it, set it here for now.
+	 * Once we have dma capability bindings this can go away.
+	 */
+	if (!pdev->dev.dma_mask)
+		pdev->dev.dma_mask = &omap_ohci_dma_mask;
 
 	hcd = usb_create_hcd(&ohci_omap3_hc_driver, dev,
 			dev_name(dev));
@@ -228,12 +239,20 @@ static void ohci_hcd_omap3_shutdown(struct platform_device *pdev)
 		hcd->driver->shutdown(hcd);
 }
 
+static const struct of_device_id omap_ohci_dt_ids[] = {
+	{ .compatible = "ti,ohci-omap3" },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, omap_ohci_dt_ids);
+
 static struct platform_driver ohci_hcd_omap3_driver = {
 	.probe		= ohci_hcd_omap3_probe,
 	.remove		= ohci_hcd_omap3_remove,
 	.shutdown	= ohci_hcd_omap3_shutdown,
 	.driver		= {
 		.name	= "ohci-omap3",
+		.of_match_table = of_match_ptr(omap_ohci_dt_ids),
 	},
 };
 
-- 
1.7.4.1

