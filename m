Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab3K1TzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:55:08 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:43821 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3K1Ty5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:54:57 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/34] sysfs, kernfs: introduce kernfs_create_dir[_ns]()
Date: Thu, 28 Nov 2013 14:54:15 -0500
Message-Id: <1385668487-10181-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kernfs interface to manipulate a directory which takes and
returns sysfs_dirents.

create_dir() is renamed to kernfs_create_dir_ns() and its argumantes
and return value are updated.  create_dir() usages are replaced with
kernfs_create_dir_ns() and sysfs_create_subdir() usages are replaced
with kernfs_create_dir().  Dup warnings are handled explicitly by
sysfs users of the kernfs interface.

sysfs_enable_ns() is renamed to kernfs_enable_ns().

This patch doesn't introduce any behavior changes.

v2: Dummy implementation for !CONFIG_SYSFS updated to return -ENOSYS.

v3: kernfs_enable_ns() added.

v4: Refreshed on top of "sysfs: drop kobj_ns_type handling, take #2"
    so that this patch removes sysfs_enable_ns().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c         | 54 ++++++++++++++++++++++++++++----------------------
 fs/sysfs/group.c       |  9 ++++++---
 fs/sysfs/sysfs.h       |  3 ---
 include/linux/kernfs.h | 17 ++++++++++++++++
 include/linux/sysfs.h  |  6 ------
 lib/kobject.c          |  2 +-
 6 files changed, 54 insertions(+), 37 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index aeb08bd..cfbf409 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -666,9 +666,18 @@ struct sysfs_dirent *sysfs_get_dirent_ns(struct sysfs_dirent *parent_sd,
 }
 EXPORT_SYMBOL_GPL(sysfs_get_dirent_ns);
 
-static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
-		      const char *name, const void *ns,
-		      struct sysfs_dirent **p_sd)
+/**
+ * kernfs_create_dir_ns - create a directory
+ * @parent: parent in which to create a new directory
+ * @name: name of the new directory
+ * @priv: opaque data associated with the new directory
+ * @ns: optional namespace tag of the directory
+ *
+ * Returns the created node on success, ERR_PTR() value on failure.
+ */
+struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
+					  const char *name, void *priv,
+					  const void *ns)
 {
 	umode_t mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
 	struct sysfs_addrm_cxt acxt;
@@ -678,28 +687,21 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 	/* allocate */
 	sd = sysfs_new_dirent(name, mode, SYSFS_DIR);
 	if (!sd)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	sd->s_ns = ns;
-	sd->priv = kobj;
+	sd->priv = priv;
 
 	/* link in */
 	sysfs_addrm_start(&acxt);
-	rc = sysfs_add_one(&acxt, sd, parent_sd);
+	rc = __sysfs_add_one(&acxt, sd, parent);
 	sysfs_addrm_finish(&acxt);
 
-	if (rc == 0)
-		*p_sd = sd;
-	else
-		sysfs_put(sd);
+	if (!rc)
+		return sd;
 
-	return rc;
-}
-
-int sysfs_create_subdir(struct kobject *kobj, const char *name,
-			struct sysfs_dirent **p_sd)
-{
-	return create_dir(kobj, kobj->sd, name, NULL, p_sd);
+	sysfs_put(sd);
+	return ERR_PTR(rc);
 }
 
 /**
@@ -710,7 +712,6 @@ int sysfs_create_subdir(struct kobject *kobj, const char *name,
 int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
 {
 	struct sysfs_dirent *parent_sd, *sd;
-	int error = 0;
 
 	BUG_ON(!kobj);
 
@@ -722,10 +723,15 @@ int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
 	if (!parent_sd)
 		return -ENOENT;
 
-	error = create_dir(kobj, parent_sd, kobject_name(kobj), ns, &sd);
-	if (!error)
-		kobj->sd = sd;
-	return error;
+	sd = kernfs_create_dir_ns(parent_sd, kobject_name(kobj), kobj, ns);
+	if (IS_ERR(sd)) {
+		if (PTR_ERR(sd) == -EEXIST)
+			sysfs_warn_dup(parent_sd, kobject_name(kobj));
+		return PTR_ERR(sd);
+	}
+
+	kobj->sd = sd;
+	return 0;
 }
 
 static struct dentry *sysfs_lookup(struct inode *dir, struct dentry *dentry,
@@ -1005,14 +1011,14 @@ int sysfs_move_dir_ns(struct kobject *kobj, struct kobject *new_parent_kobj,
 }
 
 /**
- * sysfs_enable_ns - enable namespace under a directory
+ * kernfs_enable_ns - enable namespace under a directory
  * @sd: directory of interest, should be empty
  *
  * This is to be called right after @sd is created to enable namespace
  * under it.  All children of @sd must have non-NULL namespace tags and
  * only the ones which match the super_block's tag will be visible.
  */
-void sysfs_enable_ns(struct sysfs_dirent *sd)
+void kernfs_enable_ns(struct sysfs_dirent *sd)
 {
 	WARN_ON_ONCE(sysfs_type(sd) != SYSFS_DIR);
 	WARN_ON_ONCE(!RB_EMPTY_ROOT(&sd->s_dir.children));
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 4bd9973..065689d 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -101,9 +101,12 @@ static int internal_create_group(struct kobject *kobj, int update,
 		return -EINVAL;
 	}
 	if (grp->name) {
-		error = sysfs_create_subdir(kobj, grp->name, &sd);
-		if (error)
-			return error;
+		sd = kernfs_create_dir(kobj->sd, grp->name, kobj);
+		if (IS_ERR(sd)) {
+			if (PTR_ERR(sd) == -EEXIST)
+				sysfs_warn_dup(kobj->sd, grp->name);
+			return PTR_ERR(sd);
+		}
 	} else
 		sd = kobj->sd;
 	sysfs_get(sd);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index a6f3fa3..9ac234e 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -179,9 +179,6 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type);
 
 void release_sysfs_dirent(struct sysfs_dirent *sd);
 
-int sysfs_create_subdir(struct kobject *kobj, const char *name,
-			struct sysfs_dirent **p_sd);
-
 static inline struct sysfs_dirent *__sysfs_get(struct sysfs_dirent *sd)
 {
 	if (sd) {
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 8cb6738..e8b73d4 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -17,6 +17,9 @@ struct sysfs_dirent;
 
 #ifdef CONFIG_SYSFS
 
+struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
+					  const char *name, void *priv,
+					  const void *ns);
 struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
 					const char *name,
 					struct sysfs_dirent *target);
@@ -25,11 +28,17 @@ int kernfs_remove_by_name_ns(struct sysfs_dirent *parent, const char *name,
 			     const void *ns);
 int kernfs_rename_ns(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
 		     const char *new_name, const void *new_ns);
+void kernfs_enable_ns(struct sysfs_dirent *sd);
 int kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr);
 
 #else	/* CONFIG_SYSFS */
 
 static inline struct sysfs_dirent *
+kernfs_create_dir_ns(struct sysfs_dirent *parent, const char *name, void *priv,
+		     const void *ns)
+{ return ERR_PTR(-ENOSYS); }
+
+static inline struct sysfs_dirent *
 kernfs_create_link(struct sysfs_dirent *parent, const char *name,
 		   struct sysfs_dirent *target)
 { return ERR_PTR(-ENOSYS); }
@@ -45,12 +54,20 @@ static inline int kernfs_rename_ns(struct sysfs_dirent *sd,
 				   const char *new_name, const void *new_ns)
 { return -ENOSYS; }
 
+static inline void kernfs_enable_ns(struct sysfs_dirent *sd) { }
+
 static inline int kernfs_setattr(struct sysfs_dirent *sd,
 				 const struct iattr *iattr)
 { return -ENOSYS; }
 
 #endif	/* CONFIG_SYSFS */
 
+static inline struct sysfs_dirent *
+kernfs_create_dir(struct sysfs_dirent *parent, const char *name, void *priv)
+{
+	return kernfs_create_dir_ns(parent, name, priv, NULL);
+}
+
 static inline int kernfs_remove_by_name(struct sysfs_dirent *parent,
 					const char *name)
 {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index e17381a..2bc735d 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -219,8 +219,6 @@ int sysfs_rename_link_ns(struct kobject *kobj, struct kobject *target,
 void sysfs_delete_link(struct kobject *dir, struct kobject *targ,
 			const char *name);
 
-void sysfs_enable_ns(struct sysfs_dirent *sd);
-
 int __must_check sysfs_create_group(struct kobject *kobj,
 				    const struct attribute_group *grp);
 int __must_check sysfs_create_groups(struct kobject *kobj,
@@ -354,10 +352,6 @@ static inline void sysfs_delete_link(struct kobject *k, struct kobject *t,
 {
 }
 
-static inline void sysfs_enable_ns(struct sysfs_dirent *sd)
-{
-}
-
 static inline int sysfs_create_group(struct kobject *kobj,
 				     const struct attribute_group *grp)
 {
diff --git a/lib/kobject.c b/lib/kobject.c
index 16e9335..b8d848f 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -94,7 +94,7 @@ static int create_dir(struct kobject *kobj)
 		BUG_ON(ops->type >= KOBJ_NS_TYPES);
 		BUG_ON(!kobj_ns_type_registered(ops->type));
 
-		sysfs_enable_ns(kobj->sd);
+		kernfs_enable_ns(kobj->sd);
 	}
 
 	return 0;
-- 
1.8.4.2

