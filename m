Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3JQNN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:13:58 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16446 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3JQNNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:13:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 Oct 2013 06:09:27 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Joseph Lo <josephl@nvidia.com>, Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 6/7] clk: tegra124: add wait_for_reset and disable_clock for tegra_cpu_car_ops
Date: Thu, 17 Oct 2013 16:13:19 +0300
Message-ID: <1382015600-20178-7-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382015600-20178-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382015600-20178-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Lo <josephl@nvidia.com>

Hook the functions for CPU hotplug support. After the CPU is hot
unplugged, the flow controller will handle to clock gate the CPU clock.
But still need to implement an empty function to avoid warning message.

Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Joseph Lo <josephl@nvidia.com>
---
 drivers/clk/tegra/clk-tegra124.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 739c419..a4117f3 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -114,6 +114,9 @@
 #define UTMIPLL_HW_PWRDN_CFG0_IDDQ_OVERRIDE	BIT(1)
 #define UTMIPLL_HW_PWRDN_CFG0_IDDQ_SWCTL	BIT(0)
 
+/* Tegra CPU clock and reset control regs */
+#define CLK_RST_CONTROLLER_CPU_CMPLX_STATUS	0x470
+
 static void __iomem *clk_base;
 static void __iomem *pmc_base;
 
@@ -1288,6 +1291,27 @@ static void __init tegra124_pll_init(void __iomem *clk_base,
 
 }
 
+/* Tegra124 CPU clock and reset control functions */
+static void tegra124_wait_cpu_in_reset(u32 cpu)
+{
+	unsigned int reg;
+
+	do {
+		reg = readl(clk_base + CLK_RST_CONTROLLER_CPU_CMPLX_STATUS);
+		cpu_relax();
+	} while (!(reg & (1 << cpu)));  /* check CPU been reset or not */
+}
+
+static void tegra124_disable_cpu_clock(u32 cpu)
+{
+	/* flow controller would take care in the power sequence. */
+}
+
+static struct tegra_cpu_car_ops tegra124_cpu_car_ops = {
+	.wait_for_reset	= tegra124_wait_cpu_in_reset,
+	.disable_clock	= tegra124_disable_cpu_clock,
+};
+
 static const struct of_device_id pmc_match[] __initconst = {
 	{ .compatible = "nvidia,tegra124-pmc" },
 	{},
@@ -1371,5 +1395,7 @@ static void __init tegra124_clock_init(struct device_node *np)
 	tegra_register_devclks(devclks, ARRAY_SIZE(devclks));
 
 	tegra_clk_apply_init_table = tegra124_clock_apply_init_table;
+
+	tegra_cpu_car_ops = &tegra124_cpu_car_ops;
 }
 CLK_OF_DECLARE(tegra124, "nvidia,tegra124-car", tegra124_clock_init);
-- 
1.7.7.rc0.72.g4b5ea.dirty

