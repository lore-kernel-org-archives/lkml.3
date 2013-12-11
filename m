Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3LKTN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:13:56 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:61224 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3LKTMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:12:50 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, linus.walleij@linaro.org,
        ashutosh.dixit@intel.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] kernfs: s/sysfs/kernfs/ in global variables
Date: Wed, 11 Dec 2013 14:11:57 -0500
Message-Id: <1386789118-24733-6-git-send-email-tj@kernel.org>
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

* s/sysfs_mutex/kernfs_mutex/
* s/sysfs_dentry_ops/kernfs_dops/
* s/sysfs_dir_operations/kernfs_dir_fops/
* s/sysfs_dir_inode_operations/kernfs_dir_iops/
* s/kernfs_file_operations/kernfs_file_fops/ - renamed for consistency
* s/sysfs_symlink_inode_operations/kernfs_symlink_iops/
* s/sysfs_aops/kernfs_aops/
* s/sysfs_backing_dev_info/kernfs_bdi/
* s/sysfs_inode_operations/kernfs_iops/
* s/sysfs_dir_cachep/kernfs_node_cache/
* s/sysfs_ops/kernfs_sops/

This patch is strictly rename only and doesn't introduce any
functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             | 64 ++++++++++++++++++++++-----------------------
 fs/kernfs/file.c            |  2 +-
 fs/kernfs/inode.c           | 46 ++++++++++++++++----------------
 fs/kernfs/kernfs-internal.h | 14 +++++-----
 fs/kernfs/mount.c           | 14 +++++-----
 fs/kernfs/symlink.c         |  6 ++---
 6 files changed, 73 insertions(+), 73 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index bc8a3b3..d3c6623 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -17,7 +17,7 @@
 
 #include "kernfs-internal.h"
 
-DEFINE_MUTEX(sysfs_mutex);
+DEFINE_MUTEX(kernfs_mutex);
 
 #define rb_to_kn(X) rb_entry((X), struct kernfs_node, rb)
 
@@ -68,7 +68,7 @@ static int sysfs_sd_compare(const struct kernfs_node *left,
  *	@kn->parent->dir.children.
  *
  *	Locking:
- *	mutex_lock(sysfs_mutex)
+ *	mutex_lock(kernfs_mutex)
  *
  *	RETURNS:
  *	0 on susccess -EEXIST on failure.
@@ -109,7 +109,7 @@ static int sysfs_link_sibling(struct kernfs_node *kn)
  *	kn->parent->dir.children.
  *
  *	Locking:
- *	mutex_lock(sysfs_mutex)
+ *	mutex_lock(kernfs_mutex)
  */
 static void sysfs_unlink_sibling(struct kernfs_node *kn)
 {
@@ -251,7 +251,7 @@ void kernfs_put(struct kernfs_node *kn)
 	}
 	kfree(kn->iattr);
 	ida_simple_remove(&root->ino_ida, kn->ino);
-	kmem_cache_free(sysfs_dir_cachep, kn);
+	kmem_cache_free(kernfs_node_cache, kn);
 
 	kn = parent;
 	if (kn) {
@@ -279,7 +279,7 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 		return -ECHILD;
 
 	kn = dentry->d_fsdata;
-	mutex_lock(&sysfs_mutex);
+	mutex_lock(&kernfs_mutex);
 
 	/* The sysfs dirent has been deleted */
 	if (kn->flags & KERNFS_REMOVED)
@@ -298,7 +298,7 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 	    kernfs_info(dentry->d_sb)->ns != kn->ns)
 		goto out_bad;
 
-	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&kernfs_mutex);
 out_valid:
 	return 1;
 out_bad:
@@ -312,7 +312,7 @@ out_bad:
 	 * is performed at its new name the dentry will be readded
 	 * to the dcache hashes.
 	 */
-	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&kernfs_mutex);
 
 	/* If we have submounts we must allow the vfs caches
 	 * to lie about the state of the filesystem to prevent
@@ -329,7 +329,7 @@ static void sysfs_dentry_release(struct dentry *dentry)
 	kernfs_put(dentry->d_fsdata);
 }
 
-const struct dentry_operations sysfs_dentry_ops = {
+const struct dentry_operations kernfs_dops = {
 	.d_revalidate	= sysfs_dentry_revalidate,
 	.d_delete	= sysfs_dentry_delete,
 	.d_release	= sysfs_dentry_release,
@@ -348,7 +348,7 @@ struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
 			return NULL;
 	}
 
-	kn = kmem_cache_zalloc(sysfs_dir_cachep, GFP_KERNEL);
+	kn = kmem_cache_zalloc(kernfs_node_cache, GFP_KERNEL);
 	if (!kn)
 		goto err_out1;
 
@@ -367,7 +367,7 @@ struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
 	return kn;
 
  err_out2:
-	kmem_cache_free(sysfs_dir_cachep, kn);
+	kmem_cache_free(kernfs_node_cache, kn);
  err_out1:
 	kfree(dup_name);
 	return NULL;
@@ -378,19 +378,19 @@ struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
  *	@acxt: pointer to kernfs_addrm_cxt to be used
  *
  *	This function is called when the caller is about to add or remove
- *	kernfs_node.  This function acquires sysfs_mutex.  @acxt is used to
- *	keep and pass context to other addrm functions.
+ *	kernfs_node.  This function acquires kernfs_mutex.  @acxt is used
+ *	to keep and pass context to other addrm functions.
  *
  *	LOCKING:
- *	Kernel thread context (may sleep).  sysfs_mutex is locked on
+ *	Kernel thread context (may sleep).  kernfs_mutex is locked on
  *	return.
  */
 void sysfs_addrm_start(struct kernfs_addrm_cxt *acxt)
-	__acquires(sysfs_mutex)
+	__acquires(kernfs_mutex)
 {
 	memset(acxt, 0, sizeof(*acxt));
 
-	mutex_lock(&sysfs_mutex);
+	mutex_lock(&kernfs_mutex);
 }
 
 /**
@@ -503,13 +503,13 @@ static void sysfs_remove_one(struct kernfs_addrm_cxt *acxt,
  *	cleaned up.
  *
  *	LOCKING:
- *	sysfs_mutex is released.
+ *	kernfs_mutex is released.
  */
 void sysfs_addrm_finish(struct kernfs_addrm_cxt *acxt)
-	__releases(sysfs_mutex)
+	__releases(kernfs_mutex)
 {
 	/* release resources acquired by sysfs_addrm_start() */
-	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&kernfs_mutex);
 
 	/* kill removed kernfs_nodes */
 	while (acxt->removed) {
@@ -540,7 +540,7 @@ static struct kernfs_node *kernfs_find_ns(struct kernfs_node *parent,
 	bool has_ns = kernfs_ns_enabled(parent);
 	unsigned int hash;
 
-	lockdep_assert_held(&sysfs_mutex);
+	lockdep_assert_held(&kernfs_mutex);
 
 	if (has_ns != (bool)ns) {
 		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
@@ -580,10 +580,10 @@ struct kernfs_node *kernfs_find_and_get_ns(struct kernfs_node *parent,
 {
 	struct kernfs_node *kn;
 
-	mutex_lock(&sysfs_mutex);
+	mutex_lock(&kernfs_mutex);
 	kn = kernfs_find_ns(parent, name, ns);
 	kernfs_get(kn);
-	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&kernfs_mutex);
 
 	return kn;
 }
@@ -683,7 +683,7 @@ static struct dentry *sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	struct inode *inode;
 	const void *ns = NULL;
 
-	mutex_lock(&sysfs_mutex);
+	mutex_lock(&kernfs_mutex);
 
 	if (kernfs_ns_enabled(parent))
 		ns = kernfs_info(dir->i_sb)->ns;
@@ -708,11 +708,11 @@ static struct dentry *sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	/* instantiate and hash dentry */
 	ret = d_materialise_unique(dentry, inode);
  out_unlock:
-	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&kernfs_mutex);
 	return ret;
 }
 
-const struct inode_operations sysfs_dir_inode_operations = {
+const struct inode_operations kernfs_dir_iops = {
 	.lookup		= sysfs_lookup,
 	.permission	= sysfs_permission,
 	.setattr	= sysfs_setattr,
@@ -759,7 +759,7 @@ static struct kernfs_node *sysfs_next_descendant_post(struct kernfs_node *pos,
 {
 	struct rb_node *rbn;
 
-	lockdep_assert_held(&sysfs_mutex);
+	lockdep_assert_held(&kernfs_mutex);
 
 	/* if first iteration, visit leftmost descendant which may be root */
 	if (!pos)
@@ -859,7 +859,7 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 {
 	int error;
 
-	mutex_lock(&sysfs_mutex);
+	mutex_lock(&kernfs_mutex);
 
 	error = 0;
 	if ((kn->parent == new_parent) && (kn->ns == new_ns) &&
@@ -894,7 +894,7 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 
 	error = 0;
  out:
-	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&kernfs_mutex);
 	return error;
 }
 
@@ -968,7 +968,7 @@ static int sysfs_readdir(struct file *file, struct dir_context *ctx)
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
-	mutex_lock(&sysfs_mutex);
+	mutex_lock(&kernfs_mutex);
 
 	if (kernfs_ns_enabled(parent))
 		ns = kernfs_info(dentry->d_sb)->ns;
@@ -985,12 +985,12 @@ static int sysfs_readdir(struct file *file, struct dir_context *ctx)
 		file->private_data = pos;
 		kernfs_get(pos);
 
-		mutex_unlock(&sysfs_mutex);
+		mutex_unlock(&kernfs_mutex);
 		if (!dir_emit(ctx, name, len, ino, type))
 			return 0;
-		mutex_lock(&sysfs_mutex);
+		mutex_lock(&kernfs_mutex);
 	}
-	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&kernfs_mutex);
 	file->private_data = NULL;
 	ctx->pos = INT_MAX;
 	return 0;
@@ -1008,7 +1008,7 @@ static loff_t sysfs_dir_llseek(struct file *file, loff_t offset, int whence)
 	return ret;
 }
 
-const struct file_operations sysfs_dir_operations = {
+const struct file_operations kernfs_dir_fops = {
 	.read		= generic_read_dir,
 	.iterate	= sysfs_readdir,
 	.release	= sysfs_dir_release,
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index abe93e1..32364dd 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -750,7 +750,7 @@ void kernfs_notify(struct kernfs_node *kn)
 }
 EXPORT_SYMBOL_GPL(kernfs_notify);
 
-const struct file_operations kernfs_file_operations = {
+const struct file_operations kernfs_file_fops = {
 	.read		= kernfs_file_read,
 	.write		= kernfs_file_write,
 	.llseek		= generic_file_llseek,
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index af92638..c5f231e 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -18,19 +18,19 @@
 
 #include "kernfs-internal.h"
 
-static const struct address_space_operations sysfs_aops = {
+static const struct address_space_operations kernfs_aops = {
 	.readpage	= simple_readpage,
 	.write_begin	= simple_write_begin,
 	.write_end	= simple_write_end,
 };
 
-static struct backing_dev_info sysfs_backing_dev_info = {
-	.name		= "sysfs",
+static struct backing_dev_info kernfs_bdi = {
+	.name		= "kernfs",
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
-static const struct inode_operations sysfs_inode_operations = {
+static const struct inode_operations kernfs_iops = {
 	.permission	= sysfs_permission,
 	.setattr	= sysfs_setattr,
 	.getattr	= sysfs_getattr,
@@ -42,8 +42,8 @@ static const struct inode_operations sysfs_inode_operations = {
 
 void __init sysfs_inode_init(void)
 {
-	if (bdi_init(&sysfs_backing_dev_info))
-		panic("failed to init sysfs_backing_dev_info");
+	if (bdi_init(&kernfs_bdi))
+		panic("failed to init kernfs_bdi");
 }
 
 static struct kernfs_iattrs *kernfs_iattrs(struct kernfs_node *kn)
@@ -109,9 +109,9 @@ int kernfs_setattr(struct kernfs_node *kn, const struct iattr *iattr)
 {
 	int ret;
 
-	mutex_lock(&sysfs_mutex);
+	mutex_lock(&kernfs_mutex);
 	ret = __kernfs_setattr(kn, iattr);
-	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&kernfs_mutex);
 	return ret;
 }
 
@@ -124,7 +124,7 @@ int sysfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	if (!kn)
 		return -EINVAL;
 
-	mutex_lock(&sysfs_mutex);
+	mutex_lock(&kernfs_mutex);
 	error = inode_change_ok(inode, iattr);
 	if (error)
 		goto out;
@@ -137,7 +137,7 @@ int sysfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	setattr_copy(inode, iattr);
 
 out:
-	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&kernfs_mutex);
 	return error;
 }
 
@@ -187,9 +187,9 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		if (error)
 			return error;
 
-		mutex_lock(&sysfs_mutex);
+		mutex_lock(&kernfs_mutex);
 		error = sysfs_sd_setsecdata(kn, &secdata, &secdata_len);
-		mutex_unlock(&sysfs_mutex);
+		mutex_unlock(&kernfs_mutex);
 
 		if (secdata)
 			security_release_secctx(secdata, secdata_len);
@@ -279,9 +279,9 @@ int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	struct kernfs_node *kn = dentry->d_fsdata;
 	struct inode *inode = dentry->d_inode;
 
-	mutex_lock(&sysfs_mutex);
+	mutex_lock(&kernfs_mutex);
 	sysfs_refresh_inode(kn, inode);
-	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&kernfs_mutex);
 
 	generic_fillattr(inode, stat);
 	return 0;
@@ -291,9 +291,9 @@ static void sysfs_init_inode(struct kernfs_node *kn, struct inode *inode)
 {
 	kernfs_get(kn);
 	inode->i_private = kn;
-	inode->i_mapping->a_ops = &sysfs_aops;
-	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
-	inode->i_op = &sysfs_inode_operations;
+	inode->i_mapping->a_ops = &kernfs_aops;
+	inode->i_mapping->backing_dev_info = &kernfs_bdi;
+	inode->i_op = &kernfs_iops;
 
 	set_default_inode_attr(inode, kn->mode);
 	sysfs_refresh_inode(kn, inode);
@@ -301,15 +301,15 @@ static void sysfs_init_inode(struct kernfs_node *kn, struct inode *inode)
 	/* initialize inode according to type */
 	switch (kernfs_type(kn)) {
 	case KERNFS_DIR:
-		inode->i_op = &sysfs_dir_inode_operations;
-		inode->i_fop = &sysfs_dir_operations;
+		inode->i_op = &kernfs_dir_iops;
+		inode->i_fop = &kernfs_dir_fops;
 		break;
 	case KERNFS_FILE:
 		inode->i_size = kn->attr.size;
-		inode->i_fop = &kernfs_file_operations;
+		inode->i_fop = &kernfs_file_fops;
 		break;
 	case KERNFS_LINK:
-		inode->i_op = &sysfs_symlink_inode_operations;
+		inode->i_op = &kernfs_symlink_iops;
 		break;
 	default:
 		BUG();
@@ -369,9 +369,9 @@ int sysfs_permission(struct inode *inode, int mask)
 
 	kn = inode->i_private;
 
-	mutex_lock(&sysfs_mutex);
+	mutex_lock(&kernfs_mutex);
 	sysfs_refresh_inode(kn, inode);
-	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&kernfs_mutex);
 
 	return generic_permission(inode, mask);
 }
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index c4bf5bf..e62e8ec 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -71,7 +71,7 @@ struct kernfs_super_info {
 };
 #define kernfs_info(SB) ((struct kernfs_super_info *)(SB->s_fs_info))
 
-extern struct kmem_cache *sysfs_dir_cachep;
+extern struct kmem_cache *kernfs_node_cache;
 
 /*
  * inode.c
@@ -93,10 +93,10 @@ void sysfs_inode_init(void);
 /*
  * dir.c
  */
-extern struct mutex sysfs_mutex;
-extern const struct dentry_operations sysfs_dentry_ops;
-extern const struct file_operations sysfs_dir_operations;
-extern const struct inode_operations sysfs_dir_inode_operations;
+extern struct mutex kernfs_mutex;
+extern const struct dentry_operations kernfs_dops;
+extern const struct file_operations kernfs_dir_fops;
+extern const struct inode_operations kernfs_dir_iops;
 
 struct kernfs_node *sysfs_get_active(struct kernfs_node *kn);
 void sysfs_put_active(struct kernfs_node *kn);
@@ -110,13 +110,13 @@ struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
 /*
  * file.c
  */
-extern const struct file_operations kernfs_file_operations;
+extern const struct file_operations kernfs_file_fops;
 
 void sysfs_unmap_bin_file(struct kernfs_node *kn);
 
 /*
  * symlink.c
  */
-extern const struct inode_operations sysfs_symlink_inode_operations;
+extern const struct inode_operations kernfs_symlink_iops;
 
 #endif	/* __KERNFS_INTERNAL_H */
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index e0796dc..27d967b 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -17,9 +17,9 @@
 
 #include "kernfs-internal.h"
 
-struct kmem_cache *sysfs_dir_cachep;
+struct kmem_cache *kernfs_node_cache;
 
-static const struct super_operations sysfs_ops = {
+static const struct super_operations kernfs_sops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= sysfs_evict_inode,
@@ -34,13 +34,13 @@ static int sysfs_fill_super(struct super_block *sb)
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = SYSFS_MAGIC;
-	sb->s_op = &sysfs_ops;
+	sb->s_op = &kernfs_sops;
 	sb->s_time_gran = 1;
 
 	/* get root inode, initialize and unlock it */
-	mutex_lock(&sysfs_mutex);
+	mutex_lock(&kernfs_mutex);
 	inode = sysfs_get_inode(sb, info->root->kn);
-	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&kernfs_mutex);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
 		return -ENOMEM;
@@ -55,7 +55,7 @@ static int sysfs_fill_super(struct super_block *sb)
 	kernfs_get(info->root->kn);
 	root->d_fsdata = info->root->kn;
 	sb->s_root = root;
-	sb->s_d_op = &sysfs_dentry_ops;
+	sb->s_d_op = &kernfs_dops;
 	return 0;
 }
 
@@ -158,7 +158,7 @@ void kernfs_kill_sb(struct super_block *sb)
 
 void __init kernfs_init(void)
 {
-	sysfs_dir_cachep = kmem_cache_create("sysfs_dir_cache",
+	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
 					      sizeof(struct kernfs_node),
 					      0, SLAB_PANIC, NULL);
 	sysfs_inode_init();
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index a92284d..4105bd0 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -110,9 +110,9 @@ static int sysfs_getlink(struct dentry *dentry, char *path)
 	struct kernfs_node *target = kn->symlink.target_kn;
 	int error;
 
-	mutex_lock(&sysfs_mutex);
+	mutex_lock(&kernfs_mutex);
 	error = sysfs_get_target_path(parent, target, path);
-	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&kernfs_mutex);
 
 	return error;
 }
@@ -138,7 +138,7 @@ static void sysfs_put_link(struct dentry *dentry, struct nameidata *nd,
 		free_page((unsigned long)page);
 }
 
-const struct inode_operations sysfs_symlink_inode_operations = {
+const struct inode_operations kernfs_symlink_iops = {
 	.setxattr	= sysfs_setxattr,
 	.removexattr	= sysfs_removexattr,
 	.getxattr	= sysfs_getxattr,
-- 
1.8.4.2

