Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab3JUN6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:58:40 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:6056 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3JUN6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:58:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Oct 2013 06:54:01 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>
Subject: [PATCH v6 13/15] clk: tegra: introduce common gen4 super clock
Date: Mon, 21 Oct 2013 16:53:52 +0300
Message-ID: <1382363634-10870-14-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382363634-10870-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382363634-10870-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a common function which performs super clock initialization for
Tegra114 and beyond.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/Makefile               |    1 +
 drivers/clk/tegra/clk-tegra-super-gen4.c |  149 ++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk-tegra114.c         |   76 +---------------
 drivers/clk/tegra/clk.h                  |    3 +
 4 files changed, 155 insertions(+), 74 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-tegra-super-gen4.c

diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
index a02e9a9..2d83741 100644
--- a/drivers/clk/tegra/Makefile
+++ b/drivers/clk/tegra/Makefile
@@ -10,6 +10,7 @@ obj-y					+= clk-tegra-audio.o
 obj-y					+= clk-tegra-periph.o
 obj-y					+= clk-tegra-pmc.o
 obj-y					+= clk-tegra-fixed.o
+obj-y					+= clk-tegra-super-gen4.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= clk-tegra114.o
diff --git a/drivers/clk/tegra/clk-tegra-super-gen4.c b/drivers/clk/tegra/clk-tegra-super-gen4.c
new file mode 100644
index 0000000..05dce4a
--- /dev/null
+++ b/drivers/clk/tegra/clk-tegra-super-gen4.c
@@ -0,0 +1,149 @@
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
+static void __init tegra_sclk_init(void __iomem *clk_base,
+				struct tegra_clk *tegra_clks)
+{
+	struct clk *clk;
+	struct clk **dt_clk;
+
+	/* SCLK */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_sclk, tegra_clks);
+	if (dt_clk) {
+		clk = tegra_clk_register_super_mux("sclk", sclk_parents,
+						ARRAY_SIZE(sclk_parents),
+						CLK_SET_RATE_PARENT,
+						clk_base + SCLK_BURST_POLICY,
+						0, 4, 0, 0, NULL);
+		*dt_clk = clk;
+	}
+
+	/* HCLK */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_hclk, tegra_clks);
+	if (dt_clk) {
+		clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
+				   clk_base + SYSTEM_CLK_RATE, 4, 2, 0,
+				   &sysrate_lock);
+		clk = clk_register_gate(NULL, "hclk", "hclk_div",
+				CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED,
+				clk_base + SYSTEM_CLK_RATE,
+				7, CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
+		*dt_clk = clk;
+	}
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
+	*dt_clk = clk;
+}
+
+void __init tegra_super_clk_gen4_init(void __iomem *clk_base,
+				void __iomem *pmc_base,
+				struct tegra_clk *tegra_clks,
+				struct tegra_clk_pll_params *params)
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
+		*dt_clk = clk;
+	}
+
+	tegra_sclk_init(clk_base, tegra_clks);
+
+#if defined(CONFIG_ARCH_TEGRA_114_SOC) || defined(CONFIG_ARCH_TEGRA_124_SOC)
+	/* PLLX */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_pll_x, tegra_clks);
+	if (!dt_clk)
+		return;
+
+	clk = tegra_clk_register_pllxc("pll_x", "pll_ref", clk_base,
+			pmc_base, CLK_IGNORE_UNUSED, params, NULL);
+	*dt_clk = clk;
+
+	/* PLLX_OUT0 */
+
+	dt_clk = tegra_lookup_dt_id(tegra_clk_pll_x_out0, tegra_clks);
+	if (!dt_clk)
+		return;
+	clk = clk_register_fixed_factor(NULL, "pll_x_out0", "pll_x",
+					CLK_SET_RATE_PARENT, 1, 2);
+	*dt_clk = clk;
+#endif
+}
+
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 8880b92..e365b35 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -121,9 +121,6 @@
 #define PLLXC_SW_MAX_P			6
 
 #define CCLKG_BURST_POLICY 0x368
-#define CCLKLP_BURST_POLICY 0x370
-#define SCLK_BURST_POLICY 0x028
-#define SYSTEM_CLK_RATE 0x030
 
 #define UTMIP_PLL_CFG2 0x488
 #define UTMIP_PLL_CFG2_STABLE_COUNT(x) (((x) & 0xffff) << 6)
@@ -177,7 +174,6 @@ static DEFINE_SPINLOCK(pll_d_lock);
 static DEFINE_SPINLOCK(pll_d2_lock);
 static DEFINE_SPINLOCK(pll_u_lock);
 static DEFINE_SPINLOCK(pll_re_lock);
-static DEFINE_SPINLOCK(sysrate_lock);
 
 static struct div_nmp pllxc_nmp = {
 	.divm_shift = 0,
@@ -1119,16 +1115,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clk = clk_register_fixed_factor(NULL, "pll_m_ud", "pll_m",
 					CLK_SET_RATE_PARENT, 1, 1);
 
-	/* PLLX */
-	clk = tegra_clk_register_pllxc("pll_x", "pll_ref", clk_base,
-			pmc, CLK_IGNORE_UNUSED, &pll_x_params, NULL);
-	clks[TEGRA114_CLK_PLL_X] = clk;
-
-	/* PLLX_OUT0 */
-	clk = clk_register_fixed_factor(NULL, "pll_x_out0", "pll_x",
-					CLK_SET_RATE_PARENT, 1, 2);
-	clks[TEGRA114_CLK_PLL_X_OUT0] = clk;
-
 	/* PLLU */
 	val = readl(clk_base + pll_u_params.base_reg);
 	val &= ~BIT(24); /* disable PLLU_OVERRIDE */
@@ -1197,65 +1183,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
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
-	clks[TEGRA114_CLK_CCLK_G] = clk;
-
-	/* CCLKLP */
-	clk = tegra_clk_register_super_mux("cclk_lp", cclk_lp_parents,
-					ARRAY_SIZE(cclk_lp_parents),
-					CLK_SET_RATE_PARENT,
-					clk_base + CCLKLP_BURST_POLICY,
-					0, 4, 8, 9, NULL);
-	clks[TEGRA114_CLK_CCLK_LP] = clk;
-
-	/* SCLK */
-	clk = tegra_clk_register_super_mux("sclk", sclk_parents,
-					ARRAY_SIZE(sclk_parents),
-					CLK_SET_RATE_PARENT,
-					clk_base + SCLK_BURST_POLICY,
-					0, 4, 0, 0, NULL);
-	clks[TEGRA114_CLK_SCLK] = clk;
-
-	/* HCLK */
-	clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
-				   clk_base + SYSTEM_CLK_RATE, 4, 2, 0,
-				   &sysrate_lock);
-	clk = clk_register_gate(NULL, "hclk", "hclk_div", CLK_SET_RATE_PARENT |
-				CLK_IGNORE_UNUSED, clk_base + SYSTEM_CLK_RATE,
-				7, CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clks[TEGRA114_CLK_HCLK] = clk;
-
-	/* PCLK */
-	clk = clk_register_divider(NULL, "pclk_div", "hclk", 0,
-				   clk_base + SYSTEM_CLK_RATE, 0, 2, 0,
-				   &sysrate_lock);
-	clk = clk_register_gate(NULL, "pclk", "pclk_div", CLK_SET_RATE_PARENT |
-				CLK_IGNORE_UNUSED, clk_base + SYSTEM_CLK_RATE,
-				3, CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clks[TEGRA114_CLK_PCLK] = clk;
-}
-
 static __init void tegra114_periph_clk_init(void __iomem *clk_base,
 					    void __iomem *pmc_base)
 {
@@ -1546,7 +1473,8 @@ static void __init tegra114_clock_init(struct device_node *np)
 	tegra114_periph_clk_init(clk_base, pmc_base);
 	tegra_audio_clk_init(clk_base, pmc_base, tegra114_clks, &pll_a_params);
 	tegra_pmc_clk_init(pmc_base, tegra114_clks);
-	tegra114_super_clk_init(clk_base);
+	tegra_super_clk_gen4_init(clk_base, pmc_base, tegra114_clks,
+					&pll_x_params);
 
 	tegra_add_of_provider(np);
 	tegra_register_devclks(devclks, ARRAY_SIZE(devclks));
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 2d48817..05abfc5 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -610,6 +610,9 @@ int tegra_osc_clk_init(void __iomem *clk_base, struct tegra_clk *tegra_clks,
 				unsigned long *input_freqs, int num,
 				unsigned long *osc_freq,
 				unsigned long *pll_ref_freq);
+void tegra_super_clk_gen4_init(void __iomem *clk_base,
+			void __iomem *pmc_base, struct tegra_clk *tegra_clks,
+			struct tegra_clk_pll_params *pll_params);
 
 void tegra114_clock_tune_cpu_trimmers_high(void);
 void tegra114_clock_tune_cpu_trimmers_low(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

