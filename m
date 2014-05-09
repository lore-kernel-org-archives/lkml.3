Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbaEINCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 09:02:03 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:54069 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220AbaEINB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 09:01:59 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: mturquette@linaro.org, t.figa@samsung.com, kgene.kim@samsung.com,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org
Subject: [PATCH 1/4] clk: samsung: out: Add infrastructure to register CLKOUT
Date: Fri,  9 May 2014 18:30:07 +0530
Message-Id: <1399640410-30957-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399640410-30957-1-git-send-email-tushar.behera@linaro.org>
References: <1399640410-30957-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All SoC in Exynos-series have a clock with name XCLKOUT to provide
debug information about various clocks available in the SoC. The register
controlling the MUX and GATE of this clock is provided within PMU domain.
Since PMU domain can't be dedicatedly mapped by every driver, the register
needs to be handled through a regmap handle provided by PMU syscon
controller. Right now, CCF doesn't allow regmap based MUX and GATE clocks,
hence a dedicated clock provider for XCLKOUT is added here.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: Tomasz Figa <t.figa@samsung.com>
---
 drivers/clk/samsung/Makefile  |    2 +-
 drivers/clk/samsung/clk-out.c |  181 +++++++++++++++++++++++++++++++++++++++++
 drivers/clk/samsung/clk.h     |   33 ++++++++
 3 files changed, 215 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/samsung/clk-out.c

diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
index 8eb4799..d23ad4f 100644
--- a/drivers/clk/samsung/Makefile
+++ b/drivers/clk/samsung/Makefile
@@ -2,7 +2,7 @@
 # Samsung Clock specific Makefile
 #
 
-obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-pll.o
+obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-pll.o clk-out.o
 obj-$(CONFIG_ARCH_EXYNOS4)	+= clk-exynos4.o
 obj-$(CONFIG_SOC_EXYNOS5250)	+= clk-exynos5250.o
 obj-$(CONFIG_SOC_EXYNOS5420)	+= clk-exynos5420.o
diff --git a/drivers/clk/samsung/clk-out.c b/drivers/clk/samsung/clk-out.c
new file mode 100644
index 0000000..76489b6
--- /dev/null
+++ b/drivers/clk/samsung/clk-out.c
@@ -0,0 +1,181 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This file contains the utility functions to register the clkout clocks.
+*/
+
+/**
+ * All SoC in Exynos-series have a clock with name XCLKOUT to provide
+ * debug information about various clocks available in the SoC. The register
+ * controlling the MUX and GATE of this clock is provided within PMU domain.
+ * Since PMU domain can't be dedicatedly mapped every driver, the register
+ * needs to be handled through a regmap handle provided by PMU syscon
+ * controller. Right now, CCF doesn't allow regmap based MUX and GATE clocks,
+ * hence a dedicated clock provider for XCLKOUT is added here.
+ */
+
+#include <linux/errno.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+
+#include "clk.h"
+
+/**
+ * struct samsung_clkout_soc_data: SoC specific register details
+ * @reg: Offset of CLKOUT register from PMU base
+ * @mux_shift: Start-bit of MUX bit-field
+ * @mux_width: Width of MUX bit-field
+ * @enable_bit: The bit corresponding to gating of this clock
+ */
+struct samsung_clkout_soc_data {
+	unsigned int reg;
+	u8 mux_shift;
+	u8 mux_width;
+	u8 enable_bit;
+};
+
+/**
+ * struct samsung_clkout: Structure to store driver specific clock context
+ * @hw: Handle to CCF clock
+ * @soc_data: SoC specific register details
+ * @regmap: Regmap handle of the PMU
+ */
+struct samsung_clkout {
+	struct clk_hw hw;
+	const struct samsung_clkout_soc_data *soc_data;
+	struct regmap *regmap;
+};
+
+#define to_clk_out(_hw) container_of(_hw, struct samsung_clkout, hw)
+
+int samsung_clkout_enable(struct clk_hw *hw)
+{
+	struct samsung_clkout *clkout = to_clk_out(hw);
+	const struct samsung_clkout_soc_data *soc_data = clkout->soc_data;
+	unsigned int enable_mask = BIT(soc_data->enable_bit);
+
+	/* clkout is enabled if enable bit is low */
+	regmap_update_bits(clkout->regmap, soc_data->reg, enable_mask, 0);
+
+	return 0;
+}
+
+void samsung_clkout_disable(struct clk_hw *hw)
+{
+	struct samsung_clkout *clkout = to_clk_out(hw);
+	const struct samsung_clkout_soc_data *soc_data = clkout->soc_data;
+	unsigned int enable_mask = BIT(soc_data->enable_bit);
+
+	/* clkout is gated if enable bit is high */
+	regmap_update_bits(clkout->regmap, soc_data->reg,
+			enable_mask, enable_mask);
+
+	return;
+}
+
+int samsung_clkout_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct samsung_clkout *clkout = to_clk_out(hw);
+	const struct samsung_clkout_soc_data *soc_data = clkout->soc_data;
+	unsigned int parent_mask = BIT(soc_data->mux_width) - 1;
+
+	regmap_update_bits(clkout->regmap, soc_data->reg,
+			parent_mask << soc_data->mux_shift,
+			index << soc_data->mux_shift);
+
+	return 0;
+}
+
+u8 samsung_clkout_get_parent(struct clk_hw *hw)
+{
+	struct samsung_clkout *clkout = to_clk_out(hw);
+	const struct samsung_clkout_soc_data *soc_data = clkout->soc_data;
+	unsigned int parent_mask = BIT(soc_data->mux_width) - 1;
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(clkout->regmap, soc_data->reg, &val);
+
+	return (val >> soc_data->mux_shift) & parent_mask;
+}
+
+static const struct clk_ops samsung_clkout_clk_ops = {
+	.enable = samsung_clkout_enable,
+	.disable = samsung_clkout_disable,
+	.set_parent = samsung_clkout_set_parent,
+	.get_parent = samsung_clkout_get_parent,
+};
+
+static void __init _samsung_clk_register_clkout(
+		struct samsung_out_clock *out,
+		const struct samsung_clkout_soc_data *soc_data,
+		struct regmap *regmap)
+{
+	struct samsung_clkout *clkout;
+	struct clk *clk;
+	struct clk_init_data init;
+	int ret;
+
+	clkout = kzalloc(sizeof(*clkout), GFP_KERNEL);
+	if (!clkout) {
+		pr_err("%s: could not allocate out clk %s\n",
+			__func__, out->name);
+		return;
+	}
+
+	init.name = out->name;
+	init.parent_names = out->parent_names;
+	init.num_parents = out->num_parents;
+	init.ops = &samsung_clkout_clk_ops;
+
+	clkout->hw.init = &init;
+	clkout->regmap = regmap;
+	clkout->soc_data = soc_data;
+
+	clk = clk_register(NULL, &clkout->hw);
+	if (IS_ERR(clk)) {
+		pr_err("%s: failed to register out clock %s : %ld\n",
+			__func__, out->name, PTR_ERR(clk));
+		kfree(clkout);
+		return;
+	}
+
+	samsung_clk_add_lookup(clk, out->id);
+
+	if (!out->alias)
+		return;
+
+	ret = clk_register_clkdev(clk, out->alias, out->dev_name);
+	if (ret)
+		pr_err("%s: failed to register lookup for %s : %d",
+			__func__, out->name, ret);
+}
+
+/* All existing Exynos serial of SoCs have common values for this offsets. */
+static const struct samsung_clkout_soc_data exynos_clkout_soc_data = {
+	.reg = 0xa00,
+	.mux_shift = 8,
+	.mux_width = 5,
+	.enable_bit = 0,
+};
+
+void __init samsung_clk_register_clkout(struct device_node *np,
+		struct samsung_out_clock *out_clk_list, unsigned int nr_out_clk)
+{
+	int cnt;
+	struct regmap *reg;
+	const struct samsung_clkout_soc_data *priv = &exynos_clkout_soc_data;
+
+	reg = syscon_early_regmap_lookup_by_phandle(np, "samsung,pmu-syscon");
+	if (IS_ERR(reg)) {
+		pr_err("Failed to get pmu-syscon handle for clkout\n");
+		return;
+	}
+
+	for (cnt = 0; cnt < nr_out_clk; cnt++)
+		_samsung_clk_register_clkout(&out_clk_list[cnt], priv, reg);
+}
diff --git a/drivers/clk/samsung/clk.h b/drivers/clk/samsung/clk.h
index c7141ba..b4b2122 100644
--- a/drivers/clk/samsung/clk.h
+++ b/drivers/clk/samsung/clk.h
@@ -312,6 +312,37 @@ struct samsung_pll_clock {
 	__PLL(_typ, _id, NULL, _name, _pname, CLK_GET_RATE_NOCACHE,	\
 		_lock, _con, _rtable, _alias)
 
+/**
+ * struct samsung_out_clock: information about CLKOUT clock
+ * @id: platform specific id of the clock.
+ * @dev_name: name of the device to which this clock belongs.
+ * @name: name of this mux clock.
+ * @parent_names: array of pointer to parent clock names.
+ * @num_parents: number of parents listed in @parent_names.
+ * @alias: optional clock alias name to be assigned to this clock.
+ */
+struct samsung_out_clock {
+	unsigned int		id;
+	const char		*dev_name;
+	const char		*name;
+	const char		**parent_names;
+	unsigned int		num_parents;
+	const char		*alias;
+};
+
+#define __CLKOUT(_id, dname, cname, pnames, a)		\
+	{							\
+		.id		= _id,				\
+		.dev_name	= dname,			\
+		.name		= cname,			\
+		.parent_names	= pnames,			\
+		.num_parents	= ARRAY_SIZE(pnames),		\
+		.alias		= a,				\
+	}
+
+#define CLKOUT(_id, cname, pnames) \
+	__CLKOUT(_id, NULL, cname, pnames, NULL)
+
 extern void __init samsung_clk_init(struct device_node *np, void __iomem *base,
 				    unsigned long nr_clks);
 extern void __init samsung_clk_of_register_fixed_ext(
@@ -335,6 +366,8 @@ extern void __init samsung_clk_register_gate(
 		struct samsung_gate_clock *clk_list, unsigned int nr_clk);
 extern void __init samsung_clk_register_pll(struct samsung_pll_clock *pll_list,
 		unsigned int nr_clk, void __iomem *base);
+extern void __init samsung_clk_register_clkout(struct device_node *np,
+	struct samsung_out_clock *out_clk_list, unsigned int nr_out_clk);
 
 extern unsigned long _get_rate(const char *clk_name);
 
-- 
1.7.9.5

