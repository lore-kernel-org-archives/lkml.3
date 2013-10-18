Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3JRNpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:45:31 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2064 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3JRNpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:45:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 18 Oct 2013 06:45:19 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 4/7] clk: tegra124: Add new peripheral clocks
Date: Fri, 18 Oct 2013 16:45:01 +0300
Message-ID: <1382103904-6398-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382103904-6398-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382103904-6398-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra124 introduces a number of new peripheral clocks. This patch adds those
to the common peripheral clock code.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra-periph.c |   54 ++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index 1252778..9125d02 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -37,7 +37,9 @@
 #define CLK_SOURCE_SPDIF_IN 0x10c
 #define CLK_SOURCE_PWM 0x110
 #define CLK_SOURCE_ADX 0x638
+#define CLK_SOURCE_ADX1 0x670
 #define CLK_SOURCE_AMX 0x63c
+#define CLK_SOURCE_AMX1 0x674
 #define CLK_SOURCE_HDA 0x428
 #define CLK_SOURCE_HDA2CODEC_2X 0x3e4
 #define CLK_SOURCE_SBC1 0x134
@@ -69,6 +71,7 @@
 #define CLK_SOURCE_I2C3 0x1b8
 #define CLK_SOURCE_I2C4 0x3c4
 #define CLK_SOURCE_I2C5 0x128
+#define CLK_SOURCE_I2C6 0x65c
 #define CLK_SOURCE_UARTA 0x178
 #define CLK_SOURCE_UARTB 0x17c
 #define CLK_SOURCE_UARTC 0x1a0
@@ -77,6 +80,7 @@
 #define CLK_SOURCE_3D 0x158
 #define CLK_SOURCE_2D 0x15c
 #define CLK_SOURCE_MPE 0x170
+#define CLK_SOURCE_UARTE 0x1c4
 #define CLK_SOURCE_VI_SENSOR 0x1a8
 #define CLK_SOURCE_VI 0x148
 #define CLK_SOURCE_EPP 0x16c
@@ -111,6 +115,16 @@
 #define CLK_SOURCE_XUSB_FS_SRC 0x608
 #define CLK_SOURCE_XUSB_SS_SRC 0x610
 #define CLK_SOURCE_XUSB_DEV_SRC 0x60c
+#define CLK_SOURCE_ISP 0x144
+#define CLK_SOURCE_SOR0 0x414
+#define CLK_SOURCE_DPAUX 0x418
+#define CLK_SOURCE_SATA_OOB 0x420
+#define CLK_SOURCE_SATA 0x424
+#define CLK_SOURCE_ENTROPY 0x628
+#define CLK_SOURCE_VI_SENSOR2 0x658
+#define CLK_SOURCE_HDMI_AUDIO 0x668
+#define CLK_SOURCE_VIC03 0x678
+#define CLK_SOURCE_CLK72MHZ 0x66c
 
 #define MASK(x) (BIT(x) - 1)
 
@@ -197,12 +211,14 @@
 #define PLLP_MISC 0xac
 #define PLLP_OUTA 0xa4
 #define PLLP_OUTB 0xa8
+#define PLLP_OUTC 0x67c
 
 #define PLL_BASE_LOCK BIT(27)
 #define PLL_MISC_LOCK_ENABLE 18
 
 static DEFINE_SPINLOCK(PLLP_OUTA_lock);
 static DEFINE_SPINLOCK(PLLP_OUTB_lock);
+static DEFINE_SPINLOCK(PLLP_OUTC_lock);
 
 #define MUX_I2S_SPDIF(_id)						\
 static const char *mux_pllaout0_##_id##_2x_pllp_clkm[] = { "pll_a_out0", \
@@ -319,6 +335,29 @@ static const char *mux_pllp_plld_pllc_clkm[] = {
 	"pll_p", "pll_d_out0", "pll_c", "clk_m"
 };
 #define mux_pllp_plld_pllc_clkm_idx NULL
+static const char *mux_pllm_pllc_pllp_plla_clkm_pllc4[] = {
+	"pll_m", "pll_c", "pll_p", "pll_a_out0", "clk_m", "pll_c4",
+};
+static u32 mux_pllm_pllc_pllp_plla_clkm_pllc4_idx[] = {
+	[0] = 0, [1] = 1, [2] = 3, [3] = 3, [4] = 6, [5] = 7,
+};
+
+static const char *mux_pllp_clkm1[] = {
+	"pll_p", "clk_m",
+};
+#define mux_pllp_clkm1_idx NULL
+
+static const char *mux_pllp3_pllc_clkm[] = {
+	"pll_p_out3", "pll_c", "pll_c2", "clk_m",
+};
+#define mux_pllp3_pllc_clkm_idx NULL
+
+static const char *mux_pllm_pllc_pllp_plla_pllc2_c3_clkm[] = {
+	"pll_m", "pll_c", "pll_p", "pll_a", "pll_c2", "pll_c3", "clk_m"
+};
+static u32 mux_pllm_pllc_pllp_plla_pllc2_c3_clkm_idx[] = {
+	[0] = 0, [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 6,
+};
 
 static struct tegra_periph_init_data periph_clks[] = {
 	AUDIO("d_audio", CLK_SOURCE_D_AUDIO, 106, TEGRA_PERIPH_ON_APB, tegra_clk_d_audio),
@@ -346,6 +385,7 @@ static struct tegra_periph_init_data periph_clks[] = {
 	INT8("se", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SE, 127, TEGRA_PERIPH_ON_APB, tegra_clk_se),
 	INT8("2d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_2D, 21, 0, tegra_clk_gr2d_8),
 	INT8("3d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_3D, 24, 0, tegra_clk_gr3d_8),
+	INT8("vic03", mux_pllm_pllc_pllp_plla_pllc2_c3_clkm, CLK_SOURCE_VIC03, 178, 0, tegra_clk_vic03),
 	INT_FLAGS("mselect", mux_pllp_clkm, CLK_SOURCE_MSELECT, 99, 0, tegra_clk_mselect, CLK_IGNORE_UNUSED),
 	MUX("i2s0", mux_pllaout0_audio0_2x_pllp_clkm, CLK_SOURCE_I2S0, 30, TEGRA_PERIPH_ON_APB, tegra_clk_i2s0),
 	MUX("i2s1", mux_pllaout0_audio1_2x_pllp_clkm, CLK_SOURCE_I2S1, 11, TEGRA_PERIPH_ON_APB, tegra_clk_i2s1),
@@ -393,6 +433,9 @@ static struct tegra_periph_init_data periph_clks[] = {
 	MUX("ndspeed", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_NDSPEED, 80, TEGRA_PERIPH_ON_APB, tegra_clk_ndspeed),
 	MUX("sata_oob", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SATA_OOB, 123, TEGRA_PERIPH_ON_APB, tegra_clk_sata_oob),
 	MUX("sata", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SATA, 124, TEGRA_PERIPH_ON_APB, tegra_clk_sata),
+	MUX("adx1", mux_plla_pllc_pllp_clkm, CLK_SOURCE_ADX1, 180, TEGRA_PERIPH_ON_APB, tegra_clk_adx1),
+	MUX("amx1", mux_plla_pllc_pllp_clkm, CLK_SOURCE_AMX1, 185, TEGRA_PERIPH_ON_APB, tegra_clk_amx1),
+	MUX("vi_sensor2", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR2, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor2),
 	MUX8("sbc1", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC1, 41, TEGRA_PERIPH_ON_APB, tegra_clk_sbc1_8),
 	MUX8("sbc2", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC2, 44, TEGRA_PERIPH_ON_APB, tegra_clk_sbc2_8),
 	MUX8("sbc3", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC3, 46, TEGRA_PERIPH_ON_APB, tegra_clk_sbc3_8),
@@ -407,6 +450,11 @@ static struct tegra_periph_init_data periph_clks[] = {
 	MUX8("extern3", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN3, 122, 0, tegra_clk_extern3),
 	MUX8("soc_therm", mux_pllm_pllc_pllp_plla, CLK_SOURCE_SOC_THERM, 78, TEGRA_PERIPH_ON_APB, tegra_clk_soc_therm),
 	MUX8("vi_sensor", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor_8),
+	MUX8("isp", mux_pllm_pllc_pllp_plla_clkm_pllc4, CLK_SOURCE_ISP, 23, TEGRA_PERIPH_ON_APB, tegra_clk_isp_8),
+	MUX8("entropy", mux_pllp_clkm1, CLK_SOURCE_ENTROPY, 149,  0, tegra_clk_entropy),
+	MUX8("hdmi_audio", mux_pllp3_pllc_clkm, CLK_SOURCE_HDMI_AUDIO, 176, TEGRA_PERIPH_NO_RESET, tegra_clk_hdmi_audio),
+	MUX8("clk72mhz", mux_pllp3_pllc_clkm, CLK_SOURCE_CLK72MHZ, 177, TEGRA_PERIPH_NO_RESET, tegra_clk_clk72Mhz),
+	MUX8("sor0", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_SOR0, 182, 0, tegra_clk_sor0),
 	MUX_FLAGS("csite", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_CSITE, 73, TEGRA_PERIPH_ON_APB, tegra_clk_csite, CLK_IGNORE_UNUSED),
 	NODIV("disp1", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP1, 29, 7, 27, 0, tegra_clk_disp1),
 	NODIV("disp2", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP2, 29, 7, 26, 0, tegra_clk_disp2),
@@ -453,6 +501,11 @@ static struct tegra_periph_init_data gate_clks[] = {
 	GATE("dsib", "dsib_mux", 82, 0, tegra_clk_dsib, 0),
 	GATE("emc", "emc_mux", 57, 0, tegra_clk_emc, CLK_IGNORE_UNUSED),
 	GATE("sata_cold", "clk_m", 129, TEGRA_PERIPH_ON_APB, tegra_clk_sata_cold, 0),
+	GATE("ispb", "clk_m", 3, 0, tegra_clk_ispb, 0),
+	GATE("vim2_clk", "clk_m", 11, 0, tegra_clk_vim2_clk, 0),
+	GATE("pcie", "clk_m", 70, 0, tegra_clk_pcie, 0),
+	GATE("dpaux", "clk_m", 181, 0, tegra_clk_dpaux, 0),
+	GATE("gpu", "pll_ref", 184, 0, tegra_clk_gpu, 0),
 };
 
 struct pll_out_data {
@@ -485,6 +538,7 @@ static struct pll_out_data pllp_out_clks[] = {
 	PLL_OUT(2, PLLP_OUTA, 24, TEGRA_DIVIDER_INT, 16, pll_p_out2_int),
 	PLL_OUT(3, PLLP_OUTB, 8, 0, 0, pll_p_out3),
 	PLL_OUT(4, PLLP_OUTB, 24, 0, 16, pll_p_out4),
+	PLL_OUT(5, PLLP_OUTC, 24, 0, 16, pll_p_out5),
 };
 
 static void __init periph_clk_init(void __iomem *clk_base,
-- 
1.7.7.rc0.72.g4b5ea.dirty

