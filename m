Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaCaOqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:46:11 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:59114 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaCaOqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:46:08 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] clk: tegra: Fix PLLE programming
Date: Mon, 31 Mar 2014 16:45:42 +0200
Message-Id: <1396277142-18292-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

PLLE has M, N and P divider shift and width parameters that differ from
the defaults. Furthermore, when clearing the M, N and P divider fields
the corresponding masks were never shifted, thereby clearing only the
lowest bits of the register. This lead to a situation where the PLLE
programming would only work if the register hadn't been touched before.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 0d20241e0770..357911303315 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -58,9 +58,9 @@
 #define PLLDU_LFCON_SET_DIVN 600
 
 #define PLLE_BASE_DIVCML_SHIFT 24
-#define PLLE_BASE_DIVCML_WIDTH 4
+#define PLLE_BASE_DIVCML_MASK 0xf
 #define PLLE_BASE_DIVP_SHIFT 16
-#define PLLE_BASE_DIVP_WIDTH 7
+#define PLLE_BASE_DIVP_WIDTH 6
 #define PLLE_BASE_DIVN_SHIFT 8
 #define PLLE_BASE_DIVN_WIDTH 8
 #define PLLE_BASE_DIVM_SHIFT 0
@@ -730,8 +730,10 @@ static int clk_plle_enable(struct clk_hw *hw)
 	if (pll->params->flags & TEGRA_PLLE_CONFIGURE) {
 		/* configure dividers */
 		val = pll_readl_base(pll);
-		val &= ~(divm_mask(pll) | divn_mask(pll) | divp_mask(pll));
-		val &= ~(PLLE_BASE_DIVCML_WIDTH << PLLE_BASE_DIVCML_SHIFT);
+		val &= ~(divp_mask(pll) << PLLE_BASE_DIVP_SHIFT |
+			 divn_mask(pll) << PLLE_BASE_DIVN_SHIFT |
+			 divm_mask(pll) << PLLE_BASE_DIVM_SHIFT);
+		val &= ~(PLLE_BASE_DIVCML_MASK << PLLE_BASE_DIVCML_SHIFT);
 		val |= sel.m << pll->params->div_nmp->divm_shift;
 		val |= sel.n << pll->params->div_nmp->divn_shift;
 		val |= sel.p << pll->params->div_nmp->divp_shift;
@@ -745,6 +747,7 @@ static int clk_plle_enable(struct clk_hw *hw)
 	pll_writel_misc(val, pll);
 
 	val = readl(pll->clk_base + PLLE_SS_CTRL);
+	val &= ~PLLE_SS_COEFFICIENTS_MASK;
 	val |= PLLE_SS_DISABLE;
 	writel(val, pll->clk_base + PLLE_SS_CTRL);
 
@@ -1292,8 +1295,10 @@ static int clk_plle_tegra114_enable(struct clk_hw *hw)
 	pll_writel(val, PLLE_SS_CTRL, pll);
 
 	val = pll_readl_base(pll);
-	val &= ~(divm_mask(pll) | divn_mask(pll) | divp_mask(pll));
-	val &= ~(PLLE_BASE_DIVCML_WIDTH << PLLE_BASE_DIVCML_SHIFT);
+	val &= ~(divp_mask(pll) << PLLE_BASE_DIVP_SHIFT |
+		 divn_mask(pll) << PLLE_BASE_DIVN_SHIFT |
+		 divm_mask(pll) << PLLE_BASE_DIVM_SHIFT);
+	val &= ~(PLLE_BASE_DIVCML_MASK << PLLE_BASE_DIVCML_SHIFT);
 	val |= sel.m << pll->params->div_nmp->divm_shift;
 	val |= sel.n << pll->params->div_nmp->divn_shift;
 	val |= sel.cpcon << PLLE_BASE_DIVCML_SHIFT;
@@ -1410,6 +1415,15 @@ struct clk *tegra_clk_register_pll(const char *name, const char *parent_name,
 	return clk;
 }
 
+static struct div_nmp pll_e_nmp = {
+	.divn_shift = PLLE_BASE_DIVN_SHIFT,
+	.divn_width = PLLE_BASE_DIVN_WIDTH,
+	.divm_shift = PLLE_BASE_DIVM_SHIFT,
+	.divm_width = PLLE_BASE_DIVM_WIDTH,
+	.divp_shift = PLLE_BASE_DIVP_SHIFT,
+	.divp_width = PLLE_BASE_DIVP_WIDTH,
+};
+
 struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
 		unsigned long flags, struct tegra_clk_pll_params *pll_params,
@@ -1420,6 +1434,10 @@ struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
 
 	pll_params->flags |= TEGRA_PLL_LOCK_MISC | TEGRA_PLL_BYPASS;
 	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
+
+	if (!pll_params->div_nmp)
+		pll_params->div_nmp = &pll_e_nmp;
+
 	pll = _tegra_init_pll(clk_base, pmc, pll_params, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
-- 
1.9.1

