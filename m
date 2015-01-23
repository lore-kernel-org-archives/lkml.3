Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbbAWOKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:10:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52279 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbbAWOKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:10:15 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?q?Yingjoe=20Chen=20=28=E9=99=B3=E8=8B=B1=E6=B4=B2=29?= 
	<Yingjoe.Chen@mediatek.com>,
        Henry Chen <henryc.chen@mediatek.com>,
        =?UTF-8?q?YH=20Chen=20=28=E9=99=B3=E6=98=B1=E8=B1=AA=29?= 
	<yh.chen@mediatek.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/7] soc: Add MediaTek pericfg controller support
Date: Fri, 23 Jan 2015 15:09:57 +0100
Message-Id: <1422022202-7526-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422022202-7526-1-git-send-email-s.hauer@pengutronix.de>
References: <1422022202-7526-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the MediaTek pericfg controller found
on the MT8135/MT8173 SoCs. The pericfg controller contains
miscellaneous registers for controlling peripheral resets and
clocks.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 .../devicetree/bindings/soc/mediatek/pericfg.txt   |  29 +++++
 drivers/soc/mediatek/Kconfig                       |  10 ++
 drivers/soc/mediatek/Makefile                      |   1 +
 drivers/soc/mediatek/mtk-pericfg.c                 | 127 +++++++++++++++++++++
 4 files changed, 167 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/pericfg.txt
 create mode 100644 drivers/soc/mediatek/mtk-pericfg.c

diff --git a/Documentation/devicetree/bindings/soc/mediatek/pericfg.txt b/Documentation/devicetree/bindings/soc/mediatek/pericfg.txt
new file mode 100644
index 0000000..3996e171
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/mediatek/pericfg.txt
@@ -0,0 +1,29 @@
+MediaTek pericfg Controller
+===========================
+
+The pericfg controller contains miscellaneous registers for controlling
+clocks, resets and bus settings.
+
+Required properties:
+- compatible: must be one of:
+	mediatek,mt8135-pericfg
+	mediatek,mt8173-pericfg
+- reg: Address range for the pericfg controller
+- #reset-cells: 1, see below
+
+Specifying reset lines connected to the pericfg controller
+==========================================================
+
+The infracfg controller provides various reset sources to other modules.
+Device nodes using these reset sources should specify the reset lines in
+a property containing a phandle to the infracfg node and a reset index.
+See include/dt-bindings/reset-controller/<soc>-resets.h for a list of valid
+indices.
+
+Example:
+
+	pericfg: pericfg@10003000 {
+		#reset-cells = <1>;
+		compatible = "mediatek,mt8135-pericfg";
+		reg = <0 0x10003000 0 0x1000>;
+	};
diff --git a/drivers/soc/mediatek/Kconfig b/drivers/soc/mediatek/Kconfig
index 3ad39fe..9bdb88f 100644
--- a/drivers/soc/mediatek/Kconfig
+++ b/drivers/soc/mediatek/Kconfig
@@ -10,3 +10,13 @@ config MTK_INFRACFG
 	  contains several miscellaneous registers for clock, reset and bus
 	  settings. Say yes here if you want to run your kernel on one of these
 	  SoCs.
+
+config MTK_PERICFG
+	tristate "MediaTek pericfg controller support"
+	depends on ARCH_MEDIATEK || COMPILE_TEST
+	select REGMAP
+	help
+	  The MediaTek pericfg controller found on MT8135 and MT8173 SoCs
+	  contains several miscellaneous registers for clock, reset and bus
+	  settings. Say yes here if you want to run your kernel on one of these
+	  SoCs.
diff --git a/drivers/soc/mediatek/Makefile b/drivers/soc/mediatek/Makefile
index dbeb627..e67be7c 100644
--- a/drivers/soc/mediatek/Makefile
+++ b/drivers/soc/mediatek/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_MTK_INFRACFG) += mtk-infracfg.o
+obj-$(CONFIG_MTK_PERICFG) += mtk-pericfg.o
diff --git a/drivers/soc/mediatek/mtk-pericfg.c b/drivers/soc/mediatek/mtk-pericfg.c
new file mode 100644
index 0000000..aa9a7eb
--- /dev/null
+++ b/drivers/soc/mediatek/mtk-pericfg.c
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

