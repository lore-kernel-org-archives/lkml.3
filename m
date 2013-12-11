Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab3LKTRC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:17:02 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:62327 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3LKTMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:12:47 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, linus.walleij@linaro.org,
        ashutosh.dixit@intel.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] kernfs: s/sysfs/kernfs/ in various data structures
Date: Wed, 11 Dec 2013 14:11:55 -0500
Message-Id: <1386789118-24733-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386789118-24733-1-git-send-email-tj@kernel.org>
References: <1386789118-24733-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs has just been separated out from sysfs and we're already in
full conflict mode.  Nothing can make the situation any worse.  Let's
take the chance to name things properly.

This patch performs the following renames.

* s/sysfs_open_dirent/kernfs_open_node/
* s/sysfs_open_file/kernfs_open_file/
* s/sysfs_inode_attrs/kernfs_iattrs/
* s/sysfs_addrm_cxt/kernfs_addrm_cxt/
* s/sysfs_super_info/kernfs_super_info/
* s/sysfs_info()/kernfs_info()/
* s/sysfs_open_dirent_lock/kernfs_open_node_lock/
* s/sysfs_open_file_mutex/kernfs_open_file_mutex/
* s/sysfs_of()/kernfs_of()/

This patch is strictly rename only and doesn't introduce any
functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             |  28 ++++----
 fs/kernfs/file.c            | 172 ++++++++++++++++++++++----------------------
 fs/kernfs/inode.c           |  30 ++++----
 fs/kernfs/kernfs-internal.h |  20 +++---
 fs/kernfs/mount.c           |  14 ++--
 fs/kernfs/symlink.c         |   2 +-
 fs/sysfs/file.c             |  10 +--
 include/linux/kernfs.h      |  18 ++---
 8 files changed, 147 insertions(+), 147 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 51fff9d..d038bb2 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -295,7 +295,7 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 
 	/* The sysfs dirent has been moved to a different namespace */
 	if (kn->parent && kernfs_ns_enabled(kn->parent) &&
-	    sysfs_info(dentry->d_sb)->ns != kn->ns)
+	    kernfs_info(dentry->d_sb)->ns != kn->ns)
 		goto out_bad;
 
 	mutex_unlock(&sysfs_mutex);
@@ -375,7 +375,7 @@ struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
 
 /**
  *	sysfs_addrm_start - prepare for kernfs_node add/remove
- *	@acxt: pointer to sysfs_addrm_cxt to be used
+ *	@acxt: pointer to kernfs_addrm_cxt to be used
  *
  *	This function is called when the caller is about to add or remove
  *	kernfs_node.  This function acquires sysfs_mutex.  @acxt is used to
@@ -385,7 +385,7 @@ struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
  *	Kernel thread context (may sleep).  sysfs_mutex is locked on
  *	return.
  */
-void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt)
+void sysfs_addrm_start(struct kernfs_addrm_cxt *acxt)
 	__acquires(sysfs_mutex)
 {
 	memset(acxt, 0, sizeof(*acxt));
@@ -414,11 +414,11 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt)
  *	0 on success, -EEXIST if entry with the given name already
  *	exists.
  */
-int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct kernfs_node *kn,
+int sysfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 		  struct kernfs_node *parent)
 {
 	bool has_ns = kernfs_ns_enabled(parent);
-	struct sysfs_inode_attrs *ps_iattr;
+	struct kernfs_iattrs *ps_iattr;
 	int ret;
 
 	if (has_ns != (bool)kn->ns) {
@@ -466,10 +466,10 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct kernfs_node *kn,
  *	LOCKING:
  *	Determined by sysfs_addrm_start().
  */
-static void sysfs_remove_one(struct sysfs_addrm_cxt *acxt,
+static void sysfs_remove_one(struct kernfs_addrm_cxt *acxt,
 			     struct kernfs_node *kn)
 {
-	struct sysfs_inode_attrs *ps_iattr;
+	struct kernfs_iattrs *ps_iattr;
 
 	/*
 	 * Removal can be called multiple times on the same node.  Only the
@@ -505,7 +505,7 @@ static void sysfs_remove_one(struct sysfs_addrm_cxt *acxt,
  *	LOCKING:
  *	sysfs_mutex is released.
  */
-void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
+void sysfs_addrm_finish(struct kernfs_addrm_cxt *acxt)
 	__releases(sysfs_mutex)
 {
 	/* release resources acquired by sysfs_addrm_start() */
@@ -649,7 +649,7 @@ struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
 					 const void *ns)
 {
 	umode_t mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
-	struct sysfs_addrm_cxt acxt;
+	struct kernfs_addrm_cxt acxt;
 	struct kernfs_node *kn;
 	int rc;
 
@@ -686,7 +686,7 @@ static struct dentry *sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	mutex_lock(&sysfs_mutex);
 
 	if (kernfs_ns_enabled(parent))
-		ns = sysfs_info(dir->i_sb)->ns;
+		ns = kernfs_info(dir->i_sb)->ns;
 
 	kn = kernfs_find_ns(parent, dentry->d_name.name, ns);
 
@@ -778,7 +778,7 @@ static struct kernfs_node *sysfs_next_descendant_post(struct kernfs_node *pos,
 	return pos->parent;
 }
 
-static void __kernfs_remove(struct sysfs_addrm_cxt *acxt,
+static void __kernfs_remove(struct kernfs_addrm_cxt *acxt,
 			    struct kernfs_node *kn)
 {
 	struct kernfs_node *pos, *next;
@@ -805,7 +805,7 @@ static void __kernfs_remove(struct sysfs_addrm_cxt *acxt,
  */
 void kernfs_remove(struct kernfs_node *kn)
 {
-	struct sysfs_addrm_cxt acxt;
+	struct kernfs_addrm_cxt acxt;
 
 	sysfs_addrm_start(&acxt);
 	__kernfs_remove(&acxt, kn);
@@ -824,7 +824,7 @@ void kernfs_remove(struct kernfs_node *kn)
 int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 			     const void *ns)
 {
-	struct sysfs_addrm_cxt acxt;
+	struct kernfs_addrm_cxt acxt;
 	struct kernfs_node *kn;
 
 	if (!parent) {
@@ -971,7 +971,7 @@ static int sysfs_readdir(struct file *file, struct dir_context *ctx)
 	mutex_lock(&sysfs_mutex);
 
 	if (kernfs_ns_enabled(parent))
-		ns = sysfs_info(dentry->d_sb)->ns;
+		ns = kernfs_info(dentry->d_sb)->ns;
 
 	for (pos = sysfs_dir_pos(ns, parent, ctx->pos, pos);
 	     pos;
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 5277021..2714a39 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -18,27 +18,27 @@
 #include "kernfs-internal.h"
 
 /*
- * There's one sysfs_open_file for each open file and one sysfs_open_dirent
+ * There's one kernfs_open_file for each open file and one kernfs_open_node
  * for each kernfs_node with one or more open files.
  *
- * kernfs_node->attr.open points to sysfs_open_dirent.  attr.open is
- * protected by sysfs_open_dirent_lock.
+ * kernfs_node->attr.open points to kernfs_open_node.  attr.open is
+ * protected by kernfs_open_node_lock.
  *
  * filp->private_data points to seq_file whose ->private points to
- * sysfs_open_file.  sysfs_open_files are chained at
- * sysfs_open_dirent->files, which is protected by sysfs_open_file_mutex.
+ * kernfs_open_file.  kernfs_open_files are chained at
+ * kernfs_open_node->files, which is protected by kernfs_open_file_mutex.
  */
-static DEFINE_SPINLOCK(sysfs_open_dirent_lock);
-static DEFINE_MUTEX(sysfs_open_file_mutex);
+static DEFINE_SPINLOCK(kernfs_open_node_lock);
+static DEFINE_MUTEX(kernfs_open_file_mutex);
 
-struct sysfs_open_dirent {
+struct kernfs_open_node {
 	atomic_t		refcnt;
 	atomic_t		event;
 	wait_queue_head_t	poll;
-	struct list_head	files; /* goes through sysfs_open_file.list */
+	struct list_head	files; /* goes through kernfs_open_file.list */
 };
 
-static struct sysfs_open_file *sysfs_of(struct file *file)
+static struct kernfs_open_file *kernfs_of(struct file *file)
 {
 	return ((struct seq_file *)file->private_data)->private;
 }
@@ -56,7 +56,7 @@ static const struct kernfs_ops *kernfs_ops(struct kernfs_node *kn)
 
 static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
 {
-	struct sysfs_open_file *of = sf->private;
+	struct kernfs_open_file *of = sf->private;
 	const struct kernfs_ops *ops;
 
 	/*
@@ -81,7 +81,7 @@ static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
 
 static void *kernfs_seq_next(struct seq_file *sf, void *v, loff_t *ppos)
 {
-	struct sysfs_open_file *of = sf->private;
+	struct kernfs_open_file *of = sf->private;
 	const struct kernfs_ops *ops = kernfs_ops(of->kn);
 
 	if (ops->seq_next) {
@@ -98,7 +98,7 @@ static void *kernfs_seq_next(struct seq_file *sf, void *v, loff_t *ppos)
 
 static void kernfs_seq_stop(struct seq_file *sf, void *v)
 {
-	struct sysfs_open_file *of = sf->private;
+	struct kernfs_open_file *of = sf->private;
 	const struct kernfs_ops *ops = kernfs_ops(of->kn);
 
 	if (ops->seq_stop)
@@ -110,7 +110,7 @@ static void kernfs_seq_stop(struct seq_file *sf, void *v)
 
 static int kernfs_seq_show(struct seq_file *sf, void *v)
 {
-	struct sysfs_open_file *of = sf->private;
+	struct kernfs_open_file *of = sf->private;
 
 	of->event = atomic_read(&of->kn->attr.open->event);
 
@@ -130,7 +130,7 @@ static const struct seq_operations kernfs_seq_ops = {
  * it difficult to use seq_file.  Implement simplistic custom buffering for
  * bin files.
  */
-static ssize_t kernfs_file_direct_read(struct sysfs_open_file *of,
+static ssize_t kernfs_file_direct_read(struct kernfs_open_file *of,
 				       char __user *user_buf, size_t count,
 				       loff_t *ppos)
 {
@@ -187,7 +187,7 @@ static ssize_t kernfs_file_direct_read(struct sysfs_open_file *of,
 static ssize_t kernfs_file_read(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
-	struct sysfs_open_file *of = sysfs_of(file);
+	struct kernfs_open_file *of = kernfs_of(file);
 
 	if (of->kn->flags & SYSFS_FLAG_HAS_SEQ_SHOW)
 		return seq_read(file, user_buf, count, ppos);
@@ -214,7 +214,7 @@ static ssize_t kernfs_file_read(struct file *file, char __user *user_buf,
 static ssize_t kernfs_file_write(struct file *file, const char __user *user_buf,
 				 size_t count, loff_t *ppos)
 {
-	struct sysfs_open_file *of = sysfs_of(file);
+	struct kernfs_open_file *of = kernfs_of(file);
 	ssize_t len = min_t(size_t, count, PAGE_SIZE);
 	const struct kernfs_ops *ops;
 	char *buf;
@@ -259,7 +259,7 @@ out_free:
 static void kernfs_vma_open(struct vm_area_struct *vma)
 {
 	struct file *file = vma->vm_file;
-	struct sysfs_open_file *of = sysfs_of(file);
+	struct kernfs_open_file *of = kernfs_of(file);
 
 	if (!of->vm_ops)
 		return;
@@ -276,7 +276,7 @@ static void kernfs_vma_open(struct vm_area_struct *vma)
 static int kernfs_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
-	struct sysfs_open_file *of = sysfs_of(file);
+	struct kernfs_open_file *of = kernfs_of(file);
 	int ret;
 
 	if (!of->vm_ops)
@@ -297,7 +297,7 @@ static int kernfs_vma_page_mkwrite(struct vm_area_struct *vma,
 				   struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
-	struct sysfs_open_file *of = sysfs_of(file);
+	struct kernfs_open_file *of = kernfs_of(file);
 	int ret;
 
 	if (!of->vm_ops)
@@ -320,7 +320,7 @@ static int kernfs_vma_access(struct vm_area_struct *vma, unsigned long addr,
 			     void *buf, int len, int write)
 {
 	struct file *file = vma->vm_file;
-	struct sysfs_open_file *of = sysfs_of(file);
+	struct kernfs_open_file *of = kernfs_of(file);
 	int ret;
 
 	if (!of->vm_ops)
@@ -342,7 +342,7 @@ static int kernfs_vma_set_policy(struct vm_area_struct *vma,
 				 struct mempolicy *new)
 {
 	struct file *file = vma->vm_file;
-	struct sysfs_open_file *of = sysfs_of(file);
+	struct kernfs_open_file *of = kernfs_of(file);
 	int ret;
 
 	if (!of->vm_ops)
@@ -363,7 +363,7 @@ static struct mempolicy *kernfs_vma_get_policy(struct vm_area_struct *vma,
 					       unsigned long addr)
 {
 	struct file *file = vma->vm_file;
-	struct sysfs_open_file *of = sysfs_of(file);
+	struct kernfs_open_file *of = kernfs_of(file);
 	struct mempolicy *pol;
 
 	if (!of->vm_ops)
@@ -385,7 +385,7 @@ static int kernfs_vma_migrate(struct vm_area_struct *vma,
 			      unsigned long flags)
 {
 	struct file *file = vma->vm_file;
-	struct sysfs_open_file *of = sysfs_of(file);
+	struct kernfs_open_file *of = kernfs_of(file);
 	int ret;
 
 	if (!of->vm_ops)
@@ -417,7 +417,7 @@ static const struct vm_operations_struct kernfs_vm_ops = {
 
 static int kernfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct sysfs_open_file *of = sysfs_of(file);
+	struct kernfs_open_file *of = kernfs_of(file);
 	const struct kernfs_ops *ops;
 	int rc;
 
@@ -473,9 +473,9 @@ out_unlock:
 }
 
 /**
- *	sysfs_get_open_dirent - get or create sysfs_open_dirent
+ *	sysfs_get_open_dirent - get or create kernfs_open_node
  *	@kn: target kernfs_node
- *	@of: sysfs_open_file for this instance of open
+ *	@of: kernfs_open_file for this instance of open
  *
  *	If @kn->attr.open exists, increment its reference count; otherwise,
  *	create one.  @of is chained to the files list.
@@ -487,49 +487,49 @@ out_unlock:
  *	0 on success, -errno on failure.
  */
 static int sysfs_get_open_dirent(struct kernfs_node *kn,
-				 struct sysfs_open_file *of)
+				 struct kernfs_open_file *of)
 {
-	struct sysfs_open_dirent *od, *new_od = NULL;
+	struct kernfs_open_node *on, *new_on = NULL;
 
  retry:
-	mutex_lock(&sysfs_open_file_mutex);
-	spin_lock_irq(&sysfs_open_dirent_lock);
+	mutex_lock(&kernfs_open_file_mutex);
+	spin_lock_irq(&kernfs_open_node_lock);
 
-	if (!kn->attr.open && new_od) {
-		kn->attr.open = new_od;
-		new_od = NULL;
+	if (!kn->attr.open && new_on) {
+		kn->attr.open = new_on;
+		new_on = NULL;
 	}
 
-	od = kn->attr.open;
-	if (od) {
-		atomic_inc(&od->refcnt);
-		list_add_tail(&of->list, &od->files);
+	on = kn->attr.open;
+	if (on) {
+		atomic_inc(&on->refcnt);
+		list_add_tail(&of->list, &on->files);
 	}
 
-	spin_unlock_irq(&sysfs_open_dirent_lock);
-	mutex_unlock(&sysfs_open_file_mutex);
+	spin_unlock_irq(&kernfs_open_node_lock);
+	mutex_unlock(&kernfs_open_file_mutex);
 
-	if (od) {
-		kfree(new_od);
+	if (on) {
+		kfree(new_on);
 		return 0;
 	}
 
 	/* not there, initialize a new one and retry */
-	new_od = kmalloc(sizeof(*new_od), GFP_KERNEL);
-	if (!new_od)
+	new_on = kmalloc(sizeof(*new_on), GFP_KERNEL);
+	if (!new_on)
 		return -ENOMEM;
 
-	atomic_set(&new_od->refcnt, 0);
-	atomic_set(&new_od->event, 1);
-	init_waitqueue_head(&new_od->poll);
-	INIT_LIST_HEAD(&new_od->files);
+	atomic_set(&new_on->refcnt, 0);
+	atomic_set(&new_on->event, 1);
+	init_waitqueue_head(&new_on->poll);
+	INIT_LIST_HEAD(&new_on->files);
 	goto retry;
 }
 
 /**
- *	sysfs_put_open_dirent - put sysfs_open_dirent
+ *	sysfs_put_open_dirent - put kernfs_open_node
  *	@kn: target kernfs_nodet
- *	@of: associated sysfs_open_file
+ *	@of: associated kernfs_open_file
  *
  *	Put @kn->attr.open and unlink @of from the files list.  If
  *	reference count reaches zero, disassociate and free it.
@@ -538,33 +538,33 @@ static int sysfs_get_open_dirent(struct kernfs_node *kn,
  *	None.
  */
 static void sysfs_put_open_dirent(struct kernfs_node *kn,
-				  struct sysfs_open_file *of)
+				  struct kernfs_open_file *of)
 {
-	struct sysfs_open_dirent *od = kn->attr.open;
+	struct kernfs_open_node *on = kn->attr.open;
 	unsigned long flags;
 
-	mutex_lock(&sysfs_open_file_mutex);
-	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
+	mutex_lock(&kernfs_open_file_mutex);
+	spin_lock_irqsave(&kernfs_open_node_lock, flags);
 
 	if (of)
 		list_del(&of->list);
 
-	if (atomic_dec_and_test(&od->refcnt))
+	if (atomic_dec_and_test(&on->refcnt))
 		kn->attr.open = NULL;
 	else
-		od = NULL;
+		on = NULL;
 
-	spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
-	mutex_unlock(&sysfs_open_file_mutex);
+	spin_unlock_irqrestore(&kernfs_open_node_lock, flags);
+	mutex_unlock(&kernfs_open_file_mutex);
 
-	kfree(od);
+	kfree(on);
 }
 
 static int kernfs_file_open(struct inode *inode, struct file *file)
 {
 	struct kernfs_node *kn = file->f_path.dentry->d_fsdata;
 	const struct kernfs_ops *ops;
-	struct sysfs_open_file *of;
+	struct kernfs_open_file *of;
 	bool has_read, has_write, has_mmap;
 	int error = -EACCES;
 
@@ -586,9 +586,9 @@ static int kernfs_file_open(struct inode *inode, struct file *file)
 	    (!(inode->i_mode & S_IRUGO) || !has_read))
 		goto err_out;
 
-	/* allocate a sysfs_open_file for the file */
+	/* allocate a kernfs_open_file for the file */
 	error = -ENOMEM;
-	of = kzalloc(sizeof(struct sysfs_open_file), GFP_KERNEL);
+	of = kzalloc(sizeof(struct kernfs_open_file), GFP_KERNEL);
 	if (!of)
 		goto err_out;
 
@@ -654,7 +654,7 @@ err_out:
 static int kernfs_file_release(struct inode *inode, struct file *filp)
 {
 	struct kernfs_node *kn = filp->f_path.dentry->d_fsdata;
-	struct sysfs_open_file *of = sysfs_of(filp);
+	struct kernfs_open_file *of = kernfs_of(filp);
 
 	sysfs_put_open_dirent(kn, of);
 	seq_release(inode, filp);
@@ -665,26 +665,26 @@ static int kernfs_file_release(struct inode *inode, struct file *filp)
 
 void sysfs_unmap_bin_file(struct kernfs_node *kn)
 {
-	struct sysfs_open_dirent *od;
-	struct sysfs_open_file *of;
+	struct kernfs_open_node *on;
+	struct kernfs_open_file *of;
 
 	if (!(kn->flags & SYSFS_FLAG_HAS_MMAP))
 		return;
 
-	spin_lock_irq(&sysfs_open_dirent_lock);
-	od = kn->attr.open;
-	if (od)
-		atomic_inc(&od->refcnt);
-	spin_unlock_irq(&sysfs_open_dirent_lock);
-	if (!od)
+	spin_lock_irq(&kernfs_open_node_lock);
+	on = kn->attr.open;
+	if (on)
+		atomic_inc(&on->refcnt);
+	spin_unlock_irq(&kernfs_open_node_lock);
+	if (!on)
 		return;
 
-	mutex_lock(&sysfs_open_file_mutex);
-	list_for_each_entry(of, &od->files, list) {
+	mutex_lock(&kernfs_open_file_mutex);
+	list_for_each_entry(of, &on->files, list) {
 		struct inode *inode = file_inode(of->file);
 		unmap_mapping_range(inode->i_mapping, 0, 0, 1);
 	}
-	mutex_unlock(&sysfs_open_file_mutex);
+	mutex_unlock(&kernfs_open_file_mutex);
 
 	sysfs_put_open_dirent(kn, NULL);
 }
@@ -704,19 +704,19 @@ void sysfs_unmap_bin_file(struct kernfs_node *kn)
  */
 static unsigned int kernfs_file_poll(struct file *filp, poll_table *wait)
 {
-	struct sysfs_open_file *of = sysfs_of(filp);
+	struct kernfs_open_file *of = kernfs_of(filp);
 	struct kernfs_node *kn = filp->f_path.dentry->d_fsdata;
-	struct sysfs_open_dirent *od = kn->attr.open;
+	struct kernfs_open_node *on = kn->attr.open;
 
 	/* need parent for the kobj, grab both */
 	if (!sysfs_get_active(kn))
 		goto trigger;
 
-	poll_wait(filp, &od->poll, wait);
+	poll_wait(filp, &on->poll, wait);
 
 	sysfs_put_active(kn);
 
-	if (of->event != atomic_read(&od->event))
+	if (of->event != atomic_read(&on->event))
 		goto trigger;
 
 	return DEFAULT_POLLMASK;
@@ -733,20 +733,20 @@ static unsigned int kernfs_file_poll(struct file *filp, poll_table *wait)
  */
 void kernfs_notify(struct kernfs_node *kn)
 {
-	struct sysfs_open_dirent *od;
+	struct kernfs_open_node *on;
 	unsigned long flags;
 
-	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
+	spin_lock_irqsave(&kernfs_open_node_lock, flags);
 
 	if (!WARN_ON(sysfs_type(kn) != SYSFS_KOBJ_ATTR)) {
-		od = kn->attr.open;
-		if (od) {
-			atomic_inc(&od->event);
-			wake_up_interruptible(&od->poll);
+		on = kn->attr.open;
+		if (on) {
+			atomic_inc(&on->event);
+			wake_up_interruptible(&on->poll);
 		}
 	}
 
-	spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
+	spin_unlock_irqrestore(&kernfs_open_node_lock, flags);
 }
 EXPORT_SYMBOL_GPL(kernfs_notify);
 
@@ -780,7 +780,7 @@ struct kernfs_node *kernfs_create_file_ns_key(struct kernfs_node *parent,
 					      void *priv, const void *ns,
 					      struct lock_class_key *key)
 {
-	struct sysfs_addrm_cxt acxt;
+	struct kernfs_addrm_cxt acxt;
 	struct kernfs_node *kn;
 	int rc;
 
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index f6c0aae..a0e0038 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -46,14 +46,14 @@ void __init sysfs_inode_init(void)
 		panic("failed to init sysfs_backing_dev_info");
 }
 
-static struct sysfs_inode_attrs *sysfs_inode_attrs(struct kernfs_node *kn)
+static struct kernfs_iattrs *kernfs_iattrs(struct kernfs_node *kn)
 {
 	struct iattr *iattrs;
 
 	if (kn->iattr)
 		return kn->iattr;
 
-	kn->iattr = kzalloc(sizeof(struct sysfs_inode_attrs), GFP_KERNEL);
+	kn->iattr = kzalloc(sizeof(struct kernfs_iattrs), GFP_KERNEL);
 	if (!kn->iattr)
 		return NULL;
 	iattrs = &kn->iattr->ia_iattr;
@@ -71,11 +71,11 @@ static struct sysfs_inode_attrs *sysfs_inode_attrs(struct kernfs_node *kn)
 
 static int __kernfs_setattr(struct kernfs_node *kn, const struct iattr *iattr)
 {
-	struct sysfs_inode_attrs *attrs;
+	struct kernfs_iattrs *attrs;
 	struct iattr *iattrs;
 	unsigned int ia_valid = iattr->ia_valid;
 
-	attrs = sysfs_inode_attrs(kn);
+	attrs = kernfs_iattrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
@@ -144,11 +144,11 @@ out:
 static int sysfs_sd_setsecdata(struct kernfs_node *kn, void **secdata,
 			       u32 *secdata_len)
 {
-	struct sysfs_inode_attrs *attrs;
+	struct kernfs_iattrs *attrs;
 	void *old_secdata;
 	size_t old_secdata_len;
 
-	attrs = sysfs_inode_attrs(kn);
+	attrs = kernfs_iattrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
@@ -167,12 +167,12 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
-	struct sysfs_inode_attrs *attrs;
+	struct kernfs_iattrs *attrs;
 	void *secdata;
 	int error;
 	u32 secdata_len = 0;
 
-	attrs = sysfs_inode_attrs(kn);
+	attrs = kernfs_iattrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
@@ -205,9 +205,9 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 int sysfs_removexattr(struct dentry *dentry, const char *name)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
-	struct sysfs_inode_attrs *attrs;
+	struct kernfs_iattrs *attrs;
 
-	attrs = sysfs_inode_attrs(kn);
+	attrs = kernfs_iattrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
@@ -218,9 +218,9 @@ ssize_t sysfs_getxattr(struct dentry *dentry, const char *name, void *buf,
 		       size_t size)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
-	struct sysfs_inode_attrs *attrs;
+	struct kernfs_iattrs *attrs;
 
-	attrs = sysfs_inode_attrs(kn);
+	attrs = kernfs_iattrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
@@ -230,9 +230,9 @@ ssize_t sysfs_getxattr(struct dentry *dentry, const char *name, void *buf,
 ssize_t sysfs_listxattr(struct dentry *dentry, char *buf, size_t size)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
-	struct sysfs_inode_attrs *attrs;
+	struct kernfs_iattrs *attrs;
 
-	attrs = sysfs_inode_attrs(kn);
+	attrs = kernfs_iattrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
@@ -256,7 +256,7 @@ static inline void set_inode_attr(struct inode *inode, struct iattr *iattr)
 
 static void sysfs_refresh_inode(struct kernfs_node *kn, struct inode *inode)
 {
-	struct sysfs_inode_attrs *attrs = kn->iattr;
+	struct kernfs_iattrs *attrs = kn->iattr;
 
 	inode->i_mode = kn->mode;
 	if (attrs) {
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 2dbb1cb..573f669 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -18,7 +18,7 @@
 
 #include <linux/kernfs.h>
 
-struct sysfs_inode_attrs {
+struct kernfs_iattrs {
 	struct iattr		ia_iattr;
 	void			*ia_secdata;
 	u32			ia_secdata_len;
@@ -47,14 +47,14 @@ static inline struct kernfs_root *kernfs_root(struct kernfs_node *kn)
 /*
  * Context structure to be used while adding/removing nodes.
  */
-struct sysfs_addrm_cxt {
+struct kernfs_addrm_cxt {
 	struct kernfs_node	*removed;
 };
 
 /*
  * mount.c
  */
-struct sysfs_super_info {
+struct kernfs_super_info {
 	/*
 	 * The root associated with this super_block.  Each super_block is
 	 * identified by the root and ns it's associated with.
@@ -63,13 +63,13 @@ struct sysfs_super_info {
 
 	/*
 	 * Each sb is associated with one namespace tag, currently the
-	 * network namespace of the task which mounted this sysfs instance.
-	 * If multiple tags become necessary, make the following an array
-	 * and compare kernfs_node tag against every entry.
+	 * network namespace of the task which mounted this kernfs
+	 * instance.  If multiple tags become necessary, make the following
+	 * an array and compare kernfs_node tag against every entry.
 	 */
 	const void		*ns;
 };
-#define sysfs_info(SB) ((struct sysfs_super_info *)(SB->s_fs_info))
+#define kernfs_info(SB) ((struct kernfs_super_info *)(SB->s_fs_info))
 
 extern struct kmem_cache *sysfs_dir_cachep;
 
@@ -100,10 +100,10 @@ extern const struct inode_operations sysfs_dir_inode_operations;
 
 struct kernfs_node *sysfs_get_active(struct kernfs_node *kn);
 void sysfs_put_active(struct kernfs_node *kn);
-void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt);
-int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct kernfs_node *kn,
+void sysfs_addrm_start(struct kernfs_addrm_cxt *acxt);
+int sysfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 		  struct kernfs_node *parent);
-void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
+void sysfs_addrm_finish(struct kernfs_addrm_cxt *acxt);
 struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
 				     const char *name, umode_t mode, int type);
 
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 9dbbf37..e0796dc 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -27,7 +27,7 @@ static const struct super_operations sysfs_ops = {
 
 static int sysfs_fill_super(struct super_block *sb)
 {
-	struct sysfs_super_info *info = sysfs_info(sb);
+	struct kernfs_super_info *info = kernfs_info(sb);
 	struct inode *inode;
 	struct dentry *root;
 
@@ -61,8 +61,8 @@ static int sysfs_fill_super(struct super_block *sb)
 
 static int sysfs_test_super(struct super_block *sb, void *data)
 {
-	struct sysfs_super_info *sb_info = sysfs_info(sb);
-	struct sysfs_super_info *info = data;
+	struct kernfs_super_info *sb_info = kernfs_info(sb);
+	struct kernfs_super_info *info = data;
 
 	return sb_info->root == info->root && sb_info->ns == info->ns;
 }
@@ -84,7 +84,7 @@ static int sysfs_set_super(struct super_block *sb, void *data)
  */
 const void *kernfs_super_ns(struct super_block *sb)
 {
-	struct sysfs_super_info *info = sysfs_info(sb);
+	struct kernfs_super_info *info = kernfs_info(sb);
 
 	return info->ns;
 }
@@ -107,7 +107,7 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 			       struct kernfs_root *root, const void *ns)
 {
 	struct super_block *sb;
-	struct sysfs_super_info *info;
+	struct kernfs_super_info *info;
 	int error;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
@@ -144,12 +144,12 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
  */
 void kernfs_kill_sb(struct super_block *sb)
 {
-	struct sysfs_super_info *info = sysfs_info(sb);
+	struct kernfs_super_info *info = kernfs_info(sb);
 	struct kernfs_node *root_kn = sb->s_root->d_fsdata;
 
 	/*
 	 * Remove the superblock from fs_supers/s_instances
-	 * so we can't find it, before freeing sysfs_super_info.
+	 * so we can't find it, before freeing kernfs_super_info.
 	 */
 	kill_anon_super(sb);
 	kfree(info);
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index 5ac1a57..f36e3f1 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -27,7 +27,7 @@ struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 				       struct kernfs_node *target)
 {
 	struct kernfs_node *kn;
-	struct sysfs_addrm_cxt acxt;
+	struct kernfs_addrm_cxt acxt;
 	int error;
 
 	kn = sysfs_new_dirent(kernfs_root(parent), name, S_IFLNK|S_IRWXUGO,
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 887703a..fd104b2 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -41,7 +41,7 @@ static const struct sysfs_ops *sysfs_file_ops(struct kernfs_node *kn)
  */
 static int sysfs_kf_seq_show(struct seq_file *sf, void *v)
 {
-	struct sysfs_open_file *of = sf->private;
+	struct kernfs_open_file *of = sf->private;
 	struct kobject *kobj = of->kn->parent->priv;
 	const struct sysfs_ops *ops = sysfs_file_ops(of->kn);
 	ssize_t count;
@@ -78,7 +78,7 @@ static int sysfs_kf_seq_show(struct seq_file *sf, void *v)
 	return 0;
 }
 
-static ssize_t sysfs_kf_bin_read(struct sysfs_open_file *of, char *buf,
+static ssize_t sysfs_kf_bin_read(struct kernfs_open_file *of, char *buf,
 				 size_t count, loff_t pos)
 {
 	struct bin_attribute *battr = of->kn->priv;
@@ -102,7 +102,7 @@ static ssize_t sysfs_kf_bin_read(struct sysfs_open_file *of, char *buf,
 }
 
 /* kernfs write callback for regular sysfs files */
-static ssize_t sysfs_kf_write(struct sysfs_open_file *of, char *buf,
+static ssize_t sysfs_kf_write(struct kernfs_open_file *of, char *buf,
 			      size_t count, loff_t pos)
 {
 	const struct sysfs_ops *ops = sysfs_file_ops(of->kn);
@@ -115,7 +115,7 @@ static ssize_t sysfs_kf_write(struct sysfs_open_file *of, char *buf,
 }
 
 /* kernfs write callback for bin sysfs files */
-static ssize_t sysfs_kf_bin_write(struct sysfs_open_file *of, char *buf,
+static ssize_t sysfs_kf_bin_write(struct kernfs_open_file *of, char *buf,
 				  size_t count, loff_t pos)
 {
 	struct bin_attribute *battr = of->kn->priv;
@@ -136,7 +136,7 @@ static ssize_t sysfs_kf_bin_write(struct sysfs_open_file *of, char *buf,
 	return battr->write(of->file, kobj, battr, buf, pos, count);
 }
 
-static int sysfs_kf_bin_mmap(struct sysfs_open_file *of,
+static int sysfs_kf_bin_mmap(struct kernfs_open_file *of,
 			     struct vm_area_struct *vma)
 {
 	struct bin_attribute *battr = of->kn->priv;
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 092469f..757647c 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -24,8 +24,8 @@ struct vm_area_struct;
 struct super_block;
 struct file_system_type;
 
-struct sysfs_open_dirent;
-struct sysfs_inode_attrs;
+struct kernfs_open_node;
+struct kernfs_iattrs;
 
 enum kernfs_node_type {
 	SYSFS_DIR		= 0x0001,
@@ -65,7 +65,7 @@ struct kernfs_elem_symlink {
 
 struct kernfs_elem_attr {
 	const struct kernfs_ops	*ops;
-	struct sysfs_open_dirent *open;
+	struct kernfs_open_node	*open;
 	loff_t			size;
 };
 
@@ -108,7 +108,7 @@ struct kernfs_node {
 	unsigned short		flags;
 	umode_t			mode;
 	unsigned int		ino;
-	struct sysfs_inode_attrs *iattr;
+	struct kernfs_iattrs	*iattr;
 };
 
 struct kernfs_root {
@@ -119,7 +119,7 @@ struct kernfs_root {
 	struct ida		ino_ida;
 };
 
-struct sysfs_open_file {
+struct kernfs_open_file {
 	/* published fields */
 	struct kernfs_node	*kn;
 	struct file		*file;
@@ -140,7 +140,7 @@ struct kernfs_ops {
 	 * If seq_show() is present, seq_file path is active.  Other seq
 	 * operations are optional and if not implemented, the behavior is
 	 * equivalent to single_open().  @sf->private points to the
-	 * associated sysfs_open_file.
+	 * associated kernfs_open_file.
 	 *
 	 * read() is bounced through kernel buffer and a read larger than
 	 * PAGE_SIZE results in partial operation of PAGE_SIZE.
@@ -151,17 +151,17 @@ struct kernfs_ops {
 	void *(*seq_next)(struct seq_file *sf, void *v, loff_t *ppos);
 	void (*seq_stop)(struct seq_file *sf, void *v);
 
-	ssize_t (*read)(struct sysfs_open_file *of, char *buf, size_t bytes,
+	ssize_t (*read)(struct kernfs_open_file *of, char *buf, size_t bytes,
 			loff_t off);
 
 	/*
 	 * write() is bounced through kernel buffer and a write larger than
 	 * PAGE_SIZE results in partial operation of PAGE_SIZE.
 	 */
-	ssize_t (*write)(struct sysfs_open_file *of, char *buf, size_t bytes,
+	ssize_t (*write)(struct kernfs_open_file *of, char *buf, size_t bytes,
 			 loff_t off);
 
-	int (*mmap)(struct sysfs_open_file *of, struct vm_area_struct *vma);
+	int (*mmap)(struct kernfs_open_file *of, struct vm_area_struct *vma);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lock_class_key	lockdep_key;
-- 
1.8.4.2

