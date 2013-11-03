Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3KCJ5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:57:22 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:40849 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3KCJx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:53:59 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 28/39] sysfs, kernfs: move symlink core code to fs/kernfs/symlink.c
Date: Sun,  3 Nov 2013 04:53:07 -0500
Message-Id: <1383472398-17812-29-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383472398-17812-1-git-send-email-tj@kernel.org>
References: <1383472398-17812-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move core symlink code to fs/kernfs/symlink.c.  fs/sysfs/symlink.c now
only contains sysfs wrappers around kernfs interfaces.  The respective
declarations in fs/sysfs/sysfs.h are moved to
fs/kernfs/kernfs-internal.h.

This is pure relocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/kernfs-internal.h |   5 ++
 fs/kernfs/symlink.c         | 138 ++++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/symlink.c          | 136 -------------------------------------------
 fs/sysfs/sysfs.h            |   1 -
 4 files changed, 143 insertions(+), 137 deletions(-)

diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 1046624..c711072 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -149,4 +149,9 @@ extern const struct file_operations kernfs_file_operations;
 
 void sysfs_unmap_bin_file(struct sysfs_dirent *sd);
 
+/*
+ * symlink.c
+ */
+extern const struct inode_operations sysfs_symlink_inode_operations;
+
 #endif	/* __KERNFS_INTERNAL_H */
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index 2578715..00e4fdb 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -7,3 +7,141 @@
  *
  * This file is released under the GPLv2.
  */
+
+#include <linux/fs.h>
+#include <linux/gfp.h>
+#include <linux/namei.h>
+
+#include "kernfs-internal.h"
+
+/**
+ * kernfs_create_link - create a symlink
+ * @parent: directory to create the symlink in
+ * @name: name of the symlink
+ * @target: target node for the symlink to point to
+ *
+ * Returns the created node on success, ERR_PTR() value on error.
+ */
+struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
+					const char *name,
+					struct sysfs_dirent *target)
+{
+	struct sysfs_dirent *sd;
+	struct sysfs_addrm_cxt acxt;
+	int error;
+
+	sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
+	if (!sd)
+		return ERR_PTR(-ENOMEM);
+
+	sd->s_ns = target->s_ns;
+	sd->s_symlink.target_sd = target;
+	kernfs_get(target);	/* ref owned by symlink */
+
+	sysfs_addrm_start(&acxt);
+	error = sysfs_add_one(&acxt, sd, parent);
+	sysfs_addrm_finish(&acxt);
+
+	if (!error)
+		return sd;
+
+	kernfs_put(sd);
+	return ERR_PTR(error);
+}
+
+static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
+				 struct sysfs_dirent *target_sd, char *path)
+{
+	struct sysfs_dirent *base, *sd;
+	char *s = path;
+	int len = 0;
+
+	/* go up to the root, stop at the base */
+	base = parent_sd;
+	while (base->s_parent) {
+		sd = target_sd->s_parent;
+		while (sd->s_parent && base != sd)
+			sd = sd->s_parent;
+
+		if (base == sd)
+			break;
+
+		strcpy(s, "../");
+		s += 3;
+		base = base->s_parent;
+	}
+
+	/* determine end of target string for reverse fillup */
+	sd = target_sd;
+	while (sd->s_parent && sd != base) {
+		len += strlen(sd->s_name) + 1;
+		sd = sd->s_parent;
+	}
+
+	/* check limits */
+	if (len < 2)
+		return -EINVAL;
+	len--;
+	if ((s - path) + len > PATH_MAX)
+		return -ENAMETOOLONG;
+
+	/* reverse fillup of target string from target to base */
+	sd = target_sd;
+	while (sd->s_parent && sd != base) {
+		int slen = strlen(sd->s_name);
+
+		len -= slen;
+		strncpy(s + len, sd->s_name, slen);
+		if (len)
+			s[--len] = '/';
+
+		sd = sd->s_parent;
+	}
+
+	return 0;
+}
+
+static int sysfs_getlink(struct dentry *dentry, char *path)
+{
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct sysfs_dirent *parent_sd = sd->s_parent;
+	struct sysfs_dirent *target_sd = sd->s_symlink.target_sd;
+	int error;
+
+	mutex_lock(&sysfs_mutex);
+	error = sysfs_get_target_path(parent_sd, target_sd, path);
+	mutex_unlock(&sysfs_mutex);
+
+	return error;
+}
+
+static void *sysfs_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	int error = -ENOMEM;
+	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	if (page) {
+		error = sysfs_getlink(dentry, (char *) page);
+		if (error < 0)
+			free_page((unsigned long)page);
+	}
+	nd_set_link(nd, error ? ERR_PTR(error) : (char *)page);
+	return NULL;
+}
+
+static void sysfs_put_link(struct dentry *dentry, struct nameidata *nd,
+			   void *cookie)
+{
+	char *page = nd_get_link(nd);
+	if (!IS_ERR(page))
+		free_page((unsigned long)page);
+}
+
+const struct inode_operations sysfs_symlink_inode_operations = {
+	.setxattr	= sysfs_setxattr,
+	.readlink	= generic_readlink,
+	.follow_link	= sysfs_follow_link,
+	.put_link	= sysfs_put_link,
+	.setattr	= sysfs_setattr,
+	.getattr	= sysfs_getattr,
+	.permission	= sysfs_permission,
+};
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 59a1a0a..1890394 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -11,52 +11,13 @@
  */
 
 #include <linux/fs.h>
-#include <linux/gfp.h>
-#include <linux/mount.h>
 #include <linux/module.h>
 #include <linux/kobject.h>
-#include <linux/namei.h>
 #include <linux/mutex.h>
 #include <linux/security.h>
 
 #include "sysfs.h"
 
-/**
- * kernfs_create_link - create a symlink
- * @parent: directory to create the symlink in
- * @name: name of the symlink
- * @target: target node for the symlink to point to
- *
- * Returns the created node on success, ERR_PTR() value on error.
- */
-struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
-					const char *name,
-					struct sysfs_dirent *target)
-{
-	struct sysfs_dirent *sd;
-	struct sysfs_addrm_cxt acxt;
-	int error;
-
-	sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
-	if (!sd)
-		return ERR_PTR(-ENOMEM);
-
-	sd->s_ns = target->s_ns;
-	sd->s_symlink.target_sd = target;
-	kernfs_get(target);	/* ref owned by symlink */
-
-	sysfs_addrm_start(&acxt);
-	error = sysfs_add_one(&acxt, sd, parent);
-	sysfs_addrm_finish(&acxt);
-
-	if (!error)
-		return sd;
-
-	kernfs_put(sd);
-	return ERR_PTR(error);
-}
-
-
 static int sysfs_do_create_link_sd(struct sysfs_dirent *parent_sd,
 				   struct kobject *target,
 				   const char *name, int warn)
@@ -234,100 +195,3 @@ out:
 	return result;
 }
 EXPORT_SYMBOL_GPL(sysfs_rename_link_ns);
-
-static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
-				 struct sysfs_dirent *target_sd, char *path)
-{
-	struct sysfs_dirent *base, *sd;
-	char *s = path;
-	int len = 0;
-
-	/* go up to the root, stop at the base */
-	base = parent_sd;
-	while (base->s_parent) {
-		sd = target_sd->s_parent;
-		while (sd->s_parent && base != sd)
-			sd = sd->s_parent;
-
-		if (base == sd)
-			break;
-
-		strcpy(s, "../");
-		s += 3;
-		base = base->s_parent;
-	}
-
-	/* determine end of target string for reverse fillup */
-	sd = target_sd;
-	while (sd->s_parent && sd != base) {
-		len += strlen(sd->s_name) + 1;
-		sd = sd->s_parent;
-	}
-
-	/* check limits */
-	if (len < 2)
-		return -EINVAL;
-	len--;
-	if ((s - path) + len > PATH_MAX)
-		return -ENAMETOOLONG;
-
-	/* reverse fillup of target string from target to base */
-	sd = target_sd;
-	while (sd->s_parent && sd != base) {
-		int slen = strlen(sd->s_name);
-
-		len -= slen;
-		strncpy(s + len, sd->s_name, slen);
-		if (len)
-			s[--len] = '/';
-
-		sd = sd->s_parent;
-	}
-
-	return 0;
-}
-
-static int sysfs_getlink(struct dentry *dentry, char *path)
-{
-	struct sysfs_dirent *sd = dentry->d_fsdata;
-	struct sysfs_dirent *parent_sd = sd->s_parent;
-	struct sysfs_dirent *target_sd = sd->s_symlink.target_sd;
-	int error;
-
-	mutex_lock(&sysfs_mutex);
-	error = sysfs_get_target_path(parent_sd, target_sd, path);
-	mutex_unlock(&sysfs_mutex);
-
-	return error;
-}
-
-static void *sysfs_follow_link(struct dentry *dentry, struct nameidata *nd)
-{
-	int error = -ENOMEM;
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
-	if (page) {
-		error = sysfs_getlink(dentry, (char *) page);
-		if (error < 0)
-			free_page((unsigned long)page);
-	}
-	nd_set_link(nd, error ? ERR_PTR(error) : (char *)page);
-	return NULL;
-}
-
-static void sysfs_put_link(struct dentry *dentry, struct nameidata *nd,
-			   void *cookie)
-{
-	char *page = nd_get_link(nd);
-	if (!IS_ERR(page))
-		free_page((unsigned long)page);
-}
-
-const struct inode_operations sysfs_symlink_inode_operations = {
-	.setxattr	= sysfs_setxattr,
-	.readlink	= generic_readlink,
-	.follow_link	= sysfs_follow_link,
-	.put_link	= sysfs_put_link,
-	.setattr	= sysfs_setattr,
-	.getattr	= sysfs_getattr,
-	.permission	= sysfs_permission,
-};
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 4b8b60d..6d0dcea 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -50,7 +50,6 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 /*
  * symlink.c
  */
-extern const struct inode_operations sysfs_symlink_inode_operations;
 int sysfs_create_link_sd(struct sysfs_dirent *sd, struct kobject *target,
 			 const char *name);
 
-- 
1.8.3.1

