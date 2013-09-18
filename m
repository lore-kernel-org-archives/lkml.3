Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3IRO6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:58:25 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:6094 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab3IRO6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:58:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Sep 2013 07:58:22 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 12/12] clk: tegra: introduce common gen4 super clock
Date: Wed, 18 Sep 2013 17:41:04 +0300
Message-ID: <1379515331-19427-13-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a common function which super clock initialization for Tegra114
and beyond.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/Makefile               |    1 +
 drivers/clk/tegra/clk-tegra-super-gen4.c |  220 ++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk-tegra114.c         |  126 +-----------------
 drivers/clk/tegra/clk.h                  |    2 +
 4 files changed, 226 insertions(+), 123 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-tegra-super-gen4.c

diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
index 5b78841..a4e5b5a 100644
--- a/drivers/clk/tegra/Makefile
+++ b/drivers/clk/tegra/Makefile
@@ -11,6 +11,7 @@ obj-y					+= clk-tegra-periph.o
 obj-y					+= clk-tegra-pmc.o
 obj-y					+= clk-tegra-fixed.o
 obj-y					+= clk-tegra-osc.o
+obj-y					+= clk-tegra-super-gen4.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= clk-tegra114.o
diff --git a/drivers/clk/tegra/clk-tegra-super-gen4.c b/drivers/clk/tegra/clk-tegra-super-gen4.c
new file mode 100644
index 0000000..9130025
--- /dev/null
+++ b/drivers/clk/tegra/clk-tegra-super-gen4.c
@@ -0,0 +1,220 @@
+/*
+ * Copyright (c) 2012, 2013, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/delay.h>
+#include <linux/export.h>
+#include <linux/clk/tegra.h>
+
+#include "clk.h"
+#include "clk-id.h"
+
+#define PLLX_BASE 0xe0
+#define PLLX_MISC 0xe4
+#define PLLX_MISC2 0x514
+#define PLLX_MISC3 0x518
+
+#define PLL_BASE_LOCK BIT(27)
+#define PLL_MISC_LOCK_ENABLE 18
+
+#define CCLKG_BURST_POLICY 0x368
+#define CCLKLP_BURST_POLICY 0x370
+#define SCLK_BURST_POLICY 0x028
+#define SYSTEM_CLK_RATE 0x030
+
+static DEFINE_SPINLOCK(sysrate_lock);
+
+static const char *sclk_parents[] = { "clk_m", "pll_c_out1", "pll_p_out4",
+			       "pll_p", "pll_p_out2", "unused",
+			       "clk_32k", "pll_m_out1" };
+
+static const char *cclk_g_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
+					"pll_p", "pll_p_out4", "unused",
+					"unused", "pll_x" };
+
+static const char *cclk_lp_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
+					 "pll_p", "pll_p_out4", "unused",
+					 "unused", "pll_x", "pll_x_out0" };
+
+static struct tegra_clk_pll_freq_table pll_x_freq_table[] = {
+	/* 1 GHz */
+	{12000000, 1000000000, 83, 0, 1},	/* actual: 996.0 MHz */
+	{13000000, 1000000000, 76, 0, 1},	/* actual: 988.0 MHz */
+	{16800000, 1000000000, 59, 0, 1},	/* actual: 991.2 MHz */
+	{19200000, 1000000000, 52, 0, 1},	/* actual: 998.4 MHz */
+	{26000000, 1000000000, 76, 1, 1},	/* actual: 988.0 MHz */
+	{0, 0, 0, 0, 0, 0},
+};
+
+static struct div_nmp pllxc_nmp = {
+	.divm_shift = 0,
+	.divm_width = 8,
+	.divn_shift = 8,
+	.divn_width = 8,
+	.divp_shift = 20,
+	.divp_width = 4,
+};
+
+static struct pdiv_map pllxc_p[] = {
+	{ .pdiv = 1, .hw_val = 0 },
+	{ .pdiv = 2, .hw_val = 1 },
+	{ .pdiv = 3, .hw_val = 2 },
+	{ .pdiv = 4, .hw_val = 3 },
+	{ .pdiv = 5, .hw_val = 4 },
+	{ .pdiv = 6, .hw_val = 5 },
+	{ .pdiv = 8, .hw_val = 6 },
+	{ .pdiv = 10, .hw_val = 7 },
+	{ .pdiv = 12, .hw_val = 8 },
+	{ .pdiv = 16, .hw_val = 9 },
+	{ .pdiv = 12, .hw_val = 10 },
+	{ .pdiv = 16, .hw_val = 11 },
+	{ .pdiv = 20, .hw_val = 12 },
+	{ .pdiv = 24, .hw_val = 13 },
+	{ .pdiv = 32, .hw_val = 14 },
+	{ .pdiv = 0, .hw_val = 0 },
+};
+
+static struct tegra_clk_pll_params pll_x_params = {
+	.input_min = 12000000,
+	.input_max = 800000000,
+	.cf_min = 12000000,
+	.cf_max = 19200000,	/* s/w policy, h/w capability 50 MHz */
+	.vco_min = 700000000,
+	.vco_max = 2400000000U,
+	.base_reg = PLLX_BASE,
+	.misc_reg = PLLX_MISC,
+	.lock_mask = PLL_BASE_LOCK,
+	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
+	.lock_delay = 300,
+	.iddq_reg = PLLX_MISC3,
+	.iddq_bit_idx = 3,
+	.max_p = 6,
+	.dyn_ramp_reg = PLLX_MISC2,
+	.stepa_shift = 16,
+	.stepb_shift = 24,
+	.pdiv_tohw = pllxc_p,
+	.div_nmp = &pllxc_nmp,
+};
+
+static void __init tegra_sclk_init(void __iomem *clk_base,
+				struct tegra_clk *tegra_clks)
+{
+	struct clk *clk;
+	struct clk **dt_clk;
+
+	/* SCLK */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_sclk, tegra_clks);
+	if (!dt_clk)
+		return;
+
+	clk = tegra_clk_register_super_mux("sclk", sclk_parents,
+					ARRAY_SIZE(sclk_parents),
+					CLK_SET_RATE_PARENT,
+					clk_base + SCLK_BURST_POLICY,
+					0, 4, 0, 0, NULL);
+	clk_register_clkdev(clk, "sclk", NULL);
+	*dt_clk = clk;
+
+	/* HCLK */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_hclk, tegra_clks);
+	if (!dt_clk)
+		return;
+
+	clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
+				   clk_base + SYSTEM_CLK_RATE, 4, 2, 0,
+				   &sysrate_lock);
+	clk = clk_register_gate(NULL, "hclk", "hclk_div", CLK_SET_RATE_PARENT |
+				CLK_IGNORE_UNUSED, clk_base + SYSTEM_CLK_RATE,
+				7, CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
+	clk_register_clkdev(clk, "hclk", NULL);
+	*dt_clk = clk;
+
+	/* PCLK */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_pclk, tegra_clks);
+	if (!dt_clk)
+		return;
+
+	clk = clk_register_divider(NULL, "pclk_div", "hclk", 0,
+				   clk_base + SYSTEM_CLK_RATE, 0, 2, 0,
+				   &sysrate_lock);
+	clk = clk_register_gate(NULL, "pclk", "pclk_div", CLK_SET_RATE_PARENT |
+				CLK_IGNORE_UNUSED, clk_base + SYSTEM_CLK_RATE,
+				3, CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
+	clk_register_clkdev(clk, "pclk", NULL);
+	*dt_clk = clk;
+}
+
+void __init tegra_super_clk_gen4_init(void __iomem *clk_base,
+				void __iomem *pmc_base,
+				struct tegra_clk *tegra_clks)
+{
+	struct clk *clk;
+	struct clk **dt_clk;
+
+	/* CCLKG */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_cclk_g, tegra_clks);
+	if (dt_clk) {
+		clk = tegra_clk_register_super_mux("cclk_g", cclk_g_parents,
+					ARRAY_SIZE(cclk_g_parents),
+					CLK_SET_RATE_PARENT,
+					clk_base + CCLKG_BURST_POLICY,
+					0, 4, 0, 0, NULL);
+		clk_register_clkdev(clk, "cclk_g", NULL);
+		*dt_clk = clk;
+	}
+
+	/* CCLKLP */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_cclk_lp, tegra_clks);
+	if (dt_clk) {
+		clk = tegra_clk_register_super_mux("cclk_lp", cclk_lp_parents,
+					ARRAY_SIZE(cclk_lp_parents),
+					CLK_SET_RATE_PARENT,
+					clk_base + CCLKLP_BURST_POLICY,
+					0, 4, 8, 9, NULL);
+		clk_register_clkdev(clk, "cclk_lp", NULL);
+		*dt_clk = clk;
+	}
+
+	tegra_sclk_init(clk_base, tegra_clks);
+
+	/* PLLX */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_pll_x, tegra_clks);
+	if (!dt_clk)
+		return;
+
+	clk = tegra_clk_register_pllxc("pll_x", "pll_ref", clk_base,
+			pmc_base, CLK_IGNORE_UNUSED, 0, &pll_x_params,
+			TEGRA_PLL_USE_LOCK, pll_x_freq_table, NULL);
+	clk_register_clkdev(clk, "pll_x", NULL);
+	*dt_clk = clk;
+
+	/* PLLX_OUT0 */
+
+	dt_clk = tegra_lookup_dt_id(tegra_clk_pll_x_out0, tegra_clks);
+	if (!dt_clk)
+		return;
+	clk = clk_register_fixed_factor(NULL, "pll_x_out0", "pll_x",
+					CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clk, "pll_x_out0", NULL);
+	*dt_clk = clk;
+
+}
+
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index b2ddfbf..ab11d00 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -69,10 +69,6 @@
 #define PLLM_MISC 0x9c
 #define PLLP_BASE 0xa0
 #define PLLP_MISC 0xac
-#define PLLX_BASE 0xe0
-#define PLLX_MISC 0xe4
-#define PLLX_MISC2 0x514
-#define PLLX_MISC3 0x518
 #define PLLD_BASE 0xd0
 #define PLLD_MISC 0xdc
 #define PLLD2_BASE 0x4b8
@@ -91,7 +87,6 @@
 #define PLLRE_MISC_LOCK_ENABLE 30
 
 #define PLLC_IDDQ_BIT 26
-#define PLLX_IDDQ_BIT 3
 #define PLLRE_IDDQ_BIT 16
 
 #define PLL_BASE_LOCK BIT(27)
@@ -110,12 +105,9 @@
 #define PMC_CTRL_BLINK_ENB 7
 #define PMC_BLINK_TIMER 0x40
 
-#define PLLXC_SW_MAX_P			6
-
 #define CCLKG_BURST_POLICY 0x368
-#define CCLKLP_BURST_POLICY 0x370
-#define SCLK_BURST_POLICY 0x028
-#define SYSTEM_CLK_RATE 0x030
+
+#define PLLXC_SW_MAX_P			6
 
 #define UTMIP_PLL_CFG2 0x488
 #define UTMIP_PLL_CFG2_STABLE_COUNT(x) (((x) & 0xffff) << 6)
@@ -169,7 +161,6 @@ static DEFINE_SPINLOCK(pll_d_lock);
 static DEFINE_SPINLOCK(pll_d2_lock);
 static DEFINE_SPINLOCK(pll_u_lock);
 static DEFINE_SPINLOCK(pll_re_lock);
-static DEFINE_SPINLOCK(sysrate_lock);
 
 static struct div_nmp pllxc_nmp = {
 	.divm_shift = 0,
@@ -444,39 +435,6 @@ static struct tegra_clk_pll_params pll_u_params = {
 	.div_nmp = &pllu_nmp,
 };
 
-static struct tegra_clk_pll_freq_table pll_x_freq_table[] = {
-	/* 1 GHz */
-	{12000000, 1000000000, 83, 0, 1},	/* actual: 996.0 MHz */
-	{13000000, 1000000000, 76, 0, 1},	/* actual: 988.0 MHz */
-	{16800000, 1000000000, 59, 0, 1},	/* actual: 991.2 MHz */
-	{19200000, 1000000000, 52, 0, 1},	/* actual: 998.4 MHz */
-	{26000000, 1000000000, 76, 1, 1},	/* actual: 988.0 MHz */
-
-	{0, 0, 0, 0, 0, 0},
-};
-
-static struct tegra_clk_pll_params pll_x_params = {
-	.input_min = 12000000,
-	.input_max = 800000000,
-	.cf_min = 12000000,
-	.cf_max = 19200000,	/* s/w policy, h/w capability 50 MHz */
-	.vco_min = 700000000,
-	.vco_max = 2400000000U,
-	.base_reg = PLLX_BASE,
-	.misc_reg = PLLX_MISC,
-	.lock_mask = PLL_BASE_LOCK,
-	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
-	.lock_delay = 300,
-	.iddq_reg = PLLX_MISC3,
-	.iddq_bit_idx = PLLX_IDDQ_BIT,
-	.max_p = PLLXC_SW_MAX_P,
-	.dyn_ramp_reg = PLLX_MISC2,
-	.stepa_shift = 16,
-	.stepb_shift = 24,
-	.pdiv_tohw = pllxc_p,
-	.div_nmp = &pllxc_nmp,
-};
-
 static struct tegra_clk_pll_freq_table pll_e_freq_table[] = {
 	/* PLLE special case: use cpcon field to store cml divider value */
 	{336000000, 100000000, 100, 21, 16, 11},
@@ -932,19 +890,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clk = clk_register_fixed_factor(NULL, "pll_m_ud", "pll_m",
 					CLK_SET_RATE_PARENT, 1, 1);
 
-	/* PLLX */
-	clk = tegra_clk_register_pllxc("pll_x", "pll_ref", clk_base,
-			pmc, CLK_IGNORE_UNUSED, 0, &pll_x_params,
-			TEGRA_PLL_USE_LOCK, pll_x_freq_table, NULL);
-	clk_register_clkdev(clk, "pll_x", NULL);
-	clks[TEGRA114_CLK_PLL_X] = clk;
-
-	/* PLLX_OUT0 */
-	clk = clk_register_fixed_factor(NULL, "pll_x_out0", "pll_x",
-					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "pll_x_out0", NULL);
-	clks[TEGRA114_CLK_PLL_X_OUT0] = clk;
-
 	/* PLLU */
 	val = readl(clk_base + pll_u_params.base_reg);
 	val &= ~BIT(24); /* disable PLLU_OVERRIDE */
@@ -1033,70 +978,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clks[TEGRA114_CLK_PLL_E_OUT0] = clk;
 }
 
-static const char *sclk_parents[] = { "clk_m", "pll_c_out1", "pll_p_out4",
-			       "pll_p", "pll_p_out2", "unused",
-			       "clk_32k", "pll_m_out1" };
-
-static const char *cclk_g_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
-					"pll_p", "pll_p_out4", "unused",
-					"unused", "pll_x" };
-
-static const char *cclk_lp_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
-					 "pll_p", "pll_p_out4", "unused",
-					 "unused", "pll_x", "pll_x_out0" };
-
-static void __init tegra114_super_clk_init(void __iomem *clk_base)
-{
-	struct clk *clk;
-
-	/* CCLKG */
-	clk = tegra_clk_register_super_mux("cclk_g", cclk_g_parents,
-					ARRAY_SIZE(cclk_g_parents),
-					CLK_SET_RATE_PARENT,
-					clk_base + CCLKG_BURST_POLICY,
-					0, 4, 0, 0, NULL);
-	clk_register_clkdev(clk, "cclk_g", NULL);
-	clks[TEGRA114_CLK_CCLK_G] = clk;
-
-	/* CCLKLP */
-	clk = tegra_clk_register_super_mux("cclk_lp", cclk_lp_parents,
-					ARRAY_SIZE(cclk_lp_parents),
-					CLK_SET_RATE_PARENT,
-					clk_base + CCLKLP_BURST_POLICY,
-					0, 4, 8, 9, NULL);
-	clk_register_clkdev(clk, "cclk_lp", NULL);
-	clks[TEGRA114_CLK_CCLK_LP] = clk;
-
-	/* SCLK */
-	clk = tegra_clk_register_super_mux("sclk", sclk_parents,
-					ARRAY_SIZE(sclk_parents),
-					CLK_SET_RATE_PARENT,
-					clk_base + SCLK_BURST_POLICY,
-					0, 4, 0, 0, NULL);
-	clk_register_clkdev(clk, "sclk", NULL);
-	clks[TEGRA114_CLK_SCLK] = clk;
-
-	/* HCLK */
-	clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
-				   clk_base + SYSTEM_CLK_RATE, 4, 2, 0,
-				   &sysrate_lock);
-	clk = clk_register_gate(NULL, "hclk", "hclk_div", CLK_SET_RATE_PARENT |
-				CLK_IGNORE_UNUSED, clk_base + SYSTEM_CLK_RATE,
-				7, CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clk_register_clkdev(clk, "hclk", NULL);
-	clks[TEGRA114_CLK_HCLK] = clk;
-
-	/* PCLK */
-	clk = clk_register_divider(NULL, "pclk_div", "hclk", 0,
-				   clk_base + SYSTEM_CLK_RATE, 0, 2, 0,
-				   &sysrate_lock);
-	clk = clk_register_gate(NULL, "pclk", "pclk_div", CLK_SET_RATE_PARENT |
-				CLK_IGNORE_UNUSED, clk_base + SYSTEM_CLK_RATE,
-				3, CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clk_register_clkdev(clk, "pclk", NULL);
-	clks[TEGRA114_CLK_PCLK] = clk;
-}
-
 static __init void tegra114_periph_clk_init(void __iomem *clk_base,
 					    void __iomem *pmc_base)
 {
@@ -1381,8 +1262,7 @@ static void __init tegra114_clock_init(struct device_node *np)
 	tegra_audio_clk_init(clk_base, pmc_base, tegra114_clks, NULL);
 	tegra_pmc_clk_init(pmc_base, tegra114_clks);
 
-	tegra114_super_clk_init(clk_base);
-
+	tegra_super_clk_gen4_init(clk_base, pmc_base, tegra114_clks);
 	tegra_add_of_provider(np);
 
 	tegra_clk_apply_init_table = tegra114_clock_apply_init_table;
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 3b28178..153d857 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -614,6 +614,8 @@ int tegra_osc_clk_init(void __iomem *clk_base, struct tegra_clk *tegra_clks,
 				unsigned long *input_freqs, int num,
 				unsigned long *osc_freq,
 				unsigned long *pll_ref_freq);
+void tegra_super_clk_gen4_init(void __iomem *clk_base,
+			void __iomem *pmc_base, struct tegra_clk *tegra_clks);
 
 void tegra114_clock_tune_cpu_trimmers_high(void);
 void tegra114_clock_tune_cpu_trimmers_low(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

