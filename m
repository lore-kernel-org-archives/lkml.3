Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaGCIuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:50:25 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45904 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbaGCInU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/23] drbd: add caching oldest request pointers for replication stages
Date: Thu,  3 Jul 2014 10:42:58 +0200
Message-Id: <1404376995-4877-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

A request that is to be shipped to the peer goes through a few stages:
- queued
- sent, waiting for ack
- ack received, waiting for "barrier ack", which is re-order epoch being
  closed on the peer by acknowledging a "cache flush" equivalent
  on the lower level device.

In the later two stages, depending on protocol, we may have already
completed this request to the upper layers, so it won't be found anymore
on device->pending_master_completion[] lists.

Track the oldest request yet to be sent (req_next), the oldest not yet
acknowledged (req_ack_pending) and the oldest "still waiting for
something from the peer" (req_not_net_done), doing short list walks on
the transfer log to find the next pending one whenever such a request
makes progress.

Now we have a fast way to look up the oldest requests,
don't do a transfer log walk every time.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h |   7 ++
 drivers/block/drbd/drbd_req.c | 169 ++++++++++++++++++++++++++++++++----------
 2 files changed, 136 insertions(+), 40 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index f29f107..fa010ea 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -720,6 +720,13 @@ struct drbd_connection {
 	struct drbd_thread worker;
 	struct drbd_thread asender;
 
+	/* cached pointers,
+	 * so we can look up the oldest pending requests more quickly.
+	 * protected by resource->req_lock */
+	struct drbd_request *req_next; /* DRBD 9: todo.req_next */
+	struct drbd_request *req_ack_pending;
+	struct drbd_request *req_not_net_done;
+
 	/* sender side */
 	struct drbd_work_queue sender_work;
 
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 23cd909..3f6a6ed 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -345,12 +345,91 @@ static int drbd_req_put_completion_ref(struct drbd_request *req, struct bio_and_
 	return 1;
 }
 
+static void set_if_null_req_next(struct drbd_peer_device *peer_device, struct drbd_request *req)
+{
+	struct drbd_connection *connection = peer_device ? peer_device->connection : NULL;
+	if (!connection)
+		return;
+	if (connection->req_next == NULL)
+		connection->req_next = req;
+}
+
+static void advance_conn_req_next(struct drbd_peer_device *peer_device, struct drbd_request *req)
+{
+	struct drbd_connection *connection = peer_device ? peer_device->connection : NULL;
+	if (!connection)
+		return;
+	if (connection->req_next != req)
+		return;
+	list_for_each_entry_continue(req, &connection->transfer_log, tl_requests) {
+		const unsigned s = req->rq_state;
+		if (s & RQ_NET_QUEUED)
+			break;
+	}
+	if (&req->tl_requests == &connection->transfer_log)
+		req = NULL;
+	connection->req_next = req;
+}
+
+static void set_if_null_req_ack_pending(struct drbd_peer_device *peer_device, struct drbd_request *req)
+{
+	struct drbd_connection *connection = peer_device ? peer_device->connection : NULL;
+	if (!connection)
+		return;
+	if (connection->req_ack_pending == NULL)
+		connection->req_ack_pending = req;
+}
+
+static void advance_conn_req_ack_pending(struct drbd_peer_device *peer_device, struct drbd_request *req)
+{
+	struct drbd_connection *connection = peer_device ? peer_device->connection : NULL;
+	if (!connection)
+		return;
+	if (connection->req_ack_pending != req)
+		return;
+	list_for_each_entry_continue(req, &connection->transfer_log, tl_requests) {
+		const unsigned s = req->rq_state;
+		if ((s & RQ_NET_SENT) && (s & RQ_NET_PENDING))
+			break;
+	}
+	if (&req->tl_requests == &connection->transfer_log)
+		req = NULL;
+	connection->req_ack_pending = req;
+}
+
+static void set_if_null_req_not_net_done(struct drbd_peer_device *peer_device, struct drbd_request *req)
+{
+	struct drbd_connection *connection = peer_device ? peer_device->connection : NULL;
+	if (!connection)
+		return;
+	if (connection->req_not_net_done == NULL)
+		connection->req_not_net_done = req;
+}
+
+static void advance_conn_req_not_net_done(struct drbd_peer_device *peer_device, struct drbd_request *req)
+{
+	struct drbd_connection *connection = peer_device ? peer_device->connection : NULL;
+	if (!connection)
+		return;
+	if (connection->req_not_net_done != req)
+		return;
+	list_for_each_entry_continue(req, &connection->transfer_log, tl_requests) {
+		const unsigned s = req->rq_state;
+		if ((s & RQ_NET_SENT) && !(s & RQ_NET_DONE))
+			break;
+	}
+	if (&req->tl_requests == &connection->transfer_log)
+		req = NULL;
+	connection->req_not_net_done = req;
+}
+
 /* I'd like this to be the only place that manipulates
  * req->completion_ref and req->kref. */
 static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 		int clear, int set)
 {
 	struct drbd_device *device = req->device;
+	struct drbd_peer_device *peer_device = first_peer_device(device);
 	unsigned s = req->rq_state;
 	int c_put = 0;
 	int k_put = 0;
@@ -379,6 +458,7 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 
 	if (!(s & RQ_NET_QUEUED) && (set & RQ_NET_QUEUED)) {
 		atomic_inc(&req->completion_ref);
+		set_if_null_req_next(peer_device, req);
 	}
 
 	if (!(s & RQ_EXP_BARR_ACK) && (set & RQ_EXP_BARR_ACK))
@@ -386,8 +466,12 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 
 	if (!(s & RQ_NET_SENT) && (set & RQ_NET_SENT)) {
 		/* potentially already completed in the asender thread */
-		if (!(s & RQ_NET_DONE))
+		if (!(s & RQ_NET_DONE)) {
 			atomic_add(req->i.size >> 9, &device->ap_in_flight);
+			set_if_null_req_not_net_done(peer_device, req);
+		}
+		if (s & RQ_NET_PENDING)
+			set_if_null_req_ack_pending(peer_device, req);
 	}
 
 	if (!(s & RQ_COMPLETION_SUSP) && (set & RQ_COMPLETION_SUSP))
@@ -418,10 +502,13 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 		dec_ap_pending(device);
 		++c_put;
 		req->acked_jif = jiffies;
+		advance_conn_req_ack_pending(peer_device, req);
 	}
 
-	if ((s & RQ_NET_QUEUED) && (clear & RQ_NET_QUEUED))
+	if ((s & RQ_NET_QUEUED) && (clear & RQ_NET_QUEUED)) {
 		++c_put;
+		advance_conn_req_next(peer_device, req);
+	}
 
 	if (!(s & RQ_NET_DONE) && (set & RQ_NET_DONE)) {
 		if (s & RQ_NET_SENT)
@@ -429,6 +516,13 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 		if (s & RQ_EXP_BARR_ACK)
 			++k_put;
 		req->net_done_jif = jiffies;
+
+		/* in ahead/behind mode, or just in case,
+		 * before we finally destroy this request,
+		 * the caching pointers must not reference it anymore */
+		advance_conn_req_next(peer_device, req);
+		advance_conn_req_ack_pending(peer_device, req);
+		advance_conn_req_not_net_done(peer_device, req);
 	}
 
 	/* potentially complete and destroy */
@@ -1423,36 +1517,13 @@ int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct
 	return limit;
 }
 
-static void find_oldest_requests(
-		struct drbd_connection *connection,
-		struct drbd_device *device,
-		struct drbd_request **oldest_req_waiting_for_peer,
-		struct drbd_request **oldest_req_waiting_for_disk)
-{
-	struct drbd_request *r;
-	*oldest_req_waiting_for_peer = NULL;
-	*oldest_req_waiting_for_disk = NULL;
-	list_for_each_entry(r, &connection->transfer_log, tl_requests) {
-		const unsigned s = r->rq_state;
-		if (!*oldest_req_waiting_for_peer
-		&& ((s & RQ_NET_MASK) && !(s & RQ_NET_DONE)))
-			*oldest_req_waiting_for_peer = r;
-
-		if (!*oldest_req_waiting_for_disk
-		&& (s & RQ_LOCAL_PENDING) && r->device == device)
-			*oldest_req_waiting_for_disk = r;
-
-		if (*oldest_req_waiting_for_peer && *oldest_req_waiting_for_disk)
-			break;
-	}
-}
-
 void request_timer_fn(unsigned long data)
 {
 	struct drbd_device *device = (struct drbd_device *) data;
 	struct drbd_connection *connection = first_peer_device(device)->connection;
-	struct drbd_request *req_disk, *req_peer; /* oldest request */
+	struct drbd_request *req_read, *req_write, *req_peer; /* oldest request */
 	struct net_conf *nc;
+	unsigned long oldest_submit_jif;
 	unsigned long ent = 0, dt = 0, et, nt; /* effective timeout = ko_count * timeout */
 	unsigned long now;
 
@@ -1473,14 +1544,31 @@ void request_timer_fn(unsigned long data)
 		return; /* Recurring timer stopped */
 
 	now = jiffies;
+	nt = now + et;
 
 	spin_lock_irq(&device->resource->req_lock);
-	find_oldest_requests(connection, device, &req_peer, &req_disk);
-	if (req_peer == NULL && req_disk == NULL) {
-		spin_unlock_irq(&device->resource->req_lock);
-		mod_timer(&device->request_timer, now + et);
-		return;
-	}
+	req_read = list_first_entry_or_null(&device->pending_completion[0], struct drbd_request, req_pending_local);
+	req_write = list_first_entry_or_null(&device->pending_completion[1], struct drbd_request, req_pending_local);
+	req_peer = connection->req_not_net_done;
+	/* maybe the oldest request waiting for the peer is in fact still
+	 * blocking in tcp sendmsg */
+	if (!req_peer && connection->req_next && connection->req_next->pre_send_jif)
+		req_peer = connection->req_next;
+
+	/* evaluate the oldest peer request only in one timer! */
+	if (req_peer && req_peer->device != device)
+		req_peer = NULL;
+
+	/* do we have something to evaluate? */
+	if (req_peer == NULL && req_write == NULL && req_read == NULL)
+		goto out;
+
+	oldest_submit_jif =
+		(req_write && req_read)
+		? ( time_before(req_write->pre_submit_jif, req_read->pre_submit_jif)
+		  ? req_write->pre_submit_jif : req_read->pre_submit_jif )
+		: req_write ? req_write->pre_submit_jif
+		: req_read ? req_read->pre_submit_jif : now;
 
 	/* The request is considered timed out, if
 	 * - we have some effective timeout from the configuration,
@@ -1499,13 +1587,13 @@ void request_timer_fn(unsigned long data)
 	 * to expire twice (worst case) to become effective. Good enough.
 	 */
 	if (ent && req_peer &&
-		 time_after(now, req_peer->start_jif + ent) &&
+		 time_after(now, req_peer->pre_send_jif + ent) &&
 		!time_in_range(now, connection->last_reconnect_jif, connection->last_reconnect_jif + ent)) {
 		drbd_warn(device, "Remote failed to finish a request within ko-count * timeout\n");
 		_drbd_set_state(_NS(device, conn, C_TIMEOUT), CS_VERBOSE | CS_HARD, NULL);
 	}
-	if (dt && req_disk &&
-		 time_after(now, req_disk->start_jif + dt) &&
+	if (dt && oldest_submit_jif != now &&
+		 time_after(now, oldest_submit_jif + dt) &&
 		!time_in_range(now, device->last_reattach_jif, device->last_reattach_jif + dt)) {
 		drbd_warn(device, "Local backing device failed to meet the disk-timeout\n");
 		__drbd_chk_io_error(device, DRBD_FORCE_DETACH);
@@ -1513,11 +1601,12 @@ void request_timer_fn(unsigned long data)
 
 	/* Reschedule timer for the nearest not already expired timeout.
 	 * Fallback to now + min(effective network timeout, disk timeout). */
-	ent = (ent && req_peer && time_before(now, req_peer->start_jif + ent))
-		? req_peer->start_jif + ent : now + et;
-	dt = (dt && req_disk && time_before(now, req_disk->start_jif + dt))
-		? req_disk->start_jif + dt : now + et;
+	ent = (ent && req_peer && time_before(now, req_peer->pre_send_jif + ent))
+		? req_peer->pre_send_jif + ent : now + et;
+	dt = (dt && oldest_submit_jif != now && time_before(now, oldest_submit_jif + dt))
+		? oldest_submit_jif + dt : now + et;
 	nt = time_before(ent, dt) ? ent : dt;
+out:
 	spin_unlock_irq(&connection->resource->req_lock);
 	mod_timer(&device->request_timer, nt);
 }
-- 
1.9.1

