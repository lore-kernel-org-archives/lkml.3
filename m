Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3ETN3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:29:17 -0400
Received: from multi.imgtec.com ([194.200.65.239]:44987 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712Ab3ETN3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:29:15 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v4 5/5] clk: clk-mux: implement remuxing on set_rate
Date: Mon, 20 May 2013 14:28:27 +0100
Message-ID: <1369056507-32521-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com>
References: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_20_14_29_12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement clk-mux remuxing if the CLK_SET_RATE_NO_REPARENT flag isn't
set. This implements determine_rate for clk-mux to propagate to each
parent and to choose the best one (like clk-divider this chooses the
parent which provides the fastest rate <= the requested rate).

The determine_rate op is implemented as a core helper function so that
it can be easily used by more complex clocks which incorporate muxes.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
---
Changes in v4:

* never pass NULL to determine_rate's best_parent_clk parameter.

Changes in v3:

* rename/invert CLK_SET_RATE_REMUX to CLK_SET_RATE_NO_REPARENT and move
  to patch 3.

 drivers/clk/clk-mux.c        |  1 +
 drivers/clk/clk.c            | 49 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk-provider.h |  3 +++
 3 files changed, 53 insertions(+)

diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 25b1734..cecfa01 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -100,6 +100,7 @@ static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
 const struct clk_ops clk_mux_ops = {
 	.get_parent = clk_mux_get_parent,
 	.set_parent = clk_mux_set_parent,
+	.determine_rate = __clk_mux_determine_rate,
 };
 EXPORT_SYMBOL_GPL(clk_mux_ops);
 
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 3ce4810..85b661d 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -692,6 +692,55 @@ struct clk *__clk_lookup(const char *name)
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
+	/* if NO_REPARENT flag set, pass through to current parent */
+	if (clk->flags & CLK_SET_RATE_NO_REPARENT) {
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
+		parent = clk_get_parent_by_index(clk, i);
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
+	if (best_parent)
+		*best_parent_p = best_parent;
+	*best_parent_rate = best;
+
+	return best;
+}
+
 /***        clk api        ***/
 
 void __clk_unprepare(struct clk *clk)
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index bb2d812..d6057eb 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -419,6 +419,9 @@ unsigned long __clk_get_flags(struct clk *clk);
 bool __clk_is_prepared(struct clk *clk);
 bool __clk_is_enabled(struct clk *clk);
 struct clk *__clk_lookup(const char *name);
+long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
+			      unsigned long *best_parent_rate,
+			      struct clk **best_parent_p);
 
 /*
  * FIXME clock api without lock protection
-- 
1.8.1.2


