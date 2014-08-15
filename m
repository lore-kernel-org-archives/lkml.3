Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaHOWDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 18:03:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:54444 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaHOWC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 18:02:59 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/4] f2fs: avoid double lock in truncate_blocks
Date: Fri, 15 Aug 2014 15:03:48 -0700
Message-Id: <1408140229-54949-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1408140229-54949-1-git-send-email-jaegeuk@kernel.org>
References: <1408140229-54949-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The init_inode_metadata calls truncate_blocks when error is occurred.
The callers holds f2fs_lock_op, so we should not call it again in
truncate_blocks.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c   |  2 +-
 fs/f2fs/dir.c    |  2 +-
 fs/f2fs/f2fs.h   |  2 +-
 fs/f2fs/file.c   | 13 ++++++++-----
 fs/f2fs/inline.c |  2 +-
 5 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 68834e2..14cc3e8 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -935,7 +935,7 @@ static void f2fs_write_failed(struct address_space *mapping, loff_t to)
 
 	if (to > inode->i_size) {
 		truncate_pagecache(inode, inode->i_size);
-		truncate_blocks(inode, inode->i_size);
+		truncate_blocks(inode, inode->i_size, true);
 	}
 }
 
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index a69bbfa..155fb05 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -391,7 +391,7 @@ put_error:
 error:
 	/* once the failed inode becomes a bad inode, i_mode is S_IFREG */
 	truncate_inode_pages(&inode->i_data, 0);
-	truncate_blocks(inode, 0);
+	truncate_blocks(inode, 0, false);
 	remove_dirty_dir_inode(inode);
 	remove_inode_page(inode);
 	return ERR_PTR(err);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2723b2d..7f976c1 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1122,7 +1122,7 @@ static inline void f2fs_stop_checkpoint(struct f2fs_sb_info *sbi)
  */
 int f2fs_sync_file(struct file *, loff_t, loff_t, int);
 void truncate_data_blocks(struct dnode_of_data *);
-int truncate_blocks(struct inode *, u64);
+int truncate_blocks(struct inode *, u64, bool);
 void f2fs_truncate(struct inode *);
 int f2fs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 int f2fs_setattr(struct dentry *, struct iattr *);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ecbdf6a..a8e97f8 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -422,7 +422,7 @@ out:
 	f2fs_put_page(page, 1);
 }
 
-int truncate_blocks(struct inode *inode, u64 from)
+int truncate_blocks(struct inode *inode, u64 from, bool lock)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	unsigned int blocksize = inode->i_sb->s_blocksize;
@@ -438,14 +438,16 @@ int truncate_blocks(struct inode *inode, u64 from)
 	free_from = (pgoff_t)
 			((from + blocksize - 1) >> (sbi->log_blocksize));
 
-	f2fs_lock_op(sbi);
+	if (lock)
+		f2fs_lock_op(sbi);
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, free_from, LOOKUP_NODE);
 	if (err) {
 		if (err == -ENOENT)
 			goto free_next;
-		f2fs_unlock_op(sbi);
+		if (lock)
+			f2fs_unlock_op(sbi);
 		trace_f2fs_truncate_blocks_exit(inode, err);
 		return err;
 	}
@@ -463,7 +465,8 @@ int truncate_blocks(struct inode *inode, u64 from)
 	f2fs_put_dnode(&dn);
 free_next:
 	err = truncate_inode_blocks(inode, free_from);
-	f2fs_unlock_op(sbi);
+	if (lock)
+		f2fs_unlock_op(sbi);
 done:
 	/* lastly zero out the first data page */
 	truncate_partial_data_page(inode, from);
@@ -480,7 +483,7 @@ void f2fs_truncate(struct inode *inode)
 
 	trace_f2fs_truncate(inode);
 
-	if (!truncate_blocks(inode, i_size_read(inode))) {
+	if (!truncate_blocks(inode, i_size_read(inode), true)) {
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		mark_inode_dirty(inode);
 	}
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 520758b..4d1f39f 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -247,7 +247,7 @@ process_inline:
 		update_inode(inode, ipage);
 		f2fs_put_page(ipage, 1);
 	} else if (ri && (ri->i_inline & F2FS_INLINE_DATA)) {
-		truncate_blocks(inode, 0);
+		truncate_blocks(inode, 0, false);
 		set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
 		goto process_inline;
 	}
-- 
1.8.5.2 (Apple Git-48)

