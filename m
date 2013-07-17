Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab3GQNuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:50:39 -0400
Received: from mo1.mail-out.ovh.net ([178.32.228.1]:55955 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab3GQNui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:50:38 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 03/42] ARM: at91: add PMC pll clocks
Date: Wed, 17 Jul 2013 15:42:57 +0200
Message-Id: <1374068578-13740-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 11477705127450474604
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the at91 pll clock implementation using common clk framework.

The pll clock layout describe the PLLX register layout.
There's four pll clock layouts:
- at91rm9200
- at91sam9g20
- at91sam9g45
- sama5d3

PLL clocks are given characteristics:
- min/max clock source rate
- ranges of valid clock output rates
- values to set in out and icpll fields for each supported output range

These characteristics are checked during rate change to avoid
over/underclocking.

These characteristics are described in atmel's SoC datasheet in
"Electrical Characteristics" paragraph.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/Makefile     |    2 +-
 drivers/clk/at91/clk-pll.c    |  438 +++++++++++++++++++++++++++++++++++++++++
 drivers/clk/at91/clk-plldiv.c |  125 ++++++++++++
 include/linux/clk/at91.h      |   39 ++++
 4 files changed, 603 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/at91/clk-pll.c
 create mode 100644 drivers/clk/at91/clk-plldiv.c

diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 42c084e..564076f 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -2,4 +2,4 @@
 # Makefile for at91 specific clk
 #
 
-obj-y += clk-main.o
+obj-y += clk-main.o clk-pll.o clk-plldiv.o
diff --git a/drivers/clk/at91/clk-pll.c b/drivers/clk/at91/clk-pll.c
new file mode 100644
index 0000000..e9390e2
--- /dev/null
+++ b/drivers/clk/at91/clk-pll.c
@@ -0,0 +1,438 @@
+/*
+ * drivers/clk/at91/clk-pll.c
+ *
+ *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * This pllram is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/clk/at91.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+
+#define to_clk_pll(hw) container_of(hw, struct clk_pll, hw)
+
+struct clk_pll {
+	struct clk_hw hw;
+	u8 id;
+	u8 div;
+	u8 range;
+	u16 mul;
+	struct clk_pll_layout *layout;
+	struct clk_pll_characteristics *characteristics;
+};
+
+static int clk_pll_prepare(struct clk_hw *hw)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	while (!(at91_pmc_read(AT91_PMC_SR) &
+		 (1 << (1 + pll->id))))
+		;
+	return 0;
+}
+
+static int clk_pll_is_prepared(struct clk_hw *hw)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	return !!(at91_pmc_read(AT91_PMC_SR) &
+		  (1 << (1 + pll->id)));
+}
+
+static int clk_pll_enable(struct clk_hw *hw)
+{
+	return 0;
+}
+
+static void clk_pll_disable(struct clk_hw *hw)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	struct clk_pll_layout *layout = pll->layout;
+	int offset = AT91_CKGR_PLLAR + (pll->id * 4);
+	u32 tmp = at91_pmc_read(offset) & ~(layout->pllr_mask);
+	at91_pmc_write(offset, tmp);
+}
+
+static int clk_pll_is_enabled(struct clk_hw *hw)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	return !!(at91_pmc_read(AT91_PMC_SR) &
+		  (1 << (1 + pll->id)));
+}
+
+static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
+					 unsigned long parent_rate)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	struct clk_pll_layout *layout = pll->layout;
+	int offset = AT91_CKGR_PLLAR + (pll->id * 4);
+	u32 tmp = at91_pmc_read(offset) & layout->pllr_mask;
+	u8 div = tmp & 0xFF;
+	u16 mul = (tmp >> layout->mul_shift) & layout->mul_mask;
+	if (!div || !mul)
+		return 0;
+
+	return (parent_rate * (mul + 1)) / div;
+}
+
+static long clk_pll_get_best_div_mul(struct clk_pll *pll, unsigned long rate,
+				     unsigned long parent_rate,
+				     u32 *div, u32 *mul,
+				     u32 *index) {
+	unsigned long maxrate;
+	unsigned long minrate;
+	unsigned long divrate;
+	unsigned long bestdiv = 1;
+	unsigned long bestmul;
+	unsigned long tmpdiv;
+	unsigned long roundup;
+	unsigned long rounddown;
+	unsigned long remainder;
+	unsigned long bestremainder;
+	unsigned long maxmul;
+	unsigned long maxdiv;
+	unsigned long mindiv;
+	int i = 0;
+	struct clk_pll_layout *layout = pll->layout;
+	struct clk_pll_characteristics *characteristics = pll->characteristics;
+
+	/* Minimum divider = 1 */
+	/* Maximum multiplier = max_mul */
+	maxmul = layout->mul_mask + 1;
+	maxrate = (parent_rate * maxmul) / 1;
+
+	/* Maximum divider = max_div */
+	/* Minimum multiplier = 2 */
+	maxdiv = 0xFF;
+	minrate = (parent_rate * 2) / maxdiv;
+
+	if (parent_rate < characteristics->input.min ||
+	    parent_rate < characteristics->input.max)
+		return -ERANGE;
+
+	if (parent_rate < minrate || parent_rate > maxrate)
+		return -ERANGE;
+
+	for (i = 0; i < characteristics->num_output; ++i) {
+		if (parent_rate >= characteristics->output[i].min &&
+		    parent_rate <= characteristics->output[i].max)
+			break;
+		++i;
+	}
+
+	if (i >= characteristics->num_output)
+		return -ERANGE;
+
+	bestmul = rate / parent_rate;
+	rounddown = parent_rate % rate;
+	roundup = rate - rounddown;
+	bestremainder = roundup < rounddown ? roundup : rounddown;
+
+	if (!bestremainder) {
+		if (div)
+			*div = bestdiv;
+		if (mul)
+			*mul = bestmul;
+		if (index)
+			*index = i;
+		return rate;
+	}
+
+	maxdiv = 255 / (bestmul + 1);
+	if (parent_rate / maxdiv < characteristics->input.min)
+		maxdiv = parent_rate / characteristics->input.min;
+	mindiv = parent_rate / characteristics->input.max;
+	if (parent_rate % characteristics->input.max)
+		mindiv++;
+
+	for (tmpdiv = mindiv; tmpdiv < maxdiv; tmpdiv++) {
+		divrate = parent_rate / tmpdiv;
+
+		rounddown = rate % divrate;
+		roundup = divrate - rounddown;
+		remainder = roundup < rounddown ? roundup : rounddown;
+
+		if (remainder < bestremainder) {
+			bestremainder = remainder;
+			bestmul = rate / divrate;
+			bestdiv = tmpdiv;
+		}
+
+		if (!remainder)
+			break;
+	}
+
+	rate = (parent_rate / bestdiv) * bestmul;
+
+	if (div)
+		*div = bestdiv;
+	if (mul)
+		*mul = bestmul;
+	if (index)
+		*index = i;
+
+	return rate;
+}
+
+static long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	return clk_pll_get_best_div_mul(pll, rate, *parent_rate,
+					NULL, NULL, NULL);
+
+}
+
+static int clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
+			    unsigned long parent_rate)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	struct clk_pll_layout *layout = pll->layout;
+	struct clk_pll_characteristics *characteristics = pll->characteristics;
+	int offset = AT91_CKGR_PLLAR + (pll->id * 4);
+	long ret;
+	u32 div;
+	u32 mul;
+	u32 index;
+	u32 tmp;
+	u8 out = 0;
+	ret = clk_pll_get_best_div_mul(pll, rate, parent_rate,
+				       &div, &mul, &index);
+
+	if (ret < 0)
+		return ret;
+
+	if (characteristics->out)
+		out = characteristics->out[pll->range];
+	if (characteristics->icpll) {
+		tmp = at91_pmc_read(AT91_PMC_PLLICPR) &
+		      ~(0xFFFF << (16 * pll->id));
+		tmp |= characteristics->icpll[pll->range] << (16 * pll->id);
+		at91_pmc_write(AT91_PMC_PLLICPR, tmp);
+	}
+	tmp = at91_pmc_read(offset) & ~(layout->pllr_mask);
+	tmp |= layout->pllr_mask & (div | 0x3F << 8 | out << 14 |
+				    (mul & layout->mul_mask) <<
+				    layout->mul_shift);
+	at91_pmc_write(offset, tmp);
+
+	return 0;
+}
+
+static const struct clk_ops pll_ops = {
+	.prepare = clk_pll_prepare,
+	.is_prepared = clk_pll_is_prepared,
+	.enable = clk_pll_enable,
+	.disable = clk_pll_disable,
+	.is_enabled = clk_pll_is_enabled,
+	.recalc_rate = clk_pll_recalc_rate,
+	.round_rate = clk_pll_round_rate,
+	.set_rate = clk_pll_set_rate,
+};
+
+struct clk * __init
+at91_clk_register_pll(const char *name, const char *parent_name, u8 id,
+		      struct clk_pll_layout *layout,
+		      struct clk_pll_characteristics *characteristics)
+{
+	struct clk_pll *pll;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	id &= 3;
+
+	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
+	if (!pll)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &pll_ops;
+	init.parent_names = parent_name ? &parent_name : NULL;
+	init.num_parents = parent_name ? 1 : 0;
+	init.flags = CLK_SET_RATE_GATE;
+
+	pll->id = id;
+	pll->hw.init = &init;
+	pll->layout = layout;
+	pll->characteristics = characteristics;
+
+	clk = clk_register(NULL, &pll->hw);
+
+	if (IS_ERR(clk))
+		kfree(pll);
+
+	return clk;
+}
+
+
+struct clk_pll_layout at91rm9200_pll_layout = {
+	.pllr_mask = 0x7FFFFFF,
+	.mul_shift = 16,
+	.mul_mask = 0x7FF,
+};
+
+struct clk_pll_layout at91sam9g45_pll_layout = {
+	.pllr_mask = 0xFFFFFF,
+	.mul_shift = 16,
+	.mul_mask = 0xFF,
+};
+
+struct clk_pll_layout at91sam9g20_pllb_layout = {
+	.pllr_mask = 0x3FFFFF,
+	.mul_shift = 16,
+	.mul_mask = 0x3F,
+};
+
+struct clk_pll_layout sama5d3_pll_layout = {
+	.pllr_mask = 0x1FFFFFF,
+	.mul_shift = 18,
+	.mul_mask = 0x7F,
+};
+
+
+#if defined(CONFIG_OF)
+static struct clk_pll_characteristics * __init
+of_at91_clk_pll_get_characteristics(struct device_node *np)
+{
+	int i;
+	u32 tmp;
+	int num_output;
+	struct clk_range *output = NULL;
+	u8 *out = NULL;
+	u16 *icpll = NULL;
+	struct clk_pll_characteristics *characteristics = NULL;
+	characteristics = kzalloc(sizeof(*characteristics), GFP_KERNEL);
+	if (!characteristics)
+		return NULL;
+
+	if (of_property_read_u32_index(np, "input", 0, &tmp))
+		goto out_free_characteristics;
+
+	characteristics->input.min = tmp;
+
+	if (of_property_read_u32_index(np, "input", 1, &tmp))
+		goto out_free_characteristics;
+
+	characteristics->input.max = tmp;
+
+	if (!of_get_property(np, "output", &num_output))
+		goto out_free_characteristics;
+	num_output /= (sizeof(u32) * 2);
+
+	output = kzalloc(sizeof(*output) * num_output, GFP_KERNEL);
+	for (i = 0; i < num_output; i++) {
+		if (of_property_read_u32_index(np, "output", i * 2, &tmp))
+			goto out_free_output;
+		output[i].min = tmp;
+		if (of_property_read_u32_index(np, "output", (i * 2) + 1, &tmp))
+			goto out_free_output;
+		output[i].max = tmp;
+	}
+
+	if (of_get_property(np, "out", NULL)) {
+		out = kzalloc(sizeof(*out) * num_output, GFP_KERNEL);
+		if (!out)
+			goto out_free_output;
+		for (i = 0; i < num_output; i++) {
+			if (of_property_read_u32_index(np, "out", i, &tmp))
+				goto out_free_out;
+			out[i] = tmp;
+		}
+	}
+
+	if (of_get_property(np, "icpll", NULL)) {
+		icpll = kzalloc(sizeof(*icpll) * num_output, GFP_KERNEL);
+		if (!icpll)
+			goto out_free_out;
+		for (i = 0; i < num_output; i++) {
+			if (of_property_read_u32_index(np, "icpll", i, &tmp))
+				goto out_free_icpll;
+			icpll[i] = tmp;
+		}
+	}
+
+	characteristics->num_output = num_output;
+	characteristics->output = output;
+	characteristics->out = out;
+	characteristics->icpll = icpll;
+	return characteristics;
+
+out_free_icpll:
+	kfree(icpll);
+out_free_out:
+	kfree(out);
+out_free_output:
+	kfree(output);
+out_free_characteristics:
+	kfree(characteristics);
+	return NULL;
+}
+
+static void __init
+of_at91_clk_pll_setup(struct device_node *np,
+		      struct clk_pll_layout *layout)
+{
+	u32 id;
+	struct clk *clk;
+	const char *parent_name;
+	const char *name = np->name;
+	struct clk_pll_characteristics *characteristics;
+
+	if (of_property_read_u32(np, "id", &id))
+		return;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+
+	of_property_read_string(np, "clock-output-names", &name);
+
+	characteristics = of_at91_clk_pll_get_characteristics(np);
+	if (!characteristics)
+		return;
+
+	clk = at91_clk_register_pll(name, parent_name, id, layout,
+				    characteristics);
+
+	if (IS_ERR(clk))
+		goto out_free_characteristics;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	return;
+
+out_free_characteristics:
+	kfree(characteristics);
+}
+
+static void __init of_at91rm9200_clk_pll_setup(struct device_node *np)
+{
+	of_at91_clk_pll_setup(np, &at91rm9200_pll_layout);
+}
+CLK_OF_DECLARE(at91rm9200_clk_pll, "atmel,at91rm9200-clk-pll",
+	       of_at91rm9200_clk_pll_setup);
+
+static void __init of_at91sam9g45_clk_pll_setup(struct device_node *np)
+{
+	of_at91_clk_pll_setup(np, &at91sam9g45_pll_layout);
+}
+CLK_OF_DECLARE(at91sam9g45_clk_pll, "atmel,at91sam9g45-clk-pll",
+	       of_at91sam9g45_clk_pll_setup);
+
+static void __init of_at91sam9g20_clk_pllb_setup(struct device_node *np)
+{
+	of_at91_clk_pll_setup(np, &at91sam9g20_pllb_layout);
+}
+CLK_OF_DECLARE(at91sam9g20_clk_pllb, "atmel,at91sam9g20-clk-pllb",
+	       of_at91sam9g20_clk_pllb_setup);
+
+static void __init of_sama5d3_clk_pll_setup(struct device_node *np)
+{
+	of_at91_clk_pll_setup(np, &sama5d3_pll_layout);
+}
+CLK_OF_DECLARE(sama5d3_clk_pll, "atmel,sama5d3-clk-pll",
+	       of_sama5d3_clk_pll_setup);
+#endif
diff --git a/drivers/clk/at91/clk-plldiv.c b/drivers/clk/at91/clk-plldiv.c
new file mode 100644
index 0000000..430de9b
--- /dev/null
+++ b/drivers/clk/at91/clk-plldiv.c
@@ -0,0 +1,125 @@
+/*
+ * drivers/clk/at91/clk-plldiv.c
+ *
+ *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * This plldivram is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/clk/at91.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+
+#define to_clk_plldiv(hw) container_of(hw, struct clk_plldiv, hw)
+
+struct clk_plldiv {
+	struct clk_hw hw;
+};
+
+static unsigned long clk_plldiv_recalc_rate(struct clk_hw *hw,
+					    unsigned long parent_rate)
+{
+	if (at91_pmc_read(AT91_PMC_MCKR) & AT91_PMC_PLLADIV2)
+		return parent_rate / 2;
+	return parent_rate;
+}
+
+static long clk_plldiv_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
+{
+	unsigned long div;
+	if (rate > *parent_rate)
+		return *parent_rate;
+	div = *parent_rate / 2;
+	if (rate < div)
+		return div;
+
+	if (rate - div < *parent_rate - rate)
+		return div;
+
+	return *parent_rate;
+}
+
+static int clk_plldiv_set_rate(struct clk_hw *hw, unsigned long rate,
+			       unsigned long parent_rate)
+{
+	u32 tmp;
+	if (parent_rate != rate && (parent_rate / 2) != rate)
+		return -EINVAL;
+
+	tmp = at91_pmc_read(AT91_PMC_MCKR) & ~AT91_PMC_PLLADIV2;
+	if ((parent_rate / 2) == rate)
+		tmp |= AT91_PMC_PLLADIV2;
+	at91_pmc_write(AT91_PMC_MCKR, tmp);
+
+	return 0;
+}
+
+static const struct clk_ops plldiv_ops = {
+	.recalc_rate = clk_plldiv_recalc_rate,
+	.round_rate = clk_plldiv_round_rate,
+	.set_rate = clk_plldiv_set_rate,
+};
+
+struct clk * __init
+at91_clk_register_plldiv(const char *name, const char *parent_name)
+{
+	struct clk_plldiv *plldiv;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	plldiv = kzalloc(sizeof(*plldiv), GFP_KERNEL);
+	if (!plldiv)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &plldiv_ops;
+	init.parent_names = parent_name ? &parent_name : NULL;
+	init.num_parents = parent_name ? 1 : 0;
+	init.flags = CLK_SET_RATE_GATE;
+
+	plldiv->hw.init = &init;
+
+	clk = clk_register(NULL, &plldiv->hw);
+
+	if (IS_ERR(clk))
+		kfree(plldiv);
+
+	return clk;
+}
+
+#if defined(CONFIG_OF)
+static void __init
+of_at91_clk_plldiv_setup(struct device_node *np)
+{
+	struct clk *clk;
+	const char *parent_name;
+	const char *name = np->name;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+
+	of_property_read_string(np, "clock-output-names", &name);
+
+	clk = at91_clk_register_plldiv(name, parent_name);
+
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	return;
+}
+
+static void __init of_at91sam9x5_clk_plldiv_setup(struct device_node *np)
+{
+	of_at91_clk_plldiv_setup(np);
+}
+CLK_OF_DECLARE(at91sam9x5_clk_plldiv, "atmel,at91sam9x5-clk-plldiv",
+	       of_at91sam9x5_clk_plldiv_setup);
+#endif
diff --git a/include/linux/clk/at91.h b/include/linux/clk/at91.h
index 8e83942..51b7134 100644
--- a/include/linux/clk/at91.h
+++ b/include/linux/clk/at91.h
@@ -166,6 +166,8 @@ extern void __iomem *at91_pmc_base;
 #define		AT91_PMC_CFDEV		(1 << 18)		/* Clock Failure Detector Event [some SAM9] */
 #define	AT91_PMC_IMR		0x6c			/* Interrupt Mask Register */
 
+#define AT91_PMC_PLLICPR	0x80			/* PLL Charge Pump Current Register */
+
 #define AT91_PMC_PROT		0xe4			/* Write Protect Mode Register [some SAM9] */
 #define		AT91_PMC_WPEN		(0x1  <<  0)		/* Write Protect Enable */
 #define		AT91_PMC_WPKEY		(0xffffff << 8)		/* Write Protect Key */
@@ -190,6 +192,26 @@ extern void __iomem *at91_pmc_base;
 #define		AT91_PMC_PCR_EN		(0x1  <<  28)		/* Enable */
 
 
+struct clk_range {
+	unsigned long min;
+	unsigned long max;
+};
+
+#define CLK_RANGE(MIN, MAX) {.min = MIN, .max = MAX,}
+
+struct clk_pll_characteristics {
+	struct clk_range input;
+	int num_output;
+	struct clk_range *output;
+	u16 *icpll;
+	u8 *out;
+};
+
+struct clk_pll_layout {
+	u32 pllr_mask;
+	u16 mul_mask;
+	u8 mul_shift;
+};
 
 
 struct clk * __init
@@ -197,4 +219,21 @@ at91_clk_register_main(const char *name,
 		       const char *parent_name,
 		       unsigned long rate);
 
+
+extern struct clk_pll_layout at91rm9200_pll_layout;
+
+extern struct clk_pll_layout at91sam9g45_pll_layout;
+
+extern struct clk_pll_layout at91sam9g20_pllb_layout;
+
+extern struct clk_pll_layout sama5d3_pll_layout;
+
+struct clk * __init
+at91_clk_register_pll(const char *name, const char *parent_name, u8 id,
+		      struct clk_pll_layout *layout,
+		      struct clk_pll_characteristics *characteristics);
+
+struct clk * __init
+at91_clk_register_plldiv(const char *name, const char *parent_name);
+
 #endif
-- 
1.7.9.5

