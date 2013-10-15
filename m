Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab3JOPRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:17:31 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18038 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3JOPR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:17:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Oct 2013 08:17:27 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Joseph Lo <josephl@nvidia.com>, Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 7/7] clk: tegra124: add suspend/resume function for tegra_cpu_car_ops
Date: Tue, 15 Oct 2013 18:14:50 +0300
Message-ID: <1381850098-12357-8-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1381850098-12357-1-git-send-email-pdeschrijver@nvidia.com>
References: <1381850098-12357-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Lo <josephl@nvidia.com>

Adding suspend/resume function for tegra_cpu_car_ops. We only save and
restore the setting of the clock of CoreSight. Other clocks still need
to be taken care by clock driver.

Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Joseph Lo <josephl@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/clk/tegra/clk-tegra124.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 22fce42..2a4c5c3 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -28,6 +28,7 @@
 #include "clk.h"
 #include "clk-id.h"
 
+#define CLK_SOURCE_CSITE 0x1d4
 #define CLK_SOURCE_EMC 0x19c
 #define CLK_SOURCE_XUSB_SS_SRC 0x610
 
@@ -117,6 +118,12 @@
 /* Tegra CPU clock and reset control regs */
 #define CLK_RST_CONTROLLER_CPU_CMPLX_STATUS	0x470
 
+#ifdef CONFIG_PM_SLEEP
+static struct cpu_clk_suspend_context {
+	u32 clk_csite_src;
+} tegra124_cpu_clk_sctx;
+#endif
+
 static void __iomem *clk_base;
 static void __iomem *pmc_base;
 
@@ -1308,9 +1315,29 @@ static void tegra124_disable_cpu_clock(u32 cpu)
 	/* flow controller would take care in the power sequence. */
 }
 
+#ifdef CONFIG_PM_SLEEP
+static void tegra124_cpu_clock_suspend(void)
+{
+	/* switch coresite to clk_m, save off original source */
+	tegra124_cpu_clk_sctx.clk_csite_src =
+				readl(clk_base + CLK_SOURCE_CSITE);
+	writel(3 << 30, clk_base + CLK_SOURCE_CSITE);
+}
+
+static void tegra124_cpu_clock_resume(void)
+{
+	writel(tegra124_cpu_clk_sctx.clk_csite_src,
+				clk_base + CLK_SOURCE_CSITE);
+}
+#endif
+
 static struct tegra_cpu_car_ops tegra124_cpu_car_ops = {
 	.wait_for_reset	= tegra124_wait_cpu_in_reset,
 	.disable_clock	= tegra124_disable_cpu_clock,
+#ifdef CONFIG_PM_SLEEP
+	.suspend	= tegra124_cpu_clock_suspend,
+	.resume		= tegra124_cpu_clock_resume,
+#endif
 };
 
 static const struct of_device_id pmc_match[] __initconst = {
-- 
1.7.7.rc0.72.g4b5ea.dirty

