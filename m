Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbaBGQsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:48:35 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:51403 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaBGQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:48:29 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, hch@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, zab@redhat.com, jack@suse.cz, luto@amacapital.net,
        mszeredi@suse.cz
Subject: [PATCH 01/13] vfs: add d_is_dir()
Date: Fri,  7 Feb 2014 17:48:59 +0100
Message-Id: <1391791751-2533-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add d_is_dir(dentry) helper which is analogous to S_ISDIR().

To avoid confusion, rename d_is_directory() to d_can_lookup().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c             | 23 +++++++++++------------
 include/linux/dcache.h |  7 ++++++-
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d580df2e6804..258c06ae26a7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1769,7 +1769,7 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 			if (err)
 				return err;
 		}
-		if (!d_is_directory(nd->path.dentry)) {
+		if (!d_can_lookup(nd->path.dentry)) {
 			err = -ENOTDIR; 
 			break;
 		}
@@ -1790,7 +1790,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		struct dentry *root = nd->root.dentry;
 		struct inode *inode = root->d_inode;
 		if (*name) {
-			if (!d_is_directory(root))
+			if (!d_can_lookup(root))
 				return -ENOTDIR;
 			retval = inode_permission(inode, MAY_EXEC);
 			if (retval)
@@ -1846,7 +1846,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		dentry = f.file->f_path.dentry;
 
 		if (*name) {
-			if (!d_is_directory(dentry)) {
+			if (!d_can_lookup(dentry)) {
 				fdput(f);
 				return -ENOTDIR;
 			}
@@ -1928,7 +1928,7 @@ static int path_lookupat(int dfd, const char *name,
 		err = complete_walk(nd);
 
 	if (!err && nd->flags & LOOKUP_DIRECTORY) {
-		if (!d_is_directory(nd->path.dentry)) {
+		if (!d_can_lookup(nd->path.dentry)) {
 			path_put(&nd->path);
 			err = -ENOTDIR;
 		}
@@ -2387,11 +2387,11 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 	    IS_IMMUTABLE(inode) || IS_SWAPFILE(inode))
 		return -EPERM;
 	if (isdir) {
-		if (!d_is_directory(victim) && !d_is_autodir(victim))
+		if (!d_is_dir(victim))
 			return -ENOTDIR;
 		if (IS_ROOT(victim))
 			return -EBUSY;
-	} else if (d_is_directory(victim) || d_is_autodir(victim))
+	} else if (d_is_dir(victim))
 		return -EISDIR;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
@@ -2989,11 +2989,10 @@ finish_open:
 	}
 	audit_inode(name, nd->path.dentry, 0);
 	error = -EISDIR;
-	if ((open_flag & O_CREAT) &&
-	    (d_is_directory(nd->path.dentry) || d_is_autodir(nd->path.dentry)))
+	if ((open_flag & O_CREAT) && d_is_dir(nd->path.dentry))
 		goto out;
 	error = -ENOTDIR;
-	if ((nd->flags & LOOKUP_DIRECTORY) && !d_is_directory(nd->path.dentry))
+	if ((nd->flags & LOOKUP_DIRECTORY) && !d_can_lookup(nd->path.dentry))
 		goto out;
 	if (!S_ISREG(nd->inode->i_mode))
 		will_truncate = false;
@@ -3717,7 +3716,7 @@ exit1:
 slashes:
 	if (d_is_negative(dentry))
 		error = -ENOENT;
-	else if (d_is_directory(dentry) || d_is_autodir(dentry))
+	else if (d_is_dir(dentry))
 		error = -EISDIR;
 	else
 		error = -ENOTDIR;
@@ -4096,7 +4095,7 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	       struct inode **delegated_inode)
 {
 	int error;
-	int is_dir = d_is_directory(old_dentry) || d_is_autodir(old_dentry);
+	int is_dir = d_is_dir(old_dentry);
 	const unsigned char *old_name;
 
 	if (old_dentry->d_inode == new_dentry->d_inode)
@@ -4189,7 +4188,7 @@ retry_deleg:
 	if (d_is_negative(old_dentry))
 		goto exit4;
 	/* unless the source is a directory trailing slashes give -ENOTDIR */
-	if (!d_is_directory(old_dentry) && !d_is_autodir(old_dentry)) {
+	if (!d_is_dir(old_dentry)) {
 		error = -ENOTDIR;
 		if (oldnd.last.name[oldnd.last.len])
 			goto exit4;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index bf72e9ac6de0..3b50cac7ccb3 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -429,7 +429,7 @@ static inline unsigned __d_entry_type(const struct dentry *dentry)
 	return dentry->d_flags & DCACHE_ENTRY_TYPE;
 }
 
-static inline bool d_is_directory(const struct dentry *dentry)
+static inline bool d_can_lookup(const struct dentry *dentry)
 {
 	return __d_entry_type(dentry) == DCACHE_DIRECTORY_TYPE;
 }
@@ -439,6 +439,11 @@ static inline bool d_is_autodir(const struct dentry *dentry)
 	return __d_entry_type(dentry) == DCACHE_AUTODIR_TYPE;
 }
 
+static inline bool d_is_dir(const struct dentry *dentry)
+{
+	return d_can_lookup(dentry) || d_is_autodir(dentry);
+}
+
 static inline bool d_is_symlink(const struct dentry *dentry)
 {
 	return __d_entry_type(dentry) == DCACHE_SYMLINK_TYPE;
-- 
1.8.1.4

