Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab3BGQDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:03:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49485 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243Ab3BGQDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:03:37 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <b-cousson@ti.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <linux@arm.linux.org.uk>, <kishon@ti.com>,
        <mark.rutland@arm.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v2 09/14] mfd: omap-usb-host: Add device tree support and binding information
Date: Thu, 7 Feb 2013 18:02:49 +0200
Message-ID: <1360252974-7912-10-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1360252974-7912-1-git-send-email-rogerq@ti.com>
References: <1360252974-7912-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows the OMAP HS USB host controller to be specified
via device tree.

CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 .../devicetree/bindings/mfd/omap-usb-host.txt      |   80 ++++++++++
 drivers/mfd/omap-usb-host.c                        |  160 +++++++++++++++++++-
 2 files changed, 234 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/omap-usb-host.txt

diff --git a/Documentation/devicetree/bindings/mfd/omap-usb-host.txt b/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
new file mode 100644
index 0000000..b381fa6
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
@@ -0,0 +1,80 @@
+OMAP HS USB Host
+
+Required properties:
+
+- compatible: should be "ti,usbhs-host"
+- reg: should contain one register range i.e. start and length
+- ti,hwmods: must contain "usb_host_hs"
+
+Optional properties:
+
+- num-ports: number of USB ports. Usually this is automatically detected
+  from the IP's revision register but can be overridden by specifying
+  this property. A maximum of 3 ports are supported at the moment.
+
+- portN-mode: String specifying the port mode for port N, where N can be
+  from 1 to 3. If the port mode is not specified, that port is treated
+  as unused. When specified, it must be one of the following.
+	"ehci-phy",
+        "ehci-tll",
+        "ehci-hsic",
+        "ohci-phy-6pin-datse0",
+        "ohci-phy-6pin-dpdm",
+        "ohci-phy-3pin-datse0",
+        "ohci-phy-4pin-dpdm",
+        "ohci-tll-6pin-datse0",
+        "ohci-tll-6pin-dpdm",
+        "ohci-tll-3pin-datse0",
+        "ohci-tll-4pin-dpdm",
+        "ohci-tll-2pin-datse0",
+        "ohci-tll-2pin-dpdm",
+
+- single-ulpi-bypass: Must be present if the controller contains a single
+  ULPI bypass control bit. e.g. OMAP3 silicon <= ES2.1
+
+Required properties if child node exists:
+
+- #address-cells: Must be 1
+- #size-cells: Must be 1
+- ranges: must be present
+
+Properties for children:
+
+The OMAP HS USB Host subsystem contains EHCI and OHCI controllers.
+See Documentation/devicetree/bindings/usb/omap-ehci.txt and
+omap3-ohci.txt
+
+Example for OMAP4:
+
+usbhshost: usbhshost@4a064000 {
+	compatible = "ti,usbhs-host";
+	reg = <0x4a064000 0x800>;
+	ti,hwmods = "usb_host_hs";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+
+	usbhsohci: ohci@4a064800 {
+		compatible = "ti,ohci-omap3", "usb-ohci";
+		reg = <0x4a064800 0x400>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 76 0x4>;
+	};
+
+	usbhsehci: ehci@4a064c00 {
+		compatible = "ti,ehci-omap", "usb-ehci";
+		reg = <0x4a064c00 0x400>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 77 0x4>;
+	};
+};
+
+&usbhshost {
+	port1-mode = "ehci-phy";
+	port2-mode = "ehci-tll";
+	port3-mode = "ehci-phy";
+};
+
+&usbhsehci {
+	phys = <&hsusb1_phy 0 &hsusb3_phy>;
+};
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index f8ed08e..ffc373bc 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -1,8 +1,9 @@
 /**
  * omap-usb-host.c - The USBHS core driver for OMAP EHCI & OHCI
  *
- * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com
+ * Copyright (C) 2011-2013 Texas Instruments Incorporated - http://www.ti.com
  * Author: Keshava Munegowda <keshava_mgowda@ti.com>
+ * Author: Roger Quadros <rogerq@ti.com>
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2  of
@@ -27,6 +28,8 @@
 #include <linux/platform_device.h>
 #include <linux/platform_data/usb-omap.h>
 #include <linux/pm_runtime.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 
 #include "omap-usb.h"
 
@@ -137,6 +140,49 @@ static inline u8 usbhs_readb(void __iomem *base, u8 reg)
 
 /*-------------------------------------------------------------------------*/
 
+/**
+ * Map 'enum usbhs_omap_port_mode' found in <linux/platform_data/usb-omap.h>
+ * to the device tree binding portN-mode found in
+ * 'Documentation/devicetree/bindings/mfd/omap-usb-host.txt'
+ */
+static const char *port_modes[] = {
+	[OMAP_USBHS_PORT_MODE_UNUSED]	= "",
+	[OMAP_EHCI_PORT_MODE_PHY]	= "ehci-phy",
+	[OMAP_EHCI_PORT_MODE_TLL]	= "ehci-tll",
+	[OMAP_EHCI_PORT_MODE_HSIC]	= "ehci-hsic",
+	[OMAP_OHCI_PORT_MODE_PHY_6PIN_DATSE0]	= "ohci-phy-6pin-datse0",
+	[OMAP_OHCI_PORT_MODE_PHY_6PIN_DPDM]	= "ohci-phy-6pin-dpdm",
+	[OMAP_OHCI_PORT_MODE_PHY_3PIN_DATSE0]	= "ohci-phy-3pin-datse0",
+	[OMAP_OHCI_PORT_MODE_PHY_4PIN_DPDM]	= "ohci-phy-4pin-dpdm",
+	[OMAP_OHCI_PORT_MODE_TLL_6PIN_DATSE0]	= "ohci-tll-6pin-datse0",
+	[OMAP_OHCI_PORT_MODE_TLL_6PIN_DPDM]	= "ohci-tll-6pin-dpdm",
+	[OMAP_OHCI_PORT_MODE_TLL_3PIN_DATSE0]	= "ohci-tll-3pin-datse0",
+	[OMAP_OHCI_PORT_MODE_TLL_4PIN_DPDM]	= "ohci-tll-4pin-dpdm",
+	[OMAP_OHCI_PORT_MODE_TLL_2PIN_DATSE0]	= "ohci-tll-2pin-datse0",
+	[OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM]	= "ohci-tll-2pin-dpdm",
+};
+
+/**
+ * omap_usbhs_get_dt_port_mode - Get the 'enum usbhs_omap_port_mode'
+ * from the port mode string.
+ * @mode: The port mode string, usually obtained from device tree.
+ *
+ * The function returns the 'enum usbhs_omap_port_mode' that matches the
+ * provided port mode string as per the port_modes table.
+ * If no match is found it returns -ENODEV
+ */
+static const int omap_usbhs_get_dt_port_mode(const char *mode)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(port_modes); i++) {
+		if (!strcasecmp(mode, port_modes[i]))
+			return i;
+	}
+
+	return -ENODEV;
+}
+
 static struct platform_device *omap_usbhs_alloc_child(const char *name,
 			struct resource	*res, int num_resources, void *pdata,
 			size_t pdata_size, struct device *dev)
@@ -464,6 +510,58 @@ static void omap_usbhs_init(struct device *dev)
 	pm_runtime_put_sync(dev);
 }
 
+static int usbhs_omap_get_dt_pdata(struct device *dev,
+					struct usbhs_omap_platform_data *pdata)
+{
+	int ret, i;
+	struct device_node *node = dev->of_node;
+
+	ret = of_property_read_u32(node, "num-ports", &pdata->nports);
+	if (ret)
+		pdata->nports = 0;
+
+	if (pdata->nports > OMAP3_HS_USB_PORTS) {
+		dev_warn(dev, "Too many num_ports:%d in device tree. Max:%d",
+				pdata->nports, OMAP3_HS_USB_PORTS);
+		return -ENODEV;
+	}
+
+	/* get port modes */
+	for (i = 0; i < OMAP3_HS_USB_PORTS; i++) {
+		char prop[11];
+		const char *mode;
+
+		pdata->port_mode[i] = OMAP_USBHS_PORT_MODE_UNUSED;
+
+		snprintf(prop, sizeof(prop), "port%d-mode", i + 1);
+		ret = of_property_read_string(node, prop, &mode);
+		if (ret < 0)
+			continue;
+
+		ret = omap_usbhs_get_dt_port_mode(mode);
+		if (ret < 0) {
+			dev_warn(dev, "Invalid port%d-mode \"%s\" in device tree\n",
+					i, mode);
+			return -ENODEV;
+		}
+
+		dev_dbg(dev, "port%d-mode: %s -> %d\n", i, mode, ret);
+		pdata->port_mode[i] = ret;
+	}
+
+	/* get flags */
+	pdata->single_ulpi_bypass = of_property_read_bool(node,
+						"single-ulpi-bypass");
+
+	return 0;
+}
+
+static struct of_device_id usbhs_child_match_table[] = {
+	{ .compatible = "ti,omap-ehci", },
+	{ .compatible = "ti,omap-ohci", },
+	{ }
+};
+
 /**
  * usbhs_omap_probe - initialize TI-based HCDs
  *
@@ -479,18 +577,37 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	int				i;
 	bool				need_logic_fck;
 
+	if (dev->of_node) {
+		/* For DT boot we populate platform data from OF node */
+		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+
+		ret = usbhs_omap_get_dt_pdata(dev, pdata);
+		if (ret)
+			return ret;
+
+		dev->platform_data = pdata;
+	}
+
 	if (!pdata) {
 		dev_err(dev, "Missing platform data\n");
 		return -ENODEV;
 	}
 
+	if (pdata->nports > OMAP3_HS_USB_PORTS) {
+		dev_info(dev, "Too many num_ports:%d in platform_data. Max:%d",
+				pdata->nports, OMAP3_HS_USB_PORTS);
+		return -ENODEV;
+	}
+
 	omap = devm_kzalloc(dev, sizeof(*omap), GFP_KERNEL);
 	if (!omap) {
 		dev_err(dev, "Memory allocation failed\n");
 		return -ENOMEM;
 	}
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "uhh");
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	omap->uhh_base = devm_request_and_ioremap(dev, res);
 	if (!omap->uhh_base) {
 		dev_err(dev, "Resource request/ioremap failed\n");
@@ -661,10 +778,23 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	}
 
 	omap_usbhs_init(dev);
-	ret = omap_usbhs_alloc_children(pdev);
-	if (ret) {
-		dev_err(dev, "omap_usbhs_alloc_children failed\n");
-		goto err_alloc;
+
+	if (dev->of_node) {
+		ret = of_platform_populate(dev->of_node,
+				usbhs_child_match_table, NULL, dev);
+
+		if (ret) {
+			dev_err(dev, "Failed to create DT children: %d\n", ret);
+			goto err_alloc;
+		}
+
+	} else {
+		ret = omap_usbhs_alloc_children(pdev);
+		if (ret) {
+			dev_err(dev, "omap_usbhs_alloc_children failed: %d\n",
+						ret);
+			goto err_alloc;
+		}
 	}
 
 	return 0;
@@ -703,6 +833,13 @@ err_mem:
 	return ret;
 }
 
+static int usbhs_omap_remove_child(struct device *dev, void *data)
+{
+	dev_info(dev, "unregistering\n");
+	platform_device_unregister(to_platform_device(dev));
+	return 0;
+}
+
 /**
  * usbhs_omap_remove - shutdown processing for UHH & TLL HCDs
  * @pdev: USB Host Controller being removed
@@ -734,6 +871,8 @@ static int usbhs_omap_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
+	/* remove children */
+	device_for_each_child(&pdev->dev, NULL, usbhs_omap_remove_child);
 	return 0;
 }
 
@@ -742,11 +881,20 @@ static const struct dev_pm_ops usbhsomap_dev_pm_ops = {
 	.runtime_resume		= usbhs_runtime_resume,
 };
 
+static const struct of_device_id usbhs_omap_dt_ids[] = {
+	{ .compatible = "ti,usbhs-host" },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, usbhs_omap_dt_ids);
+
+
 static struct platform_driver usbhs_omap_driver = {
 	.driver = {
 		.name		= (char *)usbhs_driver_name,
 		.owner		= THIS_MODULE,
 		.pm		= &usbhsomap_dev_pm_ops,
+		.of_match_table = of_match_ptr(usbhs_omap_dt_ids),
 	},
 	.remove		= usbhs_omap_remove,
 };
-- 
1.7.4.1

