Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaAJNrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:47:19 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:41495 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaAJNrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:47:14 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/14] kernfs: remove KERNFS_REMOVED
Date: Fri, 10 Jan 2014 08:46:50 -0500
Message-Id: <1389361620-5086-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389361620-5086-1-git-send-email-tj@kernel.org>
References: <1389361620-5086-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KERNFS_REMOVED is used to mark half-initialized and dying nodes so
that they don't show up in lookups and deny adding new nodes under or
renaming it; however, its role overlaps those of deactivation and
removal from rbtree.

It's necessary to deny addition of new children while removal is in
progress; however, this role considerably intersects with deactivation
- KERNFS_REMOVED prevents new children while deactivation prevents new
file operations.  There's no reason to have them separate making
things more complex than necessary.

KERNFS_REMOVED is also used to decide whether a node is still visible
to vfs layer, which is rather redundant as equivalent determination
can be made by testing whether the node is on its parent's children
rbtree or not.

This patch removes KERNFS_REMOVED.

* Instead of KERNFS_REMOVED, each node now starts its life
  deactivated.  This means that we now use both atomic_add() and
  atomic_sub() on KN_DEACTIVATED_BIAS, which is INT_MIN.  The compiler
  generates an overflow warnings when negating INT_MIN as the negation
  can't be represented as a positive number.  Nothing is actually
  broken but let's bump BIAS by one to avoid the warnings for archs
  which negates the subtrahend..

* KERNFS_REMOVED tests in add and rename paths are replaced with
  kernfs_get/put_active() of the target nodes.  Due to the way the add
  path is structured now, active ref handling is done in the callers
  of kernfs_add_one().  This will be consolidated up later.

* kernfs_remove_one() is updated to deactivate instead of setting
  KERNFS_REMOVED.  This removes deactivation from kernfs_deactivate(),
  which is now renamed to kernfs_drain().

* kernfs_dop_revalidate() now tests RB_EMPTY_NODE(&kn->rb) instead of
  KERNFS_REMOVED and KERNFS_REMOVED test in kernfs_dir_pos() is
  dropped.  A node which is removed from the children rbtree is not
  included in the iteration in the first place.  This means that a
  node may be visible through vfs a bit longer - it's now also visible
  after deactivation until the actual removal.  This slightly enlarged
  window difference doesn't make any difference to the userland.

* Sanity check on KERNFS_REMOVED in kernfs_put() is replaced with
  checks on the active ref.

* Some comment style updates in the affected area.

v2: Reordered before removal path restructuring.  kernfs_active()
    dropped and kernfs_get/put_active() used instead.  RB_EMPTY_NODE()
    used in the lookup paths.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             | 79 +++++++++++++++++++++++++--------------------
 fs/kernfs/file.c            | 10 ++++--
 fs/kernfs/kernfs-internal.h |  3 +-
 fs/kernfs/symlink.c         | 10 ++++--
 include/linux/kernfs.h      |  1 -
 5 files changed, 60 insertions(+), 43 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 1c9130a..7f8afc1 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -127,6 +127,7 @@ static void kernfs_unlink_sibling(struct kernfs_node *kn)
 		kn->parent->dir.subdirs--;
 
 	rb_erase(&kn->rb, &kn->parent->dir.children);
+	RB_CLEAR_NODE(&kn->rb);
 }
 
 /**
@@ -177,18 +178,16 @@ void kernfs_put_active(struct kernfs_node *kn)
 }
 
 /**
- *	kernfs_deactivate - deactivate kernfs_node
- *	@kn: kernfs_node to deactivate
+ * kernfs_drain - drain kernfs_node
+ * @kn: kernfs_node to drain
  *
- *	Deny new active references and drain existing ones.
+ * Drain existing usages.
  */
-static void kernfs_deactivate(struct kernfs_node *kn)
+static void kernfs_drain(struct kernfs_node *kn)
 {
 	struct kernfs_root *root = kernfs_root(kn);
 
-	BUG_ON(!(kn->flags & KERNFS_REMOVED));
-
-	atomic_add(KN_DEACTIVATED_BIAS, &kn->active);
+	WARN_ON_ONCE(atomic_read(&kn->active) >= 0);
 
 	if (kernfs_lockdep(kn)) {
 		rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
@@ -233,13 +232,15 @@ void kernfs_put(struct kernfs_node *kn)
 		return;
 	root = kernfs_root(kn);
  repeat:
-	/* Moving/renaming is always done while holding reference.
+	/*
+	 * Moving/renaming is always done while holding reference.
 	 * kn->parent won't change beneath us.
 	 */
 	parent = kn->parent;
 
-	WARN(!(kn->flags & KERNFS_REMOVED), "kernfs: free using entry: %s/%s\n",
-	     parent ? parent->name : "", kn->name);
+	WARN_ONCE(atomic_read(&kn->active) != KN_DEACTIVATED_BIAS,
+		  "kernfs_put: %s/%s: released with incorrect active_ref %d\n",
+		  parent ? parent->name : "", kn->name, atomic_read(&kn->active));
 
 	if (kernfs_type(kn) == KERNFS_LINK)
 		kernfs_put(kn->symlink.target_kn);
@@ -281,8 +282,8 @@ static int kernfs_dop_revalidate(struct dentry *dentry, unsigned int flags)
 	kn = dentry->d_fsdata;
 	mutex_lock(&kernfs_mutex);
 
-	/* The kernfs node has been deleted */
-	if (kn->flags & KERNFS_REMOVED)
+	/* Force fresh lookup if removed */
+	if (kn->parent && RB_EMPTY_NODE(&kn->rb))
 		goto out_bad;
 
 	/* The kernfs node has been moved? */
@@ -350,11 +351,12 @@ struct kernfs_node *kernfs_new_node(struct kernfs_root *root, const char *name,
 	kn->ino = ret;
 
 	atomic_set(&kn->count, 1);
-	atomic_set(&kn->active, 0);
+	atomic_set(&kn->active, KN_DEACTIVATED_BIAS);
+	RB_CLEAR_NODE(&kn->rb);
 
 	kn->name = name;
 	kn->mode = mode;
-	kn->flags = flags | KERNFS_REMOVED;
+	kn->flags = flags;
 
 	return kn;
 
@@ -413,6 +415,8 @@ int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 	struct kernfs_iattrs *ps_iattr;
 	int ret;
 
+	WARN_ON_ONCE(atomic_read(&parent->active) < 0);
+
 	if (has_ns != (bool)kn->ns) {
 		WARN(1, KERN_WARNING "kernfs: ns %s in '%s' for '%s'\n",
 		     has_ns ? "required" : "invalid", parent->name, kn->name);
@@ -422,9 +426,6 @@ int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 	if (kernfs_type(parent) != KERNFS_DIR)
 		return -EINVAL;
 
-	if (parent->flags & KERNFS_REMOVED)
-		return -ENOENT;
-
 	kn->hash = kernfs_name_hash(kn->name, kn->ns);
 	kn->parent = parent;
 	kernfs_get(parent);
@@ -441,8 +442,7 @@ int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 	}
 
 	/* Mark the entry added into directory tree */
-	kn->flags &= ~KERNFS_REMOVED;
-
+	atomic_sub(KN_DEACTIVATED_BIAS, &kn->active);
 	return 0;
 }
 
@@ -470,7 +470,7 @@ static void kernfs_remove_one(struct kernfs_addrm_cxt *acxt,
 	 * Removal can be called multiple times on the same node.  Only the
 	 * first invocation is effective and puts the base ref.
 	 */
-	if (kn->flags & KERNFS_REMOVED)
+	if (atomic_read(&kn->active) < 0)
 		return;
 
 	if (kn->parent) {
@@ -484,7 +484,7 @@ static void kernfs_remove_one(struct kernfs_addrm_cxt *acxt,
 		}
 	}
 
-	kn->flags |= KERNFS_REMOVED;
+	atomic_add(KN_DEACTIVATED_BIAS, &kn->active);
 	kn->u.removed_list = acxt->removed;
 	acxt->removed = kn;
 }
@@ -512,7 +512,7 @@ void kernfs_addrm_finish(struct kernfs_addrm_cxt *acxt)
 
 		acxt->removed = kn->u.removed_list;
 
-		kernfs_deactivate(kn);
+		kernfs_drain(kn);
 		kernfs_unmap_bin_file(kn);
 		kernfs_put(kn);
 	}
@@ -610,7 +610,7 @@ struct kernfs_root *kernfs_create_root(struct kernfs_dir_ops *kdops, void *priv)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	kn->flags &= ~KERNFS_REMOVED;
+	atomic_sub(KN_DEACTIVATED_BIAS, &kn->active);
 	kn->priv = priv;
 	kn->dir.root = root;
 
@@ -662,9 +662,13 @@ struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
 	kn->priv = priv;
 
 	/* link in */
-	kernfs_addrm_start(&acxt);
-	rc = kernfs_add_one(&acxt, kn, parent);
-	kernfs_addrm_finish(&acxt);
+	rc = -ENOENT;
+	if (kernfs_get_active(parent)) {
+		kernfs_addrm_start(&acxt);
+		rc = kernfs_add_one(&acxt, kn, parent);
+		kernfs_addrm_finish(&acxt);
+		kernfs_put_active(parent);
+	}
 
 	if (!rc)
 		return kn;
@@ -899,27 +903,29 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 {
 	int error;
 
-	mutex_lock(&kernfs_mutex);
-
 	error = -ENOENT;
-	if ((kn->flags | new_parent->flags) & KERNFS_REMOVED)
+	if (!kernfs_get_active(new_parent))
 		goto out;
+	if (!kernfs_get_active(kn))
+		goto out_put_new_parent;
+
+	mutex_lock(&kernfs_mutex);
 
 	error = 0;
 	if ((kn->parent == new_parent) && (kn->ns == new_ns) &&
 	    (strcmp(kn->name, new_name) == 0))
-		goto out;	/* nothing to rename */
+		goto out_unlock;	/* nothing to rename */
 
 	error = -EEXIST;
 	if (kernfs_find_ns(new_parent, new_name, new_ns))
-		goto out;
+		goto out_unlock;
 
 	/* rename kernfs_node */
 	if (strcmp(kn->name, new_name) != 0) {
 		error = -ENOMEM;
 		new_name = kstrdup(new_name, GFP_KERNEL);
 		if (!new_name)
-			goto out;
+			goto out_unlock;
 
 		if (kn->flags & KERNFS_STATIC_NAME)
 			kn->flags &= ~KERNFS_STATIC_NAME;
@@ -941,8 +947,12 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	kernfs_link_sibling(kn);
 
 	error = 0;
- out:
+out_unlock:
 	mutex_unlock(&kernfs_mutex);
+	kernfs_put_active(kn);
+out_put_new_parent:
+	kernfs_put_active(new_parent);
+out:
 	return error;
 }
 
@@ -962,8 +972,7 @@ static struct kernfs_node *kernfs_dir_pos(const void *ns,
 	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos)
 {
 	if (pos) {
-		int valid = !(pos->flags & KERNFS_REMOVED) &&
-			pos->parent == parent && hash == pos->hash;
+		int valid = pos->parent == parent && hash == pos->hash;
 		kernfs_put(pos);
 		if (!valid)
 			pos = NULL;
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index bdd3885..231a171 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -856,9 +856,13 @@ struct kernfs_node *__kernfs_create_file(struct kernfs_node *parent,
 	if (ops->mmap)
 		kn->flags |= KERNFS_HAS_MMAP;
 
-	kernfs_addrm_start(&acxt);
-	rc = kernfs_add_one(&acxt, kn, parent);
-	kernfs_addrm_finish(&acxt);
+	rc = -ENOENT;
+	if (kernfs_get_active(parent)) {
+		kernfs_addrm_start(&acxt);
+		rc = kernfs_add_one(&acxt, kn, parent);
+		kernfs_addrm_finish(&acxt);
+		kernfs_put_active(parent);
+	}
 
 	if (rc) {
 		kernfs_put(kn);
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index c6ba5bc..57a93f4 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -26,7 +26,8 @@ struct kernfs_iattrs {
 	struct simple_xattrs	xattrs;
 };
 
-#define KN_DEACTIVATED_BIAS		INT_MIN
+/* +1 to avoid triggering overflow warning when negating it */
+#define KN_DEACTIVATED_BIAS		(INT_MIN + 1)
 
 /* KERNFS_TYPE_MASK and types are defined in include/linux/kernfs.h */
 
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index a03e260..b2c106c 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -40,9 +40,13 @@ struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 	kn->symlink.target_kn = target;
 	kernfs_get(target);	/* ref owned by symlink */
 
-	kernfs_addrm_start(&acxt);
-	error = kernfs_add_one(&acxt, kn, parent);
-	kernfs_addrm_finish(&acxt);
+	error = -ENOENT;
+	if (kernfs_get_active(parent)) {
+		kernfs_addrm_start(&acxt);
+		error = kernfs_add_one(&acxt, kn, parent);
+		kernfs_addrm_finish(&acxt);
+		kernfs_put_active(parent);
+	}
 
 	if (!error)
 		return kn;
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 42ad32f..289d4f6 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -37,7 +37,6 @@ enum kernfs_node_type {
 #define KERNFS_FLAG_MASK	~KERNFS_TYPE_MASK
 
 enum kernfs_node_flag {
-	KERNFS_REMOVED		= 0x0010,
 	KERNFS_NS		= 0x0020,
 	KERNFS_HAS_SEQ_SHOW	= 0x0040,
 	KERNFS_HAS_MMAP		= 0x0080,
-- 
1.8.4.2

