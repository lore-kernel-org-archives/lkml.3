Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896AbaFZSQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:16:35 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33323 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964778AbaFZSQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:16:33 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v5 05/14] clk: Add generic driver for Maxim PMIC clocks
Date: Thu, 26 Jun 2014 20:15:37 +0200
Message-Id: <1403806546-31122-6-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Integrated Power Management ICs are very similar with
regard to their clock outputs. Most of the clock drivers for
these chips are duplicating code and are simpler enough that
can be converted to use a generic driver to consolidate code
and avoid duplication.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---

Changes since v4:
 - Return recalc 0 if clock isn't enabled in Suggested by Yadwinder Singh Brar.

Changes since v3:
 - Add current copyright information. Suggested by Krzysztof Kozlowski
 - Do a single allocation for struct max_gen_clk. Suggested by Krzysztof Kozlowski
 - Add EXPORT_SYMBOL() for exported symbols. Suggested by Krzysztof Kozlowski

 drivers/clk/Kconfig       |   3 +
 drivers/clk/Makefile      |   1 +
 drivers/clk/clk-max-gen.c | 195 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/clk-max-gen.h |  32 ++++++++
 4 files changed, 231 insertions(+)
 create mode 100644 drivers/clk/clk-max-gen.c
 create mode 100644 drivers/clk/clk-max-gen.h

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 9f9c5ae..73f78e8 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -32,6 +32,9 @@ config COMMON_CLK_WM831X
 
 source "drivers/clk/versatile/Kconfig"
 
+config COMMON_CLK_MAX_GEN
+        bool
+
 config COMMON_CLK_MAX77686
 	tristate "Clock driver for Maxim 77686 MFD"
 	depends on MFD_MAX77686
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 567f102..6c1aff6 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_ARCH_BCM2835)		+= clk-bcm2835.o
 obj-$(CONFIG_ARCH_EFM32)		+= clk-efm32gg.o
 obj-$(CONFIG_ARCH_HIGHBANK)		+= clk-highbank.o
 obj-$(CONFIG_MACH_LOONGSON1)		+= clk-ls1x.o
+obj-$(CONFIG_COMMON_CLK_MAX_GEN)	+= clk-max-gen.o
 obj-$(CONFIG_COMMON_CLK_MAX77686)	+= clk-max77686.o
 obj-$(CONFIG_ARCH_MOXART)		+= clk-moxart.o
 obj-$(CONFIG_ARCH_NOMADIK)		+= clk-nomadik.o
diff --git a/drivers/clk/clk-max-gen.c b/drivers/clk/clk-max-gen.c
new file mode 100644
index 0000000..3e9fa7e
--- /dev/null
+++ b/drivers/clk/clk-max-gen.c
@@ -0,0 +1,195 @@
+/*
+ * clk-max-gen.c - Generic clock driver for Maxim PMICs clocks
+ *
+ * Copyright (C) 2014 Google, Inc
+ *
+ * Copyright (C) 2012 Samsung Electornics
+ * Jonghwa Lee <jonghwa3.lee@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * This driver is based on clk-max77686.c
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/regmap.h>
+#include <linux/platform_device.h>
+#include <linux/clk-provider.h>
+#include <linux/mutex.h>
+#include <linux/clkdev.h>
+
+struct max_gen_clk {
+	struct regmap *regmap;
+	u32 mask;
+	u32 reg;
+	struct clk_hw hw;
+	struct clk_lookup *lookup;
+};
+
+static struct max_gen_clk *to_max_gen_clk(struct clk_hw *hw)
+{
+	return container_of(hw, struct max_gen_clk, hw);
+}
+
+static int max_gen_clk_prepare(struct clk_hw *hw)
+{
+	struct max_gen_clk *max_gen = to_max_gen_clk(hw);
+
+	return regmap_update_bits(max_gen->regmap, max_gen->reg,
+				  max_gen->mask, max_gen->mask);
+}
+
+static void max_gen_clk_unprepare(struct clk_hw *hw)
+{
+	struct max_gen_clk *max_gen = to_max_gen_clk(hw);
+
+	regmap_update_bits(max_gen->regmap, max_gen->reg,
+			   max_gen->mask, ~max_gen->mask);
+}
+
+static int max_gen_clk_is_prepared(struct clk_hw *hw)
+{
+	struct max_gen_clk *max_gen = to_max_gen_clk(hw);
+	int ret;
+	u32 val;
+
+	ret = regmap_read(max_gen->regmap, max_gen->reg, &val);
+
+	if (ret < 0)
+		return -EINVAL;
+
+	return val & max_gen->mask;
+}
+
+static unsigned long max_gen_recalc_rate(struct clk_hw *hw,
+					 unsigned long parent_rate)
+{
+	return 32768;
+}
+
+struct clk_ops max_gen_clk_ops = {
+	.prepare	= max_gen_clk_prepare,
+	.unprepare	= max_gen_clk_unprepare,
+	.is_prepared	= max_gen_clk_is_prepared,
+	.recalc_rate	= max_gen_recalc_rate,
+};
+EXPORT_SYMBOL_GPL(max_gen_clk_ops);
+
+static struct clk *max_gen_clk_register(struct device *dev,
+					struct max_gen_clk *max_gen)
+{
+	struct clk *clk;
+	struct clk_hw *hw = &max_gen->hw;
+
+	clk = clk_register(dev, hw);
+	if (IS_ERR(clk))
+		return clk;
+
+	max_gen->lookup = kzalloc(sizeof(struct clk_lookup), GFP_KERNEL);
+	if (!max_gen->lookup)
+		return ERR_PTR(-ENOMEM);
+
+	max_gen->lookup->con_id = hw->init->name;
+	max_gen->lookup->clk = clk;
+
+	clkdev_add(max_gen->lookup);
+
+	return clk;
+}
+
+int max_gen_clk_probe(struct platform_device *pdev, struct regmap *regmap,
+		      u32 reg, struct clk_init_data *clks_init, int num_init)
+{
+	int i, ret;
+	struct max_gen_clk *max_gen_clks;
+	struct clk **clocks;
+	struct device *dev = &pdev->dev;
+
+	clocks = devm_kzalloc(dev, sizeof(struct clk *) * num_init, GFP_KERNEL);
+	if (!clocks)
+		return -ENOMEM;
+
+	max_gen_clks = devm_kzalloc(dev, sizeof(struct max_gen_clk)
+				    * num_init, GFP_KERNEL);
+	if (!max_gen_clks)
+		return -ENOMEM;
+
+	for (i = 0; i < num_init; i++) {
+		max_gen_clks[i].regmap = regmap;
+		max_gen_clks[i].mask = 1 << i;
+		max_gen_clks[i].reg = reg;
+		max_gen_clks[i].hw.init = &clks_init[i];
+
+		clocks[i] = max_gen_clk_register(dev, &max_gen_clks[i]);
+		if (IS_ERR(clocks[i])) {
+			ret = PTR_ERR(clocks[i]);
+			dev_err(dev, "failed to register %s\n",
+				max_gen_clks[i].hw.init->name);
+			goto err_clocks;
+		}
+	}
+
+	platform_set_drvdata(pdev, clocks);
+
+	if (dev->of_node) {
+		struct clk_onecell_data *of_data;
+
+		of_data = devm_kzalloc(dev, sizeof(*of_data), GFP_KERNEL);
+		if (!of_data) {
+			ret = -ENOMEM;
+			goto err_clocks;
+		}
+
+		of_data->clks = clocks;
+		of_data->clk_num = num_init;
+		ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get,
+					  of_data);
+
+		if (ret) {
+			dev_err(dev, "failed to register OF clock provider\n");
+			goto err_clocks;
+		}
+	}
+
+	return 0;
+
+err_clocks:
+	for (--i; i >= 0; --i) {
+		clkdev_drop(max_gen_clks[i].lookup);
+		clk_unregister(max_gen_clks[i].hw.clk);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(max_gen_clk_probe);
+
+int max_gen_clk_remove(struct platform_device *pdev, int num_init)
+{
+	struct clk **clocks = platform_get_drvdata(pdev);
+	struct device *dev = pdev->dev.parent;
+	int i;
+
+	if (dev->of_node)
+		of_clk_del_provider(dev->of_node);
+
+	for (i = 0; i < num_init; i++) {
+		struct clk_hw *hw = __clk_get_hw(clocks[i]);
+		struct max_gen_clk *max_gen = to_max_gen_clk(hw);
+
+		clkdev_drop(max_gen->lookup);
+		clk_unregister(clocks[i]);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(max_gen_clk_remove);
diff --git a/drivers/clk/clk-max-gen.h b/drivers/clk/clk-max-gen.h
new file mode 100644
index 0000000..997e86f
--- /dev/null
+++ b/drivers/clk/clk-max-gen.h
@@ -0,0 +1,32 @@
+/*
+ * clk-max-gen.h - Generic clock driver for Maxim PMICs clocks
+ *
+ * Copyright (C) 2014 Google, Inc
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __CLK_MAX_GEN_H__
+#define __CLK_MAX_GEN_H__
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/clkdev.h>
+#include <linux/regmap.h>
+#include <linux/platform_device.h>
+
+int max_gen_clk_probe(struct platform_device *pdev, struct regmap *regmap,
+		      u32 reg, struct clk_init_data *clks_init, int num_init);
+int max_gen_clk_remove(struct platform_device *pdev, int num_init);
+extern struct clk_ops max_gen_clk_ops;
+
+#endif /* __CLK_MAX_GEN_H__ */
-- 
2.0.0.rc2

