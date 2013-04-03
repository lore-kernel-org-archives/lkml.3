Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab3DCTRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:17:31 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:19391
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762074Ab3DCTR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:17:29 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] clk: Properly handle notifier return values
Date: Wed, 3 Apr 2013 12:17:12 -0700
X-Mailer: git-send-email 1.8.2
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <a2f153b2-9266-4ddc-94a9-3efbcbe9768c@CH1EHSMHS018.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Notifiers may return NOTIFY_(OK|DONE|STOP|BAD). The CCF uses an
inconsistent mix of checking against NOTIFY_STOP or NOTIFY_BAD.
This inconsistency leaves errors undetected in some cases:
clk_set_parent() calls __clk_speculate_rates(), which stops when it
hits a NOTIFIER_BAD (STOP is ignored), and passes this value back to the
caller.
clk_set_parent() compares this return value against NOTIFY_STOP only,
ignoring NOTIFY_BAD returns.

Use NOTIFY_STOP_MASK to detect a negative notifier return value and
document all four return value options.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clk/clk.c   | 10 +++++-----
 include/linux/clk.h |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ed87b24..68bd38c 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -876,16 +876,16 @@ static int __clk_speculate_rates(struct clk *clk, unsigned long parent_rate)
 	else
 		new_rate = parent_rate;
 
-	/* abort the rate change if a driver returns NOTIFY_BAD */
+	/* abort rate change if a driver returns NOTIFY_BAD or NOTIFY_STOP */
 	if (clk->notifier_count)
 		ret = __clk_notify(clk, PRE_RATE_CHANGE, clk->rate, new_rate);
 
-	if (ret == NOTIFY_BAD)
+	if (ret & NOTIFY_STOP_MASK)
 		goto out;
 
 	hlist_for_each_entry(child, &clk->children, child_node) {
 		ret = __clk_speculate_rates(child, new_rate);
-		if (ret == NOTIFY_BAD)
+		if (ret & NOTIFY_STOP_MASK)
 			break;
 	}
 
@@ -978,7 +978,7 @@ static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long even
 
 	if (clk->notifier_count) {
 		ret = __clk_notify(clk, event, clk->rate, clk->new_rate);
-		if (ret == NOTIFY_BAD)
+		if (ret & NOTIFY_STOP_MASK)
 			fail_clk = clk;
 	}
 
@@ -1296,7 +1296,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 		ret = __clk_speculate_rates(clk, parent->rate);
 
 	/* abort if a driver objects */
-	if (ret == NOTIFY_STOP)
+	if (ret & NOTIFY_STOP_MASK)
 		goto out;
 
 	/* only re-parent if the clock is not in use */
diff --git a/include/linux/clk.h b/include/linux/clk.h
index b3ac22d..9a6d045 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -28,16 +28,16 @@ struct clk;
  * PRE_RATE_CHANGE - called immediately before the clk rate is changed,
  *     to indicate that the rate change will proceed.  Drivers must
  *     immediately terminate any operations that will be affected by the
- *     rate change.  Callbacks may either return NOTIFY_DONE or
- *     NOTIFY_STOP.
+ *     rate change.  Callbacks may either return NOTIFY_DONE, NOTIFY_OK,
+ *     NOTIFY_STOP or NOTIFY_BAD.
  *
  * ABORT_RATE_CHANGE: called if the rate change failed for some reason
  *     after PRE_RATE_CHANGE.  In this case, all registered notifiers on
  *     the clk will be called with ABORT_RATE_CHANGE. Callbacks must
- *     always return NOTIFY_DONE.
+ *     always return NOTIFY_DONE or NOTIFY_OK.
  *
  * POST_RATE_CHANGE - called after the clk rate change has successfully
- *     completed.  Callbacks must always return NOTIFY_DONE.
+ *     completed.  Callbacks must always return NOTIFY_DONE or NOTIFY_OK.
  *
  */
 #define PRE_RATE_CHANGE			BIT(0)
-- 
1.8.2


