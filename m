Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaIOENu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 00:13:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41476 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaIOENt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 00:13:49 -0400
From: Andy Gross <agross@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Kumar Gala <galak@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH] clk: qcom: Add IPQ8064 PLL required for USB
Date: Sun, 14 Sep 2014 23:12:12 -0500
Message-Id: <1410754332-26699-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the PLL0 that is required for the USB clocks to work properly.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/clk/qcom/gcc-ipq806x.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/clk/qcom/gcc-ipq806x.c b/drivers/clk/qcom/gcc-ipq806x.c
index 4032e51..21f9187 100644
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
@@ -155,6 +182,7 @@ static const char *gcc_pxo_pll8_pll0_map[] = {
 	"pxo",
 	"pll8_vote",
 	"pll0",
+	"pll0_vote",
 };
 
 static struct freq_tbl clk_tbl_gsbi_uart[] = {
@@ -2133,6 +2161,8 @@ static struct clk_branch usb_fs1_h_clk = {
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

