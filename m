Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3GQNrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:47:06 -0400
Received: from 3.mo1.mail-out.ovh.net ([46.105.60.232]:55533 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754804Ab3GQNrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:47:03 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 06/42] ARM: at91: add PMC peripheral clocks
Date: Wed, 17 Jul 2013 15:46:56 +0200
Message-Id: <1374068816-13935-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 11544696170829281388
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

This is the at91 peripheral clock implementation using common clk framework.

Almost all peripherals provided by an at91 SoC need a clock to work properly.
This clock is enabled/disabled using PCER/PCDR resgisters.

Each peripheral is given an id (see atmel's datasheets) which is used as bit
position in SCER/SCDR registers.

Some new SoCs (at91sam9x5 and sama5d3) provide a new register (PCR) where you
can configure the peripheral clock as a division of the master clock.
This will help reducing the peripherals power comsumption.

This patch fixes erronous AT91_PMC_PCR_DIV values.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/Makefile         |    2 +-
 drivers/clk/at91/clk-peripheral.c |  371 +++++++++++++++++++++++++++++++++++++
 include/linux/clk/at91.h          |    8 +
 3 files changed, 380 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/at91/clk-peripheral.c

diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 13e5714..3e2a670 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -3,4 +3,4 @@
 #
 
 obj-y += clk-main.o clk-pll.o clk-plldiv.o clk-master.o
-obj-y += clk-system.o
+obj-y += clk-system.o clk-peripheral.o
diff --git a/drivers/clk/at91/clk-peripheral.c b/drivers/clk/at91/clk-peripheral.c
new file mode 100644
index 0000000..11be85ea
--- /dev/null
+++ b/drivers/clk/at91/clk-peripheral.c
@@ -0,0 +1,371 @@
+/*
+ * drivers/clk/at91/clk-peripheral.c
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
+#define PERIPHERAL_MAX		64
+
+#define PERIPHERAL_AT91RM9200	0
+#define PERIPHERAL_AT91SAM9X5	1
+
+#define to_clk_peripheral(hw) container_of(hw, struct clk_peripheral, hw)
+struct clk_peripheral {
+	struct clk_hw hw;
+	u32 id;
+};
+
+#define to_clk_sam9x5_peripheral(hw) \
+	container_of(hw, struct clk_sam9x5_peripheral, hw)
+struct clk_sam9x5_peripheral {
+	struct clk_hw hw;
+	u32 id;
+	u8 div;
+	u8 have_div_support;
+};
+
+static int clk_peripheral_enable(struct clk_hw *hw)
+{
+	struct clk_peripheral *periph = to_clk_peripheral(hw);
+	int offset = AT91_PMC_PCER;
+	if (periph->id < 2)
+		return 0;
+	if (periph->id > 31)
+		offset = AT91_PMC_PCER1;
+	at91_pmc_write(offset, 1 << (periph->id & 31));
+	return 0;
+}
+
+static void clk_peripheral_disable(struct clk_hw *hw)
+{
+	struct clk_peripheral *periph = to_clk_peripheral(hw);
+	int offset = AT91_PMC_PCDR;
+	if (periph->id < 2)
+		return;
+	if (periph->id > 31)
+		offset = AT91_PMC_PCDR1;
+	at91_pmc_write(offset, 1 << (periph->id & 31));
+}
+
+static int clk_peripheral_is_enabled(struct clk_hw *hw)
+{
+	struct clk_peripheral *periph = to_clk_peripheral(hw);
+	int offset = AT91_PMC_PCSR;
+	if (periph->id < 2)
+		return 1;
+	if (periph->id > 31)
+		offset = AT91_PMC_PCSR1;
+	return !!(at91_pmc_read(offset) & (1 << (periph->id & 31)));
+}
+
+static const struct clk_ops peripheral_ops = {
+	.enable = clk_peripheral_enable,
+	.disable = clk_peripheral_disable,
+	.is_enabled = clk_peripheral_is_enabled,
+};
+
+struct clk * __init at91_clk_register_peripheral(const char *name,
+						 const char *parent_name,
+						 u32 id)
+{
+	struct clk_peripheral *periph;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	id &= 31;
+	periph = kzalloc(sizeof(*periph), GFP_KERNEL);
+	if (!periph)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &peripheral_ops;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+	init.flags = 0;
+
+	periph->id = id;
+	periph->hw.init = &init;
+
+	clk = clk_register(NULL, &periph->hw);
+	if (IS_ERR(clk))
+		kfree(periph);
+
+	return clk;
+}
+
+static int clk_sam9x5_peripheral_enable(struct clk_hw *hw)
+{
+	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
+	if (periph->id < 2)
+		return 0;
+	at91_pmc_write(AT91_PMC_PCR,
+		       (periph->id & AT91_PMC_PCR_PID) |
+		       AT91_PMC_PCR_CMD |
+		       AT91_PMC_PCR_DIV(periph->div) |
+		       AT91_PMC_PCR_EN);
+	return 0;
+}
+
+static void clk_sam9x5_peripheral_disable(struct clk_hw *hw)
+{
+	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
+	if (periph->id < 2)
+		return;
+
+	at91_pmc_write(AT91_PMC_PCR,
+		       (periph->id & AT91_PMC_PCR_PID) |
+		       AT91_PMC_PCR_CMD);
+}
+
+static int clk_sam9x5_peripheral_is_enabled(struct clk_hw *hw)
+{
+	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
+	if (periph->id < 2)
+		return 1;
+	at91_pmc_write(AT91_PMC_PCR,
+		       (periph->id & AT91_PMC_PCR_PID));
+	return !!(at91_pmc_read(AT91_PMC_PCR) & AT91_PMC_PCR_EN);
+}
+
+static unsigned long
+clk_sam9x5_peripheral_recalc_rate(struct clk_hw *hw,
+				  unsigned long parent_rate)
+{
+	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
+	u32 shift;
+	if (periph->id < 2 || !periph->have_div_support)
+		return parent_rate;
+	at91_pmc_write(AT91_PMC_PCR,
+		       (periph->id & AT91_PMC_PCR_PID));
+	shift = (at91_pmc_read(AT91_PMC_PCR) >> 16) & 0x3;
+	return parent_rate >> shift;
+}
+
+static long clk_sam9x5_peripheral_round_rate(struct clk_hw *hw,
+					     unsigned long rate,
+					     unsigned long *parent_rate)
+{
+	int shift;
+	unsigned long best_rate;
+	unsigned long best_diff;
+	unsigned long cur_rate;
+	unsigned long cur_diff;
+	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
+	if (periph->id < 2 || !periph->have_div_support)
+		return *parent_rate;
+	if (rate >= *parent_rate)
+		return rate;
+	best_diff = *parent_rate - rate;
+	best_rate = *parent_rate;
+	for (shift = 1; shift < 4; shift++) {
+		cur_rate = *parent_rate >> shift;
+		if (cur_rate < rate)
+			cur_diff = rate - cur_rate;
+		else
+			cur_diff = cur_rate - rate;
+		if (cur_diff < best_diff) {
+			best_diff = cur_diff;
+			best_rate = cur_rate;
+		}
+		if (!best_diff || cur_rate < rate)
+			break;
+	}
+	return best_rate;
+}
+
+static int clk_sam9x5_peripheral_set_rate(struct clk_hw *hw,
+					  unsigned long rate,
+					  unsigned long parent_rate)
+{
+	int shift;
+	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
+	if (periph->id < 2 || !periph->have_div_support) {
+		if (parent_rate == rate)
+			return 0;
+		else
+			return -EINVAL;
+	}
+
+	for (shift = 0; shift < 4; shift++) {
+		if (parent_rate >> shift == rate) {
+			periph->div = shift;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static const struct clk_ops sam9x5_peripheral_ops = {
+	.enable = clk_sam9x5_peripheral_enable,
+	.disable = clk_sam9x5_peripheral_disable,
+	.is_enabled = clk_sam9x5_peripheral_is_enabled,
+	.recalc_rate = clk_sam9x5_peripheral_recalc_rate,
+	.round_rate = clk_sam9x5_peripheral_round_rate,
+	.set_rate = clk_sam9x5_peripheral_set_rate,
+};
+
+struct clk * __init
+at91_clk_register_sam9x5_peripheral(const char *name,
+				    const char *parent_name,
+				    u32 id, u32 default_div)
+{
+	struct clk_sam9x5_peripheral *periph;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	periph = kzalloc(sizeof(*periph), GFP_KERNEL);
+	if (!periph)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &sam9x5_peripheral_ops;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+	init.flags = CLK_SET_RATE_GATE;
+
+	periph->id = id;
+	periph->hw.init = &init;
+	periph->div = default_div;
+
+	clk = clk_register(NULL, &periph->hw);
+
+	if (IS_ERR(clk))
+		kfree(periph);
+
+	return clk;
+}
+
+#if defined(CONFIG_OF)
+struct clk_periph_data {
+	struct clk **clks;
+	u8 *ids;
+	unsigned int clk_num;
+};
+
+static struct clk * __init
+of_clk_src_periph_get(struct of_phandle_args *clkspec, void *data)
+{
+	struct clk_periph_data *clk_data = data;
+	unsigned int id = clkspec->args[0];
+	int i;
+
+	if (id >= PERIPHERAL_MAX)
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
+of_at91_clk_periph_setup(struct device_node *np, u8 type)
+{
+	int num;
+	int i;
+	u32 id;
+	struct clk *clk;
+	const char *parent_name;
+	const char *name;
+	u32 divisor;
+	struct clk **clks;
+	u8 *ids;
+	struct clk_periph_data *clktab;
+	struct device_node *periphclknp;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+	if (!parent_name)
+		return;
+
+	num = of_get_child_count(np);
+	if (!num || num > PERIPHERAL_MAX)
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
+	for_each_child_of_node(np, periphclknp) {
+		name = periphclknp->name;
+
+		if (of_property_read_u32(periphclknp, "id", &id))
+			goto out_free_clks;
+		if (id >= PERIPHERAL_MAX)
+			goto out_free_clks;
+
+		if (type == PERIPHERAL_AT91RM9200) {
+			clk = at91_clk_register_peripheral(name,
+							   parent_name, id);
+		} else {
+			if (of_property_read_u32(periphclknp,
+						 "default-divisor",
+						 &divisor))
+				divisor = 0;
+
+			clk = at91_clk_register_sam9x5_peripheral(name,
+								  parent_name,
+								  id,
+								  divisor);
+		}
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
+static void __init of_at91rm9200_clk_periph_setup(struct device_node *np)
+{
+	of_at91_clk_periph_setup(np, PERIPHERAL_AT91RM9200);
+}
+CLK_OF_DECLARE(at91rm9200_clk_periph, "atmel,at91rm9200-clk-peripheral",
+	       of_at91rm9200_clk_periph_setup);
+
+static void __init of_at91sam9x5_clk_periph_setup(struct device_node *np)
+{
+	of_at91_clk_periph_setup(np, PERIPHERAL_AT91SAM9X5);
+}
+CLK_OF_DECLARE(at91sam9x5_clk_periph, "atmel,at91sam9x5-clk-peripheral",
+	       of_at91sam9x5_clk_periph_setup);
+#endif
diff --git a/include/linux/clk/at91.h b/include/linux/clk/at91.h
index 518a568..112a060 100644
--- a/include/linux/clk/at91.h
+++ b/include/linux/clk/at91.h
@@ -262,4 +262,12 @@ at91_clk_register_master(const char *name, int num_parents,
 struct clk * __init
 at91_clk_register_system(const char *name, u8 id);
 
+struct clk * __init
+at91_clk_register_peripheral(const char *name, const char *parent_name,
+			     u32 id);
+
+struct clk * __init
+at91_clk_register_sam9x5_peripheral(const char *name, const char *parent_name,
+				    u32 id, u32 default_div);
+
 #endif
-- 
1.7.9.5

