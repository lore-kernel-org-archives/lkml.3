Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaHLTtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:49:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:58031 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992AbaHLTt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:49:28 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 06/13] f2fs: fix to recover inline_xattr/data and blocks
Date: Tue, 12 Aug 2014 12:49:20 -0700
Message-Id: <1407872967-26423-6-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes not to skip xattr recovery and inline xattr/data recovery
order.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h     |  2 +-
 fs/f2fs/node.c     |  9 +--------
 fs/f2fs/recovery.c | 13 +++++++++----
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2e4aa3a..cc5ead1 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1205,7 +1205,7 @@ void alloc_nid_failed(struct f2fs_sb_info *, nid_t);
 void recover_node_page(struct f2fs_sb_info *, struct page *,
 		struct f2fs_summary *, struct node_info *, block_t);
 void recover_inline_xattr(struct inode *, struct page *);
-bool recover_xattr_data(struct inode *, struct page *, block_t);
+void recover_xattr_data(struct inode *, struct page *, block_t);
 int recover_inode_page(struct f2fs_sb_info *, struct page *);
 int restore_node_summary(struct f2fs_sb_info *, unsigned int,
 				struct f2fs_summary_block *);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 151045f..c80e3d5 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1557,9 +1557,6 @@ void recover_inline_xattr(struct inode *inode, struct page *page)
 	struct page *ipage;
 	struct f2fs_inode *ri;
 
-	if (!IS_INODE(page))
-		return;
-
 	ipage = get_node_page(sbi, inode->i_ino);
 	f2fs_bug_on(IS_ERR(ipage));
 
@@ -1580,16 +1577,13 @@ update_inode:
 	f2fs_put_page(ipage, 1);
 }
 
-bool recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
+void recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	nid_t prev_xnid = F2FS_I(inode)->i_xattr_nid;
 	nid_t new_xnid = nid_of_node(page);
 	struct node_info ni;
 
-	if (!f2fs_has_xattr_block(ofs_of_node(page)))
-		return false;
-
 	/* 1: invalidate the previous xattr nid */
 	if (!prev_xnid)
 		goto recover_xnid;
@@ -1617,7 +1611,6 @@ recover_xnid:
 	set_node_addr(sbi, &ni, blkaddr, false);
 
 	update_inode_page(inode);
-	return true;
 }
 
 int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index cfb2aa9..d7b67b8 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -302,14 +302,19 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 	struct node_info ni;
 	int err = 0, recovered = 0;
 
-	recover_inline_xattr(inode, page);
-
-	if (recover_inline_data(inode, page))
+	/* step 1: recover xattr */
+	if (IS_INODE(page)) {
+		recover_inline_xattr(inode, page);
+	} else if (f2fs_has_xattr_block(ofs_of_node(page))) {
+		recover_xattr_data(inode, page, blkaddr);
 		goto out;
+	}
 
-	if (recover_xattr_data(inode, page, blkaddr))
+	/* step 2: recover inline data */
+	if (recover_inline_data(inode, page))
 		goto out;
 
+	/* step 3: recover data indices */
 	start = start_bidx_of_node(ofs_of_node(page), fi);
 	end = start + ADDRS_PER_PAGE(page, fi);
 
-- 
1.8.5.2 (Apple Git-48)

