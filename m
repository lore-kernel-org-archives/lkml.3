Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3GQNry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:47:54 -0400
Received: from 10.mo1.mail-out.ovh.net ([178.32.96.102]:52338 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755587Ab3GQNrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:47:53 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 07/42] ARM: at91: add PMC programmable clocks
Date: Wed, 17 Jul 2013 15:47:46 +0200
Message-Id: <1374068866-13977-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 11558769919881607276
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

This is the at91 programmable clocks implementation using common clk
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
 drivers/clk/at91/clk-programmable.c |  368 +++++++++++++++++++++++++++++++++++
 include/linux/clk/at91.h            |   18 ++
 3 files changed, 388 insertions(+)
 create mode 100644 drivers/clk/at91/clk-programmable.c

diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 3e2a670..2d7c119 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -4,3 +4,5 @@
 
 obj-y += clk-main.o clk-pll.o clk-plldiv.o clk-master.o
 obj-y += clk-system.o clk-peripheral.o
+
+obj-$(CONFIG_AT91_PROGRAMMABLE_CLOCKS)	+= clk-programmable.o
diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
new file mode 100644
index 0000000..21829fc
--- /dev/null
+++ b/drivers/clk/at91/clk-programmable.c
@@ -0,0 +1,368 @@
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
+#include <linux/clk/at91.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+
+#define PROG_SOURCE_MAX		5
+#define PROG_MAX		8
+
+#define to_clk_programmable(hw) container_of(hw, struct clk_programmable, hw)
+struct clk_programmable {
+	struct clk_hw hw;
+	u8 id;
+	u8 css;
+	u8 pres;
+	u8 slckmck;
+	struct clk_programmable_layout *layout;
+};
+
+static int clk_programmable_prepare(struct clk_hw *hw)
+{
+	u32 tmp;
+	struct clk_programmable *prog = to_clk_programmable(hw);
+	struct clk_programmable_layout *layout = prog->layout;
+	tmp = prog->css | (prog->pres << layout->pres_shift);
+	if (layout->have_slck_mck && prog->slckmck)
+		tmp |= 1 << 8;
+	at91_pmc_write(AT91_PMC_PCKR(prog->id), tmp);
+	while (!(at91_pmc_read(AT91_PMC_SR) & (1 << (prog->id + 8))))
+		;
+	return 0;
+}
+
+static int clk_programmable_is_prepared(struct clk_hw *hw)
+{
+	struct clk_programmable *prog = to_clk_programmable(hw);
+	return !!(at91_pmc_read(AT91_PMC_SR) & (1 << (prog->id + 8)));
+}
+
+static unsigned long clk_programmable_recalc_rate(struct clk_hw *hw,
+						  unsigned long parent_rate)
+{
+	u32 tmp;
+	struct clk_programmable *prog = to_clk_programmable(hw);
+	struct clk_programmable_layout *layout = prog->layout;
+	tmp = at91_pmc_read(AT91_PMC_PCKR(prog->id));
+	prog->pres = (tmp >> layout->pres_shift) & 0x7;
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
+	for (shift = 1; shift < 7; shift++) {
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
+
+	}
+
+	return best_rate;
+}
+
+static int clk_programmable_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_programmable *prog = to_clk_programmable(hw);
+	struct clk_programmable_layout *layout = prog->layout;
+	if (index > layout->css_mask) {
+		if (index == 4 && layout->have_slck_mck) {
+			prog->css = 0;
+			prog->slckmck = 1;
+			return 0;
+		} else
+			return -EINVAL;
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
+	struct clk_programmable_layout *layout = prog->layout;
+	tmp = at91_pmc_read(AT91_PMC_PCKR(prog->id));
+	prog->css = tmp & layout->css_mask;
+	ret = prog->css;
+	if (layout->have_slck_mck) {
+		prog->slckmck = !!(tmp & (1 << 8));
+		if (prog->slckmck && !ret)
+			ret = 4;
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
+	for (shift = 1; shift < 7; shift++) {
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
+
+	}
+
+	prog->pres = shift;
+	return 0;
+}
+
+static const struct clk_ops programmable_ops = {
+	.prepare = clk_programmable_prepare,
+	.is_prepared = clk_programmable_is_prepared,
+	.recalc_rate = clk_programmable_recalc_rate,
+	.round_rate = clk_programmable_round_rate,
+	.get_parent = clk_programmable_get_parent,
+	.set_parent = clk_programmable_set_parent,
+	.set_rate = clk_programmable_set_rate,
+};
+
+struct clk * __init
+at91_clk_register_programmable(const char *name, const char **parent_names,
+			       u8 num_parents, u8 id,
+			       struct clk_programmable_layout *layout)
+{
+	struct clk_programmable *prog;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	id &= 7;
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
+
+	clk = clk_register(NULL, &prog->hw);
+
+	if (IS_ERR(clk))
+		kfree(prog);
+
+	return clk;
+}
+
+struct clk_programmable_layout at91rm9200_programmable_layout = {
+	.pres_shift = 2,
+	.css_mask = 0x3,
+	.have_slck_mck = 0,
+};
+
+struct clk_programmable_layout at91sam9g45_programmable_layout = {
+	.pres_shift = 2,
+	.css_mask = 0x3,
+	.have_slck_mck = 1,
+};
+
+struct clk_programmable_layout at91sam9x5_programmable_layout = {
+	.pres_shift = 4,
+	.css_mask = 0x7,
+	.have_slck_mck = 0,
+};
+
+#if defined(CONFIG_OF)
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
+	if (id >= PROG_MAX)
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
+of_at91_clk_prog_setup(struct device_node *np,
+		       struct clk_programmable_layout *layout)
+{
+	int num;
+	u32 id;
+	int i;
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
+	if (!num || num > PROG_MAX)
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
+		if (of_property_read_u32(progclknp, "id", &id))
+			goto out_free_clks;
+		if (id >= PROG_MAX)
+			goto out_free_clks;
+
+		clk = at91_clk_register_programmable(name, parent_names,
+						     num_parents, id, layout);
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
+static void __init of_at91rm9200_clk_prog_setup(struct device_node *np)
+{
+	of_at91_clk_prog_setup(np, &at91rm9200_programmable_layout);
+}
+CLK_OF_DECLARE(at91rm9200_clk_prog, "atmel,at91rm9200-clk-programmable",
+	       of_at91rm9200_clk_prog_setup);
+
+static void __init of_at91sam9g45_clk_prog_setup(struct device_node *np)
+{
+	of_at91_clk_prog_setup(np, &at91sam9g45_programmable_layout);
+}
+CLK_OF_DECLARE(at91sam9g45_clk_prog, "atmel,at91sam9g45-clk-programmable",
+	       of_at91sam9g45_clk_prog_setup);
+
+static void __init of_at91sam9x5_clk_prog_setup(struct device_node *np)
+{
+	of_at91_clk_prog_setup(np, &at91sam9x5_programmable_layout);
+}
+CLK_OF_DECLARE(at91sam9x5_clk_prog, "atmel,at91sam9x5-clk-programmable",
+	       of_at91sam9x5_clk_prog_setup);
+#endif
diff --git a/include/linux/clk/at91.h b/include/linux/clk/at91.h
index 112a060..3cafd36 100644
--- a/include/linux/clk/at91.h
+++ b/include/linux/clk/at91.h
@@ -224,6 +224,12 @@ struct clk_master_layout {
 	u8 pres_shift;
 };
 
+struct clk_programmable_layout {
+	u8 pres_shift;
+	u8 css_mask;
+	u8 have_slck_mck;
+};
+
 
 struct clk * __init
 at91_clk_register_main(const char *name,
@@ -270,4 +276,16 @@ struct clk * __init
 at91_clk_register_sam9x5_peripheral(const char *name, const char *parent_name,
 				    u32 id, u32 default_div);
 
+
+extern struct clk_programmable_layout at91rm9200_programmable_layout;
+
+extern struct clk_programmable_layout at91sam9g45_programmable_layout;
+
+extern struct clk_programmable_layout at91sam9x5_programmable_layout;
+
+struct clk * __init
+at91_clk_register_programmable(const char *name, const char **parent_names,
+			       u8 num_parents, u8 id,
+			       struct clk_programmable_layout *layout);
+
 #endif
-- 
1.7.9.5

