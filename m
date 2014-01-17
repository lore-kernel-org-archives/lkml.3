Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaAQO6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:58:33 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:49054 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaAQO63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:58:29 -0500
Date: Fri, 17 Jan 2014 09:58:25 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH driver-core-next 2/2] kernfs: associate a new kernfs_node
 with its parent on creation
Message-ID: <20140117145825.GD8598@htj.dyndns.org>
References: <20140117145749.GC8598@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117145749.GC8598@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once created, a kernfs_node is always destroyed by kernfs_put().
Since ba7443bc656e ("sysfs, kernfs: implement
kernfs_create/destroy_root()"), kernfs_put() depends on kernfs_root()
to locate the ino_ida.  kernfs_root() in turn depends on
kernfs_node->parent being set for !dir nodes.  This means that
kernfs_put() of a !dir node requires its ->parent to be initialized.

This leads to oops when a newly created !dir node is destroyed without
going through kernfs_add_one() or after failing kernfs_add_one()
before ->parent is set.  kernfs_root() invoked from kernfs_put() will
try to dereference NULL parent.

Fix it by moving parent association to kernfs_new_node() from
kernfs_add_one().  kernfs_new_node() now takes @parent instead of
@root and determines the root from the parent and also sets the new
node's parent properly.  @parent parameter is removed from
kernfs_add_one().  As there's no parent when creating the root node,
__kernfs_new_node() which takes @root as before and doesn't set the
parent is used in that case.

This ensures that a kernfs_node in any stage in its life has its
parent associated and thus can be put.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             |   40 ++++++++++++++++++++++++++--------------
 fs/kernfs/file.c            |    5 ++---
 fs/kernfs/kernfs-internal.h |    8 ++++----
 fs/kernfs/symlink.c         |    5 ++---
 4 files changed, 34 insertions(+), 24 deletions(-)

--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -324,8 +324,9 @@ const struct dentry_operations kernfs_do
 	.d_release	= kernfs_dop_release,
 };
 
-struct kernfs_node *kernfs_new_node(struct kernfs_root *root, const char *name,
-				    umode_t mode, unsigned flags)
+static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
+					     const char *name, umode_t mode,
+					     unsigned flags)
 {
 	char *dup_name = NULL;
 	struct kernfs_node *kn;
@@ -362,6 +363,20 @@ struct kernfs_node *kernfs_new_node(stru
 	return NULL;
 }
 
+struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
+				    const char *name, umode_t mode,
+				    unsigned flags)
+{
+	struct kernfs_node *kn;
+
+	kn = __kernfs_new_node(kernfs_root(parent), name, mode, flags);
+	if (kn) {
+		kernfs_get(parent);
+		kn->parent = parent;
+	}
+	return kn;
+}
+
 /**
  *	kernfs_addrm_start - prepare for kernfs_node add/remove
  *	@acxt: pointer to kernfs_addrm_cxt to be used
@@ -386,11 +401,10 @@ void kernfs_addrm_start(struct kernfs_ad
  *	kernfs_add_one - add kernfs_node to parent without warning
  *	@acxt: addrm context to use
  *	@kn: kernfs_node to be added
- *	@parent: the parent kernfs_node to add @kn to
  *
- *	Get @parent and set @kn->parent to it and increment nlink of the
- *	parent inode if @kn is a directory and link into the children list
- *	of the parent.
+ *	The caller must already have initialized @kn->parent.  This
+ *	function increments nlink of the parent's inode if @kn is a
+ *	directory and link into the children list of the parent.
  *
  *	This function should be called between calls to
  *	kernfs_addrm_start() and kernfs_addrm_finish() and should be passed
@@ -403,9 +417,9 @@ void kernfs_addrm_start(struct kernfs_ad
  *	0 on success, -EEXIST if entry with the given name already
  *	exists.
  */
-int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
-		  struct kernfs_node *parent)
+int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn)
 {
+	struct kernfs_node *parent = kn->parent;
 	bool has_ns = kernfs_ns_enabled(parent);
 	struct kernfs_iattrs *ps_iattr;
 	int ret;
@@ -423,8 +437,6 @@ int kernfs_add_one(struct kernfs_addrm_c
 		return -ENOENT;
 
 	kn->hash = kernfs_name_hash(kn->name, kn->ns);
-	kn->parent = parent;
-	kernfs_get(parent);
 
 	ret = kernfs_link_sibling(kn);
 	if (ret)
@@ -600,7 +612,8 @@ struct kernfs_root *kernfs_create_root(s
 
 	ida_init(&root->ino_ida);
 
-	kn = kernfs_new_node(root, "", S_IFDIR | S_IRUGO | S_IXUGO, KERNFS_DIR);
+	kn = __kernfs_new_node(root, "", S_IFDIR | S_IRUGO | S_IXUGO,
+			       KERNFS_DIR);
 	if (!kn) {
 		ida_destroy(&root->ino_ida);
 		kfree(root);
@@ -648,8 +661,7 @@ struct kernfs_node *kernfs_create_dir_ns
 	int rc;
 
 	/* allocate */
-	kn = kernfs_new_node(kernfs_root(parent), name, mode | S_IFDIR,
-			     KERNFS_DIR);
+	kn = kernfs_new_node(parent, name, mode | S_IFDIR, KERNFS_DIR);
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
@@ -659,7 +671,7 @@ struct kernfs_node *kernfs_create_dir_ns
 
 	/* link in */
 	kernfs_addrm_start(&acxt);
-	rc = kernfs_add_one(&acxt, kn, parent);
+	rc = kernfs_add_one(&acxt, kn);
 	kernfs_addrm_finish(&acxt);
 
 	if (!rc)
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -829,8 +829,7 @@ struct kernfs_node *__kernfs_create_file
 	if (name_is_static)
 		flags |= KERNFS_STATIC_NAME;
 
-	kn = kernfs_new_node(kernfs_root(parent), name,
-			     (mode & S_IALLUGO) | S_IFREG, flags);
+	kn = kernfs_new_node(parent, name, (mode & S_IALLUGO) | S_IFREG, flags);
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
@@ -857,7 +856,7 @@ struct kernfs_node *__kernfs_create_file
 		kn->flags |= KERNFS_HAS_MMAP;
 
 	kernfs_addrm_start(&acxt);
-	rc = kernfs_add_one(&acxt, kn, parent);
+	rc = kernfs_add_one(&acxt, kn);
 	kernfs_addrm_finish(&acxt);
 
 	if (rc) {
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -101,11 +101,11 @@ extern const struct inode_operations ker
 struct kernfs_node *kernfs_get_active(struct kernfs_node *kn);
 void kernfs_put_active(struct kernfs_node *kn);
 void kernfs_addrm_start(struct kernfs_addrm_cxt *acxt);
-int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
-		   struct kernfs_node *parent);
+int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn);
 void kernfs_addrm_finish(struct kernfs_addrm_cxt *acxt);
-struct kernfs_node *kernfs_new_node(struct kernfs_root *root, const char *name,
-				    umode_t mode, unsigned flags);
+struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
+				    const char *name, umode_t mode,
+				    unsigned flags);
 
 /*
  * file.c
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -30,8 +30,7 @@ struct kernfs_node *kernfs_create_link(s
 	struct kernfs_addrm_cxt acxt;
 	int error;
 
-	kn = kernfs_new_node(kernfs_root(parent), name, S_IFLNK|S_IRWXUGO,
-			     KERNFS_LINK);
+	kn = kernfs_new_node(parent, name, S_IFLNK|S_IRWXUGO, KERNFS_LINK);
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
@@ -41,7 +40,7 @@ struct kernfs_node *kernfs_create_link(s
 	kernfs_get(target);	/* ref owned by symlink */
 
 	kernfs_addrm_start(&acxt);
-	error = kernfs_add_one(&acxt, kn, parent);
+	error = kernfs_add_one(&acxt, kn);
 	kernfs_addrm_finish(&acxt);
 
 	if (!error)
