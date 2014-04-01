Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaDABRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 21:17:25 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41243 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaDABRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 21:17:23 -0400
From: Conrad Meyer <cemeyer@uw.edu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, Conrad Meyer <cse.cem@gmail.com>
Subject: [PATCH v4] fs: FAT: Add support for DOS 1.x formatted volumes
Date: Mon, 31 Mar 2014 18:17:17 -0700
Message-Id: <1396315037-12725-1-git-send-email-cse.cem@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396279369-17855-1-git-send-email-cse.cem@gmail.com>
References: <1396279369-17855-1-git-send-email-cse.cem@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dos1xfloppy mount option to infer DOS 2.x BIOS Parameter Block
defaults from block device geometry for ancient floppies and floppy
images.

Validate that the entire BPB is zero like we expect, and that the floppy
has a DOS-style 8086 code bootstrapping header.

Fixes kernel.org bug #42617.

Values are inferred from media size and a table.[0] Media size is
assumed to be static for archaic FAT volumes. See also [1].

[0]: https://en.wikipedia.org/wiki/File_Allocation_Table#Exceptions
[1]: http://www.win.tue.nl/~aeb/linux/fs/fat/fat-1.html

Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
---
Changes since v3!

* No EOF on floppy_defaults array (use ARRAY_SIZE instead)
* Use correct format string/types for sector_t in fat_msg()
* Pull out massive if () zero boolean expression into a hopefully expressively
  named helper function, fat_is_bpb_zero()

Thanks for the feedback.
---
 fs/fat/fat.h   |   3 +-
 fs/fat/inode.c | 175 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 157 insertions(+), 21 deletions(-)

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
index 992e8cb..0f08ca4 100644
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
@@ -1326,21 +1368,49 @@ static unsigned long calc_fat_clusters(struct super_block *sb)
 	return sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
 }
 
+static bool fat_bpb_is_zero(struct fat_boot_sector *b)
+{
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
+
 /*
  * Read the super block of an MS-DOS FS.
  */
 int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		   void (*setup)(struct super_block *))
 {
+	static const char *notdos1x = "This doesn't look like a DOS 1.x volume";
 	struct inode *root_inode = NULL, *fat_inode = NULL;
+	struct fat_floppy_defaults *fdefaults = NULL;
 	struct inode *fsinfo_inode = NULL;
 	struct buffer_head *bh;
 	struct fat_boot_sector *b;
 	struct msdos_sb_info *sbi;
 	u16 logical_sector_size;
 	u32 total_sectors, total_clusters, fat_clusters, rootdir_sectors;
+	sector_t bd_sects;
 	int debug;
-	unsigned int media;
+	unsigned int media, i;
 	long error;
 	char buf[50];
 
@@ -1378,17 +1448,60 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	}
 
 	b = (struct fat_boot_sector *) bh->b_data;
-	if (!b->reserved) {
-		if (!silent)
-			fat_msg(sb, KERN_ERR, "bogus number of reserved sectors");
-		brelse(bh);
-		goto out_invalid;
-	}
-	if (!b->fats) {
-		if (!silent)
-			fat_msg(sb, KERN_ERR, "bogus number of FAT structure");
-		brelse(bh);
-		goto out_invalid;
+
+	bd_sects = part_nr_sects_read(sb->s_bdev->bd_part);
+	if (sbi->options.dos1xfloppy) {
+		/* 16-bit DOS 1.x reliably wrote bootstrap short-jmp code */
+		if (b->ignored[0] != 0xeb || b->ignored[2] != 0x90) {
+			fat_msg(sb, KERN_ERR, "%s; no bootstrapping code",
+				notdos1x);
+			brelse(bh);
+			goto out_invalid;
+		}
+
+		/*
+		 * If any value in this region is non-zero, it isn't archaic
+		 * DOS.
+		 */
+		if (!fat_bpb_is_zero(b)) {
+			fat_msg(sb, KERN_ERR, "%s; DOS 2.x BPB is non-zero",
+				notdos1x);
+			brelse(bh);
+			goto out_invalid;
+		}
+
+		for (i = 0; i < ARRAY_SIZE(floppy_defaults); i++) {
+			if (floppy_defaults[i].nr_sectors == bd_sects) {
+				fdefaults = &floppy_defaults[i];
+				break;
+			}
+		}
+
+		if (fdefaults == NULL) {
+			fat_msg(sb, KERN_WARNING,
+				"This looks like a DOS 1.x volume, but isn't a recognized floppy size (%llu sectors)",
+				(u64)bd_sects);
+			brelse(bh);
+			goto out_invalid;
+		}
+
+		fat_msg(sb, KERN_INFO,
+			"This looks like a DOS 1.x volume; assuming default BPB values");
+	} else {
+		if (!b->reserved) {
+			if (!silent)
+				fat_msg(sb, KERN_ERR,
+					"bogus number of reserved sectors");
+			brelse(bh);
+			goto out_invalid;
+		}
+		if (!b->fats) {
+			if (!silent)
+				fat_msg(sb, KERN_ERR,
+					"bogus number of FAT structure");
+			brelse(bh);
+			goto out_invalid;
+		}
 	}
 
 	/*
@@ -1397,6 +1510,8 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	 */
 
 	media = b->media;
+	if (sbi->options.dos1xfloppy)
+		media = fdefaults->media;
 	if (!fat_valid_media(media)) {
 		if (!silent)
 			fat_msg(sb, KERN_ERR, "invalid media value (0x%02x)",
@@ -1404,7 +1519,10 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		brelse(bh);
 		goto out_invalid;
 	}
-	logical_sector_size = get_unaligned_le16(&b->sector_size);
+	if (sbi->options.dos1xfloppy)
+		logical_sector_size = SECTOR_SIZE;
+	else
+		logical_sector_size = get_unaligned_le16(&b->sector_size);
 	if (!is_power_of_2(logical_sector_size)
 	    || (logical_sector_size < 512)
 	    || (logical_sector_size > 4096)) {
@@ -1414,7 +1532,10 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		brelse(bh);
 		goto out_invalid;
 	}
-	sbi->sec_per_clus = b->sec_per_clus;
+	if (sbi->options.dos1xfloppy)
+		sbi->sec_per_clus = fdefaults->sec_per_clus;
+	else
+		sbi->sec_per_clus = b->sec_per_clus;
 	if (!is_power_of_2(sbi->sec_per_clus)) {
 		if (!silent)
 			fat_msg(sb, KERN_ERR, "bogus sectors per cluster %u",
@@ -1450,10 +1571,18 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	mutex_init(&sbi->s_lock);
 	sbi->cluster_size = sb->s_blocksize * sbi->sec_per_clus;
 	sbi->cluster_bits = ffs(sbi->cluster_size) - 1;
-	sbi->fats = b->fats;
+	if (sbi->options.dos1xfloppy)
+		sbi->fats = 2;
+	else
+		sbi->fats = b->fats;
 	sbi->fat_bits = 0;		/* Don't know yet */
-	sbi->fat_start = le16_to_cpu(b->reserved);
-	sbi->fat_length = le16_to_cpu(b->fat_length);
+	if (sbi->options.dos1xfloppy) {
+		sbi->fat_start = 1;
+		sbi->fat_length = fdefaults->fat_length;
+	} else {
+		sbi->fat_start = le16_to_cpu(b->reserved);
+		sbi->fat_length = le16_to_cpu(b->fat_length);
+	}
 	sbi->root_cluster = 0;
 	sbi->free_clusters = -1;	/* Don't know yet */
 	sbi->free_clus_valid = 0;
@@ -1515,7 +1644,10 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	sbi->dir_per_block_bits = ffs(sbi->dir_per_block) - 1;
 
 	sbi->dir_start = sbi->fat_start + sbi->fats * sbi->fat_length;
-	sbi->dir_entries = get_unaligned_le16(&b->dir_entries);
+	if (sbi->options.dos1xfloppy)
+		sbi->dir_entries = fdefaults->dir_entries;
+	else
+		sbi->dir_entries = get_unaligned_le16(&b->dir_entries);
 	if (sbi->dir_entries & (sbi->dir_per_block - 1)) {
 		if (!silent)
 			fat_msg(sb, KERN_ERR, "bogus directory-entries per block"
@@ -1527,7 +1659,10 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	rootdir_sectors = sbi->dir_entries
 		* sizeof(struct msdos_dir_entry) / sb->s_blocksize;
 	sbi->data_start = sbi->dir_start + rootdir_sectors;
-	total_sectors = get_unaligned_le16(&b->sectors);
+	if (sbi->options.dos1xfloppy)
+		total_sectors = fdefaults->nr_sectors;
+	else
+		total_sectors = get_unaligned_le16(&b->sectors);
 	if (total_sectors == 0)
 		total_sectors = le32_to_cpu(b->total_sect);
 
-- 
1.9.0

