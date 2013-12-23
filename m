Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab3LWWFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:05:06 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60667 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107Ab3LWV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:54 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 17/27] drbd: Create a dedicated struct drbd_device_work
Date: Mon, 23 Dec 2013 22:50:46 +0100
Message-Id: <1387835456-29695-18-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

drbd_device_work is a work item that has a reference to a device,
while drbd_work is a more generic work item that does not carry
a reference to a device.

All callbacks get a pointer to a drbd_work instance, those callbacks
that expect a drbd_device_work use the container_of macro to get it.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |   16 +++--
 drivers/block/drbd/drbd_int.h      |   29 ++++----
 drivers/block/drbd/drbd_main.c     |   32 ++++-----
 drivers/block/drbd/drbd_receiver.c |   84 +++++++++++-----------
 drivers/block/drbd/drbd_req.c      |   41 ++++++-----
 drivers/block/drbd/drbd_req.h      |    4 +-
 drivers/block/drbd/drbd_state.c    |   21 +++---
 drivers/block/drbd/drbd_worker.c   |  134 ++++++++++++++++++++----------------
 8 files changed, 197 insertions(+), 164 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index cacd47a..d971cb2 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -95,11 +95,13 @@ struct __packed al_transaction_on_disk {
 
 struct update_odbm_work {
 	struct drbd_work w;
+	struct drbd_device *device;
 	unsigned int enr;
 };
 
 struct update_al_work {
 	struct drbd_work w;
+	struct drbd_device *device;
 	struct completion event;
 	int err;
 };
@@ -593,7 +595,7 @@ _al_write_transaction(struct drbd_device *device)
 static int w_al_write_transaction(struct drbd_work *w, int unused)
 {
 	struct update_al_work *aw = container_of(w, struct update_al_work, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device *device = aw->device;
 	int err;
 
 	err = _al_write_transaction(device);
@@ -612,8 +614,9 @@ static int al_write_transaction(struct drbd_device *device, bool delegate)
 		struct update_al_work al_work;
 		init_completion(&al_work.event);
 		al_work.w.cb = w_al_write_transaction;
-		al_work.w.device = device;
-		drbd_queue_work_front(&first_peer_device(device)->connection->sender_work, &al_work.w);
+		al_work.device = device;
+		drbd_queue_work_front(&first_peer_device(device)->connection->sender_work,
+				      &al_work.w);
 		wait_for_completion(&al_work.event);
 		return al_work.err;
 	} else
@@ -683,7 +686,7 @@ int drbd_initialize_al(struct drbd_device *device, void *buffer)
 static int w_update_odbm(struct drbd_work *w, int unused)
 {
 	struct update_odbm_work *udw = container_of(w, struct update_odbm_work, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device *device = udw->device;
 	struct sib_info sib = { .sib_reason = SIB_SYNC_PROGRESS, };
 
 	if (!get_ldev(device)) {
@@ -794,8 +797,9 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *device, sector_t secto
 			if (udw) {
 				udw->enr = ext->lce.lc_number;
 				udw->w.cb = w_update_odbm;
-				udw->w.device = device;
-				drbd_queue_work_front(&first_peer_device(device)->connection->sender_work, &udw->w);
+				udw->device = device;
+				drbd_queue_work_front(&first_peer_device(device)->connection->sender_work,
+						      &udw->w);
 			} else {
 				drbd_warn(device, "Could not kmalloc an udw\n");
 			}
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 5cf496d..eb2bc90 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -280,10 +280,11 @@ static inline enum drbd_thread_state get_t_state(struct drbd_thread *thi)
 struct drbd_work {
 	struct list_head list;
 	int (*cb)(struct drbd_work *, int cancel);
-	union {
-		struct drbd_device *device;
-		struct drbd_connection *connection;
-	};
+};
+
+struct drbd_device_work {
+	struct drbd_work w;
+	struct drbd_device *device;
 };
 
 #include "drbd_interval.h"
@@ -292,6 +293,7 @@ extern int drbd_wait_misc(struct drbd_device *, struct drbd_interval *);
 
 struct drbd_request {
 	struct drbd_work w;
+	struct drbd_device *device;
 
 	/* if local IO is not allowed, will be NULL.
 	 * if local IO _is_ allowed, holds the locally submitted bio clone,
@@ -355,7 +357,7 @@ struct digest_info {
 };
 
 struct drbd_peer_request {
-	struct drbd_work w;
+	struct drbd_device_work dw;
 	struct drbd_epoch *epoch; /* for writes */
 	struct page *pages;
 	atomic_t pending_bios;
@@ -681,11 +683,11 @@ struct drbd_device {
 	struct gendisk	    *vdisk;
 
 	unsigned long last_reattach_jif;
-	struct drbd_work  resync_work,
-			  unplug_work,
-			  go_diskless,
-			  md_sync_work,
-			  start_resync_work;
+	struct drbd_work resync_work;
+	struct drbd_work unplug_work;
+	struct drbd_work go_diskless;
+	struct drbd_work md_sync_work;
+	struct drbd_work start_resync_work;
 	struct timer_list resync_timer;
 	struct timer_list md_sync_timer;
 	struct timer_list start_resync_timer;
@@ -1860,7 +1862,8 @@ static inline void put_ldev(struct drbd_device *device)
 		if (device->state.disk == D_FAILED) {
 			/* all application IO references gone. */
 			if (!test_and_set_bit(GO_DISKLESS, &device->flags))
-				drbd_queue_work(&first_peer_device(device)->connection->sender_work, &device->go_diskless);
+				drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+						&device->go_diskless);
 		}
 		wake_up(&device->misc_wait);
 	}
@@ -2087,7 +2090,9 @@ static inline void dec_ap_bio(struct drbd_device *device)
 
 	if (ap_bio == 0 && test_bit(BITMAP_IO, &device->flags)) {
 		if (!test_and_set_bit(BITMAP_IO_QUEUED, &device->flags))
-			drbd_queue_work(&first_peer_device(device)->connection->sender_work, &device->bm_io_work.w);
+			drbd_queue_work(&first_peer_device(device)->
+				connection->sender_work,
+				&device->bm_io_work.w);
 	}
 
 	/* this currently does wake_up for every dec_ap_bio!
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 7f178dc..0500b56 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -312,7 +312,7 @@ void tl_abort_disk_io(struct drbd_device *device)
 	list_for_each_entry_safe(req, r, &connection->transfer_log, tl_requests) {
 		if (!(req->rq_state & RQ_LOCAL_PENDING))
 			continue;
-		if (req->w.device != device)
+		if (req->device != device)
 			continue;
 		_req_mod(req, ABORT_DISK_IO);
 	}
@@ -1917,13 +1917,6 @@ void drbd_init_set_defaults(struct drbd_device *device)
 	device->bm_io_work.w.cb = w_bitmap_io;
 	device->start_resync_work.cb = w_start_resync;
 
-	device->resync_work.device  = device;
-	device->unplug_work.device  = device;
-	device->go_diskless.device  = device;
-	device->md_sync_work.device = device;
-	device->bm_io_work.w.device = device;
-	device->start_resync_work.device = device;
-
 	init_timer(&device->resync_timer);
 	init_timer(&device->md_sync_timer);
 	init_timer(&device->start_resync_timer);
@@ -2222,12 +2215,12 @@ static void do_retry(struct work_struct *ws)
 	spin_unlock_irq(&retry->lock);
 
 	list_for_each_entry_safe(req, tmp, &writes, tl_requests) {
-		struct drbd_device *device = req->w.device;
+		struct drbd_device *device = req->device;
 		struct bio *bio = req->master_bio;
 		unsigned long start_time = req->start_time;
 		bool expected;
 
-		expected = 
+		expected =
 			expect(atomic_read(&req->completion_ref) == 0) &&
 			expect(req->rq_state & RQ_POSTPONED) &&
 			expect((req->rq_state & RQ_LOCAL_PENDING) == 0 ||
@@ -2273,7 +2266,7 @@ void drbd_restart_request(struct drbd_request *req)
 	/* Drop the extra reference that would otherwise
 	 * have been dropped by complete_master_bio.
 	 * do_retry() needs to grab a new one. */
-	dec_ap_bio(req->w.device);
+	dec_ap_bio(req->device);
 
 	queue_work(retry.wq, &retry.worker);
 }
@@ -3468,8 +3461,9 @@ int drbd_bmio_clear_n_write(struct drbd_device *device)
 
 static int w_bitmap_io(struct drbd_work *w, int unused)
 {
-	struct bm_io_work *work = container_of(w, struct bm_io_work, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device *device =
+		container_of(w, struct drbd_device, bm_io_work.w);
+	struct bm_io_work *work = &device->bm_io_work;
 	int rv = -EIO;
 
 	D_ASSERT(device, atomic_read(&device->ap_bio_cnt) == 0);
@@ -3509,7 +3503,8 @@ void drbd_ldev_destroy(struct drbd_device *device)
 
 static int w_go_diskless(struct drbd_work *w, int unused)
 {
-	struct drbd_device *device = w->device;
+	struct drbd_device *device =
+		container_of(w, struct drbd_device, go_diskless);
 
 	D_ASSERT(device, device->state.disk == D_FAILED);
 	/* we cannot assert local_cnt == 0 here, as get_ldev_if_state will
@@ -3583,7 +3578,8 @@ void drbd_queue_bitmap_io(struct drbd_device *device,
 	set_bit(BITMAP_IO, &device->flags);
 	if (atomic_read(&device->ap_bio_cnt) == 0) {
 		if (!test_and_set_bit(BITMAP_IO_QUEUED, &device->flags))
-			drbd_queue_work(&first_peer_device(device)->connection->sender_work, &device->bm_io_work.w);
+			drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+					&device->bm_io_work.w);
 	}
 	spin_unlock_irq(&device->resource->req_lock);
 }
@@ -3643,12 +3639,14 @@ static void md_sync_timer_fn(unsigned long data)
 
 	/* must not double-queue! */
 	if (list_empty(&device->md_sync_work.list))
-		drbd_queue_work_front(&first_peer_device(device)->connection->sender_work, &device->md_sync_work);
+		drbd_queue_work_front(&first_peer_device(device)->connection->sender_work,
+				      &device->md_sync_work);
 }
 
 static int w_md_sync(struct drbd_work *w, int unused)
 {
-	struct drbd_device *device = w->device;
+	struct drbd_device *device =
+		container_of(w, struct drbd_device, md_sync_work);
 
 	drbd_warn(device, "md_sync_timer expired! Worker calls drbd_md_sync().\n");
 #ifdef DEBUG
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 250c8d4..3c88efa 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -209,7 +209,7 @@ static void reclaim_finished_net_peer_reqs(struct drbd_device *device,
 	   stop to examine the list... */
 
 	list_for_each_safe(le, tle, &device->net_ee) {
-		peer_req = list_entry(le, struct drbd_peer_request, w.list);
+		peer_req = list_entry(le, struct drbd_peer_request, dw.w.list);
 		if (drbd_peer_req_has_active_page(peer_req))
 			break;
 		list_move(le, to_be_freed);
@@ -225,7 +225,7 @@ static void drbd_kick_lo_and_reclaim_net(struct drbd_device *device)
 	reclaim_finished_net_peer_reqs(device, &reclaimed);
 	spin_unlock_irq(&device->resource->req_lock);
 
-	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
+	list_for_each_entry_safe(peer_req, t, &reclaimed, dw.w.list)
 		drbd_free_net_peer_req(device, peer_req);
 }
 
@@ -363,7 +363,7 @@ drbd_alloc_peer_req(struct drbd_peer_device *peer_device, u64 id, sector_t secto
 	peer_req->i.waiting = false;
 
 	peer_req->epoch = NULL;
-	peer_req->w.device = device;
+	peer_req->dw.device = device;
 	peer_req->pages = page;
 	atomic_set(&peer_req->pending_bios, 0);
 	peer_req->flags = 0;
@@ -402,7 +402,7 @@ int drbd_free_peer_reqs(struct drbd_device *device, struct list_head *list)
 	list_splice_init(list, &work_list);
 	spin_unlock_irq(&device->resource->req_lock);
 
-	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
+	list_for_each_entry_safe(peer_req, t, &work_list, dw.w.list) {
 		__drbd_free_peer_req(device, peer_req, is_net);
 		count++;
 	}
@@ -424,18 +424,18 @@ static int drbd_finish_peer_reqs(struct drbd_device *device)
 	list_splice_init(&device->done_ee, &work_list);
 	spin_unlock_irq(&device->resource->req_lock);
 
-	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
+	list_for_each_entry_safe(peer_req, t, &reclaimed, dw.w.list)
 		drbd_free_net_peer_req(device, peer_req);
 
 	/* possible callbacks here:
 	 * e_end_block, and e_end_resync_block, e_send_superseded.
 	 * all ignore the last argument.
 	 */
-	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
+	list_for_each_entry_safe(peer_req, t, &work_list, dw.w.list) {
 		int err2;
 
 		/* list_del not necessary, next/prev members not touched */
-		err2 = peer_req->w.cb(&peer_req->w, !!err);
+		err2 = peer_req->dw.w.cb(&peer_req->dw.w, !!err);
 		if (!err)
 			err = err2;
 		drbd_free_peer_req(device, peer_req);
@@ -1664,9 +1664,10 @@ static int recv_dless_read(struct drbd_peer_device *peer_device, struct drbd_req
  */
 static int e_end_resync_block(struct drbd_work *w, int unused)
 {
+	struct drbd_device_work *dw = device_work(w);
 	struct drbd_peer_request *peer_req =
-		container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = w->device;
+		container_of(dw, struct drbd_peer_request, dw);
+	struct drbd_device *device = dw->device;
 	sector_t sector = peer_req->i.sector;
 	int err;
 
@@ -1702,10 +1703,10 @@ static int recv_resync_read(struct drbd_peer_device *peer_device, sector_t secto
 	/* corresponding dec_unacked() in e_end_resync_block()
 	 * respective _drbd_clear_done_ee */
 
-	peer_req->w.cb = e_end_resync_block;
+	peer_req->dw.w.cb = e_end_resync_block;
 
 	spin_lock_irq(&device->resource->req_lock);
-	list_add(&peer_req->w.list, &device->sync_ee);
+	list_add(&peer_req->dw.w.list, &device->sync_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
 	atomic_add(data_size >> 9, &device->rs_sect_ev);
@@ -1715,7 +1716,7 @@ static int recv_resync_read(struct drbd_peer_device *peer_device, sector_t secto
 	/* don't care for the reason here */
 	drbd_err(device, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&device->resource->req_lock);
-	list_del(&peer_req->w.list);
+	list_del(&peer_req->dw.w.list);
 	spin_unlock_irq(&device->resource->req_lock);
 
 	drbd_free_peer_req(device, peer_req);
@@ -1835,9 +1836,10 @@ static void restart_conflicting_writes(struct drbd_device *device,
  */
 static int e_end_block(struct drbd_work *w, int cancel)
 {
+	struct drbd_device_work *dw = device_work(w);
 	struct drbd_peer_request *peer_req =
-		container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = w->device;
+		container_of(dw, struct drbd_peer_request, dw);
+	struct drbd_device *device = dw->device;
 	sector_t sector = peer_req->i.sector;
 	int err = 0, pcmd;
 
@@ -1874,11 +1876,11 @@ static int e_end_block(struct drbd_work *w, int cancel)
 	return err;
 }
 
-static int e_send_ack(struct drbd_work *w, enum drbd_packet ack)
+static int e_send_ack(struct drbd_device_work *dw, enum drbd_packet ack)
 {
-	struct drbd_device *device = w->device;
+	struct drbd_device *device = dw->device;
 	struct drbd_peer_request *peer_req =
-		container_of(w, struct drbd_peer_request, w);
+		container_of(dw, struct drbd_peer_request, dw);
 	int err;
 
 	err = drbd_send_ack(first_peer_device(device), ack, peer_req);
@@ -1889,14 +1891,15 @@ static int e_send_ack(struct drbd_work *w, enum drbd_packet ack)
 
 static int e_send_superseded(struct drbd_work *w, int unused)
 {
-	return e_send_ack(w, P_SUPERSEDED);
+	return e_send_ack(device_work(w), P_SUPERSEDED);
 }
 
 static int e_send_retry_write(struct drbd_work *w, int unused)
 {
-	struct drbd_connection *connection = first_peer_device(w->device)->connection;
+	struct drbd_device_work *dw = device_work(w);
+	struct drbd_connection *connection = first_peer_device(dw->device)->connection;
 
-	return e_send_ack(w, connection->agreed_pro_version >= 100 ?
+	return e_send_ack(dw, connection->agreed_pro_version >= 100 ?
 			     P_RETRY_WRITE : P_SUPERSEDED);
 }
 
@@ -1943,7 +1946,7 @@ static bool overlapping_resync_write(struct drbd_device *device, struct drbd_pee
 	bool rv = 0;
 
 	spin_lock_irq(&device->resource->req_lock);
-	list_for_each_entry(rs_req, &device->sync_ee, w.list) {
+	list_for_each_entry(rs_req, &device->sync_ee, dw.w.list) {
 		if (overlaps(peer_req->i.sector, peer_req->i.size,
 			     rs_req->i.sector, rs_req->i.size)) {
 			rv = 1;
@@ -2114,9 +2117,9 @@ static int handle_write_conflicts(struct drbd_device *device,
 					  superseded ? "local" : "remote");
 
 			inc_unacked(device);
-			peer_req->w.cb = superseded ? e_send_superseded :
+			peer_req->dw.w.cb = superseded ? e_send_superseded :
 						   e_send_retry_write;
-			list_add_tail(&peer_req->w.list, &device->done_ee);
+			list_add_tail(&peer_req->dw.w.list, &device->done_ee);
 			wake_asender(first_peer_device(device)->connection);
 
 			err = -ENOENT;
@@ -2212,7 +2215,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 		return -EIO;
 	}
 
-	peer_req->w.cb = e_end_block;
+	peer_req->dw.w.cb = e_end_block;
 
 	dp_flags = be32_to_cpu(p->dp_flags);
 	rw |= wire_flags_to_bio(device, dp_flags);
@@ -2252,7 +2255,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 		update_peer_seq(peer_device, peer_seq);
 		spin_lock_irq(&device->resource->req_lock);
 	}
-	list_add(&peer_req->w.list, &device->active_ee);
+	list_add(&peer_req->dw.w.list, &device->active_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
 	if (device->state.conn == C_SYNC_TARGET)
@@ -2299,7 +2302,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	/* don't care for the reason here */
 	drbd_err(device, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&device->resource->req_lock);
-	list_del(&peer_req->w.list);
+	list_del(&peer_req->dw.w.list);
 	drbd_remove_epoch_entry_interval(device, peer_req);
 	spin_unlock_irq(&device->resource->req_lock);
 	if (peer_req->flags & EE_CALL_AL_COMPLETE_IO)
@@ -2454,13 +2457,13 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 
 	switch (pi->cmd) {
 	case P_DATA_REQUEST:
-		peer_req->w.cb = w_e_end_data_req;
+		peer_req->dw.w.cb = w_e_end_data_req;
 		fault_type = DRBD_FAULT_DT_RD;
 		/* application IO, don't drbd_rs_begin_io */
 		goto submit;
 
 	case P_RS_DATA_REQUEST:
-		peer_req->w.cb = w_e_end_rsdata_req;
+		peer_req->dw.w.cb = w_e_end_rsdata_req;
 		fault_type = DRBD_FAULT_RS_RD;
 		/* used in the sector offset progress display */
 		device->bm_resync_fo = BM_SECT_TO_BIT(sector);
@@ -2484,13 +2487,13 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 
 		if (pi->cmd == P_CSUM_RS_REQUEST) {
 			D_ASSERT(device, peer_device->connection->agreed_pro_version >= 89);
-			peer_req->w.cb = w_e_end_csum_rs_req;
+			peer_req->dw.w.cb = w_e_end_csum_rs_req;
 			/* used in the sector offset progress display */
 			device->bm_resync_fo = BM_SECT_TO_BIT(sector);
 		} else if (pi->cmd == P_OV_REPLY) {
 			/* track progress, we may need to throttle */
 			atomic_add(size >> 9, &device->rs_sect_in);
-			peer_req->w.cb = w_e_end_ov_reply;
+			peer_req->dw.w.cb = w_e_end_ov_reply;
 			dec_rs_pending(device);
 			/* drbd_rs_begin_io done when we sent this request,
 			 * but accounting still needs to be done. */
@@ -2514,7 +2517,7 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 			drbd_info(device, "Online Verify start sector: %llu\n",
 					(unsigned long long)sector);
 		}
-		peer_req->w.cb = w_e_end_ov_req;
+		peer_req->dw.w.cb = w_e_end_ov_req;
 		fault_type = DRBD_FAULT_RS_RD;
 		break;
 
@@ -2555,7 +2558,7 @@ submit_for_resync:
 submit:
 	inc_unacked(device);
 	spin_lock_irq(&device->resource->req_lock);
-	list_add_tail(&peer_req->w.list, &device->read_ee);
+	list_add_tail(&peer_req->dw.w.list, &device->read_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
 	if (drbd_submit_peer_request(device, peer_req, READ, fault_type) == 0)
@@ -2564,7 +2567,7 @@ submit:
 	/* don't care for the reason here */
 	drbd_err(device, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&device->resource->req_lock);
-	list_del(&peer_req->w.list);
+	list_del(&peer_req->dw.w.list);
 	spin_unlock_irq(&device->resource->req_lock);
 	/* no drbd_rs_complete_io(), we are dropping the connection anyways */
 
@@ -4494,7 +4497,6 @@ void conn_flush_workqueue(struct drbd_connection *connection)
 	struct drbd_wq_barrier barr;
 
 	barr.w.cb = w_complete;
-	barr.w.connection = connection;
 	init_completion(&barr.done);
 	drbd_queue_work(&connection->sender_work, &barr.w);
 	wait_for_completion(&barr.done);
@@ -5217,7 +5219,7 @@ static int got_OVResult(struct drbd_connection *connection, struct packet_info *
 	struct drbd_peer_device *peer_device;
 	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
-	struct drbd_work *w;
+	struct drbd_device_work *dw;
 	sector_t sector;
 	int size;
 
@@ -5249,13 +5251,13 @@ static int got_OVResult(struct drbd_connection *connection, struct packet_info *
 		drbd_advance_rs_marks(device, device->ov_left);
 
 	if (device->ov_left == 0) {
-		w = kmalloc(sizeof(*w), GFP_NOIO);
-		if (w) {
-			w->cb = w_ov_finished;
-			w->device = device;
-			drbd_queue_work(&peer_device->connection->sender_work, w);
+		dw = kmalloc(sizeof(*dw), GFP_NOIO);
+		if (dw) {
+			dw->w.cb = w_ov_finished;
+			dw->device = device;
+			drbd_queue_work(&peer_device->connection->sender_work, &dw->w);
 		} else {
-			drbd_err(device, "kmalloc(w) failed.");
+			drbd_err(device, "kmalloc(dw) failed.");
 			ov_out_of_sync_print(device);
 			drbd_resync_finished(device);
 		}
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index daf7861..0fb0977 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -72,7 +72,7 @@ static struct drbd_request *drbd_req_new(struct drbd_device *device,
 
 	drbd_req_make_private_bio(req, bio_src);
 	req->rq_state    = bio_data_dir(bio_src) == WRITE ? RQ_WRITE : 0;
-	req->w.device      = device;
+	req->device   = device;
 	req->master_bio  = bio_src;
 	req->epoch       = 0;
 
@@ -95,7 +95,7 @@ static struct drbd_request *drbd_req_new(struct drbd_device *device,
 void drbd_req_destroy(struct kref *kref)
 {
 	struct drbd_request *req = container_of(kref, struct drbd_request, kref);
-	struct drbd_device *device = req->w.device;
+	struct drbd_device *device = req->device;
 	const unsigned s = req->rq_state;
 
 	if ((req->master_bio && !(s & RQ_POSTPONED)) ||
@@ -191,7 +191,7 @@ void complete_master_bio(struct drbd_device *device,
 static void drbd_remove_request_interval(struct rb_root *root,
 					 struct drbd_request *req)
 {
-	struct drbd_device *device = req->w.device;
+	struct drbd_device *device = req->device;
 	struct drbd_interval *i = &req->i;
 
 	drbd_remove_interval(root, i);
@@ -211,7 +211,7 @@ static
 void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 {
 	const unsigned s = req->rq_state;
-	struct drbd_device *device = req->w.device;
+	struct drbd_device *device = req->device;
 	int rw;
 	int error, ok;
 
@@ -306,7 +306,7 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 
 static int drbd_req_put_completion_ref(struct drbd_request *req, struct bio_and_error *m, int put)
 {
-	struct drbd_device *device = req->w.device;
+	struct drbd_device *device = req->device;
 	D_ASSERT(device, m || (req->rq_state & RQ_POSTPONED));
 
 	if (!atomic_sub_and_test(put, &req->completion_ref))
@@ -329,7 +329,7 @@ static int drbd_req_put_completion_ref(struct drbd_request *req, struct bio_and_
 static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 		int clear, int set)
 {
-	struct drbd_device *device = req->w.device;
+	struct drbd_device *device = req->device;
 	unsigned s = req->rq_state;
 	int c_put = 0;
 	int k_put = 0;
@@ -454,7 +454,7 @@ static void drbd_report_io_error(struct drbd_device *device, struct drbd_request
 int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		struct bio_and_error *m)
 {
-	struct drbd_device *device = req->w.device;
+	struct drbd_device *device = req->device;
 	struct net_conf *nc;
 	int p, rv = 0;
 
@@ -542,7 +542,8 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		D_ASSERT(device, (req->rq_state & RQ_LOCAL_MASK) == 0);
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED);
 		req->w.cb = w_send_read_req;
-		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &req->w);
+		drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+				&req->w);
 		break;
 
 	case QUEUE_FOR_NET_WRITE:
@@ -577,7 +578,8 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		D_ASSERT(device, req->rq_state & RQ_NET_PENDING);
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED|RQ_EXP_BARR_ACK);
 		req->w.cb =  w_send_dblock;
-		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &req->w);
+		drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+				&req->w);
 
 		/* close the epoch, in case it outgrew the limit */
 		rcu_read_lock();
@@ -592,7 +594,8 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 	case QUEUE_FOR_SEND_OOS:
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED);
 		req->w.cb =  w_send_out_of_sync;
-		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &req->w);
+		drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+				&req->w);
 		break;
 
 	case READ_RETRY_REMOTE_CANCELED:
@@ -704,7 +707,8 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 		get_ldev(device); /* always succeeds in this call path */
 		req->w.cb = w_restart_disk_io;
-		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &req->w);
+		drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+				&req->w);
 		break;
 
 	case RESEND:
@@ -720,12 +724,13 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		   Throwing them out of the TL here by pretending we got a BARRIER_ACK.
 		   During connection handshake, we ensure that the peer was not rebooted. */
 		if (!(req->rq_state & RQ_NET_OK)) {
-			/* FIXME could this possibly be a req->w.cb == w_send_out_of_sync?
+			/* FIXME could this possibly be a req->dw.cb == w_send_out_of_sync?
 			 * in that case we must not set RQ_NET_PENDING. */
 
 			mod_rq_state(req, m, RQ_COMPLETION_SUSP, RQ_NET_QUEUED|RQ_NET_PENDING);
 			if (req->w.cb) {
-				drbd_queue_work(&first_peer_device(device)->connection->sender_work, &req->w);
+				drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+						&req->w);
 				rv = req->rq_state & RQ_WRITE ? MR_WRITE : MR_READ;
 			} /* else: FIXME can this happen? */
 			break;
@@ -835,7 +840,7 @@ static bool remote_due_to_read_balancing(struct drbd_device *device, sector_t se
 static void complete_conflicting_writes(struct drbd_request *req)
 {
 	DEFINE_WAIT(wait);
-	struct drbd_device *device = req->w.device;
+	struct drbd_device *device = req->device;
 	struct drbd_interval *i;
 	sector_t sector = req->i.sector;
 	int size = req->i.size;
@@ -915,7 +920,7 @@ static void maybe_pull_ahead(struct drbd_device *device)
  */
 static bool do_remote_read(struct drbd_request *req)
 {
-	struct drbd_device *device = req->w.device;
+	struct drbd_device *device = req->device;
 	enum drbd_read_balancing rbm;
 
 	if (req->private_bio) {
@@ -960,7 +965,7 @@ static bool do_remote_read(struct drbd_request *req)
  * which does NOT include those that we are L_AHEAD for. */
 static int drbd_process_write_request(struct drbd_request *req)
 {
-	struct drbd_device *device = req->w.device;
+	struct drbd_device *device = req->device;
 	int remote, send_oos;
 
 	remote = drbd_should_do_remote(device->state);
@@ -997,7 +1002,7 @@ static int drbd_process_write_request(struct drbd_request *req)
 static void
 drbd_submit_req_private_bio(struct drbd_request *req)
 {
-	struct drbd_device *device = req->w.device;
+	struct drbd_device *device = req->device;
 	struct bio *bio = req->private_bio;
 	const int rw = bio_rw(bio);
 
@@ -1390,7 +1395,7 @@ void request_timer_fn(unsigned long data)
 		drbd_warn(device, "Remote failed to finish a request within ko-count * timeout\n");
 		_drbd_set_state(_NS(device, conn, C_TIMEOUT), CS_VERBOSE | CS_HARD, NULL);
 	}
-	if (dt && req->rq_state & RQ_LOCAL_PENDING && req->w.device == device &&
+	if (dt && req->rq_state & RQ_LOCAL_PENDING && req->device == device &&
 		 time_after(now, req->start_time + dt) &&
 		!time_in_range(now, device->last_reattach_jif, device->last_reattach_jif + dt)) {
 		drbd_warn(device, "Local backing device failed to meet the disk-timeout\n");
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 5ce6dc5..c684c96 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -294,7 +294,7 @@ extern void drbd_restart_request(struct drbd_request *req);
  * outside the spinlock, e.g. when walking some list on cleanup. */
 static inline int _req_mod(struct drbd_request *req, enum drbd_req_event what)
 {
-	struct drbd_device *device = req->w.device;
+	struct drbd_device *device = req->device;
 	struct bio_and_error m;
 	int rv;
 
@@ -314,7 +314,7 @@ static inline int req_mod(struct drbd_request *req,
 		enum drbd_req_event what)
 {
 	unsigned long flags;
-	struct drbd_device *device = req->w.device;
+	struct drbd_device *device = req->device;
 	struct bio_and_error m;
 	int rv;
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 3f5c5a5..c9a0dba 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -35,6 +35,7 @@ extern void tl_abort_disk_io(struct drbd_device *device);
 
 struct after_state_chg_work {
 	struct drbd_work w;
+	struct drbd_device *device;
 	union drbd_state os;
 	union drbd_state ns;
 	enum chg_state_flags flags;
@@ -1148,9 +1149,10 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 		ascw->ns = ns;
 		ascw->flags = flags;
 		ascw->w.cb = w_after_state_ch;
-		ascw->w.device = device;
+		ascw->device = device;
 		ascw->done = done;
-		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &ascw->w);
+		drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+				&ascw->w);
 	} else {
 		drbd_err(device, "Could not kmalloc an ascw\n");
 	}
@@ -1162,7 +1164,7 @@ static int w_after_state_ch(struct drbd_work *w, int unused)
 {
 	struct after_state_chg_work *ascw =
 		container_of(w, struct after_state_chg_work, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device *device = ascw->device;
 
 	after_state_ch(device, ascw->os, ascw->ns, ascw->flags);
 	if (ascw->flags & CS_WAIT_COMPLETE)
@@ -1531,18 +1533,19 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 }
 
 struct after_conn_state_chg_work {
-	struct drbd_work w;
+	struct drbd_device_work dw;
 	enum drbd_conns oc;
 	union drbd_state ns_min;
 	union drbd_state ns_max; /* new, max state, over all devices */
 	enum chg_state_flags flags;
+	struct drbd_connection *connection;
 };
 
 static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 {
 	struct after_conn_state_chg_work *acscw =
-		container_of(w, struct after_conn_state_chg_work, w);
-	struct drbd_connection *connection = w->connection;
+		container_of(w, struct after_conn_state_chg_work, dw.w);
+	struct drbd_connection *connection = acscw->connection;
 	enum drbd_conns oc = acscw->oc;
 	union drbd_state ns_max = acscw->ns_max;
 	struct drbd_peer_device *peer_device;
@@ -1843,10 +1846,10 @@ _conn_request_state(struct drbd_connection *connection, union drbd_state mask, u
 		acscw->ns_min = ns_min;
 		acscw->ns_max = ns_max;
 		acscw->flags = flags;
-		acscw->w.cb = w_after_conn_state_ch;
+		acscw->dw.w.cb = w_after_conn_state_ch;
 		kref_get(&connection->kref);
-		acscw->w.connection = connection;
-		drbd_queue_work(&connection->sender_work, &acscw->w);
+		acscw->connection = connection;
+		drbd_queue_work(&connection->sender_work, &acscw->dw.w);
 	} else {
 		drbd_err(connection, "Could not kmalloc an acscw\n");
 	}
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 7d68227..514d189 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -21,7 +21,7 @@
    along with drbd; see the file COPYING.  If not, write to
    the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
 
- */
+*/
 
 #include <linux/module.h>
 #include <linux/drbd.h>
@@ -39,7 +39,7 @@
 #include "drbd_protocol.h"
 #include "drbd_req.h"
 
-static int w_make_ov_request(struct drbd_work *w, int cancel);
+static int w_make_ov_request(struct drbd_work *, int);
 
 
 /* endio handlers:
@@ -100,18 +100,19 @@ void drbd_md_io_complete(struct bio *bio, int error)
 void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_device *device = peer_req->w.device;
+	struct drbd_device *device = peer_req->dw.device;
 
 	spin_lock_irqsave(&device->resource->req_lock, flags);
 	device->read_cnt += peer_req->i.size >> 9;
-	list_del(&peer_req->w.list);
+	list_del(&peer_req->dw.w.list);
 	if (list_empty(&device->read_ee))
 		wake_up(&device->ee_wait);
 	if (test_bit(__EE_WAS_ERROR, &peer_req->flags))
 		__drbd_chk_io_error(device, DRBD_READ_ERROR);
 	spin_unlock_irqrestore(&device->resource->req_lock, flags);
 
-	drbd_queue_work(&first_peer_device(device)->connection->sender_work, &peer_req->w);
+	drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+			&peer_req->dw.w);
 	put_ldev(device);
 }
 
@@ -120,7 +121,7 @@ void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(lo
 static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_device *device = peer_req->w.device;
+	struct drbd_device *device = peer_req->dw.device;
 	struct drbd_interval i;
 	int do_wake;
 	u64 block_id;
@@ -136,13 +137,13 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 
 	spin_lock_irqsave(&device->resource->req_lock, flags);
 	device->writ_cnt += peer_req->i.size >> 9;
-	list_move_tail(&peer_req->w.list, &device->done_ee);
+	list_move_tail(&peer_req->dw.w.list, &device->done_ee);
 
 	/*
 	 * Do not remove from the write_requests tree here: we did not send the
 	 * Ack yet and did not wake possibly waiting conflicting requests.
 	 * Removed from the tree from "drbd_process_done_ee" within the
-	 * appropriate w.cb (e_end_block/e_end_resync_block) or from
+	 * appropriate dw.cb (e_end_block/e_end_resync_block) or from
 	 * _drbd_clear_done_ee.
 	 */
 
@@ -171,7 +172,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 void drbd_peer_request_endio(struct bio *bio, int error)
 {
 	struct drbd_peer_request *peer_req = bio->bi_private;
-	struct drbd_device *device = peer_req->w.device;
+	struct drbd_device *device = peer_req->dw.device;
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
 	int is_write = bio_data_dir(bio) == WRITE;
 
@@ -208,7 +209,7 @@ void drbd_request_endio(struct bio *bio, int error)
 {
 	unsigned long flags;
 	struct drbd_request *req = bio->bi_private;
-	struct drbd_device *device = req->w.device;
+	struct drbd_device *device = req->device;
 	struct bio_and_error m;
 	enum drbd_req_event what;
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
@@ -332,8 +333,9 @@ void drbd_csum_bio(struct crypto_hash *tfm, struct bio *bio, void *digest)
 /* MAYBE merge common code with w_e_end_ov_req */
 static int w_e_send_csum(struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device_work *dw = device_work(w);
+	struct drbd_peer_request *peer_req = container_of(dw, struct drbd_peer_request, dw);
+	struct drbd_device *device = dw->device;
 	int digest_size;
 	void *digest;
 	int err = 0;
@@ -396,9 +398,9 @@ static int read_for_csum(struct drbd_peer_device *peer_device, sector_t sector,
 	if (!peer_req)
 		goto defer;
 
-	peer_req->w.cb = w_e_send_csum;
+	peer_req->dw.w.cb = w_e_send_csum;
 	spin_lock_irq(&device->resource->req_lock);
-	list_add(&peer_req->w.list, &device->read_ee);
+	list_add(&peer_req->dw.w.list, &device->read_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
 	atomic_add(size >> 9, &device->rs_sect_ev);
@@ -410,7 +412,7 @@ static int read_for_csum(struct drbd_peer_device *peer_device, sector_t sector,
 	 * retry may or may not help.
 	 * If it does not, you may need to force disconnect. */
 	spin_lock_irq(&device->resource->req_lock);
-	list_del(&peer_req->w.list);
+	list_del(&peer_req->dw.w.list);
 	spin_unlock_irq(&device->resource->req_lock);
 
 	drbd_free_peer_req(device, peer_req);
@@ -421,7 +423,9 @@ defer:
 
 int w_resync_timer(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *device = w->device;
+	struct drbd_device *device =
+		container_of(w, struct drbd_device, resync_work);
+
 	switch (device->state.conn) {
 	case C_VERIFY_S:
 		w_make_ov_request(w, cancel);
@@ -439,7 +443,8 @@ void resync_timer_fn(unsigned long data)
 	struct drbd_device *device = (struct drbd_device *) data;
 
 	if (list_empty(&device->resync_work.list))
-		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &device->resync_work);
+		drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+				&device->resync_work);
 }
 
 static void fifo_set(struct fifo_buffer *fb, int value)
@@ -563,7 +568,8 @@ static int drbd_rs_number_requests(struct drbd_device *device)
 
 int w_make_resync_request(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *device = w->device;
+	struct drbd_device_work *dw = device_work(w);
+	struct drbd_device *device = dw->device;
 	unsigned long bit;
 	sector_t sector;
 	const sector_t capacity = drbd_get_capacity(device->this_bdev);
@@ -727,7 +733,7 @@ next_sector:
 
 static int w_make_ov_request(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *device = w->device;
+	struct drbd_device *device = device_work(w)->device;
 	int number, i, size;
 	sector_t sector;
 	const sector_t capacity = drbd_get_capacity(device->this_bdev);
@@ -781,8 +787,10 @@ static int w_make_ov_request(struct drbd_work *w, int cancel)
 
 int w_ov_finished(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *device = w->device;
-	kfree(w);
+	struct drbd_device_work *dw =
+		container_of(w, struct drbd_device_work, w);
+	struct drbd_device *device = dw->device;
+	kfree(dw);
 	ov_out_of_sync_print(device);
 	drbd_resync_finished(device);
 
@@ -791,8 +799,10 @@ int w_ov_finished(struct drbd_work *w, int cancel)
 
 static int w_resync_finished(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *device = w->device;
-	kfree(w);
+	struct drbd_device_work *dw =
+		container_of(w, struct drbd_device_work, w);
+	struct drbd_device *device = dw->device;
+	kfree(dw);
 
 	drbd_resync_finished(device);
 
@@ -814,7 +824,7 @@ int drbd_resync_finished(struct drbd_device *device)
 	unsigned long db, dt, dbdt;
 	unsigned long n_oos;
 	union drbd_state os, ns;
-	struct drbd_work *w;
+	struct drbd_device_work *dw;
 	char *khelper_cmd = NULL;
 	int verify_done = 0;
 
@@ -828,20 +838,21 @@ int drbd_resync_finished(struct drbd_device *device)
 		 * is not finished by now).   Retry in 100ms. */
 
 		schedule_timeout_interruptible(HZ / 10);
-		w = kmalloc(sizeof(struct drbd_work), GFP_ATOMIC);
-		if (w) {
-			w->cb = w_resync_finished;
-			w->device = device;
-			drbd_queue_work(&first_peer_device(device)->connection->sender_work, w);
+		dw = kmalloc(sizeof(struct drbd_device_work), GFP_ATOMIC);
+		if (dw) {
+			dw->w.cb = w_resync_finished;
+			dw->device = device;
+			drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+					&dw->w);
 			return 1;
 		}
-		drbd_err(device, "Warn failed to drbd_rs_del_all() and to kmalloc(w).\n");
+		drbd_err(device, "Warn failed to drbd_rs_del_all() and to kmalloc(dw).\n");
 	}
 
 	dt = (jiffies - device->rs_start - device->rs_paused) / HZ;
 	if (dt <= 0)
 		dt = 1;
-	
+
 	db = device->rs_total;
 	/* adjust for verify start and stop sectors, respective reached position */
 	if (device->state.conn == C_VERIFY_S || device->state.conn == C_VERIFY_T)
@@ -972,7 +983,7 @@ static void move_to_net_ee_or_free(struct drbd_device *device, struct drbd_peer_
 		atomic_add(i, &device->pp_in_use_by_net);
 		atomic_sub(i, &device->pp_in_use);
 		spin_lock_irq(&device->resource->req_lock);
-		list_add_tail(&peer_req->w.list, &device->net_ee);
+		list_add_tail(&peer_req->dw.w.list, &device->net_ee);
 		spin_unlock_irq(&device->resource->req_lock);
 		wake_up(&drbd_pp_wait);
 	} else
@@ -987,8 +998,9 @@ static void move_to_net_ee_or_free(struct drbd_device *device, struct drbd_peer_
  */
 int w_e_end_data_req(struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device_work *dw = device_work(w);
+	struct drbd_peer_request *peer_req = container_of(dw, struct drbd_peer_request, dw);
+	struct drbd_device *device = dw->device;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1018,14 +1030,14 @@ int w_e_end_data_req(struct drbd_work *w, int cancel)
 
 /**
  * w_e_end_rsdata_req() - Worker callback to send a P_RS_DATA_REPLY packet in response to a P_RS_DATA_REQUEST
- * @device:	DRBD device.
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
 int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device_work *dw = device_work(w);
+	struct drbd_peer_request *peer_req = container_of(dw, struct drbd_peer_request, dw);
+	struct drbd_device *device = dw->device;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1073,8 +1085,9 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 
 int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device_work *dw = device_work(w);
+	struct drbd_peer_request *peer_req = container_of(dw, struct drbd_peer_request, dw);
+	struct drbd_device *device = dw->device;
 	struct digest_info *di;
 	int digest_size;
 	void *digest = NULL;
@@ -1136,8 +1149,9 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 
 int w_e_end_ov_req(struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device_work *dw = device_work(w);
+	struct drbd_peer_request *peer_req = container_of(dw, struct drbd_peer_request, dw);
+	struct drbd_device *device = dw->device;
 	sector_t sector = peer_req->i.sector;
 	unsigned int size = peer_req->i.size;
 	int digest_size;
@@ -1192,8 +1206,9 @@ void drbd_ov_out_of_sync_found(struct drbd_device *device, sector_t sector, int
 
 int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 {
-	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device_work *dw = device_work(w);
+	struct drbd_peer_request *peer_req = container_of(dw, struct drbd_peer_request, dw);
+	struct drbd_device *device = dw->device;
 	struct digest_info *di;
 	void *digest;
 	sector_t sector = peer_req->i.sector;
@@ -1285,7 +1300,8 @@ int drbd_send_barrier(struct drbd_connection *connection)
 
 int w_send_write_hint(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *device = w->device;
+	struct drbd_device *device =
+		container_of(w, struct drbd_device, unplug_work);
 	struct drbd_socket *sock;
 
 	if (cancel)
@@ -1320,7 +1336,7 @@ static void maybe_send_barrier(struct drbd_connection *connection, unsigned int
 int w_send_out_of_sync(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device *device = req->device;
 	struct drbd_connection *connection = first_peer_device(device)->connection;
 	int err;
 
@@ -1343,14 +1359,13 @@ int w_send_out_of_sync(struct drbd_work *w, int cancel)
 
 /**
  * w_send_dblock() - Worker callback to send a P_DATA packet in order to mirror a write request
- * @device:	DRBD device.
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
 int w_send_dblock(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device *device = req->device;
 	struct drbd_connection *connection = first_peer_device(device)->connection;
 	int err;
 
@@ -1371,14 +1386,13 @@ int w_send_dblock(struct drbd_work *w, int cancel)
 
 /**
  * w_send_read_req() - Worker callback to send a read request (P_DATA_REQUEST) packet
- * @device:	DRBD device.
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
 int w_send_read_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device *device = req->device;
 	struct drbd_connection *connection = first_peer_device(device)->connection;
 	int err;
 
@@ -1402,7 +1416,7 @@ int w_send_read_req(struct drbd_work *w, int cancel)
 int w_restart_disk_io(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
-	struct drbd_device *device = w->device;
+	struct drbd_device *device = req->device;
 
 	if (bio_data_dir(req->master_bio) == WRITE && req->rq_state & RQ_IN_ACT_LOG)
 		drbd_al_begin_io(device, &req->i, false);
@@ -1574,12 +1588,14 @@ void start_resync_timer_fn(unsigned long data)
 {
 	struct drbd_device *device = (struct drbd_device *) data;
 
-	drbd_queue_work(&first_peer_device(device)->connection->sender_work, &device->start_resync_work);
+	drbd_queue_work(&first_peer_device(device)->connection->sender_work,
+			&device->start_resync_work);
 }
 
 int w_start_resync(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *device = w->device;
+	struct drbd_device *device =
+		container_of(w, struct drbd_device, start_resync_work);
 
 	if (atomic_read(&device->unacked_cnt) || atomic_read(&device->rs_pending_cnt)) {
 		drbd_warn(device, "w_start_resync later...\n");
@@ -1881,7 +1897,7 @@ void wait_for_work(struct drbd_connection *connection, struct list_head *work_li
 int drbd_worker(struct drbd_thread *thi)
 {
 	struct drbd_connection *connection = thi->connection;
-	struct drbd_work *w = NULL;
+	struct drbd_device_work *dw = NULL;
 	struct drbd_peer_device *peer_device;
 	LIST_HEAD(work_list);
 	int vnr;
@@ -1907,9 +1923,9 @@ int drbd_worker(struct drbd_thread *thi)
 			break;
 
 		while (!list_empty(&work_list)) {
-			w = list_first_entry(&work_list, struct drbd_work, list);
-			list_del_init(&w->list);
-			if (w->cb(w, connection->cstate < C_WF_REPORT_PARAMS) == 0)
+			dw = list_first_entry(&work_list, struct drbd_device_work, w.list);
+			list_del_init(&dw->w.list);
+			if (dw->w.cb(&dw->w, connection->cstate < C_WF_REPORT_PARAMS) == 0)
 				continue;
 			if (connection->cstate >= C_WF_REPORT_PARAMS)
 				conn_request_state(connection, NS(conn, C_NETWORK_FAILURE), CS_HARD);
@@ -1918,9 +1934,9 @@ int drbd_worker(struct drbd_thread *thi)
 
 	do {
 		while (!list_empty(&work_list)) {
-			w = list_first_entry(&work_list, struct drbd_work, list);
-			list_del_init(&w->list);
-			w->cb(w, 1);
+			dw = list_first_entry(&work_list, struct drbd_device_work, w.list);
+			list_del_init(&dw->w.list);
+			dw->w.cb(&dw->w, 1);
 		}
 		dequeue_work_batch(&connection->sender_work, &work_list);
 	} while (!list_empty(&work_list));
-- 
1.7.9.5



