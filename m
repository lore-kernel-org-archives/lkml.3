Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab3HHGMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 02:12:20 -0400
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:59286 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932694Ab3HHGMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 02:12:19 -0400
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
Subject: [PATCH v3 08/19] clk: at91: add PMC master clock
Date: Thu,  8 Aug 2013 08:10:55 +0200
Message-Id: <1375942255-8929-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 3982870920969287728
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

This patch adds new at91 master clock implementation using common clk
framework.

The master clock layout describe the MCKR register layout.
There are 2 master clock layouts:
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
 drivers/clk/at91/clk-master.c |  386 +++++++++++++++++++++++++++++++++++++++++
 drivers/clk/at91/pmc.c        |    9 +
 drivers/clk/at91/pmc.h        |    5 +
 4 files changed, 401 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/at91/clk-master.c

diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 902bbf1..e28fb2b 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -3,4 +3,4 @@
 #
 
 obj-y += pmc.o
-obj-y += clk-main.o clk-pll.o clk-plldiv.o
+obj-y += clk-main.o clk-pll.o clk-plldiv.o clk-master.o
diff --git a/drivers/clk/at91/clk-master.c b/drivers/clk/at91/clk-master.c
new file mode 100644
index 0000000..f8f111d
--- /dev/null
+++ b/drivers/clk/at91/clk-master.c
@@ -0,0 +1,386 @@
+/*
+ * drivers/clk/at91/clk-master.c
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
+#define MASTER_SOURCE_MAX	4
+
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
+#define to_clk_master(hw) container_of(hw, struct clk_master, hw)
+
+struct clk_master {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+	unsigned int irq;
+	wait_queue_head_t wait;
+	const struct clk_master_layout *layout;
+	const struct clk_master_characteristics *characteristics;
+};
+
+static irqreturn_t clk_master_irq_handler(int irq, void *dev_id)
+{
+	struct clk_master *master = (struct clk_master *)dev_id;
+
+	wake_up(&master->wait);
+	disable_irq_nosync(master->irq);
+
+	return IRQ_HANDLED;
+}
+static int clk_master_prepare(struct clk_hw *hw)
+{
+	struct clk_master *master = to_clk_master(hw);
+	struct at91_pmc *pmc = master->pmc;
+
+	while (!(pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MCKRDY)) {
+		enable_irq(master->irq);
+		wait_event(master->wait,
+			   pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MCKRDY);
+	}
+
+	return 0;
+}
+
+static int clk_master_is_prepared(struct clk_hw *hw)
+{
+	struct clk_master *master = to_clk_master(hw);
+
+	return !!(pmc_read(master->pmc, AT91_PMC_SR) & AT91_PMC_MCKRDY);
+}
+
+static unsigned long clk_master_recalc_rate(struct clk_hw *hw,
+					    unsigned long parent_rate)
+{
+	u8 pres;
+	u8 div;
+	unsigned long rate = parent_rate;
+	struct clk_master *master = to_clk_master(hw);
+	struct at91_pmc *pmc = master->pmc;
+	const struct clk_master_layout *layout = master->layout;
+	const struct clk_master_characteristics *characteristics =
+						master->characteristics;
+	u32 tmp = pmc_read(pmc, AT91_PMC_MCKR) & layout->mask;
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
+	const struct clk_master_characteristics *characteristics =
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
+	struct clk_master *master = to_clk_master(hw);
+	struct at91_pmc *pmc = master->pmc;
+
+	if (index > AT91_PMC_CSS)
+		return -EINVAL;
+
+	pmc_lock(pmc);
+	tmp = pmc_read(pmc, AT91_PMC_MCKR) & ~AT91_PMC_CSS;
+	tmp |= index;
+
+	pmc_write(pmc, AT91_PMC_MCKR, tmp);
+	pmc_unlock(pmc);
+
+	return 0;
+}
+
+static u8 clk_master_get_parent(struct clk_hw *hw)
+{
+	struct clk_master *master = to_clk_master(hw);
+	struct at91_pmc *pmc = master->pmc;
+
+	return pmc_read(pmc, AT91_PMC_MCKR) & AT91_PMC_CSS;
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
+	struct at91_pmc *pmc = master->pmc;
+	const struct clk_master_layout *layout = master->layout;
+	const struct clk_master_characteristics *characteristics =
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
+				tmp = pmc_read(pmc, AT91_PMC_MCKR);
+				tmp &= layout->mask;
+				tmp &= ~AT91_PMC_CSS;
+				tmp |= pres << layout->pres_shift | mdiv << 8;
+
+				pmc_write(pmc, AT91_PMC_MCKR, tmp);
+
+				return 0;
+			}
+		}
+	}
+
+	return -EINVAL;
+}
+
+static const struct clk_ops master_ops = {
+	.prepare = clk_master_prepare,
+	.is_prepared = clk_master_is_prepared,
+	.recalc_rate = clk_master_recalc_rate,
+	.round_rate = clk_master_round_rate,
+	.get_parent = clk_master_get_parent,
+	.set_parent = clk_master_set_parent,
+	.set_rate = clk_master_set_rate,
+};
+
+static struct clk * __init
+at91_clk_register_master(struct at91_pmc *pmc, unsigned int irq,
+		const char *name, int num_parents,
+		const char **parent_names,
+		const struct clk_master_layout *layout,
+		const struct clk_master_characteristics *characteristics)
+{
+	int ret;
+	struct clk_master *master;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	if (!pmc || !irq || !name || !num_parents || !parent_names)
+		return ERR_PTR(-EINVAL);
+
+	master = kzalloc(sizeof(*master), GFP_KERNEL);
+	if (!master)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &master_ops;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+	init.flags = 0;
+
+	master->hw.init = &init;
+	master->layout = layout;
+	master->characteristics = characteristics;
+	master->pmc = pmc;
+	master->irq = irq;
+	init_waitqueue_head(&master->wait);
+	irq_set_status_flags(master->irq, IRQ_NOAUTOEN);
+	ret = request_irq(master->irq, clk_master_irq_handler,
+			  IRQF_TRIGGER_HIGH, "clk-master", master);
+	if (ret)
+		return ERR_PTR(ret);
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
+static const struct clk_master_layout at91rm9200_master_layout = {
+	.mask = 0x31F,
+	.pres_shift = 2,
+};
+
+static const struct clk_master_layout at91sam9x5_master_layout = {
+	.mask = 0x373,
+	.pres_shift = 4,
+};
+
+
+static struct clk_master_characteristics * __init
+of_at91_clk_master_get_characteristics(struct device_node *np)
+{
+	u32 tmp;
+	struct clk_master_characteristics *characteristics;
+
+	characteristics = kzalloc(sizeof(*characteristics), GFP_KERNEL);
+	if (!characteristics)
+		return NULL;
+
+	if (of_property_read_u32_index(np, "atmel,clk-output-range", 0, &tmp))
+		goto out_free_characteristics;
+	characteristics->output.min = tmp;
+
+	if (of_property_read_u32_index(np, "atmel,clk-output-range", 1, &tmp))
+		goto out_free_characteristics;
+	characteristics->output.max = tmp;
+
+	of_property_read_u32_array(np, "atmel,clk-divisors",
+				   characteristics->divisors, 4);
+
+	characteristics->have_div3_pres =
+		of_property_read_bool(np, "atmel,master-clk-have-div3-pres");
+
+	return characteristics;
+
+out_free_characteristics:
+	kfree(characteristics);
+	return NULL;
+}
+
+static void __init
+of_at91_clk_master_setup(struct device_node *np, struct at91_pmc *pmc,
+			 const struct clk_master_layout *layout)
+{
+	struct clk *clk;
+	int num_parents;
+	int i;
+	unsigned int irq;
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
+	irq = irq_of_parse_and_map(np, 0);
+	if (!irq)
+		return;
+
+	clk = at91_clk_register_master(pmc, irq, name, num_parents,
+				       parent_names, layout,
+				       characteristics);
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
+void __init of_at91rm9200_clk_master_setup(struct device_node *np,
+					   struct at91_pmc *pmc)
+{
+	of_at91_clk_master_setup(np, pmc, &at91rm9200_master_layout);
+}
+
+void __init of_at91sam9x5_clk_master_setup(struct device_node *np,
+					   struct at91_pmc *pmc)
+{
+	of_at91_clk_master_setup(np, pmc, &at91sam9x5_master_layout);
+}
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 47aff40..5258f1d 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -242,6 +242,15 @@ static const struct of_device_id pmc_clk_ids[] __initdata = {
 		.compatible = "atmel,at91sam9x5-clk-plldiv",
 		.data = of_at91sam9x5_clk_plldiv_setup,
 	},
+	/* Master clock */
+	{
+		.compatible = "atmel,at91rm9200-clk-master",
+		.data = of_at91rm9200_clk_master_setup,
+	},
+	{
+		.compatible = "atmel,at91sam9x5-clk-master",
+		.data = of_at91sam9x5_clk_master_setup,
+	},
 	{ /*sentinel*/ }
 };
 
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 35ccbbc..2e1dcb8 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -69,4 +69,9 @@ extern void __init of_sama5d3_clk_pll_setup(struct device_node *np,
 extern void __init of_at91sam9x5_clk_plldiv_setup(struct device_node *np,
 						  struct at91_pmc *pmc);
 
+extern void __init of_at91rm9200_clk_master_setup(struct device_node *np,
+						  struct at91_pmc *pmc);
+extern void __init of_at91sam9x5_clk_master_setup(struct device_node *np,
+						  struct at91_pmc *pmc);
+
 #endif /* __PMC_H_ */
-- 
1.7.9.5

