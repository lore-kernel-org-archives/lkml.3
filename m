Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaESEgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:36:05 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:14034 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbaESEcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:32:51 -0400
X-IronPort-AV: E=Sophos;i="4.98,865,1392159600"; 
   d="scan'208";a="74474215"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mike Turquette <mturquette@linaro.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/13] CLK: TI: DRA7: make return of 0 explicit
Date: Mon, 19 May 2014 06:31:05 +0200
Message-Id: <1400473875-22228-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete unnecessary local variable whose value is always 0 and that hides
the fact that the result is always 0.

Additionally dropped some unneeded braces in an affected if.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression ret;
expression e;
position p;
@@

-ret = 0;
... when != ret = e
return 
- ret
+ 0
  ;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Alternatively, is an error code wanted in either of the MAX_APLL_WAIT_TRIES
cases?

 drivers/clk/ti/apll.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/ti/apll.c b/drivers/clk/ti/apll.c
index b986f61..659032a 100644
--- a/drivers/clk/ti/apll.c
+++ b/drivers/clk/ti/apll.c
@@ -37,7 +37,7 @@
 static int dra7_apll_enable(struct clk_hw *hw)
 {
 	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
-	int r = 0, i = 0;
+	int i = 0;
 	struct dpll_data *ad;
 	const char *clk_name;
 	u8 state = 1;
@@ -55,7 +55,7 @@ static int dra7_apll_enable(struct clk_hw *hw)
 	v = ti_clk_ll_ops->clk_readl(ad->idlest_reg);
 
 	if ((v & ad->idlest_mask) == state)
-		return r;
+		return 0;
 
 	v = ti_clk_ll_ops->clk_readl(ad->control_reg);
 	v &= ~ad->enable_mask;
@@ -74,17 +74,14 @@ static int dra7_apll_enable(struct clk_hw *hw)
 		udelay(1);
 	}
 
-	if (i == MAX_APLL_WAIT_TRIES) {
+	if (i == MAX_APLL_WAIT_TRIES)
 		pr_warn("clock: %s failed transition to '%s'\n",
 			clk_name, (state) ? "locked" : "bypassed");
-	} else {
+	else
 		pr_debug("clock: %s transition to '%s' in %d loops\n",
 			 clk_name, (state) ? "locked" : "bypassed", i);
 
-		r = 0;
-	}
-
-	return r;
+	return 0;
 }
 
 static void dra7_apll_disable(struct clk_hw *hw)

