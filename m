Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaLPW70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:59:26 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:35137 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaLPW7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:59:22 -0500
MBOX-Line: From paul@pwsan.com Tue Dec 16 12:38:29 2014
Subject: [PATCH 4/4] clk: tegra: Add support for the Tegra132 CAR IP block
To: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
From: Paul Walmsley <paul@pwsan.com>
Cc: Alexandre Courbot <gnurou@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Bill Huang <bilhuang@nvidia.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Allen Martin <amartin@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 16 Dec 2014 12:38:29 -0800
Message-ID: <20141216203829.22980.64446.stgit@chromeos-P9X79>
In-Reply-To: <20141216203813.22980.2301.stgit@chromeos-P9X79>
References: <20141216203813.22980.2301.stgit@chromeos-P9X79>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Walmsley <pwalmsley@nvidia.com>

Tegra132 CAR supports almost the same clocks as Tegra124 CAR. This
patch mostly deals with the small differences.

Since Tegra132 contains many of the same PLL clock sources used on
Tegra114 and Tegra124, enable them in drivers/clk/tegra/clk-pll.c when
the kernel is configured to include Tegra132 support.

This patch is based on several patches from others:

1. a  patch from Peter De Schrijver:

http://lkml.iu.edu/hypermail/linux/kernel/1407.1/06094.html

2. a patch from Bill Huang ("clk: tegra: enable cclk_g at boot on
Tegra132"), and

3. a patch from Allen Martin ("clk: Enable tegra clock driver for
tegra132").

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Allen Martin <amartin@nvidia.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Bill Huang <bilhuang@nvidia.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/tegra/Makefile       |    1 
 drivers/clk/tegra/clk-pll.c      |   10 ++-
 drivers/clk/tegra/clk-tegra124.c |  130 +++++++++++++++++++++++++++++++++++---
 3 files changed, 129 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
index f7dfb72..edb8358 100644
--- a/drivers/clk/tegra/Makefile
+++ b/drivers/clk/tegra/Makefile
@@ -15,3 +15,4 @@ obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= clk-tegra114.o
 obj-$(CONFIG_ARCH_TEGRA_124_SOC)	+= clk-tegra124.o
+obj-$(CONFIG_ARCH_TEGRA_132_SOC)	+= clk-tegra124.o
diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index c7c6d8f..a04e584 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -816,7 +816,9 @@ const struct clk_ops tegra_clk_plle_ops = {
 	.enable = clk_plle_enable,
 };
 
-#if defined(CONFIG_ARCH_TEGRA_114_SOC) || defined(CONFIG_ARCH_TEGRA_124_SOC)
+#if defined(CONFIG_ARCH_TEGRA_114_SOC) || \
+	defined(CONFIG_ARCH_TEGRA_124_SOC) || \
+	defined(CONFIG_ARCH_TEGRA_132_SOC)
 
 static int _pll_fixed_mdiv(struct tegra_clk_pll_params *pll_params,
 			   unsigned long parent_rate)
@@ -1505,7 +1507,9 @@ struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
 	return clk;
 }
 
-#if defined(CONFIG_ARCH_TEGRA_114_SOC) || defined(CONFIG_ARCH_TEGRA_124_SOC)
+#if defined(CONFIG_ARCH_TEGRA_114_SOC) || \
+	defined(CONFIG_ARCH_TEGRA_124_SOC) || \
+	defined(CONFIG_ARCH_TEGRA_132_SOC)
 static const struct clk_ops tegra_clk_pllxc_ops = {
 	.is_enabled = clk_pll_is_enabled,
 	.enable = clk_pll_iddq_enable,
@@ -1802,7 +1806,7 @@ struct clk *tegra_clk_register_plle_tegra114(const char *name,
 }
 #endif
 
-#ifdef CONFIG_ARCH_TEGRA_124_SOC
+#if defined(CONFIG_ARCH_TEGRA_124_SOC) || defined(CONFIG_ARCH_TEGRA_132_SOC)
 static const struct clk_ops tegra_clk_pllss_ops = {
 	.is_enabled = clk_pll_is_enabled,
 	.enable = clk_pll_iddq_enable,
diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index f5f9bac..bfea9ff 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012, 2013, NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (c) 2012-2014 NVIDIA CORPORATION.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -28,6 +28,14 @@
 #include "clk.h"
 #include "clk-id.h"
 
+/*
+ * TEGRA124_CAR_BANK_COUNT: the number of peripheral clock register
+ * banks present in the Tegra124/132 CAR IP block.  The banks are
+ * identified by single letters, e.g.: L, H, U, V, W, X.  See
+ * periph_regs[] in drivers/clk/tegra/clk.c
+ */
+#define TEGRA124_CAR_BANK_COUNT			6
+
 #define CLK_SOURCE_CSITE 0x1d4
 #define CLK_SOURCE_EMC 0x19c
 
@@ -1351,7 +1359,7 @@ static const struct of_device_id pmc_match[] __initconst = {
 	{},
 };
 
-static struct tegra_clk_init_table init_table[] __initdata = {
+static struct tegra_clk_init_table common_init_table[] __initdata = {
 	{TEGRA124_CLK_UARTA, TEGRA124_CLK_PLL_P, 408000000, 0},
 	{TEGRA124_CLK_UARTB, TEGRA124_CLK_PLL_P, 408000000, 0},
 	{TEGRA124_CLK_UARTC, TEGRA124_CLK_PLL_P, 408000000, 0},
@@ -1385,27 +1393,72 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{TEGRA124_CLK_SATA, TEGRA124_CLK_PLL_P, 104000000, 0},
 	{TEGRA124_CLK_SATA_OOB, TEGRA124_CLK_PLL_P, 204000000, 0},
 	{TEGRA124_CLK_EMC, TEGRA124_CLK_CLK_MAX, 0, 1},
-	{TEGRA124_CLK_CCLK_G, TEGRA124_CLK_CLK_MAX, 0, 1},
 	{TEGRA124_CLK_MSELECT, TEGRA124_CLK_CLK_MAX, 0, 1},
 	{TEGRA124_CLK_CSITE, TEGRA124_CLK_CLK_MAX, 0, 1},
 	{TEGRA124_CLK_TSENSOR, TEGRA124_CLK_CLK_M, 400000, 0},
+	/* This MUST be the last entry. */
+	{TEGRA124_CLK_CLK_MAX, TEGRA124_CLK_CLK_MAX, 0, 0},
+};
+
+static struct tegra_clk_init_table tegra124_init_table[] __initdata = {
 	{TEGRA124_CLK_SOC_THERM, TEGRA124_CLK_PLL_P, 51000000, 0},
+	{TEGRA124_CLK_CCLK_G, TEGRA124_CLK_CLK_MAX, 0, 1},
+	/* This MUST be the last entry. */
+	{TEGRA124_CLK_CLK_MAX, TEGRA124_CLK_CLK_MAX, 0, 0},
+};
+
+/* Tegra132 requires the SOC_THERM clock to remain active */
+static struct tegra_clk_init_table tegra132_init_table[] __initdata = {
+	{TEGRA124_CLK_SOC_THERM, TEGRA124_CLK_PLL_P, 51000000, 1},
 	/* This MUST be the last entry. */
 	{TEGRA124_CLK_CLK_MAX, TEGRA124_CLK_CLK_MAX, 0, 0},
 };
 
+/**
+ * tegra124_clock_apply_init_table - initialize clocks on Tegra124 SoCs
+ *
+ * Program an initial clock rate and enable or disable clocks needed
+ * by the rest of the kernel, for Tegra124 SoCs.  It is intended to be
+ * called by assigning a pointer to it to tegra_clk_apply_init_table -
+ * this will be called as an arch_initcall.  No return value.
+ */
 static void __init tegra124_clock_apply_init_table(void)
 {
-	tegra_init_from_table(init_table, clks, TEGRA124_CLK_CLK_MAX);
+	tegra_init_from_table(common_init_table, clks, TEGRA124_CLK_CLK_MAX);
+	tegra_init_from_table(tegra124_init_table, clks, TEGRA124_CLK_CLK_MAX);
 }
 
-static void __init tegra124_clock_init(struct device_node *np)
+/**
+ * tegra132_clock_apply_init_table - initialize clocks on Tegra132 SoCs
+ *
+ * Program an initial clock rate and enable or disable clocks needed
+ * by the rest of the kernel, for Tegra132 SoCs.  It is intended to be
+ * called by assigning a pointer to it to tegra_clk_apply_init_table -
+ * this will be called as an arch_initcall.  No return value.
+ */
+static void __init tegra132_clock_apply_init_table(void)
+{
+	tegra_init_from_table(common_init_table, clks, TEGRA124_CLK_CLK_MAX);
+	tegra_init_from_table(tegra132_init_table, clks, TEGRA124_CLK_CLK_MAX);
+}
+
+/**
+ * tegra124_132_clock_init_pre - clock initialization preamble for T124/T132
+ * @np: struct device_node * of the DT node for the SoC CAR IP block
+ *
+ * Register most of the clocks controlled by the CAR IP block, along
+ * with a few clocks controlled by the PMC IP block.  Everything in
+ * this function should be common to Tegra124 and Tegra132.  XXX The
+ * PMC clock initialization should probably be moved to PMC-specific
+ * driver code.  No return value.
+ */
+static void __init tegra124_132_clock_init_pre(struct device_node *np)
 {
 	struct device_node *node;
 
 	clk_base = of_iomap(np, 0);
 	if (!clk_base) {
-		pr_err("ioremap tegra124 CAR failed\n");
+		pr_err("ioremap tegra124/tegra132 CAR failed\n");
 		return;
 	}
 
@@ -1423,7 +1476,8 @@ static void __init tegra124_clock_init(struct device_node *np)
 		return;
 	}
 
-	clks = tegra_clk_init(clk_base, TEGRA124_CLK_CLK_MAX, 6);
+	clks = tegra_clk_init(clk_base, TEGRA124_CLK_CLK_MAX,
+			      TEGRA124_CAR_BANK_COUNT);
 	if (!clks)
 		return;
 
@@ -1436,14 +1490,72 @@ static void __init tegra124_clock_init(struct device_node *np)
 	tegra124_periph_clk_init(clk_base, pmc_base);
 	tegra_audio_clk_init(clk_base, pmc_base, tegra124_clks, &pll_a_params);
 	tegra_pmc_clk_init(pmc_base, tegra124_clks);
+}
 
+/**
+ * tegra124_132_clock_init_post - clock initialization postamble for T124/T132
+ * @np: struct device_node * of the DT node for the SoC CAR IP block
+ *
+ * Register most of the along with a few clocks controlled by the PMC
+ * IP block.  Everything in this function should be common to Tegra124
+ * and Tegra132.  This function must be called after
+ * tegra124_132_clock_init_pre(), otherwise clk_base and pmc_base will
+ * not be set.  No return value.
+ */
+static void __init tegra124_132_clock_init_post(struct device_node *np)
+{
 	tegra_super_clk_gen4_init(clk_base, pmc_base, tegra124_clks,
-					&pll_x_params);
+				  &pll_x_params);
 	tegra_add_of_provider(np);
 	tegra_register_devclks(devclks, ARRAY_SIZE(devclks));
 
+	tegra_cpu_car_ops = &tegra124_cpu_car_ops;
+}
+
+/**
+ * tegra124_clock_init - Tegra124-specific clock initialization
+ * @np: struct device_node * of the DT node for the SoC CAR IP block
+ *
+ * Register most SoC clocks for the Tegra124 system-on-chip.  Most of
+ * this code is shared between the Tegra124 and Tegra132 SoCs,
+ * although some of the initial clock settings and CPU clocks differ.
+ * Intended to be called by the OF init code when a DT node with the
+ * "nvidia,tegra124-car" string is encountered, and declared with
+ * CLK_OF_DECLARE.  No return value.
+ */
+static void __init tegra124_clock_init(struct device_node *np)
+{
+	tegra124_132_clock_init_pre(np);
 	tegra_clk_apply_init_table = tegra124_clock_apply_init_table;
+	tegra124_132_clock_init_post(np);
+}
 
-	tegra_cpu_car_ops = &tegra124_cpu_car_ops;
+/**
+ * tegra132_clock_init - Tegra132-specific clock initialization
+ * @np: struct device_node * of the DT node for the SoC CAR IP block
+ *
+ * Register most SoC clocks for the Tegra132 system-on-chip.  Most of
+ * this code is shared between the Tegra124 and Tegra132 SoCs,
+ * although some of the initial clock settings and CPU clocks differ.
+ * Intended to be called by the OF init code when a DT node with the
+ * "nvidia,tegra132-car" string is encountered, and declared with
+ * CLK_OF_DECLARE.  No return value.
+ */
+static void __init tegra132_clock_init(struct device_node *np)
+{
+	tegra124_132_clock_init_pre(np);
+
+	/*
+	 * On Tegra132, these clocks are controlled by the
+	 * CLUSTER_clocks IP block, located in the CPU complex
+	 */
+	tegra124_clks[tegra_clk_cclk_g].present = false;
+	tegra124_clks[tegra_clk_cclk_lp].present = false;
+	tegra124_clks[tegra_clk_pll_x].present = false;
+	tegra124_clks[tegra_clk_pll_x_out0].present = false;
+
+	tegra_clk_apply_init_table = tegra132_clock_apply_init_table;
+	tegra124_132_clock_init_post(np);
 }
 CLK_OF_DECLARE(tegra124, "nvidia,tegra124-car", tegra124_clock_init);
+CLK_OF_DECLARE(tegra132, "nvidia,tegra132-car", tegra132_clock_init);


