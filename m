Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbaCZXGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 19:06:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37652 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaCZXGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 19:06:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] clk: Consolidate recalc rate logic
Date: Wed, 26 Mar 2014 16:06:36 -0700
Message-Id: <1395875197-16816-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1395875197-16816-1-git-send-email-sboyd@codeaurora.org>
References: <1395875197-16816-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same if-else statement exists four times to recalculate the
rate of a clock. Consolidate this logic into a single function to
save some lines.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 10e0afaefe2f..e924401c0030 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1111,6 +1111,13 @@ long clk_get_accuracy(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_get_accuracy);
 
+static unsigned long clk_recalc(struct clk *clk, unsigned long parent_rate)
+{
+	if (clk->ops->recalc_rate)
+		return clk->ops->recalc_rate(clk->hw, parent_rate);
+	return parent_rate;
+}
+
 /**
  * __clk_recalc_rates
  * @clk: first clk in the subtree
@@ -1136,10 +1143,7 @@ static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
 	if (clk->parent)
 		parent_rate = clk->parent->rate;
 
-	if (clk->ops->recalc_rate)
-		clk->rate = clk->ops->recalc_rate(clk->hw, parent_rate);
-	else
-		clk->rate = parent_rate;
+	clk->rate = clk_recalc(clk, parent_rate);
 
 	/*
 	 * ignore NOTIFY_STOP and NOTIFY_BAD return values for POST_RATE_CHANGE
@@ -1330,10 +1334,7 @@ static int __clk_speculate_rates(struct clk *clk, unsigned long parent_rate)
 	unsigned long new_rate;
 	int ret = NOTIFY_DONE;
 
-	if (clk->ops->recalc_rate)
-		new_rate = clk->ops->recalc_rate(clk->hw, parent_rate);
-	else
-		new_rate = parent_rate;
+	new_rate = clk_recalc(clk, parent_rate);
 
 	/* abort rate change if a driver returns NOTIFY_BAD or NOTIFY_STOP */
 	if (clk->notifier_count)
@@ -1369,10 +1370,7 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
 		new_parent->new_child = clk;
 
 	hlist_for_each_entry(child, &clk->children, child_node) {
-		if (child->ops->recalc_rate)
-			child->new_rate = child->ops->recalc_rate(child->hw, new_rate);
-		else
-			child->new_rate = new_rate;
+		child->new_rate = clk_recalc(child, new_rate);
 		clk_calc_subtree(child, child->new_rate, NULL, 0);
 	}
 }
@@ -1520,10 +1518,7 @@ static void clk_change_rate(struct clk *clk)
 	if (!skip_set_rate && clk->ops->set_rate)
 		clk->ops->set_rate(clk->hw, clk->new_rate, best_parent_rate);
 
-	if (clk->ops->recalc_rate)
-		clk->rate = clk->ops->recalc_rate(clk->hw, best_parent_rate);
-	else
-		clk->rate = best_parent_rate;
+	clk->rate = clk_recalc(clk, best_parent_rate);
 
 	if (clk->notifier_count && old_rate != clk->rate)
 		__clk_notify(clk, POST_RATE_CHANGE, old_rate, clk->rate);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

