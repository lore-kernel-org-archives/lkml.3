Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3GQNkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:40:17 -0400
Received: from mo1.mail-out.ovh.net ([178.32.228.1]:41590 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3GQNkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:40:15 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 02/42] ARM: at91: add PMC main clock
Date: Wed, 17 Jul 2013 15:40:04 +0200
Message-Id: <1374068404-13654-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 11429854380717013100
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

This is the at91 main oscillator clock implementation using common
clk framework.

If rate is not provided during clock registraction it is computed using
the slow clock (main clk parent in this case) rate and the MCFR register.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/Makefile   |    5 ++
 drivers/clk/at91/clk-main.c |  106 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk/at91.h    |   10 ++++
 3 files changed, 121 insertions(+)
 create mode 100644 drivers/clk/at91/Makefile
 create mode 100644 drivers/clk/at91/clk-main.c

diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
new file mode 100644
index 0000000..42c084e
--- /dev/null
+++ b/drivers/clk/at91/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for at91 specific clk
+#
+
+obj-y += clk-main.o
diff --git a/drivers/clk/at91/clk-main.c b/drivers/clk/at91/clk-main.c
new file mode 100644
index 0000000..738fa39
--- /dev/null
+++ b/drivers/clk/at91/clk-main.c
@@ -0,0 +1,106 @@
+/*
+ * drivers/clk/at91/clk-main.c
+ *
+ *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * This mainram is free software; you can redistribute it and/or modify
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
+#define to_clk_main(hw) container_of(hw, struct clk_main, hw)
+struct clk_main {
+	struct clk_hw hw;
+	unsigned long rate;
+};
+
+static unsigned long clk_main_recalc_rate(struct clk_hw *hw,
+					  unsigned long parent_rate)
+{
+	u32 tmp;
+	struct clk_main *clkmain = to_clk_main(hw);
+	if (clkmain->rate)
+		return clkmain->rate;
+	while ((tmp = at91_pmc_read(AT91_CKGR_MCFR)) & AT91_PMC_MAINRDY)
+		;
+	tmp &= AT91_PMC_MAINF;
+	clkmain->rate = (tmp * parent_rate) / 16;
+	return clkmain->rate;
+}
+
+static const struct clk_ops main_ops = {
+	.recalc_rate = clk_main_recalc_rate,
+};
+
+struct clk * __init
+at91_clk_register_main(const char *name,
+		       const char *parent_name,
+		       unsigned long rate)
+{
+	struct clk_main *clkmain;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	if (!rate && !parent_name)
+		return ERR_PTR(-EINVAL);
+
+	clkmain = kzalloc(sizeof(*clkmain), GFP_KERNEL);
+	if (!clkmain)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &main_ops;
+	init.parent_names = parent_name ? &parent_name : NULL;
+	init.num_parents = parent_name ? 1 : 0;
+	init.flags = parent_name ? 0 : CLK_IS_ROOT;
+
+	clkmain->hw.init = &init;
+	clkmain->rate = rate;
+
+	clk = clk_register(NULL, &clkmain->hw);
+
+	if (IS_ERR(clk))
+		kfree(clkmain);
+
+	return clk;
+}
+
+
+
+#if defined(CONFIG_OF)
+static void __init
+of_at91_clk_main_setup(struct device_node *np)
+{
+	struct clk *clk;
+	const char *parent_name;
+	const char *name = np->name;
+	u32 rate = 0;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+	of_property_read_string(np, "clock-output-names", &name);
+	of_property_read_u32(np, "clock-frequency", &rate);
+
+	clk = at91_clk_register_main(name, parent_name, rate);
+
+	if (!IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+
+static void __init of_at91rm9200_clk_main_setup(struct device_node *np)
+{
+	of_at91_clk_main_setup(np);
+}
+CLK_OF_DECLARE(at91rm9200_clk_main, "atmel,at91rm9200-clk-main",
+	       of_at91rm9200_clk_main_setup);
+#endif
diff --git a/include/linux/clk/at91.h b/include/linux/clk/at91.h
index 0ce9586..8e83942 100644
--- a/include/linux/clk/at91.h
+++ b/include/linux/clk/at91.h
@@ -16,6 +16,8 @@
 #ifndef AT91_PMC_H
 #define AT91_PMC_H
 
+#include <linux/clk-provider.h>
+
 #ifndef __ASSEMBLY__
 extern void __iomem *at91_pmc_base;
 
@@ -187,4 +189,12 @@ extern void __iomem *at91_pmc_base;
 #define			AT91_PMC_PCR_DIV8	0x3			/* Peripheral clock is MCK/8 */
 #define		AT91_PMC_PCR_EN		(0x1  <<  28)		/* Enable */
 
+
+
+
+struct clk * __init
+at91_clk_register_main(const char *name,
+		       const char *parent_name,
+		       unsigned long rate);
+
 #endif
-- 
1.7.9.5

