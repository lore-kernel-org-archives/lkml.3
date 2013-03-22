Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab3CVMps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:45:48 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16901 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab3CVMpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:45:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 22 Mar 2013 05:45:32 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Andrew Chew <achew@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 04/14] clk: tegra: introduce TEGRA_PLL_HAS_LOCK_ENABLE
Date: Fri, 22 Mar 2013 14:39:21 +0200
Message-ID: <1363956029-31873-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1363956029-31873-1-git-send-email-pdeschrijver@nvidia.com>
References: <1363956029-31873-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra114 PLLC2 and PLLC3 don't have a lock enable bit. The lock bits are
always functional.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c |    5 +++++
 drivers/clk/tegra/clk.h     |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 4ee6d03..eaab060 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -108,6 +108,9 @@ static void clk_pll_enable_lock(struct tegra_clk_pll *pll)
 	if (!(pll->flags & TEGRA_PLL_USE_LOCK))
 		return;
 
+	if (!(pll->flags & TEGRA_PLL_HAS_LOCK_ENABLE))
+		return;
+
 	val = pll_readl_misc(pll);
 	val |= BIT(pll->params->lock_enable_bit_idx);
 	pll_writel_misc(val, pll);
@@ -675,6 +678,7 @@ struct clk *tegra_clk_register_pll(const char *name, const char *parent_name,
 	struct clk *clk;
 
 	pll_flags |= TEGRA_PLL_BYPASS;
+	pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
 	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
 			      freq_table, lock);
 	if (IS_ERR(pll))
@@ -698,6 +702,7 @@ struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
 	struct clk *clk;
 
 	pll_flags |= TEGRA_PLL_LOCK_MISC | TEGRA_PLL_BYPASS;
+	pll_flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
 	pll = _tegra_init_pll(clk_base, pmc, fixed_rate, pll_params, pll_flags,
 			      freq_table, lock);
 	if (IS_ERR(pll))
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 2697aa8..04049d7 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -185,6 +185,7 @@ struct tegra_clk_pll_params {
  * TEGRA_PLL_LOCK_MISC - Lock bit is in the misc register instead of the
  *     base register.
  * TEGRA_PLL_BYPASS - PLL has bypass bit
+ * TEGRA_PLL_HAS_LOCK_ENABLE - PLL has bit to enable lock monitoring
  */
 struct tegra_clk_pll {
 	struct clk_hw	hw;
@@ -215,6 +216,7 @@ struct tegra_clk_pll {
 #define TEGRA_PLLE_CONFIGURE BIT(7)
 #define TEGRA_PLL_LOCK_MISC BIT(8)
 #define TEGRA_PLL_BYPASS BIT(9)
+#define TEGRA_PLL_HAS_LOCK_ENABLE BIT(10)
 
 extern const struct clk_ops tegra_clk_pll_ops;
 extern const struct clk_ops tegra_clk_plle_ops;
-- 
1.7.7.rc0.72.g4b5ea.dirty

