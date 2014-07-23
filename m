Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbaGWOs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:48:58 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43758 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676AbaGWOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:48:56 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        peppe.cavallaro@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org
Subject: [PATCH v3 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3 HC
Date: Wed, 23 Jul 2014 15:48:33 +0100
Message-Id: <1406126915-30601-2-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406126915-30601-1-git-send-email-peter.griffin@linaro.org>
References: <1406126915-30601-1-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
 drivers/usb/dwc3/dwc3-st.c | 338 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 348 insertions(+)
 create mode 100644 drivers/usb/dwc3/dwc3-st.c

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 8eb996e..6c85c43 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -79,6 +79,15 @@ config USB_DWC3_KEYSTONE
 	  Support of USB2/3 functionality in TI Keystone2 platforms.
 	  Say 'Y' or 'M' here if you have one such device
 
+config USB_DWC3_ST
+	tristate "STMicroelectronics Platforms"
+	depends on ARCH_STI && OF
+	default USB_DWC3_HOST
+	help
+	  STMicroelectronics SoCs with one DesignWare Core USB3 IP
+	  inside (i.e. STiH407).
+	  Say 'Y' or 'M' if you have one such device.
+
 comment "Debugging features"
 
 config USB_DWC3_DEBUG
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
index 0000000..a93ea19
--- /dev/null
+++ b/drivers/usb/dwc3/dwc3-st.c
@@ -0,0 +1,338 @@
+/**
+ * dwc3-st.c Support for dwc3 platform devices on ST Microelectronics platforms
+ *
+ * This is a small driver for the dwc3 to provide the glue logic
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
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+#include <linux/usb/of.h>
+
+#include "core.h"
+#include "io.h"
+
+/* glue registers */
+#define CLKRST_CTRL		0x00
+#define AUX_CLK_EN		BIT(0)
+#define SW_PIPEW_RESET_N	BIT(4)
+#define EXT_CFG_RESET_N		BIT(8)
+/*
+ * 1'b0 : The host controller complies with the xHCI revision 0.96
+ * 1'b1 : The host controller complies with the xHCI revision 1.0
+ */
+#define XHCI_REVISION		BIT(12)
+
+#define USB2_VBUS_MNGMNT_SEL1	0x2C
+/*
+ * For all fields in USB2_VBUS_MNGMNT_SEL1
+ * 2’b00 : Override value from Reg 0x30 is selected
+ * 2’b01 : utmiotg_<signal_name> from usb3_top is selected
+ * 2’b10 : pipew_<signal_name> from PIPEW instance is selected
+ * 2’b11 : value is 1'b0
+ */
+#define REG30	0x0
+#define UTMIOTG	0x1
+#define PIPEW	0x2
+#define ZERO	0x3
+
+#define SEL_OVERRIDE_VBUSVALID(n)	(n << 0)
+#define SEL_OVERRIDE_POWERPRESENT(n)	(n << 4)
+#define SEL_OVERRIDE_BVALID(n)		(n << 8)
+
+/* Static DRD configuration */
+#define USB_HOST_DEFAULT_MASK	0xffe
+#define USB_SET_PORT_DEVICE	0x1
+
+/**
+ * struct st_dwc3 - st-dwc3 driver private structure
+ * @dwc3:		platform device pointer
+ * @dev:		device pointer
+ * @glue_base		ioaddr for the glue registers
+ * @regmap		regmap pointer for getting syscfg
+ * @syscfg_reg_off	usb syscfg control offset
+ * @dr_mode		drd static host/device config
+ * @rstc_pwrdn		rest controller for powerdown signal
+ * @rstc_rst		reset controller for softreset signal
+ *
+ */
+
+struct st_dwc3 {
+	struct device *dev;
+	void __iomem *glue_base;
+	struct regmap *regmap;
+	int syscfg_reg_off;
+	enum usb_dr_mode dr_mode;
+	struct reset_control *rstc_pwrdn;
+	struct reset_control *rstc_rst;
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
+	int err;
+
+	err = regmap_read(dwc3_data->regmap, dwc3_data->syscfg_reg_off, &val);
+	if (err)
+		return err;
+
+	switch (dwc3_data->dr_mode) {
+	case USB_DR_MODE_PERIPHERAL:
+		val |= USB_SET_PORT_DEVICE;
+		dev_dbg(dwc3_data->dev, "Configuring as Device\n");
+		break;
+
+	case USB_DR_MODE_HOST:
+		val &= USB_HOST_DEFAULT_MASK;
+		dev_dbg(dwc3_data->dev, "Configuring as Host\n");
+		break;
+
+	default:
+		dev_err(dwc3_data->dev, "Unsupported mode of operation %d\n"
+			, dwc3_data->dr_mode);
+		return -EINVAL;
+	}
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
+
+	u32 reg = st_dwc3_readl(dwc3_data->glue_base, CLKRST_CTRL);
+
+	reg |= AUX_CLK_EN | EXT_CFG_RESET_N | XHCI_REVISION;
+	reg &= ~SW_PIPEW_RESET_N;
+	st_dwc3_writel(dwc3_data->glue_base, CLKRST_CTRL, reg);
+
+	/* configure mux for vbus, powerpresent and bvalid signals */
+	reg = st_dwc3_readl(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1);
+
+	reg |= SEL_OVERRIDE_VBUSVALID(UTMIOTG) |
+		SEL_OVERRIDE_POWERPRESENT(UTMIOTG) |
+		SEL_OVERRIDE_BVALID(UTMIOTG);
+
+	st_dwc3_writel(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1, reg);
+
+	reg = st_dwc3_readl(dwc3_data->glue_base, CLKRST_CTRL);
+	reg |= SW_PIPEW_RESET_N;
+	st_dwc3_writel(dwc3_data->glue_base, CLKRST_CTRL, reg);
+}
+
+static int st_dwc3_probe(struct platform_device *pdev)
+{
+	struct st_dwc3 *dwc3_data;
+	struct resource *res;
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node, *child;
+	struct regmap *regmap;
+	int ret;
+
+	dwc3_data = devm_kzalloc(dev, sizeof(*dwc3_data), GFP_KERNEL);
+	if (!dwc3_data)
+		return -ENOMEM;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "reg-glue");
+	dwc3_data->glue_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(dwc3_data->glue_base))
+		return PTR_ERR(dwc3_data->glue_base);
+
+	regmap = syscon_regmap_lookup_by_phandle(node, "st,syscfg");
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	dma_set_coherent_mask(dev, dev->coherent_dma_mask);
+	dwc3_data->dev = dev;
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
+	dev_dbg(&pdev->dev, "glue-logic addr 0x%p, syscfg-reg offset 0x%x\n",
+		 dwc3_data->glue_base, dwc3_data->syscfg_reg_off);
+
+	dwc3_data->rstc_pwrdn = devm_reset_control_get(dev, "powerdown");
+	if (IS_ERR(dwc3_data->rstc_pwrdn)) {
+		dev_err(&pdev->dev, "could not get power controller\n");
+		ret = PTR_ERR(dwc3_data->rstc_pwrdn);
+		goto undo_platform_dev_alloc;
+	}
+
+	/* Manage PowerDown */
+	reset_control_deassert(dwc3_data->rstc_pwrdn);
+
+	dwc3_data->rstc_rst = devm_reset_control_get(dev, "softreset");
+	if (IS_ERR(dwc3_data->rstc_rst)) {
+		dev_err(&pdev->dev, "could not get reset controller\n");
+		ret = PTR_ERR(dwc3_data->rstc_pwrdn);
+		goto undo_powerdown;
+	}
+
+	/* Manage SoftReset */
+	reset_control_deassert(dwc3_data->rstc_rst);
+
+	child = of_get_child_by_name(node, "dwc3");
+	if (!child) {
+		dev_err(&pdev->dev, "failed to find dwc3 core node\n");
+		ret = -ENODEV;
+		goto undo_softreset;
+	}
+
+	dwc3_data->dr_mode = of_usb_get_dr_mode(child);
+
+	/* Allocate and initialize the core */
+	ret = of_platform_populate(node, NULL, NULL, dev);
+	if (ret) {
+		dev_err(dev, "failed to add dwc3 core\n");
+		goto undo_softreset;
+	}
+
+	/*
+	 * Configure the USB port as device or host according to the static
+	 * configuration passed from DT.
+	 * DRD is the only mode currently supported so this will be enhanced
+	 * as soon as OTG is available.
+	 */
+	ret = st_dwc3_drd_init(dwc3_data);
+	if (ret) {
+		dev_err(dev, "drd initialisation failed\n");
+		goto undo_softreset;
+	}
+
+	/* ST glue logic init */
+	st_dwc3_init(dwc3_data);
+
+	platform_set_drvdata(pdev, dwc3_data);
+	return 0;
+
+undo_softreset:
+	reset_control_assert(dwc3_data->rstc_rst);
+undo_powerdown:
+	reset_control_assert(dwc3_data->rstc_pwrdn);
+undo_platform_dev_alloc:
+	platform_device_put(pdev);
+	return ret;
+}
+
+
+static int st_dwc3_remove_child(struct device *dev, void *c)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	of_device_unregister(pdev);
+
+	return 0;
+}
+
+static int st_dwc3_remove(struct platform_device *pdev)
+{
+	struct st_dwc3 *dwc3_data = platform_get_drvdata(pdev);
+
+	device_for_each_child(&pdev->dev, NULL, st_dwc3_remove_child);
+
+	reset_control_assert(dwc3_data->rstc_pwrdn);
+	reset_control_assert(dwc3_data->rstc_rst);
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
+	reset_control_assert(dwc3_data->rstc_rst);
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
+	reset_control_deassert(dwc3_data->rstc_rst);
+
+	return 0;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+static SIMPLE_DEV_PM_OPS(st_dwc3_dev_pm_ops, st_dwc3_suspend, st_dwc3_resume);
+
+static const struct of_device_id st_dwc3_match[] = {
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
+		.of_match_table = st_dwc3_match,
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

