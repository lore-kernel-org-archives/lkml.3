Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3GYAor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 20:44:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34945 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab3GYAnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 20:43:49 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v1 13/14] clk: msm: Add MSM8974 GCC data
Date: Wed, 24 Jul 2013 17:43:41 -0700
Message-Id: <1374713022-6049-14-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.840.g6a90778
In-Reply-To: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary data to probe an 8974 gcc device.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/clock/qcom,gcc.txt         |   1 +
 drivers/clk/msm/Kconfig                            |   7 ++
 drivers/clk/msm/Makefile                           |   1 +
 drivers/clk/msm/core.c                             |   3 +
 drivers/clk/msm/gcc-8974.c                         | 107 +++++++++++++++++++++
 drivers/clk/msm/internal.h                         |   1 +
 6 files changed, 120 insertions(+)
 create mode 100644 drivers/clk/msm/gcc-8974.c

diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.txt b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
index 2311e1a..5c7ebcf 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc.txt
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
@@ -7,6 +7,7 @@ Required properties :
 
 			"qcom,gcc-8660"
 			"qcom,gcc-8960"
+			"qcom,gcc-8974"
 
 - reg : shall contain base register location and length
 - clocks : shall contain clocks supplied by the clock controller
diff --git a/drivers/clk/msm/Kconfig b/drivers/clk/msm/Kconfig
index 6147380..b200554 100644
--- a/drivers/clk/msm/Kconfig
+++ b/drivers/clk/msm/Kconfig
@@ -19,4 +19,11 @@ config MSM_MMCC_8960
 	  Say Y if you want to support multimedia devices such as display,
 	  graphics, video encode/decode, camera, etc.
 
+config MSM_GCC_8974
+	bool "MSM8974 Global Clock Controller"
+	help
+	  Support for the global clock controller on msm8974 devices.
+	  Say Y if you want to use peripheral devices such as UART, SPI,
+	  i2c, USB, SD/eMMC, SATA, PCIe, etc.
+
 endif
diff --git a/drivers/clk/msm/Makefile b/drivers/clk/msm/Makefile
index ae199f5..6cd9f73 100644
--- a/drivers/clk/msm/Makefile
+++ b/drivers/clk/msm/Makefile
@@ -8,4 +8,5 @@ clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-branch.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += core.o
 
 clk-msm-$(CONFIG_MSM_GCC_8960) += gcc-8960.o
+clk-msm-$(CONFIG_MSM_GCC_8974) += gcc-8974.o
 clk-msm-$(CONFIG_MSM_MMCC_8960) += mmcc-8960.o
diff --git a/drivers/clk/msm/core.c b/drivers/clk/msm/core.c
index 4e8b8d0..f2d0c0d 100644
--- a/drivers/clk/msm/core.c
+++ b/drivers/clk/msm/core.c
@@ -176,6 +176,9 @@ static const struct of_device_id msm_cc_match_table[] = {
 #ifdef CONFIG_MSM_GCC_8960
 	{ .compatible = "qcom,gcc-8960", .data = &msm_gcc_8960_matches },
 #endif
+#ifdef CONFIG_MSM_GCC_8974
+	{ .compatible = "qcom,gcc-8974", .data = &msm_gcc_8974_matches },
+#endif
 #ifdef CONFIG_MSM_MMCC_8960
 	{ .compatible = "qcom,mmcc-8960", .data = &msm_mmcc_8960_matches },
 #endif
diff --git a/drivers/clk/msm/gcc-8974.c b/drivers/clk/msm/gcc-8974.c
new file mode 100644
index 0000000..e88f6ad
--- /dev/null
+++ b/drivers/clk/msm/gcc-8974.c
@@ -0,0 +1,107 @@
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
+#include <linux/clk-provider.h>
+
+#include "internal.h"
+#include "clk-pll.h"
+#include "clk-rcg.h"
+#include "clk-branch.h"
+
+static struct pll_desc gpll0 = {
+	.l_reg = 0x4,
+	.m_reg = 0x8,
+	.n_reg = 0xc,
+	.config_reg = 0x14,
+	.mode_reg = 0x0,
+	.status_reg = 0x1c,
+	.status_bit = 17,
+};
+
+static struct pll_vote_desc vgpll0 = {
+	.vote_reg = 0x1480,
+	.vote_bit = 0,
+};
+
+#define CXO	0
+#define GPLL0	1
+#define GPLL1	2
+
+static u8 gcc_cxo_gpll0_gpll1_map[] = {
+	[CXO]	= 0,
+	[GPLL0]	= 1,
+	[GPLL1]	= 2,
+};
+
+#define F(f, s, h, m, n) { (f), (s), (2 * (h) - 1), (m), (n) }
+
+static struct freq_tbl ftbl_gcc_blsp1_2_uart1_6_apps_clk[] = {
+	F( 3686400,  GPLL0,    1,  96,  15625),
+	F( 7372800,  GPLL0,    1, 192,  15625),
+	F(14745600,  GPLL0,    1, 384,  15625),
+	F(16000000,  GPLL0,    5,   2,     15),
+	F(19200000,    CXO,    1,   0,      0),
+	F(24000000,  GPLL0,    5,   1,      5),
+	F(32000000,  GPLL0,    1,   4,     75),
+	F(40000000,  GPLL0,   15,   0,      0),
+	F(46400000,  GPLL0,    1,  29,    375),
+	F(48000000,  GPLL0, 12.5,   0,      0),
+	F(51200000,  GPLL0,    1,  32,    375),
+	F(56000000,  GPLL0,    1,   7,     75),
+	F(58982400,  GPLL0,    1, 1536, 15625),
+	F(60000000,  GPLL0,   10,   0,      0),
+	F(63160000,  GPLL0,  9.5,   0,      0),
+	{ }
+};
+
+static struct rcg2_desc blsp1_uart2_apps_rcg = {
+	.cmd_rcgr = 0x070c,
+	.parent_map = gcc_cxo_gpll0_gpll1_map,
+	.freq_tbl = ftbl_gcc_blsp1_2_uart1_6_apps_clk,
+};
+
+static struct branch_desc blsp1_uart2_apps_cxc = {
+	.ctl_reg = 0x704,
+	.halt_reg = 0x704,
+	.ctl_bit = 0,
+	.halt_bit = 31,
+	.halt_check = BRANCH_HALT,
+};
+
+static struct branch_desc blsp1_ahb_cxc = {
+	.ctl_reg = 0x1484,
+	.halt_reg = 0x5c4,
+	.ctl_bit = 17,
+	.halt_bit = 31,
+	.halt_check = BRANCH_HALT_VOTED,
+};
+
+static struct of_clk_match msm_gcc_8974_match[] = {
+	{ .name = "cxo" },
+	{ .name = "gpll0", .driver_data = &gpll0 },
+	{ .name = "vgpll0", .driver_data = &vgpll0 },
+	{
+		.name = "blsp1_uart2_apps_rcg",
+		.driver_data = &blsp1_uart2_apps_rcg,
+	},
+	{
+		.name = "blsp1_uart2_apps_cxc",
+		.driver_data = &blsp1_uart2_apps_cxc,
+	},
+	{ .name = "blsp1_ahb_cxc", .driver_data = &blsp1_ahb_cxc },
+};
+
+const struct msm_clk_match msm_gcc_8974_matches = {
+	.matches = msm_gcc_8974_match,
+	.size = ARRAY_SIZE(msm_gcc_8974_match)
+};
diff --git a/drivers/clk/msm/internal.h b/drivers/clk/msm/internal.h
index 45435a8..ae252ec 100644
--- a/drivers/clk/msm/internal.h
+++ b/drivers/clk/msm/internal.h
@@ -22,6 +22,7 @@ struct msm_clk_match {
 };
 
 extern const struct msm_clk_match msm_gcc_8960_matches;
+extern const struct msm_clk_match msm_gcc_8974_matches;
 extern const struct msm_clk_match msm_mmcc_8960_matches;
 
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

