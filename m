Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab3JOO6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:58:06 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10575 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971Ab3JOO6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:58:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 15 Oct 2013 07:53:37 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH v3 16/19] clk: tegra20: move tegra20 to common clkdev
Date: Tue, 15 Oct 2013 17:53:01 +0300
Message-ID: <1381848794-11761-17-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move tegra20 to the common clkdev infrastructure. This will allow making
use of the common tegra clocks.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra20.c |  257 +++++++++++++++++++++++----------------
 1 files changed, 154 insertions(+), 103 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index b2d3361..ac7c8fb 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -173,31 +173,31 @@ static void __iomem *pmc_base;
 static DEFINE_SPINLOCK(pll_div_lock);
 static DEFINE_SPINLOCK(sysrate_lock);
 
-#define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
+#define TEGRA_INIT_DATA_MUX(_name, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
+	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_ROUND_UP,	\
 			_clk_num, \
 			_gate_flags, _clk_id)
 
-#define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
+#define TEGRA_INIT_DATA_INT(_name, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
+	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_INT, \
 			_clk_num, _gate_flags,	\
 			_clk_id)
 
-#define TEGRA_INIT_DATA_DIV16(_name, _con_id, _dev_id, _parents, _offset, \
+#define TEGRA_INIT_DATA_DIV16(_name, _parents, _offset, \
 			      _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
+	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
 			30, 2, 0, 0, 16, 0, TEGRA_DIVIDER_ROUND_UP, \
 			_clk_num, _gate_flags,	\
 			_clk_id)
 
-#define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
+#define TEGRA_INIT_DATA_NODIV(_name, _parents, _offset, \
 			      _mux_shift, _mux_width, _clk_num, \
 			      _gate_flags, _clk_id)			\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
+	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
 			_mux_shift, _mux_width, 0, 0, 0, 0, 0, \
 			_clk_num, _gate_flags,	\
 			_clk_id)
@@ -465,6 +465,104 @@ static struct tegra_clk_pll_params pll_e_params = {
 	.fixed_rate = 100000000,
 };
 
+static struct tegra_devclk devclks[] __initdata = {
+	{ .con_id = "pll_c", .dt_id = TEGRA20_CLK_PLL_C },
+	{ .con_id = "pll_c_out1", .dt_id = TEGRA20_CLK_PLL_C_OUT1 },
+	{ .con_id = "pll_p", .dt_id = TEGRA20_CLK_PLL_P },
+	{ .con_id = "pll_p_out1", .dt_id = TEGRA20_CLK_PLL_P_OUT1 },
+	{ .con_id = "pll_p_out2", .dt_id = TEGRA20_CLK_PLL_P_OUT2 },
+	{ .con_id = "pll_p_out3", .dt_id = TEGRA20_CLK_PLL_P_OUT3 },
+	{ .con_id = "pll_p_out4", .dt_id = TEGRA20_CLK_PLL_P_OUT4 },
+	{ .con_id = "pll_m", .dt_id = TEGRA20_CLK_PLL_M },
+	{ .con_id = "pll_m_out1", .dt_id = TEGRA20_CLK_PLL_M_OUT1 },
+	{ .con_id = "pll_x", .dt_id = TEGRA20_CLK_PLL_X },
+	{ .con_id = "pll_u", .dt_id = TEGRA20_CLK_PLL_U },
+	{ .con_id = "pll_d", .dt_id = TEGRA20_CLK_PLL_D },
+	{ .con_id = "pll_d_out0", .dt_id = TEGRA20_CLK_PLL_D_OUT0 },
+	{ .con_id = "pll_a", .dt_id = TEGRA20_CLK_PLL_A },
+	{ .con_id = "pll_a_out0", .dt_id = TEGRA20_CLK_PLL_A_OUT0 },
+	{ .con_id = "pll_e", .dt_id = TEGRA20_CLK_PLL_E },
+	{ .con_id = "cclk", .dt_id = TEGRA20_CLK_CCLK },
+	{ .con_id = "sclk", .dt_id = TEGRA20_CLK_SCLK },
+	{ .con_id = "hclk", .dt_id = TEGRA20_CLK_HCLK },
+	{ .con_id = "pclk", .dt_id = TEGRA20_CLK_PCLK },
+	{ .con_id = "twd", .dt_id = TEGRA20_CLK_TWD },
+	{ .con_id = "audio", .dt_id = TEGRA20_CLK_AUDIO },
+	{ .con_id = "audio_2x", .dt_id = TEGRA20_CLK_AUDIO_2X },
+	{ .dev_id = "tegra20-ac97", .dt_id = TEGRA20_CLK_AC97 },
+	{ .dev_id = "tegra-apbdma", .dt_id = TEGRA20_CLK_APBDMA },
+	{ .dev_id = "rtc-tegra", .dt_id = TEGRA20_CLK_RTC },
+	{ .dev_id = "timer", .dt_id = TEGRA20_CLK_TIMER },
+	{ .dev_id = "tegra-kbc", .dt_id = TEGRA20_CLK_KBC },
+	{ .con_id = "csus", .dev_id =  "tegra_camera", .dt_id = TEGRA20_CLK_CSUS },
+	{ .con_id = "vcp", .dev_id = "tegra-avp", .dt_id = TEGRA20_CLK_VCP },
+	{ .con_id = "bsea", .dev_id = "tegra-avp", .dt_id = TEGRA20_CLK_BSEA },
+	{ .con_id = "bsev", .dev_id = "tegra-aes", .dt_id = TEGRA20_CLK_BSEV },
+	{ .con_id = "emc", .dt_id = TEGRA20_CLK_EMC },
+	{ .dev_id = "fsl-tegra-udc", .dt_id = TEGRA20_CLK_USBD },
+	{ .dev_id = "tegra-ehci.1", .dt_id = TEGRA20_CLK_USB2 },
+	{ .dev_id = "tegra-ehci.2", .dt_id = TEGRA20_CLK_USB3 },
+	{ .dev_id = "dsi", .dt_id = TEGRA20_CLK_DSI },
+	{ .con_id = "csi", .dev_id = "tegra_camera", .dt_id = TEGRA20_CLK_CSI },
+	{ .con_id = "isp", .dev_id = "tegra_camera", .dt_id = TEGRA20_CLK_ISP },
+	{ .con_id = "pex", .dt_id = TEGRA20_CLK_PEX },
+	{ .con_id = "afi", .dt_id = TEGRA20_CLK_AFI },
+	{ .con_id = "pcie_xclk", .dt_id = TEGRA20_CLK_PCIE_XCLK },
+	{ .con_id = "cdev1", .dt_id = TEGRA20_CLK_CDEV1 },
+	{ .con_id = "cdev2", .dt_id = TEGRA20_CLK_CDEV2 },
+	{ .con_id = "clk_32k", .dt_id = TEGRA20_CLK_CLK_32K },
+	{ .con_id = "blink", .dt_id = TEGRA20_CLK_BLINK },
+	{ .con_id = "clk_m", .dt_id = TEGRA20_CLK_CLK_M },
+	{ .con_id = "pll_ref", .dt_id = TEGRA20_CLK_PLL_REF },
+	{ .dev_id = "tegra20-i2s.0", .dt_id = TEGRA20_CLK_I2S1 },
+	{ .dev_id = "tegra20-i2s.1", .dt_id = TEGRA20_CLK_I2S2 },
+	{ .con_id = "spdif_out", .dev_id = "tegra20-spdif", .dt_id = TEGRA20_CLK_SPDIF_OUT },
+	{ .con_id = "spdif_in", .dev_id = "tegra20-spdif", .dt_id = TEGRA20_CLK_SPDIF_IN },
+	{ .dev_id = "spi_tegra.0", .dt_id = TEGRA20_CLK_SBC1 },
+	{ .dev_id = "spi_tegra.1", .dt_id = TEGRA20_CLK_SBC2 },
+	{ .dev_id = "spi_tegra.2", .dt_id = TEGRA20_CLK_SBC3 },
+	{ .dev_id = "spi_tegra.3", .dt_id = TEGRA20_CLK_SBC4 },
+	{ .dev_id = "spi", .dt_id = TEGRA20_CLK_SPI },
+	{ .dev_id = "xio", .dt_id = TEGRA20_CLK_XIO },
+	{ .dev_id = "twc", .dt_id = TEGRA20_CLK_TWC },
+	{ .dev_id = "ide", .dt_id = TEGRA20_CLK_IDE },
+	{ .dev_id = "tegra_nand", .dt_id = TEGRA20_CLK_NDFLASH },
+	{ .dev_id = "vfir", .dt_id = TEGRA20_CLK_VFIR },
+	{ .dev_id = "csite", .dt_id = TEGRA20_CLK_CSITE },
+	{ .dev_id = "la", .dt_id = TEGRA20_CLK_LA },
+	{ .dev_id = "tegra_w1", .dt_id = TEGRA20_CLK_OWR },
+	{ .dev_id = "mipi", .dt_id = TEGRA20_CLK_MIPI },
+	{ .dev_id = "vde", .dt_id = TEGRA20_CLK_VDE },
+	{ .con_id = "vi", .dev_id =  "tegra_camera", .dt_id = TEGRA20_CLK_VI },
+	{ .dev_id = "epp", .dt_id = TEGRA20_CLK_EPP },
+	{ .dev_id = "mpe", .dt_id = TEGRA20_CLK_MPE },
+	{ .dev_id = "host1x", .dt_id = TEGRA20_CLK_HOST1X },
+	{ .dev_id = "3d", .dt_id = TEGRA20_CLK_GR3D },
+	{ .dev_id = "2d", .dt_id = TEGRA20_CLK_GR2D },
+	{ .dev_id = "tegra-nor", .dt_id = TEGRA20_CLK_NOR },
+	{ .dev_id = "sdhci-tegra.0", .dt_id = TEGRA20_CLK_SDMMC1 },
+	{ .dev_id = "sdhci-tegra.1", .dt_id = TEGRA20_CLK_SDMMC2 },
+	{ .dev_id = "sdhci-tegra.2", .dt_id = TEGRA20_CLK_SDMMC3 },
+	{ .dev_id = "sdhci-tegra.3", .dt_id = TEGRA20_CLK_SDMMC4 },
+	{ .dev_id = "cve", .dt_id = TEGRA20_CLK_CVE },
+	{ .dev_id = "tvo", .dt_id = TEGRA20_CLK_TVO },
+	{ .dev_id = "tvdac", .dt_id = TEGRA20_CLK_TVDAC },
+	{ .con_id = "vi_sensor", .dev_id = "tegra_camera", .dt_id = TEGRA20_CLK_VI_SENSOR },
+	{ .dev_id = "hdmi", .dt_id = TEGRA20_CLK_HDMI },
+	{ .con_id = "div-clk", .dev_id = "tegra-i2c.0", .dt_id = TEGRA20_CLK_I2C1 },
+	{ .con_id = "div-clk", .dev_id = "tegra-i2c.1", .dt_id = TEGRA20_CLK_I2C2 },
+	{ .con_id = "div-clk", .dev_id = "tegra-i2c.2", .dt_id = TEGRA20_CLK_I2C3 },
+	{ .con_id = "div-clk", .dev_id = "tegra-i2c.3", .dt_id = TEGRA20_CLK_DVC },
+	{ .dev_id = "tegra-pwm", .dt_id = TEGRA20_CLK_PWM },
+	{ .dev_id = "tegra_uart.0", .dt_id = TEGRA20_CLK_UARTA },
+	{ .dev_id = "tegra_uart.1", .dt_id = TEGRA20_CLK_UARTB },
+	{ .dev_id = "tegra_uart.2", .dt_id = TEGRA20_CLK_UARTC },
+	{ .dev_id = "tegra_uart.3", .dt_id = TEGRA20_CLK_UARTD },
+	{ .dev_id = "tegra_uart.4", .dt_id = TEGRA20_CLK_UARTE },
+	{ .dev_id = "tegradc.0", .dt_id = TEGRA20_CLK_DISP1 },
+	{ .dev_id = "tegradc.1", .dt_id = TEGRA20_CLK_DISP2 },
+};
+
 static unsigned long tegra20_clk_measure_input_freq(void)
 {
 	u32 osc_ctrl = readl_relaxed(clk_base + OSC_CTRL);
@@ -525,7 +623,6 @@ static void tegra20_pll_init(void)
 	/* PLLC */
 	clk = tegra_clk_register_pll("pll_c", "pll_ref", clk_base, NULL, 0,
 			    &pll_c_params, NULL);
-	clk_register_clkdev(clk, "pll_c", NULL);
 	clks[TEGRA20_CLK_PLL_C] = clk;
 
 	/* PLLC_OUT1 */
@@ -535,13 +632,11 @@ static void tegra20_pll_init(void)
 	clk = tegra_clk_register_pll_out("pll_c_out1", "pll_c_out1_div",
 				clk_base + PLLC_OUT, 1, 0, CLK_SET_RATE_PARENT,
 				0, NULL);
-	clk_register_clkdev(clk, "pll_c_out1", NULL);
 	clks[TEGRA20_CLK_PLL_C_OUT1] = clk;
 
 	/* PLLP */
 	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, NULL, 0,
 			    &pll_p_params, NULL);
-	clk_register_clkdev(clk, "pll_p", NULL);
 	clks[TEGRA20_CLK_PLL_P] = clk;
 
 	/* PLLP_OUT1 */
@@ -553,7 +648,6 @@ static void tegra20_pll_init(void)
 				clk_base + PLLP_OUTA, 1, 0,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out1", NULL);
 	clks[TEGRA20_CLK_PLL_P_OUT1] = clk;
 
 	/* PLLP_OUT2 */
@@ -565,7 +659,6 @@ static void tegra20_pll_init(void)
 				clk_base + PLLP_OUTA, 17, 16,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out2", NULL);
 	clks[TEGRA20_CLK_PLL_P_OUT2] = clk;
 
 	/* PLLP_OUT3 */
@@ -577,7 +670,6 @@ static void tegra20_pll_init(void)
 				clk_base + PLLP_OUTB, 1, 0,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out3", NULL);
 	clks[TEGRA20_CLK_PLL_P_OUT3] = clk;
 
 	/* PLLP_OUT4 */
@@ -589,14 +681,12 @@ static void tegra20_pll_init(void)
 				clk_base + PLLP_OUTB, 17, 16,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out4", NULL);
 	clks[TEGRA20_CLK_PLL_P_OUT4] = clk;
 
 	/* PLLM */
 	clk = tegra_clk_register_pll("pll_m", "pll_ref", clk_base, NULL,
 			    CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE,
 			    &pll_m_params, NULL);
-	clk_register_clkdev(clk, "pll_m", NULL);
 	clks[TEGRA20_CLK_PLL_M] = clk;
 
 	/* PLLM_OUT1 */
@@ -606,37 +696,31 @@ static void tegra20_pll_init(void)
 	clk = tegra_clk_register_pll_out("pll_m_out1", "pll_m_out1_div",
 				clk_base + PLLM_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
-	clk_register_clkdev(clk, "pll_m_out1", NULL);
 	clks[TEGRA20_CLK_PLL_M_OUT1] = clk;
 
 	/* PLLX */
 	clk = tegra_clk_register_pll("pll_x", "pll_ref", clk_base, NULL, 0,
 			    &pll_x_params, NULL);
-	clk_register_clkdev(clk, "pll_x", NULL);
 	clks[TEGRA20_CLK_PLL_X] = clk;
 
 	/* PLLU */
 	clk = tegra_clk_register_pll("pll_u", "pll_ref", clk_base, NULL, 0,
 			    &pll_u_params, NULL);
-	clk_register_clkdev(clk, "pll_u", NULL);
 	clks[TEGRA20_CLK_PLL_U] = clk;
 
 	/* PLLD */
 	clk = tegra_clk_register_pll("pll_d", "pll_ref", clk_base, NULL, 0,
 			    &pll_d_params, NULL);
-	clk_register_clkdev(clk, "pll_d", NULL);
 	clks[TEGRA20_CLK_PLL_D] = clk;
 
 	/* PLLD_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d_out0", "pll_d",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "pll_d_out0", NULL);
 	clks[TEGRA20_CLK_PLL_D_OUT0] = clk;
 
 	/* PLLA */
 	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, NULL, 0,
 			    &pll_a_params, NULL);
-	clk_register_clkdev(clk, "pll_a", NULL);
 	clks[TEGRA20_CLK_PLL_A] = clk;
 
 	/* PLLA_OUT0 */
@@ -646,13 +730,11 @@ static void tegra20_pll_init(void)
 	clk = tegra_clk_register_pll_out("pll_a_out0", "pll_a_out0_div",
 				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
-	clk_register_clkdev(clk, "pll_a_out0", NULL);
 	clks[TEGRA20_CLK_PLL_A_OUT0] = clk;
 
 	/* PLLE */
 	clk = tegra_clk_register_plle("pll_e", "pll_ref", clk_base, pmc_base,
 			     0, &pll_e_params, NULL);
-	clk_register_clkdev(clk, "pll_e", NULL);
 	clks[TEGRA20_CLK_PLL_E] = clk;
 }
 
@@ -671,14 +753,12 @@ static void tegra20_super_clk_init(void)
 	clk = tegra_clk_register_super_mux("cclk", cclk_parents,
 			      ARRAY_SIZE(cclk_parents), CLK_SET_RATE_PARENT,
 			      clk_base + CCLK_BURST_POLICY, 0, 4, 0, 0, NULL);
-	clk_register_clkdev(clk, "cclk", NULL);
 	clks[TEGRA20_CLK_CCLK] = clk;
 
 	/* SCLK */
 	clk = tegra_clk_register_super_mux("sclk", sclk_parents,
 			      ARRAY_SIZE(sclk_parents), CLK_SET_RATE_PARENT,
 			      clk_base + SCLK_BURST_POLICY, 0, 4, 0, 0, NULL);
-	clk_register_clkdev(clk, "sclk", NULL);
 	clks[TEGRA20_CLK_SCLK] = clk;
 
 	/* HCLK */
@@ -688,7 +768,6 @@ static void tegra20_super_clk_init(void)
 	clk = clk_register_gate(NULL, "hclk", "hclk_div", CLK_SET_RATE_PARENT,
 				clk_base + CLK_SYSTEM_RATE, 7,
 				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clk_register_clkdev(clk, "hclk", NULL);
 	clks[TEGRA20_CLK_HCLK] = clk;
 
 	/* PCLK */
@@ -698,12 +777,10 @@ static void tegra20_super_clk_init(void)
 	clk = clk_register_gate(NULL, "pclk", "pclk_div", CLK_SET_RATE_PARENT,
 				clk_base + CLK_SYSTEM_RATE, 3,
 				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clk_register_clkdev(clk, "pclk", NULL);
 	clks[TEGRA20_CLK_PCLK] = clk;
 
 	/* twd */
 	clk = clk_register_fixed_factor(NULL, "twd", "cclk", 0, 1, 4);
-	clk_register_clkdev(clk, "twd", NULL);
 	clks[TEGRA20_CLK_TWD] = clk;
 }
 
@@ -723,7 +800,6 @@ static void __init tegra20_audio_clk_init(void)
 	clk = clk_register_gate(NULL, "audio", "audio_mux", 0,
 				clk_base + AUDIO_SYNC_CLK, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio", NULL);
 	clks[TEGRA20_CLK_AUDIO] = clk;
 
 	/* audio_2x */
@@ -733,7 +809,6 @@ static void __init tegra20_audio_clk_init(void)
 				    TEGRA_PERIPH_NO_RESET, clk_base,
 				    CLK_SET_RATE_PARENT, 89,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio_2x", NULL);
 	clks[TEGRA20_CLK_AUDIO_2X] = clk;
 
 }
@@ -754,56 +829,56 @@ static const char *mux_pllpdc_clkm[] = {"pll_p", "pll_d_out0", "pll_c",
 static const char *mux_pllmcp_clkm[] = {"pll_m", "pll_c", "pll_p", "clk_m"};
 
 static struct tegra_periph_init_data tegra_periph_clk_list[] = {
-	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra20-i2s.0", i2s1_parents,	    CLK_SOURCE_I2S1,	  11,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2S1),
-	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra20-i2s.1", i2s2_parents,	    CLK_SOURCE_I2S2,	  18,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2S2),
-	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra20-spdif", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SPDIF_OUT),
-	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra20-spdif", spdif_in_parents,  CLK_SOURCE_SPDIF_IN,  10,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SPDIF_IN),
-	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC1,	  41,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC1),
-	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC2,	  44,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC2),
-	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC3,	  46,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC3),
-	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC4,	  68,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC4),
-	TEGRA_INIT_DATA_MUX("spi",	NULL,		"spi",		 mux_pllpcm_clkm,   CLK_SOURCE_SPI,	  43,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SPI),
-	TEGRA_INIT_DATA_MUX("xio",	NULL,		"xio",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  45,	 0, TEGRA20_CLK_XIO),
-	TEGRA_INIT_DATA_MUX("twc",	NULL,		"twc",		 mux_pllpcm_clkm,   CLK_SOURCE_TWC,	  16,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_TWC),
-	TEGRA_INIT_DATA_MUX("ide",	NULL,		"ide",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  25,	 0, TEGRA20_CLK_IDE),
-	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",	 mux_pllpcm_clkm,   CLK_SOURCE_NDFLASH,	  13,	 0, TEGRA20_CLK_NDFLASH),
-	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",		 mux_pllpcm_clkm,   CLK_SOURCE_VFIR,	  7,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_VFIR),
-	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",	 mux_pllpcm_clkm,   CLK_SOURCE_CSITE,	  73,	 0, TEGRA20_CLK_CSITE),
-	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",		 mux_pllpcm_clkm,   CLK_SOURCE_LA,	  76,	 0, TEGRA20_CLK_LA),
-	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",	 mux_pllpcm_clkm,   CLK_SOURCE_OWR,	  71,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_OWR),
-	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",		 mux_pllpcm_clkm,   CLK_SOURCE_MIPI,	  50,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_MIPI),
-	TEGRA_INIT_DATA_MUX("vde",	NULL,		"vde",		 mux_pllpcm_clkm,   CLK_SOURCE_VDE,	  61,	 0, TEGRA20_CLK_VDE),
-	TEGRA_INIT_DATA_MUX("vi",	"vi",		"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI,	  20,	 0, TEGRA20_CLK_VI),
-	TEGRA_INIT_DATA_MUX("epp",	NULL,		"epp",		 mux_pllmcpa,	    CLK_SOURCE_EPP,	  19,	 0, TEGRA20_CLK_EPP),
-	TEGRA_INIT_DATA_MUX("mpe",	NULL,		"mpe",		 mux_pllmcpa,	    CLK_SOURCE_MPE,	  60,	 0, TEGRA20_CLK_MPE),
-	TEGRA_INIT_DATA_MUX("host1x",	NULL,		"host1x",	 mux_pllmcpa,	    CLK_SOURCE_HOST1X,	  28,	 0, TEGRA20_CLK_HOST1X),
-	TEGRA_INIT_DATA_MUX("3d",	NULL,		"3d",		 mux_pllmcpa,	    CLK_SOURCE_3D,	  24,	 TEGRA_PERIPH_MANUAL_RESET, TEGRA20_CLK_GR3D),
-	TEGRA_INIT_DATA_MUX("2d",	NULL,		"2d",		 mux_pllmcpa,	    CLK_SOURCE_2D,	  21,	 0, TEGRA20_CLK_GR2D),
-	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",	 mux_pllpcm_clkm,   CLK_SOURCE_NOR,	  42,	 0, TEGRA20_CLK_NOR),
-	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC1,	  14,	 0, TEGRA20_CLK_SDMMC1),
-	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC2,	  9,	 0, TEGRA20_CLK_SDMMC2),
-	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC3,	  69,	 0, TEGRA20_CLK_SDMMC3),
-	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC4,	  15,	 0, TEGRA20_CLK_SDMMC4),
-	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",		 mux_pllpdc_clkm,   CLK_SOURCE_CVE,	  49,	 0, TEGRA20_CLK_CVE),
-	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",		 mux_pllpdc_clkm,   CLK_SOURCE_TVO,	  49,	 0, TEGRA20_CLK_TVO),
-	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",	 mux_pllpdc_clkm,   CLK_SOURCE_TVDAC,	  53,	 0, TEGRA20_CLK_TVDAC),
-	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI_SENSOR, 20,	 TEGRA_PERIPH_NO_RESET, TEGRA20_CLK_VI_SENSOR),
-	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C1,	  12,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C1),
-	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C2,	  54,	 TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C2),
-	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C3,	  67,		TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C3),
-	TEGRA_INIT_DATA_DIV16("dvc",	"div-clk",	"tegra-i2c.3",	 mux_pllpcm_clkm,   CLK_SOURCE_DVC,	  47,		TEGRA_PERIPH_ON_APB, TEGRA20_CLK_DVC),
-	TEGRA_INIT_DATA_MUX("hdmi",	NULL,		"hdmi",		 mux_pllpdc_clkm,   CLK_SOURCE_HDMI,	  51,		0, TEGRA20_CLK_HDMI),
-	TEGRA_INIT_DATA("pwm",		NULL,		"tegra-pwm",	 pwm_parents,	    CLK_SOURCE_PWM,	  28, 3, 0, 0, 8, 1, 0,  17, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_PWM),
+	TEGRA_INIT_DATA_MUX("i2s1", i2s1_parents,     CLK_SOURCE_I2S1,   11,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2S1),
+	TEGRA_INIT_DATA_MUX("i2s2", i2s2_parents,     CLK_SOURCE_I2S2,   18,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2S2),
+	TEGRA_INIT_DATA_MUX("spdif_out", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SPDIF_OUT),
+	TEGRA_INIT_DATA_MUX("spdif_in", spdif_in_parents,  CLK_SOURCE_SPDIF_IN,  10,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SPDIF_IN),
+	TEGRA_INIT_DATA_MUX("sbc1",  mux_pllpcm_clkm,   CLK_SOURCE_SBC1,   41,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC1),
+	TEGRA_INIT_DATA_MUX("sbc2",  mux_pllpcm_clkm,   CLK_SOURCE_SBC2,   44,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC2),
+	TEGRA_INIT_DATA_MUX("sbc3",  mux_pllpcm_clkm,   CLK_SOURCE_SBC3,   46,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC3),
+	TEGRA_INIT_DATA_MUX("sbc4",  mux_pllpcm_clkm,   CLK_SOURCE_SBC4,   68,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC4),
+	TEGRA_INIT_DATA_MUX("spi",   mux_pllpcm_clkm,   CLK_SOURCE_SPI,   43,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SPI),
+	TEGRA_INIT_DATA_MUX("xio",   mux_pllpcm_clkm,   CLK_SOURCE_XIO,   45,  0, TEGRA20_CLK_XIO),
+	TEGRA_INIT_DATA_MUX("twc",   mux_pllpcm_clkm,   CLK_SOURCE_TWC,   16,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_TWC),
+	TEGRA_INIT_DATA_MUX("ide",   mux_pllpcm_clkm,   CLK_SOURCE_XIO,   25,  0, TEGRA20_CLK_IDE),
+	TEGRA_INIT_DATA_MUX("ndflash",  mux_pllpcm_clkm,   CLK_SOURCE_NDFLASH,   13,  0, TEGRA20_CLK_NDFLASH),
+	TEGRA_INIT_DATA_MUX("vfir",   mux_pllpcm_clkm,   CLK_SOURCE_VFIR,   7,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_VFIR),
+	TEGRA_INIT_DATA_MUX("csite",  mux_pllpcm_clkm,   CLK_SOURCE_CSITE,   73,  0, TEGRA20_CLK_CSITE),
+	TEGRA_INIT_DATA_MUX("la",   mux_pllpcm_clkm,   CLK_SOURCE_LA,   76,  0, TEGRA20_CLK_LA),
+	TEGRA_INIT_DATA_MUX("owr",  mux_pllpcm_clkm,   CLK_SOURCE_OWR,   71,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_OWR),
+	TEGRA_INIT_DATA_MUX("mipi",   mux_pllpcm_clkm,   CLK_SOURCE_MIPI,   50,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_MIPI),
+	TEGRA_INIT_DATA_MUX("vde",   mux_pllpcm_clkm,   CLK_SOURCE_VDE,   61,  0, TEGRA20_CLK_VDE),
+	TEGRA_INIT_DATA_MUX("vi",  mux_pllmcpa,     CLK_SOURCE_VI,   20,  0, TEGRA20_CLK_VI),
+	TEGRA_INIT_DATA_MUX("epp",   mux_pllmcpa,     CLK_SOURCE_EPP,   19,  0, TEGRA20_CLK_EPP),
+	TEGRA_INIT_DATA_MUX("mpe",   mux_pllmcpa,     CLK_SOURCE_MPE,   60,  0, TEGRA20_CLK_MPE),
+	TEGRA_INIT_DATA_MUX("host1x",  mux_pllmcpa,     CLK_SOURCE_HOST1X,   28,  0, TEGRA20_CLK_HOST1X),
+	TEGRA_INIT_DATA_MUX("3d",   mux_pllmcpa,     CLK_SOURCE_3D,   24,  TEGRA_PERIPH_MANUAL_RESET, TEGRA20_CLK_GR3D),
+	TEGRA_INIT_DATA_MUX("2d",   mux_pllmcpa,     CLK_SOURCE_2D,   21,  0, TEGRA20_CLK_GR2D),
+	TEGRA_INIT_DATA_MUX("nor",  mux_pllpcm_clkm,   CLK_SOURCE_NOR,   42,  0, TEGRA20_CLK_NOR),
+	TEGRA_INIT_DATA_MUX("sdmmc1", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC1,   14,  0, TEGRA20_CLK_SDMMC1),
+	TEGRA_INIT_DATA_MUX("sdmmc2", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC2,   9,  0, TEGRA20_CLK_SDMMC2),
+	TEGRA_INIT_DATA_MUX("sdmmc3", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC3,   69,  0, TEGRA20_CLK_SDMMC3),
+	TEGRA_INIT_DATA_MUX("sdmmc4", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC4,   15,  0, TEGRA20_CLK_SDMMC4),
+	TEGRA_INIT_DATA_MUX("cve",   mux_pllpdc_clkm,   CLK_SOURCE_CVE,   49,  0, TEGRA20_CLK_CVE),
+	TEGRA_INIT_DATA_MUX("tvo",   mux_pllpdc_clkm,   CLK_SOURCE_TVO,   49,  0, TEGRA20_CLK_TVO),
+	TEGRA_INIT_DATA_MUX("tvdac",  mux_pllpdc_clkm,   CLK_SOURCE_TVDAC,   53,  0, TEGRA20_CLK_TVDAC),
+	TEGRA_INIT_DATA_MUX("vi_sensor",  mux_pllmcpa,     CLK_SOURCE_VI_SENSOR, 20,  TEGRA_PERIPH_NO_RESET, TEGRA20_CLK_VI_SENSOR),
+	TEGRA_INIT_DATA_DIV16("i2c1", mux_pllpcm_clkm,   CLK_SOURCE_I2C1,   12,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C1),
+	TEGRA_INIT_DATA_DIV16("i2c2", mux_pllpcm_clkm,   CLK_SOURCE_I2C2,   54,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C2),
+	TEGRA_INIT_DATA_DIV16("i2c3", mux_pllpcm_clkm,   CLK_SOURCE_I2C3,   67,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C3),
+	TEGRA_INIT_DATA_DIV16("dvc", mux_pllpcm_clkm,   CLK_SOURCE_DVC,   47,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_DVC),
+	TEGRA_INIT_DATA_MUX("hdmi", mux_pllpdc_clkm,   CLK_SOURCE_HDMI,   51,  0, TEGRA20_CLK_HDMI),
+	TEGRA_INIT_DATA("pwm", NULL, NULL, pwm_parents,     CLK_SOURCE_PWM,   28, 3, 0, 0, 8, 1, 0,  17, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_PWM),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
-	TEGRA_INIT_DATA_NODIV("uarta",	NULL, "tegra_uart.0", mux_pllpcm_clkm, CLK_SOURCE_UARTA, 30, 2, 6,   TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTA),
-	TEGRA_INIT_DATA_NODIV("uartb",	NULL, "tegra_uart.1", mux_pllpcm_clkm, CLK_SOURCE_UARTB, 30, 2, 7,   TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTB),
-	TEGRA_INIT_DATA_NODIV("uartc",	NULL, "tegra_uart.2", mux_pllpcm_clkm, CLK_SOURCE_UARTC, 30, 2, 55,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTC),
-	TEGRA_INIT_DATA_NODIV("uartd",	NULL, "tegra_uart.3", mux_pllpcm_clkm, CLK_SOURCE_UARTD, 30, 2, 65,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTD),
-	TEGRA_INIT_DATA_NODIV("uarte",	NULL, "tegra_uart.4", mux_pllpcm_clkm, CLK_SOURCE_UARTE, 30, 2, 66,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTE),
-	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0",    mux_pllpdc_clkm, CLK_SOURCE_DISP1, 30, 2, 27,  0, TEGRA20_CLK_DISP1),
-	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1",    mux_pllpdc_clkm, CLK_SOURCE_DISP2, 30, 2, 26,  0, TEGRA20_CLK_DISP2),
+	TEGRA_INIT_DATA_NODIV("uarta",	mux_pllpcm_clkm, CLK_SOURCE_UARTA, 30, 2, 6,   TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTA),
+	TEGRA_INIT_DATA_NODIV("uartb",	mux_pllpcm_clkm, CLK_SOURCE_UARTB, 30, 2, 7,   TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTB),
+	TEGRA_INIT_DATA_NODIV("uartc",	mux_pllpcm_clkm, CLK_SOURCE_UARTC, 30, 2, 55,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTC),
+	TEGRA_INIT_DATA_NODIV("uartd",	mux_pllpcm_clkm, CLK_SOURCE_UARTD, 30, 2, 65,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTD),
+	TEGRA_INIT_DATA_NODIV("uarte",	mux_pllpcm_clkm, CLK_SOURCE_UARTE, 30, 2, 66,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTE),
+	TEGRA_INIT_DATA_NODIV("disp1",	mux_pllpdc_clkm, CLK_SOURCE_DISP1, 30, 2, 27,  0, TEGRA20_CLK_DISP1),
+	TEGRA_INIT_DATA_NODIV("disp2",	mux_pllpdc_clkm, CLK_SOURCE_DISP2, 30, 2, 26,  0, TEGRA20_CLK_DISP2),
 };
 
 static void __init tegra20_periph_clk_init(void)
@@ -816,58 +891,49 @@ static void __init tegra20_periph_clk_init(void)
 	clk = tegra_clk_register_periph_gate("ac97", "pll_a_out0",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 3, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra20-ac97");
 	clks[TEGRA20_CLK_AC97] = clk;
 
 	/* apbdma */
 	clk = tegra_clk_register_periph_gate("apbdma", "pclk", 0, clk_base,
 				    0, 34, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra-apbdma");
 	clks[TEGRA20_CLK_APBDMA] = clk;
 
 	/* rtc */
 	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
 				    TEGRA_PERIPH_NO_RESET,
 				    clk_base, 0, 4, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "rtc-tegra");
 	clks[TEGRA20_CLK_RTC] = clk;
 
 	/* timer */
 	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base,
 				    0, 5, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "timer");
 	clks[TEGRA20_CLK_TIMER] = clk;
 
 	/* kbc */
 	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
 				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 36, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra-kbc");
 	clks[TEGRA20_CLK_KBC] = clk;
 
 	/* csus */
 	clk = tegra_clk_register_periph_gate("csus", "clk_m",
 				    TEGRA_PERIPH_NO_RESET,
 				    clk_base, 0, 92, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "csus", "tengra_camera");
 	clks[TEGRA20_CLK_CSUS] = clk;
 
 	/* vcp */
 	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0,
 				    clk_base, 0, 29, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "vcp", "tegra-avp");
 	clks[TEGRA20_CLK_VCP] = clk;
 
 	/* bsea */
 	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0,
 				    clk_base, 0, 62, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "bsea", "tegra-avp");
 	clks[TEGRA20_CLK_BSEA] = clk;
 
 	/* bsev */
 	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0,
 				    clk_base, 0, 63, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "bsev", "tegra-aes");
 	clks[TEGRA20_CLK_BSEV] = clk;
 
 	/* emc */
@@ -878,25 +944,21 @@ static void __init tegra20_periph_clk_init(void)
 			       30, 2, 0, NULL);
 	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base, 0,
 				    57, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "emc", NULL);
 	clks[TEGRA20_CLK_EMC] = clk;
 
 	/* usbd */
 	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base, 0,
 				    22, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "fsl-tegra-udc");
 	clks[TEGRA20_CLK_USBD] = clk;
 
 	/* usb2 */
 	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base, 0,
 				    58, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra-ehci.1");
 	clks[TEGRA20_CLK_USB2] = clk;
 
 	/* usb3 */
 	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base, 0,
 				    59, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra-ehci.2");
 	clks[TEGRA20_CLK_USB3] = clk;
 
 	/* dsi */
@@ -914,25 +976,21 @@ static void __init tegra20_periph_clk_init(void)
 	/* isp */
 	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0, 23,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "isp", "tegra_camera");
 	clks[TEGRA20_CLK_ISP] = clk;
 
 	/* pex */
 	clk = tegra_clk_register_periph_gate("pex", "clk_m", 0, clk_base, 0, 70,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "pex", NULL);
 	clks[TEGRA20_CLK_PEX] = clk;
 
 	/* afi */
 	clk = tegra_clk_register_periph_gate("afi", "clk_m", 0, clk_base, 0, 72,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "afi", NULL);
 	clks[TEGRA20_CLK_AFI] = clk;
 
 	/* pcie_xclk */
 	clk = tegra_clk_register_periph_gate("pcie_xclk", "clk_m", 0, clk_base,
 				    0, 74, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "pcie_xclk", NULL);
 	clks[TEGRA20_CLK_PCIE_XCLK] = clk;
 
 	/* cdev1 */
@@ -940,7 +998,6 @@ static void __init tegra20_periph_clk_init(void)
 				      26000000);
 	clk = tegra_clk_register_periph_gate("cdev1", "cdev1_fixed", 0,
 				    clk_base, 0, 94, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "cdev1", NULL);
 	clks[TEGRA20_CLK_CDEV1] = clk;
 
 	/* cdev2 */
@@ -948,7 +1005,6 @@ static void __init tegra20_periph_clk_init(void)
 				      26000000);
 	clk = tegra_clk_register_periph_gate("cdev2", "cdev2_fixed", 0,
 				    clk_base, 0, 93, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "cdev2", NULL);
 	clks[TEGRA20_CLK_CDEV2] = clk;
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
@@ -956,7 +1012,6 @@ static void __init tegra20_periph_clk_init(void)
 		clk = tegra_clk_register_periph(data->name, data->p.parent_names,
 				data->num_parents, &data->periph,
 				clk_base, data->offset, data->flags);
-		clk_register_clkdev(clk, data->con_id, data->dev_id);
 		clks[data->clk_id] = clk;
 	}
 
@@ -966,7 +1021,6 @@ static void __init tegra20_periph_clk_init(void)
 					data->p.parent_names,
 					data->num_parents, &data->periph,
 					clk_base, data->offset);
-		clk_register_clkdev(clk, data->con_id, data->dev_id);
 		clks[data->clk_id] = clk;
 	}
 }
@@ -979,7 +1033,6 @@ static void __init tegra20_fixed_clk_init(void)
 	/* clk_32k */
 	clk = clk_register_fixed_rate(NULL, "clk_32k", NULL, CLK_IS_ROOT,
 				      32768);
-	clk_register_clkdev(clk, "clk_32k", NULL);
 	clks[TEGRA20_CLK_CLK_32K] = clk;
 }
 
@@ -995,7 +1048,6 @@ static void __init tegra20_pmc_clk_init(void)
 	clk = clk_register_gate(NULL, "blink", "blink_override", 0,
 				pmc_base + PMC_CTRL,
 				PMC_CTRL_BLINK_ENB, 0, NULL);
-	clk_register_clkdev(clk, "blink", NULL);
 	clks[TEGRA20_CLK_BLINK] = clk;
 }
 
@@ -1010,14 +1062,12 @@ static void __init tegra20_osc_clk_init(void)
 	/* clk_m */
 	clk = clk_register_fixed_rate(NULL, "clk_m", NULL, CLK_IS_ROOT |
 				      CLK_IGNORE_UNUSED, input_freq);
-	clk_register_clkdev(clk, "clk_m", NULL);
 	clks[TEGRA20_CLK_CLK_M] = clk;
 
 	/* pll_ref */
 	pll_ref_div = tegra20_get_pll_ref_div();
 	clk = clk_register_fixed_factor(NULL, "pll_ref", "clk_m",
 					CLK_SET_RATE_PARENT, 1, pll_ref_div);
-	clk_register_clkdev(clk, "pll_ref", NULL);
 	clks[TEGRA20_CLK_PLL_REF] = clk;
 }
 
@@ -1252,6 +1302,7 @@ static void __init tegra20_clock_init(struct device_node *np)
 	tegra_init_dup_clks(tegra_clk_duplicates, clks, TEGRA20_CLK_CLK_MAX);
 
 	tegra_add_of_provider(np);
+	tegra_register_devclks(devclks, ARRAY_SIZE(devclks));
 
 	tegra_clk_apply_init_table = tegra20_clock_apply_init_table;
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

