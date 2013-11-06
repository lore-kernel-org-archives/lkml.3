Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab3KFLHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:07:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44825 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab3KFLHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:07:53 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH] clk: divider: fix rate calculation for fractional rates
Date: Wed, 6 Nov 2013 13:06:48 +0200
Message-ID: <1383736008-22764-1-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk-divider.c does not calculate the rates consistently at the moment.

As an example, on OMAP3 we have a clock divider with a source clock of
864000000 Hz. With dividers 6, 7 and 8 the theoretical rates are:

6: 144000000
7: 123428571.428571...
8: 108000000

Calling clk_round_rate() with the rate in the first column will give the
rate in the second column:

144000000 -> 144000000
143999999 -> 123428571
123428572 -> 123428571
123428571 -> 108000000

Note how clk_round_rate() returns 123428571 for rates from 123428572 to
143999999, which is mathematically correct, but when clk_round_rate() is
called with 123428571, the returned value is surprisingly 108000000.

This means that the following code works a bit oddly:

rate = clk_round_rate(clk, 123428572);
clk_set_rate(clk, rate);

As clk_set_rate() also does clock rate rounding, the result is that the
clock is set to the rate of 108000000, not 123428571 returned by the
clk_round_rate.

This patch changes the clk-divider.c to use DIV_ROUND_UP when
calculating the rate. This gives the following behavior which fixes the
inconsistency:

144000000 -> 144000000
143999999 -> 123428572
123428572 -> 123428572
123428571 -> 108000000

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/clk-divider.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 8d3009e..43348f3 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -24,7 +24,7 @@
  * Traits of this clock:
  * prepare - clk_prepare only ensures that parents are prepared
  * enable - clk_enable only ensures that parents are enabled
- * rate - rate is adjustable.  clk->rate = parent->rate / divisor
+ * rate - rate is adjustable.  clk->rate = DIV_ROUND_UP(parent->rate / divisor)
  * parent - fixed parent.  No clk_set_parent support
  */
 
@@ -115,7 +115,7 @@ static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
 		return parent_rate;
 	}
 
-	return parent_rate / div;
+	return DIV_ROUND_UP(parent_rate, div);
 }
 
 /*
@@ -185,7 +185,7 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 		}
 		parent_rate = __clk_round_rate(__clk_get_parent(hw->clk),
 				MULT_ROUND_UP(rate, i));
-		now = parent_rate / i;
+		now = DIV_ROUND_UP(parent_rate, i);
 		if (now <= rate && now > best) {
 			bestdiv = i;
 			best = now;
@@ -207,7 +207,7 @@ static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
 	int div;
 	div = clk_divider_bestdiv(hw, rate, prate);
 
-	return *prate / div;
+	return DIV_ROUND_UP(*prate, div);
 }
 
 static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -218,7 +218,7 @@ static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 	unsigned long flags = 0;
 	u32 val;
 
-	div = parent_rate / rate;
+	div = DIV_ROUND_UP(parent_rate, rate);
 	value = _get_val(divider, div);
 
 	if (value > div_mask(divider))
-- 
1.8.3.2

