Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876Ab3HHH0C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 03:26:02 -0400
Received: from 5.mo4.mail-out.ovh.net ([188.165.44.50]:59945 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933637Ab3HHH0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 03:26:00 -0400
X-Greylist: delayed 7800 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2013 03:26:00 EDT
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
Subject: [PATCH v3 16/19] clk: at91: add PMC smd clock
Date: Thu,  8 Aug 2013 09:17:23 +0200
Message-Id: <1375946243-9736-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 5105674603293079600
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

This patch adds at91 smd (Soft Modem) clock implementation using common clk
framework.

Not used by any driver right now.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/Kconfig |    5 ++
 drivers/clk/at91/Makefile  |    1 +
 drivers/clk/at91/clk-smd.c |  171 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/at91/pmc.c     |    7 ++
 drivers/clk/at91/pmc.h     |    5 ++
 5 files changed, 189 insertions(+)
 create mode 100644 drivers/clk/at91/clk-smd.c

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index b76dc4c..97033f7 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -39,6 +39,9 @@ config AT91_SAM9G45_RESET
 config AT91_SAM9_TIME
 	bool
 
+config HAVE_AT91_SMD
+	bool
+
 config SOC_AT91SAM9
 	bool
 	select AT91_SAM9_TIME
@@ -85,6 +88,7 @@ config SOC_SAMA5D3
 	select HAVE_AT91_DBGU1
 	select AT91_USE_OLD_CLK
 	select HAVE_AT91_UTMI
+	select HAVE_AT91_SMD
 	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's SAMA5D3 family SoC.
@@ -157,6 +161,7 @@ config SOC_AT91SAM9X5
 	select SOC_AT91SAM9
 	select AT91_USE_OLD_CLK
 	select HAVE_AT91_UTMI
+	select HAVE_AT91_SMD
 	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9x5 family SoC.
diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 61db058..0e92b71 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -9,3 +9,4 @@ obj-y += clk-system.o clk-peripheral.o
 obj-$(CONFIG_AT91_PROGRAMMABLE_CLOCKS)	+= clk-programmable.o
 obj-$(CONFIG_HAVE_AT91_UTMI)		+= clk-utmi.o
 obj-$(CONFIG_HAVE_AT91_USB_CLK)		+= clk-usb.o
+obj-$(CONFIG_HAVE_AT91_SMD)		+= clk-smd.o
diff --git a/drivers/clk/at91/clk-smd.c b/drivers/clk/at91/clk-smd.c
new file mode 100644
index 0000000..a7cf14a
--- /dev/null
+++ b/drivers/clk/at91/clk-smd.c
@@ -0,0 +1,171 @@
+/*
+ * drivers/clk/at91/clk-smd.c
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
+#define SMD_SOURCE_MAX		2
+
+#define to_at91sam9x5_clk_smd(hw) \
+	container_of(hw, struct at91sam9x5_clk_smd, hw)
+struct at91sam9x5_clk_smd {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+};
+
+static unsigned long at91sam9x5_clk_smd_recalc_rate(struct clk_hw *hw,
+						    unsigned long parent_rate)
+{
+	u32 tmp;
+	u8 smddiv;
+	struct at91sam9x5_clk_smd *smd = to_at91sam9x5_clk_smd(hw);
+	struct at91_pmc *pmc = smd->pmc;
+
+	tmp = pmc_read(pmc, AT91_PMC_SMD);
+	smddiv = (tmp & AT91_PMC_SMD_DIV) >> 8;
+	return parent_rate / (smddiv + 1);
+}
+
+static long at91sam9x5_clk_smd_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *parent_rate)
+{
+	unsigned long div;
+	unsigned long bestrate;
+	unsigned long tmp;
+
+	if (rate >= *parent_rate)
+		return *parent_rate;
+
+	div = *parent_rate / rate;
+	if (div > 15)
+		return *parent_rate / 16;
+
+	bestrate = *parent_rate / div;
+	tmp = *parent_rate / (div + 1);
+	if (bestrate - rate > rate - tmp)
+		bestrate = tmp;
+
+	return bestrate;
+}
+
+static int at91sam9x5_clk_smd_set_parent(struct clk_hw *hw, u8 index)
+{
+	u32 tmp;
+	struct at91sam9x5_clk_smd *smd = to_at91sam9x5_clk_smd(hw);
+	struct at91_pmc *pmc = smd->pmc;
+
+	if (index > 1)
+		return -EINVAL;
+	tmp = pmc_read(pmc, AT91_PMC_SMD) & ~AT91_PMC_SMDS;
+	if (index)
+		tmp |= AT91_PMC_SMDS;
+	pmc_write(pmc, AT91_PMC_SMD, tmp);
+	return 0;
+}
+
+static u8 at91sam9x5_clk_smd_get_parent(struct clk_hw *hw)
+{
+	struct at91sam9x5_clk_smd *smd = to_at91sam9x5_clk_smd(hw);
+	struct at91_pmc *pmc = smd->pmc;
+
+	return pmc_read(pmc, AT91_PMC_SMD) & AT91_PMC_SMDS;
+}
+
+static int at91sam9x5_clk_smd_set_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long parent_rate)
+{
+	u32 tmp;
+	struct at91sam9x5_clk_smd *smd = to_at91sam9x5_clk_smd(hw);
+	struct at91_pmc *pmc = smd->pmc;
+	unsigned long div = parent_rate / rate;
+
+	if (parent_rate % rate || div < 1 || div > 16)
+		return -EINVAL;
+	tmp = pmc_read(pmc, AT91_PMC_SMD) & ~AT91_PMC_SMD_DIV;
+	tmp |= (div - 1) << 8;
+	pmc_write(pmc, AT91_PMC_SMD, tmp);
+
+	return 0;
+}
+
+static const struct clk_ops at91sam9x5_smd_ops = {
+	.recalc_rate = at91sam9x5_clk_smd_recalc_rate,
+	.round_rate = at91sam9x5_clk_smd_round_rate,
+	.get_parent = at91sam9x5_clk_smd_get_parent,
+	.set_parent = at91sam9x5_clk_smd_set_parent,
+	.set_rate = at91sam9x5_clk_smd_set_rate,
+};
+
+static struct clk * __init
+at91sam9x5_clk_register_smd(struct at91_pmc *pmc, const char *name,
+			    const char **parent_names, u8 num_parents)
+{
+	struct at91sam9x5_clk_smd *smd;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	smd = kzalloc(sizeof(*smd), GFP_KERNEL);
+	if (!smd)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &at91sam9x5_smd_ops;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+	init.flags = CLK_SET_RATE_GATE | CLK_SET_PARENT_GATE;
+
+	smd->hw.init = &init;
+	smd->pmc = pmc;
+
+	clk = clk_register(NULL, &smd->hw);
+
+	if (IS_ERR(clk))
+		kfree(smd);
+
+	return clk;
+}
+
+void __init of_at91sam9x5_clk_smd_setup(struct device_node *np,
+					struct at91_pmc *pmc)
+{
+	struct clk *clk;
+	int i;
+	int num_parents;
+	const char *parent_names[SMD_SOURCE_MAX];
+	const char *name = np->name;
+
+	num_parents = of_count_phandle_with_args(np, "clocks", "#clock-cells");
+	if (num_parents <= 0 || num_parents >= SMD_SOURCE_MAX)
+		return;
+
+	for (i = 0; i < num_parents; i++) {
+		parent_names[i] = of_clk_get_parent_name(np, i);
+		if (!parent_names[i])
+			return;
+	}
+
+	of_property_read_string(np, "clock-output-names", &name);
+
+	clk = at91sam9x5_clk_register_smd(pmc, name, parent_names,
+					  num_parents);
+
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index e46de3d..0a731c8 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -298,6 +298,13 @@ static const struct of_device_id pmc_clk_ids[] __initdata = {
 		.data = of_at91sam9x5_clk_usb_setup,
 	},
 #endif
+	/* SMD clock */
+#if defined(CONFIG_HAVE_AT91_SMD)
+	{
+		.compatible = "atmel,at91sam9x5-clk-smd",
+		.data = of_at91sam9x5_clk_smd_setup,
+	},
+#endif
 	{ /*sentinel*/ }
 };
 
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index b2efff5..43f2516 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -103,4 +103,9 @@ extern void __init of_at91sam9x5_clk_usb_setup(struct device_node *np,
 					       struct at91_pmc *pmc);
 #endif
 
+#if defined(CONFIG_HAVE_AT91_SMD)
+extern void __init of_at91sam9x5_clk_smd_setup(struct device_node *np,
+					       struct at91_pmc *pmc);
+#endif
+
 #endif /* __PMC_H_ */
-- 
1.7.9.5

