Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab3KCKCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 05:02:00 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:55036 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab3KCJxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:53:44 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/39] sysfs, kernfs: introduce kernfs_create_file[_ns]()
Date: Sun,  3 Nov 2013 04:52:56 -0500
Message-Id: <1383472398-17812-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383472398-17812-1-git-send-email-tj@kernel.org>
References: <1383472398-17812-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kernfs interface to create a file which takes and returns
sysfs_dirents.

The actual file creation part is separated out from
sysfs_add_file_mode_ns() into kernfs_create_file_ns().  The former now
only decides the kernfs_ops to use and the file's size and invokes the
latter.

This patch doesn't introduce behavior changes.

v2: Dummy implementation for !CONFIG_SYSFS updated to return -ENOSYS.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c        | 53 +++++++++++++++++++++++++++++++++++++++-----------
 include/linux/kernfs.h | 18 +++++++++++++++++
 2 files changed, 60 insertions(+), 11 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 87f90ff..74d803f 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -895,14 +895,11 @@ static const struct kernfs_ops sysfs_bin_kfops_rw = {
 
 int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 			   const struct attribute *attr, bool is_bin,
-			   umode_t amode, const void *ns)
+			   umode_t mode, const void *ns)
 {
-	umode_t mode = (amode & S_IALLUGO) | S_IFREG;
 	const struct kernfs_ops *ops;
-	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 	loff_t size;
-	int rc;
 
 	if (!is_bin) {
 		struct kobject *kobj = dir_sd->priv;
@@ -939,14 +936,47 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 		size = battr->size;
 	}
 
-	sd = sysfs_new_dirent(attr->name, mode, SYSFS_KOBJ_ATTR);
+	sd = kernfs_create_file_ns(dir_sd, attr->name, mode, size,
+				   ops, (void *)attr, ns);
+	if (IS_ERR(sd)) {
+		if (PTR_ERR(sd) == -EEXIST)
+			sysfs_warn_dup(dir_sd, attr->name);
+		return PTR_ERR(sd);
+	}
+	return 0;
+}
+
+/**
+ * kernfs_create_file_ns - create a file
+ * @parent: directory to create the file in
+ * @name: name of the file
+ * @mode: mode of the file
+ * @size: size of the file
+ * @ops: kernfs operations for the file
+ * @priv: private data for the file
+ * @ns: optional namespace tag of the file
+ *
+ * Returns the created node on success, ERR_PTR() value on error.
+ */
+struct sysfs_dirent *kernfs_create_file_ns(struct sysfs_dirent *parent,
+					   const char *name,
+					   umode_t mode, loff_t size,
+					   const struct kernfs_ops *ops,
+					   void *priv, const void *ns)
+{
+	struct sysfs_addrm_cxt acxt;
+	struct sysfs_dirent *sd;
+	int rc;
+
+	sd = sysfs_new_dirent(name, (mode & S_IALLUGO) | S_IFREG,
+			      SYSFS_KOBJ_ATTR);
 	if (!sd)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	sd->s_attr.ops = ops;
 	sd->s_attr.size = size;
 	sd->s_ns = ns;
-	sd->priv = (void *)attr;
+	sd->priv = priv;
 	sysfs_dirent_init_lockdep(sd);
 
 	/*
@@ -960,13 +990,14 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 		sd->s_flags |= SYSFS_FLAG_HAS_MMAP;
 
 	sysfs_addrm_start(&acxt);
-	rc = sysfs_add_one(&acxt, sd, dir_sd);
+	rc = __sysfs_add_one(&acxt, sd, parent);
 	sysfs_addrm_finish(&acxt);
 
-	if (rc)
+	if (rc) {
 		sysfs_put(sd);
-
-	return rc;
+		return ERR_PTR(rc);
+	}
+	return sd;
 }
 
 int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 35f9421..869a0a7 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -64,6 +64,11 @@ struct kernfs_ops {
 struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
 					  const char *name, void *priv,
 					  const void *ns);
+struct sysfs_dirent *kernfs_create_file_ns(struct sysfs_dirent *parent,
+					   const char *name,
+					   umode_t mode, loff_t size,
+					   const struct kernfs_ops *ops,
+					   void *priv, const void *ns);
 struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
 					const char *name,
 					struct sysfs_dirent *target);
@@ -82,6 +87,12 @@ kernfs_create_dir_ns(struct sysfs_dirent *parent, const char *name, void *priv,
 { return ERR_PTR(-ENOSYS); }
 
 static inline struct sysfs_dirent *
+kernfs_create_file_ns(struct sysfs_dirent *parent, const char *name,
+		      umode_t mode, loff_t size, const struct kernfs_ops *ops,
+		      void *priv, const void *ns)
+{ return ERR_PTR(-ENOSYS); }
+
+static inline struct sysfs_dirent *
 kernfs_create_link(struct sysfs_dirent *parent, const char *name,
 		   struct sysfs_dirent *target)
 { return ERR_PTR(-ENOSYS); }
@@ -109,6 +120,13 @@ kernfs_create_dir(struct sysfs_dirent *parent, const char *name, void *priv)
 	return kernfs_create_dir_ns(parent, name, priv, NULL);
 }
 
+static inline struct sysfs_dirent *
+kernfs_create_file(struct sysfs_dirent *parent, const char *name, umode_t mode,
+		   loff_t size, const struct kernfs_ops *ops, void *priv)
+{
+	return kernfs_create_file_ns(parent, name, mode, size, ops, priv, NULL);
+}
+
 static inline int kernfs_remove_by_name(struct sysfs_dirent *parent,
 					const char *name)
 {
-- 
1.8.3.1

