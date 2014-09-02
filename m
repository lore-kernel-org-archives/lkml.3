Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaIBHvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 03:51:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35639 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751503AbaIBHuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 03:50:24 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 2/5] clk: at91: rework PLL rate calculation
Date: Tue,  2 Sep 2014 09:50:15 +0200
Message-Id: <1409644218-13677-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409644218-13677-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1409644218-13677-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AT91 PLL rate configuration is done by configuring a multiplier/divider
pair.
The previous calculation was over-complicated (and apparently buggy).
Simplify the implementation and add some comments to explain what is done
here.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Gaël PORTAY <gael.portay@gmail.com>
---
 drivers/clk/at91/clk-pll.c | 147 ++++++++++++++++++++++++---------------------
 1 file changed, 77 insertions(+), 70 deletions(-)

diff --git a/drivers/clk/at91/clk-pll.c b/drivers/clk/at91/clk-pll.c
index 7b453b9..a1adcf1 100644
--- a/drivers/clk/at91/clk-pll.c
+++ b/drivers/clk/at91/clk-pll.c
@@ -15,6 +15,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
@@ -29,6 +30,9 @@
 #define PLL_DIV(reg)		((reg) & PLL_DIV_MASK)
 #define PLL_MUL(reg, layout)	(((reg) >> (layout)->mul_shift) & \
 				 (layout)->mul_mask)
+#define PLL_MUL_MIN		2
+#define PLL_MUL_MASK(layout)	((layout)->mul_mask)
+#define PLL_MUL_MAX(layout)	(PLL_MUL_MASK(layout) + 1)
 #define PLL_ICPR_SHIFT(id)	((id) * 16)
 #define PLL_ICPR_MASK(id)	(0xffff << PLL_ICPR_SHIFT(id))
 #define PLL_MAX_COUNT		0x3f
@@ -163,99 +167,102 @@ static long clk_pll_get_best_div_mul(struct clk_pll *pll, unsigned long rate,
 				     unsigned long parent_rate,
 				     u32 *div, u32 *mul,
 				     u32 *index) {
-	unsigned long maxrate;
-	unsigned long minrate;
-	unsigned long divrate;
-	unsigned long bestdiv = 1;
-	unsigned long bestmul;
-	unsigned long tmpdiv;
-	unsigned long roundup;
-	unsigned long rounddown;
-	unsigned long remainder;
-	unsigned long bestremainder;
-	unsigned long maxmul;
-	unsigned long maxdiv;
-	unsigned long mindiv;
-	int i = 0;
 	const struct clk_pll_layout *layout = pll->layout;
 	const struct clk_pll_characteristics *characteristics =
 							pll->characteristics;
+	unsigned long bestremainder = ULONG_MAX;
+	unsigned long maxdiv, mindiv, tmpdiv;
+	long bestrate = -ERANGE;
+	unsigned long bestdiv;
+	unsigned long bestmul;
+	int i = 0;
 
-	/* Minimum divider = 1 */
-	/* Maximum multiplier = max_mul */
-	maxmul = layout->mul_mask + 1;
-	maxrate = (parent_rate * maxmul) / 1;
-
-	/* Maximum divider = max_div */
-	/* Minimum multiplier = 2 */
-	maxdiv = PLL_DIV_MAX;
-	minrate = (parent_rate * 2) / maxdiv;
-
+	/* Check if parent_rate is a valid input rate */
 	if (parent_rate < characteristics->input.min ||
-	    parent_rate < characteristics->input.max)
-		return -ERANGE;
-
-	if (parent_rate < minrate || parent_rate > maxrate)
+	    parent_rate > characteristics->input.max)
 		return -ERANGE;
 
-	for (i = 0; i < characteristics->num_output; i++) {
-		if (parent_rate >= characteristics->output[i].min &&
-		    parent_rate <= characteristics->output[i].max)
-			break;
-	}
-
-	if (i >= characteristics->num_output)
-		return -ERANGE;
-
-	bestmul = rate / parent_rate;
-	rounddown = parent_rate % rate;
-	roundup = rate - rounddown;
-	bestremainder = roundup < rounddown ? roundup : rounddown;
-
-	if (!bestremainder) {
-		if (div)
-			*div = bestdiv;
-		if (mul)
-			*mul = bestmul;
-		if (index)
-			*index = i;
-		return rate;
-	}
-
-	maxdiv = 255 / (bestmul + 1);
-	if (parent_rate / maxdiv < characteristics->input.min)
-		maxdiv = parent_rate / characteristics->input.min;
-	mindiv = parent_rate / characteristics->input.max;
-	if (parent_rate % characteristics->input.max)
-		mindiv++;
-
-	for (tmpdiv = mindiv; tmpdiv < maxdiv; tmpdiv++) {
-		divrate = parent_rate / tmpdiv;
-
-		rounddown = rate % divrate;
-		roundup = divrate - rounddown;
-		remainder = roundup < rounddown ? roundup : rounddown;
-
+	/*
+	 * Calculate minimum divider based on the minimum multiplier, the
+	 * parent_rate and the requested rate.
+	 * Should always be 2 according to the input and output characteristics
+	 * of the PLL blocks.
+	 */
+	mindiv = (parent_rate * PLL_MUL_MIN) / rate;
+	if (!mindiv)
+		mindiv = 1;
+
+	/*
+	 * Calculate the maximum divider which is limited by PLL register
+	 * layout (limited by the MUL or DIV field size).
+	 */
+	maxdiv = DIV_ROUND_UP(parent_rate * PLL_MUL_MAX(layout), rate);
+	if (maxdiv > PLL_DIV_MAX)
+		maxdiv = PLL_DIV_MAX;
+
+	/*
+	 * Iterate over the acceptable divider values to find the best
+	 * divider/multiplier pair (the one that generates the closest
+	 * rate to the requested one).
+	 */
+	for (tmpdiv = mindiv; tmpdiv <= maxdiv; tmpdiv++) {
+		unsigned long remainder;
+		unsigned long tmprate;
+		unsigned long tmpmul;
+
+		/*
+		 * Calculate the multiplier associated with the current
+		 * divider that provide the closest rate to the requested one.
+		 */
+		tmpmul = DIV_ROUND_CLOSEST(rate, parent_rate / tmpdiv);
+		tmprate = (parent_rate / tmpdiv) * tmpmul;
+		if (tmprate > rate)
+			remainder = tmprate - rate;
+		else
+			remainder = rate - tmprate;
+
+		/*
+		 * Compare the remainder with the best remainder found until
+		 * now and elect a new best multiplier/divider pair if the
+		 * current remainder is smaller than the best one.
+		 */
 		if (remainder < bestremainder) {
 			bestremainder = remainder;
-			bestmul = rate / divrate;
 			bestdiv = tmpdiv;
+			bestmul = tmpmul;
+			bestrate = tmprate;
 		}
 
+		/*
+		 * We've found a perfect match!
+		 * Stop searching now and use this multiplier/divider pair.
+		 */
 		if (!remainder)
 			break;
 	}
 
-	rate = (parent_rate / bestdiv) * bestmul;
+	/* We haven't found any multiplier/divider pair => return -ERANGE */
+	if (bestrate < 0)
+		return bestrate;
+
+	/* Check if bestrate is a valid output rate  */
+	for (i = 0; i < characteristics->num_output; i++) {
+		if (bestrate >= characteristics->output[i].min &&
+		    bestrate <= characteristics->output[i].max)
+			break;
+	}
+
+	if (i >= characteristics->num_output)
+		return -ERANGE;
 
 	if (div)
 		*div = bestdiv;
 	if (mul)
-		*mul = bestmul;
+		*mul = bestmul - 1;
 	if (index)
 		*index = i;
 
-	return rate;
+	return bestrate;
 }
 
 static long clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-- 
1.9.1

