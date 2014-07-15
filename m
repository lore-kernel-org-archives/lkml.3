Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbaGOXAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:00:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45445 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbaGOW7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:59:46 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH 2/2] clk: qcom: Add support for APQ8064 multimedia clocks
Date: Tue, 15 Jul 2014 15:59:42 -0700
Message-Id: <1405465182-925-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1405465182-925-1-git-send-email-sboyd@codeaurora.org>
References: <1405465182-925-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The APQ8064 multimedia clock controller is fairly similar to the
8960 multimedia clock controller, except that gfx2d0/1 has been
removed and the gfx3d frequency is slightly faster when using the
newly introduced PLL15. We also add vcap clocks and a couple new
TV clocks.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/clock/qcom,mmcc.txt        |   1 +
 drivers/clk/qcom/mmcc-msm8960.c                    | 433 ++++++++++++++++++++-
 include/dt-bindings/clock/qcom,mmcc-msm8960.h      |   8 +
 include/dt-bindings/reset/qcom,mmcc-msm8960.h      |   8 +
 4 files changed, 448 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/qcom,mmcc.txt b/Documentation/devicetree/bindings/clock/qcom,mmcc.txt
index d572e9964c54..60596018ea5d 100644
--- a/Documentation/devicetree/bindings/clock/qcom,mmcc.txt
+++ b/Documentation/devicetree/bindings/clock/qcom,mmcc.txt
@@ -4,6 +4,7 @@ Qualcomm Multimedia Clock & Reset Controller Binding
 Required properties :
 - compatible : shall contain only one of the following:
 
+			"qcom,mmcc-apq8064"
 			"qcom,mmcc-msm8660"
 			"qcom,mmcc-msm8960"
 			"qcom,mmcc-msm8974"
diff --git a/drivers/clk/qcom/mmcc-msm8960.c b/drivers/clk/qcom/mmcc-msm8960.c
index 7985982ab4e9..255f127e8f3b 100644
--- a/drivers/clk/qcom/mmcc-msm8960.c
+++ b/drivers/clk/qcom/mmcc-msm8960.c
@@ -37,6 +37,7 @@
 #define P_PLL8	1
 #define P_PLL2	2
 #define P_PLL3	3
+#define P_PLL15	3
 
 #define F_MN(f, s, _m, _n) { .freq = f, .src = s, .m = _m, .n = _n }
 
@@ -59,6 +60,20 @@ static u8 mmcc_pxo_pll8_pll2_pll3_map[] = {
 	[P_PLL3]	= 3,
 };
 
+static const char *mmcc_pxo_pll8_pll2_pll15[] = {
+	"pxo",
+	"pll8_vote",
+	"pll2",
+	"pll15",
+};
+
+static u8 mmcc_pxo_pll8_pll2_pll15_map[] = {
+	[P_PXO]		= 0,
+	[P_PLL8]	= 2,
+	[P_PLL2]	= 1,
+	[P_PLL15]	= 3,
+};
+
 static const char *mmcc_pxo_pll8_pll2_pll3[] = {
 	"pxo",
 	"pll8_vote",
@@ -82,6 +97,36 @@ static struct clk_pll pll2 = {
 	},
 };
 
+static struct clk_pll pll15 = {
+	.l_reg = 0x33c,
+	.m_reg = 0x340,
+	.n_reg = 0x344,
+	.config_reg = 0x348,
+	.mode_reg = 0x338,
+	.status_reg = 0x350,
+	.status_bit = 16,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "pll15",
+		.parent_names = (const char *[]){ "pxo" },
+		.num_parents = 1,
+		.ops = &clk_pll_ops,
+	},
+};
+
+static const struct pll_config pll15_config = {
+	.l = 33,
+	.m = 1,
+	.n = 3,
+	.vco_val = 0x2 << 16,
+	.vco_mask = 0x3 << 16,
+	.pre_div_val = 0x0,
+	.pre_div_mask = BIT(19),
+	.post_div_val = 0x0,
+	.post_div_mask = 0x3 << 20,
+	.mn_ena_mask = BIT(22),
+	.main_output_mask = BIT(23),
+};
+
 static struct freq_tbl clk_tbl_cam[] = {
 	{   6000000, P_PLL8, 4, 1, 16 },
 	{   8000000, P_PLL8, 4, 1, 12 },
@@ -863,6 +908,27 @@ static struct freq_tbl clk_tbl_gfx3d[] = {
 	{ }
 };
 
+static struct freq_tbl clk_tbl_gfx3d_8064[] = {
+	F_MN( 27000000, P_PXO,   0,  0),
+	F_MN( 48000000, P_PLL8,  1,  8),
+	F_MN( 54857000, P_PLL8,  1,  7),
+	F_MN( 64000000, P_PLL8,  1,  6),
+	F_MN( 76800000, P_PLL8,  1,  5),
+	F_MN( 96000000, P_PLL8,  1,  4),
+	F_MN(128000000, P_PLL8,  1,  3),
+	F_MN(145455000, P_PLL2,  2, 11),
+	F_MN(160000000, P_PLL2,  1,  5),
+	F_MN(177778000, P_PLL2,  2,  9),
+	F_MN(192000000, P_PLL8,  1,  2),
+	F_MN(200000000, P_PLL2,  1,  4),
+	F_MN(228571000, P_PLL2,  2,  7),
+	F_MN(266667000, P_PLL2,  1,  3),
+	F_MN(320000000, P_PLL2,  2,  5),
+	F_MN(400000000, P_PLL2,  1,  2),
+	F_MN(450000000, P_PLL15, 1,  2),
+	{ }
+};
+
 static struct clk_dyn_rcg gfx3d_src = {
 	.ns_reg = 0x008c,
 	.md_reg[0] = 0x0084,
@@ -905,6 +971,13 @@ static struct clk_dyn_rcg gfx3d_src = {
 	},
 };
 
+static const struct clk_init_data gfx3d_8064_init = {
+	.name = "gfx3d_src",
+	.parent_names = mmcc_pxo_pll8_pll2_pll15,
+	.num_parents = 4,
+	.ops = &clk_dyn_rcg_ops,
+};
+
 static struct clk_branch gfx3d_clk = {
 	.halt_reg = 0x01c8,
 	.halt_bit = 4,
@@ -921,6 +994,91 @@ static struct clk_branch gfx3d_clk = {
 	},
 };
 
+static struct freq_tbl clk_tbl_vcap[] = {
+	F_MN( 27000000, P_PXO,  0,  0),
+	F_MN( 54860000, P_PLL8, 1,  7),
+	F_MN( 64000000, P_PLL8, 1,  6),
+	F_MN( 76800000, P_PLL8, 1,  5),
+	F_MN(128000000, P_PLL8, 1,  3),
+	F_MN(160000000, P_PLL2, 1,  5),
+	F_MN(200000000, P_PLL2, 1,  4),
+	{ }
+};
+
+static struct clk_dyn_rcg vcap_src = {
+	.ns_reg = 0x021c,
+	.md_reg[0] = 0x01ec,
+	.md_reg[1] = 0x0218,
+	.mn[0] = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 23,
+		.mnctr_mode_shift = 9,
+		.n_val_shift = 18,
+		.m_val_shift = 4,
+		.width = 4,
+	},
+	.mn[1] = {
+		.mnctr_en_bit = 5,
+		.mnctr_reset_bit = 22,
+		.mnctr_mode_shift = 6,
+		.n_val_shift = 14,
+		.m_val_shift = 4,
+		.width = 4,
+	},
+	.s[0] = {
+		.src_sel_shift = 3,
+		.parent_map = mmcc_pxo_pll8_pll2_map,
+	},
+	.s[1] = {
+		.src_sel_shift = 0,
+		.parent_map = mmcc_pxo_pll8_pll2_map,
+	},
+	.mux_sel_bit = 11,
+	.freq_tbl = clk_tbl_vcap,
+	.clkr = {
+		.enable_reg = 0x0178,
+		.enable_mask = BIT(2),
+		.hw.init = &(struct clk_init_data){
+			.name = "vcap_src",
+			.parent_names = mmcc_pxo_pll8_pll2,
+			.num_parents = 3,
+			.ops = &clk_dyn_rcg_ops,
+		},
+	},
+};
+
+static struct clk_branch vcap_clk = {
+	.halt_reg = 0x0240,
+	.halt_bit = 15,
+	.clkr = {
+		.enable_reg = 0x0178,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "vcap_clk",
+			.parent_names = (const char *[]){ "vcap_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_branch vcap_npl_clk = {
+	.halt_reg = 0x0240,
+	.halt_bit = 25,
+	.clkr = {
+		.enable_reg = 0x0178,
+		.enable_mask = BIT(13),
+		.hw.init = &(struct clk_init_data){
+			.name = "vcap_npl_clk",
+			.parent_names = (const char *[]){ "vcap_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
 static struct freq_tbl clk_tbl_ijpeg[] = {
 	{  27000000, P_PXO,  1, 0,  0 },
 	{  36570000, P_PLL8, 1, 2, 21 },
@@ -1323,6 +1481,38 @@ static struct clk_branch hdmi_tv_clk = {
 	},
 };
 
+static struct clk_branch rgb_tv_clk = {
+	.halt_reg = 0x0240,
+	.halt_bit = 27,
+	.clkr = {
+		.enable_reg = 0x0124,
+		.enable_mask = BIT(14),
+		.hw.init = &(struct clk_init_data){
+			.parent_names = tv_src_name,
+			.num_parents = 1,
+			.name = "rgb_tv_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_branch npl_tv_clk = {
+	.halt_reg = 0x0240,
+	.halt_bit = 26,
+	.clkr = {
+		.enable_reg = 0x0124,
+		.enable_mask = BIT(16),
+		.hw.init = &(struct clk_init_data){
+			.parent_names = tv_src_name,
+			.num_parents = 1,
+			.name = "npl_tv_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
 static struct clk_branch hdmi_app_clk = {
 	.halt_reg = 0x01cc,
 	.halt_bit = 25,
@@ -1698,6 +1888,22 @@ static struct clk_branch rot_axi_clk = {
 	},
 };
 
+static struct clk_branch vcap_axi_clk = {
+	.halt_reg = 0x0240,
+	.halt_bit = 20,
+	.hwcg_reg = 0x0244,
+	.hwcg_bit = 11,
+	.clkr = {
+		.enable_reg = 0x0244,
+		.enable_mask = BIT(12),
+		.hw.init = &(struct clk_init_data){
+			.name = "vcap_axi_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
 static struct clk_branch vpe_axi_clk = {
 	.hwcg_reg = 0x0020,
 	.hwcg_bit = 27,
@@ -2000,6 +2206,20 @@ static struct clk_branch tv_enc_ahb_clk = {
 	},
 };
 
+static struct clk_branch vcap_ahb_clk = {
+	.halt_reg = 0x0240,
+	.halt_bit = 23,
+	.clkr = {
+		.enable_reg = 0x0248,
+		.enable_mask = BIT(1),
+		.hw.init = &(struct clk_init_data){
+			.name = "vcap_ahb_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
 static struct clk_branch vcodec_ahb_clk = {
 	.hwcg_reg = 0x0038,
 	.hwcg_bit = 26,
@@ -2212,6 +2432,175 @@ static const struct qcom_reset_map mmcc_msm8960_resets[] = {
 	[CSI_RDI2_RESET] = { 0x0214 },
 };
 
+static struct clk_regmap *mmcc_apq8064_clks[] = {
+	[AMP_AHB_CLK] = &amp_ahb_clk.clkr,
+	[DSI2_S_AHB_CLK] = &dsi2_s_ahb_clk.clkr,
+	[JPEGD_AHB_CLK] = &jpegd_ahb_clk.clkr,
+	[DSI_S_AHB_CLK] = &dsi_s_ahb_clk.clkr,
+	[DSI2_M_AHB_CLK] = &dsi2_m_ahb_clk.clkr,
+	[VPE_AHB_CLK] = &vpe_ahb_clk.clkr,
+	[SMMU_AHB_CLK] = &smmu_ahb_clk.clkr,
+	[HDMI_M_AHB_CLK] = &hdmi_m_ahb_clk.clkr,
+	[VFE_AHB_CLK] = &vfe_ahb_clk.clkr,
+	[ROT_AHB_CLK] = &rot_ahb_clk.clkr,
+	[VCODEC_AHB_CLK] = &vcodec_ahb_clk.clkr,
+	[MDP_AHB_CLK] = &mdp_ahb_clk.clkr,
+	[DSI_M_AHB_CLK] = &dsi_m_ahb_clk.clkr,
+	[CSI_AHB_CLK] = &csi_ahb_clk.clkr,
+	[MMSS_IMEM_AHB_CLK] = &mmss_imem_ahb_clk.clkr,
+	[IJPEG_AHB_CLK] = &ijpeg_ahb_clk.clkr,
+	[HDMI_S_AHB_CLK] = &hdmi_s_ahb_clk.clkr,
+	[GFX3D_AHB_CLK] = &gfx3d_ahb_clk.clkr,
+	[JPEGD_AXI_CLK] = &jpegd_axi_clk.clkr,
+	[GMEM_AXI_CLK] = &gmem_axi_clk.clkr,
+	[MDP_AXI_CLK] = &mdp_axi_clk.clkr,
+	[MMSS_IMEM_AXI_CLK] = &mmss_imem_axi_clk.clkr,
+	[IJPEG_AXI_CLK] = &ijpeg_axi_clk.clkr,
+	[GFX3D_AXI_CLK] = &gfx3d_axi_clk.clkr,
+	[VCODEC_AXI_CLK] = &vcodec_axi_clk.clkr,
+	[VFE_AXI_CLK] = &vfe_axi_clk.clkr,
+	[VPE_AXI_CLK] = &vpe_axi_clk.clkr,
+	[ROT_AXI_CLK] = &rot_axi_clk.clkr,
+	[VCODEC_AXI_A_CLK] = &vcodec_axi_a_clk.clkr,
+	[VCODEC_AXI_B_CLK] = &vcodec_axi_b_clk.clkr,
+	[CSI0_SRC] = &csi0_src.clkr,
+	[CSI0_CLK] = &csi0_clk.clkr,
+	[CSI0_PHY_CLK] = &csi0_phy_clk.clkr,
+	[CSI1_SRC] = &csi1_src.clkr,
+	[CSI1_CLK] = &csi1_clk.clkr,
+	[CSI1_PHY_CLK] = &csi1_phy_clk.clkr,
+	[CSI2_SRC] = &csi2_src.clkr,
+	[CSI2_CLK] = &csi2_clk.clkr,
+	[CSI2_PHY_CLK] = &csi2_phy_clk.clkr,
+	[CSI_PIX_CLK] = &csi_pix_clk.clkr,
+	[CSI_RDI_CLK] = &csi_rdi_clk.clkr,
+	[MDP_VSYNC_CLK] = &mdp_vsync_clk.clkr,
+	[HDMI_APP_CLK] = &hdmi_app_clk.clkr,
+	[CSI_PIX1_CLK] = &csi_pix1_clk.clkr,
+	[CSI_RDI2_CLK] = &csi_rdi2_clk.clkr,
+	[CSI_RDI1_CLK] = &csi_rdi1_clk.clkr,
+	[GFX3D_SRC] = &gfx3d_src.clkr,
+	[GFX3D_CLK] = &gfx3d_clk.clkr,
+	[IJPEG_SRC] = &ijpeg_src.clkr,
+	[IJPEG_CLK] = &ijpeg_clk.clkr,
+	[JPEGD_SRC] = &jpegd_src.clkr,
+	[JPEGD_CLK] = &jpegd_clk.clkr,
+	[MDP_SRC] = &mdp_src.clkr,
+	[MDP_CLK] = &mdp_clk.clkr,
+	[MDP_LUT_CLK] = &mdp_lut_clk.clkr,
+	[ROT_SRC] = &rot_src.clkr,
+	[ROT_CLK] = &rot_clk.clkr,
+	[TV_DAC_CLK] = &tv_dac_clk.clkr,
+	[HDMI_TV_CLK] = &hdmi_tv_clk.clkr,
+	[MDP_TV_CLK] = &mdp_tv_clk.clkr,
+	[TV_SRC] = &tv_src.clkr,
+	[VCODEC_SRC] = &vcodec_src.clkr,
+	[VCODEC_CLK] = &vcodec_clk.clkr,
+	[VFE_SRC] = &vfe_src.clkr,
+	[VFE_CLK] = &vfe_clk.clkr,
+	[VFE_CSI_CLK] = &vfe_csi_clk.clkr,
+	[VPE_SRC] = &vpe_src.clkr,
+	[VPE_CLK] = &vpe_clk.clkr,
+	[CAMCLK0_SRC] = &camclk0_src.clkr,
+	[CAMCLK0_CLK] = &camclk0_clk.clkr,
+	[CAMCLK1_SRC] = &camclk1_src.clkr,
+	[CAMCLK1_CLK] = &camclk1_clk.clkr,
+	[CAMCLK2_SRC] = &camclk2_src.clkr,
+	[CAMCLK2_CLK] = &camclk2_clk.clkr,
+	[CSIPHYTIMER_SRC] = &csiphytimer_src.clkr,
+	[CSIPHY2_TIMER_CLK] = &csiphy2_timer_clk.clkr,
+	[CSIPHY1_TIMER_CLK] = &csiphy1_timer_clk.clkr,
+	[CSIPHY0_TIMER_CLK] = &csiphy0_timer_clk.clkr,
+	[PLL2] = &pll2.clkr,
+	[RGB_TV_CLK] = &rgb_tv_clk.clkr,
+	[NPL_TV_CLK] = &npl_tv_clk.clkr,
+	[VCAP_AHB_CLK] = &vcap_ahb_clk.clkr,
+	[VCAP_AXI_CLK] = &vcap_axi_clk.clkr,
+	[VCAP_SRC] = &vcap_src.clkr,
+	[VCAP_CLK] = &vcap_clk.clkr,
+	[VCAP_NPL_CLK] = &vcap_npl_clk.clkr,
+	[PLL15] = &pll15.clkr,
+};
+
+static const struct qcom_reset_map mmcc_apq8064_resets[] = {
+	[GFX3D_AXI_RESET] = { 0x0208, 17 },
+	[VCAP_AXI_RESET] = { 0x0208, 16 },
+	[VPE_AXI_RESET] = { 0x0208, 15 },
+	[IJPEG_AXI_RESET] = { 0x0208, 14 },
+	[MPD_AXI_RESET] = { 0x0208, 13 },
+	[VFE_AXI_RESET] = { 0x0208, 9 },
+	[SP_AXI_RESET] = { 0x0208, 8 },
+	[VCODEC_AXI_RESET] = { 0x0208, 7 },
+	[ROT_AXI_RESET] = { 0x0208, 6 },
+	[VCODEC_AXI_A_RESET] = { 0x0208, 5 },
+	[VCODEC_AXI_B_RESET] = { 0x0208, 4 },
+	[FAB_S3_AXI_RESET] = { 0x0208, 3 },
+	[FAB_S2_AXI_RESET] = { 0x0208, 2 },
+	[FAB_S1_AXI_RESET] = { 0x0208, 1 },
+	[FAB_S0_AXI_RESET] = { 0x0208 },
+	[SMMU_GFX3D_ABH_RESET] = { 0x020c, 31 },
+	[SMMU_VPE_AHB_RESET] = { 0x020c, 30 },
+	[SMMU_VFE_AHB_RESET] = { 0x020c, 29 },
+	[SMMU_ROT_AHB_RESET] = { 0x020c, 28 },
+	[SMMU_VCODEC_B_AHB_RESET] = { 0x020c, 27 },
+	[SMMU_VCODEC_A_AHB_RESET] = { 0x020c, 26 },
+	[SMMU_MDP1_AHB_RESET] = { 0x020c, 25 },
+	[SMMU_MDP0_AHB_RESET] = { 0x020c, 24 },
+	[SMMU_JPEGD_AHB_RESET] = { 0x020c, 23 },
+	[SMMU_IJPEG_AHB_RESET] = { 0x020c, 22 },
+	[APU_AHB_RESET] = { 0x020c, 18 },
+	[CSI_AHB_RESET] = { 0x020c, 17 },
+	[TV_ENC_AHB_RESET] = { 0x020c, 15 },
+	[VPE_AHB_RESET] = { 0x020c, 14 },
+	[FABRIC_AHB_RESET] = { 0x020c, 13 },
+	[GFX3D_AHB_RESET] = { 0x020c, 10 },
+	[HDMI_AHB_RESET] = { 0x020c, 9 },
+	[MSSS_IMEM_AHB_RESET] = { 0x020c, 8 },
+	[IJPEG_AHB_RESET] = { 0x020c, 7 },
+	[DSI_M_AHB_RESET] = { 0x020c, 6 },
+	[DSI_S_AHB_RESET] = { 0x020c, 5 },
+	[JPEGD_AHB_RESET] = { 0x020c, 4 },
+	[MDP_AHB_RESET] = { 0x020c, 3 },
+	[ROT_AHB_RESET] = { 0x020c, 2 },
+	[VCODEC_AHB_RESET] = { 0x020c, 1 },
+	[VFE_AHB_RESET] = { 0x020c, 0 },
+	[SMMU_VCAP_AHB_RESET] = { 0x0200, 3 },
+	[VCAP_AHB_RESET] = { 0x0200, 2 },
+	[DSI2_M_AHB_RESET] = { 0x0200, 1 },
+	[DSI2_S_AHB_RESET] = { 0x0200, 0 },
+	[CSIPHY2_RESET] = { 0x0210, 31 },
+	[CSI_PIX1_RESET] = { 0x0210, 30 },
+	[CSIPHY0_RESET] = { 0x0210, 29 },
+	[CSIPHY1_RESET] = { 0x0210, 28 },
+	[CSI_RDI_RESET] = { 0x0210, 27 },
+	[CSI_PIX_RESET] = { 0x0210, 26 },
+	[DSI2_RESET] = { 0x0210, 25 },
+	[VFE_CSI_RESET] = { 0x0210, 24 },
+	[MDP_RESET] = { 0x0210, 21 },
+	[AMP_RESET] = { 0x0210, 20 },
+	[JPEGD_RESET] = { 0x0210, 19 },
+	[CSI1_RESET] = { 0x0210, 18 },
+	[VPE_RESET] = { 0x0210, 17 },
+	[MMSS_FABRIC_RESET] = { 0x0210, 16 },
+	[VFE_RESET] = { 0x0210, 15 },
+	[GFX3D_RESET] = { 0x0210, 12 },
+	[HDMI_RESET] = { 0x0210, 11 },
+	[MMSS_IMEM_RESET] = { 0x0210, 10 },
+	[IJPEG_RESET] = { 0x0210, 9 },
+	[CSI0_RESET] = { 0x0210, 8 },
+	[DSI_RESET] = { 0x0210, 7 },
+	[VCODEC_RESET] = { 0x0210, 6 },
+	[MDP_TV_RESET] = { 0x0210, 4 },
+	[MDP_VSYNC_RESET] = { 0x0210, 3 },
+	[ROT_RESET] = { 0x0210, 2 },
+	[TV_HDMI_RESET] = { 0x0210, 1 },
+	[VCAP_NPL_RESET] = { 0x0214, 4 },
+	[VCAP_RESET] = { 0x0214, 3 },
+	[CSI2_RESET] = { 0x0214, 2 },
+	[CSI_RDI1_RESET] = { 0x0214, 1 },
+	[CSI_RDI2_RESET] = { 0x0214 },
+};
+
 static const struct regmap_config mmcc_msm8960_regmap_config = {
 	.reg_bits	= 32,
 	.reg_stride	= 4,
@@ -2220,6 +2609,14 @@ static const struct regmap_config mmcc_msm8960_regmap_config = {
 	.fast_io	= true,
 };
 
+static const struct regmap_config mmcc_apq8064_regmap_config = {
+	.reg_bits	= 32,
+	.reg_stride	= 4,
+	.val_bits	= 32,
+	.max_register	= 0x350,
+	.fast_io	= true,
+};
+
 static const struct qcom_cc_desc mmcc_msm8960_desc = {
 	.config = &mmcc_msm8960_regmap_config,
 	.clks = mmcc_msm8960_clks,
@@ -2228,15 +2625,47 @@ static const struct qcom_cc_desc mmcc_msm8960_desc = {
 	.num_resets = ARRAY_SIZE(mmcc_msm8960_resets),
 };
 
+static const struct qcom_cc_desc mmcc_apq8064_desc = {
+	.config = &mmcc_apq8064_regmap_config,
+	.clks = mmcc_apq8064_clks,
+	.num_clks = ARRAY_SIZE(mmcc_apq8064_clks),
+	.resets = mmcc_apq8064_resets,
+	.num_resets = ARRAY_SIZE(mmcc_apq8064_resets),
+};
+
 static const struct of_device_id mmcc_msm8960_match_table[] = {
-	{ .compatible = "qcom,mmcc-msm8960" },
+	{ .compatible = "qcom,mmcc-msm8960", .data = &mmcc_msm8960_desc },
+	{ .compatible = "qcom,mmcc-apq8064", .data = &mmcc_apq8064_desc },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, mmcc_msm8960_match_table);
 
 static int mmcc_msm8960_probe(struct platform_device *pdev)
 {
-	return qcom_cc_probe(pdev, &mmcc_msm8960_desc);
+	const struct of_device_id *match;
+	struct regmap *regmap;
+	bool is_8064;
+	struct device *dev = &pdev->dev;
+
+	match = of_match_device(mmcc_msm8960_match_table, dev);
+	if (!match)
+		return -EINVAL;
+
+	is_8064 = of_device_is_compatible(dev->of_node, "qcom,mmcc-apq8064");
+	if (is_8064) {
+		gfx3d_src.freq_tbl = clk_tbl_gfx3d_8064;
+		gfx3d_src.clkr.hw.init = &gfx3d_8064_init;
+		gfx3d_src.s[0].parent_map = mmcc_pxo_pll8_pll2_pll15_map;
+		gfx3d_src.s[1].parent_map = mmcc_pxo_pll8_pll2_pll15_map;
+	}
+
+	regmap = qcom_cc_map(pdev, match->data);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	clk_pll_configure_sr(&pll15, regmap, &pll15_config, false);
+
+	return qcom_cc_really_probe(pdev, match->data, regmap);
 }
 
 static int mmcc_msm8960_remove(struct platform_device *pdev)
diff --git a/include/dt-bindings/clock/qcom,mmcc-msm8960.h b/include/dt-bindings/clock/qcom,mmcc-msm8960.h
index 5868ef14a777..85041b28f97f 100644
--- a/include/dt-bindings/clock/qcom,mmcc-msm8960.h
+++ b/include/dt-bindings/clock/qcom,mmcc-msm8960.h
@@ -133,5 +133,13 @@
 #define CSIPHY0_TIMER_CLK				116
 #define PLL1						117
 #define PLL2						118
+#define RGB_TV_CLK					119
+#define NPL_TV_CLK					120
+#define VCAP_AHB_CLK					121
+#define VCAP_AXI_CLK					122
+#define VCAP_SRC					123
+#define VCAP_CLK					124
+#define VCAP_NPL_CLK					125
+#define PLL15						126
 
 #endif
diff --git a/include/dt-bindings/reset/qcom,mmcc-msm8960.h b/include/dt-bindings/reset/qcom,mmcc-msm8960.h
index ba36ec680118..11741113a841 100644
--- a/include/dt-bindings/reset/qcom,mmcc-msm8960.h
+++ b/include/dt-bindings/reset/qcom,mmcc-msm8960.h
@@ -89,5 +89,13 @@
 #define CSI2_RESET					72
 #define CSI_RDI1_RESET					73
 #define CSI_RDI2_RESET					74
+#define GFX3D_AXI_RESET					75
+#define VCAP_AXI_RESET					76
+#define SMMU_VCAP_AHB_RESET				77
+#define VCAP_AHB_RESET					78
+#define CSI_RDI_RESET					79
+#define CSI_PIX_RESET					80
+#define VCAP_NPL_RESET					81
+#define VCAP_RESET					82
 
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

