Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaKJGY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:24:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:59349 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaKJGY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:24:27 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: implement -o dirsync
Date: Sun,  9 Nov 2014 22:24:22 -0800
Message-Id: <1415600662-23337-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a mount option has dirsync, we should call checkpoint for all the directory
operations.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/namei.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 6312dd2..db3ee09 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -138,6 +138,9 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	stat_inc_inline_inode(inode);
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+
+	if (IS_DIRSYNC(dir))
+		f2fs_sync_fs(sbi->sb, 1);
 	return 0;
 out:
 	handle_failed_inode(inode);
@@ -164,6 +167,9 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
 	f2fs_unlock_op(sbi);
 
 	d_instantiate(dentry, inode);
+
+	if (IS_DIRSYNC(dir))
+		f2fs_sync_fs(sbi->sb, 1);
 	return 0;
 out:
 	clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
@@ -233,6 +239,9 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	f2fs_delete_entry(de, page, dir, inode);
 	f2fs_unlock_op(sbi);
 
+	if (IS_DIRSYNC(dir))
+		f2fs_sync_fs(sbi->sb, 1);
+
 	/* In order to evict this inode, we set it dirty */
 	mark_inode_dirty(inode);
 fail:
@@ -268,6 +277,9 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
 
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+
+	if (IS_DIRSYNC(dir))
+		f2fs_sync_fs(sbi->sb, 1);
 	return err;
 out:
 	handle_failed_inode(inode);
@@ -304,6 +316,8 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
 
+	if (IS_DIRSYNC(dir))
+		f2fs_sync_fs(sbi->sb, 1);
 	return 0;
 
 out_fail:
@@ -346,8 +360,12 @@ static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
 	f2fs_unlock_op(sbi);
 
 	alloc_nid_done(sbi, inode->i_ino);
+
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
+
+	if (IS_DIRSYNC(dir))
+		f2fs_sync_fs(sbi->sb, 1);
 	return 0;
 out:
 	handle_failed_inode(inode);
@@ -461,6 +479,9 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 
 	f2fs_unlock_op(sbi);
+
+	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
+		f2fs_sync_fs(sbi->sb, 1);
 	return 0;
 
 put_out_dir:
@@ -600,6 +621,9 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	update_inode_page(new_dir);
 
 	f2fs_unlock_op(sbi);
+
+	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
+		f2fs_sync_fs(sbi->sb, 1);
 	return 0;
 out_undo:
 	/* Still we may fail to recover name info of f2fs_inode here */
-- 
2.1.1

