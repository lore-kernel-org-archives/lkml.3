Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaE1Qvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:51:36 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5711 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbaE1Qve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:51:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 28 May 2014 09:44:35 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: [PATCH 2/2] clk: tegra: periph, PLL and super clk debugfs entries
Date: Wed, 28 May 2014 19:51:08 +0300
Message-ID: <1401295868-18697-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1401295868-18697-1-git-send-email-pdeschrijver@nvidia.com>
References: <1401295868-18697-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement debugs entries for periph clks, super clks and PLLs.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-periph.c |   24 +++++++
 drivers/clk/tegra/clk-pll.c    |  144 +++++++++++++++++++++++++++++++++++++---
 drivers/clk/tegra/clk-super.c  |   24 +++++++
 drivers/clk/tegra/clk.h        |    3 +
 4 files changed, 186 insertions(+), 9 deletions(-)

diff --git a/drivers/clk/tegra/clk-periph.c b/drivers/clk/tegra/clk-periph.c
index 9e899c18..9a5061b 100644
--- a/drivers/clk/tegra/clk-periph.c
+++ b/drivers/clk/tegra/clk-periph.c
@@ -111,6 +111,29 @@ static void clk_periph_disable(struct clk_hw *hw)
 	gate_ops->disable(gate_hw);
 }
 
+#ifdef CONFIG_DEBUG_FS
+#include <linux/debugfs.h>
+
+static int clk_periph_show(struct seq_file *s, struct clk_hw *hw,
+			   void __iomem *clk_base)
+{
+	struct tegra_clk_periph *periph = to_clk_periph(hw);
+	u32 offset = periph->divider.reg - clk_base;
+
+	seq_printf(s, "clk_source_%s(0x%x): %08x\n", __clk_get_name(hw->clk),
+		    offset, readl_relaxed(periph->divider.reg));
+
+	return 0;
+}
+
+static int clk_periph_debug_init(struct clk_hw *hw, struct dentry *parent_dir)
+{
+	return tegra_clk_debug_init(hw, parent_dir, clk_periph_show);
+}
+#else
+#define clk_periph_debug_init NULL
+#endif
+
 const struct clk_ops tegra_clk_periph_ops = {
 	.get_parent = clk_periph_get_parent,
 	.set_parent = clk_periph_set_parent,
@@ -120,6 +143,7 @@ const struct clk_ops tegra_clk_periph_ops = {
 	.is_enabled = clk_periph_is_enabled,
 	.enable = clk_periph_enable,
 	.disable = clk_periph_disable,
+	.debug_init = clk_periph_debug_init,
 };
 
 static const struct clk_ops tegra_clk_periph_nodiv_ops = {
diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 0d20241..c5f830e 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/clk-provider.h>
 #include <linux/clk.h>
+#include <linux/debugfs.h>
 
 #include "clk.h"
 
@@ -662,6 +663,66 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
+#ifdef CONFIG_DEBUG_FS
+#include <linux/debugfs.h>
+
+static int clk_pll_debug_print(struct seq_file *s, const char *name,
+			       const char *reg, u32 offset,
+			       struct tegra_clk_pll *pll)
+{
+	return seq_printf(s, "%s_%s(0x%x): %08x\n", name, reg, offset,
+			  readl_relaxed(pll->clk_base + offset));
+}
+
+static int clk_pll_debug_print_base(struct seq_file *s, const char *name,
+				    struct tegra_clk_pll *pll)
+{
+	clk_pll_debug_print(s, name, "base", pll->params->base_reg, pll);
+	clk_pll_debug_print(s, name, "misc", pll->params->misc_reg, pll);
+
+	return 0;
+}
+
+static int clk_pll_show(struct seq_file *s, struct clk_hw *hw,
+			void __iomem *clk_base)
+{
+	const char *name = __clk_get_name(hw->clk);
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	struct tegra_clk_pll_params *params = pll->params;
+
+	clk_pll_debug_print_base(s, name, pll);
+
+	if (params->flags & TEGRA_PLLM) {
+		seq_printf(s, "%s(0x%x): %08x\n",
+			   "apbdev_pmc_pllm_wb0_override_freq",
+			   params->pmc_divnm_reg,
+			   pll_override_readl(params->pmc_divnm_reg, pll));
+
+		if (params->pmc_divnm_reg != params->pmc_divp_reg)
+			seq_printf(s, "%s(0x%x): %08x\n",
+				"apbdev_pmc_pllm_wb0_override2",
+				params->pmc_divp_reg,
+				pll_override_readl(params->pmc_divp_reg, pll));
+	}
+
+	return 0;
+}
+
+static int clk_pll_debug_init(struct clk_hw *hw, struct dentry *parent_dir)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	tegra_clk_debugfn *show;
+
+	show = pll->show;
+	if (!show)
+		show = clk_pll_show;
+
+	return tegra_clk_debug_init(hw, parent_dir, show);
+}
+#else
+#define clk_pll_debug_init NULL
+#endif
+
 static int clk_plle_training(struct tegra_clk_pll *pll)
 {
 	u32 val;
@@ -775,6 +836,22 @@ static unsigned long clk_plle_recalc_rate(struct clk_hw *hw,
 	return rate;
 }
 
+#ifdef CONFIG_DEBUG_FS
+static int clk_plle_show(struct seq_file *s, struct clk_hw *hw,
+			 void __iomem *clk_base)
+{
+	const char *name = __clk_get_name(hw->clk);
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+
+	clk_pll_debug_print_base(s, name, pll);
+	clk_pll_debug_print(s, name, "aux", pll->params->aux_reg, pll);
+
+	return 0;
+}
+#else
+#define clk_plle_show NULL
+#endif
+
 const struct clk_ops tegra_clk_pll_ops = {
 	.is_enabled = clk_pll_is_enabled,
 	.enable = clk_pll_enable,
@@ -782,6 +859,7 @@ const struct clk_ops tegra_clk_pll_ops = {
 	.recalc_rate = clk_pll_recalc_rate,
 	.round_rate = clk_pll_round_rate,
 	.set_rate = clk_pll_set_rate,
+	.debug_init = clk_pll_debug_init,
 };
 
 const struct clk_ops tegra_clk_plle_ops = {
@@ -789,6 +867,7 @@ const struct clk_ops tegra_clk_plle_ops = {
 	.is_enabled = clk_pll_is_enabled,
 	.disable = clk_pll_disable,
 	.enable = clk_plle_enable,
+	.debug_init = clk_pll_debug_init,
 };
 
 #if defined(CONFIG_ARCH_TEGRA_114_SOC) || defined(CONFIG_ARCH_TEGRA_124_SOC)
@@ -1346,11 +1425,49 @@ static void clk_plle_tegra114_disable(struct clk_hw *hw)
 	if (pll->lock)
 		spin_unlock_irqrestore(pll->lock, flags);
 }
+#ifdef CONFIG_DEBUG_FS
+static int clk_pllxc_show(struct seq_file *s, struct clk_hw *hw,
+			  void __iomem *clk_base)
+{
+	const char *name = __clk_get_name(hw->clk);
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	struct tegra_clk_pll_params *params = pll->params;
+
+	clk_pll_debug_print_base(s, name, pll);
+
+	clk_pll_debug_print(s, name, "misc_2", params->dyn_ramp_reg, pll);
+
+	if (pll->params->iddq_reg != pll->params->misc_reg)
+		clk_pll_debug_print(s, name, "misc_3", params->iddq_reg, pll);
+
+	return 0;
+}
+
+static int clk_pllc_show(struct seq_file *s, struct clk_hw *hw,
+			 void __iomem *clk_base)
+{
+	const char *name = __clk_get_name(hw->clk);
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	u32 *ext_misc_reg = &pll->params->ext_misc_reg[0];
+
+	clk_pll_debug_print_base(s, name, pll);
+
+	clk_pll_debug_print(s, name, "misc_1", ext_misc_reg[0], pll);
+	clk_pll_debug_print(s, name, "misc_2", ext_misc_reg[1], pll);
+	clk_pll_debug_print(s, name, "misc_3", ext_misc_reg[2], pll);
+
+	return 0;
+}
+#else
+#define clk_pllxc_show NULL
+#define clk_pllc_show NULL
+#endif
+
 #endif
 
 static struct tegra_clk_pll *_tegra_init_pll(void __iomem *clk_base,
 		void __iomem *pmc, struct tegra_clk_pll_params *pll_params,
-		spinlock_t *lock)
+		tegra_clk_debugfn *show, spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
 
@@ -1364,6 +1481,8 @@ static struct tegra_clk_pll *_tegra_init_pll(void __iomem *clk_base,
 	pll->params = pll_params;
 	pll->lock = lock;
 
+	pll->show = show;
+
 	if (!pll_params->div_nmp)
 		pll_params->div_nmp = &default_nmp;
 
@@ -1398,7 +1517,7 @@ struct clk *tegra_clk_register_pll(const char *name, const char *parent_name,
 
 	pll_params->flags |= TEGRA_PLL_BYPASS;
 	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
-	pll = _tegra_init_pll(clk_base, pmc, pll_params, lock);
+	pll = _tegra_init_pll(clk_base, pmc, pll_params, NULL, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
@@ -1420,7 +1539,8 @@ struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
 
 	pll_params->flags |= TEGRA_PLL_LOCK_MISC | TEGRA_PLL_BYPASS;
 	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
-	pll = _tegra_init_pll(clk_base, pmc, pll_params, lock);
+	pll = _tegra_init_pll(clk_base, pmc, pll_params, clk_plle_show,
+			      lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
@@ -1440,6 +1560,7 @@ static const struct clk_ops tegra_clk_pllxc_ops = {
 	.recalc_rate = clk_pll_recalc_rate,
 	.round_rate = clk_pll_ramp_round_rate,
 	.set_rate = clk_pllxc_set_rate,
+	.debug_init = clk_pll_debug_init,
 };
 
 static const struct clk_ops tegra_clk_pllm_ops = {
@@ -1449,6 +1570,7 @@ static const struct clk_ops tegra_clk_pllm_ops = {
 	.recalc_rate = clk_pll_recalc_rate,
 	.round_rate = clk_pll_ramp_round_rate,
 	.set_rate = clk_pllm_set_rate,
+	.debug_init = clk_pll_debug_init,
 };
 
 static const struct clk_ops tegra_clk_pllc_ops = {
@@ -1458,6 +1580,7 @@ static const struct clk_ops tegra_clk_pllc_ops = {
 	.recalc_rate = clk_pll_recalc_rate,
 	.round_rate = clk_pll_ramp_round_rate,
 	.set_rate = clk_pllc_set_rate,
+	.debug_init = clk_pll_debug_init,
 };
 
 static const struct clk_ops tegra_clk_pllre_ops = {
@@ -1467,6 +1590,7 @@ static const struct clk_ops tegra_clk_pllre_ops = {
 	.recalc_rate = clk_pllre_recalc_rate,
 	.round_rate = clk_pllre_round_rate,
 	.set_rate = clk_pllre_set_rate,
+	.debug_init = clk_pll_debug_init,
 };
 
 static const struct clk_ops tegra_clk_plle_tegra114_ops = {
@@ -1474,6 +1598,7 @@ static const struct clk_ops tegra_clk_plle_tegra114_ops = {
 	.enable = clk_plle_tegra114_enable,
 	.disable = clk_plle_tegra114_disable,
 	.recalc_rate = clk_pll_recalc_rate,
+	.debug_init = clk_pll_debug_init,
 };
 
 
@@ -1518,7 +1643,7 @@ struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
 	}
 
 	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
-	pll = _tegra_init_pll(clk_base, pmc, pll_params, lock);
+	pll = _tegra_init_pll(clk_base, pmc, pll_params, clk_pllxc_show, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
@@ -1544,7 +1669,7 @@ struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
 
 	pll_params->vco_min = _clip_vco_min(pll_params->vco_min, parent_rate);
 
-	pll = _tegra_init_pll(clk_base, pmc, pll_params, lock);
+	pll = _tegra_init_pll(clk_base, pmc, pll_params, NULL, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
@@ -1604,7 +1729,7 @@ struct clk *tegra_clk_register_pllm(const char *name, const char *parent_name,
 	pll_params->flags |= TEGRA_PLL_BYPASS;
 	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
 	pll_params->flags |= TEGRA_PLLM;
-	pll = _tegra_init_pll(clk_base, pmc, pll_params, lock);
+	pll = _tegra_init_pll(clk_base, pmc, pll_params, NULL, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
@@ -1643,7 +1768,7 @@ struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
 	pll_params->vco_min = _clip_vco_min(pll_params->vco_min, parent_rate);
 
 	pll_params->flags |= TEGRA_PLL_BYPASS;
-	pll = _tegra_init_pll(clk_base, pmc, pll_params, lock);
+	pll = _tegra_init_pll(clk_base, pmc, pll_params, clk_pllc_show, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
@@ -1701,7 +1826,7 @@ struct clk *tegra_clk_register_plle_tegra114(const char *name,
 	u32 val, val_aux;
 
 	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
-	pll = _tegra_init_pll(clk_base, NULL, pll_params, lock);
+	pll = _tegra_init_pll(clk_base, NULL, pll_params, NULL, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
@@ -1738,6 +1863,7 @@ static const struct clk_ops tegra_clk_pllss_ops = {
 	.recalc_rate = clk_pll_recalc_rate,
 	.round_rate = clk_pll_ramp_round_rate,
 	.set_rate = clk_pllxc_set_rate,
+	.debug_init = clk_pll_debug_init,
 };
 
 struct clk *tegra_clk_register_pllss(const char *name, const char *parent_name,
@@ -1763,7 +1889,7 @@ struct clk *tegra_clk_register_pllss(const char *name, const char *parent_name,
 	}
 
 	pll_params->flags = TEGRA_PLL_HAS_LOCK_ENABLE | TEGRA_PLL_USE_LOCK;
-	pll = _tegra_init_pll(clk_base, NULL, pll_params, lock);
+	pll = _tegra_init_pll(clk_base, NULL, pll_params, clk_pllc_show, lock);
 	if (IS_ERR(pll))
 		return ERR_CAST(pll);
 
diff --git a/drivers/clk/tegra/clk-super.c b/drivers/clk/tegra/clk-super.c
index 2fd924d..5426b9a 100644
--- a/drivers/clk/tegra/clk-super.c
+++ b/drivers/clk/tegra/clk-super.c
@@ -122,9 +122,33 @@ out:
 	return err;
 }
 
+#ifdef CONFIG_DEBUG_FS
+#include <linux/debugfs.h>
+
+static int clk_super_show(struct seq_file *s, struct clk_hw *hw,
+			  void __iomem *clk_base)
+{
+	struct tegra_clk_super_mux *mux = to_clk_super_mux(hw);
+	u32 offset = mux->reg - clk_base;
+
+	seq_printf(s, "%s_burst_policy(0x%x): %08x\n", __clk_get_name(hw->clk),
+			offset, readl_relaxed(mux->reg));
+
+	return 0;
+}
+
+static int clk_super_debug_init(struct clk_hw *hw, struct dentry *parent_dir)
+{
+	return tegra_clk_debug_init(hw, parent_dir, clk_super_show);
+}
+#else
+#define clk_super_debug_init NULL
+#endif
+
 const struct clk_ops tegra_clk_super_ops = {
 	.get_parent = clk_super_get_parent,
 	.set_parent = clk_super_set_parent,
+	.debug_init = clk_super_debug_init,
 };
 
 struct clk *tegra_clk_register_super_mux(const char *name,
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index facbd99..32c699d 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -248,6 +248,9 @@ struct tegra_clk_pll {
 	void __iomem	*pmc;
 	spinlock_t	*lock;
 	struct tegra_clk_pll_params	*params;
+#ifdef CONFIG_DEBUG_FS
+	tegra_clk_debugfn *show;
+#endif
 };
 
 #define to_clk_pll(_hw) container_of(_hw, struct tegra_clk_pll, hw)
-- 
1.7.7.rc0.72.g4b5ea.dirty

