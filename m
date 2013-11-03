Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3KCJxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:53:47 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46642 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3KCJx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:53:29 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/39] sysfs, kernfs: introduce kernfs_rename[_ns]()
Date: Sun,  3 Nov 2013 04:52:44 -0500
Message-Id: <1383472398-17812-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383472398-17812-1-git-send-email-tj@kernel.org>
References: <1383472398-17812-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kernfs rename interface, krenfs_rename[_ns]().

This is just rename of sysfs_rename().  No functional changes.
Function comment is added to kernfs_rename_ns() and @new_parent_sd is
renamed to @new_parent for consistency with other kernfs interfaces.

v2: Dummy implementation for !CONFIG_SYSFS updated to return -ENOSYS.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c         | 23 +++++++++++++++--------
 fs/sysfs/symlink.c     |  2 +-
 fs/sysfs/sysfs.h       |  3 ---
 include/linux/kernfs.h |  7 +++++++
 4 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 3fcaf08..3eb86b3 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -927,20 +927,27 @@ void sysfs_remove_dir(struct kobject *kobj)
 	}
 }
 
-int sysfs_rename(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent_sd,
-		 const char *new_name, const void *new_ns)
+/**
+ * kernfs_rename_ns - move and rename a kernfs_node
+ * @sd: target node
+ * @new_parent: new parent to put @sd under
+ * @new_name: new name
+ * @new_ns: new namespace tag
+ */
+int kernfs_rename_ns(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
+		     const char *new_name, const void *new_ns)
 {
 	int error;
 
 	mutex_lock(&sysfs_mutex);
 
 	error = 0;
-	if ((sd->s_parent == new_parent_sd) && (sd->s_ns == new_ns) &&
+	if ((sd->s_parent == new_parent) && (sd->s_ns == new_ns) &&
 	    (strcmp(sd->s_name, new_name) == 0))
 		goto out;	/* nothing to rename */
 
 	error = -EEXIST;
-	if (sysfs_find_dirent(new_parent_sd, new_name, new_ns))
+	if (sysfs_find_dirent(new_parent, new_name, new_ns))
 		goto out;
 
 	/* rename sysfs_dirent */
@@ -958,11 +965,11 @@ int sysfs_rename(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent_sd,
 	 * Move to the appropriate place in the appropriate directories rbtree.
 	 */
 	sysfs_unlink_sibling(sd);
-	sysfs_get(new_parent_sd);
+	sysfs_get(new_parent);
 	sysfs_put(sd->s_parent);
 	sd->s_ns = new_ns;
 	sd->s_hash = sysfs_name_hash(sd->s_name, sd->s_ns);
-	sd->s_parent = new_parent_sd;
+	sd->s_parent = new_parent;
 	sysfs_link_sibling(sd);
 
 	error = 0;
@@ -976,7 +983,7 @@ int sysfs_rename_dir_ns(struct kobject *kobj, const char *new_name,
 {
 	struct sysfs_dirent *parent_sd = kobj->sd->s_parent;
 
-	return sysfs_rename(kobj->sd, parent_sd, new_name, new_ns);
+	return kernfs_rename_ns(kobj->sd, parent_sd, new_name, new_ns);
 }
 
 int sysfs_move_dir_ns(struct kobject *kobj, struct kobject *new_parent_kobj,
@@ -989,7 +996,7 @@ int sysfs_move_dir_ns(struct kobject *kobj, struct kobject *new_parent_kobj,
 	new_parent_sd = new_parent_kobj && new_parent_kobj->sd ?
 		new_parent_kobj->sd : &sysfs_root;
 
-	return sysfs_rename(sd, new_parent_sd, sd->s_name, new_ns);
+	return kernfs_rename_ns(sd, new_parent_sd, sd->s_name, new_ns);
 }
 
 /* Relationship between s_mode and the DT_xxx types */
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 0f46bd3..f9d6056 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -225,7 +225,7 @@ int sysfs_rename_link_ns(struct kobject *kobj, struct kobject *targ,
 	if (sd->s_symlink.target_sd->s_dir.kobj != targ)
 		goto out;
 
-	result = sysfs_rename(sd, parent_sd, new, new_ns);
+	result = kernfs_rename_ns(sd, parent_sd, new, new_ns);
 
 out:
 	sysfs_put(sd);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 3b796e2..35561a8 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -185,9 +185,6 @@ void release_sysfs_dirent(struct sysfs_dirent *sd);
 int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			struct sysfs_dirent **p_sd);
 
-int sysfs_rename(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent_sd,
-		 const char *new_name, const void *new_ns);
-
 static inline struct sysfs_dirent *__sysfs_get(struct sysfs_dirent *sd)
 {
 	if (sd) {
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index fe6290d..803d960 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -20,6 +20,8 @@ struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
 void kernfs_remove(struct sysfs_dirent *sd);
 int kernfs_remove_by_name_ns(struct sysfs_dirent *parent, const char *name,
 			     const void *ns);
+int kernfs_rename_ns(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
+		     const char *new_name, const void *new_ns);
 
 #else	/* CONFIG_SYSFS */
 
@@ -34,6 +36,11 @@ static inline int kernfs_remove_by_name_ns(struct sysfs_dirent *parent,
 					   const char *name, const void *ns)
 { return -ENOSYS; }
 
+static inline int kernfs_rename_ns(struct sysfs_dirent *sd,
+				   struct sysfs_dirent *new_parent,
+				   const char *new_name, const void *new_ns)
+{ return -ENOSYS; }
+
 #endif	/* CONFIG_SYSFS */
 
 static inline int kernfs_remove_by_name(struct sysfs_dirent *parent,
-- 
1.8.3.1

