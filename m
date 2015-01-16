Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbbAPOsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:48:41 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49641 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbbAPOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:48:38 -0500
From: Archit Taneja <architt@codeaurora.org>
To: linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agross@codeaurora.org, galak@codeaurora.org,
        Archit Taneja <architt@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 1/5] clk: qcom: Add EBI2 clocks for IPQ806x
Date: Fri, 16 Jan 2015 20:18:18 +0530
Message-Id: <1421419702-17812-2-git-send-email-architt@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1421419702-17812-1-git-send-email-architt@codeaurora.org>
References: <1421419702-17812-1-git-send-email-architt@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NAND controller within EBI2 requires EBI2_CLK and EBI2_ALWAYS_ON_CLK clocks.
Create structs for these clocks so that they can be used by the NAND controller
driver. Add an entry for EBI2_AON_CLK in the gcc-ipq806x DT binding document.

Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Archit Taneja <architt@codeaurora.org>
---
 drivers/clk/qcom/gcc-ipq806x.c               | 34 ++++++++++++++++++++++++++++
 include/dt-bindings/clock/qcom,gcc-ipq806x.h |  1 +
 2 files changed, 35 insertions(+)

diff --git a/drivers/clk/qcom/gcc-ipq806x.c b/drivers/clk/qcom/gcc-ipq806x.c
index afed5eb..7db54c8 100644
--- a/drivers/clk/qcom/gcc-ipq806x.c
+++ b/drivers/clk/qcom/gcc-ipq806x.c
@@ -2159,6 +2159,38 @@ static struct clk_branch usb_fs1_h_clk = {
 	},
 };
 
+static struct clk_branch ebi2_clk = {
+	.hwcg_reg = 0x3b00,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fcc,
+	.halt_bit = 1,
+	.clkr = {
+		.enable_reg = 0x3b00,
+		.enable_mask = BIT(4),
+		.hw.init = &(struct clk_init_data){
+			.name = "ebi2_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
+static struct clk_branch ebi2_aon_clk = {
+	.hwcg_reg = 0x3b00,
+	.hwcg_bit = 6,
+	.halt_reg = 0x2fcc,
+	.halt_bit = 0,
+	.clkr = {
+		.enable_reg = 0x3b00,
+		.enable_mask = BIT(8),
+		.hw.init = &(struct clk_init_data){
+			.name = "ebi2_always_on_clk",
+			.ops = &clk_branch_ops,
+			.flags = CLK_IS_ROOT,
+		},
+	},
+};
+
 static struct clk_regmap *gcc_ipq806x_clks[] = {
 	[PLL0] = &pll0.clkr,
 	[PLL0_VOTE] = &pll0_vote,
@@ -2261,6 +2293,8 @@ static struct clk_regmap *gcc_ipq806x_clks[] = {
 	[USB_FS1_XCVR_SRC] = &usb_fs1_xcvr_clk_src.clkr,
 	[USB_FS1_XCVR_CLK] = &usb_fs1_xcvr_clk.clkr,
 	[USB_FS1_SYSTEM_CLK] = &usb_fs1_sys_clk.clkr,
+	[EBI2_CLK] = &ebi2_clk.clkr,
+	[EBI2_AON_CLK] = &ebi2_aon_clk.clkr,
 };
 
 static const struct qcom_reset_map gcc_ipq806x_resets[] = {
diff --git a/include/dt-bindings/clock/qcom,gcc-ipq806x.h b/include/dt-bindings/clock/qcom,gcc-ipq806x.h
index b857cad..858a47f 100644
--- a/include/dt-bindings/clock/qcom,gcc-ipq806x.h
+++ b/include/dt-bindings/clock/qcom,gcc-ipq806x.h
@@ -289,5 +289,6 @@
 #define UBI32_CORE2_CLK_SRC			278
 #define UBI32_CORE1_CLK				279
 #define UBI32_CORE2_CLK				280
+#define EBI2_AON_CLK				281
 
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

