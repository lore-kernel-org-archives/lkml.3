Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaHLTtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:49:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:57981 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbaHLTtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:49:19 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 02/13] f2fs: make clear on test condition and return types
Date: Tue, 12 Aug 2014 12:49:16 -0700
Message-Id: <1407872967-26423-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a parentheses to make clear for condition check.
And also it changes the return type for better meanings.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h   |  2 +-
 fs/f2fs/inline.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c8288c9..2e4aa3a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1442,5 +1442,5 @@ int f2fs_read_inline_data(struct inode *, struct page *);
 int f2fs_convert_inline_data(struct inode *, pgoff_t, struct page *);
 int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
 void truncate_inline_data(struct inode *, u64);
-int recover_inline_data(struct inode *, struct page *);
+bool recover_inline_data(struct inode *, struct page *);
 #endif
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 1ec512d..520758b 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -203,7 +203,7 @@ void truncate_inline_data(struct inode *inode, u64 from)
 	f2fs_put_page(ipage, 1);
 }
 
-int recover_inline_data(struct inode *inode, struct page *npage)
+bool recover_inline_data(struct inode *inode, struct page *npage)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct f2fs_inode *ri = NULL;
@@ -222,7 +222,7 @@ int recover_inline_data(struct inode *inode, struct page *npage)
 		ri = F2FS_INODE(npage);
 
 	if (f2fs_has_inline_data(inode) &&
-			ri && ri->i_inline & F2FS_INLINE_DATA) {
+			ri && (ri->i_inline & F2FS_INLINE_DATA)) {
 process_inline:
 		ipage = get_node_page(sbi, inode->i_ino);
 		f2fs_bug_on(IS_ERR(ipage));
@@ -234,7 +234,7 @@ process_inline:
 		memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
 		update_inode(inode, ipage);
 		f2fs_put_page(ipage, 1);
-		return -1;
+		return true;
 	}
 
 	if (f2fs_has_inline_data(inode)) {
@@ -246,10 +246,10 @@ process_inline:
 		clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
 		update_inode(inode, ipage);
 		f2fs_put_page(ipage, 1);
-	} else if (ri && ri->i_inline & F2FS_INLINE_DATA) {
+	} else if (ri && (ri->i_inline & F2FS_INLINE_DATA)) {
 		truncate_blocks(inode, 0);
 		set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
 		goto process_inline;
 	}
-	return 0;
+	return false;
 }
-- 
1.8.5.2 (Apple Git-48)

