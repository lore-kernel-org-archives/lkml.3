Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaBEIlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:41:11 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43450 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaBEIlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:41:07 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, mturquette@linaro.org
Cc: b.brezillon@overkiz.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jason@lakedaemon.net
Subject: [PATCH v2 1/4] clk: at91: replace prog clk round_rate with determine_rate
Date: Wed,  5 Feb 2014 09:37:35 +0100
Message-Id: <1391589458-28018-2-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391589458-28018-1-git-send-email-jjhiblot@traphandler.com>
References: <1391589458-28018-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <b.brezillon@overkiz.com>

Implement the determine_rate callback to choose the best parent clk that
fulfills the requested rate.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/clk-programmable.c | 56 ++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
index fd792b2..eff7016 100644
--- a/drivers/clk/at91/clk-programmable.c
+++ b/drivers/clk/at91/clk-programmable.c
@@ -102,40 +102,40 @@ static unsigned long clk_programmable_recalc_rate(struct clk_hw *hw,
 	return parent_rate >> prog->pres;
 }
 
-static long clk_programmable_round_rate(struct clk_hw *hw, unsigned long rate,
-					unsigned long *parent_rate)
+static long clk_programmable_determine_rate(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long *best_parent_rate,
+					    struct clk **best_parent_clk)
 {
-	unsigned long best_rate = *parent_rate;
-	unsigned long best_diff;
-	unsigned long new_diff;
-	unsigned long cur_rate;
-	int shift = shift;
-
-	if (rate > *parent_rate)
-		return *parent_rate;
-	else
-		best_diff = *parent_rate - rate;
-
-	if (!best_diff)
-		return best_rate;
+	struct clk *parent = NULL;
+	long best_rate = -EINVAL;
+	unsigned long parent_rate;
+	unsigned long tmp_rate;
+	int shift;
+	int i;
 
-	for (shift = 1; shift < PROG_PRES_MASK; shift++) {
-		cur_rate = *parent_rate >> shift;
+	for (i = 0; i < __clk_get_num_parents(hw->clk); i++) {
+		parent = clk_get_parent_by_index(hw->clk, i);
+		if (!parent)
+			continue;
 
-		if (cur_rate > rate)
-			new_diff = cur_rate - rate;
-		else
-			new_diff = rate - cur_rate;
+		parent_rate = __clk_get_rate(parent);
+		for (shift = 0; shift < PROG_PRES_MASK; shift++) {
+			tmp_rate = parent_rate >> shift;
+			if (tmp_rate <= rate)
+				break;
+		}
 
-		if (!new_diff)
-			return cur_rate;
+		if (tmp_rate > rate)
+			continue;
 
-		if (new_diff < best_diff) {
-			best_diff = new_diff;
-			best_rate = cur_rate;
+		if (best_rate < 0 || (rate - tmp_rate) < (rate - best_rate)) {
+			best_rate = tmp_rate;
+			*best_parent_rate = parent_rate;
+			*best_parent_clk = parent;
 		}
 
-		if (rate > cur_rate)
+		if (!best_rate)
 			break;
 	}
 
@@ -228,7 +228,7 @@ static const struct clk_ops programmable_ops = {
 	.prepare = clk_programmable_prepare,
 	.is_prepared = clk_programmable_is_ready,
 	.recalc_rate = clk_programmable_recalc_rate,
-	.round_rate = clk_programmable_round_rate,
+	.determine_rate = clk_programmable_determine_rate,
 	.get_parent = clk_programmable_get_parent,
 	.set_parent = clk_programmable_set_parent,
 	.set_rate = clk_programmable_set_rate,
-- 
1.8.5.2

