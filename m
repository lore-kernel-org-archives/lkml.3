Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaAOSrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:47:55 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49412 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaAOSro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:47:44 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH v5 08/14] clk: qcom: Add support for MSM8960's global clock controller (GCC)
Date: Wed, 15 Jan 2014 10:47:28 -0800
Message-Id: <1389811654-21397-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
References: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the global clock controller found on MSM8960
based platforms. This should allow most non-multimedia device
drivers to probe and control their clocks.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Kconfig                     |    8 +
 drivers/clk/qcom/Makefile                    |    2 +
 drivers/clk/qcom/gcc-msm8960.c               | 2993 ++++++++++++++++++++++++++
 include/dt-bindings/clock/qcom,gcc-msm8960.h |  313 +++
 include/dt-bindings/reset/qcom,gcc-msm8960.h |  118 +
 5 files changed, 3434 insertions(+)
 create mode 100644 drivers/clk/qcom/gcc-msm8960.c
 create mode 100644 include/dt-bindings/clock/qcom,gcc-msm8960.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-msm8960.h

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 06ccce65d598..8b39761dc9fb 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -3,3 +3,11 @@ config COMMON_CLK_QCOM
 	depends on OF
 	select REGMAP_MMIO
 	select RESET_CONTROLLER
+
+config MSM_GCC_8960
+	tristate "MSM8960 Global Clock Controller"
+	depends on COMMON_CLK_QCOM
+	help
+	  Support for the global clock controller on msm8960 devices.
+	  Say Y if you want to use peripheral devices such as UART, SPI,
+	  i2c, USB, SD/eMMC, SATA, PCIe, etc.
diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index ec12ec4568ff..1fb673c4f786 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -6,3 +6,5 @@ clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-rcg.o
 clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-rcg2.o
 clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-branch.o
 clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += reset.o
+
+obj-$(CONFIG_MSM_GCC_8960) += gcc-msm8960.o
diff --git a/drivers/clk/qcom/gcc-msm8960.c b/drivers/clk/qcom/gcc-msm8960.c
new file mode 100644
index 000000000000..fd446ab2fd98
--- /dev/null
+++ b/drivers/clk/qcom/gcc-msm8960.c
@@ -0,0 +1,2993 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/clk-provider.h>
+#include <linux/regmap.h>
+#include <linux/reset-controller.h>
+
+#include <dt-bindings/clock/qcom,gcc-msm8960.h>
+#include <dt-bindings/reset/qcom,gcc-msm8960.h>
+
+#include "clk-regmap.h"
+#include "clk-pll.h"
+#include "clk-rcg.h"
+#include "clk-branch.h"
+#include "reset.h"
+
+static struct clk_pll pll3 = {
+	.l_reg = 0x3164,
+	.m_reg = 0x3168,
+	.n_reg = 0x316c,
+	.config_reg = 0x3174,
+	.mode_reg = 0x3160,
+	.status_reg = 0x3178,
+	.status_bit = 16,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "pll3",
+		.parent_names = (const char *[]){ "pxo" },
+		.num_parents = 1,
+		.ops = &clk_pll_ops,
+	},
+};
+
+static struct clk_pll pll8 = {
+	.l_reg = 0x3144,
+	.m_reg = 0x3148,
+	.n_reg = 0x314c,
+	.config_reg = 0x3154,
+	.mode_reg = 0x3140,
+	.status_reg = 0x3158,
+	.status_bit = 16,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "pll8",
+		.parent_names = (const char *[]){ "pxo" },
+		.num_parents = 1,
+		.ops = &clk_pll_ops,
+	},
+};
+
+static struct clk_regmap pll8_vote = {
+	.enable_reg = 0x34c0,
+	.enable_mask = BIT(8),
+	.hw.init = &(struct clk_init_data){
+		.name = "pll8_vote",
+		.parent_names = (const char *[]){ "pll8" },
+		.num_parents = 1,
+		.ops = &clk_pll_vote_ops,
+	},
+};
+
+static struct clk_pll pll14 = {
+	.l_reg = 0x31c4,
+	.m_reg = 0x31c8,
+	.n_reg = 0x31cc,
+	.config_reg = 0x31d4,
+	.mode_reg = 0x31c0,
+	.status_reg = 0x31d8,
+	.status_bit = 16,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "pll14",
+		.parent_names = (const char *[]){ "pxo" },
+		.num_parents = 1,
+		.ops = &clk_pll_ops,
+	},
+};
+
+static struct clk_regmap pll14_vote = {
+	.enable_reg = 0x34c0,
+	.enable_mask = BIT(14),
+	.hw.init = &(struct clk_init_data){
+		.name = "pll14_vote",
+		.parent_names = (const char *[]){ "pll14" },
+		.num_parents = 1,
+		.ops = &clk_pll_vote_ops,
+	},
+};
+
+#define P_PXO	0
+#define P_PLL8	1
+#define P_CXO	2
+
+static const u8 gcc_pxo_pll8_map[] = {
+	[P_PXO]		= 0,
+	[P_PLL8]	= 3,
+};
+
+static const char *gcc_pxo_pll8[] = {
+	"pxo",
+	"pll8_vote",
+};
+
+static const u8 gcc_pxo_pll8_cxo_map[] = {
+	[P_PXO]		= 0,
+	[P_PLL8]	= 3,
+	[P_CXO]		= 5,
+};
+
+static const char *gcc_pxo_pll8_cxo[] = {
+	"pxo",
+	"pll8_vote",
+	"cxo",
+};
+
+static struct freq_tbl clk_tbl_gsbi_uart[] = {
+	{  1843200, P_PLL8, 2,  6, 625 },
+	{  3686400, P_PLL8, 2, 12, 625 },
+	{  7372800, P_PLL8, 2, 24, 625 },
+	{ 14745600, P_PLL8, 2, 48, 625 },
+	{ 16000000, P_PLL8, 4,  1,   6 },
+	{ 24000000, P_PLL8, 4,  1,   4 },
+	{ 32000000, P_PLL8, 4,  1,   3 },
+	{ 40000000, P_PLL8, 1,  5,  48 },
+	{ 46400000, P_PLL8, 1, 29, 240 },
+	{ 48000000, P_PLL8, 4,  1,   2 },
+	{ 51200000, P_PLL8, 1,  2,  15 },
+	{ 56000000, P_PLL8, 1,  7,  48 },
+	{ 58982400, P_PLL8, 1, 96, 625 },
+	{ 64000000, P_PLL8, 2,  1,   3 },
+	{ }
+};
+
+static struct clk_rcg gsbi1_uart_src = {
+	.ns_reg = 0x29d4,
+	.md_reg = 0x29d0,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 16,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_gsbi_uart,
+	.clkr = {
+		.enable_reg = 0x29d4,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi1_uart_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi1_uart_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 10,
+	.clkr = {
+		.enable_reg = 0x29d4,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi1_uart_clk",
+			.parent_names = (const char *[]){
+				"gsbi1_uart_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi2_uart_src = {
+	.ns_reg = 0x29f4,
+	.md_reg = 0x29f0,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 16,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_gsbi_uart,
+	.clkr = {
+		.enable_reg = 0x29f4,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi2_uart_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi2_uart_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 6,
+	.clkr = {
+		.enable_reg = 0x29f4,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi2_uart_clk",
+			.parent_names = (const char *[]){
+				"gsbi2_uart_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi3_uart_src = {
+	.ns_reg = 0x2a14,
+	.md_reg = 0x2a10,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 16,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_gsbi_uart,
+	.clkr = {
+		.enable_reg = 0x2a14,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi3_uart_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi3_uart_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 2,
+	.clkr = {
+		.enable_reg = 0x2a14,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi3_uart_clk",
+			.parent_names = (const char *[]){
+				"gsbi3_uart_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi4_uart_src = {
+	.ns_reg = 0x2a34,
+	.md_reg = 0x2a30,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 16,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_gsbi_uart,
+	.clkr = {
+		.enable_reg = 0x2a34,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi4_uart_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi4_uart_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 26,
+	.clkr = {
+		.enable_reg = 0x2a34,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi4_uart_clk",
+			.parent_names = (const char *[]){
+				"gsbi4_uart_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi5_uart_src = {
+	.ns_reg = 0x2a54,
+	.md_reg = 0x2a50,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 16,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_gsbi_uart,
+	.clkr = {
+		.enable_reg = 0x2a54,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi5_uart_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi5_uart_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 22,
+	.clkr = {
+		.enable_reg = 0x2a54,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi5_uart_clk",
+			.parent_names = (const char *[]){
+				"gsbi5_uart_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi6_uart_src = {
+	.ns_reg = 0x2a74,
+	.md_reg = 0x2a70,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 16,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_gsbi_uart,
+	.clkr = {
+		.enable_reg = 0x2a74,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi6_uart_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi6_uart_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 18,
+	.clkr = {
+		.enable_reg = 0x2a74,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi6_uart_clk",
+			.parent_names = (const char *[]){
+				"gsbi6_uart_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi7_uart_src = {
+	.ns_reg = 0x2a94,
+	.md_reg = 0x2a90,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 16,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_gsbi_uart,
+	.clkr = {
+		.enable_reg = 0x2a94,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi7_uart_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi7_uart_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 14,
+	.clkr = {
+		.enable_reg = 0x2a94,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi7_uart_clk",
+			.parent_names = (const char *[]){
+				"gsbi7_uart_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi8_uart_src = {
+	.ns_reg = 0x2ab4,
+	.md_reg = 0x2ab0,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 16,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_gsbi_uart,
+	.clkr = {
+		.enable_reg = 0x2ab4,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi8_uart_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi8_uart_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 10,
+	.clkr = {
+		.enable_reg = 0x2ab4,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi8_uart_clk",
+			.parent_names = (const char *[]){ "gsbi8_uart_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi9_uart_src = {
+	.ns_reg = 0x2ad4,
+	.md_reg = 0x2ad0,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 16,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_gsbi_uart,
+	.clkr = {
+		.enable_reg = 0x2ad4,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi9_uart_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi9_uart_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 6,
+	.clkr = {
+		.enable_reg = 0x2ad4,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi9_uart_clk",
+			.parent_names = (const char *[]){ "gsbi9_uart_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi10_uart_src = {
+	.ns_reg = 0x2af4,
+	.md_reg = 0x2af0,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 16,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_gsbi_uart,
+	.clkr = {
+		.enable_reg = 0x2af4,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi10_uart_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi10_uart_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 2,
+	.clkr = {
+		.enable_reg = 0x2af4,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi10_uart_clk",
+			.parent_names = (const char *[]){ "gsbi10_uart_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi11_uart_src = {
+	.ns_reg = 0x2b14,
+	.md_reg = 0x2b10,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 16,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_gsbi_uart,
+	.clkr = {
+		.enable_reg = 0x2b14,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi11_uart_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi11_uart_clk = {
+	.halt_reg = 0x2fd4,
+	.halt_bit = 17,
+	.clkr = {
+		.enable_reg = 0x2b14,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi11_uart_clk",
+			.parent_names = (const char *[]){ "gsbi11_uart_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi12_uart_src = {
+	.ns_reg = 0x2b34,
+	.md_reg = 0x2b30,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 16,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_gsbi_uart,
+	.clkr = {
+		.enable_reg = 0x2b34,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi12_uart_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi12_uart_clk = {
+	.halt_reg = 0x2fd4,
+	.halt_bit = 13,
+	.clkr = {
+		.enable_reg = 0x2b34,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi12_uart_clk",
+			.parent_names = (const char *[]){ "gsbi12_uart_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct freq_tbl clk_tbl_gsbi_qup[] = {
+	{  1100000, P_PXO,  1, 2, 49 },
+	{  5400000, P_PXO,  1, 1,  5 },
+	{ 10800000, P_PXO,  1, 2,  5 },
+	{ 15060000, P_PLL8, 1, 2, 51 },
+	{ 24000000, P_PLL8, 4, 1,  4 },
+	{ 25600000, P_PLL8, 1, 1, 15 },
+	{ 27000000, P_PXO,  1, 0,  0 },
+	{ 48000000, P_PLL8, 4, 1,  2 },
+	{ 51200000, P_PLL8, 1, 2, 15 },
+	{ }
+};
+
+static struct clk_rcg gsbi1_qup_src = {
+	.ns_reg = 0x29cc,
+	.md_reg = 0x29c8,
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
+	.freq_tbl = clk_tbl_gsbi_qup,
+	.clkr = {
+		.enable_reg = 0x29cc,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi1_qup_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi1_qup_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 9,
+	.clkr = {
+		.enable_reg = 0x29cc,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi1_qup_clk",
+			.parent_names = (const char *[]){ "gsbi1_qup_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi2_qup_src = {
+	.ns_reg = 0x29ec,
+	.md_reg = 0x29e8,
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
+	.freq_tbl = clk_tbl_gsbi_qup,
+	.clkr = {
+		.enable_reg = 0x29ec,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi2_qup_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi2_qup_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 4,
+	.clkr = {
+		.enable_reg = 0x29ec,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi2_qup_clk",
+			.parent_names = (const char *[]){ "gsbi2_qup_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi3_qup_src = {
+	.ns_reg = 0x2a0c,
+	.md_reg = 0x2a08,
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
+	.freq_tbl = clk_tbl_gsbi_qup,
+	.clkr = {
+		.enable_reg = 0x2a0c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi3_qup_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi3_qup_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 0,
+	.clkr = {
+		.enable_reg = 0x2a0c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi3_qup_clk",
+			.parent_names = (const char *[]){ "gsbi3_qup_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi4_qup_src = {
+	.ns_reg = 0x2a2c,
+	.md_reg = 0x2a28,
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
+	.freq_tbl = clk_tbl_gsbi_qup,
+	.clkr = {
+		.enable_reg = 0x2a2c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi4_qup_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi4_qup_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 24,
+	.clkr = {
+		.enable_reg = 0x2a2c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi4_qup_clk",
+			.parent_names = (const char *[]){ "gsbi4_qup_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi5_qup_src = {
+	.ns_reg = 0x2a4c,
+	.md_reg = 0x2a48,
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
+	.freq_tbl = clk_tbl_gsbi_qup,
+	.clkr = {
+		.enable_reg = 0x2a4c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi5_qup_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi5_qup_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 20,
+	.clkr = {
+		.enable_reg = 0x2a4c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi5_qup_clk",
+			.parent_names = (const char *[]){ "gsbi5_qup_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi6_qup_src = {
+	.ns_reg = 0x2a6c,
+	.md_reg = 0x2a68,
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
+	.freq_tbl = clk_tbl_gsbi_qup,
+	.clkr = {
+		.enable_reg = 0x2a6c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi6_qup_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi6_qup_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 16,
+	.clkr = {
+		.enable_reg = 0x2a6c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi6_qup_clk",
+			.parent_names = (const char *[]){ "gsbi6_qup_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi7_qup_src = {
+	.ns_reg = 0x2a8c,
+	.md_reg = 0x2a88,
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
+	.freq_tbl = clk_tbl_gsbi_qup,
+	.clkr = {
+		.enable_reg = 0x2a8c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi7_qup_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi7_qup_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 12,
+	.clkr = {
+		.enable_reg = 0x2a8c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi7_qup_clk",
+			.parent_names = (const char *[]){ "gsbi7_qup_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi8_qup_src = {
+	.ns_reg = 0x2aac,
+	.md_reg = 0x2aa8,
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
+	.freq_tbl = clk_tbl_gsbi_qup,
+	.clkr = {
+		.enable_reg = 0x2aac,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi8_qup_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi8_qup_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 8,
+	.clkr = {
+		.enable_reg = 0x2aac,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi8_qup_clk",
+			.parent_names = (const char *[]){ "gsbi8_qup_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi9_qup_src = {
+	.ns_reg = 0x2acc,
+	.md_reg = 0x2ac8,
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
+	.freq_tbl = clk_tbl_gsbi_qup,
+	.clkr = {
+		.enable_reg = 0x2acc,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi9_qup_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi9_qup_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 4,
+	.clkr = {
+		.enable_reg = 0x2acc,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi9_qup_clk",
+			.parent_names = (const char *[]){ "gsbi9_qup_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi10_qup_src = {
+	.ns_reg = 0x2aec,
+	.md_reg = 0x2ae8,
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
+	.freq_tbl = clk_tbl_gsbi_qup,
+	.clkr = {
+		.enable_reg = 0x2aec,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi10_qup_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi10_qup_clk = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 0,
+	.clkr = {
+		.enable_reg = 0x2aec,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi10_qup_clk",
+			.parent_names = (const char *[]){ "gsbi10_qup_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi11_qup_src = {
+	.ns_reg = 0x2b0c,
+	.md_reg = 0x2b08,
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
+	.freq_tbl = clk_tbl_gsbi_qup,
+	.clkr = {
+		.enable_reg = 0x2b0c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi11_qup_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi11_qup_clk = {
+	.halt_reg = 0x2fd4,
+	.halt_bit = 15,
+	.clkr = {
+		.enable_reg = 0x2b0c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi11_qup_clk",
+			.parent_names = (const char *[]){ "gsbi11_qup_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gsbi12_qup_src = {
+	.ns_reg = 0x2b2c,
+	.md_reg = 0x2b28,
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
+	.freq_tbl = clk_tbl_gsbi_qup,
+	.clkr = {
+		.enable_reg = 0x2b2c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi12_qup_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	},
+};
+
+static struct clk_branch gsbi12_qup_clk = {
+	.halt_reg = 0x2fd4,
+	.halt_bit = 11,
+	.clkr = {
+		.enable_reg = 0x2b2c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi12_qup_clk",
+			.parent_names = (const char *[]){ "gsbi12_qup_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static const struct freq_tbl clk_tbl_gp[] = {
+	{ 9600000, P_CXO,  2, 0, 0 },
+	{ 13500000, P_PXO,  2, 0, 0 },
+	{ 19200000, P_CXO,  1, 0, 0 },
+	{ 27000000, P_PXO,  1, 0, 0 },
+	{ 64000000, P_PLL8, 2, 1, 3 },
+	{ 76800000, P_PLL8, 1, 1, 5 },
+	{ 96000000, P_PLL8, 4, 0, 0 },
+	{ 128000000, P_PLL8, 3, 0, 0 },
+	{ 192000000, P_PLL8, 2, 0, 0 },
+	{ }
+};
+
+static struct clk_rcg gp0_src = {
+	.ns_reg = 0x2d24,
+	.md_reg = 0x2d00,
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
+		.parent_map = gcc_pxo_pll8_cxo_map,
+	},
+	.freq_tbl = clk_tbl_gp,
+	.clkr = {
+		.enable_reg = 0x2d24,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gp0_src",
+			.parent_names = gcc_pxo_pll8_cxo,
+			.num_parents = 3,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_PARENT_GATE,
+		},
+	}
+};
+
+static struct clk_branch gp0_clk = {
+	.halt_reg = 0x2fd8,
+	.halt_bit = 7,
+	.clkr = {
+		.enable_reg = 0x2d24,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gp0_clk",
+			.parent_names = (const char *[]){ "gp0_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gp1_src = {
+	.ns_reg = 0x2d44,
+	.md_reg = 0x2d40,
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
+		.parent_map = gcc_pxo_pll8_cxo_map,
+	},
+	.freq_tbl = clk_tbl_gp,
+	.clkr = {
+		.enable_reg = 0x2d44,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gp1_src",
+			.parent_names = gcc_pxo_pll8_cxo,
+			.num_parents = 3,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static struct clk_branch gp1_clk = {
+	.halt_reg = 0x2fd8,
+	.halt_bit = 6,
+	.clkr = {
+		.enable_reg = 0x2d44,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gp1_clk",
+			.parent_names = (const char *[]){ "gp1_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg gp2_src = {
+	.ns_reg = 0x2d64,
+	.md_reg = 0x2d60,
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
+		.parent_map = gcc_pxo_pll8_cxo_map,
+	},
+	.freq_tbl = clk_tbl_gp,
+	.clkr = {
+		.enable_reg = 0x2d64,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "gp2_src",
+			.parent_names = gcc_pxo_pll8_cxo,
+			.num_parents = 3,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static struct clk_branch gp2_clk = {
+	.halt_reg = 0x2fd8,
+	.halt_bit = 5,
+	.clkr = {
+		.enable_reg = 0x2d64,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "gp2_clk",
+			.parent_names = (const char *[]){ "gp2_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_branch pmem_clk = {
+	.hwcg_reg = 0x25a0,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fc8,
+	.halt_bit = 20,
+	.clkr = {
+		.enable_reg = 0x25a0,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "pmem_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_rcg prng_src = {
+	.ns_reg = 0x2e80,
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 4,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.clkr = {
+		.hw.init = &(struct clk_init_data){
+			.name = "prng_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+		},
+	},
+};
+
+static struct clk_branch prng_clk = {
+	.halt_reg = 0x2fd8,
+	.halt_check = BRANCH_HALT_VOTED,
+	.halt_bit = 10,
+	.clkr = {
+		.enable_reg = 0x3080,
+		.enable_mask = BIT(10),
+		.hw.init = &(struct clk_init_data){
+			.name = "prng_clk",
+			.parent_names = (const char *[]){ "prng_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+		},
+	},
+};
+
+static const struct freq_tbl clk_tbl_sdc[] = {
+	{    144000, P_PXO,   3, 2, 125 },
+	{    400000, P_PLL8,  4, 1, 240 },
+	{  16000000, P_PLL8,  4, 1,   6 },
+	{  17070000, P_PLL8,  1, 2,  45 },
+	{  20210000, P_PLL8,  1, 1,  19 },
+	{  24000000, P_PLL8,  4, 1,   4 },
+	{  48000000, P_PLL8,  4, 1,   2 },
+	{  64000000, P_PLL8,  3, 1,   2 },
+	{  96000000, P_PLL8,  4, 0,   0 },
+	{ 192000000, P_PLL8,  2, 0,   0 },
+	{ }
+};
+
+static struct clk_rcg sdc1_src = {
+	.ns_reg = 0x282c,
+	.md_reg = 0x2828,
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
+	.freq_tbl = clk_tbl_sdc,
+	.clkr = {
+		.enable_reg = 0x282c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc1_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static struct clk_branch sdc1_clk = {
+	.halt_reg = 0x2fc8,
+	.halt_bit = 6,
+	.clkr = {
+		.enable_reg = 0x282c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc1_clk",
+			.parent_names = (const char *[]){ "sdc1_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg sdc2_src = {
+	.ns_reg = 0x284c,
+	.md_reg = 0x2848,
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
+	.freq_tbl = clk_tbl_sdc,
+	.clkr = {
+		.enable_reg = 0x284c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc2_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static struct clk_branch sdc2_clk = {
+	.halt_reg = 0x2fc8,
+	.halt_bit = 5,
+	.clkr = {
+		.enable_reg = 0x284c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc2_clk",
+			.parent_names = (const char *[]){ "sdc2_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg sdc3_src = {
+	.ns_reg = 0x286c,
+	.md_reg = 0x2868,
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
+	.freq_tbl = clk_tbl_sdc,
+	.clkr = {
+		.enable_reg = 0x286c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc3_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static struct clk_branch sdc3_clk = {
+	.halt_reg = 0x2fc8,
+	.halt_bit = 4,
+	.clkr = {
+		.enable_reg = 0x286c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc3_clk",
+			.parent_names = (const char *[]){ "sdc3_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg sdc4_src = {
+	.ns_reg = 0x288c,
+	.md_reg = 0x2888,
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
+	.freq_tbl = clk_tbl_sdc,
+	.clkr = {
+		.enable_reg = 0x288c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc4_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static struct clk_branch sdc4_clk = {
+	.halt_reg = 0x2fc8,
+	.halt_bit = 3,
+	.clkr = {
+		.enable_reg = 0x288c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc4_clk",
+			.parent_names = (const char *[]){ "sdc4_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg sdc5_src = {
+	.ns_reg = 0x28ac,
+	.md_reg = 0x28a8,
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
+	.freq_tbl = clk_tbl_sdc,
+	.clkr = {
+		.enable_reg = 0x28ac,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc5_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static struct clk_branch sdc5_clk = {
+	.halt_reg = 0x2fc8,
+	.halt_bit = 2,
+	.clkr = {
+		.enable_reg = 0x28ac,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc5_clk",
+			.parent_names = (const char *[]){ "sdc5_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static const struct freq_tbl clk_tbl_tsif_ref[] = {
+	{ 105000, P_PXO,  1, 1, 256 },
+	{ }
+};
+
+static struct clk_rcg tsif_ref_src = {
+	.ns_reg = 0x2710,
+	.md_reg = 0x270c,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 16,
+		.m_val_shift = 16,
+		.width = 16,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = gcc_pxo_pll8_map,
+	},
+	.freq_tbl = clk_tbl_tsif_ref,
+	.clkr = {
+		.enable_reg = 0x2710,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "tsif_ref_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static struct clk_branch tsif_ref_clk = {
+	.halt_reg = 0x2fd4,
+	.halt_bit = 5,
+	.clkr = {
+		.enable_reg = 0x2710,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "tsif_ref_clk",
+			.parent_names = (const char *[]){ "tsif_ref_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static const struct freq_tbl clk_tbl_usb[] = {
+	{ 60000000, P_PLL8, 1, 5, 32 },
+	{ }
+};
+
+static struct clk_rcg usb_hs1_xcvr_src = {
+	.ns_reg = 0x290c,
+	.md_reg = 0x2908,
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
+		.enable_reg = 0x290c,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_hs1_xcvr_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static struct clk_branch usb_hs1_xcvr_clk = {
+	.halt_reg = 0x2fc8,
+	.halt_bit = 0,
+	.clkr = {
+		.enable_reg = 0x290c,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_hs1_xcvr_clk",
+			.parent_names = (const char *[]){ "usb_hs1_xcvr_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg usb_hsic_xcvr_fs_src = {
+	.ns_reg = 0x2928,
+	.md_reg = 0x2924,
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
+		.enable_reg = 0x2928,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_hsic_xcvr_fs_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static const char *usb_hsic_xcvr_fs_src_p[] = { "usb_hsic_xcvr_fs_src" };
+
+static struct clk_branch usb_hsic_xcvr_fs_clk = {
+	.halt_reg = 0x2fc8,
+	.halt_bit = 2,
+	.clkr = {
+		.enable_reg = 0x2928,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_hsic_xcvr_fs_clk",
+			.parent_names = usb_hsic_xcvr_fs_src_p,
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_branch usb_hsic_system_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 24,
+	.clkr = {
+		.enable_reg = 0x292c,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.parent_names = usb_hsic_xcvr_fs_src_p,
+			.num_parents = 1,
+			.name = "usb_hsic_system_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_branch usb_hsic_hsic_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 19,
+	.clkr = {
+		.enable_reg = 0x2b44,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.parent_names = (const char *[]){ "pll14_vote" },
+			.num_parents = 1,
+			.name = "usb_hsic_hsic_clk",
+			.ops = &clk_branch_ops,
+		},
+	},
+};
+
+static struct clk_branch usb_hsic_hsio_cal_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 23,
+	.clkr = {
+		.enable_reg = 0x2b48,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_hsic_hsio_cal_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_rcg usb_fs1_xcvr_fs_src = {
+	.ns_reg = 0x2968,
+	.md_reg = 0x2964,
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
+		.enable_reg = 0x2968,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_fs1_xcvr_fs_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static const char *usb_fs1_xcvr_fs_src_p[] = { "usb_fs1_xcvr_fs_src" };
+
+static struct clk_branch usb_fs1_xcvr_fs_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 15,
+	.clkr = {
+		.enable_reg = 0x2968,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_fs1_xcvr_fs_clk",
+			.parent_names = usb_fs1_xcvr_fs_src_p,
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_branch usb_fs1_system_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 16,
+	.clkr = {
+		.enable_reg = 0x296c,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.parent_names = usb_fs1_xcvr_fs_src_p,
+			.num_parents = 1,
+			.name = "usb_fs1_system_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg usb_fs2_xcvr_fs_src = {
+	.ns_reg = 0x2988,
+	.md_reg = 0x2984,
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
+		.enable_reg = 0x2988,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_fs2_xcvr_fs_src",
+			.parent_names = gcc_pxo_pll8,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	}
+};
+
+static const char *usb_fs2_xcvr_fs_src_p[] = { "usb_fs2_xcvr_fs_src" };
+
+static struct clk_branch usb_fs2_xcvr_fs_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 12,
+	.clkr = {
+		.enable_reg = 0x2988,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_fs2_xcvr_fs_clk",
+			.parent_names = usb_fs2_xcvr_fs_src_p,
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_branch usb_fs2_system_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 13,
+	.clkr = {
+		.enable_reg = 0x298c,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_fs2_system_clk",
+			.parent_names = usb_fs2_xcvr_fs_src_p,
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_branch ce1_core_clk = {
+	.hwcg_reg = 0x2724,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fd4,
+	.halt_bit = 27,
+	.clkr = {
+		.enable_reg = 0x2724,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "ce1_core_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch ce1_h_clk = {
+	.halt_reg = 0x2fd4,
+	.halt_bit = 1,
+	.clkr = {
+		.enable_reg = 0x2720,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "ce1_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch dma_bam_h_clk = {
+	.hwcg_reg = 0x25c0,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fc8,
+	.halt_bit = 12,
+	.clkr = {
+		.enable_reg = 0x25c0,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "dma_bam_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch gsbi1_h_clk = {
+	.hwcg_reg = 0x29c0,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fcc,
+	.halt_bit = 11,
+	.clkr = {
+		.enable_reg = 0x29c0,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi1_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch gsbi2_h_clk = {
+	.hwcg_reg = 0x29e0,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fcc,
+	.halt_bit = 7,
+	.clkr = {
+		.enable_reg = 0x29e0,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi2_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch gsbi3_h_clk = {
+	.hwcg_reg = 0x2a00,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fcc,
+	.halt_bit = 3,
+	.clkr = {
+		.enable_reg = 0x2a00,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi3_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch gsbi4_h_clk = {
+	.hwcg_reg = 0x2a20,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fd0,
+	.halt_bit = 27,
+	.clkr = {
+		.enable_reg = 0x2a20,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi4_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch gsbi5_h_clk = {
+	.hwcg_reg = 0x2a40,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fd0,
+	.halt_bit = 23,
+	.clkr = {
+		.enable_reg = 0x2a40,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi5_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch gsbi6_h_clk = {
+	.hwcg_reg = 0x2a60,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fd0,
+	.halt_bit = 19,
+	.clkr = {
+		.enable_reg = 0x2a60,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi6_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch gsbi7_h_clk = {
+	.hwcg_reg = 0x2a80,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fd0,
+	.halt_bit = 15,
+	.clkr = {
+		.enable_reg = 0x2a80,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi7_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch gsbi8_h_clk = {
+	.hwcg_reg = 0x2aa0,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fd0,
+	.halt_bit = 11,
+	.clkr = {
+		.enable_reg = 0x2aa0,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi8_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch gsbi9_h_clk = {
+	.hwcg_reg = 0x2ac0,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fd0,
+	.halt_bit = 7,
+	.clkr = {
+		.enable_reg = 0x2ac0,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi9_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch gsbi10_h_clk = {
+	.hwcg_reg = 0x2ae0,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fd0,
+	.halt_bit = 3,
+	.clkr = {
+		.enable_reg = 0x2ae0,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi10_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch gsbi11_h_clk = {
+	.hwcg_reg = 0x2b00,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fd4,
+	.halt_bit = 18,
+	.clkr = {
+		.enable_reg = 0x2b00,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi11_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch gsbi12_h_clk = {
+	.hwcg_reg = 0x2b20,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fd4,
+	.halt_bit = 14,
+	.clkr = {
+		.enable_reg = 0x2b20,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "gsbi12_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch tsif_h_clk = {
+	.hwcg_reg = 0x2700,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fd4,
+	.halt_bit = 7,
+	.clkr = {
+		.enable_reg = 0x2700,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "tsif_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch usb_fs1_h_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 17,
+	.clkr = {
+		.enable_reg = 0x2960,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_fs1_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch usb_fs2_h_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 14,
+	.clkr = {
+		.enable_reg = 0x2980,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_fs2_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch usb_hs1_h_clk = {
+	.hwcg_reg = 0x2900,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fc8,
+	.halt_bit = 1,
+	.clkr = {
+		.enable_reg = 0x2900,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_hs1_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch usb_hsic_h_clk = {
+	.halt_reg = 0x2fcc,
+	.halt_bit = 28,
+	.clkr = {
+		.enable_reg = 0x2920,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "usb_hsic_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch sdc1_h_clk = {
+	.hwcg_reg = 0x2820,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fc8,
+	.halt_bit = 11,
+	.clkr = {
+		.enable_reg = 0x2820,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc1_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch sdc2_h_clk = {
+	.hwcg_reg = 0x2840,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fc8,
+	.halt_bit = 10,
+	.clkr = {
+		.enable_reg = 0x2840,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc2_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch sdc3_h_clk = {
+	.hwcg_reg = 0x2860,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fc8,
+	.halt_bit = 9,
+	.clkr = {
+		.enable_reg = 0x2860,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc3_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch sdc4_h_clk = {
+	.hwcg_reg = 0x2880,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fc8,
+	.halt_bit = 8,
+	.clkr = {
+		.enable_reg = 0x2880,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc4_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch sdc5_h_clk = {
+	.hwcg_reg = 0x28a0,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fc8,
+	.halt_bit = 7,
+	.clkr = {
+		.enable_reg = 0x28a0,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "sdc5_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch adm0_clk = {
+	.halt_reg = 0x2fdc,
+	.halt_check = BRANCH_HALT_VOTED,
+	.halt_bit = 14,
+	.clkr = {
+		.enable_reg = 0x3080,
+		.enable_mask = BIT(2),
+		.hw.init = &(struct clk_init_data){
+			.name = "adm0_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch adm0_pbus_clk = {
+	.hwcg_reg = 0x2208,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fdc,
+	.halt_check = BRANCH_HALT_VOTED,
+	.halt_bit = 13,
+	.clkr = {
+		.enable_reg = 0x3080,
+		.enable_mask = BIT(3),
+		.hw.init = &(struct clk_init_data){
+			.name = "adm0_pbus_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch pmic_arb0_h_clk = {
+	.halt_reg = 0x2fd8,
+	.halt_check = BRANCH_HALT_VOTED,
+	.halt_bit = 22,
+	.clkr = {
+		.enable_reg = 0x3080,
+		.enable_mask = BIT(8),
+		.hw.init = &(struct clk_init_data){
+			.name = "pmic_arb0_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch pmic_arb1_h_clk = {
+	.halt_reg = 0x2fd8,
+	.halt_check = BRANCH_HALT_VOTED,
+	.halt_bit = 21,
+	.clkr = {
+		.enable_reg = 0x3080,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "pmic_arb1_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch pmic_ssbi2_clk = {
+	.halt_reg = 0x2fd8,
+	.halt_check = BRANCH_HALT_VOTED,
+	.halt_bit = 23,
+	.clkr = {
+		.enable_reg = 0x3080,
+		.enable_mask = BIT(7),
+		.hw.init = &(struct clk_init_data){
+			.name = "pmic_ssbi2_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch rpm_msg_ram_h_clk = {
+	.hwcg_reg = 0x27e0,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fd8,
+	.halt_check = BRANCH_HALT_VOTED,
+	.halt_bit = 12,
+	.clkr = {
+		.enable_reg = 0x3080,
+		.enable_mask = BIT(6),
+		.hw.init = &(struct clk_init_data){
+			.name = "rpm_msg_ram_h_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_regmap *gcc_msm8960_clks[] = {
+	[PLL3] = &pll3.clkr,
+	[PLL8] = &pll8.clkr,
+	[PLL8_VOTE] = &pll8_vote,
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
+	[GSBI7_UART_SRC] = &gsbi7_uart_src.clkr,
+	[GSBI7_UART_CLK] = &gsbi7_uart_clk.clkr,
+	[GSBI8_UART_SRC] = &gsbi8_uart_src.clkr,
+	[GSBI8_UART_CLK] = &gsbi8_uart_clk.clkr,
+	[GSBI9_UART_SRC] = &gsbi9_uart_src.clkr,
+	[GSBI9_UART_CLK] = &gsbi9_uart_clk.clkr,
+	[GSBI10_UART_SRC] = &gsbi10_uart_src.clkr,
+	[GSBI10_UART_CLK] = &gsbi10_uart_clk.clkr,
+	[GSBI11_UART_SRC] = &gsbi11_uart_src.clkr,
+	[GSBI11_UART_CLK] = &gsbi11_uart_clk.clkr,
+	[GSBI12_UART_SRC] = &gsbi12_uart_src.clkr,
+	[GSBI12_UART_CLK] = &gsbi12_uart_clk.clkr,
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
+	[GSBI7_QUP_SRC] = &gsbi7_qup_src.clkr,
+	[GSBI7_QUP_CLK] = &gsbi7_qup_clk.clkr,
+	[GSBI8_QUP_SRC] = &gsbi8_qup_src.clkr,
+	[GSBI8_QUP_CLK] = &gsbi8_qup_clk.clkr,
+	[GSBI9_QUP_SRC] = &gsbi9_qup_src.clkr,
+	[GSBI9_QUP_CLK] = &gsbi9_qup_clk.clkr,
+	[GSBI10_QUP_SRC] = &gsbi10_qup_src.clkr,
+	[GSBI10_QUP_CLK] = &gsbi10_qup_clk.clkr,
+	[GSBI11_QUP_SRC] = &gsbi11_qup_src.clkr,
+	[GSBI11_QUP_CLK] = &gsbi11_qup_clk.clkr,
+	[GSBI12_QUP_SRC] = &gsbi12_qup_src.clkr,
+	[GSBI12_QUP_CLK] = &gsbi12_qup_clk.clkr,
+	[GP0_SRC] = &gp0_src.clkr,
+	[GP0_CLK] = &gp0_clk.clkr,
+	[GP1_SRC] = &gp1_src.clkr,
+	[GP1_CLK] = &gp1_clk.clkr,
+	[GP2_SRC] = &gp2_src.clkr,
+	[GP2_CLK] = &gp2_clk.clkr,
+	[PMEM_A_CLK] = &pmem_clk.clkr,
+	[PRNG_SRC] = &prng_src.clkr,
+	[PRNG_CLK] = &prng_clk.clkr,
+	[SDC1_SRC] = &sdc1_src.clkr,
+	[SDC1_CLK] = &sdc1_clk.clkr,
+	[SDC2_SRC] = &sdc2_src.clkr,
+	[SDC2_CLK] = &sdc2_clk.clkr,
+	[SDC3_SRC] = &sdc3_src.clkr,
+	[SDC3_CLK] = &sdc3_clk.clkr,
+	[SDC4_SRC] = &sdc4_src.clkr,
+	[SDC4_CLK] = &sdc4_clk.clkr,
+	[SDC5_SRC] = &sdc5_src.clkr,
+	[SDC5_CLK] = &sdc5_clk.clkr,
+	[TSIF_REF_SRC] = &tsif_ref_src.clkr,
+	[TSIF_REF_CLK] = &tsif_ref_clk.clkr,
+	[USB_HS1_XCVR_SRC] = &usb_hs1_xcvr_src.clkr,
+	[USB_HS1_XCVR_CLK] = &usb_hs1_xcvr_clk.clkr,
+	[USB_HSIC_XCVR_FS_SRC] = &usb_hsic_xcvr_fs_src.clkr,
+	[USB_HSIC_XCVR_FS_CLK] = &usb_hsic_xcvr_fs_clk.clkr,
+	[USB_HSIC_SYSTEM_CLK] = &usb_hsic_system_clk.clkr,
+	[USB_HSIC_HSIC_CLK] = &usb_hsic_hsic_clk.clkr,
+	[USB_HSIC_HSIO_CAL_CLK] = &usb_hsic_hsio_cal_clk.clkr,
+	[USB_FS1_XCVR_FS_SRC] = &usb_fs1_xcvr_fs_src.clkr,
+	[USB_FS1_XCVR_FS_CLK] = &usb_fs1_xcvr_fs_clk.clkr,
+	[USB_FS1_SYSTEM_CLK] = &usb_fs1_system_clk.clkr,
+	[USB_FS2_XCVR_FS_SRC] = &usb_fs2_xcvr_fs_src.clkr,
+	[USB_FS2_XCVR_FS_CLK] = &usb_fs2_xcvr_fs_clk.clkr,
+	[USB_FS2_SYSTEM_CLK] = &usb_fs2_system_clk.clkr,
+	[CE1_CORE_CLK] = &ce1_core_clk.clkr,
+	[CE1_H_CLK] = &ce1_h_clk.clkr,
+	[DMA_BAM_H_CLK] = &dma_bam_h_clk.clkr,
+	[GSBI1_H_CLK] = &gsbi1_h_clk.clkr,
+	[GSBI2_H_CLK] = &gsbi2_h_clk.clkr,
+	[GSBI3_H_CLK] = &gsbi3_h_clk.clkr,
+	[GSBI4_H_CLK] = &gsbi4_h_clk.clkr,
+	[GSBI5_H_CLK] = &gsbi5_h_clk.clkr,
+	[GSBI6_H_CLK] = &gsbi6_h_clk.clkr,
+	[GSBI7_H_CLK] = &gsbi7_h_clk.clkr,
+	[GSBI8_H_CLK] = &gsbi8_h_clk.clkr,
+	[GSBI9_H_CLK] = &gsbi9_h_clk.clkr,
+	[GSBI10_H_CLK] = &gsbi10_h_clk.clkr,
+	[GSBI11_H_CLK] = &gsbi11_h_clk.clkr,
+	[GSBI12_H_CLK] = &gsbi12_h_clk.clkr,
+	[TSIF_H_CLK] = &tsif_h_clk.clkr,
+	[USB_FS1_H_CLK] = &usb_fs1_h_clk.clkr,
+	[USB_FS2_H_CLK] = &usb_fs2_h_clk.clkr,
+	[USB_HS1_H_CLK] = &usb_hs1_h_clk.clkr,
+	[USB_HSIC_H_CLK] = &usb_hsic_h_clk.clkr,
+	[SDC1_H_CLK] = &sdc1_h_clk.clkr,
+	[SDC2_H_CLK] = &sdc2_h_clk.clkr,
+	[SDC3_H_CLK] = &sdc3_h_clk.clkr,
+	[SDC4_H_CLK] = &sdc4_h_clk.clkr,
+	[SDC5_H_CLK] = &sdc5_h_clk.clkr,
+	[ADM0_CLK] = &adm0_clk.clkr,
+	[ADM0_PBUS_CLK] = &adm0_pbus_clk.clkr,
+	[PMIC_ARB0_H_CLK] = &pmic_arb0_h_clk.clkr,
+	[PMIC_ARB1_H_CLK] = &pmic_arb1_h_clk.clkr,
+	[PMIC_SSBI2_CLK] = &pmic_ssbi2_clk.clkr,
+	[RPM_MSG_RAM_H_CLK] = &rpm_msg_ram_h_clk.clkr,
+};
+
+static const struct qcom_reset_map gcc_msm8960_resets[] = {
+	[SFAB_MSS_Q6_SW_RESET] = { 0x2040, 7 },
+	[SFAB_MSS_Q6_FW_RESET] = { 0x2044, 7 },
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
+	[PCIE_A_RESET] = { 0x22c0, 7 },
+	[PCIE_AUX_RESET] = { 0x22c8, 7 },
+	[PCIE_H_RESET] = { 0x22d0, 7 },
+	[SFAB_PCIE_M_RESET] = { 0x22d4, 1 },
+	[SFAB_PCIE_S_RESET] = { 0x22d4 },
+	[SFAB_MSS_M_RESET] = { 0x2340, 7 },
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
+	[SIC_TIC_RESET] = { 0x2600, 7 },
+	[SLIMBUS_H_RESET] = { 0x2620, 7 },
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
+	[PMIC_SSBI2_RESET] = { 0x270c, 12 },
+	[SDC1_RESET] = { 0x2830 },
+	[SDC2_RESET] = { 0x2850 },
+	[SDC3_RESET] = { 0x2870 },
+	[SDC4_RESET] = { 0x2890 },
+	[SDC5_RESET] = { 0x28b0 },
+	[DFAB_A2_RESET] = { 0x28c0, 7 },
+	[USB_HS1_RESET] = { 0x2910 },
+	[USB_HSIC_RESET] = { 0x2934 },
+	[USB_FS1_XCVR_RESET] = { 0x2974, 1 },
+	[USB_FS1_RESET] = { 0x2974 },
+	[USB_FS2_XCVR_RESET] = { 0x2994, 1 },
+	[USB_FS2_RESET] = { 0x2994 },
+	[GSBI1_RESET] = { 0x29dc },
+	[GSBI2_RESET] = { 0x29fc },
+	[GSBI3_RESET] = { 0x2a1c },
+	[GSBI4_RESET] = { 0x2a3c },
+	[GSBI5_RESET] = { 0x2a5c },
+	[GSBI6_RESET] = { 0x2a7c },
+	[GSBI7_RESET] = { 0x2a9c },
+	[GSBI8_RESET] = { 0x2abc },
+	[GSBI9_RESET] = { 0x2adc },
+	[GSBI10_RESET] = { 0x2afc },
+	[GSBI11_RESET] = { 0x2b1c },
+	[GSBI12_RESET] = { 0x2b3c },
+	[SPDM_RESET] = { 0x2b6c },
+	[TLMM_H_RESET] = { 0x2ba0, 7 },
+	[SFAB_MSS_S_RESET] = { 0x2c00, 7 },
+	[MSS_SLP_RESET] = { 0x2c60, 7 },
+	[MSS_Q6SW_JTAG_RESET] = { 0x2c68, 7 },
+	[MSS_Q6FW_JTAG_RESET] = { 0x2c6c, 7 },
+	[MSS_RESET] = { 0x2c64 },
+	[SATA_H_RESET] = { 0x2c80, 7 },
+	[SATA_RXOOB_RESE] = { 0x2c8c, 7 },
+	[SATA_PMALIVE_RESET] = { 0x2c90, 7 },
+	[SATA_SFAB_M_RESET] = { 0x2c98, 7 },
+	[TSSC_RESET] = { 0x2ca0, 7 },
+	[PDM_RESET] = { 0x2cc0, 12 },
+	[MPM_H_RESET] = { 0x2da0, 7 },
+	[MPM_RESET] = { 0x2da4 },
+	[SFAB_SMPSS_S_RESET] = { 0x2e00, 7 },
+	[PRNG_RESET] = { 0x2e80, 12 },
+	[RIVA_RESET] = { 0x35e0 },
+};
+
+static const struct regmap_config gcc_msm8960_regmap_config = {
+	.reg_bits	= 32,
+	.reg_stride	= 4,
+	.val_bits	= 32,
+	.max_register	= 0x3660,
+	.fast_io	= true,
+};
+
+static const struct of_device_id gcc_msm8960_match_table[] = {
+	{ .compatible = "qcom,gcc-msm8960" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, gcc_msm8960_match_table);
+
+struct qcom_cc {
+	struct qcom_reset_controller reset;
+	struct clk_onecell_data data;
+	struct clk *clks[];
+};
+
+static int gcc_msm8960_probe(struct platform_device *pdev)
+{
+	void __iomem *base;
+	struct resource *res;
+	int i, ret;
+	struct device *dev = &pdev->dev;
+	struct clk *clk;
+	struct clk_onecell_data *data;
+	struct clk **clks;
+	struct regmap *regmap;
+	size_t num_clks;
+	struct qcom_reset_controller *reset;
+	struct qcom_cc *cc;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	regmap = devm_regmap_init_mmio(dev, base, &gcc_msm8960_regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	num_clks = ARRAY_SIZE(gcc_msm8960_clks);
+	cc = devm_kzalloc(dev, sizeof(*cc) + sizeof(*clks) * num_clks,
+			  GFP_KERNEL);
+	if (!cc)
+		return -ENOMEM;
+
+	clks = cc->clks;
+	data = &cc->data;
+	data->clks = clks;
+	data->clk_num = num_clks;
+
+	/* Temporary until RPM clocks supported */
+	clk = clk_register_fixed_rate(dev, "cxo", NULL, CLK_IS_ROOT, 19200000);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	clk = clk_register_fixed_rate(dev, "pxo", NULL, CLK_IS_ROOT, 27000000);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	for (i = 0; i < num_clks; i++) {
+		if (!gcc_msm8960_clks[i])
+			continue;
+		clk = devm_clk_register_regmap(dev, gcc_msm8960_clks[i]);
+		if (IS_ERR(clk))
+			return PTR_ERR(clk);
+		clks[i] = clk;
+	}
+
+	ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get, data);
+	if (ret)
+		return ret;
+
+	reset = &cc->reset;
+	reset->rcdev.of_node = dev->of_node;
+	reset->rcdev.ops = &qcom_reset_ops,
+	reset->rcdev.owner = THIS_MODULE,
+	reset->rcdev.nr_resets = ARRAY_SIZE(gcc_msm8960_resets),
+	reset->regmap = regmap;
+	reset->reset_map = gcc_msm8960_resets,
+	platform_set_drvdata(pdev, &reset->rcdev);
+
+	ret = reset_controller_register(&reset->rcdev);
+	if (ret)
+		of_clk_del_provider(dev->of_node);
+
+	return ret;
+}
+
+static int gcc_msm8960_remove(struct platform_device *pdev)
+{
+	of_clk_del_provider(pdev->dev.of_node);
+	reset_controller_unregister(platform_get_drvdata(pdev));
+	return 0;
+}
+
+static struct platform_driver gcc_msm8960_driver = {
+	.probe		= gcc_msm8960_probe,
+	.remove		= gcc_msm8960_remove,
+	.driver		= {
+		.name	= "gcc-msm8960",
+		.owner	= THIS_MODULE,
+		.of_match_table = gcc_msm8960_match_table,
+	},
+};
+
+static int __init gcc_msm8960_init(void)
+{
+	return platform_driver_register(&gcc_msm8960_driver);
+}
+core_initcall(gcc_msm8960_init);
+
+static void __exit gcc_msm8960_exit(void)
+{
+	platform_driver_unregister(&gcc_msm8960_driver);
+}
+module_exit(gcc_msm8960_exit);
+
+MODULE_DESCRIPTION("QCOM GCC MSM8960 Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:gcc-msm8960");
diff --git a/include/dt-bindings/clock/qcom,gcc-msm8960.h b/include/dt-bindings/clock/qcom,gcc-msm8960.h
new file mode 100644
index 000000000000..03bbf49d43b7
--- /dev/null
+++ b/include/dt-bindings/clock/qcom,gcc-msm8960.h
@@ -0,0 +1,313 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _DT_BINDINGS_CLK_MSM_GCC_8960_H
+#define _DT_BINDINGS_CLK_MSM_GCC_8960_H
+
+#define AFAB_CLK_SRC				0
+#define AFAB_CORE_CLK				1
+#define SFAB_MSS_Q6_SW_A_CLK			2
+#define SFAB_MSS_Q6_FW_A_CLK			3
+#define QDSS_STM_CLK				4
+#define SCSS_A_CLK				5
+#define SCSS_H_CLK				6
+#define SCSS_XO_SRC_CLK				7
+#define AFAB_EBI1_CH0_A_CLK			8
+#define AFAB_EBI1_CH1_A_CLK			9
+#define AFAB_AXI_S0_FCLK			10
+#define AFAB_AXI_S1_FCLK			11
+#define AFAB_AXI_S2_FCLK			12
+#define AFAB_AXI_S3_FCLK			13
+#define AFAB_AXI_S4_FCLK			14
+#define SFAB_CORE_CLK				15
+#define SFAB_AXI_S0_FCLK			16
+#define SFAB_AXI_S1_FCLK			17
+#define SFAB_AXI_S2_FCLK			18
+#define SFAB_AXI_S3_FCLK			19
+#define SFAB_AXI_S4_FCLK			20
+#define SFAB_AHB_S0_FCLK			21
+#define SFAB_AHB_S1_FCLK			22
+#define SFAB_AHB_S2_FCLK			23
+#define SFAB_AHB_S3_FCLK			24
+#define SFAB_AHB_S4_FCLK			25
+#define SFAB_AHB_S5_FCLK			26
+#define SFAB_AHB_S6_FCLK			27
+#define SFAB_AHB_S7_FCLK			28
+#define QDSS_AT_CLK_SRC				29
+#define QDSS_AT_CLK				30
+#define QDSS_TRACECLKIN_CLK_SRC			31
+#define QDSS_TRACECLKIN_CLK			32
+#define QDSS_TSCTR_CLK_SRC			33
+#define QDSS_TSCTR_CLK				34
+#define SFAB_ADM0_M0_A_CLK			35
+#define SFAB_ADM0_M1_A_CLK			36
+#define SFAB_ADM0_M2_A_CLK			37
+#define ADM0_CLK				38
+#define ADM0_PBUS_CLK				39
+#define MSS_XPU_CLK				40
+#define IMEM0_A_CLK				41
+#define QDSS_H_CLK				42
+#define PCIE_A_CLK				43
+#define PCIE_AUX_CLK				44
+#define PCIE_PHY_REF_CLK			45
+#define PCIE_H_CLK				46
+#define SFAB_CLK_SRC				47
+#define MAHB0_CLK				48
+#define Q6SW_CLK_SRC				49
+#define Q6SW_CLK				50
+#define Q6FW_CLK_SRC				51
+#define Q6FW_CLK				52
+#define SFAB_MSS_M_A_CLK			53
+#define SFAB_USB3_M_A_CLK			54
+#define SFAB_LPASS_Q6_A_CLK			55
+#define SFAB_AFAB_M_A_CLK			56
+#define AFAB_SFAB_M0_A_CLK			57
+#define AFAB_SFAB_M1_A_CLK			58
+#define SFAB_SATA_S_H_CLK			59
+#define DFAB_CLK_SRC				60
+#define DFAB_CLK				61
+#define SFAB_DFAB_M_A_CLK			62
+#define DFAB_SFAB_M_A_CLK			63
+#define DFAB_SWAY0_H_CLK			64
+#define DFAB_SWAY1_H_CLK			65
+#define DFAB_ARB0_H_CLK				66
+#define DFAB_ARB1_H_CLK				67
+#define PPSS_H_CLK				68
+#define PPSS_PROC_CLK				69
+#define PPSS_TIMER0_CLK				70
+#define PPSS_TIMER1_CLK				71
+#define PMEM_A_CLK				72
+#define DMA_BAM_H_CLK				73
+#define SIC_H_CLK				74
+#define SPS_TIC_H_CLK				75
+#define SLIMBUS_H_CLK				76
+#define SLIMBUS_XO_SRC_CLK			77
+#define CFPB_2X_CLK_SRC				78
+#define CFPB_CLK				79
+#define CFPB0_H_CLK				80
+#define CFPB1_H_CLK				81
+#define CFPB2_H_CLK				82
+#define SFAB_CFPB_M_H_CLK			83
+#define CFPB_MASTER_H_CLK			84
+#define SFAB_CFPB_S_HCLK			85
+#define CFPB_SPLITTER_H_CLK			86
+#define TSIF_H_CLK				87
+#define TSIF_INACTIVITY_TIMERS_CLK		88
+#define TSIF_REF_SRC				89
+#define TSIF_REF_CLK				90
+#define CE1_H_CLK				91
+#define CE1_CORE_CLK				92
+#define CE1_SLEEP_CLK				93
+#define CE2_H_CLK				94
+#define CE2_CORE_CLK				95
+#define CE2_SLEEP_CLK				96
+#define SFPB_H_CLK_SRC				97
+#define SFPB_H_CLK				98
+#define SFAB_SFPB_M_H_CLK			99
+#define SFAB_SFPB_S_H_CLK			100
+#define RPM_PROC_CLK				101
+#define RPM_BUS_H_CLK				102
+#define RPM_SLEEP_CLK				103
+#define RPM_TIMER_CLK				104
+#define RPM_MSG_RAM_H_CLK			105
+#define PMIC_ARB0_H_CLK				106
+#define PMIC_ARB1_H_CLK				107
+#define PMIC_SSBI2_SRC				108
+#define PMIC_SSBI2_CLK				109
+#define SDC1_H_CLK				110
+#define SDC2_H_CLK				111
+#define SDC3_H_CLK				112
+#define SDC4_H_CLK				113
+#define SDC5_H_CLK				114
+#define SDC1_SRC				115
+#define SDC2_SRC				116
+#define SDC3_SRC				117
+#define SDC4_SRC				118
+#define SDC5_SRC				119
+#define SDC1_CLK				120
+#define SDC2_CLK				121
+#define SDC3_CLK				122
+#define SDC4_CLK				123
+#define SDC5_CLK				124
+#define DFAB_A2_H_CLK				125
+#define USB_HS1_H_CLK				126
+#define USB_HS1_XCVR_SRC			127
+#define USB_HS1_XCVR_CLK			128
+#define USB_HSIC_H_CLK				129
+#define USB_HSIC_XCVR_FS_SRC			130
+#define USB_HSIC_XCVR_FS_CLK			131
+#define USB_HSIC_SYSTEM_CLK_SRC			132
+#define USB_HSIC_SYSTEM_CLK			133
+#define CFPB0_C0_H_CLK				134
+#define CFPB0_C1_H_CLK				135
+#define CFPB0_D0_H_CLK				136
+#define CFPB0_D1_H_CLK				137
+#define USB_FS1_H_CLK				138
+#define USB_FS1_XCVR_FS_SRC			139
+#define USB_FS1_XCVR_FS_CLK			140
+#define USB_FS1_SYSTEM_CLK			141
+#define USB_FS2_H_CLK				142
+#define USB_FS2_XCVR_FS_SRC			143
+#define USB_FS2_XCVR_FS_CLK			144
+#define USB_FS2_SYSTEM_CLK			145
+#define GSBI_COMMON_SIM_SRC			146
+#define GSBI1_H_CLK				147
+#define GSBI2_H_CLK				148
+#define GSBI3_H_CLK				149
+#define GSBI4_H_CLK				150
+#define GSBI5_H_CLK				151
+#define GSBI6_H_CLK				152
+#define GSBI7_H_CLK				153
+#define GSBI8_H_CLK				154
+#define GSBI9_H_CLK				155
+#define GSBI10_H_CLK				156
+#define GSBI11_H_CLK				157
+#define GSBI12_H_CLK				158
+#define GSBI1_UART_SRC				159
+#define GSBI1_UART_CLK				160
+#define GSBI2_UART_SRC				161
+#define GSBI2_UART_CLK				162
+#define GSBI3_UART_SRC				163
+#define GSBI3_UART_CLK				164
+#define GSBI4_UART_SRC				165
+#define GSBI4_UART_CLK				166
+#define GSBI5_UART_SRC				167
+#define GSBI5_UART_CLK				168
+#define GSBI6_UART_SRC				169
+#define GSBI6_UART_CLK				170
+#define GSBI7_UART_SRC				171
+#define GSBI7_UART_CLK				172
+#define GSBI8_UART_SRC				173
+#define GSBI8_UART_CLK				174
+#define GSBI9_UART_SRC				175
+#define GSBI9_UART_CLK				176
+#define GSBI10_UART_SRC				177
+#define GSBI10_UART_CLK				178
+#define GSBI11_UART_SRC				179
+#define GSBI11_UART_CLK				180
+#define GSBI12_UART_SRC				181
+#define GSBI12_UART_CLK				182
+#define GSBI1_QUP_SRC				183
+#define GSBI1_QUP_CLK				184
+#define GSBI2_QUP_SRC				185
+#define GSBI2_QUP_CLK				186
+#define GSBI3_QUP_SRC				187
+#define GSBI3_QUP_CLK				188
+#define GSBI4_QUP_SRC				189
+#define GSBI4_QUP_CLK				190
+#define GSBI5_QUP_SRC				191
+#define GSBI5_QUP_CLK				192
+#define GSBI6_QUP_SRC				193
+#define GSBI6_QUP_CLK				194
+#define GSBI7_QUP_SRC				195
+#define GSBI7_QUP_CLK				196
+#define GSBI8_QUP_SRC				197
+#define GSBI8_QUP_CLK				198
+#define GSBI9_QUP_SRC				199
+#define GSBI9_QUP_CLK				200
+#define GSBI10_QUP_SRC				201
+#define GSBI10_QUP_CLK				202
+#define GSBI11_QUP_SRC				203
+#define GSBI11_QUP_CLK				204
+#define GSBI12_QUP_SRC				205
+#define GSBI12_QUP_CLK				206
+#define GSBI1_SIM_CLK				207
+#define GSBI2_SIM_CLK				208
+#define GSBI3_SIM_CLK				209
+#define GSBI4_SIM_CLK				210
+#define GSBI5_SIM_CLK				211
+#define GSBI6_SIM_CLK				212
+#define GSBI7_SIM_CLK				213
+#define GSBI8_SIM_CLK				214
+#define GSBI9_SIM_CLK				215
+#define GSBI10_SIM_CLK				216
+#define GSBI11_SIM_CLK				217
+#define GSBI12_SIM_CLK				218
+#define USB_HSIC_HSIC_CLK_SRC			219
+#define USB_HSIC_HSIC_CLK			220
+#define USB_HSIC_HSIO_CAL_CLK			221
+#define SPDM_CFG_H_CLK				222
+#define SPDM_MSTR_H_CLK				223
+#define SPDM_FF_CLK_SRC				224
+#define SPDM_FF_CLK				225
+#define SEC_CTRL_CLK				226
+#define SEC_CTRL_ACC_CLK_SRC			227
+#define SEC_CTRL_ACC_CLK			228
+#define TLMM_H_CLK				229
+#define TLMM_CLK				230
+#define SFAB_MSS_S_H_CLK			231
+#define MSS_SLP_CLK				232
+#define MSS_Q6SW_JTAG_CLK			233
+#define MSS_Q6FW_JTAG_CLK			234
+#define MSS_S_H_CLK				235
+#define MSS_CXO_SRC_CLK				236
+#define SATA_H_CLK				237
+#define SATA_SRC_CLK				238
+#define SATA_RXOOB_CLK				239
+#define SATA_PMALIVE_CLK			240
+#define SATA_PHY_REF_CLK			241
+#define TSSC_CLK_SRC				242
+#define TSSC_CLK				243
+#define PDM_SRC					244
+#define PDM_CLK					245
+#define GP0_SRC					246
+#define GP0_CLK					247
+#define GP1_SRC					248
+#define GP1_CLK					249
+#define GP2_SRC					250
+#define GP2_CLK					251
+#define MPM_CLK					252
+#define EBI1_CLK_SRC				253
+#define EBI1_CH0_CLK				254
+#define EBI1_CH1_CLK				255
+#define EBI1_2X_CLK				256
+#define EBI1_CH0_DQ_CLK				257
+#define EBI1_CH1_DQ_CLK				258
+#define EBI1_CH0_CA_CLK				259
+#define EBI1_CH1_CA_CLK				260
+#define EBI1_XO_CLK				261
+#define SFAB_SMPSS_S_H_CLK			262
+#define PRNG_SRC				263
+#define PRNG_CLK				264
+#define PXO_SRC					265
+#define LPASS_CXO_CLK				266
+#define LPASS_PXO_CLK				267
+#define SPDM_CY_PORT0_CLK			268
+#define SPDM_CY_PORT1_CLK			269
+#define SPDM_CY_PORT2_CLK			270
+#define SPDM_CY_PORT3_CLK			271
+#define SPDM_CY_PORT4_CLK			272
+#define SPDM_CY_PORT5_CLK			273
+#define SPDM_CY_PORT6_CLK			274
+#define SPDM_CY_PORT7_CLK			275
+#define PLL0					276
+#define PLL0_VOTE				277
+#define PLL3					278
+#define PLL3_VOTE				279
+#define PLL4_VOTE				280
+#define PLL5					281
+#define PLL5_VOTE				282
+#define PLL6					283
+#define PLL6_VOTE				284
+#define PLL7_VOTE				285
+#define PLL8					286
+#define PLL8_VOTE				287
+#define PLL9					288
+#define PLL10					289
+#define PLL11					290
+#define PLL12					291
+#define PLL13					292
+#define PLL14					293
+#define PLL14_VOTE				294
+
+#endif
diff --git a/include/dt-bindings/reset/qcom,gcc-msm8960.h b/include/dt-bindings/reset/qcom,gcc-msm8960.h
new file mode 100644
index 000000000000..a840e680323c
--- /dev/null
+++ b/include/dt-bindings/reset/qcom,gcc-msm8960.h
@@ -0,0 +1,118 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _DT_BINDINGS_RESET_MSM_GCC_8960_H
+#define _DT_BINDINGS_RESET_MSM_GCC_8960_H
+
+#define SFAB_MSS_Q6_SW_RESET				0
+#define SFAB_MSS_Q6_FW_RESET				1
+#define QDSS_STM_RESET					2
+#define AFAB_SMPSS_S_RESET				3
+#define AFAB_SMPSS_M1_RESET				4
+#define AFAB_SMPSS_M0_RESET				5
+#define AFAB_EBI1_CH0_RESET				6
+#define AFAB_EBI1_CH1_RESET				7
+#define SFAB_ADM0_M0_RESET				8
+#define SFAB_ADM0_M1_RESET				9
+#define SFAB_ADM0_M2_RESET				10
+#define ADM0_C2_RESET					11
+#define ADM0_C1_RESET					12
+#define ADM0_C0_RESET					13
+#define ADM0_PBUS_RESET					14
+#define ADM0_RESET					15
+#define QDSS_CLKS_SW_RESET				16
+#define QDSS_POR_RESET					17
+#define QDSS_TSCTR_RESET				18
+#define QDSS_HRESET_RESET				19
+#define QDSS_AXI_RESET					20
+#define QDSS_DBG_RESET					21
+#define PCIE_A_RESET					22
+#define PCIE_AUX_RESET					23
+#define PCIE_H_RESET					24
+#define SFAB_PCIE_M_RESET				25
+#define SFAB_PCIE_S_RESET				26
+#define SFAB_MSS_M_RESET				27
+#define SFAB_USB3_M_RESET				28
+#define SFAB_RIVA_M_RESET				29
+#define SFAB_LPASS_RESET				30
+#define SFAB_AFAB_M_RESET				31
+#define AFAB_SFAB_M0_RESET				32
+#define AFAB_SFAB_M1_RESET				33
+#define SFAB_SATA_S_RESET				34
+#define SFAB_DFAB_M_RESET				35
+#define DFAB_SFAB_M_RESET				36
+#define DFAB_SWAY0_RESET				37
+#define DFAB_SWAY1_RESET				38
+#define DFAB_ARB0_RESET					39
+#define DFAB_ARB1_RESET					40
+#define PPSS_PROC_RESET					41
+#define PPSS_RESET					42
+#define DMA_BAM_RESET					43
+#define SIC_TIC_RESET					44
+#define SLIMBUS_H_RESET					45
+#define SFAB_CFPB_M_RESET				46
+#define SFAB_CFPB_S_RESET				47
+#define TSIF_H_RESET					48
+#define CE1_H_RESET					49
+#define CE1_CORE_RESET					50
+#define CE1_SLEEP_RESET					51
+#define CE2_H_RESET					52
+#define CE2_CORE_RESET					53
+#define SFAB_SFPB_M_RESET				54
+#define SFAB_SFPB_S_RESET				55
+#define RPM_PROC_RESET					56
+#define PMIC_SSBI2_RESET				57
+#define SDC1_RESET					58
+#define SDC2_RESET					59
+#define SDC3_RESET					60
+#define SDC4_RESET					61
+#define SDC5_RESET					62
+#define DFAB_A2_RESET					63
+#define USB_HS1_RESET					64
+#define USB_HSIC_RESET					65
+#define USB_FS1_XCVR_RESET				66
+#define USB_FS1_RESET					67
+#define USB_FS2_XCVR_RESET				68
+#define USB_FS2_RESET					69
+#define GSBI1_RESET					70
+#define GSBI2_RESET					71
+#define GSBI3_RESET					72
+#define GSBI4_RESET					73
+#define GSBI5_RESET					74
+#define GSBI6_RESET					75
+#define GSBI7_RESET					76
+#define GSBI8_RESET					77
+#define GSBI9_RESET					78
+#define GSBI10_RESET					79
+#define GSBI11_RESET					80
+#define GSBI12_RESET					81
+#define SPDM_RESET					82
+#define TLMM_H_RESET					83
+#define SFAB_MSS_S_RESET				84
+#define MSS_SLP_RESET					85
+#define MSS_Q6SW_JTAG_RESET				86
+#define MSS_Q6FW_JTAG_RESET				87
+#define MSS_RESET					88
+#define SATA_H_RESET					89
+#define SATA_RXOOB_RESE					90
+#define SATA_PMALIVE_RESET				91
+#define SATA_SFAB_M_RESET				92
+#define TSSC_RESET					93
+#define PDM_RESET					94
+#define MPM_H_RESET					95
+#define MPM_RESET					96
+#define SFAB_SMPSS_S_RESET				97
+#define PRNG_RESET					98
+#define RIVA_RESET					99
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

