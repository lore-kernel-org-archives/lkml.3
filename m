Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3JAVnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:43:00 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:44688 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab3JAVmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:42:36 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/15] sysfs: copy bin mmap support from fs/sysfs/bin.c to fs/sysfs/file.c
Date: Tue,  1 Oct 2013 17:42:07 -0400
Message-Id: <1380663729-18243-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380663729-18243-1-git-send-email-tj@kernel.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs bin file handling will be merged into the regular file support.
This patch copies mmap support from bin so that fs/sysfs/file.c can
handle mmapping bin files.

The code is copied mostly verbatim with the following updates.

* ->mmapped and ->vm_ops are added to sysfs_open_file and bin_buffer
  references are replaced with sysfs_open_file ones.

* Symbols are prefixed with sysfs_.

* sysfs_unmap_bin_file() grabs sysfs_open_dirent and traverses
  ->files.  Invocation of this function is added to
  sysfs_addrm_finish().

* sysfs_bin_mmap() is added to sysfs_bin_operations.

This is a preparation and the new mmap path isn't used yet.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c   |   1 +
 fs/sysfs/file.c  | 247 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/sysfs/sysfs.h |   2 +
 3 files changed, 249 insertions(+), 1 deletion(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b518afd..c4040dd 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -595,6 +595,7 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 		acxt->removed = sd->u.removed_list;
 
 		sysfs_deactivate(sd);
+		sysfs_unmap_bin_file(sd);
 		unmap_bin_file(sd);
 		sysfs_put(sd);
 	}
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 9ba492a..02797a1 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -22,6 +22,7 @@
 #include <linux/limits.h>
 #include <linux/uaccess.h>
 #include <linux/seq_file.h>
+#include <linux/mm.h>
 
 #include "sysfs.h"
 
@@ -52,6 +53,9 @@ struct sysfs_open_file {
 	struct mutex		mutex;
 	int			event;
 	struct list_head	list;
+
+	bool			mmapped;
+	const struct vm_operations_struct *vm_ops;
 };
 
 static bool sysfs_is_bin(struct sysfs_dirent *sd)
@@ -301,6 +305,218 @@ out_free:
 	return len;
 }
 
+static void sysfs_bin_vma_open(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+	struct sysfs_open_file *of = sysfs_of(file);
+
+	if (!of->vm_ops)
+		return;
+
+	if (!sysfs_get_active(of->sd))
+		return;
+
+	if (of->vm_ops->open)
+		of->vm_ops->open(vma);
+
+	sysfs_put_active(of->sd);
+}
+
+static int sysfs_bin_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct file *file = vma->vm_file;
+	struct sysfs_open_file *of = sysfs_of(file);
+	int ret;
+
+	if (!of->vm_ops)
+		return VM_FAULT_SIGBUS;
+
+	if (!sysfs_get_active(of->sd))
+		return VM_FAULT_SIGBUS;
+
+	ret = VM_FAULT_SIGBUS;
+	if (of->vm_ops->fault)
+		ret = of->vm_ops->fault(vma, vmf);
+
+	sysfs_put_active(of->sd);
+	return ret;
+}
+
+static int sysfs_bin_page_mkwrite(struct vm_area_struct *vma,
+				  struct vm_fault *vmf)
+{
+	struct file *file = vma->vm_file;
+	struct sysfs_open_file *of = sysfs_of(file);
+	int ret;
+
+	if (!of->vm_ops)
+		return VM_FAULT_SIGBUS;
+
+	if (!sysfs_get_active(of->sd))
+		return VM_FAULT_SIGBUS;
+
+	ret = 0;
+	if (of->vm_ops->page_mkwrite)
+		ret = of->vm_ops->page_mkwrite(vma, vmf);
+	else
+		file_update_time(file);
+
+	sysfs_put_active(of->sd);
+	return ret;
+}
+
+static int sysfs_bin_access(struct vm_area_struct *vma, unsigned long addr,
+			    void *buf, int len, int write)
+{
+	struct file *file = vma->vm_file;
+	struct sysfs_open_file *of = sysfs_of(file);
+	int ret;
+
+	if (!of->vm_ops)
+		return -EINVAL;
+
+	if (!sysfs_get_active(of->sd))
+		return -EINVAL;
+
+	ret = -EINVAL;
+	if (of->vm_ops->access)
+		ret = of->vm_ops->access(vma, addr, buf, len, write);
+
+	sysfs_put_active(of->sd);
+	return ret;
+}
+
+#ifdef CONFIG_NUMA
+static int sysfs_bin_set_policy(struct vm_area_struct *vma,
+				struct mempolicy *new)
+{
+	struct file *file = vma->vm_file;
+	struct sysfs_open_file *of = sysfs_of(file);
+	int ret;
+
+	if (!of->vm_ops)
+		return 0;
+
+	if (!sysfs_get_active(of->sd))
+		return -EINVAL;
+
+	ret = 0;
+	if (of->vm_ops->set_policy)
+		ret = of->vm_ops->set_policy(vma, new);
+
+	sysfs_put_active(of->sd);
+	return ret;
+}
+
+static struct mempolicy *sysfs_bin_get_policy(struct vm_area_struct *vma,
+					      unsigned long addr)
+{
+	struct file *file = vma->vm_file;
+	struct sysfs_open_file *of = sysfs_of(file);
+	struct mempolicy *pol;
+
+	if (!of->vm_ops)
+		return vma->vm_policy;
+
+	if (!sysfs_get_active(of->sd))
+		return vma->vm_policy;
+
+	pol = vma->vm_policy;
+	if (of->vm_ops->get_policy)
+		pol = of->vm_ops->get_policy(vma, addr);
+
+	sysfs_put_active(of->sd);
+	return pol;
+}
+
+static int sysfs_bin_migrate(struct vm_area_struct *vma, const nodemask_t *from,
+			     const nodemask_t *to, unsigned long flags)
+{
+	struct file *file = vma->vm_file;
+	struct sysfs_open_file *of = sysfs_of(file);
+	int ret;
+
+	if (!of->vm_ops)
+		return 0;
+
+	if (!sysfs_get_active(of->sd))
+		return 0;
+
+	ret = 0;
+	if (of->vm_ops->migrate)
+		ret = of->vm_ops->migrate(vma, from, to, flags);
+
+	sysfs_put_active(of->sd);
+	return ret;
+}
+#endif
+
+static const struct vm_operations_struct sysfs_bin_vm_ops = {
+	.open		= sysfs_bin_vma_open,
+	.fault		= sysfs_bin_fault,
+	.page_mkwrite	= sysfs_bin_page_mkwrite,
+	.access		= sysfs_bin_access,
+#ifdef CONFIG_NUMA
+	.set_policy	= sysfs_bin_set_policy,
+	.get_policy	= sysfs_bin_get_policy,
+	.migrate	= sysfs_bin_migrate,
+#endif
+};
+
+static int sysfs_bin_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct sysfs_open_file *of = sysfs_of(file);
+	struct bin_attribute *battr = of->sd->s_bin_attr.bin_attr;
+	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
+	int rc;
+
+	mutex_lock(&of->mutex);
+
+	/* need of->sd for battr, its parent for kobj */
+	rc = -ENODEV;
+	if (!sysfs_get_active(of->sd))
+		goto out_unlock;
+
+	rc = -EINVAL;
+	if (!battr->mmap)
+		goto out_put;
+
+	rc = battr->mmap(file, kobj, battr, vma);
+	if (rc)
+		goto out_put;
+
+	/*
+	 * PowerPC's pci_mmap of legacy_mem uses shmem_zero_setup()
+	 * to satisfy versions of X which crash if the mmap fails: that
+	 * substitutes a new vm_file, and we don't then want bin_vm_ops.
+	 */
+	if (vma->vm_file != file)
+		goto out_put;
+
+	rc = -EINVAL;
+	if (of->mmapped && of->vm_ops != vma->vm_ops)
+		goto out_put;
+
+	/*
+	 * It is not possible to successfully wrap close.
+	 * So error if someone is trying to use close.
+	 */
+	rc = -EINVAL;
+	if (vma->vm_ops && vma->vm_ops->close)
+		goto out_put;
+
+	rc = 0;
+	of->mmapped = 1;
+	of->vm_ops = vma->vm_ops;
+	vma->vm_ops = &sysfs_bin_vm_ops;
+out_put:
+	sysfs_put_active(of->sd);
+out_unlock:
+	mutex_unlock(&of->mutex);
+
+	return rc;
+}
+
 /**
  *	sysfs_get_open_dirent - get or create sysfs_open_dirent
  *	@sd: target sysfs_dirent
@@ -375,7 +591,9 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 	mutex_lock(&sysfs_open_file_mutex);
 	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
 
-	list_del(&of->list);
+	if (of)
+		list_del(&of->list);
+
 	if (atomic_dec_and_test(&od->refcnt))
 		sd->s_attr.open = NULL;
 	else
@@ -477,6 +695,32 @@ static int sysfs_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+void sysfs_unmap_bin_file(struct sysfs_dirent *sd)
+{
+	struct sysfs_open_dirent *od;
+	struct sysfs_open_file *of;
+
+	if (!sysfs_is_bin(sd))
+		return;
+
+	spin_lock_irq(&sysfs_open_dirent_lock);
+	od = sd->s_attr.open;
+	if (od)
+		atomic_inc(&od->refcnt);
+	spin_unlock_irq(&sysfs_open_dirent_lock);
+	if (!od)
+		return;
+
+	mutex_lock(&sysfs_open_file_mutex);
+	list_for_each_entry(of, &od->files, list) {
+		struct inode *inode = file_inode(of->file);
+		unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+	}
+	mutex_unlock(&sysfs_open_file_mutex);
+
+	sysfs_put_open_dirent(sd, NULL);
+}
+
 /* Sysfs attribute files are pollable.  The idea is that you read
  * the content and then you use 'poll' or 'select' to wait for
  * the content to change.  When the content changes (assuming the
@@ -562,6 +806,7 @@ const struct file_operations sysfs_bin_operations = {
 	.read		= sysfs_bin_read,
 	.write		= sysfs_write_file,
 	.llseek		= generic_file_llseek,
+	.mmap		= sysfs_bin_mmap,
 };
 
 int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index f103bac..c960d62 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -220,6 +220,8 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd,
 int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 			   const struct attribute *attr, int type,
 			   umode_t amode, const void *ns);
+void sysfs_unmap_bin_file(struct sysfs_dirent *sd);
+
 /*
  * bin.c
  */
-- 
1.8.3.1

