Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab3LKTMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:12:49 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:61167 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3LKTMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:12:45 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, linus.walleij@linaro.org,
        ashutosh.dixit@intel.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] kernfs: drop s_ prefix from kernfs_node members
Date: Wed, 11 Dec 2013 14:11:54 -0500
Message-Id: <1386789118-24733-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386789118-24733-1-git-send-email-tj@kernel.org>
References: <1386789118-24733-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs has just been separated out from sysfs and we're already in
full conflict mode.  Nothing can make the situation any worse.  Let's
take the chance to name things properly.

s_ prefix for kernfs members is used inconsistently and a misnomer
now.  It's not like kernfs_node is used widely across the kernel
making the ability to grep for the members particularly useful.  Let's
just drop the prefix.

This patch is strictly rename only and doesn't introduce any
functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             | 198 ++++++++++++++++++++++----------------------
 fs/kernfs/file.c            |  52 ++++++------
 fs/kernfs/inode.c           |  30 +++----
 fs/kernfs/kernfs-internal.h |   6 +-
 fs/kernfs/symlink.c         |  32 +++----
 fs/sysfs/dir.c              |  12 +--
 fs/sysfs/file.c             |  16 ++--
 fs/sysfs/symlink.c          |   6 +-
 include/linux/kernfs.h      |  38 ++++-----
 9 files changed, 193 insertions(+), 197 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 800ebf5..51fff9d 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -19,7 +19,7 @@
 
 DEFINE_MUTEX(sysfs_mutex);
 
-#define rb_to_kn(X) rb_entry((X), struct kernfs_node, s_rb)
+#define rb_to_kn(X) rb_entry((X), struct kernfs_node, rb)
 
 /**
  *	sysfs_name_hash
@@ -47,18 +47,17 @@ static unsigned int sysfs_name_hash(const char *name, const void *ns)
 static int sysfs_name_compare(unsigned int hash, const char *name,
 			      const void *ns, const struct kernfs_node *kn)
 {
-	if (hash != kn->s_hash)
-		return hash - kn->s_hash;
-	if (ns != kn->s_ns)
-		return ns - kn->s_ns;
-	return strcmp(name, kn->s_name);
+	if (hash != kn->hash)
+		return hash - kn->hash;
+	if (ns != kn->ns)
+		return ns - kn->ns;
+	return strcmp(name, kn->name);
 }
 
 static int sysfs_sd_compare(const struct kernfs_node *left,
 			    const struct kernfs_node *right)
 {
-	return sysfs_name_compare(left->s_hash, left->s_name, left->s_ns,
-				  right);
+	return sysfs_name_compare(left->hash, left->name, left->ns, right);
 }
 
 /**
@@ -66,7 +65,7 @@ static int sysfs_sd_compare(const struct kernfs_node *left,
  *	@kn: kernfs_node of interest
  *
  *	Link @kn into its sibling rbtree which starts from
- *	@kn->s_parent->s_dir.children.
+ *	@kn->parent->dir.children.
  *
  *	Locking:
  *	mutex_lock(sysfs_mutex)
@@ -76,11 +75,11 @@ static int sysfs_sd_compare(const struct kernfs_node *left,
  */
 static int sysfs_link_sibling(struct kernfs_node *kn)
 {
-	struct rb_node **node = &kn->s_parent->s_dir.children.rb_node;
+	struct rb_node **node = &kn->parent->dir.children.rb_node;
 	struct rb_node *parent = NULL;
 
 	if (sysfs_type(kn) == SYSFS_DIR)
-		kn->s_parent->s_dir.subdirs++;
+		kn->parent->dir.subdirs++;
 
 	while (*node) {
 		struct kernfs_node *pos;
@@ -90,15 +89,15 @@ static int sysfs_link_sibling(struct kernfs_node *kn)
 		parent = *node;
 		result = sysfs_sd_compare(kn, pos);
 		if (result < 0)
-			node = &pos->s_rb.rb_left;
+			node = &pos->rb.rb_left;
 		else if (result > 0)
-			node = &pos->s_rb.rb_right;
+			node = &pos->rb.rb_right;
 		else
 			return -EEXIST;
 	}
 	/* add new node and rebalance the tree */
-	rb_link_node(&kn->s_rb, parent, node);
-	rb_insert_color(&kn->s_rb, &kn->s_parent->s_dir.children);
+	rb_link_node(&kn->rb, parent, node);
+	rb_insert_color(&kn->rb, &kn->parent->dir.children);
 	return 0;
 }
 
@@ -107,7 +106,7 @@ static int sysfs_link_sibling(struct kernfs_node *kn)
  *	@kn: kernfs_node of interest
  *
  *	Unlink @kn from its sibling rbtree which starts from
- *	kn->s_parent->s_dir.children.
+ *	kn->parent->dir.children.
  *
  *	Locking:
  *	mutex_lock(sysfs_mutex)
@@ -115,9 +114,9 @@ static int sysfs_link_sibling(struct kernfs_node *kn)
 static void sysfs_unlink_sibling(struct kernfs_node *kn)
 {
 	if (sysfs_type(kn) == SYSFS_DIR)
-		kn->s_parent->s_dir.subdirs--;
+		kn->parent->dir.subdirs--;
 
-	rb_erase(&kn->s_rb, &kn->s_parent->s_dir.children);
+	rb_erase(&kn->rb, &kn->parent->dir.children);
 }
 
 /**
@@ -135,10 +134,10 @@ struct kernfs_node *sysfs_get_active(struct kernfs_node *kn)
 	if (unlikely(!kn))
 		return NULL;
 
-	if (!atomic_inc_unless_negative(&kn->s_active))
+	if (!atomic_inc_unless_negative(&kn->active))
 		return NULL;
 
-	if (kn->s_flags & SYSFS_FLAG_LOCKDEP)
+	if (kn->flags & SYSFS_FLAG_LOCKDEP)
 		rwsem_acquire_read(&kn->dep_map, 0, 1, _RET_IP_);
 	return kn;
 }
@@ -157,9 +156,9 @@ void sysfs_put_active(struct kernfs_node *kn)
 	if (unlikely(!kn))
 		return;
 
-	if (kn->s_flags & SYSFS_FLAG_LOCKDEP)
+	if (kn->flags & SYSFS_FLAG_LOCKDEP)
 		rwsem_release(&kn->dep_map, 1, _RET_IP_);
-	v = atomic_dec_return(&kn->s_active);
+	v = atomic_dec_return(&kn->active);
 	if (likely(v != SD_DEACTIVATED_BIAS))
 		return;
 
@@ -181,7 +180,7 @@ static void sysfs_deactivate(struct kernfs_node *kn)
 	DECLARE_COMPLETION_ONSTACK(wait);
 	int v;
 
-	BUG_ON(!(kn->s_flags & SYSFS_FLAG_REMOVED));
+	BUG_ON(!(kn->flags & SYSFS_FLAG_REMOVED));
 
 	if (!(sysfs_type(kn) & SYSFS_ACTIVE_REF))
 		return;
@@ -192,7 +191,7 @@ static void sysfs_deactivate(struct kernfs_node *kn)
 	/* atomic_add_return() is a mb(), put_active() will always see
 	 * the updated kn->u.completion.
 	 */
-	v = atomic_add_return(SD_DEACTIVATED_BIAS, &kn->s_active);
+	v = atomic_add_return(SD_DEACTIVATED_BIAS, &kn->active);
 
 	if (v != SD_DEACTIVATED_BIAS) {
 		lock_contended(&kn->dep_map, _RET_IP_);
@@ -210,8 +209,8 @@ static void sysfs_deactivate(struct kernfs_node *kn)
 void kernfs_get(struct kernfs_node *kn)
 {
 	if (kn) {
-		WARN_ON(!atomic_read(&kn->s_count));
-		atomic_inc(&kn->s_count);
+		WARN_ON(!atomic_read(&kn->count));
+		atomic_inc(&kn->count);
 	}
 }
 EXPORT_SYMBOL_GPL(kernfs_get);
@@ -227,36 +226,36 @@ void kernfs_put(struct kernfs_node *kn)
 	struct kernfs_node *parent;
 	struct kernfs_root *root;
 
-	if (!kn || !atomic_dec_and_test(&kn->s_count))
+	if (!kn || !atomic_dec_and_test(&kn->count))
 		return;
 	root = kernfs_root(kn);
  repeat:
 	/* Moving/renaming is always done while holding reference.
-	 * kn->s_parent won't change beneath us.
+	 * kn->parent won't change beneath us.
 	 */
-	parent = kn->s_parent;
+	parent = kn->parent;
 
-	WARN(!(kn->s_flags & SYSFS_FLAG_REMOVED),
+	WARN(!(kn->flags & SYSFS_FLAG_REMOVED),
 		"sysfs: free using entry: %s/%s\n",
-		parent ? parent->s_name : "", kn->s_name);
+		parent ? parent->name : "", kn->name);
 
 	if (sysfs_type(kn) == SYSFS_KOBJ_LINK)
-		kernfs_put(kn->s_symlink.target_kn);
+		kernfs_put(kn->symlink.target_kn);
 	if (sysfs_type(kn) & SYSFS_COPY_NAME)
-		kfree(kn->s_name);
-	if (kn->s_iattr) {
-		if (kn->s_iattr->ia_secdata)
-			security_release_secctx(kn->s_iattr->ia_secdata,
-						kn->s_iattr->ia_secdata_len);
-		simple_xattrs_free(&kn->s_iattr->xattrs);
+		kfree(kn->name);
+	if (kn->iattr) {
+		if (kn->iattr->ia_secdata)
+			security_release_secctx(kn->iattr->ia_secdata,
+						kn->iattr->ia_secdata_len);
+		simple_xattrs_free(&kn->iattr->xattrs);
 	}
-	kfree(kn->s_iattr);
-	ida_simple_remove(&root->ino_ida, kn->s_ino);
+	kfree(kn->iattr);
+	ida_simple_remove(&root->ino_ida, kn->ino);
 	kmem_cache_free(sysfs_dir_cachep, kn);
 
 	kn = parent;
 	if (kn) {
-		if (atomic_dec_and_test(&kn->s_count))
+		if (atomic_dec_and_test(&kn->count))
 			goto repeat;
 	} else {
 		/* just released the root kn, free @root too */
@@ -269,7 +268,7 @@ EXPORT_SYMBOL_GPL(kernfs_put);
 static int sysfs_dentry_delete(const struct dentry *dentry)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
-	return !(kn && !(kn->s_flags & SYSFS_FLAG_REMOVED));
+	return !(kn && !(kn->flags & SYSFS_FLAG_REMOVED));
 }
 
 static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
@@ -283,20 +282,20 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 	mutex_lock(&sysfs_mutex);
 
 	/* The sysfs dirent has been deleted */
-	if (kn->s_flags & SYSFS_FLAG_REMOVED)
+	if (kn->flags & SYSFS_FLAG_REMOVED)
 		goto out_bad;
 
 	/* The sysfs dirent has been moved? */
-	if (dentry->d_parent->d_fsdata != kn->s_parent)
+	if (dentry->d_parent->d_fsdata != kn->parent)
 		goto out_bad;
 
 	/* The sysfs dirent has been renamed */
-	if (strcmp(dentry->d_name.name, kn->s_name) != 0)
+	if (strcmp(dentry->d_name.name, kn->name) != 0)
 		goto out_bad;
 
 	/* The sysfs dirent has been moved to a different namespace */
-	if (kn->s_parent && kernfs_ns_enabled(kn->s_parent) &&
-	    sysfs_info(dentry->d_sb)->ns != kn->s_ns)
+	if (kn->parent && kernfs_ns_enabled(kn->parent) &&
+	    sysfs_info(dentry->d_sb)->ns != kn->ns)
 		goto out_bad;
 
 	mutex_unlock(&sysfs_mutex);
@@ -356,14 +355,14 @@ struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
 	ret = ida_simple_get(&root->ino_ida, 1, 0, GFP_KERNEL);
 	if (ret < 0)
 		goto err_out2;
-	kn->s_ino = ret;
+	kn->ino = ret;
 
-	atomic_set(&kn->s_count, 1);
-	atomic_set(&kn->s_active, 0);
+	atomic_set(&kn->count, 1);
+	atomic_set(&kn->active, 0);
 
-	kn->s_name = name;
-	kn->s_mode = mode;
-	kn->s_flags = type | SYSFS_FLAG_REMOVED;
+	kn->name = name;
+	kn->mode = mode;
+	kn->flags = type | SYSFS_FLAG_REMOVED;
 
 	return kn;
 
@@ -400,9 +399,9 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt)
  *	@kn: kernfs_node to be added
  *	@parent: the parent kernfs_node to add @kn to
  *
- *	Get @parent and set @kn->s_parent to it and increment nlink of
- *	the parent inode if @kn is a directory and link into the children
- *	list of the parent.
+ *	Get @parent and set @kn->parent to it and increment nlink of the
+ *	parent inode if @kn is a directory and link into the children list
+ *	of the parent.
  *
  *	This function should be called between calls to
  *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
@@ -422,18 +421,17 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct kernfs_node *kn,
 	struct sysfs_inode_attrs *ps_iattr;
 	int ret;
 
-	if (has_ns != (bool)kn->s_ns) {
+	if (has_ns != (bool)kn->ns) {
 		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
-		     has_ns ? "required" : "invalid",
-		     parent->s_name, kn->s_name);
+		     has_ns ? "required" : "invalid", parent->name, kn->name);
 		return -EINVAL;
 	}
 
 	if (sysfs_type(parent) != SYSFS_DIR)
 		return -EINVAL;
 
-	kn->s_hash = sysfs_name_hash(kn->s_name, kn->s_ns);
-	kn->s_parent = parent;
+	kn->hash = sysfs_name_hash(kn->name, kn->ns);
+	kn->parent = parent;
 	kernfs_get(parent);
 
 	ret = sysfs_link_sibling(kn);
@@ -441,14 +439,14 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct kernfs_node *kn,
 		return ret;
 
 	/* Update timestamps on the parent */
-	ps_iattr = parent->s_iattr;
+	ps_iattr = parent->iattr;
 	if (ps_iattr) {
 		struct iattr *ps_iattrs = &ps_iattr->ia_iattr;
 		ps_iattrs->ia_ctime = ps_iattrs->ia_mtime = CURRENT_TIME;
 	}
 
 	/* Mark the entry added into directory tree */
-	kn->s_flags &= ~SYSFS_FLAG_REMOVED;
+	kn->flags &= ~SYSFS_FLAG_REMOVED;
 
 	return 0;
 }
@@ -477,21 +475,21 @@ static void sysfs_remove_one(struct sysfs_addrm_cxt *acxt,
 	 * Removal can be called multiple times on the same node.  Only the
 	 * first invocation is effective and puts the base ref.
 	 */
-	if (kn->s_flags & SYSFS_FLAG_REMOVED)
+	if (kn->flags & SYSFS_FLAG_REMOVED)
 		return;
 
-	if (kn->s_parent) {
+	if (kn->parent) {
 		sysfs_unlink_sibling(kn);
 
 		/* Update timestamps on the parent */
-		ps_iattr = kn->s_parent->s_iattr;
+		ps_iattr = kn->parent->iattr;
 		if (ps_iattr) {
 			ps_iattr->ia_iattr.ia_ctime = CURRENT_TIME;
 			ps_iattr->ia_iattr.ia_mtime = CURRENT_TIME;
 		}
 	}
 
-	kn->s_flags |= SYSFS_FLAG_REMOVED;
+	kn->flags |= SYSFS_FLAG_REMOVED;
 	kn->u.removed_list = acxt->removed;
 	acxt->removed = kn;
 }
@@ -538,7 +536,7 @@ static struct kernfs_node *kernfs_find_ns(struct kernfs_node *parent,
 					  const unsigned char *name,
 					  const void *ns)
 {
-	struct rb_node *node = parent->s_dir.children.rb_node;
+	struct rb_node *node = parent->dir.children.rb_node;
 	bool has_ns = kernfs_ns_enabled(parent);
 	unsigned int hash;
 
@@ -546,8 +544,7 @@ static struct kernfs_node *kernfs_find_ns(struct kernfs_node *parent,
 
 	if (has_ns != (bool)ns) {
 		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
-		     has_ns ? "required" : "invalid",
-		     parent->s_name, name);
+		     has_ns ? "required" : "invalid", parent->name, name);
 		return NULL;
 	}
 
@@ -617,9 +614,9 @@ struct kernfs_root *kernfs_create_root(void *priv)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	kn->s_flags &= ~SYSFS_FLAG_REMOVED;
+	kn->flags &= ~SYSFS_FLAG_REMOVED;
 	kn->priv = priv;
-	kn->s_dir.root = root;
+	kn->dir.root = root;
 
 	root->kn = kn;
 
@@ -661,8 +658,8 @@ struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
-	kn->s_dir.root = parent->s_dir.root;
-	kn->s_ns = ns;
+	kn->dir.root = parent->dir.root;
+	kn->ns = ns;
 	kn->priv = priv;
 
 	/* link in */
@@ -738,7 +735,7 @@ static struct kernfs_node *sysfs_leftmost_descendant(struct kernfs_node *pos)
 		if (sysfs_type(pos) != SYSFS_DIR)
 			break;
 
-		rbn = rb_first(&pos->s_dir.children);
+		rbn = rb_first(&pos->dir.children);
 		if (!rbn)
 			break;
 
@@ -773,12 +770,12 @@ static struct kernfs_node *sysfs_next_descendant_post(struct kernfs_node *pos,
 		return NULL;
 
 	/* if there's an unvisited sibling, visit its leftmost descendant */
-	rbn = rb_next(&pos->s_rb);
+	rbn = rb_next(&pos->rb);
 	if (rbn)
 		return sysfs_leftmost_descendant(rb_to_kn(rbn));
 
 	/* no sibling left, visit parent */
-	return pos->s_parent;
+	return pos->parent;
 }
 
 static void __kernfs_remove(struct sysfs_addrm_cxt *acxt,
@@ -789,7 +786,7 @@ static void __kernfs_remove(struct sysfs_addrm_cxt *acxt,
 	if (!kn)
 		return;
 
-	pr_debug("sysfs %s: removing\n", kn->s_name);
+	pr_debug("sysfs %s: removing\n", kn->name);
 
 	next = NULL;
 	do {
@@ -865,8 +862,8 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	mutex_lock(&sysfs_mutex);
 
 	error = 0;
-	if ((kn->s_parent == new_parent) && (kn->s_ns == new_ns) &&
-	    (strcmp(kn->s_name, new_name) == 0))
+	if ((kn->parent == new_parent) && (kn->ns == new_ns) &&
+	    (strcmp(kn->name, new_name) == 0))
 		goto out;	/* nothing to rename */
 
 	error = -EEXIST;
@@ -874,14 +871,14 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 		goto out;
 
 	/* rename kernfs_node */
-	if (strcmp(kn->s_name, new_name) != 0) {
+	if (strcmp(kn->name, new_name) != 0) {
 		error = -ENOMEM;
 		new_name = kstrdup(new_name, GFP_KERNEL);
 		if (!new_name)
 			goto out;
 
-		kfree(kn->s_name);
-		kn->s_name = new_name;
+		kfree(kn->name);
+		kn->name = new_name;
 	}
 
 	/*
@@ -889,10 +886,10 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	 */
 	sysfs_unlink_sibling(kn);
 	kernfs_get(new_parent);
-	kernfs_put(kn->s_parent);
-	kn->s_ns = new_ns;
-	kn->s_hash = sysfs_name_hash(kn->s_name, kn->s_ns);
-	kn->s_parent = new_parent;
+	kernfs_put(kn->parent);
+	kn->ns = new_ns;
+	kn->hash = sysfs_name_hash(kn->name, kn->ns);
+	kn->parent = new_parent;
 	sysfs_link_sibling(kn);
 
 	error = 0;
@@ -904,7 +901,7 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 /* Relationship between s_mode and the DT_xxx types */
 static inline unsigned char dt_type(struct kernfs_node *kn)
 {
-	return (kn->s_mode >> 12) & 15;
+	return (kn->mode >> 12) & 15;
 }
 
 static int sysfs_dir_release(struct inode *inode, struct file *filp)
@@ -917,29 +914,28 @@ static struct kernfs_node *sysfs_dir_pos(const void *ns,
 	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos)
 {
 	if (pos) {
-		int valid = !(pos->s_flags & SYSFS_FLAG_REMOVED) &&
-			pos->s_parent == parent &&
-			hash == pos->s_hash;
+		int valid = !(pos->flags & SYSFS_FLAG_REMOVED) &&
+			pos->parent == parent && hash == pos->hash;
 		kernfs_put(pos);
 		if (!valid)
 			pos = NULL;
 	}
 	if (!pos && (hash > 1) && (hash < INT_MAX)) {
-		struct rb_node *node = parent->s_dir.children.rb_node;
+		struct rb_node *node = parent->dir.children.rb_node;
 		while (node) {
 			pos = rb_to_kn(node);
 
-			if (hash < pos->s_hash)
+			if (hash < pos->hash)
 				node = node->rb_left;
-			else if (hash > pos->s_hash)
+			else if (hash > pos->hash)
 				node = node->rb_right;
 			else
 				break;
 		}
 	}
 	/* Skip over entries in the wrong namespace */
-	while (pos && pos->s_ns != ns) {
-		struct rb_node *node = rb_next(&pos->s_rb);
+	while (pos && pos->ns != ns) {
+		struct rb_node *node = rb_next(&pos->rb);
 		if (!node)
 			pos = NULL;
 		else
@@ -954,12 +950,12 @@ static struct kernfs_node *sysfs_dir_next_pos(const void *ns,
 	pos = sysfs_dir_pos(ns, parent, ino, pos);
 	if (pos)
 		do {
-			struct rb_node *node = rb_next(&pos->s_rb);
+			struct rb_node *node = rb_next(&pos->rb);
 			if (!node)
 				pos = NULL;
 			else
 				pos = rb_to_kn(node);
-		} while (pos && pos->s_ns != ns);
+		} while (pos && pos->ns != ns);
 	return pos;
 }
 
@@ -980,12 +976,12 @@ static int sysfs_readdir(struct file *file, struct dir_context *ctx)
 	for (pos = sysfs_dir_pos(ns, parent, ctx->pos, pos);
 	     pos;
 	     pos = sysfs_dir_next_pos(ns, parent, ctx->pos, pos)) {
-		const char *name = pos->s_name;
+		const char *name = pos->name;
 		unsigned int type = dt_type(pos);
 		int len = strlen(name);
-		ino_t ino = pos->s_ino;
+		ino_t ino = pos->ino;
 
-		ctx->pos = pos->s_hash;
+		ctx->pos = pos->hash;
 		file->private_data = pos;
 		kernfs_get(pos);
 
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 1bf07de..5277021 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -21,7 +21,7 @@
  * There's one sysfs_open_file for each open file and one sysfs_open_dirent
  * for each kernfs_node with one or more open files.
  *
- * kernfs_node->s_attr.open points to sysfs_open_dirent.  s_attr.open is
+ * kernfs_node->attr.open points to sysfs_open_dirent.  attr.open is
  * protected by sysfs_open_dirent_lock.
  *
  * filp->private_data points to seq_file whose ->private points to
@@ -49,9 +49,9 @@ static struct sysfs_open_file *sysfs_of(struct file *file)
  */
 static const struct kernfs_ops *kernfs_ops(struct kernfs_node *kn)
 {
-	if (kn->s_flags & SYSFS_FLAG_LOCKDEP)
+	if (kn->flags & SYSFS_FLAG_LOCKDEP)
 		lockdep_assert_held(kn);
-	return kn->s_attr.ops;
+	return kn->attr.ops;
 }
 
 static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
@@ -112,9 +112,9 @@ static int kernfs_seq_show(struct seq_file *sf, void *v)
 {
 	struct sysfs_open_file *of = sf->private;
 
-	of->event = atomic_read(&of->kn->s_attr.open->event);
+	of->event = atomic_read(&of->kn->attr.open->event);
 
-	return of->kn->s_attr.ops->seq_show(sf, v);
+	return of->kn->attr.ops->seq_show(sf, v);
 }
 
 static const struct seq_operations kernfs_seq_ops = {
@@ -189,7 +189,7 @@ static ssize_t kernfs_file_read(struct file *file, char __user *user_buf,
 {
 	struct sysfs_open_file *of = sysfs_of(file);
 
-	if (of->kn->s_flags & SYSFS_FLAG_HAS_SEQ_SHOW)
+	if (of->kn->flags & SYSFS_FLAG_HAS_SEQ_SHOW)
 		return seq_read(file, user_buf, count, ppos);
 	else
 		return kernfs_file_direct_read(of, user_buf, count, ppos);
@@ -428,7 +428,7 @@ static int kernfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	 * without grabbing @of->mutex by testing HAS_MMAP flag.  See the
 	 * comment in kernfs_file_open() for more details.
 	 */
-	if (!(of->kn->s_flags & SYSFS_FLAG_HAS_MMAP))
+	if (!(of->kn->flags & SYSFS_FLAG_HAS_MMAP))
 		return -ENODEV;
 
 	mutex_lock(&of->mutex);
@@ -477,8 +477,8 @@ out_unlock:
  *	@kn: target kernfs_node
  *	@of: sysfs_open_file for this instance of open
  *
- *	If @kn->s_attr.open exists, increment its reference count;
- *	otherwise, create one.  @of is chained to the files list.
+ *	If @kn->attr.open exists, increment its reference count; otherwise,
+ *	create one.  @of is chained to the files list.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).
@@ -495,12 +495,12 @@ static int sysfs_get_open_dirent(struct kernfs_node *kn,
 	mutex_lock(&sysfs_open_file_mutex);
 	spin_lock_irq(&sysfs_open_dirent_lock);
 
-	if (!kn->s_attr.open && new_od) {
-		kn->s_attr.open = new_od;
+	if (!kn->attr.open && new_od) {
+		kn->attr.open = new_od;
 		new_od = NULL;
 	}
 
-	od = kn->s_attr.open;
+	od = kn->attr.open;
 	if (od) {
 		atomic_inc(&od->refcnt);
 		list_add_tail(&of->list, &od->files);
@@ -531,7 +531,7 @@ static int sysfs_get_open_dirent(struct kernfs_node *kn,
  *	@kn: target kernfs_nodet
  *	@of: associated sysfs_open_file
  *
- *	Put @kn->s_attr.open and unlink @of from the files list.  If
+ *	Put @kn->attr.open and unlink @of from the files list.  If
  *	reference count reaches zero, disassociate and free it.
  *
  *	LOCKING:
@@ -540,7 +540,7 @@ static int sysfs_get_open_dirent(struct kernfs_node *kn,
 static void sysfs_put_open_dirent(struct kernfs_node *kn,
 				  struct sysfs_open_file *of)
 {
-	struct sysfs_open_dirent *od = kn->s_attr.open;
+	struct sysfs_open_dirent *od = kn->attr.open;
 	unsigned long flags;
 
 	mutex_lock(&sysfs_open_file_mutex);
@@ -550,7 +550,7 @@ static void sysfs_put_open_dirent(struct kernfs_node *kn,
 		list_del(&of->list);
 
 	if (atomic_dec_and_test(&od->refcnt))
-		kn->s_attr.open = NULL;
+		kn->attr.open = NULL;
 	else
 		od = NULL;
 
@@ -668,11 +668,11 @@ void sysfs_unmap_bin_file(struct kernfs_node *kn)
 	struct sysfs_open_dirent *od;
 	struct sysfs_open_file *of;
 
-	if (!(kn->s_flags & SYSFS_FLAG_HAS_MMAP))
+	if (!(kn->flags & SYSFS_FLAG_HAS_MMAP))
 		return;
 
 	spin_lock_irq(&sysfs_open_dirent_lock);
-	od = kn->s_attr.open;
+	od = kn->attr.open;
 	if (od)
 		atomic_inc(&od->refcnt);
 	spin_unlock_irq(&sysfs_open_dirent_lock);
@@ -706,7 +706,7 @@ static unsigned int kernfs_file_poll(struct file *filp, poll_table *wait)
 {
 	struct sysfs_open_file *of = sysfs_of(filp);
 	struct kernfs_node *kn = filp->f_path.dentry->d_fsdata;
-	struct sysfs_open_dirent *od = kn->s_attr.open;
+	struct sysfs_open_dirent *od = kn->attr.open;
 
 	/* need parent for the kobj, grab both */
 	if (!sysfs_get_active(kn))
@@ -739,7 +739,7 @@ void kernfs_notify(struct kernfs_node *kn)
 	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
 
 	if (!WARN_ON(sysfs_type(kn) != SYSFS_KOBJ_ATTR)) {
-		od = kn->s_attr.open;
+		od = kn->attr.open;
 		if (od) {
 			atomic_inc(&od->event);
 			wake_up_interruptible(&od->poll);
@@ -789,27 +789,27 @@ struct kernfs_node *kernfs_create_file_ns_key(struct kernfs_node *parent,
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
-	kn->s_attr.ops = ops;
-	kn->s_attr.size = size;
-	kn->s_ns = ns;
+	kn->attr.ops = ops;
+	kn->attr.size = size;
+	kn->ns = ns;
 	kn->priv = priv;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	if (key) {
 		lockdep_init_map(&kn->dep_map, "s_active", key, 0);
-		kn->s_flags |= SYSFS_FLAG_LOCKDEP;
+		kn->flags |= SYSFS_FLAG_LOCKDEP;
 	}
 #endif
 
 	/*
-	 * kn->s_attr.ops is accesible only while holding active ref.  We
+	 * kn->attr.ops is accesible only while holding active ref.  We
 	 * need to know whether some ops are implemented outside active
 	 * ref.  Cache their existence in flags.
 	 */
 	if (ops->seq_show)
-		kn->s_flags |= SYSFS_FLAG_HAS_SEQ_SHOW;
+		kn->flags |= SYSFS_FLAG_HAS_SEQ_SHOW;
 	if (ops->mmap)
-		kn->s_flags |= SYSFS_FLAG_HAS_MMAP;
+		kn->flags |= SYSFS_FLAG_HAS_MMAP;
 
 	sysfs_addrm_start(&acxt);
 	rc = sysfs_add_one(&acxt, kn, parent);
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 9e74eed..f6c0aae 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -50,23 +50,23 @@ static struct sysfs_inode_attrs *sysfs_inode_attrs(struct kernfs_node *kn)
 {
 	struct iattr *iattrs;
 
-	if (kn->s_iattr)
-		return kn->s_iattr;
+	if (kn->iattr)
+		return kn->iattr;
 
-	kn->s_iattr = kzalloc(sizeof(struct sysfs_inode_attrs), GFP_KERNEL);
-	if (!kn->s_iattr)
+	kn->iattr = kzalloc(sizeof(struct sysfs_inode_attrs), GFP_KERNEL);
+	if (!kn->iattr)
 		return NULL;
-	iattrs = &kn->s_iattr->ia_iattr;
+	iattrs = &kn->iattr->ia_iattr;
 
 	/* assign default attributes */
-	iattrs->ia_mode = kn->s_mode;
+	iattrs->ia_mode = kn->mode;
 	iattrs->ia_uid = GLOBAL_ROOT_UID;
 	iattrs->ia_gid = GLOBAL_ROOT_GID;
 	iattrs->ia_atime = iattrs->ia_mtime = iattrs->ia_ctime = CURRENT_TIME;
 
-	simple_xattrs_init(&kn->s_iattr->xattrs);
+	simple_xattrs_init(&kn->iattr->xattrs);
 
-	return kn->s_iattr;
+	return kn->iattr;
 }
 
 static int __kernfs_setattr(struct kernfs_node *kn, const struct iattr *iattr)
@@ -93,7 +93,7 @@ static int __kernfs_setattr(struct kernfs_node *kn, const struct iattr *iattr)
 		iattrs->ia_ctime = iattr->ia_ctime;
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = iattr->ia_mode;
-		iattrs->ia_mode = kn->s_mode = mode;
+		iattrs->ia_mode = kn->mode = mode;
 	}
 	return 0;
 }
@@ -256,9 +256,9 @@ static inline void set_inode_attr(struct inode *inode, struct iattr *iattr)
 
 static void sysfs_refresh_inode(struct kernfs_node *kn, struct inode *inode)
 {
-	struct sysfs_inode_attrs *attrs = kn->s_iattr;
+	struct sysfs_inode_attrs *attrs = kn->iattr;
 
-	inode->i_mode = kn->s_mode;
+	inode->i_mode = kn->mode;
 	if (attrs) {
 		/*
 		 * kernfs_node has non-default attributes get them from
@@ -270,7 +270,7 @@ static void sysfs_refresh_inode(struct kernfs_node *kn, struct inode *inode)
 	}
 
 	if (sysfs_type(kn) == SYSFS_DIR)
-		set_nlink(inode, kn->s_dir.subdirs + 2);
+		set_nlink(inode, kn->dir.subdirs + 2);
 }
 
 int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
@@ -295,7 +295,7 @@ static void sysfs_init_inode(struct kernfs_node *kn, struct inode *inode)
 	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 	inode->i_op = &sysfs_inode_operations;
 
-	set_default_inode_attr(inode, kn->s_mode);
+	set_default_inode_attr(inode, kn->mode);
 	sysfs_refresh_inode(kn, inode);
 
 	/* initialize inode according to type */
@@ -305,7 +305,7 @@ static void sysfs_init_inode(struct kernfs_node *kn, struct inode *inode)
 		inode->i_fop = &sysfs_dir_operations;
 		break;
 	case SYSFS_KOBJ_ATTR:
-		inode->i_size = kn->s_attr.size;
+		inode->i_size = kn->attr.size;
 		inode->i_fop = &kernfs_file_operations;
 		break;
 	case SYSFS_KOBJ_LINK:
@@ -337,7 +337,7 @@ struct inode *sysfs_get_inode(struct super_block *sb, struct kernfs_node *kn)
 {
 	struct inode *inode;
 
-	inode = iget_locked(sb, kn->s_ino);
+	inode = iget_locked(sb, kn->ino);
 	if (inode && (inode->i_state & I_NEW))
 		sysfs_init_inode(kn, inode);
 
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index b7ea76c..2dbb1cb 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -39,9 +39,9 @@ struct sysfs_inode_attrs {
 static inline struct kernfs_root *kernfs_root(struct kernfs_node *kn)
 {
 	/* if parent exists, it's always a dir; otherwise, @sd is a dir */
-	if (kn->s_parent)
-		kn = kn->s_parent;
-	return kn->s_dir.root;
+	if (kn->parent)
+		kn = kn->parent;
+	return kn->dir.root;
 }
 
 /*
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index 29dcf5e..5ac1a57 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -36,8 +36,8 @@ struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 		return ERR_PTR(-ENOMEM);
 
 	if (kernfs_ns_enabled(parent))
-		kn->s_ns = target->s_ns;
-	kn->s_symlink.target_kn = target;
+		kn->ns = target->ns;
+	kn->symlink.target_kn = target;
 	kernfs_get(target);	/* ref owned by symlink */
 
 	sysfs_addrm_start(&acxt);
@@ -60,24 +60,24 @@ static int sysfs_get_target_path(struct kernfs_node *parent,
 
 	/* go up to the root, stop at the base */
 	base = parent;
-	while (base->s_parent) {
-		kn = target->s_parent;
-		while (kn->s_parent && base != kn)
-			kn = kn->s_parent;
+	while (base->parent) {
+		kn = target->parent;
+		while (kn->parent && base != kn)
+			kn = kn->parent;
 
 		if (base == kn)
 			break;
 
 		strcpy(s, "../");
 		s += 3;
-		base = base->s_parent;
+		base = base->parent;
 	}
 
 	/* determine end of target string for reverse fillup */
 	kn = target;
-	while (kn->s_parent && kn != base) {
-		len += strlen(kn->s_name) + 1;
-		kn = kn->s_parent;
+	while (kn->parent && kn != base) {
+		len += strlen(kn->name) + 1;
+		kn = kn->parent;
 	}
 
 	/* check limits */
@@ -89,15 +89,15 @@ static int sysfs_get_target_path(struct kernfs_node *parent,
 
 	/* reverse fillup of target string from target to base */
 	kn = target;
-	while (kn->s_parent && kn != base) {
-		int slen = strlen(kn->s_name);
+	while (kn->parent && kn != base) {
+		int slen = strlen(kn->name);
 
 		len -= slen;
-		strncpy(s + len, kn->s_name, slen);
+		strncpy(s + len, kn->name, slen);
 		if (len)
 			s[--len] = '/';
 
-		kn = kn->s_parent;
+		kn = kn->parent;
 	}
 
 	return 0;
@@ -106,8 +106,8 @@ static int sysfs_get_target_path(struct kernfs_node *parent,
 static int sysfs_getlink(struct dentry *dentry, char *path)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
-	struct kernfs_node *parent = kn->s_parent;
-	struct kernfs_node *target = kn->s_symlink.target_kn;
+	struct kernfs_node *parent = kn->parent;
+	struct kernfs_node *target = kn->symlink.target_kn;
 	int error;
 
 	mutex_lock(&sysfs_mutex);
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f1efe3d..4a80001 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -29,11 +29,11 @@ DEFINE_SPINLOCK(sysfs_symlink_target_lock);
  */
 static char *sysfs_pathname(struct kernfs_node *kn, char *path)
 {
-	if (kn->s_parent) {
-		sysfs_pathname(kn->s_parent, path);
+	if (kn->parent) {
+		sysfs_pathname(kn->parent, path);
 		strlcat(path, "/", PATH_MAX);
 	}
-	strlcat(path, kn->s_name, PATH_MAX);
+	strlcat(path, kn->name, PATH_MAX);
 	return path;
 }
 
@@ -121,7 +121,7 @@ void sysfs_remove_dir(struct kobject *kobj)
 int sysfs_rename_dir_ns(struct kobject *kobj, const char *new_name,
 			const void *new_ns)
 {
-	struct kernfs_node *parent = kobj->sd->s_parent;
+	struct kernfs_node *parent = kobj->sd->parent;
 
 	return kernfs_rename_ns(kobj->sd, parent, new_name, new_ns);
 }
@@ -132,9 +132,9 @@ int sysfs_move_dir_ns(struct kobject *kobj, struct kobject *new_parent_kobj,
 	struct kernfs_node *kn = kobj->sd;
 	struct kernfs_node *new_parent;
 
-	BUG_ON(!kn->s_parent);
+	BUG_ON(!kn->parent);
 	new_parent = new_parent_kobj && new_parent_kobj->sd ?
 		new_parent_kobj->sd : sysfs_root_kn;
 
-	return kernfs_rename_ns(kn, new_parent, kn->s_name, new_ns);
+	return kernfs_rename_ns(kn, new_parent, kn->name, new_ns);
 }
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index be1cc39..887703a 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -27,9 +27,9 @@
  */
 static const struct sysfs_ops *sysfs_file_ops(struct kernfs_node *kn)
 {
-	struct kobject *kobj = kn->s_parent->priv;
+	struct kobject *kobj = kn->parent->priv;
 
-	if (kn->s_flags & SYSFS_FLAG_LOCKDEP)
+	if (kn->flags & SYSFS_FLAG_LOCKDEP)
 		lockdep_assert_held(kn);
 	return kobj->ktype ? kobj->ktype->sysfs_ops : NULL;
 }
@@ -42,7 +42,7 @@ static const struct sysfs_ops *sysfs_file_ops(struct kernfs_node *kn)
 static int sysfs_kf_seq_show(struct seq_file *sf, void *v)
 {
 	struct sysfs_open_file *of = sf->private;
-	struct kobject *kobj = of->kn->s_parent->priv;
+	struct kobject *kobj = of->kn->parent->priv;
 	const struct sysfs_ops *ops = sysfs_file_ops(of->kn);
 	ssize_t count;
 	char *buf;
@@ -82,7 +82,7 @@ static ssize_t sysfs_kf_bin_read(struct sysfs_open_file *of, char *buf,
 				 size_t count, loff_t pos)
 {
 	struct bin_attribute *battr = of->kn->priv;
-	struct kobject *kobj = of->kn->s_parent->priv;
+	struct kobject *kobj = of->kn->parent->priv;
 	loff_t size = file_inode(of->file)->i_size;
 
 	if (!count)
@@ -106,7 +106,7 @@ static ssize_t sysfs_kf_write(struct sysfs_open_file *of, char *buf,
 			      size_t count, loff_t pos)
 {
 	const struct sysfs_ops *ops = sysfs_file_ops(of->kn);
-	struct kobject *kobj = of->kn->s_parent->priv;
+	struct kobject *kobj = of->kn->parent->priv;
 
 	if (!count)
 		return 0;
@@ -119,7 +119,7 @@ static ssize_t sysfs_kf_bin_write(struct sysfs_open_file *of, char *buf,
 				  size_t count, loff_t pos)
 {
 	struct bin_attribute *battr = of->kn->priv;
-	struct kobject *kobj = of->kn->s_parent->priv;
+	struct kobject *kobj = of->kn->parent->priv;
 	loff_t size = file_inode(of->file)->i_size;
 
 	if (size) {
@@ -140,7 +140,7 @@ static int sysfs_kf_bin_mmap(struct sysfs_open_file *of,
 			     struct vm_area_struct *vma)
 {
 	struct bin_attribute *battr = of->kn->priv;
-	struct kobject *kobj = of->kn->s_parent->priv;
+	struct kobject *kobj = of->kn->parent->priv;
 
 	return battr->mmap(of->file, kobj, battr, vma);
 }
@@ -345,7 +345,7 @@ int sysfs_chmod_file(struct kobject *kobj, const struct attribute *attr,
 	if (!kn)
 		return -ENOENT;
 
-	newattrs.ia_mode = (mode & S_IALLUGO) | (kn->s_mode & ~S_IALLUGO);
+	newattrs.ia_mode = (mode & S_IALLUGO) | (kn->mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE;
 
 	rc = kernfs_setattr(kn, &newattrs);
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 4ed3d49..0d48ea9 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -129,7 +129,7 @@ void sysfs_delete_link(struct kobject *kobj, struct kobject *targ,
 	 */
 	spin_lock(&sysfs_symlink_target_lock);
 	if (targ->sd && kernfs_ns_enabled(kobj->sd))
-		ns = targ->sd->s_ns;
+		ns = targ->sd->ns;
 	spin_unlock(&sysfs_symlink_target_lock);
 	kernfs_remove_by_name_ns(kobj->sd, name, ns);
 }
@@ -175,7 +175,7 @@ int sysfs_rename_link_ns(struct kobject *kobj, struct kobject *targ,
 		parent = kobj->sd;
 
 	if (targ->sd)
-		old_ns = targ->sd->s_ns;
+		old_ns = targ->sd->ns;
 
 	result = -ENOENT;
 	kn = kernfs_find_and_get_ns(parent, old, old_ns);
@@ -185,7 +185,7 @@ int sysfs_rename_link_ns(struct kobject *kobj, struct kobject *targ,
 	result = -EINVAL;
 	if (sysfs_type(kn) != SYSFS_KOBJ_LINK)
 		goto out;
-	if (kn->s_symlink.target_kn->priv != targ)
+	if (kn->symlink.target_kn->priv != targ)
 		goto out;
 
 	result = kernfs_rename_ns(kn, parent, new, new_ns);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 195d1c6..092469f 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -49,7 +49,7 @@ enum kernfs_node_flag {
 /* type-specific structures for kernfs_node union members */
 struct kernfs_elem_dir {
 	unsigned long		subdirs;
-	/* children rbtree starts here and goes through kn->s_rb */
+	/* children rbtree starts here and goes through kn->rb */
 	struct rb_root		children;
 
 	/*
@@ -79,36 +79,36 @@ struct kernfs_elem_attr {
  * active reference.
  */
 struct kernfs_node {
-	atomic_t		s_count;
-	atomic_t		s_active;
+	atomic_t		count;
+	atomic_t		active;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
 	/* the following two fields are published */
-	struct kernfs_node	*s_parent;
-	const char		*s_name;
+	struct kernfs_node	*parent;
+	const char		*name;
 
-	struct rb_node		s_rb;
+	struct rb_node		rb;
 
 	union {
 		struct completion	*completion;
 		struct kernfs_node	*removed_list;
 	} u;
 
-	const void		*s_ns; /* namespace tag */
-	unsigned int		s_hash; /* ns + name hash */
+	const void		*ns;	/* namespace tag */
+	unsigned int		hash;	/* ns + name hash */
 	union {
-		struct kernfs_elem_dir		s_dir;
-		struct kernfs_elem_symlink	s_symlink;
-		struct kernfs_elem_attr		s_attr;
+		struct kernfs_elem_dir		dir;
+		struct kernfs_elem_symlink	symlink;
+		struct kernfs_elem_attr		attr;
 	};
 
 	void			*priv;
 
-	unsigned short		s_flags;
-	umode_t			s_mode;
-	unsigned int		s_ino;
-	struct sysfs_inode_attrs *s_iattr;
+	unsigned short		flags;
+	umode_t			mode;
+	unsigned int		ino;
+	struct sysfs_inode_attrs *iattr;
 };
 
 struct kernfs_root {
@@ -172,7 +172,7 @@ struct kernfs_ops {
 
 static inline enum kernfs_node_type sysfs_type(struct kernfs_node *kn)
 {
-	return kn->s_flags & SYSFS_TYPE_MASK;
+	return kn->flags & SYSFS_TYPE_MASK;
 }
 
 /**
@@ -186,8 +186,8 @@ static inline enum kernfs_node_type sysfs_type(struct kernfs_node *kn)
 static inline void kernfs_enable_ns(struct kernfs_node *kn)
 {
 	WARN_ON_ONCE(sysfs_type(kn) != SYSFS_DIR);
-	WARN_ON_ONCE(!RB_EMPTY_ROOT(&kn->s_dir.children));
-	kn->s_flags |= SYSFS_FLAG_NS;
+	WARN_ON_ONCE(!RB_EMPTY_ROOT(&kn->dir.children));
+	kn->flags |= SYSFS_FLAG_NS;
 }
 
 /**
@@ -198,7 +198,7 @@ static inline void kernfs_enable_ns(struct kernfs_node *kn)
  */
 static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
 {
-	return kn->s_flags & SYSFS_FLAG_NS;
+	return kn->flags & SYSFS_FLAG_NS;
 }
 
 struct kernfs_node *kernfs_find_and_get_ns(struct kernfs_node *parent,
-- 
1.8.4.2

