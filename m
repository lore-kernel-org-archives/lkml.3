Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab3JBTJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:09:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40943 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab3JBTHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:07:12 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 7/9] clk: msm: Add support for MSM8960's global clock controller (GCC)
Date: Wed,  2 Oct 2013 12:07:04 -0700
Message-Id: <1380740826-29457-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-Reply-To: <1380740826-29457-1-git-send-email-sboyd@codeaurora.org>
References: <1380740826-29457-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the global clock controller found on MSM8960
based platforms. This should allow most non-multimedia device
drivers to probe and control their clocks.

TODO: Fill out reset of data and define all clocks

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/clock/qcom,gcc.txt         |  19 +
 drivers/clk/msm/Kconfig                            |   7 +
 drivers/clk/msm/Makefile                           |   2 +
 drivers/clk/msm/gcc-8960.c                         | 381 +++++++++++++++++++++
 include/dt-bindings/clk/msm-gcc-8960.h             |  28 ++
 5 files changed, 437 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc.txt
 create mode 100644 drivers/clk/msm/gcc-8960.c
 create mode 100644 include/dt-bindings/clk/msm-gcc-8960.h

diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.txt b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
new file mode 100644
index 0000000..e31423a
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
@@ -0,0 +1,19 @@
+MSM Global Clock Controller Binding
+-----------------------------------
+
+Required properties :
+- compatible : shall contain at least "qcom,gcc" and only one of the
+	       following:
+
+			"qcom,gcc-8660"
+			"qcom,gcc-8960"
+
+- reg : shall contain base register location and length
+- #clock-cells : shall contain 1
+
+Example:
+	clock-controller@900000 {
+		compatible = "qcom,gcc-8960", "qcom,gcc";
+		reg = <0x900000 0x4000>;
+		#clock-cells = <1>;
+	};
diff --git a/drivers/clk/msm/Kconfig b/drivers/clk/msm/Kconfig
index 91558ce..241fafc 100644
--- a/drivers/clk/msm/Kconfig
+++ b/drivers/clk/msm/Kconfig
@@ -3,3 +3,10 @@ config COMMON_CLK_MSM
 	depends on OF
 	select REGMAP_MMIO
 
+config MSM_GCC_8960
+	tristate "MSM8960 Global Clock Controller"
+	depends on COMMON_CLK_MSM
+	help
+	  Support for the global clock controller on msm8960 devices.
+	  Say Y if you want to use peripheral devices such as UART, SPI,
+	  i2c, USB, SD/eMMC, SATA, PCIe, etc.
diff --git a/drivers/clk/msm/Makefile b/drivers/clk/msm/Makefile
index e1cee29..804fbe1 100644
--- a/drivers/clk/msm/Makefile
+++ b/drivers/clk/msm/Makefile
@@ -4,3 +4,5 @@ clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-pll.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg2.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-branch.o
+
+obj-$(CONFIG_MSM_GCC_8960) += gcc-8960.o
diff --git a/drivers/clk/msm/gcc-8960.c b/drivers/clk/msm/gcc-8960.c
new file mode 100644
index 0000000..41c8a2f
--- /dev/null
+++ b/drivers/clk/msm/gcc-8960.c
@@ -0,0 +1,381 @@
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
+#include <dt-bindings/clk/msm-gcc-8960.h>
+
+#include "clk-pll.h"
+#include "clk-rcg.h"
+#include "clk-branch.h"
+
+static struct clk_pll pll8 = {
+	.l_reg = 0x3144,
+	.m_reg = 0x3148,
+	.n_reg = 0x314c,
+	.config_reg = 0x3154,
+	.mode_reg = 0x3140,
+	.status_reg = 0x3158,
+	.status_bit = 16,
+	.hw.init = &(struct clk_init_data){
+		.name = "pll8",
+		.parent_names = (const char *[]){ "pxo" },
+		.num_parents = 1,
+		.ops = &clk_pll_ops,
+	},
+};
+
+static struct clk_hw pll8_vote = {
+	.enable_reg = 0x34c0,
+	.enable_mask = BIT(8),
+	.init = &(struct clk_init_data){
+		.name = "pll8_vote",
+		.parent_names = (const char *[]){ "pll8" },
+		.num_parents = 1,
+		.ops = &clk_pll_vote_ops,
+	},
+};
+
+#define P_PXO	0
+#define P_PLL8	1
+
+static u8 gcc_pxo_pll8_map[] = {
+	[P_PXO]		= 0,
+	[P_PLL8]	= 3,
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
+static struct clk_rcg gsbi5_uart_rcg = {
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
+	.hw = {
+		.enable_reg = 0x2a54,
+		.enable_mask = BIT(11),
+		.init = &(struct clk_init_data){
+			.name = "gsbi5_uart_rcg",
+			.parent_names = (const char *[]){
+				"pxo",
+				"pll8_vote",
+			},
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+		},
+	},
+};
+
+static struct clk_branch gsbi5_uart_cxc = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 22,
+	.hw = {
+		.enable_reg = 0x2a54,
+		.enable_mask = BIT(9),
+		.init = &(struct clk_init_data){
+			.name = "gsbi5_uart_cxc",
+			.parent_names = (const char *[]){
+				"gsbi5_uart_rcg",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+		},
+	},
+};
+
+static struct clk_rcg gsbi6_uart_rcg = {
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
+	.hw = {
+		.enable_reg = 0x2a74,
+		.enable_mask = BIT(11),
+		.init = &(struct clk_init_data){
+			.name = "gsbi6_uart_rcg",
+			.parent_names = (const char *[]){
+				"pxo",
+				"pll8_vote",
+			},
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+		},
+	},
+};
+
+static struct clk_branch gsbi6_uart_cxc = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 18,
+	.hw = {
+		.enable_reg = 0x2a74,
+		.enable_mask = BIT(9),
+		.init = &(struct clk_init_data){
+			.name = "gsbi6_uart_cxc",
+			.parent_names = (const char *[]){
+				"gsbi6_uart_rcg",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch_ops,
+		},
+	},
+};
+
+static struct clk_branch gsbi5_uart_ahb = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 23,
+	.hwcg_reg = 0x2a40,
+	.hwcg_bit = 6,
+	.hw = {
+		.enable_reg = 0x2a40,
+		.enable_mask = BIT(4),
+		.init = &(struct clk_init_data){
+			.name = "gsbi5_uart_ahb",
+			.ops = &clk_branch_ops,
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
+static struct clk_rcg gsbi5_qup_rcg = {
+	.ns_reg = 0x2a4c,
+	.md_reg = 0x2a48,
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
+	.freq_tbl = clk_tbl_gsbi_qup,
+	.hw = {
+		.enable_reg = 0x2a4c,
+		.enable_mask = BIT(11),
+		.init = &(struct clk_init_data){
+			.name = "gsbi5_qup_rcg",
+			.parent_names = (const char *[]){
+				"pxo",
+				"pll8_vote",
+			},
+			.num_parents = 2,
+			.ops = &clk_rcg_ops,
+		},
+	},
+};
+
+static struct clk_branch gsbi5_qup_cxc = {
+	.halt_reg = 0x2fd0,
+	.halt_bit = 20,
+	.hw = {
+		.enable_reg = 0x2a4c,
+		.enable_mask = BIT(9),
+		.init = &(struct clk_init_data){
+			.name = "gsbi5_qup_cxc",
+			.parent_names = (const char *[]){
+				"gsbi5_qup_rcg",
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
+	MAP(PLL8, &pll8.hw),
+	MAP(PLL8_VOTE, &pll8_vote),
+	MAP(GSBI5_UART_RCG, &gsbi5_uart_rcg.hw),
+	MAP(GSBI5_UART_CXC, &gsbi5_uart_cxc.hw),
+	MAP(GSBI6_UART_RCG, &gsbi6_uart_rcg.hw),
+	MAP(GSBI6_UART_CXC, &gsbi6_uart_cxc.hw),
+	MAP(GSBI5_UART_AHB, &gsbi5_uart_ahb.hw),
+	MAP(GSBI5_QUP_RCG, &gsbi5_qup_rcg.hw),
+	MAP(GSBI5_QUP_CXC, &gsbi5_qup_cxc.hw),
+};
+
+static const struct regmap_config msm_gcc_8960_regmap_config = {
+	.reg_bits	= 32,
+	.reg_stride	= 4,
+	.val_bits	= 32,
+	.max_register	= 0x3660,
+	.fast_io	= true,
+};
+
+static const struct of_device_id msm_gcc_8960_match_table[] = {
+	{ .compatible = "qcom,gcc-8960" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, msm_gcc_8960_match_table);
+
+static int msm_gcc_8960_probe(struct platform_device *pdev)
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
+	regmap = devm_regmap_init_mmio(dev, base, &msm_gcc_8960_regmap_config);
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
+static int msm_gcc_8960_remove(struct platform_device *pdev)
+{
+	of_clk_del_provider(pdev->dev.of_node);
+	return 0;
+}
+
+static struct platform_driver msm_gcc_8960_driver = {
+	.probe		= msm_gcc_8960_probe,
+	.remove		= msm_gcc_8960_remove,
+	.driver		= {
+		.name	= "msm-gcc-8960",
+		.owner	= THIS_MODULE,
+		.of_match_table = msm_gcc_8960_match_table,
+	},
+};
+
+static int __init msm_gcc_8960_init(void)
+{
+	return platform_driver_register(&msm_gcc_8960_driver);
+}
+core_initcall(msm_gcc_8960_init);
+
+static void __exit msm_gcc_8960_exit(void)
+{
+	platform_driver_unregister(&msm_gcc_8960_driver);
+}
+module_exit(msm_gcc_8960_exit);
+
+MODULE_DESCRIPTION("MSM GCC 8960 Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:msm-gcc-8960");
diff --git a/include/dt-bindings/clk/msm-gcc-8960.h b/include/dt-bindings/clk/msm-gcc-8960.h
new file mode 100644
index 0000000..685b118
--- /dev/null
+++ b/include/dt-bindings/clk/msm-gcc-8960.h
@@ -0,0 +1,28 @@
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
+#define PLL8				0
+#define PLL8_VOTE			1
+#define GSBI5_UART_RCG			2
+#define GSBI5_UART_CXC			3
+#define GSBI6_UART_RCG			4
+#define GSBI6_UART_CXC			5
+#define GSBI6_UART_AHB			6
+#define GSBI5_UART_AHB			7
+#define GSBI5_QUP_RCG			8
+#define GSBI5_QUP_CXC			9
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

