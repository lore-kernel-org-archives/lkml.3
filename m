Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaC1WVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 18:21:43 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:32793 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaC1WVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 18:21:42 -0400
From: Conrad Meyer <cemeyer@uw.edu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, Mark <markk@clara.co.uk>,
        Conrad Meyer <cse.cem@gmail.com>
Subject: [PATCH] fs: FAT: Add support for DOS 1.x formatted volumes
Date: Fri, 28 Mar 2014 15:21:30 -0700
Message-Id: <1396045290-9795-1-git-send-email-cse.cem@gmail.com>
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
Diff is from Linus' v3.14-rc8.

I am a kernel newbie, apologies in advance for newbie mistakes. Let me know
what is wrong and I will fix it and learn.

Thanks!
---
 fs/fat/inode.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 854b578..f3686d6 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -35,6 +35,8 @@
 #define CONFIG_FAT_DEFAULT_IOCHARSET	""
 #endif
 
+#define KB_IN_SECTORS 2
+
 static int fat_default_codepage = CONFIG_FAT_DEFAULT_CODEPAGE;
 static char fat_default_iocharset[] = CONFIG_FAT_DEFAULT_IOCHARSET;
 
@@ -1246,6 +1248,63 @@ static unsigned long calc_fat_clusters(struct super_block *sb)
 }
 
 /*
+ * If this FAT filesystem is archaic (lacking a BIOS Parameter Block, ca. DOS
+ * 1.x), fix it up in-place by creating a DOS 2.x BIOS Parameter Block from
+ * defaults for the media size.
+ */
+static void fat_update_archaic_boot_sector(struct super_block *sb,
+	struct fat_boot_sector *b)
+{
+	sector_t bd_sects;
+
+	if (get_unaligned_le16(&b->sector_size) != 0 || b->sec_per_clus != 0 ||
+		b->reserved != 0 || b->fats != 0 ||
+		get_unaligned_le16(&b->dir_entries) != 0 ||
+		get_unaligned_le16(&b->sectors) != 0 || b->media != 0 ||
+		b->fat_length != 0 || b->secs_track != 0 || b->heads != 0 ||
+		b->secs_track != 0 || b->heads != 0)
+		return;
+
+	bd_sects = part_nr_sects_read(sb->s_bdev->bd_part);
+	switch (bd_sects) {
+	case 160 * KB_IN_SECTORS:
+		b->sec_per_clus = 1;
+		put_unaligned_le16(64, &b->dir_entries);
+		b->media = 0xFE;
+		b->fat_length = cpu_to_le16(1);
+		break;
+	case 180 * KB_IN_SECTORS:
+		b->sec_per_clus = 1;
+		put_unaligned_le16(64, &b->dir_entries);
+		b->media = 0xFC;
+		b->fat_length = cpu_to_le16(2);
+		break;
+	case 320 * KB_IN_SECTORS:
+		b->sec_per_clus = 2;
+		put_unaligned_le16(112, &b->dir_entries);
+		b->media = 0xFF;
+		b->fat_length = cpu_to_le16(1);
+		break;
+	case 360 * KB_IN_SECTORS:
+		b->sec_per_clus = 2;
+		put_unaligned_le16(112, &b->dir_entries);
+		b->media = 0xFD;
+		b->fat_length = cpu_to_le16(2);
+		break;
+	default:
+		fat_msg(sb, KERN_WARNING,
+			"DOS volume lacks BPB and isn't a recognized floppy size (%ld sectors)",
+			(long)bd_sects);
+		return;
+	}
+
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
@@ -1297,6 +1356,8 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	}
 
 	b = (struct fat_boot_sector *) bh->b_data;
+	fat_update_archaic_boot_sector(sb, b);
+
 	if (!b->reserved) {
 		if (!silent)
 			fat_msg(sb, KERN_ERR, "bogus number of reserved sectors");
@@ -1364,6 +1425,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 			goto out_fail;
 		}
 		b = (struct fat_boot_sector *) bh->b_data;
+		fat_update_archaic_boot_sector(sb, b);
 	}
 
 	mutex_init(&sbi->s_lock);
-- 
1.9.0

