Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3LTMlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:41:37 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38635 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3LTMjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:35 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 19/26] drbd: Remove the terrible DEV hack
Date: Fri, 20 Dec 2013 13:29:16 +0100
Message-Id: <1387542563-6833-20-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

DRBD was using dev_err() and similar all over the code; instead of having to
write dev_err(disk_to_dev(device->vdisk), ...) to convert a drbd_device into a
kernel device, a DEV macro was used which implicitly references the device
variable.  This is terrible; introduce separate drbd_err() and similar macros
with an explicit device parameter instead.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |   54 +++++------
 drivers/block/drbd/drbd_bitmap.c   |   58 ++++++------
 drivers/block/drbd/drbd_int.h      |   39 +++++---
 drivers/block/drbd/drbd_main.c     |   62 ++++++-------
 drivers/block/drbd/drbd_nl.c       |   74 +++++++--------
 drivers/block/drbd/drbd_receiver.c |  180 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_req.c      |   28 +++---
 drivers/block/drbd/drbd_state.c    |   30 +++---
 drivers/block/drbd/drbd_worker.c   |   56 +++++------
 9 files changed, 298 insertions(+), 283 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 5553219..c54cdea 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -137,7 +137,7 @@ void wait_until_done_or_force_detached(struct drbd_device *device, struct drbd_b
 	dt = wait_event_timeout(device->misc_wait,
 			*done || test_bit(FORCE_DETACH, &device->flags), dt);
 	if (dt == 0) {
-		dev_err(DEV, "meta-data IO operation timed out\n");
+		drbd_err(device, "meta-data IO operation timed out\n");
 		drbd_chk_io_error(device, 1, DRBD_FORCE_DETACH);
 	}
 }
@@ -172,7 +172,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 		;
 	else if (!get_ldev_if_state(device, D_ATTACHING)) {
 		/* Corresponding put_ldev in drbd_md_io_complete() */
-		dev_err(DEV, "ASSERT FAILED: get_ldev_if_state() == 1 in _drbd_md_sync_page_io()\n");
+		drbd_err(device, "ASSERT FAILED: get_ldev_if_state() == 1 in _drbd_md_sync_page_io()\n");
 		err = -ENODEV;
 		goto out;
 	}
@@ -202,21 +202,21 @@ int drbd_md_sync_page_io(struct drbd_device *device, struct drbd_backing_dev *bd
 
 	BUG_ON(!bdev->md_bdev);
 
-	dev_dbg(DEV, "meta_data io: %s [%d]:%s(,%llus,%s) %pS\n",
+	drbd_dbg(device, "meta_data io: %s [%d]:%s(,%llus,%s) %pS\n",
 	     current->comm, current->pid, __func__,
 	     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ",
 	     (void*)_RET_IP_ );
 
 	if (sector < drbd_md_first_sector(bdev) ||
 	    sector + 7 > drbd_md_last_sector(bdev))
-		dev_alert(DEV, "%s [%d]:%s(,%llus,%s) out of range md access!\n",
+		drbd_alert(device, "%s [%d]:%s(,%llus,%s) out of range md access!\n",
 		     current->comm, current->pid, __func__,
 		     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
 
 	/* we do all our meta data IO in aligned 4k blocks. */
 	err = _drbd_md_sync_page_io(device, bdev, iop, sector, rw, 4096);
 	if (err) {
-		dev_err(DEV, "drbd_md_sync_page_io(,%llus,%s) failed with error %d\n",
+		drbd_err(device, "drbd_md_sync_page_io(,%llus,%s) failed with error %d\n",
 		    (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ", err);
 	}
 	return err;
@@ -403,7 +403,7 @@ int drbd_al_begin_io_nonblock(struct drbd_device *device, struct drbd_interval *
 		struct lc_element *al_ext;
 		al_ext = lc_get_cumulative(device->act_log, enr);
 		if (!al_ext)
-			dev_info(DEV, "LOGIC BUG for enr=%u\n", enr);
+			drbd_info(device, "LOGIC BUG for enr=%u\n", enr);
 	}
 	return 0;
 }
@@ -424,7 +424,7 @@ void drbd_al_complete_io(struct drbd_device *device, struct drbd_interval *i)
 	for (enr = first; enr <= last; enr++) {
 		extent = lc_find(device->act_log, enr);
 		if (!extent) {
-			dev_err(DEV, "al_complete_io() called on inactive extent %u\n", enr);
+			drbd_err(device, "al_complete_io() called on inactive extent %u\n", enr);
 			continue;
 		}
 		lc_put(device->act_log, extent);
@@ -490,14 +490,14 @@ _al_write_transaction(struct drbd_device *device)
 	int err = 0;
 
 	if (!get_ldev(device)) {
-		dev_err(DEV, "disk is %s, cannot start al transaction\n",
+		drbd_err(device, "disk is %s, cannot start al transaction\n",
 			drbd_disk_str(device->state.disk));
 		return -EIO;
 	}
 
 	/* The bitmap write may have failed, causing a state change. */
 	if (device->state.disk < D_INCONSISTENT) {
-		dev_err(DEV,
+		drbd_err(device,
 			"disk is %s, cannot write al transaction\n",
 			drbd_disk_str(device->state.disk));
 		put_ldev(device);
@@ -506,7 +506,7 @@ _al_write_transaction(struct drbd_device *device)
 
 	buffer = drbd_md_get_buffer(device); /* protects md_io_buffer, al_tr_cycle, ... */
 	if (!buffer) {
-		dev_err(DEV, "disk failed while waiting for md_io buffer\n");
+		drbd_err(device, "disk failed while waiting for md_io buffer\n");
 		put_ldev(device);
 		return -ENODEV;
 	}
@@ -688,7 +688,7 @@ static int w_update_odbm(struct drbd_work *w, int unused)
 
 	if (!get_ldev(device)) {
 		if (__ratelimit(&drbd_ratelimit_state))
-			dev_warn(DEV, "Can not update on disk bitmap, local IO disabled.\n");
+			drbd_warn(device, "Can not update on disk bitmap, local IO disabled.\n");
 		kfree(udw);
 		return 0;
 	}
@@ -743,7 +743,7 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *device, sector_t secto
 			else
 				ext->rs_failed += count;
 			if (ext->rs_left < ext->rs_failed) {
-				dev_warn(DEV, "BAD! sector=%llus enr=%u rs_left=%d "
+				drbd_warn(device, "BAD! sector=%llus enr=%u rs_left=%d "
 				    "rs_failed=%d count=%d cstate=%s\n",
 				     (unsigned long long)sector,
 				     ext->lce.lc_number, ext->rs_left,
@@ -767,14 +767,14 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *device, sector_t secto
 			 */
 			int rs_left = drbd_bm_e_weight(device, enr);
 			if (ext->flags != 0) {
-				dev_warn(DEV, "changing resync lce: %d[%u;%02lx]"
+				drbd_warn(device, "changing resync lce: %d[%u;%02lx]"
 				     " -> %d[%u;00]\n",
 				     ext->lce.lc_number, ext->rs_left,
 				     ext->flags, enr, rs_left);
 				ext->flags = 0;
 			}
 			if (ext->rs_failed) {
-				dev_warn(DEV, "Kicking resync_lru element enr=%u "
+				drbd_warn(device, "Kicking resync_lru element enr=%u "
 				     "out with rs_failed=%d\n",
 				     ext->lce.lc_number, ext->rs_failed);
 			}
@@ -797,11 +797,11 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *device, sector_t secto
 				udw->w.device = device;
 				drbd_queue_work_front(&first_peer_device(device)->connection->sender_work, &udw->w);
 			} else {
-				dev_warn(DEV, "Could not kmalloc an udw\n");
+				drbd_warn(device, "Could not kmalloc an udw\n");
 			}
 		}
 	} else {
-		dev_err(DEV, "lc_get() failed! locked=%d/%d flags=%lu\n",
+		drbd_err(device, "lc_get() failed! locked=%d/%d flags=%lu\n",
 		    device->resync_locked,
 		    device->resync->nr_elements,
 		    device->resync->flags);
@@ -842,7 +842,7 @@ void __drbd_set_in_sync(struct drbd_device *device, sector_t sector, int size,
 	unsigned long flags;
 
 	if (size <= 0 || !IS_ALIGNED(size, 512) || size > DRBD_MAX_BIO_SIZE) {
-		dev_err(DEV, "drbd_set_in_sync: sector=%llus size=%d nonsense!\n",
+		drbd_err(device, "drbd_set_in_sync: sector=%llus size=%d nonsense!\n",
 				(unsigned long long)sector, size);
 		return;
 	}
@@ -916,7 +916,7 @@ int __drbd_set_out_of_sync(struct drbd_device *device, sector_t sector, int size
 		return 0;
 
 	if (size < 0 || !IS_ALIGNED(size, 512) || size > DRBD_MAX_BIO_SIZE) {
-		dev_err(DEV, "sector: %llus, size: %d\n",
+		drbd_err(device, "sector: %llus, size: %d\n",
 			(unsigned long long)sector, size);
 		return 0;
 	}
@@ -987,7 +987,7 @@ struct bm_extent *_bme_get(struct drbd_device *device, unsigned int enr)
 
 	if (!bm_ext) {
 		if (rs_flags & LC_STARVING)
-			dev_warn(DEV, "Have to wait for element"
+			drbd_warn(device, "Have to wait for element"
 			     " (resync LRU too small?)\n");
 		BUG_ON(rs_flags & LC_LOCKED);
 	}
@@ -1048,7 +1048,7 @@ retry:
 			if (schedule_timeout_interruptible(HZ/10))
 				return -EINTR;
 			if (sa && --sa == 0)
-				dev_warn(DEV,"drbd_rs_begin_io() stepped aside for 20sec."
+				drbd_warn(device, "drbd_rs_begin_io() stepped aside for 20sec."
 					 "Resync stalled?\n");
 			goto retry;
 		}
@@ -1100,7 +1100,7 @@ int drbd_try_rs_begin_io(struct drbd_device *device, sector_t sector)
 				device->resync_locked--;
 			wake_up(&device->al_wait);
 		} else {
-			dev_alert(DEV, "LOGIC BUG\n");
+			drbd_alert(device, "LOGIC BUG\n");
 		}
 	}
 	/* TRY. */
@@ -1130,7 +1130,7 @@ int drbd_try_rs_begin_io(struct drbd_device *device, sector_t sector)
 		if (!bm_ext) {
 			const unsigned long rs_flags = device->resync->flags;
 			if (rs_flags & LC_STARVING)
-				dev_warn(DEV, "Have to wait for element"
+				drbd_warn(device, "Have to wait for element"
 				     " (resync LRU too small?)\n");
 			BUG_ON(rs_flags & LC_LOCKED);
 			goto try_again;
@@ -1178,13 +1178,13 @@ void drbd_rs_complete_io(struct drbd_device *device, sector_t sector)
 	if (!bm_ext) {
 		spin_unlock_irqrestore(&device->al_lock, flags);
 		if (__ratelimit(&drbd_ratelimit_state))
-			dev_err(DEV, "drbd_rs_complete_io() called, but extent not found\n");
+			drbd_err(device, "drbd_rs_complete_io() called, but extent not found\n");
 		return;
 	}
 
 	if (bm_ext->lce.refcnt == 0) {
 		spin_unlock_irqrestore(&device->al_lock, flags);
-		dev_err(DEV, "drbd_rs_complete_io(,%llu [=%u]) called, "
+		drbd_err(device, "drbd_rs_complete_io(,%llu [=%u]) called, "
 		    "but refcnt is 0!?\n",
 		    (unsigned long long)sector, enr);
 		return;
@@ -1240,7 +1240,7 @@ int drbd_rs_del_all(struct drbd_device *device)
 			if (bm_ext->lce.lc_number == LC_FREE)
 				continue;
 			if (bm_ext->lce.lc_number == device->resync_wenr) {
-				dev_info(DEV, "dropping %u in drbd_rs_del_all, apparently"
+				drbd_info(device, "dropping %u in drbd_rs_del_all, apparently"
 				     " got 'synced' by application io\n",
 				     device->resync_wenr);
 				D_ASSERT(!test_bit(BME_LOCKED, &bm_ext->flags));
@@ -1250,7 +1250,7 @@ int drbd_rs_del_all(struct drbd_device *device)
 				lc_put(device->resync, &bm_ext->lce);
 			}
 			if (bm_ext->lce.refcnt != 0) {
-				dev_info(DEV, "Retrying drbd_rs_del_all() later. "
+				drbd_info(device, "Retrying drbd_rs_del_all() later. "
 				     "refcnt=%d\n", bm_ext->lce.refcnt);
 				put_ldev(device);
 				spin_unlock_irq(&device->al_lock);
@@ -1284,7 +1284,7 @@ void drbd_rs_failed_io(struct drbd_device *device, sector_t sector, int size)
 	int wake_up = 0;
 
 	if (size <= 0 || !IS_ALIGNED(size, 512) || size > DRBD_MAX_BIO_SIZE) {
-		dev_err(DEV, "drbd_rs_failed_io: sector=%llus size=%d nonsense!\n",
+		drbd_err(device, "drbd_rs_failed_io: sector=%llus size=%d nonsense!\n",
 				(unsigned long long)sector, size);
 		return;
 	}
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index bc66d2a..81626b9 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -118,7 +118,7 @@ static void __bm_print_lock_info(struct drbd_device *device, const char *func)
 	struct drbd_bitmap *b = device->bitmap;
 	if (!__ratelimit(&drbd_ratelimit_state))
 		return;
-	dev_err(DEV, "FIXME %s in %s, bitmap locked for '%s' by %s\n",
+	drbd_err(device, "FIXME %s in %s, bitmap locked for '%s' by %s\n",
 		drbd_task_to_thread_name(first_peer_device(device)->connection, current),
 		func, b->bm_why ?: "?",
 		drbd_task_to_thread_name(first_peer_device(device)->connection, b->bm_task));
@@ -130,21 +130,21 @@ void drbd_bm_lock(struct drbd_device *device, char *why, enum bm_flag flags)
 	int trylock_failed;
 
 	if (!b) {
-		dev_err(DEV, "FIXME no bitmap in drbd_bm_lock!?\n");
+		drbd_err(device, "FIXME no bitmap in drbd_bm_lock!?\n");
 		return;
 	}
 
 	trylock_failed = !mutex_trylock(&b->bm_change);
 
 	if (trylock_failed) {
-		dev_warn(DEV, "%s going to '%s' but bitmap already locked for '%s' by %s\n",
+		drbd_warn(device, "%s going to '%s' but bitmap already locked for '%s' by %s\n",
 			 drbd_task_to_thread_name(first_peer_device(device)->connection, current),
 			 why, b->bm_why ?: "?",
 			 drbd_task_to_thread_name(first_peer_device(device)->connection, b->bm_task));
 		mutex_lock(&b->bm_change);
 	}
 	if (BM_LOCKED_MASK & b->bm_flags)
-		dev_err(DEV, "FIXME bitmap already locked in bm_lock\n");
+		drbd_err(device, "FIXME bitmap already locked in bm_lock\n");
 	b->bm_flags |= flags & BM_LOCKED_MASK;
 
 	b->bm_why  = why;
@@ -155,12 +155,12 @@ void drbd_bm_unlock(struct drbd_device *device)
 {
 	struct drbd_bitmap *b = device->bitmap;
 	if (!b) {
-		dev_err(DEV, "FIXME no bitmap in drbd_bm_unlock!?\n");
+		drbd_err(device, "FIXME no bitmap in drbd_bm_unlock!?\n");
 		return;
 	}
 
 	if (!(BM_LOCKED_MASK & device->bitmap->bm_flags))
-		dev_err(DEV, "FIXME bitmap not locked in bm_unlock\n");
+		drbd_err(device, "FIXME bitmap not locked in bm_unlock\n");
 
 	b->bm_flags &= ~BM_LOCKED_MASK;
 	b->bm_why  = NULL;
@@ -253,7 +253,7 @@ void drbd_bm_mark_for_writeout(struct drbd_device *device, int page_nr)
 {
 	struct page *page;
 	if (page_nr >= device->bitmap->bm_number_of_pages) {
-		dev_warn(DEV, "BAD: page_nr: %u, number_of_pages: %u\n",
+		drbd_warn(device, "BAD: page_nr: %u, number_of_pages: %u\n",
 			 page_nr, (int)device->bitmap->bm_number_of_pages);
 		return;
 	}
@@ -645,7 +645,7 @@ int drbd_bm_resize(struct drbd_device *device, sector_t capacity, int set_new_bi
 
 	drbd_bm_lock(device, "resize", BM_LOCKED_MASK);
 
-	dev_info(DEV, "drbd_bm_resize called with capacity == %llu\n",
+	drbd_info(device, "drbd_bm_resize called with capacity == %llu\n",
 			(unsigned long long)capacity);
 
 	if (capacity == b->bm_dev_capacity)
@@ -682,8 +682,8 @@ int drbd_bm_resize(struct drbd_device *device, sector_t capacity, int set_new_bi
 		u64 bits_on_disk = drbd_md_on_disk_bits(device->ldev);
 		put_ldev(device);
 		if (bits > bits_on_disk) {
-			dev_info(DEV, "bits = %lu\n", bits);
-			dev_info(DEV, "bits_on_disk = %llu\n", bits_on_disk);
+			drbd_info(device, "bits = %lu\n", bits);
+			drbd_info(device, "bits_on_disk = %llu\n", bits_on_disk);
 			err = -ENOSPC;
 			goto out;
 		}
@@ -742,7 +742,7 @@ int drbd_bm_resize(struct drbd_device *device, sector_t capacity, int set_new_bi
 		bm_vk_free(opages, opages_vmalloced);
 	if (!growing)
 		b->bm_set = bm_count_bits(b);
-	dev_info(DEV, "resync bitmap: bits=%lu words=%lu pages=%lu\n", bits, words, want);
+	drbd_info(device, "resync bitmap: bits=%lu words=%lu pages=%lu\n", bits, words, want);
 
  out:
 	drbd_bm_unlock(device);
@@ -878,7 +878,7 @@ void drbd_bm_get_lel(struct drbd_device *device, size_t offset, size_t number,
 	if ((offset >= b->bm_words) ||
 	    (end    >  b->bm_words) ||
 	    (number <= 0))
-		dev_err(DEV, "offset=%lu number=%lu bm_words=%lu\n",
+		drbd_err(device, "offset=%lu number=%lu bm_words=%lu\n",
 			(unsigned long)	offset,
 			(unsigned long)	number,
 			(unsigned long) b->bm_words);
@@ -966,7 +966,7 @@ static void bm_async_io_complete(struct bio *bio, int error)
 
 	if ((ctx->flags & BM_AIO_COPY_PAGES) == 0 &&
 	    !bm_test_page_unchanged(b->bm_pages[idx]))
-		dev_warn(DEV, "bitmap page idx %u changed during IO!\n", idx);
+		drbd_warn(device, "bitmap page idx %u changed during IO!\n", idx);
 
 	if (error) {
 		/* ctx error will hold the completed-last non-zero error code,
@@ -976,11 +976,11 @@ static void bm_async_io_complete(struct bio *bio, int error)
 		/* Not identical to on disk version of it.
 		 * Is BM_PAGE_IO_ERROR enough? */
 		if (__ratelimit(&drbd_ratelimit_state))
-			dev_err(DEV, "IO ERROR %d on bitmap page idx %u\n",
+			drbd_err(device, "IO ERROR %d on bitmap page idx %u\n",
 					error, idx);
 	} else {
 		bm_clear_page_io_err(b->bm_pages[idx]);
-		dynamic_dev_dbg(DEV, "bitmap page idx %u completed\n", idx);
+		dynamic_drbd_dbg(device, "bitmap page idx %u completed\n", idx);
 	}
 
 	bm_page_unlock_io(device, idx);
@@ -1081,7 +1081,7 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
 	};
 
 	if (!get_ldev_if_state(device, D_ATTACHING)) {  /* put is in bm_aio_ctx_destroy() */
-		dev_err(DEV, "ASSERT FAILED: get_ldev_if_state() == 1 in bm_rw()\n");
+		drbd_err(device, "ASSERT FAILED: get_ldev_if_state() == 1 in bm_rw()\n");
 		kfree(ctx);
 		return -ENODEV;
 	}
@@ -1106,14 +1106,14 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
 
 			if (!(flags & BM_WRITE_ALL_PAGES) &&
 			    bm_test_page_unchanged(b->bm_pages[i])) {
-				dynamic_dev_dbg(DEV, "skipped bm write for idx %u\n", i);
+				dynamic_drbd_dbg(device, "skipped bm write for idx %u\n", i);
 				continue;
 			}
 			/* during lazy writeout,
 			 * ignore those pages not marked for lazy writeout. */
 			if (lazy_writeout_upper_idx &&
 			    !bm_test_page_lazy_writeout(b->bm_pages[i])) {
-				dynamic_dev_dbg(DEV, "skipped bm lazy write for idx %u\n", i);
+				dynamic_drbd_dbg(device, "skipped bm lazy write for idx %u\n", i);
 				continue;
 			}
 		}
@@ -1138,12 +1138,12 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
 
 	/* summary for global bitmap IO */
 	if (flags == 0)
-		dev_info(DEV, "bitmap %s of %u pages took %lu jiffies\n",
+		drbd_info(device, "bitmap %s of %u pages took %lu jiffies\n",
 			 rw == WRITE ? "WRITE" : "READ",
 			 count, jiffies - now);
 
 	if (ctx->error) {
-		dev_alert(DEV, "we had at least one MD IO ERROR during bitmap IO\n");
+		drbd_alert(device, "we had at least one MD IO ERROR during bitmap IO\n");
 		drbd_chk_io_error(device, 1, DRBD_META_IO_ERROR);
 		err = -EIO; /* ctx->error ? */
 	}
@@ -1156,13 +1156,13 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
 		drbd_md_flush(device);
 	} else /* rw == READ */ {
 		b->bm_set = bm_count_bits(b);
-		dev_info(DEV, "recounting of set bits took additional %lu jiffies\n",
+		drbd_info(device, "recounting of set bits took additional %lu jiffies\n",
 		     jiffies - now);
 	}
 	now = b->bm_set;
 
 	if (flags == 0)
-		dev_info(DEV, "%s (%lu bits) marked out-of-sync by on disk bit-map.\n",
+		drbd_info(device, "%s (%lu bits) marked out-of-sync by on disk bit-map.\n",
 		     ppsize(ppb, now << (BM_BLOCK_SHIFT-10)), now);
 
 	kref_put(&ctx->kref, &bm_aio_ctx_destroy);
@@ -1253,7 +1253,7 @@ int drbd_bm_write_page(struct drbd_device *device, unsigned int idx) __must_hold
 	int err;
 
 	if (bm_test_page_unchanged(device->bitmap->bm_pages[idx])) {
-		dynamic_dev_dbg(DEV, "skipped bm page write for idx %u\n", idx);
+		dynamic_drbd_dbg(device, "skipped bm page write for idx %u\n", idx);
 		return 0;
 	}
 
@@ -1271,7 +1271,7 @@ int drbd_bm_write_page(struct drbd_device *device, unsigned int idx) __must_hold
 	};
 
 	if (!get_ldev_if_state(device, D_ATTACHING)) {  /* put is in bm_aio_ctx_destroy() */
-		dev_err(DEV, "ASSERT FAILED: get_ldev_if_state() == 1 in drbd_bm_write_page()\n");
+		drbd_err(device, "ASSERT FAILED: get_ldev_if_state() == 1 in drbd_bm_write_page()\n");
 		kfree(ctx);
 		return -ENODEV;
 	}
@@ -1308,7 +1308,7 @@ static unsigned long __bm_find_next(struct drbd_device *device, unsigned long bm
 
 
 	if (bm_fo > b->bm_bits) {
-		dev_err(DEV, "bm_fo=%lu bm_bits=%lu\n", bm_fo, b->bm_bits);
+		drbd_err(device, "bm_fo=%lu bm_bits=%lu\n", bm_fo, b->bm_bits);
 		bm_fo = DRBD_END_OF_BITMAP;
 	} else {
 		while (bm_fo < b->bm_bits) {
@@ -1403,7 +1403,7 @@ static int __bm_change_bits_to(struct drbd_device *device, const unsigned long s
 	int changed_total = 0;
 
 	if (e >= b->bm_bits) {
-		dev_err(DEV, "ASSERT FAILED: bit_s=%lu bit_e=%lu bm_bits=%lu\n",
+		drbd_err(device, "ASSERT FAILED: bit_s=%lu bit_e=%lu bm_bits=%lu\n",
 				s, e, b->bm_bits);
 		e = b->bm_bits ? b->bm_bits -1 : 0;
 	}
@@ -1606,7 +1606,7 @@ int drbd_bm_test_bit(struct drbd_device *device, const unsigned long bitnr)
 	} else if (bitnr == b->bm_bits) {
 		i = -1;
 	} else { /* (bitnr > b->bm_bits) */
-		dev_err(DEV, "bitnr=%lu > bm_bits=%lu\n", bitnr, b->bm_bits);
+		drbd_err(device, "bitnr=%lu > bm_bits=%lu\n", bitnr, b->bm_bits);
 		i = 0;
 	}
 
@@ -1647,7 +1647,7 @@ int drbd_bm_count_bits(struct drbd_device *device, const unsigned long s, const
 		if (expect(bitnr < b->bm_bits))
 			c += (0 != test_bit_le(bitnr - (page_nr << (PAGE_SHIFT+3)), p_addr));
 		else
-			dev_err(DEV, "bitnr=%lu bm_bits=%lu\n", bitnr, b->bm_bits);
+			drbd_err(device, "bitnr=%lu bm_bits=%lu\n", bitnr, b->bm_bits);
 	}
 	if (p_addr)
 		bm_unmap(p_addr);
@@ -1697,7 +1697,7 @@ int drbd_bm_e_weight(struct drbd_device *device, unsigned long enr)
 			count += hweight_long(*bm++);
 		bm_unmap(p_addr);
 	} else {
-		dev_err(DEV, "start offset (%d) too large in drbd_bm_e_weight\n", s);
+		drbd_err(device, "start offset (%d) too large in drbd_bm_e_weight\n", s);
 	}
 	spin_unlock_irqrestore(&b->bm_lock, flags);
 	return count;
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 8b263a9..50a68e1 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -99,9 +99,24 @@ extern char usermode_helper[];
 struct drbd_device;
 struct drbd_connection;
 
-
-/* to shorten dev_warn(DEV, "msg"); and relatives statements */
-#define DEV (disk_to_dev(device->vdisk))
+#define drbd_printk(level, device, fmt, args...) \
+	dev_printk(level, disk_to_dev(device->vdisk), fmt, ## args)
+
+#define drbd_dbg(device, fmt, args...) \
+	drbd_printk(KERN_DEBUG, device, fmt, ## args)
+#define drbd_alert(device, fmt, args...) \
+	drbd_printk(KERN_ALERT, device, fmt, ## args)
+#define drbd_err(device, fmt, args...) \
+	drbd_printk(KERN_ERR, device, fmt, ## args)
+#define drbd_warn(device, fmt, args...) \
+	drbd_printk(KERN_WARNING, device, fmt, ## args)
+#define drbd_info(device, fmt, args...) \
+	drbd_printk(KERN_INFO, device, fmt, ## args)
+#define drbd_emerg(device, fmt, args...) \
+	drbd_printk(KERN_EMERG, device, fmt, ## args)
+
+#define dynamic_drbd_dbg(device, fmt, args...) \
+	dynamic_dev_dbg(disk_to_dev(device->vdisk), fmt, ## args)
 
 #define conn_printk(LEVEL, TCONN, FMT, ARGS...) \
 	printk(LEVEL "d-con %s: " FMT, TCONN->resource->name , ## ARGS)
@@ -114,7 +129,7 @@ struct drbd_connection;
 #define conn_dbg(TCONN, FMT, ARGS...)    conn_printk(KERN_DEBUG, TCONN, FMT, ## ARGS)
 
 #define D_ASSERT(exp)	if (!(exp)) \
-	 dev_err(DEV, "ASSERT( " #exp " ) in %s:%d\n", __FILE__, __LINE__)
+	 drbd_err(device, "ASSERT( " #exp " ) in %s:%d\n", __FILE__, __LINE__)
 
 /**
  * expect  -  Make an assertion
@@ -124,7 +139,7 @@ struct drbd_connection;
 #define expect(exp) ({								\
 		bool _bool = (exp);						\
 		if (!_bool)							\
-			dev_err(DEV, "ASSERTION %s FAILED in %s\n",		\
+			drbd_err(device, "ASSERTION %s FAILED in %s\n",		\
 			        #exp, __func__);				\
 		_bool;								\
 		})
@@ -1273,7 +1288,7 @@ extern void drbd_rs_controller_reset(struct drbd_device *device);
 static inline void ov_out_of_sync_print(struct drbd_device *device)
 {
 	if (device->ov_last_oos_size) {
-		dev_err(DEV, "Out of sync: start=%llu, size=%lu (sectors)\n",
+		drbd_err(device, "Out of sync: start=%llu, size=%lu (sectors)\n",
 		     (unsigned long long)device->ov_last_oos_start,
 		     (unsigned long)device->ov_last_oos_size);
 	}
@@ -1499,7 +1514,7 @@ static inline void __drbd_chk_io_error_(struct drbd_device *device,
 	case EP_PASS_ON: /* FIXME would this be better named "Ignore"? */
 		if (df == DRBD_READ_ERROR || df == DRBD_WRITE_ERROR) {
 			if (__ratelimit(&drbd_ratelimit_state))
-				dev_err(DEV, "Local IO failed in %s.\n", where);
+				drbd_err(device, "Local IO failed in %s.\n", where);
 			if (device->state.disk > D_INCONSISTENT)
 				_drbd_set_state(_NS(device, disk, D_INCONSISTENT), CS_HARD, NULL);
 			break;
@@ -1534,7 +1549,7 @@ static inline void __drbd_chk_io_error_(struct drbd_device *device,
 			set_bit(FORCE_DETACH, &device->flags);
 		if (device->state.disk > D_FAILED) {
 			_drbd_set_state(_NS(device, disk, D_FAILED), CS_HARD, NULL);
-			dev_err(DEV,
+			drbd_err(device,
 				"Local IO failed in %s. Detaching...\n", where);
 		}
 		break;
@@ -1750,7 +1765,7 @@ static inline void inc_ap_pending(struct drbd_device *device)
 
 #define ERR_IF_CNT_IS_NEGATIVE(which, func, line)			\
 	if (atomic_read(&device->which) < 0)				\
-		dev_err(DEV, "in %s:%d: " #which " = %d < 0 !\n",	\
+		drbd_err(device, "in %s:%d: " #which " = %d < 0 !\n",	\
 			func, line,					\
 			atomic_read(&device->which))
 
@@ -1883,7 +1898,7 @@ static inline void drbd_get_syncer_progress(struct drbd_device *device,
 		 * for now, just prevent in-kernel buffer overflow.
 		 */
 		smp_rmb();
-		dev_warn(DEV, "cs:%s rs_left=%lu > rs_total=%lu (rs_failed %lu)\n",
+		drbd_warn(device, "cs:%s rs_left=%lu > rs_total=%lu (rs_failed %lu)\n",
 				drbd_conn_str(device->state.conn),
 				*bits_left, device->rs_total, device->rs_failed);
 		*per_mil_done = 0;
@@ -2098,7 +2113,7 @@ static inline void drbd_md_flush(struct drbd_device *device)
 	int r;
 
 	if (device->ldev == NULL) {
-		dev_warn(DEV, "device->ldev == NULL in drbd_md_flush\n");
+		drbd_warn(device, "device->ldev == NULL in drbd_md_flush\n");
 		return;
 	}
 
@@ -2108,7 +2123,7 @@ static inline void drbd_md_flush(struct drbd_device *device)
 	r = blkdev_issue_flush(device->ldev->md_bdev, GFP_NOIO, NULL);
 	if (r) {
 		set_bit(MD_NO_FUA, &device->flags);
-		dev_err(DEV, "meta data flush failed with status %d, disabling md-flushes\n", r);
+		drbd_err(device, "meta data flush failed with status %d, disabling md-flushes\n", r);
 	}
 }
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 25b928e..a95c21b 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -873,7 +873,7 @@ void drbd_print_uuids(struct drbd_device *device, const char *text)
 {
 	if (get_ldev_if_state(device, D_NEGOTIATING)) {
 		u64 *uuid = device->ldev->md.uuid;
-		dev_info(DEV, "%s %016llX:%016llX:%016llX:%016llX\n",
+		drbd_info(device, "%s %016llX:%016llX:%016llX:%016llX\n",
 		     text,
 		     (unsigned long long)uuid[UI_CURRENT],
 		     (unsigned long long)uuid[UI_BITMAP],
@@ -881,7 +881,7 @@ void drbd_print_uuids(struct drbd_device *device, const char *text)
 		     (unsigned long long)uuid[UI_HISTORY_END]);
 		put_ldev(device);
 	} else {
-		dev_info(DEV, "%s effective data uuid: %016llX\n",
+		drbd_info(device, "%s effective data uuid: %016llX\n",
 				text,
 				(unsigned long long)device->ed_uuid);
 	}
@@ -1128,7 +1128,7 @@ int fill_bitmap_rle_bits(struct drbd_device *device,
 		/* paranoia: catch zero runlength.
 		 * can only happen if bitmap is modified while we scan it. */
 		if (rl == 0) {
-			dev_err(DEV, "unexpected zero runlength while encoding bitmap "
+			drbd_err(device, "unexpected zero runlength while encoding bitmap "
 			    "t:%u bo:%lu\n", toggle, c->bit_offset);
 			return -1;
 		}
@@ -1137,7 +1137,7 @@ int fill_bitmap_rle_bits(struct drbd_device *device,
 		if (bits == -ENOBUFS) /* buffer full */
 			break;
 		if (bits <= 0) {
-			dev_err(DEV, "error while encoding bitmap: %d\n", bits);
+			drbd_err(device, "error while encoding bitmap: %d\n", bits);
 			return 0;
 		}
 
@@ -1240,13 +1240,13 @@ static int _drbd_send_bitmap(struct drbd_device *device)
 
 	if (get_ldev(device)) {
 		if (drbd_md_test_flag(device->ldev, MDF_FULL_SYNC)) {
-			dev_info(DEV, "Writing the whole bitmap, MDF_FullSync was set.\n");
+			drbd_info(device, "Writing the whole bitmap, MDF_FullSync was set.\n");
 			drbd_bm_set_all(device);
 			if (drbd_bm_write(device)) {
 				/* write_bm did fail! Leave full sync flag set in Meta P_DATA
 				 * but otherwise process as per normal - need to tell other
 				 * side that a full resync is required! */
-				dev_err(DEV, "Failed to write bitmap to disk!\n");
+				drbd_err(device, "Failed to write bitmap to disk!\n");
 			} else {
 				drbd_md_clear_flag(device, MDF_FULL_SYNC);
 				drbd_md_sync(device);
@@ -1519,7 +1519,7 @@ static int _drbd_send_page(struct drbd_device *device, struct page *page,
 					break;
 				continue;
 			}
-			dev_warn(DEV, "%s: size=%d len=%d sent=%d\n",
+			drbd_warn(device, "%s: size=%d len=%d sent=%d\n",
 			     __func__, (int)size, len, sent);
 			if (sent < 0)
 				err = sent;
@@ -1665,7 +1665,7 @@ int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 			unsigned char digest[64];
 			drbd_csum_bio(device, first_peer_device(device)->connection->integrity_tfm, req->master_bio, digest);
 			if (memcmp(p + 1, digest, dgs)) {
-				dev_warn(DEV,
+				drbd_warn(device,
 					"Digest mismatch, buffer modified by upper layers during write: %llus +%u\n",
 					(unsigned long long)req->i.sector, req->i.size);
 			}
@@ -1957,7 +1957,7 @@ void drbd_device_cleanup(struct drbd_device *device)
 {
 	int i;
 	if (first_peer_device(device)->connection->receiver.t_state != NONE)
-		dev_err(DEV, "ASSERT FAILED: receiver t_state == %d expected 0.\n",
+		drbd_err(device, "ASSERT FAILED: receiver t_state == %d expected 0.\n",
 				first_peer_device(device)->connection->receiver.t_state);
 
 	device->al_writ_cnt  =
@@ -2142,23 +2142,23 @@ static void drbd_release_all_peer_reqs(struct drbd_device *device)
 
 	rr = drbd_free_peer_reqs(device, &device->active_ee);
 	if (rr)
-		dev_err(DEV, "%d EEs in active list found!\n", rr);
+		drbd_err(device, "%d EEs in active list found!\n", rr);
 
 	rr = drbd_free_peer_reqs(device, &device->sync_ee);
 	if (rr)
-		dev_err(DEV, "%d EEs in sync list found!\n", rr);
+		drbd_err(device, "%d EEs in sync list found!\n", rr);
 
 	rr = drbd_free_peer_reqs(device, &device->read_ee);
 	if (rr)
-		dev_err(DEV, "%d EEs in read list found!\n", rr);
+		drbd_err(device, "%d EEs in read list found!\n", rr);
 
 	rr = drbd_free_peer_reqs(device, &device->done_ee);
 	if (rr)
-		dev_err(DEV, "%d EEs in done list found!\n", rr);
+		drbd_err(device, "%d EEs in done list found!\n", rr);
 
 	rr = drbd_free_peer_reqs(device, &device->net_ee);
 	if (rr)
-		dev_err(DEV, "%d EEs in net list found!\n", rr);
+		drbd_err(device, "%d EEs in net list found!\n", rr);
 }
 
 /* caution. no locking. */
@@ -2239,7 +2239,7 @@ static void do_retry(struct work_struct *ws)
 				(req->rq_state & RQ_LOCAL_ABORTED) != 0);
 
 		if (!expected)
-			dev_err(DEV, "req=%p completion_ref=%d rq_state=%x\n",
+			drbd_err(device, "req=%p completion_ref=%d rq_state=%x\n",
 				req, atomic_read(&req->completion_ref),
 				req->rq_state);
 
@@ -3013,7 +3013,7 @@ void drbd_md_write(struct drbd_device *device, void *b)
 
 	if (drbd_md_sync_page_io(device, device->ldev, sector, WRITE)) {
 		/* this was a try anyways ... */
-		dev_err(DEV, "meta data update failed!\n");
+		drbd_err(device, "meta data update failed!\n");
 		drbd_chk_io_error(device, 1, DRBD_META_IO_ERROR);
 	}
 }
@@ -3095,7 +3095,7 @@ static int check_activity_log_stripe_size(struct drbd_device *device,
 
 	return 0;
 err:
-	dev_err(DEV, "invalid activity log striping: al_stripes=%u, al_stripe_size_4k=%u\n",
+	drbd_err(device, "invalid activity log striping: al_stripes=%u, al_stripe_size_4k=%u\n",
 			al_stripes, al_stripe_size_4k);
 	return -EINVAL;
 }
@@ -3167,7 +3167,7 @@ static int check_offsets_and_sizes(struct drbd_device *device, struct drbd_backi
 	return 0;
 
 err:
-	dev_err(DEV, "meta data offsets don't make sense: idx=%d "
+	drbd_err(device, "meta data offsets don't make sense: idx=%d "
 			"al_s=%u, al_sz4k=%u, al_offset=%d, bm_offset=%d, "
 			"md_size_sect=%u, la_size=%llu, md_capacity=%llu\n",
 			in_core->meta_dev_idx,
@@ -3212,7 +3212,7 @@ int drbd_md_read(struct drbd_device *device, struct drbd_backing_dev *bdev)
 	if (drbd_md_sync_page_io(device, bdev, bdev->md.md_offset, READ)) {
 		/* NOTE: can't do normal error processing here as this is
 		   called BEFORE disk is attached */
-		dev_err(DEV, "Error while reading metadata.\n");
+		drbd_err(device, "Error while reading metadata.\n");
 		rv = ERR_IO_MD_DISK;
 		goto err;
 	}
@@ -3222,7 +3222,7 @@ int drbd_md_read(struct drbd_device *device, struct drbd_backing_dev *bdev)
 	if (magic == DRBD_MD_MAGIC_84_UNCLEAN ||
 	    (magic == DRBD_MD_MAGIC_08 && !(flags & MDF_AL_CLEAN))) {
 			/* btw: that's Activity Log clean, not "all" clean. */
-		dev_err(DEV, "Found unclean meta data. Did you \"drbdadm apply-al\"?\n");
+		drbd_err(device, "Found unclean meta data. Did you \"drbdadm apply-al\"?\n");
 		rv = ERR_MD_UNCLEAN;
 		goto err;
 	}
@@ -3230,14 +3230,14 @@ int drbd_md_read(struct drbd_device *device, struct drbd_backing_dev *bdev)
 	rv = ERR_MD_INVALID;
 	if (magic != DRBD_MD_MAGIC_08) {
 		if (magic == DRBD_MD_MAGIC_07)
-			dev_err(DEV, "Found old (0.7) meta data magic. Did you \"drbdadm create-md\"?\n");
+			drbd_err(device, "Found old (0.7) meta data magic. Did you \"drbdadm create-md\"?\n");
 		else
-			dev_err(DEV, "Meta data magic not found. Did you \"drbdadm create-md\"?\n");
+			drbd_err(device, "Meta data magic not found. Did you \"drbdadm create-md\"?\n");
 		goto err;
 	}
 
 	if (be32_to_cpu(buffer->bm_bytes_per_bit) != BM_BLOCK_SIZE) {
-		dev_err(DEV, "unexpected bm_bytes_per_bit: %u (expected %u)\n",
+		drbd_err(device, "unexpected bm_bytes_per_bit: %u (expected %u)\n",
 		    be32_to_cpu(buffer->bm_bytes_per_bit), BM_BLOCK_SIZE);
 		goto err;
 	}
@@ -3260,12 +3260,12 @@ int drbd_md_read(struct drbd_device *device, struct drbd_backing_dev *bdev)
 		goto err;
 
 	if (be32_to_cpu(buffer->bm_offset) != bdev->md.bm_offset) {
-		dev_err(DEV, "unexpected bm_offset: %d (expected %d)\n",
+		drbd_err(device, "unexpected bm_offset: %d (expected %d)\n",
 		    be32_to_cpu(buffer->bm_offset), bdev->md.bm_offset);
 		goto err;
 	}
 	if (be32_to_cpu(buffer->md_size_sect) != bdev->md.md_size_sect) {
-		dev_err(DEV, "unexpected md_size: %u (expected %u)\n",
+		drbd_err(device, "unexpected md_size: %u (expected %u)\n",
 		    be32_to_cpu(buffer->md_size_sect), bdev->md.md_size_sect);
 		goto err;
 	}
@@ -3373,7 +3373,7 @@ void drbd_uuid_new_current(struct drbd_device *device) __must_hold(local)
 	bm_uuid = device->ldev->md.uuid[UI_BITMAP];
 
 	if (bm_uuid)
-		dev_warn(DEV, "bm UUID was already set: %llX\n", bm_uuid);
+		drbd_warn(device, "bm UUID was already set: %llX\n", bm_uuid);
 
 	device->ldev->md.uuid[UI_BITMAP] = device->ldev->md.uuid[UI_CURRENT];
 	__drbd_uuid_set(device, UI_CURRENT, val);
@@ -3398,7 +3398,7 @@ void drbd_uuid_set_bm(struct drbd_device *device, u64 val) __must_hold(local)
 	} else {
 		unsigned long long bm_uuid = device->ldev->md.uuid[UI_BITMAP];
 		if (bm_uuid)
-			dev_warn(DEV, "bm UUID was already set: %llX\n", bm_uuid);
+			drbd_warn(device, "bm UUID was already set: %llX\n", bm_uuid);
 
 		device->ldev->md.uuid[UI_BITMAP] = val & ~((u64)1);
 	}
@@ -3560,7 +3560,7 @@ void drbd_queue_bitmap_io(struct drbd_device *device,
 	D_ASSERT(!test_bit(BITMAP_IO, &device->flags));
 	D_ASSERT(list_empty(&device->bm_io_work.w.list));
 	if (device->bm_io_work.why)
-		dev_err(DEV, "FIXME going to queue '%s' but '%s' still pending?\n",
+		drbd_err(device, "FIXME going to queue '%s' but '%s' still pending?\n",
 			why, device->bm_io_work.why);
 
 	device->bm_io_work.io_fn = io_fn;
@@ -3639,9 +3639,9 @@ static int w_md_sync(struct drbd_work *w, int unused)
 {
 	struct drbd_device *device = w->device;
 
-	dev_warn(DEV, "md_sync_timer expired! Worker calls drbd_md_sync().\n");
+	drbd_warn(device, "md_sync_timer expired! Worker calls drbd_md_sync().\n");
 #ifdef DEBUG
-	dev_warn(DEV, "last md_mark_dirty: %s:%u\n",
+	drbd_warn(device, "last md_mark_dirty: %s:%u\n",
 		device->last_md_mark_dirty.func, device->last_md_mark_dirty.line);
 #endif
 	drbd_md_sync(device);
@@ -3815,7 +3815,7 @@ _drbd_insert_fault(struct drbd_device *device, unsigned int type)
 		fault_count++;
 
 		if (__ratelimit(&drbd_ratelimit_state))
-			dev_warn(DEV, "***Simulating %s failure\n",
+			drbd_warn(device, "***Simulating %s failure\n",
 				_drbd_fault_str(type));
 	}
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 88cad90..3ee8f86 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -351,17 +351,17 @@ int drbd_khelper(struct drbd_device *device, char *cmd)
 	 * write out any unsynced meta data changes now */
 	drbd_md_sync(device);
 
-	dev_info(DEV, "helper command: %s %s %s\n", usermode_helper, cmd, mb);
+	drbd_info(device, "helper command: %s %s %s\n", usermode_helper, cmd, mb);
 	sib.sib_reason = SIB_HELPER_PRE;
 	sib.helper_name = cmd;
 	drbd_bcast_event(device, &sib);
 	ret = call_usermodehelper(usermode_helper, argv, envp, UMH_WAIT_PROC);
 	if (ret)
-		dev_warn(DEV, "helper command: %s %s %s exit code %u (0x%x)\n",
+		drbd_warn(device, "helper command: %s %s %s exit code %u (0x%x)\n",
 				usermode_helper, cmd, mb,
 				(ret >> 8) & 0xff, ret);
 	else
-		dev_info(DEV, "helper command: %s %s %s exit code %u (0x%x)\n",
+		drbd_info(device, "helper command: %s %s %s exit code %u (0x%x)\n",
 				usermode_helper, cmd, mb,
 				(ret >> 8) & 0xff, ret);
 	sib.sib_reason = SIB_HELPER_POST;
@@ -603,7 +603,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 			goto out;
 		if (rv == SS_PRIMARY_NOP && mask.pdsk == 0) {
 			if (!conn_try_outdate_peer(first_peer_device(device)->connection) && force) {
-				dev_warn(DEV, "Forced into split brain situation!\n");
+				drbd_warn(device, "Forced into split brain situation!\n");
 				mask.pdsk = D_MASK;
 				val.pdsk  = D_OUTDATED;
 
@@ -636,7 +636,7 @@ drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 		goto out;
 
 	if (forced)
-		dev_warn(DEV, "Forced to consider local data as UpToDate!\n");
+		drbd_warn(device, "Forced to consider local data as UpToDate!\n");
 
 	/* Wait until nothing is on the fly :) */
 	wait_event(device->misc_wait, atomic_read(&device->ap_pending_cnt) == 0);
@@ -905,7 +905,7 @@ drbd_determine_dev_size(struct drbd_device *device, enum dds_flags flags, struct
 		if (rs && u_size == 0) {
 			/* Remove "rs &&" later. This check should always be active, but
 			   right now the receiver expects the permissive behavior */
-			dev_warn(DEV, "Implicit shrink not allowed. "
+			drbd_warn(device, "Implicit shrink not allowed. "
 				 "Use --size=%llus for explicit shrink.\n",
 				 (unsigned long long)size);
 			rv = DS_ERROR_SHRINK;
@@ -924,10 +924,10 @@ drbd_determine_dev_size(struct drbd_device *device, enum dds_flags flags, struct
 			/* currently there is only one error: ENOMEM! */
 			size = drbd_bm_capacity(device)>>1;
 			if (size == 0) {
-				dev_err(DEV, "OUT OF MEMORY! "
+				drbd_err(device, "OUT OF MEMORY! "
 				    "Could not allocate bitmap!\n");
 			} else {
-				dev_err(DEV, "BM resizing failed. "
+				drbd_err(device, "BM resizing failed. "
 				    "Leaving size unchanged at size = %lu KB\n",
 				    (unsigned long)size);
 			}
@@ -936,7 +936,7 @@ drbd_determine_dev_size(struct drbd_device *device, enum dds_flags flags, struct
 		/* racy, see comments above. */
 		drbd_set_my_capacity(device, size);
 		device->ldev->md.la_size_sect = size;
-		dev_info(DEV, "size = %s (%llu KB)\n", ppsize(ppb, size>>1),
+		drbd_info(device, "size = %s (%llu KB)\n", ppsize(ppb, size>>1),
 		     (unsigned long long)size>>1);
 	}
 	if (rv <= DS_ERROR)
@@ -956,7 +956,7 @@ drbd_determine_dev_size(struct drbd_device *device, enum dds_flags flags, struct
 		md->flags &= ~MDF_PRIMARY_IND;
 		drbd_md_write(device, buffer);
 
-		dev_info(DEV, "Writing the whole bitmap, %s\n",
+		drbd_info(device, "Writing the whole bitmap, %s\n",
 			 la_size_changed && md_moved ? "size changed and md moved" :
 			 la_size_changed ? "size changed" : "md moved");
 		/* next line implicitly does drbd_suspend_io()+drbd_resume_io() */
@@ -968,8 +968,8 @@ drbd_determine_dev_size(struct drbd_device *device, enum dds_flags flags, struct
 		drbd_md_write(device, buffer);
 
 		if (rs)
-			dev_info(DEV, "Changed AL layout to al-stripes = %d, al-stripe-size-kB = %d\n",
-				 md->al_stripes, md->al_stripe_size_4k * 4);
+			drbd_info(device, "Changed AL layout to al-stripes = %d, al-stripe-size-kB = %d\n",
+				  md->al_stripes, md->al_stripe_size_4k * 4);
 	}
 
 	if (size > la_size_sect)
@@ -1007,7 +1007,7 @@ drbd_new_dev_size(struct drbd_device *device, struct drbd_backing_dev *bdev,
 	m_size = drbd_get_max_capacity(bdev);
 
 	if (device->state.conn < C_CONNECTED && assume_peer_has_space) {
-		dev_warn(DEV, "Resize while not connected was forced by the user!\n");
+		drbd_warn(device, "Resize while not connected was forced by the user!\n");
 		p_size = m_size;
 	}
 
@@ -1029,11 +1029,11 @@ drbd_new_dev_size(struct drbd_device *device, struct drbd_backing_dev *bdev,
 	}
 
 	if (size == 0)
-		dev_err(DEV, "Both nodes diskless!\n");
+		drbd_err(device, "Both nodes diskless!\n");
 
 	if (u_size) {
 		if (u_size > size)
-			dev_err(DEV, "Requested disk size is too big (%lu > %lu)\n",
+			drbd_err(device, "Requested disk size is too big (%lu > %lu)\n",
 			    (unsigned long)u_size>>1, (unsigned long)size>>1);
 		else
 			size = u_size;
@@ -1067,7 +1067,7 @@ static int drbd_check_al_size(struct drbd_device *device, struct disk_conf *dc)
 		dc->al_extents, sizeof(struct lc_element), 0);
 
 	if (n == NULL) {
-		dev_err(DEV, "Cannot allocate act_log lru!\n");
+		drbd_err(device, "Cannot allocate act_log lru!\n");
 		return -ENOMEM;
 	}
 	spin_lock_irq(&device->al_lock);
@@ -1075,7 +1075,7 @@ static int drbd_check_al_size(struct drbd_device *device, struct disk_conf *dc)
 		for (i = 0; i < t->nr_elements; i++) {
 			e = lc_element_by_index(t, i);
 			if (e->refcnt)
-				dev_err(DEV, "refcnt(%d)==%d\n",
+				drbd_err(device, "refcnt(%d)==%d\n",
 				    e->lc_number, e->refcnt);
 			in_use += e->refcnt;
 		}
@@ -1084,7 +1084,7 @@ static int drbd_check_al_size(struct drbd_device *device, struct disk_conf *dc)
 		device->act_log = n;
 	spin_unlock_irq(&device->al_lock);
 	if (in_use) {
-		dev_err(DEV, "Activity log still in use!\n");
+		drbd_err(device, "Activity log still in use!\n");
 		lc_destroy(n);
 		return -EBUSY;
 	} else {
@@ -1123,7 +1123,7 @@ static void drbd_setup_queue_param(struct drbd_device *device, unsigned int max_
 		blk_queue_stack_limits(q, b);
 
 		if (q->backing_dev_info.ra_pages != b->backing_dev_info.ra_pages) {
-			dev_info(DEV, "Adjusting my ra_pages to backing device's (%lu -> %lu)\n",
+			drbd_info(device, "Adjusting my ra_pages to backing device's (%lu -> %lu)\n",
 				 q->backing_dev_info.ra_pages,
 				 b->backing_dev_info.ra_pages);
 			q->backing_dev_info.ra_pages = b->backing_dev_info.ra_pages;
@@ -1165,10 +1165,10 @@ void drbd_reconsider_max_bio_size(struct drbd_device *device)
 	new = min(local, peer);
 
 	if (device->state.role == R_PRIMARY && new < now)
-		dev_err(DEV, "ASSERT FAILED new < now; (%u < %u)\n", new, now);
+		drbd_err(device, "ASSERT FAILED new < now; (%u < %u)\n", new, now);
 
 	if (new != now)
-		dev_info(DEV, "max BIO size = %u\n", new);
+		drbd_info(device, "max BIO size = %u\n", new);
 
 	drbd_setup_queue_param(device, new);
 }
@@ -1202,7 +1202,7 @@ static void drbd_suspend_al(struct drbd_device *device)
 	int s = 0;
 
 	if (!lc_try_lock(device->act_log)) {
-		dev_warn(DEV, "Failed to lock al in drbd_suspend_al()\n");
+		drbd_warn(device, "Failed to lock al in drbd_suspend_al()\n");
 		return;
 	}
 
@@ -1214,7 +1214,7 @@ static void drbd_suspend_al(struct drbd_device *device)
 	lc_unlock(device->act_log);
 
 	if (s)
-		dev_info(DEV, "Suspended AL updates\n");
+		drbd_info(device, "Suspended AL updates\n");
 }
 
 
@@ -1309,7 +1309,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	if (fifo_size != device->rs_plan_s->size) {
 		new_plan = fifo_alloc(fifo_size);
 		if (!new_plan) {
-			dev_err(DEV, "kmalloc of fifo_buffer failed");
+			drbd_err(device, "kmalloc of fifo_buffer failed");
 			retcode = ERR_NOMEM;
 			goto fail_unlock;
 		}
@@ -1485,7 +1485,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	bdev = blkdev_get_by_path(new_disk_conf->backing_dev,
 				  FMODE_READ | FMODE_WRITE | FMODE_EXCL, device);
 	if (IS_ERR(bdev)) {
-		dev_err(DEV, "open(\"%s\") failed with %ld\n", new_disk_conf->backing_dev,
+		drbd_err(device, "open(\"%s\") failed with %ld\n", new_disk_conf->backing_dev,
 			PTR_ERR(bdev));
 		retcode = ERR_OPEN_DISK;
 		goto fail;
@@ -1505,7 +1505,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 				  (new_disk_conf->meta_dev_idx < 0) ?
 				  (void *)device : (void *)drbd_m_holder);
 	if (IS_ERR(bdev)) {
-		dev_err(DEV, "open(\"%s\") failed with %ld\n", new_disk_conf->meta_dev,
+		drbd_err(device, "open(\"%s\") failed with %ld\n", new_disk_conf->meta_dev,
 			PTR_ERR(bdev));
 		retcode = ERR_OPEN_MD_DISK;
 		goto fail;
@@ -1539,7 +1539,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		new_disk_conf->al_extents = drbd_al_extents_max(nbc);
 
 	if (drbd_get_max_capacity(nbc) < new_disk_conf->disk_size) {
-		dev_err(DEV, "max capacity %llu smaller than disk size %llu\n",
+		drbd_err(device, "max capacity %llu smaller than disk size %llu\n",
 			(unsigned long long) drbd_get_max_capacity(nbc),
 			(unsigned long long) new_disk_conf->disk_size);
 		retcode = ERR_DISK_TOO_SMALL;
@@ -1557,7 +1557,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 
 	if (drbd_get_capacity(nbc->md_bdev) < min_md_device_sectors) {
 		retcode = ERR_MD_DISK_TOO_SMALL;
-		dev_warn(DEV, "refusing attach: md-device too small, "
+		drbd_warn(device, "refusing attach: md-device too small, "
 		     "at least %llu sectors needed for this meta-disk type\n",
 		     (unsigned long long) min_md_device_sectors);
 		goto fail;
@@ -1574,11 +1574,11 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	nbc->known_size = drbd_get_capacity(nbc->backing_bdev);
 
 	if (nbc->known_size > max_possible_sectors) {
-		dev_warn(DEV, "==> truncating very big lower level device "
+		drbd_warn(device, "==> truncating very big lower level device "
 			"to currently maximum possible %llu sectors <==\n",
 			(unsigned long long) max_possible_sectors);
 		if (new_disk_conf->meta_dev_idx >= 0)
-			dev_warn(DEV, "==>> using internal or flexible "
+			drbd_warn(device, "==>> using internal or flexible "
 				      "meta data may help <<==\n");
 	}
 
@@ -1613,7 +1613,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	if (device->state.conn < C_CONNECTED &&
 	    device->state.role == R_PRIMARY &&
 	    (device->ed_uuid & ~((u64)1)) != (nbc->md.uuid[UI_CURRENT] & ~((u64)1))) {
-		dev_err(DEV, "Can only attach to data with current UUID=%016llX\n",
+		drbd_err(device, "Can only attach to data with current UUID=%016llX\n",
 		    (unsigned long long)device->ed_uuid);
 		retcode = ERR_DATA_NOT_CURRENT;
 		goto force_diskless_dec;
@@ -1628,7 +1628,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	/* Prevent shrinking of consistent devices ! */
 	if (drbd_md_test_flag(nbc, MDF_CONSISTENT) &&
 	    drbd_new_dev_size(device, nbc, nbc->disk_conf->disk_size, 0) < nbc->md.la_size_sect) {
-		dev_warn(DEV, "refusing to truncate a consistent device\n");
+		drbd_warn(device, "refusing to truncate a consistent device\n");
 		retcode = ERR_DISK_TOO_SMALL;
 		goto force_diskless_dec;
 	}
@@ -1702,7 +1702,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	if (drbd_md_test_flag(device->ldev, MDF_FULL_SYNC) ||
 	    (test_bit(CRASHED_PRIMARY, &device->flags) &&
 	     drbd_md_test_flag(device->ldev, MDF_AL_DISABLED))) {
-		dev_info(DEV, "Assuming that all blocks are out of sync "
+		drbd_info(device, "Assuming that all blocks are out of sync "
 		     "(aka FullSync)\n");
 		if (drbd_bitmap_io(device, &drbd_bmio_set_n_write,
 			"set_n_write from attaching", BM_LOCKED_MASK)) {
@@ -2381,7 +2381,7 @@ void resync_after_online_grow(struct drbd_device *device)
 {
 	int iass; /* I am sync source */
 
-	dev_info(DEV, "Resync of new storage after online grow\n");
+	drbd_info(device, "Resync of new storage after online grow\n");
 	if (device->state.role != device->state.peer)
 		iass = (device->state.role == R_PRIMARY);
 	else
@@ -3203,7 +3203,7 @@ int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 	if (device->state.conn == C_CONNECTED &&
 	    first_peer_device(device)->connection->agreed_pro_version >= 90 &&
 	    device->ldev->md.uuid[UI_CURRENT] == UUID_JUST_CREATED && args.clear_bm) {
-		dev_info(DEV, "Preparing to skip initial sync\n");
+		drbd_info(device, "Preparing to skip initial sync\n");
 		skip_initial_sync = 1;
 	} else if (device->state.conn != C_STANDALONE) {
 		retcode = ERR_CONNECTED;
@@ -3217,7 +3217,7 @@ int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 		err = drbd_bitmap_io(device, &drbd_bmio_clear_n_write,
 			"clear_n_write from new_c_uuid", BM_LOCKED_MASK);
 		if (err) {
-			dev_err(DEV, "Writing bitmap failed with %d\n",err);
+			drbd_err(device, "Writing bitmap failed with %d\n", err);
 			retcode = ERR_IO_MD_DISK;
 		}
 		if (skip_initial_sync) {
@@ -3513,7 +3513,7 @@ void drbd_bcast_event(struct drbd_device *device, const struct sib_info *sib)
 nla_put_failure:
 	nlmsg_free(msg);
 failed:
-	dev_err(DEV, "Error %d while broadcasting event. "
+	drbd_err(device, "Error %d while broadcasting event. "
 			"Event seq:%u sib_reason:%u\n",
 			err, seq, sib->sib_reason);
 }
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index a750102..b56c3db 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -274,7 +274,7 @@ struct page *drbd_alloc_pages(struct drbd_device *device, unsigned int number,
 			break;
 
 		if (signal_pending(current)) {
-			dev_warn(DEV, "drbd_alloc_pages interrupted!\n");
+			drbd_warn(device, "drbd_alloc_pages interrupted!\n");
 			break;
 		}
 
@@ -311,7 +311,7 @@ static void drbd_free_pages(struct drbd_device *device, struct page *page, int i
 	}
 	i = atomic_sub_return(i, a);
 	if (i < 0)
-		dev_warn(DEV, "ASSERTION FAILED: %s: %d < 0\n",
+		drbd_warn(device, "ASSERTION FAILED: %s: %d < 0\n",
 			is_net ? "pp_in_use_by_net" : "pp_in_use", i);
 	wake_up(&drbd_pp_wait);
 }
@@ -344,7 +344,7 @@ drbd_alloc_peer_req(struct drbd_device *device, u64 id, sector_t sector,
 	peer_req = mempool_alloc(drbd_ee_mempool, gfp_mask & ~__GFP_HIGHMEM);
 	if (!peer_req) {
 		if (!(gfp_mask & __GFP_NOWARN))
-			dev_err(DEV, "%s: allocation failed\n", __func__);
+			drbd_err(device, "%s: allocation failed\n", __func__);
 		return NULL;
 	}
 
@@ -1162,7 +1162,7 @@ static void drbd_flush(struct drbd_connection *connection)
 			rv = blkdev_issue_flush(device->ldev->backing_bdev,
 					GFP_NOIO, NULL);
 			if (rv) {
-				dev_info(DEV, "local disk flush failed with status %d\n", rv);
+				drbd_info(device, "local disk flush failed with status %d\n", rv);
 				/* would rather check on EOPNOTSUPP, but that is not reliable.
 				 * don't try again for ANY return value != 0
 				 * if (rv == -EOPNOTSUPP) */
@@ -1335,7 +1335,7 @@ int drbd_submit_peer_request(struct drbd_device *device,
 next_bio:
 	bio = bio_alloc(GFP_NOIO, nr_pages);
 	if (!bio) {
-		dev_err(DEV, "submit_ee: Allocation of a bio failed\n");
+		drbd_err(device, "submit_ee: Allocation of a bio failed\n");
 		goto fail;
 	}
 	/* > peer_req->i.sector, unless this is the first bio */
@@ -1356,7 +1356,7 @@ next_bio:
 			 * But in case it fails anyways,
 			 * we deal with it, and complain (below). */
 			if (bio->bi_vcnt == 0) {
-				dev_err(DEV,
+				drbd_err(device,
 					"bio_add_page failed for len=%u, "
 					"bi_vcnt=0 (bi_sector=%llu)\n",
 					len, (uint64_t)bio->bi_iter.bi_sector);
@@ -1524,7 +1524,7 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 	/* even though we trust out peer,
 	 * we sometimes have to double check. */
 	if (sector + (data_size>>9) > capacity) {
-		dev_err(DEV, "request from peer beyond end of local disk: "
+		drbd_err(device, "request from peer beyond end of local disk: "
 			"capacity: %llus < sector: %llus + size: %u\n",
 			(unsigned long long)capacity,
 			(unsigned long long)sector, data_size);
@@ -1548,7 +1548,7 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 		data = kmap(page);
 		err = drbd_recv_all_warn(first_peer_device(device)->connection, data, len);
 		if (drbd_insert_fault(device, DRBD_FAULT_RECEIVE)) {
-			dev_err(DEV, "Fault injection: Corrupting data on receive\n");
+			drbd_err(device, "Fault injection: Corrupting data on receive\n");
 			data[0] = data[0] ^ (unsigned long)-1;
 		}
 		kunmap(page);
@@ -1562,7 +1562,7 @@ read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 	if (dgs) {
 		drbd_csum_ee(device, first_peer_device(device)->connection->peer_integrity_tfm, peer_req, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
-			dev_err(DEV, "Digest integrity check FAILED: %llus +%u\n",
+			drbd_err(device, "Digest integrity check FAILED: %llus +%u\n",
 				(unsigned long long)sector, data_size);
 			drbd_free_peer_req(device, peer_req);
 			return NULL;
@@ -1639,7 +1639,7 @@ static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
 	if (dgs) {
 		drbd_csum_bio(device, first_peer_device(device)->connection->peer_integrity_tfm, bio, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
-			dev_err(DEV, "Digest integrity check FAILED. Broken NICs?\n");
+			drbd_err(device, "Digest integrity check FAILED. Broken NICs?\n");
 			return -EINVAL;
 		}
 	}
@@ -1701,7 +1701,7 @@ static int recv_resync_read(struct drbd_device *device, sector_t sector, int dat
 		return 0;
 
 	/* don't care for the reason here */
-	dev_err(DEV, "submit failed, triggering re-connect\n");
+	drbd_err(device, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	list_del(&peer_req->w.list);
 	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
@@ -1723,7 +1723,7 @@ find_request(struct drbd_device *device, struct rb_root *root, u64 id,
 	if (drbd_contains_interval(root, sector, &req->i) && req->i.local)
 		return req;
 	if (!missing_ok) {
-		dev_err(DEV, "%s: failed to find request 0x%lx, sector %llus\n", func,
+		drbd_err(device, "%s: failed to find request 0x%lx, sector %llus\n", func,
 			(unsigned long)id, (unsigned long long)sector);
 	}
 	return NULL;
@@ -1783,7 +1783,7 @@ static int receive_RSDataReply(struct drbd_connection *connection, struct packet
 		err = recv_resync_read(device, sector, pi->size);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
-			dev_err(DEV, "Can not write resync data to local disk.\n");
+			drbd_err(device, "Can not write resync data to local disk.\n");
 
 		err = drbd_drain_block(device, pi->size);
 
@@ -1997,7 +1997,7 @@ static int wait_for_and_update_peer_seq(struct drbd_device *device, const u32 pe
 		spin_lock(&device->peer_seq_lock);
 		if (!timeout) {
 			ret = -ETIMEDOUT;
-			dev_err(DEV, "Timed out waiting for missing ack packets; disconnecting\n");
+			drbd_err(device, "Timed out waiting for missing ack packets; disconnecting\n");
 			break;
 		}
 	}
@@ -2088,7 +2088,7 @@ static int handle_write_conflicts(struct drbd_device *device,
 				       (i->size >> 9) >= sector + (size >> 9);
 
 			if (!equal)
-				dev_alert(DEV, "Concurrent writes detected: "
+				drbd_alert(device, "Concurrent writes detected: "
 					       "local=%llus +%u, remote=%llus +%u, "
 					       "assuming %s came first\n",
 					  (unsigned long long)i->sector, i->size,
@@ -2108,7 +2108,7 @@ static int handle_write_conflicts(struct drbd_device *device,
 				container_of(i, struct drbd_request, i);
 
 			if (!equal)
-				dev_alert(DEV, "Concurrent writes detected: "
+				drbd_alert(device, "Concurrent writes detected: "
 					       "local=%llus +%u, remote=%llus +%u\n",
 					  (unsigned long long)i->sector, i->size,
 					  (unsigned long long)sector, size);
@@ -2277,7 +2277,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 		return 0;
 
 	/* don't care for the reason here */
-	dev_err(DEV, "submit failed, triggering re-connect\n");
+	drbd_err(device, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	list_del(&peer_req->w.list);
 	drbd_remove_epoch_entry_interval(device, peer_req);
@@ -2384,12 +2384,12 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 	size   = be32_to_cpu(p->blksize);
 
 	if (size <= 0 || !IS_ALIGNED(size, 512) || size > DRBD_MAX_BIO_SIZE) {
-		dev_err(DEV, "%s:%d: sector: %llus, size: %u\n", __FILE__, __LINE__,
+		drbd_err(device, "%s:%d: sector: %llus, size: %u\n", __FILE__, __LINE__,
 				(unsigned long long)sector, size);
 		return -EINVAL;
 	}
 	if (sector + (size>>9) > capacity) {
-		dev_err(DEV, "%s:%d: sector: %llus, size: %u\n", __FILE__, __LINE__,
+		drbd_err(device, "%s:%d: sector: %llus, size: %u\n", __FILE__, __LINE__,
 				(unsigned long long)sector, size);
 		return -EINVAL;
 	}
@@ -2414,7 +2414,7 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 			BUG();
 		}
 		if (verb && __ratelimit(&drbd_ratelimit_state))
-			dev_err(DEV, "Can not satisfy peer's read request, "
+			drbd_err(device, "Can not satisfy peer's read request, "
 			    "no local data.\n");
 
 		/* drain possibly payload */
@@ -2489,7 +2489,7 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 				device->rs_mark_left[i] = device->ov_left;
 				device->rs_mark_time[i] = now;
 			}
-			dev_info(DEV, "Online Verify start sector: %llu\n",
+			drbd_info(device, "Online Verify start sector: %llu\n",
 					(unsigned long long)sector);
 		}
 		peer_req->w.cb = w_e_end_ov_req;
@@ -2540,7 +2540,7 @@ submit:
 		return 0;
 
 	/* don't care for the reason here */
-	dev_err(DEV, "submit failed, triggering re-connect\n");
+	drbd_err(device, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
 	list_del(&peer_req->w.list);
 	spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
@@ -2572,7 +2572,7 @@ static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
 	case ASB_DISCARD_SECONDARY:
 	case ASB_CALL_HELPER:
 	case ASB_VIOLENTLY:
-		dev_err(DEV, "Configuration error.\n");
+		drbd_err(device, "Configuration error.\n");
 		break;
 	case ASB_DISCONNECT:
 		break;
@@ -2596,7 +2596,7 @@ static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
 			break;
 		}
 		/* Else fall through to one of the other strategies... */
-		dev_warn(DEV, "Discard younger/older primary did not find a decision\n"
+		drbd_warn(device, "Discard younger/older primary did not find a decision\n"
 		     "Using discard-least-changes instead\n");
 	case ASB_DISCARD_ZERO_CHG:
 		if (ch_peer == 0 && ch_self == 0) {
@@ -2644,7 +2644,7 @@ static int drbd_asb_recover_1p(struct drbd_device *device) __must_hold(local)
 	case ASB_DISCARD_LOCAL:
 	case ASB_DISCARD_REMOTE:
 	case ASB_DISCARD_ZERO_CHG:
-		dev_err(DEV, "Configuration error.\n");
+		drbd_err(device, "Configuration error.\n");
 		break;
 	case ASB_DISCONNECT:
 		break;
@@ -2672,7 +2672,7 @@ static int drbd_asb_recover_1p(struct drbd_device *device) __must_hold(local)
 			if (rv2 != SS_SUCCESS) {
 				drbd_khelper(device, "pri-lost-after-sb");
 			} else {
-				dev_warn(DEV, "Successfully gave up primary role.\n");
+				drbd_warn(device, "Successfully gave up primary role.\n");
 				rv = hg;
 			}
 		} else
@@ -2699,7 +2699,7 @@ static int drbd_asb_recover_2p(struct drbd_device *device) __must_hold(local)
 	case ASB_CONSENSUS:
 	case ASB_DISCARD_SECONDARY:
 	case ASB_DISCARD_ZERO_CHG:
-		dev_err(DEV, "Configuration error.\n");
+		drbd_err(device, "Configuration error.\n");
 		break;
 	case ASB_VIOLENTLY:
 		rv = drbd_asb_recover_0p(device);
@@ -2718,7 +2718,7 @@ static int drbd_asb_recover_2p(struct drbd_device *device) __must_hold(local)
 			if (rv2 != SS_SUCCESS) {
 				drbd_khelper(device, "pri-lost-after-sb");
 			} else {
-				dev_warn(DEV, "Successfully gave up primary role.\n");
+				drbd_warn(device, "Successfully gave up primary role.\n");
 				rv = hg;
 			}
 		} else
@@ -2732,10 +2732,10 @@ static void drbd_uuid_dump(struct drbd_device *device, char *text, u64 *uuid,
 			   u64 bits, u64 flags)
 {
 	if (!uuid) {
-		dev_info(DEV, "%s uuid info vanished while I was looking!\n", text);
+		drbd_info(device, "%s uuid info vanished while I was looking!\n", text);
 		return;
 	}
-	dev_info(DEV, "%s %016llX:%016llX:%016llX:%016llX bits:%llu flags:%llX\n",
+	drbd_info(device, "%s %016llX:%016llX:%016llX:%016llX bits:%llu flags:%llX\n",
 	     text,
 	     (unsigned long long)uuid[UI_CURRENT],
 	     (unsigned long long)uuid[UI_BITMAP],
@@ -2789,7 +2789,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 
 			if ((device->ldev->md.uuid[UI_BITMAP] & ~((u64)1)) == (device->p_uuid[UI_HISTORY_START] & ~((u64)1)) &&
 			    (device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) == (device->p_uuid[UI_HISTORY_START + 1] & ~((u64)1))) {
-				dev_info(DEV, "was SyncSource, missed the resync finished event, corrected myself:\n");
+				drbd_info(device, "was SyncSource, missed the resync finished event, corrected myself:\n");
 				drbd_uuid_move_history(device);
 				device->ldev->md.uuid[UI_HISTORY_START] = device->ldev->md.uuid[UI_BITMAP];
 				device->ldev->md.uuid[UI_BITMAP] = 0;
@@ -2798,7 +2798,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 					       device->state.disk >= D_NEGOTIATING ? drbd_bm_total_weight(device) : 0, 0);
 				*rule_nr = 34;
 			} else {
-				dev_info(DEV, "was SyncSource (peer failed to write sync_uuid)\n");
+				drbd_info(device, "was SyncSource (peer failed to write sync_uuid)\n");
 				*rule_nr = 36;
 			}
 
@@ -2812,7 +2812,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 
 			if ((device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) == (device->p_uuid[UI_BITMAP] & ~((u64)1)) &&
 			    (device->ldev->md.uuid[UI_HISTORY_START + 1] & ~((u64)1)) == (device->p_uuid[UI_HISTORY_START] & ~((u64)1))) {
-				dev_info(DEV, "was SyncTarget, peer missed the resync finished event, corrected peer:\n");
+				drbd_info(device, "was SyncTarget, peer missed the resync finished event, corrected peer:\n");
 
 				device->p_uuid[UI_HISTORY_START + 1] = device->p_uuid[UI_HISTORY_START];
 				device->p_uuid[UI_HISTORY_START] = device->p_uuid[UI_BITMAP];
@@ -2821,7 +2821,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 				drbd_uuid_dump(device, "peer", device->p_uuid, device->p_uuid[UI_SIZE], device->p_uuid[UI_FLAGS]);
 				*rule_nr = 35;
 			} else {
-				dev_info(DEV, "was SyncTarget (failed to write sync_uuid)\n");
+				drbd_info(device, "was SyncTarget (failed to write sync_uuid)\n");
 				*rule_nr = 37;
 			}
 
@@ -2866,7 +2866,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 			device->p_uuid[UI_BITMAP] = device->p_uuid[UI_HISTORY_START];
 			device->p_uuid[UI_HISTORY_START] = device->p_uuid[UI_HISTORY_START + 1];
 
-			dev_info(DEV, "Lost last syncUUID packet, corrected:\n");
+			drbd_info(device, "Lost last syncUUID packet, corrected:\n");
 			drbd_uuid_dump(device, "peer", device->p_uuid, device->p_uuid[UI_SIZE], device->p_uuid[UI_FLAGS]);
 
 			return -1;
@@ -2903,7 +2903,7 @@ static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_ho
 			__drbd_uuid_set(device, UI_BITMAP, device->ldev->md.uuid[UI_HISTORY_START]);
 			__drbd_uuid_set(device, UI_HISTORY_START, device->ldev->md.uuid[UI_HISTORY_START + 1]);
 
-			dev_info(DEV, "Last syncUUID did not get through, corrected:\n");
+			drbd_info(device, "Last syncUUID did not get through, corrected:\n");
 			drbd_uuid_dump(device, "self", device->ldev->md.uuid,
 				       device->state.disk >= D_NEGOTIATING ? drbd_bm_total_weight(device) : 0, 0);
 
@@ -2954,7 +2954,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 	if (mydisk == D_NEGOTIATING)
 		mydisk = device->new_state_tmp.disk;
 
-	dev_info(DEV, "drbd_sync_handshake:\n");
+	drbd_info(device, "drbd_sync_handshake:\n");
 
 	spin_lock_irq(&device->ldev->md.uuid_lock);
 	drbd_uuid_dump(device, "self", device->ldev->md.uuid, device->comm_bm_set, 0);
@@ -2964,14 +2964,14 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 	hg = drbd_uuid_compare(device, &rule_nr);
 	spin_unlock_irq(&device->ldev->md.uuid_lock);
 
-	dev_info(DEV, "uuid_compare()=%d by rule %d\n", hg, rule_nr);
+	drbd_info(device, "uuid_compare()=%d by rule %d\n", hg, rule_nr);
 
 	if (hg == -1000) {
-		dev_alert(DEV, "Unrelated data, aborting!\n");
+		drbd_alert(device, "Unrelated data, aborting!\n");
 		return C_MASK;
 	}
 	if (hg < -1000) {
-		dev_alert(DEV, "To resolve this both sides have to support at least protocol %d\n", -hg - 1000);
+		drbd_alert(device, "To resolve this both sides have to support at least protocol %d\n", -hg - 1000);
 		return C_MASK;
 	}
 
@@ -2981,7 +2981,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 		hg = mydisk > D_INCONSISTENT ? 1 : -1;
 		if (f)
 			hg = hg*2;
-		dev_info(DEV, "Becoming sync %s due to disk states.\n",
+		drbd_info(device, "Becoming sync %s due to disk states.\n",
 		     hg > 0 ? "source" : "target");
 	}
 
@@ -3008,11 +3008,11 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 			break;
 		}
 		if (abs(hg) < 100) {
-			dev_warn(DEV, "Split-Brain detected, %d primaries, "
+			drbd_warn(device, "Split-Brain detected, %d primaries, "
 			     "automatically solved. Sync from %s node\n",
 			     pcount, (hg < 0) ? "peer" : "this");
 			if (forced) {
-				dev_warn(DEV, "Doing a full sync, since"
+				drbd_warn(device, "Doing a full sync, since"
 				     " UUIDs where ambiguous.\n");
 				hg = hg*2;
 			}
@@ -3026,7 +3026,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 			hg = 1;
 
 		if (abs(hg) < 100)
-			dev_warn(DEV, "Split-Brain detected, manually solved. "
+			drbd_warn(device, "Split-Brain detected, manually solved. "
 			     "Sync from %s node\n",
 			     (hg < 0) ? "peer" : "this");
 	}
@@ -3039,13 +3039,13 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 		 * after an attempted attach on a diskless node.
 		 * We just refuse to attach -- well, we drop the "connection"
 		 * to that disk, in a way... */
-		dev_alert(DEV, "Split-Brain detected but unresolved, dropping connection!\n");
+		drbd_alert(device, "Split-Brain detected but unresolved, dropping connection!\n");
 		drbd_khelper(device, "split-brain");
 		return C_MASK;
 	}
 
 	if (hg > 0 && mydisk <= D_INCONSISTENT) {
-		dev_err(DEV, "I shall become SyncSource, but I am inconsistent!\n");
+		drbd_err(device, "I shall become SyncSource, but I am inconsistent!\n");
 		return C_MASK;
 	}
 
@@ -3056,26 +3056,26 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 			drbd_khelper(device, "pri-lost");
 			/* fall through */
 		case ASB_DISCONNECT:
-			dev_err(DEV, "I shall become SyncTarget, but I am primary!\n");
+			drbd_err(device, "I shall become SyncTarget, but I am primary!\n");
 			return C_MASK;
 		case ASB_VIOLENTLY:
-			dev_warn(DEV, "Becoming SyncTarget, violating the stable-data"
+			drbd_warn(device, "Becoming SyncTarget, violating the stable-data"
 			     "assumption\n");
 		}
 	}
 
 	if (tentative || test_bit(CONN_DRY_RUN, &first_peer_device(device)->connection->flags)) {
 		if (hg == 0)
-			dev_info(DEV, "dry-run connect: No resync, would become Connected immediately.\n");
+			drbd_info(device, "dry-run connect: No resync, would become Connected immediately.\n");
 		else
-			dev_info(DEV, "dry-run connect: Would become %s, doing a %s resync.",
+			drbd_info(device, "dry-run connect: Would become %s, doing a %s resync.",
 				 drbd_conn_str(hg > 0 ? C_SYNC_SOURCE : C_SYNC_TARGET),
 				 abs(hg) >= 2 ? "full" : "bit-map based");
 		return C_MASK;
 	}
 
 	if (abs(hg) >= 2) {
-		dev_info(DEV, "Writing the whole bitmap, full sync required after drbd_sync_handshake.\n");
+		drbd_info(device, "Writing the whole bitmap, full sync required after drbd_sync_handshake.\n");
 		if (drbd_bitmap_io(device, &drbd_bmio_set_n_write, "set_n_write from sync_handshake",
 					BM_LOCKED_SET_ALLOWED))
 			return C_MASK;
@@ -3088,7 +3088,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd
 	} else {
 		rv = C_CONNECTED;
 		if (drbd_bm_total_weight(device)) {
-			dev_info(DEV, "No resync, but %lu bits in bitmap!\n",
+			drbd_info(device, "No resync, but %lu bits in bitmap!\n",
 			     drbd_bm_total_weight(device));
 		}
 	}
@@ -3275,7 +3275,7 @@ struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_device *devi
 
 	tfm = crypto_alloc_hash(alg, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm)) {
-		dev_err(DEV, "Can not allocate \"%s\" as %s (reason: %ld)\n",
+		drbd_err(device, "Can not allocate \"%s\" as %s (reason: %ld)\n",
 			alg, name, PTR_ERR(tfm));
 		return tfm;
 	}
@@ -3345,7 +3345,7 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 		    : /* apv >= 95 */ sizeof(struct p_rs_param_95);
 
 	if (pi->size > exp_max_sz) {
-		dev_err(DEV, "SyncParam packet too long: received %u, expected <= %u bytes\n",
+		drbd_err(device, "SyncParam packet too long: received %u, expected <= %u bytes\n",
 		    pi->size, exp_max_sz);
 		return -EIO;
 	}
@@ -3378,7 +3378,7 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 		if (!new_disk_conf) {
 			put_ldev(device);
 			mutex_unlock(&first_peer_device(device)->connection->conf_update);
-			dev_err(DEV, "Allocation of new disk_conf failed\n");
+			drbd_err(device, "Allocation of new disk_conf failed\n");
 			return -ENOMEM;
 		}
 
@@ -3391,7 +3391,7 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 	if (apv >= 88) {
 		if (apv == 88) {
 			if (data_size > SHARED_SECRET_MAX || data_size == 0) {
-				dev_err(DEV, "verify-alg of wrong size, "
+				drbd_err(device, "verify-alg of wrong size, "
 					"peer wants %u, accepting only up to %u byte\n",
 					data_size, SHARED_SECRET_MAX);
 				err = -EIO;
@@ -3417,7 +3417,7 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 
 		if (strcmp(old_net_conf->verify_alg, p->verify_alg)) {
 			if (device->state.conn == C_WF_REPORT_PARAMS) {
-				dev_err(DEV, "Different verify-alg settings. me=\"%s\" peer=\"%s\"\n",
+				drbd_err(device, "Different verify-alg settings. me=\"%s\" peer=\"%s\"\n",
 				    old_net_conf->verify_alg, p->verify_alg);
 				goto disconnect;
 			}
@@ -3431,7 +3431,7 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 
 		if (apv >= 89 && strcmp(old_net_conf->csums_alg, p->csums_alg)) {
 			if (device->state.conn == C_WF_REPORT_PARAMS) {
-				dev_err(DEV, "Different csums-alg settings. me=\"%s\" peer=\"%s\"\n",
+				drbd_err(device, "Different csums-alg settings. me=\"%s\" peer=\"%s\"\n",
 				    old_net_conf->csums_alg, p->csums_alg);
 				goto disconnect;
 			}
@@ -3453,7 +3453,7 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 			if (fifo_size != device->rs_plan_s->size) {
 				new_plan = fifo_alloc(fifo_size);
 				if (!new_plan) {
-					dev_err(DEV, "kmalloc of fifo_buffer failed");
+					drbd_err(device, "kmalloc of fifo_buffer failed");
 					put_ldev(device);
 					goto disconnect;
 				}
@@ -3463,7 +3463,7 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 		if (verify_tfm || csums_tfm) {
 			new_net_conf = kzalloc(sizeof(struct net_conf), GFP_KERNEL);
 			if (!new_net_conf) {
-				dev_err(DEV, "Allocation of new net_conf failed\n");
+				drbd_err(device, "Allocation of new net_conf failed\n");
 				goto disconnect;
 			}
 
@@ -3474,14 +3474,14 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 				new_net_conf->verify_alg_len = strlen(p->verify_alg) + 1;
 				crypto_free_hash(first_peer_device(device)->connection->verify_tfm);
 				first_peer_device(device)->connection->verify_tfm = verify_tfm;
-				dev_info(DEV, "using verify-alg: \"%s\"\n", p->verify_alg);
+				drbd_info(device, "using verify-alg: \"%s\"\n", p->verify_alg);
 			}
 			if (csums_tfm) {
 				strcpy(new_net_conf->csums_alg, p->csums_alg);
 				new_net_conf->csums_alg_len = strlen(p->csums_alg) + 1;
 				crypto_free_hash(first_peer_device(device)->connection->csums_tfm);
 				first_peer_device(device)->connection->csums_tfm = csums_tfm;
-				dev_info(DEV, "using csums-alg: \"%s\"\n", p->csums_alg);
+				drbd_info(device, "using csums-alg: \"%s\"\n", p->csums_alg);
 			}
 			rcu_assign_pointer(connection->net_conf, new_net_conf);
 		}
@@ -3539,7 +3539,7 @@ static void warn_if_differ_considerably(struct drbd_device *device,
 		return;
 	d = (a > b) ? (a - b) : (b - a);
 	if (d > (a>>3) || d > (b>>3))
-		dev_warn(DEV, "Considerable difference in %s: %llus vs. %llus\n", s,
+		drbd_warn(device, "Considerable difference in %s: %llus vs. %llus\n", s,
 		     (unsigned long long)a, (unsigned long long)b);
 }
 
@@ -3584,7 +3584,7 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 		    drbd_get_capacity(device->this_bdev) &&
 		    device->state.disk >= D_OUTDATED &&
 		    device->state.conn < C_CONNECTED) {
-			dev_err(DEV, "The peer's disk size is too small!\n");
+			drbd_err(device, "The peer's disk size is too small!\n");
 			conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 			put_ldev(device);
 			return -EIO;
@@ -3595,7 +3595,7 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 
 			new_disk_conf = kzalloc(sizeof(struct disk_conf), GFP_KERNEL);
 			if (!new_disk_conf) {
-				dev_err(DEV, "Allocation of new disk_conf failed\n");
+				drbd_err(device, "Allocation of new disk_conf failed\n");
 				put_ldev(device);
 				return -ENOMEM;
 			}
@@ -3610,7 +3610,7 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 			synchronize_rcu();
 			kfree(old_disk_conf);
 
-			dev_info(DEV, "Peer sets u_size to %lu sectors\n",
+			drbd_info(device, "Peer sets u_size to %lu sectors\n",
 				 (unsigned long)my_usize);
 		}
 
@@ -3653,7 +3653,7 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 			if (device->state.pdsk >= D_INCONSISTENT &&
 			    device->state.disk >= D_INCONSISTENT) {
 				if (ddsf & DDSF_NO_RESYNC)
-					dev_info(DEV, "Resync of new storage suppressed with --assume-clean\n");
+					drbd_info(device, "Resync of new storage suppressed with --assume-clean\n");
 				else
 					resync_after_online_grow(device);
 			} else
@@ -3677,7 +3677,7 @@ static int receive_uuids(struct drbd_connection *connection, struct packet_info
 
 	p_uuid = kmalloc(sizeof(u64)*UI_EXTENDED_SIZE, GFP_NOIO);
 	if (!p_uuid) {
-		dev_err(DEV, "kmalloc of p_uuid failed\n");
+		drbd_err(device, "kmalloc of p_uuid failed\n");
 		return false;
 	}
 
@@ -3691,7 +3691,7 @@ static int receive_uuids(struct drbd_connection *connection, struct packet_info
 	    device->state.disk < D_INCONSISTENT &&
 	    device->state.role == R_PRIMARY &&
 	    (device->ed_uuid & ~((u64)1)) != (p_uuid[UI_CURRENT] & ~((u64)1))) {
-		dev_err(DEV, "Can only connect to data with current UUID=%016llX\n",
+		drbd_err(device, "Can only connect to data with current UUID=%016llX\n",
 		    (unsigned long long)device->ed_uuid);
 		conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 		return -EIO;
@@ -3704,7 +3704,7 @@ static int receive_uuids(struct drbd_connection *connection, struct packet_info
 			device->ldev->md.uuid[UI_CURRENT] == UUID_JUST_CREATED &&
 			(p_uuid[UI_FLAGS] & 8);
 		if (skip_initial_sync) {
-			dev_info(DEV, "Accepted new current UUID, preparing to skip initial sync\n");
+			drbd_info(device, "Accepted new current UUID, preparing to skip initial sync\n");
 			drbd_bitmap_io(device, &drbd_bmio_clear_n_write,
 					"clear_n_write from receive_uuids",
 					BM_LOCKED_TEST_ALLOWED);
@@ -3842,7 +3842,7 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 	real_peer_disk = peer_state.disk;
 	if (peer_state.disk == D_NEGOTIATING) {
 		real_peer_disk = device->p_uuid[UI_FLAGS] & 4 ? D_INCONSISTENT : D_CONSISTENT;
-		dev_info(DEV, "real peer disk state = %s\n", drbd_disk_str(real_peer_disk));
+		drbd_info(device, "real peer disk state = %s\n", drbd_disk_str(real_peer_disk));
 	}
 
 	spin_lock_irq(&first_peer_device(device)->connection->req_lock);
@@ -3938,7 +3938,7 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 			if (device->state.disk == D_NEGOTIATING) {
 				drbd_force_state(device, NS(disk, D_FAILED));
 			} else if (peer_state.disk == D_NEGOTIATING) {
-				dev_err(DEV, "Disk attach process on the peer node was aborted.\n");
+				drbd_err(device, "Disk attach process on the peer node was aborted.\n");
 				peer_state.disk = D_DISKLESS;
 				real_peer_disk = D_DISKLESS;
 			} else {
@@ -3966,7 +3966,7 @@ static int receive_state(struct drbd_connection *connection, struct packet_info
 		/* Do not allow tl_restart(RESEND) for a rebooted peer. We can only allow this
 		   for temporal network outages! */
 		spin_unlock_irq(&first_peer_device(device)->connection->req_lock);
-		dev_err(DEV, "Aborting Connect, can not thaw IO with an only Consistent peer\n");
+		drbd_err(device, "Aborting Connect, can not thaw IO with an only Consistent peer\n");
 		tl_clear(first_peer_device(device)->connection);
 		drbd_uuid_new_current(device);
 		clear_bit(NEW_CUR_UUID, &device->flags);
@@ -4028,7 +4028,7 @@ static int receive_sync_uuid(struct drbd_connection *connection, struct packet_i
 
 		put_ldev(device);
 	} else
-		dev_err(DEV, "Ignoring SyncUUID packet!\n");
+		drbd_err(device, "Ignoring SyncUUID packet!\n");
 
 	return 0;
 }
@@ -4051,7 +4051,7 @@ receive_bitmap_plain(struct drbd_device *device, unsigned int size,
 	int err;
 
 	if (want != size) {
-		dev_err(DEV, "%s:want (%u) != size (%u)\n", __func__, want, size);
+		drbd_err(device, "%s:want (%u) != size (%u)\n", __func__, want, size);
 		return -EIO;
 	}
 	if (want == 0)
@@ -4121,14 +4121,14 @@ recv_bm_rle_bits(struct drbd_device *device,
 		if (toggle) {
 			e = s + rl -1;
 			if (e >= c->bm_bits) {
-				dev_err(DEV, "bitmap overflow (e:%lu) while decoding bm RLE packet\n", e);
+				drbd_err(device, "bitmap overflow (e:%lu) while decoding bm RLE packet\n", e);
 				return -EIO;
 			}
 			_drbd_bm_set_bits(device, s, e);
 		}
 
 		if (have < bits) {
-			dev_err(DEV, "bitmap decoding error: h:%d b:%d la:0x%08llx l:%u/%u\n",
+			drbd_err(device, "bitmap decoding error: h:%d b:%d la:0x%08llx l:%u/%u\n",
 				have, bits, look_ahead,
 				(unsigned int)(bs.cur.b - p->code),
 				(unsigned int)bs.buf_len);
@@ -4173,7 +4173,7 @@ decode_bitmap_c(struct drbd_device *device,
 	 * but have been dropped as this one turned out to be "best"
 	 * during all our tests. */
 
-	dev_err(DEV, "receive_bitmap_c: unknown encoding %u\n", p->encoding);
+	drbd_err(device, "receive_bitmap_c: unknown encoding %u\n", p->encoding);
 	conn_request_state(first_peer_device(device)->connection, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
 	return -EIO;
 }
@@ -4206,7 +4206,7 @@ void INFO_bm_xfer_stats(struct drbd_device *device,
 		r = 1000;
 
 	r = 1000 - r;
-	dev_info(DEV, "%s bitmap stats [Bytes(packets)]: plain %u(%u), RLE %u(%u), "
+	drbd_info(device, "%s bitmap stats [Bytes(packets)]: plain %u(%u), RLE %u(%u), "
 	     "total %u; compression: %u.%u%%\n",
 			direction,
 			c->bytes[1], c->packets[1],
@@ -4250,12 +4250,12 @@ static int receive_bitmap(struct drbd_connection *connection, struct packet_info
 			struct p_compressed_bm *p = pi->data;
 
 			if (pi->size > DRBD_SOCKET_BUFFER_SIZE - drbd_header_size(connection)) {
-				dev_err(DEV, "ReportCBitmap packet too large\n");
+				drbd_err(device, "ReportCBitmap packet too large\n");
 				err = -EIO;
 				goto out;
 			}
 			if (pi->size <= sizeof(*p)) {
-				dev_err(DEV, "ReportCBitmap packet too small (l:%u)\n", pi->size);
+				drbd_err(device, "ReportCBitmap packet too small (l:%u)\n", pi->size);
 				err = -EIO;
 				goto out;
 			}
@@ -4264,7 +4264,7 @@ static int receive_bitmap(struct drbd_connection *connection, struct packet_info
 			       goto out;
 			err = decode_bitmap_c(device, p, &c, pi->size);
 		} else {
-			dev_warn(DEV, "receive_bitmap: cmd neither ReportBitMap nor ReportCBitMap (is 0x%x)", pi->cmd);
+			drbd_warn(device, "receive_bitmap: cmd neither ReportBitMap nor ReportCBitMap (is 0x%x)", pi->cmd);
 			err = -EIO;
 			goto out;
 		}
@@ -4296,7 +4296,7 @@ static int receive_bitmap(struct drbd_connection *connection, struct packet_info
 	} else if (device->state.conn != C_WF_BITMAP_S) {
 		/* admin may have requested C_DISCONNECTING,
 		 * other threads may have noticed network errors */
-		dev_info(DEV, "unexpected cstate (%s) in receive_bitmap\n",
+		drbd_info(device, "unexpected cstate (%s) in receive_bitmap\n",
 		    drbd_conn_str(device->state.conn));
 	}
 	err = 0;
@@ -4340,7 +4340,7 @@ static int receive_out_of_sync(struct drbd_connection *connection, struct packet
 	case C_BEHIND:
 			break;
 	default:
-		dev_err(DEV, "ASSERT FAILED cstate = %s, expected: WFSyncUUID|WFBitMapT|Behind\n",
+		drbd_err(device, "ASSERT FAILED cstate = %s, expected: WFSyncUUID|WFBitMapT|Behind\n",
 				drbd_conn_str(device->state.conn));
 	}
 
@@ -4560,13 +4560,13 @@ static int drbd_disconnected(struct drbd_device *device)
 	 */
 	i = drbd_free_peer_reqs(device, &device->net_ee);
 	if (i)
-		dev_info(DEV, "net_ee not empty, killed %u entries\n", i);
+		drbd_info(device, "net_ee not empty, killed %u entries\n", i);
 	i = atomic_read(&device->pp_in_use_by_net);
 	if (i)
-		dev_info(DEV, "pp_in_use_by_net = %d, expected 0\n", i);
+		drbd_info(device, "pp_in_use_by_net = %d, expected 0\n", i);
 	i = atomic_read(&device->pp_in_use);
 	if (i)
-		dev_info(DEV, "pp_in_use = %d, expected 0\n", i);
+		drbd_info(device, "pp_in_use = %d, expected 0\n", i);
 
 	D_ASSERT(list_empty(&device->read_ee));
 	D_ASSERT(list_empty(&device->active_ee));
@@ -4909,7 +4909,7 @@ static int got_RqSReply(struct drbd_connection *connection, struct packet_info *
 		set_bit(CL_ST_CHG_SUCCESS, &device->flags);
 	} else {
 		set_bit(CL_ST_CHG_FAIL, &device->flags);
-		dev_err(DEV, "Requested state change failed by peer: %s (%d)\n",
+		drbd_err(device, "Requested state change failed by peer: %s (%d)\n",
 			drbd_set_st_err_str(retcode), retcode);
 	}
 	wake_up(&device->state_wait);
@@ -5073,7 +5073,7 @@ static int got_NegDReply(struct drbd_connection *connection, struct packet_info
 
 	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
-	dev_err(DEV, "Got NegDReply; Sector %llus, len %u.\n",
+	drbd_err(device, "Got NegDReply; Sector %llus, len %u.\n",
 	    (unsigned long long)sector, be32_to_cpu(p->blksize));
 
 	return validate_req_change_req_state(device, p->block_id, sector,
@@ -5180,7 +5180,7 @@ static int got_OVResult(struct drbd_connection *connection, struct packet_info *
 			w->device = device;
 			drbd_queue_work(&first_peer_device(device)->connection->sender_work, w);
 		} else {
-			dev_err(DEV, "kmalloc(w) failed.");
+			drbd_err(device, "kmalloc(w) failed.");
 			ov_out_of_sync_print(device);
 			drbd_resync_finished(device);
 		}
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 1b46b92..68ea716 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -102,7 +102,7 @@ void drbd_req_destroy(struct kref *kref)
 		atomic_read(&req->completion_ref) ||
 		(s & RQ_LOCAL_PENDING) ||
 		((s & RQ_NET_MASK) && !(s & RQ_NET_DONE))) {
-		dev_err(DEV, "drbd_req_destroy: Logic BUG rq_state = 0x%x, completion_ref = %d\n",
+		drbd_err(device, "drbd_req_destroy: Logic BUG rq_state = 0x%x, completion_ref = %d\n",
 				s, atomic_read(&req->completion_ref));
 		return;
 	}
@@ -153,7 +153,7 @@ void drbd_req_destroy(struct kref *kref)
 				drbd_al_complete_io(device, &req->i);
 				put_ldev(device);
 			} else if (__ratelimit(&drbd_ratelimit_state)) {
-				dev_warn(DEV, "Should have called drbd_al_complete_io(, %llu, %u), "
+				drbd_warn(device, "Should have called drbd_al_complete_io(, %llu, %u), "
 					 "but my Disk seems to have failed :(\n",
 					 (unsigned long long) req->i.sector, req->i.size);
 			}
@@ -227,12 +227,12 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 	if ((s & RQ_LOCAL_PENDING && !(s & RQ_LOCAL_ABORTED)) ||
 	    (s & RQ_NET_QUEUED) || (s & RQ_NET_PENDING) ||
 	    (s & RQ_COMPLETION_SUSP)) {
-		dev_err(DEV, "drbd_req_complete: Logic BUG rq_state = 0x%x\n", s);
+		drbd_err(device, "drbd_req_complete: Logic BUG rq_state = 0x%x\n", s);
 		return;
 	}
 
 	if (!req->master_bio) {
-		dev_err(DEV, "drbd_req_complete: Logic BUG, master_bio == NULL!\n");
+		drbd_err(device, "drbd_req_complete: Logic BUG, master_bio == NULL!\n");
 		return;
 	}
 
@@ -410,7 +410,7 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 		int at_least = k_put + !!c_put;
 		int refcount = atomic_read(&req->kref.refcount);
 		if (refcount < at_least)
-			dev_err(DEV,
+			drbd_err(device,
 				"mod_rq_state: Logic BUG: %x -> %x: refcount = %d, should be >= %d\n",
 				s, req->rq_state, refcount, at_least);
 	}
@@ -432,7 +432,7 @@ static void drbd_report_io_error(struct drbd_device *device, struct drbd_request
 	if (!__ratelimit(&drbd_ratelimit_state))
 		return;
 
-	dev_warn(DEV, "local %s IO error sector %llu+%u on %s\n",
+	drbd_warn(device, "local %s IO error sector %llu+%u on %s\n",
 			(req->rq_state & RQ_WRITE) ? "WRITE" : "READ",
 			(unsigned long long)req->i.sector,
 			req->i.size >> 9,
@@ -463,7 +463,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 	switch (what) {
 	default:
-		dev_err(DEV, "LOGIC BUG in %s:%u\n", __FILE__ , __LINE__);
+		drbd_err(device, "LOGIC BUG in %s:%u\n", __FILE__ , __LINE__);
 		break;
 
 	/* does not happen...
@@ -741,7 +741,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 			/* barrier came in before all requests were acked.
 			 * this is bad, because if the connection is lost now,
 			 * we won't be able to clean them up... */
-			dev_err(DEV, "FIXME (BARRIER_ACKED but pending)\n");
+			drbd_err(device, "FIXME (BARRIER_ACKED but pending)\n");
 		}
 		/* Allowed to complete requests, even while suspended.
 		 * As this is called for all requests within a matching epoch,
@@ -883,12 +883,12 @@ static void maybe_pull_ahead(struct drbd_device *device)
 
 	if (nc->cong_fill &&
 	    atomic_read(&device->ap_in_flight) >= nc->cong_fill) {
-		dev_info(DEV, "Congestion-fill threshold reached\n");
+		drbd_info(device, "Congestion-fill threshold reached\n");
 		congested = true;
 	}
 
 	if (device->act_log->used >= nc->cong_extents) {
-		dev_info(DEV, "Congestion-extents threshold reached\n");
+		drbd_info(device, "Congestion-extents threshold reached\n");
 		congested = true;
 	}
 
@@ -1046,7 +1046,7 @@ drbd_request_prepare(struct drbd_device *device, struct bio *bio, unsigned long
 		dec_ap_bio(device);
 		/* only pass the error to the upper layers.
 		 * if user cannot handle io errors, that's not our business. */
-		dev_err(DEV, "could not kmalloc() req\n");
+		drbd_err(device, "could not kmalloc() req\n");
 		bio_endio(bio, -ENOMEM);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1146,7 +1146,7 @@ static void drbd_send_and_submit(struct drbd_device *device, struct drbd_request
 	} else if (no_remote) {
 nodata:
 		if (__ratelimit(&drbd_ratelimit_state))
-			dev_err(DEV, "IO ERROR: neither local nor remote data, sector %llu+%u\n",
+			drbd_err(device, "IO ERROR: neither local nor remote data, sector %llu+%u\n",
 					(unsigned long long)req->i.sector, req->i.size >> 9);
 		/* A write may have been queued for send_oos, however.
 		 * So we can not simply free it, we must go through drbd_req_put_completion_ref() */
@@ -1387,13 +1387,13 @@ void request_timer_fn(unsigned long data)
 	if (ent && req->rq_state & RQ_NET_PENDING &&
 		 time_after(now, req->start_time + ent) &&
 		!time_in_range(now, connection->last_reconnect_jif, connection->last_reconnect_jif + ent)) {
-		dev_warn(DEV, "Remote failed to finish a request within ko-count * timeout\n");
+		drbd_warn(device, "Remote failed to finish a request within ko-count * timeout\n");
 		_drbd_set_state(_NS(device, conn, C_TIMEOUT), CS_VERBOSE | CS_HARD, NULL);
 	}
 	if (dt && req->rq_state & RQ_LOCAL_PENDING && req->w.device == device &&
 		 time_after(now, req->start_time + dt) &&
 		!time_in_range(now, device->last_reattach_jif, device->last_reattach_jif + dt)) {
-		dev_warn(DEV, "Local backing device failed to meet the disk-timeout\n");
+		drbd_warn(device, "Local backing device failed to meet the disk-timeout\n");
 		__drbd_chk_io_error(device, DRBD_FORCE_DETACH);
 	}
 	nt = (time_after(now, req->start_time + et) ? now : req->start_time) + et;
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index f6a5d4d..d3bc018 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -414,7 +414,7 @@ _drbd_request_state(struct drbd_device *device, union drbd_state mask,
 
 static void print_st(struct drbd_device *device, char *name, union drbd_state ns)
 {
-	dev_err(DEV, " %s = { cs:%s ro:%s/%s ds:%s/%s %c%c%c%c%c%c }\n",
+	drbd_err(device, " %s = { cs:%s ro:%s/%s ds:%s/%s %c%c%c%c%c%c }\n",
 	    name,
 	    drbd_conn_str(ns.conn),
 	    drbd_role_str(ns.role),
@@ -435,7 +435,7 @@ void print_st_err(struct drbd_device *device, union drbd_state os,
 {
 	if (err == SS_IN_TRANSIENT_STATE)
 		return;
-	dev_err(DEV, "State change failed: %s\n", drbd_set_st_err_str(err));
+	drbd_err(device, "State change failed: %s\n", drbd_set_st_err_str(err));
 	print_st(device, " state", os);
 	print_st(device, "wanted", ns);
 }
@@ -493,7 +493,7 @@ static void drbd_pr_state_change(struct drbd_device *device, union drbd_state os
 			       ns.user_isp);
 
 	if (pbp != pb)
-		dev_info(DEV, "%s\n", pb);
+		drbd_info(device, "%s\n", pb);
 }
 
 static void conn_pr_state_change(struct drbd_connection *connection, union drbd_state os, union drbd_state ns,
@@ -729,7 +729,7 @@ static void print_sanitize_warnings(struct drbd_device *device, enum sanitize_st
 	};
 
 	if (warn != NO_WARNING)
-		dev_warn(DEV, "%s\n", msg_table[warn]);
+		drbd_warn(device, "%s\n", msg_table[warn]);
 }
 
 /**
@@ -909,7 +909,7 @@ static union drbd_state sanitize_state(struct drbd_device *device, union drbd_st
 void drbd_resume_al(struct drbd_device *device)
 {
 	if (test_and_clear_bit(AL_SUSPENDED, &device->flags))
-		dev_info(DEV, "Resumed AL updates\n");
+		drbd_info(device, "Resumed AL updates\n");
 }
 
 /* helper for __drbd_set_state */
@@ -1038,13 +1038,13 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 		device->ov_start_sector =
 			BM_BIT_TO_SECT(drbd_bm_bits(device) - device->ov_left);
 		if (device->ov_left)
-			dev_info(DEV, "Online Verify reached sector %llu\n",
+			drbd_info(device, "Online Verify reached sector %llu\n",
 				(unsigned long long)device->ov_start_sector);
 	}
 
 	if ((os.conn == C_PAUSED_SYNC_T || os.conn == C_PAUSED_SYNC_S) &&
 	    (ns.conn == C_SYNC_TARGET  || ns.conn == C_SYNC_SOURCE)) {
-		dev_info(DEV, "Syncer continues.\n");
+		drbd_info(device, "Syncer continues.\n");
 		device->rs_paused += (long)jiffies
 				  -(long)device->rs_mark_time[device->rs_last_mark];
 		if (ns.conn == C_SYNC_TARGET)
@@ -1053,7 +1053,7 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 
 	if ((os.conn == C_SYNC_TARGET  || os.conn == C_SYNC_SOURCE) &&
 	    (ns.conn == C_PAUSED_SYNC_T || ns.conn == C_PAUSED_SYNC_S)) {
-		dev_info(DEV, "Resync suspended\n");
+		drbd_info(device, "Resync suspended\n");
 		device->rs_mark_time[device->rs_last_mark] = jiffies;
 	}
 
@@ -1077,7 +1077,7 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 		drbd_rs_controller_reset(device);
 
 		if (ns.conn == C_VERIFY_S) {
-			dev_info(DEV, "Starting Online Verify from sector %llu\n",
+			drbd_info(device, "Starting Online Verify from sector %llu\n",
 					(unsigned long long)device->ov_position);
 			mod_timer(&device->resync_timer, jiffies);
 		}
@@ -1152,7 +1152,7 @@ __drbd_set_state(struct drbd_device *device, union drbd_state ns,
 		ascw->done = done;
 		drbd_queue_work(&first_peer_device(device)->connection->sender_work, &ascw->w);
 	} else {
-		dev_err(DEV, "Could not kmalloc an ascw\n");
+		drbd_err(device, "Could not kmalloc an ascw\n");
 	}
 
 	return rv;
@@ -1177,7 +1177,7 @@ static int w_after_state_ch(struct drbd_work *w, int unused)
 static void abw_start_sync(struct drbd_device *device, int rv)
 {
 	if (rv) {
-		dev_err(DEV, "Writing the bitmap failed not starting resync.\n");
+		drbd_err(device, "Writing the bitmap failed not starting resync.\n");
 		_drbd_request_state(device, NS(conn, C_CONNECTED), CS_VERBOSE);
 		return;
 	}
@@ -1444,7 +1444,7 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 			 * there is only one way out: to D_DISKLESS,
 			 * and that may only happen after our put_ldev below. */
 			if (device->state.disk != D_FAILED)
-				dev_err(DEV,
+				drbd_err(device,
 					"ASSERT FAILED: disk is %s during detach\n",
 					drbd_disk_str(device->state.disk));
 
@@ -1468,9 +1468,9 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 		/* We must still be diskless,
 		 * re-attach has to be serialized with this! */
 		if (device->state.disk != D_DISKLESS)
-			dev_err(DEV,
-				"ASSERT FAILED: disk is %s while going diskless\n",
-				drbd_disk_str(device->state.disk));
+			drbd_err(device,
+				 "ASSERT FAILED: disk is %s while going diskless\n",
+				 drbd_disk_str(device->state.disk));
 
 		if (ns.conn >= C_CONNECTED)
 			drbd_send_state(device, ns);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 06491d9..9da406b 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -176,12 +176,12 @@ void drbd_peer_request_endio(struct bio *bio, int error)
 	int is_write = bio_data_dir(bio) == WRITE;
 
 	if (error && __ratelimit(&drbd_ratelimit_state))
-		dev_warn(DEV, "%s: error=%d s=%llus\n",
+		drbd_warn(device, "%s: error=%d s=%llus\n",
 				is_write ? "write" : "read", error,
 				(unsigned long long)peer_req->i.sector);
 	if (!error && !uptodate) {
 		if (__ratelimit(&drbd_ratelimit_state))
-			dev_warn(DEV, "%s: setting error to -EIO s=%llus\n",
+			drbd_warn(device, "%s: setting error to -EIO s=%llus\n",
 					is_write ? "write" : "read",
 					(unsigned long long)peer_req->i.sector);
 		/* strange behavior of some lower level drivers...
@@ -214,7 +214,7 @@ void drbd_request_endio(struct bio *bio, int error)
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
 
 	if (!error && !uptodate) {
-		dev_warn(DEV, "p %s: setting error to -EIO\n",
+		drbd_warn(device, "p %s: setting error to -EIO\n",
 			 bio_data_dir(bio) == WRITE ? "write" : "read");
 		/* strange behavior of some lower level drivers...
 		 * fail the request by clearing the uptodate flag,
@@ -253,7 +253,7 @@ void drbd_request_endio(struct bio *bio, int error)
 	 */
 	if (unlikely(req->rq_state & RQ_LOCAL_ABORTED)) {
 		if (__ratelimit(&drbd_ratelimit_state))
-			dev_emerg(DEV, "delayed completion of aborted local request; disk-timeout may be too aggressive\n");
+			drbd_emerg(device, "delayed completion of aborted local request; disk-timeout may be too aggressive\n");
 
 		if (!error)
 			panic("possible random memory corruption caused by delayed completion of aborted local request\n");
@@ -364,7 +364,7 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 					      P_CSUM_RS_REQUEST);
 		kfree(digest);
 	} else {
-		dev_err(DEV, "kmalloc() of digest failed.\n");
+		drbd_err(device, "kmalloc() of digest failed.\n");
 		err = -ENOMEM;
 	}
 
@@ -373,7 +373,7 @@ out:
 		drbd_free_peer_req(device, peer_req);
 
 	if (unlikely(err))
-		dev_err(DEV, "drbd_send_drequest(..., csum) failed\n");
+		drbd_err(device, "drbd_send_drequest(..., csum) failed\n");
 	return err;
 }
 
@@ -534,7 +534,7 @@ static int drbd_rs_controller(struct drbd_device *device)
 		req_sect = max_sect;
 
 	/*
-	dev_warn(DEV, "si=%u if=%d wa=%u co=%d st=%d cps=%d pl=%d cc=%d rs=%d\n",
+	drbd_warn(device, "si=%u if=%d wa=%u co=%d st=%d cps=%d pl=%d cc=%d rs=%d\n",
 		 sect_in, device->rs_in_flight, want, correction,
 		 steps, cps, device->rs_planed, curr_corr, req_sect);
 	*/
@@ -586,7 +586,7 @@ int w_make_resync_request(struct drbd_work *w, int cancel)
 		   get_ldev_if_state(device,D_FAILED) would be sufficient, but
 		   to continue resync with a broken disk makes no sense at
 		   all */
-		dev_err(DEV, "Disk broke down during resync!\n");
+		drbd_err(device, "Disk broke down during resync!\n");
 		return 0;
 	}
 
@@ -699,7 +699,7 @@ next_sector:
 			err = drbd_send_drequest(device, P_RS_DATA_REQUEST,
 						 sector, size, ID_SYNCER);
 			if (err) {
-				dev_err(DEV, "drbd_send_drequest() failed, aborting...\n");
+				drbd_err(device, "drbd_send_drequest() failed, aborting...\n");
 				dec_rs_pending(device);
 				put_ldev(device);
 				return err;
@@ -835,7 +835,7 @@ int drbd_resync_finished(struct drbd_device *device)
 			drbd_queue_work(&first_peer_device(device)->connection->sender_work, w);
 			return 1;
 		}
-		dev_err(DEV, "Warn failed to drbd_rs_del_all() and to kmalloc(w).\n");
+		drbd_err(device, "Warn failed to drbd_rs_del_all() and to kmalloc(w).\n");
 	}
 
 	dt = (jiffies - device->rs_start - device->rs_paused) / HZ;
@@ -868,7 +868,7 @@ int drbd_resync_finished(struct drbd_device *device)
 	ns = os;
 	ns.conn = C_CONNECTED;
 
-	dev_info(DEV, "%s done (total %lu sec; paused %lu sec; %lu K/sec)\n",
+	drbd_info(device, "%s done (total %lu sec; paused %lu sec; %lu K/sec)\n",
 	     verify_done ? "Online verify" : "Resync",
 	     dt + device->rs_paused, device->rs_paused, dbdt);
 
@@ -876,7 +876,7 @@ int drbd_resync_finished(struct drbd_device *device)
 
 	if (os.conn == C_VERIFY_S || os.conn == C_VERIFY_T) {
 		if (n_oos) {
-			dev_alert(DEV, "Online verify found %lu %dk block out of sync!\n",
+			drbd_alert(device, "Online verify found %lu %dk block out of sync!\n",
 			      n_oos, Bit2KB(1));
 			khelper_cmd = "out-of-sync";
 		}
@@ -892,7 +892,7 @@ int drbd_resync_finished(struct drbd_device *device)
 			const int ratio =
 				(t == 0)     ? 0 :
 			(t < 100000) ? ((s*100)/t) : (s/(t/100));
-			dev_info(DEV, "%u %% had equal checksums, eliminated: %luK; "
+			drbd_info(device, "%u %% had equal checksums, eliminated: %luK; "
 			     "transferred %luK total %luK\n",
 			     ratio,
 			     Bit2KB(device->rs_same_csum),
@@ -902,7 +902,7 @@ int drbd_resync_finished(struct drbd_device *device)
 	}
 
 	if (device->rs_failed) {
-		dev_info(DEV, "            %lu failed blocks\n", device->rs_failed);
+		drbd_info(device, "            %lu failed blocks\n", device->rs_failed);
 
 		if (os.conn == C_SYNC_TARGET || os.conn == C_PAUSED_SYNC_T) {
 			ns.disk = D_INCONSISTENT;
@@ -923,7 +923,7 @@ int drbd_resync_finished(struct drbd_device *device)
 				drbd_uuid_set(device, UI_BITMAP, device->ldev->md.uuid[UI_CURRENT]);
 				_drbd_uuid_set(device, UI_CURRENT, device->p_uuid[UI_CURRENT]);
 			} else {
-				dev_err(DEV, "device->p_uuid is NULL! BUG\n");
+				drbd_err(device, "device->p_uuid is NULL! BUG\n");
 			}
 		}
 
@@ -1001,7 +1001,7 @@ int w_e_end_data_req(struct drbd_work *w, int cancel)
 		err = drbd_send_block(device, P_DATA_REPLY, peer_req);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
-			dev_err(DEV, "Sending NegDReply. sector=%llus.\n",
+			drbd_err(device, "Sending NegDReply. sector=%llus.\n",
 			    (unsigned long long)peer_req->i.sector);
 
 		err = drbd_send_ack(device, P_NEG_DREPLY, peer_req);
@@ -1012,7 +1012,7 @@ int w_e_end_data_req(struct drbd_work *w, int cancel)
 	move_to_net_ee_or_free(device, peer_req);
 
 	if (unlikely(err))
-		dev_err(DEV, "drbd_send_block() failed\n");
+		drbd_err(device, "drbd_send_block() failed\n");
 	return err;
 }
 
@@ -1047,13 +1047,13 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 			err = drbd_send_block(device, P_RS_DATA_REPLY, peer_req);
 		} else {
 			if (__ratelimit(&drbd_ratelimit_state))
-				dev_err(DEV, "Not sending RSDataReply, "
+				drbd_err(device, "Not sending RSDataReply, "
 				    "partner DISKLESS!\n");
 			err = 0;
 		}
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
-			dev_err(DEV, "Sending NegRSDReply. sector %llus.\n",
+			drbd_err(device, "Sending NegRSDReply. sector %llus.\n",
 			    (unsigned long long)peer_req->i.sector);
 
 		err = drbd_send_ack(device, P_NEG_RS_DREPLY, peer_req);
@@ -1067,7 +1067,7 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 	move_to_net_ee_or_free(device, peer_req);
 
 	if (unlikely(err))
-		dev_err(DEV, "drbd_send_block() failed\n");
+		drbd_err(device, "drbd_send_block() failed\n");
 	return err;
 }
 
@@ -1123,14 +1123,14 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 	} else {
 		err = drbd_send_ack(device, P_NEG_RS_DREPLY, peer_req);
 		if (__ratelimit(&drbd_ratelimit_state))
-			dev_err(DEV, "Sending NegDReply. I guess it gets messy.\n");
+			drbd_err(device, "Sending NegDReply. I guess it gets messy.\n");
 	}
 
 	dec_unacked(device);
 	move_to_net_ee_or_free(device, peer_req);
 
 	if (unlikely(err))
-		dev_err(DEV, "drbd_send_block/ack() failed\n");
+		drbd_err(device, "drbd_send_block/ack() failed\n");
 	return err;
 }
 
@@ -1590,7 +1590,7 @@ int w_start_resync(struct drbd_work *w, int cancel)
 	struct drbd_device *device = w->device;
 
 	if (atomic_read(&device->unacked_cnt) || atomic_read(&device->rs_pending_cnt)) {
-		dev_warn(DEV, "w_start_resync later...\n");
+		drbd_warn(device, "w_start_resync later...\n");
 		device->start_resync_timer.expires = jiffies + HZ/10;
 		add_timer(&device->start_resync_timer);
 		return 0;
@@ -1615,7 +1615,7 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 	int r;
 
 	if (device->state.conn >= C_SYNC_SOURCE && device->state.conn < C_AHEAD) {
-		dev_err(DEV, "Resync already running!\n");
+		drbd_err(device, "Resync already running!\n");
 		return;
 	}
 
@@ -1627,7 +1627,7 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 			r = drbd_khelper(device, "before-resync-target");
 			r = (r >> 8) & 0xff;
 			if (r > 0) {
-				dev_info(DEV, "before-resync-target handler returned %d, "
+				drbd_info(device, "before-resync-target handler returned %d, "
 					 "dropping connection.\n", r);
 				conn_request_state(first_peer_device(device)->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 				return;
@@ -1637,10 +1637,10 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 			r = (r >> 8) & 0xff;
 			if (r > 0) {
 				if (r == 3) {
-					dev_info(DEV, "before-resync-source handler returned %d, "
+					drbd_info(device, "before-resync-source handler returned %d, "
 						 "ignoring. Old userland tools?", r);
 				} else {
-					dev_info(DEV, "before-resync-source handler returned %d, "
+					drbd_info(device, "before-resync-source handler returned %d, "
 						 "dropping connection.\n", r);
 					conn_request_state(first_peer_device(device)->connection,
 							   NS(conn, C_DISCONNECTING), CS_HARD);
@@ -1715,7 +1715,7 @@ void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 		 * to deal with potential jiffies wrap. */
 		device->rs_last_bcast = jiffies - HZ;
 
-		dev_info(DEV, "Began resync as %s (will sync %lu KB [%lu bits set]).\n",
+		drbd_info(device, "Began resync as %s (will sync %lu KB [%lu bits set]).\n",
 		     drbd_conn_str(ns.conn),
 		     (unsigned long) device->rs_total << (BM_BLOCK_SHIFT-10),
 		     (unsigned long) device->rs_total);
-- 
1.7.9.5

