Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab3K1MzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:55:21 -0500
Received: from 14.mo6.mail-out.ovh.net ([46.105.56.113]:59794 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756092Ab3K1MzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:55:18 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH v6 09/16] clk: at91: add PMC peripheral clocks
Date: Thu, 28 Nov 2013 13:46:02 +0100
Message-Id: <1385642762-6977-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
References: <1385642184-6467-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 4258434923296094316
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

This patch adds new at91 peripheral clock implementation using common clk
framework.

Almost all peripherals provided by at91 SoCs need a clock to work properly.
This clock is enabled/disabled using PCER/PCDR resgisters.

Each peripheral is given an id (see atmel's datasheets) which is used to
define and reference peripheral clocks.

Some new SoCs (at91sam9x5 and sama5d3) provide a new register (PCR) where you
can configure the peripheral clock as a division of the master clock.
This will help reducing the peripherals power comsumption.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/clk/at91/Makefile         |    2 +-
 drivers/clk/at91/clk-peripheral.c |  410 +++++++++++++++++++++++++++++++++++++
 drivers/clk/at91/pmc.c            |    9 +
 drivers/clk/at91/pmc.h            |    5 +
 4 files changed, 425 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/at91/clk-peripheral.c

diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index c2b7068..04deba3 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -4,4 +4,4 @@
 
 obj-y += pmc.o
 obj-y += clk-main.o clk-pll.o clk-plldiv.o clk-master.o
-obj-y += clk-system.o
+obj-y += clk-system.o clk-peripheral.o
diff --git a/drivers/clk/at91/clk-peripheral.c b/drivers/clk/at91/clk-peripheral.c
new file mode 100644
index 0000000..597fed4
--- /dev/null
+++ b/drivers/clk/at91/clk-peripheral.c
@@ -0,0 +1,410 @@
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
+#include <linux/io.h>
+
+#include "pmc.h"
+
+#define PERIPHERAL_MAX		64
+
+#define PERIPHERAL_AT91RM9200	0
+#define PERIPHERAL_AT91SAM9X5	1
+
+#define PERIPHERAL_ID_MIN	2
+#define PERIPHERAL_ID_MAX	31
+#define PERIPHERAL_MASK(id)	(1 << ((id) & PERIPHERAL_ID_MAX))
+
+#define PERIPHERAL_RSHIFT_MASK	0x3
+#define PERIPHERAL_RSHIFT(val)	(((val) >> 16) & PERIPHERAL_RSHIFT_MASK)
+
+#define PERIPHERAL_MAX_SHIFT	4
+
+struct clk_peripheral {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+	u32 id;
+};
+
+#define to_clk_peripheral(hw) container_of(hw, struct clk_peripheral, hw)
+
+struct clk_sam9x5_peripheral {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+	struct clk_range range;
+	u32 id;
+	u32 div;
+	bool auto_div;
+};
+
+#define to_clk_sam9x5_peripheral(hw) \
+	container_of(hw, struct clk_sam9x5_peripheral, hw)
+
+static int clk_peripheral_enable(struct clk_hw *hw)
+{
+	struct clk_peripheral *periph = to_clk_peripheral(hw);
+	struct at91_pmc *pmc = periph->pmc;
+	int offset = AT91_PMC_PCER;
+	u32 id = periph->id;
+
+	if (id < PERIPHERAL_ID_MIN)
+		return 0;
+	if (id > PERIPHERAL_ID_MAX)
+		offset = AT91_PMC_PCER1;
+	pmc_write(pmc, offset, PERIPHERAL_MASK(id));
+	return 0;
+}
+
+static void clk_peripheral_disable(struct clk_hw *hw)
+{
+	struct clk_peripheral *periph = to_clk_peripheral(hw);
+	struct at91_pmc *pmc = periph->pmc;
+	int offset = AT91_PMC_PCDR;
+	u32 id = periph->id;
+
+	if (id < PERIPHERAL_ID_MIN)
+		return;
+	if (id > PERIPHERAL_ID_MAX)
+		offset = AT91_PMC_PCDR1;
+	pmc_write(pmc, offset, PERIPHERAL_MASK(id));
+}
+
+static int clk_peripheral_is_enabled(struct clk_hw *hw)
+{
+	struct clk_peripheral *periph = to_clk_peripheral(hw);
+	struct at91_pmc *pmc = periph->pmc;
+	int offset = AT91_PMC_PCSR;
+	u32 id = periph->id;
+
+	if (id < PERIPHERAL_ID_MIN)
+		return 1;
+	if (id > PERIPHERAL_ID_MAX)
+		offset = AT91_PMC_PCSR1;
+	return !!(pmc_read(pmc, offset) & PERIPHERAL_MASK(id));
+}
+
+static const struct clk_ops peripheral_ops = {
+	.enable = clk_peripheral_enable,
+	.disable = clk_peripheral_disable,
+	.is_enabled = clk_peripheral_is_enabled,
+};
+
+static struct clk * __init
+at91_clk_register_peripheral(struct at91_pmc *pmc, const char *name,
+			     const char *parent_name, u32 id)
+{
+	struct clk_peripheral *periph;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	if (!pmc || !name || !parent_name || id > PERIPHERAL_ID_MAX)
+		return ERR_PTR(-EINVAL);
+
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
+	periph->pmc = pmc;
+
+	clk = clk_register(NULL, &periph->hw);
+	if (IS_ERR(clk))
+		kfree(periph);
+
+	return clk;
+}
+
+static void clk_sam9x5_peripheral_autodiv(struct clk_sam9x5_peripheral *periph)
+{
+	struct clk *parent;
+	unsigned long parent_rate;
+	int shift = 0;
+
+	if (!periph->auto_div)
+		return;
+
+	if (periph->range.max) {
+		parent = clk_get_parent_by_index(periph->hw.clk, 0);
+		parent_rate = __clk_get_rate(parent);
+		if (!parent_rate)
+			return;
+
+		for (; shift < PERIPHERAL_MAX_SHIFT; shift++) {
+			if (parent_rate >> shift <= periph->range.max)
+				break;
+		}
+	}
+
+	periph->auto_div = false;
+	periph->div = shift;
+}
+
+static int clk_sam9x5_peripheral_enable(struct clk_hw *hw)
+{
+	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
+	struct at91_pmc *pmc = periph->pmc;
+
+	if (periph->id < PERIPHERAL_ID_MIN)
+		return 0;
+
+	pmc_write(pmc, AT91_PMC_PCR, (periph->id & AT91_PMC_PCR_PID) |
+				     AT91_PMC_PCR_CMD |
+				     AT91_PMC_PCR_DIV(periph->div) |
+				     AT91_PMC_PCR_EN);
+	return 0;
+}
+
+static void clk_sam9x5_peripheral_disable(struct clk_hw *hw)
+{
+	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
+	struct at91_pmc *pmc = periph->pmc;
+
+	if (periph->id < PERIPHERAL_ID_MIN)
+		return;
+
+	pmc_write(pmc, AT91_PMC_PCR, (periph->id & AT91_PMC_PCR_PID) |
+				     AT91_PMC_PCR_CMD);
+}
+
+static int clk_sam9x5_peripheral_is_enabled(struct clk_hw *hw)
+{
+	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
+	struct at91_pmc *pmc = periph->pmc;
+	int ret;
+
+	if (periph->id < PERIPHERAL_ID_MIN)
+		return 1;
+
+	pmc_lock(pmc);
+	pmc_write(pmc, AT91_PMC_PCR, (periph->id & AT91_PMC_PCR_PID));
+	ret = !!(pmc_read(pmc, AT91_PMC_PCR) & AT91_PMC_PCR_EN);
+	pmc_unlock(pmc);
+
+	return ret;
+}
+
+static unsigned long
+clk_sam9x5_peripheral_recalc_rate(struct clk_hw *hw,
+				  unsigned long parent_rate)
+{
+	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
+	struct at91_pmc *pmc = periph->pmc;
+	u32 tmp;
+
+	if (periph->id < PERIPHERAL_ID_MIN)
+		return parent_rate;
+
+	pmc_lock(pmc);
+	pmc_write(pmc, AT91_PMC_PCR, (periph->id & AT91_PMC_PCR_PID));
+	tmp = pmc_read(pmc, AT91_PMC_PCR);
+	pmc_unlock(pmc);
+
+	if (tmp & AT91_PMC_PCR_EN) {
+		periph->div = PERIPHERAL_RSHIFT(tmp);
+		periph->auto_div = false;
+	} else {
+		clk_sam9x5_peripheral_autodiv(periph);
+	}
+
+	return parent_rate >> periph->div;
+}
+
+static long clk_sam9x5_peripheral_round_rate(struct clk_hw *hw,
+					     unsigned long rate,
+					     unsigned long *parent_rate)
+{
+	int shift = 0;
+	unsigned long best_rate;
+	unsigned long best_diff;
+	unsigned long cur_rate = *parent_rate;
+	unsigned long cur_diff;
+	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
+
+	if (periph->id < PERIPHERAL_ID_MIN || !periph->range.max)
+		return *parent_rate;
+
+	if (periph->range.max) {
+		for (; shift < PERIPHERAL_MAX_SHIFT; shift++) {
+			cur_rate = *parent_rate >> shift;
+			if (cur_rate <= periph->range.max)
+				break;
+		}
+	}
+
+	if (rate >= cur_rate)
+		return cur_rate;
+
+	best_diff = cur_rate - rate;
+	best_rate = cur_rate;
+	for (; shift < PERIPHERAL_MAX_SHIFT; shift++) {
+		cur_rate = *parent_rate >> shift;
+		if (cur_rate < rate)
+			cur_diff = rate - cur_rate;
+		else
+			cur_diff = cur_rate - rate;
+
+		if (cur_diff < best_diff) {
+			best_diff = cur_diff;
+			best_rate = cur_rate;
+		}
+
+		if (!best_diff || cur_rate < rate)
+			break;
+	}
+
+	return best_rate;
+}
+
+static int clk_sam9x5_peripheral_set_rate(struct clk_hw *hw,
+					  unsigned long rate,
+					  unsigned long parent_rate)
+{
+	int shift;
+	struct clk_sam9x5_peripheral *periph = to_clk_sam9x5_peripheral(hw);
+	if (periph->id < PERIPHERAL_ID_MIN || !periph->range.max) {
+		if (parent_rate == rate)
+			return 0;
+		else
+			return -EINVAL;
+	}
+
+	if (periph->range.max && rate > periph->range.max)
+		return -EINVAL;
+
+	for (shift = 0; shift < PERIPHERAL_MAX_SHIFT; shift++) {
+		if (parent_rate >> shift == rate) {
+			periph->auto_div = false;
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
+static struct clk * __init
+at91_clk_register_sam9x5_peripheral(struct at91_pmc *pmc, const char *name,
+				    const char *parent_name, u32 id,
+				    const struct clk_range *range)
+{
+	struct clk_sam9x5_peripheral *periph;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	if (!pmc || !name || !parent_name)
+		return ERR_PTR(-EINVAL);
+
+	periph = kzalloc(sizeof(*periph), GFP_KERNEL);
+	if (!periph)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &sam9x5_peripheral_ops;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+	init.flags = 0;
+
+	periph->id = id;
+	periph->hw.init = &init;
+	periph->div = 0;
+	periph->pmc = pmc;
+	periph->auto_div = true;
+	periph->range = *range;
+
+	clk = clk_register(NULL, &periph->hw);
+	if (IS_ERR(clk))
+		kfree(periph);
+	else
+		clk_sam9x5_peripheral_autodiv(periph);
+
+	return clk;
+}
+
+static void __init
+of_at91_clk_periph_setup(struct device_node *np, struct at91_pmc *pmc, u8 type)
+{
+	int num;
+	u32 id;
+	struct clk *clk;
+	const char *parent_name;
+	const char *name;
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
+	for_each_child_of_node(np, periphclknp) {
+		if (of_property_read_u32(periphclknp, "reg", &id))
+			continue;
+
+		if (id >= PERIPHERAL_MAX)
+			continue;
+
+		if (of_property_read_string(np, "clock-output-names", &name))
+			name = periphclknp->name;
+
+		if (type == PERIPHERAL_AT91RM9200) {
+			clk = at91_clk_register_peripheral(pmc, name,
+							   parent_name, id);
+		} else {
+			struct clk_range range = CLK_RANGE(0, 0);
+
+			of_at91_get_clk_range(periphclknp,
+					      "atmel,clk-output-range",
+					      &range);
+
+			clk = at91_clk_register_sam9x5_peripheral(pmc, name,
+								  parent_name,
+								  id, &range);
+		}
+
+		if (IS_ERR(clk))
+			continue;
+
+		of_clk_add_provider(periphclknp, of_clk_src_simple_get, clk);
+	}
+}
+
+void __init of_at91rm9200_clk_periph_setup(struct device_node *np,
+					   struct at91_pmc *pmc)
+{
+	of_at91_clk_periph_setup(np, pmc, PERIPHERAL_AT91RM9200);
+}
+
+void __init of_at91sam9x5_clk_periph_setup(struct device_node *np,
+					   struct at91_pmc *pmc)
+{
+	of_at91_clk_periph_setup(np, pmc, PERIPHERAL_AT91SAM9X5);
+}
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index a97554f..afdfeb2 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -269,6 +269,15 @@ static const struct of_device_id pmc_clk_ids[] __initdata = {
 		.compatible = "atmel,at91rm9200-clk-system",
 		.data = of_at91rm9200_clk_sys_setup,
 	},
+	/* Peripheral clocks */
+	{
+		.compatible = "atmel,at91rm9200-clk-peripheral",
+		.data = of_at91rm9200_clk_periph_setup,
+	},
+	{
+		.compatible = "atmel,at91sam9x5-clk-peripheral",
+		.data = of_at91sam9x5_clk_periph_setup,
+	},
 	{ /*sentinel*/ }
 };
 
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 9c8a397..a09212b 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -80,4 +80,9 @@ extern void __init of_at91sam9x5_clk_master_setup(struct device_node *np,
 extern void __init of_at91rm9200_clk_sys_setup(struct device_node *np,
 					       struct at91_pmc *pmc);
 
+extern void __init of_at91rm9200_clk_periph_setup(struct device_node *np,
+						  struct at91_pmc *pmc);
+extern void __init of_at91sam9x5_clk_periph_setup(struct device_node *np,
+						  struct at91_pmc *pmc);
+
 #endif /* __PMC_H_ */
-- 
1.7.9.5

