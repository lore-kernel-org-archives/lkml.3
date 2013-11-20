Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab3KTNCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:02:05 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47148 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3KTNB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:01:59 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: [PATCH 01/11] vfs: add d_is_dir()
Date: Wed, 20 Nov 2013 14:01:42 +0100
Message-Id: <1384952512-21600-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384952512-21600-1-git-send-email-miklos@szeredi.hu>
References: <1384952512-21600-1-git-send-email-miklos@szeredi.hu>
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
index e029a4cbff7d..0f2a7f8febee 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1794,7 +1794,7 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 			if (err)
 				return err;
 		}
-		if (!d_is_directory(nd->path.dentry)) {
+		if (!d_can_lookup(nd->path.dentry)) {
 			err = -ENOTDIR; 
 			break;
 		}
@@ -1815,7 +1815,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		struct dentry *root = nd->root.dentry;
 		struct inode *inode = root->d_inode;
 		if (*name) {
-			if (!d_is_directory(root))
+			if (!d_can_lookup(root))
 				return -ENOTDIR;
 			retval = inode_permission(inode, MAY_EXEC);
 			if (retval)
@@ -1871,7 +1871,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		dentry = f.file->f_path.dentry;
 
 		if (*name) {
-			if (!d_is_directory(dentry)) {
+			if (!d_can_lookup(dentry)) {
 				fdput(f);
 				return -ENOTDIR;
 			}
@@ -1953,7 +1953,7 @@ static int path_lookupat(int dfd, const char *name,
 		err = complete_walk(nd);
 
 	if (!err && nd->flags & LOOKUP_DIRECTORY) {
-		if (!d_is_directory(nd->path.dentry)) {
+		if (!d_can_lookup(nd->path.dentry)) {
 			path_put(&nd->path);
 			err = -ENOTDIR;
 		}
@@ -2412,11 +2412,11 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
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
@@ -3013,11 +3013,10 @@ finish_open:
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
@@ -3741,7 +3740,7 @@ exit1:
 slashes:
 	if (d_is_negative(dentry))
 		error = -ENOENT;
-	else if (d_is_directory(dentry) || d_is_autodir(dentry))
+	else if (d_is_dir(dentry))
 		error = -EISDIR;
 	else
 		error = -ENOTDIR;
@@ -4117,7 +4116,7 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	       struct inode **delegated_inode)
 {
 	int error;
-	int is_dir = d_is_directory(old_dentry) || d_is_autodir(old_dentry);
+	int is_dir = d_is_dir(old_dentry);
 	const unsigned char *old_name;
 
 	if (old_dentry->d_inode == new_dentry->d_inode)
@@ -4210,7 +4209,7 @@ retry_deleg:
 	if (d_is_negative(old_dentry))
 		goto exit4;
 	/* unless the source is a directory trailing slashes give -ENOTDIR */
-	if (!d_is_directory(old_dentry) && !d_is_autodir(old_dentry)) {
+	if (!d_is_dir(old_dentry)) {
 		error = -ENOTDIR;
 		if (oldnd.last.name[oldnd.last.len])
 			goto exit4;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 57e87e749a48..901616910e0a 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -427,7 +427,7 @@ static inline unsigned __d_entry_type(const struct dentry *dentry)
 	return dentry->d_flags & DCACHE_ENTRY_TYPE;
 }
 
-static inline bool d_is_directory(const struct dentry *dentry)
+static inline bool d_can_lookup(const struct dentry *dentry)
 {
 	return __d_entry_type(dentry) == DCACHE_DIRECTORY_TYPE;
 }
@@ -437,6 +437,11 @@ static inline bool d_is_autodir(const struct dentry *dentry)
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

