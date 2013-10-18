Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3JRN0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:26:54 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12185 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab3JRN0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:26:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 18 Oct 2013 06:26:18 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 14/15] clk: tegra: move tegra30 to common infra
Date: Fri, 18 Oct 2013 16:25:18 +0300
Message-ID: <1382102719-5531-15-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move tegra30 to common tegra clock infrastructure.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra30.c | 1288 ++++++++++++---------------------------
 1 files changed, 403 insertions(+), 885 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index bffeb5c..880290f 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -23,8 +23,9 @@
 #include <linux/of_address.h>
 #include <linux/clk/tegra.h>
 #include <linux/tegra-powergate.h>
-
+#include <dt-bindings/clock/tegra30-car.h>
 #include "clk.h"
+#include "clk-id.h"
 
 #define OSC_CTRL			0x50
 #define OSC_CTRL_OSC_FREQ_MASK		(0xF<<28)
@@ -102,75 +103,16 @@
 
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
@@ -238,81 +180,36 @@ static void __iomem *clk_base;
 static void __iomem *pmc_base;
 static unsigned long input_freq;
 
-static DEFINE_SPINLOCK(clk_doubler_lock);
-static DEFINE_SPINLOCK(clk_out_lock);
-static DEFINE_SPINLOCK(pll_div_lock);
 static DEFINE_SPINLOCK(cml_lock);
 static DEFINE_SPINLOCK(pll_d_lock);
-static DEFINE_SPINLOCK(sysrate_lock);
 
-#define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
+#define TEGRA_INIT_DATA_MUX(_name, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
+	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, 0, _clk_num,		\
 			_gate_flags, _clk_id)
 
-#define TEGRA_INIT_DATA_DIV16(_name, _con_id, _dev_id, _parents, _offset, \
-			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
-			30, 2, 0, 0, 16, 0, TEGRA_DIVIDER_ROUND_UP,	\
-			_clk_num, \
-			_gate_flags, _clk_id)
-
-#define TEGRA_INIT_DATA_MUX8(_name, _con_id, _dev_id, _parents, _offset, \
+#define TEGRA_INIT_DATA_MUX8(_name, _parents, _offset, \
 			     _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
+	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
 			29, 3, 0, 0, 8, 1, 0, _clk_num,		\
 			_gate_flags, _clk_id)
 
-#define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
+#define TEGRA_INIT_DATA_INT(_name, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
+	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_INT,\
 			_clk_num, _gate_flags,	\
 			_clk_id)
 
-#define TEGRA_INIT_DATA_UART(_name, _con_id, _dev_id, _parents, _offset,\
-			     _clk_num, _clk_id)			\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
-			30, 2, 0, 0, 16, 1, TEGRA_DIVIDER_UART,\
-			_clk_num, 0, _clk_id)
-
-#define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
+#define TEGRA_INIT_DATA_NODIV(_name, _parents, _offset, \
 			      _mux_shift, _mux_width, _clk_num, \
 			      _gate_flags, _clk_id)			\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
+	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
 			_mux_shift, _mux_width, 0, 0, 0, 0, 0,\
 			_clk_num, _gate_flags,	\
 			_clk_id)
 
-/*
- * IDs assigned here must be in sync with DT bindings definition
- * for Tegra30 clocks.
- */
-enum tegra30_clk {
-	cpu, rtc = 4, timer, uarta, gpio = 8, sdmmc2, i2s1 = 11, i2c1, ndflash,
-	sdmmc1, sdmmc4, pwm = 17, i2s2, epp, gr2d = 21, usbd, isp, gr3d,
-	disp2 = 26, disp1, host1x, vcp, i2s0, cop_cache, mc, ahbdma, apbdma,
-	kbc = 36, statmon, pmc, kfuse = 40, sbc1, nor, sbc2 = 44, sbc3 = 46,
-	i2c5, dsia, mipi = 50, hdmi, csi, tvdac, i2c2, uartc, emc = 57, usb2,
-	usb3, mpe, vde, bsea, bsev, speedo, uartd, uarte, i2c3, sbc4, sdmmc3,
-	pcie, owr, afi, csite, pciex, avpucq, la, dtv = 79, ndspeed, i2cslow,
-	dsib, irama = 84, iramb, iramc, iramd, cram2, audio_2x = 90, csus = 92,
-	cdev2, cdev1, cpu_g = 96, cpu_lp, gr3d2, mselect, tsensor, i2s3, i2s4,
-	i2c4, sbc5, sbc6, d_audio, apbif, dam0, dam1, dam2, hda2codec_2x,
-	atomics, audio0_2x, audio1_2x, audio2_2x, audio3_2x, audio4_2x,
-	spdif_2x, actmon, extern1, extern2, extern3, sata_oob, sata, hda,
-	se = 127, hda2hdmi, sata_cold, uartb = 160, vfir, spdif_in, spdif_out,
-	vi, vi_sensor, fuse, fuse_burn, cve, tvo, clk_32k, clk_m, clk_m_div2,
-	clk_m_div4, pll_ref, pll_c, pll_c_out1, pll_m, pll_m_out1, pll_p,
-	pll_p_out1, pll_p_out2, pll_p_out3, pll_p_out4, pll_a, pll_a_out0,
-	pll_d, pll_d_out0, pll_d2, pll_d2_out0, pll_u, pll_x, pll_x_out0, pll_e,
-	spdif_in_sync, i2s0_sync, i2s1_sync, i2s2_sync, i2s3_sync, i2s4_sync,
-	vimclk_sync, audio0, audio1, audio2, audio3, audio4, spdif, clk_out_1,
-	clk_out_2, clk_out_3, sclk, blink, cclk_g, cclk_lp, twd, cml0, cml1,
-	hclk, pclk, clk_out_1_mux = 300, clk_max
-};
-
 static struct clk **clks;
 
 /*
@@ -684,67 +581,295 @@ static struct tegra_clk_pll_params pll_e_params = {
 	.fixed_rate = 100000000,
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
+static unsigned long tegra30_input_freq[] = {
+	[0] = 13000000,
+	[1] = 16800000,
+	[4] = 19200000,
+	[5] = 38400000,
+	[8] = 12000000,
+	[9] = 48000000,
+	[12] = 260000000,
+};
 
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
+static struct tegra_devclk devclks[] __initdata = {
+	{ .con_id = "pll_c", .dt_id = TEGRA30_CLK_PLL_C },
+	{ .con_id = "pll_c_out1", .dt_id = TEGRA30_CLK_PLL_C_OUT1 },
+	{ .con_id = "pll_p", .dt_id = TEGRA30_CLK_PLL_P },
+	{ .con_id = "pll_p_out1", .dt_id = TEGRA30_CLK_PLL_P_OUT1 },
+	{ .con_id = "pll_p_out2", .dt_id = TEGRA30_CLK_PLL_P_OUT2 },
+	{ .con_id = "pll_p_out3", .dt_id = TEGRA30_CLK_PLL_P_OUT3 },
+	{ .con_id = "pll_p_out4", .dt_id = TEGRA30_CLK_PLL_P_OUT4 },
+	{ .con_id = "pll_m", .dt_id = TEGRA30_CLK_PLL_M },
+	{ .con_id = "pll_m_out1", .dt_id = TEGRA30_CLK_PLL_M_OUT1 },
+	{ .con_id = "pll_x", .dt_id = TEGRA30_CLK_PLL_X },
+	{ .con_id = "pll_x_out0", .dt_id = TEGRA30_CLK_PLL_X_OUT0 },
+	{ .con_id = "pll_u", .dt_id = TEGRA30_CLK_PLL_U },
+	{ .con_id = "pll_d", .dt_id = TEGRA30_CLK_PLL_D },
+	{ .con_id = "pll_d_out0", .dt_id = TEGRA30_CLK_PLL_D_OUT0 },
+	{ .con_id = "pll_d2", .dt_id = TEGRA30_CLK_PLL_D2 },
+	{ .con_id = "pll_d2_out0", .dt_id = TEGRA30_CLK_PLL_D2_OUT0 },
+	{ .con_id = "pll_a", .dt_id = TEGRA30_CLK_PLL_A },
+	{ .con_id = "pll_a_out0", .dt_id = TEGRA30_CLK_PLL_A_OUT0 },
+	{ .con_id = "pll_e", .dt_id = TEGRA30_CLK_PLL_E },
+	{ .con_id = "spdif_in_sync", .dt_id = TEGRA30_CLK_SPDIF_IN_SYNC },
+	{ .con_id = "i2s0_sync", .dt_id = TEGRA30_CLK_I2S0_SYNC },
+	{ .con_id = "i2s1_sync", .dt_id = TEGRA30_CLK_I2S1_SYNC },
+	{ .con_id = "i2s2_sync", .dt_id = TEGRA30_CLK_I2S2_SYNC },
+	{ .con_id = "i2s3_sync", .dt_id = TEGRA30_CLK_I2S3_SYNC },
+	{ .con_id = "i2s4_sync", .dt_id = TEGRA30_CLK_I2S4_SYNC },
+	{ .con_id = "vimclk_sync", .dt_id = TEGRA30_CLK_VIMCLK_SYNC },
+	{ .con_id = "audio0", .dt_id = TEGRA30_CLK_AUDIO0 },
+	{ .con_id = "audio1", .dt_id = TEGRA30_CLK_AUDIO1 },
+	{ .con_id = "audio2", .dt_id = TEGRA30_CLK_AUDIO2 },
+	{ .con_id = "audio3", .dt_id = TEGRA30_CLK_AUDIO3 },
+	{ .con_id = "audio4", .dt_id = TEGRA30_CLK_AUDIO4 },
+	{ .con_id = "spdif", .dt_id = TEGRA30_CLK_SPDIF },
+	{ .con_id = "audio0_2x", .dt_id = TEGRA30_CLK_AUDIO0_2X },
+	{ .con_id = "audio1_2x", .dt_id = TEGRA30_CLK_AUDIO1_2X },
+	{ .con_id = "audio2_2x", .dt_id = TEGRA30_CLK_AUDIO2_2X },
+	{ .con_id = "audio3_2x", .dt_id = TEGRA30_CLK_AUDIO3_2X },
+	{ .con_id = "audio4_2x", .dt_id = TEGRA30_CLK_AUDIO4_2X },
+	{ .con_id = "spdif_2x", .dt_id = TEGRA30_CLK_SPDIF_2X },
+	{ .con_id = "extern1", .dev_id = "clk_out_1", .dt_id = TEGRA30_CLK_EXTERN1 },
+	{ .con_id = "extern2", .dev_id = "clk_out_2", .dt_id = TEGRA30_CLK_EXTERN2 },
+	{ .con_id = "extern3", .dev_id = "clk_out_3", .dt_id = TEGRA30_CLK_EXTERN3 },
+	{ .con_id = "blink", .dt_id = TEGRA30_CLK_BLINK },
+	{ .con_id = "cclk_g", .dt_id = TEGRA30_CLK_CCLK_G },
+	{ .con_id = "cclk_lp", .dt_id = TEGRA30_CLK_CCLK_LP },
+	{ .con_id = "sclk", .dt_id = TEGRA30_CLK_SCLK },
+	{ .con_id = "hclk", .dt_id = TEGRA30_CLK_HCLK },
+	{ .con_id = "pclk", .dt_id = TEGRA30_CLK_PCLK },
+	{ .con_id = "twd", .dt_id = TEGRA30_CLK_TWD },
+	{ .con_id = "emc", .dt_id = TEGRA30_CLK_EMC },
+	{ .con_id = "clk_32k", .dt_id = TEGRA30_CLK_CLK_32K },
+	{ .con_id = "clk_m_div2", .dt_id = TEGRA30_CLK_CLK_M_DIV2 },
+	{ .con_id = "clk_m_div4", .dt_id = TEGRA30_CLK_CLK_M_DIV4 },
+	{ .con_id = "cml0", .dt_id = TEGRA30_CLK_CML0 },
+	{ .con_id = "cml1", .dt_id = TEGRA30_CLK_CML1 },
+	{ .con_id = "clk_m", .dt_id = TEGRA30_CLK_CLK_M },
+	{ .con_id = "pll_ref", .dt_id = TEGRA30_CLK_PLL_REF },
+	{ .con_id = "csus", .dev_id = "tengra_camera", .dt_id = TEGRA30_CLK_CSUS },
+	{ .con_id = "vcp", .dev_id = "tegra-avp", .dt_id = TEGRA30_CLK_VCP },
+	{ .con_id = "bsea", .dev_id = "tegra-avp", .dt_id = TEGRA30_CLK_BSEA },
+	{ .con_id = "bsev", .dev_id = "tegra-aes", .dt_id = TEGRA30_CLK_BSEV },
+	{ .con_id = "dsia", .dev_id = "tegradc.0", .dt_id = TEGRA30_CLK_DSIA },
+	{ .con_id = "csi", .dev_id = "tegra_camera", .dt_id = TEGRA30_CLK_CSI },
+	{ .con_id = "isp", .dev_id = "tegra_camera", .dt_id = TEGRA30_CLK_ISP },
+	{ .con_id = "pcie", .dev_id = "tegra-pcie", .dt_id = TEGRA30_CLK_PCIE },
+	{ .con_id = "afi", .dev_id = "tegra-pcie", .dt_id = TEGRA30_CLK_AFI },
+	{ .con_id = "pciex", .dev_id = "tegra-pcie", .dt_id = TEGRA30_CLK_PCIEX },
+	{ .con_id = "fuse", .dev_id = "fuse-tegra", .dt_id = TEGRA30_CLK_FUSE },
+	{ .con_id = "fuse_burn", .dev_id = "fuse-tegra", .dt_id = TEGRA30_CLK_FUSE_BURN },
+	{ .con_id = "apbif", .dev_id = "tegra30-ahub", .dt_id = TEGRA30_CLK_APBIF },
+	{ .con_id = "hda2hdmi", .dev_id = "tegra30-hda", .dt_id = TEGRA30_CLK_HDA2HDMI },
+	{ .dev_id =  "tegra-apbdma", .dt_id = TEGRA30_CLK_APBDMA },
+	{ .dev_id =  "rtc-tegra", .dt_id = TEGRA30_CLK_RTC },
+	{ .dev_id =  "timer", .dt_id = TEGRA30_CLK_TIMER },
+	{ .dev_id =  "tegra-kbc", .dt_id = TEGRA30_CLK_KBC },
+	{ .dev_id =  "fsl-tegra-udc", .dt_id = TEGRA30_CLK_USBD },
+	{ .dev_id =  "tegra-ehci.1", .dt_id = TEGRA30_CLK_USB2 },
+	{ .dev_id =  "tegra-ehci.2", .dt_id = TEGRA30_CLK_USB2 },
+	{ .dev_id =  "kfuse-tegra", .dt_id = TEGRA30_CLK_KFUSE },
+	{ .dev_id =  "tegra_sata_cold", .dt_id = TEGRA30_CLK_SATA_COLD },
+	{ .dev_id =  "dtv", .dt_id = TEGRA30_CLK_DTV },
+	{ .dev_id = "tegra30-i2s.0", .dt_id = TEGRA30_CLK_I2S0 },
+	{ .dev_id = "tegra30-i2s.1", .dt_id = TEGRA30_CLK_I2S1 },
+	{ .dev_id = "tegra30-i2s.2", .dt_id = TEGRA30_CLK_I2S2 },
+	{ .dev_id = "tegra30-i2s.3", .dt_id = TEGRA30_CLK_I2S3 },
+	{ .dev_id = "tegra30-i2s.4", .dt_id = TEGRA30_CLK_I2S4 },
+	{ .con_id = "spdif_out", .dev_id = "tegra30-spdif", .dt_id = TEGRA30_CLK_SPDIF_OUT },
+	{ .con_id = "spdif_in", .dev_id = "tegra30-spdif", .dt_id = TEGRA30_CLK_SPDIF_IN },
+	{ .con_id = "d_audio", .dev_id = "tegra30-ahub", .dt_id = TEGRA30_CLK_D_AUDIO },
+	{ .dev_id = "tegra30-dam.0", .dt_id = TEGRA30_CLK_DAM0 },
+	{ .dev_id = "tegra30-dam.1", .dt_id = TEGRA30_CLK_DAM1 },
+	{ .dev_id = "tegra30-dam.2", .dt_id = TEGRA30_CLK_DAM2 },
+	{ .con_id = "hda", .dev_id = "tegra30-hda", .dt_id = TEGRA30_CLK_HDA },
+	{ .con_id = "hda2codec", .dev_id = "tegra30-hda", .dt_id = TEGRA30_CLK_HDA2CODEC_2X },
+	{ .dev_id = "spi_tegra.0", .dt_id = TEGRA30_CLK_SBC1 },
+	{ .dev_id = "spi_tegra.1", .dt_id = TEGRA30_CLK_SBC2 },
+	{ .dev_id = "spi_tegra.2", .dt_id = TEGRA30_CLK_SBC3 },
+	{ .dev_id = "spi_tegra.3", .dt_id = TEGRA30_CLK_SBC4 },
+	{ .dev_id = "spi_tegra.4", .dt_id = TEGRA30_CLK_SBC5 },
+	{ .dev_id = "spi_tegra.5", .dt_id = TEGRA30_CLK_SBC6 },
+	{ .dev_id = "tegra_sata_oob", .dt_id = TEGRA30_CLK_SATA_OOB },
+	{ .dev_id = "tegra_sata", .dt_id = TEGRA30_CLK_SATA },
+	{ .dev_id = "tegra_nand", .dt_id = TEGRA30_CLK_NDFLASH },
+	{ .dev_id = "tegra_nand_speed", .dt_id = TEGRA30_CLK_NDSPEED },
+	{ .dev_id = "vfir", .dt_id = TEGRA30_CLK_VFIR },
+	{ .dev_id = "csite", .dt_id = TEGRA30_CLK_CSITE },
+	{ .dev_id = "la", .dt_id = TEGRA30_CLK_LA },
+	{ .dev_id = "tegra_w1", .dt_id = TEGRA30_CLK_OWR },
+	{ .dev_id = "mipi", .dt_id = TEGRA30_CLK_MIPI },
+	{ .dev_id = "tegra-tsensor", .dt_id = TEGRA30_CLK_TSENSOR },
+	{ .dev_id = "i2cslow", .dt_id = TEGRA30_CLK_I2CSLOW },
+	{ .dev_id = "vde", .dt_id = TEGRA30_CLK_VDE },
+	{ .con_id = "vi", .dev_id = "tegra_camera", .dt_id = TEGRA30_CLK_VI },
+	{ .dev_id = "epp", .dt_id = TEGRA30_CLK_EPP },
+	{ .dev_id = "mpe", .dt_id = TEGRA30_CLK_MPE },
+	{ .dev_id = "host1x", .dt_id = TEGRA30_CLK_HOST1X },
+	{ .dev_id = "3d", .dt_id = TEGRA30_CLK_GR3D },
+	{ .dev_id = "3d2", .dt_id = TEGRA30_CLK_GR3D2 },
+	{ .dev_id = "2d", .dt_id = TEGRA30_CLK_GR2D },
+	{ .dev_id = "se", .dt_id = TEGRA30_CLK_SE },
+	{ .dev_id = "mselect", .dt_id = TEGRA30_CLK_MSELECT },
+	{ .dev_id = "tegra-nor", .dt_id = TEGRA30_CLK_NOR },
+	{ .dev_id = "sdhci-tegra.0", .dt_id = TEGRA30_CLK_SDMMC1 },
+	{ .dev_id = "sdhci-tegra.1", .dt_id = TEGRA30_CLK_SDMMC2 },
+	{ .dev_id = "sdhci-tegra.2", .dt_id = TEGRA30_CLK_SDMMC3 },
+	{ .dev_id = "sdhci-tegra.3", .dt_id = TEGRA30_CLK_SDMMC4 },
+	{ .dev_id = "cve", .dt_id = TEGRA30_CLK_CVE },
+	{ .dev_id = "tvo", .dt_id = TEGRA30_CLK_TVO },
+	{ .dev_id = "tvdac", .dt_id = TEGRA30_CLK_TVDAC },
+	{ .dev_id = "actmon", .dt_id = TEGRA30_CLK_ACTMON },
+	{ .con_id = "vi_sensor", .dev_id = "tegra_camera", .dt_id = TEGRA30_CLK_VI_SENSOR },
+	{ .con_id = "div-clk", .dev_id = "tegra-i2c.0", .dt_id = TEGRA30_CLK_I2C1 },
+	{ .con_id = "div-clk", .dev_id = "tegra-i2c.1", .dt_id = TEGRA30_CLK_I2C2 },
+	{ .con_id = "div-clk", .dev_id = "tegra-i2c.2", .dt_id = TEGRA30_CLK_I2C3 },
+	{ .con_id = "div-clk", .dev_id = "tegra-i2c.3", .dt_id = TEGRA30_CLK_I2C4 },
+	{ .con_id = "div-clk", .dev_id = "tegra-i2c.4", .dt_id = TEGRA30_CLK_I2C5 },
+	{ .dev_id = "tegra_uart.0", .dt_id = TEGRA30_CLK_UARTA },
+	{ .dev_id = "tegra_uart.1", .dt_id = TEGRA30_CLK_UARTB },
+	{ .dev_id = "tegra_uart.2", .dt_id = TEGRA30_CLK_UARTC },
+	{ .dev_id = "tegra_uart.3", .dt_id = TEGRA30_CLK_UARTD },
+	{ .dev_id = "tegra_uart.4", .dt_id = TEGRA30_CLK_UARTE },
+	{ .dev_id = "hdmi", .dt_id = TEGRA30_CLK_HDMI },
+	{ .dev_id = "extern1", .dt_id = TEGRA30_CLK_EXTERN1 },
+	{ .dev_id = "extern2", .dt_id = TEGRA30_CLK_EXTERN2 },
+	{ .dev_id = "extern3", .dt_id = TEGRA30_CLK_EXTERN3 },
+	{ .dev_id = "pwm", .dt_id = TEGRA30_CLK_PWM },
+	{ .dev_id = "tegradc.0", .dt_id = TEGRA30_CLK_DISP1 },
+	{ .dev_id = "tegradc.1", .dt_id = TEGRA30_CLK_DISP2 },
+	{ .dev_id = "tegradc.1", .dt_id = TEGRA30_CLK_DSIB },
+};
+
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
+
+};
 
 static void tegra30_utmi_param_configure(void)
 {
@@ -808,8 +933,7 @@ static void __init tegra30_pll_init(void)
 	/* PLLC */
 	clk = tegra_clk_register_pll("pll_c", "pll_ref", clk_base, pmc_base, 0,
 				&pll_c_params, NULL);
-	clk_register_clkdev(clk, "pll_c", NULL);
-	clks[pll_c] = clk;
+	clks[TEGRA30_CLK_PLL_C] = clk;
 
 	/* PLLC_OUT1 */
 	clk = tegra_clk_register_divider("pll_c_out1_div", "pll_c",
@@ -818,69 +942,13 @@ static void __init tegra30_pll_init(void)
 	clk = tegra_clk_register_pll_out("pll_c_out1", "pll_c_out1_div",
 				clk_base + PLLC_OUT, 1, 0, CLK_SET_RATE_PARENT,
 				0, NULL);
-	clk_register_clkdev(clk, "pll_c_out1", NULL);
-	clks[pll_c_out1] = clk;
-
-	/* PLLP */
-	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, pmc_base, 0,
-				&pll_p_params, NULL);
-	clk_register_clkdev(clk, "pll_p", NULL);
-	clks[pll_p] = clk;
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
-	clk_register_clkdev(clk, "pll_p_out1", NULL);
-	clks[pll_p_out1] = clk;
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
-	clk_register_clkdev(clk, "pll_p_out2", NULL);
-	clks[pll_p_out2] = clk;
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
-	clk_register_clkdev(clk, "pll_p_out3", NULL);
-	clks[pll_p_out3] = clk;
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
-	clk_register_clkdev(clk, "pll_p_out4", NULL);
-	clks[pll_p_out4] = clk;
+	clks[TEGRA30_CLK_PLL_C_OUT1] = clk;
 
 	/* PLLM */
 	clk = tegra_clk_register_pll("pll_m", "pll_ref", clk_base, pmc_base,
 			    CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE,
 			    &pll_m_params, NULL);
-	clk_register_clkdev(clk, "pll_m", NULL);
-	clks[pll_m] = clk;
+	clks[TEGRA30_CLK_PLL_M] = clk;
 
 	/* PLLM_OUT1 */
 	clk = tegra_clk_register_divider("pll_m_out1_div", "pll_m",
@@ -889,68 +957,44 @@ static void __init tegra30_pll_init(void)
 	clk = tegra_clk_register_pll_out("pll_m_out1", "pll_m_out1_div",
 				clk_base + PLLM_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
-	clk_register_clkdev(clk, "pll_m_out1", NULL);
-	clks[pll_m_out1] = clk;
+	clks[TEGRA30_CLK_PLL_M_OUT1] = clk;
 
 	/* PLLX */
 	clk = tegra_clk_register_pll("pll_x", "pll_ref", clk_base, pmc_base, 0,
 			    &pll_x_params, NULL);
-	clk_register_clkdev(clk, "pll_x", NULL);
-	clks[pll_x] = clk;
+	clks[TEGRA30_CLK_PLL_X] = clk;
 
 	/* PLLX_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_x_out0", "pll_x",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "pll_x_out0", NULL);
-	clks[pll_x_out0] = clk;
+	clks[TEGRA30_CLK_PLL_X_OUT0] = clk;
 
 	/* PLLU */
 	clk = tegra_clk_register_pll("pll_u", "pll_ref", clk_base, pmc_base, 0,
 			    &pll_u_params, NULL);
-	clk_register_clkdev(clk, "pll_u", NULL);
-	clks[pll_u] = clk;
+	clks[TEGRA30_CLK_PLL_U] = clk;
 
 	tegra30_utmi_param_configure();
 
 	/* PLLD */
 	clk = tegra_clk_register_pll("pll_d", "pll_ref", clk_base, pmc_base, 0,
 			    &pll_d_params, &pll_d_lock);
-	clk_register_clkdev(clk, "pll_d", NULL);
-	clks[pll_d] = clk;
+	clks[TEGRA30_CLK_PLL_D] = clk;
 
 	/* PLLD_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d_out0", "pll_d",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "pll_d_out0", NULL);
-	clks[pll_d_out0] = clk;
+	clks[TEGRA30_CLK_PLL_D_OUT0] = clk;
 
 	/* PLLD2 */
 	clk = tegra_clk_register_pll("pll_d2", "pll_ref", clk_base, pmc_base, 0,
 			    &pll_d2_params, NULL);
-	clk_register_clkdev(clk, "pll_d2", NULL);
-	clks[pll_d2] = clk;
+	clks[TEGRA30_CLK_PLL_D2] = clk;
 
 	/* PLLD2_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d2_out0", "pll_d2",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "pll_d2_out0", NULL);
-	clks[pll_d2_out0] = clk;
-
-	/* PLLA */
-	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, pmc_base,
-			    0, &pll_a_params, NULL);
-	clk_register_clkdev(clk, "pll_a", NULL);
-	clks[pll_a] = clk;
-
-	/* PLLA_OUT0 */
-	clk = tegra_clk_register_divider("pll_a_out0_div", "pll_a",
-				clk_base + PLLA_OUT, 0, TEGRA_DIVIDER_ROUND_UP,
-				8, 8, 1, NULL);
-	clk = tegra_clk_register_pll_out("pll_a_out0", "pll_a_out0_div",
-				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
-				CLK_SET_RATE_PARENT, 0, NULL);
-	clk_register_clkdev(clk, "pll_a_out0", NULL);
-	clks[pll_a_out0] = clk;
+	clks[TEGRA30_CLK_PLL_D2_OUT0] = clk;
 
 	/* PLLE */
 	clk = clk_register_mux(NULL, "pll_e_mux", pll_e_parents,
@@ -959,256 +1003,7 @@ static void __init tegra30_pll_init(void)
 			       clk_base + PLLE_AUX, 2, 1, 0, NULL);
 	clk = tegra_clk_register_plle("pll_e", "pll_e_mux", clk_base, pmc_base,
 			     CLK_GET_RATE_NOCACHE, &pll_e_params, NULL);
-	clk_register_clkdev(clk, "pll_e", NULL);
-	clks[pll_e] = clk;
-}
-
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
-	clk_register_clkdev(clk, "spdif_in_sync", NULL);
-	clks[spdif_in_sync] = clk;
-
-	/* i2s0_sync */
-	clk = tegra_clk_register_sync_source("i2s0_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s0_sync", NULL);
-	clks[i2s0_sync] = clk;
-
-	/* i2s1_sync */
-	clk = tegra_clk_register_sync_source("i2s1_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s1_sync", NULL);
-	clks[i2s1_sync] = clk;
-
-	/* i2s2_sync */
-	clk = tegra_clk_register_sync_source("i2s2_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s2_sync", NULL);
-	clks[i2s2_sync] = clk;
-
-	/* i2s3_sync */
-	clk = tegra_clk_register_sync_source("i2s3_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s3_sync", NULL);
-	clks[i2s3_sync] = clk;
-
-	/* i2s4_sync */
-	clk = tegra_clk_register_sync_source("i2s4_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s4_sync", NULL);
-	clks[i2s4_sync] = clk;
-
-	/* vimclk_sync */
-	clk = tegra_clk_register_sync_source("vimclk_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "vimclk_sync", NULL);
-	clks[vimclk_sync] = clk;
-
-	/* audio0 */
-	clk = clk_register_mux(NULL, "audio0_mux", mux_audio_sync_clk,
-				ARRAY_SIZE(mux_audio_sync_clk),
-				CLK_SET_RATE_NO_REPARENT,
-				clk_base + AUDIO_SYNC_CLK_I2S0, 0, 3, 0, NULL);
-	clk = clk_register_gate(NULL, "audio0", "audio0_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S0, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio0", NULL);
-	clks[audio0] = clk;
-
-	/* audio1 */
-	clk = clk_register_mux(NULL, "audio1_mux", mux_audio_sync_clk,
-				ARRAY_SIZE(mux_audio_sync_clk),
-				CLK_SET_RATE_NO_REPARENT,
-				clk_base + AUDIO_SYNC_CLK_I2S1, 0, 3, 0, NULL);
-	clk = clk_register_gate(NULL, "audio1", "audio1_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S1, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio1", NULL);
-	clks[audio1] = clk;
-
-	/* audio2 */
-	clk = clk_register_mux(NULL, "audio2_mux", mux_audio_sync_clk,
-				ARRAY_SIZE(mux_audio_sync_clk),
-				CLK_SET_RATE_NO_REPARENT,
-				clk_base + AUDIO_SYNC_CLK_I2S2, 0, 3, 0, NULL);
-	clk = clk_register_gate(NULL, "audio2", "audio2_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S2, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio2", NULL);
-	clks[audio2] = clk;
-
-	/* audio3 */
-	clk = clk_register_mux(NULL, "audio3_mux", mux_audio_sync_clk,
-				ARRAY_SIZE(mux_audio_sync_clk),
-				CLK_SET_RATE_NO_REPARENT,
-				clk_base + AUDIO_SYNC_CLK_I2S3, 0, 3, 0, NULL);
-	clk = clk_register_gate(NULL, "audio3", "audio3_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S3, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio3", NULL);
-	clks[audio3] = clk;
-
-	/* audio4 */
-	clk = clk_register_mux(NULL, "audio4_mux", mux_audio_sync_clk,
-				ARRAY_SIZE(mux_audio_sync_clk),
-				CLK_SET_RATE_NO_REPARENT,
-				clk_base + AUDIO_SYNC_CLK_I2S4, 0, 3, 0, NULL);
-	clk = clk_register_gate(NULL, "audio4", "audio4_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S4, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio4", NULL);
-	clks[audio4] = clk;
-
-	/* spdif */
-	clk = clk_register_mux(NULL, "spdif_mux", mux_audio_sync_clk,
-				ARRAY_SIZE(mux_audio_sync_clk),
-				CLK_SET_RATE_NO_REPARENT,
-				clk_base + AUDIO_SYNC_CLK_SPDIF, 0, 3, 0, NULL);
-	clk = clk_register_gate(NULL, "spdif", "spdif_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_SPDIF, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "spdif", NULL);
-	clks[spdif] = clk;
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
-	clk_register_clkdev(clk, "audio0_2x", NULL);
-	clks[audio0_2x] = clk;
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
-	clk_register_clkdev(clk, "audio1_2x", NULL);
-	clks[audio1_2x] = clk;
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
-	clk_register_clkdev(clk, "audio2_2x", NULL);
-	clks[audio2_2x] = clk;
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
-	clk_register_clkdev(clk, "audio3_2x", NULL);
-	clks[audio3_2x] = clk;
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
-	clk_register_clkdev(clk, "audio4_2x", NULL);
-	clks[audio4_2x] = clk;
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
-	clk_register_clkdev(clk, "spdif_2x", NULL);
-	clks[spdif_2x] = clk;
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
-	clks[clk_out_1_mux] = clk;
-	clk = clk_register_gate(NULL, "clk_out_1", "clk_out_1_mux", 0,
-				pmc_base + PMC_CLK_OUT_CNTRL, 2, 0,
-				&clk_out_lock);
-	clk_register_clkdev(clk, "extern1", "clk_out_1");
-	clks[clk_out_1] = clk;
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
-	clk_register_clkdev(clk, "extern2", "clk_out_2");
-	clks[clk_out_2] = clk;
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
-	clk_register_clkdev(clk, "extern3", "clk_out_3");
-	clks[clk_out_3] = clk;
-
-	/* blink */
-	writel_relaxed(0, pmc_base + PMC_BLINK_TIMER);
-	clk = clk_register_gate(NULL, "blink_override", "clk_32k", 0,
-				pmc_base + PMC_DPD_PADS_ORIDE,
-				PMC_DPD_PADS_ORIDE_BLINK_ENB, 0, NULL);
-	clk = clk_register_gate(NULL, "blink", "blink_override", 0,
-				pmc_base + PMC_CTRL,
-				PMC_CTRL_BLINK_ENB, 0, NULL);
-	clk_register_clkdev(clk, "blink", NULL);
-	clks[blink] = clk;
-
+	clks[TEGRA30_CLK_PLL_E] = clk;
 }
 
 static const char *cclk_g_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
@@ -1259,8 +1054,7 @@ static void __init tegra30_super_clk_init(void)
 				  CLK_SET_RATE_PARENT,
 				  clk_base + CCLKG_BURST_POLICY,
 				  0, 4, 0, 0, NULL);
-	clk_register_clkdev(clk, "cclk_g", NULL);
-	clks[cclk_g] = clk;
+	clks[TEGRA30_CLK_CCLK_G] = clk;
 
 	/*
 	 * Clock input to cclk_lp divided from pll_p using
@@ -1296,8 +1090,7 @@ static void __init tegra30_super_clk_init(void)
 				  clk_base + CCLKLP_BURST_POLICY,
 				  TEGRA_DIVIDER_2, 4, 8, 9,
 			      NULL);
-	clk_register_clkdev(clk, "cclk_lp", NULL);
-	clks[cclk_lp] = clk;
+	clks[TEGRA30_CLK_CCLK_LP] = clk;
 
 	/* SCLK */
 	clk = tegra_clk_register_super_mux("sclk", sclk_parents,
@@ -1305,142 +1098,42 @@ static void __init tegra30_super_clk_init(void)
 				  CLK_SET_RATE_PARENT,
 				  clk_base + SCLK_BURST_POLICY,
 				  0, 4, 0, 0, NULL);
-	clk_register_clkdev(clk, "sclk", NULL);
-	clks[sclk] = clk;
-
-	/* HCLK */
-	clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
-				   clk_base + SYSTEM_CLK_RATE, 4, 2, 0,
-				   &sysrate_lock);
-	clk = clk_register_gate(NULL, "hclk", "hclk_div", CLK_SET_RATE_PARENT,
-				clk_base + SYSTEM_CLK_RATE, 7,
-				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clk_register_clkdev(clk, "hclk", NULL);
-	clks[hclk] = clk;
-
-	/* PCLK */
-	clk = clk_register_divider(NULL, "pclk_div", "hclk", 0,
-				   clk_base + SYSTEM_CLK_RATE, 0, 2, 0,
-				   &sysrate_lock);
-	clk = clk_register_gate(NULL, "pclk", "pclk_div", CLK_SET_RATE_PARENT,
-				clk_base + SYSTEM_CLK_RATE, 3,
-				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clk_register_clkdev(clk, "pclk", NULL);
-	clks[pclk] = clk;
+	clks[TEGRA30_CLK_SCLK] = clk;
 
 	/* twd */
 	clk = clk_register_fixed_factor(NULL, "twd", "cclk_g",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "twd", NULL);
-	clks[twd] = clk;
+	clks[TEGRA30_CLK_TWD] = clk;
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
-	TEGRA_INIT_DATA_MUX("i2s0",	NULL,		"tegra30-i2s.0",	i2s0_parents,		CLK_SOURCE_I2S0,	30,	TEGRA_PERIPH_ON_APB, i2s0),
-	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra30-i2s.1",	i2s1_parents,		CLK_SOURCE_I2S1,	11,	TEGRA_PERIPH_ON_APB, i2s1),
-	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra30-i2s.2",	i2s2_parents,		CLK_SOURCE_I2S2,	18,	TEGRA_PERIPH_ON_APB, i2s2),
-	TEGRA_INIT_DATA_MUX("i2s3",	NULL,		"tegra30-i2s.3",	i2s3_parents,		CLK_SOURCE_I2S3,	101,	TEGRA_PERIPH_ON_APB, i2s3),
-	TEGRA_INIT_DATA_MUX("i2s4",	NULL,		"tegra30-i2s.4",	i2s4_parents,		CLK_SOURCE_I2S4,	102,	TEGRA_PERIPH_ON_APB, i2s4),
-	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra30-spdif",	spdif_out_parents,	CLK_SOURCE_SPDIF_OUT,	10,	TEGRA_PERIPH_ON_APB, spdif_out),
-	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra30-spdif",	spdif_in_parents,	CLK_SOURCE_SPDIF_IN,	10,	TEGRA_PERIPH_ON_APB, spdif_in),
-	TEGRA_INIT_DATA_MUX("d_audio",	"d_audio",	"tegra30-ahub",		mux_pllacp_clkm,	CLK_SOURCE_D_AUDIO,	106,	0, d_audio),
-	TEGRA_INIT_DATA_MUX("dam0",	NULL,		"tegra30-dam.0",	mux_pllacp_clkm,	CLK_SOURCE_DAM0,	108,	0, dam0),
-	TEGRA_INIT_DATA_MUX("dam1",	NULL,		"tegra30-dam.1",	mux_pllacp_clkm,	CLK_SOURCE_DAM1,	109,	0, dam1),
-	TEGRA_INIT_DATA_MUX("dam2",	NULL,		"tegra30-dam.2",	mux_pllacp_clkm,	CLK_SOURCE_DAM2,	110,	0, dam2),
-	TEGRA_INIT_DATA_MUX("hda",	"hda",		"tegra30-hda",		mux_pllpcm_clkm,	CLK_SOURCE_HDA,		125,	0, hda),
-	TEGRA_INIT_DATA_MUX("hda2codec_2x", "hda2codec", "tegra30-hda",		mux_pllpcm_clkm,	CLK_SOURCE_HDA2CODEC_2X, 111,	0, hda2codec_2x),
-	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",		mux_pllpcm_clkm,	CLK_SOURCE_SBC1,	41,	TEGRA_PERIPH_ON_APB, sbc1),
-	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",		mux_pllpcm_clkm,	CLK_SOURCE_SBC2,	44,	TEGRA_PERIPH_ON_APB, sbc2),
-	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",		mux_pllpcm_clkm,	CLK_SOURCE_SBC3,	46,	TEGRA_PERIPH_ON_APB, sbc3),
-	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",		mux_pllpcm_clkm,	CLK_SOURCE_SBC4,	68,	TEGRA_PERIPH_ON_APB, sbc4),
-	TEGRA_INIT_DATA_MUX("sbc5",	NULL,		"spi_tegra.4",		mux_pllpcm_clkm,	CLK_SOURCE_SBC5,	104,	TEGRA_PERIPH_ON_APB, sbc5),
-	TEGRA_INIT_DATA_MUX("sbc6",	NULL,		"spi_tegra.5",		mux_pllpcm_clkm,	CLK_SOURCE_SBC6,	105,	TEGRA_PERIPH_ON_APB, sbc6),
-	TEGRA_INIT_DATA_MUX("sata_oob",	NULL,		"tegra_sata_oob",	mux_pllpcm_clkm,	CLK_SOURCE_SATA_OOB,	123,	TEGRA_PERIPH_ON_APB, sata_oob),
-	TEGRA_INIT_DATA_MUX("sata",	NULL,		"tegra_sata",		mux_pllpcm_clkm,	CLK_SOURCE_SATA,	124,	TEGRA_PERIPH_ON_APB, sata),
-	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",		mux_pllpcm_clkm,	CLK_SOURCE_NDFLASH,	13,	TEGRA_PERIPH_ON_APB, ndflash),
-	TEGRA_INIT_DATA_MUX("ndspeed",	NULL,		"tegra_nand_speed",	mux_pllpcm_clkm,	CLK_SOURCE_NDSPEED,	80,	TEGRA_PERIPH_ON_APB, ndspeed),
-	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",			mux_pllpcm_clkm,	CLK_SOURCE_VFIR,	7,	TEGRA_PERIPH_ON_APB, vfir),
-	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",		mux_pllpcm_clkm,	CLK_SOURCE_CSITE,	73,	TEGRA_PERIPH_ON_APB, csite),
-	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",			mux_pllpcm_clkm,	CLK_SOURCE_LA,		76,	TEGRA_PERIPH_ON_APB, la),
-	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",		mux_pllpcm_clkm,	CLK_SOURCE_OWR,		71,	TEGRA_PERIPH_ON_APB, owr),
-	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",			mux_pllpcm_clkm,	CLK_SOURCE_MIPI,	50,	TEGRA_PERIPH_ON_APB, mipi),
-	TEGRA_INIT_DATA_MUX("tsensor",	NULL,		"tegra-tsensor",	mux_pllpc_clkm_clk32k,	CLK_SOURCE_TSENSOR,	100,	TEGRA_PERIPH_ON_APB, tsensor),
-	TEGRA_INIT_DATA_MUX("i2cslow",	NULL,		"i2cslow",		mux_pllpc_clk32k_clkm,	CLK_SOURCE_I2CSLOW,	81,	TEGRA_PERIPH_ON_APB, i2cslow),
-	TEGRA_INIT_DATA_INT("vde",	NULL,		"vde",			mux_pllpcm_clkm,	CLK_SOURCE_VDE,		61,	0, vde),
-	TEGRA_INIT_DATA_INT("vi",	"vi",		"tegra_camera",		mux_pllmcpa,		CLK_SOURCE_VI,		20,	0, vi),
-	TEGRA_INIT_DATA_INT("epp",	NULL,		"epp",			mux_pllmcpa,		CLK_SOURCE_EPP,		19,	0, epp),
-	TEGRA_INIT_DATA_INT("mpe",	NULL,		"mpe",			mux_pllmcpa,		CLK_SOURCE_MPE,		60,	0, mpe),
-	TEGRA_INIT_DATA_INT("host1x",	NULL,		"host1x",		mux_pllmcpa,		CLK_SOURCE_HOST1X,	28,	0, host1x),
-	TEGRA_INIT_DATA_INT("3d",	NULL,		"3d",			mux_pllmcpa,		CLK_SOURCE_3D,		24,	TEGRA_PERIPH_MANUAL_RESET, gr3d),
-	TEGRA_INIT_DATA_INT("3d2",	NULL,		"3d2",			mux_pllmcpa,		CLK_SOURCE_3D2,		98,	TEGRA_PERIPH_MANUAL_RESET, gr3d2),
-	TEGRA_INIT_DATA_INT("2d",	NULL,		"2d",			mux_pllmcpa,		CLK_SOURCE_2D,		21,	0, gr2d),
-	TEGRA_INIT_DATA_INT("se",	NULL,		"se",			mux_pllpcm_clkm,	CLK_SOURCE_SE,		127,	0, se),
-	TEGRA_INIT_DATA_MUX("mselect",	NULL,		"mselect",		mux_pllp_clkm,		CLK_SOURCE_MSELECT,	99,	0, mselect),
-	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",		mux_pllpcm_clkm,	CLK_SOURCE_NOR,		42,	0, nor),
-	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC1,	14,	0, sdmmc1),
-	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC2,	9,	0, sdmmc2),
-	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC3,	69,	0, sdmmc3),
-	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC4,	15,	0, sdmmc4),
-	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",			mux_pllpdc_clkm,	CLK_SOURCE_CVE,		49,	0, cve),
-	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",			mux_pllpdc_clkm,	CLK_SOURCE_TVO,		49,	0, tvo),
-	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",		mux_pllpdc_clkm,	CLK_SOURCE_TVDAC,	53,	0, tvdac),
-	TEGRA_INIT_DATA_MUX("actmon",	NULL,		"actmon",		mux_pllpc_clk32k_clkm,	CLK_SOURCE_ACTMON,	119,	0, actmon),
-	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",		mux_pllmcpa,		CLK_SOURCE_VI_SENSOR,	20,	TEGRA_PERIPH_NO_RESET, vi_sensor),
-	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",		mux_pllp_clkm,		CLK_SOURCE_I2C1,	12,	TEGRA_PERIPH_ON_APB, i2c1),
-	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",		mux_pllp_clkm,		CLK_SOURCE_I2C2,	54,	TEGRA_PERIPH_ON_APB, i2c2),
-	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",		mux_pllp_clkm,		CLK_SOURCE_I2C3,	67,	TEGRA_PERIPH_ON_APB, i2c3),
-	TEGRA_INIT_DATA_DIV16("i2c4",	"div-clk",	"tegra-i2c.3",		mux_pllp_clkm,		CLK_SOURCE_I2C4,	103,	TEGRA_PERIPH_ON_APB, i2c4),
-	TEGRA_INIT_DATA_DIV16("i2c5",	"div-clk",	"tegra-i2c.4",		mux_pllp_clkm,		CLK_SOURCE_I2C5,	47,	TEGRA_PERIPH_ON_APB, i2c5),
-	TEGRA_INIT_DATA_UART("uarta",	NULL,		"tegra_uart.0",		mux_pllpcm_clkm,	CLK_SOURCE_UARTA,	6,	uarta),
-	TEGRA_INIT_DATA_UART("uartb",	NULL,		"tegra_uart.1",		mux_pllpcm_clkm,	CLK_SOURCE_UARTB,	7,	uartb),
-	TEGRA_INIT_DATA_UART("uartc",	NULL,		"tegra_uart.2",		mux_pllpcm_clkm,	CLK_SOURCE_UARTC,	55,	uartc),
-	TEGRA_INIT_DATA_UART("uartd",	NULL,		"tegra_uart.3",		mux_pllpcm_clkm,	CLK_SOURCE_UARTD,	65,	uartd),
-	TEGRA_INIT_DATA_UART("uarte",	NULL,		"tegra_uart.4",		mux_pllpcm_clkm,	CLK_SOURCE_UARTE,	66,	uarte),
-	TEGRA_INIT_DATA_MUX8("hdmi",	NULL,		"hdmi",			mux_pllpmdacd2_clkm,	CLK_SOURCE_HDMI,	51,	0, hdmi),
-	TEGRA_INIT_DATA_MUX8("extern1",	NULL,		"extern1",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN1,	120,	0, extern1),
-	TEGRA_INIT_DATA_MUX8("extern2",	NULL,		"extern2",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN2,	121,	0, extern2),
-	TEGRA_INIT_DATA_MUX8("extern3",	NULL,		"extern3",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN3,	122,	0, extern3),
-	TEGRA_INIT_DATA("pwm",		NULL,		"pwm",			mux_pllpc_clk32k_clkm,	CLK_SOURCE_PWM,		28, 2, 0, 0, 8, 1, 0, 17, 0, pwm),
+	TEGRA_INIT_DATA_MUX("spdif_out", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SPDIF_OUT),
+	TEGRA_INIT_DATA_MUX("d_audio", mux_pllacp_clkm, CLK_SOURCE_D_AUDIO, 106, 0, TEGRA30_CLK_D_AUDIO),
+	TEGRA_INIT_DATA_MUX("dam0", mux_pllacp_clkm, CLK_SOURCE_DAM0, 108, 0, TEGRA30_CLK_DAM0),
+	TEGRA_INIT_DATA_MUX("dam1", mux_pllacp_clkm, CLK_SOURCE_DAM1, 109, 0, TEGRA30_CLK_DAM1),
+	TEGRA_INIT_DATA_MUX("dam2", mux_pllacp_clkm, CLK_SOURCE_DAM2, 110, 0, TEGRA30_CLK_DAM2),
+	TEGRA_INIT_DATA_INT("3d2", mux_pllmcpa, CLK_SOURCE_3D2, 98, TEGRA_PERIPH_MANUAL_RESET, TEGRA30_CLK_GR3D2),
+	TEGRA_INIT_DATA_INT("se", mux_pllpcm_clkm, CLK_SOURCE_SE, 127, 0, TEGRA30_CLK_SE),
+	TEGRA_INIT_DATA_MUX8("hdmi", mux_pllpmdacd2_clkm, CLK_SOURCE_HDMI, 51, 0, TEGRA30_CLK_HDMI),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
-	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0", mux_pllpmdacd2_clkm,	     CLK_SOURCE_DISP1,	29, 3, 27, 0, disp1),
-	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1", mux_pllpmdacd2_clkm,      CLK_SOURCE_DISP2,	29, 3, 26, 0, disp2),
-	TEGRA_INIT_DATA_NODIV("dsib",	NULL, "tegradc.1", mux_plld_out0_plld2_out0, CLK_SOURCE_DSIB,	25, 1, 82, 0, dsib),
+	TEGRA_INIT_DATA_NODIV("dsib", mux_plld_out0_plld2_out0, CLK_SOURCE_DSIB, 25, 1, 82, 0, TEGRA30_CLK_DSIB),
 };
 
 static void __init tegra30_periph_clk_init(void)
@@ -1449,158 +1142,25 @@ static void __init tegra30_periph_clk_init(void)
 	struct clk *clk;
 	int i;
 
-	/* apbdma */
-	clk = tegra_clk_register_periph_gate("apbdma", "clk_m", 0, clk_base, 0, 34,
-				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra-apbdma");
-	clks[apbdma] = clk;
-
-	/* rtc */
-	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
-				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 4, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "rtc-tegra");
-	clks[rtc] = clk;
-
-	/* timer */
-	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base, 0,
-				    5, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "timer");
-	clks[timer] = clk;
-
-	/* kbc */
-	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
-				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 36, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra-kbc");
-	clks[kbc] = clk;
-
-	/* csus */
-	clk = tegra_clk_register_periph_gate("csus", "clk_m",
-				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 92, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "csus", "tengra_camera");
-	clks[csus] = clk;
-
-	/* vcp */
-	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0, clk_base, 0, 29,
-				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "vcp", "tegra-avp");
-	clks[vcp] = clk;
-
-	/* bsea */
-	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0, clk_base, 0,
-				    62, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "bsea", "tegra-avp");
-	clks[bsea] = clk;
-
-	/* bsev */
-	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0, clk_base, 0,
-				    63, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "bsev", "tegra-aes");
-	clks[bsev] = clk;
-
-	/* usbd */
-	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base, 0,
-				    22, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "fsl-tegra-udc");
-	clks[usbd] = clk;
-
-	/* usb2 */
-	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base, 0,
-				    58, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra-ehci.1");
-	clks[usb2] = clk;
-
-	/* usb3 */
-	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base, 0,
-				    59, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra-ehci.2");
-	clks[usb3] = clk;
-
 	/* dsia */
 	clk = tegra_clk_register_periph_gate("dsia", "pll_d_out0", 0, clk_base,
 				    0, 48, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "dsia", "tegradc.0");
-	clks[dsia] = clk;
-
-	/* csi */
-	clk = tegra_clk_register_periph_gate("csi", "pll_p_out3", 0, clk_base,
-				    0, 52, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "csi", "tegra_camera");
-	clks[csi] = clk;
-
-	/* isp */
-	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0, 23,
-				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "isp", "tegra_camera");
-	clks[isp] = clk;
+	clks[TEGRA30_CLK_DSIA] = clk;
 
 	/* pcie */
 	clk = tegra_clk_register_periph_gate("pcie", "clk_m", 0, clk_base, 0,
 				    70, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "pcie", "tegra-pcie");
-	clks[pcie] = clk;
+	clks[TEGRA30_CLK_PCIE] = clk;
 
 	/* afi */
 	clk = tegra_clk_register_periph_gate("afi", "clk_m", 0, clk_base, 0, 72,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "afi", "tegra-pcie");
-	clks[afi] = clk;
+	clks[TEGRA30_CLK_AFI] = clk;
 
 	/* pciex */
 	clk = tegra_clk_register_periph_gate("pciex", "pll_e", 0, clk_base, 0,
 				    74, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "pciex", "tegra-pcie");
-	clks[pciex] = clk;
-
-	/* kfuse */
-	clk = tegra_clk_register_periph_gate("kfuse", "clk_m",
-				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 40, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "kfuse-tegra");
-	clks[kfuse] = clk;
-
-	/* fuse */
-	clk = tegra_clk_register_periph_gate("fuse", "clk_m",
-				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 39, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "fuse", "fuse-tegra");
-	clks[fuse] = clk;
-
-	/* fuse_burn */
-	clk = tegra_clk_register_periph_gate("fuse_burn", "clk_m",
-				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 39, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "fuse_burn", "fuse-tegra");
-	clks[fuse_burn] = clk;
-
-	/* apbif */
-	clk = tegra_clk_register_periph_gate("apbif", "clk_m", 0,
-				    clk_base, 0, 107, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "apbif", "tegra30-ahub");
-	clks[apbif] = clk;
-
-	/* hda2hdmi */
-	clk = tegra_clk_register_periph_gate("hda2hdmi", "clk_m",
-				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 128, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "hda2hdmi", "tegra30-hda");
-	clks[hda2hdmi] = clk;
-
-	/* sata_cold */
-	clk = tegra_clk_register_periph_gate("sata_cold", "clk_m",
-				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 129, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra_sata_cold");
-	clks[sata_cold] = clk;
-
-	/* dtv */
-	clk = tegra_clk_register_periph_gate("dtv", "clk_m",
-				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 79, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "dtv");
-	clks[dtv] = clk;
+	clks[TEGRA30_CLK_PCIEX] = clk;
 
 	/* emc */
 	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
@@ -1610,15 +1170,23 @@ static void __init tegra30_periph_clk_init(void)
 			       30, 2, 0, NULL);
 	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base, 0,
 				    57, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "emc", NULL);
-	clks[emc] = clk;
+	clks[TEGRA30_CLK_EMC] = clk;
+
+	/* cml0 */
+	clk = clk_register_gate(NULL, "cml0", "pll_e", 0, clk_base + PLLE_AUX,
+				0, 0, &cml_lock);
+	clks[TEGRA30_CLK_CML0] = clk;
+
+	/* cml1 */
+	clk = clk_register_gate(NULL, "cml1", "pll_e", 0, clk_base + PLLE_AUX,
+				1, 0, &cml_lock);
+	clks[TEGRA30_CLK_CML1] = clk;
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
 		data = &tegra_periph_clk_list[i];
 		clk = tegra_clk_register_periph(data->name, data->p.parent_names,
 				data->num_parents, &data->periph,
 				clk_base, data->offset, data->flags);
-		clk_register_clkdev(clk, data->con_id, data->dev_id);
 		clks[data->clk_id] = clk;
 	}
 
@@ -1628,65 +1196,10 @@ static void __init tegra30_periph_clk_init(void)
 					data->p.parent_names,
 					data->num_parents, &data->periph,
 					clk_base, data->offset);
-		clk_register_clkdev(clk, data->con_id, data->dev_id);
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
-	clk_register_clkdev(clk, "clk_32k", NULL);
-	clks[clk_32k] = clk;
-
-	/* clk_m_div2 */
-	clk = clk_register_fixed_factor(NULL, "clk_m_div2", "clk_m",
-				CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "clk_m_div2", NULL);
-	clks[clk_m_div2] = clk;
-
-	/* clk_m_div4 */
-	clk = clk_register_fixed_factor(NULL, "clk_m_div4", "clk_m",
-				CLK_SET_RATE_PARENT, 1, 4);
-	clk_register_clkdev(clk, "clk_m_div4", NULL);
-	clks[clk_m_div4] = clk;
-
-	/* cml0 */
-	clk = clk_register_gate(NULL, "cml0", "pll_e", 0, clk_base + PLLE_AUX,
-				0, 0, &cml_lock);
-	clk_register_clkdev(clk, "cml0", NULL);
-	clks[cml0] = clk;
-
-	/* cml1 */
-	clk = clk_register_gate(NULL, "cml1", "pll_e", 0, clk_base + PLLE_AUX,
-				1, 0, &cml_lock);
-	clk_register_clkdev(clk, "cml1", NULL);
-	clks[cml1] = clk;
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
-	clk_register_clkdev(clk, "clk_m", NULL);
-	clks[clk_m] = clk;
-
-	/* pll_ref */
-	pll_ref_div = tegra30_get_pll_ref_div();
-	clk = clk_register_fixed_factor(NULL, "pll_ref", "clk_m",
-				CLK_SET_RATE_PARENT, 1, pll_ref_div);
-	clk_register_clkdev(clk, "pll_ref", NULL);
-	clks[pll_ref] = clk;
+	tegra_periph_clk_init(clk_base, pmc_base, tegra30_clks, &pll_p_params);
 }
 
 /* Tegra30 CPU clock and reset control functions */
@@ -1828,48 +1341,48 @@ static struct tegra_cpu_car_ops tegra30_cpu_car_ops = {
 };
 
 static struct tegra_clk_init_table init_table[] __initdata = {
-	{uarta, pll_p, 408000000, 0},
-	{uartb, pll_p, 408000000, 0},
-	{uartc, pll_p, 408000000, 0},
-	{uartd, pll_p, 408000000, 0},
-	{uarte, pll_p, 408000000, 0},
-	{pll_a, clk_max, 564480000, 1},
-	{pll_a_out0, clk_max, 11289600, 1},
-	{extern1, pll_a_out0, 0, 1},
-	{clk_out_1_mux, extern1, 0, 0},
-	{clk_out_1, clk_max, 0, 1},
-	{blink, clk_max, 0, 1},
-	{i2s0, pll_a_out0, 11289600, 0},
-	{i2s1, pll_a_out0, 11289600, 0},
-	{i2s2, pll_a_out0, 11289600, 0},
-	{i2s3, pll_a_out0, 11289600, 0},
-	{i2s4, pll_a_out0, 11289600, 0},
-	{sdmmc1, pll_p, 48000000, 0},
-	{sdmmc2, pll_p, 48000000, 0},
-	{sdmmc3, pll_p, 48000000, 0},
-	{pll_m, clk_max, 0, 1},
-	{pclk, clk_max, 0, 1},
-	{csite, clk_max, 0, 1},
-	{emc, clk_max, 0, 1},
-	{mselect, clk_max, 0, 1},
-	{sbc1, pll_p, 100000000, 0},
-	{sbc2, pll_p, 100000000, 0},
-	{sbc3, pll_p, 100000000, 0},
-	{sbc4, pll_p, 100000000, 0},
-	{sbc5, pll_p, 100000000, 0},
-	{sbc6, pll_p, 100000000, 0},
-	{host1x, pll_c, 150000000, 0},
-	{disp1, pll_p, 600000000, 0},
-	{disp2, pll_p, 600000000, 0},
-	{twd, clk_max, 0, 1},
-	{gr2d, pll_c, 300000000, 0},
-	{gr3d, pll_c, 300000000, 0},
-	{clk_max, clk_max, 0, 0}, /* This MUST be the last entry. */
+	{TEGRA30_CLK_UARTA, TEGRA30_CLK_PLL_P, 408000000, 0},
+	{TEGRA30_CLK_UARTB, TEGRA30_CLK_PLL_P, 408000000, 0},
+	{TEGRA30_CLK_UARTC, TEGRA30_CLK_PLL_P, 408000000, 0},
+	{TEGRA30_CLK_UARTD, TEGRA30_CLK_PLL_P, 408000000, 0},
+	{TEGRA30_CLK_UARTE, TEGRA30_CLK_PLL_P, 408000000, 0},
+	{TEGRA30_CLK_PLL_A, TEGRA30_CLK_CLK_MAX, 564480000, 1},
+	{TEGRA30_CLK_PLL_A_OUT0, TEGRA30_CLK_CLK_MAX, 11289600, 1},
+	{TEGRA30_CLK_EXTERN1, TEGRA30_CLK_PLL_A_OUT0, 0, 1},
+	{TEGRA30_CLK_CLK_OUT_1_MUX, TEGRA30_CLK_EXTERN1, 0, 0},
+	{TEGRA30_CLK_CLK_OUT_1, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_BLINK, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_I2S0, TEGRA30_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA30_CLK_I2S1, TEGRA30_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA30_CLK_I2S2, TEGRA30_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA30_CLK_I2S3, TEGRA30_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA30_CLK_I2S4, TEGRA30_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA30_CLK_SDMMC1, TEGRA30_CLK_PLL_P, 48000000, 0},
+	{TEGRA30_CLK_SDMMC2, TEGRA30_CLK_PLL_P, 48000000, 0},
+	{TEGRA30_CLK_SDMMC3, TEGRA30_CLK_PLL_P, 48000000, 0},
+	{TEGRA30_CLK_PLL_M, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_PCLK, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_CSITE, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_EMC, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_MSELECT, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_SBC1, TEGRA30_CLK_PLL_P, 100000000, 0},
+	{TEGRA30_CLK_SBC2, TEGRA30_CLK_PLL_P, 100000000, 0},
+	{TEGRA30_CLK_SBC3, TEGRA30_CLK_PLL_P, 100000000, 0},
+	{TEGRA30_CLK_SBC4, TEGRA30_CLK_PLL_P, 100000000, 0},
+	{TEGRA30_CLK_SBC5, TEGRA30_CLK_PLL_P, 100000000, 0},
+	{TEGRA30_CLK_SBC6, TEGRA30_CLK_PLL_P, 100000000, 0},
+	{TEGRA30_CLK_HOST1X, TEGRA30_CLK_PLL_C, 150000000, 0},
+	{TEGRA30_CLK_DISP1, TEGRA30_CLK_PLL_P, 600000000, 0},
+	{TEGRA30_CLK_DISP2, TEGRA30_CLK_PLL_P, 600000000, 0},
+	{TEGRA30_CLK_TWD, TEGRA30_CLK_CLK_MAX, 0, 1},
+	{TEGRA30_CLK_GR2D, TEGRA30_CLK_PLL_C, 300000000, 0},
+	{TEGRA30_CLK_GR3D, TEGRA30_CLK_PLL_C, 300000000, 0},
+	{TEGRA30_CLK_CLK_MAX, TEGRA30_CLK_CLK_MAX, 0, 0}, /* This MUST be the last entry. */
 };
 
 static void __init tegra30_clock_apply_init_table(void)
 {
-	tegra_init_from_table(init_table, clks, clk_max);
+	tegra_init_from_table(init_table, clks, TEGRA30_CLK_CLK_MAX);
 }
 
 /*
@@ -1878,19 +1391,19 @@ static void __init tegra30_clock_apply_init_table(void)
  * table under two names.
  */
 static struct tegra_clk_duplicate tegra_clk_duplicates[] = {
-	TEGRA_CLK_DUPLICATE(usbd, "utmip-pad", NULL),
-	TEGRA_CLK_DUPLICATE(usbd, "tegra-ehci.0", NULL),
-	TEGRA_CLK_DUPLICATE(usbd, "tegra-otg", NULL),
-	TEGRA_CLK_DUPLICATE(bsev, "tegra-avp", "bsev"),
-	TEGRA_CLK_DUPLICATE(bsev, "nvavp", "bsev"),
-	TEGRA_CLK_DUPLICATE(vde, "tegra-aes", "vde"),
-	TEGRA_CLK_DUPLICATE(bsea, "tegra-aes", "bsea"),
-	TEGRA_CLK_DUPLICATE(bsea, "nvavp", "bsea"),
-	TEGRA_CLK_DUPLICATE(cml1, "tegra_sata_cml", NULL),
-	TEGRA_CLK_DUPLICATE(cml0, "tegra_pcie", "cml"),
-	TEGRA_CLK_DUPLICATE(pciex, "tegra_pcie", "pciex"),
-	TEGRA_CLK_DUPLICATE(vcp, "nvavp", "vcp"),
-	TEGRA_CLK_DUPLICATE(clk_max, NULL, NULL), /* MUST be the last entry */
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_USBD, "utmip-pad", NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_USBD, "tegra-ehci.0", NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_USBD, "tegra-otg", NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_BSEV, "tegra-avp", "bsev"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_BSEV, "nvavp", "bsev"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_VDE, "tegra-aes", "vde"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_BSEA, "tegra-aes", "bsea"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_BSEA, "nvavp", "bsea"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_CML1, "tegra_sata_cml", NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_CML0, "tegra_pcie", "cml"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_PCIEX, "tegra_pcie", "pciex"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_VCP, "nvavp", "vcp"),
+	TEGRA_CLK_DUPLICATE(TEGRA30_CLK_CLK_MAX, NULL, NULL), /* MUST be the last entry */
 };
 
 static const struct of_device_id pmc_match[] __initconst = {
@@ -1920,21 +1433,26 @@ static void __init tegra30_clock_init(struct device_node *np)
 		BUG();
 	}
 
-	clks = tegra_clk_init(clk_max, TEGRA30_CLK_PERIPH_BANKS);
+	clks = tegra_clk_init(TEGRA30_CLK_CLK_MAX, TEGRA30_CLK_PERIPH_BANKS);
 	if (!clks)
 		return;
 
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
 
-	tegra_init_dup_clks(tegra_clk_duplicates, clks, clk_max);
+	tegra_init_dup_clks(tegra_clk_duplicates, clks, TEGRA30_CLK_CLK_MAX);
 
 	tegra_add_of_provider(np);
+	tegra_register_devclks(devclks, ARRAY_SIZE(devclks));
 
 	tegra_clk_apply_init_table = tegra30_clock_apply_init_table;
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

