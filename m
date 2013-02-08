Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946303Ab3BHNh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 08:37:26 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1832 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759924Ab3BHNhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 08:37:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 08 Feb 2013 05:34:03 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 02/10] clk: tegra: Add TEGRA_PLL_BYPASS flag
Date: Fri, 8 Feb 2013 15:36:34 +0200
Message-ID: <1360330602-30472-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1360330602-30472-1-git-send-email-pdeschrijver@nvidia.com>
References: <1360330602-30472-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all PLLs in Tegra114 have a bypass bit. Adapt the common code to only use
this bit when available.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c |   12 ++++++++----
 drivers/clk/tegra/clk.h     |    2 ++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 3feefb1..4ee6d03 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -171,7 +171,8 @@ static void _clk_pll_enable(struct clk_hw *hw)
 	clk_pll_enable_lock(pll);
 
 	val = pll_readl_base(pll);
-	val &= ~PLL_BASE_BYPASS;
+	if (pll->flags & TEGRA_PLL_BYPASS)
+		val &= ~PLL_BASE_BYPASS;
 	val |= PLL_BASE_ENABLE;
 	pll_writel_base(val, pll);
 
@@ -188,7 +189,9 @@ static void _clk_pll_disable(struct clk_hw *hw)
 	u32 val;
 
 	val = pll_readl_base(pll);
-	val &= ~(PLL_BASE_BYPASS | PLL_BASE_ENABLE);
+	if (pll->flags & TEGRA_PLL_BYPASS)
+		val &= ~PLL_BASE_BYPASS;
+	val &= ~PLL_BASE_ENABLE;
 	pll_writel_base(val, pll);
 
 	if (pll->flags & TEGRA_PLLM) {
@@ -459,7 +462,7 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
 
 	val = pll_readl_base(pll);
 
-	if (val & PLL_BASE_BYPASS)
+	if ((pll->flags & TEGRA_PLL_BYPASS) && (val & PLL_BASE_BYPASS))
 		return parent_rate;
 
 	if ((pll->flags & TEGRA_PLL_FIXED) && !(val & PLL_BASE_OVERRIDE)) {
@@ -671,6 +674,7 @@ struct clk *tegra_clk_register_pll(const char *name, const char *parent_name,
 	struct tegra_clk_pll *pll;
 	struct clk *clk;
 
+	pll_flags |= TEGRA_PLL_BYPASS;
 	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
 			      freq_table, lock);
 	if (IS_ERR(pll))
@@ -692,8 +696,8 @@ struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
 {
 	struct tegra_clk_pll *pll;
 	struct clk *clk;
-	pll_flags |= TEGRA_PLL_LOCK_MISC;
 
+	pll_flags |= TEGRA_PLL_LOCK_MISC | TEGRA_PLL_BYPASS;
 	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
 			      freq_table, lock);
 	if (IS_ERR(pll))
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 0a9e088..2697aa8 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -184,6 +184,7 @@ struct tegra_clk_pll_params {
  * TEGRA_PLLE_CONFIGURE - Configure PLLE when enabling.
  * TEGRA_PLL_LOCK_MISC - Lock bit is in the misc register instead of the
  *     base register.
+ * TEGRA_PLL_BYPASS - PLL has bypass bit
  */
 struct tegra_clk_pll {
 	struct clk_hw	hw;
@@ -213,6 +214,7 @@ struct tegra_clk_pll {
 #define TEGRA_PLL_FIXED BIT(6)
 #define TEGRA_PLLE_CONFIGURE BIT(7)
 #define TEGRA_PLL_LOCK_MISC BIT(8)
+#define TEGRA_PLL_BYPASS BIT(9)
 
 extern const struct clk_ops tegra_clk_pll_ops;
 extern const struct clk_ops tegra_clk_plle_ops;
-- 
1.7.1

