Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3GQNu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:50:58 -0400
Received: from 2.mo1.mail-out.ovh.net ([178.32.119.250]:38999 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755402Ab3GQNu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:50:57 -0400
X-Greylist: delayed 80914 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2013 09:50:56 EDT
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
Subject: [PATCH v2 08/42] ARM: at91: add PMC utmi clock
Date: Wed, 17 Jul 2013 15:50:50 +0200
Message-Id: <1374069050-14060-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 11610842791350204524
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

This is the at91 utmi clock implementation using common clk framework.

This clock is a pll with a fixed factor (x40).
It is used as a source for usb clock.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/Kconfig  |    7 +++
 drivers/clk/at91/Makefile   |    1 +
 drivers/clk/at91/clk-utmi.c |  114 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk/at91.h    |    4 ++
 4 files changed, 126 insertions(+)
 create mode 100644 drivers/clk/at91/clk-utmi.c

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 699b71e..1a24a1f 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -1,5 +1,8 @@
 if ARCH_AT91
 
+config HAVE_AT91_UTMI
+	bool
+
 config HAVE_AT91_DBGU0
 	bool
 
@@ -65,6 +68,7 @@ config SOC_SAMA5D3
 	select SOC_SAMA5
 	select HAVE_FB_ATMEL
 	select HAVE_AT91_DBGU1
+	select HAVE_AT91_UTMI
 	help
 	  Select this if you are using one of Atmel's SAMA5D3 family SoC.
 	  This support covers SAMA5D31, SAMA5D33, SAMA5D34, SAMA5D35.
@@ -106,12 +110,14 @@ config SOC_AT91SAM9RL
 	select HAVE_AT91_DBGU0
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
+	select HAVE_AT91_UTMI
 
 config SOC_AT91SAM9G45
 	bool "AT91SAM9G45 or AT91SAM9M10 families"
 	select HAVE_AT91_DBGU1
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
+	select HAVE_AT91_UTMI
 	help
 	  Select this if you are using one of Atmel's AT91SAM9G45 family SoC.
 	  This support covers AT91SAM9G45, AT91SAM9G46, AT91SAM9M10 and AT91SAM9M11.
@@ -121,6 +127,7 @@ config SOC_AT91SAM9X5
 	select HAVE_AT91_DBGU0
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
+	select HAVE_AT91_UTMI
 	help
 	  Select this if you are using one of Atmel's AT91SAM9x5 family SoC.
 	  This means that your SAM9 name finishes with a '5' (except if it is
diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 2d7c119..76d09f0 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -6,3 +6,4 @@ obj-y += clk-main.o clk-pll.o clk-plldiv.o clk-master.o
 obj-y += clk-system.o clk-peripheral.o
 
 obj-$(CONFIG_AT91_PROGRAMMABLE_CLOCKS)	+= clk-programmable.o
+obj-$(CONFIG_HAVE_AT91_UTMI)		+= clk-utmi.o
diff --git a/drivers/clk/at91/clk-utmi.c b/drivers/clk/at91/clk-utmi.c
new file mode 100644
index 0000000..c0dd596
--- /dev/null
+++ b/drivers/clk/at91/clk-utmi.c
@@ -0,0 +1,114 @@
+/*
+ * drivers/clk/at91/clk-utmi.c
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
+#define to_clk_utmi(hw) container_of(hw, struct clk_utmi, hw)
+
+struct clk_utmi {
+	struct clk_hw hw;
+};
+
+static int clk_utmi_prepare(struct clk_hw *hw)
+{
+	u32 tmp = at91_pmc_read(AT91_CKGR_UCKR) | AT91_PMC_UPLLEN |
+		  AT91_PMC_UPLLCOUNT;
+	at91_pmc_write(AT91_CKGR_UCKR, tmp);
+	while (!(at91_pmc_read(AT91_PMC_SR) & AT91_PMC_LOCKU))
+		;
+	return 0;
+}
+
+static int clk_utmi_is_prepared(struct clk_hw *hw)
+{
+	return !!(at91_pmc_read(AT91_PMC_SR) & AT91_PMC_LOCKU);
+}
+
+static void clk_utmi_disable(struct clk_hw *hw)
+{
+	u32 tmp = at91_pmc_read(AT91_CKGR_UCKR) & ~AT91_PMC_UPLLEN;
+	at91_pmc_write(AT91_CKGR_UCKR, tmp);
+}
+
+static unsigned long clk_utmi_recalc_rate(struct clk_hw *hw,
+					  unsigned long parent_rate)
+{
+	return parent_rate * 40;
+}
+
+static const struct clk_ops utmi_ops = {
+	.prepare = clk_utmi_prepare,
+	.is_prepared = clk_utmi_is_prepared,
+	.disable = clk_utmi_disable,
+	.recalc_rate = clk_utmi_recalc_rate,
+};
+
+struct clk * __init
+at91_clk_register_utmi(const char *name, const char *parent_name)
+{
+	struct clk_utmi *utmi;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	utmi = kzalloc(sizeof(*utmi), GFP_KERNEL);
+	if (!utmi)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &utmi_ops;
+	init.parent_names = parent_name ? &parent_name : NULL;
+	init.num_parents = parent_name ? 1 : 0;
+	init.flags = CLK_SET_RATE_GATE;
+
+	utmi->hw.init = &init;
+
+	clk = clk_register(NULL, &utmi->hw);
+
+	if (IS_ERR(clk))
+		kfree(utmi);
+
+	return clk;
+}
+
+#if defined(CONFIG_OF)
+static void __init
+of_at91_clk_utmi_setup(struct device_node *np)
+{
+	struct clk *clk;
+	const char *parent_name;
+	const char *name = np->name;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+
+	of_property_read_string(np, "clock-output-names", &name);
+
+	clk = at91_clk_register_utmi(name, parent_name);
+
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	return;
+}
+
+static void __init of_at91sam9x5_clk_utmi_setup(struct device_node *np)
+{
+	of_at91_clk_utmi_setup(np);
+}
+CLK_OF_DECLARE(at91sam9x5_clk_utmi, "atmel,at91sam9x5-clk-utmi",
+	       of_at91sam9x5_clk_utmi_setup);
+#endif
diff --git a/include/linux/clk/at91.h b/include/linux/clk/at91.h
index 3cafd36..47ef7e8 100644
--- a/include/linux/clk/at91.h
+++ b/include/linux/clk/at91.h
@@ -288,4 +288,8 @@ at91_clk_register_programmable(const char *name, const char **parent_names,
 			       u8 num_parents, u8 id,
 			       struct clk_programmable_layout *layout);
 
+
+struct clk * __init
+at91_clk_register_utmi(const char *name, const char *parent_name);
+
 #endif
-- 
1.7.9.5

