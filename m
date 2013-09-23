Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab3IWOd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:33:58 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:4419 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3IWOd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:33:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Sep 2013 07:33:56 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v2 06/12] clk: tegra: add common infra for DT clocks
Date: Mon, 23 Sep 2013 17:24:58 +0300
Message-ID: <1379946381-20125-7-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1379946381-20125-1-git-send-email-pdeschrijver@nvidia.com>
References: <1379946381-20125-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a common infrastructure for sharing clock initialization between
SoCs. Move Tegra114 to this new infrastructure.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c |  181 ++++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.c          |    9 ++
 drivers/clk/tegra/clk.h          |    7 ++
 3 files changed, 197 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index b3210c8..90ae909 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -26,6 +26,7 @@
 #include <dt-bindings/clock/tegra114-car.h>
 
 #include "clk.h"
+#include "clk-id.h"
 
 #define RST_DFLL_DVCO			0x2F4
 #define CPU_FINETRIM_SELECT		0x4d4	/* override default prop dlys */
@@ -932,6 +933,186 @@ static const struct clk_div_table pll_re_div_table[] = {
 	{ .val = 0, .div = 0 },
 };
 
+static struct tegra_clk __initdata tegra114_clks[tegra_clk_max] = {
+	[tegra_clk_rtc] = { .dt_id = TEGRA114_CLK_RTC, .present = true },
+	[tegra_clk_timer] = { .dt_id = TEGRA114_CLK_TIMER, .present = true },
+	[tegra_clk_uarta] = { .dt_id = TEGRA114_CLK_UARTA, .present = true },
+	[tegra_clk_uartd] = { .dt_id = TEGRA114_CLK_UARTD, .present = true },
+	[tegra_clk_sdmmc2] = { .dt_id = TEGRA114_CLK_SDMMC2, .present = true },
+	[tegra_clk_i2s1] = { .dt_id = TEGRA114_CLK_I2S1, .present = true },
+	[tegra_clk_i2c1] = { .dt_id = TEGRA114_CLK_I2C1, .present = true },
+	[tegra_clk_ndflash] = { .dt_id = TEGRA114_CLK_NDFLASH, .present = true },
+	[tegra_clk_sdmmc1] = { .dt_id = TEGRA114_CLK_SDMMC1, .present = true },
+	[tegra_clk_sdmmc4] = { .dt_id = TEGRA114_CLK_SDMMC4, .present = true },
+	[tegra_clk_pwm] = { .dt_id = TEGRA114_CLK_PWM, .present = true },
+	[tegra_clk_i2s0] = { .dt_id = TEGRA114_CLK_I2S0, .present = true },
+	[tegra_clk_i2s2] = { .dt_id = TEGRA114_CLK_I2S2, .present = true },
+	[tegra_clk_epp] = { .dt_id = TEGRA114_CLK_EPP, .present = true },
+	[tegra_clk_gr_2d] = { .dt_id = TEGRA114_CLK_GR_2D, .present = true },
+	[tegra_clk_usbd] = { .dt_id = TEGRA114_CLK_USBD, .present = true },
+	[tegra_clk_isp] = { .dt_id = TEGRA114_CLK_ISP, .present = true },
+	[tegra_clk_gr_3d] = { .dt_id = TEGRA114_CLK_GR_3D, .present = true },
+	[tegra_clk_disp2] = { .dt_id = TEGRA114_CLK_DISP2, .present = true },
+	[tegra_clk_disp1] = { .dt_id = TEGRA114_CLK_DISP1, .present = true },
+	[tegra_clk_host1x] = { .dt_id = TEGRA114_CLK_HOST1X, .present = true },
+	[tegra_clk_vcp] = { .dt_id = TEGRA114_CLK_VCP, .present = true },
+	[tegra_clk_apbdma] = { .dt_id = TEGRA114_CLK_APBDMA, .present = true },
+	[tegra_clk_kbc] = { .dt_id = TEGRA114_CLK_KBC, .present = true },
+	[tegra_clk_kfuse] = { .dt_id = TEGRA114_CLK_KFUSE, .present = true },
+	[tegra_clk_sbc1] = { .dt_id = TEGRA114_CLK_SBC1, .present = true },
+	[tegra_clk_nor] = { .dt_id = TEGRA114_CLK_NOR, .present = true },
+	[tegra_clk_sbc2] = { .dt_id = TEGRA114_CLK_SBC2, .present = true },
+	[tegra_clk_sbc3] = { .dt_id = TEGRA114_CLK_SBC3, .present = true },
+	[tegra_clk_i2c5] = { .dt_id = TEGRA114_CLK_I2C5, .present = true },
+	[tegra_clk_dsia] = { .dt_id = TEGRA114_CLK_DSIA, .present = true },
+	[tegra_clk_mipi] = { .dt_id = TEGRA114_CLK_MIPI, .present = true },
+	[tegra_clk_hdmi] = { .dt_id = TEGRA114_CLK_HDMI, .present = true },
+	[tegra_clk_csi] = { .dt_id = TEGRA114_CLK_CSI, .present = true },
+	[tegra_clk_i2c2] = { .dt_id = TEGRA114_CLK_I2C2, .present = true },
+	[tegra_clk_uartc] = { .dt_id = TEGRA114_CLK_UARTC, .present = true },
+	[tegra_clk_mipi_cal] = { .dt_id = TEGRA114_CLK_MIPI_CAL, .present = true },
+	[tegra_clk_emc] = { .dt_id = TEGRA114_CLK_EMC, .present = true },
+	[tegra_clk_usb2] = { .dt_id = TEGRA114_CLK_USB2, .present = true },
+	[tegra_clk_usb3] = { .dt_id = TEGRA114_CLK_USB3, .present = true },
+	[tegra_clk_vde] = { .dt_id = TEGRA114_CLK_VDE, .present = true },
+	[tegra_clk_bsea] = { .dt_id = TEGRA114_CLK_BSEA, .present = true },
+	[tegra_clk_bsev] = { .dt_id = TEGRA114_CLK_BSEV, .present = true },
+	[tegra_clk_i2c3] = { .dt_id = TEGRA114_CLK_I2C3, .present = true },
+	[tegra_clk_sbc4] = { .dt_id = TEGRA114_CLK_SBC4, .present = true },
+	[tegra_clk_sdmmc3] = { .dt_id = TEGRA114_CLK_SDMMC3, .present = true },
+	[tegra_clk_owr] = { .dt_id = TEGRA114_CLK_OWR, .present = true },
+	[tegra_clk_csite] = { .dt_id = TEGRA114_CLK_CSITE, .present = true },
+	[tegra_clk_la] = { .dt_id = TEGRA114_CLK_LA, .present = true },
+	[tegra_clk_trace] = { .dt_id = TEGRA114_CLK_TRACE, .present = true },
+	[tegra_clk_soc_therm] = { .dt_id = TEGRA114_CLK_SOC_THERM, .present = true },
+	[tegra_clk_dtv] = { .dt_id = TEGRA114_CLK_DTV, .present = true },
+	[tegra_clk_ndspeed] = { .dt_id = TEGRA114_CLK_NDSPEED, .present = true },
+	[tegra_clk_i2cslow] = { .dt_id = TEGRA114_CLK_I2CSLOW, .present = true },
+	[tegra_clk_dsib] = { .dt_id = TEGRA114_CLK_DSIB, .present = true },
+	[tegra_clk_tsec] = { .dt_id = TEGRA114_CLK_TSEC, .present = true },
+	[tegra_clk_xusb_host] = { .dt_id = TEGRA114_CLK_XUSB_HOST, .present = true },
+	[tegra_clk_msenc] = { .dt_id = TEGRA114_CLK_MSENC, .present = true },
+	[tegra_clk_csus] = { .dt_id = TEGRA114_CLK_CSUS, .present = true },
+	[tegra_clk_mselect] = { .dt_id = TEGRA114_CLK_MSELECT, .present = true },
+	[tegra_clk_tsensor] = { .dt_id = TEGRA114_CLK_TSENSOR, .present = true },
+	[tegra_clk_i2s3] = { .dt_id = TEGRA114_CLK_I2S3, .present = true },
+	[tegra_clk_i2s4] = { .dt_id = TEGRA114_CLK_I2S4, .present = true },
+	[tegra_clk_i2c4] = { .dt_id = TEGRA114_CLK_I2C4, .present = true },
+	[tegra_clk_sbc5] = { .dt_id = TEGRA114_CLK_SBC5, .present = true },
+	[tegra_clk_sbc6] = { .dt_id = TEGRA114_CLK_SBC6, .present = true },
+	[tegra_clk_d_audio] = { .dt_id = TEGRA114_CLK_D_AUDIO, .present = true },
+	[tegra_clk_apbif] = { .dt_id = TEGRA114_CLK_APBIF, .present = true },
+	[tegra_clk_dam0] = { .dt_id = TEGRA114_CLK_DAM0, .present = true },
+	[tegra_clk_dam1] = { .dt_id = TEGRA114_CLK_DAM1, .present = true },
+	[tegra_clk_dam2] = { .dt_id = TEGRA114_CLK_DAM2, .present = true },
+	[tegra_clk_hda2codec_2x] = { .dt_id = TEGRA114_CLK_HDA2CODEC_2X, .present = true },
+	[tegra_clk_audio0_2x] = { .dt_id = TEGRA114_CLK_AUDIO0_2X, .present = true },
+	[tegra_clk_audio1_2x] = { .dt_id = TEGRA114_CLK_AUDIO1_2X, .present = true },
+	[tegra_clk_audio2_2x] = { .dt_id = TEGRA114_CLK_AUDIO2_2X, .present = true },
+	[tegra_clk_audio3_2x] = { .dt_id = TEGRA114_CLK_AUDIO3_2X, .present = true },
+	[tegra_clk_audio4_2x] = { .dt_id = TEGRA114_CLK_AUDIO4_2X, .present = true },
+	[tegra_clk_spdif_2x] = { .dt_id = TEGRA114_CLK_SPDIF_2X, .present = true },
+	[tegra_clk_actmon] = { .dt_id = TEGRA114_CLK_ACTMON, .present = true },
+	[tegra_clk_extern1] = { .dt_id = TEGRA114_CLK_EXTERN1, .present = true },
+	[tegra_clk_extern2] = { .dt_id = TEGRA114_CLK_EXTERN2, .present = true },
+	[tegra_clk_extern3] = { .dt_id = TEGRA114_CLK_EXTERN3, .present = true },
+	[tegra_clk_hda] = { .dt_id = TEGRA114_CLK_HDA, .present = true },
+	[tegra_clk_se] = { .dt_id = TEGRA114_CLK_SE, .present = true },
+	[tegra_clk_hda2hdmi] = { .dt_id = TEGRA114_CLK_HDA2HDMI, .present = true },
+	[tegra_clk_cilab] = { .dt_id = TEGRA114_CLK_CILAB, .present = true },
+	[tegra_clk_cilcd] = { .dt_id = TEGRA114_CLK_CILCD, .present = true },
+	[tegra_clk_cile] = { .dt_id = TEGRA114_CLK_CILE, .present = true },
+	[tegra_clk_dsialp] = { .dt_id = TEGRA114_CLK_DSIALP, .present = true },
+	[tegra_clk_dsiblp] = { .dt_id = TEGRA114_CLK_DSIBLP, .present = true },
+	[tegra_clk_dds] = { .dt_id = TEGRA114_CLK_DDS, .present = true },
+	[tegra_clk_dp2] = { .dt_id = TEGRA114_CLK_DP2, .present = true },
+	[tegra_clk_amx] = { .dt_id = TEGRA114_CLK_AMX, .present = true },
+	[tegra_clk_adx] = { .dt_id = TEGRA114_CLK_ADX, .present = true },
+	[tegra_clk_xusb_ss] = { .dt_id = TEGRA114_CLK_XUSB_SS, .present = true },
+	[tegra_clk_uartb] = { .dt_id = TEGRA114_CLK_UARTB, .present = true },
+	[tegra_clk_vfir] = { .dt_id = TEGRA114_CLK_VFIR, .present = true },
+	[tegra_clk_spdif_in] = { .dt_id = TEGRA114_CLK_SPDIF_IN, .present = true },
+	[tegra_clk_spdif_out] = { .dt_id = TEGRA114_CLK_SPDIF_OUT, .present = true },
+	[tegra_clk_vi] = { .dt_id = TEGRA114_CLK_VI, .present = true },
+	[tegra_clk_vi_sensor] = { .dt_id = TEGRA114_CLK_VI_SENSOR, .present = true },
+	[tegra_clk_fuse] = { .dt_id = TEGRA114_CLK_FUSE, .present = true },
+	[tegra_clk_fuse_burn] = { .dt_id = TEGRA114_CLK_FUSE_BURN, .present = true },
+	[tegra_clk_clk_32k] = { .dt_id = TEGRA114_CLK_CLK_32K, .present = true },
+	[tegra_clk_clk_m] = { .dt_id = TEGRA114_CLK_CLK_M, .present = true },
+	[tegra_clk_clk_m_div2] = { .dt_id = TEGRA114_CLK_CLK_M_DIV2, .present = true },
+	[tegra_clk_clk_m_div4] = { .dt_id = TEGRA114_CLK_CLK_M_DIV4, .present = true },
+	[tegra_clk_pll_ref] = { .dt_id = TEGRA114_CLK_PLL_REF, .present = true },
+	[tegra_clk_pll_c] = { .dt_id = TEGRA114_CLK_PLL_C, .present = true },
+	[tegra_clk_pll_c_out1] = { .dt_id = TEGRA114_CLK_PLL_C_OUT1, .present = true },
+	[tegra_clk_pll_c2] = { .dt_id = TEGRA114_CLK_PLL_C2, .present = true },
+	[tegra_clk_pll_c3] = { .dt_id = TEGRA114_CLK_PLL_C3, .present = true },
+	[tegra_clk_pll_m] = { .dt_id = TEGRA114_CLK_PLL_M, .present = true },
+	[tegra_clk_pll_m_out1] = { .dt_id = TEGRA114_CLK_PLL_M_OUT1, .present = true },
+	[tegra_clk_pll_p] = { .dt_id = TEGRA114_CLK_PLL_P, .present = true },
+	[tegra_clk_pll_p_out1] = { .dt_id = TEGRA114_CLK_PLL_P_OUT1, .present = true },
+	[tegra_clk_pll_p_out2] = { .dt_id = TEGRA114_CLK_PLL_P_OUT2, .present = true },
+	[tegra_clk_pll_p_out3] = { .dt_id = TEGRA114_CLK_PLL_P_OUT3, .present = true },
+	[tegra_clk_pll_p_out4] = { .dt_id = TEGRA114_CLK_PLL_P_OUT4, .present = true },
+	[tegra_clk_pll_a] = { .dt_id = TEGRA114_CLK_PLL_A, .present = true },
+	[tegra_clk_pll_a_out0] = { .dt_id = TEGRA114_CLK_PLL_A_OUT0, .present = true },
+	[tegra_clk_pll_d] = { .dt_id = TEGRA114_CLK_PLL_D, .present = true },
+	[tegra_clk_pll_d_out0] = { .dt_id = TEGRA114_CLK_PLL_D_OUT0, .present = true },
+	[tegra_clk_pll_d2] = { .dt_id = TEGRA114_CLK_PLL_D2, .present = true },
+	[tegra_clk_pll_d2_out0] = { .dt_id = TEGRA114_CLK_PLL_D2_OUT0, .present = true },
+	[tegra_clk_pll_u] = { .dt_id = TEGRA114_CLK_PLL_U, .present = true },
+	[tegra_clk_pll_u_480m] = { .dt_id = TEGRA114_CLK_PLL_U_480M, .present = true },
+	[tegra_clk_pll_u_60m] = { .dt_id = TEGRA114_CLK_PLL_U_60M, .present = true },
+	[tegra_clk_pll_u_48m] = { .dt_id = TEGRA114_CLK_PLL_U_48M, .present = true },
+	[tegra_clk_pll_u_12m] = { .dt_id = TEGRA114_CLK_PLL_U_12M, .present = true },
+	[tegra_clk_pll_x] = { .dt_id = TEGRA114_CLK_PLL_X, .present = true },
+	[tegra_clk_pll_x_out0] = { .dt_id = TEGRA114_CLK_PLL_X_OUT0, .present = true },
+	[tegra_clk_pll_re_vco] = { .dt_id = TEGRA114_CLK_PLL_RE_VCO, .present = true },
+	[tegra_clk_pll_re_out] = { .dt_id = TEGRA114_CLK_PLL_RE_OUT, .present = true },
+	[tegra_clk_pll_e_out0] = { .dt_id = TEGRA114_CLK_PLL_E_OUT0, .present = true },
+	[tegra_clk_spdif_in_sync] = { .dt_id = TEGRA114_CLK_SPDIF_IN_SYNC, .present = true },
+	[tegra_clk_i2s0_sync] = { .dt_id = TEGRA114_CLK_I2S0_SYNC, .present = true },
+	[tegra_clk_i2s1_sync] = { .dt_id = TEGRA114_CLK_I2S1_SYNC, .present = true },
+	[tegra_clk_i2s2_sync] = { .dt_id = TEGRA114_CLK_I2S2_SYNC, .present = true },
+	[tegra_clk_i2s3_sync] = { .dt_id = TEGRA114_CLK_I2S3_SYNC, .present = true },
+	[tegra_clk_i2s4_sync] = { .dt_id = TEGRA114_CLK_I2S4_SYNC, .present = true },
+	[tegra_clk_vimclk_sync] = { .dt_id = TEGRA114_CLK_VIMCLK_SYNC, .present = true },
+	[tegra_clk_audio0] = { .dt_id = TEGRA114_CLK_AUDIO0, .present = true },
+	[tegra_clk_audio1] = { .dt_id = TEGRA114_CLK_AUDIO1, .present = true },
+	[tegra_clk_audio2] = { .dt_id = TEGRA114_CLK_AUDIO2, .present = true },
+	[tegra_clk_audio3] = { .dt_id = TEGRA114_CLK_AUDIO3, .present = true },
+	[tegra_clk_audio4] = { .dt_id = TEGRA114_CLK_AUDIO4, .present = true },
+	[tegra_clk_spdif] = { .dt_id = TEGRA114_CLK_SPDIF, .present = true },
+	[tegra_clk_clk_out_1] = { .dt_id = TEGRA114_CLK_CLK_OUT_1, .present = true },
+	[tegra_clk_clk_out_2] = { .dt_id = TEGRA114_CLK_CLK_OUT_2, .present = true },
+	[tegra_clk_clk_out_3] = { .dt_id = TEGRA114_CLK_CLK_OUT_3, .present = true },
+	[tegra_clk_blink] = { .dt_id = TEGRA114_CLK_BLINK, .present = true },
+	[tegra_clk_xusb_host_src] = { .dt_id = TEGRA114_CLK_XUSB_HOST_SRC, .present = true },
+	[tegra_clk_xusb_falcon_src] = { .dt_id = TEGRA114_CLK_XUSB_FALCON_SRC, .present = true },
+	[tegra_clk_xusb_fs_src] = { .dt_id = TEGRA114_CLK_XUSB_FS_SRC, .present = true },
+	[tegra_clk_xusb_ss_src] = { .dt_id = TEGRA114_CLK_XUSB_SS_SRC, .present = true },
+	[tegra_clk_xusb_dev_src] = { .dt_id = TEGRA114_CLK_XUSB_DEV_SRC, .present = true },
+	[tegra_clk_xusb_dev] = { .dt_id = TEGRA114_CLK_XUSB_DEV, .present = true },
+	[tegra_clk_xusb_hs_src] = { .dt_id = TEGRA114_CLK_XUSB_HS_SRC, .present = true },
+	[tegra_clk_sclk] = { .dt_id = TEGRA114_CLK_SCLK, .present = true },
+	[tegra_clk_hclk] = { .dt_id = TEGRA114_CLK_HCLK, .present = true },
+	[tegra_clk_pclk] = { .dt_id = TEGRA114_CLK_PCLK, .present = true },
+	[tegra_clk_cclk_g] = { .dt_id = TEGRA114_CLK_CCLK_G, .present = true },
+	[tegra_clk_cclk_lp] = { .dt_id = TEGRA114_CLK_CCLK_LP, .present = true },
+	[tegra_clk_dfll_ref] = { .dt_id = TEGRA114_CLK_DFLL_REF, .present = true },
+	[tegra_clk_dfll_soc] = { .dt_id = TEGRA114_CLK_DFLL_SOC, .present = true },
+	[tegra_clk_audio0_mux] = { .dt_id = TEGRA114_CLK_AUDIO0_MUX, .present = true },
+	[tegra_clk_audio1_mux] = { .dt_id = TEGRA114_CLK_AUDIO1_MUX, .present = true },
+	[tegra_clk_audio2_mux] = { .dt_id = TEGRA114_CLK_AUDIO2_MUX, .present = true },
+	[tegra_clk_audio3_mux] = { .dt_id = TEGRA114_CLK_AUDIO3_MUX, .present = true },
+	[tegra_clk_audio4_mux] = { .dt_id = TEGRA114_CLK_AUDIO4_MUX, .present = true },
+	[tegra_clk_spdif_mux] = { .dt_id = TEGRA114_CLK_SPDIF_MUX, .present = true },
+	[tegra_clk_clk_out_1_mux] = { .dt_id = TEGRA114_CLK_CLK_OUT_1_MUX, .present = true },
+	[tegra_clk_clk_out_2_mux] = { .dt_id = TEGRA114_CLK_CLK_OUT_2_MUX, .present = true },
+	[tegra_clk_clk_out_3_mux] = { .dt_id = TEGRA114_CLK_CLK_OUT_3_MUX, .present = true },
+	[tegra_clk_dsia_mux] = { .dt_id = TEGRA114_CLK_DSIA_MUX, .present = true },
+	[tegra_clk_dsib_mux] = { .dt_id = TEGRA114_CLK_DSIB_MUX, .present = true },
+};
+
 static struct clk **clks;
 
 static unsigned long osc_freq;
diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index 1253217..c8c84ce 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -214,6 +214,15 @@ void __init tegra_add_of_provider(struct device_node *np)
 	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
 }
 
+struct clk ** __init tegra_lookup_dt_id(int clk_id,
+					struct tegra_clk *tegra_clk)
+{
+	if (tegra_clk[clk_id].present)
+		return &clks[tegra_clk[clk_id].dt_id];
+	else
+		return NULL;
+}
+
 tegra_clk_apply_init_table_func tegra_clk_apply_init_table;
 
 void __init tegra_clocks_apply_init_table(void)
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 7ddd407..1244010 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -582,6 +582,11 @@ struct tegra_clk_duplicate {
 		},				\
 	}
 
+struct tegra_clk {
+	int			dt_id;
+	bool			present;
+};
+
 void tegra_init_from_table(struct tegra_clk_init_table *tbl,
 		struct clk *clks[], int clk_max);
 
@@ -591,6 +596,8 @@ void tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 struct tegra_clk_periph_regs *get_reg_bank(int clkid);
 struct clk **tegra_clk_init(int num, int periph_banks);
 
+struct clk **tegra_lookup_dt_id(int clk_id, struct tegra_clk *tegra_clk);
+
 void tegra_add_of_provider(struct device_node *np);
 
 void tegra114_clock_tune_cpu_trimmers_high(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

