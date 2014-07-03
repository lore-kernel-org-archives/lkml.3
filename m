Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbaGCIw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:52:58 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45860 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaGCInS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/23] drbd: gather detailed timing statistics for drbd_requests
Date: Thu,  3 Jul 2014 10:42:56 +0200
Message-Id: <1404376995-4877-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Record (in jiffies) how much time a request spends in which stages.
Followup commits will use and present this additional timing information
so we can better locate and tackle the root causes of latency spikes,
or present the backlog for asynchronous replication.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h    | 54 ++++++++++++++++++++++-
 drivers/block/drbd/drbd_main.c   |  7 +--
 drivers/block/drbd/drbd_req.c    | 93 +++++++++++++++++++++++++---------------
 drivers/block/drbd/drbd_worker.c |  3 ++
 4 files changed, 119 insertions(+), 38 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 3f8281b..08fa2dc 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -317,7 +317,59 @@ struct drbd_request {
 
 	struct list_head tl_requests; /* ring list in the transfer log */
 	struct bio *master_bio;       /* master bio pointer */
-	unsigned long start_time;
+
+	/* for generic IO accounting */
+	unsigned long start_jif;
+
+	/* for DRBD internal statistics */
+
+	/* Minimal set of time stamps to determine if we wait for activity log
+	 * transactions, local disk or peer.  32 bit "jiffies" are good enough,
+	 * we don't expect a DRBD request to be stalled for several month.
+	 */
+
+	/* before actual request processing */
+	unsigned long in_actlog_jif;
+
+	/* local disk */
+	unsigned long pre_submit_jif;
+
+	/* per connection */
+	unsigned long pre_send_jif;
+	unsigned long acked_jif;
+	unsigned long net_done_jif;
+
+	/* Possibly even more detail to track each phase:
+	 *  master_completion_jif
+	 *      how long did it take to complete the master bio
+	 *      (application visible latency)
+	 *  allocated_jif
+	 *      how long the master bio was blocked until we finally allocated
+	 *      a tracking struct
+	 *  in_actlog_jif
+	 *      how long did we wait for activity log transactions
+	 *
+	 *  net_queued_jif
+	 *      when did we finally queue it for sending
+	 *  pre_send_jif
+	 *      when did we start sending it
+	 *  post_send_jif
+	 *      how long did we block in the network stack trying to send it
+	 *  acked_jif
+	 *      when did we receive (or fake, in protocol A) a remote ACK
+	 *  net_done_jif
+	 *      when did we receive final acknowledgement (P_BARRIER_ACK),
+	 *      or decide, e.g. on connection loss, that we do no longer expect
+	 *      anything from this peer for this request.
+	 *
+	 *  pre_submit_jif
+	 *  post_sub_jif
+	 *      when did we start submiting to the lower level device,
+	 *      and how long did we block in that submit function
+	 *  local_completion_jif
+	 *      how long did it take the lower level device to complete this request
+	 */
+
 
 	/* once it hits 0, we may complete the master_bio */
 	atomic_t completion_ref;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 3ab7461..0baec7a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -29,6 +29,7 @@
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
+#include <linux/jiffies.h>
 #include <linux/drbd.h>
 #include <asm/uaccess.h>
 #include <asm/types.h>
@@ -264,7 +265,7 @@ bail:
 
 /**
  * _tl_restart() - Walks the transfer log, and applies an action to all requests
- * @device:	DRBD device.
+ * @connection:	DRBD connection to operate on.
  * @what:       The action/event to perform with all request objects
  *
  * @what might be one of CONNECTION_LOST_WHILE_PENDING, RESEND, FAIL_FROZEN_DISK_IO,
@@ -2228,7 +2229,7 @@ static void do_retry(struct work_struct *ws)
 	list_for_each_entry_safe(req, tmp, &writes, tl_requests) {
 		struct drbd_device *device = req->device;
 		struct bio *bio = req->master_bio;
-		unsigned long start_time = req->start_time;
+		unsigned long start_jif = req->start_jif;
 		bool expected;
 
 		expected =
@@ -2263,7 +2264,7 @@ static void do_retry(struct work_struct *ws)
 		/* We are not just doing generic_make_request(),
 		 * as we want to keep the start_time information. */
 		inc_ap_bio(device);
-		__drbd_make_request(device, bio, start_time);
+		__drbd_make_request(device, bio, start_jif);
 	}
 }
 
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 3824d5c..1319bea 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -52,7 +52,7 @@ static void _drbd_start_io_acct(struct drbd_device *device, struct drbd_request
 static void _drbd_end_io_acct(struct drbd_device *device, struct drbd_request *req)
 {
 	int rw = bio_data_dir(req->master_bio);
-	unsigned long duration = jiffies - req->start_time;
+	unsigned long duration = jiffies - req->start_jif;
 	int cpu;
 	cpu = part_stat_lock();
 	part_stat_add(cpu, &device->vdisk->part0, ticks[rw], duration);
@@ -66,7 +66,7 @@ static struct drbd_request *drbd_req_new(struct drbd_device *device,
 {
 	struct drbd_request *req;
 
-	req = mempool_alloc(drbd_request_mempool, GFP_NOIO);
+	req = mempool_alloc(drbd_request_mempool, GFP_NOIO | __GFP_ZERO);
 	if (!req)
 		return NULL;
 
@@ -366,14 +366,18 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 		atomic_inc(&req->completion_ref);
 	}
 
-	if (!(s & RQ_NET_QUEUED) && (set & RQ_NET_QUEUED))
+	if (!(s & RQ_NET_QUEUED) && (set & RQ_NET_QUEUED)) {
 		atomic_inc(&req->completion_ref);
+	}
 
 	if (!(s & RQ_EXP_BARR_ACK) && (set & RQ_EXP_BARR_ACK))
 		kref_get(&req->kref); /* wait for the DONE */
 
-	if (!(s & RQ_NET_SENT) && (set & RQ_NET_SENT))
-		atomic_add(req->i.size >> 9, &device->ap_in_flight);
+	if (!(s & RQ_NET_SENT) && (set & RQ_NET_SENT)) {
+		/* potentially already completed in the asender thread */
+		if (!(s & RQ_NET_DONE))
+			atomic_add(req->i.size >> 9, &device->ap_in_flight);
+	}
 
 	if (!(s & RQ_COMPLETION_SUSP) && (set & RQ_COMPLETION_SUSP))
 		atomic_inc(&req->completion_ref);
@@ -401,15 +405,18 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 	if ((s & RQ_NET_PENDING) && (clear & RQ_NET_PENDING)) {
 		dec_ap_pending(device);
 		++c_put;
+		req->acked_jif = jiffies;
 	}
 
 	if ((s & RQ_NET_QUEUED) && (clear & RQ_NET_QUEUED))
 		++c_put;
 
-	if ((s & RQ_EXP_BARR_ACK) && !(s & RQ_NET_DONE) && (set & RQ_NET_DONE)) {
-		if (req->rq_state & RQ_NET_SENT)
+	if (!(s & RQ_NET_DONE) && (set & RQ_NET_DONE)) {
+		if (s & RQ_NET_SENT)
 			atomic_sub(req->i.size >> 9, &device->ap_in_flight);
-		++k_put;
+		if (s & RQ_EXP_BARR_ACK)
+			++k_put;
+		req->net_done_jif = jiffies;
 	}
 
 	/* potentially complete and destroy */
@@ -449,6 +456,19 @@ static void drbd_report_io_error(struct drbd_device *device, struct drbd_request
 			bdevname(device->ldev->backing_bdev, b));
 }
 
+/* Helper for HANDED_OVER_TO_NETWORK.
+ * Is this a protocol A write (neither WRITE_ACK nor RECEIVE_ACK expected)?
+ * Is it also still "PENDING"?
+ * --> If so, clear PENDING and set NET_OK below.
+ * If it is a protocol A write, but not RQ_PENDING anymore, neg-ack was faster
+ * (and we must not set RQ_NET_OK) */
+static inline bool is_pending_write_protocol_A(struct drbd_request *req)
+{
+	return (req->rq_state &
+		   (RQ_WRITE|RQ_NET_PENDING|RQ_EXP_WRITE_ACK|RQ_EXP_RECEIVE_ACK))
+		== (RQ_WRITE|RQ_NET_PENDING);
+}
+
 /* obviously this could be coded as many single functions
  * instead of one huge switch,
  * or by putting the code directly in the respective locations
@@ -627,18 +647,16 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 	case HANDED_OVER_TO_NETWORK:
 		/* assert something? */
-		if (bio_data_dir(req->master_bio) == WRITE &&
-		    !(req->rq_state & (RQ_EXP_RECEIVE_ACK | RQ_EXP_WRITE_ACK))) {
+		if (is_pending_write_protocol_A(req))
 			/* this is what is dangerous about protocol A:
 			 * pretend it was successfully written on the peer. */
-			if (req->rq_state & RQ_NET_PENDING)
-				mod_rq_state(req, m, RQ_NET_PENDING, RQ_NET_OK);
-			/* else: neg-ack was faster... */
-			/* it is still not yet RQ_NET_DONE until the
-			 * corresponding epoch barrier got acked as well,
-			 * so we know what to dirty on connection loss */
-		}
-		mod_rq_state(req, m, RQ_NET_QUEUED, RQ_NET_SENT);
+			mod_rq_state(req, m, RQ_NET_QUEUED|RQ_NET_PENDING,
+						RQ_NET_SENT|RQ_NET_OK);
+		else
+			mod_rq_state(req, m, RQ_NET_QUEUED, RQ_NET_SENT);
+		/* It is still not yet RQ_NET_DONE until the
+		 * corresponding epoch barrier got acked as well,
+		 * so we know what to dirty on connection loss. */
 		break;
 
 	case OOS_HANDED_TO_NETWORK:
@@ -1037,6 +1055,7 @@ drbd_submit_req_private_bio(struct drbd_request *req)
 	 * stable storage, and this is a WRITE, we may not even submit
 	 * this bio. */
 	if (get_ldev(device)) {
+		req->pre_submit_jif = jiffies;
 		if (drbd_insert_fault(device,
 				      rw == WRITE ? DRBD_FAULT_DT_WR
 				    : rw == READ  ? DRBD_FAULT_DT_RD
@@ -1063,7 +1082,7 @@ static void drbd_queue_write(struct drbd_device *device, struct drbd_request *re
  * Returns ERR_PTR(-ENOMEM) if we cannot allocate a drbd_request.
  */
 static struct drbd_request *
-drbd_request_prepare(struct drbd_device *device, struct bio *bio, unsigned long start_time)
+drbd_request_prepare(struct drbd_device *device, struct bio *bio, unsigned long start_jif)
 {
 	const int rw = bio_data_dir(bio);
 	struct drbd_request *req;
@@ -1078,7 +1097,7 @@ drbd_request_prepare(struct drbd_device *device, struct bio *bio, unsigned long
 		bio_endio(bio, -ENOMEM);
 		return ERR_PTR(-ENOMEM);
 	}
-	req->start_time = start_time;
+	req->start_jif = start_jif;
 
 	if (!get_ldev(device)) {
 		bio_put(req->private_bio);
@@ -1095,6 +1114,7 @@ drbd_request_prepare(struct drbd_device *device, struct bio *bio, unsigned long
 			return NULL;
 		}
 		req->rq_state |= RQ_IN_ACT_LOG;
+		req->in_actlog_jif = jiffies;
 	}
 
 	return req;
@@ -1197,9 +1217,9 @@ out:
 		complete_master_bio(device, &m);
 }
 
-void __drbd_make_request(struct drbd_device *device, struct bio *bio, unsigned long start_time)
+void __drbd_make_request(struct drbd_device *device, struct bio *bio, unsigned long start_jif)
 {
-	struct drbd_request *req = drbd_request_prepare(device, bio, start_time);
+	struct drbd_request *req = drbd_request_prepare(device, bio, start_jif);
 	if (IS_ERR_OR_NULL(req))
 		return;
 	drbd_send_and_submit(device, req);
@@ -1218,6 +1238,7 @@ static void submit_fast_path(struct drbd_device *device, struct list_head *incom
 				continue;
 
 			req->rq_state |= RQ_IN_ACT_LOG;
+			req->in_actlog_jif = jiffies;
 		}
 
 		list_del_init(&req->tl_requests);
@@ -1240,7 +1261,6 @@ static bool prepare_al_transaction_nonblock(struct drbd_device *device,
 			wake = 1;
 		if (err)
 			continue;
-		req->rq_state |= RQ_IN_ACT_LOG;
 		list_move_tail(&req->tl_requests, pending);
 	}
 	spin_unlock_irq(&device->al_lock);
@@ -1302,6 +1322,8 @@ skip_fast_path:
 		drbd_al_begin_io_commit(device);
 
 		list_for_each_entry_safe(req, tmp, &pending, tl_requests) {
+			req->rq_state |= RQ_IN_ACT_LOG;
+			req->in_actlog_jif = jiffies;
 			list_del_init(&req->tl_requests);
 			drbd_send_and_submit(device, req);
 		}
@@ -1311,9 +1333,12 @@ skip_fast_path:
 		 * requests to cold extents. In that case, prepare one request
 		 * in blocking mode. */
 		list_for_each_entry_safe(req, tmp, &incoming, tl_requests) {
+			bool was_cold;
 			list_del_init(&req->tl_requests);
-			req->rq_state |= RQ_IN_ACT_LOG;
-			if (!drbd_al_begin_io_prepare(device, &req->i)) {
+			was_cold = drbd_al_begin_io_prepare(device, &req->i);
+			if (!was_cold) {
+				req->rq_state |= RQ_IN_ACT_LOG;
+				req->in_actlog_jif = jiffies;
 				/* Corresponding extent was hot after all? */
 				drbd_send_and_submit(device, req);
 			} else {
@@ -1330,9 +1355,9 @@ skip_fast_path:
 void drbd_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct drbd_device *device = (struct drbd_device *) q->queuedata;
-	unsigned long start_time;
+	unsigned long start_jif;
 
-	start_time = jiffies;
+	start_jif = jiffies;
 
 	/*
 	 * what we "blindly" assume:
@@ -1340,7 +1365,7 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 	D_ASSERT(device, IS_ALIGNED(bio->bi_iter.bi_size, 512));
 
 	inc_ap_bio(device);
-	__drbd_make_request(device, bio, start_time);
+	__drbd_make_request(device, bio, start_jif);
 }
 
 /* This is called by bio_add_page().
@@ -1453,13 +1478,13 @@ void request_timer_fn(unsigned long data)
 	 * to expire twice (worst case) to become effective. Good enough.
 	 */
 	if (ent && req_peer &&
-		 time_after(now, req_peer->start_time + ent) &&
+		 time_after(now, req_peer->start_jif + ent) &&
 		!time_in_range(now, connection->last_reconnect_jif, connection->last_reconnect_jif + ent)) {
 		drbd_warn(device, "Remote failed to finish a request within ko-count * timeout\n");
 		_drbd_set_state(_NS(device, conn, C_TIMEOUT), CS_VERBOSE | CS_HARD, NULL);
 	}
 	if (dt && req_disk &&
-		 time_after(now, req_disk->start_time + dt) &&
+		 time_after(now, req_disk->start_jif + dt) &&
 		!time_in_range(now, device->last_reattach_jif, device->last_reattach_jif + dt)) {
 		drbd_warn(device, "Local backing device failed to meet the disk-timeout\n");
 		__drbd_chk_io_error(device, DRBD_FORCE_DETACH);
@@ -1467,10 +1492,10 @@ void request_timer_fn(unsigned long data)
 
 	/* Reschedule timer for the nearest not already expired timeout.
 	 * Fallback to now + min(effective network timeout, disk timeout). */
-	ent = (ent && req_peer && time_before(now, req_peer->start_time + ent))
-		? req_peer->start_time + ent : now + et;
-	dt = (dt && req_disk && time_before(now, req_disk->start_time + dt))
-		? req_disk->start_time + dt : now + et;
+	ent = (ent && req_peer && time_before(now, req_peer->start_jif + ent))
+		? req_peer->start_jif + ent : now + et;
+	dt = (dt && req_disk && time_before(now, req_disk->start_jif + dt))
+		? req_disk->start_jif + dt : now + et;
 	nt = time_before(ent, dt) ? ent : dt;
 	spin_unlock_irq(&connection->resource->req_lock);
 	mod_timer(&device->request_timer, nt);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 3978d9e..0ff8f46 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1368,6 +1368,7 @@ int w_send_out_of_sync(struct drbd_work *w, int cancel)
 		req_mod(req, SEND_CANCELED);
 		return 0;
 	}
+	req->pre_send_jif = jiffies;
 
 	/* this time, no connection->send.current_epoch_writes++;
 	 * If it was sent, it was the closing barrier for the last
@@ -1398,6 +1399,7 @@ int w_send_dblock(struct drbd_work *w, int cancel)
 		req_mod(req, SEND_CANCELED);
 		return 0;
 	}
+	req->pre_send_jif = jiffies;
 
 	re_init_if_first_write(connection, req->epoch);
 	maybe_send_barrier(connection, req->epoch);
@@ -1426,6 +1428,7 @@ int w_send_read_req(struct drbd_work *w, int cancel)
 		req_mod(req, SEND_CANCELED);
 		return 0;
 	}
+	req->pre_send_jif = jiffies;
 
 	/* Even read requests may close a write epoch,
 	 * if there was any yet. */
-- 
1.9.1

