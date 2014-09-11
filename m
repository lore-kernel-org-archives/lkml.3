Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbaIKM3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:29:19 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:47783 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbaIKM3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:29:17 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 2/9] drbd: Use consistent names for all the bi_end_io callbacks
Date: Thu, 11 Sep 2014 14:29:06 +0200
Message-Id: <1410438553-30440-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
References: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>

Now they follow the _endio naming sheme.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c | 4 ++--
 drivers/block/drbd/drbd_bitmap.c | 6 +++---
 drivers/block/drbd/drbd_int.h    | 2 +-
 drivers/block/drbd/drbd_worker.c | 6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index d26a3fa..a2dfa16 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -158,14 +158,14 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 	if (bio_add_page(bio, device->md_io.page, size, 0) != size)
 		goto out;
 	bio->bi_private = device;
-	bio->bi_end_io = drbd_md_io_complete;
+	bio->bi_end_io = drbd_md_endio;
 	bio->bi_rw = rw;
 
 	if (!(rw & WRITE) && device->state.disk == D_DISKLESS && device->ldev == NULL)
 		/* special case, drbd_md_read() during drbd_adm_attach(): no get_ldev */
 		;
 	else if (!get_ldev_if_state(device, D_ATTACHING)) {
-		/* Corresponding put_ldev in drbd_md_io_complete() */
+		/* Corresponding put_ldev in drbd_md_endio() */
 		drbd_err(device, "ASSERT FAILED: get_ldev_if_state() == 1 in _drbd_md_sync_page_io()\n");
 		err = -ENODEV;
 		goto out;
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 426c97a..434c77d 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -941,7 +941,7 @@ static void drbd_bm_aio_ctx_destroy(struct kref *kref)
 }
 
 /* bv_page may be a copy, or may be the original */
-static void bm_async_io_complete(struct bio *bio, int error)
+static void drbd_bm_endio(struct bio *bio, int error)
 {
 	struct drbd_bm_aio_ctx *ctx = bio->bi_private;
 	struct drbd_device *device = ctx->device;
@@ -1027,7 +1027,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 	 * according to api.  Do we want to assert that? */
 	bio_add_page(bio, page, len, 0);
 	bio->bi_private = ctx;
-	bio->bi_end_io = bm_async_io_complete;
+	bio->bi_end_io = drbd_bm_endio;
 
 	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD)) {
 		bio->bi_rw |= rw;
@@ -1125,7 +1125,7 @@ static int bm_rw(struct drbd_device *device, const unsigned int flags, unsigned
 	}
 
 	/*
-	 * We initialize ctx->in_flight to one to make sure bm_async_io_complete
+	 * We initialize ctx->in_flight to one to make sure drbd_bm_endio
 	 * will not set ctx->done early, and decrement / test it here.  If there
 	 * are still some bios in flight, we need to wait for them here.
 	 * If all IO is done already (or nothing had been submitted), there is
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 9e1288e..f424dc0 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1483,7 +1483,7 @@ extern int drbd_khelper(struct drbd_device *device, char *cmd);
 
 /* drbd_worker.c */
 /* bi_end_io handlers */
-extern void drbd_md_io_complete(struct bio *bio, int error);
+extern void drbd_md_endio(struct bio *bio, int error);
 extern void drbd_peer_request_endio(struct bio *bio, int error);
 extern void drbd_request_endio(struct bio *bio, int error);
 extern int drbd_worker(struct drbd_thread *thi);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 50776b3..6e01e62 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -43,10 +43,10 @@ static int make_ov_request(struct drbd_device *, int);
 static int make_resync_request(struct drbd_device *, int);
 
 /* endio handlers:
- *   drbd_md_io_complete (defined here)
+ *   drbd_md_endio (defined here)
  *   drbd_request_endio (defined here)
  *   drbd_peer_request_endio (defined here)
- *   bm_async_io_complete (defined in drbd_bitmap.c)
+ *   drbd_bm_endio (defined in drbd_bitmap.c)
  *
  * For all these callbacks, note the following:
  * The callbacks will be called in irq context by the IDE drivers,
@@ -65,7 +65,7 @@ rwlock_t global_state_lock;
 /* used for synchronous meta data and bitmap IO
  * submitted by drbd_md_sync_page_io()
  */
-void drbd_md_io_complete(struct bio *bio, int error)
+void drbd_md_endio(struct bio *bio, int error)
 {
 	struct drbd_device *device;
 
-- 
1.9.1

