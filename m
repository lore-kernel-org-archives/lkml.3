Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab3JOO6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:58:39 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10616 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab3JOO6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:58:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Oct 2013 07:58:35 -0700
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
Subject: [PATCH v3 19/19] clk: tegra30: move to common tegra clk infra
Date: Tue, 15 Oct 2013 17:53:04 +0300
Message-ID: <1381848794-11761-20-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move tegra30 to the common tegra clks.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra30.c |  843 ++++++++-------------------------------
 1 files changed, 159 insertions(+), 684 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 0834eeb..8346aad 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -25,6 +25,7 @@
 #include <linux/tegra-powergate.h>
 #include <dt-bindings/clock/tegra30-car.h>
 #include "clk.h"
+#include "clk-id.h"
 
 #define OSC_CTRL			0x50
 #define OSC_CTRL_OSC_FREQ_MASK		(0xF<<28)
@@ -100,75 +101,16 @@
 
 #define PMC_CLK_OUT_CNTRL 0x1a8
 
-#define CLK_SOURCE_I2S0 0x1d8
-#define CLK_SOURCE_I2S1 0x100
-#define CLK_SOURCE_I2S2 0x104
-#define CLK_SOURCE_I2S3 0x3bc
-#define CLK_SOURCE_I2S4 0x3c0
 #define CLK_SOURCE_SPDIF_OUT 0x108
-#define CLK_SOURCE_SPDIF_IN 0x10c
-#define CLK_SOURCE_PWM 0x110
 #define CLK_SOURCE_D_AUDIO 0x3d0
 #define CLK_SOURCE_DAM0 0x3d8
 #define CLK_SOURCE_DAM1 0x3dc
 #define CLK_SOURCE_DAM2 0x3e0
-#define CLK_SOURCE_HDA 0x428
-#define CLK_SOURCE_HDA2CODEC_2X 0x3e4
-#define CLK_SOURCE_SBC1 0x134
-#define CLK_SOURCE_SBC2 0x118
-#define CLK_SOURCE_SBC3 0x11c
-#define CLK_SOURCE_SBC4 0x1b4
-#define CLK_SOURCE_SBC5 0x3c8
-#define CLK_SOURCE_SBC6 0x3cc
-#define CLK_SOURCE_SATA_OOB 0x420
-#define CLK_SOURCE_SATA 0x424
-#define CLK_SOURCE_NDFLASH 0x160
-#define CLK_SOURCE_NDSPEED 0x3f8
-#define CLK_SOURCE_VFIR 0x168
-#define CLK_SOURCE_SDMMC1 0x150
-#define CLK_SOURCE_SDMMC2 0x154
-#define CLK_SOURCE_SDMMC3 0x1bc
-#define CLK_SOURCE_SDMMC4 0x164
-#define CLK_SOURCE_VDE 0x1c8
-#define CLK_SOURCE_CSITE 0x1d4
-#define CLK_SOURCE_LA 0x1f8
-#define CLK_SOURCE_OWR 0x1cc
-#define CLK_SOURCE_NOR 0x1d0
-#define CLK_SOURCE_MIPI 0x174
-#define CLK_SOURCE_I2C1 0x124
-#define CLK_SOURCE_I2C2 0x198
-#define CLK_SOURCE_I2C3 0x1b8
-#define CLK_SOURCE_I2C4 0x3c4
-#define CLK_SOURCE_I2C5 0x128
-#define CLK_SOURCE_UARTA 0x178
-#define CLK_SOURCE_UARTB 0x17c
-#define CLK_SOURCE_UARTC 0x1a0
-#define CLK_SOURCE_UARTD 0x1c0
-#define CLK_SOURCE_UARTE 0x1c4
-#define CLK_SOURCE_VI 0x148
-#define CLK_SOURCE_VI_SENSOR 0x1a8
-#define CLK_SOURCE_3D 0x158
 #define CLK_SOURCE_3D2 0x3b0
 #define CLK_SOURCE_2D 0x15c
-#define CLK_SOURCE_EPP 0x16c
-#define CLK_SOURCE_MPE 0x170
-#define CLK_SOURCE_HOST1X 0x180
-#define CLK_SOURCE_CVE 0x140
-#define CLK_SOURCE_TVO 0x188
-#define CLK_SOURCE_DTV 0x1dc
 #define CLK_SOURCE_HDMI 0x18c
-#define CLK_SOURCE_TVDAC 0x194
-#define CLK_SOURCE_DISP1 0x138
-#define CLK_SOURCE_DISP2 0x13c
 #define CLK_SOURCE_DSIB 0xd0
-#define CLK_SOURCE_TSENSOR 0x3b8
-#define CLK_SOURCE_ACTMON 0x3e8
-#define CLK_SOURCE_EXTERN1 0x3ec
-#define CLK_SOURCE_EXTERN2 0x3f0
-#define CLK_SOURCE_EXTERN3 0x3f4
-#define CLK_SOURCE_I2CSLOW 0x3fc
 #define CLK_SOURCE_SE 0x42c
-#define CLK_SOURCE_MSELECT 0x3b4
 #define CLK_SOURCE_EMC 0x19c
 
 #define AUDIO_SYNC_DOUBLER 0x49c
@@ -236,12 +178,8 @@ static void __iomem *clk_base;
 static void __iomem *pmc_base;
 static unsigned long input_freq;
 
-static DEFINE_SPINLOCK(clk_doubler_lock);
-static DEFINE_SPINLOCK(clk_out_lock);
-static DEFINE_SPINLOCK(pll_div_lock);
 static DEFINE_SPINLOCK(cml_lock);
 static DEFINE_SPINLOCK(pll_d_lock);
-static DEFINE_SPINLOCK(sysrate_lock);
 
 #define TEGRA_INIT_DATA_MUX(_name, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
@@ -249,13 +187,6 @@ static DEFINE_SPINLOCK(sysrate_lock);
 			30, 2, 0, 0, 8, 1, 0, _clk_num,		\
 			_gate_flags, _clk_id)
 
-#define TEGRA_INIT_DATA_DIV16(_name, _parents, _offset, \
-			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
-			30, 2, 0, 0, 16, 0, TEGRA_DIVIDER_ROUND_UP,	\
-			_clk_num, \
-			_gate_flags, _clk_id)
-
 #define TEGRA_INIT_DATA_MUX8(_name, _parents, _offset, \
 			     _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
@@ -269,12 +200,6 @@ static DEFINE_SPINLOCK(sysrate_lock);
 			_clk_num, _gate_flags,	\
 			_clk_id)
 
-#define TEGRA_INIT_DATA_UART(_name, _parents, _offset,\
-			     _clk_num, _clk_id)			\
-	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
-			30, 2, 0, 0, 16, 1, TEGRA_DIVIDER_UART,\
-			_clk_num, 0, _clk_id)
-
 #define TEGRA_INIT_DATA_NODIV(_name, _parents, _offset, \
 			      _mux_shift, _mux_width, _clk_num, \
 			      _gate_flags, _clk_id)			\
@@ -654,6 +579,16 @@ static struct tegra_clk_pll_params pll_e_params = {
 	.fixed_rate = 100000000,
 };
 
+static unsigned long tegra30_input_freq[] = {
+	[0] = 13000000,
+	[1] = 16800000,
+	[4] = 19200000,
+	[5] = 38400000,
+	[8] = 12000000,
+	[9] = 48000000,
+	[12] = 260000000,
+};
+
 static struct tegra_devclk devclks[] __initdata = {
 	{ .con_id = "pll_c", .dt_id = TEGRA30_CLK_PLL_C },
 	{ .con_id = "pll_c_out1", .dt_id = TEGRA30_CLK_PLL_C_OUT1 },
@@ -805,67 +740,134 @@ static struct tegra_devclk devclks[] __initdata = {
 	{ .dev_id = "tegradc.1", .dt_id = TEGRA30_CLK_DSIB },
 };
 
-static void tegra30_clk_measure_input_freq(void)
-{
-	u32 osc_ctrl = readl_relaxed(clk_base + OSC_CTRL);
-	u32 auto_clk_control = osc_ctrl & OSC_CTRL_OSC_FREQ_MASK;
-	u32 pll_ref_div = osc_ctrl & OSC_CTRL_PLL_REF_DIV_MASK;
-
-	switch (auto_clk_control) {
-	case OSC_CTRL_OSC_FREQ_12MHZ:
-		BUG_ON(pll_ref_div != OSC_CTRL_PLL_REF_DIV_1);
-		input_freq = 12000000;
-		break;
-	case OSC_CTRL_OSC_FREQ_13MHZ:
-		BUG_ON(pll_ref_div != OSC_CTRL_PLL_REF_DIV_1);
-		input_freq = 13000000;
-		break;
-	case OSC_CTRL_OSC_FREQ_19_2MHZ:
-		BUG_ON(pll_ref_div != OSC_CTRL_PLL_REF_DIV_1);
-		input_freq = 19200000;
-		break;
-	case OSC_CTRL_OSC_FREQ_26MHZ:
-		BUG_ON(pll_ref_div != OSC_CTRL_PLL_REF_DIV_1);
-		input_freq = 26000000;
-		break;
-	case OSC_CTRL_OSC_FREQ_16_8MHZ:
-		BUG_ON(pll_ref_div != OSC_CTRL_PLL_REF_DIV_1);
-		input_freq = 16800000;
-		break;
-	case OSC_CTRL_OSC_FREQ_38_4MHZ:
-		BUG_ON(pll_ref_div != OSC_CTRL_PLL_REF_DIV_2);
-		input_freq = 38400000;
-		break;
-	case OSC_CTRL_OSC_FREQ_48MHZ:
-		BUG_ON(pll_ref_div != OSC_CTRL_PLL_REF_DIV_4);
-		input_freq = 48000000;
-		break;
-	default:
-		pr_err("Unexpected auto clock control value %d",
-			auto_clk_control);
-		BUG();
-		return;
-	}
-}
+static struct tegra_clk tegra30_clks[tegra_clk_max] __initdata = {
+	[tegra_clk_clk_32k] = { .dt_id = TEGRA30_CLK_CLK_32K, .present = true },
+	[tegra_clk_clk_m] = { .dt_id = TEGRA30_CLK_CLK_M, .present = true },
+	[tegra_clk_clk_m_div2] = { .dt_id = TEGRA30_CLK_CLK_M_DIV2, .present = true },
+	[tegra_clk_clk_m_div4] = { .dt_id = TEGRA30_CLK_CLK_M_DIV4, .present = true },
+	[tegra_clk_pll_ref] = { .dt_id = TEGRA30_CLK_PLL_REF, .present = true },
+	[tegra_clk_spdif_in_sync] = { .dt_id = TEGRA30_CLK_SPDIF_IN_SYNC, .present = true },
+	[tegra_clk_i2s0_sync] = { .dt_id = TEGRA30_CLK_I2S0_SYNC, .present = true },
+	[tegra_clk_i2s1_sync] = { .dt_id = TEGRA30_CLK_I2S1_SYNC, .present = true },
+	[tegra_clk_i2s2_sync] = { .dt_id = TEGRA30_CLK_I2S2_SYNC, .present = true },
+	[tegra_clk_i2s3_sync] = { .dt_id = TEGRA30_CLK_I2S3_SYNC, .present = true },
+	[tegra_clk_i2s4_sync] = { .dt_id = TEGRA30_CLK_I2S4_SYNC, .present = true },
+	[tegra_clk_vimclk_sync] = { .dt_id = TEGRA30_CLK_VIMCLK_SYNC, .present = true },
+	[tegra_clk_audio0] = { .dt_id = TEGRA30_CLK_AUDIO0, .present = true },
+	[tegra_clk_audio1] = { .dt_id = TEGRA30_CLK_AUDIO1, .present = true },
+	[tegra_clk_audio2] = { .dt_id = TEGRA30_CLK_AUDIO2, .present = true },
+	[tegra_clk_audio3] = { .dt_id = TEGRA30_CLK_AUDIO3, .present = true },
+	[tegra_clk_audio4] = { .dt_id = TEGRA30_CLK_AUDIO4, .present = true },
+	[tegra_clk_spdif] = { .dt_id = TEGRA30_CLK_SPDIF, .present = true },
+	[tegra_clk_audio0_mux] = { .dt_id = TEGRA30_CLK_AUDIO0_MUX, .present = true },
+	[tegra_clk_audio1_mux] = { .dt_id = TEGRA30_CLK_AUDIO1_MUX, .present = true },
+	[tegra_clk_audio2_mux] = { .dt_id = TEGRA30_CLK_AUDIO2_MUX, .present = true },
+	[tegra_clk_audio3_mux] = { .dt_id = TEGRA30_CLK_AUDIO3_MUX, .present = true },
+	[tegra_clk_audio4_mux] = { .dt_id = TEGRA30_CLK_AUDIO4_MUX, .present = true },
+	[tegra_clk_spdif_mux] = { .dt_id = TEGRA30_CLK_SPDIF_MUX, .present = true },
+	[tegra_clk_audio0_2x] = { .dt_id = TEGRA30_CLK_AUDIO0_2X, .present = true },
+	[tegra_clk_audio1_2x] = { .dt_id = TEGRA30_CLK_AUDIO1_2X, .present = true },
+	[tegra_clk_audio2_2x] = { .dt_id = TEGRA30_CLK_AUDIO2_2X, .present = true },
+	[tegra_clk_audio3_2x] = { .dt_id = TEGRA30_CLK_AUDIO3_2X, .present = true },
+	[tegra_clk_audio4_2x] = { .dt_id = TEGRA30_CLK_AUDIO4_2X, .present = true },
+	[tegra_clk_spdif_2x] = { .dt_id = TEGRA30_CLK_SPDIF_2X, .present = true },
+	[tegra_clk_clk_out_1] = { .dt_id = TEGRA30_CLK_CLK_OUT_1, .present = true },
+	[tegra_clk_clk_out_2] = { .dt_id = TEGRA30_CLK_CLK_OUT_2, .present = true },
+	[tegra_clk_clk_out_3] = { .dt_id = TEGRA30_CLK_CLK_OUT_3, .present = true },
+	[tegra_clk_blink] = { .dt_id = TEGRA30_CLK_BLINK, .present = true },
+	[tegra_clk_clk_out_1_mux] = { .dt_id = TEGRA30_CLK_CLK_OUT_1_MUX, .present = true },
+	[tegra_clk_clk_out_2_mux] = { .dt_id = TEGRA30_CLK_CLK_OUT_2_MUX, .present = true },
+	[tegra_clk_clk_out_3_mux] = { .dt_id = TEGRA30_CLK_CLK_OUT_3_MUX, .present = true },
+	[tegra_clk_hclk] = { .dt_id = TEGRA30_CLK_HCLK, .present = true },
+	[tegra_clk_pclk] = { .dt_id = TEGRA30_CLK_PCLK, .present = true },
+	[tegra_clk_i2s0] = { .dt_id = TEGRA30_CLK_I2S0, .present = true },
+	[tegra_clk_i2s1] = { .dt_id = TEGRA30_CLK_I2S1, .present = true },
+	[tegra_clk_i2s2] = { .dt_id = TEGRA30_CLK_I2S2, .present = true },
+	[tegra_clk_i2s3] = { .dt_id = TEGRA30_CLK_I2S3, .present = true },
+	[tegra_clk_i2s4] = { .dt_id = TEGRA30_CLK_I2S4, .present = true },
+	[tegra_clk_spdif_in] = { .dt_id = TEGRA30_CLK_SPDIF_IN, .present = true },
+	[tegra_clk_hda] = { .dt_id = TEGRA30_CLK_HDA, .present = true },
+	[tegra_clk_hda2codec_2x] = { .dt_id = TEGRA30_CLK_HDA2CODEC_2X, .present = true },
+	[tegra_clk_sbc1] = { .dt_id = TEGRA30_CLK_SBC1, .present = true },
+	[tegra_clk_sbc2] = { .dt_id = TEGRA30_CLK_SBC2, .present = true },
+	[tegra_clk_sbc3] = { .dt_id = TEGRA30_CLK_SBC3, .present = true },
+	[tegra_clk_sbc4] = { .dt_id = TEGRA30_CLK_SBC4, .present = true },
+	[tegra_clk_sbc5] = { .dt_id = TEGRA30_CLK_SBC5, .present = true },
+	[tegra_clk_sbc6] = { .dt_id = TEGRA30_CLK_SBC6, .present = true },
+	[tegra_clk_ndflash] = { .dt_id = TEGRA30_CLK_NDFLASH, .present = true },
+	[tegra_clk_ndspeed] = { .dt_id = TEGRA30_CLK_NDSPEED, .present = true },
+	[tegra_clk_vfir] = { .dt_id = TEGRA30_CLK_VFIR, .present = true },
+	[tegra_clk_la] = { .dt_id = TEGRA30_CLK_LA, .present = true },
+	[tegra_clk_csite] = { .dt_id = TEGRA30_CLK_CSITE, .present = true },
+	[tegra_clk_owr] = { .dt_id = TEGRA30_CLK_OWR, .present = true },
+	[tegra_clk_mipi] = { .dt_id = TEGRA30_CLK_MIPI, .present = true },
+	[tegra_clk_tsensor] = { .dt_id = TEGRA30_CLK_TSENSOR, .present = true },
+	[tegra_clk_i2cslow] = { .dt_id = TEGRA30_CLK_I2CSLOW, .present = true },
+	[tegra_clk_vde] = { .dt_id = TEGRA30_CLK_VDE, .present = true },
+	[tegra_clk_vi] = { .dt_id = TEGRA30_CLK_VI, .present = true },
+	[tegra_clk_epp] = { .dt_id = TEGRA30_CLK_EPP, .present = true },
+	[tegra_clk_mpe] = { .dt_id = TEGRA30_CLK_MPE, .present = true },
+	[tegra_clk_host1x] = { .dt_id = TEGRA30_CLK_HOST1X, .present = true },
+	[tegra_clk_gr2d] = { .dt_id = TEGRA30_CLK_GR2D, .present = true },
+	[tegra_clk_gr3d] = { .dt_id = TEGRA30_CLK_GR3D, .present = true },
+	[tegra_clk_mselect] = { .dt_id = TEGRA30_CLK_MSELECT, .present = true },
+	[tegra_clk_nor] = { .dt_id = TEGRA30_CLK_NOR, .present = true },
+	[tegra_clk_sdmmc1] = { .dt_id = TEGRA30_CLK_SDMMC1, .present = true },
+	[tegra_clk_sdmmc2] = { .dt_id = TEGRA30_CLK_SDMMC2, .present = true },
+	[tegra_clk_sdmmc3] = { .dt_id = TEGRA30_CLK_SDMMC3, .present = true },
+	[tegra_clk_sdmmc4] = { .dt_id = TEGRA30_CLK_SDMMC4, .present = true },
+	[tegra_clk_cve] = { .dt_id = TEGRA30_CLK_CVE, .present = true },
+	[tegra_clk_tvo] = { .dt_id = TEGRA30_CLK_TVO, .present = true },
+	[tegra_clk_tvdac] = { .dt_id = TEGRA30_CLK_TVDAC, .present = true },
+	[tegra_clk_actmon] = { .dt_id = TEGRA30_CLK_ACTMON, .present = true },
+	[tegra_clk_vi_sensor] = { .dt_id = TEGRA30_CLK_VI_SENSOR, .present = true },
+	[tegra_clk_i2c1] = { .dt_id = TEGRA30_CLK_I2C1, .present = true },
+	[tegra_clk_i2c2] = { .dt_id = TEGRA30_CLK_I2C2, .present = true },
+	[tegra_clk_i2c3] = { .dt_id = TEGRA30_CLK_I2C3, .present = true },
+	[tegra_clk_i2c4] = { .dt_id = TEGRA30_CLK_I2C4, .present = true },
+	[tegra_clk_i2c5] = { .dt_id = TEGRA30_CLK_I2C5, .present = true },
+	[tegra_clk_uarta] = { .dt_id = TEGRA30_CLK_UARTA, .present = true },
+	[tegra_clk_uartb] = { .dt_id = TEGRA30_CLK_UARTB, .present = true },
+	[tegra_clk_uartc] = { .dt_id = TEGRA30_CLK_UARTC, .present = true },
+	[tegra_clk_uartd] = { .dt_id = TEGRA30_CLK_UARTD, .present = true },
+	[tegra_clk_uarte] = { .dt_id = TEGRA30_CLK_UARTE, .present = true },
+	[tegra_clk_extern1] = { .dt_id = TEGRA30_CLK_EXTERN1, .present = true },
+	[tegra_clk_extern2] = { .dt_id = TEGRA30_CLK_EXTERN2, .present = true },
+	[tegra_clk_extern3] = { .dt_id = TEGRA30_CLK_EXTERN3, .present = true },
+	[tegra_clk_pwm] = { .dt_id = TEGRA30_CLK_PWM, .present = true },
+	[tegra_clk_disp1] = { .dt_id = TEGRA30_CLK_DISP1, .present = true },
+	[tegra_clk_disp2] = { .dt_id = TEGRA30_CLK_DISP2, .present = true },
+	[tegra_clk_apbdma] = { .dt_id = TEGRA30_CLK_APBDMA, .present = true },
+	[tegra_clk_rtc] = { .dt_id = TEGRA30_CLK_RTC, .present = true },
+	[tegra_clk_timer] = { .dt_id = TEGRA30_CLK_TIMER, .present = true },
+	[tegra_clk_kbc] = { .dt_id = TEGRA30_CLK_KBC, .present = true },
+	[tegra_clk_csus] = { .dt_id = TEGRA30_CLK_CSUS, .present = true },
+	[tegra_clk_vcp] = { .dt_id = TEGRA30_CLK_VCP, .present = true },
+	[tegra_clk_bsea] = { .dt_id = TEGRA30_CLK_BSEA, .present = true },
+	[tegra_clk_bsev] = { .dt_id = TEGRA30_CLK_BSEV, .present = true },
+	[tegra_clk_usbd] = { .dt_id = TEGRA30_CLK_USBD, .present = true },
+	[tegra_clk_usb2] = { .dt_id = TEGRA30_CLK_USB2, .present = true },
+	[tegra_clk_usb3] = { .dt_id = TEGRA30_CLK_USB3, .present = true },
+	[tegra_clk_csi] = { .dt_id = TEGRA30_CLK_CSI, .present = true },
+	[tegra_clk_isp] = { .dt_id = TEGRA30_CLK_ISP, .present = true },
+	[tegra_clk_kfuse] = { .dt_id = TEGRA30_CLK_KFUSE, .present = true },
+	[tegra_clk_fuse] = { .dt_id = TEGRA30_CLK_FUSE, .present = true },
+	[tegra_clk_fuse_burn] = { .dt_id = TEGRA30_CLK_FUSE_BURN, .present = true },
+	[tegra_clk_apbif] = { .dt_id = TEGRA30_CLK_APBIF, .present = true },
+	[tegra_clk_hda2hdmi] = { .dt_id = TEGRA30_CLK_HDA2HDMI, .present = true },
+	[tegra_clk_sata_cold] = { .dt_id = TEGRA30_CLK_SATA_COLD, .present = true },
+	[tegra_clk_sata_oob] = { .dt_id = TEGRA30_CLK_SATA_OOB, .present = true },
+	[tegra_clk_sata] = { .dt_id = TEGRA30_CLK_SATA, .present = true },
+	[tegra_clk_dtv] = { .dt_id = TEGRA30_CLK_DTV, .present = true },
+	[tegra_clk_pll_p] = { .dt_id = TEGRA30_CLK_PLL_P, .present = true },
+	[tegra_clk_pll_p_out1] = { .dt_id = TEGRA30_CLK_PLL_P_OUT1, .present = true },
+	[tegra_clk_pll_p_out2] = { .dt_id = TEGRA30_CLK_PLL_P_OUT2, .present = true },
+	[tegra_clk_pll_p_out3] = { .dt_id = TEGRA30_CLK_PLL_P_OUT3, .present = true },
+	[tegra_clk_pll_p_out4] = { .dt_id = TEGRA30_CLK_PLL_P_OUT4, .present = true },
+	[tegra_clk_pll_a] = { .dt_id = TEGRA30_CLK_PLL_A, .present = true },
+	[tegra_clk_pll_a_out0] = { .dt_id = TEGRA30_CLK_PLL_A_OUT0, .present = true },
 
-static unsigned int tegra30_get_pll_ref_div(void)
-{
-	u32 pll_ref_div = readl_relaxed(clk_base + OSC_CTRL) &
-					OSC_CTRL_PLL_REF_DIV_MASK;
-
-	switch (pll_ref_div) {
-	case OSC_CTRL_PLL_REF_DIV_1:
-		return 1;
-	case OSC_CTRL_PLL_REF_DIV_2:
-		return 2;
-	case OSC_CTRL_PLL_REF_DIV_4:
-		return 4;
-	default:
-		pr_err("Invalid pll ref divider %d", pll_ref_div);
-		BUG();
-	}
-	return 0;
-}
+};
 
 static void tegra30_utmi_param_configure(void)
 {
@@ -940,55 +942,6 @@ static void __init tegra30_pll_init(void)
 				0, NULL);
 	clks[TEGRA30_CLK_PLL_C_OUT1] = clk;
 
-	/* PLLP */
-	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, pmc_base, 0,
-				&pll_p_params, NULL);
-	clks[TEGRA30_CLK_PLL_P] = clk;
-
-	/* PLLP_OUT1 */
-	clk = tegra_clk_register_divider("pll_p_out1_div", "pll_p",
-				clk_base + PLLP_OUTA, 0, TEGRA_DIVIDER_FIXED |
-				TEGRA_DIVIDER_ROUND_UP, 8, 8, 1,
-				&pll_div_lock);
-	clk = tegra_clk_register_pll_out("pll_p_out1", "pll_p_out1_div",
-				clk_base + PLLP_OUTA, 1, 0,
-				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
-				&pll_div_lock);
-	clks[TEGRA30_CLK_PLL_P_OUT1] = clk;
-
-	/* PLLP_OUT2 */
-	clk = tegra_clk_register_divider("pll_p_out2_div", "pll_p",
-				clk_base + PLLP_OUTA, 0, TEGRA_DIVIDER_FIXED |
-				TEGRA_DIVIDER_ROUND_UP, 24, 8, 1,
-				&pll_div_lock);
-	clk = tegra_clk_register_pll_out("pll_p_out2", "pll_p_out2_div",
-				clk_base + PLLP_OUTA, 17, 16,
-				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
-				&pll_div_lock);
-	clks[TEGRA30_CLK_PLL_P_OUT2] = clk;
-
-	/* PLLP_OUT3 */
-	clk = tegra_clk_register_divider("pll_p_out3_div", "pll_p",
-				clk_base + PLLP_OUTB, 0, TEGRA_DIVIDER_FIXED |
-				TEGRA_DIVIDER_ROUND_UP, 8, 8, 1,
-				&pll_div_lock);
-	clk = tegra_clk_register_pll_out("pll_p_out3", "pll_p_out3_div",
-				clk_base + PLLP_OUTB, 1, 0,
-				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
-				&pll_div_lock);
-	clks[TEGRA30_CLK_PLL_P_OUT3] = clk;
-
-	/* PLLP_OUT4 */
-	clk = tegra_clk_register_divider("pll_p_out4_div", "pll_p",
-				clk_base + PLLP_OUTB, 0, TEGRA_DIVIDER_FIXED |
-				TEGRA_DIVIDER_ROUND_UP, 24, 8, 1,
-				&pll_div_lock);
-	clk = tegra_clk_register_pll_out("pll_p_out4", "pll_p_out4_div",
-				clk_base + PLLP_OUTB, 17, 16,
-				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
-				&pll_div_lock);
-	clks[TEGRA30_CLK_PLL_P_OUT4] = clk;
-
 	/* PLLM */
 	clk = tegra_clk_register_pll("pll_m", "pll_ref", clk_base, pmc_base,
 			    CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE,
@@ -1041,20 +994,6 @@ static void __init tegra30_pll_init(void)
 					CLK_SET_RATE_PARENT, 1, 2);
 	clks[TEGRA30_CLK_PLL_D2_OUT0] = clk;
 
-	/* PLLA */
-	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, pmc_base,
-			    0, &pll_a_params, NULL);
-	clks[TEGRA30_CLK_PLL_A] = clk;
-
-	/* PLLA_OUT0 */
-	clk = tegra_clk_register_divider("pll_a_out0_div", "pll_a",
-				clk_base + PLLA_OUT, 0, TEGRA_DIVIDER_ROUND_UP,
-				8, 8, 1, NULL);
-	clk = tegra_clk_register_pll_out("pll_a_out0", "pll_a_out0_div",
-				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
-				CLK_SET_RATE_PARENT, 0, NULL);
-	clks[TEGRA30_CLK_PLL_A_OUT0] = clk;
-
 	/* PLLE */
 	clk = clk_register_mux(NULL, "pll_e_mux", pll_e_parents,
 			       ARRAY_SIZE(pll_e_parents),
@@ -1065,231 +1004,6 @@ static void __init tegra30_pll_init(void)
 	clks[TEGRA30_CLK_PLL_E] = clk;
 }
 
-static const char *mux_audio_sync_clk[] = { "spdif_in_sync", "i2s0_sync",
-	"i2s1_sync", "i2s2_sync", "i2s3_sync", "i2s4_sync", "vimclk_sync",};
-static const char *clk_out1_parents[] = { "clk_m", "clk_m_div2",
-					  "clk_m_div4", "extern1", };
-static const char *clk_out2_parents[] = { "clk_m", "clk_m_div2",
-					  "clk_m_div4", "extern2", };
-static const char *clk_out3_parents[] = { "clk_m", "clk_m_div2",
-					  "clk_m_div4", "extern3", };
-
-static void __init tegra30_audio_clk_init(void)
-{
-	struct clk *clk;
-
-	/* spdif_in_sync */
-	clk = tegra_clk_register_sync_source("spdif_in_sync", 24000000,
-					     24000000);
-	clks[TEGRA30_CLK_SPDIF_IN_SYNC] = clk;
-
-	/* i2s0_sync */
-	clk = tegra_clk_register_sync_source("i2s0_sync", 24000000, 24000000);
-	clks[TEGRA30_CLK_I2S0_SYNC] = clk;
-
-	/* i2s1_sync */
-	clk = tegra_clk_register_sync_source("i2s1_sync", 24000000, 24000000);
-	clks[TEGRA30_CLK_I2S1_SYNC] = clk;
-
-	/* i2s2_sync */
-	clk = tegra_clk_register_sync_source("i2s2_sync", 24000000, 24000000);
-	clks[TEGRA30_CLK_I2S2_SYNC] = clk;
-
-	/* i2s3_sync */
-	clk = tegra_clk_register_sync_source("i2s3_sync", 24000000, 24000000);
-	clks[TEGRA30_CLK_I2S3_SYNC] = clk;
-
-	/* i2s4_sync */
-	clk = tegra_clk_register_sync_source("i2s4_sync", 24000000, 24000000);
-	clks[TEGRA30_CLK_I2S4_SYNC] = clk;
-
-	/* vimclk_sync */
-	clk = tegra_clk_register_sync_source("vimclk_sync", 24000000, 24000000);
-	clks[TEGRA30_CLK_VIMCLK_SYNC] = clk;
-
-	/* audio0 */
-	clk = clk_register_mux(NULL, "audio0_mux", mux_audio_sync_clk,
-				ARRAY_SIZE(mux_audio_sync_clk),
-				CLK_SET_RATE_NO_REPARENT,
-				clk_base + AUDIO_SYNC_CLK_I2S0, 0, 3, 0, NULL);
-	clk = clk_register_gate(NULL, "audio0", "audio0_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S0, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clks[TEGRA30_CLK_AUDIO0] = clk;
-
-	/* audio1 */
-	clk = clk_register_mux(NULL, "audio1_mux", mux_audio_sync_clk,
-				ARRAY_SIZE(mux_audio_sync_clk),
-				CLK_SET_RATE_NO_REPARENT,
-				clk_base + AUDIO_SYNC_CLK_I2S1, 0, 3, 0, NULL);
-	clk = clk_register_gate(NULL, "audio1", "audio1_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S1, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clks[TEGRA30_CLK_AUDIO1] = clk;
-
-	/* audio2 */
-	clk = clk_register_mux(NULL, "audio2_mux", mux_audio_sync_clk,
-				ARRAY_SIZE(mux_audio_sync_clk),
-				CLK_SET_RATE_NO_REPARENT,
-				clk_base + AUDIO_SYNC_CLK_I2S2, 0, 3, 0, NULL);
-	clk = clk_register_gate(NULL, "audio2", "audio2_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S2, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clks[TEGRA30_CLK_AUDIO2] = clk;
-
-	/* audio3 */
-	clk = clk_register_mux(NULL, "audio3_mux", mux_audio_sync_clk,
-				ARRAY_SIZE(mux_audio_sync_clk),
-				CLK_SET_RATE_NO_REPARENT,
-				clk_base + AUDIO_SYNC_CLK_I2S3, 0, 3, 0, NULL);
-	clk = clk_register_gate(NULL, "audio3", "audio3_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S3, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clks[TEGRA30_CLK_AUDIO3] = clk;
-
-	/* audio4 */
-	clk = clk_register_mux(NULL, "audio4_mux", mux_audio_sync_clk,
-				ARRAY_SIZE(mux_audio_sync_clk),
-				CLK_SET_RATE_NO_REPARENT,
-				clk_base + AUDIO_SYNC_CLK_I2S4, 0, 3, 0, NULL);
-	clk = clk_register_gate(NULL, "audio4", "audio4_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S4, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clks[TEGRA30_CLK_AUDIO4] = clk;
-
-	/* spdif */
-	clk = clk_register_mux(NULL, "spdif_mux", mux_audio_sync_clk,
-				ARRAY_SIZE(mux_audio_sync_clk),
-				CLK_SET_RATE_NO_REPARENT,
-				clk_base + AUDIO_SYNC_CLK_SPDIF, 0, 3, 0, NULL);
-	clk = clk_register_gate(NULL, "spdif", "spdif_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_SPDIF, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clks[TEGRA30_CLK_SPDIF] = clk;
-
-	/* audio0_2x */
-	clk = clk_register_fixed_factor(NULL, "audio0_doubler", "audio0",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio0_div", "audio0_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 24, 1, 0,
-				&clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio0_2x", "audio0_div",
-				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    CLK_SET_RATE_PARENT, 113,
-				    periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_AUDIO0_2X] = clk;
-
-	/* audio1_2x */
-	clk = clk_register_fixed_factor(NULL, "audio1_doubler", "audio1",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio1_div", "audio1_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 25, 1, 0,
-				&clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio1_2x", "audio1_div",
-				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    CLK_SET_RATE_PARENT, 114,
-				    periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_AUDIO1_2X] = clk;
-
-	/* audio2_2x */
-	clk = clk_register_fixed_factor(NULL, "audio2_doubler", "audio2",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio2_div", "audio2_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 26, 1, 0,
-				&clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio2_2x", "audio2_div",
-				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    CLK_SET_RATE_PARENT, 115,
-				    periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_AUDIO2_2X] = clk;
-
-	/* audio3_2x */
-	clk = clk_register_fixed_factor(NULL, "audio3_doubler", "audio3",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio3_div", "audio3_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 27, 1, 0,
-				&clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio3_2x", "audio3_div",
-				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    CLK_SET_RATE_PARENT, 116,
-				    periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_AUDIO3_2X] = clk;
-
-	/* audio4_2x */
-	clk = clk_register_fixed_factor(NULL, "audio4_doubler", "audio4",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio4_div", "audio4_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 28, 1, 0,
-				&clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("audio4_2x", "audio4_div",
-				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    CLK_SET_RATE_PARENT, 117,
-				    periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_AUDIO4_2X] = clk;
-
-	/* spdif_2x */
-	clk = clk_register_fixed_factor(NULL, "spdif_doubler", "spdif",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("spdif_div", "spdif_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 29, 1, 0,
-				&clk_doubler_lock);
-	clk = tegra_clk_register_periph_gate("spdif_2x", "spdif_div",
-				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    CLK_SET_RATE_PARENT, 118,
-				    periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_SPDIF_2X] = clk;
-}
-
-static void __init tegra30_pmc_clk_init(void)
-{
-	struct clk *clk;
-
-	/* clk_out_1 */
-	clk = clk_register_mux(NULL, "clk_out_1_mux", clk_out1_parents,
-			       ARRAY_SIZE(clk_out1_parents),
-			       CLK_SET_RATE_NO_REPARENT,
-			       pmc_base + PMC_CLK_OUT_CNTRL, 6, 3, 0,
-			       &clk_out_lock);
-	clks[TEGRA30_CLK_CLK_OUT_1_MUX] = clk;
-	clk = clk_register_gate(NULL, "clk_out_1", "clk_out_1_mux", 0,
-				pmc_base + PMC_CLK_OUT_CNTRL, 2, 0,
-				&clk_out_lock);
-	clks[TEGRA30_CLK_CLK_OUT_1] = clk;
-
-	/* clk_out_2 */
-	clk = clk_register_mux(NULL, "clk_out_2_mux", clk_out2_parents,
-			       ARRAY_SIZE(clk_out2_parents),
-			       CLK_SET_RATE_NO_REPARENT,
-			       pmc_base + PMC_CLK_OUT_CNTRL, 14, 3, 0,
-			       &clk_out_lock);
-	clk = clk_register_gate(NULL, "clk_out_2", "clk_out_2_mux", 0,
-				pmc_base + PMC_CLK_OUT_CNTRL, 10, 0,
-				&clk_out_lock);
-	clks[TEGRA30_CLK_CLK_OUT_2] = clk;
-
-	/* clk_out_3 */
-	clk = clk_register_mux(NULL, "clk_out_3_mux", clk_out3_parents,
-			       ARRAY_SIZE(clk_out3_parents),
-			       CLK_SET_RATE_NO_REPARENT,
-			       pmc_base + PMC_CLK_OUT_CNTRL, 22, 3, 0,
-			       &clk_out_lock);
-	clk = clk_register_gate(NULL, "clk_out_3", "clk_out_3_mux", 0,
-				pmc_base + PMC_CLK_OUT_CNTRL, 18, 0,
-				&clk_out_lock);
-	clks[TEGRA30_CLK_CLK_OUT_3] = clk;
-
-	/* blink */
-	writel_relaxed(0, pmc_base + PMC_BLINK_TIMER);
-	clk = clk_register_gate(NULL, "blink_override", "clk_32k", 0,
-				pmc_base + PMC_DPD_PADS_ORIDE,
-				PMC_DPD_PADS_ORIDE_BLINK_ENB, 0, NULL);
-	clk = clk_register_gate(NULL, "blink", "blink_override", 0,
-				pmc_base + PMC_CTRL,
-				PMC_CTRL_BLINK_ENB, 0, NULL);
-	clks[TEGRA30_CLK_BLINK] = clk;
-
-}
-
 static const char *cclk_g_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
 					"pll_p_cclkg", "pll_p_out4_cclkg",
 					"pll_p_out3_cclkg", "unused", "pll_x" };
@@ -1384,135 +1098,39 @@ static void __init tegra30_super_clk_init(void)
 				  0, 4, 0, 0, NULL);
 	clks[TEGRA30_CLK_SCLK] = clk;
 
-	/* HCLK */
-	clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
-				   clk_base + SYSTEM_CLK_RATE, 4, 2, 0,
-				   &sysrate_lock);
-	clk = clk_register_gate(NULL, "hclk", "hclk_div", CLK_SET_RATE_PARENT,
-				clk_base + SYSTEM_CLK_RATE, 7,
-				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clks[TEGRA30_CLK_HCLK] = clk;
-
-	/* PCLK */
-	clk = clk_register_divider(NULL, "pclk_div", "hclk", 0,
-				   clk_base + SYSTEM_CLK_RATE, 0, 2, 0,
-				   &sysrate_lock);
-	clk = clk_register_gate(NULL, "pclk", "pclk_div", CLK_SET_RATE_PARENT,
-				clk_base + SYSTEM_CLK_RATE, 3,
-				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clks[TEGRA30_CLK_PCLK] = clk;
-
 	/* twd */
 	clk = clk_register_fixed_factor(NULL, "twd", "cclk_g",
 					CLK_SET_RATE_PARENT, 1, 2);
 	clks[TEGRA30_CLK_TWD] = clk;
+
+	tegra_super_clk_gen4_init(clk_base, pmc_base, tegra30_clks, NULL);
 }
 
 static const char *mux_pllacp_clkm[] = { "pll_a_out0", "unused", "pll_p",
 					 "clk_m" };
 static const char *mux_pllpcm_clkm[] = { "pll_p", "pll_c", "pll_m", "clk_m" };
 static const char *mux_pllmcp_clkm[] = { "pll_m", "pll_c", "pll_p", "clk_m" };
-static const char *i2s0_parents[] = { "pll_a_out0", "audio0_2x", "pll_p",
-				      "clk_m" };
-static const char *i2s1_parents[] = { "pll_a_out0", "audio1_2x", "pll_p",
-				      "clk_m" };
-static const char *i2s2_parents[] = { "pll_a_out0", "audio2_2x", "pll_p",
-				      "clk_m" };
-static const char *i2s3_parents[] = { "pll_a_out0", "audio3_2x", "pll_p",
-				      "clk_m" };
-static const char *i2s4_parents[] = { "pll_a_out0", "audio4_2x", "pll_p",
-				      "clk_m" };
 static const char *spdif_out_parents[] = { "pll_a_out0", "spdif_2x", "pll_p",
 					   "clk_m" };
-static const char *spdif_in_parents[] = { "pll_p", "pll_c", "pll_m" };
-static const char *mux_pllpc_clk32k_clkm[] = { "pll_p", "pll_c", "clk_32k",
-					       "clk_m" };
-static const char *mux_pllpc_clkm_clk32k[] = { "pll_p", "pll_c", "clk_m",
-					       "clk_32k" };
 static const char *mux_pllmcpa[] = { "pll_m", "pll_c", "pll_p", "pll_a_out0" };
-static const char *mux_pllpdc_clkm[] = { "pll_p", "pll_d_out0", "pll_c",
-					 "clk_m" };
-static const char *mux_pllp_clkm[] = { "pll_p", "unused", "unused", "clk_m" };
 static const char *mux_pllpmdacd2_clkm[] = { "pll_p", "pll_m", "pll_d_out0",
 					     "pll_a_out0", "pll_c",
 					     "pll_d2_out0", "clk_m" };
-static const char *mux_plla_clk32k_pllp_clkm_plle[] = { "pll_a_out0",
-							"clk_32k", "pll_p",
-							"clk_m", "pll_e" };
 static const char *mux_plld_out0_plld2_out0[] = { "pll_d_out0",
 						  "pll_d2_out0" };
 
 static struct tegra_periph_init_data tegra_periph_clk_list[] = {
-	TEGRA_INIT_DATA_MUX("i2s0", i2s0_parents, CLK_SOURCE_I2S0, 30, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S0),
-	TEGRA_INIT_DATA_MUX("i2s1", i2s1_parents, CLK_SOURCE_I2S1, 11, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S1),
-	TEGRA_INIT_DATA_MUX("i2s2", i2s2_parents, CLK_SOURCE_I2S2, 18, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S2),
-	TEGRA_INIT_DATA_MUX("i2s3", i2s3_parents, CLK_SOURCE_I2S3, 101, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S3),
-	TEGRA_INIT_DATA_MUX("i2s4", i2s4_parents, CLK_SOURCE_I2S4, 102, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S4),
 	TEGRA_INIT_DATA_MUX("spdif_out", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SPDIF_OUT),
-	TEGRA_INIT_DATA_MUX("spdif_in", spdif_in_parents, CLK_SOURCE_SPDIF_IN, 10, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SPDIF_IN),
 	TEGRA_INIT_DATA_MUX("d_audio", mux_pllacp_clkm, CLK_SOURCE_D_AUDIO, 106, 0, TEGRA30_CLK_D_AUDIO),
 	TEGRA_INIT_DATA_MUX("dam0", mux_pllacp_clkm, CLK_SOURCE_DAM0, 108, 0, TEGRA30_CLK_DAM0),
 	TEGRA_INIT_DATA_MUX("dam1", mux_pllacp_clkm, CLK_SOURCE_DAM1, 109, 0, TEGRA30_CLK_DAM1),
 	TEGRA_INIT_DATA_MUX("dam2", mux_pllacp_clkm, CLK_SOURCE_DAM2, 110, 0, TEGRA30_CLK_DAM2),
-	TEGRA_INIT_DATA_MUX("hda", mux_pllpcm_clkm, CLK_SOURCE_HDA, 125, 0, TEGRA30_CLK_HDA),
-	TEGRA_INIT_DATA_MUX("hda2codec_2x", mux_pllpcm_clkm, CLK_SOURCE_HDA2CODEC_2X, 111, 0, TEGRA30_CLK_HDA2CODEC_2X),
-	TEGRA_INIT_DATA_MUX("sbc1", mux_pllpcm_clkm, CLK_SOURCE_SBC1, 41, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC1),
-	TEGRA_INIT_DATA_MUX("sbc2", mux_pllpcm_clkm, CLK_SOURCE_SBC2, 44, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC2),
-	TEGRA_INIT_DATA_MUX("sbc3", mux_pllpcm_clkm, CLK_SOURCE_SBC3, 46, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC3),
-	TEGRA_INIT_DATA_MUX("sbc4", mux_pllpcm_clkm, CLK_SOURCE_SBC4, 68, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC4),
-	TEGRA_INIT_DATA_MUX("sbc5", mux_pllpcm_clkm, CLK_SOURCE_SBC5, 104, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC5),
-	TEGRA_INIT_DATA_MUX("sbc6", mux_pllpcm_clkm, CLK_SOURCE_SBC6, 105, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC6),
-	TEGRA_INIT_DATA_MUX("sata_oob", mux_pllpcm_clkm, CLK_SOURCE_SATA_OOB, 123, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SATA_OOB),
-	TEGRA_INIT_DATA_MUX("sata", mux_pllpcm_clkm, CLK_SOURCE_SATA, 124, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SATA),
-	TEGRA_INIT_DATA_MUX("ndflash", mux_pllpcm_clkm, CLK_SOURCE_NDFLASH, 13, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_NDFLASH),
-	TEGRA_INIT_DATA_MUX("ndspeed", mux_pllpcm_clkm, CLK_SOURCE_NDSPEED, 80, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_NDSPEED),
-	TEGRA_INIT_DATA_MUX("vfir", mux_pllpcm_clkm, CLK_SOURCE_VFIR, 7, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_VFIR),
-	TEGRA_INIT_DATA_MUX("csite", mux_pllpcm_clkm, CLK_SOURCE_CSITE, 73, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_CSITE),
-	TEGRA_INIT_DATA_MUX("la", mux_pllpcm_clkm, CLK_SOURCE_LA, 76, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_LA),
-	TEGRA_INIT_DATA_MUX("owr", mux_pllpcm_clkm, CLK_SOURCE_OWR, 71, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_OWR),
-	TEGRA_INIT_DATA_MUX("mipi", mux_pllpcm_clkm, CLK_SOURCE_MIPI, 50, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_MIPI),
-	TEGRA_INIT_DATA_MUX("tsensor", mux_pllpc_clkm_clk32k, CLK_SOURCE_TSENSOR, 100, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_TSENSOR),
-	TEGRA_INIT_DATA_MUX("i2cslow", mux_pllpc_clk32k_clkm, CLK_SOURCE_I2CSLOW, 81, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2CSLOW),
-	TEGRA_INIT_DATA_INT("vde", mux_pllpcm_clkm, CLK_SOURCE_VDE, 61, 0, TEGRA30_CLK_VDE),
-	TEGRA_INIT_DATA_INT("vi", mux_pllmcpa, CLK_SOURCE_VI, 20, 0, TEGRA30_CLK_VI),
-	TEGRA_INIT_DATA_INT("epp", mux_pllmcpa, CLK_SOURCE_EPP, 19, 0, TEGRA30_CLK_EPP),
-	TEGRA_INIT_DATA_INT("mpe", mux_pllmcpa, CLK_SOURCE_MPE, 60, 0, TEGRA30_CLK_MPE),
-	TEGRA_INIT_DATA_INT("host1x", mux_pllmcpa, CLK_SOURCE_HOST1X, 28, 0, TEGRA30_CLK_HOST1X),
-	TEGRA_INIT_DATA_INT("3d", mux_pllmcpa, CLK_SOURCE_3D, 24, TEGRA_PERIPH_MANUAL_RESET, TEGRA30_CLK_GR3D),
 	TEGRA_INIT_DATA_INT("3d2", mux_pllmcpa, CLK_SOURCE_3D2, 98, TEGRA_PERIPH_MANUAL_RESET, TEGRA30_CLK_GR3D2),
-	TEGRA_INIT_DATA_INT("2d", mux_pllmcpa, CLK_SOURCE_2D, 21, 0, TEGRA30_CLK_GR2D),
 	TEGRA_INIT_DATA_INT("se", mux_pllpcm_clkm, CLK_SOURCE_SE, 127, 0, TEGRA30_CLK_SE),
-	TEGRA_INIT_DATA_MUX("mselect", mux_pllp_clkm, CLK_SOURCE_MSELECT, 99, 0, TEGRA30_CLK_MSELECT),
-	TEGRA_INIT_DATA_MUX("nor", mux_pllpcm_clkm, CLK_SOURCE_NOR, 42, 0, TEGRA30_CLK_NOR),
-	TEGRA_INIT_DATA_MUX("sdmmc1", mux_pllpcm_clkm, CLK_SOURCE_SDMMC1, 14, 0, TEGRA30_CLK_SDMMC1),
-	TEGRA_INIT_DATA_MUX("sdmmc2", mux_pllpcm_clkm, CLK_SOURCE_SDMMC2, 9, 0, TEGRA30_CLK_SDMMC2),
-	TEGRA_INIT_DATA_MUX("sdmmc3", mux_pllpcm_clkm, CLK_SOURCE_SDMMC3, 69, 0, TEGRA30_CLK_SDMMC3),
-	TEGRA_INIT_DATA_MUX("sdmmc4", mux_pllpcm_clkm, CLK_SOURCE_SDMMC4, 15, 0, TEGRA30_CLK_SDMMC4),
-	TEGRA_INIT_DATA_MUX("cve", mux_pllpdc_clkm, CLK_SOURCE_CVE, 49, 0, TEGRA30_CLK_CVE),
-	TEGRA_INIT_DATA_MUX("tvo", mux_pllpdc_clkm, CLK_SOURCE_TVO, 49, 0, TEGRA30_CLK_TVO),
-	TEGRA_INIT_DATA_MUX("tvdac", mux_pllpdc_clkm, CLK_SOURCE_TVDAC, 53, 0, TEGRA30_CLK_TVDAC),
-	TEGRA_INIT_DATA_MUX("actmon", mux_pllpc_clk32k_clkm, CLK_SOURCE_ACTMON, 119, 0, TEGRA30_CLK_ACTMON),
-	TEGRA_INIT_DATA_MUX("vi_sensor", mux_pllmcpa, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, TEGRA30_CLK_VI_SENSOR),
-	TEGRA_INIT_DATA_DIV16("i2c1", mux_pllp_clkm, CLK_SOURCE_I2C1, 12, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C1),
-	TEGRA_INIT_DATA_DIV16("i2c2", mux_pllp_clkm, CLK_SOURCE_I2C2, 54, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C2),
-	TEGRA_INIT_DATA_DIV16("i2c3", mux_pllp_clkm, CLK_SOURCE_I2C3, 67, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C3),
-	TEGRA_INIT_DATA_DIV16("i2c4", mux_pllp_clkm, CLK_SOURCE_I2C4, 103, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C4),
-	TEGRA_INIT_DATA_DIV16("i2c5", mux_pllp_clkm, CLK_SOURCE_I2C5, 47, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C5),
-	TEGRA_INIT_DATA_UART("uarta", mux_pllpcm_clkm, CLK_SOURCE_UARTA, 6, TEGRA30_CLK_UARTA),
-	TEGRA_INIT_DATA_UART("uartb", mux_pllpcm_clkm, CLK_SOURCE_UARTB, 7, TEGRA30_CLK_UARTB),
-	TEGRA_INIT_DATA_UART("uartc", mux_pllpcm_clkm, CLK_SOURCE_UARTC, 55, TEGRA30_CLK_UARTC),
-	TEGRA_INIT_DATA_UART("uartd", mux_pllpcm_clkm, CLK_SOURCE_UARTD, 65, TEGRA30_CLK_UARTD),
-	TEGRA_INIT_DATA_UART("uarte", mux_pllpcm_clkm, CLK_SOURCE_UARTE, 66, TEGRA30_CLK_UARTE),
 	TEGRA_INIT_DATA_MUX8("hdmi", mux_pllpmdacd2_clkm, CLK_SOURCE_HDMI, 51, 0, TEGRA30_CLK_HDMI),
-	TEGRA_INIT_DATA_MUX8("extern1", mux_plla_clk32k_pllp_clkm_plle, CLK_SOURCE_EXTERN1, 120, 0, TEGRA30_CLK_EXTERN1),
-	TEGRA_INIT_DATA_MUX8("extern2", mux_plla_clk32k_pllp_clkm_plle, CLK_SOURCE_EXTERN2, 121, 0, TEGRA30_CLK_EXTERN2),
-	TEGRA_INIT_DATA_MUX8("extern3", mux_plla_clk32k_pllp_clkm_plle, CLK_SOURCE_EXTERN3, 122, 0, TEGRA30_CLK_EXTERN3),
-	TEGRA_INIT_DATA("pwm", NULL, NULL, mux_pllpc_clk32k_clkm, CLK_SOURCE_PWM, 28, 2, 0, 0, 8, 1, 0, 17, 0, TEGRA30_CLK_PWM),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
-	TEGRA_INIT_DATA_NODIV("disp1", mux_pllpmdacd2_clkm, CLK_SOURCE_DISP1, 29, 3, 27, 0, TEGRA30_CLK_DISP1),
-	TEGRA_INIT_DATA_NODIV("disp2", mux_pllpmdacd2_clkm, CLK_SOURCE_DISP2, 29, 3, 26, 0, TEGRA30_CLK_DISP2),
 	TEGRA_INIT_DATA_NODIV("dsib", mux_plld_out0_plld2_out0, CLK_SOURCE_DSIB, 25, 1, 82, 0, TEGRA30_CLK_DSIB),
 };
 
@@ -1522,80 +1140,11 @@ static void __init tegra30_periph_clk_init(void)
 	struct clk *clk;
 	int i;
 
-	/* apbdma */
-	clk = tegra_clk_register_periph_gate("apbdma", "clk_m", 0, clk_base, 0, 34,
-				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra-apbdma");
-
-	/* rtc */
-	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
-				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 4, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "rtc-tegra");
-	clks[TEGRA30_CLK_RTC] = clk;
-
-	/* timer */
-	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base, 0,
-				    5, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_TIMER] = clk;
-
-	/* kbc */
-	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
-				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 36, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_KBC] = clk;
-
-	/* csus */
-	clk = tegra_clk_register_periph_gate("csus", "clk_m",
-				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 92, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_CSUS] = clk;
-
-	/* vcp */
-	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0, clk_base, 0, 29,
-				    periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_VCP] = clk;
-
-	/* bsea */
-	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0, clk_base, 0,
-				    62, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_BSEA] = clk;
-
-	/* bsev */
-	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0, clk_base, 0,
-				    63, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_BSEV] = clk;
-
-	/* usbd */
-	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base, 0,
-				    22, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_USBD] = clk;
-
-	/* usb2 */
-	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base, 0,
-				    58, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_USB2] = clk;
-
-	/* usb3 */
-	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base, 0,
-				    59, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_USB3] = clk;
-
 	/* dsia */
 	clk = tegra_clk_register_periph_gate("dsia", "pll_d_out0", 0, clk_base,
 				    0, 48, periph_clk_enb_refcnt);
 	clks[TEGRA30_CLK_DSIA] = clk;
 
-	/* csi */
-	clk = tegra_clk_register_periph_gate("csi", "pll_p_out3", 0, clk_base,
-				    0, 52, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_CSI] = clk;
-
-	/* isp */
-	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0, 23,
-				    periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_ISP] = clk;
-
 	/* pcie */
 	clk = tegra_clk_register_periph_gate("pcie", "clk_m", 0, clk_base, 0,
 				    70, periph_clk_enb_refcnt);
@@ -1611,47 +1160,6 @@ static void __init tegra30_periph_clk_init(void)
 				    74, periph_clk_enb_refcnt);
 	clks[TEGRA30_CLK_PCIEX] = clk;
 
-	/* kfuse */
-	clk = tegra_clk_register_periph_gate("kfuse", "clk_m",
-				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 40, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_KFUSE] = clk;
-
-	/* fuse */
-	clk = tegra_clk_register_periph_gate("fuse", "clk_m",
-				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 39, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_FUSE] = clk;
-
-	/* fuse_burn */
-	clk = tegra_clk_register_periph_gate("fuse_burn", "clk_m",
-				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 39, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_FUSE_BURN] = clk;
-
-	/* apbif */
-	clk = tegra_clk_register_periph_gate("apbif", "clk_m", 0,
-				    clk_base, 0, 107, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_APBIF] = clk;
-
-	/* hda2hdmi */
-	clk = tegra_clk_register_periph_gate("hda2hdmi", "clk_m",
-				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 128, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_HDA2HDMI] = clk;
-
-	/* sata_cold */
-	clk = tegra_clk_register_periph_gate("sata_cold", "clk_m",
-				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 129, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_SATA_COLD] = clk;
-
-	/* dtv */
-	clk = tegra_clk_register_periph_gate("dtv", "clk_m",
-				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 79, periph_clk_enb_refcnt);
-	clks[TEGRA30_CLK_DTV] = clk;
-
 	/* emc */
 	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
 			       ARRAY_SIZE(mux_pllmcp_clkm),
@@ -1662,6 +1170,16 @@ static void __init tegra30_periph_clk_init(void)
 				    57, periph_clk_enb_refcnt);
 	clks[TEGRA30_CLK_EMC] = clk;
 
+	/* cml0 */
+	clk = clk_register_gate(NULL, "cml0", "pll_e", 0, clk_base + PLLE_AUX,
+				0, 0, &cml_lock);
+	clks[TEGRA30_CLK_CML0] = clk;
+
+	/* cml1 */
+	clk = clk_register_gate(NULL, "cml1", "pll_e", 0, clk_base + PLLE_AUX,
+				1, 0, &cml_lock);
+	clks[TEGRA30_CLK_CML1] = clk;
+
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
 		data = &tegra_periph_clk_list[i];
 		clk = tegra_clk_register_periph(data->name, data->p.parent_names,
@@ -1678,55 +1196,8 @@ static void __init tegra30_periph_clk_init(void)
 					clk_base, data->offset);
 		clks[data->clk_id] = clk;
 	}
-}
 
-static void __init tegra30_fixed_clk_init(void)
-{
-	struct clk *clk;
-
-	/* clk_32k */
-	clk = clk_register_fixed_rate(NULL, "clk_32k", NULL, CLK_IS_ROOT,
-				32768);
-	clks[TEGRA30_CLK_CLK_32K] = clk;
-
-	/* clk_m_div2 */
-	clk = clk_register_fixed_factor(NULL, "clk_m_div2", "clk_m",
-				CLK_SET_RATE_PARENT, 1, 2);
-	clks[TEGRA30_CLK_CLK_M_DIV2] = clk;
-
-	/* clk_m_div4 */
-	clk = clk_register_fixed_factor(NULL, "clk_m_div4", "clk_m",
-				CLK_SET_RATE_PARENT, 1, 4);
-	clks[TEGRA30_CLK_CLK_M_DIV4] = clk;
-
-	/* cml0 */
-	clk = clk_register_gate(NULL, "cml0", "pll_e", 0, clk_base + PLLE_AUX,
-				0, 0, &cml_lock);
-	clks[TEGRA30_CLK_CML0] = clk;
-
-	/* cml1 */
-	clk = clk_register_gate(NULL, "cml1", "pll_e", 0, clk_base + PLLE_AUX,
-				1, 0, &cml_lock);
-	clks[TEGRA30_CLK_CML1] = clk;
-}
-
-static void __init tegra30_osc_clk_init(void)
-{
-	struct clk *clk;
-	unsigned int pll_ref_div;
-
-	tegra30_clk_measure_input_freq();
-
-	/* clk_m */
-	clk = clk_register_fixed_rate(NULL, "clk_m", NULL, CLK_IS_ROOT,
-				input_freq);
-	clks[TEGRA30_CLK_CLK_M] = clk;
-
-	/* pll_ref */
-	pll_ref_div = tegra30_get_pll_ref_div();
-	clk = clk_register_fixed_factor(NULL, "pll_ref", "clk_m",
-				CLK_SET_RATE_PARENT, 1, pll_ref_div);
-	clks[TEGRA30_CLK_PLL_REF] = clk;
+	tegra_periph_clk_init(clk_base, pmc_base, tegra30_clks, &pll_p_params);
 }
 
 /* Tegra30 CPU clock and reset control functions */
@@ -1966,13 +1437,17 @@ static void __init tegra30_clock_init(struct device_node *np)
 		return;
 	}
 
-	tegra30_osc_clk_init();
-	tegra30_fixed_clk_init();
+	if (tegra_osc_clk_init(clk_base, tegra30_clks, tegra30_input_freq,
+		ARRAY_SIZE(tegra30_input_freq), &input_freq, NULL) < 0)
+		return;
+
+
+	tegra_fixed_clk_init(tegra30_clks);
 	tegra30_pll_init();
 	tegra30_super_clk_init();
 	tegra30_periph_clk_init();
-	tegra30_audio_clk_init();
-	tegra30_pmc_clk_init();
+	tegra_audio_clk_init(clk_base, pmc_base, tegra30_clks, &pll_a_params);
+	tegra_pmc_clk_init(pmc_base, tegra30_clks);
 
 	tegra_init_dup_clks(tegra_clk_duplicates, clks, TEGRA30_CLK_CLK_MAX);
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

