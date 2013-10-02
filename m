Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab3JBTJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:09:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40965 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3JBTHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:07:12 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 8/9] clk: msm: Add support for MSM8960's multimedia clock controller (MMCC)
Date: Wed,  2 Oct 2013 12:07:05 -0700
Message-Id: <1380740826-29457-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-Reply-To: <1380740826-29457-1-git-send-email-sboyd@codeaurora.org>
References: <1380740826-29457-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the multimedia clock controller found on MSM
8960 based platforms. This should allow multimedia device drivers
to probe and control their clocks.

TODO: Fill out reset of data and define all clocks

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/clock/qcom,mmcc.txt        |  19 ++
 drivers/clk/msm/Kconfig                            |   9 +
 drivers/clk/msm/Makefile                           |   1 +
 drivers/clk/msm/mmcc-8960.c                        | 297 +++++++++++++++++++++
 include/dt-bindings/clk/msm-mmcc-8960.h            |  24 ++
 5 files changed, 350 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,mmcc.txt
 create mode 100644 drivers/clk/msm/mmcc-8960.c
 create mode 100644 include/dt-bindings/clk/msm-mmcc-8960.h

diff --git a/Documentation/devicetree/bindings/clock/qcom,mmcc.txt b/Documentation/devicetree/bindings/clock/qcom,mmcc.txt
new file mode 100644
index 0000000..c29d472
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/qcom,mmcc.txt
@@ -0,0 +1,19 @@
+MSM Multimedia Clock Controller Binding
+-----------------------------------------
+
+Required properties :
+- compatible : shall contain at least "qcom,mmcc" and only one of the
+	       following:
+
+			"qcom,mmcc-8660"
+			"qcom,mmcc-8960"
+
+- reg : shall contain base register location and length
+- #clock-cells : shall contain 1
+
+Example:
+	clock-controller@4000000 {
+		compatible = "qcom,mmcc-8960", "qcom,mmcc";
+		reg = <0x4000000 0x1000>;
+		#clock-cells = <1>;
+	};
diff --git a/drivers/clk/msm/Kconfig b/drivers/clk/msm/Kconfig
index 241fafc..66f5ccf 100644
--- a/drivers/clk/msm/Kconfig
+++ b/drivers/clk/msm/Kconfig
@@ -10,3 +10,12 @@ config MSM_GCC_8960
 	  Support for the global clock controller on msm8960 devices.
 	  Say Y if you want to use peripheral devices such as UART, SPI,
 	  i2c, USB, SD/eMMC, SATA, PCIe, etc.
+
+config MSM_MMCC_8960
+	tristate "MSM8960 Multimedia Clock Controller"
+	select MSM_GCC_8960
+	depends on COMMON_CLK_MSM
+	help
+	  Support for the multimedia clock controller on msm8960 devices.
+	  Say Y if you want to support multimedia devices such as display,
+	  graphics, video encode/decode, camera, etc.
diff --git a/drivers/clk/msm/Makefile b/drivers/clk/msm/Makefile
index 804fbe1..f6ceb52 100644
--- a/drivers/clk/msm/Makefile
+++ b/drivers/clk/msm/Makefile
@@ -6,3 +6,4 @@ clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg2.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-branch.o
 
 obj-$(CONFIG_MSM_GCC_8960) += gcc-8960.o
+obj-$(CONFIG_MSM_MMCC_8960) += mmcc-8960.o
diff --git a/drivers/clk/msm/mmcc-8960.c b/drivers/clk/msm/mmcc-8960.c
new file mode 100644
index 0000000..ea660ab
--- /dev/null
+++ b/drivers/clk/msm/mmcc-8960.c
@@ -0,0 +1,297 @@
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
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/clk-provider.h>
+#include <linux/regmap.h>
+
+#include <dt-bindings/clk/msm-mmcc-8960.h>
+
+#include "clk-pll.h"
+#include "clk-rcg.h"
+#include "clk-branch.h"
+
+static struct clk_pll pll2 = {
+	.l_reg = 0x320,
+	.m_reg = 0x324,
+	.n_reg = 0x328,
+	.config_reg = 0x32c,
+	.mode_reg = 0x31c,
+	.status_reg = 0x334,
+	.status_bit = 16,
+	.hw.init = &(struct clk_init_data){
+		.name = "pll2",
+		.parent_names = (const char *[]){ "pxo" },
+		.num_parents = 1,
+		.ops = &clk_pll_ops,
+	},
+};
+
+#define P_PXO	0
+#define P_PLL2	1
+#define P_PLL8	2
+
+static u8 mmcc_pxo_pll2_pll8_map[] = {
+	[P_PXO]		= 0,
+	[P_PLL2]	= 1,
+	[P_PLL8]	= 2,
+};
+
+static struct freq_tbl clk_tbl_mdp[] = {
+	{   9600000, P_PLL8, 0, 1, 40 },
+	{  13710000, P_PLL8, 0, 1, 28 },
+	{  27000000, P_PXO,  0, 0,  0 },
+	{  29540000, P_PLL8, 0, 1, 13 },
+	{  34910000, P_PLL8, 0, 1, 11 },
+	{  38400000, P_PLL8, 0, 1, 10 },
+	{  59080000, P_PLL8, 0, 2, 13 },
+	{  76800000, P_PLL8, 0, 1,  5 },
+	{  85330000, P_PLL8, 0, 2,  9 },
+	{  96000000, P_PLL8, 0, 1,  4 },
+	{ 128000000, P_PLL8, 0, 1,  3 },
+	{ 160000000, P_PLL2, 0, 1,  5 },
+	{ 177780000, P_PLL2, 0, 2,  9 },
+	{ 200000000, P_PLL2, 0, 1,  4 },
+	{ 228571000, P_PLL2, 0, 2,  7 },
+	{ 266667000, P_PLL2, 0, 1,  3 },
+	{ }
+};
+
+static struct clk_dyn_rcg mdp_rcg = {
+	.ns_reg = 0xd0,
+	.md_reg[0] = 0xc4,
+	.md_reg[1] = 0xc8,
+	.mn[0] = {
+		.mnctr_en_bit = 8,
+		.mnctr_reset_bit = 31,
+		.mnctr_mode_shift = 9,
+		.n_val_shift = 22,
+		.m_val_shift = 8,
+		.width = 8,
+	},
+	.mn[1] = {
+		.mnctr_en_bit = 5,
+		.mnctr_reset_bit = 30,
+		.mnctr_mode_shift = 6,
+		.n_val_shift = 14,
+		.m_val_shift = 8,
+		.width = 8,
+	},
+	.s[0] = {
+		.src_sel_shift = 3,
+		.parent_map = mmcc_pxo_pll2_pll8_map,
+	},
+	.s[1] = {
+		.src_sel_shift = 0,
+		.parent_map = mmcc_pxo_pll2_pll8_map,
+	},
+	.mux_sel_bit = 11,
+	.freq_tbl = clk_tbl_mdp,
+	.hw = {
+		.enable_reg = 0xc0,
+		.enable_mask = BIT(2),
+		.init = &(struct clk_init_data){
+			.name = "mdp_rcg",
+			.parent_names = (const char *[]){
+				"pxo", "pll2", "pll8_vote"
+			},
+			.num_parents = 3,
+			.ops = &clk_dyn_rcg_ops,
+		},
+	},
+};
+
+static struct clk_branch mdp_cxc = {
+	.halt_reg = 0x1d0,
+	.halt_bit = 10,
+	.hw = {
+		.enable_reg = 0xc0,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "mdp_cxc",
+			.parent_names = (const char *[]){
+				"mdp_rcg",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+		},
+	},
+};
+
+static struct freq_tbl clk_tbl_rot[] = {
+	{  27000000, P_PXO,   1 },
+	{  29540000, P_PLL8, 13 },
+	{  32000000, P_PLL8, 12 },
+	{  38400000, P_PLL8, 10 },
+	{  48000000, P_PLL8,  8 },
+	{  54860000, P_PLL8,  7 },
+	{  64000000, P_PLL8,  6 },
+	{  76800000, P_PLL8,  5 },
+	{  96000000, P_PLL8,  4 },
+	{ 100000000, P_PLL2,  8 },
+	{ 114290000, P_PLL2,  7 },
+	{ 133330000, P_PLL2,  6 },
+	{ 160000000, P_PLL2,  5 },
+	{ 200000000, P_PLL2,  4 },
+	{ }
+};
+
+static struct clk_dyn_rcg rot_rcg = {
+	.ns_reg = 0xe8,
+	.p[0] = {
+		.pre_div_shift = 22,
+		.pre_div_width = 4,
+	},
+	.p[1] = {
+		.pre_div_shift = 26,
+		.pre_div_width = 4,
+	},
+	.s[0] = {
+		.src_sel_shift = 16,
+		.parent_map = mmcc_pxo_pll2_pll8_map,
+	},
+	.s[1] = {
+		.src_sel_shift = 19,
+		.parent_map = mmcc_pxo_pll2_pll8_map,
+	},
+	.mux_sel_bit = 30,
+	.freq_tbl = clk_tbl_rot,
+	.hw = {
+		.enable_reg = 0xe0,
+		.enable_mask = BIT(2),
+		.init = &(struct clk_init_data){
+			.name = "rot_rcg",
+			.parent_names = (const char *[]){
+				"pxo", "pll2", "pll8_vote"
+			},
+			.num_parents = 3,
+			.ops = &clk_dyn_rcg_ops,
+		},
+	},
+};
+
+static struct clk_branch rot_cxc = {
+	.halt_reg = 0x1d0,
+	.halt_bit = 15,
+	.hw = {
+		.enable_reg = 0xe0,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "rot_cxc",
+			.parent_names = (const char *[]){
+				"rot_rcg",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+		},
+	},
+};
+
+struct clk_map {
+	unsigned long id;
+	struct clk_hw *hw;
+};
+
+#define MAP(i, h) [i] = { .id = i, .hw = h }
+
+static const struct clk_map map[] = {
+	MAP(PLL2, &pll2.hw),
+	MAP(MDP_RCG, &mdp_rcg.hw),
+	MAP(MDP_CXC, &mdp_cxc.hw),
+	MAP(ROT_RCG, &rot_rcg.hw),
+	MAP(ROT_CXC, &rot_cxc.hw),
+};
+
+static const struct regmap_config msm_mmcc_8960_regmap_config = {
+	.reg_bits	= 32,
+	.reg_stride	= 4,
+	.val_bits	= 32,
+	.max_register	= 0x334,
+	.fast_io	= true,
+};
+
+static const struct of_device_id msm_mmcc_8960_match_table[] = {
+	{ .compatible = "qcom,mmcc-8960" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, msm_mmcc_8960_match_table);
+
+static int msm_mmcc_8960_probe(struct platform_device *pdev)
+{
+	void __iomem *base;
+	struct resource *res;
+	int i;
+	struct device *dev = &pdev->dev;
+	struct clk *clk;
+	struct clk_onecell_data *data;
+	struct clk **clks;
+	struct regmap *regmap;
+	size_t num_clks;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	regmap = devm_regmap_init_mmio(dev, base, &msm_mmcc_8960_regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	num_clks = ARRAY_SIZE(map);
+	data = devm_kzalloc(dev, sizeof(*data) + sizeof(*clks) * num_clks,
+			    GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	clks = (struct clk **)(data + 1);
+	data->clks = clks;
+	data->clk_num = num_clks;
+
+	for (i = 0; i < num_clks; i++) {
+		if (!map[i].hw)
+			continue;
+		clk = devm_clk_register(dev, map[i].hw);
+		if (IS_ERR(clk))
+			return PTR_ERR(clk);
+		clks[map[i].id] = clk;
+	}
+
+	return of_clk_add_provider(dev->of_node, of_clk_src_onecell_get, data);
+}
+
+static int msm_mmcc_8960_remove(struct platform_device *pdev)
+{
+	of_clk_del_provider(pdev->dev.of_node);
+	return 0;
+}
+
+static struct platform_driver msm_mmcc_8960_driver = {
+	.probe		= msm_mmcc_8960_probe,
+	.remove		= msm_mmcc_8960_remove,
+	.driver		= {
+		.name	= "msm-mmcc-8960",
+		.owner	= THIS_MODULE,
+		.of_match_table = msm_mmcc_8960_match_table,
+	},
+};
+
+module_platform_driver(msm_mmcc_8960_driver);
+
+MODULE_DESCRIPTION("MSM MMCC 8960 Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:msm-mmcc-8960");
diff --git a/include/dt-bindings/clk/msm-mmcc-8960.h b/include/dt-bindings/clk/msm-mmcc-8960.h
new file mode 100644
index 0000000..86eca3f
--- /dev/null
+++ b/include/dt-bindings/clk/msm-mmcc-8960.h
@@ -0,0 +1,24 @@
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
+#ifndef _DT_BINDINGS_CLK_MSM_MMCC_8960_H
+#define _DT_BINDINGS_CLK_MSM_MMCC_8960_H
+
+
+#define PLL2 			0
+#define MDP_RCG			1
+#define MDP_CXC			2
+#define ROT_RCG			3
+#define ROT_CXC			4
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

