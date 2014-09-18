Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbaIRFyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:54:01 -0400
Received: from mail.kernel.org ([198.145.19.201]:43974 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbaIRFyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:54:00 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/3] f2fs: update i_size when __allocate_data_block
Date: Wed, 17 Sep 2014 22:53:55 -0700
Message-Id: <1411019637-2381-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The f2fs_direct_IO uses __allocate_data_block, but inside the allocation path,
we should update i_size at the changed time to update its inode page.
Otherwise, we can get wrong i_size after roll-forward recovery.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7749f30..aaf22a9 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -572,9 +572,11 @@ put_err:
 static int __allocate_data_block(struct dnode_of_data *dn)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dn->inode);
+	struct f2fs_inode_info *fi = F2FS_I(dn->inode);
 	struct f2fs_summary sum;
 	block_t new_blkaddr;
 	struct node_info ni;
+	pgoff_t fofs;
 	int type;
 
 	if (unlikely(is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC)))
@@ -597,6 +599,12 @@ static int __allocate_data_block(struct dnode_of_data *dn)
 	update_extent_cache(new_blkaddr, dn);
 	clear_inode_flag(F2FS_I(dn->inode), FI_NO_EXTENT);
 
+	/* update i_size */
+	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
+							dn->ofs_in_node;
+	if (i_size_read(dn->inode) < ((fofs + 1) << PAGE_CACHE_SHIFT))
+		i_size_write(dn->inode, ((fofs + 1) << PAGE_CACHE_SHIFT));
+
 	dn->data_blkaddr = new_blkaddr;
 	return 0;
 }
-- 
1.8.5.2 (Apple Git-48)

