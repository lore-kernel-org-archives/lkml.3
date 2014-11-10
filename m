Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaKJOt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:49:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:56316 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbaKJOt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:49:26 -0500
Date: Mon, 10 Nov 2014 06:49:24 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Changman Lee <cm224.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: implement -o dirsync
Message-ID: <20141110144924.GA25172@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <1415600662-23337-1-git-send-email-jaegeuk@kernel.org>
 <20141110074712.GD14659@lcm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110074712.GD14659@lcm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v1:
 o call sync after mark_inode_dirty

If a mount option has dirsync, we should call checkpoint for all the directory
operations.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/namei.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 6312dd2..2bee559 100644
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
@@ -235,6 +241,9 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 
 	/* In order to evict this inode, we set it dirty */
 	mark_inode_dirty(inode);
+
+	if (IS_DIRSYNC(dir))
+		f2fs_sync_fs(sbi->sb, 1);
 fail:
 	trace_f2fs_unlink_exit(inode, err);
 	return err;
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

