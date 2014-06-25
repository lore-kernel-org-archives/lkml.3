Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaFYAGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 20:06:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41334 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaFYAG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 20:06:28 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [RFC/PATCH 02/12] clk: Add safe switch hook
Date: Tue, 24 Jun 2014 17:06:13 -0700
Message-Id: <1403654783-7176-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
References: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes clocks can't accept their parent source turning off
while the source is reprogrammed to a different rate. Most
notably some CPU clocks require a way to switch away from the
current PLL they're running on, reprogram that PLL to a new rate,
and then switch back to the PLL with the new rate once they're
done.  Add a hook that drivers can implement allowing them to
return a 'safe parent' that they can switch their parent to while
the upstream source is reprogrammed.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c            | 53 ++++++++++++++++++++++++++++++++++++++------
 include/linux/clk-private.h  |  2 ++
 include/linux/clk-provider.h |  1 +
 3 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8b73edef151d..5e32fa55032b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1367,6 +1367,7 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
 			     struct clk *new_parent, u8 p_index)
 {
 	struct clk *child;
+	struct clk *parent;
 
 	clk->new_rate = new_rate;
 	clk->new_parent = new_parent;
@@ -1376,6 +1377,17 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
 	if (new_parent && new_parent != clk->parent)
 		new_parent->new_child = clk;
 
+	if (clk->ops->get_safe_parent) {
+		parent = clk->ops->get_safe_parent(clk->hw);
+		if (parent) {
+			p_index = clk_fetch_parent_index(clk, parent);
+			clk->safe_parent_index = p_index;
+			clk->safe_parent = parent;
+		}
+	} else {
+		clk->safe_parent = NULL;
+	}
+
 	hlist_for_each_entry(child, &clk->children, child_node) {
 		child->new_rate = clk_recalc(child, new_rate);
 		clk_calc_subtree(child, child->new_rate, NULL, 0);
@@ -1458,14 +1470,42 @@ out:
 static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long event)
 {
 	struct clk *child, *tmp_clk, *fail_clk = NULL;
+	struct clk *old_parent;
 	int ret = NOTIFY_DONE;
 
-	if (clk->rate == clk->new_rate)
+	if (clk->rate == clk->new_rate && event != POST_RATE_CHANGE)
 		return NULL;
 
+	switch (event) {
+	case PRE_RATE_CHANGE:
+		if (clk->safe_parent)
+			clk->ops->set_parent(clk->hw, clk->safe_parent_index);
+		break;
+	case POST_RATE_CHANGE:
+		if (clk->safe_parent) {
+			old_parent = __clk_set_parent_before(clk,
+							     clk->new_parent);
+			if (clk->ops->set_rate_and_parent) {
+				clk->ops->set_rate_and_parent(clk->hw,
+						clk->new_rate,
+						clk->new_parent ?
+						clk->new_parent->rate : 0,
+						clk->new_parent_index);
+			} else if (clk->ops->set_parent) {
+				clk->ops->set_parent(clk->hw,
+						clk->new_parent_index);
+			}
+			__clk_set_parent_after(clk, clk->new_parent,
+					       old_parent);
+		}
+		break;
+	}
+
 	if (clk->notifier_count) {
-		ret = __clk_notify(clk, event, clk->rate, clk->new_rate);
-		if (ret & NOTIFY_STOP_MASK)
+		if (event != POST_RATE_CHANGE)
+			ret = __clk_notify(clk, event, clk->rate,
+					   clk->new_rate);
+		if (ret & NOTIFY_STOP_MASK && event != POST_RATE_CHANGE)
 			fail_clk = clk;
 	}
 
@@ -1507,7 +1547,8 @@ static void clk_change_rate(struct clk *clk)
 	else if (clk->parent)
 		best_parent_rate = clk->parent->rate;
 
-	if (clk->new_parent && clk->new_parent != clk->parent) {
+	if (clk->new_parent && clk->new_parent != clk->parent &&
+			!clk->safe_parent) {
 		old_parent = __clk_set_parent_before(clk, clk->new_parent);
 
 		if (clk->ops->set_rate_and_parent) {
@@ -1527,9 +1568,6 @@ static void clk_change_rate(struct clk *clk)
 
 	clk->rate = clk_recalc(clk, best_parent_rate);
 
-	if (clk->notifier_count && old_rate != clk->rate)
-		__clk_notify(clk, POST_RATE_CHANGE, old_rate, clk->rate);
-
 	hlist_for_each_entry(child, &clk->children, child_node) {
 		/* Skip children who will be reparented to another clock */
 		if (child->new_parent && child->new_parent != clk)
@@ -1603,6 +1641,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	/* change the rates */
 	clk_change_rate(top);
 
+	clk_propagate_rate_change(top, POST_RATE_CHANGE);
 out:
 	clk_prepare_unlock();
 
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index efbf70b9fd84..f48684af4d8f 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -38,8 +38,10 @@ struct clk {
 	struct clk		**parents;
 	u8			num_parents;
 	u8			new_parent_index;
+	u8			safe_parent_index;
 	unsigned long		rate;
 	unsigned long		new_rate;
+	struct clk		*safe_parent;
 	struct clk		*new_parent;
 	struct clk		*new_child;
 	unsigned long		flags;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 0c287dbbb144..7485911df4b6 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -170,6 +170,7 @@ struct clk_ops {
 					struct clk **best_parent_clk);
 	int		(*set_parent)(struct clk_hw *hw, u8 index);
 	u8		(*get_parent)(struct clk_hw *hw);
+	struct clk	*(*get_safe_parent)(struct clk_hw *hw);
 	int		(*set_rate)(struct clk_hw *hw, unsigned long rate,
 				    unsigned long parent_rate);
 	int		(*set_rate_and_parent)(struct clk_hw *hw,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

