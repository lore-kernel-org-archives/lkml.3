Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaBZLC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:02:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:62707 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaBZLCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:02:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: [PATCH 11/16] atm: firestream: fix interruptible_sleep_on race
Date: Wed, 26 Feb 2014 12:01:51 +0100
Message-Id: <1393412516-3762435-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:i8mXTwYredDVP+AwF62Aju1Ktj759g4ve2ZVRecBLh/
 KpUMdEyG2vhyKRwIGUFoAuJ49xY9Bm8dfzInu53Dh/rZdGqM4i
 JrymDKRUOQFtg2kFRNPtzNG7YfyJ5uQZgElgZHiTc/eE3ZwX+T
 Dz/iTjPQO0gFqmGh+VlVxFx7CezIrj6ix3i4Wvr9Qdl+UmirDX
 944Ac7T03Qw2B1oOScttgFn65c0bYDndl86wQ1aXnygAe8um4a
 OrRc6Kdm9veUwrMVLuhs3L8XWfMNZiS6ZyXPZGE6Mlzy0X+aRE
 JgCD7C1m5algHTd16LtQ8srV40Bl7lvlrgrnRqdMO9YlDguIbu
 r1iLvu+St+4f3jBttK8vYKay38D5Q+RCTylZcX9lD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interruptible_sleep_on is racy and going away. This replaces the one use
in the firestream driver with the appropriate wait_event_interruptible
variant.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: linux-atm-general@lists.sourceforge.net
Cc: netdev@vger.kernel.org
---
 drivers/atm/firestream.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index b41c948..f43e1c1 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -736,8 +736,8 @@ static void process_txdone_queue (struct fs_dev *dev, struct queue *q)
       
 			skb = td->skb;
 			if (skb == FS_VCC (ATM_SKB(skb)->vcc)->last_skb) {
-				wake_up_interruptible (& FS_VCC (ATM_SKB(skb)->vcc)->close_wait);
 				FS_VCC (ATM_SKB(skb)->vcc)->last_skb = NULL;
+				wake_up_interruptible (& FS_VCC (ATM_SKB(skb)->vcc)->close_wait);
 			}
 			td->dev->ntxpckts--;
 
@@ -1123,7 +1123,7 @@ static void fs_close(struct atm_vcc *atm_vcc)
 		   this sleep_on, we'll lose any reference to these packets. Memory leak!
 		   On the other hand, it's awfully convenient that we can abort a "close" that
 		   is taking too long. Maybe just use non-interruptible sleep on? -- REW */
-		interruptible_sleep_on (& vcc->close_wait);
+		wait_event_interruptible(vcc->close_wait, !vcc->last_skb);
 	}
 
 	txtp = &atm_vcc->qos.txtp;
-- 
1.8.3.2

