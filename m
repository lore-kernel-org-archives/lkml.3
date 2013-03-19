Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab3CSRVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:21:12 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44617 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279Ab3CSRRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:04 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 06/18] drbd: read meta data early, base on-disk offsets on super block
Date: Tue, 19 Mar 2013 18:16:47 +0100
Message-Id: <1363713419-17803-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

We used to calculate all on-disk meta data offsets, and then compare
the stored offsets, basically treating them as magic numbers.

Now with the activity log striping, the activity log size is no longer
fixed.  We need to first read the super block, then base the activity
log and bitmap offsets on the stored offsets/al stripe settings.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |   11 +++-
 drivers/block/drbd/drbd_main.c   |  131 +++++++++++++++++++++++++++++++-------
 drivers/block/drbd/drbd_nl.c     |   15 ++---
 drivers/block/drbd/drbd_worker.c |    3 +-
 4 files changed, 123 insertions(+), 37 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 7e7680e..c79625a 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -168,7 +168,11 @@ static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 	bio->bi_end_io = drbd_md_io_complete;
 	bio->bi_rw = rw;
 
-	if (!get_ldev_if_state(mdev, D_ATTACHING)) {  /* Corresponding put_ldev in drbd_md_io_complete() */
+	if (!(rw & WRITE) && mdev->state.disk == D_DISKLESS && mdev->ldev == NULL)
+		/* special case, drbd_md_read() during drbd_adm_attach(): no get_ldev */
+		;
+	else if (!get_ldev_if_state(mdev, D_ATTACHING)) {
+		/* Corresponding put_ldev in drbd_md_io_complete() */
 		dev_err(DEV, "ASSERT FAILED: get_ldev_if_state() == 1 in _drbd_md_sync_page_io()\n");
 		err = -ENODEV;
 		goto out;
@@ -199,9 +203,10 @@ int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
 
 	BUG_ON(!bdev->md_bdev);
 
-	dev_dbg(DEV, "meta_data io: %s [%d]:%s(,%llus,%s)\n",
+	dev_dbg(DEV, "meta_data io: %s [%d]:%s(,%llus,%s) %pS\n",
 	     current->comm, current->pid, __func__,
-	     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
+	     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ",
+	     (void*)_RET_IP_ );
 
 	if (sector < drbd_md_first_sector(bdev) ||
 	    sector + 7 > drbd_md_last_sector(bdev))
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index d8bbb41..3d212b9 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2971,6 +2971,86 @@ err:
 	return -EINVAL;
 }
 
+static int check_offsets_and_sizes(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
+{
+	sector_t capacity = drbd_get_capacity(bdev->md_bdev);
+	struct drbd_md *in_core = &bdev->md;
+	s32 on_disk_al_sect;
+	s32 on_disk_bm_sect;
+
+	/* The on-disk size of the activity log, calculated from offsets, and
+	 * the size of the activity log calculated from the stripe settings,
+	 * should match.
+	 * Though we could relax this a bit: it is ok, if the striped activity log
+	 * fits in the available on-disk activity log size.
+	 * Right now, that would break how resize is implemented.
+	 * TODO: make drbd_determine_dev_size() (and the drbdmeta tool) aware
+	 * of possible unused padding space in the on disk layout. */
+	if (in_core->al_offset < 0) {
+		if (in_core->bm_offset > in_core->al_offset)
+			goto err;
+		on_disk_al_sect = -in_core->al_offset;
+		on_disk_bm_sect = in_core->al_offset - in_core->bm_offset;
+	} else {
+		if (in_core->al_offset != MD_4kB_SECT)
+			goto err;
+		if (in_core->bm_offset < in_core->al_offset + in_core->al_size_4k * MD_4kB_SECT)
+			goto err;
+
+		on_disk_al_sect = in_core->bm_offset - MD_4kB_SECT;
+		on_disk_bm_sect = in_core->md_size_sect - in_core->bm_offset;
+	}
+
+	/* old fixed size meta data is exactly that: fixed. */
+	if (in_core->meta_dev_idx >= 0) {
+		if (in_core->md_size_sect != MD_128MB_SECT
+		||  in_core->al_offset != MD_4kB_SECT
+		||  in_core->bm_offset != MD_4kB_SECT + MD_32kB_SECT
+		||  in_core->al_stripes != 1
+		||  in_core->al_stripe_size_4k != MD_32kB_SECT/8)
+			goto err;
+	}
+
+	if (capacity < in_core->md_size_sect)
+		goto err;
+	if (capacity - in_core->md_size_sect < drbd_md_first_sector(bdev))
+		goto err;
+
+	/* should be aligned, and at least 32k */
+	if ((on_disk_al_sect & 7) || (on_disk_al_sect < MD_32kB_SECT))
+		goto err;
+
+	/* should fit (for now: exactly) into the available on-disk space;
+	 * overflow prevention is in check_activity_log_stripe_size() above. */
+	if (on_disk_al_sect != in_core->al_size_4k * MD_4kB_SECT)
+		goto err;
+
+	/* again, should be aligned */
+	if (in_core->bm_offset & 7)
+		goto err;
+
+	/* FIXME check for device grow with flex external meta data? */
+
+	/* can the available bitmap space cover the last agreed device size? */
+	if (on_disk_bm_sect < (in_core->la_size_sect+7)/MD_4kB_SECT/8/512)
+		goto err;
+
+	return 0;
+
+err:
+	dev_err(DEV, "meta data offsets don't make sense: idx=%d "
+			"al_s=%u, al_sz4k=%u, al_offset=%d, bm_offset=%d, "
+			"md_size_sect=%u, la_size=%llu, md_capacity=%llu\n",
+			in_core->meta_dev_idx,
+			in_core->al_stripes, in_core->al_stripe_size_4k,
+			in_core->al_offset, in_core->bm_offset, in_core->md_size_sect,
+			(unsigned long long)in_core->la_size_sect,
+			(unsigned long long)capacity);
+
+	return -EINVAL;
+}
+
+
 /**
  * drbd_md_read() - Reads in the meta data super block
  * @mdev:	DRBD device.
@@ -2979,7 +3059,8 @@ err:
  * Return NO_ERROR on success, and an enum drbd_ret_code in case
  * something goes wrong.
  *
- * Called exactly once during drbd_adm_attach()
+ * Called exactly once during drbd_adm_attach(), while still being D_DISKLESS,
+ * even before @bdev is assigned to @mdev->ldev.
  */
 int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 {
@@ -2987,14 +3068,15 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	u32 magic, flags;
 	int i, rv = NO_ERROR;
 
-	if (!get_ldev_if_state(mdev, D_ATTACHING))
-		return ERR_IO_MD_DISK;
+	if (mdev->state.disk != D_DISKLESS)
+		return ERR_DISK_CONFIGURED;
 
 	buffer = drbd_md_get_buffer(mdev);
 	if (!buffer)
-		goto out;
+		return ERR_NOMEM;
 
-	/* First, figure out where our meta data superblock is located. */
+	/* First, figure out where our meta data superblock is located,
+	 * and read it. */
 	bdev->md.meta_dev_idx = bdev->disk_conf->meta_dev_idx;
 	bdev->md.md_offset = drbd_md_ss(bdev);
 
@@ -3025,14 +3107,29 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 		goto err;
 	}
 
-	if (check_activity_log_stripe_size(mdev, buffer, &bdev->md))
+	if (be32_to_cpu(buffer->bm_bytes_per_bit) != BM_BLOCK_SIZE) {
+		dev_err(DEV, "unexpected bm_bytes_per_bit: %u (expected %u)\n",
+		    be32_to_cpu(buffer->bm_bytes_per_bit), BM_BLOCK_SIZE);
 		goto err;
+	}
 
-	if (be32_to_cpu(buffer->al_offset) != bdev->md.al_offset) {
-		dev_err(DEV, "unexpected al_offset: %d (expected %d)\n",
-		    be32_to_cpu(buffer->al_offset), bdev->md.al_offset);
+
+	/* convert to in_core endian */
+	bdev->md.la_size_sect = be64_to_cpu(buffer->la_size_sect);
+	for (i = UI_CURRENT; i < UI_SIZE; i++)
+		bdev->md.uuid[i] = be64_to_cpu(buffer->uuid[i]);
+	bdev->md.flags = be32_to_cpu(buffer->flags);
+	bdev->md.device_uuid = be64_to_cpu(buffer->device_uuid);
+
+	bdev->md.md_size_sect = be32_to_cpu(buffer->md_size_sect);
+	bdev->md.al_offset = be32_to_cpu(buffer->al_offset);
+	bdev->md.bm_offset = be32_to_cpu(buffer->bm_offset);
+
+	if (check_activity_log_stripe_size(mdev, buffer, &bdev->md))
 		goto err;
-	}
+	if (check_offsets_and_sizes(mdev, bdev))
+		goto err;
+
 	if (be32_to_cpu(buffer->bm_offset) != bdev->md.bm_offset) {
 		dev_err(DEV, "unexpected bm_offset: %d (expected %d)\n",
 		    be32_to_cpu(buffer->bm_offset), bdev->md.bm_offset);
@@ -3044,20 +3141,8 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 		goto err;
 	}
 
-	if (be32_to_cpu(buffer->bm_bytes_per_bit) != BM_BLOCK_SIZE) {
-		dev_err(DEV, "unexpected bm_bytes_per_bit: %u (expected %u)\n",
-		    be32_to_cpu(buffer->bm_bytes_per_bit), BM_BLOCK_SIZE);
-		goto err;
-	}
-
 	rv = NO_ERROR;
 
-	bdev->md.la_size_sect = be64_to_cpu(buffer->la_size_sect);
-	for (i = UI_CURRENT; i < UI_SIZE; i++)
-		bdev->md.uuid[i] = be64_to_cpu(buffer->uuid[i]);
-	bdev->md.flags = be32_to_cpu(buffer->flags);
-	bdev->md.device_uuid = be64_to_cpu(buffer->device_uuid);
-
 	spin_lock_irq(&mdev->tconn->req_lock);
 	if (mdev->state.conn < C_CONNECTED) {
 		unsigned int peer;
@@ -3069,8 +3154,6 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 
  err:
 	drbd_md_put_buffer(mdev);
- out:
-	put_ldev(mdev);
 
 	return rv;
 }
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index d5211b0..974ea47 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -721,7 +721,7 @@ static void drbd_md_set_sector_offsets(struct drbd_conf *mdev,
 				       struct drbd_backing_dev *bdev)
 {
 	sector_t md_size_sect = 0;
-	unsigned int al_size_sect = MD_32kB_SECT;
+	unsigned int al_size_sect = bdev->md.al_size_4k * 8;
 
 	bdev->md.md_offset = drbd_md_ss(bdev);
 
@@ -1413,8 +1413,11 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	/* RT - for drbd_get_max_capacity() DRBD_MD_INDEX_FLEX_INT */
-	drbd_md_set_sector_offsets(mdev, nbc);
+	/* Read our meta data super block early.
+	 * This also sets other on-disk offsets. */
+	retcode = drbd_md_read(mdev, nbc);
+	if (retcode != NO_ERROR)
+		goto fail;
 
 	if (drbd_get_max_capacity(nbc) < new_disk_conf->disk_size) {
 		dev_err(DEV, "max capacity %llu smaller than disk size %llu\n",
@@ -1481,8 +1484,6 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	if (!get_ldev_if_state(mdev, D_ATTACHING))
 		goto force_diskless;
 
-	drbd_md_set_sector_offsets(mdev, nbc);
-
 	if (!mdev->bitmap) {
 		if (drbd_bm_init(mdev)) {
 			retcode = ERR_NOMEM;
@@ -1490,10 +1491,6 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	retcode = drbd_md_read(mdev, nbc);
-	if (retcode != NO_ERROR)
-		goto force_diskless_dec;
-
 	if (mdev->state.conn < C_CONNECTED &&
 	    mdev->state.role == R_PRIMARY &&
 	    (mdev->ed_uuid & ~((u64)1)) != (nbc->md.uuid[UI_CURRENT] & ~((u64)1))) {
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 424dc7b..34b5d5d 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -89,7 +89,8 @@ void drbd_md_io_complete(struct bio *bio, int error)
 	md_io->done = 1;
 	wake_up(&mdev->misc_wait);
 	bio_put(bio);
-	put_ldev(mdev);
+	if (mdev->ldev) /* special case: drbd_md_read() during drbd_adm_attach() */
+		put_ldev(mdev);
 }
 
 /* reads on behalf of the partner,
-- 
1.7.9.5

