Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbaGCIn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:43:58 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45906 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573AbaGCIn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:29 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 20/23] drbd: resync should only lock out specific ranges
Date: Thu,  3 Jul 2014 10:43:12 +0200
Message-Id: <1404376995-4877-21-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

During resync, if we need to block some specific incoming write because
of active resync requests to that same range, we potentially caused
*all* new application writes (to "cold" activity log extents) to block
until this one request has been processed.

Improve the do_submit() logic to
 * grab all incoming requests to some "incoming" list
 * process this list
   - move aside requests that are blocked by resync
   - prepare activity log transactions,
   - commit transactions and submit corresponding requests
   - if there are remaining requests that only wait for
     activity log extents to become free, stop the fast path
     (mark activity log as "starving")
   - iterate until no more requests are waiting for the activity log,
     but all potentially remaining requests are only blocked by resync
 * only then grab new incoming requests

That way, very busy IO on currently "hot" activity log extents cannot
starve scattered IO to "cold" extents. And blocked-by-resync requests
are processed once resync traffic on the affected region has ceased,
without blocking anything else.

The only blocking mode left is when we cannot start requests to "cold"
extents because all currently "hot" extents are actually used.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |  15 ++++-
 drivers/block/drbd/drbd_req.c    | 136 ++++++++++++++++++++++++---------------
 2 files changed, 98 insertions(+), 53 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 6ce5c76..e9fbcaf 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -357,8 +357,19 @@ int drbd_al_begin_io_nonblock(struct drbd_device *device, struct drbd_interval *
 	/* We want all necessary updates for a given request within the same transaction
 	 * We could first check how many updates are *actually* needed,
 	 * and use that instead of the worst-case nr_al_extents */
-	if (available_update_slots < nr_al_extents)
-		return -EWOULDBLOCK;
+	if (available_update_slots < nr_al_extents) {
+		/* Too many activity log extents are currently "hot".
+		 *
+		 * If we have accumulated pending changes already,
+		 * we made progress.
+		 *
+		 * If we cannot get even a single pending change through,
+		 * stop the fast path until we made some progress,
+		 * or requests to "cold" extents could be starved. */
+		if (!al->pending_changes)
+			__set_bit(__LC_STARVING, &device->act_log->flags);
+		return -ENOBUFS;
+	}
 
 	/* Is resync active in this area? */
 	for (enr = first; enr <= last; enr++) {
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 74ebef1..c67717d 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1182,6 +1182,8 @@ static void drbd_queue_write(struct drbd_device *device, struct drbd_request *re
 			&device->pending_master_completion[1 /* WRITE */]);
 	spin_unlock_irq(&device->resource->req_lock);
 	queue_work(device->submit.wq, &device->submit.worker);
+	/* do_submit() may sleep internally on al_wait, too */
+	wake_up(&device->al_wait);
 }
 
 /* returns the new drbd_request pointer, if the caller is expected to
@@ -1365,7 +1367,8 @@ static void submit_fast_path(struct drbd_device *device, struct list_head *incom
 
 static bool prepare_al_transaction_nonblock(struct drbd_device *device,
 					    struct list_head *incoming,
-					    struct list_head *pending)
+					    struct list_head *pending,
+					    struct list_head *later)
 {
 	struct drbd_request *req, *tmp;
 	int wake = 0;
@@ -1374,44 +1377,105 @@ static bool prepare_al_transaction_nonblock(struct drbd_device *device,
 	spin_lock_irq(&device->al_lock);
 	list_for_each_entry_safe(req, tmp, incoming, tl_requests) {
 		err = drbd_al_begin_io_nonblock(device, &req->i);
+		if (err == -ENOBUFS)
+			break;
 		if (err == -EBUSY)
 			wake = 1;
 		if (err)
-			continue;
-		list_move_tail(&req->tl_requests, pending);
+			list_move_tail(&req->tl_requests, later);
+		else
+			list_move_tail(&req->tl_requests, pending);
 	}
 	spin_unlock_irq(&device->al_lock);
 	if (wake)
 		wake_up(&device->al_wait);
-
 	return !list_empty(pending);
 }
 
+void send_and_submit_pending(struct drbd_device *device, struct list_head *pending)
+{
+	struct drbd_request *req, *tmp;
+
+	list_for_each_entry_safe(req, tmp, pending, tl_requests) {
+		req->rq_state |= RQ_IN_ACT_LOG;
+		req->in_actlog_jif = jiffies;
+		atomic_dec(&device->ap_actlog_cnt);
+		list_del_init(&req->tl_requests);
+		drbd_send_and_submit(device, req);
+	}
+}
+
 void do_submit(struct work_struct *ws)
 {
 	struct drbd_device *device = container_of(ws, struct drbd_device, submit.worker);
-	LIST_HEAD(incoming);
-	LIST_HEAD(pending);
-	struct drbd_request *req, *tmp;
+	LIST_HEAD(incoming);	/* from drbd_make_request() */
+	LIST_HEAD(pending);	/* to be submitted after next AL-transaction commit */
+	LIST_HEAD(busy);	/* blocked by resync requests */
+
+	/* grab new incoming requests */
+	spin_lock_irq(&device->resource->req_lock);
+	list_splice_tail_init(&device->submit.writes, &incoming);
+	spin_unlock_irq(&device->resource->req_lock);
 
 	for (;;) {
-		spin_lock_irq(&device->resource->req_lock);
-		list_splice_tail_init(&device->submit.writes, &incoming);
-		spin_unlock_irq(&device->resource->req_lock);
+		DEFINE_WAIT(wait);
 
+		/* move used-to-be-busy back to front of incoming */
+		list_splice_init(&busy, &incoming);
 		submit_fast_path(device, &incoming);
 		if (list_empty(&incoming))
 			break;
 
-skip_fast_path:
-		wait_event(device->al_wait, prepare_al_transaction_nonblock(device, &incoming, &pending));
-		/* Maybe more was queued, while we prepared the transaction?
-		 * Try to stuff them into this transaction as well.
-		 * Be strictly non-blocking here, no wait_event, we already
-		 * have something to commit.
-		 * Stop if we don't make any more progres.
-		 */
 		for (;;) {
+			prepare_to_wait(&device->al_wait, &wait, TASK_UNINTERRUPTIBLE);
+
+			list_splice_init(&busy, &incoming);
+			prepare_al_transaction_nonblock(device, &incoming, &pending, &busy);
+			if (!list_empty(&pending))
+				break;
+
+			schedule();
+
+			/* If all currently "hot" activity log extents are kept busy by
+			 * incoming requests, we still must not totally starve new
+			 * requests to "cold" extents.
+			 * Something left on &incoming means there had not been
+			 * enough update slots available, and the activity log
+			 * has been marked as "starving".
+			 *
+			 * Try again now, without looking for new requests,
+			 * effectively blocking all new requests until we made
+			 * at least _some_ progress with what we currently have.
+			 */
+			if (!list_empty(&incoming))
+				continue;
+
+			/* Nothing moved to pending, but nothing left
+			 * on incoming: all moved to busy!
+			 * Grab new and iterate. */
+			spin_lock_irq(&device->resource->req_lock);
+			list_splice_tail_init(&device->submit.writes, &incoming);
+			spin_unlock_irq(&device->resource->req_lock);
+		}
+		finish_wait(&device->al_wait, &wait);
+
+		/* If the transaction was full, before all incoming requests
+		 * had been processed, skip ahead to commit, and iterate
+		 * without splicing in more incoming requests from upper layers.
+		 *
+		 * Else, if all incoming have been processed,
+		 * they have become either "pending" (to be submitted after
+		 * next transaction commit) or "busy" (blocked by resync).
+		 *
+		 * Maybe more was queued, while we prepared the transaction?
+		 * Try to stuff those into this transaction as well.
+		 * Be strictly non-blocking here,
+		 * we already have something to commit.
+		 *
+		 * Commit if we don't make any more progres.
+		 */
+
+		while (list_empty(&incoming)) {
 			LIST_HEAD(more_pending);
 			LIST_HEAD(more_incoming);
 			bool made_progress;
@@ -1428,46 +1492,16 @@ skip_fast_path:
 			if (list_empty(&more_incoming))
 				break;
 
-			made_progress = prepare_al_transaction_nonblock(device, &more_incoming, &more_pending);
+			made_progress = prepare_al_transaction_nonblock(device, &more_incoming, &more_pending, &busy);
 
 			list_splice_tail_init(&more_pending, &pending);
 			list_splice_tail_init(&more_incoming, &incoming);
-
 			if (!made_progress)
 				break;
 		}
-		drbd_al_begin_io_commit(device);
 
-		list_for_each_entry_safe(req, tmp, &pending, tl_requests) {
-			req->rq_state |= RQ_IN_ACT_LOG;
-			req->in_actlog_jif = jiffies;
-			atomic_dec(&device->ap_actlog_cnt);
-			list_del_init(&req->tl_requests);
-			drbd_send_and_submit(device, req);
-		}
-
-		/* If all currently hot activity log extents are kept busy by
-		 * incoming requests, we still must not totally starve new
-		 * requests to cold extents. In that case, prepare one request
-		 * in blocking mode. */
-		list_for_each_entry_safe(req, tmp, &incoming, tl_requests) {
-			bool was_cold;
-			list_del_init(&req->tl_requests);
-			was_cold = drbd_al_begin_io_prepare(device, &req->i);
-			if (!was_cold) {
-				req->rq_state |= RQ_IN_ACT_LOG;
-				req->in_actlog_jif = jiffies;
-				atomic_dec(&device->ap_actlog_cnt);
-				/* Corresponding extent was hot after all? */
-				drbd_send_and_submit(device, req);
-			} else {
-				/* Found a request to a cold extent.
-				 * Put on "pending" list,
-				 * and try to cumulate with more. */
-				list_add(&req->tl_requests, &pending);
-				goto skip_fast_path;
-			}
-		}
+		drbd_al_begin_io_commit(device);
+		send_and_submit_pending(device, &pending);
 	}
 }
 
-- 
1.9.1

