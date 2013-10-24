Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3JXP5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:57:31 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:32870 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab3JXPt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:49:58 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/34] sysfs, kernfs: introduce kernfs_setattr()
Date: Thu, 24 Oct 2013 11:49:17 -0400
Message-Id: <1382629780-10006-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382629780-10006-1-git-send-email-tj@kernel.org>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kernfs setattr interface - kernfs_setattr().

sysfs_sd_setattr() is renamed to __kernfs_setattr() and
kernfs_setattr() is a simple wrapper around it with sysfs_mutex
locking.  sysfs_chmod_file() is updated to get an explicit ref on
kobj->sd and then invoke kernfs_setattr() so that it doesn't have to
use internal interface.

This patch doesn't introduce any behavior differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c        | 13 +++++--------
 fs/sysfs/inode.c       | 21 +++++++++++++++++++--
 fs/sysfs/sysfs.h       |  1 -
 include/linux/kernfs.h |  8 ++++++++
 4 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 6e9c92e..d4eeb50 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -923,19 +923,16 @@ int sysfs_chmod_file(struct kobject *kobj, const struct attribute *attr,
 	struct iattr newattrs;
 	int rc;
 
-	mutex_lock(&sysfs_mutex);
-
-	rc = -ENOENT;
-	sd = sysfs_find_dirent(kobj->sd, attr->name, NULL);
+	sd = sysfs_get_dirent(kobj->sd, attr->name);
 	if (!sd)
-		goto out;
+		return -ENOENT;
 
 	newattrs.ia_mode = (mode & S_IALLUGO) | (sd->s_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE;
-	rc = sysfs_sd_setattr(sd, &newattrs);
 
- out:
-	mutex_unlock(&sysfs_mutex);
+	rc = kernfs_setattr(sd, &newattrs);
+
+	sysfs_put(sd);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(sysfs_chmod_file);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 1750f79..5f7e2af 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -67,7 +67,7 @@ static struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
 	return attrs;
 }
 
-int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr)
+static int __kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr)
 {
 	struct sysfs_inode_attrs *sd_attrs;
 	struct iattr *iattrs;
@@ -102,6 +102,23 @@ int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr)
 	return 0;
 }
 
+/**
+ * kernfs_setattr - set iattr on a node
+ * @sd: target node
+ * @iattr: iattr to set
+ *
+ * Returns 0 on success, -errno on failure.
+ */
+int kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr)
+{
+	int ret;
+
+	mutex_lock(&sysfs_mutex);
+	ret = __kernfs_setattr(sd, iattr);
+	mutex_unlock(&sysfs_mutex);
+	return ret;
+}
+
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr)
 {
 	struct inode *inode = dentry->d_inode;
@@ -116,7 +133,7 @@ int sysfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	if (error)
 		goto out;
 
-	error = sysfs_sd_setattr(sd, iattr);
+	error = __kernfs_setattr(sd, iattr);
 	if (error)
 		goto out;
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 3d48445..d49399d 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -207,7 +207,6 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
  */
 struct inode *sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd);
 void sysfs_evict_inode(struct inode *inode);
-int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr);
 int sysfs_permission(struct inode *inode, int mask);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 9ad3fe5..7585d9d 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -9,6 +9,9 @@
 
 #include <linux/kernel.h>
 
+struct file;
+struct iattr;
+
 struct sysfs_dirent;
 
 #ifdef CONFIG_SYSFS
@@ -21,6 +24,7 @@ int kernfs_remove_by_name_ns(struct sysfs_dirent *parent, const char *name,
 			     const void *ns);
 int kernfs_rename_ns(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
 		     const char *new_name, const void *new_ns);
+int kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr);
 
 #else	/* CONFIG_SYSFS */
 
@@ -40,6 +44,10 @@ static inline int kernfs_rename_ns(struct sysfs_dirent *sd,
 				   const char *new_name, const void *new_ns)
 { return 0; }
 
+static inline int kernfs_setattr(struct sysfs_dirent *sd,
+				 const struct iattr *iattr)
+{ return 0; }
+
 #endif	/* CONFIG_SYSFS */
 
 static inline int kernfs_remove_by_name(struct sysfs_dirent *parent,
-- 
1.8.3.1

