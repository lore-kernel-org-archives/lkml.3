Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3IWObj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:31:39 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17215 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3IWObh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:31:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 23 Sep 2013 07:28:04 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v2 04/12] clk: tegra: move some PLLC and PLLXC init to clk-pll.c
Date: Mon, 23 Sep 2013 17:24:56 +0300
Message-ID: <1379946381-20125-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1379946381-20125-1-git-send-email-pdeschrijver@nvidia.com>
References: <1379946381-20125-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vco min clipping, dynamic ramp setup and IDDQ init can be done in the
respective pll clk_register functions if the parent is already registered.
This is done for other some PLLs already.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c      |   95 +++++++++++++++++++++++++++++++--
 drivers/clk/tegra/clk-tegra114.c |  109 +++++++-------------------------------
 2 files changed, 111 insertions(+), 93 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 197074a..4cb2cec 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -755,6 +755,48 @@ static int _pll_fixed_mdiv(struct tegra_clk_pll_params *pll_params,
 		return 1;
 }
 
+static unsigned long _clip_vco_min(unsigned long vco_min,
+				   unsigned long parent_rate)
+{
+	return DIV_ROUND_UP(vco_min, parent_rate) * parent_rate;
+}
+
+static int _setup_dynamic_ramp(struct tegra_clk_pll_params *pll_params,
+			       void __iomem *clk_base,
+			       unsigned long parent_rate)
+{
+	u32 val;
+	u32 step_a, step_b;
+
+	switch (parent_rate) {
+	case 12000000:
+	case 13000000:
+	case 26000000:
+		step_a = 0x2B;
+		step_b = 0x0B;
+		break;
+	case 16800000:
+		step_a = 0x1A;
+		step_b = 0x09;
+		break;
+	case 19200000:
+		step_a = 0x12;
+		step_b = 0x08;
+		break;
+	default:
+		pr_err("%s: Unexpected reference rate %lu\n",
+			__func__, parent_rate);
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	val = step_a << pll_params->stepa_shift;
+	val |= step_b << pll_params->stepb_shift;
+	writel_relaxed(val, clk_base + pll_params->dyn_ramp_reg);
+
+	return 0;
+}
+
 static int clk_pll_iddq_enable(struct clk_hw *hw)
 {
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
@@ -1393,11 +1435,39 @@ struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
 			  spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
-	struct clk *clk;
+	struct clk *clk, *parent;
+	unsigned long parent_rate;
+	int err;
+	u32 val, val_iddq;
+
+	parent = __clk_lookup(parent_name);
+	if (IS_ERR(parent)) {
+		WARN(1, "parent clk %s of %s must be registered first\n",
+			name, parent_name);
+		return ERR_PTR(-EINVAL);
+	}
 
 	if (!pll_params->pdiv_tohw)
 		return ERR_PTR(-EINVAL);
 
+	parent_rate = __clk_get_rate(parent);
+
+	pll_params->vco_min = _clip_vco_min(pll_params->vco_min, parent_rate);
+
+	err = _setup_dynamic_ramp(pll_params, clk_base, parent_rate);
+	if (err)
+		return ERR_PTR(err);
+
+	val = readl_relaxed(clk_base + pll_params->base_reg);
+	val_iddq = readl_relaxed(clk_base + pll_params->iddq_reg);
+
+	if (val & BIT(30))
+		WARN_ON(val_iddq & BIT(pll_params->iddq_bit_idx));
+	else {
+		val_iddq |= BIT(pll_params->iddq_bit_idx);
+		writel_relaxed(val_iddq, clk_base + pll_params->iddq_reg);
+	}
+
 	pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
 	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
 			      freq_table, lock);
@@ -1425,6 +1495,9 @@ struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
 	struct clk *clk;
 
 	pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE | TEGRA_PLL_LOCK_MISC;
+
+	pll_params->vco_min = _clip_vco_min(pll_params->vco_min, parent_rate);
+
 	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
 			      freq_table, lock);
 	if (IS_ERR(pll))
@@ -1468,11 +1541,23 @@ struct clk *tegra_clk_register_pllm(const char *name, const char *parent_name,
 			  spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
-	struct clk *clk;
+	struct clk *clk, *parent;
+	unsigned long parent_rate;
 
 	if (!pll_params->pdiv_tohw)
 		return ERR_PTR(-EINVAL);
 
+	parent = __clk_lookup(parent_name);
+	if (IS_ERR(parent)) {
+		WARN(1, "parent clk %s of %s must be registered first\n",
+			name, parent_name);
+		return ERR_PTR(-EINVAL);
+	}
+
+	parent_rate = __clk_get_rate(parent);
+
+	pll_params->vco_min = _clip_vco_min(pll_params->vco_min, parent_rate);
+
 	pll_flags |= TEGRA_PLL_BYPASS;
 	pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
 	pll_flags |= TEGRA_PLLM;
@@ -1513,14 +1598,16 @@ struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
 		return ERR_PTR(-EINVAL);
 	}
 
+	parent_rate = __clk_get_rate(parent);
+
+	pll_params->vco_min = _clip_vco_min(pll_params->vco_min, parent_rate);
+
 	pll_flags |= TEGRA_PLL_BYPASS;
 	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
 			      freq_table, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
-	parent_rate = __clk_get_rate(parent);
-
 	/*
 	 * Most of PLLC register fields are shadowed, and can not be read
 	 * directly from PLL h/w. Hence, actual PLLC boot state is unknown.
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index ccb61bc..b3210c8 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -1075,63 +1075,6 @@ static __init void tegra114_utmi_param_configure(void __iomem *clk_base)
 	writel_relaxed(reg, clk_base + UTMIPLL_HW_PWRDN_CFG0);
 }
 
-static void __init _clip_vco_min(struct tegra_clk_pll_params *pll_params)
-{
-	pll_params->vco_min =
-		DIV_ROUND_UP(pll_params->vco_min, pll_ref_freq) * pll_ref_freq;
-}
-
-static int __init _setup_dynamic_ramp(struct tegra_clk_pll_params *pll_params,
-				      void __iomem *clk_base)
-{
-	u32 val;
-	u32 step_a, step_b;
-
-	switch (pll_ref_freq) {
-	case 12000000:
-	case 13000000:
-	case 26000000:
-		step_a = 0x2B;
-		step_b = 0x0B;
-		break;
-	case 16800000:
-		step_a = 0x1A;
-		step_b = 0x09;
-		break;
-	case 19200000:
-		step_a = 0x12;
-		step_b = 0x08;
-		break;
-	default:
-		pr_err("%s: Unexpected reference rate %lu\n",
-			__func__, pll_ref_freq);
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
-	val = step_a << pll_params->stepa_shift;
-	val |= step_b << pll_params->stepb_shift;
-	writel_relaxed(val, clk_base + pll_params->dyn_ramp_reg);
-
-	return 0;
-}
-
-static void __init _init_iddq(struct tegra_clk_pll_params *pll_params,
-			      void __iomem *clk_base)
-{
-	u32 val, val_iddq;
-
-	val = readl_relaxed(clk_base + pll_params->base_reg);
-	val_iddq = readl_relaxed(clk_base + pll_params->iddq_reg);
-
-	if (val & BIT(30))
-		WARN_ON(val_iddq & BIT(pll_params->iddq_bit_idx));
-	else {
-		val_iddq |= BIT(pll_params->iddq_bit_idx);
-		writel_relaxed(val_iddq, clk_base + pll_params->iddq_reg);
-	}
-}
-
 static void __init tegra114_pll_init(void __iomem *clk_base,
 				     void __iomem *pmc)
 {
@@ -1139,28 +1082,23 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	struct clk *clk;
 
 	/* PLLC */
-	_clip_vco_min(&pll_c_params);
-	if (_setup_dynamic_ramp(&pll_c_params, clk_base) >= 0) {
-		_init_iddq(&pll_c_params, clk_base);
-		clk = tegra_clk_register_pllxc("pll_c", "pll_ref", clk_base,
-				pmc, 0, 0, &pll_c_params, TEGRA_PLL_USE_LOCK,
-				pll_c_freq_table, NULL);
-		clk_register_clkdev(clk, "pll_c", NULL);
-		clks[TEGRA114_CLK_PLL_C] = clk;
-
-		/* PLLC_OUT1 */
-		clk = tegra_clk_register_divider("pll_c_out1_div", "pll_c",
-				clk_base + PLLC_OUT, 0, TEGRA_DIVIDER_ROUND_UP,
-				8, 8, 1, NULL);
-		clk = tegra_clk_register_pll_out("pll_c_out1", "pll_c_out1_div",
-					clk_base + PLLC_OUT, 1, 0,
-					CLK_SET_RATE_PARENT, 0, NULL);
-		clk_register_clkdev(clk, "pll_c_out1", NULL);
-		clks[TEGRA114_CLK_PLL_C_OUT1] = clk;
-	}
+	clk = tegra_clk_register_pllxc("pll_c", "pll_ref", clk_base,
+			pmc, 0, 0, &pll_c_params, TEGRA_PLL_USE_LOCK,
+			pll_c_freq_table, NULL);
+	clk_register_clkdev(clk, "pll_c", NULL);
+	clks[TEGRA114_CLK_PLL_C] = clk;
+
+	/* PLLC_OUT1 */
+	clk = tegra_clk_register_divider("pll_c_out1_div", "pll_c",
+			clk_base + PLLC_OUT, 0, TEGRA_DIVIDER_ROUND_UP,
+			8, 8, 1, NULL);
+	clk = tegra_clk_register_pll_out("pll_c_out1", "pll_c_out1_div",
+				clk_base + PLLC_OUT, 1, 0,
+				CLK_SET_RATE_PARENT, 0, NULL);
+	clk_register_clkdev(clk, "pll_c_out1", NULL);
+	clks[TEGRA114_CLK_PLL_C_OUT1] = clk;
 
 	/* PLLC2 */
-	_clip_vco_min(&pll_c2_params);
 	clk = tegra_clk_register_pllc("pll_c2", "pll_ref", clk_base, pmc, 0, 0,
 			     &pll_c2_params, TEGRA_PLL_USE_LOCK,
 			     pll_cx_freq_table, NULL);
@@ -1168,7 +1106,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clks[TEGRA114_CLK_PLL_C2] = clk;
 
 	/* PLLC3 */
-	_clip_vco_min(&pll_c3_params);
 	clk = tegra_clk_register_pllc("pll_c3", "pll_ref", clk_base, pmc, 0, 0,
 			     &pll_c3_params, TEGRA_PLL_USE_LOCK,
 			     pll_cx_freq_table, NULL);
@@ -1230,7 +1167,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clks[TEGRA114_CLK_PLL_P_OUT4] = clk;
 
 	/* PLLM */
-	_clip_vco_min(&pll_m_params);
 	clk = tegra_clk_register_pllm("pll_m", "pll_ref", clk_base, pmc,
 			     CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE, 0,
 			     &pll_m_params, TEGRA_PLL_USE_LOCK,
@@ -1253,15 +1189,11 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 					CLK_SET_RATE_PARENT, 1, 1);
 
 	/* PLLX */
-	_clip_vco_min(&pll_x_params);
-	if (_setup_dynamic_ramp(&pll_x_params, clk_base) >= 0) {
-		_init_iddq(&pll_x_params, clk_base);
-		clk = tegra_clk_register_pllxc("pll_x", "pll_ref", clk_base,
-				pmc, CLK_IGNORE_UNUSED, 0, &pll_x_params,
-				TEGRA_PLL_USE_LOCK, pll_x_freq_table, NULL);
-		clk_register_clkdev(clk, "pll_x", NULL);
-		clks[TEGRA114_CLK_PLL_X] = clk;
-	}
+	clk = tegra_clk_register_pllxc("pll_x", "pll_ref", clk_base,
+			pmc, CLK_IGNORE_UNUSED, 0, &pll_x_params,
+			TEGRA_PLL_USE_LOCK, pll_x_freq_table, NULL);
+	clk_register_clkdev(clk, "pll_x", NULL);
+	clks[TEGRA114_CLK_PLL_X] = clk;
 
 	/* PLLX_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_x_out0", "pll_x",
@@ -1354,7 +1286,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clks[TEGRA114_CLK_PLL_A_OUT0] = clk;
 
 	/* PLLRE */
-	_clip_vco_min(&pll_re_vco_params);
 	clk = tegra_clk_register_pllre("pll_re_vco", "pll_ref", clk_base, pmc,
 			     0, 0, &pll_re_vco_params, TEGRA_PLL_USE_LOCK,
 			     NULL, &pll_re_lock, pll_ref_freq);
-- 
1.7.7.rc0.72.g4b5ea.dirty

