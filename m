Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaIZEzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:55:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:57075 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbaIZEy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:54:57 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4/4] f2fs: call f2fs_unlock_op after error was handled
Date: Thu, 25 Sep 2014 21:54:47 -0700
Message-Id: <1411707287-21760-4-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.9.3 (Apple Git-50)
In-Reply-To: <1411707287-21760-1-git-send-email-jaegeuk@kernel.org>
References: <1411707287-21760-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch relocates f2fs_unlock_op in every directory operations to be called
after any error was processed.
Otherwise, the checkpoint can be entered with valid node ids without its
dentry when -ENOSPC is occurred.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h  |  1 +
 fs/f2fs/inode.c | 23 +++++++++++++++++++++++
 fs/f2fs/namei.c | 32 +++++++++++---------------------
 3 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 802ebf3..fc66d1b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1208,6 +1208,7 @@ void update_inode(struct inode *, struct page *);
 void update_inode_page(struct inode *);
 int f2fs_write_inode(struct inode *, struct writeback_control *);
 void f2fs_evict_inode(struct inode *);
+void handle_failed_inode(struct inode *);
 
 /*
  * namei.c
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 62c5284..002036b 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -310,3 +310,26 @@ no_delete:
 out_clear:
 	clear_inode(inode);
 }
+
+/* caller should call f2fs_lock_op() */
+void handle_failed_inode(struct inode *inode)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+
+	clear_nlink(inode);
+	make_bad_inode(inode);
+	unlock_new_inode(inode);
+
+	i_size_write(inode, 0);
+	if (F2FS_HAS_BLOCKS(inode))
+		f2fs_truncate(inode);
+
+	remove_inode_page(inode);
+	stat_dec_inline_inode(inode);
+
+	alloc_nid_failed(sbi, inode->i_ino);
+	f2fs_unlock_op(sbi);
+
+	/* iput will drop the inode object */
+	iput(inode);
+}
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index ba0779d..0d2526e 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -123,9 +123,9 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 
 	f2fs_lock_op(sbi);
 	err = f2fs_add_link(dentry, inode);
-	f2fs_unlock_op(sbi);
 	if (err)
 		goto out;
+	f2fs_unlock_op(sbi);
 
 	alloc_nid_done(sbi, ino);
 
@@ -133,9 +133,7 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	unlock_new_inode(inode);
 	return 0;
 out:
-	clear_nlink(inode);
-	iget_failed(inode);
-	alloc_nid_failed(sbi, ino);
+	handle_failed_inode(inode);
 	return err;
 }
 
@@ -154,15 +152,16 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
 	set_inode_flag(F2FS_I(inode), FI_INC_LINK);
 	f2fs_lock_op(sbi);
 	err = f2fs_add_link(dentry, inode);
-	f2fs_unlock_op(sbi);
 	if (err)
 		goto out;
+	f2fs_unlock_op(sbi);
 
 	d_instantiate(dentry, inode);
 	return 0;
 out:
 	clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
 	iput(inode);
+	f2fs_unlock_op(sbi);
 	return err;
 }
 
@@ -253,9 +252,9 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
 
 	f2fs_lock_op(sbi);
 	err = f2fs_add_link(dentry, inode);
-	f2fs_unlock_op(sbi);
 	if (err)
 		goto out;
+	f2fs_unlock_op(sbi);
 
 	err = page_symlink(inode, symname, symlen);
 	alloc_nid_done(sbi, inode->i_ino);
@@ -264,9 +263,7 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
 	unlock_new_inode(inode);
 	return err;
 out:
-	clear_nlink(inode);
-	iget_failed(inode);
-	alloc_nid_failed(sbi, inode->i_ino);
+	handle_failed_inode(inode);
 	return err;
 }
 
@@ -290,9 +287,9 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	set_inode_flag(F2FS_I(inode), FI_INC_LINK);
 	f2fs_lock_op(sbi);
 	err = f2fs_add_link(dentry, inode);
-	f2fs_unlock_op(sbi);
 	if (err)
 		goto out_fail;
+	f2fs_unlock_op(sbi);
 
 	alloc_nid_done(sbi, inode->i_ino);
 
@@ -303,9 +300,7 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 
 out_fail:
 	clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
-	clear_nlink(inode);
-	iget_failed(inode);
-	alloc_nid_failed(sbi, inode->i_ino);
+	handle_failed_inode(inode);
 	return err;
 }
 
@@ -338,18 +333,16 @@ static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
 
 	f2fs_lock_op(sbi);
 	err = f2fs_add_link(dentry, inode);
-	f2fs_unlock_op(sbi);
 	if (err)
 		goto out;
+	f2fs_unlock_op(sbi);
 
 	alloc_nid_done(sbi, inode->i_ino);
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
 	return 0;
 out:
-	clear_nlink(inode);
-	iget_failed(inode);
-	alloc_nid_failed(sbi, inode->i_ino);
+	handle_failed_inode(inode);
 	return err;
 }
 
@@ -677,10 +670,7 @@ static int f2fs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 release_out:
 	release_orphan_inode(sbi);
 out:
-	f2fs_unlock_op(sbi);
-	clear_nlink(inode);
-	iget_failed(inode);
-	alloc_nid_failed(sbi, inode->i_ino);
+	handle_failed_inode(inode);
 	return err;
 }
 
-- 
1.9.3 (Apple Git-50)

