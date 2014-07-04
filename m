Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbaGDLP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:15:59 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:62262 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029AbaGDLOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:14:20 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3 HC
Date: Fri,  4 Jul 2014 12:13:50 +0100
Message-Id: <1404472432-24764-2-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404472432-24764-1-git-send-email-peter.griffin@linaro.org>
References: <1404472432-24764-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ST glue logic to manage the DWC3 HC
on STiH407 SoC family. It manages the powerdown signal,
and configures the internal glue logic and syscfg registers.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/usb/dwc3/Kconfig   |   9 ++
 drivers/usb/dwc3/Makefile  |   1 +
 drivers/usb/dwc3/dwc3-st.c | 325 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 335 insertions(+)
 create mode 100644 drivers/usb/dwc3/dwc3-st.c

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 8eb996e..f7b0518 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -77,6 +77,15 @@ config USB_DWC3_KEYSTONE
 	default USB_DWC3
 	help
 	  Support of USB2/3 functionality in TI Keystone2 platforms.
+
+config USB_DWC3_ST
+	tristate "STMicroelectronics Platforms"
+	depends on ARCH_STI && OF
+	default USB_DWC3_HOST
+	help
+	  STMicroelectronics SoCs chip with one DesignWare Core USB3 IP
+	  inside (i.e. STiH407).
+
 	  Say 'Y' or 'M' here if you have one such device
 
 comment "Debugging features"
diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
index 10ac3e7..11c9f54 100644
--- a/drivers/usb/dwc3/Makefile
+++ b/drivers/usb/dwc3/Makefile
@@ -33,3 +33,4 @@ obj-$(CONFIG_USB_DWC3_OMAP)		+= dwc3-omap.o
 obj-$(CONFIG_USB_DWC3_EXYNOS)		+= dwc3-exynos.o
 obj-$(CONFIG_USB_DWC3_PCI)		+= dwc3-pci.o
 obj-$(CONFIG_USB_DWC3_KEYSTONE)		+= dwc3-keystone.o
+obj-$(CONFIG_USB_DWC3_ST)		+= dwc3-st.o
diff --git a/drivers/usb/dwc3/dwc3-st.c b/drivers/usb/dwc3/dwc3-st.c
new file mode 100644
index 0000000..80b1b8f
--- /dev/null
+++ b/drivers/usb/dwc3/dwc3-st.c
@@ -0,0 +1,325 @@
+/**
+ * dwc3-st.c Support for dwc3 platform devices on ST Microelectronics platforms
+ *
+ * This is a small platform driver for the dwc3 to provide the glue logic
+ * to configure the controller. Tested on STi platforms.
+ *
+ * Copyright (C) 2014 Stmicroelectronics
+ *
+ * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
+ * Contributors: Aymen Bouattay <aymen.bouattay@st.com>
+ *               Peter Griffin <peter.griffin@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Inspired by dwc3-omap.c and dwc3-exynos.c.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/mfd/syscon.h>
+#include <linux/delay.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+
+#include "core.h"
+#include "io.h"
+
+/* Reg glue registers */
+#define USB2_CLKRST_CTRL 0x00
+#define aux_clk_en(n) ((n)<<0)
+#define sw_pipew_reset_n(n) ((n)<<4)
+#define ext_cfg_reset_n(n) ((n)<<8)
+#define xhci_revision(n) ((n)<<12)
+
+#define USB2_VBUS_MNGMNT_SEL1 0x2C
+/*
+ * 2'b00 : Override value from Reg 0x30 is selected
+ * 2'b01 : utmiotg_vbusvalid from usb3_top top is selected
+ * 2'b10 : pipew_powerpresent from PIPEW instance is selected
+ * 2'b11 : value is 1'b0
+ */
+#define SEL_OVERRIDE_VBUSVALID(n) ((n)<<0)
+#define SEL_OVERRIDE_POWERPRESENT(n) ((n)<<4)
+#define SEL_OVERRIDE_BVALID(n) ((n)<<8)
+
+#define USB2_VBUS_MNGMNT_VAL1 0x30
+#define OVERRIDE_VBUSVALID_VAL (1 << 0)
+#define OVERRIDE_POWERPRESENT_VAL (1 << 4)
+#define OVERRIDE_BVALID_VAL (1 << 8)
+
+/* Static DRD configuration */
+#define USB_HOST_DEFAULT_MASK	0xffe
+#define USB_SET_PORT_DEVICE	0x1
+
+struct st_dwc3 {
+	struct platform_device *dwc3;	/* platform device pointer */
+	struct device *dev;	/* device pointer */
+	void __iomem *glue_base;	/* ioaddr for programming the glue */
+	struct regmap *regmap;	/* regmap for getting syscfg */
+	int syscfg_reg_off;	/* usb syscfg control offset */
+	bool drd_device_conf;	/* DRD static host/device conf */
+	struct reset_control *rstc_pwrdn;/* Rst control for powerdown*/
+};
+
+static inline u32 st_dwc3_readl(void __iomem *base, u32 offset)
+{
+	return readl_relaxed(base + offset);
+}
+
+static inline void st_dwc3_writel(void __iomem *base, u32 offset, u32 value)
+{
+	writel_relaxed(value, base + offset);
+}
+
+/**
+ * st_dwc3_drd_init: program the port
+ * @dwc3_data: driver private structure
+ * Description: this function is to program the port as either host or device
+ * according to the static configuration passed from devicetree.
+ * OTG and dual role are not yet supported!
+ */
+static int st_dwc3_drd_init(struct st_dwc3 *dwc3_data)
+{
+	u32 val;
+
+	regmap_read(dwc3_data->regmap, dwc3_data->syscfg_reg_off, &val);
+
+	if (dwc3_data->drd_device_conf)
+		val |= USB_SET_PORT_DEVICE;
+	else
+		val &= USB_HOST_DEFAULT_MASK;
+
+	return regmap_write(dwc3_data->regmap, dwc3_data->syscfg_reg_off, val);
+}
+
+/**
+ * st_dwc3_init: init the controller via glue logic
+ * @dwc3_data: driver private structure
+ */
+static void st_dwc3_init(struct st_dwc3 *dwc3_data)
+{
+	u32 reg = st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
+
+	reg |= aux_clk_en(1) | ext_cfg_reset_n(1) | xhci_revision(1);
+	reg &= ~sw_pipew_reset_n(1);
+	st_dwc3_writel(dwc3_data->glue_base, USB2_CLKRST_CTRL, reg);
+
+	reg = st_dwc3_readl(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1);
+	reg |= SEL_OVERRIDE_VBUSVALID(1) | SEL_OVERRIDE_POWERPRESENT(1) |
+	    SEL_OVERRIDE_BVALID(1);
+	st_dwc3_writel(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1, reg);
+	udelay(100);
+
+	reg = st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
+	reg |= sw_pipew_reset_n(1);
+	st_dwc3_writel(dwc3_data->glue_base, USB2_CLKRST_CTRL, reg);
+}
+
+static void st_dwc3_dt_get_pdata(struct platform_device *pdev,
+				 struct st_dwc3 *dwc3_data)
+{
+	struct device_node *np = pdev->dev.of_node;
+
+	dwc3_data->drd_device_conf =
+	    of_property_read_bool(np, "st,dwc3-drd-device");
+}
+
+/**
+ * st_dwc3_probe: main probe function
+ * @pdev: platform_device
+ * Description: this is the probe function that gets all the resources to manage
+ * the glue-logic, setup the controller and take out of powerdown.
+ */
+static int st_dwc3_probe(struct platform_device *pdev)
+{
+	struct platform_device *dwc3;
+	struct st_dwc3 *dwc3_data;
+	struct resource *res;
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct regmap *regmap;
+	int ret = 0;
+
+	if (!node) {
+		dev_err(dev, "device node not found\n");
+		return -EINVAL;
+	}
+
+	dwc3_data = devm_kzalloc(dev, sizeof(*dwc3_data), GFP_KERNEL);
+	if (!dwc3_data)
+		return -ENOMEM;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "reg-glue");
+	if (!res)
+		return -ENXIO;
+
+	dwc3_data->glue_base = devm_request_and_ioremap(dev, res);
+	if (!dwc3_data->glue_base)
+		return -EADDRNOTAVAIL;
+
+	regmap = syscon_regmap_lookup_by_phandle(node, "st,syscfg");
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	dwc3 = platform_device_alloc("st-dwc3", PLATFORM_DEVID_AUTO);
+	if (!dwc3) {
+		dev_err(&pdev->dev, "couldn't allocate dwc3 device\n");
+		return -ENOMEM;
+	}
+
+	dma_set_coherent_mask(&dwc3->dev, dev->coherent_dma_mask);
+
+	dwc3->dev.parent = &pdev->dev;
+	dwc3->dev.dma_mask = pdev->dev.dma_mask;
+	dwc3->dev.dma_parms = pdev->dev.dma_parms;
+
+	dwc3_data->dwc3 = dwc3;
+	dwc3_data->dev = &pdev->dev;
+	dwc3_data->regmap = regmap;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "syscfg-reg");
+	if (!res) {
+		ret = -ENXIO;
+		goto undo_platform_dev_alloc;
+	}
+
+	dwc3_data->syscfg_reg_off = res->start;
+
+	dev_info(&pdev->dev, "glue-logic addr 0x%p, syscfg-reg offset 0x%x\n",
+		 dwc3_data->glue_base, dwc3_data->syscfg_reg_off);
+
+	dwc3_data->rstc_pwrdn = devm_reset_control_get(dwc3_data->dev, NULL);
+	if (IS_ERR(dwc3_data->rstc_pwrdn)) {
+		dev_err(&pdev->dev, "could not get reset controller\n");
+		ret = PTR_ERR(dwc3_data->rstc_pwrdn);
+		goto undo_platform_dev_alloc;
+	}
+
+	/* Manage PowerDown */
+	reset_control_deassert(dwc3_data->rstc_pwrdn);
+
+	st_dwc3_dt_get_pdata(pdev, dwc3_data);
+
+	/* Allocate and initialize the core */
+	ret = of_platform_populate(node, NULL, NULL, dev);
+	if (ret) {
+		dev_err(dev, "failed to add dwc3 core\n");
+		goto undo_powerdown;
+	}
+
+	/* 
+	 * Configure the USB port as device or host according to the static
+	 * configuration passed from the platform.
+	 * DRD is the only mode currently supported so this will be enhanced
+	 * later as soon as OTG will be available.
+	 */
+	ret = st_dwc3_drd_init(dwc3_data);
+	if (ret) {
+		dev_err(dev, "st_dwc3_drd_init failed\n");
+		goto undo_powerdown;
+	}
+
+	dev_info(&pdev->dev, "configured as %s DRD\n",
+		 dwc3_data->drd_device_conf ? "device" : "host");
+
+	/* ST glue logic init */
+	st_dwc3_init(dwc3_data);
+
+	ret = platform_device_add_resources(dwc3_data->dwc3, pdev->resource,
+					    pdev->num_resources);
+	if (ret) {
+		dev_err(&pdev->dev, "couldn't add resources to dwc3 device\n");
+		goto undo_powerdown;
+	}
+
+	ret = platform_device_add(dwc3_data->dwc3);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register dwc3 device\n");
+		goto undo_powerdown;
+	}
+
+	platform_set_drvdata(pdev, dwc3_data);
+
+	return 0;
+
+undo_powerdown:
+	reset_control_assert(dwc3_data->rstc_pwrdn);
+undo_platform_dev_alloc:
+	platform_device_put(pdev);
+
+	return ret;
+
+}
+
+static int st_dwc3_remove(struct platform_device *pdev)
+{
+	struct st_dwc3 *dwc3_data = platform_get_drvdata(pdev);
+
+	platform_device_unregister(dwc3_data->dwc3);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int st_dwc3_suspend(struct device *dev)
+{
+	struct st_dwc3 *dwc3_data = dev_get_drvdata(dev);
+
+	reset_control_assert(dwc3_data->rstc_pwrdn);
+
+	pinctrl_pm_select_sleep_state(dev);
+
+	return 0;
+}
+
+static int st_dwc3_resume(struct device *dev)
+{
+	struct st_dwc3 *dwc3_data = dev_get_drvdata(dev);
+
+	pinctrl_pm_select_default_state(dev);
+
+	reset_control_deassert(dwc3_data->rstc_pwrdn);
+
+	return 0;
+}
+
+#endif /* CONFIG_PM_SLEEP */
+
+static const struct dev_pm_ops st_dwc3_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(st_dwc3_suspend, st_dwc3_resume)
+};
+
+static struct of_device_id st_dwc3_match[] = {
+	{ .compatible = "st,stih407-dwc3" },
+	{ /* sentinel */ },
+};
+
+MODULE_DEVICE_TABLE(of, st_dwc3_match);
+
+static struct platform_driver st_dwc3_driver = {
+	.probe = st_dwc3_probe,
+	.remove = st_dwc3_remove,
+	.driver = {
+		.name = "usb-st-dwc3",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(st_dwc3_match),
+		.pm = &st_dwc3_dev_pm_ops,
+	},
+};
+
+module_platform_driver(st_dwc3_driver);
+
+MODULE_AUTHOR("Giuseppe Cavallaro <peppe.cavallaro@st.com>");
+MODULE_DESCRIPTION("DesignWare USB3 STi Glue Layer");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

