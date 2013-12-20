Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab3LTMn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:43:26 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38633 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357Ab3LTMj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:27 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 22/26] drbd: Add explicit device parameter to D_ASSERT
Date: Fri, 20 Dec 2013 13:29:19 +0100
Message-Id: <1387542563-6833-23-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

The implicit dependency on a variable inside the macro is problematic.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |   38 ++++++++++++-------------
 drivers/block/drbd/drbd_bitmap.c   |    2 +-
 drivers/block/drbd/drbd_int.h      |   10 ++++---
 drivers/block/drbd/drbd_main.c     |   46 +++++++++++++++---------------
 drivers/block/drbd/drbd_nl.c       |    8 +++---
 drivers/block/drbd/drbd_receiver.c |   54 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_req.c      |   44 ++++++++++++++---------------
 drivers/block/drbd/drbd_state.c    |    6 ++--
 drivers/block/drbd/drbd_worker.c   |    8 +++---
 9 files changed, 109 insertions(+), 107 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index c54cdea..cacd47a 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -198,7 +198,7 @@ int drbd_md_sync_page_io(struct drbd_device *device, struct drbd_backing_dev *bd
 	int err;
 	struct page *iop = device->md_io_page;
 
-	D_ASSERT(atomic_read(&device->md_io_in_use) == 1);
+	D_ASSERT(device, atomic_read(&device->md_io_in_use) == 1);
 
 	BUG_ON(!bdev->md_bdev);
 
@@ -264,8 +264,8 @@ bool drbd_al_begin_io_fastpath(struct drbd_device *device, struct drbd_interval
 	unsigned first = i->sector >> (AL_EXTENT_SHIFT-9);
 	unsigned last = i->size == 0 ? first : (i->sector + (i->size >> 9) - 1) >> (AL_EXTENT_SHIFT-9);
 
-	D_ASSERT((unsigned)(last - first) <= 1);
-	D_ASSERT(atomic_read(&device->local_cnt) > 0);
+	D_ASSERT(device, (unsigned)(last - first) <= 1);
+	D_ASSERT(device, atomic_read(&device->local_cnt) > 0);
 
 	/* FIXME figure out a fast path for bios crossing AL extent boundaries */
 	if (first != last)
@@ -283,8 +283,8 @@ bool drbd_al_begin_io_prepare(struct drbd_device *device, struct drbd_interval *
 	unsigned enr;
 	bool need_transaction = false;
 
-	D_ASSERT(first <= last);
-	D_ASSERT(atomic_read(&device->local_cnt) > 0);
+	D_ASSERT(device, first <= last);
+	D_ASSERT(device, atomic_read(&device->local_cnt) > 0);
 
 	for (enr = first; enr <= last; enr++) {
 		struct lc_element *al_ext;
@@ -370,7 +370,7 @@ int drbd_al_begin_io_nonblock(struct drbd_device *device, struct drbd_interval *
 	unsigned available_update_slots;
 	unsigned enr;
 
-	D_ASSERT(first <= last);
+	D_ASSERT(device, first <= last);
 
 	nr_al_extents = 1 + last - first; /* worst case: all touched extends are cold. */
 	available_update_slots = min(al->nr_elements - al->used,
@@ -418,7 +418,7 @@ void drbd_al_complete_io(struct drbd_device *device, struct drbd_interval *i)
 	struct lc_element *extent;
 	unsigned long flags;
 
-	D_ASSERT(first <= last);
+	D_ASSERT(device, first <= last);
 	spin_lock_irqsave(&device->al_lock, flags);
 
 	for (enr = first; enr <= last; enr++) {
@@ -647,7 +647,7 @@ void drbd_al_shrink(struct drbd_device *device)
 	struct lc_element *al_ext;
 	int i;
 
-	D_ASSERT(test_bit(__LC_LOCKED, &device->act_log->flags));
+	D_ASSERT(device, test_bit(__LC_LOCKED, &device->act_log->flags));
 
 	for (i = 0; i < device->act_log->nr_elements; i++) {
 		al_ext = lc_element_by_index(device->act_log, i);
@@ -728,7 +728,7 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *device, sector_t secto
 
 	unsigned int enr;
 
-	D_ASSERT(atomic_read(&device->local_cnt));
+	D_ASSERT(device, atomic_read(&device->local_cnt));
 
 	/* I simply assume that a sector/size pair never crosses
 	 * a 16 MB extent border. (Currently this is true...) */
@@ -1092,8 +1092,8 @@ int drbd_try_rs_begin_io(struct drbd_device *device, sector_t sector)
 		e = lc_find(device->resync, device->resync_wenr);
 		bm_ext = e ? lc_entry(e, struct bm_extent, lce) : NULL;
 		if (bm_ext) {
-			D_ASSERT(!test_bit(BME_LOCKED, &bm_ext->flags));
-			D_ASSERT(test_bit(BME_NO_WRITES, &bm_ext->flags));
+			D_ASSERT(device, !test_bit(BME_LOCKED, &bm_ext->flags));
+			D_ASSERT(device, test_bit(BME_NO_WRITES, &bm_ext->flags));
 			clear_bit(BME_NO_WRITES, &bm_ext->flags);
 			device->resync_wenr = LC_FREE;
 			if (lc_put(device->resync, &bm_ext->lce) == 0)
@@ -1117,7 +1117,7 @@ int drbd_try_rs_begin_io(struct drbd_device *device, sector_t sector)
 			 * so we tried again.
 			 * drop the extra reference. */
 			bm_ext->lce.refcnt--;
-			D_ASSERT(bm_ext->lce.refcnt > 0);
+			D_ASSERT(device, bm_ext->lce.refcnt > 0);
 		}
 		goto check_al;
 	} else {
@@ -1140,10 +1140,10 @@ int drbd_try_rs_begin_io(struct drbd_device *device, sector_t sector)
 			bm_ext->rs_failed = 0;
 			lc_committed(device->resync);
 			wake_up(&device->al_wait);
-			D_ASSERT(test_bit(BME_LOCKED, &bm_ext->flags) == 0);
+			D_ASSERT(device, test_bit(BME_LOCKED, &bm_ext->flags) == 0);
 		}
 		set_bit(BME_NO_WRITES, &bm_ext->flags);
-		D_ASSERT(bm_ext->lce.refcnt == 1);
+		D_ASSERT(device, bm_ext->lce.refcnt == 1);
 		device->resync_locked++;
 		goto check_al;
 	}
@@ -1243,8 +1243,8 @@ int drbd_rs_del_all(struct drbd_device *device)
 				drbd_info(device, "dropping %u in drbd_rs_del_all, apparently"
 				     " got 'synced' by application io\n",
 				     device->resync_wenr);
-				D_ASSERT(!test_bit(BME_LOCKED, &bm_ext->flags));
-				D_ASSERT(test_bit(BME_NO_WRITES, &bm_ext->flags));
+				D_ASSERT(device, !test_bit(BME_LOCKED, &bm_ext->flags));
+				D_ASSERT(device, test_bit(BME_NO_WRITES, &bm_ext->flags));
 				clear_bit(BME_NO_WRITES, &bm_ext->flags);
 				device->resync_wenr = LC_FREE;
 				lc_put(device->resync, &bm_ext->lce);
@@ -1256,11 +1256,11 @@ int drbd_rs_del_all(struct drbd_device *device)
 				spin_unlock_irq(&device->al_lock);
 				return -EAGAIN;
 			}
-			D_ASSERT(!test_bit(BME_LOCKED, &bm_ext->flags));
-			D_ASSERT(!test_bit(BME_NO_WRITES, &bm_ext->flags));
+			D_ASSERT(device, !test_bit(BME_LOCKED, &bm_ext->flags));
+			D_ASSERT(device, !test_bit(BME_NO_WRITES, &bm_ext->flags));
 			lc_del(device->resync, &bm_ext->lce);
 		}
-		D_ASSERT(device->resync->used == 0);
+		D_ASSERT(device, device->resync->used == 0);
 		put_ldev(device);
 	}
 	spin_unlock_irq(&device->al_lock);
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 81626b9..b2dc168 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -692,7 +692,7 @@ int drbd_bm_resize(struct drbd_device *device, sector_t capacity, int set_new_bi
 	want = ALIGN(words*sizeof(long), PAGE_SIZE) >> PAGE_SHIFT;
 	have = b->bm_number_of_pages;
 	if (want == have) {
-		D_ASSERT(b->bm_pages != NULL);
+		D_ASSERT(device, b->bm_pages != NULL);
 		npages = b->bm_pages;
 	} else {
 		if (drbd_insert_fault(device, DRBD_FAULT_BM_ALLOC))
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 614f44d..3d1fb33 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -146,8 +146,10 @@ void drbd_printk_with_wrong_object_type(void);
 #define dynamic_drbd_dbg(device, fmt, args...) \
 	dynamic_dev_dbg(disk_to_dev(device->vdisk), fmt, ## args)
 
-#define D_ASSERT(exp)	if (!(exp)) \
-	 drbd_err(device, "ASSERT( " #exp " ) in %s:%d\n", __FILE__, __LINE__)
+#define D_ASSERT(device, exp)	do { \
+	if (!(exp)) \
+		drbd_err(device, "ASSERT( " #exp " ) in %s:%d\n", __FILE__, __LINE__); \
+	} while (0)
 
 /**
  * expect  -  Make an assertion
@@ -1858,7 +1860,7 @@ static inline void put_ldev(struct drbd_device *device)
 	 * so we must not sleep here. */
 
 	__release(local);
-	D_ASSERT(i >= 0);
+	D_ASSERT(device, i >= 0);
 	if (i == 0) {
 		if (device->state.disk == D_DISKLESS)
 			/* even internal references gone, safe to destroy */
@@ -2089,7 +2091,7 @@ static inline void dec_ap_bio(struct drbd_device *device)
 	int mxb = drbd_get_max_buffers(device);
 	int ap_bio = atomic_dec_return(&device->ap_bio_cnt);
 
-	D_ASSERT(ap_bio >= 0);
+	D_ASSERT(device, ap_bio >= 0);
 
 	if (ap_bio == 0 && test_bit(BITMAP_IO, &device->flags)) {
 		if (!test_and_set_bit(BITMAP_IO_QUEUED, &device->flags))
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 073f035..72ead5b 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -893,7 +893,7 @@ void drbd_gen_and_send_sync_uuid(struct drbd_device *device)
 	struct p_rs_uuid *p;
 	u64 uuid;
 
-	D_ASSERT(device->state.disk == D_UP_TO_DATE);
+	D_ASSERT(device, device->state.disk == D_UP_TO_DATE);
 
 	uuid = device->ldev->md.uuid[UI_BITMAP];
 	if (uuid && uuid != UUID_JUST_CREATED)
@@ -921,7 +921,7 @@ int drbd_send_sizes(struct drbd_device *device, int trigger_reply, enum dds_flag
 	unsigned int max_bio_size;
 
 	if (get_ldev_if_state(device, D_NEGOTIATING)) {
-		D_ASSERT(device->ldev->backing_bdev);
+		D_ASSERT(device, device->ldev->backing_bdev);
 		d_size = drbd_get_max_capacity(device->ldev);
 		rcu_read_lock();
 		u_size = rcu_dereference(device->ldev->disk_conf)->disk_size;
@@ -1976,7 +1976,7 @@ void drbd_device_cleanup(struct drbd_device *device)
 		device->rs_mark_left[i] = 0;
 		device->rs_mark_time[i] = 0;
 	}
-	D_ASSERT(first_peer_device(device)->connection->net_conf == NULL);
+	D_ASSERT(device, first_peer_device(device)->connection->net_conf == NULL);
 
 	drbd_set_my_capacity(device, 0);
 	if (device->bitmap) {
@@ -1990,16 +1990,16 @@ void drbd_device_cleanup(struct drbd_device *device)
 
 	clear_bit(AL_SUSPENDED, &device->flags);
 
-	D_ASSERT(list_empty(&device->active_ee));
-	D_ASSERT(list_empty(&device->sync_ee));
-	D_ASSERT(list_empty(&device->done_ee));
-	D_ASSERT(list_empty(&device->read_ee));
-	D_ASSERT(list_empty(&device->net_ee));
-	D_ASSERT(list_empty(&device->resync_reads));
-	D_ASSERT(list_empty(&first_peer_device(device)->connection->sender_work.q));
-	D_ASSERT(list_empty(&device->resync_work.list));
-	D_ASSERT(list_empty(&device->unplug_work.list));
-	D_ASSERT(list_empty(&device->go_diskless.list));
+	D_ASSERT(device, list_empty(&device->active_ee));
+	D_ASSERT(device, list_empty(&device->sync_ee));
+	D_ASSERT(device, list_empty(&device->done_ee));
+	D_ASSERT(device, list_empty(&device->read_ee));
+	D_ASSERT(device, list_empty(&device->net_ee));
+	D_ASSERT(device, list_empty(&device->resync_reads));
+	D_ASSERT(device, list_empty(&first_peer_device(device)->connection->sender_work.q));
+	D_ASSERT(device, list_empty(&device->resync_work.list));
+	D_ASSERT(device, list_empty(&device->unplug_work.list));
+	D_ASSERT(device, list_empty(&device->go_diskless.list));
 
 	drbd_set_defaults(device);
 }
@@ -2016,7 +2016,7 @@ static void drbd_destroy_mempools(void)
 		drbd_pp_vacant--;
 	}
 
-	/* D_ASSERT(atomic_read(&drbd_pp_vacant)==0); */
+	/* D_ASSERT(device, atomic_read(&drbd_pp_vacant)==0); */
 
 	if (drbd_md_io_bio_set)
 		bioset_free(drbd_md_io_bio_set);
@@ -2171,7 +2171,7 @@ void drbd_destroy_device(struct kref *kref)
 	del_timer_sync(&device->request_timer);
 
 	/* paranoia asserts */
-	D_ASSERT(device->open_cnt == 0);
+	D_ASSERT(device, device->open_cnt == 0);
 	/* end paranoia asserts */
 
 	/* cleanup stuff that may have been allocated during
@@ -3008,7 +3008,7 @@ void drbd_md_write(struct drbd_device *device, void *b)
 	buffer->al_stripes = cpu_to_be32(device->ldev->md.al_stripes);
 	buffer->al_stripe_size_4k = cpu_to_be32(device->ldev->md.al_stripe_size_4k);
 
-	D_ASSERT(drbd_md_ss(device->ldev) == device->ldev->md.md_offset);
+	D_ASSERT(device, drbd_md_ss(device->ldev) == device->ldev->md.md_offset);
 	sector = device->ldev->md.md_offset;
 
 	if (drbd_md_sync_page_io(device, device->ldev, sector, WRITE)) {
@@ -3461,7 +3461,7 @@ static int w_bitmap_io(struct drbd_work *w, int unused)
 	struct drbd_device *device = w->device;
 	int rv = -EIO;
 
-	D_ASSERT(atomic_read(&device->ap_bio_cnt) == 0);
+	D_ASSERT(device, atomic_read(&device->ap_bio_cnt) == 0);
 
 	if (get_ldev(device)) {
 		drbd_bm_lock(device, work->why, work->flags);
@@ -3500,7 +3500,7 @@ static int w_go_diskless(struct drbd_work *w, int unused)
 {
 	struct drbd_device *device = w->device;
 
-	D_ASSERT(device->state.disk == D_FAILED);
+	D_ASSERT(device, device->state.disk == D_FAILED);
 	/* we cannot assert local_cnt == 0 here, as get_ldev_if_state will
 	 * inc/dec it frequently. Once we are D_DISKLESS, no one will touch
 	 * the protected members anymore, though, so once put_ldev reaches zero
@@ -3554,11 +3554,11 @@ void drbd_queue_bitmap_io(struct drbd_device *device,
 			  void (*done)(struct drbd_device *, int),
 			  char *why, enum bm_flag flags)
 {
-	D_ASSERT(current == first_peer_device(device)->connection->worker.task);
+	D_ASSERT(device, current == first_peer_device(device)->connection->worker.task);
 
-	D_ASSERT(!test_bit(BITMAP_IO_QUEUED, &device->flags));
-	D_ASSERT(!test_bit(BITMAP_IO, &device->flags));
-	D_ASSERT(list_empty(&device->bm_io_work.w.list));
+	D_ASSERT(device, !test_bit(BITMAP_IO_QUEUED, &device->flags));
+	D_ASSERT(device, !test_bit(BITMAP_IO, &device->flags));
+	D_ASSERT(device, list_empty(&device->bm_io_work.w.list));
 	if (device->bm_io_work.why)
 		drbd_err(device, "FIXME going to queue '%s' but '%s' still pending?\n",
 			why, device->bm_io_work.why);
@@ -3591,7 +3591,7 @@ int drbd_bitmap_io(struct drbd_device *device, int (*io_fn)(struct drbd_device *
 {
 	int rv;
 
-	D_ASSERT(current != first_peer_device(device)->connection->worker.task);
+	D_ASSERT(device, current != first_peer_device(device)->connection->worker.task);
 
 	if ((flags & BM_LOCKED_SET_ALLOWED) == 0)
 		drbd_suspend_io(device);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index b53c526..c8604e7 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -590,7 +590,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 
 		if (rv == SS_NO_UP_TO_DATE_DISK &&
 		    device->state.disk == D_CONSISTENT && mask.pdsk == 0) {
-			D_ASSERT(device->state.pdsk == D_UNKNOWN);
+			D_ASSERT(device, device->state.pdsk == D_UNKNOWN);
 
 			if (conn_try_outdate_peer(first_peer_device(device)->connection)) {
 				val.disk = D_UP_TO_DATE;
@@ -1644,7 +1644,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	 * Devices and memory are no longer released by error cleanup below.
 	 * now device takes over responsibility, and the state engine should
 	 * clean it up somewhere.  */
-	D_ASSERT(device->ldev == NULL);
+	D_ASSERT(device, device->ldev == NULL);
 	device->ldev = nbc;
 	device->resync = resync_lru;
 	device->rs_plan_s = new_plan;
@@ -3011,8 +3011,8 @@ next_resource:
 		}
 
 		device = peer_device->device;
-		D_ASSERT(device->vnr == volume);
-		D_ASSERT(first_peer_device(device)->connection == connection);
+		D_ASSERT(device, device->vnr == volume);
+		D_ASSERT(device, first_peer_device(device)->connection == connection);
 
 		dh->minor = device_to_minor(device);
 		dh->ret_code = NO_ERROR;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6ed2583..90aa3aa 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -384,8 +384,8 @@ void __drbd_free_peer_req(struct drbd_device *device, struct drbd_peer_request *
 	if (peer_req->flags & EE_HAS_DIGEST)
 		kfree(peer_req->digest);
 	drbd_free_pages(device, peer_req->pages, is_net);
-	D_ASSERT(atomic_read(&peer_req->pending_bios) == 0);
-	D_ASSERT(drbd_interval_empty(&peer_req->i));
+	D_ASSERT(device, atomic_read(&peer_req->pending_bios) == 0);
+	D_ASSERT(device, drbd_interval_empty(&peer_req->i));
 	mempool_free(peer_req, drbd_ee_mempool);
 }
 
@@ -1369,8 +1369,8 @@ next_bio:
 		sector += len >> 9;
 		--nr_pages;
 	}
-	D_ASSERT(page == NULL);
-	D_ASSERT(ds == 0);
+	D_ASSERT(device, page == NULL);
+	D_ASSERT(device, ds == 0);
 
 	atomic_set(&peer_req->pending_bios, n_bios);
 	do {
@@ -1624,7 +1624,7 @@ static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
 	device->recv_cnt += data_size>>9;
 
 	bio = req->master_bio;
-	D_ASSERT(sector == bio->bi_iter.bi_sector);
+	D_ASSERT(device, sector == bio->bi_iter.bi_sector);
 
 	bio_for_each_segment(bvec, bio, iter) {
 		void *mapped = kmap(bvec.bv_page) + bvec.bv_offset;
@@ -1644,7 +1644,7 @@ static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
 		}
 	}
 
-	D_ASSERT(data_size == 0);
+	D_ASSERT(device, data_size == 0);
 	return 0;
 }
 
@@ -1660,7 +1660,7 @@ static int e_end_resync_block(struct drbd_work *w, int unused)
 	sector_t sector = peer_req->i.sector;
 	int err;
 
-	D_ASSERT(drbd_interval_empty(&peer_req->i));
+	D_ASSERT(device, drbd_interval_empty(&peer_req->i));
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
 		drbd_set_in_sync(device, sector, peer_req->i.size);
@@ -1774,7 +1774,7 @@ static int receive_RSDataReply(struct drbd_connection *connection, struct packet
 		return -EIO;
 
 	sector = be64_to_cpu(p->sector);
-	D_ASSERT(p->block_id == ID_SYNCER);
+	D_ASSERT(device, p->block_id == ID_SYNCER);
 
 	if (get_ldev(device)) {
 		/* data is submitted to disk within recv_resync_read.
@@ -1845,13 +1845,13 @@ static int e_end_block(struct drbd_work *w, int cancel)
 	 * P_WRITE_ACK / P_NEG_ACK, to get the sequence number right.  */
 	if (peer_req->flags & EE_IN_INTERVAL_TREE) {
 		spin_lock_irq(&first_peer_device(device)->connection->req_lock);
-		D_ASSERT(!drbd_interval_empty(&peer_req->i));
+		D_ASSERT(device, !drbd_interval_empty(&peer_req->i));
 		drbd_remove_epoch_entry_interval(device, peer_req);
 		if (peer_req->flags & EE_RESTART_REQUESTS)
 			restart_conflicting_writes(device, sector, peer_req->i.size);
 		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
 	} else
-		D_ASSERT(drbd_interval_empty(&peer_req->i));
+		D_ASSERT(device, drbd_interval_empty(&peer_req->i));
 
 	drbd_may_finish_epoch(first_peer_device(device)->connection, peer_req->epoch, EV_PUT + (cancel ? EV_CLEANUP : 0));
 
@@ -2197,8 +2197,8 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	dp_flags = be32_to_cpu(p->dp_flags);
 	rw |= wire_flags_to_bio(device, dp_flags);
 	if (peer_req->pages == NULL) {
-		D_ASSERT(peer_req->i.size == 0);
-		D_ASSERT(dp_flags & DP_FLUSH);
+		D_ASSERT(device, peer_req->i.size == 0);
+		D_ASSERT(device, dp_flags & DP_FLUSH);
 	}
 
 	if (dp_flags & DP_MAY_SET_IN_SYNC)
@@ -2461,7 +2461,7 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 			goto out_free_e;
 
 		if (pi->cmd == P_CSUM_RS_REQUEST) {
-			D_ASSERT(first_peer_device(device)->connection->agreed_pro_version >= 89);
+			D_ASSERT(device, first_peer_device(device)->connection->agreed_pro_version >= 89);
 			peer_req->w.cb = w_e_end_csum_rs_req;
 			/* used in the sector offset progress display */
 			device->bm_resync_fo = BM_SECT_TO_BIT(sector);
@@ -3356,11 +3356,11 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 	} else if (apv <= 94) {
 		header_size = sizeof(struct p_rs_param_89);
 		data_size = pi->size - header_size;
-		D_ASSERT(data_size == 0);
+		D_ASSERT(device, data_size == 0);
 	} else {
 		header_size = sizeof(struct p_rs_param_95);
 		data_size = pi->size - header_size;
-		D_ASSERT(data_size == 0);
+		D_ASSERT(device, data_size == 0);
 	}
 
 	/* initialize verify_alg and csums_alg */
@@ -3403,14 +3403,14 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 				goto reconnect;
 			/* we expect NUL terminated string */
 			/* but just in case someone tries to be evil */
-			D_ASSERT(p->verify_alg[data_size-1] == 0);
+			D_ASSERT(device, p->verify_alg[data_size-1] == 0);
 			p->verify_alg[data_size-1] = 0;
 
 		} else /* apv >= 89 */ {
 			/* we still expect NUL terminated strings */
 			/* but just in case someone tries to be evil */
-			D_ASSERT(p->verify_alg[SHARED_SECRET_MAX-1] == 0);
-			D_ASSERT(p->csums_alg[SHARED_SECRET_MAX-1] == 0);
+			D_ASSERT(device, p->verify_alg[SHARED_SECRET_MAX-1] == 0);
+			D_ASSERT(device, p->csums_alg[SHARED_SECRET_MAX-1] == 0);
 			p->verify_alg[SHARED_SECRET_MAX-1] = 0;
 			p->csums_alg[SHARED_SECRET_MAX-1] = 0;
 		}
@@ -3944,7 +3944,7 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 			} else {
 				if (test_and_clear_bit(CONN_DRY_RUN, &first_peer_device(device)->connection->flags))
 					return -EIO;
-				D_ASSERT(os.conn == C_WF_REPORT_PARAMS);
+				D_ASSERT(device, os.conn == C_WF_REPORT_PARAMS);
 				conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 				return -EIO;
 			}
@@ -4015,7 +4015,7 @@ static int receive_sync_uuid(struct drbd_connection *connection, struct packet_i
 		   device->state.conn < C_CONNECTED ||
 		   device->state.disk < D_NEGOTIATING);
 
-	/* D_ASSERT( device->state.conn == C_WF_SYNC_UUID ); */
+	/* D_ASSERT(device,  device->state.conn == C_WF_SYNC_UUID ); */
 
 	/* Here the _drbd_uuid_ functions are right, current should
 	   _not_ be rotated into the history */
@@ -4292,7 +4292,7 @@ static int receive_bitmap(struct drbd_connection *connection, struct packet_info
 			goto out;
 		/* Omit CS_ORDERED with this state transition to avoid deadlocks. */
 		rv = _drbd_request_state(device, NS(conn, C_WF_SYNC_UUID), CS_VERBOSE);
-		D_ASSERT(rv == SS_SUCCESS);
+		D_ASSERT(device, rv == SS_SUCCESS);
 	} else if (device->state.conn != C_WF_BITMAP_S) {
 		/* admin may have requested C_DISCONNECTING,
 		 * other threads may have noticed network errors */
@@ -4568,10 +4568,10 @@ static int drbd_disconnected(struct drbd_device *device)
 	if (i)
 		drbd_info(device, "pp_in_use = %d, expected 0\n", i);
 
-	D_ASSERT(list_empty(&device->read_ee));
-	D_ASSERT(list_empty(&device->active_ee));
-	D_ASSERT(list_empty(&device->sync_ee));
-	D_ASSERT(list_empty(&device->done_ee));
+	D_ASSERT(device, list_empty(&device->read_ee));
+	D_ASSERT(device, list_empty(&device->active_ee));
+	D_ASSERT(device, list_empty(&device->sync_ee));
+	D_ASSERT(device, list_empty(&device->done_ee));
 
 	return 0;
 }
@@ -4901,7 +4901,7 @@ static int got_RqSReply(struct drbd_connection *connection, struct packet_info *
 		return -EIO;
 
 	if (test_bit(CONN_WD_ST_CHG_REQ, &connection->flags)) {
-		D_ASSERT(connection->agreed_pro_version < 100);
+		D_ASSERT(device, connection->agreed_pro_version < 100);
 		return got_conn_RqSReply(connection, pi);
 	}
 
@@ -4944,7 +4944,7 @@ static int got_IsInSync(struct drbd_connection *connection, struct packet_info *
 	if (!device)
 		return -EIO;
 
-	D_ASSERT(first_peer_device(device)->connection->agreed_pro_version >= 89);
+	D_ASSERT(device, first_peer_device(device)->connection->agreed_pro_version >= 89);
 
 	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 68ea716..a4b46741 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -307,7 +307,7 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 static int drbd_req_put_completion_ref(struct drbd_request *req, struct bio_and_error *m, int put)
 {
 	struct drbd_device *device = req->w.device;
-	D_ASSERT(m || (req->rq_state & RQ_POSTPONED));
+	D_ASSERT(device, m || (req->rq_state & RQ_POSTPONED));
 
 	if (!atomic_sub_and_test(put, &req->completion_ref))
 		return 0;
@@ -374,7 +374,7 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 		++c_put;
 
 	if (!(s & RQ_LOCAL_ABORTED) && (set & RQ_LOCAL_ABORTED)) {
-		D_ASSERT(req->rq_state & RQ_LOCAL_PENDING);
+		D_ASSERT(device, req->rq_state & RQ_LOCAL_PENDING);
 		/* local completion may still come in later,
 		 * we need to keep the req object around. */
 		kref_get(&req->kref);
@@ -475,7 +475,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 	case TO_BE_SENT: /* via network */
 		/* reached via __drbd_make_request
 		 * and from w_read_retry_remote */
-		D_ASSERT(!(req->rq_state & RQ_NET_MASK));
+		D_ASSERT(device, !(req->rq_state & RQ_NET_MASK));
 		rcu_read_lock();
 		nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 		p = nc->wire_protocol;
@@ -488,7 +488,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 	case TO_BE_SUBMITTED: /* locally */
 		/* reached via __drbd_make_request */
-		D_ASSERT(!(req->rq_state & RQ_LOCAL_MASK));
+		D_ASSERT(device, !(req->rq_state & RQ_LOCAL_MASK));
 		mod_rq_state(req, m, 0, RQ_LOCAL_PENDING);
 		break;
 
@@ -533,13 +533,13 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		/* So we can verify the handle in the answer packet.
 		 * Corresponding drbd_remove_request_interval is in
 		 * drbd_req_complete() */
-		D_ASSERT(drbd_interval_empty(&req->i));
+		D_ASSERT(device, drbd_interval_empty(&req->i));
 		drbd_insert_interval(&device->read_requests, &req->i);
 
 		set_bit(UNPLUG_REMOTE, &device->flags);
 
-		D_ASSERT(req->rq_state & RQ_NET_PENDING);
-		D_ASSERT((req->rq_state & RQ_LOCAL_MASK) == 0);
+		D_ASSERT(device, req->rq_state & RQ_NET_PENDING);
+		D_ASSERT(device, (req->rq_state & RQ_LOCAL_MASK) == 0);
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED);
 		req->w.cb = w_send_read_req;
 		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &req->w);
@@ -551,7 +551,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 		/* Corresponding drbd_remove_request_interval is in
 		 * drbd_req_complete() */
-		D_ASSERT(drbd_interval_empty(&req->i));
+		D_ASSERT(device, drbd_interval_empty(&req->i));
 		drbd_insert_interval(&device->write_requests, &req->i);
 
 		/* NOTE
@@ -574,7 +574,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		set_bit(UNPLUG_REMOTE, &device->flags);
 
 		/* queue work item to send data */
-		D_ASSERT(req->rq_state & RQ_NET_PENDING);
+		D_ASSERT(device, req->rq_state & RQ_NET_PENDING);
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED|RQ_EXP_BARR_ACK);
 		req->w.cb =  w_send_dblock;
 		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &req->w);
@@ -640,15 +640,15 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * If this request had been marked as RQ_POSTPONED before,
 		 * it will actually not be completed, but "restarted",
 		 * resubmitted from the retry worker context. */
-		D_ASSERT(req->rq_state & RQ_NET_PENDING);
-		D_ASSERT(req->rq_state & RQ_EXP_WRITE_ACK);
+		D_ASSERT(device, req->rq_state & RQ_NET_PENDING);
+		D_ASSERT(device, req->rq_state & RQ_EXP_WRITE_ACK);
 		mod_rq_state(req, m, RQ_NET_PENDING, RQ_NET_DONE|RQ_NET_OK);
 		break;
 
 	case WRITE_ACKED_BY_PEER_AND_SIS:
 		req->rq_state |= RQ_NET_SIS;
 	case WRITE_ACKED_BY_PEER:
-		D_ASSERT(req->rq_state & RQ_EXP_WRITE_ACK);
+		D_ASSERT(device, req->rq_state & RQ_EXP_WRITE_ACK);
 		/* protocol C; successfully written on peer.
 		 * Nothing more to do here.
 		 * We want to keep the tl in place for all protocols, to cater
@@ -656,22 +656,22 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 		goto ack_common;
 	case RECV_ACKED_BY_PEER:
-		D_ASSERT(req->rq_state & RQ_EXP_RECEIVE_ACK);
+		D_ASSERT(device, req->rq_state & RQ_EXP_RECEIVE_ACK);
 		/* protocol B; pretends to be successfully written on peer.
 		 * see also notes above in HANDED_OVER_TO_NETWORK about
 		 * protocol != C */
 	ack_common:
-		D_ASSERT(req->rq_state & RQ_NET_PENDING);
+		D_ASSERT(device, req->rq_state & RQ_NET_PENDING);
 		mod_rq_state(req, m, RQ_NET_PENDING, RQ_NET_OK);
 		break;
 
 	case POSTPONE_WRITE:
-		D_ASSERT(req->rq_state & RQ_EXP_WRITE_ACK);
+		D_ASSERT(device, req->rq_state & RQ_EXP_WRITE_ACK);
 		/* If this node has already detected the write conflict, the
 		 * worker will be waiting on misc_wait.  Wake it up once this
 		 * request has completed locally.
 		 */
-		D_ASSERT(req->rq_state & RQ_NET_PENDING);
+		D_ASSERT(device, req->rq_state & RQ_NET_PENDING);
 		req->rq_state |= RQ_POSTPONED;
 		if (req->i.waiting)
 			wake_up(&device->misc_wait);
@@ -752,7 +752,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		break;
 
 	case DATA_RECEIVED:
-		D_ASSERT(req->rq_state & RQ_NET_PENDING);
+		D_ASSERT(device, req->rq_state & RQ_NET_PENDING);
 		mod_rq_state(req, m, RQ_NET_PENDING, RQ_NET_OK|RQ_NET_DONE);
 		break;
 
@@ -783,8 +783,8 @@ static bool drbd_may_do_local_read(struct drbd_device *device, sector_t sector,
 		return false;
 	esector = sector + (size >> 9) - 1;
 	nr_sectors = drbd_get_capacity(device->this_bdev);
-	D_ASSERT(sector  < nr_sectors);
-	D_ASSERT(esector < nr_sectors);
+	D_ASSERT(device, sector  < nr_sectors);
+	D_ASSERT(device, esector < nr_sectors);
 
 	sbnr = BM_SECT_TO_BIT(sector);
 	ebnr = BM_SECT_TO_BIT(esector);
@@ -974,7 +974,7 @@ static int drbd_process_write_request(struct drbd_request *req)
 	 * replicating, in which case there is no point. */
 	if (unlikely(req->i.size == 0)) {
 		/* The only size==0 bios we expect are empty flushes. */
-		D_ASSERT(req->master_bio->bi_rw & REQ_FLUSH);
+		D_ASSERT(device, req->master_bio->bi_rw & REQ_FLUSH);
 		if (remote)
 			_req_mod(req, QUEUE_AS_DRBD_BARRIER);
 		return remote;
@@ -983,7 +983,7 @@ static int drbd_process_write_request(struct drbd_request *req)
 	if (!remote && !send_oos)
 		return 0;
 
-	D_ASSERT(!(remote && send_oos));
+	D_ASSERT(device, !(remote && send_oos));
 
 	if (remote) {
 		_req_mod(req, TO_BE_SENT);
@@ -1281,7 +1281,7 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 	/*
 	 * what we "blindly" assume:
 	 */
-	D_ASSERT(IS_ALIGNED(bio->bi_iter.bi_size, 512));
+	D_ASSERT(device, IS_ALIGNED(bio->bi_iter.bi_size, 512));
 
 	inc_ap_bio(device);
 	__drbd_make_request(device, bio, start_time);
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 464ddd4..cbd287a 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -379,7 +379,7 @@ drbd_req_state(struct drbd_device *device, union drbd_state mask,
 	spin_unlock_irqrestore(&first_peer_device(device)->connection->req_lock, flags);
 
 	if (f & CS_WAIT_COMPLETE && rv == SS_SUCCESS) {
-		D_ASSERT(current != first_peer_device(device)->connection->worker.task);
+		D_ASSERT(device, current != first_peer_device(device)->connection->worker.task);
 		wait_for_completion(&done);
 	}
 
@@ -1166,7 +1166,7 @@ static int w_after_state_ch(struct drbd_work *w, int unused)
 
 	after_state_ch(device, ascw->os, ascw->ns, ascw->flags);
 	if (ascw->flags & CS_WAIT_COMPLETE) {
-		D_ASSERT(ascw->done != NULL);
+		D_ASSERT(device, ascw->done != NULL);
 		complete(ascw->done);
 	}
 	kfree(ascw);
@@ -1198,7 +1198,7 @@ int drbd_bitmap_io_from_worker(struct drbd_device *device,
 {
 	int rv;
 
-	D_ASSERT(current == first_peer_device(device)->connection->worker.task);
+	D_ASSERT(device, current == first_peer_device(device)->connection->worker.task);
 
 	/* open coded non-blocking drbd_suspend_io(device); */
 	set_bit(SUSPEND_IO, &device->flags);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 9ed105e..560ebfd 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -881,7 +881,7 @@ int drbd_resync_finished(struct drbd_device *device)
 			khelper_cmd = "out-of-sync";
 		}
 	} else {
-		D_ASSERT((n_oos - device->rs_failed) == 0);
+		D_ASSERT(device, (n_oos - device->rs_failed) == 0);
 
 		if (os.conn == C_SYNC_TARGET || os.conn == C_PAUSED_SYNC_T)
 			khelper_cmd = "after-resync-target";
@@ -1099,7 +1099,7 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 		 * introducing more locking mechanisms */
 		if (first_peer_device(device)->connection->csums_tfm) {
 			digest_size = crypto_hash_digestsize(first_peer_device(device)->connection->csums_tfm);
-			D_ASSERT(digest_size == di->digest_size);
+			D_ASSERT(device, digest_size == di->digest_size);
 			digest = kmalloc(digest_size, GFP_NOIO);
 		}
 		if (digest) {
@@ -1223,7 +1223,7 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 		if (digest) {
 			drbd_csum_ee(device, first_peer_device(device)->connection->verify_tfm, peer_req, digest);
 
-			D_ASSERT(digest_size == di->digest_size);
+			D_ASSERT(device, digest_size == di->digest_size);
 			eq = !memcmp(digest, di->digest, digest_size);
 			kfree(digest);
 		}
@@ -1936,7 +1936,7 @@ int drbd_worker(struct drbd_thread *thi)
 	rcu_read_lock();
 	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
 		struct drbd_device *device = peer_device->device;
-		D_ASSERT(device->state.disk == D_DISKLESS && device->state.conn == C_STANDALONE);
+		D_ASSERT(device, device->state.disk == D_DISKLESS && device->state.conn == C_STANDALONE);
 		kref_get(&device->kref);
 		rcu_read_unlock();
 		drbd_device_cleanup(device);
-- 
1.7.9.5

