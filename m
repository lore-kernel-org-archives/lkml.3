Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3LKTM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:12:56 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:62827 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3LKTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:12:49 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, linus.walleij@linaro.org,
        ashutosh.dixit@intel.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] kernfs: s/sysfs/kernfs/ in constants
Date: Wed, 11 Dec 2013 14:11:56 -0500
Message-Id: <1386789118-24733-5-git-send-email-tj@kernel.org>
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

* s/SYSFS_DIR/KERNFS_DIR/
* s/SYSFS_KOBJ_ATTR/KERNFS_FILE/
* s/SYSFS_KOBJ_LINK/KERNFS_LINK/
* s/SYSFS_{TYPE_FLAGS}/KERNFS_{TYPE_FLAGS}/
* s/SYSFS_FLAG_{FLAG}/KERNFS_{FLAG}/
* s/sysfs_type()/kernfs_type()/
* s/SD_DEACTIVATED_BIAS/KN_DEACTIVATED_BIAS/

This patch is strictly rename only and doesn't introduce any
functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             | 50 ++++++++++++++++++++++-----------------------
 fs/kernfs/file.c            | 18 ++++++++--------
 fs/kernfs/inode.c           | 10 ++++-----
 fs/kernfs/kernfs-internal.h |  4 ++--
 fs/kernfs/symlink.c         |  2 +-
 fs/sysfs/dir.c              |  2 +-
 fs/sysfs/file.c             |  2 +-
 fs/sysfs/symlink.c          |  2 +-
 include/linux/kernfs.h      | 36 ++++++++++++++++----------------
 9 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index d038bb2..bc8a3b3 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -78,7 +78,7 @@ static int sysfs_link_sibling(struct kernfs_node *kn)
 	struct rb_node **node = &kn->parent->dir.children.rb_node;
 	struct rb_node *parent = NULL;
 
-	if (sysfs_type(kn) == SYSFS_DIR)
+	if (kernfs_type(kn) == KERNFS_DIR)
 		kn->parent->dir.subdirs++;
 
 	while (*node) {
@@ -113,7 +113,7 @@ static int sysfs_link_sibling(struct kernfs_node *kn)
  */
 static void sysfs_unlink_sibling(struct kernfs_node *kn)
 {
-	if (sysfs_type(kn) == SYSFS_DIR)
+	if (kernfs_type(kn) == KERNFS_DIR)
 		kn->parent->dir.subdirs--;
 
 	rb_erase(&kn->rb, &kn->parent->dir.children);
@@ -137,7 +137,7 @@ struct kernfs_node *sysfs_get_active(struct kernfs_node *kn)
 	if (!atomic_inc_unless_negative(&kn->active))
 		return NULL;
 
-	if (kn->flags & SYSFS_FLAG_LOCKDEP)
+	if (kn->flags & KERNFS_LOCKDEP)
 		rwsem_acquire_read(&kn->dep_map, 0, 1, _RET_IP_);
 	return kn;
 }
@@ -156,10 +156,10 @@ void sysfs_put_active(struct kernfs_node *kn)
 	if (unlikely(!kn))
 		return;
 
-	if (kn->flags & SYSFS_FLAG_LOCKDEP)
+	if (kn->flags & KERNFS_LOCKDEP)
 		rwsem_release(&kn->dep_map, 1, _RET_IP_);
 	v = atomic_dec_return(&kn->active);
-	if (likely(v != SD_DEACTIVATED_BIAS))
+	if (likely(v != KN_DEACTIVATED_BIAS))
 		return;
 
 	/*
@@ -180,9 +180,9 @@ static void sysfs_deactivate(struct kernfs_node *kn)
 	DECLARE_COMPLETION_ONSTACK(wait);
 	int v;
 
-	BUG_ON(!(kn->flags & SYSFS_FLAG_REMOVED));
+	BUG_ON(!(kn->flags & KERNFS_REMOVED));
 
-	if (!(sysfs_type(kn) & SYSFS_ACTIVE_REF))
+	if (!(kernfs_type(kn) & KERNFS_ACTIVE_REF))
 		return;
 
 	kn->u.completion = (void *)&wait;
@@ -191,9 +191,9 @@ static void sysfs_deactivate(struct kernfs_node *kn)
 	/* atomic_add_return() is a mb(), put_active() will always see
 	 * the updated kn->u.completion.
 	 */
-	v = atomic_add_return(SD_DEACTIVATED_BIAS, &kn->active);
+	v = atomic_add_return(KN_DEACTIVATED_BIAS, &kn->active);
 
-	if (v != SD_DEACTIVATED_BIAS) {
+	if (v != KN_DEACTIVATED_BIAS) {
 		lock_contended(&kn->dep_map, _RET_IP_);
 		wait_for_completion(&wait);
 	}
@@ -235,13 +235,13 @@ void kernfs_put(struct kernfs_node *kn)
 	 */
 	parent = kn->parent;
 
-	WARN(!(kn->flags & SYSFS_FLAG_REMOVED),
+	WARN(!(kn->flags & KERNFS_REMOVED),
 		"sysfs: free using entry: %s/%s\n",
 		parent ? parent->name : "", kn->name);
 
-	if (sysfs_type(kn) == SYSFS_KOBJ_LINK)
+	if (kernfs_type(kn) == KERNFS_LINK)
 		kernfs_put(kn->symlink.target_kn);
-	if (sysfs_type(kn) & SYSFS_COPY_NAME)
+	if (kernfs_type(kn) & KERNFS_COPY_NAME)
 		kfree(kn->name);
 	if (kn->iattr) {
 		if (kn->iattr->ia_secdata)
@@ -268,7 +268,7 @@ EXPORT_SYMBOL_GPL(kernfs_put);
 static int sysfs_dentry_delete(const struct dentry *dentry)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
-	return !(kn && !(kn->flags & SYSFS_FLAG_REMOVED));
+	return !(kn && !(kn->flags & KERNFS_REMOVED));
 }
 
 static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
@@ -282,7 +282,7 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 	mutex_lock(&sysfs_mutex);
 
 	/* The sysfs dirent has been deleted */
-	if (kn->flags & SYSFS_FLAG_REMOVED)
+	if (kn->flags & KERNFS_REMOVED)
 		goto out_bad;
 
 	/* The sysfs dirent has been moved? */
@@ -342,7 +342,7 @@ struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
 	struct kernfs_node *kn;
 	int ret;
 
-	if (type & SYSFS_COPY_NAME) {
+	if (type & KERNFS_COPY_NAME) {
 		name = dup_name = kstrdup(name, GFP_KERNEL);
 		if (!name)
 			return NULL;
@@ -362,7 +362,7 @@ struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
 
 	kn->name = name;
 	kn->mode = mode;
-	kn->flags = type | SYSFS_FLAG_REMOVED;
+	kn->flags = type | KERNFS_REMOVED;
 
 	return kn;
 
@@ -427,7 +427,7 @@ int sysfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 		return -EINVAL;
 	}
 
-	if (sysfs_type(parent) != SYSFS_DIR)
+	if (kernfs_type(parent) != KERNFS_DIR)
 		return -EINVAL;
 
 	kn->hash = sysfs_name_hash(kn->name, kn->ns);
@@ -446,7 +446,7 @@ int sysfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 	}
 
 	/* Mark the entry added into directory tree */
-	kn->flags &= ~SYSFS_FLAG_REMOVED;
+	kn->flags &= ~KERNFS_REMOVED;
 
 	return 0;
 }
@@ -475,7 +475,7 @@ static void sysfs_remove_one(struct kernfs_addrm_cxt *acxt,
 	 * Removal can be called multiple times on the same node.  Only the
 	 * first invocation is effective and puts the base ref.
 	 */
-	if (kn->flags & SYSFS_FLAG_REMOVED)
+	if (kn->flags & KERNFS_REMOVED)
 		return;
 
 	if (kn->parent) {
@@ -489,7 +489,7 @@ static void sysfs_remove_one(struct kernfs_addrm_cxt *acxt,
 		}
 	}
 
-	kn->flags |= SYSFS_FLAG_REMOVED;
+	kn->flags |= KERNFS_REMOVED;
 	kn->u.removed_list = acxt->removed;
 	acxt->removed = kn;
 }
@@ -607,14 +607,14 @@ struct kernfs_root *kernfs_create_root(void *priv)
 
 	ida_init(&root->ino_ida);
 
-	kn = sysfs_new_dirent(root, "", S_IFDIR | S_IRUGO | S_IXUGO, SYSFS_DIR);
+	kn = sysfs_new_dirent(root, "", S_IFDIR | S_IRUGO | S_IXUGO, KERNFS_DIR);
 	if (!kn) {
 		ida_destroy(&root->ino_ida);
 		kfree(root);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	kn->flags &= ~SYSFS_FLAG_REMOVED;
+	kn->flags &= ~KERNFS_REMOVED;
 	kn->priv = priv;
 	kn->dir.root = root;
 
@@ -654,7 +654,7 @@ struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
 	int rc;
 
 	/* allocate */
-	kn = sysfs_new_dirent(kernfs_root(parent), name, mode, SYSFS_DIR);
+	kn = sysfs_new_dirent(kernfs_root(parent), name, mode, KERNFS_DIR);
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
@@ -732,7 +732,7 @@ static struct kernfs_node *sysfs_leftmost_descendant(struct kernfs_node *pos)
 
 		last = pos;
 
-		if (sysfs_type(pos) != SYSFS_DIR)
+		if (kernfs_type(pos) != KERNFS_DIR)
 			break;
 
 		rbn = rb_first(&pos->dir.children);
@@ -914,7 +914,7 @@ static struct kernfs_node *sysfs_dir_pos(const void *ns,
 	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos)
 {
 	if (pos) {
-		int valid = !(pos->flags & SYSFS_FLAG_REMOVED) &&
+		int valid = !(pos->flags & KERNFS_REMOVED) &&
 			pos->parent == parent && hash == pos->hash;
 		kernfs_put(pos);
 		if (!valid)
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 2714a39..abe93e1 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -49,7 +49,7 @@ static struct kernfs_open_file *kernfs_of(struct file *file)
  */
 static const struct kernfs_ops *kernfs_ops(struct kernfs_node *kn)
 {
-	if (kn->flags & SYSFS_FLAG_LOCKDEP)
+	if (kn->flags & KERNFS_LOCKDEP)
 		lockdep_assert_held(kn);
 	return kn->attr.ops;
 }
@@ -189,7 +189,7 @@ static ssize_t kernfs_file_read(struct file *file, char __user *user_buf,
 {
 	struct kernfs_open_file *of = kernfs_of(file);
 
-	if (of->kn->flags & SYSFS_FLAG_HAS_SEQ_SHOW)
+	if (of->kn->flags & KERNFS_HAS_SEQ_SHOW)
 		return seq_read(file, user_buf, count, ppos);
 	else
 		return kernfs_file_direct_read(of, user_buf, count, ppos);
@@ -428,7 +428,7 @@ static int kernfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	 * without grabbing @of->mutex by testing HAS_MMAP flag.  See the
 	 * comment in kernfs_file_open() for more details.
 	 */
-	if (!(of->kn->flags & SYSFS_FLAG_HAS_MMAP))
+	if (!(of->kn->flags & KERNFS_HAS_MMAP))
 		return -ENODEV;
 
 	mutex_lock(&of->mutex);
@@ -668,7 +668,7 @@ void sysfs_unmap_bin_file(struct kernfs_node *kn)
 	struct kernfs_open_node *on;
 	struct kernfs_open_file *of;
 
-	if (!(kn->flags & SYSFS_FLAG_HAS_MMAP))
+	if (!(kn->flags & KERNFS_HAS_MMAP))
 		return;
 
 	spin_lock_irq(&kernfs_open_node_lock);
@@ -738,7 +738,7 @@ void kernfs_notify(struct kernfs_node *kn)
 
 	spin_lock_irqsave(&kernfs_open_node_lock, flags);
 
-	if (!WARN_ON(sysfs_type(kn) != SYSFS_KOBJ_ATTR)) {
+	if (!WARN_ON(kernfs_type(kn) != KERNFS_FILE)) {
 		on = kn->attr.open;
 		if (on) {
 			atomic_inc(&on->event);
@@ -785,7 +785,7 @@ struct kernfs_node *kernfs_create_file_ns_key(struct kernfs_node *parent,
 	int rc;
 
 	kn = sysfs_new_dirent(kernfs_root(parent), name,
-			      (mode & S_IALLUGO) | S_IFREG, SYSFS_KOBJ_ATTR);
+			      (mode & S_IALLUGO) | S_IFREG, KERNFS_FILE);
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
@@ -797,7 +797,7 @@ struct kernfs_node *kernfs_create_file_ns_key(struct kernfs_node *parent,
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	if (key) {
 		lockdep_init_map(&kn->dep_map, "s_active", key, 0);
-		kn->flags |= SYSFS_FLAG_LOCKDEP;
+		kn->flags |= KERNFS_LOCKDEP;
 	}
 #endif
 
@@ -807,9 +807,9 @@ struct kernfs_node *kernfs_create_file_ns_key(struct kernfs_node *parent,
 	 * ref.  Cache their existence in flags.
 	 */
 	if (ops->seq_show)
-		kn->flags |= SYSFS_FLAG_HAS_SEQ_SHOW;
+		kn->flags |= KERNFS_HAS_SEQ_SHOW;
 	if (ops->mmap)
-		kn->flags |= SYSFS_FLAG_HAS_MMAP;
+		kn->flags |= KERNFS_HAS_MMAP;
 
 	sysfs_addrm_start(&acxt);
 	rc = sysfs_add_one(&acxt, kn, parent);
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index a0e0038..af92638 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -269,7 +269,7 @@ static void sysfs_refresh_inode(struct kernfs_node *kn, struct inode *inode)
 					    attrs->ia_secdata_len);
 	}
 
-	if (sysfs_type(kn) == SYSFS_DIR)
+	if (kernfs_type(kn) == KERNFS_DIR)
 		set_nlink(inode, kn->dir.subdirs + 2);
 }
 
@@ -299,16 +299,16 @@ static void sysfs_init_inode(struct kernfs_node *kn, struct inode *inode)
 	sysfs_refresh_inode(kn, inode);
 
 	/* initialize inode according to type */
-	switch (sysfs_type(kn)) {
-	case SYSFS_DIR:
+	switch (kernfs_type(kn)) {
+	case KERNFS_DIR:
 		inode->i_op = &sysfs_dir_inode_operations;
 		inode->i_fop = &sysfs_dir_operations;
 		break;
-	case SYSFS_KOBJ_ATTR:
+	case KERNFS_FILE:
 		inode->i_size = kn->attr.size;
 		inode->i_fop = &kernfs_file_operations;
 		break;
-	case SYSFS_KOBJ_LINK:
+	case KERNFS_LINK:
 		inode->i_op = &sysfs_symlink_inode_operations;
 		break;
 	default:
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 573f669..c4bf5bf 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -26,9 +26,9 @@ struct kernfs_iattrs {
 	struct simple_xattrs	xattrs;
 };
 
-#define SD_DEACTIVATED_BIAS		INT_MIN
+#define KN_DEACTIVATED_BIAS		INT_MIN
 
-/* SYSFS_TYPE_MASK and types are defined in include/linux/kernfs.h */
+/* KERNFS_TYPE_MASK and types are defined in include/linux/kernfs.h */
 
 /**
  * kernfs_root - find out the kernfs_root a kernfs_node belongs to
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index f36e3f1..a92284d 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -31,7 +31,7 @@ struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 	int error;
 
 	kn = sysfs_new_dirent(kernfs_root(parent), name, S_IFLNK|S_IRWXUGO,
-			      SYSFS_KOBJ_LINK);
+			      KERNFS_LINK);
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 4a80001..aa00740 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -113,7 +113,7 @@ void sysfs_remove_dir(struct kobject *kobj)
 	spin_unlock(&sysfs_symlink_target_lock);
 
 	if (kn) {
-		WARN_ON_ONCE(sysfs_type(kn) != SYSFS_DIR);
+		WARN_ON_ONCE(kernfs_type(kn) != KERNFS_DIR);
 		kernfs_remove(kn);
 	}
 }
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index fd104b2..fe6388f 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -29,7 +29,7 @@ static const struct sysfs_ops *sysfs_file_ops(struct kernfs_node *kn)
 {
 	struct kobject *kobj = kn->parent->priv;
 
-	if (kn->flags & SYSFS_FLAG_LOCKDEP)
+	if (kn->flags & KERNFS_LOCKDEP)
 		lockdep_assert_held(kn);
 	return kobj->ktype ? kobj->ktype->sysfs_ops : NULL;
 }
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 0d48ea9..aecb15f 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -183,7 +183,7 @@ int sysfs_rename_link_ns(struct kobject *kobj, struct kobject *targ,
 		goto out;
 
 	result = -EINVAL;
-	if (sysfs_type(kn) != SYSFS_KOBJ_LINK)
+	if (kernfs_type(kn) != KERNFS_LINK)
 		goto out;
 	if (kn->symlink.target_kn->priv != targ)
 		goto out;
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 757647c..e9c4e3a 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -28,22 +28,22 @@ struct kernfs_open_node;
 struct kernfs_iattrs;
 
 enum kernfs_node_type {
-	SYSFS_DIR		= 0x0001,
-	SYSFS_KOBJ_ATTR		= 0x0002,
-	SYSFS_KOBJ_LINK		= 0x0004,
+	KERNFS_DIR		= 0x0001,
+	KERNFS_FILE		= 0x0002,
+	KERNFS_LINK		= 0x0004,
 };
 
-#define SYSFS_TYPE_MASK		0x000f
-#define SYSFS_COPY_NAME		(SYSFS_DIR | SYSFS_KOBJ_LINK)
-#define SYSFS_ACTIVE_REF	SYSFS_KOBJ_ATTR
-#define SYSFS_FLAG_MASK		~SYSFS_TYPE_MASK
+#define KERNFS_TYPE_MASK	0x000f
+#define KERNFS_COPY_NAME	(KERNFS_DIR | KERNFS_LINK)
+#define KERNFS_ACTIVE_REF	KERNFS_FILE
+#define KERNFS_FLAG_MASK	~KERNFS_TYPE_MASK
 
 enum kernfs_node_flag {
-	SYSFS_FLAG_REMOVED	= 0x0010,
-	SYSFS_FLAG_NS		= 0x0020,
-	SYSFS_FLAG_HAS_SEQ_SHOW	= 0x0040,
-	SYSFS_FLAG_HAS_MMAP	= 0x0080,
-	SYSFS_FLAG_LOCKDEP	= 0x0100,
+	KERNFS_REMOVED		= 0x0010,
+	KERNFS_NS		= 0x0020,
+	KERNFS_HAS_SEQ_SHOW	= 0x0040,
+	KERNFS_HAS_MMAP		= 0x0080,
+	KERNFS_LOCKDEP		= 0x0100,
 };
 
 /* type-specific structures for kernfs_node union members */
@@ -170,9 +170,9 @@ struct kernfs_ops {
 
 #ifdef CONFIG_SYSFS
 
-static inline enum kernfs_node_type sysfs_type(struct kernfs_node *kn)
+static inline enum kernfs_node_type kernfs_type(struct kernfs_node *kn)
 {
-	return kn->flags & SYSFS_TYPE_MASK;
+	return kn->flags & KERNFS_TYPE_MASK;
 }
 
 /**
@@ -185,9 +185,9 @@ static inline enum kernfs_node_type sysfs_type(struct kernfs_node *kn)
  */
 static inline void kernfs_enable_ns(struct kernfs_node *kn)
 {
-	WARN_ON_ONCE(sysfs_type(kn) != SYSFS_DIR);
+	WARN_ON_ONCE(kernfs_type(kn) != KERNFS_DIR);
 	WARN_ON_ONCE(!RB_EMPTY_ROOT(&kn->dir.children));
-	kn->flags |= SYSFS_FLAG_NS;
+	kn->flags |= KERNFS_NS;
 }
 
 /**
@@ -198,7 +198,7 @@ static inline void kernfs_enable_ns(struct kernfs_node *kn)
  */
 static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
 {
-	return kn->flags & SYSFS_FLAG_NS;
+	return kn->flags & KERNFS_NS;
 }
 
 struct kernfs_node *kernfs_find_and_get_ns(struct kernfs_node *parent,
@@ -238,7 +238,7 @@ void kernfs_init(void);
 
 #else	/* CONFIG_SYSFS */
 
-static inline enum kernfs_node_type sysfs_type(struct kernfs_node *kn)
+static inline enum kernfs_node_type kernfs_type(struct kernfs_node *kn)
 { return 0; }	/* whatever */
 
 static inline void kernfs_enable_ns(struct kernfs_node *kn) { }
-- 
1.8.4.2

