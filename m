Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaJIVEC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:04:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaJIVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miklos Szeredi <mszeredi@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 006/163] vfs: add d_is_dir()
Date: Thu,  9 Oct 2014 14:00:31 -0700
Message-Id: <1412888588-26755-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 44b1d53043c482225196e8a9cd9f35163a1b3336 upstream.

Add d_is_dir(dentry) helper which is analogous to S_ISDIR().

To avoid confusion, rename d_is_directory() to d_can_lookup().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
[ kamal: 3.13-stable prereq for a9c8259 "CIFS: Fix directory rename error" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/namei.c             | 23 +++++++++++------------
 include/linux/dcache.h |  7 ++++++-
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 31673f4..c0cd08d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1786,7 +1786,7 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 			if (err)
 				return err;
 		}
-		if (!d_is_directory(nd->path.dentry)) {
+		if (!d_can_lookup(nd->path.dentry)) {
 			err = -ENOTDIR; 
 			break;
 		}
@@ -1807,7 +1807,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		struct dentry *root = nd->root.dentry;
 		struct inode *inode = root->d_inode;
 		if (*name) {
-			if (!d_is_directory(root))
+			if (!d_can_lookup(root))
 				return -ENOTDIR;
 			retval = inode_permission(inode, MAY_EXEC);
 			if (retval)
@@ -1863,7 +1863,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		dentry = f.file->f_path.dentry;
 
 		if (*name) {
-			if (!d_is_directory(dentry)) {
+			if (!d_can_lookup(dentry)) {
 				fdput(f);
 				return -ENOTDIR;
 			}
@@ -1945,7 +1945,7 @@ static int path_lookupat(int dfd, const char *name,
 		err = complete_walk(nd);
 
 	if (!err && nd->flags & LOOKUP_DIRECTORY) {
-		if (!d_is_directory(nd->path.dentry)) {
+		if (!d_can_lookup(nd->path.dentry)) {
 			path_put(&nd->path);
 			err = -ENOTDIR;
 		}
@@ -2405,11 +2405,11 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
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
@@ -3007,11 +3007,10 @@ finish_open:
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
@@ -3735,7 +3734,7 @@ exit1:
 slashes:
 	if (d_is_negative(dentry))
 		error = -ENOENT;
-	else if (d_is_directory(dentry) || d_is_autodir(dentry))
+	else if (d_is_dir(dentry))
 		error = -EISDIR;
 	else
 		error = -ENOTDIR;
@@ -4114,7 +4113,7 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	       struct inode **delegated_inode)
 {
 	int error;
-	int is_dir = d_is_directory(old_dentry) || d_is_autodir(old_dentry);
+	int is_dir = d_is_dir(old_dentry);
 	const unsigned char *old_name;
 
 	if (old_dentry->d_inode == new_dentry->d_inode)
@@ -4207,7 +4206,7 @@ retry_deleg:
 	if (d_is_negative(old_dentry))
 		goto exit4;
 	/* unless the source is a directory trailing slashes give -ENOTDIR */
-	if (!d_is_directory(old_dentry) && !d_is_autodir(old_dentry)) {
+	if (!d_is_dir(old_dentry)) {
 		error = -ENOTDIR;
 		if (oldnd.last.name[oldnd.last.len])
 			goto exit4;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index bf72e9a..3b50cac 100644
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
1.9.1

