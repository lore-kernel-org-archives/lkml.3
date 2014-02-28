Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaB1XfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:35:23 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:35261 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaB1XfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:35:20 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Gerhard Sittig <gsi@denx.de>
Cc: Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 1/3] clk: Introduce I2C clock primitives
Date: Fri, 28 Feb 2014 15:34:53 -0800
Message-Id: <1393630495-29689-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1393630495-29689-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1393630495-29689-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add clk-divider and clk-mux primitives for I2C clock devices. They
are derived from the clk-divider and clk-mux drivers, but use regmap to
access HW.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clk/Kconfig           |   7 +
 drivers/clk/Makefile          |   5 +
 drivers/clk/clk-i2c-divider.c | 343 ++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/clk-i2c-mux.c     | 173 +++++++++++++++++++++
 drivers/clk/clk-i2c.c         |  22 +++
 include/linux/clk-provider.h  |  95 ++++++++++++
 6 files changed, 645 insertions(+)
 create mode 100644 drivers/clk/clk-i2c-divider.c
 create mode 100644 drivers/clk/clk-i2c-mux.c
 create mode 100644 drivers/clk/clk-i2c.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 7641965d208d..ffad93ff2c9f 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -23,6 +23,13 @@ config COMMON_CLK
 menu "Common Clock Framework"
 	depends on COMMON_CLK
 
+config COMMON_CLK_I2C
+	bool "Common clock types on I2C"
+	depends on I2C
+	select REGMAP_I2C
+	---help---
+	  Support for clock primitives on the I2C bus.
+
 config COMMON_CLK_WM831X
 	tristate "Clock driver for WM831x/2x PMICs"
 	depends on MFD_WM831X
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index a367a9831717..c4fb243dd51a 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -9,6 +9,11 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-gate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-mux.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
 
+# common clock I2C types
+obj-$(CONFIG_COMMON_CLK_I2C)	+= clk-i2c.o
+obj-$(CONFIG_COMMON_CLK_I2C)	+= clk-i2c-mux.o
+obj-$(CONFIG_COMMON_CLK_I2C)	+= clk-i2c-divider.o
+
 # hardware specific clock types
 # please keep this section sorted lexicographically by file/directory path name
 obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN)	+= clk-axi-clkgen.o
diff --git a/drivers/clk/clk-i2c-divider.c b/drivers/clk/clk-i2c-divider.c
new file mode 100644
index 000000000000..690eae191072
--- /dev/null
+++ b/drivers/clk/clk-i2c-divider.c
@@ -0,0 +1,343 @@
+/*
+ * Copyright (C) 2011 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
+ * Copyright (C) 2011 Richard Zhao, Linaro <richard.zhao@linaro.org>
+ * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
+ * Copyright (C) 2014 Sören Brinkmann, Xilinx Inc. <soren.brinkmann@xilinx.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Adjustable divider clock implementation
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/string.h>
+#include <linux/log2.h>
+
+/*
+ * DOC: basic adjustable divider clock that cannot gate
+ *
+ * Traits of this clock:
+ * prepare - clk_prepare only ensures that parents are prepared
+ * enable - clk_enable only ensures that parents are enabled
+ * rate - rate is adjustable.  clk->rate = parent->rate / divisor
+ * parent - fixed parent.  No clk_set_parent support
+ */
+
+#define to_clk_i2c_divider(_hw) container_of(_hw, struct clk_i2c_divider, hw)
+
+#define div_mask(d)	((1 << ((d)->width)) - 1)
+
+static unsigned int _get_table_maxdiv(const struct clk_div_table *table)
+{
+	unsigned int maxdiv = 0;
+	const struct clk_div_table *clkt;
+
+	for (clkt = table; clkt->div; clkt++)
+		if (clkt->div > maxdiv)
+			maxdiv = clkt->div;
+	return maxdiv;
+}
+
+static unsigned int _get_maxdiv(struct clk_i2c_divider *divider)
+{
+	if (divider->flags & CLK_DIVIDER_ONE_BASED)
+		return div_mask(divider);
+	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+		return 1 << div_mask(divider);
+	if (divider->table)
+		return _get_table_maxdiv(divider->table);
+	return div_mask(divider) + 1;
+}
+
+static unsigned int _get_table_div(const struct clk_div_table *table,
+							unsigned int val)
+{
+	const struct clk_div_table *clkt;
+
+	for (clkt = table; clkt->div; clkt++)
+		if (clkt->val == val)
+			return clkt->div;
+	return 0;
+}
+
+static unsigned int _get_div(struct clk_i2c_divider *divider, unsigned int val)
+{
+	if (divider->flags & CLK_DIVIDER_ONE_BASED)
+		return val;
+	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+		return 1 << val;
+	if (divider->table)
+		return _get_table_div(divider->table, val);
+	return val + 1;
+}
+
+static unsigned int _get_table_val(const struct clk_div_table *table,
+							unsigned int div)
+{
+	const struct clk_div_table *clkt;
+
+	for (clkt = table; clkt->div; clkt++)
+		if (clkt->div == div)
+			return clkt->val;
+	return 0;
+}
+
+static unsigned int _get_val(struct clk_i2c_divider *divider, u8 div)
+{
+	if (divider->flags & CLK_DIVIDER_ONE_BASED)
+		return div;
+	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+		return __ffs(div);
+	if (divider->table)
+		return  _get_table_val(divider->table, div);
+	return div - 1;
+}
+
+static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
+		unsigned long parent_rate)
+{
+	struct clk_i2c_divider *divider = to_clk_i2c_divider(hw);
+	unsigned int div, val;
+
+	val = clk_i2c_readb(divider->regmap, divider->reg) >> divider->shift;
+	val &= div_mask(divider);
+
+	div = _get_div(divider, val);
+	if (!div) {
+		WARN(!(divider->flags & CLK_DIVIDER_ALLOW_ZERO),
+			"%s: Zero divisor and CLK_DIVIDER_ALLOW_ZERO not set\n",
+			__clk_get_name(hw->clk));
+		return parent_rate;
+	}
+
+	return parent_rate / div;
+}
+
+/*
+ * The reverse of DIV_ROUND_UP: The maximum number which
+ * divided by m is r
+ */
+#define MULT_ROUND_UP(r, m) ((r) * (m) + (m) - 1)
+
+static bool _is_valid_table_div(const struct clk_div_table *table,
+							 unsigned int div)
+{
+	const struct clk_div_table *clkt;
+
+	for (clkt = table; clkt->div; clkt++)
+		if (clkt->div == div)
+			return true;
+	return false;
+}
+
+static bool _is_valid_div(struct clk_i2c_divider *divider, unsigned int div)
+{
+	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+		return is_power_of_2(div);
+	if (divider->table)
+		return _is_valid_table_div(divider->table, div);
+	return true;
+}
+
+static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
+		unsigned long *best_parent_rate)
+{
+	struct clk_i2c_divider *divider = to_clk_i2c_divider(hw);
+	int i, bestdiv = 0;
+	unsigned long parent_rate, best = 0, now, maxdiv;
+	unsigned long parent_rate_saved = *best_parent_rate;
+
+	if (!rate)
+		rate = 1;
+
+	maxdiv = _get_maxdiv(divider);
+
+	if (!(__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT)) {
+		parent_rate = *best_parent_rate;
+		bestdiv = DIV_ROUND_UP(parent_rate, rate);
+		bestdiv = bestdiv == 0 ? 1 : bestdiv;
+		bestdiv = bestdiv > maxdiv ? maxdiv : bestdiv;
+		return bestdiv;
+	}
+
+	/*
+	 * The maximum divider we can use without overflowing
+	 * unsigned long in rate * i below
+	 */
+	maxdiv = min(ULONG_MAX / rate, maxdiv);
+
+	for (i = 1; i <= maxdiv; i++) {
+		if (!_is_valid_div(divider, i))
+			continue;
+		if (rate * i == parent_rate_saved) {
+			/*
+			 * It's the most ideal case if the requested rate can be
+			 * divided from parent clock without needing to change
+			 * parent rate, so return the divider immediately.
+			 */
+			*best_parent_rate = parent_rate_saved;
+			return i;
+		}
+		parent_rate = __clk_round_rate(__clk_get_parent(hw->clk),
+				MULT_ROUND_UP(rate, i));
+		now = parent_rate / i;
+		if (now <= rate && now > best) {
+			bestdiv = i;
+			best = now;
+			*best_parent_rate = parent_rate;
+		}
+	}
+
+	if (!bestdiv) {
+		bestdiv = _get_maxdiv(divider);
+		*best_parent_rate = __clk_round_rate(__clk_get_parent(hw->clk), 1);
+	}
+
+	return bestdiv;
+}
+
+static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long *prate)
+{
+	int div;
+	div = clk_divider_bestdiv(hw, rate, prate);
+
+	return *prate / div;
+}
+
+static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long parent_rate)
+{
+	struct clk_i2c_divider *divider = to_clk_i2c_divider(hw);
+	unsigned int div, value;
+	unsigned long flags = 0;
+	u32 val;
+
+	div = parent_rate / rate;
+	value = _get_val(divider, div);
+
+	if (value > div_mask(divider))
+		value = div_mask(divider);
+
+	if (divider->flags & CLK_DIVIDER_HIWORD_MASK) {
+		val = div_mask(divider) << (divider->shift + 16);
+	} else {
+		val = clk_i2c_readb(divider->regmap, divider->reg);
+		val &= ~(div_mask(divider) << divider->shift);
+	}
+	val |= value << divider->shift;
+	clk_i2c_writeb(val, divider->regmap, divider->reg);
+
+	return 0;
+}
+
+const struct clk_ops clk_i2c_divider_ops = {
+	.recalc_rate = clk_divider_recalc_rate,
+	.round_rate = clk_divider_round_rate,
+	.set_rate = clk_divider_set_rate,
+};
+EXPORT_SYMBOL_GPL(clk_i2c_divider_ops);
+
+static struct clk *_register_divider(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		struct regmap *regmap, unsigned int reg, u8 shift, u8 width,
+		u8 clk_divider_flags, const struct clk_div_table *table)
+{
+	struct clk_i2c_divider *div;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	if (!dev) {
+		pr_err("%s: invalid argument \'dev\'(%p)\n", __func__, dev);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (clk_divider_flags & CLK_DIVIDER_HIWORD_MASK) {
+		if (width + shift > 16) {
+			pr_warn("divider value exceeds LOWORD field\n");
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	/* allocate the divider */
+	div = kzalloc(sizeof(*div), GFP_KERNEL);
+	if (!div) {
+		pr_err("%s: could not allocate divider clk\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	init.name = name;
+	init.ops = &clk_i2c_divider_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name: NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	/* struct clk_i2c_divider assignments */
+	div->regmap = regmap;
+	div->reg = reg;
+	div->shift = shift;
+	div->width = width;
+	div->flags = clk_divider_flags;
+	div->hw.init = &init;
+	div->table = table;
+
+	/* register the clock */
+	clk = devm_clk_register(dev, &div->hw);
+
+	if (IS_ERR(clk))
+		kfree(div);
+
+	return clk;
+}
+
+/**
+ * clk_register_divider - register a divider clock with the clock framework
+ * @dev: device registering this clock
+ * @name: name of this clock
+ * @parent_name: name of clock's parent
+ * @flags: framework-specific flags
+ * @regmap: I2C regmap to access device
+ * @reg: register address to adjust divider
+ * @shift: number of bits to shift the bitfield
+ * @width: width of the bitfield
+ * @clk_divider_flags: divider-specific flags for this clock
+ */
+struct clk *clk_i2c_register_divider(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		struct regmap *regmap, unsigned int reg, u8 shift, u8 width,
+		u8 clk_divider_flags)
+{
+	return _register_divider(dev, name, parent_name, flags, regmap, reg,
+			shift, width, clk_divider_flags, NULL);
+}
+EXPORT_SYMBOL_GPL(clk_i2c_register_divider);
+
+/**
+ * clk_register_divider_table - register a table based divider clock with
+ * the clock framework
+ * @dev: device registering this clock
+ * @name: name of this clock
+ * @parent_name: name of clock's parent
+ * @flags: framework-specific flags
+ * @regmap: I2C regmap to access device
+ * @reg: register address to adjust divider
+ * @shift: number of bits to shift the bitfield
+ * @width: width of the bitfield
+ * @clk_divider_flags: divider-specific flags for this clock
+ * @table: array of divider/value pairs ending with a div set to 0
+ */
+struct clk *clk_i2c_register_divider_table(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		struct regmap *regmap, unsigned int reg, u8 shift, u8 width,
+		u8 clk_divider_flags, const struct clk_div_table *table)
+{
+	return _register_divider(dev, name, parent_name, flags, regmap, reg,
+			shift, width, clk_divider_flags, table);
+}
+EXPORT_SYMBOL_GPL(clk_i2c_register_divider_table);
diff --git a/drivers/clk/clk-i2c-mux.c b/drivers/clk/clk-i2c-mux.c
new file mode 100644
index 000000000000..c5e23c98f964
--- /dev/null
+++ b/drivers/clk/clk-i2c-mux.c
@@ -0,0 +1,173 @@
+/*
+ * Copyright (C) 2011 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
+ * Copyright (C) 2011 Richard Zhao, Linaro <richard.zhao@linaro.org>
+ * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
+ * Copyright (C) 2014 Sören Brinkmann, Xilinx Inc. <soren.brinkmann@xilinx.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Simple multiplexer clock implementation
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/err.h>
+
+/*
+ * DOC: basic adjustable multiplexer clock that cannot gate
+ *
+ * Traits of this clock:
+ * prepare - clk_prepare only ensures that parents are prepared
+ * enable - clk_enable only ensures that parents are enabled
+ * rate - rate is only affected by parent switching.  No clk_set_rate support
+ * parent - parent is adjustable through clk_set_parent
+ */
+
+#define to_clk_i2c_mux(_hw) container_of(_hw, struct clk_i2c_mux, hw)
+
+static u8 clk_mux_get_parent(struct clk_hw *hw)
+{
+	struct clk_i2c_mux *mux = to_clk_i2c_mux(hw);
+	int num_parents = __clk_get_num_parents(hw->clk);
+	u32 val;
+
+	/*
+	 * FIXME need a mux-specific flag to determine if val is bitwise or numeric
+	 * e.g. sys_clkin_ck's clksel field is 3 bits wide, but ranges from 0x1
+	 * to 0x7 (index starts at one)
+	 * OTOH, pmd_trace_clk_mux_ck uses a separate bit for each clock, so
+	 * val = 0x4 really means "bit 2, index starts at bit 0"
+	 */
+	val = clk_i2c_readb(mux->regmap, mux->reg) >> mux->shift;
+	val &= mux->mask;
+
+	if (mux->table) {
+		int i;
+
+		for (i = 0; i < num_parents; i++)
+			if (mux->table[i] == val)
+				return i;
+		return -EINVAL;
+	}
+
+	if (val && (mux->flags & CLK_MUX_INDEX_BIT))
+		val = ffs(val) - 1;
+
+	if (val && (mux->flags & CLK_MUX_INDEX_ONE))
+		val--;
+
+	if (val >= num_parents)
+		return -EINVAL;
+
+	return val;
+}
+
+static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_i2c_mux *mux = to_clk_i2c_mux(hw);
+	u32 val;
+
+	if (mux->table)
+		index = mux->table[index];
+
+	else {
+		if (mux->flags & CLK_MUX_INDEX_BIT)
+			index = (1 << ffs(index));
+
+		if (mux->flags & CLK_MUX_INDEX_ONE)
+			index++;
+	}
+
+	if (mux->flags & CLK_MUX_HIWORD_MASK) {
+		val = mux->mask << (mux->shift + 16);
+	} else {
+		val = clk_i2c_readb(mux->regmap, mux->reg);
+		val &= ~(mux->mask << mux->shift);
+	}
+	val |= index << mux->shift;
+	clk_i2c_writeb(val, mux->regmap, mux->reg);
+
+	return 0;
+}
+
+const struct clk_ops clk_i2c_mux_ops = {
+	.get_parent = clk_mux_get_parent,
+	.set_parent = clk_mux_set_parent,
+	.determine_rate = __clk_mux_determine_rate,
+};
+EXPORT_SYMBOL_GPL(clk_i2c_mux_ops);
+
+const struct clk_ops clk_i2c_mux_ro_ops = {
+	.get_parent = clk_mux_get_parent,
+};
+EXPORT_SYMBOL_GPL(clk_i2c_mux_ro_ops);
+
+struct clk *clk_i2c_register_mux_table(struct device *dev, const char *name,
+		const char **parent_names, u8 num_parents, unsigned long flags,
+		struct regmap *regmap, unsigned int reg, u8 shift, u32 mask,
+		u8 clk_mux_flags, u32 *table)
+{
+	struct clk_i2c_mux *mux;
+	struct clk *clk;
+	struct clk_init_data init;
+	u8 width = 0;
+
+	if (clk_mux_flags & CLK_MUX_HIWORD_MASK) {
+		width = fls(mask) - ffs(mask) + 1;
+		if (width + shift > 16) {
+			pr_err("mux value exceeds LOWORD field\n");
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	/* allocate the mux */
+	mux = kzalloc(sizeof(struct clk_i2c_mux), GFP_KERNEL);
+	if (!mux) {
+		pr_err("%s: could not allocate mux clk\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	init.name = name;
+	if (clk_mux_flags & CLK_MUX_READ_ONLY)
+		init.ops = &clk_i2c_mux_ro_ops;
+	else
+		init.ops = &clk_i2c_mux_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+
+	/* struct clk_i2c_mux assignments */
+	mux->regmap = regmap;
+	mux->reg = reg;
+	mux->shift = shift;
+	mux->mask = mask;
+	mux->flags = clk_mux_flags;
+	mux->table = table;
+	mux->hw.init = &init;
+
+	clk = clk_register(dev, &mux->hw);
+
+	if (IS_ERR(clk))
+		kfree(mux);
+
+	return clk;
+}
+EXPORT_SYMBOL_GPL(clk_i2c_register_mux_table);
+
+struct clk *clk_i2c_register_mux(struct device *dev, const char *name,
+		const char **parent_names, u8 num_parents, unsigned long flags,
+		struct regmap *regmap, unsigned int reg, u8 shift, u8 width,
+		u8 clk_mux_flags)
+{
+	u32 mask = BIT(width) - 1;
+
+	return clk_i2c_register_mux_table(dev, name, parent_names, num_parents,
+				      flags, regmap, reg, shift, mask,
+				      clk_mux_flags, NULL);
+}
+EXPORT_SYMBOL_GPL(clk_i2c_register_mux);
diff --git a/drivers/clk/clk-i2c.c b/drivers/clk/clk-i2c.c
new file mode 100644
index 000000000000..cc1f89cbd313
--- /dev/null
+++ b/drivers/clk/clk-i2c.c
@@ -0,0 +1,22 @@
+#include <linux/clk-provider.h>
+
+u8 clk_i2c_readb(struct regmap *regmap, unsigned int reg)
+{
+	unsigned int val;
+	int err = regmap_read(regmap, reg, &val);
+
+	if (err) {
+		pr_err("%s: read from device failed\n", __func__);
+		return 0;
+	}
+
+	return val;
+}
+
+void clk_i2c_writeb(u8 val, struct regmap *regmap,
+		unsigned int reg)
+{
+	int err = regmap_write(regmap, reg, val);
+	if (err)
+		pr_err("%s: write to device failed\n", __func__);
+}
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 939533da93a7..d86bb6ec4232 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -315,6 +315,46 @@ struct clk_divider {
 	spinlock_t	*lock;
 };
 
+/**
+ * struct clk_i2c_divider - adjustable divider clock
+ *
+ * @hw:		handle between common and hardware-specific interfaces
+ * @regmap:	Regmap to access device
+ * @reg:	register containing the divider
+ * @shift:	shift to the divider bit field
+ * @width:	width of the divider bit field
+ * @table:	array of value/divider pairs, last entry should have div = 0
+ *
+ * Clock with an adjustable divider affecting its output frequency.  Implements
+ * .recalc_rate, .set_rate and .round_rate
+ *
+ * Flags:
+ * CLK_DIVIDER_ONE_BASED - by default the divisor is the value read from the
+ * 	register plus one.  If CLK_DIVIDER_ONE_BASED is set then the divider is
+ * 	the raw value read from the register, with the value of zero considered
+ *	invalid, unless CLK_DIVIDER_ALLOW_ZERO is set.
+ * CLK_DIVIDER_POWER_OF_TWO - clock divisor is 2 raised to the value read from
+ * 	the hardware register
+ * CLK_DIVIDER_ALLOW_ZERO - Allow zero divisors.  For dividers which have
+ *	CLK_DIVIDER_ONE_BASED set, it is possible to end up with a zero divisor.
+ *	Some hardware implementations gracefully handle this case and allow a
+ *	zero divisor by not modifying their input clock
+ *	(divide by one / bypass).
+ * CLK_DIVIDER_HIWORD_MASK - The divider settings are only in lower 16-bit
+ *   of this register, and mask of divider bits are in higher 16-bit of this
+ *   register.  While setting the divider bits, higher 16-bit should also be
+ *   updated to indicate changing divider bits.
+ */
+struct clk_i2c_divider {
+	struct clk_hw	hw;
+	struct regmap	*regmap;
+	unsigned int	reg;
+	u8		shift;
+	u8		width;
+	u8		flags;
+	const struct clk_div_table	*table;
+};
+
 #define CLK_DIVIDER_ONE_BASED		BIT(0)
 #define CLK_DIVIDER_POWER_OF_TWO	BIT(1)
 #define CLK_DIVIDER_ALLOW_ZERO		BIT(2)
@@ -362,6 +402,37 @@ struct clk_mux {
 	spinlock_t	*lock;
 };
 
+/**
+ * struct clk_i2c_mux - multiplexer clock
+ *
+ * @hw:		handle between common and hardware-specific interfaces
+ * @regmap:	regmap handle for the device
+ * @reg:	register controlling multiplexer
+ * @shift:	shift to multiplexer bit field
+ * @width:	width of mutliplexer bit field
+ * @flags:	hardware-specific flags
+ *
+ * Clock with multiple selectable parents.  Implements .get_parent, .set_parent
+ * and .recalc_rate
+ *
+ * Flags:
+ * CLK_MUX_INDEX_ONE - register index starts at 1, not 0
+ * CLK_MUX_INDEX_BIT - register index is a single bit (power of two)
+ * CLK_MUX_HIWORD_MASK - The mux settings are only in lower 16-bit of this
+ *   register, and mask of mux bits are in higher 16-bit of this register.
+ *   While setting the mux bits, higher 16-bit should also be updated to
+ *   indicate changing mux bits.
+ */
+struct clk_i2c_mux {
+	struct clk_hw	hw;
+	struct regmap	*regmap;
+	unsigned int	reg;
+	u32		*table;
+	u32		mask;
+	u8		shift;
+	u8		flags;
+};
+
 #define CLK_MUX_INDEX_ONE		BIT(0)
 #define CLK_MUX_INDEX_BIT		BIT(1)
 #define CLK_MUX_HIWORD_MASK		BIT(2)
@@ -570,5 +641,29 @@ static inline void clk_writel(u32 val, u32 __iomem *reg)
 
 #endif	/* platform dependent I/O accessors */
 
+#ifdef CONFIG_COMMON_CLK_I2C
+#include <linux/regmap.h>
+u8 clk_i2c_readb(struct regmap *regmap, unsigned int reg);
+void clk_i2c_writeb(u8 val, struct regmap *regmap, unsigned int reg);
+
+struct clk *clk_i2c_register_mux(struct device *dev, const char *name,
+		const char **parent_names, u8 num_parents, unsigned long flags,
+		struct regmap *regmap, unsigned int reg, u8 shift, u8 width,
+		u8 clk_mux_flags);
+
+struct clk *clk_i2c_register_mux_table(struct device *dev, const char *name,
+		const char **parent_names, u8 num_parents, unsigned long flags,
+		struct regmap *regmap, unsigned int reg, u8 shift, u32 mask,
+		u8 clk_mux_flags, u32 *table);
+struct clk *clk_i2c_register_divider(struct device *dev, const char *name,
+                const char *parent_name, unsigned long flags,
+                struct regmap *regmap, unsigned int reg, u8 shift, u8 width,
+                u8 clk_divider_flags);
+struct clk *clk_i2c_register_divider_table(struct device *dev, const char *name, 
+                const char *parent_name, unsigned long flags,
+                struct regmap *regmap, unsigned int reg, u8 shift, u8 width,
+                u8 clk_divider_flags, const struct clk_div_table *table);
+#endif /* CONFIG_COMMON_CLK_I2C */
+
 #endif /* CONFIG_COMMON_CLK */
 #endif /* CLK_PROVIDER_H */
-- 
1.9.0.1.g4196000

