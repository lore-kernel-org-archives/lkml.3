Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaCUUKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 16:10:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58682 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751809AbaCUUI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 16:08:58 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 1/5] clk: berlin: add support for berlin plls
Date: Fri, 21 Mar 2014 21:08:37 +0100
Message-Id: <1395432521-11055-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This drivers allows to provide DT clocks for the cpu and system PLLs found on
Marvell Berlin SoCs.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/clk/Makefile              |   1 +
 drivers/clk/berlin/Makefile       |   4 ++
 drivers/clk/berlin/common.h       |  35 +++++++++++++
 drivers/clk/berlin/pll-berlin2.c  |  42 +++++++++++++++
 drivers/clk/berlin/pll-berlin2q.c |  42 +++++++++++++++
 drivers/clk/berlin/pll.c          | 107 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 231 insertions(+)
 create mode 100644 drivers/clk/berlin/Makefile
 create mode 100644 drivers/clk/berlin/common.h
 create mode 100644 drivers/clk/berlin/pll-berlin2.c
 create mode 100644 drivers/clk/berlin/pll-berlin2q.c
 create mode 100644 drivers/clk/berlin/pll.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index a367a9831717..4a2602737c27 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_ARCH_VT8500)		+= clk-vt8500.o
 obj-$(CONFIG_COMMON_CLK_WM831X)		+= clk-wm831x.o
 obj-$(CONFIG_COMMON_CLK_XGENE)		+= clk-xgene.o
 obj-$(CONFIG_COMMON_CLK_AT91)		+= at91/
+obj-$(CONFIG_ARCH_BERLIN)		+= berlin/
 obj-$(CONFIG_ARCH_HI3xxx)		+= hisilicon/
 obj-$(CONFIG_COMMON_CLK_KEYSTONE)	+= keystone/
 ifeq ($(CONFIG_COMMON_CLK), y)
diff --git a/drivers/clk/berlin/Makefile b/drivers/clk/berlin/Makefile
new file mode 100644
index 000000000000..94859513de90
--- /dev/null
+++ b/drivers/clk/berlin/Makefile
@@ -0,0 +1,4 @@
+obj-y += pll.o
+obj-$(CONFIG_MACH_BERLIN_BG2)   += pll-berlin2.o
+obj-$(CONFIG_MACH_BERLIN_BG2CD) += pll-berlin2.o
+obj-$(CONFIG_MACH_BERLIN_BG2Q)  += pll-berlin2q.o
diff --git a/drivers/clk/berlin/common.h b/drivers/clk/berlin/common.h
new file mode 100644
index 000000000000..8eb8a9f9aa30
--- /dev/null
+++ b/drivers/clk/berlin/common.h
@@ -0,0 +1,35 @@
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
+#ifndef __BERLIN_CLK_H
+#define __BERLIN_CLK_H
+
+struct device_node;
+
+struct berlin_pllmap {
+	const u8	*vcodiv;
+	u32		fbdiv_mask;
+	u32		rfdiv_mask;
+	u32		divsel_mask;
+	u8		fbdiv_shift;
+	u8		rfdiv_shift;
+	u8		divsel_shift;
+	u8		mult;
+};
+
+extern void __init berlin_pll_setup(struct device_node *np,
+				struct berlin_pllmap *map);
+
+#endif /* BERLIN_CLK_H */
diff --git a/drivers/clk/berlin/pll-berlin2.c b/drivers/clk/berlin/pll-berlin2.c
new file mode 100644
index 000000000000..3b2f5856442d
--- /dev/null
+++ b/drivers/clk/berlin/pll-berlin2.c
@@ -0,0 +1,42 @@
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
+#include <linux/clk-provider.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+
+#include "common.h"
+
+static const u8 vcodiv_berlin2[] = {10, 15, 20, 25, 30, 40, 50, 60, 80,
+				    1, 1, 1, 1, 1, 1, 1};
+
+static struct berlin_pllmap berlin_pll_map = {
+	.vcodiv = vcodiv_berlin2,
+	.fbdiv_mask = 0x1FF,
+	.fbdiv_shift = 6,
+	.rfdiv_mask = 0x1F,
+	.rfdiv_shift = 1,
+	.divsel_mask = 0xF,
+	.divsel_shift = 7,
+	.mult = 10,
+};
+
+static void __init berlin2_pll_setup(struct device_node *np)
+{
+	berlin_pll_setup(np, &berlin_pll_map);
+}
+CLK_OF_DECLARE(berlin2q_pll, "marvell,berlin2-pll", berlin2_pll_setup);
+
diff --git a/drivers/clk/berlin/pll-berlin2q.c b/drivers/clk/berlin/pll-berlin2q.c
new file mode 100644
index 000000000000..0a2e9968cc09
--- /dev/null
+++ b/drivers/clk/berlin/pll-berlin2q.c
@@ -0,0 +1,42 @@
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
+#include <linux/clk-provider.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+
+#include "common.h"
+
+static const u8 vcodiv_berlin2q[] = {1, 0, 2, 0, 3, 4, 0, 6, 8,
+				     1, 1, 1, 1, 1, 1, 1};
+
+static struct berlin_pllmap berlin2q_pll_map = {
+	.vcodiv = vcodiv_berlin2q,
+	.fbdiv_mask = 0x1FF,
+	.fbdiv_shift = 7,
+	.rfdiv_mask = 0x1F,
+	.rfdiv_shift = 2,
+	.divsel_mask = 0xF,
+	.divsel_shift = 9,
+	.mult = 1,
+};
+
+static void __init berlin2q_pll_setup(struct device_node *np)
+{
+	berlin_pll_setup(np, &berlin2q_pll_map);
+}
+CLK_OF_DECLARE(berlin2q_pll, "marvell,berlin2q-pll", berlin2q_pll_setup);
+
diff --git a/drivers/clk/berlin/pll.c b/drivers/clk/berlin/pll.c
new file mode 100644
index 000000000000..264c48d6e797
--- /dev/null
+++ b/drivers/clk/berlin/pll.c
@@ -0,0 +1,107 @@
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
+#include <linux/clk-provider.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+
+#include "common.h"
+
+struct berlin_pll {
+	struct clk_hw		hw;
+	void __iomem		*base;
+	struct berlin_pllmap	*map;
+};
+
+#define to_berlin_pll(hw)	container_of(hw, struct berlin_pll, hw)
+
+#define PLL_CTRL0	0x00
+#define PLL_CTRL1	0x04
+
+static inline u32 berlin_pll_read(struct berlin_pll *pll, unsigned long offset)
+{
+	return readl_relaxed(pll->base + offset);
+}
+
+/*
+ * The output frequency formula for the pll is:
+ * clkout = fbdiv / refdiv * parent / vcodiv
+ * Note that for BG2, BG2CD and BG2Q, the parent clock is provided by the SM
+ * oscillator and is always 25MHz.
+ */
+static unsigned long berlin_pll_recalc_rate(struct clk_hw *hw,
+					unsigned long parent_rate)
+{
+	struct berlin_pll *pll = to_berlin_pll(hw);
+	struct berlin_pllmap *map = pll->map;
+	u32 val, fbdiv, rfdiv, vcodivsel;
+
+	val = berlin_pll_read(pll, PLL_CTRL0);
+	fbdiv = (val >> map->fbdiv_shift) & map->fbdiv_mask;
+	rfdiv = (val >> map->rfdiv_shift) & map->rfdiv_mask;
+	if (rfdiv == 0)
+		rfdiv = 1;
+
+	val = berlin_pll_read(pll, PLL_CTRL1);
+	vcodivsel = (val >> map->divsel_shift) & map->divsel_mask;
+
+	parent_rate *= fbdiv * map->mult;
+	parent_rate /= rfdiv;
+	return parent_rate / map->vcodiv[vcodivsel];
+}
+
+static const struct clk_ops berlin_pll_ops = {
+	.recalc_rate	= berlin_pll_recalc_rate,
+};
+
+void __init berlin_pll_setup(struct device_node *np,
+			struct berlin_pllmap *map)
+{
+	struct clk_init_data init;
+	struct berlin_pll *pll;
+	const char *parent_name;
+	struct clk *clk;
+	int ret;
+
+	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
+	if (WARN_ON(!pll))
+		return;
+
+	pll->base = of_iomap(np, 0);
+	if (WARN_ON(!pll->base))
+		return;
+
+	pll->map = map;
+
+	init.name = np->name;
+	init.ops = &berlin_pll_ops;
+	parent_name = of_clk_get_parent_name(np, 0);
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+
+	pll->hw.init = &init;
+
+	clk = clk_register(NULL, &pll->hw);
+	if (WARN_ON(IS_ERR(clk)))
+		return;
+
+	ret = of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	if (WARN_ON(ret))
+		return;
+}
+
-- 
1.8.3.2

