Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbaGCIw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:52:57 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45865 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbaGCInS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/23] drbd: track meta data IO intent, start and submit time
Date: Thu,  3 Jul 2014 10:42:55 +0200
Message-Id: <1404376995-4877-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

For diagnostic purposes, track intent, start time
and latest submit time of meta data IO.

Move separate members from struct drbd_device
into the embeded struct drbd_md_io.
s/md_io_(page|in_use)/md_io.\1/

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c | 26 +++++++++++++++++---------
 drivers/block/drbd/drbd_int.h    |  9 ++++++---
 drivers/block/drbd/drbd_main.c   | 14 +++++++-------
 drivers/block/drbd/drbd_nl.c     |  4 ++--
 drivers/block/drbd/drbd_worker.c |  9 +++------
 5 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 5f82a36..d7e8066 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -92,20 +92,26 @@ struct __packed al_transaction_on_disk {
 	__be32	context[AL_CONTEXT_PER_TRANSACTION];
 };
 
-void *drbd_md_get_buffer(struct drbd_device *device)
+void *drbd_md_get_buffer(struct drbd_device *device, const char *intent)
 {
 	int r;
 
 	wait_event(device->misc_wait,
-		   (r = atomic_cmpxchg(&device->md_io_in_use, 0, 1)) == 0 ||
+		   (r = atomic_cmpxchg(&device->md_io.in_use, 0, 1)) == 0 ||
 		   device->state.disk <= D_FAILED);
 
-	return r ? NULL : page_address(device->md_io_page);
+	if (r)
+		return NULL;
+
+	device->md_io.current_use = intent;
+	device->md_io.start_jif = jiffies;
+	device->md_io.submit_jif = device->md_io.start_jif - 1;
+	return page_address(device->md_io.page);
 }
 
 void drbd_md_put_buffer(struct drbd_device *device)
 {
-	if (atomic_dec_and_test(&device->md_io_in_use))
+	if (atomic_dec_and_test(&device->md_io.in_use))
 		wake_up(&device->misc_wait);
 }
 
@@ -150,7 +156,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 	err = -EIO;
 	if (bio_add_page(bio, page, size, 0) != size)
 		goto out;
-	bio->bi_private = &device->md_io;
+	bio->bi_private = device;
 	bio->bi_end_io = drbd_md_io_complete;
 	bio->bi_rw = rw;
 
@@ -165,7 +171,8 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 	}
 
 	bio_get(bio); /* one bio_put() is in the completion handler */
-	atomic_inc(&device->md_io_in_use); /* drbd_md_put_buffer() is in the completion handler */
+	atomic_inc(&device->md_io.in_use); /* drbd_md_put_buffer() is in the completion handler */
+	device->md_io.submit_jif = jiffies;
 	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD))
 		bio_endio(bio, -EIO);
 	else
@@ -183,9 +190,9 @@ int drbd_md_sync_page_io(struct drbd_device *device, struct drbd_backing_dev *bd
 			 sector_t sector, int rw)
 {
 	int err;
-	struct page *iop = device->md_io_page;
+	struct page *iop = device->md_io.page;
 
-	D_ASSERT(device, atomic_read(&device->md_io_in_use) == 1);
+	D_ASSERT(device, atomic_read(&device->md_io.in_use) == 1);
 
 	BUG_ON(!bdev->md_bdev);
 
@@ -465,7 +472,8 @@ int al_write_transaction(struct drbd_device *device)
 		return -EIO;
 	}
 
-	buffer = drbd_md_get_buffer(device); /* protects md_io_buffer, al_tr_cycle, ... */
+	/* protects md_io_buffer, al_tr_cycle, ... */
+	buffer = drbd_md_get_buffer(device, __func__);
 	if (!buffer) {
 		drbd_err(device, "disk failed while waiting for md_io buffer\n");
 		put_ldev(device);
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index d85f43c..3f8281b 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -542,6 +542,11 @@ struct drbd_backing_dev {
 };
 
 struct drbd_md_io {
+	struct page *page;
+	unsigned long start_jif;	/* last call to drbd_md_get_buffer */
+	unsigned long submit_jif;	/* last _drbd_md_sync_page_io() submit */
+	const char *current_use;
+	atomic_t in_use;
 	unsigned int done;
 	int error;
 };
@@ -795,9 +800,7 @@ struct drbd_device {
 	atomic_t pp_in_use;		/* allocated from page pool */
 	atomic_t pp_in_use_by_net;	/* sendpage()d, still referenced by tcp */
 	wait_queue_head_t ee_wait;
-	struct page *md_io_page;	/* one page buffer for md_io */
 	struct drbd_md_io md_io;
-	atomic_t md_io_in_use;		/* protects the md_io, md_io_page and md_io_tmpp */
 	spinlock_t al_lock;
 	wait_queue_head_t al_wait;
 	struct lru_cache *act_log;	/* activity log */
@@ -1336,7 +1339,7 @@ extern void resume_next_sg(struct drbd_device *device);
 extern void suspend_other_sg(struct drbd_device *device);
 extern int drbd_resync_finished(struct drbd_device *device);
 /* maybe rather drbd_main.c ? */
-extern void *drbd_md_get_buffer(struct drbd_device *device);
+extern void *drbd_md_get_buffer(struct drbd_device *device, const char *intent);
 extern void drbd_md_put_buffer(struct drbd_device *device);
 extern int drbd_md_sync_page_io(struct drbd_device *device,
 		struct drbd_backing_dev *bdev, sector_t sector, int rw);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 56cf11b..3ab7461 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1916,7 +1916,7 @@ void drbd_init_set_defaults(struct drbd_device *device)
 	atomic_set(&device->rs_sect_in, 0);
 	atomic_set(&device->rs_sect_ev, 0);
 	atomic_set(&device->ap_in_flight, 0);
-	atomic_set(&device->md_io_in_use, 0);
+	atomic_set(&device->md_io.in_use, 0);
 
 	mutex_init(&device->own_state_mutex);
 	device->state_mutex = &device->own_state_mutex;
@@ -2187,7 +2187,7 @@ void drbd_destroy_device(struct kref *kref)
 
 	if (device->bitmap) /* should no longer be there. */
 		drbd_bm_cleanup(device);
-	__free_page(device->md_io_page);
+	__free_page(device->md_io.page);
 	put_disk(device->vdisk);
 	blk_cleanup_queue(device->rq_queue);
 	kfree(device->rs_plan_s);
@@ -2756,8 +2756,8 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	blk_queue_merge_bvec(q, drbd_merge_bvec);
 	q->queue_lock = &resource->req_lock;
 
-	device->md_io_page = alloc_page(GFP_KERNEL);
-	if (!device->md_io_page)
+	device->md_io.page = alloc_page(GFP_KERNEL);
+	if (!device->md_io.page)
 		goto out_no_io_page;
 
 	if (drbd_bm_init(device))
@@ -2845,7 +2845,7 @@ out_idr_remove_minor:
 out_no_minor_idr:
 	drbd_bm_cleanup(device);
 out_no_bitmap:
-	__free_page(device->md_io_page);
+	__free_page(device->md_io.page);
 out_no_io_page:
 	put_disk(disk);
 out_no_disk:
@@ -3079,7 +3079,7 @@ void drbd_md_sync(struct drbd_device *device)
 	if (!get_ldev_if_state(device, D_FAILED))
 		return;
 
-	buffer = drbd_md_get_buffer(device);
+	buffer = drbd_md_get_buffer(device, __func__);
 	if (!buffer)
 		goto out;
 
@@ -3239,7 +3239,7 @@ int drbd_md_read(struct drbd_device *device, struct drbd_backing_dev *bdev)
 	if (device->state.disk != D_DISKLESS)
 		return ERR_DISK_CONFIGURED;
 
-	buffer = drbd_md_get_buffer(device);
+	buffer = drbd_md_get_buffer(device, __func__);
 	if (!buffer)
 		return ERR_NOMEM;
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index c2e047f..7fcdc54 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -887,7 +887,7 @@ drbd_determine_dev_size(struct drbd_device *device, enum dds_flags flags, struct
 	 * still lock the act_log to not trigger ASSERTs there.
 	 */
 	drbd_suspend_io(device);
-	buffer = drbd_md_get_buffer(device); /* Lock meta-data IO */
+	buffer = drbd_md_get_buffer(device, __func__); /* Lock meta-data IO */
 	if (!buffer) {
 		drbd_resume_io(device);
 		return DS_ERROR;
@@ -1899,7 +1899,7 @@ static int adm_detach(struct drbd_device *device, int force)
 	}
 
 	drbd_suspend_io(device); /* so no-one is stuck in drbd_al_begin_io */
-	drbd_md_get_buffer(device); /* make sure there is no in-flight meta-data IO */
+	drbd_md_get_buffer(device, __func__); /* make sure there is no in-flight meta-data IO */
 	retcode = drbd_request_state(device, NS(disk, D_FAILED));
 	drbd_md_put_buffer(device);
 	/* D_FAILED will transition to DISKLESS. */
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index ad57129..3978d9e 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -67,13 +67,10 @@ rwlock_t global_state_lock;
  */
 void drbd_md_io_complete(struct bio *bio, int error)
 {
-	struct drbd_md_io *md_io;
 	struct drbd_device *device;
 
-	md_io = (struct drbd_md_io *)bio->bi_private;
-	device = container_of(md_io, struct drbd_device, md_io);
-
-	md_io->error = error;
+	device = bio->bi_private;
+	device->md_io.error = error;
 
 	/* We grabbed an extra reference in _drbd_md_sync_page_io() to be able
 	 * to timeout on the lower level device, and eventually detach from it.
@@ -87,7 +84,7 @@ void drbd_md_io_complete(struct bio *bio, int error)
 	 * ASSERT(atomic_read(&device->md_io_in_use) == 1) there.
 	 */
 	drbd_md_put_buffer(device);
-	md_io->done = 1;
+	device->md_io.done = 1;
 	wake_up(&device->misc_wait);
 	bio_put(bio);
 	if (device->ldev) /* special case: drbd_md_read() during drbd_adm_attach() */
-- 
1.9.1

