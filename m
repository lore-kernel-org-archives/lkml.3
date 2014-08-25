Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbaHYWdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 18:33:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:43244 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463AbaHYWdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 18:33:40 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: truncate stale block for inline_data
Date: Mon, 25 Aug 2014 15:33:40 -0700
Message-Id: <1409006020-5120-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This verifies to truncate any allocated blocks, offset[0], by inline_data.
Not figured out, but for making sure.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/node.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 044395c..4537819 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -823,22 +823,26 @@ int truncate_xattr_node(struct inode *inode, struct page *page)
  */
 void remove_inode_page(struct inode *inode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	struct page *page;
-	nid_t ino = inode->i_ino;
 	struct dnode_of_data dn;
 
-	page = get_node_page(sbi, ino);
-	if (IS_ERR(page))
+	set_new_dnode(&dn, inode, NULL, NULL, inode->i_ino);
+	if (get_dnode_of_data(&dn, 0, LOOKUP_NODE))
 		return;
 
-	if (truncate_xattr_node(inode, page)) {
-		f2fs_put_page(page, 1);
+	if (truncate_xattr_node(inode, dn.inode_page)) {
+		f2fs_put_dnode(&dn);
 		return;
 	}
+
+	/* remove potential inline_data blocks */
+	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+				S_ISLNK(inode->i_mode))
+		truncate_data_blocks_range(&dn, 1);
+
 	/* 0 is possible, after f2fs_new_inode() has failed */
 	f2fs_bug_on(inode->i_blocks != 0 && inode->i_blocks != 1);
-	set_new_dnode(&dn, inode, page, page, ino);
+
+	/* will put inode & node pages */
 	truncate_node(&dn);
 }
 
-- 
1.8.5.2 (Apple Git-48)

