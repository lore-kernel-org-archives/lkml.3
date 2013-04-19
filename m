Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967947Ab3DSQaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:30:06 -0400
Received: from multi.imgtec.com ([194.200.65.239]:16464 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968457Ab3DSQaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:30:02 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 3/3] clk: clk-mux: implement remuxing on set_rate
Date: Fri, 19 Apr 2013 17:28:24 +0100
Message-ID: <1366388904-13903-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com>
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_04_19_17_29_55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new clock flag called CLK_SET_RATE_REMUX to indicate that the
clock can have it's parent changed automatically in response to a
set_rate.

Implement clk-mux remuxing if the CLK_SET_RATE_REMUX flag is set. This
implements determine_rate for clk-mux to propagate to each parent and to
choose the best one (like clk-divider this chooses the parent which
provides the fastest rate <= the requested rate).

The determine_rate op is implemented as a core helper function so that
it can be easily used by more complex clocks which incorporate muxes.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/clk/clk-mux.c        |  1 +
 drivers/clk/clk.c            | 49 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk-provider.h |  4 ++++
 3 files changed, 54 insertions(+)

diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 508c032..3a42b96 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -85,6 +85,7 @@ static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
 const struct clk_ops clk_mux_ops = {
 	.get_parent = clk_mux_get_parent,
 	.set_parent = clk_mux_set_parent,
+	.determine_rate = __clk_mux_determine_rate,
 };
 EXPORT_SYMBOL_GPL(clk_mux_ops);
 
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index cc0e618..8c4b714 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -529,6 +529,55 @@ struct clk *__clk_lookup(const char *name)
 	return NULL;
 }
 
+/*
+ * Helper for finding best parent to provide a given frequency. This can be used
+ * directly as a determine_rate callback (e.g. for a mux), or from a more
+ * complex clock that may combine a mux with other operations.
+ */
+long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
+			      unsigned long *best_parent_rate,
+			      struct clk **best_parent_p)
+{
+	struct clk *clk = hw->clk, *parent, *best_parent = NULL;
+	int i, num_parents;
+	unsigned long parent_rate, best = 0;
+
+	/* if remux flag not set, pass through to current parent */
+	if (!(clk->flags & CLK_SET_RATE_REMUX)) {
+		parent = clk->parent;
+		if (clk->flags & CLK_SET_RATE_PARENT)
+			best = __clk_round_rate(parent, rate);
+		else if (parent)
+			best = __clk_get_rate(parent);
+		else
+			best = __clk_get_rate(clk);
+		goto out;
+	}
+
+	/* find the parent that can provide the fastest rate <= rate */
+	num_parents = clk->num_parents;
+	for (i = 0; i < num_parents; i++) {
+		parent = __clk_get_parent_by_index(clk, i);
+		if (!parent)
+			continue;
+		if (clk->flags & CLK_SET_RATE_PARENT)
+			parent_rate = __clk_round_rate(parent, rate);
+		else
+			parent_rate = __clk_get_rate(parent);
+		if (parent_rate <= rate && parent_rate > best) {
+			best_parent = parent;
+			best = parent_rate;
+		}
+	}
+
+out:
+	if (best_parent_p && best_parent)
+		*best_parent_p = best_parent;
+	*best_parent_rate = best;
+
+	return best;
+}
+
 /***        clk api        ***/
 
 void __clk_unprepare(struct clk *clk)
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 5fe1d38..0eb4532 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -27,6 +27,7 @@
 #define CLK_IS_ROOT		BIT(4) /* root clk, has no parent */
 #define CLK_IS_BASIC		BIT(5) /* Basic clk, can't do a to_clk_foo() */
 #define CLK_GET_RATE_NOCACHE	BIT(6) /* do not use the cached clk rate */
+#define CLK_SET_RATE_REMUX	BIT(7) /* find best parent for rate change */
 
 struct clk_hw;
 
@@ -361,6 +362,9 @@ unsigned long __clk_get_rate(struct clk *clk);
 unsigned long __clk_get_flags(struct clk *clk);
 bool __clk_is_enabled(struct clk *clk);
 struct clk *__clk_lookup(const char *name);
+long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
+			      unsigned long *best_parent_rate,
+			      struct clk **best_parent_p);
 
 /*
  * FIXME clock api without lock protection
-- 
1.8.1.2


