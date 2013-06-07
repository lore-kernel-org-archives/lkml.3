Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3FGOhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:37:50 -0400
Received: from 15.mo1.mail-out.ovh.net ([188.165.38.232]:37646 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752432Ab3FGOht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:37:49 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        devicetree-discuss@lists.ozlabs.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC PATCH 05/50] ARM: at91: add PMC system clocks
Date: Fri,  7 Jun 2013 16:24:13 +0200
Message-Id: <1370615115-16979-6-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 17278341447218345132
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the at91 system clock implementation using common clk framework.

Some peripheral needs to enable a "system" clock in order to work properly.
Each system clock is given an id which is the bit offset used in SCER/SCDR
registers.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/Makefile     |    1 +
 drivers/clk/at91/clk-system.c |  189 +++++++++++++++++++++++++++++++++++++++++
 include/linux/clk/at91.h      |    3 +
 3 files changed, 193 insertions(+)

diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index d41f616..13e5714 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-y += clk-main.o clk-pll.o clk-plldiv.o clk-master.o
+obj-y += clk-system.o
diff --git a/drivers/clk/at91/clk-system.c b/drivers/clk/at91/clk-system.c
new file mode 100644
index 0000000..21af468
--- /dev/null
+++ b/drivers/clk/at91/clk-system.c
@@ -0,0 +1,189 @@
+/*
+ * drivers/clk/at91/clk-system.c
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
+#define SYSTEM_MAX		32
+
+#define to_clk_system(hw) container_of(hw, struct clk_system, hw)
+struct clk_system {
+	struct clk_hw hw;
+	u8 id;
+};
+
+static int clk_system_enable(struct clk_hw *hw)
+{
+	struct clk_system *sys = to_clk_system(hw);
+	at91_pmc_write(AT91_PMC_SCER, sys->id);
+	return 0;
+}
+
+static void clk_system_disable(struct clk_hw *hw)
+{
+	struct clk_system *sys = to_clk_system(hw);
+	at91_pmc_write(AT91_PMC_SCDR, 1 << sys->id);
+}
+
+static int clk_system_is_enabled(struct clk_hw *hw)
+{
+	struct clk_system *sys = to_clk_system(hw);
+	return !!(at91_pmc_read(AT91_PMC_SCSR) & (sys->id));
+}
+
+static const struct clk_ops system_ops = {
+	.enable = clk_system_enable,
+	.disable = clk_system_disable,
+	.is_enabled = clk_system_is_enabled,
+};
+
+struct clk * __init
+at91_clk_register_system(const char *name, const char *parent_name, u8 id)
+{
+	struct clk_system *sys;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	id &= 31;
+
+	sys = kzalloc(sizeof(*sys), GFP_KERNEL);
+	if (!sys)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &system_ops;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+	init.flags = 0;
+
+	sys->id = id;
+	sys->hw.init = &init;
+
+	clk = clk_register(NULL, &sys->hw);
+
+	if (IS_ERR(clk))
+		kfree(sys);
+
+	return clk;
+}
+
+#if defined(CONFIG_OF)
+struct clk_system_data {
+	struct clk **clks;
+	u8 *ids;
+	unsigned int clk_num;
+};
+
+static struct clk * __init
+of_clk_src_system_get(struct of_phandle_args *clkspec, void *data)
+{
+	struct clk_system_data *clk_data = data;
+	unsigned int id = clkspec->args[0];
+	int i;
+
+	if (id >= SYSTEM_MAX)
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
+of_at91_clk_sys_setup(struct device_node *np)
+{
+	int i;
+	int num;
+	u32 id;
+	struct clk *clk;
+	u8 *ids;
+	struct clk **clks;
+	struct clk_system_data *clktab;
+	const char *parent_name;
+	const char *name = np->name;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+	if (!parent_name)
+		return;
+
+	if (!of_get_property(np, "ids", &num))
+		return;
+	num /= 4;
+	if (num > SYSTEM_MAX)
+		return;
+
+	if (of_count_phandle_with_args(np, "clocks", "#clock-cells") != num)
+		return;
+
+	if (of_property_count_strings(np, "clock-output-names") != num)
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
+	for (i = 0; i < num; i++) {
+		of_property_read_u32_index(np, "ids", i, &id);
+		if (id >= SYSTEM_MAX)
+			goto out_free_clks;
+		of_property_read_string_index(np, "clock-output-names",
+					      i, &name);
+		parent_name = of_clk_get_parent_name(np, i);
+		if (!parent_name)
+			goto out_free_clks;
+
+		clk = at91_clk_register_system(name, parent_name, id);
+		if (IS_ERR(clk))
+			goto out_free_clks;
+
+		clks[i] = clk;
+		ids[i] = id;
+	}
+
+	clktab->clk_num = num;
+	clktab->clks = clks;
+	clktab->ids = ids;
+	of_clk_add_provider(np, of_clk_src_system_get, clktab);
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
+static void __init of_at91rm9200_clk_sys_setup(struct device_node *np)
+{
+	of_at91_clk_sys_setup(np);
+}
+CLK_OF_DECLARE(at91rm9200_clk_sys, "atmel,at91rm9200-clk-system",
+	       of_at91rm9200_clk_sys_setup);
+#endif
diff --git a/include/linux/clk/at91.h b/include/linux/clk/at91.h
index a960e2f..c886226 100644
--- a/include/linux/clk/at91.h
+++ b/include/linux/clk/at91.h
@@ -256,4 +256,7 @@ at91_clk_register_master(const char *name, int num_parents,
 			 struct clk_master_characteristics *characteristics);
 
 
+struct clk * __init
+at91_clk_register_system(const char *name, const char *parent_name, u8 id);
+
 #endif
-- 
1.7.9.5

