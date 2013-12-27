Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3L0ApJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:45:09 -0500
Received: from mail-pb0-f74.google.com ([209.85.160.74]:54476 "EHLO
	mail-pb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3L0Aov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:44:51 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 5/7] clk: tegra: fix sdmmc clks on Tegra1x4
Date: Thu, 26 Dec 2013 16:44:25 -0800
Message-Id: <1388105067-24438-6-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
References: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sdmmc clocks on Tegra114 and Tegra124 are 3-bit wide muxes with
6 parents.  Add support for tegra_clk_sdmmc*_8 and switch Tegra114
and Tegra124 to use these clocks instead.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clk/tegra/clk-id.h           | 4 ++++
 drivers/clk/tegra/clk-tegra-periph.c | 4 ++++
 drivers/clk/tegra/clk-tegra114.c     | 8 ++++----
 drivers/clk/tegra/clk-tegra124.c     | 8 ++++----
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/tegra/clk-id.h b/drivers/clk/tegra/clk-id.h
index cf0c323..c39613c 100644
--- a/drivers/clk/tegra/clk-id.h
+++ b/drivers/clk/tegra/clk-id.h
@@ -180,9 +180,13 @@ enum clk_id {
 	tegra_clk_sbc6_8,
 	tegra_clk_sclk,
 	tegra_clk_sdmmc1,
+	tegra_clk_sdmmc1_8,
 	tegra_clk_sdmmc2,
+	tegra_clk_sdmmc2_8,
 	tegra_clk_sdmmc3,
+	tegra_clk_sdmmc3_8,
 	tegra_clk_sdmmc4,
+	tegra_clk_sdmmc4_8,
 	tegra_clk_se,
 	tegra_clk_soc_therm,
 	tegra_clk_sor0,
diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index 5c35885..c212473 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -465,6 +465,10 @@ static struct tegra_periph_init_data periph_clks[] = {
 	MUX("adx1", mux_plla_pllc_pllp_clkm, CLK_SOURCE_ADX1, 180, TEGRA_PERIPH_ON_APB, tegra_clk_adx1),
 	MUX("amx1", mux_plla_pllc_pllp_clkm, CLK_SOURCE_AMX1, 185, TEGRA_PERIPH_ON_APB, tegra_clk_amx1),
 	MUX("vi_sensor2", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR2, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor2),
+	MUX8("sdmmc1", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC1, 14, 0, tegra_clk_sdmmc1_8),
+	MUX8("sdmmc2", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC2, 9, 0, tegra_clk_sdmmc2_8),
+	MUX8("sdmmc3", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC3, 69, 0, tegra_clk_sdmmc3_8),
+	MUX8("sdmmc4", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC4, 15, 0, tegra_clk_sdmmc4_8),
 	MUX8("sbc1", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC1, 41, TEGRA_PERIPH_ON_APB, tegra_clk_sbc1_8),
 	MUX8("sbc2", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC2, 44, TEGRA_PERIPH_ON_APB, tegra_clk_sbc2_8),
 	MUX8("sbc3", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC3, 46, TEGRA_PERIPH_ON_APB, tegra_clk_sbc3_8),
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 90d9d25..80431f0 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -682,12 +682,12 @@ static struct tegra_clk tegra114_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_timer] = { .dt_id = TEGRA114_CLK_TIMER, .present = true },
 	[tegra_clk_uarta] = { .dt_id = TEGRA114_CLK_UARTA, .present = true },
 	[tegra_clk_uartd] = { .dt_id = TEGRA114_CLK_UARTD, .present = true },
-	[tegra_clk_sdmmc2] = { .dt_id = TEGRA114_CLK_SDMMC2, .present = true },
+	[tegra_clk_sdmmc2_8] = { .dt_id = TEGRA114_CLK_SDMMC2, .present = true },
 	[tegra_clk_i2s1] = { .dt_id = TEGRA114_CLK_I2S1, .present = true },
 	[tegra_clk_i2c1] = { .dt_id = TEGRA114_CLK_I2C1, .present = true },
 	[tegra_clk_ndflash] = { .dt_id = TEGRA114_CLK_NDFLASH, .present = true },
-	[tegra_clk_sdmmc1] = { .dt_id = TEGRA114_CLK_SDMMC1, .present = true },
-	[tegra_clk_sdmmc4] = { .dt_id = TEGRA114_CLK_SDMMC4, .present = true },
+	[tegra_clk_sdmmc1_8] = { .dt_id = TEGRA114_CLK_SDMMC1, .present = true },
+	[tegra_clk_sdmmc4_8] = { .dt_id = TEGRA114_CLK_SDMMC4, .present = true },
 	[tegra_clk_pwm] = { .dt_id = TEGRA114_CLK_PWM, .present = true },
 	[tegra_clk_i2s0] = { .dt_id = TEGRA114_CLK_I2S0, .present = true },
 	[tegra_clk_i2s2] = { .dt_id = TEGRA114_CLK_I2S2, .present = true },
@@ -723,7 +723,7 @@ static struct tegra_clk tegra114_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_bsev] = { .dt_id = TEGRA114_CLK_BSEV, .present = true },
 	[tegra_clk_i2c3] = { .dt_id = TEGRA114_CLK_I2C3, .present = true },
 	[tegra_clk_sbc4_8] = { .dt_id = TEGRA114_CLK_SBC4, .present = true },
-	[tegra_clk_sdmmc3] = { .dt_id = TEGRA114_CLK_SDMMC3, .present = true },
+	[tegra_clk_sdmmc3_8] = { .dt_id = TEGRA114_CLK_SDMMC3, .present = true },
 	[tegra_clk_owr] = { .dt_id = TEGRA114_CLK_OWR, .present = true },
 	[tegra_clk_csite] = { .dt_id = TEGRA114_CLK_CSITE, .present = true },
 	[tegra_clk_la] = { .dt_id = TEGRA114_CLK_LA, .present = true },
diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 743ccb4..b4cf650 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -761,12 +761,12 @@ static struct tegra_clk tegra124_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_rtc] = { .dt_id = TEGRA124_CLK_RTC, .present = true },
 	[tegra_clk_timer] = { .dt_id = TEGRA124_CLK_TIMER, .present = true },
 	[tegra_clk_uarta] = { .dt_id = TEGRA124_CLK_UARTA, .present = true },
-	[tegra_clk_sdmmc2] = { .dt_id = TEGRA124_CLK_SDMMC2, .present = true },
+	[tegra_clk_sdmmc2_8] = { .dt_id = TEGRA124_CLK_SDMMC2, .present = true },
 	[tegra_clk_i2s1] = { .dt_id = TEGRA124_CLK_I2S1, .present = true },
 	[tegra_clk_i2c1] = { .dt_id = TEGRA124_CLK_I2C1, .present = true },
 	[tegra_clk_ndflash] = { .dt_id = TEGRA124_CLK_NDFLASH, .present = true },
-	[tegra_clk_sdmmc1] = { .dt_id = TEGRA124_CLK_SDMMC1, .present = true },
-	[tegra_clk_sdmmc4] = { .dt_id = TEGRA124_CLK_SDMMC4, .present = true },
+	[tegra_clk_sdmmc1_8] = { .dt_id = TEGRA124_CLK_SDMMC1, .present = true },
+	[tegra_clk_sdmmc4_8] = { .dt_id = TEGRA124_CLK_SDMMC4, .present = true },
 	[tegra_clk_pwm] = { .dt_id = TEGRA124_CLK_PWM, .present = true },
 	[tegra_clk_i2s2] = { .dt_id = TEGRA124_CLK_I2S2, .present = true },
 	[tegra_clk_gr2d] = { .dt_id = TEGRA124_CLK_GR_2D, .present = true },
@@ -802,7 +802,7 @@ static struct tegra_clk tegra124_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_uartd] = { .dt_id = TEGRA124_CLK_UARTD, .present = true },
 	[tegra_clk_i2c3] = { .dt_id = TEGRA124_CLK_I2C3, .present = true },
 	[tegra_clk_sbc4] = { .dt_id = TEGRA124_CLK_SBC4, .present = true },
-	[tegra_clk_sdmmc3] = { .dt_id = TEGRA124_CLK_SDMMC3, .present = true },
+	[tegra_clk_sdmmc3_8] = { .dt_id = TEGRA124_CLK_SDMMC3, .present = true },
 	[tegra_clk_pcie] = { .dt_id = TEGRA124_CLK_PCIE, .present = true },
 	[tegra_clk_owr] = { .dt_id = TEGRA124_CLK_OWR, .present = true },
 	[tegra_clk_afi] = { .dt_id = TEGRA124_CLK_AFI, .present = true },
-- 
1.8.5.1

