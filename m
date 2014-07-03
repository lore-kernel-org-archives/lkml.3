Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbaGCIu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:50:27 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45903 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbaGCInU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/23] drbd: add lists to find oldest pending requests
Date: Thu,  3 Jul 2014 10:42:57 +0200
Message-Id: <1404376995-4877-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Adding requests to per-device fifo lists as soon as possible after
allocating them leaves a simple list_first_entry_or_null() to find the
oldest request, regardless what it is still waiting for.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  | 11 ++++++++++-
 drivers/block/drbd/drbd_main.c |  7 ++++++-
 drivers/block/drbd/drbd_req.c  | 45 +++++++++++++++++++++++++++++++-----------
 3 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 08fa2dc..f29f107 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -318,6 +318,10 @@ struct drbd_request {
 	struct list_head tl_requests; /* ring list in the transfer log */
 	struct bio *master_bio;       /* master bio pointer */
 
+	/* see struct drbd_device */
+	struct list_head req_pending_master_completion;
+	struct list_head req_pending_local;
+
 	/* for generic IO accounting */
 	unsigned long start_jif;
 
@@ -738,7 +742,7 @@ struct submit_worker {
 	struct workqueue_struct *wq;
 	struct work_struct worker;
 
-	spinlock_t lock;
+	/* protected by ..->resource->req_lock */
 	struct list_head writes;
 };
 
@@ -795,6 +799,11 @@ struct drbd_device {
 	struct rb_root read_requests;
 	struct rb_root write_requests;
 
+	/* for statistics and timeouts */
+	/* [0] read, [1] write */
+	struct list_head pending_master_completion[2];
+	struct list_head pending_completion[2];
+
 	/* use checksums for *this* resync */
 	bool use_csums;
 	/* blocks to resync in this run [unit BM_BLOCK_SIZE] */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 0baec7a..5886596 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1934,6 +1934,10 @@ void drbd_init_set_defaults(struct drbd_device *device)
 	INIT_LIST_HEAD(&device->resync_work.list);
 	INIT_LIST_HEAD(&device->unplug_work.list);
 	INIT_LIST_HEAD(&device->bm_io_work.w.list);
+	INIT_LIST_HEAD(&device->pending_master_completion[0]);
+	INIT_LIST_HEAD(&device->pending_master_completion[1]);
+	INIT_LIST_HEAD(&device->pending_completion[0]);
+	INIT_LIST_HEAD(&device->pending_completion[1]);
 
 	device->resync_work.cb  = w_resync_timer;
 	device->unplug_work.cb  = w_send_write_hint;
@@ -2268,6 +2272,8 @@ static void do_retry(struct work_struct *ws)
 	}
 }
 
+/* called via drbd_req_put_completion_ref(),
+ * holds resource->req_lock */
 void drbd_restart_request(struct drbd_request *req)
 {
 	unsigned long flags;
@@ -2687,7 +2693,6 @@ static int init_submitter(struct drbd_device *device)
 		return -ENOMEM;
 
 	INIT_WORK(&device->submit.worker, do_submit);
-	spin_lock_init(&device->submit.lock);
 	INIT_LIST_HEAD(&device->submit.writes);
 	return 0;
 }
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 1319bea..23cd909 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -84,6 +84,8 @@ static struct drbd_request *drbd_req_new(struct drbd_device *device,
 
 	INIT_LIST_HEAD(&req->tl_requests);
 	INIT_LIST_HEAD(&req->w.list);
+	INIT_LIST_HEAD(&req->req_pending_master_completion);
+	INIT_LIST_HEAD(&req->req_pending_local);
 
 	/* one reference to be put by __drbd_make_request */
 	atomic_set(&req->completion_ref, 1);
@@ -120,12 +122,14 @@ void drbd_req_destroy(struct kref *kref)
 		return;
 	}
 
-	/* remove it from the transfer log.
-	 * well, only if it had been there in the first
-	 * place... if it had not (local only or conflicting
-	 * and never sent), it should still be "empty" as
-	 * initialized in drbd_req_new(), so we can list_del() it
-	 * here unconditionally */
+	/* If called from mod_rq_state (expected normal case) or
+	 * drbd_send_and_submit (the less likely normal path), this holds the
+	 * req_lock, and req->tl_requests will typicaly be on ->transfer_log,
+	 * though it may be still empty (never added to the transfer log).
+	 *
+	 * If called from do_retry(), we do NOT hold the req_lock, but we are
+	 * still allowed to unconditionally list_del(&req->tl_requests),
+	 * because it will be on a local on-stack list only. */
 	list_del_init(&req->tl_requests);
 
 	/* finally remove the request from the conflict detection
@@ -312,8 +316,15 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 
 	if (req->i.waiting)
 		wake_up(&device->misc_wait);
+
+	/* Either we are about to complete to upper layers,
+	 * or we will restart this request.
+	 * In either case, the request object will be destroyed soon,
+	 * so better remove it from all lists. */
+	list_del_init(&req->req_pending_master_completion);
 }
 
+/* still holds resource->req_lock */
 static int drbd_req_put_completion_ref(struct drbd_request *req, struct bio_and_error *m, int put)
 {
 	struct drbd_device *device = req->device;
@@ -400,6 +411,7 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 			++k_put;
 		else
 			++c_put;
+		list_del_init(&req->req_pending_local);
 	}
 
 	if ((s & RQ_NET_PENDING) && (clear & RQ_NET_PENDING)) {
@@ -1070,9 +1082,11 @@ drbd_submit_req_private_bio(struct drbd_request *req)
 
 static void drbd_queue_write(struct drbd_device *device, struct drbd_request *req)
 {
-	spin_lock(&device->submit.lock);
+	spin_lock_irq(&device->resource->req_lock);
 	list_add_tail(&req->tl_requests, &device->submit.writes);
-	spin_unlock(&device->submit.lock);
+	list_add_tail(&req->req_pending_master_completion,
+			&device->pending_master_completion[1 /* WRITE */]);
+	spin_unlock_irq(&device->resource->req_lock);
 	queue_work(device->submit.wq, &device->submit.worker);
 }
 
@@ -1186,8 +1200,15 @@ static void drbd_send_and_submit(struct drbd_device *device, struct drbd_request
 			no_remote = true;
 	}
 
+	/* If it took the fast path in drbd_request_prepare, add it here.
+	 * The slow path has added it already. */
+	if (list_empty(&req->req_pending_master_completion))
+		list_add_tail(&req->req_pending_master_completion,
+			&device->pending_master_completion[rw == WRITE]);
 	if (req->private_bio) {
 		/* needs to be marked within the same spinlock */
+		list_add_tail(&req->req_pending_local,
+			&device->pending_completion[rw == WRITE]);
 		_req_mod(req, TO_BE_SUBMITTED);
 		/* but we need to give up the spinlock to submit */
 		submit_private_bio = true;
@@ -1278,9 +1299,9 @@ void do_submit(struct work_struct *ws)
 	struct drbd_request *req, *tmp;
 
 	for (;;) {
-		spin_lock(&device->submit.lock);
+		spin_lock_irq(&device->resource->req_lock);
 		list_splice_tail_init(&device->submit.writes, &incoming);
-		spin_unlock(&device->submit.lock);
+		spin_unlock_irq(&device->resource->req_lock);
 
 		submit_fast_path(device, &incoming);
 		if (list_empty(&incoming))
@@ -1304,9 +1325,9 @@ skip_fast_path:
 			if (list_empty(&device->submit.writes))
 				break;
 
-			spin_lock(&device->submit.lock);
+			spin_lock_irq(&device->resource->req_lock);
 			list_splice_tail_init(&device->submit.writes, &more_incoming);
-			spin_unlock(&device->submit.lock);
+			spin_unlock_irq(&device->resource->req_lock);
 
 			if (list_empty(&more_incoming))
 				break;
-- 
1.9.1

