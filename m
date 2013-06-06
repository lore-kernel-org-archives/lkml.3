Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab3FFKva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:51:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10142 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab3FFKvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:51:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 06 Jun 2013 03:51:00 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/4] clk: tegra: Use override bits when needed
Date: Thu, 6 Jun 2013 13:47:31 +0300
Message-ID: <1370515677-6807-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1370515677-6807-1-git-send-email-pdeschrijver@nvidia.com>
References: <1370515677-6807-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PLLM has override bits in the PMC. Use those when PLLM_OVERRIDE_ENABLE
is set.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c |   82 +++++++++++++++++++++++++-----------------
 1 files changed, 49 insertions(+), 33 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 3b778d3..4293643 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -117,10 +117,6 @@
 #define PLLCX_MISC2_DEFAULT 0x30211200
 #define PLLCX_MISC3_DEFAULT 0x200
 
-#define PMC_PLLM_WB0_OVERRIDE	0x1dc
-#define PMC_PLLM_WB0_OVERRIDE_2	0x2b0
-#define PMC_PLLM_WB0_OVERRIDE_2_DIVP_MASK BIT(27)
-
 #define PMC_SATA_PWRGT 0x1ac
 #define PMC_SATA_PWRGT_PLLE_IDDQ_VALUE BIT(5)
 #define PMC_SATA_PWRGT_PLLE_IDDQ_SWCTL BIT(4)
@@ -128,10 +124,12 @@
 #define pll_readl(offset, p) readl_relaxed(p->clk_base + offset)
 #define pll_readl_base(p) pll_readl(p->params->base_reg, p)
 #define pll_readl_misc(p) pll_readl(p->params->misc_reg, p)
+#define pll_override_readl(offset, p) readl_relaxed(p->pmc + offset)
 
 #define pll_writel(val, offset, p) writel_relaxed(val, p->clk_base + offset)
 #define pll_writel_base(val, p) pll_writel(val, p->params->base_reg, p)
 #define pll_writel_misc(val, p) pll_writel(val, p->params->misc_reg, p)
+#define pll_override_writel(val, offset, p) writel(val, p->pmc + offset)
 
 #define mask(w) ((1 << (w)) - 1)
 #define divm_mask(p) mask(p->params->div_nmp->divm_width)
@@ -413,29 +411,61 @@ static void _update_pll_mnp(struct tegra_clk_pll *pll,
 			    struct tegra_clk_pll_freq_table *cfg)
 {
 	u32 val;
+	struct tegra_clk_pll_params *params = pll->params;
+	struct div_nmp *div_nmp = params->div_nmp;
+
+	if ((pll->flags & TEGRA_PLLM) &&
+		(pll_override_readl(PMC_PLLP_WB0_OVERRIDE, pll) &
+			PMC_PLLP_WB0_OVERRIDE_PLLM_OVERRIDE)) {
+		val = pll_override_readl(params->pmc_divp_reg, pll);
+		val &= ~(divp_mask(pll) << div_nmp->override_divp_shift);
+		val |= cfg->p << div_nmp->override_divp_shift;
+		pll_override_writel(val, params->pmc_divp_reg, pll);
+
+		val = pll_override_readl(params->pmc_divnm_reg, pll);
+		val &= ~(divm_mask(pll) << div_nmp->override_divm_shift) |
+			~(divn_mask(pll) << div_nmp->override_divn_shift);
+		val |= (cfg->m << div_nmp->override_divm_shift) |
+			(cfg->n << div_nmp->override_divn_shift);
+		pll_override_writel(val, params->pmc_divnm_reg, pll);
+	} else {
+		val = pll_readl_base(pll);
 
-	val = pll_readl_base(pll);
+		val &= ~((divm_mask(pll) << div_nmp->divm_shift) |
+		 (divn_mask(pll) << div_nmp->divn_shift) |
+		 (divp_mask(pll) << div_nmp->divp_shift));
 
-	val &= ~((divm_mask(pll) << pll->params->div_nmp->divm_shift) |
-		 (divn_mask(pll) << pll->params->div_nmp->divn_shift) |
-		 (divp_mask(pll) << pll->params->div_nmp->divp_shift));
-	val |= ((cfg->m << pll->params->div_nmp->divm_shift) |
-		(cfg->n << pll->params->div_nmp->divn_shift) |
-		(cfg->p << pll->params->div_nmp->divp_shift));
+		val |= ((cfg->m << div_nmp->divm_shift) |
+			(cfg->n << div_nmp->divn_shift) |
+			(cfg->p << div_nmp->divp_shift));
 
-	pll_writel_base(val, pll);
+		pll_writel_base(val, pll);
+	}
 }
 
 static void _get_pll_mnp(struct tegra_clk_pll *pll,
 			 struct tegra_clk_pll_freq_table *cfg)
 {
 	u32 val;
+	struct tegra_clk_pll_params *params = pll->params;
+	struct div_nmp *div_nmp = params->div_nmp;
+
+	if ((pll->flags & TEGRA_PLLM) &&
+		(pll_override_readl(PMC_PLLP_WB0_OVERRIDE, pll) &
+			PMC_PLLP_WB0_OVERRIDE_PLLM_OVERRIDE)) {
+		val = pll_override_readl(params->pmc_divp_reg, pll);
+		cfg->p = (val >> div_nmp->override_divp_shift) & divp_mask(pll);
+
+		val = pll_override_readl(params->pmc_divnm_reg, pll);
+		cfg->m = (val >> div_nmp->override_divm_shift) & divm_mask(pll);
+		cfg->n = (val >> div_nmp->override_divn_shift) & divn_mask(pll);
+	}  else {
+		val = pll_readl_base(pll);
 
-	val = pll_readl_base(pll);
-
-	cfg->m = (val >> pll->params->div_nmp->divm_shift) & (divm_mask(pll));
-	cfg->n = (val >> pll->params->div_nmp->divn_shift) & (divn_mask(pll));
-	cfg->p = (val >> pll->params->div_nmp->divp_shift) & (divp_mask(pll));
+		cfg->m = (val >> div_nmp->divm_shift) & divm_mask(pll);
+		cfg->n = (val >> div_nmp->divn_shift) & divn_mask(pll);
+		cfg->p = (val >> div_nmp->divp_shift) & divp_mask(pll);
+	}
 }
 
 static void _update_pll_cpcon(struct tegra_clk_pll *pll,
@@ -883,7 +913,6 @@ static int clk_pllm_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
 	unsigned long flags = 0;
 	int state, ret = 0;
-	u32 val;
 
 	if (pll->lock)
 		spin_lock_irqsave(pll->lock, flags);
@@ -902,21 +931,7 @@ static int clk_pllm_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (ret < 0)
 		goto out;
 
-	val = readl_relaxed(pll->pmc + PMC_PLLM_WB0_OVERRIDE);
-	if (val & PMC_PLLP_WB0_OVERRIDE_PLLM_OVERRIDE) {
-		val = readl_relaxed(pll->pmc + PMC_PLLM_WB0_OVERRIDE_2);
-		val = cfg.p ? (val | PMC_PLLM_WB0_OVERRIDE_2_DIVP_MASK) :
-			(val & ~PMC_PLLM_WB0_OVERRIDE_2_DIVP_MASK);
-		writel_relaxed(val, pll->pmc + PMC_PLLM_WB0_OVERRIDE_2);
-
-		val = readl_relaxed(pll->pmc + PMC_PLLM_WB0_OVERRIDE);
-		val &= ~(divn_mask(pll) | divm_mask(pll));
-		val |= (cfg.m << pll->params->div_nmp->divm_shift) |
-			(cfg.n << pll->params->div_nmp->divn_shift);
-		writel_relaxed(val, pll->pmc + PMC_PLLM_WB0_OVERRIDE);
-	} else
-		_update_pll_mnp(pll, &cfg);
-
+	_update_pll_mnp(pll, &cfg);
 
 out:
 	if (pll->lock)
@@ -1461,6 +1476,7 @@ struct clk *tegra_clk_register_pllm(const char *name, const char *parent_name,
 
 	pll_flags |= TEGRA_PLL_BYPASS;
 	pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
+	pll_flags |= TEGRA_PLLM;
 	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
 			      freq_table, lock);
 	if (IS_ERR(pll))
-- 
1.7.7.rc0.72.g4b5ea.dirty

