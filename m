Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaESK1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:27:17 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51194 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbaESK1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:27:10 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        davem@davemloft.net
Subject: [PATCH 3/4 V2] atm: idt77252: Remove redundant error check
Date: Mon, 19 May 2014 12:26:52 +0200
Message-Id: <1400495212-9150-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove double checks, convert printk to pr_warn, and move the call to
pr_warn to the first check. The simplified version of the coccinelle
semantic patch that find this issue is as follows:

// <smpl>
@@
expression E; identifier pr; expression list es;
@@
while(...){
...
-       if (E) break;
+       if (E){
+               pr(es);
+               break;
+       }
...
}
- if(E) pr(es);
// </smpl>

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Changes from V1:
 - Convert printk(KERN_WARNING ... to pr_warn(...

 drivers/atm/idt77252.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 1bdf104..b621f56 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2551,12 +2551,12 @@ done:
 		timeout = 5 * 1000;
 		while (atomic_read(&vc->scq->used) > 0) {
 			timeout = msleep_interruptible(timeout);
-			if (!timeout)
+			if (!timeout) {
+				pr_warn("%s: SCQ drain timeout: %u used\n",
+					card->name, atomic_read(&vc->scq->used));
 				break;
+			}
 		}
-		if (!timeout)
-			printk("%s: SCQ drain timeout: %u used\n",
-			       card->name, atomic_read(&vc->scq->used));
 
 		writel(TCMDQ_HALT | vc->index, SAR_REG_TCMDQ);
 		clear_scd(card, vc->scq, vc->class);
-- 
1.8.3.1

