Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbaAJOBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:01:10 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:36909 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbaAJN5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:57:50 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/14] kernfs: implement kernfs_{de|re}activate[_self]()
Date: Fri, 10 Jan 2014 08:57:26 -0500
Message-Id: <1389362251-8128-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389362251-8128-1-git-send-email-tj@kernel.org>
References: <1389362251-8128-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements four functions to manipulate deactivation state
- deactivate, reactivate and the _self suffixed pair.  A new fields
kernfs_node->deact_depth is added so that concurrent and nested
deactivations are handled properly.  kernfs_node->hash is moved so
that it's paired with the new field so that it doesn't increase the
size of kernfs_node.

A kernfs user's lock would normally nest inside active ref but during
removal the user may want to perform kernfs_remove() while holding the
said lock, which would introduce a reverse locking dependency.  This
function can be used to break such reverse dependency by allowing
deactivation step to performed separately outside user's critical
section.

This will also be used implement kernfs_remove_self().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c        | 118 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/kernfs.h |   7 ++-
 2 files changed, 123 insertions(+), 2 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 37dd640..1aeb579 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -396,6 +396,7 @@ struct kernfs_node *kernfs_new_node(struct kernfs_root *root, const char *name,
 
 	atomic_set(&kn->count, 1);
 	atomic_set(&kn->active, KN_DEACTIVATED_BIAS);
+	kn->deact_depth = 1;
 	RB_CLEAR_NODE(&kn->rb);
 
 	kn->name = name;
@@ -461,6 +462,7 @@ int kernfs_add_one(struct kernfs_node *kn, struct kernfs_node *parent)
 
 	/* Mark the entry added into directory tree */
 	atomic_sub(KN_DEACTIVATED_BIAS, &kn->active);
+	kn->deact_depth--;
 	ret = 0;
 out_unlock:
 	mutex_unlock(&kernfs_mutex);
@@ -561,6 +563,7 @@ struct kernfs_root *kernfs_create_root(struct kernfs_dir_ops *kdops, void *priv)
 	}
 
 	atomic_sub(KN_DEACTIVATED_BIAS, &kn->active);
+	kn->deact_depth--;
 	kn->priv = priv;
 	kn->dir.root = root;
 
@@ -773,7 +776,8 @@ static void __kernfs_deactivate(struct kernfs_node *kn)
 	/* prevent any new usage under @kn by deactivating all nodes */
 	pos = NULL;
 	while ((pos = kernfs_next_descendant_post(pos, kn))) {
-		if (atomic_read(&pos->active) >= 0) {
+		if (!pos->deact_depth++) {
+			WARN_ON_ONCE(atomic_read(&pos->active) < 0);
 			atomic_add(KN_DEACTIVATED_BIAS, &pos->active);
 			pos->flags |= KERNFS_JUST_DEACTIVATED;
 		}
@@ -797,6 +801,118 @@ static void __kernfs_deactivate(struct kernfs_node *kn)
 	}
 }
 
+static void __kernfs_reactivate(struct kernfs_node *kn)
+{
+	struct kernfs_node *pos;
+
+	lockdep_assert_held(&kernfs_mutex);
+
+	pos = NULL;
+	while ((pos = kernfs_next_descendant_post(pos, kn))) {
+		if (!--pos->deact_depth) {
+			WARN_ON_ONCE(atomic_read(&pos->active) >= 0);
+			atomic_sub(KN_DEACTIVATED_BIAS, &pos->active);
+		}
+		WARN_ON_ONCE(pos->deact_depth < 0);
+	}
+
+	/* some nodes reactivated, kick get_active waiters */
+	wake_up_all(&kernfs_root(kn)->deactivate_waitq);
+}
+
+static void __kernfs_deactivate_self(struct kernfs_node *kn)
+{
+	/*
+	 * Take out ourself out of the active ref dependency chain and
+	 * deactivate.  If we're called without an active ref, lockdep will
+	 * complain.
+	 */
+	kernfs_put_active(kn);
+	__kernfs_deactivate(kn);
+}
+
+static void __kernfs_reactivate_self(struct kernfs_node *kn)
+{
+	__kernfs_reactivate(kn);
+	/*
+	 * Restore active ref dropped by deactivate_self() so that it's
+	 * balanced on return.  put_active() will soon be called on @kn, so
+	 * this can't break anything regardless of @kn's state.
+	 */
+	atomic_inc(&kn->active);
+	if (kernfs_lockdep(kn))
+		rwsem_acquire(&kn->dep_map, 0, 1, _RET_IP_);
+}
+
+/**
+ * kernfs_deactivate - deactivate subtree of a node
+ * @kn: kernfs_node to deactivate subtree of
+ *
+ * Deactivate the subtree of @kn.  On return, there's no active operation
+ * going on under @kn and creation or renaming of a node under @kn is
+ * blocked until @kn is reactivated or removed.  This function can be
+ * called multiple times and nests properly.  Each invocation should be
+ * paired with kernfs_reactivate().
+ *
+ * For a kernfs user which uses simple locking, the subsystem lock would
+ * nest inside active reference.  This becomes problematic if the user
+ * tries to remove nodes while holding the subystem lock as it would create
+ * a reverse locking dependency from the subsystem lock to active ref.
+ * This function can be used to break such reverse dependency.  The user
+ * can call this function outside the subsystem lock and then proceed to
+ * invoke kernfs_remove() while holding the subsystem lock without
+ * introducing such reverse dependency.
+ */
+void kernfs_deactivate(struct kernfs_node *kn)
+{
+	mutex_lock(&kernfs_mutex);
+	__kernfs_deactivate(kn);
+	mutex_unlock(&kernfs_mutex);
+}
+
+/**
+ * kernfs_reactivate - reactivate subtree of a node
+ * @kn: kernfs_node to reactivate subtree of
+ *
+ * Undo kernfs_deactivate().
+ */
+void kernfs_reactivate(struct kernfs_node *kn)
+{
+	mutex_lock(&kernfs_mutex);
+	__kernfs_reactivate(kn);
+	mutex_unlock(&kernfs_mutex);
+}
+
+/**
+ * kernfs_deactivate_self - deactivate subtree of a node from its own method
+ * @kn: the self kernfs_node to deactivate subtree of
+ *
+ * The caller must be running off of a kernfs operation which is invoked
+ * with an active reference - e.g. one of kernfs_ops.  Once this function
+ * is called, @kn may be removed by someone else while the enclosing method
+ * is in progress.  Other than that, this function is equivalent to
+ * kernfs_deactivate() and should be paired with kernfs_reactivate_self().
+ */
+void kernfs_deactivate_self(struct kernfs_node *kn)
+{
+	mutex_lock(&kernfs_mutex);
+	__kernfs_deactivate_self(kn);
+	mutex_unlock(&kernfs_mutex);
+}
+
+/**
+ * kernfs_reactivate_self - reactivate subtree of a node from its own method
+ * @kn: the self kernfs_node to reactivate subtree of
+ *
+ * Undo kernfs_deactivate_self().
+ */
+void kernfs_reactivate_self(struct kernfs_node *kn)
+{
+	mutex_lock(&kernfs_mutex);
+	__kernfs_reactivate_self(kn);
+	mutex_unlock(&kernfs_mutex);
+}
+
 static void __kernfs_remove(struct kernfs_node *kn)
 {
 	struct kernfs_root *root = kernfs_root(kn);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 9b5a4bb..ac86930 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -80,6 +80,8 @@ struct kernfs_elem_attr {
 struct kernfs_node {
 	atomic_t		count;
 	atomic_t		active;
+	int			deact_depth;
+	unsigned int		hash;	/* ns + name hash */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
@@ -90,7 +92,6 @@ struct kernfs_node {
 	struct rb_node		rb;
 
 	const void		*ns;	/* namespace tag */
-	unsigned int		hash;	/* ns + name hash */
 	union {
 		struct kernfs_elem_dir		dir;
 		struct kernfs_elem_symlink	symlink;
@@ -233,6 +234,10 @@ struct kernfs_node *__kernfs_create_file(struct kernfs_node *parent,
 struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 				       const char *name,
 				       struct kernfs_node *target);
+void kernfs_deactivate(struct kernfs_node *kn);
+void kernfs_reactivate(struct kernfs_node *kn);
+void kernfs_deactivate_self(struct kernfs_node *kn);
+void kernfs_reactivate_self(struct kernfs_node *kn);
 void kernfs_remove(struct kernfs_node *kn);
 int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 			     const void *ns);
-- 
1.8.4.2

