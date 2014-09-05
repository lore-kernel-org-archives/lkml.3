Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaIEWrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:47:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43560 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbaIEWrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:47:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH v2 06/15] clk: Avoid sending high rates to downstream clocks during set_rate
Date: Fri,  5 Sep 2014 15:47:26 -0700
Message-Id: <1409957256-23729-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
In-Reply-To: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a clock is on and we call clk_set_rate() on it we may get into
a situation where the clock temporarily increases in rate
dramatically while we walk the tree and call .set_rate() ops. For
example, consider a case where a PLL feeds into a divider.
Initially the divider is set to divide by 1 and the PLL is
running fairly slow (100MHz). The downstream consumer of the
divider output can only handle rates =< 400 MHz, but the divider
can only choose between divisors of 1 and 4.

 +-----+   +----------------+
 | PLL |-->| div 1 or div 4 |---> consumer device
 +-----+   +----------------+

To achieve a rate of 400MHz on the output of the divider, we
would have to set the rate of the PLL to 1.6 GHz and then divide
it by 4. The current code would set the PLL to 1.6GHz first while
the divider is still set to 1, thus causing the downstream
consumer of the clock to receive a few clock cycles of 1.6GHz
clock (far beyond it's maximum acceptable rate). We should be
changing the divider first before increasing the PLL rate to
avoid this problem.

Therefore, set the rate of any child clocks that are increasing
in rate from their current rate so that they can increase their
dividers if necessary. We assume that there isn't such a thing as
minimum rate requirements.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index b23e2b9c9102..5e9afbc3040b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1533,20 +1533,22 @@ static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long even
  * walk down a subtree and set the new rates notifying the rate
  * change on the way
  */
-static void clk_change_rate(struct clk *clk)
+static void clk_change_rate(struct clk *clk, unsigned long best_parent_rate)
 {
 	struct clk *child;
 	unsigned long old_rate;
-	unsigned long best_parent_rate = 0;
 	bool skip_set_rate = false;
 	struct clk *old_parent;
 
-	old_rate = clk->rate;
+	hlist_for_each_entry(child, &clk->children, child_node) {
+		/* Skip children who will be reparented to another clock */
+		if (child->new_parent && child->new_parent != clk)
+			continue;
+		if (child->new_rate > child->rate)
+			clk_change_rate(child, clk->new_rate);
+	}
 
-	if (clk->new_parent)
-		best_parent_rate = clk->new_parent->rate;
-	else if (clk->parent)
-		best_parent_rate = clk->parent->rate;
+	old_rate = clk->rate;
 
 	if (clk->new_parent && clk->new_parent != clk->parent &&
 			!clk->safe_parent) {
@@ -1567,18 +1569,19 @@ static void clk_change_rate(struct clk *clk)
 	if (!skip_set_rate && clk->ops->set_rate)
 		clk->ops->set_rate(clk->hw, clk->new_rate, best_parent_rate);
 
-	clk->rate = clk_recalc(clk, best_parent_rate);
+	clk->rate = clk->new_rate;
 
 	hlist_for_each_entry(child, &clk->children, child_node) {
 		/* Skip children who will be reparented to another clock */
 		if (child->new_parent && child->new_parent != clk)
 			continue;
-		clk_change_rate(child);
+		if (child->new_rate != child->rate)
+			clk_change_rate(child, clk->new_rate);
 	}
 
 	/* handle the new child who might not be in clk->children yet */
-	if (clk->new_child)
-		clk_change_rate(clk->new_child);
+	if (clk->new_child && clk->new_child->new_rate != clk->new_child->rate)
+		clk_change_rate(clk->new_child, clk->new_rate);
 }
 
 /**
@@ -1606,6 +1609,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 {
 	struct clk *top, *fail_clk;
 	int ret = 0;
+	unsigned long parent_rate;
 
 	if (!clk)
 		return 0;
@@ -1639,8 +1643,13 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 		goto out;
 	}
 
+	if (top->parent)
+		parent_rate = top->parent->rate;
+	else
+		parent_rate = 0;
+
 	/* change the rates */
-	clk_change_rate(top);
+	clk_change_rate(top, parent_rate);
 
 	clk_propagate_rate_change(top, POST_RATE_CHANGE);
 out:
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

