Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838Ab3BFTuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:50:08 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:41009 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964798Ab3BFTuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:00 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 24/77] atm/nicstar: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:39:56 -0800
Message-Id: <1360179649-22465-25-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.  The existing code looks
buggy to me - ID 0 is treated as no-ID but allocation specifies 0 as
lower limit and there's no error handling after partial success.  This
conversion keeps the bugs unchanged.

Only compile tested.

v2: id1 and id2 are now directly used for -errno return and thus
    should be signed.  Make them int instead of u32.  This was spotted
    by kbuild test robot.

v3: Further simplify as suggested by Chas Williams.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Chas Williams <chas@cmf.nrl.navy.mil>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: netdev@vger.kernel.org
---
 drivers/atm/nicstar.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 628787e..6587dc2 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -949,11 +949,10 @@ static void free_scq(ns_dev *card, scq_info *scq, struct atm_vcc *vcc)
 static void push_rxbufs(ns_dev * card, struct sk_buff *skb)
 {
 	struct sk_buff *handle1, *handle2;
-	u32 id1 = 0, id2 = 0;
+	int id1, id2;
 	u32 addr1, addr2;
 	u32 stat;
 	unsigned long flags;
-	int err;
 
 	/* *BARF* */
 	handle2 = NULL;
@@ -1026,23 +1025,12 @@ static void push_rxbufs(ns_dev * card, struct sk_buff *skb)
 				card->lbfqc += 2;
 		}
 
-		do {
-			if (!idr_pre_get(&card->idr, GFP_ATOMIC)) {
-				printk(KERN_ERR
-				       "nicstar%d: no free memory for idr\n",
-				       card->index);
-				goto out;
-			}
-
-			if (!id1)
-				err = idr_get_new_above(&card->idr, handle1, 0, &id1);
-
-			if (!id2 && err == 0)
-				err = idr_get_new_above(&card->idr, handle2, 0, &id2);
-
-		} while (err == -EAGAIN);
+		id1 = idr_alloc(&card->idr, handle1, 0, 0, GFP_ATOMIC);
+		if (id1 < 0)
+			goto out;
 
-		if (err)
+		id2 = idr_alloc(&card->idr, handle2, 0, 0, GFP_ATOMIC);
+		if (id2 < 0)
 			goto out;
 
 		spin_lock_irqsave(&card->res_lock, flags);
-- 
1.8.1

