Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3ETN3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:29:19 -0400
Received: from multi.imgtec.com ([194.200.65.239]:44979 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508Ab3ETN3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:29:15 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v4 2/5] clk: move some parent related functions upwards
Date: Mon, 20 May 2013 14:28:24 +0100
Message-ID: <1369056507-32521-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com>
References: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_20_14_29_12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move some parent related functions up in clk.c so they can be used by
the modifications in the following patch which enables clock reparenting
during set_rate. No other changes are made so this patch makes no
functional difference in isolation. This is separate from the following
patch primarily to ease readability of that patch.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
---
Changes in v4:

* new patch (patch 2) split out of patch 3 to avoid having to declare
  static __clk_set_parent() at the top of clk.c, and to ease readability
  of patch 3.

 drivers/clk/clk.c | 220 +++++++++++++++++++++++++++---------------------------
 1 file changed, 110 insertions(+), 110 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f0ebada..a4cd6bc 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1027,6 +1027,108 @@ unsigned long clk_get_rate(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_get_rate);
 
+static u8 clk_fetch_parent_index(struct clk *clk, struct clk *parent)
+{
+	u8 i;
+
+	if (!clk->parents)
+		clk->parents = kzalloc((sizeof(struct clk*) * clk->num_parents),
+								GFP_KERNEL);
+
+	/*
+	 * find index of new parent clock using cached parent ptrs,
+	 * or if not yet cached, use string name comparison and cache
+	 * them now to avoid future calls to __clk_lookup.
+	 */
+	for (i = 0; i < clk->num_parents; i++) {
+		if (clk->parents && clk->parents[i] == parent)
+			break;
+		else if (!strcmp(clk->parent_names[i], parent->name)) {
+			if (clk->parents)
+				clk->parents[i] = __clk_lookup(parent->name);
+			break;
+		}
+	}
+
+	return i;
+}
+
+static void clk_reparent(struct clk *clk, struct clk *new_parent)
+{
+	hlist_del(&clk->child_node);
+
+	if (new_parent)
+		hlist_add_head(&clk->child_node, &new_parent->children);
+	else
+		hlist_add_head(&clk->child_node, &clk_orphan_list);
+
+	clk->parent = new_parent;
+}
+
+static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
+{
+	unsigned long flags;
+	int ret = 0;
+	struct clk *old_parent = clk->parent;
+
+	/*
+	 * Migrate prepare state between parents and prevent race with
+	 * clk_enable().
+	 *
+	 * If the clock is not prepared, then a race with
+	 * clk_enable/disable() is impossible since we already have the
+	 * prepare lock (future calls to clk_enable() need to be preceded by
+	 * a clk_prepare()).
+	 *
+	 * If the clock is prepared, migrate the prepared state to the new
+	 * parent and also protect against a race with clk_enable() by
+	 * forcing the clock and the new parent on.  This ensures that all
+	 * future calls to clk_enable() are practically NOPs with respect to
+	 * hardware and software states.
+	 */
+	if (clk->prepare_count) {
+		__clk_prepare(parent);
+		clk_enable(parent);
+		clk_enable(clk);
+	}
+
+	/* update the clk tree topology */
+	flags = clk_enable_lock();
+	clk_reparent(clk, parent);
+	clk_enable_unlock(flags);
+
+	/* change clock input source */
+	if (parent && clk->ops->set_parent)
+		ret = clk->ops->set_parent(clk->hw, p_index);
+
+	if (ret) {
+		flags = clk_enable_lock();
+		clk_reparent(clk, old_parent);
+		clk_enable_unlock(flags);
+
+		if (clk->prepare_count) {
+			clk_disable(clk);
+			clk_disable(parent);
+			__clk_unprepare(parent);
+		}
+		return ret;
+	}
+
+	/*
+	 * Finish the migration of prepare state and undo the changes done
+	 * for preventing a race with clk_enable().
+	 */
+	if (clk->prepare_count) {
+		clk_disable(clk);
+		clk_disable(old_parent);
+		__clk_unprepare(old_parent);
+	}
+
+	/* update debugfs with new clk tree topology */
+	clk_debug_reparent(clk, parent);
+	return 0;
+}
+
 /**
  * __clk_speculate_rates
  * @clk: first clk in the subtree
@@ -1334,18 +1436,6 @@ out:
 	return ret;
 }
 
-static void clk_reparent(struct clk *clk, struct clk *new_parent)
-{
-	hlist_del(&clk->child_node);
-
-	if (new_parent)
-		hlist_add_head(&clk->child_node, &new_parent->children);
-	else
-		hlist_add_head(&clk->child_node, &clk_orphan_list);
-
-	clk->parent = new_parent;
-}
-
 void __clk_reparent(struct clk *clk, struct clk *new_parent)
 {
 	clk_reparent(clk, new_parent);
@@ -1353,96 +1443,6 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
 	__clk_recalc_rates(clk, POST_RATE_CHANGE);
 }
 
-static u8 clk_fetch_parent_index(struct clk *clk, struct clk *parent)
-{
-	u8 i;
-
-	if (!clk->parents)
-		clk->parents = kzalloc((sizeof(struct clk*) * clk->num_parents),
-								GFP_KERNEL);
-
-	/*
-	 * find index of new parent clock using cached parent ptrs,
-	 * or if not yet cached, use string name comparison and cache
-	 * them now to avoid future calls to __clk_lookup.
-	 */
-	for (i = 0; i < clk->num_parents; i++) {
-		if (clk->parents && clk->parents[i] == parent)
-			break;
-		else if (!strcmp(clk->parent_names[i], parent->name)) {
-			if (clk->parents)
-				clk->parents[i] = __clk_lookup(parent->name);
-			break;
-		}
-	}
-
-	return i;
-}
-
-static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
-{
-	unsigned long flags;
-	int ret = 0;
-	struct clk *old_parent = clk->parent;
-
-	/*
-	 * Migrate prepare state between parents and prevent race with
-	 * clk_enable().
-	 *
-	 * If the clock is not prepared, then a race with
-	 * clk_enable/disable() is impossible since we already have the
-	 * prepare lock (future calls to clk_enable() need to be preceded by
-	 * a clk_prepare()).
-	 *
-	 * If the clock is prepared, migrate the prepared state to the new
-	 * parent and also protect against a race with clk_enable() by
-	 * forcing the clock and the new parent on.  This ensures that all
-	 * future calls to clk_enable() are practically NOPs with respect to
-	 * hardware and software states.
-	 */
-	if (clk->prepare_count) {
-		__clk_prepare(parent);
-		clk_enable(parent);
-		clk_enable(clk);
-	}
-
-	/* update the clk tree topology */
-	flags = clk_enable_lock();
-	clk_reparent(clk, parent);
-	clk_enable_unlock(flags);
-
-	/* change clock input source */
-	if (parent && clk->ops->set_parent)
-		ret = clk->ops->set_parent(clk->hw, p_index);
-
-	if (ret) {
-		flags = clk_enable_lock();
-		clk_reparent(clk, old_parent);
-		clk_enable_unlock(flags);
-
-		if (clk->prepare_count) {
-			clk_disable(clk);
-			clk_disable(parent);
-			__clk_unprepare(parent);
-		}
-		return ret;
-	}
-
-	/*
-	 * Finish the migration of prepare state and undo the changes done
-	 * for preventing a race with clk_enable().
-	 */
-	if (clk->prepare_count) {
-		clk_disable(clk);
-		clk_disable(old_parent);
-		__clk_unprepare(old_parent);
-	}
-
-	/* update debugfs with new clk tree topology */
-	clk_debug_reparent(clk, parent);
-	return 0;
-}
-
 /**
  * clk_set_parent - switch the parent of a mux clk
  * @clk: the mux clk whose input we are switching
-- 
1.8.1.2


