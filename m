Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbaA1XYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:24:06 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:61898 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872AbaA1XWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:22:05 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/11] kernfs: remove KERNFS_REMOVED
Date: Tue, 28 Jan 2014 18:21:46 -0500
Message-Id: <1390951311-15325-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951311-15325-1-git-send-email-tj@kernel.org>
References: <1390951311-15325-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KERNFS_REMOVED is used to mark half-initialized and dying nodes so
that they don't show up in lookups and deny adding new nodes under or
renaming it; however, its role overlaps that of deactivation.

It's necessary to deny addition of new children while removal is in
progress; however, this role considerably intersects with deactivation
- KERNFS_REMOVED prevents new children while deactivation prevents new
file operations.  There's no reason to have them separate making
things more complex than necessary.

This patch removes KERNFS_REMOVED.

* Instead of KERNFS_REMOVED, each node now starts its life
  deactivated.  This means that we now use both atomic_add() and
  atomic_sub() on KN_DEACTIVATED_BIAS, which is INT_MIN.  The compiler
  generates an overflow warnings when negating INT_MIN as the negation
  can't be represented as a positive number.  Nothing is actually
  broken but let's bump BIAS by one to avoid the warnings for archs
  which negates the subtrahend..

* A new helper kernfs_active() which tests whether kn->active >= 0 is
  added for convenience and lockdep annotation.  All KERNFS_REMOVED
  tests are replaced with negated kernfs_active() tests.

* __kernfs_remove() is updated to deactivate, but not drain, all nodes
  in the subtree instead of setting KERNFS_REMOVED.  This removes
  deactivation from kernfs_deactivate(), which is now renamed to
  kernfs_drain().

* Sanity check on KERNFS_REMOVED in kernfs_put() is replaced with
  checks on the active ref.

* Some comment style updates in the affected area.

v2: Reordered before removal path restructuring.  kernfs_active()
    dropped and kernfs_get/put_active() used instead.  RB_EMPTY_NODE()
    used in the lookup paths.

v3: Reverted most of v2 except for creating a new node with
    KN_DEACTIVATED_BIAS.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             | 66 ++++++++++++++++++++++++---------------------
 fs/kernfs/kernfs-internal.h |  3 ++-
 include/linux/kernfs.h      |  1 -
 3 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 5cf137b..d0fd739 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -22,6 +22,12 @@ DEFINE_MUTEX(kernfs_mutex);
 
 #define rb_to_kn(X) rb_entry((X), struct kernfs_node, rb)
 
+static bool kernfs_active(struct kernfs_node *kn)
+{
+	lockdep_assert_held(&kernfs_mutex);
+	return atomic_read(&kn->active) >= 0;
+}
+
 static bool kernfs_lockdep(struct kernfs_node *kn)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -183,25 +189,20 @@ void kernfs_put_active(struct kernfs_node *kn)
 }
 
 /**
- *	kernfs_deactivate - deactivate kernfs_node
- *	@kn: kernfs_node to deactivate
+ * kernfs_drain - drain kernfs_node
+ * @kn: kernfs_node to drain
  *
- *	Deny new active references, drain existing ones and nuke all
- *	existing mmaps.  Mutiple removers may invoke this function
- *	concurrently on @kn and all will return after deactivation and
- *	draining are complete.
+ * Drain existing usages and nuke all existing mmaps of @kn.  Mutiple
+ * removers may invoke this function concurrently on @kn and all will
+ * return after draining is complete.
  */
-static void kernfs_deactivate(struct kernfs_node *kn)
+static void kernfs_drain(struct kernfs_node *kn)
 	__releases(&kernfs_mutex) __acquires(&kernfs_mutex)
 {
 	struct kernfs_root *root = kernfs_root(kn);
 
 	lockdep_assert_held(&kernfs_mutex);
-	BUG_ON(!(kn->flags & KERNFS_REMOVED));
-
-	/* only the first invocation on @kn should deactivate it */
-	if (atomic_read(&kn->active) >= 0)
-		atomic_add(KN_DEACTIVATED_BIAS, &kn->active);
+	WARN_ON_ONCE(kernfs_active(kn));
 
 	mutex_unlock(&kernfs_mutex);
 
@@ -253,13 +254,15 @@ void kernfs_put(struct kernfs_node *kn)
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
@@ -301,8 +304,8 @@ static int kernfs_dop_revalidate(struct dentry *dentry, unsigned int flags)
 	kn = dentry->d_fsdata;
 	mutex_lock(&kernfs_mutex);
 
-	/* The kernfs node has been deleted */
-	if (kn->flags & KERNFS_REMOVED)
+	/* The kernfs node has been deactivated */
+	if (!kernfs_active(kn))
 		goto out_bad;
 
 	/* The kernfs node has been moved? */
@@ -371,12 +374,12 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 	kn->ino = ret;
 
 	atomic_set(&kn->count, 1);
-	atomic_set(&kn->active, 0);
+	atomic_set(&kn->active, KN_DEACTIVATED_BIAS);
 	RB_CLEAR_NODE(&kn->rb);
 
 	kn->name = name;
 	kn->mode = mode;
-	kn->flags = flags | KERNFS_REMOVED;
+	kn->flags = flags;
 
 	return kn;
 
@@ -432,7 +435,7 @@ int kernfs_add_one(struct kernfs_node *kn)
 		goto out_unlock;
 
 	ret = -ENOENT;
-	if (parent->flags & KERNFS_REMOVED)
+	if (!kernfs_active(parent))
 		goto out_unlock;
 
 	kn->hash = kernfs_name_hash(kn->name, kn->ns);
@@ -449,7 +452,7 @@ int kernfs_add_one(struct kernfs_node *kn)
 	}
 
 	/* Mark the entry added into directory tree */
-	kn->flags &= ~KERNFS_REMOVED;
+	atomic_sub(KN_DEACTIVATED_BIAS, &kn->active);
 	ret = 0;
 out_unlock:
 	mutex_unlock(&kernfs_mutex);
@@ -549,7 +552,7 @@ struct kernfs_root *kernfs_create_root(struct kernfs_dir_ops *kdops, void *priv)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	kn->flags &= ~KERNFS_REMOVED;
+	atomic_sub(KN_DEACTIVATED_BIAS, &kn->active);
 	kn->priv = priv;
 	kn->dir.root = root;
 
@@ -763,24 +766,25 @@ static void __kernfs_remove(struct kernfs_node *kn)
 
 	pr_debug("kernfs %s: removing\n", kn->name);
 
-	/* disable lookup and node creation under @kn */
+	/* prevent any new usage under @kn by deactivating all nodes */
 	pos = NULL;
 	while ((pos = kernfs_next_descendant_post(pos, kn)))
-		pos->flags |= KERNFS_REMOVED;
+		if (kernfs_active(pos))
+			atomic_add(KN_DEACTIVATED_BIAS, &pos->active);
 
 	/* deactivate and unlink the subtree node-by-node */
 	do {
 		pos = kernfs_leftmost_descendant(kn);
 
 		/*
-		 * kernfs_deactivate() drops kernfs_mutex temporarily and
-		 * @pos's base ref could have been put by someone else by
-		 * the time the function returns.  Make sure it doesn't go
-		 * away underneath us.
+		 * kernfs_drain() drops kernfs_mutex temporarily and @pos's
+		 * base ref could have been put by someone else by the time
+		 * the function returns.  Make sure it doesn't go away
+		 * underneath us.
 		 */
 		kernfs_get(pos);
 
-		kernfs_deactivate(pos);
+		kernfs_drain(pos);
 
 		/*
 		 * kernfs_unlink_sibling() succeeds once per node.  Use it
@@ -865,7 +869,7 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	mutex_lock(&kernfs_mutex);
 
 	error = -ENOENT;
-	if ((kn->flags | new_parent->flags) & KERNFS_REMOVED)
+	if (!kernfs_active(kn) || !kernfs_active(new_parent))
 		goto out;
 
 	error = 0;
@@ -925,7 +929,7 @@ static struct kernfs_node *kernfs_dir_pos(const void *ns,
 	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos)
 {
 	if (pos) {
-		int valid = !(pos->flags & KERNFS_REMOVED) &&
+		int valid = kernfs_active(pos) &&
 			pos->parent == parent && hash == pos->hash;
 		kernfs_put(pos);
 		if (!valid)
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 46b58de..a91d7a1 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -26,7 +26,8 @@ struct kernfs_iattrs {
 	struct simple_xattrs	xattrs;
 };
 
-#define KN_DEACTIVATED_BIAS		INT_MIN
+/* +1 to avoid triggering overflow warning when negating it */
+#define KN_DEACTIVATED_BIAS		(INT_MIN + 1)
 
 /* KERNFS_TYPE_MASK and types are defined in include/linux/kernfs.h */
 
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index dc4cd6c..917bc6c 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -38,7 +38,6 @@ enum kernfs_node_type {
 #define KERNFS_FLAG_MASK	~KERNFS_TYPE_MASK
 
 enum kernfs_node_flag {
-	KERNFS_REMOVED		= 0x0010,
 	KERNFS_NS		= 0x0020,
 	KERNFS_HAS_SEQ_SHOW	= 0x0040,
 	KERNFS_HAS_MMAP		= 0x0080,
-- 
1.8.5.3

