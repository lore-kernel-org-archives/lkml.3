Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946470Ab3BHNhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 08:37:55 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1856 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946182Ab3BHNhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 08:37:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 08 Feb 2013 05:37:51 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 04/10] clk: tegra: Add new fields and PLL types for Tegra114
Date: Fri, 8 Feb 2013 15:36:36 +0200
Message-ID: <1360330602-30472-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1360330602-30472-1-git-send-email-pdeschrijver@nvidia.com>
References: <1360330602-30472-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra114 introduces new PLL types. This requires new clocktypes as well
as some new fields in the pll structure.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c |  836 +++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.h     |   48 +++
 2 files changed, 884 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 08f4eb7..914d4f9 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -79,6 +79,48 @@
 #define PLLE_SS_CTRL 0x68
 #define PLLE_SS_DISABLE (7 << 10)
 
+#define PLLE_AUX_PLLP_SEL	BIT(2)
+#define PLLE_AUX_ENABLE_SWCTL	BIT(4)
+#define PLLE_AUX_SEQ_ENABLE	BIT(24)
+#define PLLE_AUX_PLLRE_SEL	BIT(28)
+
+#define PLLE_MISC_PLLE_PTS	BIT(8)
+#define PLLE_MISC_IDDQ_SW_VALUE	BIT(13)
+#define PLLE_MISC_IDDQ_SW_CTRL	BIT(14)
+#define PLLE_MISC_VREG_BG_CTRL_SHIFT	4
+#define PLLE_MISC_VREG_BG_CTRL_MASK	(3 << PLLE_MISC_VREG_BG_CTRL_SHIFT)
+#define PLLE_MISC_VREG_CTRL_SHIFT	2
+#define PLLE_MISC_VREG_CTRL_MASK	(2 << PLLE_MISC_VREG_CTRL_SHIFT)
+
+#define PLLCX_MISC_STROBE	BIT(31)
+#define PLLCX_MISC_RESET	BIT(30)
+#define PLLCX_MISC_SDM_DIV_SHIFT 28
+#define PLLCX_MISC_SDM_DIV_MASK (0x3 << PLLCX_MISC_SDM_DIV_SHIFT)
+#define PLLCX_MISC_FILT_DIV_SHIFT 26
+#define PLLCX_MISC_FILT_DIV_MASK (0x3 << PLLCX_MISC_FILT_DIV_SHIFT)
+#define PLLCX_MISC_ALPHA_SHIFT 18
+#define PLLCX_MISC_DIV_LOW_RANGE \
+		((0x2 << PLLCX_MISC_SDM_DIV_SHIFT) | \
+		(0x2 << PLLCX_MISC_FILT_DIV_SHIFT))
+#define PLLCX_MISC_DIV_HIGH_RANGE \
+		((0x1 << PLLCX_MISC_SDM_DIV_SHIFT) | \
+		(0x1 << PLLCX_MISC_FILT_DIV_SHIFT))
+#define PLLCX_MISC_COEF_LOW_RANGE \
+		((0x14 << PLLCX_MISC_KA_SHIFT) | (0x38 << PLLCX_MISC_KB_SHIFT))
+#define PLLCX_MISC_KA_SHIFT 2
+#define PLLCX_MISC_KB_SHIFT 9
+#define PLLCX_MISC_DEFAULT (PLLCX_MISC_COEF_LOW_RANGE | \
+			    (0x19 << PLLCX_MISC_ALPHA_SHIFT) | \
+			    PLLCX_MISC_DIV_LOW_RANGE | \
+			    PLLCX_MISC_RESET)
+#define PLLCX_MISC1_DEFAULT 0x000d2308
+#define PLLCX_MISC2_DEFAULT 0x30211200
+#define PLLCX_MISC3_DEFAULT 0x200
+
+#define PMC_PLLM_WB0_OVERRIDE	0x1dc
+#define PMC_PLLM_WB0_OVERRIDE_2	0x2b0
+#define PMC_PLLM_WB0_OVERRIDE_2_DIVP_MASK BIT(27)
+
 #define PMC_SATA_PWRGT 0x1ac
 #define PMC_SATA_PWRGT_PLLE_IDDQ_VALUE BIT(5)
 #define PMC_SATA_PWRGT_PLLE_IDDQ_SWCTL BIT(4)
@@ -101,6 +143,24 @@
 #define divn_max(p) (divn_mask(p))
 #define divp_max(p) (1 << (divp_mask(p)))
 
+
+#ifdef CONFIG_ARCH_TEGRA_114_SOC
+/* PLLXC has 4-bit PDIV, but entry 15 is not allowed in h/w */
+#define PLLXC_PDIV_MAX			14
+
+/* non-monotonic mapping below is not a typo */
+static u8 pllxc_p[PLLXC_PDIV_MAX + 1] = {
+	/* PDIV: 0, 1, 2, 3, 4, 5, 6,  7,  8,  9, 10, 11, 12, 13, 14 */
+	/* p: */ 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 12, 16, 20, 24, 32
+};
+
+#define PLLCX_PDIV_MAX 7
+static u8 pllcx_p[PLLCX_PDIV_MAX + 1] = {
+	/* PDIV: 0, 1, 2, 3, 4, 5,  6,  7 */
+	/* p: */ 1, 2, 3, 4, 6, 8, 12, 16
+};
+#endif
+
 static void clk_pll_enable_lock(struct tegra_clk_pll *pll)
 {
 	u32 val;
@@ -643,6 +703,520 @@ const struct clk_ops tegra_clk_plle_ops = {
 	.enable = clk_plle_enable,
 };
 
+#ifdef CONFIG_ARCH_TEGRA_114_SOC
+
+static int _pll_fixed_mdiv(struct tegra_clk_pll_params *pll_params,
+			   unsigned long parent_rate)
+{
+	if (parent_rate > pll_params->cf_max)
+		return 2;
+	else
+		return 1;
+}
+
+static int clk_pll_iddq_enable(struct clk_hw *hw)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	unsigned long flags = 0;
+
+	u32 val;
+	int ret;
+
+	if (pll->lock)
+		spin_lock_irqsave(pll->lock, flags);
+
+	val = pll_readl(pll->params->iddq_reg, pll);
+	val &= ~BIT(pll->params->iddq_bit_idx);
+	pll_writel(val, pll->params->iddq_reg, pll);
+	udelay(2);
+
+	_clk_pll_enable(hw);
+
+	ret = clk_pll_wait_for_lock(pll);
+
+	if (pll->lock)
+		spin_unlock_irqrestore(pll->lock, flags);
+
+	return 0;
+}
+
+static void clk_pll_iddq_disable(struct clk_hw *hw)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	unsigned long flags = 0;
+	u32 val;
+
+	if (pll->lock)
+		spin_lock_irqsave(pll->lock, flags);
+
+	_clk_pll_disable(hw);
+
+	val = pll_readl(pll->params->iddq_reg, pll);
+	val |= BIT(pll->params->iddq_bit_idx);
+	pll_writel(val, pll->params->iddq_reg, pll);
+	udelay(2);
+
+	if (pll->lock)
+		spin_unlock_irqrestore(pll->lock, flags);
+}
+
+static int _calc_dynamic_ramp_rate(struct clk_hw *hw,
+				struct tegra_clk_pll_freq_table *cfg,
+				unsigned long rate, unsigned long parent_rate)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	unsigned int p;
+
+	if (!rate)
+		return -EINVAL;
+
+	p = DIV_ROUND_UP(pll->params->vco_min, rate);
+	cfg->m = _pll_fixed_mdiv(pll->params, parent_rate);
+	cfg->p = p;
+	cfg->output_rate = rate * cfg->p;
+	cfg->n = cfg->output_rate * cfg->m / parent_rate;
+
+	if (cfg->n > divn_max(pll) || cfg->output_rate > pll->params->vco_max)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int _pll_ramp_calc_pll(struct clk_hw *hw,
+			      struct tegra_clk_pll_freq_table *cfg,
+			      unsigned long rate, unsigned long parent_rate)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	int err = 0;
+
+	err = _get_table_rate(hw, cfg, rate, parent_rate);
+	if (err < 0)
+		err = _calc_dynamic_ramp_rate(hw, cfg, rate, parent_rate);
+	else if (cfg->m != _pll_fixed_mdiv(pll->params, parent_rate)) {
+			WARN_ON(1);
+			err = -EINVAL;
+			goto out;
+	}
+
+	if (!cfg->p || (cfg->p >  pll->params->max_p))
+		err = -EINVAL;
+
+out:
+	return err;
+}
+
+static int clk_pllxc_set_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long parent_rate)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	struct tegra_clk_pll_freq_table cfg, old_cfg;
+	unsigned long flags = 0;
+	int ret = 0;
+	u8 old_p;
+
+	ret = _pll_ramp_calc_pll(hw, &cfg, rate, parent_rate);
+	if (ret < 0)
+		return ret;
+
+	if (pll->lock)
+		spin_lock_irqsave(pll->lock, flags);
+
+	_get_pll_mnp(pll, &old_cfg);
+
+	old_p = pllxc_p[old_cfg.p];
+	if (old_cfg.m != cfg.m && old_cfg.n != cfg.n && old_p != cfg.p) {
+		cfg.p -= 1;
+		ret = _program_pll(hw, &cfg, rate);
+	}
+
+	if (pll->lock)
+		spin_unlock_irqrestore(pll->lock, flags);
+
+	return ret;
+}
+
+static long clk_pll_ramp_round_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long *prate)
+{
+	struct tegra_clk_pll_freq_table cfg;
+	int ret = 0;
+	u64 output_rate = *prate;
+
+	ret = _pll_ramp_calc_pll(hw, &cfg, rate, *prate);
+	if (ret < 0)
+		return ret;
+
+	output_rate *= cfg.n;
+	do_div(output_rate, cfg.m * cfg.p);
+
+	return output_rate;
+}
+
+static int clk_pllm_set_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long parent_rate)
+{
+	struct tegra_clk_pll_freq_table cfg;
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	unsigned long flags = 0;
+	int state, ret = 0;
+	u32 val;
+
+	if (pll->lock)
+		spin_lock_irqsave(pll->lock, flags);
+
+	state = clk_pll_is_enabled(hw);
+	if (state) {
+		if (rate != clk_get_rate(hw->clk)) {
+			pr_err("%s: Cannot change active PLLM\n", __func__);
+			ret = -EINVAL;
+			goto out;
+		}
+		goto out;
+	}
+
+	ret = _pll_ramp_calc_pll(hw, &cfg, rate, parent_rate);
+	if (ret < 0)
+		goto out;
+
+	cfg.p -= 1;
+
+	val = readl_relaxed(pll->pmc + PMC_PLLM_WB0_OVERRIDE);
+	if (val & PMC_PLLP_WB0_OVERRIDE_PLLM_OVERRIDE) {
+		val = readl_relaxed(pll->pmc + PMC_PLLM_WB0_OVERRIDE_2);
+		val = cfg.p ? (val | PMC_PLLM_WB0_OVERRIDE_2_DIVP_MASK) :
+			(val & ~PMC_PLLM_WB0_OVERRIDE_2_DIVP_MASK);
+		writel_relaxed(val, pll->pmc + PMC_PLLM_WB0_OVERRIDE_2);
+
+		val = readl_relaxed(pll->pmc + PMC_PLLM_WB0_OVERRIDE);
+		val &= ~(divn_mask(pll) | divm_mask(pll));
+		val |= (cfg.m << pll->divm_shift) | (cfg.n << pll->divn_shift);
+		writel_relaxed(val, pll->pmc + PMC_PLLM_WB0_OVERRIDE);
+	} else
+		_update_pll_mnp(pll, &cfg);
+
+
+out:
+	if (pll->lock)
+		spin_unlock_irqrestore(pll->lock, flags);
+
+	return ret;
+}
+
+static void _pllcx_strobe(struct tegra_clk_pll *pll)
+{
+	u32 val;
+
+	val = pll_readl_misc(pll);
+	val |= PLLCX_MISC_STROBE;
+	pll_writel_misc(val, pll);
+	udelay(2);
+
+	val &= ~PLLCX_MISC_STROBE;
+	pll_writel_misc(val, pll);
+}
+
+static int clk_pllc_enable(struct clk_hw *hw)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	u32 val;
+	int ret = 0;
+	unsigned long flags = 0;
+
+	if (pll->lock)
+		spin_lock_irqsave(pll->lock, flags);
+
+	_clk_pll_enable(hw);
+	udelay(2);
+
+	val = pll_readl_misc(pll);
+	val &= ~PLLCX_MISC_RESET;
+	pll_writel_misc(val, pll);
+	udelay(2);
+
+	_pllcx_strobe(pll);
+
+	ret = clk_pll_wait_for_lock(pll);
+
+	if (pll->lock)
+		spin_unlock_irqrestore(pll->lock, flags);
+
+	return ret;
+}
+
+static void _clk_pllc_disable(struct clk_hw *hw)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	u32 val;
+
+	_clk_pll_disable(hw);
+
+	val = pll_readl_misc(pll);
+	val |= PLLCX_MISC_RESET;
+	pll_writel_misc(val, pll);
+	udelay(2);
+}
+
+static void clk_pllc_disable(struct clk_hw *hw)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	unsigned long flags = 0;
+
+	if (pll->lock)
+		spin_lock_irqsave(pll->lock, flags);
+
+	_clk_pllc_disable(hw);
+
+	if (pll->lock)
+		spin_unlock_irqrestore(pll->lock, flags);
+}
+
+static int _pllcx_update_dynamic_coef(struct tegra_clk_pll *pll,
+					unsigned long input_rate, u32 n)
+{
+	u32 val, n_threshold;
+
+	switch (input_rate) {
+	case 12000000:
+		n_threshold = 70;
+		break;
+	case 13000000:
+	case 26000000:
+		n_threshold = 71;
+		break;
+	case 16800000:
+		n_threshold = 55;
+		break;
+	case 19200000:
+		n_threshold = 48;
+		break;
+	default:
+		pr_err("%s: Unexpected reference rate %lu\n",
+			__func__, input_rate);
+		return -EINVAL;
+	}
+
+	val = pll_readl_misc(pll);
+	val &= ~(PLLCX_MISC_SDM_DIV_MASK | PLLCX_MISC_FILT_DIV_MASK);
+	val |= n <= n_threshold ?
+		PLLCX_MISC_DIV_LOW_RANGE : PLLCX_MISC_DIV_HIGH_RANGE;
+	pll_writel_misc(val, pll);
+
+	return 0;
+}
+
+static int clk_pllc_set_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long parent_rate)
+{
+	struct tegra_clk_pll_freq_table cfg;
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	unsigned long flags = 0;
+	int state, ret = 0;
+	u32 val;
+	u16 old_m, old_n;
+	u8 old_p;
+
+	if (pll->lock)
+		spin_lock_irqsave(pll->lock, flags);
+
+	ret = _pll_ramp_calc_pll(hw, &cfg, rate, parent_rate);
+	if (ret < 0)
+		goto out;
+
+	val = pll_readl_base(pll);
+	old_m = (val >> pll->divm_shift) & (divm_mask(pll));
+	old_n = (val >> pll->divn_shift) & (divn_mask(pll));
+	old_p = pllcx_p[(val >> pll->divp_shift) & (divp_mask(pll))];
+
+	if (cfg.m != old_m) {
+		WARN_ON(1);
+		goto out;
+	}
+
+	if (old_n == cfg.n && old_p == cfg.p)
+		goto out;
+
+	cfg.p -= 1;
+
+	state = clk_pll_is_enabled(hw);
+	if (state)
+		_clk_pllc_disable(hw);
+
+	ret = _pllcx_update_dynamic_coef(pll, parent_rate, cfg.n);
+	if (ret < 0)
+		goto out;
+
+	_update_pll_mnp(pll, &cfg);
+
+	if (state)
+		ret = clk_pllc_enable(hw);
+
+out:
+	if (pll->lock)
+		spin_unlock_irqrestore(pll->lock, flags);
+
+	return ret;
+}
+
+static long _pllre_calc_rate(struct tegra_clk_pll *pll,
+			     struct tegra_clk_pll_freq_table *cfg,
+			     unsigned long rate, unsigned long parent_rate)
+{
+	u16 m, n;
+	u64 output_rate = parent_rate;
+
+	m = _pll_fixed_mdiv(pll->params, parent_rate);
+	n = rate * m / parent_rate;
+
+	output_rate *= n;
+	do_div(output_rate, m);
+
+	if (cfg) {
+		cfg->m = m;
+		cfg->n = n;
+	}
+
+	return output_rate;
+}
+static int clk_pllre_set_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long parent_rate)
+{
+	struct tegra_clk_pll_freq_table cfg, old_cfg;
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	unsigned long flags = 0;
+	int state, ret = 0;
+
+	if (pll->lock)
+		spin_lock_irqsave(pll->lock, flags);
+
+	_pllre_calc_rate(pll, &cfg, rate, parent_rate);
+	_get_pll_mnp(pll, &old_cfg);
+	cfg.p = old_cfg.p;
+
+	if (cfg.m != old_cfg.m || cfg.n != old_cfg.n) {
+		state = clk_pll_is_enabled(hw);
+		if (state)
+			_clk_pll_disable(hw);
+
+		_update_pll_mnp(pll, &cfg);
+
+		if (state) {
+			_clk_pll_enable(hw);
+			ret = clk_pll_wait_for_lock(pll);
+		}
+	}
+
+	if (pll->lock)
+		spin_unlock_irqrestore(pll->lock, flags);
+
+	return ret;
+}
+
+static unsigned long clk_pllre_recalc_rate(struct clk_hw *hw,
+					 unsigned long parent_rate)
+{
+	struct tegra_clk_pll_freq_table cfg;
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	u64 rate = parent_rate;
+
+	_get_pll_mnp(pll, &cfg);
+
+	rate *= cfg.n;
+	do_div(rate, cfg.m);
+
+	return rate;
+}
+
+static long clk_pllre_round_rate(struct clk_hw *hw, unsigned long rate,
+				 unsigned long *prate)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+
+	return _pllre_calc_rate(pll, NULL, rate, *prate);
+}
+
+static int clk_plle_tegra114_enable(struct clk_hw *hw)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	struct tegra_clk_pll_freq_table sel;
+	u32 val;
+	int ret;
+	unsigned long flags = 0;
+	unsigned long input_rate = clk_get_rate(clk_get_parent(hw->clk));
+
+	if (_get_table_rate(hw, &sel, pll->fixed_rate, input_rate))
+		return -EINVAL;
+
+	if (pll->lock)
+		spin_lock_irqsave(pll->lock, flags);
+
+	val = pll_readl_base(pll);
+	val &= ~BIT(29); /* Disable lock override */
+	pll_writel_base(val, pll);
+
+	val = pll_readl(pll->params->aux_reg, pll);
+	val |= PLLE_AUX_ENABLE_SWCTL;
+	val &= ~PLLE_AUX_SEQ_ENABLE;
+	pll_writel(val, pll->params->aux_reg, pll);
+	udelay(1);
+
+	val = pll_readl_misc(pll);
+	val |= PLLE_MISC_LOCK_ENABLE;
+	val |= PLLE_MISC_IDDQ_SW_CTRL;
+	val &= ~PLLE_MISC_IDDQ_SW_VALUE;
+	val |= PLLE_MISC_PLLE_PTS;
+	val |= PLLE_MISC_VREG_BG_CTRL_MASK | PLLE_MISC_VREG_CTRL_MASK;
+	pll_writel_misc(val, pll);
+	udelay(5);
+
+	val = pll_readl(PLLE_SS_CTRL, pll);
+	val |= PLLE_SS_DISABLE;
+	pll_writel(val, PLLE_SS_CTRL, pll);
+
+	val = pll_readl_base(pll);
+	val &= ~(divm_mask(pll) | divn_mask(pll) | divp_mask(pll));
+	val &= ~(PLLE_BASE_DIVCML_WIDTH << PLLE_BASE_DIVCML_SHIFT);
+	val |= sel.m << pll->divm_shift;
+	val |= sel.n << pll->divn_shift;
+	val |= sel.cpcon << PLLE_BASE_DIVCML_SHIFT;
+	pll_writel_base(val, pll);
+	udelay(1);
+
+	_clk_pll_enable(hw);
+	ret = clk_pll_wait_for_lock(pll);
+
+	if (ret < 0)
+		goto out;
+
+	/* TODO: enable hw control of xusb brick pll */
+
+out:
+	if (pll->lock)
+		spin_unlock_irqrestore(pll->lock, flags);
+
+	return ret;
+}
+
+static void clk_plle_tegra114_disable(struct clk_hw *hw)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	unsigned long flags = 0;
+	u32 val;
+
+	if (pll->lock)
+		spin_lock_irqsave(pll->lock, flags);
+
+	_clk_pll_disable(hw);
+
+	val = pll_readl_misc(pll);
+	val |= PLLE_MISC_IDDQ_SW_CTRL | PLLE_MISC_IDDQ_SW_VALUE;
+	pll_writel_misc(val, pll);
+	udelay(1);
+
+	if (pll->lock)
+		spin_unlock_irqrestore(pll->lock, flags);
+}
+#endif
+
 static struct tegra_clk_pll *_tegra_init_pll(void __iomem *clk_base,
 		void __iomem *pmc, unsigned long fixed_rate,
 		struct tegra_clk_pll_params *pll_params, u32 pll_flags,
@@ -736,3 +1310,265 @@ struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
 
 	return clk;
 }
+
+#ifdef CONFIG_ARCH_TEGRA_114_SOC
+const struct clk_ops tegra_clk_pllxc_ops = {
+	.is_enabled = clk_pll_is_enabled,
+	.enable = clk_pll_iddq_enable,
+	.disable = clk_pll_iddq_disable,
+	.recalc_rate = clk_pll_recalc_rate,
+	.round_rate = clk_pll_ramp_round_rate,
+	.set_rate = clk_pllxc_set_rate,
+};
+
+const struct clk_ops tegra_clk_pllm_ops = {
+	.is_enabled = clk_pll_is_enabled,
+	.enable = clk_pll_iddq_enable,
+	.disable = clk_pll_iddq_disable,
+	.recalc_rate = clk_pll_recalc_rate,
+	.round_rate = clk_pll_ramp_round_rate,
+	.set_rate = clk_pllm_set_rate,
+};
+
+const struct clk_ops tegra_clk_pllc_ops = {
+	.is_enabled = clk_pll_is_enabled,
+	.enable = clk_pllc_enable,
+	.disable = clk_pllc_disable,
+	.recalc_rate = clk_pll_recalc_rate,
+	.round_rate = clk_pll_ramp_round_rate,
+	.set_rate = clk_pllc_set_rate,
+};
+
+const struct clk_ops tegra_clk_pllre_ops = {
+	.is_enabled = clk_pll_is_enabled,
+	.enable = clk_pll_iddq_enable,
+	.disable = clk_pll_iddq_disable,
+	.recalc_rate = clk_pllre_recalc_rate,
+	.round_rate = clk_pllre_round_rate,
+	.set_rate = clk_pllre_set_rate,
+};
+
+const struct clk_ops tegra_clk_plle_tegra114_ops = {
+	.is_enabled =  clk_pll_is_enabled,
+	.enable = clk_plle_tegra114_enable,
+	.disable = clk_plle_tegra114_disable,
+	.recalc_rate = clk_pll_recalc_rate,
+};
+
+
+struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
+			  void __iomem *clk_base, void __iomem *pmc,
+			  unsigned long flags, unsigned long fixed_rate,
+			  struct tegra_clk_pll_params *pll_params,
+			  u32 pll_flags,
+			  struct tegra_clk_pll_freq_table *freq_table,
+			  spinlock_t *lock)
+{
+	struct tegra_clk_pll *pll;
+	struct clk *clk;
+
+	if (!pll_params->pdiv_tohw)
+		return ERR_PTR(-EINVAL);
+
+	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
+			      freq_table, lock);
+	if (IS_ERR(pll))
+		return ERR_CAST(pll);
+
+	clk = _tegra_clk_register_pll(pll, name, parent_name, flags,
+				      &tegra_clk_pllxc_ops);
+	if (IS_ERR(clk))
+		kfree(pll);
+
+	return clk;
+}
+
+struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
+			  void __iomem *clk_base, void __iomem *pmc,
+			  unsigned long flags, unsigned long fixed_rate,
+			  struct tegra_clk_pll_params *pll_params,
+			  u32 pll_flags,
+			  struct tegra_clk_pll_freq_table *freq_table,
+			  spinlock_t *lock, unsigned long parent_rate)
+{
+	u32 val;
+	struct tegra_clk_pll *pll;
+	struct clk *clk;
+
+	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
+			      freq_table, lock);
+	if (IS_ERR(pll))
+		return ERR_CAST(pll);
+
+	/* program minimum rate by default */
+
+	val = pll_readl_base(pll);
+	if (val & PLL_BASE_ENABLE)
+		WARN_ON(val & pll_params->iddq_bit_idx);
+	else {
+		int m;
+
+		m = _pll_fixed_mdiv(pll_params, parent_rate);
+		val = m << PLL_BASE_DIVM_SHIFT;
+		val |= (pll_params->vco_min / parent_rate)
+				<< PLL_BASE_DIVN_SHIFT;
+		pll_writel_base(val, pll);
+	}
+
+	/* disable lock override */
+
+	val = pll_readl_misc(pll);
+	val &= ~BIT(29);
+	pll_writel_misc(val, pll);
+
+	pll_flags |= TEGRA_PLL_LOCK_MISC;
+	clk = _tegra_clk_register_pll(pll, name, parent_name, flags,
+				      &tegra_clk_pllre_ops);
+	if (IS_ERR(clk))
+		kfree(pll);
+
+	return clk;
+}
+
+struct clk *tegra_clk_register_pllm(const char *name, const char *parent_name,
+			  void __iomem *clk_base, void __iomem *pmc,
+			  unsigned long flags, unsigned long fixed_rate,
+			  struct tegra_clk_pll_params *pll_params,
+			  u32 pll_flags,
+			  struct tegra_clk_pll_freq_table *freq_table,
+			  spinlock_t *lock)
+{
+	struct tegra_clk_pll *pll;
+	struct clk *clk;
+
+	if (!pll_params->pdiv_tohw)
+		return ERR_PTR(-EINVAL);
+
+	pll_flags |= TEGRA_PLL_BYPASS;
+	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
+			      freq_table, lock);
+	if (IS_ERR(pll))
+		return ERR_CAST(pll);
+
+	clk = _tegra_clk_register_pll(pll, name, parent_name, flags,
+				      &tegra_clk_pllxc_ops);
+	if (IS_ERR(clk))
+		kfree(pll);
+
+	return clk;
+}
+
+struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
+			  void __iomem *clk_base, void __iomem *pmc,
+			  unsigned long flags, unsigned long fixed_rate,
+			  struct tegra_clk_pll_params *pll_params,
+			  u32 pll_flags,
+			  struct tegra_clk_pll_freq_table *freq_table,
+			  spinlock_t *lock)
+{
+	struct clk *parent, *clk;
+	struct pdiv_map *p_tohw = pll_params->pdiv_tohw;
+	struct tegra_clk_pll *pll;
+	struct tegra_clk_pll_freq_table cfg;
+	unsigned long parent_rate;
+
+	if (!p_tohw)
+		return ERR_PTR(-EINVAL);
+
+	parent = __clk_lookup(parent_name);
+	if (IS_ERR(parent)) {
+		WARN(1, "parent clk %s of %s must be registered first\n",
+			name, parent_name);
+		return ERR_PTR(-EINVAL);
+	}
+
+	pll_flags |= TEGRA_PLL_BYPASS;
+	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
+			      freq_table, lock);
+	if (IS_ERR(pll))
+		return ERR_CAST(pll);
+
+	parent_rate = __clk_get_rate(parent);
+
+	/*
+	 * Most of PLLC register fields are shadowed, and can not be read
+	 * directly from PLL h/w. Hence, actual PLLC boot state is unknown.
+	 * Initialize PLL to default state: disabled, reset; shadow registers
+	 * loaded with default parameters; dividers are preset for half of
+	 * minimum VCO rate (the latter assured that shadowed divider settings
+	 * are within supported range).
+	 */
+
+	cfg.m = _pll_fixed_mdiv(pll_params, parent_rate);
+	cfg.n = cfg.m * pll_params->vco_min / parent_rate;
+
+	while (p_tohw->pdiv) {
+		if (p_tohw->pdiv == 2) {
+			cfg.p = p_tohw->hw_val;
+			break;
+		}
+		p_tohw++;
+	}
+
+	if (!p_tohw->pdiv) {
+		WARN_ON(1);
+		return ERR_PTR(-EINVAL);
+	}
+
+	pll_writel_base(0, pll);
+	_update_pll_mnp(pll, &cfg);
+
+	pll_writel_misc(PLLCX_MISC_DEFAULT, pll);
+	pll_writel(PLLCX_MISC1_DEFAULT, pll_params->ext_misc_reg[0], pll);
+	pll_writel(PLLCX_MISC2_DEFAULT, pll_params->ext_misc_reg[1], pll);
+	pll_writel(PLLCX_MISC3_DEFAULT, pll_params->ext_misc_reg[2], pll);
+
+	_pllcx_update_dynamic_coef(pll, parent_rate, cfg.n);
+
+	clk = _tegra_clk_register_pll(pll, name, parent_name, flags,
+				      &tegra_clk_pllc_ops);
+	if (IS_ERR(clk))
+		kfree(pll);
+
+	return clk;
+}
+
+struct clk *tegra_clk_register_plle_tegra114(const char *name,
+				const char *parent_name,
+				void __iomem *clk_base, unsigned long flags,
+				unsigned long fixed_rate,
+				struct tegra_clk_pll_params *pll_params,
+				struct tegra_clk_pll_freq_table *freq_table,
+				spinlock_t *lock)
+{
+	struct tegra_clk_pll *pll;
+	struct clk *clk;
+	u32 val, val_aux;
+
+	pll = _tegra_init_pll(clk_base, NULL, fixed_rate, pll_params, 0,
+			      freq_table, lock);
+	if (IS_ERR(pll))
+		return ERR_CAST(pll);
+
+	/* ensure parent is set to pll_re_vco */
+
+	val = pll_readl_base(pll);
+	val_aux = pll_readl(pll_params->aux_reg, pll);
+
+	if (val & PLL_BASE_ENABLE) {
+		if (!(val_aux & PLLE_AUX_PLLRE_SEL))
+			WARN(1, "pll_e enabled with unsupported parent %s\n",
+			  (val & PLLE_AUX_PLLP_SEL) ? "pllp_out0" : "pll_ref");
+	} else {
+		val_aux |= PLLE_AUX_PLLRE_SEL;
+		pll_writel(val, pll_params->aux_reg, pll);
+	}
+
+	clk = _tegra_clk_register_pll(pll, name, parent_name, flags,
+				      &tegra_clk_plle_tegra114_ops);
+	if (IS_ERR(clk))
+		kfree(pll);
+
+	return clk;
+}
+#endif
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 79b93ee..ea3cce2 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -156,6 +156,13 @@ struct tegra_clk_pll_params {
 	u32		lock_reg;
 	u32		lock_bit_idx;
 	u32		lock_enable_bit_idx;
+	u32		iddq_reg;
+	u32		iddq_bit_idx;
+	u32		aux_reg;
+	u32		dyn_ramp_reg;
+	u32		ext_misc_reg[3];
+	int		stepa_shift;
+	int		stepb_shift;
 	int		lock_delay;
 	int		max_p;
 	struct pdiv_map *pdiv_tohw;
@@ -236,12 +243,53 @@ struct clk *tegra_clk_register_pll(const char *name, const char *parent_name,
 		unsigned long flags, unsigned long fixed_rate,
 		struct tegra_clk_pll_params *pll_params, u32 pll_flags,
 		struct tegra_clk_pll_freq_table *freq_table, spinlock_t *lock);
+
 struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
 		unsigned long flags, unsigned long fixed_rate,
 		struct tegra_clk_pll_params *pll_params, u32 pll_flags,
 		struct tegra_clk_pll_freq_table *freq_table, spinlock_t *lock);
 
+struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
+			    void __iomem *clk_base, void __iomem *pmc,
+			    unsigned long flags, unsigned long fixed_rate,
+			    struct tegra_clk_pll_params *pll_params,
+			    u32 pll_flags,
+			    struct tegra_clk_pll_freq_table *freq_table,
+			    spinlock_t *lock);
+
+struct clk *tegra_clk_register_pllm(const char *name, const char *parent_name,
+			   void __iomem *clk_base, void __iomem *pmc,
+			   unsigned long flags, unsigned long fixed_rate,
+			   struct tegra_clk_pll_params *pll_params,
+			   u32 pll_flags,
+			   struct tegra_clk_pll_freq_table *freq_table,
+			   spinlock_t *lock);
+
+struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
+			   void __iomem *clk_base, void __iomem *pmc,
+			   unsigned long flags, unsigned long fixed_rate,
+			   struct tegra_clk_pll_params *pll_params,
+			   u32 pll_flags,
+			   struct tegra_clk_pll_freq_table *freq_table,
+			   spinlock_t *lock);
+
+struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
+			   void __iomem *clk_base, void __iomem *pmc,
+			   unsigned long flags, unsigned long fixed_rate,
+			   struct tegra_clk_pll_params *pll_params,
+			   u32 pll_flags,
+			   struct tegra_clk_pll_freq_table *freq_table,
+			   spinlock_t *lock, unsigned long parent_rate);
+
+struct clk *tegra_clk_register_plle_tegra114(const char *name,
+				const char *parent_name,
+				void __iomem *clk_base, unsigned long flags,
+				unsigned long fixed_rate,
+				struct tegra_clk_pll_params *pll_params,
+				struct tegra_clk_pll_freq_table *freq_table,
+				spinlock_t *lock);
+
 /**
  * struct tegra_clk_pll_out - PLL divider down clock
  *
-- 
1.7.1

