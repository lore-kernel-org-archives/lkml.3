Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab3K1TzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:55:23 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:33917 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278Ab3K1TzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:09 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/34] sysfs, kernfs: remove SYSFS_KOBJ_BIN_ATTR
Date: Thu, 28 Nov 2013 14:54:23 -0500
Message-Id: <1385668487-10181-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After kernfs_ops and sysfs_dirent->s_attr.size addition, the
distinction between SYSFS_KOBJ_BIN_ATTR and SYSFS_KOBJ_ATTR is only
necessary while creating files to decide which kernfs_ops to use.
Afterwards, they behave exactly the same.

This patch removes SYSFS_KOBJ_BIN_ATTR along with sysfs_is_bin().
sysfs_add_file[_mode_ns]() are updated to take bool @is_bin instead of
@type.

This patch doesn't introduce any behavior changes.  This completely
isolates the distinction between the two sysfs file types in the sysfs
layer proper.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c  | 23 ++++++++---------------
 fs/sysfs/group.c |  5 ++---
 fs/sysfs/inode.c |  1 -
 fs/sysfs/sysfs.h | 11 ++++-------
 4 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 0b0cec8..e2ce674 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -47,11 +47,6 @@ struct sysfs_open_dirent {
 	struct list_head	files; /* goes through sysfs_open_file.list */
 };
 
-static bool sysfs_is_bin(struct sysfs_dirent *sd)
-{
-	return sysfs_type(sd) == SYSFS_KOBJ_BIN_ATTR;
-}
-
 static struct sysfs_open_file *sysfs_of(struct file *file)
 {
 	return ((struct seq_file *)file->private_data)->private;
@@ -916,7 +911,7 @@ static const struct kernfs_ops sysfs_bin_kfops_rw = {
 };
 
 int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
-			   const struct attribute *attr, int type,
+			   const struct attribute *attr, bool is_bin,
 			   umode_t amode, const void *ns)
 {
 	umode_t mode = (amode & S_IALLUGO) | S_IFREG;
@@ -926,7 +921,7 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 	loff_t size;
 	int rc;
 
-	if (type == SYSFS_KOBJ_ATTR) {
+	if (!is_bin) {
 		struct kobject *kobj = dir_sd->priv;
 		const struct sysfs_ops *sysfs_ops = kobj->ktype->sysfs_ops;
 
@@ -961,7 +956,7 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 		size = battr->size;
 	}
 
-	sd = sysfs_new_dirent(attr->name, mode, type);
+	sd = sysfs_new_dirent(attr->name, mode, SYSFS_KOBJ_ATTR);
 	if (!sd)
 		return -ENOMEM;
 
@@ -991,11 +986,10 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 	return rc;
 }
 
-
 int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
-		   int type)
+		   bool is_bin)
 {
-	return sysfs_add_file_mode_ns(dir_sd, attr, type, attr->mode, NULL);
+	return sysfs_add_file_mode_ns(dir_sd, attr, is_bin, attr->mode, NULL);
 }
 
 /**
@@ -1009,8 +1003,7 @@ int sysfs_create_file_ns(struct kobject *kobj, const struct attribute *attr,
 {
 	BUG_ON(!kobj || !kobj->sd || !attr);
 
-	return sysfs_add_file_mode_ns(kobj->sd, attr, SYSFS_KOBJ_ATTR,
-				      attr->mode, ns);
+	return sysfs_add_file_mode_ns(kobj->sd, attr, false, attr->mode, ns);
 
 }
 EXPORT_SYMBOL_GPL(sysfs_create_file_ns);
@@ -1049,7 +1042,7 @@ int sysfs_add_file_to_group(struct kobject *kobj,
 	if (!dir_sd)
 		return -ENOENT;
 
-	error = sysfs_add_file(dir_sd, attr, SYSFS_KOBJ_ATTR);
+	error = sysfs_add_file(dir_sd, attr, false);
 	sysfs_put(dir_sd);
 
 	return error;
@@ -1141,7 +1134,7 @@ int sysfs_create_bin_file(struct kobject *kobj,
 {
 	BUG_ON(!kobj || !kobj->sd || !attr);
 
-	return sysfs_add_file(kobj->sd, &attr->attr, SYSFS_KOBJ_BIN_ATTR);
+	return sysfs_add_file(kobj->sd, &attr->attr, true);
 }
 EXPORT_SYMBOL_GPL(sysfs_create_bin_file);
 
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 065689d..9f65cd9 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -55,8 +55,7 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 				if (!mode)
 					continue;
 			}
-			error = sysfs_add_file_mode_ns(dir_sd, *attr,
-						       SYSFS_KOBJ_ATTR,
+			error = sysfs_add_file_mode_ns(dir_sd, *attr, false,
 						       (*attr)->mode | mode,
 						       NULL);
 			if (unlikely(error))
@@ -269,7 +268,7 @@ int sysfs_merge_group(struct kobject *kobj,
 		return -ENOENT;
 
 	for ((i = 0, attr = grp->attrs); *attr && !error; (++i, ++attr))
-		error = sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
+		error = sysfs_add_file(dir_sd, *attr, false);
 	if (error) {
 		while (--i >= 0)
 			kernfs_remove_by_name(dir_sd, (*--attr)->name);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 037a892..b3c717a 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -269,7 +269,6 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 		inode->i_fop = &sysfs_dir_operations;
 		break;
 	case SYSFS_KOBJ_ATTR:
-	case SYSFS_KOBJ_BIN_ATTR:
 		inode->i_size = sd->s_attr.size;
 		inode->i_fop = &kernfs_file_operations;
 		break;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index d40e85e..28898fa 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -83,10 +83,9 @@ struct sysfs_dirent {
 #define SYSFS_TYPE_MASK			0x00ff
 #define SYSFS_DIR			0x0001
 #define SYSFS_KOBJ_ATTR			0x0002
-#define SYSFS_KOBJ_BIN_ATTR		0x0004
 #define SYSFS_KOBJ_LINK			0x0008
 #define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
-#define SYSFS_ACTIVE_REF		(SYSFS_KOBJ_ATTR | SYSFS_KOBJ_BIN_ATTR)
+#define SYSFS_ACTIVE_REF		SYSFS_KOBJ_ATTR
 
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
 #define SYSFS_FLAG_NS			0x01000
@@ -115,10 +114,8 @@ do {								\
 static inline bool sysfs_ignore_lockdep(struct sysfs_dirent *sd)
 {
 	struct attribute *attr = sd->priv;
-	int type = sysfs_type(sd);
 
-	return (type == SYSFS_KOBJ_ATTR || type == SYSFS_KOBJ_BIN_ATTR) &&
-		attr->ignore_lockdep;
+	return sysfs_type(sd) == SYSFS_KOBJ_ATTR && attr->ignore_lockdep;
 }
 
 #else
@@ -219,10 +216,10 @@ int sysfs_inode_init(void);
 extern const struct file_operations kernfs_file_operations;
 
 int sysfs_add_file(struct sysfs_dirent *dir_sd,
-		   const struct attribute *attr, int type);
+		   const struct attribute *attr, bool is_bin);
 
 int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
-			   const struct attribute *attr, int type,
+			   const struct attribute *attr, bool is_bin,
 			   umode_t amode, const void *ns);
 void sysfs_unmap_bin_file(struct sysfs_dirent *sd);
 
-- 
1.8.4.2

