Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992476AbaEPXI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:08:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52424 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbaEPXHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:07:20 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 6/7] clk: qcom: Support msm8974pro global clock control hardware
Date: Fri, 16 May 2014 16:07:13 -0700
Message-Id: <1400281634-9313-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1400281634-9313-1-git-send-email-sboyd@codeaurora.org>
References: <1400281634-9313-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new PLL (gpll4) is added on msm8974 PRO devices to support a
faster sdc1 clock rate. Add support for this and the two new sdcc
cal clocks.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/clock/qcom,gcc.txt         |   2 +
 drivers/clk/qcom/gcc-msm8974.c                     | 130 ++++++++++++++++++++-
 include/dt-bindings/clock/qcom,gcc-msm8974.h       |   4 +
 3 files changed, 130 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.txt b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
index 7b7104e8cb1e..9cfcb4f2bc97 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc.txt
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
@@ -8,6 +8,8 @@ Required properties :
 			"qcom,gcc-msm8660"
 			"qcom,gcc-msm8960"
 			"qcom,gcc-msm8974"
+			"qcom,gcc-msm8974pro"
+			"qcom,gcc-msm8974pro-ac"
 
 - reg : shall contain base register location and length
 - #clock-cells : shall contain 1
diff --git a/drivers/clk/qcom/gcc-msm8974.c b/drivers/clk/qcom/gcc-msm8974.c
index 0d1edc1e9b31..33eb051d7255 100644
--- a/drivers/clk/qcom/gcc-msm8974.c
+++ b/drivers/clk/qcom/gcc-msm8974.c
@@ -35,6 +35,7 @@
 #define P_XO	0
 #define P_GPLL0	1
 #define P_GPLL1	1
+#define P_GPLL4	2
 
 static const u8 gcc_xo_gpll0_map[] = {
 	[P_XO]		= 0,
@@ -46,6 +47,18 @@ static const char *gcc_xo_gpll0[] = {
 	"gpll0_vote",
 };
 
+static const u8 gcc_xo_gpll0_gpll4_map[] = {
+	[P_XO]		= 0,
+	[P_GPLL0]	= 1,
+	[P_GPLL4]	= 5,
+};
+
+static const char *gcc_xo_gpll0_gpll4[] = {
+	"xo",
+	"gpll0_vote",
+	"gpll4_vote",
+};
+
 #define F(f, s, h, m, n) { (f), (s), (2 * (h) - 1), (m), (n) }
 
 static struct clk_pll gpll0 = {
@@ -138,6 +151,33 @@ static struct clk_regmap gpll1_vote = {
 	},
 };
 
+static struct clk_pll gpll4 = {
+	.l_reg = 0x1dc4,
+	.m_reg = 0x1dc8,
+	.n_reg = 0x1dcc,
+	.config_reg = 0x1dd4,
+	.mode_reg = 0x1dc0,
+	.status_reg = 0x1ddc,
+	.status_bit = 17,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "gpll4",
+		.parent_names = (const char *[]){ "xo" },
+		.num_parents = 1,
+		.ops = &clk_pll_ops,
+	},
+};
+
+static struct clk_regmap gpll4_vote = {
+	.enable_reg = 0x1480,
+	.enable_mask = BIT(4),
+	.hw.init = &(struct clk_init_data){
+		.name = "gpll4_vote",
+		.parent_names = (const char *[]){ "gpll4" },
+		.num_parents = 1,
+		.ops = &clk_pll_vote_ops,
+	},
+};
+
 static const struct freq_tbl ftbl_gcc_usb30_master_clk[] = {
 	F(125000000, P_GPLL0, 1, 5, 24),
 	{ }
@@ -812,18 +852,33 @@ static const struct freq_tbl ftbl_gcc_sdcc1_4_apps_clk[] = {
 	{ }
 };
 
+static const struct freq_tbl ftbl_gcc_sdcc1_apps_clk_pro[] = {
+	F(144000, P_XO, 16, 3, 25),
+	F(400000, P_XO, 12, 1, 4),
+	F(20000000, P_GPLL0, 15, 1, 2),
+	F(25000000, P_GPLL0, 12, 1, 2),
+	F(50000000, P_GPLL0, 12, 0, 0),
+	F(100000000, P_GPLL0, 6, 0, 0),
+	F(192000000, P_GPLL4, 4, 0, 0),
+	F(200000000, P_GPLL0, 3, 0, 0),
+	F(384000000, P_GPLL4, 2, 0, 0),
+	{ }
+};
+
+static struct clk_init_data sdcc1_apps_clk_src_init = {
+	.name = "sdcc1_apps_clk_src",
+	.parent_names = gcc_xo_gpll0,
+	.num_parents = 2,
+	.ops = &clk_rcg2_ops,
+};
+
 static struct clk_rcg2 sdcc1_apps_clk_src = {
 	.cmd_rcgr = 0x04d0,
 	.mnd_width = 8,
 	.hid_width = 5,
 	.parent_map = gcc_xo_gpll0_map,
 	.freq_tbl = ftbl_gcc_sdcc1_4_apps_clk,
-	.clkr.hw.init = &(struct clk_init_data){
-		.name = "sdcc1_apps_clk_src",
-		.parent_names = gcc_xo_gpll0,
-		.num_parents = 2,
-		.ops = &clk_rcg2_ops,
-	},
+	.clkr.hw.init = &sdcc1_apps_clk_src_init,
 };
 
 static struct clk_rcg2 sdcc2_apps_clk_src = {
@@ -1995,6 +2050,38 @@ static struct clk_branch gcc_sdcc1_apps_clk = {
 	},
 };
 
+static struct clk_branch gcc_sdcc1_cdccal_ff_clk = {
+	.halt_reg = 0x04e8,
+	.clkr = {
+		.enable_reg = 0x04e8,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_sdcc1_cdccal_ff_clk",
+			.parent_names = (const char *[]){
+				"xo"
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sdcc1_cdccal_sleep_clk = {
+	.halt_reg = 0x04e4,
+	.clkr = {
+		.enable_reg = 0x04e4,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_sdcc1_cdccal_sleep_clk",
+			.parent_names = (const char *[]){
+				"sleep_clk_src"
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
 static struct clk_branch gcc_sdcc2_ahb_clk = {
 	.halt_reg = 0x0508,
 	.clkr = {
@@ -2484,6 +2571,10 @@ static struct clk_regmap *gcc_msm8974_clocks[] = {
 	[GCC_USB_HSIC_IO_CAL_SLEEP_CLK] = &gcc_usb_hsic_io_cal_sleep_clk.clkr,
 	[GCC_USB_HSIC_SYSTEM_CLK] = &gcc_usb_hsic_system_clk.clkr,
 	[GCC_MMSS_GPLL0_CLK_SRC] = &gcc_mmss_gpll0_clk_src,
+	[GPLL4] = NULL,
+	[GPLL4_VOTE] = NULL,
+	[GCC_SDCC1_CDCCAL_SLEEP_CLK] = NULL,
+	[GCC_SDCC1_CDCCAL_FF_CLK] = NULL,
 };
 
 static const struct qcom_reset_map gcc_msm8974_resets[] = {
@@ -2585,14 +2676,41 @@ static const struct qcom_cc_desc gcc_msm8974_desc = {
 
 static const struct of_device_id gcc_msm8974_match_table[] = {
 	{ .compatible = "qcom,gcc-msm8974" },
+	{ .compatible = "qcom,gcc-msm8974pro" , .data = (void *)1UL },
+	{ .compatible = "qcom,gcc-msm8974pro-ac", .data = (void *)1UL },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, gcc_msm8974_match_table);
 
+static void msm8974_pro_clock_override(void)
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
+}
+
 static int gcc_msm8974_probe(struct platform_device *pdev)
 {
 	struct clk *clk;
 	struct device *dev = &pdev->dev;
+	bool pro;
+	const struct of_device_id *id;
+
+	id = of_match_device(gcc_msm8974_match_table, dev);
+	if (!id)
+		return -ENODEV;
+	pro = !!(id->data);
+
+	if (pro)
+		msm8974_pro_clock_override();
 
 	/* Temporary until RPM clocks supported */
 	clk = clk_register_fixed_rate(dev, "xo", NULL, CLK_IS_ROOT, 19200000);
diff --git a/include/dt-bindings/clock/qcom,gcc-msm8974.h b/include/dt-bindings/clock/qcom,gcc-msm8974.h
index 223ca174d9d3..51e51c860fe6 100644
--- a/include/dt-bindings/clock/qcom,gcc-msm8974.h
+++ b/include/dt-bindings/clock/qcom,gcc-msm8974.h
@@ -316,5 +316,9 @@
 #define GCC_CE2_CLK_SLEEP_ENA					299
 #define GCC_CE2_AXI_CLK_SLEEP_ENA				300
 #define GCC_CE2_AHB_CLK_SLEEP_ENA				301
+#define GPLL4							302
+#define GPLL4_VOTE						303
+#define GCC_SDCC1_CDCCAL_SLEEP_CLK				304
+#define GCC_SDCC1_CDCCAL_FF_CLK					305
 
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

