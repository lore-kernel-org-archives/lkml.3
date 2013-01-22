Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3AVQkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:40:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44896 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab3AVQks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:40:48 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] clk: divider: handle minimum divider
Date: Tue, 22 Jan 2013 22:10:43 +0530
Message-ID: <6723eb0c815bab677aac508dcdc5c15ef1d279a5.1358870920.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <d20165dfc67970c3429b9d95ac9631015f8b2396.1358870920.git.afzal@ti.com>
References: <d20165dfc67970c3429b9d95ac9631015f8b2396.1358870920.git.afzal@ti.com>
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
index 0b34992..2de9ff5 100644
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

