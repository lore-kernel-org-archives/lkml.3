Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab3JOO6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:58:17 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11757 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932953Ab3JOO6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:58:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Oct 2013 07:58:12 -0700
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
Subject: [PATCH v3 17/19] clk: tegra30: move tegra30 to common clkdev
Date: Tue, 15 Oct 2013 17:53:02 +0300
Message-ID: <1381848794-11761-18-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move tegra30 to the common clkdev infrastructure. This will allow making
use of the common tegra clocks.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra30.c |  393 +++++++++++++++++++++++----------------
 1 files changed, 232 insertions(+), 161 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 046df9a..0834eeb 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -243,42 +243,42 @@ static DEFINE_SPINLOCK(cml_lock);
 static DEFINE_SPINLOCK(pll_d_lock);
 static DEFINE_SPINLOCK(sysrate_lock);
 
-#define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
+#define TEGRA_INIT_DATA_MUX(_name, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
+	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, 0, _clk_num,		\
 			_gate_flags, _clk_id)
 
-#define TEGRA_INIT_DATA_DIV16(_name, _con_id, _dev_id, _parents, _offset, \
+#define TEGRA_INIT_DATA_DIV16(_name, _parents, _offset, \
 			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
+	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
 			30, 2, 0, 0, 16, 0, TEGRA_DIVIDER_ROUND_UP,	\
 			_clk_num, \
 			_gate_flags, _clk_id)
 
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
+#define TEGRA_INIT_DATA_UART(_name, _parents, _offset,\
 			     _clk_num, _clk_id)			\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
+	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
 			30, 2, 0, 0, 16, 1, TEGRA_DIVIDER_UART,\
 			_clk_num, 0, _clk_id)
 
-#define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
+#define TEGRA_INIT_DATA_NODIV(_name, _parents, _offset, \
 			      _mux_shift, _mux_width, _clk_num, \
 			      _gate_flags, _clk_id)			\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
+	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
 			_mux_shift, _mux_width, 0, 0, 0, 0, 0,\
 			_clk_num, _gate_flags,	\
 			_clk_id)
@@ -654,6 +654,157 @@ static struct tegra_clk_pll_params pll_e_params = {
 	.fixed_rate = 100000000,
 };
 
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
 static void tegra30_clk_measure_input_freq(void)
 {
 	u32 osc_ctrl = readl_relaxed(clk_base + OSC_CTRL);
@@ -778,7 +929,6 @@ static void __init tegra30_pll_init(void)
 	/* PLLC */
 	clk = tegra_clk_register_pll("pll_c", "pll_ref", clk_base, pmc_base, 0,
 				&pll_c_params, NULL);
-	clk_register_clkdev(clk, "pll_c", NULL);
 	clks[TEGRA30_CLK_PLL_C] = clk;
 
 	/* PLLC_OUT1 */
@@ -788,13 +938,11 @@ static void __init tegra30_pll_init(void)
 	clk = tegra_clk_register_pll_out("pll_c_out1", "pll_c_out1_div",
 				clk_base + PLLC_OUT, 1, 0, CLK_SET_RATE_PARENT,
 				0, NULL);
-	clk_register_clkdev(clk, "pll_c_out1", NULL);
 	clks[TEGRA30_CLK_PLL_C_OUT1] = clk;
 
 	/* PLLP */
 	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, pmc_base, 0,
 				&pll_p_params, NULL);
-	clk_register_clkdev(clk, "pll_p", NULL);
 	clks[TEGRA30_CLK_PLL_P] = clk;
 
 	/* PLLP_OUT1 */
@@ -806,7 +954,6 @@ static void __init tegra30_pll_init(void)
 				clk_base + PLLP_OUTA, 1, 0,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out1", NULL);
 	clks[TEGRA30_CLK_PLL_P_OUT1] = clk;
 
 	/* PLLP_OUT2 */
@@ -818,7 +965,6 @@ static void __init tegra30_pll_init(void)
 				clk_base + PLLP_OUTA, 17, 16,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out2", NULL);
 	clks[TEGRA30_CLK_PLL_P_OUT2] = clk;
 
 	/* PLLP_OUT3 */
@@ -830,7 +976,6 @@ static void __init tegra30_pll_init(void)
 				clk_base + PLLP_OUTB, 1, 0,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out3", NULL);
 	clks[TEGRA30_CLK_PLL_P_OUT3] = clk;
 
 	/* PLLP_OUT4 */
@@ -842,14 +987,12 @@ static void __init tegra30_pll_init(void)
 				clk_base + PLLP_OUTB, 17, 16,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out4", NULL);
 	clks[TEGRA30_CLK_PLL_P_OUT4] = clk;
 
 	/* PLLM */
 	clk = tegra_clk_register_pll("pll_m", "pll_ref", clk_base, pmc_base,
 			    CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE,
 			    &pll_m_params, NULL);
-	clk_register_clkdev(clk, "pll_m", NULL);
 	clks[TEGRA30_CLK_PLL_M] = clk;
 
 	/* PLLM_OUT1 */
@@ -859,25 +1002,21 @@ static void __init tegra30_pll_init(void)
 	clk = tegra_clk_register_pll_out("pll_m_out1", "pll_m_out1_div",
 				clk_base + PLLM_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
-	clk_register_clkdev(clk, "pll_m_out1", NULL);
 	clks[TEGRA30_CLK_PLL_M_OUT1] = clk;
 
 	/* PLLX */
 	clk = tegra_clk_register_pll("pll_x", "pll_ref", clk_base, pmc_base, 0,
 			    &pll_x_params, NULL);
-	clk_register_clkdev(clk, "pll_x", NULL);
 	clks[TEGRA30_CLK_PLL_X] = clk;
 
 	/* PLLX_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_x_out0", "pll_x",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "pll_x_out0", NULL);
 	clks[TEGRA30_CLK_PLL_X_OUT0] = clk;
 
 	/* PLLU */
 	clk = tegra_clk_register_pll("pll_u", "pll_ref", clk_base, pmc_base, 0,
 			    &pll_u_params, NULL);
-	clk_register_clkdev(clk, "pll_u", NULL);
 	clks[TEGRA30_CLK_PLL_U] = clk;
 
 	tegra30_utmi_param_configure();
@@ -885,31 +1024,26 @@ static void __init tegra30_pll_init(void)
 	/* PLLD */
 	clk = tegra_clk_register_pll("pll_d", "pll_ref", clk_base, pmc_base, 0,
 			    &pll_d_params, &pll_d_lock);
-	clk_register_clkdev(clk, "pll_d", NULL);
 	clks[TEGRA30_CLK_PLL_D] = clk;
 
 	/* PLLD_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d_out0", "pll_d",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "pll_d_out0", NULL);
 	clks[TEGRA30_CLK_PLL_D_OUT0] = clk;
 
 	/* PLLD2 */
 	clk = tegra_clk_register_pll("pll_d2", "pll_ref", clk_base, pmc_base, 0,
 			    &pll_d2_params, NULL);
-	clk_register_clkdev(clk, "pll_d2", NULL);
 	clks[TEGRA30_CLK_PLL_D2] = clk;
 
 	/* PLLD2_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d2_out0", "pll_d2",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "pll_d2_out0", NULL);
 	clks[TEGRA30_CLK_PLL_D2_OUT0] = clk;
 
 	/* PLLA */
 	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, pmc_base,
 			    0, &pll_a_params, NULL);
-	clk_register_clkdev(clk, "pll_a", NULL);
 	clks[TEGRA30_CLK_PLL_A] = clk;
 
 	/* PLLA_OUT0 */
@@ -919,7 +1053,6 @@ static void __init tegra30_pll_init(void)
 	clk = tegra_clk_register_pll_out("pll_a_out0", "pll_a_out0_div",
 				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
-	clk_register_clkdev(clk, "pll_a_out0", NULL);
 	clks[TEGRA30_CLK_PLL_A_OUT0] = clk;
 
 	/* PLLE */
@@ -929,7 +1062,6 @@ static void __init tegra30_pll_init(void)
 			       clk_base + PLLE_AUX, 2, 1, 0, NULL);
 	clk = tegra_clk_register_plle("pll_e", "pll_e_mux", clk_base, pmc_base,
 			     CLK_GET_RATE_NOCACHE, &pll_e_params, NULL);
-	clk_register_clkdev(clk, "pll_e", NULL);
 	clks[TEGRA30_CLK_PLL_E] = clk;
 }
 
@@ -949,37 +1081,30 @@ static void __init tegra30_audio_clk_init(void)
 	/* spdif_in_sync */
 	clk = tegra_clk_register_sync_source("spdif_in_sync", 24000000,
 					     24000000);
-	clk_register_clkdev(clk, "spdif_in_sync", NULL);
 	clks[TEGRA30_CLK_SPDIF_IN_SYNC] = clk;
 
 	/* i2s0_sync */
 	clk = tegra_clk_register_sync_source("i2s0_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s0_sync", NULL);
 	clks[TEGRA30_CLK_I2S0_SYNC] = clk;
 
 	/* i2s1_sync */
 	clk = tegra_clk_register_sync_source("i2s1_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s1_sync", NULL);
 	clks[TEGRA30_CLK_I2S1_SYNC] = clk;
 
 	/* i2s2_sync */
 	clk = tegra_clk_register_sync_source("i2s2_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s2_sync", NULL);
 	clks[TEGRA30_CLK_I2S2_SYNC] = clk;
 
 	/* i2s3_sync */
 	clk = tegra_clk_register_sync_source("i2s3_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s3_sync", NULL);
 	clks[TEGRA30_CLK_I2S3_SYNC] = clk;
 
 	/* i2s4_sync */
 	clk = tegra_clk_register_sync_source("i2s4_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s4_sync", NULL);
 	clks[TEGRA30_CLK_I2S4_SYNC] = clk;
 
 	/* vimclk_sync */
 	clk = tegra_clk_register_sync_source("vimclk_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "vimclk_sync", NULL);
 	clks[TEGRA30_CLK_VIMCLK_SYNC] = clk;
 
 	/* audio0 */
@@ -990,7 +1115,6 @@ static void __init tegra30_audio_clk_init(void)
 	clk = clk_register_gate(NULL, "audio0", "audio0_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S0, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio0", NULL);
 	clks[TEGRA30_CLK_AUDIO0] = clk;
 
 	/* audio1 */
@@ -1001,7 +1125,6 @@ static void __init tegra30_audio_clk_init(void)
 	clk = clk_register_gate(NULL, "audio1", "audio1_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S1, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio1", NULL);
 	clks[TEGRA30_CLK_AUDIO1] = clk;
 
 	/* audio2 */
@@ -1012,7 +1135,6 @@ static void __init tegra30_audio_clk_init(void)
 	clk = clk_register_gate(NULL, "audio2", "audio2_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S2, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio2", NULL);
 	clks[TEGRA30_CLK_AUDIO2] = clk;
 
 	/* audio3 */
@@ -1023,7 +1145,6 @@ static void __init tegra30_audio_clk_init(void)
 	clk = clk_register_gate(NULL, "audio3", "audio3_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S3, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio3", NULL);
 	clks[TEGRA30_CLK_AUDIO3] = clk;
 
 	/* audio4 */
@@ -1034,7 +1155,6 @@ static void __init tegra30_audio_clk_init(void)
 	clk = clk_register_gate(NULL, "audio4", "audio4_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S4, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio4", NULL);
 	clks[TEGRA30_CLK_AUDIO4] = clk;
 
 	/* spdif */
@@ -1045,7 +1165,6 @@ static void __init tegra30_audio_clk_init(void)
 	clk = clk_register_gate(NULL, "spdif", "spdif_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_SPDIF, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "spdif", NULL);
 	clks[TEGRA30_CLK_SPDIF] = clk;
 
 	/* audio0_2x */
@@ -1058,7 +1177,6 @@ static void __init tegra30_audio_clk_init(void)
 				    TEGRA_PERIPH_NO_RESET, clk_base,
 				    CLK_SET_RATE_PARENT, 113,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio0_2x", NULL);
 	clks[TEGRA30_CLK_AUDIO0_2X] = clk;
 
 	/* audio1_2x */
@@ -1071,7 +1189,6 @@ static void __init tegra30_audio_clk_init(void)
 				    TEGRA_PERIPH_NO_RESET, clk_base,
 				    CLK_SET_RATE_PARENT, 114,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio1_2x", NULL);
 	clks[TEGRA30_CLK_AUDIO1_2X] = clk;
 
 	/* audio2_2x */
@@ -1084,7 +1201,6 @@ static void __init tegra30_audio_clk_init(void)
 				    TEGRA_PERIPH_NO_RESET, clk_base,
 				    CLK_SET_RATE_PARENT, 115,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio2_2x", NULL);
 	clks[TEGRA30_CLK_AUDIO2_2X] = clk;
 
 	/* audio3_2x */
@@ -1097,7 +1213,6 @@ static void __init tegra30_audio_clk_init(void)
 				    TEGRA_PERIPH_NO_RESET, clk_base,
 				    CLK_SET_RATE_PARENT, 116,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio3_2x", NULL);
 	clks[TEGRA30_CLK_AUDIO3_2X] = clk;
 
 	/* audio4_2x */
@@ -1110,7 +1225,6 @@ static void __init tegra30_audio_clk_init(void)
 				    TEGRA_PERIPH_NO_RESET, clk_base,
 				    CLK_SET_RATE_PARENT, 117,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio4_2x", NULL);
 	clks[TEGRA30_CLK_AUDIO4_2X] = clk;
 
 	/* spdif_2x */
@@ -1123,7 +1237,6 @@ static void __init tegra30_audio_clk_init(void)
 				    TEGRA_PERIPH_NO_RESET, clk_base,
 				    CLK_SET_RATE_PARENT, 118,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "spdif_2x", NULL);
 	clks[TEGRA30_CLK_SPDIF_2X] = clk;
 }
 
@@ -1141,7 +1254,6 @@ static void __init tegra30_pmc_clk_init(void)
 	clk = clk_register_gate(NULL, "clk_out_1", "clk_out_1_mux", 0,
 				pmc_base + PMC_CLK_OUT_CNTRL, 2, 0,
 				&clk_out_lock);
-	clk_register_clkdev(clk, "extern1", "clk_out_1");
 	clks[TEGRA30_CLK_CLK_OUT_1] = clk;
 
 	/* clk_out_2 */
@@ -1153,7 +1265,6 @@ static void __init tegra30_pmc_clk_init(void)
 	clk = clk_register_gate(NULL, "clk_out_2", "clk_out_2_mux", 0,
 				pmc_base + PMC_CLK_OUT_CNTRL, 10, 0,
 				&clk_out_lock);
-	clk_register_clkdev(clk, "extern2", "clk_out_2");
 	clks[TEGRA30_CLK_CLK_OUT_2] = clk;
 
 	/* clk_out_3 */
@@ -1165,7 +1276,6 @@ static void __init tegra30_pmc_clk_init(void)
 	clk = clk_register_gate(NULL, "clk_out_3", "clk_out_3_mux", 0,
 				pmc_base + PMC_CLK_OUT_CNTRL, 18, 0,
 				&clk_out_lock);
-	clk_register_clkdev(clk, "extern3", "clk_out_3");
 	clks[TEGRA30_CLK_CLK_OUT_3] = clk;
 
 	/* blink */
@@ -1176,7 +1286,6 @@ static void __init tegra30_pmc_clk_init(void)
 	clk = clk_register_gate(NULL, "blink", "blink_override", 0,
 				pmc_base + PMC_CTRL,
 				PMC_CTRL_BLINK_ENB, 0, NULL);
-	clk_register_clkdev(clk, "blink", NULL);
 	clks[TEGRA30_CLK_BLINK] = clk;
 
 }
@@ -1229,7 +1338,6 @@ static void __init tegra30_super_clk_init(void)
 				  CLK_SET_RATE_PARENT,
 				  clk_base + CCLKG_BURST_POLICY,
 				  0, 4, 0, 0, NULL);
-	clk_register_clkdev(clk, "cclk_g", NULL);
 	clks[TEGRA30_CLK_CCLK_G] = clk;
 
 	/*
@@ -1266,7 +1374,6 @@ static void __init tegra30_super_clk_init(void)
 				  clk_base + CCLKLP_BURST_POLICY,
 				  TEGRA_DIVIDER_2, 4, 8, 9,
 			      NULL);
-	clk_register_clkdev(clk, "cclk_lp", NULL);
 	clks[TEGRA30_CLK_CCLK_LP] = clk;
 
 	/* SCLK */
@@ -1275,7 +1382,6 @@ static void __init tegra30_super_clk_init(void)
 				  CLK_SET_RATE_PARENT,
 				  clk_base + SCLK_BURST_POLICY,
 				  0, 4, 0, 0, NULL);
-	clk_register_clkdev(clk, "sclk", NULL);
 	clks[TEGRA30_CLK_SCLK] = clk;
 
 	/* HCLK */
@@ -1285,7 +1391,6 @@ static void __init tegra30_super_clk_init(void)
 	clk = clk_register_gate(NULL, "hclk", "hclk_div", CLK_SET_RATE_PARENT,
 				clk_base + SYSTEM_CLK_RATE, 7,
 				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clk_register_clkdev(clk, "hclk", NULL);
 	clks[TEGRA30_CLK_HCLK] = clk;
 
 	/* PCLK */
@@ -1295,13 +1400,11 @@ static void __init tegra30_super_clk_init(void)
 	clk = clk_register_gate(NULL, "pclk", "pclk_div", CLK_SET_RATE_PARENT,
 				clk_base + SYSTEM_CLK_RATE, 3,
 				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clk_register_clkdev(clk, "pclk", NULL);
 	clks[TEGRA30_CLK_PCLK] = clk;
 
 	/* twd */
 	clk = clk_register_fixed_factor(NULL, "twd", "cclk_g",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "twd", NULL);
 	clks[TEGRA30_CLK_TWD] = clk;
 }
 
@@ -1340,77 +1443,77 @@ static const char *mux_plld_out0_plld2_out0[] = { "pll_d_out0",
 						  "pll_d2_out0" };
 
 static struct tegra_periph_init_data tegra_periph_clk_list[] = {
-	TEGRA_INIT_DATA_MUX("i2s0",	NULL,		"tegra30-i2s.0",	i2s0_parents,		CLK_SOURCE_I2S0,	30,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S0),
-	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra30-i2s.1",	i2s1_parents,		CLK_SOURCE_I2S1,	11,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S1),
-	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra30-i2s.2",	i2s2_parents,		CLK_SOURCE_I2S2,	18,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S2),
-	TEGRA_INIT_DATA_MUX("i2s3",	NULL,		"tegra30-i2s.3",	i2s3_parents,		CLK_SOURCE_I2S3,	101,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S3),
-	TEGRA_INIT_DATA_MUX("i2s4",	NULL,		"tegra30-i2s.4",	i2s4_parents,		CLK_SOURCE_I2S4,	102,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S4),
-	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra30-spdif",	spdif_out_parents,	CLK_SOURCE_SPDIF_OUT,	10,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SPDIF_OUT),
-	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra30-spdif",	spdif_in_parents,	CLK_SOURCE_SPDIF_IN,	10,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SPDIF_IN),
-	TEGRA_INIT_DATA_MUX("d_audio",	"d_audio",	"tegra30-ahub",		mux_pllacp_clkm,	CLK_SOURCE_D_AUDIO,	106,	0, TEGRA30_CLK_D_AUDIO),
-	TEGRA_INIT_DATA_MUX("dam0",	NULL,		"tegra30-dam.0",	mux_pllacp_clkm,	CLK_SOURCE_DAM0,	108,	0, TEGRA30_CLK_DAM0),
-	TEGRA_INIT_DATA_MUX("dam1",	NULL,		"tegra30-dam.1",	mux_pllacp_clkm,	CLK_SOURCE_DAM1,	109,	0, TEGRA30_CLK_DAM1),
-	TEGRA_INIT_DATA_MUX("dam2",	NULL,		"tegra30-dam.2",	mux_pllacp_clkm,	CLK_SOURCE_DAM2,	110,	0, TEGRA30_CLK_DAM2),
-	TEGRA_INIT_DATA_MUX("hda",	"hda",		"tegra30-hda",		mux_pllpcm_clkm,	CLK_SOURCE_HDA,		125,	0, TEGRA30_CLK_HDA),
-	TEGRA_INIT_DATA_MUX("hda2codec_2x", "hda2codec", "tegra30-hda",		mux_pllpcm_clkm,	CLK_SOURCE_HDA2CODEC_2X, 111,	0, TEGRA30_CLK_HDA2CODEC_2X),
-	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",		mux_pllpcm_clkm,	CLK_SOURCE_SBC1,	41,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC1),
-	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",		mux_pllpcm_clkm,	CLK_SOURCE_SBC2,	44,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC2),
-	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",		mux_pllpcm_clkm,	CLK_SOURCE_SBC3,	46,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC3),
-	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",		mux_pllpcm_clkm,	CLK_SOURCE_SBC4,	68,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC4),
-	TEGRA_INIT_DATA_MUX("sbc5",	NULL,		"spi_tegra.4",		mux_pllpcm_clkm,	CLK_SOURCE_SBC5,	104,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC5),
-	TEGRA_INIT_DATA_MUX("sbc6",	NULL,		"spi_tegra.5",		mux_pllpcm_clkm,	CLK_SOURCE_SBC6,	105,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC6),
-	TEGRA_INIT_DATA_MUX("sata_oob",	NULL,		"tegra_sata_oob",	mux_pllpcm_clkm,	CLK_SOURCE_SATA_OOB,	123,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SATA_OOB),
-	TEGRA_INIT_DATA_MUX("sata",	NULL,		"tegra_sata",		mux_pllpcm_clkm,	CLK_SOURCE_SATA,	124,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SATA),
-	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",		mux_pllpcm_clkm,	CLK_SOURCE_NDFLASH,	13,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_NDFLASH),
-	TEGRA_INIT_DATA_MUX("ndspeed",	NULL,		"tegra_nand_speed",	mux_pllpcm_clkm,	CLK_SOURCE_NDSPEED,	80,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_NDSPEED),
-	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",			mux_pllpcm_clkm,	CLK_SOURCE_VFIR,	7,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_VFIR),
-	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",		mux_pllpcm_clkm,	CLK_SOURCE_CSITE,	73,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_CSITE),
-	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",			mux_pllpcm_clkm,	CLK_SOURCE_LA,		76,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_LA),
-	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",		mux_pllpcm_clkm,	CLK_SOURCE_OWR,		71,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_OWR),
-	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",			mux_pllpcm_clkm,	CLK_SOURCE_MIPI,	50,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_MIPI),
-	TEGRA_INIT_DATA_MUX("tsensor",	NULL,		"tegra-tsensor",	mux_pllpc_clkm_clk32k,	CLK_SOURCE_TSENSOR,	100,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_TSENSOR),
-	TEGRA_INIT_DATA_MUX("i2cslow",	NULL,		"i2cslow",		mux_pllpc_clk32k_clkm,	CLK_SOURCE_I2CSLOW,	81,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2CSLOW),
-	TEGRA_INIT_DATA_INT("vde",	NULL,		"vde",			mux_pllpcm_clkm,	CLK_SOURCE_VDE,		61,	0, TEGRA30_CLK_VDE),
-	TEGRA_INIT_DATA_INT("vi",	"vi",		"tegra_camera",		mux_pllmcpa,		CLK_SOURCE_VI,		20,	0, TEGRA30_CLK_VI),
-	TEGRA_INIT_DATA_INT("epp",	NULL,		"epp",			mux_pllmcpa,		CLK_SOURCE_EPP,		19,	0, TEGRA30_CLK_EPP),
-	TEGRA_INIT_DATA_INT("mpe",	NULL,		"mpe",			mux_pllmcpa,		CLK_SOURCE_MPE,		60,	0, TEGRA30_CLK_MPE),
-	TEGRA_INIT_DATA_INT("host1x",	NULL,		"host1x",		mux_pllmcpa,		CLK_SOURCE_HOST1X,	28,	0, TEGRA30_CLK_HOST1X),
-	TEGRA_INIT_DATA_INT("3d",	NULL,		"3d",			mux_pllmcpa,		CLK_SOURCE_3D,		24,	TEGRA_PERIPH_MANUAL_RESET, TEGRA30_CLK_GR3D),
-	TEGRA_INIT_DATA_INT("3d2",	NULL,		"3d2",			mux_pllmcpa,		CLK_SOURCE_3D2,		98,	TEGRA_PERIPH_MANUAL_RESET, TEGRA30_CLK_GR3D2),
-	TEGRA_INIT_DATA_INT("2d",	NULL,		"2d",			mux_pllmcpa,		CLK_SOURCE_2D,		21,	0, TEGRA30_CLK_GR2D),
-	TEGRA_INIT_DATA_INT("se",	NULL,		"se",			mux_pllpcm_clkm,	CLK_SOURCE_SE,		127,	0, TEGRA30_CLK_SE),
-	TEGRA_INIT_DATA_MUX("mselect",	NULL,		"mselect",		mux_pllp_clkm,		CLK_SOURCE_MSELECT,	99,	0, TEGRA30_CLK_MSELECT),
-	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",		mux_pllpcm_clkm,	CLK_SOURCE_NOR,		42,	0, TEGRA30_CLK_NOR),
-	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC1,	14,	0, TEGRA30_CLK_SDMMC1),
-	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC2,	9,	0, TEGRA30_CLK_SDMMC2),
-	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC3,	69,	0, TEGRA30_CLK_SDMMC3),
-	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC4,	15,	0, TEGRA30_CLK_SDMMC4),
-	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",			mux_pllpdc_clkm,	CLK_SOURCE_CVE,		49,	0, TEGRA30_CLK_CVE),
-	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",			mux_pllpdc_clkm,	CLK_SOURCE_TVO,		49,	0, TEGRA30_CLK_TVO),
-	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",		mux_pllpdc_clkm,	CLK_SOURCE_TVDAC,	53,	0, TEGRA30_CLK_TVDAC),
-	TEGRA_INIT_DATA_MUX("actmon",	NULL,		"actmon",		mux_pllpc_clk32k_clkm,	CLK_SOURCE_ACTMON,	119,	0, TEGRA30_CLK_ACTMON),
-	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",		mux_pllmcpa,		CLK_SOURCE_VI_SENSOR,	20,	TEGRA_PERIPH_NO_RESET, TEGRA30_CLK_VI_SENSOR),
-	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",		mux_pllp_clkm,		CLK_SOURCE_I2C1,	12,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C1),
-	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",		mux_pllp_clkm,		CLK_SOURCE_I2C2,	54,	TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C2),
-	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",		mux_pllp_clkm,		CLK_SOURCE_I2C3,	67,		TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C3),
-	TEGRA_INIT_DATA_DIV16("i2c4",	"div-clk",	"tegra-i2c.3",		mux_pllp_clkm,		CLK_SOURCE_I2C4,	103,		TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C4),
-	TEGRA_INIT_DATA_DIV16("i2c5",	"div-clk",	"tegra-i2c.4",		mux_pllp_clkm,		CLK_SOURCE_I2C5,	47,		TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C5),
-	TEGRA_INIT_DATA_UART("uarta",	NULL,		"tegra_uart.0",		mux_pllpcm_clkm,	CLK_SOURCE_UARTA,	6,	TEGRA30_CLK_UARTA),
-	TEGRA_INIT_DATA_UART("uartb",	NULL,		"tegra_uart.1",		mux_pllpcm_clkm,	CLK_SOURCE_UARTB,	7,	TEGRA30_CLK_UARTB),
-	TEGRA_INIT_DATA_UART("uartc",	NULL,		"tegra_uart.2",		mux_pllpcm_clkm,	CLK_SOURCE_UARTC,	55,	TEGRA30_CLK_UARTC),
-	TEGRA_INIT_DATA_UART("uartd",	NULL,		"tegra_uart.3",		mux_pllpcm_clkm,	CLK_SOURCE_UARTD,	65,	TEGRA30_CLK_UARTD),
-	TEGRA_INIT_DATA_UART("uarte",	NULL,		"tegra_uart.4",		mux_pllpcm_clkm,	CLK_SOURCE_UARTE,	66,	TEGRA30_CLK_UARTE),
-	TEGRA_INIT_DATA_MUX8("hdmi",	NULL,		"hdmi",			mux_pllpmdacd2_clkm,	CLK_SOURCE_HDMI,	51,		0, TEGRA30_CLK_HDMI),
-	TEGRA_INIT_DATA_MUX8("extern1",	NULL,		"extern1",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN1,	120,		0, TEGRA30_CLK_EXTERN1),
-	TEGRA_INIT_DATA_MUX8("extern2",	NULL,		"extern2",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN2,	121,		0, TEGRA30_CLK_EXTERN2),
-	TEGRA_INIT_DATA_MUX8("extern3",	NULL,		"extern3",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN3,	122,		0, TEGRA30_CLK_EXTERN3),
-	TEGRA_INIT_DATA("pwm",		NULL,		"pwm",			mux_pllpc_clk32k_clkm,	CLK_SOURCE_PWM,		28, 2, 0, 0, 8, 1, 0, 17, 0, TEGRA30_CLK_PWM),
+	TEGRA_INIT_DATA_MUX("i2s0", i2s0_parents, CLK_SOURCE_I2S0, 30, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S0),
+	TEGRA_INIT_DATA_MUX("i2s1", i2s1_parents, CLK_SOURCE_I2S1, 11, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S1),
+	TEGRA_INIT_DATA_MUX("i2s2", i2s2_parents, CLK_SOURCE_I2S2, 18, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S2),
+	TEGRA_INIT_DATA_MUX("i2s3", i2s3_parents, CLK_SOURCE_I2S3, 101, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S3),
+	TEGRA_INIT_DATA_MUX("i2s4", i2s4_parents, CLK_SOURCE_I2S4, 102, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2S4),
+	TEGRA_INIT_DATA_MUX("spdif_out", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SPDIF_OUT),
+	TEGRA_INIT_DATA_MUX("spdif_in", spdif_in_parents, CLK_SOURCE_SPDIF_IN, 10, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SPDIF_IN),
+	TEGRA_INIT_DATA_MUX("d_audio", mux_pllacp_clkm, CLK_SOURCE_D_AUDIO, 106, 0, TEGRA30_CLK_D_AUDIO),
+	TEGRA_INIT_DATA_MUX("dam0", mux_pllacp_clkm, CLK_SOURCE_DAM0, 108, 0, TEGRA30_CLK_DAM0),
+	TEGRA_INIT_DATA_MUX("dam1", mux_pllacp_clkm, CLK_SOURCE_DAM1, 109, 0, TEGRA30_CLK_DAM1),
+	TEGRA_INIT_DATA_MUX("dam2", mux_pllacp_clkm, CLK_SOURCE_DAM2, 110, 0, TEGRA30_CLK_DAM2),
+	TEGRA_INIT_DATA_MUX("hda", mux_pllpcm_clkm, CLK_SOURCE_HDA, 125, 0, TEGRA30_CLK_HDA),
+	TEGRA_INIT_DATA_MUX("hda2codec_2x", mux_pllpcm_clkm, CLK_SOURCE_HDA2CODEC_2X, 111, 0, TEGRA30_CLK_HDA2CODEC_2X),
+	TEGRA_INIT_DATA_MUX("sbc1", mux_pllpcm_clkm, CLK_SOURCE_SBC1, 41, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC1),
+	TEGRA_INIT_DATA_MUX("sbc2", mux_pllpcm_clkm, CLK_SOURCE_SBC2, 44, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC2),
+	TEGRA_INIT_DATA_MUX("sbc3", mux_pllpcm_clkm, CLK_SOURCE_SBC3, 46, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC3),
+	TEGRA_INIT_DATA_MUX("sbc4", mux_pllpcm_clkm, CLK_SOURCE_SBC4, 68, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC4),
+	TEGRA_INIT_DATA_MUX("sbc5", mux_pllpcm_clkm, CLK_SOURCE_SBC5, 104, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC5),
+	TEGRA_INIT_DATA_MUX("sbc6", mux_pllpcm_clkm, CLK_SOURCE_SBC6, 105, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SBC6),
+	TEGRA_INIT_DATA_MUX("sata_oob", mux_pllpcm_clkm, CLK_SOURCE_SATA_OOB, 123, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SATA_OOB),
+	TEGRA_INIT_DATA_MUX("sata", mux_pllpcm_clkm, CLK_SOURCE_SATA, 124, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SATA),
+	TEGRA_INIT_DATA_MUX("ndflash", mux_pllpcm_clkm, CLK_SOURCE_NDFLASH, 13, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_NDFLASH),
+	TEGRA_INIT_DATA_MUX("ndspeed", mux_pllpcm_clkm, CLK_SOURCE_NDSPEED, 80, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_NDSPEED),
+	TEGRA_INIT_DATA_MUX("vfir", mux_pllpcm_clkm, CLK_SOURCE_VFIR, 7, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_VFIR),
+	TEGRA_INIT_DATA_MUX("csite", mux_pllpcm_clkm, CLK_SOURCE_CSITE, 73, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_CSITE),
+	TEGRA_INIT_DATA_MUX("la", mux_pllpcm_clkm, CLK_SOURCE_LA, 76, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_LA),
+	TEGRA_INIT_DATA_MUX("owr", mux_pllpcm_clkm, CLK_SOURCE_OWR, 71, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_OWR),
+	TEGRA_INIT_DATA_MUX("mipi", mux_pllpcm_clkm, CLK_SOURCE_MIPI, 50, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_MIPI),
+	TEGRA_INIT_DATA_MUX("tsensor", mux_pllpc_clkm_clk32k, CLK_SOURCE_TSENSOR, 100, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_TSENSOR),
+	TEGRA_INIT_DATA_MUX("i2cslow", mux_pllpc_clk32k_clkm, CLK_SOURCE_I2CSLOW, 81, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2CSLOW),
+	TEGRA_INIT_DATA_INT("vde", mux_pllpcm_clkm, CLK_SOURCE_VDE, 61, 0, TEGRA30_CLK_VDE),
+	TEGRA_INIT_DATA_INT("vi", mux_pllmcpa, CLK_SOURCE_VI, 20, 0, TEGRA30_CLK_VI),
+	TEGRA_INIT_DATA_INT("epp", mux_pllmcpa, CLK_SOURCE_EPP, 19, 0, TEGRA30_CLK_EPP),
+	TEGRA_INIT_DATA_INT("mpe", mux_pllmcpa, CLK_SOURCE_MPE, 60, 0, TEGRA30_CLK_MPE),
+	TEGRA_INIT_DATA_INT("host1x", mux_pllmcpa, CLK_SOURCE_HOST1X, 28, 0, TEGRA30_CLK_HOST1X),
+	TEGRA_INIT_DATA_INT("3d", mux_pllmcpa, CLK_SOURCE_3D, 24, TEGRA_PERIPH_MANUAL_RESET, TEGRA30_CLK_GR3D),
+	TEGRA_INIT_DATA_INT("3d2", mux_pllmcpa, CLK_SOURCE_3D2, 98, TEGRA_PERIPH_MANUAL_RESET, TEGRA30_CLK_GR3D2),
+	TEGRA_INIT_DATA_INT("2d", mux_pllmcpa, CLK_SOURCE_2D, 21, 0, TEGRA30_CLK_GR2D),
+	TEGRA_INIT_DATA_INT("se", mux_pllpcm_clkm, CLK_SOURCE_SE, 127, 0, TEGRA30_CLK_SE),
+	TEGRA_INIT_DATA_MUX("mselect", mux_pllp_clkm, CLK_SOURCE_MSELECT, 99, 0, TEGRA30_CLK_MSELECT),
+	TEGRA_INIT_DATA_MUX("nor", mux_pllpcm_clkm, CLK_SOURCE_NOR, 42, 0, TEGRA30_CLK_NOR),
+	TEGRA_INIT_DATA_MUX("sdmmc1", mux_pllpcm_clkm, CLK_SOURCE_SDMMC1, 14, 0, TEGRA30_CLK_SDMMC1),
+	TEGRA_INIT_DATA_MUX("sdmmc2", mux_pllpcm_clkm, CLK_SOURCE_SDMMC2, 9, 0, TEGRA30_CLK_SDMMC2),
+	TEGRA_INIT_DATA_MUX("sdmmc3", mux_pllpcm_clkm, CLK_SOURCE_SDMMC3, 69, 0, TEGRA30_CLK_SDMMC3),
+	TEGRA_INIT_DATA_MUX("sdmmc4", mux_pllpcm_clkm, CLK_SOURCE_SDMMC4, 15, 0, TEGRA30_CLK_SDMMC4),
+	TEGRA_INIT_DATA_MUX("cve", mux_pllpdc_clkm, CLK_SOURCE_CVE, 49, 0, TEGRA30_CLK_CVE),
+	TEGRA_INIT_DATA_MUX("tvo", mux_pllpdc_clkm, CLK_SOURCE_TVO, 49, 0, TEGRA30_CLK_TVO),
+	TEGRA_INIT_DATA_MUX("tvdac", mux_pllpdc_clkm, CLK_SOURCE_TVDAC, 53, 0, TEGRA30_CLK_TVDAC),
+	TEGRA_INIT_DATA_MUX("actmon", mux_pllpc_clk32k_clkm, CLK_SOURCE_ACTMON, 119, 0, TEGRA30_CLK_ACTMON),
+	TEGRA_INIT_DATA_MUX("vi_sensor", mux_pllmcpa, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, TEGRA30_CLK_VI_SENSOR),
+	TEGRA_INIT_DATA_DIV16("i2c1", mux_pllp_clkm, CLK_SOURCE_I2C1, 12, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C1),
+	TEGRA_INIT_DATA_DIV16("i2c2", mux_pllp_clkm, CLK_SOURCE_I2C2, 54, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C2),
+	TEGRA_INIT_DATA_DIV16("i2c3", mux_pllp_clkm, CLK_SOURCE_I2C3, 67, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C3),
+	TEGRA_INIT_DATA_DIV16("i2c4", mux_pllp_clkm, CLK_SOURCE_I2C4, 103, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C4),
+	TEGRA_INIT_DATA_DIV16("i2c5", mux_pllp_clkm, CLK_SOURCE_I2C5, 47, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_I2C5),
+	TEGRA_INIT_DATA_UART("uarta", mux_pllpcm_clkm, CLK_SOURCE_UARTA, 6, TEGRA30_CLK_UARTA),
+	TEGRA_INIT_DATA_UART("uartb", mux_pllpcm_clkm, CLK_SOURCE_UARTB, 7, TEGRA30_CLK_UARTB),
+	TEGRA_INIT_DATA_UART("uartc", mux_pllpcm_clkm, CLK_SOURCE_UARTC, 55, TEGRA30_CLK_UARTC),
+	TEGRA_INIT_DATA_UART("uartd", mux_pllpcm_clkm, CLK_SOURCE_UARTD, 65, TEGRA30_CLK_UARTD),
+	TEGRA_INIT_DATA_UART("uarte", mux_pllpcm_clkm, CLK_SOURCE_UARTE, 66, TEGRA30_CLK_UARTE),
+	TEGRA_INIT_DATA_MUX8("hdmi", mux_pllpmdacd2_clkm, CLK_SOURCE_HDMI, 51, 0, TEGRA30_CLK_HDMI),
+	TEGRA_INIT_DATA_MUX8("extern1", mux_plla_clk32k_pllp_clkm_plle, CLK_SOURCE_EXTERN1, 120, 0, TEGRA30_CLK_EXTERN1),
+	TEGRA_INIT_DATA_MUX8("extern2", mux_plla_clk32k_pllp_clkm_plle, CLK_SOURCE_EXTERN2, 121, 0, TEGRA30_CLK_EXTERN2),
+	TEGRA_INIT_DATA_MUX8("extern3", mux_plla_clk32k_pllp_clkm_plle, CLK_SOURCE_EXTERN3, 122, 0, TEGRA30_CLK_EXTERN3),
+	TEGRA_INIT_DATA("pwm", NULL, NULL, mux_pllpc_clk32k_clkm, CLK_SOURCE_PWM, 28, 2, 0, 0, 8, 1, 0, 17, 0, TEGRA30_CLK_PWM),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
-	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0", mux_pllpmdacd2_clkm,	     CLK_SOURCE_DISP1,	29, 3, 27, 0, TEGRA30_CLK_DISP1),
-	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1", mux_pllpmdacd2_clkm,      CLK_SOURCE_DISP2,	29, 3, 26, 0, TEGRA30_CLK_DISP2),
-	TEGRA_INIT_DATA_NODIV("dsib",	NULL, "tegradc.1", mux_plld_out0_plld2_out0, CLK_SOURCE_DSIB,	25, 1, 82, 0, TEGRA30_CLK_DSIB),
+	TEGRA_INIT_DATA_NODIV("disp1", mux_pllpmdacd2_clkm, CLK_SOURCE_DISP1, 29, 3, 27, 0, TEGRA30_CLK_DISP1),
+	TEGRA_INIT_DATA_NODIV("disp2", mux_pllpmdacd2_clkm, CLK_SOURCE_DISP2, 29, 3, 26, 0, TEGRA30_CLK_DISP2),
+	TEGRA_INIT_DATA_NODIV("dsib", mux_plld_out0_plld2_out0, CLK_SOURCE_DSIB, 25, 1, 82, 0, TEGRA30_CLK_DSIB),
 };
 
 static void __init tegra30_periph_clk_init(void)
@@ -1423,7 +1526,6 @@ static void __init tegra30_periph_clk_init(void)
 	clk = tegra_clk_register_periph_gate("apbdma", "clk_m", 0, clk_base, 0, 34,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-apbdma");
-	clks[TEGRA30_CLK_APBDMA] = clk;
 
 	/* rtc */
 	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
@@ -1435,141 +1537,119 @@ static void __init tegra30_periph_clk_init(void)
 	/* timer */
 	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base, 0,
 				    5, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "timer");
 	clks[TEGRA30_CLK_TIMER] = clk;
 
 	/* kbc */
 	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
 				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 36, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra-kbc");
 	clks[TEGRA30_CLK_KBC] = clk;
 
 	/* csus */
 	clk = tegra_clk_register_periph_gate("csus", "clk_m",
 				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 92, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "csus", "tengra_camera");
 	clks[TEGRA30_CLK_CSUS] = clk;
 
 	/* vcp */
 	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0, clk_base, 0, 29,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "vcp", "tegra-avp");
 	clks[TEGRA30_CLK_VCP] = clk;
 
 	/* bsea */
 	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0, clk_base, 0,
 				    62, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "bsea", "tegra-avp");
 	clks[TEGRA30_CLK_BSEA] = clk;
 
 	/* bsev */
 	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0, clk_base, 0,
 				    63, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "bsev", "tegra-aes");
 	clks[TEGRA30_CLK_BSEV] = clk;
 
 	/* usbd */
 	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base, 0,
 				    22, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "fsl-tegra-udc");
 	clks[TEGRA30_CLK_USBD] = clk;
 
 	/* usb2 */
 	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base, 0,
 				    58, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra-ehci.1");
 	clks[TEGRA30_CLK_USB2] = clk;
 
 	/* usb3 */
 	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base, 0,
 				    59, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra-ehci.2");
 	clks[TEGRA30_CLK_USB3] = clk;
 
 	/* dsia */
 	clk = tegra_clk_register_periph_gate("dsia", "pll_d_out0", 0, clk_base,
 				    0, 48, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "dsia", "tegradc.0");
 	clks[TEGRA30_CLK_DSIA] = clk;
 
 	/* csi */
 	clk = tegra_clk_register_periph_gate("csi", "pll_p_out3", 0, clk_base,
 				    0, 52, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "csi", "tegra_camera");
 	clks[TEGRA30_CLK_CSI] = clk;
 
 	/* isp */
 	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0, 23,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "isp", "tegra_camera");
 	clks[TEGRA30_CLK_ISP] = clk;
 
 	/* pcie */
 	clk = tegra_clk_register_periph_gate("pcie", "clk_m", 0, clk_base, 0,
 				    70, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "pcie", "tegra-pcie");
 	clks[TEGRA30_CLK_PCIE] = clk;
 
 	/* afi */
 	clk = tegra_clk_register_periph_gate("afi", "clk_m", 0, clk_base, 0, 72,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "afi", "tegra-pcie");
 	clks[TEGRA30_CLK_AFI] = clk;
 
 	/* pciex */
 	clk = tegra_clk_register_periph_gate("pciex", "pll_e", 0, clk_base, 0,
 				    74, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "pciex", "tegra-pcie");
 	clks[TEGRA30_CLK_PCIEX] = clk;
 
 	/* kfuse */
 	clk = tegra_clk_register_periph_gate("kfuse", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 40, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "kfuse-tegra");
 	clks[TEGRA30_CLK_KFUSE] = clk;
 
 	/* fuse */
 	clk = tegra_clk_register_periph_gate("fuse", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 39, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "fuse", "fuse-tegra");
 	clks[TEGRA30_CLK_FUSE] = clk;
 
 	/* fuse_burn */
 	clk = tegra_clk_register_periph_gate("fuse_burn", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 39, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "fuse_burn", "fuse-tegra");
 	clks[TEGRA30_CLK_FUSE_BURN] = clk;
 
 	/* apbif */
 	clk = tegra_clk_register_periph_gate("apbif", "clk_m", 0,
 				    clk_base, 0, 107, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "apbif", "tegra30-ahub");
 	clks[TEGRA30_CLK_APBIF] = clk;
 
 	/* hda2hdmi */
 	clk = tegra_clk_register_periph_gate("hda2hdmi", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 128, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "hda2hdmi", "tegra30-hda");
 	clks[TEGRA30_CLK_HDA2HDMI] = clk;
 
 	/* sata_cold */
 	clk = tegra_clk_register_periph_gate("sata_cold", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 129, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra_sata_cold");
 	clks[TEGRA30_CLK_SATA_COLD] = clk;
 
 	/* dtv */
 	clk = tegra_clk_register_periph_gate("dtv", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 79, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "dtv");
 	clks[TEGRA30_CLK_DTV] = clk;
 
 	/* emc */
@@ -1580,7 +1660,6 @@ static void __init tegra30_periph_clk_init(void)
 			       30, 2, 0, NULL);
 	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base, 0,
 				    57, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "emc", NULL);
 	clks[TEGRA30_CLK_EMC] = clk;
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
@@ -1588,7 +1667,6 @@ static void __init tegra30_periph_clk_init(void)
 		clk = tegra_clk_register_periph(data->name, data->p.parent_names,
 				data->num_parents, &data->periph,
 				clk_base, data->offset, data->flags);
-		clk_register_clkdev(clk, data->con_id, data->dev_id);
 		clks[data->clk_id] = clk;
 	}
 
@@ -1598,7 +1676,6 @@ static void __init tegra30_periph_clk_init(void)
 					data->p.parent_names,
 					data->num_parents, &data->periph,
 					clk_base, data->offset);
-		clk_register_clkdev(clk, data->con_id, data->dev_id);
 		clks[data->clk_id] = clk;
 	}
 }
@@ -1610,31 +1687,26 @@ static void __init tegra30_fixed_clk_init(void)
 	/* clk_32k */
 	clk = clk_register_fixed_rate(NULL, "clk_32k", NULL, CLK_IS_ROOT,
 				32768);
-	clk_register_clkdev(clk, "clk_32k", NULL);
 	clks[TEGRA30_CLK_CLK_32K] = clk;
 
 	/* clk_m_div2 */
 	clk = clk_register_fixed_factor(NULL, "clk_m_div2", "clk_m",
 				CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "clk_m_div2", NULL);
 	clks[TEGRA30_CLK_CLK_M_DIV2] = clk;
 
 	/* clk_m_div4 */
 	clk = clk_register_fixed_factor(NULL, "clk_m_div4", "clk_m",
 				CLK_SET_RATE_PARENT, 1, 4);
-	clk_register_clkdev(clk, "clk_m_div4", NULL);
 	clks[TEGRA30_CLK_CLK_M_DIV4] = clk;
 
 	/* cml0 */
 	clk = clk_register_gate(NULL, "cml0", "pll_e", 0, clk_base + PLLE_AUX,
 				0, 0, &cml_lock);
-	clk_register_clkdev(clk, "cml0", NULL);
 	clks[TEGRA30_CLK_CML0] = clk;
 
 	/* cml1 */
 	clk = clk_register_gate(NULL, "cml1", "pll_e", 0, clk_base + PLLE_AUX,
 				1, 0, &cml_lock);
-	clk_register_clkdev(clk, "cml1", NULL);
 	clks[TEGRA30_CLK_CML1] = clk;
 }
 
@@ -1648,14 +1720,12 @@ static void __init tegra30_osc_clk_init(void)
 	/* clk_m */
 	clk = clk_register_fixed_rate(NULL, "clk_m", NULL, CLK_IS_ROOT,
 				input_freq);
-	clk_register_clkdev(clk, "clk_m", NULL);
 	clks[TEGRA30_CLK_CLK_M] = clk;
 
 	/* pll_ref */
 	pll_ref_div = tegra30_get_pll_ref_div();
 	clk = clk_register_fixed_factor(NULL, "pll_ref", "clk_m",
 				CLK_SET_RATE_PARENT, 1, pll_ref_div);
-	clk_register_clkdev(clk, "pll_ref", NULL);
 	clks[TEGRA30_CLK_PLL_REF] = clk;
 }
 
@@ -1907,6 +1977,7 @@ static void __init tegra30_clock_init(struct device_node *np)
 	tegra_init_dup_clks(tegra_clk_duplicates, clks, TEGRA30_CLK_CLK_MAX);
 
 	tegra_add_of_provider(np);
+	tegra_register_devclks(devclks, ARRAY_SIZE(devclks));
 
 	tegra_clk_apply_init_table = tegra30_clock_apply_init_table;
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

