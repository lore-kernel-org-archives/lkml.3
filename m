Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbaIWWGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:06:44 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaIWWGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:06:38 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        ricard.wanderlof@axis.com, aschmidt@dekaresearch.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] [RFC] UBI: Implement bitrot checking
Date: Wed, 24 Sep 2014 00:06:16 +0200
Message-Id: <1411509976-12636-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1411509976-12636-1-git-send-email-richard@nod.at>
References: <1411509976-12636-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements bitrot checking for UBI.
ubi_wl_trigger_bitrot_check() triggers a re-read of every
PEB which is currently in use.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/debug.c |   3 ++
 drivers/mtd/ubi/eba.c   |   2 +-
 drivers/mtd/ubi/ubi.h   |   3 +-
 drivers/mtd/ubi/wl.c    | 115 ++++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 112 insertions(+), 11 deletions(-)

diff --git a/drivers/mtd/ubi/debug.c b/drivers/mtd/ubi/debug.c
index 63cb1d7..80d7832 100644
--- a/drivers/mtd/ubi/debug.c
+++ b/drivers/mtd/ubi/debug.c
@@ -332,6 +332,9 @@ static ssize_t dfs_file_write(struct file *file, const char __user *user_buf,
 		goto out;
 	}
 
+	//XXX
+	ubi_wl_trigger_bitrot_check(ubi);
+
 	if (dent == d->dfs_chk_gen)
 		d->chk_gen = val;
 	else if (dent == d->dfs_chk_io)
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 0e11671d..78109e7 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -468,7 +468,7 @@ retry:
 	}
 
 	if (scrub)
-		err = ubi_wl_scrub_peb(ubi, pnum);
+		err = ubi_wl_scrub_peb(ubi, pnum, 0);
 
 	leb_read_unlock(ubi, vol_id, lnum);
 	return err;
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 7bf4163..ad004bd 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -806,7 +806,7 @@ int ubi_wl_get_peb(struct ubi_device *ubi);
 int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
 		   int pnum, int torture);
 int ubi_wl_flush(struct ubi_device *ubi, int vol_id, int lnum);
-int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
+int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum, int nested);
 int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai);
 void ubi_wl_close(struct ubi_device *ubi);
 int ubi_thread(void *u);
@@ -816,6 +816,7 @@ int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *used_e,
 int ubi_is_erase_work(struct ubi_work *wrk);
 void ubi_refill_pools(struct ubi_device *ubi);
 int ubi_ensure_anchor_pebs(struct ubi_device *ubi);
+void ubi_wl_trigger_bitrot_check(struct ubi_device *ubi);
 
 /* io.c */
 int ubi_io_read(const struct ubi_device *ubi, void *buf, int pnum, int offset,
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 20f4917..80e451f 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -325,6 +325,20 @@ static int in_wl_tree(struct ubi_wl_entry *e, struct rb_root *root)
 	return 0;
 }
 
+static inline int in_pg(const struct ubi_device *ubi, struct ubi_wl_entry *e)
+{
+	struct ubi_wl_entry *p;
+	int i;
+
+	for (i = 0; i < UBI_PROT_QUEUE_LEN; ++i)
+		list_for_each_entry(p, &ubi->pq[i], u.list)
+			if (p == e)
+				return 1;
+
+	return 0;
+}
+
+
 /**
  * prot_queue_add - add physical eraseblock to the protection queue.
  * @ubi: UBI device description object
@@ -914,6 +928,93 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 }
 
 /**
+ * bitrot_check_worker - physical eraseblock bitrot check worker function.
+ * @ubi: UBI device description object
+ * @wl_wrk: the work object
+ * @shutdown: non-zero if the worker has to free memory and exit
+ *
+ * This function read a physical eraseblock and schedules scrubbing if
+ * bit flips are detected.
+ */
+static int bitrot_check_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
+			 int shutdown)
+{
+	struct ubi_wl_entry *e = wl_wrk->e;
+	int err;
+
+	kfree(wl_wrk);
+	if (shutdown) {
+		dbg_wl("cancel bitrot check of PEB %d", e->pnum);
+		kmem_cache_free(ubi_wl_entry_slab, e);
+		return 0;
+	}
+
+	if (!in_wl_tree(e, &ubi->used) && !in_pg(ubi, e)) {
+		dbg_wl("PEB %d not in used tree nor in protection queue", e->pnum);
+		return 0;
+	}
+
+	mutex_lock(&ubi->buf_mutex);
+	err = ubi_io_read(ubi, ubi->peb_buf, e->pnum, 0, ubi->peb_size);
+	mutex_unlock(&ubi->buf_mutex);
+	if (err == UBI_IO_BITFLIPS)
+		err = ubi_wl_scrub_peb(ubi, e->pnum, 1);
+	else
+		/* Ignore read errors as we return only work related errors.
+		 * Read errors will be logged by ubi_io_read(). */
+		err = 0;
+
+	return err;
+}
+
+/**
+ * schedule_bitrot_check - schedule a bitrot check work.
+ * @ubi: UBI device description object
+ * @e: the WL entry of the physical eraseblock to check
+ *
+ * This function returns zero in case of success and a %-ENOMEM in case of
+ * failure.
+ */
+static int schedule_bitrot_check(struct ubi_device *ubi,
+				 struct ubi_wl_entry *e)
+{
+	struct ubi_work *wl_wrk;
+
+	ubi_assert(e);
+
+	dbg_wl("schedule bitrot check of PEB %d", e->pnum);
+
+	wl_wrk = kmalloc(sizeof(struct ubi_work), GFP_NOFS);
+	if (!wl_wrk)
+		return -ENOMEM;
+
+	wl_wrk->func = &bitrot_check_worker;
+	wl_wrk->e = e;
+
+	schedule_ubi_work(ubi, wl_wrk);
+	return 0;
+}
+
+/**
+ * ubi_wl_trigger_bitrot_check - triggers a re-read of all physical erase
+ * blocks in use.
+ * @ubi: UBI device description object
+ */
+void ubi_wl_trigger_bitrot_check(struct ubi_device *ubi)
+{
+	int i;
+	struct ubi_wl_entry *e;
+
+	for (i = 0; i < ubi->peb_count; i++) {
+		spin_lock(&ubi->wl_lock);
+		e = ubi->lookuptbl[i];
+		spin_unlock(&ubi->wl_lock);
+		if (e)
+			schedule_bitrot_check(ubi, e);
+	}
+}
+
+/**
  * do_sync_erase - run the erase worker synchronously.
  * @ubi: UBI device description object
  * @e: the WL entry of the physical eraseblock to erase
@@ -1634,13 +1735,14 @@ retry:
  * ubi_wl_scrub_peb - schedule a physical eraseblock for scrubbing.
  * @ubi: UBI device description object
  * @pnum: the physical eraseblock to schedule
+ * @nested: set to non-zero if this function is called from UBI worker
  *
  * If a bit-flip in a physical eraseblock is detected, this physical eraseblock
  * needs scrubbing. This function schedules a physical eraseblock for
  * scrubbing which is done in background. This function returns zero in case of
  * success and a negative error code in case of failure.
  */
-int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum)
+int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum, int nested)
 {
 	struct ubi_wl_entry *e;
 
@@ -1690,7 +1792,7 @@ retry:
 	 * Technically scrubbing is the same as wear-leveling, so it is done
 	 * by the WL worker.
 	 */
-	return ensure_wear_leveling(ubi, 0);
+	return ensure_wear_leveling(ubi, nested);
 }
 
 /**
@@ -2117,16 +2219,11 @@ static int self_check_in_wl_tree(const struct ubi_device *ubi,
 static int self_check_in_pq(const struct ubi_device *ubi,
 			    struct ubi_wl_entry *e)
 {
-	struct ubi_wl_entry *p;
-	int i;
-
 	if (!ubi_dbg_chk_gen(ubi))
 		return 0;
 
-	for (i = 0; i < UBI_PROT_QUEUE_LEN; ++i)
-		list_for_each_entry(p, &ubi->pq[i], u.list)
-			if (p == e)
-				return 0;
+	if (!in_pg(ubi, e))
+		return 0;
 
 	ubi_err("self-check failed for PEB %d, EC %d, Protect queue",
 		e->pnum, e->ec);
-- 
1.8.4.5

