Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3KCJxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:53:44 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:61492 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3KCJx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:53:26 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/39] sysfs, kernfs: introduce kernfs_remove[_by_name[_ns]]()
Date: Sun,  3 Nov 2013 04:52:42 -0500
Message-Id: <1383472398-17812-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383472398-17812-1-git-send-email-tj@kernel.org>
References: <1383472398-17812-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kernfs removal interfaces - kernfs_remove() and
kernfs_remove_by_name[_ns]().

These are just renames of sysfs_remove() and sysfs_hash_and_remove().
No functional changes.

v2: Dummy kernfs_remove_by_name_ns() for !CONFIG_SYSFS updated to
    return -ENOSYS instead of 0.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c         | 20 ++++++++++----------
 fs/sysfs/file.c        |  6 +++---
 fs/sysfs/group.c       | 15 +++++++--------
 fs/sysfs/symlink.c     |  4 ++--
 fs/sysfs/sysfs.h       |  3 ---
 include/linux/kernfs.h | 24 ++++++++++++++++++++++++
 6 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f192c41..3fcaf08 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -824,8 +824,8 @@ static struct sysfs_dirent *sysfs_next_descendant_post(struct sysfs_dirent *pos,
 	return pos->s_parent;
 }
 
-static void __sysfs_remove(struct sysfs_addrm_cxt *acxt,
-			   struct sysfs_dirent *sd)
+static void __kernfs_remove(struct sysfs_addrm_cxt *acxt,
+			    struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent *pos, *next;
 
@@ -844,22 +844,22 @@ static void __sysfs_remove(struct sysfs_addrm_cxt *acxt,
 }
 
 /**
- * sysfs_remove - remove a sysfs_dirent recursively
+ * kernfs_remove - remove a sysfs_dirent recursively
  * @sd: the sysfs_dirent to remove
  *
  * Remove @sd along with all its subdirectories and files.
  */
-void sysfs_remove(struct sysfs_dirent *sd)
+void kernfs_remove(struct sysfs_dirent *sd)
 {
 	struct sysfs_addrm_cxt acxt;
 
 	sysfs_addrm_start(&acxt);
-	__sysfs_remove(&acxt, sd);
+	__kernfs_remove(&acxt, sd);
 	sysfs_addrm_finish(&acxt);
 }
 
 /**
- * sysfs_hash_and_remove - find a sysfs_dirent by name and remove it
+ * kernfs_remove_by_name_ns - find a sysfs_dirent by name and remove it
  * @dir_sd: parent of the target
  * @name: name of the sysfs_dirent to remove
  * @ns: namespace tag of the sysfs_dirent to remove
@@ -867,8 +867,8 @@ void sysfs_remove(struct sysfs_dirent *sd)
  * Look for the sysfs_dirent with @name and @ns under @dir_sd and remove
  * it.  Returns 0 on success, -ENOENT if such entry doesn't exist.
  */
-int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name,
-			  const void *ns)
+int kernfs_remove_by_name_ns(struct sysfs_dirent *dir_sd, const char *name,
+			     const void *ns)
 {
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
@@ -883,7 +883,7 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name,
 
 	sd = sysfs_find_dirent(dir_sd, name, ns);
 	if (sd)
-		__sysfs_remove(&acxt, sd);
+		__kernfs_remove(&acxt, sd);
 
 	sysfs_addrm_finish(&acxt);
 
@@ -923,7 +923,7 @@ void sysfs_remove_dir(struct kobject *kobj)
 
 	if (sd) {
 		WARN_ON_ONCE(sysfs_type(sd) != SYSFS_DIR);
-		sysfs_remove(sd);
+		kernfs_remove(sd);
 	}
 }
 
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 79b5da2..5664410 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -952,7 +952,7 @@ void sysfs_remove_file_ns(struct kobject *kobj, const struct attribute *attr,
 {
 	struct sysfs_dirent *dir_sd = kobj->sd;
 
-	sysfs_hash_and_remove(dir_sd, attr->name, ns);
+	kernfs_remove_by_name_ns(dir_sd, attr->name, ns);
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_file_ns);
 
@@ -980,7 +980,7 @@ void sysfs_remove_file_from_group(struct kobject *kobj,
 	else
 		dir_sd = sysfs_get(kobj->sd);
 	if (dir_sd) {
-		sysfs_hash_and_remove(dir_sd, attr->name, NULL);
+		kernfs_remove_by_name(dir_sd, attr->name);
 		sysfs_put(dir_sd);
 	}
 }
@@ -1008,7 +1008,7 @@ EXPORT_SYMBOL_GPL(sysfs_create_bin_file);
 void sysfs_remove_bin_file(struct kobject *kobj,
 			   const struct bin_attribute *attr)
 {
-	sysfs_hash_and_remove(kobj->sd, attr->attr.name, NULL);
+	kernfs_remove_by_name(kobj->sd, attr->attr.name);
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_bin_file);
 
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 1898a10..4bd9973 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -26,7 +26,7 @@ static void remove_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 
 	if (grp->attrs)
 		for (attr = grp->attrs; *attr; attr++)
-			sysfs_hash_and_remove(dir_sd, (*attr)->name, NULL);
+			kernfs_remove_by_name(dir_sd, (*attr)->name);
 	if (grp->bin_attrs)
 		for (bin_attr = grp->bin_attrs; *bin_attr; bin_attr++)
 			sysfs_remove_bin_file(kobj, *bin_attr);
@@ -49,8 +49,7 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 			 * re-adding (if required) the file.
 			 */
 			if (update)
-				sysfs_hash_and_remove(dir_sd, (*attr)->name,
-						      NULL);
+				kernfs_remove_by_name(dir_sd, (*attr)->name);
 			if (grp->is_visible) {
 				mode = grp->is_visible(kobj, *attr, i);
 				if (!mode)
@@ -111,7 +110,7 @@ static int internal_create_group(struct kobject *kobj, int update,
 	error = create_files(sd, kobj, grp, update);
 	if (error) {
 		if (grp->name)
-			sysfs_remove(sd);
+			kernfs_remove(sd);
 	}
 	sysfs_put(sd);
 	return error;
@@ -219,7 +218,7 @@ void sysfs_remove_group(struct kobject *kobj,
 
 	remove_files(sd, kobj, grp);
 	if (grp->name)
-		sysfs_remove(sd);
+		kernfs_remove(sd);
 
 	sysfs_put(sd);
 }
@@ -270,7 +269,7 @@ int sysfs_merge_group(struct kobject *kobj,
 		error = sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
 	if (error) {
 		while (--i >= 0)
-			sysfs_hash_and_remove(dir_sd, (*--attr)->name, NULL);
+			kernfs_remove_by_name(dir_sd, (*--attr)->name);
 	}
 	sysfs_put(dir_sd);
 
@@ -292,7 +291,7 @@ void sysfs_unmerge_group(struct kobject *kobj,
 	dir_sd = sysfs_get_dirent(kobj->sd, grp->name);
 	if (dir_sd) {
 		for (attr = grp->attrs; *attr; ++attr)
-			sysfs_hash_and_remove(dir_sd, (*attr)->name, NULL);
+			kernfs_remove_by_name(dir_sd, (*attr)->name);
 		sysfs_put(dir_sd);
 	}
 }
@@ -335,7 +334,7 @@ void sysfs_remove_link_from_group(struct kobject *kobj, const char *group_name,
 
 	dir_sd = sysfs_get_dirent(kobj->sd, group_name);
 	if (dir_sd) {
-		sysfs_hash_and_remove(dir_sd, link_name, NULL);
+		kernfs_remove_by_name(dir_sd, link_name);
 		sysfs_put(dir_sd);
 	}
 }
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 1a23681..a57a43a 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -152,7 +152,7 @@ void sysfs_delete_link(struct kobject *kobj, struct kobject *targ,
 	if (targ->sd)
 		ns = targ->sd->s_ns;
 	spin_unlock(&sysfs_symlink_target_lock);
-	sysfs_hash_and_remove(kobj->sd, name, ns);
+	kernfs_remove_by_name_ns(kobj->sd, name, ns);
 }
 
 /**
@@ -169,7 +169,7 @@ void sysfs_remove_link(struct kobject *kobj, const char *name)
 	else
 		parent_sd = kobj->sd;
 
-	sysfs_hash_and_remove(parent_sd, name, NULL);
+	kernfs_remove_by_name(parent_sd, name);
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_link);
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index e3aea92..3b796e2 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -173,9 +173,6 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		    struct sysfs_dirent *parent_sd);
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		  struct sysfs_dirent *parent_sd);
-void sysfs_remove(struct sysfs_dirent *sd);
-int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name,
-			  const void *ns);
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
 
 struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 254b9e8..83e151a 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -7,6 +7,30 @@
 #ifndef __LINUX_KERNFS_H
 #define __LINUX_KERNFS_H
 
+#include <linux/kernel.h>
+
 struct sysfs_dirent;
 
+#ifdef CONFIG_SYSFS
+
+void kernfs_remove(struct sysfs_dirent *sd);
+int kernfs_remove_by_name_ns(struct sysfs_dirent *parent, const char *name,
+			     const void *ns);
+
+#else	/* CONFIG_SYSFS */
+
+static inline void kernfs_remove(struct sysfs_dirent *sd) { }
+
+static inline int kernfs_remove_by_name_ns(struct sysfs_dirent *parent,
+					   const char *name, const void *ns)
+{ return -ENOSYS; }
+
+#endif	/* CONFIG_SYSFS */
+
+static inline int kernfs_remove_by_name(struct sysfs_dirent *parent,
+					const char *name)
+{
+	return kernfs_remove_by_name_ns(parent, name, NULL);
+}
+
 #endif	/* __LINUX_KERNFS_H */
-- 
1.8.3.1

