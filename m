Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3FENwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:52:34 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16484 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3FENwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:52:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Jun 2013 06:52:06 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] clk: tegra: allow PLL m,n,p init from SoC files
Date: Wed, 5 Jun 2013 16:51:25 +0300
Message-ID: <1370440301-3562-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1370440301-3562-1-git-send-email-pdeschrijver@nvidia.com>
References: <1370440301-3562-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The m,n,p fields don't have the same bit offset and width across all PLLs.
This patch allows SoC specific files to indicate the offset and width.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c |   60 +++++++++++++++++++++++-------------------
 drivers/clk/tegra/clk.h     |   32 ++++++++++++++--------
 2 files changed, 53 insertions(+), 39 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 85bec1d..3b778d3 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -134,15 +134,24 @@
 #define pll_writel_misc(val, p) pll_writel(val, p->params->misc_reg, p)
 
 #define mask(w) ((1 << (w)) - 1)
-#define divm_mask(p) mask(p->divm_width)
-#define divn_mask(p) mask(p->divn_width)
+#define divm_mask(p) mask(p->params->div_nmp->divm_width)
+#define divn_mask(p) mask(p->params->div_nmp->divn_width)
 #define divp_mask(p) (p->flags & TEGRA_PLLU ? PLLU_POST_DIVP_MASK :	\
-		      mask(p->divp_width))
+		      mask(p->params->div_nmp->divp_width))
 
 #define divm_max(p) (divm_mask(p))
 #define divn_max(p) (divn_mask(p))
 #define divp_max(p) (1 << (divp_mask(p)))
 
+static struct div_nmp default_nmp = {
+	.divn_shift = PLL_BASE_DIVN_SHIFT,
+	.divn_width = PLL_BASE_DIVN_WIDTH,
+	.divm_shift = PLL_BASE_DIVM_SHIFT,
+	.divm_width = PLL_BASE_DIVM_WIDTH,
+	.divp_shift = PLL_BASE_DIVP_SHIFT,
+	.divp_width = PLL_BASE_DIVP_WIDTH,
+};
+
 static void clk_pll_enable_lock(struct tegra_clk_pll *pll)
 {
 	u32 val;
@@ -407,12 +416,12 @@ static void _update_pll_mnp(struct tegra_clk_pll *pll,
 
 	val = pll_readl_base(pll);
 
-	val &= ~((divm_mask(pll) << pll->divm_shift) |
-		 (divn_mask(pll) << pll->divn_shift) |
-		 (divp_mask(pll) << pll->divp_shift));
-	val |= ((cfg->m << pll->divm_shift) |
-		(cfg->n << pll->divn_shift) |
-		(cfg->p << pll->divp_shift));
+	val &= ~((divm_mask(pll) << pll->params->div_nmp->divm_shift) |
+		 (divn_mask(pll) << pll->params->div_nmp->divn_shift) |
+		 (divp_mask(pll) << pll->params->div_nmp->divp_shift));
+	val |= ((cfg->m << pll->params->div_nmp->divm_shift) |
+		(cfg->n << pll->params->div_nmp->divn_shift) |
+		(cfg->p << pll->params->div_nmp->divp_shift));
 
 	pll_writel_base(val, pll);
 }
@@ -424,9 +433,9 @@ static void _get_pll_mnp(struct tegra_clk_pll *pll,
 
 	val = pll_readl_base(pll);
 
-	cfg->m = (val >> pll->divm_shift) & (divm_mask(pll));
-	cfg->n = (val >> pll->divn_shift) & (divn_mask(pll));
-	cfg->p = (val >> pll->divp_shift) & (divp_mask(pll));
+	cfg->m = (val >> pll->params->div_nmp->divm_shift) & (divm_mask(pll));
+	cfg->n = (val >> pll->params->div_nmp->divn_shift) & (divn_mask(pll));
+	cfg->p = (val >> pll->params->div_nmp->divp_shift) & (divp_mask(pll));
 }
 
 static void _update_pll_cpcon(struct tegra_clk_pll *pll,
@@ -646,9 +655,9 @@ static int clk_plle_enable(struct clk_hw *hw)
 		val = pll_readl_base(pll);
 		val &= ~(divm_mask(pll) | divn_mask(pll) | divp_mask(pll));
 		val &= ~(PLLE_BASE_DIVCML_WIDTH << PLLE_BASE_DIVCML_SHIFT);
-		val |= sel.m << pll->divm_shift;
-		val |= sel.n << pll->divn_shift;
-		val |= sel.p << pll->divp_shift;
+		val |= sel.m << pll->params->div_nmp->divm_shift;
+		val |= sel.n << pll->params->div_nmp->divn_shift;
+		val |= sel.p << pll->params->div_nmp->divp_shift;
 		val |= sel.cpcon << PLLE_BASE_DIVCML_SHIFT;
 		pll_writel_base(val, pll);
 	}
@@ -679,9 +688,9 @@ static unsigned long clk_plle_recalc_rate(struct clk_hw *hw,
 	u32 divn = 0, divm = 0, divp = 0;
 	u64 rate = parent_rate;
 
-	divp = (val >> pll->divp_shift) & (divp_mask(pll));
-	divn = (val >> pll->divn_shift) & (divn_mask(pll));
-	divm = (val >> pll->divm_shift) & (divm_mask(pll));
+	divp = (val >> pll->params->div_nmp->divp_shift) & (divp_mask(pll));
+	divn = (val >> pll->params->div_nmp->divn_shift) & (divn_mask(pll));
+	divm = (val >> pll->params->div_nmp->divm_shift) & (divm_mask(pll));
 	divm *= divp;
 
 	rate *= divn;
@@ -902,7 +911,8 @@ static int clk_pllm_set_rate(struct clk_hw *hw, unsigned long rate,
 
 		val = readl_relaxed(pll->pmc + PMC_PLLM_WB0_OVERRIDE);
 		val &= ~(divn_mask(pll) | divm_mask(pll));
-		val |= (cfg.m << pll->divm_shift) | (cfg.n << pll->divn_shift);
+		val |= (cfg.m << pll->params->div_nmp->divm_shift) |
+			(cfg.n << pll->params->div_nmp->divn_shift);
 		writel_relaxed(val, pll->pmc + PMC_PLLM_WB0_OVERRIDE);
 	} else
 		_update_pll_mnp(pll, &cfg);
@@ -1180,8 +1190,8 @@ static int clk_plle_tegra114_enable(struct clk_hw *hw)
 	val = pll_readl_base(pll);
 	val &= ~(divm_mask(pll) | divn_mask(pll) | divp_mask(pll));
 	val &= ~(PLLE_BASE_DIVCML_WIDTH << PLLE_BASE_DIVCML_SHIFT);
-	val |= sel.m << pll->divm_shift;
-	val |= sel.n << pll->divn_shift;
+	val |= sel.m << pll->params->div_nmp->divm_shift;
+	val |= sel.n << pll->params->div_nmp->divn_shift;
 	val |= sel.cpcon << PLLE_BASE_DIVCML_SHIFT;
 	pll_writel_base(val, pll);
 	udelay(1);
@@ -1242,12 +1252,8 @@ static struct tegra_clk_pll *_tegra_init_pll(void __iomem *clk_base,
 	pll->flags = pll_flags;
 	pll->lock = lock;
 
-	pll->divp_shift = PLL_BASE_DIVP_SHIFT;
-	pll->divp_width = PLL_BASE_DIVP_WIDTH;
-	pll->divn_shift = PLL_BASE_DIVN_SHIFT;
-	pll->divn_width = PLL_BASE_DIVN_WIDTH;
-	pll->divm_shift = PLL_BASE_DIVM_SHIFT;
-	pll->divm_width = PLL_BASE_DIVM_WIDTH;
+	if (!pll_params->div_nmp)
+		pll_params->div_nmp = &default_nmp;
 
 	return pll;
 }
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 11278a8..d70eb2d 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -128,6 +128,25 @@ struct pdiv_map {
 };
 
 /**
+ * struct div_nmp - offset and width of m,n and p fields
+ *
+ * @divn_shift:	shift to the feedback divider bit field
+ * @divn_width:	width of the feedback divider bit field
+ * @divm_shift:	shift to the input divider bit field
+ * @divm_width:	width of the input divider bit field
+ * @divp_shift:	shift to the post divider bit field
+ * @divp_width:	width of the post divider bit field
+ */
+struct div_nmp {
+	u8		divn_shift;
+	u8		divn_width;
+	u8		divm_shift;
+	u8		divm_width;
+	u8		divp_shift;
+	u8		divp_width;
+};
+
+/**
  * struct clk_pll_params - PLL parameters
  *
  * @input_min:			Minimum input frequency
@@ -166,6 +185,7 @@ struct tegra_clk_pll_params {
 	int		lock_delay;
 	int		max_p;
 	struct pdiv_map *pdiv_tohw;
+	struct div_nmp	*div_nmp;
 };
 
 /**
@@ -179,12 +199,6 @@ struct tegra_clk_pll_params {
  * @flags:	PLL flags
  * @fixed_rate:	PLL rate if it is fixed
  * @lock:	register lock
- * @divn_shift:	shift to the feedback divider bit field
- * @divn_width:	width of the feedback divider bit field
- * @divm_shift:	shift to the input divider bit field
- * @divm_width:	width of the input divider bit field
- * @divp_shift:	shift to the post divider bit field
- * @divp_width:	width of the post divider bit field
  *
  * Flags:
  * TEGRA_PLL_USE_LOCK - This flag indicated to use lock bits for
@@ -214,12 +228,6 @@ struct tegra_clk_pll {
 	u32		flags;
 	unsigned long	fixed_rate;
 	spinlock_t	*lock;
-	u8		divn_shift;
-	u8		divn_width;
-	u8		divm_shift;
-	u8		divm_width;
-	u8		divp_shift;
-	u8		divp_width;
 	struct tegra_clk_pll_freq_table	*freq_table;
 	struct tegra_clk_pll_params	*params;
 };
-- 
1.7.7.rc0.72.g4b5ea.dirty

