Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab3JOPQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:16:23 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12553 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3JOPQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:16:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Oct 2013 08:16:20 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 1/7] clk: tegra: Add support for PLLSS
Date: Tue, 15 Oct 2013 18:14:44 +0300
Message-ID: <1381850098-12357-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1381850098-12357-1-git-send-email-pdeschrijver@nvidia.com>
References: <1381850098-12357-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra124 introduces a new PLL type, PLLSS. Add support for it.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c |  172 +++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.h     |    5 +
 2 files changed, 177 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index c38c0df..ecaecc9 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -137,6 +137,36 @@
 #define PMC_SATA_PWRGT_PLLE_IDDQ_VALUE BIT(5)
 #define PMC_SATA_PWRGT_PLLE_IDDQ_SWCTL BIT(4)
 
+#define PLLSS_MISC_KCP		0
+#define PLLSS_MISC_KVCO		0
+#define PLLSS_MISC_SETUP	0
+#define PLLSS_EN_SDM		0
+#define PLLSS_EN_SSC		0
+#define PLLSS_EN_DITHER2	0
+#define PLLSS_EN_DITHER		1
+#define PLLSS_SDM_RESET		0
+#define PLLSS_CLAMP		0
+#define PLLSS_SDM_SSC_MAX	0
+#define PLLSS_SDM_SSC_MIN	0
+#define PLLSS_SDM_SSC_STEP	0
+#define PLLSS_SDM_DIN		0
+#define PLLSS_MISC_DEFAULT ((PLLSS_MISC_KCP << 25) | \
+			    (PLLSS_MISC_KVCO << 24) | \
+			    PLLSS_MISC_SETUP)
+#define PLLSS_CFG_DEFAULT ((PLLSS_EN_SDM << 31) | \
+			   (PLLSS_EN_SSC << 30) | \
+			   (PLLSS_EN_DITHER2 << 29) | \
+			   (PLLSS_EN_DITHER << 28) | \
+			   (PLLSS_SDM_RESET) << 27 | \
+			   (PLLSS_CLAMP << 22))
+#define PLLSS_CTRL1_DEFAULT \
+			((PLLSS_SDM_SSC_MAX << 16) | PLLSS_SDM_SSC_MIN)
+#define PLLSS_CTRL2_DEFAULT \
+			((PLLSS_SDM_SSC_STEP << 16) | PLLSS_SDM_DIN)
+#define PLLSS_LOCK_OVERRIDE	BIT(24)
+#define PLLSS_REF_SRC_SEL_SHIFT	25
+#define PLLSS_REF_SRC_SEL_MASK	(3 << PLLSS_REF_SRC_SEL_SHIFT)
+
 #define pll_readl(offset, p) readl_relaxed(p->clk_base + offset)
 #define pll_readl_base(p) pll_readl(p->params->base_reg, p)
 #define pll_readl_misc(p) pll_readl(p->params->misc_reg, p)
@@ -1319,6 +1349,51 @@ static void clk_plle_tegra114_disable(struct clk_hw *hw)
 }
 #endif
 
+static int clk_pllss_set_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long parent_rate)
+{
+	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	struct tegra_clk_pll_freq_table cfg, old_cfg;
+	unsigned long flags = 0;
+	int ret = 0;
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
+	if (old_cfg.m != cfg.m || old_cfg.n != cfg.n || old_cfg.p != cfg.p) {
+		u32 val;
+		int state = clk_pll_is_enabled(hw);
+
+		if (state) {
+			val = pll_readl_base(pll);
+			val &= ~PLL_BASE_ENABLE;
+			pll_writel_base(val, pll);
+			udelay(1);
+		}
+
+		_update_pll_mnp(pll, &cfg);
+
+		if (state) {
+			val = pll_readl_base(pll);
+			val |= PLL_BASE_ENABLE;
+			pll_writel_base(val, pll);
+			udelay(2);
+			clk_pll_wait_for_lock(pll);
+		}
+	}
+
+	if (pll->lock)
+		spin_unlock_irqrestore(pll->lock, flags);
+
+	return ret;
+}
+
 static struct tegra_clk_pll *_tegra_init_pll(void __iomem *clk_base,
 		void __iomem *pmc, struct tegra_clk_pll_params *pll_params,
 		spinlock_t *lock)
@@ -1698,3 +1773,100 @@ struct clk *tegra_clk_register_plle_tegra114(const char *name,
 	return clk;
 }
 #endif
+
+const struct clk_ops tegra_clk_pllss_ops = {
+	.is_enabled = clk_pll_is_enabled,
+	.enable = clk_pll_iddq_enable,
+	.disable = clk_pll_iddq_disable,
+	.recalc_rate = clk_pll_recalc_rate,
+	.round_rate = clk_pll_ramp_round_rate,
+	.set_rate = clk_pllss_set_rate,
+};
+
+struct clk *tegra_clk_register_pllss(const char *name, const char *parent_name,
+				void __iomem *clk_base, unsigned long flags,
+				struct tegra_clk_pll_params *pll_params,
+				spinlock_t *lock)
+{
+	struct tegra_clk_pll *pll;
+	struct clk *clk, *parent;
+	struct tegra_clk_pll_freq_table cfg;
+	unsigned long parent_rate;
+	u32 val;
+	int i;
+
+	if (!pll_params->div_nmp)
+		return ERR_PTR(-EINVAL);
+
+	parent = __clk_lookup(parent_name);
+	if (IS_ERR(parent)) {
+		WARN(1, "parent clk %s of %s must be registered first\n",
+			name, parent_name);
+		return ERR_PTR(-EINVAL);
+	}
+
+	pll_params->flags = TEGRA_PLL_HAS_LOCK_ENABLE | TEGRA_PLL_USE_LOCK;
+	pll = _tegra_init_pll(clk_base, NULL, pll_params, lock);
+	if (IS_ERR(pll))
+		return ERR_CAST(pll);
+
+	val = pll_readl_base(pll);
+	if (val & PLLSS_REF_SRC_SEL_MASK) {
+		WARN(1, "Unknown parent selected for %s: %d\n", name,
+			(val & PLLSS_REF_SRC_SEL_MASK) >>
+			PLLSS_REF_SRC_SEL_SHIFT);
+		kfree(pll);
+		return ERR_PTR(-EINVAL);
+	}
+
+	_get_pll_mnp(pll, &cfg);
+	if (cfg.n > 1) {
+		WARN(1, "%s should not be initialized\n", name);
+		kfree(pll);
+		return ERR_PTR(-EINVAL);
+	}
+
+	parent_rate = __clk_get_rate(parent);
+
+	pll_params->vco_min = _clip_vco_min(pll_params->vco_min, parent_rate);
+
+	cfg.m = _pll_fixed_mdiv(pll_params, parent_rate);
+	cfg.n = cfg.m * pll_params->vco_min / parent_rate;
+
+	for (i = 0; pll_params->pdiv_tohw[i].pdiv; i++)
+		;
+	if (!i) {
+		kfree(pll);
+		return ERR_PTR(-EINVAL);
+	}
+
+	cfg.p = pll_params->pdiv_tohw[i-1].hw_val;
+
+	_update_pll_mnp(pll, &cfg);
+
+	pll_writel_misc(PLLSS_MISC_DEFAULT, pll);
+	pll_writel(PLLSS_CFG_DEFAULT, pll_params->ext_misc_reg[0], pll);
+	pll_writel(PLLSS_CTRL1_DEFAULT, pll_params->ext_misc_reg[1], pll);
+	pll_writel(PLLSS_CTRL1_DEFAULT, pll_params->ext_misc_reg[2], pll);
+
+	val = pll_readl_base(pll);
+	if (val & PLL_BASE_ENABLE) {
+		if (val & BIT(pll_params->iddq_bit_idx)) {
+			WARN(1, "%s is on but IDDQ set\n", name);
+			kfree(pll);
+			return ERR_PTR(-EINVAL);
+		}
+	} else
+		val |= BIT(pll_params->iddq_bit_idx);
+
+	val &= ~PLLSS_LOCK_OVERRIDE;
+	pll_writel_base(val, pll);
+
+	clk = _tegra_clk_register_pll(pll, name, parent_name, flags,
+					&tegra_clk_pllss_ops);
+
+	if (IS_ERR(clk))
+		kfree(pll);
+
+	return clk;
+}
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index da69e3a..936abd0 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -298,6 +298,11 @@ struct clk *tegra_clk_register_plle_tegra114(const char *name,
 				struct tegra_clk_pll_params *pll_params,
 				spinlock_t *lock);
 
+struct clk *tegra_clk_register_pllss(const char *name, const char *parent_name,
+			   void __iomem *clk_base, unsigned long flags,
+			   struct tegra_clk_pll_params *pll_params,
+			   spinlock_t *lock);
+
 /**
  * struct tegra_clk_pll_out - PLL divider down clock
  *
-- 
1.7.7.rc0.72.g4b5ea.dirty

