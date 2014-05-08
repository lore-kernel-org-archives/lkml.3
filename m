Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaEHURM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:17:12 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38407 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbaEHURF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:17:05 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 2/3] clk: berlin: add driver for BG2x complex divider cells
Date: Thu,  8 May 2014 22:16:51 +0200
Message-Id: <1399580212-30183-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1399580212-30183-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1399580212-30183-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is some awkward ASCII-art describing the basic structure
of the cell.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/berlin/berlin2-div.c | 261 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 261 insertions(+)
 create mode 100644 drivers/clk/berlin/berlin2-div.c

diff --git a/drivers/clk/berlin/berlin2-div.c b/drivers/clk/berlin/berlin2-div.c
new file mode 100644
index 000000000000..ef8f7583a78f
--- /dev/null
+++ b/drivers/clk/berlin/berlin2-div.c
@@ -0,0 +1,261 @@
+/*
+ * Copyright (c) 2014 Marvell Technology Group Ltd.
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
+#include "common.h"
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
+ * we have to deal with those, too.
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
+	spin_lock(div->lock);
+
+	reg = readl_relaxed(div->base + map->gate_offs);
+	reg >>= map->gate_shift;
+
+	spin_unlock(div->lock);
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
+	spin_lock(div->lock);
+
+	reg = readl_relaxed(div->base + map->gate_offs);
+	reg |= BIT(map->gate_shift);
+	writel_relaxed(reg, div->base + map->gate_offs);
+
+	spin_unlock(div->lock);
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
+	spin_lock(div->lock);
+
+	reg = readl_relaxed(div->base + map->gate_offs);
+	reg &= ~BIT(map->gate_shift);
+	writel_relaxed(reg, div->base + map->gate_offs);
+
+	spin_unlock(div->lock);
+}
+
+static int berlin2_div_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct berlin2_div *div = to_berlin2_div(hw);
+	struct berlin2_div_map *map = &div->map;
+	u32 reg;
+
+	spin_lock(div->lock);
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
+	spin_unlock(div->lock);
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
+	spin_lock(div->lock);
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
+	spin_unlock(div->lock);
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
+	spin_lock(div->lock);
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
+	spin_unlock(div->lock);
+
+	return parent_rate / divider;
+}
+
+static const struct clk_ops berlin2_div_full_ops = {
+	.is_enabled	= berlin2_div_is_enabled,
+	.enable		= berlin2_div_enable,
+	.disable	= berlin2_div_disable,
+	.recalc_rate	= berlin2_div_recalc_rate,
+	.set_parent	= berlin2_div_set_parent,
+	.get_parent	= berlin2_div_get_parent,
+};
+
+static const struct clk_ops berlin2_div_no_gate_ops = {
+	.recalc_rate	= berlin2_div_recalc_rate,
+	.set_parent	= berlin2_div_set_parent,
+	.get_parent	= berlin2_div_get_parent,
+};
+
+static const struct clk_ops berlin2_div_no_pll_mux_ops = {
+	.is_enabled	= berlin2_div_is_enabled,
+	.enable		= berlin2_div_enable,
+	.disable	= berlin2_div_disable,
+	.recalc_rate	= berlin2_div_recalc_rate,
+};
+
+struct clk * __init
+berlin2_div_register(const struct berlin2_div_map *map,
+		     void __iomem *base, const char *name,
+		     const char **parent_names, int num_parents,
+		     unsigned long flags, spinlock_t *lock)
+{
+	struct clk_init_data init;
+	struct berlin2_div *div;
+
+	div = kzalloc(sizeof(*div), GFP_KERNEL);
+	if (!div)
+		return ERR_PTR(-ENOMEM);
+
+	/* copy div_map to allow __initconst */
+	memcpy(&div->map, map, sizeof(*map));
+
+	init.name = name;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+	init.flags = flags;
+
+	if (!map->has_gate)
+		init.ops = &berlin2_div_no_gate_ops;
+	else if (!map->has_pll_switch || !map->has_pll_select)
+		init.ops = &berlin2_div_no_pll_mux_ops;
+	else
+		init.ops = &berlin2_div_full_ops;
+
+	div->base = base;
+	div->lock = lock;
+	div->hw.init = &init;
+
+	return clk_register(NULL, &div->hw);
+}
-- 
1.9.1

