Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab3JRN0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:26:24 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12190 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab3JRN0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:26:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 18 Oct 2013 06:21:51 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 15/15] clk: tegra: move tegra20 to common infra
Date: Fri, 18 Oct 2013 16:25:19 +0300
Message-ID: <1382102719-5531-16-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move tegra20 to common tegra clock infrastructure.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra20.c |  651 +++++++++++++++------------------------
 1 files changed, 255 insertions(+), 396 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 7c9af8e..58faac5 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -22,8 +22,10 @@
 #include <linux/of_address.h>
 #include <linux/clk/tegra.h>
 #include <linux/delay.h>
+#include <dt-bindings/clock/tegra20-car.h>
 
 #include "clk.h"
+#include "clk-id.h"
 
 #define OSC_CTRL 0x50
 #define OSC_CTRL_OSC_FREQ_MASK (3<<30)
@@ -94,34 +96,15 @@
 
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
@@ -131,14 +114,6 @@
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
@@ -171,57 +146,28 @@ static struct cpu_clk_suspend_context {
 static void __iomem *clk_base;
 static void __iomem *pmc_base;
 
-static DEFINE_SPINLOCK(pll_div_lock);
-static DEFINE_SPINLOCK(sysrate_lock);
-
-#define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
+#define TEGRA_INIT_DATA_MUX(_name, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
+	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_ROUND_UP,	\
 			_clk_num, \
 			_gate_flags, _clk_id)
 
-#define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
-			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
-			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_INT, \
-			_clk_num, _gate_flags,	\
-			_clk_id)
-
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
 
-/* IDs assigned here must be in sync with DT bindings definition
- * for Tegra20 clocks .
- */
-enum tegra20_clk {
-	cpu, ac97 = 3, rtc, timer, uarta, gpio = 8, sdmmc2, i2s1 = 11, i2c1,
-	ndflash, sdmmc1, sdmmc4, twc, pwm, i2s2, epp, gr2d = 21, usbd, isp,
-	gr3d, ide, disp2, disp1, host1x, vcp, cache2 = 31, mem, ahbdma, apbdma,
-	kbc = 36, stat_mon, pmc, fuse, kfuse, sbc1, nor, spi, sbc2, xio, sbc3,
-	dvc, dsi, mipi = 50, hdmi, csi, tvdac, i2c2, uartc, emc = 57, usb2,
-	usb3, mpe, vde, bsea, bsev, speedo, uartd, uarte, i2c3, sbc4, sdmmc3,
-	pex, owr, afi, csite, pcie_xclk, avpucq = 75, la, irama = 84, iramb,
-	iramc, iramd, cram2, audio_2x, clk_d, csus = 92, cdev2, cdev1,
-	uartb = 96, vfir, spdif_in, spdif_out, vi, vi_sensor, tvo, cve,
-	osc, clk_32k, clk_m, sclk, cclk, hclk, pclk, blink, pll_a, pll_a_out0,
-	pll_c, pll_c_out1, pll_d, pll_d_out0, pll_e, pll_m, pll_m_out1,
-	pll_p, pll_p_out1, pll_p_out2, pll_p_out3, pll_p_out4, pll_s, pll_u,
-	pll_x, cop, audio, pll_ref, twd, clk_max,
-};
-
 static struct clk **clks;
 
 static struct tegra_clk_pll_freq_table pll_c_freq_table[] = {
@@ -485,6 +431,157 @@ static struct tegra_clk_pll_params pll_e_params = {
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
@@ -545,8 +642,7 @@ static void tegra20_pll_init(void)
 	/* PLLC */
 	clk = tegra_clk_register_pll("pll_c", "pll_ref", clk_base, NULL, 0,
 			    &pll_c_params, NULL);
-	clk_register_clkdev(clk, "pll_c", NULL);
-	clks[pll_c] = clk;
+	clks[TEGRA20_CLK_PLL_C] = clk;
 
 	/* PLLC_OUT1 */
 	clk = tegra_clk_register_divider("pll_c_out1_div", "pll_c",
@@ -555,69 +651,13 @@ static void tegra20_pll_init(void)
 	clk = tegra_clk_register_pll_out("pll_c_out1", "pll_c_out1_div",
 				clk_base + PLLC_OUT, 1, 0, CLK_SET_RATE_PARENT,
 				0, NULL);
-	clk_register_clkdev(clk, "pll_c_out1", NULL);
-	clks[pll_c_out1] = clk;
-
-	/* PLLP */
-	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, NULL, 0,
-			    &pll_p_params, NULL);
-	clk_register_clkdev(clk, "pll_p", NULL);
-	clks[pll_p] = clk;
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
-	clk_register_clkdev(clk, "pll_p_out1", NULL);
-	clks[pll_p_out1] = clk;
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
-	clk_register_clkdev(clk, "pll_p_out2", NULL);
-	clks[pll_p_out2] = clk;
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
-	clk_register_clkdev(clk, "pll_p_out3", NULL);
-	clks[pll_p_out3] = clk;
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
-	clk_register_clkdev(clk, "pll_p_out4", NULL);
-	clks[pll_p_out4] = clk;
+	clks[TEGRA20_CLK_PLL_C_OUT1] = clk;
 
 	/* PLLM */
 	clk = tegra_clk_register_pll("pll_m", "pll_ref", clk_base, NULL,
 			    CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE,
 			    &pll_m_params, NULL);
-	clk_register_clkdev(clk, "pll_m", NULL);
-	clks[pll_m] = clk;
+	clks[TEGRA20_CLK_PLL_M] = clk;
 
 	/* PLLM_OUT1 */
 	clk = tegra_clk_register_divider("pll_m_out1_div", "pll_m",
@@ -626,38 +666,32 @@ static void tegra20_pll_init(void)
 	clk = tegra_clk_register_pll_out("pll_m_out1", "pll_m_out1_div",
 				clk_base + PLLM_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
-	clk_register_clkdev(clk, "pll_m_out1", NULL);
-	clks[pll_m_out1] = clk;
+	clks[TEGRA20_CLK_PLL_M_OUT1] = clk;
 
 	/* PLLX */
 	clk = tegra_clk_register_pll("pll_x", "pll_ref", clk_base, NULL, 0,
 			    &pll_x_params, NULL);
-	clk_register_clkdev(clk, "pll_x", NULL);
-	clks[pll_x] = clk;
+	clks[TEGRA20_CLK_PLL_X] = clk;
 
 	/* PLLU */
 	clk = tegra_clk_register_pll("pll_u", "pll_ref", clk_base, NULL, 0,
 			    &pll_u_params, NULL);
-	clk_register_clkdev(clk, "pll_u", NULL);
-	clks[pll_u] = clk;
+	clks[TEGRA20_CLK_PLL_U] = clk;
 
 	/* PLLD */
 	clk = tegra_clk_register_pll("pll_d", "pll_ref", clk_base, NULL, 0,
 			    &pll_d_params, NULL);
-	clk_register_clkdev(clk, "pll_d", NULL);
-	clks[pll_d] = clk;
+	clks[TEGRA20_CLK_PLL_D] = clk;
 
 	/* PLLD_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d_out0", "pll_d",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "pll_d_out0", NULL);
-	clks[pll_d_out0] = clk;
+	clks[TEGRA20_CLK_PLL_D_OUT0] = clk;
 
 	/* PLLA */
 	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, NULL, 0,
 			    &pll_a_params, NULL);
-	clk_register_clkdev(clk, "pll_a", NULL);
-	clks[pll_a] = clk;
+	clks[TEGRA20_CLK_PLL_A] = clk;
 
 	/* PLLA_OUT0 */
 	clk = tegra_clk_register_divider("pll_a_out0_div", "pll_a",
@@ -666,14 +700,12 @@ static void tegra20_pll_init(void)
 	clk = tegra_clk_register_pll_out("pll_a_out0", "pll_a_out0_div",
 				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
-	clk_register_clkdev(clk, "pll_a_out0", NULL);
-	clks[pll_a_out0] = clk;
+	clks[TEGRA20_CLK_PLL_A_OUT0] = clk;
 
 	/* PLLE */
 	clk = tegra_clk_register_plle("pll_e", "pll_ref", clk_base, pmc_base,
 			     0, &pll_e_params, NULL);
-	clk_register_clkdev(clk, "pll_e", NULL);
-	clks[pll_e] = clk;
+	clks[TEGRA20_CLK_PLL_E] = clk;
 }
 
 static const char *cclk_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
@@ -691,40 +723,17 @@ static void tegra20_super_clk_init(void)
 	clk = tegra_clk_register_super_mux("cclk", cclk_parents,
 			      ARRAY_SIZE(cclk_parents), CLK_SET_RATE_PARENT,
 			      clk_base + CCLK_BURST_POLICY, 0, 4, 0, 0, NULL);
-	clk_register_clkdev(clk, "cclk", NULL);
-	clks[cclk] = clk;
+	clks[TEGRA20_CLK_CCLK] = clk;
 
 	/* SCLK */
 	clk = tegra_clk_register_super_mux("sclk", sclk_parents,
 			      ARRAY_SIZE(sclk_parents), CLK_SET_RATE_PARENT,
 			      clk_base + SCLK_BURST_POLICY, 0, 4, 0, 0, NULL);
-	clk_register_clkdev(clk, "sclk", NULL);
-	clks[sclk] = clk;
-
-	/* HCLK */
-	clk = clk_register_divider(NULL, "hclk_div", "sclk", 0,
-				   clk_base + CLK_SYSTEM_RATE, 4, 2, 0,
-				   &sysrate_lock);
-	clk = clk_register_gate(NULL, "hclk", "hclk_div", CLK_SET_RATE_PARENT,
-				clk_base + CLK_SYSTEM_RATE, 7,
-				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clk_register_clkdev(clk, "hclk", NULL);
-	clks[hclk] = clk;
-
-	/* PCLK */
-	clk = clk_register_divider(NULL, "pclk_div", "hclk", 0,
-				   clk_base + CLK_SYSTEM_RATE, 0, 2, 0,
-				   &sysrate_lock);
-	clk = clk_register_gate(NULL, "pclk", "pclk_div", CLK_SET_RATE_PARENT,
-				clk_base + CLK_SYSTEM_RATE, 3,
-				CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clk_register_clkdev(clk, "pclk", NULL);
-	clks[pclk] = clk;
+	clks[TEGRA20_CLK_SCLK] = clk;
 
 	/* twd */
 	clk = clk_register_fixed_factor(NULL, "twd", "cclk", 0, 1, 4);
-	clk_register_clkdev(clk, "twd", NULL);
-	clks[twd] = clk;
+	clks[TEGRA20_CLK_TWD] = clk;
 }
 
 static const char *audio_parents[] = {"spdif_in", "i2s1", "i2s2", "unused",
@@ -743,8 +752,7 @@ static void __init tegra20_audio_clk_init(void)
 	clk = clk_register_gate(NULL, "audio", "audio_mux", 0,
 				clk_base + AUDIO_SYNC_CLK, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio", NULL);
-	clks[audio] = clk;
+	clks[TEGRA20_CLK_AUDIO] = clk;
 
 	/* audio_2x */
 	clk = clk_register_fixed_factor(NULL, "audio_doubler", "audio",
@@ -753,8 +761,7 @@ static void __init tegra20_audio_clk_init(void)
 				    TEGRA_PERIPH_NO_RESET, clk_base,
 				    CLK_SET_RATE_PARENT, 89,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio_2x", NULL);
-	clks[audio_2x] = clk;
+	clks[TEGRA20_CLK_AUDIO_2X] = clk;
 
 }
 
@@ -762,68 +769,36 @@ static const char *i2s1_parents[] = {"pll_a_out0", "audio_2x", "pll_p",
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
-	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra20-i2s.0", i2s1_parents,	    CLK_SOURCE_I2S1,	  11,	TEGRA_PERIPH_ON_APB, i2s1),
-	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra20-i2s.1", i2s2_parents,	    CLK_SOURCE_I2S2,	  18,	TEGRA_PERIPH_ON_APB, i2s2),
-	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra20-spdif", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10,	TEGRA_PERIPH_ON_APB, spdif_out),
-	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra20-spdif", spdif_in_parents,  CLK_SOURCE_SPDIF_IN,  10,	TEGRA_PERIPH_ON_APB, spdif_in),
-	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC1,	  41,	TEGRA_PERIPH_ON_APB, sbc1),
-	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC2,	  44,	TEGRA_PERIPH_ON_APB, sbc2),
-	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC3,	  46,	TEGRA_PERIPH_ON_APB, sbc3),
-	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC4,	  68,	TEGRA_PERIPH_ON_APB, sbc4),
-	TEGRA_INIT_DATA_MUX("spi",	NULL,		"spi",		 mux_pllpcm_clkm,   CLK_SOURCE_SPI,	  43,	TEGRA_PERIPH_ON_APB, spi),
-	TEGRA_INIT_DATA_MUX("xio",	NULL,		"xio",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  45,	0, xio),
-	TEGRA_INIT_DATA_MUX("twc",	NULL,		"twc",		 mux_pllpcm_clkm,   CLK_SOURCE_TWC,	  16,	TEGRA_PERIPH_ON_APB, twc),
-	TEGRA_INIT_DATA_MUX("ide",	NULL,		"ide",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  25,	0, ide),
-	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",	 mux_pllpcm_clkm,   CLK_SOURCE_NDFLASH,	  13,	0, ndflash),
-	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",		 mux_pllpcm_clkm,   CLK_SOURCE_VFIR,	  7,	TEGRA_PERIPH_ON_APB, vfir),
-	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",	 mux_pllpcm_clkm,   CLK_SOURCE_CSITE,	  73,	0, csite),
-	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",		 mux_pllpcm_clkm,   CLK_SOURCE_LA,	  76,	0, la),
-	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",	 mux_pllpcm_clkm,   CLK_SOURCE_OWR,	  71,	TEGRA_PERIPH_ON_APB, owr),
-	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",		 mux_pllpcm_clkm,   CLK_SOURCE_MIPI,	  50,	TEGRA_PERIPH_ON_APB, mipi),
-	TEGRA_INIT_DATA_MUX("vde",	NULL,		"vde",		 mux_pllpcm_clkm,   CLK_SOURCE_VDE,	  61,	0, vde),
-	TEGRA_INIT_DATA_MUX("vi",	"vi",		"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI,	  20,	0, vi),
-	TEGRA_INIT_DATA_MUX("epp",	NULL,		"epp",		 mux_pllmcpa,	    CLK_SOURCE_EPP,	  19,	0, epp),
-	TEGRA_INIT_DATA_MUX("mpe",	NULL,		"mpe",		 mux_pllmcpa,	    CLK_SOURCE_MPE,	  60,	0, mpe),
-	TEGRA_INIT_DATA_MUX("host1x",	NULL,		"host1x",	 mux_pllmcpa,	    CLK_SOURCE_HOST1X,	  28,	0, host1x),
-	TEGRA_INIT_DATA_MUX("3d",	NULL,		"3d",		 mux_pllmcpa,	    CLK_SOURCE_3D,	  24,	TEGRA_PERIPH_MANUAL_RESET, gr3d),
-	TEGRA_INIT_DATA_MUX("2d",	NULL,		"2d",		 mux_pllmcpa,	    CLK_SOURCE_2D,	  21,	0, gr2d),
-	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",	 mux_pllpcm_clkm,   CLK_SOURCE_NOR,	  42,	0, nor),
-	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC1,	  14,	0, sdmmc1),
-	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC2,	  9,	0, sdmmc2),
-	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC3,	  69,	0, sdmmc3),
-	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC4,	  15,	0, sdmmc4),
-	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",		 mux_pllpdc_clkm,   CLK_SOURCE_CVE,	  49,	0, cve),
-	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",		 mux_pllpdc_clkm,   CLK_SOURCE_TVO,	  49,	0, tvo),
-	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",	 mux_pllpdc_clkm,   CLK_SOURCE_TVDAC,	  53,	0, tvdac),
-	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI_SENSOR, 20,	TEGRA_PERIPH_NO_RESET, vi_sensor),
-	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C1,	  12,	TEGRA_PERIPH_ON_APB, i2c1),
-	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C2,	  54,	TEGRA_PERIPH_ON_APB, i2c2),
-	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C3,	  67,	TEGRA_PERIPH_ON_APB, i2c3),
-	TEGRA_INIT_DATA_DIV16("dvc",	"div-clk",	"tegra-i2c.3",	 mux_pllpcm_clkm,   CLK_SOURCE_DVC,	  47,	TEGRA_PERIPH_ON_APB, dvc),
-	TEGRA_INIT_DATA_MUX("hdmi",	NULL,		"hdmi",		 mux_pllpdc_clkm,   CLK_SOURCE_HDMI,	  51,	0, hdmi),
-	TEGRA_INIT_DATA("pwm",		NULL,		"tegra-pwm",	 pwm_parents,	    CLK_SOURCE_PWM,	  28, 3, 0, 0, 8, 1, 0, 17, TEGRA_PERIPH_ON_APB, pwm),
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
-	TEGRA_INIT_DATA_NODIV("uarta",	NULL, "tegra_uart.0", mux_pllpcm_clkm, CLK_SOURCE_UARTA, 30, 2, 6,  TEGRA_PERIPH_ON_APB, uarta),
-	TEGRA_INIT_DATA_NODIV("uartb",	NULL, "tegra_uart.1", mux_pllpcm_clkm, CLK_SOURCE_UARTB, 30, 2, 7,  TEGRA_PERIPH_ON_APB, uartb),
-	TEGRA_INIT_DATA_NODIV("uartc",	NULL, "tegra_uart.2", mux_pllpcm_clkm, CLK_SOURCE_UARTC, 30, 2, 55, TEGRA_PERIPH_ON_APB, uartc),
-	TEGRA_INIT_DATA_NODIV("uartd",	NULL, "tegra_uart.3", mux_pllpcm_clkm, CLK_SOURCE_UARTD, 30, 2, 65, TEGRA_PERIPH_ON_APB, uartd),
-	TEGRA_INIT_DATA_NODIV("uarte",	NULL, "tegra_uart.4", mux_pllpcm_clkm, CLK_SOURCE_UARTE, 30, 2, 66, TEGRA_PERIPH_ON_APB, uarte),
-	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0",    mux_pllpdc_clkm, CLK_SOURCE_DISP1, 30, 2, 27, 0, disp1),
-	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1",    mux_pllpdc_clkm, CLK_SOURCE_DISP2, 30, 2, 26, 0, disp2),
+	TEGRA_INIT_DATA_NODIV("uarta",	mux_pllpcm_clkm, CLK_SOURCE_UARTA, 30, 2, 6,   TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTA),
+	TEGRA_INIT_DATA_NODIV("uartb",	mux_pllpcm_clkm, CLK_SOURCE_UARTB, 30, 2, 7,   TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTB),
+	TEGRA_INIT_DATA_NODIV("uartc",	mux_pllpcm_clkm, CLK_SOURCE_UARTC, 30, 2, 55,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTC),
+	TEGRA_INIT_DATA_NODIV("uartd",	mux_pllpcm_clkm, CLK_SOURCE_UARTD, 30, 2, 65,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTD),
+	TEGRA_INIT_DATA_NODIV("uarte",	mux_pllpcm_clkm, CLK_SOURCE_UARTE, 30, 2, 66,  TEGRA_PERIPH_ON_APB, TEGRA20_CLK_UARTE),
+	TEGRA_INIT_DATA_NODIV("disp1",	mux_pllpdc_clkm, CLK_SOURCE_DISP1, 30, 2, 27,  0, TEGRA20_CLK_DISP1),
+	TEGRA_INIT_DATA_NODIV("disp2",	mux_pllpdc_clkm, CLK_SOURCE_DISP2, 30, 2, 26,  0, TEGRA20_CLK_DISP2),
 };
 
 static void __init tegra20_periph_clk_init(void)
@@ -836,59 +811,12 @@ static void __init tegra20_periph_clk_init(void)
 	clk = tegra_clk_register_periph_gate("ac97", "pll_a_out0",
 				    TEGRA_PERIPH_ON_APB,
 				    clk_base, 0, 3, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra20-ac97");
-	clks[ac97] = clk;
+	clks[TEGRA20_CLK_AC97] = clk;
 
 	/* apbdma */
 	clk = tegra_clk_register_periph_gate("apbdma", "pclk", 0, clk_base,
 				    0, 34, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "tegra-apbdma");
-	clks[apbdma] = clk;
-
-	/* rtc */
-	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
-				    TEGRA_PERIPH_NO_RESET,
-				    clk_base, 0, 4, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "rtc-tegra");
-	clks[rtc] = clk;
-
-	/* timer */
-	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base,
-				    0, 5, periph_clk_enb_refcnt);
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
-				    TEGRA_PERIPH_NO_RESET,
-				    clk_base, 0, 92, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "csus", "tengra_camera");
-	clks[csus] = clk;
-
-	/* vcp */
-	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0,
-				    clk_base, 0, 29, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "vcp", "tegra-avp");
-	clks[vcp] = clk;
-
-	/* bsea */
-	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0,
-				    clk_base, 0, 62, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "bsea", "tegra-avp");
-	clks[bsea] = clk;
-
-	/* bsev */
-	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0,
-				    clk_base, 0, 63, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "bsev", "tegra-aes");
-	clks[bsev] = clk;
+	clks[TEGRA20_CLK_APBDMA] = clk;
 
 	/* emc */
 	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
@@ -898,85 +826,43 @@ static void __init tegra20_periph_clk_init(void)
 			       30, 2, 0, NULL);
 	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base, 0,
 				    57, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "emc", NULL);
-	clks[emc] = clk;
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
+	clks[TEGRA20_CLK_EMC] = clk;
 
 	/* dsi */
 	clk = tegra_clk_register_periph_gate("dsi", "pll_d", 0, clk_base, 0,
 				    48, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "dsi");
-	clks[dsi] = clk;
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
+	clks[TEGRA20_CLK_DSI] = clk;
 
 	/* pex */
 	clk = tegra_clk_register_periph_gate("pex", "clk_m", 0, clk_base, 0, 70,
 				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "pex", NULL);
-	clks[pex] = clk;
-
-	/* afi */
-	clk = tegra_clk_register_periph_gate("afi", "clk_m", 0, clk_base, 0, 72,
-				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "afi", NULL);
-	clks[afi] = clk;
+	clks[TEGRA20_CLK_PEX] = clk;
 
 	/* pcie_xclk */
 	clk = tegra_clk_register_periph_gate("pcie_xclk", "clk_m", 0, clk_base,
 				    0, 74, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "pcie_xclk", NULL);
-	clks[pcie_xclk] = clk;
+	clks[TEGRA20_CLK_PCIE_XCLK] = clk;
 
 	/* cdev1 */
 	clk = clk_register_fixed_rate(NULL, "cdev1_fixed", NULL, CLK_IS_ROOT,
 				      26000000);
 	clk = tegra_clk_register_periph_gate("cdev1", "cdev1_fixed", 0,
 				    clk_base, 0, 94, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "cdev1", NULL);
-	clks[cdev1] = clk;
+	clks[TEGRA20_CLK_CDEV1] = clk;
 
 	/* cdev2 */
 	clk = clk_register_fixed_rate(NULL, "cdev2_fixed", NULL, CLK_IS_ROOT,
 				      26000000);
 	clk = tegra_clk_register_periph_gate("cdev2", "cdev2_fixed", 0,
 				    clk_base, 0, 93, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "cdev2", NULL);
-	clks[cdev2] = clk;
+	clks[TEGRA20_CLK_CDEV2] = clk;
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
 		data = &tegra_periph_clk_list[i];
 		clk = tegra_clk_register_periph(data->name, data->p.parent_names,
 				data->num_parents, &data->periph,
 				clk_base, data->offset, data->flags);
-		clk_register_clkdev(clk, data->con_id, data->dev_id);
 		clks[data->clk_id] = clk;
 	}
 
@@ -986,37 +872,10 @@ static void __init tegra20_periph_clk_init(void)
 					data->p.parent_names,
 					data->num_parents, &data->periph,
 					clk_base, data->offset);
-		clk_register_clkdev(clk, data->con_id, data->dev_id);
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
-	clk_register_clkdev(clk, "clk_32k", NULL);
-	clks[clk_32k] = clk;
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
-	clk_register_clkdev(clk, "blink", NULL);
-	clks[blink] = clk;
+	tegra_periph_clk_init(clk_base, pmc_base, tegra20_clks, &pll_p_params);
 }
 
 static void __init tegra20_osc_clk_init(void)
@@ -1030,15 +889,13 @@ static void __init tegra20_osc_clk_init(void)
 	/* clk_m */
 	clk = clk_register_fixed_rate(NULL, "clk_m", NULL, CLK_IS_ROOT |
 				      CLK_IGNORE_UNUSED, input_freq);
-	clk_register_clkdev(clk, "clk_m", NULL);
-	clks[clk_m] = clk;
+	clks[TEGRA20_CLK_CLK_M] = clk;
 
 	/* pll_ref */
 	pll_ref_div = tegra20_get_pll_ref_div();
 	clk = clk_register_fixed_factor(NULL, "pll_ref", "clk_m",
 					CLK_SET_RATE_PARENT, 1, pll_ref_div);
-	clk_register_clkdev(clk, "pll_ref", NULL);
-	clks[pll_ref] = clk;
+	clks[TEGRA20_CLK_PLL_REF] = clk;
 }
 
 /* Tegra20 CPU clock and reset control functions */
@@ -1172,49 +1029,49 @@ static struct tegra_cpu_car_ops tegra20_cpu_car_ops = {
 };
 
 static struct tegra_clk_init_table init_table[] __initdata = {
-	{pll_p, clk_max, 216000000, 1},
-	{pll_p_out1, clk_max, 28800000, 1},
-	{pll_p_out2, clk_max, 48000000, 1},
-	{pll_p_out3, clk_max, 72000000, 1},
-	{pll_p_out4, clk_max, 24000000, 1},
-	{pll_c, clk_max, 600000000, 1},
-	{pll_c_out1, clk_max, 120000000, 1},
-	{sclk, pll_c_out1, 0, 1},
-	{hclk, clk_max, 0, 1},
-	{pclk, clk_max, 60000000, 1},
-	{csite, clk_max, 0, 1},
-	{emc, clk_max, 0, 1},
-	{cclk, clk_max, 0, 1},
-	{uarta, pll_p, 0, 0},
-	{uartb, pll_p, 0, 0},
-	{uartc, pll_p, 0, 0},
-	{uartd, pll_p, 0, 0},
-	{uarte, pll_p, 0, 0},
-	{pll_a, clk_max, 56448000, 1},
-	{pll_a_out0, clk_max, 11289600, 1},
-	{cdev1, clk_max, 0, 1},
-	{blink, clk_max, 32768, 1},
-	{i2s1, pll_a_out0, 11289600, 0},
-	{i2s2, pll_a_out0, 11289600, 0},
-	{sdmmc1, pll_p, 48000000, 0},
-	{sdmmc3, pll_p, 48000000, 0},
-	{sdmmc4, pll_p, 48000000, 0},
-	{spi, pll_p, 20000000, 0},
-	{sbc1, pll_p, 100000000, 0},
-	{sbc2, pll_p, 100000000, 0},
-	{sbc3, pll_p, 100000000, 0},
-	{sbc4, pll_p, 100000000, 0},
-	{host1x, pll_c, 150000000, 0},
-	{disp1, pll_p, 600000000, 0},
-	{disp2, pll_p, 600000000, 0},
-	{gr2d, pll_c, 300000000, 0},
-	{gr3d, pll_c, 300000000, 0},
-	{clk_max, clk_max, 0, 0}, /* This MUST be the last entry */
+	{TEGRA20_CLK_PLL_P, TEGRA20_CLK_CLK_MAX, 216000000, 1},
+	{TEGRA20_CLK_PLL_P_OUT1, TEGRA20_CLK_CLK_MAX, 28800000, 1},
+	{TEGRA20_CLK_PLL_P_OUT2, TEGRA20_CLK_CLK_MAX, 48000000, 1},
+	{TEGRA20_CLK_PLL_P_OUT3, TEGRA20_CLK_CLK_MAX, 72000000, 1},
+	{TEGRA20_CLK_PLL_P_OUT4, TEGRA20_CLK_CLK_MAX, 24000000, 1},
+	{TEGRA20_CLK_PLL_C, TEGRA20_CLK_CLK_MAX, 600000000, 1},
+	{TEGRA20_CLK_PLL_C_OUT1, TEGRA20_CLK_CLK_MAX, 120000000, 1},
+	{TEGRA20_CLK_SCLK, TEGRA20_CLK_PLL_C_OUT1, 0, 1},
+	{TEGRA20_CLK_HCLK, TEGRA20_CLK_CLK_MAX, 0, 1},
+	{TEGRA20_CLK_PCLK, TEGRA20_CLK_CLK_MAX, 60000000, 1},
+	{TEGRA20_CLK_CSITE, TEGRA20_CLK_CLK_MAX, 0, 1},
+	{TEGRA20_CLK_EMC, TEGRA20_CLK_CLK_MAX, 0, 1},
+	{TEGRA20_CLK_CCLK, TEGRA20_CLK_CLK_MAX, 0, 1},
+	{TEGRA20_CLK_UARTA, TEGRA20_CLK_PLL_P, 0, 0},
+	{TEGRA20_CLK_UARTB, TEGRA20_CLK_PLL_P, 0, 0},
+	{TEGRA20_CLK_UARTC, TEGRA20_CLK_PLL_P, 0, 0},
+	{TEGRA20_CLK_UARTD, TEGRA20_CLK_PLL_P, 0, 0},
+	{TEGRA20_CLK_UARTE, TEGRA20_CLK_PLL_P, 0, 0},
+	{TEGRA20_CLK_PLL_A, TEGRA20_CLK_CLK_MAX, 56448000, 1},
+	{TEGRA20_CLK_PLL_A_OUT0, TEGRA20_CLK_CLK_MAX, 11289600, 1},
+	{TEGRA20_CLK_CDEV1, TEGRA20_CLK_CLK_MAX, 0, 1},
+	{TEGRA20_CLK_BLINK, TEGRA20_CLK_CLK_MAX, 32768, 1},
+	{TEGRA20_CLK_I2S1, TEGRA20_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA20_CLK_I2S2, TEGRA20_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA20_CLK_SDMMC1, TEGRA20_CLK_PLL_P, 48000000, 0},
+	{TEGRA20_CLK_SDMMC3, TEGRA20_CLK_PLL_P, 48000000, 0},
+	{TEGRA20_CLK_SDMMC4, TEGRA20_CLK_PLL_P, 48000000, 0},
+	{TEGRA20_CLK_SPI, TEGRA20_CLK_PLL_P, 20000000, 0},
+	{TEGRA20_CLK_SBC1, TEGRA20_CLK_PLL_P, 100000000, 0},
+	{TEGRA20_CLK_SBC2, TEGRA20_CLK_PLL_P, 100000000, 0},
+	{TEGRA20_CLK_SBC3, TEGRA20_CLK_PLL_P, 100000000, 0},
+	{TEGRA20_CLK_SBC4, TEGRA20_CLK_PLL_P, 100000000, 0},
+	{TEGRA20_CLK_HOST1X, TEGRA20_CLK_PLL_C, 150000000, 0},
+	{TEGRA20_CLK_DISP1, TEGRA20_CLK_PLL_P, 600000000, 0},
+	{TEGRA20_CLK_DISP2, TEGRA20_CLK_PLL_P, 600000000, 0},
+	{TEGRA20_CLK_GR2D, TEGRA20_CLK_PLL_C, 300000000, 0},
+	{TEGRA20_CLK_GR3D, TEGRA20_CLK_PLL_C, 300000000, 0},
+	{TEGRA20_CLK_CLK_MAX, TEGRA20_CLK_CLK_MAX, 0, 0}, /* This MUST be the last entry */
 };
 
 static void __init tegra20_clock_apply_init_table(void)
 {
-	tegra_init_from_table(init_table, clks, clk_max);
+	tegra_init_from_table(init_table, clks, TEGRA20_CLK_CLK_MAX);
 }
 
 /*
@@ -1223,11 +1080,11 @@ static void __init tegra20_clock_apply_init_table(void)
  * table under two names.
  */
 static struct tegra_clk_duplicate tegra_clk_duplicates[] = {
-	TEGRA_CLK_DUPLICATE(usbd,   "utmip-pad",    NULL),
-	TEGRA_CLK_DUPLICATE(usbd,   "tegra-ehci.0", NULL),
-	TEGRA_CLK_DUPLICATE(usbd,   "tegra-otg",    NULL),
-	TEGRA_CLK_DUPLICATE(cclk,   NULL,           "cpu"),
-	TEGRA_CLK_DUPLICATE(clk_max, NULL, NULL), /* Must be the last entry */
+	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_USBD,   "utmip-pad",    NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_USBD,   "tegra-ehci.0", NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_USBD,   "tegra-otg",    NULL),
+	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_CCLK,   NULL,           "cpu"),
+	TEGRA_CLK_DUPLICATE(TEGRA20_CLK_CLK_MAX, NULL, NULL), /* Must be the last entry */
 };
 
 static const struct of_device_id pmc_match[] __initconst = {
@@ -1257,21 +1114,23 @@ static void __init tegra20_clock_init(struct device_node *np)
 		BUG();
 	}
 
-	clks = tegra_clk_init(clk_max, TEGRA20_CLK_PERIPH_BANKS);
+	clks = tegra_clk_init(TEGRA20_CLK_CLK_MAX, TEGRA20_CLK_PERIPH_BANKS);
 	if (!clks)
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
 
-	tegra_init_dup_clks(tegra_clk_duplicates, clks, clk_max);
+	tegra_init_dup_clks(tegra_clk_duplicates, clks, TEGRA20_CLK_CLK_MAX);
 
 	tegra_add_of_provider(np);
+	tegra_register_devclks(devclks, ARRAY_SIZE(devclks));
 
 	tegra_clk_apply_init_table = tegra20_clock_apply_init_table;
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

