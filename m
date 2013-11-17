Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3KQLjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 06:39:01 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60647 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3KQLio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 06:38:44 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v2 5/5] fat: permit to return phy block number by fibmap in fallocated region
Date: Sun, 17 Nov 2013 20:38:35 +0900
Message-Id: <1384688316-3003-1-git-send-email-linkinjeon@gmail.com>
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
 fs/fat/cache.c |   16 ++++++++++++++--
 fs/fat/inode.c |    4 ++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index c56bd7e..7777822 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -312,6 +312,7 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 	const unsigned char blocksize_bits = sb->s_blocksize_bits;
 	sector_t last_block;
 	int cluster, offset;
+	loff_t i_size = i_size_read(inode);
 
 	*phys = 0;
 	*mapped_blocks = 0;
@@ -323,10 +324,20 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 		return 0;
 	}
 
-	last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
+	last_block = (i_size + (blocksize - 1)) >> blocksize_bits;
 	if (sector >= last_block) {
-		if (!create)
+		if (!create) {
+			/*
+			 * to map cluster in case of read request
+			 * for a block in fallocated region
+			 */
+			if (MSDOS_I(inode)->i_disksize >
+			    round_up(i_size, sb->s_blocksize)) {
+				goto out_map_cluster;
+			}
+
 			return 0;
+		}
 
 		/*
 		 * Both ->mmu_private and ->i_disksize can access
@@ -339,6 +350,7 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 			return 0;
 	}
 
+out_map_cluster:
 	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
 	offset  = sector & (sbi->sec_per_clus - 1);
 	cluster = fat_bmap_cluster(inode, cluster);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index c9fb9b6..bdd1efd 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -243,9 +243,9 @@ static sector_t _fat_bmap(struct address_space *mapping, sector_t block)
 	sector_t blocknr;
 
 	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
-	down_read(&MSDOS_I(mapping->host)->truncate_lock);
+	mutex_lock(&mapping->host->i_mutex);
 	blocknr = generic_block_bmap(mapping, block, fat_get_block);
-	up_read(&MSDOS_I(mapping->host)->truncate_lock);
+	mutex_unlock(&mapping->host->i_mutex);
 
 	return blocknr;
 }
-- 
1.7.9.5

