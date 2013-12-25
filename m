Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab3LYGcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 01:32:05 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36069 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab3LYGcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 01:32:01 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v3 5/6] fat: permit to return phy block number by fibmap in fallocated region
Date: Wed, 25 Dec 2013 15:31:52 +0900
Message-Id: <1387953112-2828-1-git-send-email-linkinjeon@gmail.com>
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
 fs/fat/cache.c |   13 ++++++++++---
 fs/fat/fat.h   |    3 +++
 fs/fat/inode.c |    3 +++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index a132666..d22c1a2 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -325,19 +325,26 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 
 	last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
 	if (sector >= last_block) {
-		if (!create)
-			return 0;
-
 		/*
 		 * Both ->mmu_private and ->i_disksize can access
 		 * on only allocation path. (caller must hold ->i_mutex)
 		 */
 		last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
 			>> blocksize_bits;
+		if (!create) {
+			/* Map a block in fallocated region */
+			if (atomic_read(&MSDOS_I(inode)->beyond_isize))
+				if (sector < last_block)
+					goto out_map_cluster;
+
+			return 0;
+		}
+
 		if (sector >= last_block)
 			return 0;
 	}
 
+out_map_cluster:
 	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
 	offset  = sector & (sbi->sec_per_clus - 1);
 	cluster = fat_bmap_cluster(inode, cluster);
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 7b5851f..b884276 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -129,6 +129,9 @@ struct msdos_inode_info {
 	struct hlist_node i_dir_hash;	/* hash by i_logstart */
 	struct rw_semaphore truncate_lock; /* protect bmap against truncate */
 	struct inode vfs_inode;
+
+	/* for getting block number beyond file size in case of fallocate */
+	atomic_t beyond_isize;
 };
 
 struct fat_slot_info {
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 3636617..1c3192b 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -256,7 +256,10 @@ static sector_t _fat_bmap(struct address_space *mapping, sector_t block)
 
 	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
 	down_read(&MSDOS_I(mapping->host)->truncate_lock);
+	/* To get block number beyond file size in fallocated region */
+	atomic_set(&MSDOS_I(mapping->host)->beyond_isize, 1);
 	blocknr = generic_block_bmap(mapping, block, fat_get_block);
+	atomic_set(&MSDOS_I(mapping->host)->beyond_isize, 0);
 	up_read(&MSDOS_I(mapping->host)->truncate_lock);
 
 	return blocknr;
-- 
1.7.9.5

