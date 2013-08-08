Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab3HHGIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 02:08:50 -0400
Received: from 4.mo4.mail-out.ovh.net ([178.32.98.131]:50314 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755406Ab3HHGIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 02:08:47 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH v3 06/19] clk: at91: add PMC pll clocks
Date: Thu,  8 Aug 2013 08:07:21 +0200
Message-Id: <1375942041-8843-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 3922916750623733808
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new at91 pll clock implementation using common clk framework.

The pll clock layout describe the PLLX register layout.
There are four pll clock layouts:
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
 drivers/clk/at91/clk-pll.c    |  506 +++++++++++++++++++++++++++++++++++++++++
 drivers/clk/at91/clk-plldiv.c |  137 +++++++++++
 drivers/clk/at91/pmc.c        |   21 ++
 drivers/clk/at91/pmc.h        |   11 +
 include/linux/clk/at91_pmc.h  |    2 +
 6 files changed, 678 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/at91/clk-pll.c
 create mode 100644 drivers/clk/at91/clk-plldiv.c

diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 44105bd..902bbf1 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -3,4 +3,4 @@
 #
 
 obj-y += pmc.o
-obj-y += clk-main.o
+obj-y += clk-main.o clk-pll.o clk-plldiv.o
diff --git a/drivers/clk/at91/clk-pll.c b/drivers/clk/at91/clk-pll.c
new file mode 100644
index 0000000..ce519f2
--- /dev/null
+++ b/drivers/clk/at91/clk-pll.c
@@ -0,0 +1,506 @@
+/*
+ * drivers/clk/at91/clk-pll.c
+ *
+ *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/clk/at91_pmc.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/io.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+
+#include "pmc.h"
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
+
+#define to_clk_pll(hw) container_of(hw, struct clk_pll, hw)
+
+struct clk_pll {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+	unsigned int irq;
+	wait_queue_head_t wait;
+	u8 id;
+	u8 div;
+	u8 range;
+	u16 mul;
+	const struct clk_pll_layout *layout;
+	const struct clk_pll_characteristics *characteristics;
+};
+
+static irqreturn_t clk_pll_irq_handler(int irq, void *dev_id)
+{
+	struct clk_pll *pll = (struct clk_pll *)dev_id;
+
+	wake_up(&pll->wait);
+	disable_irq_nosync(pll->irq);
+
+	return IRQ_HANDLED;
+}
+
+static int clk_pll_prepare(struct clk_hw *hw)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	struct at91_pmc *pmc = pll->pmc;
+
+	while (!(pmc_read(pmc, AT91_PMC_SR) & (1 << (1 + pll->id)))) {
+		enable_irq(pll->irq);
+		wait_event(pll->wait,
+			   pmc_read(pmc, AT91_PMC_SR) & (1 << (1 + pll->id)));
+	}
+
+	return 0;
+}
+
+static int clk_pll_is_ready(struct clk_hw *hw)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	struct at91_pmc *pmc = pll->pmc;
+
+	return !!(pmc_read(pmc, AT91_PMC_SR) &
+		  (1 << (1 + pll->id)));
+}
+
+static void clk_pll_disable(struct clk_hw *hw)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	struct at91_pmc *pmc = pll->pmc;
+	const struct clk_pll_layout *layout = pll->layout;
+	int offset = AT91_CKGR_PLLAR + (pll->id * 4);
+	u32 tmp = pmc_read(pmc, offset) & ~(layout->pllr_mask);
+
+	pmc_write(pmc, offset, tmp);
+}
+
+static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
+					 unsigned long parent_rate)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	const struct clk_pll_layout *layout = pll->layout;
+	struct at91_pmc *pmc = pll->pmc;
+	int offset = AT91_CKGR_PLLAR + (pll->id * 4);
+	u32 tmp = pmc_read(pmc, offset) & layout->pllr_mask;
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
+	const struct clk_pll_layout *layout = pll->layout;
+	const struct clk_pll_characteristics *characteristics =
+							pll->characteristics;
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
+
+	return clk_pll_get_best_div_mul(pll, rate, *parent_rate,
+					NULL, NULL, NULL);
+
+}
+
+static int clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
+			    unsigned long parent_rate)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	struct at91_pmc *pmc = pll->pmc;
+	const struct clk_pll_layout *layout = pll->layout;
+	const struct clk_pll_characteristics *characteristics =
+						pll->characteristics;
+	int offset = AT91_CKGR_PLLAR + (pll->id * 4);
+	long ret;
+	u32 div;
+	u32 mul;
+	u32 index;
+	u32 tmp;
+	u8 out = 0;
+
+	ret = clk_pll_get_best_div_mul(pll, rate, parent_rate,
+				       &div, &mul, &index);
+	if (ret < 0)
+		return ret;
+
+	if (characteristics->out)
+		out = characteristics->out[pll->range];
+	if (characteristics->icpll) {
+		tmp = pmc_read(pmc, AT91_PMC_PLLICPR) &
+		      ~(0xFFFF << (16 * pll->id));
+		tmp |= characteristics->icpll[pll->range] << (16 * pll->id);
+		pmc_write(pmc, AT91_PMC_PLLICPR, tmp);
+	}
+	tmp = pmc_read(pmc, offset) & ~(layout->pllr_mask);
+	tmp |= layout->pllr_mask & (div | 0x3F << 8 | out << 14 |
+				    (mul & layout->mul_mask) <<
+				    layout->mul_shift);
+	pmc_write(pmc, offset, tmp);
+
+	return 0;
+}
+
+static const struct clk_ops pll_ops = {
+	.prepare = clk_pll_prepare,
+	.is_prepared = clk_pll_is_ready,
+	.disable = clk_pll_disable,
+	.is_enabled = clk_pll_is_ready,
+	.recalc_rate = clk_pll_recalc_rate,
+	.round_rate = clk_pll_round_rate,
+	.set_rate = clk_pll_set_rate,
+};
+
+static struct clk * __init
+at91_clk_register_pll(struct at91_pmc *pmc, unsigned int irq, const char *name,
+		      const char *parent_name, u8 id,
+		      const struct clk_pll_layout *layout,
+		      const struct clk_pll_characteristics *characteristics)
+{
+	struct clk_pll *pll;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+	int ret;
+
+	id &= 3;
+
+	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
+	if (!pll)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &pll_ops;
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+	init.flags = CLK_SET_RATE_GATE;
+
+	pll->id = id;
+	pll->hw.init = &init;
+	pll->layout = layout;
+	pll->characteristics = characteristics;
+	pll->pmc = pmc;
+	pll->irq = irq;
+	init_waitqueue_head(&pll->wait);
+	irq_set_status_flags(pll->irq, IRQ_NOAUTOEN);
+	ret = request_irq(pll->irq, clk_pll_irq_handler, IRQF_TRIGGER_HIGH,
+			  id ? "clk-pllb" : "clk-plla", pll);
+	if (ret)
+		return ERR_PTR(ret);
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
+static const struct clk_pll_layout at91rm9200_pll_layout = {
+	.pllr_mask = 0x7FFFFFF,
+	.mul_shift = 16,
+	.mul_mask = 0x7FF,
+};
+
+static const struct clk_pll_layout at91sam9g45_pll_layout = {
+	.pllr_mask = 0xFFFFFF,
+	.mul_shift = 16,
+	.mul_mask = 0xFF,
+};
+
+static const struct clk_pll_layout at91sam9g20_pllb_layout = {
+	.pllr_mask = 0x3FFFFF,
+	.mul_shift = 16,
+	.mul_mask = 0x3F,
+};
+
+static const struct clk_pll_layout sama5d3_pll_layout = {
+	.pllr_mask = 0x1FFFFFF,
+	.mul_shift = 18,
+	.mul_mask = 0x7F,
+};
+
+
+static struct clk_pll_characteristics * __init
+of_at91_clk_pll_get_characteristics(struct device_node *np)
+{
+	int i;
+	int offset;
+	u32 tmp;
+	int num_output;
+	u32 num_cells;
+	struct clk_range input;
+	struct clk_range *output;
+	u8 *out = NULL;
+	u16 *icpll = NULL;
+	struct clk_pll_characteristics *characteristics;
+
+	if (of_property_read_u32_index(np, "atmel,clk-input-range", 0, &tmp))
+		return NULL;
+	input.min = tmp;
+
+	if (of_property_read_u32_index(np, "atmel,clk-input-range", 1, &tmp))
+		return NULL;
+	input.max = tmp;
+
+	if (of_property_read_u32(np, "#atmel,pll-clk-output-range-cells",
+				 &num_cells))
+		return NULL;
+
+	if (num_cells < 2 || num_cells > 4)
+		return NULL;
+
+	if (!of_get_property(np, "atmel,pll-clk-output-ranges", &tmp))
+		return NULL;
+	num_output = tmp / (sizeof(u32) * num_cells);
+
+	characteristics = kzalloc(sizeof(*characteristics), GFP_KERNEL);
+	if (!characteristics)
+		return NULL;
+
+	output = kzalloc(sizeof(*output) * num_output, GFP_KERNEL);
+	if (!output)
+		goto out_free_characteristics;
+
+	if (num_cells > 2) {
+		out = kzalloc(sizeof(*out) * num_output, GFP_KERNEL);
+		if (!out)
+			goto out_free_output;
+	}
+
+	if (num_cells > 3) {
+		icpll = kzalloc(sizeof(*icpll) * num_output, GFP_KERNEL);
+		if (!icpll)
+			goto out_free_output;
+	}
+
+	for (i = 0; i < num_output; i++) {
+		offset = i * num_cells;
+		if (of_property_read_u32_index(np,
+					       "atmel,pll-clk-output-ranges",
+					       offset, &tmp))
+			goto out_free_output;
+		output[i].min = tmp;
+		if (of_property_read_u32_index(np,
+					       "atmel,pll-clk-output-ranges",
+					       offset + 1, &tmp))
+			goto out_free_output;
+		output[i].max = tmp;
+
+		if (num_cells == 2)
+			continue;
+
+		if (of_property_read_u32_index(np,
+					       "atmel,pll-clk-output-ranges",
+					       offset + 2, &tmp))
+			goto out_free_output;
+		out[i] = tmp;
+
+		if (num_cells == 3)
+			continue;
+
+		if (of_property_read_u32_index(np,
+					       "atmel,pll-clk-output-ranges",
+					       offset + 3, &tmp))
+			goto out_free_output;
+		icpll[i] = tmp;
+	}
+
+	characteristics->input = input;
+	characteristics->num_output = num_output;
+	characteristics->output = output;
+	characteristics->out = out;
+	characteristics->icpll = icpll;
+	return characteristics;
+
+out_free_output:
+	kfree(icpll);
+	kfree(out);
+	kfree(output);
+out_free_characteristics:
+	kfree(characteristics);
+	return NULL;
+}
+
+static void __init
+of_at91_clk_pll_setup(struct device_node *np, struct at91_pmc *pmc,
+		      const struct clk_pll_layout *layout)
+{
+	u32 id;
+	unsigned int irq;
+	struct clk *clk;
+	const char *parent_name;
+	const char *name = np->name;
+	struct clk_pll_characteristics *characteristics;
+
+	if (of_property_read_u32(np, "atmel,clk-id", &id))
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
+	irq = irq_of_parse_and_map(np, 0);
+	if (!irq)
+		return;
+
+	clk = at91_clk_register_pll(pmc, irq, name, parent_name, id, layout,
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
+void __init of_at91rm9200_clk_pll_setup(struct device_node *np,
+					       struct at91_pmc *pmc)
+{
+	of_at91_clk_pll_setup(np, pmc, &at91rm9200_pll_layout);
+}
+
+void __init of_at91sam9g45_clk_pll_setup(struct device_node *np,
+						struct at91_pmc *pmc)
+{
+	of_at91_clk_pll_setup(np, pmc, &at91sam9g45_pll_layout);
+}
+
+void __init of_at91sam9g20_clk_pllb_setup(struct device_node *np,
+						 struct at91_pmc *pmc)
+{
+	of_at91_clk_pll_setup(np, pmc, &at91sam9g20_pllb_layout);
+}
+
+void __init of_sama5d3_clk_pll_setup(struct device_node *np,
+					    struct at91_pmc *pmc)
+{
+	of_at91_clk_pll_setup(np, pmc, &sama5d3_pll_layout);
+}
diff --git a/drivers/clk/at91/clk-plldiv.c b/drivers/clk/at91/clk-plldiv.c
new file mode 100644
index 0000000..2bbb22b
--- /dev/null
+++ b/drivers/clk/at91/clk-plldiv.c
@@ -0,0 +1,137 @@
+/*
+ * drivers/clk/at91/clk-plldiv.c
+ *
+ *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/clk/at91_pmc.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+
+#include "pmc.h"
+
+#define to_clk_plldiv(hw) container_of(hw, struct clk_plldiv, hw)
+
+struct clk_plldiv {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+};
+
+static unsigned long clk_plldiv_recalc_rate(struct clk_hw *hw,
+					    unsigned long parent_rate)
+{
+	struct clk_plldiv *plldiv = to_clk_plldiv(hw);
+	struct at91_pmc *pmc = plldiv->pmc;
+
+	if (pmc_read(pmc, AT91_PMC_MCKR) & AT91_PMC_PLLADIV2)
+		return parent_rate / 2;
+
+	return parent_rate;
+}
+
+static long clk_plldiv_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
+{
+	unsigned long div;
+
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
+	struct clk_plldiv *plldiv = to_clk_plldiv(hw);
+	struct at91_pmc *pmc = plldiv->pmc;
+	u32 tmp;
+
+	if (parent_rate != rate && (parent_rate / 2) != rate)
+		return -EINVAL;
+
+	pmc_lock(pmc);
+	tmp = pmc_read(pmc, AT91_PMC_MCKR) & ~AT91_PMC_PLLADIV2;
+	if ((parent_rate / 2) == rate)
+		tmp |= AT91_PMC_PLLADIV2;
+	pmc_write(pmc, AT91_PMC_MCKR, tmp);
+	pmc_unlock(pmc);
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
+static struct clk * __init
+at91_clk_register_plldiv(struct at91_pmc *pmc, const char *name,
+			 const char *parent_name)
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
+	plldiv->pmc = pmc;
+
+	clk = clk_register(NULL, &plldiv->hw);
+
+	if (IS_ERR(clk))
+		kfree(plldiv);
+
+	return clk;
+}
+
+static void __init
+of_at91_clk_plldiv_setup(struct device_node *np, struct at91_pmc *pmc)
+{
+	struct clk *clk;
+	const char *parent_name;
+	const char *name = np->name;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+
+	of_property_read_string(np, "clock-output-names", &name);
+
+	clk = at91_clk_register_plldiv(pmc, name, parent_name);
+
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	return;
+}
+
+void __init of_at91sam9x5_clk_plldiv_setup(struct device_node *np,
+					   struct at91_pmc *pmc)
+{
+	of_at91_clk_plldiv_setup(np, pmc);
+}
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 42f0c19..47aff40 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -221,6 +221,27 @@ static const struct of_device_id pmc_clk_ids[] __initdata = {
 		.compatible = "atmel,at91rm9200-clk-main",
 		.data = of_at91rm9200_clk_main_setup
 	},
+	/* PLL clocks */
+	{
+		.compatible = "atmel,at91rm9200-clk-pll",
+		.data = of_at91rm9200_clk_pll_setup,
+	},
+	{
+		.compatible = "atmel,at91sam9g45-clk-pll",
+		.data = of_at91sam9g45_clk_pll_setup,
+	},
+	{
+		.compatible = "atmel,at91sam9g20-clk-pllb",
+		.data = of_at91sam9g20_clk_pllb_setup,
+	},
+	{
+		.compatible = "atmel,sama5d3-clk-pll",
+		.data = of_sama5d3_clk_pll_setup,
+	},
+	{
+		.compatible = "atmel,at91sam9x5-clk-plldiv",
+		.data = of_at91sam9x5_clk_plldiv_setup,
+	},
 	{ /*sentinel*/ }
 };
 
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 294e230..35ccbbc 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -58,4 +58,15 @@ static inline void pmc_write(struct at91_pmc *pmc, int offset, u32 value)
 extern void __init of_at91rm9200_clk_main_setup(struct device_node *np,
 						struct at91_pmc *pmc);
 
+extern void __init of_at91rm9200_clk_pll_setup(struct device_node *np,
+					       struct at91_pmc *pmc);
+extern void __init of_at91sam9g45_clk_pll_setup(struct device_node *np,
+						struct at91_pmc *pmc);
+extern void __init of_at91sam9g20_clk_pllb_setup(struct device_node *np,
+						 struct at91_pmc *pmc);
+extern void __init of_sama5d3_clk_pll_setup(struct device_node *np,
+					    struct at91_pmc *pmc);
+extern void __init of_at91sam9x5_clk_plldiv_setup(struct device_node *np,
+						  struct at91_pmc *pmc);
+
 #endif /* __PMC_H_ */
diff --git a/include/linux/clk/at91_pmc.h b/include/linux/clk/at91_pmc.h
index 00c45b3..a6911eb 100644
--- a/include/linux/clk/at91_pmc.h
+++ b/include/linux/clk/at91_pmc.h
@@ -164,6 +164,8 @@ extern void __iomem *at91_pmc_base;
 #define		AT91_PMC_CFDEV		(1 << 18)		/* Clock Failure Detector Event [some SAM9] */
 #define	AT91_PMC_IMR		0x6c			/* Interrupt Mask Register */
 
+#define AT91_PMC_PLLICPR	0x80			/* PLL Charge Pump Current Register */
+
 #define AT91_PMC_PROT		0xe4			/* Write Protect Mode Register [some SAM9] */
 #define		AT91_PMC_WPEN		(0x1  <<  0)		/* Write Protect Enable */
 #define		AT91_PMC_WPKEY		(0xffffff << 8)		/* Write Protect Key */
-- 
1.7.9.5

