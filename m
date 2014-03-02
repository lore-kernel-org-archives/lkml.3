Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaCBOJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 09:09:22 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:58364 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbaCBOJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 09:09:18 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v4 3/6] fat: zero out seek range on _fat_get_block
Date: Sun,  2 Mar 2014 23:09:09 +0900
Message-Id: <1393769349-3540-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

For normal buffered write operations, normally if we try to write to an
offset > than file size, it does a cont_expand_zero till that offset.
Now, in case of fallocated regions, since the blocks are already
allocated.  So, make it zero out that buffers for those blocks till the
seek'ed offset.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/inode.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index ca222ef..a594dae 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -54,6 +54,25 @@ static int fat_add_cluster(struct inode *inode)
 	return err;
 }
 
+static void check_fallocated_region(struct inode *inode, sector_t iblock,
+		unsigned long *max_blocks, struct buffer_head *bh_result)
+{
+	struct super_block *sb = inode->i_sb;
+	sector_t last_block, disk_block;
+	const unsigned long blocksize = sb->s_blocksize;
+	const unsigned char blocksize_bits = sb->s_blocksize_bits;
+
+	last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
+		>> blocksize_bits;
+	disk_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
+		>> blocksize_bits;
+	if (iblock >= last_block && iblock <= disk_block) {
+		MSDOS_I(inode)->mmu_private += *max_blocks << blocksize_bits;
+		set_buffer_new(bh_result);
+	}
+
+}
+
 static inline int __fat_get_block(struct inode *inode, sector_t iblock,
 				  unsigned long *max_blocks,
 				  struct buffer_head *bh_result, int create)
@@ -68,8 +87,11 @@ static inline int __fat_get_block(struct inode *inode, sector_t iblock,
 	if (err)
 		return err;
 	if (phys) {
-		map_bh(bh_result, sb, phys);
 		*max_blocks = min(mapped_blocks, *max_blocks);
+		if (create)
+			check_fallocated_region(inode, iblock, max_blocks,
+				bh_result);
+		map_bh(bh_result, sb, phys);
 		return 0;
 	}
 	if (!create)
-- 
1.7.11-rc0


