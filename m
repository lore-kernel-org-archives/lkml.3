Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3HHGNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 02:13:52 -0400
Received: from 12.mo4.mail-out.ovh.net ([178.33.104.253]:41273 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755504Ab3HHGNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 02:13:50 -0400
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
Subject: [PATCH v3 09/19] clk: at91: add PMC system clocks
Date: Thu,  8 Aug 2013 08:12:26 +0200
Message-Id: <1375942346-8966-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 4008485143960320048
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

This patch adds new at91 system clock implementation using common clk
framework.

Some peripherals need to enable a "system" clock in order to work properly.
Each system clock is given an id based on the bit position in SCER/SCDR
registers.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/Makefile     |    1 +
 drivers/clk/at91/clk-system.c |  191 +++++++++++++++++++++++++++++++++++++++++
 drivers/clk/at91/pmc.c        |    5 ++
 drivers/clk/at91/pmc.h        |    3 +
 4 files changed, 200 insertions(+)
 create mode 100644 drivers/clk/at91/clk-system.c

diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index e28fb2b..c2b7068 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -4,3 +4,4 @@
 
 obj-y += pmc.o
 obj-y += clk-main.o clk-pll.o clk-plldiv.o clk-master.o
+obj-y += clk-system.o
diff --git a/drivers/clk/at91/clk-system.c b/drivers/clk/at91/clk-system.c
new file mode 100644
index 0000000..11a3eb8
--- /dev/null
+++ b/drivers/clk/at91/clk-system.c
@@ -0,0 +1,191 @@
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
+#include <linux/clk/at91_pmc.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+
+#include "pmc.h"
+
+#define SYSTEM_MAX		32
+
+#define to_clk_system(hw) container_of(hw, struct clk_system, hw)
+struct clk_system {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+	u8 id;
+};
+
+static int clk_system_enable(struct clk_hw *hw)
+{
+	struct clk_system *sys = to_clk_system(hw);
+	struct at91_pmc *pmc = sys->pmc;
+
+	pmc_write(pmc, AT91_PMC_SCER, 1 << sys->id);
+	return 0;
+}
+
+static void clk_system_disable(struct clk_hw *hw)
+{
+	struct clk_system *sys = to_clk_system(hw);
+	struct at91_pmc *pmc = sys->pmc;
+
+	pmc_write(pmc, AT91_PMC_SCDR, 1 << sys->id);
+}
+
+static int clk_system_is_enabled(struct clk_hw *hw)
+{
+	struct clk_system *sys = to_clk_system(hw);
+	struct at91_pmc *pmc = sys->pmc;
+
+	return !!(pmc_read(pmc, AT91_PMC_SCSR) & (1 << sys->id));
+}
+
+static const struct clk_ops system_ops = {
+	.enable = clk_system_enable,
+	.disable = clk_system_disable,
+	.is_enabled = clk_system_is_enabled,
+};
+
+static struct clk * __init
+at91_clk_register_system(struct at91_pmc *pmc, const char *name, u8 id)
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
+	init.parent_names = NULL;
+	init.num_parents = 0;
+	/*
+	 * CLK_IGNORE_UNUSED is used to avoid ddrck switch off.
+	 * TODO : we should implement a driver supporting at91 ddr controller
+	 * (see drivers/memory) which would request and enable the ddrck clock.
+	 * When this is done we will be able to remove CLK_IGNORE_UNUSED flag.
+	 */
+	init.flags = CLK_IS_ROOT | CLK_IGNORE_UNUSED;
+
+	sys->id = id;
+	sys->hw.init = &init;
+	sys->pmc = pmc;
+
+	clk = clk_register(NULL, &sys->hw);
+
+	if (IS_ERR(clk))
+		kfree(sys);
+
+	return clk;
+}
+
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
+of_at91_clk_sys_setup(struct device_node *np, struct at91_pmc *pmc)
+{
+	int i;
+	int num;
+	u32 id;
+	struct clk *clk;
+	u8 *ids;
+	struct clk **clks;
+	struct clk_system_data *clktab;
+	const char *name;
+	struct device_node *sysclknp;
+
+	num = of_get_child_count(np);
+	if (num > SYSTEM_MAX)
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
+	for_each_child_of_node(np, sysclknp) {
+		name = sysclknp->name;
+
+		if (of_property_read_u32(sysclknp, "atmel,clk-id", &id))
+			goto out_free_clks;
+		if (id >= SYSTEM_MAX)
+			goto out_free_clks;
+
+		clk = at91_clk_register_system(pmc, name, id);
+		if (IS_ERR(clk))
+			goto out_free_clks;
+
+		clks[i] = clk;
+		ids[i] = id;
+
+		i++;
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
+void __init of_at91rm9200_clk_sys_setup(struct device_node *np,
+					struct at91_pmc *pmc)
+{
+	of_at91_clk_sys_setup(np, pmc);
+}
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 5258f1d..c674ef2 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -251,6 +251,11 @@ static const struct of_device_id pmc_clk_ids[] __initdata = {
 		.compatible = "atmel,at91sam9x5-clk-master",
 		.data = of_at91sam9x5_clk_master_setup,
 	},
+	/* System clocks */
+	{
+		.compatible = "atmel,at91rm9200-clk-system",
+		.data = of_at91rm9200_clk_sys_setup,
+	},
 	{ /*sentinel*/ }
 };
 
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 2e1dcb8..f88ef41 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -74,4 +74,7 @@ extern void __init of_at91rm9200_clk_master_setup(struct device_node *np,
 extern void __init of_at91sam9x5_clk_master_setup(struct device_node *np,
 						  struct at91_pmc *pmc);
 
+extern void __init of_at91rm9200_clk_sys_setup(struct device_node *np,
+					       struct at91_pmc *pmc);
+
 #endif /* __PMC_H_ */
-- 
1.7.9.5

