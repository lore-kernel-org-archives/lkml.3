Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaIEWrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:47:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43539 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaIEWrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:47:40 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH v2 03/15] clk: Add __clk_mux_determine_rate_closest
Date: Fri,  5 Sep 2014 15:47:22 -0700
Message-Id: <1409957256-23729-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
In-Reply-To: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some clock drivers want to find the closest rate on the input of
a mux instead of a rate that's less than or equal to the desired
rate. Add a generic mux function to support this.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c            | 47 +++++++++++++++++++++++++++++++++++---------
 include/linux/clk-provider.h |  9 +++++++--
 2 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index b76fa69b44cb..255ec8c92919 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -712,14 +712,20 @@ struct clk *__clk_lookup(const char *name)
 	return NULL;
 }
 
-/*
- * Helper for finding best parent to provide a given frequency. This can be used
- * directly as a determine_rate callback (e.g. for a mux), or from a more
- * complex clock that may combine a mux with other operations.
- */
-long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
-			      unsigned long *best_parent_rate,
-			      struct clk **best_parent_p)
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
+			     struct clk **best_parent_p,
+			     unsigned long flags)
 {
 	struct clk *clk = hw->clk, *parent, *best_parent = NULL;
 	int i, num_parents;
@@ -747,7 +753,7 @@ long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 			parent_rate = __clk_round_rate(parent, rate);
 		else
 			parent_rate = __clk_get_rate(parent);
-		if (parent_rate <= rate && parent_rate > best) {
+		if (mux_is_better_rate(rate, parent_rate, best, flags)) {
 			best_parent = parent;
 			best = parent_rate;
 		}
@@ -760,8 +766,31 @@ out:
 
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
+			      struct clk **best_parent_p)
+{
+	return clk_mux_determine_rate_flags(hw, rate, best_parent_rate,
+					    best_parent_p, 0);
+}
 EXPORT_SYMBOL_GPL(__clk_mux_determine_rate);
 
+long __clk_mux_determine_rate_closest(struct clk_hw *hw, unsigned long rate,
+			      unsigned long *best_parent_rate,
+			      struct clk **best_parent_p)
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
index 48a92e318542..ba97e25c1115 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -372,6 +372,8 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
  *	register, and mask of mux bits are in higher 16-bit of this register.
  *	While setting the mux bits, higher 16-bit should also be updated to
  *	indicate changing mux bits.
+ * CLK_MUX_ROUND_CLOSEST - Use the parent rate that is closest to the desired
+ *	frequency.
  */
 struct clk_mux {
 	struct clk_hw	hw;
@@ -386,7 +388,8 @@ struct clk_mux {
 #define CLK_MUX_INDEX_ONE		BIT(0)
 #define CLK_MUX_INDEX_BIT		BIT(1)
 #define CLK_MUX_HIWORD_MASK		BIT(2)
-#define CLK_MUX_READ_ONLY	BIT(3) /* mux setting cannot be changed */
+#define CLK_MUX_READ_ONLY		BIT(3) /* mux can't be changed */
+#define CLK_MUX_ROUND_CLOSEST		BIT(4)
 
 extern const struct clk_ops clk_mux_ops;
 extern const struct clk_ops clk_mux_ro_ops;
@@ -529,7 +532,9 @@ struct clk *__clk_lookup(const char *name);
 long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 			      unsigned long *best_parent_rate,
 			      struct clk **best_parent_p);
-
+long __clk_mux_determine_rate_closest(struct clk_hw *hw, unsigned long rate,
+			      unsigned long *best_parent_rate,
+			      struct clk **best_parent_p);
 /*
  * FIXME clock api without lock protection
  */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

