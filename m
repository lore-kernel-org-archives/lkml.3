Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbbATJrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:47:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55116 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbbATJrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:47:36 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/8] soc: Add MediaTek infracfg controller support
Date: Tue, 20 Jan 2015 10:47:04 +0100
Message-Id: <1421747231-554-2-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
References: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the MediaTek infracfg controller found
on the MT8135/MT8173 SoCs. The infracfg controller contains
miscellaneous registers for controlling peripheral resets and
clocks.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 .../devicetree/bindings/soc/mediatek/infracfg.txt  |  19 +++
 drivers/soc/Kconfig                                |   1 +
 drivers/soc/Makefile                               |   1 +
 drivers/soc/mediatek/Kconfig                       |  12 ++
 drivers/soc/mediatek/Makefile                      |   1 +
 drivers/soc/mediatek/mtk-infracfg.c                | 127 ++++++++++++++++++++
 drivers/soc/mediatek/mtk-pericfg.c                 | 128 +++++++++++++++++++++
 7 files changed, 289 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/infracfg.txt
 create mode 100644 drivers/soc/mediatek/Kconfig
 create mode 100644 drivers/soc/mediatek/Makefile
 create mode 100644 drivers/soc/mediatek/mtk-infracfg.c
 create mode 100644 drivers/soc/mediatek/mtk-pericfg.c

diff --git a/Documentation/devicetree/bindings/soc/mediatek/infracfg.txt b/Documentation/devicetree/bindings/soc/mediatek/infracfg.txt
new file mode 100644
index 0000000..042083a
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/mediatek/infracfg.txt
@@ -0,0 +1,19 @@
+MediaTek infracfg Controller
+
+The infracfg controller contains miscellaneous registers for controlling
+clocks, resets and bus settings.
+
+Required properties:
+- compatible: must be one of:
+	mediatek,mt8135-infracfg
+	mediatek,mt8173-infracfg
+- reg: Address range for the infracfg controller
+
+Example:
+
+	infracfg: infracfg@10003000 {
+		#reset-cells = <1>;
+		#clock-cells = <1>;
+		compatible = "mediatek,mt8135-infracfg";
+		reg = <0 0x10003000 0 0x1000>;
+	};
diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
index 76d6bd4..d8bde82f0 100644
--- a/drivers/soc/Kconfig
+++ b/drivers/soc/Kconfig
@@ -1,5 +1,6 @@
 menu "SOC (System On Chip) specific Drivers"
 
+source "drivers/soc/mediatek/Kconfig"
 source "drivers/soc/qcom/Kconfig"
 source "drivers/soc/ti/Kconfig"
 source "drivers/soc/versatile/Kconfig"
diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
index 063113d..70042b2 100644
--- a/drivers/soc/Makefile
+++ b/drivers/soc/Makefile
@@ -2,6 +2,7 @@
 # Makefile for the Linux Kernel SOC specific device drivers.
 #
 
+obj-$(CONFIG_ARCH_MEDIATEK)	+= mediatek/
 obj-$(CONFIG_ARCH_QCOM)		+= qcom/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_SOC_TI)		+= ti/
diff --git a/drivers/soc/mediatek/Kconfig b/drivers/soc/mediatek/Kconfig
new file mode 100644
index 0000000..3ad39fe
--- /dev/null
+++ b/drivers/soc/mediatek/Kconfig
@@ -0,0 +1,12 @@
+#
+# MediaTek SoC drivers
+#
+config MTK_INFRACFG
+	tristate "MediaTek infracfg controller support"
+	depends on ARCH_MEDIATEK || COMPILE_TEST
+	select REGMAP
+	help
+	  The MediaTek infracfg controller found on MT8135 and MT8173 SoCs
+	  contains several miscellaneous registers for clock, reset and bus
+	  settings. Say yes here if you want to run your kernel on one of these
+	  SoCs.
diff --git a/drivers/soc/mediatek/Makefile b/drivers/soc/mediatek/Makefile
new file mode 100644
index 0000000..dbeb627
--- /dev/null
+++ b/drivers/soc/mediatek/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_MTK_INFRACFG) += mtk-infracfg.o
diff --git a/drivers/soc/mediatek/mtk-infracfg.c b/drivers/soc/mediatek/mtk-infracfg.c
new file mode 100644
index 0000000..3bbd39b
--- /dev/null
+++ b/drivers/soc/mediatek/mtk-infracfg.c
@@ -0,0 +1,127 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/reset-controller.h>
+
+struct mtk_infracfg {
+	struct regmap *regmap;
+	struct reset_controller_dev rcdev;
+};
+
+static int mtk_infracfg_reset_assert(struct reset_controller_dev *rcdev,
+			      unsigned long id)
+{
+	struct mtk_infracfg *data = container_of(rcdev, struct mtk_infracfg, rcdev);
+
+	return regmap_update_bits(data->regmap, 0x30 + ((id / 32) << 2), BIT(id % 32), ~0u);
+}
+
+static int mtk_infracfg_reset_deassert(struct reset_controller_dev *rcdev,
+				unsigned long id)
+{
+	struct mtk_infracfg *data = container_of(rcdev, struct mtk_infracfg, rcdev);
+
+	return regmap_update_bits(data->regmap, 0x30 + ((id / 32) << 2), BIT(id % 32), 0);
+}
+
+static int mtk_infracfg_reset(struct reset_controller_dev *rcdev,
+			      unsigned long id)
+{
+	int ret;
+
+	ret = mtk_infracfg_reset_assert(rcdev, id);
+	if (ret)
+		return ret;
+
+	return mtk_infracfg_reset_deassert(rcdev, id);
+}
+
+static struct reset_control_ops mtk_infracfg_reset_ops = {
+	.assert = mtk_infracfg_reset_assert,
+	.deassert = mtk_infracfg_reset_deassert,
+	.reset = mtk_infracfg_reset,
+};
+
+static struct regmap_config mtk_infracfg_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+};
+
+static int mtk_infracfg_probe(struct platform_device *pdev)
+{
+	struct mtk_infracfg *data;
+	struct resource *res;
+	void __iomem *base;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	data->regmap = devm_regmap_init_mmio(&pdev->dev, base,
+                                        &mtk_infracfg_regmap_config);
+	if (IS_ERR(data->regmap))
+		return PTR_ERR(data->regmap);
+
+	data->rcdev.owner = THIS_MODULE;
+	data->rcdev.nr_resets = 64;
+	data->rcdev.ops = &mtk_infracfg_reset_ops;
+	data->rcdev.of_node = pdev->dev.of_node;
+
+	return reset_controller_register(&data->rcdev);
+}
+
+static int mtk_infracfg_remove(struct platform_device *pdev)
+{
+	struct mtk_infracfg *data = platform_get_drvdata(pdev);
+
+	reset_controller_unregister(&data->rcdev);
+
+	return 0;
+}
+
+static const struct of_device_id mtk_infracfg_dt_ids[] = {
+	{
+		.compatible = "mediatek,mt8173-infracfg",
+	}, {
+		.compatible = "mediatek,mt8135-infracfg",
+	}, {
+		/* sentinel */
+	},
+};
+MODULE_DEVICE_TABLE(of, mtk_infracfg_dt_ids);
+
+static struct platform_driver mtk_infracfg_driver = {
+	.probe = mtk_infracfg_probe,
+	.remove = mtk_infracfg_remove,
+	.driver = {
+		.name = "mtk-infracfg",
+		.of_match_table = mtk_infracfg_dt_ids,
+	},
+};
+
+module_platform_driver(mtk_infracfg_driver);
+
+MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
+MODULE_DESCRIPTION("MediaTek infracfg controller");
+MODULE_LICENSE("GPL");
diff --git a/drivers/soc/mediatek/mtk-pericfg.c b/drivers/soc/mediatek/mtk-pericfg.c
new file mode 100644
index 0000000..b7ee902
--- /dev/null
+++ b/drivers/soc/mediatek/mtk-pericfg.c
@@ -0,0 +1,128 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ * Author: Flora Fu <flora.fu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/reset-controller.h>
+
+struct mtk_pericfg {
+	struct regmap *regmap;
+	struct reset_controller_dev rcdev;
+};
+
+static int mtk_pericfg_reset_assert(struct reset_controller_dev *rcdev,
+			      unsigned long id)
+{
+	struct mtk_pericfg *data = container_of(rcdev, struct mtk_pericfg, rcdev);
+
+	return regmap_update_bits(data->regmap, (id / 32) << 2, BIT(id % 32), ~0);
+}
+
+static int mtk_pericfg_reset_deassert(struct reset_controller_dev *rcdev,
+				unsigned long id)
+{
+	struct mtk_pericfg *data = container_of(rcdev, struct mtk_pericfg, rcdev);
+
+	return regmap_update_bits(data->regmap, (id / 32) << 2, BIT(id % 32), 0);
+}
+
+static int mtk_pericfg_reset(struct reset_controller_dev *rcdev,
+			      unsigned long id)
+{
+	int ret;
+
+	ret = mtk_pericfg_reset_assert(rcdev, id);
+	if (ret)
+		return ret;
+
+	return mtk_pericfg_reset_deassert(rcdev, id);
+}
+
+static struct reset_control_ops mtk_pericfg_reset_ops = {
+	.assert = mtk_pericfg_reset_assert,
+	.deassert = mtk_pericfg_reset_deassert,
+	.reset = mtk_pericfg_reset,
+};
+
+static struct regmap_config mtk_pericfg_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+};
+
+static int mtk_pericfg_probe(struct platform_device *pdev)
+{
+	struct mtk_pericfg *data;
+	struct resource *res;
+	void __iomem *base;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	data->regmap = devm_regmap_init_mmio(&pdev->dev, base,
+                                        &mtk_pericfg_regmap_config);
+	if (IS_ERR(data->regmap))
+		return PTR_ERR(data->regmap);
+
+	data->rcdev.owner = THIS_MODULE;
+	data->rcdev.nr_resets = 64;
+	data->rcdev.ops = &mtk_pericfg_reset_ops;
+	data->rcdev.of_node = pdev->dev.of_node;
+
+	return reset_controller_register(&data->rcdev);
+}
+
+static int mtk_pericfg_remove(struct platform_device *pdev)
+{
+	struct mtk_pericfg *data = platform_get_drvdata(pdev);
+
+	reset_controller_unregister(&data->rcdev);
+
+	return 0;
+}
+
+static const struct of_device_id mtk_pericfg_dt_ids[] = {
+	{
+		.compatible = "mediatek,mt8173-pericfg",
+	}, {
+		.compatible = "mediatek,mt8135-pericfg",
+	}, {
+		/* sentinel */
+	},
+};
+MODULE_DEVICE_TABLE(of, mtk_pericfg_dt_ids);
+
+static struct platform_driver mtk_pericfg_driver = {
+	.probe = mtk_pericfg_probe,
+	.remove = mtk_pericfg_remove,
+	.driver = {
+		.name = "mtk-pericfg",
+		.of_match_table = mtk_pericfg_dt_ids,
+	},
+};
+
+module_platform_driver(mtk_pericfg_driver);
+
+MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
+MODULE_DESCRIPTION("MediaTek pericfg controller");
+MODULE_LICENSE("GPL");
-- 
2.1.4

