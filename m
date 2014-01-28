Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaA1XWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:22:08 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:53867 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaA1XV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:21:59 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/11] kernfs: restructure removal path to fix possible premature return
Date: Tue, 28 Jan 2014 18:21:42 -0500
Message-Id: <1390951311-15325-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951311-15325-1-git-send-email-tj@kernel.org>
References: <1390951311-15325-1-git-send-email-tj@kernel.org>
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

To achieve the above, removal path now first marks all descendants
including self REMOVED and then deactivates and unlinks leftmost
descendant one-by-one.  kernfs_deactivate() is called directly from
__kernfs_removal() and drops and regrabs kernfs_mutex for each
descendant to drain active refs.  As this means that multiple removers
can enter kernfs_deactivate() for the same node, the function is
updated so that it can handle multiple deactivators of the same node -
only one actually deactivates but all wait till drain completion.

The restructured removal path guarantees that a removed node gets
unlinked only after the node is deactivated and drained.  Combined
with proper multiple deactivator handling, this guarantees that any
invocation of kernfs_remove() returns only after the node itself and
all its descendants are deactivated, drained and removed.

v2: Draining separated into a separate loop (used to be in the same
    loop as unlink) and done from __kernfs_deactivate().  This is to
    allow exposing deactivation as a separate interface later.

    Root node removal was broken in v1 patch.  Fixed.

v3: Revert most of v2 except for root node removal fix and
    simplification of KERNFS_REMOVED setting loop.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c | 121 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 64 insertions(+), 57 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 9b00ebb..9d99e6a 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -106,18 +106,24 @@ static int kernfs_link_sibling(struct kernfs_node *kn)
  *	kernfs_unlink_sibling - unlink kernfs_node from sibling rbtree
  *	@kn: kernfs_node of interest
  *
- *	Unlink @kn from its sibling rbtree which starts from
- *	kn->parent->dir.children.
+ *	Try to unlink @kn from its sibling rbtree which starts from
+ *	kn->parent->dir.children.  Returns %true if @kn was actually
+ *	removed, %false if @kn wasn't on the rbtree.
  *
  *	Locking:
  *	mutex_lock(kernfs_mutex)
  */
-static void kernfs_unlink_sibling(struct kernfs_node *kn)
+static bool kernfs_unlink_sibling(struct kernfs_node *kn)
 {
+	if (RB_EMPTY_NODE(&kn->rb))
+		return false;
+
 	if (kernfs_type(kn) == KERNFS_DIR)
 		kn->parent->dir.subdirs--;
 
 	rb_erase(&kn->rb, &kn->parent->dir.children);
+	RB_CLEAR_NODE(&kn->rb);
+	return true;
 }
 
 /**
@@ -171,29 +177,39 @@ void kernfs_put_active(struct kernfs_node *kn)
  *	kernfs_deactivate - deactivate kernfs_node
  *	@kn: kernfs_node to deactivate
  *
- *	Deny new active references and drain existing ones.
+ *	Deny new active references and drain existing ones.  Mutiple
+ *	removers may invoke this function concurrently on @kn and all will
+ *	return after deactivation and draining are complete.
  */
 static void kernfs_deactivate(struct kernfs_node *kn)
+	__releases(&kernfs_mutex) __acquires(&kernfs_mutex)
 {
 	struct kernfs_root *root = kernfs_root(kn);
 
+	lockdep_assert_held(&kernfs_mutex);
 	BUG_ON(!(kn->flags & KERNFS_REMOVED));
 
 	if (!(kernfs_type(kn) & KERNFS_ACTIVE_REF))
 		return;
 
-	rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
+	/* only the first invocation on @kn should deactivate it */
+	if (atomic_read(&kn->active) >= 0)
+		atomic_add(KN_DEACTIVATED_BIAS, &kn->active);
 
-	atomic_add(KN_DEACTIVATED_BIAS, &kn->active);
+	mutex_unlock(&kernfs_mutex);
 
+	rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
 	if (atomic_read(&kn->active) != KN_DEACTIVATED_BIAS)
 		lock_contended(&kn->dep_map, _RET_IP_);
 
+	/* but everyone should wait for draining */
 	wait_event(root->deactivate_waitq,
 		   atomic_read(&kn->active) == KN_DEACTIVATED_BIAS);
 
 	lock_acquired(&kn->dep_map, _RET_IP_);
 	rwsem_release(&kn->dep_map, 1, _RET_IP_);
+
+	mutex_lock(&kernfs_mutex);
 }
 
 /**
@@ -343,6 +359,7 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 
 	atomic_set(&kn->count, 1);
 	atomic_set(&kn->active, 0);
+	RB_CLEAR_NODE(&kn->rb);
 
 	kn->name = name;
 	kn->mode = mode;
@@ -450,49 +467,6 @@ int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn)
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
-	if (kn->flags & KERNFS_REMOVED)
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
-	kn->flags |= KERNFS_REMOVED;
-	kn->u.removed_list = acxt->removed;
-	acxt->removed = kn;
-}
-
-/**
  *	kernfs_addrm_finish - finish up kernfs_node add/remove
  *	@acxt: addrm context to finish up
  *
@@ -515,7 +489,6 @@ void kernfs_addrm_finish(struct kernfs_addrm_cxt *acxt)
 
 		acxt->removed = kn->u.removed_list;
 
-		kernfs_deactivate(kn);
 		kernfs_unmap_bin_file(kn);
 		kernfs_put(kn);
 	}
@@ -824,20 +797,54 @@ static struct kernfs_node *kernfs_next_descendant_post(struct kernfs_node *pos,
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
+	/* disable lookup and node creation under @kn */
+	pos = NULL;
+	while ((pos = kernfs_next_descendant_post(pos, kn)))
+		pos->flags |= KERNFS_REMOVED;
+
+	/* deactivate and unlink the subtree node-by-node */
 	do {
-		pos = next;
-		next = kernfs_next_descendant_post(pos, kn);
-		if (pos)
-			kernfs_remove_one(acxt, pos);
-	} while (next);
+		pos = kernfs_leftmost_descendant(kn);
+
+		/*
+		 * kernfs_deactivate() drops kernfs_mutex temporarily and
+		 * @pos's base ref could have been put by someone else by
+		 * the time the function returns.  Make sure it doesn't go
+		 * away underneath us.
+		 */
+		kernfs_get(pos);
+
+		kernfs_deactivate(pos);
+
+		/*
+		 * kernfs_unlink_sibling() succeeds once per node.  Use it
+		 * to decide who's responsible for cleanups.
+		 */
+		if (!pos->parent || kernfs_unlink_sibling(pos)) {
+			struct kernfs_iattrs *ps_iattr =
+				pos->parent ? pos->parent->iattr : NULL;
+
+			/* update timestamps on the parent */
+			if (ps_iattr) {
+				ps_iattr->ia_iattr.ia_ctime = CURRENT_TIME;
+				ps_iattr->ia_iattr.ia_mtime = CURRENT_TIME;
+			}
+
+			pos->u.removed_list = acxt->removed;
+			acxt->removed = pos;
+		}
+
+		kernfs_put(pos);
+	} while (pos != kn);
 }
 
 /**
-- 
1.8.5.3

