Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528Ab3CZO1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:27:51 -0400
Received: from nm4-vm0.bullet.mail.ird.yahoo.com ([77.238.189.211]:34668 "HELO
	nm4-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759784Ab3CZO1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:27:49 -0400
X-Yahoo-Newman-Id: 418541.43629.bm@smtp134.mail.ir2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vf3mjT0VM1k2fxf1_lTFwcMoFzPjgLYjyvKfAQ5zLLUGWlf
 wgOK6RuFV7ueHEwdKQDiibKJ_RcqAgTTxpfIJbIsBTbc4JinuXwr1oHXnthN
 Si3Cvo6PluD6WsSbBhAkmnnwevgzTXg2LFbLThdCJ4.RuqYPGlast.ooUNLU
 emDBQ78bPwzjQnW2dhN9e.KGZudUih6ifeiKNTgghcn3MjnTOvqnN0TsJ0Vi
 KmUKkIOMTZsDfNq_C8VHA1zp_8JAveoLgTeWbSa_sVY8fMSpdylZWN_pfMVK
 fZ85pI6YlUfjFgUg5yAaStcMzSqBx.D270eagkJ7cGHDIlQxzglUCU_KjAXM
 IgppihM7hzskrqEgBYauuzWbWRGwaSlQMJPpEz.m.rC5QDfH.8YjA09LxtuT
 wlgvfGSEOIL9FurEQLDw1mNSIbMwq4m9U4GJVpHt8uX_ygyzPNcUg
X-Yahoo-SMTP: IxOjdKKswBB59COaViHCSVQ76QHx62w9Xzjbfg--
X-Rocket-Received: from localhost.localdomain (maxime_coquelin@82.127.83.212 with login)
        by smtp134.mail.ir2.yahoo.com with SMTP; 26 Mar 2013 14:27:48 +0000 UTC
From: Maxime Coquelin <maxime_coquelin@yahoo.fr>
To: mike.turquette@linaro.org, linux-kernel@vger.kernel.org
Cc: Maxime Coquelin <maxime.coquelin@st.com>
Subject: [PATCH] clk: ux500: Fix prcmu clocks registration
Date: Tue, 26 Mar 2013 15:27:15 +0100
Message-Id: <1364308035-16909-1-git-send-email-maxime_coquelin@yahoo.fr>
X-Mailer: git-send-email 1.7.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Coquelin <maxime.coquelin@st.com>

In clk_reg_prcmu(), clk->hw.init field is assigned with a
reference local to clk_reg_prcmu() function.

This patch replaces references to clk->hw.init with calls
to __clk_get_name when called after clock registration.

This patch applies on top of v3.9-rc4.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/clk/ux500/clk-prcmu.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/ux500/clk-prcmu.c b/drivers/clk/ux500/clk-prcmu.c
index 74faa7e..63ba261 100644
--- a/drivers/clk/ux500/clk-prcmu.c
+++ b/drivers/clk/ux500/clk-prcmu.c
@@ -36,7 +36,7 @@ static void clk_prcmu_unprepare(struct clk_hw *hw)
 	struct clk_prcmu *clk = to_clk_prcmu(hw);
 	if (prcmu_request_clock(clk->cg_sel, false))
 		pr_err("clk_prcmu: %s failed to disable %s.\n", __func__,
-			hw->init->name);
+			__clk_get_name(hw->clk));
 }
 
 static int clk_prcmu_enable(struct clk_hw *hw)
@@ -107,7 +107,7 @@ static int clk_prcmu_opp_prepare(struct clk_hw *hw)
 	err = request_ape_opp100(true);
 	if (err) {
 		pr_err("clk_prcmu: %s failed to request APE OPP100 for %s.\n",
-			__func__, hw->init->name);
+			__func__, __clk_get_name(hw->clk));
 		return err;
 	}
 
@@ -130,7 +130,7 @@ static void clk_prcmu_opp_unprepare(struct clk_hw *hw)
 
 out_error:
 	pr_err("clk_prcmu: %s failed to disable %s.\n", __func__,
-		hw->init->name);
+		__clk_get_name(hw->clk));
 }
 
 static int clk_prcmu_opp_volt_prepare(struct clk_hw *hw)
@@ -141,7 +141,7 @@ static int clk_prcmu_opp_volt_prepare(struct clk_hw *hw)
 	err = prcmu_request_ape_opp_100_voltage(true);
 	if (err) {
 		pr_err("clk_prcmu: %s failed to request APE OPP VOLT for %s.\n",
-			__func__, hw->init->name);
+			__func__, __clk_get_name(hw->clk));
 		return err;
 	}
 
@@ -164,7 +164,7 @@ static void clk_prcmu_opp_volt_unprepare(struct clk_hw *hw)
 
 out_error:
 	pr_err("clk_prcmu: %s failed to disable %s.\n", __func__,
-		hw->init->name);
+		__clk_get_name(hw->clk));
 }
 
 static struct clk_ops clk_prcmu_scalable_ops = {
-- 
1.7.8

