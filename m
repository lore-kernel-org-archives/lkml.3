Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab3JKJ7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:59:33 -0400
Received: from 3.mo1.mail-out.ovh.net ([46.105.60.232]:52109 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756629Ab3JKJ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:59:31 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH v4 11/17] clk: at91: add PMC programmable clocks
Date: Fri, 11 Oct 2013 11:57:04 +0200
Message-Id: <1381485424-13895-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com>
References: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 14670757261196884192
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new at91 programmable clocks implementation using common clk
framework.
A programmable clock is a clock which can be exported on a given pin to clock
external devices.
Each programmable clock is given an id (from 0 to 8).
The number of available programmable clocks depends on the SoC you're using.
Programmable clock driver only implements the clock setting (clock rate and
parent setting). It must be chained to a system clock in order to
enable/disable the generated clock.
The PCKX pins used to output the clock signals must be assigned to the
appropriate peripheral (see atmel's datasheets).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/Makefile           |    2 +
 drivers/clk/at91/clk-programmable.c |  423 +++++++++++++++++++++++++++++++++++
 drivers/clk/at91/pmc.c              |   15 ++
 drivers/clk/at91/pmc.h              |    9 +
 4 files changed, 449 insertions(+)
 create mode 100644 drivers/clk/at91/clk-programmable.c

diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 04deba3..3873b62 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -5,3 +5,5 @@
 obj-y += pmc.o
 obj-y += clk-main.o clk-pll.o clk-plldiv.o clk-master.o
 obj-y += clk-system.o clk-peripheral.o
+
+obj-$(CONFIG_AT91_PROGRAMMABLE_CLOCKS)	+= clk-programmable.o
diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
new file mode 100644
index 0000000..b34f80b
--- /dev/null
+++ b/drivers/clk/at91/clk-programmable.c
@@ -0,0 +1,423 @@
+/*
+ * drivers/clk/at91/clk-programmable.c
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
+#define PROG_SOURCE_MAX		5
+#define PROG_ID_MAX		7
+
+#define PROG_STATUS_MASK(id)	(1 << ((id) + 8))
+#define PROG_PRES_MASK		0x7
+#define PROG_MAX_RM9200_CSS	3
+
+struct clk_programmable_layout {
+	u8 pres_shift;
+	u8 css_mask;
+	u8 have_slck_mck;
+};
+
+struct clk_programmable {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+	unsigned int irq;
+	wait_queue_head_t wait;
+	u8 id;
+	u8 css;
+	u8 pres;
+	u8 slckmck;
+	const struct clk_programmable_layout *layout;
+};
+
+#define to_clk_programmable(hw) container_of(hw, struct clk_programmable, hw)
+
+
+static irqreturn_t clk_programmable_irq_handler(int irq, void *dev_id)
+{
+	struct clk_programmable *prog = (struct clk_programmable *)dev_id;
+
+	wake_up(&prog->wait);
+
+	return IRQ_HANDLED;
+}
+
+static int clk_programmable_prepare(struct clk_hw *hw)
+{
+	u32 tmp;
+	struct clk_programmable *prog = to_clk_programmable(hw);
+	struct at91_pmc *pmc = prog->pmc;
+	const struct clk_programmable_layout *layout = prog->layout;
+	u8 id = prog->id;
+	u32 mask = PROG_STATUS_MASK(id);
+
+	tmp = prog->css | (prog->pres << layout->pres_shift);
+	if (layout->have_slck_mck && prog->slckmck)
+		tmp |= AT91_PMC_CSSMCK_MCK;
+
+	pmc_write(pmc, AT91_PMC_PCKR(id), tmp);
+
+	while (!(pmc_read(pmc, AT91_PMC_SR) & mask))
+		wait_event(prog->wait, pmc_read(pmc, AT91_PMC_SR) & mask);
+
+	return 0;
+}
+
+static int clk_programmable_is_ready(struct clk_hw *hw)
+{
+	struct clk_programmable *prog = to_clk_programmable(hw);
+	struct at91_pmc *pmc = prog->pmc;
+
+	return !!(pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_PCKR(prog->id));
+}
+
+static unsigned long clk_programmable_recalc_rate(struct clk_hw *hw,
+						  unsigned long parent_rate)
+{
+	u32 tmp;
+	struct clk_programmable *prog = to_clk_programmable(hw);
+	struct at91_pmc *pmc = prog->pmc;
+	const struct clk_programmable_layout *layout = prog->layout;
+
+	tmp = pmc_read(pmc, AT91_PMC_PCKR(prog->id));
+	prog->pres = (tmp >> layout->pres_shift) & PROG_PRES_MASK;
+
+	return parent_rate >> prog->pres;
+}
+
+static long clk_programmable_round_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate)
+{
+	unsigned long best_rate = *parent_rate;
+	unsigned long best_diff;
+	unsigned long new_diff;
+	unsigned long cur_rate;
+	int shift = shift;
+
+	if (rate > *parent_rate)
+		return *parent_rate;
+	else
+		best_diff = *parent_rate - rate;
+
+	if (!best_diff)
+		return best_rate;
+
+	for (shift = 1; shift < PROG_PRES_MASK; shift++) {
+		cur_rate = *parent_rate >> shift;
+
+		if (cur_rate > rate)
+			new_diff = cur_rate - rate;
+		else
+			new_diff = rate - cur_rate;
+
+		if (!new_diff)
+			return cur_rate;
+
+		if (new_diff < best_diff) {
+			best_diff = new_diff;
+			best_rate = cur_rate;
+		}
+
+		if (rate > cur_rate)
+			break;
+	}
+
+	return best_rate;
+}
+
+static int clk_programmable_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_programmable *prog = to_clk_programmable(hw);
+	const struct clk_programmable_layout *layout = prog->layout;
+	if (index > layout->css_mask) {
+		if (index > PROG_MAX_RM9200_CSS && layout->have_slck_mck) {
+			prog->css = 0;
+			prog->slckmck = 1;
+			return 0;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	prog->css = index;
+	return 0;
+}
+
+static u8 clk_programmable_get_parent(struct clk_hw *hw)
+{
+	u32 tmp;
+	u8 ret;
+	struct clk_programmable *prog = to_clk_programmable(hw);
+	struct at91_pmc *pmc = prog->pmc;
+	const struct clk_programmable_layout *layout = prog->layout;
+
+	tmp = pmc_read(pmc, AT91_PMC_PCKR(prog->id));
+	prog->css = tmp & layout->css_mask;
+	ret = prog->css;
+	if (layout->have_slck_mck) {
+		prog->slckmck = !!(tmp & AT91_PMC_CSSMCK_MCK);
+		if (prog->slckmck && !ret)
+			ret = PROG_MAX_RM9200_CSS + 1;
+	}
+
+	return ret;
+}
+
+static int clk_programmable_set_rate(struct clk_hw *hw, unsigned long rate,
+				     unsigned long parent_rate)
+{
+	struct clk_programmable *prog = to_clk_programmable(hw);
+	unsigned long best_rate = parent_rate;
+	unsigned long best_diff;
+	unsigned long new_diff;
+	unsigned long cur_rate;
+	int shift = 0;
+
+	if (rate > parent_rate)
+		return parent_rate;
+	else
+		best_diff = parent_rate - rate;
+
+	if (!best_diff) {
+		prog->pres = shift;
+		return 0;
+	}
+
+	for (shift = 1; shift < PROG_PRES_MASK; shift++) {
+		cur_rate = parent_rate >> shift;
+
+		if (cur_rate > rate)
+			new_diff = cur_rate - rate;
+		else
+			new_diff = rate - cur_rate;
+
+		if (!new_diff)
+			break;
+
+		if (new_diff < best_diff) {
+			best_diff = new_diff;
+			best_rate = cur_rate;
+		}
+
+		if (rate > cur_rate)
+			break;
+	}
+
+	prog->pres = shift;
+	return 0;
+}
+
+static const struct clk_ops programmable_ops = {
+	.prepare = clk_programmable_prepare,
+	.is_prepared = clk_programmable_is_ready,
+	.recalc_rate = clk_programmable_recalc_rate,
+	.round_rate = clk_programmable_round_rate,
+	.get_parent = clk_programmable_get_parent,
+	.set_parent = clk_programmable_set_parent,
+	.set_rate = clk_programmable_set_rate,
+};
+
+static struct clk * __init
+at91_clk_register_programmable(struct at91_pmc *pmc, unsigned int irq,
+			       const char *name, const char **parent_names,
+			       u8 num_parents, u8 id,
+			       const struct clk_programmable_layout *layout)
+{
+	int ret;
+	struct clk_programmable *prog;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+	char irq_name[11];
+
+	if (id > PROG_ID_MAX)
+		return ERR_PTR(-EINVAL);
+
+	prog = kzalloc(sizeof(*prog), GFP_KERNEL);
+	if (!prog)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &programmable_ops;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+	init.flags = CLK_SET_RATE_GATE | CLK_SET_PARENT_GATE;
+
+	prog->id = id;
+	prog->layout = layout;
+	prog->hw.init = &init;
+	prog->pmc = pmc;
+	prog->irq = irq;
+	init_waitqueue_head(&prog->wait);
+	irq_set_status_flags(prog->irq, IRQ_NOAUTOEN);
+	snprintf(irq_name, sizeof(irq_name), "clk-prog%d", id);
+	ret = request_irq(prog->irq, clk_programmable_irq_handler,
+			  IRQF_TRIGGER_HIGH, irq_name, prog);
+	if (ret)
+		return ERR_PTR(ret);
+
+	clk = clk_register(NULL, &prog->hw);
+	if (IS_ERR(clk))
+		kfree(prog);
+
+	return clk;
+}
+
+static const struct clk_programmable_layout at91rm9200_programmable_layout = {
+	.pres_shift = 2,
+	.css_mask = 0x3,
+	.have_slck_mck = 0,
+};
+
+static const struct clk_programmable_layout at91sam9g45_programmable_layout = {
+	.pres_shift = 2,
+	.css_mask = 0x3,
+	.have_slck_mck = 1,
+};
+
+static const struct clk_programmable_layout at91sam9x5_programmable_layout = {
+	.pres_shift = 4,
+	.css_mask = 0x7,
+	.have_slck_mck = 0,
+};
+
+struct clk_prog_data {
+	struct clk **clks;
+	u8 *ids;
+	unsigned int clk_num;
+};
+
+static struct clk * __init
+of_clk_src_periph_get(struct of_phandle_args *clkspec, void *data)
+{
+	struct clk_prog_data *clk_data = data;
+	unsigned int id = clkspec->args[0];
+	int i;
+
+	if (id > PROG_ID_MAX)
+		goto err;
+
+	for (i = 0; i < clk_data->clk_num; i++) {
+		if (clk_data->ids[i] == id)
+			return clk_data->clks[i];
+	}
+
+err:
+	pr_err("%s: invalid clock id %d\n", __func__, id);
+	return ERR_PTR(-EINVAL);
+}
+
+static void __init
+of_at91_clk_prog_setup(struct device_node *np, struct at91_pmc *pmc,
+		       const struct clk_programmable_layout *layout)
+{
+	int num;
+	u32 id;
+	int i;
+	unsigned int irq;
+	struct clk *clk;
+	int num_parents;
+	u8 *ids;
+	struct clk **clks;
+	struct clk_prog_data *clktab;
+	const char *parent_names[PROG_SOURCE_MAX];
+	const char *name;
+	struct device_node *progclknp;
+
+	num_parents = of_count_phandle_with_args(np, "clocks", "#clock-cells");
+	if (num_parents <= 0 || num_parents > PROG_SOURCE_MAX)
+		return;
+
+	for (i = 0; i < num_parents; ++i) {
+		parent_names[i] = of_clk_get_parent_name(np, i);
+		if (!parent_names[i])
+			return;
+	}
+
+	num = of_get_child_count(np);
+	if (!num || num > (PROG_ID_MAX + 1))
+		return;
+
+	clktab = kzalloc(sizeof(*clktab), GFP_KERNEL);
+	if (!clktab)
+		return;
+
+	ids = kzalloc(num * sizeof(*ids), GFP_KERNEL);
+	if (!ids)
+		goto out_free_clktab;
+
+	clks = kzalloc(num * sizeof(*clks), GFP_KERNEL);
+	if (!clks)
+		goto out_free_ids;
+
+	i = 0;
+	for_each_child_of_node(np, progclknp) {
+		name = progclknp->name;
+
+		if (of_property_read_u32(progclknp, "atmel,clk-id", &id))
+			goto out_free_clks;
+
+		irq = irq_of_parse_and_map(np, 0);
+		if (!irq)
+			goto out_free_clks;
+
+		clk = at91_clk_register_programmable(pmc, irq, name,
+						     parent_names, num_parents,
+						     id, layout);
+		if (IS_ERR(clk))
+			goto out_free_clks;
+
+		clks[i] = clk;
+		ids[i++] = id;
+	}
+
+	clktab->clk_num = num;
+	clktab->clks = clks;
+	clktab->ids = ids;
+	of_clk_add_provider(np, of_clk_src_periph_get, clktab);
+	return;
+
+out_free_clks:
+	kfree(clks);
+out_free_ids:
+	kfree(ids);
+out_free_clktab:
+	kfree(clktab);
+}
+
+
+void __init of_at91rm9200_clk_prog_setup(struct device_node *np,
+					 struct at91_pmc *pmc)
+{
+	of_at91_clk_prog_setup(np, pmc, &at91rm9200_programmable_layout);
+}
+
+void __init of_at91sam9g45_clk_prog_setup(struct device_node *np,
+					  struct at91_pmc *pmc)
+{
+	of_at91_clk_prog_setup(np, pmc, &at91sam9g45_programmable_layout);
+}
+
+void __init of_at91sam9x5_clk_prog_setup(struct device_node *np,
+					 struct at91_pmc *pmc)
+{
+	of_at91_clk_prog_setup(np, pmc, &at91sam9x5_programmable_layout);
+}
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 8e27e92..5b8a959e 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -257,6 +257,21 @@ static const struct of_device_id pmc_clk_ids[] __initdata = {
 		.compatible = "atmel,at91sam9x5-clk-peripheral",
 		.data = of_at91sam9x5_clk_periph_setup,
 	},
+	/* Programmable clocks */
+#if defined(CONFIG_AT91_PROGRAMMABLE_CLOCKS)
+	{
+		.compatible = "atmel,at91rm9200-clk-programmable",
+		.data = of_at91rm9200_clk_prog_setup,
+	},
+	{
+		.compatible = "atmel,at91sam9g45-clk-programmable",
+		.data = of_at91sam9g45_clk_prog_setup,
+	},
+	{
+		.compatible = "atmel,at91sam9x5-clk-programmable",
+		.data = of_at91sam9x5_clk_prog_setup,
+	},
+#endif
 	{ /*sentinel*/ }
 };
 
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 08c30fb..5f20dc1 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -82,4 +82,13 @@ extern void __init of_at91rm9200_clk_periph_setup(struct device_node *np,
 extern void __init of_at91sam9x5_clk_periph_setup(struct device_node *np,
 						  struct at91_pmc *pmc);
 
+#if defined(CONFIG_AT91_PROGRAMMABLE_CLOCKS)
+extern void __init of_at91rm9200_clk_prog_setup(struct device_node *np,
+						struct at91_pmc *pmc);
+extern void __init of_at91sam9g45_clk_prog_setup(struct device_node *np,
+						 struct at91_pmc *pmc);
+extern void __init of_at91sam9x5_clk_prog_setup(struct device_node *np,
+						struct at91_pmc *pmc);
+#endif
+
 #endif /* __PMC_H_ */
-- 
1.7.9.5

