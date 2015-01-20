Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbbATCHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:07:44 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41497 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbbATCFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:05:41 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: Rajendra Nayak <rnayak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH v3 6/8] clk: qcom: Add IPQ806X LPASS clock controller (LCC) driver
Date: Mon, 19 Jan 2015 18:05:33 -0800
Message-Id: <1421719535-28398-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
In-Reply-To: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
References: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@codeaurora.org>

Add an LCC driver for IPQ806x that supports the i2s, S/PDIF, and
pcm clocks.

Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
Signed-off-by: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
[sboyd@codeaurora.org: Reworded commit text, added Kconfig
select, fleshed out Kconfig description a bit more, added pll4
configuration and reworked probe for it, added muxes, split out
dt-binding file]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Change-Id: Idf4d008306a98d75d914c5625b46d15c6f7921b4
---
 drivers/clk/qcom/Kconfig       |   9 +
 drivers/clk/qcom/Makefile      |   1 +
 drivers/clk/qcom/gcc-ipq806x.c |  12 ++
 drivers/clk/qcom/lcc-ipq806x.c | 473 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 495 insertions(+)
 create mode 100644 drivers/clk/qcom/lcc-ipq806x.c

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 1107351ed346..07bce5f35eee 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -29,6 +29,15 @@ config IPQ_GCC_806X
 	  Say Y if you want to use peripheral devices such as UART, SPI,
 	  i2c, USB, SD/eMMC, etc.
 
+config IPQ_LCC_806X
+	tristate "IPQ806x LPASS Clock Controller"
+	select IPQ_GCC_806X
+	depends on COMMON_CLK_QCOM
+	help
+	  Support for the LPASS clock controller on ipq806x devices.
+	  Say Y if you want to use audio devices such as i2s, pcm,
+	  S/PDIF, etc.
+
 config MSM_GCC_8660
 	tristate "MSM8660 Global Clock Controller"
 	depends on COMMON_CLK_QCOM
diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index f5e5607f3965..13c03a8808ec 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -13,6 +13,7 @@ clk-qcom-y += reset.o
 obj-$(CONFIG_APQ_GCC_8084) += gcc-apq8084.o
 obj-$(CONFIG_APQ_MMCC_8084) += mmcc-apq8084.o
 obj-$(CONFIG_IPQ_GCC_806X) += gcc-ipq806x.o
+obj-$(CONFIG_IPQ_LCC_806X) += lcc-ipq806x.o
 obj-$(CONFIG_MSM_GCC_8660) += gcc-msm8660.o
 obj-$(CONFIG_MSM_GCC_8960) += gcc-msm8960.o
 obj-$(CONFIG_MSM_GCC_8974) += gcc-msm8974.o
diff --git a/drivers/clk/qcom/gcc-ipq806x.c b/drivers/clk/qcom/gcc-ipq806x.c
index afed5eb0691e..cbdc31dea7f4 100644
--- a/drivers/clk/qcom/gcc-ipq806x.c
+++ b/drivers/clk/qcom/gcc-ipq806x.c
@@ -75,6 +75,17 @@ static struct clk_pll pll3 = {
 	},
 };
 
+static struct clk_regmap pll4_vote = {
+	.enable_reg = 0x34c0,
+	.enable_mask = BIT(4),
+	.hw.init = &(struct clk_init_data){
+		.name = "pll4_vote",
+		.parent_names = (const char *[]){ "pll4" },
+		.num_parents = 1,
+		.ops = &clk_pll_vote_ops,
+	},
+};
+
 static struct clk_pll pll8 = {
 	.l_reg = 0x3144,
 	.m_reg = 0x3148,
@@ -2163,6 +2174,7 @@ static struct clk_regmap *gcc_ipq806x_clks[] = {
 	[PLL0] = &pll0.clkr,
 	[PLL0_VOTE] = &pll0_vote,
 	[PLL3] = &pll3.clkr,
+	[PLL4_VOTE] = &pll4_vote,
 	[PLL8] = &pll8.clkr,
 	[PLL8_VOTE] = &pll8_vote,
 	[PLL14] = &pll14.clkr,
diff --git a/drivers/clk/qcom/lcc-ipq806x.c b/drivers/clk/qcom/lcc-ipq806x.c
new file mode 100644
index 000000000000..121ffde25dc3
--- /dev/null
+++ b/drivers/clk/qcom/lcc-ipq806x.c
@@ -0,0 +1,473 @@
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
+#include <dt-bindings/clock/qcom,lcc-ipq806x.h>
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
+static const struct pll_config pll4_config = {
+	.l = 0xf,
+	.m = 0x91,
+	.n = 0xc7,
+	.vco_val = 0x0,
+	.vco_mask = BIT(17) | BIT(16),
+	.pre_div_val = 0x0,
+	.pre_div_mask = BIT(19),
+	.post_div_val = 0x0,
+	.post_div_mask = BIT(21) | BIT(20),
+	.mn_ena_mask = BIT(22),
+	.main_output_mask = BIT(23),
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
+static struct freq_tbl clk_tbl_aif_mi2s[] = {
+	{  1024000, P_PLL4, 4,  1,  96 },
+	{  1411200, P_PLL4, 4,  2, 139 },
+	{  1536000, P_PLL4, 4,  1,  64 },
+	{  2048000, P_PLL4, 4,  1,  48 },
+	{  2116800, P_PLL4, 4,  2,  93 },
+	{  2304000, P_PLL4, 4,  2,  85 },
+	{  2822400, P_PLL4, 4,  6, 209 },
+	{  3072000, P_PLL4, 4,  1,  32 },
+	{  3175200, P_PLL4, 4,  1,  31 },
+	{  4096000, P_PLL4, 4,  1,  24 },
+	{  4233600, P_PLL4, 4,  9, 209 },
+	{  4608000, P_PLL4, 4,  3,  64 },
+	{  5644800, P_PLL4, 4, 12, 209 },
+	{  6144000, P_PLL4, 4,  1,  16 },
+	{  6350400, P_PLL4, 4,  2,  31 },
+	{  8192000, P_PLL4, 4,  1,  12 },
+	{  8467200, P_PLL4, 4, 18, 209 },
+	{  9216000, P_PLL4, 4,  3,  32 },
+	{ 11289600, P_PLL4, 4, 24, 209 },
+	{ 12288000, P_PLL4, 4,  1,   8 },
+	{ 12700800, P_PLL4, 4, 27, 209 },
+	{ 13824000, P_PLL4, 4,  9,  64 },
+	{ 16384000, P_PLL4, 4,  1,   6 },
+	{ 16934400, P_PLL4, 4, 41, 238 },
+	{ 18432000, P_PLL4, 4,  3,  16 },
+	{ 22579200, P_PLL4, 2, 24, 209 },
+	{ 24576000, P_PLL4, 4,  1,   4 },
+	{ 27648000, P_PLL4, 4,  9,  32 },
+	{ 33868800, P_PLL4, 4, 41, 119 },
+	{ 36864000, P_PLL4, 4,  3,   8 },
+	{ 45158400, P_PLL4, 1, 24, 209 },
+	{ 49152000, P_PLL4, 4,  1,   2 },
+	{ 50803200, P_PLL4, 1, 27, 209 },
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
+	.freq_tbl = clk_tbl_aif_mi2s,
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
+static struct freq_tbl clk_tbl_pcm[] = {
+	{   64000, P_PLL4, 4, 1, 1536 },
+	{  128000, P_PLL4, 4, 1,  768 },
+	{  256000, P_PLL4, 4, 1,  384 },
+	{  512000, P_PLL4, 4, 1,  192 },
+	{ 1024000, P_PLL4, 4, 1,   96 },
+	{ 2048000, P_PLL4, 4, 1,   48 },
+	{ },
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
+	.freq_tbl = clk_tbl_pcm,
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
+static struct freq_tbl clk_tbl_aif_osr[] = {
+	{  22050, P_PLL4, 1, 147, 20480 },
+	{  32000, P_PLL4, 1,   1,    96 },
+	{  44100, P_PLL4, 1, 147, 10240 },
+	{  48000, P_PLL4, 1,   1,    64 },
+	{  88200, P_PLL4, 1, 147,  5120 },
+	{  96000, P_PLL4, 1,   1,    32 },
+	{ 176400, P_PLL4, 1, 147,  2560 },
+	{ 192000, P_PLL4, 1,   1,    16 },
+	{ },
+};
+
+static struct clk_rcg spdif_src = {
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
+	.freq_tbl = clk_tbl_aif_osr,
+	.clkr = {
+		.enable_reg = 0xcc,
+		.enable_mask = BIT(9),
+		.hw.init = &(struct clk_init_data){
+			.name = "spdif_src",
+			.parent_names = lcc_pxo_pll4,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	},
+};
+
+static const char *lcc_spdif_parents[] = {
+	"spdif_src",
+};
+
+static struct clk_branch spdif_clk = {
+	.halt_reg = 0xd4,
+	.halt_bit = 1,
+	.halt_check = BRANCH_HALT_ENABLE,
+	.clkr = {
+		.enable_reg = 0xcc,
+		.enable_mask = BIT(12),
+		.hw.init = &(struct clk_init_data){
+			.name = "spdif_clk",
+			.parent_names = lcc_spdif_parents,
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+			.flags = CLK_SET_RATE_PARENT,
+		},
+	},
+};
+
+static struct freq_tbl clk_tbl_ahbix[] = {
+	{ 131072, P_PLL4, 1, 1, 3 },
+	{ },
+};
+
+static struct clk_rcg ahbix_clk = {
+	.ns_reg = 0x38,
+	.md_reg = 0x3c,
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
+	.freq_tbl = clk_tbl_ahbix,
+	.clkr = {
+		.enable_reg = 0x38,
+		.enable_mask = BIT(10), /* toggle the gfmux to select mn/pxo */
+		.hw.init = &(struct clk_init_data){
+			.name = "ahbix",
+			.parent_names = lcc_pxo_pll4,
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+			.flags = CLK_SET_RATE_GATE,
+		},
+	},
+};
+
+static struct clk_regmap *lcc_ipq806x_clks[] = {
+	[PLL4] = &pll4.clkr,
+	[MI2S_OSR_SRC] = &mi2s_osr_src.clkr,
+	[MI2S_OSR_CLK] = &mi2s_osr_clk.clkr,
+	[MI2S_DIV_CLK] = &mi2s_div_clk.clkr,
+	[MI2S_BIT_DIV_CLK] = &mi2s_bit_div_clk.clkr,
+	[MI2S_BIT_CLK] = &mi2s_bit_clk.clkr,
+	[PCM_SRC] = &pcm_src.clkr,
+	[PCM_CLK_OUT] = &pcm_clk_out.clkr,
+	[PCM_CLK] = &pcm_clk.clkr,
+	[SPDIF_SRC] = &spdif_src.clkr,
+	[SPDIF_CLK] = &spdif_clk.clkr,
+	[AHBIX_CLK] = &ahbix_clk.clkr,
+};
+
+static const struct regmap_config lcc_ipq806x_regmap_config = {
+	.reg_bits	= 32,
+	.reg_stride	= 4,
+	.val_bits	= 32,
+	.max_register	= 0xfc,
+	.fast_io	= true,
+};
+
+static const struct qcom_cc_desc lcc_ipq806x_desc = {
+	.config = &lcc_ipq806x_regmap_config,
+	.clks = lcc_ipq806x_clks,
+	.num_clks = ARRAY_SIZE(lcc_ipq806x_clks),
+};
+
+static const struct of_device_id lcc_ipq806x_match_table[] = {
+	{ .compatible = "qcom,lcc-ipq8064" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lcc_ipq806x_match_table);
+
+static int lcc_ipq806x_probe(struct platform_device *pdev)
+{
+	u32 val;
+	struct regmap *regmap;
+
+	regmap = qcom_cc_map(pdev, &lcc_ipq806x_desc);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	/* Configure the rate of PLL4 if the bootloader hasn't already */
+	val = regmap_read(regmap, 0x0, &val);
+	if (!val)
+		clk_pll_configure_sr(&pll4, regmap, &pll4_config, true);
+	/* Enable PLL4 source on the LPASS Primary PLL Mux */
+	regmap_write(regmap, 0xc4, 0x1);
+
+	return qcom_cc_really_probe(pdev, &lcc_ipq806x_desc, regmap);
+}
+
+static int lcc_ipq806x_remove(struct platform_device *pdev)
+{
+	qcom_cc_remove(pdev);
+	return 0;
+}
+
+static struct platform_driver lcc_ipq806x_driver = {
+	.probe		= lcc_ipq806x_probe,
+	.remove		= lcc_ipq806x_remove,
+	.driver		= {
+		.name	= "lcc-ipq806x",
+		.owner	= THIS_MODULE,
+		.of_match_table = lcc_ipq806x_match_table,
+	},
+};
+module_platform_driver(lcc_ipq806x_driver);
+
+MODULE_DESCRIPTION("QCOM LCC IPQ806x Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:lcc-ipq806x");
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

