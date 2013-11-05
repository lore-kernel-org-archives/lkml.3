Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3KECI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:08:58 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:32956 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab3KECI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:08:56 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, dpquigl@tycho.nsa.gov, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/2] kernfs: implement "trusted.*" xattr support
Date: Mon,  4 Nov 2013 21:08:42 -0500
Message-Id: <1383617322-4386-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383617322-4386-1-git-send-email-tj@kernel.org>
References: <1383617322-4386-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs inherited "security.*" xattr support from sysfs.  This patch
extends xattr support to "trusted.*" using simple_xattr_*().  As
trusted xattrs are restricted to CAP_SYS_ADMIN, simple_xattr_*() which
uses kernel memory for storage shouldn't be problematic.

Note that the existing "security.*" support doesn't implement
get/remove/list and the this patch only implements those ops for
"trusted.*".  We probably want to extend those ops to include support
for "security.*".

This patch will allow using kernfs from cgroup which requires
"trusted.*" xattr support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/kernfs/dir.c             | 12 ++++++---
 fs/kernfs/inode.c           | 63 +++++++++++++++++++++++++++++++++++++++------
 fs/kernfs/kernfs-internal.h |  7 +++++
 fs/kernfs/symlink.c         |  3 +++
 4 files changed, 74 insertions(+), 11 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 6db5ed3..d5b33fe 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -255,9 +255,12 @@ void kernfs_put(struct sysfs_dirent *sd)
 		kernfs_put(sd->s_symlink.target_sd);
 	if (sysfs_type(sd) & SYSFS_COPY_NAME)
 		kfree(sd->s_name);
-	if (sd->s_iattr && sd->s_iattr->ia_secdata)
-		security_release_secctx(sd->s_iattr->ia_secdata,
-					sd->s_iattr->ia_secdata_len);
+	if (sd->s_iattr) {
+		if (sd->s_iattr->ia_secdata)
+			security_release_secctx(sd->s_iattr->ia_secdata,
+						sd->s_iattr->ia_secdata_len);
+		simple_xattrs_free(&sd->s_iattr->xattrs);
+	}
 	kfree(sd->s_iattr);
 	ida_simple_remove(&root->ino_ida, sd->s_ino);
 	kmem_cache_free(sysfs_dir_cachep, sd);
@@ -711,6 +714,9 @@ const struct inode_operations sysfs_dir_inode_operations = {
 	.setattr	= sysfs_setattr,
 	.getattr	= sysfs_getattr,
 	.setxattr	= sysfs_setxattr,
+	.removexattr	= sysfs_removexattr,
+	.getxattr	= sysfs_getxattr,
+	.listxattr	= sysfs_listxattr,
 };
 
 static struct sysfs_dirent *sysfs_leftmost_descendant(struct sysfs_dirent *pos)
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index a1f8382..18ad431 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -35,6 +35,9 @@ static const struct inode_operations sysfs_inode_operations = {
 	.setattr	= sysfs_setattr,
 	.getattr	= sysfs_getattr,
 	.setxattr	= sysfs_setxattr,
+	.removexattr	= sysfs_removexattr,
+	.getxattr	= sysfs_getxattr,
+	.listxattr	= sysfs_listxattr,
 };
 
 void __init sysfs_inode_init(void)
@@ -61,6 +64,8 @@ static struct sysfs_inode_attrs *sysfs_inode_attrs(struct sysfs_dirent *sd)
 	iattrs->ia_gid = GLOBAL_ROOT_GID;
 	iattrs->ia_atime = iattrs->ia_mtime = iattrs->ia_ctime = CURRENT_TIME;
 
+	simple_xattrs_init(&sd->s_iattr->xattrs);
+
 	return sd->s_iattr;
 }
 
@@ -162,23 +167,25 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags)
 {
 	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct sysfs_inode_attrs *attrs;
 	void *secdata;
 	int error;
 	u32 secdata_len = 0;
 
-	if (!sd)
-		return -EINVAL;
+	attrs = sysfs_inode_attrs(sd);
+	if (!attrs)
+		return -ENOMEM;
 
 	if (!strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN)) {
 		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
 		error = security_inode_setsecurity(dentry->d_inode, suffix,
 						value, size, flags);
 		if (error)
-			goto out;
+			return error;
 		error = security_inode_getsecctx(dentry->d_inode,
 						&secdata, &secdata_len);
 		if (error)
-			goto out;
+			return error;
 
 		mutex_lock(&sysfs_mutex);
 		error = sysfs_sd_setsecdata(sd, &secdata, &secdata_len);
@@ -186,10 +193,50 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 
 		if (secdata)
 			security_release_secctx(secdata, secdata_len);
-	} else
-		return -EINVAL;
-out:
-	return error;
+		return error;
+	} else if (!strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN)) {
+		return simple_xattr_set(&attrs->xattrs, name, value, size,
+					flags);
+	}
+
+	return -EINVAL;
+}
+
+int sysfs_removexattr(struct dentry *dentry, const char *name)
+{
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct sysfs_inode_attrs *attrs;
+
+	attrs = sysfs_inode_attrs(sd);
+	if (!attrs)
+		return -ENOMEM;
+
+	return simple_xattr_remove(&attrs->xattrs, name);
+}
+
+ssize_t sysfs_getxattr(struct dentry *dentry, const char *name, void *buf,
+		       size_t size)
+{
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct sysfs_inode_attrs *attrs;
+
+	attrs = sysfs_inode_attrs(sd);
+	if (!attrs)
+		return -ENOMEM;
+
+	return simple_xattr_get(&attrs->xattrs, name, buf, size);
+}
+
+ssize_t sysfs_listxattr(struct dentry *dentry, char *buf, size_t size)
+{
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct sysfs_inode_attrs *attrs;
+
+	attrs = sysfs_inode_attrs(sd);
+	if (!attrs)
+		return -ENOMEM;
+
+	return simple_xattr_list(&attrs->xattrs, buf, size);
 }
 
 static inline void set_default_inode_attr(struct inode *inode, umode_t mode)
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index ff08b45..007d22d 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -14,6 +14,7 @@
 #include <linux/lockdep.h>
 #include <linux/fs.h>
 #include <linux/mutex.h>
+#include <linux/xattr.h>
 
 #include <linux/kernfs.h>
 
@@ -21,6 +22,8 @@ struct sysfs_inode_attrs {
 	struct iattr		ia_iattr;
 	void			*ia_secdata;
 	u32			ia_secdata_len;
+
+	struct simple_xattrs	xattrs;
 };
 
 #define SD_DEACTIVATED_BIAS		INT_MIN
@@ -90,6 +93,10 @@ int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
 int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		   size_t size, int flags);
+int sysfs_removexattr(struct dentry *dentry, const char *name);
+ssize_t sysfs_getxattr(struct dentry *dentry, const char *name, void *buf,
+		       size_t size);
+ssize_t sysfs_listxattr(struct dentry *dentry, char *buf, size_t size);
 void sysfs_inode_init(void);
 
 /*
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index b65cd22..4d46d8e 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -139,6 +139,9 @@ static void sysfs_put_link(struct dentry *dentry, struct nameidata *nd,
 
 const struct inode_operations sysfs_symlink_inode_operations = {
 	.setxattr	= sysfs_setxattr,
+	.removexattr	= sysfs_removexattr,
+	.getxattr	= sysfs_getxattr,
+	.listxattr	= sysfs_listxattr,
 	.readlink	= generic_readlink,
 	.follow_link	= sysfs_follow_link,
 	.put_link	= sysfs_put_link,
-- 
1.8.3.1

