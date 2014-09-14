Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaINWOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 18:14:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:32918 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbaINWOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 18:14:37 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 10/10] f2fs: fix double lock for inode page during roll-foward recovery
Date: Sun, 14 Sep 2014 15:14:24 -0700
Message-Id: <1410732864-53069-10-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
References: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the inode is same and its data index are needed to truncate, we can fall into
double lock for its inode page via get_dnode_of_data.

Error case is like this.

1. write data 1, 2, 3, 4, 5 in inode #4.
2. write data 100, 102, 103, 104, 105 in dnode #6 of inode #4.
3. sync
4. update data 100->106 in dnode #6.
5. fsync inode #4.
6. power-cut

-> Then,
1. go back to #3's checkpoint
2. in do_recover_data, get_dnode_of_data() gets inode #4.
3. detect 100->106 in dnode #6.
4. check_index_in_prev_nodes tries to truncate 100 in dnode #6.
5. to trigger truncate_hole, get_dnode_of_data should grab inode #4.
6. detect *kernel hang*

This patch should resolve that bug.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/recovery.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index dbeb32d..5638c05 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -306,16 +306,30 @@ got_it:
 	ino = ino_of_node(node_page);
 	f2fs_put_page(node_page, 1);
 
-	/* Deallocate previous index in the node page */
-	inode = f2fs_iget(sbi->sb, ino);
-	if (IS_ERR(inode))
-		return PTR_ERR(inode);
+	if (ino != dn->inode->i_ino) {
+		/* Deallocate previous index in the node page */
+		inode = f2fs_iget(sbi->sb, ino);
+		if (IS_ERR(inode))
+			return PTR_ERR(inode);
+	} else {
+		inode = dn->inode;
+	}
 
 	bidx = start_bidx_of_node(offset, F2FS_I(inode)) +
-					le16_to_cpu(sum.ofs_in_node);
+			le16_to_cpu(sum.ofs_in_node);
 
-	truncate_hole(inode, bidx, bidx + 1);
-	iput(inode);
+	if (ino != dn->inode->i_ino) {
+		truncate_hole(inode, bidx, bidx + 1);
+		iput(inode);
+	} else {
+		struct dnode_of_data tdn;
+		set_new_dnode(&tdn, inode, dn->inode_page, NULL, 0);
+		if (get_dnode_of_data(&tdn, bidx, LOOKUP_NODE))
+			return 0;
+		if (tdn.data_blkaddr != NULL_ADDR)
+			truncate_data_blocks_range(&tdn, 1);
+		f2fs_put_page(tdn.node_page, 1);
+	}
 	return 0;
 }
 
-- 
1.8.5.2 (Apple Git-48)

