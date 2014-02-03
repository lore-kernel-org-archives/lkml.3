Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaBCL00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 06:26:26 -0500
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:42674 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751072AbaBCLZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:25:41 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH 2/3] clk: at91: replace prog clk round_rate with determine_rate
Date: Mon,  3 Feb 2014 12:25:29 +0100
Message-Id: <1391426731-9392-3-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391426731-9392-1-git-send-email-b.brezillon@overkiz.com>
References: <1391426731-9392-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 8986370107941287966
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrieelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrieelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the determine_rate callback to choose the best parent clk that
fulfills the requested rate.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/clk-programmable.c |   56 +++++++++++++++++------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
index 02f62a0..8e242c7 100644
--- a/drivers/clk/at91/clk-programmable.c
+++ b/drivers/clk/at91/clk-programmable.c
@@ -105,40 +105,40 @@ static unsigned long clk_programmable_recalc_rate(struct clk_hw *hw,
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
 
@@ -231,7 +231,7 @@ static const struct clk_ops programmable_ops = {
 	.prepare = clk_programmable_prepare,
 	.is_prepared = clk_programmable_is_ready,
 	.recalc_rate = clk_programmable_recalc_rate,
-	.round_rate = clk_programmable_round_rate,
+	.determine_rate = clk_programmable_determine_rate,
 	.get_parent = clk_programmable_get_parent,
 	.set_parent = clk_programmable_set_parent,
 	.set_rate = clk_programmable_set_rate,
-- 
1.7.9.5

