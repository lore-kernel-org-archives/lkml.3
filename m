Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaC2TKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 15:10:42 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46672 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaC2TKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 15:10:41 -0400
From: Conrad Meyer <cemeyer@uw.edu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, Mark <markk@clara.co.uk>,
        Conrad Meyer <cse.cem@gmail.com>
Subject: [PATCH v2] fs: FAT: Add support for DOS 1.x formatted volumes
Date: Sat, 29 Mar 2014 12:10:35 -0700
Message-Id: <1396120235-27844-1-git-send-email-cse.cem@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When possible, infer DOS 2.x BIOS Parameter Block from block device
geometry (for floppies and floppy images). Update in-memory only. We
only perform this update when the entire BPB region is zeroed, like
produced by DOS 1.x-era FORMAT (and other OEM variations on DOS).

Fixes kernel.org bug #42617.

BPB default values are inferred from media size and a table.[0] Media
size is assumed to be static for archaic FAT volumes. See also [1].

[0]: https://en.wikipedia.org/wiki/File_Allocation_Table#Exceptions
[1]: http://www.win.tue.nl/~aeb/linux/fs/fat/fat-1.html

Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
---
Diff from v3.14-rc8.

Changes since v1:
  * Check for FAT bootstrap prefix (EB xx 90) to help avoid conflicting with
    other filesystems
  * Move default from a switch to a static table

Thanks!
---
 fs/fat/inode.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 854b578..c31fbdc 100644
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
+{ 0 } };
 
 static int fat_add_cluster(struct inode *inode)
 {
@@ -1246,6 +1284,58 @@ static unsigned long calc_fat_clusters(struct super_block *sb)
 }
 
 /*
+ * If this FAT filesystem is archaic (lacking a BIOS Parameter Block, ca. DOS
+ * 1.x), fix it up in-place by creating a DOS 2.x BIOS Parameter Block from
+ * defaults for the media size.
+ */
+static void fat_update_archaic_boot_sector(struct super_block *sb,
+	struct fat_boot_sector *b)
+{
+	struct fat_floppy_defaults *di;
+	sector_t bd_sects;
+
+	/* 16-bit DOS 1.x reliably wrote bootstrap short-jmp code */
+	if (b->ignored[0] != 0xeb || b->ignored[2] != 0x90)
+		return;
+
+	/*
+	 * If any value in this region is non-zero, don't assume it is archaic
+	 * DOS.
+	 */
+	if (get_unaligned_le16(&b->sector_size) != 0 || b->sec_per_clus != 0 ||
+		b->reserved != 0 || b->fats != 0 ||
+		get_unaligned_le16(&b->dir_entries) != 0 ||
+		get_unaligned_le16(&b->sectors) != 0 || b->media != 0 ||
+		b->fat_length != 0 || b->secs_track != 0 || b->heads != 0 ||
+		b->secs_track != 0 || b->heads != 0)
+		return;
+
+	bd_sects = part_nr_sects_read(sb->s_bdev->bd_part);
+	for (di = floppy_defaults; di->nr_sectors; di++) {
+		if (di->nr_sectors == bd_sects)
+			break;
+	}
+	if (di->nr_sectors == 0) {
+		fat_msg(sb, KERN_WARNING,
+			"DOS volume lacks BPB and isn't a recognized floppy size (%ld sectors)",
+			(long)bd_sects);
+		return;
+	}
+
+	fat_msg(sb, KERN_INFO,
+		"Volume lacks BPB but looks like archaic DOS; assuming default BPB values");
+
+	b->sec_per_clus = di->sec_per_clus;
+	put_unaligned_le16(di->dir_entries, &b->dir_entries);
+	b->media = di->media;
+	b->fat_length = cpu_to_le16(di->fat_length);
+	put_unaligned_le16(SECTOR_SIZE, &b->sector_size);
+	b->reserved = cpu_to_le16(1);
+	b->fats = 2;
+	put_unaligned_le16(bd_sects, &b->sectors);
+}
+
+/*
  * Read the super block of an MS-DOS FS.
  */
 int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
@@ -1297,6 +1387,8 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	}
 
 	b = (struct fat_boot_sector *) bh->b_data;
+	fat_update_archaic_boot_sector(sb, b);
+
 	if (!b->reserved) {
 		if (!silent)
 			fat_msg(sb, KERN_ERR, "bogus number of reserved sectors");
@@ -1364,6 +1456,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 			goto out_fail;
 		}
 		b = (struct fat_boot_sector *) bh->b_data;
+		fat_update_archaic_boot_sector(sb, b);
 	}
 
 	mutex_init(&sbi->s_lock);
-- 
1.9.0

