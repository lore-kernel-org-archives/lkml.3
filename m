Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab3LTMkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:40:45 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38632 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab3LTMjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:37 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/26] drbd: Rename "mdev" to "device"
Date: Fri, 20 Dec 2013 13:29:03 +0100
Message-Id: <1387542563-6833-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

sed -i -e 's:mdev:device:g'

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |  544 ++++++-------
 drivers/block/drbd/drbd_bitmap.c   |  300 ++++----
 drivers/block/drbd/drbd_int.h      |  484 ++++++------
 drivers/block/drbd/drbd_main.c     | 1186 ++++++++++++++--------------
 drivers/block/drbd/drbd_nl.c       |  938 +++++++++++------------
 drivers/block/drbd/drbd_proc.c     |  138 ++--
 drivers/block/drbd/drbd_receiver.c | 1485 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_req.c      |  348 ++++-----
 drivers/block/drbd/drbd_req.h      |   14 +-
 drivers/block/drbd/drbd_state.c    |  610 +++++++--------
 drivers/block/drbd/drbd_state.h    |   10 +-
 drivers/block/drbd/drbd_worker.c   |  736 +++++++++---------
 drivers/block/drbd/drbd_wrappers.h |   14 +-
 13 files changed, 3404 insertions(+), 3403 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index d5f1188..f718484 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -105,24 +105,24 @@ struct update_al_work {
 };
 
 
-void *drbd_md_get_buffer(struct drbd_device *mdev)
+void *drbd_md_get_buffer(struct drbd_device *device)
 {
 	int r;
 
-	wait_event(mdev->misc_wait,
-		   (r = atomic_cmpxchg(&mdev->md_io_in_use, 0, 1)) == 0 ||
-		   mdev->state.disk <= D_FAILED);
+	wait_event(device->misc_wait,
+		   (r = atomic_cmpxchg(&device->md_io_in_use, 0, 1)) == 0 ||
+		   device->state.disk <= D_FAILED);
 
-	return r ? NULL : page_address(mdev->md_io_page);
+	return r ? NULL : page_address(device->md_io_page);
 }
 
-void drbd_md_put_buffer(struct drbd_device *mdev)
+void drbd_md_put_buffer(struct drbd_device *device)
 {
-	if (atomic_dec_and_test(&mdev->md_io_in_use))
-		wake_up(&mdev->misc_wait);
+	if (atomic_dec_and_test(&device->md_io_in_use))
+		wake_up(&device->misc_wait);
 }
 
-void wait_until_done_or_force_detached(struct drbd_device *mdev, struct drbd_backing_dev *bdev,
+void wait_until_done_or_force_detached(struct drbd_device *device, struct drbd_backing_dev *bdev,
 				     unsigned int *done)
 {
 	long dt;
@@ -134,15 +134,15 @@ void wait_until_done_or_force_detached(struct drbd_device *mdev, struct drbd_bac
 	if (dt == 0)
 		dt = MAX_SCHEDULE_TIMEOUT;
 
-	dt = wait_event_timeout(mdev->misc_wait,
-			*done || test_bit(FORCE_DETACH, &mdev->flags), dt);
+	dt = wait_event_timeout(device->misc_wait,
+			*done || test_bit(FORCE_DETACH, &device->flags), dt);
 	if (dt == 0) {
 		dev_err(DEV, "meta-data IO operation timed out\n");
-		drbd_chk_io_error(mdev, 1, DRBD_FORCE_DETACH);
+		drbd_chk_io_error(device, 1, DRBD_FORCE_DETACH);
 	}
 }
 
-static int _drbd_md_sync_page_io(struct drbd_device *mdev,
+static int _drbd_md_sync_page_io(struct drbd_device *device,
 				 struct drbd_backing_dev *bdev,
 				 struct page *page, sector_t sector,
 				 int rw, int size)
@@ -150,10 +150,10 @@ static int _drbd_md_sync_page_io(struct drbd_device *mdev,
 	struct bio *bio;
 	int err;
 
-	mdev->md_io.done = 0;
-	mdev->md_io.error = -ENODEV;
+	device->md_io.done = 0;
+	device->md_io.error = -ENODEV;
 
-	if ((rw & WRITE) && !test_bit(MD_NO_FUA, &mdev->flags))
+	if ((rw & WRITE) && !test_bit(MD_NO_FUA, &device->flags))
 		rw |= REQ_FUA | REQ_FLUSH;
 	rw |= REQ_SYNC;
 
@@ -163,14 +163,14 @@ static int _drbd_md_sync_page_io(struct drbd_device *mdev,
 	err = -EIO;
 	if (bio_add_page(bio, page, size, 0) != size)
 		goto out;
-	bio->bi_private = &mdev->md_io;
+	bio->bi_private = &device->md_io;
 	bio->bi_end_io = drbd_md_io_complete;
 	bio->bi_rw = rw;
 
-	if (!(rw & WRITE) && mdev->state.disk == D_DISKLESS && mdev->ldev == NULL)
+	if (!(rw & WRITE) && device->state.disk == D_DISKLESS && device->ldev == NULL)
 		/* special case, drbd_md_read() during drbd_adm_attach(): no get_ldev */
 		;
-	else if (!get_ldev_if_state(mdev, D_ATTACHING)) {
+	else if (!get_ldev_if_state(device, D_ATTACHING)) {
 		/* Corresponding put_ldev in drbd_md_io_complete() */
 		dev_err(DEV, "ASSERT FAILED: get_ldev_if_state() == 1 in _drbd_md_sync_page_io()\n");
 		err = -ENODEV;
@@ -178,27 +178,27 @@ static int _drbd_md_sync_page_io(struct drbd_device *mdev,
 	}
 
 	bio_get(bio); /* one bio_put() is in the completion handler */
-	atomic_inc(&mdev->md_io_in_use); /* drbd_md_put_buffer() is in the completion handler */
-	if (drbd_insert_fault(mdev, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD))
+	atomic_inc(&device->md_io_in_use); /* drbd_md_put_buffer() is in the completion handler */
+	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD))
 		bio_endio(bio, -EIO);
 	else
 		submit_bio(rw, bio);
-	wait_until_done_or_force_detached(mdev, bdev, &mdev->md_io.done);
+	wait_until_done_or_force_detached(device, bdev, &device->md_io.done);
 	if (bio_flagged(bio, BIO_UPTODATE))
-		err = mdev->md_io.error;
+		err = device->md_io.error;
 
  out:
 	bio_put(bio);
 	return err;
 }
 
-int drbd_md_sync_page_io(struct drbd_device *mdev, struct drbd_backing_dev *bdev,
+int drbd_md_sync_page_io(struct drbd_device *device, struct drbd_backing_dev *bdev,
 			 sector_t sector, int rw)
 {
 	int err;
-	struct page *iop = mdev->md_io_page;
+	struct page *iop = device->md_io_page;
 
-	D_ASSERT(atomic_read(&mdev->md_io_in_use) == 1);
+	D_ASSERT(atomic_read(&device->md_io_in_use) == 1);
 
 	BUG_ON(!bdev->md_bdev);
 
@@ -214,7 +214,7 @@ int drbd_md_sync_page_io(struct drbd_device *mdev, struct drbd_backing_dev *bdev
 		     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
 
 	/* we do all our meta data IO in aligned 4k blocks. */
-	err = _drbd_md_sync_page_io(mdev, bdev, iop, sector, rw, 4096);
+	err = _drbd_md_sync_page_io(device, bdev, iop, sector, rw, 4096);
 	if (err) {
 		dev_err(DEV, "drbd_md_sync_page_io(,%llus,%s) failed with error %d\n",
 		    (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ", err);
@@ -222,10 +222,10 @@ int drbd_md_sync_page_io(struct drbd_device *mdev, struct drbd_backing_dev *bdev
 	return err;
 }
 
-static struct bm_extent *find_active_resync_extent(struct drbd_device *mdev, unsigned int enr)
+static struct bm_extent *find_active_resync_extent(struct drbd_device *device, unsigned int enr)
 {
 	struct lc_element *tmp;
-	tmp = lc_find(mdev->resync, enr/AL_EXT_PER_BM_SECT);
+	tmp = lc_find(device->resync, enr/AL_EXT_PER_BM_SECT);
 	if (unlikely(tmp != NULL)) {
 		struct bm_extent  *bm_ext = lc_entry(tmp, struct bm_extent, lce);
 		if (test_bit(BME_NO_WRITES, &bm_ext->flags))
@@ -234,30 +234,30 @@ static struct bm_extent *find_active_resync_extent(struct drbd_device *mdev, uns
 	return NULL;
 }
 
-static struct lc_element *_al_get(struct drbd_device *mdev, unsigned int enr, bool nonblock)
+static struct lc_element *_al_get(struct drbd_device *device, unsigned int enr, bool nonblock)
 {
 	struct lc_element *al_ext;
 	struct bm_extent *bm_ext;
 	int wake;
 
-	spin_lock_irq(&mdev->al_lock);
-	bm_ext = find_active_resync_extent(mdev, enr);
+	spin_lock_irq(&device->al_lock);
+	bm_ext = find_active_resync_extent(device, enr);
 	if (bm_ext) {
 		wake = !test_and_set_bit(BME_PRIORITY, &bm_ext->flags);
-		spin_unlock_irq(&mdev->al_lock);
+		spin_unlock_irq(&device->al_lock);
 		if (wake)
-			wake_up(&mdev->al_wait);
+			wake_up(&device->al_wait);
 		return NULL;
 	}
 	if (nonblock)
-		al_ext = lc_try_get(mdev->act_log, enr);
+		al_ext = lc_try_get(device->act_log, enr);
 	else
-		al_ext = lc_get(mdev->act_log, enr);
-	spin_unlock_irq(&mdev->al_lock);
+		al_ext = lc_get(device->act_log, enr);
+	spin_unlock_irq(&device->al_lock);
 	return al_ext;
 }
 
-bool drbd_al_begin_io_fastpath(struct drbd_device *mdev, struct drbd_interval *i)
+bool drbd_al_begin_io_fastpath(struct drbd_device *device, struct drbd_interval *i)
 {
 	/* for bios crossing activity log extent boundaries,
 	 * we may need to activate two extents in one go */
@@ -265,16 +265,16 @@ bool drbd_al_begin_io_fastpath(struct drbd_device *mdev, struct drbd_interval *i
 	unsigned last = i->size == 0 ? first : (i->sector + (i->size >> 9) - 1) >> (AL_EXTENT_SHIFT-9);
 
 	D_ASSERT((unsigned)(last - first) <= 1);
-	D_ASSERT(atomic_read(&mdev->local_cnt) > 0);
+	D_ASSERT(atomic_read(&device->local_cnt) > 0);
 
 	/* FIXME figure out a fast path for bios crossing AL extent boundaries */
 	if (first != last)
 		return false;
 
-	return _al_get(mdev, first, true);
+	return _al_get(device, first, true);
 }
 
-bool drbd_al_begin_io_prepare(struct drbd_device *mdev, struct drbd_interval *i)
+bool drbd_al_begin_io_prepare(struct drbd_device *device, struct drbd_interval *i)
 {
 	/* for bios crossing activity log extent boundaries,
 	 * we may need to activate two extents in one go */
@@ -284,19 +284,19 @@ bool drbd_al_begin_io_prepare(struct drbd_device *mdev, struct drbd_interval *i)
 	bool need_transaction = false;
 
 	D_ASSERT(first <= last);
-	D_ASSERT(atomic_read(&mdev->local_cnt) > 0);
+	D_ASSERT(atomic_read(&device->local_cnt) > 0);
 
 	for (enr = first; enr <= last; enr++) {
 		struct lc_element *al_ext;
-		wait_event(mdev->al_wait,
-				(al_ext = _al_get(mdev, enr, false)) != NULL);
+		wait_event(device->al_wait,
+				(al_ext = _al_get(device, enr, false)) != NULL);
 		if (al_ext->lc_number != enr)
 			need_transaction = true;
 	}
 	return need_transaction;
 }
 
-static int al_write_transaction(struct drbd_device *mdev, bool delegate);
+static int al_write_transaction(struct drbd_device *device, bool delegate);
 
 /* When called through generic_make_request(), we must delegate
  * activity log I/O to the worker thread: a further request
@@ -310,58 +310,58 @@ static int al_write_transaction(struct drbd_device *mdev, bool delegate);
 /*
  * @delegate:   delegate activity log I/O to the worker thread
  */
-void drbd_al_begin_io_commit(struct drbd_device *mdev, bool delegate)
+void drbd_al_begin_io_commit(struct drbd_device *device, bool delegate)
 {
 	bool locked = false;
 
-	BUG_ON(delegate && current == mdev->tconn->worker.task);
+	BUG_ON(delegate && current == device->tconn->worker.task);
 
 	/* Serialize multiple transactions.
 	 * This uses test_and_set_bit, memory barrier is implicit.
 	 */
-	wait_event(mdev->al_wait,
-			mdev->act_log->pending_changes == 0 ||
-			(locked = lc_try_lock_for_transaction(mdev->act_log)));
+	wait_event(device->al_wait,
+			device->act_log->pending_changes == 0 ||
+			(locked = lc_try_lock_for_transaction(device->act_log)));
 
 	if (locked) {
 		/* Double check: it may have been committed by someone else,
 		 * while we have been waiting for the lock. */
-		if (mdev->act_log->pending_changes) {
+		if (device->act_log->pending_changes) {
 			bool write_al_updates;
 
 			rcu_read_lock();
-			write_al_updates = rcu_dereference(mdev->ldev->disk_conf)->al_updates;
+			write_al_updates = rcu_dereference(device->ldev->disk_conf)->al_updates;
 			rcu_read_unlock();
 
 			if (write_al_updates)
-				al_write_transaction(mdev, delegate);
-			spin_lock_irq(&mdev->al_lock);
+				al_write_transaction(device, delegate);
+			spin_lock_irq(&device->al_lock);
 			/* FIXME
 			if (err)
 				we need an "lc_cancel" here;
 			*/
-			lc_committed(mdev->act_log);
-			spin_unlock_irq(&mdev->al_lock);
+			lc_committed(device->act_log);
+			spin_unlock_irq(&device->al_lock);
 		}
-		lc_unlock(mdev->act_log);
-		wake_up(&mdev->al_wait);
+		lc_unlock(device->act_log);
+		wake_up(&device->al_wait);
 	}
 }
 
 /*
  * @delegate:   delegate activity log I/O to the worker thread
  */
-void drbd_al_begin_io(struct drbd_device *mdev, struct drbd_interval *i, bool delegate)
+void drbd_al_begin_io(struct drbd_device *device, struct drbd_interval *i, bool delegate)
 {
-	BUG_ON(delegate && current == mdev->tconn->worker.task);
+	BUG_ON(delegate && current == device->tconn->worker.task);
 
-	if (drbd_al_begin_io_prepare(mdev, i))
-		drbd_al_begin_io_commit(mdev, delegate);
+	if (drbd_al_begin_io_prepare(device, i))
+		drbd_al_begin_io_commit(device, delegate);
 }
 
-int drbd_al_begin_io_nonblock(struct drbd_device *mdev, struct drbd_interval *i)
+int drbd_al_begin_io_nonblock(struct drbd_device *device, struct drbd_interval *i)
 {
-	struct lru_cache *al = mdev->act_log;
+	struct lru_cache *al = device->act_log;
 	/* for bios crossing activity log extent boundaries,
 	 * we may need to activate two extents in one go */
 	unsigned first = i->sector >> (AL_EXTENT_SHIFT-9);
@@ -385,7 +385,7 @@ int drbd_al_begin_io_nonblock(struct drbd_device *mdev, struct drbd_interval *i)
 	/* Is resync active in this area? */
 	for (enr = first; enr <= last; enr++) {
 		struct lc_element *tmp;
-		tmp = lc_find(mdev->resync, enr/AL_EXT_PER_BM_SECT);
+		tmp = lc_find(device->resync, enr/AL_EXT_PER_BM_SECT);
 		if (unlikely(tmp != NULL)) {
 			struct bm_extent  *bm_ext = lc_entry(tmp, struct bm_extent, lce);
 			if (test_bit(BME_NO_WRITES, &bm_ext->flags)) {
@@ -401,14 +401,14 @@ int drbd_al_begin_io_nonblock(struct drbd_device *mdev, struct drbd_interval *i)
 	 * this has to be successful. */
 	for (enr = first; enr <= last; enr++) {
 		struct lc_element *al_ext;
-		al_ext = lc_get_cumulative(mdev->act_log, enr);
+		al_ext = lc_get_cumulative(device->act_log, enr);
 		if (!al_ext)
 			dev_info(DEV, "LOGIC BUG for enr=%u\n", enr);
 	}
 	return 0;
 }
 
-void drbd_al_complete_io(struct drbd_device *mdev, struct drbd_interval *i)
+void drbd_al_complete_io(struct drbd_device *device, struct drbd_interval *i)
 {
 	/* for bios crossing activity log extent boundaries,
 	 * we may need to activate two extents in one go */
@@ -419,18 +419,18 @@ void drbd_al_complete_io(struct drbd_device *mdev, struct drbd_interval *i)
 	unsigned long flags;
 
 	D_ASSERT(first <= last);
-	spin_lock_irqsave(&mdev->al_lock, flags);
+	spin_lock_irqsave(&device->al_lock, flags);
 
 	for (enr = first; enr <= last; enr++) {
-		extent = lc_find(mdev->act_log, enr);
+		extent = lc_find(device->act_log, enr);
 		if (!extent) {
 			dev_err(DEV, "al_complete_io() called on inactive extent %u\n", enr);
 			continue;
 		}
-		lc_put(mdev->act_log, extent);
+		lc_put(device->act_log, extent);
 	}
-	spin_unlock_irqrestore(&mdev->al_lock, flags);
-	wake_up(&mdev->al_wait);
+	spin_unlock_irqrestore(&device->al_lock, flags);
+	wake_up(&device->al_wait);
 }
 
 #if (PAGE_SHIFT + 3) < (AL_EXTENT_SHIFT - BM_BLOCK_SHIFT)
@@ -460,13 +460,13 @@ static unsigned int rs_extent_to_bm_page(unsigned int rs_enr)
 		 (BM_EXT_SHIFT - BM_BLOCK_SHIFT));
 }
 
-static sector_t al_tr_number_to_on_disk_sector(struct drbd_device *mdev)
+static sector_t al_tr_number_to_on_disk_sector(struct drbd_device *device)
 {
-	const unsigned int stripes = mdev->ldev->md.al_stripes;
-	const unsigned int stripe_size_4kB = mdev->ldev->md.al_stripe_size_4k;
+	const unsigned int stripes = device->ldev->md.al_stripes;
+	const unsigned int stripe_size_4kB = device->ldev->md.al_stripe_size_4k;
 
 	/* transaction number, modulo on-disk ring buffer wrap around */
-	unsigned int t = mdev->al_tr_number % (mdev->ldev->md.al_size_4k);
+	unsigned int t = device->al_tr_number % (device->ldev->md.al_size_4k);
 
 	/* ... to aligned 4k on disk block */
 	t = ((t % stripes) * stripe_size_4kB) + t/stripes;
@@ -475,11 +475,11 @@ static sector_t al_tr_number_to_on_disk_sector(struct drbd_device *mdev)
 	t *= 8;
 
 	/* ... plus offset to the on disk position */
-	return mdev->ldev->md.md_offset + mdev->ldev->md.al_offset + t;
+	return device->ldev->md.md_offset + device->ldev->md.al_offset + t;
 }
 
 static int
-_al_write_transaction(struct drbd_device *mdev)
+_al_write_transaction(struct drbd_device *device)
 {
 	struct al_transaction_on_disk *buffer;
 	struct lc_element *e;
@@ -489,31 +489,31 @@ _al_write_transaction(struct drbd_device *mdev)
 	unsigned crc = 0;
 	int err = 0;
 
-	if (!get_ldev(mdev)) {
+	if (!get_ldev(device)) {
 		dev_err(DEV, "disk is %s, cannot start al transaction\n",
-			drbd_disk_str(mdev->state.disk));
+			drbd_disk_str(device->state.disk));
 		return -EIO;
 	}
 
 	/* The bitmap write may have failed, causing a state change. */
-	if (mdev->state.disk < D_INCONSISTENT) {
+	if (device->state.disk < D_INCONSISTENT) {
 		dev_err(DEV,
 			"disk is %s, cannot write al transaction\n",
-			drbd_disk_str(mdev->state.disk));
-		put_ldev(mdev);
+			drbd_disk_str(device->state.disk));
+		put_ldev(device);
 		return -EIO;
 	}
 
-	buffer = drbd_md_get_buffer(mdev); /* protects md_io_buffer, al_tr_cycle, ... */
+	buffer = drbd_md_get_buffer(device); /* protects md_io_buffer, al_tr_cycle, ... */
 	if (!buffer) {
 		dev_err(DEV, "disk failed while waiting for md_io buffer\n");
-		put_ldev(mdev);
+		put_ldev(device);
 		return -ENODEV;
 	}
 
 	memset(buffer, 0, sizeof(*buffer));
 	buffer->magic = cpu_to_be32(DRBD_AL_MAGIC);
-	buffer->tr_number = cpu_to_be32(mdev->al_tr_number);
+	buffer->tr_number = cpu_to_be32(device->al_tr_number);
 
 	i = 0;
 
@@ -521,8 +521,8 @@ _al_write_transaction(struct drbd_device *mdev)
 	 * once we set the LC_LOCKED -- from drbd_al_begin_io(),
 	 * lc_try_lock_for_transaction() --, someone may still
 	 * be in the process of changing it. */
-	spin_lock_irq(&mdev->al_lock);
-	list_for_each_entry(e, &mdev->act_log->to_be_changed, list) {
+	spin_lock_irq(&device->al_lock);
+	list_for_each_entry(e, &device->act_log->to_be_changed, list) {
 		if (i == AL_UPDATES_PER_TRANSACTION) {
 			i++;
 			break;
@@ -530,11 +530,11 @@ _al_write_transaction(struct drbd_device *mdev)
 		buffer->update_slot_nr[i] = cpu_to_be16(e->lc_index);
 		buffer->update_extent_nr[i] = cpu_to_be32(e->lc_new_number);
 		if (e->lc_number != LC_FREE)
-			drbd_bm_mark_for_writeout(mdev,
+			drbd_bm_mark_for_writeout(device,
 					al_extent_to_bm_page(e->lc_number));
 		i++;
 	}
-	spin_unlock_irq(&mdev->al_lock);
+	spin_unlock_irq(&device->al_lock);
 	BUG_ON(i > AL_UPDATES_PER_TRANSACTION);
 
 	buffer->n_updates = cpu_to_be16(i);
@@ -543,48 +543,48 @@ _al_write_transaction(struct drbd_device *mdev)
 		buffer->update_extent_nr[i] = cpu_to_be32(LC_FREE);
 	}
 
-	buffer->context_size = cpu_to_be16(mdev->act_log->nr_elements);
-	buffer->context_start_slot_nr = cpu_to_be16(mdev->al_tr_cycle);
+	buffer->context_size = cpu_to_be16(device->act_log->nr_elements);
+	buffer->context_start_slot_nr = cpu_to_be16(device->al_tr_cycle);
 
 	mx = min_t(int, AL_CONTEXT_PER_TRANSACTION,
-		   mdev->act_log->nr_elements - mdev->al_tr_cycle);
+		   device->act_log->nr_elements - device->al_tr_cycle);
 	for (i = 0; i < mx; i++) {
-		unsigned idx = mdev->al_tr_cycle + i;
-		extent_nr = lc_element_by_index(mdev->act_log, idx)->lc_number;
+		unsigned idx = device->al_tr_cycle + i;
+		extent_nr = lc_element_by_index(device->act_log, idx)->lc_number;
 		buffer->context[i] = cpu_to_be32(extent_nr);
 	}
 	for (; i < AL_CONTEXT_PER_TRANSACTION; i++)
 		buffer->context[i] = cpu_to_be32(LC_FREE);
 
-	mdev->al_tr_cycle += AL_CONTEXT_PER_TRANSACTION;
-	if (mdev->al_tr_cycle >= mdev->act_log->nr_elements)
-		mdev->al_tr_cycle = 0;
+	device->al_tr_cycle += AL_CONTEXT_PER_TRANSACTION;
+	if (device->al_tr_cycle >= device->act_log->nr_elements)
+		device->al_tr_cycle = 0;
 
-	sector = al_tr_number_to_on_disk_sector(mdev);
+	sector = al_tr_number_to_on_disk_sector(device);
 
 	crc = crc32c(0, buffer, 4096);
 	buffer->crc32c = cpu_to_be32(crc);
 
-	if (drbd_bm_write_hinted(mdev))
+	if (drbd_bm_write_hinted(device))
 		err = -EIO;
 	else {
 		bool write_al_updates;
 		rcu_read_lock();
-		write_al_updates = rcu_dereference(mdev->ldev->disk_conf)->al_updates;
+		write_al_updates = rcu_dereference(device->ldev->disk_conf)->al_updates;
 		rcu_read_unlock();
 		if (write_al_updates) {
-			if (drbd_md_sync_page_io(mdev, mdev->ldev, sector, WRITE)) {
+			if (drbd_md_sync_page_io(device, device->ldev, sector, WRITE)) {
 				err = -EIO;
-				drbd_chk_io_error(mdev, 1, DRBD_META_IO_ERROR);
+				drbd_chk_io_error(device, 1, DRBD_META_IO_ERROR);
 			} else {
-				mdev->al_tr_number++;
-				mdev->al_writ_cnt++;
+				device->al_tr_number++;
+				device->al_writ_cnt++;
 			}
 		}
 	}
 
-	drbd_md_put_buffer(mdev);
-	put_ldev(mdev);
+	drbd_md_put_buffer(device);
+	put_ldev(device);
 
 	return err;
 }
@@ -593,10 +593,10 @@ _al_write_transaction(struct drbd_device *mdev)
 static int w_al_write_transaction(struct drbd_work *w, int unused)
 {
 	struct update_al_work *aw = container_of(w, struct update_al_work, w);
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	int err;
 
-	err = _al_write_transaction(mdev);
+	err = _al_write_transaction(device);
 	aw->err = err;
 	complete(&aw->event);
 
@@ -606,63 +606,63 @@ static int w_al_write_transaction(struct drbd_work *w, int unused)
 /* Calls from worker context (see w_restart_disk_io()) need to write the
    transaction directly. Others came through generic_make_request(),
    those need to delegate it to the worker. */
-static int al_write_transaction(struct drbd_device *mdev, bool delegate)
+static int al_write_transaction(struct drbd_device *device, bool delegate)
 {
 	if (delegate) {
 		struct update_al_work al_work;
 		init_completion(&al_work.event);
 		al_work.w.cb = w_al_write_transaction;
-		al_work.w.mdev = mdev;
-		drbd_queue_work_front(&mdev->tconn->sender_work, &al_work.w);
+		al_work.w.device = device;
+		drbd_queue_work_front(&device->tconn->sender_work, &al_work.w);
 		wait_for_completion(&al_work.event);
 		return al_work.err;
 	} else
-		return _al_write_transaction(mdev);
+		return _al_write_transaction(device);
 }
 
-static int _try_lc_del(struct drbd_device *mdev, struct lc_element *al_ext)
+static int _try_lc_del(struct drbd_device *device, struct lc_element *al_ext)
 {
 	int rv;
 
-	spin_lock_irq(&mdev->al_lock);
+	spin_lock_irq(&device->al_lock);
 	rv = (al_ext->refcnt == 0);
 	if (likely(rv))
-		lc_del(mdev->act_log, al_ext);
-	spin_unlock_irq(&mdev->al_lock);
+		lc_del(device->act_log, al_ext);
+	spin_unlock_irq(&device->al_lock);
 
 	return rv;
 }
 
 /**
  * drbd_al_shrink() - Removes all active extents form the activity log
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Removes all active extents form the activity log, waiting until
  * the reference count of each entry dropped to 0 first, of course.
  *
- * You need to lock mdev->act_log with lc_try_lock() / lc_unlock()
+ * You need to lock device->act_log with lc_try_lock() / lc_unlock()
  */
-void drbd_al_shrink(struct drbd_device *mdev)
+void drbd_al_shrink(struct drbd_device *device)
 {
 	struct lc_element *al_ext;
 	int i;
 
-	D_ASSERT(test_bit(__LC_LOCKED, &mdev->act_log->flags));
+	D_ASSERT(test_bit(__LC_LOCKED, &device->act_log->flags));
 
-	for (i = 0; i < mdev->act_log->nr_elements; i++) {
-		al_ext = lc_element_by_index(mdev->act_log, i);
+	for (i = 0; i < device->act_log->nr_elements; i++) {
+		al_ext = lc_element_by_index(device->act_log, i);
 		if (al_ext->lc_number == LC_FREE)
 			continue;
-		wait_event(mdev->al_wait, _try_lc_del(mdev, al_ext));
+		wait_event(device->al_wait, _try_lc_del(device, al_ext));
 	}
 
-	wake_up(&mdev->al_wait);
+	wake_up(&device->al_wait);
 }
 
-int drbd_initialize_al(struct drbd_device *mdev, void *buffer)
+int drbd_initialize_al(struct drbd_device *device, void *buffer)
 {
 	struct al_transaction_on_disk *al = buffer;
-	struct drbd_md *md = &mdev->ldev->md;
+	struct drbd_md *md = &device->ldev->md;
 	sector_t al_base = md->md_offset + md->al_offset;
 	int al_size_4k = md->al_stripes * md->al_stripe_size_4k;
 	int i;
@@ -673,7 +673,7 @@ int drbd_initialize_al(struct drbd_device *mdev, void *buffer)
 	al->crc32c = cpu_to_be32(crc32c(0, al, 4096));
 
 	for (i = 0; i < al_size_4k; i++) {
-		int err = drbd_md_sync_page_io(mdev, mdev->ldev, al_base + i * 8, WRITE);
+		int err = drbd_md_sync_page_io(device, device->ldev, al_base + i * 8, WRITE);
 		if (err)
 			return err;
 	}
@@ -683,32 +683,32 @@ int drbd_initialize_al(struct drbd_device *mdev, void *buffer)
 static int w_update_odbm(struct drbd_work *w, int unused)
 {
 	struct update_odbm_work *udw = container_of(w, struct update_odbm_work, w);
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	struct sib_info sib = { .sib_reason = SIB_SYNC_PROGRESS, };
 
-	if (!get_ldev(mdev)) {
+	if (!get_ldev(device)) {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_warn(DEV, "Can not update on disk bitmap, local IO disabled.\n");
 		kfree(udw);
 		return 0;
 	}
 
-	drbd_bm_write_page(mdev, rs_extent_to_bm_page(udw->enr));
-	put_ldev(mdev);
+	drbd_bm_write_page(device, rs_extent_to_bm_page(udw->enr));
+	put_ldev(device);
 
 	kfree(udw);
 
-	if (drbd_bm_total_weight(mdev) <= mdev->rs_failed) {
-		switch (mdev->state.conn) {
+	if (drbd_bm_total_weight(device) <= device->rs_failed) {
+		switch (device->state.conn) {
 		case C_SYNC_SOURCE:  case C_SYNC_TARGET:
 		case C_PAUSED_SYNC_S: case C_PAUSED_SYNC_T:
-			drbd_resync_finished(mdev);
+			drbd_resync_finished(device);
 		default:
 			/* nothing to do */
 			break;
 		}
 	}
-	drbd_bcast_event(mdev, &sib);
+	drbd_bcast_event(device, &sib);
 
 	return 0;
 }
@@ -720,7 +720,7 @@ static int w_update_odbm(struct drbd_work *w, int unused)
  *
  * TODO will be obsoleted once we have a caching lru of the on disk bitmap
  */
-static void drbd_try_clear_on_disk_bm(struct drbd_device *mdev, sector_t sector,
+static void drbd_try_clear_on_disk_bm(struct drbd_device *device, sector_t sector,
 				      int count, int success)
 {
 	struct lc_element *e;
@@ -728,13 +728,13 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *mdev, sector_t sector,
 
 	unsigned int enr;
 
-	D_ASSERT(atomic_read(&mdev->local_cnt));
+	D_ASSERT(atomic_read(&device->local_cnt));
 
 	/* I simply assume that a sector/size pair never crosses
 	 * a 16 MB extent border. (Currently this is true...) */
 	enr = BM_SECT_TO_EXT(sector);
 
-	e = lc_get(mdev->resync, enr);
+	e = lc_get(device->resync, enr);
 	if (e) {
 		struct bm_extent *ext = lc_entry(e, struct bm_extent, lce);
 		if (ext->lce.lc_number == enr) {
@@ -748,7 +748,7 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *mdev, sector_t sector,
 				     (unsigned long long)sector,
 				     ext->lce.lc_number, ext->rs_left,
 				     ext->rs_failed, count,
-				     drbd_conn_str(mdev->state.conn));
+				     drbd_conn_str(device->state.conn));
 
 				/* We don't expect to be able to clear more bits
 				 * than have been set when we originally counted
@@ -756,7 +756,7 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *mdev, sector_t sector,
 				 * Whatever the reason (disconnect during resync,
 				 * delayed local completion of an application write),
 				 * try to fix it up by recounting here. */
-				ext->rs_left = drbd_bm_e_weight(mdev, enr);
+				ext->rs_left = drbd_bm_e_weight(device, enr);
 			}
 		} else {
 			/* Normally this element should be in the cache,
@@ -765,7 +765,7 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *mdev, sector_t sector,
 			 * But maybe an application write finished, and we set
 			 * something outside the resync lru_cache in sync.
 			 */
-			int rs_left = drbd_bm_e_weight(mdev, enr);
+			int rs_left = drbd_bm_e_weight(device, enr);
 			if (ext->flags != 0) {
 				dev_warn(DEV, "changing resync lce: %d[%u;%02lx]"
 				     " -> %d[%u;00]\n",
@@ -782,9 +782,9 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *mdev, sector_t sector,
 			ext->rs_failed = success ? 0 : count;
 			/* we don't keep a persistent log of the resync lru,
 			 * we can commit any change right away. */
-			lc_committed(mdev->resync);
+			lc_committed(device->resync);
 		}
-		lc_put(mdev->resync, &ext->lce);
+		lc_put(device->resync, &ext->lce);
 		/* no race, we are within the al_lock! */
 
 		if (ext->rs_left == ext->rs_failed) {
@@ -794,32 +794,32 @@ static void drbd_try_clear_on_disk_bm(struct drbd_device *mdev, sector_t sector,
 			if (udw) {
 				udw->enr = ext->lce.lc_number;
 				udw->w.cb = w_update_odbm;
-				udw->w.mdev = mdev;
-				drbd_queue_work_front(&mdev->tconn->sender_work, &udw->w);
+				udw->w.device = device;
+				drbd_queue_work_front(&device->tconn->sender_work, &udw->w);
 			} else {
 				dev_warn(DEV, "Could not kmalloc an udw\n");
 			}
 		}
 	} else {
 		dev_err(DEV, "lc_get() failed! locked=%d/%d flags=%lu\n",
-		    mdev->resync_locked,
-		    mdev->resync->nr_elements,
-		    mdev->resync->flags);
+		    device->resync_locked,
+		    device->resync->nr_elements,
+		    device->resync->flags);
 	}
 }
 
-void drbd_advance_rs_marks(struct drbd_device *mdev, unsigned long still_to_go)
+void drbd_advance_rs_marks(struct drbd_device *device, unsigned long still_to_go)
 {
 	unsigned long now = jiffies;
-	unsigned long last = mdev->rs_mark_time[mdev->rs_last_mark];
-	int next = (mdev->rs_last_mark + 1) % DRBD_SYNC_MARKS;
+	unsigned long last = device->rs_mark_time[device->rs_last_mark];
+	int next = (device->rs_last_mark + 1) % DRBD_SYNC_MARKS;
 	if (time_after_eq(now, last + DRBD_SYNC_MARK_STEP)) {
-		if (mdev->rs_mark_left[mdev->rs_last_mark] != still_to_go &&
-		    mdev->state.conn != C_PAUSED_SYNC_T &&
-		    mdev->state.conn != C_PAUSED_SYNC_S) {
-			mdev->rs_mark_time[next] = now;
-			mdev->rs_mark_left[next] = still_to_go;
-			mdev->rs_last_mark = next;
+		if (device->rs_mark_left[device->rs_last_mark] != still_to_go &&
+		    device->state.conn != C_PAUSED_SYNC_T &&
+		    device->state.conn != C_PAUSED_SYNC_S) {
+			device->rs_mark_time[next] = now;
+			device->rs_mark_left[next] = still_to_go;
+			device->rs_last_mark = next;
 		}
 	}
 }
@@ -831,7 +831,7 @@ void drbd_advance_rs_marks(struct drbd_device *mdev, unsigned long still_to_go)
  * called by worker on C_SYNC_TARGET and receiver on SyncSource.
  *
  */
-void __drbd_set_in_sync(struct drbd_device *mdev, sector_t sector, int size,
+void __drbd_set_in_sync(struct drbd_device *device, sector_t sector, int size,
 		       const char *file, const unsigned int line)
 {
 	/* Is called from worker and receiver context _only_ */
@@ -847,10 +847,10 @@ void __drbd_set_in_sync(struct drbd_device *mdev, sector_t sector, int size,
 		return;
 	}
 
-	if (!get_ldev(mdev))
+	if (!get_ldev(device))
 		return; /* no disk, no metadata, no bitmap to clear bits in */
 
-	nr_sectors = drbd_get_capacity(mdev->this_bdev);
+	nr_sectors = drbd_get_capacity(device->this_bdev);
 	esector = sector + (size >> 9) - 1;
 
 	if (!expect(sector < nr_sectors))
@@ -878,21 +878,21 @@ void __drbd_set_in_sync(struct drbd_device *mdev, sector_t sector, int size,
 	 * ok, (capacity & 7) != 0 sometimes, but who cares...
 	 * we count rs_{total,left} in bits, not sectors.
 	 */
-	count = drbd_bm_clear_bits(mdev, sbnr, ebnr);
+	count = drbd_bm_clear_bits(device, sbnr, ebnr);
 	if (count) {
-		drbd_advance_rs_marks(mdev, drbd_bm_total_weight(mdev));
-		spin_lock_irqsave(&mdev->al_lock, flags);
-		drbd_try_clear_on_disk_bm(mdev, sector, count, true);
-		spin_unlock_irqrestore(&mdev->al_lock, flags);
+		drbd_advance_rs_marks(device, drbd_bm_total_weight(device));
+		spin_lock_irqsave(&device->al_lock, flags);
+		drbd_try_clear_on_disk_bm(device, sector, count, true);
+		spin_unlock_irqrestore(&device->al_lock, flags);
 
 		/* just wake_up unconditional now, various lc_chaged(),
 		 * lc_put() in drbd_try_clear_on_disk_bm(). */
 		wake_up = 1;
 	}
 out:
-	put_ldev(mdev);
+	put_ldev(device);
 	if (wake_up)
-		wake_up(&mdev->al_wait);
+		wake_up(&device->al_wait);
 }
 
 /*
@@ -903,7 +903,7 @@ out:
  * called by tl_clear and drbd_send_dblock (==drbd_make_request).
  * so this can be _any_ process.
  */
-int __drbd_set_out_of_sync(struct drbd_device *mdev, sector_t sector, int size,
+int __drbd_set_out_of_sync(struct drbd_device *device, sector_t sector, int size,
 			    const char *file, const unsigned int line)
 {
 	unsigned long sbnr, ebnr, flags;
@@ -921,10 +921,10 @@ int __drbd_set_out_of_sync(struct drbd_device *mdev, sector_t sector, int size,
 		return 0;
 	}
 
-	if (!get_ldev(mdev))
+	if (!get_ldev(device))
 		return 0; /* no disk, no metadata, no bitmap to set bits in */
 
-	nr_sectors = drbd_get_capacity(mdev->this_bdev);
+	nr_sectors = drbd_get_capacity(device->this_bdev);
 	esector = sector + (size >> 9) - 1;
 
 	if (!expect(sector < nr_sectors))
@@ -939,51 +939,51 @@ int __drbd_set_out_of_sync(struct drbd_device *mdev, sector_t sector, int size,
 
 	/* ok, (capacity & 7) != 0 sometimes, but who cares...
 	 * we count rs_{total,left} in bits, not sectors.  */
-	spin_lock_irqsave(&mdev->al_lock, flags);
-	count = drbd_bm_set_bits(mdev, sbnr, ebnr);
+	spin_lock_irqsave(&device->al_lock, flags);
+	count = drbd_bm_set_bits(device, sbnr, ebnr);
 
 	enr = BM_SECT_TO_EXT(sector);
-	e = lc_find(mdev->resync, enr);
+	e = lc_find(device->resync, enr);
 	if (e)
 		lc_entry(e, struct bm_extent, lce)->rs_left += count;
-	spin_unlock_irqrestore(&mdev->al_lock, flags);
+	spin_unlock_irqrestore(&device->al_lock, flags);
 
 out:
-	put_ldev(mdev);
+	put_ldev(device);
 
 	return count;
 }
 
 static
-struct bm_extent *_bme_get(struct drbd_device *mdev, unsigned int enr)
+struct bm_extent *_bme_get(struct drbd_device *device, unsigned int enr)
 {
 	struct lc_element *e;
 	struct bm_extent *bm_ext;
 	int wakeup = 0;
 	unsigned long rs_flags;
 
-	spin_lock_irq(&mdev->al_lock);
-	if (mdev->resync_locked > mdev->resync->nr_elements/2) {
-		spin_unlock_irq(&mdev->al_lock);
+	spin_lock_irq(&device->al_lock);
+	if (device->resync_locked > device->resync->nr_elements/2) {
+		spin_unlock_irq(&device->al_lock);
 		return NULL;
 	}
-	e = lc_get(mdev->resync, enr);
+	e = lc_get(device->resync, enr);
 	bm_ext = e ? lc_entry(e, struct bm_extent, lce) : NULL;
 	if (bm_ext) {
 		if (bm_ext->lce.lc_number != enr) {
-			bm_ext->rs_left = drbd_bm_e_weight(mdev, enr);
+			bm_ext->rs_left = drbd_bm_e_weight(device, enr);
 			bm_ext->rs_failed = 0;
-			lc_committed(mdev->resync);
+			lc_committed(device->resync);
 			wakeup = 1;
 		}
 		if (bm_ext->lce.refcnt == 1)
-			mdev->resync_locked++;
+			device->resync_locked++;
 		set_bit(BME_NO_WRITES, &bm_ext->flags);
 	}
-	rs_flags = mdev->resync->flags;
-	spin_unlock_irq(&mdev->al_lock);
+	rs_flags = device->resync->flags;
+	spin_unlock_irq(&device->al_lock);
 	if (wakeup)
-		wake_up(&mdev->al_wait);
+		wake_up(&device->al_wait);
 
 	if (!bm_ext) {
 		if (rs_flags & LC_STARVING)
@@ -995,25 +995,25 @@ struct bm_extent *_bme_get(struct drbd_device *mdev, unsigned int enr)
 	return bm_ext;
 }
 
-static int _is_in_al(struct drbd_device *mdev, unsigned int enr)
+static int _is_in_al(struct drbd_device *device, unsigned int enr)
 {
 	int rv;
 
-	spin_lock_irq(&mdev->al_lock);
-	rv = lc_is_used(mdev->act_log, enr);
-	spin_unlock_irq(&mdev->al_lock);
+	spin_lock_irq(&device->al_lock);
+	rv = lc_is_used(device->act_log, enr);
+	spin_unlock_irq(&device->al_lock);
 
 	return rv;
 }
 
 /**
  * drbd_rs_begin_io() - Gets an extent in the resync LRU cache and sets it to BME_LOCKED
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @sector:	The sector number.
  *
  * This functions sleeps on al_wait. Returns 0 on success, -EINTR if interrupted.
  */
-int drbd_rs_begin_io(struct drbd_device *mdev, sector_t sector)
+int drbd_rs_begin_io(struct drbd_device *device, sector_t sector)
 {
 	unsigned int enr = BM_SECT_TO_EXT(sector);
 	struct bm_extent *bm_ext;
@@ -1022,8 +1022,8 @@ int drbd_rs_begin_io(struct drbd_device *mdev, sector_t sector)
 			 200 times -> 20 seconds. */
 
 retry:
-	sig = wait_event_interruptible(mdev->al_wait,
-			(bm_ext = _bme_get(mdev, enr)));
+	sig = wait_event_interruptible(device->al_wait,
+			(bm_ext = _bme_get(device, enr)));
 	if (sig)
 		return -EINTR;
 
@@ -1031,18 +1031,18 @@ retry:
 		return 0;
 
 	for (i = 0; i < AL_EXT_PER_BM_SECT; i++) {
-		sig = wait_event_interruptible(mdev->al_wait,
-					       !_is_in_al(mdev, enr * AL_EXT_PER_BM_SECT + i) ||
+		sig = wait_event_interruptible(device->al_wait,
+					       !_is_in_al(device, enr * AL_EXT_PER_BM_SECT + i) ||
 					       test_bit(BME_PRIORITY, &bm_ext->flags));
 
 		if (sig || (test_bit(BME_PRIORITY, &bm_ext->flags) && sa)) {
-			spin_lock_irq(&mdev->al_lock);
-			if (lc_put(mdev->resync, &bm_ext->lce) == 0) {
+			spin_lock_irq(&device->al_lock);
+			if (lc_put(device->resync, &bm_ext->lce) == 0) {
 				bm_ext->flags = 0; /* clears BME_NO_WRITES and eventually BME_PRIORITY */
-				mdev->resync_locked--;
-				wake_up(&mdev->al_wait);
+				device->resync_locked--;
+				wake_up(&device->al_wait);
 			}
-			spin_unlock_irq(&mdev->al_lock);
+			spin_unlock_irq(&device->al_lock);
 			if (sig)
 				return -EINTR;
 			if (schedule_timeout_interruptible(HZ/10))
@@ -1059,14 +1059,14 @@ retry:
 
 /**
  * drbd_try_rs_begin_io() - Gets an extent in the resync LRU cache, does not sleep
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @sector:	The sector number.
  *
  * Gets an extent in the resync LRU cache, sets it to BME_NO_WRITES, then
  * tries to set it to BME_LOCKED. Returns 0 upon success, and -EAGAIN
  * if there is still application IO going on in this area.
  */
-int drbd_try_rs_begin_io(struct drbd_device *mdev, sector_t sector)
+int drbd_try_rs_begin_io(struct drbd_device *device, sector_t sector)
 {
 	unsigned int enr = BM_SECT_TO_EXT(sector);
 	const unsigned int al_enr = enr*AL_EXT_PER_BM_SECT;
@@ -1074,8 +1074,8 @@ int drbd_try_rs_begin_io(struct drbd_device *mdev, sector_t sector)
 	struct bm_extent *bm_ext;
 	int i;
 
-	spin_lock_irq(&mdev->al_lock);
-	if (mdev->resync_wenr != LC_FREE && mdev->resync_wenr != enr) {
+	spin_lock_irq(&device->al_lock);
+	if (device->resync_wenr != LC_FREE && device->resync_wenr != enr) {
 		/* in case you have very heavy scattered io, it may
 		 * stall the syncer undefined if we give up the ref count
 		 * when we try again and requeue.
@@ -1089,28 +1089,28 @@ int drbd_try_rs_begin_io(struct drbd_device *mdev, sector_t sector)
 		 * the lc_put here...
 		 * we also have to wake_up
 		 */
-		e = lc_find(mdev->resync, mdev->resync_wenr);
+		e = lc_find(device->resync, device->resync_wenr);
 		bm_ext = e ? lc_entry(e, struct bm_extent, lce) : NULL;
 		if (bm_ext) {
 			D_ASSERT(!test_bit(BME_LOCKED, &bm_ext->flags));
 			D_ASSERT(test_bit(BME_NO_WRITES, &bm_ext->flags));
 			clear_bit(BME_NO_WRITES, &bm_ext->flags);
-			mdev->resync_wenr = LC_FREE;
-			if (lc_put(mdev->resync, &bm_ext->lce) == 0)
-				mdev->resync_locked--;
-			wake_up(&mdev->al_wait);
+			device->resync_wenr = LC_FREE;
+			if (lc_put(device->resync, &bm_ext->lce) == 0)
+				device->resync_locked--;
+			wake_up(&device->al_wait);
 		} else {
 			dev_alert(DEV, "LOGIC BUG\n");
 		}
 	}
 	/* TRY. */
-	e = lc_try_get(mdev->resync, enr);
+	e = lc_try_get(device->resync, enr);
 	bm_ext = e ? lc_entry(e, struct bm_extent, lce) : NULL;
 	if (bm_ext) {
 		if (test_bit(BME_LOCKED, &bm_ext->flags))
 			goto proceed;
 		if (!test_and_set_bit(BME_NO_WRITES, &bm_ext->flags)) {
-			mdev->resync_locked++;
+			device->resync_locked++;
 		} else {
 			/* we did set the BME_NO_WRITES,
 			 * but then could not set BME_LOCKED,
@@ -1122,13 +1122,13 @@ int drbd_try_rs_begin_io(struct drbd_device *mdev, sector_t sector)
 		goto check_al;
 	} else {
 		/* do we rather want to try later? */
-		if (mdev->resync_locked > mdev->resync->nr_elements-3)
+		if (device->resync_locked > device->resync->nr_elements-3)
 			goto try_again;
 		/* Do or do not. There is no try. -- Yoda */
-		e = lc_get(mdev->resync, enr);
+		e = lc_get(device->resync, enr);
 		bm_ext = e ? lc_entry(e, struct bm_extent, lce) : NULL;
 		if (!bm_ext) {
-			const unsigned long rs_flags = mdev->resync->flags;
+			const unsigned long rs_flags = device->resync->flags;
 			if (rs_flags & LC_STARVING)
 				dev_warn(DEV, "Have to wait for element"
 				     " (resync LRU too small?)\n");
@@ -1136,146 +1136,146 @@ int drbd_try_rs_begin_io(struct drbd_device *mdev, sector_t sector)
 			goto try_again;
 		}
 		if (bm_ext->lce.lc_number != enr) {
-			bm_ext->rs_left = drbd_bm_e_weight(mdev, enr);
+			bm_ext->rs_left = drbd_bm_e_weight(device, enr);
 			bm_ext->rs_failed = 0;
-			lc_committed(mdev->resync);
-			wake_up(&mdev->al_wait);
+			lc_committed(device->resync);
+			wake_up(&device->al_wait);
 			D_ASSERT(test_bit(BME_LOCKED, &bm_ext->flags) == 0);
 		}
 		set_bit(BME_NO_WRITES, &bm_ext->flags);
 		D_ASSERT(bm_ext->lce.refcnt == 1);
-		mdev->resync_locked++;
+		device->resync_locked++;
 		goto check_al;
 	}
 check_al:
 	for (i = 0; i < AL_EXT_PER_BM_SECT; i++) {
-		if (lc_is_used(mdev->act_log, al_enr+i))
+		if (lc_is_used(device->act_log, al_enr+i))
 			goto try_again;
 	}
 	set_bit(BME_LOCKED, &bm_ext->flags);
 proceed:
-	mdev->resync_wenr = LC_FREE;
-	spin_unlock_irq(&mdev->al_lock);
+	device->resync_wenr = LC_FREE;
+	spin_unlock_irq(&device->al_lock);
 	return 0;
 
 try_again:
 	if (bm_ext)
-		mdev->resync_wenr = enr;
-	spin_unlock_irq(&mdev->al_lock);
+		device->resync_wenr = enr;
+	spin_unlock_irq(&device->al_lock);
 	return -EAGAIN;
 }
 
-void drbd_rs_complete_io(struct drbd_device *mdev, sector_t sector)
+void drbd_rs_complete_io(struct drbd_device *device, sector_t sector)
 {
 	unsigned int enr = BM_SECT_TO_EXT(sector);
 	struct lc_element *e;
 	struct bm_extent *bm_ext;
 	unsigned long flags;
 
-	spin_lock_irqsave(&mdev->al_lock, flags);
-	e = lc_find(mdev->resync, enr);
+	spin_lock_irqsave(&device->al_lock, flags);
+	e = lc_find(device->resync, enr);
 	bm_ext = e ? lc_entry(e, struct bm_extent, lce) : NULL;
 	if (!bm_ext) {
-		spin_unlock_irqrestore(&mdev->al_lock, flags);
+		spin_unlock_irqrestore(&device->al_lock, flags);
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "drbd_rs_complete_io() called, but extent not found\n");
 		return;
 	}
 
 	if (bm_ext->lce.refcnt == 0) {
-		spin_unlock_irqrestore(&mdev->al_lock, flags);
+		spin_unlock_irqrestore(&device->al_lock, flags);
 		dev_err(DEV, "drbd_rs_complete_io(,%llu [=%u]) called, "
 		    "but refcnt is 0!?\n",
 		    (unsigned long long)sector, enr);
 		return;
 	}
 
-	if (lc_put(mdev->resync, &bm_ext->lce) == 0) {
+	if (lc_put(device->resync, &bm_ext->lce) == 0) {
 		bm_ext->flags = 0; /* clear BME_LOCKED, BME_NO_WRITES and BME_PRIORITY */
-		mdev->resync_locked--;
-		wake_up(&mdev->al_wait);
+		device->resync_locked--;
+		wake_up(&device->al_wait);
 	}
 
-	spin_unlock_irqrestore(&mdev->al_lock, flags);
+	spin_unlock_irqrestore(&device->al_lock, flags);
 }
 
 /**
  * drbd_rs_cancel_all() - Removes all extents from the resync LRU (even BME_LOCKED)
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  */
-void drbd_rs_cancel_all(struct drbd_device *mdev)
+void drbd_rs_cancel_all(struct drbd_device *device)
 {
-	spin_lock_irq(&mdev->al_lock);
+	spin_lock_irq(&device->al_lock);
 
-	if (get_ldev_if_state(mdev, D_FAILED)) { /* Makes sure ->resync is there. */
-		lc_reset(mdev->resync);
-		put_ldev(mdev);
+	if (get_ldev_if_state(device, D_FAILED)) { /* Makes sure ->resync is there. */
+		lc_reset(device->resync);
+		put_ldev(device);
 	}
-	mdev->resync_locked = 0;
-	mdev->resync_wenr = LC_FREE;
-	spin_unlock_irq(&mdev->al_lock);
-	wake_up(&mdev->al_wait);
+	device->resync_locked = 0;
+	device->resync_wenr = LC_FREE;
+	spin_unlock_irq(&device->al_lock);
+	wake_up(&device->al_wait);
 }
 
 /**
  * drbd_rs_del_all() - Gracefully remove all extents from the resync LRU
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Returns 0 upon success, -EAGAIN if at least one reference count was
  * not zero.
  */
-int drbd_rs_del_all(struct drbd_device *mdev)
+int drbd_rs_del_all(struct drbd_device *device)
 {
 	struct lc_element *e;
 	struct bm_extent *bm_ext;
 	int i;
 
-	spin_lock_irq(&mdev->al_lock);
+	spin_lock_irq(&device->al_lock);
 
-	if (get_ldev_if_state(mdev, D_FAILED)) {
+	if (get_ldev_if_state(device, D_FAILED)) {
 		/* ok, ->resync is there. */
-		for (i = 0; i < mdev->resync->nr_elements; i++) {
-			e = lc_element_by_index(mdev->resync, i);
+		for (i = 0; i < device->resync->nr_elements; i++) {
+			e = lc_element_by_index(device->resync, i);
 			bm_ext = lc_entry(e, struct bm_extent, lce);
 			if (bm_ext->lce.lc_number == LC_FREE)
 				continue;
-			if (bm_ext->lce.lc_number == mdev->resync_wenr) {
+			if (bm_ext->lce.lc_number == device->resync_wenr) {
 				dev_info(DEV, "dropping %u in drbd_rs_del_all, apparently"
 				     " got 'synced' by application io\n",
-				     mdev->resync_wenr);
+				     device->resync_wenr);
 				D_ASSERT(!test_bit(BME_LOCKED, &bm_ext->flags));
 				D_ASSERT(test_bit(BME_NO_WRITES, &bm_ext->flags));
 				clear_bit(BME_NO_WRITES, &bm_ext->flags);
-				mdev->resync_wenr = LC_FREE;
-				lc_put(mdev->resync, &bm_ext->lce);
+				device->resync_wenr = LC_FREE;
+				lc_put(device->resync, &bm_ext->lce);
 			}
 			if (bm_ext->lce.refcnt != 0) {
 				dev_info(DEV, "Retrying drbd_rs_del_all() later. "
 				     "refcnt=%d\n", bm_ext->lce.refcnt);
-				put_ldev(mdev);
-				spin_unlock_irq(&mdev->al_lock);
+				put_ldev(device);
+				spin_unlock_irq(&device->al_lock);
 				return -EAGAIN;
 			}
 			D_ASSERT(!test_bit(BME_LOCKED, &bm_ext->flags));
 			D_ASSERT(!test_bit(BME_NO_WRITES, &bm_ext->flags));
-			lc_del(mdev->resync, &bm_ext->lce);
+			lc_del(device->resync, &bm_ext->lce);
 		}
-		D_ASSERT(mdev->resync->used == 0);
-		put_ldev(mdev);
+		D_ASSERT(device->resync->used == 0);
+		put_ldev(device);
 	}
-	spin_unlock_irq(&mdev->al_lock);
-	wake_up(&mdev->al_wait);
+	spin_unlock_irq(&device->al_lock);
+	wake_up(&device->al_wait);
 
 	return 0;
 }
 
 /**
  * drbd_rs_failed_io() - Record information on a failure to resync the specified blocks
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @sector:	The sector number.
  * @size:	Size of failed IO operation, in byte.
  */
-void drbd_rs_failed_io(struct drbd_device *mdev, sector_t sector, int size)
+void drbd_rs_failed_io(struct drbd_device *device, sector_t sector, int size)
 {
 	/* Is called from worker and receiver context _only_ */
 	unsigned long sbnr, ebnr, lbnr;
@@ -1288,7 +1288,7 @@ void drbd_rs_failed_io(struct drbd_device *mdev, sector_t sector, int size)
 				(unsigned long long)sector, size);
 		return;
 	}
-	nr_sectors = drbd_get_capacity(mdev->this_bdev);
+	nr_sectors = drbd_get_capacity(device->this_bdev);
 	esector = sector + (size >> 9) - 1;
 
 	if (!expect(sector < nr_sectors))
@@ -1316,21 +1316,21 @@ void drbd_rs_failed_io(struct drbd_device *mdev, sector_t sector, int size)
 	 * ok, (capacity & 7) != 0 sometimes, but who cares...
 	 * we count rs_{total,left} in bits, not sectors.
 	 */
-	spin_lock_irq(&mdev->al_lock);
-	count = drbd_bm_count_bits(mdev, sbnr, ebnr);
+	spin_lock_irq(&device->al_lock);
+	count = drbd_bm_count_bits(device, sbnr, ebnr);
 	if (count) {
-		mdev->rs_failed += count;
+		device->rs_failed += count;
 
-		if (get_ldev(mdev)) {
-			drbd_try_clear_on_disk_bm(mdev, sector, count, false);
-			put_ldev(mdev);
+		if (get_ldev(device)) {
+			drbd_try_clear_on_disk_bm(device, sector, count, false);
+			put_ldev(device);
 		}
 
 		/* just wake_up unconditional now, various lc_chaged(),
 		 * lc_put() in drbd_try_clear_on_disk_bm(). */
 		wake_up = 1;
 	}
-	spin_unlock_irq(&mdev->al_lock);
+	spin_unlock_irq(&device->al_lock);
 	if (wake_up)
-		wake_up(&mdev->al_wait);
+		wake_up(&device->al_wait);
 }
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 1287993..fd3b89a 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -113,20 +113,20 @@ struct drbd_bitmap {
 };
 
 #define bm_print_lock_info(m) __bm_print_lock_info(m, __func__)
-static void __bm_print_lock_info(struct drbd_device *mdev, const char *func)
+static void __bm_print_lock_info(struct drbd_device *device, const char *func)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	if (!__ratelimit(&drbd_ratelimit_state))
 		return;
 	dev_err(DEV, "FIXME %s in %s, bitmap locked for '%s' by %s\n",
-		drbd_task_to_thread_name(mdev->tconn, current),
+		drbd_task_to_thread_name(device->tconn, current),
 		func, b->bm_why ?: "?",
-		drbd_task_to_thread_name(mdev->tconn, b->bm_task));
+		drbd_task_to_thread_name(device->tconn, b->bm_task));
 }
 
-void drbd_bm_lock(struct drbd_device *mdev, char *why, enum bm_flag flags)
+void drbd_bm_lock(struct drbd_device *device, char *why, enum bm_flag flags)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	int trylock_failed;
 
 	if (!b) {
@@ -138,9 +138,9 @@ void drbd_bm_lock(struct drbd_device *mdev, char *why, enum bm_flag flags)
 
 	if (trylock_failed) {
 		dev_warn(DEV, "%s going to '%s' but bitmap already locked for '%s' by %s\n",
-			 drbd_task_to_thread_name(mdev->tconn, current),
+			 drbd_task_to_thread_name(device->tconn, current),
 			 why, b->bm_why ?: "?",
-			 drbd_task_to_thread_name(mdev->tconn, b->bm_task));
+			 drbd_task_to_thread_name(device->tconn, b->bm_task));
 		mutex_lock(&b->bm_change);
 	}
 	if (BM_LOCKED_MASK & b->bm_flags)
@@ -151,15 +151,15 @@ void drbd_bm_lock(struct drbd_device *mdev, char *why, enum bm_flag flags)
 	b->bm_task = current;
 }
 
-void drbd_bm_unlock(struct drbd_device *mdev)
+void drbd_bm_unlock(struct drbd_device *device)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	if (!b) {
 		dev_err(DEV, "FIXME no bitmap in drbd_bm_unlock!?\n");
 		return;
 	}
 
-	if (!(BM_LOCKED_MASK & mdev->bitmap->bm_flags))
+	if (!(BM_LOCKED_MASK & device->bitmap->bm_flags))
 		dev_err(DEV, "FIXME bitmap not locked in bm_unlock\n");
 
 	b->bm_flags &= ~BM_LOCKED_MASK;
@@ -211,19 +211,19 @@ static unsigned long bm_page_to_idx(struct page *page)
 /* As is very unlikely that the same page is under IO from more than one
  * context, we can get away with a bit per page and one wait queue per bitmap.
  */
-static void bm_page_lock_io(struct drbd_device *mdev, int page_nr)
+static void bm_page_lock_io(struct drbd_device *device, int page_nr)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	void *addr = &page_private(b->bm_pages[page_nr]);
 	wait_event(b->bm_io_wait, !test_and_set_bit(BM_PAGE_IO_LOCK, addr));
 }
 
-static void bm_page_unlock_io(struct drbd_device *mdev, int page_nr)
+static void bm_page_unlock_io(struct drbd_device *device, int page_nr)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	void *addr = &page_private(b->bm_pages[page_nr]);
 	clear_bit_unlock(BM_PAGE_IO_LOCK, addr);
-	wake_up(&mdev->bitmap->bm_io_wait);
+	wake_up(&device->bitmap->bm_io_wait);
 }
 
 /* set _before_ submit_io, so it may be reset due to being changed
@@ -242,22 +242,22 @@ static void bm_set_page_need_writeout(struct page *page)
 
 /**
  * drbd_bm_mark_for_writeout() - mark a page with a "hint" to be considered for writeout
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @page_nr:	the bitmap page to mark with the "hint" flag
  *
  * From within an activity log transaction, we mark a few pages with these
  * hints, then call drbd_bm_write_hinted(), which will only write out changed
  * pages which are flagged with this mark.
  */
-void drbd_bm_mark_for_writeout(struct drbd_device *mdev, int page_nr)
+void drbd_bm_mark_for_writeout(struct drbd_device *device, int page_nr)
 {
 	struct page *page;
-	if (page_nr >= mdev->bitmap->bm_number_of_pages) {
+	if (page_nr >= device->bitmap->bm_number_of_pages) {
 		dev_warn(DEV, "BAD: page_nr: %u, number_of_pages: %u\n",
-			 page_nr, (int)mdev->bitmap->bm_number_of_pages);
+			 page_nr, (int)device->bitmap->bm_number_of_pages);
 		return;
 	}
-	page = mdev->bitmap->bm_pages[page_nr];
+	page = device->bitmap->bm_pages[page_nr];
 	set_bit(BM_PAGE_HINT_WRITEOUT, &page_private(page));
 }
 
@@ -340,7 +340,7 @@ static void bm_unmap(unsigned long *p_addr)
 
 /*
  * actually most functions herein should take a struct drbd_bitmap*, not a
- * struct drbd_device*, but for the debug macros I like to have the mdev around
+ * struct drbd_device*, but for the debug macros I like to have the device around
  * to be able to report device specific.
  */
 
@@ -436,11 +436,11 @@ static struct page **bm_realloc_pages(struct drbd_bitmap *b, unsigned long want)
 
 /*
  * called on driver init only. TODO call when a device is created.
- * allocates the drbd_bitmap, and stores it in mdev->bitmap.
+ * allocates the drbd_bitmap, and stores it in device->bitmap.
  */
-int drbd_bm_init(struct drbd_device *mdev)
+int drbd_bm_init(struct drbd_device *device)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	WARN_ON(b != NULL);
 	b = kzalloc(sizeof(struct drbd_bitmap), GFP_KERNEL);
 	if (!b)
@@ -449,28 +449,28 @@ int drbd_bm_init(struct drbd_device *mdev)
 	mutex_init(&b->bm_change);
 	init_waitqueue_head(&b->bm_io_wait);
 
-	mdev->bitmap = b;
+	device->bitmap = b;
 
 	return 0;
 }
 
-sector_t drbd_bm_capacity(struct drbd_device *mdev)
+sector_t drbd_bm_capacity(struct drbd_device *device)
 {
-	if (!expect(mdev->bitmap))
+	if (!expect(device->bitmap))
 		return 0;
-	return mdev->bitmap->bm_dev_capacity;
+	return device->bitmap->bm_dev_capacity;
 }
 
 /* called on driver unload. TODO: call when a device is destroyed.
  */
-void drbd_bm_cleanup(struct drbd_device *mdev)
+void drbd_bm_cleanup(struct drbd_device *device)
 {
-	if (!expect(mdev->bitmap))
+	if (!expect(device->bitmap))
 		return;
-	bm_free_pages(mdev->bitmap->bm_pages, mdev->bitmap->bm_number_of_pages);
-	bm_vk_free(mdev->bitmap->bm_pages, (BM_P_VMALLOCED & mdev->bitmap->bm_flags));
-	kfree(mdev->bitmap);
-	mdev->bitmap = NULL;
+	bm_free_pages(device->bitmap->bm_pages, device->bitmap->bm_number_of_pages);
+	bm_vk_free(device->bitmap->bm_pages, (BM_P_VMALLOCED & device->bitmap->bm_flags));
+	kfree(device->bitmap);
+	device->bitmap = NULL;
 }
 
 /*
@@ -631,9 +631,9 @@ static u64 drbd_md_on_disk_bits(struct drbd_backing_dev *ldev)
  * In case this is actually a resize, we copy the old bitmap into the new one.
  * Otherwise, the bitmap is initialized to all bits set.
  */
-int drbd_bm_resize(struct drbd_device *mdev, sector_t capacity, int set_new_bits)
+int drbd_bm_resize(struct drbd_device *device, sector_t capacity, int set_new_bits)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	unsigned long bits, words, owords, obits;
 	unsigned long want, have, onpages; /* number of pages */
 	struct page **npages, **opages = NULL;
@@ -643,7 +643,7 @@ int drbd_bm_resize(struct drbd_device *mdev, sector_t capacity, int set_new_bits
 	if (!expect(b))
 		return -ENOMEM;
 
-	drbd_bm_lock(mdev, "resize", BM_LOCKED_MASK);
+	drbd_bm_lock(device, "resize", BM_LOCKED_MASK);
 
 	dev_info(DEV, "drbd_bm_resize called with capacity == %llu\n",
 			(unsigned long long)capacity);
@@ -678,9 +678,9 @@ int drbd_bm_resize(struct drbd_device *mdev, sector_t capacity, int set_new_bits
 	*/
 	words = ALIGN(bits, 64) >> LN2_BPL;
 
-	if (get_ldev(mdev)) {
-		u64 bits_on_disk = drbd_md_on_disk_bits(mdev->ldev);
-		put_ldev(mdev);
+	if (get_ldev(device)) {
+		u64 bits_on_disk = drbd_md_on_disk_bits(device->ldev);
+		put_ldev(device);
 		if (bits > bits_on_disk) {
 			dev_info(DEV, "bits = %lu\n", bits);
 			dev_info(DEV, "bits_on_disk = %llu\n", bits_on_disk);
@@ -695,7 +695,7 @@ int drbd_bm_resize(struct drbd_device *mdev, sector_t capacity, int set_new_bits
 		D_ASSERT(b->bm_pages != NULL);
 		npages = b->bm_pages;
 	} else {
-		if (drbd_insert_fault(mdev, DRBD_FAULT_BM_ALLOC))
+		if (drbd_insert_fault(device, DRBD_FAULT_BM_ALLOC))
 			npages = NULL;
 		else
 			npages = bm_realloc_pages(b, want);
@@ -745,7 +745,7 @@ int drbd_bm_resize(struct drbd_device *mdev, sector_t capacity, int set_new_bits
 	dev_info(DEV, "resync bitmap: bits=%lu words=%lu pages=%lu\n", bits, words, want);
 
  out:
-	drbd_bm_unlock(mdev);
+	drbd_bm_unlock(device);
 	return err;
 }
 
@@ -757,9 +757,9 @@ int drbd_bm_resize(struct drbd_device *mdev, sector_t capacity, int set_new_bits
  *
  * maybe bm_set should be atomic_t ?
  */
-unsigned long _drbd_bm_total_weight(struct drbd_device *mdev)
+unsigned long _drbd_bm_total_weight(struct drbd_device *device)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	unsigned long s;
 	unsigned long flags;
 
@@ -775,20 +775,20 @@ unsigned long _drbd_bm_total_weight(struct drbd_device *mdev)
 	return s;
 }
 
-unsigned long drbd_bm_total_weight(struct drbd_device *mdev)
+unsigned long drbd_bm_total_weight(struct drbd_device *device)
 {
 	unsigned long s;
 	/* if I don't have a disk, I don't know about out-of-sync status */
-	if (!get_ldev_if_state(mdev, D_NEGOTIATING))
+	if (!get_ldev_if_state(device, D_NEGOTIATING))
 		return 0;
-	s = _drbd_bm_total_weight(mdev);
-	put_ldev(mdev);
+	s = _drbd_bm_total_weight(device);
+	put_ldev(device);
 	return s;
 }
 
-size_t drbd_bm_words(struct drbd_device *mdev)
+size_t drbd_bm_words(struct drbd_device *device)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	if (!expect(b))
 		return 0;
 	if (!expect(b->bm_pages))
@@ -797,9 +797,9 @@ size_t drbd_bm_words(struct drbd_device *mdev)
 	return b->bm_words;
 }
 
-unsigned long drbd_bm_bits(struct drbd_device *mdev)
+unsigned long drbd_bm_bits(struct drbd_device *device)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	if (!expect(b))
 		return 0;
 
@@ -811,10 +811,10 @@ unsigned long drbd_bm_bits(struct drbd_device *mdev)
  * bitmap must be locked by drbd_bm_lock.
  * currently only used from receive_bitmap.
  */
-void drbd_bm_merge_lel(struct drbd_device *mdev, size_t offset, size_t number,
+void drbd_bm_merge_lel(struct drbd_device *device, size_t offset, size_t number,
 			unsigned long *buffer)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	unsigned long *p_addr, *bm;
 	unsigned long word, bits;
 	unsigned int idx;
@@ -860,10 +860,10 @@ void drbd_bm_merge_lel(struct drbd_device *mdev, size_t offset, size_t number,
 /* copy number words from the bitmap starting at offset into the buffer.
  * buffer[i] will be little endian unsigned long.
  */
-void drbd_bm_get_lel(struct drbd_device *mdev, size_t offset, size_t number,
+void drbd_bm_get_lel(struct drbd_device *device, size_t offset, size_t number,
 		     unsigned long *buffer)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	unsigned long *p_addr, *bm;
 	size_t end, do_now;
 
@@ -897,9 +897,9 @@ void drbd_bm_get_lel(struct drbd_device *mdev, size_t offset, size_t number,
 }
 
 /* set all bits in the bitmap */
-void drbd_bm_set_all(struct drbd_device *mdev)
+void drbd_bm_set_all(struct drbd_device *device)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	if (!expect(b))
 		return;
 	if (!expect(b->bm_pages))
@@ -913,9 +913,9 @@ void drbd_bm_set_all(struct drbd_device *mdev)
 }
 
 /* clear all bits in the bitmap */
-void drbd_bm_clear_all(struct drbd_device *mdev)
+void drbd_bm_clear_all(struct drbd_device *device)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	if (!expect(b))
 		return;
 	if (!expect(b->bm_pages))
@@ -928,7 +928,7 @@ void drbd_bm_clear_all(struct drbd_device *mdev)
 }
 
 struct bm_aio_ctx {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	atomic_t in_flight;
 	unsigned int done;
 	unsigned flags;
@@ -943,7 +943,7 @@ static void bm_aio_ctx_destroy(struct kref *kref)
 {
 	struct bm_aio_ctx *ctx = container_of(kref, struct bm_aio_ctx, kref);
 
-	put_ldev(ctx->mdev);
+	put_ldev(ctx->device);
 	kfree(ctx);
 }
 
@@ -951,8 +951,8 @@ static void bm_aio_ctx_destroy(struct kref *kref)
 static void bm_async_io_complete(struct bio *bio, int error)
 {
 	struct bm_aio_ctx *ctx = bio->bi_private;
-	struct drbd_device *mdev = ctx->mdev;
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_device *device = ctx->device;
+	struct drbd_bitmap *b = device->bitmap;
 	unsigned int idx = bm_page_to_idx(bio->bi_io_vec[0].bv_page);
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
 
@@ -983,7 +983,7 @@ static void bm_async_io_complete(struct bio *bio, int error)
 		dynamic_dev_dbg(DEV, "bitmap page idx %u completed\n", idx);
 	}
 
-	bm_page_unlock_io(mdev, idx);
+	bm_page_unlock_io(device, idx);
 
 	if (ctx->flags & BM_AIO_COPY_PAGES)
 		mempool_free(bio->bi_io_vec[0].bv_page, drbd_md_io_page_pool);
@@ -992,7 +992,7 @@ static void bm_async_io_complete(struct bio *bio, int error)
 
 	if (atomic_dec_and_test(&ctx->in_flight)) {
 		ctx->done = 1;
-		wake_up(&mdev->misc_wait);
+		wake_up(&device->misc_wait);
 		kref_put(&ctx->kref, &bm_aio_ctx_destroy);
 	}
 }
@@ -1000,23 +1000,23 @@ static void bm_async_io_complete(struct bio *bio, int error)
 static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must_hold(local)
 {
 	struct bio *bio = bio_alloc_drbd(GFP_NOIO);
-	struct drbd_device *mdev = ctx->mdev;
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_device *device = ctx->device;
+	struct drbd_bitmap *b = device->bitmap;
 	struct page *page;
 	unsigned int len;
 
 	sector_t on_disk_sector =
-		mdev->ldev->md.md_offset + mdev->ldev->md.bm_offset;
+		device->ldev->md.md_offset + device->ldev->md.bm_offset;
 	on_disk_sector += ((sector_t)page_nr) << (PAGE_SHIFT-9);
 
 	/* this might happen with very small
 	 * flexible external meta data device,
 	 * or with PAGE_SIZE > 4k */
 	len = min_t(unsigned int, PAGE_SIZE,
-		(drbd_md_last_sector(mdev->ldev) - on_disk_sector + 1)<<9);
+		(drbd_md_last_sector(device->ldev) - on_disk_sector + 1)<<9);
 
 	/* serialize IO on this page */
-	bm_page_lock_io(mdev, page_nr);
+	bm_page_lock_io(device, page_nr);
 	/* before memcpy and submit,
 	 * so it can be redirtied any time */
 	bm_set_page_unchanged(b->bm_pages[page_nr]);
@@ -1027,7 +1027,7 @@ static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must
 		bm_store_page_idx(page, page_nr);
 	} else
 		page = b->bm_pages[page_nr];
-	bio->bi_bdev = mdev->ldev->md_bdev;
+	bio->bi_bdev = device->ldev->md_bdev;
 	bio->bi_iter.bi_sector = on_disk_sector;
 	/* bio_add_page of a single page to an empty bio will always succeed,
 	 * according to api.  Do we want to assert that? */
@@ -1035,24 +1035,24 @@ static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must
 	bio->bi_private = ctx;
 	bio->bi_end_io = bm_async_io_complete;
 
-	if (drbd_insert_fault(mdev, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD)) {
+	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD)) {
 		bio->bi_rw |= rw;
 		bio_endio(bio, -EIO);
 	} else {
 		submit_bio(rw, bio);
 		/* this should not count as user activity and cause the
 		 * resync to throttle -- see drbd_rs_should_slow_down(). */
-		atomic_add(len >> 9, &mdev->rs_sect_ev);
+		atomic_add(len >> 9, &device->rs_sect_ev);
 	}
 }
 
 /*
  * bm_rw: read/write the whole bitmap from/to its on disk location.
  */
-static int bm_rw(struct drbd_device *mdev, int rw, unsigned flags, unsigned lazy_writeout_upper_idx) __must_hold(local)
+static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned lazy_writeout_upper_idx) __must_hold(local)
 {
 	struct bm_aio_ctx *ctx;
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	int num_pages, i, count = 0;
 	unsigned long now;
 	char ppb[10];
@@ -1072,7 +1072,7 @@ static int bm_rw(struct drbd_device *mdev, int rw, unsigned flags, unsigned lazy
 		return -ENOMEM;
 
 	*ctx = (struct bm_aio_ctx) {
-		.mdev = mdev,
+		.device = device,
 		.in_flight = ATOMIC_INIT(1),
 		.done = 0,
 		.flags = flags,
@@ -1080,7 +1080,7 @@ static int bm_rw(struct drbd_device *mdev, int rw, unsigned flags, unsigned lazy
 		.kref = { ATOMIC_INIT(2) },
 	};
 
-	if (!get_ldev_if_state(mdev, D_ATTACHING)) {  /* put is in bm_aio_ctx_destroy() */
+	if (!get_ldev_if_state(device, D_ATTACHING)) {  /* put is in bm_aio_ctx_destroy() */
 		dev_err(DEV, "ASSERT FAILED: get_ldev_if_state() == 1 in bm_rw()\n");
 		kfree(ctx);
 		return -ENODEV;
@@ -1132,7 +1132,7 @@ static int bm_rw(struct drbd_device *mdev, int rw, unsigned flags, unsigned lazy
 	 * "in_flight reached zero, all done" event.
 	 */
 	if (!atomic_dec_and_test(&ctx->in_flight))
-		wait_until_done_or_force_detached(mdev, mdev->ldev, &ctx->done);
+		wait_until_done_or_force_detached(device, device->ldev, &ctx->done);
 	else
 		kref_put(&ctx->kref, &bm_aio_ctx_destroy);
 
@@ -1144,7 +1144,7 @@ static int bm_rw(struct drbd_device *mdev, int rw, unsigned flags, unsigned lazy
 
 	if (ctx->error) {
 		dev_alert(DEV, "we had at least one MD IO ERROR during bitmap IO\n");
-		drbd_chk_io_error(mdev, 1, DRBD_META_IO_ERROR);
+		drbd_chk_io_error(device, 1, DRBD_META_IO_ERROR);
 		err = -EIO; /* ctx->error ? */
 	}
 
@@ -1153,7 +1153,7 @@ static int bm_rw(struct drbd_device *mdev, int rw, unsigned flags, unsigned lazy
 
 	now = jiffies;
 	if (rw == WRITE) {
-		drbd_md_flush(mdev);
+		drbd_md_flush(device);
 	} else /* rw == READ */ {
 		b->bm_set = bm_count_bits(b);
 		dev_info(DEV, "recounting of set bits took additional %lu jiffies\n",
@@ -1171,48 +1171,48 @@ static int bm_rw(struct drbd_device *mdev, int rw, unsigned flags, unsigned lazy
 
 /**
  * drbd_bm_read() - Read the whole bitmap from its on disk location.
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  */
-int drbd_bm_read(struct drbd_device *mdev) __must_hold(local)
+int drbd_bm_read(struct drbd_device *device) __must_hold(local)
 {
-	return bm_rw(mdev, READ, 0, 0);
+	return bm_rw(device, READ, 0, 0);
 }
 
 /**
  * drbd_bm_write() - Write the whole bitmap to its on disk location.
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Will only write pages that have changed since last IO.
  */
-int drbd_bm_write(struct drbd_device *mdev) __must_hold(local)
+int drbd_bm_write(struct drbd_device *device) __must_hold(local)
 {
-	return bm_rw(mdev, WRITE, 0, 0);
+	return bm_rw(device, WRITE, 0, 0);
 }
 
 /**
  * drbd_bm_write_all() - Write the whole bitmap to its on disk location.
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Will write all pages.
  */
-int drbd_bm_write_all(struct drbd_device *mdev) __must_hold(local)
+int drbd_bm_write_all(struct drbd_device *device) __must_hold(local)
 {
-	return bm_rw(mdev, WRITE, BM_WRITE_ALL_PAGES, 0);
+	return bm_rw(device, WRITE, BM_WRITE_ALL_PAGES, 0);
 }
 
 /**
  * drbd_bm_lazy_write_out() - Write bitmap pages 0 to @upper_idx-1, if they have changed.
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @upper_idx:	0: write all changed pages; +ve: page index to stop scanning for changed pages
  */
-int drbd_bm_write_lazy(struct drbd_device *mdev, unsigned upper_idx) __must_hold(local)
+int drbd_bm_write_lazy(struct drbd_device *device, unsigned upper_idx) __must_hold(local)
 {
-	return bm_rw(mdev, WRITE, BM_AIO_COPY_PAGES, upper_idx);
+	return bm_rw(device, WRITE, BM_AIO_COPY_PAGES, upper_idx);
 }
 
 /**
  * drbd_bm_write_copy_pages() - Write the whole bitmap to its on disk location.
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Will only write pages that have changed since last IO.
  * In contrast to drbd_bm_write(), this will copy the bitmap pages
@@ -1221,23 +1221,23 @@ int drbd_bm_write_lazy(struct drbd_device *mdev, unsigned upper_idx) __must_hold
  * verify is aborted due to a failed peer disk, while local IO continues, or
  * pending resync acks are still being processed.
  */
-int drbd_bm_write_copy_pages(struct drbd_device *mdev) __must_hold(local)
+int drbd_bm_write_copy_pages(struct drbd_device *device) __must_hold(local)
 {
-	return bm_rw(mdev, WRITE, BM_AIO_COPY_PAGES, 0);
+	return bm_rw(device, WRITE, BM_AIO_COPY_PAGES, 0);
 }
 
 /**
  * drbd_bm_write_hinted() - Write bitmap pages with "hint" marks, if they have changed.
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  */
-int drbd_bm_write_hinted(struct drbd_device *mdev) __must_hold(local)
+int drbd_bm_write_hinted(struct drbd_device *device) __must_hold(local)
 {
-	return bm_rw(mdev, WRITE, BM_AIO_WRITE_HINTED | BM_AIO_COPY_PAGES, 0);
+	return bm_rw(device, WRITE, BM_AIO_WRITE_HINTED | BM_AIO_COPY_PAGES, 0);
 }
 
 /**
  * drbd_bm_write_page() - Writes a PAGE_SIZE aligned piece of bitmap
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @idx:	bitmap page index
  *
  * We don't want to special case on logical_block_size of the backend device,
@@ -1247,12 +1247,12 @@ int drbd_bm_write_hinted(struct drbd_device *mdev) __must_hold(local)
  * In case this becomes an issue on systems with larger PAGE_SIZE,
  * we may want to change this again to write 4k aligned 4k pieces.
  */
-int drbd_bm_write_page(struct drbd_device *mdev, unsigned int idx) __must_hold(local)
+int drbd_bm_write_page(struct drbd_device *device, unsigned int idx) __must_hold(local)
 {
 	struct bm_aio_ctx *ctx;
 	int err;
 
-	if (bm_test_page_unchanged(mdev->bitmap->bm_pages[idx])) {
+	if (bm_test_page_unchanged(device->bitmap->bm_pages[idx])) {
 		dynamic_dev_dbg(DEV, "skipped bm page write for idx %u\n", idx);
 		return 0;
 	}
@@ -1262,7 +1262,7 @@ int drbd_bm_write_page(struct drbd_device *mdev, unsigned int idx) __must_hold(l
 		return -ENOMEM;
 
 	*ctx = (struct bm_aio_ctx) {
-		.mdev = mdev,
+		.device = device,
 		.in_flight = ATOMIC_INIT(1),
 		.done = 0,
 		.flags = BM_AIO_COPY_PAGES,
@@ -1270,21 +1270,21 @@ int drbd_bm_write_page(struct drbd_device *mdev, unsigned int idx) __must_hold(l
 		.kref = { ATOMIC_INIT(2) },
 	};
 
-	if (!get_ldev_if_state(mdev, D_ATTACHING)) {  /* put is in bm_aio_ctx_destroy() */
+	if (!get_ldev_if_state(device, D_ATTACHING)) {  /* put is in bm_aio_ctx_destroy() */
 		dev_err(DEV, "ASSERT FAILED: get_ldev_if_state() == 1 in drbd_bm_write_page()\n");
 		kfree(ctx);
 		return -ENODEV;
 	}
 
 	bm_page_io_async(ctx, idx, WRITE_SYNC);
-	wait_until_done_or_force_detached(mdev, mdev->ldev, &ctx->done);
+	wait_until_done_or_force_detached(device, device->ldev, &ctx->done);
 
 	if (ctx->error)
-		drbd_chk_io_error(mdev, 1, DRBD_META_IO_ERROR);
+		drbd_chk_io_error(device, 1, DRBD_META_IO_ERROR);
 		/* that causes us to detach, so the in memory bitmap will be
 		 * gone in a moment as well. */
 
-	mdev->bm_writ_cnt++;
+	device->bm_writ_cnt++;
 	err = atomic_read(&ctx->in_flight) ? -EIO : ctx->error;
 	kref_put(&ctx->kref, &bm_aio_ctx_destroy);
 	return err;
@@ -1298,10 +1298,10 @@ int drbd_bm_write_page(struct drbd_device *mdev, unsigned int idx) __must_hold(l
  *
  * this returns a bit number, NOT a sector!
  */
-static unsigned long __bm_find_next(struct drbd_device *mdev, unsigned long bm_fo,
+static unsigned long __bm_find_next(struct drbd_device *device, unsigned long bm_fo,
 	const int find_zero_bit)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	unsigned long *p_addr;
 	unsigned long bit_offset;
 	unsigned i;
@@ -1338,10 +1338,10 @@ static unsigned long __bm_find_next(struct drbd_device *mdev, unsigned long bm_f
 	return bm_fo;
 }
 
-static unsigned long bm_find_next(struct drbd_device *mdev,
+static unsigned long bm_find_next(struct drbd_device *device,
 	unsigned long bm_fo, const int find_zero_bit)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	unsigned long i = DRBD_END_OF_BITMAP;
 
 	if (!expect(b))
@@ -1351,39 +1351,39 @@ static unsigned long bm_find_next(struct drbd_device *mdev,
 
 	spin_lock_irq(&b->bm_lock);
 	if (BM_DONT_TEST & b->bm_flags)
-		bm_print_lock_info(mdev);
+		bm_print_lock_info(device);
 
-	i = __bm_find_next(mdev, bm_fo, find_zero_bit);
+	i = __bm_find_next(device, bm_fo, find_zero_bit);
 
 	spin_unlock_irq(&b->bm_lock);
 	return i;
 }
 
-unsigned long drbd_bm_find_next(struct drbd_device *mdev, unsigned long bm_fo)
+unsigned long drbd_bm_find_next(struct drbd_device *device, unsigned long bm_fo)
 {
-	return bm_find_next(mdev, bm_fo, 0);
+	return bm_find_next(device, bm_fo, 0);
 }
 
 #if 0
 /* not yet needed for anything. */
-unsigned long drbd_bm_find_next_zero(struct drbd_device *mdev, unsigned long bm_fo)
+unsigned long drbd_bm_find_next_zero(struct drbd_device *device, unsigned long bm_fo)
 {
-	return bm_find_next(mdev, bm_fo, 1);
+	return bm_find_next(device, bm_fo, 1);
 }
 #endif
 
 /* does not spin_lock_irqsave.
  * you must take drbd_bm_lock() first */
-unsigned long _drbd_bm_find_next(struct drbd_device *mdev, unsigned long bm_fo)
+unsigned long _drbd_bm_find_next(struct drbd_device *device, unsigned long bm_fo)
 {
-	/* WARN_ON(!(BM_DONT_SET & mdev->b->bm_flags)); */
-	return __bm_find_next(mdev, bm_fo, 0);
+	/* WARN_ON(!(BM_DONT_SET & device->b->bm_flags)); */
+	return __bm_find_next(device, bm_fo, 0);
 }
 
-unsigned long _drbd_bm_find_next_zero(struct drbd_device *mdev, unsigned long bm_fo)
+unsigned long _drbd_bm_find_next_zero(struct drbd_device *device, unsigned long bm_fo)
 {
-	/* WARN_ON(!(BM_DONT_SET & mdev->b->bm_flags)); */
-	return __bm_find_next(mdev, bm_fo, 1);
+	/* WARN_ON(!(BM_DONT_SET & device->b->bm_flags)); */
+	return __bm_find_next(device, bm_fo, 1);
 }
 
 /* returns number of bits actually changed.
@@ -1392,10 +1392,10 @@ unsigned long _drbd_bm_find_next_zero(struct drbd_device *mdev, unsigned long bm
  * wants bitnr, not sector.
  * expected to be called for only a few bits (e - s about BITS_PER_LONG).
  * Must hold bitmap lock already. */
-static int __bm_change_bits_to(struct drbd_device *mdev, const unsigned long s,
+static int __bm_change_bits_to(struct drbd_device *device, const unsigned long s,
 	unsigned long e, int val)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	unsigned long *p_addr = NULL;
 	unsigned long bitnr;
 	unsigned int last_page_nr = -1U;
@@ -1441,11 +1441,11 @@ static int __bm_change_bits_to(struct drbd_device *mdev, const unsigned long s,
  * for val != 0, we change 0 -> 1, return code positive
  * for val == 0, we change 1 -> 0, return code negative
  * wants bitnr, not sector */
-static int bm_change_bits_to(struct drbd_device *mdev, const unsigned long s,
+static int bm_change_bits_to(struct drbd_device *device, const unsigned long s,
 	const unsigned long e, int val)
 {
 	unsigned long flags;
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	int c = 0;
 
 	if (!expect(b))
@@ -1455,24 +1455,24 @@ static int bm_change_bits_to(struct drbd_device *mdev, const unsigned long s,
 
 	spin_lock_irqsave(&b->bm_lock, flags);
 	if ((val ? BM_DONT_SET : BM_DONT_CLEAR) & b->bm_flags)
-		bm_print_lock_info(mdev);
+		bm_print_lock_info(device);
 
-	c = __bm_change_bits_to(mdev, s, e, val);
+	c = __bm_change_bits_to(device, s, e, val);
 
 	spin_unlock_irqrestore(&b->bm_lock, flags);
 	return c;
 }
 
 /* returns number of bits changed 0 -> 1 */
-int drbd_bm_set_bits(struct drbd_device *mdev, const unsigned long s, const unsigned long e)
+int drbd_bm_set_bits(struct drbd_device *device, const unsigned long s, const unsigned long e)
 {
-	return bm_change_bits_to(mdev, s, e, 1);
+	return bm_change_bits_to(device, s, e, 1);
 }
 
 /* returns number of bits changed 1 -> 0 */
-int drbd_bm_clear_bits(struct drbd_device *mdev, const unsigned long s, const unsigned long e)
+int drbd_bm_clear_bits(struct drbd_device *device, const unsigned long s, const unsigned long e)
 {
-	return -bm_change_bits_to(mdev, s, e, 0);
+	return -bm_change_bits_to(device, s, e, 0);
 }
 
 /* sets all bits in full words,
@@ -1504,7 +1504,7 @@ static inline void bm_set_full_words_within_one_page(struct drbd_bitmap *b,
  * You must first drbd_bm_lock().
  * Can be called to set the whole bitmap in one go.
  * Sets bits from s to e _inclusive_. */
-void _drbd_bm_set_bits(struct drbd_device *mdev, const unsigned long s, const unsigned long e)
+void _drbd_bm_set_bits(struct drbd_device *device, const unsigned long s, const unsigned long e)
 {
 	/* First set_bit from the first bit (s)
 	 * up to the next long boundary (sl),
@@ -1514,7 +1514,7 @@ void _drbd_bm_set_bits(struct drbd_device *mdev, const unsigned long s, const un
 	 * Do not use memset, because we must account for changes,
 	 * so we need to loop over the words with hweight() anyways.
 	 */
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	unsigned long sl = ALIGN(s,BITS_PER_LONG);
 	unsigned long el = (e+1) & ~((unsigned long)BITS_PER_LONG-1);
 	int first_page;
@@ -1526,7 +1526,7 @@ void _drbd_bm_set_bits(struct drbd_device *mdev, const unsigned long s, const un
 	if (e - s <= 3*BITS_PER_LONG) {
 		/* don't bother; el and sl may even be wrong. */
 		spin_lock_irq(&b->bm_lock);
-		__bm_change_bits_to(mdev, s, e, 1);
+		__bm_change_bits_to(device, s, e, 1);
 		spin_unlock_irq(&b->bm_lock);
 		return;
 	}
@@ -1537,7 +1537,7 @@ void _drbd_bm_set_bits(struct drbd_device *mdev, const unsigned long s, const un
 
 	/* bits filling the current long */
 	if (sl)
-		__bm_change_bits_to(mdev, s, sl-1, 1);
+		__bm_change_bits_to(device, s, sl-1, 1);
 
 	first_page = sl >> (3 + PAGE_SHIFT);
 	last_page = el >> (3 + PAGE_SHIFT);
@@ -1549,7 +1549,7 @@ void _drbd_bm_set_bits(struct drbd_device *mdev, const unsigned long s, const un
 
 	/* first and full pages, unless first page == last page */
 	for (page_nr = first_page; page_nr < last_page; page_nr++) {
-		bm_set_full_words_within_one_page(mdev->bitmap, page_nr, first_word, last_word);
+		bm_set_full_words_within_one_page(device->bitmap, page_nr, first_word, last_word);
 		spin_unlock_irq(&b->bm_lock);
 		cond_resched();
 		first_word = 0;
@@ -1565,7 +1565,7 @@ void _drbd_bm_set_bits(struct drbd_device *mdev, const unsigned long s, const un
 	 * as we did not allocate it, it is not present in bitmap->bm_pages.
 	 */
 	if (last_word)
-		bm_set_full_words_within_one_page(mdev->bitmap, last_page, first_word, last_word);
+		bm_set_full_words_within_one_page(device->bitmap, last_page, first_word, last_word);
 
 	/* possibly trailing bits.
 	 * example: (e & 63) == 63, el will be e+1.
@@ -1573,7 +1573,7 @@ void _drbd_bm_set_bits(struct drbd_device *mdev, const unsigned long s, const un
 	 * it would trigger an assert in __bm_change_bits_to()
 	 */
 	if (el <= e)
-		__bm_change_bits_to(mdev, el, e, 1);
+		__bm_change_bits_to(device, el, e, 1);
 	spin_unlock_irq(&b->bm_lock);
 }
 
@@ -1584,10 +1584,10 @@ void _drbd_bm_set_bits(struct drbd_device *mdev, const unsigned long s, const un
  *  0 ... bit not set
  * -1 ... first out of bounds access, stop testing for bits!
  */
-int drbd_bm_test_bit(struct drbd_device *mdev, const unsigned long bitnr)
+int drbd_bm_test_bit(struct drbd_device *device, const unsigned long bitnr)
 {
 	unsigned long flags;
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	unsigned long *p_addr;
 	int i;
 
@@ -1598,7 +1598,7 @@ int drbd_bm_test_bit(struct drbd_device *mdev, const unsigned long bitnr)
 
 	spin_lock_irqsave(&b->bm_lock, flags);
 	if (BM_DONT_TEST & b->bm_flags)
-		bm_print_lock_info(mdev);
+		bm_print_lock_info(device);
 	if (bitnr < b->bm_bits) {
 		p_addr = bm_map_pidx(b, bm_bit_to_page_idx(b, bitnr));
 		i = test_bit_le(bitnr & BITS_PER_PAGE_MASK, p_addr) ? 1 : 0;
@@ -1615,10 +1615,10 @@ int drbd_bm_test_bit(struct drbd_device *mdev, const unsigned long bitnr)
 }
 
 /* returns number of bits set in the range [s, e] */
-int drbd_bm_count_bits(struct drbd_device *mdev, const unsigned long s, const unsigned long e)
+int drbd_bm_count_bits(struct drbd_device *device, const unsigned long s, const unsigned long e)
 {
 	unsigned long flags;
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	unsigned long *p_addr = NULL;
 	unsigned long bitnr;
 	unsigned int page_nr = -1U;
@@ -1635,7 +1635,7 @@ int drbd_bm_count_bits(struct drbd_device *mdev, const unsigned long s, const un
 
 	spin_lock_irqsave(&b->bm_lock, flags);
 	if (BM_DONT_TEST & b->bm_flags)
-		bm_print_lock_info(mdev);
+		bm_print_lock_info(device);
 	for (bitnr = s; bitnr <= e; bitnr++) {
 		unsigned int idx = bm_bit_to_page_idx(b, bitnr);
 		if (page_nr != idx) {
@@ -1670,9 +1670,9 @@ int drbd_bm_count_bits(struct drbd_device *mdev, const unsigned long s, const un
  * reference count of some bitmap extent element from some lru instead...
  *
  */
-int drbd_bm_e_weight(struct drbd_device *mdev, unsigned long enr)
+int drbd_bm_e_weight(struct drbd_device *device, unsigned long enr)
 {
-	struct drbd_bitmap *b = mdev->bitmap;
+	struct drbd_bitmap *b = device->bitmap;
 	int count, s, e;
 	unsigned long flags;
 	unsigned long *p_addr, *bm;
@@ -1684,7 +1684,7 @@ int drbd_bm_e_weight(struct drbd_device *mdev, unsigned long enr)
 
 	spin_lock_irqsave(&b->bm_lock, flags);
 	if (BM_DONT_TEST & b->bm_flags)
-		bm_print_lock_info(mdev);
+		bm_print_lock_info(device);
 
 	s = S2W(enr);
 	e = min((size_t)S2W(enr+1), b->bm_words);
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 143fadb..ab01b15 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -101,7 +101,7 @@ struct drbd_tconn;
 
 
 /* to shorten dev_warn(DEV, "msg"); and relatives statements */
-#define DEV (disk_to_dev(mdev->vdisk))
+#define DEV (disk_to_dev(device->vdisk))
 
 #define conn_printk(LEVEL, TCONN, FMT, ARGS...) \
 	printk(LEVEL "d-con %s: " FMT, TCONN->name , ## ARGS)
@@ -146,14 +146,14 @@ enum {
 };
 
 extern unsigned int
-_drbd_insert_fault(struct drbd_device *mdev, unsigned int type);
+_drbd_insert_fault(struct drbd_device *device, unsigned int type);
 
 static inline int
-drbd_insert_fault(struct drbd_device *mdev, unsigned int type) {
+drbd_insert_fault(struct drbd_device *device, unsigned int type) {
 #ifdef CONFIG_DRBD_FAULT_INJECTION
 	return fault_rate &&
 		(enable_faults & (1<<type)) &&
-		_drbd_insert_fault(mdev, type);
+		_drbd_insert_fault(device, type);
 #else
 	return 0;
 #endif
@@ -188,7 +188,7 @@ struct bm_xfer_ctx {
 	unsigned bytes[2];
 };
 
-extern void INFO_bm_xfer_stats(struct drbd_device *mdev,
+extern void INFO_bm_xfer_stats(struct drbd_device *device,
 		const char *direction, struct bm_xfer_ctx *c);
 
 static inline void bm_xfer_ctx_bit_to_word_offset(struct bm_xfer_ctx *c)
@@ -245,7 +245,7 @@ struct drbd_work {
 	struct list_head list;
 	int (*cb)(struct drbd_work *, int cancel);
 	union {
-		struct drbd_device *mdev;
+		struct drbd_device *device;
 		struct drbd_tconn *tconn;
 	};
 };
@@ -372,7 +372,7 @@ enum {
 #define EE_SEND_WRITE_ACK	(1<<__EE_SEND_WRITE_ACK)
 #define EE_IN_INTERVAL_TREE	(1<<__EE_IN_INTERVAL_TREE)
 
-/* flag bits per mdev */
+/* flag bits per device */
 enum {
 	UNPLUG_REMOTE,		/* sending a "UnplugRemote" could help */
 	MD_DIRTY,		/* current uuids and flags not yet on disk */
@@ -478,7 +478,7 @@ struct drbd_backing_dev {
 	struct block_device *backing_bdev;
 	struct block_device *md_bdev;
 	struct drbd_md md;
-	struct disk_conf *disk_conf; /* RCU, for updates: mdev->tconn->conf_update */
+	struct disk_conf *disk_conf; /* RCU, for updates: device->tconn->conf_update */
 	sector_t known_size; /* last known size of that backing device */
 };
 
@@ -491,8 +491,8 @@ struct bm_io_work {
 	struct drbd_work w;
 	char *why;
 	enum bm_flag flags;
-	int (*io_fn)(struct drbd_device *mdev);
-	void (*done)(struct drbd_device *mdev, int rv);
+	int (*io_fn)(struct drbd_device *device);
+	void (*done)(struct drbd_device *device, int rv);
 };
 
 enum write_ordering_e {
@@ -535,7 +535,7 @@ struct drbd_tconn {			/* is a resource from the config file */
 	char *name;			/* Resource name */
 	struct list_head all_tconn;	/* linked on global drbd_tconns */
 	struct kref kref;
-	struct idr volumes;		/* <tconn, vnr> to mdev mapping */
+	struct idr volumes;		/* <tconn, vnr> to device mapping */
 	enum drbd_conns cstate;		/* Only C_STANDALONE to C_WF_REPORT_PARAMS */
 	unsigned susp:1;		/* IO suspended by user */
 	unsigned susp_nod:1;		/* IO suspended because no data */
@@ -739,7 +739,7 @@ struct drbd_device {
 	struct bm_io_work bm_io_work;
 	u64 ed_uuid; /* UUID of the exposed data */
 	struct mutex own_state_mutex;
-	struct mutex *state_mutex; /* either own_state_mutex or mdev->tconn->cstate_mutex */
+	struct mutex *state_mutex; /* either own_state_mutex or device->tconn->cstate_mutex */
 	char congestion_reason;  /* Why we where congested... */
 	atomic_t rs_sect_in; /* for incoming resync data rate, SyncTarget */
 	atomic_t rs_sect_ev; /* for submitted resync data rate, both */
@@ -758,17 +758,17 @@ struct drbd_device {
 	struct submit_worker submit;
 };
 
-static inline struct drbd_device *minor_to_mdev(unsigned int minor)
+static inline struct drbd_device *minor_to_device(unsigned int minor)
 {
 	return (struct drbd_device *)idr_find(&minors, minor);
 }
 
-static inline unsigned int mdev_to_minor(struct drbd_device *mdev)
+static inline unsigned int device_to_minor(struct drbd_device *device)
 {
-	return mdev->minor;
+	return device->minor;
 }
 
-static inline struct drbd_device *vnr_to_mdev(struct drbd_tconn *tconn, int vnr)
+static inline struct drbd_device *vnr_to_device(struct drbd_tconn *tconn, int vnr)
 {
 	return (struct drbd_device *)idr_find(&tconn->volumes, vnr);
 }
@@ -784,7 +784,7 @@ enum dds_flags {
 	DDSF_NO_RESYNC = 2, /* Do not run a resync for the new space */
 };
 
-extern void drbd_init_set_defaults(struct drbd_device *mdev);
+extern void drbd_init_set_defaults(struct drbd_device *device);
 extern int  drbd_thread_start(struct drbd_thread *thi);
 extern void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait);
 extern char *drbd_task_to_thread_name(struct drbd_tconn *tconn, struct task_struct *task);
@@ -806,74 +806,74 @@ extern int drbd_send_all(struct drbd_tconn *, struct socket *, void *, size_t,
 
 extern int __drbd_send_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd);
 extern int drbd_send_protocol(struct drbd_tconn *tconn);
-extern int drbd_send_uuids(struct drbd_device *mdev);
-extern int drbd_send_uuids_skip_initial_sync(struct drbd_device *mdev);
-extern void drbd_gen_and_send_sync_uuid(struct drbd_device *mdev);
-extern int drbd_send_sizes(struct drbd_device *mdev, int trigger_reply, enum dds_flags flags);
-extern int drbd_send_state(struct drbd_device *mdev, union drbd_state s);
-extern int drbd_send_current_state(struct drbd_device *mdev);
-extern int drbd_send_sync_param(struct drbd_device *mdev);
+extern int drbd_send_uuids(struct drbd_device *device);
+extern int drbd_send_uuids_skip_initial_sync(struct drbd_device *device);
+extern void drbd_gen_and_send_sync_uuid(struct drbd_device *device);
+extern int drbd_send_sizes(struct drbd_device *device, int trigger_reply, enum dds_flags flags);
+extern int drbd_send_state(struct drbd_device *device, union drbd_state s);
+extern int drbd_send_current_state(struct drbd_device *device);
+extern int drbd_send_sync_param(struct drbd_device *device);
 extern void drbd_send_b_ack(struct drbd_tconn *tconn, u32 barrier_nr,
 			    u32 set_size);
 extern int drbd_send_ack(struct drbd_device *, enum drbd_packet,
 			 struct drbd_peer_request *);
-extern void drbd_send_ack_rp(struct drbd_device *mdev, enum drbd_packet cmd,
+extern void drbd_send_ack_rp(struct drbd_device *device, enum drbd_packet cmd,
 			     struct p_block_req *rp);
-extern void drbd_send_ack_dp(struct drbd_device *mdev, enum drbd_packet cmd,
+extern void drbd_send_ack_dp(struct drbd_device *device, enum drbd_packet cmd,
 			     struct p_data *dp, int data_size);
-extern int drbd_send_ack_ex(struct drbd_device *mdev, enum drbd_packet cmd,
+extern int drbd_send_ack_ex(struct drbd_device *device, enum drbd_packet cmd,
 			    sector_t sector, int blksize, u64 block_id);
 extern int drbd_send_out_of_sync(struct drbd_device *, struct drbd_request *);
 extern int drbd_send_block(struct drbd_device *, enum drbd_packet,
 			   struct drbd_peer_request *);
-extern int drbd_send_dblock(struct drbd_device *mdev, struct drbd_request *req);
-extern int drbd_send_drequest(struct drbd_device *mdev, int cmd,
+extern int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req);
+extern int drbd_send_drequest(struct drbd_device *device, int cmd,
 			      sector_t sector, int size, u64 block_id);
-extern int drbd_send_drequest_csum(struct drbd_device *mdev, sector_t sector,
+extern int drbd_send_drequest_csum(struct drbd_device *device, sector_t sector,
 				   int size, void *digest, int digest_size,
 				   enum drbd_packet cmd);
-extern int drbd_send_ov_request(struct drbd_device *mdev, sector_t sector, int size);
+extern int drbd_send_ov_request(struct drbd_device *device, sector_t sector, int size);
 
-extern int drbd_send_bitmap(struct drbd_device *mdev);
-extern void drbd_send_sr_reply(struct drbd_device *mdev, enum drbd_state_rv retcode);
+extern int drbd_send_bitmap(struct drbd_device *device);
+extern void drbd_send_sr_reply(struct drbd_device *device, enum drbd_state_rv retcode);
 extern void conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode);
 extern void drbd_free_bc(struct drbd_backing_dev *ldev);
-extern void drbd_mdev_cleanup(struct drbd_device *mdev);
-void drbd_print_uuids(struct drbd_device *mdev, const char *text);
+extern void drbd_device_cleanup(struct drbd_device *device);
+void drbd_print_uuids(struct drbd_device *device, const char *text);
 
 extern void conn_md_sync(struct drbd_tconn *tconn);
-extern void drbd_md_write(struct drbd_device *mdev, void *buffer);
-extern void drbd_md_sync(struct drbd_device *mdev);
-extern int  drbd_md_read(struct drbd_device *mdev, struct drbd_backing_dev *bdev);
-extern void drbd_uuid_set(struct drbd_device *mdev, int idx, u64 val) __must_hold(local);
-extern void _drbd_uuid_set(struct drbd_device *mdev, int idx, u64 val) __must_hold(local);
-extern void drbd_uuid_new_current(struct drbd_device *mdev) __must_hold(local);
-extern void drbd_uuid_set_bm(struct drbd_device *mdev, u64 val) __must_hold(local);
-extern void drbd_uuid_move_history(struct drbd_device *mdev) __must_hold(local);
-extern void __drbd_uuid_set(struct drbd_device *mdev, int idx, u64 val) __must_hold(local);
-extern void drbd_md_set_flag(struct drbd_device *mdev, int flags) __must_hold(local);
-extern void drbd_md_clear_flag(struct drbd_device *mdev, int flags)__must_hold(local);
+extern void drbd_md_write(struct drbd_device *device, void *buffer);
+extern void drbd_md_sync(struct drbd_device *device);
+extern int  drbd_md_read(struct drbd_device *device, struct drbd_backing_dev *bdev);
+extern void drbd_uuid_set(struct drbd_device *device, int idx, u64 val) __must_hold(local);
+extern void _drbd_uuid_set(struct drbd_device *device, int idx, u64 val) __must_hold(local);
+extern void drbd_uuid_new_current(struct drbd_device *device) __must_hold(local);
+extern void drbd_uuid_set_bm(struct drbd_device *device, u64 val) __must_hold(local);
+extern void drbd_uuid_move_history(struct drbd_device *device) __must_hold(local);
+extern void __drbd_uuid_set(struct drbd_device *device, int idx, u64 val) __must_hold(local);
+extern void drbd_md_set_flag(struct drbd_device *device, int flags) __must_hold(local);
+extern void drbd_md_clear_flag(struct drbd_device *device, int flags)__must_hold(local);
 extern int drbd_md_test_flag(struct drbd_backing_dev *, int);
 #ifndef DRBD_DEBUG_MD_SYNC
-extern void drbd_md_mark_dirty(struct drbd_device *mdev);
+extern void drbd_md_mark_dirty(struct drbd_device *device);
 #else
 #define drbd_md_mark_dirty(m)	drbd_md_mark_dirty_(m, __LINE__ , __func__ )
-extern void drbd_md_mark_dirty_(struct drbd_device *mdev,
+extern void drbd_md_mark_dirty_(struct drbd_device *device,
 		unsigned int line, const char *func);
 #endif
-extern void drbd_queue_bitmap_io(struct drbd_device *mdev,
+extern void drbd_queue_bitmap_io(struct drbd_device *device,
 				 int (*io_fn)(struct drbd_device *),
 				 void (*done)(struct drbd_device *, int),
 				 char *why, enum bm_flag flags);
-extern int drbd_bitmap_io(struct drbd_device *mdev,
+extern int drbd_bitmap_io(struct drbd_device *device,
 		int (*io_fn)(struct drbd_device *),
 		char *why, enum bm_flag flags);
-extern int drbd_bitmap_io_from_worker(struct drbd_device *mdev,
+extern int drbd_bitmap_io_from_worker(struct drbd_device *device,
 		int (*io_fn)(struct drbd_device *),
 		char *why, enum bm_flag flags);
-extern int drbd_bmio_set_n_write(struct drbd_device *mdev);
-extern int drbd_bmio_clear_n_write(struct drbd_device *mdev);
-extern void drbd_ldev_destroy(struct drbd_device *mdev);
+extern int drbd_bmio_set_n_write(struct drbd_device *device);
+extern int drbd_bmio_clear_n_write(struct drbd_device *device);
+extern void drbd_ldev_destroy(struct drbd_device *device);
 
 /* Meta data layout
  *
@@ -1059,52 +1059,52 @@ struct bm_extent {
 #define DRBD_MAX_SIZE_H80_PACKET (1U << 15) /* Header 80 only allows packets up to 32KiB data */
 #define DRBD_MAX_BIO_SIZE_P95    (1U << 17) /* Protocol 95 to 99 allows bios up to 128KiB */
 
-extern int  drbd_bm_init(struct drbd_device *mdev);
-extern int  drbd_bm_resize(struct drbd_device *mdev, sector_t sectors, int set_new_bits);
-extern void drbd_bm_cleanup(struct drbd_device *mdev);
-extern void drbd_bm_set_all(struct drbd_device *mdev);
-extern void drbd_bm_clear_all(struct drbd_device *mdev);
+extern int  drbd_bm_init(struct drbd_device *device);
+extern int  drbd_bm_resize(struct drbd_device *device, sector_t sectors, int set_new_bits);
+extern void drbd_bm_cleanup(struct drbd_device *device);
+extern void drbd_bm_set_all(struct drbd_device *device);
+extern void drbd_bm_clear_all(struct drbd_device *device);
 /* set/clear/test only a few bits at a time */
 extern int  drbd_bm_set_bits(
-		struct drbd_device *mdev, unsigned long s, unsigned long e);
+		struct drbd_device *device, unsigned long s, unsigned long e);
 extern int  drbd_bm_clear_bits(
-		struct drbd_device *mdev, unsigned long s, unsigned long e);
+		struct drbd_device *device, unsigned long s, unsigned long e);
 extern int drbd_bm_count_bits(
-	struct drbd_device *mdev, const unsigned long s, const unsigned long e);
+	struct drbd_device *device, const unsigned long s, const unsigned long e);
 /* bm_set_bits variant for use while holding drbd_bm_lock,
  * may process the whole bitmap in one go */
-extern void _drbd_bm_set_bits(struct drbd_device *mdev,
+extern void _drbd_bm_set_bits(struct drbd_device *device,
 		const unsigned long s, const unsigned long e);
-extern int  drbd_bm_test_bit(struct drbd_device *mdev, unsigned long bitnr);
-extern int  drbd_bm_e_weight(struct drbd_device *mdev, unsigned long enr);
-extern int  drbd_bm_write_page(struct drbd_device *mdev, unsigned int idx) __must_hold(local);
-extern int  drbd_bm_read(struct drbd_device *mdev) __must_hold(local);
-extern void drbd_bm_mark_for_writeout(struct drbd_device *mdev, int page_nr);
-extern int  drbd_bm_write(struct drbd_device *mdev) __must_hold(local);
-extern int  drbd_bm_write_hinted(struct drbd_device *mdev) __must_hold(local);
-extern int drbd_bm_write_all(struct drbd_device *mdev) __must_hold(local);
-extern int  drbd_bm_write_copy_pages(struct drbd_device *mdev) __must_hold(local);
-extern size_t	     drbd_bm_words(struct drbd_device *mdev);
-extern unsigned long drbd_bm_bits(struct drbd_device *mdev);
-extern sector_t      drbd_bm_capacity(struct drbd_device *mdev);
+extern int  drbd_bm_test_bit(struct drbd_device *device, unsigned long bitnr);
+extern int  drbd_bm_e_weight(struct drbd_device *device, unsigned long enr);
+extern int  drbd_bm_write_page(struct drbd_device *device, unsigned int idx) __must_hold(local);
+extern int  drbd_bm_read(struct drbd_device *device) __must_hold(local);
+extern void drbd_bm_mark_for_writeout(struct drbd_device *device, int page_nr);
+extern int  drbd_bm_write(struct drbd_device *device) __must_hold(local);
+extern int  drbd_bm_write_hinted(struct drbd_device *device) __must_hold(local);
+extern int drbd_bm_write_all(struct drbd_device *device) __must_hold(local);
+extern int  drbd_bm_write_copy_pages(struct drbd_device *device) __must_hold(local);
+extern size_t	     drbd_bm_words(struct drbd_device *device);
+extern unsigned long drbd_bm_bits(struct drbd_device *device);
+extern sector_t      drbd_bm_capacity(struct drbd_device *device);
 
 #define DRBD_END_OF_BITMAP	(~(unsigned long)0)
-extern unsigned long drbd_bm_find_next(struct drbd_device *mdev, unsigned long bm_fo);
+extern unsigned long drbd_bm_find_next(struct drbd_device *device, unsigned long bm_fo);
 /* bm_find_next variants for use while you hold drbd_bm_lock() */
-extern unsigned long _drbd_bm_find_next(struct drbd_device *mdev, unsigned long bm_fo);
-extern unsigned long _drbd_bm_find_next_zero(struct drbd_device *mdev, unsigned long bm_fo);
-extern unsigned long _drbd_bm_total_weight(struct drbd_device *mdev);
-extern unsigned long drbd_bm_total_weight(struct drbd_device *mdev);
-extern int drbd_bm_rs_done(struct drbd_device *mdev);
+extern unsigned long _drbd_bm_find_next(struct drbd_device *device, unsigned long bm_fo);
+extern unsigned long _drbd_bm_find_next_zero(struct drbd_device *device, unsigned long bm_fo);
+extern unsigned long _drbd_bm_total_weight(struct drbd_device *device);
+extern unsigned long drbd_bm_total_weight(struct drbd_device *device);
+extern int drbd_bm_rs_done(struct drbd_device *device);
 /* for receive_bitmap */
-extern void drbd_bm_merge_lel(struct drbd_device *mdev, size_t offset,
+extern void drbd_bm_merge_lel(struct drbd_device *device, size_t offset,
 		size_t number, unsigned long *buffer);
 /* for _drbd_send_bitmap */
-extern void drbd_bm_get_lel(struct drbd_device *mdev, size_t offset,
+extern void drbd_bm_get_lel(struct drbd_device *device, size_t offset,
 		size_t number, unsigned long *buffer);
 
-extern void drbd_bm_lock(struct drbd_device *mdev, char *why, enum bm_flag flags);
-extern void drbd_bm_unlock(struct drbd_device *mdev);
+extern void drbd_bm_lock(struct drbd_device *device, char *why, enum bm_flag flags);
+extern void drbd_bm_unlock(struct drbd_device *device);
 /* drbd_main.c */
 
 extern struct kmem_cache *drbd_request_cache;
@@ -1166,15 +1166,15 @@ extern int proc_details;
 extern void do_submit(struct work_struct *ws);
 extern void __drbd_make_request(struct drbd_device *, struct bio *, unsigned long);
 extern void drbd_make_request(struct request_queue *q, struct bio *bio);
-extern int drbd_read_remote(struct drbd_device *mdev, struct drbd_request *req);
+extern int drbd_read_remote(struct drbd_device *device, struct drbd_request *req);
 extern int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct bio_vec *bvec);
 extern int is_valid_ar_handle(struct drbd_request *, sector_t);
 
 
 /* drbd_nl.c */
 extern int drbd_msg_put_info(const char *info);
-extern void drbd_suspend_io(struct drbd_device *mdev);
-extern void drbd_resume_io(struct drbd_device *mdev);
+extern void drbd_suspend_io(struct drbd_device *device);
+extern void drbd_resume_io(struct drbd_device *device);
 extern char *ppsize(char *buf, unsigned long long size);
 extern sector_t drbd_new_dev_size(struct drbd_device *, struct drbd_backing_dev *, sector_t, int);
 enum determine_dev_size {
@@ -1189,40 +1189,40 @@ enum determine_dev_size {
 extern enum determine_dev_size
 drbd_determine_dev_size(struct drbd_device *, enum dds_flags, struct resize_parms *) __must_hold(local);
 extern void resync_after_online_grow(struct drbd_device *);
-extern void drbd_reconsider_max_bio_size(struct drbd_device *mdev);
-extern enum drbd_state_rv drbd_set_role(struct drbd_device *mdev,
+extern void drbd_reconsider_max_bio_size(struct drbd_device *device);
+extern enum drbd_state_rv drbd_set_role(struct drbd_device *device,
 					enum drbd_role new_role,
 					int force);
 extern bool conn_try_outdate_peer(struct drbd_tconn *tconn);
 extern void conn_try_outdate_peer_async(struct drbd_tconn *tconn);
-extern int drbd_khelper(struct drbd_device *mdev, char *cmd);
+extern int drbd_khelper(struct drbd_device *device, char *cmd);
 
 /* drbd_worker.c */
 extern int drbd_worker(struct drbd_thread *thi);
-enum drbd_ret_code drbd_resync_after_valid(struct drbd_device *mdev, int o_minor);
-void drbd_resync_after_changed(struct drbd_device *mdev);
-extern void drbd_start_resync(struct drbd_device *mdev, enum drbd_conns side);
-extern void resume_next_sg(struct drbd_device *mdev);
-extern void suspend_other_sg(struct drbd_device *mdev);
-extern int drbd_resync_finished(struct drbd_device *mdev);
+enum drbd_ret_code drbd_resync_after_valid(struct drbd_device *device, int o_minor);
+void drbd_resync_after_changed(struct drbd_device *device);
+extern void drbd_start_resync(struct drbd_device *device, enum drbd_conns side);
+extern void resume_next_sg(struct drbd_device *device);
+extern void suspend_other_sg(struct drbd_device *device);
+extern int drbd_resync_finished(struct drbd_device *device);
 /* maybe rather drbd_main.c ? */
-extern void *drbd_md_get_buffer(struct drbd_device *mdev);
-extern void drbd_md_put_buffer(struct drbd_device *mdev);
-extern int drbd_md_sync_page_io(struct drbd_device *mdev,
+extern void *drbd_md_get_buffer(struct drbd_device *device);
+extern void drbd_md_put_buffer(struct drbd_device *device);
+extern int drbd_md_sync_page_io(struct drbd_device *device,
 		struct drbd_backing_dev *bdev, sector_t sector, int rw);
 extern void drbd_ov_out_of_sync_found(struct drbd_device *, sector_t, int);
-extern void wait_until_done_or_force_detached(struct drbd_device *mdev,
+extern void wait_until_done_or_force_detached(struct drbd_device *device,
 		struct drbd_backing_dev *bdev, unsigned int *done);
-extern void drbd_rs_controller_reset(struct drbd_device *mdev);
+extern void drbd_rs_controller_reset(struct drbd_device *device);
 
-static inline void ov_out_of_sync_print(struct drbd_device *mdev)
+static inline void ov_out_of_sync_print(struct drbd_device *device)
 {
-	if (mdev->ov_last_oos_size) {
+	if (device->ov_last_oos_size) {
 		dev_err(DEV, "Out of sync: start=%llu, size=%lu (sectors)\n",
-		     (unsigned long long)mdev->ov_last_oos_start,
-		     (unsigned long)mdev->ov_last_oos_size);
+		     (unsigned long long)device->ov_last_oos_start,
+		     (unsigned long)device->ov_last_oos_size);
 	}
-	mdev->ov_last_oos_size=0;
+	device->ov_last_oos_size = 0;
 }
 
 
@@ -1251,7 +1251,7 @@ extern void resync_timer_fn(unsigned long data);
 extern void start_resync_timer_fn(unsigned long data);
 
 /* drbd_receiver.c */
-extern int drbd_rs_should_slow_down(struct drbd_device *mdev, sector_t sector);
+extern int drbd_rs_should_slow_down(struct drbd_device *device, sector_t sector);
 extern int drbd_submit_peer_request(struct drbd_device *,
 				    struct drbd_peer_request *, const unsigned,
 				    const int);
@@ -1264,13 +1264,13 @@ extern void __drbd_free_peer_req(struct drbd_device *, struct drbd_peer_request
 #define drbd_free_peer_req(m,e) __drbd_free_peer_req(m, e, 0)
 #define drbd_free_net_peer_req(m,e) __drbd_free_peer_req(m, e, 1)
 extern struct page *drbd_alloc_pages(struct drbd_device *, unsigned int, bool);
-extern void drbd_set_recv_tcq(struct drbd_device *mdev, int tcq_enabled);
-extern void _drbd_clear_done_ee(struct drbd_device *mdev, struct list_head *to_be_freed);
+extern void drbd_set_recv_tcq(struct drbd_device *device, int tcq_enabled);
+extern void _drbd_clear_done_ee(struct drbd_device *device, struct list_head *to_be_freed);
 extern void conn_flush_workqueue(struct drbd_tconn *tconn);
-extern int drbd_connected(struct drbd_device *mdev);
-static inline void drbd_flush_workqueue(struct drbd_device *mdev)
+extern int drbd_connected(struct drbd_device *device);
+static inline void drbd_flush_workqueue(struct drbd_device *device)
 {
-	conn_flush_workqueue(mdev->tconn);
+	conn_flush_workqueue(device->tconn);
 }
 
 /* Yes, there is kernel_setsockopt, but only since 2.6.18.
@@ -1331,28 +1331,28 @@ extern const char *drbd_conn_str(enum drbd_conns s);
 extern const char *drbd_role_str(enum drbd_role s);
 
 /* drbd_actlog.c */
-extern int drbd_al_begin_io_nonblock(struct drbd_device *mdev, struct drbd_interval *i);
-extern void drbd_al_begin_io_commit(struct drbd_device *mdev, bool delegate);
-extern bool drbd_al_begin_io_fastpath(struct drbd_device *mdev, struct drbd_interval *i);
-extern void drbd_al_begin_io(struct drbd_device *mdev, struct drbd_interval *i, bool delegate);
-extern void drbd_al_complete_io(struct drbd_device *mdev, struct drbd_interval *i);
-extern void drbd_rs_complete_io(struct drbd_device *mdev, sector_t sector);
-extern int drbd_rs_begin_io(struct drbd_device *mdev, sector_t sector);
-extern int drbd_try_rs_begin_io(struct drbd_device *mdev, sector_t sector);
-extern void drbd_rs_cancel_all(struct drbd_device *mdev);
-extern int drbd_rs_del_all(struct drbd_device *mdev);
-extern void drbd_rs_failed_io(struct drbd_device *mdev,
+extern int drbd_al_begin_io_nonblock(struct drbd_device *device, struct drbd_interval *i);
+extern void drbd_al_begin_io_commit(struct drbd_device *device, bool delegate);
+extern bool drbd_al_begin_io_fastpath(struct drbd_device *device, struct drbd_interval *i);
+extern void drbd_al_begin_io(struct drbd_device *device, struct drbd_interval *i, bool delegate);
+extern void drbd_al_complete_io(struct drbd_device *device, struct drbd_interval *i);
+extern void drbd_rs_complete_io(struct drbd_device *device, sector_t sector);
+extern int drbd_rs_begin_io(struct drbd_device *device, sector_t sector);
+extern int drbd_try_rs_begin_io(struct drbd_device *device, sector_t sector);
+extern void drbd_rs_cancel_all(struct drbd_device *device);
+extern int drbd_rs_del_all(struct drbd_device *device);
+extern void drbd_rs_failed_io(struct drbd_device *device,
 		sector_t sector, int size);
-extern void drbd_advance_rs_marks(struct drbd_device *mdev, unsigned long still_to_go);
-extern void __drbd_set_in_sync(struct drbd_device *mdev, sector_t sector,
+extern void drbd_advance_rs_marks(struct drbd_device *device, unsigned long still_to_go);
+extern void __drbd_set_in_sync(struct drbd_device *device, sector_t sector,
 		int size, const char *file, const unsigned int line);
-#define drbd_set_in_sync(mdev, sector, size) \
-	__drbd_set_in_sync(mdev, sector, size, __FILE__, __LINE__)
-extern int __drbd_set_out_of_sync(struct drbd_device *mdev, sector_t sector,
+#define drbd_set_in_sync(device, sector, size) \
+	__drbd_set_in_sync(device, sector, size, __FILE__, __LINE__)
+extern int __drbd_set_out_of_sync(struct drbd_device *device, sector_t sector,
 		int size, const char *file, const unsigned int line);
-#define drbd_set_out_of_sync(mdev, sector, size) \
-	__drbd_set_out_of_sync(mdev, sector, size, __FILE__, __LINE__)
-extern void drbd_al_shrink(struct drbd_device *mdev);
+#define drbd_set_out_of_sync(device, sector, size) \
+	__drbd_set_out_of_sync(device, sector, size, __FILE__, __LINE__)
+extern void drbd_al_shrink(struct drbd_device *device);
 extern int drbd_initialize_al(struct drbd_device *, void *);
 
 /* drbd_nl.c */
@@ -1370,7 +1370,7 @@ struct sib_info {
 		};
 	};
 };
-void drbd_bcast_event(struct drbd_device *mdev, const struct sib_info *sib);
+void drbd_bcast_event(struct drbd_device *device, const struct sib_info *sib);
 
 /*
  * inline helper functions
@@ -1399,26 +1399,26 @@ static inline int drbd_peer_req_has_active_page(struct drbd_peer_request *peer_r
 }
 
 static inline enum drbd_state_rv
-_drbd_set_state(struct drbd_device *mdev, union drbd_state ns,
+_drbd_set_state(struct drbd_device *device, union drbd_state ns,
 		enum chg_state_flags flags, struct completion *done)
 {
 	enum drbd_state_rv rv;
 
 	read_lock(&global_state_lock);
-	rv = __drbd_set_state(mdev, ns, flags, done);
+	rv = __drbd_set_state(device, ns, flags, done);
 	read_unlock(&global_state_lock);
 
 	return rv;
 }
 
-static inline union drbd_state drbd_read_state(struct drbd_device *mdev)
+static inline union drbd_state drbd_read_state(struct drbd_device *device)
 {
 	union drbd_state rv;
 
-	rv.i = mdev->state.i;
-	rv.susp = mdev->tconn->susp;
-	rv.susp_nod = mdev->tconn->susp_nod;
-	rv.susp_fen = mdev->tconn->susp_fen;
+	rv.i = device->state.i;
+	rv.susp = device->tconn->susp;
+	rv.susp_nod = device->tconn->susp_nod;
+	rv.susp_fen = device->tconn->susp_fen;
 
 	return rv;
 }
@@ -1431,22 +1431,22 @@ enum drbd_force_detach_flags {
 };
 
 #define __drbd_chk_io_error(m,f) __drbd_chk_io_error_(m,f, __func__)
-static inline void __drbd_chk_io_error_(struct drbd_device *mdev,
+static inline void __drbd_chk_io_error_(struct drbd_device *device,
 		enum drbd_force_detach_flags df,
 		const char *where)
 {
 	enum drbd_io_error_p ep;
 
 	rcu_read_lock();
-	ep = rcu_dereference(mdev->ldev->disk_conf)->on_io_error;
+	ep = rcu_dereference(device->ldev->disk_conf)->on_io_error;
 	rcu_read_unlock();
 	switch (ep) {
 	case EP_PASS_ON: /* FIXME would this be better named "Ignore"? */
 		if (df == DRBD_READ_ERROR || df == DRBD_WRITE_ERROR) {
 			if (__ratelimit(&drbd_ratelimit_state))
 				dev_err(DEV, "Local IO failed in %s.\n", where);
-			if (mdev->state.disk > D_INCONSISTENT)
-				_drbd_set_state(_NS(mdev, disk, D_INCONSISTENT), CS_HARD, NULL);
+			if (device->state.disk > D_INCONSISTENT)
+				_drbd_set_state(_NS(device, disk, D_INCONSISTENT), CS_HARD, NULL);
 			break;
 		}
 		/* NOTE fall through for DRBD_META_IO_ERROR or DRBD_FORCE_DETACH */
@@ -1472,13 +1472,13 @@ static inline void __drbd_chk_io_error_(struct drbd_device *mdev,
 		 * we read meta data only once during attach,
 		 * which will fail in case of errors.
 		 */
-		set_bit(WAS_IO_ERROR, &mdev->flags);
+		set_bit(WAS_IO_ERROR, &device->flags);
 		if (df == DRBD_READ_ERROR)
-			set_bit(WAS_READ_ERROR, &mdev->flags);
+			set_bit(WAS_READ_ERROR, &device->flags);
 		if (df == DRBD_FORCE_DETACH)
-			set_bit(FORCE_DETACH, &mdev->flags);
-		if (mdev->state.disk > D_FAILED) {
-			_drbd_set_state(_NS(mdev, disk, D_FAILED), CS_HARD, NULL);
+			set_bit(FORCE_DETACH, &device->flags);
+		if (device->state.disk > D_FAILED) {
+			_drbd_set_state(_NS(device, disk, D_FAILED), CS_HARD, NULL);
 			dev_err(DEV,
 				"Local IO failed in %s. Detaching...\n", where);
 		}
@@ -1488,21 +1488,21 @@ static inline void __drbd_chk_io_error_(struct drbd_device *mdev,
 
 /**
  * drbd_chk_io_error: Handle the on_io_error setting, should be called from all io completion handlers
- * @mdev:	 DRBD device.
+ * @device:	 DRBD device.
  * @error:	 Error code passed to the IO completion callback
  * @forcedetach: Force detach. I.e. the error happened while accessing the meta data
  *
  * See also drbd_main.c:after_state_ch() if (os.disk > D_FAILED && ns.disk == D_FAILED)
  */
 #define drbd_chk_io_error(m,e,f) drbd_chk_io_error_(m,e,f, __func__)
-static inline void drbd_chk_io_error_(struct drbd_device *mdev,
+static inline void drbd_chk_io_error_(struct drbd_device *device,
 	int error, enum drbd_force_detach_flags forcedetach, const char *where)
 {
 	if (error) {
 		unsigned long flags;
-		spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-		__drbd_chk_io_error_(mdev, forcedetach, where);
-		spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
+		spin_lock_irqsave(&device->tconn->req_lock, flags);
+		__drbd_chk_io_error_(device, forcedetach, where);
+		spin_unlock_irqrestore(&device->tconn->req_lock, flags);
 	}
 }
 
@@ -1688,22 +1688,22 @@ static inline void drbd_thread_restart_nowait(struct drbd_thread *thi)
  *  _req_mod(req, CONNECTION_LOST_WHILE_PENDING)
  *     [from tl_clear_barrier]
  */
-static inline void inc_ap_pending(struct drbd_device *mdev)
+static inline void inc_ap_pending(struct drbd_device *device)
 {
-	atomic_inc(&mdev->ap_pending_cnt);
+	atomic_inc(&device->ap_pending_cnt);
 }
 
 #define ERR_IF_CNT_IS_NEGATIVE(which, func, line)			\
-	if (atomic_read(&mdev->which) < 0)				\
+	if (atomic_read(&device->which) < 0)				\
 		dev_err(DEV, "in %s:%d: " #which " = %d < 0 !\n",	\
 			func, line,					\
-			atomic_read(&mdev->which))
+			atomic_read(&device->which))
 
-#define dec_ap_pending(mdev) _dec_ap_pending(mdev, __FUNCTION__, __LINE__)
-static inline void _dec_ap_pending(struct drbd_device *mdev, const char *func, int line)
+#define dec_ap_pending(device) _dec_ap_pending(device, __FUNCTION__, __LINE__)
+static inline void _dec_ap_pending(struct drbd_device *device, const char *func, int line)
 {
-	if (atomic_dec_and_test(&mdev->ap_pending_cnt))
-		wake_up(&mdev->misc_wait);
+	if (atomic_dec_and_test(&device->ap_pending_cnt))
+		wake_up(&device->misc_wait);
 	ERR_IF_CNT_IS_NEGATIVE(ap_pending_cnt, func, line);
 }
 
@@ -1713,15 +1713,15 @@ static inline void _dec_ap_pending(struct drbd_device *mdev, const char *func, i
  * C_SYNC_SOURCE sends P_RS_DATA_REPLY   (and expects P_WRITE_ACK with ID_SYNCER)
  *					   (or P_NEG_ACK with ID_SYNCER)
  */
-static inline void inc_rs_pending(struct drbd_device *mdev)
+static inline void inc_rs_pending(struct drbd_device *device)
 {
-	atomic_inc(&mdev->rs_pending_cnt);
+	atomic_inc(&device->rs_pending_cnt);
 }
 
-#define dec_rs_pending(mdev) _dec_rs_pending(mdev, __FUNCTION__, __LINE__)
-static inline void _dec_rs_pending(struct drbd_device *mdev, const char *func, int line)
+#define dec_rs_pending(device) _dec_rs_pending(device, __FUNCTION__, __LINE__)
+static inline void _dec_rs_pending(struct drbd_device *device, const char *func, int line)
 {
-	atomic_dec(&mdev->rs_pending_cnt);
+	atomic_dec(&device->rs_pending_cnt);
 	ERR_IF_CNT_IS_NEGATIVE(rs_pending_cnt, func, line);
 }
 
@@ -1734,37 +1734,37 @@ static inline void _dec_rs_pending(struct drbd_device *mdev, const char *func, i
  *  receive_DataRequest (receive_RSDataRequest) we need to send back P_DATA
  *  receive_Barrier_*	we need to send a P_BARRIER_ACK
  */
-static inline void inc_unacked(struct drbd_device *mdev)
+static inline void inc_unacked(struct drbd_device *device)
 {
-	atomic_inc(&mdev->unacked_cnt);
+	atomic_inc(&device->unacked_cnt);
 }
 
-#define dec_unacked(mdev) _dec_unacked(mdev, __FUNCTION__, __LINE__)
-static inline void _dec_unacked(struct drbd_device *mdev, const char *func, int line)
+#define dec_unacked(device) _dec_unacked(device, __FUNCTION__, __LINE__)
+static inline void _dec_unacked(struct drbd_device *device, const char *func, int line)
 {
-	atomic_dec(&mdev->unacked_cnt);
+	atomic_dec(&device->unacked_cnt);
 	ERR_IF_CNT_IS_NEGATIVE(unacked_cnt, func, line);
 }
 
-#define sub_unacked(mdev, n) _sub_unacked(mdev, n, __FUNCTION__, __LINE__)
-static inline void _sub_unacked(struct drbd_device *mdev, int n, const char *func, int line)
+#define sub_unacked(device, n) _sub_unacked(device, n, __FUNCTION__, __LINE__)
+static inline void _sub_unacked(struct drbd_device *device, int n, const char *func, int line)
 {
-	atomic_sub(n, &mdev->unacked_cnt);
+	atomic_sub(n, &device->unacked_cnt);
 	ERR_IF_CNT_IS_NEGATIVE(unacked_cnt, func, line);
 }
 
 /**
- * get_ldev() - Increase the ref count on mdev->ldev. Returns 0 if there is no ldev
+ * get_ldev() - Increase the ref count on device->ldev. Returns 0 if there is no ldev
  * @M:		DRBD device.
  *
- * You have to call put_ldev() when finished working with mdev->ldev.
+ * You have to call put_ldev() when finished working with device->ldev.
  */
 #define get_ldev(M) __cond_lock(local, _get_ldev_if_state(M,D_INCONSISTENT))
 #define get_ldev_if_state(M,MINS) __cond_lock(local, _get_ldev_if_state(M,MINS))
 
-static inline void put_ldev(struct drbd_device *mdev)
+static inline void put_ldev(struct drbd_device *device)
 {
-	int i = atomic_dec_return(&mdev->local_cnt);
+	int i = atomic_dec_return(&device->local_cnt);
 
 	/* This may be called from some endio handler,
 	 * so we must not sleep here. */
@@ -1772,56 +1772,56 @@ static inline void put_ldev(struct drbd_device *mdev)
 	__release(local);
 	D_ASSERT(i >= 0);
 	if (i == 0) {
-		if (mdev->state.disk == D_DISKLESS)
+		if (device->state.disk == D_DISKLESS)
 			/* even internal references gone, safe to destroy */
-			drbd_ldev_destroy(mdev);
-		if (mdev->state.disk == D_FAILED) {
+			drbd_ldev_destroy(device);
+		if (device->state.disk == D_FAILED) {
 			/* all application IO references gone. */
-			if (!test_and_set_bit(GO_DISKLESS, &mdev->flags))
-				drbd_queue_work(&mdev->tconn->sender_work, &mdev->go_diskless);
+			if (!test_and_set_bit(GO_DISKLESS, &device->flags))
+				drbd_queue_work(&device->tconn->sender_work, &device->go_diskless);
 		}
-		wake_up(&mdev->misc_wait);
+		wake_up(&device->misc_wait);
 	}
 }
 
 #ifndef __CHECKER__
-static inline int _get_ldev_if_state(struct drbd_device *mdev, enum drbd_disk_state mins)
+static inline int _get_ldev_if_state(struct drbd_device *device, enum drbd_disk_state mins)
 {
 	int io_allowed;
 
 	/* never get a reference while D_DISKLESS */
-	if (mdev->state.disk == D_DISKLESS)
+	if (device->state.disk == D_DISKLESS)
 		return 0;
 
-	atomic_inc(&mdev->local_cnt);
-	io_allowed = (mdev->state.disk >= mins);
+	atomic_inc(&device->local_cnt);
+	io_allowed = (device->state.disk >= mins);
 	if (!io_allowed)
-		put_ldev(mdev);
+		put_ldev(device);
 	return io_allowed;
 }
 #else
-extern int _get_ldev_if_state(struct drbd_device *mdev, enum drbd_disk_state mins);
+extern int _get_ldev_if_state(struct drbd_device *device, enum drbd_disk_state mins);
 #endif
 
 /* you must have an "get_ldev" reference */
-static inline void drbd_get_syncer_progress(struct drbd_device *mdev,
+static inline void drbd_get_syncer_progress(struct drbd_device *device,
 		unsigned long *bits_left, unsigned int *per_mil_done)
 {
 	/* this is to break it at compile time when we change that, in case we
 	 * want to support more than (1<<32) bits on a 32bit arch. */
-	typecheck(unsigned long, mdev->rs_total);
+	typecheck(unsigned long, device->rs_total);
 
 	/* note: both rs_total and rs_left are in bits, i.e. in
 	 * units of BM_BLOCK_SIZE.
 	 * for the percentage, we don't care. */
 
-	if (mdev->state.conn == C_VERIFY_S || mdev->state.conn == C_VERIFY_T)
-		*bits_left = mdev->ov_left;
+	if (device->state.conn == C_VERIFY_S || device->state.conn == C_VERIFY_T)
+		*bits_left = device->ov_left;
 	else
-		*bits_left = drbd_bm_total_weight(mdev) - mdev->rs_failed;
+		*bits_left = drbd_bm_total_weight(device) - device->rs_failed;
 	/* >> 10 to prevent overflow,
 	 * +1 to prevent division by zero */
-	if (*bits_left > mdev->rs_total) {
+	if (*bits_left > device->rs_total) {
 		/* doh. maybe a logic bug somewhere.
 		 * may also be just a race condition
 		 * between this and a disconnect during sync.
@@ -1829,8 +1829,8 @@ static inline void drbd_get_syncer_progress(struct drbd_device *mdev,
 		 */
 		smp_rmb();
 		dev_warn(DEV, "cs:%s rs_left=%lu > rs_total=%lu (rs_failed %lu)\n",
-				drbd_conn_str(mdev->state.conn),
-				*bits_left, mdev->rs_total, mdev->rs_failed);
+				drbd_conn_str(device->state.conn),
+				*bits_left, device->rs_total, device->rs_failed);
 		*per_mil_done = 0;
 	} else {
 		/* Make sure the division happens in long context.
@@ -1842,9 +1842,9 @@ static inline void drbd_get_syncer_progress(struct drbd_device *mdev,
 		 * Note: currently we don't support such large bitmaps on 32bit
 		 * arch anyways, but no harm done to be prepared for it here.
 		 */
-		unsigned int shift = mdev->rs_total > UINT_MAX ? 16 : 10;
+		unsigned int shift = device->rs_total > UINT_MAX ? 16 : 10;
 		unsigned long left = *bits_left >> shift;
-		unsigned long total = 1UL + (mdev->rs_total >> shift);
+		unsigned long total = 1UL + (device->rs_total >> shift);
 		unsigned long tmp = 1000UL - left * 1000UL/total;
 		*per_mil_done = tmp;
 	}
@@ -1854,22 +1854,22 @@ static inline void drbd_get_syncer_progress(struct drbd_device *mdev,
 /* this throttles on-the-fly application requests
  * according to max_buffers settings;
  * maybe re-implement using semaphores? */
-static inline int drbd_get_max_buffers(struct drbd_device *mdev)
+static inline int drbd_get_max_buffers(struct drbd_device *device)
 {
 	struct net_conf *nc;
 	int mxb;
 
 	rcu_read_lock();
-	nc = rcu_dereference(mdev->tconn->net_conf);
+	nc = rcu_dereference(device->tconn->net_conf);
 	mxb = nc ? nc->max_buffers : 1000000;  /* arbitrary limit on open requests */
 	rcu_read_unlock();
 
 	return mxb;
 }
 
-static inline int drbd_state_is_stable(struct drbd_device *mdev)
+static inline int drbd_state_is_stable(struct drbd_device *device)
 {
-	union drbd_dev_state s = mdev->state;
+	union drbd_dev_state s = device->state;
 
 	/* DO NOT add a default clause, we want the compiler to warn us
 	 * for any newly introduced state we may have forgotten to add here */
@@ -1903,7 +1903,7 @@ static inline int drbd_state_is_stable(struct drbd_device *mdev)
 
 		/* Allow IO in BM exchange states with new protocols */
 	case C_WF_BITMAP_S:
-		if (mdev->tconn->agreed_pro_version < 96)
+		if (device->tconn->agreed_pro_version < 96)
 			return 0;
 		break;
 
@@ -1937,20 +1937,20 @@ static inline int drbd_state_is_stable(struct drbd_device *mdev)
 	return 1;
 }
 
-static inline int drbd_suspended(struct drbd_device *mdev)
+static inline int drbd_suspended(struct drbd_device *device)
 {
-	struct drbd_tconn *tconn = mdev->tconn;
+	struct drbd_tconn *tconn = device->tconn;
 
 	return tconn->susp || tconn->susp_fen || tconn->susp_nod;
 }
 
-static inline bool may_inc_ap_bio(struct drbd_device *mdev)
+static inline bool may_inc_ap_bio(struct drbd_device *device)
 {
-	int mxb = drbd_get_max_buffers(mdev);
+	int mxb = drbd_get_max_buffers(device);
 
-	if (drbd_suspended(mdev))
+	if (drbd_suspended(device))
 		return false;
-	if (test_bit(SUSPEND_IO, &mdev->flags))
+	if (test_bit(SUSPEND_IO, &device->flags))
 		return false;
 
 	/* to avoid potential deadlock or bitmap corruption,
@@ -1958,32 +1958,32 @@ static inline bool may_inc_ap_bio(struct drbd_device *mdev)
 	 * to start during "stable" states. */
 
 	/* no new io accepted when attaching or detaching the disk */
-	if (!drbd_state_is_stable(mdev))
+	if (!drbd_state_is_stable(device))
 		return false;
 
 	/* since some older kernels don't have atomic_add_unless,
 	 * and we are within the spinlock anyways, we have this workaround.  */
-	if (atomic_read(&mdev->ap_bio_cnt) > mxb)
+	if (atomic_read(&device->ap_bio_cnt) > mxb)
 		return false;
-	if (test_bit(BITMAP_IO, &mdev->flags))
+	if (test_bit(BITMAP_IO, &device->flags))
 		return false;
 	return true;
 }
 
-static inline bool inc_ap_bio_cond(struct drbd_device *mdev)
+static inline bool inc_ap_bio_cond(struct drbd_device *device)
 {
 	bool rv = false;
 
-	spin_lock_irq(&mdev->tconn->req_lock);
-	rv = may_inc_ap_bio(mdev);
+	spin_lock_irq(&device->tconn->req_lock);
+	rv = may_inc_ap_bio(device);
 	if (rv)
-		atomic_inc(&mdev->ap_bio_cnt);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+		atomic_inc(&device->ap_bio_cnt);
+	spin_unlock_irq(&device->tconn->req_lock);
 
 	return rv;
 }
 
-static inline void inc_ap_bio(struct drbd_device *mdev)
+static inline void inc_ap_bio(struct drbd_device *device)
 {
 	/* we wait here
 	 *    as long as the device is suspended
@@ -1993,42 +1993,42 @@ static inline void inc_ap_bio(struct drbd_device *mdev)
 	 * to avoid races with the reconnect code,
 	 * we need to atomic_inc within the spinlock. */
 
-	wait_event(mdev->misc_wait, inc_ap_bio_cond(mdev));
+	wait_event(device->misc_wait, inc_ap_bio_cond(device));
 }
 
-static inline void dec_ap_bio(struct drbd_device *mdev)
+static inline void dec_ap_bio(struct drbd_device *device)
 {
-	int mxb = drbd_get_max_buffers(mdev);
-	int ap_bio = atomic_dec_return(&mdev->ap_bio_cnt);
+	int mxb = drbd_get_max_buffers(device);
+	int ap_bio = atomic_dec_return(&device->ap_bio_cnt);
 
 	D_ASSERT(ap_bio >= 0);
 
-	if (ap_bio == 0 && test_bit(BITMAP_IO, &mdev->flags)) {
-		if (!test_and_set_bit(BITMAP_IO_QUEUED, &mdev->flags))
-			drbd_queue_work(&mdev->tconn->sender_work, &mdev->bm_io_work.w);
+	if (ap_bio == 0 && test_bit(BITMAP_IO, &device->flags)) {
+		if (!test_and_set_bit(BITMAP_IO_QUEUED, &device->flags))
+			drbd_queue_work(&device->tconn->sender_work, &device->bm_io_work.w);
 	}
 
 	/* this currently does wake_up for every dec_ap_bio!
 	 * maybe rather introduce some type of hysteresis?
 	 * e.g. (ap_bio == mxb/2 || ap_bio == 0) ? */
 	if (ap_bio < mxb)
-		wake_up(&mdev->misc_wait);
+		wake_up(&device->misc_wait);
 }
 
-static inline bool verify_can_do_stop_sector(struct drbd_device *mdev)
+static inline bool verify_can_do_stop_sector(struct drbd_device *device)
 {
-	return mdev->tconn->agreed_pro_version >= 97 &&
-		mdev->tconn->agreed_pro_version != 100;
+	return device->tconn->agreed_pro_version >= 97 &&
+		device->tconn->agreed_pro_version != 100;
 }
 
-static inline int drbd_set_ed_uuid(struct drbd_device *mdev, u64 val)
+static inline int drbd_set_ed_uuid(struct drbd_device *device, u64 val)
 {
-	int changed = mdev->ed_uuid != val;
-	mdev->ed_uuid = val;
+	int changed = device->ed_uuid != val;
+	device->ed_uuid = val;
 	return changed;
 }
 
-static inline int drbd_queue_order_type(struct drbd_device *mdev)
+static inline int drbd_queue_order_type(struct drbd_device *device)
 {
 	/* sorry, we currently have no working implementation
 	 * of distributed TCQ stuff */
@@ -2038,21 +2038,21 @@ static inline int drbd_queue_order_type(struct drbd_device *mdev)
 	return QUEUE_ORDERED_NONE;
 }
 
-static inline void drbd_md_flush(struct drbd_device *mdev)
+static inline void drbd_md_flush(struct drbd_device *device)
 {
 	int r;
 
-	if (mdev->ldev == NULL) {
-		dev_warn(DEV, "mdev->ldev == NULL in drbd_md_flush\n");
+	if (device->ldev == NULL) {
+		dev_warn(DEV, "device->ldev == NULL in drbd_md_flush\n");
 		return;
 	}
 
-	if (test_bit(MD_NO_FUA, &mdev->flags))
+	if (test_bit(MD_NO_FUA, &device->flags))
 		return;
 
-	r = blkdev_issue_flush(mdev->ldev->md_bdev, GFP_NOIO, NULL);
+	r = blkdev_issue_flush(device->ldev->md_bdev, GFP_NOIO, NULL);
 	if (r) {
-		set_bit(MD_NO_FUA, &mdev->flags);
+		set_bit(MD_NO_FUA, &device->flags);
 		dev_err(DEV, "meta data flush failed with status %d, disabling md-flushes\n", r);
 	}
 }
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 92cb9e5..7eeed19 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -167,15 +167,15 @@ struct bio *bio_alloc_drbd(gfp_t gfp_mask)
 /* When checking with sparse, and this is an inline function, sparse will
    give tons of false positives. When this is a real functions sparse works.
  */
-int _get_ldev_if_state(struct drbd_device *mdev, enum drbd_disk_state mins)
+int _get_ldev_if_state(struct drbd_device *device, enum drbd_disk_state mins)
 {
 	int io_allowed;
 
-	atomic_inc(&mdev->local_cnt);
-	io_allowed = (mdev->state.disk >= mins);
+	atomic_inc(&device->local_cnt);
+	io_allowed = (device->state.disk >= mins);
 	if (!io_allowed) {
-		if (atomic_dec_and_test(&mdev->local_cnt))
-			wake_up(&mdev->misc_wait);
+		if (atomic_dec_and_test(&device->local_cnt))
+			wake_up(&device->misc_wait);
 	}
 	return io_allowed;
 }
@@ -269,7 +269,7 @@ bail:
 
 /**
  * _tl_restart() - Walks the transfer log, and applies an action to all requests
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @what:       The action/event to perform with all request objects
  *
  * @what might be one of CONNECTION_LOST_WHILE_PENDING, RESEND, FAIL_FROZEN_DISK_IO,
@@ -293,7 +293,7 @@ void tl_restart(struct drbd_tconn *tconn, enum drbd_req_event what)
 
 /**
  * tl_clear() - Clears all requests and &struct drbd_tl_epoch objects out of the TL
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * This is called after the connection to the peer was lost. The storage covered
  * by the requests on the transfer gets marked as our of sync. Called from the
@@ -305,19 +305,19 @@ void tl_clear(struct drbd_tconn *tconn)
 }
 
 /**
- * tl_abort_disk_io() - Abort disk I/O for all requests for a certain mdev in the TL
- * @mdev:	DRBD device.
+ * tl_abort_disk_io() - Abort disk I/O for all requests for a certain device in the TL
+ * @device:	DRBD device.
  */
-void tl_abort_disk_io(struct drbd_device *mdev)
+void tl_abort_disk_io(struct drbd_device *device)
 {
-	struct drbd_tconn *tconn = mdev->tconn;
+	struct drbd_tconn *tconn = device->tconn;
 	struct drbd_request *req, *r;
 
 	spin_lock_irq(&tconn->req_lock);
 	list_for_each_entry_safe(req, r, &tconn->transfer_log, tl_requests) {
 		if (!(req->rq_state & RQ_LOCAL_PENDING))
 			continue;
-		if (req->w.mdev != mdev)
+		if (req->w.device != device)
 			continue;
 		_req_mod(req, ABORT_DISK_IO);
 	}
@@ -497,12 +497,12 @@ char *drbd_task_to_thread_name(struct drbd_tconn *tconn, struct task_struct *tas
 
 int conn_lowest_minor(struct drbd_tconn *tconn)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr = 0, m;
 
 	rcu_read_lock();
-	mdev = idr_get_next(&tconn->volumes, &vnr);
-	m = mdev ? mdev_to_minor(mdev) : -1;
+	device = idr_get_next(&tconn->volumes, &vnr);
+	m = device ? device_to_minor(device) : -1;
 	rcu_read_unlock();
 
 	return m;
@@ -511,7 +511,7 @@ int conn_lowest_minor(struct drbd_tconn *tconn)
 #ifdef CONFIG_SMP
 /**
  * drbd_calc_cpu_mask() - Generate CPU masks, spread over all CPUs
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Forces all threads of a device onto the same CPU. This is beneficial for
  * DRBD's performance. May be overwritten by user's configuration.
@@ -537,7 +537,7 @@ void drbd_calc_cpu_mask(struct drbd_tconn *tconn)
 
 /**
  * drbd_thread_current_set_cpu() - modifies the cpu mask of the _current_ thread
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @thi:	drbd_thread object
  *
  * call in the "main loop" of _all_ threads, no need for any mutex, current won't die
@@ -633,9 +633,9 @@ void *conn_prepare_command(struct drbd_tconn *tconn, struct drbd_socket *sock)
 	return p;
 }
 
-void *drbd_prepare_command(struct drbd_device *mdev, struct drbd_socket *sock)
+void *drbd_prepare_command(struct drbd_device *device, struct drbd_socket *sock)
 {
-	return conn_prepare_command(mdev->tconn, sock);
+	return conn_prepare_command(device->tconn, sock);
 }
 
 static int __send_command(struct drbd_tconn *tconn, int vnr,
@@ -682,13 +682,13 @@ int conn_send_command(struct drbd_tconn *tconn, struct drbd_socket *sock,
 	return err;
 }
 
-int drbd_send_command(struct drbd_device *mdev, struct drbd_socket *sock,
+int drbd_send_command(struct drbd_device *device, struct drbd_socket *sock,
 		      enum drbd_packet cmd, unsigned int header_size,
 		      void *data, unsigned int size)
 {
 	int err;
 
-	err = __send_command(mdev->tconn, mdev->vnr, sock, cmd, header_size,
+	err = __send_command(device->tconn, device->vnr, sock, cmd, header_size,
 			     data, size);
 	mutex_unlock(&sock->mutex);
 	return err;
@@ -714,23 +714,23 @@ int drbd_send_ping_ack(struct drbd_tconn *tconn)
 	return conn_send_command(tconn, sock, P_PING_ACK, 0, NULL, 0);
 }
 
-int drbd_send_sync_param(struct drbd_device *mdev)
+int drbd_send_sync_param(struct drbd_device *device)
 {
 	struct drbd_socket *sock;
 	struct p_rs_param_95 *p;
 	int size;
-	const int apv = mdev->tconn->agreed_pro_version;
+	const int apv = device->tconn->agreed_pro_version;
 	enum drbd_packet cmd;
 	struct net_conf *nc;
 	struct disk_conf *dc;
 
-	sock = &mdev->tconn->data;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->data;
+	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
 
 	rcu_read_lock();
-	nc = rcu_dereference(mdev->tconn->net_conf);
+	nc = rcu_dereference(device->tconn->net_conf);
 
 	size = apv <= 87 ? sizeof(struct p_rs_param)
 		: apv == 88 ? sizeof(struct p_rs_param)
@@ -743,14 +743,14 @@ int drbd_send_sync_param(struct drbd_device *mdev)
 	/* initialize verify_alg and csums_alg */
 	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
 
-	if (get_ldev(mdev)) {
-		dc = rcu_dereference(mdev->ldev->disk_conf);
+	if (get_ldev(device)) {
+		dc = rcu_dereference(device->ldev->disk_conf);
 		p->resync_rate = cpu_to_be32(dc->resync_rate);
 		p->c_plan_ahead = cpu_to_be32(dc->c_plan_ahead);
 		p->c_delay_target = cpu_to_be32(dc->c_delay_target);
 		p->c_fill_target = cpu_to_be32(dc->c_fill_target);
 		p->c_max_rate = cpu_to_be32(dc->c_max_rate);
-		put_ldev(mdev);
+		put_ldev(device);
 	} else {
 		p->resync_rate = cpu_to_be32(DRBD_RESYNC_RATE_DEF);
 		p->c_plan_ahead = cpu_to_be32(DRBD_C_PLAN_AHEAD_DEF);
@@ -765,7 +765,7 @@ int drbd_send_sync_param(struct drbd_device *mdev)
 		strcpy(p->csums_alg, nc->csums_alg);
 	rcu_read_unlock();
 
-	return drbd_send_command(mdev, sock, cmd, size, NULL, 0);
+	return drbd_send_command(device, sock, cmd, size, NULL, 0);
 }
 
 int __drbd_send_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd)
@@ -824,93 +824,93 @@ int drbd_send_protocol(struct drbd_tconn *tconn)
 	return err;
 }
 
-int _drbd_send_uuids(struct drbd_device *mdev, u64 uuid_flags)
+int _drbd_send_uuids(struct drbd_device *device, u64 uuid_flags)
 {
 	struct drbd_socket *sock;
 	struct p_uuids *p;
 	int i;
 
-	if (!get_ldev_if_state(mdev, D_NEGOTIATING))
+	if (!get_ldev_if_state(device, D_NEGOTIATING))
 		return 0;
 
-	sock = &mdev->tconn->data;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->data;
+	p = drbd_prepare_command(device, sock);
 	if (!p) {
-		put_ldev(mdev);
+		put_ldev(device);
 		return -EIO;
 	}
-	spin_lock_irq(&mdev->ldev->md.uuid_lock);
+	spin_lock_irq(&device->ldev->md.uuid_lock);
 	for (i = UI_CURRENT; i < UI_SIZE; i++)
-		p->uuid[i] = cpu_to_be64(mdev->ldev->md.uuid[i]);
-	spin_unlock_irq(&mdev->ldev->md.uuid_lock);
+		p->uuid[i] = cpu_to_be64(device->ldev->md.uuid[i]);
+	spin_unlock_irq(&device->ldev->md.uuid_lock);
 
-	mdev->comm_bm_set = drbd_bm_total_weight(mdev);
-	p->uuid[UI_SIZE] = cpu_to_be64(mdev->comm_bm_set);
+	device->comm_bm_set = drbd_bm_total_weight(device);
+	p->uuid[UI_SIZE] = cpu_to_be64(device->comm_bm_set);
 	rcu_read_lock();
-	uuid_flags |= rcu_dereference(mdev->tconn->net_conf)->discard_my_data ? 1 : 0;
+	uuid_flags |= rcu_dereference(device->tconn->net_conf)->discard_my_data ? 1 : 0;
 	rcu_read_unlock();
-	uuid_flags |= test_bit(CRASHED_PRIMARY, &mdev->flags) ? 2 : 0;
-	uuid_flags |= mdev->new_state_tmp.disk == D_INCONSISTENT ? 4 : 0;
+	uuid_flags |= test_bit(CRASHED_PRIMARY, &device->flags) ? 2 : 0;
+	uuid_flags |= device->new_state_tmp.disk == D_INCONSISTENT ? 4 : 0;
 	p->uuid[UI_FLAGS] = cpu_to_be64(uuid_flags);
 
-	put_ldev(mdev);
-	return drbd_send_command(mdev, sock, P_UUIDS, sizeof(*p), NULL, 0);
+	put_ldev(device);
+	return drbd_send_command(device, sock, P_UUIDS, sizeof(*p), NULL, 0);
 }
 
-int drbd_send_uuids(struct drbd_device *mdev)
+int drbd_send_uuids(struct drbd_device *device)
 {
-	return _drbd_send_uuids(mdev, 0);
+	return _drbd_send_uuids(device, 0);
 }
 
-int drbd_send_uuids_skip_initial_sync(struct drbd_device *mdev)
+int drbd_send_uuids_skip_initial_sync(struct drbd_device *device)
 {
-	return _drbd_send_uuids(mdev, 8);
+	return _drbd_send_uuids(device, 8);
 }
 
-void drbd_print_uuids(struct drbd_device *mdev, const char *text)
+void drbd_print_uuids(struct drbd_device *device, const char *text)
 {
-	if (get_ldev_if_state(mdev, D_NEGOTIATING)) {
-		u64 *uuid = mdev->ldev->md.uuid;
+	if (get_ldev_if_state(device, D_NEGOTIATING)) {
+		u64 *uuid = device->ldev->md.uuid;
 		dev_info(DEV, "%s %016llX:%016llX:%016llX:%016llX\n",
 		     text,
 		     (unsigned long long)uuid[UI_CURRENT],
 		     (unsigned long long)uuid[UI_BITMAP],
 		     (unsigned long long)uuid[UI_HISTORY_START],
 		     (unsigned long long)uuid[UI_HISTORY_END]);
-		put_ldev(mdev);
+		put_ldev(device);
 	} else {
 		dev_info(DEV, "%s effective data uuid: %016llX\n",
 				text,
-				(unsigned long long)mdev->ed_uuid);
+				(unsigned long long)device->ed_uuid);
 	}
 }
 
-void drbd_gen_and_send_sync_uuid(struct drbd_device *mdev)
+void drbd_gen_and_send_sync_uuid(struct drbd_device *device)
 {
 	struct drbd_socket *sock;
 	struct p_rs_uuid *p;
 	u64 uuid;
 
-	D_ASSERT(mdev->state.disk == D_UP_TO_DATE);
+	D_ASSERT(device->state.disk == D_UP_TO_DATE);
 
-	uuid = mdev->ldev->md.uuid[UI_BITMAP];
+	uuid = device->ldev->md.uuid[UI_BITMAP];
 	if (uuid && uuid != UUID_JUST_CREATED)
 		uuid = uuid + UUID_NEW_BM_OFFSET;
 	else
 		get_random_bytes(&uuid, sizeof(u64));
-	drbd_uuid_set(mdev, UI_BITMAP, uuid);
-	drbd_print_uuids(mdev, "updated sync UUID");
-	drbd_md_sync(mdev);
+	drbd_uuid_set(device, UI_BITMAP, uuid);
+	drbd_print_uuids(device, "updated sync UUID");
+	drbd_md_sync(device);
 
-	sock = &mdev->tconn->data;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->data;
+	p = drbd_prepare_command(device, sock);
 	if (p) {
 		p->uuid = cpu_to_be64(uuid);
-		drbd_send_command(mdev, sock, P_SYNC_UUID, sizeof(*p), NULL, 0);
+		drbd_send_command(device, sock, P_SYNC_UUID, sizeof(*p), NULL, 0);
 	}
 }
 
-int drbd_send_sizes(struct drbd_device *mdev, int trigger_reply, enum dds_flags flags)
+int drbd_send_sizes(struct drbd_device *device, int trigger_reply, enum dds_flags flags)
 {
 	struct drbd_socket *sock;
 	struct p_sizes *p;
@@ -918,16 +918,16 @@ int drbd_send_sizes(struct drbd_device *mdev, int trigger_reply, enum dds_flags
 	int q_order_type;
 	unsigned int max_bio_size;
 
-	if (get_ldev_if_state(mdev, D_NEGOTIATING)) {
-		D_ASSERT(mdev->ldev->backing_bdev);
-		d_size = drbd_get_max_capacity(mdev->ldev);
+	if (get_ldev_if_state(device, D_NEGOTIATING)) {
+		D_ASSERT(device->ldev->backing_bdev);
+		d_size = drbd_get_max_capacity(device->ldev);
 		rcu_read_lock();
-		u_size = rcu_dereference(mdev->ldev->disk_conf)->disk_size;
+		u_size = rcu_dereference(device->ldev->disk_conf)->disk_size;
 		rcu_read_unlock();
-		q_order_type = drbd_queue_order_type(mdev);
-		max_bio_size = queue_max_hw_sectors(mdev->ldev->backing_bdev->bd_disk->queue) << 9;
+		q_order_type = drbd_queue_order_type(device);
+		max_bio_size = queue_max_hw_sectors(device->ldev->backing_bdev->bd_disk->queue) << 9;
 		max_bio_size = min(max_bio_size, DRBD_MAX_BIO_SIZE);
-		put_ldev(mdev);
+		put_ldev(device);
 	} else {
 		d_size = 0;
 		u_size = 0;
@@ -935,45 +935,45 @@ int drbd_send_sizes(struct drbd_device *mdev, int trigger_reply, enum dds_flags
 		max_bio_size = DRBD_MAX_BIO_SIZE; /* ... multiple BIOs per peer_request */
 	}
 
-	sock = &mdev->tconn->data;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->data;
+	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
 
-	if (mdev->tconn->agreed_pro_version <= 94)
+	if (device->tconn->agreed_pro_version <= 94)
 		max_bio_size = min(max_bio_size, DRBD_MAX_SIZE_H80_PACKET);
-	else if (mdev->tconn->agreed_pro_version < 100)
+	else if (device->tconn->agreed_pro_version < 100)
 		max_bio_size = min(max_bio_size, DRBD_MAX_BIO_SIZE_P95);
 
 	p->d_size = cpu_to_be64(d_size);
 	p->u_size = cpu_to_be64(u_size);
-	p->c_size = cpu_to_be64(trigger_reply ? 0 : drbd_get_capacity(mdev->this_bdev));
+	p->c_size = cpu_to_be64(trigger_reply ? 0 : drbd_get_capacity(device->this_bdev));
 	p->max_bio_size = cpu_to_be32(max_bio_size);
 	p->queue_order_type = cpu_to_be16(q_order_type);
 	p->dds_flags = cpu_to_be16(flags);
-	return drbd_send_command(mdev, sock, P_SIZES, sizeof(*p), NULL, 0);
+	return drbd_send_command(device, sock, P_SIZES, sizeof(*p), NULL, 0);
 }
 
 /**
  * drbd_send_current_state() - Sends the drbd state to the peer
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  */
-int drbd_send_current_state(struct drbd_device *mdev)
+int drbd_send_current_state(struct drbd_device *device)
 {
 	struct drbd_socket *sock;
 	struct p_state *p;
 
-	sock = &mdev->tconn->data;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->data;
+	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
-	p->state = cpu_to_be32(mdev->state.i); /* Within the send mutex */
-	return drbd_send_command(mdev, sock, P_STATE, sizeof(*p), NULL, 0);
+	p->state = cpu_to_be32(device->state.i); /* Within the send mutex */
+	return drbd_send_command(device, sock, P_STATE, sizeof(*p), NULL, 0);
 }
 
 /**
  * drbd_send_state() - After a state change, sends the new state to the peer
- * @mdev:      DRBD device.
+ * @device:      DRBD device.
  * @state:     the state to send, not necessarily the current state.
  *
  * Each state change queues an "after_state_ch" work, which will eventually
@@ -981,31 +981,31 @@ int drbd_send_current_state(struct drbd_device *mdev)
  * between queuing and processing of the after_state_ch work, we still
  * want to send each intermediary state in the order it occurred.
  */
-int drbd_send_state(struct drbd_device *mdev, union drbd_state state)
+int drbd_send_state(struct drbd_device *device, union drbd_state state)
 {
 	struct drbd_socket *sock;
 	struct p_state *p;
 
-	sock = &mdev->tconn->data;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->data;
+	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
 	p->state = cpu_to_be32(state.i); /* Within the send mutex */
-	return drbd_send_command(mdev, sock, P_STATE, sizeof(*p), NULL, 0);
+	return drbd_send_command(device, sock, P_STATE, sizeof(*p), NULL, 0);
 }
 
-int drbd_send_state_req(struct drbd_device *mdev, union drbd_state mask, union drbd_state val)
+int drbd_send_state_req(struct drbd_device *device, union drbd_state mask, union drbd_state val)
 {
 	struct drbd_socket *sock;
 	struct p_req_state *p;
 
-	sock = &mdev->tconn->data;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->data;
+	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
 	p->mask = cpu_to_be32(mask.i);
 	p->val = cpu_to_be32(val.i);
-	return drbd_send_command(mdev, sock, P_STATE_CHG_REQ, sizeof(*p), NULL, 0);
+	return drbd_send_command(device, sock, P_STATE_CHG_REQ, sizeof(*p), NULL, 0);
 }
 
 int conn_send_state_req(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val)
@@ -1024,16 +1024,16 @@ int conn_send_state_req(struct drbd_tconn *tconn, union drbd_state mask, union d
 	return conn_send_command(tconn, sock, cmd, sizeof(*p), NULL, 0);
 }
 
-void drbd_send_sr_reply(struct drbd_device *mdev, enum drbd_state_rv retcode)
+void drbd_send_sr_reply(struct drbd_device *device, enum drbd_state_rv retcode)
 {
 	struct drbd_socket *sock;
 	struct p_req_state_reply *p;
 
-	sock = &mdev->tconn->meta;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->meta;
+	p = drbd_prepare_command(device, sock);
 	if (p) {
 		p->retcode = cpu_to_be32(retcode);
-		drbd_send_command(mdev, sock, P_STATE_CHG_REPLY, sizeof(*p), NULL, 0);
+		drbd_send_command(device, sock, P_STATE_CHG_REPLY, sizeof(*p), NULL, 0);
 	}
 }
 
@@ -1068,7 +1068,7 @@ static void dcbp_set_pad_bits(struct p_compressed_bm *p, int n)
 	p->encoding = (p->encoding & (~0x7 << 4)) | (n << 4);
 }
 
-int fill_bitmap_rle_bits(struct drbd_device *mdev,
+int fill_bitmap_rle_bits(struct drbd_device *device,
 			 struct p_compressed_bm *p,
 			 unsigned int size,
 			 struct bm_xfer_ctx *c)
@@ -1083,9 +1083,9 @@ int fill_bitmap_rle_bits(struct drbd_device *mdev,
 
 	/* may we use this feature? */
 	rcu_read_lock();
-	use_rle = rcu_dereference(mdev->tconn->net_conf)->use_rle;
+	use_rle = rcu_dereference(device->tconn->net_conf)->use_rle;
 	rcu_read_unlock();
-	if (!use_rle || mdev->tconn->agreed_pro_version < 90)
+	if (!use_rle || device->tconn->agreed_pro_version < 90)
 		return 0;
 
 	if (c->bit_offset >= c->bm_bits)
@@ -1105,8 +1105,8 @@ int fill_bitmap_rle_bits(struct drbd_device *mdev,
 	/* see how much plain bits we can stuff into one packet
 	 * using RLE and VLI. */
 	do {
-		tmp = (toggle == 0) ? _drbd_bm_find_next_zero(mdev, c->bit_offset)
-				    : _drbd_bm_find_next(mdev, c->bit_offset);
+		tmp = (toggle == 0) ? _drbd_bm_find_next_zero(device, c->bit_offset)
+				    : _drbd_bm_find_next(device, c->bit_offset);
 		if (tmp == -1UL)
 			tmp = c->bm_bits;
 		rl = tmp - c->bit_offset;
@@ -1172,21 +1172,21 @@ int fill_bitmap_rle_bits(struct drbd_device *mdev,
  * code upon failure.
  */
 static int
-send_bitmap_rle_or_plain(struct drbd_device *mdev, struct bm_xfer_ctx *c)
+send_bitmap_rle_or_plain(struct drbd_device *device, struct bm_xfer_ctx *c)
 {
-	struct drbd_socket *sock = &mdev->tconn->data;
-	unsigned int header_size = drbd_header_size(mdev->tconn);
+	struct drbd_socket *sock = &device->tconn->data;
+	unsigned int header_size = drbd_header_size(device->tconn);
 	struct p_compressed_bm *p = sock->sbuf + header_size;
 	int len, err;
 
-	len = fill_bitmap_rle_bits(mdev, p,
+	len = fill_bitmap_rle_bits(device, p,
 			DRBD_SOCKET_BUFFER_SIZE - header_size - sizeof(*p), c);
 	if (len < 0)
 		return -EIO;
 
 	if (len) {
 		dcbp_set_code(p, RLE_VLI_Bits);
-		err = __send_command(mdev->tconn, mdev->vnr, sock,
+		err = __send_command(device->tconn, device->vnr, sock,
 				     P_COMPRESSED_BITMAP, sizeof(*p) + len,
 				     NULL, 0);
 		c->packets[0]++;
@@ -1206,8 +1206,8 @@ send_bitmap_rle_or_plain(struct drbd_device *mdev, struct bm_xfer_ctx *c)
 				  c->bm_words - c->word_offset);
 		len = num_words * sizeof(*p);
 		if (len)
-			drbd_bm_get_lel(mdev, c->word_offset, num_words, p);
-		err = __send_command(mdev->tconn, mdev->vnr, sock, P_BITMAP, len, NULL, 0);
+			drbd_bm_get_lel(device, c->word_offset, num_words, p);
+		err = __send_command(device->tconn, device->vnr, sock, P_BITMAP, len, NULL, 0);
 		c->word_offset += num_words;
 		c->bit_offset = c->word_offset * BITS_PER_LONG;
 
@@ -1219,7 +1219,7 @@ send_bitmap_rle_or_plain(struct drbd_device *mdev, struct bm_xfer_ctx *c)
 	}
 	if (!err) {
 		if (len == 0) {
-			INFO_bm_xfer_stats(mdev, "send", c);
+			INFO_bm_xfer_stats(device, "send", c);
 			return 0;
 		} else
 			return 1;
@@ -1228,51 +1228,51 @@ send_bitmap_rle_or_plain(struct drbd_device *mdev, struct bm_xfer_ctx *c)
 }
 
 /* See the comment at receive_bitmap() */
-static int _drbd_send_bitmap(struct drbd_device *mdev)
+static int _drbd_send_bitmap(struct drbd_device *device)
 {
 	struct bm_xfer_ctx c;
 	int err;
 
-	if (!expect(mdev->bitmap))
+	if (!expect(device->bitmap))
 		return false;
 
-	if (get_ldev(mdev)) {
-		if (drbd_md_test_flag(mdev->ldev, MDF_FULL_SYNC)) {
+	if (get_ldev(device)) {
+		if (drbd_md_test_flag(device->ldev, MDF_FULL_SYNC)) {
 			dev_info(DEV, "Writing the whole bitmap, MDF_FullSync was set.\n");
-			drbd_bm_set_all(mdev);
-			if (drbd_bm_write(mdev)) {
+			drbd_bm_set_all(device);
+			if (drbd_bm_write(device)) {
 				/* write_bm did fail! Leave full sync flag set in Meta P_DATA
 				 * but otherwise process as per normal - need to tell other
 				 * side that a full resync is required! */
 				dev_err(DEV, "Failed to write bitmap to disk!\n");
 			} else {
-				drbd_md_clear_flag(mdev, MDF_FULL_SYNC);
-				drbd_md_sync(mdev);
+				drbd_md_clear_flag(device, MDF_FULL_SYNC);
+				drbd_md_sync(device);
 			}
 		}
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 
 	c = (struct bm_xfer_ctx) {
-		.bm_bits = drbd_bm_bits(mdev),
-		.bm_words = drbd_bm_words(mdev),
+		.bm_bits = drbd_bm_bits(device),
+		.bm_words = drbd_bm_words(device),
 	};
 
 	do {
-		err = send_bitmap_rle_or_plain(mdev, &c);
+		err = send_bitmap_rle_or_plain(device, &c);
 	} while (err > 0);
 
 	return err == 0;
 }
 
-int drbd_send_bitmap(struct drbd_device *mdev)
+int drbd_send_bitmap(struct drbd_device *device)
 {
-	struct drbd_socket *sock = &mdev->tconn->data;
+	struct drbd_socket *sock = &device->tconn->data;
 	int err = -1;
 
 	mutex_lock(&sock->mutex);
 	if (sock->socket)
-		err = !_drbd_send_bitmap(mdev);
+		err = !_drbd_send_bitmap(device);
 	mutex_unlock(&sock->mutex);
 	return err;
 }
@@ -1296,60 +1296,60 @@ void drbd_send_b_ack(struct drbd_tconn *tconn, u32 barrier_nr, u32 set_size)
 
 /**
  * _drbd_send_ack() - Sends an ack packet
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @cmd:	Packet command code.
  * @sector:	sector, needs to be in big endian byte order
  * @blksize:	size in byte, needs to be in big endian byte order
  * @block_id:	Id, big endian byte order
  */
-static int _drbd_send_ack(struct drbd_device *mdev, enum drbd_packet cmd,
+static int _drbd_send_ack(struct drbd_device *device, enum drbd_packet cmd,
 			  u64 sector, u32 blksize, u64 block_id)
 {
 	struct drbd_socket *sock;
 	struct p_block_ack *p;
 
-	if (mdev->state.conn < C_CONNECTED)
+	if (device->state.conn < C_CONNECTED)
 		return -EIO;
 
-	sock = &mdev->tconn->meta;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->meta;
+	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
 	p->sector = sector;
 	p->block_id = block_id;
 	p->blksize = blksize;
-	p->seq_num = cpu_to_be32(atomic_inc_return(&mdev->packet_seq));
-	return drbd_send_command(mdev, sock, cmd, sizeof(*p), NULL, 0);
+	p->seq_num = cpu_to_be32(atomic_inc_return(&device->packet_seq));
+	return drbd_send_command(device, sock, cmd, sizeof(*p), NULL, 0);
 }
 
 /* dp->sector and dp->block_id already/still in network byte order,
  * data_size is payload size according to dp->head,
  * and may need to be corrected for digest size. */
-void drbd_send_ack_dp(struct drbd_device *mdev, enum drbd_packet cmd,
+void drbd_send_ack_dp(struct drbd_device *device, enum drbd_packet cmd,
 		      struct p_data *dp, int data_size)
 {
-	if (mdev->tconn->peer_integrity_tfm)
-		data_size -= crypto_hash_digestsize(mdev->tconn->peer_integrity_tfm);
-	_drbd_send_ack(mdev, cmd, dp->sector, cpu_to_be32(data_size),
+	if (device->tconn->peer_integrity_tfm)
+		data_size -= crypto_hash_digestsize(device->tconn->peer_integrity_tfm);
+	_drbd_send_ack(device, cmd, dp->sector, cpu_to_be32(data_size),
 		       dp->block_id);
 }
 
-void drbd_send_ack_rp(struct drbd_device *mdev, enum drbd_packet cmd,
+void drbd_send_ack_rp(struct drbd_device *device, enum drbd_packet cmd,
 		      struct p_block_req *rp)
 {
-	_drbd_send_ack(mdev, cmd, rp->sector, rp->blksize, rp->block_id);
+	_drbd_send_ack(device, cmd, rp->sector, rp->blksize, rp->block_id);
 }
 
 /**
  * drbd_send_ack() - Sends an ack packet
- * @mdev:	DRBD device
+ * @device:	DRBD device
  * @cmd:	packet command code
  * @peer_req:	peer request
  */
-int drbd_send_ack(struct drbd_device *mdev, enum drbd_packet cmd,
+int drbd_send_ack(struct drbd_device *device, enum drbd_packet cmd,
 		  struct drbd_peer_request *peer_req)
 {
-	return _drbd_send_ack(mdev, cmd,
+	return _drbd_send_ack(device, cmd,
 			      cpu_to_be64(peer_req->i.sector),
 			      cpu_to_be32(peer_req->i.size),
 			      peer_req->block_id);
@@ -1357,32 +1357,32 @@ int drbd_send_ack(struct drbd_device *mdev, enum drbd_packet cmd,
 
 /* This function misuses the block_id field to signal if the blocks
  * are is sync or not. */
-int drbd_send_ack_ex(struct drbd_device *mdev, enum drbd_packet cmd,
+int drbd_send_ack_ex(struct drbd_device *device, enum drbd_packet cmd,
 		     sector_t sector, int blksize, u64 block_id)
 {
-	return _drbd_send_ack(mdev, cmd,
+	return _drbd_send_ack(device, cmd,
 			      cpu_to_be64(sector),
 			      cpu_to_be32(blksize),
 			      cpu_to_be64(block_id));
 }
 
-int drbd_send_drequest(struct drbd_device *mdev, int cmd,
+int drbd_send_drequest(struct drbd_device *device, int cmd,
 		       sector_t sector, int size, u64 block_id)
 {
 	struct drbd_socket *sock;
 	struct p_block_req *p;
 
-	sock = &mdev->tconn->data;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->data;
+	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
 	p->sector = cpu_to_be64(sector);
 	p->block_id = block_id;
 	p->blksize = cpu_to_be32(size);
-	return drbd_send_command(mdev, sock, cmd, sizeof(*p), NULL, 0);
+	return drbd_send_command(device, sock, cmd, sizeof(*p), NULL, 0);
 }
 
-int drbd_send_drequest_csum(struct drbd_device *mdev, sector_t sector, int size,
+int drbd_send_drequest_csum(struct drbd_device *device, sector_t sector, int size,
 			    void *digest, int digest_size, enum drbd_packet cmd)
 {
 	struct drbd_socket *sock;
@@ -1390,30 +1390,30 @@ int drbd_send_drequest_csum(struct drbd_device *mdev, sector_t sector, int size,
 
 	/* FIXME: Put the digest into the preallocated socket buffer.  */
 
-	sock = &mdev->tconn->data;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->data;
+	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
 	p->sector = cpu_to_be64(sector);
 	p->block_id = ID_SYNCER /* unused */;
 	p->blksize = cpu_to_be32(size);
-	return drbd_send_command(mdev, sock, cmd, sizeof(*p),
+	return drbd_send_command(device, sock, cmd, sizeof(*p),
 				 digest, digest_size);
 }
 
-int drbd_send_ov_request(struct drbd_device *mdev, sector_t sector, int size)
+int drbd_send_ov_request(struct drbd_device *device, sector_t sector, int size)
 {
 	struct drbd_socket *sock;
 	struct p_block_req *p;
 
-	sock = &mdev->tconn->data;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->data;
+	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
 	p->sector = cpu_to_be64(sector);
 	p->block_id = ID_SYNCER /* unused */;
 	p->blksize = cpu_to_be32(size);
-	return drbd_send_command(mdev, sock, P_OV_REQUEST, sizeof(*p), NULL, 0);
+	return drbd_send_command(device, sock, P_OV_REQUEST, sizeof(*p), NULL, 0);
 }
 
 /* called on sndtimeo
@@ -1423,7 +1423,7 @@ int drbd_send_ov_request(struct drbd_device *mdev, sector_t sector, int size)
 static int we_should_drop_the_connection(struct drbd_tconn *tconn, struct socket *sock)
 {
 	int drop_it;
-	/* long elapsed = (long)(jiffies - mdev->last_received); */
+	/* long elapsed = (long)(jiffies - device->last_received); */
 
 	drop_it =   tconn->meta.socket == sock
 		|| !tconn->asender.task
@@ -1440,7 +1440,7 @@ static int we_should_drop_the_connection(struct drbd_tconn *tconn, struct socket
 		request_ping(tconn);
 	}
 
-	return drop_it; /* && (mdev->state == R_PRIMARY) */;
+	return drop_it; /* && (device->state == R_PRIMARY) */;
 }
 
 static void drbd_update_congested(struct drbd_tconn *tconn)
@@ -1471,26 +1471,26 @@ static void drbd_update_congested(struct drbd_tconn *tconn)
  * As a workaround, we disable sendpage on pages
  * with page_count == 0 or PageSlab.
  */
-static int _drbd_no_send_page(struct drbd_device *mdev, struct page *page,
+static int _drbd_no_send_page(struct drbd_device *device, struct page *page,
 			      int offset, size_t size, unsigned msg_flags)
 {
 	struct socket *socket;
 	void *addr;
 	int err;
 
-	socket = mdev->tconn->data.socket;
+	socket = device->tconn->data.socket;
 	addr = kmap(page) + offset;
-	err = drbd_send_all(mdev->tconn, socket, addr, size, msg_flags);
+	err = drbd_send_all(device->tconn, socket, addr, size, msg_flags);
 	kunmap(page);
 	if (!err)
-		mdev->send_cnt += size >> 9;
+		device->send_cnt += size >> 9;
 	return err;
 }
 
-static int _drbd_send_page(struct drbd_device *mdev, struct page *page,
+static int _drbd_send_page(struct drbd_device *device, struct page *page,
 		    int offset, size_t size, unsigned msg_flags)
 {
-	struct socket *socket = mdev->tconn->data.socket;
+	struct socket *socket = device->tconn->data.socket;
 	mm_segment_t oldfs = get_fs();
 	int len = size;
 	int err = -EIO;
@@ -1502,10 +1502,10 @@ static int _drbd_send_page(struct drbd_device *mdev, struct page *page,
 	 * __page_cache_release a page that would actually still be referenced
 	 * by someone, leading to some obscure delayed Oops somewhere else. */
 	if (disable_sendpage || (page_count(page) < 1) || PageSlab(page))
-		return _drbd_no_send_page(mdev, page, offset, size, msg_flags);
+		return _drbd_no_send_page(device, page, offset, size, msg_flags);
 
 	msg_flags |= MSG_NOSIGNAL;
-	drbd_update_congested(mdev->tconn);
+	drbd_update_congested(device->tconn);
 	set_fs(KERNEL_DS);
 	do {
 		int sent;
@@ -1513,7 +1513,7 @@ static int _drbd_send_page(struct drbd_device *mdev, struct page *page,
 		sent = socket->ops->sendpage(socket, page, offset, len, msg_flags);
 		if (sent <= 0) {
 			if (sent == -EAGAIN) {
-				if (we_should_drop_the_connection(mdev->tconn, socket))
+				if (we_should_drop_the_connection(device->tconn, socket))
 					break;
 				continue;
 			}
@@ -1525,18 +1525,18 @@ static int _drbd_send_page(struct drbd_device *mdev, struct page *page,
 		}
 		len    -= sent;
 		offset += sent;
-	} while (len > 0 /* THINK && mdev->cstate >= C_CONNECTED*/);
+	} while (len > 0 /* THINK && device->cstate >= C_CONNECTED*/);
 	set_fs(oldfs);
-	clear_bit(NET_CONGESTED, &mdev->tconn->flags);
+	clear_bit(NET_CONGESTED, &device->tconn->flags);
 
 	if (len == 0) {
 		err = 0;
-		mdev->send_cnt += size >> 9;
+		device->send_cnt += size >> 9;
 	}
 	return err;
 }
 
-static int _drbd_send_bio(struct drbd_device *mdev, struct bio *bio)
+static int _drbd_send_bio(struct drbd_device *device, struct bio *bio)
 {
 	struct bio_vec bvec;
 	struct bvec_iter iter;
@@ -1545,7 +1545,7 @@ static int _drbd_send_bio(struct drbd_device *mdev, struct bio *bio)
 	bio_for_each_segment(bvec, bio, iter) {
 		int err;
 
-		err = _drbd_no_send_page(mdev, bvec.bv_page,
+		err = _drbd_no_send_page(device, bvec.bv_page,
 					 bvec.bv_offset, bvec.bv_len,
 					 bio_iter_last(bvec, iter)
 					 ? 0 : MSG_MORE);
@@ -1555,7 +1555,7 @@ static int _drbd_send_bio(struct drbd_device *mdev, struct bio *bio)
 	return 0;
 }
 
-static int _drbd_send_zc_bio(struct drbd_device *mdev, struct bio *bio)
+static int _drbd_send_zc_bio(struct drbd_device *device, struct bio *bio)
 {
 	struct bio_vec bvec;
 	struct bvec_iter iter;
@@ -1564,7 +1564,7 @@ static int _drbd_send_zc_bio(struct drbd_device *mdev, struct bio *bio)
 	bio_for_each_segment(bvec, bio, iter) {
 		int err;
 
-		err = _drbd_send_page(mdev, bvec.bv_page,
+		err = _drbd_send_page(device, bvec.bv_page,
 				      bvec.bv_offset, bvec.bv_len,
 				      bio_iter_last(bvec, iter) ? 0 : MSG_MORE);
 		if (err)
@@ -1573,7 +1573,7 @@ static int _drbd_send_zc_bio(struct drbd_device *mdev, struct bio *bio)
 	return 0;
 }
 
-static int _drbd_send_zc_ee(struct drbd_device *mdev,
+static int _drbd_send_zc_ee(struct drbd_device *device,
 			    struct drbd_peer_request *peer_req)
 {
 	struct page *page = peer_req->pages;
@@ -1584,7 +1584,7 @@ static int _drbd_send_zc_ee(struct drbd_device *mdev,
 	page_chain_for_each(page) {
 		unsigned l = min_t(unsigned, len, PAGE_SIZE);
 
-		err = _drbd_send_page(mdev, page, 0, l,
+		err = _drbd_send_page(device, page, 0, l,
 				      page_chain_next(page) ? MSG_MORE : 0);
 		if (err)
 			return err;
@@ -1593,9 +1593,9 @@ static int _drbd_send_zc_ee(struct drbd_device *mdev,
 	return 0;
 }
 
-static u32 bio_flags_to_wire(struct drbd_device *mdev, unsigned long bi_rw)
+static u32 bio_flags_to_wire(struct drbd_device *device, unsigned long bi_rw)
 {
-	if (mdev->tconn->agreed_pro_version >= 95)
+	if (device->tconn->agreed_pro_version >= 95)
 		return  (bi_rw & REQ_SYNC ? DP_RW_SYNC : 0) |
 			(bi_rw & REQ_FUA ? DP_FUA : 0) |
 			(bi_rw & REQ_FLUSH ? DP_FLUSH : 0) |
@@ -1607,7 +1607,7 @@ static u32 bio_flags_to_wire(struct drbd_device *mdev, unsigned long bi_rw)
 /* Used to send write requests
  * R_PRIMARY -> Peer	(P_DATA)
  */
-int drbd_send_dblock(struct drbd_device *mdev, struct drbd_request *req)
+int drbd_send_dblock(struct drbd_device *device, struct drbd_request *req)
 {
 	struct drbd_socket *sock;
 	struct p_data *p;
@@ -1615,20 +1615,20 @@ int drbd_send_dblock(struct drbd_device *mdev, struct drbd_request *req)
 	int dgs;
 	int err;
 
-	sock = &mdev->tconn->data;
-	p = drbd_prepare_command(mdev, sock);
-	dgs = mdev->tconn->integrity_tfm ? crypto_hash_digestsize(mdev->tconn->integrity_tfm) : 0;
+	sock = &device->tconn->data;
+	p = drbd_prepare_command(device, sock);
+	dgs = device->tconn->integrity_tfm ? crypto_hash_digestsize(device->tconn->integrity_tfm) : 0;
 
 	if (!p)
 		return -EIO;
 	p->sector = cpu_to_be64(req->i.sector);
 	p->block_id = (unsigned long)req;
-	p->seq_num = cpu_to_be32(atomic_inc_return(&mdev->packet_seq));
-	dp_flags = bio_flags_to_wire(mdev, req->master_bio->bi_rw);
-	if (mdev->state.conn >= C_SYNC_SOURCE &&
-	    mdev->state.conn <= C_PAUSED_SYNC_T)
+	p->seq_num = cpu_to_be32(atomic_inc_return(&device->packet_seq));
+	dp_flags = bio_flags_to_wire(device, req->master_bio->bi_rw);
+	if (device->state.conn >= C_SYNC_SOURCE &&
+	    device->state.conn <= C_PAUSED_SYNC_T)
 		dp_flags |= DP_MAY_SET_IN_SYNC;
-	if (mdev->tconn->agreed_pro_version >= 100) {
+	if (device->tconn->agreed_pro_version >= 100) {
 		if (req->rq_state & RQ_EXP_RECEIVE_ACK)
 			dp_flags |= DP_SEND_RECEIVE_ACK;
 		if (req->rq_state & RQ_EXP_WRITE_ACK)
@@ -1636,8 +1636,8 @@ int drbd_send_dblock(struct drbd_device *mdev, struct drbd_request *req)
 	}
 	p->dp_flags = cpu_to_be32(dp_flags);
 	if (dgs)
-		drbd_csum_bio(mdev, mdev->tconn->integrity_tfm, req->master_bio, p + 1);
-	err = __send_command(mdev->tconn, mdev->vnr, sock, P_DATA, sizeof(*p) + dgs, NULL, req->i.size);
+		drbd_csum_bio(device, device->tconn->integrity_tfm, req->master_bio, p + 1);
+	err = __send_command(device->tconn, device->vnr, sock, P_DATA, sizeof(*p) + dgs, NULL, req->i.size);
 	if (!err) {
 		/* For protocol A, we have to memcpy the payload into
 		 * socket buffers, as we may complete right away
@@ -1651,16 +1651,16 @@ int drbd_send_dblock(struct drbd_device *mdev, struct drbd_request *req)
 		 * receiving side, we sure have detected corruption elsewhere.
 		 */
 		if (!(req->rq_state & (RQ_EXP_RECEIVE_ACK | RQ_EXP_WRITE_ACK)) || dgs)
-			err = _drbd_send_bio(mdev, req->master_bio);
+			err = _drbd_send_bio(device, req->master_bio);
 		else
-			err = _drbd_send_zc_bio(mdev, req->master_bio);
+			err = _drbd_send_zc_bio(device, req->master_bio);
 
 		/* double check digest, sometimes buffers have been modified in flight. */
 		if (dgs > 0 && dgs <= 64) {
 			/* 64 byte, 512 bit, is the largest digest size
 			 * currently supported in kernel crypto. */
 			unsigned char digest[64];
-			drbd_csum_bio(mdev, mdev->tconn->integrity_tfm, req->master_bio, digest);
+			drbd_csum_bio(device, device->tconn->integrity_tfm, req->master_bio, digest);
 			if (memcmp(p + 1, digest, dgs)) {
 				dev_warn(DEV,
 					"Digest mismatch, buffer modified by upper layers during write: %llus +%u\n",
@@ -1679,7 +1679,7 @@ int drbd_send_dblock(struct drbd_device *mdev, struct drbd_request *req)
  *  Peer       -> (diskless) R_PRIMARY   (P_DATA_REPLY)
  *  C_SYNC_SOURCE -> C_SYNC_TARGET         (P_RS_DATA_REPLY)
  */
-int drbd_send_block(struct drbd_device *mdev, enum drbd_packet cmd,
+int drbd_send_block(struct drbd_device *device, enum drbd_packet cmd,
 		    struct drbd_peer_request *peer_req)
 {
 	struct drbd_socket *sock;
@@ -1687,10 +1687,10 @@ int drbd_send_block(struct drbd_device *mdev, enum drbd_packet cmd,
 	int err;
 	int dgs;
 
-	sock = &mdev->tconn->data;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->data;
+	p = drbd_prepare_command(device, sock);
 
-	dgs = mdev->tconn->integrity_tfm ? crypto_hash_digestsize(mdev->tconn->integrity_tfm) : 0;
+	dgs = device->tconn->integrity_tfm ? crypto_hash_digestsize(device->tconn->integrity_tfm) : 0;
 
 	if (!p)
 		return -EIO;
@@ -1699,27 +1699,27 @@ int drbd_send_block(struct drbd_device *mdev, enum drbd_packet cmd,
 	p->seq_num = 0;  /* unused */
 	p->dp_flags = 0;
 	if (dgs)
-		drbd_csum_ee(mdev, mdev->tconn->integrity_tfm, peer_req, p + 1);
-	err = __send_command(mdev->tconn, mdev->vnr, sock, cmd, sizeof(*p) + dgs, NULL, peer_req->i.size);
+		drbd_csum_ee(device, device->tconn->integrity_tfm, peer_req, p + 1);
+	err = __send_command(device->tconn, device->vnr, sock, cmd, sizeof(*p) + dgs, NULL, peer_req->i.size);
 	if (!err)
-		err = _drbd_send_zc_ee(mdev, peer_req);
+		err = _drbd_send_zc_ee(device, peer_req);
 	mutex_unlock(&sock->mutex);  /* locked by drbd_prepare_command() */
 
 	return err;
 }
 
-int drbd_send_out_of_sync(struct drbd_device *mdev, struct drbd_request *req)
+int drbd_send_out_of_sync(struct drbd_device *device, struct drbd_request *req)
 {
 	struct drbd_socket *sock;
 	struct p_block_desc *p;
 
-	sock = &mdev->tconn->data;
-	p = drbd_prepare_command(mdev, sock);
+	sock = &device->tconn->data;
+	p = drbd_prepare_command(device, sock);
 	if (!p)
 		return -EIO;
 	p->sector = cpu_to_be64(req->i.sector);
 	p->blksize = cpu_to_be32(req->i.size);
-	return drbd_send_command(mdev, sock, P_OUT_OF_SYNC, sizeof(*p), NULL, 0);
+	return drbd_send_command(device, sock, P_OUT_OF_SYNC, sizeof(*p), NULL, 0);
 }
 
 /*
@@ -1829,16 +1829,16 @@ int drbd_send_all(struct drbd_tconn *tconn, struct socket *sock, void *buffer,
 
 static int drbd_open(struct block_device *bdev, fmode_t mode)
 {
-	struct drbd_device *mdev = bdev->bd_disk->private_data;
+	struct drbd_device *device = bdev->bd_disk->private_data;
 	unsigned long flags;
 	int rv = 0;
 
 	mutex_lock(&drbd_main_mutex);
-	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-	/* to have a stable mdev->state.role
+	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	/* to have a stable device->state.role
 	 * and no race with updating open_cnt */
 
-	if (mdev->state.role != R_PRIMARY) {
+	if (device->state.role != R_PRIMARY) {
 		if (mode & FMODE_WRITE)
 			rv = -EROFS;
 		else if (!allow_oos)
@@ -1846,8 +1846,8 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 	}
 
 	if (!rv)
-		mdev->open_cnt++;
-	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
+		device->open_cnt++;
+	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
 	mutex_unlock(&drbd_main_mutex);
 
 	return rv;
@@ -1855,17 +1855,17 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 
 static void drbd_release(struct gendisk *gd, fmode_t mode)
 {
-	struct drbd_device *mdev = gd->private_data;
+	struct drbd_device *device = gd->private_data;
 	mutex_lock(&drbd_main_mutex);
-	mdev->open_cnt--;
+	device->open_cnt--;
 	mutex_unlock(&drbd_main_mutex);
 }
 
-static void drbd_set_defaults(struct drbd_device *mdev)
+static void drbd_set_defaults(struct drbd_device *device)
 {
 	/* Beware! The actual layout differs
 	 * between big endian and little endian */
-	mdev->state = (union drbd_dev_state) {
+	device->state = (union drbd_dev_state) {
 		{ .role = R_SECONDARY,
 		  .peer = R_UNKNOWN,
 		  .conn = C_STANDALONE,
@@ -1874,130 +1874,130 @@ static void drbd_set_defaults(struct drbd_device *mdev)
 		} };
 }
 
-void drbd_init_set_defaults(struct drbd_device *mdev)
+void drbd_init_set_defaults(struct drbd_device *device)
 {
 	/* the memset(,0,) did most of this.
 	 * note: only assignments, no allocation in here */
 
-	drbd_set_defaults(mdev);
-
-	atomic_set(&mdev->ap_bio_cnt, 0);
-	atomic_set(&mdev->ap_pending_cnt, 0);
-	atomic_set(&mdev->rs_pending_cnt, 0);
-	atomic_set(&mdev->unacked_cnt, 0);
-	atomic_set(&mdev->local_cnt, 0);
-	atomic_set(&mdev->pp_in_use_by_net, 0);
-	atomic_set(&mdev->rs_sect_in, 0);
-	atomic_set(&mdev->rs_sect_ev, 0);
-	atomic_set(&mdev->ap_in_flight, 0);
-	atomic_set(&mdev->md_io_in_use, 0);
-
-	mutex_init(&mdev->own_state_mutex);
-	mdev->state_mutex = &mdev->own_state_mutex;
-
-	spin_lock_init(&mdev->al_lock);
-	spin_lock_init(&mdev->peer_seq_lock);
-
-	INIT_LIST_HEAD(&mdev->active_ee);
-	INIT_LIST_HEAD(&mdev->sync_ee);
-	INIT_LIST_HEAD(&mdev->done_ee);
-	INIT_LIST_HEAD(&mdev->read_ee);
-	INIT_LIST_HEAD(&mdev->net_ee);
-	INIT_LIST_HEAD(&mdev->resync_reads);
-	INIT_LIST_HEAD(&mdev->resync_work.list);
-	INIT_LIST_HEAD(&mdev->unplug_work.list);
-	INIT_LIST_HEAD(&mdev->go_diskless.list);
-	INIT_LIST_HEAD(&mdev->md_sync_work.list);
-	INIT_LIST_HEAD(&mdev->start_resync_work.list);
-	INIT_LIST_HEAD(&mdev->bm_io_work.w.list);
-
-	mdev->resync_work.cb  = w_resync_timer;
-	mdev->unplug_work.cb  = w_send_write_hint;
-	mdev->go_diskless.cb  = w_go_diskless;
-	mdev->md_sync_work.cb = w_md_sync;
-	mdev->bm_io_work.w.cb = w_bitmap_io;
-	mdev->start_resync_work.cb = w_start_resync;
-
-	mdev->resync_work.mdev  = mdev;
-	mdev->unplug_work.mdev  = mdev;
-	mdev->go_diskless.mdev  = mdev;
-	mdev->md_sync_work.mdev = mdev;
-	mdev->bm_io_work.w.mdev = mdev;
-	mdev->start_resync_work.mdev = mdev;
-
-	init_timer(&mdev->resync_timer);
-	init_timer(&mdev->md_sync_timer);
-	init_timer(&mdev->start_resync_timer);
-	init_timer(&mdev->request_timer);
-	mdev->resync_timer.function = resync_timer_fn;
-	mdev->resync_timer.data = (unsigned long) mdev;
-	mdev->md_sync_timer.function = md_sync_timer_fn;
-	mdev->md_sync_timer.data = (unsigned long) mdev;
-	mdev->start_resync_timer.function = start_resync_timer_fn;
-	mdev->start_resync_timer.data = (unsigned long) mdev;
-	mdev->request_timer.function = request_timer_fn;
-	mdev->request_timer.data = (unsigned long) mdev;
-
-	init_waitqueue_head(&mdev->misc_wait);
-	init_waitqueue_head(&mdev->state_wait);
-	init_waitqueue_head(&mdev->ee_wait);
-	init_waitqueue_head(&mdev->al_wait);
-	init_waitqueue_head(&mdev->seq_wait);
-
-	mdev->resync_wenr = LC_FREE;
-	mdev->peer_max_bio_size = DRBD_MAX_BIO_SIZE_SAFE;
-	mdev->local_max_bio_size = DRBD_MAX_BIO_SIZE_SAFE;
-}
-
-void drbd_mdev_cleanup(struct drbd_device *mdev)
+	drbd_set_defaults(device);
+
+	atomic_set(&device->ap_bio_cnt, 0);
+	atomic_set(&device->ap_pending_cnt, 0);
+	atomic_set(&device->rs_pending_cnt, 0);
+	atomic_set(&device->unacked_cnt, 0);
+	atomic_set(&device->local_cnt, 0);
+	atomic_set(&device->pp_in_use_by_net, 0);
+	atomic_set(&device->rs_sect_in, 0);
+	atomic_set(&device->rs_sect_ev, 0);
+	atomic_set(&device->ap_in_flight, 0);
+	atomic_set(&device->md_io_in_use, 0);
+
+	mutex_init(&device->own_state_mutex);
+	device->state_mutex = &device->own_state_mutex;
+
+	spin_lock_init(&device->al_lock);
+	spin_lock_init(&device->peer_seq_lock);
+
+	INIT_LIST_HEAD(&device->active_ee);
+	INIT_LIST_HEAD(&device->sync_ee);
+	INIT_LIST_HEAD(&device->done_ee);
+	INIT_LIST_HEAD(&device->read_ee);
+	INIT_LIST_HEAD(&device->net_ee);
+	INIT_LIST_HEAD(&device->resync_reads);
+	INIT_LIST_HEAD(&device->resync_work.list);
+	INIT_LIST_HEAD(&device->unplug_work.list);
+	INIT_LIST_HEAD(&device->go_diskless.list);
+	INIT_LIST_HEAD(&device->md_sync_work.list);
+	INIT_LIST_HEAD(&device->start_resync_work.list);
+	INIT_LIST_HEAD(&device->bm_io_work.w.list);
+
+	device->resync_work.cb  = w_resync_timer;
+	device->unplug_work.cb  = w_send_write_hint;
+	device->go_diskless.cb  = w_go_diskless;
+	device->md_sync_work.cb = w_md_sync;
+	device->bm_io_work.w.cb = w_bitmap_io;
+	device->start_resync_work.cb = w_start_resync;
+
+	device->resync_work.device  = device;
+	device->unplug_work.device  = device;
+	device->go_diskless.device  = device;
+	device->md_sync_work.device = device;
+	device->bm_io_work.w.device = device;
+	device->start_resync_work.device = device;
+
+	init_timer(&device->resync_timer);
+	init_timer(&device->md_sync_timer);
+	init_timer(&device->start_resync_timer);
+	init_timer(&device->request_timer);
+	device->resync_timer.function = resync_timer_fn;
+	device->resync_timer.data = (unsigned long) device;
+	device->md_sync_timer.function = md_sync_timer_fn;
+	device->md_sync_timer.data = (unsigned long) device;
+	device->start_resync_timer.function = start_resync_timer_fn;
+	device->start_resync_timer.data = (unsigned long) device;
+	device->request_timer.function = request_timer_fn;
+	device->request_timer.data = (unsigned long) device;
+
+	init_waitqueue_head(&device->misc_wait);
+	init_waitqueue_head(&device->state_wait);
+	init_waitqueue_head(&device->ee_wait);
+	init_waitqueue_head(&device->al_wait);
+	init_waitqueue_head(&device->seq_wait);
+
+	device->resync_wenr = LC_FREE;
+	device->peer_max_bio_size = DRBD_MAX_BIO_SIZE_SAFE;
+	device->local_max_bio_size = DRBD_MAX_BIO_SIZE_SAFE;
+}
+
+void drbd_device_cleanup(struct drbd_device *device)
 {
 	int i;
-	if (mdev->tconn->receiver.t_state != NONE)
+	if (device->tconn->receiver.t_state != NONE)
 		dev_err(DEV, "ASSERT FAILED: receiver t_state == %d expected 0.\n",
-				mdev->tconn->receiver.t_state);
-
-	mdev->al_writ_cnt  =
-	mdev->bm_writ_cnt  =
-	mdev->read_cnt     =
-	mdev->recv_cnt     =
-	mdev->send_cnt     =
-	mdev->writ_cnt     =
-	mdev->p_size       =
-	mdev->rs_start     =
-	mdev->rs_total     =
-	mdev->rs_failed    = 0;
-	mdev->rs_last_events = 0;
-	mdev->rs_last_sect_ev = 0;
+				device->tconn->receiver.t_state);
+
+	device->al_writ_cnt  =
+	device->bm_writ_cnt  =
+	device->read_cnt     =
+	device->recv_cnt     =
+	device->send_cnt     =
+	device->writ_cnt     =
+	device->p_size       =
+	device->rs_start     =
+	device->rs_total     =
+	device->rs_failed    = 0;
+	device->rs_last_events = 0;
+	device->rs_last_sect_ev = 0;
 	for (i = 0; i < DRBD_SYNC_MARKS; i++) {
-		mdev->rs_mark_left[i] = 0;
-		mdev->rs_mark_time[i] = 0;
+		device->rs_mark_left[i] = 0;
+		device->rs_mark_time[i] = 0;
 	}
-	D_ASSERT(mdev->tconn->net_conf == NULL);
+	D_ASSERT(device->tconn->net_conf == NULL);
 
-	drbd_set_my_capacity(mdev, 0);
-	if (mdev->bitmap) {
+	drbd_set_my_capacity(device, 0);
+	if (device->bitmap) {
 		/* maybe never allocated. */
-		drbd_bm_resize(mdev, 0, 1);
-		drbd_bm_cleanup(mdev);
+		drbd_bm_resize(device, 0, 1);
+		drbd_bm_cleanup(device);
 	}
 
-	drbd_free_bc(mdev->ldev);
-	mdev->ldev = NULL;
+	drbd_free_bc(device->ldev);
+	device->ldev = NULL;
 
-	clear_bit(AL_SUSPENDED, &mdev->flags);
+	clear_bit(AL_SUSPENDED, &device->flags);
 
-	D_ASSERT(list_empty(&mdev->active_ee));
-	D_ASSERT(list_empty(&mdev->sync_ee));
-	D_ASSERT(list_empty(&mdev->done_ee));
-	D_ASSERT(list_empty(&mdev->read_ee));
-	D_ASSERT(list_empty(&mdev->net_ee));
-	D_ASSERT(list_empty(&mdev->resync_reads));
-	D_ASSERT(list_empty(&mdev->tconn->sender_work.q));
-	D_ASSERT(list_empty(&mdev->resync_work.list));
-	D_ASSERT(list_empty(&mdev->unplug_work.list));
-	D_ASSERT(list_empty(&mdev->go_diskless.list));
+	D_ASSERT(list_empty(&device->active_ee));
+	D_ASSERT(list_empty(&device->sync_ee));
+	D_ASSERT(list_empty(&device->done_ee));
+	D_ASSERT(list_empty(&device->read_ee));
+	D_ASSERT(list_empty(&device->net_ee));
+	D_ASSERT(list_empty(&device->resync_reads));
+	D_ASSERT(list_empty(&device->tconn->sender_work.q));
+	D_ASSERT(list_empty(&device->resync_work.list));
+	D_ASSERT(list_empty(&device->unplug_work.list));
+	D_ASSERT(list_empty(&device->go_diskless.list));
 
-	drbd_set_defaults(mdev);
+	drbd_set_defaults(device);
 }
 
 
@@ -2132,27 +2132,27 @@ static struct notifier_block drbd_notifier = {
 	.notifier_call = drbd_notify_sys,
 };
 
-static void drbd_release_all_peer_reqs(struct drbd_device *mdev)
+static void drbd_release_all_peer_reqs(struct drbd_device *device)
 {
 	int rr;
 
-	rr = drbd_free_peer_reqs(mdev, &mdev->active_ee);
+	rr = drbd_free_peer_reqs(device, &device->active_ee);
 	if (rr)
 		dev_err(DEV, "%d EEs in active list found!\n", rr);
 
-	rr = drbd_free_peer_reqs(mdev, &mdev->sync_ee);
+	rr = drbd_free_peer_reqs(device, &device->sync_ee);
 	if (rr)
 		dev_err(DEV, "%d EEs in sync list found!\n", rr);
 
-	rr = drbd_free_peer_reqs(mdev, &mdev->read_ee);
+	rr = drbd_free_peer_reqs(device, &device->read_ee);
 	if (rr)
 		dev_err(DEV, "%d EEs in read list found!\n", rr);
 
-	rr = drbd_free_peer_reqs(mdev, &mdev->done_ee);
+	rr = drbd_free_peer_reqs(device, &device->done_ee);
 	if (rr)
 		dev_err(DEV, "%d EEs in done list found!\n", rr);
 
-	rr = drbd_free_peer_reqs(mdev, &mdev->net_ee);
+	rr = drbd_free_peer_reqs(device, &device->net_ee);
 	if (rr)
 		dev_err(DEV, "%d EEs in net list found!\n", rr);
 }
@@ -2160,39 +2160,39 @@ static void drbd_release_all_peer_reqs(struct drbd_device *mdev)
 /* caution. no locking. */
 void drbd_minor_destroy(struct kref *kref)
 {
-	struct drbd_device *mdev = container_of(kref, struct drbd_device, kref);
-	struct drbd_tconn *tconn = mdev->tconn;
+	struct drbd_device *device = container_of(kref, struct drbd_device, kref);
+	struct drbd_tconn *tconn = device->tconn;
 
-	del_timer_sync(&mdev->request_timer);
+	del_timer_sync(&device->request_timer);
 
 	/* paranoia asserts */
-	D_ASSERT(mdev->open_cnt == 0);
+	D_ASSERT(device->open_cnt == 0);
 	/* end paranoia asserts */
 
 	/* cleanup stuff that may have been allocated during
 	 * device (re-)configuration or state changes */
 
-	if (mdev->this_bdev)
-		bdput(mdev->this_bdev);
+	if (device->this_bdev)
+		bdput(device->this_bdev);
 
-	drbd_free_bc(mdev->ldev);
-	mdev->ldev = NULL;
+	drbd_free_bc(device->ldev);
+	device->ldev = NULL;
 
-	drbd_release_all_peer_reqs(mdev);
+	drbd_release_all_peer_reqs(device);
 
-	lc_destroy(mdev->act_log);
-	lc_destroy(mdev->resync);
+	lc_destroy(device->act_log);
+	lc_destroy(device->resync);
 
-	kfree(mdev->p_uuid);
-	/* mdev->p_uuid = NULL; */
+	kfree(device->p_uuid);
+	/* device->p_uuid = NULL; */
 
-	if (mdev->bitmap) /* should no longer be there. */
-		drbd_bm_cleanup(mdev);
-	__free_page(mdev->md_io_page);
-	put_disk(mdev->vdisk);
-	blk_cleanup_queue(mdev->rq_queue);
-	kfree(mdev->rs_plan_s);
-	kfree(mdev);
+	if (device->bitmap) /* should no longer be there. */
+		drbd_bm_cleanup(device);
+	__free_page(device->md_io_page);
+	put_disk(device->vdisk);
+	blk_cleanup_queue(device->rq_queue);
+	kfree(device->rs_plan_s);
+	kfree(device);
 
 	kref_put(&tconn->kref, &conn_destroy);
 }
@@ -2219,7 +2219,7 @@ static void do_retry(struct work_struct *ws)
 	spin_unlock_irq(&retry->lock);
 
 	list_for_each_entry_safe(req, tmp, &writes, tl_requests) {
-		struct drbd_device *mdev = req->w.mdev;
+		struct drbd_device *device = req->w.device;
 		struct bio *bio = req->master_bio;
 		unsigned long start_time = req->start_time;
 		bool expected;
@@ -2255,8 +2255,8 @@ static void do_retry(struct work_struct *ws)
 
 		/* We are not just doing generic_make_request(),
 		 * as we want to keep the start_time information. */
-		inc_ap_bio(mdev);
-		__drbd_make_request(mdev, bio, start_time);
+		inc_ap_bio(device);
+		__drbd_make_request(device, bio, start_time);
 	}
 }
 
@@ -2270,7 +2270,7 @@ void drbd_restart_request(struct drbd_request *req)
 	/* Drop the extra reference that would otherwise
 	 * have been dropped by complete_master_bio.
 	 * do_retry() needs to grab a new one. */
-	dec_ap_bio(req->w.mdev);
+	dec_ap_bio(req->w.device);
 
 	queue_work(retry.wq, &retry.worker);
 }
@@ -2279,7 +2279,7 @@ void drbd_restart_request(struct drbd_request *req)
 static void drbd_cleanup(void)
 {
 	unsigned int i;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct drbd_tconn *tconn, *tmp;
 
 	unregister_reboot_notifier(&drbd_notifier);
@@ -2300,13 +2300,13 @@ static void drbd_cleanup(void)
 
 	drbd_genl_unregister();
 
-	idr_for_each_entry(&minors, mdev, i) {
-		idr_remove(&minors, mdev_to_minor(mdev));
-		idr_remove(&mdev->tconn->volumes, mdev->vnr);
-		destroy_workqueue(mdev->submit.wq);
-		del_gendisk(mdev->vdisk);
+	idr_for_each_entry(&minors, device, i) {
+		idr_remove(&minors, device_to_minor(device));
+		idr_remove(&device->tconn->volumes, device->vnr);
+		destroy_workqueue(device->submit.wq);
+		del_gendisk(device->vdisk);
 		/* synchronize_rcu(); No other threads running at this point */
-		kref_put(&mdev->kref, &drbd_minor_destroy);
+		kref_put(&device->kref, &drbd_minor_destroy);
 	}
 
 	/* not _rcu since, no other updater anymore. Genl already unregistered */
@@ -2333,49 +2333,49 @@ static void drbd_cleanup(void)
  */
 static int drbd_congested(void *congested_data, int bdi_bits)
 {
-	struct drbd_device *mdev = congested_data;
+	struct drbd_device *device = congested_data;
 	struct request_queue *q;
 	char reason = '-';
 	int r = 0;
 
-	if (!may_inc_ap_bio(mdev)) {
+	if (!may_inc_ap_bio(device)) {
 		/* DRBD has frozen IO */
 		r = bdi_bits;
 		reason = 'd';
 		goto out;
 	}
 
-	if (test_bit(CALLBACK_PENDING, &mdev->tconn->flags)) {
+	if (test_bit(CALLBACK_PENDING, &device->tconn->flags)) {
 		r |= (1 << BDI_async_congested);
 		/* Without good local data, we would need to read from remote,
 		 * and that would need the worker thread as well, which is
 		 * currently blocked waiting for that usermode helper to
 		 * finish.
 		 */
-		if (!get_ldev_if_state(mdev, D_UP_TO_DATE))
+		if (!get_ldev_if_state(device, D_UP_TO_DATE))
 			r |= (1 << BDI_sync_congested);
 		else
-			put_ldev(mdev);
+			put_ldev(device);
 		r &= bdi_bits;
 		reason = 'c';
 		goto out;
 	}
 
-	if (get_ldev(mdev)) {
-		q = bdev_get_queue(mdev->ldev->backing_bdev);
+	if (get_ldev(device)) {
+		q = bdev_get_queue(device->ldev->backing_bdev);
 		r = bdi_congested(&q->backing_dev_info, bdi_bits);
-		put_ldev(mdev);
+		put_ldev(device);
 		if (r)
 			reason = 'b';
 	}
 
-	if (bdi_bits & (1 << BDI_async_congested) && test_bit(NET_CONGESTED, &mdev->tconn->flags)) {
+	if (bdi_bits & (1 << BDI_async_congested) && test_bit(NET_CONGESTED, &device->tconn->flags)) {
 		r |= (1 << BDI_async_congested);
 		reason = reason == 'b' ? 'a' : 'n';
 	}
 
 out:
-	mdev->congestion_reason = reason;
+	device->congestion_reason = reason;
 	return r;
 }
 
@@ -2593,57 +2593,57 @@ void conn_destroy(struct kref *kref)
 	kfree(tconn);
 }
 
-int init_submitter(struct drbd_device *mdev)
+int init_submitter(struct drbd_device *device)
 {
 	/* opencoded create_singlethread_workqueue(),
 	 * to be able to say "drbd%d", ..., minor */
-	mdev->submit.wq = alloc_workqueue("drbd%u_submit",
-			WQ_UNBOUND | WQ_MEM_RECLAIM, 1, mdev->minor);
-	if (!mdev->submit.wq)
+	device->submit.wq = alloc_workqueue("drbd%u_submit",
+			WQ_UNBOUND | WQ_MEM_RECLAIM, 1, device->minor);
+	if (!device->submit.wq)
 		return -ENOMEM;
 
-	INIT_WORK(&mdev->submit.worker, do_submit);
-	spin_lock_init(&mdev->submit.lock);
-	INIT_LIST_HEAD(&mdev->submit.writes);
+	INIT_WORK(&device->submit.worker, do_submit);
+	spin_lock_init(&device->submit.lock);
+	INIT_LIST_HEAD(&device->submit.writes);
 	return 0;
 }
 
 enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor, int vnr)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct gendisk *disk;
 	struct request_queue *q;
 	int vnr_got = vnr;
 	int minor_got = minor;
 	enum drbd_ret_code err = ERR_NOMEM;
 
-	mdev = minor_to_mdev(minor);
-	if (mdev)
+	device = minor_to_device(minor);
+	if (device)
 		return ERR_MINOR_EXISTS;
 
 	/* GFP_KERNEL, we are outside of all write-out paths */
-	mdev = kzalloc(sizeof(struct drbd_device), GFP_KERNEL);
-	if (!mdev)
+	device = kzalloc(sizeof(struct drbd_device), GFP_KERNEL);
+	if (!device)
 		return ERR_NOMEM;
 
 	kref_get(&tconn->kref);
-	mdev->tconn = tconn;
+	device->tconn = tconn;
 
-	mdev->minor = minor;
-	mdev->vnr = vnr;
+	device->minor = minor;
+	device->vnr = vnr;
 
-	drbd_init_set_defaults(mdev);
+	drbd_init_set_defaults(device);
 
 	q = blk_alloc_queue(GFP_KERNEL);
 	if (!q)
 		goto out_no_q;
-	mdev->rq_queue = q;
-	q->queuedata   = mdev;
+	device->rq_queue = q;
+	q->queuedata   = device;
 
 	disk = alloc_disk(1);
 	if (!disk)
 		goto out_no_disk;
-	mdev->vdisk = disk;
+	device->vdisk = disk;
 
 	set_disk_ro(disk, true);
 
@@ -2652,14 +2652,14 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	disk->first_minor = minor;
 	disk->fops = &drbd_ops;
 	sprintf(disk->disk_name, "drbd%d", minor);
-	disk->private_data = mdev;
+	disk->private_data = device;
 
-	mdev->this_bdev = bdget(MKDEV(DRBD_MAJOR, minor));
+	device->this_bdev = bdget(MKDEV(DRBD_MAJOR, minor));
 	/* we have no partitions. we contain only ourselves. */
-	mdev->this_bdev->bd_contains = mdev->this_bdev;
+	device->this_bdev->bd_contains = device->this_bdev;
 
 	q->backing_dev_info.congested_fn = drbd_congested;
-	q->backing_dev_info.congested_data = mdev;
+	q->backing_dev_info.congested_data = device;
 
 	blk_queue_make_request(q, drbd_make_request);
 	blk_queue_flush(q, REQ_FLUSH | REQ_FUA);
@@ -2668,18 +2668,18 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	blk_queue_max_hw_sectors(q, DRBD_MAX_BIO_SIZE_SAFE >> 8);
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 	blk_queue_merge_bvec(q, drbd_merge_bvec);
-	q->queue_lock = &mdev->tconn->req_lock; /* needed since we use */
+	q->queue_lock = &device->tconn->req_lock; /* needed since we use */
 
-	mdev->md_io_page = alloc_page(GFP_KERNEL);
-	if (!mdev->md_io_page)
+	device->md_io_page = alloc_page(GFP_KERNEL);
+	if (!device->md_io_page)
 		goto out_no_io_page;
 
-	if (drbd_bm_init(mdev))
+	if (drbd_bm_init(device))
 		goto out_no_bitmap;
-	mdev->read_requests = RB_ROOT;
-	mdev->write_requests = RB_ROOT;
+	device->read_requests = RB_ROOT;
+	device->write_requests = RB_ROOT;
 
-	minor_got = idr_alloc(&minors, mdev, minor, minor + 1, GFP_KERNEL);
+	minor_got = idr_alloc(&minors, device, minor, minor + 1, GFP_KERNEL);
 	if (minor_got < 0) {
 		if (minor_got == -ENOSPC) {
 			err = ERR_MINOR_EXISTS;
@@ -2688,7 +2688,7 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 		goto out_no_minor_idr;
 	}
 
-	vnr_got = idr_alloc(&tconn->volumes, mdev, vnr, vnr + 1, GFP_KERNEL);
+	vnr_got = idr_alloc(&tconn->volumes, device, vnr, vnr + 1, GFP_KERNEL);
 	if (vnr_got < 0) {
 		if (vnr_got == -ENOSPC) {
 			err = ERR_INVALID_REQUEST;
@@ -2697,19 +2697,19 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 		goto out_idr_remove_minor;
 	}
 
-	if (init_submitter(mdev)) {
+	if (init_submitter(device)) {
 		err = ERR_NOMEM;
 		drbd_msg_put_info("unable to create submit workqueue");
 		goto out_idr_remove_vol;
 	}
 
 	add_disk(disk);
-	kref_init(&mdev->kref); /* one ref for both idrs and the the add_disk */
+	kref_init(&device->kref); /* one ref for both idrs and the the add_disk */
 
 	/* inherit the connection state */
-	mdev->state.conn = tconn->cstate;
-	if (mdev->state.conn == C_WF_REPORT_PARAMS)
-		drbd_connected(mdev);
+	device->state.conn = tconn->cstate;
+	if (device->state.conn == C_WF_REPORT_PARAMS)
+		drbd_connected(device);
 
 	return NO_ERROR;
 
@@ -2719,15 +2719,15 @@ out_idr_remove_minor:
 	idr_remove(&minors, minor_got);
 	synchronize_rcu();
 out_no_minor_idr:
-	drbd_bm_cleanup(mdev);
+	drbd_bm_cleanup(device);
 out_no_bitmap:
-	__free_page(mdev->md_io_page);
+	__free_page(device->md_io_page);
 out_no_io_page:
 	put_disk(disk);
 out_no_disk:
 	blk_cleanup_queue(q);
 out_no_q:
-	kfree(mdev);
+	kfree(device);
 	kref_put(&tconn->kref, &conn_destroy);
 	return err;
 }
@@ -2845,15 +2845,15 @@ void drbd_free_sock(struct drbd_tconn *tconn)
 
 void conn_md_sync(struct drbd_tconn *tconn)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		kref_get(&mdev->kref);
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
+		kref_get(&device->kref);
 		rcu_read_unlock();
-		drbd_md_sync(mdev);
-		kref_put(&mdev->kref, &drbd_minor_destroy);
+		drbd_md_sync(device);
+		kref_put(&device->kref, &drbd_minor_destroy);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
@@ -2884,7 +2884,7 @@ struct meta_data_on_disk {
 
 
 
-void drbd_md_write(struct drbd_device *mdev, void *b)
+void drbd_md_write(struct drbd_device *device, void *b)
 {
 	struct meta_data_on_disk *buffer = b;
 	sector_t sector;
@@ -2892,39 +2892,39 @@ void drbd_md_write(struct drbd_device *mdev, void *b)
 
 	memset(buffer, 0, sizeof(*buffer));
 
-	buffer->la_size_sect = cpu_to_be64(drbd_get_capacity(mdev->this_bdev));
+	buffer->la_size_sect = cpu_to_be64(drbd_get_capacity(device->this_bdev));
 	for (i = UI_CURRENT; i < UI_SIZE; i++)
-		buffer->uuid[i] = cpu_to_be64(mdev->ldev->md.uuid[i]);
-	buffer->flags = cpu_to_be32(mdev->ldev->md.flags);
+		buffer->uuid[i] = cpu_to_be64(device->ldev->md.uuid[i]);
+	buffer->flags = cpu_to_be32(device->ldev->md.flags);
 	buffer->magic = cpu_to_be32(DRBD_MD_MAGIC_84_UNCLEAN);
 
-	buffer->md_size_sect  = cpu_to_be32(mdev->ldev->md.md_size_sect);
-	buffer->al_offset     = cpu_to_be32(mdev->ldev->md.al_offset);
-	buffer->al_nr_extents = cpu_to_be32(mdev->act_log->nr_elements);
+	buffer->md_size_sect  = cpu_to_be32(device->ldev->md.md_size_sect);
+	buffer->al_offset     = cpu_to_be32(device->ldev->md.al_offset);
+	buffer->al_nr_extents = cpu_to_be32(device->act_log->nr_elements);
 	buffer->bm_bytes_per_bit = cpu_to_be32(BM_BLOCK_SIZE);
-	buffer->device_uuid = cpu_to_be64(mdev->ldev->md.device_uuid);
+	buffer->device_uuid = cpu_to_be64(device->ldev->md.device_uuid);
 
-	buffer->bm_offset = cpu_to_be32(mdev->ldev->md.bm_offset);
-	buffer->la_peer_max_bio_size = cpu_to_be32(mdev->peer_max_bio_size);
+	buffer->bm_offset = cpu_to_be32(device->ldev->md.bm_offset);
+	buffer->la_peer_max_bio_size = cpu_to_be32(device->peer_max_bio_size);
 
-	buffer->al_stripes = cpu_to_be32(mdev->ldev->md.al_stripes);
-	buffer->al_stripe_size_4k = cpu_to_be32(mdev->ldev->md.al_stripe_size_4k);
+	buffer->al_stripes = cpu_to_be32(device->ldev->md.al_stripes);
+	buffer->al_stripe_size_4k = cpu_to_be32(device->ldev->md.al_stripe_size_4k);
 
-	D_ASSERT(drbd_md_ss(mdev->ldev) == mdev->ldev->md.md_offset);
-	sector = mdev->ldev->md.md_offset;
+	D_ASSERT(drbd_md_ss(device->ldev) == device->ldev->md.md_offset);
+	sector = device->ldev->md.md_offset;
 
-	if (drbd_md_sync_page_io(mdev, mdev->ldev, sector, WRITE)) {
+	if (drbd_md_sync_page_io(device, device->ldev, sector, WRITE)) {
 		/* this was a try anyways ... */
 		dev_err(DEV, "meta data update failed!\n");
-		drbd_chk_io_error(mdev, 1, DRBD_META_IO_ERROR);
+		drbd_chk_io_error(device, 1, DRBD_META_IO_ERROR);
 	}
 }
 
 /**
  * drbd_md_sync() - Writes the meta data super block if the MD_DIRTY flag bit is set
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  */
-void drbd_md_sync(struct drbd_device *mdev)
+void drbd_md_sync(struct drbd_device *device)
 {
 	struct meta_data_on_disk *buffer;
 
@@ -2932,32 +2932,32 @@ void drbd_md_sync(struct drbd_device *mdev)
 	BUILD_BUG_ON(UI_SIZE != 4);
 	BUILD_BUG_ON(sizeof(struct meta_data_on_disk) != 4096);
 
-	del_timer(&mdev->md_sync_timer);
+	del_timer(&device->md_sync_timer);
 	/* timer may be rearmed by drbd_md_mark_dirty() now. */
-	if (!test_and_clear_bit(MD_DIRTY, &mdev->flags))
+	if (!test_and_clear_bit(MD_DIRTY, &device->flags))
 		return;
 
 	/* We use here D_FAILED and not D_ATTACHING because we try to write
 	 * metadata even if we detach due to a disk failure! */
-	if (!get_ldev_if_state(mdev, D_FAILED))
+	if (!get_ldev_if_state(device, D_FAILED))
 		return;
 
-	buffer = drbd_md_get_buffer(mdev);
+	buffer = drbd_md_get_buffer(device);
 	if (!buffer)
 		goto out;
 
-	drbd_md_write(mdev, buffer);
+	drbd_md_write(device, buffer);
 
-	/* Update mdev->ldev->md.la_size_sect,
+	/* Update device->ldev->md.la_size_sect,
 	 * since we updated it on metadata. */
-	mdev->ldev->md.la_size_sect = drbd_get_capacity(mdev->this_bdev);
+	device->ldev->md.la_size_sect = drbd_get_capacity(device->this_bdev);
 
-	drbd_md_put_buffer(mdev);
+	drbd_md_put_buffer(device);
 out:
-	put_ldev(mdev);
+	put_ldev(device);
 }
 
-static int check_activity_log_stripe_size(struct drbd_device *mdev,
+static int check_activity_log_stripe_size(struct drbd_device *device,
 		struct meta_data_on_disk *on_disk,
 		struct drbd_md *in_core)
 {
@@ -3002,7 +3002,7 @@ err:
 	return -EINVAL;
 }
 
-static int check_offsets_and_sizes(struct drbd_device *mdev, struct drbd_backing_dev *bdev)
+static int check_offsets_and_sizes(struct drbd_device *device, struct drbd_backing_dev *bdev)
 {
 	sector_t capacity = drbd_get_capacity(bdev->md_bdev);
 	struct drbd_md *in_core = &bdev->md;
@@ -3084,25 +3084,25 @@ err:
 
 /**
  * drbd_md_read() - Reads in the meta data super block
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @bdev:	Device from which the meta data should be read in.
  *
  * Return NO_ERROR on success, and an enum drbd_ret_code in case
  * something goes wrong.
  *
  * Called exactly once during drbd_adm_attach(), while still being D_DISKLESS,
- * even before @bdev is assigned to @mdev->ldev.
+ * even before @bdev is assigned to @device->ldev.
  */
-int drbd_md_read(struct drbd_device *mdev, struct drbd_backing_dev *bdev)
+int drbd_md_read(struct drbd_device *device, struct drbd_backing_dev *bdev)
 {
 	struct meta_data_on_disk *buffer;
 	u32 magic, flags;
 	int i, rv = NO_ERROR;
 
-	if (mdev->state.disk != D_DISKLESS)
+	if (device->state.disk != D_DISKLESS)
 		return ERR_DISK_CONFIGURED;
 
-	buffer = drbd_md_get_buffer(mdev);
+	buffer = drbd_md_get_buffer(device);
 	if (!buffer)
 		return ERR_NOMEM;
 
@@ -3111,7 +3111,7 @@ int drbd_md_read(struct drbd_device *mdev, struct drbd_backing_dev *bdev)
 	bdev->md.meta_dev_idx = bdev->disk_conf->meta_dev_idx;
 	bdev->md.md_offset = drbd_md_ss(bdev);
 
-	if (drbd_md_sync_page_io(mdev, bdev, bdev->md.md_offset, READ)) {
+	if (drbd_md_sync_page_io(device, bdev, bdev->md.md_offset, READ)) {
 		/* NOTE: can't do normal error processing here as this is
 		   called BEFORE disk is attached */
 		dev_err(DEV, "Error while reading metadata.\n");
@@ -3156,9 +3156,9 @@ int drbd_md_read(struct drbd_device *mdev, struct drbd_backing_dev *bdev)
 	bdev->md.al_offset = be32_to_cpu(buffer->al_offset);
 	bdev->md.bm_offset = be32_to_cpu(buffer->bm_offset);
 
-	if (check_activity_log_stripe_size(mdev, buffer, &bdev->md))
+	if (check_activity_log_stripe_size(device, buffer, &bdev->md))
 		goto err;
-	if (check_offsets_and_sizes(mdev, bdev))
+	if (check_offsets_and_sizes(device, bdev))
 		goto err;
 
 	if (be32_to_cpu(buffer->bm_offset) != bdev->md.bm_offset) {
@@ -3174,164 +3174,164 @@ int drbd_md_read(struct drbd_device *mdev, struct drbd_backing_dev *bdev)
 
 	rv = NO_ERROR;
 
-	spin_lock_irq(&mdev->tconn->req_lock);
-	if (mdev->state.conn < C_CONNECTED) {
+	spin_lock_irq(&device->tconn->req_lock);
+	if (device->state.conn < C_CONNECTED) {
 		unsigned int peer;
 		peer = be32_to_cpu(buffer->la_peer_max_bio_size);
 		peer = max(peer, DRBD_MAX_BIO_SIZE_SAFE);
-		mdev->peer_max_bio_size = peer;
+		device->peer_max_bio_size = peer;
 	}
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_unlock_irq(&device->tconn->req_lock);
 
  err:
-	drbd_md_put_buffer(mdev);
+	drbd_md_put_buffer(device);
 
 	return rv;
 }
 
 /**
  * drbd_md_mark_dirty() - Mark meta data super block as dirty
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Call this function if you change anything that should be written to
  * the meta-data super block. This function sets MD_DIRTY, and starts a
  * timer that ensures that within five seconds you have to call drbd_md_sync().
  */
 #ifdef DEBUG
-void drbd_md_mark_dirty_(struct drbd_device *mdev, unsigned int line, const char *func)
+void drbd_md_mark_dirty_(struct drbd_device *device, unsigned int line, const char *func)
 {
-	if (!test_and_set_bit(MD_DIRTY, &mdev->flags)) {
-		mod_timer(&mdev->md_sync_timer, jiffies + HZ);
-		mdev->last_md_mark_dirty.line = line;
-		mdev->last_md_mark_dirty.func = func;
+	if (!test_and_set_bit(MD_DIRTY, &device->flags)) {
+		mod_timer(&device->md_sync_timer, jiffies + HZ);
+		device->last_md_mark_dirty.line = line;
+		device->last_md_mark_dirty.func = func;
 	}
 }
 #else
-void drbd_md_mark_dirty(struct drbd_device *mdev)
+void drbd_md_mark_dirty(struct drbd_device *device)
 {
-	if (!test_and_set_bit(MD_DIRTY, &mdev->flags))
-		mod_timer(&mdev->md_sync_timer, jiffies + 5*HZ);
+	if (!test_and_set_bit(MD_DIRTY, &device->flags))
+		mod_timer(&device->md_sync_timer, jiffies + 5*HZ);
 }
 #endif
 
-void drbd_uuid_move_history(struct drbd_device *mdev) __must_hold(local)
+void drbd_uuid_move_history(struct drbd_device *device) __must_hold(local)
 {
 	int i;
 
 	for (i = UI_HISTORY_START; i < UI_HISTORY_END; i++)
-		mdev->ldev->md.uuid[i+1] = mdev->ldev->md.uuid[i];
+		device->ldev->md.uuid[i+1] = device->ldev->md.uuid[i];
 }
 
-void __drbd_uuid_set(struct drbd_device *mdev, int idx, u64 val) __must_hold(local)
+void __drbd_uuid_set(struct drbd_device *device, int idx, u64 val) __must_hold(local)
 {
 	if (idx == UI_CURRENT) {
-		if (mdev->state.role == R_PRIMARY)
+		if (device->state.role == R_PRIMARY)
 			val |= 1;
 		else
 			val &= ~((u64)1);
 
-		drbd_set_ed_uuid(mdev, val);
+		drbd_set_ed_uuid(device, val);
 	}
 
-	mdev->ldev->md.uuid[idx] = val;
-	drbd_md_mark_dirty(mdev);
+	device->ldev->md.uuid[idx] = val;
+	drbd_md_mark_dirty(device);
 }
 
-void _drbd_uuid_set(struct drbd_device *mdev, int idx, u64 val) __must_hold(local)
+void _drbd_uuid_set(struct drbd_device *device, int idx, u64 val) __must_hold(local)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&mdev->ldev->md.uuid_lock, flags);
-	__drbd_uuid_set(mdev, idx, val);
-	spin_unlock_irqrestore(&mdev->ldev->md.uuid_lock, flags);
+	spin_lock_irqsave(&device->ldev->md.uuid_lock, flags);
+	__drbd_uuid_set(device, idx, val);
+	spin_unlock_irqrestore(&device->ldev->md.uuid_lock, flags);
 }
 
-void drbd_uuid_set(struct drbd_device *mdev, int idx, u64 val) __must_hold(local)
+void drbd_uuid_set(struct drbd_device *device, int idx, u64 val) __must_hold(local)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&mdev->ldev->md.uuid_lock, flags);
-	if (mdev->ldev->md.uuid[idx]) {
-		drbd_uuid_move_history(mdev);
-		mdev->ldev->md.uuid[UI_HISTORY_START] = mdev->ldev->md.uuid[idx];
+	spin_lock_irqsave(&device->ldev->md.uuid_lock, flags);
+	if (device->ldev->md.uuid[idx]) {
+		drbd_uuid_move_history(device);
+		device->ldev->md.uuid[UI_HISTORY_START] = device->ldev->md.uuid[idx];
 	}
-	__drbd_uuid_set(mdev, idx, val);
-	spin_unlock_irqrestore(&mdev->ldev->md.uuid_lock, flags);
+	__drbd_uuid_set(device, idx, val);
+	spin_unlock_irqrestore(&device->ldev->md.uuid_lock, flags);
 }
 
 /**
  * drbd_uuid_new_current() - Creates a new current UUID
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Creates a new current UUID, and rotates the old current UUID into
  * the bitmap slot. Causes an incremental resync upon next connect.
  */
-void drbd_uuid_new_current(struct drbd_device *mdev) __must_hold(local)
+void drbd_uuid_new_current(struct drbd_device *device) __must_hold(local)
 {
 	u64 val;
 	unsigned long long bm_uuid;
 
 	get_random_bytes(&val, sizeof(u64));
 
-	spin_lock_irq(&mdev->ldev->md.uuid_lock);
-	bm_uuid = mdev->ldev->md.uuid[UI_BITMAP];
+	spin_lock_irq(&device->ldev->md.uuid_lock);
+	bm_uuid = device->ldev->md.uuid[UI_BITMAP];
 
 	if (bm_uuid)
 		dev_warn(DEV, "bm UUID was already set: %llX\n", bm_uuid);
 
-	mdev->ldev->md.uuid[UI_BITMAP] = mdev->ldev->md.uuid[UI_CURRENT];
-	__drbd_uuid_set(mdev, UI_CURRENT, val);
-	spin_unlock_irq(&mdev->ldev->md.uuid_lock);
+	device->ldev->md.uuid[UI_BITMAP] = device->ldev->md.uuid[UI_CURRENT];
+	__drbd_uuid_set(device, UI_CURRENT, val);
+	spin_unlock_irq(&device->ldev->md.uuid_lock);
 
-	drbd_print_uuids(mdev, "new current UUID");
+	drbd_print_uuids(device, "new current UUID");
 	/* get it to stable storage _now_ */
-	drbd_md_sync(mdev);
+	drbd_md_sync(device);
 }
 
-void drbd_uuid_set_bm(struct drbd_device *mdev, u64 val) __must_hold(local)
+void drbd_uuid_set_bm(struct drbd_device *device, u64 val) __must_hold(local)
 {
 	unsigned long flags;
-	if (mdev->ldev->md.uuid[UI_BITMAP] == 0 && val == 0)
+	if (device->ldev->md.uuid[UI_BITMAP] == 0 && val == 0)
 		return;
 
-	spin_lock_irqsave(&mdev->ldev->md.uuid_lock, flags);
+	spin_lock_irqsave(&device->ldev->md.uuid_lock, flags);
 	if (val == 0) {
-		drbd_uuid_move_history(mdev);
-		mdev->ldev->md.uuid[UI_HISTORY_START] = mdev->ldev->md.uuid[UI_BITMAP];
-		mdev->ldev->md.uuid[UI_BITMAP] = 0;
+		drbd_uuid_move_history(device);
+		device->ldev->md.uuid[UI_HISTORY_START] = device->ldev->md.uuid[UI_BITMAP];
+		device->ldev->md.uuid[UI_BITMAP] = 0;
 	} else {
-		unsigned long long bm_uuid = mdev->ldev->md.uuid[UI_BITMAP];
+		unsigned long long bm_uuid = device->ldev->md.uuid[UI_BITMAP];
 		if (bm_uuid)
 			dev_warn(DEV, "bm UUID was already set: %llX\n", bm_uuid);
 
-		mdev->ldev->md.uuid[UI_BITMAP] = val & ~((u64)1);
+		device->ldev->md.uuid[UI_BITMAP] = val & ~((u64)1);
 	}
-	spin_unlock_irqrestore(&mdev->ldev->md.uuid_lock, flags);
+	spin_unlock_irqrestore(&device->ldev->md.uuid_lock, flags);
 
-	drbd_md_mark_dirty(mdev);
+	drbd_md_mark_dirty(device);
 }
 
 /**
  * drbd_bmio_set_n_write() - io_fn for drbd_queue_bitmap_io() or drbd_bitmap_io()
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Sets all bits in the bitmap and writes the whole bitmap to stable storage.
  */
-int drbd_bmio_set_n_write(struct drbd_device *mdev)
+int drbd_bmio_set_n_write(struct drbd_device *device)
 {
 	int rv = -EIO;
 
-	if (get_ldev_if_state(mdev, D_ATTACHING)) {
-		drbd_md_set_flag(mdev, MDF_FULL_SYNC);
-		drbd_md_sync(mdev);
-		drbd_bm_set_all(mdev);
+	if (get_ldev_if_state(device, D_ATTACHING)) {
+		drbd_md_set_flag(device, MDF_FULL_SYNC);
+		drbd_md_sync(device);
+		drbd_bm_set_all(device);
 
-		rv = drbd_bm_write(mdev);
+		rv = drbd_bm_write(device);
 
 		if (!rv) {
-			drbd_md_clear_flag(mdev, MDF_FULL_SYNC);
-			drbd_md_sync(mdev);
+			drbd_md_clear_flag(device, MDF_FULL_SYNC);
+			drbd_md_sync(device);
 		}
 
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 
 	return rv;
@@ -3339,19 +3339,19 @@ int drbd_bmio_set_n_write(struct drbd_device *mdev)
 
 /**
  * drbd_bmio_clear_n_write() - io_fn for drbd_queue_bitmap_io() or drbd_bitmap_io()
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Clears all bits in the bitmap and writes the whole bitmap to stable storage.
  */
-int drbd_bmio_clear_n_write(struct drbd_device *mdev)
+int drbd_bmio_clear_n_write(struct drbd_device *device)
 {
 	int rv = -EIO;
 
-	drbd_resume_al(mdev);
-	if (get_ldev_if_state(mdev, D_ATTACHING)) {
-		drbd_bm_clear_all(mdev);
-		rv = drbd_bm_write(mdev);
-		put_ldev(mdev);
+	drbd_resume_al(device);
+	if (get_ldev_if_state(device, D_ATTACHING)) {
+		drbd_bm_clear_all(device);
+		rv = drbd_bm_write(device);
+		put_ldev(device);
 	}
 
 	return rv;
@@ -3360,49 +3360,49 @@ int drbd_bmio_clear_n_write(struct drbd_device *mdev)
 static int w_bitmap_io(struct drbd_work *w, int unused)
 {
 	struct bm_io_work *work = container_of(w, struct bm_io_work, w);
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	int rv = -EIO;
 
-	D_ASSERT(atomic_read(&mdev->ap_bio_cnt) == 0);
+	D_ASSERT(atomic_read(&device->ap_bio_cnt) == 0);
 
-	if (get_ldev(mdev)) {
-		drbd_bm_lock(mdev, work->why, work->flags);
-		rv = work->io_fn(mdev);
-		drbd_bm_unlock(mdev);
-		put_ldev(mdev);
+	if (get_ldev(device)) {
+		drbd_bm_lock(device, work->why, work->flags);
+		rv = work->io_fn(device);
+		drbd_bm_unlock(device);
+		put_ldev(device);
 	}
 
-	clear_bit_unlock(BITMAP_IO, &mdev->flags);
-	wake_up(&mdev->misc_wait);
+	clear_bit_unlock(BITMAP_IO, &device->flags);
+	wake_up(&device->misc_wait);
 
 	if (work->done)
-		work->done(mdev, rv);
+		work->done(device, rv);
 
-	clear_bit(BITMAP_IO_QUEUED, &mdev->flags);
+	clear_bit(BITMAP_IO_QUEUED, &device->flags);
 	work->why = NULL;
 	work->flags = 0;
 
 	return 0;
 }
 
-void drbd_ldev_destroy(struct drbd_device *mdev)
+void drbd_ldev_destroy(struct drbd_device *device)
 {
-	lc_destroy(mdev->resync);
-	mdev->resync = NULL;
-	lc_destroy(mdev->act_log);
-	mdev->act_log = NULL;
+	lc_destroy(device->resync);
+	device->resync = NULL;
+	lc_destroy(device->act_log);
+	device->act_log = NULL;
 	__no_warn(local,
-		drbd_free_bc(mdev->ldev);
-		mdev->ldev = NULL;);
+		drbd_free_bc(device->ldev);
+		device->ldev = NULL;);
 
-	clear_bit(GO_DISKLESS, &mdev->flags);
+	clear_bit(GO_DISKLESS, &device->flags);
 }
 
 static int w_go_diskless(struct drbd_work *w, int unused)
 {
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 
-	D_ASSERT(mdev->state.disk == D_FAILED);
+	D_ASSERT(device->state.disk == D_FAILED);
 	/* we cannot assert local_cnt == 0 here, as get_ldev_if_state will
 	 * inc/dec it frequently. Once we are D_DISKLESS, no one will touch
 	 * the protected members anymore, though, so once put_ldev reaches zero
@@ -3421,27 +3421,27 @@ static int w_go_diskless(struct drbd_work *w, int unused)
 	 * We still need to check if both bitmap and ldev are present, we may
 	 * end up here after a failed attach, before ldev was even assigned.
 	 */
-	if (mdev->bitmap && mdev->ldev) {
+	if (device->bitmap && device->ldev) {
 		/* An interrupted resync or similar is allowed to recounts bits
 		 * while we detach.
 		 * Any modifications would not be expected anymore, though.
 		 */
-		if (drbd_bitmap_io_from_worker(mdev, drbd_bm_write,
+		if (drbd_bitmap_io_from_worker(device, drbd_bm_write,
 					"detach", BM_LOCKED_TEST_ALLOWED)) {
-			if (test_bit(WAS_READ_ERROR, &mdev->flags)) {
-				drbd_md_set_flag(mdev, MDF_FULL_SYNC);
-				drbd_md_sync(mdev);
+			if (test_bit(WAS_READ_ERROR, &device->flags)) {
+				drbd_md_set_flag(device, MDF_FULL_SYNC);
+				drbd_md_sync(device);
 			}
 		}
 	}
 
-	drbd_force_state(mdev, NS(disk, D_DISKLESS));
+	drbd_force_state(device, NS(disk, D_DISKLESS));
 	return 0;
 }
 
 /**
  * drbd_queue_bitmap_io() - Queues an IO operation on the whole bitmap
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @io_fn:	IO callback to be called when bitmap IO is possible
  * @done:	callback to be called after the bitmap IO was performed
  * @why:	Descriptive text of the reason for doing the IO
@@ -3451,76 +3451,76 @@ static int w_go_diskless(struct drbd_work *w, int unused)
  * called from worker context. It MUST NOT be used while a previous such
  * work is still pending!
  */
-void drbd_queue_bitmap_io(struct drbd_device *mdev,
+void drbd_queue_bitmap_io(struct drbd_device *device,
 			  int (*io_fn)(struct drbd_device *),
 			  void (*done)(struct drbd_device *, int),
 			  char *why, enum bm_flag flags)
 {
-	D_ASSERT(current == mdev->tconn->worker.task);
+	D_ASSERT(current == device->tconn->worker.task);
 
-	D_ASSERT(!test_bit(BITMAP_IO_QUEUED, &mdev->flags));
-	D_ASSERT(!test_bit(BITMAP_IO, &mdev->flags));
-	D_ASSERT(list_empty(&mdev->bm_io_work.w.list));
-	if (mdev->bm_io_work.why)
+	D_ASSERT(!test_bit(BITMAP_IO_QUEUED, &device->flags));
+	D_ASSERT(!test_bit(BITMAP_IO, &device->flags));
+	D_ASSERT(list_empty(&device->bm_io_work.w.list));
+	if (device->bm_io_work.why)
 		dev_err(DEV, "FIXME going to queue '%s' but '%s' still pending?\n",
-			why, mdev->bm_io_work.why);
+			why, device->bm_io_work.why);
 
-	mdev->bm_io_work.io_fn = io_fn;
-	mdev->bm_io_work.done = done;
-	mdev->bm_io_work.why = why;
-	mdev->bm_io_work.flags = flags;
+	device->bm_io_work.io_fn = io_fn;
+	device->bm_io_work.done = done;
+	device->bm_io_work.why = why;
+	device->bm_io_work.flags = flags;
 
-	spin_lock_irq(&mdev->tconn->req_lock);
-	set_bit(BITMAP_IO, &mdev->flags);
-	if (atomic_read(&mdev->ap_bio_cnt) == 0) {
-		if (!test_and_set_bit(BITMAP_IO_QUEUED, &mdev->flags))
-			drbd_queue_work(&mdev->tconn->sender_work, &mdev->bm_io_work.w);
+	spin_lock_irq(&device->tconn->req_lock);
+	set_bit(BITMAP_IO, &device->flags);
+	if (atomic_read(&device->ap_bio_cnt) == 0) {
+		if (!test_and_set_bit(BITMAP_IO_QUEUED, &device->flags))
+			drbd_queue_work(&device->tconn->sender_work, &device->bm_io_work.w);
 	}
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_unlock_irq(&device->tconn->req_lock);
 }
 
 /**
  * drbd_bitmap_io() -  Does an IO operation on the whole bitmap
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @io_fn:	IO callback to be called when bitmap IO is possible
  * @why:	Descriptive text of the reason for doing the IO
  *
  * freezes application IO while that the actual IO operations runs. This
  * functions MAY NOT be called from worker context.
  */
-int drbd_bitmap_io(struct drbd_device *mdev, int (*io_fn)(struct drbd_device *),
+int drbd_bitmap_io(struct drbd_device *device, int (*io_fn)(struct drbd_device *),
 		char *why, enum bm_flag flags)
 {
 	int rv;
 
-	D_ASSERT(current != mdev->tconn->worker.task);
+	D_ASSERT(current != device->tconn->worker.task);
 
 	if ((flags & BM_LOCKED_SET_ALLOWED) == 0)
-		drbd_suspend_io(mdev);
+		drbd_suspend_io(device);
 
-	drbd_bm_lock(mdev, why, flags);
-	rv = io_fn(mdev);
-	drbd_bm_unlock(mdev);
+	drbd_bm_lock(device, why, flags);
+	rv = io_fn(device);
+	drbd_bm_unlock(device);
 
 	if ((flags & BM_LOCKED_SET_ALLOWED) == 0)
-		drbd_resume_io(mdev);
+		drbd_resume_io(device);
 
 	return rv;
 }
 
-void drbd_md_set_flag(struct drbd_device *mdev, int flag) __must_hold(local)
+void drbd_md_set_flag(struct drbd_device *device, int flag) __must_hold(local)
 {
-	if ((mdev->ldev->md.flags & flag) != flag) {
-		drbd_md_mark_dirty(mdev);
-		mdev->ldev->md.flags |= flag;
+	if ((device->ldev->md.flags & flag) != flag) {
+		drbd_md_mark_dirty(device);
+		device->ldev->md.flags |= flag;
 	}
 }
 
-void drbd_md_clear_flag(struct drbd_device *mdev, int flag) __must_hold(local)
+void drbd_md_clear_flag(struct drbd_device *device, int flag) __must_hold(local)
 {
-	if ((mdev->ldev->md.flags & flag) != 0) {
-		drbd_md_mark_dirty(mdev);
-		mdev->ldev->md.flags &= ~flag;
+	if ((device->ldev->md.flags & flag) != 0) {
+		drbd_md_mark_dirty(device);
+		device->ldev->md.flags &= ~flag;
 	}
 }
 int drbd_md_test_flag(struct drbd_backing_dev *bdev, int flag)
@@ -3530,23 +3530,23 @@ int drbd_md_test_flag(struct drbd_backing_dev *bdev, int flag)
 
 static void md_sync_timer_fn(unsigned long data)
 {
-	struct drbd_device *mdev = (struct drbd_device *) data;
+	struct drbd_device *device = (struct drbd_device *) data;
 
 	/* must not double-queue! */
-	if (list_empty(&mdev->md_sync_work.list))
-		drbd_queue_work_front(&mdev->tconn->sender_work, &mdev->md_sync_work);
+	if (list_empty(&device->md_sync_work.list))
+		drbd_queue_work_front(&device->tconn->sender_work, &device->md_sync_work);
 }
 
 static int w_md_sync(struct drbd_work *w, int unused)
 {
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 
 	dev_warn(DEV, "md_sync_timer expired! Worker calls drbd_md_sync().\n");
 #ifdef DEBUG
 	dev_warn(DEV, "last md_mark_dirty: %s:%u\n",
-		mdev->last_md_mark_dirty.func, mdev->last_md_mark_dirty.line);
+		device->last_md_mark_dirty.func, device->last_md_mark_dirty.line);
 #endif
-	drbd_md_sync(mdev);
+	drbd_md_sync(device);
 	return 0;
 }
 
@@ -3622,18 +3622,18 @@ const char *cmdname(enum drbd_packet cmd)
 
 /**
  * drbd_wait_misc  -  wait for a request to make progress
- * @mdev:	device associated with the request
+ * @device:	device associated with the request
  * @i:		the struct drbd_interval embedded in struct drbd_request or
  *		struct drbd_peer_request
  */
-int drbd_wait_misc(struct drbd_device *mdev, struct drbd_interval *i)
+int drbd_wait_misc(struct drbd_device *device, struct drbd_interval *i)
 {
 	struct net_conf *nc;
 	DEFINE_WAIT(wait);
 	long timeout;
 
 	rcu_read_lock();
-	nc = rcu_dereference(mdev->tconn->net_conf);
+	nc = rcu_dereference(device->tconn->net_conf);
 	if (!nc) {
 		rcu_read_unlock();
 		return -ETIMEDOUT;
@@ -3641,14 +3641,14 @@ int drbd_wait_misc(struct drbd_device *mdev, struct drbd_interval *i)
 	timeout = nc->ko_count ? nc->timeout * HZ / 10 * nc->ko_count : MAX_SCHEDULE_TIMEOUT;
 	rcu_read_unlock();
 
-	/* Indicate to wake up mdev->misc_wait on progress.  */
+	/* Indicate to wake up device->misc_wait on progress.  */
 	i->waiting = true;
-	prepare_to_wait(&mdev->misc_wait, &wait, TASK_INTERRUPTIBLE);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	prepare_to_wait(&device->misc_wait, &wait, TASK_INTERRUPTIBLE);
+	spin_unlock_irq(&device->tconn->req_lock);
 	timeout = schedule_timeout(timeout);
-	finish_wait(&mdev->misc_wait, &wait);
-	spin_lock_irq(&mdev->tconn->req_lock);
-	if (!timeout || mdev->state.conn < C_CONNECTED)
+	finish_wait(&device->misc_wait, &wait);
+	spin_lock_irq(&device->tconn->req_lock);
+	if (!timeout || device->state.conn < C_CONNECTED)
 		return -ETIMEDOUT;
 	if (signal_pending(current))
 		return -ERESTARTSYS;
@@ -3704,13 +3704,13 @@ _drbd_fault_str(unsigned int type) {
 }
 
 unsigned int
-_drbd_insert_fault(struct drbd_device *mdev, unsigned int type)
+_drbd_insert_fault(struct drbd_device *device, unsigned int type)
 {
 	static struct fault_random_state rrs = {0, 0};
 
 	unsigned int ret = (
 		(fault_devs == 0 ||
-			((1 << mdev_to_minor(mdev)) & fault_devs) != 0) &&
+			((1 << device_to_minor(device)) & fault_devs) != 0) &&
 		(((_drbd_fault_random(&rrs) % 100) + 1) <= fault_rate));
 
 	if (ret) {
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 9edc201..107a824 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -103,7 +103,7 @@ static struct drbd_config_context {
 	/* pointer into reply buffer */
 	struct drbd_genlmsghdr *reply_dh;
 	/* resolved from attributes, if possible */
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct drbd_tconn *tconn;
 } adm_ctx;
 
@@ -212,10 +212,10 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	}
 
 	adm_ctx.minor = d_in->minor;
-	adm_ctx.mdev = minor_to_mdev(d_in->minor);
+	adm_ctx.device = minor_to_device(d_in->minor);
 	adm_ctx.tconn = conn_get_by_name(adm_ctx.resource_name);
 
-	if (!adm_ctx.mdev && (flags & DRBD_ADM_NEED_MINOR)) {
+	if (!adm_ctx.device && (flags & DRBD_ADM_NEED_MINOR)) {
 		drbd_msg_put_info("unknown minor");
 		return ERR_MINOR_INVALID;
 	}
@@ -229,7 +229,7 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 			drbd_msg_put_info("no resource name expected");
 			return ERR_INVALID_REQUEST;
 		}
-		if (adm_ctx.mdev) {
+		if (adm_ctx.device) {
 			drbd_msg_put_info("no minor number expected");
 			return ERR_INVALID_REQUEST;
 		}
@@ -245,20 +245,20 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	}
 
 	/* some more paranoia, if the request was over-determined */
-	if (adm_ctx.mdev && adm_ctx.tconn &&
-	    adm_ctx.mdev->tconn != adm_ctx.tconn) {
+	if (adm_ctx.device && adm_ctx.tconn &&
+	    adm_ctx.device->tconn != adm_ctx.tconn) {
 		pr_warning("request: minor=%u, resource=%s; but that minor belongs to connection %s\n",
 				adm_ctx.minor, adm_ctx.resource_name,
-				adm_ctx.mdev->tconn->name);
+				adm_ctx.device->tconn->name);
 		drbd_msg_put_info("minor exists in different resource");
 		return ERR_INVALID_REQUEST;
 	}
-	if (adm_ctx.mdev &&
+	if (adm_ctx.device &&
 	    adm_ctx.volume != VOLUME_UNSPECIFIED &&
-	    adm_ctx.volume != adm_ctx.mdev->vnr) {
+	    adm_ctx.volume != adm_ctx.device->vnr) {
 		pr_warning("request: minor=%u, volume=%u; but that minor is volume %u in %s\n",
 				adm_ctx.minor, adm_ctx.volume,
-				adm_ctx.mdev->vnr, adm_ctx.mdev->tconn->name);
+				adm_ctx.device->vnr, adm_ctx.device->tconn->name);
 		drbd_msg_put_info("minor exists as different volume");
 		return ERR_INVALID_REQUEST;
 	}
@@ -313,7 +313,7 @@ static void setup_khelper_env(struct drbd_tconn *tconn, char **envp)
 	snprintf(envp[3], 20, "DRBD_PEER_AF=%s", afs);
 }
 
-int drbd_khelper(struct drbd_device *mdev, char *cmd)
+int drbd_khelper(struct drbd_device *device, char *cmd)
 {
 	char *envp[] = { "HOME=/",
 			"TERM=linux",
@@ -323,24 +323,24 @@ int drbd_khelper(struct drbd_device *mdev, char *cmd)
 			NULL };
 	char mb[12];
 	char *argv[] = {usermode_helper, cmd, mb, NULL };
-	struct drbd_tconn *tconn = mdev->tconn;
+	struct drbd_tconn *tconn = device->tconn;
 	struct sib_info sib;
 	int ret;
 
 	if (current == tconn->worker.task)
 		set_bit(CALLBACK_PENDING, &tconn->flags);
 
-	snprintf(mb, 12, "minor-%d", mdev_to_minor(mdev));
+	snprintf(mb, 12, "minor-%d", device_to_minor(device));
 	setup_khelper_env(tconn, envp);
 
 	/* The helper may take some time.
 	 * write out any unsynced meta data changes now */
-	drbd_md_sync(mdev);
+	drbd_md_sync(device);
 
 	dev_info(DEV, "helper command: %s %s %s\n", usermode_helper, cmd, mb);
 	sib.sib_reason = SIB_HELPER_PRE;
 	sib.helper_name = cmd;
-	drbd_bcast_event(mdev, &sib);
+	drbd_bcast_event(device, &sib);
 	ret = call_usermodehelper(usermode_helper, argv, envp, UMH_WAIT_PROC);
 	if (ret)
 		dev_warn(DEV, "helper command: %s %s %s exit code %u (0x%x)\n",
@@ -352,7 +352,7 @@ int drbd_khelper(struct drbd_device *mdev, char *cmd)
 				(ret >> 8) & 0xff, ret);
 	sib.sib_reason = SIB_HELPER_POST;
 	sib.helper_exit_code = ret;
-	drbd_bcast_event(mdev, &sib);
+	drbd_bcast_event(device, &sib);
 
 	if (current == tconn->worker.task)
 		clear_bit(CALLBACK_PENDING, &tconn->flags);
@@ -400,15 +400,15 @@ int conn_khelper(struct drbd_tconn *tconn, char *cmd)
 static enum drbd_fencing_p highest_fencing_policy(struct drbd_tconn *tconn)
 {
 	enum drbd_fencing_p fp = FP_NOT_AVAIL;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		if (get_ldev_if_state(mdev, D_CONSISTENT)) {
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
+		if (get_ldev_if_state(device, D_CONSISTENT)) {
 			fp = max_t(enum drbd_fencing_p, fp,
-				   rcu_dereference(mdev->ldev->disk_conf)->fencing);
-			put_ldev(mdev);
+				   rcu_dereference(device->ldev->disk_conf)->fencing);
+			put_ldev(device);
 		}
 	}
 	rcu_read_unlock();
@@ -534,7 +534,7 @@ void conn_try_outdate_peer_async(struct drbd_tconn *tconn)
 }
 
 enum drbd_state_rv
-drbd_set_role(struct drbd_device *mdev, enum drbd_role new_role, int force)
+drbd_set_role(struct drbd_device *device, enum drbd_role new_role, int force)
 {
 	const int max_tries = 4;
 	enum drbd_state_rv rv = SS_UNKNOWN_ERROR;
@@ -544,15 +544,15 @@ drbd_set_role(struct drbd_device *mdev, enum drbd_role new_role, int force)
 	union drbd_state mask, val;
 
 	if (new_role == R_PRIMARY)
-		request_ping(mdev->tconn); /* Detect a dead peer ASAP */
+		request_ping(device->tconn); /* Detect a dead peer ASAP */
 
-	mutex_lock(mdev->state_mutex);
+	mutex_lock(device->state_mutex);
 
 	mask.i = 0; mask.role = R_MASK;
 	val.i  = 0; val.role  = new_role;
 
 	while (try++ < max_tries) {
-		rv = _drbd_request_state(mdev, mask, val, CS_WAIT_COMPLETE);
+		rv = _drbd_request_state(device, mask, val, CS_WAIT_COMPLETE);
 
 		/* in case we first succeeded to outdate,
 		 * but now suddenly could establish a connection */
@@ -563,8 +563,8 @@ drbd_set_role(struct drbd_device *mdev, enum drbd_role new_role, int force)
 		}
 
 		if (rv == SS_NO_UP_TO_DATE_DISK && force &&
-		    (mdev->state.disk < D_UP_TO_DATE &&
-		     mdev->state.disk >= D_INCONSISTENT)) {
+		    (device->state.disk < D_UP_TO_DATE &&
+		     device->state.disk >= D_INCONSISTENT)) {
 			mask.disk = D_MASK;
 			val.disk  = D_UP_TO_DATE;
 			forced = 1;
@@ -572,10 +572,10 @@ drbd_set_role(struct drbd_device *mdev, enum drbd_role new_role, int force)
 		}
 
 		if (rv == SS_NO_UP_TO_DATE_DISK &&
-		    mdev->state.disk == D_CONSISTENT && mask.pdsk == 0) {
-			D_ASSERT(mdev->state.pdsk == D_UNKNOWN);
+		    device->state.disk == D_CONSISTENT && mask.pdsk == 0) {
+			D_ASSERT(device->state.pdsk == D_UNKNOWN);
 
-			if (conn_try_outdate_peer(mdev->tconn)) {
+			if (conn_try_outdate_peer(device->tconn)) {
 				val.disk = D_UP_TO_DATE;
 				mask.disk = D_MASK;
 			}
@@ -585,7 +585,7 @@ drbd_set_role(struct drbd_device *mdev, enum drbd_role new_role, int force)
 		if (rv == SS_NOTHING_TO_DO)
 			goto out;
 		if (rv == SS_PRIMARY_NOP && mask.pdsk == 0) {
-			if (!conn_try_outdate_peer(mdev->tconn) && force) {
+			if (!conn_try_outdate_peer(device->tconn) && force) {
 				dev_warn(DEV, "Forced into split brain situation!\n");
 				mask.pdsk = D_MASK;
 				val.pdsk  = D_OUTDATED;
@@ -598,7 +598,7 @@ drbd_set_role(struct drbd_device *mdev, enum drbd_role new_role, int force)
 			   retry at most once more in this case. */
 			int timeo;
 			rcu_read_lock();
-			nc = rcu_dereference(mdev->tconn->net_conf);
+			nc = rcu_dereference(device->tconn->net_conf);
 			timeo = nc ? (nc->ping_timeo + 1) * HZ / 10 : 1;
 			rcu_read_unlock();
 			schedule_timeout_interruptible(timeo);
@@ -607,7 +607,7 @@ drbd_set_role(struct drbd_device *mdev, enum drbd_role new_role, int force)
 			continue;
 		}
 		if (rv < SS_SUCCESS) {
-			rv = _drbd_request_state(mdev, mask, val,
+			rv = _drbd_request_state(device, mask, val,
 						CS_VERBOSE + CS_WAIT_COMPLETE);
 			if (rv < SS_SUCCESS)
 				goto out;
@@ -622,50 +622,50 @@ drbd_set_role(struct drbd_device *mdev, enum drbd_role new_role, int force)
 		dev_warn(DEV, "Forced to consider local data as UpToDate!\n");
 
 	/* Wait until nothing is on the fly :) */
-	wait_event(mdev->misc_wait, atomic_read(&mdev->ap_pending_cnt) == 0);
+	wait_event(device->misc_wait, atomic_read(&device->ap_pending_cnt) == 0);
 
 	/* FIXME also wait for all pending P_BARRIER_ACK? */
 
 	if (new_role == R_SECONDARY) {
-		set_disk_ro(mdev->vdisk, true);
-		if (get_ldev(mdev)) {
-			mdev->ldev->md.uuid[UI_CURRENT] &= ~(u64)1;
-			put_ldev(mdev);
+		set_disk_ro(device->vdisk, true);
+		if (get_ldev(device)) {
+			device->ldev->md.uuid[UI_CURRENT] &= ~(u64)1;
+			put_ldev(device);
 		}
 	} else {
-		mutex_lock(&mdev->tconn->conf_update);
-		nc = mdev->tconn->net_conf;
+		mutex_lock(&device->tconn->conf_update);
+		nc = device->tconn->net_conf;
 		if (nc)
 			nc->discard_my_data = 0; /* without copy; single bit op is atomic */
-		mutex_unlock(&mdev->tconn->conf_update);
+		mutex_unlock(&device->tconn->conf_update);
 
-		set_disk_ro(mdev->vdisk, false);
-		if (get_ldev(mdev)) {
-			if (((mdev->state.conn < C_CONNECTED ||
-			       mdev->state.pdsk <= D_FAILED)
-			      && mdev->ldev->md.uuid[UI_BITMAP] == 0) || forced)
-				drbd_uuid_new_current(mdev);
+		set_disk_ro(device->vdisk, false);
+		if (get_ldev(device)) {
+			if (((device->state.conn < C_CONNECTED ||
+			       device->state.pdsk <= D_FAILED)
+			      && device->ldev->md.uuid[UI_BITMAP] == 0) || forced)
+				drbd_uuid_new_current(device);
 
-			mdev->ldev->md.uuid[UI_CURRENT] |=  (u64)1;
-			put_ldev(mdev);
+			device->ldev->md.uuid[UI_CURRENT] |=  (u64)1;
+			put_ldev(device);
 		}
 	}
 
 	/* writeout of activity log covered areas of the bitmap
 	 * to stable storage done in after state change already */
 
-	if (mdev->state.conn >= C_WF_REPORT_PARAMS) {
+	if (device->state.conn >= C_WF_REPORT_PARAMS) {
 		/* if this was forced, we should consider sync */
 		if (forced)
-			drbd_send_uuids(mdev);
-		drbd_send_current_state(mdev);
+			drbd_send_uuids(device);
+		drbd_send_current_state(device);
 	}
 
-	drbd_md_sync(mdev);
+	drbd_md_sync(device);
 
-	kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
+	kobject_uevent(&disk_to_dev(device->vdisk)->kobj, KOBJ_CHANGE);
 out:
-	mutex_unlock(mdev->state_mutex);
+	mutex_unlock(device->state_mutex);
 	return rv;
 }
 
@@ -700,9 +700,9 @@ int drbd_adm_set_role(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->genlhdr->cmd == DRBD_ADM_PRIMARY)
-		retcode = drbd_set_role(adm_ctx.mdev, R_PRIMARY, parms.assume_uptodate);
+		retcode = drbd_set_role(adm_ctx.device, R_PRIMARY, parms.assume_uptodate);
 	else
-		retcode = drbd_set_role(adm_ctx.mdev, R_SECONDARY, 0);
+		retcode = drbd_set_role(adm_ctx.device, R_SECONDARY, 0);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -729,7 +729,7 @@ out:
  *  Activity log size used to be fixed 32kB,
  *  but is about to become configurable.
  */
-static void drbd_md_set_sector_offsets(struct drbd_device *mdev,
+static void drbd_md_set_sector_offsets(struct drbd_device *device,
 				       struct drbd_backing_dev *bdev)
 {
 	sector_t md_size_sect = 0;
@@ -805,35 +805,35 @@ char *ppsize(char *buf, unsigned long long size)
  * drbd_adm_suspend_io/drbd_adm_resume_io,
  * which are (sub) state changes triggered by admin (drbdsetup),
  * and can be long lived.
- * This changes an mdev->flag, is triggered by drbd internals,
+ * This changes an device->flag, is triggered by drbd internals,
  * and should be short-lived. */
-void drbd_suspend_io(struct drbd_device *mdev)
+void drbd_suspend_io(struct drbd_device *device)
 {
-	set_bit(SUSPEND_IO, &mdev->flags);
-	if (drbd_suspended(mdev))
+	set_bit(SUSPEND_IO, &device->flags);
+	if (drbd_suspended(device))
 		return;
-	wait_event(mdev->misc_wait, !atomic_read(&mdev->ap_bio_cnt));
+	wait_event(device->misc_wait, !atomic_read(&device->ap_bio_cnt));
 }
 
-void drbd_resume_io(struct drbd_device *mdev)
+void drbd_resume_io(struct drbd_device *device)
 {
-	clear_bit(SUSPEND_IO, &mdev->flags);
-	wake_up(&mdev->misc_wait);
+	clear_bit(SUSPEND_IO, &device->flags);
+	wake_up(&device->misc_wait);
 }
 
 /**
  * drbd_determine_dev_size() -  Sets the right device size obeying all constraints
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Returns 0 on success, negative return values indicate errors.
  * You should call drbd_md_sync() after calling this function.
  */
 enum determine_dev_size
-drbd_determine_dev_size(struct drbd_device *mdev, enum dds_flags flags, struct resize_parms *rs) __must_hold(local)
+drbd_determine_dev_size(struct drbd_device *device, enum dds_flags flags, struct resize_parms *rs) __must_hold(local)
 {
 	sector_t prev_first_sect, prev_size; /* previous meta location */
 	sector_t la_size_sect, u_size;
-	struct drbd_md *md = &mdev->ldev->md;
+	struct drbd_md *md = &device->ldev->md;
 	u32 prev_al_stripe_size_4k;
 	u32 prev_al_stripes;
 	sector_t size;
@@ -852,19 +852,19 @@ drbd_determine_dev_size(struct drbd_device *mdev, enum dds_flags flags, struct r
 	 * Suspend IO right here.
 	 * still lock the act_log to not trigger ASSERTs there.
 	 */
-	drbd_suspend_io(mdev);
-	buffer = drbd_md_get_buffer(mdev); /* Lock meta-data IO */
+	drbd_suspend_io(device);
+	buffer = drbd_md_get_buffer(device); /* Lock meta-data IO */
 	if (!buffer) {
-		drbd_resume_io(mdev);
+		drbd_resume_io(device);
 		return DS_ERROR;
 	}
 
 	/* no wait necessary anymore, actually we could assert that */
-	wait_event(mdev->al_wait, lc_try_lock(mdev->act_log));
+	wait_event(device->al_wait, lc_try_lock(device->act_log));
 
-	prev_first_sect = drbd_md_first_sector(mdev->ldev);
-	prev_size = mdev->ldev->md.md_size_sect;
-	la_size_sect = mdev->ldev->md.la_size_sect;
+	prev_first_sect = drbd_md_first_sector(device->ldev);
+	prev_size = device->ldev->md.md_size_sect;
+	la_size_sect = device->ldev->md.la_size_sect;
 
 	if (rs) {
 		/* rs is non NULL if we should change the AL layout only */
@@ -877,12 +877,12 @@ drbd_determine_dev_size(struct drbd_device *mdev, enum dds_flags flags, struct r
 		md->al_size_4k = (u64)rs->al_stripes * rs->al_stripe_size / 4;
 	}
 
-	drbd_md_set_sector_offsets(mdev, mdev->ldev);
+	drbd_md_set_sector_offsets(device, device->ldev);
 
 	rcu_read_lock();
-	u_size = rcu_dereference(mdev->ldev->disk_conf)->disk_size;
+	u_size = rcu_dereference(device->ldev->disk_conf)->disk_size;
 	rcu_read_unlock();
-	size = drbd_new_dev_size(mdev, mdev->ldev, u_size, flags & DDSF_FORCED);
+	size = drbd_new_dev_size(device, device->ldev, u_size, flags & DDSF_FORCED);
 
 	if (size < la_size_sect) {
 		if (rs && u_size == 0) {
@@ -899,13 +899,13 @@ drbd_determine_dev_size(struct drbd_device *mdev, enum dds_flags flags, struct r
 			goto err_out;
 	}
 
-	if (drbd_get_capacity(mdev->this_bdev) != size ||
-	    drbd_bm_capacity(mdev) != size) {
+	if (drbd_get_capacity(device->this_bdev) != size ||
+	    drbd_bm_capacity(device) != size) {
 		int err;
-		err = drbd_bm_resize(mdev, size, !(flags & DDSF_NO_RESYNC));
+		err = drbd_bm_resize(device, size, !(flags & DDSF_NO_RESYNC));
 		if (unlikely(err)) {
 			/* currently there is only one error: ENOMEM! */
-			size = drbd_bm_capacity(mdev)>>1;
+			size = drbd_bm_capacity(device)>>1;
 			if (size == 0) {
 				dev_err(DEV, "OUT OF MEMORY! "
 				    "Could not allocate bitmap!\n");
@@ -917,38 +917,38 @@ drbd_determine_dev_size(struct drbd_device *mdev, enum dds_flags flags, struct r
 			rv = DS_ERROR;
 		}
 		/* racy, see comments above. */
-		drbd_set_my_capacity(mdev, size);
-		mdev->ldev->md.la_size_sect = size;
+		drbd_set_my_capacity(device, size);
+		device->ldev->md.la_size_sect = size;
 		dev_info(DEV, "size = %s (%llu KB)\n", ppsize(ppb, size>>1),
 		     (unsigned long long)size>>1);
 	}
 	if (rv <= DS_ERROR)
 		goto err_out;
 
-	la_size_changed = (la_size_sect != mdev->ldev->md.la_size_sect);
+	la_size_changed = (la_size_sect != device->ldev->md.la_size_sect);
 
-	md_moved = prev_first_sect != drbd_md_first_sector(mdev->ldev)
-		|| prev_size	   != mdev->ldev->md.md_size_sect;
+	md_moved = prev_first_sect != drbd_md_first_sector(device->ldev)
+		|| prev_size	   != device->ldev->md.md_size_sect;
 
 	if (la_size_changed || md_moved || rs) {
 		u32 prev_flags;
 
-		drbd_al_shrink(mdev); /* All extents inactive. */
+		drbd_al_shrink(device); /* All extents inactive. */
 
 		prev_flags = md->flags;
 		md->flags &= ~MDF_PRIMARY_IND;
-		drbd_md_write(mdev, buffer);
+		drbd_md_write(device, buffer);
 
 		dev_info(DEV, "Writing the whole bitmap, %s\n",
 			 la_size_changed && md_moved ? "size changed and md moved" :
 			 la_size_changed ? "size changed" : "md moved");
 		/* next line implicitly does drbd_suspend_io()+drbd_resume_io() */
-		drbd_bitmap_io(mdev, md_moved ? &drbd_bm_write_all : &drbd_bm_write,
+		drbd_bitmap_io(device, md_moved ? &drbd_bm_write_all : &drbd_bm_write,
 			       "size changed", BM_LOCKED_MASK);
-		drbd_initialize_al(mdev, buffer);
+		drbd_initialize_al(device, buffer);
 
 		md->flags = prev_flags;
-		drbd_md_write(mdev, buffer);
+		drbd_md_write(device, buffer);
 
 		if (rs)
 			dev_info(DEV, "Changed AL layout to al-stripes = %d, al-stripe-size-kB = %d\n",
@@ -967,29 +967,29 @@ drbd_determine_dev_size(struct drbd_device *mdev, enum dds_flags flags, struct r
 			md->al_stripe_size_4k = prev_al_stripe_size_4k;
 			md->al_size_4k = (u64)prev_al_stripes * prev_al_stripe_size_4k;
 
-			drbd_md_set_sector_offsets(mdev, mdev->ldev);
+			drbd_md_set_sector_offsets(device, device->ldev);
 		}
 	}
-	lc_unlock(mdev->act_log);
-	wake_up(&mdev->al_wait);
-	drbd_md_put_buffer(mdev);
-	drbd_resume_io(mdev);
+	lc_unlock(device->act_log);
+	wake_up(&device->al_wait);
+	drbd_md_put_buffer(device);
+	drbd_resume_io(device);
 
 	return rv;
 }
 
 sector_t
-drbd_new_dev_size(struct drbd_device *mdev, struct drbd_backing_dev *bdev,
+drbd_new_dev_size(struct drbd_device *device, struct drbd_backing_dev *bdev,
 		  sector_t u_size, int assume_peer_has_space)
 {
-	sector_t p_size = mdev->p_size;   /* partner's disk size. */
+	sector_t p_size = device->p_size;   /* partner's disk size. */
 	sector_t la_size_sect = bdev->md.la_size_sect; /* last agreed size. */
 	sector_t m_size; /* my size */
 	sector_t size = 0;
 
 	m_size = drbd_get_max_capacity(bdev);
 
-	if (mdev->state.conn < C_CONNECTED && assume_peer_has_space) {
+	if (device->state.conn < C_CONNECTED && assume_peer_has_space) {
 		dev_warn(DEV, "Resize while not connected was forced by the user!\n");
 		p_size = m_size;
 	}
@@ -1027,25 +1027,25 @@ drbd_new_dev_size(struct drbd_device *mdev, struct drbd_backing_dev *bdev,
 
 /**
  * drbd_check_al_size() - Ensures that the AL is of the right size
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Returns -EBUSY if current al lru is still used, -ENOMEM when allocation
  * failed, and 0 on success. You should call drbd_md_sync() after you called
  * this function.
  */
-static int drbd_check_al_size(struct drbd_device *mdev, struct disk_conf *dc)
+static int drbd_check_al_size(struct drbd_device *device, struct disk_conf *dc)
 {
 	struct lru_cache *n, *t;
 	struct lc_element *e;
 	unsigned int in_use;
 	int i;
 
-	if (mdev->act_log &&
-	    mdev->act_log->nr_elements == dc->al_extents)
+	if (device->act_log &&
+	    device->act_log->nr_elements == dc->al_extents)
 		return 0;
 
 	in_use = 0;
-	t = mdev->act_log;
+	t = device->act_log;
 	n = lc_create("act_log", drbd_al_ext_cache, AL_UPDATES_PER_TRANSACTION,
 		dc->al_extents, sizeof(struct lc_element), 0);
 
@@ -1053,7 +1053,7 @@ static int drbd_check_al_size(struct drbd_device *mdev, struct disk_conf *dc)
 		dev_err(DEV, "Cannot allocate act_log lru!\n");
 		return -ENOMEM;
 	}
-	spin_lock_irq(&mdev->al_lock);
+	spin_lock_irq(&device->al_lock);
 	if (t) {
 		for (i = 0; i < t->nr_elements; i++) {
 			e = lc_element_by_index(t, i);
@@ -1064,8 +1064,8 @@ static int drbd_check_al_size(struct drbd_device *mdev, struct disk_conf *dc)
 		}
 	}
 	if (!in_use)
-		mdev->act_log = n;
-	spin_unlock_irq(&mdev->al_lock);
+		device->act_log = n;
+	spin_unlock_irq(&device->al_lock);
 	if (in_use) {
 		dev_err(DEV, "Activity log still in use!\n");
 		lc_destroy(n);
@@ -1074,24 +1074,24 @@ static int drbd_check_al_size(struct drbd_device *mdev, struct disk_conf *dc)
 		if (t)
 			lc_destroy(t);
 	}
-	drbd_md_mark_dirty(mdev); /* we changed mdev->act_log->nr_elemens */
+	drbd_md_mark_dirty(device); /* we changed device->act_log->nr_elemens */
 	return 0;
 }
 
-static void drbd_setup_queue_param(struct drbd_device *mdev, unsigned int max_bio_size)
+static void drbd_setup_queue_param(struct drbd_device *device, unsigned int max_bio_size)
 {
-	struct request_queue * const q = mdev->rq_queue;
+	struct request_queue * const q = device->rq_queue;
 	unsigned int max_hw_sectors = max_bio_size >> 9;
 	unsigned int max_segments = 0;
 
-	if (get_ldev_if_state(mdev, D_ATTACHING)) {
-		struct request_queue * const b = mdev->ldev->backing_bdev->bd_disk->queue;
+	if (get_ldev_if_state(device, D_ATTACHING)) {
+		struct request_queue * const b = device->ldev->backing_bdev->bd_disk->queue;
 
 		max_hw_sectors = min(queue_max_hw_sectors(b), max_bio_size >> 9);
 		rcu_read_lock();
-		max_segments = rcu_dereference(mdev->ldev->disk_conf)->max_bio_bvecs;
+		max_segments = rcu_dereference(device->ldev->disk_conf)->max_bio_bvecs;
 		rcu_read_unlock();
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 
 	blk_queue_logical_block_size(q, 512);
@@ -1100,8 +1100,8 @@ static void drbd_setup_queue_param(struct drbd_device *mdev, unsigned int max_bi
 	blk_queue_max_segments(q, max_segments ? max_segments : BLK_MAX_SEGMENTS);
 	blk_queue_segment_boundary(q, PAGE_CACHE_SIZE-1);
 
-	if (get_ldev_if_state(mdev, D_ATTACHING)) {
-		struct request_queue * const b = mdev->ldev->backing_bdev->bd_disk->queue;
+	if (get_ldev_if_state(device, D_ATTACHING)) {
+		struct request_queue * const b = device->ldev->backing_bdev->bd_disk->queue;
 
 		blk_queue_stack_limits(q, b);
 
@@ -1111,35 +1111,35 @@ static void drbd_setup_queue_param(struct drbd_device *mdev, unsigned int max_bi
 				 b->backing_dev_info.ra_pages);
 			q->backing_dev_info.ra_pages = b->backing_dev_info.ra_pages;
 		}
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 }
 
-void drbd_reconsider_max_bio_size(struct drbd_device *mdev)
+void drbd_reconsider_max_bio_size(struct drbd_device *device)
 {
 	unsigned int now, new, local, peer;
 
-	now = queue_max_hw_sectors(mdev->rq_queue) << 9;
-	local = mdev->local_max_bio_size; /* Eventually last known value, from volatile memory */
-	peer = mdev->peer_max_bio_size; /* Eventually last known value, from meta data */
+	now = queue_max_hw_sectors(device->rq_queue) << 9;
+	local = device->local_max_bio_size; /* Eventually last known value, from volatile memory */
+	peer = device->peer_max_bio_size; /* Eventually last known value, from meta data */
 
-	if (get_ldev_if_state(mdev, D_ATTACHING)) {
-		local = queue_max_hw_sectors(mdev->ldev->backing_bdev->bd_disk->queue) << 9;
-		mdev->local_max_bio_size = local;
-		put_ldev(mdev);
+	if (get_ldev_if_state(device, D_ATTACHING)) {
+		local = queue_max_hw_sectors(device->ldev->backing_bdev->bd_disk->queue) << 9;
+		device->local_max_bio_size = local;
+		put_ldev(device);
 	}
 	local = min(local, DRBD_MAX_BIO_SIZE);
 
 	/* We may ignore peer limits if the peer is modern enough.
 	   Because new from 8.3.8 onwards the peer can use multiple
 	   BIOs for a single peer_request */
-	if (mdev->state.conn >= C_WF_REPORT_PARAMS) {
-		if (mdev->tconn->agreed_pro_version < 94)
-			peer = min(mdev->peer_max_bio_size, DRBD_MAX_SIZE_H80_PACKET);
+	if (device->state.conn >= C_WF_REPORT_PARAMS) {
+		if (device->tconn->agreed_pro_version < 94)
+			peer = min(device->peer_max_bio_size, DRBD_MAX_SIZE_H80_PACKET);
 			/* Correct old drbd (up to 8.3.7) if it believes it can do more than 32KiB */
-		else if (mdev->tconn->agreed_pro_version == 94)
+		else if (device->tconn->agreed_pro_version == 94)
 			peer = DRBD_MAX_SIZE_H80_PACKET;
-		else if (mdev->tconn->agreed_pro_version < 100)
+		else if (device->tconn->agreed_pro_version < 100)
 			peer = DRBD_MAX_BIO_SIZE_P95;  /* drbd 8.3.8 onwards, before 8.4.0 */
 		else
 			peer = DRBD_MAX_BIO_SIZE;
@@ -1147,13 +1147,13 @@ void drbd_reconsider_max_bio_size(struct drbd_device *mdev)
 
 	new = min(local, peer);
 
-	if (mdev->state.role == R_PRIMARY && new < now)
+	if (device->state.role == R_PRIMARY && new < now)
 		dev_err(DEV, "ASSERT FAILED new < now; (%u < %u)\n", new, now);
 
 	if (new != now)
 		dev_info(DEV, "max BIO size = %u\n", new);
 
-	drbd_setup_queue_param(mdev, new);
+	drbd_setup_queue_param(device, new);
 }
 
 /* Starts the worker thread */
@@ -1180,21 +1180,21 @@ static void conn_reconfig_done(struct drbd_tconn *tconn)
 }
 
 /* Make sure IO is suspended before calling this function(). */
-static void drbd_suspend_al(struct drbd_device *mdev)
+static void drbd_suspend_al(struct drbd_device *device)
 {
 	int s = 0;
 
-	if (!lc_try_lock(mdev->act_log)) {
+	if (!lc_try_lock(device->act_log)) {
 		dev_warn(DEV, "Failed to lock al in drbd_suspend_al()\n");
 		return;
 	}
 
-	drbd_al_shrink(mdev);
-	spin_lock_irq(&mdev->tconn->req_lock);
-	if (mdev->state.conn < C_CONNECTED)
-		s = !test_and_set_bit(AL_SUSPENDED, &mdev->flags);
-	spin_unlock_irq(&mdev->tconn->req_lock);
-	lc_unlock(mdev->act_log);
+	drbd_al_shrink(device);
+	spin_lock_irq(&device->tconn->req_lock);
+	if (device->state.conn < C_CONNECTED)
+		s = !test_and_set_bit(AL_SUSPENDED, &device->flags);
+	spin_unlock_irq(&device->tconn->req_lock);
+	lc_unlock(device->act_log);
 
 	if (s)
 		dev_info(DEV, "Suspended AL updates\n");
@@ -1238,7 +1238,7 @@ static unsigned int drbd_al_extents_max(struct drbd_backing_dev *bdev)
 int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct disk_conf *new_disk_conf, *old_disk_conf;
 	struct fifo_buffer *old_plan = NULL, *new_plan = NULL;
 	int err, fifo_size;
@@ -1249,11 +1249,11 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	mdev = adm_ctx.mdev;
+	device = adm_ctx.device;
 
 	/* we also need a disk
 	 * to change the options on */
-	if (!get_ldev(mdev)) {
+	if (!get_ldev(device)) {
 		retcode = ERR_NO_DISK;
 		goto out;
 	}
@@ -1264,8 +1264,8 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	mutex_lock(&mdev->tconn->conf_update);
-	old_disk_conf = mdev->ldev->disk_conf;
+	mutex_lock(&device->tconn->conf_update);
+	old_disk_conf = device->ldev->disk_conf;
 	*new_disk_conf = *old_disk_conf;
 	if (should_set_defaults(info))
 		set_disk_conf_defaults(new_disk_conf);
@@ -1282,14 +1282,14 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 
 	if (new_disk_conf->al_extents < DRBD_AL_EXTENTS_MIN)
 		new_disk_conf->al_extents = DRBD_AL_EXTENTS_MIN;
-	if (new_disk_conf->al_extents > drbd_al_extents_max(mdev->ldev))
-		new_disk_conf->al_extents = drbd_al_extents_max(mdev->ldev);
+	if (new_disk_conf->al_extents > drbd_al_extents_max(device->ldev))
+		new_disk_conf->al_extents = drbd_al_extents_max(device->ldev);
 
 	if (new_disk_conf->c_plan_ahead > DRBD_C_PLAN_AHEAD_MAX)
 		new_disk_conf->c_plan_ahead = DRBD_C_PLAN_AHEAD_MAX;
 
 	fifo_size = (new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ;
-	if (fifo_size != mdev->rs_plan_s->size) {
+	if (fifo_size != device->rs_plan_s->size) {
 		new_plan = fifo_alloc(fifo_size);
 		if (!new_plan) {
 			dev_err(DEV, "kmalloc of fifo_buffer failed");
@@ -1298,13 +1298,13 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	drbd_suspend_io(mdev);
-	wait_event(mdev->al_wait, lc_try_lock(mdev->act_log));
-	drbd_al_shrink(mdev);
-	err = drbd_check_al_size(mdev, new_disk_conf);
-	lc_unlock(mdev->act_log);
-	wake_up(&mdev->al_wait);
-	drbd_resume_io(mdev);
+	drbd_suspend_io(device);
+	wait_event(device->al_wait, lc_try_lock(device->act_log));
+	drbd_al_shrink(device);
+	err = drbd_check_al_size(device, new_disk_conf);
+	lc_unlock(device->act_log);
+	wake_up(&device->al_wait);
+	drbd_resume_io(device);
 
 	if (err) {
 		retcode = ERR_NOMEM;
@@ -1312,10 +1312,10 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	write_lock_irq(&global_state_lock);
-	retcode = drbd_resync_after_valid(mdev, new_disk_conf->resync_after);
+	retcode = drbd_resync_after_valid(device, new_disk_conf->resync_after);
 	if (retcode == NO_ERROR) {
-		rcu_assign_pointer(mdev->ldev->disk_conf, new_disk_conf);
-		drbd_resync_after_changed(mdev);
+		rcu_assign_pointer(device->ldev->disk_conf, new_disk_conf);
+		drbd_resync_after_changed(device);
 	}
 	write_unlock_irq(&global_state_lock);
 
@@ -1323,42 +1323,42 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail_unlock;
 
 	if (new_plan) {
-		old_plan = mdev->rs_plan_s;
-		rcu_assign_pointer(mdev->rs_plan_s, new_plan);
+		old_plan = device->rs_plan_s;
+		rcu_assign_pointer(device->rs_plan_s, new_plan);
 	}
 
-	mutex_unlock(&mdev->tconn->conf_update);
+	mutex_unlock(&device->tconn->conf_update);
 
 	if (new_disk_conf->al_updates)
-		mdev->ldev->md.flags &= ~MDF_AL_DISABLED;
+		device->ldev->md.flags &= ~MDF_AL_DISABLED;
 	else
-		mdev->ldev->md.flags |= MDF_AL_DISABLED;
+		device->ldev->md.flags |= MDF_AL_DISABLED;
 
 	if (new_disk_conf->md_flushes)
-		clear_bit(MD_NO_FUA, &mdev->flags);
+		clear_bit(MD_NO_FUA, &device->flags);
 	else
-		set_bit(MD_NO_FUA, &mdev->flags);
+		set_bit(MD_NO_FUA, &device->flags);
 
-	drbd_bump_write_ordering(mdev->tconn, WO_bdev_flush);
+	drbd_bump_write_ordering(device->tconn, WO_bdev_flush);
 
-	drbd_md_sync(mdev);
+	drbd_md_sync(device);
 
-	if (mdev->state.conn >= C_CONNECTED)
-		drbd_send_sync_param(mdev);
+	if (device->state.conn >= C_CONNECTED)
+		drbd_send_sync_param(device);
 
 	synchronize_rcu();
 	kfree(old_disk_conf);
 	kfree(old_plan);
-	mod_timer(&mdev->request_timer, jiffies + HZ);
+	mod_timer(&device->request_timer, jiffies + HZ);
 	goto success;
 
 fail_unlock:
-	mutex_unlock(&mdev->tconn->conf_update);
+	mutex_unlock(&device->tconn->conf_update);
  fail:
 	kfree(new_disk_conf);
 	kfree(new_plan);
 success:
-	put_ldev(mdev);
+	put_ldev(device);
  out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -1366,7 +1366,7 @@ success:
 
 int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int err;
 	enum drbd_ret_code retcode;
 	enum determine_dev_size dd;
@@ -1387,11 +1387,11 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto finish;
 
-	mdev = adm_ctx.mdev;
-	conn_reconfig_start(mdev->tconn);
+	device = adm_ctx.device;
+	conn_reconfig_start(device->tconn);
 
 	/* if you want to reconfigure, please tear down first */
-	if (mdev->state.disk > D_DISKLESS) {
+	if (device->state.disk > D_DISKLESS) {
 		retcode = ERR_DISK_CONFIGURED;
 		goto fail;
 	}
@@ -1399,17 +1399,17 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	 * drbd_ldev_destroy is done already, we may end up here very fast,
 	 * e.g. if someone calls attach from the on-io-error handler,
 	 * to realize a "hot spare" feature (not that I'd recommend that) */
-	wait_event(mdev->misc_wait, !atomic_read(&mdev->local_cnt));
+	wait_event(device->misc_wait, !atomic_read(&device->local_cnt));
 
 	/* make sure there is no leftover from previous force-detach attempts */
-	clear_bit(FORCE_DETACH, &mdev->flags);
-	clear_bit(WAS_IO_ERROR, &mdev->flags);
-	clear_bit(WAS_READ_ERROR, &mdev->flags);
+	clear_bit(FORCE_DETACH, &device->flags);
+	clear_bit(WAS_IO_ERROR, &device->flags);
+	clear_bit(WAS_READ_ERROR, &device->flags);
 
 	/* and no leftover from previously aborted resync or verify, either */
-	mdev->rs_total = 0;
-	mdev->rs_failed = 0;
-	atomic_set(&mdev->rs_pending_cnt, 0);
+	device->rs_total = 0;
+	device->rs_failed = 0;
+	atomic_set(&device->rs_pending_cnt, 0);
 
 	/* allocation not in the IO path, drbdsetup context */
 	nbc = kzalloc(sizeof(struct drbd_backing_dev), GFP_KERNEL);
@@ -1449,13 +1449,13 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	write_lock_irq(&global_state_lock);
-	retcode = drbd_resync_after_valid(mdev, new_disk_conf->resync_after);
+	retcode = drbd_resync_after_valid(device, new_disk_conf->resync_after);
 	write_unlock_irq(&global_state_lock);
 	if (retcode != NO_ERROR)
 		goto fail;
 
 	rcu_read_lock();
-	nc = rcu_dereference(mdev->tconn->net_conf);
+	nc = rcu_dereference(device->tconn->net_conf);
 	if (nc) {
 		if (new_disk_conf->fencing == FP_STONITH && nc->wire_protocol == DRBD_PROT_A) {
 			rcu_read_unlock();
@@ -1466,7 +1466,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	rcu_read_unlock();
 
 	bdev = blkdev_get_by_path(new_disk_conf->backing_dev,
-				  FMODE_READ | FMODE_WRITE | FMODE_EXCL, mdev);
+				  FMODE_READ | FMODE_WRITE | FMODE_EXCL, device);
 	if (IS_ERR(bdev)) {
 		dev_err(DEV, "open(\"%s\") failed with %ld\n", new_disk_conf->backing_dev,
 			PTR_ERR(bdev));
@@ -1486,7 +1486,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	bdev = blkdev_get_by_path(new_disk_conf->meta_dev,
 				  FMODE_READ | FMODE_WRITE | FMODE_EXCL,
 				  (new_disk_conf->meta_dev_idx < 0) ?
-				  (void *)mdev : (void *)drbd_m_holder);
+				  (void *)device : (void *)drbd_m_holder);
 	if (IS_ERR(bdev)) {
 		dev_err(DEV, "open(\"%s\") failed with %ld\n", new_disk_conf->meta_dev,
 			PTR_ERR(bdev));
@@ -1512,7 +1512,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 
 	/* Read our meta data super block early.
 	 * This also sets other on-disk offsets. */
-	retcode = drbd_md_read(mdev, nbc);
+	retcode = drbd_md_read(device, nbc);
 	if (retcode != NO_ERROR)
 		goto fail;
 
@@ -1549,7 +1549,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	/* Make sure the new disk is big enough
 	 * (we may currently be R_PRIMARY with no local disk...) */
 	if (drbd_get_max_capacity(nbc) <
-	    drbd_get_capacity(mdev->this_bdev)) {
+	    drbd_get_capacity(device->this_bdev)) {
 		retcode = ERR_DISK_TOO_SMALL;
 		goto fail;
 	}
@@ -1565,7 +1565,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 				      "meta data may help <<==\n");
 	}
 
-	drbd_suspend_io(mdev);
+	drbd_suspend_io(device);
 	/* also wait for the last barrier ack. */
 	/* FIXME see also https://daiquiri.linbit/cgi-bin/bugzilla/show_bug.cgi?id=171
 	 * We need a way to either ignore barrier acks for barriers sent before a device
@@ -1573,44 +1573,44 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	 * As barriers are counted per resource,
 	 * we'd need to suspend io on all devices of a resource.
 	 */
-	wait_event(mdev->misc_wait, !atomic_read(&mdev->ap_pending_cnt) || drbd_suspended(mdev));
+	wait_event(device->misc_wait, !atomic_read(&device->ap_pending_cnt) || drbd_suspended(device));
 	/* and for any other previously queued work */
-	drbd_flush_workqueue(mdev);
+	drbd_flush_workqueue(device);
 
-	rv = _drbd_request_state(mdev, NS(disk, D_ATTACHING), CS_VERBOSE);
+	rv = _drbd_request_state(device, NS(disk, D_ATTACHING), CS_VERBOSE);
 	retcode = rv;  /* FIXME: Type mismatch. */
-	drbd_resume_io(mdev);
+	drbd_resume_io(device);
 	if (rv < SS_SUCCESS)
 		goto fail;
 
-	if (!get_ldev_if_state(mdev, D_ATTACHING))
+	if (!get_ldev_if_state(device, D_ATTACHING))
 		goto force_diskless;
 
-	if (!mdev->bitmap) {
-		if (drbd_bm_init(mdev)) {
+	if (!device->bitmap) {
+		if (drbd_bm_init(device)) {
 			retcode = ERR_NOMEM;
 			goto force_diskless_dec;
 		}
 	}
 
-	if (mdev->state.conn < C_CONNECTED &&
-	    mdev->state.role == R_PRIMARY &&
-	    (mdev->ed_uuid & ~((u64)1)) != (nbc->md.uuid[UI_CURRENT] & ~((u64)1))) {
+	if (device->state.conn < C_CONNECTED &&
+	    device->state.role == R_PRIMARY &&
+	    (device->ed_uuid & ~((u64)1)) != (nbc->md.uuid[UI_CURRENT] & ~((u64)1))) {
 		dev_err(DEV, "Can only attach to data with current UUID=%016llX\n",
-		    (unsigned long long)mdev->ed_uuid);
+		    (unsigned long long)device->ed_uuid);
 		retcode = ERR_DATA_NOT_CURRENT;
 		goto force_diskless_dec;
 	}
 
 	/* Since we are diskless, fix the activity log first... */
-	if (drbd_check_al_size(mdev, new_disk_conf)) {
+	if (drbd_check_al_size(device, new_disk_conf)) {
 		retcode = ERR_NOMEM;
 		goto force_diskless_dec;
 	}
 
 	/* Prevent shrinking of consistent devices ! */
 	if (drbd_md_test_flag(nbc, MDF_CONSISTENT) &&
-	    drbd_new_dev_size(mdev, nbc, nbc->disk_conf->disk_size, 0) < nbc->md.la_size_sect) {
+	    drbd_new_dev_size(device, nbc, nbc->disk_conf->disk_size, 0) < nbc->md.la_size_sect) {
 		dev_warn(DEV, "refusing to truncate a consistent device\n");
 		retcode = ERR_DISK_TOO_SMALL;
 		goto force_diskless_dec;
@@ -1619,40 +1619,40 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	/* Reset the "barriers don't work" bits here, then force meta data to
 	 * be written, to ensure we determine if barriers are supported. */
 	if (new_disk_conf->md_flushes)
-		clear_bit(MD_NO_FUA, &mdev->flags);
+		clear_bit(MD_NO_FUA, &device->flags);
 	else
-		set_bit(MD_NO_FUA, &mdev->flags);
+		set_bit(MD_NO_FUA, &device->flags);
 
 	/* Point of no return reached.
 	 * Devices and memory are no longer released by error cleanup below.
-	 * now mdev takes over responsibility, and the state engine should
+	 * now device takes over responsibility, and the state engine should
 	 * clean it up somewhere.  */
-	D_ASSERT(mdev->ldev == NULL);
-	mdev->ldev = nbc;
-	mdev->resync = resync_lru;
-	mdev->rs_plan_s = new_plan;
+	D_ASSERT(device->ldev == NULL);
+	device->ldev = nbc;
+	device->resync = resync_lru;
+	device->rs_plan_s = new_plan;
 	nbc = NULL;
 	resync_lru = NULL;
 	new_disk_conf = NULL;
 	new_plan = NULL;
 
-	drbd_bump_write_ordering(mdev->tconn, WO_bdev_flush);
+	drbd_bump_write_ordering(device->tconn, WO_bdev_flush);
 
-	if (drbd_md_test_flag(mdev->ldev, MDF_CRASHED_PRIMARY))
-		set_bit(CRASHED_PRIMARY, &mdev->flags);
+	if (drbd_md_test_flag(device->ldev, MDF_CRASHED_PRIMARY))
+		set_bit(CRASHED_PRIMARY, &device->flags);
 	else
-		clear_bit(CRASHED_PRIMARY, &mdev->flags);
+		clear_bit(CRASHED_PRIMARY, &device->flags);
 
-	if (drbd_md_test_flag(mdev->ldev, MDF_PRIMARY_IND) &&
-	    !(mdev->state.role == R_PRIMARY && mdev->tconn->susp_nod))
-		set_bit(CRASHED_PRIMARY, &mdev->flags);
+	if (drbd_md_test_flag(device->ldev, MDF_PRIMARY_IND) &&
+	    !(device->state.role == R_PRIMARY && device->tconn->susp_nod))
+		set_bit(CRASHED_PRIMARY, &device->flags);
 
-	mdev->send_cnt = 0;
-	mdev->recv_cnt = 0;
-	mdev->read_cnt = 0;
-	mdev->writ_cnt = 0;
+	device->send_cnt = 0;
+	device->recv_cnt = 0;
+	device->read_cnt = 0;
+	device->writ_cnt = 0;
 
-	drbd_reconsider_max_bio_size(mdev);
+	drbd_reconsider_max_bio_size(device);
 
 	/* If I am currently not R_PRIMARY,
 	 * but meta data primary indicator is set,
@@ -1668,50 +1668,50 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	 * so we can automatically recover from a crash of a
 	 * degraded but active "cluster" after a certain timeout.
 	 */
-	clear_bit(USE_DEGR_WFC_T, &mdev->flags);
-	if (mdev->state.role != R_PRIMARY &&
-	     drbd_md_test_flag(mdev->ldev, MDF_PRIMARY_IND) &&
-	    !drbd_md_test_flag(mdev->ldev, MDF_CONNECTED_IND))
-		set_bit(USE_DEGR_WFC_T, &mdev->flags);
+	clear_bit(USE_DEGR_WFC_T, &device->flags);
+	if (device->state.role != R_PRIMARY &&
+	     drbd_md_test_flag(device->ldev, MDF_PRIMARY_IND) &&
+	    !drbd_md_test_flag(device->ldev, MDF_CONNECTED_IND))
+		set_bit(USE_DEGR_WFC_T, &device->flags);
 
-	dd = drbd_determine_dev_size(mdev, 0, NULL);
+	dd = drbd_determine_dev_size(device, 0, NULL);
 	if (dd <= DS_ERROR) {
 		retcode = ERR_NOMEM_BITMAP;
 		goto force_diskless_dec;
 	} else if (dd == DS_GREW)
-		set_bit(RESYNC_AFTER_NEG, &mdev->flags);
+		set_bit(RESYNC_AFTER_NEG, &device->flags);
 
-	if (drbd_md_test_flag(mdev->ldev, MDF_FULL_SYNC) ||
-	    (test_bit(CRASHED_PRIMARY, &mdev->flags) &&
-	     drbd_md_test_flag(mdev->ldev, MDF_AL_DISABLED))) {
+	if (drbd_md_test_flag(device->ldev, MDF_FULL_SYNC) ||
+	    (test_bit(CRASHED_PRIMARY, &device->flags) &&
+	     drbd_md_test_flag(device->ldev, MDF_AL_DISABLED))) {
 		dev_info(DEV, "Assuming that all blocks are out of sync "
 		     "(aka FullSync)\n");
-		if (drbd_bitmap_io(mdev, &drbd_bmio_set_n_write,
+		if (drbd_bitmap_io(device, &drbd_bmio_set_n_write,
 			"set_n_write from attaching", BM_LOCKED_MASK)) {
 			retcode = ERR_IO_MD_DISK;
 			goto force_diskless_dec;
 		}
 	} else {
-		if (drbd_bitmap_io(mdev, &drbd_bm_read,
+		if (drbd_bitmap_io(device, &drbd_bm_read,
 			"read from attaching", BM_LOCKED_MASK)) {
 			retcode = ERR_IO_MD_DISK;
 			goto force_diskless_dec;
 		}
 	}
 
-	if (_drbd_bm_total_weight(mdev) == drbd_bm_bits(mdev))
-		drbd_suspend_al(mdev); /* IO is still suspended here... */
+	if (_drbd_bm_total_weight(device) == drbd_bm_bits(device))
+		drbd_suspend_al(device); /* IO is still suspended here... */
 
-	spin_lock_irq(&mdev->tconn->req_lock);
-	os = drbd_read_state(mdev);
+	spin_lock_irq(&device->tconn->req_lock);
+	os = drbd_read_state(device);
 	ns = os;
 	/* If MDF_CONSISTENT is not set go into inconsistent state,
 	   otherwise investigate MDF_WasUpToDate...
 	   If MDF_WAS_UP_TO_DATE is not set go into D_OUTDATED disk state,
 	   otherwise into D_CONSISTENT state.
 	*/
-	if (drbd_md_test_flag(mdev->ldev, MDF_CONSISTENT)) {
-		if (drbd_md_test_flag(mdev->ldev, MDF_WAS_UP_TO_DATE))
+	if (drbd_md_test_flag(device->ldev, MDF_CONSISTENT)) {
+		if (drbd_md_test_flag(device->ldev, MDF_WAS_UP_TO_DATE))
 			ns.disk = D_CONSISTENT;
 		else
 			ns.disk = D_OUTDATED;
@@ -1719,12 +1719,12 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		ns.disk = D_INCONSISTENT;
 	}
 
-	if (drbd_md_test_flag(mdev->ldev, MDF_PEER_OUT_DATED))
+	if (drbd_md_test_flag(device->ldev, MDF_PEER_OUT_DATED))
 		ns.pdsk = D_OUTDATED;
 
 	rcu_read_lock();
 	if (ns.disk == D_CONSISTENT &&
-	    (ns.pdsk == D_OUTDATED || rcu_dereference(mdev->ldev->disk_conf)->fencing == FP_DONT_CARE))
+	    (ns.pdsk == D_OUTDATED || rcu_dereference(device->ldev->disk_conf)->fencing == FP_DONT_CARE))
 		ns.disk = D_UP_TO_DATE;
 
 	/* All tests on MDF_PRIMARY_IND, MDF_CONNECTED_IND,
@@ -1732,56 +1732,56 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	   this point, because drbd_request_state() modifies these
 	   flags. */
 
-	if (rcu_dereference(mdev->ldev->disk_conf)->al_updates)
-		mdev->ldev->md.flags &= ~MDF_AL_DISABLED;
+	if (rcu_dereference(device->ldev->disk_conf)->al_updates)
+		device->ldev->md.flags &= ~MDF_AL_DISABLED;
 	else
-		mdev->ldev->md.flags |= MDF_AL_DISABLED;
+		device->ldev->md.flags |= MDF_AL_DISABLED;
 
 	rcu_read_unlock();
 
 	/* In case we are C_CONNECTED postpone any decision on the new disk
 	   state after the negotiation phase. */
-	if (mdev->state.conn == C_CONNECTED) {
-		mdev->new_state_tmp.i = ns.i;
+	if (device->state.conn == C_CONNECTED) {
+		device->new_state_tmp.i = ns.i;
 		ns.i = os.i;
 		ns.disk = D_NEGOTIATING;
 
 		/* We expect to receive up-to-date UUIDs soon.
 		   To avoid a race in receive_state, free p_uuid while
 		   holding req_lock. I.e. atomic with the state change */
-		kfree(mdev->p_uuid);
-		mdev->p_uuid = NULL;
+		kfree(device->p_uuid);
+		device->p_uuid = NULL;
 	}
 
-	rv = _drbd_set_state(mdev, ns, CS_VERBOSE, NULL);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	rv = _drbd_set_state(device, ns, CS_VERBOSE, NULL);
+	spin_unlock_irq(&device->tconn->req_lock);
 
 	if (rv < SS_SUCCESS)
 		goto force_diskless_dec;
 
-	mod_timer(&mdev->request_timer, jiffies + HZ);
+	mod_timer(&device->request_timer, jiffies + HZ);
 
-	if (mdev->state.role == R_PRIMARY)
-		mdev->ldev->md.uuid[UI_CURRENT] |=  (u64)1;
+	if (device->state.role == R_PRIMARY)
+		device->ldev->md.uuid[UI_CURRENT] |=  (u64)1;
 	else
-		mdev->ldev->md.uuid[UI_CURRENT] &= ~(u64)1;
+		device->ldev->md.uuid[UI_CURRENT] &= ~(u64)1;
 
-	drbd_md_mark_dirty(mdev);
-	drbd_md_sync(mdev);
+	drbd_md_mark_dirty(device);
+	drbd_md_sync(device);
 
-	kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
-	put_ldev(mdev);
-	conn_reconfig_done(mdev->tconn);
+	kobject_uevent(&disk_to_dev(device->vdisk)->kobj, KOBJ_CHANGE);
+	put_ldev(device);
+	conn_reconfig_done(device->tconn);
 	drbd_adm_finish(info, retcode);
 	return 0;
 
  force_diskless_dec:
-	put_ldev(mdev);
+	put_ldev(device);
  force_diskless:
-	drbd_force_state(mdev, NS(disk, D_DISKLESS));
-	drbd_md_sync(mdev);
+	drbd_force_state(device, NS(disk, D_DISKLESS));
+	drbd_md_sync(device);
  fail:
-	conn_reconfig_done(mdev->tconn);
+	conn_reconfig_done(device->tconn);
 	if (nbc) {
 		if (nbc->backing_bdev)
 			blkdev_put(nbc->backing_bdev,
@@ -1800,26 +1800,26 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-static int adm_detach(struct drbd_device *mdev, int force)
+static int adm_detach(struct drbd_device *device, int force)
 {
 	enum drbd_state_rv retcode;
 	int ret;
 
 	if (force) {
-		set_bit(FORCE_DETACH, &mdev->flags);
-		drbd_force_state(mdev, NS(disk, D_FAILED));
+		set_bit(FORCE_DETACH, &device->flags);
+		drbd_force_state(device, NS(disk, D_FAILED));
 		retcode = SS_SUCCESS;
 		goto out;
 	}
 
-	drbd_suspend_io(mdev); /* so no-one is stuck in drbd_al_begin_io */
-	drbd_md_get_buffer(mdev); /* make sure there is no in-flight meta-data IO */
-	retcode = drbd_request_state(mdev, NS(disk, D_FAILED));
-	drbd_md_put_buffer(mdev);
+	drbd_suspend_io(device); /* so no-one is stuck in drbd_al_begin_io */
+	drbd_md_get_buffer(device); /* make sure there is no in-flight meta-data IO */
+	retcode = drbd_request_state(device, NS(disk, D_FAILED));
+	drbd_md_put_buffer(device);
 	/* D_FAILED will transition to DISKLESS. */
-	ret = wait_event_interruptible(mdev->misc_wait,
-			mdev->state.disk != D_FAILED);
-	drbd_resume_io(mdev);
+	ret = wait_event_interruptible(device->misc_wait,
+			device->state.disk != D_FAILED);
+	drbd_resume_io(device);
 	if ((int)retcode == (int)SS_IS_DISKLESS)
 		retcode = SS_NOTHING_TO_DO;
 	if (ret)
@@ -1854,7 +1854,7 @@ int drbd_adm_detach(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	retcode = adm_detach(adm_ctx.mdev, parms.force_detach);
+	retcode = adm_detach(adm_ctx.device, parms.force_detach);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -1862,16 +1862,16 @@ out:
 
 static bool conn_resync_running(struct drbd_tconn *tconn)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	bool rv = false;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		if (mdev->state.conn == C_SYNC_SOURCE ||
-		    mdev->state.conn == C_SYNC_TARGET ||
-		    mdev->state.conn == C_PAUSED_SYNC_S ||
-		    mdev->state.conn == C_PAUSED_SYNC_T) {
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
+		if (device->state.conn == C_SYNC_SOURCE ||
+		    device->state.conn == C_SYNC_TARGET ||
+		    device->state.conn == C_PAUSED_SYNC_S ||
+		    device->state.conn == C_PAUSED_SYNC_T) {
 			rv = true;
 			break;
 		}
@@ -1883,14 +1883,14 @@ static bool conn_resync_running(struct drbd_tconn *tconn)
 
 static bool conn_ov_running(struct drbd_tconn *tconn)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	bool rv = false;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		if (mdev->state.conn == C_VERIFY_S ||
-		    mdev->state.conn == C_VERIFY_T) {
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
+		if (device->state.conn == C_VERIFY_S ||
+		    device->state.conn == C_VERIFY_T) {
 			rv = true;
 			break;
 		}
@@ -1903,7 +1903,7 @@ static bool conn_ov_running(struct drbd_tconn *tconn)
 static enum drbd_ret_code
 _check_net_options(struct drbd_tconn *tconn, struct net_conf *old_conf, struct net_conf *new_conf)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int i;
 
 	if (old_conf && tconn->cstate == C_WF_REPORT_PARAMS && tconn->agreed_pro_version < 100) {
@@ -1926,14 +1926,14 @@ _check_net_options(struct drbd_tconn *tconn, struct net_conf *old_conf, struct n
 	    (new_conf->wire_protocol != DRBD_PROT_C))
 		return ERR_NOT_PROTO_C;
 
-	idr_for_each_entry(&tconn->volumes, mdev, i) {
-		if (get_ldev(mdev)) {
-			enum drbd_fencing_p fp = rcu_dereference(mdev->ldev->disk_conf)->fencing;
-			put_ldev(mdev);
+	idr_for_each_entry(&tconn->volumes, device, i) {
+		if (get_ldev(device)) {
+			enum drbd_fencing_p fp = rcu_dereference(device->ldev->disk_conf)->fencing;
+			put_ldev(device);
 			if (new_conf->wire_protocol == DRBD_PROT_A && fp == FP_STONITH)
 				return ERR_STONITH_AND_PROT_A;
 		}
-		if (mdev->state.role == R_PRIMARY && new_conf->discard_my_data)
+		if (device->state.role == R_PRIMARY && new_conf->discard_my_data)
 			return ERR_DISCARD_IMPOSSIBLE;
 	}
 
@@ -1947,7 +1947,7 @@ static enum drbd_ret_code
 check_net_options(struct drbd_tconn *tconn, struct net_conf *new_conf)
 {
 	static enum drbd_ret_code rv;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int i;
 
 	rcu_read_lock();
@@ -1955,9 +1955,9 @@ check_net_options(struct drbd_tconn *tconn, struct net_conf *new_conf)
 	rcu_read_unlock();
 
 	/* tconn->volumes protected by genl_lock() here */
-	idr_for_each_entry(&tconn->volumes, mdev, i) {
-		if (!mdev->bitmap) {
-			if(drbd_bm_init(mdev))
+	idr_for_each_entry(&tconn->volumes, device, i) {
+		if (!device->bitmap) {
+			if (drbd_bm_init(device))
 				return ERR_NOMEM;
 		}
 	}
@@ -2121,7 +2121,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	kfree(old_conf);
 
 	if (tconn->cstate >= C_WF_REPORT_PARAMS)
-		drbd_send_sync_param(minor_to_mdev(conn_lowest_minor(tconn)));
+		drbd_send_sync_param(minor_to_device(conn_lowest_minor(tconn)));
 
 	goto done;
 
@@ -2139,7 +2139,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct net_conf *old_conf, *new_conf = NULL;
 	struct crypto crypto = { };
 	struct drbd_tconn *tconn;
@@ -2235,9 +2235,9 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	mutex_unlock(&tconn->conf_update);
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, i) {
-		mdev->send_cnt = 0;
-		mdev->recv_cnt = 0;
+	idr_for_each_entry(&tconn->volumes, device, i) {
+		device->send_cnt = 0;
+		device->recv_cnt = 0;
 	}
 	rcu_read_unlock();
 
@@ -2349,27 +2349,27 @@ int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-void resync_after_online_grow(struct drbd_device *mdev)
+void resync_after_online_grow(struct drbd_device *device)
 {
 	int iass; /* I am sync source */
 
 	dev_info(DEV, "Resync of new storage after online grow\n");
-	if (mdev->state.role != mdev->state.peer)
-		iass = (mdev->state.role == R_PRIMARY);
+	if (device->state.role != device->state.peer)
+		iass = (device->state.role == R_PRIMARY);
 	else
-		iass = test_bit(RESOLVE_CONFLICTS, &mdev->tconn->flags);
+		iass = test_bit(RESOLVE_CONFLICTS, &device->tconn->flags);
 
 	if (iass)
-		drbd_start_resync(mdev, C_SYNC_SOURCE);
+		drbd_start_resync(device, C_SYNC_SOURCE);
 	else
-		_drbd_request_state(mdev, NS(conn, C_WF_SYNC_UUID), CS_VERBOSE + CS_SERIALIZE);
+		_drbd_request_state(device, NS(conn, C_WF_SYNC_UUID), CS_VERBOSE + CS_SERIALIZE);
 }
 
 int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 {
 	struct disk_conf *old_disk_conf, *new_disk_conf = NULL;
 	struct resize_parms rs;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	enum drbd_ret_code retcode;
 	enum determine_dev_size dd;
 	bool change_al_layout = false;
@@ -2383,15 +2383,15 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto fail;
 
-	mdev = adm_ctx.mdev;
-	if (!get_ldev(mdev)) {
+	device = adm_ctx.device;
+	if (!get_ldev(device)) {
 		retcode = ERR_NO_DISK;
 		goto fail;
 	}
 
 	memset(&rs, 0, sizeof(struct resize_parms));
-	rs.al_stripes = mdev->ldev->md.al_stripes;
-	rs.al_stripe_size = mdev->ldev->md.al_stripe_size_4k * 4;
+	rs.al_stripes = device->ldev->md.al_stripes;
+	rs.al_stripe_size = device->ldev->md.al_stripe_size_4k * 4;
 	if (info->attrs[DRBD_NLA_RESIZE_PARMS]) {
 		err = resize_parms_from_attrs(&rs, info);
 		if (err) {
@@ -2401,24 +2401,24 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	if (mdev->state.conn > C_CONNECTED) {
+	if (device->state.conn > C_CONNECTED) {
 		retcode = ERR_RESIZE_RESYNC;
 		goto fail_ldev;
 	}
 
-	if (mdev->state.role == R_SECONDARY &&
-	    mdev->state.peer == R_SECONDARY) {
+	if (device->state.role == R_SECONDARY &&
+	    device->state.peer == R_SECONDARY) {
 		retcode = ERR_NO_PRIMARY;
 		goto fail_ldev;
 	}
 
-	if (rs.no_resync && mdev->tconn->agreed_pro_version < 93) {
+	if (rs.no_resync && device->tconn->agreed_pro_version < 93) {
 		retcode = ERR_NEED_APV_93;
 		goto fail_ldev;
 	}
 
 	rcu_read_lock();
-	u_size = rcu_dereference(mdev->ldev->disk_conf)->disk_size;
+	u_size = rcu_dereference(device->ldev->disk_conf)->disk_size;
 	rcu_read_unlock();
 	if (u_size != (sector_t)rs.resize_size) {
 		new_disk_conf = kmalloc(sizeof(struct disk_conf), GFP_KERNEL);
@@ -2428,8 +2428,8 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	if (mdev->ldev->md.al_stripes != rs.al_stripes ||
-	    mdev->ldev->md.al_stripe_size_4k != rs.al_stripe_size / 4) {
+	if (device->ldev->md.al_stripes != rs.al_stripes ||
+	    device->ldev->md.al_stripe_size_4k != rs.al_stripe_size / 4) {
 		u32 al_size_k = rs.al_stripes * rs.al_stripe_size;
 
 		if (al_size_k > (16 * 1024 * 1024)) {
@@ -2442,7 +2442,7 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 			goto fail_ldev;
 		}
 
-		if (mdev->state.conn != C_CONNECTED) {
+		if (device->state.conn != C_CONNECTED) {
 			retcode = ERR_MD_LAYOUT_CONNECTED;
 			goto fail_ldev;
 		}
@@ -2450,24 +2450,24 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 		change_al_layout = true;
 	}
 
-	if (mdev->ldev->known_size != drbd_get_capacity(mdev->ldev->backing_bdev))
-		mdev->ldev->known_size = drbd_get_capacity(mdev->ldev->backing_bdev);
+	if (device->ldev->known_size != drbd_get_capacity(device->ldev->backing_bdev))
+		device->ldev->known_size = drbd_get_capacity(device->ldev->backing_bdev);
 
 	if (new_disk_conf) {
-		mutex_lock(&mdev->tconn->conf_update);
-		old_disk_conf = mdev->ldev->disk_conf;
+		mutex_lock(&device->tconn->conf_update);
+		old_disk_conf = device->ldev->disk_conf;
 		*new_disk_conf = *old_disk_conf;
 		new_disk_conf->disk_size = (sector_t)rs.resize_size;
-		rcu_assign_pointer(mdev->ldev->disk_conf, new_disk_conf);
-		mutex_unlock(&mdev->tconn->conf_update);
+		rcu_assign_pointer(device->ldev->disk_conf, new_disk_conf);
+		mutex_unlock(&device->tconn->conf_update);
 		synchronize_rcu();
 		kfree(old_disk_conf);
 	}
 
 	ddsf = (rs.resize_force ? DDSF_FORCED : 0) | (rs.no_resync ? DDSF_NO_RESYNC : 0);
-	dd = drbd_determine_dev_size(mdev, ddsf, change_al_layout ? &rs : NULL);
-	drbd_md_sync(mdev);
-	put_ldev(mdev);
+	dd = drbd_determine_dev_size(device, ddsf, change_al_layout ? &rs : NULL);
+	drbd_md_sync(device);
+	put_ldev(device);
 	if (dd == DS_ERROR) {
 		retcode = ERR_NOMEM_BITMAP;
 		goto fail;
@@ -2479,12 +2479,12 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	if (mdev->state.conn == C_CONNECTED) {
+	if (device->state.conn == C_CONNECTED) {
 		if (dd == DS_GREW)
-			set_bit(RESIZE_PENDING, &mdev->flags);
+			set_bit(RESIZE_PENDING, &device->flags);
 
-		drbd_send_uuids(mdev);
-		drbd_send_sizes(mdev, 1, ddsf);
+		drbd_send_uuids(device);
+		drbd_send_sizes(device, 1, ddsf);
 	}
 
  fail:
@@ -2492,7 +2492,7 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
  fail_ldev:
-	put_ldev(mdev);
+	put_ldev(device);
 	goto fail;
 }
 
@@ -2535,7 +2535,7 @@ fail:
 
 int drbd_adm_invalidate(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int retcode; /* enum drbd_ret_code rsp. enum drbd_state_rv */
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
@@ -2544,29 +2544,29 @@ int drbd_adm_invalidate(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	mdev = adm_ctx.mdev;
+	device = adm_ctx.device;
 
 	/* If there is still bitmap IO pending, probably because of a previous
 	 * resync just being finished, wait for it before requesting a new resync.
 	 * Also wait for it's after_state_ch(). */
-	drbd_suspend_io(mdev);
-	wait_event(mdev->misc_wait, !test_bit(BITMAP_IO, &mdev->flags));
-	drbd_flush_workqueue(mdev);
+	drbd_suspend_io(device);
+	wait_event(device->misc_wait, !test_bit(BITMAP_IO, &device->flags));
+	drbd_flush_workqueue(device);
 
 	/* If we happen to be C_STANDALONE R_SECONDARY, just change to
 	 * D_INCONSISTENT, and set all bits in the bitmap.  Otherwise,
 	 * try to start a resync handshake as sync target for full sync.
 	 */
-	if (mdev->state.conn == C_STANDALONE && mdev->state.role == R_SECONDARY) {
-		retcode = drbd_request_state(mdev, NS(disk, D_INCONSISTENT));
+	if (device->state.conn == C_STANDALONE && device->state.role == R_SECONDARY) {
+		retcode = drbd_request_state(device, NS(disk, D_INCONSISTENT));
 		if (retcode >= SS_SUCCESS) {
-			if (drbd_bitmap_io(mdev, &drbd_bmio_set_n_write,
+			if (drbd_bitmap_io(device, &drbd_bmio_set_n_write,
 				"set_n_write from invalidate", BM_LOCKED_MASK))
 				retcode = ERR_IO_MD_DISK;
 		}
 	} else
-		retcode = drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_T));
-	drbd_resume_io(mdev);
+		retcode = drbd_request_state(device, NS(conn, C_STARTING_SYNC_T));
+	drbd_resume_io(device);
 
 out:
 	drbd_adm_finish(info, retcode);
@@ -2584,25 +2584,25 @@ static int drbd_adm_simple_request_state(struct sk_buff *skb, struct genl_info *
 	if (retcode != NO_ERROR)
 		goto out;
 
-	retcode = drbd_request_state(adm_ctx.mdev, mask, val);
+	retcode = drbd_request_state(adm_ctx.device, mask, val);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
 }
 
-static int drbd_bmio_set_susp_al(struct drbd_device *mdev)
+static int drbd_bmio_set_susp_al(struct drbd_device *device)
 {
 	int rv;
 
-	rv = drbd_bmio_set_n_write(mdev);
-	drbd_suspend_al(mdev);
+	rv = drbd_bmio_set_n_write(device);
+	drbd_suspend_al(device);
 	return rv;
 }
 
 int drbd_adm_invalidate_peer(struct sk_buff *skb, struct genl_info *info)
 {
 	int retcode; /* drbd_ret_code, drbd_state_rv */
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
 	if (!adm_ctx.reply_skb)
@@ -2610,32 +2610,32 @@ int drbd_adm_invalidate_peer(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	mdev = adm_ctx.mdev;
+	device = adm_ctx.device;
 
 	/* If there is still bitmap IO pending, probably because of a previous
 	 * resync just being finished, wait for it before requesting a new resync.
 	 * Also wait for it's after_state_ch(). */
-	drbd_suspend_io(mdev);
-	wait_event(mdev->misc_wait, !test_bit(BITMAP_IO, &mdev->flags));
-	drbd_flush_workqueue(mdev);
+	drbd_suspend_io(device);
+	wait_event(device->misc_wait, !test_bit(BITMAP_IO, &device->flags));
+	drbd_flush_workqueue(device);
 
 	/* If we happen to be C_STANDALONE R_PRIMARY, just set all bits
 	 * in the bitmap.  Otherwise, try to start a resync handshake
 	 * as sync source for full sync.
 	 */
-	if (mdev->state.conn == C_STANDALONE && mdev->state.role == R_PRIMARY) {
+	if (device->state.conn == C_STANDALONE && device->state.role == R_PRIMARY) {
 		/* The peer will get a resync upon connect anyways. Just make that
 		   into a full resync. */
-		retcode = drbd_request_state(mdev, NS(pdsk, D_INCONSISTENT));
+		retcode = drbd_request_state(device, NS(pdsk, D_INCONSISTENT));
 		if (retcode >= SS_SUCCESS) {
-			if (drbd_bitmap_io(mdev, &drbd_bmio_set_susp_al,
+			if (drbd_bitmap_io(device, &drbd_bmio_set_susp_al,
 				"set_n_write from invalidate_peer",
 				BM_LOCKED_SET_ALLOWED))
 				retcode = ERR_IO_MD_DISK;
 		}
 	} else
-		retcode = drbd_request_state(mdev, NS(conn, C_STARTING_SYNC_S));
-	drbd_resume_io(mdev);
+		retcode = drbd_request_state(device, NS(conn, C_STARTING_SYNC_S));
+	drbd_resume_io(device);
 
 out:
 	drbd_adm_finish(info, retcode);
@@ -2652,7 +2652,7 @@ int drbd_adm_pause_sync(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	if (drbd_request_state(adm_ctx.mdev, NS(user_isp, 1)) == SS_NOTHING_TO_DO)
+	if (drbd_request_state(adm_ctx.device, NS(user_isp, 1)) == SS_NOTHING_TO_DO)
 		retcode = ERR_PAUSE_IS_SET;
 out:
 	drbd_adm_finish(info, retcode);
@@ -2670,8 +2670,8 @@ int drbd_adm_resume_sync(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	if (drbd_request_state(adm_ctx.mdev, NS(user_isp, 0)) == SS_NOTHING_TO_DO) {
-		s = adm_ctx.mdev->state;
+	if (drbd_request_state(adm_ctx.device, NS(user_isp, 0)) == SS_NOTHING_TO_DO) {
+		s = adm_ctx.device->state;
 		if (s.conn == C_PAUSED_SYNC_S || s.conn == C_PAUSED_SYNC_T) {
 			retcode = s.aftr_isp ? ERR_PIC_AFTER_DEP :
 				  s.peer_isp ? ERR_PIC_PEER_DEP : ERR_PAUSE_IS_CLEAR;
@@ -2692,7 +2692,7 @@ int drbd_adm_suspend_io(struct sk_buff *skb, struct genl_info *info)
 
 int drbd_adm_resume_io(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int retcode; /* enum drbd_ret_code rsp. enum drbd_state_rv */
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
@@ -2701,20 +2701,20 @@ int drbd_adm_resume_io(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	mdev = adm_ctx.mdev;
-	if (test_bit(NEW_CUR_UUID, &mdev->flags)) {
-		drbd_uuid_new_current(mdev);
-		clear_bit(NEW_CUR_UUID, &mdev->flags);
+	device = adm_ctx.device;
+	if (test_bit(NEW_CUR_UUID, &device->flags)) {
+		drbd_uuid_new_current(device);
+		clear_bit(NEW_CUR_UUID, &device->flags);
 	}
-	drbd_suspend_io(mdev);
-	retcode = drbd_request_state(mdev, NS3(susp, 0, susp_nod, 0, susp_fen, 0));
+	drbd_suspend_io(device);
+	retcode = drbd_request_state(device, NS3(susp, 0, susp_nod, 0, susp_fen, 0));
 	if (retcode == SS_SUCCESS) {
-		if (mdev->state.conn < C_CONNECTED)
-			tl_clear(mdev->tconn);
-		if (mdev->state.disk == D_DISKLESS || mdev->state.disk == D_FAILED)
-			tl_restart(mdev->tconn, FAIL_FROZEN_DISK_IO);
+		if (device->state.conn < C_CONNECTED)
+			tl_clear(device->tconn);
+		if (device->state.disk == D_DISKLESS || device->state.disk == D_FAILED)
+			tl_restart(device->tconn, FAIL_FROZEN_DISK_IO);
 	}
-	drbd_resume_io(mdev);
+	drbd_resume_io(device);
 
 out:
 	drbd_adm_finish(info, retcode);
@@ -2752,7 +2752,7 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
-int nla_put_status_info(struct sk_buff *skb, struct drbd_device *mdev,
+int nla_put_status_info(struct sk_buff *skb, struct drbd_device *device,
 		const struct sib_info *sib)
 {
 	struct state_info *si = NULL; /* for sizeof(si->member); */
@@ -2774,27 +2774,27 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_device *mdev,
 	 * always in the context of the receiving process */
 	exclude_sensitive = sib || !capable(CAP_SYS_ADMIN);
 
-	got_ldev = get_ldev(mdev);
+	got_ldev = get_ldev(device);
 
 	/* We need to add connection name and volume number information still.
 	 * Minor number is in drbd_genlmsghdr. */
-	if (nla_put_drbd_cfg_context(skb, mdev->tconn, mdev->vnr))
+	if (nla_put_drbd_cfg_context(skb, device->tconn, device->vnr))
 		goto nla_put_failure;
 
-	if (res_opts_to_skb(skb, &mdev->tconn->res_opts, exclude_sensitive))
+	if (res_opts_to_skb(skb, &device->tconn->res_opts, exclude_sensitive))
 		goto nla_put_failure;
 
 	rcu_read_lock();
 	if (got_ldev) {
 		struct disk_conf *disk_conf;
 
-		disk_conf = rcu_dereference(mdev->ldev->disk_conf);
+		disk_conf = rcu_dereference(device->ldev->disk_conf);
 		err = disk_conf_to_skb(skb, disk_conf, exclude_sensitive);
 	}
 	if (!err) {
 		struct net_conf *nc;
 
-		nc = rcu_dereference(mdev->tconn->net_conf);
+		nc = rcu_dereference(device->tconn->net_conf);
 		if (nc)
 			err = net_conf_to_skb(skb, nc, exclude_sensitive);
 	}
@@ -2806,38 +2806,38 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_device *mdev,
 	if (!nla)
 		goto nla_put_failure;
 	if (nla_put_u32(skb, T_sib_reason, sib ? sib->sib_reason : SIB_GET_STATUS_REPLY) ||
-	    nla_put_u32(skb, T_current_state, mdev->state.i) ||
-	    nla_put_u64(skb, T_ed_uuid, mdev->ed_uuid) ||
-	    nla_put_u64(skb, T_capacity, drbd_get_capacity(mdev->this_bdev)) ||
-	    nla_put_u64(skb, T_send_cnt, mdev->send_cnt) ||
-	    nla_put_u64(skb, T_recv_cnt, mdev->recv_cnt) ||
-	    nla_put_u64(skb, T_read_cnt, mdev->read_cnt) ||
-	    nla_put_u64(skb, T_writ_cnt, mdev->writ_cnt) ||
-	    nla_put_u64(skb, T_al_writ_cnt, mdev->al_writ_cnt) ||
-	    nla_put_u64(skb, T_bm_writ_cnt, mdev->bm_writ_cnt) ||
-	    nla_put_u32(skb, T_ap_bio_cnt, atomic_read(&mdev->ap_bio_cnt)) ||
-	    nla_put_u32(skb, T_ap_pending_cnt, atomic_read(&mdev->ap_pending_cnt)) ||
-	    nla_put_u32(skb, T_rs_pending_cnt, atomic_read(&mdev->rs_pending_cnt)))
+	    nla_put_u32(skb, T_current_state, device->state.i) ||
+	    nla_put_u64(skb, T_ed_uuid, device->ed_uuid) ||
+	    nla_put_u64(skb, T_capacity, drbd_get_capacity(device->this_bdev)) ||
+	    nla_put_u64(skb, T_send_cnt, device->send_cnt) ||
+	    nla_put_u64(skb, T_recv_cnt, device->recv_cnt) ||
+	    nla_put_u64(skb, T_read_cnt, device->read_cnt) ||
+	    nla_put_u64(skb, T_writ_cnt, device->writ_cnt) ||
+	    nla_put_u64(skb, T_al_writ_cnt, device->al_writ_cnt) ||
+	    nla_put_u64(skb, T_bm_writ_cnt, device->bm_writ_cnt) ||
+	    nla_put_u32(skb, T_ap_bio_cnt, atomic_read(&device->ap_bio_cnt)) ||
+	    nla_put_u32(skb, T_ap_pending_cnt, atomic_read(&device->ap_pending_cnt)) ||
+	    nla_put_u32(skb, T_rs_pending_cnt, atomic_read(&device->rs_pending_cnt)))
 		goto nla_put_failure;
 
 	if (got_ldev) {
 		int err;
 
-		spin_lock_irq(&mdev->ldev->md.uuid_lock);
-		err = nla_put(skb, T_uuids, sizeof(si->uuids), mdev->ldev->md.uuid);
-		spin_unlock_irq(&mdev->ldev->md.uuid_lock);
+		spin_lock_irq(&device->ldev->md.uuid_lock);
+		err = nla_put(skb, T_uuids, sizeof(si->uuids), device->ldev->md.uuid);
+		spin_unlock_irq(&device->ldev->md.uuid_lock);
 
 		if (err)
 			goto nla_put_failure;
 
-		if (nla_put_u32(skb, T_disk_flags, mdev->ldev->md.flags) ||
-		    nla_put_u64(skb, T_bits_total, drbd_bm_bits(mdev)) ||
-		    nla_put_u64(skb, T_bits_oos, drbd_bm_total_weight(mdev)))
+		if (nla_put_u32(skb, T_disk_flags, device->ldev->md.flags) ||
+		    nla_put_u64(skb, T_bits_total, drbd_bm_bits(device)) ||
+		    nla_put_u64(skb, T_bits_oos, drbd_bm_total_weight(device)))
 			goto nla_put_failure;
-		if (C_SYNC_SOURCE <= mdev->state.conn &&
-		    C_PAUSED_SYNC_T >= mdev->state.conn) {
-			if (nla_put_u64(skb, T_bits_rs_total, mdev->rs_total) ||
-			    nla_put_u64(skb, T_bits_rs_failed, mdev->rs_failed))
+		if (C_SYNC_SOURCE <= device->state.conn &&
+		    C_PAUSED_SYNC_T >= device->state.conn) {
+			if (nla_put_u64(skb, T_bits_rs_total, device->rs_total) ||
+			    nla_put_u64(skb, T_bits_rs_failed, device->rs_failed))
 				goto nla_put_failure;
 		}
 	}
@@ -2869,7 +2869,7 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_device *mdev,
 nla_put_failure:
 		err = -EMSGSIZE;
 	if (got_ldev)
-		put_ldev(mdev);
+		put_ldev(device);
 	return err;
 }
 
@@ -2884,7 +2884,7 @@ int drbd_adm_get_status(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	err = nla_put_status_info(adm_ctx.reply_skb, adm_ctx.mdev, NULL);
+	err = nla_put_status_info(adm_ctx.reply_skb, adm_ctx.device, NULL);
 	if (err) {
 		nlmsg_free(adm_ctx.reply_skb);
 		return err;
@@ -2896,7 +2896,7 @@ out:
 
 int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct drbd_genlmsghdr *dh;
 	struct drbd_tconn *pos = (struct drbd_tconn*)cb->args[0];
 	struct drbd_tconn *tconn = NULL;
@@ -2905,7 +2905,7 @@ int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 
 	/* Open coded, deferred, iteration:
 	 * list_for_each_entry_safe(tconn, tmp, &drbd_tconns, all_tconn) {
-	 *	idr_for_each_entry(&tconn->volumes, mdev, i) {
+	 *	idr_for_each_entry(&tconn->volumes, device, i) {
 	 *	  ...
 	 *	}
 	 * }
@@ -2918,7 +2918,7 @@ int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 	 * This may miss entries inserted after this dump started,
 	 * or entries deleted before they are reached.
 	 *
-	 * We need to make sure the mdev won't disappear while
+	 * We need to make sure the device won't disappear while
 	 * we are looking at it, and revalidate our iterators
 	 * on each iteration.
 	 */
@@ -2940,8 +2940,8 @@ int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 	if (tconn) {
 next_tconn:
-		mdev = idr_get_next(&tconn->volumes, &volume);
-		if (!mdev) {
+		device = idr_get_next(&tconn->volumes, &volume);
+		if (!device) {
 			/* No more volumes to dump on this tconn.
 			 * Advance tconn iterator. */
 			pos = list_entry_rcu(tconn->all_tconn.next,
@@ -2965,7 +2965,7 @@ next_tconn:
 		if (!dh)
 			goto out;
 
-		if (!mdev) {
+		if (!device) {
 			/* This is a tconn without a single volume.
 			 * Suprisingly enough, it may have a network
 			 * configuration. */
@@ -2980,13 +2980,13 @@ next_tconn:
 			goto done;
 		}
 
-		D_ASSERT(mdev->vnr == volume);
-		D_ASSERT(mdev->tconn == tconn);
+		D_ASSERT(device->vnr == volume);
+		D_ASSERT(device->tconn == tconn);
 
-		dh->minor = mdev_to_minor(mdev);
+		dh->minor = device_to_minor(device);
 		dh->ret_code = NO_ERROR;
 
-		if (nla_put_status_info(skb, mdev, NULL)) {
+		if (nla_put_status_info(skb, device, NULL)) {
 cancel:
 			genlmsg_cancel(skb, dh);
 			goto out;
@@ -3080,8 +3080,8 @@ int drbd_adm_get_timeout_type(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 
 	tp.timeout_type =
-		adm_ctx.mdev->state.pdsk == D_OUTDATED ? UT_PEER_OUTDATED :
-		test_bit(USE_DEGR_WFC_T, &adm_ctx.mdev->flags) ? UT_DEGRADED :
+		adm_ctx.device->state.pdsk == D_OUTDATED ? UT_PEER_OUTDATED :
+		test_bit(USE_DEGR_WFC_T, &adm_ctx.device->flags) ? UT_DEGRADED :
 		UT_DEFAULT;
 
 	err = timeout_parms_to_priv_skb(adm_ctx.reply_skb, &tp);
@@ -3096,7 +3096,7 @@ out:
 
 int drbd_adm_start_ov(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	enum drbd_ret_code retcode;
 	struct start_ov_parms parms;
 
@@ -3106,10 +3106,10 @@ int drbd_adm_start_ov(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	mdev = adm_ctx.mdev;
+	device = adm_ctx.device;
 
 	/* resume from last known position, if possible */
-	parms.ov_start_sector = mdev->ov_start_sector;
+	parms.ov_start_sector = device->ov_start_sector;
 	parms.ov_stop_sector = ULLONG_MAX;
 	if (info->attrs[DRBD_NLA_START_OV_PARMS]) {
 		int err = start_ov_parms_from_attrs(&parms, info);
@@ -3120,15 +3120,15 @@ int drbd_adm_start_ov(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 	/* w_make_ov_request expects position to be aligned */
-	mdev->ov_start_sector = parms.ov_start_sector & ~(BM_SECT_PER_BIT-1);
-	mdev->ov_stop_sector = parms.ov_stop_sector;
+	device->ov_start_sector = parms.ov_start_sector & ~(BM_SECT_PER_BIT-1);
+	device->ov_stop_sector = parms.ov_stop_sector;
 
 	/* If there is still bitmap IO pending, e.g. previous resync or verify
 	 * just being finished, wait for it before requesting a new resync. */
-	drbd_suspend_io(mdev);
-	wait_event(mdev->misc_wait, !test_bit(BITMAP_IO, &mdev->flags));
-	retcode = drbd_request_state(mdev,NS(conn,C_VERIFY_S));
-	drbd_resume_io(mdev);
+	drbd_suspend_io(device);
+	wait_event(device->misc_wait, !test_bit(BITMAP_IO, &device->flags));
+	retcode = drbd_request_state(device, NS(conn, C_VERIFY_S));
+	drbd_resume_io(device);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3137,7 +3137,7 @@ out:
 
 int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	enum drbd_ret_code retcode;
 	int skip_initial_sync = 0;
 	int err;
@@ -3149,7 +3149,7 @@ int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out_nolock;
 
-	mdev = adm_ctx.mdev;
+	device = adm_ctx.device;
 	memset(&args, 0, sizeof(args));
 	if (info->attrs[DRBD_NLA_NEW_C_UUID_PARMS]) {
 		err = new_c_uuid_parms_from_attrs(&args, info);
@@ -3160,49 +3160,49 @@ int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	mutex_lock(mdev->state_mutex); /* Protects us against serialized state changes. */
+	mutex_lock(device->state_mutex); /* Protects us against serialized state changes. */
 
-	if (!get_ldev(mdev)) {
+	if (!get_ldev(device)) {
 		retcode = ERR_NO_DISK;
 		goto out;
 	}
 
 	/* this is "skip initial sync", assume to be clean */
-	if (mdev->state.conn == C_CONNECTED && mdev->tconn->agreed_pro_version >= 90 &&
-	    mdev->ldev->md.uuid[UI_CURRENT] == UUID_JUST_CREATED && args.clear_bm) {
+	if (device->state.conn == C_CONNECTED && device->tconn->agreed_pro_version >= 90 &&
+	    device->ldev->md.uuid[UI_CURRENT] == UUID_JUST_CREATED && args.clear_bm) {
 		dev_info(DEV, "Preparing to skip initial sync\n");
 		skip_initial_sync = 1;
-	} else if (mdev->state.conn != C_STANDALONE) {
+	} else if (device->state.conn != C_STANDALONE) {
 		retcode = ERR_CONNECTED;
 		goto out_dec;
 	}
 
-	drbd_uuid_set(mdev, UI_BITMAP, 0); /* Rotate UI_BITMAP to History 1, etc... */
-	drbd_uuid_new_current(mdev); /* New current, previous to UI_BITMAP */
+	drbd_uuid_set(device, UI_BITMAP, 0); /* Rotate UI_BITMAP to History 1, etc... */
+	drbd_uuid_new_current(device); /* New current, previous to UI_BITMAP */
 
 	if (args.clear_bm) {
-		err = drbd_bitmap_io(mdev, &drbd_bmio_clear_n_write,
+		err = drbd_bitmap_io(device, &drbd_bmio_clear_n_write,
 			"clear_n_write from new_c_uuid", BM_LOCKED_MASK);
 		if (err) {
 			dev_err(DEV, "Writing bitmap failed with %d\n",err);
 			retcode = ERR_IO_MD_DISK;
 		}
 		if (skip_initial_sync) {
-			drbd_send_uuids_skip_initial_sync(mdev);
-			_drbd_uuid_set(mdev, UI_BITMAP, 0);
-			drbd_print_uuids(mdev, "cleared bitmap UUID");
-			spin_lock_irq(&mdev->tconn->req_lock);
-			_drbd_set_state(_NS2(mdev, disk, D_UP_TO_DATE, pdsk, D_UP_TO_DATE),
+			drbd_send_uuids_skip_initial_sync(device);
+			_drbd_uuid_set(device, UI_BITMAP, 0);
+			drbd_print_uuids(device, "cleared bitmap UUID");
+			spin_lock_irq(&device->tconn->req_lock);
+			_drbd_set_state(_NS2(device, disk, D_UP_TO_DATE, pdsk, D_UP_TO_DATE),
 					CS_VERBOSE, NULL);
-			spin_unlock_irq(&mdev->tconn->req_lock);
+			spin_unlock_irq(&device->tconn->req_lock);
 		}
 	}
 
-	drbd_md_sync(mdev);
+	drbd_md_sync(device);
 out_dec:
-	put_ldev(mdev);
+	put_ldev(device);
 out:
-	mutex_unlock(mdev->state_mutex);
+	mutex_unlock(device->state_mutex);
 out_nolock:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3287,8 +3287,8 @@ int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* drbd_adm_prepare made sure already
-	 * that mdev->tconn and mdev->vnr match the request. */
-	if (adm_ctx.mdev) {
+	 * that device->tconn and device->vnr match the request. */
+	if (adm_ctx.device) {
 		if (info->nlhdr->nlmsg_flags & NLM_F_EXCL)
 			retcode = ERR_MINOR_EXISTS;
 		/* else: still NO_ERROR */
@@ -3301,21 +3301,21 @@ out:
 	return 0;
 }
 
-static enum drbd_ret_code adm_delete_minor(struct drbd_device *mdev)
+static enum drbd_ret_code adm_delete_minor(struct drbd_device *device)
 {
-	if (mdev->state.disk == D_DISKLESS &&
-	    /* no need to be mdev->state.conn == C_STANDALONE &&
+	if (device->state.disk == D_DISKLESS &&
+	    /* no need to be device->state.conn == C_STANDALONE &&
 	     * we may want to delete a minor from a live replication group.
 	     */
-	    mdev->state.role == R_SECONDARY) {
-		_drbd_request_state(mdev, NS(conn, C_WF_REPORT_PARAMS),
+	    device->state.role == R_SECONDARY) {
+		_drbd_request_state(device, NS(conn, C_WF_REPORT_PARAMS),
 				    CS_VERBOSE + CS_WAIT_COMPLETE);
-		idr_remove(&mdev->tconn->volumes, mdev->vnr);
-		idr_remove(&minors, mdev_to_minor(mdev));
-		destroy_workqueue(mdev->submit.wq);
-		del_gendisk(mdev->vdisk);
+		idr_remove(&device->tconn->volumes, device->vnr);
+		idr_remove(&minors, device_to_minor(device));
+		destroy_workqueue(device->submit.wq);
+		del_gendisk(device->vdisk);
 		synchronize_rcu();
-		kref_put(&mdev->kref, &drbd_minor_destroy);
+		kref_put(&device->kref, &drbd_minor_destroy);
 		return NO_ERROR;
 	} else
 		return ERR_MINOR_CONFIGURED;
@@ -3331,7 +3331,7 @@ int drbd_adm_delete_minor(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	retcode = adm_delete_minor(adm_ctx.mdev);
+	retcode = adm_delete_minor(adm_ctx.device);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3340,7 +3340,7 @@ out:
 int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 {
 	int retcode; /* enum drbd_ret_code rsp. enum drbd_state_rv */
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	unsigned i;
 
 	retcode = drbd_adm_prepare(skb, info, 0);
@@ -3355,8 +3355,8 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* demote */
-	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
-		retcode = drbd_set_role(mdev, R_SECONDARY, 0);
+	idr_for_each_entry(&adm_ctx.tconn->volumes, device, i) {
+		retcode = drbd_set_role(device, R_SECONDARY, 0);
 		if (retcode < SS_SUCCESS) {
 			drbd_msg_put_info("failed to demote");
 			goto out;
@@ -3370,8 +3370,8 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* detach */
-	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
-		retcode = adm_detach(mdev, 0);
+	idr_for_each_entry(&adm_ctx.tconn->volumes, device, i) {
+		retcode = adm_detach(device, 0);
 		if (retcode < SS_SUCCESS || retcode > NO_ERROR) {
 			drbd_msg_put_info("failed to detach");
 			goto out;
@@ -3386,8 +3386,8 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 	/* Now, nothing can fail anymore */
 
 	/* delete volumes */
-	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
-		retcode = adm_delete_minor(mdev);
+	idr_for_each_entry(&adm_ctx.tconn->volumes, device, i) {
+		retcode = adm_delete_minor(device);
 		if (retcode != NO_ERROR) {
 			/* "can not happen" */
 			drbd_msg_put_info("failed to delete volume");
@@ -3440,7 +3440,7 @@ out:
 	return 0;
 }
 
-void drbd_bcast_event(struct drbd_device *mdev, const struct sib_info *sib)
+void drbd_bcast_event(struct drbd_device *device, const struct sib_info *sib)
 {
 	static atomic_t drbd_genl_seq = ATOMIC_INIT(2); /* two. */
 	struct sk_buff *msg;
@@ -3449,8 +3449,8 @@ void drbd_bcast_event(struct drbd_device *mdev, const struct sib_info *sib)
 	int err = -ENOMEM;
 
 	if (sib->sib_reason == SIB_SYNC_PROGRESS) {
-		if (time_after(jiffies, mdev->rs_last_bcast + HZ))
-			mdev->rs_last_bcast = jiffies;
+		if (time_after(jiffies, device->rs_last_bcast + HZ))
+			device->rs_last_bcast = jiffies;
 		else
 			return;
 	}
@@ -3464,10 +3464,10 @@ void drbd_bcast_event(struct drbd_device *mdev, const struct sib_info *sib)
 	d_out = genlmsg_put(msg, 0, seq, &drbd_genl_family, 0, DRBD_EVENT);
 	if (!d_out) /* cannot happen, but anyways. */
 		goto nla_put_failure;
-	d_out->minor = mdev_to_minor(mdev);
+	d_out->minor = device_to_minor(device);
 	d_out->ret_code = NO_ERROR;
 
-	if (nla_put_status_info(msg, mdev, sib))
+	if (nla_put_status_info(msg, device, sib))
 		goto nla_put_failure;
 	genlmsg_end(msg, d_out);
 	err = drbd_genl_multicast_events(msg, 0);
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 384d61f..61972d8 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -66,14 +66,14 @@ void seq_printf_with_thousands_grouping(struct seq_file *seq, long v)
  *	[=====>..............] 33.5% (23456/123456)
  *	finish: 2:20:20 speed: 6,345 (6,456) K/sec
  */
-static void drbd_syncer_progress(struct drbd_device *mdev, struct seq_file *seq)
+static void drbd_syncer_progress(struct drbd_device *device, struct seq_file *seq)
 {
 	unsigned long db, dt, dbdt, rt, rs_left;
 	unsigned int res;
 	int i, x, y;
 	int stalled = 0;
 
-	drbd_get_syncer_progress(mdev, &rs_left, &res);
+	drbd_get_syncer_progress(device, &rs_left, &res);
 
 	x = res/50;
 	y = 20-x;
@@ -85,21 +85,21 @@ static void drbd_syncer_progress(struct drbd_device *mdev, struct seq_file *seq)
 		seq_printf(seq, ".");
 	seq_printf(seq, "] ");
 
-	if (mdev->state.conn == C_VERIFY_S || mdev->state.conn == C_VERIFY_T)
+	if (device->state.conn == C_VERIFY_S || device->state.conn == C_VERIFY_T)
 		seq_printf(seq, "verified:");
 	else
 		seq_printf(seq, "sync'ed:");
 	seq_printf(seq, "%3u.%u%% ", res / 10, res % 10);
 
 	/* if more than a few GB, display in MB */
-	if (mdev->rs_total > (4UL << (30 - BM_BLOCK_SHIFT)))
+	if (device->rs_total > (4UL << (30 - BM_BLOCK_SHIFT)))
 		seq_printf(seq, "(%lu/%lu)M",
 			    (unsigned long) Bit2KB(rs_left >> 10),
-			    (unsigned long) Bit2KB(mdev->rs_total >> 10));
+			    (unsigned long) Bit2KB(device->rs_total >> 10));
 	else
 		seq_printf(seq, "(%lu/%lu)K\n\t",
 			    (unsigned long) Bit2KB(rs_left),
-			    (unsigned long) Bit2KB(mdev->rs_total));
+			    (unsigned long) Bit2KB(device->rs_total));
 
 	/* see drivers/md/md.c
 	 * We do not want to overflow, so the order of operands and
@@ -114,14 +114,14 @@ static void drbd_syncer_progress(struct drbd_device *mdev, struct seq_file *seq)
 	 * at least (DRBD_SYNC_MARKS-2)*DRBD_SYNC_MARK_STEP old, and has at
 	 * least DRBD_SYNC_MARK_STEP time before it will be modified. */
 	/* ------------------------ ~18s average ------------------------ */
-	i = (mdev->rs_last_mark + 2) % DRBD_SYNC_MARKS;
-	dt = (jiffies - mdev->rs_mark_time[i]) / HZ;
+	i = (device->rs_last_mark + 2) % DRBD_SYNC_MARKS;
+	dt = (jiffies - device->rs_mark_time[i]) / HZ;
 	if (dt > (DRBD_SYNC_MARK_STEP * DRBD_SYNC_MARKS))
 		stalled = 1;
 
 	if (!dt)
 		dt++;
-	db = mdev->rs_mark_left[i] - rs_left;
+	db = device->rs_mark_left[i] - rs_left;
 	rt = (dt * (rs_left / (db/100+1)))/100; /* seconds */
 
 	seq_printf(seq, "finish: %lu:%02lu:%02lu",
@@ -134,11 +134,11 @@ static void drbd_syncer_progress(struct drbd_device *mdev, struct seq_file *seq)
 	/* ------------------------- ~3s average ------------------------ */
 	if (proc_details >= 1) {
 		/* this is what drbd_rs_should_slow_down() uses */
-		i = (mdev->rs_last_mark + DRBD_SYNC_MARKS-1) % DRBD_SYNC_MARKS;
-		dt = (jiffies - mdev->rs_mark_time[i]) / HZ;
+		i = (device->rs_last_mark + DRBD_SYNC_MARKS-1) % DRBD_SYNC_MARKS;
+		dt = (jiffies - device->rs_mark_time[i]) / HZ;
 		if (!dt)
 			dt++;
-		db = mdev->rs_mark_left[i] - rs_left;
+		db = device->rs_mark_left[i] - rs_left;
 		dbdt = Bit2KB(db/dt);
 		seq_printf_with_thousands_grouping(seq, dbdt);
 		seq_printf(seq, " -- ");
@@ -147,34 +147,34 @@ static void drbd_syncer_progress(struct drbd_device *mdev, struct seq_file *seq)
 	/* --------------------- long term average ---------------------- */
 	/* mean speed since syncer started
 	 * we do account for PausedSync periods */
-	dt = (jiffies - mdev->rs_start - mdev->rs_paused) / HZ;
+	dt = (jiffies - device->rs_start - device->rs_paused) / HZ;
 	if (dt == 0)
 		dt = 1;
-	db = mdev->rs_total - rs_left;
+	db = device->rs_total - rs_left;
 	dbdt = Bit2KB(db/dt);
 	seq_printf_with_thousands_grouping(seq, dbdt);
 	seq_printf(seq, ")");
 
-	if (mdev->state.conn == C_SYNC_TARGET ||
-	    mdev->state.conn == C_VERIFY_S) {
+	if (device->state.conn == C_SYNC_TARGET ||
+	    device->state.conn == C_VERIFY_S) {
 		seq_printf(seq, " want: ");
-		seq_printf_with_thousands_grouping(seq, mdev->c_sync_rate);
+		seq_printf_with_thousands_grouping(seq, device->c_sync_rate);
 	}
 	seq_printf(seq, " K/sec%s\n", stalled ? " (stalled)" : "");
 
 	if (proc_details >= 1) {
 		/* 64 bit:
 		 * we convert to sectors in the display below. */
-		unsigned long bm_bits = drbd_bm_bits(mdev);
+		unsigned long bm_bits = drbd_bm_bits(device);
 		unsigned long bit_pos;
 		unsigned long long stop_sector = 0;
-		if (mdev->state.conn == C_VERIFY_S ||
-		    mdev->state.conn == C_VERIFY_T) {
-			bit_pos = bm_bits - mdev->ov_left;
-			if (verify_can_do_stop_sector(mdev))
-				stop_sector = mdev->ov_stop_sector;
+		if (device->state.conn == C_VERIFY_S ||
+		    device->state.conn == C_VERIFY_T) {
+			bit_pos = bm_bits - device->ov_left;
+			if (verify_can_do_stop_sector(device))
+				stop_sector = device->ov_stop_sector;
 		} else
-			bit_pos = mdev->bm_resync_fo;
+			bit_pos = device->bm_resync_fo;
 		/* Total sectors may be slightly off for oddly
 		 * sized devices. So what. */
 		seq_printf(seq,
@@ -202,7 +202,7 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 {
 	int i, prev_i = -1;
 	const char *sn;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct net_conf *nc;
 	char wp;
 
@@ -236,72 +236,72 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 	*/
 
 	rcu_read_lock();
-	idr_for_each_entry(&minors, mdev, i) {
+	idr_for_each_entry(&minors, device, i) {
 		if (prev_i != i - 1)
 			seq_printf(seq, "\n");
 		prev_i = i;
 
-		sn = drbd_conn_str(mdev->state.conn);
+		sn = drbd_conn_str(device->state.conn);
 
-		if (mdev->state.conn == C_STANDALONE &&
-		    mdev->state.disk == D_DISKLESS &&
-		    mdev->state.role == R_SECONDARY) {
+		if (device->state.conn == C_STANDALONE &&
+		    device->state.disk == D_DISKLESS &&
+		    device->state.role == R_SECONDARY) {
 			seq_printf(seq, "%2d: cs:Unconfigured\n", i);
 		} else {
-			/* reset mdev->congestion_reason */
-			bdi_rw_congested(&mdev->rq_queue->backing_dev_info);
+			/* reset device->congestion_reason */
+			bdi_rw_congested(&device->rq_queue->backing_dev_info);
 
-			nc = rcu_dereference(mdev->tconn->net_conf);
+			nc = rcu_dereference(device->tconn->net_conf);
 			wp = nc ? nc->wire_protocol - DRBD_PROT_A + 'A' : ' ';
 			seq_printf(seq,
 			   "%2d: cs:%s ro:%s/%s ds:%s/%s %c %c%c%c%c%c%c\n"
 			   "    ns:%u nr:%u dw:%u dr:%u al:%u bm:%u "
 			   "lo:%d pe:%d ua:%d ap:%d ep:%d wo:%c",
 			   i, sn,
-			   drbd_role_str(mdev->state.role),
-			   drbd_role_str(mdev->state.peer),
-			   drbd_disk_str(mdev->state.disk),
-			   drbd_disk_str(mdev->state.pdsk),
+			   drbd_role_str(device->state.role),
+			   drbd_role_str(device->state.peer),
+			   drbd_disk_str(device->state.disk),
+			   drbd_disk_str(device->state.pdsk),
 			   wp,
-			   drbd_suspended(mdev) ? 's' : 'r',
-			   mdev->state.aftr_isp ? 'a' : '-',
-			   mdev->state.peer_isp ? 'p' : '-',
-			   mdev->state.user_isp ? 'u' : '-',
-			   mdev->congestion_reason ?: '-',
-			   test_bit(AL_SUSPENDED, &mdev->flags) ? 's' : '-',
-			   mdev->send_cnt/2,
-			   mdev->recv_cnt/2,
-			   mdev->writ_cnt/2,
-			   mdev->read_cnt/2,
-			   mdev->al_writ_cnt,
-			   mdev->bm_writ_cnt,
-			   atomic_read(&mdev->local_cnt),
-			   atomic_read(&mdev->ap_pending_cnt) +
-			   atomic_read(&mdev->rs_pending_cnt),
-			   atomic_read(&mdev->unacked_cnt),
-			   atomic_read(&mdev->ap_bio_cnt),
-			   mdev->tconn->epochs,
-			   write_ordering_chars[mdev->tconn->write_ordering]
+			   drbd_suspended(device) ? 's' : 'r',
+			   device->state.aftr_isp ? 'a' : '-',
+			   device->state.peer_isp ? 'p' : '-',
+			   device->state.user_isp ? 'u' : '-',
+			   device->congestion_reason ?: '-',
+			   test_bit(AL_SUSPENDED, &device->flags) ? 's' : '-',
+			   device->send_cnt/2,
+			   device->recv_cnt/2,
+			   device->writ_cnt/2,
+			   device->read_cnt/2,
+			   device->al_writ_cnt,
+			   device->bm_writ_cnt,
+			   atomic_read(&device->local_cnt),
+			   atomic_read(&device->ap_pending_cnt) +
+			   atomic_read(&device->rs_pending_cnt),
+			   atomic_read(&device->unacked_cnt),
+			   atomic_read(&device->ap_bio_cnt),
+			   device->tconn->epochs,
+			   write_ordering_chars[device->tconn->write_ordering]
 			);
 			seq_printf(seq, " oos:%llu\n",
 				   Bit2KB((unsigned long long)
-					   drbd_bm_total_weight(mdev)));
+					   drbd_bm_total_weight(device)));
 		}
-		if (mdev->state.conn == C_SYNC_SOURCE ||
-		    mdev->state.conn == C_SYNC_TARGET ||
-		    mdev->state.conn == C_VERIFY_S ||
-		    mdev->state.conn == C_VERIFY_T)
-			drbd_syncer_progress(mdev, seq);
-
-		if (proc_details >= 1 && get_ldev_if_state(mdev, D_FAILED)) {
-			lc_seq_printf_stats(seq, mdev->resync);
-			lc_seq_printf_stats(seq, mdev->act_log);
-			put_ldev(mdev);
+		if (device->state.conn == C_SYNC_SOURCE ||
+		    device->state.conn == C_SYNC_TARGET ||
+		    device->state.conn == C_VERIFY_S ||
+		    device->state.conn == C_VERIFY_T)
+			drbd_syncer_progress(device, seq);
+
+		if (proc_details >= 1 && get_ldev_if_state(device, D_FAILED)) {
+			lc_seq_printf_stats(seq, device->resync);
+			lc_seq_printf_stats(seq, device->act_log);
+			put_ldev(device);
 		}
 
 		if (proc_details >= 2) {
-			if (mdev->resync) {
-				lc_seq_dump_details(seq, mdev->resync, "rs_left",
+			if (device->resync) {
+				lc_seq_dump_details(seq, device->resync, "rs_left",
 					resync_dump_detail);
 			}
 		}
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index cd43fac..c71154c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -64,7 +64,7 @@ enum finish_epoch {
 
 static int drbd_do_features(struct drbd_tconn *tconn);
 static int drbd_do_auth(struct drbd_tconn *tconn);
-static int drbd_disconnected(struct drbd_device *mdev);
+static int drbd_disconnected(struct drbd_device *device);
 
 static enum finish_epoch drbd_may_finish_epoch(struct drbd_tconn *, struct drbd_epoch *, enum epoch_event);
 static int e_end_block(struct drbd_work *, int);
@@ -151,7 +151,7 @@ static void page_chain_add(struct page **head,
 	*head = chain_first;
 }
 
-static struct page *__drbd_alloc_pages(struct drbd_device *mdev,
+static struct page *__drbd_alloc_pages(struct drbd_device *device,
 				       unsigned int number)
 {
 	struct page *page = NULL;
@@ -197,7 +197,7 @@ static struct page *__drbd_alloc_pages(struct drbd_device *mdev,
 	return NULL;
 }
 
-static void reclaim_finished_net_peer_reqs(struct drbd_device *mdev,
+static void reclaim_finished_net_peer_reqs(struct drbd_device *device,
 					   struct list_head *to_be_freed)
 {
 	struct drbd_peer_request *peer_req;
@@ -208,7 +208,7 @@ static void reclaim_finished_net_peer_reqs(struct drbd_device *mdev,
 	   in order. As soon as we see the first not finished we can
 	   stop to examine the list... */
 
-	list_for_each_safe(le, tle, &mdev->net_ee) {
+	list_for_each_safe(le, tle, &device->net_ee) {
 		peer_req = list_entry(le, struct drbd_peer_request, w.list);
 		if (drbd_peer_req_has_active_page(peer_req))
 			break;
@@ -216,22 +216,22 @@ static void reclaim_finished_net_peer_reqs(struct drbd_device *mdev,
 	}
 }
 
-static void drbd_kick_lo_and_reclaim_net(struct drbd_device *mdev)
+static void drbd_kick_lo_and_reclaim_net(struct drbd_device *device)
 {
 	LIST_HEAD(reclaimed);
 	struct drbd_peer_request *peer_req, *t;
 
-	spin_lock_irq(&mdev->tconn->req_lock);
-	reclaim_finished_net_peer_reqs(mdev, &reclaimed);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
+	reclaim_finished_net_peer_reqs(device, &reclaimed);
+	spin_unlock_irq(&device->tconn->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
-		drbd_free_net_peer_req(mdev, peer_req);
+		drbd_free_net_peer_req(device, peer_req);
 }
 
 /**
  * drbd_alloc_pages() - Returns @number pages, retries forever (or until signalled)
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @number:	number of pages requested
  * @retry:	whether to retry, if not enough pages are available right now
  *
@@ -241,7 +241,7 @@ static void drbd_kick_lo_and_reclaim_net(struct drbd_device *mdev)
  *
  * Returns a page chain linked via page->private.
  */
-struct page *drbd_alloc_pages(struct drbd_device *mdev, unsigned int number,
+struct page *drbd_alloc_pages(struct drbd_device *device, unsigned int number,
 			      bool retry)
 {
 	struct page *page = NULL;
@@ -252,20 +252,20 @@ struct page *drbd_alloc_pages(struct drbd_device *mdev, unsigned int number,
 	/* Yes, we may run up to @number over max_buffers. If we
 	 * follow it strictly, the admin will get it wrong anyways. */
 	rcu_read_lock();
-	nc = rcu_dereference(mdev->tconn->net_conf);
+	nc = rcu_dereference(device->tconn->net_conf);
 	mxb = nc ? nc->max_buffers : 1000000;
 	rcu_read_unlock();
 
-	if (atomic_read(&mdev->pp_in_use) < mxb)
-		page = __drbd_alloc_pages(mdev, number);
+	if (atomic_read(&device->pp_in_use) < mxb)
+		page = __drbd_alloc_pages(device, number);
 
 	while (page == NULL) {
 		prepare_to_wait(&drbd_pp_wait, &wait, TASK_INTERRUPTIBLE);
 
-		drbd_kick_lo_and_reclaim_net(mdev);
+		drbd_kick_lo_and_reclaim_net(device);
 
-		if (atomic_read(&mdev->pp_in_use) < mxb) {
-			page = __drbd_alloc_pages(mdev, number);
+		if (atomic_read(&device->pp_in_use) < mxb) {
+			page = __drbd_alloc_pages(device, number);
 			if (page)
 				break;
 		}
@@ -283,17 +283,17 @@ struct page *drbd_alloc_pages(struct drbd_device *mdev, unsigned int number,
 	finish_wait(&drbd_pp_wait, &wait);
 
 	if (page)
-		atomic_add(number, &mdev->pp_in_use);
+		atomic_add(number, &device->pp_in_use);
 	return page;
 }
 
 /* Must not be used from irq, as that may deadlock: see drbd_alloc_pages.
- * Is also used from inside an other spin_lock_irq(&mdev->tconn->req_lock);
+ * Is also used from inside an other spin_lock_irq(&device->tconn->req_lock);
  * Either links the page chain back to the global pool,
  * or returns all pages to the system. */
-static void drbd_free_pages(struct drbd_device *mdev, struct page *page, int is_net)
+static void drbd_free_pages(struct drbd_device *device, struct page *page, int is_net)
 {
-	atomic_t *a = is_net ? &mdev->pp_in_use_by_net : &mdev->pp_in_use;
+	atomic_t *a = is_net ? &device->pp_in_use_by_net : &device->pp_in_use;
 	int i;
 
 	if (page == NULL)
@@ -331,14 +331,14 @@ You must not have the req_lock:
 */
 
 struct drbd_peer_request *
-drbd_alloc_peer_req(struct drbd_device *mdev, u64 id, sector_t sector,
+drbd_alloc_peer_req(struct drbd_device *device, u64 id, sector_t sector,
 		    unsigned int data_size, gfp_t gfp_mask) __must_hold(local)
 {
 	struct drbd_peer_request *peer_req;
 	struct page *page = NULL;
 	unsigned nr_pages = (data_size + PAGE_SIZE -1) >> PAGE_SHIFT;
 
-	if (drbd_insert_fault(mdev, DRBD_FAULT_AL_EE))
+	if (drbd_insert_fault(device, DRBD_FAULT_AL_EE))
 		return NULL;
 
 	peer_req = mempool_alloc(drbd_ee_mempool, gfp_mask & ~__GFP_HIGHMEM);
@@ -349,7 +349,7 @@ drbd_alloc_peer_req(struct drbd_device *mdev, u64 id, sector_t sector,
 	}
 
 	if (data_size) {
-		page = drbd_alloc_pages(mdev, nr_pages, (gfp_mask & __GFP_WAIT));
+		page = drbd_alloc_pages(device, nr_pages, (gfp_mask & __GFP_WAIT));
 		if (!page)
 			goto fail;
 	}
@@ -361,7 +361,7 @@ drbd_alloc_peer_req(struct drbd_device *mdev, u64 id, sector_t sector,
 	peer_req->i.waiting = false;
 
 	peer_req->epoch = NULL;
-	peer_req->w.mdev = mdev;
+	peer_req->w.device = device;
 	peer_req->pages = page;
 	atomic_set(&peer_req->pending_bios, 0);
 	peer_req->flags = 0;
@@ -378,30 +378,30 @@ drbd_alloc_peer_req(struct drbd_device *mdev, u64 id, sector_t sector,
 	return NULL;
 }
 
-void __drbd_free_peer_req(struct drbd_device *mdev, struct drbd_peer_request *peer_req,
+void __drbd_free_peer_req(struct drbd_device *device, struct drbd_peer_request *peer_req,
 		       int is_net)
 {
 	if (peer_req->flags & EE_HAS_DIGEST)
 		kfree(peer_req->digest);
-	drbd_free_pages(mdev, peer_req->pages, is_net);
+	drbd_free_pages(device, peer_req->pages, is_net);
 	D_ASSERT(atomic_read(&peer_req->pending_bios) == 0);
 	D_ASSERT(drbd_interval_empty(&peer_req->i));
 	mempool_free(peer_req, drbd_ee_mempool);
 }
 
-int drbd_free_peer_reqs(struct drbd_device *mdev, struct list_head *list)
+int drbd_free_peer_reqs(struct drbd_device *device, struct list_head *list)
 {
 	LIST_HEAD(work_list);
 	struct drbd_peer_request *peer_req, *t;
 	int count = 0;
-	int is_net = list == &mdev->net_ee;
+	int is_net = list == &device->net_ee;
 
-	spin_lock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
 	list_splice_init(list, &work_list);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_unlock_irq(&device->tconn->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
-		__drbd_free_peer_req(mdev, peer_req, is_net);
+		__drbd_free_peer_req(device, peer_req, is_net);
 		count++;
 	}
 	return count;
@@ -410,20 +410,20 @@ int drbd_free_peer_reqs(struct drbd_device *mdev, struct list_head *list)
 /*
  * See also comments in _req_mod(,BARRIER_ACKED) and receive_Barrier.
  */
-static int drbd_finish_peer_reqs(struct drbd_device *mdev)
+static int drbd_finish_peer_reqs(struct drbd_device *device)
 {
 	LIST_HEAD(work_list);
 	LIST_HEAD(reclaimed);
 	struct drbd_peer_request *peer_req, *t;
 	int err = 0;
 
-	spin_lock_irq(&mdev->tconn->req_lock);
-	reclaim_finished_net_peer_reqs(mdev, &reclaimed);
-	list_splice_init(&mdev->done_ee, &work_list);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
+	reclaim_finished_net_peer_reqs(device, &reclaimed);
+	list_splice_init(&device->done_ee, &work_list);
+	spin_unlock_irq(&device->tconn->req_lock);
 
 	list_for_each_entry_safe(peer_req, t, &reclaimed, w.list)
-		drbd_free_net_peer_req(mdev, peer_req);
+		drbd_free_net_peer_req(device, peer_req);
 
 	/* possible callbacks here:
 	 * e_end_block, and e_end_resync_block, e_send_superseded.
@@ -436,14 +436,14 @@ static int drbd_finish_peer_reqs(struct drbd_device *mdev)
 		err2 = peer_req->w.cb(&peer_req->w, !!err);
 		if (!err)
 			err = err2;
-		drbd_free_peer_req(mdev, peer_req);
+		drbd_free_peer_req(device, peer_req);
 	}
-	wake_up(&mdev->ee_wait);
+	wake_up(&device->ee_wait);
 
 	return err;
 }
 
-static void _drbd_wait_ee_list_empty(struct drbd_device *mdev,
+static void _drbd_wait_ee_list_empty(struct drbd_device *device,
 				     struct list_head *head)
 {
 	DEFINE_WAIT(wait);
@@ -451,20 +451,20 @@ static void _drbd_wait_ee_list_empty(struct drbd_device *mdev,
 	/* avoids spin_lock/unlock
 	 * and calling prepare_to_wait in the fast path */
 	while (!list_empty(head)) {
-		prepare_to_wait(&mdev->ee_wait, &wait, TASK_UNINTERRUPTIBLE);
-		spin_unlock_irq(&mdev->tconn->req_lock);
+		prepare_to_wait(&device->ee_wait, &wait, TASK_UNINTERRUPTIBLE);
+		spin_unlock_irq(&device->tconn->req_lock);
 		io_schedule();
-		finish_wait(&mdev->ee_wait, &wait);
-		spin_lock_irq(&mdev->tconn->req_lock);
+		finish_wait(&device->ee_wait, &wait);
+		spin_lock_irq(&device->tconn->req_lock);
 	}
 }
 
-static void drbd_wait_ee_list_empty(struct drbd_device *mdev,
+static void drbd_wait_ee_list_empty(struct drbd_device *device,
 				    struct list_head *head)
 {
-	spin_lock_irq(&mdev->tconn->req_lock);
-	_drbd_wait_ee_list_empty(mdev, head);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
+	_drbd_wait_ee_list_empty(device, head);
+	spin_unlock_irq(&device->tconn->req_lock);
 }
 
 static int drbd_recv_short(struct socket *sock, void *buf, size_t size, int flags)
@@ -831,28 +831,28 @@ static int drbd_socket_okay(struct socket **sock)
 }
 /* Gets called if a connection is established, or if a new minor gets created
    in a connection */
-int drbd_connected(struct drbd_device *mdev)
+int drbd_connected(struct drbd_device *device)
 {
 	int err;
 
-	atomic_set(&mdev->packet_seq, 0);
-	mdev->peer_seq = 0;
+	atomic_set(&device->packet_seq, 0);
+	device->peer_seq = 0;
 
-	mdev->state_mutex = mdev->tconn->agreed_pro_version < 100 ?
-		&mdev->tconn->cstate_mutex :
-		&mdev->own_state_mutex;
+	device->state_mutex = device->tconn->agreed_pro_version < 100 ?
+		&device->tconn->cstate_mutex :
+		&device->own_state_mutex;
 
-	err = drbd_send_sync_param(mdev);
+	err = drbd_send_sync_param(device);
 	if (!err)
-		err = drbd_send_sizes(mdev, 0, 0);
+		err = drbd_send_sizes(device, 0, 0);
 	if (!err)
-		err = drbd_send_uuids(mdev);
+		err = drbd_send_uuids(device);
 	if (!err)
-		err = drbd_send_current_state(mdev);
-	clear_bit(USE_DEGR_WFC_T, &mdev->flags);
-	clear_bit(RESIZE_PENDING, &mdev->flags);
-	atomic_set(&mdev->ap_in_flight, 0);
-	mod_timer(&mdev->request_timer, jiffies + HZ); /* just start it here. */
+		err = drbd_send_current_state(device);
+	clear_bit(USE_DEGR_WFC_T, &device->flags);
+	clear_bit(RESIZE_PENDING, &device->flags);
+	atomic_set(&device->ap_in_flight, 0);
+	mod_timer(&device->request_timer, jiffies + HZ); /* just start it here. */
 	return err;
 }
 
@@ -867,7 +867,7 @@ int drbd_connected(struct drbd_device *mdev)
 static int conn_connect(struct drbd_tconn *tconn)
 {
 	struct drbd_socket sock, msock;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct net_conf *nc;
 	int vnr, timeout, h, ok;
 	bool discard_my_data;
@@ -1018,7 +1018,7 @@ randomize:
 		return h;
 
 	if (tconn->cram_hmac_tfm) {
-		/* drbd_request_state(mdev, NS(conn, WFAuth)); */
+		/* drbd_request_state(device, NS(conn, WFAuth)); */
 		switch (drbd_do_auth(tconn)) {
 		case -1:
 			conn_err(tconn, "Authentication of peer failed\n");
@@ -1038,8 +1038,8 @@ randomize:
 	set_bit(STATE_SENT, &tconn->flags);
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		kref_get(&mdev->kref);
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
+		kref_get(&device->kref);
 		rcu_read_unlock();
 
 		/* Prevent a race between resync-handshake and
@@ -1049,16 +1049,16 @@ randomize:
 		 * drbd_set_role() is finished, and any incoming drbd_set_role
 		 * will see the STATE_SENT flag, and wait for it to be cleared.
 		 */
-		mutex_lock(mdev->state_mutex);
-		mutex_unlock(mdev->state_mutex);
+		mutex_lock(device->state_mutex);
+		mutex_unlock(device->state_mutex);
 
 		if (discard_my_data)
-			set_bit(DISCARD_MY_DATA, &mdev->flags);
+			set_bit(DISCARD_MY_DATA, &device->flags);
 		else
-			clear_bit(DISCARD_MY_DATA, &mdev->flags);
+			clear_bit(DISCARD_MY_DATA, &device->flags);
 
-		drbd_connected(mdev);
-		kref_put(&mdev->kref, &drbd_minor_destroy);
+		drbd_connected(device);
+		kref_put(&device->kref, &drbd_minor_destroy);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
@@ -1145,18 +1145,18 @@ static int drbd_recv_header(struct drbd_tconn *tconn, struct packet_info *pi)
 static void drbd_flush(struct drbd_tconn *tconn)
 {
 	int rv;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 
 	if (tconn->write_ordering >= WO_bdev_flush) {
 		rcu_read_lock();
-		idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-			if (!get_ldev(mdev))
+		idr_for_each_entry(&tconn->volumes, device, vnr) {
+			if (!get_ldev(device))
 				continue;
-			kref_get(&mdev->kref);
+			kref_get(&device->kref);
 			rcu_read_unlock();
 
-			rv = blkdev_issue_flush(mdev->ldev->backing_bdev,
+			rv = blkdev_issue_flush(device->ldev->backing_bdev,
 					GFP_NOIO, NULL);
 			if (rv) {
 				dev_info(DEV, "local disk flush failed with status %d\n", rv);
@@ -1165,8 +1165,8 @@ static void drbd_flush(struct drbd_tconn *tconn)
 				 * if (rv == -EOPNOTSUPP) */
 				drbd_bump_write_ordering(tconn, WO_drain_io);
 			}
-			put_ldev(mdev);
-			kref_put(&mdev->kref, &drbd_minor_destroy);
+			put_ldev(device);
+			kref_put(&device->kref, &drbd_minor_destroy);
 
 			rcu_read_lock();
 			if (rv)
@@ -1178,7 +1178,7 @@ static void drbd_flush(struct drbd_tconn *tconn)
 
 /**
  * drbd_may_finish_epoch() - Applies an epoch_event to the epoch's state, eventually finishes it.
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @epoch:	Epoch object.
  * @ev:		Epoch event.
  */
@@ -1260,7 +1260,7 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_tconn *tconn,
 void drbd_bump_write_ordering(struct drbd_tconn *tconn, enum write_ordering_e wo)
 {
 	struct disk_conf *dc;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	enum write_ordering_e pwo;
 	int vnr;
 	static char *write_ordering_str[] = {
@@ -1272,16 +1272,16 @@ void drbd_bump_write_ordering(struct drbd_tconn *tconn, enum write_ordering_e wo
 	pwo = tconn->write_ordering;
 	wo = min(pwo, wo);
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		if (!get_ldev_if_state(mdev, D_ATTACHING))
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
+		if (!get_ldev_if_state(device, D_ATTACHING))
 			continue;
-		dc = rcu_dereference(mdev->ldev->disk_conf);
+		dc = rcu_dereference(device->ldev->disk_conf);
 
 		if (wo == WO_bdev_flush && !dc->disk_flushes)
 			wo = WO_drain_io;
 		if (wo == WO_drain_io && !dc->disk_drain)
 			wo = WO_none;
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 	rcu_read_unlock();
 	tconn->write_ordering = wo;
@@ -1291,7 +1291,7 @@ void drbd_bump_write_ordering(struct drbd_tconn *tconn, enum write_ordering_e wo
 
 /**
  * drbd_submit_peer_request()
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @peer_req:	peer request
  * @rw:		flag field, see bio->bi_rw
  *
@@ -1306,7 +1306,7 @@ void drbd_bump_write_ordering(struct drbd_tconn *tconn, enum write_ordering_e wo
  *  on certain Xen deployments.
  */
 /* TODO allocate from our own bio_set. */
-int drbd_submit_peer_request(struct drbd_device *mdev,
+int drbd_submit_peer_request(struct drbd_device *device,
 			     struct drbd_peer_request *peer_req,
 			     const unsigned rw, const int fault_type)
 {
@@ -1335,7 +1335,7 @@ next_bio:
 	}
 	/* > peer_req->i.sector, unless this is the first bio */
 	bio->bi_iter.bi_sector = sector;
-	bio->bi_bdev = mdev->ldev->backing_bdev;
+	bio->bi_bdev = device->ldev->backing_bdev;
 	bio->bi_rw = rw;
 	bio->bi_private = peer_req;
 	bio->bi_end_io = drbd_peer_request_endio;
@@ -1373,7 +1373,7 @@ next_bio:
 		bios = bios->bi_next;
 		bio->bi_next = NULL;
 
-		drbd_generic_make_request(mdev, fault_type, bio);
+		drbd_generic_make_request(device, fault_type, bio);
 	} while (bios);
 	return 0;
 
@@ -1386,30 +1386,30 @@ fail:
 	return err;
 }
 
-static void drbd_remove_epoch_entry_interval(struct drbd_device *mdev,
+static void drbd_remove_epoch_entry_interval(struct drbd_device *device,
 					     struct drbd_peer_request *peer_req)
 {
 	struct drbd_interval *i = &peer_req->i;
 
-	drbd_remove_interval(&mdev->write_requests, i);
+	drbd_remove_interval(&device->write_requests, i);
 	drbd_clear_interval(i);
 
 	/* Wake up any processes waiting for this peer request to complete.  */
 	if (i->waiting)
-		wake_up(&mdev->misc_wait);
+		wake_up(&device->misc_wait);
 }
 
 void conn_wait_active_ee_empty(struct drbd_tconn *tconn)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		kref_get(&mdev->kref);
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
+		kref_get(&device->kref);
 		rcu_read_unlock();
-		drbd_wait_ee_list_empty(mdev, &mdev->active_ee);
-		kref_put(&mdev->kref, &drbd_minor_destroy);
+		drbd_wait_ee_list_empty(device, &device->active_ee);
+		kref_put(&device->kref, &drbd_minor_destroy);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
@@ -1485,25 +1485,25 @@ static int receive_Barrier(struct drbd_tconn *tconn, struct packet_info *pi)
 /* used from receive_RSDataReply (recv_resync_read)
  * and from receive_Data */
 static struct drbd_peer_request *
-read_in_block(struct drbd_device *mdev, u64 id, sector_t sector,
+read_in_block(struct drbd_device *device, u64 id, sector_t sector,
 	      int data_size) __must_hold(local)
 {
-	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
+	const sector_t capacity = drbd_get_capacity(device->this_bdev);
 	struct drbd_peer_request *peer_req;
 	struct page *page;
 	int dgs, ds, err;
-	void *dig_in = mdev->tconn->int_dig_in;
-	void *dig_vv = mdev->tconn->int_dig_vv;
+	void *dig_in = device->tconn->int_dig_in;
+	void *dig_vv = device->tconn->int_dig_vv;
 	unsigned long *data;
 
 	dgs = 0;
-	if (mdev->tconn->peer_integrity_tfm) {
-		dgs = crypto_hash_digestsize(mdev->tconn->peer_integrity_tfm);
+	if (device->tconn->peer_integrity_tfm) {
+		dgs = crypto_hash_digestsize(device->tconn->peer_integrity_tfm);
 		/*
 		 * FIXME: Receive the incoming digest into the receive buffer
 		 *	  here, together with its struct p_data?
 		 */
-		err = drbd_recv_all_warn(mdev->tconn, dig_in, dgs);
+		err = drbd_recv_all_warn(device->tconn, dig_in, dgs);
 		if (err)
 			return NULL;
 		data_size -= dgs;
@@ -1527,7 +1527,7 @@ read_in_block(struct drbd_device *mdev, u64 id, sector_t sector,
 	/* GFP_NOIO, because we must not cause arbitrary write-out: in a DRBD
 	 * "criss-cross" setup, that might cause write-out on some other DRBD,
 	 * which in turn might block on the other node at this very place.  */
-	peer_req = drbd_alloc_peer_req(mdev, id, sector, data_size, GFP_NOIO);
+	peer_req = drbd_alloc_peer_req(device, id, sector, data_size, GFP_NOIO);
 	if (!peer_req)
 		return NULL;
 
@@ -1539,36 +1539,36 @@ read_in_block(struct drbd_device *mdev, u64 id, sector_t sector,
 	page_chain_for_each(page) {
 		unsigned len = min_t(int, ds, PAGE_SIZE);
 		data = kmap(page);
-		err = drbd_recv_all_warn(mdev->tconn, data, len);
-		if (drbd_insert_fault(mdev, DRBD_FAULT_RECEIVE)) {
+		err = drbd_recv_all_warn(device->tconn, data, len);
+		if (drbd_insert_fault(device, DRBD_FAULT_RECEIVE)) {
 			dev_err(DEV, "Fault injection: Corrupting data on receive\n");
 			data[0] = data[0] ^ (unsigned long)-1;
 		}
 		kunmap(page);
 		if (err) {
-			drbd_free_peer_req(mdev, peer_req);
+			drbd_free_peer_req(device, peer_req);
 			return NULL;
 		}
 		ds -= len;
 	}
 
 	if (dgs) {
-		drbd_csum_ee(mdev, mdev->tconn->peer_integrity_tfm, peer_req, dig_vv);
+		drbd_csum_ee(device, device->tconn->peer_integrity_tfm, peer_req, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			dev_err(DEV, "Digest integrity check FAILED: %llus +%u\n",
 				(unsigned long long)sector, data_size);
-			drbd_free_peer_req(mdev, peer_req);
+			drbd_free_peer_req(device, peer_req);
 			return NULL;
 		}
 	}
-	mdev->recv_cnt += data_size>>9;
+	device->recv_cnt += data_size>>9;
 	return peer_req;
 }
 
 /* drbd_drain_block() just takes a data block
  * out of the socket input buffer, and discards it.
  */
-static int drbd_drain_block(struct drbd_device *mdev, int data_size)
+static int drbd_drain_block(struct drbd_device *device, int data_size)
 {
 	struct page *page;
 	int err = 0;
@@ -1577,36 +1577,36 @@ static int drbd_drain_block(struct drbd_device *mdev, int data_size)
 	if (!data_size)
 		return 0;
 
-	page = drbd_alloc_pages(mdev, 1, 1);
+	page = drbd_alloc_pages(device, 1, 1);
 
 	data = kmap(page);
 	while (data_size) {
 		unsigned int len = min_t(int, data_size, PAGE_SIZE);
 
-		err = drbd_recv_all_warn(mdev->tconn, data, len);
+		err = drbd_recv_all_warn(device->tconn, data, len);
 		if (err)
 			break;
 		data_size -= len;
 	}
 	kunmap(page);
-	drbd_free_pages(mdev, page, 0);
+	drbd_free_pages(device, page, 0);
 	return err;
 }
 
-static int recv_dless_read(struct drbd_device *mdev, struct drbd_request *req,
+static int recv_dless_read(struct drbd_device *device, struct drbd_request *req,
 			   sector_t sector, int data_size)
 {
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	struct bio *bio;
 	int dgs, err, expect;
-	void *dig_in = mdev->tconn->int_dig_in;
-	void *dig_vv = mdev->tconn->int_dig_vv;
+	void *dig_in = device->tconn->int_dig_in;
+	void *dig_vv = device->tconn->int_dig_vv;
 
 	dgs = 0;
-	if (mdev->tconn->peer_integrity_tfm) {
-		dgs = crypto_hash_digestsize(mdev->tconn->peer_integrity_tfm);
-		err = drbd_recv_all_warn(mdev->tconn, dig_in, dgs);
+	if (device->tconn->peer_integrity_tfm) {
+		dgs = crypto_hash_digestsize(device->tconn->peer_integrity_tfm);
+		err = drbd_recv_all_warn(device->tconn, dig_in, dgs);
 		if (err)
 			return err;
 		data_size -= dgs;
@@ -1614,7 +1614,7 @@ static int recv_dless_read(struct drbd_device *mdev, struct drbd_request *req,
 
 	/* optimistically update recv_cnt.  if receiving fails below,
 	 * we disconnect anyways, and counters will be reset. */
-	mdev->recv_cnt += data_size>>9;
+	device->recv_cnt += data_size>>9;
 
 	bio = req->master_bio;
 	D_ASSERT(sector == bio->bi_iter.bi_sector);
@@ -1622,7 +1622,7 @@ static int recv_dless_read(struct drbd_device *mdev, struct drbd_request *req,
 	bio_for_each_segment(bvec, bio, iter) {
 		void *mapped = kmap(bvec.bv_page) + bvec.bv_offset;
 		expect = min_t(int, data_size, bvec.bv_len);
-		err = drbd_recv_all_warn(mdev->tconn, mapped, expect);
+		err = drbd_recv_all_warn(device->tconn, mapped, expect);
 		kunmap(bvec.bv_page);
 		if (err)
 			return err;
@@ -1630,7 +1630,7 @@ static int recv_dless_read(struct drbd_device *mdev, struct drbd_request *req,
 	}
 
 	if (dgs) {
-		drbd_csum_bio(mdev, mdev->tconn->peer_integrity_tfm, bio, dig_vv);
+		drbd_csum_bio(device, device->tconn->peer_integrity_tfm, bio, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			dev_err(DEV, "Digest integrity check FAILED. Broken NICs?\n");
 			return -EINVAL;
@@ -1649,64 +1649,64 @@ static int e_end_resync_block(struct drbd_work *w, int unused)
 {
 	struct drbd_peer_request *peer_req =
 		container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	sector_t sector = peer_req->i.sector;
 	int err;
 
 	D_ASSERT(drbd_interval_empty(&peer_req->i));
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
-		drbd_set_in_sync(mdev, sector, peer_req->i.size);
-		err = drbd_send_ack(mdev, P_RS_WRITE_ACK, peer_req);
+		drbd_set_in_sync(device, sector, peer_req->i.size);
+		err = drbd_send_ack(device, P_RS_WRITE_ACK, peer_req);
 	} else {
 		/* Record failure to sync */
-		drbd_rs_failed_io(mdev, sector, peer_req->i.size);
+		drbd_rs_failed_io(device, sector, peer_req->i.size);
 
-		err  = drbd_send_ack(mdev, P_NEG_ACK, peer_req);
+		err  = drbd_send_ack(device, P_NEG_ACK, peer_req);
 	}
-	dec_unacked(mdev);
+	dec_unacked(device);
 
 	return err;
 }
 
-static int recv_resync_read(struct drbd_device *mdev, sector_t sector, int data_size) __releases(local)
+static int recv_resync_read(struct drbd_device *device, sector_t sector, int data_size) __releases(local)
 {
 	struct drbd_peer_request *peer_req;
 
-	peer_req = read_in_block(mdev, ID_SYNCER, sector, data_size);
+	peer_req = read_in_block(device, ID_SYNCER, sector, data_size);
 	if (!peer_req)
 		goto fail;
 
-	dec_rs_pending(mdev);
+	dec_rs_pending(device);
 
-	inc_unacked(mdev);
+	inc_unacked(device);
 	/* corresponding dec_unacked() in e_end_resync_block()
 	 * respective _drbd_clear_done_ee */
 
 	peer_req->w.cb = e_end_resync_block;
 
-	spin_lock_irq(&mdev->tconn->req_lock);
-	list_add(&peer_req->w.list, &mdev->sync_ee);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
+	list_add(&peer_req->w.list, &device->sync_ee);
+	spin_unlock_irq(&device->tconn->req_lock);
 
-	atomic_add(data_size >> 9, &mdev->rs_sect_ev);
-	if (drbd_submit_peer_request(mdev, peer_req, WRITE, DRBD_FAULT_RS_WR) == 0)
+	atomic_add(data_size >> 9, &device->rs_sect_ev);
+	if (drbd_submit_peer_request(device, peer_req, WRITE, DRBD_FAULT_RS_WR) == 0)
 		return 0;
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
 	list_del(&peer_req->w.list);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_unlock_irq(&device->tconn->req_lock);
 
-	drbd_free_peer_req(mdev, peer_req);
+	drbd_free_peer_req(device, peer_req);
 fail:
-	put_ldev(mdev);
+	put_ldev(device);
 	return -EIO;
 }
 
 static struct drbd_request *
-find_request(struct drbd_device *mdev, struct rb_root *root, u64 id,
+find_request(struct drbd_device *device, struct rb_root *root, u64 id,
 	     sector_t sector, bool missing_ok, const char *func)
 {
 	struct drbd_request *req;
@@ -1724,28 +1724,28 @@ find_request(struct drbd_device *mdev, struct rb_root *root, u64 id,
 
 static int receive_DataReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct drbd_request *req;
 	sector_t sector;
 	int err;
 	struct p_data *p = pi->data;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
 	sector = be64_to_cpu(p->sector);
 
-	spin_lock_irq(&mdev->tconn->req_lock);
-	req = find_request(mdev, &mdev->read_requests, p->block_id, sector, false, __func__);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
+	req = find_request(device, &device->read_requests, p->block_id, sector, false, __func__);
+	spin_unlock_irq(&device->tconn->req_lock);
 	if (unlikely(!req))
 		return -EIO;
 
 	/* hlist_del(&req->collision) is done in _req_may_be_done, to avoid
 	 * special casing it there for the various failure cases.
 	 * still no race with drbd_fail_pending_reads */
-	err = recv_dless_read(mdev, req, sector, pi->size);
+	err = recv_dless_read(device, req, sector, pi->size);
 	if (!err)
 		req_mod(req, DATA_RECEIVED);
 	/* else: nothing. handled from drbd_disconnect...
@@ -1757,44 +1757,44 @@ static int receive_DataReply(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int receive_RSDataReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	sector_t sector;
 	int err;
 	struct p_data *p = pi->data;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
 	sector = be64_to_cpu(p->sector);
 	D_ASSERT(p->block_id == ID_SYNCER);
 
-	if (get_ldev(mdev)) {
+	if (get_ldev(device)) {
 		/* data is submitted to disk within recv_resync_read.
 		 * corresponding put_ldev done below on error,
 		 * or in drbd_peer_request_endio. */
-		err = recv_resync_read(mdev, sector, pi->size);
+		err = recv_resync_read(device, sector, pi->size);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Can not write resync data to local disk.\n");
 
-		err = drbd_drain_block(mdev, pi->size);
+		err = drbd_drain_block(device, pi->size);
 
-		drbd_send_ack_dp(mdev, P_NEG_ACK, p, pi->size);
+		drbd_send_ack_dp(device, P_NEG_ACK, p, pi->size);
 	}
 
-	atomic_add(pi->size >> 9, &mdev->rs_sect_in);
+	atomic_add(pi->size >> 9, &device->rs_sect_in);
 
 	return err;
 }
 
-static void restart_conflicting_writes(struct drbd_device *mdev,
+static void restart_conflicting_writes(struct drbd_device *device,
 				       sector_t sector, int size)
 {
 	struct drbd_interval *i;
 	struct drbd_request *req;
 
-	drbd_for_each_overlap(i, &mdev->write_requests, sector, size) {
+	drbd_for_each_overlap(i, &device->write_requests, sector, size) {
 		if (!i->local)
 			continue;
 		req = container_of(i, struct drbd_request, i);
@@ -1814,52 +1814,52 @@ static int e_end_block(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req =
 		container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	sector_t sector = peer_req->i.sector;
 	int err = 0, pcmd;
 
 	if (peer_req->flags & EE_SEND_WRITE_ACK) {
 		if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
-			pcmd = (mdev->state.conn >= C_SYNC_SOURCE &&
-				mdev->state.conn <= C_PAUSED_SYNC_T &&
+			pcmd = (device->state.conn >= C_SYNC_SOURCE &&
+				device->state.conn <= C_PAUSED_SYNC_T &&
 				peer_req->flags & EE_MAY_SET_IN_SYNC) ?
 				P_RS_WRITE_ACK : P_WRITE_ACK;
-			err = drbd_send_ack(mdev, pcmd, peer_req);
+			err = drbd_send_ack(device, pcmd, peer_req);
 			if (pcmd == P_RS_WRITE_ACK)
-				drbd_set_in_sync(mdev, sector, peer_req->i.size);
+				drbd_set_in_sync(device, sector, peer_req->i.size);
 		} else {
-			err = drbd_send_ack(mdev, P_NEG_ACK, peer_req);
+			err = drbd_send_ack(device, P_NEG_ACK, peer_req);
 			/* we expect it to be marked out of sync anyways...
 			 * maybe assert this?  */
 		}
-		dec_unacked(mdev);
+		dec_unacked(device);
 	}
 	/* we delete from the conflict detection hash _after_ we sent out the
 	 * P_WRITE_ACK / P_NEG_ACK, to get the sequence number right.  */
 	if (peer_req->flags & EE_IN_INTERVAL_TREE) {
-		spin_lock_irq(&mdev->tconn->req_lock);
+		spin_lock_irq(&device->tconn->req_lock);
 		D_ASSERT(!drbd_interval_empty(&peer_req->i));
-		drbd_remove_epoch_entry_interval(mdev, peer_req);
+		drbd_remove_epoch_entry_interval(device, peer_req);
 		if (peer_req->flags & EE_RESTART_REQUESTS)
-			restart_conflicting_writes(mdev, sector, peer_req->i.size);
-		spin_unlock_irq(&mdev->tconn->req_lock);
+			restart_conflicting_writes(device, sector, peer_req->i.size);
+		spin_unlock_irq(&device->tconn->req_lock);
 	} else
 		D_ASSERT(drbd_interval_empty(&peer_req->i));
 
-	drbd_may_finish_epoch(mdev->tconn, peer_req->epoch, EV_PUT + (cancel ? EV_CLEANUP : 0));
+	drbd_may_finish_epoch(device->tconn, peer_req->epoch, EV_PUT + (cancel ? EV_CLEANUP : 0));
 
 	return err;
 }
 
 static int e_send_ack(struct drbd_work *w, enum drbd_packet ack)
 {
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	struct drbd_peer_request *peer_req =
 		container_of(w, struct drbd_peer_request, w);
 	int err;
 
-	err = drbd_send_ack(mdev, ack, peer_req);
-	dec_unacked(mdev);
+	err = drbd_send_ack(device, ack, peer_req);
+	dec_unacked(device);
 
 	return err;
 }
@@ -1871,7 +1871,7 @@ static int e_send_superseded(struct drbd_work *w, int unused)
 
 static int e_send_retry_write(struct drbd_work *w, int unused)
 {
-	struct drbd_tconn *tconn = w->mdev->tconn;
+	struct drbd_tconn *tconn = w->device->tconn;
 
 	return e_send_ack(w, tconn->agreed_pro_version >= 100 ?
 			     P_RETRY_WRITE : P_SUPERSEDED);
@@ -1892,18 +1892,19 @@ static u32 seq_max(u32 a, u32 b)
 	return seq_greater(a, b) ? a : b;
 }
 
-static void update_peer_seq(struct drbd_conf *mdev, unsigned int peer_seq)
+
+static void update_peer_seq(struct drbd_device *device, unsigned int peer_seq)
 {
 	unsigned int newest_peer_seq;
 
-	if (test_bit(RESOLVE_CONFLICTS, &mdev->tconn->flags)) {
-		spin_lock(&mdev->peer_seq_lock);
-		newest_peer_seq = seq_max(mdev->peer_seq, peer_seq);
-		mdev->peer_seq = newest_peer_seq;
-		spin_unlock(&mdev->peer_seq_lock);
-		/* wake up only if we actually changed mdev->peer_seq */
+	if (test_bit(RESOLVE_CONFLICTS, &device->tconn->flags)) {
+		spin_lock(&device->peer_seq_lock);
+		newest_peer_seq = seq_max(device->peer_seq, peer_seq);
+		device->peer_seq = newest_peer_seq;
+		spin_unlock(&device->peer_seq_lock);
+		/* wake up only if we actually changed device->peer_seq */
 		if (peer_seq == newest_peer_seq)
-			wake_up(&mdev->seq_wait);
+			wake_up(&device->seq_wait);
 	}
 }
 
@@ -1913,20 +1914,20 @@ static inline int overlaps(sector_t s1, int l1, sector_t s2, int l2)
 }
 
 /* maybe change sync_ee into interval trees as well? */
-static bool overlapping_resync_write(struct drbd_device *mdev, struct drbd_peer_request *peer_req)
+static bool overlapping_resync_write(struct drbd_device *device, struct drbd_peer_request *peer_req)
 {
 	struct drbd_peer_request *rs_req;
 	bool rv = 0;
 
-	spin_lock_irq(&mdev->tconn->req_lock);
-	list_for_each_entry(rs_req, &mdev->sync_ee, w.list) {
+	spin_lock_irq(&device->tconn->req_lock);
+	list_for_each_entry(rs_req, &device->sync_ee, w.list) {
 		if (overlaps(peer_req->i.sector, peer_req->i.size,
 			     rs_req->i.sector, rs_req->i.size)) {
 			rv = 1;
 			break;
 		}
 	}
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_unlock_irq(&device->tconn->req_lock);
 
 	return rv;
 }
@@ -1940,9 +1941,9 @@ static bool overlapping_resync_write(struct drbd_device *mdev, struct drbd_peer_
  *
  * Note: we don't care for Ack packets overtaking P_DATA packets.
  *
- * In case packet_seq is larger than mdev->peer_seq number, there are
+ * In case packet_seq is larger than device->peer_seq number, there are
  * outstanding packets on the msock. We wait for them to arrive.
- * In case we are the logically next packet, we update mdev->peer_seq
+ * In case we are the logically next packet, we update device->peer_seq
  * ourselves. Correctly handles 32bit wrap around.
  *
  * Assume we have a 10 GBit connection, that is about 1<<30 byte per second,
@@ -1952,19 +1953,19 @@ static bool overlapping_resync_write(struct drbd_device *mdev, struct drbd_peer_
  *
  * returns 0 if we may process the packet,
  * -ERESTARTSYS if we were interrupted (by disconnect signal). */
-static int wait_for_and_update_peer_seq(struct drbd_device *mdev, const u32 peer_seq)
+static int wait_for_and_update_peer_seq(struct drbd_device *device, const u32 peer_seq)
 {
 	DEFINE_WAIT(wait);
 	long timeout;
 	int ret = 0, tp;
 
-	if (!test_bit(RESOLVE_CONFLICTS, &mdev->tconn->flags))
+	if (!test_bit(RESOLVE_CONFLICTS, &device->tconn->flags))
 		return 0;
 
-	spin_lock(&mdev->peer_seq_lock);
+	spin_lock(&device->peer_seq_lock);
 	for (;;) {
-		if (!seq_greater(peer_seq - 1, mdev->peer_seq)) {
-			mdev->peer_seq = seq_max(mdev->peer_seq, peer_seq);
+		if (!seq_greater(peer_seq - 1, device->peer_seq)) {
+			device->peer_seq = seq_max(device->peer_seq, peer_seq);
 			break;
 		}
 
@@ -1974,35 +1975,35 @@ static int wait_for_and_update_peer_seq(struct drbd_device *mdev, const u32 peer
 		}
 
 		rcu_read_lock();
-		tp = rcu_dereference(mdev->tconn->net_conf)->two_primaries;
+		tp = rcu_dereference(device->tconn->net_conf)->two_primaries;
 		rcu_read_unlock();
 
 		if (!tp)
 			break;
 
 		/* Only need to wait if two_primaries is enabled */
-		prepare_to_wait(&mdev->seq_wait, &wait, TASK_INTERRUPTIBLE);
-		spin_unlock(&mdev->peer_seq_lock);
+		prepare_to_wait(&device->seq_wait, &wait, TASK_INTERRUPTIBLE);
+		spin_unlock(&device->peer_seq_lock);
 		rcu_read_lock();
-		timeout = rcu_dereference(mdev->tconn->net_conf)->ping_timeo*HZ/10;
+		timeout = rcu_dereference(device->tconn->net_conf)->ping_timeo*HZ/10;
 		rcu_read_unlock();
 		timeout = schedule_timeout(timeout);
-		spin_lock(&mdev->peer_seq_lock);
+		spin_lock(&device->peer_seq_lock);
 		if (!timeout) {
 			ret = -ETIMEDOUT;
 			dev_err(DEV, "Timed out waiting for missing ack packets; disconnecting\n");
 			break;
 		}
 	}
-	spin_unlock(&mdev->peer_seq_lock);
-	finish_wait(&mdev->seq_wait, &wait);
+	spin_unlock(&device->peer_seq_lock);
+	finish_wait(&device->seq_wait, &wait);
 	return ret;
 }
 
 /* see also bio_flags_to_wire()
  * DRBD_REQ_*, because we need to semantically map the flags to data packet
  * flags and back. We may replicate to other kernel versions. */
-static unsigned long wire_flags_to_bio(struct drbd_device *mdev, u32 dpf)
+static unsigned long wire_flags_to_bio(struct drbd_device *device, u32 dpf)
 {
 	return  (dpf & DP_RW_SYNC ? REQ_SYNC : 0) |
 		(dpf & DP_FUA ? REQ_FUA : 0) |
@@ -2010,13 +2011,13 @@ static unsigned long wire_flags_to_bio(struct drbd_device *mdev, u32 dpf)
 		(dpf & DP_DISCARD ? REQ_DISCARD : 0);
 }
 
-static void fail_postponed_requests(struct drbd_device *mdev, sector_t sector,
+static void fail_postponed_requests(struct drbd_device *device, sector_t sector,
 				    unsigned int size)
 {
 	struct drbd_interval *i;
 
     repeat:
-	drbd_for_each_overlap(i, &mdev->write_requests, sector, size) {
+	drbd_for_each_overlap(i, &device->write_requests, sector, size) {
 		struct drbd_request *req;
 		struct bio_and_error m;
 
@@ -2027,18 +2028,18 @@ static void fail_postponed_requests(struct drbd_device *mdev, sector_t sector,
 			continue;
 		req->rq_state &= ~RQ_POSTPONED;
 		__req_mod(req, NEG_ACKED, &m);
-		spin_unlock_irq(&mdev->tconn->req_lock);
+		spin_unlock_irq(&device->tconn->req_lock);
 		if (m.bio)
-			complete_master_bio(mdev, &m);
-		spin_lock_irq(&mdev->tconn->req_lock);
+			complete_master_bio(device, &m);
+		spin_lock_irq(&device->tconn->req_lock);
 		goto repeat;
 	}
 }
 
-static int handle_write_conflicts(struct drbd_device *mdev,
+static int handle_write_conflicts(struct drbd_device *device,
 				  struct drbd_peer_request *peer_req)
 {
-	struct drbd_tconn *tconn = mdev->tconn;
+	struct drbd_tconn *tconn = device->tconn;
 	bool resolve_conflicts = test_bit(RESOLVE_CONFLICTS, &tconn->flags);
 	sector_t sector = peer_req->i.sector;
 	const unsigned int size = peer_req->i.size;
@@ -2050,10 +2051,10 @@ static int handle_write_conflicts(struct drbd_device *mdev,
 	 * Inserting the peer request into the write_requests tree will prevent
 	 * new conflicting local requests from being added.
 	 */
-	drbd_insert_interval(&mdev->write_requests, &peer_req->i);
+	drbd_insert_interval(&device->write_requests, &peer_req->i);
 
     repeat:
-	drbd_for_each_overlap(i, &mdev->write_requests, sector, size) {
+	drbd_for_each_overlap(i, &device->write_requests, sector, size) {
 		if (i == &peer_req->i)
 			continue;
 
@@ -2063,7 +2064,7 @@ static int handle_write_conflicts(struct drbd_device *mdev,
 			 * should not happen in a two-node setup.  Wait for the
 			 * earlier peer request to complete.
 			 */
-			err = drbd_wait_misc(mdev, i);
+			err = drbd_wait_misc(device, i);
 			if (err)
 				goto out;
 			goto repeat;
@@ -2088,11 +2089,11 @@ static int handle_write_conflicts(struct drbd_device *mdev,
 					  (unsigned long long)sector, size,
 					  superseded ? "local" : "remote");
 
-			inc_unacked(mdev);
+			inc_unacked(device);
 			peer_req->w.cb = superseded ? e_send_superseded :
 						   e_send_retry_write;
-			list_add_tail(&peer_req->w.list, &mdev->done_ee);
-			wake_asender(mdev->tconn);
+			list_add_tail(&peer_req->w.list, &device->done_ee);
+			wake_asender(device->tconn);
 
 			err = -ENOENT;
 			goto out;
@@ -2119,12 +2120,12 @@ static int handle_write_conflicts(struct drbd_device *mdev,
 				 * request to finish locally before submitting
 				 * the conflicting peer request.
 				 */
-				err = drbd_wait_misc(mdev, &req->i);
+				err = drbd_wait_misc(device, &req->i);
 				if (err) {
-					_conn_request_state(mdev->tconn,
+					_conn_request_state(device->tconn,
 							    NS(conn, C_TIMEOUT),
 							    CS_HARD);
-					fail_postponed_requests(mdev, sector, size);
+					fail_postponed_requests(device, sector, size);
 					goto out;
 				}
 				goto repeat;
@@ -2140,14 +2141,14 @@ static int handle_write_conflicts(struct drbd_device *mdev,
 
     out:
 	if (err)
-		drbd_remove_epoch_entry_interval(mdev, peer_req);
+		drbd_remove_epoch_entry_interval(device, peer_req);
 	return err;
 }
 
 /* mirrored write */
 static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	sector_t sector;
 	struct drbd_peer_request *peer_req;
 	struct p_data *p = pi->data;
@@ -2156,17 +2157,17 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 	u32 dp_flags;
 	int err, tp;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
-	if (!get_ldev(mdev)) {
+	if (!get_ldev(device)) {
 		int err2;
 
-		err = wait_for_and_update_peer_seq(mdev, peer_seq);
-		drbd_send_ack_dp(mdev, P_NEG_ACK, p, pi->size);
+		err = wait_for_and_update_peer_seq(device, peer_seq);
+		drbd_send_ack_dp(device, P_NEG_ACK, p, pi->size);
 		atomic_inc(&tconn->current_epoch->epoch_size);
-		err2 = drbd_drain_block(mdev, pi->size);
+		err2 = drbd_drain_block(device, pi->size);
 		if (!err)
 			err = err2;
 		return err;
@@ -2179,16 +2180,16 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 	 */
 
 	sector = be64_to_cpu(p->sector);
-	peer_req = read_in_block(mdev, p->block_id, sector, pi->size);
+	peer_req = read_in_block(device, p->block_id, sector, pi->size);
 	if (!peer_req) {
-		put_ldev(mdev);
+		put_ldev(device);
 		return -EIO;
 	}
 
 	peer_req->w.cb = e_end_block;
 
 	dp_flags = be32_to_cpu(p->dp_flags);
-	rw |= wire_flags_to_bio(mdev, dp_flags);
+	rw |= wire_flags_to_bio(device, dp_flags);
 	if (peer_req->pages == NULL) {
 		D_ASSERT(peer_req->i.size == 0);
 		D_ASSERT(dp_flags & DP_FLUSH);
@@ -2204,36 +2205,36 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 	spin_unlock(&tconn->epoch_lock);
 
 	rcu_read_lock();
-	tp = rcu_dereference(mdev->tconn->net_conf)->two_primaries;
+	tp = rcu_dereference(device->tconn->net_conf)->two_primaries;
 	rcu_read_unlock();
 	if (tp) {
 		peer_req->flags |= EE_IN_INTERVAL_TREE;
-		err = wait_for_and_update_peer_seq(mdev, peer_seq);
+		err = wait_for_and_update_peer_seq(device, peer_seq);
 		if (err)
 			goto out_interrupted;
-		spin_lock_irq(&mdev->tconn->req_lock);
-		err = handle_write_conflicts(mdev, peer_req);
+		spin_lock_irq(&device->tconn->req_lock);
+		err = handle_write_conflicts(device, peer_req);
 		if (err) {
-			spin_unlock_irq(&mdev->tconn->req_lock);
+			spin_unlock_irq(&device->tconn->req_lock);
 			if (err == -ENOENT) {
-				put_ldev(mdev);
+				put_ldev(device);
 				return 0;
 			}
 			goto out_interrupted;
 		}
 	} else {
-		update_peer_seq(mdev, peer_seq);
-		spin_lock_irq(&mdev->tconn->req_lock);
+		update_peer_seq(device, peer_seq);
+		spin_lock_irq(&device->tconn->req_lock);
 	}
-	list_add(&peer_req->w.list, &mdev->active_ee);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	list_add(&peer_req->w.list, &device->active_ee);
+	spin_unlock_irq(&device->tconn->req_lock);
 
-	if (mdev->state.conn == C_SYNC_TARGET)
-		wait_event(mdev->ee_wait, !overlapping_resync_write(mdev, peer_req));
+	if (device->state.conn == C_SYNC_TARGET)
+		wait_event(device->ee_wait, !overlapping_resync_write(device, peer_req));
 
-	if (mdev->tconn->agreed_pro_version < 100) {
+	if (device->tconn->agreed_pro_version < 100) {
 		rcu_read_lock();
-		switch (rcu_dereference(mdev->tconn->net_conf)->wire_protocol) {
+		switch (rcu_dereference(device->tconn->net_conf)->wire_protocol) {
 		case DRBD_PROT_C:
 			dp_flags |= DP_SEND_WRITE_ACK;
 			break;
@@ -2246,7 +2247,7 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	if (dp_flags & DP_SEND_WRITE_ACK) {
 		peer_req->flags |= EE_SEND_WRITE_ACK;
-		inc_unacked(mdev);
+		inc_unacked(device);
 		/* corresponding dec_unacked() in e_end_block()
 		 * respective _drbd_clear_done_ee */
 	}
@@ -2254,34 +2255,34 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 	if (dp_flags & DP_SEND_RECEIVE_ACK) {
 		/* I really don't like it that the receiver thread
 		 * sends on the msock, but anyways */
-		drbd_send_ack(mdev, P_RECV_ACK, peer_req);
+		drbd_send_ack(device, P_RECV_ACK, peer_req);
 	}
 
-	if (mdev->state.pdsk < D_INCONSISTENT) {
+	if (device->state.pdsk < D_INCONSISTENT) {
 		/* In case we have the only disk of the cluster, */
-		drbd_set_out_of_sync(mdev, peer_req->i.sector, peer_req->i.size);
+		drbd_set_out_of_sync(device, peer_req->i.sector, peer_req->i.size);
 		peer_req->flags |= EE_CALL_AL_COMPLETE_IO;
 		peer_req->flags &= ~EE_MAY_SET_IN_SYNC;
-		drbd_al_begin_io(mdev, &peer_req->i, true);
+		drbd_al_begin_io(device, &peer_req->i, true);
 	}
 
-	err = drbd_submit_peer_request(mdev, peer_req, rw, DRBD_FAULT_DT_WR);
+	err = drbd_submit_peer_request(device, peer_req, rw, DRBD_FAULT_DT_WR);
 	if (!err)
 		return 0;
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
 	list_del(&peer_req->w.list);
-	drbd_remove_epoch_entry_interval(mdev, peer_req);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	drbd_remove_epoch_entry_interval(device, peer_req);
+	spin_unlock_irq(&device->tconn->req_lock);
 	if (peer_req->flags & EE_CALL_AL_COMPLETE_IO)
-		drbd_al_complete_io(mdev, &peer_req->i);
+		drbd_al_complete_io(device, &peer_req->i);
 
 out_interrupted:
 	drbd_may_finish_epoch(tconn, peer_req->epoch, EV_PUT + EV_CLEANUP);
-	put_ldev(mdev);
-	drbd_free_peer_req(mdev, peer_req);
+	put_ldev(device);
+	drbd_free_peer_req(device, peer_req);
 	return err;
 }
 
@@ -2296,9 +2297,9 @@ out_interrupted:
  * The current sync rate used here uses only the most recent two step marks,
  * to have a short time average so we can react faster.
  */
-int drbd_rs_should_slow_down(struct drbd_device *mdev, sector_t sector)
+int drbd_rs_should_slow_down(struct drbd_device *device, sector_t sector)
 {
-	struct gendisk *disk = mdev->ldev->backing_bdev->bd_contains->bd_disk;
+	struct gendisk *disk = device->ldev->backing_bdev->bd_contains->bd_disk;
 	unsigned long db, dt, dbdt;
 	struct lc_element *tmp;
 	int curr_events;
@@ -2306,48 +2307,48 @@ int drbd_rs_should_slow_down(struct drbd_device *mdev, sector_t sector)
 	unsigned int c_min_rate;
 
 	rcu_read_lock();
-	c_min_rate = rcu_dereference(mdev->ldev->disk_conf)->c_min_rate;
+	c_min_rate = rcu_dereference(device->ldev->disk_conf)->c_min_rate;
 	rcu_read_unlock();
 
 	/* feature disabled? */
 	if (c_min_rate == 0)
 		return 0;
 
-	spin_lock_irq(&mdev->al_lock);
-	tmp = lc_find(mdev->resync, BM_SECT_TO_EXT(sector));
+	spin_lock_irq(&device->al_lock);
+	tmp = lc_find(device->resync, BM_SECT_TO_EXT(sector));
 	if (tmp) {
 		struct bm_extent *bm_ext = lc_entry(tmp, struct bm_extent, lce);
 		if (test_bit(BME_PRIORITY, &bm_ext->flags)) {
-			spin_unlock_irq(&mdev->al_lock);
+			spin_unlock_irq(&device->al_lock);
 			return 0;
 		}
 		/* Do not slow down if app IO is already waiting for this extent */
 	}
-	spin_unlock_irq(&mdev->al_lock);
+	spin_unlock_irq(&device->al_lock);
 
 	curr_events = (int)part_stat_read(&disk->part0, sectors[0]) +
 		      (int)part_stat_read(&disk->part0, sectors[1]) -
-			atomic_read(&mdev->rs_sect_ev);
+			atomic_read(&device->rs_sect_ev);
 
-	if (!mdev->rs_last_events || curr_events - mdev->rs_last_events > 64) {
+	if (!device->rs_last_events || curr_events - device->rs_last_events > 64) {
 		unsigned long rs_left;
 		int i;
 
-		mdev->rs_last_events = curr_events;
+		device->rs_last_events = curr_events;
 
 		/* sync speed average over the last 2*DRBD_SYNC_MARK_STEP,
 		 * approx. */
-		i = (mdev->rs_last_mark + DRBD_SYNC_MARKS-1) % DRBD_SYNC_MARKS;
+		i = (device->rs_last_mark + DRBD_SYNC_MARKS-1) % DRBD_SYNC_MARKS;
 
-		if (mdev->state.conn == C_VERIFY_S || mdev->state.conn == C_VERIFY_T)
-			rs_left = mdev->ov_left;
+		if (device->state.conn == C_VERIFY_S || device->state.conn == C_VERIFY_T)
+			rs_left = device->ov_left;
 		else
-			rs_left = drbd_bm_total_weight(mdev) - mdev->rs_failed;
+			rs_left = drbd_bm_total_weight(device) - device->rs_failed;
 
-		dt = ((long)jiffies - (long)mdev->rs_mark_time[i]) / HZ;
+		dt = ((long)jiffies - (long)device->rs_mark_time[i]) / HZ;
 		if (!dt)
 			dt++;
-		db = mdev->rs_mark_left[i] - rs_left;
+		db = device->rs_mark_left[i] - rs_left;
 		dbdt = Bit2KB(db/dt);
 
 		if (dbdt > c_min_rate)
@@ -2359,7 +2360,7 @@ int drbd_rs_should_slow_down(struct drbd_device *mdev, sector_t sector)
 
 static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	sector_t sector;
 	sector_t capacity;
 	struct drbd_peer_request *peer_req;
@@ -2368,10 +2369,10 @@ static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 	unsigned int fault_type;
 	struct p_block_req *p =	pi->data;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
-	capacity = drbd_get_capacity(mdev->this_bdev);
+	capacity = drbd_get_capacity(device->this_bdev);
 
 	sector = be64_to_cpu(p->sector);
 	size   = be32_to_cpu(p->blksize);
@@ -2387,21 +2388,21 @@ static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 		return -EINVAL;
 	}
 
-	if (!get_ldev_if_state(mdev, D_UP_TO_DATE)) {
+	if (!get_ldev_if_state(device, D_UP_TO_DATE)) {
 		verb = 1;
 		switch (pi->cmd) {
 		case P_DATA_REQUEST:
-			drbd_send_ack_rp(mdev, P_NEG_DREPLY, p);
+			drbd_send_ack_rp(device, P_NEG_DREPLY, p);
 			break;
 		case P_RS_DATA_REQUEST:
 		case P_CSUM_RS_REQUEST:
 		case P_OV_REQUEST:
-			drbd_send_ack_rp(mdev, P_NEG_RS_DREPLY , p);
+			drbd_send_ack_rp(device, P_NEG_RS_DREPLY , p);
 			break;
 		case P_OV_REPLY:
 			verb = 0;
-			dec_rs_pending(mdev);
-			drbd_send_ack_ex(mdev, P_OV_RESULT, sector, size, ID_IN_SYNC);
+			dec_rs_pending(device);
+			drbd_send_ack_ex(device, P_OV_RESULT, sector, size, ID_IN_SYNC);
 			break;
 		default:
 			BUG();
@@ -2411,15 +2412,15 @@ static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 			    "no local data.\n");
 
 		/* drain possibly payload */
-		return drbd_drain_block(mdev, pi->size);
+		return drbd_drain_block(device, pi->size);
 	}
 
 	/* GFP_NOIO, because we must not cause arbitrary write-out: in a DRBD
 	 * "criss-cross" setup, that might cause write-out on some other DRBD,
 	 * which in turn might block on the other node at this very place.  */
-	peer_req = drbd_alloc_peer_req(mdev, p->block_id, sector, size, GFP_NOIO);
+	peer_req = drbd_alloc_peer_req(device, p->block_id, sector, size, GFP_NOIO);
 	if (!peer_req) {
-		put_ldev(mdev);
+		put_ldev(device);
 		return -ENOMEM;
 	}
 
@@ -2434,7 +2435,7 @@ static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 		peer_req->w.cb = w_e_end_rsdata_req;
 		fault_type = DRBD_FAULT_RS_RD;
 		/* used in the sector offset progress display */
-		mdev->bm_resync_fo = BM_SECT_TO_BIT(sector);
+		device->bm_resync_fo = BM_SECT_TO_BIT(sector);
 		break;
 
 	case P_OV_REPLY:
@@ -2450,19 +2451,19 @@ static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 		peer_req->digest = di;
 		peer_req->flags |= EE_HAS_DIGEST;
 
-		if (drbd_recv_all(mdev->tconn, di->digest, pi->size))
+		if (drbd_recv_all(device->tconn, di->digest, pi->size))
 			goto out_free_e;
 
 		if (pi->cmd == P_CSUM_RS_REQUEST) {
-			D_ASSERT(mdev->tconn->agreed_pro_version >= 89);
+			D_ASSERT(device->tconn->agreed_pro_version >= 89);
 			peer_req->w.cb = w_e_end_csum_rs_req;
 			/* used in the sector offset progress display */
-			mdev->bm_resync_fo = BM_SECT_TO_BIT(sector);
+			device->bm_resync_fo = BM_SECT_TO_BIT(sector);
 		} else if (pi->cmd == P_OV_REPLY) {
 			/* track progress, we may need to throttle */
-			atomic_add(size >> 9, &mdev->rs_sect_in);
+			atomic_add(size >> 9, &device->rs_sect_in);
 			peer_req->w.cb = w_e_end_ov_reply;
-			dec_rs_pending(mdev);
+			dec_rs_pending(device);
 			/* drbd_rs_begin_io done when we sent this request,
 			 * but accounting still needs to be done. */
 			goto submit_for_resync;
@@ -2470,17 +2471,17 @@ static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 		break;
 
 	case P_OV_REQUEST:
-		if (mdev->ov_start_sector == ~(sector_t)0 &&
-		    mdev->tconn->agreed_pro_version >= 90) {
+		if (device->ov_start_sector == ~(sector_t)0 &&
+		    device->tconn->agreed_pro_version >= 90) {
 			unsigned long now = jiffies;
 			int i;
-			mdev->ov_start_sector = sector;
-			mdev->ov_position = sector;
-			mdev->ov_left = drbd_bm_bits(mdev) - BM_SECT_TO_BIT(sector);
-			mdev->rs_total = mdev->ov_left;
+			device->ov_start_sector = sector;
+			device->ov_position = sector;
+			device->ov_left = drbd_bm_bits(device) - BM_SECT_TO_BIT(sector);
+			device->rs_total = device->ov_left;
 			for (i = 0; i < DRBD_SYNC_MARKS; i++) {
-				mdev->rs_mark_left[i] = mdev->ov_left;
-				mdev->rs_mark_time[i] = now;
+				device->rs_mark_left[i] = device->ov_left;
+				device->rs_mark_time[i] = now;
 			}
 			dev_info(DEV, "Online Verify start sector: %llu\n",
 					(unsigned long long)sector);
@@ -2515,50 +2516,50 @@ static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 	 * we would also throttle its application reads.
 	 * In that case, throttling is done on the SyncTarget only.
 	 */
-	if (mdev->state.peer != R_PRIMARY && drbd_rs_should_slow_down(mdev, sector))
+	if (device->state.peer != R_PRIMARY && drbd_rs_should_slow_down(device, sector))
 		schedule_timeout_uninterruptible(HZ/10);
-	if (drbd_rs_begin_io(mdev, sector))
+	if (drbd_rs_begin_io(device, sector))
 		goto out_free_e;
 
 submit_for_resync:
-	atomic_add(size >> 9, &mdev->rs_sect_ev);
+	atomic_add(size >> 9, &device->rs_sect_ev);
 
 submit:
-	inc_unacked(mdev);
-	spin_lock_irq(&mdev->tconn->req_lock);
-	list_add_tail(&peer_req->w.list, &mdev->read_ee);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	inc_unacked(device);
+	spin_lock_irq(&device->tconn->req_lock);
+	list_add_tail(&peer_req->w.list, &device->read_ee);
+	spin_unlock_irq(&device->tconn->req_lock);
 
-	if (drbd_submit_peer_request(mdev, peer_req, READ, fault_type) == 0)
+	if (drbd_submit_peer_request(device, peer_req, READ, fault_type) == 0)
 		return 0;
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
-	spin_lock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
 	list_del(&peer_req->w.list);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_unlock_irq(&device->tconn->req_lock);
 	/* no drbd_rs_complete_io(), we are dropping the connection anyways */
 
 out_free_e:
-	put_ldev(mdev);
-	drbd_free_peer_req(mdev, peer_req);
+	put_ldev(device);
+	drbd_free_peer_req(device, peer_req);
 	return -EIO;
 }
 
-static int drbd_asb_recover_0p(struct drbd_device *mdev) __must_hold(local)
+static int drbd_asb_recover_0p(struct drbd_device *device) __must_hold(local)
 {
 	int self, peer, rv = -100;
 	unsigned long ch_self, ch_peer;
 	enum drbd_after_sb_p after_sb_0p;
 
-	self = mdev->ldev->md.uuid[UI_BITMAP] & 1;
-	peer = mdev->p_uuid[UI_BITMAP] & 1;
+	self = device->ldev->md.uuid[UI_BITMAP] & 1;
+	peer = device->p_uuid[UI_BITMAP] & 1;
 
-	ch_peer = mdev->p_uuid[UI_SIZE];
-	ch_self = mdev->comm_bm_set;
+	ch_peer = device->p_uuid[UI_SIZE];
+	ch_self = device->comm_bm_set;
 
 	rcu_read_lock();
-	after_sb_0p = rcu_dereference(mdev->tconn->net_conf)->after_sb_0p;
+	after_sb_0p = rcu_dereference(device->tconn->net_conf)->after_sb_0p;
 	rcu_read_unlock();
 	switch (after_sb_0p) {
 	case ASB_CONSENSUS:
@@ -2593,7 +2594,7 @@ static int drbd_asb_recover_0p(struct drbd_device *mdev) __must_hold(local)
 		     "Using discard-least-changes instead\n");
 	case ASB_DISCARD_ZERO_CHG:
 		if (ch_peer == 0 && ch_self == 0) {
-			rv = test_bit(RESOLVE_CONFLICTS, &mdev->tconn->flags)
+			rv = test_bit(RESOLVE_CONFLICTS, &device->tconn->flags)
 				? -1 : 1;
 			break;
 		} else {
@@ -2609,7 +2610,7 @@ static int drbd_asb_recover_0p(struct drbd_device *mdev) __must_hold(local)
 			rv =  1;
 		else /* ( ch_self == ch_peer ) */
 		     /* Well, then use something else. */
-			rv = test_bit(RESOLVE_CONFLICTS, &mdev->tconn->flags)
+			rv = test_bit(RESOLVE_CONFLICTS, &device->tconn->flags)
 				? -1 : 1;
 		break;
 	case ASB_DISCARD_LOCAL:
@@ -2622,13 +2623,13 @@ static int drbd_asb_recover_0p(struct drbd_device *mdev) __must_hold(local)
 	return rv;
 }
 
-static int drbd_asb_recover_1p(struct drbd_device *mdev) __must_hold(local)
+static int drbd_asb_recover_1p(struct drbd_device *device) __must_hold(local)
 {
 	int hg, rv = -100;
 	enum drbd_after_sb_p after_sb_1p;
 
 	rcu_read_lock();
-	after_sb_1p = rcu_dereference(mdev->tconn->net_conf)->after_sb_1p;
+	after_sb_1p = rcu_dereference(device->tconn->net_conf)->after_sb_1p;
 	rcu_read_unlock();
 	switch (after_sb_1p) {
 	case ASB_DISCARD_YOUNGER_PRI:
@@ -2642,28 +2643,28 @@ static int drbd_asb_recover_1p(struct drbd_device *mdev) __must_hold(local)
 	case ASB_DISCONNECT:
 		break;
 	case ASB_CONSENSUS:
-		hg = drbd_asb_recover_0p(mdev);
-		if (hg == -1 && mdev->state.role == R_SECONDARY)
+		hg = drbd_asb_recover_0p(device);
+		if (hg == -1 && device->state.role == R_SECONDARY)
 			rv = hg;
-		if (hg == 1  && mdev->state.role == R_PRIMARY)
+		if (hg == 1  && device->state.role == R_PRIMARY)
 			rv = hg;
 		break;
 	case ASB_VIOLENTLY:
-		rv = drbd_asb_recover_0p(mdev);
+		rv = drbd_asb_recover_0p(device);
 		break;
 	case ASB_DISCARD_SECONDARY:
-		return mdev->state.role == R_PRIMARY ? 1 : -1;
+		return device->state.role == R_PRIMARY ? 1 : -1;
 	case ASB_CALL_HELPER:
-		hg = drbd_asb_recover_0p(mdev);
-		if (hg == -1 && mdev->state.role == R_PRIMARY) {
+		hg = drbd_asb_recover_0p(device);
+		if (hg == -1 && device->state.role == R_PRIMARY) {
 			enum drbd_state_rv rv2;
 
 			 /* drbd_change_state() does not sleep while in SS_IN_TRANSIENT_STATE,
 			  * we might be here in C_WF_REPORT_PARAMS which is transient.
 			  * we do not need to wait for the after state change work either. */
-			rv2 = drbd_change_state(mdev, CS_VERBOSE, NS(role, R_SECONDARY));
+			rv2 = drbd_change_state(device, CS_VERBOSE, NS(role, R_SECONDARY));
 			if (rv2 != SS_SUCCESS) {
-				drbd_khelper(mdev, "pri-lost-after-sb");
+				drbd_khelper(device, "pri-lost-after-sb");
 			} else {
 				dev_warn(DEV, "Successfully gave up primary role.\n");
 				rv = hg;
@@ -2675,13 +2676,13 @@ static int drbd_asb_recover_1p(struct drbd_device *mdev) __must_hold(local)
 	return rv;
 }
 
-static int drbd_asb_recover_2p(struct drbd_device *mdev) __must_hold(local)
+static int drbd_asb_recover_2p(struct drbd_device *device) __must_hold(local)
 {
 	int hg, rv = -100;
 	enum drbd_after_sb_p after_sb_2p;
 
 	rcu_read_lock();
-	after_sb_2p = rcu_dereference(mdev->tconn->net_conf)->after_sb_2p;
+	after_sb_2p = rcu_dereference(device->tconn->net_conf)->after_sb_2p;
 	rcu_read_unlock();
 	switch (after_sb_2p) {
 	case ASB_DISCARD_YOUNGER_PRI:
@@ -2695,21 +2696,21 @@ static int drbd_asb_recover_2p(struct drbd_device *mdev) __must_hold(local)
 		dev_err(DEV, "Configuration error.\n");
 		break;
 	case ASB_VIOLENTLY:
-		rv = drbd_asb_recover_0p(mdev);
+		rv = drbd_asb_recover_0p(device);
 		break;
 	case ASB_DISCONNECT:
 		break;
 	case ASB_CALL_HELPER:
-		hg = drbd_asb_recover_0p(mdev);
+		hg = drbd_asb_recover_0p(device);
 		if (hg == -1) {
 			enum drbd_state_rv rv2;
 
 			 /* drbd_change_state() does not sleep while in SS_IN_TRANSIENT_STATE,
 			  * we might be here in C_WF_REPORT_PARAMS which is transient.
 			  * we do not need to wait for the after state change work either. */
-			rv2 = drbd_change_state(mdev, CS_VERBOSE, NS(role, R_SECONDARY));
+			rv2 = drbd_change_state(device, CS_VERBOSE, NS(role, R_SECONDARY));
 			if (rv2 != SS_SUCCESS) {
-				drbd_khelper(mdev, "pri-lost-after-sb");
+				drbd_khelper(device, "pri-lost-after-sb");
 			} else {
 				dev_warn(DEV, "Successfully gave up primary role.\n");
 				rv = hg;
@@ -2721,7 +2722,7 @@ static int drbd_asb_recover_2p(struct drbd_device *mdev) __must_hold(local)
 	return rv;
 }
 
-static void drbd_uuid_dump(struct drbd_device *mdev, char *text, u64 *uuid,
+static void drbd_uuid_dump(struct drbd_device *device, char *text, u64 *uuid,
 			   u64 bits, u64 flags)
 {
 	if (!uuid) {
@@ -2750,13 +2751,13 @@ static void drbd_uuid_dump(struct drbd_device *mdev, char *text, u64 *uuid,
 -1091   requires proto 91
 -1096   requires proto 96
  */
-static int drbd_uuid_compare(struct drbd_device *mdev, int *rule_nr) __must_hold(local)
+static int drbd_uuid_compare(struct drbd_device *device, int *rule_nr) __must_hold(local)
 {
 	u64 self, peer;
 	int i, j;
 
-	self = mdev->ldev->md.uuid[UI_CURRENT] & ~((u64)1);
-	peer = mdev->p_uuid[UI_CURRENT] & ~((u64)1);
+	self = device->ldev->md.uuid[UI_CURRENT] & ~((u64)1);
+	peer = device->p_uuid[UI_CURRENT] & ~((u64)1);
 
 	*rule_nr = 10;
 	if (self == UUID_JUST_CREATED && peer == UUID_JUST_CREATED)
@@ -2775,20 +2776,20 @@ static int drbd_uuid_compare(struct drbd_device *mdev, int *rule_nr) __must_hold
 	if (self == peer) {
 		int rct, dc; /* roles at crash time */
 
-		if (mdev->p_uuid[UI_BITMAP] == (u64)0 && mdev->ldev->md.uuid[UI_BITMAP] != (u64)0) {
+		if (device->p_uuid[UI_BITMAP] == (u64)0 && device->ldev->md.uuid[UI_BITMAP] != (u64)0) {
 
-			if (mdev->tconn->agreed_pro_version < 91)
+			if (device->tconn->agreed_pro_version < 91)
 				return -1091;
 
-			if ((mdev->ldev->md.uuid[UI_BITMAP] & ~((u64)1)) == (mdev->p_uuid[UI_HISTORY_START] & ~((u64)1)) &&
-			    (mdev->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) == (mdev->p_uuid[UI_HISTORY_START + 1] & ~((u64)1))) {
+			if ((device->ldev->md.uuid[UI_BITMAP] & ~((u64)1)) == (device->p_uuid[UI_HISTORY_START] & ~((u64)1)) &&
+			    (device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) == (device->p_uuid[UI_HISTORY_START + 1] & ~((u64)1))) {
 				dev_info(DEV, "was SyncSource, missed the resync finished event, corrected myself:\n");
-				drbd_uuid_move_history(mdev);
-				mdev->ldev->md.uuid[UI_HISTORY_START] = mdev->ldev->md.uuid[UI_BITMAP];
-				mdev->ldev->md.uuid[UI_BITMAP] = 0;
+				drbd_uuid_move_history(device);
+				device->ldev->md.uuid[UI_HISTORY_START] = device->ldev->md.uuid[UI_BITMAP];
+				device->ldev->md.uuid[UI_BITMAP] = 0;
 
-				drbd_uuid_dump(mdev, "self", mdev->ldev->md.uuid,
-					       mdev->state.disk >= D_NEGOTIATING ? drbd_bm_total_weight(mdev) : 0, 0);
+				drbd_uuid_dump(device, "self", device->ldev->md.uuid,
+					       device->state.disk >= D_NEGOTIATING ? drbd_bm_total_weight(device) : 0, 0);
 				*rule_nr = 34;
 			} else {
 				dev_info(DEV, "was SyncSource (peer failed to write sync_uuid)\n");
@@ -2798,20 +2799,20 @@ static int drbd_uuid_compare(struct drbd_device *mdev, int *rule_nr) __must_hold
 			return 1;
 		}
 
-		if (mdev->ldev->md.uuid[UI_BITMAP] == (u64)0 && mdev->p_uuid[UI_BITMAP] != (u64)0) {
+		if (device->ldev->md.uuid[UI_BITMAP] == (u64)0 && device->p_uuid[UI_BITMAP] != (u64)0) {
 
-			if (mdev->tconn->agreed_pro_version < 91)
+			if (device->tconn->agreed_pro_version < 91)
 				return -1091;
 
-			if ((mdev->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) == (mdev->p_uuid[UI_BITMAP] & ~((u64)1)) &&
-			    (mdev->ldev->md.uuid[UI_HISTORY_START + 1] & ~((u64)1)) == (mdev->p_uuid[UI_HISTORY_START] & ~((u64)1))) {
+			if ((device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) == (device->p_uuid[UI_BITMAP] & ~((u64)1)) &&
+			    (device->ldev->md.uuid[UI_HISTORY_START + 1] & ~((u64)1)) == (device->p_uuid[UI_HISTORY_START] & ~((u64)1))) {
 				dev_info(DEV, "was SyncTarget, peer missed the resync finished event, corrected peer:\n");
 
-				mdev->p_uuid[UI_HISTORY_START + 1] = mdev->p_uuid[UI_HISTORY_START];
-				mdev->p_uuid[UI_HISTORY_START] = mdev->p_uuid[UI_BITMAP];
-				mdev->p_uuid[UI_BITMAP] = 0UL;
+				device->p_uuid[UI_HISTORY_START + 1] = device->p_uuid[UI_HISTORY_START];
+				device->p_uuid[UI_HISTORY_START] = device->p_uuid[UI_BITMAP];
+				device->p_uuid[UI_BITMAP] = 0UL;
 
-				drbd_uuid_dump(mdev, "peer", mdev->p_uuid, mdev->p_uuid[UI_SIZE], mdev->p_uuid[UI_FLAGS]);
+				drbd_uuid_dump(device, "peer", device->p_uuid, device->p_uuid[UI_SIZE], device->p_uuid[UI_FLAGS]);
 				*rule_nr = 35;
 			} else {
 				dev_info(DEV, "was SyncTarget (failed to write sync_uuid)\n");
@@ -2822,8 +2823,8 @@ static int drbd_uuid_compare(struct drbd_device *mdev, int *rule_nr) __must_hold
 		}
 
 		/* Common power [off|failure] */
-		rct = (test_bit(CRASHED_PRIMARY, &mdev->flags) ? 1 : 0) +
-			(mdev->p_uuid[UI_FLAGS] & 2);
+		rct = (test_bit(CRASHED_PRIMARY, &device->flags) ? 1 : 0) +
+			(device->p_uuid[UI_FLAGS] & 2);
 		/* lowest bit is set when we were primary,
 		 * next bit (weight 2) is set when peer was primary */
 		*rule_nr = 40;
@@ -2833,72 +2834,72 @@ static int drbd_uuid_compare(struct drbd_device *mdev, int *rule_nr) __must_hold
 		case 1: /*  self_pri && !peer_pri */ return 1;
 		case 2: /* !self_pri &&  peer_pri */ return -1;
 		case 3: /*  self_pri &&  peer_pri */
-			dc = test_bit(RESOLVE_CONFLICTS, &mdev->tconn->flags);
+			dc = test_bit(RESOLVE_CONFLICTS, &device->tconn->flags);
 			return dc ? -1 : 1;
 		}
 	}
 
 	*rule_nr = 50;
-	peer = mdev->p_uuid[UI_BITMAP] & ~((u64)1);
+	peer = device->p_uuid[UI_BITMAP] & ~((u64)1);
 	if (self == peer)
 		return -1;
 
 	*rule_nr = 51;
-	peer = mdev->p_uuid[UI_HISTORY_START] & ~((u64)1);
+	peer = device->p_uuid[UI_HISTORY_START] & ~((u64)1);
 	if (self == peer) {
-		if (mdev->tconn->agreed_pro_version < 96 ?
-		    (mdev->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) ==
-		    (mdev->p_uuid[UI_HISTORY_START + 1] & ~((u64)1)) :
-		    peer + UUID_NEW_BM_OFFSET == (mdev->p_uuid[UI_BITMAP] & ~((u64)1))) {
+		if (device->tconn->agreed_pro_version < 96 ?
+		    (device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1)) ==
+		    (device->p_uuid[UI_HISTORY_START + 1] & ~((u64)1)) :
+		    peer + UUID_NEW_BM_OFFSET == (device->p_uuid[UI_BITMAP] & ~((u64)1))) {
 			/* The last P_SYNC_UUID did not get though. Undo the last start of
 			   resync as sync source modifications of the peer's UUIDs. */
 
-			if (mdev->tconn->agreed_pro_version < 91)
+			if (device->tconn->agreed_pro_version < 91)
 				return -1091;
 
-			mdev->p_uuid[UI_BITMAP] = mdev->p_uuid[UI_HISTORY_START];
-			mdev->p_uuid[UI_HISTORY_START] = mdev->p_uuid[UI_HISTORY_START + 1];
+			device->p_uuid[UI_BITMAP] = device->p_uuid[UI_HISTORY_START];
+			device->p_uuid[UI_HISTORY_START] = device->p_uuid[UI_HISTORY_START + 1];
 
 			dev_info(DEV, "Lost last syncUUID packet, corrected:\n");
-			drbd_uuid_dump(mdev, "peer", mdev->p_uuid, mdev->p_uuid[UI_SIZE], mdev->p_uuid[UI_FLAGS]);
+			drbd_uuid_dump(device, "peer", device->p_uuid, device->p_uuid[UI_SIZE], device->p_uuid[UI_FLAGS]);
 
 			return -1;
 		}
 	}
 
 	*rule_nr = 60;
-	self = mdev->ldev->md.uuid[UI_CURRENT] & ~((u64)1);
+	self = device->ldev->md.uuid[UI_CURRENT] & ~((u64)1);
 	for (i = UI_HISTORY_START; i <= UI_HISTORY_END; i++) {
-		peer = mdev->p_uuid[i] & ~((u64)1);
+		peer = device->p_uuid[i] & ~((u64)1);
 		if (self == peer)
 			return -2;
 	}
 
 	*rule_nr = 70;
-	self = mdev->ldev->md.uuid[UI_BITMAP] & ~((u64)1);
-	peer = mdev->p_uuid[UI_CURRENT] & ~((u64)1);
+	self = device->ldev->md.uuid[UI_BITMAP] & ~((u64)1);
+	peer = device->p_uuid[UI_CURRENT] & ~((u64)1);
 	if (self == peer)
 		return 1;
 
 	*rule_nr = 71;
-	self = mdev->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1);
+	self = device->ldev->md.uuid[UI_HISTORY_START] & ~((u64)1);
 	if (self == peer) {
-		if (mdev->tconn->agreed_pro_version < 96 ?
-		    (mdev->ldev->md.uuid[UI_HISTORY_START + 1] & ~((u64)1)) ==
-		    (mdev->p_uuid[UI_HISTORY_START] & ~((u64)1)) :
-		    self + UUID_NEW_BM_OFFSET == (mdev->ldev->md.uuid[UI_BITMAP] & ~((u64)1))) {
+		if (device->tconn->agreed_pro_version < 96 ?
+		    (device->ldev->md.uuid[UI_HISTORY_START + 1] & ~((u64)1)) ==
+		    (device->p_uuid[UI_HISTORY_START] & ~((u64)1)) :
+		    self + UUID_NEW_BM_OFFSET == (device->ldev->md.uuid[UI_BITMAP] & ~((u64)1))) {
 			/* The last P_SYNC_UUID did not get though. Undo the last start of
 			   resync as sync source modifications of our UUIDs. */
 
-			if (mdev->tconn->agreed_pro_version < 91)
+			if (device->tconn->agreed_pro_version < 91)
 				return -1091;
 
-			__drbd_uuid_set(mdev, UI_BITMAP, mdev->ldev->md.uuid[UI_HISTORY_START]);
-			__drbd_uuid_set(mdev, UI_HISTORY_START, mdev->ldev->md.uuid[UI_HISTORY_START + 1]);
+			__drbd_uuid_set(device, UI_BITMAP, device->ldev->md.uuid[UI_HISTORY_START]);
+			__drbd_uuid_set(device, UI_HISTORY_START, device->ldev->md.uuid[UI_HISTORY_START + 1]);
 
 			dev_info(DEV, "Last syncUUID did not get through, corrected:\n");
-			drbd_uuid_dump(mdev, "self", mdev->ldev->md.uuid,
-				       mdev->state.disk >= D_NEGOTIATING ? drbd_bm_total_weight(mdev) : 0, 0);
+			drbd_uuid_dump(device, "self", device->ldev->md.uuid,
+				       device->state.disk >= D_NEGOTIATING ? drbd_bm_total_weight(device) : 0, 0);
 
 			return 1;
 		}
@@ -2906,24 +2907,24 @@ static int drbd_uuid_compare(struct drbd_device *mdev, int *rule_nr) __must_hold
 
 
 	*rule_nr = 80;
-	peer = mdev->p_uuid[UI_CURRENT] & ~((u64)1);
+	peer = device->p_uuid[UI_CURRENT] & ~((u64)1);
 	for (i = UI_HISTORY_START; i <= UI_HISTORY_END; i++) {
-		self = mdev->ldev->md.uuid[i] & ~((u64)1);
+		self = device->ldev->md.uuid[i] & ~((u64)1);
 		if (self == peer)
 			return 2;
 	}
 
 	*rule_nr = 90;
-	self = mdev->ldev->md.uuid[UI_BITMAP] & ~((u64)1);
-	peer = mdev->p_uuid[UI_BITMAP] & ~((u64)1);
+	self = device->ldev->md.uuid[UI_BITMAP] & ~((u64)1);
+	peer = device->p_uuid[UI_BITMAP] & ~((u64)1);
 	if (self == peer && self != ((u64)0))
 		return 100;
 
 	*rule_nr = 100;
 	for (i = UI_HISTORY_START; i <= UI_HISTORY_END; i++) {
-		self = mdev->ldev->md.uuid[i] & ~((u64)1);
+		self = device->ldev->md.uuid[i] & ~((u64)1);
 		for (j = UI_HISTORY_START; j <= UI_HISTORY_END; j++) {
-			peer = mdev->p_uuid[j] & ~((u64)1);
+			peer = device->p_uuid[j] & ~((u64)1);
 			if (self == peer)
 				return -100;
 		}
@@ -2935,7 +2936,7 @@ static int drbd_uuid_compare(struct drbd_device *mdev, int *rule_nr) __must_hold
 /* drbd_sync_handshake() returns the new conn state on success, or
    CONN_MASK (-1) on failure.
  */
-static enum drbd_conns drbd_sync_handshake(struct drbd_device *mdev, enum drbd_role peer_role,
+static enum drbd_conns drbd_sync_handshake(struct drbd_device *device, enum drbd_role peer_role,
 					   enum drbd_disk_state peer_disk) __must_hold(local)
 {
 	enum drbd_conns rv = C_MASK;
@@ -2943,19 +2944,19 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *mdev, enum drbd_r
 	struct net_conf *nc;
 	int hg, rule_nr, rr_conflict, tentative;
 
-	mydisk = mdev->state.disk;
+	mydisk = device->state.disk;
 	if (mydisk == D_NEGOTIATING)
-		mydisk = mdev->new_state_tmp.disk;
+		mydisk = device->new_state_tmp.disk;
 
 	dev_info(DEV, "drbd_sync_handshake:\n");
 
-	spin_lock_irq(&mdev->ldev->md.uuid_lock);
-	drbd_uuid_dump(mdev, "self", mdev->ldev->md.uuid, mdev->comm_bm_set, 0);
-	drbd_uuid_dump(mdev, "peer", mdev->p_uuid,
-		       mdev->p_uuid[UI_SIZE], mdev->p_uuid[UI_FLAGS]);
+	spin_lock_irq(&device->ldev->md.uuid_lock);
+	drbd_uuid_dump(device, "self", device->ldev->md.uuid, device->comm_bm_set, 0);
+	drbd_uuid_dump(device, "peer", device->p_uuid,
+		       device->p_uuid[UI_SIZE], device->p_uuid[UI_FLAGS]);
 
-	hg = drbd_uuid_compare(mdev, &rule_nr);
-	spin_unlock_irq(&mdev->ldev->md.uuid_lock);
+	hg = drbd_uuid_compare(device, &rule_nr);
+	spin_unlock_irq(&device->ldev->md.uuid_lock);
 
 	dev_info(DEV, "uuid_compare()=%d by rule %d\n", hg, rule_nr);
 
@@ -2979,25 +2980,25 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *mdev, enum drbd_r
 	}
 
 	if (abs(hg) == 100)
-		drbd_khelper(mdev, "initial-split-brain");
+		drbd_khelper(device, "initial-split-brain");
 
 	rcu_read_lock();
-	nc = rcu_dereference(mdev->tconn->net_conf);
+	nc = rcu_dereference(device->tconn->net_conf);
 
 	if (hg == 100 || (hg == -100 && nc->always_asbp)) {
-		int pcount = (mdev->state.role == R_PRIMARY)
+		int pcount = (device->state.role == R_PRIMARY)
 			   + (peer_role == R_PRIMARY);
 		int forced = (hg == -100);
 
 		switch (pcount) {
 		case 0:
-			hg = drbd_asb_recover_0p(mdev);
+			hg = drbd_asb_recover_0p(device);
 			break;
 		case 1:
-			hg = drbd_asb_recover_1p(mdev);
+			hg = drbd_asb_recover_1p(device);
 			break;
 		case 2:
-			hg = drbd_asb_recover_2p(mdev);
+			hg = drbd_asb_recover_2p(device);
 			break;
 		}
 		if (abs(hg) < 100) {
@@ -3013,9 +3014,9 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *mdev, enum drbd_r
 	}
 
 	if (hg == -100) {
-		if (test_bit(DISCARD_MY_DATA, &mdev->flags) && !(mdev->p_uuid[UI_FLAGS]&1))
+		if (test_bit(DISCARD_MY_DATA, &device->flags) && !(device->p_uuid[UI_FLAGS]&1))
 			hg = -1;
-		if (!test_bit(DISCARD_MY_DATA, &mdev->flags) && (mdev->p_uuid[UI_FLAGS]&1))
+		if (!test_bit(DISCARD_MY_DATA, &device->flags) && (device->p_uuid[UI_FLAGS]&1))
 			hg = 1;
 
 		if (abs(hg) < 100)
@@ -3033,7 +3034,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *mdev, enum drbd_r
 		 * We just refuse to attach -- well, we drop the "connection"
 		 * to that disk, in a way... */
 		dev_alert(DEV, "Split-Brain detected but unresolved, dropping connection!\n");
-		drbd_khelper(mdev, "split-brain");
+		drbd_khelper(device, "split-brain");
 		return C_MASK;
 	}
 
@@ -3043,10 +3044,10 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *mdev, enum drbd_r
 	}
 
 	if (hg < 0 && /* by intention we do not use mydisk here. */
-	    mdev->state.role == R_PRIMARY && mdev->state.disk >= D_CONSISTENT) {
+	    device->state.role == R_PRIMARY && device->state.disk >= D_CONSISTENT) {
 		switch (rr_conflict) {
 		case ASB_CALL_HELPER:
-			drbd_khelper(mdev, "pri-lost");
+			drbd_khelper(device, "pri-lost");
 			/* fall through */
 		case ASB_DISCONNECT:
 			dev_err(DEV, "I shall become SyncTarget, but I am primary!\n");
@@ -3057,7 +3058,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *mdev, enum drbd_r
 		}
 	}
 
-	if (tentative || test_bit(CONN_DRY_RUN, &mdev->tconn->flags)) {
+	if (tentative || test_bit(CONN_DRY_RUN, &device->tconn->flags)) {
 		if (hg == 0)
 			dev_info(DEV, "dry-run connect: No resync, would become Connected immediately.\n");
 		else
@@ -3069,7 +3070,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *mdev, enum drbd_r
 
 	if (abs(hg) >= 2) {
 		dev_info(DEV, "Writing the whole bitmap, full sync required after drbd_sync_handshake.\n");
-		if (drbd_bitmap_io(mdev, &drbd_bmio_set_n_write, "set_n_write from sync_handshake",
+		if (drbd_bitmap_io(device, &drbd_bmio_set_n_write, "set_n_write from sync_handshake",
 					BM_LOCKED_SET_ALLOWED))
 			return C_MASK;
 	}
@@ -3080,9 +3081,9 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_device *mdev, enum drbd_r
 		rv = C_WF_BITMAP_T;
 	} else {
 		rv = C_CONNECTED;
-		if (drbd_bm_total_weight(mdev)) {
+		if (drbd_bm_total_weight(device)) {
 			dev_info(DEV, "No resync, but %lu bits in bitmap!\n",
-			     drbd_bm_total_weight(mdev));
+			     drbd_bm_total_weight(device));
 		}
 	}
 
@@ -3258,7 +3259,7 @@ disconnect:
  * return: NULL (alg name was "")
  *         ERR_PTR(error) if something goes wrong
  *         or the crypto hash ptr, if it worked out ok. */
-struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_device *mdev,
+struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_device *device,
 		const char *alg, const char *name)
 {
 	struct crypto_hash *tfm;
@@ -3315,7 +3316,7 @@ static int config_unknown_volume(struct drbd_tconn *tconn, struct packet_info *p
 
 static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct p_rs_param_95 *p;
 	unsigned int header_size, data_size, exp_max_sz;
 	struct crypto_hash *verify_tfm = NULL;
@@ -3327,8 +3328,8 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	int fifo_size = 0;
 	int err;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return config_unknown_volume(tconn, pi);
 
 	exp_max_sz  = apv <= 87 ? sizeof(struct p_rs_param)
@@ -3360,22 +3361,22 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	p = pi->data;
 	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
 
-	err = drbd_recv_all(mdev->tconn, p, header_size);
+	err = drbd_recv_all(device->tconn, p, header_size);
 	if (err)
 		return err;
 
-	mutex_lock(&mdev->tconn->conf_update);
-	old_net_conf = mdev->tconn->net_conf;
-	if (get_ldev(mdev)) {
+	mutex_lock(&device->tconn->conf_update);
+	old_net_conf = device->tconn->net_conf;
+	if (get_ldev(device)) {
 		new_disk_conf = kzalloc(sizeof(struct disk_conf), GFP_KERNEL);
 		if (!new_disk_conf) {
-			put_ldev(mdev);
-			mutex_unlock(&mdev->tconn->conf_update);
+			put_ldev(device);
+			mutex_unlock(&device->tconn->conf_update);
 			dev_err(DEV, "Allocation of new disk_conf failed\n");
 			return -ENOMEM;
 		}
 
-		old_disk_conf = mdev->ldev->disk_conf;
+		old_disk_conf = device->ldev->disk_conf;
 		*new_disk_conf = *old_disk_conf;
 
 		new_disk_conf->resync_rate = be32_to_cpu(p->resync_rate);
@@ -3391,7 +3392,7 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 				goto reconnect;
 			}
 
-			err = drbd_recv_all(mdev->tconn, p->verify_alg, data_size);
+			err = drbd_recv_all(device->tconn, p->verify_alg, data_size);
 			if (err)
 				goto reconnect;
 			/* we expect NUL terminated string */
@@ -3409,12 +3410,12 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 		}
 
 		if (strcmp(old_net_conf->verify_alg, p->verify_alg)) {
-			if (mdev->state.conn == C_WF_REPORT_PARAMS) {
+			if (device->state.conn == C_WF_REPORT_PARAMS) {
 				dev_err(DEV, "Different verify-alg settings. me=\"%s\" peer=\"%s\"\n",
 				    old_net_conf->verify_alg, p->verify_alg);
 				goto disconnect;
 			}
-			verify_tfm = drbd_crypto_alloc_digest_safe(mdev,
+			verify_tfm = drbd_crypto_alloc_digest_safe(device,
 					p->verify_alg, "verify-alg");
 			if (IS_ERR(verify_tfm)) {
 				verify_tfm = NULL;
@@ -3423,12 +3424,12 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 		}
 
 		if (apv >= 89 && strcmp(old_net_conf->csums_alg, p->csums_alg)) {
-			if (mdev->state.conn == C_WF_REPORT_PARAMS) {
+			if (device->state.conn == C_WF_REPORT_PARAMS) {
 				dev_err(DEV, "Different csums-alg settings. me=\"%s\" peer=\"%s\"\n",
 				    old_net_conf->csums_alg, p->csums_alg);
 				goto disconnect;
 			}
-			csums_tfm = drbd_crypto_alloc_digest_safe(mdev,
+			csums_tfm = drbd_crypto_alloc_digest_safe(device,
 					p->csums_alg, "csums-alg");
 			if (IS_ERR(csums_tfm)) {
 				csums_tfm = NULL;
@@ -3443,11 +3444,11 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 			new_disk_conf->c_max_rate = be32_to_cpu(p->c_max_rate);
 
 			fifo_size = (new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ;
-			if (fifo_size != mdev->rs_plan_s->size) {
+			if (fifo_size != device->rs_plan_s->size) {
 				new_plan = fifo_alloc(fifo_size);
 				if (!new_plan) {
 					dev_err(DEV, "kmalloc of fifo_buffer failed");
-					put_ldev(mdev);
+					put_ldev(device);
 					goto disconnect;
 				}
 			}
@@ -3465,15 +3466,15 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 			if (verify_tfm) {
 				strcpy(new_net_conf->verify_alg, p->verify_alg);
 				new_net_conf->verify_alg_len = strlen(p->verify_alg) + 1;
-				crypto_free_hash(mdev->tconn->verify_tfm);
-				mdev->tconn->verify_tfm = verify_tfm;
+				crypto_free_hash(device->tconn->verify_tfm);
+				device->tconn->verify_tfm = verify_tfm;
 				dev_info(DEV, "using verify-alg: \"%s\"\n", p->verify_alg);
 			}
 			if (csums_tfm) {
 				strcpy(new_net_conf->csums_alg, p->csums_alg);
 				new_net_conf->csums_alg_len = strlen(p->csums_alg) + 1;
-				crypto_free_hash(mdev->tconn->csums_tfm);
-				mdev->tconn->csums_tfm = csums_tfm;
+				crypto_free_hash(device->tconn->csums_tfm);
+				device->tconn->csums_tfm = csums_tfm;
 				dev_info(DEV, "using csums-alg: \"%s\"\n", p->csums_alg);
 			}
 			rcu_assign_pointer(tconn->net_conf, new_net_conf);
@@ -3481,16 +3482,16 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	}
 
 	if (new_disk_conf) {
-		rcu_assign_pointer(mdev->ldev->disk_conf, new_disk_conf);
-		put_ldev(mdev);
+		rcu_assign_pointer(device->ldev->disk_conf, new_disk_conf);
+		put_ldev(device);
 	}
 
 	if (new_plan) {
-		old_plan = mdev->rs_plan_s;
-		rcu_assign_pointer(mdev->rs_plan_s, new_plan);
+		old_plan = device->rs_plan_s;
+		rcu_assign_pointer(device->rs_plan_s, new_plan);
 	}
 
-	mutex_unlock(&mdev->tconn->conf_update);
+	mutex_unlock(&device->tconn->conf_update);
 	synchronize_rcu();
 	if (new_net_conf)
 		kfree(old_net_conf);
@@ -3501,30 +3502,30 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 
 reconnect:
 	if (new_disk_conf) {
-		put_ldev(mdev);
+		put_ldev(device);
 		kfree(new_disk_conf);
 	}
-	mutex_unlock(&mdev->tconn->conf_update);
+	mutex_unlock(&device->tconn->conf_update);
 	return -EIO;
 
 disconnect:
 	kfree(new_plan);
 	if (new_disk_conf) {
-		put_ldev(mdev);
+		put_ldev(device);
 		kfree(new_disk_conf);
 	}
-	mutex_unlock(&mdev->tconn->conf_update);
+	mutex_unlock(&device->tconn->conf_update);
 	/* just for completeness: actually not needed,
 	 * as this is not reached if csums_tfm was ok. */
 	crypto_free_hash(csums_tfm);
 	/* but free the verify_tfm again, if csums_tfm did not work out */
 	crypto_free_hash(verify_tfm);
-	conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+	conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 	return -EIO;
 }
 
 /* warn if the arguments differ by more than 12.5% */
-static void warn_if_differ_considerably(struct drbd_device *mdev,
+static void warn_if_differ_considerably(struct drbd_device *device,
 	const char *s, sector_t a, sector_t b)
 {
 	sector_t d;
@@ -3538,15 +3539,15 @@ static void warn_if_differ_considerably(struct drbd_device *mdev,
 
 static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct p_sizes *p = pi->data;
 	enum determine_dev_size dd = DS_UNCHANGED;
 	sector_t p_size, p_usize, my_usize;
 	int ldsc = 0; /* local disk size changed */
 	enum dds_flags ddsf;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return config_unknown_volume(tconn, pi);
 
 	p_size = be64_to_cpu(p->d_size);
@@ -3554,32 +3555,32 @@ static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	/* just store the peer's disk size for now.
 	 * we still need to figure out whether we accept that. */
-	mdev->p_size = p_size;
+	device->p_size = p_size;
 
-	if (get_ldev(mdev)) {
+	if (get_ldev(device)) {
 		rcu_read_lock();
-		my_usize = rcu_dereference(mdev->ldev->disk_conf)->disk_size;
+		my_usize = rcu_dereference(device->ldev->disk_conf)->disk_size;
 		rcu_read_unlock();
 
-		warn_if_differ_considerably(mdev, "lower level device sizes",
-			   p_size, drbd_get_max_capacity(mdev->ldev));
-		warn_if_differ_considerably(mdev, "user requested size",
+		warn_if_differ_considerably(device, "lower level device sizes",
+			   p_size, drbd_get_max_capacity(device->ldev));
+		warn_if_differ_considerably(device, "user requested size",
 					    p_usize, my_usize);
 
 		/* if this is the first connect, or an otherwise expected
 		 * param exchange, choose the minimum */
-		if (mdev->state.conn == C_WF_REPORT_PARAMS)
+		if (device->state.conn == C_WF_REPORT_PARAMS)
 			p_usize = min_not_zero(my_usize, p_usize);
 
 		/* Never shrink a device with usable data during connect.
 		   But allow online shrinking if we are connected. */
-		if (drbd_new_dev_size(mdev, mdev->ldev, p_usize, 0) <
-		    drbd_get_capacity(mdev->this_bdev) &&
-		    mdev->state.disk >= D_OUTDATED &&
-		    mdev->state.conn < C_CONNECTED) {
+		if (drbd_new_dev_size(device, device->ldev, p_usize, 0) <
+		    drbd_get_capacity(device->this_bdev) &&
+		    device->state.disk >= D_OUTDATED &&
+		    device->state.conn < C_CONNECTED) {
 			dev_err(DEV, "The peer's disk size is too small!\n");
-			conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
-			put_ldev(mdev);
+			conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+			put_ldev(device);
 			return -EIO;
 		}
 
@@ -3589,17 +3590,17 @@ static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 			new_disk_conf = kzalloc(sizeof(struct disk_conf), GFP_KERNEL);
 			if (!new_disk_conf) {
 				dev_err(DEV, "Allocation of new disk_conf failed\n");
-				put_ldev(mdev);
+				put_ldev(device);
 				return -ENOMEM;
 			}
 
-			mutex_lock(&mdev->tconn->conf_update);
-			old_disk_conf = mdev->ldev->disk_conf;
+			mutex_lock(&device->tconn->conf_update);
+			old_disk_conf = device->ldev->disk_conf;
 			*new_disk_conf = *old_disk_conf;
 			new_disk_conf->disk_size = p_usize;
 
-			rcu_assign_pointer(mdev->ldev->disk_conf, new_disk_conf);
-			mutex_unlock(&mdev->tconn->conf_update);
+			rcu_assign_pointer(device->ldev->disk_conf, new_disk_conf);
+			mutex_unlock(&device->tconn->conf_update);
 			synchronize_rcu();
 			kfree(old_disk_conf);
 
@@ -3607,50 +3608,50 @@ static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 				 (unsigned long)my_usize);
 		}
 
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 
 	ddsf = be16_to_cpu(p->dds_flags);
-	if (get_ldev(mdev)) {
-		dd = drbd_determine_dev_size(mdev, ddsf, NULL);
-		put_ldev(mdev);
+	if (get_ldev(device)) {
+		dd = drbd_determine_dev_size(device, ddsf, NULL);
+		put_ldev(device);
 		if (dd == DS_ERROR)
 			return -EIO;
-		drbd_md_sync(mdev);
+		drbd_md_sync(device);
 	} else {
 		/* I am diskless, need to accept the peer's size. */
-		drbd_set_my_capacity(mdev, p_size);
+		drbd_set_my_capacity(device, p_size);
 	}
 
-	mdev->peer_max_bio_size = be32_to_cpu(p->max_bio_size);
-	drbd_reconsider_max_bio_size(mdev);
+	device->peer_max_bio_size = be32_to_cpu(p->max_bio_size);
+	drbd_reconsider_max_bio_size(device);
 
-	if (get_ldev(mdev)) {
-		if (mdev->ldev->known_size != drbd_get_capacity(mdev->ldev->backing_bdev)) {
-			mdev->ldev->known_size = drbd_get_capacity(mdev->ldev->backing_bdev);
+	if (get_ldev(device)) {
+		if (device->ldev->known_size != drbd_get_capacity(device->ldev->backing_bdev)) {
+			device->ldev->known_size = drbd_get_capacity(device->ldev->backing_bdev);
 			ldsc = 1;
 		}
 
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 
-	if (mdev->state.conn > C_WF_REPORT_PARAMS) {
+	if (device->state.conn > C_WF_REPORT_PARAMS) {
 		if (be64_to_cpu(p->c_size) !=
-		    drbd_get_capacity(mdev->this_bdev) || ldsc) {
+		    drbd_get_capacity(device->this_bdev) || ldsc) {
 			/* we have different sizes, probably peer
 			 * needs to know my new size... */
-			drbd_send_sizes(mdev, 0, ddsf);
+			drbd_send_sizes(device, 0, ddsf);
 		}
-		if (test_and_clear_bit(RESIZE_PENDING, &mdev->flags) ||
-		    (dd == DS_GREW && mdev->state.conn == C_CONNECTED)) {
-			if (mdev->state.pdsk >= D_INCONSISTENT &&
-			    mdev->state.disk >= D_INCONSISTENT) {
+		if (test_and_clear_bit(RESIZE_PENDING, &device->flags) ||
+		    (dd == DS_GREW && device->state.conn == C_CONNECTED)) {
+			if (device->state.pdsk >= D_INCONSISTENT &&
+			    device->state.disk >= D_INCONSISTENT) {
 				if (ddsf & DDSF_NO_RESYNC)
 					dev_info(DEV, "Resync of new storage suppressed with --assume-clean\n");
 				else
-					resync_after_online_grow(mdev);
+					resync_after_online_grow(device);
 			} else
-				set_bit(RESYNC_AFTER_NEG, &mdev->flags);
+				set_bit(RESYNC_AFTER_NEG, &device->flags);
 		}
 	}
 
@@ -3659,13 +3660,13 @@ static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int receive_uuids(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct p_uuids *p = pi->data;
 	u64 *p_uuid;
 	int i, updated_uuids = 0;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return config_unknown_volume(tconn, pi);
 
 	p_uuid = kmalloc(sizeof(u64)*UI_EXTENDED_SIZE, GFP_NOIO);
@@ -3677,56 +3678,56 @@ static int receive_uuids(struct drbd_tconn *tconn, struct packet_info *pi)
 	for (i = UI_CURRENT; i < UI_EXTENDED_SIZE; i++)
 		p_uuid[i] = be64_to_cpu(p->uuid[i]);
 
-	kfree(mdev->p_uuid);
-	mdev->p_uuid = p_uuid;
+	kfree(device->p_uuid);
+	device->p_uuid = p_uuid;
 
-	if (mdev->state.conn < C_CONNECTED &&
-	    mdev->state.disk < D_INCONSISTENT &&
-	    mdev->state.role == R_PRIMARY &&
-	    (mdev->ed_uuid & ~((u64)1)) != (p_uuid[UI_CURRENT] & ~((u64)1))) {
+	if (device->state.conn < C_CONNECTED &&
+	    device->state.disk < D_INCONSISTENT &&
+	    device->state.role == R_PRIMARY &&
+	    (device->ed_uuid & ~((u64)1)) != (p_uuid[UI_CURRENT] & ~((u64)1))) {
 		dev_err(DEV, "Can only connect to data with current UUID=%016llX\n",
-		    (unsigned long long)mdev->ed_uuid);
-		conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+		    (unsigned long long)device->ed_uuid);
+		conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 		return -EIO;
 	}
 
-	if (get_ldev(mdev)) {
+	if (get_ldev(device)) {
 		int skip_initial_sync =
-			mdev->state.conn == C_CONNECTED &&
-			mdev->tconn->agreed_pro_version >= 90 &&
-			mdev->ldev->md.uuid[UI_CURRENT] == UUID_JUST_CREATED &&
+			device->state.conn == C_CONNECTED &&
+			device->tconn->agreed_pro_version >= 90 &&
+			device->ldev->md.uuid[UI_CURRENT] == UUID_JUST_CREATED &&
 			(p_uuid[UI_FLAGS] & 8);
 		if (skip_initial_sync) {
 			dev_info(DEV, "Accepted new current UUID, preparing to skip initial sync\n");
-			drbd_bitmap_io(mdev, &drbd_bmio_clear_n_write,
+			drbd_bitmap_io(device, &drbd_bmio_clear_n_write,
 					"clear_n_write from receive_uuids",
 					BM_LOCKED_TEST_ALLOWED);
-			_drbd_uuid_set(mdev, UI_CURRENT, p_uuid[UI_CURRENT]);
-			_drbd_uuid_set(mdev, UI_BITMAP, 0);
-			_drbd_set_state(_NS2(mdev, disk, D_UP_TO_DATE, pdsk, D_UP_TO_DATE),
+			_drbd_uuid_set(device, UI_CURRENT, p_uuid[UI_CURRENT]);
+			_drbd_uuid_set(device, UI_BITMAP, 0);
+			_drbd_set_state(_NS2(device, disk, D_UP_TO_DATE, pdsk, D_UP_TO_DATE),
 					CS_VERBOSE, NULL);
-			drbd_md_sync(mdev);
+			drbd_md_sync(device);
 			updated_uuids = 1;
 		}
-		put_ldev(mdev);
-	} else if (mdev->state.disk < D_INCONSISTENT &&
-		   mdev->state.role == R_PRIMARY) {
+		put_ldev(device);
+	} else if (device->state.disk < D_INCONSISTENT &&
+		   device->state.role == R_PRIMARY) {
 		/* I am a diskless primary, the peer just created a new current UUID
 		   for me. */
-		updated_uuids = drbd_set_ed_uuid(mdev, p_uuid[UI_CURRENT]);
+		updated_uuids = drbd_set_ed_uuid(device, p_uuid[UI_CURRENT]);
 	}
 
 	/* Before we test for the disk state, we should wait until an eventually
 	   ongoing cluster wide state change is finished. That is important if
 	   we are primary and are detaching from our disk. We need to see the
 	   new disk state... */
-	mutex_lock(mdev->state_mutex);
-	mutex_unlock(mdev->state_mutex);
-	if (mdev->state.conn >= C_CONNECTED && mdev->state.disk < D_INCONSISTENT)
-		updated_uuids |= drbd_set_ed_uuid(mdev, p_uuid[UI_CURRENT]);
+	mutex_lock(device->state_mutex);
+	mutex_unlock(device->state_mutex);
+	if (device->state.conn >= C_CONNECTED && device->state.disk < D_INCONSISTENT)
+		updated_uuids |= drbd_set_ed_uuid(device, p_uuid[UI_CURRENT]);
 
 	if (updated_uuids)
-		drbd_print_uuids(mdev, "receiver updated UUIDs to");
+		drbd_print_uuids(device, "receiver updated UUIDs to");
 
 	return 0;
 }
@@ -3764,31 +3765,31 @@ static union drbd_state convert_state(union drbd_state ps)
 
 static int receive_req_state(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct p_req_state *p = pi->data;
 	union drbd_state mask, val;
 	enum drbd_state_rv rv;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
 	mask.i = be32_to_cpu(p->mask);
 	val.i = be32_to_cpu(p->val);
 
-	if (test_bit(RESOLVE_CONFLICTS, &mdev->tconn->flags) &&
-	    mutex_is_locked(mdev->state_mutex)) {
-		drbd_send_sr_reply(mdev, SS_CONCURRENT_ST_CHG);
+	if (test_bit(RESOLVE_CONFLICTS, &device->tconn->flags) &&
+	    mutex_is_locked(device->state_mutex)) {
+		drbd_send_sr_reply(device, SS_CONCURRENT_ST_CHG);
 		return 0;
 	}
 
 	mask = convert_state(mask);
 	val = convert_state(val);
 
-	rv = drbd_change_state(mdev, CS_VERBOSE, mask, val);
-	drbd_send_sr_reply(mdev, rv);
+	rv = drbd_change_state(device, CS_VERBOSE, mask, val);
+	drbd_send_sr_reply(device, rv);
 
-	drbd_md_sync(mdev);
+	drbd_md_sync(device);
 
 	return 0;
 }
@@ -3819,29 +3820,29 @@ static int receive_req_conn_state(struct drbd_tconn *tconn, struct packet_info *
 
 static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct p_state *p = pi->data;
 	union drbd_state os, ns, peer_state;
 	enum drbd_disk_state real_peer_disk;
 	enum chg_state_flags cs_flags;
 	int rv;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return config_unknown_volume(tconn, pi);
 
 	peer_state.i = be32_to_cpu(p->state);
 
 	real_peer_disk = peer_state.disk;
 	if (peer_state.disk == D_NEGOTIATING) {
-		real_peer_disk = mdev->p_uuid[UI_FLAGS] & 4 ? D_INCONSISTENT : D_CONSISTENT;
+		real_peer_disk = device->p_uuid[UI_FLAGS] & 4 ? D_INCONSISTENT : D_CONSISTENT;
 		dev_info(DEV, "real peer disk state = %s\n", drbd_disk_str(real_peer_disk));
 	}
 
-	spin_lock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
  retry:
-	os = ns = drbd_read_state(mdev);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	os = ns = drbd_read_state(device);
+	spin_unlock_irq(&device->tconn->req_lock);
 
 	/* If some other part of the code (asender thread, timeout)
 	 * already decided to close the connection again,
@@ -3873,8 +3874,8 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 		 * Maybe we should finish it up, too? */
 		else if (os.conn >= C_SYNC_SOURCE &&
 			 peer_state.conn == C_CONNECTED) {
-			if (drbd_bm_total_weight(mdev) <= mdev->rs_failed)
-				drbd_resync_finished(mdev);
+			if (drbd_bm_total_weight(device) <= device->rs_failed)
+				drbd_resync_finished(device);
 			return 0;
 		}
 	}
@@ -3882,8 +3883,8 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 	/* explicit verify finished notification, stop sector reached. */
 	if (os.conn == C_VERIFY_T && os.disk == D_UP_TO_DATE &&
 	    peer_state.conn == C_CONNECTED && real_peer_disk == D_UP_TO_DATE) {
-		ov_out_of_sync_print(mdev);
-		drbd_resync_finished(mdev);
+		ov_out_of_sync_print(device);
+		drbd_resync_finished(device);
 		return 0;
 	}
 
@@ -3902,8 +3903,8 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 	if (peer_state.conn == C_AHEAD)
 		ns.conn = C_BEHIND;
 
-	if (mdev->p_uuid && peer_state.disk >= D_NEGOTIATING &&
-	    get_ldev_if_state(mdev, D_NEGOTIATING)) {
+	if (device->p_uuid && peer_state.disk >= D_NEGOTIATING &&
+	    get_ldev_if_state(device, D_NEGOTIATING)) {
 		int cr; /* consider resync */
 
 		/* if we established a new connection */
@@ -3915,7 +3916,7 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 			os.disk == D_NEGOTIATING));
 		/* if we have both been inconsistent, and the peer has been
 		 * forced to be UpToDate with --overwrite-data */
-		cr |= test_bit(CONSIDER_RESYNC, &mdev->flags);
+		cr |= test_bit(CONSIDER_RESYNC, &device->flags);
 		/* if we had been plain connected, and the admin requested to
 		 * start a sync by "invalidate" or "invalidate-remote" */
 		cr |= (os.conn == C_CONNECTED &&
@@ -3923,55 +3924,55 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 				 peer_state.conn <= C_WF_BITMAP_T));
 
 		if (cr)
-			ns.conn = drbd_sync_handshake(mdev, peer_state.role, real_peer_disk);
+			ns.conn = drbd_sync_handshake(device, peer_state.role, real_peer_disk);
 
-		put_ldev(mdev);
+		put_ldev(device);
 		if (ns.conn == C_MASK) {
 			ns.conn = C_CONNECTED;
-			if (mdev->state.disk == D_NEGOTIATING) {
-				drbd_force_state(mdev, NS(disk, D_FAILED));
+			if (device->state.disk == D_NEGOTIATING) {
+				drbd_force_state(device, NS(disk, D_FAILED));
 			} else if (peer_state.disk == D_NEGOTIATING) {
 				dev_err(DEV, "Disk attach process on the peer node was aborted.\n");
 				peer_state.disk = D_DISKLESS;
 				real_peer_disk = D_DISKLESS;
 			} else {
-				if (test_and_clear_bit(CONN_DRY_RUN, &mdev->tconn->flags))
+				if (test_and_clear_bit(CONN_DRY_RUN, &device->tconn->flags))
 					return -EIO;
 				D_ASSERT(os.conn == C_WF_REPORT_PARAMS);
-				conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+				conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 				return -EIO;
 			}
 		}
 	}
 
-	spin_lock_irq(&mdev->tconn->req_lock);
-	if (os.i != drbd_read_state(mdev).i)
+	spin_lock_irq(&device->tconn->req_lock);
+	if (os.i != drbd_read_state(device).i)
 		goto retry;
-	clear_bit(CONSIDER_RESYNC, &mdev->flags);
+	clear_bit(CONSIDER_RESYNC, &device->flags);
 	ns.peer = peer_state.role;
 	ns.pdsk = real_peer_disk;
 	ns.peer_isp = (peer_state.aftr_isp | peer_state.user_isp);
 	if ((ns.conn == C_CONNECTED || ns.conn == C_WF_BITMAP_S) && ns.disk == D_NEGOTIATING)
-		ns.disk = mdev->new_state_tmp.disk;
+		ns.disk = device->new_state_tmp.disk;
 	cs_flags = CS_VERBOSE + (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED ? 0 : CS_HARD);
-	if (ns.pdsk == D_CONSISTENT && drbd_suspended(mdev) && ns.conn == C_CONNECTED && os.conn < C_CONNECTED &&
-	    test_bit(NEW_CUR_UUID, &mdev->flags)) {
+	if (ns.pdsk == D_CONSISTENT && drbd_suspended(device) && ns.conn == C_CONNECTED && os.conn < C_CONNECTED &&
+	    test_bit(NEW_CUR_UUID, &device->flags)) {
 		/* Do not allow tl_restart(RESEND) for a rebooted peer. We can only allow this
 		   for temporal network outages! */
-		spin_unlock_irq(&mdev->tconn->req_lock);
+		spin_unlock_irq(&device->tconn->req_lock);
 		dev_err(DEV, "Aborting Connect, can not thaw IO with an only Consistent peer\n");
-		tl_clear(mdev->tconn);
-		drbd_uuid_new_current(mdev);
-		clear_bit(NEW_CUR_UUID, &mdev->flags);
-		conn_request_state(mdev->tconn, NS2(conn, C_PROTOCOL_ERROR, susp, 0), CS_HARD);
+		tl_clear(device->tconn);
+		drbd_uuid_new_current(device);
+		clear_bit(NEW_CUR_UUID, &device->flags);
+		conn_request_state(device->tconn, NS2(conn, C_PROTOCOL_ERROR, susp, 0), CS_HARD);
 		return -EIO;
 	}
-	rv = _drbd_set_state(mdev, ns, cs_flags, NULL);
-	ns = drbd_read_state(mdev);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	rv = _drbd_set_state(device, ns, cs_flags, NULL);
+	ns = drbd_read_state(device);
+	spin_unlock_irq(&device->tconn->req_lock);
 
 	if (rv < SS_SUCCESS) {
-		conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+		conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 		return -EIO;
 	}
 
@@ -3981,45 +3982,45 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 			/* we want resync, peer has not yet decided to sync... */
 			/* Nowadays only used when forcing a node into primary role and
 			   setting its disk to UpToDate with that */
-			drbd_send_uuids(mdev);
-			drbd_send_current_state(mdev);
+			drbd_send_uuids(device);
+			drbd_send_current_state(device);
 		}
 	}
 
-	clear_bit(DISCARD_MY_DATA, &mdev->flags);
+	clear_bit(DISCARD_MY_DATA, &device->flags);
 
-	drbd_md_sync(mdev); /* update connected indicator, la_size_sect, ... */
+	drbd_md_sync(device); /* update connected indicator, la_size_sect, ... */
 
 	return 0;
 }
 
 static int receive_sync_uuid(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct p_rs_uuid *p = pi->data;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
-	wait_event(mdev->misc_wait,
-		   mdev->state.conn == C_WF_SYNC_UUID ||
-		   mdev->state.conn == C_BEHIND ||
-		   mdev->state.conn < C_CONNECTED ||
-		   mdev->state.disk < D_NEGOTIATING);
+	wait_event(device->misc_wait,
+		   device->state.conn == C_WF_SYNC_UUID ||
+		   device->state.conn == C_BEHIND ||
+		   device->state.conn < C_CONNECTED ||
+		   device->state.disk < D_NEGOTIATING);
 
-	/* D_ASSERT( mdev->state.conn == C_WF_SYNC_UUID ); */
+	/* D_ASSERT( device->state.conn == C_WF_SYNC_UUID ); */
 
 	/* Here the _drbd_uuid_ functions are right, current should
 	   _not_ be rotated into the history */
-	if (get_ldev_if_state(mdev, D_NEGOTIATING)) {
-		_drbd_uuid_set(mdev, UI_CURRENT, be64_to_cpu(p->uuid));
-		_drbd_uuid_set(mdev, UI_BITMAP, 0UL);
+	if (get_ldev_if_state(device, D_NEGOTIATING)) {
+		_drbd_uuid_set(device, UI_CURRENT, be64_to_cpu(p->uuid));
+		_drbd_uuid_set(device, UI_BITMAP, 0UL);
 
-		drbd_print_uuids(mdev, "updated sync uuid");
-		drbd_start_resync(mdev, C_SYNC_TARGET);
+		drbd_print_uuids(device, "updated sync uuid");
+		drbd_start_resync(device, C_SYNC_TARGET);
 
-		put_ldev(mdev);
+		put_ldev(device);
 	} else
 		dev_err(DEV, "Ignoring SyncUUID packet!\n");
 
@@ -4033,11 +4034,11 @@ static int receive_sync_uuid(struct drbd_tconn *tconn, struct packet_info *pi)
  * code upon failure.
  */
 static int
-receive_bitmap_plain(struct drbd_device *mdev, unsigned int size,
+receive_bitmap_plain(struct drbd_device *device, unsigned int size,
 		     unsigned long *p, struct bm_xfer_ctx *c)
 {
 	unsigned int data_size = DRBD_SOCKET_BUFFER_SIZE -
-				 drbd_header_size(mdev->tconn);
+				 drbd_header_size(device->tconn);
 	unsigned int num_words = min_t(size_t, data_size / sizeof(*p),
 				       c->bm_words - c->word_offset);
 	unsigned int want = num_words * sizeof(*p);
@@ -4049,11 +4050,11 @@ receive_bitmap_plain(struct drbd_device *mdev, unsigned int size,
 	}
 	if (want == 0)
 		return 0;
-	err = drbd_recv_all(mdev->tconn, p, want);
+	err = drbd_recv_all(device->tconn, p, want);
 	if (err)
 		return err;
 
-	drbd_bm_merge_lel(mdev, c->word_offset, num_words, p);
+	drbd_bm_merge_lel(device, c->word_offset, num_words, p);
 
 	c->word_offset += num_words;
 	c->bit_offset = c->word_offset * BITS_PER_LONG;
@@ -4085,7 +4086,7 @@ static int dcbp_get_pad_bits(struct p_compressed_bm *p)
  * code upon failure.
  */
 static int
-recv_bm_rle_bits(struct drbd_device *mdev,
+recv_bm_rle_bits(struct drbd_device *device,
 		struct p_compressed_bm *p,
 		 struct bm_xfer_ctx *c,
 		 unsigned int len)
@@ -4117,7 +4118,7 @@ recv_bm_rle_bits(struct drbd_device *mdev,
 				dev_err(DEV, "bitmap overflow (e:%lu) while decoding bm RLE packet\n", e);
 				return -EIO;
 			}
-			_drbd_bm_set_bits(mdev, s, e);
+			_drbd_bm_set_bits(device, s, e);
 		}
 
 		if (have < bits) {
@@ -4154,28 +4155,28 @@ recv_bm_rle_bits(struct drbd_device *mdev,
  * code upon failure.
  */
 static int
-decode_bitmap_c(struct drbd_device *mdev,
+decode_bitmap_c(struct drbd_device *device,
 		struct p_compressed_bm *p,
 		struct bm_xfer_ctx *c,
 		unsigned int len)
 {
 	if (dcbp_get_code(p) == RLE_VLI_Bits)
-		return recv_bm_rle_bits(mdev, p, c, len - sizeof(*p));
+		return recv_bm_rle_bits(device, p, c, len - sizeof(*p));
 
 	/* other variants had been implemented for evaluation,
 	 * but have been dropped as this one turned out to be "best"
 	 * during all our tests. */
 
 	dev_err(DEV, "receive_bitmap_c: unknown encoding %u\n", p->encoding);
-	conn_request_state(mdev->tconn, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
+	conn_request_state(device->tconn, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
 	return -EIO;
 }
 
-void INFO_bm_xfer_stats(struct drbd_device *mdev,
+void INFO_bm_xfer_stats(struct drbd_device *device,
 		const char *direction, struct bm_xfer_ctx *c)
 {
 	/* what would it take to transfer it "plaintext" */
-	unsigned int header_size = drbd_header_size(mdev->tconn);
+	unsigned int header_size = drbd_header_size(device->tconn);
 	unsigned int data_size = DRBD_SOCKET_BUFFER_SIZE - header_size;
 	unsigned int plain =
 		header_size * (DIV_ROUND_UP(c->bm_words, data_size) + 1) +
@@ -4217,26 +4218,26 @@ void INFO_bm_xfer_stats(struct drbd_device *mdev,
    returns 0 on failure, 1 if we successfully received it. */
 static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct bm_xfer_ctx c;
 	int err;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
-	drbd_bm_lock(mdev, "receive bitmap", BM_LOCKED_SET_ALLOWED);
+	drbd_bm_lock(device, "receive bitmap", BM_LOCKED_SET_ALLOWED);
 	/* you are supposed to send additional out-of-sync information
 	 * if you actually set bits during this phase */
 
 	c = (struct bm_xfer_ctx) {
-		.bm_bits = drbd_bm_bits(mdev),
-		.bm_words = drbd_bm_words(mdev),
+		.bm_bits = drbd_bm_bits(device),
+		.bm_words = drbd_bm_words(device),
 	};
 
 	for(;;) {
 		if (pi->cmd == P_BITMAP)
-			err = receive_bitmap_plain(mdev, pi->size, pi->data, &c);
+			err = receive_bitmap_plain(device, pi->size, pi->data, &c);
 		else if (pi->cmd == P_COMPRESSED_BITMAP) {
 			/* MAYBE: sanity check that we speak proto >= 90,
 			 * and the feature is enabled! */
@@ -4252,10 +4253,10 @@ static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
 				err = -EIO;
 				goto out;
 			}
-			err = drbd_recv_all(mdev->tconn, p, pi->size);
+			err = drbd_recv_all(device->tconn, p, pi->size);
 			if (err)
 			       goto out;
-			err = decode_bitmap_c(mdev, p, &c, pi->size);
+			err = decode_bitmap_c(device, p, &c, pi->size);
 		} else {
 			dev_warn(DEV, "receive_bitmap: cmd neither ReportBitMap nor ReportCBitMap (is 0x%x)", pi->cmd);
 			err = -EIO;
@@ -4270,34 +4271,34 @@ static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
 				goto out;
 			break;
 		}
-		err = drbd_recv_header(mdev->tconn, pi);
+		err = drbd_recv_header(device->tconn, pi);
 		if (err)
 			goto out;
 	}
 
-	INFO_bm_xfer_stats(mdev, "receive", &c);
+	INFO_bm_xfer_stats(device, "receive", &c);
 
-	if (mdev->state.conn == C_WF_BITMAP_T) {
+	if (device->state.conn == C_WF_BITMAP_T) {
 		enum drbd_state_rv rv;
 
-		err = drbd_send_bitmap(mdev);
+		err = drbd_send_bitmap(device);
 		if (err)
 			goto out;
 		/* Omit CS_ORDERED with this state transition to avoid deadlocks. */
-		rv = _drbd_request_state(mdev, NS(conn, C_WF_SYNC_UUID), CS_VERBOSE);
+		rv = _drbd_request_state(device, NS(conn, C_WF_SYNC_UUID), CS_VERBOSE);
 		D_ASSERT(rv == SS_SUCCESS);
-	} else if (mdev->state.conn != C_WF_BITMAP_S) {
+	} else if (device->state.conn != C_WF_BITMAP_S) {
 		/* admin may have requested C_DISCONNECTING,
 		 * other threads may have noticed network errors */
 		dev_info(DEV, "unexpected cstate (%s) in receive_bitmap\n",
-		    drbd_conn_str(mdev->state.conn));
+		    drbd_conn_str(device->state.conn));
 	}
 	err = 0;
 
  out:
-	drbd_bm_unlock(mdev);
-	if (!err && mdev->state.conn == C_WF_BITMAP_S)
-		drbd_start_resync(mdev, C_SYNC_SOURCE);
+	drbd_bm_unlock(device);
+	if (!err && device->state.conn == C_WF_BITMAP_S)
+		drbd_start_resync(device, C_SYNC_SOURCE);
 	return err;
 }
 
@@ -4320,24 +4321,24 @@ static int receive_UnplugRemote(struct drbd_tconn *tconn, struct packet_info *pi
 
 static int receive_out_of_sync(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct p_block_desc *p = pi->data;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
-	switch (mdev->state.conn) {
+	switch (device->state.conn) {
 	case C_WF_SYNC_UUID:
 	case C_WF_BITMAP_T:
 	case C_BEHIND:
 			break;
 	default:
 		dev_err(DEV, "ASSERT FAILED cstate = %s, expected: WFSyncUUID|WFBitMapT|Behind\n",
-				drbd_conn_str(mdev->state.conn));
+				drbd_conn_str(device->state.conn));
 	}
 
-	drbd_set_out_of_sync(mdev, be64_to_cpu(p->sector), be32_to_cpu(p->blksize));
+	drbd_set_out_of_sync(device, be64_to_cpu(p->sector), be32_to_cpu(p->blksize));
 
 	return 0;
 }
@@ -4435,7 +4436,7 @@ void conn_flush_workqueue(struct drbd_tconn *tconn)
 
 static void conn_disconnect(struct drbd_tconn *tconn)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	enum drbd_conns oc;
 	int vnr;
 
@@ -4454,11 +4455,11 @@ static void conn_disconnect(struct drbd_tconn *tconn)
 	drbd_free_sock(tconn);
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		kref_get(&mdev->kref);
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
+		kref_get(&device->kref);
 		rcu_read_unlock();
-		drbd_disconnected(mdev);
-		kref_put(&mdev->kref, &drbd_minor_destroy);
+		drbd_disconnected(device);
+		kref_put(&device->kref, &drbd_minor_destroy);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
@@ -4485,16 +4486,16 @@ static void conn_disconnect(struct drbd_tconn *tconn)
 		conn_request_state(tconn, NS(conn, C_STANDALONE), CS_VERBOSE | CS_HARD);
 }
 
-static int drbd_disconnected(struct drbd_device *mdev)
+static int drbd_disconnected(struct drbd_device *device)
 {
 	unsigned int i;
 
 	/* wait for current activity to cease. */
-	spin_lock_irq(&mdev->tconn->req_lock);
-	_drbd_wait_ee_list_empty(mdev, &mdev->active_ee);
-	_drbd_wait_ee_list_empty(mdev, &mdev->sync_ee);
-	_drbd_wait_ee_list_empty(mdev, &mdev->read_ee);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
+	_drbd_wait_ee_list_empty(device, &device->active_ee);
+	_drbd_wait_ee_list_empty(device, &device->sync_ee);
+	_drbd_wait_ee_list_empty(device, &device->read_ee);
+	spin_unlock_irq(&device->tconn->req_lock);
 
 	/* We do not have data structures that would allow us to
 	 * get the rs_pending_cnt down to 0 again.
@@ -4506,42 +4507,42 @@ static int drbd_disconnected(struct drbd_device *mdev)
 	 *  resync_LRU. The resync_LRU tracks the whole operation including
 	 *  the disk-IO, while the rs_pending_cnt only tracks the blocks
 	 *  on the fly. */
-	drbd_rs_cancel_all(mdev);
-	mdev->rs_total = 0;
-	mdev->rs_failed = 0;
-	atomic_set(&mdev->rs_pending_cnt, 0);
-	wake_up(&mdev->misc_wait);
+	drbd_rs_cancel_all(device);
+	device->rs_total = 0;
+	device->rs_failed = 0;
+	atomic_set(&device->rs_pending_cnt, 0);
+	wake_up(&device->misc_wait);
 
-	del_timer_sync(&mdev->resync_timer);
-	resync_timer_fn((unsigned long)mdev);
+	del_timer_sync(&device->resync_timer);
+	resync_timer_fn((unsigned long)device);
 
 	/* wait for all w_e_end_data_req, w_e_end_rsdata_req, w_send_barrier,
 	 * w_make_resync_request etc. which may still be on the worker queue
 	 * to be "canceled" */
-	drbd_flush_workqueue(mdev);
+	drbd_flush_workqueue(device);
 
-	drbd_finish_peer_reqs(mdev);
+	drbd_finish_peer_reqs(device);
 
 	/* This second workqueue flush is necessary, since drbd_finish_peer_reqs()
 	   might have issued a work again. The one before drbd_finish_peer_reqs() is
 	   necessary to reclain net_ee in drbd_finish_peer_reqs(). */
-	drbd_flush_workqueue(mdev);
+	drbd_flush_workqueue(device);
 
 	/* need to do it again, drbd_finish_peer_reqs() may have populated it
 	 * again via drbd_try_clear_on_disk_bm(). */
-	drbd_rs_cancel_all(mdev);
+	drbd_rs_cancel_all(device);
 
-	kfree(mdev->p_uuid);
-	mdev->p_uuid = NULL;
+	kfree(device->p_uuid);
+	device->p_uuid = NULL;
 
-	if (!drbd_suspended(mdev))
-		tl_clear(mdev->tconn);
+	if (!drbd_suspended(device))
+		tl_clear(device->tconn);
 
-	drbd_md_sync(mdev);
+	drbd_md_sync(device);
 
 	/* serialize with bitmap writeout triggered by the state change,
 	 * if any. */
-	wait_event(mdev->misc_wait, !test_bit(BITMAP_IO, &mdev->flags));
+	wait_event(device->misc_wait, !test_bit(BITMAP_IO, &device->flags));
 
 	/* tcp_close and release of sendpage pages can be deferred.  I don't
 	 * want to use SO_LINGER, because apparently it can be deferred for
@@ -4550,20 +4551,20 @@ static int drbd_disconnected(struct drbd_device *mdev)
 	 * Actually we don't care for exactly when the network stack does its
 	 * put_page(), but release our reference on these pages right here.
 	 */
-	i = drbd_free_peer_reqs(mdev, &mdev->net_ee);
+	i = drbd_free_peer_reqs(device, &device->net_ee);
 	if (i)
 		dev_info(DEV, "net_ee not empty, killed %u entries\n", i);
-	i = atomic_read(&mdev->pp_in_use_by_net);
+	i = atomic_read(&device->pp_in_use_by_net);
 	if (i)
 		dev_info(DEV, "pp_in_use_by_net = %d, expected 0\n", i);
-	i = atomic_read(&mdev->pp_in_use);
+	i = atomic_read(&device->pp_in_use);
 	if (i)
 		dev_info(DEV, "pp_in_use = %d, expected 0\n", i);
 
-	D_ASSERT(list_empty(&mdev->read_ee));
-	D_ASSERT(list_empty(&mdev->active_ee));
-	D_ASSERT(list_empty(&mdev->sync_ee));
-	D_ASSERT(list_empty(&mdev->done_ee));
+	D_ASSERT(list_empty(&device->read_ee));
+	D_ASSERT(list_empty(&device->active_ee));
+	D_ASSERT(list_empty(&device->sync_ee));
+	D_ASSERT(list_empty(&device->done_ee));
 
 	return 0;
 }
@@ -4884,12 +4885,12 @@ static int got_conn_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int got_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct p_req_state_reply *p = pi->data;
 	int retcode = be32_to_cpu(p->retcode);
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
 	if (test_bit(CONN_WD_ST_CHG_REQ, &tconn->flags)) {
@@ -4898,13 +4899,13 @@ static int got_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 	}
 
 	if (retcode >= SS_SUCCESS) {
-		set_bit(CL_ST_CHG_SUCCESS, &mdev->flags);
+		set_bit(CL_ST_CHG_SUCCESS, &device->flags);
 	} else {
-		set_bit(CL_ST_CHG_FAIL, &mdev->flags);
+		set_bit(CL_ST_CHG_FAIL, &device->flags);
 		dev_err(DEV, "Requested state change failed by peer: %s (%d)\n",
 			drbd_set_st_err_str(retcode), retcode);
 	}
-	wake_up(&mdev->state_wait);
+	wake_up(&device->state_wait);
 
 	return 0;
 }
@@ -4927,71 +4928,71 @@ static int got_PingAck(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int got_IsInSync(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
-	D_ASSERT(mdev->tconn->agreed_pro_version >= 89);
+	D_ASSERT(device->tconn->agreed_pro_version >= 89);
 
-	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
+	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
-	if (get_ldev(mdev)) {
-		drbd_rs_complete_io(mdev, sector);
-		drbd_set_in_sync(mdev, sector, blksize);
+	if (get_ldev(device)) {
+		drbd_rs_complete_io(device, sector);
+		drbd_set_in_sync(device, sector, blksize);
 		/* rs_same_csums is supposed to count in units of BM_BLOCK_SIZE */
-		mdev->rs_same_csum += (blksize >> BM_BLOCK_SHIFT);
-		put_ldev(mdev);
+		device->rs_same_csum += (blksize >> BM_BLOCK_SHIFT);
+		put_ldev(device);
 	}
-	dec_rs_pending(mdev);
-	atomic_add(blksize >> 9, &mdev->rs_sect_in);
+	dec_rs_pending(device);
+	atomic_add(blksize >> 9, &device->rs_sect_in);
 
 	return 0;
 }
 
 static int
-validate_req_change_req_state(struct drbd_device *mdev, u64 id, sector_t sector,
+validate_req_change_req_state(struct drbd_device *device, u64 id, sector_t sector,
 			      struct rb_root *root, const char *func,
 			      enum drbd_req_event what, bool missing_ok)
 {
 	struct drbd_request *req;
 	struct bio_and_error m;
 
-	spin_lock_irq(&mdev->tconn->req_lock);
-	req = find_request(mdev, root, id, sector, missing_ok, func);
+	spin_lock_irq(&device->tconn->req_lock);
+	req = find_request(device, root, id, sector, missing_ok, func);
 	if (unlikely(!req)) {
-		spin_unlock_irq(&mdev->tconn->req_lock);
+		spin_unlock_irq(&device->tconn->req_lock);
 		return -EIO;
 	}
 	__req_mod(req, what, &m);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_unlock_irq(&device->tconn->req_lock);
 
 	if (m.bio)
-		complete_master_bio(mdev, &m);
+		complete_master_bio(device, &m);
 	return 0;
 }
 
 static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 	enum drbd_req_event what;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
-	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
+	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
 	if (p->block_id == ID_SYNCER) {
-		drbd_set_in_sync(mdev, sector, blksize);
-		dec_rs_pending(mdev);
+		drbd_set_in_sync(device, sector, blksize);
+		dec_rs_pending(device);
 		return 0;
 	}
 	switch (pi->cmd) {
@@ -5014,33 +5015,33 @@ static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
 		BUG();
 	}
 
-	return validate_req_change_req_state(mdev, p->block_id, sector,
-					     &mdev->write_requests, __func__,
+	return validate_req_change_req_state(device, p->block_id, sector,
+					     &device->write_requests, __func__,
 					     what, false);
 }
 
 static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int size = be32_to_cpu(p->blksize);
 	int err;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
-	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
+	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
 	if (p->block_id == ID_SYNCER) {
-		dec_rs_pending(mdev);
-		drbd_rs_failed_io(mdev, sector, size);
+		dec_rs_pending(device);
+		drbd_rs_failed_io(device, sector, size);
 		return 0;
 	}
 
-	err = validate_req_change_req_state(mdev, p->block_id, sector,
-					    &mdev->write_requests, __func__,
+	err = validate_req_change_req_state(device, p->block_id, sector,
+					    &device->write_requests, __func__,
 					    NEG_ACKED, true);
 	if (err) {
 		/* Protocol A has no P_WRITE_ACKs, but has P_NEG_ACKs.
@@ -5048,60 +5049,60 @@ static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 		   request is no longer in the collision hash. */
 		/* In Protocol B we might already have got a P_RECV_ACK
 		   but then get a P_NEG_ACK afterwards. */
-		drbd_set_out_of_sync(mdev, sector, size);
+		drbd_set_out_of_sync(device, sector, size);
 	}
 	return 0;
 }
 
 static int got_NegDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
-	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
+	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
 	dev_err(DEV, "Got NegDReply; Sector %llus, len %u.\n",
 	    (unsigned long long)sector, be32_to_cpu(p->blksize));
 
-	return validate_req_change_req_state(mdev, p->block_id, sector,
-					     &mdev->read_requests, __func__,
+	return validate_req_change_req_state(device, p->block_id, sector,
+					     &device->read_requests, __func__,
 					     NEG_ACKED, false);
 }
 
 static int got_NegRSDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	sector_t sector;
 	int size;
 	struct p_block_ack *p = pi->data;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
 	sector = be64_to_cpu(p->sector);
 	size = be32_to_cpu(p->blksize);
 
-	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
+	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
-	dec_rs_pending(mdev);
+	dec_rs_pending(device);
 
-	if (get_ldev_if_state(mdev, D_FAILED)) {
-		drbd_rs_complete_io(mdev, sector);
+	if (get_ldev_if_state(device, D_FAILED)) {
+		drbd_rs_complete_io(device, sector);
 		switch (pi->cmd) {
 		case P_NEG_RS_DREPLY:
-			drbd_rs_failed_io(mdev, sector, size);
+			drbd_rs_failed_io(device, sector, size);
 		case P_RS_CANCEL:
 			break;
 		default:
 			BUG();
 		}
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 
 	return 0;
@@ -5110,18 +5111,18 @@ static int got_NegRSDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 static int got_BarrierAck(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct p_barrier_ack *p = pi->data;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 
 	tl_release(tconn, p->barrier, be32_to_cpu(p->set_size));
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		if (mdev->state.conn == C_AHEAD &&
-		    atomic_read(&mdev->ap_in_flight) == 0 &&
-		    !test_and_set_bit(AHEAD_TO_SYNC_SOURCE, &mdev->flags)) {
-			mdev->start_resync_timer.expires = jiffies + HZ;
-			add_timer(&mdev->start_resync_timer);
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
+		if (device->state.conn == C_AHEAD &&
+		    atomic_read(&device->ap_in_flight) == 0 &&
+		    !test_and_set_bit(AHEAD_TO_SYNC_SOURCE, &device->flags)) {
+			device->start_resync_timer.expires = jiffies + HZ;
+			add_timer(&device->start_resync_timer);
 		}
 	}
 	rcu_read_unlock();
@@ -5131,51 +5132,51 @@ static int got_BarrierAck(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int got_OVResult(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	struct p_block_ack *p = pi->data;
 	struct drbd_work *w;
 	sector_t sector;
 	int size;
 
-	mdev = vnr_to_mdev(tconn, pi->vnr);
-	if (!mdev)
+	device = vnr_to_device(tconn, pi->vnr);
+	if (!device)
 		return -EIO;
 
 	sector = be64_to_cpu(p->sector);
 	size = be32_to_cpu(p->blksize);
 
-	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
+	update_peer_seq(device, be32_to_cpu(p->seq_num));
 
 	if (be64_to_cpu(p->block_id) == ID_OUT_OF_SYNC)
-		drbd_ov_out_of_sync_found(mdev, sector, size);
+		drbd_ov_out_of_sync_found(device, sector, size);
 	else
-		ov_out_of_sync_print(mdev);
+		ov_out_of_sync_print(device);
 
-	if (!get_ldev(mdev))
+	if (!get_ldev(device))
 		return 0;
 
-	drbd_rs_complete_io(mdev, sector);
-	dec_rs_pending(mdev);
+	drbd_rs_complete_io(device, sector);
+	dec_rs_pending(device);
 
-	--mdev->ov_left;
+	--device->ov_left;
 
 	/* let's advance progress step marks only for every other megabyte */
-	if ((mdev->ov_left & 0x200) == 0x200)
-		drbd_advance_rs_marks(mdev, mdev->ov_left);
+	if ((device->ov_left & 0x200) == 0x200)
+		drbd_advance_rs_marks(device, device->ov_left);
 
-	if (mdev->ov_left == 0) {
+	if (device->ov_left == 0) {
 		w = kmalloc(sizeof(*w), GFP_NOIO);
 		if (w) {
 			w->cb = w_ov_finished;
-			w->mdev = mdev;
-			drbd_queue_work(&mdev->tconn->sender_work, w);
+			w->device = device;
+			drbd_queue_work(&device->tconn->sender_work, w);
 		} else {
 			dev_err(DEV, "kmalloc(w) failed.");
-			ov_out_of_sync_print(mdev);
-			drbd_resync_finished(mdev);
+			ov_out_of_sync_print(device);
+			drbd_resync_finished(device);
 		}
 	}
-	put_ldev(mdev);
+	put_ldev(device);
 	return 0;
 }
 
@@ -5186,7 +5187,7 @@ static int got_skip(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int tconn_finish_peer_reqs(struct drbd_tconn *tconn)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr, not_empty = 0;
 
 	do {
@@ -5194,21 +5195,21 @@ static int tconn_finish_peer_reqs(struct drbd_tconn *tconn)
 		flush_signals(current);
 
 		rcu_read_lock();
-		idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-			kref_get(&mdev->kref);
+		idr_for_each_entry(&tconn->volumes, device, vnr) {
+			kref_get(&device->kref);
 			rcu_read_unlock();
-			if (drbd_finish_peer_reqs(mdev)) {
-				kref_put(&mdev->kref, &drbd_minor_destroy);
+			if (drbd_finish_peer_reqs(device)) {
+				kref_put(&device->kref, &drbd_minor_destroy);
 				return 1;
 			}
-			kref_put(&mdev->kref, &drbd_minor_destroy);
+			kref_put(&device->kref, &drbd_minor_destroy);
 			rcu_read_lock();
 		}
 		set_bit(SIGNAL_ASENDER, &tconn->flags);
 
 		spin_lock_irq(&tconn->req_lock);
-		idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-			not_empty = !list_empty(&mdev->done_ee);
+		idr_for_each_entry(&tconn->volumes, device, vnr) {
+			not_empty = !list_empty(&device->done_ee);
 			if (not_empty)
 				break;
 		}
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 6b81de4..70b325d 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -31,37 +31,37 @@
 #include "drbd_req.h"
 
 
-static bool drbd_may_do_local_read(struct drbd_device *mdev, sector_t sector, int size);
+static bool drbd_may_do_local_read(struct drbd_device *device, sector_t sector, int size);
 
 /* Update disk stats at start of I/O request */
-static void _drbd_start_io_acct(struct drbd_device *mdev, struct drbd_request *req)
+static void _drbd_start_io_acct(struct drbd_device *device, struct drbd_request *req)
 {
 	const int rw = bio_data_dir(req->master_bio);
 	int cpu;
 	cpu = part_stat_lock();
-	part_round_stats(cpu, &mdev->vdisk->part0);
-	part_stat_inc(cpu, &mdev->vdisk->part0, ios[rw]);
-	part_stat_add(cpu, &mdev->vdisk->part0, sectors[rw], req->i.size >> 9);
+	part_round_stats(cpu, &device->vdisk->part0);
+	part_stat_inc(cpu, &device->vdisk->part0, ios[rw]);
+	part_stat_add(cpu, &device->vdisk->part0, sectors[rw], req->i.size >> 9);
 	(void) cpu; /* The macro invocations above want the cpu argument, I do not like
 		       the compiler warning about cpu only assigned but never used... */
-	part_inc_in_flight(&mdev->vdisk->part0, rw);
+	part_inc_in_flight(&device->vdisk->part0, rw);
 	part_stat_unlock();
 }
 
 /* Update disk stats when completing request upwards */
-static void _drbd_end_io_acct(struct drbd_device *mdev, struct drbd_request *req)
+static void _drbd_end_io_acct(struct drbd_device *device, struct drbd_request *req)
 {
 	int rw = bio_data_dir(req->master_bio);
 	unsigned long duration = jiffies - req->start_time;
 	int cpu;
 	cpu = part_stat_lock();
-	part_stat_add(cpu, &mdev->vdisk->part0, ticks[rw], duration);
-	part_round_stats(cpu, &mdev->vdisk->part0);
-	part_dec_in_flight(&mdev->vdisk->part0, rw);
+	part_stat_add(cpu, &device->vdisk->part0, ticks[rw], duration);
+	part_round_stats(cpu, &device->vdisk->part0);
+	part_dec_in_flight(&device->vdisk->part0, rw);
 	part_stat_unlock();
 }
 
-static struct drbd_request *drbd_req_new(struct drbd_device *mdev,
+static struct drbd_request *drbd_req_new(struct drbd_device *device,
 					       struct bio *bio_src)
 {
 	struct drbd_request *req;
@@ -72,7 +72,7 @@ static struct drbd_request *drbd_req_new(struct drbd_device *mdev,
 
 	drbd_req_make_private_bio(req, bio_src);
 	req->rq_state    = bio_data_dir(bio_src) == WRITE ? RQ_WRITE : 0;
-	req->w.mdev      = mdev;
+	req->w.device      = device;
 	req->master_bio  = bio_src;
 	req->epoch       = 0;
 
@@ -95,7 +95,7 @@ static struct drbd_request *drbd_req_new(struct drbd_device *mdev,
 void drbd_req_destroy(struct kref *kref)
 {
 	struct drbd_request *req = container_of(kref, struct drbd_request, kref);
-	struct drbd_device *mdev = req->w.mdev;
+	struct drbd_device *device = req->w.device;
 	const unsigned s = req->rq_state;
 
 	if ((req->master_bio && !(s & RQ_POSTPONED)) ||
@@ -132,10 +132,10 @@ void drbd_req_destroy(struct kref *kref)
 		 */
 		if ((s & (RQ_POSTPONED|RQ_LOCAL_MASK|RQ_NET_MASK)) != RQ_POSTPONED) {
 			if (!(s & RQ_NET_OK) || !(s & RQ_LOCAL_OK))
-				drbd_set_out_of_sync(mdev, req->i.sector, req->i.size);
+				drbd_set_out_of_sync(device, req->i.sector, req->i.size);
 
 			if ((s & RQ_NET_OK) && (s & RQ_LOCAL_OK) && (s & RQ_NET_SIS))
-				drbd_set_in_sync(mdev, req->i.sector, req->i.size);
+				drbd_set_in_sync(device, req->i.sector, req->i.size);
 		}
 
 		/* one might be tempted to move the drbd_al_complete_io
@@ -149,9 +149,9 @@ void drbd_req_destroy(struct kref *kref)
 		 * we would forget to resync the corresponding extent.
 		 */
 		if (s & RQ_IN_ACT_LOG) {
-			if (get_ldev_if_state(mdev, D_FAILED)) {
-				drbd_al_complete_io(mdev, &req->i);
-				put_ldev(mdev);
+			if (get_ldev_if_state(device, D_FAILED)) {
+				drbd_al_complete_io(device, &req->i);
+				put_ldev(device);
 			} else if (__ratelimit(&drbd_ratelimit_state)) {
 				dev_warn(DEV, "Should have called drbd_al_complete_io(, %llu, %u), "
 					 "but my Disk seems to have failed :(\n",
@@ -179,25 +179,25 @@ void start_new_tl_epoch(struct drbd_tconn *tconn)
 	wake_all_senders(tconn);
 }
 
-void complete_master_bio(struct drbd_device *mdev,
+void complete_master_bio(struct drbd_device *device,
 		struct bio_and_error *m)
 {
 	bio_endio(m->bio, m->error);
-	dec_ap_bio(mdev);
+	dec_ap_bio(device);
 }
 
 
 static void drbd_remove_request_interval(struct rb_root *root,
 					 struct drbd_request *req)
 {
-	struct drbd_device *mdev = req->w.mdev;
+	struct drbd_device *device = req->w.device;
 	struct drbd_interval *i = &req->i;
 
 	drbd_remove_interval(root, i);
 
 	/* Wake up any processes waiting for this request to complete.  */
 	if (i->waiting)
-		wake_up(&mdev->misc_wait);
+		wake_up(&device->misc_wait);
 }
 
 /* Helper for __req_mod().
@@ -210,7 +210,7 @@ static
 void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 {
 	const unsigned s = req->rq_state;
-	struct drbd_device *mdev = req->w.mdev;
+	struct drbd_device *device = req->w.device;
 	int rw;
 	int error, ok;
 
@@ -259,9 +259,9 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 		struct rb_root *root;
 
 		if (rw == WRITE)
-			root = &mdev->write_requests;
+			root = &device->write_requests;
 		else
-			root = &mdev->read_requests;
+			root = &device->read_requests;
 		drbd_remove_request_interval(root, req);
 	}
 
@@ -273,11 +273,11 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 	 * and reset the transfer log epoch write_cnt.
 	 */
 	if (rw == WRITE &&
-	    req->epoch == atomic_read(&mdev->tconn->current_tle_nr))
-		start_new_tl_epoch(mdev->tconn);
+	    req->epoch == atomic_read(&device->tconn->current_tle_nr))
+		start_new_tl_epoch(device->tconn);
 
 	/* Update disk stats */
-	_drbd_end_io_acct(mdev, req);
+	_drbd_end_io_acct(device, req);
 
 	/* If READ failed,
 	 * have it be pushed back to the retry work queue,
@@ -305,7 +305,7 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 
 static int drbd_req_put_completion_ref(struct drbd_request *req, struct bio_and_error *m, int put)
 {
-	struct drbd_device *mdev = req->w.mdev;
+	struct drbd_device *device = req->w.device;
 	D_ASSERT(m || (req->rq_state & RQ_POSTPONED));
 
 	if (!atomic_sub_and_test(put, &req->completion_ref))
@@ -328,12 +328,12 @@ static int drbd_req_put_completion_ref(struct drbd_request *req, struct bio_and_
 static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 		int clear, int set)
 {
-	struct drbd_device *mdev = req->w.mdev;
+	struct drbd_device *device = req->w.device;
 	unsigned s = req->rq_state;
 	int c_put = 0;
 	int k_put = 0;
 
-	if (drbd_suspended(mdev) && !((s | clear) & RQ_COMPLETION_SUSP))
+	if (drbd_suspended(device) && !((s | clear) & RQ_COMPLETION_SUSP))
 		set |= RQ_COMPLETION_SUSP;
 
 	/* apply */
@@ -351,7 +351,7 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 		atomic_inc(&req->completion_ref);
 
 	if (!(s & RQ_NET_PENDING) && (set & RQ_NET_PENDING)) {
-		inc_ap_pending(mdev);
+		inc_ap_pending(device);
 		atomic_inc(&req->completion_ref);
 	}
 
@@ -362,7 +362,7 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 		kref_get(&req->kref); /* wait for the DONE */
 
 	if (!(s & RQ_NET_SENT) && (set & RQ_NET_SENT))
-		atomic_add(req->i.size >> 9, &mdev->ap_in_flight);
+		atomic_add(req->i.size >> 9, &device->ap_in_flight);
 
 	if (!(s & RQ_COMPLETION_SUSP) && (set & RQ_COMPLETION_SUSP))
 		atomic_inc(&req->completion_ref);
@@ -388,7 +388,7 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 	}
 
 	if ((s & RQ_NET_PENDING) && (clear & RQ_NET_PENDING)) {
-		dec_ap_pending(mdev);
+		dec_ap_pending(device);
 		++c_put;
 	}
 
@@ -397,7 +397,7 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 
 	if ((s & RQ_EXP_BARR_ACK) && !(s & RQ_NET_DONE) && (set & RQ_NET_DONE)) {
 		if (req->rq_state & RQ_NET_SENT)
-			atomic_sub(req->i.size >> 9, &mdev->ap_in_flight);
+			atomic_sub(req->i.size >> 9, &device->ap_in_flight);
 		++k_put;
 	}
 
@@ -416,7 +416,7 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 
 	/* If we made progress, retry conflicting peer requests, if any. */
 	if (req->i.waiting)
-		wake_up(&mdev->misc_wait);
+		wake_up(&device->misc_wait);
 
 	if (c_put)
 		k_put += drbd_req_put_completion_ref(req, m, c_put);
@@ -424,7 +424,7 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 		kref_sub(&req->kref, k_put, drbd_req_destroy);
 }
 
-static void drbd_report_io_error(struct drbd_device *mdev, struct drbd_request *req)
+static void drbd_report_io_error(struct drbd_device *device, struct drbd_request *req)
 {
         char b[BDEVNAME_SIZE];
 
@@ -435,7 +435,7 @@ static void drbd_report_io_error(struct drbd_device *mdev, struct drbd_request *
 			(req->rq_state & RQ_WRITE) ? "WRITE" : "READ",
 			(unsigned long long)req->i.sector,
 			req->i.size >> 9,
-			bdevname(mdev->ldev->backing_bdev, b));
+			bdevname(device->ldev->backing_bdev, b));
 }
 
 /* obviously this could be coded as many single functions
@@ -453,7 +453,7 @@ static void drbd_report_io_error(struct drbd_device *mdev, struct drbd_request *
 int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		struct bio_and_error *m)
 {
-	struct drbd_device *mdev = req->w.mdev;
+	struct drbd_device *device = req->w.device;
 	struct net_conf *nc;
 	int p, rv = 0;
 
@@ -476,7 +476,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * and from w_read_retry_remote */
 		D_ASSERT(!(req->rq_state & RQ_NET_MASK));
 		rcu_read_lock();
-		nc = rcu_dereference(mdev->tconn->net_conf);
+		nc = rcu_dereference(device->tconn->net_conf);
 		p = nc->wire_protocol;
 		rcu_read_unlock();
 		req->rq_state |=
@@ -493,9 +493,9 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 	case COMPLETED_OK:
 		if (req->rq_state & RQ_WRITE)
-			mdev->writ_cnt += req->i.size >> 9;
+			device->writ_cnt += req->i.size >> 9;
 		else
-			mdev->read_cnt += req->i.size >> 9;
+			device->read_cnt += req->i.size >> 9;
 
 		mod_rq_state(req, m, RQ_LOCAL_PENDING,
 				RQ_LOCAL_COMPLETED|RQ_LOCAL_OK);
@@ -506,15 +506,15 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		break;
 
 	case WRITE_COMPLETED_WITH_ERROR:
-		drbd_report_io_error(mdev, req);
-		__drbd_chk_io_error(mdev, DRBD_WRITE_ERROR);
+		drbd_report_io_error(device, req);
+		__drbd_chk_io_error(device, DRBD_WRITE_ERROR);
 		mod_rq_state(req, m, RQ_LOCAL_PENDING, RQ_LOCAL_COMPLETED);
 		break;
 
 	case READ_COMPLETED_WITH_ERROR:
-		drbd_set_out_of_sync(mdev, req->i.sector, req->i.size);
-		drbd_report_io_error(mdev, req);
-		__drbd_chk_io_error(mdev, DRBD_READ_ERROR);
+		drbd_set_out_of_sync(device, req->i.sector, req->i.size);
+		drbd_report_io_error(device, req);
+		__drbd_chk_io_error(device, DRBD_READ_ERROR);
 		/* fall through. */
 	case READ_AHEAD_COMPLETED_WITH_ERROR:
 		/* it is legal to fail READA, no __drbd_chk_io_error in that case. */
@@ -533,15 +533,15 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		 * Corresponding drbd_remove_request_interval is in
 		 * drbd_req_complete() */
 		D_ASSERT(drbd_interval_empty(&req->i));
-		drbd_insert_interval(&mdev->read_requests, &req->i);
+		drbd_insert_interval(&device->read_requests, &req->i);
 
-		set_bit(UNPLUG_REMOTE, &mdev->flags);
+		set_bit(UNPLUG_REMOTE, &device->flags);
 
 		D_ASSERT(req->rq_state & RQ_NET_PENDING);
 		D_ASSERT((req->rq_state & RQ_LOCAL_MASK) == 0);
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED);
 		req->w.cb = w_send_read_req;
-		drbd_queue_work(&mdev->tconn->sender_work, &req->w);
+		drbd_queue_work(&device->tconn->sender_work, &req->w);
 		break;
 
 	case QUEUE_FOR_NET_WRITE:
@@ -551,7 +551,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		/* Corresponding drbd_remove_request_interval is in
 		 * drbd_req_complete() */
 		D_ASSERT(drbd_interval_empty(&req->i));
-		drbd_insert_interval(&mdev->write_requests, &req->i);
+		drbd_insert_interval(&device->write_requests, &req->i);
 
 		/* NOTE
 		 * In case the req ended up on the transfer log before being
@@ -570,28 +570,28 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		/* otherwise we may lose an unplug, which may cause some remote
 		 * io-scheduler timeout to expire, increasing maximum latency,
 		 * hurting performance. */
-		set_bit(UNPLUG_REMOTE, &mdev->flags);
+		set_bit(UNPLUG_REMOTE, &device->flags);
 
 		/* queue work item to send data */
 		D_ASSERT(req->rq_state & RQ_NET_PENDING);
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED|RQ_EXP_BARR_ACK);
 		req->w.cb =  w_send_dblock;
-		drbd_queue_work(&mdev->tconn->sender_work, &req->w);
+		drbd_queue_work(&device->tconn->sender_work, &req->w);
 
 		/* close the epoch, in case it outgrew the limit */
 		rcu_read_lock();
-		nc = rcu_dereference(mdev->tconn->net_conf);
+		nc = rcu_dereference(device->tconn->net_conf);
 		p = nc->max_epoch_size;
 		rcu_read_unlock();
-		if (mdev->tconn->current_tle_writes >= p)
-			start_new_tl_epoch(mdev->tconn);
+		if (device->tconn->current_tle_writes >= p)
+			start_new_tl_epoch(device->tconn);
 
 		break;
 
 	case QUEUE_FOR_SEND_OOS:
 		mod_rq_state(req, m, 0, RQ_NET_QUEUED);
 		req->w.cb =  w_send_out_of_sync;
-		drbd_queue_work(&mdev->tconn->sender_work, &req->w);
+		drbd_queue_work(&device->tconn->sender_work, &req->w);
 		break;
 
 	case READ_RETRY_REMOTE_CANCELED:
@@ -673,7 +673,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		D_ASSERT(req->rq_state & RQ_NET_PENDING);
 		req->rq_state |= RQ_POSTPONED;
 		if (req->i.waiting)
-			wake_up(&mdev->misc_wait);
+			wake_up(&device->misc_wait);
 		/* Do not clear RQ_NET_PENDING. This request will make further
 		 * progress via restart_conflicting_writes() or
 		 * fail_postponed_requests(). Hopefully. */
@@ -701,9 +701,9 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		if (bio_data_dir(req->master_bio) == WRITE)
 			rv = MR_WRITE;
 
-		get_ldev(mdev); /* always succeeds in this call path */
+		get_ldev(device); /* always succeeds in this call path */
 		req->w.cb = w_restart_disk_io;
-		drbd_queue_work(&mdev->tconn->sender_work, &req->w);
+		drbd_queue_work(&device->tconn->sender_work, &req->w);
 		break;
 
 	case RESEND:
@@ -724,7 +724,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 			mod_rq_state(req, m, RQ_COMPLETION_SUSP, RQ_NET_QUEUED|RQ_NET_PENDING);
 			if (req->w.cb) {
-				drbd_queue_work(&mdev->tconn->sender_work, &req->w);
+				drbd_queue_work(&device->tconn->sender_work, &req->w);
 				rv = req->rq_state & RQ_WRITE ? MR_WRITE : MR_READ;
 			} /* else: FIXME can this happen? */
 			break;
@@ -756,7 +756,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		break;
 
 	case QUEUE_AS_DRBD_BARRIER:
-		start_new_tl_epoch(mdev->tconn);
+		start_new_tl_epoch(device->tconn);
 		mod_rq_state(req, m, 0, RQ_NET_OK|RQ_NET_DONE);
 		break;
 	};
@@ -771,27 +771,27 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
  *   since size may be bigger than BM_BLOCK_SIZE,
  *   we may need to check several bits.
  */
-static bool drbd_may_do_local_read(struct drbd_device *mdev, sector_t sector, int size)
+static bool drbd_may_do_local_read(struct drbd_device *device, sector_t sector, int size)
 {
 	unsigned long sbnr, ebnr;
 	sector_t esector, nr_sectors;
 
-	if (mdev->state.disk == D_UP_TO_DATE)
+	if (device->state.disk == D_UP_TO_DATE)
 		return true;
-	if (mdev->state.disk != D_INCONSISTENT)
+	if (device->state.disk != D_INCONSISTENT)
 		return false;
 	esector = sector + (size >> 9) - 1;
-	nr_sectors = drbd_get_capacity(mdev->this_bdev);
+	nr_sectors = drbd_get_capacity(device->this_bdev);
 	D_ASSERT(sector  < nr_sectors);
 	D_ASSERT(esector < nr_sectors);
 
 	sbnr = BM_SECT_TO_BIT(sector);
 	ebnr = BM_SECT_TO_BIT(esector);
 
-	return drbd_bm_count_bits(mdev, sbnr, ebnr) == 0;
+	return drbd_bm_count_bits(device, sbnr, ebnr) == 0;
 }
 
-static bool remote_due_to_read_balancing(struct drbd_device *mdev, sector_t sector,
+static bool remote_due_to_read_balancing(struct drbd_device *device, sector_t sector,
 		enum drbd_read_balancing rbm)
 {
 	struct backing_dev_info *bdi;
@@ -799,11 +799,11 @@ static bool remote_due_to_read_balancing(struct drbd_device *mdev, sector_t sect
 
 	switch (rbm) {
 	case RB_CONGESTED_REMOTE:
-		bdi = &mdev->ldev->backing_bdev->bd_disk->queue->backing_dev_info;
+		bdi = &device->ldev->backing_bdev->bd_disk->queue->backing_dev_info;
 		return bdi_read_congested(bdi);
 	case RB_LEAST_PENDING:
-		return atomic_read(&mdev->local_cnt) >
-			atomic_read(&mdev->ap_pending_cnt) + atomic_read(&mdev->rs_pending_cnt);
+		return atomic_read(&device->local_cnt) >
+			atomic_read(&device->ap_pending_cnt) + atomic_read(&device->rs_pending_cnt);
 	case RB_32K_STRIPING:  /* stripe_shift = 15 */
 	case RB_64K_STRIPING:
 	case RB_128K_STRIPING:
@@ -813,7 +813,7 @@ static bool remote_due_to_read_balancing(struct drbd_device *mdev, sector_t sect
 		stripe_shift = (rbm - RB_32K_STRIPING + 15);
 		return (sector >> (stripe_shift - 9)) & 1;
 	case RB_ROUND_ROBIN:
-		return test_and_change_bit(READ_BALANCE_RR, &mdev->flags);
+		return test_and_change_bit(READ_BALANCE_RR, &device->flags);
 	case RB_PREFER_REMOTE:
 		return true;
 	case RB_PREFER_LOCAL:
@@ -834,33 +834,33 @@ static bool remote_due_to_read_balancing(struct drbd_device *mdev, sector_t sect
 static void complete_conflicting_writes(struct drbd_request *req)
 {
 	DEFINE_WAIT(wait);
-	struct drbd_device *mdev = req->w.mdev;
+	struct drbd_device *device = req->w.device;
 	struct drbd_interval *i;
 	sector_t sector = req->i.sector;
 	int size = req->i.size;
 
-	i = drbd_find_overlap(&mdev->write_requests, sector, size);
+	i = drbd_find_overlap(&device->write_requests, sector, size);
 	if (!i)
 		return;
 
 	for (;;) {
-		prepare_to_wait(&mdev->misc_wait, &wait, TASK_UNINTERRUPTIBLE);
-		i = drbd_find_overlap(&mdev->write_requests, sector, size);
+		prepare_to_wait(&device->misc_wait, &wait, TASK_UNINTERRUPTIBLE);
+		i = drbd_find_overlap(&device->write_requests, sector, size);
 		if (!i)
 			break;
 		/* Indicate to wake up device->misc_wait on progress.  */
 		i->waiting = true;
-		spin_unlock_irq(&mdev->tconn->req_lock);
+		spin_unlock_irq(&device->tconn->req_lock);
 		schedule();
-		spin_lock_irq(&mdev->tconn->req_lock);
+		spin_lock_irq(&device->tconn->req_lock);
 	}
-	finish_wait(&mdev->misc_wait, &wait);
+	finish_wait(&device->misc_wait, &wait);
 }
 
 /* called within req_lock and rcu_read_lock() */
-static void maybe_pull_ahead(struct drbd_device *mdev)
+static void maybe_pull_ahead(struct drbd_device *device)
 {
-	struct drbd_tconn *tconn = mdev->tconn;
+	struct drbd_tconn *tconn = device->tconn;
 	struct net_conf *nc;
 	bool congested = false;
 	enum drbd_on_congestion on_congestion;
@@ -875,32 +875,32 @@ static void maybe_pull_ahead(struct drbd_device *mdev)
 
 	/* If I don't even have good local storage, we can not reasonably try
 	 * to pull ahead of the peer. We also need the local reference to make
-	 * sure mdev->act_log is there.
+	 * sure device->act_log is there.
 	 */
-	if (!get_ldev_if_state(mdev, D_UP_TO_DATE))
+	if (!get_ldev_if_state(device, D_UP_TO_DATE))
 		return;
 
 	if (nc->cong_fill &&
-	    atomic_read(&mdev->ap_in_flight) >= nc->cong_fill) {
+	    atomic_read(&device->ap_in_flight) >= nc->cong_fill) {
 		dev_info(DEV, "Congestion-fill threshold reached\n");
 		congested = true;
 	}
 
-	if (mdev->act_log->used >= nc->cong_extents) {
+	if (device->act_log->used >= nc->cong_extents) {
 		dev_info(DEV, "Congestion-extents threshold reached\n");
 		congested = true;
 	}
 
 	if (congested) {
 		/* start a new epoch for non-mirrored writes */
-		start_new_tl_epoch(mdev->tconn);
+		start_new_tl_epoch(device->tconn);
 
 		if (on_congestion == OC_PULL_AHEAD)
-			_drbd_set_state(_NS(mdev, conn, C_AHEAD), 0, NULL);
+			_drbd_set_state(_NS(device, conn, C_AHEAD), 0, NULL);
 		else  /*nc->on_congestion == OC_DISCONNECT */
-			_drbd_set_state(_NS(mdev, conn, C_DISCONNECTING), 0, NULL);
+			_drbd_set_state(_NS(device, conn, C_DISCONNECTING), 0, NULL);
 	}
-	put_ldev(mdev);
+	put_ldev(device);
 }
 
 /* If this returns false, and req->private_bio is still set,
@@ -914,19 +914,19 @@ static void maybe_pull_ahead(struct drbd_device *mdev)
  */
 static bool do_remote_read(struct drbd_request *req)
 {
-	struct drbd_device *mdev = req->w.mdev;
+	struct drbd_device *device = req->w.device;
 	enum drbd_read_balancing rbm;
 
 	if (req->private_bio) {
-		if (!drbd_may_do_local_read(mdev,
+		if (!drbd_may_do_local_read(device,
 					req->i.sector, req->i.size)) {
 			bio_put(req->private_bio);
 			req->private_bio = NULL;
-			put_ldev(mdev);
+			put_ldev(device);
 		}
 	}
 
-	if (mdev->state.pdsk != D_UP_TO_DATE)
+	if (device->state.pdsk != D_UP_TO_DATE)
 		return false;
 
 	if (req->private_bio == NULL)
@@ -936,17 +936,17 @@ static bool do_remote_read(struct drbd_request *req)
 	 * protocol, pending requests etc. */
 
 	rcu_read_lock();
-	rbm = rcu_dereference(mdev->ldev->disk_conf)->read_balancing;
+	rbm = rcu_dereference(device->ldev->disk_conf)->read_balancing;
 	rcu_read_unlock();
 
 	if (rbm == RB_PREFER_LOCAL && req->private_bio)
 		return false; /* submit locally */
 
-	if (remote_due_to_read_balancing(mdev, req->i.sector, rbm)) {
+	if (remote_due_to_read_balancing(device, req->i.sector, rbm)) {
 		if (req->private_bio) {
 			bio_put(req->private_bio);
 			req->private_bio = NULL;
-			put_ldev(mdev);
+			put_ldev(device);
 		}
 		return true;
 	}
@@ -959,11 +959,11 @@ static bool do_remote_read(struct drbd_request *req)
  * which does NOT include those that we are L_AHEAD for. */
 static int drbd_process_write_request(struct drbd_request *req)
 {
-	struct drbd_device *mdev = req->w.mdev;
+	struct drbd_device *device = req->w.device;
 	int remote, send_oos;
 
-	remote = drbd_should_do_remote(mdev->state);
-	send_oos = drbd_should_send_out_of_sync(mdev->state);
+	remote = drbd_should_do_remote(device->state);
+	send_oos = drbd_should_send_out_of_sync(device->state);
 
 	/* Need to replicate writes.  Unless it is an empty flush,
 	 * which is better mapped to a DRBD P_BARRIER packet,
@@ -987,7 +987,7 @@ static int drbd_process_write_request(struct drbd_request *req)
 	if (remote) {
 		_req_mod(req, TO_BE_SENT);
 		_req_mod(req, QUEUE_FOR_NET_WRITE);
-	} else if (drbd_set_out_of_sync(mdev, req->i.sector, req->i.size))
+	} else if (drbd_set_out_of_sync(device, req->i.sector, req->i.size))
 		_req_mod(req, QUEUE_FOR_SEND_OOS);
 
 	return remote;
@@ -996,36 +996,36 @@ static int drbd_process_write_request(struct drbd_request *req)
 static void
 drbd_submit_req_private_bio(struct drbd_request *req)
 {
-	struct drbd_device *mdev = req->w.mdev;
+	struct drbd_device *device = req->w.device;
 	struct bio *bio = req->private_bio;
 	const int rw = bio_rw(bio);
 
-	bio->bi_bdev = mdev->ldev->backing_bdev;
+	bio->bi_bdev = device->ldev->backing_bdev;
 
 	/* State may have changed since we grabbed our reference on the
 	 * ->ldev member. Double check, and short-circuit to endio.
 	 * In case the last activity log transaction failed to get on
 	 * stable storage, and this is a WRITE, we may not even submit
 	 * this bio. */
-	if (get_ldev(mdev)) {
-		if (drbd_insert_fault(mdev,
+	if (get_ldev(device)) {
+		if (drbd_insert_fault(device,
 				      rw == WRITE ? DRBD_FAULT_DT_WR
 				    : rw == READ  ? DRBD_FAULT_DT_RD
 				    :               DRBD_FAULT_DT_RA))
 			bio_endio(bio, -EIO);
 		else
 			generic_make_request(bio);
-		put_ldev(mdev);
+		put_ldev(device);
 	} else
 		bio_endio(bio, -EIO);
 }
 
-static void drbd_queue_write(struct drbd_device *mdev, struct drbd_request *req)
+static void drbd_queue_write(struct drbd_device *device, struct drbd_request *req)
 {
-	spin_lock(&mdev->submit.lock);
-	list_add_tail(&req->tl_requests, &mdev->submit.writes);
-	spin_unlock(&mdev->submit.lock);
-	queue_work(mdev->submit.wq, &mdev->submit.worker);
+	spin_lock(&device->submit.lock);
+	list_add_tail(&req->tl_requests, &device->submit.writes);
+	spin_unlock(&device->submit.lock);
+	queue_work(device->submit.wq, &device->submit.worker);
 }
 
 /* returns the new drbd_request pointer, if the caller is expected to
@@ -1034,15 +1034,15 @@ static void drbd_queue_write(struct drbd_device *mdev, struct drbd_request *req)
  * Returns ERR_PTR(-ENOMEM) if we cannot allocate a drbd_request.
  */
 struct drbd_request *
-drbd_request_prepare(struct drbd_device *mdev, struct bio *bio, unsigned long start_time)
+drbd_request_prepare(struct drbd_device *device, struct bio *bio, unsigned long start_time)
 {
 	const int rw = bio_data_dir(bio);
 	struct drbd_request *req;
 
 	/* allocate outside of all locks; */
-	req = drbd_req_new(mdev, bio);
+	req = drbd_req_new(device, bio);
 	if (!req) {
-		dec_ap_bio(mdev);
+		dec_ap_bio(device);
 		/* only pass the error to the upper layers.
 		 * if user cannot handle io errors, that's not our business. */
 		dev_err(DEV, "could not kmalloc() req\n");
@@ -1051,18 +1051,18 @@ drbd_request_prepare(struct drbd_device *mdev, struct bio *bio, unsigned long st
 	}
 	req->start_time = start_time;
 
-	if (!get_ldev(mdev)) {
+	if (!get_ldev(device)) {
 		bio_put(req->private_bio);
 		req->private_bio = NULL;
 	}
 
 	/* Update disk stats */
-	_drbd_start_io_acct(mdev, req);
+	_drbd_start_io_acct(device, req);
 
 	if (rw == WRITE && req->private_bio && req->i.size
-	&& !test_bit(AL_SUSPENDED, &mdev->flags)) {
-		if (!drbd_al_begin_io_fastpath(mdev, &req->i)) {
-			drbd_queue_write(mdev, req);
+	&& !test_bit(AL_SUSPENDED, &device->flags)) {
+		if (!drbd_al_begin_io_fastpath(device, &req->i)) {
+			drbd_queue_write(device, req);
 			return NULL;
 		}
 		req->rq_state |= RQ_IN_ACT_LOG;
@@ -1071,13 +1071,13 @@ drbd_request_prepare(struct drbd_device *mdev, struct bio *bio, unsigned long st
 	return req;
 }
 
-static void drbd_send_and_submit(struct drbd_device *mdev, struct drbd_request *req)
+static void drbd_send_and_submit(struct drbd_device *device, struct drbd_request *req)
 {
 	const int rw = bio_rw(req->master_bio);
 	struct bio_and_error m = { NULL, };
 	bool no_remote = false;
 
-	spin_lock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
 	if (rw == WRITE) {
 		/* This may temporarily give up the req_lock,
 		 * but will re-aquire it before it returns here.
@@ -1087,17 +1087,17 @@ static void drbd_send_and_submit(struct drbd_device *mdev, struct drbd_request *
 
 		/* check for congestion, and potentially stop sending
 		 * full data updates, but start sending "dirty bits" only. */
-		maybe_pull_ahead(mdev);
+		maybe_pull_ahead(device);
 	}
 
 
-	if (drbd_suspended(mdev)) {
+	if (drbd_suspended(device)) {
 		/* push back and retry: */
 		req->rq_state |= RQ_POSTPONED;
 		if (req->private_bio) {
 			bio_put(req->private_bio);
 			req->private_bio = NULL;
-			put_ldev(mdev);
+			put_ldev(device);
 		}
 		goto out;
 	}
@@ -1111,15 +1111,15 @@ static void drbd_send_and_submit(struct drbd_device *mdev, struct drbd_request *
 	}
 
 	/* which transfer log epoch does this belong to? */
-	req->epoch = atomic_read(&mdev->tconn->current_tle_nr);
+	req->epoch = atomic_read(&device->tconn->current_tle_nr);
 
 	/* no point in adding empty flushes to the transfer log,
 	 * they are mapped to drbd barriers already. */
 	if (likely(req->i.size!=0)) {
 		if (rw == WRITE)
-			mdev->tconn->current_tle_writes++;
+			device->tconn->current_tle_writes++;
 
-		list_add_tail(&req->tl_requests, &mdev->tconn->transfer_log);
+		list_add_tail(&req->tl_requests, &device->tconn->transfer_log);
 	}
 
 	if (rw == WRITE) {
@@ -1139,9 +1139,9 @@ static void drbd_send_and_submit(struct drbd_device *mdev, struct drbd_request *
 		/* needs to be marked within the same spinlock */
 		_req_mod(req, TO_BE_SUBMITTED);
 		/* but we need to give up the spinlock to submit */
-		spin_unlock_irq(&mdev->tconn->req_lock);
+		spin_unlock_irq(&device->tconn->req_lock);
 		drbd_submit_req_private_bio(req);
-		spin_lock_irq(&mdev->tconn->req_lock);
+		spin_lock_irq(&device->tconn->req_lock);
 	} else if (no_remote) {
 nodata:
 		if (__ratelimit(&drbd_ratelimit_state))
@@ -1154,21 +1154,21 @@ nodata:
 out:
 	if (drbd_req_put_completion_ref(req, &m, 1))
 		kref_put(&req->kref, drbd_req_destroy);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_unlock_irq(&device->tconn->req_lock);
 
 	if (m.bio)
-		complete_master_bio(mdev, &m);
+		complete_master_bio(device, &m);
 }
 
-void __drbd_make_request(struct drbd_device *mdev, struct bio *bio, unsigned long start_time)
+void __drbd_make_request(struct drbd_device *device, struct bio *bio, unsigned long start_time)
 {
-	struct drbd_request *req = drbd_request_prepare(mdev, bio, start_time);
+	struct drbd_request *req = drbd_request_prepare(device, bio, start_time);
 	if (IS_ERR_OR_NULL(req))
 		return;
-	drbd_send_and_submit(mdev, req);
+	drbd_send_and_submit(device, req);
 }
 
-static void submit_fast_path(struct drbd_device *mdev, struct list_head *incoming)
+static void submit_fast_path(struct drbd_device *device, struct list_head *incoming)
 {
 	struct drbd_request *req, *tmp;
 	list_for_each_entry_safe(req, tmp, incoming, tl_requests) {
@@ -1176,19 +1176,19 @@ static void submit_fast_path(struct drbd_device *mdev, struct list_head *incomin
 
 		if (rw == WRITE /* rw != WRITE should not even end up here! */
 		&& req->private_bio && req->i.size
-		&& !test_bit(AL_SUSPENDED, &mdev->flags)) {
-			if (!drbd_al_begin_io_fastpath(mdev, &req->i))
+		&& !test_bit(AL_SUSPENDED, &device->flags)) {
+			if (!drbd_al_begin_io_fastpath(device, &req->i))
 				continue;
 
 			req->rq_state |= RQ_IN_ACT_LOG;
 		}
 
 		list_del_init(&req->tl_requests);
-		drbd_send_and_submit(mdev, req);
+		drbd_send_and_submit(device, req);
 	}
 }
 
-static bool prepare_al_transaction_nonblock(struct drbd_device *mdev,
+static bool prepare_al_transaction_nonblock(struct drbd_device *device,
 					    struct list_head *incoming,
 					    struct list_head *pending)
 {
@@ -1196,9 +1196,9 @@ static bool prepare_al_transaction_nonblock(struct drbd_device *mdev,
 	int wake = 0;
 	int err;
 
-	spin_lock_irq(&mdev->al_lock);
+	spin_lock_irq(&device->al_lock);
 	list_for_each_entry_safe(req, tmp, incoming, tl_requests) {
-		err = drbd_al_begin_io_nonblock(mdev, &req->i);
+		err = drbd_al_begin_io_nonblock(device, &req->i);
 		if (err == -EBUSY)
 			wake = 1;
 		if (err)
@@ -1206,30 +1206,30 @@ static bool prepare_al_transaction_nonblock(struct drbd_device *mdev,
 		req->rq_state |= RQ_IN_ACT_LOG;
 		list_move_tail(&req->tl_requests, pending);
 	}
-	spin_unlock_irq(&mdev->al_lock);
+	spin_unlock_irq(&device->al_lock);
 	if (wake)
-		wake_up(&mdev->al_wait);
+		wake_up(&device->al_wait);
 
 	return !list_empty(pending);
 }
 
 void do_submit(struct work_struct *ws)
 {
-	struct drbd_device *mdev = container_of(ws, struct drbd_device, submit.worker);
+	struct drbd_device *device = container_of(ws, struct drbd_device, submit.worker);
 	LIST_HEAD(incoming);
 	LIST_HEAD(pending);
 	struct drbd_request *req, *tmp;
 
 	for (;;) {
-		spin_lock(&mdev->submit.lock);
-		list_splice_tail_init(&mdev->submit.writes, &incoming);
-		spin_unlock(&mdev->submit.lock);
+		spin_lock(&device->submit.lock);
+		list_splice_tail_init(&device->submit.writes, &incoming);
+		spin_unlock(&device->submit.lock);
 
-		submit_fast_path(mdev, &incoming);
+		submit_fast_path(device, &incoming);
 		if (list_empty(&incoming))
 			break;
 
-		wait_event(mdev->al_wait, prepare_al_transaction_nonblock(mdev, &incoming, &pending));
+		wait_event(device->al_wait, prepare_al_transaction_nonblock(device, &incoming, &pending));
 		/* Maybe more was queued, while we prepared the transaction?
 		 * Try to stuff them into this transaction as well.
 		 * Be strictly non-blocking here, no wait_event, we already
@@ -1243,17 +1243,17 @@ void do_submit(struct work_struct *ws)
 
 			/* It is ok to look outside the lock,
 			 * it's only an optimization anyways */
-			if (list_empty(&mdev->submit.writes))
+			if (list_empty(&device->submit.writes))
 				break;
 
-			spin_lock(&mdev->submit.lock);
-			list_splice_tail_init(&mdev->submit.writes, &more_incoming);
-			spin_unlock(&mdev->submit.lock);
+			spin_lock(&device->submit.lock);
+			list_splice_tail_init(&device->submit.writes, &more_incoming);
+			spin_unlock(&device->submit.lock);
 
 			if (list_empty(&more_incoming))
 				break;
 
-			made_progress = prepare_al_transaction_nonblock(mdev, &more_incoming, &more_pending);
+			made_progress = prepare_al_transaction_nonblock(device, &more_incoming, &more_pending);
 
 			list_splice_tail_init(&more_pending, &pending);
 			list_splice_tail_init(&more_incoming, &incoming);
@@ -1261,18 +1261,18 @@ void do_submit(struct work_struct *ws)
 			if (!made_progress)
 				break;
 		}
-		drbd_al_begin_io_commit(mdev, false);
+		drbd_al_begin_io_commit(device, false);
 
 		list_for_each_entry_safe(req, tmp, &pending, tl_requests) {
 			list_del_init(&req->tl_requests);
-			drbd_send_and_submit(mdev, req);
+			drbd_send_and_submit(device, req);
 		}
 	}
 }
 
 void drbd_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct drbd_device *mdev = (struct drbd_device *) q->queuedata;
+	struct drbd_device *device = (struct drbd_device *) q->queuedata;
 	unsigned long start_time;
 
 	start_time = jiffies;
@@ -1282,8 +1282,8 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 	 */
 	D_ASSERT(IS_ALIGNED(bio->bi_iter.bi_size, 512));
 
-	inc_ap_bio(mdev);
-	__drbd_make_request(mdev, bio, start_time);
+	inc_ap_bio(device);
+	__drbd_make_request(device, bio, start_time);
 }
 
 /* This is called by bio_add_page().
@@ -1300,20 +1300,20 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
  */
 int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct bio_vec *bvec)
 {
-	struct drbd_device *mdev = (struct drbd_device *) q->queuedata;
+	struct drbd_device *device = (struct drbd_device *) q->queuedata;
 	unsigned int bio_size = bvm->bi_size;
 	int limit = DRBD_MAX_BIO_SIZE;
 	int backing_limit;
 
-	if (bio_size && get_ldev(mdev)) {
+	if (bio_size && get_ldev(device)) {
 		unsigned int max_hw_sectors = queue_max_hw_sectors(q);
 		struct request_queue * const b =
-			mdev->ldev->backing_bdev->bd_disk->queue;
+			device->ldev->backing_bdev->bd_disk->queue;
 		if (b->merge_bvec_fn) {
 			backing_limit = b->merge_bvec_fn(b, bvm, bvec);
 			limit = min(limit, backing_limit);
 		}
-		put_ldev(mdev);
+		put_ldev(device);
 		if ((limit >> 9) > max_hw_sectors)
 			limit = max_hw_sectors << 9;
 	}
@@ -1334,8 +1334,8 @@ struct drbd_request *find_oldest_request(struct drbd_tconn *tconn)
 
 void request_timer_fn(unsigned long data)
 {
-	struct drbd_device *mdev = (struct drbd_device *) data;
-	struct drbd_tconn *tconn = mdev->tconn;
+	struct drbd_device *device = (struct drbd_device *) data;
+	struct drbd_tconn *tconn = device->tconn;
 	struct drbd_request *req; /* oldest request */
 	struct net_conf *nc;
 	unsigned long ent = 0, dt = 0, et, nt; /* effective timeout = ko_count * timeout */
@@ -1343,12 +1343,12 @@ void request_timer_fn(unsigned long data)
 
 	rcu_read_lock();
 	nc = rcu_dereference(tconn->net_conf);
-	if (nc && mdev->state.conn >= C_WF_REPORT_PARAMS)
+	if (nc && device->state.conn >= C_WF_REPORT_PARAMS)
 		ent = nc->timeout * HZ/10 * nc->ko_count;
 
-	if (get_ldev(mdev)) { /* implicit state.disk >= D_INCONSISTENT */
-		dt = rcu_dereference(mdev->ldev->disk_conf)->disk_timeout * HZ / 10;
-		put_ldev(mdev);
+	if (get_ldev(device)) { /* implicit state.disk >= D_INCONSISTENT */
+		dt = rcu_dereference(device->ldev->disk_conf)->disk_timeout * HZ / 10;
+		put_ldev(device);
 	}
 	rcu_read_unlock();
 
@@ -1363,7 +1363,7 @@ void request_timer_fn(unsigned long data)
 	req = find_oldest_request(tconn);
 	if (!req) {
 		spin_unlock_irq(&tconn->req_lock);
-		mod_timer(&mdev->request_timer, now + et);
+		mod_timer(&device->request_timer, now + et);
 		return;
 	}
 
@@ -1387,15 +1387,15 @@ void request_timer_fn(unsigned long data)
 		 time_after(now, req->start_time + ent) &&
 		!time_in_range(now, tconn->last_reconnect_jif, tconn->last_reconnect_jif + ent)) {
 		dev_warn(DEV, "Remote failed to finish a request within ko-count * timeout\n");
-		_drbd_set_state(_NS(mdev, conn, C_TIMEOUT), CS_VERBOSE | CS_HARD, NULL);
+		_drbd_set_state(_NS(device, conn, C_TIMEOUT), CS_VERBOSE | CS_HARD, NULL);
 	}
-	if (dt && req->rq_state & RQ_LOCAL_PENDING && req->w.mdev == mdev &&
+	if (dt && req->rq_state & RQ_LOCAL_PENDING && req->w.device == device &&
 		 time_after(now, req->start_time + dt) &&
-		!time_in_range(now, mdev->last_reattach_jif, mdev->last_reattach_jif + dt)) {
+		!time_in_range(now, device->last_reattach_jif, device->last_reattach_jif + dt)) {
 		dev_warn(DEV, "Local backing device failed to meet the disk-timeout\n");
-		__drbd_chk_io_error(mdev, DRBD_FORCE_DETACH);
+		__drbd_chk_io_error(device, DRBD_FORCE_DETACH);
 	}
 	nt = (time_after(now, req->start_time + et) ? now : req->start_time) + et;
 	spin_unlock_irq(&tconn->req_lock);
-	mod_timer(&mdev->request_timer, nt);
+	mod_timer(&device->request_timer, nt);
 }
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 3f1e776..3e32a7b 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -281,7 +281,7 @@ extern void _req_may_be_done(struct drbd_request *req,
 		struct bio_and_error *m);
 extern int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		struct bio_and_error *m);
-extern void complete_master_bio(struct drbd_device *mdev,
+extern void complete_master_bio(struct drbd_device *device,
 		struct bio_and_error *m);
 extern void request_timer_fn(unsigned long data);
 extern void tl_restart(struct drbd_tconn *tconn, enum drbd_req_event what);
@@ -294,14 +294,14 @@ extern void drbd_restart_request(struct drbd_request *req);
  * outside the spinlock, e.g. when walking some list on cleanup. */
 static inline int _req_mod(struct drbd_request *req, enum drbd_req_event what)
 {
-	struct drbd_device *mdev = req->w.mdev;
+	struct drbd_device *device = req->w.device;
 	struct bio_and_error m;
 	int rv;
 
 	/* __req_mod possibly frees req, do not touch req after that! */
 	rv = __req_mod(req, what, &m);
 	if (m.bio)
-		complete_master_bio(mdev, &m);
+		complete_master_bio(device, &m);
 
 	return rv;
 }
@@ -314,16 +314,16 @@ static inline int req_mod(struct drbd_request *req,
 		enum drbd_req_event what)
 {
 	unsigned long flags;
-	struct drbd_device *mdev = req->w.mdev;
+	struct drbd_device *device = req->w.device;
 	struct bio_and_error m;
 	int rv;
 
-	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
+	spin_lock_irqsave(&device->tconn->req_lock, flags);
 	rv = __req_mod(req, what, &m);
-	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
+	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
 
 	if (m.bio)
-		complete_master_bio(mdev, &m);
+		complete_master_bio(device, &m);
 
 	return rv;
 }
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 978c948..5205570 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -31,7 +31,7 @@
 #include "drbd_req.h"
 
 /* in drbd_main.c */
-extern void tl_abort_disk_io(struct drbd_device *mdev);
+extern void tl_abort_disk_io(struct drbd_device *device);
 
 struct after_state_chg_work {
 	struct drbd_work w;
@@ -51,12 +51,12 @@ enum sanitize_state_warnings {
 };
 
 static int w_after_state_ch(struct drbd_work *w, int unused);
-static void after_state_ch(struct drbd_device *mdev, union drbd_state os,
+static void after_state_ch(struct drbd_device *device, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags);
 static enum drbd_state_rv is_valid_state(struct drbd_device *, union drbd_state);
 static enum drbd_state_rv is_valid_soft_transition(union drbd_state, union drbd_state, struct drbd_tconn *);
 static enum drbd_state_rv is_valid_transition(union drbd_state os, union drbd_state ns);
-static union drbd_state sanitize_state(struct drbd_device *mdev, union drbd_state ns,
+static union drbd_state sanitize_state(struct drbd_device *device, union drbd_state ns,
 				       enum sanitize_state_warnings *warn);
 
 static inline bool is_susp(union drbd_state s)
@@ -66,15 +66,15 @@ static inline bool is_susp(union drbd_state s)
 
 bool conn_all_vols_unconf(struct drbd_tconn *tconn)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	bool rv = true;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		if (mdev->state.disk != D_DISKLESS ||
-		    mdev->state.conn != C_STANDALONE ||
-		    mdev->state.role != R_SECONDARY) {
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
+		if (device->state.disk != D_DISKLESS ||
+		    device->state.conn != C_STANDALONE ||
+		    device->state.role != R_SECONDARY) {
 			rv = false;
 			break;
 		}
@@ -106,12 +106,12 @@ static enum drbd_role min_role(enum drbd_role role1, enum drbd_role role2)
 enum drbd_role conn_highest_role(struct drbd_tconn *tconn)
 {
 	enum drbd_role role = R_UNKNOWN;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr)
-		role = max_role(role, mdev->state.role);
+	idr_for_each_entry(&tconn->volumes, device, vnr)
+		role = max_role(role, device->state.role);
 	rcu_read_unlock();
 
 	return role;
@@ -120,12 +120,12 @@ enum drbd_role conn_highest_role(struct drbd_tconn *tconn)
 enum drbd_role conn_highest_peer(struct drbd_tconn *tconn)
 {
 	enum drbd_role peer = R_UNKNOWN;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr)
-		peer = max_role(peer, mdev->state.peer);
+	idr_for_each_entry(&tconn->volumes, device, vnr)
+		peer = max_role(peer, device->state.peer);
 	rcu_read_unlock();
 
 	return peer;
@@ -134,12 +134,12 @@ enum drbd_role conn_highest_peer(struct drbd_tconn *tconn)
 enum drbd_disk_state conn_highest_disk(struct drbd_tconn *tconn)
 {
 	enum drbd_disk_state ds = D_DISKLESS;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr)
-		ds = max_t(enum drbd_disk_state, ds, mdev->state.disk);
+	idr_for_each_entry(&tconn->volumes, device, vnr)
+		ds = max_t(enum drbd_disk_state, ds, device->state.disk);
 	rcu_read_unlock();
 
 	return ds;
@@ -148,12 +148,12 @@ enum drbd_disk_state conn_highest_disk(struct drbd_tconn *tconn)
 enum drbd_disk_state conn_lowest_disk(struct drbd_tconn *tconn)
 {
 	enum drbd_disk_state ds = D_MASK;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr)
-		ds = min_t(enum drbd_disk_state, ds, mdev->state.disk);
+	idr_for_each_entry(&tconn->volumes, device, vnr)
+		ds = min_t(enum drbd_disk_state, ds, device->state.disk);
 	rcu_read_unlock();
 
 	return ds;
@@ -162,12 +162,12 @@ enum drbd_disk_state conn_lowest_disk(struct drbd_tconn *tconn)
 enum drbd_disk_state conn_highest_pdsk(struct drbd_tconn *tconn)
 {
 	enum drbd_disk_state ds = D_DISKLESS;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr)
-		ds = max_t(enum drbd_disk_state, ds, mdev->state.pdsk);
+	idr_for_each_entry(&tconn->volumes, device, vnr)
+		ds = max_t(enum drbd_disk_state, ds, device->state.pdsk);
 	rcu_read_unlock();
 
 	return ds;
@@ -176,12 +176,12 @@ enum drbd_disk_state conn_highest_pdsk(struct drbd_tconn *tconn)
 enum drbd_conns conn_lowest_conn(struct drbd_tconn *tconn)
 {
 	enum drbd_conns conn = C_MASK;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr)
-		conn = min_t(enum drbd_conns, conn, mdev->state.conn);
+	idr_for_each_entry(&tconn->volumes, device, vnr)
+		conn = min_t(enum drbd_conns, conn, device->state.conn);
 	rcu_read_unlock();
 
 	return conn;
@@ -189,13 +189,13 @@ enum drbd_conns conn_lowest_conn(struct drbd_tconn *tconn)
 
 static bool no_peer_wf_report_params(struct drbd_tconn *tconn)
 {
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 	bool rv = true;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr)
-		if (mdev->state.conn == C_WF_REPORT_PARAMS) {
+	idr_for_each_entry(&tconn->volumes, device, vnr)
+		if (device->state.conn == C_WF_REPORT_PARAMS) {
 			rv = false;
 			break;
 		}
@@ -207,11 +207,11 @@ static bool no_peer_wf_report_params(struct drbd_tconn *tconn)
 
 /**
  * cl_wide_st_chg() - true if the state change is a cluster wide one
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @os:		old (current) state.
  * @ns:		new (wanted) state.
  */
-static int cl_wide_st_chg(struct drbd_device *mdev,
+static int cl_wide_st_chg(struct drbd_device *device,
 			  union drbd_state os, union drbd_state ns)
 {
 	return (os.conn >= C_CONNECTED && ns.conn >= C_CONNECTED &&
@@ -233,72 +233,72 @@ apply_mask_val(union drbd_state os, union drbd_state mask, union drbd_state val)
 }
 
 enum drbd_state_rv
-drbd_change_state(struct drbd_device *mdev, enum chg_state_flags f,
+drbd_change_state(struct drbd_device *device, enum chg_state_flags f,
 		  union drbd_state mask, union drbd_state val)
 {
 	unsigned long flags;
 	union drbd_state ns;
 	enum drbd_state_rv rv;
 
-	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-	ns = apply_mask_val(drbd_read_state(mdev), mask, val);
-	rv = _drbd_set_state(mdev, ns, f, NULL);
-	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
+	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	ns = apply_mask_val(drbd_read_state(device), mask, val);
+	rv = _drbd_set_state(device, ns, f, NULL);
+	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
 
 	return rv;
 }
 
 /**
  * drbd_force_state() - Impose a change which happens outside our control on our state
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @mask:	mask of state bits to change.
  * @val:	value of new state bits.
  */
-void drbd_force_state(struct drbd_device *mdev,
+void drbd_force_state(struct drbd_device *device,
 	union drbd_state mask, union drbd_state val)
 {
-	drbd_change_state(mdev, CS_HARD, mask, val);
+	drbd_change_state(device, CS_HARD, mask, val);
 }
 
 static enum drbd_state_rv
-_req_st_cond(struct drbd_device *mdev, union drbd_state mask,
+_req_st_cond(struct drbd_device *device, union drbd_state mask,
 	     union drbd_state val)
 {
 	union drbd_state os, ns;
 	unsigned long flags;
 	enum drbd_state_rv rv;
 
-	if (test_and_clear_bit(CL_ST_CHG_SUCCESS, &mdev->flags))
+	if (test_and_clear_bit(CL_ST_CHG_SUCCESS, &device->flags))
 		return SS_CW_SUCCESS;
 
-	if (test_and_clear_bit(CL_ST_CHG_FAIL, &mdev->flags))
+	if (test_and_clear_bit(CL_ST_CHG_FAIL, &device->flags))
 		return SS_CW_FAILED_BY_PEER;
 
-	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-	os = drbd_read_state(mdev);
-	ns = sanitize_state(mdev, apply_mask_val(os, mask, val), NULL);
+	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	os = drbd_read_state(device);
+	ns = sanitize_state(device, apply_mask_val(os, mask, val), NULL);
 	rv = is_valid_transition(os, ns);
 	if (rv >= SS_SUCCESS)
 		rv = SS_UNKNOWN_ERROR;  /* cont waiting, otherwise fail. */
 
-	if (!cl_wide_st_chg(mdev, os, ns))
+	if (!cl_wide_st_chg(device, os, ns))
 		rv = SS_CW_NO_NEED;
 	if (rv == SS_UNKNOWN_ERROR) {
-		rv = is_valid_state(mdev, ns);
+		rv = is_valid_state(device, ns);
 		if (rv >= SS_SUCCESS) {
-			rv = is_valid_soft_transition(os, ns, mdev->tconn);
+			rv = is_valid_soft_transition(os, ns, device->tconn);
 			if (rv >= SS_SUCCESS)
 				rv = SS_UNKNOWN_ERROR; /* cont waiting, otherwise fail. */
 		}
 	}
-	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
+	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
 
 	return rv;
 }
 
 /**
  * drbd_req_state() - Perform an eventually cluster wide state change
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @mask:	mask of state bits to change.
  * @val:	value of new state bits.
  * @f:		flags
@@ -307,7 +307,7 @@ _req_st_cond(struct drbd_device *mdev, union drbd_state mask,
  * _drbd_request_state().
  */
 static enum drbd_state_rv
-drbd_req_state(struct drbd_device *mdev, union drbd_state mask,
+drbd_req_state(struct drbd_device *device, union drbd_state mask,
 	       union drbd_state val, enum chg_state_flags f)
 {
 	struct completion done;
@@ -318,68 +318,68 @@ drbd_req_state(struct drbd_device *mdev, union drbd_state mask,
 	init_completion(&done);
 
 	if (f & CS_SERIALIZE)
-		mutex_lock(mdev->state_mutex);
+		mutex_lock(device->state_mutex);
 
-	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-	os = drbd_read_state(mdev);
-	ns = sanitize_state(mdev, apply_mask_val(os, mask, val), NULL);
+	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	os = drbd_read_state(device);
+	ns = sanitize_state(device, apply_mask_val(os, mask, val), NULL);
 	rv = is_valid_transition(os, ns);
 	if (rv < SS_SUCCESS) {
-		spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
+		spin_unlock_irqrestore(&device->tconn->req_lock, flags);
 		goto abort;
 	}
 
-	if (cl_wide_st_chg(mdev, os, ns)) {
-		rv = is_valid_state(mdev, ns);
+	if (cl_wide_st_chg(device, os, ns)) {
+		rv = is_valid_state(device, ns);
 		if (rv == SS_SUCCESS)
-			rv = is_valid_soft_transition(os, ns, mdev->tconn);
-		spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
+			rv = is_valid_soft_transition(os, ns, device->tconn);
+		spin_unlock_irqrestore(&device->tconn->req_lock, flags);
 
 		if (rv < SS_SUCCESS) {
 			if (f & CS_VERBOSE)
-				print_st_err(mdev, os, ns, rv);
+				print_st_err(device, os, ns, rv);
 			goto abort;
 		}
 
-		if (drbd_send_state_req(mdev, mask, val)) {
+		if (drbd_send_state_req(device, mask, val)) {
 			rv = SS_CW_FAILED_BY_PEER;
 			if (f & CS_VERBOSE)
-				print_st_err(mdev, os, ns, rv);
+				print_st_err(device, os, ns, rv);
 			goto abort;
 		}
 
-		wait_event(mdev->state_wait,
-			(rv = _req_st_cond(mdev, mask, val)));
+		wait_event(device->state_wait,
+			(rv = _req_st_cond(device, mask, val)));
 
 		if (rv < SS_SUCCESS) {
 			if (f & CS_VERBOSE)
-				print_st_err(mdev, os, ns, rv);
+				print_st_err(device, os, ns, rv);
 			goto abort;
 		}
-		spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-		ns = apply_mask_val(drbd_read_state(mdev), mask, val);
-		rv = _drbd_set_state(mdev, ns, f, &done);
+		spin_lock_irqsave(&device->tconn->req_lock, flags);
+		ns = apply_mask_val(drbd_read_state(device), mask, val);
+		rv = _drbd_set_state(device, ns, f, &done);
 	} else {
-		rv = _drbd_set_state(mdev, ns, f, &done);
+		rv = _drbd_set_state(device, ns, f, &done);
 	}
 
-	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
+	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
 
 	if (f & CS_WAIT_COMPLETE && rv == SS_SUCCESS) {
-		D_ASSERT(current != mdev->tconn->worker.task);
+		D_ASSERT(current != device->tconn->worker.task);
 		wait_for_completion(&done);
 	}
 
 abort:
 	if (f & CS_SERIALIZE)
-		mutex_unlock(mdev->state_mutex);
+		mutex_unlock(device->state_mutex);
 
 	return rv;
 }
 
 /**
  * _drbd_request_state() - Request a state change (with flags)
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @mask:	mask of state bits to change.
  * @val:	value of new state bits.
  * @f:		flags
@@ -388,18 +388,18 @@ abort:
  * flag, or when logging of failed state change requests is not desired.
  */
 enum drbd_state_rv
-_drbd_request_state(struct drbd_device *mdev, union drbd_state mask,
+_drbd_request_state(struct drbd_device *device, union drbd_state mask,
 		    union drbd_state val, enum chg_state_flags f)
 {
 	enum drbd_state_rv rv;
 
-	wait_event(mdev->state_wait,
-		   (rv = drbd_req_state(mdev, mask, val, f)) != SS_IN_TRANSIENT_STATE);
+	wait_event(device->state_wait,
+		   (rv = drbd_req_state(device, mask, val, f)) != SS_IN_TRANSIENT_STATE);
 
 	return rv;
 }
 
-static void print_st(struct drbd_device *mdev, char *name, union drbd_state ns)
+static void print_st(struct drbd_device *device, char *name, union drbd_state ns)
 {
 	dev_err(DEV, " %s = { cs:%s ro:%s/%s ds:%s/%s %c%c%c%c%c%c }\n",
 	    name,
@@ -417,14 +417,14 @@ static void print_st(struct drbd_device *mdev, char *name, union drbd_state ns)
 	    );
 }
 
-void print_st_err(struct drbd_device *mdev, union drbd_state os,
+void print_st_err(struct drbd_device *device, union drbd_state os,
 	          union drbd_state ns, enum drbd_state_rv err)
 {
 	if (err == SS_IN_TRANSIENT_STATE)
 		return;
 	dev_err(DEV, "State change failed: %s\n", drbd_set_st_err_str(err));
-	print_st(mdev, " state", os);
-	print_st(mdev, "wanted", ns);
+	print_st(device, " state", os);
+	print_st(device, "wanted", ns);
 }
 
 static long print_state_change(char *pb, union drbd_state os, union drbd_state ns,
@@ -458,7 +458,7 @@ static long print_state_change(char *pb, union drbd_state os, union drbd_state n
 	return pbp - pb;
 }
 
-static void drbd_pr_state_change(struct drbd_device *mdev, union drbd_state os, union drbd_state ns,
+static void drbd_pr_state_change(struct drbd_device *device, union drbd_state os, union drbd_state ns,
 				 enum chg_state_flags flags)
 {
 	char pb[300];
@@ -503,11 +503,11 @@ static void conn_pr_state_change(struct drbd_tconn *tconn, union drbd_state os,
 
 /**
  * is_valid_state() - Returns an SS_ error code if ns is not valid
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @ns:		State to consider.
  */
 static enum drbd_state_rv
-is_valid_state(struct drbd_device *mdev, union drbd_state ns)
+is_valid_state(struct drbd_device *device, union drbd_state ns)
 {
 	/* See drbd_state_sw_errors in drbd_strings.c */
 
@@ -517,24 +517,24 @@ is_valid_state(struct drbd_device *mdev, union drbd_state ns)
 
 	rcu_read_lock();
 	fp = FP_DONT_CARE;
-	if (get_ldev(mdev)) {
-		fp = rcu_dereference(mdev->ldev->disk_conf)->fencing;
-		put_ldev(mdev);
+	if (get_ldev(device)) {
+		fp = rcu_dereference(device->ldev->disk_conf)->fencing;
+		put_ldev(device);
 	}
 
-	nc = rcu_dereference(mdev->tconn->net_conf);
+	nc = rcu_dereference(device->tconn->net_conf);
 	if (nc) {
 		if (!nc->two_primaries && ns.role == R_PRIMARY) {
 			if (ns.peer == R_PRIMARY)
 				rv = SS_TWO_PRIMARIES;
-			else if (conn_highest_peer(mdev->tconn) == R_PRIMARY)
+			else if (conn_highest_peer(device->tconn) == R_PRIMARY)
 				rv = SS_O_VOL_PEER_PRI;
 		}
 	}
 
 	if (rv <= 0)
 		/* already found a reason to abort */;
-	else if (ns.role == R_SECONDARY && mdev->open_cnt)
+	else if (ns.role == R_SECONDARY && device->open_cnt)
 		rv = SS_DEVICE_IN_USE;
 
 	else if (ns.role == R_PRIMARY && ns.conn < C_CONNECTED && ns.disk < D_UP_TO_DATE)
@@ -568,7 +568,7 @@ is_valid_state(struct drbd_device *mdev, union drbd_state ns)
 		rv = SS_NO_VERIFY_ALG;
 
 	else if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
-		  mdev->tconn->agreed_pro_version < 88)
+		  device->tconn->agreed_pro_version < 88)
 		rv = SS_NOT_SUPPORTED;
 
 	else if (ns.role == R_PRIMARY && ns.disk < D_UP_TO_DATE && ns.pdsk < D_UP_TO_DATE)
@@ -590,7 +590,7 @@ is_valid_state(struct drbd_device *mdev, union drbd_state ns)
  * is_valid_soft_transition() - Returns an SS_ error code if the state transition is not possible
  * This function limits state transitions that may be declined by DRBD. I.e.
  * user requests (aka soft transitions).
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @ns:		new state.
  * @os:		old state.
  */
@@ -704,7 +704,7 @@ is_valid_transition(union drbd_state os, union drbd_state ns)
 	return rv;
 }
 
-static void print_sanitize_warnings(struct drbd_device *mdev, enum sanitize_state_warnings warn)
+static void print_sanitize_warnings(struct drbd_device *device, enum sanitize_state_warnings warn)
 {
 	static const char *msg_table[] = {
 		[NO_WARNING] = "",
@@ -721,7 +721,7 @@ static void print_sanitize_warnings(struct drbd_device *mdev, enum sanitize_stat
 
 /**
  * sanitize_state() - Resolves implicitly necessary additional changes to a state transition
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @os:		old state.
  * @ns:		new state.
  * @warn_sync_abort:
@@ -729,7 +729,7 @@ static void print_sanitize_warnings(struct drbd_device *mdev, enum sanitize_stat
  * When we loose connection, we have to set the state of the peers disk (pdsk)
  * to D_UNKNOWN. This rule and many more along those lines are in this function.
  */
-static union drbd_state sanitize_state(struct drbd_device *mdev, union drbd_state ns,
+static union drbd_state sanitize_state(struct drbd_device *device, union drbd_state ns,
 				       enum sanitize_state_warnings *warn)
 {
 	enum drbd_fencing_p fp;
@@ -739,11 +739,11 @@ static union drbd_state sanitize_state(struct drbd_device *mdev, union drbd_stat
 		*warn = NO_WARNING;
 
 	fp = FP_DONT_CARE;
-	if (get_ldev(mdev)) {
+	if (get_ldev(device)) {
 		rcu_read_lock();
-		fp = rcu_dereference(mdev->ldev->disk_conf)->fencing;
+		fp = rcu_dereference(device->ldev->disk_conf)->fencing;
 		rcu_read_unlock();
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 
 	/* Implications from connection to peer and peer_isp */
@@ -769,17 +769,17 @@ static union drbd_state sanitize_state(struct drbd_device *mdev, union drbd_stat
 
 	/* Connection breaks down before we finished "Negotiating" */
 	if (ns.conn < C_CONNECTED && ns.disk == D_NEGOTIATING &&
-	    get_ldev_if_state(mdev, D_NEGOTIATING)) {
-		if (mdev->ed_uuid == mdev->ldev->md.uuid[UI_CURRENT]) {
-			ns.disk = mdev->new_state_tmp.disk;
-			ns.pdsk = mdev->new_state_tmp.pdsk;
+	    get_ldev_if_state(device, D_NEGOTIATING)) {
+		if (device->ed_uuid == device->ldev->md.uuid[UI_CURRENT]) {
+			ns.disk = device->new_state_tmp.disk;
+			ns.pdsk = device->new_state_tmp.pdsk;
 		} else {
 			if (warn)
 				*warn = CONNECTION_LOST_NEGOTIATING;
 			ns.disk = D_DISKLESS;
 			ns.pdsk = D_UNKNOWN;
 		}
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 
 	/* D_CONSISTENT and D_OUTDATED vanish when we get connected */
@@ -874,7 +874,7 @@ static union drbd_state sanitize_state(struct drbd_device *mdev, union drbd_stat
 	    (ns.role == R_PRIMARY && ns.conn < C_CONNECTED && ns.pdsk > D_OUTDATED))
 		ns.susp_fen = 1; /* Suspend IO while fence-peer handler runs (peer lost) */
 
-	if (mdev->tconn->res_opts.on_no_data == OND_SUSPEND_IO &&
+	if (device->tconn->res_opts.on_no_data == OND_SUSPEND_IO &&
 	    (ns.role == R_PRIMARY && ns.disk < D_UP_TO_DATE && ns.pdsk < D_UP_TO_DATE))
 		ns.susp_nod = 1; /* Suspend IO while no data available (no accessible data available) */
 
@@ -893,42 +893,42 @@ static union drbd_state sanitize_state(struct drbd_device *mdev, union drbd_stat
 	return ns;
 }
 
-void drbd_resume_al(struct drbd_device *mdev)
+void drbd_resume_al(struct drbd_device *device)
 {
-	if (test_and_clear_bit(AL_SUSPENDED, &mdev->flags))
+	if (test_and_clear_bit(AL_SUSPENDED, &device->flags))
 		dev_info(DEV, "Resumed AL updates\n");
 }
 
 /* helper for __drbd_set_state */
-static void set_ov_position(struct drbd_device *mdev, enum drbd_conns cs)
+static void set_ov_position(struct drbd_device *device, enum drbd_conns cs)
 {
-	if (mdev->tconn->agreed_pro_version < 90)
-		mdev->ov_start_sector = 0;
-	mdev->rs_total = drbd_bm_bits(mdev);
-	mdev->ov_position = 0;
+	if (device->tconn->agreed_pro_version < 90)
+		device->ov_start_sector = 0;
+	device->rs_total = drbd_bm_bits(device);
+	device->ov_position = 0;
 	if (cs == C_VERIFY_T) {
 		/* starting online verify from an arbitrary position
 		 * does not fit well into the existing protocol.
 		 * on C_VERIFY_T, we initialize ov_left and friends
 		 * implicitly in receive_DataRequest once the
 		 * first P_OV_REQUEST is received */
-		mdev->ov_start_sector = ~(sector_t)0;
+		device->ov_start_sector = ~(sector_t)0;
 	} else {
-		unsigned long bit = BM_SECT_TO_BIT(mdev->ov_start_sector);
-		if (bit >= mdev->rs_total) {
-			mdev->ov_start_sector =
-				BM_BIT_TO_SECT(mdev->rs_total - 1);
-			mdev->rs_total = 1;
+		unsigned long bit = BM_SECT_TO_BIT(device->ov_start_sector);
+		if (bit >= device->rs_total) {
+			device->ov_start_sector =
+				BM_BIT_TO_SECT(device->rs_total - 1);
+			device->rs_total = 1;
 		} else
-			mdev->rs_total -= bit;
-		mdev->ov_position = mdev->ov_start_sector;
+			device->rs_total -= bit;
+		device->ov_position = device->ov_start_sector;
 	}
-	mdev->ov_left = mdev->rs_total;
+	device->ov_left = device->rs_total;
 }
 
 /**
  * __drbd_set_state() - Set a new DRBD state
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @ns:		new state.
  * @flags:	Flags
  * @done:	Optional completion, that will get completed after the after_state_ch() finished
@@ -936,7 +936,7 @@ static void set_ov_position(struct drbd_device *mdev, enum drbd_conns cs)
  * Caller needs to hold req_lock, and global_state_lock. Do not call directly.
  */
 enum drbd_state_rv
-__drbd_set_state(struct drbd_device *mdev, union drbd_state ns,
+__drbd_set_state(struct drbd_device *device, union drbd_state ns,
 	         enum chg_state_flags flags, struct completion *done)
 {
 	union drbd_state os;
@@ -945,9 +945,9 @@ __drbd_set_state(struct drbd_device *mdev, union drbd_state ns,
 	struct after_state_chg_work *ascw;
 	bool did_remote, should_do_remote;
 
-	os = drbd_read_state(mdev);
+	os = drbd_read_state(device);
 
-	ns = sanitize_state(mdev, ns, &ssw);
+	ns = sanitize_state(device, ns, &ssw);
 	if (ns.i == os.i)
 		return SS_NOTHING_TO_DO;
 
@@ -959,32 +959,32 @@ __drbd_set_state(struct drbd_device *mdev, union drbd_state ns,
 		/*  pre-state-change checks ; only look at ns  */
 		/* See drbd_state_sw_errors in drbd_strings.c */
 
-		rv = is_valid_state(mdev, ns);
+		rv = is_valid_state(device, ns);
 		if (rv < SS_SUCCESS) {
 			/* If the old state was illegal as well, then let
 			   this happen...*/
 
-			if (is_valid_state(mdev, os) == rv)
-				rv = is_valid_soft_transition(os, ns, mdev->tconn);
+			if (is_valid_state(device, os) == rv)
+				rv = is_valid_soft_transition(os, ns, device->tconn);
 		} else
-			rv = is_valid_soft_transition(os, ns, mdev->tconn);
+			rv = is_valid_soft_transition(os, ns, device->tconn);
 	}
 
 	if (rv < SS_SUCCESS) {
 		if (flags & CS_VERBOSE)
-			print_st_err(mdev, os, ns, rv);
+			print_st_err(device, os, ns, rv);
 		return rv;
 	}
 
-	print_sanitize_warnings(mdev, ssw);
+	print_sanitize_warnings(device, ssw);
 
-	drbd_pr_state_change(mdev, os, ns, flags);
+	drbd_pr_state_change(device, os, ns, flags);
 
 	/* Display changes to the susp* flags that where caused by the call to
 	   sanitize_state(). Only display it here if we where not called from
 	   _conn_request_state() */
 	if (!(flags & CS_DC_SUSP))
-		conn_pr_state_change(mdev->tconn, os, ns, (flags & ~CS_DC_MASK) | CS_DC_SUSP);
+		conn_pr_state_change(device->tconn, os, ns, (flags & ~CS_DC_MASK) | CS_DC_SUSP);
 
 	/* if we are going -> D_FAILED or D_DISKLESS, grab one extra reference
 	 * on the ldev here, to be sure the transition -> D_DISKLESS resp.
@@ -992,55 +992,55 @@ __drbd_set_state(struct drbd_device *mdev, union drbd_state ns,
 	 * after_state_ch works run, where we put_ldev again. */
 	if ((os.disk != D_FAILED && ns.disk == D_FAILED) ||
 	    (os.disk != D_DISKLESS && ns.disk == D_DISKLESS))
-		atomic_inc(&mdev->local_cnt);
+		atomic_inc(&device->local_cnt);
 
-	did_remote = drbd_should_do_remote(mdev->state);
-	mdev->state.i = ns.i;
-	should_do_remote = drbd_should_do_remote(mdev->state);
-	mdev->tconn->susp = ns.susp;
-	mdev->tconn->susp_nod = ns.susp_nod;
-	mdev->tconn->susp_fen = ns.susp_fen;
+	did_remote = drbd_should_do_remote(device->state);
+	device->state.i = ns.i;
+	should_do_remote = drbd_should_do_remote(device->state);
+	device->tconn->susp = ns.susp;
+	device->tconn->susp_nod = ns.susp_nod;
+	device->tconn->susp_fen = ns.susp_fen;
 
 	/* put replicated vs not-replicated requests in seperate epochs */
 	if (did_remote != should_do_remote)
-		start_new_tl_epoch(mdev->tconn);
+		start_new_tl_epoch(device->tconn);
 
 	if (os.disk == D_ATTACHING && ns.disk >= D_NEGOTIATING)
-		drbd_print_uuids(mdev, "attached to UUIDs");
+		drbd_print_uuids(device, "attached to UUIDs");
 
 	/* Wake up role changes, that were delayed because of connection establishing */
 	if (os.conn == C_WF_REPORT_PARAMS && ns.conn != C_WF_REPORT_PARAMS &&
-	    no_peer_wf_report_params(mdev->tconn))
-		clear_bit(STATE_SENT, &mdev->tconn->flags);
+	    no_peer_wf_report_params(device->tconn))
+		clear_bit(STATE_SENT, &device->tconn->flags);
 
-	wake_up(&mdev->misc_wait);
-	wake_up(&mdev->state_wait);
-	wake_up(&mdev->tconn->ping_wait);
+	wake_up(&device->misc_wait);
+	wake_up(&device->state_wait);
+	wake_up(&device->tconn->ping_wait);
 
 	/* Aborted verify run, or we reached the stop sector.
 	 * Log the last position, unless end-of-device. */
 	if ((os.conn == C_VERIFY_S || os.conn == C_VERIFY_T) &&
 	    ns.conn <= C_CONNECTED) {
-		mdev->ov_start_sector =
-			BM_BIT_TO_SECT(drbd_bm_bits(mdev) - mdev->ov_left);
-		if (mdev->ov_left)
+		device->ov_start_sector =
+			BM_BIT_TO_SECT(drbd_bm_bits(device) - device->ov_left);
+		if (device->ov_left)
 			dev_info(DEV, "Online Verify reached sector %llu\n",
-				(unsigned long long)mdev->ov_start_sector);
+				(unsigned long long)device->ov_start_sector);
 	}
 
 	if ((os.conn == C_PAUSED_SYNC_T || os.conn == C_PAUSED_SYNC_S) &&
 	    (ns.conn == C_SYNC_TARGET  || ns.conn == C_SYNC_SOURCE)) {
 		dev_info(DEV, "Syncer continues.\n");
-		mdev->rs_paused += (long)jiffies
-				  -(long)mdev->rs_mark_time[mdev->rs_last_mark];
+		device->rs_paused += (long)jiffies
+				  -(long)device->rs_mark_time[device->rs_last_mark];
 		if (ns.conn == C_SYNC_TARGET)
-			mod_timer(&mdev->resync_timer, jiffies);
+			mod_timer(&device->resync_timer, jiffies);
 	}
 
 	if ((os.conn == C_SYNC_TARGET  || os.conn == C_SYNC_SOURCE) &&
 	    (ns.conn == C_PAUSED_SYNC_T || ns.conn == C_PAUSED_SYNC_S)) {
 		dev_info(DEV, "Resync suspended\n");
-		mdev->rs_mark_time[mdev->rs_last_mark] = jiffies;
+		device->rs_mark_time[device->rs_last_mark] = jiffies;
 	}
 
 	if (os.conn == C_CONNECTED &&
@@ -1048,77 +1048,77 @@ __drbd_set_state(struct drbd_device *mdev, union drbd_state ns,
 		unsigned long now = jiffies;
 		int i;
 
-		set_ov_position(mdev, ns.conn);
-		mdev->rs_start = now;
-		mdev->rs_last_events = 0;
-		mdev->rs_last_sect_ev = 0;
-		mdev->ov_last_oos_size = 0;
-		mdev->ov_last_oos_start = 0;
+		set_ov_position(device, ns.conn);
+		device->rs_start = now;
+		device->rs_last_events = 0;
+		device->rs_last_sect_ev = 0;
+		device->ov_last_oos_size = 0;
+		device->ov_last_oos_start = 0;
 
 		for (i = 0; i < DRBD_SYNC_MARKS; i++) {
-			mdev->rs_mark_left[i] = mdev->ov_left;
-			mdev->rs_mark_time[i] = now;
+			device->rs_mark_left[i] = device->ov_left;
+			device->rs_mark_time[i] = now;
 		}
 
-		drbd_rs_controller_reset(mdev);
+		drbd_rs_controller_reset(device);
 
 		if (ns.conn == C_VERIFY_S) {
 			dev_info(DEV, "Starting Online Verify from sector %llu\n",
-					(unsigned long long)mdev->ov_position);
-			mod_timer(&mdev->resync_timer, jiffies);
+					(unsigned long long)device->ov_position);
+			mod_timer(&device->resync_timer, jiffies);
 		}
 	}
 
-	if (get_ldev(mdev)) {
-		u32 mdf = mdev->ldev->md.flags & ~(MDF_CONSISTENT|MDF_PRIMARY_IND|
+	if (get_ldev(device)) {
+		u32 mdf = device->ldev->md.flags & ~(MDF_CONSISTENT|MDF_PRIMARY_IND|
 						 MDF_CONNECTED_IND|MDF_WAS_UP_TO_DATE|
 						 MDF_PEER_OUT_DATED|MDF_CRASHED_PRIMARY);
 
 		mdf &= ~MDF_AL_CLEAN;
-		if (test_bit(CRASHED_PRIMARY, &mdev->flags))
+		if (test_bit(CRASHED_PRIMARY, &device->flags))
 			mdf |= MDF_CRASHED_PRIMARY;
-		if (mdev->state.role == R_PRIMARY ||
-		    (mdev->state.pdsk < D_INCONSISTENT && mdev->state.peer == R_PRIMARY))
+		if (device->state.role == R_PRIMARY ||
+		    (device->state.pdsk < D_INCONSISTENT && device->state.peer == R_PRIMARY))
 			mdf |= MDF_PRIMARY_IND;
-		if (mdev->state.conn > C_WF_REPORT_PARAMS)
+		if (device->state.conn > C_WF_REPORT_PARAMS)
 			mdf |= MDF_CONNECTED_IND;
-		if (mdev->state.disk > D_INCONSISTENT)
+		if (device->state.disk > D_INCONSISTENT)
 			mdf |= MDF_CONSISTENT;
-		if (mdev->state.disk > D_OUTDATED)
+		if (device->state.disk > D_OUTDATED)
 			mdf |= MDF_WAS_UP_TO_DATE;
-		if (mdev->state.pdsk <= D_OUTDATED && mdev->state.pdsk >= D_INCONSISTENT)
+		if (device->state.pdsk <= D_OUTDATED && device->state.pdsk >= D_INCONSISTENT)
 			mdf |= MDF_PEER_OUT_DATED;
-		if (mdf != mdev->ldev->md.flags) {
-			mdev->ldev->md.flags = mdf;
-			drbd_md_mark_dirty(mdev);
+		if (mdf != device->ldev->md.flags) {
+			device->ldev->md.flags = mdf;
+			drbd_md_mark_dirty(device);
 		}
 		if (os.disk < D_CONSISTENT && ns.disk >= D_CONSISTENT)
-			drbd_set_ed_uuid(mdev, mdev->ldev->md.uuid[UI_CURRENT]);
-		put_ldev(mdev);
+			drbd_set_ed_uuid(device, device->ldev->md.uuid[UI_CURRENT]);
+		put_ldev(device);
 	}
 
 	/* Peer was forced D_UP_TO_DATE & R_PRIMARY, consider to resync */
 	if (os.disk == D_INCONSISTENT && os.pdsk == D_INCONSISTENT &&
 	    os.peer == R_SECONDARY && ns.peer == R_PRIMARY)
-		set_bit(CONSIDER_RESYNC, &mdev->flags);
+		set_bit(CONSIDER_RESYNC, &device->flags);
 
 	/* Receiver should clean up itself */
 	if (os.conn != C_DISCONNECTING && ns.conn == C_DISCONNECTING)
-		drbd_thread_stop_nowait(&mdev->tconn->receiver);
+		drbd_thread_stop_nowait(&device->tconn->receiver);
 
 	/* Now the receiver finished cleaning up itself, it should die */
 	if (os.conn != C_STANDALONE && ns.conn == C_STANDALONE)
-		drbd_thread_stop_nowait(&mdev->tconn->receiver);
+		drbd_thread_stop_nowait(&device->tconn->receiver);
 
 	/* Upon network failure, we need to restart the receiver. */
 	if (os.conn > C_WF_CONNECTION &&
 	    ns.conn <= C_TEAR_DOWN && ns.conn >= C_TIMEOUT)
-		drbd_thread_restart_nowait(&mdev->tconn->receiver);
+		drbd_thread_restart_nowait(&device->tconn->receiver);
 
 	/* Resume AL writing if we get a connection */
 	if (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED) {
-		drbd_resume_al(mdev);
-		mdev->tconn->connect_cnt++;
+		drbd_resume_al(device);
+		device->tconn->connect_cnt++;
 	}
 
 	/* remember last attach time so request_timer_fn() won't
@@ -1126,7 +1126,7 @@ __drbd_set_state(struct drbd_device *mdev, union drbd_state ns,
 	 * previously frozen IO */
 	if ((os.disk == D_ATTACHING || os.disk == D_NEGOTIATING) &&
 	    ns.disk > D_NEGOTIATING)
-		mdev->last_reattach_jif = jiffies;
+		device->last_reattach_jif = jiffies;
 
 	ascw = kmalloc(sizeof(*ascw), GFP_ATOMIC);
 	if (ascw) {
@@ -1134,9 +1134,9 @@ __drbd_set_state(struct drbd_device *mdev, union drbd_state ns,
 		ascw->ns = ns;
 		ascw->flags = flags;
 		ascw->w.cb = w_after_state_ch;
-		ascw->w.mdev = mdev;
+		ascw->w.device = device;
 		ascw->done = done;
-		drbd_queue_work(&mdev->tconn->sender_work, &ascw->w);
+		drbd_queue_work(&device->tconn->sender_work, &ascw->w);
 	} else {
 		dev_err(DEV, "Could not kmalloc an ascw\n");
 	}
@@ -1148,9 +1148,9 @@ static int w_after_state_ch(struct drbd_work *w, int unused)
 {
 	struct after_state_chg_work *ascw =
 		container_of(w, struct after_state_chg_work, w);
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 
-	after_state_ch(mdev, ascw->os, ascw->ns, ascw->flags);
+	after_state_ch(device, ascw->os, ascw->ns, ascw->flags);
 	if (ascw->flags & CS_WAIT_COMPLETE) {
 		D_ASSERT(ascw->done != NULL);
 		complete(ascw->done);
@@ -1160,52 +1160,52 @@ static int w_after_state_ch(struct drbd_work *w, int unused)
 	return 0;
 }
 
-static void abw_start_sync(struct drbd_device *mdev, int rv)
+static void abw_start_sync(struct drbd_device *device, int rv)
 {
 	if (rv) {
 		dev_err(DEV, "Writing the bitmap failed not starting resync.\n");
-		_drbd_request_state(mdev, NS(conn, C_CONNECTED), CS_VERBOSE);
+		_drbd_request_state(device, NS(conn, C_CONNECTED), CS_VERBOSE);
 		return;
 	}
 
-	switch (mdev->state.conn) {
+	switch (device->state.conn) {
 	case C_STARTING_SYNC_T:
-		_drbd_request_state(mdev, NS(conn, C_WF_SYNC_UUID), CS_VERBOSE);
+		_drbd_request_state(device, NS(conn, C_WF_SYNC_UUID), CS_VERBOSE);
 		break;
 	case C_STARTING_SYNC_S:
-		drbd_start_resync(mdev, C_SYNC_SOURCE);
+		drbd_start_resync(device, C_SYNC_SOURCE);
 		break;
 	}
 }
 
-int drbd_bitmap_io_from_worker(struct drbd_device *mdev,
+int drbd_bitmap_io_from_worker(struct drbd_device *device,
 		int (*io_fn)(struct drbd_device *),
 		char *why, enum bm_flag flags)
 {
 	int rv;
 
-	D_ASSERT(current == mdev->tconn->worker.task);
+	D_ASSERT(current == device->tconn->worker.task);
 
-	/* open coded non-blocking drbd_suspend_io(mdev); */
-	set_bit(SUSPEND_IO, &mdev->flags);
+	/* open coded non-blocking drbd_suspend_io(device); */
+	set_bit(SUSPEND_IO, &device->flags);
 
-	drbd_bm_lock(mdev, why, flags);
-	rv = io_fn(mdev);
-	drbd_bm_unlock(mdev);
+	drbd_bm_lock(device, why, flags);
+	rv = io_fn(device);
+	drbd_bm_unlock(device);
 
-	drbd_resume_io(mdev);
+	drbd_resume_io(device);
 
 	return rv;
 }
 
 /**
  * after_state_ch() - Perform after state change actions that may sleep
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @os:		old state.
  * @ns:		new state.
  * @flags:	Flags
  */
-static void after_state_ch(struct drbd_device *mdev, union drbd_state os,
+static void after_state_ch(struct drbd_device *device, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags)
 {
 	struct sib_info sib;
@@ -1215,23 +1215,23 @@ static void after_state_ch(struct drbd_device *mdev, union drbd_state os,
 	sib.ns = ns;
 
 	if (os.conn != C_CONNECTED && ns.conn == C_CONNECTED) {
-		clear_bit(CRASHED_PRIMARY, &mdev->flags);
-		if (mdev->p_uuid)
-			mdev->p_uuid[UI_FLAGS] &= ~((u64)2);
+		clear_bit(CRASHED_PRIMARY, &device->flags);
+		if (device->p_uuid)
+			device->p_uuid[UI_FLAGS] &= ~((u64)2);
 	}
 
 	/* Inform userspace about the change... */
-	drbd_bcast_event(mdev, &sib);
+	drbd_bcast_event(device, &sib);
 
 	if (!(os.role == R_PRIMARY && os.disk < D_UP_TO_DATE && os.pdsk < D_UP_TO_DATE) &&
 	    (ns.role == R_PRIMARY && ns.disk < D_UP_TO_DATE && ns.pdsk < D_UP_TO_DATE))
-		drbd_khelper(mdev, "pri-on-incon-degr");
+		drbd_khelper(device, "pri-on-incon-degr");
 
 	/* Here we have the actions that are performed after a
 	   state change. This function might sleep */
 
 	if (ns.susp_nod) {
-		struct drbd_tconn *tconn = mdev->tconn;
+		struct drbd_tconn *tconn = device->tconn;
 		enum drbd_req_event what = NOTHING;
 
 		spin_lock_irq(&tconn->req_lock);
@@ -1253,7 +1253,7 @@ static void after_state_ch(struct drbd_device *mdev, union drbd_state os,
 	}
 
 	if (ns.susp_fen) {
-		struct drbd_tconn *tconn = mdev->tconn;
+		struct drbd_tconn *tconn = device->tconn;
 
 		spin_lock_irq(&tconn->req_lock);
 		if (tconn->susp_fen && conn_lowest_conn(tconn) >= C_CONNECTED) {
@@ -1280,9 +1280,9 @@ static void after_state_ch(struct drbd_device *mdev, union drbd_state os,
 	 * which is unexpected. */
 	if ((os.conn != C_SYNC_SOURCE && os.conn != C_PAUSED_SYNC_S) &&
 	    (ns.conn == C_SYNC_SOURCE || ns.conn == C_PAUSED_SYNC_S) &&
-	    mdev->tconn->agreed_pro_version >= 96 && get_ldev(mdev)) {
-		drbd_gen_and_send_sync_uuid(mdev);
-		put_ldev(mdev);
+	    device->tconn->agreed_pro_version >= 96 && get_ldev(device)) {
+		drbd_gen_and_send_sync_uuid(device);
+		put_ldev(device);
 	}
 
 	/* Do not change the order of the if above and the two below... */
@@ -1290,20 +1290,20 @@ static void after_state_ch(struct drbd_device *mdev, union drbd_state os,
 	    ns.pdsk > D_DISKLESS && ns.pdsk != D_UNKNOWN) {      /* attach on the peer */
 		/* we probably will start a resync soon.
 		 * make sure those things are properly reset. */
-		mdev->rs_total = 0;
-		mdev->rs_failed = 0;
-		atomic_set(&mdev->rs_pending_cnt, 0);
-		drbd_rs_cancel_all(mdev);
+		device->rs_total = 0;
+		device->rs_failed = 0;
+		atomic_set(&device->rs_pending_cnt, 0);
+		drbd_rs_cancel_all(device);
 
-		drbd_send_uuids(mdev);
-		drbd_send_state(mdev, ns);
+		drbd_send_uuids(device);
+		drbd_send_state(device, ns);
 	}
 	/* No point in queuing send_bitmap if we don't have a connection
 	 * anymore, so check also the _current_ state, not only the new state
 	 * at the time this work was queued. */
 	if (os.conn != C_WF_BITMAP_S && ns.conn == C_WF_BITMAP_S &&
-	    mdev->state.conn == C_WF_BITMAP_S)
-		drbd_queue_bitmap_io(mdev, &drbd_send_bitmap, NULL,
+	    device->state.conn == C_WF_BITMAP_S)
+		drbd_queue_bitmap_io(device, &drbd_send_bitmap, NULL,
 				"send_bitmap (WFBitMapS)",
 				BM_LOCKED_TEST_ALLOWED);
 
@@ -1314,80 +1314,80 @@ static void after_state_ch(struct drbd_device *mdev, union drbd_state os,
 	&&  (ns.pdsk < D_INCONSISTENT ||
 	     ns.pdsk == D_UNKNOWN ||
 	     ns.pdsk == D_OUTDATED)) {
-		if (get_ldev(mdev)) {
+		if (get_ldev(device)) {
 			if ((ns.role == R_PRIMARY || ns.peer == R_PRIMARY) &&
-			    mdev->ldev->md.uuid[UI_BITMAP] == 0 && ns.disk >= D_UP_TO_DATE) {
-				if (drbd_suspended(mdev)) {
-					set_bit(NEW_CUR_UUID, &mdev->flags);
+			    device->ldev->md.uuid[UI_BITMAP] == 0 && ns.disk >= D_UP_TO_DATE) {
+				if (drbd_suspended(device)) {
+					set_bit(NEW_CUR_UUID, &device->flags);
 				} else {
-					drbd_uuid_new_current(mdev);
-					drbd_send_uuids(mdev);
+					drbd_uuid_new_current(device);
+					drbd_send_uuids(device);
 				}
 			}
-			put_ldev(mdev);
+			put_ldev(device);
 		}
 	}
 
-	if (ns.pdsk < D_INCONSISTENT && get_ldev(mdev)) {
+	if (ns.pdsk < D_INCONSISTENT && get_ldev(device)) {
 		if (os.peer == R_SECONDARY && ns.peer == R_PRIMARY &&
-		    mdev->ldev->md.uuid[UI_BITMAP] == 0 && ns.disk >= D_UP_TO_DATE) {
-			drbd_uuid_new_current(mdev);
-			drbd_send_uuids(mdev);
+		    device->ldev->md.uuid[UI_BITMAP] == 0 && ns.disk >= D_UP_TO_DATE) {
+			drbd_uuid_new_current(device);
+			drbd_send_uuids(device);
 		}
 		/* D_DISKLESS Peer becomes secondary */
 		if (os.peer == R_PRIMARY && ns.peer == R_SECONDARY)
 			/* We may still be Primary ourselves.
 			 * No harm done if the bitmap still changes,
 			 * redirtied pages will follow later. */
-			drbd_bitmap_io_from_worker(mdev, &drbd_bm_write,
+			drbd_bitmap_io_from_worker(device, &drbd_bm_write,
 				"demote diskless peer", BM_LOCKED_SET_ALLOWED);
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 
 	/* Write out all changed bits on demote.
 	 * Though, no need to da that just yet
 	 * if there is a resync going on still */
 	if (os.role == R_PRIMARY && ns.role == R_SECONDARY &&
-		mdev->state.conn <= C_CONNECTED && get_ldev(mdev)) {
+		device->state.conn <= C_CONNECTED && get_ldev(device)) {
 		/* No changes to the bitmap expected this time, so assert that,
 		 * even though no harm was done if it did change. */
-		drbd_bitmap_io_from_worker(mdev, &drbd_bm_write,
+		drbd_bitmap_io_from_worker(device, &drbd_bm_write,
 				"demote", BM_LOCKED_TEST_ALLOWED);
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 
 	/* Last part of the attaching process ... */
 	if (ns.conn >= C_CONNECTED &&
 	    os.disk == D_ATTACHING && ns.disk == D_NEGOTIATING) {
-		drbd_send_sizes(mdev, 0, 0);  /* to start sync... */
-		drbd_send_uuids(mdev);
-		drbd_send_state(mdev, ns);
+		drbd_send_sizes(device, 0, 0);  /* to start sync... */
+		drbd_send_uuids(device);
+		drbd_send_state(device, ns);
 	}
 
 	/* We want to pause/continue resync, tell peer. */
 	if (ns.conn >= C_CONNECTED &&
 	     ((os.aftr_isp != ns.aftr_isp) ||
 	      (os.user_isp != ns.user_isp)))
-		drbd_send_state(mdev, ns);
+		drbd_send_state(device, ns);
 
 	/* In case one of the isp bits got set, suspend other devices. */
 	if ((!os.aftr_isp && !os.peer_isp && !os.user_isp) &&
 	    (ns.aftr_isp || ns.peer_isp || ns.user_isp))
-		suspend_other_sg(mdev);
+		suspend_other_sg(device);
 
 	/* Make sure the peer gets informed about eventual state
 	   changes (ISP bits) while we were in WFReportParams. */
 	if (os.conn == C_WF_REPORT_PARAMS && ns.conn >= C_CONNECTED)
-		drbd_send_state(mdev, ns);
+		drbd_send_state(device, ns);
 
 	if (os.conn != C_AHEAD && ns.conn == C_AHEAD)
-		drbd_send_state(mdev, ns);
+		drbd_send_state(device, ns);
 
 	/* We are in the progress to start a full sync... */
 	if ((os.conn != C_STARTING_SYNC_T && ns.conn == C_STARTING_SYNC_T) ||
 	    (os.conn != C_STARTING_SYNC_S && ns.conn == C_STARTING_SYNC_S))
 		/* no other bitmap changes expected during this phase */
-		drbd_queue_bitmap_io(mdev,
+		drbd_queue_bitmap_io(device,
 			&drbd_bmio_set_n_write, &abw_start_sync,
 			"set_n_write from StartingSync", BM_LOCKED_TEST_ALLOWED);
 
@@ -1400,15 +1400,15 @@ static void after_state_ch(struct drbd_device *mdev, union drbd_state os,
 		 * our cleanup here with the transition to D_DISKLESS.
 		 * But is is still not save to dreference ldev here, since
 		 * we might come from an failed Attach before ldev was set. */
-		if (mdev->ldev) {
+		if (device->ldev) {
 			rcu_read_lock();
-			eh = rcu_dereference(mdev->ldev->disk_conf)->on_io_error;
+			eh = rcu_dereference(device->ldev->disk_conf)->on_io_error;
 			rcu_read_unlock();
 
-			was_io_error = test_and_clear_bit(WAS_IO_ERROR, &mdev->flags);
+			was_io_error = test_and_clear_bit(WAS_IO_ERROR, &device->flags);
 
 			if (was_io_error && eh == EP_CALL_HELPER)
-				drbd_khelper(mdev, "local-io-error");
+				drbd_khelper(device, "local-io-error");
 
 			/* Immediately allow completion of all application IO,
 			 * that waits for completion from the local disk,
@@ -1423,76 +1423,76 @@ static void after_state_ch(struct drbd_device *mdev, union drbd_state os,
 			 * So aborting local requests may cause crashes,
 			 * or even worse, silent data corruption.
 			 */
-			if (test_and_clear_bit(FORCE_DETACH, &mdev->flags))
-				tl_abort_disk_io(mdev);
+			if (test_and_clear_bit(FORCE_DETACH, &device->flags))
+				tl_abort_disk_io(device);
 
 			/* current state still has to be D_FAILED,
 			 * there is only one way out: to D_DISKLESS,
 			 * and that may only happen after our put_ldev below. */
-			if (mdev->state.disk != D_FAILED)
+			if (device->state.disk != D_FAILED)
 				dev_err(DEV,
 					"ASSERT FAILED: disk is %s during detach\n",
-					drbd_disk_str(mdev->state.disk));
+					drbd_disk_str(device->state.disk));
 
 			if (ns.conn >= C_CONNECTED)
-				drbd_send_state(mdev, ns);
+				drbd_send_state(device, ns);
 
-			drbd_rs_cancel_all(mdev);
+			drbd_rs_cancel_all(device);
 
 			/* In case we want to get something to stable storage still,
 			 * this may be the last chance.
 			 * Following put_ldev may transition to D_DISKLESS. */
-			drbd_md_sync(mdev);
+			drbd_md_sync(device);
 		}
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 
-        /* second half of local IO error, failure to attach,
-         * or administrative detach,
-         * after local_cnt references have reached zero again */
-        if (os.disk != D_DISKLESS && ns.disk == D_DISKLESS) {
-                /* We must still be diskless,
-                 * re-attach has to be serialized with this! */
-                if (mdev->state.disk != D_DISKLESS)
-                        dev_err(DEV,
-                                "ASSERT FAILED: disk is %s while going diskless\n",
-                                drbd_disk_str(mdev->state.disk));
+	/* second half of local IO error, failure to attach,
+	 * or administrative detach,
+	 * after local_cnt references have reached zero again */
+	if (os.disk != D_DISKLESS && ns.disk == D_DISKLESS) {
+		/* We must still be diskless,
+		 * re-attach has to be serialized with this! */
+		if (device->state.disk != D_DISKLESS)
+			dev_err(DEV,
+				"ASSERT FAILED: disk is %s while going diskless\n",
+				drbd_disk_str(device->state.disk));
 
 		if (ns.conn >= C_CONNECTED)
-			drbd_send_state(mdev, ns);
+			drbd_send_state(device, ns);
 		/* corresponding get_ldev in __drbd_set_state
 		 * this may finally trigger drbd_ldev_destroy. */
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 
 	/* Notify peer that I had a local IO error, and did not detached.. */
 	if (os.disk == D_UP_TO_DATE && ns.disk == D_INCONSISTENT && ns.conn >= C_CONNECTED)
-		drbd_send_state(mdev, ns);
+		drbd_send_state(device, ns);
 
 	/* Disks got bigger while they were detached */
 	if (ns.disk > D_NEGOTIATING && ns.pdsk > D_NEGOTIATING &&
-	    test_and_clear_bit(RESYNC_AFTER_NEG, &mdev->flags)) {
+	    test_and_clear_bit(RESYNC_AFTER_NEG, &device->flags)) {
 		if (ns.conn == C_CONNECTED)
-			resync_after_online_grow(mdev);
+			resync_after_online_grow(device);
 	}
 
 	/* A resync finished or aborted, wake paused devices... */
 	if ((os.conn > C_CONNECTED && ns.conn <= C_CONNECTED) ||
 	    (os.peer_isp && !ns.peer_isp) ||
 	    (os.user_isp && !ns.user_isp))
-		resume_next_sg(mdev);
+		resume_next_sg(device);
 
 	/* sync target done with resync.  Explicitly notify peer, even though
 	 * it should (at least for non-empty resyncs) already know itself. */
 	if (os.disk < D_UP_TO_DATE && os.conn >= C_SYNC_SOURCE && ns.conn == C_CONNECTED)
-		drbd_send_state(mdev, ns);
+		drbd_send_state(device, ns);
 
 	/* Verify finished, or reached stop sector.  Peer did not know about
 	 * the stop sector, and we may even have changed the stop sector during
 	 * verify to interrupt/stop early.  Send the new state. */
 	if (os.conn == C_VERIFY_S && ns.conn == C_CONNECTED
-	&& verify_can_do_stop_sector(mdev))
-		drbd_send_state(mdev, ns);
+	&& verify_can_do_stop_sector(device))
+		drbd_send_state(device, ns);
 
 	/* This triggers bitmap writeout of potentially still unwritten pages
 	 * if the resync finished cleanly, or aborted because of peer disk
@@ -1501,27 +1501,27 @@ static void after_state_ch(struct drbd_device *mdev, union drbd_state os,
 	 * any bitmap writeout anymore.
 	 * No harm done if some bits change during this phase.
 	 */
-	if (os.conn > C_CONNECTED && ns.conn <= C_CONNECTED && get_ldev(mdev)) {
-		drbd_queue_bitmap_io(mdev, &drbd_bm_write_copy_pages, NULL,
+	if (os.conn > C_CONNECTED && ns.conn <= C_CONNECTED && get_ldev(device)) {
+		drbd_queue_bitmap_io(device, &drbd_bm_write_copy_pages, NULL,
 			"write from resync_finished", BM_LOCKED_CHANGE_ALLOWED);
-		put_ldev(mdev);
+		put_ldev(device);
 	}
 
 	if (ns.disk == D_DISKLESS &&
 	    ns.conn == C_STANDALONE &&
 	    ns.role == R_SECONDARY) {
 		if (os.aftr_isp != ns.aftr_isp)
-			resume_next_sg(mdev);
+			resume_next_sg(device);
 	}
 
-	drbd_md_sync(mdev);
+	drbd_md_sync(device);
 }
 
 struct after_conn_state_chg_work {
 	struct drbd_work w;
 	enum drbd_conns oc;
 	union drbd_state ns_min;
-	union drbd_state ns_max; /* new, max state, over all mdevs */
+	union drbd_state ns_max; /* new, max state, over all devices */
 	enum chg_state_flags flags;
 };
 
@@ -1532,7 +1532,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 	struct drbd_tconn *tconn = w->tconn;
 	enum drbd_conns oc = acscw->oc;
 	union drbd_state ns_max = acscw->ns_max;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 
 	kfree(acscw);
@@ -1560,10 +1560,10 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 		/* case1: The outdate peer handler is successful: */
 		if (ns_max.pdsk <= D_OUTDATED) {
 			rcu_read_lock();
-			idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-				if (test_bit(NEW_CUR_UUID, &mdev->flags)) {
-					drbd_uuid_new_current(mdev);
-					clear_bit(NEW_CUR_UUID, &mdev->flags);
+			idr_for_each_entry(&tconn->volumes, device, vnr) {
+				if (test_bit(NEW_CUR_UUID, &device->flags)) {
+					drbd_uuid_new_current(device);
+					clear_bit(NEW_CUR_UUID, &device->flags);
 				}
 			}
 			rcu_read_unlock();
@@ -1586,7 +1586,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, enum chg_state_flags *pf)
 {
 	enum chg_state_flags flags = ~0;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr, first_vol = 1;
 	union drbd_dev_state os, cs = {
 		{ .role = R_SECONDARY,
@@ -1597,8 +1597,8 @@ void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, enum
 		} };
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		os = mdev->state;
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
+		os = device->state;
 
 		if (first_vol) {
 			cs = os;
@@ -1634,13 +1634,13 @@ conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union
 {
 	enum drbd_state_rv rv = SS_SUCCESS;
 	union drbd_state ns, os;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	int vnr;
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		os = drbd_read_state(mdev);
-		ns = sanitize_state(mdev, apply_mask_val(os, mask, val), NULL);
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
+		os = drbd_read_state(device);
+		ns = sanitize_state(device, apply_mask_val(os, mask, val), NULL);
 
 		if (flags & CS_IGN_OUTD_FAIL && ns.disk == D_OUTDATED && os.disk < D_OUTDATED)
 			ns.disk = os.disk;
@@ -1653,9 +1653,9 @@ conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union
 			break;
 
 		if (!(flags & CS_HARD)) {
-			rv = is_valid_state(mdev, ns);
+			rv = is_valid_state(device, ns);
 			if (rv < SS_SUCCESS) {
-				if (is_valid_state(mdev, os) == rv)
+				if (is_valid_state(device, os) == rv)
 					rv = is_valid_soft_transition(os, ns, tconn);
 			} else
 				rv = is_valid_soft_transition(os, ns, tconn);
@@ -1666,7 +1666,7 @@ conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union
 	rcu_read_unlock();
 
 	if (rv < SS_SUCCESS && flags & CS_VERBOSE)
-		print_st_err(mdev, os, ns, rv);
+		print_st_err(device, os, ns, rv);
 
 	return rv;
 }
@@ -1683,7 +1683,7 @@ conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 		  .disk = D_MASK,
 		  .pdsk = D_MASK
 		} };
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	enum drbd_state_rv rv;
 	int vnr, number_of_volumes = 0;
 
@@ -1698,20 +1698,20 @@ conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 	}
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
 		number_of_volumes++;
-		os = drbd_read_state(mdev);
+		os = drbd_read_state(device);
 		ns = apply_mask_val(os, mask, val);
-		ns = sanitize_state(mdev, ns, NULL);
+		ns = sanitize_state(device, ns, NULL);
 
 		if (flags & CS_IGN_OUTD_FAIL && ns.disk == D_OUTDATED && os.disk < D_OUTDATED)
 			ns.disk = os.disk;
 
-		rv = __drbd_set_state(mdev, ns, flags, NULL);
+		rv = __drbd_set_state(device, ns, flags, NULL);
 		if (rv < SS_SUCCESS)
 			BUG();
 
-		ns.i = mdev->state.i;
+		ns.i = device->state.i;
 		ns_max.role = max_role(ns.role, ns_max.role);
 		ns_max.peer = max_role(ns.peer, ns_max.peer);
 		ns_max.conn = max_t(enum drbd_conns, ns.conn, ns_max.conn);
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index 181b6b2..033668a 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -107,7 +107,7 @@ union drbd_dev_state {
 	unsigned int i;
 };
 
-extern enum drbd_state_rv drbd_change_state(struct drbd_device *mdev,
+extern enum drbd_state_rv drbd_change_state(struct drbd_device *device,
 					    enum chg_state_flags f,
 					    union drbd_state mask,
 					    union drbd_state val);
@@ -131,12 +131,12 @@ enum drbd_state_rv
 conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
 		   enum chg_state_flags flags);
 
-extern void drbd_resume_al(struct drbd_device *mdev);
+extern void drbd_resume_al(struct drbd_device *device);
 extern bool conn_all_vols_unconf(struct drbd_tconn *tconn);
 
 /**
  * drbd_request_state() - Reqest a state change
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @mask:	mask of state bits to change.
  * @val:	value of new state bits.
  *
@@ -144,11 +144,11 @@ extern bool conn_all_vols_unconf(struct drbd_tconn *tconn);
  * quite verbose in case the state change is not possible, and all those
  * state changes are globally serialized.
  */
-static inline int drbd_request_state(struct drbd_device *mdev,
+static inline int drbd_request_state(struct drbd_device *device,
 				     union drbd_state mask,
 				     union drbd_state val)
 {
-	return _drbd_request_state(mdev, mask, val, CS_VERBOSE + CS_ORDERED);
+	return _drbd_request_state(device, mask, val, CS_VERBOSE + CS_ORDERED);
 }
 
 enum drbd_role conn_highest_role(struct drbd_tconn *tconn);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 852fa4b..73e5e6d 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -68,10 +68,10 @@ rwlock_t global_state_lock;
 void drbd_md_io_complete(struct bio *bio, int error)
 {
 	struct drbd_md_io *md_io;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 
 	md_io = (struct drbd_md_io *)bio->bi_private;
-	mdev = container_of(md_io, struct drbd_device, md_io);
+	device = container_of(md_io, struct drbd_device, md_io);
 
 	md_io->error = error;
 
@@ -84,14 +84,14 @@ void drbd_md_io_complete(struct bio *bio, int error)
 	 * Make sure we first drop the reference, and only then signal
 	 * completion, or we may (in drbd_al_read_log()) cycle so fast into the
 	 * next drbd_md_sync_page_io(), that we trigger the
-	 * ASSERT(atomic_read(&mdev->md_io_in_use) == 1) there.
+	 * ASSERT(atomic_read(&device->md_io_in_use) == 1) there.
 	 */
-	drbd_md_put_buffer(mdev);
+	drbd_md_put_buffer(device);
 	md_io->done = 1;
-	wake_up(&mdev->misc_wait);
+	wake_up(&device->misc_wait);
 	bio_put(bio);
-	if (mdev->ldev) /* special case: drbd_md_read() during drbd_adm_attach() */
-		put_ldev(mdev);
+	if (device->ldev) /* special case: drbd_md_read() during drbd_adm_attach() */
+		put_ldev(device);
 }
 
 /* reads on behalf of the partner,
@@ -100,19 +100,19 @@ void drbd_md_io_complete(struct bio *bio, int error)
 void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_device *mdev = peer_req->w.mdev;
+	struct drbd_device *device = peer_req->w.device;
 
-	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-	mdev->read_cnt += peer_req->i.size >> 9;
+	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	device->read_cnt += peer_req->i.size >> 9;
 	list_del(&peer_req->w.list);
-	if (list_empty(&mdev->read_ee))
-		wake_up(&mdev->ee_wait);
+	if (list_empty(&device->read_ee))
+		wake_up(&device->ee_wait);
 	if (test_bit(__EE_WAS_ERROR, &peer_req->flags))
-		__drbd_chk_io_error(mdev, DRBD_READ_ERROR);
-	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
+		__drbd_chk_io_error(device, DRBD_READ_ERROR);
+	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
 
-	drbd_queue_work(&mdev->tconn->sender_work, &peer_req->w);
-	put_ldev(mdev);
+	drbd_queue_work(&device->tconn->sender_work, &peer_req->w);
+	put_ldev(device);
 }
 
 /* writes on behalf of the partner, or resync writes,
@@ -120,7 +120,7 @@ void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(lo
 static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_device *mdev = peer_req->w.mdev;
+	struct drbd_device *device = peer_req->w.device;
 	struct drbd_interval i;
 	int do_wake;
 	u64 block_id;
@@ -134,9 +134,9 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 	do_al_complete_io = peer_req->flags & EE_CALL_AL_COMPLETE_IO;
 	block_id = peer_req->block_id;
 
-	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-	mdev->writ_cnt += peer_req->i.size >> 9;
-	list_move_tail(&peer_req->w.list, &mdev->done_ee);
+	spin_lock_irqsave(&device->tconn->req_lock, flags);
+	device->writ_cnt += peer_req->i.size >> 9;
+	list_move_tail(&peer_req->w.list, &device->done_ee);
 
 	/*
 	 * Do not remove from the write_requests tree here: we did not send the
@@ -146,23 +146,23 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 	 * _drbd_clear_done_ee.
 	 */
 
-	do_wake = list_empty(block_id == ID_SYNCER ? &mdev->sync_ee : &mdev->active_ee);
+	do_wake = list_empty(block_id == ID_SYNCER ? &device->sync_ee : &device->active_ee);
 
 	if (test_bit(__EE_WAS_ERROR, &peer_req->flags))
-		__drbd_chk_io_error(mdev, DRBD_WRITE_ERROR);
-	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
+		__drbd_chk_io_error(device, DRBD_WRITE_ERROR);
+	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
 
 	if (block_id == ID_SYNCER)
-		drbd_rs_complete_io(mdev, i.sector);
+		drbd_rs_complete_io(device, i.sector);
 
 	if (do_wake)
-		wake_up(&mdev->ee_wait);
+		wake_up(&device->ee_wait);
 
 	if (do_al_complete_io)
-		drbd_al_complete_io(mdev, &i);
+		drbd_al_complete_io(device, &i);
 
-	wake_asender(mdev->tconn);
-	put_ldev(mdev);
+	wake_asender(device->tconn);
+	put_ldev(device);
 }
 
 /* writes on behalf of the partner, or resync writes,
@@ -171,7 +171,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 void drbd_peer_request_endio(struct bio *bio, int error)
 {
 	struct drbd_peer_request *peer_req = bio->bi_private;
-	struct drbd_device *mdev = peer_req->w.mdev;
+	struct drbd_device *device = peer_req->w.device;
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
 	int is_write = bio_data_dir(bio) == WRITE;
 
@@ -208,7 +208,7 @@ void drbd_request_endio(struct bio *bio, int error)
 {
 	unsigned long flags;
 	struct drbd_request *req = bio->bi_private;
-	struct drbd_device *mdev = req->w.mdev;
+	struct drbd_device *device = req->w.device;
 	struct bio_and_error m;
 	enum drbd_req_event what;
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
@@ -273,16 +273,16 @@ void drbd_request_endio(struct bio *bio, int error)
 	req->private_bio = ERR_PTR(error);
 
 	/* not req_mod(), we need irqsave here! */
-	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
+	spin_lock_irqsave(&device->tconn->req_lock, flags);
 	__req_mod(req, what, &m);
-	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
-	put_ldev(mdev);
+	spin_unlock_irqrestore(&device->tconn->req_lock, flags);
+	put_ldev(device);
 
 	if (m.bio)
-		complete_master_bio(mdev, &m);
+		complete_master_bio(device, &m);
 }
 
-void drbd_csum_ee(struct drbd_device *mdev, struct crypto_hash *tfm,
+void drbd_csum_ee(struct drbd_device *device, struct crypto_hash *tfm,
 		  struct drbd_peer_request *peer_req, void *digest)
 {
 	struct hash_desc desc;
@@ -310,7 +310,7 @@ void drbd_csum_ee(struct drbd_device *mdev, struct crypto_hash *tfm,
 	crypto_hash_final(&desc, digest);
 }
 
-void drbd_csum_bio(struct drbd_device *mdev, struct crypto_hash *tfm, struct bio *bio, void *digest)
+void drbd_csum_bio(struct drbd_device *device, struct crypto_hash *tfm, struct bio *bio, void *digest)
 {
 	struct hash_desc desc;
 	struct scatterlist sg;
@@ -334,7 +334,7 @@ void drbd_csum_bio(struct drbd_device *mdev, struct crypto_hash *tfm, struct bio
 static int w_e_send_csum(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	int digest_size;
 	void *digest;
 	int err = 0;
@@ -345,21 +345,21 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 	if (unlikely((peer_req->flags & EE_WAS_ERROR) != 0))
 		goto out;
 
-	digest_size = crypto_hash_digestsize(mdev->tconn->csums_tfm);
+	digest_size = crypto_hash_digestsize(device->tconn->csums_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (digest) {
 		sector_t sector = peer_req->i.sector;
 		unsigned int size = peer_req->i.size;
-		drbd_csum_ee(mdev, mdev->tconn->csums_tfm, peer_req, digest);
+		drbd_csum_ee(device, device->tconn->csums_tfm, peer_req, digest);
 		/* Free peer_req and pages before send.
 		 * In case we block on congestion, we could otherwise run into
 		 * some distributed deadlock, if the other side blocks on
 		 * congestion as well, because our receiver blocks in
 		 * drbd_alloc_pages due to pp_in_use > max_buffers. */
-		drbd_free_peer_req(mdev, peer_req);
+		drbd_free_peer_req(device, peer_req);
 		peer_req = NULL;
-		inc_rs_pending(mdev);
-		err = drbd_send_drequest_csum(mdev, sector, size,
+		inc_rs_pending(device);
+		err = drbd_send_drequest_csum(device, sector, size,
 					      digest, digest_size,
 					      P_CSUM_RS_REQUEST);
 		kfree(digest);
@@ -370,7 +370,7 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 
 out:
 	if (peer_req)
-		drbd_free_peer_req(mdev, peer_req);
+		drbd_free_peer_req(device, peer_req);
 
 	if (unlikely(err))
 		dev_err(DEV, "drbd_send_drequest(..., csum) failed\n");
@@ -379,50 +379,50 @@ out:
 
 #define GFP_TRY	(__GFP_HIGHMEM | __GFP_NOWARN)
 
-static int read_for_csum(struct drbd_device *mdev, sector_t sector, int size)
+static int read_for_csum(struct drbd_device *device, sector_t sector, int size)
 {
 	struct drbd_peer_request *peer_req;
 
-	if (!get_ldev(mdev))
+	if (!get_ldev(device))
 		return -EIO;
 
-	if (drbd_rs_should_slow_down(mdev, sector))
+	if (drbd_rs_should_slow_down(device, sector))
 		goto defer;
 
 	/* GFP_TRY, because if there is no memory available right now, this may
 	 * be rescheduled for later. It is "only" background resync, after all. */
-	peer_req = drbd_alloc_peer_req(mdev, ID_SYNCER /* unused */, sector,
+	peer_req = drbd_alloc_peer_req(device, ID_SYNCER /* unused */, sector,
 				       size, GFP_TRY);
 	if (!peer_req)
 		goto defer;
 
 	peer_req->w.cb = w_e_send_csum;
-	spin_lock_irq(&mdev->tconn->req_lock);
-	list_add(&peer_req->w.list, &mdev->read_ee);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
+	list_add(&peer_req->w.list, &device->read_ee);
+	spin_unlock_irq(&device->tconn->req_lock);
 
-	atomic_add(size >> 9, &mdev->rs_sect_ev);
-	if (drbd_submit_peer_request(mdev, peer_req, READ, DRBD_FAULT_RS_RD) == 0)
+	atomic_add(size >> 9, &device->rs_sect_ev);
+	if (drbd_submit_peer_request(device, peer_req, READ, DRBD_FAULT_RS_RD) == 0)
 		return 0;
 
 	/* If it failed because of ENOMEM, retry should help.  If it failed
 	 * because bio_add_page failed (probably broken lower level driver),
 	 * retry may or may not help.
 	 * If it does not, you may need to force disconnect. */
-	spin_lock_irq(&mdev->tconn->req_lock);
+	spin_lock_irq(&device->tconn->req_lock);
 	list_del(&peer_req->w.list);
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	spin_unlock_irq(&device->tconn->req_lock);
 
-	drbd_free_peer_req(mdev, peer_req);
+	drbd_free_peer_req(device, peer_req);
 defer:
-	put_ldev(mdev);
+	put_ldev(device);
 	return -EAGAIN;
 }
 
 int w_resync_timer(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *mdev = w->mdev;
-	switch (mdev->state.conn) {
+	struct drbd_device *device = w->device;
+	switch (device->state.conn) {
 	case C_VERIFY_S:
 		w_make_ov_request(w, cancel);
 		break;
@@ -436,10 +436,10 @@ int w_resync_timer(struct drbd_work *w, int cancel)
 
 void resync_timer_fn(unsigned long data)
 {
-	struct drbd_device *mdev = (struct drbd_device *) data;
+	struct drbd_device *device = (struct drbd_device *) data;
 
-	if (list_empty(&mdev->resync_work.list))
-		drbd_queue_work(&mdev->tconn->sender_work, &mdev->resync_work);
+	if (list_empty(&device->resync_work.list))
+		drbd_queue_work(&device->tconn->sender_work, &device->resync_work);
 }
 
 static void fifo_set(struct fifo_buffer *fb, int value)
@@ -486,7 +486,7 @@ struct fifo_buffer *fifo_alloc(int fifo_size)
 	return fb;
 }
 
-static int drbd_rs_controller(struct drbd_device *mdev)
+static int drbd_rs_controller(struct drbd_device *device)
 {
 	struct disk_conf *dc;
 	unsigned int sect_in;  /* Number of sectors that came in since the last turn */
@@ -499,22 +499,22 @@ static int drbd_rs_controller(struct drbd_device *mdev)
 	int max_sect;
 	struct fifo_buffer *plan;
 
-	sect_in = atomic_xchg(&mdev->rs_sect_in, 0); /* Number of sectors that came in */
-	mdev->rs_in_flight -= sect_in;
+	sect_in = atomic_xchg(&device->rs_sect_in, 0); /* Number of sectors that came in */
+	device->rs_in_flight -= sect_in;
 
-	dc = rcu_dereference(mdev->ldev->disk_conf);
-	plan = rcu_dereference(mdev->rs_plan_s);
+	dc = rcu_dereference(device->ldev->disk_conf);
+	plan = rcu_dereference(device->rs_plan_s);
 
 	steps = plan->size; /* (dc->c_plan_ahead * 10 * SLEEP_TIME) / HZ; */
 
-	if (mdev->rs_in_flight + sect_in == 0) { /* At start of resync */
+	if (device->rs_in_flight + sect_in == 0) { /* At start of resync */
 		want = ((dc->resync_rate * 2 * SLEEP_TIME) / HZ) * steps;
 	} else { /* normal path */
 		want = dc->c_fill_target ? dc->c_fill_target :
 			sect_in * dc->c_delay_target * HZ / (SLEEP_TIME * 10);
 	}
 
-	correction = want - mdev->rs_in_flight - plan->total;
+	correction = want - device->rs_in_flight - plan->total;
 
 	/* Plan ahead */
 	cps = correction / steps;
@@ -535,24 +535,24 @@ static int drbd_rs_controller(struct drbd_device *mdev)
 
 	/*
 	dev_warn(DEV, "si=%u if=%d wa=%u co=%d st=%d cps=%d pl=%d cc=%d rs=%d\n",
-		 sect_in, mdev->rs_in_flight, want, correction,
-		 steps, cps, mdev->rs_planed, curr_corr, req_sect);
+		 sect_in, device->rs_in_flight, want, correction,
+		 steps, cps, device->rs_planed, curr_corr, req_sect);
 	*/
 
 	return req_sect;
 }
 
-static int drbd_rs_number_requests(struct drbd_device *mdev)
+static int drbd_rs_number_requests(struct drbd_device *device)
 {
 	int number;
 
 	rcu_read_lock();
-	if (rcu_dereference(mdev->rs_plan_s)->size) {
-		number = drbd_rs_controller(mdev) >> (BM_BLOCK_SHIFT - 9);
-		mdev->c_sync_rate = number * HZ * (BM_BLOCK_SIZE / 1024) / SLEEP_TIME;
+	if (rcu_dereference(device->rs_plan_s)->size) {
+		number = drbd_rs_controller(device) >> (BM_BLOCK_SHIFT - 9);
+		device->c_sync_rate = number * HZ * (BM_BLOCK_SIZE / 1024) / SLEEP_TIME;
 	} else {
-		mdev->c_sync_rate = rcu_dereference(mdev->ldev->disk_conf)->resync_rate;
-		number = SLEEP_TIME * mdev->c_sync_rate  / ((BM_BLOCK_SIZE / 1024) * HZ);
+		device->c_sync_rate = rcu_dereference(device->ldev->disk_conf)->resync_rate;
+		number = SLEEP_TIME * device->c_sync_rate  / ((BM_BLOCK_SIZE / 1024) * HZ);
 	}
 	rcu_read_unlock();
 
@@ -563,10 +563,10 @@ static int drbd_rs_number_requests(struct drbd_device *mdev)
 
 int w_make_resync_request(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	unsigned long bit;
 	sector_t sector;
-	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
+	const sector_t capacity = drbd_get_capacity(device->this_bdev);
 	int max_bio_size;
 	int number, rollback_i, size;
 	int align, queued, sndbuf;
@@ -575,61 +575,61 @@ int w_make_resync_request(struct drbd_work *w, int cancel)
 	if (unlikely(cancel))
 		return 0;
 
-	if (mdev->rs_total == 0) {
+	if (device->rs_total == 0) {
 		/* empty resync? */
-		drbd_resync_finished(mdev);
+		drbd_resync_finished(device);
 		return 0;
 	}
 
-	if (!get_ldev(mdev)) {
-		/* Since we only need to access mdev->rsync a
-		   get_ldev_if_state(mdev,D_FAILED) would be sufficient, but
+	if (!get_ldev(device)) {
+		/* Since we only need to access device->rsync a
+		   get_ldev_if_state(device,D_FAILED) would be sufficient, but
 		   to continue resync with a broken disk makes no sense at
 		   all */
 		dev_err(DEV, "Disk broke down during resync!\n");
 		return 0;
 	}
 
-	max_bio_size = queue_max_hw_sectors(mdev->rq_queue) << 9;
-	number = drbd_rs_number_requests(mdev);
+	max_bio_size = queue_max_hw_sectors(device->rq_queue) << 9;
+	number = drbd_rs_number_requests(device);
 	if (number == 0)
 		goto requeue;
 
 	for (i = 0; i < number; i++) {
 		/* Stop generating RS requests, when half of the send buffer is filled */
-		mutex_lock(&mdev->tconn->data.mutex);
-		if (mdev->tconn->data.socket) {
-			queued = mdev->tconn->data.socket->sk->sk_wmem_queued;
-			sndbuf = mdev->tconn->data.socket->sk->sk_sndbuf;
+		mutex_lock(&device->tconn->data.mutex);
+		if (device->tconn->data.socket) {
+			queued = device->tconn->data.socket->sk->sk_wmem_queued;
+			sndbuf = device->tconn->data.socket->sk->sk_sndbuf;
 		} else {
 			queued = 1;
 			sndbuf = 0;
 		}
-		mutex_unlock(&mdev->tconn->data.mutex);
+		mutex_unlock(&device->tconn->data.mutex);
 		if (queued > sndbuf / 2)
 			goto requeue;
 
 next_sector:
 		size = BM_BLOCK_SIZE;
-		bit  = drbd_bm_find_next(mdev, mdev->bm_resync_fo);
+		bit  = drbd_bm_find_next(device, device->bm_resync_fo);
 
 		if (bit == DRBD_END_OF_BITMAP) {
-			mdev->bm_resync_fo = drbd_bm_bits(mdev);
-			put_ldev(mdev);
+			device->bm_resync_fo = drbd_bm_bits(device);
+			put_ldev(device);
 			return 0;
 		}
 
 		sector = BM_BIT_TO_SECT(bit);
 
-		if (drbd_rs_should_slow_down(mdev, sector) ||
-		    drbd_try_rs_begin_io(mdev, sector)) {
-			mdev->bm_resync_fo = bit;
+		if (drbd_rs_should_slow_down(device, sector) ||
+		    drbd_try_rs_begin_io(device, sector)) {
+			device->bm_resync_fo = bit;
 			goto requeue;
 		}
-		mdev->bm_resync_fo = bit + 1;
+		device->bm_resync_fo = bit + 1;
 
-		if (unlikely(drbd_bm_test_bit(mdev, bit) == 0)) {
-			drbd_rs_complete_io(mdev, sector);
+		if (unlikely(drbd_bm_test_bit(device, bit) == 0)) {
+			drbd_rs_complete_io(device, sector);
 			goto next_sector;
 		}
 
@@ -658,7 +658,7 @@ next_sector:
 			 * obscure reason; ( b == 0 ) would get the out-of-band
 			 * only accidentally right because of the "oddly sized"
 			 * adjustment below */
-			if (drbd_bm_test_bit(mdev, bit+1) != 1)
+			if (drbd_bm_test_bit(device, bit+1) != 1)
 				break;
 			bit++;
 			size += BM_BLOCK_SIZE;
@@ -669,20 +669,20 @@ next_sector:
 		/* if we merged some,
 		 * reset the offset to start the next drbd_bm_find_next from */
 		if (size > BM_BLOCK_SIZE)
-			mdev->bm_resync_fo = bit + 1;
+			device->bm_resync_fo = bit + 1;
 #endif
 
 		/* adjust very last sectors, in case we are oddly sized */
 		if (sector + (size>>9) > capacity)
 			size = (capacity-sector)<<9;
-		if (mdev->tconn->agreed_pro_version >= 89 && mdev->tconn->csums_tfm) {
-			switch (read_for_csum(mdev, sector, size)) {
+		if (device->tconn->agreed_pro_version >= 89 && device->tconn->csums_tfm) {
+			switch (read_for_csum(device, sector, size)) {
 			case -EIO: /* Disk failure */
-				put_ldev(mdev);
+				put_ldev(device);
 				return -EIO;
 			case -EAGAIN: /* allocation failed, or ldev busy */
-				drbd_rs_complete_io(mdev, sector);
-				mdev->bm_resync_fo = BM_SECT_TO_BIT(sector);
+				drbd_rs_complete_io(device, sector);
+				device->bm_resync_fo = BM_SECT_TO_BIT(sector);
 				i = rollback_i;
 				goto requeue;
 			case 0:
@@ -694,50 +694,50 @@ next_sector:
 		} else {
 			int err;
 
-			inc_rs_pending(mdev);
-			err = drbd_send_drequest(mdev, P_RS_DATA_REQUEST,
+			inc_rs_pending(device);
+			err = drbd_send_drequest(device, P_RS_DATA_REQUEST,
 						 sector, size, ID_SYNCER);
 			if (err) {
 				dev_err(DEV, "drbd_send_drequest() failed, aborting...\n");
-				dec_rs_pending(mdev);
-				put_ldev(mdev);
+				dec_rs_pending(device);
+				put_ldev(device);
 				return err;
 			}
 		}
 	}
 
-	if (mdev->bm_resync_fo >= drbd_bm_bits(mdev)) {
+	if (device->bm_resync_fo >= drbd_bm_bits(device)) {
 		/* last syncer _request_ was sent,
 		 * but the P_RS_DATA_REPLY not yet received.  sync will end (and
 		 * next sync group will resume), as soon as we receive the last
 		 * resync data block, and the last bit is cleared.
 		 * until then resync "work" is "inactive" ...
 		 */
-		put_ldev(mdev);
+		put_ldev(device);
 		return 0;
 	}
 
  requeue:
-	mdev->rs_in_flight += (i << (BM_BLOCK_SHIFT - 9));
-	mod_timer(&mdev->resync_timer, jiffies + SLEEP_TIME);
-	put_ldev(mdev);
+	device->rs_in_flight += (i << (BM_BLOCK_SHIFT - 9));
+	mod_timer(&device->resync_timer, jiffies + SLEEP_TIME);
+	put_ldev(device);
 	return 0;
 }
 
 static int w_make_ov_request(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	int number, i, size;
 	sector_t sector;
-	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
+	const sector_t capacity = drbd_get_capacity(device->this_bdev);
 	bool stop_sector_reached = false;
 
 	if (unlikely(cancel))
 		return 1;
 
-	number = drbd_rs_number_requests(mdev);
+	number = drbd_rs_number_requests(device);
 
-	sector = mdev->ov_position;
+	sector = device->ov_position;
 	for (i = 0; i < number; i++) {
 		if (sector >= capacity)
 			return 1;
@@ -746,69 +746,69 @@ static int w_make_ov_request(struct drbd_work *w, int cancel)
 		 * w_e_end_ov_reply().
 		 * We need to send at least one request out. */
 		stop_sector_reached = i > 0
-			&& verify_can_do_stop_sector(mdev)
-			&& sector >= mdev->ov_stop_sector;
+			&& verify_can_do_stop_sector(device)
+			&& sector >= device->ov_stop_sector;
 		if (stop_sector_reached)
 			break;
 
 		size = BM_BLOCK_SIZE;
 
-		if (drbd_rs_should_slow_down(mdev, sector) ||
-		    drbd_try_rs_begin_io(mdev, sector)) {
-			mdev->ov_position = sector;
+		if (drbd_rs_should_slow_down(device, sector) ||
+		    drbd_try_rs_begin_io(device, sector)) {
+			device->ov_position = sector;
 			goto requeue;
 		}
 
 		if (sector + (size>>9) > capacity)
 			size = (capacity-sector)<<9;
 
-		inc_rs_pending(mdev);
-		if (drbd_send_ov_request(mdev, sector, size)) {
-			dec_rs_pending(mdev);
+		inc_rs_pending(device);
+		if (drbd_send_ov_request(device, sector, size)) {
+			dec_rs_pending(device);
 			return 0;
 		}
 		sector += BM_SECT_PER_BIT;
 	}
-	mdev->ov_position = sector;
+	device->ov_position = sector;
 
  requeue:
-	mdev->rs_in_flight += (i << (BM_BLOCK_SHIFT - 9));
+	device->rs_in_flight += (i << (BM_BLOCK_SHIFT - 9));
 	if (i == 0 || !stop_sector_reached)
-		mod_timer(&mdev->resync_timer, jiffies + SLEEP_TIME);
+		mod_timer(&device->resync_timer, jiffies + SLEEP_TIME);
 	return 1;
 }
 
 int w_ov_finished(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	kfree(w);
-	ov_out_of_sync_print(mdev);
-	drbd_resync_finished(mdev);
+	ov_out_of_sync_print(device);
+	drbd_resync_finished(device);
 
 	return 0;
 }
 
 static int w_resync_finished(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	kfree(w);
 
-	drbd_resync_finished(mdev);
+	drbd_resync_finished(device);
 
 	return 0;
 }
 
-static void ping_peer(struct drbd_device *mdev)
+static void ping_peer(struct drbd_device *device)
 {
-	struct drbd_tconn *tconn = mdev->tconn;
+	struct drbd_tconn *tconn = device->tconn;
 
 	clear_bit(GOT_PING_ACK, &tconn->flags);
 	request_ping(tconn);
 	wait_event(tconn->ping_wait,
-		   test_bit(GOT_PING_ACK, &tconn->flags) || mdev->state.conn < C_CONNECTED);
+		   test_bit(GOT_PING_ACK, &tconn->flags) || device->state.conn < C_CONNECTED);
 }
 
-int drbd_resync_finished(struct drbd_device *mdev)
+int drbd_resync_finished(struct drbd_device *device)
 {
 	unsigned long db, dt, dbdt;
 	unsigned long n_oos;
@@ -820,7 +820,7 @@ int drbd_resync_finished(struct drbd_device *mdev)
 	/* Remove all elements from the resync LRU. Since future actions
 	 * might set bits in the (main) bitmap, then the entries in the
 	 * resync LRU would be wrong. */
-	if (drbd_rs_del_all(mdev)) {
+	if (drbd_rs_del_all(device)) {
 		/* In case this is not possible now, most probably because
 		 * there are P_RS_DATA_REPLY Packets lingering on the worker's
 		 * queue (or even the read operations for those packets
@@ -830,32 +830,32 @@ int drbd_resync_finished(struct drbd_device *mdev)
 		w = kmalloc(sizeof(struct drbd_work), GFP_ATOMIC);
 		if (w) {
 			w->cb = w_resync_finished;
-			w->mdev = mdev;
-			drbd_queue_work(&mdev->tconn->sender_work, w);
+			w->device = device;
+			drbd_queue_work(&device->tconn->sender_work, w);
 			return 1;
 		}
 		dev_err(DEV, "Warn failed to drbd_rs_del_all() and to kmalloc(w).\n");
 	}
 
-	dt = (jiffies - mdev->rs_start - mdev->rs_paused) / HZ;
+	dt = (jiffies - device->rs_start - device->rs_paused) / HZ;
 	if (dt <= 0)
 		dt = 1;
 	
-	db = mdev->rs_total;
+	db = device->rs_total;
 	/* adjust for verify start and stop sectors, respective reached position */
-	if (mdev->state.conn == C_VERIFY_S || mdev->state.conn == C_VERIFY_T)
-		db -= mdev->ov_left;
+	if (device->state.conn == C_VERIFY_S || device->state.conn == C_VERIFY_T)
+		db -= device->ov_left;
 
 	dbdt = Bit2KB(db/dt);
-	mdev->rs_paused /= HZ;
+	device->rs_paused /= HZ;
 
-	if (!get_ldev(mdev))
+	if (!get_ldev(device))
 		goto out;
 
-	ping_peer(mdev);
+	ping_peer(device);
 
-	spin_lock_irq(&mdev->tconn->req_lock);
-	os = drbd_read_state(mdev);
+	spin_lock_irq(&device->tconn->req_lock);
+	os = drbd_read_state(device);
 
 	verify_done = (os.conn == C_VERIFY_S || os.conn == C_VERIFY_T);
 
@@ -869,9 +869,9 @@ int drbd_resync_finished(struct drbd_device *mdev)
 
 	dev_info(DEV, "%s done (total %lu sec; paused %lu sec; %lu K/sec)\n",
 	     verify_done ? "Online verify" : "Resync",
-	     dt + mdev->rs_paused, mdev->rs_paused, dbdt);
+	     dt + device->rs_paused, device->rs_paused, dbdt);
 
-	n_oos = drbd_bm_total_weight(mdev);
+	n_oos = drbd_bm_total_weight(device);
 
 	if (os.conn == C_VERIFY_S || os.conn == C_VERIFY_T) {
 		if (n_oos) {
@@ -880,28 +880,28 @@ int drbd_resync_finished(struct drbd_device *mdev)
 			khelper_cmd = "out-of-sync";
 		}
 	} else {
-		D_ASSERT((n_oos - mdev->rs_failed) == 0);
+		D_ASSERT((n_oos - device->rs_failed) == 0);
 
 		if (os.conn == C_SYNC_TARGET || os.conn == C_PAUSED_SYNC_T)
 			khelper_cmd = "after-resync-target";
 
-		if (mdev->tconn->csums_tfm && mdev->rs_total) {
-			const unsigned long s = mdev->rs_same_csum;
-			const unsigned long t = mdev->rs_total;
+		if (device->tconn->csums_tfm && device->rs_total) {
+			const unsigned long s = device->rs_same_csum;
+			const unsigned long t = device->rs_total;
 			const int ratio =
 				(t == 0)     ? 0 :
 			(t < 100000) ? ((s*100)/t) : (s/(t/100));
 			dev_info(DEV, "%u %% had equal checksums, eliminated: %luK; "
 			     "transferred %luK total %luK\n",
 			     ratio,
-			     Bit2KB(mdev->rs_same_csum),
-			     Bit2KB(mdev->rs_total - mdev->rs_same_csum),
-			     Bit2KB(mdev->rs_total));
+			     Bit2KB(device->rs_same_csum),
+			     Bit2KB(device->rs_total - device->rs_same_csum),
+			     Bit2KB(device->rs_total));
 		}
 	}
 
-	if (mdev->rs_failed) {
-		dev_info(DEV, "            %lu failed blocks\n", mdev->rs_failed);
+	if (device->rs_failed) {
+		dev_info(DEV, "            %lu failed blocks\n", device->rs_failed);
 
 		if (os.conn == C_SYNC_TARGET || os.conn == C_PAUSED_SYNC_T) {
 			ns.disk = D_INCONSISTENT;
@@ -915,100 +915,100 @@ int drbd_resync_finished(struct drbd_device *mdev)
 		ns.pdsk = D_UP_TO_DATE;
 
 		if (os.conn == C_SYNC_TARGET || os.conn == C_PAUSED_SYNC_T) {
-			if (mdev->p_uuid) {
+			if (device->p_uuid) {
 				int i;
 				for (i = UI_BITMAP ; i <= UI_HISTORY_END ; i++)
-					_drbd_uuid_set(mdev, i, mdev->p_uuid[i]);
-				drbd_uuid_set(mdev, UI_BITMAP, mdev->ldev->md.uuid[UI_CURRENT]);
-				_drbd_uuid_set(mdev, UI_CURRENT, mdev->p_uuid[UI_CURRENT]);
+					_drbd_uuid_set(device, i, device->p_uuid[i]);
+				drbd_uuid_set(device, UI_BITMAP, device->ldev->md.uuid[UI_CURRENT]);
+				_drbd_uuid_set(device, UI_CURRENT, device->p_uuid[UI_CURRENT]);
 			} else {
-				dev_err(DEV, "mdev->p_uuid is NULL! BUG\n");
+				dev_err(DEV, "device->p_uuid is NULL! BUG\n");
 			}
 		}
 
 		if (!(os.conn == C_VERIFY_S || os.conn == C_VERIFY_T)) {
 			/* for verify runs, we don't update uuids here,
 			 * so there would be nothing to report. */
-			drbd_uuid_set_bm(mdev, 0UL);
-			drbd_print_uuids(mdev, "updated UUIDs");
-			if (mdev->p_uuid) {
+			drbd_uuid_set_bm(device, 0UL);
+			drbd_print_uuids(device, "updated UUIDs");
+			if (device->p_uuid) {
 				/* Now the two UUID sets are equal, update what we
 				 * know of the peer. */
 				int i;
 				for (i = UI_CURRENT ; i <= UI_HISTORY_END ; i++)
-					mdev->p_uuid[i] = mdev->ldev->md.uuid[i];
+					device->p_uuid[i] = device->ldev->md.uuid[i];
 			}
 		}
 	}
 
-	_drbd_set_state(mdev, ns, CS_VERBOSE, NULL);
+	_drbd_set_state(device, ns, CS_VERBOSE, NULL);
 out_unlock:
-	spin_unlock_irq(&mdev->tconn->req_lock);
-	put_ldev(mdev);
+	spin_unlock_irq(&device->tconn->req_lock);
+	put_ldev(device);
 out:
-	mdev->rs_total  = 0;
-	mdev->rs_failed = 0;
-	mdev->rs_paused = 0;
+	device->rs_total  = 0;
+	device->rs_failed = 0;
+	device->rs_paused = 0;
 
 	/* reset start sector, if we reached end of device */
-	if (verify_done && mdev->ov_left == 0)
-		mdev->ov_start_sector = 0;
+	if (verify_done && device->ov_left == 0)
+		device->ov_start_sector = 0;
 
-	drbd_md_sync(mdev);
+	drbd_md_sync(device);
 
 	if (khelper_cmd)
-		drbd_khelper(mdev, khelper_cmd);
+		drbd_khelper(device, khelper_cmd);
 
 	return 1;
 }
 
 /* helper */
-static void move_to_net_ee_or_free(struct drbd_device *mdev, struct drbd_peer_request *peer_req)
+static void move_to_net_ee_or_free(struct drbd_device *device, struct drbd_peer_request *peer_req)
 {
 	if (drbd_peer_req_has_active_page(peer_req)) {
 		/* This might happen if sendpage() has not finished */
 		int i = (peer_req->i.size + PAGE_SIZE -1) >> PAGE_SHIFT;
-		atomic_add(i, &mdev->pp_in_use_by_net);
-		atomic_sub(i, &mdev->pp_in_use);
-		spin_lock_irq(&mdev->tconn->req_lock);
-		list_add_tail(&peer_req->w.list, &mdev->net_ee);
-		spin_unlock_irq(&mdev->tconn->req_lock);
+		atomic_add(i, &device->pp_in_use_by_net);
+		atomic_sub(i, &device->pp_in_use);
+		spin_lock_irq(&device->tconn->req_lock);
+		list_add_tail(&peer_req->w.list, &device->net_ee);
+		spin_unlock_irq(&device->tconn->req_lock);
 		wake_up(&drbd_pp_wait);
 	} else
-		drbd_free_peer_req(mdev, peer_req);
+		drbd_free_peer_req(device, peer_req);
 }
 
 /**
  * w_e_end_data_req() - Worker callback, to send a P_DATA_REPLY packet in response to a P_DATA_REQUEST
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
 int w_e_end_data_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	int err;
 
 	if (unlikely(cancel)) {
-		drbd_free_peer_req(mdev, peer_req);
-		dec_unacked(mdev);
+		drbd_free_peer_req(device, peer_req);
+		dec_unacked(device);
 		return 0;
 	}
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
-		err = drbd_send_block(mdev, P_DATA_REPLY, peer_req);
+		err = drbd_send_block(device, P_DATA_REPLY, peer_req);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Sending NegDReply. sector=%llus.\n",
 			    (unsigned long long)peer_req->i.sector);
 
-		err = drbd_send_ack(mdev, P_NEG_DREPLY, peer_req);
+		err = drbd_send_ack(device, P_NEG_DREPLY, peer_req);
 	}
 
-	dec_unacked(mdev);
+	dec_unacked(device);
 
-	move_to_net_ee_or_free(mdev, peer_req);
+	move_to_net_ee_or_free(device, peer_req);
 
 	if (unlikely(err))
 		dev_err(DEV, "drbd_send_block() failed\n");
@@ -1017,33 +1017,33 @@ int w_e_end_data_req(struct drbd_work *w, int cancel)
 
 /**
  * w_e_end_rsdata_req() - Worker callback to send a P_RS_DATA_REPLY packet in response to a P_RS_DATA_REQUEST
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
 int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	int err;
 
 	if (unlikely(cancel)) {
-		drbd_free_peer_req(mdev, peer_req);
-		dec_unacked(mdev);
+		drbd_free_peer_req(device, peer_req);
+		dec_unacked(device);
 		return 0;
 	}
 
-	if (get_ldev_if_state(mdev, D_FAILED)) {
-		drbd_rs_complete_io(mdev, peer_req->i.sector);
-		put_ldev(mdev);
+	if (get_ldev_if_state(device, D_FAILED)) {
+		drbd_rs_complete_io(device, peer_req->i.sector);
+		put_ldev(device);
 	}
 
-	if (mdev->state.conn == C_AHEAD) {
-		err = drbd_send_ack(mdev, P_RS_CANCEL, peer_req);
+	if (device->state.conn == C_AHEAD) {
+		err = drbd_send_ack(device, P_RS_CANCEL, peer_req);
 	} else if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
-		if (likely(mdev->state.pdsk >= D_INCONSISTENT)) {
-			inc_rs_pending(mdev);
-			err = drbd_send_block(mdev, P_RS_DATA_REPLY, peer_req);
+		if (likely(device->state.pdsk >= D_INCONSISTENT)) {
+			inc_rs_pending(device);
+			err = drbd_send_block(device, P_RS_DATA_REPLY, peer_req);
 		} else {
 			if (__ratelimit(&drbd_ratelimit_state))
 				dev_err(DEV, "Not sending RSDataReply, "
@@ -1055,15 +1055,15 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 			dev_err(DEV, "Sending NegRSDReply. sector %llus.\n",
 			    (unsigned long long)peer_req->i.sector);
 
-		err = drbd_send_ack(mdev, P_NEG_RS_DREPLY, peer_req);
+		err = drbd_send_ack(device, P_NEG_RS_DREPLY, peer_req);
 
 		/* update resync data with failure */
-		drbd_rs_failed_io(mdev, peer_req->i.sector, peer_req->i.size);
+		drbd_rs_failed_io(device, peer_req->i.sector, peer_req->i.size);
 	}
 
-	dec_unacked(mdev);
+	dec_unacked(device);
 
-	move_to_net_ee_or_free(mdev, peer_req);
+	move_to_net_ee_or_free(device, peer_req);
 
 	if (unlikely(err))
 		dev_err(DEV, "drbd_send_block() failed\n");
@@ -1073,21 +1073,21 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	struct digest_info *di;
 	int digest_size;
 	void *digest = NULL;
 	int err, eq = 0;
 
 	if (unlikely(cancel)) {
-		drbd_free_peer_req(mdev, peer_req);
-		dec_unacked(mdev);
+		drbd_free_peer_req(device, peer_req);
+		dec_unacked(device);
 		return 0;
 	}
 
-	if (get_ldev(mdev)) {
-		drbd_rs_complete_io(mdev, peer_req->i.sector);
-		put_ldev(mdev);
+	if (get_ldev(device)) {
+		drbd_rs_complete_io(device, peer_req->i.sector);
+		put_ldev(device);
 	}
 
 	di = peer_req->digest;
@@ -1096,37 +1096,37 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 		/* quick hack to try to avoid a race against reconfiguration.
 		 * a real fix would be much more involved,
 		 * introducing more locking mechanisms */
-		if (mdev->tconn->csums_tfm) {
-			digest_size = crypto_hash_digestsize(mdev->tconn->csums_tfm);
+		if (device->tconn->csums_tfm) {
+			digest_size = crypto_hash_digestsize(device->tconn->csums_tfm);
 			D_ASSERT(digest_size == di->digest_size);
 			digest = kmalloc(digest_size, GFP_NOIO);
 		}
 		if (digest) {
-			drbd_csum_ee(mdev, mdev->tconn->csums_tfm, peer_req, digest);
+			drbd_csum_ee(device, device->tconn->csums_tfm, peer_req, digest);
 			eq = !memcmp(digest, di->digest, digest_size);
 			kfree(digest);
 		}
 
 		if (eq) {
-			drbd_set_in_sync(mdev, peer_req->i.sector, peer_req->i.size);
+			drbd_set_in_sync(device, peer_req->i.sector, peer_req->i.size);
 			/* rs_same_csums unit is BM_BLOCK_SIZE */
-			mdev->rs_same_csum += peer_req->i.size >> BM_BLOCK_SHIFT;
-			err = drbd_send_ack(mdev, P_RS_IS_IN_SYNC, peer_req);
+			device->rs_same_csum += peer_req->i.size >> BM_BLOCK_SHIFT;
+			err = drbd_send_ack(device, P_RS_IS_IN_SYNC, peer_req);
 		} else {
-			inc_rs_pending(mdev);
+			inc_rs_pending(device);
 			peer_req->block_id = ID_SYNCER; /* By setting block_id, digest pointer becomes invalid! */
 			peer_req->flags &= ~EE_HAS_DIGEST; /* This peer request no longer has a digest pointer */
 			kfree(di);
-			err = drbd_send_block(mdev, P_RS_DATA_REPLY, peer_req);
+			err = drbd_send_block(device, P_RS_DATA_REPLY, peer_req);
 		}
 	} else {
-		err = drbd_send_ack(mdev, P_NEG_RS_DREPLY, peer_req);
+		err = drbd_send_ack(device, P_NEG_RS_DREPLY, peer_req);
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Sending NegDReply. I guess it gets messy.\n");
 	}
 
-	dec_unacked(mdev);
-	move_to_net_ee_or_free(mdev, peer_req);
+	dec_unacked(device);
+	move_to_net_ee_or_free(device, peer_req);
 
 	if (unlikely(err))
 		dev_err(DEV, "drbd_send_block/ack() failed\n");
@@ -1136,7 +1136,7 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 int w_e_end_ov_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	sector_t sector = peer_req->i.sector;
 	unsigned int size = peer_req->i.size;
 	int digest_size;
@@ -1146,7 +1146,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	if (unlikely(cancel))
 		goto out;
 
-	digest_size = crypto_hash_digestsize(mdev->tconn->verify_tfm);
+	digest_size = crypto_hash_digestsize(device->tconn->verify_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (!digest) {
 		err = 1;	/* terminate the connection in case the allocation failed */
@@ -1154,7 +1154,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	}
 
 	if (likely(!(peer_req->flags & EE_WAS_ERROR)))
-		drbd_csum_ee(mdev, mdev->tconn->verify_tfm, peer_req, digest);
+		drbd_csum_ee(device, device->tconn->verify_tfm, peer_req, digest);
 	else
 		memset(digest, 0, digest_size);
 
@@ -1163,36 +1163,36 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	 * some distributed deadlock, if the other side blocks on
 	 * congestion as well, because our receiver blocks in
 	 * drbd_alloc_pages due to pp_in_use > max_buffers. */
-	drbd_free_peer_req(mdev, peer_req);
+	drbd_free_peer_req(device, peer_req);
 	peer_req = NULL;
-	inc_rs_pending(mdev);
-	err = drbd_send_drequest_csum(mdev, sector, size, digest, digest_size, P_OV_REPLY);
+	inc_rs_pending(device);
+	err = drbd_send_drequest_csum(device, sector, size, digest, digest_size, P_OV_REPLY);
 	if (err)
-		dec_rs_pending(mdev);
+		dec_rs_pending(device);
 	kfree(digest);
 
 out:
 	if (peer_req)
-		drbd_free_peer_req(mdev, peer_req);
-	dec_unacked(mdev);
+		drbd_free_peer_req(device, peer_req);
+	dec_unacked(device);
 	return err;
 }
 
-void drbd_ov_out_of_sync_found(struct drbd_device *mdev, sector_t sector, int size)
+void drbd_ov_out_of_sync_found(struct drbd_device *device, sector_t sector, int size)
 {
-	if (mdev->ov_last_oos_start + mdev->ov_last_oos_size == sector) {
-		mdev->ov_last_oos_size += size>>9;
+	if (device->ov_last_oos_start + device->ov_last_oos_size == sector) {
+		device->ov_last_oos_size += size>>9;
 	} else {
-		mdev->ov_last_oos_start = sector;
-		mdev->ov_last_oos_size = size>>9;
+		device->ov_last_oos_start = sector;
+		device->ov_last_oos_size = size>>9;
 	}
-	drbd_set_out_of_sync(mdev, sector, size);
+	drbd_set_out_of_sync(device, sector, size);
 }
 
 int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	struct digest_info *di;
 	void *digest;
 	sector_t sector = peer_req->i.sector;
@@ -1202,25 +1202,25 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	bool stop_sector_reached = false;
 
 	if (unlikely(cancel)) {
-		drbd_free_peer_req(mdev, peer_req);
-		dec_unacked(mdev);
+		drbd_free_peer_req(device, peer_req);
+		dec_unacked(device);
 		return 0;
 	}
 
 	/* after "cancel", because after drbd_disconnect/drbd_rs_cancel_all
 	 * the resync lru has been cleaned up already */
-	if (get_ldev(mdev)) {
-		drbd_rs_complete_io(mdev, peer_req->i.sector);
-		put_ldev(mdev);
+	if (get_ldev(device)) {
+		drbd_rs_complete_io(device, peer_req->i.sector);
+		put_ldev(device);
 	}
 
 	di = peer_req->digest;
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
-		digest_size = crypto_hash_digestsize(mdev->tconn->verify_tfm);
+		digest_size = crypto_hash_digestsize(device->tconn->verify_tfm);
 		digest = kmalloc(digest_size, GFP_NOIO);
 		if (digest) {
-			drbd_csum_ee(mdev, mdev->tconn->verify_tfm, peer_req, digest);
+			drbd_csum_ee(device, device->tconn->verify_tfm, peer_req, digest);
 
 			D_ASSERT(digest_size == di->digest_size);
 			eq = !memcmp(digest, di->digest, digest_size);
@@ -1233,29 +1233,29 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	 * some distributed deadlock, if the other side blocks on
 	 * congestion as well, because our receiver blocks in
 	 * drbd_alloc_pages due to pp_in_use > max_buffers. */
-	drbd_free_peer_req(mdev, peer_req);
+	drbd_free_peer_req(device, peer_req);
 	if (!eq)
-		drbd_ov_out_of_sync_found(mdev, sector, size);
+		drbd_ov_out_of_sync_found(device, sector, size);
 	else
-		ov_out_of_sync_print(mdev);
+		ov_out_of_sync_print(device);
 
-	err = drbd_send_ack_ex(mdev, P_OV_RESULT, sector, size,
+	err = drbd_send_ack_ex(device, P_OV_RESULT, sector, size,
 			       eq ? ID_IN_SYNC : ID_OUT_OF_SYNC);
 
-	dec_unacked(mdev);
+	dec_unacked(device);
 
-	--mdev->ov_left;
+	--device->ov_left;
 
 	/* let's advance progress step marks only for every other megabyte */
-	if ((mdev->ov_left & 0x200) == 0x200)
-		drbd_advance_rs_marks(mdev, mdev->ov_left);
+	if ((device->ov_left & 0x200) == 0x200)
+		drbd_advance_rs_marks(device, device->ov_left);
 
-	stop_sector_reached = verify_can_do_stop_sector(mdev) &&
-		(sector + (size>>9)) >= mdev->ov_stop_sector;
+	stop_sector_reached = verify_can_do_stop_sector(device) &&
+		(sector + (size>>9)) >= device->ov_stop_sector;
 
-	if (mdev->ov_left == 0 || stop_sector_reached) {
-		ov_out_of_sync_print(mdev);
-		drbd_resync_finished(mdev);
+	if (device->ov_left == 0 || stop_sector_reached) {
+		ov_out_of_sync_print(device);
+		drbd_resync_finished(device);
 	}
 
 	return err;
@@ -1292,15 +1292,15 @@ int drbd_send_barrier(struct drbd_tconn *tconn)
 
 int w_send_write_hint(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 	struct drbd_socket *sock;
 
 	if (cancel)
 		return 0;
-	sock = &mdev->tconn->data;
-	if (!drbd_prepare_command(mdev, sock))
+	sock = &device->tconn->data;
+	if (!drbd_prepare_command(device, sock))
 		return -EIO;
-	return drbd_send_command(mdev, sock, P_UNPLUG_REMOTE, 0, NULL, 0);
+	return drbd_send_command(device, sock, P_UNPLUG_REMOTE, 0, NULL, 0);
 }
 
 static void re_init_if_first_write(struct drbd_tconn *tconn, unsigned int epoch)
@@ -1327,8 +1327,8 @@ static void maybe_send_barrier(struct drbd_tconn *tconn, unsigned int epoch)
 int w_send_out_of_sync(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
-	struct drbd_device *mdev = w->mdev;
-	struct drbd_tconn *tconn = mdev->tconn;
+	struct drbd_device *device = w->device;
+	struct drbd_tconn *tconn = device->tconn;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1342,7 +1342,7 @@ int w_send_out_of_sync(struct drbd_work *w, int cancel)
 	 * No more barriers will be sent, until we leave AHEAD mode again. */
 	maybe_send_barrier(tconn, req->epoch);
 
-	err = drbd_send_out_of_sync(mdev, req);
+	err = drbd_send_out_of_sync(device, req);
 	req_mod(req, OOS_HANDED_TO_NETWORK);
 
 	return err;
@@ -1350,15 +1350,15 @@ int w_send_out_of_sync(struct drbd_work *w, int cancel)
 
 /**
  * w_send_dblock() - Worker callback to send a P_DATA packet in order to mirror a write request
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
 int w_send_dblock(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
-	struct drbd_device *mdev = w->mdev;
-	struct drbd_tconn *tconn = mdev->tconn;
+	struct drbd_device *device = w->device;
+	struct drbd_tconn *tconn = device->tconn;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1370,7 +1370,7 @@ int w_send_dblock(struct drbd_work *w, int cancel)
 	maybe_send_barrier(tconn, req->epoch);
 	tconn->send.current_epoch_writes++;
 
-	err = drbd_send_dblock(mdev, req);
+	err = drbd_send_dblock(device, req);
 	req_mod(req, err ? SEND_FAILED : HANDED_OVER_TO_NETWORK);
 
 	return err;
@@ -1378,15 +1378,15 @@ int w_send_dblock(struct drbd_work *w, int cancel)
 
 /**
  * w_send_read_req() - Worker callback to send a read request (P_DATA_REQUEST) packet
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @w:		work object.
  * @cancel:	The connection will be closed anyways
  */
 int w_send_read_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
-	struct drbd_device *mdev = w->mdev;
-	struct drbd_tconn *tconn = mdev->tconn;
+	struct drbd_device *device = w->device;
+	struct drbd_tconn *tconn = device->tconn;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1398,7 +1398,7 @@ int w_send_read_req(struct drbd_work *w, int cancel)
 	 * if there was any yet. */
 	maybe_send_barrier(tconn, req->epoch);
 
-	err = drbd_send_drequest(mdev, P_DATA_REQUEST, req->i.sector, req->i.size,
+	err = drbd_send_drequest(device, P_DATA_REQUEST, req->i.sector, req->i.size,
 				 (unsigned long)req);
 
 	req_mod(req, err ? SEND_FAILED : HANDED_OVER_TO_NETWORK);
@@ -1409,21 +1409,21 @@ int w_send_read_req(struct drbd_work *w, int cancel)
 int w_restart_disk_io(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 
 	if (bio_data_dir(req->master_bio) == WRITE && req->rq_state & RQ_IN_ACT_LOG)
-		drbd_al_begin_io(mdev, &req->i, false);
+		drbd_al_begin_io(device, &req->i, false);
 
 	drbd_req_make_private_bio(req, req->master_bio);
-	req->private_bio->bi_bdev = mdev->ldev->backing_bdev;
+	req->private_bio->bi_bdev = device->ldev->backing_bdev;
 	generic_make_request(req->private_bio);
 
 	return 0;
 }
 
-static int _drbd_may_sync_now(struct drbd_device *mdev)
+static int _drbd_may_sync_now(struct drbd_device *device)
 {
-	struct drbd_device *odev = mdev;
+	struct drbd_device *odev = device;
 	int resync_after;
 
 	while (1) {
@@ -1434,7 +1434,7 @@ static int _drbd_may_sync_now(struct drbd_device *mdev)
 		rcu_read_unlock();
 		if (resync_after == -1)
 			return 1;
-		odev = minor_to_mdev(resync_after);
+		odev = minor_to_device(resync_after);
 		if (!odev)
 			return 1;
 		if ((odev->state.conn >= C_SYNC_SOURCE &&
@@ -1447,11 +1447,11 @@ static int _drbd_may_sync_now(struct drbd_device *mdev)
 
 /**
  * _drbd_pause_after() - Pause resync on all devices that may not resync now
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Called from process context only (admin command and after_state_ch).
  */
-static int _drbd_pause_after(struct drbd_device *mdev)
+static int _drbd_pause_after(struct drbd_device *device)
 {
 	struct drbd_device *odev;
 	int i, rv = 0;
@@ -1471,11 +1471,11 @@ static int _drbd_pause_after(struct drbd_device *mdev)
 
 /**
  * _drbd_resume_next() - Resume resync on all devices that may resync now
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  *
  * Called from process context only (admin command and worker).
  */
-static int _drbd_resume_next(struct drbd_device *mdev)
+static int _drbd_resume_next(struct drbd_device *device)
 {
 	struct drbd_device *odev;
 	int i, rv = 0;
@@ -1495,22 +1495,22 @@ static int _drbd_resume_next(struct drbd_device *mdev)
 	return rv;
 }
 
-void resume_next_sg(struct drbd_device *mdev)
+void resume_next_sg(struct drbd_device *device)
 {
 	write_lock_irq(&global_state_lock);
-	_drbd_resume_next(mdev);
+	_drbd_resume_next(device);
 	write_unlock_irq(&global_state_lock);
 }
 
-void suspend_other_sg(struct drbd_device *mdev)
+void suspend_other_sg(struct drbd_device *device)
 {
 	write_lock_irq(&global_state_lock);
-	_drbd_pause_after(mdev);
+	_drbd_pause_after(device);
 	write_unlock_irq(&global_state_lock);
 }
 
 /* caller must hold global_state_lock */
-enum drbd_ret_code drbd_resync_after_valid(struct drbd_device *mdev, int o_minor)
+enum drbd_ret_code drbd_resync_after_valid(struct drbd_device *device, int o_minor)
 {
 	struct drbd_device *odev;
 	int resync_after;
@@ -1521,9 +1521,9 @@ enum drbd_ret_code drbd_resync_after_valid(struct drbd_device *mdev, int o_minor
 		return ERR_RESYNC_AFTER;
 
 	/* check for loops */
-	odev = minor_to_mdev(o_minor);
+	odev = minor_to_device(o_minor);
 	while (1) {
-		if (odev == mdev)
+		if (odev == device)
 			return ERR_RESYNC_AFTER_CYCLE;
 
 		/* You are free to depend on diskless, non-existing,
@@ -1543,35 +1543,35 @@ enum drbd_ret_code drbd_resync_after_valid(struct drbd_device *mdev, int o_minor
 			return NO_ERROR;
 
 		/* follow the dependency chain */
-		odev = minor_to_mdev(resync_after);
+		odev = minor_to_device(resync_after);
 	}
 }
 
 /* caller must hold global_state_lock */
-void drbd_resync_after_changed(struct drbd_device *mdev)
+void drbd_resync_after_changed(struct drbd_device *device)
 {
 	int changes;
 
 	do {
-		changes  = _drbd_pause_after(mdev);
-		changes |= _drbd_resume_next(mdev);
+		changes  = _drbd_pause_after(device);
+		changes |= _drbd_resume_next(device);
 	} while (changes);
 }
 
-void drbd_rs_controller_reset(struct drbd_device *mdev)
+void drbd_rs_controller_reset(struct drbd_device *device)
 {
 	struct fifo_buffer *plan;
 
-	atomic_set(&mdev->rs_sect_in, 0);
-	atomic_set(&mdev->rs_sect_ev, 0);
-	mdev->rs_in_flight = 0;
+	atomic_set(&device->rs_sect_in, 0);
+	atomic_set(&device->rs_sect_ev, 0);
+	device->rs_in_flight = 0;
 
 	/* Updating the RCU protected object in place is necessary since
 	   this function gets called from atomic context.
 	   It is valid since all other updates also lead to an completely
 	   empty fifo */
 	rcu_read_lock();
-	plan = rcu_dereference(mdev->rs_plan_s);
+	plan = rcu_dereference(device->rs_plan_s);
 	plan->total = 0;
 	fifo_set(plan, 0);
 	rcu_read_unlock();
@@ -1579,60 +1579,60 @@ void drbd_rs_controller_reset(struct drbd_device *mdev)
 
 void start_resync_timer_fn(unsigned long data)
 {
-	struct drbd_device *mdev = (struct drbd_device *) data;
+	struct drbd_device *device = (struct drbd_device *) data;
 
-	drbd_queue_work(&mdev->tconn->sender_work, &mdev->start_resync_work);
+	drbd_queue_work(&device->tconn->sender_work, &device->start_resync_work);
 }
 
 int w_start_resync(struct drbd_work *w, int cancel)
 {
-	struct drbd_device *mdev = w->mdev;
+	struct drbd_device *device = w->device;
 
-	if (atomic_read(&mdev->unacked_cnt) || atomic_read(&mdev->rs_pending_cnt)) {
+	if (atomic_read(&device->unacked_cnt) || atomic_read(&device->rs_pending_cnt)) {
 		dev_warn(DEV, "w_start_resync later...\n");
-		mdev->start_resync_timer.expires = jiffies + HZ/10;
-		add_timer(&mdev->start_resync_timer);
+		device->start_resync_timer.expires = jiffies + HZ/10;
+		add_timer(&device->start_resync_timer);
 		return 0;
 	}
 
-	drbd_start_resync(mdev, C_SYNC_SOURCE);
-	clear_bit(AHEAD_TO_SYNC_SOURCE, &mdev->flags);
+	drbd_start_resync(device, C_SYNC_SOURCE);
+	clear_bit(AHEAD_TO_SYNC_SOURCE, &device->flags);
 	return 0;
 }
 
 /**
  * drbd_start_resync() - Start the resync process
- * @mdev:	DRBD device.
+ * @device:	DRBD device.
  * @side:	Either C_SYNC_SOURCE or C_SYNC_TARGET
  *
  * This function might bring you directly into one of the
  * C_PAUSED_SYNC_* states.
  */
-void drbd_start_resync(struct drbd_device *mdev, enum drbd_conns side)
+void drbd_start_resync(struct drbd_device *device, enum drbd_conns side)
 {
 	union drbd_state ns;
 	int r;
 
-	if (mdev->state.conn >= C_SYNC_SOURCE && mdev->state.conn < C_AHEAD) {
+	if (device->state.conn >= C_SYNC_SOURCE && device->state.conn < C_AHEAD) {
 		dev_err(DEV, "Resync already running!\n");
 		return;
 	}
 
-	if (!test_bit(B_RS_H_DONE, &mdev->flags)) {
+	if (!test_bit(B_RS_H_DONE, &device->flags)) {
 		if (side == C_SYNC_TARGET) {
 			/* Since application IO was locked out during C_WF_BITMAP_T and
 			   C_WF_SYNC_UUID we are still unmodified. Before going to C_SYNC_TARGET
 			   we check that we might make the data inconsistent. */
-			r = drbd_khelper(mdev, "before-resync-target");
+			r = drbd_khelper(device, "before-resync-target");
 			r = (r >> 8) & 0xff;
 			if (r > 0) {
 				dev_info(DEV, "before-resync-target handler returned %d, "
 					 "dropping connection.\n", r);
-				conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+				conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 				return;
 			}
 		} else /* C_SYNC_SOURCE */ {
-			r = drbd_khelper(mdev, "before-resync-source");
+			r = drbd_khelper(device, "before-resync-source");
 			r = (r >> 8) & 0xff;
 			if (r > 0) {
 				if (r == 3) {
@@ -1641,39 +1641,39 @@ void drbd_start_resync(struct drbd_device *mdev, enum drbd_conns side)
 				} else {
 					dev_info(DEV, "before-resync-source handler returned %d, "
 						 "dropping connection.\n", r);
-					conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+					conn_request_state(device->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 					return;
 				}
 			}
 		}
 	}
 
-	if (current == mdev->tconn->worker.task) {
+	if (current == device->tconn->worker.task) {
 		/* The worker should not sleep waiting for state_mutex,
 		   that can take long */
-		if (!mutex_trylock(mdev->state_mutex)) {
-			set_bit(B_RS_H_DONE, &mdev->flags);
-			mdev->start_resync_timer.expires = jiffies + HZ/5;
-			add_timer(&mdev->start_resync_timer);
+		if (!mutex_trylock(device->state_mutex)) {
+			set_bit(B_RS_H_DONE, &device->flags);
+			device->start_resync_timer.expires = jiffies + HZ/5;
+			add_timer(&device->start_resync_timer);
 			return;
 		}
 	} else {
-		mutex_lock(mdev->state_mutex);
+		mutex_lock(device->state_mutex);
 	}
-	clear_bit(B_RS_H_DONE, &mdev->flags);
+	clear_bit(B_RS_H_DONE, &device->flags);
 
 	write_lock_irq(&global_state_lock);
 	/* Did some connection breakage or IO error race with us? */
-	if (mdev->state.conn < C_CONNECTED
-	|| !get_ldev_if_state(mdev, D_NEGOTIATING)) {
+	if (device->state.conn < C_CONNECTED
+	|| !get_ldev_if_state(device, D_NEGOTIATING)) {
 		write_unlock_irq(&global_state_lock);
-		mutex_unlock(mdev->state_mutex);
+		mutex_unlock(device->state_mutex);
 		return;
 	}
 
-	ns = drbd_read_state(mdev);
+	ns = drbd_read_state(device);
 
-	ns.aftr_isp = !_drbd_may_sync_now(mdev);
+	ns.aftr_isp = !_drbd_may_sync_now(device);
 
 	ns.conn = side;
 
@@ -1682,43 +1682,43 @@ void drbd_start_resync(struct drbd_device *mdev, enum drbd_conns side)
 	else /* side == C_SYNC_SOURCE */
 		ns.pdsk = D_INCONSISTENT;
 
-	r = __drbd_set_state(mdev, ns, CS_VERBOSE, NULL);
-	ns = drbd_read_state(mdev);
+	r = __drbd_set_state(device, ns, CS_VERBOSE, NULL);
+	ns = drbd_read_state(device);
 
 	if (ns.conn < C_CONNECTED)
 		r = SS_UNKNOWN_ERROR;
 
 	if (r == SS_SUCCESS) {
-		unsigned long tw = drbd_bm_total_weight(mdev);
+		unsigned long tw = drbd_bm_total_weight(device);
 		unsigned long now = jiffies;
 		int i;
 
-		mdev->rs_failed    = 0;
-		mdev->rs_paused    = 0;
-		mdev->rs_same_csum = 0;
-		mdev->rs_last_events = 0;
-		mdev->rs_last_sect_ev = 0;
-		mdev->rs_total     = tw;
-		mdev->rs_start     = now;
+		device->rs_failed    = 0;
+		device->rs_paused    = 0;
+		device->rs_same_csum = 0;
+		device->rs_last_events = 0;
+		device->rs_last_sect_ev = 0;
+		device->rs_total     = tw;
+		device->rs_start     = now;
 		for (i = 0; i < DRBD_SYNC_MARKS; i++) {
-			mdev->rs_mark_left[i] = tw;
-			mdev->rs_mark_time[i] = now;
+			device->rs_mark_left[i] = tw;
+			device->rs_mark_time[i] = now;
 		}
-		_drbd_pause_after(mdev);
+		_drbd_pause_after(device);
 	}
 	write_unlock_irq(&global_state_lock);
 
 	if (r == SS_SUCCESS) {
 		/* reset rs_last_bcast when a resync or verify is started,
 		 * to deal with potential jiffies wrap. */
-		mdev->rs_last_bcast = jiffies - HZ;
+		device->rs_last_bcast = jiffies - HZ;
 
 		dev_info(DEV, "Began resync as %s (will sync %lu KB [%lu bits set]).\n",
 		     drbd_conn_str(ns.conn),
-		     (unsigned long) mdev->rs_total << (BM_BLOCK_SHIFT-10),
-		     (unsigned long) mdev->rs_total);
+		     (unsigned long) device->rs_total << (BM_BLOCK_SHIFT-10),
+		     (unsigned long) device->rs_total);
 		if (side == C_SYNC_TARGET)
-			mdev->bm_resync_fo = 0;
+			device->bm_resync_fo = 0;
 
 		/* Since protocol 96, we must serialize drbd_gen_and_send_sync_uuid
 		 * with w_send_oos, or the sync target will get confused as to
@@ -1727,10 +1727,10 @@ void drbd_start_resync(struct drbd_device *mdev, enum drbd_conns side)
 		 * drbd_resync_finished from here in that case.
 		 * We drbd_gen_and_send_sync_uuid here for protocol < 96,
 		 * and from after_state_ch otherwise. */
-		if (side == C_SYNC_SOURCE && mdev->tconn->agreed_pro_version < 96)
-			drbd_gen_and_send_sync_uuid(mdev);
+		if (side == C_SYNC_SOURCE && device->tconn->agreed_pro_version < 96)
+			drbd_gen_and_send_sync_uuid(device);
 
-		if (mdev->tconn->agreed_pro_version < 95 && mdev->rs_total == 0) {
+		if (device->tconn->agreed_pro_version < 95 && device->rs_total == 0) {
 			/* This still has a race (about when exactly the peers
 			 * detect connection loss) that can lead to a full sync
 			 * on next handshake. In 8.3.9 we fixed this with explicit
@@ -1746,26 +1746,26 @@ void drbd_start_resync(struct drbd_device *mdev, enum drbd_conns side)
 				int timeo;
 
 				rcu_read_lock();
-				nc = rcu_dereference(mdev->tconn->net_conf);
+				nc = rcu_dereference(device->tconn->net_conf);
 				timeo = nc->ping_int * HZ + nc->ping_timeo * HZ / 9;
 				rcu_read_unlock();
 				schedule_timeout_interruptible(timeo);
 			}
-			drbd_resync_finished(mdev);
+			drbd_resync_finished(device);
 		}
 
-		drbd_rs_controller_reset(mdev);
-		/* ns.conn may already be != mdev->state.conn,
+		drbd_rs_controller_reset(device);
+		/* ns.conn may already be != device->state.conn,
 		 * we may have been paused in between, or become paused until
 		 * the timer triggers.
 		 * No matter, that is handled in resync_timer_fn() */
 		if (ns.conn == C_SYNC_TARGET)
-			mod_timer(&mdev->resync_timer, jiffies);
+			mod_timer(&device->resync_timer, jiffies);
 
-		drbd_md_sync(mdev);
+		drbd_md_sync(device);
 	}
-	put_ldev(mdev);
-	mutex_unlock(mdev->state_mutex);
+	put_ldev(device);
+	mutex_unlock(device->state_mutex);
 }
 
 /* If the resource already closed the current epoch, but we did not
@@ -1886,7 +1886,7 @@ int drbd_worker(struct drbd_thread *thi)
 {
 	struct drbd_tconn *tconn = thi->tconn;
 	struct drbd_work *w = NULL;
-	struct drbd_device *mdev;
+	struct drbd_device *device;
 	LIST_HEAD(work_list);
 	int vnr;
 
@@ -1930,12 +1930,12 @@ int drbd_worker(struct drbd_thread *thi)
 	} while (!list_empty(&work_list));
 
 	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		D_ASSERT(mdev->state.disk == D_DISKLESS && mdev->state.conn == C_STANDALONE);
-		kref_get(&mdev->kref);
+	idr_for_each_entry(&tconn->volumes, device, vnr) {
+		D_ASSERT(device->state.disk == D_DISKLESS && device->state.conn == C_STANDALONE);
+		kref_get(&device->kref);
 		rcu_read_unlock();
-		drbd_mdev_cleanup(mdev);
-		kref_put(&mdev->kref, &drbd_minor_destroy);
+		drbd_device_cleanup(device);
+		kref_put(&device->kref, &drbd_minor_destroy);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
diff --git a/drivers/block/drbd/drbd_wrappers.h b/drivers/block/drbd/drbd_wrappers.h
index ee6362a..3db9eba 100644
--- a/drivers/block/drbd/drbd_wrappers.h
+++ b/drivers/block/drbd/drbd_wrappers.h
@@ -9,12 +9,12 @@
 extern char *drbd_sec_holder;
 
 /* sets the number of 512 byte sectors of our virtual device */
-static inline void drbd_set_my_capacity(struct drbd_device *mdev,
+static inline void drbd_set_my_capacity(struct drbd_device *device,
 					sector_t size)
 {
-	/* set_capacity(mdev->this_bdev->bd_disk, size); */
-	set_capacity(mdev->vdisk, size);
-	mdev->this_bdev->bd_inode->i_size = (loff_t)size << 9;
+	/* set_capacity(device->this_bdev->bd_disk, size); */
+	set_capacity(device->vdisk, size);
+	device->this_bdev->bd_inode->i_size = (loff_t)size << 9;
 }
 
 #define drbd_bio_uptodate(bio) bio_flagged(bio, BIO_UPTODATE)
@@ -27,20 +27,20 @@ extern void drbd_request_endio(struct bio *bio, int error);
 /*
  * used to submit our private bio
  */
-static inline void drbd_generic_make_request(struct drbd_device *mdev,
+static inline void drbd_generic_make_request(struct drbd_device *device,
 					     int fault_type, struct bio *bio)
 {
 	__release(local);
 	if (!bio->bi_bdev) {
 		printk(KERN_ERR "drbd%d: drbd_generic_make_request: "
 				"bio->bi_bdev == NULL\n",
-		       mdev_to_minor(mdev));
+		       device_to_minor(device));
 		dump_stack();
 		bio_endio(bio, -ENODEV);
 		return;
 	}
 
-	if (drbd_insert_fault(mdev, fault_type))
+	if (drbd_insert_fault(device, fault_type))
 		bio_endio(bio, -EIO);
 	else
 		generic_make_request(bio);
-- 
1.7.9.5

