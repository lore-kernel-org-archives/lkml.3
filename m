Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbaDDQbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 12:31:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47272 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbaDDQbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 12:31:32 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        sboyd@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH] clk: qcom: Add basic support for APQ8064 global clock controller clocks
Date: Fri,  4 Apr 2014 11:31:29 -0500
Message-Id: <1396629089-7358-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The APQ8064 and MSM8960 share a significant amount of clock data and
code between the two SoCs.  Rather than duplicating the data we just add
support for a unqiue APQ8064 clock table into the MSM8960 code.

For now add just enough clocks to get a basic serial port going on an
APQ8064 device.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---

This patch is based on Stephen's qcom common clk init conslidation patch

 .../devicetree/bindings/clock/qcom,gcc.txt         |  1 +
 drivers/clk/qcom/Kconfig                           |  4 +--
 drivers/clk/qcom/gcc-msm8960.c                     | 30 +++++++++++++++++++---
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.txt b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
index 74974d6..25ae79c 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc.txt
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
@@ -4,6 +4,7 @@ Qualcomm Global Clock & Reset Controller Binding
 Required properties :
 - compatible : shall contain only one of the following:
 
+			"qcom,gcc-apq8064"
 			"qcom,gcc-ipq8064"
 			"qcom,gcc-msm8660"
 			"qcom,gcc-msm8960"
diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 5d81f7d..4b1f2d7 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -21,10 +21,10 @@ config MSM_GCC_8660
 	  i2c, USB, SD/eMMC, etc.
 
 config MSM_GCC_8960
-	tristate "MSM8960 Global Clock Controller"
+	tristate "APQ8064/MSM8960 Global Clock Controller"
 	depends on COMMON_CLK_QCOM
 	help
-	  Support for the global clock controller on msm8960 devices.
+	  Support for the global clock controller on apq8064/msm8960 devices.
 	  Say Y if you want to use peripheral devices such as UART, SPI,
 	  i2c, USB, SD/eMMC, SATA, PCIe, etc.
 
diff --git a/drivers/clk/qcom/gcc-msm8960.c b/drivers/clk/qcom/gcc-msm8960.c
index 633b019..8e2b6dd 100644
--- a/drivers/clk/qcom/gcc-msm8960.c
+++ b/drivers/clk/qcom/gcc-msm8960.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -2868,6 +2868,16 @@ static const struct qcom_reset_map gcc_msm8960_resets[] = {
 	[RIVA_RESET] = { 0x35e0 },
 };
 
+static struct clk_regmap *gcc_apq8064_clks[] = {
+	[PLL8] = &pll8.clkr,
+	[PLL8_VOTE] = &pll8_vote,
+	[GSBI7_UART_SRC] = &gsbi7_uart_src.clkr,
+	[GSBI7_UART_CLK] = &gsbi7_uart_clk.clkr,
+	[GSBI7_QUP_SRC] = &gsbi7_qup_src.clkr,
+	[GSBI7_QUP_CLK] = &gsbi7_qup_clk.clkr,
+	[GSBI7_H_CLK] = &gsbi7_h_clk.clkr,
+};
+
 static const struct regmap_config gcc_msm8960_regmap_config = {
 	.reg_bits	= 32,
 	.reg_stride	= 4,
@@ -2884,8 +2894,17 @@ static const struct qcom_cc_desc gcc_msm8960_desc = {
 	.num_resets = ARRAY_SIZE(gcc_msm8960_resets),
 };
 
+static const struct qcom_cc_desc gcc_apq8064_desc = {
+	.config = &gcc_msm8960_regmap_config,
+	.clks = gcc_apq8064_clks,
+	.num_clks = ARRAY_SIZE(gcc_apq8064_clks),
+	.resets = gcc_msm8960_resets,
+	.num_resets = ARRAY_SIZE(gcc_msm8960_resets),
+};
+
 static const struct of_device_id gcc_msm8960_match_table[] = {
-	{ .compatible = "qcom,gcc-msm8960" },
+	{ .compatible = "qcom,gcc-msm8960", .data = &gcc_msm8960_desc },
+	{ .compatible = "qcom,gcc-apq8064", .data = &gcc_apq8064_desc },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, gcc_msm8960_match_table);
@@ -2894,6 +2913,11 @@ static int gcc_msm8960_probe(struct platform_device *pdev)
 {
 	struct clk *clk;
 	struct device *dev = &pdev->dev;
+	const struct of_device_id *match;
+
+	match = of_match_device(gcc_msm8960_match_table, &pdev->dev);
+	if (!match)
+		return -EINVAL;
 
 	/* Temporary until RPM clocks supported */
 	clk = clk_register_fixed_rate(dev, "cxo", NULL, CLK_IS_ROOT, 19200000);
@@ -2904,7 +2928,7 @@ static int gcc_msm8960_probe(struct platform_device *pdev)
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
-	return qcom_cc_probe(pdev, &gcc_msm8960_desc);
+	return qcom_cc_probe(pdev, match->data);
 }
 
 static int gcc_msm8960_remove(struct platform_device *pdev)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

