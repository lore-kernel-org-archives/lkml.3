Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbaF3P5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:57:05 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50036 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbaF3PxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/18] drbd: fix resync finished detection
Date: Mon, 30 Jun 2014 17:52:58 +0200
Message-Id: <1404143587-24344-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

This fixes one recent regresion,
and one long existing bug.

The bug:
drbd_try_clear_on_disk_bm() assumed that all "count" bits have to be
accounted in the resync extent corresponding to the start sector.

Since we allow application requests to cross our "extent" boundaries,
this assumption is no longer true, resulting in possible misaccounting,
scary messages
("BAD! sector=12345s enr=6 rs_left=-7 rs_failed=0 count=58 cstate=..."),
and potentially, if the last bit to be cleared during resync would
reside in previously misaccounted resync extent, the resync would never
be recognized as finished, but would be "stalled" forever, even though
all blocks are in sync again and all bits have been cleared...

The regression was introduced by
    drbd: get rid of atomic update on disk bitmap works

For an "empty" resync (rs_total == 0), we must not "finish" the
resync on the SyncSource before the SyncTarget knows all relevant
information (sync uuid).  We need to wait for the full round-trip,
the SyncTarget will then explicitly notify us.

Also for normal, non-empty resyncs (rs_total > 0), the resync-finished
condition needs to be tested before the schedule() in wait_for_work, or
it is likely to be missed.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c | 315 ++++++++++++++++++---------------------
 drivers/block/drbd/drbd_int.h    |  42 ++++--
 drivers/block/drbd/drbd_state.c  |   3 +
 drivers/block/drbd/drbd_worker.c |  42 +++---
 4 files changed, 197 insertions(+), 205 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 9c42edf..278c31f 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -667,36 +667,56 @@ int drbd_initialize_al(struct drbd_device *device, void *buffer)
 	return 0;
 }
 
+static const char *drbd_change_sync_fname[] = {
+	[RECORD_RS_FAILED] = "drbd_rs_failed_io",
+	[SET_IN_SYNC] = "drbd_set_in_sync",
+	[SET_OUT_OF_SYNC] = "drbd_set_out_of_sync"
+};
+
 /* ATTENTION. The AL's extents are 4MB each, while the extents in the
  * resync LRU-cache are 16MB each.
  * The caller of this function has to hold an get_ldev() reference.
  *
+ * Adjusts the caching members ->rs_left (success) or ->rs_failed (!success),
+ * potentially pulling in (and recounting the corresponding bits)
+ * this resync extent into the resync extent lru cache.
+ *
+ * Returns whether all bits have been cleared for this resync extent,
+ * precisely: (rs_left <= rs_failed)
+ *
  * TODO will be obsoleted once we have a caching lru of the on disk bitmap
  */
-static void drbd_try_clear_on_disk_bm(struct drbd_device *device, sector_t sector,
-				      int count, int success)
+static bool update_rs_extent(struct drbd_device *device,
+		unsigned int enr, int count,
+		enum update_sync_bits_mode mode)
 {
 	struct lc_element *e;
-	unsigned int enr;
 
 	D_ASSERT(device, atomic_read(&device->local_cnt));
 
-	/* I simply assume that a sector/size pair never crosses
-	 * a 16 MB extent border. (Currently this is true...) */
-	enr = BM_SECT_TO_EXT(sector);
-
-	e = lc_get(device->resync, enr);
+	/* When setting out-of-sync bits,
+	 * we don't need it cached (lc_find).
+	 * But if it is present in the cache,
+	 * we should update the cached bit count.
+	 * Otherwise, that extent should be in the resync extent lru cache
+	 * already -- or we want to pull it in if necessary -- (lc_get),
+	 * then update and check rs_left and rs_failed. */
+	if (mode == SET_OUT_OF_SYNC)
+		e = lc_find(device->resync, enr);
+	else
+		e = lc_get(device->resync, enr);
 	if (e) {
 		struct bm_extent *ext = lc_entry(e, struct bm_extent, lce);
 		if (ext->lce.lc_number == enr) {
-			if (success)
+			if (mode == SET_IN_SYNC)
 				ext->rs_left -= count;
+			else if (mode == SET_OUT_OF_SYNC)
+				ext->rs_left += count;
 			else
 				ext->rs_failed += count;
 			if (ext->rs_left < ext->rs_failed) {
-				drbd_warn(device, "BAD! sector=%llus enr=%u rs_left=%d "
+				drbd_warn(device, "BAD! enr=%u rs_left=%d "
 				    "rs_failed=%d count=%d cstate=%s\n",
-				     (unsigned long long)sector,
 				     ext->lce.lc_number, ext->rs_left,
 				     ext->rs_failed, count,
 				     drbd_conn_str(device->state.conn));
@@ -730,24 +750,27 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *device, sector_t secto
 				     ext->lce.lc_number, ext->rs_failed);
 			}
 			ext->rs_left = rs_left;
-			ext->rs_failed = success ? 0 : count;
+			ext->rs_failed = (mode == RECORD_RS_FAILED) ? count : 0;
 			/* we don't keep a persistent log of the resync lru,
 			 * we can commit any change right away. */
 			lc_committed(device->resync);
 		}
-		lc_put(device->resync, &ext->lce);
+		if (mode != SET_OUT_OF_SYNC)
+			lc_put(device->resync, &ext->lce);
 		/* no race, we are within the al_lock! */
 
-		if (ext->rs_left == ext->rs_failed) {
+		if (ext->rs_left <= ext->rs_failed) {
 			ext->rs_failed = 0;
-			wake_up(&first_peer_device(device)->connection->sender_work.q_wait);
+			return true;
 		}
-	} else {
+	} else if (mode != SET_OUT_OF_SYNC) {
+		/* be quiet if lc_find() did not find it. */
 		drbd_err(device, "lc_get() failed! locked=%d/%d flags=%lu\n",
 		    device->resync_locked,
 		    device->resync->nr_elements,
 		    device->resync->flags);
 	}
+	return false;
 }
 
 void drbd_advance_rs_marks(struct drbd_device *device, unsigned long still_to_go)
@@ -766,105 +789,112 @@ void drbd_advance_rs_marks(struct drbd_device *device, unsigned long still_to_go
 	}
 }
 
-/* clear the bit corresponding to the piece of storage in question:
- * size byte of data starting from sector.  Only clear a bits of the affected
- * one ore more _aligned_ BM_BLOCK_SIZE blocks.
- *
- * called by worker on C_SYNC_TARGET and receiver on SyncSource.
- *
- */
-void __drbd_set_in_sync(struct drbd_device *device, sector_t sector, int size,
-		       const char *file, const unsigned int line)
+/* It is called lazy update, so don't do write-out too often. */
+static bool lazy_bitmap_update_due(struct drbd_device *device)
 {
-	/* Is called from worker and receiver context _only_ */
-	unsigned long sbnr, ebnr, lbnr;
-	unsigned long count = 0;
-	sector_t esector, nr_sectors;
-	int wake_up = 0;
-	unsigned long flags;
+	return time_after(jiffies, device->rs_last_bcast + 2*HZ);
+}
 
-	if (size <= 0 || !IS_ALIGNED(size, 512) || size > DRBD_MAX_DISCARD_SIZE) {
-		drbd_err(device, "drbd_set_in_sync: sector=%llus size=%d nonsense!\n",
-				(unsigned long long)sector, size);
+static void maybe_schedule_on_disk_bitmap_update(struct drbd_device *device, bool rs_done)
+{
+	struct drbd_connection *connection;
+	if (rs_done)
+		set_bit(RS_DONE, &device->flags);
+		/* and also set RS_PROGRESS below */
+	else if (!lazy_bitmap_update_due(device))
 		return;
-	}
 
-	if (!get_ldev(device))
-		return; /* no disk, no metadata, no bitmap to clear bits in */
-
-	nr_sectors = drbd_get_capacity(device->this_bdev);
-	esector = sector + (size >> 9) - 1;
-
-	if (!expect(sector < nr_sectors))
-		goto out;
-	if (!expect(esector < nr_sectors))
-		esector = nr_sectors - 1;
-
-	lbnr = BM_SECT_TO_BIT(nr_sectors-1);
-
-	/* we clear it (in sync).
-	 * round up start sector, round down end sector.  we make sure we only
-	 * clear full, aligned, BM_BLOCK_SIZE (4K) blocks */
-	if (unlikely(esector < BM_SECT_PER_BIT-1))
-		goto out;
-	if (unlikely(esector == (nr_sectors-1)))
-		ebnr = lbnr;
-	else
-		ebnr = BM_SECT_TO_BIT(esector - (BM_SECT_PER_BIT-1));
-	sbnr = BM_SECT_TO_BIT(sector + BM_SECT_PER_BIT-1);
-
-	if (sbnr > ebnr)
-		goto out;
+	/* compare with test_and_clear_bit() calls in and above
+	 * try_update_all_on_disk_bitmaps() from the drbd_worker(). */
+	if (test_and_set_bit(RS_PROGRESS, &device->flags))
+		return;
+	connection = first_peer_device(device)->connection;
+	if (!test_and_set_bit(CONN_RS_PROGRESS, &connection->flags))
+		wake_up(&connection->sender_work.q_wait);
+}
 
+static int update_sync_bits(struct drbd_device *device,
+		unsigned long sbnr, unsigned long ebnr,
+		enum update_sync_bits_mode mode)
+{
 	/*
-	 * ok, (capacity & 7) != 0 sometimes, but who cares...
-	 * we count rs_{total,left} in bits, not sectors.
+	 * We keep a count of set bits per resync-extent in the ->rs_left
+	 * caching member, so we need to loop and work within the resync extent
+	 * alignment. Typically this loop will execute exactly once.
 	 */
-	count = drbd_bm_clear_bits(device, sbnr, ebnr);
-	if (count) {
-		drbd_advance_rs_marks(device, drbd_bm_total_weight(device));
-		spin_lock_irqsave(&device->al_lock, flags);
-		drbd_try_clear_on_disk_bm(device, sector, count, true);
-		spin_unlock_irqrestore(&device->al_lock, flags);
-
-		/* just wake_up unconditional now, various lc_chaged(),
-		 * lc_put() in drbd_try_clear_on_disk_bm(). */
-		wake_up = 1;
+	unsigned long flags;
+	unsigned long count = 0;
+	unsigned int cleared = 0;
+	while (sbnr <= ebnr) {
+		/* set temporary boundary bit number to last bit number within
+		 * the resync extent of the current start bit number,
+		 * but cap at provided end bit number */
+		unsigned long tbnr = min(ebnr, sbnr | BM_BLOCKS_PER_BM_EXT_MASK);
+		unsigned long c;
+
+		if (mode == RECORD_RS_FAILED)
+			/* Only called from drbd_rs_failed_io(), bits
+			 * supposedly still set.  Recount, maybe some
+			 * of the bits have been successfully cleared
+			 * by application IO meanwhile.
+			 */
+			c = drbd_bm_count_bits(device, sbnr, tbnr);
+		else if (mode == SET_IN_SYNC)
+			c = drbd_bm_clear_bits(device, sbnr, tbnr);
+		else /* if (mode == SET_OUT_OF_SYNC) */
+			c = drbd_bm_set_bits(device, sbnr, tbnr);
+
+		if (c) {
+			spin_lock_irqsave(&device->al_lock, flags);
+			cleared += update_rs_extent(device, BM_BIT_TO_EXT(sbnr), c, mode);
+			spin_unlock_irqrestore(&device->al_lock, flags);
+			count += c;
+		}
+		sbnr = tbnr + 1;
 	}
-out:
-	put_ldev(device);
-	if (wake_up)
+	if (count) {
+		if (mode == SET_IN_SYNC) {
+			unsigned long still_to_go = drbd_bm_total_weight(device);
+			bool rs_is_done = (still_to_go <= device->rs_failed);
+			drbd_advance_rs_marks(device, still_to_go);
+			if (cleared || rs_is_done)
+				maybe_schedule_on_disk_bitmap_update(device, rs_is_done);
+		} else if (mode == RECORD_RS_FAILED)
+			device->rs_failed += count;
 		wake_up(&device->al_wait);
+	}
+	return count;
 }
 
-/*
- * this is intended to set one request worth of data out of sync.
- * affects at least 1 bit,
- * and at most 1+DRBD_MAX_BIO_SIZE/BM_BLOCK_SIZE bits.
+/* clear the bit corresponding to the piece of storage in question:
+ * size byte of data starting from sector.  Only clear a bits of the affected
+ * one ore more _aligned_ BM_BLOCK_SIZE blocks.
+ *
+ * called by worker on C_SYNC_TARGET and receiver on SyncSource.
  *
- * called by tl_clear and drbd_send_dblock (==drbd_make_request).
- * so this can be _any_ process.
  */
-int __drbd_set_out_of_sync(struct drbd_device *device, sector_t sector, int size,
-			    const char *file, const unsigned int line)
+int __drbd_change_sync(struct drbd_device *device, sector_t sector, int size,
+		enum update_sync_bits_mode mode,
+		const char *file, const unsigned int line)
 {
-	unsigned long sbnr, ebnr, flags;
+	/* Is called from worker and receiver context _only_ */
+	unsigned long sbnr, ebnr, lbnr;
+	unsigned long count = 0;
 	sector_t esector, nr_sectors;
-	unsigned int enr, count = 0;
-	struct lc_element *e;
 
-	/* this should be an empty REQ_FLUSH */
-	if (size == 0)
+	/* This would be an empty REQ_FLUSH, be silent. */
+	if ((mode == SET_OUT_OF_SYNC) && size == 0)
 		return 0;
 
-	if (size < 0 || !IS_ALIGNED(size, 512) || size > DRBD_MAX_DISCARD_SIZE) {
-		drbd_err(device, "sector: %llus, size: %d\n",
-			(unsigned long long)sector, size);
+	if (size <= 0 || !IS_ALIGNED(size, 512) || size > DRBD_MAX_DISCARD_SIZE) {
+		drbd_err(device, "%s: sector=%llus size=%d nonsense!\n",
+				drbd_change_sync_fname[mode],
+				(unsigned long long)sector, size);
 		return 0;
 	}
 
 	if (!get_ldev(device))
-		return 0; /* no disk, no metadata, no bitmap to set bits in */
+		return 0; /* no disk, no metadata, no bitmap to manipulate bits in */
 
 	nr_sectors = drbd_get_capacity(device->this_bdev);
 	esector = sector + (size >> 9) - 1;
@@ -874,25 +904,28 @@ int __drbd_set_out_of_sync(struct drbd_device *device, sector_t sector, int size
 	if (!expect(esector < nr_sectors))
 		esector = nr_sectors - 1;
 
-	/* we set it out of sync,
-	 * we do not need to round anything here */
-	sbnr = BM_SECT_TO_BIT(sector);
-	ebnr = BM_SECT_TO_BIT(esector);
-
-	/* ok, (capacity & 7) != 0 sometimes, but who cares...
-	 * we count rs_{total,left} in bits, not sectors.  */
-	spin_lock_irqsave(&device->al_lock, flags);
-	count = drbd_bm_set_bits(device, sbnr, ebnr);
+	lbnr = BM_SECT_TO_BIT(nr_sectors-1);
 
-	enr = BM_SECT_TO_EXT(sector);
-	e = lc_find(device->resync, enr);
-	if (e)
-		lc_entry(e, struct bm_extent, lce)->rs_left += count;
-	spin_unlock_irqrestore(&device->al_lock, flags);
+	if (mode == SET_IN_SYNC) {
+		/* Round up start sector, round down end sector.  We make sure
+		 * we only clear full, aligned, BM_BLOCK_SIZE blocks. */
+		if (unlikely(esector < BM_SECT_PER_BIT-1))
+			goto out;
+		if (unlikely(esector == (nr_sectors-1)))
+			ebnr = lbnr;
+		else
+			ebnr = BM_SECT_TO_BIT(esector - (BM_SECT_PER_BIT-1));
+		sbnr = BM_SECT_TO_BIT(sector + BM_SECT_PER_BIT-1);
+	} else {
+		/* We set it out of sync, or record resync failure.
+		 * Should not round anything here. */
+		sbnr = BM_SECT_TO_BIT(sector);
+		ebnr = BM_SECT_TO_BIT(esector);
+	}
 
+	count = update_sync_bits(device, sbnr, ebnr, mode);
 out:
 	put_ldev(device);
-
 	return count;
 }
 
@@ -1209,69 +1242,3 @@ int drbd_rs_del_all(struct drbd_device *device)
 
 	return 0;
 }
-
-/**
- * drbd_rs_failed_io() - Record information on a failure to resync the specified blocks
- * @device:	DRBD device.
- * @sector:	The sector number.
- * @size:	Size of failed IO operation, in byte.
- */
-void drbd_rs_failed_io(struct drbd_device *device, sector_t sector, int size)
-{
-	/* Is called from worker and receiver context _only_ */
-	unsigned long sbnr, ebnr, lbnr;
-	unsigned long count;
-	sector_t esector, nr_sectors;
-	int wake_up = 0;
-
-	if (size <= 0 || !IS_ALIGNED(size, 512) || size > DRBD_MAX_DISCARD_SIZE) {
-		drbd_err(device, "drbd_rs_failed_io: sector=%llus size=%d nonsense!\n",
-				(unsigned long long)sector, size);
-		return;
-	}
-	nr_sectors = drbd_get_capacity(device->this_bdev);
-	esector = sector + (size >> 9) - 1;
-
-	if (!expect(sector < nr_sectors))
-		return;
-	if (!expect(esector < nr_sectors))
-		esector = nr_sectors - 1;
-
-	lbnr = BM_SECT_TO_BIT(nr_sectors-1);
-
-	/*
-	 * round up start sector, round down end sector.  we make sure we only
-	 * handle full, aligned, BM_BLOCK_SIZE (4K) blocks */
-	if (unlikely(esector < BM_SECT_PER_BIT-1))
-		return;
-	if (unlikely(esector == (nr_sectors-1)))
-		ebnr = lbnr;
-	else
-		ebnr = BM_SECT_TO_BIT(esector - (BM_SECT_PER_BIT-1));
-	sbnr = BM_SECT_TO_BIT(sector + BM_SECT_PER_BIT-1);
-
-	if (sbnr > ebnr)
-		return;
-
-	/*
-	 * ok, (capacity & 7) != 0 sometimes, but who cares...
-	 * we count rs_{total,left} in bits, not sectors.
-	 */
-	spin_lock_irq(&device->al_lock);
-	count = drbd_bm_count_bits(device, sbnr, ebnr);
-	if (count) {
-		device->rs_failed += count;
-
-		if (get_ldev(device)) {
-			drbd_try_clear_on_disk_bm(device, sector, count, false);
-			put_ldev(device);
-		}
-
-		/* just wake_up unconditional now, various lc_chaged(),
-		 * lc_put() in drbd_try_clear_on_disk_bm(). */
-		wake_up = 1;
-	}
-	spin_unlock_irq(&device->al_lock);
-	if (wake_up)
-		wake_up(&device->al_wait);
-}
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index eb002a7..a16f9ae 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -432,7 +432,11 @@ enum {
 				 * goes into C_CONNECTED state. */
 	CONSIDER_RESYNC,
 
+	RS_PROGRESS,		/* tell worker that resync made significant progress */
+	RS_DONE,		/* tell worker that resync is done */
+
 	MD_NO_FUA,		/* Users wants us to not use FUA/FLUSH on meta data dev */
+
 	SUSPEND_IO,		/* suspend application io */
 	BITMAP_IO,		/* suspend application io;
 				   once no more io in flight, start bitmap io */
@@ -577,6 +581,7 @@ enum {
 				 * and potentially deadlock on, this drbd worker.
 				 */
 	DISCONNECT_SENT,
+	CONN_RS_PROGRESS,	/* tell worker that resync made significant progress */
 };
 
 struct drbd_resource {
@@ -1106,17 +1111,21 @@ struct bm_extent {
 /* in which _bitmap_ extent (resp. sector) the bit for a certain
  * _storage_ sector is located in */
 #define BM_SECT_TO_EXT(x)   ((x)>>(BM_EXT_SHIFT-9))
+#define BM_BIT_TO_EXT(x)    ((x) >> (BM_EXT_SHIFT - BM_BLOCK_SHIFT))
 
-/* how much _storage_ sectors we have per bitmap sector */
+/* first storage sector a bitmap extent corresponds to */
 #define BM_EXT_TO_SECT(x)   ((sector_t)(x) << (BM_EXT_SHIFT-9))
+/* how much _storage_ sectors we have per bitmap extent */
 #define BM_SECT_PER_EXT     BM_EXT_TO_SECT(1)
+/* how many bits are covered by one bitmap extent (resync extent) */
+#define BM_BITS_PER_EXT     (1UL << (BM_EXT_SHIFT - BM_BLOCK_SHIFT))
+
+#define BM_BLOCKS_PER_BM_EXT_MASK  (BM_BITS_PER_EXT - 1)
+
 
 /* in one sector of the bitmap, we have this many activity_log extents. */
 #define AL_EXT_PER_BM_SECT  (1 << (BM_EXT_SHIFT - AL_EXTENT_SHIFT))
 
-#define BM_BLOCKS_PER_BM_EXT_B (BM_EXT_SHIFT - BM_BLOCK_SHIFT)
-#define BM_BLOCKS_PER_BM_EXT_MASK  ((1<<BM_BLOCKS_PER_BM_EXT_B) - 1)
-
 /* the extent in "PER_EXTENT" below is an activity log extent
  * we need that many (long words/bytes) to store the bitmap
  *		     of one AL_EXTENT_SIZE chunk of storage.
@@ -1214,7 +1223,6 @@ extern unsigned long _drbd_bm_find_next(struct drbd_device *device, unsigned lon
 extern unsigned long _drbd_bm_find_next_zero(struct drbd_device *device, unsigned long bm_fo);
 extern unsigned long _drbd_bm_total_weight(struct drbd_device *device);
 extern unsigned long drbd_bm_total_weight(struct drbd_device *device);
-extern int drbd_bm_rs_done(struct drbd_device *device);
 /* for receive_bitmap */
 extern void drbd_bm_merge_lel(struct drbd_device *device, size_t offset,
 		size_t number, unsigned long *buffer);
@@ -1503,14 +1511,17 @@ extern int drbd_rs_del_all(struct drbd_device *device);
 extern void drbd_rs_failed_io(struct drbd_device *device,
 		sector_t sector, int size);
 extern void drbd_advance_rs_marks(struct drbd_device *device, unsigned long still_to_go);
-extern void __drbd_set_in_sync(struct drbd_device *device, sector_t sector,
-		int size, const char *file, const unsigned int line);
+
+enum update_sync_bits_mode { RECORD_RS_FAILED, SET_OUT_OF_SYNC, SET_IN_SYNC };
+extern int __drbd_change_sync(struct drbd_device *device, sector_t sector, int size,
+		enum update_sync_bits_mode mode,
+		const char *file, const unsigned int line);
 #define drbd_set_in_sync(device, sector, size) \
-	__drbd_set_in_sync(device, sector, size, __FILE__, __LINE__)
-extern int __drbd_set_out_of_sync(struct drbd_device *device, sector_t sector,
-		int size, const char *file, const unsigned int line);
+	__drbd_change_sync(device, sector, size, SET_IN_SYNC, __FILE__, __LINE__)
 #define drbd_set_out_of_sync(device, sector, size) \
-	__drbd_set_out_of_sync(device, sector, size, __FILE__, __LINE__)
+	__drbd_change_sync(device, sector, size, SET_OUT_OF_SYNC, __FILE__, __LINE__)
+#define drbd_rs_failed_io(device, sector, size) \
+	__drbd_change_sync(device, sector, size, RECORD_RS_FAILED, __FILE__, __LINE__)
 extern void drbd_al_shrink(struct drbd_device *device);
 extern int drbd_initialize_al(struct drbd_device *, void *);
 
@@ -1915,6 +1926,15 @@ static inline void _sub_unacked(struct drbd_device *device, int n, const char *f
 	ERR_IF_CNT_IS_NEGATIVE(unacked_cnt, func, line);
 }
 
+static inline bool is_sync_state(enum drbd_conns connection_state)
+{
+	return
+	   (connection_state == C_SYNC_SOURCE
+	||  connection_state == C_SYNC_TARGET
+	||  connection_state == C_PAUSED_SYNC_S
+	||  connection_state == C_PAUSED_SYNC_T);
+}
+
 /**
  * get_ldev() - Increase the ref count on device->ldev. Returns 0 if there is no ldev
  * @M:		DRBD device.
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 19da7c7..1bddd6c 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1011,6 +1011,9 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 		atomic_inc(&device->local_cnt);
 
 	did_remote = drbd_should_do_remote(device->state);
+	if (!is_sync_state(os.conn) && is_sync_state(ns.conn))
+		clear_bit(RS_DONE, &device->flags);
+
 	device->state.i = ns.i;
 	should_do_remote = drbd_should_do_remote(device->state);
 	device->resource->susp = ns.susp;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 47bc840..bafb62e 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1740,11 +1740,20 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 			device->rs_mark_time[i] = now;
 		}
 		_drbd_pause_after(device);
+		/* Forget potentially stale cached per resync extent bit-counts.
+		 * Open coded drbd_rs_cancel_all(device), we already have IRQs
+		 * disabled, and know the disk state is ok. */
+		spin_lock(&device->al_lock);
+		lc_reset(device->resync);
+		device->resync_locked = 0;
+		device->resync_wenr = LC_FREE;
+		spin_unlock(&device->al_lock);
 	}
 	write_unlock(&global_state_lock);
 	spin_unlock_irq(&device->resource->req_lock);
 
 	if (r == SS_SUCCESS) {
+		wake_up(&device->al_wait); /* for lc_reset() above */
 		/* reset rs_last_bcast when a resync or verify is started,
 		 * to deal with potential jiffies wrap. */
 		device->rs_last_bcast = jiffies - HZ;
@@ -1807,36 +1816,22 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 static void update_on_disk_bitmap(struct drbd_device *device)
 {
 	struct sib_info sib = { .sib_reason = SIB_SYNC_PROGRESS, };
+	bool resync_done = test_and_clear_bit(RS_DONE, &device->flags);
 	device->rs_last_bcast = jiffies;
 
 	if (!get_ldev(device))
 		return;
 
 	drbd_bm_write_lazy(device, 0);
-	if (drbd_bm_total_weight(device) <= device->rs_failed)
+	if (resync_done && is_sync_state(device->state.conn))
 		drbd_resync_finished(device);
+
 	drbd_bcast_event(device, &sib);
 	/* update timestamp, in case it took a while to write out stuff */
 	device->rs_last_bcast = jiffies;
 	put_ldev(device);
 }
 
-bool wants_lazy_bitmap_update(struct drbd_device *device)
-{
-	enum drbd_conns connection_state = device->state.conn;
-	return
-	/* only do a lazy writeout, if device is in some resync state */
-	   (connection_state == C_SYNC_SOURCE
-	||  connection_state == C_SYNC_TARGET
-	||  connection_state == C_PAUSED_SYNC_S
-	||  connection_state == C_PAUSED_SYNC_T) &&
-	/* AND
-	 * either we just finished, or the last lazy update
-	 * was some time ago already. */
-	   (drbd_bm_total_weight(device) <= device->rs_failed
-	||  time_after(jiffies, device->rs_last_bcast + 2*HZ));
-}
-
 static void try_update_all_on_disk_bitmaps(struct drbd_connection *connection)
 {
 	struct drbd_peer_device *peer_device;
@@ -1845,8 +1840,9 @@ static void try_update_all_on_disk_bitmaps(struct drbd_connection *connection)
 	rcu_read_lock();
 	idr_for_each_entry(&connection->peer_devices, peer_device, vnr) {
 		struct drbd_device *device = peer_device->device;
-		if (!wants_lazy_bitmap_update(device))
+		if (!test_and_clear_bit(RS_PROGRESS, &device->flags))
 			continue;
+
 		kref_get(&device->kref);
 		rcu_read_unlock();
 		update_on_disk_bitmap(device);
@@ -1930,15 +1926,18 @@ static void wait_for_work(struct drbd_connection *connection, struct list_head *
 		if (send_barrier)
 			maybe_send_barrier(connection,
 					connection->send.current_epoch_nr + 1);
+
+		if (test_bit(CONN_RS_PROGRESS, &connection->flags))
+			break;
+
 		/* drbd_send() may have called flush_signals() */
 		if (get_t_state(&connection->worker) != RUNNING)
 			break;
+
 		schedule();
 		/* may be woken up for other things but new work, too,
 		 * e.g. if the current epoch got closed.
 		 * In which case we send the barrier above. */
-
-		try_update_all_on_disk_bitmaps(connection);
 	}
 	finish_wait(&connection->sender_work.q_wait, &wait);
 
@@ -1973,6 +1972,9 @@ int drbd_worker(struct drbd_thread *thi)
 		if (list_empty(&work_list))
 			wait_for_work(connection, &work_list);
 
+		if (test_and_clear_bit(CONN_RS_PROGRESS, &connection->flags))
+			try_update_all_on_disk_bitmaps(connection);
+
 		if (signal_pending(current)) {
 			flush_signals(current);
 			if (get_t_state(thi) == RUNNING) {
-- 
1.9.1

