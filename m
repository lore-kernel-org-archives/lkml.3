Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502Ab3CSRUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:20:04 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44640 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab3CSRRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 07/18] drbd: Clarify when activity log I/O is delegated to the worker thread
Date: Tue, 19 Mar 2013 18:16:48 +0100
Message-Id: <1363713419-17803-8-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_actlog.c   |   49 ++++++++++++++++++++----------------
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_receiver.c |    2 +-
 drivers/block/drbd/drbd_req.c      |    2 +-
 drivers/block/drbd/drbd_worker.c   |    2 +-
 5 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index c79625a..82199d9 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -104,7 +104,7 @@ struct update_al_work {
 	int err;
 };
 
-static int al_write_transaction(struct drbd_conf *mdev);
+static int al_write_transaction(struct drbd_conf *mdev, bool delegate);
 
 void *drbd_md_get_buffer(struct drbd_conf *mdev)
 {
@@ -246,7 +246,10 @@ static struct lc_element *_al_get(struct drbd_conf *mdev, unsigned int enr)
 	return al_ext;
 }
 
-void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i)
+/*
+ * @delegate:   delegate activity log I/O to the worker thread
+ */
+void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool delegate)
 {
 	/* for bios crossing activity log extent boundaries,
 	 * we may need to activate two extents in one go */
@@ -255,6 +258,17 @@ void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i)
 	unsigned enr;
 	bool locked = false;
 
+	/* When called through generic_make_request(), we must delegate
+	 * activity log I/O to the worker thread: a further request
+	 * submitted via generic_make_request() within the same task
+	 * would be queued on current->bio_list, and would only start
+	 * after this function returns (see generic_make_request()).
+	 *
+	 * However, if we *are* the worker, we must not delegate to ourselves.
+	 */
+
+	if (delegate)
+		BUG_ON(current == mdev->tconn->worker.task);
 
 	D_ASSERT(first <= last);
 	D_ASSERT(atomic_read(&mdev->local_cnt) > 0);
@@ -270,13 +284,6 @@ void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i)
 			(locked = lc_try_lock_for_transaction(mdev->act_log)));
 
 	if (locked) {
-		/* drbd_al_write_transaction(mdev,al_ext,enr);
-		 * recurses into generic_make_request(), which
-		 * disallows recursion, bios being serialized on the
-		 * current->bio_tail list now.
-		 * we have to delegate updates to the activity log
-		 * to the worker thread. */
-
 		/* Double check: it may have been committed by someone else,
 		 * while we have been waiting for the lock. */
 		if (mdev->act_log->pending_changes) {
@@ -287,7 +294,7 @@ void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i)
 			rcu_read_unlock();
 
 			if (write_al_updates) {
-				al_write_transaction(mdev);
+				al_write_transaction(mdev, delegate);
 				mdev->al_writ_cnt++;
 			}
 
@@ -495,20 +502,18 @@ static int w_al_write_transaction(struct drbd_work *w, int unused)
 /* Calls from worker context (see w_restart_disk_io()) need to write the
    transaction directly. Others came through generic_make_request(),
    those need to delegate it to the worker. */
-static int al_write_transaction(struct drbd_conf *mdev)
+static int al_write_transaction(struct drbd_conf *mdev, bool delegate)
 {
-	struct update_al_work al_work;
-
-	if (current == mdev->tconn->worker.task)
+	if (delegate) {
+		struct update_al_work al_work;
+		init_completion(&al_work.event);
+		al_work.w.cb = w_al_write_transaction;
+		al_work.w.mdev = mdev;
+		drbd_queue_work_front(&mdev->tconn->sender_work, &al_work.w);
+		wait_for_completion(&al_work.event);
+		return al_work.err;
+	} else
 		return _al_write_transaction(mdev);
-
-	init_completion(&al_work.event);
-	al_work.w.cb = w_al_write_transaction;
-	al_work.w.mdev = mdev;
-	drbd_queue_work_front(&mdev->tconn->sender_work, &al_work.w);
-	wait_for_completion(&al_work.event);
-
-	return al_work.err;
 }
 
 static int _try_lc_del(struct drbd_conf *mdev, struct lc_element *al_ext)
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 6eecdec..453fccf 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1598,7 +1598,7 @@ extern const char *drbd_conn_str(enum drbd_conns s);
 extern const char *drbd_role_str(enum drbd_role s);
 
 /* drbd_actlog.c */
-extern void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i);
+extern void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool delegate);
 extern void drbd_al_complete_io(struct drbd_conf *mdev, struct drbd_interval *i);
 extern void drbd_rs_complete_io(struct drbd_conf *mdev, sector_t sector);
 extern int drbd_rs_begin_io(struct drbd_conf *mdev, sector_t sector);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 8172a2c..1921871 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2265,7 +2265,7 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 		drbd_set_out_of_sync(mdev, peer_req->i.sector, peer_req->i.size);
 		peer_req->flags |= EE_CALL_AL_COMPLETE_IO;
 		peer_req->flags &= ~EE_MAY_SET_IN_SYNC;
-		drbd_al_begin_io(mdev, &peer_req->i);
+		drbd_al_begin_io(mdev, &peer_req->i, true);
 	}
 
 	err = drbd_submit_peer_request(mdev, peer_req, rw, DRBD_FAULT_DT_WR);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 2b8303a..7d1ff1a 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1054,7 +1054,7 @@ void __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long
 	if (rw == WRITE && req->private_bio && req->i.size
 	&& !test_bit(AL_SUSPENDED, &mdev->flags)) {
 		req->rq_state |= RQ_IN_ACT_LOG;
-		drbd_al_begin_io(mdev, &req->i);
+		drbd_al_begin_io(mdev, &req->i, true);
 	}
 
 	spin_lock_irq(&mdev->tconn->req_lock);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 34b5d5d..f41e224 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1411,7 +1411,7 @@ int w_restart_disk_io(struct drbd_work *w, int cancel)
 	struct drbd_conf *mdev = w->mdev;
 
 	if (bio_data_dir(req->master_bio) == WRITE && req->rq_state & RQ_IN_ACT_LOG)
-		drbd_al_begin_io(mdev, &req->i);
+		drbd_al_begin_io(mdev, &req->i, false);
 
 	drbd_req_make_private_bio(req, req->master_bio);
 	req->private_bio->bi_bdev = mdev->ldev->backing_bdev;
-- 
1.7.9.5

