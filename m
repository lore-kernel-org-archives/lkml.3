Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaCBOJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 09:09:44 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53024 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbaCBOJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 09:09:40 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v4 5/6] fat: permit to return phy block number by fibmap in fallocated region
Date: Sun,  2 Mar 2014 23:09:33 +0900
Message-Id: <1393769373-3609-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Make the fibmap call the return the proper physical block number for any
offset request in the fallocated range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/cache.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++------------
 fs/fat/fat.h   |  3 +++
 fs/fat/inode.c | 25 ++++++++++++++++++++++-
 3 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index a132666..e26bc9a 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -303,6 +303,31 @@ static int fat_bmap_cluster(struct inode *inode, int cluster)
 	return dclus;
 }
 
+static int fat_get_mapped_cluster(struct inode *inode, sector_t sector,
+				  sector_t last_block,
+				  unsigned long *mapped_blocks, sector_t *bmap)
+{
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int cluster, offset;
+
+	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
+	offset  = sector & (sbi->sec_per_clus - 1);
+	cluster = fat_bmap_cluster(inode, cluster);
+
+	if (cluster < 0)
+		return cluster;
+
+	else if (cluster) {
+		*bmap = fat_clus_to_blknr(sbi, cluster) + offset;
+		*mapped_blocks = sbi->sec_per_clus - offset;
+		if (*mapped_blocks > last_block - sector)
+			*mapped_blocks = last_block - sector;
+	}
+
+	return 0;
+}
+
 int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 	     unsigned long *mapped_blocks, int create)
 {
@@ -311,7 +336,6 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 	const unsigned long blocksize = sb->s_blocksize;
 	const unsigned char blocksize_bits = sb->s_blocksize_bits;
 	sector_t last_block;
-	int cluster, offset;
 
 	*phys = 0;
 	*mapped_blocks = 0;
@@ -338,16 +362,30 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 			return 0;
 	}
 
-	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
-	offset  = sector & (sbi->sec_per_clus - 1);
-	cluster = fat_bmap_cluster(inode, cluster);
-	if (cluster < 0)
-		return cluster;
-	else if (cluster) {
-		*phys = fat_clus_to_blknr(sbi, cluster) + offset;
-		*mapped_blocks = sbi->sec_per_clus - offset;
-		if (*mapped_blocks > last_block - sector)
-			*mapped_blocks = last_block - sector;
-	}
-	return 0;
+	return fat_get_mapped_cluster(inode, sector, last_block, mapped_blocks,
+				      phys);
+}
+
+int fat_bmap2(struct inode *inode, sector_t sector,
+	      unsigned long *mapped_blocks, struct buffer_head *bh_result,
+	      int create, sector_t *bmap)
+{
+	struct super_block *sb = inode->i_sb;
+	sector_t last_block;
+	const unsigned long blocksize = sb->s_blocksize;
+	const unsigned char blocksize_bits = sb->s_blocksize_bits;
+
+	BUG_ON(create != 0);
+
+	*bmap = 0;
+	*mapped_blocks = 0;
+
+	last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
+		>> blocksize_bits;
+
+	if (sector >= last_block)
+		return 0;
+
+	return fat_get_mapped_cluster(inode, sector, last_block, mapped_blocks,
+				      bmap);
 }
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 7b5851f..7270bdb 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -290,6 +290,9 @@ extern int fat_get_cluster(struct inode *inode, int cluster,
 			   int *fclus, int *dclus);
 extern int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 		    unsigned long *mapped_blocks, int create);
+extern int fat_bmap2(struct inode *inode, sector_t sector,
+		     unsigned long *mapped_blocks,
+		     struct buffer_head *bh_result, int create, sector_t *bmap);
 
 /* fat/dir.c */
 extern const struct file_operations fat_dir_operations;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 9509d07..a4a0d5f 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -250,13 +250,36 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 	return ret;
 }
 
+static int fat_get_block_bmap(struct inode *inode, sector_t iblock,
+		struct buffer_head *bh_result, int create)
+{
+	struct super_block *sb = inode->i_sb;
+	unsigned long max_blocks = bh_result->b_size >> inode->i_blkbits;
+	int err;
+	sector_t bmap;
+	unsigned long mapped_blocks;
+
+	err = fat_bmap2(inode, iblock, &mapped_blocks, bh_result, create,
+			&bmap);
+	if (err)
+		return err;
+
+	if (bmap) {
+		map_bh(bh_result, sb, bmap);
+		max_blocks = min(mapped_blocks, max_blocks);
+	}
+
+	bh_result->b_size = max_blocks << sb->s_blocksize_bits;
+	return 0;
+}
+
 static sector_t _fat_bmap(struct address_space *mapping, sector_t block)
 {
 	sector_t blocknr;
 
 	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
 	down_read(&MSDOS_I(mapping->host)->truncate_lock);
-	blocknr = generic_block_bmap(mapping, block, fat_get_block);
+	blocknr = generic_block_bmap(mapping, block, fat_get_block_bmap);
 	up_read(&MSDOS_I(mapping->host)->truncate_lock);
 
 	return blocknr;
-- 
1.7.11-rc0


