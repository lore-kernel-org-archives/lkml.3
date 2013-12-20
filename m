Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab3LTMqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:46:06 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38620 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab3LTMjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:25 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/26] drbd: Rename struct drbd_conf -> struct drbd_device
Date: Fri, 20 Dec 2013 13:29:02 +0100
Message-Id: <1387542563-6833-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

sed -i -e 's:\<drbd_conf\>:drbd_device:g'

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |   68 +++----
 drivers/block/drbd/drbd_bitmap.c   |   88 ++++-----
 drivers/block/drbd/drbd_int.h      |  344 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_main.c     |  158 ++++++++---------
 drivers/block/drbd/drbd_nl.c       |   68 +++----
 drivers/block/drbd/drbd_proc.c     |    4 +-
 drivers/block/drbd/drbd_receiver.c |  140 +++++++--------
 drivers/block/drbd/drbd_req.c      |   58 +++---
 drivers/block/drbd/drbd_req.h      |    6 +-
 drivers/block/drbd/drbd_state.c    |   74 ++++----
 drivers/block/drbd/drbd_state.h    |   16 +-
 drivers/block/drbd/drbd_worker.c   |   96 +++++-----
 drivers/block/drbd/drbd_wrappers.h |    4 +-
 13 files changed, 562 insertions(+), 562 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index a9b13f2..d5f1188 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -105,7 +105,7 @@ struct update_al_work {
 };
 
 
-void *drbd_md_get_buffer(struct drbd_conf *mdev)
+void *drbd_md_get_buffer(struct drbd_device *mdev)
 {
 	int r;
 
@@ -116,13 +116,13 @@ void *drbd_md_get_buffer(struct drbd_conf *mdev)
 	return r ? NULL : page_address(mdev->md_io_page);
 }
 
-void drbd_md_put_buffer(struct drbd_conf *mdev)
+void drbd_md_put_buffer(struct drbd_device *mdev)
 {
 	if (atomic_dec_and_test(&mdev->md_io_in_use))
 		wake_up(&mdev->misc_wait);
 }
 
-void wait_until_done_or_force_detached(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
+void wait_until_done_or_force_detached(struct drbd_device *mdev, struct drbd_backing_dev *bdev,
 				     unsigned int *done)
 {
 	long dt;
@@ -142,7 +142,7 @@ void wait_until_done_or_force_detached(struct drbd_conf *mdev, struct drbd_backi
 	}
 }
 
-static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
+static int _drbd_md_sync_page_io(struct drbd_device *mdev,
 				 struct drbd_backing_dev *bdev,
 				 struct page *page, sector_t sector,
 				 int rw, int size)
@@ -192,7 +192,7 @@ static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 	return err;
 }
 
-int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
+int drbd_md_sync_page_io(struct drbd_device *mdev, struct drbd_backing_dev *bdev,
 			 sector_t sector, int rw)
 {
 	int err;
@@ -222,7 +222,7 @@ int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
 	return err;
 }
 
-static struct bm_extent *find_active_resync_extent(struct drbd_conf *mdev, unsigned int enr)
+static struct bm_extent *find_active_resync_extent(struct drbd_device *mdev, unsigned int enr)
 {
 	struct lc_element *tmp;
 	tmp = lc_find(mdev->resync, enr/AL_EXT_PER_BM_SECT);
@@ -234,7 +234,7 @@ static struct bm_extent *find_active_resync_extent(struct drbd_conf *mdev, unsig
 	return NULL;
 }
 
-static struct lc_element *_al_get(struct drbd_conf *mdev, unsigned int enr, bool nonblock)
+static struct lc_element *_al_get(struct drbd_device *mdev, unsigned int enr, bool nonblock)
 {
 	struct lc_element *al_ext;
 	struct bm_extent *bm_ext;
@@ -257,7 +257,7 @@ static struct lc_element *_al_get(struct drbd_conf *mdev, unsigned int enr, bool
 	return al_ext;
 }
 
-bool drbd_al_begin_io_fastpath(struct drbd_conf *mdev, struct drbd_interval *i)
+bool drbd_al_begin_io_fastpath(struct drbd_device *mdev, struct drbd_interval *i)
 {
 	/* for bios crossing activity log extent boundaries,
 	 * we may need to activate two extents in one go */
@@ -274,7 +274,7 @@ bool drbd_al_begin_io_fastpath(struct drbd_conf *mdev, struct drbd_interval *i)
 	return _al_get(mdev, first, true);
 }
 
-bool drbd_al_begin_io_prepare(struct drbd_conf *mdev, struct drbd_interval *i)
+bool drbd_al_begin_io_prepare(struct drbd_device *mdev, struct drbd_interval *i)
 {
 	/* for bios crossing activity log extent boundaries,
 	 * we may need to activate two extents in one go */
@@ -296,7 +296,7 @@ bool drbd_al_begin_io_prepare(struct drbd_conf *mdev, struct drbd_interval *i)
 	return need_transaction;
 }
 
-static int al_write_transaction(struct drbd_conf *mdev, bool delegate);
+static int al_write_transaction(struct drbd_device *mdev, bool delegate);
 
 /* When called through generic_make_request(), we must delegate
  * activity log I/O to the worker thread: a further request
@@ -310,7 +310,7 @@ static int al_write_transaction(struct drbd_conf *mdev, bool delegate);
 /*
  * @delegate:   delegate activity log I/O to the worker thread
  */
-void drbd_al_begin_io_commit(struct drbd_conf *mdev, bool delegate)
+void drbd_al_begin_io_commit(struct drbd_device *mdev, bool delegate)
 {
 	bool locked = false;
 
@@ -351,7 +351,7 @@ void drbd_al_begin_io_commit(struct drbd_conf *mdev, bool delegate)
 /*
  * @delegate:   delegate activity log I/O to the worker thread
  */
-void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool delegate)
+void drbd_al_begin_io(struct drbd_device *mdev, struct drbd_interval *i, bool delegate)
 {
 	BUG_ON(delegate && current == mdev->tconn->worker.task);
 
@@ -359,7 +359,7 @@ void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool dele
 		drbd_al_begin_io_commit(mdev, delegate);
 }
 
-int drbd_al_begin_io_nonblock(struct drbd_conf *mdev, struct drbd_interval *i)
+int drbd_al_begin_io_nonblock(struct drbd_device *mdev, struct drbd_interval *i)
 {
 	struct lru_cache *al = mdev->act_log;
 	/* for bios crossing activity log extent boundaries,
@@ -408,7 +408,7 @@ int drbd_al_begin_io_nonblock(struct drbd_conf *mdev, struct drbd_interval *i)
 	return 0;
 }
 
-void drbd_al_complete_io(struct drbd_conf *mdev, struct drbd_interval *i)
+void drbd_al_complete_io(struct drbd_device *mdev, struct drbd_interval *i)
 {
 	/* for bios crossing activity log extent boundaries,
 	 * we may need to activate two extents in one go */
@@ -460,7 +460,7 @@ static unsigned int rs_extent_to_bm_page(unsigned int rs_enr)
 		 (BM_EXT_SHIFT - BM_BLOCK_SHIFT));
 }
 
-static sector_t al_tr_number_to_on_disk_sector(struct drbd_conf *mdev)
+static sector_t al_tr_number_to_on_disk_sector(struct drbd_device *mdev)
 {
 	const unsigned int stripes = mdev->ldev->md.al_stripes;
 	const unsigned int stripe_size_4kB = mdev->ldev->md.al_stripe_size_4k;
@@ -479,7 +479,7 @@ static sector_t al_tr_number_to_on_disk_sector(struct drbd_conf *mdev)
 }
 
 static int
-_al_write_transaction(struct drbd_conf *mdev)
+_al_write_transaction(struct drbd_device *mdev)
 {
 	struct al_transaction_on_disk *buffer;
 	struct lc_element *e;
@@ -593,7 +593,7 @@ _al_write_transaction(struct drbd_conf *mdev)
 static int w_al_write_transaction(struct drbd_work *w, int unused)
 {
 	struct update_al_work *aw = container_of(w, struct update_al_work, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	int err;
 
 	err = _al_write_transaction(mdev);
@@ -606,7 +606,7 @@ static int w_al_write_transaction(struct drbd_work *w, int unused)
 /* Calls from worker context (see w_restart_disk_io()) need to write the
    transaction directly. Others came through generic_make_request(),
    those need to delegate it to the worker. */
-static int al_write_transaction(struct drbd_conf *mdev, bool delegate)
+static int al_write_transaction(struct drbd_device *mdev, bool delegate)
 {
 	if (delegate) {
 		struct update_al_work al_work;
@@ -620,7 +620,7 @@ static int al_write_transaction(struct drbd_conf *mdev, bool delegate)
 		return _al_write_transaction(mdev);
 }
 
-static int _try_lc_del(struct drbd_conf *mdev, struct lc_element *al_ext)
+static int _try_lc_del(struct drbd_device *mdev, struct lc_element *al_ext)
 {
 	int rv;
 
@@ -642,7 +642,7 @@ static int _try_lc_del(struct drbd_conf *mdev, struct lc_element *al_ext)
  *
  * You need to lock mdev->act_log with lc_try_lock() / lc_unlock()
  */
-void drbd_al_shrink(struct drbd_conf *mdev)
+void drbd_al_shrink(struct drbd_device *mdev)
 {
 	struct lc_element *al_ext;
 	int i;
@@ -659,7 +659,7 @@ void drbd_al_shrink(struct drbd_conf *mdev)
 	wake_up(&mdev->al_wait);
 }
 
-int drbd_initialize_al(struct drbd_conf *mdev, void *buffer)
+int drbd_initialize_al(struct drbd_device *mdev, void *buffer)
 {
 	struct al_transaction_on_disk *al = buffer;
 	struct drbd_md *md = &mdev->ldev->md;
@@ -683,7 +683,7 @@ int drbd_initialize_al(struct drbd_conf *mdev, void *buffer)
 static int w_update_odbm(struct drbd_work *w, int unused)
 {
 	struct update_odbm_work *udw = container_of(w, struct update_odbm_work, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	struct sib_info sib = { .sib_reason = SIB_SYNC_PROGRESS, };
 
 	if (!get_ldev(mdev)) {
@@ -720,7 +720,7 @@ static int w_update_odbm(struct drbd_work *w, int unused)
  *
  * TODO will be obsoleted once we have a caching lru of the on disk bitmap
  */
-static void drbd_try_clear_on_disk_bm(struct drbd_conf *mdev, sector_t sector,
+static void drbd_try_clear_on_disk_bm(struct drbd_device *mdev, sector_t sector,
 				      int count, int success)
 {
 	struct lc_element *e;
@@ -808,7 +808,7 @@ static void drbd_try_clear_on_disk_bm(struct drbd_conf *mdev, sector_t sector,
 	}
 }
 
-void drbd_advance_rs_marks(struct drbd_conf *mdev, unsigned long still_to_go)
+void drbd_advance_rs_marks(struct drbd_device *mdev, unsigned long still_to_go)
 {
 	unsigned long now = jiffies;
 	unsigned long last = mdev->rs_mark_time[mdev->rs_last_mark];
@@ -831,7 +831,7 @@ void drbd_advance_rs_marks(struct drbd_conf *mdev, unsigned long still_to_go)
  * called by worker on C_SYNC_TARGET and receiver on SyncSource.
  *
  */
-void __drbd_set_in_sync(struct drbd_conf *mdev, sector_t sector, int size,
+void __drbd_set_in_sync(struct drbd_device *mdev, sector_t sector, int size,
 		       const char *file, const unsigned int line)
 {
 	/* Is called from worker and receiver context _only_ */
@@ -903,7 +903,7 @@ out:
  * called by tl_clear and drbd_send_dblock (==drbd_make_request).
  * so this can be _any_ process.
  */
-int __drbd_set_out_of_sync(struct drbd_conf *mdev, sector_t sector, int size,
+int __drbd_set_out_of_sync(struct drbd_device *mdev, sector_t sector, int size,
 			    const char *file, const unsigned int line)
 {
 	unsigned long sbnr, ebnr, flags;
@@ -955,7 +955,7 @@ out:
 }
 
 static
-struct bm_extent *_bme_get(struct drbd_conf *mdev, unsigned int enr)
+struct bm_extent *_bme_get(struct drbd_device *mdev, unsigned int enr)
 {
 	struct lc_element *e;
 	struct bm_extent *bm_ext;
@@ -995,7 +995,7 @@ struct bm_extent *_bme_get(struct drbd_conf *mdev, unsigned int enr)
 	return bm_ext;
 }
 
-static int _is_in_al(struct drbd_conf *mdev, unsigned int enr)
+static int _is_in_al(struct drbd_device *mdev, unsigned int enr)
 {
 	int rv;
 
@@ -1013,7 +1013,7 @@ static int _is_in_al(struct drbd_conf *mdev, unsigned int enr)
  *
  * This functions sleeps on al_wait. Returns 0 on success, -EINTR if interrupted.
  */
-int drbd_rs_begin_io(struct drbd_conf *mdev, sector_t sector)
+int drbd_rs_begin_io(struct drbd_device *mdev, sector_t sector)
 {
 	unsigned int enr = BM_SECT_TO_EXT(sector);
 	struct bm_extent *bm_ext;
@@ -1066,7 +1066,7 @@ retry:
  * tries to set it to BME_LOCKED. Returns 0 upon success, and -EAGAIN
  * if there is still application IO going on in this area.
  */
-int drbd_try_rs_begin_io(struct drbd_conf *mdev, sector_t sector)
+int drbd_try_rs_begin_io(struct drbd_device *mdev, sector_t sector)
 {
 	unsigned int enr = BM_SECT_TO_EXT(sector);
 	const unsigned int al_enr = enr*AL_EXT_PER_BM_SECT;
@@ -1165,7 +1165,7 @@ try_again:
 	return -EAGAIN;
 }
 
-void drbd_rs_complete_io(struct drbd_conf *mdev, sector_t sector)
+void drbd_rs_complete_io(struct drbd_device *mdev, sector_t sector)
 {
 	unsigned int enr = BM_SECT_TO_EXT(sector);
 	struct lc_element *e;
@@ -1203,7 +1203,7 @@ void drbd_rs_complete_io(struct drbd_conf *mdev, sector_t sector)
  * drbd_rs_cancel_all() - Removes all extents from the resync LRU (even BME_LOCKED)
  * @mdev:	DRBD device.
  */
-void drbd_rs_cancel_all(struct drbd_conf *mdev)
+void drbd_rs_cancel_all(struct drbd_device *mdev)
 {
 	spin_lock_irq(&mdev->al_lock);
 
@@ -1224,7 +1224,7 @@ void drbd_rs_cancel_all(struct drbd_conf *mdev)
  * Returns 0 upon success, -EAGAIN if at least one reference count was
  * not zero.
  */
-int drbd_rs_del_all(struct drbd_conf *mdev)
+int drbd_rs_del_all(struct drbd_device *mdev)
 {
 	struct lc_element *e;
 	struct bm_extent *bm_ext;
@@ -1275,7 +1275,7 @@ int drbd_rs_del_all(struct drbd_conf *mdev)
  * @sector:	The sector number.
  * @size:	Size of failed IO operation, in byte.
  */
-void drbd_rs_failed_io(struct drbd_conf *mdev, sector_t sector, int size)
+void drbd_rs_failed_io(struct drbd_device *mdev, sector_t sector, int size)
 {
 	/* Is called from worker and receiver context _only_ */
 	unsigned long sbnr, ebnr, lbnr;
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 597f111..1287993 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -113,7 +113,7 @@ struct drbd_bitmap {
 };
 
 #define bm_print_lock_info(m) __bm_print_lock_info(m, __func__)
-static void __bm_print_lock_info(struct drbd_conf *mdev, const char *func)
+static void __bm_print_lock_info(struct drbd_device *mdev, const char *func)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	if (!__ratelimit(&drbd_ratelimit_state))
@@ -124,7 +124,7 @@ static void __bm_print_lock_info(struct drbd_conf *mdev, const char *func)
 		drbd_task_to_thread_name(mdev->tconn, b->bm_task));
 }
 
-void drbd_bm_lock(struct drbd_conf *mdev, char *why, enum bm_flag flags)
+void drbd_bm_lock(struct drbd_device *mdev, char *why, enum bm_flag flags)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	int trylock_failed;
@@ -151,7 +151,7 @@ void drbd_bm_lock(struct drbd_conf *mdev, char *why, enum bm_flag flags)
 	b->bm_task = current;
 }
 
-void drbd_bm_unlock(struct drbd_conf *mdev)
+void drbd_bm_unlock(struct drbd_device *mdev)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	if (!b) {
@@ -211,14 +211,14 @@ static unsigned long bm_page_to_idx(struct page *page)
 /* As is very unlikely that the same page is under IO from more than one
  * context, we can get away with a bit per page and one wait queue per bitmap.
  */
-static void bm_page_lock_io(struct drbd_conf *mdev, int page_nr)
+static void bm_page_lock_io(struct drbd_device *mdev, int page_nr)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	void *addr = &page_private(b->bm_pages[page_nr]);
 	wait_event(b->bm_io_wait, !test_and_set_bit(BM_PAGE_IO_LOCK, addr));
 }
 
-static void bm_page_unlock_io(struct drbd_conf *mdev, int page_nr)
+static void bm_page_unlock_io(struct drbd_device *mdev, int page_nr)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	void *addr = &page_private(b->bm_pages[page_nr]);
@@ -249,7 +249,7 @@ static void bm_set_page_need_writeout(struct page *page)
  * hints, then call drbd_bm_write_hinted(), which will only write out changed
  * pages which are flagged with this mark.
  */
-void drbd_bm_mark_for_writeout(struct drbd_conf *mdev, int page_nr)
+void drbd_bm_mark_for_writeout(struct drbd_device *mdev, int page_nr)
 {
 	struct page *page;
 	if (page_nr >= mdev->bitmap->bm_number_of_pages) {
@@ -340,7 +340,7 @@ static void bm_unmap(unsigned long *p_addr)
 
 /*
  * actually most functions herein should take a struct drbd_bitmap*, not a
- * struct drbd_conf*, but for the debug macros I like to have the mdev around
+ * struct drbd_device*, but for the debug macros I like to have the mdev around
  * to be able to report device specific.
  */
 
@@ -438,7 +438,7 @@ static struct page **bm_realloc_pages(struct drbd_bitmap *b, unsigned long want)
  * called on driver init only. TODO call when a device is created.
  * allocates the drbd_bitmap, and stores it in mdev->bitmap.
  */
-int drbd_bm_init(struct drbd_conf *mdev)
+int drbd_bm_init(struct drbd_device *mdev)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	WARN_ON(b != NULL);
@@ -454,7 +454,7 @@ int drbd_bm_init(struct drbd_conf *mdev)
 	return 0;
 }
 
-sector_t drbd_bm_capacity(struct drbd_conf *mdev)
+sector_t drbd_bm_capacity(struct drbd_device *mdev)
 {
 	if (!expect(mdev->bitmap))
 		return 0;
@@ -463,7 +463,7 @@ sector_t drbd_bm_capacity(struct drbd_conf *mdev)
 
 /* called on driver unload. TODO: call when a device is destroyed.
  */
-void drbd_bm_cleanup(struct drbd_conf *mdev)
+void drbd_bm_cleanup(struct drbd_device *mdev)
 {
 	if (!expect(mdev->bitmap))
 		return;
@@ -631,7 +631,7 @@ static u64 drbd_md_on_disk_bits(struct drbd_backing_dev *ldev)
  * In case this is actually a resize, we copy the old bitmap into the new one.
  * Otherwise, the bitmap is initialized to all bits set.
  */
-int drbd_bm_resize(struct drbd_conf *mdev, sector_t capacity, int set_new_bits)
+int drbd_bm_resize(struct drbd_device *mdev, sector_t capacity, int set_new_bits)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	unsigned long bits, words, owords, obits;
@@ -757,7 +757,7 @@ int drbd_bm_resize(struct drbd_conf *mdev, sector_t capacity, int set_new_bits)
  *
  * maybe bm_set should be atomic_t ?
  */
-unsigned long _drbd_bm_total_weight(struct drbd_conf *mdev)
+unsigned long _drbd_bm_total_weight(struct drbd_device *mdev)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	unsigned long s;
@@ -775,7 +775,7 @@ unsigned long _drbd_bm_total_weight(struct drbd_conf *mdev)
 	return s;
 }
 
-unsigned long drbd_bm_total_weight(struct drbd_conf *mdev)
+unsigned long drbd_bm_total_weight(struct drbd_device *mdev)
 {
 	unsigned long s;
 	/* if I don't have a disk, I don't know about out-of-sync status */
@@ -786,7 +786,7 @@ unsigned long drbd_bm_total_weight(struct drbd_conf *mdev)
 	return s;
 }
 
-size_t drbd_bm_words(struct drbd_conf *mdev)
+size_t drbd_bm_words(struct drbd_device *mdev)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	if (!expect(b))
@@ -797,7 +797,7 @@ size_t drbd_bm_words(struct drbd_conf *mdev)
 	return b->bm_words;
 }
 
-unsigned long drbd_bm_bits(struct drbd_conf *mdev)
+unsigned long drbd_bm_bits(struct drbd_device *mdev)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	if (!expect(b))
@@ -811,7 +811,7 @@ unsigned long drbd_bm_bits(struct drbd_conf *mdev)
  * bitmap must be locked by drbd_bm_lock.
  * currently only used from receive_bitmap.
  */
-void drbd_bm_merge_lel(struct drbd_conf *mdev, size_t offset, size_t number,
+void drbd_bm_merge_lel(struct drbd_device *mdev, size_t offset, size_t number,
 			unsigned long *buffer)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
@@ -860,7 +860,7 @@ void drbd_bm_merge_lel(struct drbd_conf *mdev, size_t offset, size_t number,
 /* copy number words from the bitmap starting at offset into the buffer.
  * buffer[i] will be little endian unsigned long.
  */
-void drbd_bm_get_lel(struct drbd_conf *mdev, size_t offset, size_t number,
+void drbd_bm_get_lel(struct drbd_device *mdev, size_t offset, size_t number,
 		     unsigned long *buffer)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
@@ -897,7 +897,7 @@ void drbd_bm_get_lel(struct drbd_conf *mdev, size_t offset, size_t number,
 }
 
 /* set all bits in the bitmap */
-void drbd_bm_set_all(struct drbd_conf *mdev)
+void drbd_bm_set_all(struct drbd_device *mdev)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	if (!expect(b))
@@ -913,7 +913,7 @@ void drbd_bm_set_all(struct drbd_conf *mdev)
 }
 
 /* clear all bits in the bitmap */
-void drbd_bm_clear_all(struct drbd_conf *mdev)
+void drbd_bm_clear_all(struct drbd_device *mdev)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	if (!expect(b))
@@ -928,7 +928,7 @@ void drbd_bm_clear_all(struct drbd_conf *mdev)
 }
 
 struct bm_aio_ctx {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	atomic_t in_flight;
 	unsigned int done;
 	unsigned flags;
@@ -951,7 +951,7 @@ static void bm_aio_ctx_destroy(struct kref *kref)
 static void bm_async_io_complete(struct bio *bio, int error)
 {
 	struct bm_aio_ctx *ctx = bio->bi_private;
-	struct drbd_conf *mdev = ctx->mdev;
+	struct drbd_device *mdev = ctx->mdev;
 	struct drbd_bitmap *b = mdev->bitmap;
 	unsigned int idx = bm_page_to_idx(bio->bi_io_vec[0].bv_page);
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
@@ -1000,7 +1000,7 @@ static void bm_async_io_complete(struct bio *bio, int error)
 static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must_hold(local)
 {
 	struct bio *bio = bio_alloc_drbd(GFP_NOIO);
-	struct drbd_conf *mdev = ctx->mdev;
+	struct drbd_device *mdev = ctx->mdev;
 	struct drbd_bitmap *b = mdev->bitmap;
 	struct page *page;
 	unsigned int len;
@@ -1049,7 +1049,7 @@ static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must
 /*
  * bm_rw: read/write the whole bitmap from/to its on disk location.
  */
-static int bm_rw(struct drbd_conf *mdev, int rw, unsigned flags, unsigned lazy_writeout_upper_idx) __must_hold(local)
+static int bm_rw(struct drbd_device *mdev, int rw, unsigned flags, unsigned lazy_writeout_upper_idx) __must_hold(local)
 {
 	struct bm_aio_ctx *ctx;
 	struct drbd_bitmap *b = mdev->bitmap;
@@ -1173,7 +1173,7 @@ static int bm_rw(struct drbd_conf *mdev, int rw, unsigned flags, unsigned lazy_w
  * drbd_bm_read() - Read the whole bitmap from its on disk location.
  * @mdev:	DRBD device.
  */
-int drbd_bm_read(struct drbd_conf *mdev) __must_hold(local)
+int drbd_bm_read(struct drbd_device *mdev) __must_hold(local)
 {
 	return bm_rw(mdev, READ, 0, 0);
 }
@@ -1184,7 +1184,7 @@ int drbd_bm_read(struct drbd_conf *mdev) __must_hold(local)
  *
  * Will only write pages that have changed since last IO.
  */
-int drbd_bm_write(struct drbd_conf *mdev) __must_hold(local)
+int drbd_bm_write(struct drbd_device *mdev) __must_hold(local)
 {
 	return bm_rw(mdev, WRITE, 0, 0);
 }
@@ -1195,7 +1195,7 @@ int drbd_bm_write(struct drbd_conf *mdev) __must_hold(local)
  *
  * Will write all pages.
  */
-int drbd_bm_write_all(struct drbd_conf *mdev) __must_hold(local)
+int drbd_bm_write_all(struct drbd_device *mdev) __must_hold(local)
 {
 	return bm_rw(mdev, WRITE, BM_WRITE_ALL_PAGES, 0);
 }
@@ -1205,7 +1205,7 @@ int drbd_bm_write_all(struct drbd_conf *mdev) __must_hold(local)
  * @mdev:	DRBD device.
  * @upper_idx:	0: write all changed pages; +ve: page index to stop scanning for changed pages
  */
-int drbd_bm_write_lazy(struct drbd_conf *mdev, unsigned upper_idx) __must_hold(local)
+int drbd_bm_write_lazy(struct drbd_device *mdev, unsigned upper_idx) __must_hold(local)
 {
 	return bm_rw(mdev, WRITE, BM_AIO_COPY_PAGES, upper_idx);
 }
@@ -1221,7 +1221,7 @@ int drbd_bm_write_lazy(struct drbd_conf *mdev, unsigned upper_idx) __must_hold(l
  * verify is aborted due to a failed peer disk, while local IO continues, or
  * pending resync acks are still being processed.
  */
-int drbd_bm_write_copy_pages(struct drbd_conf *mdev) __must_hold(local)
+int drbd_bm_write_copy_pages(struct drbd_device *mdev) __must_hold(local)
 {
 	return bm_rw(mdev, WRITE, BM_AIO_COPY_PAGES, 0);
 }
@@ -1230,7 +1230,7 @@ int drbd_bm_write_copy_pages(struct drbd_conf *mdev) __must_hold(local)
  * drbd_bm_write_hinted() - Write bitmap pages with "hint" marks, if they have changed.
  * @mdev:	DRBD device.
  */
-int drbd_bm_write_hinted(struct drbd_conf *mdev) __must_hold(local)
+int drbd_bm_write_hinted(struct drbd_device *mdev) __must_hold(local)
 {
 	return bm_rw(mdev, WRITE, BM_AIO_WRITE_HINTED | BM_AIO_COPY_PAGES, 0);
 }
@@ -1247,7 +1247,7 @@ int drbd_bm_write_hinted(struct drbd_conf *mdev) __must_hold(local)
  * In case this becomes an issue on systems with larger PAGE_SIZE,
  * we may want to change this again to write 4k aligned 4k pieces.
  */
-int drbd_bm_write_page(struct drbd_conf *mdev, unsigned int idx) __must_hold(local)
+int drbd_bm_write_page(struct drbd_device *mdev, unsigned int idx) __must_hold(local)
 {
 	struct bm_aio_ctx *ctx;
 	int err;
@@ -1298,7 +1298,7 @@ int drbd_bm_write_page(struct drbd_conf *mdev, unsigned int idx) __must_hold(loc
  *
  * this returns a bit number, NOT a sector!
  */
-static unsigned long __bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo,
+static unsigned long __bm_find_next(struct drbd_device *mdev, unsigned long bm_fo,
 	const int find_zero_bit)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
@@ -1338,7 +1338,7 @@ static unsigned long __bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo,
 	return bm_fo;
 }
 
-static unsigned long bm_find_next(struct drbd_conf *mdev,
+static unsigned long bm_find_next(struct drbd_device *mdev,
 	unsigned long bm_fo, const int find_zero_bit)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
@@ -1359,14 +1359,14 @@ static unsigned long bm_find_next(struct drbd_conf *mdev,
 	return i;
 }
 
-unsigned long drbd_bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo)
+unsigned long drbd_bm_find_next(struct drbd_device *mdev, unsigned long bm_fo)
 {
 	return bm_find_next(mdev, bm_fo, 0);
 }
 
 #if 0
 /* not yet needed for anything. */
-unsigned long drbd_bm_find_next_zero(struct drbd_conf *mdev, unsigned long bm_fo)
+unsigned long drbd_bm_find_next_zero(struct drbd_device *mdev, unsigned long bm_fo)
 {
 	return bm_find_next(mdev, bm_fo, 1);
 }
@@ -1374,13 +1374,13 @@ unsigned long drbd_bm_find_next_zero(struct drbd_conf *mdev, unsigned long bm_fo
 
 /* does not spin_lock_irqsave.
  * you must take drbd_bm_lock() first */
-unsigned long _drbd_bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo)
+unsigned long _drbd_bm_find_next(struct drbd_device *mdev, unsigned long bm_fo)
 {
 	/* WARN_ON(!(BM_DONT_SET & mdev->b->bm_flags)); */
 	return __bm_find_next(mdev, bm_fo, 0);
 }
 
-unsigned long _drbd_bm_find_next_zero(struct drbd_conf *mdev, unsigned long bm_fo)
+unsigned long _drbd_bm_find_next_zero(struct drbd_device *mdev, unsigned long bm_fo)
 {
 	/* WARN_ON(!(BM_DONT_SET & mdev->b->bm_flags)); */
 	return __bm_find_next(mdev, bm_fo, 1);
@@ -1392,7 +1392,7 @@ unsigned long _drbd_bm_find_next_zero(struct drbd_conf *mdev, unsigned long bm_f
  * wants bitnr, not sector.
  * expected to be called for only a few bits (e - s about BITS_PER_LONG).
  * Must hold bitmap lock already. */
-static int __bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
+static int __bm_change_bits_to(struct drbd_device *mdev, const unsigned long s,
 	unsigned long e, int val)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
@@ -1441,7 +1441,7 @@ static int __bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
  * for val != 0, we change 0 -> 1, return code positive
  * for val == 0, we change 1 -> 0, return code negative
  * wants bitnr, not sector */
-static int bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
+static int bm_change_bits_to(struct drbd_device *mdev, const unsigned long s,
 	const unsigned long e, int val)
 {
 	unsigned long flags;
@@ -1464,13 +1464,13 @@ static int bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
 }
 
 /* returns number of bits changed 0 -> 1 */
-int drbd_bm_set_bits(struct drbd_conf *mdev, const unsigned long s, const unsigned long e)
+int drbd_bm_set_bits(struct drbd_device *mdev, const unsigned long s, const unsigned long e)
 {
 	return bm_change_bits_to(mdev, s, e, 1);
 }
 
 /* returns number of bits changed 1 -> 0 */
-int drbd_bm_clear_bits(struct drbd_conf *mdev, const unsigned long s, const unsigned long e)
+int drbd_bm_clear_bits(struct drbd_device *mdev, const unsigned long s, const unsigned long e)
 {
 	return -bm_change_bits_to(mdev, s, e, 0);
 }
@@ -1504,7 +1504,7 @@ static inline void bm_set_full_words_within_one_page(struct drbd_bitmap *b,
  * You must first drbd_bm_lock().
  * Can be called to set the whole bitmap in one go.
  * Sets bits from s to e _inclusive_. */
-void _drbd_bm_set_bits(struct drbd_conf *mdev, const unsigned long s, const unsigned long e)
+void _drbd_bm_set_bits(struct drbd_device *mdev, const unsigned long s, const unsigned long e)
 {
 	/* First set_bit from the first bit (s)
 	 * up to the next long boundary (sl),
@@ -1584,7 +1584,7 @@ void _drbd_bm_set_bits(struct drbd_conf *mdev, const unsigned long s, const unsi
  *  0 ... bit not set
  * -1 ... first out of bounds access, stop testing for bits!
  */
-int drbd_bm_test_bit(struct drbd_conf *mdev, const unsigned long bitnr)
+int drbd_bm_test_bit(struct drbd_device *mdev, const unsigned long bitnr)
 {
 	unsigned long flags;
 	struct drbd_bitmap *b = mdev->bitmap;
@@ -1615,7 +1615,7 @@ int drbd_bm_test_bit(struct drbd_conf *mdev, const unsigned long bitnr)
 }
 
 /* returns number of bits set in the range [s, e] */
-int drbd_bm_count_bits(struct drbd_conf *mdev, const unsigned long s, const unsigned long e)
+int drbd_bm_count_bits(struct drbd_device *mdev, const unsigned long s, const unsigned long e)
 {
 	unsigned long flags;
 	struct drbd_bitmap *b = mdev->bitmap;
@@ -1670,7 +1670,7 @@ int drbd_bm_count_bits(struct drbd_conf *mdev, const unsigned long s, const unsi
  * reference count of some bitmap extent element from some lru instead...
  *
  */
-int drbd_bm_e_weight(struct drbd_conf *mdev, unsigned long enr)
+int drbd_bm_e_weight(struct drbd_device *mdev, unsigned long enr)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	int count, s, e;
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2800c74..143fadb 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -96,7 +96,7 @@ extern char usermode_helper[];
 
 #define UUID_NEW_BM_OFFSET ((u64)0x0001000000000000ULL)
 
-struct drbd_conf;
+struct drbd_device;
 struct drbd_tconn;
 
 
@@ -146,10 +146,10 @@ enum {
 };
 
 extern unsigned int
-_drbd_insert_fault(struct drbd_conf *mdev, unsigned int type);
+_drbd_insert_fault(struct drbd_device *mdev, unsigned int type);
 
 static inline int
-drbd_insert_fault(struct drbd_conf *mdev, unsigned int type) {
+drbd_insert_fault(struct drbd_device *mdev, unsigned int type) {
 #ifdef CONFIG_DRBD_FAULT_INJECTION
 	return fault_rate &&
 		(enable_faults & (1<<type)) &&
@@ -188,7 +188,7 @@ struct bm_xfer_ctx {
 	unsigned bytes[2];
 };
 
-extern void INFO_bm_xfer_stats(struct drbd_conf *mdev,
+extern void INFO_bm_xfer_stats(struct drbd_device *mdev,
 		const char *direction, struct bm_xfer_ctx *c);
 
 static inline void bm_xfer_ctx_bit_to_word_offset(struct bm_xfer_ctx *c)
@@ -245,14 +245,14 @@ struct drbd_work {
 	struct list_head list;
 	int (*cb)(struct drbd_work *, int cancel);
 	union {
-		struct drbd_conf *mdev;
+		struct drbd_device *mdev;
 		struct drbd_tconn *tconn;
 	};
 };
 
 #include "drbd_interval.h"
 
-extern int drbd_wait_misc(struct drbd_conf *, struct drbd_interval *);
+extern int drbd_wait_misc(struct drbd_device *, struct drbd_interval *);
 
 struct drbd_request {
 	struct drbd_work w;
@@ -404,7 +404,7 @@ enum {
 	READ_BALANCE_RR,
 };
 
-struct drbd_bitmap; /* opaque for drbd_conf */
+struct drbd_bitmap; /* opaque for drbd_device */
 
 /* definition of bits in bm_flags to be used in drbd_bm_lock
  * and drbd_bitmap_io and friends. */
@@ -491,8 +491,8 @@ struct bm_io_work {
 	struct drbd_work w;
 	char *why;
 	enum bm_flag flags;
-	int (*io_fn)(struct drbd_conf *mdev);
-	void (*done)(struct drbd_conf *mdev, int rv);
+	int (*io_fn)(struct drbd_device *mdev);
+	void (*done)(struct drbd_device *mdev, int rv);
 };
 
 enum write_ordering_e {
@@ -612,7 +612,7 @@ struct submit_worker {
 	struct list_head writes;
 };
 
-struct drbd_conf {
+struct drbd_device {
 	struct drbd_tconn *tconn;
 	int vnr;			/* volume number within the connection */
 	struct kref kref;
@@ -758,19 +758,19 @@ struct drbd_conf {
 	struct submit_worker submit;
 };
 
-static inline struct drbd_conf *minor_to_mdev(unsigned int minor)
+static inline struct drbd_device *minor_to_mdev(unsigned int minor)
 {
-	return (struct drbd_conf *)idr_find(&minors, minor);
+	return (struct drbd_device *)idr_find(&minors, minor);
 }
 
-static inline unsigned int mdev_to_minor(struct drbd_conf *mdev)
+static inline unsigned int mdev_to_minor(struct drbd_device *mdev)
 {
 	return mdev->minor;
 }
 
-static inline struct drbd_conf *vnr_to_mdev(struct drbd_tconn *tconn, int vnr)
+static inline struct drbd_device *vnr_to_mdev(struct drbd_tconn *tconn, int vnr)
 {
-	return (struct drbd_conf *)idr_find(&tconn->volumes, vnr);
+	return (struct drbd_device *)idr_find(&tconn->volumes, vnr);
 }
 
 /*
@@ -784,7 +784,7 @@ enum dds_flags {
 	DDSF_NO_RESYNC = 2, /* Do not run a resync for the new space */
 };
 
-extern void drbd_init_set_defaults(struct drbd_conf *mdev);
+extern void drbd_init_set_defaults(struct drbd_device *mdev);
 extern int  drbd_thread_start(struct drbd_thread *thi);
 extern void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait);
 extern char *drbd_task_to_thread_name(struct drbd_tconn *tconn, struct task_struct *task);
@@ -806,74 +806,74 @@ extern int drbd_send_all(struct drbd_tconn *, struct socket *, void *, size_t,
 
 extern int __drbd_send_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd);
 extern int drbd_send_protocol(struct drbd_tconn *tconn);
-extern int drbd_send_uuids(struct drbd_conf *mdev);
-extern int drbd_send_uuids_skip_initial_sync(struct drbd_conf *mdev);
-extern void drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev);
-extern int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags flags);
-extern int drbd_send_state(struct drbd_conf *mdev, union drbd_state s);
-extern int drbd_send_current_state(struct drbd_conf *mdev);
-extern int drbd_send_sync_param(struct drbd_conf *mdev);
+extern int drbd_send_uuids(struct drbd_device *mdev);
+extern int drbd_send_uuids_skip_initial_sync(struct drbd_device *mdev);
+extern void drbd_gen_and_send_sync_uuid(struct drbd_device *mdev);
+extern int drbd_send_sizes(struct drbd_device *mdev, int trigger_reply, enum dds_flags flags);
+extern int drbd_send_state(struct drbd_device *mdev, union drbd_state s);
+extern int drbd_send_current_state(struct drbd_device *mdev);
+extern int drbd_send_sync_param(struct drbd_device *mdev);
 extern void drbd_send_b_ack(struct drbd_tconn *tconn, u32 barrier_nr,
 			    u32 set_size);
-extern int drbd_send_ack(struct drbd_conf *, enum drbd_packet,
+extern int drbd_send_ack(struct drbd_device *, enum drbd_packet,
 			 struct drbd_peer_request *);
-extern void drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
+extern void drbd_send_ack_rp(struct drbd_device *mdev, enum drbd_packet cmd,
 			     struct p_block_req *rp);
-extern void drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
+extern void drbd_send_ack_dp(struct drbd_device *mdev, enum drbd_packet cmd,
 			     struct p_data *dp, int data_size);
-extern int drbd_send_ack_ex(struct drbd_conf *mdev, enum drbd_packet cmd,
+extern int drbd_send_ack_ex(struct drbd_device *mdev, enum drbd_packet cmd,
 			    sector_t sector, int blksize, u64 block_id);
-extern int drbd_send_out_of_sync(struct drbd_conf *, struct drbd_request *);
-extern int drbd_send_block(struct drbd_conf *, enum drbd_packet,
+extern int drbd_send_out_of_sync(struct drbd_device *, struct drbd_request *);
+extern int drbd_send_block(struct drbd_device *, enum drbd_packet,
 			   struct drbd_peer_request *);
-extern int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req);
-extern int drbd_send_drequest(struct drbd_conf *mdev, int cmd,
+extern int drbd_send_dblock(struct drbd_device *mdev, struct drbd_request *req);
+extern int drbd_send_drequest(struct drbd_device *mdev, int cmd,
 			      sector_t sector, int size, u64 block_id);
-extern int drbd_send_drequest_csum(struct drbd_conf *mdev, sector_t sector,
+extern int drbd_send_drequest_csum(struct drbd_device *mdev, sector_t sector,
 				   int size, void *digest, int digest_size,
 				   enum drbd_packet cmd);
-extern int drbd_send_ov_request(struct drbd_conf *mdev,sector_t sector,int size);
+extern int drbd_send_ov_request(struct drbd_device *mdev, sector_t sector, int size);
 
-extern int drbd_send_bitmap(struct drbd_conf *mdev);
-extern void drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode);
+extern int drbd_send_bitmap(struct drbd_device *mdev);
+extern void drbd_send_sr_reply(struct drbd_device *mdev, enum drbd_state_rv retcode);
 extern void conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode);
 extern void drbd_free_bc(struct drbd_backing_dev *ldev);
-extern void drbd_mdev_cleanup(struct drbd_conf *mdev);
-void drbd_print_uuids(struct drbd_conf *mdev, const char *text);
+extern void drbd_mdev_cleanup(struct drbd_device *mdev);
+void drbd_print_uuids(struct drbd_device *mdev, const char *text);
 
 extern void conn_md_sync(struct drbd_tconn *tconn);
-extern void drbd_md_write(struct drbd_conf *mdev, void *buffer);
-extern void drbd_md_sync(struct drbd_conf *mdev);
-extern int  drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev);
-extern void drbd_uuid_set(struct drbd_conf *mdev, int idx, u64 val) __must_hold(local);
-extern void _drbd_uuid_set(struct drbd_conf *mdev, int idx, u64 val) __must_hold(local);
-extern void drbd_uuid_new_current(struct drbd_conf *mdev) __must_hold(local);
-extern void drbd_uuid_set_bm(struct drbd_conf *mdev, u64 val) __must_hold(local);
-extern void drbd_uuid_move_history(struct drbd_conf *mdev) __must_hold(local);
-extern void __drbd_uuid_set(struct drbd_conf *mdev, int idx, u64 val) __must_hold(local);
-extern void drbd_md_set_flag(struct drbd_conf *mdev, int flags) __must_hold(local);
-extern void drbd_md_clear_flag(struct drbd_conf *mdev, int flags)__must_hold(local);
+extern void drbd_md_write(struct drbd_device *mdev, void *buffer);
+extern void drbd_md_sync(struct drbd_device *mdev);
+extern int  drbd_md_read(struct drbd_device *mdev, struct drbd_backing_dev *bdev);
+extern void drbd_uuid_set(struct drbd_device *mdev, int idx, u64 val) __must_hold(local);
+extern void _drbd_uuid_set(struct drbd_device *mdev, int idx, u64 val) __must_hold(local);
+extern void drbd_uuid_new_current(struct drbd_device *mdev) __must_hold(local);
+extern void drbd_uuid_set_bm(struct drbd_device *mdev, u64 val) __must_hold(local);
+extern void drbd_uuid_move_history(struct drbd_device *mdev) __must_hold(local);
+extern void __drbd_uuid_set(struct drbd_device *mdev, int idx, u64 val) __must_hold(local);
+extern void drbd_md_set_flag(struct drbd_device *mdev, int flags) __must_hold(local);
+extern void drbd_md_clear_flag(struct drbd_device *mdev, int flags)__must_hold(local);
 extern int drbd_md_test_flag(struct drbd_backing_dev *, int);
 #ifndef DRBD_DEBUG_MD_SYNC
-extern void drbd_md_mark_dirty(struct drbd_conf *mdev);
+extern void drbd_md_mark_dirty(struct drbd_device *mdev);
 #else
 #define drbd_md_mark_dirty(m)	drbd_md_mark_dirty_(m, __LINE__ , __func__ )
-extern void drbd_md_mark_dirty_(struct drbd_conf *mdev,
+extern void drbd_md_mark_dirty_(struct drbd_device *mdev,
 		unsigned int line, const char *func);
 #endif
-extern void drbd_queue_bitmap_io(struct drbd_conf *mdev,
-				 int (*io_fn)(struct drbd_conf *),
-				 void (*done)(struct drbd_conf *, int),
+extern void drbd_queue_bitmap_io(struct drbd_device *mdev,
+				 int (*io_fn)(struct drbd_device *),
+				 void (*done)(struct drbd_device *, int),
 				 char *why, enum bm_flag flags);
-extern int drbd_bitmap_io(struct drbd_conf *mdev,
-		int (*io_fn)(struct drbd_conf *),
+extern int drbd_bitmap_io(struct drbd_device *mdev,
+		int (*io_fn)(struct drbd_device *),
 		char *why, enum bm_flag flags);
-extern int drbd_bitmap_io_from_worker(struct drbd_conf *mdev,
-		int (*io_fn)(struct drbd_conf *),
+extern int drbd_bitmap_io_from_worker(struct drbd_device *mdev,
+		int (*io_fn)(struct drbd_device *),
 		char *why, enum bm_flag flags);
-extern int drbd_bmio_set_n_write(struct drbd_conf *mdev);
-extern int drbd_bmio_clear_n_write(struct drbd_conf *mdev);
-extern void drbd_ldev_destroy(struct drbd_conf *mdev);
+extern int drbd_bmio_set_n_write(struct drbd_device *mdev);
+extern int drbd_bmio_clear_n_write(struct drbd_device *mdev);
+extern void drbd_ldev_destroy(struct drbd_device *mdev);
 
 /* Meta data layout
  *
@@ -1059,52 +1059,52 @@ struct bm_extent {
 #define DRBD_MAX_SIZE_H80_PACKET (1U << 15) /* Header 80 only allows packets up to 32KiB data */
 #define DRBD_MAX_BIO_SIZE_P95    (1U << 17) /* Protocol 95 to 99 allows bios up to 128KiB */
 
-extern int  drbd_bm_init(struct drbd_conf *mdev);
-extern int  drbd_bm_resize(struct drbd_conf *mdev, sector_t sectors, int set_new_bits);
-extern void drbd_bm_cleanup(struct drbd_conf *mdev);
-extern void drbd_bm_set_all(struct drbd_conf *mdev);
-extern void drbd_bm_clear_all(struct drbd_conf *mdev);
+extern int  drbd_bm_init(struct drbd_device *mdev);
+extern int  drbd_bm_resize(struct drbd_device *mdev, sector_t sectors, int set_new_bits);
+extern void drbd_bm_cleanup(struct drbd_device *mdev);
+extern void drbd_bm_set_all(struct drbd_device *mdev);
+extern void drbd_bm_clear_all(struct drbd_device *mdev);
 /* set/clear/test only a few bits at a time */
 extern int  drbd_bm_set_bits(
-		struct drbd_conf *mdev, unsigned long s, unsigned long e);
+		struct drbd_device *mdev, unsigned long s, unsigned long e);
 extern int  drbd_bm_clear_bits(
-		struct drbd_conf *mdev, unsigned long s, unsigned long e);
+		struct drbd_device *mdev, unsigned long s, unsigned long e);
 extern int drbd_bm_count_bits(
-	struct drbd_conf *mdev, const unsigned long s, const unsigned long e);
+	struct drbd_device *mdev, const unsigned long s, const unsigned long e);
 /* bm_set_bits variant for use while holding drbd_bm_lock,
  * may process the whole bitmap in one go */
-extern void _drbd_bm_set_bits(struct drbd_conf *mdev,
+extern void _drbd_bm_set_bits(struct drbd_device *mdev,
 		const unsigned long s, const unsigned long e);
-extern int  drbd_bm_test_bit(struct drbd_conf *mdev, unsigned long bitnr);
-extern int  drbd_bm_e_weight(struct drbd_conf *mdev, unsigned long enr);
-extern int  drbd_bm_write_page(struct drbd_conf *mdev, unsigned int idx) __must_hold(local);
-extern int  drbd_bm_read(struct drbd_conf *mdev) __must_hold(local);
-extern void drbd_bm_mark_for_writeout(struct drbd_conf *mdev, int page_nr);
-extern int  drbd_bm_write(struct drbd_conf *mdev) __must_hold(local);
-extern int  drbd_bm_write_hinted(struct drbd_conf *mdev) __must_hold(local);
-extern int drbd_bm_write_all(struct drbd_conf *mdev) __must_hold(local);
-extern int  drbd_bm_write_copy_pages(struct drbd_conf *mdev) __must_hold(local);
-extern size_t	     drbd_bm_words(struct drbd_conf *mdev);
-extern unsigned long drbd_bm_bits(struct drbd_conf *mdev);
-extern sector_t      drbd_bm_capacity(struct drbd_conf *mdev);
+extern int  drbd_bm_test_bit(struct drbd_device *mdev, unsigned long bitnr);
+extern int  drbd_bm_e_weight(struct drbd_device *mdev, unsigned long enr);
+extern int  drbd_bm_write_page(struct drbd_device *mdev, unsigned int idx) __must_hold(local);
+extern int  drbd_bm_read(struct drbd_device *mdev) __must_hold(local);
+extern void drbd_bm_mark_for_writeout(struct drbd_device *mdev, int page_nr);
+extern int  drbd_bm_write(struct drbd_device *mdev) __must_hold(local);
+extern int  drbd_bm_write_hinted(struct drbd_device *mdev) __must_hold(local);
+extern int drbd_bm_write_all(struct drbd_device *mdev) __must_hold(local);
+extern int  drbd_bm_write_copy_pages(struct drbd_device *mdev) __must_hold(local);
+extern size_t	     drbd_bm_words(struct drbd_device *mdev);
+extern unsigned long drbd_bm_bits(struct drbd_device *mdev);
+extern sector_t      drbd_bm_capacity(struct drbd_device *mdev);
 
 #define DRBD_END_OF_BITMAP	(~(unsigned long)0)
-extern unsigned long drbd_bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo);
+extern unsigned long drbd_bm_find_next(struct drbd_device *mdev, unsigned long bm_fo);
 /* bm_find_next variants for use while you hold drbd_bm_lock() */
-extern unsigned long _drbd_bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo);
-extern unsigned long _drbd_bm_find_next_zero(struct drbd_conf *mdev, unsigned long bm_fo);
-extern unsigned long _drbd_bm_total_weight(struct drbd_conf *mdev);
-extern unsigned long drbd_bm_total_weight(struct drbd_conf *mdev);
-extern int drbd_bm_rs_done(struct drbd_conf *mdev);
+extern unsigned long _drbd_bm_find_next(struct drbd_device *mdev, unsigned long bm_fo);
+extern unsigned long _drbd_bm_find_next_zero(struct drbd_device *mdev, unsigned long bm_fo);
+extern unsigned long _drbd_bm_total_weight(struct drbd_device *mdev);
+extern unsigned long drbd_bm_total_weight(struct drbd_device *mdev);
+extern int drbd_bm_rs_done(struct drbd_device *mdev);
 /* for receive_bitmap */
-extern void drbd_bm_merge_lel(struct drbd_conf *mdev, size_t offset,
+extern void drbd_bm_merge_lel(struct drbd_device *mdev, size_t offset,
 		size_t number, unsigned long *buffer);
 /* for _drbd_send_bitmap */
-extern void drbd_bm_get_lel(struct drbd_conf *mdev, size_t offset,
+extern void drbd_bm_get_lel(struct drbd_device *mdev, size_t offset,
 		size_t number, unsigned long *buffer);
 
-extern void drbd_bm_lock(struct drbd_conf *mdev, char *why, enum bm_flag flags);
-extern void drbd_bm_unlock(struct drbd_conf *mdev);
+extern void drbd_bm_lock(struct drbd_device *mdev, char *why, enum bm_flag flags);
+extern void drbd_bm_unlock(struct drbd_device *mdev);
 /* drbd_main.c */
 
 extern struct kmem_cache *drbd_request_cache;
@@ -1164,19 +1164,19 @@ extern int proc_details;
 
 /* drbd_req */
 extern void do_submit(struct work_struct *ws);
-extern void __drbd_make_request(struct drbd_conf *, struct bio *, unsigned long);
+extern void __drbd_make_request(struct drbd_device *, struct bio *, unsigned long);
 extern void drbd_make_request(struct request_queue *q, struct bio *bio);
-extern int drbd_read_remote(struct drbd_conf *mdev, struct drbd_request *req);
+extern int drbd_read_remote(struct drbd_device *mdev, struct drbd_request *req);
 extern int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct bio_vec *bvec);
 extern int is_valid_ar_handle(struct drbd_request *, sector_t);
 
 
 /* drbd_nl.c */
 extern int drbd_msg_put_info(const char *info);
-extern void drbd_suspend_io(struct drbd_conf *mdev);
-extern void drbd_resume_io(struct drbd_conf *mdev);
+extern void drbd_suspend_io(struct drbd_device *mdev);
+extern void drbd_resume_io(struct drbd_device *mdev);
 extern char *ppsize(char *buf, unsigned long long size);
-extern sector_t drbd_new_dev_size(struct drbd_conf *, struct drbd_backing_dev *, sector_t, int);
+extern sector_t drbd_new_dev_size(struct drbd_device *, struct drbd_backing_dev *, sector_t, int);
 enum determine_dev_size {
 	DS_ERROR_SHRINK = -3,
 	DS_ERROR_SPACE_MD = -2,
@@ -1187,35 +1187,35 @@ enum determine_dev_size {
 	DS_GREW_FROM_ZERO = 3,
 };
 extern enum determine_dev_size
-drbd_determine_dev_size(struct drbd_conf *, enum dds_flags, struct resize_parms *) __must_hold(local);
-extern void resync_after_online_grow(struct drbd_conf *);
-extern void drbd_reconsider_max_bio_size(struct drbd_conf *mdev);
-extern enum drbd_state_rv drbd_set_role(struct drbd_conf *mdev,
+drbd_determine_dev_size(struct drbd_device *, enum dds_flags, struct resize_parms *) __must_hold(local);
+extern void resync_after_online_grow(struct drbd_device *);
+extern void drbd_reconsider_max_bio_size(struct drbd_device *mdev);
+extern enum drbd_state_rv drbd_set_role(struct drbd_device *mdev,
 					enum drbd_role new_role,
 					int force);
 extern bool conn_try_outdate_peer(struct drbd_tconn *tconn);
 extern void conn_try_outdate_peer_async(struct drbd_tconn *tconn);
-extern int drbd_khelper(struct drbd_conf *mdev, char *cmd);
+extern int drbd_khelper(struct drbd_device *mdev, char *cmd);
 
 /* drbd_worker.c */
 extern int drbd_worker(struct drbd_thread *thi);
-enum drbd_ret_code drbd_resync_after_valid(struct drbd_conf *mdev, int o_minor);
-void drbd_resync_after_changed(struct drbd_conf *mdev);
-extern void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side);
-extern void resume_next_sg(struct drbd_conf *mdev);
-extern void suspend_other_sg(struct drbd_conf *mdev);
-extern int drbd_resync_finished(struct drbd_conf *mdev);
+enum drbd_ret_code drbd_resync_after_valid(struct drbd_device *mdev, int o_minor);
+void drbd_resync_after_changed(struct drbd_device *mdev);
+extern void drbd_start_resync(struct drbd_device *mdev, enum drbd_conns side);
+extern void resume_next_sg(struct drbd_device *mdev);
+extern void suspend_other_sg(struct drbd_device *mdev);
+extern int drbd_resync_finished(struct drbd_device *mdev);
 /* maybe rather drbd_main.c ? */
-extern void *drbd_md_get_buffer(struct drbd_conf *mdev);
-extern void drbd_md_put_buffer(struct drbd_conf *mdev);
-extern int drbd_md_sync_page_io(struct drbd_conf *mdev,
+extern void *drbd_md_get_buffer(struct drbd_device *mdev);
+extern void drbd_md_put_buffer(struct drbd_device *mdev);
+extern int drbd_md_sync_page_io(struct drbd_device *mdev,
 		struct drbd_backing_dev *bdev, sector_t sector, int rw);
-extern void drbd_ov_out_of_sync_found(struct drbd_conf *, sector_t, int);
-extern void wait_until_done_or_force_detached(struct drbd_conf *mdev,
+extern void drbd_ov_out_of_sync_found(struct drbd_device *, sector_t, int);
+extern void wait_until_done_or_force_detached(struct drbd_device *mdev,
 		struct drbd_backing_dev *bdev, unsigned int *done);
-extern void drbd_rs_controller_reset(struct drbd_conf *mdev);
+extern void drbd_rs_controller_reset(struct drbd_device *mdev);
 
-static inline void ov_out_of_sync_print(struct drbd_conf *mdev)
+static inline void ov_out_of_sync_print(struct drbd_device *mdev)
 {
 	if (mdev->ov_last_oos_size) {
 		dev_err(DEV, "Out of sync: start=%llu, size=%lu (sectors)\n",
@@ -1226,8 +1226,8 @@ static inline void ov_out_of_sync_print(struct drbd_conf *mdev)
 }
 
 
-extern void drbd_csum_bio(struct drbd_conf *, struct crypto_hash *, struct bio *, void *);
-extern void drbd_csum_ee(struct drbd_conf *, struct crypto_hash *,
+extern void drbd_csum_bio(struct drbd_device *, struct crypto_hash *, struct bio *, void *);
+extern void drbd_csum_ee(struct drbd_device *, struct crypto_hash *,
 			 struct drbd_peer_request *, void *);
 /* worker callbacks */
 extern int w_e_end_data_req(struct drbd_work *, int);
@@ -1251,24 +1251,24 @@ extern void resync_timer_fn(unsigned long data);
 extern void start_resync_timer_fn(unsigned long data);
 
 /* drbd_receiver.c */
-extern int drbd_rs_should_slow_down(struct drbd_conf *mdev, sector_t sector);
-extern int drbd_submit_peer_request(struct drbd_conf *,
+extern int drbd_rs_should_slow_down(struct drbd_device *mdev, sector_t sector);
+extern int drbd_submit_peer_request(struct drbd_device *,
 				    struct drbd_peer_request *, const unsigned,
 				    const int);
-extern int drbd_free_peer_reqs(struct drbd_conf *, struct list_head *);
-extern struct drbd_peer_request *drbd_alloc_peer_req(struct drbd_conf *, u64,
+extern int drbd_free_peer_reqs(struct drbd_device *, struct list_head *);
+extern struct drbd_peer_request *drbd_alloc_peer_req(struct drbd_device *, u64,
 						     sector_t, unsigned int,
 						     gfp_t) __must_hold(local);
-extern void __drbd_free_peer_req(struct drbd_conf *, struct drbd_peer_request *,
+extern void __drbd_free_peer_req(struct drbd_device *, struct drbd_peer_request *,
 				 int);
 #define drbd_free_peer_req(m,e) __drbd_free_peer_req(m, e, 0)
 #define drbd_free_net_peer_req(m,e) __drbd_free_peer_req(m, e, 1)
-extern struct page *drbd_alloc_pages(struct drbd_conf *, unsigned int, bool);
-extern void drbd_set_recv_tcq(struct drbd_conf *mdev, int tcq_enabled);
-extern void _drbd_clear_done_ee(struct drbd_conf *mdev, struct list_head *to_be_freed);
+extern struct page *drbd_alloc_pages(struct drbd_device *, unsigned int, bool);
+extern void drbd_set_recv_tcq(struct drbd_device *mdev, int tcq_enabled);
+extern void _drbd_clear_done_ee(struct drbd_device *mdev, struct list_head *to_be_freed);
 extern void conn_flush_workqueue(struct drbd_tconn *tconn);
-extern int drbd_connected(struct drbd_conf *mdev);
-static inline void drbd_flush_workqueue(struct drbd_conf *mdev)
+extern int drbd_connected(struct drbd_device *mdev);
+static inline void drbd_flush_workqueue(struct drbd_device *mdev)
 {
 	conn_flush_workqueue(mdev->tconn);
 }
@@ -1331,29 +1331,29 @@ extern const char *drbd_conn_str(enum drbd_conns s);
 extern const char *drbd_role_str(enum drbd_role s);
 
 /* drbd_actlog.c */
-extern int drbd_al_begin_io_nonblock(struct drbd_conf *mdev, struct drbd_interval *i);
-extern void drbd_al_begin_io_commit(struct drbd_conf *mdev, bool delegate);
-extern bool drbd_al_begin_io_fastpath(struct drbd_conf *mdev, struct drbd_interval *i);
-extern void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool delegate);
-extern void drbd_al_complete_io(struct drbd_conf *mdev, struct drbd_interval *i);
-extern void drbd_rs_complete_io(struct drbd_conf *mdev, sector_t sector);
-extern int drbd_rs_begin_io(struct drbd_conf *mdev, sector_t sector);
-extern int drbd_try_rs_begin_io(struct drbd_conf *mdev, sector_t sector);
-extern void drbd_rs_cancel_all(struct drbd_conf *mdev);
-extern int drbd_rs_del_all(struct drbd_conf *mdev);
-extern void drbd_rs_failed_io(struct drbd_conf *mdev,
+extern int drbd_al_begin_io_nonblock(struct drbd_device *mdev, struct drbd_interval *i);
+extern void drbd_al_begin_io_commit(struct drbd_device *mdev, bool delegate);
+extern bool drbd_al_begin_io_fastpath(struct drbd_device *mdev, struct drbd_interval *i);
+extern void drbd_al_begin_io(struct drbd_device *mdev, struct drbd_interval *i, bool delegate);
+extern void drbd_al_complete_io(struct drbd_device *mdev, struct drbd_interval *i);
+extern void drbd_rs_complete_io(struct drbd_device *mdev, sector_t sector);
+extern int drbd_rs_begin_io(struct drbd_device *mdev, sector_t sector);
+extern int drbd_try_rs_begin_io(struct drbd_device *mdev, sector_t sector);
+extern void drbd_rs_cancel_all(struct drbd_device *mdev);
+extern int drbd_rs_del_all(struct drbd_device *mdev);
+extern void drbd_rs_failed_io(struct drbd_device *mdev,
 		sector_t sector, int size);
-extern void drbd_advance_rs_marks(struct drbd_conf *mdev, unsigned long still_to_go);
-extern void __drbd_set_in_sync(struct drbd_conf *mdev, sector_t sector,
+extern void drbd_advance_rs_marks(struct drbd_device *mdev, unsigned long still_to_go);
+extern void __drbd_set_in_sync(struct drbd_device *mdev, sector_t sector,
 		int size, const char *file, const unsigned int line);
 #define drbd_set_in_sync(mdev, sector, size) \
 	__drbd_set_in_sync(mdev, sector, size, __FILE__, __LINE__)
-extern int __drbd_set_out_of_sync(struct drbd_conf *mdev, sector_t sector,
+extern int __drbd_set_out_of_sync(struct drbd_device *mdev, sector_t sector,
 		int size, const char *file, const unsigned int line);
 #define drbd_set_out_of_sync(mdev, sector, size) \
 	__drbd_set_out_of_sync(mdev, sector, size, __FILE__, __LINE__)
-extern void drbd_al_shrink(struct drbd_conf *mdev);
-extern int drbd_initialize_al(struct drbd_conf *, void *);
+extern void drbd_al_shrink(struct drbd_device *mdev);
+extern int drbd_initialize_al(struct drbd_device *, void *);
 
 /* drbd_nl.c */
 /* state info broadcast */
@@ -1370,7 +1370,7 @@ struct sib_info {
 		};
 	};
 };
-void drbd_bcast_event(struct drbd_conf *mdev, const struct sib_info *sib);
+void drbd_bcast_event(struct drbd_device *mdev, const struct sib_info *sib);
 
 /*
  * inline helper functions
@@ -1399,7 +1399,7 @@ static inline int drbd_peer_req_has_active_page(struct drbd_peer_request *peer_r
 }
 
 static inline enum drbd_state_rv
-_drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
+_drbd_set_state(struct drbd_device *mdev, union drbd_state ns,
 		enum chg_state_flags flags, struct completion *done)
 {
 	enum drbd_state_rv rv;
@@ -1411,7 +1411,7 @@ _drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 	return rv;
 }
 
-static inline union drbd_state drbd_read_state(struct drbd_conf *mdev)
+static inline union drbd_state drbd_read_state(struct drbd_device *mdev)
 {
 	union drbd_state rv;
 
@@ -1431,7 +1431,7 @@ enum drbd_force_detach_flags {
 };
 
 #define __drbd_chk_io_error(m,f) __drbd_chk_io_error_(m,f, __func__)
-static inline void __drbd_chk_io_error_(struct drbd_conf *mdev,
+static inline void __drbd_chk_io_error_(struct drbd_device *mdev,
 		enum drbd_force_detach_flags df,
 		const char *where)
 {
@@ -1495,7 +1495,7 @@ static inline void __drbd_chk_io_error_(struct drbd_conf *mdev,
  * See also drbd_main.c:after_state_ch() if (os.disk > D_FAILED && ns.disk == D_FAILED)
  */
 #define drbd_chk_io_error(m,e,f) drbd_chk_io_error_(m,e,f, __func__)
-static inline void drbd_chk_io_error_(struct drbd_conf *mdev,
+static inline void drbd_chk_io_error_(struct drbd_device *mdev,
 	int error, enum drbd_force_detach_flags forcedetach, const char *where)
 {
 	if (error) {
@@ -1638,17 +1638,17 @@ static inline void request_ping(struct drbd_tconn *tconn)
 }
 
 extern void *conn_prepare_command(struct drbd_tconn *, struct drbd_socket *);
-extern void *drbd_prepare_command(struct drbd_conf *, struct drbd_socket *);
+extern void *drbd_prepare_command(struct drbd_device *, struct drbd_socket *);
 extern int conn_send_command(struct drbd_tconn *, struct drbd_socket *,
 			     enum drbd_packet, unsigned int, void *,
 			     unsigned int);
-extern int drbd_send_command(struct drbd_conf *, struct drbd_socket *,
+extern int drbd_send_command(struct drbd_device *, struct drbd_socket *,
 			     enum drbd_packet, unsigned int, void *,
 			     unsigned int);
 
 extern int drbd_send_ping(struct drbd_tconn *tconn);
 extern int drbd_send_ping_ack(struct drbd_tconn *tconn);
-extern int drbd_send_state_req(struct drbd_conf *, union drbd_state, union drbd_state);
+extern int drbd_send_state_req(struct drbd_device *, union drbd_state, union drbd_state);
 extern int conn_send_state_req(struct drbd_tconn *, union drbd_state, union drbd_state);
 
 static inline void drbd_thread_stop(struct drbd_thread *thi)
@@ -1688,7 +1688,7 @@ static inline void drbd_thread_restart_nowait(struct drbd_thread *thi)
  *  _req_mod(req, CONNECTION_LOST_WHILE_PENDING)
  *     [from tl_clear_barrier]
  */
-static inline void inc_ap_pending(struct drbd_conf *mdev)
+static inline void inc_ap_pending(struct drbd_device *mdev)
 {
 	atomic_inc(&mdev->ap_pending_cnt);
 }
@@ -1700,7 +1700,7 @@ static inline void inc_ap_pending(struct drbd_conf *mdev)
 			atomic_read(&mdev->which))
 
 #define dec_ap_pending(mdev) _dec_ap_pending(mdev, __FUNCTION__, __LINE__)
-static inline void _dec_ap_pending(struct drbd_conf *mdev, const char *func, int line)
+static inline void _dec_ap_pending(struct drbd_device *mdev, const char *func, int line)
 {
 	if (atomic_dec_and_test(&mdev->ap_pending_cnt))
 		wake_up(&mdev->misc_wait);
@@ -1713,13 +1713,13 @@ static inline void _dec_ap_pending(struct drbd_conf *mdev, const char *func, int
  * C_SYNC_SOURCE sends P_RS_DATA_REPLY   (and expects P_WRITE_ACK with ID_SYNCER)
  *					   (or P_NEG_ACK with ID_SYNCER)
  */
-static inline void inc_rs_pending(struct drbd_conf *mdev)
+static inline void inc_rs_pending(struct drbd_device *mdev)
 {
 	atomic_inc(&mdev->rs_pending_cnt);
 }
 
 #define dec_rs_pending(mdev) _dec_rs_pending(mdev, __FUNCTION__, __LINE__)
-static inline void _dec_rs_pending(struct drbd_conf *mdev, const char *func, int line)
+static inline void _dec_rs_pending(struct drbd_device *mdev, const char *func, int line)
 {
 	atomic_dec(&mdev->rs_pending_cnt);
 	ERR_IF_CNT_IS_NEGATIVE(rs_pending_cnt, func, line);
@@ -1734,20 +1734,20 @@ static inline void _dec_rs_pending(struct drbd_conf *mdev, const char *func, int
  *  receive_DataRequest (receive_RSDataRequest) we need to send back P_DATA
  *  receive_Barrier_*	we need to send a P_BARRIER_ACK
  */
-static inline void inc_unacked(struct drbd_conf *mdev)
+static inline void inc_unacked(struct drbd_device *mdev)
 {
 	atomic_inc(&mdev->unacked_cnt);
 }
 
 #define dec_unacked(mdev) _dec_unacked(mdev, __FUNCTION__, __LINE__)
-static inline void _dec_unacked(struct drbd_conf *mdev, const char *func, int line)
+static inline void _dec_unacked(struct drbd_device *mdev, const char *func, int line)
 {
 	atomic_dec(&mdev->unacked_cnt);
 	ERR_IF_CNT_IS_NEGATIVE(unacked_cnt, func, line);
 }
 
 #define sub_unacked(mdev, n) _sub_unacked(mdev, n, __FUNCTION__, __LINE__)
-static inline void _sub_unacked(struct drbd_conf *mdev, int n, const char *func, int line)
+static inline void _sub_unacked(struct drbd_device *mdev, int n, const char *func, int line)
 {
 	atomic_sub(n, &mdev->unacked_cnt);
 	ERR_IF_CNT_IS_NEGATIVE(unacked_cnt, func, line);
@@ -1762,7 +1762,7 @@ static inline void _sub_unacked(struct drbd_conf *mdev, int n, const char *func,
 #define get_ldev(M) __cond_lock(local, _get_ldev_if_state(M,D_INCONSISTENT))
 #define get_ldev_if_state(M,MINS) __cond_lock(local, _get_ldev_if_state(M,MINS))
 
-static inline void put_ldev(struct drbd_conf *mdev)
+static inline void put_ldev(struct drbd_device *mdev)
 {
 	int i = atomic_dec_return(&mdev->local_cnt);
 
@@ -1785,7 +1785,7 @@ static inline void put_ldev(struct drbd_conf *mdev)
 }
 
 #ifndef __CHECKER__
-static inline int _get_ldev_if_state(struct drbd_conf *mdev, enum drbd_disk_state mins)
+static inline int _get_ldev_if_state(struct drbd_device *mdev, enum drbd_disk_state mins)
 {
 	int io_allowed;
 
@@ -1800,11 +1800,11 @@ static inline int _get_ldev_if_state(struct drbd_conf *mdev, enum drbd_disk_stat
 	return io_allowed;
 }
 #else
-extern int _get_ldev_if_state(struct drbd_conf *mdev, enum drbd_disk_state mins);
+extern int _get_ldev_if_state(struct drbd_device *mdev, enum drbd_disk_state mins);
 #endif
 
 /* you must have an "get_ldev" reference */
-static inline void drbd_get_syncer_progress(struct drbd_conf *mdev,
+static inline void drbd_get_syncer_progress(struct drbd_device *mdev,
 		unsigned long *bits_left, unsigned int *per_mil_done)
 {
 	/* this is to break it at compile time when we change that, in case we
@@ -1854,7 +1854,7 @@ static inline void drbd_get_syncer_progress(struct drbd_conf *mdev,
 /* this throttles on-the-fly application requests
  * according to max_buffers settings;
  * maybe re-implement using semaphores? */
-static inline int drbd_get_max_buffers(struct drbd_conf *mdev)
+static inline int drbd_get_max_buffers(struct drbd_device *mdev)
 {
 	struct net_conf *nc;
 	int mxb;
@@ -1867,7 +1867,7 @@ static inline int drbd_get_max_buffers(struct drbd_conf *mdev)
 	return mxb;
 }
 
-static inline int drbd_state_is_stable(struct drbd_conf *mdev)
+static inline int drbd_state_is_stable(struct drbd_device *mdev)
 {
 	union drbd_dev_state s = mdev->state;
 
@@ -1937,14 +1937,14 @@ static inline int drbd_state_is_stable(struct drbd_conf *mdev)
 	return 1;
 }
 
-static inline int drbd_suspended(struct drbd_conf *mdev)
+static inline int drbd_suspended(struct drbd_device *mdev)
 {
 	struct drbd_tconn *tconn = mdev->tconn;
 
 	return tconn->susp || tconn->susp_fen || tconn->susp_nod;
 }
 
-static inline bool may_inc_ap_bio(struct drbd_conf *mdev)
+static inline bool may_inc_ap_bio(struct drbd_device *mdev)
 {
 	int mxb = drbd_get_max_buffers(mdev);
 
@@ -1970,7 +1970,7 @@ static inline bool may_inc_ap_bio(struct drbd_conf *mdev)
 	return true;
 }
 
-static inline bool inc_ap_bio_cond(struct drbd_conf *mdev)
+static inline bool inc_ap_bio_cond(struct drbd_device *mdev)
 {
 	bool rv = false;
 
@@ -1983,7 +1983,7 @@ static inline bool inc_ap_bio_cond(struct drbd_conf *mdev)
 	return rv;
 }
 
-static inline void inc_ap_bio(struct drbd_conf *mdev)
+static inline void inc_ap_bio(struct drbd_device *mdev)
 {
 	/* we wait here
 	 *    as long as the device is suspended
@@ -1996,7 +1996,7 @@ static inline void inc_ap_bio(struct drbd_conf *mdev)
 	wait_event(mdev->misc_wait, inc_ap_bio_cond(mdev));
 }
 
-static inline void dec_ap_bio(struct drbd_conf *mdev)
+static inline void dec_ap_bio(struct drbd_device *mdev)
 {
 	int mxb = drbd_get_max_buffers(mdev);
 	int ap_bio = atomic_dec_return(&mdev->ap_bio_cnt);
@@ -2015,20 +2015,20 @@ static inline void dec_ap_bio(struct drbd_conf *mdev)
 		wake_up(&mdev->misc_wait);
 }
 
-static inline bool verify_can_do_stop_sector(struct drbd_conf *mdev)
+static inline bool verify_can_do_stop_sector(struct drbd_device *mdev)
 {
 	return mdev->tconn->agreed_pro_version >= 97 &&
 		mdev->tconn->agreed_pro_version != 100;
 }
 
-static inline int drbd_set_ed_uuid(struct drbd_conf *mdev, u64 val)
+static inline int drbd_set_ed_uuid(struct drbd_device *mdev, u64 val)
 {
 	int changed = mdev->ed_uuid != val;
 	mdev->ed_uuid = val;
 	return changed;
 }
 
-static inline int drbd_queue_order_type(struct drbd_conf *mdev)
+static inline int drbd_queue_order_type(struct drbd_device *mdev)
 {
 	/* sorry, we currently have no working implementation
 	 * of distributed TCQ stuff */
@@ -2038,7 +2038,7 @@ static inline int drbd_queue_order_type(struct drbd_conf *mdev)
 	return QUEUE_ORDERED_NONE;
 }
 
-static inline void drbd_md_flush(struct drbd_conf *mdev)
+static inline void drbd_md_flush(struct drbd_device *mdev)
 {
 	int r;
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 47cadde..92cb9e5 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -167,7 +167,7 @@ struct bio *bio_alloc_drbd(gfp_t gfp_mask)
 /* When checking with sparse, and this is an inline function, sparse will
    give tons of false positives. When this is a real functions sparse works.
  */
-int _get_ldev_if_state(struct drbd_conf *mdev, enum drbd_disk_state mins)
+int _get_ldev_if_state(struct drbd_device *mdev, enum drbd_disk_state mins)
 {
 	int io_allowed;
 
@@ -308,7 +308,7 @@ void tl_clear(struct drbd_tconn *tconn)
  * tl_abort_disk_io() - Abort disk I/O for all requests for a certain mdev in the TL
  * @mdev:	DRBD device.
  */
-void tl_abort_disk_io(struct drbd_conf *mdev)
+void tl_abort_disk_io(struct drbd_device *mdev)
 {
 	struct drbd_tconn *tconn = mdev->tconn;
 	struct drbd_request *req, *r;
@@ -497,7 +497,7 @@ char *drbd_task_to_thread_name(struct drbd_tconn *tconn, struct task_struct *tas
 
 int conn_lowest_minor(struct drbd_tconn *tconn)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr = 0, m;
 
 	rcu_read_lock();
@@ -633,7 +633,7 @@ void *conn_prepare_command(struct drbd_tconn *tconn, struct drbd_socket *sock)
 	return p;
 }
 
-void *drbd_prepare_command(struct drbd_conf *mdev, struct drbd_socket *sock)
+void *drbd_prepare_command(struct drbd_device *mdev, struct drbd_socket *sock)
 {
 	return conn_prepare_command(mdev->tconn, sock);
 }
@@ -682,7 +682,7 @@ int conn_send_command(struct drbd_tconn *tconn, struct drbd_socket *sock,
 	return err;
 }
 
-int drbd_send_command(struct drbd_conf *mdev, struct drbd_socket *sock,
+int drbd_send_command(struct drbd_device *mdev, struct drbd_socket *sock,
 		      enum drbd_packet cmd, unsigned int header_size,
 		      void *data, unsigned int size)
 {
@@ -714,7 +714,7 @@ int drbd_send_ping_ack(struct drbd_tconn *tconn)
 	return conn_send_command(tconn, sock, P_PING_ACK, 0, NULL, 0);
 }
 
-int drbd_send_sync_param(struct drbd_conf *mdev)
+int drbd_send_sync_param(struct drbd_device *mdev)
 {
 	struct drbd_socket *sock;
 	struct p_rs_param_95 *p;
@@ -824,7 +824,7 @@ int drbd_send_protocol(struct drbd_tconn *tconn)
 	return err;
 }
 
-int _drbd_send_uuids(struct drbd_conf *mdev, u64 uuid_flags)
+int _drbd_send_uuids(struct drbd_device *mdev, u64 uuid_flags)
 {
 	struct drbd_socket *sock;
 	struct p_uuids *p;
@@ -857,17 +857,17 @@ int _drbd_send_uuids(struct drbd_conf *mdev, u64 uuid_flags)
 	return drbd_send_command(mdev, sock, P_UUIDS, sizeof(*p), NULL, 0);
 }
 
-int drbd_send_uuids(struct drbd_conf *mdev)
+int drbd_send_uuids(struct drbd_device *mdev)
 {
 	return _drbd_send_uuids(mdev, 0);
 }
 
-int drbd_send_uuids_skip_initial_sync(struct drbd_conf *mdev)
+int drbd_send_uuids_skip_initial_sync(struct drbd_device *mdev)
 {
 	return _drbd_send_uuids(mdev, 8);
 }
 
-void drbd_print_uuids(struct drbd_conf *mdev, const char *text)
+void drbd_print_uuids(struct drbd_device *mdev, const char *text)
 {
 	if (get_ldev_if_state(mdev, D_NEGOTIATING)) {
 		u64 *uuid = mdev->ldev->md.uuid;
@@ -885,7 +885,7 @@ void drbd_print_uuids(struct drbd_conf *mdev, const char *text)
 	}
 }
 
-void drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev)
+void drbd_gen_and_send_sync_uuid(struct drbd_device *mdev)
 {
 	struct drbd_socket *sock;
 	struct p_rs_uuid *p;
@@ -910,7 +910,7 @@ void drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev)
 	}
 }
 
-int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags flags)
+int drbd_send_sizes(struct drbd_device *mdev, int trigger_reply, enum dds_flags flags)
 {
 	struct drbd_socket *sock;
 	struct p_sizes *p;
@@ -958,7 +958,7 @@ int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags fl
  * drbd_send_current_state() - Sends the drbd state to the peer
  * @mdev:	DRBD device.
  */
-int drbd_send_current_state(struct drbd_conf *mdev)
+int drbd_send_current_state(struct drbd_device *mdev)
 {
 	struct drbd_socket *sock;
 	struct p_state *p;
@@ -981,7 +981,7 @@ int drbd_send_current_state(struct drbd_conf *mdev)
  * between queuing and processing of the after_state_ch work, we still
  * want to send each intermediary state in the order it occurred.
  */
-int drbd_send_state(struct drbd_conf *mdev, union drbd_state state)
+int drbd_send_state(struct drbd_device *mdev, union drbd_state state)
 {
 	struct drbd_socket *sock;
 	struct p_state *p;
@@ -994,7 +994,7 @@ int drbd_send_state(struct drbd_conf *mdev, union drbd_state state)
 	return drbd_send_command(mdev, sock, P_STATE, sizeof(*p), NULL, 0);
 }
 
-int drbd_send_state_req(struct drbd_conf *mdev, union drbd_state mask, union drbd_state val)
+int drbd_send_state_req(struct drbd_device *mdev, union drbd_state mask, union drbd_state val)
 {
 	struct drbd_socket *sock;
 	struct p_req_state *p;
@@ -1024,7 +1024,7 @@ int conn_send_state_req(struct drbd_tconn *tconn, union drbd_state mask, union d
 	return conn_send_command(tconn, sock, cmd, sizeof(*p), NULL, 0);
 }
 
-void drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode)
+void drbd_send_sr_reply(struct drbd_device *mdev, enum drbd_state_rv retcode)
 {
 	struct drbd_socket *sock;
 	struct p_req_state_reply *p;
@@ -1068,7 +1068,7 @@ static void dcbp_set_pad_bits(struct p_compressed_bm *p, int n)
 	p->encoding = (p->encoding & (~0x7 << 4)) | (n << 4);
 }
 
-int fill_bitmap_rle_bits(struct drbd_conf *mdev,
+int fill_bitmap_rle_bits(struct drbd_device *mdev,
 			 struct p_compressed_bm *p,
 			 unsigned int size,
 			 struct bm_xfer_ctx *c)
@@ -1172,7 +1172,7 @@ int fill_bitmap_rle_bits(struct drbd_conf *mdev,
  * code upon failure.
  */
 static int
-send_bitmap_rle_or_plain(struct drbd_conf *mdev, struct bm_xfer_ctx *c)
+send_bitmap_rle_or_plain(struct drbd_device *mdev, struct bm_xfer_ctx *c)
 {
 	struct drbd_socket *sock = &mdev->tconn->data;
 	unsigned int header_size = drbd_header_size(mdev->tconn);
@@ -1228,7 +1228,7 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev, struct bm_xfer_ctx *c)
 }
 
 /* See the comment at receive_bitmap() */
-static int _drbd_send_bitmap(struct drbd_conf *mdev)
+static int _drbd_send_bitmap(struct drbd_device *mdev)
 {
 	struct bm_xfer_ctx c;
 	int err;
@@ -1265,7 +1265,7 @@ static int _drbd_send_bitmap(struct drbd_conf *mdev)
 	return err == 0;
 }
 
-int drbd_send_bitmap(struct drbd_conf *mdev)
+int drbd_send_bitmap(struct drbd_device *mdev)
 {
 	struct drbd_socket *sock = &mdev->tconn->data;
 	int err = -1;
@@ -1302,7 +1302,7 @@ void drbd_send_b_ack(struct drbd_tconn *tconn, u32 barrier_nr, u32 set_size)
  * @blksize:	size in byte, needs to be in big endian byte order
  * @block_id:	Id, big endian byte order
  */
-static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
+static int _drbd_send_ack(struct drbd_device *mdev, enum drbd_packet cmd,
 			  u64 sector, u32 blksize, u64 block_id)
 {
 	struct drbd_socket *sock;
@@ -1325,7 +1325,7 @@ static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 /* dp->sector and dp->block_id already/still in network byte order,
  * data_size is payload size according to dp->head,
  * and may need to be corrected for digest size. */
-void drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
+void drbd_send_ack_dp(struct drbd_device *mdev, enum drbd_packet cmd,
 		      struct p_data *dp, int data_size)
 {
 	if (mdev->tconn->peer_integrity_tfm)
@@ -1334,7 +1334,7 @@ void drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
 		       dp->block_id);
 }
 
-void drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
+void drbd_send_ack_rp(struct drbd_device *mdev, enum drbd_packet cmd,
 		      struct p_block_req *rp)
 {
 	_drbd_send_ack(mdev, cmd, rp->sector, rp->blksize, rp->block_id);
@@ -1346,7 +1346,7 @@ void drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
  * @cmd:	packet command code
  * @peer_req:	peer request
  */
-int drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
+int drbd_send_ack(struct drbd_device *mdev, enum drbd_packet cmd,
 		  struct drbd_peer_request *peer_req)
 {
 	return _drbd_send_ack(mdev, cmd,
@@ -1357,7 +1357,7 @@ int drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 /* This function misuses the block_id field to signal if the blocks
  * are is sync or not. */
-int drbd_send_ack_ex(struct drbd_conf *mdev, enum drbd_packet cmd,
+int drbd_send_ack_ex(struct drbd_device *mdev, enum drbd_packet cmd,
 		     sector_t sector, int blksize, u64 block_id)
 {
 	return _drbd_send_ack(mdev, cmd,
@@ -1366,7 +1366,7 @@ int drbd_send_ack_ex(struct drbd_conf *mdev, enum drbd_packet cmd,
 			      cpu_to_be64(block_id));
 }
 
-int drbd_send_drequest(struct drbd_conf *mdev, int cmd,
+int drbd_send_drequest(struct drbd_device *mdev, int cmd,
 		       sector_t sector, int size, u64 block_id)
 {
 	struct drbd_socket *sock;
@@ -1382,7 +1382,7 @@ int drbd_send_drequest(struct drbd_conf *mdev, int cmd,
 	return drbd_send_command(mdev, sock, cmd, sizeof(*p), NULL, 0);
 }
 
-int drbd_send_drequest_csum(struct drbd_conf *mdev, sector_t sector, int size,
+int drbd_send_drequest_csum(struct drbd_device *mdev, sector_t sector, int size,
 			    void *digest, int digest_size, enum drbd_packet cmd)
 {
 	struct drbd_socket *sock;
@@ -1401,7 +1401,7 @@ int drbd_send_drequest_csum(struct drbd_conf *mdev, sector_t sector, int size,
 				 digest, digest_size);
 }
 
-int drbd_send_ov_request(struct drbd_conf *mdev, sector_t sector, int size)
+int drbd_send_ov_request(struct drbd_device *mdev, sector_t sector, int size)
 {
 	struct drbd_socket *sock;
 	struct p_block_req *p;
@@ -1471,7 +1471,7 @@ static void drbd_update_congested(struct drbd_tconn *tconn)
  * As a workaround, we disable sendpage on pages
  * with page_count == 0 or PageSlab.
  */
-static int _drbd_no_send_page(struct drbd_conf *mdev, struct page *page,
+static int _drbd_no_send_page(struct drbd_device *mdev, struct page *page,
 			      int offset, size_t size, unsigned msg_flags)
 {
 	struct socket *socket;
@@ -1487,7 +1487,7 @@ static int _drbd_no_send_page(struct drbd_conf *mdev, struct page *page,
 	return err;
 }
 
-static int _drbd_send_page(struct drbd_conf *mdev, struct page *page,
+static int _drbd_send_page(struct drbd_device *mdev, struct page *page,
 		    int offset, size_t size, unsigned msg_flags)
 {
 	struct socket *socket = mdev->tconn->data.socket;
@@ -1536,7 +1536,7 @@ static int _drbd_send_page(struct drbd_conf *mdev, struct page *page,
 	return err;
 }
 
-static int _drbd_send_bio(struct drbd_conf *mdev, struct bio *bio)
+static int _drbd_send_bio(struct drbd_device *mdev, struct bio *bio)
 {
 	struct bio_vec bvec;
 	struct bvec_iter iter;
@@ -1555,7 +1555,7 @@ static int _drbd_send_bio(struct drbd_conf *mdev, struct bio *bio)
 	return 0;
 }
 
-static int _drbd_send_zc_bio(struct drbd_conf *mdev, struct bio *bio)
+static int _drbd_send_zc_bio(struct drbd_device *mdev, struct bio *bio)
 {
 	struct bio_vec bvec;
 	struct bvec_iter iter;
@@ -1573,7 +1573,7 @@ static int _drbd_send_zc_bio(struct drbd_conf *mdev, struct bio *bio)
 	return 0;
 }
 
-static int _drbd_send_zc_ee(struct drbd_conf *mdev,
+static int _drbd_send_zc_ee(struct drbd_device *mdev,
 			    struct drbd_peer_request *peer_req)
 {
 	struct page *page = peer_req->pages;
@@ -1593,7 +1593,7 @@ static int _drbd_send_zc_ee(struct drbd_conf *mdev,
 	return 0;
 }
 
-static u32 bio_flags_to_wire(struct drbd_conf *mdev, unsigned long bi_rw)
+static u32 bio_flags_to_wire(struct drbd_device *mdev, unsigned long bi_rw)
 {
 	if (mdev->tconn->agreed_pro_version >= 95)
 		return  (bi_rw & REQ_SYNC ? DP_RW_SYNC : 0) |
@@ -1607,7 +1607,7 @@ static u32 bio_flags_to_wire(struct drbd_conf *mdev, unsigned long bi_rw)
 /* Used to send write requests
  * R_PRIMARY -> Peer	(P_DATA)
  */
-int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
+int drbd_send_dblock(struct drbd_device *mdev, struct drbd_request *req)
 {
 	struct drbd_socket *sock;
 	struct p_data *p;
@@ -1679,7 +1679,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
  *  Peer       -> (diskless) R_PRIMARY   (P_DATA_REPLY)
  *  C_SYNC_SOURCE -> C_SYNC_TARGET         (P_RS_DATA_REPLY)
  */
-int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
+int drbd_send_block(struct drbd_device *mdev, enum drbd_packet cmd,
 		    struct drbd_peer_request *peer_req)
 {
 	struct drbd_socket *sock;
@@ -1708,7 +1708,7 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 	return err;
 }
 
-int drbd_send_out_of_sync(struct drbd_conf *mdev, struct drbd_request *req)
+int drbd_send_out_of_sync(struct drbd_device *mdev, struct drbd_request *req)
 {
 	struct drbd_socket *sock;
 	struct p_block_desc *p;
@@ -1829,7 +1829,7 @@ int drbd_send_all(struct drbd_tconn *tconn, struct socket *sock, void *buffer,
 
 static int drbd_open(struct block_device *bdev, fmode_t mode)
 {
-	struct drbd_conf *mdev = bdev->bd_disk->private_data;
+	struct drbd_device *mdev = bdev->bd_disk->private_data;
 	unsigned long flags;
 	int rv = 0;
 
@@ -1855,13 +1855,13 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 
 static void drbd_release(struct gendisk *gd, fmode_t mode)
 {
-	struct drbd_conf *mdev = gd->private_data;
+	struct drbd_device *mdev = gd->private_data;
 	mutex_lock(&drbd_main_mutex);
 	mdev->open_cnt--;
 	mutex_unlock(&drbd_main_mutex);
 }
 
-static void drbd_set_defaults(struct drbd_conf *mdev)
+static void drbd_set_defaults(struct drbd_device *mdev)
 {
 	/* Beware! The actual layout differs
 	 * between big endian and little endian */
@@ -1874,7 +1874,7 @@ static void drbd_set_defaults(struct drbd_conf *mdev)
 		} };
 }
 
-void drbd_init_set_defaults(struct drbd_conf *mdev)
+void drbd_init_set_defaults(struct drbd_device *mdev)
 {
 	/* the memset(,0,) did most of this.
 	 * note: only assignments, no allocation in here */
@@ -1949,7 +1949,7 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	mdev->local_max_bio_size = DRBD_MAX_BIO_SIZE_SAFE;
 }
 
-void drbd_mdev_cleanup(struct drbd_conf *mdev)
+void drbd_mdev_cleanup(struct drbd_device *mdev)
 {
 	int i;
 	if (mdev->tconn->receiver.t_state != NONE)
@@ -2132,7 +2132,7 @@ static struct notifier_block drbd_notifier = {
 	.notifier_call = drbd_notify_sys,
 };
 
-static void drbd_release_all_peer_reqs(struct drbd_conf *mdev)
+static void drbd_release_all_peer_reqs(struct drbd_device *mdev)
 {
 	int rr;
 
@@ -2160,7 +2160,7 @@ static void drbd_release_all_peer_reqs(struct drbd_conf *mdev)
 /* caution. no locking. */
 void drbd_minor_destroy(struct kref *kref)
 {
-	struct drbd_conf *mdev = container_of(kref, struct drbd_conf, kref);
+	struct drbd_device *mdev = container_of(kref, struct drbd_device, kref);
 	struct drbd_tconn *tconn = mdev->tconn;
 
 	del_timer_sync(&mdev->request_timer);
@@ -2219,7 +2219,7 @@ static void do_retry(struct work_struct *ws)
 	spin_unlock_irq(&retry->lock);
 
 	list_for_each_entry_safe(req, tmp, &writes, tl_requests) {
-		struct drbd_conf *mdev = req->w.mdev;
+		struct drbd_device *mdev = req->w.mdev;
 		struct bio *bio = req->master_bio;
 		unsigned long start_time = req->start_time;
 		bool expected;
@@ -2279,7 +2279,7 @@ void drbd_restart_request(struct drbd_request *req)
 static void drbd_cleanup(void)
 {
 	unsigned int i;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct drbd_tconn *tconn, *tmp;
 
 	unregister_reboot_notifier(&drbd_notifier);
@@ -2333,7 +2333,7 @@ static void drbd_cleanup(void)
  */
 static int drbd_congested(void *congested_data, int bdi_bits)
 {
-	struct drbd_conf *mdev = congested_data;
+	struct drbd_device *mdev = congested_data;
 	struct request_queue *q;
 	char reason = '-';
 	int r = 0;
@@ -2593,7 +2593,7 @@ void conn_destroy(struct kref *kref)
 	kfree(tconn);
 }
 
-int init_submitter(struct drbd_conf *mdev)
+int init_submitter(struct drbd_device *mdev)
 {
 	/* opencoded create_singlethread_workqueue(),
 	 * to be able to say "drbd%d", ..., minor */
@@ -2610,7 +2610,7 @@ int init_submitter(struct drbd_conf *mdev)
 
 enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor, int vnr)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct gendisk *disk;
 	struct request_queue *q;
 	int vnr_got = vnr;
@@ -2622,7 +2622,7 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 		return ERR_MINOR_EXISTS;
 
 	/* GFP_KERNEL, we are outside of all write-out paths */
-	mdev = kzalloc(sizeof(struct drbd_conf), GFP_KERNEL);
+	mdev = kzalloc(sizeof(struct drbd_device), GFP_KERNEL);
 	if (!mdev)
 		return ERR_NOMEM;
 
@@ -2845,7 +2845,7 @@ void drbd_free_sock(struct drbd_tconn *tconn)
 
 void conn_md_sync(struct drbd_tconn *tconn)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 
 	rcu_read_lock();
@@ -2884,7 +2884,7 @@ struct meta_data_on_disk {
 
 
 
-void drbd_md_write(struct drbd_conf *mdev, void *b)
+void drbd_md_write(struct drbd_device *mdev, void *b)
 {
 	struct meta_data_on_disk *buffer = b;
 	sector_t sector;
@@ -2924,7 +2924,7 @@ void drbd_md_write(struct drbd_conf *mdev, void *b)
  * drbd_md_sync() - Writes the meta data super block if the MD_DIRTY flag bit is set
  * @mdev:	DRBD device.
  */
-void drbd_md_sync(struct drbd_conf *mdev)
+void drbd_md_sync(struct drbd_device *mdev)
 {
 	struct meta_data_on_disk *buffer;
 
@@ -2957,7 +2957,7 @@ out:
 	put_ldev(mdev);
 }
 
-static int check_activity_log_stripe_size(struct drbd_conf *mdev,
+static int check_activity_log_stripe_size(struct drbd_device *mdev,
 		struct meta_data_on_disk *on_disk,
 		struct drbd_md *in_core)
 {
@@ -3002,7 +3002,7 @@ err:
 	return -EINVAL;
 }
 
-static int check_offsets_and_sizes(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
+static int check_offsets_and_sizes(struct drbd_device *mdev, struct drbd_backing_dev *bdev)
 {
 	sector_t capacity = drbd_get_capacity(bdev->md_bdev);
 	struct drbd_md *in_core = &bdev->md;
@@ -3093,7 +3093,7 @@ err:
  * Called exactly once during drbd_adm_attach(), while still being D_DISKLESS,
  * even before @bdev is assigned to @mdev->ldev.
  */
-int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
+int drbd_md_read(struct drbd_device *mdev, struct drbd_backing_dev *bdev)
 {
 	struct meta_data_on_disk *buffer;
 	u32 magic, flags;
@@ -3198,7 +3198,7 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
  * timer that ensures that within five seconds you have to call drbd_md_sync().
  */
 #ifdef DEBUG
-void drbd_md_mark_dirty_(struct drbd_conf *mdev, unsigned int line, const char *func)
+void drbd_md_mark_dirty_(struct drbd_device *mdev, unsigned int line, const char *func)
 {
 	if (!test_and_set_bit(MD_DIRTY, &mdev->flags)) {
 		mod_timer(&mdev->md_sync_timer, jiffies + HZ);
@@ -3207,14 +3207,14 @@ void drbd_md_mark_dirty_(struct drbd_conf *mdev, unsigned int line, const char *
 	}
 }
 #else
-void drbd_md_mark_dirty(struct drbd_conf *mdev)
+void drbd_md_mark_dirty(struct drbd_device *mdev)
 {
 	if (!test_and_set_bit(MD_DIRTY, &mdev->flags))
 		mod_timer(&mdev->md_sync_timer, jiffies + 5*HZ);
 }
 #endif
 
-void drbd_uuid_move_history(struct drbd_conf *mdev) __must_hold(local)
+void drbd_uuid_move_history(struct drbd_device *mdev) __must_hold(local)
 {
 	int i;
 
@@ -3222,7 +3222,7 @@ void drbd_uuid_move_history(struct drbd_conf *mdev) __must_hold(local)
 		mdev->ldev->md.uuid[i+1] = mdev->ldev->md.uuid[i];
 }
 
-void __drbd_uuid_set(struct drbd_conf *mdev, int idx, u64 val) __must_hold(local)
+void __drbd_uuid_set(struct drbd_device *mdev, int idx, u64 val) __must_hold(local)
 {
 	if (idx == UI_CURRENT) {
 		if (mdev->state.role == R_PRIMARY)
@@ -3237,7 +3237,7 @@ void __drbd_uuid_set(struct drbd_conf *mdev, int idx, u64 val) __must_hold(local
 	drbd_md_mark_dirty(mdev);
 }
 
-void _drbd_uuid_set(struct drbd_conf *mdev, int idx, u64 val) __must_hold(local)
+void _drbd_uuid_set(struct drbd_device *mdev, int idx, u64 val) __must_hold(local)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&mdev->ldev->md.uuid_lock, flags);
@@ -3245,7 +3245,7 @@ void _drbd_uuid_set(struct drbd_conf *mdev, int idx, u64 val) __must_hold(local)
 	spin_unlock_irqrestore(&mdev->ldev->md.uuid_lock, flags);
 }
 
-void drbd_uuid_set(struct drbd_conf *mdev, int idx, u64 val) __must_hold(local)
+void drbd_uuid_set(struct drbd_device *mdev, int idx, u64 val) __must_hold(local)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&mdev->ldev->md.uuid_lock, flags);
@@ -3264,7 +3264,7 @@ void drbd_uuid_set(struct drbd_conf *mdev, int idx, u64 val) __must_hold(local)
  * Creates a new current UUID, and rotates the old current UUID into
  * the bitmap slot. Causes an incremental resync upon next connect.
  */
-void drbd_uuid_new_current(struct drbd_conf *mdev) __must_hold(local)
+void drbd_uuid_new_current(struct drbd_device *mdev) __must_hold(local)
 {
 	u64 val;
 	unsigned long long bm_uuid;
@@ -3286,7 +3286,7 @@ void drbd_uuid_new_current(struct drbd_conf *mdev) __must_hold(local)
 	drbd_md_sync(mdev);
 }
 
-void drbd_uuid_set_bm(struct drbd_conf *mdev, u64 val) __must_hold(local)
+void drbd_uuid_set_bm(struct drbd_device *mdev, u64 val) __must_hold(local)
 {
 	unsigned long flags;
 	if (mdev->ldev->md.uuid[UI_BITMAP] == 0 && val == 0)
@@ -3315,7 +3315,7 @@ void drbd_uuid_set_bm(struct drbd_conf *mdev, u64 val) __must_hold(local)
  *
  * Sets all bits in the bitmap and writes the whole bitmap to stable storage.
  */
-int drbd_bmio_set_n_write(struct drbd_conf *mdev)
+int drbd_bmio_set_n_write(struct drbd_device *mdev)
 {
 	int rv = -EIO;
 
@@ -3343,7 +3343,7 @@ int drbd_bmio_set_n_write(struct drbd_conf *mdev)
  *
  * Clears all bits in the bitmap and writes the whole bitmap to stable storage.
  */
-int drbd_bmio_clear_n_write(struct drbd_conf *mdev)
+int drbd_bmio_clear_n_write(struct drbd_device *mdev)
 {
 	int rv = -EIO;
 
@@ -3360,7 +3360,7 @@ int drbd_bmio_clear_n_write(struct drbd_conf *mdev)
 static int w_bitmap_io(struct drbd_work *w, int unused)
 {
 	struct bm_io_work *work = container_of(w, struct bm_io_work, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	int rv = -EIO;
 
 	D_ASSERT(atomic_read(&mdev->ap_bio_cnt) == 0);
@@ -3385,7 +3385,7 @@ static int w_bitmap_io(struct drbd_work *w, int unused)
 	return 0;
 }
 
-void drbd_ldev_destroy(struct drbd_conf *mdev)
+void drbd_ldev_destroy(struct drbd_device *mdev)
 {
 	lc_destroy(mdev->resync);
 	mdev->resync = NULL;
@@ -3400,7 +3400,7 @@ void drbd_ldev_destroy(struct drbd_conf *mdev)
 
 static int w_go_diskless(struct drbd_work *w, int unused)
 {
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 
 	D_ASSERT(mdev->state.disk == D_FAILED);
 	/* we cannot assert local_cnt == 0 here, as get_ldev_if_state will
@@ -3451,9 +3451,9 @@ static int w_go_diskless(struct drbd_work *w, int unused)
  * called from worker context. It MUST NOT be used while a previous such
  * work is still pending!
  */
-void drbd_queue_bitmap_io(struct drbd_conf *mdev,
-			  int (*io_fn)(struct drbd_conf *),
-			  void (*done)(struct drbd_conf *, int),
+void drbd_queue_bitmap_io(struct drbd_device *mdev,
+			  int (*io_fn)(struct drbd_device *),
+			  void (*done)(struct drbd_device *, int),
 			  char *why, enum bm_flag flags)
 {
 	D_ASSERT(current == mdev->tconn->worker.task);
@@ -3488,7 +3488,7 @@ void drbd_queue_bitmap_io(struct drbd_conf *mdev,
  * freezes application IO while that the actual IO operations runs. This
  * functions MAY NOT be called from worker context.
  */
-int drbd_bitmap_io(struct drbd_conf *mdev, int (*io_fn)(struct drbd_conf *),
+int drbd_bitmap_io(struct drbd_device *mdev, int (*io_fn)(struct drbd_device *),
 		char *why, enum bm_flag flags)
 {
 	int rv;
@@ -3508,7 +3508,7 @@ int drbd_bitmap_io(struct drbd_conf *mdev, int (*io_fn)(struct drbd_conf *),
 	return rv;
 }
 
-void drbd_md_set_flag(struct drbd_conf *mdev, int flag) __must_hold(local)
+void drbd_md_set_flag(struct drbd_device *mdev, int flag) __must_hold(local)
 {
 	if ((mdev->ldev->md.flags & flag) != flag) {
 		drbd_md_mark_dirty(mdev);
@@ -3516,7 +3516,7 @@ void drbd_md_set_flag(struct drbd_conf *mdev, int flag) __must_hold(local)
 	}
 }
 
-void drbd_md_clear_flag(struct drbd_conf *mdev, int flag) __must_hold(local)
+void drbd_md_clear_flag(struct drbd_device *mdev, int flag) __must_hold(local)
 {
 	if ((mdev->ldev->md.flags & flag) != 0) {
 		drbd_md_mark_dirty(mdev);
@@ -3530,7 +3530,7 @@ int drbd_md_test_flag(struct drbd_backing_dev *bdev, int flag)
 
 static void md_sync_timer_fn(unsigned long data)
 {
-	struct drbd_conf *mdev = (struct drbd_conf *) data;
+	struct drbd_device *mdev = (struct drbd_device *) data;
 
 	/* must not double-queue! */
 	if (list_empty(&mdev->md_sync_work.list))
@@ -3539,7 +3539,7 @@ static void md_sync_timer_fn(unsigned long data)
 
 static int w_md_sync(struct drbd_work *w, int unused)
 {
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 
 	dev_warn(DEV, "md_sync_timer expired! Worker calls drbd_md_sync().\n");
 #ifdef DEBUG
@@ -3626,7 +3626,7 @@ const char *cmdname(enum drbd_packet cmd)
  * @i:		the struct drbd_interval embedded in struct drbd_request or
  *		struct drbd_peer_request
  */
-int drbd_wait_misc(struct drbd_conf *mdev, struct drbd_interval *i)
+int drbd_wait_misc(struct drbd_device *mdev, struct drbd_interval *i)
 {
 	struct net_conf *nc;
 	DEFINE_WAIT(wait);
@@ -3704,7 +3704,7 @@ _drbd_fault_str(unsigned int type) {
 }
 
 unsigned int
-_drbd_insert_fault(struct drbd_conf *mdev, unsigned int type)
+_drbd_insert_fault(struct drbd_device *mdev, unsigned int type)
 {
 	static struct fault_random_state rrs = {0, 0};
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 7dd36db..9edc201 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -103,7 +103,7 @@ static struct drbd_config_context {
 	/* pointer into reply buffer */
 	struct drbd_genlmsghdr *reply_dh;
 	/* resolved from attributes, if possible */
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct drbd_tconn *tconn;
 } adm_ctx;
 
@@ -313,7 +313,7 @@ static void setup_khelper_env(struct drbd_tconn *tconn, char **envp)
 	snprintf(envp[3], 20, "DRBD_PEER_AF=%s", afs);
 }
 
-int drbd_khelper(struct drbd_conf *mdev, char *cmd)
+int drbd_khelper(struct drbd_device *mdev, char *cmd)
 {
 	char *envp[] = { "HOME=/",
 			"TERM=linux",
@@ -400,7 +400,7 @@ int conn_khelper(struct drbd_tconn *tconn, char *cmd)
 static enum drbd_fencing_p highest_fencing_policy(struct drbd_tconn *tconn)
 {
 	enum drbd_fencing_p fp = FP_NOT_AVAIL;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 
 	rcu_read_lock();
@@ -534,7 +534,7 @@ void conn_try_outdate_peer_async(struct drbd_tconn *tconn)
 }
 
 enum drbd_state_rv
-drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
+drbd_set_role(struct drbd_device *mdev, enum drbd_role new_role, int force)
 {
 	const int max_tries = 4;
 	enum drbd_state_rv rv = SS_UNKNOWN_ERROR;
@@ -729,7 +729,7 @@ out:
  *  Activity log size used to be fixed 32kB,
  *  but is about to become configurable.
  */
-static void drbd_md_set_sector_offsets(struct drbd_conf *mdev,
+static void drbd_md_set_sector_offsets(struct drbd_device *mdev,
 				       struct drbd_backing_dev *bdev)
 {
 	sector_t md_size_sect = 0;
@@ -807,7 +807,7 @@ char *ppsize(char *buf, unsigned long long size)
  * and can be long lived.
  * This changes an mdev->flag, is triggered by drbd internals,
  * and should be short-lived. */
-void drbd_suspend_io(struct drbd_conf *mdev)
+void drbd_suspend_io(struct drbd_device *mdev)
 {
 	set_bit(SUSPEND_IO, &mdev->flags);
 	if (drbd_suspended(mdev))
@@ -815,7 +815,7 @@ void drbd_suspend_io(struct drbd_conf *mdev)
 	wait_event(mdev->misc_wait, !atomic_read(&mdev->ap_bio_cnt));
 }
 
-void drbd_resume_io(struct drbd_conf *mdev)
+void drbd_resume_io(struct drbd_device *mdev)
 {
 	clear_bit(SUSPEND_IO, &mdev->flags);
 	wake_up(&mdev->misc_wait);
@@ -829,7 +829,7 @@ void drbd_resume_io(struct drbd_conf *mdev)
  * You should call drbd_md_sync() after calling this function.
  */
 enum determine_dev_size
-drbd_determine_dev_size(struct drbd_conf *mdev, enum dds_flags flags, struct resize_parms *rs) __must_hold(local)
+drbd_determine_dev_size(struct drbd_device *mdev, enum dds_flags flags, struct resize_parms *rs) __must_hold(local)
 {
 	sector_t prev_first_sect, prev_size; /* previous meta location */
 	sector_t la_size_sect, u_size;
@@ -979,7 +979,7 @@ drbd_determine_dev_size(struct drbd_conf *mdev, enum dds_flags flags, struct res
 }
 
 sector_t
-drbd_new_dev_size(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
+drbd_new_dev_size(struct drbd_device *mdev, struct drbd_backing_dev *bdev,
 		  sector_t u_size, int assume_peer_has_space)
 {
 	sector_t p_size = mdev->p_size;   /* partner's disk size. */
@@ -1033,7 +1033,7 @@ drbd_new_dev_size(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
  * failed, and 0 on success. You should call drbd_md_sync() after you called
  * this function.
  */
-static int drbd_check_al_size(struct drbd_conf *mdev, struct disk_conf *dc)
+static int drbd_check_al_size(struct drbd_device *mdev, struct disk_conf *dc)
 {
 	struct lru_cache *n, *t;
 	struct lc_element *e;
@@ -1078,7 +1078,7 @@ static int drbd_check_al_size(struct drbd_conf *mdev, struct disk_conf *dc)
 	return 0;
 }
 
-static void drbd_setup_queue_param(struct drbd_conf *mdev, unsigned int max_bio_size)
+static void drbd_setup_queue_param(struct drbd_device *mdev, unsigned int max_bio_size)
 {
 	struct request_queue * const q = mdev->rq_queue;
 	unsigned int max_hw_sectors = max_bio_size >> 9;
@@ -1115,7 +1115,7 @@ static void drbd_setup_queue_param(struct drbd_conf *mdev, unsigned int max_bio_
 	}
 }
 
-void drbd_reconsider_max_bio_size(struct drbd_conf *mdev)
+void drbd_reconsider_max_bio_size(struct drbd_device *mdev)
 {
 	unsigned int now, new, local, peer;
 
@@ -1180,7 +1180,7 @@ static void conn_reconfig_done(struct drbd_tconn *tconn)
 }
 
 /* Make sure IO is suspended before calling this function(). */
-static void drbd_suspend_al(struct drbd_conf *mdev)
+static void drbd_suspend_al(struct drbd_device *mdev)
 {
 	int s = 0;
 
@@ -1238,7 +1238,7 @@ static unsigned int drbd_al_extents_max(struct drbd_backing_dev *bdev)
 int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct disk_conf *new_disk_conf, *old_disk_conf;
 	struct fifo_buffer *old_plan = NULL, *new_plan = NULL;
 	int err, fifo_size;
@@ -1366,7 +1366,7 @@ success:
 
 int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int err;
 	enum drbd_ret_code retcode;
 	enum determine_dev_size dd;
@@ -1800,7 +1800,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-static int adm_detach(struct drbd_conf *mdev, int force)
+static int adm_detach(struct drbd_device *mdev, int force)
 {
 	enum drbd_state_rv retcode;
 	int ret;
@@ -1862,7 +1862,7 @@ out:
 
 static bool conn_resync_running(struct drbd_tconn *tconn)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	bool rv = false;
 	int vnr;
 
@@ -1883,7 +1883,7 @@ static bool conn_resync_running(struct drbd_tconn *tconn)
 
 static bool conn_ov_running(struct drbd_tconn *tconn)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	bool rv = false;
 	int vnr;
 
@@ -1903,7 +1903,7 @@ static bool conn_ov_running(struct drbd_tconn *tconn)
 static enum drbd_ret_code
 _check_net_options(struct drbd_tconn *tconn, struct net_conf *old_conf, struct net_conf *new_conf)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int i;
 
 	if (old_conf && tconn->cstate == C_WF_REPORT_PARAMS && tconn->agreed_pro_version < 100) {
@@ -1947,7 +1947,7 @@ static enum drbd_ret_code
 check_net_options(struct drbd_tconn *tconn, struct net_conf *new_conf)
 {
 	static enum drbd_ret_code rv;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int i;
 
 	rcu_read_lock();
@@ -2139,7 +2139,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct net_conf *old_conf, *new_conf = NULL;
 	struct crypto crypto = { };
 	struct drbd_tconn *tconn;
@@ -2349,7 +2349,7 @@ int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-void resync_after_online_grow(struct drbd_conf *mdev)
+void resync_after_online_grow(struct drbd_device *mdev)
 {
 	int iass; /* I am sync source */
 
@@ -2369,7 +2369,7 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 {
 	struct disk_conf *old_disk_conf, *new_disk_conf = NULL;
 	struct resize_parms rs;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	enum drbd_ret_code retcode;
 	enum determine_dev_size dd;
 	bool change_al_layout = false;
@@ -2535,7 +2535,7 @@ fail:
 
 int drbd_adm_invalidate(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int retcode; /* enum drbd_ret_code rsp. enum drbd_state_rv */
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
@@ -2590,7 +2590,7 @@ out:
 	return 0;
 }
 
-static int drbd_bmio_set_susp_al(struct drbd_conf *mdev)
+static int drbd_bmio_set_susp_al(struct drbd_device *mdev)
 {
 	int rv;
 
@@ -2602,7 +2602,7 @@ static int drbd_bmio_set_susp_al(struct drbd_conf *mdev)
 int drbd_adm_invalidate_peer(struct sk_buff *skb, struct genl_info *info)
 {
 	int retcode; /* drbd_ret_code, drbd_state_rv */
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
 	if (!adm_ctx.reply_skb)
@@ -2692,7 +2692,7 @@ int drbd_adm_suspend_io(struct sk_buff *skb, struct genl_info *info)
 
 int drbd_adm_resume_io(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int retcode; /* enum drbd_ret_code rsp. enum drbd_state_rv */
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
@@ -2752,7 +2752,7 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
-int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
+int nla_put_status_info(struct sk_buff *skb, struct drbd_device *mdev,
 		const struct sib_info *sib)
 {
 	struct state_info *si = NULL; /* for sizeof(si->member); */
@@ -2896,7 +2896,7 @@ out:
 
 int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct drbd_genlmsghdr *dh;
 	struct drbd_tconn *pos = (struct drbd_tconn*)cb->args[0];
 	struct drbd_tconn *tconn = NULL;
@@ -3096,7 +3096,7 @@ out:
 
 int drbd_adm_start_ov(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	enum drbd_ret_code retcode;
 	struct start_ov_parms parms;
 
@@ -3137,7 +3137,7 @@ out:
 
 int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	enum drbd_ret_code retcode;
 	int skip_initial_sync = 0;
 	int err;
@@ -3301,7 +3301,7 @@ out:
 	return 0;
 }
 
-static enum drbd_ret_code adm_delete_minor(struct drbd_conf *mdev)
+static enum drbd_ret_code adm_delete_minor(struct drbd_device *mdev)
 {
 	if (mdev->state.disk == D_DISKLESS &&
 	    /* no need to be mdev->state.conn == C_STANDALONE &&
@@ -3340,7 +3340,7 @@ out:
 int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 {
 	int retcode; /* enum drbd_ret_code rsp. enum drbd_state_rv */
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	unsigned i;
 
 	retcode = drbd_adm_prepare(skb, info, 0);
@@ -3440,7 +3440,7 @@ out:
 	return 0;
 }
 
-void drbd_bcast_event(struct drbd_conf *mdev, const struct sib_info *sib)
+void drbd_bcast_event(struct drbd_device *mdev, const struct sib_info *sib)
 {
 	static atomic_t drbd_genl_seq = ATOMIC_INIT(2); /* two. */
 	struct sk_buff *msg;
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index bf31d41..384d61f 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -66,7 +66,7 @@ void seq_printf_with_thousands_grouping(struct seq_file *seq, long v)
  *	[=====>..............] 33.5% (23456/123456)
  *	finish: 2:20:20 speed: 6,345 (6,456) K/sec
  */
-static void drbd_syncer_progress(struct drbd_conf *mdev, struct seq_file *seq)
+static void drbd_syncer_progress(struct drbd_device *mdev, struct seq_file *seq)
 {
 	unsigned long db, dt, dbdt, rt, rs_left;
 	unsigned int res;
@@ -202,7 +202,7 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 {
 	int i, prev_i = -1;
 	const char *sn;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct net_conf *nc;
 	char wp;
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index a3716a4..cd43fac 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -64,7 +64,7 @@ enum finish_epoch {
 
 static int drbd_do_features(struct drbd_tconn *tconn);
 static int drbd_do_auth(struct drbd_tconn *tconn);
-static int drbd_disconnected(struct drbd_conf *mdev);
+static int drbd_disconnected(struct drbd_device *mdev);
 
 static enum finish_epoch drbd_may_finish_epoch(struct drbd_tconn *, struct drbd_epoch *, enum epoch_event);
 static int e_end_block(struct drbd_work *, int);
@@ -151,7 +151,7 @@ static void page_chain_add(struct page **head,
 	*head = chain_first;
 }
 
-static struct page *__drbd_alloc_pages(struct drbd_conf *mdev,
+static struct page *__drbd_alloc_pages(struct drbd_device *mdev,
 				       unsigned int number)
 {
 	struct page *page = NULL;
@@ -197,7 +197,7 @@ static struct page *__drbd_alloc_pages(struct drbd_conf *mdev,
 	return NULL;
 }
 
-static void reclaim_finished_net_peer_reqs(struct drbd_conf *mdev,
+static void reclaim_finished_net_peer_reqs(struct drbd_device *mdev,
 					   struct list_head *to_be_freed)
 {
 	struct drbd_peer_request *peer_req;
@@ -216,7 +216,7 @@ static void reclaim_finished_net_peer_reqs(struct drbd_conf *mdev,
 	}
 }
 
-static void drbd_kick_lo_and_reclaim_net(struct drbd_conf *mdev)
+static void drbd_kick_lo_and_reclaim_net(struct drbd_device *mdev)
 {
 	LIST_HEAD(reclaimed);
 	struct drbd_peer_request *peer_req, *t;
@@ -241,7 +241,7 @@ static void drbd_kick_lo_and_reclaim_net(struct drbd_conf *mdev)
  *
  * Returns a page chain linked via page->private.
  */
-struct page *drbd_alloc_pages(struct drbd_conf *mdev, unsigned int number,
+struct page *drbd_alloc_pages(struct drbd_device *mdev, unsigned int number,
 			      bool retry)
 {
 	struct page *page = NULL;
@@ -291,7 +291,7 @@ struct page *drbd_alloc_pages(struct drbd_conf *mdev, unsigned int number,
  * Is also used from inside an other spin_lock_irq(&mdev->tconn->req_lock);
  * Either links the page chain back to the global pool,
  * or returns all pages to the system. */
-static void drbd_free_pages(struct drbd_conf *mdev, struct page *page, int is_net)
+static void drbd_free_pages(struct drbd_device *mdev, struct page *page, int is_net)
 {
 	atomic_t *a = is_net ? &mdev->pp_in_use_by_net : &mdev->pp_in_use;
 	int i;
@@ -331,7 +331,7 @@ You must not have the req_lock:
 */
 
 struct drbd_peer_request *
-drbd_alloc_peer_req(struct drbd_conf *mdev, u64 id, sector_t sector,
+drbd_alloc_peer_req(struct drbd_device *mdev, u64 id, sector_t sector,
 		    unsigned int data_size, gfp_t gfp_mask) __must_hold(local)
 {
 	struct drbd_peer_request *peer_req;
@@ -378,7 +378,7 @@ drbd_alloc_peer_req(struct drbd_conf *mdev, u64 id, sector_t sector,
 	return NULL;
 }
 
-void __drbd_free_peer_req(struct drbd_conf *mdev, struct drbd_peer_request *peer_req,
+void __drbd_free_peer_req(struct drbd_device *mdev, struct drbd_peer_request *peer_req,
 		       int is_net)
 {
 	if (peer_req->flags & EE_HAS_DIGEST)
@@ -389,7 +389,7 @@ void __drbd_free_peer_req(struct drbd_conf *mdev, struct drbd_peer_request *peer
 	mempool_free(peer_req, drbd_ee_mempool);
 }
 
-int drbd_free_peer_reqs(struct drbd_conf *mdev, struct list_head *list)
+int drbd_free_peer_reqs(struct drbd_device *mdev, struct list_head *list)
 {
 	LIST_HEAD(work_list);
 	struct drbd_peer_request *peer_req, *t;
@@ -410,7 +410,7 @@ int drbd_free_peer_reqs(struct drbd_conf *mdev, struct list_head *list)
 /*
  * See also comments in _req_mod(,BARRIER_ACKED) and receive_Barrier.
  */
-static int drbd_finish_peer_reqs(struct drbd_conf *mdev)
+static int drbd_finish_peer_reqs(struct drbd_device *mdev)
 {
 	LIST_HEAD(work_list);
 	LIST_HEAD(reclaimed);
@@ -443,7 +443,7 @@ static int drbd_finish_peer_reqs(struct drbd_conf *mdev)
 	return err;
 }
 
-static void _drbd_wait_ee_list_empty(struct drbd_conf *mdev,
+static void _drbd_wait_ee_list_empty(struct drbd_device *mdev,
 				     struct list_head *head)
 {
 	DEFINE_WAIT(wait);
@@ -459,7 +459,7 @@ static void _drbd_wait_ee_list_empty(struct drbd_conf *mdev,
 	}
 }
 
-static void drbd_wait_ee_list_empty(struct drbd_conf *mdev,
+static void drbd_wait_ee_list_empty(struct drbd_device *mdev,
 				    struct list_head *head)
 {
 	spin_lock_irq(&mdev->tconn->req_lock);
@@ -831,7 +831,7 @@ static int drbd_socket_okay(struct socket **sock)
 }
 /* Gets called if a connection is established, or if a new minor gets created
    in a connection */
-int drbd_connected(struct drbd_conf *mdev)
+int drbd_connected(struct drbd_device *mdev)
 {
 	int err;
 
@@ -867,7 +867,7 @@ int drbd_connected(struct drbd_conf *mdev)
 static int conn_connect(struct drbd_tconn *tconn)
 {
 	struct drbd_socket sock, msock;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct net_conf *nc;
 	int vnr, timeout, h, ok;
 	bool discard_my_data;
@@ -1145,7 +1145,7 @@ static int drbd_recv_header(struct drbd_tconn *tconn, struct packet_info *pi)
 static void drbd_flush(struct drbd_tconn *tconn)
 {
 	int rv;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 
 	if (tconn->write_ordering >= WO_bdev_flush) {
@@ -1260,7 +1260,7 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_tconn *tconn,
 void drbd_bump_write_ordering(struct drbd_tconn *tconn, enum write_ordering_e wo)
 {
 	struct disk_conf *dc;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	enum write_ordering_e pwo;
 	int vnr;
 	static char *write_ordering_str[] = {
@@ -1306,7 +1306,7 @@ void drbd_bump_write_ordering(struct drbd_tconn *tconn, enum write_ordering_e wo
  *  on certain Xen deployments.
  */
 /* TODO allocate from our own bio_set. */
-int drbd_submit_peer_request(struct drbd_conf *mdev,
+int drbd_submit_peer_request(struct drbd_device *mdev,
 			     struct drbd_peer_request *peer_req,
 			     const unsigned rw, const int fault_type)
 {
@@ -1386,7 +1386,7 @@ fail:
 	return err;
 }
 
-static void drbd_remove_epoch_entry_interval(struct drbd_conf *mdev,
+static void drbd_remove_epoch_entry_interval(struct drbd_device *mdev,
 					     struct drbd_peer_request *peer_req)
 {
 	struct drbd_interval *i = &peer_req->i;
@@ -1401,7 +1401,7 @@ static void drbd_remove_epoch_entry_interval(struct drbd_conf *mdev,
 
 void conn_wait_active_ee_empty(struct drbd_tconn *tconn)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 
 	rcu_read_lock();
@@ -1485,7 +1485,7 @@ static int receive_Barrier(struct drbd_tconn *tconn, struct packet_info *pi)
 /* used from receive_RSDataReply (recv_resync_read)
  * and from receive_Data */
 static struct drbd_peer_request *
-read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
+read_in_block(struct drbd_device *mdev, u64 id, sector_t sector,
 	      int data_size) __must_hold(local)
 {
 	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
@@ -1568,7 +1568,7 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 /* drbd_drain_block() just takes a data block
  * out of the socket input buffer, and discards it.
  */
-static int drbd_drain_block(struct drbd_conf *mdev, int data_size)
+static int drbd_drain_block(struct drbd_device *mdev, int data_size)
 {
 	struct page *page;
 	int err = 0;
@@ -1593,7 +1593,7 @@ static int drbd_drain_block(struct drbd_conf *mdev, int data_size)
 	return err;
 }
 
-static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
+static int recv_dless_read(struct drbd_device *mdev, struct drbd_request *req,
 			   sector_t sector, int data_size)
 {
 	struct bio_vec bvec;
@@ -1649,7 +1649,7 @@ static int e_end_resync_block(struct drbd_work *w, int unused)
 {
 	struct drbd_peer_request *peer_req =
 		container_of(w, struct drbd_peer_request, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	sector_t sector = peer_req->i.sector;
 	int err;
 
@@ -1669,7 +1669,7 @@ static int e_end_resync_block(struct drbd_work *w, int unused)
 	return err;
 }
 
-static int recv_resync_read(struct drbd_conf *mdev, sector_t sector, int data_size) __releases(local)
+static int recv_resync_read(struct drbd_device *mdev, sector_t sector, int data_size) __releases(local)
 {
 	struct drbd_peer_request *peer_req;
 
@@ -1706,7 +1706,7 @@ fail:
 }
 
 static struct drbd_request *
-find_request(struct drbd_conf *mdev, struct rb_root *root, u64 id,
+find_request(struct drbd_device *mdev, struct rb_root *root, u64 id,
 	     sector_t sector, bool missing_ok, const char *func)
 {
 	struct drbd_request *req;
@@ -1724,7 +1724,7 @@ find_request(struct drbd_conf *mdev, struct rb_root *root, u64 id,
 
 static int receive_DataReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct drbd_request *req;
 	sector_t sector;
 	int err;
@@ -1757,7 +1757,7 @@ static int receive_DataReply(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int receive_RSDataReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	sector_t sector;
 	int err;
 	struct p_data *p = pi->data;
@@ -1788,7 +1788,7 @@ static int receive_RSDataReply(struct drbd_tconn *tconn, struct packet_info *pi)
 	return err;
 }
 
-static void restart_conflicting_writes(struct drbd_conf *mdev,
+static void restart_conflicting_writes(struct drbd_device *mdev,
 				       sector_t sector, int size)
 {
 	struct drbd_interval *i;
@@ -1814,7 +1814,7 @@ static int e_end_block(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req =
 		container_of(w, struct drbd_peer_request, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	sector_t sector = peer_req->i.sector;
 	int err = 0, pcmd;
 
@@ -1853,7 +1853,7 @@ static int e_end_block(struct drbd_work *w, int cancel)
 
 static int e_send_ack(struct drbd_work *w, enum drbd_packet ack)
 {
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	struct drbd_peer_request *peer_req =
 		container_of(w, struct drbd_peer_request, w);
 	int err;
@@ -1913,7 +1913,7 @@ static inline int overlaps(sector_t s1, int l1, sector_t s2, int l2)
 }
 
 /* maybe change sync_ee into interval trees as well? */
-static bool overlapping_resync_write(struct drbd_conf *mdev, struct drbd_peer_request *peer_req)
+static bool overlapping_resync_write(struct drbd_device *mdev, struct drbd_peer_request *peer_req)
 {
 	struct drbd_peer_request *rs_req;
 	bool rv = 0;
@@ -1952,7 +1952,7 @@ static bool overlapping_resync_write(struct drbd_conf *mdev, struct drbd_peer_re
  *
  * returns 0 if we may process the packet,
  * -ERESTARTSYS if we were interrupted (by disconnect signal). */
-static int wait_for_and_update_peer_seq(struct drbd_conf *mdev, const u32 peer_seq)
+static int wait_for_and_update_peer_seq(struct drbd_device *mdev, const u32 peer_seq)
 {
 	DEFINE_WAIT(wait);
 	long timeout;
@@ -2002,7 +2002,7 @@ static int wait_for_and_update_peer_seq(struct drbd_conf *mdev, const u32 peer_s
 /* see also bio_flags_to_wire()
  * DRBD_REQ_*, because we need to semantically map the flags to data packet
  * flags and back. We may replicate to other kernel versions. */
-static unsigned long wire_flags_to_bio(struct drbd_conf *mdev, u32 dpf)
+static unsigned long wire_flags_to_bio(struct drbd_device *mdev, u32 dpf)
 {
 	return  (dpf & DP_RW_SYNC ? REQ_SYNC : 0) |
 		(dpf & DP_FUA ? REQ_FUA : 0) |
@@ -2010,7 +2010,7 @@ static unsigned long wire_flags_to_bio(struct drbd_conf *mdev, u32 dpf)
 		(dpf & DP_DISCARD ? REQ_DISCARD : 0);
 }
 
-static void fail_postponed_requests(struct drbd_conf *mdev, sector_t sector,
+static void fail_postponed_requests(struct drbd_device *mdev, sector_t sector,
 				    unsigned int size)
 {
 	struct drbd_interval *i;
@@ -2035,7 +2035,7 @@ static void fail_postponed_requests(struct drbd_conf *mdev, sector_t sector,
 	}
 }
 
-static int handle_write_conflicts(struct drbd_conf *mdev,
+static int handle_write_conflicts(struct drbd_device *mdev,
 				  struct drbd_peer_request *peer_req)
 {
 	struct drbd_tconn *tconn = mdev->tconn;
@@ -2147,7 +2147,7 @@ static int handle_write_conflicts(struct drbd_conf *mdev,
 /* mirrored write */
 static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	sector_t sector;
 	struct drbd_peer_request *peer_req;
 	struct p_data *p = pi->data;
@@ -2296,7 +2296,7 @@ out_interrupted:
  * The current sync rate used here uses only the most recent two step marks,
  * to have a short time average so we can react faster.
  */
-int drbd_rs_should_slow_down(struct drbd_conf *mdev, sector_t sector)
+int drbd_rs_should_slow_down(struct drbd_device *mdev, sector_t sector)
 {
 	struct gendisk *disk = mdev->ldev->backing_bdev->bd_contains->bd_disk;
 	unsigned long db, dt, dbdt;
@@ -2359,7 +2359,7 @@ int drbd_rs_should_slow_down(struct drbd_conf *mdev, sector_t sector)
 
 static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	sector_t sector;
 	sector_t capacity;
 	struct drbd_peer_request *peer_req;
@@ -2545,7 +2545,7 @@ out_free_e:
 	return -EIO;
 }
 
-static int drbd_asb_recover_0p(struct drbd_conf *mdev) __must_hold(local)
+static int drbd_asb_recover_0p(struct drbd_device *mdev) __must_hold(local)
 {
 	int self, peer, rv = -100;
 	unsigned long ch_self, ch_peer;
@@ -2622,7 +2622,7 @@ static int drbd_asb_recover_0p(struct drbd_conf *mdev) __must_hold(local)
 	return rv;
 }
 
-static int drbd_asb_recover_1p(struct drbd_conf *mdev) __must_hold(local)
+static int drbd_asb_recover_1p(struct drbd_device *mdev) __must_hold(local)
 {
 	int hg, rv = -100;
 	enum drbd_after_sb_p after_sb_1p;
@@ -2675,7 +2675,7 @@ static int drbd_asb_recover_1p(struct drbd_conf *mdev) __must_hold(local)
 	return rv;
 }
 
-static int drbd_asb_recover_2p(struct drbd_conf *mdev) __must_hold(local)
+static int drbd_asb_recover_2p(struct drbd_device *mdev) __must_hold(local)
 {
 	int hg, rv = -100;
 	enum drbd_after_sb_p after_sb_2p;
@@ -2721,7 +2721,7 @@ static int drbd_asb_recover_2p(struct drbd_conf *mdev) __must_hold(local)
 	return rv;
 }
 
-static void drbd_uuid_dump(struct drbd_conf *mdev, char *text, u64 *uuid,
+static void drbd_uuid_dump(struct drbd_device *mdev, char *text, u64 *uuid,
 			   u64 bits, u64 flags)
 {
 	if (!uuid) {
@@ -2750,7 +2750,7 @@ static void drbd_uuid_dump(struct drbd_conf *mdev, char *text, u64 *uuid,
 -1091   requires proto 91
 -1096   requires proto 96
  */
-static int drbd_uuid_compare(struct drbd_conf *mdev, int *rule_nr) __must_hold(local)
+static int drbd_uuid_compare(struct drbd_device *mdev, int *rule_nr) __must_hold(local)
 {
 	u64 self, peer;
 	int i, j;
@@ -2935,7 +2935,7 @@ static int drbd_uuid_compare(struct drbd_conf *mdev, int *rule_nr) __must_hold(l
 /* drbd_sync_handshake() returns the new conn state on success, or
    CONN_MASK (-1) on failure.
  */
-static enum drbd_conns drbd_sync_handshake(struct drbd_conf *mdev, enum drbd_role peer_role,
+static enum drbd_conns drbd_sync_handshake(struct drbd_device *mdev, enum drbd_role peer_role,
 					   enum drbd_disk_state peer_disk) __must_hold(local)
 {
 	enum drbd_conns rv = C_MASK;
@@ -3258,7 +3258,7 @@ disconnect:
  * return: NULL (alg name was "")
  *         ERR_PTR(error) if something goes wrong
  *         or the crypto hash ptr, if it worked out ok. */
-struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_conf *mdev,
+struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_device *mdev,
 		const char *alg, const char *name)
 {
 	struct crypto_hash *tfm;
@@ -3315,7 +3315,7 @@ static int config_unknown_volume(struct drbd_tconn *tconn, struct packet_info *p
 
 static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct p_rs_param_95 *p;
 	unsigned int header_size, data_size, exp_max_sz;
 	struct crypto_hash *verify_tfm = NULL;
@@ -3524,7 +3524,7 @@ disconnect:
 }
 
 /* warn if the arguments differ by more than 12.5% */
-static void warn_if_differ_considerably(struct drbd_conf *mdev,
+static void warn_if_differ_considerably(struct drbd_device *mdev,
 	const char *s, sector_t a, sector_t b)
 {
 	sector_t d;
@@ -3538,7 +3538,7 @@ static void warn_if_differ_considerably(struct drbd_conf *mdev,
 
 static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct p_sizes *p = pi->data;
 	enum determine_dev_size dd = DS_UNCHANGED;
 	sector_t p_size, p_usize, my_usize;
@@ -3659,7 +3659,7 @@ static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int receive_uuids(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct p_uuids *p = pi->data;
 	u64 *p_uuid;
 	int i, updated_uuids = 0;
@@ -3764,7 +3764,7 @@ static union drbd_state convert_state(union drbd_state ps)
 
 static int receive_req_state(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct p_req_state *p = pi->data;
 	union drbd_state mask, val;
 	enum drbd_state_rv rv;
@@ -3819,7 +3819,7 @@ static int receive_req_conn_state(struct drbd_tconn *tconn, struct packet_info *
 
 static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct p_state *p = pi->data;
 	union drbd_state os, ns, peer_state;
 	enum drbd_disk_state real_peer_disk;
@@ -3995,7 +3995,7 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int receive_sync_uuid(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct p_rs_uuid *p = pi->data;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
@@ -4033,7 +4033,7 @@ static int receive_sync_uuid(struct drbd_tconn *tconn, struct packet_info *pi)
  * code upon failure.
  */
 static int
-receive_bitmap_plain(struct drbd_conf *mdev, unsigned int size,
+receive_bitmap_plain(struct drbd_device *mdev, unsigned int size,
 		     unsigned long *p, struct bm_xfer_ctx *c)
 {
 	unsigned int data_size = DRBD_SOCKET_BUFFER_SIZE -
@@ -4085,7 +4085,7 @@ static int dcbp_get_pad_bits(struct p_compressed_bm *p)
  * code upon failure.
  */
 static int
-recv_bm_rle_bits(struct drbd_conf *mdev,
+recv_bm_rle_bits(struct drbd_device *mdev,
 		struct p_compressed_bm *p,
 		 struct bm_xfer_ctx *c,
 		 unsigned int len)
@@ -4154,7 +4154,7 @@ recv_bm_rle_bits(struct drbd_conf *mdev,
  * code upon failure.
  */
 static int
-decode_bitmap_c(struct drbd_conf *mdev,
+decode_bitmap_c(struct drbd_device *mdev,
 		struct p_compressed_bm *p,
 		struct bm_xfer_ctx *c,
 		unsigned int len)
@@ -4171,7 +4171,7 @@ decode_bitmap_c(struct drbd_conf *mdev,
 	return -EIO;
 }
 
-void INFO_bm_xfer_stats(struct drbd_conf *mdev,
+void INFO_bm_xfer_stats(struct drbd_device *mdev,
 		const char *direction, struct bm_xfer_ctx *c)
 {
 	/* what would it take to transfer it "plaintext" */
@@ -4217,7 +4217,7 @@ void INFO_bm_xfer_stats(struct drbd_conf *mdev,
    returns 0 on failure, 1 if we successfully received it. */
 static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct bm_xfer_ctx c;
 	int err;
 
@@ -4320,7 +4320,7 @@ static int receive_UnplugRemote(struct drbd_tconn *tconn, struct packet_info *pi
 
 static int receive_out_of_sync(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct p_block_desc *p = pi->data;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
@@ -4435,7 +4435,7 @@ void conn_flush_workqueue(struct drbd_tconn *tconn)
 
 static void conn_disconnect(struct drbd_tconn *tconn)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	enum drbd_conns oc;
 	int vnr;
 
@@ -4485,7 +4485,7 @@ static void conn_disconnect(struct drbd_tconn *tconn)
 		conn_request_state(tconn, NS(conn, C_STANDALONE), CS_VERBOSE | CS_HARD);
 }
 
-static int drbd_disconnected(struct drbd_conf *mdev)
+static int drbd_disconnected(struct drbd_device *mdev)
 {
 	unsigned int i;
 
@@ -4884,7 +4884,7 @@ static int got_conn_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int got_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct p_req_state_reply *p = pi->data;
 	int retcode = be32_to_cpu(p->retcode);
 
@@ -4927,7 +4927,7 @@ static int got_PingAck(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int got_IsInSync(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
@@ -4954,7 +4954,7 @@ static int got_IsInSync(struct drbd_tconn *tconn, struct packet_info *pi)
 }
 
 static int
-validate_req_change_req_state(struct drbd_conf *mdev, u64 id, sector_t sector,
+validate_req_change_req_state(struct drbd_device *mdev, u64 id, sector_t sector,
 			      struct rb_root *root, const char *func,
 			      enum drbd_req_event what, bool missing_ok)
 {
@@ -4977,7 +4977,7 @@ validate_req_change_req_state(struct drbd_conf *mdev, u64 id, sector_t sector,
 
 static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
@@ -5021,7 +5021,7 @@ static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int size = be32_to_cpu(p->blksize);
@@ -5055,7 +5055,7 @@ static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int got_NegDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 
@@ -5075,7 +5075,7 @@ static int got_NegDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int got_NegRSDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	sector_t sector;
 	int size;
 	struct p_block_ack *p = pi->data;
@@ -5110,7 +5110,7 @@ static int got_NegRSDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 static int got_BarrierAck(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct p_barrier_ack *p = pi->data;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 
 	tl_release(tconn, p->barrier, be32_to_cpu(p->set_size));
@@ -5131,7 +5131,7 @@ static int got_BarrierAck(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int got_OVResult(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	struct p_block_ack *p = pi->data;
 	struct drbd_work *w;
 	sector_t sector;
@@ -5186,7 +5186,7 @@ static int got_skip(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int tconn_finish_peer_reqs(struct drbd_tconn *tconn)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr, not_empty = 0;
 
 	do {
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 104a040..6b81de4 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -31,10 +31,10 @@
 #include "drbd_req.h"
 
 
-static bool drbd_may_do_local_read(struct drbd_conf *mdev, sector_t sector, int size);
+static bool drbd_may_do_local_read(struct drbd_device *mdev, sector_t sector, int size);
 
 /* Update disk stats at start of I/O request */
-static void _drbd_start_io_acct(struct drbd_conf *mdev, struct drbd_request *req)
+static void _drbd_start_io_acct(struct drbd_device *mdev, struct drbd_request *req)
 {
 	const int rw = bio_data_dir(req->master_bio);
 	int cpu;
@@ -49,7 +49,7 @@ static void _drbd_start_io_acct(struct drbd_conf *mdev, struct drbd_request *req
 }
 
 /* Update disk stats when completing request upwards */
-static void _drbd_end_io_acct(struct drbd_conf *mdev, struct drbd_request *req)
+static void _drbd_end_io_acct(struct drbd_device *mdev, struct drbd_request *req)
 {
 	int rw = bio_data_dir(req->master_bio);
 	unsigned long duration = jiffies - req->start_time;
@@ -61,7 +61,7 @@ static void _drbd_end_io_acct(struct drbd_conf *mdev, struct drbd_request *req)
 	part_stat_unlock();
 }
 
-static struct drbd_request *drbd_req_new(struct drbd_conf *mdev,
+static struct drbd_request *drbd_req_new(struct drbd_device *mdev,
 					       struct bio *bio_src)
 {
 	struct drbd_request *req;
@@ -95,7 +95,7 @@ static struct drbd_request *drbd_req_new(struct drbd_conf *mdev,
 void drbd_req_destroy(struct kref *kref)
 {
 	struct drbd_request *req = container_of(kref, struct drbd_request, kref);
-	struct drbd_conf *mdev = req->w.mdev;
+	struct drbd_device *mdev = req->w.mdev;
 	const unsigned s = req->rq_state;
 
 	if ((req->master_bio && !(s & RQ_POSTPONED)) ||
@@ -179,7 +179,7 @@ void start_new_tl_epoch(struct drbd_tconn *tconn)
 	wake_all_senders(tconn);
 }
 
-void complete_master_bio(struct drbd_conf *mdev,
+void complete_master_bio(struct drbd_device *mdev,
 		struct bio_and_error *m)
 {
 	bio_endio(m->bio, m->error);
@@ -190,7 +190,7 @@ void complete_master_bio(struct drbd_conf *mdev,
 static void drbd_remove_request_interval(struct rb_root *root,
 					 struct drbd_request *req)
 {
-	struct drbd_conf *mdev = req->w.mdev;
+	struct drbd_device *mdev = req->w.mdev;
 	struct drbd_interval *i = &req->i;
 
 	drbd_remove_interval(root, i);
@@ -210,7 +210,7 @@ static
 void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 {
 	const unsigned s = req->rq_state;
-	struct drbd_conf *mdev = req->w.mdev;
+	struct drbd_device *mdev = req->w.mdev;
 	int rw;
 	int error, ok;
 
@@ -305,7 +305,7 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 
 static int drbd_req_put_completion_ref(struct drbd_request *req, struct bio_and_error *m, int put)
 {
-	struct drbd_conf *mdev = req->w.mdev;
+	struct drbd_device *mdev = req->w.mdev;
 	D_ASSERT(m || (req->rq_state & RQ_POSTPONED));
 
 	if (!atomic_sub_and_test(put, &req->completion_ref))
@@ -328,7 +328,7 @@ static int drbd_req_put_completion_ref(struct drbd_request *req, struct bio_and_
 static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 		int clear, int set)
 {
-	struct drbd_conf *mdev = req->w.mdev;
+	struct drbd_device *mdev = req->w.mdev;
 	unsigned s = req->rq_state;
 	int c_put = 0;
 	int k_put = 0;
@@ -424,7 +424,7 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 		kref_sub(&req->kref, k_put, drbd_req_destroy);
 }
 
-static void drbd_report_io_error(struct drbd_conf *mdev, struct drbd_request *req)
+static void drbd_report_io_error(struct drbd_device *mdev, struct drbd_request *req)
 {
         char b[BDEVNAME_SIZE];
 
@@ -453,7 +453,7 @@ static void drbd_report_io_error(struct drbd_conf *mdev, struct drbd_request *re
 int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		struct bio_and_error *m)
 {
-	struct drbd_conf *mdev = req->w.mdev;
+	struct drbd_device *mdev = req->w.mdev;
 	struct net_conf *nc;
 	int p, rv = 0;
 
@@ -771,7 +771,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
  *   since size may be bigger than BM_BLOCK_SIZE,
  *   we may need to check several bits.
  */
-static bool drbd_may_do_local_read(struct drbd_conf *mdev, sector_t sector, int size)
+static bool drbd_may_do_local_read(struct drbd_device *mdev, sector_t sector, int size)
 {
 	unsigned long sbnr, ebnr;
 	sector_t esector, nr_sectors;
@@ -791,7 +791,7 @@ static bool drbd_may_do_local_read(struct drbd_conf *mdev, sector_t sector, int
 	return drbd_bm_count_bits(mdev, sbnr, ebnr) == 0;
 }
 
-static bool remote_due_to_read_balancing(struct drbd_conf *mdev, sector_t sector,
+static bool remote_due_to_read_balancing(struct drbd_device *mdev, sector_t sector,
 		enum drbd_read_balancing rbm)
 {
 	struct backing_dev_info *bdi;
@@ -834,7 +834,7 @@ static bool remote_due_to_read_balancing(struct drbd_conf *mdev, sector_t sector
 static void complete_conflicting_writes(struct drbd_request *req)
 {
 	DEFINE_WAIT(wait);
-	struct drbd_conf *mdev = req->w.mdev;
+	struct drbd_device *mdev = req->w.mdev;
 	struct drbd_interval *i;
 	sector_t sector = req->i.sector;
 	int size = req->i.size;
@@ -858,7 +858,7 @@ static void complete_conflicting_writes(struct drbd_request *req)
 }
 
 /* called within req_lock and rcu_read_lock() */
-static void maybe_pull_ahead(struct drbd_conf *mdev)
+static void maybe_pull_ahead(struct drbd_device *mdev)
 {
 	struct drbd_tconn *tconn = mdev->tconn;
 	struct net_conf *nc;
@@ -914,7 +914,7 @@ static void maybe_pull_ahead(struct drbd_conf *mdev)
  */
 static bool do_remote_read(struct drbd_request *req)
 {
-	struct drbd_conf *mdev = req->w.mdev;
+	struct drbd_device *mdev = req->w.mdev;
 	enum drbd_read_balancing rbm;
 
 	if (req->private_bio) {
@@ -959,7 +959,7 @@ static bool do_remote_read(struct drbd_request *req)
  * which does NOT include those that we are L_AHEAD for. */
 static int drbd_process_write_request(struct drbd_request *req)
 {
-	struct drbd_conf *mdev = req->w.mdev;
+	struct drbd_device *mdev = req->w.mdev;
 	int remote, send_oos;
 
 	remote = drbd_should_do_remote(mdev->state);
@@ -996,7 +996,7 @@ static int drbd_process_write_request(struct drbd_request *req)
 static void
 drbd_submit_req_private_bio(struct drbd_request *req)
 {
-	struct drbd_conf *mdev = req->w.mdev;
+	struct drbd_device *mdev = req->w.mdev;
 	struct bio *bio = req->private_bio;
 	const int rw = bio_rw(bio);
 
@@ -1020,7 +1020,7 @@ drbd_submit_req_private_bio(struct drbd_request *req)
 		bio_endio(bio, -EIO);
 }
 
-static void drbd_queue_write(struct drbd_conf *mdev, struct drbd_request *req)
+static void drbd_queue_write(struct drbd_device *mdev, struct drbd_request *req)
 {
 	spin_lock(&mdev->submit.lock);
 	list_add_tail(&req->tl_requests, &mdev->submit.writes);
@@ -1034,7 +1034,7 @@ static void drbd_queue_write(struct drbd_conf *mdev, struct drbd_request *req)
  * Returns ERR_PTR(-ENOMEM) if we cannot allocate a drbd_request.
  */
 struct drbd_request *
-drbd_request_prepare(struct drbd_conf *mdev, struct bio *bio, unsigned long start_time)
+drbd_request_prepare(struct drbd_device *mdev, struct bio *bio, unsigned long start_time)
 {
 	const int rw = bio_data_dir(bio);
 	struct drbd_request *req;
@@ -1071,7 +1071,7 @@ drbd_request_prepare(struct drbd_conf *mdev, struct bio *bio, unsigned long star
 	return req;
 }
 
-static void drbd_send_and_submit(struct drbd_conf *mdev, struct drbd_request *req)
+static void drbd_send_and_submit(struct drbd_device *mdev, struct drbd_request *req)
 {
 	const int rw = bio_rw(req->master_bio);
 	struct bio_and_error m = { NULL, };
@@ -1160,7 +1160,7 @@ out:
 		complete_master_bio(mdev, &m);
 }
 
-void __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long start_time)
+void __drbd_make_request(struct drbd_device *mdev, struct bio *bio, unsigned long start_time)
 {
 	struct drbd_request *req = drbd_request_prepare(mdev, bio, start_time);
 	if (IS_ERR_OR_NULL(req))
@@ -1168,7 +1168,7 @@ void __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long
 	drbd_send_and_submit(mdev, req);
 }
 
-static void submit_fast_path(struct drbd_conf *mdev, struct list_head *incoming)
+static void submit_fast_path(struct drbd_device *mdev, struct list_head *incoming)
 {
 	struct drbd_request *req, *tmp;
 	list_for_each_entry_safe(req, tmp, incoming, tl_requests) {
@@ -1188,7 +1188,7 @@ static void submit_fast_path(struct drbd_conf *mdev, struct list_head *incoming)
 	}
 }
 
-static bool prepare_al_transaction_nonblock(struct drbd_conf *mdev,
+static bool prepare_al_transaction_nonblock(struct drbd_device *mdev,
 					    struct list_head *incoming,
 					    struct list_head *pending)
 {
@@ -1215,7 +1215,7 @@ static bool prepare_al_transaction_nonblock(struct drbd_conf *mdev,
 
 void do_submit(struct work_struct *ws)
 {
-	struct drbd_conf *mdev = container_of(ws, struct drbd_conf, submit.worker);
+	struct drbd_device *mdev = container_of(ws, struct drbd_device, submit.worker);
 	LIST_HEAD(incoming);
 	LIST_HEAD(pending);
 	struct drbd_request *req, *tmp;
@@ -1272,7 +1272,7 @@ void do_submit(struct work_struct *ws)
 
 void drbd_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct drbd_conf *mdev = (struct drbd_conf *) q->queuedata;
+	struct drbd_device *mdev = (struct drbd_device *) q->queuedata;
 	unsigned long start_time;
 
 	start_time = jiffies;
@@ -1300,7 +1300,7 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
  */
 int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct bio_vec *bvec)
 {
-	struct drbd_conf *mdev = (struct drbd_conf *) q->queuedata;
+	struct drbd_device *mdev = (struct drbd_device *) q->queuedata;
 	unsigned int bio_size = bvm->bi_size;
 	int limit = DRBD_MAX_BIO_SIZE;
 	int backing_limit;
@@ -1334,7 +1334,7 @@ struct drbd_request *find_oldest_request(struct drbd_tconn *tconn)
 
 void request_timer_fn(unsigned long data)
 {
-	struct drbd_conf *mdev = (struct drbd_conf *) data;
+	struct drbd_device *mdev = (struct drbd_device *) data;
 	struct drbd_tconn *tconn = mdev->tconn;
 	struct drbd_request *req; /* oldest request */
 	struct net_conf *nc;
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 28e15d9..3f1e776 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -281,7 +281,7 @@ extern void _req_may_be_done(struct drbd_request *req,
 		struct bio_and_error *m);
 extern int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		struct bio_and_error *m);
-extern void complete_master_bio(struct drbd_conf *mdev,
+extern void complete_master_bio(struct drbd_device *mdev,
 		struct bio_and_error *m);
 extern void request_timer_fn(unsigned long data);
 extern void tl_restart(struct drbd_tconn *tconn, enum drbd_req_event what);
@@ -294,7 +294,7 @@ extern void drbd_restart_request(struct drbd_request *req);
  * outside the spinlock, e.g. when walking some list on cleanup. */
 static inline int _req_mod(struct drbd_request *req, enum drbd_req_event what)
 {
-	struct drbd_conf *mdev = req->w.mdev;
+	struct drbd_device *mdev = req->w.mdev;
 	struct bio_and_error m;
 	int rv;
 
@@ -314,7 +314,7 @@ static inline int req_mod(struct drbd_request *req,
 		enum drbd_req_event what)
 {
 	unsigned long flags;
-	struct drbd_conf *mdev = req->w.mdev;
+	struct drbd_device *mdev = req->w.mdev;
 	struct bio_and_error m;
 	int rv;
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 26692a1..978c948 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -31,7 +31,7 @@
 #include "drbd_req.h"
 
 /* in drbd_main.c */
-extern void tl_abort_disk_io(struct drbd_conf *mdev);
+extern void tl_abort_disk_io(struct drbd_device *mdev);
 
 struct after_state_chg_work {
 	struct drbd_work w;
@@ -51,12 +51,12 @@ enum sanitize_state_warnings {
 };
 
 static int w_after_state_ch(struct drbd_work *w, int unused);
-static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
+static void after_state_ch(struct drbd_device *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags);
-static enum drbd_state_rv is_valid_state(struct drbd_conf *, union drbd_state);
+static enum drbd_state_rv is_valid_state(struct drbd_device *, union drbd_state);
 static enum drbd_state_rv is_valid_soft_transition(union drbd_state, union drbd_state, struct drbd_tconn *);
 static enum drbd_state_rv is_valid_transition(union drbd_state os, union drbd_state ns);
-static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state ns,
+static union drbd_state sanitize_state(struct drbd_device *mdev, union drbd_state ns,
 				       enum sanitize_state_warnings *warn);
 
 static inline bool is_susp(union drbd_state s)
@@ -66,7 +66,7 @@ static inline bool is_susp(union drbd_state s)
 
 bool conn_all_vols_unconf(struct drbd_tconn *tconn)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	bool rv = true;
 	int vnr;
 
@@ -106,7 +106,7 @@ static enum drbd_role min_role(enum drbd_role role1, enum drbd_role role2)
 enum drbd_role conn_highest_role(struct drbd_tconn *tconn)
 {
 	enum drbd_role role = R_UNKNOWN;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 
 	rcu_read_lock();
@@ -120,7 +120,7 @@ enum drbd_role conn_highest_role(struct drbd_tconn *tconn)
 enum drbd_role conn_highest_peer(struct drbd_tconn *tconn)
 {
 	enum drbd_role peer = R_UNKNOWN;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 
 	rcu_read_lock();
@@ -134,7 +134,7 @@ enum drbd_role conn_highest_peer(struct drbd_tconn *tconn)
 enum drbd_disk_state conn_highest_disk(struct drbd_tconn *tconn)
 {
 	enum drbd_disk_state ds = D_DISKLESS;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 
 	rcu_read_lock();
@@ -148,7 +148,7 @@ enum drbd_disk_state conn_highest_disk(struct drbd_tconn *tconn)
 enum drbd_disk_state conn_lowest_disk(struct drbd_tconn *tconn)
 {
 	enum drbd_disk_state ds = D_MASK;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 
 	rcu_read_lock();
@@ -162,7 +162,7 @@ enum drbd_disk_state conn_lowest_disk(struct drbd_tconn *tconn)
 enum drbd_disk_state conn_highest_pdsk(struct drbd_tconn *tconn)
 {
 	enum drbd_disk_state ds = D_DISKLESS;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 
 	rcu_read_lock();
@@ -176,7 +176,7 @@ enum drbd_disk_state conn_highest_pdsk(struct drbd_tconn *tconn)
 enum drbd_conns conn_lowest_conn(struct drbd_tconn *tconn)
 {
 	enum drbd_conns conn = C_MASK;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 
 	rcu_read_lock();
@@ -189,7 +189,7 @@ enum drbd_conns conn_lowest_conn(struct drbd_tconn *tconn)
 
 static bool no_peer_wf_report_params(struct drbd_tconn *tconn)
 {
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 	bool rv = true;
 
@@ -211,7 +211,7 @@ static bool no_peer_wf_report_params(struct drbd_tconn *tconn)
  * @os:		old (current) state.
  * @ns:		new (wanted) state.
  */
-static int cl_wide_st_chg(struct drbd_conf *mdev,
+static int cl_wide_st_chg(struct drbd_device *mdev,
 			  union drbd_state os, union drbd_state ns)
 {
 	return (os.conn >= C_CONNECTED && ns.conn >= C_CONNECTED &&
@@ -233,7 +233,7 @@ apply_mask_val(union drbd_state os, union drbd_state mask, union drbd_state val)
 }
 
 enum drbd_state_rv
-drbd_change_state(struct drbd_conf *mdev, enum chg_state_flags f,
+drbd_change_state(struct drbd_device *mdev, enum chg_state_flags f,
 		  union drbd_state mask, union drbd_state val)
 {
 	unsigned long flags;
@@ -254,14 +254,14 @@ drbd_change_state(struct drbd_conf *mdev, enum chg_state_flags f,
  * @mask:	mask of state bits to change.
  * @val:	value of new state bits.
  */
-void drbd_force_state(struct drbd_conf *mdev,
+void drbd_force_state(struct drbd_device *mdev,
 	union drbd_state mask, union drbd_state val)
 {
 	drbd_change_state(mdev, CS_HARD, mask, val);
 }
 
 static enum drbd_state_rv
-_req_st_cond(struct drbd_conf *mdev, union drbd_state mask,
+_req_st_cond(struct drbd_device *mdev, union drbd_state mask,
 	     union drbd_state val)
 {
 	union drbd_state os, ns;
@@ -307,7 +307,7 @@ _req_st_cond(struct drbd_conf *mdev, union drbd_state mask,
  * _drbd_request_state().
  */
 static enum drbd_state_rv
-drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
+drbd_req_state(struct drbd_device *mdev, union drbd_state mask,
 	       union drbd_state val, enum chg_state_flags f)
 {
 	struct completion done;
@@ -388,7 +388,7 @@ abort:
  * flag, or when logging of failed state change requests is not desired.
  */
 enum drbd_state_rv
-_drbd_request_state(struct drbd_conf *mdev, union drbd_state mask,
+_drbd_request_state(struct drbd_device *mdev, union drbd_state mask,
 		    union drbd_state val, enum chg_state_flags f)
 {
 	enum drbd_state_rv rv;
@@ -399,7 +399,7 @@ _drbd_request_state(struct drbd_conf *mdev, union drbd_state mask,
 	return rv;
 }
 
-static void print_st(struct drbd_conf *mdev, char *name, union drbd_state ns)
+static void print_st(struct drbd_device *mdev, char *name, union drbd_state ns)
 {
 	dev_err(DEV, " %s = { cs:%s ro:%s/%s ds:%s/%s %c%c%c%c%c%c }\n",
 	    name,
@@ -417,7 +417,7 @@ static void print_st(struct drbd_conf *mdev, char *name, union drbd_state ns)
 	    );
 }
 
-void print_st_err(struct drbd_conf *mdev, union drbd_state os,
+void print_st_err(struct drbd_device *mdev, union drbd_state os,
 	          union drbd_state ns, enum drbd_state_rv err)
 {
 	if (err == SS_IN_TRANSIENT_STATE)
@@ -458,7 +458,7 @@ static long print_state_change(char *pb, union drbd_state os, union drbd_state n
 	return pbp - pb;
 }
 
-static void drbd_pr_state_change(struct drbd_conf *mdev, union drbd_state os, union drbd_state ns,
+static void drbd_pr_state_change(struct drbd_device *mdev, union drbd_state os, union drbd_state ns,
 				 enum chg_state_flags flags)
 {
 	char pb[300];
@@ -507,7 +507,7 @@ static void conn_pr_state_change(struct drbd_tconn *tconn, union drbd_state os,
  * @ns:		State to consider.
  */
 static enum drbd_state_rv
-is_valid_state(struct drbd_conf *mdev, union drbd_state ns)
+is_valid_state(struct drbd_device *mdev, union drbd_state ns)
 {
 	/* See drbd_state_sw_errors in drbd_strings.c */
 
@@ -704,7 +704,7 @@ is_valid_transition(union drbd_state os, union drbd_state ns)
 	return rv;
 }
 
-static void print_sanitize_warnings(struct drbd_conf *mdev, enum sanitize_state_warnings warn)
+static void print_sanitize_warnings(struct drbd_device *mdev, enum sanitize_state_warnings warn)
 {
 	static const char *msg_table[] = {
 		[NO_WARNING] = "",
@@ -729,7 +729,7 @@ static void print_sanitize_warnings(struct drbd_conf *mdev, enum sanitize_state_
  * When we loose connection, we have to set the state of the peers disk (pdsk)
  * to D_UNKNOWN. This rule and many more along those lines are in this function.
  */
-static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state ns,
+static union drbd_state sanitize_state(struct drbd_device *mdev, union drbd_state ns,
 				       enum sanitize_state_warnings *warn)
 {
 	enum drbd_fencing_p fp;
@@ -893,14 +893,14 @@ static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state
 	return ns;
 }
 
-void drbd_resume_al(struct drbd_conf *mdev)
+void drbd_resume_al(struct drbd_device *mdev)
 {
 	if (test_and_clear_bit(AL_SUSPENDED, &mdev->flags))
 		dev_info(DEV, "Resumed AL updates\n");
 }
 
 /* helper for __drbd_set_state */
-static void set_ov_position(struct drbd_conf *mdev, enum drbd_conns cs)
+static void set_ov_position(struct drbd_device *mdev, enum drbd_conns cs)
 {
 	if (mdev->tconn->agreed_pro_version < 90)
 		mdev->ov_start_sector = 0;
@@ -936,7 +936,7 @@ static void set_ov_position(struct drbd_conf *mdev, enum drbd_conns cs)
  * Caller needs to hold req_lock, and global_state_lock. Do not call directly.
  */
 enum drbd_state_rv
-__drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
+__drbd_set_state(struct drbd_device *mdev, union drbd_state ns,
 	         enum chg_state_flags flags, struct completion *done)
 {
 	union drbd_state os;
@@ -1148,7 +1148,7 @@ static int w_after_state_ch(struct drbd_work *w, int unused)
 {
 	struct after_state_chg_work *ascw =
 		container_of(w, struct after_state_chg_work, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 
 	after_state_ch(mdev, ascw->os, ascw->ns, ascw->flags);
 	if (ascw->flags & CS_WAIT_COMPLETE) {
@@ -1160,7 +1160,7 @@ static int w_after_state_ch(struct drbd_work *w, int unused)
 	return 0;
 }
 
-static void abw_start_sync(struct drbd_conf *mdev, int rv)
+static void abw_start_sync(struct drbd_device *mdev, int rv)
 {
 	if (rv) {
 		dev_err(DEV, "Writing the bitmap failed not starting resync.\n");
@@ -1178,8 +1178,8 @@ static void abw_start_sync(struct drbd_conf *mdev, int rv)
 	}
 }
 
-int drbd_bitmap_io_from_worker(struct drbd_conf *mdev,
-		int (*io_fn)(struct drbd_conf *),
+int drbd_bitmap_io_from_worker(struct drbd_device *mdev,
+		int (*io_fn)(struct drbd_device *),
 		char *why, enum bm_flag flags)
 {
 	int rv;
@@ -1205,7 +1205,7 @@ int drbd_bitmap_io_from_worker(struct drbd_conf *mdev,
  * @ns:		new state.
  * @flags:	Flags
  */
-static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
+static void after_state_ch(struct drbd_device *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags)
 {
 	struct sib_info sib;
@@ -1258,7 +1258,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 		spin_lock_irq(&tconn->req_lock);
 		if (tconn->susp_fen && conn_lowest_conn(tconn) >= C_CONNECTED) {
 			/* case2: The connection was established again: */
-			struct drbd_conf *odev;
+			struct drbd_device *odev;
 			int vnr;
 
 			rcu_read_lock();
@@ -1532,7 +1532,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 	struct drbd_tconn *tconn = w->tconn;
 	enum drbd_conns oc = acscw->oc;
 	union drbd_state ns_max = acscw->ns_max;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 
 	kfree(acscw);
@@ -1586,7 +1586,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, enum chg_state_flags *pf)
 {
 	enum chg_state_flags flags = ~0;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr, first_vol = 1;
 	union drbd_dev_state os, cs = {
 		{ .role = R_SECONDARY,
@@ -1634,7 +1634,7 @@ conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union
 {
 	enum drbd_state_rv rv = SS_SUCCESS;
 	union drbd_state ns, os;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	int vnr;
 
 	rcu_read_lock();
@@ -1683,7 +1683,7 @@ conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 		  .disk = D_MASK,
 		  .pdsk = D_MASK
 		} };
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	enum drbd_state_rv rv;
 	int vnr, number_of_volumes = 0;
 
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index a3c361b..181b6b2 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -1,7 +1,7 @@
 #ifndef DRBD_STATE_H
 #define DRBD_STATE_H
 
-struct drbd_conf;
+struct drbd_device;
 struct drbd_tconn;
 
 /**
@@ -107,20 +107,20 @@ union drbd_dev_state {
 	unsigned int i;
 };
 
-extern enum drbd_state_rv drbd_change_state(struct drbd_conf *mdev,
+extern enum drbd_state_rv drbd_change_state(struct drbd_device *mdev,
 					    enum chg_state_flags f,
 					    union drbd_state mask,
 					    union drbd_state val);
-extern void drbd_force_state(struct drbd_conf *, union drbd_state,
+extern void drbd_force_state(struct drbd_device *, union drbd_state,
 			union drbd_state);
-extern enum drbd_state_rv _drbd_request_state(struct drbd_conf *,
+extern enum drbd_state_rv _drbd_request_state(struct drbd_device *,
 					      union drbd_state,
 					      union drbd_state,
 					      enum chg_state_flags);
-extern enum drbd_state_rv __drbd_set_state(struct drbd_conf *, union drbd_state,
+extern enum drbd_state_rv __drbd_set_state(struct drbd_device *, union drbd_state,
 					   enum chg_state_flags,
 					   struct completion *done);
-extern void print_st_err(struct drbd_conf *, union drbd_state,
+extern void print_st_err(struct drbd_device *, union drbd_state,
 			union drbd_state, int);
 
 enum drbd_state_rv
@@ -131,7 +131,7 @@ enum drbd_state_rv
 conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
 		   enum chg_state_flags flags);
 
-extern void drbd_resume_al(struct drbd_conf *mdev);
+extern void drbd_resume_al(struct drbd_device *mdev);
 extern bool conn_all_vols_unconf(struct drbd_tconn *tconn);
 
 /**
@@ -144,7 +144,7 @@ extern bool conn_all_vols_unconf(struct drbd_tconn *tconn);
  * quite verbose in case the state change is not possible, and all those
  * state changes are globally serialized.
  */
-static inline int drbd_request_state(struct drbd_conf *mdev,
+static inline int drbd_request_state(struct drbd_device *mdev,
 				     union drbd_state mask,
 				     union drbd_state val)
 {
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 8b65711..852fa4b 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -68,10 +68,10 @@ rwlock_t global_state_lock;
 void drbd_md_io_complete(struct bio *bio, int error)
 {
 	struct drbd_md_io *md_io;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 
 	md_io = (struct drbd_md_io *)bio->bi_private;
-	mdev = container_of(md_io, struct drbd_conf, md_io);
+	mdev = container_of(md_io, struct drbd_device, md_io);
 
 	md_io->error = error;
 
@@ -100,7 +100,7 @@ void drbd_md_io_complete(struct bio *bio, int error)
 void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_conf *mdev = peer_req->w.mdev;
+	struct drbd_device *mdev = peer_req->w.mdev;
 
 	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	mdev->read_cnt += peer_req->i.size >> 9;
@@ -120,7 +120,7 @@ void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(lo
 static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
-	struct drbd_conf *mdev = peer_req->w.mdev;
+	struct drbd_device *mdev = peer_req->w.mdev;
 	struct drbd_interval i;
 	int do_wake;
 	u64 block_id;
@@ -171,7 +171,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 void drbd_peer_request_endio(struct bio *bio, int error)
 {
 	struct drbd_peer_request *peer_req = bio->bi_private;
-	struct drbd_conf *mdev = peer_req->w.mdev;
+	struct drbd_device *mdev = peer_req->w.mdev;
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
 	int is_write = bio_data_dir(bio) == WRITE;
 
@@ -208,7 +208,7 @@ void drbd_request_endio(struct bio *bio, int error)
 {
 	unsigned long flags;
 	struct drbd_request *req = bio->bi_private;
-	struct drbd_conf *mdev = req->w.mdev;
+	struct drbd_device *mdev = req->w.mdev;
 	struct bio_and_error m;
 	enum drbd_req_event what;
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
@@ -282,7 +282,7 @@ void drbd_request_endio(struct bio *bio, int error)
 		complete_master_bio(mdev, &m);
 }
 
-void drbd_csum_ee(struct drbd_conf *mdev, struct crypto_hash *tfm,
+void drbd_csum_ee(struct drbd_device *mdev, struct crypto_hash *tfm,
 		  struct drbd_peer_request *peer_req, void *digest)
 {
 	struct hash_desc desc;
@@ -310,7 +310,7 @@ void drbd_csum_ee(struct drbd_conf *mdev, struct crypto_hash *tfm,
 	crypto_hash_final(&desc, digest);
 }
 
-void drbd_csum_bio(struct drbd_conf *mdev, struct crypto_hash *tfm, struct bio *bio, void *digest)
+void drbd_csum_bio(struct drbd_device *mdev, struct crypto_hash *tfm, struct bio *bio, void *digest)
 {
 	struct hash_desc desc;
 	struct scatterlist sg;
@@ -334,7 +334,7 @@ void drbd_csum_bio(struct drbd_conf *mdev, struct crypto_hash *tfm, struct bio *
 static int w_e_send_csum(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	int digest_size;
 	void *digest;
 	int err = 0;
@@ -379,7 +379,7 @@ out:
 
 #define GFP_TRY	(__GFP_HIGHMEM | __GFP_NOWARN)
 
-static int read_for_csum(struct drbd_conf *mdev, sector_t sector, int size)
+static int read_for_csum(struct drbd_device *mdev, sector_t sector, int size)
 {
 	struct drbd_peer_request *peer_req;
 
@@ -421,7 +421,7 @@ defer:
 
 int w_resync_timer(struct drbd_work *w, int cancel)
 {
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	switch (mdev->state.conn) {
 	case C_VERIFY_S:
 		w_make_ov_request(w, cancel);
@@ -436,7 +436,7 @@ int w_resync_timer(struct drbd_work *w, int cancel)
 
 void resync_timer_fn(unsigned long data)
 {
-	struct drbd_conf *mdev = (struct drbd_conf *) data;
+	struct drbd_device *mdev = (struct drbd_device *) data;
 
 	if (list_empty(&mdev->resync_work.list))
 		drbd_queue_work(&mdev->tconn->sender_work, &mdev->resync_work);
@@ -486,7 +486,7 @@ struct fifo_buffer *fifo_alloc(int fifo_size)
 	return fb;
 }
 
-static int drbd_rs_controller(struct drbd_conf *mdev)
+static int drbd_rs_controller(struct drbd_device *mdev)
 {
 	struct disk_conf *dc;
 	unsigned int sect_in;  /* Number of sectors that came in since the last turn */
@@ -542,7 +542,7 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 	return req_sect;
 }
 
-static int drbd_rs_number_requests(struct drbd_conf *mdev)
+static int drbd_rs_number_requests(struct drbd_device *mdev)
 {
 	int number;
 
@@ -563,7 +563,7 @@ static int drbd_rs_number_requests(struct drbd_conf *mdev)
 
 int w_make_resync_request(struct drbd_work *w, int cancel)
 {
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	unsigned long bit;
 	sector_t sector;
 	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
@@ -726,7 +726,7 @@ next_sector:
 
 static int w_make_ov_request(struct drbd_work *w, int cancel)
 {
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	int number, i, size;
 	sector_t sector;
 	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
@@ -780,7 +780,7 @@ static int w_make_ov_request(struct drbd_work *w, int cancel)
 
 int w_ov_finished(struct drbd_work *w, int cancel)
 {
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	kfree(w);
 	ov_out_of_sync_print(mdev);
 	drbd_resync_finished(mdev);
@@ -790,7 +790,7 @@ int w_ov_finished(struct drbd_work *w, int cancel)
 
 static int w_resync_finished(struct drbd_work *w, int cancel)
 {
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	kfree(w);
 
 	drbd_resync_finished(mdev);
@@ -798,7 +798,7 @@ static int w_resync_finished(struct drbd_work *w, int cancel)
 	return 0;
 }
 
-static void ping_peer(struct drbd_conf *mdev)
+static void ping_peer(struct drbd_device *mdev)
 {
 	struct drbd_tconn *tconn = mdev->tconn;
 
@@ -808,7 +808,7 @@ static void ping_peer(struct drbd_conf *mdev)
 		   test_bit(GOT_PING_ACK, &tconn->flags) || mdev->state.conn < C_CONNECTED);
 }
 
-int drbd_resync_finished(struct drbd_conf *mdev)
+int drbd_resync_finished(struct drbd_device *mdev)
 {
 	unsigned long db, dt, dbdt;
 	unsigned long n_oos;
@@ -963,7 +963,7 @@ out:
 }
 
 /* helper */
-static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_peer_request *peer_req)
+static void move_to_net_ee_or_free(struct drbd_device *mdev, struct drbd_peer_request *peer_req)
 {
 	if (drbd_peer_req_has_active_page(peer_req)) {
 		/* This might happen if sendpage() has not finished */
@@ -987,7 +987,7 @@ static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_peer_requ
 int w_e_end_data_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1024,7 +1024,7 @@ int w_e_end_data_req(struct drbd_work *w, int cancel)
 int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	int err;
 
 	if (unlikely(cancel)) {
@@ -1073,7 +1073,7 @@ int w_e_end_rsdata_req(struct drbd_work *w, int cancel)
 int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	struct digest_info *di;
 	int digest_size;
 	void *digest = NULL;
@@ -1136,7 +1136,7 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 int w_e_end_ov_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	sector_t sector = peer_req->i.sector;
 	unsigned int size = peer_req->i.size;
 	int digest_size;
@@ -1178,7 +1178,7 @@ out:
 	return err;
 }
 
-void drbd_ov_out_of_sync_found(struct drbd_conf *mdev, sector_t sector, int size)
+void drbd_ov_out_of_sync_found(struct drbd_device *mdev, sector_t sector, int size)
 {
 	if (mdev->ov_last_oos_start + mdev->ov_last_oos_size == sector) {
 		mdev->ov_last_oos_size += size>>9;
@@ -1192,7 +1192,7 @@ void drbd_ov_out_of_sync_found(struct drbd_conf *mdev, sector_t sector, int size
 int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 {
 	struct drbd_peer_request *peer_req = container_of(w, struct drbd_peer_request, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	struct digest_info *di;
 	void *digest;
 	sector_t sector = peer_req->i.sector;
@@ -1292,7 +1292,7 @@ int drbd_send_barrier(struct drbd_tconn *tconn)
 
 int w_send_write_hint(struct drbd_work *w, int cancel)
 {
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	struct drbd_socket *sock;
 
 	if (cancel)
@@ -1327,7 +1327,7 @@ static void maybe_send_barrier(struct drbd_tconn *tconn, unsigned int epoch)
 int w_send_out_of_sync(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	struct drbd_tconn *tconn = mdev->tconn;
 	int err;
 
@@ -1357,7 +1357,7 @@ int w_send_out_of_sync(struct drbd_work *w, int cancel)
 int w_send_dblock(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	struct drbd_tconn *tconn = mdev->tconn;
 	int err;
 
@@ -1385,7 +1385,7 @@ int w_send_dblock(struct drbd_work *w, int cancel)
 int w_send_read_req(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 	struct drbd_tconn *tconn = mdev->tconn;
 	int err;
 
@@ -1409,7 +1409,7 @@ int w_send_read_req(struct drbd_work *w, int cancel)
 int w_restart_disk_io(struct drbd_work *w, int cancel)
 {
 	struct drbd_request *req = container_of(w, struct drbd_request, w);
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 
 	if (bio_data_dir(req->master_bio) == WRITE && req->rq_state & RQ_IN_ACT_LOG)
 		drbd_al_begin_io(mdev, &req->i, false);
@@ -1421,9 +1421,9 @@ int w_restart_disk_io(struct drbd_work *w, int cancel)
 	return 0;
 }
 
-static int _drbd_may_sync_now(struct drbd_conf *mdev)
+static int _drbd_may_sync_now(struct drbd_device *mdev)
 {
-	struct drbd_conf *odev = mdev;
+	struct drbd_device *odev = mdev;
 	int resync_after;
 
 	while (1) {
@@ -1451,9 +1451,9 @@ static int _drbd_may_sync_now(struct drbd_conf *mdev)
  *
  * Called from process context only (admin command and after_state_ch).
  */
-static int _drbd_pause_after(struct drbd_conf *mdev)
+static int _drbd_pause_after(struct drbd_device *mdev)
 {
-	struct drbd_conf *odev;
+	struct drbd_device *odev;
 	int i, rv = 0;
 
 	rcu_read_lock();
@@ -1475,9 +1475,9 @@ static int _drbd_pause_after(struct drbd_conf *mdev)
  *
  * Called from process context only (admin command and worker).
  */
-static int _drbd_resume_next(struct drbd_conf *mdev)
+static int _drbd_resume_next(struct drbd_device *mdev)
 {
-	struct drbd_conf *odev;
+	struct drbd_device *odev;
 	int i, rv = 0;
 
 	rcu_read_lock();
@@ -1495,14 +1495,14 @@ static int _drbd_resume_next(struct drbd_conf *mdev)
 	return rv;
 }
 
-void resume_next_sg(struct drbd_conf *mdev)
+void resume_next_sg(struct drbd_device *mdev)
 {
 	write_lock_irq(&global_state_lock);
 	_drbd_resume_next(mdev);
 	write_unlock_irq(&global_state_lock);
 }
 
-void suspend_other_sg(struct drbd_conf *mdev)
+void suspend_other_sg(struct drbd_device *mdev)
 {
 	write_lock_irq(&global_state_lock);
 	_drbd_pause_after(mdev);
@@ -1510,9 +1510,9 @@ void suspend_other_sg(struct drbd_conf *mdev)
 }
 
 /* caller must hold global_state_lock */
-enum drbd_ret_code drbd_resync_after_valid(struct drbd_conf *mdev, int o_minor)
+enum drbd_ret_code drbd_resync_after_valid(struct drbd_device *mdev, int o_minor)
 {
-	struct drbd_conf *odev;
+	struct drbd_device *odev;
 	int resync_after;
 
 	if (o_minor == -1)
@@ -1548,7 +1548,7 @@ enum drbd_ret_code drbd_resync_after_valid(struct drbd_conf *mdev, int o_minor)
 }
 
 /* caller must hold global_state_lock */
-void drbd_resync_after_changed(struct drbd_conf *mdev)
+void drbd_resync_after_changed(struct drbd_device *mdev)
 {
 	int changes;
 
@@ -1558,7 +1558,7 @@ void drbd_resync_after_changed(struct drbd_conf *mdev)
 	} while (changes);
 }
 
-void drbd_rs_controller_reset(struct drbd_conf *mdev)
+void drbd_rs_controller_reset(struct drbd_device *mdev)
 {
 	struct fifo_buffer *plan;
 
@@ -1579,14 +1579,14 @@ void drbd_rs_controller_reset(struct drbd_conf *mdev)
 
 void start_resync_timer_fn(unsigned long data)
 {
-	struct drbd_conf *mdev = (struct drbd_conf *) data;
+	struct drbd_device *mdev = (struct drbd_device *) data;
 
 	drbd_queue_work(&mdev->tconn->sender_work, &mdev->start_resync_work);
 }
 
 int w_start_resync(struct drbd_work *w, int cancel)
 {
-	struct drbd_conf *mdev = w->mdev;
+	struct drbd_device *mdev = w->mdev;
 
 	if (atomic_read(&mdev->unacked_cnt) || atomic_read(&mdev->rs_pending_cnt)) {
 		dev_warn(DEV, "w_start_resync later...\n");
@@ -1608,7 +1608,7 @@ int w_start_resync(struct drbd_work *w, int cancel)
  * This function might bring you directly into one of the
  * C_PAUSED_SYNC_* states.
  */
-void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side)
+void drbd_start_resync(struct drbd_device *mdev, enum drbd_conns side)
 {
 	union drbd_state ns;
 	int r;
@@ -1886,7 +1886,7 @@ int drbd_worker(struct drbd_thread *thi)
 {
 	struct drbd_tconn *tconn = thi->tconn;
 	struct drbd_work *w = NULL;
-	struct drbd_conf *mdev;
+	struct drbd_device *mdev;
 	LIST_HEAD(work_list);
 	int vnr;
 
diff --git a/drivers/block/drbd/drbd_wrappers.h b/drivers/block/drbd/drbd_wrappers.h
index 328f18e..ee6362a 100644
--- a/drivers/block/drbd/drbd_wrappers.h
+++ b/drivers/block/drbd/drbd_wrappers.h
@@ -9,7 +9,7 @@
 extern char *drbd_sec_holder;
 
 /* sets the number of 512 byte sectors of our virtual device */
-static inline void drbd_set_my_capacity(struct drbd_conf *mdev,
+static inline void drbd_set_my_capacity(struct drbd_device *mdev,
 					sector_t size)
 {
 	/* set_capacity(mdev->this_bdev->bd_disk, size); */
@@ -27,7 +27,7 @@ extern void drbd_request_endio(struct bio *bio, int error);
 /*
  * used to submit our private bio
  */
-static inline void drbd_generic_make_request(struct drbd_conf *mdev,
+static inline void drbd_generic_make_request(struct drbd_device *mdev,
 					     int fault_type, struct bio *bio)
 {
 	__release(local);
-- 
1.7.9.5

