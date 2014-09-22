Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbaIVIqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:46:16 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14387 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbaIVIpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:45:45 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/3] UBI: wl: Rename cancel flag to shutdown
Date: Mon, 22 Sep 2014 10:45:35 +0200
Message-Id: <1411375536-20067-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1411375536-20067-1-git-send-email-richard@nod.at>
References: <1411375536-20067-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It confused me more than once that the cancel flag of the
work function does not indicate the cancellation of a single work.
In fact it indicates the WL sub-system shutdown and therefore
worker functions have to free their wl_entries too.
That's why you cannot cancel a single work, you can only shutdown
all works.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/ubi.h |  9 +++++----
 drivers/mtd/ubi/wl.c  | 24 +++++++++++++-----------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 7bf4163..7dad704 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -713,14 +713,15 @@ struct ubi_attach_info {
  * @torture: if the physical eraseblock has to be tortured
  * @anchor: produce a anchor PEB to by used by fastmap
  *
- * The @func pointer points to the worker function. If the @cancel argument is
- * not zero, the worker has to free the resources and exit immediately. The
- * worker has to return zero in case of success and a negative error code in
+ * The @func pointer points to the worker function. If the @shutdown argument is
+ * not zero, the worker has to free the resources and exit immediately as the
+ * WL sub-system is shutting down.
+ * The worker has to return zero in case of success and a negative error code in
  * case of failure.
  */
 struct ubi_work {
 	struct list_head list;
-	int (*func)(struct ubi_device *ubi, struct ubi_work *wrk, int cancel);
+	int (*func)(struct ubi_device *ubi, struct ubi_work *wrk, int shutdown);
 	/* The below fields are only relevant to erasure works */
 	struct ubi_wl_entry *e;
 	int vol_id;
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 20f4917..253ec9b 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -864,7 +864,7 @@ static void schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
 }
 
 static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
-			int cancel);
+			int shutdown);
 
 #ifdef CONFIG_MTD_UBI_FASTMAP
 /**
@@ -990,14 +990,15 @@ int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *fm_e,
  * wear_leveling_worker - wear-leveling worker function.
  * @ubi: UBI device description object
  * @wrk: the work object
- * @cancel: non-zero if the worker has to free memory and exit
+ * @shutdown: non-zero if the worker has to free memory and exit
+ * because the WL-subsystem is shutting down
  *
  * This function copies a more worn out physical eraseblock to a less worn out
  * one. Returns zero in case of success and a negative error code in case of
  * failure.
  */
 static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
-				int cancel)
+				int shutdown)
 {
 	int err, scrubbing = 0, torture = 0, protect = 0, erroneous = 0;
 	int vol_id = -1, uninitialized_var(lnum);
@@ -1008,7 +1009,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 	struct ubi_vid_hdr *vid_hdr;
 
 	kfree(wrk);
-	if (cancel)
+	if (shutdown)
 		return 0;
 
 	vid_hdr = ubi_zalloc_vid_hdr(ubi, GFP_NOFS);
@@ -1407,7 +1408,8 @@ int ubi_ensure_anchor_pebs(struct ubi_device *ubi)
  * erase_worker - physical eraseblock erase worker function.
  * @ubi: UBI device description object
  * @wl_wrk: the work object
- * @cancel: non-zero if the worker has to free memory and exit
+ * @shutdown: non-zero if the worker has to free memory and exit
+ * because the WL sub-system is shutting down
  *
  * This function erases a physical eraseblock and perform torture testing if
  * needed. It also takes care about marking the physical eraseblock bad if
@@ -1415,7 +1417,7 @@ int ubi_ensure_anchor_pebs(struct ubi_device *ubi)
  * failure.
  */
 static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
-			int cancel)
+			int shutdown)
 {
 	struct ubi_wl_entry *e = wl_wrk->e;
 	int pnum = e->pnum;
@@ -1423,7 +1425,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 	int lnum = wl_wrk->lnum;
 	int err, available_consumed = 0;
 
-	if (cancel) {
+	if (shutdown) {
 		dbg_wl("cancel erasure of PEB %d EC %d", pnum, e->ec);
 		kfree(wl_wrk);
 		kmem_cache_free(ubi_wl_entry_slab, e);
@@ -1845,10 +1847,10 @@ int ubi_thread(void *u)
 }
 
 /**
- * cancel_pending - cancel all pending works.
+ * shutdown_work - shutdown all pending works.
  * @ubi: UBI device description object
  */
-static void cancel_pending(struct ubi_device *ubi)
+static void shutdown_work(struct ubi_device *ubi)
 {
 	while (!list_empty(&ubi->works)) {
 		struct ubi_work *wrk;
@@ -1997,7 +1999,7 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	return 0;
 
 out_free:
-	cancel_pending(ubi);
+	shutdown_work(ubi);
 	tree_destroy(&ubi->used);
 	tree_destroy(&ubi->free);
 	tree_destroy(&ubi->scrub);
@@ -2029,7 +2031,7 @@ static void protection_queue_destroy(struct ubi_device *ubi)
 void ubi_wl_close(struct ubi_device *ubi)
 {
 	dbg_wl("close the WL sub-system");
-	cancel_pending(ubi);
+	shutdown_work(ubi);
 	protection_queue_destroy(ubi);
 	tree_destroy(&ubi->used);
 	tree_destroy(&ubi->erroneous);
-- 
1.8.4.5

