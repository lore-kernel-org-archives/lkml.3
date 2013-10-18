Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3JRNpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:45:13 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15799 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3JRNpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:45:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 18 Oct 2013 06:45:11 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 1/7] clk: tegra: Add support for PLLSS
Date: Fri, 18 Oct 2013 16:44:58 +0300
Message-ID: <1382103904-6398-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382103904-6398-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382103904-6398-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra124 introduces a new PLL type, PLLSS. Add support for it.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c |  123 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/clk/tegra/clk.h     |    5 ++
 2 files changed, 126 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 0550a43..7d775a9 100644
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
@@ -762,7 +792,7 @@ const struct clk_ops tegra_clk_plle_ops = {
 	.enable = clk_plle_enable,
 };
 
-#ifdef CONFIG_ARCH_TEGRA_114_SOC
+#if defined(CONFIG_ARCH_TEGRA_114_SOC) || defined(CONFIG_ARCH_TEGRA_124_SOC)
 
 static int _pll_fixed_mdiv(struct tegra_clk_pll_params *pll_params,
 			   unsigned long parent_rate)
@@ -1403,7 +1433,7 @@ struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
 	return clk;
 }
 
-#ifdef CONFIG_ARCH_TEGRA_114_SOC
+#if defined(CONFIG_ARCH_TEGRA_114_SOC) || defined(CONFIG_ARCH_TEGRA_124_SOC)
 const struct clk_ops tegra_clk_pllxc_ops = {
 	.is_enabled = clk_pll_is_enabled,
 	.enable = clk_pll_iddq_enable,
@@ -1698,3 +1728,92 @@ struct clk *tegra_clk_register_plle_tegra114(const char *name,
 	return clk;
 }
 #endif
+
+#ifdef CONFIG_ARCH_TEGRA_124_SOC
+const struct clk_ops tegra_clk_pllss_ops = {
+	.is_enabled = clk_pll_is_enabled,
+	.enable = clk_pll_iddq_enable,
+	.disable = clk_pll_iddq_disable,
+	.recalc_rate = clk_pll_recalc_rate,
+	.round_rate = clk_pll_ramp_round_rate,
+	.set_rate = clk_pllxc_set_rate,
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
+	val &= ~PLLSS_REF_SRC_SEL_MASK;
+	pll_writel_base(val, pll);
+
+	parent_rate = __clk_get_rate(parent);
+
+	pll_params->vco_min = _clip_vco_min(pll_params->vco_min, parent_rate);
+
+	/* initialize PLL to minimum rate */
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
+#endif
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 05abfc5..7f110ac 100644
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

