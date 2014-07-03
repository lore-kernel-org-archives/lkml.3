Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbaGCIuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:50:17 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45907 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbaGCInV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/23] drbd: track details of bitmap IO
Date: Thu,  3 Jul 2014 10:43:02 +0200
Message-Id: <1404376995-4877-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Track start and submit time of bitmap operations, and
add pending bitmap IO contexts to a new pending_bitmap_io list.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_bitmap.c | 70 +++++++++++++++++++---------------------
 drivers/block/drbd/drbd_int.h    | 16 +++++++++
 drivers/block/drbd/drbd_main.c   |  1 +
 3 files changed, 51 insertions(+), 36 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index c5f5a20..f435e7e 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -928,22 +928,14 @@ void drbd_bm_clear_all(struct drbd_device *device)
 	spin_unlock_irq(&b->bm_lock);
 }
 
-struct bm_aio_ctx {
-	struct drbd_device *device;
-	atomic_t in_flight;
-	unsigned int done;
-	unsigned flags;
-#define BM_AIO_COPY_PAGES	1
-#define BM_AIO_WRITE_HINTED	2
-#define BM_WRITE_ALL_PAGES	4
-	int error;
-	struct kref kref;
-};
-
-static void bm_aio_ctx_destroy(struct kref *kref)
+static void drbd_bm_aio_ctx_destroy(struct kref *kref)
 {
-	struct bm_aio_ctx *ctx = container_of(kref, struct bm_aio_ctx, kref);
+	struct drbd_bm_aio_ctx *ctx = container_of(kref, struct drbd_bm_aio_ctx, kref);
+	unsigned long flags;
 
+	spin_lock_irqsave(&ctx->device->resource->req_lock, flags);
+	list_del(&ctx->list);
+	spin_unlock_irqrestore(&ctx->device->resource->req_lock, flags);
 	put_ldev(ctx->device);
 	kfree(ctx);
 }
@@ -951,7 +943,7 @@ static void bm_aio_ctx_destroy(struct kref *kref)
 /* bv_page may be a copy, or may be the original */
 static void bm_async_io_complete(struct bio *bio, int error)
 {
-	struct bm_aio_ctx *ctx = bio->bi_private;
+	struct drbd_bm_aio_ctx *ctx = bio->bi_private;
 	struct drbd_device *device = ctx->device;
 	struct drbd_bitmap *b = device->bitmap;
 	unsigned int idx = bm_page_to_idx(bio->bi_io_vec[0].bv_page);
@@ -994,17 +986,18 @@ static void bm_async_io_complete(struct bio *bio, int error)
 	if (atomic_dec_and_test(&ctx->in_flight)) {
 		ctx->done = 1;
 		wake_up(&device->misc_wait);
-		kref_put(&ctx->kref, &bm_aio_ctx_destroy);
+		kref_put(&ctx->kref, &drbd_bm_aio_ctx_destroy);
 	}
 }
 
-static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must_hold(local)
+static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_hold(local)
 {
 	struct bio *bio = bio_alloc_drbd(GFP_NOIO);
 	struct drbd_device *device = ctx->device;
 	struct drbd_bitmap *b = device->bitmap;
 	struct page *page;
 	unsigned int len;
+	unsigned int rw = (ctx->flags & BM_AIO_READ) ? READ : WRITE;
 
 	sector_t on_disk_sector =
 		device->ldev->md.md_offset + device->ldev->md.bm_offset;
@@ -1050,9 +1043,9 @@ static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must
 /*
  * bm_rw: read/write the whole bitmap from/to its on disk location.
  */
-static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned lazy_writeout_upper_idx) __must_hold(local)
+static int bm_rw(struct drbd_device *device, const unsigned int flags, unsigned lazy_writeout_upper_idx) __must_hold(local)
 {
-	struct bm_aio_ctx *ctx;
+	struct drbd_bm_aio_ctx *ctx;
 	struct drbd_bitmap *b = device->bitmap;
 	int num_pages, i, count = 0;
 	unsigned long now;
@@ -1068,12 +1061,13 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
 	 * as we submit copies of pages anyways.
 	 */
 
-	ctx = kmalloc(sizeof(struct bm_aio_ctx), GFP_NOIO);
+	ctx = kmalloc(sizeof(struct drbd_bm_aio_ctx), GFP_NOIO);
 	if (!ctx)
 		return -ENOMEM;
 
-	*ctx = (struct bm_aio_ctx) {
+	*ctx = (struct drbd_bm_aio_ctx) {
 		.device = device,
+		.start_jif = jiffies,
 		.in_flight = ATOMIC_INIT(1),
 		.done = 0,
 		.flags = flags,
@@ -1081,7 +1075,7 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
 		.kref = { ATOMIC_INIT(2) },
 	};
 
-	if (!get_ldev_if_state(device, D_ATTACHING)) {  /* put is in bm_aio_ctx_destroy() */
+	if (!get_ldev_if_state(device, D_ATTACHING)) {  /* put is in drbd_bm_aio_ctx_destroy() */
 		drbd_err(device, "ASSERT FAILED: get_ldev_if_state() == 1 in bm_rw()\n");
 		kfree(ctx);
 		return -ENODEV;
@@ -1089,9 +1083,13 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
 	/* Here D_ATTACHING is sufficient since drbd_bm_read() is called only from
 	   drbd_adm_attach(), after device->ldev was assigned. */
 
-	if (!ctx->flags)
+	if (0 == (ctx->flags & ~BM_AIO_READ))
 		WARN_ON(!(BM_LOCKED_MASK & b->bm_flags));
 
+	spin_lock_irq(&device->resource->req_lock);
+	list_add_tail(&ctx->list, &device->pending_bitmap_io);
+	spin_unlock_irq(&device->resource->req_lock);
+
 	num_pages = b->bm_number_of_pages;
 
 	now = jiffies;
@@ -1101,13 +1099,13 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
 		/* ignore completely unchanged pages */
 		if (lazy_writeout_upper_idx && i == lazy_writeout_upper_idx)
 			break;
-		if (rw & WRITE) {
+		if (!(flags & BM_AIO_READ)) {
 			if ((flags & BM_AIO_WRITE_HINTED) &&
 			    !test_and_clear_bit(BM_PAGE_HINT_WRITEOUT,
 				    &page_private(b->bm_pages[i])))
 				continue;
 
-			if (!(flags & BM_WRITE_ALL_PAGES) &&
+			if (!(flags & BM_AIO_WRITE_ALL_PAGES) &&
 			    bm_test_page_unchanged(b->bm_pages[i])) {
 				dynamic_drbd_dbg(device, "skipped bm write for idx %u\n", i);
 				continue;
@@ -1121,7 +1119,7 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
 			}
 		}
 		atomic_inc(&ctx->in_flight);
-		bm_page_io_async(ctx, i, rw);
+		bm_page_io_async(ctx, i);
 		++count;
 		cond_resched();
 	}
@@ -1137,12 +1135,12 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
 	if (!atomic_dec_and_test(&ctx->in_flight))
 		wait_until_done_or_force_detached(device, device->ldev, &ctx->done);
 	else
-		kref_put(&ctx->kref, &bm_aio_ctx_destroy);
+		kref_put(&ctx->kref, &drbd_bm_aio_ctx_destroy);
 
 	/* summary for global bitmap IO */
 	if (flags == 0)
 		drbd_info(device, "bitmap %s of %u pages took %lu jiffies\n",
-			 rw == WRITE ? "WRITE" : "READ",
+			 (flags & BM_AIO_READ) ? "READ" : "WRITE",
 			 count, jiffies - now);
 
 	if (ctx->error) {
@@ -1155,18 +1153,18 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
 		err = -EIO; /* Disk timeout/force-detach during IO... */
 
 	now = jiffies;
-	if (rw == READ) {
+	if (flags & BM_AIO_READ) {
 		b->bm_set = bm_count_bits(b);
 		drbd_info(device, "recounting of set bits took additional %lu jiffies\n",
 		     jiffies - now);
 	}
 	now = b->bm_set;
 
-	if (flags == 0)
+	if ((flags & ~BM_AIO_READ) == 0)
 		drbd_info(device, "%s (%lu bits) marked out-of-sync by on disk bit-map.\n",
 		     ppsize(ppb, now << (BM_BLOCK_SHIFT-10)), now);
 
-	kref_put(&ctx->kref, &bm_aio_ctx_destroy);
+	kref_put(&ctx->kref, &drbd_bm_aio_ctx_destroy);
 	return err;
 }
 
@@ -1176,7 +1174,7 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
  */
 int drbd_bm_read(struct drbd_device *device) __must_hold(local)
 {
-	return bm_rw(device, READ, 0, 0);
+	return bm_rw(device, BM_AIO_READ, 0);
 }
 
 /**
@@ -1187,7 +1185,7 @@ int drbd_bm_read(struct drbd_device *device) __must_hold(local)
  */
 int drbd_bm_write(struct drbd_device *device) __must_hold(local)
 {
-	return bm_rw(device, WRITE, 0, 0);
+	return bm_rw(device, 0, 0);
 }
 
 /**
@@ -1198,7 +1196,7 @@ int drbd_bm_write(struct drbd_device *device) __must_hold(local)
  */
 int drbd_bm_write_all(struct drbd_device *device) __must_hold(local)
 {
-	return bm_rw(device, WRITE, BM_WRITE_ALL_PAGES, 0);
+	return bm_rw(device, BM_AIO_WRITE_ALL_PAGES, 0);
 }
 
 /**
@@ -1214,7 +1212,7 @@ int drbd_bm_write_all(struct drbd_device *device) __must_hold(local)
  */
 int drbd_bm_write_copy_pages(struct drbd_device *device) __must_hold(local)
 {
-	return bm_rw(device, WRITE, BM_AIO_COPY_PAGES, 0);
+	return bm_rw(device, BM_AIO_COPY_PAGES, 0);
 }
 
 /**
@@ -1223,7 +1221,7 @@ int drbd_bm_write_copy_pages(struct drbd_device *device) __must_hold(local)
  */
 int drbd_bm_write_hinted(struct drbd_device *device) __must_hold(local)
 {
-	return bm_rw(device, WRITE, BM_AIO_WRITE_HINTED | BM_AIO_COPY_PAGES, 0);
+	return bm_rw(device, BM_AIO_WRITE_HINTED | BM_AIO_COPY_PAGES, 0);
 }
 
 /* NOTE
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c7a409f..40c816c 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -777,6 +777,7 @@ struct drbd_peer_device {
 struct drbd_device {
 	struct drbd_resource *resource;
 	struct list_head peer_devices;
+	struct list_head pending_bitmap_io;
 	int vnr;			/* volume number within the connection */
 	struct kref kref;
 
@@ -918,6 +919,21 @@ struct drbd_device {
 	struct submit_worker submit;
 };
 
+struct drbd_bm_aio_ctx {
+	struct drbd_device *device;
+	struct list_head list; /* on device->pending_bitmap_io */;
+	unsigned long start_jif;
+	atomic_t in_flight;
+	unsigned int done;
+	unsigned flags;
+#define BM_AIO_COPY_PAGES	1
+#define BM_AIO_WRITE_HINTED	2
+#define BM_AIO_WRITE_ALL_PAGES	4
+#define BM_AIO_READ		8
+	int error;
+	struct kref kref;
+};
+
 struct drbd_config_context {
 	/* assigned from drbd_genlmsghdr */
 	unsigned int minor;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index ad7c0e8..922d631 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2793,6 +2793,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	kref_get(&device->kref);
 
 	INIT_LIST_HEAD(&device->peer_devices);
+	INIT_LIST_HEAD(&device->pending_bitmap_io);
 	for_each_connection(connection, resource) {
 		peer_device = kzalloc(sizeof(struct drbd_peer_device), GFP_KERNEL);
 		if (!peer_device)
-- 
1.9.1

