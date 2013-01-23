Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3AWLjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:39:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44189 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab3AWLjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:39:08 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v2 2/2] clk: divider: handle minimum divider
Date: Wed, 23 Jan 2013 17:09:01 +0530
Message-ID: <9e6a498d23f5768e2e9d57bfe13c4f9434bf74d8.1358937138.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <6dc1c48cac5b2646a55da3079afb72f88e40c3bc.1358937138.git.afzal@ti.com>
References: <6dc1c48cac5b2646a55da3079afb72f88e40c3bc.1358937138.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of clocks can have a limit on minimum divider value that can be
programmed. Modify basic clock divider to take care of this aspect.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/clk/clk-divider.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 4025c5a..ee648dc 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -32,6 +32,11 @@
 #define div_mask(d)	((1 << (d->width)) - 1)
 #define is_power_of_two(i)	!(i & ~i)
 
+static unsigned int _get_mindiv(struct clk_divider *divider)
+{
+	return divider->min_div;
+}
+
 static unsigned int _get_table_maxdiv(const struct clk_div_table *table)
 {
 	unsigned int maxdiv = 0;
@@ -148,17 +153,18 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 {
 	struct clk_divider *divider = to_clk_divider(hw);
 	int i, bestdiv = 0;
-	unsigned long parent_rate, best = 0, now, maxdiv;
+	unsigned long parent_rate, best = 0, now, maxdiv, mindiv;
 
 	if (!rate)
 		rate = 1;
 
 	maxdiv = _get_maxdiv(divider);
+	mindiv = _get_mindiv(divider);
 
 	if (!(__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT)) {
 		parent_rate = *best_parent_rate;
 		bestdiv = DIV_ROUND_UP(parent_rate, rate);
-		bestdiv = bestdiv == 0 ? 1 : bestdiv;
+		bestdiv = bestdiv == 0 ? mindiv : bestdiv;
 		bestdiv = bestdiv > maxdiv ? maxdiv : bestdiv;
 		return bestdiv;
 	}
@@ -169,7 +175,7 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 	 */
 	maxdiv = min(ULONG_MAX / rate, maxdiv);
 
-	for (i = 1; i <= maxdiv; i++) {
+	for (i = mindiv; i <= maxdiv; i++) {
 		if (!_is_valid_div(divider, i))
 			continue;
 		parent_rate = __clk_round_rate(__clk_get_parent(hw->clk),
-- 
1.7.12

