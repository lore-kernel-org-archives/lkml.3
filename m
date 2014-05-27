Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaE0Q5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:57:00 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40271 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbaE0Q47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:56:59 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] clk: bcm/kona: implement determine_rate()
Date: Tue, 27 May 2014 11:56:56 -0500
Message-Id: <1401209816-24953-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the clk->determine_rate method for Broadcom Kona peripheral
clocks.  This allows a peripheral clock to be re-parented in order to
satisfy a rate change request.  This takes the place of the previous
kona_peri_clk_round_rate() functionality, though that function remains
because it is used by the new one.

The parent clock that allows the peripheral clock to produce a rate
closest to the one requested is the one selected, though the current
parent is used by default.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Added WARN_ON_ONCE() call as suggested.

This patch is based on Mike Turquette's current "clk-next" branch.
    42dd880 Merge branch 'clk-fixes' into clk-next

It is available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/bcm-determine-rate-v2

 drivers/clk/bcm/clk-kona.c | 54 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index d603c4e..95af2e6 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -1031,6 +1031,58 @@ static long kona_peri_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 				rate ? rate : 1, *parent_rate, NULL);
 }
 
+static long kona_peri_clk_determine_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long *best_parent_rate, struct clk **best_parent)
+{
+	struct kona_clk *bcm_clk = to_kona_clk(hw);
+	struct clk *clk = hw->clk;
+	struct clk *current_parent;
+	unsigned long parent_rate;
+	unsigned long best_delta;
+	unsigned long best_rate;
+	u32 parent_count;
+	u32 which;
+
+	/*
+	 * If there is no other parent to choose, use the current one.
+	 * Note:  We don't honor (or use) CLK_SET_RATE_NO_REPARENT.
+	 */
+	WARN_ON_ONCE(bcm_clk->init_data.flags & CLK_SET_RATE_NO_REPARENT);
+	parent_count = (u32)bcm_clk->init_data.num_parents;
+	if (parent_count < 2)
+		return kona_peri_clk_round_rate(hw, rate, best_parent_rate);
+
+	/* Unless we can do better, stick with current parent */
+	current_parent = clk_get_parent(clk);
+	parent_rate = __clk_get_rate(current_parent);
+	best_rate = kona_peri_clk_round_rate(hw, rate, &parent_rate);
+	best_delta = abs(best_rate - rate);
+
+	/* Check whether any other parent clock can produce a better result */
+	for (which = 0; which < parent_count; which++) {
+		struct clk *parent = clk_get_parent_by_index(clk, which);
+		unsigned long delta;
+		unsigned long other_rate;
+
+		BUG_ON(!parent);
+		if (parent == current_parent)
+			continue;
+
+		/* We don't support CLK_SET_RATE_PARENT */
+		parent_rate = __clk_get_rate(parent);
+		other_rate = kona_peri_clk_round_rate(hw, rate, &parent_rate);
+		delta = abs(other_rate - rate);
+		if (delta < best_delta) {
+			best_delta = delta;
+			best_rate = other_rate;
+			*best_parent = parent;
+			*best_parent_rate = parent_rate;
+		}
+	}
+
+	return best_rate;
+}
+
 static int kona_peri_clk_set_parent(struct clk_hw *hw, u8 index)
 {
 	struct kona_clk *bcm_clk = to_kona_clk(hw);
@@ -1135,7 +1187,7 @@ struct clk_ops kona_peri_clk_ops = {
 	.disable = kona_peri_clk_disable,
 	.is_enabled = kona_peri_clk_is_enabled,
 	.recalc_rate = kona_peri_clk_recalc_rate,
-	.round_rate = kona_peri_clk_round_rate,
+	.determine_rate = kona_peri_clk_determine_rate,
 	.set_parent = kona_peri_clk_set_parent,
 	.get_parent = kona_peri_clk_get_parent,
 	.set_rate = kona_peri_clk_set_rate,
-- 
1.9.1

