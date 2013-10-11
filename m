Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab3JKJxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:53:07 -0400
Received: from 9.mo1.mail-out.ovh.net ([178.32.108.172]:42670 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757707Ab3JKJxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:53:04 -0400
X-Greylist: delayed 3732 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Oct 2013 05:53:03 EDT
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
Subject: [PATCH v4 08/17] clk: at91: add PMC system clocks
Date: Fri, 11 Oct 2013 11:41:41 +0200
Message-Id: <1381484501-13420-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com>
References: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 14412081758448744672
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

This patch adds new at91 system clock implementation using common clk
framework.

Some peripherals need to enable a "system" clock in order to work properly.
Each system clock is given an id based on the bit position in SCER/SCDR
registers.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/Makefile     |    1 +
 drivers/clk/at91/clk-system.c |  193 +++++++++++++++++++++++++++++++++++++++++
 drivers/clk/at91/pmc.c        |    5 ++
 drivers/clk/at91/pmc.h        |    3 +
 4 files changed, 202 insertions(+)
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
index 0000000..603b4b1
--- /dev/null
+++ b/drivers/clk/at91/clk-system.c
@@ -0,0 +1,193 @@
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
+#define SYSTEM_MAX_ID		31
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
+at91_clk_register_system(struct at91_pmc *pmc, const char *name,
+			 const char *parent_name, u8 id)
+{
+	struct clk_system *sys;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	if (!parent_name || id > SYSTEM_MAX_ID)
+		return ERR_PTR(-EINVAL);
+
+	sys = kzalloc(sizeof(*sys), GFP_KERNEL);
+	if (!sys)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &system_ops;
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+	/*
+	 * CLK_IGNORE_UNUSED is used to avoid ddrck switch off.
+	 * TODO : we should implement a driver supporting at91 ddr controller
+	 * (see drivers/memory) which would request and enable the ddrck clock.
+	 * When this is done we will be able to remove CLK_IGNORE_UNUSED flag.
+	 */
+	init.flags = CLK_IGNORE_UNUSED;
+
+	sys->id = id;
+	sys->hw.init = &init;
+	sys->pmc = pmc;
+
+	clk = clk_register(NULL, &sys->hw);
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
+	if (id > SYSTEM_MAX_ID)
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
+	const char *parent_name;
+
+	num = of_get_child_count(np);
+	if (num > (SYSTEM_MAX_ID + 1))
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
+
+		parent_name = of_clk_get_parent_name(sysclknp, 0);
+
+		clk = at91_clk_register_system(pmc, name, parent_name, id);
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
index 6f08879..ce76ba6 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -243,6 +243,11 @@ static const struct of_device_id pmc_clk_ids[] __initdata = {
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

