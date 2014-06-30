Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbaF3QBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:01:33 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50032 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaF3PxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/18] drbd: get rid of atomic update on disk bitmap works
Date: Mon, 30 Jun 2014 17:52:56 +0200
Message-Id: <1404143587-24344-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Just trigger the occasional lazy bitmap write-out during resync
from the central wait_for_work() helper.

Previously, during resync, bitmap pages would be written out separately,
synchronously, one at a time, at least 8 times each (every 512 bytes
worth of bitmap cleared).

Now we trigger "merge friendly" bulk write out of all cleared pages
every two seconds during resync, and once the resync is finished.
Most pages will be written out only once.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c | 63 +---------------------------------------
 drivers/block/drbd/drbd_bitmap.c | 55 -----------------------------------
 drivers/block/drbd/drbd_int.h    |  2 +-
 drivers/block/drbd/drbd_nl.c     |  7 -----
 drivers/block/drbd/drbd_worker.c | 54 ++++++++++++++++++++++++++++++++++
 5 files changed, 56 insertions(+), 125 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 05a1780..9c42edf 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -92,12 +92,6 @@ struct __packed al_transaction_on_disk {
 	__be32	context[AL_CONTEXT_PER_TRANSACTION];
 };
 
-struct update_odbm_work {
-	struct drbd_work w;
-	struct drbd_device *device;
-	unsigned int enr;
-};
-
 struct update_al_work {
 	struct drbd_work w;
 	struct drbd_device *device;
@@ -452,15 +446,6 @@ static unsigned int al_extent_to_bm_page(unsigned int al_enr)
 		 (AL_EXTENT_SHIFT - BM_BLOCK_SHIFT));
 }
 
-static unsigned int rs_extent_to_bm_page(unsigned int rs_enr)
-{
-	return rs_enr >>
-		/* bit to page */
-		((PAGE_SHIFT + 3) -
-		/* resync extent number to bit */
-		 (BM_EXT_SHIFT - BM_BLOCK_SHIFT));
-}
-
 static sector_t al_tr_number_to_on_disk_sector(struct drbd_device *device)
 {
 	const unsigned int stripes = device->ldev->md.al_stripes;
@@ -682,40 +667,6 @@ int drbd_initialize_al(struct drbd_device *device, void *buffer)
 	return 0;
 }
 
-static int w_update_odbm(struct drbd_work *w, int unused)
-{
-	struct update_odbm_work *udw = container_of(w, struct update_odbm_work, w);
-	struct drbd_device *device = udw->device;
-	struct sib_info sib = { .sib_reason = SIB_SYNC_PROGRESS, };
-
-	if (!get_ldev(device)) {
-		if (__ratelimit(&drbd_ratelimit_state))
-			drbd_warn(device, "Can not update on disk bitmap, local IO disabled.\n");
-		kfree(udw);
-		return 0;
-	}
-
-	drbd_bm_write_page(device, rs_extent_to_bm_page(udw->enr));
-	put_ldev(device);
-
-	kfree(udw);
-
-	if (drbd_bm_total_weight(device) <= device->rs_failed) {
-		switch (device->state.conn) {
-		case C_SYNC_SOURCE:  case C_SYNC_TARGET:
-		case C_PAUSED_SYNC_S: case C_PAUSED_SYNC_T:
-			drbd_resync_finished(device);
-		default:
-			/* nothing to do */
-			break;
-		}
-	}
-	drbd_bcast_event(device, &sib);
-
-	return 0;
-}
-
-
 /* ATTENTION. The AL's extents are 4MB each, while the extents in the
  * resync LRU-cache are 16MB each.
  * The caller of this function has to hold an get_ldev() reference.
@@ -726,8 +677,6 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *device, sector_t secto
 				      int count, int success)
 {
 	struct lc_element *e;
-	struct update_odbm_work *udw;
-
 	unsigned int enr;
 
 	D_ASSERT(device, atomic_read(&device->local_cnt));
@@ -791,17 +740,7 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *device, sector_t secto
 
 		if (ext->rs_left == ext->rs_failed) {
 			ext->rs_failed = 0;
-
-			udw = kmalloc(sizeof(*udw), GFP_ATOMIC);
-			if (udw) {
-				udw->enr = ext->lce.lc_number;
-				udw->w.cb = w_update_odbm;
-				udw->device = device;
-				drbd_queue_work_front(&first_peer_device(device)->connection->sender_work,
-						      &udw->w);
-			} else {
-				drbd_warn(device, "Could not kmalloc an udw\n");
-			}
+			wake_up(&first_peer_device(device)->connection->sender_work.q_wait);
 		}
 	} else {
 		drbd_err(device, "lc_get() failed! locked=%d/%d flags=%lu\n",
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index ed31041..3da6730 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1227,61 +1227,6 @@ int drbd_bm_write_hinted(struct drbd_device *device) __must_hold(local)
 	return bm_rw(device, WRITE, BM_AIO_WRITE_HINTED | BM_AIO_COPY_PAGES, 0);
 }
 
-/**
- * drbd_bm_write_page() - Writes a PAGE_SIZE aligned piece of bitmap
- * @device:	DRBD device.
- * @idx:	bitmap page index
- *
- * We don't want to special case on logical_block_size of the backend device,
- * so we submit PAGE_SIZE aligned pieces.
- * Note that on "most" systems, PAGE_SIZE is 4k.
- *
- * In case this becomes an issue on systems with larger PAGE_SIZE,
- * we may want to change this again to write 4k aligned 4k pieces.
- */
-int drbd_bm_write_page(struct drbd_device *device, unsigned int idx) __must_hold(local)
-{
-	struct bm_aio_ctx *ctx;
-	int err;
-
-	if (bm_test_page_unchanged(device->bitmap->bm_pages[idx])) {
-		dynamic_drbd_dbg(device, "skipped bm page write for idx %u\n", idx);
-		return 0;
-	}
-
-	ctx = kmalloc(sizeof(struct bm_aio_ctx), GFP_NOIO);
-	if (!ctx)
-		return -ENOMEM;
-
-	*ctx = (struct bm_aio_ctx) {
-		.device = device,
-		.in_flight = ATOMIC_INIT(1),
-		.done = 0,
-		.flags = BM_AIO_COPY_PAGES,
-		.error = 0,
-		.kref = { ATOMIC_INIT(2) },
-	};
-
-	if (!get_ldev(device)) {  /* put is in bm_aio_ctx_destroy() */
-		drbd_err(device, "ASSERT FAILED: get_ldev_if_state() == 1 in drbd_bm_write_page()\n");
-		kfree(ctx);
-		return -ENODEV;
-	}
-
-	bm_page_io_async(ctx, idx, WRITE_SYNC);
-	wait_until_done_or_force_detached(device, device->ldev, &ctx->done);
-
-	if (ctx->error)
-		drbd_chk_io_error(device, 1, DRBD_META_IO_ERROR);
-		/* that causes us to detach, so the in memory bitmap will be
-		 * gone in a moment as well. */
-
-	device->bm_writ_cnt++;
-	err = atomic_read(&ctx->in_flight) ? -EIO : ctx->error;
-	kref_put(&ctx->kref, &bm_aio_ctx_destroy);
-	return err;
-}
-
 /* NOTE
  * find_first_bit returns int, we return unsigned long.
  * For this to work on 32bit arch with bitnumbers > (1<<32),
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 82ece1b..eb002a7 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1196,11 +1196,11 @@ extern void _drbd_bm_set_bits(struct drbd_device *device,
 		const unsigned long s, const unsigned long e);
 extern int  drbd_bm_test_bit(struct drbd_device *device, unsigned long bitnr);
 extern int  drbd_bm_e_weight(struct drbd_device *device, unsigned long enr);
-extern int  drbd_bm_write_page(struct drbd_device *device, unsigned int idx) __must_hold(local);
 extern int  drbd_bm_read(struct drbd_device *device) __must_hold(local);
 extern void drbd_bm_mark_for_writeout(struct drbd_device *device, int page_nr);
 extern int  drbd_bm_write(struct drbd_device *device) __must_hold(local);
 extern int  drbd_bm_write_hinted(struct drbd_device *device) __must_hold(local);
+extern int  drbd_bm_write_lazy(struct drbd_device *device, unsigned upper_idx) __must_hold(local);
 extern int drbd_bm_write_all(struct drbd_device *device) __must_hold(local);
 extern int  drbd_bm_write_copy_pages(struct drbd_device *device) __must_hold(local);
 extern size_t	     drbd_bm_words(struct drbd_device *device);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 66065e6..52221f6 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -3641,13 +3641,6 @@ void drbd_bcast_event(struct drbd_device *device, const struct sib_info *sib)
 	unsigned seq;
 	int err = -ENOMEM;
 
-	if (sib->sib_reason == SIB_SYNC_PROGRESS) {
-		if (time_after(jiffies, device->rs_last_bcast + HZ))
-			device->rs_last_bcast = jiffies;
-		else
-			return;
-	}
-
 	seq = atomic_inc_return(&drbd_genl_seq);
 	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_NOIO);
 	if (!msg)
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 595ab57..5915885 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1804,6 +1804,58 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 	mutex_unlock(device->state_mutex);
 }
 
+static void update_on_disk_bitmap(struct drbd_device *device)
+{
+	struct sib_info sib = { .sib_reason = SIB_SYNC_PROGRESS, };
+	device->rs_last_bcast = jiffies;
+
+	if (!get_ldev(device))
+		return;
+
+	drbd_bm_write_lazy(device, 0);
+	if (drbd_bm_total_weight(device) <= device->rs_failed)
+		drbd_resync_finished(device);
+	drbd_bcast_event(device, &sib);
+	/* update timestamp, in case it took a while to write out stuff */
+	device->rs_last_bcast = jiffies;
+	put_ldev(device);
+}
+
+bool wants_lazy_bitmap_update(struct drbd_device *device)
+{
+	enum drbd_conns connection_state = device->state.conn;
+	return
+	/* only do a lazy writeout, if device is in some resync state */
+	   (connection_state == C_SYNC_SOURCE
+	||  connection_state == C_SYNC_TARGET
+	||  connection_state == C_PAUSED_SYNC_S
+	||  connection_state == C_PAUSED_SYNC_T) &&
+	/* AND
+	 * either we just finished, or the last lazy update
+	 * was some time ago already. */
+	   (drbd_bm_total_weight(device) <= device->rs_failed
+	||  time_after(jiffies, device->rs_last_bcast + 2*HZ));
+}
+
+static void try_update_all_on_disk_bitmaps(struct drbd_connection *connection)
+{
+	struct drbd_peer_device *peer_device;
+	int vnr;
+
+	rcu_read_lock();
+	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
+		struct drbd_device *device = peer_device->device;
+		if (!wants_lazy_bitmap_update(device))
+			continue;
+		kref_get(&device->kref);
+		rcu_read_unlock();
+		update_on_disk_bitmap(device);
+		kref_put(&device->kref, drbd_destroy_device);
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+}
+
 static bool dequeue_work_batch(struct drbd_work_queue *queue, struct list_head *work_list)
 {
 	spin_lock_irq(&queue->q_lock);
@@ -1882,6 +1934,8 @@ static void wait_for_work(struct drbd_connection *connection, struct list_head *
 		/* may be woken up for other things but new work, too,
 		 * e.g. if the current epoch got closed.
 		 * In which case we send the barrier above. */
+
+		try_update_all_on_disk_bitmaps(connection);
 	}
 	finish_wait(&connection->sender_work.q_wait, &wait);
 
-- 
1.9.1

