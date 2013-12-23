Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab3LWV7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:59:12 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60681 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab3LWV65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:57 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 20/27] drbd: struct drbd_peer_request: Use drbd_work instead of drbd_device_work
Date: Mon, 23 Dec 2013 22:50:49 +0100
Message-Id: <1387835456-29695-21-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    3 +-
 drivers/block/drbd/drbd_receiver.c |   91 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_worker.c   |   50 +++++++++-----------
 3 files changed, 69 insertions(+), 75 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 7185c98..12dc970 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -352,7 +352,8 @@ struct digest_info {
 };
 
 struct drbd_peer_request {
-	struct drbd_device_work dw;
+	struct drbd_work w;
+	struct drbd_peer_device *peer_device;
 	struct drbd_epoch *epoch; /* for writes */
 	struct page *pages;
 	atomic_t pending_bios;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index c99f252..e2e01b4 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -200,19 +200,17 @@ static struct page *__drbd_alloc_pages(struct drbd_device *device,
 static void reclaim_finished_net_peer_reqs(struct drbd_device *device,
 					   struct list_head *to_be_freed)
 {
-	struct drbd_peer_request *peer_req;
-	struct list_head *le, *tle;
+	struct drbd_peer_request *peer_req, *tmp;
 
 	/* The EEs are always appended to the end of the list. Since
 	   they are sent in order over the wire, they have to finish
 	   in order. As soon as we see the first not finished we can
 	   stop to examine the list... */
 
-	list_for_each_safe(le, tle, &device->net_ee) {
-		peer_req = list_entry(le, struct drbd_peer_request, dw.w.list);
+	list_for_each_entry_safe(peer_req, tmp, &device->net_ee, w.list) {
 		if (drbd_peer_req_has_active_page(peer_req))
 			break;
-		list_move(le, to_be_freed);
+		list_move(&peer_req->w.list, to_be_freed);
 	}
 }
 
@@ -225,7 +223,7 @@ static void drbd_kick_lo_and_reclaim_net(struct drbd_device *device)
 	reclaim_finished_net_peer_reqs(device, &reclaimed);
 	spin_unlock_irq(&device->resource->req_lock);
 
-	list_for_each_entry_safe(peer_req, t, &reclaimed, dw.w.list)
+	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
 		drbd_free_net_peer_req(device, peer_req);
 }
 
@@ -363,7 +361,7 @@ drbd_alloc_peer_req(struct drbd_peer_device *peer_device, u64 id, sector_t secto
 	peer_req->i.waiting = false;
 
 	peer_req->epoch = NULL;
-	peer_req->dw.device = device;
+	peer_req->peer_device = peer_device;
 	peer_req->pages = page;
 	atomic_set(&peer_req->pending_bios, 0);
 	peer_req->flags = 0;
@@ -402,7 +400,7 @@ int drbd_free_peer_reqs(struct drbd_device *device, struct list_head *list)
 	list_splice_init(list, &work_list);
 	spin_unlock_irq(&device->resource->req_lock);
 
-	list_for_each_entry_safe(peer_req, t, &work_list, dw.w.list) {
+	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
 		__drbd_free_peer_req(device, peer_req, is_net);
 		count++;
 	}
@@ -424,18 +422,18 @@ static int drbd_finish_peer_reqs(struct drbd_device *device)
 	list_splice_init(&device->done_ee, &work_list);
 	spin_unlock_irq(&device->resource->req_lock);
 
-	list_for_each_entry_safe(peer_req, t, &reclaimed, dw.w.list)
+	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
 		drbd_free_net_peer_req(device, peer_req);
 
 	/* possible callbacks here:
 	 * e_end_block, and e_end_resync_block, e_send_superseded.
 	 * all ignore the last argument.
 	 */
-	list_for_each_entry_safe(peer_req, t, &work_list, dw.w.list) {
+	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
 		int err2;
 
 		/* list_del not necessary, next/prev members not touched */
-		err2 = peer_req->dw.w.cb(&peer_req->dw.w, !!err);
+		err2 = peer_req->w.cb(&peer_req->w, !!err);
 		if (!err)
 			err = err2;
 		drbd_free_peer_req(device, peer_req);
@@ -1664,10 +1662,10 @@ static int recv_dless_read(struct drbd_peer_device *peer_device, struct drbd_req
  */
 static int e_end_resync_block(struct drbd_work *w, int unused)
 {
-	struct drbd_device_work *dw = device_work(w);
 	struct drbd_peer_request *peer_req =
-		container_of(dw, struct drbd_peer_request, dw);
-	struct drbd_device *device = dw->device;
+		container_of(w, struct drbd_peer_request, w);
+	struct drbd_peer_device *peer_device = peer_req->peer_device;
+	struct drbd_device *device = peer_device->device;
 	sector_t sector = peer_req->i.sector;
 	int err;
 
@@ -1675,12 +1673,12 @@ static int e_end_resync_block(struct drbd_work *w, int unused)
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 		drbd_set_in_sync(device, sector, peer_req->i.size);
-		err = drbd_send_ack(first_peer_device(device), P_RS_WRITE_ACK, peer_req);
+		err = drbd_send_ack(peer_device, P_RS_WRITE_ACK, peer_req);
 	} else {
 		/* Record failure to sync */
 		drbd_rs_failed_io(device, sector, peer_req->i.size);
 
-		err  = drbd_send_ack(first_peer_device(device), P_NEG_ACK, peer_req);
+		err  = drbd_send_ack(peer_device, P_NEG_ACK, peer_req);
 	}
 	dec_unacked(device);
 
@@ -1703,10 +1701,10 @@ static int recv_resync_read(struct drbd_peer_device *peer_device, sector_t secto
 	/* corresponding dec_unacked() in e_end_resync_block()
 	 * respective _drbd_clear_done_ee */
 
-	peer_req->dw.w.cb = e_end_resync_block;
+	peer_req->w.cb = e_end_resync_block;
 
 	spin_lock_irq(&device->resource->req_lock);
-	list_add(&peer_req->dw.w.list, &device->sync_ee);
+	list_add(&peer_req->w.list, &device->sync_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
 	atomic_add(data_size >> 9, &device->rs_sect_ev);
@@ -1716,7 +1714,7 @@ static int recv_resync_read(struct drbd_peer_device *peer_device, sector_t secto
 	/* don't care for the reason here */
 	drbd_err(device, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&device->resource->req_lock);
-	list_del(&peer_req->dw.w.list);
+	list_del(&peer_req->w.list);
 	spin_unlock_irq(&device->resource->req_lock);
 
 	drbd_free_peer_req(device, peer_req);
@@ -1836,10 +1834,10 @@ static void restart_conflicting_writes(struct drbd_device *device,
  */
 static int e_end_block(struct drbd_work *w, int cancel)
 {
-	struct drbd_device_work *dw = device_work(w);
 	struct drbd_peer_request *peer_req =
-		container_of(dw, struct drbd_peer_request, dw);
-	struct drbd_device *device = dw->device;
+		container_of(w, struct drbd_peer_request, w);
+	struct drbd_peer_device *peer_device = peer_req->peer_device;
+	struct drbd_device *device = peer_device->device;
 	sector_t sector = peer_req->i.sector;
 	int err = 0, pcmd;
 
@@ -1849,11 +1847,11 @@ static int e_end_block(struct drbd_work *w, int cancel)
 				device->state.conn <= C_PAUSED_SYNC_T &&
 				peer_req->flags & EE_MAY_SET_IN_SYNC) ?
 				P_RS_WRITE_ACK : P_WRITE_ACK;
-			err = drbd_send_ack(first_peer_device(device), pcmd, peer_req);
+			err = drbd_send_ack(peer_device, pcmd, peer_req);
 			if (pcmd == P_RS_WRITE_ACK)
 				drbd_set_in_sync(device, sector, peer_req->i.size);
 		} else {
-			err = drbd_send_ack(first_peer_device(device), P_NEG_ACK, peer_req);
+			err = drbd_send_ack(peer_device, P_NEG_ACK, peer_req);
 			/* we expect it to be marked out of sync anyways...
 			 * maybe assert this?  */
 		}
@@ -1876,30 +1874,31 @@ static int e_end_block(struct drbd_work *w, int cancel)
 	return err;
 }
 
-static int e_send_ack(struct drbd_device_work *dw, enum drbd_packet ack)
+static int e_send_ack(struct drbd_work *w, enum drbd_packet ack)
 {
-	struct drbd_device *device = dw->device;
 	struct drbd_peer_request *peer_req =
-		container_of(dw, struct drbd_peer_request, dw);
+		container_of(w, struct drbd_peer_request, w);
+	struct drbd_peer_device *peer_device = peer_req->peer_device;
 	int err;
 
-	err = drbd_send_ack(first_peer_device(device), ack, peer_req);
-	dec_unacked(device);
+	err = drbd_send_ack(peer_device, ack, peer_req);
+	dec_unacked(peer_device->device);
 
 	return err;
 }
 
 static int e_send_superseded(struct drbd_work *w, int unused)
 {
-	return e_send_ack(device_work(w), P_SUPERSEDED);
+	return e_send_ack(w, P_SUPERSEDED);
 }
 
 static int e_send_retry_write(struct drbd_work *w, int unused)
 {
-	struct drbd_device_work *dw = device_work(w);
-	struct drbd_connection *connection = first_peer_device(dw->device)->connection;
+	struct drbd_peer_request *peer_req =
+		container_of(w, struct drbd_peer_request, w);
+	struct drbd_connection *connection = peer_req->peer_device->connection;
 
-	return e_send_ack(dw, connection->agreed_pro_version >= 100 ?
+	return e_send_ack(w, connection->agreed_pro_version >= 100 ?
 			     P_RETRY_WRITE : P_SUPERSEDED);
 }
 
@@ -1946,7 +1945,7 @@ static bool overlapping_resync_write(struct drbd_device *device, struct drbd_pee
 	bool rv = 0;
 
 	spin_lock_irq(&device->resource->req_lock);
-	list_for_each_entry(rs_req, &device->sync_ee, dw.w.list) {
+	list_for_each_entry(rs_req, &device->sync_ee, w.list) {
 		if (overlaps(peer_req->i.sector, peer_req->i.size,
 			     rs_req->i.sector, rs_req->i.size)) {
 			rv = 1;
@@ -2117,9 +2116,9 @@ static int handle_write_conflicts(struct drbd_device *device,
 					  superseded ? "local" : "remote");
 
 			inc_unacked(device);
-			peer_req->dw.w.cb = superseded ? e_send_superseded :
+			peer_req->w.cb = superseded ? e_send_superseded :
 						   e_send_retry_write;
-			list_add_tail(&peer_req->dw.w.list, &device->done_ee);
+			list_add_tail(&peer_req->w.list, &device->done_ee);
 			wake_asender(first_peer_device(device)->connection);
 
 			err = -ENOENT;
@@ -2215,7 +2214,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 		return -EIO;
 	}
 
-	peer_req->dw.w.cb = e_end_block;
+	peer_req->w.cb = e_end_block;
 
 	dp_flags = be32_to_cpu(p->dp_flags);
 	rw |= wire_flags_to_bio(device, dp_flags);
@@ -2255,7 +2254,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 		update_peer_seq(peer_device, peer_seq);
 		spin_lock_irq(&device->resource->req_lock);
 	}
-	list_add(&peer_req->dw.w.list, &device->active_ee);
+	list_add(&peer_req->w.list, &device->active_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
 	if (device->state.conn == C_SYNC_TARGET)
@@ -2302,7 +2301,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	/* don't care for the reason here */
 	drbd_err(device, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&device->resource->req_lock);
-	list_del(&peer_req->dw.w.list);
+	list_del(&peer_req->w.list);
 	drbd_remove_epoch_entry_interval(device, peer_req);
 	spin_unlock_irq(&device->resource->req_lock);
 	if (peer_req->flags & EE_CALL_AL_COMPLETE_IO)
@@ -2457,13 +2456,13 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 
 	switch (pi->cmd) {
 	case P_DATA_REQUEST:
-		peer_req->dw.w.cb = w_e_end_data_req;
+		peer_req->w.cb = w_e_end_data_req;
 		fault_type = DRBD_FAULT_DT_RD;
 		/* application IO, don't drbd_rs_begin_io */
 		goto submit;
 
 	case P_RS_DATA_REQUEST:
-		peer_req->dw.w.cb = w_e_end_rsdata_req;
+		peer_req->w.cb = w_e_end_rsdata_req;
 		fault_type = DRBD_FAULT_RS_RD;
 		/* used in the sector offset progress display */
 		device->bm_resync_fo = BM_SECT_TO_BIT(sector);
@@ -2487,13 +2486,13 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 
 		if (pi->cmd == P_CSUM_RS_REQUEST) {
 			D_ASSERT(device, peer_device->connection->agreed_pro_version >= 89);
-			peer_req->dw.w.cb = w_e_end_csum_rs_req;
+			peer_req->w.cb = w_e_end_csum_rs_req;
 			/* used in the sector offset progress display */
 			device->bm_resync_fo = BM_SECT_TO_BIT(sector);
 		} else if (pi->cmd == P_OV_REPLY) {
 			/* track progress, we may need to throttle */
 			atomic_add(size >> 9, &device->rs_sect_in);
-			peer_req->dw.w.cb = w_e_end_ov_reply;
+			peer_req->w.cb = w_e_end_ov_reply;
 			dec_rs_pending(device);
 			/* drbd_rs_begin_io done when we sent this request,
 			 * but accounting still needs to be done. */
@@ -2517,7 +2516,7 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 			drbd_info(device, "Online Verify start sector: %llu\n",
 					(unsigned long long)sector);
 		}
-		peer_req->dw.w.cb = w_e_end_ov_req;
+		peer_req->w.cb = w_e_end_ov_req;
 		fault_type = DRBD_FAULT_RS_RD;
 		break;
 
@@ -2558,7 +2557,7 @@ submit_for_resync:
 submit:
 	inc_unacked(device);
 	spin_lock_irq(&device->resource->req_lock);
-	list_add_tail(&peer_req->dw.w.list, &device->read_ee);
+	list_add_tail(&peer_req->w.list, &device->read_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
 	if (drbd_submit_peer_request(device, peer_req, READ, fault_type) == 0)
@@ -2567,7 +2566,7 @@ submit:
 	/* don't care for the reason here */
 	drbd_err(device, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&device->resource->req_lock);
-	list_del(&peer_req->dw.w.list);
+	list_del(&peer_req->w.list);
 	spin_unlock_irq(&device->resource->req_lock);
 	/* no drbd_rs_complete_io(), we are dropping the connection anyways */
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 514d189..abcfdab 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -100,11 +100,11 @@ void drbd_md_io_complete(struct bio *bio, int error)
 void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_device *device = peer_req->dw.device;
+	struct drbd_device *device = peer_req->peer_device->device;
 
 	spin_lock_irqsave(&device->resource->req_lock, flags);
 	device->read_cnt += peer_req->i.size >> 9;
-	list_del(&peer_req->dw.w.list);
+	list_del(&peer_req->w.list);
 	if (list_empty(&device->read_ee))
 		wake_up(&device->ee_wait);
 	if (test_bit(__EE_WAS_ERROR, &peer_req->flags))
@@ -112,7 +112,7 @@ void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(lo
 	spin_unlock_irqrestore(&device->resource->req_lock, flags);
 
 	drbd_queue_work(&first_peer_device(device)->connection->sender_work,
-			&peer_req->dw.w);
+			&peer_req->w);
 	put_ldev(device);
 }
 
@@ -121,7 +121,7 @@ void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(lo
 static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_device *device = peer_req->dw.device;
+	struct drbd_device *device = peer_req->peer_device->device;
 	struct drbd_interval i;
 	int do_wake;
 	u64 block_id;
@@ -137,7 +137,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 
 	spin_lock_irqsave(&device->resource->req_lock, flags);
 	device->writ_cnt += peer_req->i.size >> 9;
-	list_move_tail(&peer_req->dw.w.list, &device->done_ee);
+	list_move_tail(&peer_req->w.list, &device->done_ee);
 
 	/*
 	 * Do not remove from the write_requests tree here: we did not send the
@@ -172,7 +172,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 void drbd_peer_request_endio(struct bio *bio, int error)
 {
 	struct drbd_peer_request *peer_req = bio->bi_private;
-	struct drbd_device *device = peer_req->dw.device;
+	struct drbd_device *device = peer_req->peer_device->device;
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
 	int is_write = bio_data_dir(bio) == WRITE;
 
@@ -333,9 +333,8 @@ void drbd_csum_bio(struct crypto_hash *tfm, struct bio *bio, void *digest)
 /* MAYBE merge common code with w_e_end_ov_req */
 static int w_e_send_csum(struct drbd_work *w, int cancel)
 {
-	struct drbd_device_work *dw = device_work(w);
-	struct drbd_peer_request *peer_req = container_of(dw, struct drbd_peer_request, dw);
-	struct drbd_device *device = dw->device;
+	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
+	struct drbd_device *device = peer_req->peer_device->device;
 	int digest_size;
 	void *digest;
 	int err = 0;
@@ -398,9 +397,9 @@ static int read_for_csum(struct drbd_peer_device *peer_device, sector_t sector,
 	if (!peer_req)
 		goto defer;
 
-	peer_req->dw.w.cb = w_e_send_csum;
+	peer_req->w.cb = w_e_send_csum;
 	spin_lock_irq(&device->resource->req_lock);
-	list_add(&peer_req->dw.w.list, &device->read_ee);
+	list_add(&peer_req->w.list, &device->read_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
 	atomic_add(size >> 9, &device->rs_sect_ev);
@@ -412,7 +411,7 @@ static int read_for_csum(struct drbd_peer_device *peer_device, sector_t sector,
 	 * retry may or may not help.
 	 * If it does not, you may need to force disconnect. */
 	spin_lock_irq(&device->resource->req_lock);
-	list_del(&peer_req->dw.w.list);
+	list_del(&peer_req->w.list);
 	spin_unlock_irq(&device->resource->req_lock);
 
 	drbd_free_peer_req(device, peer_req);
@@ -983,7 +982,7 @@ static void move_to_net_ee_or_free(struct drbd_device *device, struct drbd_peer_
 		atomic_add(i, &device->pp_in_use_by_net);
 		atomic_sub(i, &device->pp_in_use);
 		spin_lock_irq(&device->resource->req_lock);
-		list_add_tail(&peer_req->dw.w.list, &device->net_ee);
+		list_add_tail(&peer_req->w.list, &device->net_ee);
 		spin_unlock_irq(&device->resource->req_lock);
 		wake_up(&drbd_pp_wait);
 	} else
@@ -998,9 +997,8 @@ static void move_to_net_ee_or_free(struct drbd_device *device, struct drbd_peer_
  */
 int w_e_end_data_req(struct drbd_work *w, int cancel)
 {
-	struct drbd_device_work *dw = device_work(w);
-	struct drbd_peer_request *peer_req = container_of(dw, struct drbd_peer_request, dw);
-	struct drbd_device *device = dw->device;
+	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
+	struct drbd_device *device = peer_req->peer_device->device;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1035,9 +1033,8 @@ int w_e_end_data_req(struct drbd_work *w, int cancel)
  */
 int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 {
-	struct drbd_device_work *dw = device_work(w);
-	struct drbd_peer_request *peer_req = container_of(dw, struct drbd_peer_request, dw);
-	struct drbd_device *device = dw->device;
+	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
+	struct drbd_device *device = peer_req->peer_device->device;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1085,9 +1082,8 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 
 int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 {
-	struct drbd_device_work *dw = device_work(w);
-	struct drbd_peer_request *peer_req = container_of(dw, struct drbd_peer_request, dw);
-	struct drbd_device *device = dw->device;
+	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
+	struct drbd_device *device = peer_req->peer_device->device;
 	struct digest_info *di;
 	int digest_size;
 	void *digest = NULL;
@@ -1149,9 +1145,8 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 
 int w_e_end_ov_req(struct drbd_work *w, int cancel)
 {
-	struct drbd_device_work *dw = device_work(w);
-	struct drbd_peer_request *peer_req = container_of(dw, struct drbd_peer_request, dw);
-	struct drbd_device *device = dw->device;
+	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
+	struct drbd_device *device = peer_req->peer_device->device;
 	sector_t sector = peer_req->i.sector;
 	unsigned int size = peer_req->i.size;
 	int digest_size;
@@ -1206,9 +1201,8 @@ void drbd_ov_out_of_sync_found(struct drbd_device *device, sector_t sector, int
 
 int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 {
-	struct drbd_device_work *dw = device_work(w);
-	struct drbd_peer_request *peer_req = container_of(dw, struct drbd_peer_request, dw);
-	struct drbd_device *device = dw->device;
+	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
+	struct drbd_device *device = peer_req->peer_device->device;
 	struct digest_info *di;
 	void *digest;
 	sector_t sector = peer_req->i.sector;
-- 
1.7.9.5

