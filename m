Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaCVA7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 20:59:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43966 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaCVA7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 20:59:44 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] clk: qcom: Consolidate common probe code
Date: Fri, 21 Mar 2014 17:59:37 -0700
Message-Id: <1395449977-2401-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the probe code is the same between all the different
clock controllers. Consolidate the code into a common.c file.
This makes changes to the common probe parts easier and reduces
chances for bugs.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Makefile       |  1 +
 drivers/clk/qcom/common.c       | 99 +++++++++++++++++++++++++++++++++++++++++
 drivers/clk/qcom/common.h       | 34 ++++++++++++++
 drivers/clk/qcom/gcc-msm8660.c  | 87 +++++-------------------------------
 drivers/clk/qcom/gcc-msm8960.c  | 77 +++++---------------------------
 drivers/clk/qcom/gcc-msm8974.c  | 77 +++++---------------------------
 drivers/clk/qcom/mmcc-msm8960.c | 78 +++++---------------------------
 drivers/clk/qcom/mmcc-msm8974.c | 80 +++++++--------------------------
 8 files changed, 196 insertions(+), 337 deletions(-)
 create mode 100644 drivers/clk/qcom/common.c
 create mode 100644 drivers/clk/qcom/common.h

diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index f60db2ef1aee..689e05bf4f95 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_COMMON_CLK_QCOM) += clk-qcom.o
 
+clk-qcom-y += common.o
 clk-qcom-y += clk-regmap.o
 clk-qcom-y += clk-pll.o
 clk-qcom-y += clk-rcg.o
diff --git a/drivers/clk/qcom/common.c b/drivers/clk/qcom/common.c
new file mode 100644
index 000000000000..86b45fba5f90
--- /dev/null
+++ b/drivers/clk/qcom/common.c
@@ -0,0 +1,99 @@
+/*
+ * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/export.h>
+#include <linux/regmap.h>
+#include <linux/platform_device.h>
+#include <linux/clk-provider.h>
+#include <linux/reset-controller.h>
+
+#include "common.h"
+#include "clk-regmap.h"
+#include "reset.h"
+
+struct qcom_cc {
+	struct qcom_reset_controller reset;
+	struct clk_onecell_data data;
+	struct clk *clks[];
+};
+
+int qcom_cc_probe(struct platform_device *pdev, const struct qcom_cc_desc *desc)
+{
+	void __iomem *base;
+	struct resource *res;
+	int i, ret;
+	struct device *dev = &pdev->dev;
+	struct clk *clk;
+	struct clk_onecell_data *data;
+	struct clk **clks;
+	struct regmap *regmap;
+	struct qcom_reset_controller *reset;
+	struct qcom_cc *cc;
+	size_t num_clks = desc->num_clks;
+	struct clk_regmap **rclks = desc->clks;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	regmap = devm_regmap_init_mmio(dev, base, desc->config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	cc = devm_kzalloc(dev, sizeof(*cc) + sizeof(*clks) * num_clks,
+			  GFP_KERNEL);
+	if (!cc)
+		return -ENOMEM;
+
+	clks = cc->clks;
+	data = &cc->data;
+	data->clks = clks;
+	data->clk_num = num_clks;
+
+	for (i = 0; i < num_clks; i++) {
+		if (!rclks[i])
+			continue;
+		clk = devm_clk_register_regmap(dev, rclks[i]);
+		if (IS_ERR(clk))
+			return PTR_ERR(clk);
+		clks[i] = clk;
+	}
+
+	ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get, data);
+	if (ret)
+		return ret;
+
+	reset = &cc->reset;
+	reset->rcdev.of_node = dev->of_node;
+	reset->rcdev.ops = &qcom_reset_ops;
+	reset->rcdev.owner = dev->driver->owner;
+	reset->rcdev.nr_resets = desc->num_resets;
+	reset->regmap = regmap;
+	reset->reset_map = desc->resets;
+	platform_set_drvdata(pdev, &reset->rcdev);
+
+	ret = reset_controller_register(&reset->rcdev);
+	if (ret)
+		of_clk_del_provider(dev->of_node);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(qcom_cc_probe);
+
+void qcom_cc_remove(struct platform_device *pdev)
+{
+	of_clk_del_provider(pdev->dev.of_node);
+	reset_controller_unregister(platform_get_drvdata(pdev));
+}
+EXPORT_SYMBOL_GPL(qcom_cc_remove);
diff --git a/drivers/clk/qcom/common.h b/drivers/clk/qcom/common.h
new file mode 100644
index 000000000000..2c3cfc860348
--- /dev/null
+++ b/drivers/clk/qcom/common.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef __QCOM_CLK_COMMON_H__
+#define __QCOM_CLK_COMMON_H__
+
+struct platform_device;
+struct regmap_config;
+struct clk_regmap;
+struct qcom_reset_map;
+
+struct qcom_cc_desc {
+	const struct regmap_config *config;
+	struct clk_regmap **clks;
+	size_t num_clks;
+	const struct qcom_reset_map *resets;
+	size_t num_resets;
+};
+
+extern int qcom_cc_probe(struct platform_device *pdev,
+			 const struct qcom_cc_desc *desc);
+
+extern void qcom_cc_remove(struct platform_device *pdev);
+
+#endif
diff --git a/drivers/clk/qcom/gcc-msm8660.c b/drivers/clk/qcom/gcc-msm8660.c
index bc0b7f1fcfbe..44bc6fa64d78 100644
--- a/drivers/clk/qcom/gcc-msm8660.c
+++ b/drivers/clk/qcom/gcc-msm8660.c
@@ -25,6 +25,7 @@
 #include <dt-bindings/clock/qcom,gcc-msm8660.h>
 #include <dt-bindings/reset/qcom,gcc-msm8660.h>
 
+#include "common.h"
 #include "clk-regmap.h"
 #include "clk-pll.h"
 #include "clk-rcg.h"
@@ -2701,94 +2702,28 @@ static const struct regmap_config gcc_msm8660_regmap_config = {
 	.fast_io	= true,
 };
 
+static const struct qcom_cc_desc gcc_msm8660_desc = {
+	.config = &gcc_msm8660_regmap_config,
+	.clks = gcc_msm8660_clks,
+	.num_clks = ARRAY_SIZE(gcc_msm8660_clks),
+	.resets = gcc_msm8660_resets,
+	.num_resets = ARRAY_SIZE(gcc_msm8660_resets),
+};
+
 static const struct of_device_id gcc_msm8660_match_table[] = {
 	{ .compatible = "qcom,gcc-msm8660" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, gcc_msm8660_match_table);
 
-struct qcom_cc {
-	struct qcom_reset_controller reset;
-	struct clk_onecell_data data;
-	struct clk *clks[];
-};
-
 static int gcc_msm8660_probe(struct platform_device *pdev)
 {
-	void __iomem *base;
-	struct resource *res;
-	int i, ret;
-	struct device *dev = &pdev->dev;
-	struct clk *clk;
-	struct clk_onecell_data *data;
-	struct clk **clks;
-	struct regmap *regmap;
-	size_t num_clks;
-	struct qcom_reset_controller *reset;
-	struct qcom_cc *cc;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
-	regmap = devm_regmap_init_mmio(dev, base, &gcc_msm8660_regmap_config);
-	if (IS_ERR(regmap))
-		return PTR_ERR(regmap);
-
-	num_clks = ARRAY_SIZE(gcc_msm8660_clks);
-	cc = devm_kzalloc(dev, sizeof(*cc) + sizeof(*clks) * num_clks,
-			  GFP_KERNEL);
-	if (!cc)
-		return -ENOMEM;
-
-	clks = cc->clks;
-	data = &cc->data;
-	data->clks = clks;
-	data->clk_num = num_clks;
-
-	/* Temporary until RPM clocks supported */
-	clk = clk_register_fixed_rate(dev, "cxo", NULL, CLK_IS_ROOT, 19200000);
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
-
-	clk = clk_register_fixed_rate(dev, "pxo", NULL, CLK_IS_ROOT, 27000000);
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
-
-	for (i = 0; i < num_clks; i++) {
-		if (!gcc_msm8660_clks[i])
-			continue;
-		clk = devm_clk_register_regmap(dev, gcc_msm8660_clks[i]);
-		if (IS_ERR(clk))
-			return PTR_ERR(clk);
-		clks[i] = clk;
-	}
-
-	ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get, data);
-	if (ret)
-		return ret;
-
-	reset = &cc->reset;
-	reset->rcdev.of_node = dev->of_node;
-	reset->rcdev.ops = &qcom_reset_ops,
-	reset->rcdev.owner = THIS_MODULE,
-	reset->rcdev.nr_resets = ARRAY_SIZE(gcc_msm8660_resets),
-	reset->regmap = regmap;
-	reset->reset_map = gcc_msm8660_resets,
-	platform_set_drvdata(pdev, &reset->rcdev);
-
-	ret = reset_controller_register(&reset->rcdev);
-	if (ret)
-		of_clk_del_provider(dev->of_node);
-
-	return ret;
+	return qcom_cc_probe(pdev, &gcc_msm8660_desc);
 }
 
 static int gcc_msm8660_remove(struct platform_device *pdev)
 {
-	of_clk_del_provider(pdev->dev.of_node);
-	reset_controller_unregister(platform_get_drvdata(pdev));
+	qcom_cc_remove(pdev);
 	return 0;
 }
 
diff --git a/drivers/clk/qcom/gcc-msm8960.c b/drivers/clk/qcom/gcc-msm8960.c
index fd446ab2fd98..633b019891bb 100644
--- a/drivers/clk/qcom/gcc-msm8960.c
+++ b/drivers/clk/qcom/gcc-msm8960.c
@@ -25,6 +25,7 @@
 #include <dt-bindings/clock/qcom,gcc-msm8960.h>
 #include <dt-bindings/reset/qcom,gcc-msm8960.h>
 
+#include "common.h"
 #include "clk-regmap.h"
 #include "clk-pll.h"
 #include "clk-rcg.h"
@@ -2875,51 +2876,24 @@ static const struct regmap_config gcc_msm8960_regmap_config = {
 	.fast_io	= true,
 };
 
+static const struct qcom_cc_desc gcc_msm8960_desc = {
+	.config = &gcc_msm8960_regmap_config,
+	.clks = gcc_msm8960_clks,
+	.num_clks = ARRAY_SIZE(gcc_msm8960_clks),
+	.resets = gcc_msm8960_resets,
+	.num_resets = ARRAY_SIZE(gcc_msm8960_resets),
+};
+
 static const struct of_device_id gcc_msm8960_match_table[] = {
 	{ .compatible = "qcom,gcc-msm8960" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, gcc_msm8960_match_table);
 
-struct qcom_cc {
-	struct qcom_reset_controller reset;
-	struct clk_onecell_data data;
-	struct clk *clks[];
-};
-
 static int gcc_msm8960_probe(struct platform_device *pdev)
 {
-	void __iomem *base;
-	struct resource *res;
-	int i, ret;
-	struct device *dev = &pdev->dev;
 	struct clk *clk;
-	struct clk_onecell_data *data;
-	struct clk **clks;
-	struct regmap *regmap;
-	size_t num_clks;
-	struct qcom_reset_controller *reset;
-	struct qcom_cc *cc;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
-	regmap = devm_regmap_init_mmio(dev, base, &gcc_msm8960_regmap_config);
-	if (IS_ERR(regmap))
-		return PTR_ERR(regmap);
-
-	num_clks = ARRAY_SIZE(gcc_msm8960_clks);
-	cc = devm_kzalloc(dev, sizeof(*cc) + sizeof(*clks) * num_clks,
-			  GFP_KERNEL);
-	if (!cc)
-		return -ENOMEM;
-
-	clks = cc->clks;
-	data = &cc->data;
-	data->clks = clks;
-	data->clk_num = num_clks;
+	struct device *dev = &pdev->dev;
 
 	/* Temporary until RPM clocks supported */
 	clk = clk_register_fixed_rate(dev, "cxo", NULL, CLK_IS_ROOT, 19200000);
@@ -2930,39 +2904,12 @@ static int gcc_msm8960_probe(struct platform_device *pdev)
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
-	for (i = 0; i < num_clks; i++) {
-		if (!gcc_msm8960_clks[i])
-			continue;
-		clk = devm_clk_register_regmap(dev, gcc_msm8960_clks[i]);
-		if (IS_ERR(clk))
-			return PTR_ERR(clk);
-		clks[i] = clk;
-	}
-
-	ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get, data);
-	if (ret)
-		return ret;
-
-	reset = &cc->reset;
-	reset->rcdev.of_node = dev->of_node;
-	reset->rcdev.ops = &qcom_reset_ops,
-	reset->rcdev.owner = THIS_MODULE,
-	reset->rcdev.nr_resets = ARRAY_SIZE(gcc_msm8960_resets),
-	reset->regmap = regmap;
-	reset->reset_map = gcc_msm8960_resets,
-	platform_set_drvdata(pdev, &reset->rcdev);
-
-	ret = reset_controller_register(&reset->rcdev);
-	if (ret)
-		of_clk_del_provider(dev->of_node);
-
-	return ret;
+	return qcom_cc_probe(pdev, &gcc_msm8960_desc);
 }
 
 static int gcc_msm8960_remove(struct platform_device *pdev)
 {
-	of_clk_del_provider(pdev->dev.of_node);
-	reset_controller_unregister(platform_get_drvdata(pdev));
+	qcom_cc_remove(pdev);
 	return 0;
 }
 
diff --git a/drivers/clk/qcom/gcc-msm8974.c b/drivers/clk/qcom/gcc-msm8974.c
index 51d457e2b959..0d1edc1e9b31 100644
--- a/drivers/clk/qcom/gcc-msm8974.c
+++ b/drivers/clk/qcom/gcc-msm8974.c
@@ -25,6 +25,7 @@
 #include <dt-bindings/clock/qcom,gcc-msm8974.h>
 #include <dt-bindings/reset/qcom,gcc-msm8974.h>
 
+#include "common.h"
 #include "clk-regmap.h"
 #include "clk-pll.h"
 #include "clk-rcg.h"
@@ -2574,51 +2575,24 @@ static const struct regmap_config gcc_msm8974_regmap_config = {
 	.fast_io	= true,
 };
 
+static const struct qcom_cc_desc gcc_msm8974_desc = {
+	.config = &gcc_msm8974_regmap_config,
+	.clks = gcc_msm8974_clocks,
+	.num_clks = ARRAY_SIZE(gcc_msm8974_clocks),
+	.resets = gcc_msm8974_resets,
+	.num_resets = ARRAY_SIZE(gcc_msm8974_resets),
+};
+
 static const struct of_device_id gcc_msm8974_match_table[] = {
 	{ .compatible = "qcom,gcc-msm8974" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, gcc_msm8974_match_table);
 
-struct qcom_cc {
-	struct qcom_reset_controller reset;
-	struct clk_onecell_data data;
-	struct clk *clks[];
-};
-
 static int gcc_msm8974_probe(struct platform_device *pdev)
 {
-	void __iomem *base;
-	struct resource *res;
-	int i, ret;
-	struct device *dev = &pdev->dev;
 	struct clk *clk;
-	struct clk_onecell_data *data;
-	struct clk **clks;
-	struct regmap *regmap;
-	size_t num_clks;
-	struct qcom_reset_controller *reset;
-	struct qcom_cc *cc;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
-	regmap = devm_regmap_init_mmio(dev, base, &gcc_msm8974_regmap_config);
-	if (IS_ERR(regmap))
-		return PTR_ERR(regmap);
-
-	num_clks = ARRAY_SIZE(gcc_msm8974_clocks);
-	cc = devm_kzalloc(dev, sizeof(*cc) + sizeof(*clks) * num_clks,
-			  GFP_KERNEL);
-	if (!cc)
-		return -ENOMEM;
-
-	clks = cc->clks;
-	data = &cc->data;
-	data->clks = clks;
-	data->clk_num = num_clks;
+	struct device *dev = &pdev->dev;
 
 	/* Temporary until RPM clocks supported */
 	clk = clk_register_fixed_rate(dev, "xo", NULL, CLK_IS_ROOT, 19200000);
@@ -2631,39 +2605,12 @@ static int gcc_msm8974_probe(struct platform_device *pdev)
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
-	for (i = 0; i < num_clks; i++) {
-		if (!gcc_msm8974_clocks[i])
-			continue;
-		clk = devm_clk_register_regmap(dev, gcc_msm8974_clocks[i]);
-		if (IS_ERR(clk))
-			return PTR_ERR(clk);
-		clks[i] = clk;
-	}
-
-	ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get, data);
-	if (ret)
-		return ret;
-
-	reset = &cc->reset;
-	reset->rcdev.of_node = dev->of_node;
-	reset->rcdev.ops = &qcom_reset_ops,
-	reset->rcdev.owner = THIS_MODULE,
-	reset->rcdev.nr_resets = ARRAY_SIZE(gcc_msm8974_resets),
-	reset->regmap = regmap;
-	reset->reset_map = gcc_msm8974_resets,
-	platform_set_drvdata(pdev, &reset->rcdev);
-
-	ret = reset_controller_register(&reset->rcdev);
-	if (ret)
-		of_clk_del_provider(dev->of_node);
-
-	return ret;
+	return qcom_cc_probe(pdev, &gcc_msm8974_desc);
 }
 
 static int gcc_msm8974_remove(struct platform_device *pdev)
 {
-	of_clk_del_provider(pdev->dev.of_node);
-	reset_controller_unregister(platform_get_drvdata(pdev));
+	qcom_cc_remove(pdev);
 	return 0;
 }
 
diff --git a/drivers/clk/qcom/mmcc-msm8960.c b/drivers/clk/qcom/mmcc-msm8960.c
index f9b59c7e48e9..12f3c0b64fcd 100644
--- a/drivers/clk/qcom/mmcc-msm8960.c
+++ b/drivers/clk/qcom/mmcc-msm8960.c
@@ -26,6 +26,7 @@
 #include <dt-bindings/clock/qcom,mmcc-msm8960.h>
 #include <dt-bindings/reset/qcom,mmcc-msm8960.h>
 
+#include "common.h"
 #include "clk-regmap.h"
 #include "clk-pll.h"
 #include "clk-rcg.h"
@@ -2222,85 +2223,28 @@ static const struct regmap_config mmcc_msm8960_regmap_config = {
 	.fast_io	= true,
 };
 
+static const struct qcom_cc_desc mmcc_msm8960_desc = {
+	.config = &mmcc_msm8960_regmap_config,
+	.clks = mmcc_msm8960_clks,
+	.num_clks = ARRAY_SIZE(mmcc_msm8960_clks),
+	.resets = mmcc_msm8960_resets,
+	.num_resets = ARRAY_SIZE(mmcc_msm8960_resets),
+};
+
 static const struct of_device_id mmcc_msm8960_match_table[] = {
 	{ .compatible = "qcom,mmcc-msm8960" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, mmcc_msm8960_match_table);
 
-struct qcom_cc {
-	struct qcom_reset_controller reset;
-	struct clk_onecell_data data;
-	struct clk *clks[];
-};
-
 static int mmcc_msm8960_probe(struct platform_device *pdev)
 {
-	void __iomem *base;
-	struct resource *res;
-	int i, ret;
-	struct device *dev = &pdev->dev;
-	struct clk *clk;
-	struct clk_onecell_data *data;
-	struct clk **clks;
-	struct regmap *regmap;
-	size_t num_clks;
-	struct qcom_reset_controller *reset;
-	struct qcom_cc *cc;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
-	regmap = devm_regmap_init_mmio(dev, base, &mmcc_msm8960_regmap_config);
-	if (IS_ERR(regmap))
-		return PTR_ERR(regmap);
-
-	num_clks = ARRAY_SIZE(mmcc_msm8960_clks);
-	cc = devm_kzalloc(dev, sizeof(*cc) + sizeof(*clks) * num_clks,
-			  GFP_KERNEL);
-	if (!cc)
-		return -ENOMEM;
-
-	clks = cc->clks;
-	data = &cc->data;
-	data->clks = clks;
-	data->clk_num = num_clks;
-
-	for (i = 0; i < num_clks; i++) {
-		if (!mmcc_msm8960_clks[i])
-			continue;
-		clk = devm_clk_register_regmap(dev, mmcc_msm8960_clks[i]);
-		if (IS_ERR(clk))
-			return PTR_ERR(clk);
-		clks[i] = clk;
-	}
-
-	ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get, data);
-	if (ret)
-		return ret;
-
-	reset = &cc->reset;
-	reset->rcdev.of_node = dev->of_node;
-	reset->rcdev.ops = &qcom_reset_ops,
-	reset->rcdev.owner = THIS_MODULE,
-	reset->rcdev.nr_resets = ARRAY_SIZE(mmcc_msm8960_resets),
-	reset->regmap = regmap;
-	reset->reset_map = mmcc_msm8960_resets,
-	platform_set_drvdata(pdev, &reset->rcdev);
-
-	ret = reset_controller_register(&reset->rcdev);
-	if (ret)
-		of_clk_del_provider(dev->of_node);
-
-	return ret;
+	return qcom_cc_probe(pdev, &mmcc_msm8960_desc);
 }
 
 static int mmcc_msm8960_remove(struct platform_device *pdev)
 {
-	of_clk_del_provider(pdev->dev.of_node);
-	reset_controller_unregister(platform_get_drvdata(pdev));
+	qcom_cc_remove(pdev);
 	return 0;
 }
 
diff --git a/drivers/clk/qcom/mmcc-msm8974.c b/drivers/clk/qcom/mmcc-msm8974.c
index c95774514b81..60b7c24a5cd6 100644
--- a/drivers/clk/qcom/mmcc-msm8974.c
+++ b/drivers/clk/qcom/mmcc-msm8974.c
@@ -25,6 +25,7 @@
 #include <dt-bindings/clock/qcom,mmcc-msm8974.h>
 #include <dt-bindings/reset/qcom,mmcc-msm8974.h>
 
+#include "common.h"
 #include "clk-regmap.h"
 #include "clk-pll.h"
 #include "clk-rcg.h"
@@ -2524,88 +2525,39 @@ static const struct regmap_config mmcc_msm8974_regmap_config = {
 	.fast_io	= true,
 };
 
+static const struct qcom_cc_desc mmcc_msm8974_desc = {
+	.config = &mmcc_msm8974_regmap_config,
+	.clks = mmcc_msm8974_clocks,
+	.num_clks = ARRAY_SIZE(mmcc_msm8974_clocks),
+	.resets = mmcc_msm8974_resets,
+	.num_resets = ARRAY_SIZE(mmcc_msm8974_resets),
+};
+
 static const struct of_device_id mmcc_msm8974_match_table[] = {
 	{ .compatible = "qcom,mmcc-msm8974" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, mmcc_msm8974_match_table);
 
-struct qcom_cc {
-	struct qcom_reset_controller reset;
-	struct clk_onecell_data data;
-	struct clk *clks[];
-};
-
 static int mmcc_msm8974_probe(struct platform_device *pdev)
 {
-	void __iomem *base;
-	struct resource *res;
-	int i, ret;
-	struct device *dev = &pdev->dev;
-	struct clk *clk;
-	struct clk_onecell_data *data;
-	struct clk **clks;
+	int ret;
 	struct regmap *regmap;
-	size_t num_clks;
-	struct qcom_reset_controller *reset;
-	struct qcom_cc *cc;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
-	regmap = devm_regmap_init_mmio(dev, base, &mmcc_msm8974_regmap_config);
-	if (IS_ERR(regmap))
-		return PTR_ERR(regmap);
-
-	num_clks = ARRAY_SIZE(mmcc_msm8974_clocks);
-	cc = devm_kzalloc(dev, sizeof(*cc) + sizeof(*clks) * num_clks,
-			  GFP_KERNEL);
-	if (!cc)
-		return -ENOMEM;
-
-	clks = cc->clks;
-	data = &cc->data;
-	data->clks = clks;
-	data->clk_num = num_clks;
-
-	clk_pll_configure_sr_hpm_lp(&mmpll1, regmap, &mmpll1_config, true);
-	clk_pll_configure_sr_hpm_lp(&mmpll3, regmap, &mmpll3_config, false);
 
-	for (i = 0; i < num_clks; i++) {
-		if (!mmcc_msm8974_clocks[i])
-			continue;
-		clk = devm_clk_register_regmap(dev, mmcc_msm8974_clocks[i]);
-		if (IS_ERR(clk))
-			return PTR_ERR(clk);
-		clks[i] = clk;
-	}
-
-	ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get, data);
+	ret = qcom_cc_probe(pdev, &mmcc_msm8974_desc);
 	if (ret)
 		return ret;
 
-	reset = &cc->reset;
-	reset->rcdev.of_node = dev->of_node;
-	reset->rcdev.ops = &qcom_reset_ops,
-	reset->rcdev.owner = THIS_MODULE,
-	reset->rcdev.nr_resets = ARRAY_SIZE(mmcc_msm8974_resets),
-	reset->regmap = regmap;
-	reset->reset_map = mmcc_msm8974_resets,
-	platform_set_drvdata(pdev, &reset->rcdev);
-
-	ret = reset_controller_register(&reset->rcdev);
-	if (ret)
-		of_clk_del_provider(dev->of_node);
+	regmap = dev_get_regmap(&pdev->dev, NULL);
+	clk_pll_configure_sr_hpm_lp(&mmpll1, regmap, &mmpll1_config, true);
+	clk_pll_configure_sr_hpm_lp(&mmpll3, regmap, &mmpll3_config, false);
 
-	return ret;
+	return 0;
 }
 
 static int mmcc_msm8974_remove(struct platform_device *pdev)
 {
-	of_clk_del_provider(pdev->dev.of_node);
-	reset_controller_unregister(platform_get_drvdata(pdev));
+	qcom_cc_remove(pdev);
 	return 0;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

