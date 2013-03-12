Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab3CLKpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:45:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41839 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab3CLKp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:45:28 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 09/12] USB: ohci-omap3: Add device tree support and binding information
Date: Tue, 12 Mar 2013 12:44:47 +0200
Message-ID: <1363085090-24676-10-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363085090-24676-1-git-send-email-rogerq@ti.com>
References: <1363085090-24676-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows the OHCI controller found in OMAP3 and later chips to
be specified via device tree.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 .../devicetree/bindings/usb/ohci-omap3.txt         |   15 +++++++++++++++
 drivers/usb/host/ohci-omap3.c                      |   19 +++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/ohci-omap3.txt

diff --git a/Documentation/devicetree/bindings/usb/ohci-omap3.txt b/Documentation/devicetree/bindings/usb/ohci-omap3.txt
new file mode 100644
index 0000000..14ab428
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ohci-omap3.txt
@@ -0,0 +1,15 @@
+OMAP HS USB OHCI controller (OMAP3 and later)
+
+Required properties:
+
+- compatible: should be "ti,ohci-omap3"
+- reg: should contain one register range i.e. start and length
+- interrupts: description of the interrupt line
+
+Example for OMAP4:
+
+usbhsohci: ohci@4a064800 {
+	compatible = "ti,ohci-omap3", "usb-ohci";
+	reg = <0x4a064800 0x400>;
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

