Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaDMOKI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 10:10:08 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39337 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaDMOKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 10:10:05 -0400
From: Conrad Meyer <cse.cem@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, Conrad Meyer <cse.cem@gmail.com>
Subject: [PATCH v5] fs: FAT: Add support for DOS 1.x formatted volumes
Date: Sun, 13 Apr 2014 07:10:00 -0700
Message-Id: <1397398200-6510-1-git-send-email-cse.cem@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dos1xfloppy mount option to infer DOS 2.x BIOS Parameter Block
defaults from block device geometry for ancient floppies and floppy
images, as a fall-back from the default BPB parsing logic.

Validate that the entire BPB is zero like we expect, and that the floppy
has a DOS-style 8086 code bootstrapping header.

Fixes kernel.org bug #42617.

Values are inferred from media size and a table.[0] Media size is
assumed to be static for archaic FAT volumes. See also [1].

[0]: https://en.wikipedia.org/wiki/File_Allocation_Table#Exceptions
[1]: http://www.win.tue.nl/~aeb/linux/fs/fat/fat-1.html

Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
---
Changes since v4:
  * Read FAT FS block device size with i_size_read()
  * In silent (probing) mode, don't message
  * Use dos1xfloppy as a gate to allow trying static BPB values (don't require
    floppy to be archaic with this option)
  * Split out BPB-parsing functionality of fat_fill_super() into two helpers,
    fat_read_bpb() and fat_read_static_bpb()

Thanks for your patience. I apologize for it taking so many revisions to get it
right :).
---
 fs/fat/fat.h   |   3 +-
 fs/fat/inode.c | 353 ++++++++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 266 insertions(+), 90 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 7270bdb..13b7202 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -52,7 +52,8 @@ struct fat_mount_options {
 		 usefree:1,	   /* Use free_clusters for FAT32 */
 		 tz_set:1,	   /* Filesystem timestamps' offset set */
 		 rodir:1,	   /* allow ATTR_RO for directory */
-		 discard:1;	   /* Issue discard requests on deletions */
+		 discard:1,	   /* Issue discard requests on deletions */
+		 dos1xfloppy:1;	   /* Assume default BPB for DOS 1.x floppies */
 };
 
 #define FAT_HASH_BITS	8
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 992e8cb..85ea562 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -35,9 +35,47 @@
 #define CONFIG_FAT_DEFAULT_IOCHARSET	""
 #endif
 
+#define KB_IN_SECTORS 2
+
 static int fat_default_codepage = CONFIG_FAT_DEFAULT_CODEPAGE;
 static char fat_default_iocharset[] = CONFIG_FAT_DEFAULT_IOCHARSET;
 
+static struct fat_floppy_defaults {
+	unsigned nr_sectors;
+	unsigned sec_per_clus;
+	unsigned dir_entries;
+	unsigned media;
+	unsigned fat_length;
+} floppy_defaults[] = {
+{
+	.nr_sectors = 160 * KB_IN_SECTORS,
+	.sec_per_clus = 1,
+	.dir_entries = 64,
+	.media = 0xFE,
+	.fat_length = 1,
+},
+{
+	.nr_sectors = 180 * KB_IN_SECTORS,
+	.sec_per_clus = 1,
+	.dir_entries = 64,
+	.media = 0xFC,
+	.fat_length = 2,
+},
+{
+	.nr_sectors = 320 * KB_IN_SECTORS,
+	.sec_per_clus = 2,
+	.dir_entries = 112,
+	.media = 0xFF,
+	.fat_length = 1,
+},
+{
+	.nr_sectors = 360 * KB_IN_SECTORS,
+	.sec_per_clus = 2,
+	.dir_entries = 112,
+	.media = 0xFD,
+	.fat_length = 2,
+},
+};
 
 static int fat_add_cluster(struct inode *inode)
 {
@@ -945,7 +983,7 @@ enum {
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
 	Opt_obsolete, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
 	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_nfs, Opt_time_offset,
-	Opt_nfs_stale_rw, Opt_nfs_nostale_ro, Opt_err,
+	Opt_nfs_stale_rw, Opt_nfs_nostale_ro, Opt_err, Opt_dos1xfloppy,
 };
 
 static const match_table_t fat_tokens = {
@@ -978,6 +1016,7 @@ static const match_table_t fat_tokens = {
 	{Opt_nfs_stale_rw, "nfs"},
 	{Opt_nfs_stale_rw, "nfs=stale_rw"},
 	{Opt_nfs_nostale_ro, "nfs=nostale_ro"},
+	{Opt_dos1xfloppy, "dos1xfloppy"},
 	{Opt_obsolete, "conv=binary"},
 	{Opt_obsolete, "conv=text"},
 	{Opt_obsolete, "conv=auto"},
@@ -1180,6 +1219,9 @@ static int parse_options(struct super_block *sb, char *options, int is_vfat,
 		case Opt_nfs_nostale_ro:
 			opts->nfs = FAT_NFS_NOSTALE_RO;
 			break;
+		case Opt_dos1xfloppy:
+			opts->dos1xfloppy = 1;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
@@ -1326,69 +1368,50 @@ static unsigned long calc_fat_clusters(struct super_block *sb)
 	return sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
 }
 
-/*
- * Read the super block of an MS-DOS FS.
- */
-int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
-		   void (*setup)(struct super_block *))
+static bool fat_bpb_is_zero(struct fat_boot_sector *b)
 {
-	struct inode *root_inode = NULL, *fat_inode = NULL;
-	struct inode *fsinfo_inode = NULL;
-	struct buffer_head *bh;
-	struct fat_boot_sector *b;
-	struct msdos_sb_info *sbi;
-	u16 logical_sector_size;
-	u32 total_sectors, total_clusters, fat_clusters, rootdir_sectors;
-	int debug;
-	unsigned int media;
-	long error;
-	char buf[50];
-
-	/*
-	 * GFP_KERNEL is ok here, because while we do hold the
-	 * supeblock lock, memory pressure can't call back into
-	 * the filesystem, since we're only just about to mount
-	 * it and have no inodes etc active!
-	 */
-	sbi = kzalloc(sizeof(struct msdos_sb_info), GFP_KERNEL);
-	if (!sbi)
-		return -ENOMEM;
-	sb->s_fs_info = sbi;
-
-	sb->s_flags |= MS_NODIRATIME;
-	sb->s_magic = MSDOS_SUPER_MAGIC;
-	sb->s_op = &fat_sops;
-	sb->s_export_op = &fat_export_ops;
-	mutex_init(&sbi->nfs_build_inode_lock);
-	ratelimit_state_init(&sbi->ratelimit, DEFAULT_RATELIMIT_INTERVAL,
-			     DEFAULT_RATELIMIT_BURST);
-
-	error = parse_options(sb, data, isvfat, silent, &debug, &sbi->options);
-	if (error)
-		goto out_fail;
-
-	setup(sb); /* flavour-specific stuff that needs options */
+	if (get_unaligned_le16(&b->sector_size))
+		return false;
+	if (b->sec_per_clus)
+		return false;
+	if (b->reserved)
+		return false;
+	if (b->fats)
+		return false;
+	if (get_unaligned_le16(&b->dir_entries))
+		return false;
+	if (get_unaligned_le16(&b->sectors))
+		return false;
+	if (b->media)
+		return false;
+	if (b->fat_length)
+		return false;
+	if (b->secs_track)
+		return false;
+	if (b->heads)
+		return false;
+	return true;
+}
 
-	error = -EIO;
-	sb_min_blocksize(sb, 512);
-	bh = sb_bread(sb, 0);
-	if (bh == NULL) {
-		fat_msg(sb, KERN_ERR, "unable to read boot sector");
-		goto out_fail;
-	}
+static int fat_read_bpb(struct super_block *sb, struct fat_boot_sector *b,
+	int silent, struct buffer_head **bh)
+{
+	u32 total_sectors, total_clusters, fat_clusters, rootdir_sectors;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	u16 logical_sector_size;
+	int error = -EINVAL;
+	unsigned media;
 
-	b = (struct fat_boot_sector *) bh->b_data;
 	if (!b->reserved) {
 		if (!silent)
-			fat_msg(sb, KERN_ERR, "bogus number of reserved sectors");
-		brelse(bh);
-		goto out_invalid;
+			fat_msg(sb, KERN_ERR,
+				"bogus number of reserved sectors");
+		goto out;
 	}
 	if (!b->fats) {
 		if (!silent)
 			fat_msg(sb, KERN_ERR, "bogus number of FAT structure");
-		brelse(bh);
-		goto out_invalid;
+		goto out;
 	}
 
 	/*
@@ -1401,9 +1424,9 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		if (!silent)
 			fat_msg(sb, KERN_ERR, "invalid media value (0x%02x)",
 			       media);
-		brelse(bh);
-		goto out_invalid;
+		goto out;
 	}
+
 	logical_sector_size = get_unaligned_le16(&b->sector_size);
 	if (!is_power_of_2(logical_sector_size)
 	    || (logical_sector_size < 512)
@@ -1411,54 +1434,49 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		if (!silent)
 			fat_msg(sb, KERN_ERR, "bogus logical sector size %u",
 			       logical_sector_size);
-		brelse(bh);
-		goto out_invalid;
+		goto out;
 	}
+
 	sbi->sec_per_clus = b->sec_per_clus;
 	if (!is_power_of_2(sbi->sec_per_clus)) {
 		if (!silent)
 			fat_msg(sb, KERN_ERR, "bogus sectors per cluster %u",
 			       sbi->sec_per_clus);
-		brelse(bh);
-		goto out_invalid;
+		goto out;
 	}
 
 	if (logical_sector_size < sb->s_blocksize) {
+		error = -EIO;
 		fat_msg(sb, KERN_ERR, "logical sector size too small for device"
 		       " (logical sector size = %u)", logical_sector_size);
-		brelse(bh);
-		goto out_fail;
+		goto out;
 	}
+
 	if (logical_sector_size > sb->s_blocksize) {
-		brelse(bh);
+		brelse(*bh);
 
 		if (!sb_set_blocksize(sb, logical_sector_size)) {
+			error = -EIO;
 			fat_msg(sb, KERN_ERR, "unable to set blocksize %u",
 			       logical_sector_size);
-			goto out_fail;
+			goto out;
 		}
-		bh = sb_bread(sb, 0);
-		if (bh == NULL) {
+		*bh = sb_bread(sb, 0);
+		if (*bh == NULL) {
+			error = -EIO;
 			fat_msg(sb, KERN_ERR, "unable to read boot sector"
 			       " (logical sector size = %lu)",
 			       sb->s_blocksize);
-			goto out_fail;
+			goto out;
 		}
-		b = (struct fat_boot_sector *) bh->b_data;
+		b = (struct fat_boot_sector *) (*bh)->b_data;
 	}
 
-	mutex_init(&sbi->s_lock);
 	sbi->cluster_size = sb->s_blocksize * sbi->sec_per_clus;
 	sbi->cluster_bits = ffs(sbi->cluster_size) - 1;
 	sbi->fats = b->fats;
-	sbi->fat_bits = 0;		/* Don't know yet */
 	sbi->fat_start = le16_to_cpu(b->reserved);
 	sbi->fat_length = le16_to_cpu(b->fat_length);
-	sbi->root_cluster = 0;
-	sbi->free_clusters = -1;	/* Don't know yet */
-	sbi->free_clus_valid = 0;
-	sbi->prev_free = FAT_START_ENT;
-	sb->s_maxbytes = 0xffffffff;
 
 	if (!sbi->fat_length && b->fat32.length) {
 		struct fat_boot_fsinfo *fsinfo;
@@ -1476,10 +1494,10 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 
 		fsinfo_bh = sb_bread(sb, sbi->fsinfo_sector);
 		if (fsinfo_bh == NULL) {
+			error = -EIO;
 			fat_msg(sb, KERN_ERR, "bread failed, FSINFO block"
 			       " (sector = %lu)", sbi->fsinfo_sector);
-			brelse(bh);
-			goto out_fail;
+			goto out;
 		}
 
 		fsinfo = (struct fat_boot_fsinfo *)fsinfo_bh->b_data;
@@ -1513,21 +1531,21 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 
 	sbi->dir_per_block = sb->s_blocksize / sizeof(struct msdos_dir_entry);
 	sbi->dir_per_block_bits = ffs(sbi->dir_per_block) - 1;
-
 	sbi->dir_start = sbi->fat_start + sbi->fats * sbi->fat_length;
 	sbi->dir_entries = get_unaligned_le16(&b->dir_entries);
+
 	if (sbi->dir_entries & (sbi->dir_per_block - 1)) {
 		if (!silent)
 			fat_msg(sb, KERN_ERR, "bogus directory-entries per block"
 			       " (%u)", sbi->dir_entries);
-		brelse(bh);
-		goto out_invalid;
+		goto out;
 	}
 
 	rootdir_sectors = sbi->dir_entries
 		* sizeof(struct msdos_dir_entry) / sb->s_blocksize;
 	sbi->data_start = sbi->dir_start + rootdir_sectors;
 	total_sectors = get_unaligned_le16(&b->sectors);
+
 	if (total_sectors == 0)
 		total_sectors = le32_to_cpu(b->total_sect);
 
@@ -1549,21 +1567,180 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		if (!silent)
 			fat_msg(sb, KERN_ERR, "count of clusters too big (%u)",
 			       total_clusters);
-		brelse(bh);
-		goto out_invalid;
+		goto out;
 	}
 
 	sbi->max_cluster = total_clusters + FAT_START_ENT;
 	/* check the free_clusters, it's not necessarily correct */
 	if (sbi->free_clusters != -1 && sbi->free_clusters > total_clusters)
 		sbi->free_clusters = -1;
+	error = 0;
+
+out:
+	return error;
+}
+
+static int fat_read_static_bpb(struct super_block *sb,
+	struct fat_boot_sector *b, int silent)
+{
+	static const char *notdos1x = "This doesn't look like a DOS 1.x volume";
+	u32 total_sectors, total_clusters, fat_clusters, rootdir_sectors;
+	struct fat_floppy_defaults *fdefaults = NULL;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int error = -EINVAL;
+	sector_t bd_sects;
+	unsigned i;
+
+	bd_sects = i_size_read(sb->s_bdev->bd_inode) / SECTOR_SIZE;
+
+	/* 16-bit DOS 1.x reliably wrote bootstrap short-jmp code */
+	if (b->ignored[0] != 0xeb || b->ignored[2] != 0x90) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR,
+				"%s; no bootstrapping code", notdos1x);
+		goto out;
+	}
+
+	/*
+	 * If any value in this region is non-zero, it isn't archaic
+	 * DOS.
+	 */
+	if (!fat_bpb_is_zero(b)) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR,
+				"%s; DOS 2.x BPB is non-zero", notdos1x);
+		goto out;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(floppy_defaults); i++) {
+		if (floppy_defaults[i].nr_sectors == bd_sects) {
+			fdefaults = &floppy_defaults[i];
+			break;
+		}
+	}
+
+	if (fdefaults == NULL) {
+		if (!silent)
+			fat_msg(sb, KERN_WARNING,
+				"This looks like a DOS 1.x volume, but isn't a recognized floppy size (%llu sectors)",
+				(u64)bd_sects);
+		goto out;
+	}
+
+	fat_msg(sb, KERN_INFO,
+		"This looks like a DOS 1.x volume; assuming default BPB values");
+
+	sbi->sec_per_clus = fdefaults->sec_per_clus;
+	sbi->cluster_size = sb->s_blocksize * sbi->sec_per_clus;
+	sbi->cluster_bits = ffs(sbi->cluster_size) - 1;
+	sbi->fats = 2;
+	sbi->fat_start = 1;
+	sbi->fat_length = fdefaults->fat_length;
+
+	sbi->dir_per_block = sb->s_blocksize / sizeof(struct msdos_dir_entry);
+	sbi->dir_per_block_bits = ffs(sbi->dir_per_block) - 1;
+	sbi->dir_start = sbi->fat_start + sbi->fats * sbi->fat_length;
+	sbi->dir_entries = fdefaults->dir_entries;
+
+	rootdir_sectors = sbi->dir_entries
+		* sizeof(struct msdos_dir_entry) / sb->s_blocksize;
+	sbi->data_start = sbi->dir_start + rootdir_sectors;
+	total_sectors = fdefaults->nr_sectors;
+	total_clusters = (total_sectors - sbi->data_start) / sbi->sec_per_clus;
+	sbi->fat_bits = (total_clusters > MAX_FAT12) ? 16 : 12;
+
+	/* some OSes set FAT_STATE_DIRTY and clean it on unmount. */
+	sbi->dirty = b->fat16.state & FAT_STATE_DIRTY;
+
+	/* check that FAT table does not overflow */
+	fat_clusters = calc_fat_clusters(sb);
+	total_clusters = min(total_clusters, fat_clusters - FAT_START_ENT);
+	if (total_clusters > MAX_FAT(sb)) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR, "count of clusters too big (%u)",
+			       total_clusters);
+		goto out;
+	}
+
+	sbi->max_cluster = total_clusters + FAT_START_ENT;
+	/* check the free_clusters, it's not necessarily correct */
+	if (sbi->free_clusters != -1 && sbi->free_clusters > total_clusters)
+		sbi->free_clusters = -1;
+	error = 0;
+
+out:
+	return error;
+}
+
+/*
+ * Read the super block of an MS-DOS FS.
+ */
+int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
+		   void (*setup)(struct super_block *))
+{
+	struct inode *root_inode = NULL, *fat_inode = NULL;
+	struct inode *fsinfo_inode = NULL;
+	struct buffer_head *bh;
+	struct fat_boot_sector *b;
+	struct msdos_sb_info *sbi;
+	int debug;
+	long error;
+	char buf[50];
+
+	/*
+	 * GFP_KERNEL is ok here, because while we do hold the
+	 * supeblock lock, memory pressure can't call back into
+	 * the filesystem, since we're only just about to mount
+	 * it and have no inodes etc active!
+	 */
+	sbi = kzalloc(sizeof(struct msdos_sb_info), GFP_KERNEL);
+	if (!sbi)
+		return -ENOMEM;
+	sb->s_fs_info = sbi;
+
+	sb->s_flags |= MS_NODIRATIME;
+	sb->s_magic = MSDOS_SUPER_MAGIC;
+	sb->s_op = &fat_sops;
+	sb->s_export_op = &fat_export_ops;
+	mutex_init(&sbi->nfs_build_inode_lock);
+	ratelimit_state_init(&sbi->ratelimit, DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST);
+
+	error = parse_options(sb, data, isvfat, silent, &debug, &sbi->options);
+	if (error)
+		goto out_fail;
+
+	setup(sb); /* flavour-specific stuff that needs options */
+
+	error = -EIO;
+	sb_min_blocksize(sb, 512);
+	bh = sb_bread(sb, 0);
+	if (bh == NULL) {
+		fat_msg(sb, KERN_ERR, "unable to read boot sector");
+		goto out_fail;
+	}
+
+	mutex_init(&sbi->s_lock);
+	sbi->fat_bits = 0;		/* Don't know yet */
+	sbi->root_cluster = 0;
+	sbi->free_clusters = -1;	/* Don't know yet */
+	sbi->free_clus_valid = 0;
+	sbi->prev_free = FAT_START_ENT;
+	sb->s_maxbytes = 0xffffffff;
+
+	b = (struct fat_boot_sector *) bh->b_data;
+	error = fat_read_bpb(sb, b, silent, &bh);
+	if (error == -EINVAL && sbi->options.dos1xfloppy)
+		error = fat_read_static_bpb(sb, b, silent);
+	brelse(bh);
+	if (error)
+		goto out_fail;
+
 	/* check the prev_free, it's not necessarily correct */
 	sbi->prev_free %= sbi->max_cluster;
 	if (sbi->prev_free < FAT_START_ENT)
 		sbi->prev_free = FAT_START_ENT;
 
-	brelse(bh);
-
 	/* set up enough so that it can read an inode */
 	fat_hash_init(sb);
 	dir_hash_init(sb);
@@ -1639,12 +1816,10 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	fat_set_state(sb, 1, 0);
 	return 0;
 
-out_invalid:
-	error = -EINVAL;
-	if (!silent)
+out_fail:
+	if (error == -EINVAL && !silent)
 		fat_msg(sb, KERN_INFO, "Can't find a valid FAT filesystem");
 
-out_fail:
 	if (fsinfo_inode)
 		iput(fsinfo_inode);
 	if (fat_inode)
-- 
1.9.0

