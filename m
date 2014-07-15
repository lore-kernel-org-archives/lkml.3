Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbaGOW7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:59:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45442 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbaGOW7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:59:45 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH 1/2] clk: qcom: pll: Add support for configuring SR PLLs
Date: Tue, 15 Jul 2014 15:59:41 -0700
Message-Id: <1405465182-925-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1405465182-925-1-git-send-email-sboyd@codeaurora.org>
References: <1405465182-925-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SR type PLLs need to be configured for a certain rate when
linux boots. Add support for these types of PLLs so that we can
program PLL15's rate on APQ8064.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/clk-pll.c | 15 ++++++++++++---
 drivers/clk/qcom/clk-pll.h |  2 ++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/clk-pll.c b/drivers/clk/qcom/clk-pll.c
index 0f927c538613..9db03d3b1657 100644
--- a/drivers/clk/qcom/clk-pll.c
+++ b/drivers/clk/qcom/clk-pll.c
@@ -166,7 +166,7 @@ const struct clk_ops clk_pll_vote_ops = {
 EXPORT_SYMBOL_GPL(clk_pll_vote_ops);
 
 static void
-clk_pll_set_fsm_mode(struct clk_pll *pll, struct regmap *regmap)
+clk_pll_set_fsm_mode(struct clk_pll *pll, struct regmap *regmap, u8 lock_count)
 {
 	u32 val;
 	u32 mask;
@@ -175,7 +175,7 @@ clk_pll_set_fsm_mode(struct clk_pll *pll, struct regmap *regmap)
 	regmap_update_bits(regmap, pll->mode_reg, PLL_VOTE_FSM_RESET, 0);
 
 	/* Program bias count and lock count */
-	val = 1 << PLL_BIAS_COUNT_SHIFT;
+	val = 1 << PLL_BIAS_COUNT_SHIFT | lock_count << PLL_LOCK_COUNT_SHIFT;
 	mask = PLL_BIAS_COUNT_MASK << PLL_BIAS_COUNT_SHIFT;
 	mask |= PLL_LOCK_COUNT_MASK << PLL_LOCK_COUNT_SHIFT;
 	regmap_update_bits(regmap, pll->mode_reg, mask, val);
@@ -212,11 +212,20 @@ static void clk_pll_configure(struct clk_pll *pll, struct regmap *regmap,
 	regmap_update_bits(regmap, pll->config_reg, mask, val);
 }
 
+void clk_pll_configure_sr(struct clk_pll *pll, struct regmap *regmap,
+		const struct pll_config *config, bool fsm_mode)
+{
+	clk_pll_configure(pll, regmap, config);
+	if (fsm_mode)
+		clk_pll_set_fsm_mode(pll, regmap, 8);
+}
+EXPORT_SYMBOL_GPL(clk_pll_configure_sr);
+
 void clk_pll_configure_sr_hpm_lp(struct clk_pll *pll, struct regmap *regmap,
 		const struct pll_config *config, bool fsm_mode)
 {
 	clk_pll_configure(pll, regmap, config);
 	if (fsm_mode)
-		clk_pll_set_fsm_mode(pll, regmap);
+		clk_pll_set_fsm_mode(pll, regmap, 0);
 }
 EXPORT_SYMBOL_GPL(clk_pll_configure_sr_hpm_lp);
diff --git a/drivers/clk/qcom/clk-pll.h b/drivers/clk/qcom/clk-pll.h
index 0775a99ca768..3003e9962472 100644
--- a/drivers/clk/qcom/clk-pll.h
+++ b/drivers/clk/qcom/clk-pll.h
@@ -60,6 +60,8 @@ struct pll_config {
 	u32 aux_output_mask;
 };
 
+void clk_pll_configure_sr(struct clk_pll *pll, struct regmap *regmap,
+		const struct pll_config *config, bool fsm_mode);
 void clk_pll_configure_sr_hpm_lp(struct clk_pll *pll, struct regmap *regmap,
 		const struct pll_config *config, bool fsm_mode);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

