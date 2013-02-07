Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab3BGQlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:41:22 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5148 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3BGQlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:41:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 07 Feb 2013 08:40:52 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: Add missing spinlock for hclk and pclk
Date: Thu, 7 Feb 2013 18:37:35 +0200
Message-ID: <1360255064-28833-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hclk and pclk clocks are controlled by the same register. Hence a lock is
required to avoid corruption.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra20.c |   11 +++++++----
 drivers/clk/tegra/clk-tegra30.c |   11 +++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 5d41569..4612b2e 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -194,6 +194,7 @@ static void __iomem *clk_base;
 static void __iomem *pmc_base;
 
 static DEFINE_SPINLOCK(pll_div_lock);
+static DEFINE_SPINLOCK(sysrate_lock);
 
 #define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
 			    _clk_num, _regs, _gate_flags, _clk_id)	\
@@ -768,19 +769,21 @@ static void tegra20_super_clk_init(void)
 
 	/* HCLK */
 	clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
-				   clk_base + CLK_SYSTEM_RATE, 4, 2, 0, NULL);
+				   clk_base + CLK_SYSTEM_RATE, 4, 2, 0,
+				   &sysrate_lock);
 	clk = clk_register_gate(NULL, "hclk", "hclk_div", CLK_SET_RATE_PARENT,
 				clk_base + CLK_SYSTEM_RATE, 7,
-				CLK_GATE_SET_TO_DISABLE, NULL);
+				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
 	clk_register_clkdev(clk, "hclk", NULL);
 	clks[hclk] = clk;
 
 	/* PCLK */
 	clk = clk_register_divider(NULL, "pclk_div", "hclk", 0,
-				   clk_base + CLK_SYSTEM_RATE, 0, 2, 0, NULL);
+				   clk_base + CLK_SYSTEM_RATE, 0, 2, 0,
+				   &sysrate_lock);
 	clk = clk_register_gate(NULL, "pclk", "pclk_div", CLK_SET_RATE_PARENT,
 				clk_base + CLK_SYSTEM_RATE, 3,
-				CLK_GATE_SET_TO_DISABLE, NULL);
+				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
 	clk_register_clkdev(clk, "pclk", NULL);
 	clks[pclk] = clk;
 
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index d169ef0..c5415ce 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -275,6 +275,7 @@ static DEFINE_SPINLOCK(clk_out_lock);
 static DEFINE_SPINLOCK(pll_div_lock);
 static DEFINE_SPINLOCK(cml_lock);
 static DEFINE_SPINLOCK(pll_d_lock);
+static DEFINE_SPINLOCK(sysrate_lock);
 
 #define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
 			    _clk_num, _regs, _gate_flags, _clk_id)	\
@@ -1348,19 +1349,21 @@ static void __init tegra30_super_clk_init(void)
 
 	/* HCLK */
 	clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
-				   clk_base + SYSTEM_CLK_RATE, 4, 2, 0, NULL);
+				   clk_base + SYSTEM_CLK_RATE, 4, 2, 0,
+				   &sysrate_lock);
 	clk = clk_register_gate(NULL, "hclk", "hclk_div", CLK_SET_RATE_PARENT,
 				clk_base + SYSTEM_CLK_RATE, 7,
-				CLK_GATE_SET_TO_DISABLE, NULL);
+				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
 	clk_register_clkdev(clk, "hclk", NULL);
 	clks[hclk] = clk;
 
 	/* PCLK */
 	clk = clk_register_divider(NULL, "pclk_div", "hclk", 0,
-				   clk_base + SYSTEM_CLK_RATE, 0, 2, 0, NULL);
+				   clk_base + SYSTEM_CLK_RATE, 0, 2, 0,
+				   &sysrate_lock);
 	clk = clk_register_gate(NULL, "pclk", "pclk_div", CLK_SET_RATE_PARENT,
 				clk_base + SYSTEM_CLK_RATE, 3,
-				CLK_GATE_SET_TO_DISABLE, NULL);
+				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
 	clk_register_clkdev(clk, "pclk", NULL);
 	clks[pclk] = clk;
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

