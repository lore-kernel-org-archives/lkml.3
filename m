Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaGOP0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:26:44 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8494 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbaGOP0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:26:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Jul 2014 08:15:23 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 5/6] clk: tegra: Add support for Tegra132 CAR clocks
Date: Tue, 15 Jul 2014 18:24:35 +0300
Message-ID: <1405437890-6468-6-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra132 CAR supports almost the same clocks as Tegra124 CAR. This patch
deals with the small differences.

--
I'm not entirely sure why the soc_therm clock needs to be enabled on Tegra132,
but turning it off results in a system hang. I presume this might be because
of fastboot initializing soc_therm.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra124.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 80efe51..b857aab 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -1369,6 +1369,7 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{TEGRA124_CLK_XUSB_HS_SRC, TEGRA124_CLK_PLL_U_60M, 60000000, 0},
 	{TEGRA124_CLK_XUSB_FALCON_SRC, TEGRA124_CLK_PLL_RE_OUT, 224000000, 0},
 	{TEGRA124_CLK_XUSB_HOST_SRC, TEGRA124_CLK_PLL_RE_OUT, 112000000, 0},
+	{TEGRA124_CLK_SOC_THERM, TEGRA124_CLK_PLL_P, 51000000, 0},
 	/* This MUST be the last entry. */
 	{TEGRA124_CLK_CLK_MAX, TEGRA124_CLK_CLK_MAX, 0, 0},
 };
@@ -1378,9 +1379,25 @@ static void __init tegra124_clock_apply_init_table(void)
 	tegra_init_from_table(init_table, clks, TEGRA124_CLK_CLK_MAX);
 }
 
+enum {
+	TEGRA124_CLK,
+	TEGRA132_CLK,
+};
+
+static const struct of_device_id tegra_clock_of_match[] = {
+	{ .compatible = "nvidia,tegra124-car", .data = (void *)TEGRA124_CLK },
+	{ .compatible = "nvidia,tegra132-car", .data = (void *)TEGRA132_CLK },
+	{},
+};
+
 static void __init tegra124_clock_init(struct device_node *np)
 {
 	struct device_node *node;
+	const struct of_device_id *match;
+	uintptr_t id;
+
+	match = of_match_node(tegra_clock_of_match, np);
+	id = (uintptr_t)match->data;
 
 	clk_base = of_iomap(np, 0);
 	if (!clk_base) {
@@ -1416,6 +1433,20 @@ static void __init tegra124_clock_init(struct device_node *np)
 	tegra_audio_clk_init(clk_base, pmc_base, tegra124_clks, &pll_a_params);
 	tegra_pmc_clk_init(pmc_base, tegra124_clks);
 
+	if (id == TEGRA132_CLK) {
+		int i;
+
+		tegra124_clks[tegra_clk_cclk_g].present = false;
+		tegra124_clks[tegra_clk_cclk_lp].present = false;
+		tegra124_clks[tegra_clk_pll_x].present = false;
+		tegra124_clks[tegra_clk_pll_x_out0].present = false;
+
+		/* Tegra132 requires the soc_therm clock to be always on */
+		for (i = 0; i < ARRAY_SIZE(init_table); i++) {
+			if (init_table[i].clk_id == TEGRA124_CLK_SOC_THERM)
+				init_table[i].state = 1;
+		}
+	}
 	tegra_super_clk_gen4_init(clk_base, pmc_base, tegra124_clks,
 					&pll_x_params);
 	tegra_add_of_provider(np);
@@ -1426,3 +1457,4 @@ static void __init tegra124_clock_init(struct device_node *np)
 	tegra_cpu_car_ops = &tegra124_cpu_car_ops;
 }
 CLK_OF_DECLARE(tegra124, "nvidia,tegra124-car", tegra124_clock_init);
+CLK_OF_DECLARE(tegra132, "nvidia,tegra132-car", tegra124_clock_init);
-- 
1.7.7.rc0.72.g4b5ea.dirty

