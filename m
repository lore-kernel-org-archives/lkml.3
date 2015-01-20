Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbbATCFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:05:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41465 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbbATCFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:05:39 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 1/8] clk: Add __clk_mux_determine_rate_closest
Date: Mon, 19 Jan 2015 18:05:28 -0800
Message-Id: <1421719535-28398-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
In-Reply-To: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
References: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some clock drivers want to find the closest rate on the input of
a mux instead of a rate that's less than or equal to the desired
rate. Add a generic mux function to support this.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c            | 47 +++++++++++++++++++++++++++++++++++---------
 include/linux/clk-provider.h |  8 +++++++-
 2 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f4963b7d4e17..bd46e3ba2771 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -694,14 +694,20 @@ struct clk *__clk_lookup(const char *name)
 	return NULL;
 }
 
-/*
- * Helper for finding best parent to provide a given frequency. This can be used
- * directly as a determine_rate callback (e.g. for a mux), or from a more
- * complex clock that may combine a mux with other operations.
- */
-long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
-			      unsigned long *best_parent_rate,
-			      struct clk_hw **best_parent_p)
+static bool mux_is_better_rate(unsigned long rate, unsigned long now,
+			   unsigned long best, unsigned long flags)
+{
+	if (flags & CLK_MUX_ROUND_CLOSEST)
+		return abs(now - rate) < abs(best - rate);
+
+	return now <= rate && now > best;
+}
+
+static long
+clk_mux_determine_rate_flags(struct clk_hw *hw, unsigned long rate,
+			     unsigned long *best_parent_rate,
+			     struct clk_hw **best_parent_p,
+			     unsigned long flags)
 {
 	struct clk *clk = hw->clk, *parent, *best_parent = NULL;
 	int i, num_parents;
@@ -729,7 +735,7 @@ long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 			parent_rate = __clk_round_rate(parent, rate);
 		else
 			parent_rate = __clk_get_rate(parent);
-		if (parent_rate <= rate && parent_rate > best) {
+		if (mux_is_better_rate(rate, parent_rate, best, flags)) {
 			best_parent = parent;
 			best = parent_rate;
 		}
@@ -742,8 +748,31 @@ out:
 
 	return best;
 }
+
+/*
+ * Helper for finding best parent to provide a given frequency. This can be used
+ * directly as a determine_rate callback (e.g. for a mux), or from a more
+ * complex clock that may combine a mux with other operations.
+ */
+long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
+			      unsigned long *best_parent_rate,
+			      struct clk_hw **best_parent_p)
+{
+	return clk_mux_determine_rate_flags(hw, rate, best_parent_rate,
+					    best_parent_p, 0);
+}
 EXPORT_SYMBOL_GPL(__clk_mux_determine_rate);
 
+long __clk_mux_determine_rate_closest(struct clk_hw *hw, unsigned long rate,
+			      unsigned long *best_parent_rate,
+			      struct clk_hw **best_parent_p)
+{
+	return clk_mux_determine_rate_flags(hw, rate, best_parent_rate,
+					    best_parent_p,
+					    CLK_MUX_ROUND_CLOSEST);
+}
+EXPORT_SYMBOL_GPL(__clk_mux_determine_rate_closest);
+
 /***        clk api        ***/
 
 void __clk_unprepare(struct clk *clk)
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index d936409520f8..d2523f42f4e4 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -382,6 +382,8 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
  *	register, and mask of mux bits are in higher 16-bit of this register.
  *	While setting the mux bits, higher 16-bit should also be updated to
  *	indicate changing mux bits.
+ * CLK_MUX_ROUND_CLOSEST - Use the parent rate that is closest to the desired
+ *	frequency.
  */
 struct clk_mux {
 	struct clk_hw	hw;
@@ -396,7 +398,8 @@ struct clk_mux {
 #define CLK_MUX_INDEX_ONE		BIT(0)
 #define CLK_MUX_INDEX_BIT		BIT(1)
 #define CLK_MUX_HIWORD_MASK		BIT(2)
-#define CLK_MUX_READ_ONLY	BIT(3) /* mux setting cannot be changed */
+#define CLK_MUX_READ_ONLY		BIT(3) /* mux can't be changed */
+#define CLK_MUX_ROUND_CLOSEST		BIT(4)
 
 extern const struct clk_ops clk_mux_ops;
 extern const struct clk_ops clk_mux_ro_ops;
@@ -552,6 +555,9 @@ struct clk *__clk_lookup(const char *name);
 long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 			      unsigned long *best_parent_rate,
 			      struct clk_hw **best_parent_p);
+long __clk_mux_determine_rate_closest(struct clk_hw *hw, unsigned long rate,
+			      unsigned long *best_parent_rate,
+			      struct clk_hw **best_parent_p);
 
 /*
  * FIXME clock api without lock protection
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

