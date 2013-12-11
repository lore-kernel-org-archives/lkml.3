Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab3LKTND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:13:03 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:40276 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3LKTMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:12:52 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, linus.walleij@linaro.org,
        ashutosh.dixit@intel.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] kernfs: s/sysfs/kernfs/ in internal functions and whatever is left
Date: Wed, 11 Dec 2013 14:11:58 -0500
Message-Id: <1386789118-24733-7-git-send-email-tj@kernel.org>
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

* s/sysfs_*()/kernfs_*()/ in all internal functions
* s/sysfs/kernfs/ in internal strings, comments and whatever is remaining
* Uniformly rename various vfs operations so that they're consistently
  named and distinguishable.

This patch is strictly rename only and doesn't introduce any
functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             | 212 ++++++++++++++++++++++----------------------
 fs/kernfs/file.c            | 121 ++++++++++++-------------
 fs/kernfs/inode.c           |  66 +++++++-------
 fs/kernfs/kernfs-internal.h |  44 ++++-----
 fs/kernfs/mount.c           |  18 ++--
 fs/kernfs/symlink.c         |  44 ++++-----
 6 files changed, 254 insertions(+), 251 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index d3c6623..6520066 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -22,13 +22,13 @@ DEFINE_MUTEX(kernfs_mutex);
 #define rb_to_kn(X) rb_entry((X), struct kernfs_node, rb)
 
 /**
- *	sysfs_name_hash
+ *	kernfs_name_hash
  *	@name: Null terminated string to hash
  *	@ns:   Namespace tag to hash
  *
  *	Returns 31 bit hash of ns + name (so it fits in an off_t )
  */
-static unsigned int sysfs_name_hash(const char *name, const void *ns)
+static unsigned int kernfs_name_hash(const char *name, const void *ns)
 {
 	unsigned long hash = init_name_hash();
 	unsigned int len = strlen(name);
@@ -44,8 +44,8 @@ static unsigned int sysfs_name_hash(const char *name, const void *ns)
 	return hash;
 }
 
-static int sysfs_name_compare(unsigned int hash, const char *name,
-			      const void *ns, const struct kernfs_node *kn)
+static int kernfs_name_compare(unsigned int hash, const char *name,
+			       const void *ns, const struct kernfs_node *kn)
 {
 	if (hash != kn->hash)
 		return hash - kn->hash;
@@ -54,14 +54,14 @@ static int sysfs_name_compare(unsigned int hash, const char *name,
 	return strcmp(name, kn->name);
 }
 
-static int sysfs_sd_compare(const struct kernfs_node *left,
-			    const struct kernfs_node *right)
+static int kernfs_sd_compare(const struct kernfs_node *left,
+			     const struct kernfs_node *right)
 {
-	return sysfs_name_compare(left->hash, left->name, left->ns, right);
+	return kernfs_name_compare(left->hash, left->name, left->ns, right);
 }
 
 /**
- *	sysfs_link_sibling - link kernfs_node into sibling rbtree
+ *	kernfs_link_sibling - link kernfs_node into sibling rbtree
  *	@kn: kernfs_node of interest
  *
  *	Link @kn into its sibling rbtree which starts from
@@ -73,7 +73,7 @@ static int sysfs_sd_compare(const struct kernfs_node *left,
  *	RETURNS:
  *	0 on susccess -EEXIST on failure.
  */
-static int sysfs_link_sibling(struct kernfs_node *kn)
+static int kernfs_link_sibling(struct kernfs_node *kn)
 {
 	struct rb_node **node = &kn->parent->dir.children.rb_node;
 	struct rb_node *parent = NULL;
@@ -87,7 +87,7 @@ static int sysfs_link_sibling(struct kernfs_node *kn)
 
 		pos = rb_to_kn(*node);
 		parent = *node;
-		result = sysfs_sd_compare(kn, pos);
+		result = kernfs_sd_compare(kn, pos);
 		if (result < 0)
 			node = &pos->rb.rb_left;
 		else if (result > 0)
@@ -102,7 +102,7 @@ static int sysfs_link_sibling(struct kernfs_node *kn)
 }
 
 /**
- *	sysfs_unlink_sibling - unlink kernfs_node from sibling rbtree
+ *	kernfs_unlink_sibling - unlink kernfs_node from sibling rbtree
  *	@kn: kernfs_node of interest
  *
  *	Unlink @kn from its sibling rbtree which starts from
@@ -111,7 +111,7 @@ static int sysfs_link_sibling(struct kernfs_node *kn)
  *	Locking:
  *	mutex_lock(kernfs_mutex)
  */
-static void sysfs_unlink_sibling(struct kernfs_node *kn)
+static void kernfs_unlink_sibling(struct kernfs_node *kn)
 {
 	if (kernfs_type(kn) == KERNFS_DIR)
 		kn->parent->dir.subdirs--;
@@ -120,7 +120,7 @@ static void sysfs_unlink_sibling(struct kernfs_node *kn)
 }
 
 /**
- *	sysfs_get_active - get an active reference to kernfs_node
+ *	kernfs_get_active - get an active reference to kernfs_node
  *	@kn: kernfs_node to get an active reference to
  *
  *	Get an active reference of @kn.  This function is noop if @kn
@@ -129,7 +129,7 @@ static void sysfs_unlink_sibling(struct kernfs_node *kn)
  *	RETURNS:
  *	Pointer to @kn on success, NULL on failure.
  */
-struct kernfs_node *sysfs_get_active(struct kernfs_node *kn)
+struct kernfs_node *kernfs_get_active(struct kernfs_node *kn)
 {
 	if (unlikely(!kn))
 		return NULL;
@@ -143,13 +143,13 @@ struct kernfs_node *sysfs_get_active(struct kernfs_node *kn)
 }
 
 /**
- *	sysfs_put_active - put an active reference to kernfs_node
+ *	kernfs_put_active - put an active reference to kernfs_node
  *	@kn: kernfs_node to put an active reference to
  *
  *	Put an active reference to @kn.  This function is noop if @kn
  *	is NULL.
  */
-void sysfs_put_active(struct kernfs_node *kn)
+void kernfs_put_active(struct kernfs_node *kn)
 {
 	int v;
 
@@ -170,12 +170,12 @@ void sysfs_put_active(struct kernfs_node *kn)
 }
 
 /**
- *	sysfs_deactivate - deactivate kernfs_node
+ *	kernfs_deactivate - deactivate kernfs_node
  *	@kn: kernfs_node to deactivate
  *
  *	Deny new active references and drain existing ones.
  */
-static void sysfs_deactivate(struct kernfs_node *kn)
+static void kernfs_deactivate(struct kernfs_node *kn)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	int v;
@@ -235,9 +235,8 @@ void kernfs_put(struct kernfs_node *kn)
 	 */
 	parent = kn->parent;
 
-	WARN(!(kn->flags & KERNFS_REMOVED),
-		"sysfs: free using entry: %s/%s\n",
-		parent ? parent->name : "", kn->name);
+	WARN(!(kn->flags & KERNFS_REMOVED), "kernfs: free using entry: %s/%s\n",
+	     parent ? parent->name : "", kn->name);
 
 	if (kernfs_type(kn) == KERNFS_LINK)
 		kernfs_put(kn->symlink.target_kn);
@@ -265,13 +264,13 @@ void kernfs_put(struct kernfs_node *kn)
 }
 EXPORT_SYMBOL_GPL(kernfs_put);
 
-static int sysfs_dentry_delete(const struct dentry *dentry)
+static int kernfs_dop_delete(const struct dentry *dentry)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
 	return !(kn && !(kn->flags & KERNFS_REMOVED));
 }
 
-static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
+static int kernfs_dop_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct kernfs_node *kn;
 
@@ -281,19 +280,19 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 	kn = dentry->d_fsdata;
 	mutex_lock(&kernfs_mutex);
 
-	/* The sysfs dirent has been deleted */
+	/* The kernfs node has been deleted */
 	if (kn->flags & KERNFS_REMOVED)
 		goto out_bad;
 
-	/* The sysfs dirent has been moved? */
+	/* The kernfs node has been moved? */
 	if (dentry->d_parent->d_fsdata != kn->parent)
 		goto out_bad;
 
-	/* The sysfs dirent has been renamed */
+	/* The kernfs node has been renamed */
 	if (strcmp(dentry->d_name.name, kn->name) != 0)
 		goto out_bad;
 
-	/* The sysfs dirent has been moved to a different namespace */
+	/* The kernfs node has been moved to a different namespace */
 	if (kn->parent && kernfs_ns_enabled(kn->parent) &&
 	    kernfs_info(dentry->d_sb)->ns != kn->ns)
 		goto out_bad;
@@ -302,9 +301,10 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 out_valid:
 	return 1;
 out_bad:
-	/* Remove the dentry from the dcache hashes.
+	/*
+	 * Remove the dentry from the dcache hashes.
 	 * If this is a deleted dentry we use d_drop instead of d_delete
-	 * so sysfs doesn't need to cope with negative dentries.
+	 * so kernfs doesn't need to cope with negative dentries.
 	 *
 	 * If this is a dentry that has simply been renamed we
 	 * use d_drop to remove it from the dcache lookup on its
@@ -324,19 +324,19 @@ out_bad:
 	return 0;
 }
 
-static void sysfs_dentry_release(struct dentry *dentry)
+static void kernfs_dop_release(struct dentry *dentry)
 {
 	kernfs_put(dentry->d_fsdata);
 }
 
 const struct dentry_operations kernfs_dops = {
-	.d_revalidate	= sysfs_dentry_revalidate,
-	.d_delete	= sysfs_dentry_delete,
-	.d_release	= sysfs_dentry_release,
+	.d_revalidate	= kernfs_dop_revalidate,
+	.d_delete	= kernfs_dop_delete,
+	.d_release	= kernfs_dop_release,
 };
 
-struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
-				     const char *name, umode_t mode, int type)
+struct kernfs_node *kernfs_new_node(struct kernfs_root *root, const char *name,
+				    umode_t mode, int type)
 {
 	char *dup_name = NULL;
 	struct kernfs_node *kn;
@@ -374,7 +374,7 @@ struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
 }
 
 /**
- *	sysfs_addrm_start - prepare for kernfs_node add/remove
+ *	kernfs_addrm_start - prepare for kernfs_node add/remove
  *	@acxt: pointer to kernfs_addrm_cxt to be used
  *
  *	This function is called when the caller is about to add or remove
@@ -385,7 +385,7 @@ struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
  *	Kernel thread context (may sleep).  kernfs_mutex is locked on
  *	return.
  */
-void sysfs_addrm_start(struct kernfs_addrm_cxt *acxt)
+void kernfs_addrm_start(struct kernfs_addrm_cxt *acxt)
 	__acquires(kernfs_mutex)
 {
 	memset(acxt, 0, sizeof(*acxt));
@@ -394,7 +394,7 @@ void sysfs_addrm_start(struct kernfs_addrm_cxt *acxt)
 }
 
 /**
- *	sysfs_add_one - add kernfs_node to parent without warning
+ *	kernfs_add_one - add kernfs_node to parent without warning
  *	@acxt: addrm context to use
  *	@kn: kernfs_node to be added
  *	@parent: the parent kernfs_node to add @kn to
@@ -404,17 +404,17 @@ void sysfs_addrm_start(struct kernfs_addrm_cxt *acxt)
  *	of the parent.
  *
  *	This function should be called between calls to
- *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
- *	passed the same @acxt as passed to sysfs_addrm_start().
+ *	kernfs_addrm_start() and kernfs_addrm_finish() and should be passed
+ *	the same @acxt as passed to kernfs_addrm_start().
  *
  *	LOCKING:
- *	Determined by sysfs_addrm_start().
+ *	Determined by kernfs_addrm_start().
  *
  *	RETURNS:
  *	0 on success, -EEXIST if entry with the given name already
  *	exists.
  */
-int sysfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
+int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 		  struct kernfs_node *parent)
 {
 	bool has_ns = kernfs_ns_enabled(parent);
@@ -422,7 +422,7 @@ int sysfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 	int ret;
 
 	if (has_ns != (bool)kn->ns) {
-		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
+		WARN(1, KERN_WARNING "kernfs: ns %s in '%s' for '%s'\n",
 		     has_ns ? "required" : "invalid", parent->name, kn->name);
 		return -EINVAL;
 	}
@@ -430,11 +430,11 @@ int sysfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 	if (kernfs_type(parent) != KERNFS_DIR)
 		return -EINVAL;
 
-	kn->hash = sysfs_name_hash(kn->name, kn->ns);
+	kn->hash = kernfs_name_hash(kn->name, kn->ns);
 	kn->parent = parent;
 	kernfs_get(parent);
 
-	ret = sysfs_link_sibling(kn);
+	ret = kernfs_link_sibling(kn);
 	if (ret)
 		return ret;
 
@@ -452,7 +452,7 @@ int sysfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 }
 
 /**
- *	sysfs_remove_one - remove kernfs_node from parent
+ *	kernfs_remove_one - remove kernfs_node from parent
  *	@acxt: addrm context to use
  *	@kn: kernfs_node to be removed
  *
@@ -460,14 +460,14 @@ int sysfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
  *	directory.  @kn is unlinked from the children list.
  *
  *	This function should be called between calls to
- *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
- *	passed the same @acxt as passed to sysfs_addrm_start().
+ *	kernfs_addrm_start() and kernfs_addrm_finish() and should be
+ *	passed the same @acxt as passed to kernfs_addrm_start().
  *
  *	LOCKING:
- *	Determined by sysfs_addrm_start().
+ *	Determined by kernfs_addrm_start().
  */
-static void sysfs_remove_one(struct kernfs_addrm_cxt *acxt,
-			     struct kernfs_node *kn)
+static void kernfs_remove_one(struct kernfs_addrm_cxt *acxt,
+			      struct kernfs_node *kn)
 {
 	struct kernfs_iattrs *ps_iattr;
 
@@ -479,7 +479,7 @@ static void sysfs_remove_one(struct kernfs_addrm_cxt *acxt,
 		return;
 
 	if (kn->parent) {
-		sysfs_unlink_sibling(kn);
+		kernfs_unlink_sibling(kn);
 
 		/* Update timestamps on the parent */
 		ps_iattr = kn->parent->iattr;
@@ -495,20 +495,20 @@ static void sysfs_remove_one(struct kernfs_addrm_cxt *acxt,
 }
 
 /**
- *	sysfs_addrm_finish - finish up kernfs_node add/remove
+ *	kernfs_addrm_finish - finish up kernfs_node add/remove
  *	@acxt: addrm context to finish up
  *
  *	Finish up kernfs_node add/remove.  Resources acquired by
- *	sysfs_addrm_start() are released and removed kernfs_nodes are
+ *	kernfs_addrm_start() are released and removed kernfs_nodes are
  *	cleaned up.
  *
  *	LOCKING:
  *	kernfs_mutex is released.
  */
-void sysfs_addrm_finish(struct kernfs_addrm_cxt *acxt)
+void kernfs_addrm_finish(struct kernfs_addrm_cxt *acxt)
 	__releases(kernfs_mutex)
 {
-	/* release resources acquired by sysfs_addrm_start() */
+	/* release resources acquired by kernfs_addrm_start() */
 	mutex_unlock(&kernfs_mutex);
 
 	/* kill removed kernfs_nodes */
@@ -517,8 +517,8 @@ void sysfs_addrm_finish(struct kernfs_addrm_cxt *acxt)
 
 		acxt->removed = kn->u.removed_list;
 
-		sysfs_deactivate(kn);
-		sysfs_unmap_bin_file(kn);
+		kernfs_deactivate(kn);
+		kernfs_unmap_bin_file(kn);
 		kernfs_put(kn);
 	}
 }
@@ -543,18 +543,18 @@ static struct kernfs_node *kernfs_find_ns(struct kernfs_node *parent,
 	lockdep_assert_held(&kernfs_mutex);
 
 	if (has_ns != (bool)ns) {
-		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
+		WARN(1, KERN_WARNING "kernfs: ns %s in '%s' for '%s'\n",
 		     has_ns ? "required" : "invalid", parent->name, name);
 		return NULL;
 	}
 
-	hash = sysfs_name_hash(name, ns);
+	hash = kernfs_name_hash(name, ns);
 	while (node) {
 		struct kernfs_node *kn;
 		int result;
 
 		kn = rb_to_kn(node);
-		result = sysfs_name_compare(hash, name, ns, kn);
+		result = kernfs_name_compare(hash, name, ns, kn);
 		if (result < 0)
 			node = node->rb_left;
 		else if (result > 0)
@@ -607,7 +607,7 @@ struct kernfs_root *kernfs_create_root(void *priv)
 
 	ida_init(&root->ino_ida);
 
-	kn = sysfs_new_dirent(root, "", S_IFDIR | S_IRUGO | S_IXUGO, KERNFS_DIR);
+	kn = kernfs_new_node(root, "", S_IFDIR | S_IRUGO | S_IXUGO, KERNFS_DIR);
 	if (!kn) {
 		ida_destroy(&root->ino_ida);
 		kfree(root);
@@ -654,7 +654,7 @@ struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
 	int rc;
 
 	/* allocate */
-	kn = sysfs_new_dirent(kernfs_root(parent), name, mode, KERNFS_DIR);
+	kn = kernfs_new_node(kernfs_root(parent), name, mode, KERNFS_DIR);
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
@@ -663,9 +663,9 @@ struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
 	kn->priv = priv;
 
 	/* link in */
-	sysfs_addrm_start(&acxt);
-	rc = sysfs_add_one(&acxt, kn, parent);
-	sysfs_addrm_finish(&acxt);
+	kernfs_addrm_start(&acxt);
+	rc = kernfs_add_one(&acxt, kn, parent);
+	kernfs_addrm_finish(&acxt);
 
 	if (!rc)
 		return kn;
@@ -674,8 +674,9 @@ struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
 	return ERR_PTR(rc);
 }
 
-static struct dentry *sysfs_lookup(struct inode *dir, struct dentry *dentry,
-				   unsigned int flags)
+static struct dentry *kernfs_iop_lookup(struct inode *dir,
+					struct dentry *dentry,
+					unsigned int flags)
 {
 	struct dentry *ret = NULL;
 	struct kernfs_node *parent = dentry->d_parent->d_fsdata;
@@ -699,7 +700,7 @@ static struct dentry *sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	dentry->d_fsdata = kn;
 
 	/* attach dentry and inode */
-	inode = sysfs_get_inode(dir->i_sb, kn);
+	inode = kernfs_get_inode(dir->i_sb, kn);
 	if (!inode) {
 		ret = ERR_PTR(-ENOMEM);
 		goto out_unlock;
@@ -713,17 +714,17 @@ static struct dentry *sysfs_lookup(struct inode *dir, struct dentry *dentry,
 }
 
 const struct inode_operations kernfs_dir_iops = {
-	.lookup		= sysfs_lookup,
-	.permission	= sysfs_permission,
-	.setattr	= sysfs_setattr,
-	.getattr	= sysfs_getattr,
-	.setxattr	= sysfs_setxattr,
-	.removexattr	= sysfs_removexattr,
-	.getxattr	= sysfs_getxattr,
-	.listxattr	= sysfs_listxattr,
+	.lookup		= kernfs_iop_lookup,
+	.permission	= kernfs_iop_permission,
+	.setattr	= kernfs_iop_setattr,
+	.getattr	= kernfs_iop_getattr,
+	.setxattr	= kernfs_iop_setxattr,
+	.removexattr	= kernfs_iop_removexattr,
+	.getxattr	= kernfs_iop_getxattr,
+	.listxattr	= kernfs_iop_listxattr,
 };
 
-static struct kernfs_node *sysfs_leftmost_descendant(struct kernfs_node *pos)
+static struct kernfs_node *kernfs_leftmost_descendant(struct kernfs_node *pos)
 {
 	struct kernfs_node *last;
 
@@ -746,7 +747,7 @@ static struct kernfs_node *sysfs_leftmost_descendant(struct kernfs_node *pos)
 }
 
 /**
- * sysfs_next_descendant_post - find the next descendant for post-order walk
+ * kernfs_next_descendant_post - find the next descendant for post-order walk
  * @pos: the current position (%NULL to initiate traversal)
  * @root: kernfs_node whose descendants to walk
  *
@@ -754,8 +755,8 @@ static struct kernfs_node *sysfs_leftmost_descendant(struct kernfs_node *pos)
  * descendants.  @root is included in the iteration and the last node to be
  * visited.
  */
-static struct kernfs_node *sysfs_next_descendant_post(struct kernfs_node *pos,
-						      struct kernfs_node *root)
+static struct kernfs_node *kernfs_next_descendant_post(struct kernfs_node *pos,
+						       struct kernfs_node *root)
 {
 	struct rb_node *rbn;
 
@@ -763,7 +764,7 @@ static struct kernfs_node *sysfs_next_descendant_post(struct kernfs_node *pos,
 
 	/* if first iteration, visit leftmost descendant which may be root */
 	if (!pos)
-		return sysfs_leftmost_descendant(root);
+		return kernfs_leftmost_descendant(root);
 
 	/* if we visited @root, we're done */
 	if (pos == root)
@@ -772,7 +773,7 @@ static struct kernfs_node *sysfs_next_descendant_post(struct kernfs_node *pos,
 	/* if there's an unvisited sibling, visit its leftmost descendant */
 	rbn = rb_next(&pos->rb);
 	if (rbn)
-		return sysfs_leftmost_descendant(rb_to_kn(rbn));
+		return kernfs_leftmost_descendant(rb_to_kn(rbn));
 
 	/* no sibling left, visit parent */
 	return pos->parent;
@@ -786,14 +787,14 @@ static void __kernfs_remove(struct kernfs_addrm_cxt *acxt,
 	if (!kn)
 		return;
 
-	pr_debug("sysfs %s: removing\n", kn->name);
+	pr_debug("kernfs %s: removing\n", kn->name);
 
 	next = NULL;
 	do {
 		pos = next;
-		next = sysfs_next_descendant_post(pos, kn);
+		next = kernfs_next_descendant_post(pos, kn);
 		if (pos)
-			sysfs_remove_one(acxt, pos);
+			kernfs_remove_one(acxt, pos);
 	} while (next);
 }
 
@@ -807,9 +808,9 @@ void kernfs_remove(struct kernfs_node *kn)
 {
 	struct kernfs_addrm_cxt acxt;
 
-	sysfs_addrm_start(&acxt);
+	kernfs_addrm_start(&acxt);
 	__kernfs_remove(&acxt, kn);
-	sysfs_addrm_finish(&acxt);
+	kernfs_addrm_finish(&acxt);
 }
 
 /**
@@ -828,18 +829,18 @@ int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 	struct kernfs_node *kn;
 
 	if (!parent) {
-		WARN(1, KERN_WARNING "sysfs: can not remove '%s', no directory\n",
+		WARN(1, KERN_WARNING "kernfs: can not remove '%s', no directory\n",
 			name);
 		return -ENOENT;
 	}
 
-	sysfs_addrm_start(&acxt);
+	kernfs_addrm_start(&acxt);
 
 	kn = kernfs_find_ns(parent, name, ns);
 	if (kn)
 		__kernfs_remove(&acxt, kn);
 
-	sysfs_addrm_finish(&acxt);
+	kernfs_addrm_finish(&acxt);
 
 	if (kn)
 		return 0;
@@ -884,13 +885,13 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	/*
 	 * Move to the appropriate place in the appropriate directories rbtree.
 	 */
-	sysfs_unlink_sibling(kn);
+	kernfs_unlink_sibling(kn);
 	kernfs_get(new_parent);
 	kernfs_put(kn->parent);
 	kn->ns = new_ns;
-	kn->hash = sysfs_name_hash(kn->name, kn->ns);
+	kn->hash = kernfs_name_hash(kn->name, kn->ns);
 	kn->parent = new_parent;
-	sysfs_link_sibling(kn);
+	kernfs_link_sibling(kn);
 
 	error = 0;
  out:
@@ -904,13 +905,13 @@ static inline unsigned char dt_type(struct kernfs_node *kn)
 	return (kn->mode >> 12) & 15;
 }
 
-static int sysfs_dir_release(struct inode *inode, struct file *filp)
+static int kernfs_dir_fop_release(struct inode *inode, struct file *filp)
 {
 	kernfs_put(filp->private_data);
 	return 0;
 }
 
-static struct kernfs_node *sysfs_dir_pos(const void *ns,
+static struct kernfs_node *kernfs_dir_pos(const void *ns,
 	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos)
 {
 	if (pos) {
@@ -944,10 +945,10 @@ static struct kernfs_node *sysfs_dir_pos(const void *ns,
 	return pos;
 }
 
-static struct kernfs_node *sysfs_dir_next_pos(const void *ns,
+static struct kernfs_node *kernfs_dir_next_pos(const void *ns,
 	struct kernfs_node *parent, ino_t ino, struct kernfs_node *pos)
 {
-	pos = sysfs_dir_pos(ns, parent, ino, pos);
+	pos = kernfs_dir_pos(ns, parent, ino, pos);
 	if (pos)
 		do {
 			struct rb_node *node = rb_next(&pos->rb);
@@ -959,7 +960,7 @@ static struct kernfs_node *sysfs_dir_next_pos(const void *ns,
 	return pos;
 }
 
-static int sysfs_readdir(struct file *file, struct dir_context *ctx)
+static int kernfs_fop_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct kernfs_node *parent = dentry->d_fsdata;
@@ -973,9 +974,9 @@ static int sysfs_readdir(struct file *file, struct dir_context *ctx)
 	if (kernfs_ns_enabled(parent))
 		ns = kernfs_info(dentry->d_sb)->ns;
 
-	for (pos = sysfs_dir_pos(ns, parent, ctx->pos, pos);
+	for (pos = kernfs_dir_pos(ns, parent, ctx->pos, pos);
 	     pos;
-	     pos = sysfs_dir_next_pos(ns, parent, ctx->pos, pos)) {
+	     pos = kernfs_dir_next_pos(ns, parent, ctx->pos, pos)) {
 		const char *name = pos->name;
 		unsigned int type = dt_type(pos);
 		int len = strlen(name);
@@ -996,7 +997,8 @@ static int sysfs_readdir(struct file *file, struct dir_context *ctx)
 	return 0;
 }
 
-static loff_t sysfs_dir_llseek(struct file *file, loff_t offset, int whence)
+static loff_t kernfs_dir_fop_llseek(struct file *file, loff_t offset,
+				    int whence)
 {
 	struct inode *inode = file_inode(file);
 	loff_t ret;
@@ -1010,7 +1012,7 @@ static loff_t sysfs_dir_llseek(struct file *file, loff_t offset, int whence)
 
 const struct file_operations kernfs_dir_fops = {
 	.read		= generic_read_dir,
-	.iterate	= sysfs_readdir,
-	.release	= sysfs_dir_release,
-	.llseek		= sysfs_dir_llseek,
+	.iterate	= kernfs_fop_readdir,
+	.release	= kernfs_dir_fop_release,
+	.llseek		= kernfs_dir_fop_llseek,
 };
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 32364dd..053cfd9 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -64,7 +64,7 @@ static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
 	 * the ops aren't called concurrently for the same open file.
 	 */
 	mutex_lock(&of->mutex);
-	if (!sysfs_get_active(of->kn))
+	if (!kernfs_get_active(of->kn))
 		return ERR_PTR(-ENODEV);
 
 	ops = kernfs_ops(of->kn);
@@ -104,7 +104,7 @@ static void kernfs_seq_stop(struct seq_file *sf, void *v)
 	if (ops->seq_stop)
 		ops->seq_stop(sf, v);
 
-	sysfs_put_active(of->kn);
+	kernfs_put_active(of->kn);
 	mutex_unlock(&of->mutex);
 }
 
@@ -147,7 +147,7 @@ static ssize_t kernfs_file_direct_read(struct kernfs_open_file *of,
 	 * the ops aren't called concurrently for the same open file.
 	 */
 	mutex_lock(&of->mutex);
-	if (!sysfs_get_active(of->kn)) {
+	if (!kernfs_get_active(of->kn)) {
 		len = -ENODEV;
 		mutex_unlock(&of->mutex);
 		goto out_free;
@@ -159,7 +159,7 @@ static ssize_t kernfs_file_direct_read(struct kernfs_open_file *of,
 	else
 		len = -EINVAL;
 
-	sysfs_put_active(of->kn);
+	kernfs_put_active(of->kn);
 	mutex_unlock(&of->mutex);
 
 	if (len < 0)
@@ -178,14 +178,14 @@ static ssize_t kernfs_file_direct_read(struct kernfs_open_file *of,
 }
 
 /**
- * kernfs_file_read - kernfs vfs read callback
+ * kernfs_fop_read - kernfs vfs read callback
  * @file: file pointer
  * @user_buf: data to write
  * @count: number of bytes
  * @ppos: starting offset
  */
-static ssize_t kernfs_file_read(struct file *file, char __user *user_buf,
-				size_t count, loff_t *ppos)
+static ssize_t kernfs_fop_read(struct file *file, char __user *user_buf,
+			       size_t count, loff_t *ppos)
 {
 	struct kernfs_open_file *of = kernfs_of(file);
 
@@ -196,7 +196,7 @@ static ssize_t kernfs_file_read(struct file *file, char __user *user_buf,
 }
 
 /**
- * kernfs_file_write - kernfs vfs write callback
+ * kernfs_fop_write - kernfs vfs write callback
  * @file: file pointer
  * @user_buf: data to write
  * @count: number of bytes
@@ -211,8 +211,8 @@ static ssize_t kernfs_file_read(struct file *file, char __user *user_buf,
  * modify only the the value you're changing, then write entire buffer
  * back.
  */
-static ssize_t kernfs_file_write(struct file *file, const char __user *user_buf,
-				 size_t count, loff_t *ppos)
+static ssize_t kernfs_fop_write(struct file *file, const char __user *user_buf,
+				size_t count, loff_t *ppos)
 {
 	struct kernfs_open_file *of = kernfs_of(file);
 	ssize_t len = min_t(size_t, count, PAGE_SIZE);
@@ -234,7 +234,7 @@ static ssize_t kernfs_file_write(struct file *file, const char __user *user_buf,
 	 * the ops aren't called concurrently for the same open file.
 	 */
 	mutex_lock(&of->mutex);
-	if (!sysfs_get_active(of->kn)) {
+	if (!kernfs_get_active(of->kn)) {
 		mutex_unlock(&of->mutex);
 		len = -ENODEV;
 		goto out_free;
@@ -246,7 +246,7 @@ static ssize_t kernfs_file_write(struct file *file, const char __user *user_buf,
 	else
 		len = -EINVAL;
 
-	sysfs_put_active(of->kn);
+	kernfs_put_active(of->kn);
 	mutex_unlock(&of->mutex);
 
 	if (len > 0)
@@ -264,13 +264,13 @@ static void kernfs_vma_open(struct vm_area_struct *vma)
 	if (!of->vm_ops)
 		return;
 
-	if (!sysfs_get_active(of->kn))
+	if (!kernfs_get_active(of->kn))
 		return;
 
 	if (of->vm_ops->open)
 		of->vm_ops->open(vma);
 
-	sysfs_put_active(of->kn);
+	kernfs_put_active(of->kn);
 }
 
 static int kernfs_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
@@ -282,14 +282,14 @@ static int kernfs_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (!of->vm_ops)
 		return VM_FAULT_SIGBUS;
 
-	if (!sysfs_get_active(of->kn))
+	if (!kernfs_get_active(of->kn))
 		return VM_FAULT_SIGBUS;
 
 	ret = VM_FAULT_SIGBUS;
 	if (of->vm_ops->fault)
 		ret = of->vm_ops->fault(vma, vmf);
 
-	sysfs_put_active(of->kn);
+	kernfs_put_active(of->kn);
 	return ret;
 }
 
@@ -303,7 +303,7 @@ static int kernfs_vma_page_mkwrite(struct vm_area_struct *vma,
 	if (!of->vm_ops)
 		return VM_FAULT_SIGBUS;
 
-	if (!sysfs_get_active(of->kn))
+	if (!kernfs_get_active(of->kn))
 		return VM_FAULT_SIGBUS;
 
 	ret = 0;
@@ -312,7 +312,7 @@ static int kernfs_vma_page_mkwrite(struct vm_area_struct *vma,
 	else
 		file_update_time(file);
 
-	sysfs_put_active(of->kn);
+	kernfs_put_active(of->kn);
 	return ret;
 }
 
@@ -326,14 +326,14 @@ static int kernfs_vma_access(struct vm_area_struct *vma, unsigned long addr,
 	if (!of->vm_ops)
 		return -EINVAL;
 
-	if (!sysfs_get_active(of->kn))
+	if (!kernfs_get_active(of->kn))
 		return -EINVAL;
 
 	ret = -EINVAL;
 	if (of->vm_ops->access)
 		ret = of->vm_ops->access(vma, addr, buf, len, write);
 
-	sysfs_put_active(of->kn);
+	kernfs_put_active(of->kn);
 	return ret;
 }
 
@@ -348,14 +348,14 @@ static int kernfs_vma_set_policy(struct vm_area_struct *vma,
 	if (!of->vm_ops)
 		return 0;
 
-	if (!sysfs_get_active(of->kn))
+	if (!kernfs_get_active(of->kn))
 		return -EINVAL;
 
 	ret = 0;
 	if (of->vm_ops->set_policy)
 		ret = of->vm_ops->set_policy(vma, new);
 
-	sysfs_put_active(of->kn);
+	kernfs_put_active(of->kn);
 	return ret;
 }
 
@@ -369,14 +369,14 @@ static struct mempolicy *kernfs_vma_get_policy(struct vm_area_struct *vma,
 	if (!of->vm_ops)
 		return vma->vm_policy;
 
-	if (!sysfs_get_active(of->kn))
+	if (!kernfs_get_active(of->kn))
 		return vma->vm_policy;
 
 	pol = vma->vm_policy;
 	if (of->vm_ops->get_policy)
 		pol = of->vm_ops->get_policy(vma, addr);
 
-	sysfs_put_active(of->kn);
+	kernfs_put_active(of->kn);
 	return pol;
 }
 
@@ -391,14 +391,14 @@ static int kernfs_vma_migrate(struct vm_area_struct *vma,
 	if (!of->vm_ops)
 		return 0;
 
-	if (!sysfs_get_active(of->kn))
+	if (!kernfs_get_active(of->kn))
 		return 0;
 
 	ret = 0;
 	if (of->vm_ops->migrate)
 		ret = of->vm_ops->migrate(vma, from, to, flags);
 
-	sysfs_put_active(of->kn);
+	kernfs_put_active(of->kn);
 	return ret;
 }
 #endif
@@ -415,7 +415,7 @@ static const struct vm_operations_struct kernfs_vm_ops = {
 #endif
 };
 
-static int kernfs_file_mmap(struct file *file, struct vm_area_struct *vma)
+static int kernfs_fop_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct kernfs_open_file *of = kernfs_of(file);
 	const struct kernfs_ops *ops;
@@ -434,7 +434,7 @@ static int kernfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	mutex_lock(&of->mutex);
 
 	rc = -ENODEV;
-	if (!sysfs_get_active(of->kn))
+	if (!kernfs_get_active(of->kn))
 		goto out_unlock;
 
 	ops = kernfs_ops(of->kn);
@@ -465,7 +465,7 @@ static int kernfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	of->vm_ops = vma->vm_ops;
 	vma->vm_ops = &kernfs_vm_ops;
 out_put:
-	sysfs_put_active(of->kn);
+	kernfs_put_active(of->kn);
 out_unlock:
 	mutex_unlock(&of->mutex);
 
@@ -473,7 +473,7 @@ out_unlock:
 }
 
 /**
- *	sysfs_get_open_dirent - get or create kernfs_open_node
+ *	kernfs_get_open_node - get or create kernfs_open_node
  *	@kn: target kernfs_node
  *	@of: kernfs_open_file for this instance of open
  *
@@ -486,8 +486,8 @@ out_unlock:
  *	RETURNS:
  *	0 on success, -errno on failure.
  */
-static int sysfs_get_open_dirent(struct kernfs_node *kn,
-				 struct kernfs_open_file *of)
+static int kernfs_get_open_node(struct kernfs_node *kn,
+				struct kernfs_open_file *of)
 {
 	struct kernfs_open_node *on, *new_on = NULL;
 
@@ -527,7 +527,7 @@ static int sysfs_get_open_dirent(struct kernfs_node *kn,
 }
 
 /**
- *	sysfs_put_open_dirent - put kernfs_open_node
+ *	kernfs_put_open_node - put kernfs_open_node
  *	@kn: target kernfs_nodet
  *	@of: associated kernfs_open_file
  *
@@ -537,8 +537,8 @@ static int sysfs_get_open_dirent(struct kernfs_node *kn,
  *	LOCKING:
  *	None.
  */
-static void sysfs_put_open_dirent(struct kernfs_node *kn,
-				  struct kernfs_open_file *of)
+static void kernfs_put_open_node(struct kernfs_node *kn,
+				 struct kernfs_open_file *of)
 {
 	struct kernfs_open_node *on = kn->attr.open;
 	unsigned long flags;
@@ -560,7 +560,7 @@ static void sysfs_put_open_dirent(struct kernfs_node *kn,
 	kfree(on);
 }
 
-static int kernfs_file_open(struct inode *inode, struct file *file)
+static int kernfs_fop_open(struct inode *inode, struct file *file)
 {
 	struct kernfs_node *kn = file->f_path.dentry->d_fsdata;
 	const struct kernfs_ops *ops;
@@ -568,7 +568,7 @@ static int kernfs_file_open(struct inode *inode, struct file *file)
 	bool has_read, has_write, has_mmap;
 	int error = -EACCES;
 
-	if (!sysfs_get_active(kn))
+	if (!kernfs_get_active(kn))
 		return -ENODEV;
 
 	ops = kernfs_ops(kn);
@@ -633,13 +633,13 @@ static int kernfs_file_open(struct inode *inode, struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		file->f_mode |= FMODE_PWRITE;
 
-	/* make sure we have open dirent struct */
-	error = sysfs_get_open_dirent(kn, of);
+	/* make sure we have open node struct */
+	error = kernfs_get_open_node(kn, of);
 	if (error)
 		goto err_close;
 
 	/* open succeeded, put active references */
-	sysfs_put_active(kn);
+	kernfs_put_active(kn);
 	return 0;
 
 err_close:
@@ -647,23 +647,23 @@ err_close:
 err_free:
 	kfree(of);
 err_out:
-	sysfs_put_active(kn);
+	kernfs_put_active(kn);
 	return error;
 }
 
-static int kernfs_file_release(struct inode *inode, struct file *filp)
+static int kernfs_fop_release(struct inode *inode, struct file *filp)
 {
 	struct kernfs_node *kn = filp->f_path.dentry->d_fsdata;
 	struct kernfs_open_file *of = kernfs_of(filp);
 
-	sysfs_put_open_dirent(kn, of);
+	kernfs_put_open_node(kn, of);
 	seq_release(inode, filp);
 	kfree(of);
 
 	return 0;
 }
 
-void sysfs_unmap_bin_file(struct kernfs_node *kn)
+void kernfs_unmap_bin_file(struct kernfs_node *kn)
 {
 	struct kernfs_open_node *on;
 	struct kernfs_open_file *of;
@@ -686,10 +686,11 @@ void sysfs_unmap_bin_file(struct kernfs_node *kn)
 	}
 	mutex_unlock(&kernfs_open_file_mutex);
 
-	sysfs_put_open_dirent(kn, NULL);
+	kernfs_put_open_node(kn, NULL);
 }
 
-/* Sysfs attribute files are pollable.  The idea is that you read
+/*
+ * Kernfs attribute files are pollable.  The idea is that you read
  * the content and then you use 'poll' or 'select' to wait for
  * the content to change.  When the content changes (assuming the
  * manager for the kobject supports notification), poll will
@@ -702,19 +703,19 @@ void sysfs_unmap_bin_file(struct kernfs_node *kn)
  * to see if it supports poll (Neither 'poll' nor 'select' return
  * an appropriate error code).  When in doubt, set a suitable timeout value.
  */
-static unsigned int kernfs_file_poll(struct file *filp, poll_table *wait)
+static unsigned int kernfs_fop_poll(struct file *filp, poll_table *wait)
 {
 	struct kernfs_open_file *of = kernfs_of(filp);
 	struct kernfs_node *kn = filp->f_path.dentry->d_fsdata;
 	struct kernfs_open_node *on = kn->attr.open;
 
 	/* need parent for the kobj, grab both */
-	if (!sysfs_get_active(kn))
+	if (!kernfs_get_active(kn))
 		goto trigger;
 
 	poll_wait(filp, &on->poll, wait);
 
-	sysfs_put_active(kn);
+	kernfs_put_active(kn);
 
 	if (of->event != atomic_read(&on->event))
 		goto trigger;
@@ -751,13 +752,13 @@ void kernfs_notify(struct kernfs_node *kn)
 EXPORT_SYMBOL_GPL(kernfs_notify);
 
 const struct file_operations kernfs_file_fops = {
-	.read		= kernfs_file_read,
-	.write		= kernfs_file_write,
+	.read		= kernfs_fop_read,
+	.write		= kernfs_fop_write,
 	.llseek		= generic_file_llseek,
-	.mmap		= kernfs_file_mmap,
-	.open		= kernfs_file_open,
-	.release	= kernfs_file_release,
-	.poll		= kernfs_file_poll,
+	.mmap		= kernfs_fop_mmap,
+	.open		= kernfs_fop_open,
+	.release	= kernfs_fop_release,
+	.poll		= kernfs_fop_poll,
 };
 
 /**
@@ -784,8 +785,8 @@ struct kernfs_node *kernfs_create_file_ns_key(struct kernfs_node *parent,
 	struct kernfs_node *kn;
 	int rc;
 
-	kn = sysfs_new_dirent(kernfs_root(parent), name,
-			      (mode & S_IALLUGO) | S_IFREG, KERNFS_FILE);
+	kn = kernfs_new_node(kernfs_root(parent), name,
+			     (mode & S_IALLUGO) | S_IFREG, KERNFS_FILE);
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
@@ -811,9 +812,9 @@ struct kernfs_node *kernfs_create_file_ns_key(struct kernfs_node *parent,
 	if (ops->mmap)
 		kn->flags |= KERNFS_HAS_MMAP;
 
-	sysfs_addrm_start(&acxt);
-	rc = sysfs_add_one(&acxt, kn, parent);
-	sysfs_addrm_finish(&acxt);
+	kernfs_addrm_start(&acxt);
+	rc = kernfs_add_one(&acxt, kn, parent);
+	kernfs_addrm_finish(&acxt);
 
 	if (rc) {
 		kernfs_put(kn);
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index c5f231e..e55126f 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -31,16 +31,16 @@ static struct backing_dev_info kernfs_bdi = {
 };
 
 static const struct inode_operations kernfs_iops = {
-	.permission	= sysfs_permission,
-	.setattr	= sysfs_setattr,
-	.getattr	= sysfs_getattr,
-	.setxattr	= sysfs_setxattr,
-	.removexattr	= sysfs_removexattr,
-	.getxattr	= sysfs_getxattr,
-	.listxattr	= sysfs_listxattr,
+	.permission	= kernfs_iop_permission,
+	.setattr	= kernfs_iop_setattr,
+	.getattr	= kernfs_iop_getattr,
+	.setxattr	= kernfs_iop_setxattr,
+	.removexattr	= kernfs_iop_removexattr,
+	.getxattr	= kernfs_iop_getxattr,
+	.listxattr	= kernfs_iop_listxattr,
 };
 
-void __init sysfs_inode_init(void)
+void __init kernfs_inode_init(void)
 {
 	if (bdi_init(&kernfs_bdi))
 		panic("failed to init kernfs_bdi");
@@ -115,7 +115,7 @@ int kernfs_setattr(struct kernfs_node *kn, const struct iattr *iattr)
 	return ret;
 }
 
-int sysfs_setattr(struct dentry *dentry, struct iattr *iattr)
+int kernfs_iop_setattr(struct dentry *dentry, struct iattr *iattr)
 {
 	struct inode *inode = dentry->d_inode;
 	struct kernfs_node *kn = dentry->d_fsdata;
@@ -141,8 +141,8 @@ out:
 	return error;
 }
 
-static int sysfs_sd_setsecdata(struct kernfs_node *kn, void **secdata,
-			       u32 *secdata_len)
+static int kernfs_node_setsecdata(struct kernfs_node *kn, void **secdata,
+				  u32 *secdata_len)
 {
 	struct kernfs_iattrs *attrs;
 	void *old_secdata;
@@ -163,8 +163,8 @@ static int sysfs_sd_setsecdata(struct kernfs_node *kn, void **secdata,
 	return 0;
 }
 
-int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
-		size_t size, int flags)
+int kernfs_iop_setxattr(struct dentry *dentry, const char *name,
+			const void *value, size_t size, int flags)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
 	struct kernfs_iattrs *attrs;
@@ -188,7 +188,7 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 			return error;
 
 		mutex_lock(&kernfs_mutex);
-		error = sysfs_sd_setsecdata(kn, &secdata, &secdata_len);
+		error = kernfs_node_setsecdata(kn, &secdata, &secdata_len);
 		mutex_unlock(&kernfs_mutex);
 
 		if (secdata)
@@ -202,7 +202,7 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 	return -EINVAL;
 }
 
-int sysfs_removexattr(struct dentry *dentry, const char *name)
+int kernfs_iop_removexattr(struct dentry *dentry, const char *name)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
 	struct kernfs_iattrs *attrs;
@@ -214,8 +214,8 @@ int sysfs_removexattr(struct dentry *dentry, const char *name)
 	return simple_xattr_remove(&attrs->xattrs, name);
 }
 
-ssize_t sysfs_getxattr(struct dentry *dentry, const char *name, void *buf,
-		       size_t size)
+ssize_t kernfs_iop_getxattr(struct dentry *dentry, const char *name, void *buf,
+			    size_t size)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
 	struct kernfs_iattrs *attrs;
@@ -227,7 +227,7 @@ ssize_t sysfs_getxattr(struct dentry *dentry, const char *name, void *buf,
 	return simple_xattr_get(&attrs->xattrs, name, buf, size);
 }
 
-ssize_t sysfs_listxattr(struct dentry *dentry, char *buf, size_t size)
+ssize_t kernfs_iop_listxattr(struct dentry *dentry, char *buf, size_t size)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
 	struct kernfs_iattrs *attrs;
@@ -254,7 +254,7 @@ static inline void set_inode_attr(struct inode *inode, struct iattr *iattr)
 	inode->i_ctime = iattr->ia_ctime;
 }
 
-static void sysfs_refresh_inode(struct kernfs_node *kn, struct inode *inode)
+static void kernfs_refresh_inode(struct kernfs_node *kn, struct inode *inode)
 {
 	struct kernfs_iattrs *attrs = kn->iattr;
 
@@ -273,21 +273,21 @@ static void sysfs_refresh_inode(struct kernfs_node *kn, struct inode *inode)
 		set_nlink(inode, kn->dir.subdirs + 2);
 }
 
-int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		  struct kstat *stat)
+int kernfs_iop_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		   struct kstat *stat)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
 	struct inode *inode = dentry->d_inode;
 
 	mutex_lock(&kernfs_mutex);
-	sysfs_refresh_inode(kn, inode);
+	kernfs_refresh_inode(kn, inode);
 	mutex_unlock(&kernfs_mutex);
 
 	generic_fillattr(inode, stat);
 	return 0;
 }
 
-static void sysfs_init_inode(struct kernfs_node *kn, struct inode *inode)
+static void kernfs_init_inode(struct kernfs_node *kn, struct inode *inode)
 {
 	kernfs_get(kn);
 	inode->i_private = kn;
@@ -296,7 +296,7 @@ static void sysfs_init_inode(struct kernfs_node *kn, struct inode *inode)
 	inode->i_op = &kernfs_iops;
 
 	set_default_inode_attr(inode, kn->mode);
-	sysfs_refresh_inode(kn, inode);
+	kernfs_refresh_inode(kn, inode);
 
 	/* initialize inode according to type */
 	switch (kernfs_type(kn)) {
@@ -319,7 +319,7 @@ static void sysfs_init_inode(struct kernfs_node *kn, struct inode *inode)
 }
 
 /**
- *	sysfs_get_inode - get inode for kernfs_node
+ *	kernfs_get_inode - get inode for kernfs_node
  *	@sb: super block
  *	@kn: kernfs_node to allocate inode for
  *
@@ -333,25 +333,25 @@ static void sysfs_init_inode(struct kernfs_node *kn, struct inode *inode)
  *	RETURNS:
  *	Pointer to allocated inode on success, NULL on failure.
  */
-struct inode *sysfs_get_inode(struct super_block *sb, struct kernfs_node *kn)
+struct inode *kernfs_get_inode(struct super_block *sb, struct kernfs_node *kn)
 {
 	struct inode *inode;
 
 	inode = iget_locked(sb, kn->ino);
 	if (inode && (inode->i_state & I_NEW))
-		sysfs_init_inode(kn, inode);
+		kernfs_init_inode(kn, inode);
 
 	return inode;
 }
 
 /*
- * The kernfs_node serves as both an inode and a directory entry for sysfs.
- * To prevent the sysfs inode numbers from being freed prematurely we take
- * a reference to kernfs_node from the sysfs inode.  A
+ * The kernfs_node serves as both an inode and a directory entry for
+ * kernfs.  To prevent the kernfs inode numbers from being freed
+ * prematurely we take a reference to kernfs_node from the kernfs inode.  A
  * super_operations.evict_inode() implementation is needed to drop that
  * reference upon inode destruction.
  */
-void sysfs_evict_inode(struct inode *inode)
+void kernfs_evict_inode(struct inode *inode)
 {
 	struct kernfs_node *kn = inode->i_private;
 
@@ -360,7 +360,7 @@ void sysfs_evict_inode(struct inode *inode)
 	kernfs_put(kn);
 }
 
-int sysfs_permission(struct inode *inode, int mask)
+int kernfs_iop_permission(struct inode *inode, int mask)
 {
 	struct kernfs_node *kn;
 
@@ -370,7 +370,7 @@ int sysfs_permission(struct inode *inode, int mask)
 	kn = inode->i_private;
 
 	mutex_lock(&kernfs_mutex);
-	sysfs_refresh_inode(kn, inode);
+	kernfs_refresh_inode(kn, inode);
 	mutex_unlock(&kernfs_mutex);
 
 	return generic_permission(inode, mask);
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index e62e8ec..a4ff491 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -76,19 +76,19 @@ extern struct kmem_cache *kernfs_node_cache;
 /*
  * inode.c
  */
-struct inode *sysfs_get_inode(struct super_block *sb, struct kernfs_node *kn);
-void sysfs_evict_inode(struct inode *inode);
-int sysfs_permission(struct inode *inode, int mask);
-int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
-int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		  struct kstat *stat);
-int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
-		   size_t size, int flags);
-int sysfs_removexattr(struct dentry *dentry, const char *name);
-ssize_t sysfs_getxattr(struct dentry *dentry, const char *name, void *buf,
-		       size_t size);
-ssize_t sysfs_listxattr(struct dentry *dentry, char *buf, size_t size);
-void sysfs_inode_init(void);
+struct inode *kernfs_get_inode(struct super_block *sb, struct kernfs_node *kn);
+void kernfs_evict_inode(struct inode *inode);
+int kernfs_iop_permission(struct inode *inode, int mask);
+int kernfs_iop_setattr(struct dentry *dentry, struct iattr *iattr);
+int kernfs_iop_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		       struct kstat *stat);
+int kernfs_iop_setxattr(struct dentry *dentry, const char *name, const void *value,
+			size_t size, int flags);
+int kernfs_iop_removexattr(struct dentry *dentry, const char *name);
+ssize_t kernfs_iop_getxattr(struct dentry *dentry, const char *name, void *buf,
+			    size_t size);
+ssize_t kernfs_iop_listxattr(struct dentry *dentry, char *buf, size_t size);
+void kernfs_inode_init(void);
 
 /*
  * dir.c
@@ -98,21 +98,21 @@ extern const struct dentry_operations kernfs_dops;
 extern const struct file_operations kernfs_dir_fops;
 extern const struct inode_operations kernfs_dir_iops;
 
-struct kernfs_node *sysfs_get_active(struct kernfs_node *kn);
-void sysfs_put_active(struct kernfs_node *kn);
-void sysfs_addrm_start(struct kernfs_addrm_cxt *acxt);
-int sysfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
-		  struct kernfs_node *parent);
-void sysfs_addrm_finish(struct kernfs_addrm_cxt *acxt);
-struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
-				     const char *name, umode_t mode, int type);
+struct kernfs_node *kernfs_get_active(struct kernfs_node *kn);
+void kernfs_put_active(struct kernfs_node *kn);
+void kernfs_addrm_start(struct kernfs_addrm_cxt *acxt);
+int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
+		   struct kernfs_node *parent);
+void kernfs_addrm_finish(struct kernfs_addrm_cxt *acxt);
+struct kernfs_node *kernfs_new_node(struct kernfs_root *root, const char *name,
+				    umode_t mode, int type);
 
 /*
  * file.c
  */
 extern const struct file_operations kernfs_file_fops;
 
-void sysfs_unmap_bin_file(struct kernfs_node *kn);
+void kernfs_unmap_bin_file(struct kernfs_node *kn);
 
 /*
  * symlink.c
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 27d967b..0d6ce89 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -22,10 +22,10 @@ struct kmem_cache *kernfs_node_cache;
 static const struct super_operations kernfs_sops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
-	.evict_inode	= sysfs_evict_inode,
+	.evict_inode	= kernfs_evict_inode,
 };
 
-static int sysfs_fill_super(struct super_block *sb)
+static int kernfs_fill_super(struct super_block *sb)
 {
 	struct kernfs_super_info *info = kernfs_info(sb);
 	struct inode *inode;
@@ -39,10 +39,10 @@ static int sysfs_fill_super(struct super_block *sb)
 
 	/* get root inode, initialize and unlock it */
 	mutex_lock(&kernfs_mutex);
-	inode = sysfs_get_inode(sb, info->root->kn);
+	inode = kernfs_get_inode(sb, info->root->kn);
 	mutex_unlock(&kernfs_mutex);
 	if (!inode) {
-		pr_debug("sysfs: could not get root inode\n");
+		pr_debug("kernfs: could not get root inode\n");
 		return -ENOMEM;
 	}
 
@@ -59,7 +59,7 @@ static int sysfs_fill_super(struct super_block *sb)
 	return 0;
 }
 
-static int sysfs_test_super(struct super_block *sb, void *data)
+static int kernfs_test_super(struct super_block *sb, void *data)
 {
 	struct kernfs_super_info *sb_info = kernfs_info(sb);
 	struct kernfs_super_info *info = data;
@@ -67,7 +67,7 @@ static int sysfs_test_super(struct super_block *sb, void *data)
 	return sb_info->root == info->root && sb_info->ns == info->ns;
 }
 
-static int sysfs_set_super(struct super_block *sb, void *data)
+static int kernfs_set_super(struct super_block *sb, void *data)
 {
 	int error;
 	error = set_anon_super(sb, data);
@@ -117,13 +117,13 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 	info->root = root;
 	info->ns = ns;
 
-	sb = sget(fs_type, sysfs_test_super, sysfs_set_super, flags, info);
+	sb = sget(fs_type, kernfs_test_super, kernfs_set_super, flags, info);
 	if (IS_ERR(sb) || sb->s_fs_info != info)
 		kfree(info);
 	if (IS_ERR(sb))
 		return ERR_CAST(sb);
 	if (!sb->s_root) {
-		error = sysfs_fill_super(sb);
+		error = kernfs_fill_super(sb);
 		if (error) {
 			deactivate_locked_super(sb);
 			return ERR_PTR(error);
@@ -161,5 +161,5 @@ void __init kernfs_init(void)
 	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
 					      sizeof(struct kernfs_node),
 					      0, SLAB_PANIC, NULL);
-	sysfs_inode_init();
+	kernfs_inode_init();
 }
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index 4105bd0..a03e260 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -30,8 +30,8 @@ struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 	struct kernfs_addrm_cxt acxt;
 	int error;
 
-	kn = sysfs_new_dirent(kernfs_root(parent), name, S_IFLNK|S_IRWXUGO,
-			      KERNFS_LINK);
+	kn = kernfs_new_node(kernfs_root(parent), name, S_IFLNK|S_IRWXUGO,
+			     KERNFS_LINK);
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
@@ -40,9 +40,9 @@ struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 	kn->symlink.target_kn = target;
 	kernfs_get(target);	/* ref owned by symlink */
 
-	sysfs_addrm_start(&acxt);
-	error = sysfs_add_one(&acxt, kn, parent);
-	sysfs_addrm_finish(&acxt);
+	kernfs_addrm_start(&acxt);
+	error = kernfs_add_one(&acxt, kn, parent);
+	kernfs_addrm_finish(&acxt);
 
 	if (!error)
 		return kn;
@@ -51,8 +51,8 @@ struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 	return ERR_PTR(error);
 }
 
-static int sysfs_get_target_path(struct kernfs_node *parent,
-				 struct kernfs_node *target, char *path)
+static int kernfs_get_target_path(struct kernfs_node *parent,
+				  struct kernfs_node *target, char *path)
 {
 	struct kernfs_node *base, *kn;
 	char *s = path;
@@ -103,7 +103,7 @@ static int sysfs_get_target_path(struct kernfs_node *parent,
 	return 0;
 }
 
-static int sysfs_getlink(struct dentry *dentry, char *path)
+static int kernfs_getlink(struct dentry *dentry, char *path)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
 	struct kernfs_node *parent = kn->parent;
@@ -111,18 +111,18 @@ static int sysfs_getlink(struct dentry *dentry, char *path)
 	int error;
 
 	mutex_lock(&kernfs_mutex);
-	error = sysfs_get_target_path(parent, target, path);
+	error = kernfs_get_target_path(parent, target, path);
 	mutex_unlock(&kernfs_mutex);
 
 	return error;
 }
 
-static void *sysfs_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *kernfs_iop_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	int error = -ENOMEM;
 	unsigned long page = get_zeroed_page(GFP_KERNEL);
 	if (page) {
-		error = sysfs_getlink(dentry, (char *) page);
+		error = kernfs_getlink(dentry, (char *) page);
 		if (error < 0)
 			free_page((unsigned long)page);
 	}
@@ -130,8 +130,8 @@ static void *sysfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 	return NULL;
 }
 
-static void sysfs_put_link(struct dentry *dentry, struct nameidata *nd,
-			   void *cookie)
+static void kernfs_iop_put_link(struct dentry *dentry, struct nameidata *nd,
+				void *cookie)
 {
 	char *page = nd_get_link(nd);
 	if (!IS_ERR(page))
@@ -139,14 +139,14 @@ static void sysfs_put_link(struct dentry *dentry, struct nameidata *nd,
 }
 
 const struct inode_operations kernfs_symlink_iops = {
-	.setxattr	= sysfs_setxattr,
-	.removexattr	= sysfs_removexattr,
-	.getxattr	= sysfs_getxattr,
-	.listxattr	= sysfs_listxattr,
+	.setxattr	= kernfs_iop_setxattr,
+	.removexattr	= kernfs_iop_removexattr,
+	.getxattr	= kernfs_iop_getxattr,
+	.listxattr	= kernfs_iop_listxattr,
 	.readlink	= generic_readlink,
-	.follow_link	= sysfs_follow_link,
-	.put_link	= sysfs_put_link,
-	.setattr	= sysfs_setattr,
-	.getattr	= sysfs_getattr,
-	.permission	= sysfs_permission,
+	.follow_link	= kernfs_iop_follow_link,
+	.put_link	= kernfs_iop_put_link,
+	.setattr	= kernfs_iop_setattr,
+	.getattr	= kernfs_iop_getattr,
+	.permission	= kernfs_iop_permission,
 };
-- 
1.8.4.2

