Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3GQNxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:53:40 -0400
Received: from 1.mo1.mail-out.ovh.net ([178.32.127.22]:44838 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754372Ab3GQNxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:53:39 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 10/42] ARM: at91: add PMC smd clock
Date: Wed, 17 Jul 2013 15:53:31 +0200
Message-Id: <1374069211-14142-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 11656160261087656044
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

This is the at91 smd (Soft Modem) clock implementation using common clk
framework.

Not used by any driver right now.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/Kconfig |    5 ++
 drivers/clk/at91/Makefile  |    1 +
 drivers/clk/at91/clk-smd.c |  157 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 163 insertions(+)
 create mode 100644 drivers/clk/at91/clk-smd.c

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index ac18755..c8e02ca 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -27,6 +27,9 @@ config AT91_SAM9G45_RESET
 config AT91_SAM9_TIME
 	bool
 
+config HAVE_AT91_SMD
+	bool
+
 config SOC_AT91SAM9
 	bool
 	select AT91_SAM9_TIME
@@ -72,6 +75,7 @@ config SOC_SAMA5D3
 	select HAVE_FB_ATMEL
 	select HAVE_AT91_DBGU1
 	select HAVE_AT91_UTMI
+	select HAVE_AT91_SMD
 	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's SAMA5D3 family SoC.
@@ -137,6 +141,7 @@ config SOC_AT91SAM9X5
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
 	select HAVE_AT91_UTMI
+	select HAVE_AT91_SMD
 	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9x5 family SoC.
diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index bbfd245..7206f4c 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -8,3 +8,4 @@ obj-y += clk-system.o clk-peripheral.o
 obj-$(CONFIG_AT91_PROGRAMMABLE_CLOCKS)	+= clk-programmable.o
 obj-$(CONFIG_HAVE_AT91_UTMI)		+= clk-utmi.o
 obj-$(CONFIG_HAVE_AT91_USB_CLK)		+= clk-usb.o
+obj-$(CONFIG_HAVE_AT91_SMD)		+= clk-smd.o
diff --git a/drivers/clk/at91/clk-smd.c b/drivers/clk/at91/clk-smd.c
new file mode 100644
index 0000000..61bd8a5
--- /dev/null
+++ b/drivers/clk/at91/clk-smd.c
@@ -0,0 +1,157 @@
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
+#include <linux/clk/at91.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+
+#define SMD_SOURCE_MAX		2
+
+#define to_at91sam9x5_clk_smd(hw) \
+	container_of(hw, struct at91sam9x5_clk_smd, hw)
+struct at91sam9x5_clk_smd {
+	struct clk_hw hw;
+};
+
+static unsigned long at91sam9x5_clk_smd_recalc_rate(struct clk_hw *hw,
+						    unsigned long parent_rate)
+{
+	u32 tmp;
+	u8 smddiv;
+	tmp = at91_pmc_read(AT91_PMC_SMD);
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
+	if (index > 1)
+		return -EINVAL;
+	tmp = at91_pmc_read(AT91_PMC_SMD) & ~AT91_PMC_SMDS;
+	if (index)
+		tmp |= AT91_PMC_SMDS;
+	at91_pmc_write(AT91_PMC_SMD, tmp);
+	return 0;
+}
+
+static u8 at91sam9x5_clk_smd_get_parent(struct clk_hw *hw)
+{
+	return at91_pmc_read(AT91_PMC_SMD) & AT91_PMC_SMDS;
+}
+
+static int at91sam9x5_clk_smd_set_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long parent_rate)
+{
+	u32 tmp;
+	unsigned long div = parent_rate / rate;
+	if (parent_rate % rate || div < 1 || div > 16)
+		return -EINVAL;
+	tmp = at91_pmc_read(AT91_PMC_SMD) & ~AT91_PMC_SMD_DIV;
+	tmp |= (div - 1) << 8;
+	at91_pmc_write(AT91_PMC_SMD, tmp);
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
+struct clk * __init
+at91sam9x5_clk_register_smd(const char *name, const char **parent_names,
+			    u8 num_parents)
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
+
+	clk = clk_register(NULL, &smd->hw);
+
+	if (IS_ERR(clk))
+		kfree(smd);
+
+	return clk;
+}
+
+#if defined(CONFIG_OF)
+static void __init of_at91sam9x5_clk_smd_setup(struct device_node *np)
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
+	clk = at91sam9x5_clk_register_smd(name, parent_names, num_parents);
+
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+CLK_OF_DECLARE(at91sam9x5_clk_smd, "atmel,at91sam9x5-clk-smd",
+	       of_at91sam9x5_clk_smd_setup);
+#endif
-- 
1.7.9.5

