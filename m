Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbaEKUZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 16:25:41 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63424 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669AbaEKUYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 16:24:54 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] clk: berlin: add driver for BG2x complex divider cells
Date: Sun, 11 May 2014 22:24:38 +0200
Message-Id: <1399839881-29895-6-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>

This is a driver for the complex divider cells found on Marvell Berlin2
SoCs. The cells come in two flavors: single register cells and shared
register cells. The single register cells are registered by using a DT
node, while the shared ones will be taken care of in a SoC-specific
core clock driver.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/berlin/Makefile      |   2 +-
 drivers/clk/berlin/berlin2-div.c | 326 +++++++++++++++++++++++++++++++++++++++
 drivers/clk/berlin/berlin2-div.h |  80 ++++++++++
 3 files changed, 407 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/berlin/berlin2-div.c
 create mode 100644 drivers/clk/berlin/berlin2-div.h

diff --git a/drivers/clk/berlin/Makefile b/drivers/clk/berlin/Makefile
index 9d3490e9782f..f0a7dc8b5e30 100644
--- a/drivers/clk/berlin/Makefile
+++ b/drivers/clk/berlin/Makefile
@@ -1 +1 @@
-obj-y += berlin2-avpll.o berlin2-pll.o
+obj-y += berlin2-avpll.o berlin2-pll.o berlin2-div.o
diff --git a/drivers/clk/berlin/berlin2-div.c b/drivers/clk/berlin/berlin2-div.c
new file mode 100644
index 000000000000..96513a6e8ca7
--- /dev/null
+++ b/drivers/clk/berlin/berlin2-div.c
@@ -0,0 +1,326 @@
+/*
+ * Copyright (c) 2014 Marvell Technology Group Ltd.
+ *
+ * Alexandre Belloni <alexandre.belloni@free-electrons.com>
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/bitops.h>
+#include <linux/clk-provider.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include "berlin2-div.h"
+
+/*
+ * Clock dividers in Berlin2 SoCs comprise a complex cell to select
+ * input pll and divider. The virtual structure as it is used in Marvell
+ * BSP code can be seen as:
+ *
+ *                      +---+
+ * pll0 --------------->| 0 |                   +---+
+ *           +---+      |(B)|--+--------------->| 0 |      +---+
+ * pll1.0 -->| 0 |  +-->| 1 |  |   +--------+   |(E)|----->| 0 |   +---+
+ * pll1.1 -->| 1 |  |   +---+  +-->|(C) 1:M |-->| 1 |      |(F)|-->|(G)|->
+ * ...    -->|(A)|--+          |   +--------+   +---+  +-->| 1 |   +---+
+ * ...    -->|   |             +-->|(D) 1:3 |----------+   +---+
+ * pll1.N -->| N |                 +---------
+ *           +---+
+ *
+ * (A) input pll clock mux controlled by               <PllSelect[1:n]>
+ * (B) input pll bypass mux controlled by              <PllSwitch>
+ * (C) programmable clock divider controlled by        <Select[1:n]>
+ * (D) constant div-by-3 clock divider
+ * (E) programmable clock divider bypass controlled by <Switch>
+ * (F) constant div-by-3 clock mux controlled by       <D3Switch>
+ * (G) clock gate controlled by                        <Enable>
+ *
+ * For whatever reason, above control signals come in two flavors:
+ * - single register dividers with all bits in one register
+ * - shared register dividers with bits spread over multiple registers
+ *   (including signals for the same cell spread over consecutive registers)
+ *
+ * Also, clock gate and pll mux is not available on every div cell, so
+ * we have to deal with those, too. We reuse common clock composite driver
+ * for it.
+ */
+
+#define PLL_SELECT_MASK	0x7
+#define DIV_SELECT_MASK	0x7
+
+struct berlin2_div {
+	struct clk_hw hw;
+	void __iomem *base;
+	struct berlin2_div_map map;
+	spinlock_t *lock;
+};
+
+#define to_berlin2_div(hw) container_of(hw, struct berlin2_div, hw)
+
+static u8 clk_div[] = { 1, 2, 4, 6, 8, 12, 1, 1 };
+
+static int berlin2_div_is_enabled(struct clk_hw *hw)
+{
+	struct berlin2_div *div = to_berlin2_div(hw);
+	struct berlin2_div_map *map = &div->map;
+	u32 reg;
+
+	if (div->lock)
+		spin_lock(div->lock);
+
+	reg = readl_relaxed(div->base + map->gate_offs);
+	reg >>= map->gate_shift;
+
+	if (div->lock)
+		spin_unlock(div->lock);
+
+	return (reg & 0x1);
+}
+
+static int berlin2_div_enable(struct clk_hw *hw)
+{
+	struct berlin2_div *div = to_berlin2_div(hw);
+	struct berlin2_div_map *map = &div->map;
+	u32 reg;
+
+	if (div->lock)
+		spin_lock(div->lock);
+
+	reg = readl_relaxed(div->base + map->gate_offs);
+	reg |= BIT(map->gate_shift);
+	writel_relaxed(reg, div->base + map->gate_offs);
+
+	if (div->lock)
+		spin_unlock(div->lock);
+
+	return 0;
+}
+
+static void berlin2_div_disable(struct clk_hw *hw)
+{
+	struct berlin2_div *div = to_berlin2_div(hw);
+	struct berlin2_div_map *map = &div->map;
+	u32 reg;
+
+	if (div->lock)
+		spin_lock(div->lock);
+
+	reg = readl_relaxed(div->base + map->gate_offs);
+	reg &= ~BIT(map->gate_shift);
+	writel_relaxed(reg, div->base + map->gate_offs);
+
+	if (div->lock)
+		spin_unlock(div->lock);
+}
+
+static int berlin2_div_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct berlin2_div *div = to_berlin2_div(hw);
+	struct berlin2_div_map *map = &div->map;
+	u32 reg;
+
+	if (div->lock)
+		spin_lock(div->lock);
+
+	/* index == 0 is PLL_SWITCH */
+	reg = readl_relaxed(div->base + map->pll_switch_offs);
+	if (index == 0)
+		reg &= ~BIT(map->pll_switch_shift);
+	else
+		reg |= BIT(map->pll_switch_shift);
+	writel_relaxed(reg, div->base + map->pll_switch_offs);
+
+	/* index > 0 is PLL_SELECT */
+	if (index > 0) {
+		reg = readl_relaxed(div->base + map->pll_select_offs);
+		reg &= ~(PLL_SELECT_MASK << map->pll_select_shift);
+		reg |= (index - 1) << map->pll_select_shift;
+		writel_relaxed(reg, div->base + map->pll_select_offs);
+	}
+
+	if (div->lock)
+		spin_unlock(div->lock);
+
+	return 0;
+}
+
+static u8 berlin2_div_get_parent(struct clk_hw *hw)
+{
+	struct berlin2_div *div = to_berlin2_div(hw);
+	struct berlin2_div_map *map = &div->map;
+	u32 reg;
+	u8 index = 0;
+
+	if (div->lock)
+		spin_lock(div->lock);
+
+	/* PLL_SWITCH == 0 is index 0 */
+	reg = readl_relaxed(div->base + map->pll_switch_offs);
+	reg &= BIT(map->pll_switch_shift);
+	if (reg) {
+		reg = readl_relaxed(div->base + map->pll_select_offs);
+		reg >>= map->pll_select_shift;
+		reg &= PLL_SELECT_MASK;
+		index = 1 + reg;
+	}
+
+	if (div->lock)
+		spin_unlock(div->lock);
+
+	return index;
+}
+
+static unsigned long berlin2_div_recalc_rate(struct clk_hw *hw,
+					     unsigned long parent_rate)
+{
+	struct berlin2_div *div = to_berlin2_div(hw);
+	struct berlin2_div_map *map = &div->map;
+	u32 divsw, div3sw, divider = 1;
+
+	if (div->lock)
+		spin_lock(div->lock);
+
+	divsw = readl_relaxed(div->base + map->div_switch_offs) &
+		(1 << map->div_switch_shift);
+	div3sw = readl_relaxed(div->base + map->div3_switch_offs) &
+		(1 << map->div3_switch_shift);
+
+	/* constant divide-by-3 (dominant) */
+	if (div3sw == 1) {
+		divider = 3;
+	/* divider can be bypassed with DIV_SWITCH == 0 */
+	} else if (divsw == 0) {
+		divider = 1;
+	/* clock divider determined by DIV_SELECT */
+	} else {
+		u32 reg;
+		reg = readl_relaxed(div->base + map->div_select_offs);
+		reg >>= map->div_select_shift;
+		reg &= DIV_SELECT_MASK;
+		divider = clk_div[reg];
+	}
+
+	if (div->lock)
+		spin_unlock(div->lock);
+
+	return parent_rate / divider;
+}
+
+static const struct clk_ops berlin2_div_rate_ops = {
+	.recalc_rate	= berlin2_div_recalc_rate,
+};
+
+static const struct clk_ops berlin2_div_gate_ops = {
+	.is_enabled	= berlin2_div_is_enabled,
+	.enable		= berlin2_div_enable,
+	.disable	= berlin2_div_disable,
+};
+
+static const struct clk_ops berlin2_div_mux_ops = {
+	.set_parent	= berlin2_div_set_parent,
+	.get_parent	= berlin2_div_get_parent,
+};
+
+struct clk * __init
+berlin2_div_register(const struct berlin2_div_map *map,
+		     void __iomem *base, const char *name, u8 div_flags,
+		     const char **parent_names, int num_parents,
+		     unsigned long flags, spinlock_t *lock)
+{
+	const struct clk_ops *mux_ops = &berlin2_div_mux_ops;
+	const struct clk_ops *rate_ops = &berlin2_div_rate_ops;
+	const struct clk_ops *gate_ops = &berlin2_div_gate_ops;
+	struct berlin2_div *div;
+
+	div = kzalloc(sizeof(*div), GFP_KERNEL);
+	if (!div)
+		return ERR_PTR(-ENOMEM);
+
+	/* copy div_map to allow __initconst */
+	memcpy(&div->map, map, sizeof(*map));
+	div->base = base;
+	div->lock = lock;
+
+	if ((div_flags & BERLIN2_DIV_HAS_GATE) == 0)
+		gate_ops = NULL;
+	if ((div_flags & BERLIN2_DIV_HAS_MUX) == 0)
+		mux_ops = NULL;
+
+	return clk_register_composite(NULL, name, parent_names, num_parents,
+				      &div->hw, mux_ops, &div->hw, rate_ops,
+				      &div->hw, gate_ops, flags);
+}
+
+static const struct berlin2_div_map berlin2_single_div_map __initconst = {
+	.gate_offs = 0,
+	.gate_shift = 0,
+	.pll_select_offs = 0,
+	.pll_select_shift = 1,
+	.pll_switch_offs = 0,
+	.pll_switch_shift = 4,
+	.div_switch_offs = 0,
+	.div_switch_shift = 5,
+	.div3_switch_offs = 0,
+	.div3_switch_shift = 6,
+	.div_select_offs = 0,
+	.div_select_shift = 7,
+};
+
+static void __init berlin2_div_of_setup(struct device_node *np)
+{
+	const char *parent_names[9] = {};
+	char *mux_name = "mux0";
+	int num_parents = 0;
+	void __iomem *base;
+	struct clk *iclk;
+	struct clk *div;
+	char *div_name;
+	int n;
+
+	iclk = of_clk_get_by_name(np, "mux_bypass");
+	if (IS_ERR(iclk)) {
+		pr_err("%s: Missing mux bypass clock\n", np->full_name);
+		return;
+	}
+	parent_names[0] = __clk_get_name(iclk);
+	clk_put(iclk);
+
+	/* collect mux input clock names */
+	for (n = 0; n < 8; n++) {
+		sprintf(mux_name, "mux%d", n);
+		iclk = of_clk_get_by_name(np, mux_name);
+		if (IS_ERR(iclk))
+			continue;
+		parent_names[1 + n] = __clk_get_name(iclk);
+		clk_put(iclk);
+	}
+
+	base = of_iomap(np, 0);
+	if (!base) {
+		pr_err("%s: Unable to map div register\n", np->full_name);
+		return;
+	}
+
+	div_name = of_clk_create_name(np);
+	div = berlin2_div_register(&berlin2_single_div_map, base, div_name,
+				   BERLIN2_DIV_HAS_GATE | BERLIN2_DIV_HAS_MUX,
+				   parent_names, num_parents, 0, NULL);
+	if (!IS_ERR(div))
+		of_clk_add_provider(np, of_clk_src_simple_get, div);
+
+	kfree(div_name);
+}
+CLK_OF_DECLARE(berlin2_div, "marvell,berlin2-div", berlin2_div_of_setup);
diff --git a/drivers/clk/berlin/berlin2-div.h b/drivers/clk/berlin/berlin2-div.h
new file mode 100644
index 000000000000..344865181712
--- /dev/null
+++ b/drivers/clk/berlin/berlin2-div.h
@@ -0,0 +1,80 @@
+/*
+ * Copyright (c) 2014 Marvell Technology Group Ltd.
+ *
+ * Alexandre Belloni <alexandre.belloni@free-electrons.com>
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __BERLIN2_DIV_H
+#define __BERLIN2_DIV_H
+
+#include <linux/clk.h>
+#include <linux/spinlock.h>
+
+#define BERLIN2_DIV_HAS_GATE	BIT(0)
+#define BERLIN2_DIV_HAS_MUX	BIT(1)
+
+#define BERLIN2_PLL_SELECT(_off, _sh)	\
+	.pll_select_offs = _off,	\
+	.pll_select_shift = _sh
+
+#define BERLIN2_PLL_SWITCH(_off, _sh)	\
+	.pll_switch_offs = _off,	\
+	.pll_switch_shift = _sh
+
+#define BERLIN2_DIV_SELECT(_off, _sh)	\
+	.div_select_offs = _off,	\
+	.div_select_shift = _sh
+
+#define BERLIN2_DIV_SWITCH(_off, _sh)	\
+	.div_switch_offs = _off,	\
+	.div_switch_shift = _sh
+
+#define BERLIN2_DIV_D3SWITCH(_off, _sh)	\
+	.div3_switch_offs = _off,	\
+	.div3_switch_shift = _sh
+
+#define BERLIN2_DIV_GATE(_off, _sh)	\
+	.gate_offs = _off,		\
+	.gate_shift = _sh
+
+struct berlin2_div_map {
+	u16 pll_select_offs;
+	u16 pll_switch_offs;
+	u16 div_select_offs;
+	u16 div_switch_offs;
+	u16 div3_switch_offs;
+	u16 gate_offs;
+	u8 pll_select_shift;
+	u8 pll_switch_shift;
+	u8 div_select_shift;
+	u8 div_switch_shift;
+	u8 div3_switch_shift;
+	u8 gate_shift;
+};
+
+struct berlin2_div_data {
+	const char *name;
+	unsigned long flags;
+	struct berlin2_div_map map;
+	u8 div_flags;
+};
+
+struct clk * __init
+berlin2_div_register(const struct berlin2_div_map *map,
+	     void __iomem *base,  const char *name, u8 div_flags,
+	     const char **parent_names, int num_parents,
+	     unsigned long flags,  spinlock_t *lock);
+
+#endif /* BERLIN2_DIV_H */
-- 
1.9.1

