Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbaF3QCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:02:50 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:49989 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbaF3PxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/18] drbd: device->ldev is not guaranteed on an D_ATTACHING disk
Date: Mon, 30 Jun 2014 17:52:51 +0200
Message-Id: <1404143587-24344-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some parts of the code assumed that get_ldev_if_state(device, D_ATTACHING)
is sufficient to access the ldev member of the device object. That was
wrong. ldev may not be there or might be freed at any time if the device
has a disk state of D_ATTACHING.

bm_rw()
  Documented that drbd_bm_read() is only called from drbd_adm_attach.
  drbd_bm_write() is only called when a reference is held, and it is
  documented that a caller has to hold a reference before calling
  drbd_bm_write()

drbd_bm_write_page()
  Use get_ldev() instead of get_ldev_if_state(device, D_ATTACHING)

drbd_bmio_set_n_write()
  No longer use get_ldev_if_state(device, D_ATTACHING). All callers
  hold a reference to ldev now.

drbd_bmio_clear_n_write()
  All callers where holding a reference of ldev anyways. Remove the
  misleading get_ldev_if_state(device, D_ATTACHING)

drbd_reconsider_max_bio_size()
  Removed the get_ldev_if_state(device, D_ATTACHING). All callers
  now pass a struct drbd_backing_dev* when they have a proper
  reference, or a NULL pointer.
  Before this fix, the receiver could trigger a NULL pointer
  deref when in drbd_reconsider_max_bio_size()

drbd_bump_write_ordering()
  Used get_ldev_if_state(device, D_ATTACHING) with the wrong assumption.
  Remove it, and allow the caller to pass in a struct drbd_backing_dev*
  when the caller knows that accessing this bdev is safe.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_bitmap.c   |  4 +++-
 drivers/block/drbd/drbd_int.h      |  9 ++++----
 drivers/block/drbd/drbd_main.c     | 36 +++++++++++++------------------
 drivers/block/drbd/drbd_nl.c       | 41 +++++++++++++++++++++++-------------
 drivers/block/drbd/drbd_receiver.c | 43 ++++++++++++++++++++++++++------------
 include/linux/drbd.h               |  2 +-
 6 files changed, 79 insertions(+), 56 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 1aa29f8..ed31041 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1085,6 +1085,8 @@ static int bm_rw(struct drbd_device *device, int rw, unsigned flags, unsigned la
 		kfree(ctx);
 		return -ENODEV;
 	}
+	/* Here D_ATTACHING is sufficient since drbd_bm_read() is called only from
+	   drbd_adm_attach(), after device->ldev was assigned. */
 
 	if (!ctx->flags)
 		WARN_ON(!(BM_LOCKED_MASK & b->bm_flags));
@@ -1260,7 +1262,7 @@ int drbd_bm_write_page(struct drbd_device *device, unsigned int idx) __must_hold
 		.kref = { ATOMIC_INIT(2) },
 	};
 
-	if (!get_ldev_if_state(device, D_ATTACHING)) {  /* put is in bm_aio_ctx_destroy() */
+	if (!get_ldev(device)) {  /* put is in bm_aio_ctx_destroy() */
 		drbd_err(device, "ASSERT FAILED: get_ldev_if_state() == 1 in drbd_bm_write_page()\n");
 		kfree(ctx);
 		return -ENODEV;
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 1ef2474..c87bc8e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -984,8 +984,8 @@ extern int drbd_bitmap_io(struct drbd_device *device,
 extern int drbd_bitmap_io_from_worker(struct drbd_device *device,
 		int (*io_fn)(struct drbd_device *),
 		char *why, enum bm_flag flags);
-extern int drbd_bmio_set_n_write(struct drbd_device *device);
-extern int drbd_bmio_clear_n_write(struct drbd_device *device);
+extern int drbd_bmio_set_n_write(struct drbd_device *device) __must_hold(local);
+extern int drbd_bmio_clear_n_write(struct drbd_device *device) __must_hold(local);
 extern void drbd_ldev_destroy(struct drbd_device *device);
 
 /* Meta data layout
@@ -1313,7 +1313,7 @@ enum determine_dev_size {
 extern enum determine_dev_size
 drbd_determine_dev_size(struct drbd_device *, enum dds_flags, struct resize_parms *) __must_hold(local);
 extern void resync_after_online_grow(struct drbd_device *);
-extern void drbd_reconsider_max_bio_size(struct drbd_device *device);
+extern void drbd_reconsider_max_bio_size(struct drbd_device *device, struct drbd_backing_dev *bdev);
 extern enum drbd_state_rv drbd_set_role(struct drbd_device *device,
 					enum drbd_role new_role,
 					int force);
@@ -1479,7 +1479,8 @@ static inline void drbd_generic_make_request(struct drbd_device *device,
 		generic_make_request(bio);
 }
 
-void drbd_bump_write_ordering(struct drbd_resource *resource, enum write_ordering_e wo);
+void drbd_bump_write_ordering(struct drbd_resource *resource, struct drbd_backing_dev *bdev,
+			      enum write_ordering_e wo);
 
 /* drbd_proc.c */
 extern struct proc_dir_entry *drbd_proc;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 17b9a23..a6af935 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3466,23 +3466,19 @@ void drbd_uuid_set_bm(struct drbd_device *device, u64 val) __must_hold(local)
  *
  * Sets all bits in the bitmap and writes the whole bitmap to stable storage.
  */
-int drbd_bmio_set_n_write(struct drbd_device *device)
+int drbd_bmio_set_n_write(struct drbd_device *device) __must_hold(local)
 {
 	int rv = -EIO;
 
-	if (get_ldev_if_state(device, D_ATTACHING)) {
-		drbd_md_set_flag(device, MDF_FULL_SYNC);
-		drbd_md_sync(device);
-		drbd_bm_set_all(device);
-
-		rv = drbd_bm_write(device);
+	drbd_md_set_flag(device, MDF_FULL_SYNC);
+	drbd_md_sync(device);
+	drbd_bm_set_all(device);
 
-		if (!rv) {
-			drbd_md_clear_flag(device, MDF_FULL_SYNC);
-			drbd_md_sync(device);
-		}
+	rv = drbd_bm_write(device);
 
-		put_ldev(device);
+	if (!rv) {
+		drbd_md_clear_flag(device, MDF_FULL_SYNC);
+		drbd_md_sync(device);
 	}
 
 	return rv;
@@ -3494,18 +3490,11 @@ int drbd_bmio_set_n_write(struct drbd_device *device)
  *
  * Clears all bits in the bitmap and writes the whole bitmap to stable storage.
  */
-int drbd_bmio_clear_n_write(struct drbd_device *device)
+int drbd_bmio_clear_n_write(struct drbd_device *device) __must_hold(local)
 {
-	int rv = -EIO;
-
 	drbd_resume_al(device);
-	if (get_ldev_if_state(device, D_ATTACHING)) {
-		drbd_bm_clear_all(device);
-		rv = drbd_bm_write(device);
-		put_ldev(device);
-	}
-
-	return rv;
+	drbd_bm_clear_all(device);
+	return drbd_bm_write(device);
 }
 
 static int w_bitmap_io(struct drbd_work *w, int unused)
@@ -3603,6 +3592,9 @@ static int w_go_diskless(struct drbd_work *w, int unused)
  * that drbd_set_out_of_sync() can not be called. This function MAY ONLY be
  * called from worker context. It MUST NOT be used while a previous such
  * work is still pending!
+ *
+ * Its worker function encloses the call of io_fn() by get_ldev() and
+ * put_ldev().
  */
 void drbd_queue_bitmap_io(struct drbd_device *device,
 			  int (*io_fn)(struct drbd_device *),
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 43fad2c..25f4b6f 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1110,15 +1110,16 @@ static int drbd_check_al_size(struct drbd_device *device, struct disk_conf *dc)
 	return 0;
 }
 
-static void drbd_setup_queue_param(struct drbd_device *device, unsigned int max_bio_size)
+static void drbd_setup_queue_param(struct drbd_device *device, struct drbd_backing_dev *bdev,
+				   unsigned int max_bio_size)
 {
 	struct request_queue * const q = device->rq_queue;
 	unsigned int max_hw_sectors = max_bio_size >> 9;
 	unsigned int max_segments = 0;
 	struct request_queue *b = NULL;
 
-	if (get_ldev_if_state(device, D_ATTACHING)) {
-		b = device->ldev->backing_bdev->bd_disk->queue;
+	if (bdev) {
+		b = bdev->backing_bdev->bd_disk->queue;
 
 		max_hw_sectors = min(queue_max_hw_sectors(b), max_bio_size >> 9);
 		rcu_read_lock();
@@ -1163,11 +1164,10 @@ static void drbd_setup_queue_param(struct drbd_device *device, unsigned int max_
 				 b->backing_dev_info.ra_pages);
 			q->backing_dev_info.ra_pages = b->backing_dev_info.ra_pages;
 		}
-		put_ldev(device);
 	}
 }
 
-void drbd_reconsider_max_bio_size(struct drbd_device *device)
+void drbd_reconsider_max_bio_size(struct drbd_device *device, struct drbd_backing_dev *bdev)
 {
 	unsigned int now, new, local, peer;
 
@@ -1175,10 +1175,9 @@ void drbd_reconsider_max_bio_size(struct drbd_device *device)
 	local = device->local_max_bio_size; /* Eventually last known value, from volatile memory */
 	peer = device->peer_max_bio_size; /* Eventually last known value, from meta data */
 
-	if (get_ldev_if_state(device, D_ATTACHING)) {
-		local = queue_max_hw_sectors(device->ldev->backing_bdev->bd_disk->queue) << 9;
+	if (bdev) {
+		local = queue_max_hw_sectors(bdev->backing_bdev->bd_disk->queue) << 9;
 		device->local_max_bio_size = local;
-		put_ldev(device);
 	}
 	local = min(local, DRBD_MAX_BIO_SIZE);
 
@@ -1211,7 +1210,7 @@ void drbd_reconsider_max_bio_size(struct drbd_device *device)
 	if (new != now)
 		drbd_info(device, "max BIO size = %u\n", new);
 
-	drbd_setup_queue_param(device, new);
+	drbd_setup_queue_param(device, bdev, new);
 }
 
 /* Starts the worker thread */
@@ -1399,7 +1398,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	else
 		set_bit(MD_NO_FUA, &device->flags);
 
-	drbd_bump_write_ordering(device->resource, WO_bdev_flush);
+	drbd_bump_write_ordering(device->resource, NULL, WO_bdev_flush);
 
 	drbd_md_sync(device);
 
@@ -1704,7 +1703,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	new_disk_conf = NULL;
 	new_plan = NULL;
 
-	drbd_bump_write_ordering(device->resource, WO_bdev_flush);
+	drbd_bump_write_ordering(device->resource, device->ldev, WO_bdev_flush);
 
 	if (drbd_md_test_flag(device->ldev, MDF_CRASHED_PRIMARY))
 		set_bit(CRASHED_PRIMARY, &device->flags);
@@ -1720,7 +1719,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	device->read_cnt = 0;
 	device->writ_cnt = 0;
 
-	drbd_reconsider_max_bio_size(device);
+	drbd_reconsider_max_bio_size(device, device->ldev);
 
 	/* If I am currently not R_PRIMARY,
 	 * but meta data primary indicator is set,
@@ -2648,8 +2647,13 @@ int drbd_adm_invalidate(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	mutex_lock(&adm_ctx.resource->adm_mutex);
 	device = adm_ctx.device;
+	if (!get_ldev(device)) {
+		retcode = ERR_NO_DISK;
+		goto out;
+	}
+
+	mutex_lock(&adm_ctx.resource->adm_mutex);
 
 	/* If there is still bitmap IO pending, probably because of a previous
 	 * resync just being finished, wait for it before requesting a new resync.
@@ -2673,6 +2677,7 @@ int drbd_adm_invalidate(struct sk_buff *skb, struct genl_info *info)
 		retcode = drbd_request_state(device, NS(conn, C_STARTING_SYNC_T));
 	drbd_resume_io(device);
 	mutex_unlock(&adm_ctx.resource->adm_mutex);
+	put_ldev(device);
 out:
 	drbd_adm_finish(&adm_ctx, info, retcode);
 	return 0;
@@ -2698,7 +2703,7 @@ out:
 	return 0;
 }
 
-static int drbd_bmio_set_susp_al(struct drbd_device *device)
+static int drbd_bmio_set_susp_al(struct drbd_device *device) __must_hold(local)
 {
 	int rv;
 
@@ -2719,8 +2724,13 @@ int drbd_adm_invalidate_peer(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	mutex_lock(&adm_ctx.resource->adm_mutex);
 	device = adm_ctx.device;
+	if (!get_ldev(device)) {
+		retcode = ERR_NO_DISK;
+		goto out;
+	}
+
+	mutex_lock(&adm_ctx.resource->adm_mutex);
 
 	/* If there is still bitmap IO pending, probably because of a previous
 	 * resync just being finished, wait for it before requesting a new resync.
@@ -2747,6 +2757,7 @@ int drbd_adm_invalidate_peer(struct sk_buff *skb, struct genl_info *info)
 		retcode = drbd_request_state(device, NS(conn, C_STARTING_SYNC_S));
 	drbd_resume_io(device);
 	mutex_unlock(&adm_ctx.resource->adm_mutex);
+	put_ldev(device);
 out:
 	drbd_adm_finish(&adm_ctx, info, retcode);
 	return 0;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index c708418..be0c376 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1168,7 +1168,7 @@ static void drbd_flush(struct drbd_connection *connection)
 				/* would rather check on EOPNOTSUPP, but that is not reliable.
 				 * don't try again for ANY return value != 0
 				 * if (rv == -EOPNOTSUPP) */
-				drbd_bump_write_ordering(connection->resource, WO_drain_io);
+				drbd_bump_write_ordering(connection->resource, NULL, WO_drain_io);
 			}
 			put_ldev(device);
 			kref_put(&device->kref, drbd_destroy_device);
@@ -1257,14 +1257,29 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_connection *connectio
 	return rv;
 }
 
+static enum write_ordering_e
+max_allowed_wo(struct drbd_backing_dev *bdev, enum write_ordering_e wo)
+{
+	struct disk_conf *dc;
+
+	dc = rcu_dereference(bdev->disk_conf);
+
+	if (wo == WO_bdev_flush && !dc->disk_flushes)
+		wo = WO_drain_io;
+	if (wo == WO_drain_io && !dc->disk_drain)
+		wo = WO_none;
+
+	return wo;
+}
+
 /**
  * drbd_bump_write_ordering() - Fall back to an other write ordering method
  * @connection:	DRBD connection.
  * @wo:		Write ordering method to try.
  */
-void drbd_bump_write_ordering(struct drbd_resource *resource, enum write_ordering_e wo)
+void drbd_bump_write_ordering(struct drbd_resource *resource, struct drbd_backing_dev *bdev,
+			      enum write_ordering_e wo)
 {
-	struct disk_conf *dc;
 	struct drbd_device *device;
 	enum write_ordering_e pwo;
 	int vnr;
@@ -1278,17 +1293,18 @@ void drbd_bump_write_ordering(struct drbd_resource *resource, enum write_orderin
 	wo = min(pwo, wo);
 	rcu_read_lock();
 	idr_for_each_entry(&resource->devices, device, vnr) {
-		if (!get_ldev_if_state(device, D_ATTACHING))
-			continue;
-		dc = rcu_dereference(device->ldev->disk_conf);
-
-		if (wo == WO_bdev_flush && !dc->disk_flushes)
-			wo = WO_drain_io;
-		if (wo == WO_drain_io && !dc->disk_drain)
-			wo = WO_none;
-		put_ldev(device);
+		if (get_ldev(device)) {
+			wo = max_allowed_wo(device->ldev, wo);
+			if (device->ldev == bdev)
+				bdev = NULL;
+			put_ldev(device);
+		}
 	}
 	rcu_read_unlock();
+
+	if (bdev)
+		wo = max_allowed_wo(bdev, wo);
+
 	resource->write_ordering = wo;
 	if (pwo != resource->write_ordering || wo == WO_bdev_flush)
 		drbd_info(resource, "Method to ensure write ordering: %s\n", write_ordering_str[resource->write_ordering]);
@@ -3709,7 +3725,6 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 	}
 
 	device->peer_max_bio_size = be32_to_cpu(p->max_bio_size);
-	drbd_reconsider_max_bio_size(device);
 	/* Leave drbd_reconsider_max_bio_size() before drbd_determine_dev_size().
 	   In case we cleared the QUEUE_FLAG_DISCARD from our queue in
 	   drbd_reconsider_max_bio_size(), we can be sure that after
@@ -3717,6 +3732,7 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 
 	ddsf = be16_to_cpu(p->dds_flags);
 	if (get_ldev(device)) {
+		drbd_reconsider_max_bio_size(device, device->ldev);
 		dd = drbd_determine_dev_size(device, ddsf, NULL);
 		put_ldev(device);
 		if (dd == DS_ERROR)
@@ -3724,6 +3740,7 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 		drbd_md_sync(device);
 	} else {
 		/* I am diskless, need to accept the peer's size. */
+		drbd_reconsider_max_bio_size(device, NULL);
 		drbd_set_my_capacity(device, p_size);
 	}
 
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 3dbe9bd..20ec890 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -245,7 +245,7 @@ enum drbd_disk_state {
 	D_DISKLESS,
 	D_ATTACHING,      /* In the process of reading the meta-data */
 	D_FAILED,         /* Becomes D_DISKLESS as soon as we told it the peer */
-			/* when >= D_FAILED it is legal to access mdev->bc */
+			  /* when >= D_FAILED it is legal to access mdev->ldev */
 	D_NEGOTIATING,    /* Late attaching state, we need to talk to the peer */
 	D_INCONSISTENT,
 	D_OUTDATED,
-- 
1.9.1

