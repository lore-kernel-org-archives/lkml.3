Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbaGUPnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:43:09 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11247 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052AbaGUPkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:40:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Jul 2014 08:32:24 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, <devicetree@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v2 09/16] clk: tegra: Save/restore CCLKG_BURST_POLICY on suspend
Date: Mon, 21 Jul 2014 18:38:55 +0300
Message-ID: <1405957142-19416-10-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save and restore this register since the LP1 restore assembly routines
fiddle with it. Otherwise the CPU would keep running on PLLX after
resume from suspend even when DFLL was the original clocksource.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
v2 changes:
    - none

 drivers/clk/tegra/clk-tegra124.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 77fbf38..758a4cf 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -89,6 +89,8 @@
 #define PMC_PLLM_WB0_OVERRIDE 0x1dc
 #define PMC_PLLM_WB0_OVERRIDE_2 0x2b0
 
+#define CCLKG_BURST_POLICY 0x368
+
 #define UTMIP_PLL_CFG2 0x488
 #define UTMIP_PLL_CFG2_STABLE_COUNT(x) (((x) & 0xffff) << 6)
 #define UTMIP_PLL_CFG2_ACTIVE_DLY_COUNT(x) (((x) & 0x3f) << 18)
@@ -121,6 +123,8 @@
 #ifdef CONFIG_PM_SLEEP
 static struct cpu_clk_suspend_context {
 	u32 clk_csite_src;
+	u32 cclkg_burst;
+	u32 cclkg_divider;
 } tegra124_cpu_clk_sctx;
 #endif
 
@@ -1318,12 +1322,22 @@ static void tegra124_cpu_clock_suspend(void)
 	tegra124_cpu_clk_sctx.clk_csite_src =
 				readl(clk_base + CLK_SOURCE_CSITE);
 	writel(3 << 30, clk_base + CLK_SOURCE_CSITE);
+
+	tegra124_cpu_clk_sctx.cclkg_burst =
+				readl(clk_base + CCLKG_BURST_POLICY);
+	tegra124_cpu_clk_sctx.cclkg_divider =
+				readl(clk_base + CCLKG_BURST_POLICY + 4);
 }
 
 static void tegra124_cpu_clock_resume(void)
 {
 	writel(tegra124_cpu_clk_sctx.clk_csite_src,
 				clk_base + CLK_SOURCE_CSITE);
+
+	writel(tegra124_cpu_clk_sctx.cclkg_burst,
+					clk_base + CCLKG_BURST_POLICY);
+	writel(tegra124_cpu_clk_sctx.cclkg_divider,
+					clk_base + CCLKG_BURST_POLICY + 4);
 }
 #endif
 
-- 
1.8.1.5

