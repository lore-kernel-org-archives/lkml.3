Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbaKSXTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:19:44 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37098 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbaKSXQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:04 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 04/15] clk: tz1090: add PLL clock driver
Date: Wed, 19 Nov 2014 23:15:32 +0000
Message-Id: <1416438943-11429-5-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the main PLLs in the TZ1090 SoC, the system PLL and the
ADC PLL. The system PLL is used to derive the core Meta clock, the DDR
clock, and the system clock. The ADC PLL can be used for various
purposes, but is usually used for the pixel clock.

The PLL is a True Circuits PLL, but the arrangement of the fields in the
registers is I believe specific to the TZ1090 SoC.

The driver supports recalc_rate, round_rate, and set_rate operations.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
 drivers/clk/Makefile                |   1 +
 drivers/clk/tz1090/Makefile         |   2 +
 drivers/clk/tz1090/clk-tz1090-pll.c | 305 ++++++++++++++++++++++++++++++++++++
 3 files changed, 308 insertions(+)
 create mode 100644 drivers/clk/tz1090/Makefile
 create mode 100644 drivers/clk/tz1090/clk-tz1090-pll.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index d5fba5b..ca486ed 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_PLAT_SPEAR)		+= spear/
 obj-$(CONFIG_ARCH_STI)			+= st/
 obj-$(CONFIG_ARCH_SUNXI)		+= sunxi/
 obj-$(CONFIG_ARCH_TEGRA)		+= tegra/
+obj-$(CONFIG_SOC_TZ1090)		+= tz1090/
 obj-$(CONFIG_ARCH_OMAP2PLUS)		+= ti/
 obj-$(CONFIG_ARCH_U8500)		+= ux500/
 obj-$(CONFIG_COMMON_CLK_VERSATILE)	+= versatile/
diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
new file mode 100644
index 0000000..14f2d33
--- /dev/null
+++ b/drivers/clk/tz1090/Makefile
@@ -0,0 +1,2 @@
+# Makefile for TZ1090-specific clocks
+obj-y		+= clk-tz1090-pll.o
diff --git a/drivers/clk/tz1090/clk-tz1090-pll.c b/drivers/clk/tz1090/clk-tz1090-pll.c
new file mode 100644
index 0000000..b51e6e7
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-pll.c
@@ -0,0 +1,305 @@
+/*
+ * Copyright (C) 2011 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
+ * Copyright (C) 2011 Richard Zhao, Linaro <richard.zhao@linaro.org>
+ * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
+ * Copyright (C) 2013 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * True Circuits PLL in TZ1090 SoC.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+
+/* Register definitions */
+
+#define PLL_CTL0		0
+#define  PLL_CTL0_BWADJ_M		0xfff
+#define  PLL_CTL0_BWADJ_S		20
+#define  PLL_CTL0_CLKF_M		0x1fff
+#define  PLL_CTL0_CLKF_S		4
+#define  PLL_CTL0_CLKOD_M		0x7
+#define  PLL_CTL0_CLKOD_S		0
+#define PLL_CTL1		4
+#define  PLL_CTL1_RESET_B		BIT(28)
+#define  PLL_CTL1_FASTEN_B		BIT(27)
+#define  PLL_CTL1_ENSAT_B		BIT(26)
+#define  PLL_CTL1_BYPASS_B		BIT(25)
+#define  PLL_CTL1_PWRDN_B		BIT(24)
+#define  PLL_CTL1_CLKR_M		0x3f
+#define  PLL_CTL1_CLKR_S		0
+
+/**
+ * struct clk_tz1090_pll - PLL in TZ1090
+ *
+ * @hw:		handle between common and hardware-specific interfaces
+ * @reg:	first of two registers
+ *
+ * PLL in TZ1090.  Implements .recalc_rate, .set_rate and .round_rate
+ */
+struct clk_tz1090_pll {
+	struct clk_hw	hw;
+	void __iomem	*reg;
+};
+
+/*
+ * DOC: TZ1090 adjustable PLL clock
+ *
+ * Traits of this clock:
+ * prepare - clk_prepare only ensures that parents are prepared
+ * enable - clk_enable only ensures that parents are enabled
+ * rate - rate is adjustable.
+ * parent - fixed parent.  No clk_set_parent support
+ */
+
+#define to_clk_tz1090_pll(_hw) container_of(_hw, struct clk_tz1090_pll, hw)
+
+static unsigned long clk_tz1090_pll_recalc_rate(struct clk_hw *hw,
+						unsigned long f_in)
+{
+	struct clk_tz1090_pll *pll = to_clk_tz1090_pll(hw);
+	u32 ctl0, ctl1;
+	unsigned int clk_f;	/* feedback divide */
+	unsigned int clk_od;	/* output divide */
+	unsigned int clk_r;	/* reference divide */
+	unsigned long f_out;
+
+	ctl0 = readl(pll->reg + PLL_CTL0);
+	ctl1 = readl(pll->reg + PLL_CTL1);
+
+	/* Bypass? */
+	if (ctl1 & PLL_CTL1_BYPASS_B)
+		return f_in;
+
+	/* Get divider values */
+	clk_f  = 1 + ((ctl0 >> PLL_CTL0_CLKF_S)  & PLL_CTL0_CLKF_M);
+	clk_od = 1 + ((ctl0 >> PLL_CTL0_CLKOD_S) & PLL_CTL0_CLKOD_M);
+	clk_r  = 1 + ((ctl1 >> PLL_CTL1_CLKR_S)  & PLL_CTL1_CLKR_M);
+
+	/*
+	 * formula:
+	 * f_out = (f_in / clk_r) * (clk_f / 2) / clk_od
+	 *       = (f_in * clk_f) / (2 * clk_r * clk_od)
+	 */
+	f_out = div_u64((u64)f_in * clk_f,
+			2 * clk_r * clk_od);
+	return f_out;
+}
+
+/* finds best pll parameters and returns rate on success (or 0) */
+static int clk_tz1090_pll_bestvals(struct clk_hw *hw, unsigned long parent_rate,
+				   unsigned long rate, unsigned long *clkf,
+				   unsigned long *clkr, unsigned long *clkod)
+{
+	unsigned long odmin, odmax;
+	unsigned long bestf = 1, bestr = 1, bestod = 1;
+	unsigned long rod2, cur, best = 0;
+	unsigned long f, r, od;
+
+	/* 120MHz/freq < od < 600MHz/freq */
+	odmin = 120000000/rate + 1;
+	odmax = 600000000/rate;
+
+	if (odmin < 1)
+		odmin = 1;
+	if (odmax > PLL_CTL0_CLKOD_M + 1)
+		odmax = PLL_CTL0_CLKOD_M + 1;
+
+	/*
+	 * Search through valid combinations of od and r, starting with lower
+	 * output divider values to get a lower intermediate frequency.
+	 */
+	for (od = odmin; od <= odmax; ++od) {
+		for (r = 1; r <= PLL_CTL1_CLKR_M + 1; ++r) {
+			/*
+			 * Calculate best f for given r and od, rounding down
+			 * So for f, freq <= rate
+			 * And for f+1, freq > rate
+			 * We have to do rate+1 because rate may have itself
+			 * been rounded down.
+			 */
+			rod2 = 2 * r * od;
+			f = div_u64((u64)(rate + 1) * rod2, parent_rate);
+			if (f < 1)
+				continue;
+			if (f > PLL_CTL0_CLKF_M + 1)
+				f = PLL_CTL0_CLKF_M + 1;
+
+			/* Calculate final rate and see if it's the best */
+			cur = div_u64((u64)parent_rate * f, rod2);
+			if (cur > best) {
+				bestf = f;
+				bestr = r;
+				bestod = od;
+				best = cur;
+				/* Can't improve on a perfect match */
+				if (cur == rate)
+					goto done;
+			}
+		}
+	}
+	if (!best)
+		return 0;
+done:
+	pr_debug("clk_tz1090_pll: final %lu/%lu * %lu/2/%lu=%lu (req=%lu, err=%ld)\n",
+		 parent_rate, bestr, bestf, bestod, best, rate, best - rate);
+
+	*clkf = bestf;
+	*clkr = bestr;
+	*clkod = bestod;
+	return best;
+}
+
+static long clk_tz1090_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+				      unsigned long *prate)
+{
+	unsigned long clkf, clkr, clkod;
+	unsigned long parent_rate = *prate;
+
+	return clk_tz1090_pll_bestvals(hw, parent_rate, rate, &clkf, &clkr,
+				       &clkod);
+}
+
+static int clk_tz1090_pll_set_rate(struct clk_hw *hw, unsigned long rate,
+				   unsigned long parent_rate)
+{
+	struct clk_tz1090_pll *pll = to_clk_tz1090_pll(hw);
+	unsigned long clkf, clkr, clkod, bwadj;
+	u32 ctl0, ctl1;
+
+	if (!clk_tz1090_pll_bestvals(hw, parent_rate, rate,
+				     &clkf, &clkr, &clkod))
+		return -EINVAL;
+
+	/* offset the values ready to go in the PLL registers */
+	--clkr;
+	--clkf;
+	--clkod;
+	bwadj = clkf / 2;
+
+	/* bypass, reset and configure PLL */
+	ctl0 =	(bwadj << PLL_CTL0_BWADJ_S) |
+		(clkf  << PLL_CTL0_CLKF_S)  |
+		(clkod << PLL_CTL0_CLKOD_S);
+	ctl1 =	PLL_CTL1_RESET_B  |
+		PLL_CTL1_ENSAT_B  |
+		PLL_CTL1_BYPASS_B |
+		(clkr  << PLL_CTL1_CLKR_S);
+	writel(ctl1, pll->reg + PLL_CTL1);
+	writel(ctl0, pll->reg + PLL_CTL0);
+
+	/* allow 5us after clkf before deasserting reset */
+	udelay(5);
+
+	/* take PLL out of reset and enable fasten */
+	ctl1 &= ~PLL_CTL1_RESET_B;
+	ctl1 |= PLL_CTL1_FASTEN_B;
+	writel(ctl1, pll->reg + PLL_CTL1);
+
+	/* count at least 500 divided ref clks to allow time to lock */
+	msleep(1 + 500*1000*(clkr+1)/parent_rate);
+
+	/* take PLL out of fasten / bypass */
+	ctl1 &= ~PLL_CTL1_FASTEN_B;
+	ctl1 &= ~PLL_CTL1_BYPASS_B;
+	writel(ctl1, pll->reg + PLL_CTL1);
+
+	return 0;
+}
+
+static const struct clk_ops clk_tz1090_pll_ops = {
+	.recalc_rate = clk_tz1090_pll_recalc_rate,
+	.round_rate = clk_tz1090_pll_round_rate,
+	.set_rate = clk_tz1090_pll_set_rate,
+};
+
+/**
+ * clk_register_tz1090_pll_setup - register a PLL with the clock framework
+ * @dev: device registering this clock
+ * @name: name of this clock
+ * @parent_name: name of clock's parent
+ * @flags: framework-specific flags
+ * @reg: register address to adjust divider
+ *
+ * Register a TZ1090 PLL clock to the clock framework.
+ */
+static struct clk *__init clk_register_tz1090_pll(struct device *dev,
+						  const char *name,
+						  const char *parent_name,
+						  unsigned long flags,
+						  void __iomem *reg)
+{
+	struct clk_tz1090_pll *div;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the divider */
+	div = kzalloc(sizeof(struct clk_tz1090_pll), GFP_KERNEL);
+	if (!div)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_tz1090_pll_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	/* struct clk_tz1090_pll assignments */
+	div->reg = reg;
+	div->hw.init = &init;
+
+	/* register the clock */
+	clk = clk_register(dev, &div->hw);
+
+	if (IS_ERR(clk))
+		kfree(div);
+
+	return clk;
+}
+
+/**
+ * of_tz1090_pll_setup() - Setup function for PLL in TZ1090
+ */
+static void __init of_tz1090_pll_setup(struct device_node *node)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	void __iomem *reg;
+	const char *parent_name;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	parent_name = of_clk_get_parent_name(node, 0);
+	if (!parent_name) {
+		pr_err("%s(%s): could not read parent clock\n",
+		       __func__, clk_name);
+		return;
+	}
+
+	reg = of_iomap(node, 0);
+	if (!reg) {
+		pr_err("%s(%s): of_iomap failed\n",
+		       __func__, clk_name);
+		return;
+	}
+
+	clk = clk_register_tz1090_pll(NULL, clk_name, parent_name, 0, reg);
+	if (IS_ERR(clk))
+		goto err_iounmap;
+
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+
+	return;
+
+err_iounmap:
+	iounmap(reg);
+}
+CLK_OF_DECLARE(tz1090_pll_clk, "img,tz1090-pll", of_tz1090_pll_setup);
-- 
2.0.4

