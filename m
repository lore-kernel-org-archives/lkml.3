Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbaA1Xfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:35:44 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:39038 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbaA1XdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:33:01 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/9] kernfs: rename kernfs_dir_ops to kernfs_syscall_ops
Date: Tue, 28 Jan 2014 18:32:44 -0500
Message-Id: <1390951971-15671-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951971-15671-1-git-send-email-tj@kernel.org>
References: <1390951971-15671-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're gonna need non-dir syscall callbacks, which will make dir_ops a
misnomer.  Let's rename kernfs_dir_ops to kernfs_syscall_ops.

This is pure rename.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c        | 25 +++++++++++++------------
 include/linux/kernfs.h | 18 +++++++++---------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index bfbfb48..f58d2f1 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -527,13 +527,14 @@ EXPORT_SYMBOL_GPL(kernfs_find_and_get_ns);
 
 /**
  * kernfs_create_root - create a new kernfs hierarchy
- * @kdops: optional directory syscall operations for the hierarchy
+ * @scops: optional syscall operations for the hierarchy
  * @priv: opaque data associated with the new directory
  *
  * Returns the root of the new hierarchy on success, ERR_PTR() value on
  * failure.
  */
-struct kernfs_root *kernfs_create_root(struct kernfs_dir_ops *kdops, void *priv)
+struct kernfs_root *kernfs_create_root(struct kernfs_syscall_ops *scops,
+				       void *priv)
 {
 	struct kernfs_root *root;
 	struct kernfs_node *kn;
@@ -556,7 +557,7 @@ struct kernfs_root *kernfs_create_root(struct kernfs_dir_ops *kdops, void *priv)
 	kn->priv = priv;
 	kn->dir.root = root;
 
-	root->dir_ops = kdops;
+	root->syscall_ops = scops;
 	root->kn = kn;
 	init_waitqueue_head(&root->deactivate_waitq);
 
@@ -653,16 +654,16 @@ static int kernfs_iop_mkdir(struct inode *dir, struct dentry *dentry,
 			    umode_t mode)
 {
 	struct kernfs_node *parent = dir->i_private;
-	struct kernfs_dir_ops *kdops = kernfs_root(parent)->dir_ops;
+	struct kernfs_syscall_ops *scops = kernfs_root(parent)->syscall_ops;
 	int ret;
 
-	if (!kdops || !kdops->mkdir)
+	if (!scops || !scops->mkdir)
 		return -EPERM;
 
 	if (!kernfs_get_active(parent))
 		return -ENODEV;
 
-	ret = kdops->mkdir(parent, dentry->d_name.name, mode);
+	ret = scops->mkdir(parent, dentry->d_name.name, mode);
 
 	kernfs_put_active(parent);
 	return ret;
@@ -671,16 +672,16 @@ static int kernfs_iop_mkdir(struct inode *dir, struct dentry *dentry,
 static int kernfs_iop_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct kernfs_node *kn  = dentry->d_fsdata;
-	struct kernfs_dir_ops *kdops = kernfs_root(kn)->dir_ops;
+	struct kernfs_syscall_ops *scops = kernfs_root(kn)->syscall_ops;
 	int ret;
 
-	if (!kdops || !kdops->rmdir)
+	if (!scops || !scops->rmdir)
 		return -EPERM;
 
 	if (!kernfs_get_active(kn))
 		return -ENODEV;
 
-	ret = kdops->rmdir(kn);
+	ret = scops->rmdir(kn);
 
 	kernfs_put_active(kn);
 	return ret;
@@ -691,10 +692,10 @@ static int kernfs_iop_rename(struct inode *old_dir, struct dentry *old_dentry,
 {
 	struct kernfs_node *kn  = old_dentry->d_fsdata;
 	struct kernfs_node *new_parent = new_dir->i_private;
-	struct kernfs_dir_ops *kdops = kernfs_root(kn)->dir_ops;
+	struct kernfs_syscall_ops *scops = kernfs_root(kn)->syscall_ops;
 	int ret;
 
-	if (!kdops || !kdops->rename)
+	if (!scops || !scops->rename)
 		return -EPERM;
 
 	if (!kernfs_get_active(kn))
@@ -705,7 +706,7 @@ static int kernfs_iop_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return -ENODEV;
 	}
 
-	ret = kdops->rename(kn, new_parent, new_dentry->d_name.name);
+	ret = scops->rename(kn, new_parent, new_dentry->d_name.name);
 
 	kernfs_put_active(new_parent);
 	kernfs_put_active(kn);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 58a131d..5ddc474 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -108,13 +108,13 @@ struct kernfs_node {
 };
 
 /*
- * kernfs_dir_ops may be specified on kernfs_create_root() to support
- * directory manipulation syscalls.  These optional callbacks are invoked
- * on the matching syscalls and can perform any kernfs operations which
- * don't necessarily have to be the exact operation requested.  An active
- * reference is held for each kernfs_node parameter.
+ * kernfs_syscall_ops may be specified on kernfs_create_root() to support
+ * syscalls.  These optional callbacks are invoked on the matching syscalls
+ * and can perform any kernfs operations which don't necessarily have to be
+ * the exact operation requested.  An active reference is held for each
+ * kernfs_node parameter.
  */
-struct kernfs_dir_ops {
+struct kernfs_syscall_ops {
 	int (*mkdir)(struct kernfs_node *parent, const char *name,
 		     umode_t mode);
 	int (*rmdir)(struct kernfs_node *kn);
@@ -128,7 +128,7 @@ struct kernfs_root {
 
 	/* private fields, do not use outside kernfs proper */
 	struct ida		ino_ida;
-	struct kernfs_dir_ops	*dir_ops;
+	struct kernfs_syscall_ops *syscall_ops;
 	wait_queue_head_t	deactivate_waitq;
 };
 
@@ -219,7 +219,7 @@ struct kernfs_node *kernfs_find_and_get_ns(struct kernfs_node *parent,
 void kernfs_get(struct kernfs_node *kn);
 void kernfs_put(struct kernfs_node *kn);
 
-struct kernfs_root *kernfs_create_root(struct kernfs_dir_ops *kdops,
+struct kernfs_root *kernfs_create_root(struct kernfs_syscall_ops *scops,
 				       void *priv);
 void kernfs_destroy_root(struct kernfs_root *root);
 
@@ -273,7 +273,7 @@ static inline void kernfs_get(struct kernfs_node *kn) { }
 static inline void kernfs_put(struct kernfs_node *kn) { }
 
 static inline struct kernfs_root *
-kernfs_create_root(struct kernfs_dir_ops *kdops, void *priv)
+kernfs_create_root(struct kernfs_syscall_ops *scops, void *priv)
 { return ERR_PTR(-ENOSYS); }
 
 static inline void kernfs_destroy_root(struct kernfs_root *root) { }
-- 
1.8.5.3

