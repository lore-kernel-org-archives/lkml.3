Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab3CSRRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:17:06 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44513 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045Ab3CSRRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:02 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 03/18] drbd: prepare for new striped layout of activity log
Date: Tue, 19 Mar 2013 18:16:44 +0100
Message-Id: <1363713419-17803-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Introduce two new on-disk meta data fields: al_stripes and al_stripe_size_4k
The intended use case is activity log on RAID 0 or similar.
Logically consecutive transactions will advance their on-disk position
by al_stripe_size_4k 4kB (transaction sized) blocks.

Right now, these are still asserted to be the backward compatible
values al_stripes = 1, al_stripe_size_4k = 8 (which amounts to 32kB).

Also introduce a caching member for meta_dev_idx in the in-core
structure: even though it is initially passed in in the rcu-protected
disk_conf structure, it cannot change without a detach/attach cycle.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |    6 +--
 drivers/block/drbd/drbd_int.h    |   46 ++++++++++-------------
 drivers/block/drbd/drbd_main.c   |   77 ++++++++++++++++++++++++++++++++++----
 drivers/block/drbd/drbd_nl.c     |    5 +--
 4 files changed, 94 insertions(+), 40 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index b230d91..7e7680e 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -353,11 +353,11 @@ static unsigned int rs_extent_to_bm_page(unsigned int rs_enr)
 
 static sector_t al_tr_number_to_on_disk_sector(struct drbd_conf *mdev)
 {
-	const unsigned int stripes = 1;
-	const unsigned int stripe_size_4kB = MD_32kB_SECT/MD_4kB_SECT;
+	const unsigned int stripes = mdev->ldev->md.al_stripes;
+	const unsigned int stripe_size_4kB = mdev->ldev->md.al_stripe_size_4k;
 
 	/* transaction number, modulo on-disk ring buffer wrap around */
-	unsigned int t = mdev->al_tr_number % (stripe_size_4kB * stripes);
+	unsigned int t = mdev->al_tr_number % (mdev->ldev->md.al_size_4k);
 
 	/* ... to aligned 4k on disk block */
 	t = ((t % stripes) * stripe_size_4kB) + t/stripes;
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 60c89e5..ee19ba2 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -755,6 +755,14 @@ struct drbd_md {
 
 	s32 al_offset;	/* signed relative sector offset to activity log */
 	s32 bm_offset;	/* signed relative sector offset to bitmap */
+
+	/* cached value of bdev->disk_conf->meta_dev_idx (see below) */
+	s32 meta_dev_idx;
+
+	/* see al_tr_number_to_on_disk_sector() */
+	u32 al_stripes;
+	u32 al_stripe_size_4k;
+	u32 al_size_4k; /* cached product of the above */
 };
 
 struct drbd_backing_dev {
@@ -1862,38 +1870,24 @@ static inline sector_t drbd_get_max_capacity(struct drbd_backing_dev *bdev)
 }
 
 /**
- * drbd_md_ss__() - Return the sector number of our meta data super block
- * @mdev:	DRBD device.
+ * drbd_md_ss() - Return the sector number of our meta data super block
  * @bdev:	Meta data block device.
  */
-static inline sector_t drbd_md_ss__(struct drbd_conf *mdev,
-				    struct drbd_backing_dev *bdev)
+static inline sector_t drbd_md_ss(struct drbd_backing_dev *bdev)
 {
-	int meta_dev_idx;
+	const int meta_dev_idx = bdev->md.meta_dev_idx;
 
-	rcu_read_lock();
-	meta_dev_idx = rcu_dereference(bdev->disk_conf)->meta_dev_idx;
-	rcu_read_unlock();
+	if (meta_dev_idx == DRBD_MD_INDEX_FLEX_EXT)
+		return 0;
 
-	switch (meta_dev_idx) {
-	default: /* external, some index; this is the old fixed size layout */
-		return MD_128MB_SECT * meta_dev_idx;
-	case DRBD_MD_INDEX_INTERNAL:
-		/* with drbd08, internal meta data is always "flexible" */
-	case DRBD_MD_INDEX_FLEX_INT:
-		if (!bdev->backing_bdev) {
-			if (__ratelimit(&drbd_ratelimit_state)) {
-				dev_err(DEV, "bdev->backing_bdev==NULL\n");
-				dump_stack();
-			}
-			return 0;
-		}
-		/* sizeof(struct md_on_disk_07) == 4k
-		 * position: last 4k aligned block of 4k size */
+	/* Since drbd08, internal meta data is always "flexible".
+	 * position: last 4k aligned block of 4k size */
+	if (meta_dev_idx == DRBD_MD_INDEX_INTERNAL ||
+	    meta_dev_idx == DRBD_MD_INDEX_FLEX_INT)
 		return (drbd_get_capacity(bdev->backing_bdev) & ~7ULL) - 8;
-	case DRBD_MD_INDEX_FLEX_EXT:
-		return 0;
-	}
+
+	/* external, some index; this is the old fixed size layout */
+	return MD_128MB_SECT * bdev->md.meta_dev_idx;
 }
 
 static inline void
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 6c4f0ff..b9bfb10 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2853,7 +2853,11 @@ struct meta_data_on_disk {
 	u32 bm_bytes_per_bit;  /* BM_BLOCK_SIZE */
 	u32 la_peer_max_bio_size;   /* last peer max_bio_size */
 
-	u8 reserved_u8[4096 - (7*8 + 8*4)];
+	/* see al_tr_number_to_on_disk_sector() */
+	u32 al_stripes;
+	u32 al_stripe_size_4k;
+
+	u8 reserved_u8[4096 - (7*8 + 10*4)];
 } __packed;
 
 /**
@@ -2901,7 +2905,10 @@ void drbd_md_sync(struct drbd_conf *mdev)
 	buffer->bm_offset = cpu_to_be32(mdev->ldev->md.bm_offset);
 	buffer->la_peer_max_bio_size = cpu_to_be32(mdev->peer_max_bio_size);
 
-	D_ASSERT(drbd_md_ss__(mdev, mdev->ldev) == mdev->ldev->md.md_offset);
+	buffer->al_stripes = cpu_to_be32(mdev->ldev->md.al_stripes);
+	buffer->al_stripe_size_4k = cpu_to_be32(mdev->ldev->md.al_stripe_size_4k);
+
+	D_ASSERT(drbd_md_ss(mdev->ldev) == mdev->ldev->md.md_offset);
 	sector = mdev->ldev->md.md_offset;
 
 	if (drbd_md_sync_page_io(mdev, mdev->ldev, sector, WRITE)) {
@@ -2919,13 +2926,60 @@ out:
 	put_ldev(mdev);
 }
 
+static int check_activity_log_stripe_size(struct drbd_conf *mdev,
+		struct meta_data_on_disk *on_disk,
+		struct drbd_md *in_core)
+{
+	u32 al_stripes = be32_to_cpu(on_disk->al_stripes);
+	u32 al_stripe_size_4k = be32_to_cpu(on_disk->al_stripe_size_4k);
+	u64 al_size_4k;
+
+	/* both not set: default to old fixed size activity log */
+	if (al_stripes == 0 && al_stripe_size_4k == 0) {
+		al_stripes = 1;
+		al_stripe_size_4k = MD_32kB_SECT/8;
+	}
+
+	/* some paranoia plausibility checks */
+
+	/* we need both values to be set */
+	if (al_stripes == 0 || al_stripe_size_4k == 0)
+		goto err;
+
+	al_size_4k = (u64)al_stripes * al_stripe_size_4k;
+
+	/* Upper limit of activity log area, to avoid potential overflow
+	 * problems in al_tr_number_to_on_disk_sector(). As right now, more
+	 * than 72 * 4k blocks total only increases the amount of history,
+	 * limiting this arbitrarily to 16 GB is not a real limitation ;-)  */
+	if (al_size_4k > (16 * 1024 * 1024/4))
+		goto err;
+
+	/* Lower limit: we need at least 8 transaction slots (32kB)
+	 * to not break existing setups */
+	if (al_size_4k < MD_32kB_SECT/8)
+		goto err;
+
+	in_core->al_stripe_size_4k = al_stripe_size_4k;
+	in_core->al_stripes = al_stripes;
+	in_core->al_size_4k = al_size_4k;
+
+	return 0;
+err:
+	dev_err(DEV, "invalid activity log striping: al_stripes=%u, al_stripe_size_4k=%u\n",
+			al_stripes, al_stripe_size_4k);
+	return -EINVAL;
+}
+
 /**
  * drbd_md_read() - Reads in the meta data super block
  * @mdev:	DRBD device.
  * @bdev:	Device from which the meta data should be read in.
  *
- * Return 0 (NO_ERROR) on success, and an enum drbd_ret_code in case
+ * Return NO_ERROR on success, and an enum drbd_ret_code in case
  * something goes wrong.
+ *
+ * Called exactly once during drbd_adm_attach()
  */
 int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 {
@@ -2940,6 +2994,10 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	if (!buffer)
 		goto out;
 
+	/* First, figure out where our meta data superblock is located. */
+	bdev->md.meta_dev_idx = bdev->disk_conf->meta_dev_idx;
+	bdev->md.md_offset = drbd_md_ss(bdev);
+
 	if (drbd_md_sync_page_io(mdev, bdev, bdev->md.md_offset, READ)) {
 		/* NOTE: can't do normal error processing here as this is
 		   called BEFORE disk is attached */
@@ -2957,40 +3015,43 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 		rv = ERR_MD_UNCLEAN;
 		goto err;
 	}
+
+	rv = ERR_MD_INVALID;
 	if (magic != DRBD_MD_MAGIC_08) {
 		if (magic == DRBD_MD_MAGIC_07)
 			dev_err(DEV, "Found old (0.7) meta data magic. Did you \"drbdadm create-md\"?\n");
 		else
 			dev_err(DEV, "Meta data magic not found. Did you \"drbdadm create-md\"?\n");
-		rv = ERR_MD_INVALID;
 		goto err;
 	}
+
+	if (check_activity_log_stripe_size(mdev, buffer, &bdev->md))
+		goto err;
+
 	if (be32_to_cpu(buffer->al_offset) != bdev->md.al_offset) {
 		dev_err(DEV, "unexpected al_offset: %d (expected %d)\n",
 		    be32_to_cpu(buffer->al_offset), bdev->md.al_offset);
-		rv = ERR_MD_INVALID;
 		goto err;
 	}
 	if (be32_to_cpu(buffer->bm_offset) != bdev->md.bm_offset) {
 		dev_err(DEV, "unexpected bm_offset: %d (expected %d)\n",
 		    be32_to_cpu(buffer->bm_offset), bdev->md.bm_offset);
-		rv = ERR_MD_INVALID;
 		goto err;
 	}
 	if (be32_to_cpu(buffer->md_size_sect) != bdev->md.md_size_sect) {
 		dev_err(DEV, "unexpected md_size: %u (expected %u)\n",
 		    be32_to_cpu(buffer->md_size_sect), bdev->md.md_size_sect);
-		rv = ERR_MD_INVALID;
 		goto err;
 	}
 
 	if (be32_to_cpu(buffer->bm_bytes_per_bit) != BM_BLOCK_SIZE) {
 		dev_err(DEV, "unexpected bm_bytes_per_bit: %u (expected %u)\n",
 		    be32_to_cpu(buffer->bm_bytes_per_bit), BM_BLOCK_SIZE);
-		rv = ERR_MD_INVALID;
 		goto err;
 	}
 
+	rv = NO_ERROR;
+
 	bdev->md.la_size_sect = be64_to_cpu(buffer->la_size);
 	for (i = UI_CURRENT; i < UI_SIZE; i++)
 		bdev->md.uuid[i] = be64_to_cpu(buffer->uuid[i]);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 581f680..104b7ce 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -727,24 +727,23 @@ static void drbd_md_set_sector_offsets(struct drbd_conf *mdev,
 	rcu_read_lock();
 	meta_dev_idx = rcu_dereference(bdev->disk_conf)->meta_dev_idx;
 
+	bdev->md.md_offset = drbd_md_ss(bdev);
+
 	switch (meta_dev_idx) {
 	default:
 		/* v07 style fixed size indexed meta data */
 		bdev->md.md_size_sect = MD_128MB_SECT;
-		bdev->md.md_offset = drbd_md_ss__(mdev, bdev);
 		bdev->md.al_offset = MD_4kB_SECT;
 		bdev->md.bm_offset = MD_4kB_SECT + al_size_sect;
 		break;
 	case DRBD_MD_INDEX_FLEX_EXT:
 		/* just occupy the full device; unit: sectors */
 		bdev->md.md_size_sect = drbd_get_capacity(bdev->md_bdev);
-		bdev->md.md_offset = 0;
 		bdev->md.al_offset = MD_4kB_SECT;
 		bdev->md.bm_offset = MD_4kB_SECT + al_size_sect;
 		break;
 	case DRBD_MD_INDEX_INTERNAL:
 	case DRBD_MD_INDEX_FLEX_INT:
-		bdev->md.md_offset = drbd_md_ss__(mdev, bdev);
 		/* al size is still fixed */
 		bdev->md.al_offset = -al_size_sect;
 		/* we need (slightly less than) ~ this much bitmap sectors: */
-- 
1.7.9.5

