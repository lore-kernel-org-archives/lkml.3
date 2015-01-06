Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbbAFTUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:20:46 -0500
Received: from mail.kernel.org ([198.145.29.136]:43564 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299AbbAFTUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:20:44 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/4] f2fs: remove uncovered code path
Date: Tue,  6 Jan 2015 11:20:33 -0800
Message-Id: <1420572034-53758-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1420572034-53758-1-git-send-email-jaegeuk@kernel.org>
References: <1420572034-53758-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unnecessary function calls.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 155885b..3e0f5f3 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -563,31 +563,22 @@ static int __allocate_data_block(struct dnode_of_data *dn)
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dn->inode);
 	struct f2fs_inode_info *fi = F2FS_I(dn->inode);
 	struct f2fs_summary sum;
-	block_t new_blkaddr;
 	struct node_info ni;
 	pgoff_t fofs;
-	int type;
 
 	if (unlikely(is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC)))
 		return -EPERM;
 	if (unlikely(!inc_valid_block_count(sbi, dn->inode, 1)))
 		return -ENOSPC;
 
-	dn->data_blkaddr = NEW_ADDR;
-	__set_data_blkaddr(dn);
-
 	get_node_info(sbi, dn->nid, &ni);
 	set_summary(&sum, dn->nid, dn->ofs_in_node, ni.version);
 
-	type = CURSEG_WARM_DATA;
-
-	allocate_data_block(sbi, NULL, NULL_ADDR, &new_blkaddr, &sum, type);
+	allocate_data_block(sbi, NULL, NULL_ADDR, &dn->data_blkaddr, &sum,
+							CURSEG_WARM_DATA);
 
 	/* direct IO doesn't use extent cache to maximize the performance */
-	set_inode_flag(F2FS_I(dn->inode), FI_NO_EXTENT);
-	dn->data_blkaddr = new_blkaddr;
-	update_extent_cache(dn);
-	clear_inode_flag(F2FS_I(dn->inode), FI_NO_EXTENT);
+	__set_data_blkaddr(dn);
 
 	/* update i_size */
 	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
@@ -595,7 +586,6 @@ static int __allocate_data_block(struct dnode_of_data *dn)
 	if (i_size_read(dn->inode) < ((fofs + 1) << PAGE_CACHE_SHIFT))
 		i_size_write(dn->inode, ((fofs + 1) << PAGE_CACHE_SHIFT));
 
-	dn->data_blkaddr = new_blkaddr;
 	return 0;
 }
 
-- 
2.1.1

