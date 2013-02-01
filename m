Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab3BAKVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:21:13 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17451 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3BAKVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:21:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 01 Feb 2013 02:18:33 -0800
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
Subject: [PATCH v5 02/10] clk: tegra: Add TEGRA_PLL_BYPASS flag
Date: Fri, 1 Feb 2013 12:18:31 +0200
Message-ID: <1359713962-16822-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com>
References: <1359713962-16822-1-git-send-email-pdeschrijver@nvidia.com>
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
 drivers/clk/tegra/clk-pll.c |   15 ++++++++++-----
 drivers/clk/tegra/clk.h     |    8 +++++---
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 912c977..3c3a25e 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -166,7 +166,8 @@ static void _clk_pll_enable(struct clk_hw *hw)
 	clk_pll_enable_lock(pll);
 
 	val = pll_readl_base(pll);
-	val &= ~PLL_BASE_BYPASS;
+	if (pll->flags & TEGRA_PLL_BYPASS)
+		val &= ~PLL_BASE_BYPASS;
 	val |= PLL_BASE_ENABLE;
 	pll_writel_base(val, pll);
 
@@ -183,7 +184,9 @@ static void _clk_pll_disable(struct clk_hw *hw)
 	u32 val;
 
 	val = pll_readl_base(pll);
-	val &= ~(PLL_BASE_BYPASS | PLL_BASE_ENABLE);
+	if (pll->flags & TEGRA_PLL_BYPASS)
+		val &= ~PLL_BASE_BYPASS;
+	val &= ~PLL_BASE_ENABLE;
 	pll_writel_base(val, pll);
 
 	if (pll->flags & TEGRA_PLLM) {
@@ -454,7 +457,7 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
 
 	val = pll_readl_base(pll);
 
-	if (val & PLL_BASE_BYPASS)
+	if ((pll->flags & TEGRA_PLL_BYPASS) && (val & PLL_BASE_BYPASS))
 		return parent_rate;
 
 	if ((pll->flags & TEGRA_PLL_FIXED) && !(val & PLL_BASE_OVERRIDE)) {
@@ -660,9 +663,10 @@ static struct clk *_tegra_clk_register_pll(const char *name,
 struct clk *tegra_clk_register_pll(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
 		unsigned long flags, unsigned long fixed_rate,
-		struct tegra_clk_pll_params *pll_params, u8 pll_flags,
+		struct tegra_clk_pll_params *pll_params, u32 pll_flags,
 		struct tegra_clk_pll_freq_table *freq_table, spinlock_t *lock)
 {
+	pll_flags |= TEGRA_PLL_BYPASS;
 	return _tegra_clk_register_pll(name, parent_name, clk_base, pmc,
 			flags, fixed_rate, pll_params, pll_flags, freq_table,
 			lock, &tegra_clk_pll_ops);
@@ -671,9 +675,10 @@ struct clk *tegra_clk_register_pll(const char *name, const char *parent_name,
 struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
 		unsigned long flags, unsigned long fixed_rate,
-		struct tegra_clk_pll_params *pll_params, u8 pll_flags,
+		struct tegra_clk_pll_params *pll_params, u32 pll_flags,
 		struct tegra_clk_pll_freq_table *freq_table, spinlock_t *lock)
 {
+	pll_flags |= TEGRA_PLL_BYPASS;
 	return _tegra_clk_register_pll(name, parent_name, clk_base, pmc,
 			flags, fixed_rate, pll_params, pll_flags, freq_table,
 			lock, &tegra_clk_plle_ops);
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index a09d7dc..3cff1df 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -182,12 +182,13 @@ struct tegra_clk_pll_params {
  * TEGRA_PLL_FIXED - We are not supposed to change output frequency
  *     of some plls.
  * TEGRA_PLLE_CONFIGURE - Configure PLLE when enabling.
+ * TEGRA_PLL_BYPASS - PLL has bypass bit
  */
 struct tegra_clk_pll {
 	struct clk_hw	hw;
 	void __iomem	*clk_base;
 	void __iomem	*pmc;
-	u8		flags;
+	u32		flags;
 	unsigned long	fixed_rate;
 	spinlock_t	*lock;
 	u8		divn_shift;
@@ -210,18 +211,19 @@ struct tegra_clk_pll {
 #define TEGRA_PLLM BIT(5)
 #define TEGRA_PLL_FIXED BIT(6)
 #define TEGRA_PLLE_CONFIGURE BIT(7)
+#define TEGRA_PLL_BYPASS BIT(8)
 
 extern const struct clk_ops tegra_clk_pll_ops;
 extern const struct clk_ops tegra_clk_plle_ops;
 struct clk *tegra_clk_register_pll(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
 		unsigned long flags, unsigned long fixed_rate,
-		struct tegra_clk_pll_params *pll_params, u8 pll_flags,
+		struct tegra_clk_pll_params *pll_params, u32 pll_flags,
 		struct tegra_clk_pll_freq_table *freq_table, spinlock_t *lock);
 struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
 		unsigned long flags, unsigned long fixed_rate,
-		struct tegra_clk_pll_params *pll_params, u8 pll_flags,
+		struct tegra_clk_pll_params *pll_params, u32 pll_flags,
 		struct tegra_clk_pll_freq_table *freq_table, spinlock_t *lock);
 
 /**

