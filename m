Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaDYUAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:00:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49598 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753571AbaDYUAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:00:40 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [RFC 1/5] clk: berlin: add support for clock groups
Date: Fri, 25 Apr 2014 22:00:19 +0200
Message-Id: <1398456024-27876-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398456024-27876-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1398456024-27876-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for clocks sharing the same register set.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/clk/berlin/Makefile |   2 +-
 drivers/clk/berlin/grp.c    | 208 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 209 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/berlin/grp.c

diff --git a/drivers/clk/berlin/Makefile b/drivers/clk/berlin/Makefile
index 9bfa58eaf25a..893b2f2ba4fa 100644
--- a/drivers/clk/berlin/Makefile
+++ b/drivers/clk/berlin/Makefile
@@ -1,4 +1,4 @@
-obj-y += pll.o clk.o
+obj-y += pll.o clk.o grp.o
 obj-$(CONFIG_MACH_BERLIN_BG2)   += pll-berlin2.o
 obj-$(CONFIG_MACH_BERLIN_BG2CD) += pll-berlin2.o
 obj-$(CONFIG_MACH_BERLIN_BG2Q)  += pll-berlin2q.o
diff --git a/drivers/clk/berlin/grp.c b/drivers/clk/berlin/grp.c
new file mode 100644
index 000000000000..9e11e634ae20
--- /dev/null
+++ b/drivers/clk/berlin/grp.c
@@ -0,0 +1,208 @@
+/*
+ * Copyright (c) 2014 Marvell Technology Group Ltd.
+ *
+ * Based on code from Jisheng Zhang <jszhang@marvell.com>
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
+
+#include "common.h"
+
+/*
+ * The clocks are sharing two kind of registers, the switch registers and the
+ * selection registers.
+ *
+ * The berlin_clkgrp struct has an offset (in bits) to the first bit related to
+ * the clock, from the start of the switch or selection region.
+ *
+ * The layout in the switch register is:
+ *        2         1        0
+ *  +----------+--------+--------+
+ *  | DIV3 SW  | DIV SW | PLL SW |
+ *  +----------+--------+--------+
+ *
+ *
+ * The layout in the selection register is:
+ *    5   4   3   2   1   0
+ *  +---+---+---+---+---+---+
+ *  |  DIVISOR  |    PLL    |
+ *  +---+---+---+---+---+---+
+ *
+ */
+
+#define CLK_PLL_SWITCH		BIT(0)
+#define CLK_SWITCH		BIT(1)
+#define CLK_DIV3_SWITCH		BIT(2)
+
+#define CLK_PLLSEL_MASK		7
+#define CLK_SEL_MASK		7
+#define CLK_SEL_SHIFT		3
+
+struct berlin_clkgrp_regs {
+	void __iomem *switch_base;
+	void __iomem *select_base;
+};
+
+struct berlin_clkgrp {
+	struct clk_hw hw;
+	struct berlin_clkgrp_regs *regs;
+	u32 switch_offset;
+	u32 select_offset;
+};
+
+#define to_berlin_clkgrp(hw) container_of(hw, struct berlin_clkgrp, hw)
+
+static u8 clk_div[] = {1, 2, 4, 6, 8, 12, 1, 1};
+
+static u32 berlin_clkgrp_read(void __iomem *base, u32 offset)
+{
+	u32 offset_bytes = offset / 32;
+	u32 reg_offset = offset_bytes * 4;
+	u32 reg_shift = offset - (offset_bytes * 32);
+
+	return readl_relaxed(base + reg_offset) >> reg_shift;
+}
+
+static unsigned long berlin_clkgrp_recalc_rate(struct clk_hw *hw,
+					unsigned long parent_rate)
+{
+	u32 val, divider;
+	struct berlin_clkgrp *clk = to_berlin_clkgrp(hw);
+
+	val = berlin_clkgrp_read(clk->regs->switch_base, clk->switch_offset);
+	divider = 1;
+	if (val & CLK_DIV3_SWITCH) {
+		divider = 3;
+	} else if (val & CLK_SWITCH) {
+		val = berlin_clkgrp_read(clk->regs->select_base,
+					 clk->select_offset + CLK_SEL_SHIFT);
+		val &= CLK_SEL_MASK;
+		divider = clk_div[val];
+	}
+
+	return parent_rate / divider;
+}
+
+static u8 berlin_clkgrp_get_parent(struct clk_hw *hw)
+{
+	u32 val;
+	struct berlin_clkgrp *clk = to_berlin_clkgrp(hw);
+
+	val = berlin_clkgrp_read(clk->regs->switch_base, clk->switch_offset);
+	if (val & CLK_PLL_SWITCH) {
+		val = berlin_clkgrp_read(clk->regs->select_base,
+					 clk->select_offset);
+		return val & CLK_PLLSEL_MASK;
+	}
+
+	return 0;
+}
+
+static const struct clk_ops berlin_clkgrp_ops = {
+	.recalc_rate	= berlin_clkgrp_recalc_rate,
+	.get_parent	= berlin_clkgrp_get_parent,
+};
+
+static struct clk * __init berlin_clkgrp_register(struct device_node *np,
+		const char **parent_names, int num_parents,
+		struct berlin_clkgrp_regs *regs)
+{
+	struct berlin_clkgrp *bclk;
+	struct clk *clk;
+	struct clk_init_data init;
+	u32 switch_offset, select_offset;
+	int ret;
+
+	ret = of_property_read_u32(np, "marvell,clk-switch-offset",
+				   &switch_offset);
+	if (WARN_ON(ret))
+		return ERR_PTR(ret);
+	ret = of_property_read_u32(np, "marvell,clk-select-offset",
+				   &select_offset);
+	if (WARN_ON(ret))
+		return ERR_PTR(ret);
+
+	bclk = kzalloc(sizeof(*bclk), GFP_KERNEL);
+	if (WARN_ON(!bclk))
+		return ERR_PTR(-ENOMEM);
+
+	init.name = np->name;
+	init.ops = &berlin_clkgrp_ops;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+
+	bclk->regs = regs;
+	bclk->switch_offset = switch_offset;
+	bclk->select_offset = select_offset;
+	bclk->hw.init = &init;
+
+	clk = clk_register(NULL, &bclk->hw);
+	if (WARN_ON(IS_ERR(clk)))
+		return clk;
+
+	ret = of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	if (WARN_ON(ret))
+		return ERR_PTR(ret);
+
+	return clk;
+}
+
+void __init berlin_clkgrp_setup(struct device_node *np)
+{
+	struct device_node *childnp;
+	struct berlin_clkgrp_regs *regs;
+	const char **parent_names;
+	int nparents;
+	int i;
+
+	regs = kzalloc(sizeof(*regs), GFP_KERNEL);
+	if (WARN_ON(!regs))
+		return;
+
+	regs->switch_base = of_iomap(np, 0);
+	if (WARN_ON(!regs->switch_base))
+		goto exit;
+
+	regs->select_base = of_iomap(np, 1);
+	if (WARN_ON(!regs->select_base))
+		goto exit;
+
+	nparents = of_clk_get_parent_count(np);
+	if (WARN_ON(!nparents))
+		goto exit;
+
+	parent_names = kzalloc(nparents * sizeof(char *), GFP_KERNEL);
+	if (WARN_ON(!parent_names))
+		goto exit;
+
+	for (i = 0; i < nparents; i++) {
+		parent_names[i] = of_clk_get_parent_name(np, i);
+		if (!parent_names[i])
+			break;
+	}
+
+	for_each_child_of_node(np, childnp) {
+		berlin_clkgrp_register(childnp, parent_names, nparents,
+				       regs);
+	}
+
+	kfree(parent_names);
+exit:
+	kfree(regs);
+}
+CLK_OF_DECLARE(berlin_clk, "marvell,berlin2-clkgrp", berlin_clkgrp_setup);
-- 
1.9.1

