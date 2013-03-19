Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369Ab3CSRVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:21:45 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44514 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160Ab3CSRRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:03 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 02/18] drbd: cleanup ondisk meta data layout calculations and defines
Date: Tue, 19 Mar 2013 18:16:43 +0100
Message-Id: <1363713419-17803-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Add a comment about our meta data layout variants,
and rename a few defines (e.g. MD_RESERVED_SECT -> MD_128MB_SECT)
to make it clear that they are short hand for fixed constants,
and not arbitrarily to be redefined as one may see fit.

Properly pad struct meta_data_on_disk to 4kB,
and initialize to zero not only the first 512 Byte,
but all of it in drbd_md_sync().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |   28 ++++++++++---
 drivers/block/drbd/drbd_bitmap.c |   13 +++++-
 drivers/block/drbd/drbd_int.h    |   86 ++++++++++++++++++++++----------------
 drivers/block/drbd/drbd_main.c   |   11 +++--
 drivers/block/drbd/drbd_nl.c     |   42 ++++++++++++++-----
 5 files changed, 123 insertions(+), 57 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 92510f8..b230d91 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -209,7 +209,8 @@ int drbd_md_sync_page_io(struct drbd_conf *mdev, struct drbd_backing_dev *bdev,
 		     current->comm, current->pid, __func__,
 		     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
 
-	err = _drbd_md_sync_page_io(mdev, bdev, iop, sector, rw, MD_BLOCK_SIZE);
+	/* we do all our meta data IO in aligned 4k blocks. */
+	err = _drbd_md_sync_page_io(mdev, bdev, iop, sector, rw, 4096);
 	if (err) {
 		dev_err(DEV, "drbd_md_sync_page_io(,%llus,%s) failed with error %d\n",
 		    (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ", err);
@@ -350,6 +351,24 @@ static unsigned int rs_extent_to_bm_page(unsigned int rs_enr)
 		 (BM_EXT_SHIFT - BM_BLOCK_SHIFT));
 }
 
+static sector_t al_tr_number_to_on_disk_sector(struct drbd_conf *mdev)
+{
+	const unsigned int stripes = 1;
+	const unsigned int stripe_size_4kB = MD_32kB_SECT/MD_4kB_SECT;
+
+	/* transaction number, modulo on-disk ring buffer wrap around */
+	unsigned int t = mdev->al_tr_number % (stripe_size_4kB * stripes);
+
+	/* ... to aligned 4k on disk block */
+	t = ((t % stripes) * stripe_size_4kB) + t/stripes;
+
+	/* ... to 512 byte sector in activity log */
+	t *= 8;
+
+	/* ... plus offset to the on disk position */
+	return mdev->ldev->md.md_offset + mdev->ldev->md.al_offset + t;
+}
+
 static int
 _al_write_transaction(struct drbd_conf *mdev)
 {
@@ -432,13 +451,12 @@ _al_write_transaction(struct drbd_conf *mdev)
 	if (mdev->al_tr_cycle >= mdev->act_log->nr_elements)
 		mdev->al_tr_cycle = 0;
 
-	sector =  mdev->ldev->md.md_offset
-		+ mdev->ldev->md.al_offset
-		+ mdev->al_tr_pos * (MD_BLOCK_SIZE>>9);
+	sector = al_tr_number_to_on_disk_sector(mdev);
 
 	crc = crc32c(0, buffer, 4096);
 	buffer->crc32c = cpu_to_be32(crc);
 
+	/* normal execution path goes through all three branches */
 	if (drbd_bm_write_hinted(mdev))
 		err = -EIO;
 		/* drbd_chk_io_error done already */
@@ -446,8 +464,6 @@ _al_write_transaction(struct drbd_conf *mdev)
 		err = -EIO;
 		drbd_chk_io_error(mdev, 1, DRBD_META_IO_ERROR);
 	} else {
-		/* advance ringbuffer position and transaction counter */
-		mdev->al_tr_pos = (mdev->al_tr_pos + 1) % (MD_AL_SECTORS*512/MD_BLOCK_SIZE);
 		mdev->al_tr_number++;
 	}
 
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 8dc2950..64fbb83 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -612,6 +612,17 @@ static void bm_memset(struct drbd_bitmap *b, size_t offset, int c, size_t len)
 	}
 }
 
+/* For the layout, see comment above drbd_md_set_sector_offsets(). */
+static u64 drbd_md_on_disk_bits(struct drbd_backing_dev *ldev)
+{
+	u64 bitmap_sectors;
+	if (ldev->md.al_offset == 8)
+		bitmap_sectors = ldev->md.md_size_sect - ldev->md.bm_offset;
+	else
+		bitmap_sectors = ldev->md.al_offset - ldev->md.bm_offset;
+	return bitmap_sectors << (9 + 3);
+}
+
 /*
  * make sure the bitmap has enough room for the attached storage,
  * if necessary, resize.
@@ -668,7 +679,7 @@ int drbd_bm_resize(struct drbd_conf *mdev, sector_t capacity, int set_new_bits)
 	words = ALIGN(bits, 64) >> LN2_BPL;
 
 	if (get_ldev(mdev)) {
-		u64 bits_on_disk = ((u64)mdev->ldev->md.md_size_sect-MD_BM_OFFSET) << 12;
+		u64 bits_on_disk = drbd_md_on_disk_bits(mdev->ldev);
 		put_ldev(mdev);
 		if (bits > bits_on_disk) {
 			dev_info(DEV, "bits = %lu\n", bits);
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index db504d0..60c89e5 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -753,13 +753,8 @@ struct drbd_md {
 	u32 flags;
 	u32 md_size_sect;
 
-	s32 al_offset;	/* signed relative sector offset to al area */
+	s32 al_offset;	/* signed relative sector offset to activity log */
 	s32 bm_offset;	/* signed relative sector offset to bitmap */
-
-	/* u32 al_nr_extents;	   important for restoring the AL
-	 * is stored into  ldev->dc.al_extents, which in turn
-	 * gets applied to act_log->nr_elements
-	 */
 };
 
 struct drbd_backing_dev {
@@ -1009,7 +1004,6 @@ struct drbd_conf {
 	struct lru_cache *act_log;	/* activity log */
 	unsigned int al_tr_number;
 	int al_tr_cycle;
-	int al_tr_pos;   /* position of the next transaction in the journal */
 	wait_queue_head_t seq_wait;
 	atomic_t packet_seq;
 	unsigned int peer_seq;
@@ -1151,21 +1145,41 @@ extern int drbd_bmio_clear_n_write(struct drbd_conf *mdev);
 extern void drbd_ldev_destroy(struct drbd_conf *mdev);
 
 /* Meta data layout
-   We reserve a 128MB Block (4k aligned)
-   * either at the end of the backing device
-   * or on a separate meta data device. */
+ *
+ * We currently have two possible layouts.
+ * Offsets in (512 byte) sectors.
+ * external:
+ *   |----------- md_size_sect ------------------|
+ *   [ 4k superblock ][ activity log ][  Bitmap  ]
+ *   | al_offset == 8 |
+ *   | bm_offset = al_offset + X      |
+ *  ==> bitmap sectors = md_size_sect - bm_offset
+ *
+ *  Variants:
+ *     old, indexed fixed size meta data:
+ *
+ * internal:
+ *            |----------- md_size_sect ------------------|
+ * [data.....][  Bitmap  ][ activity log ][ 4k superblock ][padding*]
+ *                        | al_offset < 0 |
+ *            | bm_offset = al_offset - Y |
+ *  ==> bitmap sectors = Y = al_offset - bm_offset
+ *
+ *  [padding*] are zero or up to 7 unused 512 Byte sectors to the
+ *  end of the device, so that the [4k superblock] will be 4k aligned.
+ *
+ *  The activity log consists of 4k transaction blocks,
+ *  which are written in a ring-buffer, or striped ring-buffer like fashion,
+ *  which are writtensize used to be fixed 32kB,
+ *  but is about to become configurable.
+ */
 
-/* The following numbers are sectors */
-/* Allows up to about 3.8TB, so if you want more,
+/* Our old fixed size meta data layout
+ * allows up to about 3.8TB, so if you want more,
  * you need to use the "flexible" meta data format. */
-#define MD_RESERVED_SECT (128LU << 11)  /* 128 MB, unit sectors */
-#define MD_AL_OFFSET	8    /* 8 Sectors after start of meta area */
-#define MD_AL_SECTORS	64   /* = 32 kB on disk activity log ring buffer */
-#define MD_BM_OFFSET (MD_AL_OFFSET + MD_AL_SECTORS)
-
-/* we do all meta data IO in 4k blocks */
-#define MD_BLOCK_SHIFT	12
-#define MD_BLOCK_SIZE	(1<<MD_BLOCK_SHIFT)
+#define MD_128MB_SECT (128LLU << 11)  /* 128 MB, unit sectors */
+#define MD_4kB_SECT	 8
+#define MD_32kB_SECT	64
 
 /* One activity log extent represents 4M of storage */
 #define AL_EXTENT_SHIFT 22
@@ -1255,7 +1269,6 @@ struct bm_extent {
 
 /* in one sector of the bitmap, we have this many activity_log extents. */
 #define AL_EXT_PER_BM_SECT  (1 << (BM_EXT_SHIFT - AL_EXTENT_SHIFT))
-#define BM_WORDS_PER_AL_EXT (1 << (AL_EXTENT_SHIFT-BM_BLOCK_SHIFT-LN2_BPL))
 
 #define BM_BLOCKS_PER_BM_EXT_B (BM_EXT_SHIFT - BM_BLOCK_SHIFT)
 #define BM_BLOCKS_PER_BM_EXT_MASK  ((1<<BM_BLOCKS_PER_BM_EXT_B) - 1)
@@ -1275,16 +1288,18 @@ struct bm_extent {
  */
 
 #define DRBD_MAX_SECTORS_32 (0xffffffffLU)
-#define DRBD_MAX_SECTORS_BM \
-	  ((MD_RESERVED_SECT - MD_BM_OFFSET) * (1LL<<(BM_EXT_SHIFT-9)))
-#if DRBD_MAX_SECTORS_BM < DRBD_MAX_SECTORS_32
-#define DRBD_MAX_SECTORS      DRBD_MAX_SECTORS_BM
-#define DRBD_MAX_SECTORS_FLEX DRBD_MAX_SECTORS_BM
-#elif !defined(CONFIG_LBDAF) && BITS_PER_LONG == 32
+/* we have a certain meta data variant that has a fixed on-disk size of 128
+ * MiB, of which 4k are our "superblock", and 32k are the fixed size activity
+ * log, leaving this many sectors for the bitmap.
+ */
+
+#define DRBD_MAX_SECTORS_FIXED_BM \
+	  ((MD_128MB_SECT - MD_32kB_SECT - MD_4kB_SECT) * (1LL<<(BM_EXT_SHIFT-9)))
+#if !defined(CONFIG_LBDAF) && BITS_PER_LONG == 32
 #define DRBD_MAX_SECTORS      DRBD_MAX_SECTORS_32
 #define DRBD_MAX_SECTORS_FLEX DRBD_MAX_SECTORS_32
 #else
-#define DRBD_MAX_SECTORS      DRBD_MAX_SECTORS_BM
+#define DRBD_MAX_SECTORS      DRBD_MAX_SECTORS_FIXED_BM
 /* 16 TB in units of sectors */
 #if BITS_PER_LONG == 32
 /* adjust by one page worth of bitmap,
@@ -1792,10 +1807,10 @@ static inline sector_t drbd_md_last_sector(struct drbd_backing_dev *bdev)
 	switch (meta_dev_idx) {
 	case DRBD_MD_INDEX_INTERNAL:
 	case DRBD_MD_INDEX_FLEX_INT:
-		return bdev->md.md_offset + MD_AL_OFFSET - 1;
+		return bdev->md.md_offset + MD_4kB_SECT -1;
 	case DRBD_MD_INDEX_FLEX_EXT:
 	default:
-		return bdev->md.md_offset + bdev->md.md_size_sect;
+		return bdev->md.md_offset + bdev->md.md_size_sect -1;
 	}
 }
 
@@ -1861,13 +1876,11 @@ static inline sector_t drbd_md_ss__(struct drbd_conf *mdev,
 	rcu_read_unlock();
 
 	switch (meta_dev_idx) {
-	default: /* external, some index */
-		return MD_RESERVED_SECT * meta_dev_idx;
+	default: /* external, some index; this is the old fixed size layout */
+		return MD_128MB_SECT * meta_dev_idx;
 	case DRBD_MD_INDEX_INTERNAL:
 		/* with drbd08, internal meta data is always "flexible" */
 	case DRBD_MD_INDEX_FLEX_INT:
-		/* sizeof(struct md_on_disk_07) == 4k
-		 * position: last 4k aligned block of 4k size */
 		if (!bdev->backing_bdev) {
 			if (__ratelimit(&drbd_ratelimit_state)) {
 				dev_err(DEV, "bdev->backing_bdev==NULL\n");
@@ -1875,8 +1888,9 @@ static inline sector_t drbd_md_ss__(struct drbd_conf *mdev,
 			}
 			return 0;
 		}
-		return (drbd_get_capacity(bdev->backing_bdev) & ~7ULL)
-			- MD_AL_OFFSET;
+		/* sizeof(struct md_on_disk_07) == 4k
+		 * position: last 4k aligned block of 4k size */
+		return (drbd_get_capacity(bdev->backing_bdev) & ~7ULL) - 8;
 	case DRBD_MD_INDEX_FLEX_EXT:
 		return 0;
 	}
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 6224963..6c4f0ff 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2837,6 +2837,7 @@ void conn_md_sync(struct drbd_tconn *tconn)
 	rcu_read_unlock();
 }
 
+/* aligned 4kByte */
 struct meta_data_on_disk {
 	u64 la_size;           /* last agreed size. */
 	u64 uuid[UI_SIZE];   /* UUIDs. */
@@ -2846,13 +2847,13 @@ struct meta_data_on_disk {
 	u32 magic;
 	u32 md_size_sect;
 	u32 al_offset;         /* offset to this block */
-	u32 al_nr_extents;     /* important for restoring the AL */
+	u32 al_nr_extents;     /* important for restoring the AL (userspace) */
 	      /* `-- act_log->nr_elements <-- ldev->dc.al_extents */
 	u32 bm_offset;         /* offset to the bitmap, from here */
 	u32 bm_bytes_per_bit;  /* BM_BLOCK_SIZE */
 	u32 la_peer_max_bio_size;   /* last peer max_bio_size */
-	u32 reserved_u32[3];
 
+	u8 reserved_u8[4096 - (7*8 + 8*4)];
 } __packed;
 
 /**
@@ -2865,6 +2866,10 @@ void drbd_md_sync(struct drbd_conf *mdev)
 	sector_t sector;
 	int i;
 
+	/* Don't accidentally change the DRBD meta data layout. */
+	BUILD_BUG_ON(UI_SIZE != 4);
+	BUILD_BUG_ON(sizeof(struct meta_data_on_disk) != 4096);
+
 	del_timer(&mdev->md_sync_timer);
 	/* timer may be rearmed by drbd_md_mark_dirty() now. */
 	if (!test_and_clear_bit(MD_DIRTY, &mdev->flags))
@@ -2879,7 +2884,7 @@ void drbd_md_sync(struct drbd_conf *mdev)
 	if (!buffer)
 		goto out;
 
-	memset(buffer, 0, 512);
+	memset(buffer, 0, sizeof(*buffer));
 
 	buffer->la_size = cpu_to_be64(drbd_get_capacity(mdev->this_bdev));
 	for (i = UI_CURRENT; i < UI_SIZE; i++)
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 2af26fc..581f680 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -696,12 +696,32 @@ out:
 	return 0;
 }
 
-/* initializes the md.*_offset members, so we are able to find
- * the on disk meta data */
+/* Initializes the md.*_offset members, so we are able to find
+ * the on disk meta data.
+ *
+ * We currently have two possible layouts:
+ * external:
+ *   |----------- md_size_sect ------------------|
+ *   [ 4k superblock ][ activity log ][  Bitmap  ]
+ *   | al_offset == 8 |
+ *   | bm_offset = al_offset + X      |
+ *  ==> bitmap sectors = md_size_sect - bm_offset
+ *
+ * internal:
+ *            |----------- md_size_sect ------------------|
+ * [data.....][  Bitmap  ][ activity log ][ 4k superblock ]
+ *                        | al_offset < 0 |
+ *            | bm_offset = al_offset - Y |
+ *  ==> bitmap sectors = Y = al_offset - bm_offset
+ *
+ *  Activity log size used to be fixed 32kB,
+ *  but is about to become configurable.
+ */
 static void drbd_md_set_sector_offsets(struct drbd_conf *mdev,
 				       struct drbd_backing_dev *bdev)
 {
 	sector_t md_size_sect = 0;
+	unsigned int al_size_sect = MD_32kB_SECT;
 	int meta_dev_idx;
 
 	rcu_read_lock();
@@ -710,23 +730,23 @@ static void drbd_md_set_sector_offsets(struct drbd_conf *mdev,
 	switch (meta_dev_idx) {
 	default:
 		/* v07 style fixed size indexed meta data */
-		bdev->md.md_size_sect = MD_RESERVED_SECT;
+		bdev->md.md_size_sect = MD_128MB_SECT;
 		bdev->md.md_offset = drbd_md_ss__(mdev, bdev);
-		bdev->md.al_offset = MD_AL_OFFSET;
-		bdev->md.bm_offset = MD_BM_OFFSET;
+		bdev->md.al_offset = MD_4kB_SECT;
+		bdev->md.bm_offset = MD_4kB_SECT + al_size_sect;
 		break;
 	case DRBD_MD_INDEX_FLEX_EXT:
 		/* just occupy the full device; unit: sectors */
 		bdev->md.md_size_sect = drbd_get_capacity(bdev->md_bdev);
 		bdev->md.md_offset = 0;
-		bdev->md.al_offset = MD_AL_OFFSET;
-		bdev->md.bm_offset = MD_BM_OFFSET;
+		bdev->md.al_offset = MD_4kB_SECT;
+		bdev->md.bm_offset = MD_4kB_SECT + al_size_sect;
 		break;
 	case DRBD_MD_INDEX_INTERNAL:
 	case DRBD_MD_INDEX_FLEX_INT:
 		bdev->md.md_offset = drbd_md_ss__(mdev, bdev);
 		/* al size is still fixed */
-		bdev->md.al_offset = -MD_AL_SECTORS;
+		bdev->md.al_offset = -al_size_sect;
 		/* we need (slightly less than) ~ this much bitmap sectors: */
 		md_size_sect = drbd_get_capacity(bdev->backing_bdev);
 		md_size_sect = ALIGN(md_size_sect, BM_SECT_PER_EXT);
@@ -735,11 +755,11 @@ static void drbd_md_set_sector_offsets(struct drbd_conf *mdev,
 
 		/* plus the "drbd meta data super block",
 		 * and the activity log; */
-		md_size_sect += MD_BM_OFFSET;
+		md_size_sect += MD_4kB_SECT + al_size_sect;
 
 		bdev->md.md_size_sect = md_size_sect;
 		/* bitmap offset is adjusted by 'super' block size */
-		bdev->md.bm_offset   = -md_size_sect + MD_AL_OFFSET;
+		bdev->md.bm_offset   = -md_size_sect + MD_4kB_SECT;
 		break;
 	}
 	rcu_read_unlock();
@@ -1416,7 +1436,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		min_md_device_sectors = (2<<10);
 	} else {
 		max_possible_sectors = DRBD_MAX_SECTORS;
-		min_md_device_sectors = MD_RESERVED_SECT * (new_disk_conf->meta_dev_idx + 1);
+		min_md_device_sectors = MD_128MB_SECT * (new_disk_conf->meta_dev_idx + 1);
 	}
 
 	if (drbd_get_capacity(nbc->md_bdev) < min_md_device_sectors) {
-- 
1.7.9.5

