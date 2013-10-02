Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3JBTJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:09:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40969 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab3JBTHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:07:15 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 9/9] clk: msm: Add support for MSM8974's global clock controller (GCC)
Date: Wed,  2 Oct 2013 12:07:06 -0700
Message-Id: <1380740826-29457-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-Reply-To: <1380740826-29457-1-git-send-email-sboyd@codeaurora.org>
References: <1380740826-29457-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the global clock controller found on MSM 8974
based platforms. This should allow most non-multimedia device
drivers to probe and control their clocks.

TODO: define all clocks in binding

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/clock/qcom,gcc.txt         |    1 +
 drivers/clk/msm/Kconfig                            |    8 +
 drivers/clk/msm/Makefile                           |    1 +
 drivers/clk/msm/gcc-8974.c                         | 2488 ++++++++++++++++++++
 include/dt-bindings/clk/msm-gcc-8974.h             |  154 ++
 5 files changed, 2652 insertions(+)
 create mode 100644 drivers/clk/msm/gcc-8974.c
 create mode 100644 include/dt-bindings/clk/msm-gcc-8974.h

diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.txt b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
index e31423a..376f100 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc.txt
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
@@ -7,6 +7,7 @@ Required properties :
 
 			"qcom,gcc-8660"
 			"qcom,gcc-8960"
+			"qcom,gcc-8974"
 
 - reg : shall contain base register location and length
 - #clock-cells : shall contain 1
diff --git a/drivers/clk/msm/Kconfig b/drivers/clk/msm/Kconfig
index 66f5ccf..3c2586f 100644
--- a/drivers/clk/msm/Kconfig
+++ b/drivers/clk/msm/Kconfig
@@ -19,3 +19,11 @@ config MSM_MMCC_8960
 	  Support for the multimedia clock controller on msm8960 devices.
 	  Say Y if you want to support multimedia devices such as display,
 	  graphics, video encode/decode, camera, etc.
+
+config MSM_GCC_8974
+	tristate "MSM8974 Global Clock Controller"
+	depends on COMMON_CLK_MSM
+	help
+	  Support for the global clock controller on msm8974 devices.
+	  Say Y if you want to use peripheral devices such as UART, SPI,
+	  i2c, USB, SD/eMMC, SATA, PCIe, etc.
diff --git a/drivers/clk/msm/Makefile b/drivers/clk/msm/Makefile
index f6ceb52..d11b9a2 100644
--- a/drivers/clk/msm/Makefile
+++ b/drivers/clk/msm/Makefile
@@ -6,4 +6,5 @@ clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg2.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-branch.o
 
 obj-$(CONFIG_MSM_GCC_8960) += gcc-8960.o
+obj-$(CONFIG_MSM_GCC_8974) += gcc-8974.o
 obj-$(CONFIG_MSM_MMCC_8960) += mmcc-8960.o
diff --git a/drivers/clk/msm/gcc-8974.c b/drivers/clk/msm/gcc-8974.c
new file mode 100644
index 0000000..73ae19e
--- /dev/null
+++ b/drivers/clk/msm/gcc-8974.c
@@ -0,0 +1,2488 @@
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
+#include <dt-bindings/clk/msm-gcc-8974.h>
+
+#include "clk-pll.h"
+#include "clk-rcg.h"
+#include "clk-branch.h"
+
+#define P_XO	0
+#define P_GPLL0	1
+#define P_GPLL1	2
+
+static u8 gcc_xo_gpll0_gpll1_map[] = {
+	[P_XO]		= 0,
+	[P_GPLL0]	= 1,
+	[P_GPLL1]	= 2,
+};
+
+#define F(f, s, h, m, n) { (f), (s), (2 * (h) - 1), (m), (n) }
+
+static struct clk_pll gpll0 = {
+	.l_reg = 0x0000 + 0x4,
+	.m_reg = 0x0000 + 0x8,
+	.n_reg = 0x0000 + 0xc,
+	.config_reg = 0x0000 + 0x14,
+	.mode_reg = 0x0000,
+	.status_reg = 0x0000 + 0x1c,
+        .hw.init = &(struct clk_init_data){
+                .name = "gpll0",
+                .parent_names = (const char *[]){ "xo" },
+                .num_parents = 1,
+                .ops = &clk_pll_ops,
+        },
+};
+
+static struct clk_hw gpll0_vote = {
+	.enable_reg = 0x1480,
+	.enable_mask = BIT(0),
+	.init = &(struct clk_init_data){
+		.name = "gpll0_vote",
+		.parent_names = (const char *[]){ "gpll0" },
+		.num_parents = 1,
+		.ops = &clk_pll_vote_ops,
+	},
+};
+
+static struct clk_rcg2 config_noc_clk_src = {
+	.cmd_rcgr = 0x0150,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.hw.init = &(struct clk_init_data){
+		.name = "config_noc_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 periph_noc_clk_src = {
+	.cmd_rcgr = 0x0190,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.hw.init = &(struct clk_init_data){
+		.name = "periph_noc_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 system_noc_clk_src = {
+	.cmd_rcgr = 0x0120,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.hw.init = &(struct clk_init_data){
+		.name = "system_noc_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_pll gpll1 = {
+	.l_reg = 0x0040 + 0x4,
+	.m_reg = 0x0040 + 0x8,
+	.n_reg = 0x0040 + 0xc,
+	.config_reg = 0x0040 + 0x14,
+	.mode_reg = 0x0040,
+	.status_reg = 0x0040 + 0x1c,
+        .hw.init = &(struct clk_init_data){
+                .name = "gpll1",
+                .parent_names = (const char *[]){ "xo" },
+                .num_parents = 1,
+                .ops = &clk_pll_ops,
+        },
+};
+
+static struct clk_hw gpll1_vote = {
+	.enable_reg = 0x1480,
+	.enable_mask = BIT(1),
+	.init = &(struct clk_init_data){
+		.name = "gpll1_vote",
+		.parent_names = (const char *[]){ "gpll1" },
+		.num_parents = 1,
+		.ops = &clk_pll_vote_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_usb30_master_clk[] = {
+	F(125000000, P_GPLL0, 1, 5, 24),
+	{ }
+};
+
+static struct clk_rcg2 usb30_master_clk_src = {
+	.cmd_rcgr = 0x03d4,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_usb30_master_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "usb30_master_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+			"gpll1_vote",
+		},
+		.num_parents = 3,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk[] = {
+	F(19200000, P_XO, 1, 0, 0),
+	F(37500000, P_GPLL0, 16, 0, 0),
+	F(50000000, P_GPLL0, 12, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 blsp1_qup1_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0660,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup1_i2c_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk[] = {
+	F(960000, P_XO, 10, 1, 2),
+	F(4800000, P_XO, 4, 0, 0),
+	F(9600000, P_XO, 2, 0, 0),
+	F(15000000, P_GPLL0, 10, 1, 4),
+	F(19200000, P_XO, 1, 0, 0),
+	F(25000000, P_GPLL0, 12, 1, 2),
+	F(50000000, P_GPLL0, 12, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 blsp1_qup1_spi_apps_clk_src = {
+	.cmd_rcgr = 0x064c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup1_spi_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup2_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x06e0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup2_i2c_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup2_spi_apps_clk_src = {
+	.cmd_rcgr = 0x06cc,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup2_spi_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup3_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0760,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup3_i2c_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup3_spi_apps_clk_src = {
+	.cmd_rcgr = 0x074c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup3_spi_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup4_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x07e0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup4_i2c_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup4_spi_apps_clk_src = {
+	.cmd_rcgr = 0x07cc,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup4_spi_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup5_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0860,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup5_i2c_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup5_spi_apps_clk_src = {
+	.cmd_rcgr = 0x084c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup5_spi_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup6_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x08e0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup6_i2c_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup6_spi_apps_clk_src = {
+	.cmd_rcgr = 0x08cc,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup6_spi_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_blsp1_2_uart1_6_apps_clk[] = {
+	F(3686400, P_GPLL0, 1, 96, 15625),
+	F(7372800, P_GPLL0, 1, 192, 15625),
+	F(14745600, P_GPLL0, 1, 384, 15625),
+	F(16000000, P_GPLL0, 5, 2, 15),
+	F(19200000, P_XO, 1, 0, 0),
+	F(24000000, P_GPLL0, 5, 1, 5),
+	F(32000000, P_GPLL0, 1, 4, 75),
+	F(40000000, P_GPLL0, 15, 0, 0),
+	F(46400000, P_GPLL0, 1, 29, 375),
+	F(48000000, P_GPLL0, 12.5, 0, 0),
+	F(51200000, P_GPLL0, 1, 32, 375),
+	F(56000000, P_GPLL0, 1, 7, 75),
+	F(58982400, P_GPLL0, 1, 1536, 15625),
+	F(60000000, P_GPLL0, 10, 0, 0),
+	F(63160000, P_GPLL0, 9.5, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 blsp1_uart1_apps_clk_src = {
+	.cmd_rcgr = 0x068c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_uart1_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_uart2_apps_clk_src = {
+	.cmd_rcgr = 0x070c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_uart2_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_uart3_apps_clk_src = {
+	.cmd_rcgr = 0x078c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_uart3_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_uart4_apps_clk_src = {
+	.cmd_rcgr = 0x080c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_uart4_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_uart5_apps_clk_src = {
+	.cmd_rcgr = 0x088c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_uart5_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_uart6_apps_clk_src = {
+	.cmd_rcgr = 0x090c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp1_uart6_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup1_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x09a0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup1_i2c_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup1_spi_apps_clk_src = {
+	.cmd_rcgr = 0x098c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup1_spi_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup2_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0a20,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup2_i2c_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup2_spi_apps_clk_src = {
+	.cmd_rcgr = 0x0a0c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup2_spi_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup3_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0aa0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup3_i2c_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup3_spi_apps_clk_src = {
+	.cmd_rcgr = 0x0a8c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup3_spi_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup4_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0b20,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup4_i2c_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup4_spi_apps_clk_src = {
+	.cmd_rcgr = 0x0b0c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup4_spi_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup5_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0ba0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup5_i2c_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup5_spi_apps_clk_src = {
+	.cmd_rcgr = 0x0b8c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup5_spi_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup6_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0c20,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup6_i2c_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup6_spi_apps_clk_src = {
+	.cmd_rcgr = 0x0c0c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup6_spi_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_uart1_apps_clk_src = {
+	.cmd_rcgr = 0x09cc,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_uart1_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_uart2_apps_clk_src = {
+	.cmd_rcgr = 0x0a4c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_uart2_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_uart3_apps_clk_src = {
+	.cmd_rcgr = 0x0acc,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_uart3_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_uart4_apps_clk_src = {
+	.cmd_rcgr = 0x0b4c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_uart4_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_uart5_apps_clk_src = {
+	.cmd_rcgr = 0x0bcc,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_uart5_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_uart6_apps_clk_src = {
+	.cmd_rcgr = 0x0c4c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "blsp2_uart6_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_ce1_clk[] = {
+	F(50000000, P_GPLL0, 12, 0, 0),
+	F(75000000, P_GPLL0, 8, 0, 0),
+	F(100000000, P_GPLL0, 6, 0, 0),
+	F(150000000, P_GPLL0, 4, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 ce1_clk_src = {
+	.cmd_rcgr = 0x1050,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_ce1_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "ce1_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_ce2_clk[] = {
+	F(50000000, P_GPLL0, 12, 0, 0),
+	F(75000000, P_GPLL0, 8, 0, 0),
+	F(100000000, P_GPLL0, 6, 0, 0),
+	F(150000000, P_GPLL0, 4, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 ce2_clk_src = {
+	.cmd_rcgr = 0x1090,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_ce2_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "ce2_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 gp1_clk_src = {
+	.cmd_rcgr = 0x1904,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.hw.init = &(struct clk_init_data){
+		.name = "gp1_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+			"gpll1_vote",
+		},
+		.num_parents = 3,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 gp2_clk_src = {
+	.cmd_rcgr = 0x1944,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.hw.init = &(struct clk_init_data){
+		.name = "gp2_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+			"gpll1_vote",
+		},
+		.num_parents = 3,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 gp3_clk_src = {
+	.cmd_rcgr = 0x1984,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.hw.init = &(struct clk_init_data){
+		.name = "gp3_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_pdm2_clk[] = {
+	F(60000000, P_GPLL0, 10, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 pdm2_clk_src = {
+	.cmd_rcgr = 0x0cd0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_pdm2_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "pdm2_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_sdcc1_4_apps_clk[] = {
+	F(144000, P_XO, 16, 3, 25),
+	F(400000, P_XO, 12, 1, 4),
+	F(20000000, P_GPLL0, 15, 1, 2),
+	F(25000000, P_GPLL0, 12, 1, 2),
+	F(50000000, P_GPLL0, 12, 0, 0),
+	F(100000000, P_GPLL0, 6, 0, 0),
+	F(200000000, P_GPLL0, 3, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 sdcc1_apps_clk_src = {
+	.cmd_rcgr = 0x04d0,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_sdcc1_4_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "sdcc1_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 sdcc2_apps_clk_src = {
+	.cmd_rcgr = 0x0510,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_sdcc1_4_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "sdcc2_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 sdcc3_apps_clk_src = {
+	.cmd_rcgr = 0x0550,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_sdcc1_4_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "sdcc3_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 sdcc4_apps_clk_src = {
+	.cmd_rcgr = 0x0590,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_sdcc1_4_apps_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "sdcc4_apps_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_tsif_ref_clk[] = {
+	F(105000, P_XO, 2, 1, 91),
+	{ }
+};
+
+static struct clk_rcg2 tsif_ref_clk_src = {
+	.cmd_rcgr = 0x0d90,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_tsif_ref_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "tsif_ref_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+			"aud_ref_clk",
+		},
+		.num_parents = 3,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_usb30_mock_utmi_clk[] = {
+	F(60000000, P_GPLL0, 10, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 usb30_mock_utmi_clk_src = {
+	.cmd_rcgr = 0x03e8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_usb30_mock_utmi_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "usb30_mock_utmi_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_usb_hs_system_clk[] = {
+	F(60000000, P_GPLL0, 10, 0, 0),
+	F(75000000, P_GPLL0, 8, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 usb_hs_system_clk_src = {
+	.cmd_rcgr = 0x0490,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_usb_hs_system_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "usb_hs_system_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_usb_hsic_clk[] = {
+	F(480000000, P_GPLL1, 0, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 usb_hsic_clk_src = {
+	.cmd_rcgr = 0x0440,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_usb_hsic_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "usb_hsic_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll1_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_usb_hsic_io_cal_clk[] = {
+	F(9600000, P_XO, 2, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 usb_hsic_io_cal_clk_src = {
+	.cmd_rcgr = 0x0458,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_usb_hsic_io_cal_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "usb_hsic_io_cal_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+		},
+		.num_parents = 1,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct freq_tbl ftbl_gcc_usb_hsic_system_clk[] = {
+	F(60000000, P_GPLL0, 10, 0, 0),
+	F(75000000, P_GPLL0, 8, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 usb_hsic_system_clk_src = {
+	.cmd_rcgr = 0x041c,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_usb_hsic_system_clk,
+	.hw.init = &(struct clk_init_data){
+		.name = "usb_hsic_system_clk_src",
+		.parent_names = (const char *[]){
+			"xo",
+			"gpll0_vote",
+		},
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_branch gcc_bam_dma_ahb_clk = {
+	.halt_reg = 0x0d44,
+	.hw = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(12),
+		.init = &(struct clk_init_data){
+			.name = "gcc_bam_dma_ahb_clk",
+			.parent_names = (const char *[]){
+				"periph_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_ahb_clk = {
+	.halt_reg = 0x05c4,
+	.hw = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(17),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_ahb_clk",
+			.parent_names = (const char *[]){
+				"periph_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_qup1_i2c_apps_clk = {
+	.halt_reg = 0x0648,
+	.hw = {
+		.enable_reg = 0x0648,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_qup1_i2c_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_qup1_i2c_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_qup1_spi_apps_clk = {
+	.halt_reg = 0x0644,
+	.hw = {
+		.enable_reg = 0x0644,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_qup1_spi_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_qup1_spi_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_qup2_i2c_apps_clk = {
+	.halt_reg = 0x06c8,
+	.hw = {
+		.enable_reg = 0x06c8,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_qup2_i2c_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_qup2_i2c_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_qup2_spi_apps_clk = {
+	.halt_reg = 0x06c4,
+	.hw = {
+		.enable_reg = 0x06c4,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_qup2_spi_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_qup2_spi_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_qup3_i2c_apps_clk = {
+	.halt_reg = 0x0748,
+	.hw = {
+		.enable_reg = 0x0748,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_qup3_i2c_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_qup3_i2c_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_qup3_spi_apps_clk = {
+	.halt_reg = 0x0744,
+	.hw = {
+		.enable_reg = 0x0744,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_qup3_spi_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_qup3_spi_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_qup4_i2c_apps_clk = {
+	.halt_reg = 0x07c8,
+	.hw = {
+		.enable_reg = 0x07c8,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_qup4_i2c_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_qup4_i2c_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_qup4_spi_apps_clk = {
+	.halt_reg = 0x07c4,
+	.hw = {
+		.enable_reg = 0x07c4,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_qup4_spi_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_qup4_spi_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_qup5_i2c_apps_clk = {
+	.halt_reg = 0x0848,
+	.hw = {
+		.enable_reg = 0x0848,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_qup5_i2c_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_qup5_i2c_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_qup5_spi_apps_clk = {
+	.halt_reg = 0x0844,
+	.hw = {
+		.enable_reg = 0x0844,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_qup5_spi_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_qup5_spi_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_qup6_i2c_apps_clk = {
+	.halt_reg = 0x08c8,
+	.hw = {
+		.enable_reg = 0x08c8,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_qup6_i2c_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_qup6_i2c_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_qup6_spi_apps_clk = {
+	.halt_reg = 0x08c4,
+	.hw = {
+		.enable_reg = 0x08c4,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_qup6_spi_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_qup6_spi_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_uart1_apps_clk = {
+	.halt_reg = 0x0684,
+	.hw = {
+		.enable_reg = 0x0684,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_uart1_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_uart1_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_uart2_apps_clk = {
+	.halt_reg = 0x0704,
+	.hw = {
+		.enable_reg = 0x0704,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_uart2_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_uart2_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_uart3_apps_clk = {
+	.halt_reg = 0x0784,
+	.hw = {
+		.enable_reg = 0x0784,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_uart3_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_uart3_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_uart4_apps_clk = {
+	.halt_reg = 0x0804,
+	.hw = {
+		.enable_reg = 0x0804,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_uart4_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_uart4_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_uart5_apps_clk = {
+	.halt_reg = 0x0884,
+	.hw = {
+		.enable_reg = 0x0884,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_uart5_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_uart5_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp1_uart6_apps_clk = {
+	.halt_reg = 0x0904,
+	.hw = {
+		.enable_reg = 0x0904,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp1_uart6_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp1_uart6_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_ahb_clk = {
+	.halt_reg = 0x05c4,
+	.hw = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(15),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_ahb_clk",
+			.parent_names = (const char *[]){
+				"periph_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_qup1_i2c_apps_clk = {
+	.halt_reg = 0x0988,
+	.hw = {
+		.enable_reg = 0x0988,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_qup1_i2c_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_qup1_i2c_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_qup1_spi_apps_clk = {
+	.halt_reg = 0x0984,
+	.hw = {
+		.enable_reg = 0x0984,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_qup1_spi_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_qup1_spi_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_qup2_i2c_apps_clk = {
+	.halt_reg = 0x0a08,
+	.hw = {
+		.enable_reg = 0x0a08,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_qup2_i2c_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_qup2_i2c_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_qup2_spi_apps_clk = {
+	.halt_reg = 0x0a04,
+	.hw = {
+		.enable_reg = 0x0a04,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_qup2_spi_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_qup2_spi_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_qup3_i2c_apps_clk = {
+	.halt_reg = 0x0a88,
+	.hw = {
+		.enable_reg = 0x0a88,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_qup3_i2c_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_qup3_i2c_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_qup3_spi_apps_clk = {
+	.halt_reg = 0x0a84,
+	.hw = {
+		.enable_reg = 0x0a84,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_qup3_spi_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_qup3_spi_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_qup4_i2c_apps_clk = {
+	.halt_reg = 0x0b08,
+	.hw = {
+		.enable_reg = 0x0b08,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_qup4_i2c_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_qup4_i2c_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_qup4_spi_apps_clk = {
+	.halt_reg = 0x0b04,
+	.hw = {
+		.enable_reg = 0x0b04,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_qup4_spi_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_qup4_spi_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_qup5_i2c_apps_clk = {
+	.halt_reg = 0x0b88,
+	.hw = {
+		.enable_reg = 0x0b88,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_qup5_i2c_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_qup5_i2c_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_qup5_spi_apps_clk = {
+	.halt_reg = 0x0b84,
+	.hw = {
+		.enable_reg = 0x0b84,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_qup5_spi_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_qup5_spi_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_qup6_i2c_apps_clk = {
+	.halt_reg = 0x0c08,
+	.hw = {
+		.enable_reg = 0x0c08,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_qup6_i2c_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_qup6_i2c_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_qup6_spi_apps_clk = {
+	.halt_reg = 0x0c04,
+	.hw = {
+		.enable_reg = 0x0c04,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_qup6_spi_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_qup6_spi_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_uart1_apps_clk = {
+	.halt_reg = 0x09c4,
+	.hw = {
+		.enable_reg = 0x09c4,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_uart1_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_uart1_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_uart2_apps_clk = {
+	.halt_reg = 0x0a44,
+	.hw = {
+		.enable_reg = 0x0a44,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_uart2_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_uart2_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_uart3_apps_clk = {
+	.halt_reg = 0x0ac4,
+	.hw = {
+		.enable_reg = 0x0ac4,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_uart3_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_uart3_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_uart4_apps_clk = {
+	.halt_reg = 0x0b44,
+	.hw = {
+		.enable_reg = 0x0b44,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_uart4_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_uart4_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_uart5_apps_clk = {
+	.halt_reg = 0x0bc4,
+	.hw = {
+		.enable_reg = 0x0bc4,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_uart5_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_uart5_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_blsp2_uart6_apps_clk = {
+	.halt_reg = 0x0c44,
+	.hw = {
+		.enable_reg = 0x0c44,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_blsp2_uart6_apps_clk",
+			.parent_names = (const char *[]){
+				"blsp2_uart6_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_boot_rom_ahb_clk = {
+	.halt_reg = 0x0e04,
+	.hw = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(10),
+		.init = &(struct clk_init_data){
+			.name = "gcc_boot_rom_ahb_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ce1_ahb_clk = {
+	.halt_reg = 0x104c,
+	.hw = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(3),
+		.init = &(struct clk_init_data){
+			.name = "gcc_ce1_ahb_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ce1_axi_clk = {
+	.halt_reg = 0x1048,
+	.hw = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(4),
+		.init = &(struct clk_init_data){
+			.name = "gcc_ce1_axi_clk",
+			.parent_names = (const char *[]){
+				"system_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ce1_clk = {
+	.halt_reg = 0x1050,
+	.hw = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(5),
+		.init = &(struct clk_init_data){
+			.name = "gcc_ce1_clk",
+			.parent_names = (const char *[]){
+				"ce1_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ce2_ahb_clk = {
+	.halt_reg = 0x108c,
+	.hw = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_ce2_ahb_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ce2_axi_clk = {
+	.halt_reg = 0x1088,
+	.hw = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(1),
+		.init = &(struct clk_init_data){
+			.name = "gcc_ce2_axi_clk",
+			.parent_names = (const char *[]){
+				"system_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_ce2_clk = {
+	.halt_reg = 0x1090,
+	.hw = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(2),
+		.init = &(struct clk_init_data){
+			.name = "gcc_ce2_clk",
+			.parent_names = (const char *[]){
+				"ce2_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_gp1_clk = {
+	.halt_reg = 0x1900,
+	.hw = {
+		.enable_reg = 0x1900,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_gp1_clk",
+			.parent_names = (const char *[]){
+				"gp1_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_gp2_clk = {
+	.halt_reg = 0x1940,
+	.hw = {
+		.enable_reg = 0x1940,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_gp2_clk",
+			.parent_names = (const char *[]){
+				"gp2_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_gp3_clk = {
+	.halt_reg = 0x1980,
+	.hw = {
+		.enable_reg = 0x1980,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_gp3_clk",
+			.parent_names = (const char *[]){
+				"gp3_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_pdm2_clk = {
+	.halt_reg = 0x0ccc,
+	.hw = {
+		.enable_reg = 0x0ccc,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_pdm2_clk",
+			.parent_names = (const char *[]){
+				"pdm2_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_prng_ahb_clk = {
+	.halt_reg = 0x0d04,
+	.hw = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(13),
+		.init = &(struct clk_init_data){
+			.name = "gcc_prng_ahb_clk",
+			.parent_names = (const char *[]){
+				"periph_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sdcc1_apps_clk = {
+	.halt_reg = 0x04c4,
+	.hw = {
+		.enable_reg = 0x04c4,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_sdcc1_apps_clk",
+			.parent_names = (const char *[]){
+				"sdcc1_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sdcc2_apps_clk = {
+	.halt_reg = 0x0504,
+	.hw = {
+		.enable_reg = 0x0504,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_sdcc2_apps_clk",
+			.parent_names = (const char *[]){
+				"sdcc2_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sdcc3_apps_clk = {
+	.halt_reg = 0x0544,
+	.hw = {
+		.enable_reg = 0x0544,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_sdcc3_apps_clk",
+			.parent_names = (const char *[]){
+				"sdcc3_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sdcc4_apps_clk = {
+	.halt_reg = 0x0584,
+	.hw = {
+		.enable_reg = 0x0584,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_sdcc4_apps_clk",
+			.parent_names = (const char *[]){
+				"sdcc4_apps_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sys_noc_usb3_axi_clk = {
+	.halt_reg = 0x0108,
+	.hw = {
+		.enable_reg = 0x0108,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_sys_noc_usb3_axi_clk",
+			.parent_names = (const char *[]){
+				"usb30_master_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_tsif_ref_clk = {
+	.halt_reg = 0x0d88,
+	.hw = {
+		.enable_reg = 0x0d88,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_tsif_ref_clk",
+			.parent_names = (const char *[]){
+				"tsif_ref_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb2a_phy_sleep_clk = {
+	.halt_reg = 0x04ac,
+	.hw = {
+		.enable_reg = 0x04ac,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_usb2a_phy_sleep_clk",
+			.parent_names = (const char *[]){
+				"gcc_sleep_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb2b_phy_sleep_clk = {
+	.halt_reg = 0x04b4,
+	.hw = {
+		.enable_reg = 0x04b4,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_usb2b_phy_sleep_clk",
+			.parent_names = (const char *[]){
+				"gcc_sleep_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb30_master_clk = {
+	.halt_reg = 0x03c8,
+	.hw = {
+		.enable_reg = 0x03c8,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_usb30_master_clk",
+			.parent_names = (const char *[]){
+				"usb30_master_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb30_mock_utmi_clk = {
+	.halt_reg = 0x03d0,
+	.hw = {
+		.enable_reg = 0x03d0,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_usb30_mock_utmi_clk",
+			.parent_names = (const char *[]){
+				"usb30_mock_utmi_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb30_sleep_clk = {
+	.halt_reg = 0x03cc,
+	.hw = {
+		.enable_reg = 0x03cc,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_usb30_sleep_clk",
+			.parent_names = (const char *[]){
+				"gcc_sleep_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb_hs_system_clk = {
+	.halt_reg = 0x0484,
+	.hw = {
+		.enable_reg = 0x0484,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_usb_hs_system_clk",
+			.parent_names = (const char *[]){
+				"usb_hs_system_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb_hsic_clk = {
+	.halt_reg = 0x0410,
+	.hw = {
+		.enable_reg = 0x0410,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_usb_hsic_clk",
+			.parent_names = (const char *[]){
+				"usb_hsic_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb_hsic_io_cal_clk = {
+	.halt_reg = 0x0414,
+	.hw = {
+		.enable_reg = 0x0414,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_usb_hsic_io_cal_clk",
+			.parent_names = (const char *[]){
+				"usb_hsic_io_cal_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb_hsic_io_cal_sleep_clk = {
+	.halt_reg = 0x0418,
+	.hw = {
+		.enable_reg = 0x0418,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_usb_hsic_io_cal_sleep_clk",
+			.parent_names = (const char *[]){
+				"gcc_sleep_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb_hsic_system_clk = {
+	.halt_reg = 0x040c,
+	.hw = {
+		.enable_reg = 0x040c,
+		.enable_mask = BIT(0),
+		.init = &(struct clk_init_data){
+			.name = "gcc_usb_hsic_system_clk",
+			.parent_names = (const char *[]){
+				"usb_hsic_system_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
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
+	MAP(GPLL0, &gpll0.hw),
+	MAP(GPLL0_VOTE, &gpll0_vote),
+	MAP(CONFIG_NOC_CLK_SRC, &config_noc_clk_src.hw),
+	MAP(PERIPH_NOC_CLK_SRC, &periph_noc_clk_src.hw),
+	MAP(SYSTEM_NOC_CLK_SRC, &system_noc_clk_src.hw),
+	MAP(GPLL1, &gpll1.hw),
+	MAP(GPLL1_VOTE, &gpll1_vote),
+	MAP(USB30_MASTER_CLK_SRC, &usb30_master_clk_src.hw),
+	MAP(BLSP1_QUP1_I2C_APPS_CLK_SRC, &blsp1_qup1_i2c_apps_clk_src.hw),
+	MAP(BLSP1_QUP1_SPI_APPS_CLK_SRC, &blsp1_qup1_spi_apps_clk_src.hw),
+	MAP(BLSP1_QUP2_I2C_APPS_CLK_SRC, &blsp1_qup2_i2c_apps_clk_src.hw),
+	MAP(BLSP1_QUP2_SPI_APPS_CLK_SRC, &blsp1_qup2_spi_apps_clk_src.hw),
+	MAP(BLSP1_QUP3_I2C_APPS_CLK_SRC, &blsp1_qup3_i2c_apps_clk_src.hw),
+	MAP(BLSP1_QUP3_SPI_APPS_CLK_SRC, &blsp1_qup3_spi_apps_clk_src.hw),
+	MAP(BLSP1_QUP4_I2C_APPS_CLK_SRC, &blsp1_qup4_i2c_apps_clk_src.hw),
+	MAP(BLSP1_QUP4_SPI_APPS_CLK_SRC, &blsp1_qup4_spi_apps_clk_src.hw),
+	MAP(BLSP1_QUP5_I2C_APPS_CLK_SRC, &blsp1_qup5_i2c_apps_clk_src.hw),
+	MAP(BLSP1_QUP5_SPI_APPS_CLK_SRC, &blsp1_qup5_spi_apps_clk_src.hw),
+	MAP(BLSP1_QUP6_I2C_APPS_CLK_SRC, &blsp1_qup6_i2c_apps_clk_src.hw),
+	MAP(BLSP1_QUP6_SPI_APPS_CLK_SRC, &blsp1_qup6_spi_apps_clk_src.hw),
+	MAP(BLSP1_UART1_APPS_CLK_SRC, &blsp1_uart1_apps_clk_src.hw),
+	MAP(BLSP1_UART2_APPS_CLK_SRC, &blsp1_uart2_apps_clk_src.hw),
+	MAP(BLSP1_UART3_APPS_CLK_SRC, &blsp1_uart3_apps_clk_src.hw),
+	MAP(BLSP1_UART4_APPS_CLK_SRC, &blsp1_uart4_apps_clk_src.hw),
+	MAP(BLSP1_UART5_APPS_CLK_SRC, &blsp1_uart5_apps_clk_src.hw),
+	MAP(BLSP1_UART6_APPS_CLK_SRC, &blsp1_uart6_apps_clk_src.hw),
+	MAP(BLSP2_QUP1_I2C_APPS_CLK_SRC, &blsp2_qup1_i2c_apps_clk_src.hw),
+	MAP(BLSP2_QUP1_SPI_APPS_CLK_SRC, &blsp2_qup1_spi_apps_clk_src.hw),
+	MAP(BLSP2_QUP2_I2C_APPS_CLK_SRC, &blsp2_qup2_i2c_apps_clk_src.hw),
+	MAP(BLSP2_QUP2_SPI_APPS_CLK_SRC, &blsp2_qup2_spi_apps_clk_src.hw),
+	MAP(BLSP2_QUP3_I2C_APPS_CLK_SRC, &blsp2_qup3_i2c_apps_clk_src.hw),
+	MAP(BLSP2_QUP3_SPI_APPS_CLK_SRC, &blsp2_qup3_spi_apps_clk_src.hw),
+	MAP(BLSP2_QUP4_I2C_APPS_CLK_SRC, &blsp2_qup4_i2c_apps_clk_src.hw),
+	MAP(BLSP2_QUP4_SPI_APPS_CLK_SRC, &blsp2_qup4_spi_apps_clk_src.hw),
+	MAP(BLSP2_QUP5_I2C_APPS_CLK_SRC, &blsp2_qup5_i2c_apps_clk_src.hw),
+	MAP(BLSP2_QUP5_SPI_APPS_CLK_SRC, &blsp2_qup5_spi_apps_clk_src.hw),
+	MAP(BLSP2_QUP6_I2C_APPS_CLK_SRC, &blsp2_qup6_i2c_apps_clk_src.hw),
+	MAP(BLSP2_QUP6_SPI_APPS_CLK_SRC, &blsp2_qup6_spi_apps_clk_src.hw),
+	MAP(BLSP2_UART1_APPS_CLK_SRC, &blsp2_uart1_apps_clk_src.hw),
+	MAP(BLSP2_UART2_APPS_CLK_SRC, &blsp2_uart2_apps_clk_src.hw),
+	MAP(BLSP2_UART3_APPS_CLK_SRC, &blsp2_uart3_apps_clk_src.hw),
+	MAP(BLSP2_UART4_APPS_CLK_SRC, &blsp2_uart4_apps_clk_src.hw),
+	MAP(BLSP2_UART5_APPS_CLK_SRC, &blsp2_uart5_apps_clk_src.hw),
+	MAP(BLSP2_UART6_APPS_CLK_SRC, &blsp2_uart6_apps_clk_src.hw),
+	MAP(CE1_CLK_SRC, &ce1_clk_src.hw),
+	MAP(CE2_CLK_SRC, &ce2_clk_src.hw),
+	MAP(GP1_CLK_SRC, &gp1_clk_src.hw),
+	MAP(GP2_CLK_SRC, &gp2_clk_src.hw),
+	MAP(GP3_CLK_SRC, &gp3_clk_src.hw),
+	MAP(PDM2_CLK_SRC, &pdm2_clk_src.hw),
+	MAP(SDCC1_APPS_CLK_SRC, &sdcc1_apps_clk_src.hw),
+	MAP(SDCC2_APPS_CLK_SRC, &sdcc2_apps_clk_src.hw),
+	MAP(SDCC3_APPS_CLK_SRC, &sdcc3_apps_clk_src.hw),
+	MAP(SDCC4_APPS_CLK_SRC, &sdcc4_apps_clk_src.hw),
+	MAP(TSIF_REF_CLK_SRC, &tsif_ref_clk_src.hw),
+	MAP(USB30_MOCK_UTMI_CLK_SRC, &usb30_mock_utmi_clk_src.hw),
+	MAP(USB_HS_SYSTEM_CLK_SRC, &usb_hs_system_clk_src.hw),
+	MAP(USB_HSIC_CLK_SRC, &usb_hsic_clk_src.hw),
+	MAP(USB_HSIC_IO_CAL_CLK_SRC, &usb_hsic_io_cal_clk_src.hw),
+	MAP(USB_HSIC_SYSTEM_CLK_SRC, &usb_hsic_system_clk_src.hw),
+	MAP(GCC_BAM_DMA_AHB_CLK, &gcc_bam_dma_ahb_clk.hw),
+	MAP(GCC_BLSP1_AHB_CLK, &gcc_blsp1_ahb_clk.hw),
+	MAP(GCC_BLSP1_QUP1_I2C_APPS_CLK, &gcc_blsp1_qup1_i2c_apps_clk.hw),
+	MAP(GCC_BLSP1_QUP1_SPI_APPS_CLK, &gcc_blsp1_qup1_spi_apps_clk.hw),
+	MAP(GCC_BLSP1_QUP2_I2C_APPS_CLK, &gcc_blsp1_qup2_i2c_apps_clk.hw),
+	MAP(GCC_BLSP1_QUP2_SPI_APPS_CLK, &gcc_blsp1_qup2_spi_apps_clk.hw),
+	MAP(GCC_BLSP1_QUP3_I2C_APPS_CLK, &gcc_blsp1_qup3_i2c_apps_clk.hw),
+	MAP(GCC_BLSP1_QUP3_SPI_APPS_CLK, &gcc_blsp1_qup3_spi_apps_clk.hw),
+	MAP(GCC_BLSP1_QUP4_I2C_APPS_CLK, &gcc_blsp1_qup4_i2c_apps_clk.hw),
+	MAP(GCC_BLSP1_QUP4_SPI_APPS_CLK, &gcc_blsp1_qup4_spi_apps_clk.hw),
+	MAP(GCC_BLSP1_QUP5_I2C_APPS_CLK, &gcc_blsp1_qup5_i2c_apps_clk.hw),
+	MAP(GCC_BLSP1_QUP5_SPI_APPS_CLK, &gcc_blsp1_qup5_spi_apps_clk.hw),
+	MAP(GCC_BLSP1_QUP6_I2C_APPS_CLK, &gcc_blsp1_qup6_i2c_apps_clk.hw),
+	MAP(GCC_BLSP1_QUP6_SPI_APPS_CLK, &gcc_blsp1_qup6_spi_apps_clk.hw),
+	MAP(GCC_BLSP1_UART1_APPS_CLK, &gcc_blsp1_uart1_apps_clk.hw),
+	MAP(GCC_BLSP1_UART2_APPS_CLK, &gcc_blsp1_uart2_apps_clk.hw),
+	MAP(GCC_BLSP1_UART3_APPS_CLK, &gcc_blsp1_uart3_apps_clk.hw),
+	MAP(GCC_BLSP1_UART4_APPS_CLK, &gcc_blsp1_uart4_apps_clk.hw),
+	MAP(GCC_BLSP1_UART5_APPS_CLK, &gcc_blsp1_uart5_apps_clk.hw),
+	MAP(GCC_BLSP1_UART6_APPS_CLK, &gcc_blsp1_uart6_apps_clk.hw),
+	MAP(GCC_BLSP2_AHB_CLK, &gcc_blsp2_ahb_clk.hw),
+	MAP(GCC_BLSP2_QUP1_I2C_APPS_CLK, &gcc_blsp2_qup1_i2c_apps_clk.hw),
+	MAP(GCC_BLSP2_QUP1_SPI_APPS_CLK, &gcc_blsp2_qup1_spi_apps_clk.hw),
+	MAP(GCC_BLSP2_QUP2_I2C_APPS_CLK, &gcc_blsp2_qup2_i2c_apps_clk.hw),
+	MAP(GCC_BLSP2_QUP2_SPI_APPS_CLK, &gcc_blsp2_qup2_spi_apps_clk.hw),
+	MAP(GCC_BLSP2_QUP3_I2C_APPS_CLK, &gcc_blsp2_qup3_i2c_apps_clk.hw),
+	MAP(GCC_BLSP2_QUP3_SPI_APPS_CLK, &gcc_blsp2_qup3_spi_apps_clk.hw),
+	MAP(GCC_BLSP2_QUP4_I2C_APPS_CLK, &gcc_blsp2_qup4_i2c_apps_clk.hw),
+	MAP(GCC_BLSP2_QUP4_SPI_APPS_CLK, &gcc_blsp2_qup4_spi_apps_clk.hw),
+	MAP(GCC_BLSP2_QUP5_I2C_APPS_CLK, &gcc_blsp2_qup5_i2c_apps_clk.hw),
+	MAP(GCC_BLSP2_QUP5_SPI_APPS_CLK, &gcc_blsp2_qup5_spi_apps_clk.hw),
+	MAP(GCC_BLSP2_QUP6_I2C_APPS_CLK, &gcc_blsp2_qup6_i2c_apps_clk.hw),
+	MAP(GCC_BLSP2_QUP6_SPI_APPS_CLK, &gcc_blsp2_qup6_spi_apps_clk.hw),
+	MAP(GCC_BLSP2_UART1_APPS_CLK, &gcc_blsp2_uart1_apps_clk.hw),
+	MAP(GCC_BLSP2_UART2_APPS_CLK, &gcc_blsp2_uart2_apps_clk.hw),
+	MAP(GCC_BLSP2_UART3_APPS_CLK, &gcc_blsp2_uart3_apps_clk.hw),
+	MAP(GCC_BLSP2_UART4_APPS_CLK, &gcc_blsp2_uart4_apps_clk.hw),
+	MAP(GCC_BLSP2_UART5_APPS_CLK, &gcc_blsp2_uart5_apps_clk.hw),
+	MAP(GCC_BLSP2_UART6_APPS_CLK, &gcc_blsp2_uart6_apps_clk.hw),
+	MAP(GCC_BOOT_ROM_AHB_CLK, &gcc_boot_rom_ahb_clk.hw),
+	MAP(GCC_CE1_AHB_CLK, &gcc_ce1_ahb_clk.hw),
+	MAP(GCC_CE1_AXI_CLK, &gcc_ce1_axi_clk.hw),
+	MAP(GCC_CE1_CLK, &gcc_ce1_clk.hw),
+	MAP(GCC_CE2_AHB_CLK, &gcc_ce2_ahb_clk.hw),
+	MAP(GCC_CE2_AXI_CLK, &gcc_ce2_axi_clk.hw),
+	MAP(GCC_CE2_CLK, &gcc_ce2_clk.hw),
+	MAP(GCC_GP1_CLK, &gcc_gp1_clk.hw),
+	MAP(GCC_GP2_CLK, &gcc_gp2_clk.hw),
+	MAP(GCC_GP3_CLK, &gcc_gp3_clk.hw),
+	MAP(GCC_PDM2_CLK, &gcc_pdm2_clk.hw),
+	MAP(GCC_PRNG_AHB_CLK, &gcc_prng_ahb_clk.hw),
+	MAP(GCC_SDCC1_APPS_CLK, &gcc_sdcc1_apps_clk.hw),
+	MAP(GCC_SDCC2_APPS_CLK, &gcc_sdcc2_apps_clk.hw),
+	MAP(GCC_SDCC3_APPS_CLK, &gcc_sdcc3_apps_clk.hw),
+	MAP(GCC_SDCC4_APPS_CLK, &gcc_sdcc4_apps_clk.hw),
+	MAP(GCC_SYS_NOC_USB3_AXI_CLK, &gcc_sys_noc_usb3_axi_clk.hw),
+	MAP(GCC_TSIF_REF_CLK, &gcc_tsif_ref_clk.hw),
+	MAP(GCC_USB2A_PHY_SLEEP_CLK, &gcc_usb2a_phy_sleep_clk.hw),
+	MAP(GCC_USB2B_PHY_SLEEP_CLK, &gcc_usb2b_phy_sleep_clk.hw),
+	MAP(GCC_USB30_MASTER_CLK, &gcc_usb30_master_clk.hw),
+	MAP(GCC_USB30_MOCK_UTMI_CLK, &gcc_usb30_mock_utmi_clk.hw),
+	MAP(GCC_USB30_SLEEP_CLK, &gcc_usb30_sleep_clk.hw),
+	MAP(GCC_USB_HS_SYSTEM_CLK, &gcc_usb_hs_system_clk.hw),
+	MAP(GCC_USB_HSIC_CLK, &gcc_usb_hsic_clk.hw),
+	MAP(GCC_USB_HSIC_IO_CAL_CLK, &gcc_usb_hsic_io_cal_clk.hw),
+	MAP(GCC_USB_HSIC_IO_CAL_SLEEP_CLK, &gcc_usb_hsic_io_cal_sleep_clk.hw),
+	MAP(GCC_USB_HSIC_SYSTEM_CLK, &gcc_usb_hsic_system_clk.hw),
+};
+
+static const struct regmap_config msm_gcc_8974_regmap_config = {
+	.reg_bits	= 32,
+	.reg_stride	= 4,
+	.val_bits	= 32,
+	.max_register	= 0x1a00,
+	.fast_io	= true,
+};
+
+static const struct of_device_id msm_gcc_8974_match_table[] = {
+	{ .compatible = "qcom,gcc-8974" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, msm_gcc_8974_match_table);
+
+static int msm_gcc_8974_probe(struct platform_device *pdev)
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
+	regmap = devm_regmap_init_mmio(dev, base, &msm_gcc_8974_regmap_config);
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
+	clk = clk_register_fixed_rate(dev, "xo", NULL, CLK_IS_ROOT, 19200000);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	/* Should move to DT node? */
+	clk = clk_register_fixed_rate(dev, "gcc_sleep_clk_src", NULL,
+				      CLK_IS_ROOT, 32768);
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
+static int msm_gcc_8974_remove(struct platform_device *pdev)
+{
+	of_clk_del_provider(pdev->dev.of_node);
+	return 0;
+}
+
+static struct platform_driver msm_gcc_8974_driver = {
+	.probe		= msm_gcc_8974_probe,
+	.remove		= msm_gcc_8974_remove,
+	.driver		= {
+		.name	= "msm-gcc-8974",
+		.owner	= THIS_MODULE,
+		.of_match_table = msm_gcc_8974_match_table,
+	},
+};
+
+static int __init msm_gcc_8974_init(void)
+{
+	return platform_driver_register(&msm_gcc_8974_driver);
+}
+core_initcall(msm_gcc_8974_init);
+
+static void __exit msm_gcc_8974_exit(void)
+{
+	platform_driver_unregister(&msm_gcc_8974_driver);
+}
+module_exit(msm_gcc_8974_exit);
+
+MODULE_DESCRIPTION("MSM GCC 8974 Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:msm-gcc-8974");
diff --git a/include/dt-bindings/clk/msm-gcc-8974.h b/include/dt-bindings/clk/msm-gcc-8974.h
new file mode 100644
index 0000000..207ec32
--- /dev/null
+++ b/include/dt-bindings/clk/msm-gcc-8974.h
@@ -0,0 +1,154 @@
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
+#ifndef _DT_BINDINGS_CLK_MSM_GCC_8974_H
+#define _DT_BINDINGS_CLK_MSM_GCC_8974_H
+
+#define GPLL0					0
+#define GPLL0_VOTE				1
+#define CONFIG_NOC_CLK_SRC			2
+#define PERIPH_NOC_CLK_SRC			3
+#define SYSTEM_NOC_CLK_SRC			4
+#define GPLL1					5
+#define GPLL1_VOTE				6
+#define USB30_MASTER_CLK_SRC			7
+#define BLSP1_QUP1_I2C_APPS_CLK_SRC		8
+#define BLSP1_QUP1_SPI_APPS_CLK_SRC		9
+#define BLSP1_QUP2_I2C_APPS_CLK_SRC		10
+#define BLSP1_QUP2_SPI_APPS_CLK_SRC		11
+#define BLSP1_QUP3_I2C_APPS_CLK_SRC		12
+#define BLSP1_QUP3_SPI_APPS_CLK_SRC		13
+#define BLSP1_QUP4_I2C_APPS_CLK_SRC		14
+#define BLSP1_QUP4_SPI_APPS_CLK_SRC		15
+#define BLSP1_QUP5_I2C_APPS_CLK_SRC		16
+#define BLSP1_QUP5_SPI_APPS_CLK_SRC		17
+#define BLSP1_QUP6_I2C_APPS_CLK_SRC		18
+#define BLSP1_QUP6_SPI_APPS_CLK_SRC		19
+#define BLSP1_UART1_APPS_CLK_SRC		20
+#define BLSP1_UART2_APPS_CLK_SRC		21
+#define BLSP1_UART3_APPS_CLK_SRC		22
+#define BLSP1_UART4_APPS_CLK_SRC		23
+#define BLSP1_UART5_APPS_CLK_SRC		24
+#define BLSP1_UART6_APPS_CLK_SRC		25
+#define BLSP2_QUP1_I2C_APPS_CLK_SRC		26
+#define BLSP2_QUP1_SPI_APPS_CLK_SRC		27
+#define BLSP2_QUP2_I2C_APPS_CLK_SRC		28
+#define BLSP2_QUP2_SPI_APPS_CLK_SRC		29
+#define BLSP2_QUP3_I2C_APPS_CLK_SRC		30
+#define BLSP2_QUP3_SPI_APPS_CLK_SRC		31
+#define BLSP2_QUP4_I2C_APPS_CLK_SRC		32
+#define BLSP2_QUP4_SPI_APPS_CLK_SRC		33
+#define BLSP2_QUP5_I2C_APPS_CLK_SRC		34
+#define BLSP2_QUP5_SPI_APPS_CLK_SRC		35
+#define BLSP2_QUP6_I2C_APPS_CLK_SRC		36
+#define BLSP2_QUP6_SPI_APPS_CLK_SRC		37
+#define BLSP2_UART1_APPS_CLK_SRC		38
+#define BLSP2_UART2_APPS_CLK_SRC		39
+#define BLSP2_UART3_APPS_CLK_SRC		40
+#define BLSP2_UART4_APPS_CLK_SRC		41
+#define BLSP2_UART5_APPS_CLK_SRC		42
+#define BLSP2_UART6_APPS_CLK_SRC		43
+#define CE1_CLK_SRC				44
+#define CE2_CLK_SRC				45
+#define GP1_CLK_SRC				46
+#define GP2_CLK_SRC				47
+#define GP3_CLK_SRC				48
+#define PDM2_CLK_SRC				49
+#define SDCC1_APPS_CLK_SRC			50
+#define SDCC2_APPS_CLK_SRC			51
+#define SDCC3_APPS_CLK_SRC			52
+#define SDCC4_APPS_CLK_SRC			53
+#define TSIF_REF_CLK_SRC			54
+#define USB30_MOCK_UTMI_CLK_SRC			55
+#define USB_HS_SYSTEM_CLK_SRC			56
+#define USB_HSIC_CLK_SRC			57
+#define USB_HSIC_IO_CAL_CLK_SRC			58
+#define USB_HSIC_SYSTEM_CLK_SRC			59
+#define GCC_BAM_DMA_AHB_CLK			60
+#define GCC_BLSP1_AHB_CLK			61
+#define GCC_BLSP1_QUP1_I2C_APPS_CLK		62
+#define GCC_BLSP1_QUP1_SPI_APPS_CLK		63
+#define GCC_BLSP1_QUP2_I2C_APPS_CLK		64
+#define GCC_BLSP1_QUP2_SPI_APPS_CLK		65
+#define GCC_BLSP1_QUP3_I2C_APPS_CLK		66
+#define GCC_BLSP1_QUP3_SPI_APPS_CLK		67
+#define GCC_BLSP1_QUP4_I2C_APPS_CLK		68
+#define GCC_BLSP1_QUP4_SPI_APPS_CLK		69
+#define GCC_BLSP1_QUP5_I2C_APPS_CLK		70
+#define GCC_BLSP1_QUP5_SPI_APPS_CLK		71
+#define GCC_BLSP1_QUP6_I2C_APPS_CLK		72
+#define GCC_BLSP1_QUP6_SPI_APPS_CLK		73
+#define GCC_BLSP1_UART1_APPS_CLK		74
+#define GCC_BLSP1_UART1_SIM_CLK			75
+#define GCC_BLSP1_UART2_APPS_CLK		76
+#define GCC_BLSP1_UART2_SIM_CLK			77
+#define GCC_BLSP1_UART3_APPS_CLK		78
+#define GCC_BLSP1_UART3_SIM_CLK			79
+#define GCC_BLSP1_UART4_APPS_CLK		80
+#define GCC_BLSP1_UART4_SIM_CLK			81
+#define GCC_BLSP1_UART5_APPS_CLK		82
+#define GCC_BLSP1_UART5_SIM_CLK			83
+#define GCC_BLSP1_UART6_APPS_CLK		84
+#define GCC_BLSP1_UART6_SIM_CLK			85
+#define GCC_BLSP2_AHB_CLK			86
+#define GCC_BLSP2_QUP1_I2C_APPS_CLK		87
+#define GCC_BLSP2_QUP1_SPI_APPS_CLK		88
+#define GCC_BLSP2_QUP2_I2C_APPS_CLK		89
+#define GCC_BLSP2_QUP2_SPI_APPS_CLK		90
+#define GCC_BLSP2_QUP3_I2C_APPS_CLK		91
+#define GCC_BLSP2_QUP3_SPI_APPS_CLK		92
+#define GCC_BLSP2_QUP4_I2C_APPS_CLK		93
+#define GCC_BLSP2_QUP4_SPI_APPS_CLK		94
+#define GCC_BLSP2_QUP5_I2C_APPS_CLK		95
+#define GCC_BLSP2_QUP5_SPI_APPS_CLK		96
+#define GCC_BLSP2_QUP6_I2C_APPS_CLK		97
+#define GCC_BLSP2_QUP6_SPI_APPS_CLK		98
+#define GCC_BLSP2_UART1_APPS_CLK		99
+#define GCC_BLSP2_UART2_APPS_CLK		100
+#define GCC_BLSP2_UART3_APPS_CLK		101
+#define GCC_BLSP2_UART4_APPS_CLK		102
+#define GCC_BLSP2_UART5_APPS_CLK		103
+#define GCC_BLSP2_UART6_APPS_CLK		104
+#define GCC_BOOT_ROM_AHB_CLK			105
+#define GCC_CE1_AHB_CLK				106
+#define GCC_CE1_AXI_CLK				107
+#define GCC_CE1_CLK				108
+#define GCC_CE2_AHB_CLK				109
+#define GCC_CE2_AXI_CLK				110
+#define GCC_CE2_CLK				111
+#define GCC_XO_CLK				112
+#define GCC_XO_DIV4_CLK				113
+#define GCC_GP1_CLK				114
+#define GCC_GP2_CLK				115
+#define GCC_GP3_CLK				116
+#define GCC_MSS_Q6_BIMC_AXI_CLK			117
+#define GCC_PDM2_CLK				118
+#define GCC_PRNG_AHB_CLK			119
+#define GCC_SDCC1_APPS_CLK			120
+#define GCC_SDCC2_APPS_CLK			121
+#define GCC_SDCC3_APPS_CLK			122
+#define GCC_SDCC4_APPS_CLK			123
+#define GCC_SYS_NOC_USB3_AXI_CLK		124
+#define GCC_TSIF_REF_CLK			125
+#define GCC_USB2A_PHY_SLEEP_CLK			126
+#define GCC_USB2B_PHY_SLEEP_CLK			127
+#define GCC_USB30_MASTER_CLK			128
+#define GCC_USB30_MOCK_UTMI_CLK			129
+#define GCC_USB30_SLEEP_CLK			130
+#define GCC_USB_HS_SYSTEM_CLK			131
+#define GCC_USB_HSIC_CLK			132
+#define GCC_USB_HSIC_IO_CAL_CLK			133
+#define GCC_USB_HSIC_IO_CAL_SLEEP_CLK		134
+#define GCC_USB_HSIC_SYSTEM_CLK			135
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

