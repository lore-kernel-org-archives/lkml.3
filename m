Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946437Ab3BHNhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 08:37:45 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13686 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946333Ab3BHNhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 08:37:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 08 Feb 2013 05:34:23 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 03/10] clk: tegra: Add PLL post divider table
Date: Fri, 8 Feb 2013 15:36:35 +0200
Message-ID: <1360330602-30472-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1360330602-30472-1-git-send-email-pdeschrijver@nvidia.com>
References: <1360330602-30472-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PLLs in Tegra114 don't use a power of 2 mapping for the post divider.
Introduce a table based approach and switch PLLU to it.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c     |   38 ++++++++++++++++++++++++++++++++------
 drivers/clk/tegra/clk-tegra20.c |    7 +++++++
 drivers/clk/tegra/clk-tegra30.c |    7 +++++++
 drivers/clk/tegra/clk.h         |   13 +++++++++++++
 4 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 4ee6d03..08f4eb7 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -263,6 +263,7 @@ static int _calc_rate(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
 		      unsigned long rate, unsigned long parent_rate)
 {
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
+	struct pdiv_map *p_tohw = pll->params->pdiv_tohw;
 	unsigned long cfreq;
 	u32 p_div = 0;
 
@@ -296,7 +297,6 @@ static int _calc_rate(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
 	     cfg->output_rate <<= 1)
 		p_div++;
 
-	cfg->p = p_div;
 	cfg->m = parent_rate / cfreq;
 	cfg->n = cfg->output_rate / cfreq;
 	cfg->cpcon = OUT_OF_TABLE_CPCON;
@@ -309,8 +309,19 @@ static int _calc_rate(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
 		return -EINVAL;
 	}
 
-	if (pll->flags & TEGRA_PLLU)
-		cfg->p ^= 1;
+	if (p_tohw) {
+		p_div = 1 << p_div;
+		while (p_tohw->pdiv) {
+			if (p_div <= p_tohw->pdiv) {
+				cfg->p = p_tohw->hw_val;
+				break;
+			}
+			p_tohw++;
+		}
+		if (!p_tohw->pdiv)
+			return -EINVAL;
+	} else
+		cfg->p = p_div;
 
 	return 0;
 }
@@ -457,8 +468,10 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
 {
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
 	struct tegra_clk_pll_freq_table cfg;
+	struct pdiv_map *p_tohw = pll->params->pdiv_tohw;
 	u32 val;
 	u64 rate = parent_rate;
+	int pdiv;
 
 	val = pll_readl_base(pll);
 
@@ -477,10 +490,23 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hw,
 
 	_get_pll_mnp(pll, &cfg);
 
-	if (pll->flags & TEGRA_PLLU)
-		cfg.p ^= 1;
+	if (p_tohw) {
+		while (p_tohw->pdiv) {
+			if (cfg.p == p_tohw->hw_val) {
+				pdiv = p_tohw->pdiv;
+				break;
+			}
+			p_tohw++;
+		}
+
+		if (!p_tohw->pdiv) {
+			WARN_ON(1);
+			pdiv = 1;
+		}
+	} else
+		pdiv = 1 << cfg.p;
 
-	cfg.m *= 1 << cfg.p;
+	cfg.m *= pdiv;
 
 	rate *= cfg.n;
 	do_div(rate, cfg.m);
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 30bd3fd..54c6777 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -440,6 +440,12 @@ static struct tegra_clk_pll_params pll_d_params = {
 	.lock_delay = 1000,
 };
 
+static struct pdiv_map pllu_p[] = {
+	{ .pdiv = 1, .hw_val = 1 },
+	{ .pdiv = 2, .hw_val = 0 },
+	{ .pdiv = 0, .hw_val = 0 },
+};
+
 static struct tegra_clk_pll_params pll_u_params = {
 	.input_min = 2000000,
 	.input_max = 40000000,
@@ -452,6 +458,7 @@ static struct tegra_clk_pll_params pll_u_params = {
 	.lock_bit_idx = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
+	.pdiv_tohw = pllu_p,
 };
 
 static struct tegra_clk_pll_params pll_x_params = {
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 28a2997..078f9b8 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -466,6 +466,12 @@ static struct tegra_clk_pll_freq_table pll_d_freq_table[] = {
 	{ 0, 0, 0, 0, 0, 0 },
 };
 
+static struct pdiv_map pllu_p[] = {
+	{ .pdiv = 1, .hw_val = 1 },
+	{ .pdiv = 2, .hw_val = 0 },
+	{ .pdiv = 0, .hw_val = 0 },
+};
+
 static struct tegra_clk_pll_freq_table pll_u_freq_table[] = {
 	{ 12000000, 480000000, 960, 12, 0, 12},
 	{ 13000000, 480000000, 960, 13, 0, 12},
@@ -639,6 +645,7 @@ static struct tegra_clk_pll_params pll_u_params = {
 	.lock_bit_idx = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
+	.pdiv_tohw = pllu_p,
 };
 
 static struct tegra_clk_pll_params pll_x_params = {
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 2697aa8..79b93ee 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -117,6 +117,17 @@ struct tegra_clk_pll_freq_table {
 };
 
 /**
+ * struct pdiv_map - map post divider to hw value
+ *
+ * @pdiv:		post divider
+ * @hw_val:		value to be written to the PLL hw
+ */
+struct pdiv_map {
+	u8 pdiv;
+	u8 hw_val;
+};
+
+/**
  * struct clk_pll_params - PLL parameters
  *
  * @input_min:			Minimum input frequency
@@ -146,6 +157,8 @@ struct tegra_clk_pll_params {
 	u32		lock_bit_idx;
 	u32		lock_enable_bit_idx;
 	int		lock_delay;
+	int		max_p;
+	struct pdiv_map *pdiv_tohw;
 };
 
 /**
-- 
1.7.1

