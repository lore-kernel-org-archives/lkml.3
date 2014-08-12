Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbaHLTt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:49:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:58014 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbaHLTtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:49:24 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 05/13] f2fs: should clear the inline_xattr flag
Date: Tue, 12 Aug 2014 12:49:19 -0700
Message-Id: <1407872967-26423-5-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the recovery, we should clear the inline_xattr flag if its xattr node
block is recovered.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/node.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 093d799..151045f 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1557,26 +1557,25 @@ void recover_inline_xattr(struct inode *inode, struct page *page)
 	struct page *ipage;
 	struct f2fs_inode *ri;
 
-	if (!f2fs_has_inline_xattr(inode))
-		return;
-
 	if (!IS_INODE(page))
 		return;
 
-	ri = F2FS_INODE(page);
-	if (!(ri->i_inline & F2FS_INLINE_XATTR))
-		return;
-
 	ipage = get_node_page(sbi, inode->i_ino);
 	f2fs_bug_on(IS_ERR(ipage));
 
+	ri = F2FS_INODE(page);
+	if (!(ri->i_inline & F2FS_INLINE_XATTR)) {
+		clear_inode_flag(F2FS_I(inode), FI_INLINE_XATTR);
+		goto update_inode;
+	}
+
 	dst_addr = inline_xattr_addr(ipage);
 	src_addr = inline_xattr_addr(page);
 	inline_size = inline_xattr_size(inode);
 
 	f2fs_wait_on_page_writeback(ipage, NODE);
 	memcpy(dst_addr, src_addr, inline_size);
-
+update_inode:
 	update_inode(inode, ipage);
 	f2fs_put_page(ipage, 1);
 }
-- 
1.8.5.2 (Apple Git-48)

