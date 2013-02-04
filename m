Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3BDRwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:52:18 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:62262 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3BDRwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:52:16 -0500
Date: Mon, 4 Feb 2013 09:52:10 -0800
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Chas Williams <chas@cmf.nrl.navy.mil>, netdev@vger.kernel.org
Subject: [PATCH v2 02/14] atm/nicstar: don't use idr_remove_all()
Message-ID: <20130204175210.GQ27963@mtj.dyndns.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
 <1359163872-1949-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359163872-1949-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: atm/nicstar: convert to idr_alloc()

Convert to the much saner new idr interface.  The existing code looks
buggy to me - ID 0 is treated as no-ID but allocation specifies 0 as
lower limit and there's no error handling after partial success.  This
conversion keeps the bugs unchanged.

Only compile tested.

v2: id1 and id2 are now directly used for -errno return and thus
    should be signed.  Make them int instead of u32.  This was spotted
    by kbuild test robot.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Chas Williams <chas@cmf.nrl.navy.mil>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: netdev@vger.kernel.org
---
 drivers/atm/nicstar.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -949,7 +949,7 @@ static void free_scq(ns_dev *card, scq_i
 static void push_rxbufs(ns_dev * card, struct sk_buff *skb)
 {
 	struct sk_buff *handle1, *handle2;
-	u32 id1 = 0, id2 = 0;
+	int id1 = 0, id2 = 0;
 	u32 addr1, addr2;
 	u32 stat;
 	unsigned long flags;
@@ -1026,24 +1026,21 @@ static void push_rxbufs(ns_dev * card, s
 				card->lbfqc += 2;
 		}
 
-		do {
-			if (!idr_pre_get(&card->idr, GFP_ATOMIC)) {
-				printk(KERN_ERR
-				       "nicstar%d: no free memory for idr\n",
-				       card->index);
+		if (id1 < 0) {
+			id1 = idr_alloc(&card->idr, handle1, 0, 0, GFP_ATOMIC);
+			if (id1 < 0) {
+				err = id1;
 				goto out;
 			}
+		}
 
-			if (!id1)
-				err = idr_get_new_above(&card->idr, handle1, 0, &id1);
-
-			if (!id2 && err == 0)
-				err = idr_get_new_above(&card->idr, handle2, 0, &id2);
-
-		} while (err == -EAGAIN);
-
-		if (err)
-			goto out;
+		if (id2 < 0) {
+			id2 = idr_alloc(&card->idr, handle2, 0, 0, GFP_ATOMIC);
+			if (id2 < 0) {
+				err = id2;
+				goto out;
+			}
+		}
 
 		spin_lock_irqsave(&card->res_lock, flags);
 		while (CMD_BUSY(card)) ;
