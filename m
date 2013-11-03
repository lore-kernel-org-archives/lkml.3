Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3KCJxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:53:52 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:37454 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3KCJxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:53:33 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/39] sysfs, kernfs: introduce kernfs_create_dir[_ns]()
Date: Sun,  3 Nov 2013 04:52:47 -0500
Message-Id: <1383472398-17812-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383472398-17812-1-git-send-email-tj@kernel.org>
References: <1383472398-17812-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kernfs interface to create a directory which takes and
returns sysfs_dirents.

create_dir() is renamed to kernfs_create_dir_ns() and its argumantes
and return value are updated.  create_dir() usages are replaced with
kernfs_create_dir_ns() and sysfs_create_subdir() usages are replaced
with kernfs_create_dir().  Dup warnings are handled explicitly by
sysfs users of the kernfs interface.

This patch doesn't introduce any behavior changes.

v2: Dummy implementation for !CONFIG_SYSFS updated to return -ENOSYS.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c         | 50 ++++++++++++++++++++++++++++----------------------
 fs/sysfs/group.c       |  9 ++++++---
 fs/sysfs/sysfs.h       |  3 ---
 include/linux/kernfs.h | 14 ++++++++++++++
 4 files changed, 48 insertions(+), 28 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 31f9311..27822a1 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -661,9 +661,18 @@ struct sysfs_dirent *sysfs_get_dirent_ns(struct sysfs_dirent *parent_sd,
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
@@ -673,28 +682,21 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
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
@@ -705,7 +707,6 @@ int sysfs_create_subdir(struct kobject *kobj, const char *name,
 int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
 {
 	struct sysfs_dirent *parent_sd, *sd;
-	int error = 0;
 
 	BUG_ON(!kobj);
 
@@ -717,10 +718,15 @@ int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
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
index da65790..dc3ac27 100644
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
index 8cb6738..345773f 100644
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
@@ -30,6 +33,11 @@ int kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr);
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
@@ -51,6 +59,12 @@ static inline int kernfs_setattr(struct sysfs_dirent *sd,
 
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
-- 
1.8.3.1

