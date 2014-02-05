Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaBEIlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:41:14 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:47821 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaBEIlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:41:11 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, mturquette@linaro.org
Cc: b.brezillon@overkiz.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jason@lakedaemon.net,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2 4/4] clk: at91: optimization of the determine_rate callback
Date: Wed,  5 Feb 2014 09:37:38 +0100
Message-Id: <1391589458-28018-5-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391589458-28018-1-git-send-email-jjhiblot@traphandler.com>
References: <1391589458-28018-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/clk/at91/clk-programmable.c | 38 ++++++++-----------------------------
 1 file changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
index 7bcc725..62e2509 100644
--- a/drivers/clk/at91/clk-programmable.c
+++ b/drivers/clk/at91/clk-programmable.c
@@ -139,43 +139,21 @@ static int clk_programmable_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct clk_programmable *prog = to_clk_programmable(hw);
 	struct at91_pmc *pmc = prog->pmc;
 	const struct clk_programmable_layout *layout = prog->layout;
-	unsigned long best_rate = parent_rate;
-	unsigned long best_diff;
-	unsigned long new_diff;
-	unsigned long cur_rate;
+	unsigned long div = parent_rate / rate;
 	int shift = 0;
 	u32 tmp = pmc_read(pmc, AT91_PMC_PCKR(prog->id)) &
 		  ~(PROG_PRES_MASK << layout->pres_shift);
 
-	if (rate > parent_rate)
-		return parent_rate;
-	else
-		best_diff = parent_rate - rate;
+	if (!div)
+		return -EINVAL;
 
-	if (!best_diff) {
-		pmc_write(pmc, AT91_PMC_PCKR(prog->id), tmp | shift);
-		return 0;
-	}
-
-	for (shift = 1; shift < PROG_PRES_MASK; shift++) {
-		cur_rate = parent_rate >> shift;
-
-		if (cur_rate > rate)
-			new_diff = cur_rate - rate;
-		else
-			new_diff = rate - cur_rate;
-
-		if (!new_diff)
-			break;
+	shift = fls(div) - 1;
 
-		if (new_diff < best_diff) {
-			best_diff = new_diff;
-			best_rate = cur_rate;
-		}
+	if (div != (1<<shift))
+		return -EINVAL;
 
-		if (rate > cur_rate)
-			break;
-	}
+	if (shift >= PROG_PRES_MASK)
+		return -EINVAL;
 
 	pmc_write(pmc, AT91_PMC_PCKR(prog->id),
 		  tmp | (shift << layout->pres_shift));
-- 
1.8.5.2

