Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580Ab3CSRSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:18:31 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44704 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933338Ab3CSRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 11/18] drbd: split drbd_al_begin_io into fastpath, prepare, and commit
Date: Tue, 19 Mar 2013 18:16:52 +0100
Message-Id: <1363713419-17803-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |  104 ++++++++++++++++++++++++++------------
 drivers/block/drbd/drbd_int.h    |    1 +
 2 files changed, 72 insertions(+), 33 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 1d7244d..e4f1231 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -104,7 +104,6 @@ struct update_al_work {
 	int err;
 };
 
-static int al_write_transaction(struct drbd_conf *mdev, bool delegate);
 
 void *drbd_md_get_buffer(struct drbd_conf *mdev)
 {
@@ -246,30 +245,37 @@ static struct lc_element *_al_get(struct drbd_conf *mdev, unsigned int enr)
 	return al_ext;
 }
 
-/*
- * @delegate:   delegate activity log I/O to the worker thread
- */
-void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool delegate)
+bool drbd_al_begin_io_fastpath(struct drbd_conf *mdev, struct drbd_interval *i)
 {
 	/* for bios crossing activity log extent boundaries,
 	 * we may need to activate two extents in one go */
 	unsigned first = i->sector >> (AL_EXTENT_SHIFT-9);
 	unsigned last = i->size == 0 ? first : (i->sector + (i->size >> 9) - 1) >> (AL_EXTENT_SHIFT-9);
-	unsigned enr;
-	bool need_transaction = false;
-	bool locked = false;
+	bool fastpath_ok = true;
 
-	/* When called through generic_make_request(), we must delegate
-	 * activity log I/O to the worker thread: a further request
-	 * submitted via generic_make_request() within the same task
-	 * would be queued on current->bio_list, and would only start
-	 * after this function returns (see generic_make_request()).
-	 *
-	 * However, if we *are* the worker, we must not delegate to ourselves.
-	 */
+	D_ASSERT((unsigned)(last - first) <= 1);
+	D_ASSERT(atomic_read(&mdev->local_cnt) > 0);
+
+	/* FIXME figure out a fast path for bios crossing AL extent boundaries */
+	if (first != last)
+		return false;
+
+	spin_lock_irq(&mdev->al_lock);
+	fastpath_ok =
+		lc_find(mdev->resync, first/AL_EXT_PER_BM_SECT) == NULL &&
+		lc_try_get(mdev->act_log, first) != NULL;
+	spin_unlock_irq(&mdev->al_lock);
+	return fastpath_ok;
+}
 
-	if (delegate)
-		BUG_ON(current == mdev->tconn->worker.task);
+bool drbd_al_begin_io_prepare(struct drbd_conf *mdev, struct drbd_interval *i)
+{
+	/* for bios crossing activity log extent boundaries,
+	 * we may need to activate two extents in one go */
+	unsigned first = i->sector >> (AL_EXTENT_SHIFT-9);
+	unsigned last = i->size == 0 ? first : (i->sector + (i->size >> 9) - 1) >> (AL_EXTENT_SHIFT-9);
+	unsigned enr;
+	bool need_transaction = false;
 
 	D_ASSERT(first <= last);
 	D_ASSERT(atomic_read(&mdev->local_cnt) > 0);
@@ -280,11 +286,28 @@ void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool dele
 		if (al_ext->lc_number != enr)
 			need_transaction = true;
 	}
+	return need_transaction;
+}
 
-	/* If *this* request was to an already active extent,
-	 * we're done, even if there are pending changes. */
-	if (!need_transaction)
-		return;
+static int al_write_transaction(struct drbd_conf *mdev, bool delegate);
+
+/* When called through generic_make_request(), we must delegate
+ * activity log I/O to the worker thread: a further request
+ * submitted via generic_make_request() within the same task
+ * would be queued on current->bio_list, and would only start
+ * after this function returns (see generic_make_request()).
+ *
+ * However, if we *are* the worker, we must not delegate to ourselves.
+ */
+
+/*
+ * @delegate:   delegate activity log I/O to the worker thread
+ */
+void drbd_al_begin_io_commit(struct drbd_conf *mdev, bool delegate)
+{
+	bool locked = false;
+
+	BUG_ON(delegate && current == mdev->tconn->worker.task);
 
 	/* Serialize multiple transactions.
 	 * This uses test_and_set_bit, memory barrier is implicit.
@@ -303,11 +326,8 @@ void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool dele
 			write_al_updates = rcu_dereference(mdev->ldev->disk_conf)->al_updates;
 			rcu_read_unlock();
 
-			if (write_al_updates) {
+			if (write_al_updates)
 				al_write_transaction(mdev, delegate);
-				mdev->al_writ_cnt++;
-			}
-
 			spin_lock_irq(&mdev->al_lock);
 			/* FIXME
 			if (err)
@@ -321,6 +341,17 @@ void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool dele
 	}
 }
 
+/*
+ * @delegate:   delegate activity log I/O to the worker thread
+ */
+void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool delegate)
+{
+	BUG_ON(delegate && current == mdev->tconn->worker.task);
+
+	if (drbd_al_begin_io_prepare(mdev, i))
+		drbd_al_begin_io_commit(mdev, delegate);
+}
+
 void drbd_al_complete_io(struct drbd_conf *mdev, struct drbd_interval *i)
 {
 	/* for bios crossing activity log extent boundaries,
@@ -478,15 +509,22 @@ _al_write_transaction(struct drbd_conf *mdev)
 	crc = crc32c(0, buffer, 4096);
 	buffer->crc32c = cpu_to_be32(crc);
 
-	/* normal execution path goes through all three branches */
 	if (drbd_bm_write_hinted(mdev))
 		err = -EIO;
-		/* drbd_chk_io_error done already */
-	else if (drbd_md_sync_page_io(mdev, mdev->ldev, sector, WRITE)) {
-		err = -EIO;
-		drbd_chk_io_error(mdev, 1, DRBD_META_IO_ERROR);
-	} else {
-		mdev->al_tr_number++;
+	else {
+		bool write_al_updates;
+		rcu_read_lock();
+		write_al_updates = rcu_dereference(mdev->ldev->disk_conf)->al_updates;
+		rcu_read_unlock();
+		if (write_al_updates) {
+			if (drbd_md_sync_page_io(mdev, mdev->ldev, sector, WRITE)) {
+				err = -EIO;
+				drbd_chk_io_error(mdev, 1, DRBD_META_IO_ERROR);
+			} else {
+				mdev->al_tr_number++;
+				mdev->al_writ_cnt++;
+			}
+		}
 	}
 
 	drbd_md_put_buffer(mdev);
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index a6b71b6..b7b52dd 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1611,6 +1611,7 @@ extern const char *drbd_conn_str(enum drbd_conns s);
 extern const char *drbd_role_str(enum drbd_role s);
 
 /* drbd_actlog.c */
+extern bool drbd_al_begin_io_fastpath(struct drbd_conf *mdev, struct drbd_interval *i);
 extern void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool delegate);
 extern void drbd_al_complete_io(struct drbd_conf *mdev, struct drbd_interval *i);
 extern void drbd_rs_complete_io(struct drbd_conf *mdev, sector_t sector);
-- 
1.7.9.5

