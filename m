Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab3JDJSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 05:18:53 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11333 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab3JDJSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 05:18:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Oct 2013 02:14:53 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH 4/5] clk: tegra124: Add new peripheral clocks
Date: Fri, 4 Oct 2013 12:12:43 +0300
Message-ID: <1380878014-22088-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
References: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
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
 drivers/clk/tegra/clk-tegra-periph.c |   61 ++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index 407dbb8..f8b1e8e 100644
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
@@ -66,10 +68,12 @@
 #define CLK_SOURCE_I2C3 0x1b8
 #define CLK_SOURCE_I2C4 0x3c4
 #define CLK_SOURCE_I2C5 0x128
+#define CLK_SOURCE_I2C6 0x65c
 #define CLK_SOURCE_UARTA 0x178
 #define CLK_SOURCE_UARTB 0x17c
 #define CLK_SOURCE_UARTC 0x1a0
 #define CLK_SOURCE_UARTD 0x1c0
+#define CLK_SOURCE_UARTE 0x1c4
 #define CLK_SOURCE_VI_SENSOR 0x1a8
 #define CLK_SOURCE_VI 0x148
 #define CLK_SOURCE_EPP 0x16c
@@ -104,6 +108,16 @@
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
 
@@ -192,12 +206,14 @@
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
@@ -310,6 +326,30 @@ static u32 mux_d_audio_clk_idx[] = {
 	[5] = 0xE002, [6] = 0xE003, [7] = 0xE004, [8] = 0xE005, [9] = 0xE007,
 };
 
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
+
 static struct tegra_periph_init_data periph_clks[] = {
 	MUX("i2s0", NULL, "tegra30-i2s.0", mux_pllaout0_audio0_2x_pllp_clkm, CLK_SOURCE_I2S0, 30, TEGRA_PERIPH_ON_APB, tegra_clk_i2s0),
 	MUX("i2s1", NULL, "tegra30-i2s.1", mux_pllaout0_audio1_2x_pllp_clkm, CLK_SOURCE_I2S1, 11, TEGRA_PERIPH_ON_APB, tegra_clk_i2s1),
@@ -386,6 +426,19 @@ static struct tegra_periph_init_data periph_clks[] = {
 	AUDIO("dam2", NULL, "tegra30-dam.2", CLK_SOURCE_DAM2, 110, TEGRA_PERIPH_ON_APB, tegra_clk_dam2),
 	NODIV("disp1", NULL, "tegradc.0", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP1, 29, 7, 27, 0, tegra_clk_disp1),
 	NODIV("disp2", NULL, "tegradc.1", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP2, 29, 7, 26, 0, tegra_clk_disp2),
+	MUX8("isp", NULL, "isp", mux_pllm_pllc_pllp_plla_clkm_pllc4, CLK_SOURCE_ISP, 23, TEGRA_PERIPH_ON_APB, tegra124_clk_isp),
+	MUX8("entropy", NULL, "entropy", mux_pllp_clkm1, CLK_SOURCE_ENTROPY, 149,  0, tegra_clk_entropy),
+	I2C("i2c6", "div-clk", "tegra11-i2c.5", mux_pllp_clkm, CLK_SOURCE_I2C6, 166, tegra_clk_i2c6),
+	MUX8("hdmi_audio", NULL, "hdmi_audio", mux_pllp3_pllc_clkm, CLK_SOURCE_HDMI_AUDIO, 176, TEGRA_PERIPH_NO_RESET, tegra_clk_hdmi_audio),
+	MUX8("clk72mhz", NULL, "clk72mhz", mux_pllp3_pllc_clkm, CLK_SOURCE_CLK72MHZ, 177, TEGRA_PERIPH_NO_RESET, tegra_clk_clk72Mhz),
+	INT8("vic03", NULL, "vic03", mux_pllm_pllc_pllp_plla_pllc2_c3_clkm, CLK_SOURCE_VIC03, 178, 0, tegra_clk_vic03),
+	MUX("adx1", NULL, "adx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_ADX1, 180, TEGRA_PERIPH_ON_APB, tegra_clk_adx1),
+	MUX("amx1", NULL, "amx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_AMX1, 185, TEGRA_PERIPH_ON_APB, tegra_clk_amx1),
+	MUX8("sor0", NULL, "sor0", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_SOR0, 182, 0, tegra_clk_sor0),
+	MUX("sata_oob", NULL, "tegra_sata_oob", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SATA_OOB, 123, TEGRA_PERIPH_ON_APB, tegra_clk_sata_oob),
+	MUX("sata", NULL, "tegra_sata", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SATA, 124, TEGRA_PERIPH_ON_APB, tegra_clk_sata),
+	MUX("vi_sensor2", "vi_sensor2", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR2, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor2),
+	UART("uarte", NULL, "tegra_uart.4", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTE, 66, tegra_clk_uarte),
 };
 
 static struct tegra_periph_init_data gate_clks[] = {
@@ -417,6 +470,13 @@ static struct tegra_periph_init_data gate_clks[] = {
 	GATE("dsia", NULL, NULL, "dsia_mux", 48, 0, tegra_clk_dsia, 0),
 	GATE("dsib", NULL, NULL, "dsib_mux", 82, 0, tegra_clk_dsib, 0),
 	GATE("emc", NULL, NULL, "emc_mux", 57, 0, tegra_clk_emc, CLK_IGNORE_UNUSED),
+	GATE("ispb", "ispb", "tegra_camera", "clk_m", 3, 0, tegra_clk_ispb, 0),
+	GATE("vim2_clk", "vim2_clk", "tegra_camera", "clk_m", 11, 0, tegra_clk_vim2_clk, 0),
+	GATE("pcie", "pcie", "tegra-pcie", "clk_m", 70, 0, tegra_clk_pcie, 0),
+	GATE("afi", "afi", "tegra-pcie", "clk_m", 72, 0, tegra_clk_afi, 0),
+	GATE("sata_cold", NULL, "tegra_sata_cold", "clk_m", 129, TEGRA_PERIPH_ON_APB, tegra_clk_sata_cold, 0),
+	GATE("dpaux", NULL, "dpaux", "clk_m", 181, 0, tegra_clk_dpaux, 0),
+	GATE("gpu", NULL, NULL, "pll_ref", 184, 0, tegra_clk_gpu, 0),
 };
 
 struct pll_out_data {
@@ -448,6 +508,7 @@ static struct pll_out_data pllp_out_clks[] = {
 	PLL_OUT(2, PLLP_OUTA, 24, TEGRA_DIVIDER_INT, 16),
 	PLL_OUT(3, PLLP_OUTB, 8, 0, 0),
 	PLL_OUT(4, PLLP_OUTB, 24, 0, 16),
+	PLL_OUT(5, PLLP_OUTC, 24, 0, 16),
 };
 
 static struct div_nmp pllp_nmp = {
-- 
1.7.7.rc0.72.g4b5ea.dirty

