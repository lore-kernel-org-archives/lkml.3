Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3JIOlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:41:02 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:37611 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3JIOlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:41:00 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.sahrawat@samsung.com, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 3/5] fat: zero out seek range on _fat_get_block
Date: Wed,  9 Oct 2013 23:40:53 +0900
Message-Id: <1381329653-11905-1-git-send-email-linkinjeon@gmail.com>
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
index 37572c2..7dc689e 100644
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
index 2211489..2f2a265 100644
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

