Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3JIOkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:40:37 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:53401 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab3JIOkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:40:35 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.sahrawat@samsung.com, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 1/5] fat: add i_disksize to represent uninitialized size
Date: Wed,  9 Oct 2013 23:40:27 +0900
Message-Id: <1381329627-11837-1-git-send-email-linkinjeon@gmail.com>
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
 fs/fat/cache.c |    4 ++--
 fs/fat/fat.h   |    3 ++-
 fs/fat/file.c  |    4 +++-
 fs/fat/inode.c |    4 ++++
 4 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index 91ad9e1..37572c2 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -329,10 +329,10 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 			return 0;
 
 		/*
-		 * ->mmu_private can access on only allocation path.
+		 * ->i_disksize can access on only allocation path.
 		 * (caller must hold ->i_mutex)
 		 */
-		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
+		last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
 			>> blocksize_bits;
 		if (sector >= last_block)
 			return 0;
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 4241e6f..1716199 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -117,7 +117,8 @@ struct msdos_inode_info {
 	unsigned int cache_valid_id;
 
 	/* NOTE: mmu_private is 64bits, so must hold ->i_mutex to access */
-	loff_t mmu_private;	/* physically allocated size */
+	loff_t mmu_private;	/* physically allocated size (uninitialized) */
+	loff_t i_disksize;	/* physically allocated size (initialized) */
 
 	int i_start;		/* first cluster or 0 */
 	int i_logstart;		/* logical first cluster */
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 33711ff..7301adb 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -300,8 +300,10 @@ void fat_truncate_blocks(struct inode *inode, loff_t offset)
 	 * This protects against truncating a file bigger than it was then
 	 * trying to write into the hole.
 	 */
-	if (MSDOS_I(inode)->mmu_private > offset)
+	if (MSDOS_I(inode)->mmu_private > offset) {
 		MSDOS_I(inode)->mmu_private = offset;
+		MSDOS_I(inode)->i_disksize = offset;
+	}
 
 	nr_clusters = (offset + (cluster_size - 1)) >> sbi->cluster_bits;
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 3134d1e..578a5db 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -93,6 +93,7 @@ static inline int __fat_get_block(struct inode *inode, sector_t iblock,
 
 	*max_blocks = min(mapped_blocks, *max_blocks);
 	MSDOS_I(inode)->mmu_private += *max_blocks << sb->s_blocksize_bits;
+	MSDOS_I(inode)->i_disksize = MSDOS_I(inode)->mmu_private;
 
 	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
 	if (err)
@@ -406,6 +407,7 @@ int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 		if (error < 0)
 			return error;
 		MSDOS_I(inode)->mmu_private = inode->i_size;
+		MSDOS_I(inode)->i_disksize = inode->i_size;
 
 		set_nlink(inode, fat_subdirs(inode));
 	} else { /* not a directory */
@@ -421,6 +423,7 @@ int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 		inode->i_fop = &fat_file_operations;
 		inode->i_mapping->a_ops = &fat_aops;
 		MSDOS_I(inode)->mmu_private = inode->i_size;
+		MSDOS_I(inode)->i_disksize = inode->i_size;
 	}
 	if (de->attr & ATTR_SYS) {
 		if (sbi->options.sys_immutable)
@@ -1218,6 +1221,7 @@ static int fat_read_root(struct inode *inode)
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
 	MSDOS_I(inode)->i_logstart = 0;
 	MSDOS_I(inode)->mmu_private = inode->i_size;
+	MSDOS_I(inode)->i_disksize = inode->i_size;
 
 	fat_save_attrs(inode, ATTR_DIR);
 	inode->i_mtime.tv_sec = inode->i_atime.tv_sec = inode->i_ctime.tv_sec = 0;
-- 
1.7.9.5

