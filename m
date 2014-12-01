Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbaLAXUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:20:54 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64882 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690AbaLAXUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:20:50 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 06/16] clk: tz1090: add PLL clock driver
Date: Mon,  1 Dec 2014 23:19:56 +0000
Message-Id: <1417476006-10407-7-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a clock driver for the main PLLs in the TZ1090 SoC, the system PLL
and the ADC PLL. The system PLL is used to derive the core Meta clock,
the DDR clock, and the system clock. The ADC PLL can be used for various
purposes, but is usually used for the pixel clock.

The PLL is a True Circuits PLL, but the arrangement of the fields in the
registers is specific to the TZ1090 SoC.

The driver supports recalc_rate, round_rate, and set_rate operations.

The tz1090_clk_register_plls() helper function can be used to register a
set of PLLs from static initialisation data. A PLL() macro is provided
in tz1090/clk.h to aid the creation of this data. For example:

static const struct tz1090_clk_pll plls[] __initconst = {
	PLL(CLK_TOP_SYSPLL, "sys_sw", "sys_pll", TOP_SYSPLL_CTL0),
	...
};
...
tz1090_clk_register_plls(p, plls, ARRAY_SIZE(plls));

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
Changes since v1 (patch 4):
- Renamed function prefixes from clk_tz1090_ to tz1090_clk_ for
  consistency with the rest.
- Drop DT binding as it will be instantiated directly from a provider.
- Add tz1090_clk_register_plls() to conveniently register a set of PLLs
  in a clock provider from static initilisation data.
- Extend tz1090/clk.h interface for easy static initialisation with
  macros.
---
 drivers/clk/tz1090/Makefile         |   1 +
 drivers/clk/tz1090/clk-tz1090-pll.c | 276 ++++++++++++++++++++++++++++++++++++
 drivers/clk/tz1090/clk.h            |  22 +++
 3 files changed, 299 insertions(+)
 create mode 100644 drivers/clk/tz1090/clk-tz1090-pll.c

diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
index a7127d9..a28a5bb 100644
--- a/drivers/clk/tz1090/Makefile
+++ b/drivers/clk/tz1090/Makefile
@@ -5,3 +5,4 @@ obj-y		+= clk-tz1090-deleter.o
 obj-y		+= clk-tz1090-divider.o
 obj-y		+= clk-tz1090-gate-bank.o
 obj-y		+= clk-tz1090-mux-bank.o
+obj-y		+= clk-tz1090-pll.o
diff --git a/drivers/clk/tz1090/clk-tz1090-pll.c b/drivers/clk/tz1090/clk-tz1090-pll.c
new file mode 100644
index 0000000..ca8260b
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-pll.c
@@ -0,0 +1,276 @@
+/*
+ * Copyright (C) 2011 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
+ * Copyright (C) 2011 Richard Zhao, Linaro <richard.zhao@linaro.org>
+ * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
+ * Copyright (C) 2013-2014 Imagination Technologies Ltd.
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
+#include <linux/slab.h>
+
+#include "clk.h"
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
+ * struct tz1090_clk_pll_priv - PLL in TZ1090
+ *
+ * @hw:		handle between common and hardware-specific interfaces
+ * @reg:	first of two registers
+ *
+ * PLL in TZ1090.
+ */
+struct tz1090_clk_pll_priv {
+	struct clk_hw	hw;
+	void __iomem	*reg;
+};
+
+#define to_tz1090_clk_pll(_hw) container_of(_hw, struct tz1090_clk_pll_priv, hw)
+
+static unsigned long tz1090_clk_pll_recalc_rate(struct clk_hw *hw,
+						unsigned long f_in)
+{
+	struct tz1090_clk_pll_priv *pll = to_tz1090_clk_pll(hw);
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
+static int tz1090_clk_pll_bestvals(struct clk_hw *hw, unsigned long parent_rate,
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
+	pr_debug("tz1090_clk_pll: final %lu/%lu * %lu/2/%lu=%lu (req=%lu, err=%ld)\n",
+		 parent_rate, bestr, bestf, bestod, best, rate, best - rate);
+
+	*clkf = bestf;
+	*clkr = bestr;
+	*clkod = bestod;
+	return best;
+}
+
+static long tz1090_clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+				      unsigned long *prate)
+{
+	unsigned long clkf, clkr, clkod;
+	unsigned long parent_rate = *prate;
+
+	return tz1090_clk_pll_bestvals(hw, parent_rate, rate, &clkf, &clkr,
+				       &clkod);
+}
+
+static int tz1090_clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
+				   unsigned long parent_rate)
+{
+	struct tz1090_clk_pll_priv *pll = to_tz1090_clk_pll(hw);
+	unsigned long clkf, clkr, clkod, bwadj;
+	u32 ctl0, ctl1;
+
+	if (!tz1090_clk_pll_bestvals(hw, parent_rate, rate,
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
+static const struct clk_ops tz1090_clk_pll_ops = {
+	.recalc_rate	= tz1090_clk_pll_recalc_rate,
+	.round_rate	= tz1090_clk_pll_round_rate,
+	.set_rate	= tz1090_clk_pll_set_rate,
+};
+
+/**
+ * __register_pll() - register a PLL with the clock framework
+ * @name: name of this clock
+ * @parent_name: name of clock's parent
+ * @flags: framework-specific flags
+ * @reg: register address to adjust PLL
+ *
+ * Register a TZ1090 PLL clock to the clock framework.
+ */
+static struct clk *__init __register_pll(const char *name,
+					 const char *parent_name,
+					 unsigned long flags,
+					 void __iomem *reg)
+{
+	struct tz1090_clk_pll_priv *pll;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the pll */
+	pll = kzalloc(sizeof(struct tz1090_clk_pll_priv), GFP_KERNEL);
+	if (!pll)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &tz1090_clk_pll_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	/* struct tz1090_clk_pll_priv assignments */
+	pll->reg = reg;
+	pll->hw.init = &init;
+
+	/* register the clock */
+	clk = clk_register(NULL, &pll->hw);
+
+	if (IS_ERR(clk))
+		kfree(pll);
+
+	return clk;
+}
+
+/**
+ * tz1090_clk_register_plls() - Register set of PLLs with a provider.
+ * @p:		TZ1090 clock provider.
+ * @plls:	Array of PLL descriptions.
+ * @count	Number of PLLs described in the array.
+ */
+void __init tz1090_clk_register_plls(struct tz1090_clk_provider *p,
+				     const struct tz1090_clk_pll *plls,
+				     unsigned int count)
+{
+	const struct tz1090_clk_pll *pll;
+	struct clk *clk;
+	unsigned int i;
+
+	for (pll = plls, i = 0; i < count; ++pll, ++i) {
+		clk = __register_pll(tz1090_clk_xlate(p, pll->name),
+				     tz1090_clk_xlate(p, pll->parent), 0,
+				     p->base + pll->reg_base);
+		p->clk_data.clks[pll->id] = clk;
+	}
+}
diff --git a/drivers/clk/tz1090/clk.h b/drivers/clk/tz1090/clk.h
index ca51f87..ae77ed5 100644
--- a/drivers/clk/tz1090/clk.h
+++ b/drivers/clk/tz1090/clk.h
@@ -229,4 +229,26 @@ void tz1090_clk_register_dividers(struct tz1090_clk_provider *p,
 				  const struct tz1090_clk_divider *dividers,
 				  unsigned int count);
 
+
+/* PLLs */
+
+struct tz1090_clk_pll {
+	unsigned int		id;
+	unsigned long		reg_base;
+	const char		*name;
+	const char		*parent;
+};
+
+#define PLL(_id, _parent, _name, _reg)			\
+	{						\
+		.id		= (_id),		\
+		.reg_base	= (_reg),		\
+		.name		= (_name),		\
+		.parent		= (_parent),		\
+	}
+
+void tz1090_clk_register_plls(struct tz1090_clk_provider *p,
+			      const struct tz1090_clk_pll *plls,
+			      unsigned int count);
+
 #endif
-- 
2.0.4

