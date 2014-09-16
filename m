Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaIPN0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:26:52 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14387 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbaIPN0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:26:50 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] UBI: Get rid of __schedule_ubi_work()
Date: Tue, 16 Sep 2014 15:26:38 +0200
Message-Id: <1410873998-2955-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1410873998-2955-1-git-send-email-richard@nod.at>
References: <1410873998-2955-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we got rid of work_sem held in workers we can remove
__schedule_ubi_work() too.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index b1e2ed1..ba15d33 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -830,15 +830,16 @@ repeat:
 }
 
 /**
- * __schedule_ubi_work - schedule a work.
+ * schedule_ubi_work - schedule a work.
  * @ubi: UBI device description object
  * @wrk: the work to schedule
  *
  * This function adds a work defined by @wrk to the tail of the pending works
- * list. Can only be used of ubi->work_sem is already held in read mode!
+ * list.
  */
-static void __schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
+static void schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
 {
+	down_read(&ubi->work_sem);
 	spin_lock(&ubi->wl_lock);
 	list_add_tail(&wrk->list, &ubi->works);
 	ubi_assert(ubi->works_count >= 0);
@@ -846,20 +847,6 @@ static void __schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
 	if (ubi->thread_enabled && !ubi_dbg_is_bgt_disabled(ubi))
 		wake_up_process(ubi->bgt_thread);
 	spin_unlock(&ubi->wl_lock);
-}
-
-/**
- * schedule_ubi_work - schedule a work.
- * @ubi: UBI device description object
- * @wrk: the work to schedule
- *
- * This function adds a work defined by @wrk to the tail of the pending works
- * list.
- */
-static void schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
-{
-	down_read(&ubi->work_sem);
-	__schedule_ubi_work(ubi, wrk);
 	up_read(&ubi->work_sem);
 }
 
@@ -1304,13 +1291,12 @@ out_cancel:
 /**
  * ensure_wear_leveling - schedule wear-leveling if it is needed.
  * @ubi: UBI device description object
- * @nested: set to non-zero if this function is called from UBI worker
  *
  * This function checks if it is time to start wear-leveling and schedules it
  * if yes. This function returns zero in case of success and a negative error
  * code in case of failure.
  */
-static int ensure_wear_leveling(struct ubi_device *ubi, int nested)
+static int ensure_wear_leveling(struct ubi_device *ubi)
 {
 	int err = 0;
 	struct ubi_wl_entry *e1;
@@ -1357,10 +1343,7 @@ static int ensure_wear_leveling(struct ubi_device *ubi, int nested)
 
 	wrk->anchor = 0;
 	wrk->func = &wear_leveling_worker;
-	if (nested)
-		__schedule_ubi_work(ubi, wrk);
-	else
-		schedule_ubi_work(ubi, wrk);
+	schedule_ubi_work(ubi, wrk);
 	return err;
 
 out_cancel:
@@ -1452,7 +1435,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 		serve_prot_queue(ubi);
 
 		/* And take care about wear-leveling */
-		err = ensure_wear_leveling(ubi, 0);
+		err = ensure_wear_leveling(ubi);
 		return err;
 	}
 
@@ -1690,7 +1673,7 @@ retry:
 	 * Technically scrubbing is the same as wear-leveling, so it is done
 	 * by the WL worker.
 	 */
-	return ensure_wear_leveling(ubi, 0);
+	return ensure_wear_leveling(ubi);
 }
 
 /**
@@ -1991,7 +1974,7 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	ubi->rsvd_pebs += reserved_pebs;
 
 	/* Schedule wear-leveling if needed */
-	err = ensure_wear_leveling(ubi, 0);
+	err = ensure_wear_leveling(ubi);
 	if (err)
 		goto out_free;
 
-- 
1.8.4.5

