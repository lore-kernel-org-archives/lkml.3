Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967049AbaFQVwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:52:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54734 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966954AbaFQVwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 138/212] clk: tegra: use pll_ref as the pll_e parent
Date: Tue, 17 Jun 2014 14:43:52 -0700
Message-Id: <1403041506-13646-139-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter De Schrijver <pdeschrijver@nvidia.com>

commit 8e9cc80aa348938078c3c1a7ab55efb3c40990e3 upstream.

Use pll_ref instead of pll_re_vco as the pll_e parent on Tegra114. Also
add a 12Mhz pll_ref table entry for pll_e for Tegra114. This prevents
the system from crashing at bootup because of an unsupported pll_re_vco
rate.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
[ kamal: 3.13-stable prereq for
  d2c834a clk: tegra: Fix wrong value written to PLLE_AUX ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/clk/tegra/clk-pll.c      | 8 +++++---
 drivers/clk/tegra/clk-tegra114.c | 3 ++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 197074a..e09f09c 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -1587,11 +1587,13 @@ struct clk *tegra_clk_register_plle_tegra114(const char *name,
 	val_aux = pll_readl(pll_params->aux_reg, pll);
 
 	if (val & PLL_BASE_ENABLE) {
-		if (!(val_aux & PLLE_AUX_PLLRE_SEL))
+		if ((val_aux & PLLE_AUX_PLLRE_SEL) ||
+			(val_aux & PLLE_AUX_PLLP_SEL))
 			WARN(1, "pll_e enabled with unsupported parent %s\n",
-			  (val & PLLE_AUX_PLLP_SEL) ? "pllp_out0" : "pll_ref");
+			  (val_aux & PLLE_AUX_PLLP_SEL) ? "pllp_out0" :
+					"pll_re_vco");
 	} else {
-		val_aux |= PLLE_AUX_PLLRE_SEL;
+		val_aux &= ~(PLLE_AUX_PLLRE_SEL | PLLE_AUX_PLLP_SEL);
 		pll_writel(val, pll_params->aux_reg, pll);
 	}
 
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 9467da7..406929d 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -673,6 +673,7 @@ static struct tegra_clk_pll_freq_table pll_e_freq_table[] = {
 	/* PLLE special case: use cpcon field to store cml divider value */
 	{336000000, 100000000, 100, 21, 16, 11},
 	{312000000, 100000000, 200, 26, 24, 13},
+	{12000000, 100000000, 200,  1,  24, 13},
 	{0, 0, 0, 0, 0, 0},
 };
 
@@ -1501,7 +1502,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clks[pll_re_out] = clk;
 
 	/* PLLE */
-	clk = tegra_clk_register_plle_tegra114("pll_e_out0", "pll_re_vco",
+	clk = tegra_clk_register_plle_tegra114("pll_e_out0", "pll_ref",
 				      clk_base, 0, 100000000, &pll_e_params,
 				      pll_e_freq_table, NULL);
 	clk_register_clkdev(clk, "pll_e_out0", NULL);
-- 
1.9.1

