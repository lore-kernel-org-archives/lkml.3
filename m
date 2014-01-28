Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbaA1XYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:24:38 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59170 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbaA1XWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:22:03 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/11] kernfs: remove kernfs_addrm_cxt
Date: Tue, 28 Jan 2014 18:21:44 -0500
Message-Id: <1390951311-15325-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951311-15325-1-git-send-email-tj@kernel.org>
References: <1390951311-15325-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_addrm_cxt and the accompanying kernfs_addrm_start/finish() were
added because there were operations which should be performed outside
kernfs_mutex after adding and removing kernfs_nodes.  The necessary
operations were recorded in kernfs_addrm_cxt and performed by
kernfs_addrm_finish(); however, after the recent changes which
relocated deactivation and unmapping so that they're performed
directly during removal, the only operation kernfs_addrm_finish()
performs is kernfs_put(), which can be moved inside the removal path
too.

This patch moves the kernfs_put() of the base ref to __kernfs_remove()
and remove kernfs_addrm_cxt and kernfs_addrm_start/finish().

* kernfs_add_one() is updated to grab and release kernfs_mutex itself.
  sysfs_addrm_start/finish() invocations around it are removed from
  all users.

* __kernfs_remove() puts an unlinked node directly instead of chaining
  it to kernfs_addrm_cxt.  Its callers are updated to grab and release
  kernfs_mutex instead of calling kernfs_addrm_start/finish() around
  it.

v2: Rebased on top of "kernfs: associate a new kernfs_node with its
    parent on creation" which dropped @parent from kernfs_add_one().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             | 109 ++++++++++----------------------------------
 fs/kernfs/file.c            |   6 +--
 fs/kernfs/kernfs-internal.h |  11 +----
 fs/kernfs/symlink.c         |   6 +--
 include/linux/kernfs.h      |   4 --
 5 files changed, 28 insertions(+), 108 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 1cb74bd..8459f61 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -392,69 +392,44 @@ struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
 }
 
 /**
- *	kernfs_addrm_start - prepare for kernfs_node add/remove
- *	@acxt: pointer to kernfs_addrm_cxt to be used
- *
- *	This function is called when the caller is about to add or remove
- *	kernfs_node.  This function acquires kernfs_mutex.  @acxt is used
- *	to keep and pass context to other addrm functions.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).  kernfs_mutex is locked on
- *	return.
- */
-void kernfs_addrm_start(struct kernfs_addrm_cxt *acxt)
-	__acquires(kernfs_mutex)
-{
-	memset(acxt, 0, sizeof(*acxt));
-
-	mutex_lock(&kernfs_mutex);
-}
-
-/**
  *	kernfs_add_one - add kernfs_node to parent without warning
- *	@acxt: addrm context to use
  *	@kn: kernfs_node to be added
  *
  *	The caller must already have initialized @kn->parent.  This
  *	function increments nlink of the parent's inode if @kn is a
  *	directory and link into the children list of the parent.
  *
- *	This function should be called between calls to
- *	kernfs_addrm_start() and kernfs_addrm_finish() and should be passed
- *	the same @acxt as passed to kernfs_addrm_start().
- *
- *	LOCKING:
- *	Determined by kernfs_addrm_start().
- *
  *	RETURNS:
  *	0 on success, -EEXIST if entry with the given name already
  *	exists.
  */
-int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn)
+int kernfs_add_one(struct kernfs_node *kn)
 {
 	struct kernfs_node *parent = kn->parent;
-	bool has_ns = kernfs_ns_enabled(parent);
 	struct kernfs_iattrs *ps_iattr;
+	bool has_ns;
 	int ret;
 
-	if (has_ns != (bool)kn->ns) {
-		WARN(1, KERN_WARNING "kernfs: ns %s in '%s' for '%s'\n",
-		     has_ns ? "required" : "invalid", parent->name, kn->name);
-		return -EINVAL;
-	}
+	mutex_lock(&kernfs_mutex);
+
+	ret = -EINVAL;
+	has_ns = kernfs_ns_enabled(parent);
+	if (WARN(has_ns != (bool)kn->ns, KERN_WARNING "kernfs: ns %s in '%s' for '%s'\n",
+		 has_ns ? "required" : "invalid", parent->name, kn->name))
+		goto out_unlock;
 
 	if (kernfs_type(parent) != KERNFS_DIR)
-		return -EINVAL;
+		goto out_unlock;
 
+	ret = -ENOENT;
 	if (parent->flags & KERNFS_REMOVED)
-		return -ENOENT;
+		goto out_unlock;
 
 	kn->hash = kernfs_name_hash(kn->name, kn->ns);
 
 	ret = kernfs_link_sibling(kn);
 	if (ret)
-		return ret;
+		goto out_unlock;
 
 	/* Update timestamps on the parent */
 	ps_iattr = parent->iattr;
@@ -465,35 +440,10 @@ int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn)
 
 	/* Mark the entry added into directory tree */
 	kn->flags &= ~KERNFS_REMOVED;
-
-	return 0;
-}
-
-/**
- *	kernfs_addrm_finish - finish up kernfs_node add/remove
- *	@acxt: addrm context to finish up
- *
- *	Finish up kernfs_node add/remove.  Resources acquired by
- *	kernfs_addrm_start() are released and removed kernfs_nodes are
- *	cleaned up.
- *
- *	LOCKING:
- *	kernfs_mutex is released.
- */
-void kernfs_addrm_finish(struct kernfs_addrm_cxt *acxt)
-	__releases(kernfs_mutex)
-{
-	/* release resources acquired by kernfs_addrm_start() */
+	ret = 0;
+out_unlock:
 	mutex_unlock(&kernfs_mutex);
-
-	/* kill removed kernfs_nodes */
-	while (acxt->removed) {
-		struct kernfs_node *kn = acxt->removed;
-
-		acxt->removed = kn->u.removed_list;
-
-		kernfs_put(kn);
-	}
+	return ret;
 }
 
 /**
@@ -626,7 +576,6 @@ struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
 					 const char *name, umode_t mode,
 					 void *priv, const void *ns)
 {
-	struct kernfs_addrm_cxt acxt;
 	struct kernfs_node *kn;
 	int rc;
 
@@ -640,10 +589,7 @@ struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
 	kn->priv = priv;
 
 	/* link in */
-	kernfs_addrm_start(&acxt);
-	rc = kernfs_add_one(&acxt, kn);
-	kernfs_addrm_finish(&acxt);
-
+	rc = kernfs_add_one(kn);
 	if (!rc)
 		return kn;
 
@@ -796,8 +742,7 @@ static struct kernfs_node *kernfs_next_descendant_post(struct kernfs_node *pos,
 	return pos->parent;
 }
 
-static void __kernfs_remove(struct kernfs_addrm_cxt *acxt,
-			    struct kernfs_node *kn)
+static void __kernfs_remove(struct kernfs_node *kn)
 {
 	struct kernfs_node *pos;
 
@@ -841,8 +786,7 @@ static void __kernfs_remove(struct kernfs_addrm_cxt *acxt,
 				ps_iattr->ia_iattr.ia_mtime = CURRENT_TIME;
 			}
 
-			pos->u.removed_list = acxt->removed;
-			acxt->removed = pos;
+			kernfs_put(pos);
 		}
 
 		kernfs_put(pos);
@@ -857,11 +801,9 @@ static void __kernfs_remove(struct kernfs_addrm_cxt *acxt,
  */
 void kernfs_remove(struct kernfs_node *kn)
 {
-	struct kernfs_addrm_cxt acxt;
-
-	kernfs_addrm_start(&acxt);
-	__kernfs_remove(&acxt, kn);
-	kernfs_addrm_finish(&acxt);
+	mutex_lock(&kernfs_mutex);
+	__kernfs_remove(kn);
+	mutex_unlock(&kernfs_mutex);
 }
 
 /**
@@ -876,7 +818,6 @@ void kernfs_remove(struct kernfs_node *kn)
 int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 			     const void *ns)
 {
-	struct kernfs_addrm_cxt acxt;
 	struct kernfs_node *kn;
 
 	if (!parent) {
@@ -885,13 +826,13 @@ int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 		return -ENOENT;
 	}
 
-	kernfs_addrm_start(&acxt);
+	mutex_lock(&kernfs_mutex);
 
 	kn = kernfs_find_ns(parent, name, ns);
 	if (kn)
-		__kernfs_remove(&acxt, kn);
+		__kernfs_remove(kn);
 
-	kernfs_addrm_finish(&acxt);
+	mutex_unlock(&kernfs_mutex);
 
 	if (kn)
 		return 0;
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index dbf397b..10a8c91 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -820,7 +820,6 @@ struct kernfs_node *__kernfs_create_file(struct kernfs_node *parent,
 					 bool name_is_static,
 					 struct lock_class_key *key)
 {
-	struct kernfs_addrm_cxt acxt;
 	struct kernfs_node *kn;
 	unsigned flags;
 	int rc;
@@ -855,10 +854,7 @@ struct kernfs_node *__kernfs_create_file(struct kernfs_node *parent,
 	if (ops->mmap)
 		kn->flags |= KERNFS_HAS_MMAP;
 
-	kernfs_addrm_start(&acxt);
-	rc = kernfs_add_one(&acxt, kn);
-	kernfs_addrm_finish(&acxt);
-
+	rc = kernfs_add_one(kn);
 	if (rc) {
 		kernfs_put(kn);
 		return ERR_PTR(rc);
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index eb536b7..46b58de 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -45,13 +45,6 @@ static inline struct kernfs_root *kernfs_root(struct kernfs_node *kn)
 }
 
 /*
- * Context structure to be used while adding/removing nodes.
- */
-struct kernfs_addrm_cxt {
-	struct kernfs_node	*removed;
-};
-
-/*
  * mount.c
  */
 struct kernfs_super_info {
@@ -100,9 +93,7 @@ extern const struct inode_operations kernfs_dir_iops;
 
 struct kernfs_node *kernfs_get_active(struct kernfs_node *kn);
 void kernfs_put_active(struct kernfs_node *kn);
-void kernfs_addrm_start(struct kernfs_addrm_cxt *acxt);
-int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn);
-void kernfs_addrm_finish(struct kernfs_addrm_cxt *acxt);
+int kernfs_add_one(struct kernfs_node *kn);
 struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
 				    const char *name, umode_t mode,
 				    unsigned flags);
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index 4d45705..8a19889 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -27,7 +27,6 @@ struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 				       struct kernfs_node *target)
 {
 	struct kernfs_node *kn;
-	struct kernfs_addrm_cxt acxt;
 	int error;
 
 	kn = kernfs_new_node(parent, name, S_IFLNK|S_IRWXUGO, KERNFS_LINK);
@@ -39,10 +38,7 @@ struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 	kn->symlink.target_kn = target;
 	kernfs_get(target);	/* ref owned by symlink */
 
-	kernfs_addrm_start(&acxt);
-	error = kernfs_add_one(&acxt, kn);
-	kernfs_addrm_finish(&acxt);
-
+	error = kernfs_add_one(kn);
 	if (!error)
 		return kn;
 
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 295a3bf..38646f6 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -91,10 +91,6 @@ struct kernfs_node {
 
 	struct rb_node		rb;
 
-	union {
-		struct kernfs_node	*removed_list;
-	} u;
-
 	const void		*ns;	/* namespace tag */
 	unsigned int		hash;	/* ns + name hash */
 	union {
-- 
1.8.5.3

