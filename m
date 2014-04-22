Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbaDVNQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:16:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48452 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755864AbaDVNMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:12:49 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 03/11] clk: at91: add slow clks driver
Date: Tue, 22 Apr 2014 15:12:32 +0200
Message-Id: <1398172360-7837-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AT91 slow clk is a clk multiplexer.

In some SoCs (sam9x5, sama5, sam9g45 families) this multiplexer can
choose among 2 sources: an internal RC oscillator circuit and an oscillator
using an external crystal.

In other Socs (sam9260 family) the multiplexer source is hardcoded with
the OSCSEL signal.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/clk/at91/Makefile    |   4 +-
 drivers/clk/at91/clk-slow.c  | 467 +++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/at91/pmc.c       |   5 +
 drivers/clk/at91/pmc.h       |   3 +
 drivers/clk/at91/sckc.c      |  57 ++++++
 drivers/clk/at91/sckc.h      |  22 ++
 include/linux/clk/at91_pmc.h |   1 +
 7 files changed, 557 insertions(+), 2 deletions(-)
 create mode 100644 drivers/clk/at91/clk-slow.c
 create mode 100644 drivers/clk/at91/sckc.c
 create mode 100644 drivers/clk/at91/sckc.h

diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
index 46c1d3d..4998aee 100644
--- a/drivers/clk/at91/Makefile
+++ b/drivers/clk/at91/Makefile
@@ -2,8 +2,8 @@
 # Makefile for at91 specific clk
 #
 
-obj-y += pmc.o
-obj-y += clk-main.o clk-pll.o clk-plldiv.o clk-master.o
+obj-y += pmc.o sckc.o
+obj-y += clk-slow.o clk-main.o clk-pll.o clk-plldiv.o clk-master.o
 obj-y += clk-system.o clk-peripheral.o clk-programmable.o
 
 obj-$(CONFIG_HAVE_AT91_UTMI)		+= clk-utmi.o
diff --git a/drivers/clk/at91/clk-slow.c b/drivers/clk/at91/clk-slow.c
new file mode 100644
index 0000000..fc2d54c
--- /dev/null
+++ b/drivers/clk/at91/clk-slow.c
@@ -0,0 +1,467 @@
+/*
+ * drivers/clk/at91/clk-slow.c
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
+#include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+
+#include "pmc.h"
+#include "sckc.h"
+
+#define SLOW_CLOCK_FREQ		32768
+#define SLOWCK_SW_CYCLES	5
+#define SLOWCK_SW_TIME_USEC	((SLOWCK_SW_CYCLES * USEC_PER_SEC) / \
+				 SLOW_CLOCK_FREQ)
+
+#define	AT91_SCKC_CR			0x00
+#define		AT91_SCKC_RCEN		(1 << 0)
+#define		AT91_SCKC_OSC32EN	(1 << 1)
+#define		AT91_SCKC_OSC32BYP	(1 << 2)
+#define		AT91_SCKC_OSCSEL	(1 << 3)
+
+struct clk_slow_osc {
+	struct clk_hw hw;
+	void __iomem *sckcr;
+	unsigned long startup_usec;
+};
+
+#define to_clk_slow_osc(hw) container_of(hw, struct clk_slow_osc, hw)
+
+struct clk_slow_rc_osc {
+	struct clk_hw hw;
+	void __iomem *sckcr;
+	unsigned long frequency;
+	unsigned long accuracy;
+	unsigned long startup_usec;
+};
+
+#define to_clk_slow_rc_osc(hw) container_of(hw, struct clk_slow_rc_osc, hw)
+
+struct clk_sam9260_slow {
+	struct clk_hw hw;
+	struct at91_pmc *pmc;
+};
+
+#define to_clk_sam9260_slow(hw) container_of(hw, struct clk_sam9260_slow, hw)
+
+struct clk_sam9x5_slow {
+	struct clk_hw hw;
+	void __iomem *sckcr;
+	u8 parent;
+};
+
+#define to_clk_sam9x5_slow(hw) container_of(hw, struct clk_sam9x5_slow, hw)
+
+
+static int clk_slow_osc_prepare(struct clk_hw *hw)
+{
+	struct clk_slow_osc *osc = to_clk_slow_osc(hw);
+	void __iomem *sckcr = osc->sckcr;
+	u32 tmp = readl(sckcr);
+
+	if (tmp & AT91_SCKC_OSC32BYP)
+		return 0;
+
+	writel(tmp | AT91_SCKC_OSC32EN, sckcr);
+
+	usleep_range(osc->startup_usec, osc->startup_usec + 1);
+
+	return 0;
+}
+
+static void clk_slow_osc_unprepare(struct clk_hw *hw)
+{
+	struct clk_slow_osc *osc = to_clk_slow_osc(hw);
+	void __iomem *sckcr = osc->sckcr;
+	u32 tmp = readl(sckcr);
+
+	if (tmp & AT91_SCKC_OSC32BYP)
+		return;
+
+	writel(tmp & ~AT91_SCKC_OSC32EN, sckcr);
+}
+
+static int clk_slow_osc_is_prepared(struct clk_hw *hw)
+{
+	struct clk_slow_osc *osc = to_clk_slow_osc(hw);
+	void __iomem *sckcr = osc->sckcr;
+	u32 tmp = readl(sckcr);
+
+	if (tmp & AT91_SCKC_OSC32BYP)
+		return 1;
+
+	return !!(tmp & AT91_SCKC_OSC32EN);
+}
+
+static const struct clk_ops slow_osc_ops = {
+	.prepare = clk_slow_osc_prepare,
+	.unprepare = clk_slow_osc_unprepare,
+	.is_prepared = clk_slow_osc_is_prepared,
+};
+
+static struct clk * __init
+at91_clk_register_slow_osc(void __iomem *sckcr,
+			   const char *name,
+			   const char *parent_name,
+			   unsigned long startup,
+			   bool bypass)
+{
+	struct clk_slow_osc *osc;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	if (!sckcr || !name || !parent_name)
+		return ERR_PTR(-EINVAL);
+
+	osc = kzalloc(sizeof(*osc), GFP_KERNEL);
+	if (!osc)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &slow_osc_ops;
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+	init.flags = 0;
+
+	osc->hw.init = &init;
+	osc->sckcr = sckcr;
+	osc->startup_usec = startup;
+
+	if (bypass)
+		writel((readl(sckcr) & ~AT91_SCKC_OSC32EN) | AT91_SCKC_OSC32BYP,
+		       sckcr);
+
+	clk = clk_register(NULL, &osc->hw);
+	if (IS_ERR(clk))
+		kfree(osc);
+
+	return clk;
+}
+
+void __init of_at91sam9x5_clk_slow_osc_setup(struct device_node *np,
+					     void __iomem *sckcr)
+{
+	struct clk *clk;
+	const char *parent_name;
+	const char *name = np->name;
+	u32 startup;
+	bool bypass;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+	of_property_read_string(np, "clock-output-names", &name);
+	of_property_read_u32(np, "atmel,startup-time-usec", &startup);
+	bypass = of_property_read_bool(np, "atmel,osc-bypass");
+
+	clk = at91_clk_register_slow_osc(sckcr, name, parent_name, startup,
+					 bypass);
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+
+static unsigned long clk_slow_rc_osc_recalc_rate(struct clk_hw *hw,
+						 unsigned long parent_rate)
+{
+	struct clk_slow_rc_osc *osc = to_clk_slow_rc_osc(hw);
+
+	return osc->frequency;
+}
+
+static unsigned long clk_slow_rc_osc_recalc_accuracy(struct clk_hw *hw,
+						     unsigned long parent_acc)
+{
+	struct clk_slow_rc_osc *osc = to_clk_slow_rc_osc(hw);
+
+	return osc->accuracy;
+}
+
+static int clk_slow_rc_osc_prepare(struct clk_hw *hw)
+{
+	struct clk_slow_rc_osc *osc = to_clk_slow_rc_osc(hw);
+	void __iomem *sckcr = osc->sckcr;
+
+	writel(readl(sckcr) | AT91_SCKC_RCEN, sckcr);
+
+	usleep_range(osc->startup_usec, osc->startup_usec + 1);
+
+	return 0;
+}
+
+static void clk_slow_rc_osc_unprepare(struct clk_hw *hw)
+{
+	struct clk_slow_rc_osc *osc = to_clk_slow_rc_osc(hw);
+	void __iomem *sckcr = osc->sckcr;
+
+	writel(readl(sckcr) & ~AT91_SCKC_RCEN, sckcr);
+}
+
+static int clk_slow_rc_osc_is_prepared(struct clk_hw *hw)
+{
+	struct clk_slow_rc_osc *osc = to_clk_slow_rc_osc(hw);
+
+	return !!(readl(osc->sckcr) & AT91_SCKC_RCEN);
+}
+
+static const struct clk_ops slow_rc_osc_ops = {
+	.prepare = clk_slow_rc_osc_prepare,
+	.unprepare = clk_slow_rc_osc_unprepare,
+	.is_prepared = clk_slow_rc_osc_is_prepared,
+	.recalc_rate = clk_slow_rc_osc_recalc_rate,
+	.recalc_accuracy = clk_slow_rc_osc_recalc_accuracy,
+};
+
+static struct clk * __init
+at91_clk_register_slow_rc_osc(void __iomem *sckcr,
+			      const char *name,
+			      unsigned long frequency,
+			      unsigned long accuracy,
+			      unsigned long startup)
+{
+	struct clk_slow_rc_osc *osc;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	if (!sckcr || !name)
+		return ERR_PTR(-EINVAL);
+
+	osc = kzalloc(sizeof(*osc), GFP_KERNEL);
+	if (!osc)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &slow_rc_osc_ops;
+	init.parent_names = NULL;
+	init.num_parents = 0;
+	init.flags = CLK_IS_ROOT;
+
+	osc->hw.init = &init;
+	osc->sckcr = sckcr;
+	osc->frequency = frequency;
+	osc->accuracy = accuracy;
+	osc->startup_usec = startup;
+
+	clk = clk_register(NULL, &osc->hw);
+	if (IS_ERR(clk))
+		kfree(osc);
+
+	return clk;
+}
+
+void __init of_at91sam9x5_clk_slow_rc_osc_setup(struct device_node *np,
+						void __iomem *sckcr)
+{
+	struct clk *clk;
+	u32 frequency = 0;
+	u32 accuracy = 0;
+	u32 startup = 0;
+	const char *name = np->name;
+
+	of_property_read_string(np, "clock-output-names", &name);
+	of_property_read_u32(np, "clock-frequency", &frequency);
+	of_property_read_u32(np, "clock-accuracy", &accuracy);
+	of_property_read_u32(np, "atmel,startup-time-usec", &startup);
+
+	clk = at91_clk_register_slow_rc_osc(sckcr, name, frequency, accuracy,
+					    startup);
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+
+static int clk_sam9x5_slow_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_sam9x5_slow *slowck = to_clk_sam9x5_slow(hw);
+	void __iomem *sckcr = slowck->sckcr;
+	u32 tmp;
+
+	if (index > 1)
+		return -EINVAL;
+
+	tmp = readl(sckcr);
+
+	if ((!index && !(tmp & AT91_SCKC_OSCSEL)) ||
+	    (index && (tmp & AT91_SCKC_OSCSEL)))
+		return 0;
+
+	if (index)
+		tmp |= AT91_SCKC_OSCSEL;
+	else
+		tmp &= ~AT91_SCKC_OSCSEL;
+
+	writel(tmp, sckcr);
+
+	usleep_range(SLOWCK_SW_TIME_USEC, SLOWCK_SW_TIME_USEC + 1);
+
+	return 0;
+}
+
+static u8 clk_sam9x5_slow_get_parent(struct clk_hw *hw)
+{
+	struct clk_sam9x5_slow *slowck = to_clk_sam9x5_slow(hw);
+
+	return !!(readl(slowck->sckcr) & AT91_SCKC_OSCSEL);
+}
+
+static const struct clk_ops sam9x5_slow_ops = {
+	.set_parent = clk_sam9x5_slow_set_parent,
+	.get_parent = clk_sam9x5_slow_get_parent,
+};
+
+static struct clk * __init
+at91_clk_register_sam9x5_slow(void __iomem *sckcr,
+			      const char *name,
+			      const char **parent_names,
+			      int num_parents)
+{
+	struct clk_sam9x5_slow *slowck;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	if (!sckcr || !name || !parent_names || !num_parents)
+		return ERR_PTR(-EINVAL);
+
+	slowck = kzalloc(sizeof(*slowck), GFP_KERNEL);
+	if (!slowck)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &sam9x5_slow_ops;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+	init.flags = 0;
+
+	slowck->hw.init = &init;
+	slowck->sckcr = sckcr;
+	slowck->parent = !!(readl(sckcr) & AT91_SCKC_OSCSEL);
+
+	clk = clk_register(NULL, &slowck->hw);
+	if (IS_ERR(clk))
+		kfree(slowck);
+
+	return clk;
+}
+
+void __init of_at91sam9x5_clk_slow_setup(struct device_node *np,
+					 void __iomem *sckcr)
+{
+	struct clk *clk;
+	const char *parent_names[2];
+	int num_parents;
+	const char *name = np->name;
+	int i;
+
+	num_parents = of_count_phandle_with_args(np, "clocks", "#clock-cells");
+	if (num_parents <= 0 || num_parents > 2)
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
+	clk = at91_clk_register_sam9x5_slow(sckcr, name, parent_names,
+					    num_parents);
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+
+static u8 clk_sam9260_slow_get_parent(struct clk_hw *hw)
+{
+	struct clk_sam9260_slow *slowck = to_clk_sam9260_slow(hw);
+
+	return !!(pmc_read(slowck->pmc, AT91_PMC_SR) & AT91_PMC_OSCSEL);
+}
+
+static const struct clk_ops sam9260_slow_ops = {
+	.get_parent = clk_sam9260_slow_get_parent,
+};
+
+static struct clk * __init
+at91_clk_register_sam9260_slow(struct at91_pmc *pmc,
+			       const char *name,
+			       const char **parent_names,
+			       int num_parents)
+{
+	struct clk_sam9260_slow *slowck;
+	struct clk *clk = NULL;
+	struct clk_init_data init;
+
+	if (!pmc || !name)
+		return ERR_PTR(-EINVAL);
+
+	if (!parent_names || !num_parents)
+		return ERR_PTR(-EINVAL);
+
+	slowck = kzalloc(sizeof(*slowck), GFP_KERNEL);
+	if (!slowck)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &sam9260_slow_ops;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+	init.flags = 0;
+
+	slowck->hw.init = &init;
+	slowck->pmc = pmc;
+
+	clk = clk_register(NULL, &slowck->hw);
+	if (IS_ERR(clk))
+		kfree(slowck);
+
+	return clk;
+}
+
+void __init of_at91sam9260_clk_slow_setup(struct device_node *np,
+					  struct at91_pmc *pmc)
+{
+	struct clk *clk;
+	const char *parent_names[2];
+	int num_parents;
+	const char *name = np->name;
+	int i;
+
+	num_parents = of_count_phandle_with_args(np, "clocks", "#clock-cells");
+	if (num_parents <= 0 || num_parents > 1)
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
+	clk = at91_clk_register_sam9260_slow(pmc, name, parent_names,
+					     num_parents);
+	if (IS_ERR(clk))
+		return;
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index dc5fdde..524196b 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -229,6 +229,11 @@ out_free_pmc:
 }
 
 static const struct of_device_id pmc_clk_ids[] __initconst = {
+	/* Slow oscillator */
+	{
+		.compatible = "atmel,at91sam9260-clk-slow",
+		.data = of_at91sam9260_clk_slow_setup,
+	},
 	/* Main clock */
 	{
 		.compatible = "atmel,at91rm9200-clk-main-osc",
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 42cc7cc..6c76259 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -58,6 +58,9 @@ static inline void pmc_write(struct at91_pmc *pmc, int offset, u32 value)
 int of_at91_get_clk_range(struct device_node *np, const char *propname,
 			  struct clk_range *range);
 
+extern void __init of_at91sam9260_clk_slow_setup(struct device_node *np,
+						 struct at91_pmc *pmc);
+
 extern void __init of_at91rm9200_clk_main_osc_setup(struct device_node *np,
 						    struct at91_pmc *pmc);
 extern void __init of_at91sam9x5_clk_main_rc_osc_setup(struct device_node *np,
diff --git a/drivers/clk/at91/sckc.c b/drivers/clk/at91/sckc.c
new file mode 100644
index 0000000..1184d76
--- /dev/null
+++ b/drivers/clk/at91/sckc.c
@@ -0,0 +1,57 @@
+/*
+ * drivers/clk/at91/sckc.c
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
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+
+#include "sckc.h"
+
+static const struct of_device_id sckc_clk_ids[] __initconst = {
+	/* Slow clock */
+	{
+		.compatible = "atmel,at91sam9x5-clk-slow-osc",
+		.data = of_at91sam9x5_clk_slow_osc_setup,
+	},
+	{
+		.compatible = "atmel,at91sam9x5-clk-slow-rc-osc",
+		.data = of_at91sam9x5_clk_slow_rc_osc_setup,
+	},
+	{
+		.compatible = "atmel,at91sam9x5-clk-slow",
+		.data = of_at91sam9x5_clk_slow_setup,
+	},
+	{ /*sentinel*/ }
+};
+
+static void __init of_at91sam9x5_sckc_setup(struct device_node *np)
+{
+	struct device_node *childnp;
+	void (*clk_setup)(struct device_node *, void __iomem *);
+	const struct of_device_id *clk_id;
+	void __iomem *regbase = of_iomap(np, 0);
+
+	if (!regbase)
+		return;
+
+	for_each_child_of_node(np, childnp) {
+		clk_id = of_match_node(sckc_clk_ids, childnp);
+		if (!clk_id)
+			continue;
+		clk_setup = clk_id->data;
+		clk_setup(childnp, regbase);
+	}
+}
+CLK_OF_DECLARE(at91sam9x5_clk_sckc, "atmel,at91sam9x5-sckc",
+	       of_at91sam9x5_sckc_setup);
diff --git a/drivers/clk/at91/sckc.h b/drivers/clk/at91/sckc.h
new file mode 100644
index 0000000..836fcf5
--- /dev/null
+++ b/drivers/clk/at91/sckc.h
@@ -0,0 +1,22 @@
+/*
+ * drivers/clk/at91/sckc.h
+ *
+ *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __AT91_SCKC_H_
+#define __AT91_SCKC_H_
+
+extern void __init of_at91sam9x5_clk_slow_osc_setup(struct device_node *np,
+						    void __iomem *sckcr);
+extern void __init of_at91sam9x5_clk_slow_rc_osc_setup(struct device_node *np,
+						       void __iomem *sckcr);
+extern void __init of_at91sam9x5_clk_slow_setup(struct device_node *np,
+						void __iomem *sckcr);
+
+#endif /* __AT91_SCKC_H_ */
diff --git a/include/linux/clk/at91_pmc.h b/include/linux/clk/at91_pmc.h
index a6911eb..de4268d 100644
--- a/include/linux/clk/at91_pmc.h
+++ b/include/linux/clk/at91_pmc.h
@@ -155,6 +155,7 @@ extern void __iomem *at91_pmc_base;
 #define		AT91_PMC_LOCKB		(1 <<  2)		/* PLLB Lock */
 #define		AT91_PMC_MCKRDY		(1 <<  3)		/* Master Clock */
 #define		AT91_PMC_LOCKU		(1 <<  6)		/* UPLL Lock [some SAM9] */
+#define		AT91_PMC_OSCSEL		(1 <<  7)		/* Slow Oscillator Selection [some SAM9] */
 #define		AT91_PMC_PCK0RDY	(1 <<  8)		/* Programmable Clock 0 */
 #define		AT91_PMC_PCK1RDY	(1 <<  9)		/* Programmable Clock 1 */
 #define		AT91_PMC_PCK2RDY	(1 << 10)		/* Programmable Clock 2 */
-- 
1.8.3.2

