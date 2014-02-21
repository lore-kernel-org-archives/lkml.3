Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaBUGkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 01:40:01 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:17976 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397AbaBUGj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 01:39:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhgEALbyBlOl5H4JgWdsb2JhbABZhkm+FIEkDgEBFiYogiYBBSdSEAhJVwcJCYgFzT0XjmQHhDgEmDSUFoFSKA
From: Alistair Popple <alistair@popple.id.au>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: Alistair Popple <alistair@popple.id.au>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 4/7] ECHI Platform: Merge ppc-of EHCI driver into the ehci-platform driver
Date: Fri, 21 Feb 2014 17:31:30 +1100
Message-Id: <1392964293-13687-5-git-send-email-alistair@popple.id.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392964293-13687-1-git-send-email-alistair@popple.id.au>
References: <1392964293-13687-1-git-send-email-alistair@popple.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the ppc-of driver uses the compatibility string
"usb-ehci". This means platforms that use device-tree and implement an
EHCI compatible interface have to either use the ppc-of driver or add
a compatible line to the ehci-platform driver. It would be more
appropriate for the platform driver to be compatible with "usb-ehci"
as non-powerpc platforms are also beginning to utilise device-tree.

This patch merges the device tree property parsing from ehci-ppc-of
into the platform driver and adds a "usb-ehci" compatibility
string. The existing ehci-ppc-of driver is removed and the 440EPX
specific quirks are added to the ehci-platform driver.

Signed-off-by: Alistair Popple <alistair@popple.id.au>
---
 drivers/usb/host/Kconfig         |    7 +-
 drivers/usb/host/ehci-hcd.c      |    5 -
 drivers/usb/host/ehci-platform.c |   87 +++++++++++++-
 drivers/usb/host/ehci-ppc-of.c   |  238 --------------------------------------
 4 files changed, 89 insertions(+), 248 deletions(-)
 delete mode 100644 drivers/usb/host/ehci-ppc-of.c

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index a9707da..5d9b3ff 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -189,12 +189,13 @@ config USB_EHCI_TEGRA
          found in NVIDIA Tegra SoCs. The controllers are EHCI compliant.
 
 config USB_EHCI_HCD_PPC_OF
-	bool "EHCI support for PPC USB controller on OF platform bus"
+	bool "EHCI support for PPC USB controller on OF platform bus (DEPRECATED)"
 	depends on PPC_OF
 	default y
+	select USB_EHCI_HCD_PLATFORM
 	---help---
-	  Enables support for the USB controller present on the PowerPC
-	  OpenFirmware platform bus.
+	  This option is deprecated now and the driver was removed, use
+	  USB_EHCI_HCD_PLATFORM instead.
 
 config USB_EHCI_SH
 	bool "EHCI support for SuperH USB controller"
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index e8ba4c4..b2bbd4b 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1261,11 +1261,6 @@ MODULE_LICENSE ("GPL");
 #define	PS3_SYSTEM_BUS_DRIVER	ps3_ehci_driver
 #endif
 
-#ifdef CONFIG_USB_EHCI_HCD_PPC_OF
-#include "ehci-ppc-of.c"
-#define OF_PLATFORM_DRIVER	ehci_hcd_ppc_of_driver
-#endif
-
 #ifdef CONFIG_XPS_USB_HCD_XILINX
 #include "ehci-xilinx-of.c"
 #define XILINX_OF_PLATFORM_DRIVER	ehci_hcd_xilinx_of_driver
diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index 7f30b71..71959eb 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -25,6 +25,7 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
@@ -36,11 +37,33 @@
 
 static const char hcd_name[] = "ehci-platform";
 
+/*
+ * 440EPx Errata USBH_3
+ * Fix: Enable Break Memory Transfer (BMT) in INSNREG3
+ */
+#define PPC440EPX_EHCI0_INSREG_BMT	(0x1 << 0)
+static int
+ppc44x_enable_bmt(struct device_node *dn)
+{
+	__iomem u32 *insreg_virt;
+
+	insreg_virt = of_iomap(dn, 1);
+	if (!insreg_virt)
+		return  -EINVAL;
+
+	out_be32(insreg_virt + 3, PPC440EPX_EHCI0_INSREG_BMT);
+
+	iounmap(insreg_virt);
+	return 0;
+}
+
 static int ehci_platform_reset(struct usb_hcd *hcd)
 {
 	struct platform_device *pdev = to_platform_device(hcd->self.controller);
 	struct usb_ehci_pdata *pdata = dev_get_platdata(&pdev->dev);
 	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
+	struct device_node *dn, *np;
+	struct resource res;
 	int retval;
 
 	hcd->has_tt = pdata->has_tt;
@@ -48,6 +71,43 @@ static int ehci_platform_reset(struct usb_hcd *hcd)
 	ehci->big_endian_desc = pdata->big_endian_desc;
 	ehci->big_endian_mmio = pdata->big_endian_mmio;
 
+	/* Device tree properties if available will override platform data. */
+	dn = hcd_to_bus(hcd)->controller->of_node;
+	if (dn) {
+		if (of_get_property(dn, "big-endian", NULL)) {
+			ehci->big_endian_mmio = 1;
+			ehci->big_endian_desc = 1;
+		}
+		if (of_get_property(dn, "big-endian-regs", NULL))
+			ehci->big_endian_mmio = 1;
+		if (of_get_property(dn, "big-endian-desc", NULL))
+			ehci->big_endian_desc = 1;
+	}
+
+	np = of_find_compatible_node(NULL, NULL, "ibm,usb-ohci-440epx");
+	if (np != NULL) {
+		/* claim we really affected by usb23 erratum */
+		if (!of_address_to_resource(np, 0, &res))
+			ehci->ohci_hcctrl_reg =
+				devm_ioremap(&pdev->dev,
+					     res.start + OHCI_HCCTRL_OFFSET,
+					     OHCI_HCCTRL_LEN);
+		else
+			ehci_dbg(ehci, "%s: no ohci offset in fdt\n", __FILE__);
+		if (!ehci->ohci_hcctrl_reg) {
+			ehci_dbg(ehci, "%s: ioremap for ohci hcctrl failed\n",
+				__FILE__);
+		} else {
+			ehci->has_amcc_usb23 = 1;
+		}
+	}
+
+	if (of_device_is_compatible(dn, "ibm,usb-ehci-440epx")) {
+		retval = ppc44x_enable_bmt(dn);
+		ehci_dbg(ehci, "Break Memory Transfer (BMT) is %senabled!\n",
+			retval ? "NOT " : "");
+	}
+
 	if (pdata->pre_setup) {
 		retval = pdata->pre_setup(hcd);
 		if (retval < 0)
@@ -149,6 +209,9 @@ static int ehci_platform_remove(struct platform_device *dev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 	struct usb_ehci_pdata *pdata = dev_get_platdata(&dev->dev);
+	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
+	struct device_node *np;
+	struct resource res;
 
 	usb_remove_hcd(hcd);
 	usb_put_hcd(hcd);
@@ -159,6 +222,25 @@ static int ehci_platform_remove(struct platform_device *dev)
 	if (pdata == &ehci_platform_defaults)
 		dev->dev.platform_data = NULL;
 
+	/* use request_mem_region to test if the ohci driver is loaded.  if so
+	 * ensure the ohci core is operational.
+	 */
+	if (ehci->has_amcc_usb23) {
+		np = of_find_compatible_node(NULL, NULL, "ibm,usb-ohci-440epx");
+		if (np != NULL) {
+			if (!of_address_to_resource(np, 0, &res))
+				if (!request_mem_region(res.start,
+							    0x4, hcd_name))
+					set_ohci_hcfs(ehci, 1);
+				else
+					release_mem_region(res.start, 0x4);
+			else
+				ehci_dbg(ehci, "%s: no ohci offset in fdt\n",
+					__FILE__);
+			of_node_put(np);
+		}
+	}
+
 	return 0;
 }
 
@@ -203,9 +285,10 @@ static int ehci_platform_resume(struct device *dev)
 #define ehci_platform_resume	NULL
 #endif /* CONFIG_PM */
 
-static const struct of_device_id vt8500_ehci_ids[] = {
+static const struct of_device_id ehci_platform_ids[] = {
 	{ .compatible = "via,vt8500-ehci", },
 	{ .compatible = "wm,prizm-ehci", },
+	{ .compatible = "usb-ehci", },
 	{}
 };
 
@@ -229,7 +312,7 @@ static struct platform_driver ehci_platform_driver = {
 		.owner	= THIS_MODULE,
 		.name	= "ehci-platform",
 		.pm	= &ehci_platform_pm_ops,
-		.of_match_table = vt8500_ehci_ids,
+		.of_match_table = ehci_platform_ids,
 	}
 };
 
diff --git a/drivers/usb/host/ehci-ppc-of.c b/drivers/usb/host/ehci-ppc-of.c
deleted file mode 100644
index 875d2fc..0000000
--- a/drivers/usb/host/ehci-ppc-of.c
+++ /dev/null
@@ -1,238 +0,0 @@
-/*
- * EHCI HCD (Host Controller Driver) for USB.
- *
- * Bus Glue for PPC On-Chip EHCI driver on the of_platform bus
- * Tested on AMCC PPC 440EPx
- *
- * Valentine Barshak <vbarshak@ru.mvista.com>
- *
- * Based on "ehci-ppc-soc.c" by Stefan Roese <sr@denx.de>
- * and "ohci-ppc-of.c" by Sylvain Munaut <tnt@246tNt.com>
- *
- * This file is licenced under the GPL.
- */
-
-#include <linux/err.h>
-#include <linux/signal.h>
-
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
-#include <linux/of_platform.h>
-
-
-static const struct hc_driver ehci_ppc_of_hc_driver = {
-	.description		= hcd_name,
-	.product_desc		= "OF EHCI",
-	.hcd_priv_size		= sizeof(struct ehci_hcd),
-
-	/*
-	 * generic hardware linkage
-	 */
-	.irq			= ehci_irq,
-	.flags			= HCD_MEMORY | HCD_USB2 | HCD_BH,
-
-	/*
-	 * basic lifecycle operations
-	 */
-	.reset			= ehci_setup,
-	.start			= ehci_run,
-	.stop			= ehci_stop,
-	.shutdown		= ehci_shutdown,
-
-	/*
-	 * managing i/o requests and associated device resources
-	 */
-	.urb_enqueue		= ehci_urb_enqueue,
-	.urb_dequeue		= ehci_urb_dequeue,
-	.endpoint_disable	= ehci_endpoint_disable,
-	.endpoint_reset		= ehci_endpoint_reset,
-
-	/*
-	 * scheduling support
-	 */
-	.get_frame_number	= ehci_get_frame,
-
-	/*
-	 * root hub support
-	 */
-	.hub_status_data	= ehci_hub_status_data,
-	.hub_control		= ehci_hub_control,
-#ifdef	CONFIG_PM
-	.bus_suspend		= ehci_bus_suspend,
-	.bus_resume		= ehci_bus_resume,
-#endif
-	.relinquish_port	= ehci_relinquish_port,
-	.port_handed_over	= ehci_port_handed_over,
-
-	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
-};
-
-
-/*
- * 440EPx Errata USBH_3
- * Fix: Enable Break Memory Transfer (BMT) in INSNREG3
- */
-#define PPC440EPX_EHCI0_INSREG_BMT	(0x1 << 0)
-static int
-ppc44x_enable_bmt(struct device_node *dn)
-{
-	__iomem u32 *insreg_virt;
-
-	insreg_virt = of_iomap(dn, 1);
-	if (!insreg_virt)
-		return  -EINVAL;
-
-	out_be32(insreg_virt + 3, PPC440EPX_EHCI0_INSREG_BMT);
-
-	iounmap(insreg_virt);
-	return 0;
-}
-
-
-static int ehci_hcd_ppc_of_probe(struct platform_device *op)
-{
-	struct device_node *dn = op->dev.of_node;
-	struct usb_hcd *hcd;
-	struct ehci_hcd	*ehci = NULL;
-	struct resource res;
-	int irq;
-	int rv;
-
-	struct device_node *np;
-
-	if (usb_disabled())
-		return -ENODEV;
-
-	dev_dbg(&op->dev, "initializing PPC-OF USB Controller\n");
-
-	rv = of_address_to_resource(dn, 0, &res);
-	if (rv)
-		return rv;
-
-	hcd = usb_create_hcd(&ehci_ppc_of_hc_driver, &op->dev, "PPC-OF USB");
-	if (!hcd)
-		return -ENOMEM;
-
-	hcd->rsrc_start = res.start;
-	hcd->rsrc_len = resource_size(&res);
-
-	irq = irq_of_parse_and_map(dn, 0);
-	if (irq == NO_IRQ) {
-		printk(KERN_ERR "%s: irq_of_parse_and_map failed\n", __FILE__);
-		rv = -EBUSY;
-		goto err_irq;
-	}
-
-	hcd->regs = devm_ioremap_resource(&op->dev, &res);
-	if (IS_ERR(hcd->regs)) {
-		rv = PTR_ERR(hcd->regs);
-		goto err_ioremap;
-	}
-
-	ehci = hcd_to_ehci(hcd);
-	np = of_find_compatible_node(NULL, NULL, "ibm,usb-ohci-440epx");
-	if (np != NULL) {
-		/* claim we really affected by usb23 erratum */
-		if (!of_address_to_resource(np, 0, &res))
-			ehci->ohci_hcctrl_reg =
-				devm_ioremap(&op->dev,
-					     res.start + OHCI_HCCTRL_OFFSET,
-					     OHCI_HCCTRL_LEN);
-		else
-			pr_debug("%s: no ohci offset in fdt\n", __FILE__);
-		if (!ehci->ohci_hcctrl_reg) {
-			pr_debug("%s: ioremap for ohci hcctrl failed\n", __FILE__);
-		} else {
-			ehci->has_amcc_usb23 = 1;
-		}
-	}
-
-	if (of_get_property(dn, "big-endian", NULL)) {
-		ehci->big_endian_mmio = 1;
-		ehci->big_endian_desc = 1;
-	}
-	if (of_get_property(dn, "big-endian-regs", NULL))
-		ehci->big_endian_mmio = 1;
-	if (of_get_property(dn, "big-endian-desc", NULL))
-		ehci->big_endian_desc = 1;
-
-	ehci->caps = hcd->regs;
-
-	if (of_device_is_compatible(dn, "ibm,usb-ehci-440epx")) {
-		rv = ppc44x_enable_bmt(dn);
-		ehci_dbg(ehci, "Break Memory Transfer (BMT) is %senabled!\n",
-				rv ? "NOT ": "");
-	}
-
-	rv = usb_add_hcd(hcd, irq, 0);
-	if (rv)
-		goto err_ioremap;
-
-	return 0;
-
-err_ioremap:
-	irq_dispose_mapping(irq);
-err_irq:
-	usb_put_hcd(hcd);
-
-	return rv;
-}
-
-
-static int ehci_hcd_ppc_of_remove(struct platform_device *op)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(op);
-	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
-
-	struct device_node *np;
-	struct resource res;
-
-	dev_dbg(&op->dev, "stopping PPC-OF USB Controller\n");
-
-	usb_remove_hcd(hcd);
-
-	irq_dispose_mapping(hcd->irq);
-
-	/* use request_mem_region to test if the ohci driver is loaded.  if so
-	 * ensure the ohci core is operational.
-	 */
-	if (ehci->has_amcc_usb23) {
-		np = of_find_compatible_node(NULL, NULL, "ibm,usb-ohci-440epx");
-		if (np != NULL) {
-			if (!of_address_to_resource(np, 0, &res))
-				if (!request_mem_region(res.start,
-							    0x4, hcd_name))
-					set_ohci_hcfs(ehci, 1);
-				else
-					release_mem_region(res.start, 0x4);
-			else
-				pr_debug("%s: no ohci offset in fdt\n", __FILE__);
-			of_node_put(np);
-		}
-	}
-	usb_put_hcd(hcd);
-
-	return 0;
-}
-
-
-static const struct of_device_id ehci_hcd_ppc_of_match[] = {
-	{
-		.compatible = "usb-ehci",
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(of, ehci_hcd_ppc_of_match);
-
-
-static struct platform_driver ehci_hcd_ppc_of_driver = {
-	.probe		= ehci_hcd_ppc_of_probe,
-	.remove		= ehci_hcd_ppc_of_remove,
-	.shutdown	= usb_hcd_platform_shutdown,
-	.driver = {
-		.name = "ppc-of-ehci",
-		.owner = THIS_MODULE,
-		.of_match_table = ehci_hcd_ppc_of_match,
-	},
-};
-- 
1.7.10.4

