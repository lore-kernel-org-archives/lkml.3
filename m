Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab3IBPoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:44:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44522 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab3IBPov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:44:51 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rogerq@ti.com>, <kishon@ti.com>, <balbi@ti.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] drivers: phy: renamed struct omap_control_usb to struct omap_control_phy
Date: Mon, 2 Sep 2013 21:13:11 +0530
Message-ID: <1378136591-7463-8-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1378136591-7463-1-git-send-email-kishon@ti.com>
References: <1378136591-7463-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

renamed struct omap_control_usb to struct omap_control_phy since it can
be used to control PHY of USB, SATA and PCIE. Also moved the driver and
include files under *phy* and made the corresponding changes in the users
of phy-omap-control.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig                                |   14 +-
 drivers/phy/Makefile                               |    1 +
 drivers/{usb => }/phy/phy-omap-control.c           |  164 ++++++++++----------
 drivers/phy/phy-omap-pipe3.c                       |    8 +-
 drivers/phy/phy-omap-usb2.c                        |    8 +-
 drivers/usb/musb/omap2430.c                        |    2 +-
 drivers/usb/phy/Makefile                           |    1 -
 .../omap_control_usb.h => phy/omap_control_phy.h}  |   32 ++--
 8 files changed, 120 insertions(+), 110 deletions(-)
 rename drivers/{usb => }/phy/phy-omap-control.c (55%)
 rename include/linux/{usb/omap_control_usb.h => phy/omap_control_phy.h} (69%)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 5c2e7a0..fd11294 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -15,12 +15,22 @@ config GENERIC_PHY
 	  phy users can obtain reference to the PHY. All the users of this
 	  framework should select this config.
 
+config OMAP_CONTROL_PHY
+	tristate "OMAP CONTROL PHY Driver"
+	depends on ARCH_OMAP2PLUS || COMPILE_TEST
+	help
+	  Enable this to add support for the PHY part present in the control
+	  module. This driver has API to power on the USB2 PHY and to write to
+	  the mailbox. The mailbox is present only in omap4 and the register to
+	  power on the USB2 PHY is present in OMAP4 and OMAP5. OMAP5 has
+	  additional registers to power on PIPE3 PHYs.
+
 config OMAP_USB2
 	tristate "OMAP USB2 PHY Driver"
 	depends on ARCH_OMAP2PLUS
 	select GENERIC_PHY
 	select USB_PHY
-	select OMAP_CONTROL_USB
+	select OMAP_CONTROL_PHY
 	help
 	  Enable this to support the transceiver that is part of SOC. This
 	  driver takes care of all the PHY functionality apart from comparator.
@@ -30,7 +40,7 @@ config OMAP_USB2
 config OMAP_PIPE3
 	tristate "OMAP PIPE3 PHY Driver"
 	select GENERIC_PHY
-	select OMAP_CONTROL_USB
+	select OMAP_CONTROL_PHY
 	help
 	  Enable this to support the PIPE3 PHY that is part of SOC. This
 	  driver takes care of all the PHY functionality apart from comparator.
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 48bf9f2..f0127f6 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
+obj-$(CONFIG_OMAP_CONTROL_PHY)	+= phy-omap-control.o
 obj-$(CONFIG_OMAP_USB2)		+= phy-omap-usb2.o
 obj-$(CONFIG_OMAP_PIPE3)	+= phy-omap-pipe3.o
 obj-$(CONFIG_TWL4030_USB)	+= phy-twl4030-usb.o
diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/phy/phy-omap-control.c
similarity index 55%
rename from drivers/usb/phy/phy-omap-control.c
rename to drivers/phy/phy-omap-control.c
index 1a7e19a..ece3573 100644
--- a/drivers/usb/phy/phy-omap-control.c
+++ b/drivers/phy/phy-omap-control.c
@@ -1,5 +1,5 @@
 /*
- * omap-control-usb.c - The USB part of control module.
+ * phy-omap-control.c - The USB part of control module.
  *
  * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
  * This program is free software; you can redistribute it and/or modify
@@ -24,36 +24,36 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/clk.h>
-#include <linux/usb/omap_control_usb.h>
+#include <linux/phy/omap_control_phy.h>
 
 /**
- * omap_control_usb_phy_power - power on/off the phy using control module reg
+ * omap_control_phy_power - power on/off the phy using control module reg
  * @dev: the control module device
  * @on: 0 or 1, based on powering on or off the PHY
  */
-void omap_control_usb_phy_power(struct device *dev, int on)
+void omap_control_phy_power(struct device *dev, int on)
 {
 	u32 val, val_aux;
 	unsigned long rate;
-	struct omap_control_usb	*control_usb;
+	struct omap_control_phy	*control_phy;
 
 	if (IS_ERR(dev) || !dev) {
 		pr_err("%s: invalid device\n", __func__);
 		return;
 	}
 
-	control_usb = dev_get_drvdata(dev);
-	if (!control_usb) {
+	control_phy = dev_get_drvdata(dev);
+	if (!control_phy) {
 		dev_err(dev, "%s: invalid control usb device\n", __func__);
 		return;
 	}
 
-	if (control_usb->type == OMAP_CTRL_TYPE_OMAP4)
+	if (control_phy->type == OMAP_CTRL_TYPE_OMAP4)
 		return;
 
-	val = readl(control_usb->power);
+	val = readl(control_phy->power);
 
-	switch (control_usb->type) {
+	switch (control_phy->type) {
 	case OMAP_CTRL_TYPE_USB2:
 		if (on)
 			val &= ~OMAP_CTRL_DEV_PHY_PD;
@@ -62,24 +62,24 @@ void omap_control_usb_phy_power(struct device *dev, int on)
 		break;
 
 	case OMAP_CTRL_TYPE_USB3:
-		rate = clk_get_rate(control_usb->sys_clk);
+		rate = clk_get_rate(control_phy->sys_clk);
 		rate = rate/1000000;
 
 		if (on) {
-			val &= ~(OMAP_CTRL_USB_PWRCTL_CLK_CMD_MASK |
-					OMAP_CTRL_USB_PWRCTL_CLK_FREQ_MASK);
-			val |= OMAP_CTRL_USB3_PHY_TX_RX_POWERON <<
-				OMAP_CTRL_USB_PWRCTL_CLK_CMD_SHIFT;
-			val |= rate << OMAP_CTRL_USB_PWRCTL_CLK_FREQ_SHIFT;
+			val &= ~(OMAP_CTRL_PIPE3_PWRCTL_CLK_CMD_MASK |
+					OMAP_CTRL_PIPE3_PWRCTL_CLK_FREQ_MASK);
+			val |= OMAP_CTRL_PIPE3_PHY_TX_RX_POWERON <<
+				OMAP_CTRL_PIPE3_PWRCTL_CLK_CMD_SHIFT;
+			val |= rate << OMAP_CTRL_PIPE3_PWRCTL_CLK_FREQ_SHIFT;
 		} else {
-			val &= ~OMAP_CTRL_USB_PWRCTL_CLK_CMD_MASK;
-			val |= OMAP_CTRL_USB3_PHY_TX_RX_POWEROFF <<
-				OMAP_CTRL_USB_PWRCTL_CLK_CMD_SHIFT;
+			val &= ~OMAP_CTRL_PIPE3_PWRCTL_CLK_CMD_MASK;
+			val |= OMAP_CTRL_PIPE3_PHY_TX_RX_POWEROFF <<
+				OMAP_CTRL_PIPE3_PWRCTL_CLK_CMD_SHIFT;
 		}
 		break;
 
 	case OMAP_CTRL_TYPE_DRA7:
-		val_aux = readl(control_usb->power_aux);
+		val_aux = readl(control_phy->power_aux);
 		if (on) {
 			val &= ~OMAP_CTRL_USB2_PHY_PD;
 			val_aux |= 0x100;
@@ -88,70 +88,70 @@ void omap_control_usb_phy_power(struct device *dev, int on)
 			val_aux &= ~0x100;
 		}
 
-		writel(val_aux, control_usb->power_aux);
+		writel(val_aux, control_phy->power_aux);
 		break;
 	default:
 		dev_err(dev, "%s: type %d not recognized\n",
-					__func__, control_usb->type);
+					__func__, control_phy->type);
 		break;
 	}
 
-	writel(val, control_usb->power);
+	writel(val, control_phy->power);
 }
-EXPORT_SYMBOL_GPL(omap_control_usb_phy_power);
+EXPORT_SYMBOL_GPL(omap_control_phy_power);
 
 /**
  * omap_control_usb_host_mode - set AVALID, VBUSVALID and ID pin in grounded
- * @ctrl_usb: struct omap_control_usb *
+ * @ctrl_phy: struct omap_control_phy *
  *
  * Writes to the mailbox register to notify the usb core that a usb
  * device has been connected.
  */
-static void omap_control_usb_host_mode(struct omap_control_usb *ctrl_usb)
+static void omap_control_usb_host_mode(struct omap_control_phy *ctrl_phy)
 {
 	u32 val;
 
-	val = readl(ctrl_usb->otghs_control);
+	val = readl(ctrl_phy->otghs_control);
 	val &= ~(OMAP_CTRL_DEV_IDDIG | OMAP_CTRL_DEV_SESSEND);
 	val |= OMAP_CTRL_DEV_AVALID | OMAP_CTRL_DEV_VBUSVALID;
-	writel(val, ctrl_usb->otghs_control);
+	writel(val, ctrl_phy->otghs_control);
 }
 
 /**
  * omap_control_usb_device_mode - set AVALID, VBUSVALID and ID pin in high
  * impedance
- * @ctrl_usb: struct omap_control_usb *
+ * @ctrl_phy: struct omap_control_phy *
  *
  * Writes to the mailbox register to notify the usb core that it has been
  * connected to a usb host.
  */
-static void omap_control_usb_device_mode(struct omap_control_usb *ctrl_usb)
+static void omap_control_usb_device_mode(struct omap_control_phy *ctrl_phy)
 {
 	u32 val;
 
-	val = readl(ctrl_usb->otghs_control);
+	val = readl(ctrl_phy->otghs_control);
 	val &= ~OMAP_CTRL_DEV_SESSEND;
 	val |= OMAP_CTRL_DEV_IDDIG | OMAP_CTRL_DEV_AVALID |
 		OMAP_CTRL_DEV_VBUSVALID;
-	writel(val, ctrl_usb->otghs_control);
+	writel(val, ctrl_phy->otghs_control);
 }
 
 /**
  * omap_control_usb_set_sessionend - Enable SESSIONEND and IDIG to high
  * impedance
- * @ctrl_usb: struct omap_control_usb *
+ * @ctrl_phy: struct omap_control_phy *
  *
  * Writes to the mailbox register to notify the usb core it's now in
  * disconnected state.
  */
-static void omap_control_usb_set_sessionend(struct omap_control_usb *ctrl_usb)
+static void omap_control_usb_set_sessionend(struct omap_control_phy *ctrl_phy)
 {
 	u32 val;
 
-	val = readl(ctrl_usb->otghs_control);
+	val = readl(ctrl_phy->otghs_control);
 	val &= ~(OMAP_CTRL_DEV_AVALID | OMAP_CTRL_DEV_VBUSVALID);
 	val |= OMAP_CTRL_DEV_IDDIG | OMAP_CTRL_DEV_SESSEND;
-	writel(val, ctrl_usb->otghs_control);
+	writel(val, ctrl_phy->otghs_control);
 }
 
 /**
@@ -166,30 +166,30 @@ static void omap_control_usb_set_sessionend(struct omap_control_usb *ctrl_usb)
 void omap_control_usb_set_mode(struct device *dev,
 	enum omap_control_usb_mode mode)
 {
-	struct omap_control_usb	*ctrl_usb;
+	struct omap_control_phy	*ctrl_phy;
 
 	if (IS_ERR(dev) || !dev)
 		return;
 
-	ctrl_usb = dev_get_drvdata(dev);
+	ctrl_phy = dev_get_drvdata(dev);
 
-	if (!ctrl_usb) {
+	if (!ctrl_phy) {
 		dev_err(dev, "Invalid control usb device\n");
 		return;
 	}
 
-	if (ctrl_usb->type != OMAP_CTRL_TYPE_OMAP4)
+	if (ctrl_phy->type != OMAP_CTRL_TYPE_OMAP4)
 		return;
 
 	switch (mode) {
 	case USB_MODE_HOST:
-		omap_control_usb_host_mode(ctrl_usb);
+		omap_control_usb_host_mode(ctrl_phy);
 		break;
 	case USB_MODE_DEVICE:
-		omap_control_usb_device_mode(ctrl_usb);
+		omap_control_usb_device_mode(ctrl_phy);
 		break;
 	case USB_MODE_DISCONNECT:
-		omap_control_usb_set_sessionend(ctrl_usb);
+		omap_control_usb_set_sessionend(ctrl_phy);
 		break;
 	default:
 		dev_vdbg(dev, "invalid omap control usb mode\n");
@@ -197,77 +197,77 @@ void omap_control_usb_set_mode(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(omap_control_usb_set_mode);
 
-static const struct of_device_id omap_control_usb_id_table[];
+static const struct of_device_id omap_control_phy_id_table[];
 
-static int omap_control_usb_probe(struct platform_device *pdev)
+static int omap_control_phy_probe(struct platform_device *pdev)
 {
 	struct resource	*res;
 	const struct of_device_id *of_id;
-	struct omap_control_usb *control_usb;
+	struct omap_control_phy *control_phy;
 
-	of_id = of_match_device(omap_control_usb_id_table, &pdev->dev);
+	of_id = of_match_device(omap_control_phy_id_table, &pdev->dev);
 	if (!of_id)
 		return -EINVAL;
 
-	control_usb = devm_kzalloc(&pdev->dev, sizeof(*control_usb),
+	control_phy = devm_kzalloc(&pdev->dev, sizeof(*control_phy),
 		GFP_KERNEL);
-	if (!control_usb) {
+	if (!control_phy) {
 		dev_err(&pdev->dev, "unable to alloc memory for control usb\n");
 		return -ENOMEM;
 	}
 
-	control_usb->dev = &pdev->dev;
-	control_usb->type = *(enum omap_control_usb_type *)of_id->data;
+	control_phy->dev = &pdev->dev;
+	control_phy->type = *(enum omap_control_phy_type *)of_id->data;
 
-	if (control_usb->type == OMAP_CTRL_TYPE_OMAP4) {
+	if (control_phy->type == OMAP_CTRL_TYPE_OMAP4) {
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 			"otghs_control");
-		control_usb->otghs_control = devm_ioremap_resource(
+		control_phy->otghs_control = devm_ioremap_resource(
 			&pdev->dev, res);
-		if (IS_ERR(control_usb->otghs_control))
-			return PTR_ERR(control_usb->otghs_control);
+		if (IS_ERR(control_phy->otghs_control))
+			return PTR_ERR(control_phy->otghs_control);
 	} else {
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 				"power");
-		control_usb->power = devm_ioremap_resource(&pdev->dev, res);
-		if (IS_ERR(control_usb->power)) {
+		control_phy->power = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(control_phy->power)) {
 			dev_err(&pdev->dev, "Couldn't get power register\n");
-			return PTR_ERR(control_usb->power);
+			return PTR_ERR(control_phy->power);
 		}
 	}
 
-	if (control_usb->type == OMAP_CTRL_TYPE_USB3) {
-		control_usb->sys_clk = devm_clk_get(control_usb->dev,
+	if (control_phy->type == OMAP_CTRL_TYPE_USB3) {
+		control_phy->sys_clk = devm_clk_get(control_phy->dev,
 			"sys_clkin");
-		if (IS_ERR(control_usb->sys_clk)) {
+		if (IS_ERR(control_phy->sys_clk)) {
 			pr_err("%s: unable to get sys_clkin\n", __func__);
 			return -EINVAL;
 		}
 	}
 
-	if (control_usb->type == OMAP_CTRL_TYPE_DRA7) {
+	if (control_phy->type == OMAP_CTRL_TYPE_DRA7) {
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 				"power_aux");
-		control_usb->power_aux = devm_ioremap_resource(&pdev->dev, res);
-		if (IS_ERR(control_usb->power_aux)) {
+		control_phy->power_aux = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(control_phy->power_aux)) {
 			dev_err(&pdev->dev, "Couldn't get power_aux register\n");
-			return PTR_ERR(control_usb->power_aux);
+			return PTR_ERR(control_phy->power_aux);
 		}
 	}
 
-	dev_set_drvdata(control_usb->dev, control_usb);
+	dev_set_drvdata(control_phy->dev, control_phy);
 
 	return 0;
 }
 
 #ifdef CONFIG_OF
 
-static const enum omap_control_usb_type omap4_data = OMAP_CTRL_TYPE_OMAP4;
-static const enum omap_control_usb_type usb2_data = OMAP_CTRL_TYPE_USB2;
-static const enum omap_control_usb_type usb3_data = OMAP_CTRL_TYPE_USB3;
-static const enum omap_control_usb_type dra7_data = OMAP_CTRL_TYPE_DRA7;
+static const enum omap_control_phy_type omap4_data = OMAP_CTRL_TYPE_OMAP4;
+static const enum omap_control_phy_type usb2_data = OMAP_CTRL_TYPE_USB2;
+static const enum omap_control_phy_type usb3_data = OMAP_CTRL_TYPE_USB3;
+static const enum omap_control_phy_type dra7_data = OMAP_CTRL_TYPE_DRA7;
 
-static const struct of_device_id omap_control_usb_id_table[] = {
+static const struct of_device_id omap_control_phy_id_table[] = {
 	{
 		.compatible = "ti,omap4-control-usb",
 		.data = &omap4_data,
@@ -286,31 +286,31 @@ static const struct of_device_id omap_control_usb_id_table[] = {
 	},
 	{},
 };
-MODULE_DEVICE_TABLE(of, omap_control_usb_id_table);
+MODULE_DEVICE_TABLE(of, omap_control_phy_id_table);
 #endif
 
-static struct platform_driver omap_control_usb_driver = {
-	.probe		= omap_control_usb_probe,
+static struct platform_driver omap_control_phy_driver = {
+	.probe		= omap_control_phy_probe,
 	.driver		= {
 		.name	= "omap-control-usb",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(omap_control_usb_id_table),
+		.of_match_table = of_match_ptr(omap_control_phy_id_table),
 	},
 };
 
-static int __init omap_control_usb_init(void)
+static int __init omap_control_phy_init(void)
 {
-	return platform_driver_register(&omap_control_usb_driver);
+	return platform_driver_register(&omap_control_phy_driver);
 }
-subsys_initcall(omap_control_usb_init);
+subsys_initcall(omap_control_phy_init);
 
-static void __exit omap_control_usb_exit(void)
+static void __exit omap_control_phy_exit(void)
 {
-	platform_driver_unregister(&omap_control_usb_driver);
+	platform_driver_unregister(&omap_control_phy_driver);
 }
-module_exit(omap_control_usb_exit);
+module_exit(omap_control_phy_exit);
 
-MODULE_ALIAS("platform: omap_control_usb");
+MODULE_ALIAS("platform: omap_control_phy");
 MODULE_AUTHOR("Texas Instruments Inc.");
 MODULE_DESCRIPTION("OMAP Control Module USB Driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/phy/phy-omap-pipe3.c b/drivers/phy/phy-omap-pipe3.c
index ee9a901..63de0f8 100644
--- a/drivers/phy/phy-omap-pipe3.c
+++ b/drivers/phy/phy-omap-pipe3.c
@@ -26,7 +26,7 @@
 #include <linux/err.h>
 #include <linux/pm_runtime.h>
 #include <linux/delay.h>
-#include <linux/usb/omap_control_usb.h>
+#include <linux/phy/omap_control_phy.h>
 #include <linux/of_platform.h>
 
 #define	PLL_STATUS		0x00000004
@@ -101,7 +101,7 @@ static int omap_pipe3_power_off(struct phy *x)
 		udelay(1);
 	} while (--timeout);
 
-	omap_control_usb_phy_power(phy->control_dev, 0);
+	omap_control_phy_power(phy->control_dev, 0);
 
 	return 0;
 }
@@ -194,7 +194,7 @@ static int omap_pipe3_init(struct phy *x)
 	if (ret)
 		return ret;
 
-	omap_control_usb_phy_power(phy->control_dev, 1);
+	omap_control_phy_power(phy->control_dev, 1);
 
 	return 0;
 }
@@ -270,7 +270,7 @@ static int omap_pipe3_probe(struct platform_device *pdev)
 
 	phy->control_dev = &control_pdev->dev;
 
-	omap_control_usb_phy_power(phy->control_dev, 0);
+	omap_control_phy_power(phy->control_dev, 0);
 
 	platform_set_drvdata(pdev, phy);
 	pm_runtime_enable(phy->dev);
diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 6c78584..d3ea81d 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -27,7 +27,7 @@
 #include <linux/err.h>
 #include <linux/pm_runtime.h>
 #include <linux/delay.h>
-#include <linux/usb/omap_control_usb.h>
+#include <linux/phy/omap_control_phy.h>
 #include <linux/of_platform.h>
 #include <linux/phy/phy.h>
 
@@ -102,7 +102,7 @@ static int omap_usb_power_off(struct phy *x)
 {
 	struct omap_usb *phy = phy_get_drvdata(x);
 
-	omap_control_usb_phy_power(phy->control_dev, 0);
+	omap_control_phy_power(phy->control_dev, 0);
 
 	return 0;
 }
@@ -111,7 +111,7 @@ static int omap_usb_power_on(struct phy *x)
 {
 	struct omap_usb *phy = phy_get_drvdata(x);
 
-	omap_control_usb_phy_power(phy->control_dev, 1);
+	omap_control_phy_power(phy->control_dev, 1);
 
 	return 0;
 }
@@ -172,7 +172,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	if (IS_ERR(phy_provider))
 		return PTR_ERR(phy_provider);
 
-	omap_control_usb_phy_power(phy->control_dev, 0);
+	omap_control_phy_power(phy->control_dev, 0);
 
 	otg->set_host		= omap_usb_set_host;
 	otg->set_peripheral	= omap_usb_set_peripheral;
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 9eab645..4f5ef0b 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -37,7 +37,7 @@
 #include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/usb/musb-omap.h>
-#include <linux/usb/omap_control_usb.h>
+#include <linux/phy/omap_control_phy.h>
 #include <linux/of_platform.h>
 
 #include "musb_core.h"
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index d1c9683..255cda9 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -12,7 +12,6 @@ obj-$(CONFIG_FSL_USB2_OTG)		+= phy-fsl-usb2.o
 obj-$(CONFIG_ISP1301_OMAP)		+= phy-isp1301-omap.o
 obj-$(CONFIG_MV_U3D_PHY)		+= phy-mv-u3d-usb.o
 obj-$(CONFIG_NOP_USB_XCEIV)		+= phy-generic.o
-obj-$(CONFIG_OMAP_CONTROL_USB)		+= phy-omap-control.o
 obj-$(CONFIG_SAMSUNG_USBPHY)		+= phy-samsung-usb.o
 obj-$(CONFIG_SAMSUNG_USB2PHY)		+= phy-samsung-usb2.o
 obj-$(CONFIG_SAMSUNG_USB3PHY)		+= phy-samsung-usb3.o
diff --git a/include/linux/usb/omap_control_usb.h b/include/linux/phy/omap_control_phy.h
similarity index 69%
rename from include/linux/usb/omap_control_usb.h
rename to include/linux/phy/omap_control_phy.h
index 8008e8d..9d6b08f 100644
--- a/include/linux/usb/omap_control_usb.h
+++ b/include/linux/phy/omap_control_phy.h
@@ -1,5 +1,5 @@
 /*
- * omap_control_usb.h - Header file for the USB part of control module.
+ * omap_control_phy.h - Header file for the USB part of control module.
  *
  * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
  * This program is free software; you can redistribute it and/or modify
@@ -16,17 +16,17 @@
  *
  */
 
-#ifndef __OMAP_CONTROL_USB_H__
-#define __OMAP_CONTROL_USB_H__
+#ifndef __OMAP_CONTROL_PHY_H__
+#define __OMAP_CONTROL_PHY_H__
 
-enum omap_control_usb_type {
+enum omap_control_phy_type {
 	OMAP_CTRL_TYPE_OMAP4 = 1,	/* Mailbox OTGHS_CONTROL */
 	OMAP_CTRL_TYPE_USB2,	/* USB2_PHY, power down in CONTROL_DEV_CONF */
 	OMAP_CTRL_TYPE_USB3,	/* USB3_PHY, DPLL & seperate Rx/Tx power */
 	OMAP_CTRL_TYPE_DRA7,	/* USB2 PHY, power and power_aux e.g. DRA7 */
 };
 
-struct omap_control_usb {
+struct omap_control_phy {
 	struct device *dev;
 
 	u32 __iomem *otghs_control;
@@ -35,7 +35,7 @@ struct omap_control_usb {
 
 	struct clk *sys_clk;
 
-	enum omap_control_usb_type type;
+	enum omap_control_phy_type type;
 };
 
 enum omap_control_usb_mode {
@@ -53,24 +53,24 @@ enum omap_control_usb_mode {
 #define	OMAP_CTRL_DEV_SESSEND		BIT(3)
 #define	OMAP_CTRL_DEV_IDDIG		BIT(4)
 
-#define	OMAP_CTRL_USB_PWRCTL_CLK_CMD_MASK	0x003FC000
-#define	OMAP_CTRL_USB_PWRCTL_CLK_CMD_SHIFT	0xE
+#define	OMAP_CTRL_PIPE3_PWRCTL_CLK_CMD_MASK	0x003FC000
+#define	OMAP_CTRL_PIPE3_PWRCTL_CLK_CMD_SHIFT	0xE
 
-#define	OMAP_CTRL_USB_PWRCTL_CLK_FREQ_MASK	0xFFC00000
-#define	OMAP_CTRL_USB_PWRCTL_CLK_FREQ_SHIFT	0x16
+#define	OMAP_CTRL_PIPE3_PWRCTL_CLK_FREQ_MASK	0xFFC00000
+#define	OMAP_CTRL_PIPE3_PWRCTL_CLK_FREQ_SHIFT	0x16
 
-#define	OMAP_CTRL_USB3_PHY_TX_RX_POWERON	0x3
-#define	OMAP_CTRL_USB3_PHY_TX_RX_POWEROFF	0x0
+#define	OMAP_CTRL_PIPE3_PHY_TX_RX_POWERON	0x3
+#define	OMAP_CTRL_PIPE3_PHY_TX_RX_POWEROFF	0x0
 
 #define OMAP_CTRL_USB2_PHY_PD		BIT(28)
 
-#if IS_ENABLED(CONFIG_OMAP_CONTROL_USB)
-extern void omap_control_usb_phy_power(struct device *dev, int on);
+#if IS_ENABLED(CONFIG_OMAP_CONTROL_PHY)
+extern void omap_control_phy_power(struct device *dev, int on);
 extern void omap_control_usb_set_mode(struct device *dev,
 	enum omap_control_usb_mode mode);
 #else
 
-static inline void omap_control_usb_phy_power(struct device *dev, int on)
+static inline void omap_control_phy_power(struct device *dev, int on)
 {
 }
 
@@ -80,4 +80,4 @@ static inline void omap_control_usb_set_mode(struct device *dev,
 }
 #endif
 
-#endif	/* __OMAP_CONTROL_USB_H__ */
+#endif	/* __OMAP_CONTROL_PHY_H__ */
-- 
1.7.10.4

