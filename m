Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaFJU65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:58:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43047 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbaFJU6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:58:31 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 2/2] clk: qcom: Fully support apq8064 global clock control
Date: Tue, 10 Jun 2014 13:58:26 -0700
Message-Id: <1402433906-19309-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1402433906-19309-1-git-send-email-sboyd@codeaurora.org>
References: <1402433906-19309-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add in the handful of new clocks and introduce a new reset table
with the few new resets.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/gcc-msm8960.c               | 577 ++++++++++++++++++++++++++-
 include/dt-bindings/clock/qcom,gcc-msm8960.h |  11 +
 include/dt-bindings/reset/qcom,gcc-msm8960.h |  16 +
 3 files changed, 600 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/gcc-msm8960.c b/drivers/clk/qcom/gcc-msm8960.c
index c47a75829b2b..007534f7a2d7 100644
--- a/drivers/clk/qcom/gcc-msm8960.c
+++ b/drivers/clk/qcom/gcc-msm8960.c
@@ -104,6 +104,7 @@ static struct clk_regmap pll14_vote = {
 
 #define P_PXO	0
 #define P_PLL8	1
+#define P_PLL3	2
 #define P_CXO	2
 
 static const u8 gcc_pxo_pll8_map[] = {
@@ -128,6 +129,18 @@ static const char *gcc_pxo_pll8_cxo[] = {
 	"cxo",
 };
 
+static const u8 gcc_pxo_pll8_pll3_map[] = {
+	[P_PXO]		= 0,
+	[P_PLL8]	= 3,
+	[P_PLL3]	= 6,
+};
+
+static const char *gcc_pxo_pll8_pll3[] = {
+	"pxo",
+	"pll8_vote",
+	"pll3",
+};
+
 static struct freq_tbl clk_tbl_gsbi_uart[] = {
 	{  1843200, P_PLL8, 2,  6, 625 },
 	{  3686400, P_PLL8, 2, 12, 625 },
@@ -1928,6 +1941,104 @@ static struct clk_branch usb_hs1_xcvr_clk = {
 	},
 };
 
+static struct clk_rcg usb_hs3_xcvr_src = {
+	.ns_reg = 0x370c,
+	.md_reg = 0x3708,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 8,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_usb,
+	.clkr = {
+		.enable_reg = 0x370c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_hs3_xcvr_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static struct clk_branch usb_hs3_xcvr_clk = {
+	.halt_reg = 0x2fc8,
+	.halt_bit = 30,
+	.clkr = {
+		.enable_reg = 0x370c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_hs3_xcvr_clk",
+			.parent_names = (const char *[]){ "usb_hs3_xcvr_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg usb_hs4_xcvr_src = {
+	.ns_reg = 0x372c,
+	.md_reg = 0x3728,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 8,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_usb,
+	.clkr = {
+		.enable_reg = 0x372c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_hs4_xcvr_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static struct clk_branch usb_hs4_xcvr_clk = {
+	.halt_reg = 0x2fc8,
+	.halt_bit = 2,
+	.clkr = {
+		.enable_reg = 0x372c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_hs4_xcvr_clk",
+			.parent_names = (const char *[]){ "usb_hs4_xcvr_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
 static struct clk_rcg usb_hsic_xcvr_fs_src = {
 	.ns_reg = 0x2928,
 	.md_reg = 0x2924,
@@ -2456,6 +2567,34 @@ static struct clk_branch usb_hs1_h_clk = {
 	},
 };
 
+static struct clk_branch usb_hs3_h_clk = {
+	.halt_reg = 0x2fc8,
+	.halt_bit = 31,
+	.clkr = {
+		.enable_reg = 0x3700,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_hs3_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch usb_hs4_h_clk = {
+	.halt_reg = 0x2fc8,
+	.halt_bit = 7,
+	.clkr = {
+		.enable_reg = 0x3720,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_hs4_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
 static struct clk_branch usb_hsic_h_clk = {
 	.halt_reg = 0x2fcc,
 	.halt_bit = 28,
@@ -2582,6 +2721,244 @@ static struct clk_branch adm0_pbus_clk = {
 	},
 };
 
+static struct freq_tbl clk_tbl_ce3[] = {
+	{ 48000000, P_PLL8, 8 },
+	{ 100000000, P_PLL3, 12 },
+	{ 120000000, P_PLL3, 10 },
+	{ }
+};
+
+static struct clk_rcg ce3_src = {
+	.ns_reg = 0x36c0,
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 4,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_pll3_map,
+	},
+	.freq_tbl = clk_tbl_ce3,
+	.clkr = {
+		.enable_reg = 0x2c08,
+		.enable_mask = BIT(7),
+		.hw.init = &(struct clk_init_data){
+			.name = "ce3_src",
+			.parent_names = gcc_pxo_pll8_pll3,
+			.num_parents = 3,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	},
+};
+
+static struct clk_branch ce3_core_clk = {
+	.halt_reg = 0x2fdc,
+	.halt_bit = 5,
+	.clkr = {
+		.enable_reg = 0x36c4,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "ce3_core_clk",
+			.parent_names = (const char *[]){ "ce3_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_branch ce3_h_clk = {
+	.halt_reg = 0x2fc4,
+	.halt_bit = 16,
+	.clkr = {
+		.enable_reg = 0x36c4,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "ce3_h_clk",
+			.parent_names = (const char *[]){ "ce3_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static const struct freq_tbl clk_tbl_sata_ref[] = {
+	{ 48000000, P_PLL8, 8, 0, 0 },
+	{ 100000000, P_PLL3, 12, 0, 0 },
+	{ }
+};
+
+static struct clk_rcg sata_clk_src = {
+	.ns_reg = 0x2c08,
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 4,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_pll3_map,
+	},
+	.freq_tbl = clk_tbl_sata_ref,
+	.clkr = {
+		.enable_reg = 0x2c08,
+		.enable_mask = BIT(7),
+		.hw.init = &(struct clk_init_data){
+			.name = "sata_clk_src",
+			.parent_names = gcc_pxo_pll8_pll3,
+			.num_parents = 3,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	},
+};
+
+static struct clk_branch sata_rxoob_clk = {
+	.halt_reg = 0x2fdc,
+	.halt_bit = 26,
+	.clkr = {
+		.enable_reg = 0x2c0c,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "sata_rxoob_clk",
+			.parent_names = (const char *[]){ "sata_clk_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_branch sata_pmalive_clk = {
+	.halt_reg = 0x2fdc,
+	.halt_bit = 25,
+	.clkr = {
+		.enable_reg = 0x2c10,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "sata_pmalive_clk",
+			.parent_names = (const char *[]){ "sata_clk_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_branch sata_phy_ref_clk = {
+	.halt_reg = 0x2fdc,
+	.halt_bit = 24,
+	.clkr = {
+		.enable_reg = 0x2c14,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "sata_phy_ref_clk",
+			.parent_names = (const char *[]){ "pxo" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+		},
+	},
+};
+
+static struct clk_branch sata_a_clk = {
+	.halt_reg = 0x2fc0,
+	.halt_bit = 12,
+	.clkr = {
+		.enable_reg = 0x2c20,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "sata_a_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch sata_h_clk = {
+	.halt_reg = 0x2fdc,
+	.halt_bit = 27,
+	.clkr = {
+		.enable_reg = 0x2c00,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "sata_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch sfab_sata_s_h_clk = {
+	.halt_reg = 0x2fc4,
+	.halt_bit = 14,
+	.clkr = {
+		.enable_reg = 0x2480,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "sfab_sata_s_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch sata_phy_cfg_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 12,
+	.clkr = {
+		.enable_reg = 0x2c40,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "sata_phy_cfg_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch pcie_phy_ref_clk = {
+	.halt_reg = 0x2fdc,
+	.halt_bit = 29,
+	.clkr = {
+		.enable_reg = 0x22d0,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "pcie_phy_ref_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch pcie_h_clk = {
+	.halt_reg = 0x2fd4,
+	.halt_bit = 8,
+	.clkr = {
+		.enable_reg = 0x22cc,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "pcie_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch pcie_a_clk = {
+	.halt_reg = 0x2fc0,
+	.halt_bit = 13,
+	.clkr = {
+		.enable_reg = 0x22c0,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "pcie_a_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
 static struct clk_branch pmic_arb0_h_clk = {
 	.halt_reg = 0x2fd8,
 	.halt_check = BRANCH_HALT_VOTED,
@@ -2869,13 +3246,48 @@ static const struct qcom_reset_map gcc_msm8960_resets[] = {
 };
 
 static struct clk_regmap *gcc_apq8064_clks[] = {
+	[PLL3] = &pll3.clkr,
 	[PLL8] = &pll8.clkr,
 	[PLL8_VOTE] = &pll8_vote,
+	[PLL14] = &pll14.clkr,
+	[PLL14_VOTE] = &pll14_vote,
+	[GSBI1_UART_SRC] = &gsbi1_uart_src.clkr,
+	[GSBI1_UART_CLK] = &gsbi1_uart_clk.clkr,
+	[GSBI2_UART_SRC] = &gsbi2_uart_src.clkr,
+	[GSBI2_UART_CLK] = &gsbi2_uart_clk.clkr,
+	[GSBI3_UART_SRC] = &gsbi3_uart_src.clkr,
+	[GSBI3_UART_CLK] = &gsbi3_uart_clk.clkr,
+	[GSBI4_UART_SRC] = &gsbi4_uart_src.clkr,
+	[GSBI4_UART_CLK] = &gsbi4_uart_clk.clkr,
+	[GSBI5_UART_SRC] = &gsbi5_uart_src.clkr,
+	[GSBI5_UART_CLK] = &gsbi5_uart_clk.clkr,
+	[GSBI6_UART_SRC] = &gsbi6_uart_src.clkr,
+	[GSBI6_UART_CLK] = &gsbi6_uart_clk.clkr,
 	[GSBI7_UART_SRC] = &gsbi7_uart_src.clkr,
 	[GSBI7_UART_CLK] = &gsbi7_uart_clk.clkr,
+	[GSBI1_QUP_SRC] = &gsbi1_qup_src.clkr,
+	[GSBI1_QUP_CLK] = &gsbi1_qup_clk.clkr,
+	[GSBI2_QUP_SRC] = &gsbi2_qup_src.clkr,
+	[GSBI2_QUP_CLK] = &gsbi2_qup_clk.clkr,
+	[GSBI3_QUP_SRC] = &gsbi3_qup_src.clkr,
+	[GSBI3_QUP_CLK] = &gsbi3_qup_clk.clkr,
+	[GSBI4_QUP_SRC] = &gsbi4_qup_src.clkr,
+	[GSBI4_QUP_CLK] = &gsbi4_qup_clk.clkr,
+	[GSBI5_QUP_SRC] = &gsbi5_qup_src.clkr,
+	[GSBI5_QUP_CLK] = &gsbi5_qup_clk.clkr,
+	[GSBI6_QUP_SRC] = &gsbi6_qup_src.clkr,
+	[GSBI6_QUP_CLK] = &gsbi6_qup_clk.clkr,
 	[GSBI7_QUP_SRC] = &gsbi7_qup_src.clkr,
 	[GSBI7_QUP_CLK] = &gsbi7_qup_clk.clkr,
-	[GSBI7_H_CLK] = &gsbi7_h_clk.clkr,
+	[GP0_SRC] = &gp0_src.clkr,
+	[GP0_CLK] = &gp0_clk.clkr,
+	[GP1_SRC] = &gp1_src.clkr,
+	[GP1_CLK] = &gp1_clk.clkr,
+	[GP2_SRC] = &gp2_src.clkr,
+	[GP2_CLK] = &gp2_clk.clkr,
+	[PMEM_A_CLK] = &pmem_clk.clkr,
+	[PRNG_SRC] = &prng_src.clkr,
+	[PRNG_CLK] = &prng_clk.clkr,
 	[SDC1_SRC] = &sdc1_src.clkr,
 	[SDC1_CLK] = &sdc1_clk.clkr,
 	[SDC2_SRC] = &sdc2_src.clkr,
@@ -2884,6 +3296,155 @@ static struct clk_regmap *gcc_apq8064_clks[] = {
 	[SDC3_CLK] = &sdc3_clk.clkr,
 	[SDC4_SRC] = &sdc4_src.clkr,
 	[SDC4_CLK] = &sdc4_clk.clkr,
+	[TSIF_REF_SRC] = &tsif_ref_src.clkr,
+	[TSIF_REF_CLK] = &tsif_ref_clk.clkr,
+	[USB_HS1_XCVR_SRC] = &usb_hs1_xcvr_src.clkr,
+	[USB_HS1_XCVR_CLK] = &usb_hs1_xcvr_clk.clkr,
+	[USB_HS3_XCVR_SRC] = &usb_hs3_xcvr_src.clkr,
+	[USB_HS3_XCVR_CLK] = &usb_hs3_xcvr_clk.clkr,
+	[USB_HS4_XCVR_SRC] = &usb_hs4_xcvr_src.clkr,
+	[USB_HS4_XCVR_CLK] = &usb_hs4_xcvr_clk.clkr,
+	[USB_HSIC_XCVR_FS_SRC] = &usb_hsic_xcvr_fs_src.clkr,
+	[USB_HSIC_XCVR_FS_CLK] = &usb_hsic_xcvr_fs_clk.clkr,
+	[USB_HSIC_SYSTEM_CLK] = &usb_hsic_system_clk.clkr,
+	[USB_HSIC_HSIC_CLK] = &usb_hsic_hsic_clk.clkr,
+	[USB_HSIC_HSIO_CAL_CLK] = &usb_hsic_hsio_cal_clk.clkr,
+	[USB_FS1_XCVR_FS_SRC] = &usb_fs1_xcvr_fs_src.clkr,
+	[USB_FS1_XCVR_FS_CLK] = &usb_fs1_xcvr_fs_clk.clkr,
+	[USB_FS1_SYSTEM_CLK] = &usb_fs1_system_clk.clkr,
+	[SATA_H_CLK] = &sata_h_clk.clkr,
+	[SATA_CLK_SRC] = &sata_clk_src.clkr,
+	[SATA_RXOOB_CLK] = &sata_rxoob_clk.clkr,
+	[SATA_PMALIVE_CLK] = &sata_pmalive_clk.clkr,
+	[SATA_PHY_REF_CLK] = &sata_phy_ref_clk.clkr,
+	[SATA_PHY_CFG_CLK] = &sata_phy_cfg_clk.clkr,
+	[SATA_A_CLK] = &sata_a_clk.clkr,
+	[SFAB_SATA_S_H_CLK] = &sfab_sata_s_h_clk.clkr,
+	[CE3_SRC] = &ce3_src.clkr,
+	[CE3_CORE_CLK] = &ce3_core_clk.clkr,
+	[CE3_H_CLK] = &ce3_h_clk.clkr,
+	[DMA_BAM_H_CLK] = &dma_bam_h_clk.clkr,
+	[GSBI1_H_CLK] = &gsbi1_h_clk.clkr,
+	[GSBI2_H_CLK] = &gsbi2_h_clk.clkr,
+	[GSBI3_H_CLK] = &gsbi3_h_clk.clkr,
+	[GSBI4_H_CLK] = &gsbi4_h_clk.clkr,
+	[GSBI5_H_CLK] = &gsbi5_h_clk.clkr,
+	[GSBI6_H_CLK] = &gsbi6_h_clk.clkr,
+	[GSBI7_H_CLK] = &gsbi7_h_clk.clkr,
+	[TSIF_H_CLK] = &tsif_h_clk.clkr,
+	[USB_FS1_H_CLK] = &usb_fs1_h_clk.clkr,
+	[USB_HS1_H_CLK] = &usb_hs1_h_clk.clkr,
+	[USB_HSIC_H_CLK] = &usb_hsic_h_clk.clkr,
+	[USB_HS3_H_CLK] = &usb_hs3_h_clk.clkr,
+	[USB_HS4_H_CLK] = &usb_hs4_h_clk.clkr,
+	[SDC1_H_CLK] = &sdc1_h_clk.clkr,
+	[SDC2_H_CLK] = &sdc2_h_clk.clkr,
+	[SDC3_H_CLK] = &sdc3_h_clk.clkr,
+	[SDC4_H_CLK] = &sdc4_h_clk.clkr,
+	[ADM0_CLK] = &adm0_clk.clkr,
+	[ADM0_PBUS_CLK] = &adm0_pbus_clk.clkr,
+	[PCIE_A_CLK] = &pcie_a_clk.clkr,
+	[PCIE_PHY_REF_CLK] = &pcie_phy_ref_clk.clkr,
+	[PCIE_H_CLK] = &pcie_h_clk.clkr,
+	[PMIC_ARB0_H_CLK] = &pmic_arb0_h_clk.clkr,
+	[PMIC_ARB1_H_CLK] = &pmic_arb1_h_clk.clkr,
+	[PMIC_SSBI2_CLK] = &pmic_ssbi2_clk.clkr,
+	[RPM_MSG_RAM_H_CLK] = &rpm_msg_ram_h_clk.clkr,
+};
+
+static const struct qcom_reset_map gcc_apq8064_resets[] = {
+	[QDSS_STM_RESET] = { 0x2060, 6 },
+	[AFAB_SMPSS_S_RESET] = { 0x20b8, 2 },
+	[AFAB_SMPSS_M1_RESET] = { 0x20b8, 1 },
+	[AFAB_SMPSS_M0_RESET] = { 0x20b8 },
+	[AFAB_EBI1_CH0_RESET] = { 0x20c0, 7 },
+	[AFAB_EBI1_CH1_RESET] = { 0x20c4, 7},
+	[SFAB_ADM0_M0_RESET] = { 0x21e0, 7 },
+	[SFAB_ADM0_M1_RESET] = { 0x21e4, 7 },
+	[SFAB_ADM0_M2_RESET] = { 0x21e8, 7 },
+	[ADM0_C2_RESET] = { 0x220c, 4},
+	[ADM0_C1_RESET] = { 0x220c, 3},
+	[ADM0_C0_RESET] = { 0x220c, 2},
+	[ADM0_PBUS_RESET] = { 0x220c, 1 },
+	[ADM0_RESET] = { 0x220c },
+	[QDSS_CLKS_SW_RESET] = { 0x2260, 5 },
+	[QDSS_POR_RESET] = { 0x2260, 4 },
+	[QDSS_TSCTR_RESET] = { 0x2260, 3 },
+	[QDSS_HRESET_RESET] = { 0x2260, 2 },
+	[QDSS_AXI_RESET] = { 0x2260, 1 },
+	[QDSS_DBG_RESET] = { 0x2260 },
+	[SFAB_PCIE_M_RESET] = { 0x22d8, 1 },
+	[SFAB_PCIE_S_RESET] = { 0x22d8 },
+	[PCIE_EXT_PCI_RESET] = { 0x22dc, 6 },
+	[PCIE_PHY_RESET] = { 0x22dc, 5 },
+	[PCIE_PCI_RESET] = { 0x22dc, 4 },
+	[PCIE_POR_RESET] = { 0x22dc, 3 },
+	[PCIE_HCLK_RESET] = { 0x22dc, 2 },
+	[PCIE_ACLK_RESET] = { 0x22dc },
+	[SFAB_USB3_M_RESET] = { 0x2360, 7 },
+	[SFAB_RIVA_M_RESET] = { 0x2380, 7 },
+	[SFAB_LPASS_RESET] = { 0x23a0, 7 },
+	[SFAB_AFAB_M_RESET] = { 0x23e0, 7 },
+	[AFAB_SFAB_M0_RESET] = { 0x2420, 7 },
+	[AFAB_SFAB_M1_RESET] = { 0x2424, 7 },
+	[SFAB_SATA_S_RESET] = { 0x2480, 7 },
+	[SFAB_DFAB_M_RESET] = { 0x2500, 7 },
+	[DFAB_SFAB_M_RESET] = { 0x2520, 7 },
+	[DFAB_SWAY0_RESET] = { 0x2540, 7 },
+	[DFAB_SWAY1_RESET] = { 0x2544, 7 },
+	[DFAB_ARB0_RESET] = { 0x2560, 7 },
+	[DFAB_ARB1_RESET] = { 0x2564, 7 },
+	[PPSS_PROC_RESET] = { 0x2594, 1 },
+	[PPSS_RESET] = { 0x2594},
+	[DMA_BAM_RESET] = { 0x25c0, 7 },
+	[SPS_TIC_H_RESET] = { 0x2600, 7 },
+	[SFAB_CFPB_M_RESET] = { 0x2680, 7 },
+	[SFAB_CFPB_S_RESET] = { 0x26c0, 7 },
+	[TSIF_H_RESET] = { 0x2700, 7 },
+	[CE1_H_RESET] = { 0x2720, 7 },
+	[CE1_CORE_RESET] = { 0x2724, 7 },
+	[CE1_SLEEP_RESET] = { 0x2728, 7 },
+	[CE2_H_RESET] = { 0x2740, 7 },
+	[CE2_CORE_RESET] = { 0x2744, 7 },
+	[SFAB_SFPB_M_RESET] = { 0x2780, 7 },
+	[SFAB_SFPB_S_RESET] = { 0x27a0, 7 },
+	[RPM_PROC_RESET] = { 0x27c0, 7 },
+	[PMIC_SSBI2_RESET] = { 0x280c, 12 },
+	[SDC1_RESET] = { 0x2830 },
+	[SDC2_RESET] = { 0x2850 },
+	[SDC3_RESET] = { 0x2870 },
+	[SDC4_RESET] = { 0x2890 },
+	[USB_HS1_RESET] = { 0x2910 },
+	[USB_HSIC_RESET] = { 0x2934 },
+	[USB_FS1_XCVR_RESET] = { 0x2974, 1 },
+	[USB_FS1_RESET] = { 0x2974 },
+	[GSBI1_RESET] = { 0x29dc },
+	[GSBI2_RESET] = { 0x29fc },
+	[GSBI3_RESET] = { 0x2a1c },
+	[GSBI4_RESET] = { 0x2a3c },
+	[GSBI5_RESET] = { 0x2a5c },
+	[GSBI6_RESET] = { 0x2a7c },
+	[GSBI7_RESET] = { 0x2a9c },
+	[SPDM_RESET] = { 0x2b6c },
+	[TLMM_H_RESET] = { 0x2ba0, 7 },
+	[SATA_SFAB_M_RESET] = { 0x2c18 },
+	[SATA_RESET] = { 0x2c1c },
+	[GSS_SLP_RESET] = { 0x2c60, 7 },
+	[GSS_RESET] = { 0x2c64 },
+	[TSSC_RESET] = { 0x2ca0, 7 },
+	[PDM_RESET] = { 0x2cc0, 12 },
+	[MPM_H_RESET] = { 0x2da0, 7 },
+	[MPM_RESET] = { 0x2da4 },
+	[SFAB_SMPSS_S_RESET] = { 0x2e00, 7 },
+	[PRNG_RESET] = { 0x2e80, 12 },
+	[RIVA_RESET] = { 0x35e0 },
+	[CE3_H_RESET] = { 0x36c4, 7 },
+	[SFAB_CE3_M_RESET] = { 0x36c8, 1 },
+	[SFAB_CE3_S_RESET] = { 0x36c8 },
+	[CE3_RESET] = { 0x36cc, 7 },
+	[CE3_SLEEP_RESET] = { 0x36d0, 7 },
+	[USB_HS3_RESET] = { 0x3710 },
+	[USB_HS4_RESET] = { 0x3730 },
 };
 
 static const struct regmap_config gcc_msm8960_regmap_config = {
@@ -2894,6 +3455,14 @@ static const struct regmap_config gcc_msm8960_regmap_config = {
 	.fast_io	= true,
 };
 
+static const struct regmap_config gcc_apq8064_regmap_config = {
+	.reg_bits	= 32,
+	.reg_stride	= 4,
+	.val_bits	= 32,
+	.max_register	= 0x3880,
+	.fast_io	= true,
+};
+
 static const struct qcom_cc_desc gcc_msm8960_desc = {
 	.config = &gcc_msm8960_regmap_config,
 	.clks = gcc_msm8960_clks,
@@ -2903,11 +3472,11 @@ static const struct qcom_cc_desc gcc_msm8960_desc = {
 };
 
 static const struct qcom_cc_desc gcc_apq8064_desc = {
-	.config = &gcc_msm8960_regmap_config,
+	.config = &gcc_apq8064_regmap_config,
 	.clks = gcc_apq8064_clks,
 	.num_clks = ARRAY_SIZE(gcc_apq8064_clks),
-	.resets = gcc_msm8960_resets,
-	.num_resets = ARRAY_SIZE(gcc_msm8960_resets),
+	.resets = gcc_apq8064_resets,
+	.num_resets = ARRAY_SIZE(gcc_apq8064_resets),
 };
 
 static const struct of_device_id gcc_msm8960_match_table[] = {
diff --git a/include/dt-bindings/clock/qcom,gcc-msm8960.h b/include/dt-bindings/clock/qcom,gcc-msm8960.h
index f9f547146a15..7d20eedfee98 100644
--- a/include/dt-bindings/clock/qcom,gcc-msm8960.h
+++ b/include/dt-bindings/clock/qcom,gcc-msm8960.h
@@ -308,5 +308,16 @@
 #define PLL13					292
 #define PLL14					293
 #define PLL14_VOTE				294
+#define USB_HS3_H_CLK				295
+#define USB_HS3_XCVR_SRC			296
+#define USB_HS3_XCVR_CLK			297
+#define USB_HS4_H_CLK				298
+#define USB_HS4_XCVR_SRC			299
+#define USB_HS4_XCVR_CLK			300
+#define SATA_PHY_CFG_CLK			301
+#define SATA_A_CLK				302
+#define CE3_SRC					303
+#define CE3_CORE_CLK				304
+#define CE3_H_CLK				305
 
 #endif
diff --git a/include/dt-bindings/reset/qcom,gcc-msm8960.h b/include/dt-bindings/reset/qcom,gcc-msm8960.h
index 07edd0e65eed..47c8686955da 100644
--- a/include/dt-bindings/reset/qcom,gcc-msm8960.h
+++ b/include/dt-bindings/reset/qcom,gcc-msm8960.h
@@ -114,5 +114,21 @@
 #define SFAB_SMPSS_S_RESET				97
 #define PRNG_RESET					98
 #define RIVA_RESET					99
+#define USB_HS3_RESET					100
+#define USB_HS4_RESET					101
+#define CE3_RESET					102
+#define PCIE_EXT_PCI_RESET				103
+#define PCIE_PHY_RESET					104
+#define PCIE_PCI_RESET					105
+#define PCIE_POR_RESET					106
+#define PCIE_HCLK_RESET					107
+#define PCIE_ACLK_RESET					108
+#define CE3_H_RESET					109
+#define SFAB_CE3_M_RESET				110
+#define SFAB_CE3_S_RESET				111
+#define SATA_RESET					112
+#define CE3_SLEEP_RESET					113
+#define GSS_SLP_RESET					114
+#define GSS_RESET					115
 
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

