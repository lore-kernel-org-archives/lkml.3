Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbaETQpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:45:04 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40120 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaETQnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:43:41 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-77-537b863a9e76
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 2/4] clk: samsung: exynos4: Add CLKOUT clock hierarchy
Date: Tue, 20 May 2014 18:43:29 +0200
Message-id: <1400604211-9447-3-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1400604211-9447-1-git-send-email-t.figa@samsung.com>
References: <1400604211-9447-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xa7pWbdXBBtdfyltMffiEzWL+kXOs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jslh75C67xdLrF5ksnk64yGaxaOsXdospiw6zWrTuPcJu
	sX7GaxaLVbv+MFq0/93L5sDvsWbeGkaPnbPusntsWtXJ5nHn2h42j81L6j36tqxi9Pi8SS6A
	PYrLJiU1J7MstUjfLoErY+b5NraCOaUV/fs2MzYwdiV3MXJySAiYSHzaNo0VwhaTuHBvPRuI
	LSSwlFGi62diFyMXkN3HJDFz+V6wIjYBNYnPDY/AikQEVCU+ty1gByliFpjGIrFqWTs7SEJY
	wE3i0I07LCA2C1DRy8/dYHFeAUeJ9Tc6GSG2yUn0bnvDDGJzCjhJ/Gh/xg6x2VHi2dJO5gmM
	vAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihATu1x2MS49ZHWIU4GBU4uGVSK0KFmJN
	LCuuzD3EKMHBrCTCax9cHSzEm5JYWZValB9fVJqTWnyIkYmDU6qB8biS6/aERzUrvh5ZvfdT
	6+w1mb3FpveuaUqk1F+53cG/YdadNZWe/+IebZx8evnGwGu1LQdfXXdYdHbPBscDB+ojONZ8
	09JivD7hlPoE7snrPm1fUHLh7PVN1bsOTT9V90Pv4r/aC+0b7wrxNskZH+aa9fydaN+aIJ7G
	sNsvJliIdb9e2ZOx5qyfEktxRqKhFnNRcSIAbBW+mDoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds definitions of clocks that are used to drive clock
output signals of particular CMU sub-blocks that are then fed to PMU and
handled by Exynos CLKOUT driver added in further patch.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/clk/samsung/clk-exynos4.c   | 123 ++++++++++++++++++++++++++++++++++++
 include/dt-bindings/clock/exynos4.h |   6 ++
 2 files changed, 129 insertions(+)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 9d13fed..ee23b83 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -25,10 +25,12 @@
 #define DIV_LEFTBUS		0x4500
 #define GATE_IP_LEFTBUS		0x4800
 #define E4X12_GATE_IP_IMAGE	0x4930
+#define CLKOUT_CMU_LEFTBUS	0x4a00
 #define SRC_RIGHTBUS		0x8200
 #define DIV_RIGHTBUS		0x8500
 #define GATE_IP_RIGHTBUS	0x8800
 #define E4X12_GATE_IP_PERIR	0x8960
+#define CLKOUT_CMU_RIGHTBUS	0x8a00
 #define EPLL_LOCK		0xc010
 #define VPLL_LOCK		0xc020
 #define EPLL_CON0		0xc110
@@ -98,6 +100,7 @@
 #define GATE_IP_PERIL		0xc950
 #define E4210_GATE_IP_PERIR	0xc960
 #define GATE_BLOCK		0xc970
+#define CLKOUT_CMU_TOP		0xca00
 #define E4X12_MPLL_LOCK		0x10008
 #define E4X12_MPLL_CON0		0x10108
 #define SRC_DMC			0x10200
@@ -105,6 +108,7 @@
 #define DIV_DMC0		0x10500
 #define DIV_DMC1		0x10504
 #define GATE_IP_DMC		0x10900
+#define CLKOUT_CMU_DMC		0x10a00
 #define APLL_LOCK		0x14000
 #define E4210_MPLL_LOCK		0x14008
 #define APLL_CON0		0x14100
@@ -114,10 +118,12 @@
 #define DIV_CPU1		0x14504
 #define GATE_SCLK_CPU		0x14800
 #define GATE_IP_CPU		0x14900
+#define CLKOUT_CMU_CPU		0x14a00
 #define E4X12_DIV_ISP0		0x18300
 #define E4X12_DIV_ISP1		0x18304
 #define E4X12_GATE_ISP0		0x18800
 #define E4X12_GATE_ISP1		0x18804
+#define E4X12_CLKOUT_CMU_ISP	0x18a00
 
 /* the exynos4 soc type */
 enum exynos4_soc {
@@ -164,6 +170,7 @@ static unsigned long exynos4x12_clk_save[] __initdata = {
 	E4X12_DIV_ISP,
 	E4X12_DIV_CAM1,
 	E4X12_MPLL_CON0,
+	E4X12_CLKOUT_CMU_ISP,
 };
 
 static unsigned long exynos4_clk_pll_regs[] __initdata = {
@@ -242,6 +249,11 @@ static unsigned long exynos4_clk_regs[] __initdata = {
 	DIV_CPU1,
 	GATE_SCLK_CPU,
 	GATE_IP_CPU,
+	CLKOUT_CMU_LEFTBUS,
+	CLKOUT_CMU_RIGHTBUS,
+	CLKOUT_CMU_TOP,
+	CLKOUT_CMU_DMC,
+	CLKOUT_CMU_CPU,
 };
 
 static const struct samsung_clk_reg_dump src_mask_suspend[] = {
@@ -400,6 +412,23 @@ PNAME(mout_dac_p4210)	= { "sclk_vpll", "sclk_hdmiphy", };
 PNAME(mout_pwi_p4210) = { "xxti", "xusbxti", "sclk_hdmi24m", "sclk_usbphy0",
 				"sclk_usbphy1", "sclk_hdmiphy", "none",
 				"sclk_epll", "sclk_vpll" };
+PNAME(clkout_left_p4210) = { "sclk_mpll_div_2", "sclk_apll_div_2",
+				"div_gdl", "div_gpl" };
+PNAME(clkout_right_p4210) = { "sclk_mpll_div_2", "sclk_apll_div_2",
+				"div_gdr", "div_gpr" };
+PNAME(clkout_top_p4210) = { "fout_epll", "fout_vpll", "sclk_hdmi24m",
+				"sclk_usbphy0", "sclk_usbphy1", "sclk_hdmiphy",
+				"cdclk0", "cdclk1", "cdclk2", "spdif_extclk",
+				"aclk160", "aclk133", "aclk200", "aclk100",
+				"sclk_mfc", "sclk_g3d", "sclk_g2d",
+				"cam_a_pclk", "cam_b_pclk", "s_rxbyteclkhs0_2l",
+				"s_rxbyteclkhs0_4l" };
+PNAME(clkout_dmc_p4210) = { "div_dmcd", "div_dmcp", "div_acp_pclk", "div_dmc",
+				"div_dphy", "none", "div_pwi" };
+PNAME(clkout_cpu_p4210) = { "fout_apll_div_2", "none", "fout_mpll_div_2",
+				"none", "arm_clk_div_2", "div_corem0",
+				"div_corem1", "div_corem0", "div_atb",
+				"div_periph", "div_pclk_dbg", "div_hpm" };
 
 /* Exynos 4x12-specific parent groups */
 PNAME(mout_mpll_user_p4x12) = { "fin_pll", "sclk_mpll", };
@@ -426,6 +455,31 @@ PNAME(mout_user_aclk266_gps_p4x12) = {"fin_pll", "div_aclk266_gps", };
 PNAME(mout_pwi_p4x12) = { "xxti", "xusbxti", "sclk_hdmi24m", "sclk_usbphy0",
 				"none", "sclk_hdmiphy", "sclk_mpll",
 				"sclk_epll", "sclk_vpll" };
+PNAME(clkout_left_p4x12) = { "sclk_mpll_user_l_div_2", "sclk_apll_div_2",
+				"div_gdl", "div_gpl" };
+PNAME(clkout_right_p4x12) = { "sclk_mpll_user_r_div_2", "sclk_apll_div_2",
+				"div_gdr", "div_gpr" };
+PNAME(clkout_top_p4x12) = { "fout_epll", "fout_vpll", "sclk_hdmi24m",
+				"sclk_usbphy0", "none", "sclk_hdmiphy",
+				"cdclk0", "cdclk1", "cdclk2", "spdif_extclk",
+				"aclk160", "aclk133", "aclk200", "aclk100",
+				"sclk_mfc", "sclk_g3d", "aclk400_mcuisp",
+				"cam_a_pclk", "cam_b_pclk", "s_rxbyteclkhs0_2l",
+				"s_rxbyteclkhs0_4l", "rx_half_byte_clk_csis0",
+				"rx_half_byte_clk_csis1", "div_jpeg",
+				"sclk_pwm_isp", "sclk_spi0_isp",
+				"sclk_spi1_isp", "sclk_uart_isp",
+				"sclk_mipihsi", "sclk_hdmi", "sclk_fimd0",
+				"sclk_pcm0" };
+PNAME(clkout_dmc_p4x12) = { "div_dmcd", "div_dmcp", "aclk_acp", "div_acp_pclk",
+				"div_dmc", "div_dphy", "fout_mpll_div_2",
+				"div_pwi", "none", "div_c2c", "div_c2c_aclk" };
+PNAME(clkout_cpu_p4x12) = { "fout_apll_div_2", "none", "none", "none",
+				"arm_clk_div_2", "div_corem0", "div_corem1",
+				"div_cores", "div_atb", "div_periph",
+				"div_pclk_dbg", "div_hpm" };
+PNAME(clkout_isp_p4x12) = { "aclk400_mcuisp", "div_mcuisp1", "div_isp0",
+				"div_isp1", "div_mpwm" };
 
 /* fixed rate clocks generated outside the soc */
 static struct samsung_fixed_rate_clock exynos4_fixed_rate_ext_clks[] __initdata = {
@@ -444,6 +498,24 @@ static struct samsung_fixed_rate_clock exynos4210_fixed_rate_clks[] __initdata =
 	FRATE(0, "sclk_usbphy1", NULL, CLK_IS_ROOT, 48000000),
 };
 
+static struct samsung_fixed_factor_clock exynos4_fixed_factor_clks[] __initdata = {
+	FFACTOR(0, "sclk_apll_div_2", "sclk_apll", 1, 2, 0),
+	FFACTOR(0, "fout_mpll_div_2", "fout_mpll", 1, 2, 0),
+	FFACTOR(0, "fout_apll_div_2", "fout_apll", 1, 2, 0),
+	FFACTOR(0, "arm_clk_div_2", "arm_clk", 1, 2, 0),
+};
+
+static struct samsung_fixed_factor_clock exynos4210_fixed_factor_clks[] __initdata = {
+	FFACTOR(0, "sclk_mpll_div_2", "sclk_mpll", 1, 2, 0),
+};
+
+static struct samsung_fixed_factor_clock exynos4x12_fixed_factor_clks[] __initdata = {
+	FFACTOR(0, "sclk_mpll_user_l_div_2", "mout_mpll_user_l", 1, 2, 0),
+	FFACTOR(0, "sclk_mpll_user_r_div_2", "mout_mpll_user_r", 1, 2, 0),
+	FFACTOR(0, "sclk_mpll_user_t_div_2", "mout_mpll_user_t", 1, 2, 0),
+	FFACTOR(0, "sclk_mpll_user_c_div_2", "mout_mpll_user_c", 1, 2, 0),
+};
+
 /* list of mux clocks supported in all exynos4 soc's */
 static struct samsung_mux_clock exynos4_mux_clks[] __initdata = {
 	MUX_FA(CLK_MOUT_APLL, "mout_apll", mout_apll_p, SRC_CPU, 0, 1,
@@ -471,8 +543,12 @@ static struct samsung_mux_clock exynos4210_mux_early[] __initdata = {
 
 static struct samsung_mux_clock exynos4210_mux_clks[] __initdata = {
 	MUX(0, "mout_gdl", sclk_ampll_p4210, SRC_LEFTBUS, 0, 1),
+	MUX(0, "mout_clkout_leftbus", clkout_left_p4210,
+			CLKOUT_CMU_LEFTBUS, 0, 5),
 
 	MUX(0, "mout_gdr", sclk_ampll_p4210, SRC_RIGHTBUS, 0, 1),
+	MUX(0, "mout_clkout_rightbus", clkout_right_p4210,
+			CLKOUT_CMU_RIGHTBUS, 0, 5),
 
 	MUX(0, "mout_aclk200", sclk_ampll_p4210, SRC_TOP0, 12, 1),
 	MUX(0, "mout_aclk100", sclk_ampll_p4210, SRC_TOP0, 16, 1),
@@ -519,20 +595,30 @@ static struct samsung_mux_clock exynos4210_mux_clks[] __initdata = {
 	MUX(0, "mout_spi0", group1_p4210, SRC_PERIL1, 16, 4),
 	MUX(0, "mout_spi1", group1_p4210, SRC_PERIL1, 20, 4),
 	MUX(0, "mout_spi2", group1_p4210, SRC_PERIL1, 24, 4),
+	MUX(0, "mout_clkout_top", clkout_top_p4210, CLKOUT_CMU_TOP, 0, 5),
 
 	MUX(0, "mout_pwi", mout_pwi_p4210, SRC_DMC, 16, 4),
+	MUX(0, "mout_clkout_dmc", clkout_dmc_p4210, CLKOUT_CMU_DMC, 0, 5),
+
+	MUX(0, "mout_clkout_cpu", clkout_cpu_p4210, CLKOUT_CMU_CPU, 0, 5),
 };
 
 /* list of mux clocks supported in exynos4x12 soc */
 static struct samsung_mux_clock exynos4x12_mux_clks[] __initdata = {
 	MUX(0, "mout_mpll_user_l", mout_mpll_p, SRC_LEFTBUS, 4, 1),
 	MUX(0, "mout_gdl", mout_gdl_p4x12, SRC_LEFTBUS, 0, 1),
+	MUX(0, "mout_clkout_leftbus", clkout_left_p4x12,
+			CLKOUT_CMU_LEFTBUS, 0, 5),
 
 	MUX(0, "mout_mpll_user_r", mout_mpll_p, SRC_RIGHTBUS, 4, 1),
 	MUX(0, "mout_gdr", mout_gdr_p4x12, SRC_RIGHTBUS, 0, 1),
+	MUX(0, "mout_clkout_rightbus", clkout_right_p4x12,
+			CLKOUT_CMU_RIGHTBUS, 0, 5),
 
 	MUX(CLK_MOUT_MPLL_USER_C, "mout_mpll_user_c", mout_mpll_user_p4x12,
 			SRC_CPU, 24, 1),
+	MUX(0, "mout_clkout_cpu", clkout_cpu_p4x12, CLKOUT_CMU_CPU, 0, 5),
+
 	MUX(0, "mout_aclk266_gps", aclk_p4412, SRC_TOP1, 4, 1),
 	MUX(0, "mout_aclk400_mcuisp", aclk_p4412, SRC_TOP1, 8, 1),
 	MUX(CLK_MOUT_MPLL_USER_T, "mout_mpll_user_t", mout_mpll_user_p4x12,
@@ -586,24 +672,33 @@ static struct samsung_mux_clock exynos4x12_mux_clks[] __initdata = {
 	MUX(0, "mout_spi0", group1_p4x12, SRC_PERIL1, 16, 4),
 	MUX(0, "mout_spi1", group1_p4x12, SRC_PERIL1, 20, 4),
 	MUX(0, "mout_spi2", group1_p4x12, SRC_PERIL1, 24, 4),
+	MUX(0, "mout_clkout_top", clkout_top_p4x12, CLKOUT_CMU_TOP, 0, 5),
+
 	MUX(0, "mout_pwm_isp", group1_p4x12, E4X12_SRC_ISP, 0, 4),
 	MUX(0, "mout_spi0_isp", group1_p4x12, E4X12_SRC_ISP, 4, 4),
 	MUX(0, "mout_spi1_isp", group1_p4x12, E4X12_SRC_ISP, 8, 4),
 	MUX(0, "mout_uart_isp", group1_p4x12, E4X12_SRC_ISP, 12, 4),
+	MUX(0, "mout_clkout_isp", clkout_isp_p4x12, E4X12_CLKOUT_CMU_ISP, 0, 5),
+
 	MUX(0, "mout_c2c", sclk_ampll_p4210, SRC_DMC, 0, 1),
 	MUX(0, "mout_pwi", mout_pwi_p4x12, SRC_DMC, 16, 4),
 	MUX(0, "mout_g2d0", sclk_ampll_p4210, SRC_DMC, 20, 1),
 	MUX(0, "mout_g2d1", sclk_evpll_p, SRC_DMC, 24, 1),
 	MUX(0, "mout_g2d", mout_g2d_p, SRC_DMC, 28, 1),
+	MUX(0, "mout_clkout_dmc", clkout_dmc_p4x12, CLKOUT_CMU_DMC, 0, 5),
 };
 
 /* list of divider clocks supported in all exynos4 soc's */
 static struct samsung_div_clock exynos4_div_clks[] __initdata = {
 	DIV(0, "div_gdl", "mout_gdl", DIV_LEFTBUS, 0, 3),
 	DIV(0, "div_gpl", "div_gdl", DIV_LEFTBUS, 4, 3),
+	DIV(0, "div_clkout_leftbus", "mout_clkout_leftbus",
+			CLKOUT_CMU_LEFTBUS, 8, 6),
 
 	DIV(0, "div_gdr", "mout_gdr", DIV_RIGHTBUS, 0, 3),
 	DIV(0, "div_gpr", "div_gdr", DIV_RIGHTBUS, 4, 3),
+	DIV(0, "div_clkout_rightbus", "mout_clkout_rightbus",
+			CLKOUT_CMU_RIGHTBUS, 8, 6),
 
 	DIV(0, "div_core", "mout_core", DIV_CPU0, 0, 3),
 	DIV(0, "div_corem0", "div_core2", DIV_CPU0, 4, 3),
@@ -614,6 +709,8 @@ static struct samsung_div_clock exynos4_div_clks[] __initdata = {
 	DIV(0, "div_core2", "div_core", DIV_CPU0, 28, 3),
 	DIV(0, "div_copy", "mout_hpm", DIV_CPU1, 0, 3),
 	DIV(0, "div_hpm", "div_copy", DIV_CPU1, 4, 3),
+	DIV(0, "div_clkout_cpu", "mout_clkout_cpu", CLKOUT_CMU_CPU, 8, 6),
+
 	DIV(0, "div_fimc0", "mout_fimc0", DIV_CAM, 0, 4),
 	DIV(0, "div_fimc1", "mout_fimc1", DIV_CAM, 4, 4),
 	DIV(0, "div_fimc2", "mout_fimc2", DIV_CAM, 8, 4),
@@ -671,6 +768,7 @@ static struct samsung_div_clock exynos4_div_clks[] __initdata = {
 			CLK_SET_RATE_PARENT, 0),
 	DIV_F(0, "div_mmc_pre3", "div_mmc3", DIV_FSYS2, 24, 8,
 			CLK_SET_RATE_PARENT, 0),
+	DIV(0, "div_clkout_top", "mout_clkout_top", CLKOUT_CMU_TOP, 8, 6),
 
 	DIV(0, "div_acp", "mout_dmc_bus", DIV_DMC0, 0, 3),
 	DIV(0, "div_acp_pclk", "div_acp", DIV_DMC0, 4, 3),
@@ -679,6 +777,7 @@ static struct samsung_div_clock exynos4_div_clks[] __initdata = {
 	DIV(0, "div_dmcd", "div_dmc", DIV_DMC0, 16, 3),
 	DIV(0, "div_dmcp", "div_dmcd", DIV_DMC0, 20, 3),
 	DIV(0, "div_pwi", "mout_pwi", DIV_DMC1, 8, 4),
+	DIV(0, "div_clkout_dmc", "mout_clkout_dmc", CLKOUT_CMU_DMC, 8, 6),
 };
 
 /* list of divider clocks supported in exynos4210 soc */
@@ -718,6 +817,8 @@ static struct samsung_div_clock exynos4x12_div_clks[] __initdata = {
 						4, 3, CLK_GET_RATE_NOCACHE, 0),
 	DIV_F(CLK_DIV_MCUISP1, "div_mcuisp1", "div_mcuisp0", E4X12_DIV_ISP1,
 						8, 3, CLK_GET_RATE_NOCACHE, 0),
+	DIV(0, "div_clkout_isp", "mout_clkout_isp", E4X12_CLKOUT_CMU_ISP, 8, 6),
+
 	DIV(CLK_SCLK_FIMG2D, "sclk_fimg2d", "mout_g2d", DIV_DMC1, 0, 4),
 	DIV(0, "div_c2c", "mout_c2c", DIV_DMC1, 4, 3),
 	DIV(0, "div_c2c_aclk", "div_c2c", DIV_DMC1, 12, 3),
@@ -902,6 +1003,17 @@ static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
 			0, 0),
 	GATE(CLK_AC97, "ac97", "aclk100", GATE_IP_PERIL, 27,
 			0, 0),
+
+	GATE(CLK_OUT_LEFTBUS, "clkout_leftbus", "div_clkout_leftbus",
+			CLKOUT_CMU_LEFTBUS, 16, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_OUT_RIGHTBUS, "clkout_rightbus", "div_clkout_rightbus",
+			CLKOUT_CMU_RIGHTBUS, 16, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_OUT_TOP, "clkout_top", "div_clkout_top",
+			CLKOUT_CMU_TOP, 16, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_OUT_DMC, "clkout_dmc", "div_clkout_dmc",
+			CLKOUT_CMU_DMC, 16, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_OUT_CPU, "clkout_cpu", "div_clkout_cpu",
+			CLKOUT_CMU_CPU, 16, CLK_SET_RATE_PARENT, 0),
 };
 
 /* list of gate clocks supported in exynos4210 soc */
@@ -1051,6 +1163,9 @@ static struct samsung_gate_clock exynos4x12_gate_clks[] __initdata = {
 	GATE(CLK_G2D, "g2d", "aclk200", GATE_IP_DMC, 23, 0, 0),
 	GATE(CLK_TMU_APBIF, "tmu_apbif", "aclk100", E4X12_GATE_IP_PERIR, 17, 0,
 		0),
+
+	GATE(CLK_OUT_ISP, "clkout_isp", "div_clkout_isp",
+			E4X12_CLKOUT_CMU_ISP, 16, CLK_SET_RATE_PARENT, 0),
 };
 
 static struct samsung_clock_alias exynos4_aliases[] __initdata = {
@@ -1282,6 +1397,8 @@ static void __init exynos4_clk_init(struct device_node *np,
 			ARRAY_SIZE(exynos4_div_clks));
 	samsung_clk_register_gate(ctx, exynos4_gate_clks,
 			ARRAY_SIZE(exynos4_gate_clks));
+	samsung_clk_register_fixed_factor(ctx, exynos4_fixed_factor_clks,
+			ARRAY_SIZE(exynos4_fixed_factor_clks));
 
 	if (exynos4_soc == EXYNOS4210) {
 		samsung_clk_register_fixed_rate(ctx, exynos4210_fixed_rate_clks,
@@ -1294,6 +1411,9 @@ static void __init exynos4_clk_init(struct device_node *np,
 			ARRAY_SIZE(exynos4210_gate_clks));
 		samsung_clk_register_alias(ctx, exynos4210_aliases,
 			ARRAY_SIZE(exynos4210_aliases));
+		samsung_clk_register_fixed_factor(ctx,
+			exynos4210_fixed_factor_clks,
+			ARRAY_SIZE(exynos4210_fixed_factor_clks));
 	} else {
 		samsung_clk_register_mux(ctx, exynos4x12_mux_clks,
 			ARRAY_SIZE(exynos4x12_mux_clks));
@@ -1303,6 +1423,9 @@ static void __init exynos4_clk_init(struct device_node *np,
 			ARRAY_SIZE(exynos4x12_gate_clks));
 		samsung_clk_register_alias(ctx, exynos4x12_aliases,
 			ARRAY_SIZE(exynos4x12_aliases));
+		samsung_clk_register_fixed_factor(ctx,
+			exynos4x12_fixed_factor_clks,
+			ARRAY_SIZE(exynos4x12_fixed_factor_clks));
 	}
 
 	samsung_clk_register_alias(ctx, exynos4_aliases,
diff --git a/include/dt-bindings/clock/exynos4.h b/include/dt-bindings/clock/exynos4.h
index 1106ca5..b1012db 100644
--- a/include/dt-bindings/clock/exynos4.h
+++ b/include/dt-bindings/clock/exynos4.h
@@ -34,6 +34,12 @@
 #define CLK_MOUT_CORE		19
 #define CLK_MOUT_APLL		20
 #define CLK_SCLK_HDMIPHY	22
+#define CLK_OUT_DMC		23
+#define CLK_OUT_TOP		24
+#define CLK_OUT_LEFTBUS		25
+#define CLK_OUT_RIGHTBUS	26
+#define CLK_OUT_CPU		27
+#define CLK_OUT_ISP		28
 
 /* gate for special clocks (sclk) */
 #define CLK_SCLK_FIMC0		128
-- 
1.9.3

