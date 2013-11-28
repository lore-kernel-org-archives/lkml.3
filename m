Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab3K1T5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:57:30 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:53897 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab3K1Tzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:39 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 30/34] sysfs, kernfs: prepare mount path for kernfs
Date: Thu, 28 Nov 2013 14:54:43 -0500
Message-Id: <1385668487-10181-31-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're in the process of separating out core sysfs functionality into
kernfs which will deal with sysfs_dirents directly.  This patch
rearranges mount path so that the kernfs and sysfs parts are separate.

* As sysfs_super_info won't be visible outside kernfs proper,
  kernfs_super_ns() is added to allow kernfs users to access a
  super_block's namespace tag.

* Generic mount operation is separated out into kernfs_mount_ns().
  sysfs_mount() now just performs sysfs-specific permission check,
  acquires namespace tag, and invokes kernfs_mount_ns().

* Generic superblock release is separated out into kernfs_kill_sb()
  which can be used directly as file_system_type->kill_sb().  As sysfs
  needs to put the namespace tag, sysfs_kill_sb() wraps
  kernfs_kill_sb() with ns tag put.

* sysfs_dir_cachep init and sysfs_inode_init() are separated out into
  kernfs_init().  kernfs_init() uses only small amount of memory and
  trying to handle and propagate kernfs_init() failure doesn't make
  much sense.  Use SLAB_PANIC for sysfs_dir_cachep and make
  sysfs_inode_init() panic on failure.

  After this change, kernfs_init() should be called before
  sysfs_init(), fs/namespace.c::mnt_init() modified accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/kernfs/inode.c           |   5 ++-
 fs/kernfs/kernfs-internal.h |   2 +-
 fs/namespace.c              |   2 +
 fs/sysfs/mount.c            | 104 ++++++++++++++++++++++++++++++--------------
 include/linux/kernfs.h      |  28 ++++++++++++
 5 files changed, 106 insertions(+), 35 deletions(-)

diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 9d4fab4..b4cae6f 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -37,9 +37,10 @@ static const struct inode_operations sysfs_inode_operations = {
 	.setxattr	= sysfs_setxattr,
 };
 
-int __init sysfs_inode_init(void)
+void __init sysfs_inode_init(void)
 {
-	return bdi_init(&sysfs_backing_dev_info);
+	if (bdi_init(&sysfs_backing_dev_info))
+		panic("failed to init sysfs_backing_dev_info");
 }
 
 static struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 466943d..0d94988 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -144,7 +144,7 @@ int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
 int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		   size_t size, int flags);
-int sysfs_inode_init(void);
+void sysfs_inode_init(void);
 
 /*
  * dir.c
diff --git a/fs/namespace.c b/fs/namespace.c
index ac2ce8a..a511ea0 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2790,6 +2790,8 @@ void __init mnt_init(void)
 	for (u = 0; u < HASH_SIZE; u++)
 		INIT_LIST_HEAD(&mountpoint_hashtable[u]);
 
+	kernfs_init();
+
 	err = sysfs_init();
 	if (err)
 		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index f143b20..5384732 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -86,18 +86,24 @@ static int sysfs_set_super(struct super_block *sb, void *data)
 	return error;
 }
 
-static void free_sysfs_super_info(struct sysfs_super_info *info)
+/**
+ * kernfs_super_ns - determine the namespace tag of a kernfs super_block
+ * @sb: super_block of interest
+ *
+ * Return the namespace tag associated with kernfs super_block @sb.
+ */
+const void *kernfs_super_ns(struct super_block *sb)
 {
-	kobj_ns_drop(KOBJ_NS_TYPE_NET, (void *)info->ns);
-	kfree(info);
+	struct sysfs_super_info *info = sysfs_info(sb);
+
+	return info->ns;
 }
 
 static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
-	struct sysfs_super_info *info;
-	struct super_block *sb;
-	int error;
+	struct dentry *root;
+	void *ns;
 
 	if (!(flags & MS_KERNMOUNT)) {
 		if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type))
@@ -107,16 +113,44 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 			return ERR_PTR(-EPERM);
 	}
 
+	ns = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
+	root = kernfs_mount_ns(fs_type, flags, sysfs_root, ns);
+	if (IS_ERR(root))
+		kobj_ns_drop(KOBJ_NS_TYPE_NET, ns);
+	return root;
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
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return ERR_PTR(-ENOMEM);
 
-	info->root = sysfs_root;
-	info->ns = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
+	info->root = root;
+	info->ns = ns;
 
 	sb = sget(fs_type, sysfs_test_super, sysfs_set_super, flags, info);
 	if (IS_ERR(sb) || sb->s_fs_info != info)
-		free_sysfs_super_info(info);
+		kfree(info);
 	if (IS_ERR(sb))
 		return ERR_CAST(sb);
 	if (!sb->s_root) {
@@ -133,6 +167,20 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 
 static void sysfs_kill_sb(struct super_block *sb)
 {
+	kernfs_kill_sb(sb);
+	kobj_ns_drop(KOBJ_NS_TYPE_NET, (void *)kernfs_super_ns(sb));
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
 	struct sysfs_super_info *info = sysfs_info(sb);
 	struct sysfs_dirent *root_sd = sb->s_root->d_fsdata;
 
@@ -141,7 +189,7 @@ static void sysfs_kill_sb(struct super_block *sb)
 	 * so we can't find it, before freeing sysfs_super_info.
 	 */
 	kill_anon_super(sb);
-	free_sysfs_super_info(info);
+	kfree(info);
 	kernfs_put(root_sd);
 }
 
@@ -152,37 +200,29 @@ static struct file_system_type sysfs_fs_type = {
 	.fs_flags	= FS_USERNS_MOUNT,
 };
 
-int __init sysfs_init(void)
+void __init kernfs_init(void)
 {
-	int err;
-
 	sysfs_dir_cachep = kmem_cache_create("sysfs_dir_cache",
 					      sizeof(struct sysfs_dirent),
-					      0, 0, NULL);
-	if (!sysfs_dir_cachep)
-		return -ENOMEM;
+					      0, SLAB_PANIC, NULL);
+	sysfs_inode_init();
+}
 
-	err = sysfs_inode_init();
-	if (err)
-		goto out_err;
+int __init sysfs_init(void)
+{
+	int err;
 
 	sysfs_root = kernfs_create_root(NULL);
-	if (IS_ERR(sysfs_root)) {
-		err = PTR_ERR(sysfs_root);
-		goto out_err;
-	}
+	if (IS_ERR(sysfs_root))
+		return PTR_ERR(sysfs_root);
+
 	sysfs_root_sd = sysfs_root->sd;
 
 	err = register_filesystem(&sysfs_fs_type);
-	if (err)
-		goto out_destroy_root;
+	if (err) {
+		kernfs_destroy_root(sysfs_root);
+		return err;
+	}
 
 	return 0;
-
-out_destroy_root:
-	kernfs_destroy_root(sysfs_root);
-out_err:
-	kmem_cache_destroy(sysfs_dir_cachep);
-	sysfs_dir_cachep = NULL;
-	return err;
 }
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index fad8b98..75fcbe5 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -18,6 +18,8 @@ struct file;
 struct iattr;
 struct seq_file;
 struct vm_area_struct;
+struct super_block;
+struct file_system_type;
 
 struct sysfs_dirent;
 
@@ -109,6 +111,13 @@ void kernfs_enable_ns(struct sysfs_dirent *sd);
 int kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr);
 void kernfs_notify(struct sysfs_dirent *sd);
 
+const void *kernfs_super_ns(struct super_block *sb);
+struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
+			       struct kernfs_root *root, const void *ns);
+void kernfs_kill_sb(struct super_block *sb);
+
+void kernfs_init(void);
+
 #else	/* CONFIG_SYSFS */
 
 static inline struct sysfs_dirent *
@@ -160,6 +169,18 @@ static inline int kernfs_setattr(struct sysfs_dirent *sd,
 
 static inline void kernfs_notify(struct sysfs_dirent *sd) { }
 
+static inline const void *kernfs_super_ns(struct super_block *sb)
+{ return NULL; }
+
+static inline struct dentry *
+kernfs_mount_ns(struct file_system_type *fs_type, int flags,
+		struct kernfs_root *root, const void *ns)
+{ return ERR_PTR(-ENOSYS); }
+
+static inline void kernfs_kill_sb(struct super_block *sb) { }
+
+static inline void kernfs_init(void) { }
+
 #endif	/* CONFIG_SYSFS */
 
 static inline struct sysfs_dirent *
@@ -201,4 +222,11 @@ static inline int kernfs_remove_by_name(struct sysfs_dirent *parent,
 	return kernfs_remove_by_name_ns(parent, name, NULL);
 }
 
+static inline struct dentry *
+kernfs_mount(struct file_system_type *fs_type, int flags,
+	     struct kernfs_root *root)
+{
+	return kernfs_mount_ns(fs_type, flags, root, NULL);
+}
+
 #endif	/* __LINUX_KERNFS_H */
-- 
1.8.4.2

