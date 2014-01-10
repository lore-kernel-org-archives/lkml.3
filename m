Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbaAJNuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:50:05 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:57243 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaAJNrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:47:19 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/14] kernfs: invoke kernfs_unmap_bin_file() directly from __kernfs_remove()
Date: Fri, 10 Jan 2014 08:46:52 -0500
Message-Id: <1389361620-5086-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389361620-5086-1-git-send-email-tj@kernel.org>
References: <1389361620-5086-1-git-send-email-tj@kernel.org>
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

v2: Updated to fit the v2 restructuring of removal path.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index e565ec0..bb4662f 100644
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
@@ -854,23 +857,37 @@ static void __kernfs_remove(struct kernfs_addrm_cxt *acxt,
 
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
+		mutex_unlock(&kernfs_mutex);
+		kernfs_unmap_bin_file(pos);
+		mutex_lock(&kernfs_mutex);
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
 
-- 
1.8.4.2

