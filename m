Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3BAKUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:20:33 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17362 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3BAKUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:20:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 01 Feb 2013 02:19:54 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v5 01/10] clk: tegra: Refactor PLL programming code
Date: Fri, 1 Feb 2013 12:18:30 +0200
Message-ID: <1359713962-16822-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com>
References: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the PLL programming code to make it useable by the new PLL types
introduced by Tegra114.

The following changes were done:

* Split programming the PLL into updating m,n,p and updating cpcon
* Move locking from _update_pll_cpcon() to clk_pll_set_rate()
* Introduce _get_pll_mnp() helper
* Move check for identical m,n,p values to clk_pll_set_rate()
* struct tegra_clk_pll_freq_table will always contain the values as defined
  by the hardware.
* Simplify the arguments to clk_pll_wait_for_lock()

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c     |  178 +++++++++++++++++------------
 drivers/clk/tegra/clk-tegra20.c |  144 ++++++++++++------------
 drivers/clk/tegra/clk-tegra30.c |  234 +++++++++++++++++++-------------------
 3 files changed, 294 insertions(+), 262 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 165f247..912c977 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (c) 2012, 2013, NVIDIA CORPORATION.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -113,20 +113,23 @@ static void clk_pll_enable_lock(struct tegra_clk_pll *pll)
 	pll_writel_misc(val, pll);
 }
 
-static int clk_pll_wait_for_lock(struct tegra_clk_pll *pll,
-				 void __iomem *lock_addr, u32 lock_bit_idx)
+static int clk_pll_wait_for_lock(struct tegra_clk_pll *pll)
 {
 	int i;
-	u32 val;
+	u32 val, lock_bit;
+	void __iomem *lock_addr;
 
 	if (!(pll->flags & TEGRA_PLL_USE_LOCK)) {
 		udelay(pll->params->lock_delay);
 		return 0;
 	}
 
+	lock_addr = pll->clk_base + pll->params->base_reg;
+	lock_bit = BIT(pll->params->lock_bit_idx);
+
 	for (i = 0; i < pll->params->lock_delay; i++) {
 		val = readl_relaxed(lock_addr);
-		if (val & BIT(lock_bit_idx)) {
+		if (val & lock_bit) {
 			udelay(PLL_POST_LOCK_DELAY);
 			return 0;
 		}
@@ -155,7 +158,7 @@ static int clk_pll_is_enabled(struct clk_hw *hw)
 	return val & PLL_BASE_ENABLE ? 1 : 0;
 }
 
-static int _clk_pll_enable(struct clk_hw *hw)
+static void _clk_pll_enable(struct clk_hw *hw)
 {
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
 	u32 val;
@@ -172,11 +175,6 @@ static int _clk_pll_enable(struct clk_hw *hw)
 		val |= PMC_PLLP_WB0_OVERRIDE_PLLM_ENABLE;
 		writel_relaxed(val, pll->pmc + PMC_PLLP_WB0_OVERRIDE);
 	}
-
-	clk_pll_wait_for_lock(pll, pll->clk_base + pll->params->base_reg,
-			      pll->params->lock_bit_idx);
-
-	return 0;
 }
 
 static void _clk_pll_disable(struct clk_hw *hw)
@@ -204,7 +202,9 @@ static int clk_pll_enable(struct clk_hw *hw)
 	if (pll->lock)
 		spin_lock_irqsave(pll->lock, flags);
 
-	ret = _clk_pll_enable(hw);
+	_clk_pll_enable(hw);
+
+	ret = clk_pll_wait_for_lock(pll);
 
 	if (pll->lock)
 		spin_unlock_irqrestore(pll->lock, flags);
@@ -241,8 +241,6 @@ static int _get_table_rate(struct clk_hw *hw,
 	if (sel->input_rate == 0)
 		return -EINVAL;
 
-	BUG_ON(sel->p < 1);
-
 	cfg->input_rate = sel->input_rate;
 	cfg->output_rate = sel->output_rate;
 	cfg->m = sel->m;
@@ -290,88 +288,109 @@ static int _calc_rate(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
 	     cfg->output_rate <<= 1)
 		p_div++;
 
-	cfg->p = 1 << p_div;
+	cfg->p = p_div;
 	cfg->m = parent_rate / cfreq;
 	cfg->n = cfg->output_rate / cfreq;
 	cfg->cpcon = OUT_OF_TABLE_CPCON;
 
 	if (cfg->m > divm_max(pll) || cfg->n > divn_max(pll) ||
-	    cfg->p > divp_max(pll) || cfg->output_rate > pll->params->vco_max) {
+	    (1 << p_div) > divp_max(pll)
+	    || cfg->output_rate > pll->params->vco_max) {
 		pr_err("%s: Failed to set %s rate %lu\n",
 		       __func__, __clk_get_name(hw->clk), rate);
 		return -EINVAL;
 	}
 
+	if (pll->flags & TEGRA_PLLU)
+		cfg->p ^= 1;
+
 	return 0;
 }
 
-static int _program_pll(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
-			unsigned long rate)
+static void _update_pll_mnp(struct tegra_clk_pll *pll,
+			    struct tegra_clk_pll_freq_table *cfg)
 {
-	struct tegra_clk_pll *pll = to_clk_pll(hw);
-	unsigned long flags = 0;
-	u32 divp, val, old_base;
-	int state;
-
-	divp = __ffs(cfg->p);
-
-	if (pll->flags & TEGRA_PLLU)
-		divp ^= 1;
+	u32 val;
 
-	if (pll->lock)
-		spin_lock_irqsave(pll->lock, flags);
+	val = pll_readl_base(pll);
 
-	old_base = val = pll_readl_base(pll);
 	val &= ~((divm_mask(pll) << pll->divm_shift) |
 		 (divn_mask(pll) << pll->divn_shift) |
 		 (divp_mask(pll) << pll->divp_shift));
 	val |= ((cfg->m << pll->divm_shift) |
 		(cfg->n << pll->divn_shift) |
-		(divp << pll->divp_shift));
-	if (val == old_base) {
-		if (pll->lock)
-			spin_unlock_irqrestore(pll->lock, flags);
-		return 0;
+		(cfg->p << pll->divp_shift));
+
+	pll_writel_base(val, pll);
+}
+
+static void _get_pll_mnp(struct tegra_clk_pll *pll,
+			 struct tegra_clk_pll_freq_table *cfg)
+{
+	u32 val;
+
+	val = pll_readl_base(pll);
+
+	cfg->m = (val >> pll->divm_shift) & (divm_mask(pll));
+	cfg->n = (val >> pll->divn_shift) & (divn_mask(pll));
+	cfg->p = (val >> pll->divp_shift) & (divp_mask(pll));
+}
+
+static void _update_pll_cpcon(struct tegra_clk_pll *pll,
+			      struct tegra_clk_pll_freq_table *cfg,
+			      unsigned long rate)
+{
+	u32 val;
+
+	val = pll_readl_misc(pll);
+
+	val &= ~(PLL_MISC_CPCON_MASK << PLL_MISC_CPCON_SHIFT);
+	val |= cfg->cpcon << PLL_MISC_CPCON_SHIFT;
+
+	if (pll->flags & TEGRA_PLL_SET_LFCON) {
+		val &= ~(PLL_MISC_LFCON_MASK << PLL_MISC_LFCON_SHIFT);
+		if (cfg->n >= PLLDU_LFCON_SET_DIVN)
+			val |= 1 << PLL_MISC_LFCON_SHIFT;
+	} else if (pll->flags & TEGRA_PLL_SET_DCCON) {
+		val &= ~(1 << PLL_MISC_DCCON_SHIFT);
+		if (rate >= (pll->params->vco_max >> 1))
+			val |= 1 << PLL_MISC_DCCON_SHIFT;
 	}
 
+	pll_writel_misc(val, pll);
+}
+
+static int _program_pll(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
+			unsigned long rate)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	int state, ret = 0;
+
 	state = clk_pll_is_enabled(hw);
 
-	if (state) {
+	if (state)
 		_clk_pll_disable(hw);
-		val &= ~(PLL_BASE_BYPASS | PLL_BASE_ENABLE);
-	}
-	pll_writel_base(val, pll);
 
-	if (pll->flags & TEGRA_PLL_HAS_CPCON) {
-		val = pll_readl_misc(pll);
-		val &= ~(PLL_MISC_CPCON_MASK << PLL_MISC_CPCON_SHIFT);
-		val |= cfg->cpcon << PLL_MISC_CPCON_SHIFT;
-		if (pll->flags & TEGRA_PLL_SET_LFCON) {
-			val &= ~(PLL_MISC_LFCON_MASK << PLL_MISC_LFCON_SHIFT);
-			if (cfg->n >= PLLDU_LFCON_SET_DIVN)
-				val |= 0x1 << PLL_MISC_LFCON_SHIFT;
-		} else if (pll->flags & TEGRA_PLL_SET_DCCON) {
-			val &= ~(0x1 << PLL_MISC_DCCON_SHIFT);
-			if (rate >= (pll->params->vco_max >> 1))
-				val |= 0x1 << PLL_MISC_DCCON_SHIFT;
-		}
-		pll_writel_misc(val, pll);
-	}
+	_update_pll_mnp(pll, cfg);
 
-	if (pll->lock)
-		spin_unlock_irqrestore(pll->lock, flags);
+	if (pll->flags & TEGRA_PLL_HAS_CPCON)
+		_update_pll_cpcon(pll, cfg, rate);
 
-	if (state)
-		clk_pll_enable(hw);
+	if (state) {
+		_clk_pll_enable(hw);
+		ret = clk_pll_wait_for_lock(pll);
+	}
 
-	return 0;
+	return ret;
 }
 
 static int clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 			unsigned long parent_rate)
 {
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
-	struct tegra_clk_pll_freq_table cfg;
+	struct tegra_clk_pll_freq_table cfg, old_cfg;
+	unsigned long flags = 0;
+	int ret = 0;
 
 	if (pll->flags & TEGRA_PLL_FIXED) {
 		if (rate != pll->fixed_rate) {
@@ -387,7 +406,18 @@ static int clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	    _calc_rate(hw, &cfg, rate, parent_rate))
 		return -EINVAL;
 
-	return _program_pll(hw, &cfg, rate);
+	if (pll->lock)
+		spin_lock_irqsave(pll->lock, flags);
+
+	_get_pll_mnp(pll, &old_cfg);
+
+	if (old_cfg.m != cfg.m || old_cfg.n != cfg.n || old_cfg.p != cfg.p)
+		ret = _program_pll(hw, &cfg, rate);
+
+	if (pll->lock)
+		spin_unlock_irqrestore(pll->lock, flags);
+
+	return ret;
 }
 
 static long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
@@ -409,7 +439,7 @@ static long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 		return -EINVAL;
 
 	output_rate *= cfg.n;
-	do_div(output_rate, cfg.m * cfg.p);
+	do_div(output_rate, cfg.m * (1 << cfg.p));
 
 	return output_rate;
 }
@@ -418,10 +448,12 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
 					 unsigned long parent_rate)
 {
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
-	u32 val = pll_readl_base(pll);
-	u32 divn = 0, divm = 0, divp = 0;
+	struct tegra_clk_pll_freq_table cfg;
+	u32 val;
 	u64 rate = parent_rate;
 
+	val = pll_readl_base(pll);
+
 	if (val & PLL_BASE_BYPASS)
 		return parent_rate;
 
@@ -435,16 +467,16 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
 		return pll->fixed_rate;
 	}
 
-	divp = (val >> pll->divp_shift) & (divp_mask(pll));
+	_get_pll_mnp(pll, &cfg);
+
 	if (pll->flags & TEGRA_PLLU)
-		divp ^= 1;
+		cfg.p ^= 1;
 
-	divn = (val >> pll->divn_shift) & (divn_mask(pll));
-	divm = (val >> pll->divm_shift) & (divm_mask(pll));
-	divm *= (1 << divp);
+	cfg.m *= 1 << cfg.p;
+
+	rate *= cfg.n;
+	do_div(rate, cfg.m);
 
-	rate *= divn;
-	do_div(rate, divm);
 	return rate;
 }
 
@@ -538,8 +570,8 @@ static int clk_plle_enable(struct clk_hw *hw)
 	val |= (PLL_BASE_BYPASS | PLL_BASE_ENABLE);
 	pll_writel_base(val, pll);
 
-	clk_pll_wait_for_lock(pll, pll->clk_base + pll->params->misc_reg,
-			      pll->params->lock_bit_idx);
+	clk_pll_wait_for_lock(pll);
+
 	return 0;
 }
 
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 5d41569..30bd3fd 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -247,125 +247,125 @@ static struct clk *clks[clk_max];
 static struct clk_onecell_data clk_data;
 
 static struct tegra_clk_pll_freq_table pll_c_freq_table[] = {
-	{ 12000000, 600000000, 600, 12, 1, 8 },
-	{ 13000000, 600000000, 600, 13, 1, 8 },
-	{ 19200000, 600000000, 500, 16, 1, 6 },
-	{ 26000000, 600000000, 600, 26, 1, 8 },
+	{ 12000000, 600000000, 600, 12, 0, 8 },
+	{ 13000000, 600000000, 600, 13, 0, 8 },
+	{ 19200000, 600000000, 500, 16, 0, 6 },
+	{ 26000000, 600000000, 600, 26, 0, 8 },
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
 static struct tegra_clk_pll_freq_table pll_m_freq_table[] = {
-	{ 12000000, 666000000, 666, 12, 1, 8},
-	{ 13000000, 666000000, 666, 13, 1, 8},
-	{ 19200000, 666000000, 555, 16, 1, 8},
-	{ 26000000, 666000000, 666, 26, 1, 8},
-	{ 12000000, 600000000, 600, 12, 1, 8},
-	{ 13000000, 600000000, 600, 13, 1, 8},
-	{ 19200000, 600000000, 375, 12, 1, 6},
-	{ 26000000, 600000000, 600, 26, 1, 8},
+	{ 12000000, 666000000, 666, 12, 0, 8},
+	{ 13000000, 666000000, 666, 13, 0, 8},
+	{ 19200000, 666000000, 555, 16, 0, 8},
+	{ 26000000, 666000000, 666, 26, 0, 8},
+	{ 12000000, 600000000, 600, 12, 0, 8},
+	{ 13000000, 600000000, 600, 13, 0, 8},
+	{ 19200000, 600000000, 375, 12, 0, 6},
+	{ 26000000, 600000000, 600, 26, 0, 8},
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
 static struct tegra_clk_pll_freq_table pll_p_freq_table[] = {
-	{ 12000000, 216000000, 432, 12, 2, 8},
-	{ 13000000, 216000000, 432, 13, 2, 8},
-	{ 19200000, 216000000, 90,   4, 2, 1},
-	{ 26000000, 216000000, 432, 26, 2, 8},
-	{ 12000000, 432000000, 432, 12, 1, 8},
-	{ 13000000, 432000000, 432, 13, 1, 8},
-	{ 19200000, 432000000, 90,   4, 1, 1},
-	{ 26000000, 432000000, 432, 26, 1, 8},
+	{ 12000000, 216000000, 432, 12, 1, 8},
+	{ 13000000, 216000000, 432, 13, 1, 8},
+	{ 19200000, 216000000, 90,   4, 1, 1},
+	{ 26000000, 216000000, 432, 26, 1, 8},
+	{ 12000000, 432000000, 432, 12, 0, 8},
+	{ 13000000, 432000000, 432, 13, 0, 8},
+	{ 19200000, 432000000, 90,   4, 0, 1},
+	{ 26000000, 432000000, 432, 26, 0, 8},
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
 static struct tegra_clk_pll_freq_table pll_a_freq_table[] = {
-	{ 28800000, 56448000, 49, 25, 1, 1},
-	{ 28800000, 73728000, 64, 25, 1, 1},
-	{ 28800000, 24000000,  5,  6, 1, 1},
+	{ 28800000, 56448000, 49, 25, 0, 1},
+	{ 28800000, 73728000, 64, 25, 0, 1},
+	{ 28800000, 24000000,  5,  6, 0, 1},
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
 static struct tegra_clk_pll_freq_table pll_d_freq_table[] = {
-	{ 12000000, 216000000, 216, 12, 1, 4},
-	{ 13000000, 216000000, 216, 13, 1, 4},
-	{ 19200000, 216000000, 135, 12, 1, 3},
-	{ 26000000, 216000000, 216, 26, 1, 4},
+	{ 12000000, 216000000, 216, 12, 0, 4},
+	{ 13000000, 216000000, 216, 13, 0, 4},
+	{ 19200000, 216000000, 135, 12, 0, 3},
+	{ 26000000, 216000000, 216, 26, 0, 4},
 
-	{ 12000000, 594000000, 594, 12, 1, 8},
-	{ 13000000, 594000000, 594, 13, 1, 8},
-	{ 19200000, 594000000, 495, 16, 1, 8},
-	{ 26000000, 594000000, 594, 26, 1, 8},
+	{ 12000000, 594000000, 594, 12, 0, 8},
+	{ 13000000, 594000000, 594, 13, 0, 8},
+	{ 19200000, 594000000, 495, 16, 0, 8},
+	{ 26000000, 594000000, 594, 26, 0, 8},
 
-	{ 12000000, 1000000000, 1000, 12, 1, 12},
-	{ 13000000, 1000000000, 1000, 13, 1, 12},
-	{ 19200000, 1000000000, 625,  12, 1, 8},
-	{ 26000000, 1000000000, 1000, 26, 1, 12},
+	{ 12000000, 1000000000, 1000, 12, 0, 12},
+	{ 13000000, 1000000000, 1000, 13, 0, 12},
+	{ 19200000, 1000000000, 625,  12, 0, 8},
+	{ 26000000, 1000000000, 1000, 26, 0, 12},
 
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
 static struct tegra_clk_pll_freq_table pll_u_freq_table[] = {
-	{ 12000000, 480000000, 960, 12, 2, 0},
-	{ 13000000, 480000000, 960, 13, 2, 0},
-	{ 19200000, 480000000, 200, 4,  2, 0},
-	{ 26000000, 480000000, 960, 26, 2, 0},
+	{ 12000000, 480000000, 960, 12, 0, 0},
+	{ 13000000, 480000000, 960, 13, 0, 0},
+	{ 19200000, 480000000, 200, 4,  0, 0},
+	{ 26000000, 480000000, 960, 26, 0, 0},
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
 static struct tegra_clk_pll_freq_table pll_x_freq_table[] = {
 	/* 1 GHz */
-	{ 12000000, 1000000000, 1000, 12, 1, 12},
-	{ 13000000, 1000000000, 1000, 13, 1, 12},
-	{ 19200000, 1000000000, 625,  12, 1, 8},
-	{ 26000000, 1000000000, 1000, 26, 1, 12},
+	{ 12000000, 1000000000, 1000, 12, 0, 12},
+	{ 13000000, 1000000000, 1000, 13, 0, 12},
+	{ 19200000, 1000000000, 625,  12, 0, 8},
+	{ 26000000, 1000000000, 1000, 26, 0, 12},
 
 	/* 912 MHz */
-	{ 12000000, 912000000,  912,  12, 1, 12},
-	{ 13000000, 912000000,  912,  13, 1, 12},
-	{ 19200000, 912000000,  760,  16, 1, 8},
-	{ 26000000, 912000000,  912,  26, 1, 12},
+	{ 12000000, 912000000,  912,  12, 0, 12},
+	{ 13000000, 912000000,  912,  13, 0, 12},
+	{ 19200000, 912000000,  760,  16, 0, 8},
+	{ 26000000, 912000000,  912,  26, 0, 12},
 
 	/* 816 MHz */
-	{ 12000000, 816000000,  816,  12, 1, 12},
-	{ 13000000, 816000000,  816,  13, 1, 12},
-	{ 19200000, 816000000,  680,  16, 1, 8},
-	{ 26000000, 816000000,  816,  26, 1, 12},
+	{ 12000000, 816000000,  816,  12, 0, 12},
+	{ 13000000, 816000000,  816,  13, 0, 12},
+	{ 19200000, 816000000,  680,  16, 0, 8},
+	{ 26000000, 816000000,  816,  26, 0, 12},
 
 	/* 760 MHz */
-	{ 12000000, 760000000,  760,  12, 1, 12},
-	{ 13000000, 760000000,  760,  13, 1, 12},
-	{ 19200000, 760000000,  950,  24, 1, 8},
-	{ 26000000, 760000000,  760,  26, 1, 12},
+	{ 12000000, 760000000,  760,  12, 0, 12},
+	{ 13000000, 760000000,  760,  13, 0, 12},
+	{ 19200000, 760000000,  950,  24, 0, 8},
+	{ 26000000, 760000000,  760,  26, 0, 12},
 
 	/* 750 MHz */
-	{ 12000000, 750000000,  750,  12, 1, 12},
-	{ 13000000, 750000000,  750,  13, 1, 12},
-	{ 19200000, 750000000,  625,  16, 1, 8},
-	{ 26000000, 750000000,  750,  26, 1, 12},
+	{ 12000000, 750000000,  750,  12, 0, 12},
+	{ 13000000, 750000000,  750,  13, 0, 12},
+	{ 19200000, 750000000,  625,  16, 0, 8},
+	{ 26000000, 750000000,  750,  26, 0, 12},
 
 	/* 608 MHz */
-	{ 12000000, 608000000,  608,  12, 1, 12},
-	{ 13000000, 608000000,  608,  13, 1, 12},
-	{ 19200000, 608000000,  380,  12, 1, 8},
-	{ 26000000, 608000000,  608,  26, 1, 12},
+	{ 12000000, 608000000,  608,  12, 0, 12},
+	{ 13000000, 608000000,  608,  13, 0, 12},
+	{ 19200000, 608000000,  380,  12, 0, 8},
+	{ 26000000, 608000000,  608,  26, 0, 12},
 
 	/* 456 MHz */
-	{ 12000000, 456000000,  456,  12, 1, 12},
-	{ 13000000, 456000000,  456,  13, 1, 12},
-	{ 19200000, 456000000,  380,  16, 1, 8},
-	{ 26000000, 456000000,  456,  26, 1, 12},
+	{ 12000000, 456000000,  456,  12, 0, 12},
+	{ 13000000, 456000000,  456,  13, 0, 12},
+	{ 19200000, 456000000,  380,  16, 0, 8},
+	{ 26000000, 456000000,  456,  26, 0, 12},
 
 	/* 312 MHz */
-	{ 12000000, 312000000,  312,  12, 1, 12},
-	{ 13000000, 312000000,  312,  13, 1, 12},
-	{ 19200000, 312000000,  260,  16, 1, 8},
-	{ 26000000, 312000000,  312,  26, 1, 12},
+	{ 12000000, 312000000,  312,  12, 0, 12},
+	{ 13000000, 312000000,  312,  13, 0, 12},
+	{ 19200000, 312000000,  260,  16, 0, 8},
+	{ 26000000, 312000000,  312,  26, 0, 12},
 
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
 static struct tegra_clk_pll_freq_table pll_e_freq_table[] = {
-	{ 12000000, 100000000,  200,  24, 1, 0 },
+	{ 12000000, 100000000,  200,  24, 0, 0 },
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index a163812..28a2997 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -373,164 +373,164 @@ static const struct utmi_clk_param utmi_parameters[] = {
 };
 
 static struct tegra_clk_pll_freq_table pll_c_freq_table[] = {
-	{ 12000000, 1040000000, 520,  6, 1, 8},
-	{ 13000000, 1040000000, 480,  6, 1, 8},
-	{ 16800000, 1040000000, 495,  8, 1, 8},	/* actual: 1039.5 MHz */
-	{ 19200000, 1040000000, 325,  6, 1, 6},
-	{ 26000000, 1040000000, 520, 13, 1, 8},
-
-	{ 12000000, 832000000, 416,  6, 1, 8},
-	{ 13000000, 832000000, 832, 13, 1, 8},
-	{ 16800000, 832000000, 396,  8, 1, 8},	/* actual: 831.6 MHz */
-	{ 19200000, 832000000, 260,  6, 1, 8},
-	{ 26000000, 832000000, 416, 13, 1, 8},
-
-	{ 12000000, 624000000, 624, 12, 1, 8},
-	{ 13000000, 624000000, 624, 13, 1, 8},
-	{ 16800000, 600000000, 520, 14, 1, 8},
-	{ 19200000, 624000000, 520, 16, 1, 8},
-	{ 26000000, 624000000, 624, 26, 1, 8},
-
-	{ 12000000, 600000000, 600, 12, 1, 8},
-	{ 13000000, 600000000, 600, 13, 1, 8},
-	{ 16800000, 600000000, 500, 14, 1, 8},
-	{ 19200000, 600000000, 375, 12, 1, 6},
-	{ 26000000, 600000000, 600, 26, 1, 8},
-
-	{ 12000000, 520000000, 520, 12, 1, 8},
-	{ 13000000, 520000000, 520, 13, 1, 8},
-	{ 16800000, 520000000, 495, 16, 1, 8},	/* actual: 519.75 MHz */
-	{ 19200000, 520000000, 325, 12, 1, 6},
-	{ 26000000, 520000000, 520, 26, 1, 8},
-
-	{ 12000000, 416000000, 416, 12, 1, 8},
-	{ 13000000, 416000000, 416, 13, 1, 8},
-	{ 16800000, 416000000, 396, 16, 1, 8},	/* actual: 415.8 MHz */
-	{ 19200000, 416000000, 260, 12, 1, 6},
-	{ 26000000, 416000000, 416, 26, 1, 8},
+	{ 12000000, 1040000000, 520,  6, 0, 8},
+	{ 13000000, 1040000000, 480,  6, 0, 8},
+	{ 16800000, 1040000000, 495,  8, 0, 8},	/* actual: 1039.5 MHz */
+	{ 19200000, 1040000000, 325,  6, 0, 6},
+	{ 26000000, 1040000000, 520, 13, 0, 8},
+
+	{ 12000000, 832000000, 416,  6, 0, 8},
+	{ 13000000, 832000000, 832, 13, 0, 8},
+	{ 16800000, 832000000, 396,  8, 0, 8},	/* actual: 831.6 MHz */
+	{ 19200000, 832000000, 260,  6, 0, 8},
+	{ 26000000, 832000000, 416, 13, 0, 8},
+
+	{ 12000000, 624000000, 624, 12, 0, 8},
+	{ 13000000, 624000000, 624, 13, 0, 8},
+	{ 16800000, 600000000, 520, 14, 0, 8},
+	{ 19200000, 624000000, 520, 16, 0, 8},
+	{ 26000000, 624000000, 624, 26, 0, 8},
+
+	{ 12000000, 600000000, 600, 12, 0, 8},
+	{ 13000000, 600000000, 600, 13, 0, 8},
+	{ 16800000, 600000000, 500, 14, 0, 8},
+	{ 19200000, 600000000, 375, 12, 0, 6},
+	{ 26000000, 600000000, 600, 26, 0, 8},
+
+	{ 12000000, 520000000, 520, 12, 0, 8},
+	{ 13000000, 520000000, 520, 13, 0, 8},
+	{ 16800000, 520000000, 495, 16, 0, 8},	/* actual: 519.75 MHz */
+	{ 19200000, 520000000, 325, 12, 0, 6},
+	{ 26000000, 520000000, 520, 26, 0, 8},
+
+	{ 12000000, 416000000, 416, 12, 0, 8},
+	{ 13000000, 416000000, 416, 13, 0, 8},
+	{ 16800000, 416000000, 396, 16, 0, 8},	/* actual: 415.8 MHz */
+	{ 19200000, 416000000, 260, 12, 0, 6},
+	{ 26000000, 416000000, 416, 26, 0, 8},
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
 static struct tegra_clk_pll_freq_table pll_m_freq_table[] = {
-	{ 12000000, 666000000, 666, 12, 1, 8},
-	{ 13000000, 666000000, 666, 13, 1, 8},
-	{ 16800000, 666000000, 555, 14, 1, 8},
-	{ 19200000, 666000000, 555, 16, 1, 8},
-	{ 26000000, 666000000, 666, 26, 1, 8},
-	{ 12000000, 600000000, 600, 12, 1, 8},
-	{ 13000000, 600000000, 600, 13, 1, 8},
-	{ 16800000, 600000000, 500, 14, 1, 8},
-	{ 19200000, 600000000, 375, 12, 1, 6},
-	{ 26000000, 600000000, 600, 26, 1, 8},
+	{ 12000000, 666000000, 666, 12, 0, 8},
+	{ 13000000, 666000000, 666, 13, 0, 8},
+	{ 16800000, 666000000, 555, 14, 0, 8},
+	{ 19200000, 666000000, 555, 16, 0, 8},
+	{ 26000000, 666000000, 666, 26, 0, 8},
+	{ 12000000, 600000000, 600, 12, 0, 8},
+	{ 13000000, 600000000, 600, 13, 0, 8},
+	{ 16800000, 600000000, 500, 14, 0, 8},
+	{ 19200000, 600000000, 375, 12, 0, 6},
+	{ 26000000, 600000000, 600, 26, 0, 8},
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
 static struct tegra_clk_pll_freq_table pll_p_freq_table[] = {
-	{ 12000000, 216000000, 432, 12, 2, 8},
-	{ 13000000, 216000000, 432, 13, 2, 8},
-	{ 16800000, 216000000, 360, 14, 2, 8},
-	{ 19200000, 216000000, 360, 16, 2, 8},
-	{ 26000000, 216000000, 432, 26, 2, 8},
+	{ 12000000, 216000000, 432, 12, 1, 8},
+	{ 13000000, 216000000, 432, 13, 1, 8},
+	{ 16800000, 216000000, 360, 14, 1, 8},
+	{ 19200000, 216000000, 360, 16, 1, 8},
+	{ 26000000, 216000000, 432, 26, 1, 8},
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
 static struct tegra_clk_pll_freq_table pll_a_freq_table[] = {
-	{ 9600000, 564480000, 294, 5, 1, 4},
-	{ 9600000, 552960000, 288, 5, 1, 4},
-	{ 9600000, 24000000,  5,   2, 1, 1},
+	{ 9600000, 564480000, 294, 5, 0, 4},
+	{ 9600000, 552960000, 288, 5, 0, 4},
+	{ 9600000, 24000000,  5,   2, 0, 1},
 
-	{ 28800000, 56448000, 49, 25, 1, 1},
-	{ 28800000, 73728000, 64, 25, 1, 1},
-	{ 28800000, 24000000,  5,  6, 1, 1},
+	{ 28800000, 56448000, 49, 25, 0, 1},
+	{ 28800000, 73728000, 64, 25, 0, 1},
+	{ 28800000, 24000000,  5,  6, 0, 1},
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
 static struct tegra_clk_pll_freq_table pll_d_freq_table[] = {
-	{ 12000000, 216000000, 216, 12, 1, 4},
-	{ 13000000, 216000000, 216, 13, 1, 4},
-	{ 16800000, 216000000, 180, 14, 1, 4},
-	{ 19200000, 216000000, 180, 16, 1, 4},
-	{ 26000000, 216000000, 216, 26, 1, 4},
-
-	{ 12000000, 594000000, 594, 12, 1, 8},
-	{ 13000000, 594000000, 594, 13, 1, 8},
-	{ 16800000, 594000000, 495, 14, 1, 8},
-	{ 19200000, 594000000, 495, 16, 1, 8},
-	{ 26000000, 594000000, 594, 26, 1, 8},
-
-	{ 12000000, 1000000000, 1000, 12, 1, 12},
-	{ 13000000, 1000000000, 1000, 13, 1, 12},
-	{ 19200000, 1000000000, 625,  12, 1, 8},
-	{ 26000000, 1000000000, 1000, 26, 1, 12},
+	{ 12000000, 216000000, 216, 12, 0, 4},
+	{ 13000000, 216000000, 216, 13, 0, 4},
+	{ 16800000, 216000000, 180, 14, 0, 4},
+	{ 19200000, 216000000, 180, 16, 0, 4},
+	{ 26000000, 216000000, 216, 26, 0, 4},
+
+	{ 12000000, 594000000, 594, 12, 0, 8},
+	{ 13000000, 594000000, 594, 13, 0, 8},
+	{ 16800000, 594000000, 495, 14, 0, 8},
+	{ 19200000, 594000000, 495, 16, 0, 8},
+	{ 26000000, 594000000, 594, 26, 0, 8},
+
+	{ 12000000, 1000000000, 1000, 12, 0, 12},
+	{ 13000000, 1000000000, 1000, 13, 0, 12},
+	{ 19200000, 1000000000, 625,  12, 0, 8},
+	{ 26000000, 1000000000, 1000, 26, 0, 12},
 
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
 static struct tegra_clk_pll_freq_table pll_u_freq_table[] = {
-	{ 12000000, 480000000, 960, 12, 2, 12},
-	{ 13000000, 480000000, 960, 13, 2, 12},
-	{ 16800000, 480000000, 400, 7,  2, 5},
-	{ 19200000, 480000000, 200, 4,  2, 3},
-	{ 26000000, 480000000, 960, 26, 2, 12},
+	{ 12000000, 480000000, 960, 12, 0, 12},
+	{ 13000000, 480000000, 960, 13, 0, 12},
+	{ 16800000, 480000000, 400, 7,  0, 5},
+	{ 19200000, 480000000, 200, 4,  0, 3},
+	{ 26000000, 480000000, 960, 26, 0, 12},
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
 static struct tegra_clk_pll_freq_table pll_x_freq_table[] = {
 	/* 1.7 GHz */
-	{ 12000000, 1700000000, 850,  6,  1, 8},
-	{ 13000000, 1700000000, 915,  7,  1, 8},	/* actual: 1699.2 MHz */
-	{ 16800000, 1700000000, 708,  7,  1, 8},	/* actual: 1699.2 MHz */
-	{ 19200000, 1700000000, 885,  10, 1, 8},	/* actual: 1699.2 MHz */
-	{ 26000000, 1700000000, 850,  13, 1, 8},
+	{ 12000000, 1700000000, 850,  6,  0, 8},
+	{ 13000000, 1700000000, 915,  7,  0, 8},	/* actual: 1699.2 MHz */
+	{ 16800000, 1700000000, 708,  7,  0, 8},	/* actual: 1699.2 MHz */
+	{ 19200000, 1700000000, 885,  10, 0, 8},	/* actual: 1699.2 MHz */
+	{ 26000000, 1700000000, 850,  13, 0, 8},
 
 	/* 1.6 GHz */
-	{ 12000000, 1600000000, 800,  6,  1, 8},
-	{ 13000000, 1600000000, 738,  6,  1, 8},	/* actual: 1599.0 MHz */
-	{ 16800000, 1600000000, 857,  9,  1, 8},	/* actual: 1599.7 MHz */
-	{ 19200000, 1600000000, 500,  6,  1, 8},
-	{ 26000000, 1600000000, 800,  13, 1, 8},
+	{ 12000000, 1600000000, 800,  6,  0, 8},
+	{ 13000000, 1600000000, 738,  6,  0, 8},	/* actual: 1599.0 MHz */
+	{ 16800000, 1600000000, 857,  9,  0, 8},	/* actual: 1599.7 MHz */
+	{ 19200000, 1600000000, 500,  6,  0, 8},
+	{ 26000000, 1600000000, 800,  13, 0, 8},
 
 	/* 1.5 GHz */
-	{ 12000000, 1500000000, 750,  6,  1, 8},
-	{ 13000000, 1500000000, 923,  8,  1, 8},	/* actual: 1499.8 MHz */
-	{ 16800000, 1500000000, 625,  7,  1, 8},
-	{ 19200000, 1500000000, 625,  8,  1, 8},
-	{ 26000000, 1500000000, 750,  13, 1, 8},
+	{ 12000000, 1500000000, 750,  6,  0, 8},
+	{ 13000000, 1500000000, 923,  8,  0, 8},	/* actual: 1499.8 MHz */
+	{ 16800000, 1500000000, 625,  7,  0, 8},
+	{ 19200000, 1500000000, 625,  8,  0, 8},
+	{ 26000000, 1500000000, 750,  13, 0, 8},
 
 	/* 1.4 GHz */
-	{ 12000000, 1400000000, 700,  6,  1, 8},
-	{ 13000000, 1400000000, 969,  9,  1, 8},	/* actual: 1399.7 MHz */
-	{ 16800000, 1400000000, 1000, 12, 1, 8},
-	{ 19200000, 1400000000, 875,  12, 1, 8},
-	{ 26000000, 1400000000, 700,  13, 1, 8},
+	{ 12000000, 1400000000, 700,  6,  0, 8},
+	{ 13000000, 1400000000, 969,  9,  0, 8},	/* actual: 1399.7 MHz */
+	{ 16800000, 1400000000, 1000, 12, 0, 8},
+	{ 19200000, 1400000000, 875,  12, 0, 8},
+	{ 26000000, 1400000000, 700,  13, 0, 8},
 
 	/* 1.3 GHz */
-	{ 12000000, 1300000000, 975,  9,  1, 8},
-	{ 13000000, 1300000000, 1000, 10, 1, 8},
-	{ 16800000, 1300000000, 928,  12, 1, 8},	/* actual: 1299.2 MHz */
-	{ 19200000, 1300000000, 812,  12, 1, 8},	/* actual: 1299.2 MHz */
-	{ 26000000, 1300000000, 650,  13, 1, 8},
+	{ 12000000, 1300000000, 975,  9,  0, 8},
+	{ 13000000, 1300000000, 1000, 10, 0, 8},
+	{ 16800000, 1300000000, 928,  12, 0, 8},	/* actual: 1299.2 MHz */
+	{ 19200000, 1300000000, 812,  12, 0, 8},	/* actual: 1299.2 MHz */
+	{ 26000000, 1300000000, 650,  13, 0, 8},
 
 	/* 1.2 GHz */
-	{ 12000000, 1200000000, 1000, 10, 1, 8},
-	{ 13000000, 1200000000, 923,  10, 1, 8},	/* actual: 1199.9 MHz */
-	{ 16800000, 1200000000, 1000, 14, 1, 8},
-	{ 19200000, 1200000000, 1000, 16, 1, 8},
-	{ 26000000, 1200000000, 600,  13, 1, 8},
+	{ 12000000, 1200000000, 1000, 10, 0, 8},
+	{ 13000000, 1200000000, 923,  10, 0, 8},	/* actual: 1199.9 MHz */
+	{ 16800000, 1200000000, 1000, 14, 0, 8},
+	{ 19200000, 1200000000, 1000, 16, 0, 8},
+	{ 26000000, 1200000000, 600,  13, 0, 8},
 
 	/* 1.1 GHz */
-	{ 12000000, 1100000000, 825,  9,  1, 8},
-	{ 13000000, 1100000000, 846,  10, 1, 8},	/* actual: 1099.8 MHz */
-	{ 16800000, 1100000000, 982,  15, 1, 8},	/* actual: 1099.8 MHz */
-	{ 19200000, 1100000000, 859,  15, 1, 8},	/* actual: 1099.5 MHz */
-	{ 26000000, 1100000000, 550,  13, 1, 8},
+	{ 12000000, 1100000000, 825,  9,  0, 8},
+	{ 13000000, 1100000000, 846,  10, 0, 8},	/* actual: 1099.8 MHz */
+	{ 16800000, 1100000000, 982,  15, 0, 8},	/* actual: 1099.8 MHz */
+	{ 19200000, 1100000000, 859,  15, 0, 8},	/* actual: 1099.5 MHz */
+	{ 26000000, 1100000000, 550,  13, 0, 8},
 
 	/* 1 GHz */
-	{ 12000000, 1000000000, 1000, 12, 1, 8},
-	{ 13000000, 1000000000, 1000, 13, 1, 8},
-	{ 16800000, 1000000000, 833,  14, 1, 8},	/* actual: 999.6 MHz */
-	{ 19200000, 1000000000, 625,  12, 1, 8},
-	{ 26000000, 1000000000, 1000, 26, 1, 8},
+	{ 12000000, 1000000000, 1000, 12, 0, 8},
+	{ 13000000, 1000000000, 1000, 13, 0, 8},
+	{ 16800000, 1000000000, 833,  14, 0, 8},	/* actual: 999.6 MHz */
+	{ 19200000, 1000000000, 625,  12, 0, 8},
+	{ 26000000, 1000000000, 1000, 26, 0, 8},
 
 	{ 0, 0, 0, 0, 0, 0 },
 };

