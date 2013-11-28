Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab3K1TzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:55:18 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:51498 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab3K1TzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:05 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/34] sysfs, kernfs: introduce kernfs_ops
Date: Thu, 28 Nov 2013 14:54:21 -0500
Message-Id: <1385668487-10181-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're in the process of separating out core sysfs functionality into
kernfs which will deal with sysfs_dirents directly.  This patch
introduces kernfs_ops which hosts methods kernfs users implement and
updates fs/sysfs/file.c such that sysfs_kf_*() functions populate
kernfs_ops and kernfs_file_*() functions call the matching entries
from kernfs_ops.

kernfs_ops contains the following groups of methods.

* seq_show() - for kernfs files which use seq_file for reads.

* read() - for direct read implementations.  Used iff seq_show() is
  not implemented.

* write() - for writes.

* mmap() - for mmaps.

Notes:

* sysfs_elem_attr->ops is added so that kernfs_ops can be accessed
  from sysfs_dirent.  kernfs_ops() helper is added to verify locking
  and access the field.

* SYSFS_FLAG_HAS_(SEQ_SHOW|MMAP) added.  sd->s_attr->ops is accessible
  only while holding active_ref and there are cases where we want to
  take different actions depending on which ops are implemented.
  These two flags cache whether the two ops are implemented for those.

* kernfs_file_*() no longer test sysfs type but chooses different
  behaviors depending on which methods in kernfs_ops are implemented.
  The conversions are trivial except for the open path.  As
  kernfs_file_open() now decides whether to allow read/write accesses
  depending on the kernfs_ops implemented, the presence of methods in
  kobjs and attribute_bin should be propagated to kernfs_ops.
  sysfs_add_file_mode_ns() is updated so that it propagates presence /
  absence of the callbacks through _empty, _ro, _wo, _rw kernfs_ops.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c        | 146 +++++++++++++++++++++++++++++++++++++------------
 fs/sysfs/sysfs.h       |   3 +
 include/linux/kernfs.h |  26 +++++++++
 3 files changed, 141 insertions(+), 34 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index acba583..cbebc33 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -58,6 +58,17 @@ static struct sysfs_open_file *sysfs_of(struct file *file)
 }
 
 /*
+ * Determine the kernfs_ops for the given sysfs_dirent.  This function must
+ * be called while holding an active reference.
+ */
+static const struct kernfs_ops *kernfs_ops(struct sysfs_dirent *sd)
+{
+	if (!sysfs_ignore_lockdep(sd))
+		lockdep_assert_held(sd);
+	return sd->s_attr.ops;
+}
+
+/*
  * Determine ktype->sysfs_ops for the given sysfs_dirent.  This function
  * must be called while holding an active reference.
  */
@@ -180,7 +191,7 @@ static int kernfs_seq_show(struct seq_file *sf, void *v)
 
 	of->event = atomic_read(&of->sd->s_attr.open->event);
 
-	return sysfs_kf_seq_show(sf, v);
+	return of->sd->s_attr.ops->seq_show(sf, v);
 }
 
 static const struct seq_operations kernfs_seq_ops = {
@@ -201,6 +212,7 @@ static ssize_t kernfs_file_direct_read(struct sysfs_open_file *of,
 				       loff_t *ppos)
 {
 	ssize_t len = min_t(size_t, count, PAGE_SIZE);
+	const struct kernfs_ops *ops;
 	char *buf;
 
 	buf = kmalloc(len, GFP_KERNEL);
@@ -218,7 +230,11 @@ static ssize_t kernfs_file_direct_read(struct sysfs_open_file *of,
 		goto out_free;
 	}
 
-	len = sysfs_kf_bin_read(of, buf, len, *ppos);
+	ops = kernfs_ops(of->sd);
+	if (ops->read)
+		len = ops->read(of, buf, len, *ppos);
+	else
+		len = -EINVAL;
 
 	sysfs_put_active(of->sd);
 	mutex_unlock(&of->mutex);
@@ -250,10 +266,10 @@ static ssize_t kernfs_file_read(struct file *file, char __user *user_buf,
 {
 	struct sysfs_open_file *of = sysfs_of(file);
 
-	if (sysfs_is_bin(of->sd))
-		return kernfs_file_direct_read(of, user_buf, count, ppos);
-	else
+	if (of->sd->s_flags & SYSFS_FLAG_HAS_SEQ_SHOW)
 		return seq_read(file, user_buf, count, ppos);
+	else
+		return kernfs_file_direct_read(of, user_buf, count, ppos);
 }
 
 /* kernfs write callback for regular sysfs files */
@@ -312,6 +328,7 @@ static ssize_t kernfs_file_write(struct file *file, const char __user *user_buf,
 {
 	struct sysfs_open_file *of = sysfs_of(file);
 	ssize_t len = min_t(size_t, count, PAGE_SIZE);
+	const struct kernfs_ops *ops;
 	char *buf;
 
 	buf = kmalloc(len + 1, GFP_KERNEL);
@@ -335,10 +352,11 @@ static ssize_t kernfs_file_write(struct file *file, const char __user *user_buf,
 		goto out_free;
 	}
 
-	if (sysfs_is_bin(of->sd))
-		len = sysfs_kf_bin_write(of, buf, len, *ppos);
+	ops = kernfs_ops(of->sd);
+	if (ops->write)
+		len = ops->write(of, buf, len, *ppos);
 	else
-		len = sysfs_kf_write(of, buf, len, *ppos);
+		len = -EINVAL;
 
 	sysfs_put_active(of->sd);
 	mutex_unlock(&of->mutex);
@@ -524,6 +542,7 @@ static const struct vm_operations_struct kernfs_vm_ops = {
 static int kernfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct sysfs_open_file *of = sysfs_of(file);
+	const struct kernfs_ops *ops;
 	int rc;
 
 	mutex_lock(&of->mutex);
@@ -532,8 +551,9 @@ static int kernfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	if (!sysfs_get_active(of->sd))
 		goto out_unlock;
 
-	if (sysfs_is_bin(of->sd))
-		rc = sysfs_kf_bin_mmap(of, vma);
+	ops = kernfs_ops(of->sd);
+	if (ops->mmap)
+		rc = ops->mmap(of, vma);
 	if (rc)
 		goto out_put;
 
@@ -660,34 +680,19 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 static int kernfs_file_open(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->priv;
+	const struct kernfs_ops *ops;
 	struct sysfs_open_file *of;
 	bool has_read, has_write, has_mmap;
 	int error = -EACCES;
 
-	/* need attr_sd for attr and ops, its parent for kobj */
 	if (!sysfs_get_active(attr_sd))
 		return -ENODEV;
 
-	if (sysfs_is_bin(attr_sd)) {
-		struct bin_attribute *battr = attr_sd->priv;
+	ops = kernfs_ops(attr_sd);
 
-		has_read = battr->read || battr->mmap;
-		has_write = battr->write || battr->mmap;
-		has_mmap = battr->mmap;
-	} else {
-		const struct sysfs_ops *ops = sysfs_file_ops(attr_sd);
-
-		/* every kobject with an attribute needs a ktype assigned */
-		if (WARN(!ops, KERN_ERR
-			 "missing sysfs attribute operations for kobject: %s\n",
-			 kobject_name(kobj)))
-			goto err_out;
-
-		has_read = ops->show;
-		has_write = ops->store;
-		has_mmap = false;
-	}
+	has_read = ops->seq_show || ops->read || ops->mmap;
+	has_write = ops->write || ops->mmap;
+	has_mmap = ops->mmap;
 
 	/* check perms and supported operations */
 	if ((file->f_mode & FMODE_WRITE) &&
@@ -729,10 +734,10 @@ static int kernfs_file_open(struct inode *inode, struct file *file)
 	 * seq_file or is not requested.  This unifies private data access
 	 * and readable regular files are the vast majority anyway.
 	 */
-	if (sysfs_is_bin(attr_sd))
-		error = seq_open(file, NULL);
-	else
+	if (ops->seq_show)
 		error = seq_open(file, &kernfs_seq_ops);
+	else
+		error = seq_open(file, NULL);
 	if (error)
 		goto err_free;
 
@@ -777,7 +782,7 @@ void sysfs_unmap_bin_file(struct sysfs_dirent *sd)
 	struct sysfs_open_dirent *od;
 	struct sysfs_open_file *of;
 
-	if (!sysfs_is_bin(sd))
+	if (!(sd->s_flags & SYSFS_FLAG_HAS_MMAP))
 		return;
 
 	spin_lock_irq(&sysfs_open_dirent_lock);
@@ -880,23 +885,96 @@ const struct file_operations kernfs_file_operations = {
 	.poll		= kernfs_file_poll,
 };
 
+static const struct kernfs_ops sysfs_file_kfops_empty = {
+};
+
+static const struct kernfs_ops sysfs_file_kfops_ro = {
+	.seq_show	= sysfs_kf_seq_show,
+};
+
+static const struct kernfs_ops sysfs_file_kfops_wo = {
+	.write		= sysfs_kf_write,
+};
+
+static const struct kernfs_ops sysfs_file_kfops_rw = {
+	.seq_show	= sysfs_kf_seq_show,
+	.write		= sysfs_kf_write,
+};
+
+static const struct kernfs_ops sysfs_bin_kfops_ro = {
+	.read		= sysfs_kf_bin_read,
+};
+
+static const struct kernfs_ops sysfs_bin_kfops_wo = {
+	.write		= sysfs_kf_bin_write,
+};
+
+static const struct kernfs_ops sysfs_bin_kfops_rw = {
+	.read		= sysfs_kf_bin_read,
+	.write		= sysfs_kf_bin_write,
+	.mmap		= sysfs_kf_bin_mmap,
+};
+
 int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 			   const struct attribute *attr, int type,
 			   umode_t amode, const void *ns)
 {
 	umode_t mode = (amode & S_IALLUGO) | S_IFREG;
+	const struct kernfs_ops *ops;
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 	int rc;
 
+	if (type == SYSFS_KOBJ_ATTR) {
+		struct kobject *kobj = dir_sd->priv;
+		const struct sysfs_ops *sysfs_ops = kobj->ktype->sysfs_ops;
+
+		/* every kobject with an attribute needs a ktype assigned */
+		if (WARN(!sysfs_ops, KERN_ERR
+			 "missing sysfs attribute operations for kobject: %s\n",
+			 kobject_name(kobj)))
+			return -EINVAL;
+
+		if (sysfs_ops->show && sysfs_ops->store)
+			ops = &sysfs_file_kfops_rw;
+		else if (sysfs_ops->show)
+			ops = &sysfs_file_kfops_ro;
+		else if (sysfs_ops->store)
+			ops = &sysfs_file_kfops_wo;
+		else
+			ops = &sysfs_file_kfops_empty;
+	} else {
+		struct bin_attribute *battr = (void *)attr;
+
+		if ((battr->read && battr->write) || battr->mmap)
+			ops = &sysfs_bin_kfops_rw;
+		else if (battr->read)
+			ops = &sysfs_bin_kfops_ro;
+		else if (battr->write)
+			ops = &sysfs_bin_kfops_wo;
+		else
+			ops = &sysfs_file_kfops_empty;
+	}
+
 	sd = sysfs_new_dirent(attr->name, mode, type);
 	if (!sd)
 		return -ENOMEM;
 
+	sd->s_attr.ops = ops;
 	sd->s_ns = ns;
 	sd->priv = (void *)attr;
 	sysfs_dirent_init_lockdep(sd);
 
+	/*
+	 * sd->s_attr.ops is accesible only while holding active ref.  We
+	 * need to know whether some ops are implemented outside active
+	 * ref.  Cache their existence in flags.
+	 */
+	if (ops->seq_show)
+		sd->s_flags |= SYSFS_FLAG_HAS_SEQ_SHOW;
+	if (ops->mmap)
+		sd->s_flags |= SYSFS_FLAG_HAS_MMAP;
+
 	sysfs_addrm_start(&acxt);
 	rc = sysfs_add_one(&acxt, sd, dir_sd);
 	sysfs_addrm_finish(&acxt);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 619250d..c05e0dd 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -27,6 +27,7 @@ struct sysfs_elem_symlink {
 };
 
 struct sysfs_elem_attr {
+	const struct kernfs_ops	*ops;
 	struct sysfs_open_dirent *open;
 };
 
@@ -89,6 +90,8 @@ struct sysfs_dirent {
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
 #define SYSFS_FLAG_NS			0x01000
 #define SYSFS_FLAG_REMOVED		0x02000
+#define SYSFS_FLAG_HAS_SEQ_SHOW		0x04000
+#define SYSFS_FLAG_HAS_MMAP		0x08000
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 {
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index b923052..97c6c0f 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -33,6 +33,32 @@ struct sysfs_open_file {
 	const struct vm_operations_struct *vm_ops;
 };
 
+struct kernfs_ops {
+	/*
+	 * Read is handled by either seq_file or raw_read().
+	 *
+	 * If seq_show() is present, seq_file path is active.  The behavior
+	 * is equivalent to single_open().  @sf->private points to the
+	 * associated sysfs_open_file.
+	 *
+	 * read() is bounced through kernel buffer and a read larger than
+	 * PAGE_SIZE results in partial operation of PAGE_SIZE.
+	 */
+	int (*seq_show)(struct seq_file *sf, void *v);
+
+	ssize_t (*read)(struct sysfs_open_file *of, char *buf, size_t bytes,
+			loff_t off);
+
+	/*
+	 * write() is bounced through kernel buffer and a write larger than
+	 * PAGE_SIZE results in partial operation of PAGE_SIZE.
+	 */
+	ssize_t (*write)(struct sysfs_open_file *of, char *buf, size_t bytes,
+			 loff_t off);
+
+	int (*mmap)(struct sysfs_open_file *of, struct vm_area_struct *vma);
+};
+
 #ifdef CONFIG_SYSFS
 
 struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
-- 
1.8.4.2

