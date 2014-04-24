Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbaDXTE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:04:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43960 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758844AbaDXTEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:04:25 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 1/5] clk: berlin: add support for clocks
Date: Thu, 24 Apr 2014 21:04:08 +0200
Message-Id: <1398366252-19582-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398366252-19582-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1398366252-19582-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for clocks having their own register set.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/clk/berlin/Makefile |   2 +-
 drivers/clk/berlin/clk.c    | 134 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 135 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/berlin/clk.c

diff --git a/drivers/clk/berlin/Makefile b/drivers/clk/berlin/Makefile
index 94859513de90..9bfa58eaf25a 100644
--- a/drivers/clk/berlin/Makefile
+++ b/drivers/clk/berlin/Makefile
@@ -1,4 +1,4 @@
-obj-y += pll.o
+obj-y += pll.o clk.o
 obj-$(CONFIG_MACH_BERLIN_BG2)   += pll-berlin2.o
 obj-$(CONFIG_MACH_BERLIN_BG2CD) += pll-berlin2.o
 obj-$(CONFIG_MACH_BERLIN_BG2Q)  += pll-berlin2q.o
diff --git a/drivers/clk/berlin/clk.c b/drivers/clk/berlin/clk.c
new file mode 100644
index 000000000000..ba9892bb8ac8
--- /dev/null
+++ b/drivers/clk/berlin/clk.c
@@ -0,0 +1,134 @@
+/*
+ * Copyright (c) 2014 Marvell Technology Group Ltd.
+ *
+ * Original author: Jisheng Zhang <jszhang@marvell.com>
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
+#define CLK_EN			BIT(0)
+#define CLK_PLLSEL_MASK		7
+#define CLK_PLLSEL_SHIFT	1
+#define CLK_PLL_SWITCH		BIT(4)
+#define CLK_SWITCH		BIT(5)
+#define CLK_DIV3_SWITCH		BIT(6)
+#define CLK_SEL_MASK		7
+#define CLK_SEL_SHIFT		7
+
+struct berlin_clk {
+	struct clk_hw hw;
+	void __iomem *base;
+	struct berlin_clkmap *map;
+};
+
+#define to_berlin_clk(hw) container_of(hw, struct berlin_clk, hw)
+
+static u8 clk_div[] = {1, 2, 4, 6, 8, 12, 1, 1};
+
+static unsigned long berlin_clk_recalc_rate(struct clk_hw *hw,
+					unsigned long parent_rate)
+{
+	u32 val, divider;
+	struct berlin_clk *clk = to_berlin_clk(hw);
+
+	val = readl_relaxed(clk->base);
+
+	divider = 1;
+	if (val & CLK_DIV3_SWITCH) {
+		divider = 3;
+	} else if (val & CLK_SWITCH) {
+		val >>= CLK_SEL_SHIFT;
+		val &= CLK_SEL_MASK;
+		divider = clk_div[val];
+	}
+
+	return parent_rate / divider;
+}
+
+static u8 berlin_clk_get_parent(struct clk_hw *hw)
+{
+	u32 val;
+	struct berlin_clk *clk = to_berlin_clk(hw);
+
+	val = readl_relaxed(clk->base);
+	if (val & CLK_PLL_SWITCH) {
+		val >>= CLK_PLLSEL_SHIFT;
+		val &= CLK_PLLSEL_MASK;
+		return val;
+	}
+
+	return 0;
+}
+
+static const struct clk_ops berlin_clk_ops = {
+	.recalc_rate	= berlin_clk_recalc_rate,
+	.get_parent	= berlin_clk_get_parent,
+};
+
+static void __init berlin_clk_setup(struct device_node *np)
+{
+	struct clk_init_data init;
+	struct berlin_clk *bclk;
+	struct clk *clk;
+	const char **parent_names;
+	int nparents, i, ret;
+
+	bclk = kzalloc(sizeof(*bclk), GFP_KERNEL);
+	if (WARN_ON(!bclk))
+		return;
+
+	bclk->base = of_iomap(np, 0);
+	if (WARN_ON(!bclk->base))
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
+	init.name = np->name;
+	init.ops = &berlin_clk_ops;
+	for (i = 0; i < nparents; i++) {
+		parent_names[i] = of_clk_get_parent_name(np, i);
+		if (!parent_names[i])
+			break;
+	}
+	init.parent_names = parent_names;
+	init.num_parents = i;
+
+	bclk->hw.init = &init;
+
+	clk = clk_register(NULL, &bclk->hw);
+	kfree(parent_names);
+	if (WARN_ON(IS_ERR(clk)))
+		goto exit;
+
+	ret = of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	WARN_ON(ret);
+
+	return;
+exit:
+	kfree(bclk);
+}
+
+CLK_OF_DECLARE(berlin_clk, "marvell,berlin-clk", berlin_clk_setup);
-- 
1.9.1

