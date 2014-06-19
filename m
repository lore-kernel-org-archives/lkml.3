Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202AbaFSSHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:07:30 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:47583 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933473AbaFSSH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:07:28 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: mturquette@linaro.org, galak@codeaurora.org, sboyd@codeaurora.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v1] clk: qcom: Add APQ8084 clocks for SATA, PCIe and UFS
Date: Thu, 19 Jun 2014 21:07:19 +0300
Message-Id: <1403201239-7609-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary clocks for SATA, PCIe and UFS to the
APQ8084 global clock controller (GCC). This will allow
the above device drivers to control their clocks.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---

Patch applies to clk-next + https://lkml.org/lkml/2014/6/3/443

 drivers/clk/qcom/gcc-apq8084.c               |  667 ++++++++++++++++++++++++++
 include/dt-bindings/clock/qcom,gcc-apq8084.h |   14 +
 2 files changed, 681 insertions(+)

diff --git a/drivers/clk/qcom/gcc-apq8084.c b/drivers/clk/qcom/gcc-apq8084.c
index b9e6140..ee52eb1 100644
--- a/drivers/clk/qcom/gcc-apq8084.c
+++ b/drivers/clk/qcom/gcc-apq8084.c
@@ -36,6 +36,10 @@
 #define P_GPLL0	1
 #define P_GPLL1	1
 #define P_GPLL4	2
+#define P_PCIE_0_1_PIPE_CLK 1
+#define P_SATA_ASIC0_CLK 1
+#define P_SATA_RX_CLK 1
+#define P_SLEEP_CLK 1
 
 static const u8 gcc_xo_gpll0_map[] = {
 	[P_XO]		= 0,
@@ -59,6 +63,46 @@ static const char *gcc_xo_gpll0_gpll4[] = {
 	"gpll4_vote",
 };
 
+static const u8 gcc_xo_sata_asic0_map[] = {
+	[P_XO]			= 0,
+	[P_SATA_ASIC0_CLK]	= 2,
+};
+
+static const char *gcc_xo_sata_asic0[] = {
+	"xo",
+	"sata_asic0_clk",
+};
+
+static const u8 gcc_xo_sata_rx_map[] = {
+	[P_XO]			= 0,
+	[P_SATA_RX_CLK]		= 2,
+};
+
+static const char *gcc_xo_sata_rx[] = {
+	"xo",
+	"sata_rx_clk",
+};
+
+static const u8 gcc_xo_pcie_map[] = {
+	[P_XO]			= 0,
+	[P_PCIE_0_1_PIPE_CLK]	= 2,
+};
+
+static const char *gcc_xo_pcie[] = {
+	"xo",
+	"pcie_pipe",
+};
+
+static const u8 gcc_xo_pcie_sleep_map[] = {
+	[P_XO]			= 0,
+	[P_SLEEP_CLK]		= 6,
+};
+
+static const char *gcc_xo_pcie_sleep[] = {
+	"xo",
+	"sleep_clk_src",
+};
+
 #define F(f, s, h, m, n) { (f), (s), (2 * (h) - 1), (m), (n) }
 
 static struct clk_pll gpll0 = {
@@ -178,6 +222,27 @@ static struct clk_regmap gpll4_vote = {
 	},
 };
 
+static const struct freq_tbl ftbl_gcc_ufs_axi_clk[] = {
+	F(100000000, P_GPLL0, 6, 0, 0),
+	F(200000000, P_GPLL0, 3, 0, 0),
+	F(240000000, P_GPLL0, 2.5, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 ufs_axi_clk_src = {
+	.cmd_rcgr = 0x1d64,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_ufs_axi_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "ufs_axi_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
 static const struct freq_tbl ftbl_gcc_usb30_master_clk[] = {
 	F(125000000, P_GPLL0, 1, 5, 24),
 	{ }
@@ -890,6 +955,71 @@ static struct clk_rcg2 gp3_clk_src = {
 	},
 };
 
+static const struct freq_tbl ftbl_gcc_pcie_0_1_aux_clk[] = {
+	F(1010000, P_XO, 1, 1, 19),
+	{ }
+};
+
+static struct clk_rcg2 pcie_0_aux_clk_src = {
+	.cmd_rcgr = 0x1b2c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_pcie_sleep_map,
+	.freq_tbl = ftbl_gcc_pcie_0_1_aux_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "pcie_0_aux_clk_src",
+		.parent_names = gcc_xo_pcie_sleep,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 pcie_1_aux_clk_src = {
+	.cmd_rcgr = 0x1bac,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_pcie_sleep_map,
+	.freq_tbl = ftbl_gcc_pcie_0_1_aux_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "pcie_1_aux_clk_src",
+		.parent_names = gcc_xo_pcie_sleep,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_pcie_0_1_pipe_clk[] = {
+	F(125000000, P_PCIE_0_1_PIPE_CLK, 1, 0, 0),
+	F(250000000, P_PCIE_0_1_PIPE_CLK, 1, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 pcie_0_pipe_clk_src = {
+	.cmd_rcgr = 0x1b18,
+	.hid_width = 5,
+	.parent_map = gcc_xo_pcie_map,
+	.freq_tbl = ftbl_gcc_pcie_0_1_pipe_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "pcie_0_pipe_clk_src",
+		.parent_names = gcc_xo_pcie,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 pcie_1_pipe_clk_src = {
+	.cmd_rcgr = 0x1b98,
+	.hid_width = 5,
+	.parent_map = gcc_xo_pcie_map,
+	.freq_tbl = ftbl_gcc_pcie_0_1_pipe_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "pcie_1_pipe_clk_src",
+		.parent_names = gcc_xo_pcie,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
 static const struct freq_tbl ftbl_gcc_pdm2_clk[] = {
 	F(60000000, P_GPLL0, 10, 0, 0),
 	{ }
@@ -908,6 +1038,84 @@ static struct clk_rcg2 pdm2_clk_src = {
 	},
 };
 
+static const struct freq_tbl ftbl_gcc_sata_asic0_clk[] = {
+	F(75000000, P_SATA_ASIC0_CLK, 1, 0, 0),
+	F(150000000, P_SATA_ASIC0_CLK, 1, 0, 0),
+	F(300000000, P_SATA_ASIC0_CLK, 1, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 sata_asic0_clk_src = {
+	.cmd_rcgr = 0x1c94,
+	.hid_width = 5,
+	.parent_map = gcc_xo_sata_asic0_map,
+	.freq_tbl = ftbl_gcc_sata_asic0_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "sata_asic0_clk_src",
+		.parent_names = gcc_xo_sata_asic0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_sata_pmalive_clk[] = {
+	F(19200000, P_XO, 1, 0, 0),
+	F(50000000, P_GPLL0, 12, 0, 0),
+	F(100000000, P_GPLL0, 6, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 sata_pmalive_clk_src = {
+	.cmd_rcgr = 0x1c80,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_sata_pmalive_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "sata_pmalive_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_sata_rx_clk[] = {
+	F(75000000, P_SATA_RX_CLK, 1, 0, 0),
+	F(150000000, P_SATA_RX_CLK, 1, 0, 0),
+	F(300000000, P_SATA_RX_CLK, 1, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 sata_rx_clk_src = {
+	.cmd_rcgr = 0x1ca8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_sata_rx_map,
+	.freq_tbl = ftbl_gcc_sata_rx_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "sata_rx_clk_src",
+		.parent_names = gcc_xo_sata_rx,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_sata_rx_oob_clk[] = {
+	F(100000000, P_GPLL0, 6, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 sata_rx_oob_clk_src = {
+	.cmd_rcgr = 0x1c5c,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_sata_rx_oob_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "sata_rx_oob_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
 static const struct freq_tbl ftbl_gcc_sdcc1_4_apps_clk[] = {
 	F(144000, P_XO, 16, 3, 25),
 	F(400000, P_XO, 12, 1, 4),
@@ -2071,6 +2279,176 @@ static struct clk_branch gcc_ocmem_noc_cfg_ahb_clk = {
 	},
 };
 
+static struct clk_branch gcc_pcie_0_aux_clk = {
+	.halt_reg = 0x1b10,
+	.clkr = {
+		.enable_reg = 0x1b10,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_pcie_0_aux_clk",
+			.parent_names = (const char *[]){
+				"pcie_0_aux_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_pcie_0_cfg_ahb_clk = {
+	.halt_reg = 0x1b0c,
+	.clkr = {
+		.enable_reg = 0x1b0c,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_pcie_0_cfg_ahb_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_pcie_0_mstr_axi_clk = {
+	.halt_reg = 0x1b08,
+	.clkr = {
+		.enable_reg = 0x1b08,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_pcie_0_mstr_axi_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_pcie_0_pipe_clk = {
+	.halt_reg = 0x1b14,
+	.clkr = {
+		.enable_reg = 0x1b14,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_pcie_0_pipe_clk",
+			.parent_names = (const char *[]){
+				"pcie_0_pipe_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_pcie_0_slv_axi_clk = {
+	.halt_reg = 0x1b04,
+	.clkr = {
+		.enable_reg = 0x1b04,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_pcie_0_slv_axi_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_pcie_1_aux_clk = {
+	.halt_reg = 0x1b90,
+	.clkr = {
+		.enable_reg = 0x1b90,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_pcie_1_aux_clk",
+			.parent_names = (const char *[]){
+				"pcie_1_aux_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_pcie_1_cfg_ahb_clk = {
+	.halt_reg = 0x1b8c,
+	.clkr = {
+		.enable_reg = 0x1b8c,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_pcie_1_cfg_ahb_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_pcie_1_mstr_axi_clk = {
+	.halt_reg = 0x1b88,
+	.clkr = {
+		.enable_reg = 0x1b88,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_pcie_1_mstr_axi_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_pcie_1_pipe_clk = {
+	.halt_reg = 0x1b94,
+	.clkr = {
+		.enable_reg = 0x1b94,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_pcie_1_pipe_clk",
+			.parent_names = (const char *[]){
+				"pcie_1_pipe_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_pcie_1_slv_axi_clk = {
+	.halt_reg = 0x1b84,
+	.clkr = {
+		.enable_reg = 0x1b84,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_pcie_1_slv_axi_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
 static struct clk_branch gcc_pdm2_clk = {
 	.halt_reg = 0x0ccc,
 	.clkr = {
@@ -2138,6 +2516,108 @@ static struct clk_branch gcc_prng_ahb_clk = {
 	},
 };
 
+static struct clk_branch gcc_sata_asic0_clk = {
+	.halt_reg = 0x1c54,
+	.clkr = {
+		.enable_reg = 0x1c54,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_sata_asic0_clk",
+			.parent_names = (const char *[]){
+				"sata_asic0_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sata_axi_clk = {
+	.halt_reg = 0x1c44,
+	.clkr = {
+		.enable_reg = 0x1c44,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_sata_axi_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sata_cfg_ahb_clk = {
+	.halt_reg = 0x1c48,
+	.clkr = {
+		.enable_reg = 0x1c48,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_sata_cfg_ahb_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sata_pmalive_clk = {
+	.halt_reg = 0x1c50,
+	.clkr = {
+		.enable_reg = 0x1c50,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_sata_pmalive_clk",
+			.parent_names = (const char *[]){
+				"sata_pmalive_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sata_rx_clk = {
+	.halt_reg = 0x1c58,
+	.clkr = {
+		.enable_reg = 0x1c58,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_sata_rx_clk",
+			.parent_names = (const char *[]){
+				"sata_rx_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sata_rx_oob_clk = {
+	.halt_reg = 0x1c4c,
+	.clkr = {
+		.enable_reg = 0x1c4c,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_sata_rx_oob_clk",
+			.parent_names = (const char *[]){
+				"sata_rx_oob_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
 static struct clk_branch gcc_sdcc1_ahb_clk = {
 	.halt_reg = 0x04c8,
 	.clkr = {
@@ -2302,6 +2782,23 @@ static struct clk_branch gcc_sdcc4_apps_clk = {
 	},
 };
 
+static struct clk_branch gcc_sys_noc_ufs_axi_clk = {
+	.halt_reg = 0x013c,
+	.clkr = {
+		.enable_reg = 0x013c,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_sys_noc_ufs_axi_clk",
+			.parent_names = (const char *[]){
+				"ufs_axi_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
 static struct clk_branch gcc_sys_noc_usb3_axi_clk = {
 	.halt_reg = 0x0108,
 	.clkr = {
@@ -2386,6 +2883,142 @@ static struct clk_branch gcc_tsif_ref_clk = {
 	},
 };
 
+static struct clk_branch gcc_ufs_ahb_clk = {
+	.halt_reg = 0x1d48,
+	.clkr = {
+		.enable_reg = 0x1d48,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_ufs_ahb_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ufs_axi_clk = {
+	.halt_reg = 0x1d44,
+	.clkr = {
+		.enable_reg = 0x1d44,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_ufs_axi_clk",
+			.parent_names = (const char *[]){
+				"ufs_axi_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ufs_rx_cfg_clk = {
+	.halt_reg = 0x1d50,
+	.clkr = {
+		.enable_reg = 0x1d50,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_ufs_rx_cfg_clk",
+			.parent_names = (const char *[]){
+				"ufs_axi_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ufs_rx_symbol_0_clk = {
+	.halt_reg = 0x1d5c,
+	.clkr = {
+		.enable_reg = 0x1d5c,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_ufs_rx_symbol_0_clk",
+			.parent_names = (const char *[]){
+				"ufs_rx_symbol_0_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ufs_rx_symbol_1_clk = {
+	.halt_reg = 0x1d60,
+	.clkr = {
+		.enable_reg = 0x1d60,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_ufs_rx_symbol_1_clk",
+			.parent_names = (const char *[]){
+				"ufs_rx_symbol_1_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ufs_tx_cfg_clk = {
+	.halt_reg = 0x1d4c,
+	.clkr = {
+		.enable_reg = 0x1d4c,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_ufs_tx_cfg_clk",
+			.parent_names = (const char *[]){
+				"ufs_axi_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ufs_tx_symbol_0_clk = {
+	.halt_reg = 0x1d54,
+	.clkr = {
+		.enable_reg = 0x1d54,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_ufs_tx_symbol_0_clk",
+			.parent_names = (const char *[]){
+				"ufs_tx_symbol_0_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ufs_tx_symbol_1_clk = {
+	.halt_reg = 0x1d58,
+	.clkr = {
+		.enable_reg = 0x1d58,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_ufs_tx_symbol_1_clk",
+			.parent_names = (const char *[]){
+				"ufs_tx_symbol_1_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
 static struct clk_branch gcc_usb2a_phy_sleep_clk = {
 	.halt_reg = 0x04ac,
 	.clkr = {
@@ -2628,6 +3261,7 @@ static struct clk_regmap *gcc_apq8084_clocks[] = {
 	[CONFIG_NOC_CLK_SRC] = &config_noc_clk_src.clkr,
 	[PERIPH_NOC_CLK_SRC] = &periph_noc_clk_src.clkr,
 	[SYSTEM_NOC_CLK_SRC] = &system_noc_clk_src.clkr,
+	[UFS_AXI_CLK_SRC] = &ufs_axi_clk_src.clkr,
 	[USB30_MASTER_CLK_SRC] = &usb30_master_clk_src.clkr,
 	[USB30_SEC_MASTER_CLK_SRC] = &usb30_sec_master_clk_src.clkr,
 	[USB_HSIC_AHB_CLK_SRC] = &usb_hsic_ahb_clk_src.clkr,
@@ -2673,7 +3307,15 @@ static struct clk_regmap *gcc_apq8084_clocks[] = {
 	[GP1_CLK_SRC] = &gp1_clk_src.clkr,
 	[GP2_CLK_SRC] = &gp2_clk_src.clkr,
 	[GP3_CLK_SRC] = &gp3_clk_src.clkr,
+	[PCIE_0_AUX_CLK_SRC] = &pcie_0_aux_clk_src.clkr,
+	[PCIE_0_PIPE_CLK_SRC] = &pcie_0_pipe_clk_src.clkr,
+	[PCIE_1_AUX_CLK_SRC] = &pcie_1_aux_clk_src.clkr,
+	[PCIE_1_PIPE_CLK_SRC] = &pcie_1_pipe_clk_src.clkr,
 	[PDM2_CLK_SRC] = &pdm2_clk_src.clkr,
+	[SATA_ASIC0_CLK_SRC] = &sata_asic0_clk_src.clkr,
+	[SATA_PMALIVE_CLK_SRC] = &sata_pmalive_clk_src.clkr,
+	[SATA_RX_CLK_SRC] = &sata_rx_clk_src.clkr,
+	[SATA_RX_OOB_CLK_SRC] = &sata_rx_oob_clk_src.clkr,
 	[SDCC1_APPS_CLK_SRC] = &sdcc1_apps_clk_src.clkr,
 	[SDCC2_APPS_CLK_SRC] = &sdcc2_apps_clk_src.clkr,
 	[SDCC3_APPS_CLK_SRC] = &sdcc3_apps_clk_src.clkr,
@@ -2739,10 +3381,26 @@ static struct clk_regmap *gcc_apq8084_clocks[] = {
 	[GCC_GP2_CLK] = &gcc_gp2_clk.clkr,
 	[GCC_GP3_CLK] = &gcc_gp3_clk.clkr,
 	[GCC_OCMEM_NOC_CFG_AHB_CLK] = &gcc_ocmem_noc_cfg_ahb_clk.clkr,
+	[GCC_PCIE_0_AUX_CLK] = &gcc_pcie_0_aux_clk.clkr,
+	[GCC_PCIE_0_CFG_AHB_CLK] = &gcc_pcie_0_cfg_ahb_clk.clkr,
+	[GCC_PCIE_0_MSTR_AXI_CLK] = &gcc_pcie_0_mstr_axi_clk.clkr,
+	[GCC_PCIE_0_PIPE_CLK] = &gcc_pcie_0_pipe_clk.clkr,
+	[GCC_PCIE_0_SLV_AXI_CLK] = &gcc_pcie_0_slv_axi_clk.clkr,
+	[GCC_PCIE_1_AUX_CLK] = &gcc_pcie_1_aux_clk.clkr,
+	[GCC_PCIE_1_CFG_AHB_CLK] = &gcc_pcie_1_cfg_ahb_clk.clkr,
+	[GCC_PCIE_1_MSTR_AXI_CLK] = &gcc_pcie_1_mstr_axi_clk.clkr,
+	[GCC_PCIE_1_PIPE_CLK] = &gcc_pcie_1_pipe_clk.clkr,
+	[GCC_PCIE_1_SLV_AXI_CLK] = &gcc_pcie_1_slv_axi_clk.clkr,
 	[GCC_PDM2_CLK] = &gcc_pdm2_clk.clkr,
 	[GCC_PDM_AHB_CLK] = &gcc_pdm_ahb_clk.clkr,
 	[GCC_PERIPH_NOC_USB_HSIC_AHB_CLK] = &gcc_periph_noc_usb_hsic_ahb_clk.clkr,
 	[GCC_PRNG_AHB_CLK] = &gcc_prng_ahb_clk.clkr,
+	[GCC_SATA_ASIC0_CLK] = &gcc_sata_asic0_clk.clkr,
+	[GCC_SATA_AXI_CLK] = &gcc_sata_axi_clk.clkr,
+	[GCC_SATA_CFG_AHB_CLK] = &gcc_sata_cfg_ahb_clk.clkr,
+	[GCC_SATA_PMALIVE_CLK] = &gcc_sata_pmalive_clk.clkr,
+	[GCC_SATA_RX_CLK] = &gcc_sata_rx_clk.clkr,
+	[GCC_SATA_RX_OOB_CLK] = &gcc_sata_rx_oob_clk.clkr,
 	[GCC_SDCC1_AHB_CLK] = &gcc_sdcc1_ahb_clk.clkr,
 	[GCC_SDCC1_APPS_CLK] = &gcc_sdcc1_apps_clk.clkr,
 	[GCC_SDCC1_CDCCAL_FF_CLK] = &gcc_sdcc1_cdccal_ff_clk.clkr,
@@ -2753,11 +3411,20 @@ static struct clk_regmap *gcc_apq8084_clocks[] = {
 	[GCC_SDCC3_APPS_CLK] = &gcc_sdcc3_apps_clk.clkr,
 	[GCC_SDCC4_AHB_CLK] = &gcc_sdcc4_ahb_clk.clkr,
 	[GCC_SDCC4_APPS_CLK] = &gcc_sdcc4_apps_clk.clkr,
+	[GCC_SYS_NOC_UFS_AXI_CLK] = &gcc_sys_noc_ufs_axi_clk.clkr,
 	[GCC_SYS_NOC_USB3_AXI_CLK] = &gcc_sys_noc_usb3_axi_clk.clkr,
 	[GCC_SYS_NOC_USB3_SEC_AXI_CLK] = &gcc_sys_noc_usb3_sec_axi_clk.clkr,
 	[GCC_TSIF_AHB_CLK] = &gcc_tsif_ahb_clk.clkr,
 	[GCC_TSIF_INACTIVITY_TIMERS_CLK] = &gcc_tsif_inactivity_timers_clk.clkr,
 	[GCC_TSIF_REF_CLK] = &gcc_tsif_ref_clk.clkr,
+	[GCC_UFS_AHB_CLK] = &gcc_ufs_ahb_clk.clkr,
+	[GCC_UFS_AXI_CLK] = &gcc_ufs_axi_clk.clkr,
+	[GCC_UFS_RX_CFG_CLK] = &gcc_ufs_rx_cfg_clk.clkr,
+	[GCC_UFS_RX_SYMBOL_0_CLK] = &gcc_ufs_rx_symbol_0_clk.clkr,
+	[GCC_UFS_RX_SYMBOL_1_CLK] = &gcc_ufs_rx_symbol_1_clk.clkr,
+	[GCC_UFS_TX_CFG_CLK] = &gcc_ufs_tx_cfg_clk.clkr,
+	[GCC_UFS_TX_SYMBOL_0_CLK] = &gcc_ufs_tx_symbol_0_clk.clkr,
+	[GCC_UFS_TX_SYMBOL_1_CLK] = &gcc_ufs_tx_symbol_1_clk.clkr,
 	[GCC_USB2A_PHY_SLEEP_CLK] = &gcc_usb2a_phy_sleep_clk.clkr,
 	[GCC_USB2B_PHY_SLEEP_CLK] = &gcc_usb2b_phy_sleep_clk.clkr,
 	[GCC_USB30_MASTER_CLK] = &gcc_usb30_master_clk.clkr,
diff --git a/include/dt-bindings/clock/qcom,gcc-apq8084.h b/include/dt-bindings/clock/qcom,gcc-apq8084.h
index ce5bc0f..2c0da56 100644
--- a/include/dt-bindings/clock/qcom,gcc-apq8084.h
+++ b/include/dt-bindings/clock/qcom,gcc-apq8084.h
@@ -333,5 +333,19 @@
 #define GCC_USB_HSIC_IO_CAL_SLEEP_CLK			316
 #define GCC_USB_HSIC_MOCK_UTMI_CLK			317
 #define GCC_USB_HSIC_SYSTEM_CLK				318
+#define PCIE_0_AUX_CLK_SRC				319
+#define PCIE_0_PIPE_CLK_SRC				320
+#define PCIE_1_AUX_CLK_SRC				321
+#define PCIE_1_PIPE_CLK_SRC				322
+#define GCC_PCIE_0_AUX_CLK				323
+#define GCC_PCIE_0_CFG_AHB_CLK				324
+#define GCC_PCIE_0_MSTR_AXI_CLK				325
+#define GCC_PCIE_0_PIPE_CLK				326
+#define GCC_PCIE_0_SLV_AXI_CLK				327
+#define GCC_PCIE_1_AUX_CLK				328
+#define GCC_PCIE_1_CFG_AHB_CLK				329
+#define GCC_PCIE_1_MSTR_AXI_CLK				330
+#define GCC_PCIE_1_PIPE_CLK				331
+#define GCC_PCIE_1_SLV_AXI_CLK				332
 
 #endif
-- 
1.7.9.5

