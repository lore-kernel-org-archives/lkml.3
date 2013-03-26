Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879Ab3CZUFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:05:48 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:49989 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3CZUFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:05:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Maxime Coquelin <maxime_coquelin@yahoo.fr>, linux-kernel@vger.kernel.org
From: Mike Turquette <mike.turquette@linaro.org>
In-Reply-To: <1364308035-16909-1-git-send-email-maxime_coquelin@yahoo.fr>
Cc: Maxime Coquelin <maxime.coquelin@st.com>
References: <1364308035-16909-1-git-send-email-maxime_coquelin@yahoo.fr>
Message-ID: <20130326200533.4014.81236@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH] clk: ux500: Fix prcmu clocks registration
Date: Tue, 26 Mar 2013 13:05:33 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Maxime Coquelin (2013-03-26 07:27:15)
> From: Maxime Coquelin <maxime.coquelin@st.com>
> 
> In clk_reg_prcmu(), clk->hw.init field is assigned with a
> reference local to clk_reg_prcmu() function.
> 
> This patch replaces references to clk->hw.init with calls
> to __clk_get_name when called after clock registration.
> 
> This patch applies on top of v3.9-rc4.
> 
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Hi Maxime,

This patch did not apply cleanly onto clk-next.  Below is what I merged.
Please let me know if there are any issues.

Regards,
Mike



>From 5717b1a93c7d86cfea501a35bb8c83910c20159f Mon Sep 17 00:00:00 2001
From: Maxime Coquelin <maxime.coquelin@st.com>
Date: Tue, 26 Mar 2013 15:27:15 +0100
Subject: [PATCH] clk: ux500: Fix prcmu clocks registration

In clk_reg_prcmu(), clk->hw.init field is assigned with a
reference local to clk_reg_prcmu() function.

This patch replaces references to clk->hw.init with calls
to __clk_get_name when called after clock registration.

This patch applies on top of v3.9-rc4.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
[mturquette@linaro.org: resolved trivial merge issues]
---
 drivers/clk/ux500/clk-prcmu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/ux500/clk-prcmu.c b/drivers/clk/ux500/clk-prcmu.c
index 9d83256..293a288 100644
--- a/drivers/clk/ux500/clk-prcmu.c
+++ b/drivers/clk/ux500/clk-prcmu.c
@@ -44,7 +44,7 @@ static void clk_prcmu_unprepare(struct clk_hw *hw)
 	struct clk_prcmu *clk = to_clk_prcmu(hw);
 	if (prcmu_request_clock(clk->cg_sel, false))
 		pr_err("clk_prcmu: %s failed to disable %s.\n", __func__,
-			hw->init->name);
+			__clk_get_name(hw->clk));
 	else
 		clk->is_prepared = 0;
 }
@@ -106,7 +106,7 @@ static int clk_prcmu_opp_prepare(struct clk_hw *hw)
 						100);
 		if (err) {
 			pr_err("clk_prcmu: %s fail req APE OPP for %s.\n",
-				__func__, hw->init->name);
+				__func__, __clk_get_name(hw->clk));
 			return err;
 		}
 		clk->opp_requested = 1;
@@ -130,7 +130,7 @@ static void clk_prcmu_opp_unprepare(struct clk_hw *hw)
 
 	if (prcmu_request_clock(clk->cg_sel, false)) {
 		pr_err("clk_prcmu: %s failed to disable %s.\n", __func__,
-			hw->init->name);
+			__clk_get_name(hw->clk));
 		return;
 	}
 
@@ -152,7 +152,7 @@ static int clk_prcmu_opp_volt_prepare(struct clk_hw *hw)
 		err = prcmu_request_ape_opp_100_voltage(true);
 		if (err) {
 			pr_err("clk_prcmu: %s fail req APE OPP VOLT for %s.\n",
-				__func__, hw->init->name);
+				__func__, __clk_get_name(hw->clk));
 			return err;
 		}
 		clk->opp_requested = 1;
@@ -175,7 +175,7 @@ static void clk_prcmu_opp_volt_unprepare(struct clk_hw *hw)
 
 	if (prcmu_request_clock(clk->cg_sel, false)) {
 		pr_err("clk_prcmu: %s failed to disable %s.\n", __func__,
-			hw->init->name);
+			__clk_get_name(hw->clk));
 		return;
 	}
 
-- 
1.7.10.4

