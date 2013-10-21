Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3JUN4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:56:20 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19467 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab3JUN4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:56:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Oct 2013 06:51:39 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 06/15] clk: tegra: move fields to tegra_clk_pll_params
Date: Mon, 21 Oct 2013 16:53:45 +0300
Message-ID: <1382363634-10870-7-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382363634-10870-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382363634-10870-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move some fields related to the PLL HW description to the tegra_clk_pll_params.
This allows some PLL code to be moved to common files later.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c      |  138 ++++++++++++++++----------------------
 drivers/clk/tegra/clk-tegra114.c |   74 ++++++++++++---------
 drivers/clk/tegra/clk-tegra20.c  |   44 ++++++++-----
 drivers/clk/tegra/clk-tegra30.c  |   62 ++++++++++--------
 drivers/clk/tegra/clk.h          |   34 +++------
 5 files changed, 175 insertions(+), 177 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 0baabb0..0550a43 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -150,7 +150,7 @@
 #define mask(w) ((1 << (w)) - 1)
 #define divm_mask(p) mask(p->params->div_nmp->divm_width)
 #define divn_mask(p) mask(p->params->div_nmp->divn_width)
-#define divp_mask(p) (p->flags & TEGRA_PLLU ? PLLU_POST_DIVP_MASK :	\
+#define divp_mask(p) (p->params->flags & TEGRA_PLLU ? PLLU_POST_DIVP_MASK :\
 		      mask(p->params->div_nmp->divp_width))
 
 #define divm_max(p) (divm_mask(p))
@@ -170,10 +170,10 @@ static void clk_pll_enable_lock(struct tegra_clk_pll *pll)
 {
 	u32 val;
 
-	if (!(pll->flags & TEGRA_PLL_USE_LOCK))
+	if (!(pll->params->flags & TEGRA_PLL_USE_LOCK))
 		return;
 
-	if (!(pll->flags & TEGRA_PLL_HAS_LOCK_ENABLE))
+	if (!(pll->params->flags & TEGRA_PLL_HAS_LOCK_ENABLE))
 		return;
 
 	val = pll_readl_misc(pll);
@@ -187,13 +187,13 @@ static int clk_pll_wait_for_lock(struct tegra_clk_pll *pll)
 	u32 val, lock_mask;
 	void __iomem *lock_addr;
 
-	if (!(pll->flags & TEGRA_PLL_USE_LOCK)) {
+	if (!(pll->params->flags & TEGRA_PLL_USE_LOCK)) {
 		udelay(pll->params->lock_delay);
 		return 0;
 	}
 
 	lock_addr = pll->clk_base;
-	if (pll->flags & TEGRA_PLL_LOCK_MISC)
+	if (pll->params->flags & TEGRA_PLL_LOCK_MISC)
 		lock_addr += pll->params->misc_reg;
 	else
 		lock_addr += pll->params->base_reg;
@@ -220,7 +220,7 @@ static int clk_pll_is_enabled(struct clk_hw *hw)
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
 	u32 val;
 
-	if (pll->flags & TEGRA_PLLM) {
+	if (pll->params->flags & TEGRA_PLLM) {
 		val = readl_relaxed(pll->pmc + PMC_PLLP_WB0_OVERRIDE);
 		if (val & PMC_PLLP_WB0_OVERRIDE_PLLM_OVERRIDE)
 			return val & PMC_PLLP_WB0_OVERRIDE_PLLM_ENABLE ? 1 : 0;
@@ -239,12 +239,12 @@ static void _clk_pll_enable(struct clk_hw *hw)
 	clk_pll_enable_lock(pll);
 
 	val = pll_readl_base(pll);
-	if (pll->flags & TEGRA_PLL_BYPASS)
+	if (pll->params->flags & TEGRA_PLL_BYPASS)
 		val &= ~PLL_BASE_BYPASS;
 	val |= PLL_BASE_ENABLE;
 	pll_writel_base(val, pll);
 
-	if (pll->flags & TEGRA_PLLM) {
+	if (pll->params->flags & TEGRA_PLLM) {
 		val = readl_relaxed(pll->pmc + PMC_PLLP_WB0_OVERRIDE);
 		val |= PMC_PLLP_WB0_OVERRIDE_PLLM_ENABLE;
 		writel_relaxed(val, pll->pmc + PMC_PLLP_WB0_OVERRIDE);
@@ -257,12 +257,12 @@ static void _clk_pll_disable(struct clk_hw *hw)
 	u32 val;
 
 	val = pll_readl_base(pll);
-	if (pll->flags & TEGRA_PLL_BYPASS)
+	if (pll->params->flags & TEGRA_PLL_BYPASS)
 		val &= ~PLL_BASE_BYPASS;
 	val &= ~PLL_BASE_ENABLE;
 	pll_writel_base(val, pll);
 
-	if (pll->flags & TEGRA_PLLM) {
+	if (pll->params->flags & TEGRA_PLLM) {
 		val = readl_relaxed(pll->pmc + PMC_PLLP_WB0_OVERRIDE);
 		val &= ~PMC_PLLP_WB0_OVERRIDE_PLLM_ENABLE;
 		writel_relaxed(val, pll->pmc + PMC_PLLP_WB0_OVERRIDE);
@@ -342,7 +342,7 @@ static int _get_table_rate(struct clk_hw *hw,
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
 	struct tegra_clk_pll_freq_table *sel;
 
-	for (sel = pll->freq_table; sel->input_rate != 0; sel++)
+	for (sel = pll->params->freq_table; sel->input_rate != 0; sel++)
 		if (sel->input_rate == parent_rate &&
 		    sel->output_rate == rate)
 			break;
@@ -430,7 +430,7 @@ static void _update_pll_mnp(struct tegra_clk_pll *pll,
 	struct tegra_clk_pll_params *params = pll->params;
 	struct div_nmp *div_nmp = params->div_nmp;
 
-	if ((pll->flags & TEGRA_PLLM) &&
+	if ((params->flags & TEGRA_PLLM) &&
 		(pll_override_readl(PMC_PLLP_WB0_OVERRIDE, pll) &
 			PMC_PLLP_WB0_OVERRIDE_PLLM_OVERRIDE)) {
 		val = pll_override_readl(params->pmc_divp_reg, pll);
@@ -466,7 +466,7 @@ static void _get_pll_mnp(struct tegra_clk_pll *pll,
 	struct tegra_clk_pll_params *params = pll->params;
 	struct div_nmp *div_nmp = params->div_nmp;
 
-	if ((pll->flags & TEGRA_PLLM) &&
+	if ((params->flags & TEGRA_PLLM) &&
 		(pll_override_readl(PMC_PLLP_WB0_OVERRIDE, pll) &
 			PMC_PLLP_WB0_OVERRIDE_PLLM_OVERRIDE)) {
 		val = pll_override_readl(params->pmc_divp_reg, pll);
@@ -495,11 +495,11 @@ static void _update_pll_cpcon(struct tegra_clk_pll *pll,
 	val &= ~(PLL_MISC_CPCON_MASK << PLL_MISC_CPCON_SHIFT);
 	val |= cfg->cpcon << PLL_MISC_CPCON_SHIFT;
 
-	if (pll->flags & TEGRA_PLL_SET_LFCON) {
+	if (pll->params->flags & TEGRA_PLL_SET_LFCON) {
 		val &= ~(PLL_MISC_LFCON_MASK << PLL_MISC_LFCON_SHIFT);
 		if (cfg->n >= PLLDU_LFCON_SET_DIVN)
 			val |= 1 << PLL_MISC_LFCON_SHIFT;
-	} else if (pll->flags & TEGRA_PLL_SET_DCCON) {
+	} else if (pll->params->flags & TEGRA_PLL_SET_DCCON) {
 		val &= ~(1 << PLL_MISC_DCCON_SHIFT);
 		if (rate >= (pll->params->vco_max >> 1))
 			val |= 1 << PLL_MISC_DCCON_SHIFT;
@@ -521,7 +521,7 @@ static int _program_pll(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
 
 	_update_pll_mnp(pll, cfg);
 
-	if (pll->flags & TEGRA_PLL_HAS_CPCON)
+	if (pll->params->flags & TEGRA_PLL_HAS_CPCON)
 		_update_pll_cpcon(pll, cfg, rate);
 
 	if (state) {
@@ -540,11 +540,11 @@ static int clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	unsigned long flags = 0;
 	int ret = 0;
 
-	if (pll->flags & TEGRA_PLL_FIXED) {
-		if (rate != pll->fixed_rate) {
+	if (pll->params->flags & TEGRA_PLL_FIXED) {
+		if (rate != pll->params->fixed_rate) {
 			pr_err("%s: Can not change %s fixed rate %lu to %lu\n",
 				__func__, __clk_get_name(hw->clk),
-				pll->fixed_rate, rate);
+				pll->params->fixed_rate, rate);
 			return -EINVAL;
 		}
 		return 0;
@@ -575,11 +575,11 @@ static long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
 	struct tegra_clk_pll_freq_table cfg;
 
-	if (pll->flags & TEGRA_PLL_FIXED)
-		return pll->fixed_rate;
+	if (pll->params->flags & TEGRA_PLL_FIXED)
+		return pll->params->fixed_rate;
 
 	/* PLLM is used for memory; we do not change rate */
-	if (pll->flags & TEGRA_PLLM)
+	if (pll->params->flags & TEGRA_PLLM)
 		return __clk_get_rate(hw->clk);
 
 	if (_get_table_rate(hw, &cfg, rate, *prate) &&
@@ -602,17 +602,19 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
 
 	val = pll_readl_base(pll);
 
-	if ((pll->flags & TEGRA_PLL_BYPASS) && (val & PLL_BASE_BYPASS))
+	if ((pll->params->flags & TEGRA_PLL_BYPASS) && (val & PLL_BASE_BYPASS))
 		return parent_rate;
 
-	if ((pll->flags & TEGRA_PLL_FIXED) && !(val & PLL_BASE_OVERRIDE)) {
+	if ((pll->params->flags & TEGRA_PLL_FIXED) &&
+			!(val & PLL_BASE_OVERRIDE)) {
 		struct tegra_clk_pll_freq_table sel;
-		if (_get_table_rate(hw, &sel, pll->fixed_rate, parent_rate)) {
+		if (_get_table_rate(hw, &sel, pll->params->fixed_rate,
+					parent_rate)) {
 			pr_err("Clock %s has unknown fixed frequency\n",
 			       __clk_get_name(hw->clk));
 			BUG();
 		}
-		return pll->fixed_rate;
+		return pll->params->fixed_rate;
 	}
 
 	_get_pll_mnp(pll, &cfg);
@@ -680,7 +682,7 @@ static int clk_plle_enable(struct clk_hw *hw)
 	u32 val;
 	int err;
 
-	if (_get_table_rate(hw, &sel, pll->fixed_rate, input_rate))
+	if (_get_table_rate(hw, &sel, pll->params->fixed_rate, input_rate))
 		return -EINVAL;
 
 	clk_pll_disable(hw);
@@ -696,7 +698,7 @@ static int clk_plle_enable(struct clk_hw *hw)
 			return err;
 	}
 
-	if (pll->flags & TEGRA_PLLE_CONFIGURE) {
+	if (pll->params->flags & TEGRA_PLLE_CONFIGURE) {
 		/* configure dividers */
 		val = pll_readl_base(pll);
 		val &= ~(divm_mask(pll) | divn_mask(pll) | divp_mask(pll));
@@ -1231,7 +1233,7 @@ static int clk_plle_tegra114_enable(struct clk_hw *hw)
 	unsigned long flags = 0;
 	unsigned long input_rate = clk_get_rate(clk_get_parent(hw->clk));
 
-	if (_get_table_rate(hw, &sel, pll->fixed_rate, input_rate))
+	if (_get_table_rate(hw, &sel, pll->params->fixed_rate, input_rate))
 		return -EINVAL;
 
 	if (pll->lock)
@@ -1318,9 +1320,8 @@ static void clk_plle_tegra114_disable(struct clk_hw *hw)
 #endif
 
 static struct tegra_clk_pll *_tegra_init_pll(void __iomem *clk_base,
-		void __iomem *pmc, unsigned long fixed_rate,
-		struct tegra_clk_pll_params *pll_params, u32 pll_flags,
-		struct tegra_clk_pll_freq_table *freq_table, spinlock_t *lock)
+		void __iomem *pmc, struct tegra_clk_pll_params *pll_params,
+		spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
 
@@ -1331,10 +1332,7 @@ static struct tegra_clk_pll *_tegra_init_pll(void __iomem *clk_base,
 	pll->clk_base = clk_base;
 	pll->pmc = pmc;
 
-	pll->freq_table = freq_table;
 	pll->params = pll_params;
-	pll->fixed_rate = fixed_rate;
-	pll->flags = pll_flags;
 	pll->lock = lock;
 
 	if (!pll_params->div_nmp)
@@ -1363,17 +1361,15 @@ static struct clk *_tegra_clk_register_pll(struct tegra_clk_pll *pll,
 
 struct clk *tegra_clk_register_pll(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
-		unsigned long flags, unsigned long fixed_rate,
-		struct tegra_clk_pll_params *pll_params, u32 pll_flags,
-		struct tegra_clk_pll_freq_table *freq_table, spinlock_t *lock)
+		unsigned long flags, struct tegra_clk_pll_params *pll_params,
+		spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
 	struct clk *clk;
 
-	pll_flags |= TEGRA_PLL_BYPASS;
-	pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
-	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
-			      freq_table, lock);
+	pll_params->flags |= TEGRA_PLL_BYPASS;
+	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
+	pll = _tegra_init_pll(clk_base, pmc, pll_params, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
@@ -1387,17 +1383,15 @@ struct clk *tegra_clk_register_pll(const char *name, const char *parent_name,
 
 struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
-		unsigned long flags, unsigned long fixed_rate,
-		struct tegra_clk_pll_params *pll_params, u32 pll_flags,
-		struct tegra_clk_pll_freq_table *freq_table, spinlock_t *lock)
+		unsigned long flags, struct tegra_clk_pll_params *pll_params,
+		spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
 	struct clk *clk;
 
-	pll_flags |= TEGRA_PLL_LOCK_MISC | TEGRA_PLL_BYPASS;
-	pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
-	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
-			      freq_table, lock);
+	pll_params->flags |= TEGRA_PLL_LOCK_MISC | TEGRA_PLL_BYPASS;
+	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
+	pll = _tegra_init_pll(clk_base, pmc, pll_params, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
@@ -1456,10 +1450,8 @@ const struct clk_ops tegra_clk_plle_tegra114_ops = {
 
 struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
 			  void __iomem *clk_base, void __iomem *pmc,
-			  unsigned long flags, unsigned long fixed_rate,
+			  unsigned long flags,
 			  struct tegra_clk_pll_params *pll_params,
-			  u32 pll_flags,
-			  struct tegra_clk_pll_freq_table *freq_table,
 			  spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
@@ -1496,9 +1488,8 @@ struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
 		writel_relaxed(val_iddq, clk_base + pll_params->iddq_reg);
 	}
 
-	pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
-	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
-			      freq_table, lock);
+	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
+	pll = _tegra_init_pll(clk_base, pmc, pll_params, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
@@ -1512,22 +1503,19 @@ struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
 
 struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
 			  void __iomem *clk_base, void __iomem *pmc,
-			  unsigned long flags, unsigned long fixed_rate,
+			  unsigned long flags,
 			  struct tegra_clk_pll_params *pll_params,
-			  u32 pll_flags,
-			  struct tegra_clk_pll_freq_table *freq_table,
 			  spinlock_t *lock, unsigned long parent_rate)
 {
 	u32 val;
 	struct tegra_clk_pll *pll;
 	struct clk *clk;
 
-	pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE | TEGRA_PLL_LOCK_MISC;
+	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE | TEGRA_PLL_LOCK_MISC;
 
 	pll_params->vco_min = _clip_vco_min(pll_params->vco_min, parent_rate);
 
-	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
-			      freq_table, lock);
+	pll = _tegra_init_pll(clk_base, pmc, pll_params, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
@@ -1562,10 +1550,8 @@ struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
 
 struct clk *tegra_clk_register_pllm(const char *name, const char *parent_name,
 			  void __iomem *clk_base, void __iomem *pmc,
-			  unsigned long flags, unsigned long fixed_rate,
+			  unsigned long flags,
 			  struct tegra_clk_pll_params *pll_params,
-			  u32 pll_flags,
-			  struct tegra_clk_pll_freq_table *freq_table,
 			  spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
@@ -1586,11 +1572,10 @@ struct clk *tegra_clk_register_pllm(const char *name, const char *parent_name,
 
 	pll_params->vco_min = _clip_vco_min(pll_params->vco_min, parent_rate);
 
-	pll_flags |= TEGRA_PLL_BYPASS;
-	pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
-	pll_flags |= TEGRA_PLLM;
-	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
-			      freq_table, lock);
+	pll_params->flags |= TEGRA_PLL_BYPASS;
+	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
+	pll_params->flags |= TEGRA_PLLM;
+	pll = _tegra_init_pll(clk_base, pmc, pll_params, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
@@ -1604,10 +1589,8 @@ struct clk *tegra_clk_register_pllm(const char *name, const char *parent_name,
 
 struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
 			  void __iomem *clk_base, void __iomem *pmc,
-			  unsigned long flags, unsigned long fixed_rate,
+			  unsigned long flags,
 			  struct tegra_clk_pll_params *pll_params,
-			  u32 pll_flags,
-			  struct tegra_clk_pll_freq_table *freq_table,
 			  spinlock_t *lock)
 {
 	struct clk *parent, *clk;
@@ -1630,9 +1613,8 @@ struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
 
 	pll_params->vco_min = _clip_vco_min(pll_params->vco_min, parent_rate);
 
-	pll_flags |= TEGRA_PLL_BYPASS;
-	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
-			      freq_table, lock);
+	pll_params->flags |= TEGRA_PLL_BYPASS;
+	pll = _tegra_init_pll(clk_base, pmc, pll_params, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
@@ -1682,17 +1664,15 @@ struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
 struct clk *tegra_clk_register_plle_tegra114(const char *name,
 				const char *parent_name,
 				void __iomem *clk_base, unsigned long flags,
-				unsigned long fixed_rate,
 				struct tegra_clk_pll_params *pll_params,
-				struct tegra_clk_pll_freq_table *freq_table,
 				spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
 	struct clk *clk;
 	u32 val, val_aux;
 
-	pll = _tegra_init_pll(clk_base, NULL, fixed_rate, pll_params,
-			      TEGRA_PLL_HAS_LOCK_ENABLE, freq_table, lock);
+	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
+	pll = _tegra_init_pll(clk_base, NULL, pll_params, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index ab361a2..123e8eb 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -334,6 +334,8 @@ static struct tegra_clk_pll_params pll_c_params = {
 	.stepb_shift = 9,
 	.pdiv_tohw = pllxc_p,
 	.div_nmp = &pllxc_nmp,
+	.freq_table = pll_c_freq_table,
+	.flags = TEGRA_PLL_USE_LOCK,
 };
 
 static struct div_nmp pllcx_nmp = {
@@ -381,6 +383,8 @@ static struct tegra_clk_pll_params pll_c2_params = {
 	.ext_misc_reg[0] = 0x4f0,
 	.ext_misc_reg[1] = 0x4f4,
 	.ext_misc_reg[2] = 0x4f8,
+	.freq_table = pll_cx_freq_table,
+	.flags = TEGRA_PLL_USE_LOCK,
 };
 
 static struct tegra_clk_pll_params pll_c3_params = {
@@ -401,6 +405,8 @@ static struct tegra_clk_pll_params pll_c3_params = {
 	.ext_misc_reg[0] = 0x504,
 	.ext_misc_reg[1] = 0x508,
 	.ext_misc_reg[2] = 0x50c,
+	.freq_table = pll_cx_freq_table,
+	.flags = TEGRA_PLL_USE_LOCK,
 };
 
 static struct div_nmp pllm_nmp = {
@@ -447,6 +453,8 @@ static struct tegra_clk_pll_params pll_m_params = {
 	.div_nmp = &pllm_nmp,
 	.pmc_divnm_reg = PMC_PLLM_WB0_OVERRIDE,
 	.pmc_divp_reg = PMC_PLLM_WB0_OVERRIDE_2,
+	.freq_table = pll_m_freq_table,
+	.flags = TEGRA_PLL_USE_LOCK,
 };
 
 static struct div_nmp pllp_nmp = {
@@ -480,6 +488,9 @@ static struct tegra_clk_pll_params pll_p_params = {
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 	.div_nmp = &pllp_nmp,
+	.freq_table = pll_p_freq_table,
+	.flags = TEGRA_PLL_FIXED | TEGRA_PLL_USE_LOCK,
+	.fixed_rate = 408000000,
 };
 
 static struct tegra_clk_pll_freq_table pll_a_freq_table[] = {
@@ -507,6 +518,8 @@ static struct tegra_clk_pll_params pll_a_params = {
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 	.div_nmp = &pllp_nmp,
+	.freq_table = pll_a_freq_table,
+	.flags = TEGRA_PLL_HAS_CPCON | TEGRA_PLL_USE_LOCK,
 };
 
 static struct tegra_clk_pll_freq_table pll_d_freq_table[] = {
@@ -543,6 +556,9 @@ static struct tegra_clk_pll_params pll_d_params = {
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
 	.div_nmp = &pllp_nmp,
+	.freq_table = pll_d_freq_table,
+	.flags = TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
+		 TEGRA_PLL_USE_LOCK,
 };
 
 static struct tegra_clk_pll_params pll_d2_params = {
@@ -558,6 +574,9 @@ static struct tegra_clk_pll_params pll_d2_params = {
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
 	.div_nmp = &pllp_nmp,
+	.freq_table = pll_d_freq_table,
+	.flags = TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
+		 TEGRA_PLL_USE_LOCK,
 };
 
 static struct pdiv_map pllu_p[] = {
@@ -598,6 +617,9 @@ static struct tegra_clk_pll_params pll_u_params = {
 	.lock_delay = 1000,
 	.pdiv_tohw = pllu_p,
 	.div_nmp = &pllu_nmp,
+	.freq_table = pll_u_freq_table,
+	.flags = TEGRA_PLLU | TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
+		 TEGRA_PLL_USE_LOCK,
 };
 
 static struct tegra_clk_pll_freq_table pll_x_freq_table[] = {
@@ -631,6 +653,8 @@ static struct tegra_clk_pll_params pll_x_params = {
 	.stepb_shift = 24,
 	.pdiv_tohw = pllxc_p,
 	.div_nmp = &pllxc_nmp,
+	.freq_table = pll_x_freq_table,
+	.flags = TEGRA_PLL_USE_LOCK,
 };
 
 static struct tegra_clk_pll_freq_table pll_e_freq_table[] = {
@@ -663,6 +687,9 @@ static struct tegra_clk_pll_params pll_e_params = {
 	.lock_enable_bit_idx = PLLE_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 	.div_nmp = &plle_nmp,
+	.freq_table = pll_e_freq_table,
+	.flags = TEGRA_PLL_FIXED,
+	.fixed_rate = 100000000,
 };
 
 static struct div_nmp pllre_nmp = {
@@ -689,6 +716,7 @@ static struct tegra_clk_pll_params pll_re_vco_params = {
 	.iddq_reg = PLLRE_MISC,
 	.iddq_bit_idx = PLLRE_IDDQ_BIT,
 	.div_nmp = &pllre_nmp,
+	.flags = TEGRA_PLL_USE_LOCK,
 };
 
 /* possible OSC frequencies in Hz */
@@ -1087,8 +1115,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 
 	/* PLLC */
 	clk = tegra_clk_register_pllxc("pll_c", "pll_ref", clk_base,
-			pmc, 0, 0, &pll_c_params, TEGRA_PLL_USE_LOCK,
-			pll_c_freq_table, NULL);
+			pmc, 0, &pll_c_params, NULL);
 	clk_register_clkdev(clk, "pll_c", NULL);
 	clks[TEGRA114_CLK_PLL_C] = clk;
 
@@ -1103,24 +1130,20 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clks[TEGRA114_CLK_PLL_C_OUT1] = clk;
 
 	/* PLLC2 */
-	clk = tegra_clk_register_pllc("pll_c2", "pll_ref", clk_base, pmc, 0, 0,
-			     &pll_c2_params, TEGRA_PLL_USE_LOCK,
-			     pll_cx_freq_table, NULL);
+	clk = tegra_clk_register_pllc("pll_c2", "pll_ref", clk_base, pmc, 0,
+			     &pll_c2_params, NULL);
 	clk_register_clkdev(clk, "pll_c2", NULL);
 	clks[TEGRA114_CLK_PLL_C2] = clk;
 
 	/* PLLC3 */
-	clk = tegra_clk_register_pllc("pll_c3", "pll_ref", clk_base, pmc, 0, 0,
-			     &pll_c3_params, TEGRA_PLL_USE_LOCK,
-			     pll_cx_freq_table, NULL);
+	clk = tegra_clk_register_pllc("pll_c3", "pll_ref", clk_base, pmc, 0,
+			     &pll_c3_params, NULL);
 	clk_register_clkdev(clk, "pll_c3", NULL);
 	clks[TEGRA114_CLK_PLL_C3] = clk;
 
 	/* PLLP */
 	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, pmc, 0,
-			    408000000, &pll_p_params,
-			    TEGRA_PLL_FIXED | TEGRA_PLL_USE_LOCK,
-			    pll_p_freq_table, NULL);
+			    &pll_p_params, NULL);
 	clk_register_clkdev(clk, "pll_p", NULL);
 	clks[TEGRA114_CLK_PLL_P] = clk;
 
@@ -1172,9 +1195,8 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 
 	/* PLLM */
 	clk = tegra_clk_register_pllm("pll_m", "pll_ref", clk_base, pmc,
-			     CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE, 0,
-			     &pll_m_params, TEGRA_PLL_USE_LOCK,
-			     pll_m_freq_table, NULL);
+			     CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE,
+			     &pll_m_params, NULL);
 	clk_register_clkdev(clk, "pll_m", NULL);
 	clks[TEGRA114_CLK_PLL_M] = clk;
 
@@ -1194,8 +1216,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 
 	/* PLLX */
 	clk = tegra_clk_register_pllxc("pll_x", "pll_ref", clk_base,
-			pmc, CLK_IGNORE_UNUSED, 0, &pll_x_params,
-			TEGRA_PLL_USE_LOCK, pll_x_freq_table, NULL);
+			pmc, CLK_IGNORE_UNUSED, &pll_x_params, NULL);
 	clk_register_clkdev(clk, "pll_x", NULL);
 	clks[TEGRA114_CLK_PLL_X] = clk;
 
@@ -1211,9 +1232,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	writel(val, clk_base + pll_u_params.base_reg);
 
 	clk = tegra_clk_register_pll("pll_u", "pll_ref", clk_base, pmc, 0,
-			    0, &pll_u_params, TEGRA_PLLU |
-			    TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
-			    TEGRA_PLL_USE_LOCK, pll_u_freq_table, &pll_u_lock);
+			    &pll_u_params, &pll_u_lock);
 	clk_register_clkdev(clk, "pll_u", NULL);
 	clks[TEGRA114_CLK_PLL_U] = clk;
 
@@ -1246,9 +1265,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 
 	/* PLLD */
 	clk = tegra_clk_register_pll("pll_d", "pll_ref", clk_base, pmc, 0,
-			    0, &pll_d_params,
-			    TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
-			    TEGRA_PLL_USE_LOCK, pll_d_freq_table, &pll_d_lock);
+			    &pll_d_params, &pll_d_lock);
 	clk_register_clkdev(clk, "pll_d", NULL);
 	clks[TEGRA114_CLK_PLL_D] = clk;
 
@@ -1260,9 +1277,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 
 	/* PLLD2 */
 	clk = tegra_clk_register_pll("pll_d2", "pll_ref", clk_base, pmc, 0,
-			    0, &pll_d2_params,
-			    TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
-			    TEGRA_PLL_USE_LOCK, pll_d_freq_table, &pll_d2_lock);
+			    &pll_d2_params, &pll_d2_lock);
 	clk_register_clkdev(clk, "pll_d2", NULL);
 	clks[TEGRA114_CLK_PLL_D2] = clk;
 
@@ -1274,8 +1289,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 
 	/* PLLA */
 	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, pmc, 0,
-			    0, &pll_a_params, TEGRA_PLL_HAS_CPCON |
-			    TEGRA_PLL_USE_LOCK, pll_a_freq_table, NULL);
+			    &pll_a_params, NULL);
 	clk_register_clkdev(clk, "pll_a", NULL);
 	clks[TEGRA114_CLK_PLL_A] = clk;
 
@@ -1291,8 +1305,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 
 	/* PLLRE */
 	clk = tegra_clk_register_pllre("pll_re_vco", "pll_ref", clk_base, pmc,
-			     0, 0, &pll_re_vco_params, TEGRA_PLL_USE_LOCK,
-			     NULL, &pll_re_lock, pll_ref_freq);
+			     0, &pll_re_vco_params, &pll_re_lock, pll_ref_freq);
 	clk_register_clkdev(clk, "pll_re_vco", NULL);
 	clks[TEGRA114_CLK_PLL_RE_VCO] = clk;
 
@@ -1304,8 +1317,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 
 	/* PLLE */
 	clk = tegra_clk_register_plle_tegra114("pll_e_out0", "pll_re_vco",
-				      clk_base, 0, 100000000, &pll_e_params,
-				      pll_e_freq_table, NULL);
+				      clk_base, 0, &pll_e_params, NULL);
 	clk_register_clkdev(clk, "pll_e_out0", NULL);
 	clks[TEGRA114_CLK_PLL_E_OUT0] = clk;
 }
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 6bf5c33..31547fd 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -360,6 +360,8 @@ static struct tegra_clk_pll_params pll_c_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.freq_table = pll_c_freq_table,
+	.flags = TEGRA_PLL_HAS_CPCON,
 };
 
 static struct tegra_clk_pll_params pll_m_params = {
@@ -374,6 +376,8 @@ static struct tegra_clk_pll_params pll_m_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.freq_table = pll_m_freq_table,
+	.flags = TEGRA_PLL_HAS_CPCON,
 };
 
 static struct tegra_clk_pll_params pll_p_params = {
@@ -388,6 +392,9 @@ static struct tegra_clk_pll_params pll_p_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.freq_table = pll_p_freq_table,
+	.flags = TEGRA_PLL_FIXED | TEGRA_PLL_HAS_CPCON,
+	.fixed_rate =  216000000,
 };
 
 static struct tegra_clk_pll_params pll_a_params = {
@@ -402,6 +409,8 @@ static struct tegra_clk_pll_params pll_a_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.freq_table = pll_a_freq_table,
+	.flags = TEGRA_PLL_HAS_CPCON,
 };
 
 static struct tegra_clk_pll_params pll_d_params = {
@@ -416,6 +425,8 @@ static struct tegra_clk_pll_params pll_d_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
+	.freq_table = pll_d_freq_table,
+	.flags = TEGRA_PLL_HAS_CPCON,
 };
 
 static struct pdiv_map pllu_p[] = {
@@ -437,6 +448,8 @@ static struct tegra_clk_pll_params pll_u_params = {
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
 	.pdiv_tohw = pllu_p,
+	.freq_table = pll_u_freq_table,
+	.flags = TEGRA_PLLU | TEGRA_PLL_HAS_CPCON,
 };
 
 static struct tegra_clk_pll_params pll_x_params = {
@@ -451,6 +464,8 @@ static struct tegra_clk_pll_params pll_x_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.freq_table = pll_x_freq_table,
+	.flags = TEGRA_PLL_HAS_CPCON,
 };
 
 static struct tegra_clk_pll_params pll_e_params = {
@@ -465,6 +480,9 @@ static struct tegra_clk_pll_params pll_e_params = {
 	.lock_mask = PLLE_MISC_LOCK,
 	.lock_enable_bit_idx = PLLE_MISC_LOCK_ENABLE,
 	.lock_delay = 0,
+	.freq_table = pll_e_freq_table,
+	.flags = TEGRA_PLL_FIXED,
+	.fixed_rate = 100000000,
 };
 
 static unsigned long tegra20_clk_measure_input_freq(void)
@@ -526,8 +544,7 @@ static void tegra20_pll_init(void)
 
 	/* PLLC */
 	clk = tegra_clk_register_pll("pll_c", "pll_ref", clk_base, NULL, 0,
-			    0, &pll_c_params, TEGRA_PLL_HAS_CPCON,
-			    pll_c_freq_table, NULL);
+			    &pll_c_params, NULL);
 	clk_register_clkdev(clk, "pll_c", NULL);
 	clks[pll_c] = clk;
 
@@ -543,8 +560,7 @@ static void tegra20_pll_init(void)
 
 	/* PLLP */
 	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, NULL, 0,
-			    216000000, &pll_p_params, TEGRA_PLL_FIXED |
-			    TEGRA_PLL_HAS_CPCON, pll_p_freq_table, NULL);
+			    &pll_p_params, NULL);
 	clk_register_clkdev(clk, "pll_p", NULL);
 	clks[pll_p] = clk;
 
@@ -598,9 +614,8 @@ static void tegra20_pll_init(void)
 
 	/* PLLM */
 	clk = tegra_clk_register_pll("pll_m", "pll_ref", clk_base, NULL,
-			    CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE, 0,
-			    &pll_m_params, TEGRA_PLL_HAS_CPCON,
-			    pll_m_freq_table, NULL);
+			    CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE,
+			    &pll_m_params, NULL);
 	clk_register_clkdev(clk, "pll_m", NULL);
 	clks[pll_m] = clk;
 
@@ -616,22 +631,19 @@ static void tegra20_pll_init(void)
 
 	/* PLLX */
 	clk = tegra_clk_register_pll("pll_x", "pll_ref", clk_base, NULL, 0,
-			    0, &pll_x_params, TEGRA_PLL_HAS_CPCON,
-			    pll_x_freq_table, NULL);
+			    &pll_x_params, NULL);
 	clk_register_clkdev(clk, "pll_x", NULL);
 	clks[pll_x] = clk;
 
 	/* PLLU */
 	clk = tegra_clk_register_pll("pll_u", "pll_ref", clk_base, NULL, 0,
-			    0, &pll_u_params, TEGRA_PLLU | TEGRA_PLL_HAS_CPCON,
-			    pll_u_freq_table, NULL);
+			    &pll_u_params, NULL);
 	clk_register_clkdev(clk, "pll_u", NULL);
 	clks[pll_u] = clk;
 
 	/* PLLD */
 	clk = tegra_clk_register_pll("pll_d", "pll_ref", clk_base, NULL, 0,
-			    0, &pll_d_params, TEGRA_PLL_HAS_CPCON,
-			    pll_d_freq_table, NULL);
+			    &pll_d_params, NULL);
 	clk_register_clkdev(clk, "pll_d", NULL);
 	clks[pll_d] = clk;
 
@@ -643,8 +655,7 @@ static void tegra20_pll_init(void)
 
 	/* PLLA */
 	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, NULL, 0,
-			    0, &pll_a_params, TEGRA_PLL_HAS_CPCON,
-			    pll_a_freq_table, NULL);
+			    &pll_a_params, NULL);
 	clk_register_clkdev(clk, "pll_a", NULL);
 	clks[pll_a] = clk;
 
@@ -660,8 +671,7 @@ static void tegra20_pll_init(void)
 
 	/* PLLE */
 	clk = tegra_clk_register_plle("pll_e", "pll_ref", clk_base, pmc_base,
-			     0, 100000000, &pll_e_params,
-			     0, pll_e_freq_table, NULL);
+			     0, &pll_e_params, NULL);
 	clk_register_clkdev(clk, "pll_e", NULL);
 	clks[pll_e] = clk;
 }
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 0505445..d5a78f5 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -529,6 +529,8 @@ static struct tegra_clk_pll_params pll_c_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.freq_table = pll_c_freq_table,
+	.flags = TEGRA_PLL_HAS_CPCON | TEGRA_PLL_USE_LOCK,
 };
 
 static struct div_nmp pllm_nmp = {
@@ -558,6 +560,9 @@ static struct tegra_clk_pll_params pll_m_params = {
 	.div_nmp = &pllm_nmp,
 	.pmc_divnm_reg = PMC_PLLM_WB0_OVERRIDE,
 	.pmc_divp_reg = PMC_PLLM_WB0_OVERRIDE,
+	.freq_table = pll_m_freq_table,
+	.flags = TEGRA_PLLM | TEGRA_PLL_HAS_CPCON |
+		 TEGRA_PLL_SET_DCCON | TEGRA_PLL_USE_LOCK,
 };
 
 static struct tegra_clk_pll_params pll_p_params = {
@@ -572,6 +577,9 @@ static struct tegra_clk_pll_params pll_p_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.freq_table = pll_p_freq_table,
+	.flags = TEGRA_PLL_FIXED | TEGRA_PLL_HAS_CPCON | TEGRA_PLL_USE_LOCK,
+	.fixed_rate = 408000000,
 };
 
 static struct tegra_clk_pll_params pll_a_params = {
@@ -586,6 +594,8 @@ static struct tegra_clk_pll_params pll_a_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.freq_table = pll_a_freq_table,
+	.flags = TEGRA_PLL_HAS_CPCON | TEGRA_PLL_USE_LOCK,
 };
 
 static struct tegra_clk_pll_params pll_d_params = {
@@ -600,6 +610,10 @@ static struct tegra_clk_pll_params pll_d_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
+	.freq_table = pll_d_freq_table,
+	.flags = TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
+		 TEGRA_PLL_USE_LOCK,
+
 };
 
 static struct tegra_clk_pll_params pll_d2_params = {
@@ -614,6 +628,9 @@ static struct tegra_clk_pll_params pll_d2_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
+	.freq_table = pll_d_freq_table,
+	.flags = TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
+		 TEGRA_PLL_USE_LOCK,
 };
 
 static struct tegra_clk_pll_params pll_u_params = {
@@ -629,6 +646,8 @@ static struct tegra_clk_pll_params pll_u_params = {
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
 	.pdiv_tohw = pllu_p,
+	.freq_table = pll_u_freq_table,
+	.flags = TEGRA_PLLU | TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON,
 };
 
 static struct tegra_clk_pll_params pll_x_params = {
@@ -643,6 +662,9 @@ static struct tegra_clk_pll_params pll_x_params = {
 	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.freq_table = pll_x_freq_table,
+	.flags = TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_DCCON |
+		 TEGRA_PLL_USE_LOCK,
 };
 
 static struct tegra_clk_pll_params pll_e_params = {
@@ -657,6 +679,9 @@ static struct tegra_clk_pll_params pll_e_params = {
 	.lock_mask = PLLE_MISC_LOCK,
 	.lock_enable_bit_idx = PLLE_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
+	.freq_table = pll_e_freq_table,
+	.flags = TEGRA_PLLE_CONFIGURE | TEGRA_PLL_FIXED,
+	.fixed_rate = 100000000,
 };
 
 static void tegra30_clk_measure_input_freq(void)
@@ -782,9 +807,7 @@ static void __init tegra30_pll_init(void)
 
 	/* PLLC */
 	clk = tegra_clk_register_pll("pll_c", "pll_ref", clk_base, pmc_base, 0,
-			    0, &pll_c_params,
-			    TEGRA_PLL_HAS_CPCON | TEGRA_PLL_USE_LOCK,
-			    pll_c_freq_table, NULL);
+				&pll_c_params, NULL);
 	clk_register_clkdev(clk, "pll_c", NULL);
 	clks[pll_c] = clk;
 
@@ -800,9 +823,7 @@ static void __init tegra30_pll_init(void)
 
 	/* PLLP */
 	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, pmc_base, 0,
-			    408000000, &pll_p_params,
-			    TEGRA_PLL_FIXED | TEGRA_PLL_HAS_CPCON |
-			    TEGRA_PLL_USE_LOCK, pll_p_freq_table, NULL);
+				&pll_p_params, NULL);
 	clk_register_clkdev(clk, "pll_p", NULL);
 	clks[pll_p] = clk;
 
@@ -856,10 +877,8 @@ static void __init tegra30_pll_init(void)
 
 	/* PLLM */
 	clk = tegra_clk_register_pll("pll_m", "pll_ref", clk_base, pmc_base,
-			    CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE, 0,
-			    &pll_m_params, TEGRA_PLLM | TEGRA_PLL_HAS_CPCON |
-			    TEGRA_PLL_SET_DCCON | TEGRA_PLL_USE_LOCK,
-			    pll_m_freq_table, NULL);
+			    CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE,
+			    &pll_m_params, NULL);
 	clk_register_clkdev(clk, "pll_m", NULL);
 	clks[pll_m] = clk;
 
@@ -875,9 +894,7 @@ static void __init tegra30_pll_init(void)
 
 	/* PLLX */
 	clk = tegra_clk_register_pll("pll_x", "pll_ref", clk_base, pmc_base, 0,
-			    0, &pll_x_params, TEGRA_PLL_HAS_CPCON |
-			    TEGRA_PLL_SET_DCCON | TEGRA_PLL_USE_LOCK,
-			    pll_x_freq_table, NULL);
+			    &pll_x_params, NULL);
 	clk_register_clkdev(clk, "pll_x", NULL);
 	clks[pll_x] = clk;
 
@@ -889,10 +906,7 @@ static void __init tegra30_pll_init(void)
 
 	/* PLLU */
 	clk = tegra_clk_register_pll("pll_u", "pll_ref", clk_base, pmc_base, 0,
-			    0, &pll_u_params, TEGRA_PLLU | TEGRA_PLL_HAS_CPCON |
-			    TEGRA_PLL_SET_LFCON,
-			    pll_u_freq_table,
-			    NULL);
+			    &pll_u_params, NULL);
 	clk_register_clkdev(clk, "pll_u", NULL);
 	clks[pll_u] = clk;
 
@@ -900,9 +914,7 @@ static void __init tegra30_pll_init(void)
 
 	/* PLLD */
 	clk = tegra_clk_register_pll("pll_d", "pll_ref", clk_base, pmc_base, 0,
-			    0, &pll_d_params, TEGRA_PLL_HAS_CPCON |
-			    TEGRA_PLL_SET_LFCON | TEGRA_PLL_USE_LOCK,
-			    pll_d_freq_table, &pll_d_lock);
+			    &pll_d_params, &pll_d_lock);
 	clk_register_clkdev(clk, "pll_d", NULL);
 	clks[pll_d] = clk;
 
@@ -914,9 +926,7 @@ static void __init tegra30_pll_init(void)
 
 	/* PLLD2 */
 	clk = tegra_clk_register_pll("pll_d2", "pll_ref", clk_base, pmc_base, 0,
-			    0, &pll_d2_params, TEGRA_PLL_HAS_CPCON |
-			    TEGRA_PLL_SET_LFCON | TEGRA_PLL_USE_LOCK,
-			    pll_d_freq_table, NULL);
+			    &pll_d2_params, NULL);
 	clk_register_clkdev(clk, "pll_d2", NULL);
 	clks[pll_d2] = clk;
 
@@ -928,8 +938,7 @@ static void __init tegra30_pll_init(void)
 
 	/* PLLA */
 	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, pmc_base,
-			    0, 0, &pll_a_params, TEGRA_PLL_HAS_CPCON |
-			    TEGRA_PLL_USE_LOCK, pll_a_freq_table, NULL);
+			    0, &pll_a_params, NULL);
 	clk_register_clkdev(clk, "pll_a", NULL);
 	clks[pll_a] = clk;
 
@@ -949,8 +958,7 @@ static void __init tegra30_pll_init(void)
 			       CLK_SET_RATE_NO_REPARENT,
 			       clk_base + PLLE_AUX, 2, 1, 0, NULL);
 	clk = tegra_clk_register_plle("pll_e", "pll_e_mux", clk_base, pmc_base,
-			     CLK_GET_RATE_NOCACHE, 100000000, &pll_e_params,
-			     TEGRA_PLLE_CONFIGURE, pll_e_freq_table, NULL);
+			     CLK_GET_RATE_NOCACHE, &pll_e_params, NULL);
 	clk_register_clkdev(clk, "pll_e", NULL);
 	clks[pll_e] = clk;
 }
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index a826720..c49df4d 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -190,12 +190,15 @@ struct tegra_clk_pll_params {
 	u32		ext_misc_reg[3];
 	u32		pmc_divnm_reg;
 	u32		pmc_divp_reg;
+	u32		flags;
 	int		stepa_shift;
 	int		stepb_shift;
 	int		lock_delay;
 	int		max_p;
 	struct pdiv_map *pdiv_tohw;
 	struct div_nmp	*div_nmp;
+	struct tegra_clk_pll_freq_table	*freq_table;
+	unsigned long	fixed_rate;
 };
 
 /**
@@ -235,10 +238,7 @@ struct tegra_clk_pll {
 	struct clk_hw	hw;
 	void __iomem	*clk_base;
 	void __iomem	*pmc;
-	u32		flags;
-	unsigned long	fixed_rate;
 	spinlock_t	*lock;
-	struct tegra_clk_pll_freq_table	*freq_table;
 	struct tegra_clk_pll_params	*params;
 };
 
@@ -260,54 +260,42 @@ extern const struct clk_ops tegra_clk_pll_ops;
 extern const struct clk_ops tegra_clk_plle_ops;
 struct clk *tegra_clk_register_pll(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
-		unsigned long flags, unsigned long fixed_rate,
-		struct tegra_clk_pll_params *pll_params, u32 pll_flags,
-		struct tegra_clk_pll_freq_table *freq_table, spinlock_t *lock);
+		unsigned long flags, struct tegra_clk_pll_params *pll_params,
+		spinlock_t *lock);
 
 struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
-		unsigned long flags, unsigned long fixed_rate,
-		struct tegra_clk_pll_params *pll_params, u32 pll_flags,
-		struct tegra_clk_pll_freq_table *freq_table, spinlock_t *lock);
+		unsigned long flags, struct tegra_clk_pll_params *pll_params,
+		spinlock_t *lock);
 
 struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
 			    void __iomem *clk_base, void __iomem *pmc,
-			    unsigned long flags, unsigned long fixed_rate,
+			    unsigned long flags,
 			    struct tegra_clk_pll_params *pll_params,
-			    u32 pll_flags,
-			    struct tegra_clk_pll_freq_table *freq_table,
 			    spinlock_t *lock);
 
 struct clk *tegra_clk_register_pllm(const char *name, const char *parent_name,
 			   void __iomem *clk_base, void __iomem *pmc,
-			   unsigned long flags, unsigned long fixed_rate,
+			   unsigned long flags,
 			   struct tegra_clk_pll_params *pll_params,
-			   u32 pll_flags,
-			   struct tegra_clk_pll_freq_table *freq_table,
 			   spinlock_t *lock);
 
 struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
 			   void __iomem *clk_base, void __iomem *pmc,
-			   unsigned long flags, unsigned long fixed_rate,
+			   unsigned long flags,
 			   struct tegra_clk_pll_params *pll_params,
-			   u32 pll_flags,
-			   struct tegra_clk_pll_freq_table *freq_table,
 			   spinlock_t *lock);
 
 struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
 			   void __iomem *clk_base, void __iomem *pmc,
-			   unsigned long flags, unsigned long fixed_rate,
+			   unsigned long flags,
 			   struct tegra_clk_pll_params *pll_params,
-			   u32 pll_flags,
-			   struct tegra_clk_pll_freq_table *freq_table,
 			   spinlock_t *lock, unsigned long parent_rate);
 
 struct clk *tegra_clk_register_plle_tegra114(const char *name,
 				const char *parent_name,
 				void __iomem *clk_base, unsigned long flags,
-				unsigned long fixed_rate,
 				struct tegra_clk_pll_params *pll_params,
-				struct tegra_clk_pll_freq_table *freq_table,
 				spinlock_t *lock);
 
 /**
-- 
1.7.7.rc0.72.g4b5ea.dirty

