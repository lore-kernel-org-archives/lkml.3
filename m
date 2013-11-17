Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab3KQLic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 06:38:32 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:50966 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab3KQLiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 06:38:19 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v2 3/5] fat: zero out seek range on _fat_get_block
Date: Sun, 17 Nov 2013 20:38:11 +0900
Message-Id: <1384688291-2935-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

For normal buffered write operations, normally if we try to write to an
offset > than file size, it does a cont_expand_zero till that offset.
Now, in case of fallocated regions, since the blocks are already allocated.
So, make it zero out that buffers for those blocks till the seek'ed offset.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/cache.c |    3 ++-
 fs/fat/inode.c |   15 +++++++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index a132666..c56bd7e 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -334,7 +334,8 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 		 */
 		last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
 			>> blocksize_bits;
-		if (sector >= last_block)
+		if (sector >= last_block &&
+		    MSDOS_I(inode)->mmu_private == MSDOS_I(inode)->i_disksize)
 			return 0;
 	}
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 655dcc7..12a37a9 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -61,15 +61,26 @@ static inline int __fat_get_block(struct inode *inode, sector_t iblock,
 	struct super_block *sb = inode->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	unsigned long mapped_blocks;
-	sector_t phys;
+	sector_t phys, last_block, disk_block;
 	int err, offset;
+	const unsigned long blocksize = sb->s_blocksize;
+	const unsigned char blocksize_bits = sb->s_blocksize_bits;
 
 	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
 	if (err)
 		return err;
 	if (phys) {
-		map_bh(bh_result, sb, phys);
 		*max_blocks = min(mapped_blocks, *max_blocks);
+		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
+			>> blocksize_bits;
+		disk_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
+			>> blocksize_bits;
+		if (iblock >= last_block && iblock <= disk_block) {
+			MSDOS_I(inode)->mmu_private +=
+				*max_blocks << blocksize_bits;
+			set_buffer_new(bh_result);
+		}
+		map_bh(bh_result, sb, phys);
 		return 0;
 	}
 	if (!create)
-- 
1.7.9.5

