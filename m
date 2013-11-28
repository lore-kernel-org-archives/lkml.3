Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab3K1MoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:44:15 -0500
Received: from 11.mo6.mail-out.ovh.net ([188.165.38.119]:51486 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751332Ab3K1MoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:44:13 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH v6 07/16] clk: at91: add PMC master clock
Date: Thu, 28 Nov 2013 13:43:47 +0100
Message-Id: <1385642627-6837-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
References: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 4220717276047439980
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
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
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/clk/at91/Makefile     |    2 +-
 drivers/clk/at91/clk-master.c |  270 +++++++++++++++++++++++++++++++++++++++++
 drivers/clk/at91/clk-pll.c    |   10 +-
 drivers/clk/at91/pmc.c        |    9 ++
 drivers/clk/at91/pmc.h        |    5 +
 5 files changed, 287 insertions(+), 9 deletions(-)
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
index 0000000..bd313f7
--- /dev/null
+++ b/drivers/clk/at91/clk-master.c
@@ -0,0 +1,270 @@
+/*
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
+#define MASTER_PRES_MASK	0x7
+#define MASTER_PRES_MAX		MASTER_PRES_MASK
+#define MASTER_DIV_SHIFT	8
+#define MASTER_DIV_MASK		0x3
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
+	u32 tmp;
+
+	pmc_lock(pmc);
+	tmp = pmc_read(pmc, AT91_PMC_MCKR) & layout->mask;
+	pmc_unlock(pmc);
+
+	pres = (tmp >> layout->pres_shift) & MASTER_PRES_MASK;
+	div = (tmp >> MASTER_DIV_SHIFT) & MASTER_DIV_MASK;
+
+	if (characteristics->have_div3_pres && pres == MASTER_PRES_MAX)
+		rate /= 3;
+	else
+		rate >>= pres;
+
+	rate /= characteristics->divisors[div];
+
+	if (rate < characteristics->output.min)
+		pr_warn("master clk is underclocked");
+	else if (rate > characteristics->output.max)
+		pr_warn("master clk is overclocked");
+
+	return rate;
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
+static const struct clk_ops master_ops = {
+	.prepare = clk_master_prepare,
+	.is_prepared = clk_master_is_prepared,
+	.recalc_rate = clk_master_recalc_rate,
+	.get_parent = clk_master_get_parent,
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
+	struct clk_master_characteristics *characteristics;
+
+	characteristics = kzalloc(sizeof(*characteristics), GFP_KERNEL);
+	if (!characteristics)
+		return NULL;
+
+	if (of_at91_get_clk_range(np, "atmel,clk-output-range", &characteristics->output))
+		goto out_free_characteristics;
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
diff --git a/drivers/clk/at91/clk-pll.c b/drivers/clk/at91/clk-pll.c
index 5e23ee4..cf6ed02 100644
--- a/drivers/clk/at91/clk-pll.c
+++ b/drivers/clk/at91/clk-pll.c
@@ -80,6 +80,8 @@ static int clk_pll_prepare(struct clk_hw *hw)
 	struct clk_pll *pll = to_clk_pll(hw);
 	struct at91_pmc *pmc = pll->pmc;
 	const struct clk_pll_layout *layout = pll->layout;
+	const struct clk_pll_characteristics *characteristics =
+							pll->characteristics;
 	u8 id = pll->id;
 	u32 mask = PLL_STATUS_MASK(id);
 	int offset = PLL_REG(id);
@@ -269,18 +271,10 @@ static int clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 			    unsigned long parent_rate)
 {
 	struct clk_pll *pll = to_clk_pll(hw);
-	struct at91_pmc *pmc = pll->pmc;
-	const struct clk_pll_layout *layout = pll->layout;
-	const struct clk_pll_characteristics *characteristics =
-						pll->characteristics;
-	u8 id = pll->id;
-	int offset = PLL_REG(id);
 	long ret;
 	u32 div;
 	u32 mul;
 	u32 index;
-	u32 tmp;
-	u8 out = 0;
 
 	ret = clk_pll_get_best_div_mul(pll, rate, parent_rate,
 				       &div, &mul, &index);
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 5af3f2f..a311cf3 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -255,6 +255,15 @@ static const struct of_device_id pmc_clk_ids[] __initdata = {
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
index 15aaf38..be5c964 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -72,4 +72,9 @@ extern void __init of_sama5d3_clk_pll_setup(struct device_node *np,
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

