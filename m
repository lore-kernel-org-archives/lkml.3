Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3GQNoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:44:44 -0400
Received: from 12.mo1.mail-out.ovh.net ([87.98.162.229]:32886 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754804Ab3GQNom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:44:42 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 04/42] ARM: at91: add PMC master clock
Date: Wed, 17 Jul 2013 15:44:33 +0200
Message-Id: <1374068673-13818-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 11504445248565114988
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

This is the at91 master clock implementation using common clk framework.

The pll clock layout describe the MCKR register layout.
There's four pll clock layouts:
- at91rm9200
- at91sam9x5

Master clocks are given characteristics:
- min/max clock output rate

These characteristics are checked during rate change to avoid
over/underclocking.

These characteristics are described in atmel's SoC datasheet in
"Electrical Characteristics" paragraph.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/Makefile     |    2 +-
 drivers/clk/at91/clk-master.c |  317 +++++++++++++++++++++++++++++++++++++++++
 include/linux/clk/at91.h      |   23 +++
 3 files changed, 341 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/at91/clk-master.c

diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 564076f..d41f616 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -2,4 +2,4 @@
 # Makefile for at91 specific clk
 #
 
-obj-y += clk-main.o clk-pll.o clk-plldiv.o
+obj-y += clk-main.o clk-pll.o clk-plldiv.o clk-master.o
diff --git a/drivers/clk/at91/clk-master.c b/drivers/clk/at91/clk-master.c
new file mode 100644
index 0000000..71ade7d
--- /dev/null
+++ b/drivers/clk/at91/clk-master.c
@@ -0,0 +1,317 @@
+/*
+ * drivers/clk/at91/clk-master.c
+ *
+ *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * This masterram is free software; you can redistribute it and/or modify
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
+#define MASTER_SOURCE_MAX	4
+
+#define to_clk_master(hw) container_of(hw, struct clk_master, hw)
+
+struct clk_master {
+	struct clk_hw hw;
+	struct clk_master_layout *layout;
+	struct clk_master_characteristics *characteristics;
+};
+
+static unsigned long clk_master_recalc_rate(struct clk_hw *hw,
+					    unsigned long parent_rate)
+{
+	u8 pres;
+	u8 div;
+	unsigned long rate = parent_rate;
+	struct clk_master *master = to_clk_master(hw);
+	struct clk_master_layout *layout = master->layout;
+	struct clk_master_characteristics *characteristics =
+						master->characteristics;
+	u32 tmp = at91_pmc_read(AT91_PMC_MCKR) & layout->mask;
+
+	pres = (tmp >> layout->pres_shift) & 0x7;
+	div = (tmp >> 8) & 0x3;
+
+	if (characteristics->have_div3_pres && pres == 7)
+		rate /= 3;
+	else
+		rate >>= pres;
+
+	rate /= characteristics->divisors[div];
+
+	/* print overclocking or underclocking error */
+	/*
+	if (rate < characteristics->output.min ||
+	    rate > characteristics->output.max) {
+	}
+	*/
+	return rate;
+}
+
+static long clk_master_round_rate(struct clk_hw *hw, unsigned long rate,
+				  unsigned long *parent_rate)
+{
+	int mdiv;
+	int pres;
+	u32 div;
+	long best_rate = -EINVAL;
+	unsigned long best_diff = 0;
+	unsigned long cur_diff;
+	unsigned long pres_rate;
+	unsigned long cur_rate;
+	struct clk_master *master = to_clk_master(hw);
+	struct clk_master_characteristics *characteristics =
+						master->characteristics;
+
+	if (rate < characteristics->output.min ||
+	    rate > characteristics->output.max)
+		return -EINVAL;
+
+	for (pres = 0; pres < 7; pres++) {
+		if (pres < 7)
+			pres_rate = *parent_rate >> pres;
+		else {
+			if (!characteristics->have_div3_pres)
+				break;
+			pres_rate = *parent_rate / 3;
+		}
+		for (mdiv = 0; mdiv < 4; mdiv++) {
+			div = characteristics->divisors[mdiv];
+			if (!div)
+				continue;
+			cur_rate = pres_rate / div;
+			if (rate < cur_rate)
+				cur_diff = cur_rate - rate;
+			else
+				cur_diff = rate - cur_rate;
+
+			if (best_rate < 0 || cur_diff < best_diff) {
+				best_rate = cur_rate;
+				best_diff = cur_diff;
+				if (!best_diff)
+					return best_rate;
+			}
+		}
+	}
+
+	return best_rate;
+}
+
+static int clk_master_set_parent(struct clk_hw *hw, u8 index)
+{
+	u32 tmp;
+	if (index > AT91_PMC_CSS)
+		return -EINVAL;
+	tmp = at91_pmc_read(AT91_PMC_MCKR) & ~AT91_PMC_CSS;
+	tmp |= index;
+
+	at91_pmc_write(AT91_PMC_MCKR, tmp);
+	while (!(at91_pmc_read(AT91_PMC_SR) & AT91_PMC_MCKRDY))
+		;
+	return 0;
+}
+
+static u8 clk_master_get_parent(struct clk_hw *hw)
+{
+	return at91_pmc_read(AT91_PMC_MCKR) & AT91_PMC_CSS;
+}
+
+static int clk_master_set_rate(struct clk_hw *hw, unsigned long rate,
+			       unsigned long parent_rate)
+{
+	int mdiv;
+	int pres;
+	u32 div;
+	u32 tmp;
+	unsigned long cur_rate;
+	unsigned long pres_rate;
+	struct clk_master *master = to_clk_master(hw);
+	struct clk_master_layout *layout = master->layout;
+	struct clk_master_characteristics *characteristics =
+						master->characteristics;
+	for (pres = 0; pres < 7; pres++) {
+		if (pres < 7)
+			pres_rate = parent_rate >> pres;
+		else {
+			if (!characteristics->have_div3_pres)
+				break;
+			pres_rate = parent_rate / 3;
+		}
+		for (mdiv = 0; mdiv < 4; mdiv++) {
+			div = characteristics->divisors[mdiv];
+			if (!div)
+				continue;
+			cur_rate = pres_rate / div;
+			if (cur_rate == rate) {
+				tmp = at91_pmc_read(AT91_PMC_MCKR);
+				tmp &= layout->mask;
+				tmp &= ~AT91_PMC_CSS;
+				tmp |= pres << layout->pres_shift | mdiv << 8;
+
+				at91_pmc_write(AT91_PMC_MCKR, tmp);
+				while (!(at91_pmc_read(AT91_PMC_SR) &
+					 AT91_PMC_MCKRDY))
+					;
+				return 0;
+			}
+		}
+	}
+
+	return -EINVAL;
+}
+
+static const struct clk_ops master_ops = {
+	.recalc_rate = clk_master_recalc_rate,
+	.round_rate = clk_master_round_rate,
+	.get_parent = clk_master_get_parent,
+	.set_parent = clk_master_set_parent,
+	.set_rate = clk_master_set_rate,
+};
+
+struct clk * __init
+at91_clk_register_master(const char *name,
+			 int num_parents,
+			 const char **parent_names,
+			 struct clk_master_layout *layout,
+			 struct clk_master_characteristics *characteristics)
+{
+	struct clk_master *master;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	master = kzalloc(sizeof(*master), GFP_KERNEL);
+	if (!master)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &master_ops;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+	init.flags = CLK_SET_RATE_GATE | CLK_SET_PARENT_GATE;
+
+	master->hw.init = &init;
+	master->layout = layout;
+	master->characteristics = characteristics;
+
+	clk = clk_register(NULL, &master->hw);
+
+	if (IS_ERR(clk))
+		kfree(master);
+
+	return clk;
+}
+
+
+struct clk_master_layout at91rm9200_master_layout = {
+	.mask = 0x31F,
+	.pres_shift = 2,
+};
+
+struct clk_master_layout at91sam9x5_master_layout = {
+	.mask = 0x373,
+	.pres_shift = 4,
+};
+
+
+#if defined(CONFIG_OF)
+static struct clk_master_characteristics * __init
+of_at91_clk_master_get_characteristics(struct device_node *np)
+{
+	int i;
+	u32 tmp;
+	struct clk_master_characteristics *characteristics = NULL;
+
+	characteristics = kzalloc(sizeof(*characteristics), GFP_KERNEL);
+	if (!characteristics)
+		return NULL;
+
+	if (of_property_read_u32_index(np, "output", 0, &tmp))
+		goto out_free_characteristics;
+
+	characteristics->output.min = tmp;
+
+	if (of_property_read_u32_index(np, "output", 1, &tmp))
+		goto out_free_characteristics;
+
+	characteristics->output.max = tmp;
+
+	for (i = 0; i < 4; i++) {
+		tmp = 0;
+		of_property_read_u32_index(np, "divisors", i, &tmp);
+		characteristics->divisors[i] = tmp;
+	}
+
+	characteristics->have_div3_pres =
+		of_property_read_bool(np, "have-div3-pres");
+
+	return characteristics;
+
+out_free_characteristics:
+	kfree(characteristics);
+	return NULL;
+}
+
+static void __init
+of_at91_clk_master_setup(struct device_node *np,
+			 struct clk_master_layout *layout)
+{
+	struct clk *clk;
+	int num_parents;
+	int i;
+	const char *parent_names[MASTER_SOURCE_MAX];
+	const char *name = np->name;
+	struct clk_master_characteristics *characteristics;
+
+	num_parents = of_count_phandle_with_args(np, "clocks", "#clock-cells");
+	if (num_parents <= 0 || num_parents > MASTER_SOURCE_MAX)
+		return;
+
+	for (i = 0; i < num_parents; ++i) {
+		parent_names[i] = of_clk_get_parent_name(np, i);
+		if (!parent_names[i])
+			return;
+	}
+
+	of_property_read_string(np, "clock-output-names", &name);
+
+	characteristics = of_at91_clk_master_get_characteristics(np);
+	if (!characteristics)
+		return;
+
+	clk = at91_clk_register_master(name, num_parents, parent_names,
+				       layout, characteristics);
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
+static void __init of_at91rm9200_clk_master_setup(struct device_node *np)
+{
+	of_at91_clk_master_setup(np, &at91rm9200_master_layout);
+}
+CLK_OF_DECLARE(at91rm9200_clk_master, "atmel,at91rm9200-clk-master",
+	       of_at91rm9200_clk_master_setup);
+
+static void __init of_at91sam9x5_clk_master_setup(struct device_node *np)
+{
+	of_at91_clk_master_setup(np, &at91sam9x5_master_layout);
+}
+CLK_OF_DECLARE(at91sam9x5_clk_master, "atmel,at91sam9x5-clk-master",
+	       of_at91sam9x5_clk_master_setup);
+#endif
diff --git a/include/linux/clk/at91.h b/include/linux/clk/at91.h
index 51b7134..324134c 100644
--- a/include/linux/clk/at91.h
+++ b/include/linux/clk/at91.h
@@ -213,6 +213,17 @@ struct clk_pll_layout {
 	u8 mul_shift;
 };
 
+struct clk_master_characteristics {
+	struct clk_range output;
+	u32 divisors[4];
+	u8 have_div3_pres;
+};
+
+struct clk_master_layout {
+	u32 mask;
+	u8 pres_shift;
+};
+
 
 struct clk * __init
 at91_clk_register_main(const char *name,
@@ -236,4 +247,16 @@ at91_clk_register_pll(const char *name, const char *parent_name, u8 id,
 struct clk * __init
 at91_clk_register_plldiv(const char *name, const char *parent_name);
 
+
+extern struct clk_master_layout at91rm9200_master_layout;
+
+extern struct clk_master_layout at91sam9x5_master_layout;
+
+struct clk * __init
+at91_clk_register_master(const char *name, int num_parents,
+			 const char **parent_names,
+			 struct clk_master_layout *layout,
+			 struct clk_master_characteristics *characteristics);
+
+
 #endif
-- 
1.7.9.5

