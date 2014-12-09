Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaLIHAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:00:15 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8980 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaLIHAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:00:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 08 Dec 2014 22:57:03 -0800
From: Mark Zhang <markz@nvidia.com>
To: <pdeschrijver@nvidia.com>, <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <sboyd@codeaurora.org>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <gnurou@gmail.com>,
        <mperttunen@nvidia.com>, <abrestic@chromium.org>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Mark Zhang <markz@nvidia.com>
Subject: [PATCH] clk: tegra: Define PLLD_DSI and remove dsia(b)_mux
Date: Tue, 9 Dec 2014 14:59:59 +0800
Message-ID: <1418108399-7264-1-git-send-email-markz@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PLLD is the only parent for DSIA & DSIB on Tegra124 and
Tegra132. Besides, BIT 30 in PLLD_MISC register controls
the output of DSI clock.

So this patch removes "dsia_mux" & "dsib_mux", and create
a new clock "plld_dsi" to represent the DSI clock enable
control.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
Signed-off-by: Mark Zhang <markz@nvidia.com>
---
 drivers/clk/tegra/clk-id.h               |  2 --
 drivers/clk/tegra/clk-tegra-periph.c     |  2 --
 drivers/clk/tegra/clk-tegra114.c         | 10 +++++++--
 drivers/clk/tegra/clk-tegra124.c         | 36 ++++++++++++++------------------
 include/dt-bindings/clock/tegra124-car.h |  6 +++---
 5 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/clk/tegra/clk-id.h b/drivers/clk/tegra/clk-id.h
index 0011d547a9f7..60738cc954cb 100644
--- a/drivers/clk/tegra/clk-id.h
+++ b/drivers/clk/tegra/clk-id.h
@@ -64,10 +64,8 @@ enum clk_id {
 	tegra_clk_disp2,
 	tegra_clk_dp2,
 	tegra_clk_dpaux,
-	tegra_clk_dsia,
 	tegra_clk_dsialp,
 	tegra_clk_dsia_mux,
-	tegra_clk_dsib,
 	tegra_clk_dsiblp,
 	tegra_clk_dsib_mux,
 	tegra_clk_dtv,
diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index 37f32c49674e..1d0acbce6dc6 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -537,8 +537,6 @@ static struct tegra_periph_init_data gate_clks[] = {
 	GATE("xusb_host", "xusb_host_src", 89, 0, tegra_clk_xusb_host, 0),
 	GATE("xusb_ss", "xusb_ss_src", 156, 0, tegra_clk_xusb_ss, 0),
 	GATE("xusb_dev", "xusb_dev_src", 95, 0, tegra_clk_xusb_dev, 0),
-	GATE("dsia", "dsia_mux", 48, 0, tegra_clk_dsia, 0),
-	GATE("dsib", "dsib_mux", 82, 0, tegra_clk_dsib, 0),
 	GATE("emc", "emc_mux", 57, 0, tegra_clk_emc, CLK_IGNORE_UNUSED),
 	GATE("sata_cold", "clk_m", 129, TEGRA_PERIPH_ON_APB, tegra_clk_sata_cold, 0),
 	GATE("ispb", "clk_m", 3, 0, tegra_clk_ispb, 0),
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 0b03d2cf7264..d0766423a5d6 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -715,7 +715,6 @@ static struct tegra_clk tegra114_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_sbc2_8] = { .dt_id = TEGRA114_CLK_SBC2, .present = true },
 	[tegra_clk_sbc3_8] = { .dt_id = TEGRA114_CLK_SBC3, .present = true },
 	[tegra_clk_i2c5] = { .dt_id = TEGRA114_CLK_I2C5, .present = true },
-	[tegra_clk_dsia] = { .dt_id = TEGRA114_CLK_DSIA, .present = true },
 	[tegra_clk_mipi] = { .dt_id = TEGRA114_CLK_MIPI, .present = true },
 	[tegra_clk_hdmi] = { .dt_id = TEGRA114_CLK_HDMI, .present = true },
 	[tegra_clk_csi] = { .dt_id = TEGRA114_CLK_CSI, .present = true },
@@ -739,7 +738,6 @@ static struct tegra_clk tegra114_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_dtv] = { .dt_id = TEGRA114_CLK_DTV, .present = true },
 	[tegra_clk_ndspeed] = { .dt_id = TEGRA114_CLK_NDSPEED, .present = true },
 	[tegra_clk_i2cslow] = { .dt_id = TEGRA114_CLK_I2CSLOW, .present = true },
-	[tegra_clk_dsib] = { .dt_id = TEGRA114_CLK_DSIB, .present = true },
 	[tegra_clk_tsec] = { .dt_id = TEGRA114_CLK_TSEC, .present = true },
 	[tegra_clk_xusb_host] = { .dt_id = TEGRA114_CLK_XUSB_HOST, .present = true },
 	[tegra_clk_msenc] = { .dt_id = TEGRA114_CLK_MSENC, .present = true },
@@ -1224,6 +1222,14 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base,
 			       clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
 	clks[TEGRA114_CLK_DSIB_MUX] = clk;
 
+	clk = tegra_clk_register_periph_gate("dsia", "dsia_mux", 0, clk_base,
+					     0, 48, periph_clk_enb_refcnt);
+	clks[TEGRA114_CLK_DSIA] = clk;
+
+	clk = tegra_clk_register_periph_gate("dsib", "dsib_mux", 0, clk_base,
+					     0, 82, periph_clk_enb_refcnt);
+	clks[TEGRA114_CLK_DSIB] = clk;
+
 	/* emc mux */
 	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
 			       ARRAY_SIZE(mux_pllmcp_clkm),
diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index f5f9baca7bb6..482086326f6f 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -128,7 +128,6 @@ static unsigned long osc_freq;
 static unsigned long pll_ref_freq;
 
 static DEFINE_SPINLOCK(pll_d_lock);
-static DEFINE_SPINLOCK(pll_d2_lock);
 static DEFINE_SPINLOCK(pll_e_lock);
 static DEFINE_SPINLOCK(pll_re_lock);
 static DEFINE_SPINLOCK(pll_u_lock);
@@ -145,11 +144,6 @@ static unsigned long tegra124_input_freq[] = {
 	[12] = 260000000,
 };
 
-static const char *mux_plld_out0_plld2_out0[] = {
-	"pll_d_out0", "pll_d2_out0",
-};
-#define mux_plld_out0_plld2_out0_idx NULL
-
 static const char *mux_pllmcp_clkm[] = {
 	"pll_m", "pll_c", "pll_p", "clk_m", "pll_m_ud", "pll_c2", "pll_c3",
 };
@@ -783,7 +777,6 @@ static struct tegra_clk tegra124_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_sbc2] = { .dt_id = TEGRA124_CLK_SBC2, .present = true },
 	[tegra_clk_sbc3] = { .dt_id = TEGRA124_CLK_SBC3, .present = true },
 	[tegra_clk_i2c5] = { .dt_id = TEGRA124_CLK_I2C5, .present = true },
-	[tegra_clk_dsia] = { .dt_id = TEGRA124_CLK_DSIA, .present = true },
 	[tegra_clk_mipi] = { .dt_id = TEGRA124_CLK_MIPI, .present = true },
 	[tegra_clk_hdmi] = { .dt_id = TEGRA124_CLK_HDMI, .present = true },
 	[tegra_clk_csi] = { .dt_id = TEGRA124_CLK_CSI, .present = true },
@@ -809,7 +802,6 @@ static struct tegra_clk tegra124_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_soc_therm] = { .dt_id = TEGRA124_CLK_SOC_THERM, .present = true },
 	[tegra_clk_dtv] = { .dt_id = TEGRA124_CLK_DTV, .present = true },
 	[tegra_clk_i2cslow] = { .dt_id = TEGRA124_CLK_I2CSLOW, .present = true },
-	[tegra_clk_dsib] = { .dt_id = TEGRA124_CLK_DSIB, .present = true },
 	[tegra_clk_tsec] = { .dt_id = TEGRA124_CLK_TSEC, .present = true },
 	[tegra_clk_xusb_host] = { .dt_id = TEGRA124_CLK_XUSB_HOST, .present = true },
 	[tegra_clk_msenc] = { .dt_id = TEGRA124_CLK_MSENC, .present = true },
@@ -949,8 +941,6 @@ static struct tegra_clk tegra124_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_clk_out_1_mux] = { .dt_id = TEGRA124_CLK_CLK_OUT_1_MUX, .present = true },
 	[tegra_clk_clk_out_2_mux] = { .dt_id = TEGRA124_CLK_CLK_OUT_2_MUX, .present = true },
 	[tegra_clk_clk_out_3_mux] = { .dt_id = TEGRA124_CLK_CLK_OUT_3_MUX, .present = true },
-	[tegra_clk_dsia_mux] = { .dt_id = TEGRA124_CLK_DSIA_MUX, .present = true },
-	[tegra_clk_dsib_mux] = { .dt_id = TEGRA124_CLK_DSIB_MUX, .present = true },
 };
 
 static struct tegra_devclk devclks[] __initdata = {
@@ -1112,17 +1102,17 @@ static __init void tegra124_periph_clk_init(void __iomem *clk_base,
 					1, 2);
 	clks[TEGRA124_CLK_XUSB_SS_DIV2] = clk;
 
-	/* dsia mux */
-	clk = clk_register_mux(NULL, "dsia_mux", mux_plld_out0_plld2_out0,
-			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
-			       clk_base + PLLD_BASE, 25, 1, 0, &pll_d_lock);
-	clks[TEGRA124_CLK_DSIA_MUX] = clk;
+	clk = clk_register_gate(NULL, "plld_dsi", "plld_out0", 0,
+				clk_base + PLLD_MISC, 30, 0, &pll_d_lock);
+	clks[TEGRA124_CLK_PLLD_DSI] = clk;
 
-	/* dsib mux */
-	clk = clk_register_mux(NULL, "dsib_mux", mux_plld_out0_plld2_out0,
-			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
-			       clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
-	clks[TEGRA124_CLK_DSIB_MUX] = clk;
+	clk = tegra_clk_register_periph_gate("dsia", "plld_dsi", 0, clk_base,
+					     0, 48, periph_clk_enb_refcnt);
+	clks[TEGRA124_CLK_DSIA] = clk;
+
+	clk = tegra_clk_register_periph_gate("dsib", "plld_dsi", 0, clk_base,
+					     0, 82, periph_clk_enb_refcnt);
+	clks[TEGRA124_CLK_DSIB] = clk;
 
 	/* emc mux */
 	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
@@ -1402,6 +1392,7 @@ static void __init tegra124_clock_apply_init_table(void)
 static void __init tegra124_clock_init(struct device_node *np)
 {
 	struct device_node *node;
+	u32 plld_base;
 
 	clk_base = of_iomap(np, 0);
 	if (!clk_base) {
@@ -1445,5 +1436,10 @@ static void __init tegra124_clock_init(struct device_node *np)
 	tegra_clk_apply_init_table = tegra124_clock_apply_init_table;
 
 	tegra_cpu_car_ops = &tegra124_cpu_car_ops;
+
+	/* For Tegra124 & Tegra132, PLLD is the only source for DSIA & DSIB */
+	plld_base = clk_readl(clk_base + PLLD_BASE);
+	plld_base &= ~BIT(25);
+	clk_writel(plld_base, clk_base + PLLD_BASE);
 }
 CLK_OF_DECLARE(tegra124, "nvidia,tegra124-car", tegra124_clock_init);
diff --git a/include/dt-bindings/clock/tegra124-car.h b/include/dt-bindings/clock/tegra124-car.h
index af9bc9a3ddbc..0e802688c028 100644
--- a/include/dt-bindings/clock/tegra124-car.h
+++ b/include/dt-bindings/clock/tegra124-car.h
@@ -296,7 +296,7 @@
 #define TEGRA124_CLK_PLL_C4 270
 #define TEGRA124_CLK_PLL_DP 271
 #define TEGRA124_CLK_PLL_E_MUX 272
-/* 273 */
+#define TEGRA124_CLK_PLLD_DSI 273
 /* 274 */
 /* 275 */
 /* 276 */
@@ -333,8 +333,8 @@
 #define TEGRA124_CLK_CLK_OUT_1_MUX 306
 #define TEGRA124_CLK_CLK_OUT_2_MUX 307
 #define TEGRA124_CLK_CLK_OUT_3_MUX 308
-#define TEGRA124_CLK_DSIA_MUX 309
-#define TEGRA124_CLK_DSIB_MUX 310
+/* 309 */
+/* 310 */
 #define TEGRA124_CLK_SOR0_LVDS 311
 #define TEGRA124_CLK_XUSB_SS_DIV2 312
 
-- 
1.8.1.5

