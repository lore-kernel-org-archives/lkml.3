Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaIPVEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:04:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32784 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaIPVES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:04:18 -0400
From: Andy Gross <agross@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>
Subject: [Patch v2] clk: qcom: Add IPQ8064 PLL required for USB
Date: Tue, 16 Sep 2014 16:04:12 -0500
Message-Id: <1410901452-13519-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the PLL0 that is required for the USB clocks to work properly.

Changes in v2: Correct table to only use pll0_vote

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/clk/qcom/gcc-ipq806x.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-ipq806x.c b/drivers/clk/qcom/gcc-ipq806x.c
index 4032e51..193b7c4 100644
--- a/drivers/clk/qcom/gcc-ipq806x.c
+++ b/drivers/clk/qcom/gcc-ipq806x.c
@@ -32,6 +32,33 @@
 #include "clk-branch.h"
 #include "reset.h"
 
+static struct clk_pll pll0 = {
+	.l_reg = 0x30c4,
+	.m_reg = 0x30c8,
+	.n_reg = 0x30cc,
+	.config_reg = 0x30d4,
+	.mode_reg = 0x30c0,
+	.status_reg = 0x30d8,
+	.status_bit = 16,
+	.clkr.hw.init = &(struct clk_init_data){
+		.name = "pll0",
+		.parent_names = (const char *[]){ "pxo" },
+		.num_parents = 1,
+		.ops = &clk_pll_ops,
+	},
+};
+
+static struct clk_regmap pll0_vote = {
+	.enable_reg = 0x34c0,
+	.enable_mask = BIT(0),
+	.hw.init = &(struct clk_init_data){
+		.name = "pll0_vote",
+		.parent_names = (const char *[]){ "pll0" },
+		.num_parents = 1,
+		.ops = &clk_pll_vote_ops,
+	},
+};
+
 static struct clk_pll pll3 = {
 	.l_reg = 0x3164,
 	.m_reg = 0x3168,
@@ -154,7 +181,7 @@ static const u8 gcc_pxo_pll8_pll0[] = {
 static const char *gcc_pxo_pll8_pll0_map[] = {
 	"pxo",
 	"pll8_vote",
-	"pll0",
+	"pll0_vote",
 };
 
 static struct freq_tbl clk_tbl_gsbi_uart[] = {
@@ -2133,6 +2160,8 @@ static struct clk_branch usb_fs1_h_clk = {
 };
 
 static struct clk_regmap *gcc_ipq806x_clks[] = {
+	[PLL0] = &pll0.clkr,
+	[PLL0_VOTE] = &pll0_vote,
 	[PLL3] = &pll3.clkr,
 	[PLL8] = &pll8.clkr,
 	[PLL8_VOTE] = &pll8_vote,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

