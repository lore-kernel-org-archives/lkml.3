Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbaF3PyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:54:03 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50053 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbaF3PxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:15 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 18/18] drbd: get rid of drbd_queue_work_front
Date: Mon, 30 Jun 2014 17:53:07 +0200
Message-Id: <1404143587-24344-19-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

The last user was al_write_transaction, if called with "delegate",
and the last user to call it with "delegate = true" was the receiver
thread, which has no need to delegate, but can call it himself.

Finally drop the delegate parameter, drop the extra
w_al_write_transaction callback, and drop drbd_queue_work_front.

Do not (yet) change dequeue_work_item to dequeue_work_batch, though.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   | 69 ++++----------------------------------
 drivers/block/drbd/drbd_int.h      | 14 ++------
 drivers/block/drbd/drbd_receiver.c |  2 +-
 drivers/block/drbd/drbd_req.c      |  2 +-
 drivers/block/drbd/drbd_worker.c   |  6 ++--
 5 files changed, 12 insertions(+), 81 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 5add201..5f82a36 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -92,14 +92,6 @@ struct __packed al_transaction_on_disk {
 	__be32	context[AL_CONTEXT_PER_TRANSACTION];
 };
 
-struct update_al_work {
-	struct drbd_work w;
-	struct drbd_device *device;
-	struct completion event;
-	int err;
-};
-
-
 void *drbd_md_get_buffer(struct drbd_device *device)
 {
 	int r;
@@ -291,26 +283,12 @@ bool drbd_al_begin_io_prepare(struct drbd_device *device, struct drbd_interval *
 	return need_transaction;
 }
 
-static int al_write_transaction(struct drbd_device *device, bool delegate);
+static int al_write_transaction(struct drbd_device *device);
 
-/* When called through generic_make_request(), we must delegate
- * activity log I/O to the worker thread: a further request
- * submitted via generic_make_request() within the same task
- * would be queued on current->bio_list, and would only start
- * after this function returns (see generic_make_request()).
- *
- * However, if we *are* the worker, we must not delegate to ourselves.
- */
-
-/*
- * @delegate:   delegate activity log I/O to the worker thread
- */
-void drbd_al_begin_io_commit(struct drbd_device *device, bool delegate)
+void drbd_al_begin_io_commit(struct drbd_device *device)
 {
 	bool locked = false;
 
-	BUG_ON(delegate && current == first_peer_device(device)->connection->worker.task);
-
 	/* Serialize multiple transactions.
 	 * This uses test_and_set_bit, memory barrier is implicit.
 	 */
@@ -329,7 +307,7 @@ void drbd_al_begin_io_commit(struct drbd_device *device, bool delegate)
 			rcu_read_unlock();
 
 			if (write_al_updates)
-				al_write_transaction(device, delegate);
+				al_write_transaction(device);
 			spin_lock_irq(&device->al_lock);
 			/* FIXME
 			if (err)
@@ -346,12 +324,10 @@ void drbd_al_begin_io_commit(struct drbd_device *device, bool delegate)
 /*
  * @delegate:   delegate activity log I/O to the worker thread
  */
-void drbd_al_begin_io(struct drbd_device *device, struct drbd_interval *i, bool delegate)
+void drbd_al_begin_io(struct drbd_device *device, struct drbd_interval *i)
 {
-	BUG_ON(delegate && current == first_peer_device(device)->connection->worker.task);
-
 	if (drbd_al_begin_io_prepare(device, i))
-		drbd_al_begin_io_commit(device, delegate);
+		drbd_al_begin_io_commit(device);
 }
 
 int drbd_al_begin_io_nonblock(struct drbd_device *device, struct drbd_interval *i)
@@ -464,8 +440,7 @@ static sector_t al_tr_number_to_on_disk_sector(struct drbd_device *device)
 	return device->ldev->md.md_offset + device->ldev->md.al_offset + t;
 }
 
-static int
-_al_write_transaction(struct drbd_device *device)
+int al_write_transaction(struct drbd_device *device)
 {
 	struct al_transaction_on_disk *buffer;
 	struct lc_element *e;
@@ -575,38 +550,6 @@ _al_write_transaction(struct drbd_device *device)
 	return err;
 }
 
-
-static int w_al_write_transaction(struct drbd_work *w, int unused)
-{
-	struct update_al_work *aw = container_of(w, struct update_al_work, w);
-	struct drbd_device *device = aw->device;
-	int err;
-
-	err = _al_write_transaction(device);
-	aw->err = err;
-	complete(&aw->event);
-
-	return err != -EIO ? err : 0;
-}
-
-/* Calls from worker context (see w_restart_disk_io()) need to write the
-   transaction directly. Others came through generic_make_request(),
-   those need to delegate it to the worker. */
-static int al_write_transaction(struct drbd_device *device, bool delegate)
-{
-	if (delegate) {
-		struct update_al_work al_work;
-		init_completion(&al_work.event);
-		al_work.w.cb = w_al_write_transaction;
-		al_work.device = device;
-		drbd_queue_work_front(&first_peer_device(device)->connection->sender_work,
-				      &al_work.w);
-		wait_for_completion(&al_work.event);
-		return al_work.err;
-	} else
-		return _al_write_transaction(device);
-}
-
 static int _try_lc_del(struct drbd_device *device, struct lc_element *al_ext)
 {
 	int rv;
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 3c701b0..72b5001 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1491,9 +1491,9 @@ extern const char *drbd_role_str(enum drbd_role s);
 /* drbd_actlog.c */
 extern bool drbd_al_begin_io_prepare(struct drbd_device *device, struct drbd_interval *i);
 extern int drbd_al_begin_io_nonblock(struct drbd_device *device, struct drbd_interval *i);
-extern void drbd_al_begin_io_commit(struct drbd_device *device, bool delegate);
+extern void drbd_al_begin_io_commit(struct drbd_device *device);
 extern bool drbd_al_begin_io_fastpath(struct drbd_device *device, struct drbd_interval *i);
-extern void drbd_al_begin_io(struct drbd_device *device, struct drbd_interval *i, bool delegate);
+extern void drbd_al_begin_io(struct drbd_device *device, struct drbd_interval *i);
 extern void drbd_al_complete_io(struct drbd_device *device, struct drbd_interval *i);
 extern void drbd_rs_complete_io(struct drbd_device *device, sector_t sector);
 extern int drbd_rs_begin_io(struct drbd_device *device, sector_t sector);
@@ -1769,16 +1769,6 @@ static inline sector_t drbd_md_ss(struct drbd_backing_dev *bdev)
 }
 
 static inline void
-drbd_queue_work_front(struct drbd_work_queue *q, struct drbd_work *w)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&q->q_lock, flags);
-	list_add(&w->list, &q->q);
-	spin_unlock_irqrestore(&q->q_lock, flags);
-	wake_up(&q->q_wait);
-}
-
-static inline void
 drbd_queue_work(struct drbd_work_queue *q, struct drbd_work *w)
 {
 	unsigned long flags;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 8d8a6b7..cfc3d43 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2351,7 +2351,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 		drbd_set_out_of_sync(device, peer_req->i.sector, peer_req->i.size);
 		peer_req->flags |= EE_CALL_AL_COMPLETE_IO;
 		peer_req->flags &= ~EE_MAY_SET_IN_SYNC;
-		drbd_al_begin_io(device, &peer_req->i, true);
+		drbd_al_begin_io(device, &peer_req->i);
 	}
 
 	err = drbd_submit_peer_request(device, peer_req, rw, DRBD_FAULT_DT_WR);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 042bbc6..1ee7355 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1286,7 +1286,7 @@ skip_fast_path:
 			if (!made_progress)
 				break;
 		}
-		drbd_al_begin_io_commit(device, false);
+		drbd_al_begin_io_commit(device);
 
 		list_for_each_entry_safe(req, tmp, &pending, tl_requests) {
 			list_del_init(&req->tl_requests);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index a4310fd..2ff5fd4 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1438,7 +1438,7 @@ int w_restart_disk_io(struct drbd_work *w, int cancel)
 	struct drbd_device *device = req->device;
 
 	if (bio_data_dir(req->master_bio) == WRITE && req->rq_state & RQ_IN_ACT_LOG)
-		drbd_al_begin_io(device, &req->i, false);
+		drbd_al_begin_io(device, &req->i);
 
 	drbd_req_make_private_bio(req, req->master_bio);
 	req->private_bio->bi_bdev = device->ldev->backing_bdev;
@@ -1991,7 +1991,7 @@ static void wait_for_work(struct drbd_connection *connection, struct list_head *
 		/* dequeue single item only,
 		 * we still use drbd_queue_work_front() in some places */
 		if (!list_empty(&connection->sender_work.q))
-			list_move(connection->sender_work.q.next, work_list);
+			list_splice_tail_init(&connection->sender_work.q, work_list);
 		spin_unlock(&connection->sender_work.q_lock);	/* FIXME get rid of this one? */
 		if (!list_empty(work_list) || signal_pending(current)) {
 			spin_unlock_irq(&connection->resource->req_lock);
@@ -2054,8 +2054,6 @@ int drbd_worker(struct drbd_thread *thi)
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
 
-		/* as long as we use drbd_queue_work_front(),
-		 * we may only dequeue single work items here, not batches. */
 		if (list_empty(&work_list))
 			wait_for_work(connection, &work_list);
 
-- 
1.9.1

