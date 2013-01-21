Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3AUOK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:10:27 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52868 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab3AUOJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:09:07 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <balbi@ti.com>, <b-cousson@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v2 1/4] drivers: usb: phy: add a new driver for usb part of control module
Date: Mon, 21 Jan 2013 19:38:25 +0530
Message-ID: <1358777308-2409-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358777308-2409-1-git-send-email-kishon@ti.com>
References: <1358777308-2409-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a new driver for the usb part of control module. This has an API
to power on the USB2 phy and an API to write to the mailbox depending on
whether MUSB has to act in host mode or in device mode.

Writing to control module registers for doing the above task which was
previously done in omap glue and in omap-usb2 phy will be removed.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/usb/omap-usb.txt |   26 ++-
 Documentation/devicetree/bindings/usb/usb-phy.txt  |    5 +
 drivers/usb/phy/Kconfig                            |    9 +
 drivers/usb/phy/Makefile                           |    1 +
 drivers/usb/phy/omap-control-usb.c                 |  238 ++++++++++++++++++++
 include/linux/usb/omap_control_usb.h               |   71 ++++++
 6 files changed, 349 insertions(+), 1 deletion(-)
 create mode 100644 drivers/usb/phy/omap-control-usb.c
 create mode 100644 include/linux/usb/omap_control_usb.h

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index 29a043e..ead6ba9 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -1,4 +1,4 @@
-OMAP GLUE
+OMAP GLUE AND OTHER OMAP SPECIFIC COMPONENTS
 
 OMAP MUSB GLUE
  - compatible : Should be "ti,omap4-musb" or "ti,omap3-musb"
@@ -16,6 +16,10 @@ OMAP MUSB GLUE
  - power : Should be "50". This signifies the controller can supply upto
    100mA when operating in host mode.
 
+Optional properties:
+ - ctrl_module : phandle of the control module this glue uses to write to
+   mailbox
+
 SOC specific device node entry
 usb_otg_hs: usb_otg_hs@4a0ab000 {
 	compatible = "ti,omap4-musb";
@@ -23,6 +27,7 @@ usb_otg_hs: usb_otg_hs@4a0ab000 {
 	multipoint = <1>;
 	num_eps = <16>;
 	ram_bits = <12>;
+	ctrl_module = <&omap_control_usb>;
 };
 
 Board specific device node entry
@@ -31,3 +36,22 @@ Board specific device node entry
 	mode = <3>;
 	power = <50>;
 };
+
+OMAP CONTROL USB
+
+Required properties:
+ - compatible: Should be "ti,omap-control-usb"
+ - reg : Address and length of the register set for the device. It contains
+   the address of "control_dev_conf" and "otghs_control".
+ - reg-names: The names of the register addresses corresponding to the registers
+   filled in "reg".
+ - ti,has_mailbox: This is used to specify if the platform has mailbox in
+   control module.
+
+omap_control_usb: omap-control-usb@4a002300 {
+	compatible = "ti,omap-control-usb";
+	reg = <0x4a002300 0x4>,
+	      <0x4a00233c 0x4>;
+	reg-names = "control_dev_conf", "otghs_control";
+	ti,has_mailbox;
+};
diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
index 80d4148..2466b6f 100644
--- a/Documentation/devicetree/bindings/usb/usb-phy.txt
+++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
@@ -8,10 +8,15 @@ Required properties:
 add the address of control module dev conf register until a driver for
 control module is added
 
+Optional properties:
+ - ctrl_module : phandle of the control module used by PHY driver to power on
+   the PHY.
+
 This is usually a subnode of ocp2scp to which it is connected.
 
 usb2phy@4a0ad080 {
 	compatible = "ti,omap-usb2";
 	reg = <0x4a0ad080 0x58>,
 	      <0x4a002300 0x4>;
+	ctrl_module = <&omap_control_usb>;
 };
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 36a85b6..20479e8 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -14,6 +14,15 @@ config OMAP_USB2
 	  The USB OTG controller communicates with the comparator using this
 	  driver.
 
+config OMAP_CONTROL_USB
+	tristate "OMAP CONTROL USB Driver"
+	depends on ARCH_OMAP2PLUS
+	help
+	  Enable this to add support for the USB part present in the control
+	  module. This driver has API to power on the PHY and to write to the
+	  mailbox. The mailbox is present only in omap4 and the register to
+	  power on the PHY is present in omap4 and omap5.
+
 config USB_ISP1301
 	tristate "NXP ISP1301 USB transceiver support"
 	depends on USB || USB_GADGET
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index ec304f6..ee97767 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -5,6 +5,7 @@
 ccflags-$(CONFIG_USB_DEBUG) := -DDEBUG
 
 obj-$(CONFIG_OMAP_USB2)			+= omap-usb2.o
+obj-$(CONFIG_OMAP_CONTROL_USB)		+= omap-control-usb.o
 obj-$(CONFIG_USB_ISP1301)		+= isp1301.o
 obj-$(CONFIG_MV_U3D_PHY)		+= mv_u3d_phy.o
 obj-$(CONFIG_USB_EHCI_TEGRA)	+= tegra_usb_phy.o
diff --git a/drivers/usb/phy/omap-control-usb.c b/drivers/usb/phy/omap-control-usb.c
new file mode 100644
index 0000000..e8fd85c
--- /dev/null
+++ b/drivers/usb/phy/omap-control-usb.c
@@ -0,0 +1,238 @@
+/*
+ * omap-control-usb.c - The USB part of control module.
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Author: Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/usb/omap_control_usb.h>
+
+static struct omap_control_usb *control_usb;
+
+/**
+ * omap_get_control_dev - returns the device pointer for this control device
+ *
+ * This API should be called to get the device pointer for this control
+ * module device. This device pointer should be used for called other
+ * exported API's in this driver.
+ *
+ * To be used by PHY driver and glue driver.
+ */
+struct device *omap_get_control_dev(void)
+{
+	if (!control_usb)
+		return ERR_PTR(-ENODEV);
+
+	return control_usb->dev;
+}
+EXPORT_SYMBOL_GPL(omap_get_control_dev);
+
+/**
+ * omap_control_usb_phy_power - power on/off the phy using control module reg
+ * @dev: the control module device
+ * @on: 0 or 1, based on powering on or off the PHY
+ */
+void omap_control_usb_phy_power(struct device *dev, int on)
+{
+	u32 val;
+	struct omap_control_usb	*control_usb = dev_get_drvdata(dev);
+
+	val = readl(control_usb->dev_conf);
+
+	if (on)
+		val &= ~OMAP_CTRL_DEV_PHY_PD;
+	else
+		val |= OMAP_CTRL_DEV_PHY_PD;
+
+	writel(val, control_usb->dev_conf);
+}
+EXPORT_SYMBOL_GPL(omap_control_usb_phy_power);
+
+/**
+ * omap_control_usb_host_mode - set AVALID, VBUSVALID and ID pin in grounded
+ * @ctrl_usb: struct omap_control_usb *
+ *
+ * Writes to the mailbox register to notify the usb core that a usb
+ * device has been connected.
+ */
+static void omap_control_usb_host_mode(struct omap_control_usb *ctrl_usb)
+{
+	u32 val;
+
+	val = readl(ctrl_usb->otghs_control);
+	val &= ~(OMAP_CTRL_DEV_IDDIG | OMAP_CTRL_DEV_SESSEND);
+	val |= OMAP_CTRL_DEV_AVALID | OMAP_CTRL_DEV_VBUSVALID;
+	writel(val, ctrl_usb->otghs_control);
+}
+
+/**
+ * omap_control_usb_device_mode - set AVALID, VBUSVALID and ID pin in high
+ * impedance
+ * @ctrl_usb: struct omap_control_usb *
+ *
+ * Writes to the mailbox register to notify the usb core that it has been
+ * connected to a usb host.
+ */
+static void omap_control_usb_device_mode(struct omap_control_usb *ctrl_usb)
+{
+	u32 val;
+
+	val = readl(ctrl_usb->otghs_control);
+	val &= ~OMAP_CTRL_DEV_SESSEND;
+	val |= OMAP_CTRL_DEV_IDDIG | OMAP_CTRL_DEV_AVALID |
+		OMAP_CTRL_DEV_VBUSVALID;
+	writel(val, ctrl_usb->otghs_control);
+}
+
+/**
+ * omap_control_usb_set_sessionend - Enable SESSIONEND and IDIG to high
+ * impedance
+ * @ctrl_usb: struct omap_control_usb *
+ *
+ * Writes to the mailbox register to notify the usb core it's now in
+ * disconnected state.
+ */
+static void omap_control_usb_set_sessionend(struct omap_control_usb *ctrl_usb)
+{
+	u32 val;
+
+	val = readl(ctrl_usb->otghs_control);
+	val &= ~(OMAP_CTRL_DEV_AVALID | OMAP_CTRL_DEV_VBUSVALID);
+	val |= OMAP_CTRL_DEV_IDDIG | OMAP_CTRL_DEV_SESSEND;
+	writel(val, ctrl_usb->otghs_control);
+}
+
+/**
+ * omap_control_usb_set_mode - Calls to functions to set USB in one of host mode
+ * or device mode or to denote disconnected state
+ * @dev: the control module device
+ * @mode: The mode to which usb should be configured
+ *
+ * This is an API to write to the mailbox register to notify the usb core that
+ * a usb device has been connected.
+ */
+void omap_control_usb_set_mode(struct device *dev,
+	enum omap_control_usb_mode mode)
+{
+	struct omap_control_usb	*ctrl_usb;
+
+	if (IS_ERR(dev))
+		return;
+
+	ctrl_usb = dev_get_drvdata(dev);
+
+	switch (mode) {
+	case USB_MODE_HOST:
+		omap_control_usb_host_mode(ctrl_usb);
+		break;
+	case USB_MODE_DEVICE:
+		omap_control_usb_device_mode(ctrl_usb);
+		break;
+	case USB_MODE_DISCONNECT:
+		omap_control_usb_set_sessionend(ctrl_usb);
+		break;
+	default:
+		dev_vdbg(dev, "invalid omap control usb mode\n");
+	}
+}
+EXPORT_SYMBOL_GPL(omap_control_usb_set_mode);
+
+static int omap_control_usb_probe(struct platform_device *pdev)
+{
+	struct resource	*res;
+	struct device_node *np = pdev->dev.of_node;
+	struct omap_control_usb_platform_data *pdata = pdev->dev.platform_data;
+
+	control_usb = devm_kzalloc(&pdev->dev, sizeof(*control_usb),
+		GFP_KERNEL);
+	if (!control_usb) {
+		dev_err(&pdev->dev, "unable to alloc memory for control usb\n");
+		return -ENOMEM;
+	}
+
+	if (np) {
+		control_usb->has_mailbox = of_property_read_bool(np,
+			"ti,has_mailbox");
+	} else if (pdata) {
+		control_usb->has_mailbox = pdata->has_mailbox;
+	} else {
+		dev_err(&pdev->dev, "no pdata present\n");
+		return -EINVAL;
+	}
+
+	control_usb->dev	= &pdev->dev;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+		"control_dev_conf");
+	control_usb->dev_conf = devm_request_and_ioremap(&pdev->dev, res);
+	if (control_usb->dev_conf == NULL) {
+		dev_err(&pdev->dev, "Failed to obtain io memory\n");
+		return -EADDRNOTAVAIL;
+	}
+
+	if (control_usb->has_mailbox) {
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+			"otghs_control");
+		control_usb->otghs_control = devm_request_and_ioremap(
+			&pdev->dev, res);
+		if (control_usb->otghs_control == NULL) {
+			dev_err(&pdev->dev, "Failed to obtain io memory\n");
+			return -EADDRNOTAVAIL;
+		}
+	}
+
+	dev_set_drvdata(control_usb->dev, control_usb);
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id omap_control_usb_id_table[] = {
+	{ .compatible = "ti,omap-control-usb" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, omap_control_usb_id_table);
+#endif
+
+static struct platform_driver omap_control_usb_driver = {
+	.probe		= omap_control_usb_probe,
+	.driver		= {
+		.name	= "omap-control-usb",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(omap_control_usb_id_table),
+	},
+};
+
+static int __init omap_control_usb_init(void)
+{
+	return platform_driver_register(&omap_control_usb_driver);
+}
+subsys_initcall(omap_control_usb_init);
+
+static void __exit omap_control_usb_exit(void)
+{
+	platform_driver_unregister(&omap_control_usb_driver);
+}
+module_exit(omap_control_usb_exit);
+
+MODULE_ALIAS("platform: omap_control_usb");
+MODULE_AUTHOR("Texas Instruments Inc.");
+MODULE_DESCRIPTION("OMAP Control Module USB Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/usb/omap_control_usb.h b/include/linux/usb/omap_control_usb.h
new file mode 100644
index 0000000..941a43b
--- /dev/null
+++ b/include/linux/usb/omap_control_usb.h
@@ -0,0 +1,71 @@
+/*
+ * omap_control_usb.h - Header file for the USB part of control module.
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Author: Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __OMAP_CONTROL_USB_H__
+#define __OMAP_CONTROL_USB_H__
+
+struct omap_control_usb {
+	struct device *dev;
+
+	u32 __iomem *dev_conf;
+	u32 __iomem *otghs_control;
+
+	u8 has_mailbox:1;
+};
+
+struct omap_control_usb_platform_data {
+	u8 has_mailbox:1;
+};
+
+enum omap_control_usb_mode {
+	USB_MODE_UNDEFINED = 0,
+	USB_MODE_HOST,
+	USB_MODE_DEVICE,
+	USB_MODE_DISCONNECT,
+};
+
+#define	OMAP_CTRL_DEV_PHY_PD		BIT(0)
+
+#define	OMAP_CTRL_DEV_AVALID		BIT(0)
+#define	OMAP_CTRL_DEV_BVALID		BIT(1)
+#define	OMAP_CTRL_DEV_VBUSVALID		BIT(2)
+#define	OMAP_CTRL_DEV_SESSEND		BIT(3)
+#define	OMAP_CTRL_DEV_IDDIG		BIT(4)
+
+#if IS_ENABLED(CONFIG_OMAP_CONTROL_USB)
+extern struct device *omap_get_control_dev(void);
+extern void omap_control_usb_phy_power(struct device *dev, int on);
+extern void omap_control_usb_set_mode(struct device *dev,
+	enum omap_control_usb_mode mode);
+#else
+static inline struct device *omap_get_control_dev()
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline void omap_control_usb_phy_power(struct device *dev, int on)
+{
+}
+
+static inline void omap_control_usb_set_mode(struct device *dev,
+	enum omap_control_usb_mode mode)
+{
+}
+#endif
+
+#endif	/* __OMAP_CONTROL_USB_H__ */
-- 
1.7.9.5

