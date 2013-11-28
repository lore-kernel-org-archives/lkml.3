Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab3K1TzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:55:01 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:51098 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448Ab3K1Ty4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:54:56 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/34] sysfs, kernfs: replace sysfs_dirent->s_dir.kobj and ->s_attr.[bin_]attr with ->priv
Date: Thu, 28 Nov 2013 14:54:14 -0500
Message-Id: <1385668487-10181-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A directory sysfs_dirent points to the associated kobj.  A regular or
bin file points to the associated [bin_]attribute.  This patch
replaces sysfs_dirent->s_dir.kobj and ->s_attr.[bin_]attr with void *
->priv.

This is to prepare for kernfs interface so that sysfs can specify the
private data in the same way for directories and files.  This lower
debuggability but not by much - the whole thing was overlaid in a
union anyway.  If debuggability becomes an issue, we can later add
->priv accessors which explicitly check for the sysfs_dirent type and
performs casting.

This patch doesn't introduce any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c     |  2 +-
 fs/sysfs/file.c    | 26 +++++++++++++-------------
 fs/sysfs/inode.c   |  2 +-
 fs/sysfs/symlink.c |  2 +-
 fs/sysfs/sysfs.h   | 13 +++++--------
 5 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 5ba8966..aeb08bd 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -681,7 +681,7 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 		return -ENOMEM;
 
 	sd->s_ns = ns;
-	sd->s_dir.kobj = kobj;
+	sd->priv = kobj;
 
 	/* link in */
 	sysfs_addrm_start(&acxt);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 0f3f0a2..9b58d87 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -74,7 +74,7 @@ static struct sysfs_open_file *sysfs_of(struct file *file)
  */
 static const struct sysfs_ops *sysfs_file_ops(struct sysfs_dirent *sd)
 {
-	struct kobject *kobj = sd->s_parent->s_dir.kobj;
+	struct kobject *kobj = sd->s_parent->priv;
 
 	if (!sysfs_ignore_lockdep(sd))
 		lockdep_assert_held(sd);
@@ -89,7 +89,7 @@ static const struct sysfs_ops *sysfs_file_ops(struct sysfs_dirent *sd)
 static int sysfs_seq_show(struct seq_file *sf, void *v)
 {
 	struct sysfs_open_file *of = sf->private;
-	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
+	struct kobject *kobj = of->sd->s_parent->priv;
 	const struct sysfs_ops *ops;
 	char *buf;
 	ssize_t count;
@@ -120,7 +120,7 @@ static int sysfs_seq_show(struct seq_file *sf, void *v)
 	 */
 	ops = sysfs_file_ops(of->sd);
 	if (ops->show)
-		count = ops->show(kobj, of->sd->s_attr.attr, buf);
+		count = ops->show(kobj, of->sd->priv, buf);
 	else
 		count = 0;
 
@@ -154,8 +154,8 @@ static ssize_t sysfs_bin_read(struct file *file, char __user *userbuf,
 			      size_t bytes, loff_t *off)
 {
 	struct sysfs_open_file *of = sysfs_of(file);
-	struct bin_attribute *battr = of->sd->s_attr.bin_attr;
-	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
+	struct bin_attribute *battr = of->sd->priv;
+	struct kobject *kobj = of->sd->s_parent->priv;
 	loff_t size = file_inode(file)->i_size;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
 	loff_t offs = *off;
@@ -221,7 +221,7 @@ static ssize_t sysfs_bin_read(struct file *file, char __user *userbuf,
 static int flush_write_buffer(struct sysfs_open_file *of, char *buf, loff_t off,
 			      size_t count)
 {
-	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
+	struct kobject *kobj = of->sd->s_parent->priv;
 	int rc = 0;
 
 	/*
@@ -236,7 +236,7 @@ static int flush_write_buffer(struct sysfs_open_file *of, char *buf, loff_t off,
 	}
 
 	if (sysfs_is_bin(of->sd)) {
-		struct bin_attribute *battr = of->sd->s_attr.bin_attr;
+		struct bin_attribute *battr = of->sd->priv;
 
 		rc = -EIO;
 		if (battr->write)
@@ -245,7 +245,7 @@ static int flush_write_buffer(struct sysfs_open_file *of, char *buf, loff_t off,
 	} else {
 		const struct sysfs_ops *ops = sysfs_file_ops(of->sd);
 
-		rc = ops->store(kobj, of->sd->s_attr.attr, buf, count);
+		rc = ops->store(kobj, of->sd->priv, buf, count);
 	}
 
 	sysfs_put_active(of->sd);
@@ -466,8 +466,8 @@ static const struct vm_operations_struct sysfs_bin_vm_ops = {
 static int sysfs_bin_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct sysfs_open_file *of = sysfs_of(file);
-	struct bin_attribute *battr = of->sd->s_attr.bin_attr;
-	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
+	struct bin_attribute *battr = of->sd->priv;
+	struct kobject *kobj = of->sd->s_parent->priv;
 	int rc;
 
 	mutex_lock(&of->mutex);
@@ -607,7 +607,7 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->priv;
 	struct sysfs_open_file *of;
 	bool has_read, has_write, has_mmap;
 	int error = -EACCES;
@@ -617,7 +617,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 		return -ENODEV;
 
 	if (sysfs_is_bin(attr_sd)) {
-		struct bin_attribute *battr = attr_sd->s_attr.bin_attr;
+		struct bin_attribute *battr = attr_sd->priv;
 
 		has_read = battr->read || battr->mmap;
 		has_write = battr->write || battr->mmap;
@@ -848,7 +848,7 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 		return -ENOMEM;
 
 	sd->s_ns = ns;
-	sd->s_attr.attr = (void *)attr;
+	sd->priv = (void *)attr;
 	sysfs_dirent_init_lockdep(sd);
 
 	sysfs_addrm_start(&acxt);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 5f7e2af..81cc858 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -275,7 +275,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 		inode->i_fop = &sysfs_file_operations;
 		break;
 	case SYSFS_KOBJ_BIN_ATTR:
-		bin_attr = sd->s_attr.bin_attr;
+		bin_attr = sd->priv;
 		inode->i_size = bin_attr->size;
 		inode->i_fop = &sysfs_bin_operations;
 		break;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 0922c53..352fbbb 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -223,7 +223,7 @@ int sysfs_rename_link_ns(struct kobject *kobj, struct kobject *targ,
 	result = -EINVAL;
 	if (sysfs_type(sd) != SYSFS_KOBJ_LINK)
 		goto out;
-	if (sd->s_symlink.target_sd->s_dir.kobj != targ)
+	if (sd->s_symlink.target_sd->priv != targ)
 		goto out;
 
 	result = kernfs_rename_ns(sd, parent_sd, new, new_ns);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 2abccfd..a6f3fa3 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -17,8 +17,6 @@ struct sysfs_open_dirent;
 
 /* type-specific structures for sysfs_dirent->s_* union members */
 struct sysfs_elem_dir {
-	struct kobject		*kobj;
-
 	unsigned long		subdirs;
 	/* children rbtree starts here and goes through sd->s_rb */
 	struct rb_root		children;
@@ -29,10 +27,6 @@ struct sysfs_elem_symlink {
 };
 
 struct sysfs_elem_attr {
-	union {
-		struct attribute	*attr;
-		struct bin_attribute	*bin_attr;
-	};
 	struct sysfs_open_dirent *open;
 };
 
@@ -74,6 +68,8 @@ struct sysfs_dirent {
 		struct sysfs_elem_attr		s_attr;
 	};
 
+	void			*priv;
+
 	unsigned short		s_flags;
 	umode_t			s_mode;
 	unsigned int		s_ino;
@@ -103,7 +99,7 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 
 #define sysfs_dirent_init_lockdep(sd)				\
 do {								\
-	struct attribute *attr = sd->s_attr.attr;		\
+	struct attribute *attr = sd->priv;			\
 	struct lock_class_key *key = attr->key;			\
 	if (!key)						\
 		key = &attr->skey;				\
@@ -114,10 +110,11 @@ do {								\
 /* Test for attributes that want to ignore lockdep for read-locking */
 static inline bool sysfs_ignore_lockdep(struct sysfs_dirent *sd)
 {
+	struct attribute *attr = sd->priv;
 	int type = sysfs_type(sd);
 
 	return (type == SYSFS_KOBJ_ATTR || type == SYSFS_KOBJ_BIN_ATTR) &&
-		sd->s_attr.attr->ignore_lockdep;
+		attr->ignore_lockdep;
 }
 
 #else
-- 
1.8.4.2

