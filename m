Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaAOStJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:49:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49426 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaAOSrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:47:46 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH v5 10/14] clk: qcom: Add support for MSM8974's global clock controller (GCC)
Date: Wed, 15 Jan 2014 10:47:30 -0800
Message-Id: <1389811654-21397-11-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
References: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the global clock controller found on MSM 8974
based platforms. This should allow most non-multimedia device
drivers to probe and control their clocks.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Kconfig                     |    8 +
 drivers/clk/qcom/Makefile                    |    1 +
 drivers/clk/qcom/gcc-msm8974.c               | 2694 ++++++++++++++++++++++++++
 include/dt-bindings/clock/qcom,gcc-msm8974.h |  320 +++
 include/dt-bindings/reset/qcom,gcc-msm8974.h |   96 +
 5 files changed, 3119 insertions(+)
 create mode 100644 drivers/clk/qcom/gcc-msm8974.c
 create mode 100644 include/dt-bindings/clock/qcom,gcc-msm8974.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-msm8974.h

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 715269381cca..7a1325119637 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -20,3 +20,11 @@ config MSM_MMCC_8960
 	  Support for the multimedia clock controller on msm8960 devices.
 	  Say Y if you want to support multimedia devices such as display,
 	  graphics, video encode/decode, camera, etc.
+
+config MSM_GCC_8974
+	tristate "MSM8974 Global Clock Controller"
+	depends on COMMON_CLK_QCOM
+	help
+	  Support for the global clock controller on msm8974 devices.
+	  Say Y if you want to use peripheral devices such as UART, SPI,
+	  i2c, USB, SD/eMMC, SATA, PCIe, etc.
diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index 52efa954ed3e..10883e6306de 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -8,4 +8,5 @@ clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-branch.o
 clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += reset.o
 
 obj-$(CONFIG_MSM_GCC_8960) += gcc-msm8960.o
+obj-$(CONFIG_MSM_GCC_8974) += gcc-msm8974.o
 obj-$(CONFIG_MSM_MMCC_8960) += mmcc-msm8960.o
diff --git a/drivers/clk/qcom/gcc-msm8974.c b/drivers/clk/qcom/gcc-msm8974.c
new file mode 100644
index 000000000000..51d457e2b959
--- /dev/null
+++ b/drivers/clk/qcom/gcc-msm8974.c
@@ -0,0 +1,2694 @@
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
+#include <dt-bindings/clock/qcom,gcc-msm8974.h>
+#include <dt-bindings/reset/qcom,gcc-msm8974.h>
+
+#include "clk-regmap.h"
+#include "clk-pll.h"
+#include "clk-rcg.h"
+#include "clk-branch.h"
+#include "reset.h"
+
+#define P_XO	0
+#define P_GPLL0	1
+#define P_GPLL1	1
+
+static const u8 gcc_xo_gpll0_map[] = {
+	[P_XO]		= 0,
+	[P_GPLL0]	= 1,
+};
+
+static const char *gcc_xo_gpll0[] = {
+	"xo",
+	"gpll0_vote",
+};
+
+#define F(f, s, h, m, n) { (f), (s), (2 * (h) - 1), (m), (n) }
+
+static struct clk_pll gpll0 = {
+	.l_reg = 0x0004,
+	.m_reg = 0x0008,
+	.n_reg = 0x000c,
+	.config_reg = 0x0014,
+	.mode_reg = 0x0000,
+	.status_reg = 0x001c,
+	.status_bit = 17,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "gpll0",
+		.parent_names = (const char *[]){ "xo" },
+		.num_parents = 1,
+		.ops = &clk_pll_ops,
+	},
+};
+
+static struct clk_regmap gpll0_vote = {
+	.enable_reg = 0x1480,
+	.enable_mask = BIT(0),
+	.hw.init = &(struct clk_init_data){
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
+	.parent_map = gcc_xo_gpll0_map,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "config_noc_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 periph_noc_clk_src = {
+	.cmd_rcgr = 0x0190,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "periph_noc_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 system_noc_clk_src = {
+	.cmd_rcgr = 0x0120,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "system_noc_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_pll gpll1 = {
+	.l_reg = 0x0044,
+	.m_reg = 0x0048,
+	.n_reg = 0x004c,
+	.config_reg = 0x0054,
+	.mode_reg = 0x0040,
+	.status_reg = 0x005c,
+	.status_bit = 17,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "gpll1",
+		.parent_names = (const char *[]){ "xo" },
+		.num_parents = 1,
+		.ops = &clk_pll_ops,
+	},
+};
+
+static struct clk_regmap gpll1_vote = {
+	.enable_reg = 0x1480,
+	.enable_mask = BIT(1),
+	.hw.init = &(struct clk_init_data){
+		.name = "gpll1_vote",
+		.parent_names = (const char *[]){ "gpll1" },
+		.num_parents = 1,
+		.ops = &clk_pll_vote_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_usb30_master_clk[] = {
+	F(125000000, P_GPLL0, 1, 5, 24),
+	{ }
+};
+
+static struct clk_rcg2 usb30_master_clk_src = {
+	.cmd_rcgr = 0x03d4,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_usb30_master_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "usb30_master_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk[] = {
+	F(19200000, P_XO, 1, 0, 0),
+	F(37500000, P_GPLL0, 16, 0, 0),
+	F(50000000, P_GPLL0, 12, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 blsp1_qup1_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0660,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup1_i2c_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk[] = {
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
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup1_spi_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup2_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x06e0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup2_i2c_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup2_spi_apps_clk_src = {
+	.cmd_rcgr = 0x06cc,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup2_spi_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup3_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0760,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup3_i2c_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup3_spi_apps_clk_src = {
+	.cmd_rcgr = 0x074c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup3_spi_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup4_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x07e0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup4_i2c_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup4_spi_apps_clk_src = {
+	.cmd_rcgr = 0x07cc,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup4_spi_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup5_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0860,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup5_i2c_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup5_spi_apps_clk_src = {
+	.cmd_rcgr = 0x084c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup5_spi_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup6_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x08e0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup6_i2c_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_qup6_spi_apps_clk_src = {
+	.cmd_rcgr = 0x08cc,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_qup6_spi_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_blsp1_2_uart1_6_apps_clk[] = {
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
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_uart1_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_uart2_apps_clk_src = {
+	.cmd_rcgr = 0x070c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_uart2_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_uart3_apps_clk_src = {
+	.cmd_rcgr = 0x078c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_uart3_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_uart4_apps_clk_src = {
+	.cmd_rcgr = 0x080c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_uart4_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_uart5_apps_clk_src = {
+	.cmd_rcgr = 0x088c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_uart5_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp1_uart6_apps_clk_src = {
+	.cmd_rcgr = 0x090c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp1_uart6_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup1_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x09a0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup1_i2c_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup1_spi_apps_clk_src = {
+	.cmd_rcgr = 0x098c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup1_spi_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup2_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0a20,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup2_i2c_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup2_spi_apps_clk_src = {
+	.cmd_rcgr = 0x0a0c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup2_spi_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup3_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0aa0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup3_i2c_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup3_spi_apps_clk_src = {
+	.cmd_rcgr = 0x0a8c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup3_spi_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup4_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0b20,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup4_i2c_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup4_spi_apps_clk_src = {
+	.cmd_rcgr = 0x0b0c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup4_spi_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup5_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0ba0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup5_i2c_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup5_spi_apps_clk_src = {
+	.cmd_rcgr = 0x0b8c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup5_spi_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup6_i2c_apps_clk_src = {
+	.cmd_rcgr = 0x0c20,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_i2c_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup6_i2c_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_qup6_spi_apps_clk_src = {
+	.cmd_rcgr = 0x0c0c,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_qup1_6_spi_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_qup6_spi_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_uart1_apps_clk_src = {
+	.cmd_rcgr = 0x09cc,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_uart1_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_uart2_apps_clk_src = {
+	.cmd_rcgr = 0x0a4c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_uart2_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_uart3_apps_clk_src = {
+	.cmd_rcgr = 0x0acc,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_uart3_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_uart4_apps_clk_src = {
+	.cmd_rcgr = 0x0b4c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_uart4_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_uart5_apps_clk_src = {
+	.cmd_rcgr = 0x0bcc,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_uart5_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 blsp2_uart6_apps_clk_src = {
+	.cmd_rcgr = 0x0c4c,
+	.mnd_width = 16,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "blsp2_uart6_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_ce1_clk[] = {
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
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_ce1_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "ce1_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_ce2_clk[] = {
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
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_ce2_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "ce2_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_gp_clk[] = {
+	F(4800000, P_XO, 4, 0, 0),
+	F(6000000, P_GPLL0, 10, 1, 10),
+	F(6750000, P_GPLL0, 1, 1, 89),
+	F(8000000, P_GPLL0, 15, 1, 5),
+	F(9600000, P_XO, 2, 0, 0),
+	F(16000000, P_GPLL0, 1, 2, 75),
+	F(19200000, P_XO, 1, 0, 0),
+	F(24000000, P_GPLL0, 5, 1, 5),
+	{ }
+};
+
+
+static struct clk_rcg2 gp1_clk_src = {
+	.cmd_rcgr = 0x1904,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_gp_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "gp1_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 gp2_clk_src = {
+	.cmd_rcgr = 0x1944,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_gp_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "gp2_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 gp3_clk_src = {
+	.cmd_rcgr = 0x1984,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_gp_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "gp3_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_pdm2_clk[] = {
+	F(60000000, P_GPLL0, 10, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 pdm2_clk_src = {
+	.cmd_rcgr = 0x0cd0,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_pdm2_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "pdm2_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_sdcc1_4_apps_clk[] = {
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
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_sdcc1_4_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "sdcc1_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 sdcc2_apps_clk_src = {
+	.cmd_rcgr = 0x0510,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_sdcc1_4_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "sdcc2_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 sdcc3_apps_clk_src = {
+	.cmd_rcgr = 0x0550,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_sdcc1_4_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "sdcc3_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_rcg2 sdcc4_apps_clk_src = {
+	.cmd_rcgr = 0x0590,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_sdcc1_4_apps_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "sdcc4_apps_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_tsif_ref_clk[] = {
+	F(105000, P_XO, 2, 1, 91),
+	{ }
+};
+
+static struct clk_rcg2 tsif_ref_clk_src = {
+	.cmd_rcgr = 0x0d90,
+	.mnd_width = 8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_tsif_ref_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "tsif_ref_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_usb30_mock_utmi_clk[] = {
+	F(60000000, P_GPLL0, 10, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 usb30_mock_utmi_clk_src = {
+	.cmd_rcgr = 0x03e8,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_usb30_mock_utmi_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "usb30_mock_utmi_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_usb_hs_system_clk[] = {
+	F(60000000, P_GPLL0, 10, 0, 0),
+	F(75000000, P_GPLL0, 8, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 usb_hs_system_clk_src = {
+	.cmd_rcgr = 0x0490,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_usb_hs_system_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "usb_hs_system_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_usb_hsic_clk[] = {
+	F(480000000, P_GPLL1, 1, 0, 0),
+	{ }
+};
+
+static u8 usb_hsic_clk_src_map[] = {
+	[P_XO]		= 0,
+	[P_GPLL1]	= 4,
+};
+
+static struct clk_rcg2 usb_hsic_clk_src = {
+	.cmd_rcgr = 0x0440,
+	.hid_width = 5,
+	.parent_map = usb_hsic_clk_src_map,
+	.freq_tbl = ftbl_gcc_usb_hsic_clk,
+	.clkr.hw.init = &(struct clk_init_data){
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
+static const struct freq_tbl ftbl_gcc_usb_hsic_io_cal_clk[] = {
+	F(9600000, P_XO, 2, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 usb_hsic_io_cal_clk_src = {
+	.cmd_rcgr = 0x0458,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_usb_hsic_io_cal_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "usb_hsic_io_cal_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 1,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static const struct freq_tbl ftbl_gcc_usb_hsic_system_clk[] = {
+	F(60000000, P_GPLL0, 10, 0, 0),
+	F(75000000, P_GPLL0, 8, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 usb_hsic_system_clk_src = {
+	.cmd_rcgr = 0x041c,
+	.hid_width = 5,
+	.parent_map = gcc_xo_gpll0_map,
+	.freq_tbl = ftbl_gcc_usb_hsic_system_clk,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "usb_hsic_system_clk_src",
+		.parent_names = gcc_xo_gpll0,
+		.num_parents = 2,
+		.ops = &clk_rcg2_ops,
+	},
+};
+
+static struct clk_regmap gcc_mmss_gpll0_clk_src = {
+	.enable_reg = 0x1484,
+	.enable_mask = BIT(26),
+	.hw.init = &(struct clk_init_data){
+		.name = "mmss_gpll0_vote",
+		.parent_names = (const char *[]){
+			"gpll0_vote",
+		},
+		.num_parents = 1,
+		.ops = &clk_branch_simple_ops,
+	},
+};
+
+static struct clk_branch gcc_bam_dma_ahb_clk = {
+	.halt_reg = 0x0d44,
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(12),
+		.hw.init = &(struct clk_init_data){
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
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(17),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0648,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0644,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x06c8,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x06c4,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0748,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0744,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x07c8,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x07c4,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0848,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0844,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x08c8,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x08c4,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0684,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0704,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0784,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0804,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0884,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0904,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(15),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0988,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0984,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0a08,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0a04,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0a88,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0a84,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0b08,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0b04,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0b88,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0b84,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0c08,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0c04,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x09c4,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0a44,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0ac4,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0b44,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0bc4,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0c44,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(10),
+		.hw.init = &(struct clk_init_data){
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
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(3),
+		.hw.init = &(struct clk_init_data){
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
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
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
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(5),
+		.hw.init = &(struct clk_init_data){
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
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(1),
+		.hw.init = &(struct clk_init_data){
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
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(2),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_ce2_clk",
+			.parent_names = (const char *[]){
+				"ce2_clk_src",
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_gp1_clk = {
+	.halt_reg = 0x1900,
+	.clkr = {
+		.enable_reg = 0x1900,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x1940,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x1980,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+static struct clk_branch gcc_lpass_q6_axi_clk = {
+	.halt_reg = 0x11c0,
+	.clkr = {
+		.enable_reg = 0x11c0,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_lpass_q6_axi_clk",
+			.parent_names = (const char *[]){
+				"system_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_mmss_noc_cfg_ahb_clk = {
+	.halt_reg = 0x024c,
+	.clkr = {
+		.enable_reg = 0x024c,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_mmss_noc_cfg_ahb_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+			.flags = CLK_IGNORE_UNUSED,
+		},
+	},
+};
+
+static struct clk_branch gcc_ocmem_noc_cfg_ahb_clk = {
+	.halt_reg = 0x0248,
+	.clkr = {
+		.enable_reg = 0x0248,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_ocmem_noc_cfg_ahb_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_mss_cfg_ahb_clk = {
+	.halt_reg = 0x0280,
+	.clkr = {
+		.enable_reg = 0x0280,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_mss_cfg_ahb_clk",
+			.parent_names = (const char *[]){
+				"config_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_mss_q6_bimc_axi_clk = {
+	.halt_reg = 0x0284,
+	.clkr = {
+		.enable_reg = 0x0284,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_mss_q6_bimc_axi_clk",
+			.flags = CLK_IS_ROOT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_pdm2_clk = {
+	.halt_reg = 0x0ccc,
+	.clkr = {
+		.enable_reg = 0x0ccc,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+static struct clk_branch gcc_pdm_ahb_clk = {
+	.halt_reg = 0x0cc4,
+	.clkr = {
+		.enable_reg = 0x0cc4,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_pdm_ahb_clk",
+			.parent_names = (const char *[]){
+				"periph_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_prng_ahb_clk = {
+	.halt_reg = 0x0d04,
+	.halt_check = BRANCH_HALT_VOTED,
+	.clkr = {
+		.enable_reg = 0x1484,
+		.enable_mask = BIT(13),
+		.hw.init = &(struct clk_init_data){
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
+static struct clk_branch gcc_sdcc1_ahb_clk = {
+	.halt_reg = 0x04c8,
+	.clkr = {
+		.enable_reg = 0x04c8,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_sdcc1_ahb_clk",
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
+	.clkr = {
+		.enable_reg = 0x04c4,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+static struct clk_branch gcc_sdcc2_ahb_clk = {
+	.halt_reg = 0x0508,
+	.clkr = {
+		.enable_reg = 0x0508,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_sdcc2_ahb_clk",
+			.parent_names = (const char *[]){
+				"periph_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sdcc2_apps_clk = {
+	.halt_reg = 0x0504,
+	.clkr = {
+		.enable_reg = 0x0504,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+static struct clk_branch gcc_sdcc3_ahb_clk = {
+	.halt_reg = 0x0548,
+	.clkr = {
+		.enable_reg = 0x0548,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_sdcc3_ahb_clk",
+			.parent_names = (const char *[]){
+				"periph_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sdcc3_apps_clk = {
+	.halt_reg = 0x0544,
+	.clkr = {
+		.enable_reg = 0x0544,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+static struct clk_branch gcc_sdcc4_ahb_clk = {
+	.halt_reg = 0x0588,
+	.clkr = {
+		.enable_reg = 0x0588,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_sdcc4_ahb_clk",
+			.parent_names = (const char *[]){
+				"periph_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_sdcc4_apps_clk = {
+	.halt_reg = 0x0584,
+	.clkr = {
+		.enable_reg = 0x0584,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0108,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+static struct clk_branch gcc_tsif_ahb_clk = {
+	.halt_reg = 0x0d84,
+	.clkr = {
+		.enable_reg = 0x0d84,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_tsif_ahb_clk",
+			.parent_names = (const char *[]){
+				"periph_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_tsif_ref_clk = {
+	.halt_reg = 0x0d88,
+	.clkr = {
+		.enable_reg = 0x0d88,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x04ac,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_usb2a_phy_sleep_clk",
+			.parent_names = (const char *[]){
+				"sleep_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb2b_phy_sleep_clk = {
+	.halt_reg = 0x04b4,
+	.clkr = {
+		.enable_reg = 0x04b4,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_usb2b_phy_sleep_clk",
+			.parent_names = (const char *[]){
+				"sleep_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb30_master_clk = {
+	.halt_reg = 0x03c8,
+	.clkr = {
+		.enable_reg = 0x03c8,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x03d0,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x03cc,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_usb30_sleep_clk",
+			.parent_names = (const char *[]){
+				"sleep_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb_hs_ahb_clk = {
+	.halt_reg = 0x0488,
+	.clkr = {
+		.enable_reg = 0x0488,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_usb_hs_ahb_clk",
+			.parent_names = (const char *[]){
+				"periph_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb_hs_system_clk = {
+	.halt_reg = 0x0484,
+	.clkr = {
+		.enable_reg = 0x0484,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+static struct clk_branch gcc_usb_hsic_ahb_clk = {
+	.halt_reg = 0x0408,
+	.clkr = {
+		.enable_reg = 0x0408,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_usb_hsic_ahb_clk",
+			.parent_names = (const char *[]){
+				"periph_noc_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb_hsic_clk = {
+	.halt_reg = 0x0410,
+	.clkr = {
+		.enable_reg = 0x0410,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0414,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+	.clkr = {
+		.enable_reg = 0x0418,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
+			.name = "gcc_usb_hsic_io_cal_sleep_clk",
+			.parent_names = (const char *[]){
+				"sleep_clk_src",
+			},
+			.num_parents = 1,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch gcc_usb_hsic_system_clk = {
+	.halt_reg = 0x040c,
+	.clkr = {
+		.enable_reg = 0x040c,
+		.enable_mask = BIT(0),
+		.hw.init = &(struct clk_init_data){
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
+static struct clk_regmap *gcc_msm8974_clocks[] = {
+	[GPLL0] = &gpll0.clkr,
+	[GPLL0_VOTE] = &gpll0_vote,
+	[CONFIG_NOC_CLK_SRC] = &config_noc_clk_src.clkr,
+	[PERIPH_NOC_CLK_SRC] = &periph_noc_clk_src.clkr,
+	[SYSTEM_NOC_CLK_SRC] = &system_noc_clk_src.clkr,
+	[GPLL1] = &gpll1.clkr,
+	[GPLL1_VOTE] = &gpll1_vote,
+	[USB30_MASTER_CLK_SRC] = &usb30_master_clk_src.clkr,
+	[BLSP1_QUP1_I2C_APPS_CLK_SRC] = &blsp1_qup1_i2c_apps_clk_src.clkr,
+	[BLSP1_QUP1_SPI_APPS_CLK_SRC] = &blsp1_qup1_spi_apps_clk_src.clkr,
+	[BLSP1_QUP2_I2C_APPS_CLK_SRC] = &blsp1_qup2_i2c_apps_clk_src.clkr,
+	[BLSP1_QUP2_SPI_APPS_CLK_SRC] = &blsp1_qup2_spi_apps_clk_src.clkr,
+	[BLSP1_QUP3_I2C_APPS_CLK_SRC] = &blsp1_qup3_i2c_apps_clk_src.clkr,
+	[BLSP1_QUP3_SPI_APPS_CLK_SRC] = &blsp1_qup3_spi_apps_clk_src.clkr,
+	[BLSP1_QUP4_I2C_APPS_CLK_SRC] = &blsp1_qup4_i2c_apps_clk_src.clkr,
+	[BLSP1_QUP4_SPI_APPS_CLK_SRC] = &blsp1_qup4_spi_apps_clk_src.clkr,
+	[BLSP1_QUP5_I2C_APPS_CLK_SRC] = &blsp1_qup5_i2c_apps_clk_src.clkr,
+	[BLSP1_QUP5_SPI_APPS_CLK_SRC] = &blsp1_qup5_spi_apps_clk_src.clkr,
+	[BLSP1_QUP6_I2C_APPS_CLK_SRC] = &blsp1_qup6_i2c_apps_clk_src.clkr,
+	[BLSP1_QUP6_SPI_APPS_CLK_SRC] = &blsp1_qup6_spi_apps_clk_src.clkr,
+	[BLSP1_UART1_APPS_CLK_SRC] = &blsp1_uart1_apps_clk_src.clkr,
+	[BLSP1_UART2_APPS_CLK_SRC] = &blsp1_uart2_apps_clk_src.clkr,
+	[BLSP1_UART3_APPS_CLK_SRC] = &blsp1_uart3_apps_clk_src.clkr,
+	[BLSP1_UART4_APPS_CLK_SRC] = &blsp1_uart4_apps_clk_src.clkr,
+	[BLSP1_UART5_APPS_CLK_SRC] = &blsp1_uart5_apps_clk_src.clkr,
+	[BLSP1_UART6_APPS_CLK_SRC] = &blsp1_uart6_apps_clk_src.clkr,
+	[BLSP2_QUP1_I2C_APPS_CLK_SRC] = &blsp2_qup1_i2c_apps_clk_src.clkr,
+	[BLSP2_QUP1_SPI_APPS_CLK_SRC] = &blsp2_qup1_spi_apps_clk_src.clkr,
+	[BLSP2_QUP2_I2C_APPS_CLK_SRC] = &blsp2_qup2_i2c_apps_clk_src.clkr,
+	[BLSP2_QUP2_SPI_APPS_CLK_SRC] = &blsp2_qup2_spi_apps_clk_src.clkr,
+	[BLSP2_QUP3_I2C_APPS_CLK_SRC] = &blsp2_qup3_i2c_apps_clk_src.clkr,
+	[BLSP2_QUP3_SPI_APPS_CLK_SRC] = &blsp2_qup3_spi_apps_clk_src.clkr,
+	[BLSP2_QUP4_I2C_APPS_CLK_SRC] = &blsp2_qup4_i2c_apps_clk_src.clkr,
+	[BLSP2_QUP4_SPI_APPS_CLK_SRC] = &blsp2_qup4_spi_apps_clk_src.clkr,
+	[BLSP2_QUP5_I2C_APPS_CLK_SRC] = &blsp2_qup5_i2c_apps_clk_src.clkr,
+	[BLSP2_QUP5_SPI_APPS_CLK_SRC] = &blsp2_qup5_spi_apps_clk_src.clkr,
+	[BLSP2_QUP6_I2C_APPS_CLK_SRC] = &blsp2_qup6_i2c_apps_clk_src.clkr,
+	[BLSP2_QUP6_SPI_APPS_CLK_SRC] = &blsp2_qup6_spi_apps_clk_src.clkr,
+	[BLSP2_UART1_APPS_CLK_SRC] = &blsp2_uart1_apps_clk_src.clkr,
+	[BLSP2_UART2_APPS_CLK_SRC] = &blsp2_uart2_apps_clk_src.clkr,
+	[BLSP2_UART3_APPS_CLK_SRC] = &blsp2_uart3_apps_clk_src.clkr,
+	[BLSP2_UART4_APPS_CLK_SRC] = &blsp2_uart4_apps_clk_src.clkr,
+	[BLSP2_UART5_APPS_CLK_SRC] = &blsp2_uart5_apps_clk_src.clkr,
+	[BLSP2_UART6_APPS_CLK_SRC] = &blsp2_uart6_apps_clk_src.clkr,
+	[CE1_CLK_SRC] = &ce1_clk_src.clkr,
+	[CE2_CLK_SRC] = &ce2_clk_src.clkr,
+	[GP1_CLK_SRC] = &gp1_clk_src.clkr,
+	[GP2_CLK_SRC] = &gp2_clk_src.clkr,
+	[GP3_CLK_SRC] = &gp3_clk_src.clkr,
+	[PDM2_CLK_SRC] = &pdm2_clk_src.clkr,
+	[SDCC1_APPS_CLK_SRC] = &sdcc1_apps_clk_src.clkr,
+	[SDCC2_APPS_CLK_SRC] = &sdcc2_apps_clk_src.clkr,
+	[SDCC3_APPS_CLK_SRC] = &sdcc3_apps_clk_src.clkr,
+	[SDCC4_APPS_CLK_SRC] = &sdcc4_apps_clk_src.clkr,
+	[TSIF_REF_CLK_SRC] = &tsif_ref_clk_src.clkr,
+	[USB30_MOCK_UTMI_CLK_SRC] = &usb30_mock_utmi_clk_src.clkr,
+	[USB_HS_SYSTEM_CLK_SRC] = &usb_hs_system_clk_src.clkr,
+	[USB_HSIC_CLK_SRC] = &usb_hsic_clk_src.clkr,
+	[USB_HSIC_IO_CAL_CLK_SRC] = &usb_hsic_io_cal_clk_src.clkr,
+	[USB_HSIC_SYSTEM_CLK_SRC] = &usb_hsic_system_clk_src.clkr,
+	[GCC_BAM_DMA_AHB_CLK] = &gcc_bam_dma_ahb_clk.clkr,
+	[GCC_BLSP1_AHB_CLK] = &gcc_blsp1_ahb_clk.clkr,
+	[GCC_BLSP1_QUP1_I2C_APPS_CLK] = &gcc_blsp1_qup1_i2c_apps_clk.clkr,
+	[GCC_BLSP1_QUP1_SPI_APPS_CLK] = &gcc_blsp1_qup1_spi_apps_clk.clkr,
+	[GCC_BLSP1_QUP2_I2C_APPS_CLK] = &gcc_blsp1_qup2_i2c_apps_clk.clkr,
+	[GCC_BLSP1_QUP2_SPI_APPS_CLK] = &gcc_blsp1_qup2_spi_apps_clk.clkr,
+	[GCC_BLSP1_QUP3_I2C_APPS_CLK] = &gcc_blsp1_qup3_i2c_apps_clk.clkr,
+	[GCC_BLSP1_QUP3_SPI_APPS_CLK] = &gcc_blsp1_qup3_spi_apps_clk.clkr,
+	[GCC_BLSP1_QUP4_I2C_APPS_CLK] = &gcc_blsp1_qup4_i2c_apps_clk.clkr,
+	[GCC_BLSP1_QUP4_SPI_APPS_CLK] = &gcc_blsp1_qup4_spi_apps_clk.clkr,
+	[GCC_BLSP1_QUP5_I2C_APPS_CLK] = &gcc_blsp1_qup5_i2c_apps_clk.clkr,
+	[GCC_BLSP1_QUP5_SPI_APPS_CLK] = &gcc_blsp1_qup5_spi_apps_clk.clkr,
+	[GCC_BLSP1_QUP6_I2C_APPS_CLK] = &gcc_blsp1_qup6_i2c_apps_clk.clkr,
+	[GCC_BLSP1_QUP6_SPI_APPS_CLK] = &gcc_blsp1_qup6_spi_apps_clk.clkr,
+	[GCC_BLSP1_UART1_APPS_CLK] = &gcc_blsp1_uart1_apps_clk.clkr,
+	[GCC_BLSP1_UART2_APPS_CLK] = &gcc_blsp1_uart2_apps_clk.clkr,
+	[GCC_BLSP1_UART3_APPS_CLK] = &gcc_blsp1_uart3_apps_clk.clkr,
+	[GCC_BLSP1_UART4_APPS_CLK] = &gcc_blsp1_uart4_apps_clk.clkr,
+	[GCC_BLSP1_UART5_APPS_CLK] = &gcc_blsp1_uart5_apps_clk.clkr,
+	[GCC_BLSP1_UART6_APPS_CLK] = &gcc_blsp1_uart6_apps_clk.clkr,
+	[GCC_BLSP2_AHB_CLK] = &gcc_blsp2_ahb_clk.clkr,
+	[GCC_BLSP2_QUP1_I2C_APPS_CLK] = &gcc_blsp2_qup1_i2c_apps_clk.clkr,
+	[GCC_BLSP2_QUP1_SPI_APPS_CLK] = &gcc_blsp2_qup1_spi_apps_clk.clkr,
+	[GCC_BLSP2_QUP2_I2C_APPS_CLK] = &gcc_blsp2_qup2_i2c_apps_clk.clkr,
+	[GCC_BLSP2_QUP2_SPI_APPS_CLK] = &gcc_blsp2_qup2_spi_apps_clk.clkr,
+	[GCC_BLSP2_QUP3_I2C_APPS_CLK] = &gcc_blsp2_qup3_i2c_apps_clk.clkr,
+	[GCC_BLSP2_QUP3_SPI_APPS_CLK] = &gcc_blsp2_qup3_spi_apps_clk.clkr,
+	[GCC_BLSP2_QUP4_I2C_APPS_CLK] = &gcc_blsp2_qup4_i2c_apps_clk.clkr,
+	[GCC_BLSP2_QUP4_SPI_APPS_CLK] = &gcc_blsp2_qup4_spi_apps_clk.clkr,
+	[GCC_BLSP2_QUP5_I2C_APPS_CLK] = &gcc_blsp2_qup5_i2c_apps_clk.clkr,
+	[GCC_BLSP2_QUP5_SPI_APPS_CLK] = &gcc_blsp2_qup5_spi_apps_clk.clkr,
+	[GCC_BLSP2_QUP6_I2C_APPS_CLK] = &gcc_blsp2_qup6_i2c_apps_clk.clkr,
+	[GCC_BLSP2_QUP6_SPI_APPS_CLK] = &gcc_blsp2_qup6_spi_apps_clk.clkr,
+	[GCC_BLSP2_UART1_APPS_CLK] = &gcc_blsp2_uart1_apps_clk.clkr,
+	[GCC_BLSP2_UART2_APPS_CLK] = &gcc_blsp2_uart2_apps_clk.clkr,
+	[GCC_BLSP2_UART3_APPS_CLK] = &gcc_blsp2_uart3_apps_clk.clkr,
+	[GCC_BLSP2_UART4_APPS_CLK] = &gcc_blsp2_uart4_apps_clk.clkr,
+	[GCC_BLSP2_UART5_APPS_CLK] = &gcc_blsp2_uart5_apps_clk.clkr,
+	[GCC_BLSP2_UART6_APPS_CLK] = &gcc_blsp2_uart6_apps_clk.clkr,
+	[GCC_BOOT_ROM_AHB_CLK] = &gcc_boot_rom_ahb_clk.clkr,
+	[GCC_CE1_AHB_CLK] = &gcc_ce1_ahb_clk.clkr,
+	[GCC_CE1_AXI_CLK] = &gcc_ce1_axi_clk.clkr,
+	[GCC_CE1_CLK] = &gcc_ce1_clk.clkr,
+	[GCC_CE2_AHB_CLK] = &gcc_ce2_ahb_clk.clkr,
+	[GCC_CE2_AXI_CLK] = &gcc_ce2_axi_clk.clkr,
+	[GCC_CE2_CLK] = &gcc_ce2_clk.clkr,
+	[GCC_GP1_CLK] = &gcc_gp1_clk.clkr,
+	[GCC_GP2_CLK] = &gcc_gp2_clk.clkr,
+	[GCC_GP3_CLK] = &gcc_gp3_clk.clkr,
+	[GCC_LPASS_Q6_AXI_CLK] = &gcc_lpass_q6_axi_clk.clkr,
+	[GCC_MMSS_NOC_CFG_AHB_CLK] = &gcc_mmss_noc_cfg_ahb_clk.clkr,
+	[GCC_OCMEM_NOC_CFG_AHB_CLK] = &gcc_ocmem_noc_cfg_ahb_clk.clkr,
+	[GCC_MSS_CFG_AHB_CLK] = &gcc_mss_cfg_ahb_clk.clkr,
+	[GCC_MSS_Q6_BIMC_AXI_CLK] = &gcc_mss_q6_bimc_axi_clk.clkr,
+	[GCC_PDM2_CLK] = &gcc_pdm2_clk.clkr,
+	[GCC_PDM_AHB_CLK] = &gcc_pdm_ahb_clk.clkr,
+	[GCC_PRNG_AHB_CLK] = &gcc_prng_ahb_clk.clkr,
+	[GCC_SDCC1_AHB_CLK] = &gcc_sdcc1_ahb_clk.clkr,
+	[GCC_SDCC1_APPS_CLK] = &gcc_sdcc1_apps_clk.clkr,
+	[GCC_SDCC2_AHB_CLK] = &gcc_sdcc2_ahb_clk.clkr,
+	[GCC_SDCC2_APPS_CLK] = &gcc_sdcc2_apps_clk.clkr,
+	[GCC_SDCC3_AHB_CLK] = &gcc_sdcc3_ahb_clk.clkr,
+	[GCC_SDCC3_APPS_CLK] = &gcc_sdcc3_apps_clk.clkr,
+	[GCC_SDCC4_AHB_CLK] = &gcc_sdcc4_ahb_clk.clkr,
+	[GCC_SDCC4_APPS_CLK] = &gcc_sdcc4_apps_clk.clkr,
+	[GCC_SYS_NOC_USB3_AXI_CLK] = &gcc_sys_noc_usb3_axi_clk.clkr,
+	[GCC_TSIF_AHB_CLK] = &gcc_tsif_ahb_clk.clkr,
+	[GCC_TSIF_REF_CLK] = &gcc_tsif_ref_clk.clkr,
+	[GCC_USB2A_PHY_SLEEP_CLK] = &gcc_usb2a_phy_sleep_clk.clkr,
+	[GCC_USB2B_PHY_SLEEP_CLK] = &gcc_usb2b_phy_sleep_clk.clkr,
+	[GCC_USB30_MASTER_CLK] = &gcc_usb30_master_clk.clkr,
+	[GCC_USB30_MOCK_UTMI_CLK] = &gcc_usb30_mock_utmi_clk.clkr,
+	[GCC_USB30_SLEEP_CLK] = &gcc_usb30_sleep_clk.clkr,
+	[GCC_USB_HS_AHB_CLK] = &gcc_usb_hs_ahb_clk.clkr,
+	[GCC_USB_HS_SYSTEM_CLK] = &gcc_usb_hs_system_clk.clkr,
+	[GCC_USB_HSIC_AHB_CLK] = &gcc_usb_hsic_ahb_clk.clkr,
+	[GCC_USB_HSIC_CLK] = &gcc_usb_hsic_clk.clkr,
+	[GCC_USB_HSIC_IO_CAL_CLK] = &gcc_usb_hsic_io_cal_clk.clkr,
+	[GCC_USB_HSIC_IO_CAL_SLEEP_CLK] = &gcc_usb_hsic_io_cal_sleep_clk.clkr,
+	[GCC_USB_HSIC_SYSTEM_CLK] = &gcc_usb_hsic_system_clk.clkr,
+	[GCC_MMSS_GPLL0_CLK_SRC] = &gcc_mmss_gpll0_clk_src,
+};
+
+static const struct qcom_reset_map gcc_msm8974_resets[] = {
+	[GCC_SYSTEM_NOC_BCR] = { 0x0100 },
+	[GCC_CONFIG_NOC_BCR] = { 0x0140 },
+	[GCC_PERIPH_NOC_BCR] = { 0x0180 },
+	[GCC_IMEM_BCR] = { 0x0200 },
+	[GCC_MMSS_BCR] = { 0x0240 },
+	[GCC_QDSS_BCR] = { 0x0300 },
+	[GCC_USB_30_BCR] = { 0x03c0 },
+	[GCC_USB3_PHY_BCR] = { 0x03fc },
+	[GCC_USB_HS_HSIC_BCR] = { 0x0400 },
+	[GCC_USB_HS_BCR] = { 0x0480 },
+	[GCC_USB2A_PHY_BCR] = { 0x04a8 },
+	[GCC_USB2B_PHY_BCR] = { 0x04b0 },
+	[GCC_SDCC1_BCR] = { 0x04c0 },
+	[GCC_SDCC2_BCR] = { 0x0500 },
+	[GCC_SDCC3_BCR] = { 0x0540 },
+	[GCC_SDCC4_BCR] = { 0x0580 },
+	[GCC_BLSP1_BCR] = { 0x05c0 },
+	[GCC_BLSP1_QUP1_BCR] = { 0x0640 },
+	[GCC_BLSP1_UART1_BCR] = { 0x0680 },
+	[GCC_BLSP1_QUP2_BCR] = { 0x06c0 },
+	[GCC_BLSP1_UART2_BCR] = { 0x0700 },
+	[GCC_BLSP1_QUP3_BCR] = { 0x0740 },
+	[GCC_BLSP1_UART3_BCR] = { 0x0780 },
+	[GCC_BLSP1_QUP4_BCR] = { 0x07c0 },
+	[GCC_BLSP1_UART4_BCR] = { 0x0800 },
+	[GCC_BLSP1_QUP5_BCR] = { 0x0840 },
+	[GCC_BLSP1_UART5_BCR] = { 0x0880 },
+	[GCC_BLSP1_QUP6_BCR] = { 0x08c0 },
+	[GCC_BLSP1_UART6_BCR] = { 0x0900 },
+	[GCC_BLSP2_BCR] = { 0x0940 },
+	[GCC_BLSP2_QUP1_BCR] = { 0x0980 },
+	[GCC_BLSP2_UART1_BCR] = { 0x09c0 },
+	[GCC_BLSP2_QUP2_BCR] = { 0x0a00 },
+	[GCC_BLSP2_UART2_BCR] = { 0x0a40 },
+	[GCC_BLSP2_QUP3_BCR] = { 0x0a80 },
+	[GCC_BLSP2_UART3_BCR] = { 0x0ac0 },
+	[GCC_BLSP2_QUP4_BCR] = { 0x0b00 },
+	[GCC_BLSP2_UART4_BCR] = { 0x0b40 },
+	[GCC_BLSP2_QUP5_BCR] = { 0x0b80 },
+	[GCC_BLSP2_UART5_BCR] = { 0x0bc0 },
+	[GCC_BLSP2_QUP6_BCR] = { 0x0c00 },
+	[GCC_BLSP2_UART6_BCR] = { 0x0c40 },
+	[GCC_PDM_BCR] = { 0x0cc0 },
+	[GCC_BAM_DMA_BCR] = { 0x0d40 },
+	[GCC_TSIF_BCR] = { 0x0d80 },
+	[GCC_TCSR_BCR] = { 0x0dc0 },
+	[GCC_BOOT_ROM_BCR] = { 0x0e00 },
+	[GCC_MSG_RAM_BCR] = { 0x0e40 },
+	[GCC_TLMM_BCR] = { 0x0e80 },
+	[GCC_MPM_BCR] = { 0x0ec0 },
+	[GCC_SEC_CTRL_BCR] = { 0x0f40 },
+	[GCC_SPMI_BCR] = { 0x0fc0 },
+	[GCC_SPDM_BCR] = { 0x1000 },
+	[GCC_CE1_BCR] = { 0x1040 },
+	[GCC_CE2_BCR] = { 0x1080 },
+	[GCC_BIMC_BCR] = { 0x1100 },
+	[GCC_MPM_NON_AHB_RESET] = { 0x0ec4, 2 },
+	[GCC_MPM_AHB_RESET] = {	0x0ec4, 1 },
+	[GCC_SNOC_BUS_TIMEOUT0_BCR] = { 0x1240 },
+	[GCC_SNOC_BUS_TIMEOUT2_BCR] = { 0x1248 },
+	[GCC_PNOC_BUS_TIMEOUT0_BCR] = { 0x1280 },
+	[GCC_PNOC_BUS_TIMEOUT1_BCR] = { 0x1288 },
+	[GCC_PNOC_BUS_TIMEOUT2_BCR] = { 0x1290 },
+	[GCC_PNOC_BUS_TIMEOUT3_BCR] = { 0x1298 },
+	[GCC_PNOC_BUS_TIMEOUT4_BCR] = { 0x12a0 },
+	[GCC_CNOC_BUS_TIMEOUT0_BCR] = { 0x12c0 },
+	[GCC_CNOC_BUS_TIMEOUT1_BCR] = { 0x12c8 },
+	[GCC_CNOC_BUS_TIMEOUT2_BCR] = { 0x12d0 },
+	[GCC_CNOC_BUS_TIMEOUT3_BCR] = { 0x12d8 },
+	[GCC_CNOC_BUS_TIMEOUT4_BCR] = { 0x12e0 },
+	[GCC_CNOC_BUS_TIMEOUT5_BCR] = { 0x12e8 },
+	[GCC_CNOC_BUS_TIMEOUT6_BCR] = { 0x12f0 },
+	[GCC_DEHR_BCR] = { 0x1300 },
+	[GCC_RBCPR_BCR] = { 0x1380 },
+	[GCC_MSS_RESTART] = { 0x1680 },
+	[GCC_LPASS_RESTART] = { 0x16c0 },
+	[GCC_WCSS_RESTART] = { 0x1700 },
+	[GCC_VENUS_RESTART] = { 0x1740 },
+};
+
+static const struct regmap_config gcc_msm8974_regmap_config = {
+	.reg_bits	= 32,
+	.reg_stride	= 4,
+	.val_bits	= 32,
+	.max_register	= 0x1fc0,
+	.fast_io	= true,
+};
+
+static const struct of_device_id gcc_msm8974_match_table[] = {
+	{ .compatible = "qcom,gcc-msm8974" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, gcc_msm8974_match_table);
+
+struct qcom_cc {
+	struct qcom_reset_controller reset;
+	struct clk_onecell_data data;
+	struct clk *clks[];
+};
+
+static int gcc_msm8974_probe(struct platform_device *pdev)
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
+	regmap = devm_regmap_init_mmio(dev, base, &gcc_msm8974_regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	num_clks = ARRAY_SIZE(gcc_msm8974_clocks);
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
+	clk = clk_register_fixed_rate(dev, "xo", NULL, CLK_IS_ROOT, 19200000);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	/* Should move to DT node? */
+	clk = clk_register_fixed_rate(dev, "sleep_clk_src", NULL,
+				      CLK_IS_ROOT, 32768);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	for (i = 0; i < num_clks; i++) {
+		if (!gcc_msm8974_clocks[i])
+			continue;
+		clk = devm_clk_register_regmap(dev, gcc_msm8974_clocks[i]);
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
+	reset->rcdev.nr_resets = ARRAY_SIZE(gcc_msm8974_resets),
+	reset->regmap = regmap;
+	reset->reset_map = gcc_msm8974_resets,
+	platform_set_drvdata(pdev, &reset->rcdev);
+
+	ret = reset_controller_register(&reset->rcdev);
+	if (ret)
+		of_clk_del_provider(dev->of_node);
+
+	return ret;
+}
+
+static int gcc_msm8974_remove(struct platform_device *pdev)
+{
+	of_clk_del_provider(pdev->dev.of_node);
+	reset_controller_unregister(platform_get_drvdata(pdev));
+	return 0;
+}
+
+static struct platform_driver gcc_msm8974_driver = {
+	.probe		= gcc_msm8974_probe,
+	.remove		= gcc_msm8974_remove,
+	.driver		= {
+		.name	= "gcc-msm8974",
+		.owner	= THIS_MODULE,
+		.of_match_table = gcc_msm8974_match_table,
+	},
+};
+
+static int __init gcc_msm8974_init(void)
+{
+	return platform_driver_register(&gcc_msm8974_driver);
+}
+core_initcall(gcc_msm8974_init);
+
+static void __exit gcc_msm8974_exit(void)
+{
+	platform_driver_unregister(&gcc_msm8974_driver);
+}
+module_exit(gcc_msm8974_exit);
+
+MODULE_DESCRIPTION("QCOM GCC MSM8974 Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:gcc-msm8974");
diff --git a/include/dt-bindings/clock/qcom,gcc-msm8974.h b/include/dt-bindings/clock/qcom,gcc-msm8974.h
new file mode 100644
index 000000000000..223ca174d9d3
--- /dev/null
+++ b/include/dt-bindings/clock/qcom,gcc-msm8974.h
@@ -0,0 +1,320 @@
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
+#define GPLL0							0
+#define GPLL0_VOTE						1
+#define CONFIG_NOC_CLK_SRC					2
+#define GPLL2							3
+#define GPLL2_VOTE						4
+#define GPLL3							5
+#define GPLL3_VOTE						6
+#define PERIPH_NOC_CLK_SRC					7
+#define BLSP_UART_SIM_CLK_SRC					8
+#define QDSS_TSCTR_CLK_SRC					9
+#define BIMC_DDR_CLK_SRC					10
+#define SYSTEM_NOC_CLK_SRC					11
+#define GPLL1							12
+#define GPLL1_VOTE						13
+#define RPM_CLK_SRC						14
+#define GCC_BIMC_CLK						15
+#define BIMC_DDR_CPLL0_ROOT_CLK_SRC				16
+#define KPSS_AHB_CLK_SRC					17
+#define QDSS_AT_CLK_SRC						18
+#define USB30_MASTER_CLK_SRC					19
+#define BIMC_DDR_CPLL1_ROOT_CLK_SRC				20
+#define QDSS_STM_CLK_SRC					21
+#define ACC_CLK_SRC						22
+#define SEC_CTRL_CLK_SRC					23
+#define BLSP1_QUP1_I2C_APPS_CLK_SRC				24
+#define BLSP1_QUP1_SPI_APPS_CLK_SRC				25
+#define BLSP1_QUP2_I2C_APPS_CLK_SRC				26
+#define BLSP1_QUP2_SPI_APPS_CLK_SRC				27
+#define BLSP1_QUP3_I2C_APPS_CLK_SRC				28
+#define BLSP1_QUP3_SPI_APPS_CLK_SRC				29
+#define BLSP1_QUP4_I2C_APPS_CLK_SRC				30
+#define BLSP1_QUP4_SPI_APPS_CLK_SRC				31
+#define BLSP1_QUP5_I2C_APPS_CLK_SRC				32
+#define BLSP1_QUP5_SPI_APPS_CLK_SRC				33
+#define BLSP1_QUP6_I2C_APPS_CLK_SRC				34
+#define BLSP1_QUP6_SPI_APPS_CLK_SRC				35
+#define BLSP1_UART1_APPS_CLK_SRC				36
+#define BLSP1_UART2_APPS_CLK_SRC				37
+#define BLSP1_UART3_APPS_CLK_SRC				38
+#define BLSP1_UART4_APPS_CLK_SRC				39
+#define BLSP1_UART5_APPS_CLK_SRC				40
+#define BLSP1_UART6_APPS_CLK_SRC				41
+#define BLSP2_QUP1_I2C_APPS_CLK_SRC				42
+#define BLSP2_QUP1_SPI_APPS_CLK_SRC				43
+#define BLSP2_QUP2_I2C_APPS_CLK_SRC				44
+#define BLSP2_QUP2_SPI_APPS_CLK_SRC				45
+#define BLSP2_QUP3_I2C_APPS_CLK_SRC				46
+#define BLSP2_QUP3_SPI_APPS_CLK_SRC				47
+#define BLSP2_QUP4_I2C_APPS_CLK_SRC				48
+#define BLSP2_QUP4_SPI_APPS_CLK_SRC				49
+#define BLSP2_QUP5_I2C_APPS_CLK_SRC				50
+#define BLSP2_QUP5_SPI_APPS_CLK_SRC				51
+#define BLSP2_QUP6_I2C_APPS_CLK_SRC				52
+#define BLSP2_QUP6_SPI_APPS_CLK_SRC				53
+#define BLSP2_UART1_APPS_CLK_SRC				54
+#define BLSP2_UART2_APPS_CLK_SRC				55
+#define BLSP2_UART3_APPS_CLK_SRC				56
+#define BLSP2_UART4_APPS_CLK_SRC				57
+#define BLSP2_UART5_APPS_CLK_SRC				58
+#define BLSP2_UART6_APPS_CLK_SRC				59
+#define CE1_CLK_SRC						60
+#define CE2_CLK_SRC						61
+#define GP1_CLK_SRC						62
+#define GP2_CLK_SRC						63
+#define GP3_CLK_SRC						64
+#define PDM2_CLK_SRC						65
+#define QDSS_TRACECLKIN_CLK_SRC					66
+#define RBCPR_CLK_SRC						67
+#define SDCC1_APPS_CLK_SRC					68
+#define SDCC2_APPS_CLK_SRC					69
+#define SDCC3_APPS_CLK_SRC					70
+#define SDCC4_APPS_CLK_SRC					71
+#define SPMI_AHB_CLK_SRC					72
+#define SPMI_SER_CLK_SRC					73
+#define TSIF_REF_CLK_SRC					74
+#define USB30_MOCK_UTMI_CLK_SRC					75
+#define USB_HS_SYSTEM_CLK_SRC					76
+#define USB_HSIC_CLK_SRC					77
+#define USB_HSIC_IO_CAL_CLK_SRC					78
+#define USB_HSIC_SYSTEM_CLK_SRC					79
+#define GCC_BAM_DMA_AHB_CLK					80
+#define GCC_BAM_DMA_INACTIVITY_TIMERS_CLK			81
+#define GCC_BIMC_CFG_AHB_CLK					82
+#define GCC_BIMC_KPSS_AXI_CLK					83
+#define GCC_BIMC_SLEEP_CLK					84
+#define GCC_BIMC_SYSNOC_AXI_CLK					85
+#define GCC_BIMC_XO_CLK						86
+#define GCC_BLSP1_AHB_CLK					87
+#define GCC_BLSP1_SLEEP_CLK					88
+#define GCC_BLSP1_QUP1_I2C_APPS_CLK				89
+#define GCC_BLSP1_QUP1_SPI_APPS_CLK				90
+#define GCC_BLSP1_QUP2_I2C_APPS_CLK				91
+#define GCC_BLSP1_QUP2_SPI_APPS_CLK				92
+#define GCC_BLSP1_QUP3_I2C_APPS_CLK				93
+#define GCC_BLSP1_QUP3_SPI_APPS_CLK				94
+#define GCC_BLSP1_QUP4_I2C_APPS_CLK				95
+#define GCC_BLSP1_QUP4_SPI_APPS_CLK				96
+#define GCC_BLSP1_QUP5_I2C_APPS_CLK				97
+#define GCC_BLSP1_QUP5_SPI_APPS_CLK				98
+#define GCC_BLSP1_QUP6_I2C_APPS_CLK				99
+#define GCC_BLSP1_QUP6_SPI_APPS_CLK				100
+#define GCC_BLSP1_UART1_APPS_CLK				101
+#define GCC_BLSP1_UART1_SIM_CLK					102
+#define GCC_BLSP1_UART2_APPS_CLK				103
+#define GCC_BLSP1_UART2_SIM_CLK					104
+#define GCC_BLSP1_UART3_APPS_CLK				105
+#define GCC_BLSP1_UART3_SIM_CLK					106
+#define GCC_BLSP1_UART4_APPS_CLK				107
+#define GCC_BLSP1_UART4_SIM_CLK					108
+#define GCC_BLSP1_UART5_APPS_CLK				109
+#define GCC_BLSP1_UART5_SIM_CLK					110
+#define GCC_BLSP1_UART6_APPS_CLK				111
+#define GCC_BLSP1_UART6_SIM_CLK					112
+#define GCC_BLSP2_AHB_CLK					113
+#define GCC_BLSP2_SLEEP_CLK					114
+#define GCC_BLSP2_QUP1_I2C_APPS_CLK				115
+#define GCC_BLSP2_QUP1_SPI_APPS_CLK				116
+#define GCC_BLSP2_QUP2_I2C_APPS_CLK				117
+#define GCC_BLSP2_QUP2_SPI_APPS_CLK				118
+#define GCC_BLSP2_QUP3_I2C_APPS_CLK				119
+#define GCC_BLSP2_QUP3_SPI_APPS_CLK				120
+#define GCC_BLSP2_QUP4_I2C_APPS_CLK				121
+#define GCC_BLSP2_QUP4_SPI_APPS_CLK				122
+#define GCC_BLSP2_QUP5_I2C_APPS_CLK				123
+#define GCC_BLSP2_QUP5_SPI_APPS_CLK				124
+#define GCC_BLSP2_QUP6_I2C_APPS_CLK				125
+#define GCC_BLSP2_QUP6_SPI_APPS_CLK				126
+#define GCC_BLSP2_UART1_APPS_CLK				127
+#define GCC_BLSP2_UART1_SIM_CLK					128
+#define GCC_BLSP2_UART2_APPS_CLK				129
+#define GCC_BLSP2_UART2_SIM_CLK					130
+#define GCC_BLSP2_UART3_APPS_CLK				131
+#define GCC_BLSP2_UART3_SIM_CLK					132
+#define GCC_BLSP2_UART4_APPS_CLK				133
+#define GCC_BLSP2_UART4_SIM_CLK					134
+#define GCC_BLSP2_UART5_APPS_CLK				135
+#define GCC_BLSP2_UART5_SIM_CLK					136
+#define GCC_BLSP2_UART6_APPS_CLK				137
+#define GCC_BLSP2_UART6_SIM_CLK					138
+#define GCC_BOOT_ROM_AHB_CLK					139
+#define GCC_CE1_AHB_CLK						140
+#define GCC_CE1_AXI_CLK						141
+#define GCC_CE1_CLK						142
+#define GCC_CE2_AHB_CLK						143
+#define GCC_CE2_AXI_CLK						144
+#define GCC_CE2_CLK						145
+#define GCC_CNOC_BUS_TIMEOUT0_AHB_CLK				146
+#define GCC_CNOC_BUS_TIMEOUT1_AHB_CLK				147
+#define GCC_CNOC_BUS_TIMEOUT2_AHB_CLK				148
+#define GCC_CNOC_BUS_TIMEOUT3_AHB_CLK				149
+#define GCC_CNOC_BUS_TIMEOUT4_AHB_CLK				150
+#define GCC_CNOC_BUS_TIMEOUT5_AHB_CLK				151
+#define GCC_CNOC_BUS_TIMEOUT6_AHB_CLK				152
+#define GCC_CFG_NOC_AHB_CLK					153
+#define GCC_CFG_NOC_DDR_CFG_CLK					154
+#define GCC_CFG_NOC_RPM_AHB_CLK					155
+#define GCC_BIMC_DDR_CPLL0_CLK					156
+#define GCC_BIMC_DDR_CPLL1_CLK					157
+#define GCC_DDR_DIM_CFG_CLK					158
+#define GCC_DDR_DIM_SLEEP_CLK					159
+#define GCC_DEHR_CLK						160
+#define GCC_AHB_CLK						161
+#define GCC_IM_SLEEP_CLK					162
+#define GCC_XO_CLK						163
+#define GCC_XO_DIV4_CLK						164
+#define GCC_GP1_CLK						165
+#define GCC_GP2_CLK						166
+#define GCC_GP3_CLK						167
+#define GCC_IMEM_AXI_CLK					168
+#define GCC_IMEM_CFG_AHB_CLK					169
+#define GCC_KPSS_AHB_CLK					170
+#define GCC_KPSS_AXI_CLK					171
+#define GCC_LPASS_Q6_AXI_CLK					172
+#define GCC_MMSS_NOC_AT_CLK					173
+#define GCC_MMSS_NOC_CFG_AHB_CLK				174
+#define GCC_OCMEM_NOC_CFG_AHB_CLK				175
+#define GCC_OCMEM_SYS_NOC_AXI_CLK				176
+#define GCC_MPM_AHB_CLK						177
+#define GCC_MSG_RAM_AHB_CLK					178
+#define GCC_MSS_CFG_AHB_CLK					179
+#define GCC_MSS_Q6_BIMC_AXI_CLK					180
+#define GCC_NOC_CONF_XPU_AHB_CLK				181
+#define GCC_PDM2_CLK						182
+#define GCC_PDM_AHB_CLK						183
+#define GCC_PDM_XO4_CLK						184
+#define GCC_PERIPH_NOC_AHB_CLK					185
+#define GCC_PERIPH_NOC_AT_CLK					186
+#define GCC_PERIPH_NOC_CFG_AHB_CLK				187
+#define GCC_PERIPH_NOC_MPU_CFG_AHB_CLK				188
+#define GCC_PERIPH_XPU_AHB_CLK					189
+#define GCC_PNOC_BUS_TIMEOUT0_AHB_CLK				190
+#define GCC_PNOC_BUS_TIMEOUT1_AHB_CLK				191
+#define GCC_PNOC_BUS_TIMEOUT2_AHB_CLK				192
+#define GCC_PNOC_BUS_TIMEOUT3_AHB_CLK				193
+#define GCC_PNOC_BUS_TIMEOUT4_AHB_CLK				194
+#define GCC_PRNG_AHB_CLK					195
+#define GCC_QDSS_AT_CLK						196
+#define GCC_QDSS_CFG_AHB_CLK					197
+#define GCC_QDSS_DAP_AHB_CLK					198
+#define GCC_QDSS_DAP_CLK					199
+#define GCC_QDSS_ETR_USB_CLK					200
+#define GCC_QDSS_STM_CLK					201
+#define GCC_QDSS_TRACECLKIN_CLK					202
+#define GCC_QDSS_TSCTR_DIV16_CLK				203
+#define GCC_QDSS_TSCTR_DIV2_CLK					204
+#define GCC_QDSS_TSCTR_DIV3_CLK					205
+#define GCC_QDSS_TSCTR_DIV4_CLK					206
+#define GCC_QDSS_TSCTR_DIV8_CLK					207
+#define GCC_QDSS_RBCPR_XPU_AHB_CLK				208
+#define GCC_RBCPR_AHB_CLK					209
+#define GCC_RBCPR_CLK						210
+#define GCC_RPM_BUS_AHB_CLK					211
+#define GCC_RPM_PROC_HCLK					212
+#define GCC_RPM_SLEEP_CLK					213
+#define GCC_RPM_TIMER_CLK					214
+#define GCC_SDCC1_AHB_CLK					215
+#define GCC_SDCC1_APPS_CLK					216
+#define GCC_SDCC1_INACTIVITY_TIMERS_CLK				217
+#define GCC_SDCC2_AHB_CLK					218
+#define GCC_SDCC2_APPS_CLK					219
+#define GCC_SDCC2_INACTIVITY_TIMERS_CLK				220
+#define GCC_SDCC3_AHB_CLK					221
+#define GCC_SDCC3_APPS_CLK					222
+#define GCC_SDCC3_INACTIVITY_TIMERS_CLK				223
+#define GCC_SDCC4_AHB_CLK					224
+#define GCC_SDCC4_APPS_CLK					225
+#define GCC_SDCC4_INACTIVITY_TIMERS_CLK				226
+#define GCC_SEC_CTRL_ACC_CLK					227
+#define GCC_SEC_CTRL_AHB_CLK					228
+#define GCC_SEC_CTRL_BOOT_ROM_PATCH_CLK				229
+#define GCC_SEC_CTRL_CLK					230
+#define GCC_SEC_CTRL_SENSE_CLK					231
+#define GCC_SNOC_BUS_TIMEOUT0_AHB_CLK				232
+#define GCC_SNOC_BUS_TIMEOUT2_AHB_CLK				233
+#define GCC_SPDM_BIMC_CY_CLK					234
+#define GCC_SPDM_CFG_AHB_CLK					235
+#define GCC_SPDM_DEBUG_CY_CLK					236
+#define GCC_SPDM_FF_CLK						237
+#define GCC_SPDM_MSTR_AHB_CLK					238
+#define GCC_SPDM_PNOC_CY_CLK					239
+#define GCC_SPDM_RPM_CY_CLK					240
+#define GCC_SPDM_SNOC_CY_CLK					241
+#define GCC_SPMI_AHB_CLK					242
+#define GCC_SPMI_CNOC_AHB_CLK					243
+#define GCC_SPMI_SER_CLK					244
+#define GCC_SNOC_CNOC_AHB_CLK					245
+#define GCC_SNOC_PNOC_AHB_CLK					246
+#define GCC_SYS_NOC_AT_CLK					247
+#define GCC_SYS_NOC_AXI_CLK					248
+#define GCC_SYS_NOC_KPSS_AHB_CLK				249
+#define GCC_SYS_NOC_QDSS_STM_AXI_CLK				250
+#define GCC_SYS_NOC_USB3_AXI_CLK				251
+#define GCC_TCSR_AHB_CLK					252
+#define GCC_TLMM_AHB_CLK					253
+#define GCC_TLMM_CLK						254
+#define GCC_TSIF_AHB_CLK					255
+#define GCC_TSIF_INACTIVITY_TIMERS_CLK				256
+#define GCC_TSIF_REF_CLK					257
+#define GCC_USB2A_PHY_SLEEP_CLK					258
+#define GCC_USB2B_PHY_SLEEP_CLK					259
+#define GCC_USB30_MASTER_CLK					260
+#define GCC_USB30_MOCK_UTMI_CLK					261
+#define GCC_USB30_SLEEP_CLK					262
+#define GCC_USB_HS_AHB_CLK					263
+#define GCC_USB_HS_INACTIVITY_TIMERS_CLK			264
+#define GCC_USB_HS_SYSTEM_CLK					265
+#define GCC_USB_HSIC_AHB_CLK					266
+#define GCC_USB_HSIC_CLK					267
+#define GCC_USB_HSIC_IO_CAL_CLK					268
+#define GCC_USB_HSIC_IO_CAL_SLEEP_CLK				269
+#define GCC_USB_HSIC_SYSTEM_CLK					270
+#define GCC_WCSS_GPLL1_CLK_SRC					271
+#define GCC_MMSS_GPLL0_CLK_SRC					272
+#define GCC_LPASS_GPLL0_CLK_SRC					273
+#define GCC_WCSS_GPLL1_CLK_SRC_SLEEP_ENA			274
+#define GCC_MMSS_GPLL0_CLK_SRC_SLEEP_ENA			275
+#define GCC_LPASS_GPLL0_CLK_SRC_SLEEP_ENA			276
+#define GCC_IMEM_AXI_CLK_SLEEP_ENA				277
+#define GCC_SYS_NOC_KPSS_AHB_CLK_SLEEP_ENA			278
+#define GCC_BIMC_KPSS_AXI_CLK_SLEEP_ENA				279
+#define GCC_KPSS_AHB_CLK_SLEEP_ENA				280
+#define GCC_KPSS_AXI_CLK_SLEEP_ENA				281
+#define GCC_MPM_AHB_CLK_SLEEP_ENA				282
+#define GCC_OCMEM_SYS_NOC_AXI_CLK_SLEEP_ENA			283
+#define GCC_BLSP1_AHB_CLK_SLEEP_ENA				284
+#define GCC_BLSP1_SLEEP_CLK_SLEEP_ENA				285
+#define GCC_BLSP2_AHB_CLK_SLEEP_ENA				286
+#define GCC_BLSP2_SLEEP_CLK_SLEEP_ENA				287
+#define GCC_PRNG_AHB_CLK_SLEEP_ENA				288
+#define GCC_BAM_DMA_AHB_CLK_SLEEP_ENA				289
+#define GCC_BAM_DMA_INACTIVITY_TIMERS_CLK_SLEEP_ENA		290
+#define GCC_BOOT_ROM_AHB_CLK_SLEEP_ENA				291
+#define GCC_MSG_RAM_AHB_CLK_SLEEP_ENA				292
+#define GCC_TLMM_AHB_CLK_SLEEP_ENA				293
+#define GCC_TLMM_CLK_SLEEP_ENA					294
+#define GCC_SPMI_CNOC_AHB_CLK_SLEEP_ENA				295
+#define GCC_CE1_CLK_SLEEP_ENA					296
+#define GCC_CE1_AXI_CLK_SLEEP_ENA				297
+#define GCC_CE1_AHB_CLK_SLEEP_ENA				298
+#define GCC_CE2_CLK_SLEEP_ENA					299
+#define GCC_CE2_AXI_CLK_SLEEP_ENA				300
+#define GCC_CE2_AHB_CLK_SLEEP_ENA				301
+
+#endif
diff --git a/include/dt-bindings/reset/qcom,gcc-msm8974.h b/include/dt-bindings/reset/qcom,gcc-msm8974.h
new file mode 100644
index 000000000000..9bdf54322938
--- /dev/null
+++ b/include/dt-bindings/reset/qcom,gcc-msm8974.h
@@ -0,0 +1,96 @@
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
+#ifndef _DT_BINDINGS_RESET_MSM_GCC_8974_H
+#define _DT_BINDINGS_RESET_MSM_GCC_8974_H
+
+#define GCC_SYSTEM_NOC_BCR			0
+#define GCC_CONFIG_NOC_BCR			1
+#define GCC_PERIPH_NOC_BCR			2
+#define GCC_IMEM_BCR				3
+#define GCC_MMSS_BCR				4
+#define GCC_QDSS_BCR				5
+#define GCC_USB_30_BCR				6
+#define GCC_USB3_PHY_BCR			7
+#define GCC_USB_HS_HSIC_BCR			8
+#define GCC_USB_HS_BCR				9
+#define GCC_USB2A_PHY_BCR			10
+#define GCC_USB2B_PHY_BCR			11
+#define GCC_SDCC1_BCR				12
+#define GCC_SDCC2_BCR				13
+#define GCC_SDCC3_BCR				14
+#define GCC_SDCC4_BCR				15
+#define GCC_BLSP1_BCR				16
+#define GCC_BLSP1_QUP1_BCR			17
+#define GCC_BLSP1_UART1_BCR			18
+#define GCC_BLSP1_QUP2_BCR			19
+#define GCC_BLSP1_UART2_BCR			20
+#define GCC_BLSP1_QUP3_BCR			21
+#define GCC_BLSP1_UART3_BCR			22
+#define GCC_BLSP1_QUP4_BCR			23
+#define GCC_BLSP1_UART4_BCR			24
+#define GCC_BLSP1_QUP5_BCR			25
+#define GCC_BLSP1_UART5_BCR			26
+#define GCC_BLSP1_QUP6_BCR			27
+#define GCC_BLSP1_UART6_BCR			28
+#define GCC_BLSP2_BCR				29
+#define GCC_BLSP2_QUP1_BCR			30
+#define GCC_BLSP2_UART1_BCR			31
+#define GCC_BLSP2_QUP2_BCR			32
+#define GCC_BLSP2_UART2_BCR			33
+#define GCC_BLSP2_QUP3_BCR			34
+#define GCC_BLSP2_UART3_BCR			35
+#define GCC_BLSP2_QUP4_BCR			36
+#define GCC_BLSP2_UART4_BCR			37
+#define GCC_BLSP2_QUP5_BCR			38
+#define GCC_BLSP2_UART5_BCR			39
+#define GCC_BLSP2_QUP6_BCR			40
+#define GCC_BLSP2_UART6_BCR			41
+#define GCC_PDM_BCR				42
+#define GCC_BAM_DMA_BCR				43
+#define GCC_TSIF_BCR				44
+#define GCC_TCSR_BCR				45
+#define GCC_BOOT_ROM_BCR			46
+#define GCC_MSG_RAM_BCR				47
+#define GCC_TLMM_BCR				48
+#define GCC_MPM_BCR				49
+#define GCC_SEC_CTRL_BCR			50
+#define GCC_SPMI_BCR				51
+#define GCC_SPDM_BCR				52
+#define GCC_CE1_BCR				53
+#define GCC_CE2_BCR				54
+#define GCC_BIMC_BCR				55
+#define GCC_MPM_NON_AHB_RESET			56
+#define GCC_MPM_AHB_RESET			57
+#define GCC_SNOC_BUS_TIMEOUT0_BCR		58
+#define GCC_SNOC_BUS_TIMEOUT2_BCR		59
+#define GCC_PNOC_BUS_TIMEOUT0_BCR		60
+#define GCC_PNOC_BUS_TIMEOUT1_BCR		61
+#define GCC_PNOC_BUS_TIMEOUT2_BCR		62
+#define GCC_PNOC_BUS_TIMEOUT3_BCR		63
+#define GCC_PNOC_BUS_TIMEOUT4_BCR		64
+#define GCC_CNOC_BUS_TIMEOUT0_BCR		65
+#define GCC_CNOC_BUS_TIMEOUT1_BCR		66
+#define GCC_CNOC_BUS_TIMEOUT2_BCR		67
+#define GCC_CNOC_BUS_TIMEOUT3_BCR		68
+#define GCC_CNOC_BUS_TIMEOUT4_BCR		69
+#define GCC_CNOC_BUS_TIMEOUT5_BCR		70
+#define GCC_CNOC_BUS_TIMEOUT6_BCR		71
+#define GCC_DEHR_BCR				72
+#define GCC_RBCPR_BCR				73
+#define GCC_MSS_RESTART				74
+#define GCC_LPASS_RESTART			75
+#define GCC_WCSS_RESTART			76
+#define GCC_VENUS_RESTART			77
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

