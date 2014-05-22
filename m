Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaEVQZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:25:20 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:58979 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaEVQZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:25:13 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sboyd@codeaurora.org, rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v1 3/5] clk: gcc: Add APQ8084 Global Clock Controller support
Date: Thu, 22 May 2014 19:24:43 +0300
Message-Id: <1400775885-10296-4-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400775885-10296-1-git-send-email-gdjakov@mm-sol.com>
References: <1400775885-10296-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the global clock controller found on
the APQ8084 based devices.

The APQ8084 and MSM8974 share a lot of clock data, so instead of
duplicating all the data, we add support to the MSM8974 code.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/clk/qcom/Kconfig                     |    4 +-
 drivers/clk/qcom/gcc-msm8974.c               |  151 +++++++++++++++++++++++++-
 include/dt-bindings/clock/qcom,gcc-msm8974.h |    4 +
 3 files changed, 154 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 7f696b7..00541e7 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -30,10 +30,10 @@ config MSM_MMCC_8960
 	  graphics, video encode/decode, camera, etc.
 
 config MSM_GCC_8974
-	tristate "MSM8974 Global Clock Controller"
+	tristate "APQ8084/MSM8974 Global Clock Controller"
 	depends on COMMON_CLK_QCOM
 	help
-	  Support for the global clock controller on msm8974 devices.
+	  Support for the global clock controller on apq8084/msm8974 devices.
 	  Say Y if you want to use peripheral devices such as UART, SPI,
 	  i2c, USB, SD/eMMC, SATA, PCIe, etc.
 
diff --git a/drivers/clk/qcom/gcc-msm8974.c b/drivers/clk/qcom/gcc-msm8974.c
index 58cb2f5..c2a8d77 100644
--- a/drivers/clk/qcom/gcc-msm8974.c
+++ b/drivers/clk/qcom/gcc-msm8974.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -204,6 +204,12 @@ static const struct freq_tbl ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk[] = {
 	{ }
 };
 
+static const struct freq_tbl ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk_apq8084[] = {
+	F(19200000, P_XO, 1, 0, 0),
+	F(50000000, P_GPLL0, 12, 0, 0),
+	{ }
+};
+
 static struct clk_rcg2 blsp1_qup1_i2c_apps_clk_src = {
 	.cmd_rcgr = 0x0660,
 	.hid_width = 5,
@@ -768,6 +774,27 @@ static struct clk_rcg2 ce2_clk_src = {
 	},
 };
 
+static const struct freq_tbl ftbl_gcc_ce3_clk_apq8084[] = {
+	F(50000000, P_GPLL0, 12, 0, 0),
+	F(85710000, P_GPLL0, 7, 0, 0),
+	F(100000000, P_GPLL0, 6, 0, 0),
+	F(171430000, P_GPLL0, 3.5, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 ce3_clk_src_apq8084 = {
+	.cmd_rcgr = 0x1d10,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_ce3_clk_apq8084,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "ce3_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
 static const struct freq_tbl ftbl_gcc_gp_clk[] = {
 	F(4800000, P_XO, 4, 0, 0),
 	F(6000000, P_GPLL0, 10, 1, 10),
@@ -780,6 +807,12 @@ static const struct freq_tbl ftbl_gcc_gp_clk[] = {
 	{ }
 };
 
+static const struct freq_tbl ftbl_gcc_gp_clk_apq8084[] = {
+	F(19200000, P_XO, 1, 0, 0),
+	F(100000000, P_GPLL0, 6, 0, 0),
+	F(200000000, P_GPLL0, 3, 0, 0),
+	{ }
+};
 
 static struct clk_rcg2 gp1_clk_src = {
 	.cmd_rcgr = 0x1904,
@@ -966,6 +999,11 @@ static const struct freq_tbl ftbl_gcc_usb_hs_system_clk[] = {
 	{ }
 };
 
+static const struct freq_tbl ftbl_gcc_usb_hs_system_clk_apq8084[] = {
+	F(75000000, P_GPLL0, 8, 0, 0),
+	{ }
+};
+
 static struct clk_rcg2 usb_hs_system_clk_src = {
 	.cmd_rcgr = 0x0490,
 	.hid_width = 5,
@@ -1029,6 +1067,11 @@ static const struct freq_tbl ftbl_gcc_usb_hsic_system_clk[] = {
 	{ }
 };
 
+static const struct freq_tbl ftbl_gcc_usb_hsic_system_clk_apq8084[] = {
+	F(75000000, P_GPLL0, 8, 0, 0),
+	{ }
+};
+
 static struct clk_rcg2 usb_hsic_system_clk_src = {
 	.cmd_rcgr = 0x041c,
 	.hid_width = 5,
@@ -1838,6 +1881,58 @@ static struct clk_branch gcc_ce2_clk = {
 	},
 };
 
+static struct clk_branch gcc_ce3_ahb_clk_apq8084 = {
+	.halt_reg = 0x1d0c,
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1d0c,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_ce3_ahb_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ce3_axi_clk_apq8084 = {
+	.halt_reg = 0x1088,
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1d08,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_ce3_axi_clk",
+			.parent_names = (const char *[]){
+				"system_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ce3_clk_apq8084 = {
+	.halt_reg = 0x1090,
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1d04,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_ce3_clk",
+			.parent_names = (const char *[]){
+				"ce3_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
 static struct clk_branch gcc_gp1_clk = {
 	.halt_reg = 0x1900,
 	.clkr = {
@@ -2575,6 +2670,10 @@ static struct clk_regmap *gcc_msm8974_clocks[] = {
 	[GPLL4_VOTE] = NULL,
 	[GCC_SDCC1_CDCCAL_SLEEP_CLK] = NULL,
 	[GCC_SDCC1_CDCCAL_FF_CLK] = NULL,
+	[CE3_CLK_SRC] = NULL,
+	[GCC_CE3_AHB_CLK] = NULL,
+	[GCC_CE3_AXI_CLK] = NULL,
+	[GCC_CE3_CLK] = NULL,
 };
 
 static const struct qcom_reset_map gcc_msm8974_resets[] = {
@@ -2689,12 +2788,58 @@ static void msm8974_pro_clock_override(void)
 		&gcc_sdcc1_cdccal_ff_clk.clkr;
 }
 
+static void apq8084_clock_override(void)
+{
+	sdcc1_apps_clk_src_init.parent_names = gcc_xo_gpll0_gpll4;
+	sdcc1_apps_clk_src_init.num_parents = 3;
+	sdcc1_apps_clk_src.freq_tbl = ftbl_gcc_sdcc1_apps_clk_pro;
+	sdcc1_apps_clk_src.parent_map = gcc_xo_gpll0_gpll4_map;
+
+	gcc_msm8974_clocks[GPLL4] = &gpll4.clkr;
+	gcc_msm8974_clocks[GPLL4_VOTE] = &gpll4_vote;
+	gcc_msm8974_clocks[GCC_SDCC1_CDCCAL_SLEEP_CLK] =
+		&gcc_sdcc1_cdccal_sleep_clk.clkr;
+	gcc_msm8974_clocks[GCC_SDCC1_CDCCAL_FF_CLK] =
+		&gcc_sdcc1_cdccal_ff_clk.clkr;
+
+	blsp1_qup1_i2c_apps_clk_src.freq_tbl =
+		ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk_apq8084;
+	blsp1_qup2_i2c_apps_clk_src.freq_tbl =
+		ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk_apq8084;
+	blsp1_qup3_i2c_apps_clk_src.freq_tbl =
+		ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk_apq8084;
+	blsp1_qup4_i2c_apps_clk_src.freq_tbl =
+		ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk_apq8084;
+	blsp1_qup5_i2c_apps_clk_src.freq_tbl =
+		ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk_apq8084;
+	blsp1_qup6_i2c_apps_clk_src.freq_tbl =
+		ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk_apq8084;
+	blsp2_qup1_i2c_apps_clk_src.freq_tbl =
+		ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk_apq8084;
+	usb_hsic_system_clk_src.freq_tbl =
+		ftbl_gcc_usb_hsic_system_clk_apq8084;
+	usb_hs_system_clk_src.freq_tbl = ftbl_gcc_usb_hs_system_clk_apq8084;
+
+	gcc_msm8974_clocks[CE3_CLK_SRC] = &ce3_clk_src_apq8084.clkr,
+	gcc_msm8974_clocks[GCC_CE3_AHB_CLK] = &gcc_ce3_ahb_clk_apq8084.clkr,
+	gcc_msm8974_clocks[GCC_CE3_AXI_CLK] = &gcc_ce3_axi_clk_apq8084.clkr,
+	gcc_msm8974_clocks[GCC_CE3_CLK] = &gcc_ce3_clk_apq8084.clkr,
+
+	gp1_clk_src.freq_tbl = ftbl_gcc_gp_clk_apq8084;
+	gp2_clk_src.freq_tbl = ftbl_gcc_gp_clk_apq8084;
+	gp3_clk_src.freq_tbl = ftbl_gcc_gp_clk_apq8084;
+
+	gcc_msm8974_clocks[GCC_LPASS_Q6_AXI_CLK] = NULL;
+}
+
 static const struct of_device_id gcc_msm8974_match_table[] = {
 	{ .compatible = "qcom,gcc-msm8974" },
 	{ .compatible = "qcom,gcc-msm8974pro",
-		.data =	&msm8974_pro_clock_override },
+		.data =	msm8974_pro_clock_override },
 	{ .compatible = "qcom,gcc-msm8974pro-ac",
-		.data = &msm8974_pro_clock_override },
+		.data = msm8974_pro_clock_override },
+	{ .compatible = "qcom,gcc-apq8084",
+		.data = apq8084_clock_override },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, gcc_msm8974_match_table);
diff --git a/include/dt-bindings/clock/qcom,gcc-msm8974.h b/include/dt-bindings/clock/qcom,gcc-msm8974.h
index 51e51c8..01f8863 100644
--- a/include/dt-bindings/clock/qcom,gcc-msm8974.h
+++ b/include/dt-bindings/clock/qcom,gcc-msm8974.h
@@ -320,5 +320,9 @@
 #define GPLL4_VOTE						303
 #define GCC_SDCC1_CDCCAL_SLEEP_CLK				304
 #define GCC_SDCC1_CDCCAL_FF_CLK					305
+#define CE3_CLK_SRC                             306
+#define GCC_CE3_CLK                             307
+#define GCC_CE3_AHB_CLK                         308
+#define GCC_CE3_AXI_CLK                         309
 
 #endif
-- 
1.7.9.5

