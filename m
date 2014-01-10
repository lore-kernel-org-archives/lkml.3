Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaAJNrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:47:21 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:54264 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaAJNrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:47:16 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/14] kernfs: restructure removal path to fix possible premature return
Date: Fri, 10 Jan 2014 08:46:51 -0500
Message-Id: <1389361620-5086-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389361620-5086-1-git-send-email-tj@kernel.org>
References: <1389361620-5086-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recursive nature of kernfs_remove() means that, even if
kernfs_remove() is not allowed to be called multiple times on the same
node, there may be race conditions between removal of parent and its
descendants.  While we can claim that kernfs_remove() shouldn't be
called on one of the descendants while the removal of an ancestor is
in progress, such rule is unnecessarily restrictive and very difficult
to enforce.  It's better to simply allow invoking kernfs_remove() as
the caller sees fit as long as the caller ensures that the node is
accessible.

The current behavior in such situations is broken.  Whoever enters
removal path first takes the node off the hierarchy and then
deactivates.  Following removers either return as soon as it notices
that it's not the first one or can't even find the target node as it
has already been removed from the hierarchy.  In both cases, the
following removers may finish prematurely while the nodes which should
be removed and drained are still being processed by the first one.

This patch restructures so that multiple removers, whether through
recursion or direction invocation, always follow the following rules.

* When there are multiple concurrent removers, only one puts the base
  ref.

* Regardless of which one puts the base ref, all removers are blocked
  until the target node is fully deactivated and removed.

To achieve the above, removal path now first deactivates the subtree,
drains it and then unlinks one-by-one.  __kernfs_deactivate() is
called directly from __kernfs_removal() and drops and regrabs
kernfs_mutex for each descendant to drain active refs.  As this means
that multiple removers can enter __kernfs_deactivate() for the same
node, the function is updated so that it can handle multiple
deactivators of the same node - only one actually deactivates but all
wait till drain completion.

The restructured removal path guarantees that a removed node gets
unlinked only after the node is deactivated and drained.  Combined
with proper multiple deactivator handling, this guarantees that any
invocation of kernfs_remove() returns only after the node itself and
all its descendants are deactivated, drained and removed.

v2: Draining separated into a separate loop (used to be in the same
    loop as unlink) and done from __kernfs_deactivate().  This is to
    allow exposing deactivation as a separate interface later.

    Root node removal was broken in v1 patch.  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c        | 139 ++++++++++++++++++++++++++++++-------------------
 include/linux/kernfs.h |   1 +
 2 files changed, 87 insertions(+), 53 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 7f8afc1..e565ec0 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -181,14 +181,38 @@ void kernfs_put_active(struct kernfs_node *kn)
  * kernfs_drain - drain kernfs_node
  * @kn: kernfs_node to drain
  *
- * Drain existing usages.
+ * Drain existing usages of @kn.  Mutiple removers may invoke this function
+ * concurrently on @kn and all will return after draining is complete.
+ * Returns %true if drain is performed and kernfs_mutex was temporarily
+ * released.  %false if @kn was already drained and no operation was
+ * necessary.
+ *
+ * The caller is responsible for ensuring @kn stays pinned while this
+ * function is in progress even if it gets removed by someone else.
  */
-static void kernfs_drain(struct kernfs_node *kn)
+static bool kernfs_drain(struct kernfs_node *kn)
+	__releases(&kernfs_mutex) __acquires(&kernfs_mutex)
 {
 	struct kernfs_root *root = kernfs_root(kn);
 
+	lockdep_assert_held(&kernfs_mutex);
 	WARN_ON_ONCE(atomic_read(&kn->active) >= 0);
 
+	/*
+	 * We want to go through the active ref lockdep annotation at least
+	 * once for all node removals, but the lockdep annotation can't be
+	 * nested inside kernfs_mutex and deactivation can't make forward
+	 * progress if we keep dropping the mutex.  Use JUST_ACTIVATED to
+	 * force the slow path once for each deactivation if lockdep is
+	 * enabled.
+	 */
+	if ((!kernfs_lockdep(kn) || !(kn->flags & KERNFS_JUST_DEACTIVATED)) &&
+	    atomic_read(&kn->active) == KN_DEACTIVATED_BIAS)
+		return false;
+
+	kn->flags &= ~KERNFS_JUST_DEACTIVATED;
+	mutex_unlock(&kernfs_mutex);
+
 	if (kernfs_lockdep(kn)) {
 		rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
 		if (atomic_read(&kn->active) != KN_DEACTIVATED_BIAS)
@@ -202,6 +226,9 @@ static void kernfs_drain(struct kernfs_node *kn)
 		lock_acquired(&kn->dep_map, _RET_IP_);
 		rwsem_release(&kn->dep_map, 1, _RET_IP_);
 	}
+
+	mutex_lock(&kernfs_mutex);
+	return true;
 }
 
 /**
@@ -447,49 +474,6 @@ int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 }
 
 /**
- *	kernfs_remove_one - remove kernfs_node from parent
- *	@acxt: addrm context to use
- *	@kn: kernfs_node to be removed
- *
- *	Mark @kn removed and drop nlink of parent inode if @kn is a
- *	directory.  @kn is unlinked from the children list.
- *
- *	This function should be called between calls to
- *	kernfs_addrm_start() and kernfs_addrm_finish() and should be
- *	passed the same @acxt as passed to kernfs_addrm_start().
- *
- *	LOCKING:
- *	Determined by kernfs_addrm_start().
- */
-static void kernfs_remove_one(struct kernfs_addrm_cxt *acxt,
-			      struct kernfs_node *kn)
-{
-	struct kernfs_iattrs *ps_iattr;
-
-	/*
-	 * Removal can be called multiple times on the same node.  Only the
-	 * first invocation is effective and puts the base ref.
-	 */
-	if (atomic_read(&kn->active) < 0)
-		return;
-
-	if (kn->parent) {
-		kernfs_unlink_sibling(kn);
-
-		/* Update timestamps on the parent */
-		ps_iattr = kn->parent->iattr;
-		if (ps_iattr) {
-			ps_iattr->ia_iattr.ia_ctime = CURRENT_TIME;
-			ps_iattr->ia_iattr.ia_mtime = CURRENT_TIME;
-		}
-	}
-
-	atomic_add(KN_DEACTIVATED_BIAS, &kn->active);
-	kn->u.removed_list = acxt->removed;
-	acxt->removed = kn;
-}
-
-/**
  *	kernfs_addrm_finish - finish up kernfs_node add/remove
  *	@acxt: addrm context to finish up
  *
@@ -512,7 +496,6 @@ void kernfs_addrm_finish(struct kernfs_addrm_cxt *acxt)
 
 		acxt->removed = kn->u.removed_list;
 
-		kernfs_drain(kn);
 		kernfs_unmap_bin_file(kn);
 		kernfs_put(kn);
 	}
@@ -822,23 +805,73 @@ static struct kernfs_node *kernfs_next_descendant_post(struct kernfs_node *pos,
 	return pos->parent;
 }
 
+static void __kernfs_deactivate(struct kernfs_node *kn)
+{
+	struct kernfs_node *pos;
+
+	lockdep_assert_held(&kernfs_mutex);
+
+	/* prevent any new usage under @kn by deactivating all nodes */
+	pos = NULL;
+	while ((pos = kernfs_next_descendant_post(pos, kn))) {
+		if (atomic_read(&pos->active) >= 0) {
+			atomic_add(KN_DEACTIVATED_BIAS, &pos->active);
+			pos->flags |= KERNFS_JUST_DEACTIVATED;
+		}
+	}
+
+	/*
+	 * Drain the subtree.  If kernfs_drain() blocked to drain, which is
+	 * indicated by %true return, it temporarily released kernfs_mutex
+	 * and the rbtree might have been modified inbetween breaking our
+	 * future walk.  Restart the walk after each %true return.
+	 */
+	pos = NULL;
+	while ((pos = kernfs_next_descendant_post(pos, kn))) {
+		bool drained;
+
+		kernfs_get(pos);
+		drained = kernfs_drain(pos);
+		kernfs_put(pos);
+		if (drained)
+			pos = NULL;
+	}
+}
+
 static void __kernfs_remove(struct kernfs_addrm_cxt *acxt,
 			    struct kernfs_node *kn)
 {
-	struct kernfs_node *pos, *next;
+	struct kernfs_node *pos;
+
+	lockdep_assert_held(&kernfs_mutex);
 
 	if (!kn)
 		return;
 
 	pr_debug("kernfs %s: removing\n", kn->name);
 
-	next = NULL;
+	__kernfs_deactivate(kn);
+
+	/* unlink the subtree node-by-node */
 	do {
-		pos = next;
-		next = kernfs_next_descendant_post(pos, kn);
-		if (pos)
-			kernfs_remove_one(acxt, pos);
-	} while (next);
+		struct kernfs_iattrs *ps_iattr;
+
+		pos = kernfs_leftmost_descendant(kn);
+
+		if (pos->parent) {
+			kernfs_unlink_sibling(pos);
+
+			/* update timestamps on the parent */
+			ps_iattr = pos->parent->iattr;
+			if (ps_iattr) {
+				ps_iattr->ia_iattr.ia_ctime = CURRENT_TIME;
+				ps_iattr->ia_iattr.ia_mtime = CURRENT_TIME;
+			}
+		}
+
+		pos->u.removed_list = acxt->removed;
+		acxt->removed = pos;
+	} while (pos != kn);
 }
 
 /**
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 289d4f6..61bd7ae 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -37,6 +37,7 @@ enum kernfs_node_type {
 #define KERNFS_FLAG_MASK	~KERNFS_TYPE_MASK
 
 enum kernfs_node_flag {
+	KERNFS_JUST_DEACTIVATED	= 0x0010, /* used to aid lockdep annotation */
 	KERNFS_NS		= 0x0020,
 	KERNFS_HAS_SEQ_SHOW	= 0x0040,
 	KERNFS_HAS_MMAP		= 0x0080,
-- 
1.8.4.2

