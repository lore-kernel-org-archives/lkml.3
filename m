Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab3K1Tzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:55:54 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:62130 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab3K1Tzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:40 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 31/34] sysfs, kernfs: move mount core code to fs/kernfs/mount.c
Date: Thu, 28 Nov 2013 14:54:44 -0500
Message-Id: <1385668487-10181-32-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move core mount code to fs/kernfs/mount.c.  The respective
declarations in fs/sysfs/sysfs.h are moved to
fs/kernfs/kernfs-internal.h.

This is pure relocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/kernfs-internal.h |  22 +++++++
 fs/kernfs/mount.c           | 156 ++++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/mount.c            | 152 ------------------------------------------
 fs/sysfs/sysfs.h            |  18 -----
 4 files changed, 178 insertions(+), 170 deletions(-)

diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 0d94988..ced0d6d 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -134,6 +134,28 @@ struct sysfs_addrm_cxt {
 #include "../sysfs/sysfs.h"
 
 /*
+ * mount.c
+ */
+struct sysfs_super_info {
+	/*
+	 * The root associated with this super_block.  Each super_block is
+	 * identified by the root and ns it's associated with.
+	 */
+	struct kernfs_root	*root;
+
+	/*
+	 * Each sb is associated with one namespace tag, currently the network
+	 * namespace of the task which mounted this sysfs instance.  If multiple
+	 * tags become necessary, make the following an array and compare
+	 * sysfs_dirent tag against every entry.
+	 */
+	const void		*ns;
+};
+#define sysfs_info(SB) ((struct sysfs_super_info *)(SB->s_fs_info))
+
+extern struct kmem_cache *sysfs_dir_cachep;
+
+/*
  * inode.c
  */
 struct inode *sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd);
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 872e262..84c83e2 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -7,3 +7,159 @@
  *
  * This file is released under the GPLv2.
  */
+
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/init.h>
+#include <linux/magic.h>
+#include <linux/slab.h>
+#include <linux/pagemap.h>
+
+#include "kernfs-internal.h"
+
+struct kmem_cache *sysfs_dir_cachep;
+
+static const struct super_operations sysfs_ops = {
+	.statfs		= simple_statfs,
+	.drop_inode	= generic_delete_inode,
+	.evict_inode	= sysfs_evict_inode,
+};
+
+static int sysfs_fill_super(struct super_block *sb)
+{
+	struct sysfs_super_info *info = sysfs_info(sb);
+	struct inode *inode;
+	struct dentry *root;
+
+	sb->s_blocksize = PAGE_CACHE_SIZE;
+	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
+	sb->s_magic = SYSFS_MAGIC;
+	sb->s_op = &sysfs_ops;
+	sb->s_time_gran = 1;
+
+	/* get root inode, initialize and unlock it */
+	mutex_lock(&sysfs_mutex);
+	inode = sysfs_get_inode(sb, info->root->sd);
+	mutex_unlock(&sysfs_mutex);
+	if (!inode) {
+		pr_debug("sysfs: could not get root inode\n");
+		return -ENOMEM;
+	}
+
+	/* instantiate and link root dentry */
+	root = d_make_root(inode);
+	if (!root) {
+		pr_debug("%s: could not get root dentry!\n", __func__);
+		return -ENOMEM;
+	}
+	kernfs_get(info->root->sd);
+	root->d_fsdata = info->root->sd;
+	sb->s_root = root;
+	sb->s_d_op = &sysfs_dentry_ops;
+	return 0;
+}
+
+static int sysfs_test_super(struct super_block *sb, void *data)
+{
+	struct sysfs_super_info *sb_info = sysfs_info(sb);
+	struct sysfs_super_info *info = data;
+
+	return sb_info->root == info->root && sb_info->ns == info->ns;
+}
+
+static int sysfs_set_super(struct super_block *sb, void *data)
+{
+	int error;
+	error = set_anon_super(sb, data);
+	if (!error)
+		sb->s_fs_info = data;
+	return error;
+}
+
+/**
+ * kernfs_super_ns - determine the namespace tag of a kernfs super_block
+ * @sb: super_block of interest
+ *
+ * Return the namespace tag associated with kernfs super_block @sb.
+ */
+const void *kernfs_super_ns(struct super_block *sb)
+{
+	struct sysfs_super_info *info = sysfs_info(sb);
+
+	return info->ns;
+}
+
+/**
+ * kernfs_mount_ns - kernfs mount helper
+ * @fs_type: file_system_type of the fs being mounted
+ * @flags: mount flags specified for the mount
+ * @root: kernfs_root of the hierarchy being mounted
+ * @ns: optional namespace tag of the mount
+ *
+ * This is to be called from each kernfs user's file_system_type->mount()
+ * implementation, which should pass through the specified @fs_type and
+ * @flags, and specify the hierarchy and namespace tag to mount via @root
+ * and @ns, respectively.
+ *
+ * The return value can be passed to the vfs layer verbatim.
+ */
+struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
+			       struct kernfs_root *root, const void *ns)
+{
+	struct super_block *sb;
+	struct sysfs_super_info *info;
+	int error;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	info->root = root;
+	info->ns = ns;
+
+	sb = sget(fs_type, sysfs_test_super, sysfs_set_super, flags, info);
+	if (IS_ERR(sb) || sb->s_fs_info != info)
+		kfree(info);
+	if (IS_ERR(sb))
+		return ERR_CAST(sb);
+	if (!sb->s_root) {
+		error = sysfs_fill_super(sb);
+		if (error) {
+			deactivate_locked_super(sb);
+			return ERR_PTR(error);
+		}
+		sb->s_flags |= MS_ACTIVE;
+	}
+
+	return dget(sb->s_root);
+}
+
+/**
+ * kernfs_kill_sb - kill_sb for kernfs
+ * @sb: super_block being killed
+ *
+ * This can be used directly for file_system_type->kill_sb().  If a kernfs
+ * user needs extra cleanup, it can implement its own kill_sb() and call
+ * this function at the end.
+ */
+void kernfs_kill_sb(struct super_block *sb)
+{
+	struct sysfs_super_info *info = sysfs_info(sb);
+	struct sysfs_dirent *root_sd = sb->s_root->d_fsdata;
+
+	/*
+	 * Remove the superblock from fs_supers/s_instances
+	 * so we can't find it, before freeing sysfs_super_info.
+	 */
+	kill_anon_super(sb);
+	kfree(info);
+	kernfs_put(root_sd);
+}
+
+void __init kernfs_init(void)
+{
+	sysfs_dir_cachep = kmem_cache_create("sysfs_dir_cache",
+					      sizeof(struct sysfs_dirent),
+					      0, SLAB_PANIC, NULL);
+	sysfs_inode_init();
+}
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 5384732..e7e3aa8 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -14,91 +14,14 @@
 
 #include <linux/fs.h>
 #include <linux/mount.h>
-#include <linux/pagemap.h>
 #include <linux/init.h>
-#include <linux/module.h>
-#include <linux/magic.h>
-#include <linux/slab.h>
 #include <linux/user_namespace.h>
 
 #include "sysfs.h"
 
-
-struct kmem_cache *sysfs_dir_cachep;
-
-static const struct super_operations sysfs_ops = {
-	.statfs		= simple_statfs,
-	.drop_inode	= generic_delete_inode,
-	.evict_inode	= sysfs_evict_inode,
-};
-
 static struct kernfs_root *sysfs_root;
 struct sysfs_dirent *sysfs_root_sd;
 
-static int sysfs_fill_super(struct super_block *sb)
-{
-	struct sysfs_super_info *info = sysfs_info(sb);
-	struct inode *inode;
-	struct dentry *root;
-
-	sb->s_blocksize = PAGE_CACHE_SIZE;
-	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
-	sb->s_magic = SYSFS_MAGIC;
-	sb->s_op = &sysfs_ops;
-	sb->s_time_gran = 1;
-
-	/* get root inode, initialize and unlock it */
-	mutex_lock(&sysfs_mutex);
-	inode = sysfs_get_inode(sb, info->root->sd);
-	mutex_unlock(&sysfs_mutex);
-	if (!inode) {
-		pr_debug("sysfs: could not get root inode\n");
-		return -ENOMEM;
-	}
-
-	/* instantiate and link root dentry */
-	root = d_make_root(inode);
-	if (!root) {
-		pr_debug("%s: could not get root dentry!\n", __func__);
-		return -ENOMEM;
-	}
-	kernfs_get(info->root->sd);
-	root->d_fsdata = info->root->sd;
-	sb->s_root = root;
-	sb->s_d_op = &sysfs_dentry_ops;
-	return 0;
-}
-
-static int sysfs_test_super(struct super_block *sb, void *data)
-{
-	struct sysfs_super_info *sb_info = sysfs_info(sb);
-	struct sysfs_super_info *info = data;
-
-	return sb_info->root == info->root && sb_info->ns == info->ns;
-}
-
-static int sysfs_set_super(struct super_block *sb, void *data)
-{
-	int error;
-	error = set_anon_super(sb, data);
-	if (!error)
-		sb->s_fs_info = data;
-	return error;
-}
-
-/**
- * kernfs_super_ns - determine the namespace tag of a kernfs super_block
- * @sb: super_block of interest
- *
- * Return the namespace tag associated with kernfs super_block @sb.
- */
-const void *kernfs_super_ns(struct super_block *sb)
-{
-	struct sysfs_super_info *info = sysfs_info(sb);
-
-	return info->ns;
-}
-
 static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
@@ -120,79 +43,12 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	return root;
 }
 
-/**
- * kernfs_mount_ns - kernfs mount helper
- * @fs_type: file_system_type of the fs being mounted
- * @flags: mount flags specified for the mount
- * @root: kernfs_root of the hierarchy being mounted
- * @ns: optional namespace tag of the mount
- *
- * This is to be called from each kernfs user's file_system_type->mount()
- * implementation, which should pass through the specified @fs_type and
- * @flags, and specify the hierarchy and namespace tag to mount via @root
- * and @ns, respectively.
- *
- * The return value can be passed to the vfs layer verbatim.
- */
-struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
-			       struct kernfs_root *root, const void *ns)
-{
-	struct super_block *sb;
-	struct sysfs_super_info *info;
-	int error;
-
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info)
-		return ERR_PTR(-ENOMEM);
-
-	info->root = root;
-	info->ns = ns;
-
-	sb = sget(fs_type, sysfs_test_super, sysfs_set_super, flags, info);
-	if (IS_ERR(sb) || sb->s_fs_info != info)
-		kfree(info);
-	if (IS_ERR(sb))
-		return ERR_CAST(sb);
-	if (!sb->s_root) {
-		error = sysfs_fill_super(sb);
-		if (error) {
-			deactivate_locked_super(sb);
-			return ERR_PTR(error);
-		}
-		sb->s_flags |= MS_ACTIVE;
-	}
-
-	return dget(sb->s_root);
-}
-
 static void sysfs_kill_sb(struct super_block *sb)
 {
 	kernfs_kill_sb(sb);
 	kobj_ns_drop(KOBJ_NS_TYPE_NET, (void *)kernfs_super_ns(sb));
 }
 
-/**
- * kernfs_kill_sb - kill_sb for kernfs
- * @sb: super_block being killed
- *
- * This can be used directly for file_system_type->kill_sb().  If a kernfs
- * user needs extra cleanup, it can implement its own kill_sb() and call
- * this function at the end.
- */
-void kernfs_kill_sb(struct super_block *sb)
-{
-	struct sysfs_super_info *info = sysfs_info(sb);
-	struct sysfs_dirent *root_sd = sb->s_root->d_fsdata;
-
-	/*
-	 * Remove the superblock from fs_supers/s_instances
-	 * so we can't find it, before freeing sysfs_super_info.
-	 */
-	kill_anon_super(sb);
-	kfree(info);
-	kernfs_put(root_sd);
-}
-
 static struct file_system_type sysfs_fs_type = {
 	.name		= "sysfs",
 	.mount		= sysfs_mount,
@@ -200,14 +56,6 @@ static struct file_system_type sysfs_fs_type = {
 	.fs_flags	= FS_USERNS_MOUNT,
 };
 
-void __init kernfs_init(void)
-{
-	sysfs_dir_cachep = kmem_cache_create("sysfs_dir_cache",
-					      sizeof(struct sysfs_dirent),
-					      0, SLAB_PANIC, NULL);
-	sysfs_inode_init();
-}
-
 int __init sysfs_init(void)
 {
 	int err;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 93b4b68..6a82311 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -17,25 +17,7 @@
 /*
  * mount.c
  */
-
-struct sysfs_super_info {
-	/*
-	 * The root associated with this super_block.  Each super_block is
-	 * identified by the root and ns it's associated with.
-	 */
-	struct kernfs_root	*root;
-
-	/*
-	 * Each sb is associated with one namespace tag, currently the network
-	 * namespace of the task which mounted this sysfs instance.  If multiple
-	 * tags become necessary, make the following an array and compare
-	 * sysfs_dirent tag against every entry.
-	 */
-	const void		*ns;
-};
-#define sysfs_info(SB) ((struct sysfs_super_info *)(SB->s_fs_info))
 extern struct sysfs_dirent *sysfs_root_sd;
-extern struct kmem_cache *sysfs_dir_cachep;
 
 /*
  * dir.c
-- 
1.8.4.2

