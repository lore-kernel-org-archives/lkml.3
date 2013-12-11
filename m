Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3LKVDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:03:50 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:54344 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3LKVDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:03:16 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, kay@vrfy.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] kernfs: add kernfs_dir_ops
Date: Wed, 11 Dec 2013 16:03:00 -0500
Message-Id: <1386795780-23324-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386795780-23324-1-git-send-email-tj@kernel.org>
References: <1386795780-23324-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for mkdir(2), rmdir(2) and rename(2) syscalls.  This is
implemented through optional kernfs_dir_ops callback table which can
be specified on kernfs_create_root().  An implemented callback is
invoked when the matching syscall is invoked.

As kernfs keep dcache syncs with internal representation and
revalidates dentries on each access, the implementation of these
methods is extremely simple.  Each just discovers the relevant
kernfs_node(s) and invokes the requested callback which is allowed to
do any kernfs operations and the end result doesn't necessarily have
to match the expected semantics of the syscall.

This will be used to convert cgroup to use kernfs instead of its own
filesystem implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c        | 44 +++++++++++++++++++++++++++++++++++++++++++-
 fs/sysfs/mount.c       |  2 +-
 include/linux/kernfs.h | 21 +++++++++++++++++++--
 3 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 42c5b9f..510b506 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -583,12 +583,13 @@ EXPORT_SYMBOL_GPL(kernfs_find_and_get_ns);
 
 /**
  * kernfs_create_root - create a new kernfs hierarchy
+ * @kdops: optional directory syscall operations for the hierarchy
  * @priv: opaque data associated with the new directory
  *
  * Returns the root of the new hierarchy on success, ERR_PTR() value on
  * failure.
  */
-struct kernfs_root *kernfs_create_root(void *priv)
+struct kernfs_root *kernfs_create_root(struct kernfs_dir_ops *kdops, void *priv)
 {
 	struct kernfs_root *root;
 	struct kernfs_node *kn;
@@ -610,6 +611,7 @@ struct kernfs_root *kernfs_create_root(void *priv)
 	kn->priv = priv;
 	kn->dir.root = root;
 
+	root->dir_ops = kdops;
 	root->kn = kn;
 
 	return root;
@@ -706,6 +708,42 @@ static struct dentry *kernfs_iop_lookup(struct inode *dir,
 	return ret;
 }
 
+static int kernfs_iop_mkdir(struct inode *dir, struct dentry *dentry,
+			    umode_t mode)
+{
+	struct kernfs_node *parent = dir->i_private;
+	struct kernfs_dir_ops *kdops = kernfs_root(parent)->dir_ops;
+
+	if (!kdops || !kdops->mkdir)
+		return -EPERM;
+
+	return kdops->mkdir(parent, dentry->d_name.name, mode);
+}
+
+static int kernfs_iop_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct kernfs_node *kn  = dentry->d_fsdata;
+	struct kernfs_dir_ops *kdops = kernfs_root(kn)->dir_ops;
+
+	if (!kdops || !kdops->rmdir)
+		return -EPERM;
+
+	return kdops->rmdir(kn);
+}
+
+static int kernfs_iop_rename(struct inode *old_dir, struct dentry *old_dentry,
+			     struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct kernfs_node *kn  = old_dentry->d_fsdata;
+	struct kernfs_node *new_parent = new_dir->i_private;
+	struct kernfs_dir_ops *kdops = kernfs_root(kn)->dir_ops;
+
+	if (!kdops || !kdops->rename)
+		return -EPERM;
+
+	return kdops->rename(kn, new_parent, new_dentry->d_name.name);
+}
+
 const struct inode_operations kernfs_dir_iops = {
 	.lookup		= kernfs_iop_lookup,
 	.permission	= kernfs_iop_permission,
@@ -715,6 +753,10 @@ const struct inode_operations kernfs_dir_iops = {
 	.removexattr	= kernfs_iop_removexattr,
 	.getxattr	= kernfs_iop_getxattr,
 	.listxattr	= kernfs_iop_listxattr,
+
+	.mkdir		= kernfs_iop_mkdir,
+	.rmdir		= kernfs_iop_rmdir,
+	.rename		= kernfs_iop_rename,
 };
 
 static struct kernfs_node *kernfs_leftmost_descendant(struct kernfs_node *pos)
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 701a56f..6211230 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -62,7 +62,7 @@ int __init sysfs_init(void)
 {
 	int err;
 
-	sysfs_root = kernfs_create_root(NULL);
+	sysfs_root = kernfs_create_root(NULL, NULL);
 	if (IS_ERR(sysfs_root))
 		return PTR_ERR(sysfs_root);
 
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 321ed84..d2c439d 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -111,12 +111,27 @@ struct kernfs_node {
 	struct kernfs_iattrs	*iattr;
 };
 
+/*
+ * kernfs_dir_ops may be specified on kernfs_create_root() to support
+ * directory manipulation syscalls.  These optional callbacks are invoked
+ * on the matching syscalls and can perform any kernfs operations which
+ * don't necessarily have to be the exact operation requested.
+ */
+struct kernfs_dir_ops {
+	int (*mkdir)(struct kernfs_node *parent, const char *name,
+		     umode_t mode);
+	int (*rmdir)(struct kernfs_node *kn);
+	int (*rename)(struct kernfs_node *kn, struct kernfs_node *new_parent,
+		      const char *new_name);
+};
+
 struct kernfs_root {
 	/* published fields */
 	struct kernfs_node	*kn;
 
 	/* private fields, do not use outside kernfs proper */
 	struct ida		ino_ida;
+	struct kernfs_dir_ops	*dir_ops;
 };
 
 struct kernfs_open_file {
@@ -206,7 +221,8 @@ struct kernfs_node *kernfs_find_and_get_ns(struct kernfs_node *parent,
 void kernfs_get(struct kernfs_node *kn);
 void kernfs_put(struct kernfs_node *kn);
 
-struct kernfs_root *kernfs_create_root(void *priv);
+struct kernfs_root *kernfs_create_root(struct kernfs_dir_ops *kdops,
+				       void *priv);
 void kernfs_destroy_root(struct kernfs_root *root);
 
 struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
@@ -255,7 +271,8 @@ kernfs_find_and_get_ns(struct kernfs_node *parent, const char *name,
 static inline void kernfs_get(struct kernfs_node *kn) { }
 static inline void kernfs_put(struct kernfs_node *kn) { }
 
-static inline struct kernfs_root *kernfs_create_root(void *priv)
+static inline struct kernfs_root *
+kernfs_create_root(struct kernfs_dir_ops *kdops, void *priv)
 { return ERR_PTR(-ENOSYS); }
 
 static inline void kernfs_destroy_root(struct kernfs_root *root) { }
-- 
1.8.4.2

