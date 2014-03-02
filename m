Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaCBOJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 09:09:15 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51259 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaCBOIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 09:08:54 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v4 1/6] fat: add i_disksize to represent uninitialized size
Date: Sun,  2 Mar 2014 23:08:47 +0900
Message-Id: <1393769327-3472-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add i_disksize to represent uninitialized allocated size.
And mmu_private represent initialized allocated size.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/cache.c | 6 +++---
 fs/fat/fat.h   | 3 ++-
 fs/fat/file.c  | 4 +++-
 fs/fat/inode.c | 9 +++++++--
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index 91ad9e1..a132666 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -329,10 +329,10 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 			return 0;
 
 		/*
-		 * ->mmu_private can access on only allocation path.
-		 * (caller must hold ->i_mutex)
+		 * Both ->mmu_private and ->i_disksize can access
+		 * on only allocation path. (caller must hold ->i_mutex)
 		 */
-		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
+		last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
 			>> blocksize_bits;
 		if (sector >= last_block)
 			return 0;
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 7c31f4b..7b5851f 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -118,7 +118,8 @@ struct msdos_inode_info {
 	unsigned int cache_valid_id;
 
 	/* NOTE: mmu_private is 64bits, so must hold ->i_mutex to access */
-	loff_t mmu_private;	/* physically allocated size */
+	loff_t mmu_private;	/* physically allocated size (initialized) */
+	loff_t i_disksize;	/* physically allocated size (uninitialized) */
 
 	int i_start;		/* first cluster or 0 */
 	int i_logstart;		/* logical first cluster */
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 9b104f5..0bf0d28 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -300,8 +300,10 @@ void fat_truncate_blocks(struct inode *inode, loff_t offset)
 	 * This protects against truncating a file bigger than it was then
 	 * trying to write into the hole.
 	 */
-	if (MSDOS_I(inode)->mmu_private > offset)
+	if (MSDOS_I(inode)->i_disksize > offset) {
 		MSDOS_I(inode)->mmu_private = offset;
+		MSDOS_I(inode)->i_disksize = offset;
+	}
 
 	nr_clusters = (offset + (cluster_size - 1)) >> sbi->cluster_bits;
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index c68d9f2..a3b9fe8 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -93,6 +93,7 @@ static inline int __fat_get_block(struct inode *inode, sector_t iblock,
 
 	*max_blocks = min(mapped_blocks, *max_blocks);
 	MSDOS_I(inode)->mmu_private += *max_blocks << sb->s_blocksize_bits;
+	MSDOS_I(inode)->i_disksize = MSDOS_I(inode)->mmu_private;
 
 	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
 	if (err)
@@ -407,7 +408,6 @@ int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 		error = fat_calc_dir_size(inode);
 		if (error < 0)
 			return error;
-		MSDOS_I(inode)->mmu_private = inode->i_size;
 
 		set_nlink(inode, fat_subdirs(inode));
 	} else { /* not a directory */
@@ -422,8 +422,12 @@ int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 		inode->i_op = &fat_file_inode_operations;
 		inode->i_fop = &fat_file_operations;
 		inode->i_mapping->a_ops = &fat_aops;
-		MSDOS_I(inode)->mmu_private = inode->i_size;
 	}
+
+	MSDOS_I(inode)->mmu_private = inode->i_size;
+	MSDOS_I(inode)->i_disksize = round_up(inode->i_size,
+		inode->i_sb->s_blocksize);
+
 	if (de->attr & ATTR_SYS) {
 		if (sbi->options.sys_immutable)
 			inode->i_flags |= S_IMMUTABLE;
@@ -1223,6 +1227,7 @@ static int fat_read_root(struct inode *inode)
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
 	MSDOS_I(inode)->i_logstart = 0;
 	MSDOS_I(inode)->mmu_private = inode->i_size;
+	MSDOS_I(inode)->i_disksize = inode->i_size;
 
 	fat_save_attrs(inode, ATTR_DIR);
 	inode->i_mtime.tv_sec = inode->i_atime.tv_sec = inode->i_ctime.tv_sec = 0;
-- 
1.7.11-rc0


