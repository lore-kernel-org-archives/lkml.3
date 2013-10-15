Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab3JOO63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:58:29 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16906 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab3JOO6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:58:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Oct 2013 07:58:24 -0700
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
Subject: [PATCH v3 18/19] clk: tegra20: move to common periph clk
Date: Tue, 15 Oct 2013 17:53:03 +0300
Message-ID: <1381848794-11761-19-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move tegra20 to the common periph clks.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra20.c |  314 +++++++++------------------------------
 1 files changed, 70 insertions(+), 244 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index ac7c8fb..726cb9f 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -25,6 +25,7 @@
 #include <dt-bindings/clock/tegra20-car.h>
 
 #include "clk.h"
+#include "clk-id.h"
 
 #define OSC_CTRL 0x50
 #define OSC_CTRL_OSC_FREQ_MASK (3<<30)
@@ -93,34 +94,15 @@
 
 #define CLK_SOURCE_I2S1 0x100
 #define CLK_SOURCE_I2S2 0x104
-#define CLK_SOURCE_SPDIF_OUT 0x108
-#define CLK_SOURCE_SPDIF_IN 0x10c
 #define CLK_SOURCE_PWM 0x110
 #define CLK_SOURCE_SPI 0x114
-#define CLK_SOURCE_SBC1 0x134
-#define CLK_SOURCE_SBC2 0x118
-#define CLK_SOURCE_SBC3 0x11c
-#define CLK_SOURCE_SBC4 0x1b4
 #define CLK_SOURCE_XIO 0x120
 #define CLK_SOURCE_TWC 0x12c
 #define CLK_SOURCE_IDE 0x144
-#define CLK_SOURCE_NDFLASH 0x160
-#define CLK_SOURCE_VFIR 0x168
-#define CLK_SOURCE_SDMMC1 0x150
-#define CLK_SOURCE_SDMMC2 0x154
-#define CLK_SOURCE_SDMMC3 0x1bc
-#define CLK_SOURCE_SDMMC4 0x164
-#define CLK_SOURCE_CVE 0x140
-#define CLK_SOURCE_TVO 0x188
-#define CLK_SOURCE_TVDAC 0x194
 #define CLK_SOURCE_HDMI 0x18c
 #define CLK_SOURCE_DISP1 0x138
 #define CLK_SOURCE_DISP2 0x13c
 #define CLK_SOURCE_CSITE 0x1d4
-#define CLK_SOURCE_LA 0x1f8
-#define CLK_SOURCE_OWR 0x1cc
-#define CLK_SOURCE_NOR 0x1d0
-#define CLK_SOURCE_MIPI 0x174
 #define CLK_SOURCE_I2C1 0x124
 #define CLK_SOURCE_I2C2 0x198
 #define CLK_SOURCE_I2C3 0x1b8
@@ -130,14 +112,6 @@
 #define CLK_SOURCE_UARTC 0x1a0
 #define CLK_SOURCE_UARTD 0x1c0
 #define CLK_SOURCE_UARTE 0x1c4
-#define CLK_SOURCE_3D 0x158
-#define CLK_SOURCE_2D 0x15c
-#define CLK_SOURCE_MPE 0x170
-#define CLK_SOURCE_EPP 0x16c
-#define CLK_SOURCE_HOST1X 0x180
-#define CLK_SOURCE_VDE 0x1c8
-#define CLK_SOURCE_VI 0x148
-#define CLK_SOURCE_VI_SENSOR 0x1a8
 #define CLK_SOURCE_EMC 0x19c
 
 #define AUDIO_SYNC_CLK 0x38
@@ -170,9 +144,6 @@ static struct cpu_clk_suspend_context {
 static void __iomem *clk_base;
 static void __iomem *pmc_base;
 
-static DEFINE_SPINLOCK(pll_div_lock);
-static DEFINE_SPINLOCK(sysrate_lock);
-
 #define TEGRA_INIT_DATA_MUX(_name, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
@@ -180,13 +151,6 @@ static DEFINE_SPINLOCK(sysrate_lock);
 			_clk_num, \
 			_gate_flags, _clk_id)
 
-#define TEGRA_INIT_DATA_INT(_name, _parents, _offset,	\
-			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
-			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_INT, \
-			_clk_num, _gate_flags,	\
-			_clk_id)
-
 #define TEGRA_INIT_DATA_DIV16(_name, _parents, _offset, \
 			      _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
@@ -563,6 +527,59 @@ static struct tegra_devclk devclks[] __initdata = {
 	{ .dev_id = "tegradc.1", .dt_id = TEGRA20_CLK_DISP2 },
 };
 
+static struct tegra_clk tegra20_clks[tegra_clk_max] __initdata = {
+	[tegra_clk_spdif_out] = { .dt_id = TEGRA20_CLK_SPDIF_OUT, .present = true },
+	[tegra_clk_spdif_in] = { .dt_id = TEGRA20_CLK_SPDIF_IN, .present = true },
+	[tegra_clk_sdmmc1] = { .dt_id = TEGRA20_CLK_SDMMC1, .present = true },
+	[tegra_clk_sdmmc2] = { .dt_id = TEGRA20_CLK_SDMMC2, .present = true },
+	[tegra_clk_sdmmc3] = { .dt_id = TEGRA20_CLK_SDMMC3, .present = true },
+	[tegra_clk_sdmmc4] = { .dt_id = TEGRA20_CLK_SDMMC4, .present = true },
+	[tegra_clk_la] = { .dt_id = TEGRA20_CLK_LA, .present = true },
+	[tegra_clk_csite] = { .dt_id = TEGRA20_CLK_CSITE, .present = true },
+	[tegra_clk_vfir] = { .dt_id = TEGRA20_CLK_VFIR, .present = true },
+	[tegra_clk_mipi] = { .dt_id = TEGRA20_CLK_MIPI, .present = true },
+	[tegra_clk_nor] = { .dt_id = TEGRA20_CLK_NOR, .present = true },
+	[tegra_clk_rtc] = { .dt_id = TEGRA20_CLK_RTC, .present = true },
+	[tegra_clk_timer] = { .dt_id = TEGRA20_CLK_TIMER, .present = true },
+	[tegra_clk_kbc] = { .dt_id = TEGRA20_CLK_KBC, .present = true },
+	[tegra_clk_csus] = { .dt_id = TEGRA20_CLK_CSUS, .present = true },
+	[tegra_clk_vcp] = { .dt_id = TEGRA20_CLK_VCP, .present = true },
+	[tegra_clk_bsea] = { .dt_id = TEGRA20_CLK_BSEA, .present = true },
+	[tegra_clk_bsev] = { .dt_id = TEGRA20_CLK_BSEV, .present = true },
+	[tegra_clk_usbd] = { .dt_id = TEGRA20_CLK_USBD, .present = true },
+	[tegra_clk_usb2] = { .dt_id = TEGRA20_CLK_USB2, .present = true },
+	[tegra_clk_usb3] = { .dt_id = TEGRA20_CLK_USB3, .present = true },
+	[tegra_clk_csi] = { .dt_id = TEGRA20_CLK_CSI, .present = true },
+	[tegra_clk_isp] = { .dt_id = TEGRA20_CLK_ISP, .present = true },
+	[tegra_clk_clk_32k] = { .dt_id = TEGRA20_CLK_CLK_32K, .present = true },
+	[tegra_clk_blink] = { .dt_id = TEGRA20_CLK_BLINK, .present = true },
+	[tegra_clk_hclk] = { .dt_id = TEGRA20_CLK_HCLK, .present = true },
+	[tegra_clk_pclk] = { .dt_id = TEGRA20_CLK_PCLK, .present = true },
+	[tegra_clk_pll_p_out1] = { .dt_id = TEGRA20_CLK_PLL_P_OUT1, .present = true },
+	[tegra_clk_pll_p_out2] = { .dt_id = TEGRA20_CLK_PLL_P_OUT2, .present = true },
+	[tegra_clk_pll_p_out3] = { .dt_id = TEGRA20_CLK_PLL_P_OUT3, .present = true },
+	[tegra_clk_pll_p_out4] = { .dt_id = TEGRA20_CLK_PLL_P_OUT4, .present = true },
+	[tegra_clk_pll_p] = { .dt_id = TEGRA20_CLK_PLL_P, .present = true },
+	[tegra_clk_owr] = { .dt_id = TEGRA20_CLK_OWR, .present = true },
+	[tegra_clk_sbc1] = { .dt_id = TEGRA20_CLK_SBC1, .present = true },
+	[tegra_clk_sbc2] = { .dt_id = TEGRA20_CLK_SBC2, .present = true },
+	[tegra_clk_sbc3] = { .dt_id = TEGRA20_CLK_SBC3, .present = true },
+	[tegra_clk_sbc4] = { .dt_id = TEGRA20_CLK_SBC4, .present = true },
+	[tegra_clk_vde] = { .dt_id = TEGRA20_CLK_VDE, .present = true },
+	[tegra_clk_vi] = { .dt_id = TEGRA20_CLK_VI, .present = true },
+	[tegra_clk_epp] = { .dt_id = TEGRA20_CLK_EPP, .present = true },
+	[tegra_clk_mpe] = { .dt_id = TEGRA20_CLK_MPE, .present = true },
+	[tegra_clk_host1x] = { .dt_id = TEGRA20_CLK_HOST1X, .present = true },
+	[tegra_clk_gr2d] = { .dt_id = TEGRA20_CLK_GR2D, .present = true },
+	[tegra_clk_gr3d] = { .dt_id = TEGRA20_CLK_GR3D, .present = true },
+	[tegra_clk_ndflash] = { .dt_id = TEGRA20_CLK_NDFLASH, .present = true },
+	[tegra_clk_cve] = { .dt_id = TEGRA20_CLK_CVE, .present = true },
+	[tegra_clk_tvo] = { .dt_id = TEGRA20_CLK_TVO, .present = true },
+	[tegra_clk_tvdac] = { .dt_id = TEGRA20_CLK_TVDAC, .present = true },
+	[tegra_clk_vi_sensor] = { .dt_id = TEGRA20_CLK_VI_SENSOR, .present = true },
+	[tegra_clk_afi] = { .dt_id = TEGRA20_CLK_AFI, .present = true },
+};
+
 static unsigned long tegra20_clk_measure_input_freq(void)
 {
 	u32 osc_ctrl = readl_relaxed(clk_base + OSC_CTRL);
@@ -634,55 +651,6 @@ static void tegra20_pll_init(void)
 				0, NULL);
 	clks[TEGRA20_CLK_PLL_C_OUT1] = clk;
 
-	/* PLLP */
-	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, NULL, 0,
-			    &pll_p_params, NULL);
-	clks[TEGRA20_CLK_PLL_P] = clk;
-
-	/* PLLP_OUT1 */
-	clk = tegra_clk_register_divider("pll_p_out1_div", "pll_p",
-				clk_base + PLLP_OUTA, 0,
-				TEGRA_DIVIDER_FIXED | TEGRA_DIVIDER_ROUND_UP,
-				8, 8, 1, &pll_div_lock);
-	clk = tegra_clk_register_pll_out("pll_p_out1", "pll_p_out1_div",
-				clk_base + PLLP_OUTA, 1, 0,
-				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
-				&pll_div_lock);
-	clks[TEGRA20_CLK_PLL_P_OUT1] = clk;
-
-	/* PLLP_OUT2 */
-	clk = tegra_clk_register_divider("pll_p_out2_div", "pll_p",
-				clk_base + PLLP_OUTA, 0,
-				TEGRA_DIVIDER_FIXED | TEGRA_DIVIDER_ROUND_UP,
-				24, 8, 1, &pll_div_lock);
-	clk = tegra_clk_register_pll_out("pll_p_out2", "pll_p_out2_div",
-				clk_base + PLLP_OUTA, 17, 16,
-				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
-				&pll_div_lock);
-	clks[TEGRA20_CLK_PLL_P_OUT2] = clk;
-
-	/* PLLP_OUT3 */
-	clk = tegra_clk_register_divider("pll_p_out3_div", "pll_p",
-				clk_base + PLLP_OUTB, 0,
-				TEGRA_DIVIDER_FIXED | TEGRA_DIVIDER_ROUND_UP,
-				8, 8, 1, &pll_div_lock);
-	clk = tegra_clk_register_pll_out("pll_p_out3", "pll_p_out3_div",
-				clk_base + PLLP_OUTB, 1, 0,
-				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
-				&pll_div_lock);
-	clks[TEGRA20_CLK_PLL_P_OUT3] = clk;
-
-	/* PLLP_OUT4 */
-	clk = tegra_clk_register_divider("pll_p_out4_div", "pll_p",
-				clk_base + PLLP_OUTB, 0,
-				TEGRA_DIVIDER_FIXED | TEGRA_DIVIDER_ROUND_UP,
-				24, 8, 1, &pll_div_lock);
-	clk = tegra_clk_register_pll_out("pll_p_out4", "pll_p_out4_div",
-				clk_base + PLLP_OUTB, 17, 16,
-				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
-				&pll_div_lock);
-	clks[TEGRA20_CLK_PLL_P_OUT4] = clk;
-
 	/* PLLM */
 	clk = tegra_clk_register_pll("pll_m", "pll_ref", clk_base, NULL,
 			    CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE,
@@ -761,24 +729,6 @@ static void tegra20_super_clk_init(void)
 			      clk_base + SCLK_BURST_POLICY, 0, 4, 0, 0, NULL);
 	clks[TEGRA20_CLK_SCLK] = clk;
 
-	/* HCLK */
-	clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
-				   clk_base + CLK_SYSTEM_RATE, 4, 2, 0,
-				   &sysrate_lock);
-	clk = clk_register_gate(NULL, "hclk", "hclk_div", CLK_SET_RATE_PARENT,
-				clk_base + CLK_SYSTEM_RATE, 7,
-				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clks[TEGRA20_CLK_HCLK] = clk;
-
-	/* PCLK */
-	clk = clk_register_divider(NULL, "pclk_div", "hclk", 0,
-				   clk_base + CLK_SYSTEM_RATE, 0, 2, 0,
-				   &sysrate_lock);
-	clk = clk_register_gate(NULL, "pclk", "pclk_div", CLK_SET_RATE_PARENT,
-				clk_base + CLK_SYSTEM_RATE, 3,
-				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clks[TEGRA20_CLK_PCLK] = clk;
-
 	/* twd */
 	clk = clk_register_fixed_factor(NULL, "twd", "cclk", 0, 1, 4);
 	clks[TEGRA20_CLK_TWD] = clk;
@@ -817,58 +767,26 @@ static const char *i2s1_parents[] = {"pll_a_out0", "audio_2x", "pll_p",
 				     "clk_m"};
 static const char *i2s2_parents[] = {"pll_a_out0", "audio_2x", "pll_p",
 				     "clk_m"};
-static const char *spdif_out_parents[] = {"pll_a_out0", "audio_2x", "pll_p",
-					  "clk_m"};
-static const char *spdif_in_parents[] = {"pll_p", "pll_c", "pll_m"};
 static const char *pwm_parents[] = {"pll_p", "pll_c", "audio", "clk_m",
 				    "clk_32k"};
 static const char *mux_pllpcm_clkm[] = {"pll_p", "pll_c", "pll_m", "clk_m"};
-static const char *mux_pllmcpa[] = {"pll_m", "pll_c", "pll_c", "pll_a"};
 static const char *mux_pllpdc_clkm[] = {"pll_p", "pll_d_out0", "pll_c",
 					"clk_m"};
 static const char *mux_pllmcp_clkm[] = {"pll_m", "pll_c", "pll_p", "clk_m"};
 
 static struct tegra_periph_init_data tegra_periph_clk_list[] = {
-	TEGRA_INIT_DATA_MUX("i2s1", i2s1_parents,     CLK_SOURCE_I2S1,   11,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2S1),
-	TEGRA_INIT_DATA_MUX("i2s2", i2s2_parents,     CLK_SOURCE_I2S2,   18,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2S2),
-	TEGRA_INIT_DATA_MUX("spdif_out", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SPDIF_OUT),
-	TEGRA_INIT_DATA_MUX("spdif_in", spdif_in_parents,  CLK_SOURCE_SPDIF_IN,  10,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SPDIF_IN),
-	TEGRA_INIT_DATA_MUX("sbc1",  mux_pllpcm_clkm,   CLK_SOURCE_SBC1,   41,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC1),
-	TEGRA_INIT_DATA_MUX("sbc2",  mux_pllpcm_clkm,   CLK_SOURCE_SBC2,   44,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC2),
-	TEGRA_INIT_DATA_MUX("sbc3",  mux_pllpcm_clkm,   CLK_SOURCE_SBC3,   46,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC3),
-	TEGRA_INIT_DATA_MUX("sbc4",  mux_pllpcm_clkm,   CLK_SOURCE_SBC4,   68,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SBC4),
-	TEGRA_INIT_DATA_MUX("spi",   mux_pllpcm_clkm,   CLK_SOURCE_SPI,   43,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SPI),
-	TEGRA_INIT_DATA_MUX("xio",   mux_pllpcm_clkm,   CLK_SOURCE_XIO,   45,  0, TEGRA20_CLK_XIO),
-	TEGRA_INIT_DATA_MUX("twc",   mux_pllpcm_clkm,   CLK_SOURCE_TWC,   16,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_TWC),
-	TEGRA_INIT_DATA_MUX("ide",   mux_pllpcm_clkm,   CLK_SOURCE_XIO,   25,  0, TEGRA20_CLK_IDE),
-	TEGRA_INIT_DATA_MUX("ndflash",  mux_pllpcm_clkm,   CLK_SOURCE_NDFLASH,   13,  0, TEGRA20_CLK_NDFLASH),
-	TEGRA_INIT_DATA_MUX("vfir",   mux_pllpcm_clkm,   CLK_SOURCE_VFIR,   7,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_VFIR),
-	TEGRA_INIT_DATA_MUX("csite",  mux_pllpcm_clkm,   CLK_SOURCE_CSITE,   73,  0, TEGRA20_CLK_CSITE),
-	TEGRA_INIT_DATA_MUX("la",   mux_pllpcm_clkm,   CLK_SOURCE_LA,   76,  0, TEGRA20_CLK_LA),
-	TEGRA_INIT_DATA_MUX("owr",  mux_pllpcm_clkm,   CLK_SOURCE_OWR,   71,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_OWR),
-	TEGRA_INIT_DATA_MUX("mipi",   mux_pllpcm_clkm,   CLK_SOURCE_MIPI,   50,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_MIPI),
-	TEGRA_INIT_DATA_MUX("vde",   mux_pllpcm_clkm,   CLK_SOURCE_VDE,   61,  0, TEGRA20_CLK_VDE),
-	TEGRA_INIT_DATA_MUX("vi",  mux_pllmcpa,     CLK_SOURCE_VI,   20,  0, TEGRA20_CLK_VI),
-	TEGRA_INIT_DATA_MUX("epp",   mux_pllmcpa,     CLK_SOURCE_EPP,   19,  0, TEGRA20_CLK_EPP),
-	TEGRA_INIT_DATA_MUX("mpe",   mux_pllmcpa,     CLK_SOURCE_MPE,   60,  0, TEGRA20_CLK_MPE),
-	TEGRA_INIT_DATA_MUX("host1x",  mux_pllmcpa,     CLK_SOURCE_HOST1X,   28,  0, TEGRA20_CLK_HOST1X),
-	TEGRA_INIT_DATA_MUX("3d",   mux_pllmcpa,     CLK_SOURCE_3D,   24,  TEGRA_PERIPH_MANUAL_RESET, TEGRA20_CLK_GR3D),
-	TEGRA_INIT_DATA_MUX("2d",   mux_pllmcpa,     CLK_SOURCE_2D,   21,  0, TEGRA20_CLK_GR2D),
-	TEGRA_INIT_DATA_MUX("nor",  mux_pllpcm_clkm,   CLK_SOURCE_NOR,   42,  0, TEGRA20_CLK_NOR),
-	TEGRA_INIT_DATA_MUX("sdmmc1", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC1,   14,  0, TEGRA20_CLK_SDMMC1),
-	TEGRA_INIT_DATA_MUX("sdmmc2", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC2,   9,  0, TEGRA20_CLK_SDMMC2),
-	TEGRA_INIT_DATA_MUX("sdmmc3", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC3,   69,  0, TEGRA20_CLK_SDMMC3),
-	TEGRA_INIT_DATA_MUX("sdmmc4", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC4,   15,  0, TEGRA20_CLK_SDMMC4),
-	TEGRA_INIT_DATA_MUX("cve",   mux_pllpdc_clkm,   CLK_SOURCE_CVE,   49,  0, TEGRA20_CLK_CVE),
-	TEGRA_INIT_DATA_MUX("tvo",   mux_pllpdc_clkm,   CLK_SOURCE_TVO,   49,  0, TEGRA20_CLK_TVO),
-	TEGRA_INIT_DATA_MUX("tvdac",  mux_pllpdc_clkm,   CLK_SOURCE_TVDAC,   53,  0, TEGRA20_CLK_TVDAC),
-	TEGRA_INIT_DATA_MUX("vi_sensor",  mux_pllmcpa,     CLK_SOURCE_VI_SENSOR, 20,  TEGRA_PERIPH_NO_RESET, TEGRA20_CLK_VI_SENSOR),
-	TEGRA_INIT_DATA_DIV16("i2c1", mux_pllpcm_clkm,   CLK_SOURCE_I2C1,   12,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C1),
-	TEGRA_INIT_DATA_DIV16("i2c2", mux_pllpcm_clkm,   CLK_SOURCE_I2C2,   54,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C2),
-	TEGRA_INIT_DATA_DIV16("i2c3", mux_pllpcm_clkm,   CLK_SOURCE_I2C3,   67,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C3),
-	TEGRA_INIT_DATA_DIV16("dvc", mux_pllpcm_clkm,   CLK_SOURCE_DVC,   47,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_DVC),
-	TEGRA_INIT_DATA_MUX("hdmi", mux_pllpdc_clkm,   CLK_SOURCE_HDMI,   51,  0, TEGRA20_CLK_HDMI),
-	TEGRA_INIT_DATA("pwm", NULL, NULL, pwm_parents,     CLK_SOURCE_PWM,   28, 3, 0, 0, 8, 1, 0,  17, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_PWM),
+	TEGRA_INIT_DATA_MUX("i2s1", i2s1_parents,     CLK_SOURCE_I2S1,   11, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2S1),
+	TEGRA_INIT_DATA_MUX("i2s2", i2s2_parents,     CLK_SOURCE_I2S2,   18, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2S2),
+	TEGRA_INIT_DATA_MUX("spi",   mux_pllpcm_clkm,   CLK_SOURCE_SPI,   43, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_SPI),
+	TEGRA_INIT_DATA_MUX("xio",   mux_pllpcm_clkm,   CLK_SOURCE_XIO,   45, 0, TEGRA20_CLK_XIO),
+	TEGRA_INIT_DATA_MUX("twc",   mux_pllpcm_clkm,   CLK_SOURCE_TWC,   16, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_TWC),
+	TEGRA_INIT_DATA_MUX("ide",   mux_pllpcm_clkm,   CLK_SOURCE_XIO,   25, 0, TEGRA20_CLK_IDE),
+	TEGRA_INIT_DATA_DIV16("dvc", mux_pllpcm_clkm,   CLK_SOURCE_DVC,   47, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_DVC),
+	TEGRA_INIT_DATA_DIV16("i2c1", mux_pllpcm_clkm,   CLK_SOURCE_I2C1,   12, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C1),
+	TEGRA_INIT_DATA_DIV16("i2c2", mux_pllpcm_clkm,   CLK_SOURCE_I2C2,   54, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C2),
+	TEGRA_INIT_DATA_DIV16("i2c3", mux_pllpcm_clkm,   CLK_SOURCE_I2C3,   67, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2C3),
+	TEGRA_INIT_DATA_MUX("hdmi", mux_pllpdc_clkm,   CLK_SOURCE_HDMI,   51, 0, TEGRA20_CLK_HDMI),
+	TEGRA_INIT_DATA("pwm", NULL, NULL, pwm_parents,     CLK_SOURCE_PWM,   28, 3, 0, 0, 8, 1, 0, 17, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_PWM),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
@@ -898,44 +816,6 @@ static void __init tegra20_periph_clk_init(void)
 				    0, 34, periph_clk_enb_refcnt);
 	clks[TEGRA20_CLK_APBDMA] = clk;
 
-	/* rtc */
-	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
-				    TEGRA_PERIPH_NO_RESET,
-				    clk_base, 0, 4, periph_clk_enb_refcnt);
-	clks[TEGRA20_CLK_RTC] = clk;
-
-	/* timer */
-	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base,
-				    0, 5, periph_clk_enb_refcnt);
-	clks[TEGRA20_CLK_TIMER] = clk;
-
-	/* kbc */
-	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
-				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 36, periph_clk_enb_refcnt);
-	clks[TEGRA20_CLK_KBC] = clk;
-
-	/* csus */
-	clk = tegra_clk_register_periph_gate("csus", "clk_m",
-				    TEGRA_PERIPH_NO_RESET,
-				    clk_base, 0, 92, periph_clk_enb_refcnt);
-	clks[TEGRA20_CLK_CSUS] = clk;
-
-	/* vcp */
-	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0,
-				    clk_base, 0, 29, periph_clk_enb_refcnt);
-	clks[TEGRA20_CLK_VCP] = clk;
-
-	/* bsea */
-	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0,
-				    clk_base, 0, 62, periph_clk_enb_refcnt);
-	clks[TEGRA20_CLK_BSEA] = clk;
-
-	/* bsev */
-	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0,
-				    clk_base, 0, 63, periph_clk_enb_refcnt);
-	clks[TEGRA20_CLK_BSEV] = clk;
-
 	/* emc */
 	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
 			       ARRAY_SIZE(mux_pllmcp_clkm),
@@ -946,48 +826,17 @@ static void __init tegra20_periph_clk_init(void)
 				    57, periph_clk_enb_refcnt);
 	clks[TEGRA20_CLK_EMC] = clk;
 
-	/* usbd */
-	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base, 0,
-				    22, periph_clk_enb_refcnt);
-	clks[TEGRA20_CLK_USBD] = clk;
-
-	/* usb2 */
-	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base, 0,
-				    58, periph_clk_enb_refcnt);
-	clks[TEGRA20_CLK_USB2] = clk;
-
-	/* usb3 */
-	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base, 0,
-				    59, periph_clk_enb_refcnt);
-	clks[TEGRA20_CLK_USB3] = clk;
-
 	/* dsi */
 	clk = tegra_clk_register_periph_gate("dsi", "pll_d", 0, clk_base, 0,
 				    48, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "dsi");
 	clks[TEGRA20_CLK_DSI] = clk;
 
-	/* csi */
-	clk = tegra_clk_register_periph_gate("csi", "pll_p_out3", 0, clk_base,
-				    0, 52, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "csi", "tegra_camera");
-	clks[TEGRA20_CLK_CSI] = clk;
-
-	/* isp */
-	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0, 23,
-				    periph_clk_enb_refcnt);
-	clks[TEGRA20_CLK_ISP] = clk;
-
 	/* pex */
 	clk = tegra_clk_register_periph_gate("pex", "clk_m", 0, clk_base, 0, 70,
 				    periph_clk_enb_refcnt);
 	clks[TEGRA20_CLK_PEX] = clk;
 
-	/* afi */
-	clk = tegra_clk_register_periph_gate("afi", "clk_m", 0, clk_base, 0, 72,
-				    periph_clk_enb_refcnt);
-	clks[TEGRA20_CLK_AFI] = clk;
-
 	/* pcie_xclk */
 	clk = tegra_clk_register_periph_gate("pcie_xclk", "clk_m", 0, clk_base,
 				    0, 74, periph_clk_enb_refcnt);
@@ -1023,32 +872,8 @@ static void __init tegra20_periph_clk_init(void)
 					clk_base, data->offset);
 		clks[data->clk_id] = clk;
 	}
-}
-
-
-static void __init tegra20_fixed_clk_init(void)
-{
-	struct clk *clk;
-
-	/* clk_32k */
-	clk = clk_register_fixed_rate(NULL, "clk_32k", NULL, CLK_IS_ROOT,
-				      32768);
-	clks[TEGRA20_CLK_CLK_32K] = clk;
-}
-
-static void __init tegra20_pmc_clk_init(void)
-{
-	struct clk *clk;
 
-	/* blink */
-	writel_relaxed(0, pmc_base + PMC_BLINK_TIMER);
-	clk = clk_register_gate(NULL, "blink_override", "clk_32k", 0,
-				pmc_base + PMC_DPD_PADS_ORIDE,
-				PMC_DPD_PADS_ORIDE_BLINK_ENB, 0, NULL);
-	clk = clk_register_gate(NULL, "blink", "blink_override", 0,
-				pmc_base + PMC_CTRL,
-				PMC_CTRL_BLINK_ENB, 0, NULL);
-	clks[TEGRA20_CLK_BLINK] = clk;
+	tegra_periph_clk_init(clk_base, pmc_base, tegra20_clks, &pll_p_params);
 }
 
 static void __init tegra20_osc_clk_init(void)
@@ -1292,12 +1117,13 @@ static void __init tegra20_clock_init(struct device_node *np)
 		return;
 
 	tegra20_osc_clk_init();
-	tegra20_pmc_clk_init();
-	tegra20_fixed_clk_init();
+	tegra_fixed_clk_init(tegra20_clks);
 	tegra20_pll_init();
 	tegra20_super_clk_init();
+	tegra_super_clk_gen4_init(clk_base, pmc_base, tegra20_clks, NULL);
 	tegra20_periph_clk_init();
 	tegra20_audio_clk_init();
+	tegra_pmc_clk_init(pmc_base, tegra20_clks);
 
 	tegra_init_dup_clks(tegra_clk_duplicates, clks, TEGRA20_CLK_CLK_MAX);
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

