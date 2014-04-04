Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaDDN4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 09:56:05 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1159 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaDDN4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:56:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Apr 2014 06:51:25 -0700
From: Thierry Reding <treding@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] clk: tegra: Introduce divider mask and shift helpers
Date: Fri, 4 Apr 2014 15:55:14 +0200
Message-ID: <1396619715-15524-2-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396619715-15524-1-git-send-email-treding@nvidia.com>
References: <1396619715-15524-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add div{m,n,p}_shift() and div{m,n,p}_mask_shifted() helpers to make the
code that modifies the m-, n- and p-divider fields of PLLs shorter and
easier to read.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- new patch to address comment by Stephen

 drivers/clk/tegra/clk-pll.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 357911303315..1187187a1cf2 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -183,6 +183,14 @@
 #define divp_mask(p) (p->params->flags & TEGRA_PLLU ? PLLU_POST_DIVP_MASK :\
 		      mask(p->params->div_nmp->divp_width))
 
+#define divm_shift(p) (p)->params->div_nmp->divm_shift
+#define divn_shift(p) (p)->params->div_nmp->divn_shift
+#define divp_shift(p) (p)->params->div_nmp->divp_shift
+
+#define divm_mask_shifted(p) (divm_mask(p) << divm_shift(p))
+#define divn_mask_shifted(p) (divn_mask(p) << divn_shift(p))
+#define divp_mask_shifted(p) (divp_mask(p) << divp_shift(p))
+
 #define divm_max(p) (divm_mask(p))
 #define divn_max(p) (divn_mask(p))
 #define divp_max(p) (1 << (divp_mask(p)))
@@ -476,13 +484,12 @@ static void _update_pll_mnp(struct tegra_clk_pll *pll,
 	} else {
 		val = pll_readl_base(pll);
 
-		val &= ~((divm_mask(pll) << div_nmp->divm_shift) |
-		 (divn_mask(pll) << div_nmp->divn_shift) |
-		 (divp_mask(pll) << div_nmp->divp_shift));
+		val &= ~(divm_mask_shifted(pll) | divn_mask_shifted(pll) |
+			 divp_mask_shifted(pll));
 
-		val |= ((cfg->m << div_nmp->divm_shift) |
-			(cfg->n << div_nmp->divn_shift) |
-			(cfg->p << div_nmp->divp_shift));
+		val |= (cfg->m << divm_shift(pll)) |
+		       (cfg->n << divn_shift(pll)) |
+		       (cfg->p << divp_shift(pll));
 
 		pll_writel_base(val, pll);
 	}
@@ -730,13 +737,12 @@ static int clk_plle_enable(struct clk_hw *hw)
 	if (pll->params->flags & TEGRA_PLLE_CONFIGURE) {
 		/* configure dividers */
 		val = pll_readl_base(pll);
-		val &= ~(divp_mask(pll) << PLLE_BASE_DIVP_SHIFT |
-			 divn_mask(pll) << PLLE_BASE_DIVN_SHIFT |
-			 divm_mask(pll) << PLLE_BASE_DIVM_SHIFT);
+		val &= ~(divp_mask_shifted(pll) | divn_mask_shifted(pll) |
+			 divm_mask_shifted(pll));
 		val &= ~(PLLE_BASE_DIVCML_MASK << PLLE_BASE_DIVCML_SHIFT);
-		val |= sel.m << pll->params->div_nmp->divm_shift;
-		val |= sel.n << pll->params->div_nmp->divn_shift;
-		val |= sel.p << pll->params->div_nmp->divp_shift;
+		val |= sel.m << divm_shift(pll);
+		val |= sel.n << divn_shift(pll);
+		val |= sel.p << divp_shift(pll);
 		val |= sel.cpcon << PLLE_BASE_DIVCML_SHIFT;
 		pll_writel_base(val, pll);
 	}
@@ -1295,12 +1301,11 @@ static int clk_plle_tegra114_enable(struct clk_hw *hw)
 	pll_writel(val, PLLE_SS_CTRL, pll);
 
 	val = pll_readl_base(pll);
-	val &= ~(divp_mask(pll) << PLLE_BASE_DIVP_SHIFT |
-		 divn_mask(pll) << PLLE_BASE_DIVN_SHIFT |
-		 divm_mask(pll) << PLLE_BASE_DIVM_SHIFT);
+	val &= ~(divp_mask_shifted(pll) | divn_mask_shifted(pll) |
+		 divm_mask_shifted(pll));
 	val &= ~(PLLE_BASE_DIVCML_MASK << PLLE_BASE_DIVCML_SHIFT);
-	val |= sel.m << pll->params->div_nmp->divm_shift;
-	val |= sel.n << pll->params->div_nmp->divn_shift;
+	val |= sel.m << divm_shift(pll);
+	val |= sel.n << divn_shift(pll);
 	val |= sel.cpcon << PLLE_BASE_DIVCML_SHIFT;
 	pll_writel_base(val, pll);
 	udelay(1);
@@ -1575,9 +1580,8 @@ struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
 		int m;
 
 		m = _pll_fixed_mdiv(pll_params, parent_rate);
-		val = m << PLL_BASE_DIVM_SHIFT;
-		val |= (pll_params->vco_min / parent_rate)
-				<< PLL_BASE_DIVN_SHIFT;
+		val = m << divm_shift(pll);
+		val |= (pll_params->vco_min / parent_rate) << divn_shift(pll);
 		pll_writel_base(val, pll);
 	}
 
-- 
1.9.1

