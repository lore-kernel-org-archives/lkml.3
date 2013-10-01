Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3JAQAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:00:39 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:65367 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3JAQAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:00:06 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, tytso@mit.edu, mszeredi@suse.cz
Subject: [PATCH 2/7] vfs: rename: use common code for dir and non-dir
Date: Tue,  1 Oct 2013 18:00:34 +0200
Message-Id: <1380643239-16060-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
References: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

There's actually very little difference between vfs_rename_dir() and
vfs_rename_other() so move both inline into vfs_rename() which still stays
reasonably readable.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c | 118 ++++++++++++++++++++-----------------------------------------
 1 file changed, 39 insertions(+), 79 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 911aadc..7ec6a12 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3963,19 +3963,38 @@ SYSCALL_DEFINE2(link, const char __user *, oldname, const char __user *, newname
  *	   ->i_mutex on parents, which works but leads to some truly excessive
  *	   locking].
  */
-static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
-			  struct inode *new_dir, struct dentry *new_dentry)
+int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+	       struct inode *new_dir, struct dentry *new_dentry)
 {
-	int error = 0;
+	int error;
+	const unsigned char *old_name;
+	struct inode *source = old_dentry->d_inode;
 	struct inode *target = new_dentry->d_inode;
-	unsigned max_links = new_dir->i_sb->s_max_links;
+	bool is_dir = S_ISDIR(source->i_mode);
+
+	if (source == target)
+		return 0;
+
+	error = may_delete(old_dir, old_dentry, is_dir);
+	if (error)
+		return error;
+
+	if (!target)
+		error = may_create(new_dir, new_dentry);
+	else
+		error = may_delete(new_dir, new_dentry, is_dir);
+	if (error)
+		return error;
+
+	if (!old_dir->i_op->rename)
+		return -EPERM;
 
 	/*
 	 * If we are going to change the parent - check write permissions,
 	 * we'll need to flip '..'.
 	 */
-	if (new_dir != old_dir) {
-		error = inode_permission(old_dentry->d_inode, MAY_WRITE);
+	if (is_dir && new_dir != old_dir) {
+		error = inode_permission(source, MAY_WRITE);
 		if (error)
 			return error;
 	}
@@ -3984,6 +4003,7 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 	if (error)
 		return error;
 
+	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
 	dget(new_dentry);
 	if (target)
 		mutex_lock(&target->i_mutex);
@@ -3992,96 +4012,36 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 	if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
 		goto out;
 
-	error = -EMLINK;
-	if (max_links && !target && new_dir != old_dir &&
-	    new_dir->i_nlink >= max_links)
-		goto out;
+	if (is_dir) {
+		unsigned max_links = new_dir->i_sb->s_max_links;
 
-	if (target)
-		shrink_dcache_parent(new_dentry);
-	error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
-	if (error)
-		goto out;
+		error = -EMLINK;
+		if (max_links && !target && new_dir != old_dir &&
+		    new_dir->i_nlink >= max_links)
+			goto out;
 
-	if (target) {
-		target->i_flags |= S_DEAD;
-		dont_mount(new_dentry);
+		if (target)
+			shrink_dcache_parent(new_dentry);
 	}
-	if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE))
-		d_move(old_dentry, new_dentry);
-out:
-	if (target)
-		mutex_unlock(&target->i_mutex);
-	dput(new_dentry);
-	return error;
-}
-
-static int vfs_rename_other(struct inode *old_dir, struct dentry *old_dentry,
-			    struct inode *new_dir, struct dentry *new_dentry)
-{
-	struct inode *target = new_dentry->d_inode;
-	int error;
-
-	error = security_inode_rename(old_dir, old_dentry, new_dir, new_dentry);
-	if (error)
-		return error;
-
-	dget(new_dentry);
-	if (target)
-		mutex_lock(&target->i_mutex);
-
-	error = -EBUSY;
-	if (d_mountpoint(old_dentry)||d_mountpoint(new_dentry))
-		goto out;
 
 	error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
 	if (error)
 		goto out;
 
-	if (target)
+	if (target) {
+		if (is_dir)
+			target->i_flags |= S_DEAD;
 		dont_mount(new_dentry);
+	}
 	if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE))
 		d_move(old_dentry, new_dentry);
 out:
 	if (target)
 		mutex_unlock(&target->i_mutex);
 	dput(new_dentry);
-	return error;
-}
-
-int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-	       struct inode *new_dir, struct dentry *new_dentry)
-{
-	int error;
-	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
-	const unsigned char *old_name;
-
-	if (old_dentry->d_inode == new_dentry->d_inode)
- 		return 0;
- 
-	error = may_delete(old_dir, old_dentry, is_dir);
-	if (error)
-		return error;
-
-	if (!new_dentry->d_inode)
-		error = may_create(new_dir, new_dentry);
-	else
-		error = may_delete(new_dir, new_dentry, is_dir);
-	if (error)
-		return error;
-
-	if (!old_dir->i_op->rename)
-		return -EPERM;
-
-	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
-
-	if (is_dir)
-		error = vfs_rename_dir(old_dir,old_dentry,new_dir,new_dentry);
-	else
-		error = vfs_rename_other(old_dir,old_dentry,new_dir,new_dentry);
 	if (!error)
 		fsnotify_move(old_dir, new_dir, old_name, is_dir,
-			      new_dentry->d_inode, old_dentry);
+			      target, old_dentry);
 	fsnotify_oldname_free(old_name);
 
 	return error;
-- 
1.8.1.4

