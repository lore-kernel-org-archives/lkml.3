Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaCKJBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:01:23 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:61972 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaCKJAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:00:55 -0400
From: Boris BREZILLON <brezillonboris@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH v3 4/4] clk: at91: optimization of the set_rate callback
Date: Tue, 11 Mar 2014 10:00:35 +0100
Message-Id: <1394528435-23734-5-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394528435-23734-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1394528435-23734-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/clk/at91/clk-programmable.c |   38 ++++++++---------------------------
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
1.7.9.5

