Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaBQP2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:28:04 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:54978 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbaBQP2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:28:01 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, mturquette@linaro.org
Cc: b.brezillon@overkiz.com, jason@lakedaemon.net,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2] clk: at91: optimization of the set_rate callback
Date: Mon, 17 Feb 2014 16:24:51 +0100
Message-Id: <1392650691-20215-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <52F1FC52.1040205@overkiz.com>
References: <52F1FC52.1040205@overkiz.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---

Hi,
this fixes the commit's log as indicated by Boris.
cheers,
Jean-jacques

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
1.8.5.3

