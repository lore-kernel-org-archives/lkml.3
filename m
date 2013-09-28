Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3I1VvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:51:07 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:57190 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3I1VuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:50:05 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/14] sysfs: merge regular and bin file handling
Date: Sat, 28 Sep 2013 17:49:44 -0400
Message-Id: <1380404984-31858-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380404984-31858-1-git-send-email-tj@kernel.org>
References: <1380404984-31858-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous changes, sysfs regular file code is ready to handle
bin files too.  This patch makes bin files share the regular file
path.

* sysfs_create/remove_bin_file() are moved to fs/sysfs/file.c.

* sysfs_init_inode() is updated to use sysfs_file_operations for both
  regular and bin files.

* fs/sysfs/bin.c and the related pieces are removed.

This patch introduces subtle behavior changes in extreme corner cases.
Please refer to the preceding preparation patches which added bin file
handling to regular file paths for details.

Overall, this unification reduces the amount of duplicate logic, makes
behaviors more consistent and paves the road for building simpler and
more versatile interface which will allow other subsystems to make use
of sysfs for their pseudo filesystems.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay@vrfy.org>
---
 fs/sysfs/Makefile |   3 +-
 fs/sysfs/bin.c    | 502 ------------------------------------------------------
 fs/sysfs/dir.c    |   1 -
 fs/sysfs/file.c   |  26 +++
 fs/sysfs/inode.c  |   2 +-
 fs/sysfs/sysfs.h  |   6 -
 6 files changed, 28 insertions(+), 512 deletions(-)
 delete mode 100644 fs/sysfs/bin.c

diff --git a/fs/sysfs/Makefile b/fs/sysfs/Makefile
index 7a1ceb9..8876ac1 100644
--- a/fs/sysfs/Makefile
+++ b/fs/sysfs/Makefile
@@ -2,5 +2,4 @@
 # Makefile for the sysfs virtual filesystem
 #
 
-obj-y		:= inode.o file.o dir.o symlink.o mount.o bin.o \
-		   group.o
+obj-y		:= inode.o file.o dir.o symlink.o mount.o group.o
diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
deleted file mode 100644
index d49e6ca..0000000
--- a/fs/sysfs/bin.c
+++ /dev/null
@@ -1,502 +0,0 @@
-/*
- * fs/sysfs/bin.c - sysfs binary file implementation
- *
- * Copyright (c) 2003 Patrick Mochel
- * Copyright (c) 2003 Matthew Wilcox
- * Copyright (c) 2004 Silicon Graphics, Inc.
- * Copyright (c) 2007 SUSE Linux Products GmbH
- * Copyright (c) 2007 Tejun Heo <teheo@suse.de>
- *
- * This file is released under the GPLv2.
- *
- * Please see Documentation/filesystems/sysfs.txt for more information.
- */
-
-#undef DEBUG
-
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/kernel.h>
-#include <linux/kobject.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/mutex.h>
-#include <linux/mm.h>
-#include <linux/uaccess.h>
-
-#include "sysfs.h"
-
-/*
- * There's one bin_buffer for each open file.
- *
- * filp->private_data points to bin_buffer and
- * sysfs_dirent->s_bin_attr.buffers points to a the bin_buffer s
- * sysfs_dirent->s_bin_attr.buffers is protected by sysfs_bin_lock
- */
-static DEFINE_MUTEX(sysfs_bin_lock);
-
-struct bin_buffer {
-	struct mutex			mutex;
-	void				*buffer;
-	int				mmapped;
-	const struct vm_operations_struct *vm_ops;
-	struct file			*file;
-	struct hlist_node		list;
-};
-
-static int
-fill_read(struct file *file, char *buffer, loff_t off, size_t count)
-{
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	int rc;
-
-	/* need attr_sd for attr, its parent for kobj */
-	if (!sysfs_get_active(attr_sd))
-		return -ENODEV;
-
-	rc = -EIO;
-	if (attr->read)
-		rc = attr->read(file, kobj, attr, buffer, off, count);
-
-	sysfs_put_active(attr_sd);
-
-	return rc;
-}
-
-static ssize_t
-read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
-{
-	struct bin_buffer *bb = file->private_data;
-	int size = file_inode(file)->i_size;
-	loff_t offs = *off;
-	int count = min_t(size_t, bytes, PAGE_SIZE);
-	char *temp;
-
-	if (!bytes)
-		return 0;
-
-	if (size) {
-		if (offs > size)
-			return 0;
-		if (offs + count > size)
-			count = size - offs;
-	}
-
-	temp = kmalloc(count, GFP_KERNEL);
-	if (!temp)
-		return -ENOMEM;
-
-	mutex_lock(&bb->mutex);
-
-	count = fill_read(file, bb->buffer, offs, count);
-	if (count < 0) {
-		mutex_unlock(&bb->mutex);
-		goto out_free;
-	}
-
-	memcpy(temp, bb->buffer, count);
-
-	mutex_unlock(&bb->mutex);
-
-	if (copy_to_user(userbuf, temp, count)) {
-		count = -EFAULT;
-		goto out_free;
-	}
-
-	pr_debug("offs = %lld, *off = %lld, count = %d\n", offs, *off, count);
-
-	*off = offs + count;
-
- out_free:
-	kfree(temp);
-	return count;
-}
-
-static int
-flush_write(struct file *file, char *buffer, loff_t offset, size_t count)
-{
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	int rc;
-
-	/* need attr_sd for attr, its parent for kobj */
-	if (!sysfs_get_active(attr_sd))
-		return -ENODEV;
-
-	rc = -EIO;
-	if (attr->write)
-		rc = attr->write(file, kobj, attr, buffer, offset, count);
-
-	sysfs_put_active(attr_sd);
-
-	return rc;
-}
-
-static ssize_t write(struct file *file, const char __user *userbuf,
-		     size_t bytes, loff_t *off)
-{
-	struct bin_buffer *bb = file->private_data;
-	int size = file_inode(file)->i_size;
-	loff_t offs = *off;
-	int count = min_t(size_t, bytes, PAGE_SIZE);
-	char *temp;
-
-	if (!bytes)
-		return 0;
-
-	if (size) {
-		if (offs > size)
-			return 0;
-		if (offs + count > size)
-			count = size - offs;
-	}
-
-	temp = memdup_user(userbuf, count);
-	if (IS_ERR(temp))
-		return PTR_ERR(temp);
-
-	mutex_lock(&bb->mutex);
-
-	memcpy(bb->buffer, temp, count);
-
-	count = flush_write(file, bb->buffer, offs, count);
-	mutex_unlock(&bb->mutex);
-
-	if (count > 0)
-		*off = offs + count;
-
-	kfree(temp);
-	return count;
-}
-
-static void bin_vma_open(struct vm_area_struct *vma)
-{
-	struct file *file = vma->vm_file;
-	struct bin_buffer *bb = file->private_data;
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-
-	if (!bb->vm_ops)
-		return;
-
-	if (!sysfs_get_active(attr_sd))
-		return;
-
-	if (bb->vm_ops->open)
-		bb->vm_ops->open(vma);
-
-	sysfs_put_active(attr_sd);
-}
-
-static int bin_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
-{
-	struct file *file = vma->vm_file;
-	struct bin_buffer *bb = file->private_data;
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	int ret;
-
-	if (!bb->vm_ops)
-		return VM_FAULT_SIGBUS;
-
-	if (!sysfs_get_active(attr_sd))
-		return VM_FAULT_SIGBUS;
-
-	ret = VM_FAULT_SIGBUS;
-	if (bb->vm_ops->fault)
-		ret = bb->vm_ops->fault(vma, vmf);
-
-	sysfs_put_active(attr_sd);
-	return ret;
-}
-
-static int bin_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
-{
-	struct file *file = vma->vm_file;
-	struct bin_buffer *bb = file->private_data;
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	int ret;
-
-	if (!bb->vm_ops)
-		return VM_FAULT_SIGBUS;
-
-	if (!sysfs_get_active(attr_sd))
-		return VM_FAULT_SIGBUS;
-
-	ret = 0;
-	if (bb->vm_ops->page_mkwrite)
-		ret = bb->vm_ops->page_mkwrite(vma, vmf);
-	else
-		file_update_time(file);
-
-	sysfs_put_active(attr_sd);
-	return ret;
-}
-
-static int bin_access(struct vm_area_struct *vma, unsigned long addr,
-		  void *buf, int len, int write)
-{
-	struct file *file = vma->vm_file;
-	struct bin_buffer *bb = file->private_data;
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	int ret;
-
-	if (!bb->vm_ops)
-		return -EINVAL;
-
-	if (!sysfs_get_active(attr_sd))
-		return -EINVAL;
-
-	ret = -EINVAL;
-	if (bb->vm_ops->access)
-		ret = bb->vm_ops->access(vma, addr, buf, len, write);
-
-	sysfs_put_active(attr_sd);
-	return ret;
-}
-
-#ifdef CONFIG_NUMA
-static int bin_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
-{
-	struct file *file = vma->vm_file;
-	struct bin_buffer *bb = file->private_data;
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	int ret;
-
-	if (!bb->vm_ops)
-		return 0;
-
-	if (!sysfs_get_active(attr_sd))
-		return -EINVAL;
-
-	ret = 0;
-	if (bb->vm_ops->set_policy)
-		ret = bb->vm_ops->set_policy(vma, new);
-
-	sysfs_put_active(attr_sd);
-	return ret;
-}
-
-static struct mempolicy *bin_get_policy(struct vm_area_struct *vma,
-					unsigned long addr)
-{
-	struct file *file = vma->vm_file;
-	struct bin_buffer *bb = file->private_data;
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct mempolicy *pol;
-
-	if (!bb->vm_ops)
-		return vma->vm_policy;
-
-	if (!sysfs_get_active(attr_sd))
-		return vma->vm_policy;
-
-	pol = vma->vm_policy;
-	if (bb->vm_ops->get_policy)
-		pol = bb->vm_ops->get_policy(vma, addr);
-
-	sysfs_put_active(attr_sd);
-	return pol;
-}
-
-static int bin_migrate(struct vm_area_struct *vma, const nodemask_t *from,
-			const nodemask_t *to, unsigned long flags)
-{
-	struct file *file = vma->vm_file;
-	struct bin_buffer *bb = file->private_data;
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	int ret;
-
-	if (!bb->vm_ops)
-		return 0;
-
-	if (!sysfs_get_active(attr_sd))
-		return 0;
-
-	ret = 0;
-	if (bb->vm_ops->migrate)
-		ret = bb->vm_ops->migrate(vma, from, to, flags);
-
-	sysfs_put_active(attr_sd);
-	return ret;
-}
-#endif
-
-static const struct vm_operations_struct bin_vm_ops = {
-	.open		= bin_vma_open,
-	.fault		= bin_fault,
-	.page_mkwrite	= bin_page_mkwrite,
-	.access		= bin_access,
-#ifdef CONFIG_NUMA
-	.set_policy	= bin_set_policy,
-	.get_policy	= bin_get_policy,
-	.migrate	= bin_migrate,
-#endif
-};
-
-static int mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct bin_buffer *bb = file->private_data;
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	int rc;
-
-	mutex_lock(&bb->mutex);
-
-	/* need attr_sd for attr, its parent for kobj */
-	rc = -ENODEV;
-	if (!sysfs_get_active(attr_sd))
-		goto out_unlock;
-
-	rc = -EINVAL;
-	if (!attr->mmap)
-		goto out_put;
-
-	rc = attr->mmap(file, kobj, attr, vma);
-	if (rc)
-		goto out_put;
-
-	/*
-	 * PowerPC's pci_mmap of legacy_mem uses shmem_zero_setup()
-	 * to satisfy versions of X which crash if the mmap fails: that
-	 * substitutes a new vm_file, and we don't then want bin_vm_ops.
-	 */
-	if (vma->vm_file != file)
-		goto out_put;
-
-	rc = -EINVAL;
-	if (bb->mmapped && bb->vm_ops != vma->vm_ops)
-		goto out_put;
-
-	/*
-	 * It is not possible to successfully wrap close.
-	 * So error if someone is trying to use close.
-	 */
-	rc = -EINVAL;
-	if (vma->vm_ops && vma->vm_ops->close)
-		goto out_put;
-
-	rc = 0;
-	bb->mmapped = 1;
-	bb->vm_ops = vma->vm_ops;
-	vma->vm_ops = &bin_vm_ops;
-out_put:
-	sysfs_put_active(attr_sd);
-out_unlock:
-	mutex_unlock(&bb->mutex);
-
-	return rc;
-}
-
-static int open(struct inode *inode, struct file *file)
-{
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
-	struct bin_buffer *bb = NULL;
-	int error;
-
-	/* binary file operations requires both @sd and its parent */
-	if (!sysfs_get_active(attr_sd))
-		return -ENODEV;
-
-	error = -EACCES;
-	if ((file->f_mode & FMODE_WRITE) && !(attr->write || attr->mmap))
-		goto err_out;
-	if ((file->f_mode & FMODE_READ) && !(attr->read || attr->mmap))
-		goto err_out;
-
-	error = -ENOMEM;
-	bb = kzalloc(sizeof(*bb), GFP_KERNEL);
-	if (!bb)
-		goto err_out;
-
-	bb->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!bb->buffer)
-		goto err_out;
-
-	mutex_init(&bb->mutex);
-	bb->file = file;
-	file->private_data = bb;
-
-	mutex_lock(&sysfs_bin_lock);
-	hlist_add_head(&bb->list, &attr_sd->s_bin_attr.buffers);
-	mutex_unlock(&sysfs_bin_lock);
-
-	/* open succeeded, put active references */
-	sysfs_put_active(attr_sd);
-	return 0;
-
- err_out:
-	sysfs_put_active(attr_sd);
-	kfree(bb);
-	return error;
-}
-
-static int release(struct inode *inode, struct file *file)
-{
-	struct bin_buffer *bb = file->private_data;
-
-	mutex_lock(&sysfs_bin_lock);
-	hlist_del(&bb->list);
-	mutex_unlock(&sysfs_bin_lock);
-
-	kfree(bb->buffer);
-	kfree(bb);
-	return 0;
-}
-
-const struct file_operations bin_fops = {
-	.read		= read,
-	.write		= write,
-	.mmap		= mmap,
-	.llseek		= generic_file_llseek,
-	.open		= open,
-	.release	= release,
-};
-
-
-void unmap_bin_file(struct sysfs_dirent *attr_sd)
-{
-	struct bin_buffer *bb;
-
-	if (sysfs_type(attr_sd) != SYSFS_KOBJ_BIN_ATTR)
-		return;
-
-	mutex_lock(&sysfs_bin_lock);
-
-	hlist_for_each_entry(bb, &attr_sd->s_bin_attr.buffers, list) {
-		struct inode *inode = file_inode(bb->file);
-
-		unmap_mapping_range(inode->i_mapping, 0, 0, 1);
-	}
-
-	mutex_unlock(&sysfs_bin_lock);
-}
-
-/**
- *	sysfs_create_bin_file - create binary file for object.
- *	@kobj:	object.
- *	@attr:	attribute descriptor.
- */
-int sysfs_create_bin_file(struct kobject *kobj,
-			  const struct bin_attribute *attr)
-{
-	BUG_ON(!kobj || !kobj->sd || !attr);
-
-	return sysfs_add_file(kobj->sd, &attr->attr, SYSFS_KOBJ_BIN_ATTR);
-}
-EXPORT_SYMBOL_GPL(sysfs_create_bin_file);
-
-/**
- *	sysfs_remove_bin_file - remove binary file for object.
- *	@kobj:	object.
- *	@attr:	attribute descriptor.
- */
-void sysfs_remove_bin_file(struct kobject *kobj,
-			   const struct bin_attribute *attr)
-{
-	sysfs_hash_and_remove(kobj->sd, attr->attr.name, NULL);
-}
-EXPORT_SYMBOL_GPL(sysfs_remove_bin_file);
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index c4040dd..f6025c8 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -596,7 +596,6 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 
 		sysfs_deactivate(sd);
 		sysfs_unmap_bin_file(sd);
-		unmap_bin_file(sd);
 		sysfs_put(sd);
 	}
 }
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 723f78c..f3cbdbd 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -1014,6 +1014,32 @@ void sysfs_remove_file_from_group(struct kobject *kobj,
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_file_from_group);
 
+/**
+ *	sysfs_create_bin_file - create binary file for object.
+ *	@kobj:	object.
+ *	@attr:	attribute descriptor.
+ */
+int sysfs_create_bin_file(struct kobject *kobj,
+			  const struct bin_attribute *attr)
+{
+	BUG_ON(!kobj || !kobj->sd || !attr);
+
+	return sysfs_add_file(kobj->sd, &attr->attr, SYSFS_KOBJ_BIN_ATTR);
+}
+EXPORT_SYMBOL_GPL(sysfs_create_bin_file);
+
+/**
+ *	sysfs_remove_bin_file - remove binary file for object.
+ *	@kobj:	object.
+ *	@attr:	attribute descriptor.
+ */
+void sysfs_remove_bin_file(struct kobject *kobj,
+			   const struct bin_attribute *attr)
+{
+	sysfs_hash_and_remove(kobj->sd, attr->attr.name, NULL);
+}
+EXPORT_SYMBOL_GPL(sysfs_remove_bin_file);
+
 struct sysfs_schedule_callback_struct {
 	struct list_head	workq_list;
 	struct kobject		*kobj;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 63f755e..fe274a3 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -260,7 +260,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 	case SYSFS_KOBJ_BIN_ATTR:
 		bin_attr = sd->s_bin_attr.bin_attr;
 		inode->i_size = bin_attr->size;
-		inode->i_fop = &bin_fops;
+		inode->i_fop = &sysfs_file_operations;
 		break;
 	case SYSFS_KOBJ_LINK:
 		inode->i_op = &sysfs_symlink_inode_operations;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index b6444ec..94857dc 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -222,12 +222,6 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 void sysfs_unmap_bin_file(struct sysfs_dirent *sd);
 
 /*
- * bin.c
- */
-extern const struct file_operations bin_fops;
-void unmap_bin_file(struct sysfs_dirent *attr_sd);
-
-/*
  * symlink.c
  */
 extern const struct inode_operations sysfs_symlink_inode_operations;
-- 
1.8.3.1

