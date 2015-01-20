Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbbATCHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:07:45 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41482 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbbATCFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:05:41 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 7/8] clk: qcom: Add MSM8960/APQ8064 LPASS clock controller (LCC) driver
Date: Mon, 19 Jan 2015 18:05:34 -0800
Message-Id: <1421719535-28398-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
In-Reply-To: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
References: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an LCC driver for MSM8960/APQ8064 that supports the i2s,
slimbus, and pcm clocks.

Change-Id: I2549b821f7bf467c1bd80d4827a1a7621e725659
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Kconfig                     |   9 +
 drivers/clk/qcom/Makefile                    |   1 +
 drivers/clk/qcom/lcc-msm8960.c               | 585 +++++++++++++++++++++++++++
 include/dt-bindings/clock/qcom,lcc-msm8960.h |  50 +++
 4 files changed, 645 insertions(+)
 create mode 100644 drivers/clk/qcom/lcc-msm8960.c
 create mode 100644 include/dt-bindings/clock/qcom,lcc-msm8960.h

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 07bce5f35eee..0d7ab52b7ab0 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -54,6 +54,15 @@ config MSM_GCC_8960
 	  Say Y if you want to use peripheral devices such as UART, SPI,
 	  i2c, USB, SD/eMMC, SATA, PCIe, etc.
 
+config MSM_LCC_8960
+	tristate "APQ8064/MSM8960 LPASS Clock Controller"
+	select MSM_GCC_8960
+	depends on COMMON_CLK_QCOM
+	help
+	  Support for the LPASS clock controller on apq8064/msm8960 devices.
+	  Say Y if you want to use audio devices such as i2s, pcm,
+	  SLIMBus, etc.
+
 config MSM_MMCC_8960
 	tristate "MSM8960 Multimedia Clock Controller"
 	select MSM_GCC_8960
diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index 13c03a8808ec..617826469595 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_IPQ_GCC_806X) += gcc-ipq806x.o
 obj-$(CONFIG_IPQ_LCC_806X) += lcc-ipq806x.o
 obj-$(CONFIG_MSM_GCC_8660) += gcc-msm8660.o
 obj-$(CONFIG_MSM_GCC_8960) += gcc-msm8960.o
+obj-$(CONFIG_MSM_LCC_8960) += lcc-msm8960.o
 obj-$(CONFIG_MSM_GCC_8974) += gcc-msm8974.o
 obj-$(CONFIG_MSM_MMCC_8960) += mmcc-msm8960.o
 obj-$(CONFIG_MSM_MMCC_8974) += mmcc-msm8974.o
diff --git a/drivers/clk/qcom/lcc-msm8960.c b/drivers/clk/qcom/lcc-msm8960.c
new file mode 100644
index 000000000000..a75a408cfccd
--- /dev/null
+++ b/drivers/clk/qcom/lcc-msm8960.c
@@ -0,0 +1,585 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
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
+
+#include <dt-bindings/clock/qcom,lcc-msm8960.h>
+
+#include "common.h"
+#include "clk-regmap.h"
+#include "clk-pll.h"
+#include "clk-rcg.h"
+#include "clk-branch.h"
+#include "clk-regmap-divider.h"
+#include "clk-regmap-mux.h"
+
+static struct clk_pll pll4 = {
+	.l_reg = 0x4,
+	.m_reg = 0x8,
+	.n_reg = 0xc,
+	.config_reg = 0x14,
+	.mode_reg = 0x0,
+	.status_reg = 0x18,
+	.status_bit = 16,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "pll4",
+		.parent_names = (const char *[]){ "pxo" },
+		.num_parents = 1,
+		.ops = &clk_pll_ops,
+	},
+};
+
+#define P_PXO	0
+#define P_PLL4	1
+
+static const u8 lcc_pxo_pll4_map[] = {
+	[P_PXO]		= 0,
+	[P_PLL4]	= 2,
+};
+
+static const char *lcc_pxo_pll4[] = {
+	"pxo",
+	"pll4_vote",
+};
+
+static struct freq_tbl clk_tbl_aif_osr_492[] = {
+	{   512000, P_PLL4, 4, 1, 240 },
+	{   768000, P_PLL4, 4, 1, 160 },
+	{  1024000, P_PLL4, 4, 1, 120 },
+	{  1536000, P_PLL4, 4, 1,  80 },
+	{  2048000, P_PLL4, 4, 1,  60 },
+	{  3072000, P_PLL4, 4, 1,  40 },
+	{  4096000, P_PLL4, 4, 1,  30 },
+	{  6144000, P_PLL4, 4, 1,  20 },
+	{  8192000, P_PLL4, 4, 1,  15 },
+	{ 12288000, P_PLL4, 4, 1,  10 },
+	{ 24576000, P_PLL4, 4, 1,   5 },
+	{ 27000000, P_PXO,  1, 0,   0 },
+	{ }
+};
+
+static struct freq_tbl clk_tbl_aif_osr_393[] = {
+	{   512000, P_PLL4, 4, 1, 192 },
+	{   768000, P_PLL4, 4, 1, 128 },
+	{  1024000, P_PLL4, 4, 1,  96 },
+	{  1536000, P_PLL4, 4, 1,  64 },
+	{  2048000, P_PLL4, 4, 1,  48 },
+	{  3072000, P_PLL4, 4, 1,  32 },
+	{  4096000, P_PLL4, 4, 1,  24 },
+	{  6144000, P_PLL4, 4, 1,  16 },
+	{  8192000, P_PLL4, 4, 1,  12 },
+	{ 12288000, P_PLL4, 4, 1,   8 },
+	{ 24576000, P_PLL4, 4, 1,   4 },
+	{ 27000000, P_PXO,  1, 0,   0 },
+	{ }
+};
+
+static struct clk_rcg mi2s_osr_src = {
+	.ns_reg = 0x48,
+	.md_reg = 0x4c,
+	.mn = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 7,
+		.mnctr_mode_shift = 5,
+		.n_val_shift = 24,
+		.m_val_shift = 8,
+		.width = 8,
+	},
+	.p = {
+		.pre_div_shift = 3,
+		.pre_div_width = 2,
+	},
+	.s = {
+		.src_sel_shift = 0,
+		.parent_map = lcc_pxo_pll4_map,
+	},
+	.freq_tbl = clk_tbl_aif_osr_393,
+	.clkr = {
+		.enable_reg = 0x48,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "mi2s_osr_src",
+			.parent_names = lcc_pxo_pll4,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	},
+};
+
+static const char *lcc_mi2s_parents[] = {
+	"mi2s_osr_src",
+};
+
+static struct clk_branch mi2s_osr_clk = {
+	.halt_reg = 0x50,
+	.halt_bit = 1,
+	.halt_check = BRANCH_HALT_ENABLE,
+	.clkr = {
+		.enable_reg = 0x48,
+		.enable_mask = BIT(17),
+		.hw.init = &(struct clk_init_data){
+			.name = "mi2s_osr_clk",
+			.parent_names = lcc_mi2s_parents,
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_regmap_div mi2s_div_clk = {
+	.reg = 0x48,
+	.shift = 10,
+	.width = 4,
+	.clkr = {
+		.enable_reg = 0x48,
+		.enable_mask = BIT(15),
+		.hw.init = &(struct clk_init_data){
+			.name = "mi2s_div_clk",
+			.parent_names = lcc_mi2s_parents,
+			.num_parents = 1,
+			.ops = &clk_regmap_div_ops,
+		},
+	},
+};
+
+static struct clk_branch mi2s_bit_div_clk = {
+	.halt_reg = 0x50,
+	.halt_bit = 0,
+	.halt_check = BRANCH_HALT_ENABLE,
+	.clkr = {
+		.enable_reg = 0x48,
+		.enable_mask = BIT(15),
+		.hw.init = &(struct clk_init_data){
+			.name = "mi2s_bit_div_clk",
+			.parent_names = (const char *[]){ "mi2s_div_clk" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_regmap_mux mi2s_bit_clk = {
+	.reg = 0x48,
+	.shift = 14,
+	.width = 1,
+	.clkr = {
+		.hw.init = &(struct clk_init_data){
+			.name = "mi2s_bit_clk",
+			.parent_names = (const char *[]){
+				"mi2s_bit_div_clk",
+				"mi2s_codec_clk",
+			},
+			.num_parents = 2,
+			.ops = &clk_regmap_mux_closest_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+#define CLK_AIF_OSR_DIV(prefix, _ns, _md, hr)			\
+static struct clk_rcg prefix##_osr_src = {			\
+	.ns_reg = _ns,						\
+	.md_reg = _md,						\
+	.mn = {							\
+		.mnctr_en_bit = 8,				\
+		.mnctr_reset_bit = 7,				\
+		.mnctr_mode_shift = 5,				\
+		.n_val_shift = 24,				\
+		.m_val_shift = 8,				\
+		.width = 8,					\
+	},							\
+	.p = {							\
+		.pre_div_shift = 3,				\
+		.pre_div_width = 2,				\
+	},							\
+	.s = {							\
+		.src_sel_shift = 0,				\
+		.parent_map = lcc_pxo_pll4_map,			\
+	},							\
+	.freq_tbl = clk_tbl_aif_osr_393,			\
+	.clkr = {						\
+		.enable_reg = _ns,				\
+		.enable_mask = BIT(9),				\
+		.hw.init = &(struct clk_init_data){		\
+			.name = #prefix "_osr_src",		\
+			.parent_names = lcc_pxo_pll4,		\
+			.num_parents = 2,			\
+			.ops = &clk_rcg_ops,			\
+			.flags = CLK_SET_RATE_GATE,		\
+		},						\
+	},							\
+};								\
+								\
+static const char *lcc_##prefix##_parents[] = {			\
+	#prefix "_osr_src",					\
+};								\
+								\
+static struct clk_branch prefix##_osr_clk = {			\
+	.halt_reg = hr,						\
+	.halt_bit = 1,						\
+	.halt_check = BRANCH_HALT_ENABLE,			\
+	.clkr = {						\
+		.enable_reg = _ns,				\
+		.enable_mask = BIT(21),				\
+		.hw.init = &(struct clk_init_data){		\
+			.name = #prefix "_osr_clk",		\
+			.parent_names = lcc_##prefix##_parents,	\
+			.num_parents = 1,			\
+			.ops = &clk_branch_ops,			\
+			.flags = CLK_SET_RATE_PARENT,		\
+		},						\
+	},							\
+};								\
+								\
+static struct clk_regmap_div prefix##_div_clk = {		\
+	.reg = _ns,						\
+	.shift = 10,						\
+	.width = 8,						\
+	.clkr = {						\
+		.hw.init = &(struct clk_init_data){		\
+			.name = #prefix "_div_clk",		\
+			.parent_names = lcc_##prefix##_parents,	\
+			.num_parents = 1,			\
+			.ops = &clk_regmap_div_ops,		\
+		},						\
+	},							\
+};								\
+								\
+static struct clk_branch prefix##_bit_div_clk = {		\
+	.halt_reg = hr,						\
+	.halt_bit = 0,						\
+	.halt_check = BRANCH_HALT_ENABLE,			\
+	.clkr = {						\
+		.enable_reg = _ns,				\
+		.enable_mask = BIT(19),				\
+		.hw.init = &(struct clk_init_data){		\
+			.name = #prefix "_bit_div_clk",		\
+			.parent_names = (const char *[]){	\
+				#prefix "_div_clk"		\
+			}, 					\
+			.num_parents = 1,			\
+			.ops = &clk_branch_ops,			\
+			.flags = CLK_SET_RATE_PARENT,		\
+		},						\
+	},							\
+};								\
+								\
+static struct clk_regmap_mux prefix##_bit_clk = {		\
+	.reg = _ns,						\
+	.shift = 18,						\
+	.width = 1,						\
+	.clkr = {						\
+		.hw.init = &(struct clk_init_data){		\
+			.name = #prefix "_bit_clk",		\
+			.parent_names = (const char *[]){	\
+				#prefix "_bit_div_clk",		\
+				#prefix "_codec_clk",		\
+			},					\
+			.num_parents = 2,			\
+			.ops = &clk_regmap_mux_closest_ops,	\
+			.flags = CLK_SET_RATE_PARENT,		\
+		},						\
+	},							\
+}
+
+CLK_AIF_OSR_DIV(codec_i2s_mic, 0x60, 0x64, 0x68);
+CLK_AIF_OSR_DIV(spare_i2s_mic, 0x78, 0x7c, 0x80);
+CLK_AIF_OSR_DIV(codec_i2s_spkr, 0x6c, 0x70, 0x74);
+CLK_AIF_OSR_DIV(spare_i2s_spkr, 0x84, 0x88, 0x8c);
+
+static struct freq_tbl clk_tbl_pcm_492[] = {
+	{   256000, P_PLL4, 4, 1, 480 },
+	{   512000, P_PLL4, 4, 1, 240 },
+	{   768000, P_PLL4, 4, 1, 160 },
+	{  1024000, P_PLL4, 4, 1, 120 },
+	{  1536000, P_PLL4, 4, 1,  80 },
+	{  2048000, P_PLL4, 4, 1,  60 },
+	{  3072000, P_PLL4, 4, 1,  40 },
+	{  4096000, P_PLL4, 4, 1,  30 },
+	{  6144000, P_PLL4, 4, 1,  20 },
+	{  8192000, P_PLL4, 4, 1,  15 },
+	{ 12288000, P_PLL4, 4, 1,  10 },
+	{ 24576000, P_PLL4, 4, 1,   5 },
+	{ 27000000, P_PXO,  1, 0,   0 },
+	{ }
+};
+
+static struct freq_tbl clk_tbl_pcm_393[] = {
+	{   256000, P_PLL4, 4, 1, 384 },
+	{   512000, P_PLL4, 4, 1, 192 },
+	{   768000, P_PLL4, 4, 1, 128 },
+	{  1024000, P_PLL4, 4, 1,  96 },
+	{  1536000, P_PLL4, 4, 1,  64 },
+	{  2048000, P_PLL4, 4, 1,  48 },
+	{  3072000, P_PLL4, 4, 1,  32 },
+	{  4096000, P_PLL4, 4, 1,  24 },
+	{  6144000, P_PLL4, 4, 1,  16 },
+	{  8192000, P_PLL4, 4, 1,  12 },
+	{ 12288000, P_PLL4, 4, 1,   8 },
+	{ 24576000, P_PLL4, 4, 1,   4 },
+	{ 27000000, P_PXO,  1, 0,   0 },
+	{ }
+};
+
+static struct clk_rcg pcm_src = {
+	.ns_reg = 0x54,
+	.md_reg = 0x58,
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
+		.parent_map = lcc_pxo_pll4_map,
+	},
+	.freq_tbl = clk_tbl_pcm_393,
+	.clkr = {
+		.enable_reg = 0x54,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "pcm_src",
+			.parent_names = lcc_pxo_pll4,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	},
+};
+
+static struct clk_branch pcm_clk_out = {
+	.halt_reg = 0x5c,
+	.halt_bit = 0,
+	.halt_check = BRANCH_HALT_ENABLE,
+	.clkr = {
+		.enable_reg = 0x54,
+		.enable_mask = BIT(11),
+		.hw.init = &(struct clk_init_data){
+			.name = "pcm_clk_out",
+			.parent_names = (const char *[]){ "pcm_src" },
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_regmap_mux pcm_clk = {
+	.reg = 0x54,
+	.shift = 10,
+	.width = 1,
+	.clkr = {
+		.hw.init = &(struct clk_init_data){
+			.name = "pcm_clk",
+			.parent_names = (const char *[]){
+				"pcm_clk_out",
+				"pcm_codec_clk",
+			},
+			.num_parents = 2,
+			.ops = &clk_regmap_mux_closest_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_rcg slimbus_src = {
+	.ns_reg = 0xcc,
+	.md_reg = 0xd0,
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
+		.parent_map = lcc_pxo_pll4_map,
+	},
+	.freq_tbl = clk_tbl_aif_osr_393,
+	.clkr = {
+		.enable_reg = 0xcc,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "slimbus_src",
+			.parent_names = lcc_pxo_pll4,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	},
+};
+
+static const char *lcc_slimbus_parents[] = {
+	"slimbus_src",
+};
+
+static struct clk_branch audio_slimbus_clk = {
+	.halt_reg = 0xd4,
+	.halt_bit = 0,
+	.halt_check = BRANCH_HALT_ENABLE,
+	.clkr = {
+		.enable_reg = 0xcc,
+		.enable_mask = BIT(10),
+		.hw.init = &(struct clk_init_data){
+			.name = "audio_slimbus_clk",
+			.parent_names = lcc_slimbus_parents,
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_branch sps_slimbus_clk = {
+	.halt_reg = 0xd4,
+	.halt_bit = 1,
+	.halt_check = BRANCH_HALT_ENABLE,
+	.clkr = {
+		.enable_reg = 0xcc,
+		.enable_mask = BIT(12),
+		.hw.init = &(struct clk_init_data){
+			.name = "sps_slimbus_clk",
+			.parent_names = lcc_slimbus_parents,
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct clk_regmap *lcc_msm8960_clks[] = {
+	[PLL4] = &pll4.clkr,
+	[MI2S_OSR_SRC] = &mi2s_osr_src.clkr,
+	[MI2S_OSR_CLK] = &mi2s_osr_clk.clkr,
+	[MI2S_DIV_CLK] = &mi2s_div_clk.clkr,
+	[MI2S_BIT_DIV_CLK] = &mi2s_bit_div_clk.clkr,
+	[MI2S_BIT_CLK] = &mi2s_bit_clk.clkr,
+	[PCM_SRC] = &pcm_src.clkr,
+	[PCM_CLK_OUT] = &pcm_clk_out.clkr,
+	[PCM_CLK] = &pcm_clk.clkr,
+	[SLIMBUS_SRC] = &slimbus_src.clkr,
+	[AUDIO_SLIMBUS_CLK] = &audio_slimbus_clk.clkr,
+	[SPS_SLIMBUS_CLK] = &sps_slimbus_clk.clkr,
+	[CODEC_I2S_MIC_OSR_SRC] = &codec_i2s_mic_osr_src.clkr,
+	[CODEC_I2S_MIC_OSR_CLK] = &codec_i2s_mic_osr_clk.clkr,
+	[CODEC_I2S_MIC_DIV_CLK] = &codec_i2s_mic_div_clk.clkr,
+	[CODEC_I2S_MIC_BIT_DIV_CLK] = &codec_i2s_mic_bit_div_clk.clkr,
+	[CODEC_I2S_MIC_BIT_CLK] = &codec_i2s_mic_bit_clk.clkr,
+	[SPARE_I2S_MIC_OSR_SRC] = &spare_i2s_mic_osr_src.clkr,
+	[SPARE_I2S_MIC_OSR_CLK] = &spare_i2s_mic_osr_clk.clkr,
+	[SPARE_I2S_MIC_DIV_CLK] = &spare_i2s_mic_div_clk.clkr,
+	[SPARE_I2S_MIC_BIT_DIV_CLK] = &spare_i2s_mic_bit_div_clk.clkr,
+	[SPARE_I2S_MIC_BIT_CLK] = &spare_i2s_mic_bit_clk.clkr,
+	[CODEC_I2S_SPKR_OSR_SRC] = &codec_i2s_spkr_osr_src.clkr,
+	[CODEC_I2S_SPKR_OSR_CLK] = &codec_i2s_spkr_osr_clk.clkr,
+	[CODEC_I2S_SPKR_DIV_CLK] = &codec_i2s_spkr_div_clk.clkr,
+	[CODEC_I2S_SPKR_BIT_DIV_CLK] = &codec_i2s_spkr_bit_div_clk.clkr,
+	[CODEC_I2S_SPKR_BIT_CLK] = &codec_i2s_spkr_bit_clk.clkr,
+	[SPARE_I2S_SPKR_OSR_SRC] = &spare_i2s_spkr_osr_src.clkr,
+	[SPARE_I2S_SPKR_OSR_CLK] = &spare_i2s_spkr_osr_clk.clkr,
+	[SPARE_I2S_SPKR_DIV_CLK] = &spare_i2s_spkr_div_clk.clkr,
+	[SPARE_I2S_SPKR_BIT_DIV_CLK] = &spare_i2s_spkr_bit_div_clk.clkr,
+	[SPARE_I2S_SPKR_BIT_CLK] = &spare_i2s_spkr_bit_clk.clkr,
+};
+
+static const struct regmap_config lcc_msm8960_regmap_config = {
+	.reg_bits	= 32,
+	.reg_stride	= 4,
+	.val_bits	= 32,
+	.max_register	= 0xfc,
+	.fast_io	= true,
+};
+
+static const struct qcom_cc_desc lcc_msm8960_desc = {
+	.config = &lcc_msm8960_regmap_config,
+	.clks = lcc_msm8960_clks,
+	.num_clks = ARRAY_SIZE(lcc_msm8960_clks),
+};
+
+static const struct of_device_id lcc_msm8960_match_table[] = {
+	{ .compatible = "qcom,lcc-msm8960" },
+	{ .compatible = "qcom,lcc-apq8064" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lcc_msm8960_match_table);
+
+static int lcc_msm8960_probe(struct platform_device *pdev)
+{
+	u32 val;
+	struct regmap *regmap;
+
+	regmap = qcom_cc_map(pdev, &lcc_msm8960_desc);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	/* Use the correct frequency plan depending on speed of PLL4 */
+	val = regmap_read(regmap, 0x4, &val);
+	if (val == 0x12) {
+		slimbus_src.freq_tbl = clk_tbl_aif_osr_492;
+		mi2s_osr_src.freq_tbl = clk_tbl_aif_osr_492;
+		codec_i2s_mic_osr_src.freq_tbl = clk_tbl_aif_osr_492;
+		spare_i2s_mic_osr_src.freq_tbl = clk_tbl_aif_osr_492;
+		codec_i2s_spkr_osr_src.freq_tbl = clk_tbl_aif_osr_492;
+		spare_i2s_spkr_osr_src.freq_tbl = clk_tbl_aif_osr_492;
+		pcm_src.freq_tbl = clk_tbl_pcm_492;
+	}
+	/* Enable PLL4 source on the LPASS Primary PLL Mux */
+	regmap_write(regmap, 0xc4, 0x1);
+
+	return qcom_cc_really_probe(pdev, &lcc_msm8960_desc, regmap);
+}
+
+static int lcc_msm8960_remove(struct platform_device *pdev)
+{
+	qcom_cc_remove(pdev);
+	return 0;
+}
+
+static struct platform_driver lcc_msm8960_driver = {
+	.probe		= lcc_msm8960_probe,
+	.remove		= lcc_msm8960_remove,
+	.driver		= {
+		.name	= "lcc-msm8960",
+		.owner	= THIS_MODULE,
+		.of_match_table = lcc_msm8960_match_table,
+	},
+};
+module_platform_driver(lcc_msm8960_driver);
+
+MODULE_DESCRIPTION("QCOM LCC MSM8960 Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:lcc-msm8960");
diff --git a/include/dt-bindings/clock/qcom,lcc-msm8960.h b/include/dt-bindings/clock/qcom,lcc-msm8960.h
new file mode 100644
index 000000000000..4fb2aa64d9fe
--- /dev/null
+++ b/include/dt-bindings/clock/qcom,lcc-msm8960.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
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
+#ifndef _DT_BINDINGS_CLK_LCC_MSM8960_H
+#define _DT_BINDINGS_CLK_LCC_MSM8960_H
+
+#define PLL4				0
+#define MI2S_OSR_SRC			1
+#define MI2S_OSR_CLK			2
+#define MI2S_DIV_CLK			3
+#define MI2S_BIT_DIV_CLK		4
+#define MI2S_BIT_CLK			5
+#define PCM_SRC				6
+#define PCM_CLK_OUT			7
+#define PCM_CLK				8
+#define SLIMBUS_SRC			9
+#define AUDIO_SLIMBUS_CLK		10
+#define SPS_SLIMBUS_CLK			11
+#define CODEC_I2S_MIC_OSR_SRC		12
+#define CODEC_I2S_MIC_OSR_CLK		13
+#define CODEC_I2S_MIC_DIV_CLK		14
+#define CODEC_I2S_MIC_BIT_DIV_CLK	15
+#define CODEC_I2S_MIC_BIT_CLK		16
+#define SPARE_I2S_MIC_OSR_SRC		17
+#define SPARE_I2S_MIC_OSR_CLK		18
+#define SPARE_I2S_MIC_DIV_CLK		19
+#define SPARE_I2S_MIC_BIT_DIV_CLK	20
+#define SPARE_I2S_MIC_BIT_CLK		21
+#define CODEC_I2S_SPKR_OSR_SRC		22
+#define CODEC_I2S_SPKR_OSR_CLK		23
+#define CODEC_I2S_SPKR_DIV_CLK		24
+#define CODEC_I2S_SPKR_BIT_DIV_CLK	25
+#define CODEC_I2S_SPKR_BIT_CLK		26
+#define SPARE_I2S_SPKR_OSR_SRC		27
+#define SPARE_I2S_SPKR_OSR_CLK		28
+#define SPARE_I2S_SPKR_DIV_CLK		29
+#define SPARE_I2S_SPKR_BIT_DIV_CLK	30
+#define SPARE_I2S_SPKR_BIT_CLK		31
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

