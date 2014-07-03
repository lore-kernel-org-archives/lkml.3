Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492AbaGCIuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:50:21 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45905 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbaGCInU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/23] drbd: track timing details of peer_requests
Date: Thu,  3 Jul 2014 10:43:00 +0200
Message-Id: <1404376995-4877-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

To be able to present timing details in debugfs,
we need to track preparation/submit times of peer requests.

Track peer request flags early,
before they are put on the epoch_entry lists.

Waiting for activity log transactions may be a major latency factor.
We want to be able to present the peer_request state accurately in
debugfs, and what it is waiting for.

Consistently mark/unmark peer requests with EE_CALL_AL_COMPLETE_IO.
Set it only *after* calling drbd_al_begin_io(),
clear it as soon as we call drbd_al_complete_io().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      | 15 ++++++++
 drivers/block/drbd/drbd_receiver.c | 78 +++++++++++++++++++++++---------------
 drivers/block/drbd/drbd_worker.c   |  1 +
 3 files changed, 64 insertions(+), 30 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 81f4af4..c7a409f 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -422,6 +422,7 @@ struct drbd_peer_request {
 	struct drbd_interval i;
 	/* see comments on ee flag bits below */
 	unsigned long flags;
+	unsigned long submit_jif;
 	union {
 		u64 block_id;
 		struct digest_info *digest;
@@ -464,6 +465,17 @@ enum {
 
 	/* Is set when net_conf had two_primaries set while creating this peer_req */
 	__EE_IN_INTERVAL_TREE,
+
+	/* for debugfs: */
+	/* has this been submitted, or does it still wait for something else? */
+	__EE_SUBMITTED,
+
+	/* this is/was a write request */
+	__EE_WRITE,
+
+	/* this originates from application on peer
+	 * (not some resync or verify or other DRBD internal request) */
+	__EE_APPLICATION,
 };
 #define EE_CALL_AL_COMPLETE_IO (1<<__EE_CALL_AL_COMPLETE_IO)
 #define EE_MAY_SET_IN_SYNC     (1<<__EE_MAY_SET_IN_SYNC)
@@ -475,6 +487,9 @@ enum {
 #define EE_RESTART_REQUESTS	(1<<__EE_RESTART_REQUESTS)
 #define EE_SEND_WRITE_ACK	(1<<__EE_SEND_WRITE_ACK)
 #define EE_IN_INTERVAL_TREE	(1<<__EE_IN_INTERVAL_TREE)
+#define EE_SUBMITTED		(1<<__EE_SUBMITTED)
+#define EE_WRITE		(1<<__EE_WRITE)
+#define EE_APPLICATION		(1<<__EE_APPLICATION)
 
 /* flag bits per device */
 enum {
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 0d3cbd8..2f67dc0 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -389,11 +389,16 @@ drbd_alloc_peer_req(struct drbd_peer_device *peer_device, u64 id, sector_t secto
 void __drbd_free_peer_req(struct drbd_device *device, struct drbd_peer_request *peer_req,
 		       int is_net)
 {
+	might_sleep();
 	if (peer_req->flags & EE_HAS_DIGEST)
 		kfree(peer_req->digest);
 	drbd_free_pages(device, peer_req->pages, is_net);
 	D_ASSERT(device, atomic_read(&peer_req->pending_bios) == 0);
 	D_ASSERT(device, drbd_interval_empty(&peer_req->i));
+	if (!expect(!(peer_req->flags & EE_CALL_AL_COMPLETE_IO))) {
+		peer_req->flags &= ~EE_CALL_AL_COMPLETE_IO;
+		drbd_al_complete_io(device, &peer_req->i);
+	}
 	mempool_free(peer_req, drbd_ee_mempool);
 }
 
@@ -1372,6 +1377,8 @@ int drbd_submit_peer_request(struct drbd_device *device,
 		conn_wait_active_ee_empty(first_peer_device(device)->connection);
 		/* add it to the active list now,
 		 * so we can find it to present it in debugfs */
+		peer_req->submit_jif = jiffies;
+		peer_req->flags |= EE_SUBMITTED;
 		spin_lock_irq(&device->resource->req_lock);
 		list_add_tail(&peer_req->w.list, &device->active_ee);
 		spin_unlock_irq(&device->resource->req_lock);
@@ -1443,6 +1450,9 @@ submit:
 	D_ASSERT(device, page == NULL);
 
 	atomic_set(&peer_req->pending_bios, n_bios);
+	/* for debugfs: update timestamp, mark as submitted */
+	peer_req->submit_jif = jiffies;
+	peer_req->flags |= EE_SUBMITTED;
 	do {
 		bio = bios;
 		bios = bios->bi_next;
@@ -1624,6 +1634,7 @@ read_in_block(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 	if (!peer_req)
 		return NULL;
 
+	peer_req->flags |= EE_WRITE;
 	if (trim)
 		return peer_req;
 
@@ -1780,6 +1791,7 @@ static int recv_resync_read(struct drbd_peer_device *peer_device, sector_t secto
 	 * respective _drbd_clear_done_ee */
 
 	peer_req->w.cb = e_end_resync_block;
+	peer_req->submit_jif = jiffies;
 
 	spin_lock_irq(&device->resource->req_lock);
 	list_add_tail(&peer_req->w.list, &device->sync_ee);
@@ -2196,7 +2208,6 @@ static int handle_write_conflicts(struct drbd_device *device,
 					  (unsigned long long)sector, size,
 					  superseded ? "local" : "remote");
 
-			inc_unacked(device);
 			peer_req->w.cb = superseded ? e_send_superseded :
 						   e_send_retry_write;
 			list_add_tail(&peer_req->w.list, &device->done_ee);
@@ -2255,6 +2266,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 {
 	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
+	struct net_conf *nc;
 	sector_t sector;
 	struct drbd_peer_request *peer_req;
 	struct p_data *p = pi->data;
@@ -2294,6 +2306,8 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	}
 
 	peer_req->w.cb = e_end_block;
+	peer_req->submit_jif = jiffies;
+	peer_req->flags |= EE_APPLICATION;
 
 	dp_flags = be32_to_cpu(p->dp_flags);
 	rw |= wire_flags_to_bio(dp_flags);
@@ -2320,9 +2334,36 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	spin_unlock(&connection->epoch_lock);
 
 	rcu_read_lock();
-	tp = rcu_dereference(peer_device->connection->net_conf)->two_primaries;
+	nc = rcu_dereference(peer_device->connection->net_conf);
+	tp = nc->two_primaries;
+	if (peer_device->connection->agreed_pro_version < 100) {
+		switch (nc->wire_protocol) {
+		case DRBD_PROT_C:
+			dp_flags |= DP_SEND_WRITE_ACK;
+			break;
+		case DRBD_PROT_B:
+			dp_flags |= DP_SEND_RECEIVE_ACK;
+			break;
+		}
+	}
 	rcu_read_unlock();
+
+	if (dp_flags & DP_SEND_WRITE_ACK) {
+		peer_req->flags |= EE_SEND_WRITE_ACK;
+		inc_unacked(device);
+		/* corresponding dec_unacked() in e_end_block()
+		 * respective _drbd_clear_done_ee */
+	}
+
+	if (dp_flags & DP_SEND_RECEIVE_ACK) {
+		/* I really don't like it that the receiver thread
+		 * sends on the msock, but anyways */
+		drbd_send_ack(first_peer_device(device), P_RECV_ACK, peer_req);
+	}
+
 	if (tp) {
+		/* two primaries implies protocol C */
+		D_ASSERT(device, dp_flags & DP_SEND_WRITE_ACK);
 		peer_req->flags |= EE_IN_INTERVAL_TREE;
 		err = wait_for_and_update_peer_seq(peer_device, peer_seq);
 		if (err)
@@ -2352,38 +2393,12 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	if (device->state.conn == C_SYNC_TARGET)
 		wait_event(device->ee_wait, !overlapping_resync_write(device, peer_req));
 
-	if (peer_device->connection->agreed_pro_version < 100) {
-		rcu_read_lock();
-		switch (rcu_dereference(peer_device->connection->net_conf)->wire_protocol) {
-		case DRBD_PROT_C:
-			dp_flags |= DP_SEND_WRITE_ACK;
-			break;
-		case DRBD_PROT_B:
-			dp_flags |= DP_SEND_RECEIVE_ACK;
-			break;
-		}
-		rcu_read_unlock();
-	}
-
-	if (dp_flags & DP_SEND_WRITE_ACK) {
-		peer_req->flags |= EE_SEND_WRITE_ACK;
-		inc_unacked(device);
-		/* corresponding dec_unacked() in e_end_block()
-		 * respective _drbd_clear_done_ee */
-	}
-
-	if (dp_flags & DP_SEND_RECEIVE_ACK) {
-		/* I really don't like it that the receiver thread
-		 * sends on the msock, but anyways */
-		drbd_send_ack(first_peer_device(device), P_RECV_ACK, peer_req);
-	}
-
 	if (device->state.pdsk < D_INCONSISTENT) {
 		/* In case we have the only disk of the cluster, */
 		drbd_set_out_of_sync(device, peer_req->i.sector, peer_req->i.size);
-		peer_req->flags |= EE_CALL_AL_COMPLETE_IO;
 		peer_req->flags &= ~EE_MAY_SET_IN_SYNC;
 		drbd_al_begin_io(device, &peer_req->i);
+		peer_req->flags |= EE_CALL_AL_COMPLETE_IO;
 	}
 
 	err = drbd_submit_peer_request(device, peer_req, rw, DRBD_FAULT_DT_WR);
@@ -2396,8 +2411,10 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	list_del(&peer_req->w.list);
 	drbd_remove_epoch_entry_interval(device, peer_req);
 	spin_unlock_irq(&device->resource->req_lock);
-	if (peer_req->flags & EE_CALL_AL_COMPLETE_IO)
+	if (peer_req->flags & EE_CALL_AL_COMPLETE_IO) {
+		peer_req->flags &= ~EE_CALL_AL_COMPLETE_IO;
 		drbd_al_complete_io(device, &peer_req->i);
+	}
 
 out_interrupted:
 	drbd_may_finish_epoch(connection, peer_req->epoch, EV_PUT + EV_CLEANUP);
@@ -2561,6 +2578,7 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 		peer_req->w.cb = w_e_end_data_req;
 		fault_type = DRBD_FAULT_DT_RD;
 		/* application IO, don't drbd_rs_begin_io */
+		peer_req->flags |= EE_APPLICATION;
 		goto submit;
 
 	case P_RS_DATA_REQUEST:
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 48975a2..b908e9b 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -132,6 +132,7 @@ void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __releases(l
 	i = peer_req->i;
 	do_al_complete_io = peer_req->flags & EE_CALL_AL_COMPLETE_IO;
 	block_id = peer_req->block_id;
+	peer_req->flags &= ~EE_CALL_AL_COMPLETE_IO;
 
 	spin_lock_irqsave(&device->resource->req_lock, flags);
 	device->writ_cnt += peer_req->i.size >> 9;
-- 
1.9.1

