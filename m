Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaAOSv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:51:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49372 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaAOSri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:47:38 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH v5 02/14] clk: Add set_rate_and_parent() op
Date: Wed, 15 Jan 2014 10:47:22 -0800
Message-Id: <1389811654-21397-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
References: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of Qualcomm's clocks can change their parent and rate at the
same time with a single register write. Add support for this
hardware to the common clock framework by adding a new
set_rate_and_parent() op. When the clock framework determines
that both the parent and the rate are going to change during
clk_set_rate() it will call the .set_rate_and_parent() op if
available and fall back to calling .set_parent() followed by
.set_rate() otherwise.

Reviewed-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/clk.txt        |  3 ++
 drivers/clk/clk.c            | 78 +++++++++++++++++++++++++++++++++-----------
 include/linux/clk-provider.h | 15 +++++++++
 3 files changed, 77 insertions(+), 19 deletions(-)

diff --git a/Documentation/clk.txt b/Documentation/clk.txt
index 3aeb5c440442..79700eab821d 100644
--- a/Documentation/clk.txt
+++ b/Documentation/clk.txt
@@ -77,6 +77,9 @@ the operations defined in clk.h:
 		int		(*set_parent)(struct clk_hw *hw, u8 index);
 		u8		(*get_parent)(struct clk_hw *hw);
 		int		(*set_rate)(struct clk_hw *hw, unsigned long);
+		int		(*set_rate_and_parent)(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long parent_rate, u8 index);
 		void		(*init)(struct clk_hw *hw);
 	};
 
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 9ad7b71b641f..0b27b543dacf 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1129,10 +1129,9 @@ static void clk_reparent(struct clk *clk, struct clk *new_parent)
 	clk->parent = new_parent;
 }
 
-static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
+static struct clk *__clk_set_parent_before(struct clk *clk, struct clk *parent)
 {
 	unsigned long flags;
-	int ret = 0;
 	struct clk *old_parent = clk->parent;
 
 	/*
@@ -1163,6 +1162,34 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
 	clk_reparent(clk, parent);
 	clk_enable_unlock(flags);
 
+	return old_parent;
+}
+
+static void __clk_set_parent_after(struct clk *clk, struct clk *parent,
+		struct clk *old_parent)
+{
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
+}
+
+static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
+{
+	unsigned long flags;
+	int ret = 0;
+	struct clk *old_parent;
+
+	old_parent = __clk_set_parent_before(clk, parent);
+
 	/* change clock input source */
 	if (parent && clk->ops->set_parent)
 		ret = clk->ops->set_parent(clk->hw, p_index);
@@ -1180,18 +1207,8 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
 		return ret;
 	}
 
-	/*
-	 * Finish the migration of prepare state and undo the changes done
-	 * for preventing a race with clk_enable().
-	 */
-	if (clk->prepare_count) {
-		clk_disable(clk);
-		clk_disable(old_parent);
-		__clk_unprepare(old_parent);
-	}
+	__clk_set_parent_after(clk, parent, old_parent);
 
-	/* update debugfs with new clk tree topology */
-	clk_debug_reparent(clk, parent);
 	return 0;
 }
 
@@ -1376,17 +1393,32 @@ static void clk_change_rate(struct clk *clk)
 	struct clk *child;
 	unsigned long old_rate;
 	unsigned long best_parent_rate = 0;
+	bool skip_set_rate = false;
+	struct clk *old_parent;
 
 	old_rate = clk->rate;
 
-	/* set parent */
-	if (clk->new_parent && clk->new_parent != clk->parent)
-		__clk_set_parent(clk, clk->new_parent, clk->new_parent_index);
-
-	if (clk->parent)
+	if (clk->new_parent)
+		best_parent_rate = clk->new_parent->rate;
+	else if (clk->parent)
 		best_parent_rate = clk->parent->rate;
 
-	if (clk->ops->set_rate)
+	if (clk->new_parent && clk->new_parent != clk->parent) {
+		old_parent = __clk_set_parent_before(clk, clk->new_parent);
+
+		if (clk->ops->set_rate_and_parent) {
+			skip_set_rate = true;
+			clk->ops->set_rate_and_parent(clk->hw, clk->new_rate,
+					best_parent_rate,
+					clk->new_parent_index);
+		} else if (clk->ops->set_parent) {
+			clk->ops->set_parent(clk->hw, clk->new_parent_index);
+		}
+
+		__clk_set_parent_after(clk, clk->new_parent, old_parent);
+	}
+
+	if (!skip_set_rate && clk->ops->set_rate)
 		clk->ops->set_rate(clk->hw, clk->new_rate, best_parent_rate);
 
 	if (clk->ops->recalc_rate)
@@ -1678,6 +1710,14 @@ int __clk_init(struct device *dev, struct clk *clk)
 		goto out;
 	}
 
+	if (clk->ops->set_rate_and_parent &&
+			!(clk->ops->set_parent && clk->ops->set_rate)) {
+		pr_warn("%s: %s must implement .set_parent & .set_rate\n",
+				__func__, clk->name);
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/* throw a WARN if any entries in parent_names are NULL */
 	for (i = 0; i < clk->num_parents; i++)
 		WARN(!clk->parent_names[i],
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 7e59253b8603..a944222a43df 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -108,6 +108,18 @@ struct clk_hw;
  *		which is likely helpful for most .set_rate implementation.
  *		Returns 0 on success, -EERROR otherwise.
  *
+ * @set_rate_and_parent: Change the rate and the parent of this clock. The
+ *		requested rate is specified by the second argument, which
+ *		should typically be the return of .round_rate call.  The
+ *		third argument gives the parent rate which is likely helpful
+ *		for most .set_rate_and_parent implementation. The fourth
+ *		argument gives the parent index. This callback is optional (and
+ *		unnecessary) for clocks with 0 or 1 parents as well as
+ *		for clocks that can tolerate switching the rate and the parent
+ *		separately via calls to .set_parent and .set_rate.
+ *		Returns 0 on success, -EERROR otherwise.
+ *
+ *
  * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
  * implementations to split any work between atomic (enable) and sleepable
  * (prepare) contexts.  If enabling a clock requires code that might sleep,
@@ -139,6 +151,9 @@ struct clk_ops {
 	u8		(*get_parent)(struct clk_hw *hw);
 	int		(*set_rate)(struct clk_hw *hw, unsigned long,
 				    unsigned long);
+	int		(*set_rate_and_parent)(struct clk_hw *hw,
+				    unsigned long rate,
+				    unsigned long parent_rate, u8 index);
 	void		(*init)(struct clk_hw *hw);
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

