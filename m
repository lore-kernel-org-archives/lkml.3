Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab3DCOtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:49:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11190 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3DCOt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:49:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 03 Apr 2013 07:49:15 -0700
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
Subject: [PATCH v9 06/14] clk: tegra: move from a lock bit idx to a lock mask
Date: Wed, 3 Apr 2013 17:40:40 +0300
Message-ID: <1365000110-8916-7-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com>
References: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PLLC2 and PLLC3 on Tegra114 have separate phaselock and frequencylock bits.
So switch to a lock mask to be able to test both at the same time.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-pll.c     |    6 +++---
 drivers/clk/tegra/clk-tegra20.c |   20 ++++++++++----------
 drivers/clk/tegra/clk-tegra30.c |   22 +++++++++++-----------
 drivers/clk/tegra/clk.h         |    2 +-
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index ccb367e..0b96352 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -119,7 +119,7 @@ static void clk_pll_enable_lock(struct tegra_clk_pll *pll)
 static int clk_pll_wait_for_lock(struct tegra_clk_pll *pll)
 {
 	int i;
-	u32 val, lock_bit;
+	u32 val, lock_mask;
 	void __iomem *lock_addr;
 
 	if (!(pll->flags & TEGRA_PLL_USE_LOCK)) {
@@ -133,11 +133,11 @@ static int clk_pll_wait_for_lock(struct tegra_clk_pll *pll)
 	else
 		lock_addr += pll->params->base_reg;
 
-	lock_bit = BIT(pll->params->lock_bit_idx);
+	lock_mask = pll->params->lock_mask;
 
 	for (i = 0; i < pll->params->lock_delay; i++) {
 		val = readl_relaxed(lock_addr);
-		if (val & lock_bit) {
+		if ((val & lock_mask) == lock_mask) {
 			udelay(PLL_POST_LOCK_DELAY);
 			return 0;
 		}
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index b1a49cb..b6a747f 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -86,8 +86,8 @@
 #define PLLE_BASE 0xe8
 #define PLLE_MISC 0xec
 
-#define PLL_BASE_LOCK 27
-#define PLLE_MISC_LOCK 11
+#define PLL_BASE_LOCK BIT(27)
+#define PLLE_MISC_LOCK BIT(11)
 
 #define PLL_MISC_LOCK_ENABLE 18
 #define PLLDU_MISC_LOCK_ENABLE 22
@@ -380,7 +380,7 @@ static struct tegra_clk_pll_params pll_c_params = {
 	.vco_max = 1400000000,
 	.base_reg = PLLC_BASE,
 	.misc_reg = PLLC_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 };
@@ -394,7 +394,7 @@ static struct tegra_clk_pll_params pll_m_params = {
 	.vco_max = 1200000000,
 	.base_reg = PLLM_BASE,
 	.misc_reg = PLLM_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 };
@@ -408,7 +408,7 @@ static struct tegra_clk_pll_params pll_p_params = {
 	.vco_max = 1400000000,
 	.base_reg = PLLP_BASE,
 	.misc_reg = PLLP_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 };
@@ -422,7 +422,7 @@ static struct tegra_clk_pll_params pll_a_params = {
 	.vco_max = 1400000000,
 	.base_reg = PLLA_BASE,
 	.misc_reg = PLLA_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 };
@@ -436,7 +436,7 @@ static struct tegra_clk_pll_params pll_d_params = {
 	.vco_max = 1000000000,
 	.base_reg = PLLD_BASE,
 	.misc_reg = PLLD_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
 };
@@ -456,7 +456,7 @@ static struct tegra_clk_pll_params pll_u_params = {
 	.vco_max = 960000000,
 	.base_reg = PLLU_BASE,
 	.misc_reg = PLLU_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
 	.pdiv_tohw = pllu_p,
@@ -471,7 +471,7 @@ static struct tegra_clk_pll_params pll_x_params = {
 	.vco_max = 1200000000,
 	.base_reg = PLLX_BASE,
 	.misc_reg = PLLX_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 };
@@ -485,7 +485,7 @@ static struct tegra_clk_pll_params pll_e_params = {
 	.vco_max = 0,
 	.base_reg = PLLE_BASE,
 	.misc_reg = PLLE_MISC,
-	.lock_bit_idx = PLLE_MISC_LOCK,
+	.lock_mask = PLLE_MISC_LOCK,
 	.lock_enable_bit_idx = PLLE_MISC_LOCK_ENABLE,
 	.lock_delay = 0,
 };
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 102bcbb..9c43bb4 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -116,8 +116,8 @@
 #define PLLDU_MISC_LOCK_ENABLE 22
 #define PLLE_MISC_LOCK_ENABLE 9
 
-#define PLL_BASE_LOCK 27
-#define PLLE_MISC_LOCK 11
+#define PLL_BASE_LOCK BIT(27)
+#define PLLE_MISC_LOCK BIT(11)
 
 #define PLLE_AUX 0x48c
 #define PLLC_OUT 0x84
@@ -559,7 +559,7 @@ static struct tegra_clk_pll_params pll_c_params = {
 	.vco_max = 1400000000,
 	.base_reg = PLLC_BASE,
 	.misc_reg = PLLC_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 };
@@ -573,7 +573,7 @@ static struct tegra_clk_pll_params pll_m_params = {
 	.vco_max = 1200000000,
 	.base_reg = PLLM_BASE,
 	.misc_reg = PLLM_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 };
@@ -587,7 +587,7 @@ static struct tegra_clk_pll_params pll_p_params = {
 	.vco_max = 1400000000,
 	.base_reg = PLLP_BASE,
 	.misc_reg = PLLP_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 };
@@ -601,7 +601,7 @@ static struct tegra_clk_pll_params pll_a_params = {
 	.vco_max = 1400000000,
 	.base_reg = PLLA_BASE,
 	.misc_reg = PLLA_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 };
@@ -615,7 +615,7 @@ static struct tegra_clk_pll_params pll_d_params = {
 	.vco_max = 1000000000,
 	.base_reg = PLLD_BASE,
 	.misc_reg = PLLD_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
 };
@@ -629,7 +629,7 @@ static struct tegra_clk_pll_params pll_d2_params = {
 	.vco_max = 1000000000,
 	.base_reg = PLLD2_BASE,
 	.misc_reg = PLLD2_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
 };
@@ -643,7 +643,7 @@ static struct tegra_clk_pll_params pll_u_params = {
 	.vco_max = 960000000,
 	.base_reg = PLLU_BASE,
 	.misc_reg = PLLU_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
 	.lock_delay = 1000,
 	.pdiv_tohw = pllu_p,
@@ -658,7 +658,7 @@ static struct tegra_clk_pll_params pll_x_params = {
 	.vco_max = 1700000000,
 	.base_reg = PLLX_BASE,
 	.misc_reg = PLLX_MISC,
-	.lock_bit_idx = PLL_BASE_LOCK,
+	.lock_mask = PLL_BASE_LOCK,
 	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 };
@@ -672,7 +672,7 @@ static struct tegra_clk_pll_params pll_e_params = {
 	.vco_max = 2400000000U,
 	.base_reg = PLLE_BASE,
 	.misc_reg = PLLE_MISC,
-	.lock_bit_idx = PLLE_MISC_LOCK,
+	.lock_mask = PLLE_MISC_LOCK,
 	.lock_enable_bit_idx = PLLE_MISC_LOCK_ENABLE,
 	.lock_delay = 300,
 };
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 925da45..3b498e0 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -154,7 +154,7 @@ struct tegra_clk_pll_params {
 	u32		base_reg;
 	u32		misc_reg;
 	u32		lock_reg;
-	u32		lock_bit_idx;
+	u32		lock_mask;
 	u32		lock_enable_bit_idx;
 	int		lock_delay;
 	int		max_p;
-- 
1.7.7.rc0.72.g4b5ea.dirty

