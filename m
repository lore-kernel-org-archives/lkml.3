Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbaAJN6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:58:06 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:60490 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaAJN5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:57:46 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/14] kernfs: invoke kernfs_unmap_bin_file() directly from __kernfs_remove()
Date: Fri, 10 Jan 2014 08:57:23 -0500
Message-Id: <1389362251-8128-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389362251-8128-1-git-send-email-tj@kernel.org>
References: <1389362251-8128-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_unmap_bin_file() is supposed to unmap all memory mappings of
the target file before kernfs_remove() finishes; however, it currently
is being called from kernfs_addrm_finish() and has the same race
problem as the original implementation of deactivation when there are
multiple removers - only the remover which snatches the node to its
addrm_cxt->removed list is guaranteed to wait for its completion
before returning.

It can be fixed by moving kernfs_unmap_bin_file() invocation from
kernfs_addrm_finish() to __kernfs_remove().  The function may be
called multiple times but that shouldn't do any harm.

We end up dropping kernfs_mutex in the removal loop and the node may
be removed inbetween by someone else.  kernfs_unlink_sibling() is
updated to test whether the node has already been removed and return
accordingly.  __kernfs_remove() in turn performs post-unlinking
cleanup only if it actually unlinked the node.

KERNFS_HAS_MMAP test is moved out of the unmap function into
__kernfs_remove() so that we don't unlock kernfs_mutex unnecessarily.
While at it, drop the now meaningless "bin" qualifier from the
function name.

v2: Rewritten to fit the v2 restructuring of removal path.  HAS_MMAP
    test relocated.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             | 42 +++++++++++++++++++++++++++++++++---------
 fs/kernfs/file.c            |  5 +----
 fs/kernfs/kernfs-internal.h |  2 +-
 3 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index e565ec0..f878e4f 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -121,13 +121,17 @@ static int kernfs_link_sibling(struct kernfs_node *kn)
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
 	RB_CLEAR_NODE(&kn->rb);
+	return true;
 }
 
 /**
@@ -496,7 +500,6 @@ void kernfs_addrm_finish(struct kernfs_addrm_cxt *acxt)
 
 		acxt->removed = kn->u.removed_list;
 
-		kernfs_unmap_bin_file(kn);
 		kernfs_put(kn);
 	}
 }
@@ -854,23 +857,44 @@ static void __kernfs_remove(struct kernfs_addrm_cxt *acxt,
 
 	/* unlink the subtree node-by-node */
 	do {
-		struct kernfs_iattrs *ps_iattr;
-
 		pos = kernfs_leftmost_descendant(kn);
 
-		if (pos->parent) {
-			kernfs_unlink_sibling(pos);
+		/*
+		 * We're gonna release kernfs_mutex to unmap bin files,
+		 * Make sure @pos doesn't go away inbetween.
+		 */
+		kernfs_get(pos);
+
+		/*
+		 * This must be come before unlinking; otherwise, when
+		 * there are multiple removers, some may finish before
+		 * unmapping is complete.
+		 */
+		if (pos->flags & KERNFS_HAS_MMAP) {
+			mutex_unlock(&kernfs_mutex);
+			kernfs_unmap_file(pos);
+			mutex_lock(&kernfs_mutex);
+		}
+
+		/*
+		 * kernfs_unlink_sibling() succeeds once per node.  Use it
+		 * to decide who's responsible for cleanups.
+		 */
+		if (!pos->parent || kernfs_unlink_sibling(pos)) {
+			struct kernfs_iattrs *ps_iattr =
+				pos->parent ? pos->parent->iattr : NULL;
 
 			/* update timestamps on the parent */
-			ps_iattr = pos->parent->iattr;
 			if (ps_iattr) {
 				ps_iattr->ia_iattr.ia_ctime = CURRENT_TIME;
 				ps_iattr->ia_iattr.ia_mtime = CURRENT_TIME;
 			}
+
+			pos->u.removed_list = acxt->removed;
+			acxt->removed = pos;
 		}
 
-		pos->u.removed_list = acxt->removed;
-		acxt->removed = pos;
+		kernfs_put(pos);
 	} while (pos != kn);
 }
 
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 231a171..404ffd2 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -700,14 +700,11 @@ static int kernfs_fop_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-void kernfs_unmap_bin_file(struct kernfs_node *kn)
+void kernfs_unmap_file(struct kernfs_node *kn)
 {
 	struct kernfs_open_node *on;
 	struct kernfs_open_file *of;
 
-	if (!(kn->flags & KERNFS_HAS_MMAP))
-		return;
-
 	spin_lock_irq(&kernfs_open_node_lock);
 	on = kn->attr.open;
 	if (on)
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 57a93f4..e9ec38c 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -113,7 +113,7 @@ struct kernfs_node *kernfs_new_node(struct kernfs_root *root, const char *name,
  */
 extern const struct file_operations kernfs_file_fops;
 
-void kernfs_unmap_bin_file(struct kernfs_node *kn);
+void kernfs_unmap_file(struct kernfs_node *kn);
 
 /*
  * symlink.c
-- 
1.8.4.2

