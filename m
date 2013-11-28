Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab3K1T6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:58:25 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:40241 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab3K1Tzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:32 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 27/34] sysfs, kernfs: implement kernfs_create/destroy_root()
Date: Thu, 28 Nov 2013 14:54:40 -0500
Message-Id: <1385668487-10181-28-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There currently is single kernfs hierarchy in the whole system which
is used for sysfs.  kernfs needs to support multiple hierarchies to
allow other users.  This patch introduces struct kernfs_root which
serves as the root of each kernfs hierarchy and implements
kernfs_create/destroy_root().

* Each kernfs_root is associated with a root sd (sysfs_dentry).  The
  root is freed when the root sd is released and kernfs_destory_root()
  simply invokes kernfs_remove() on the root sd.  sysfs_remove_one()
  is updated to handle release of the root sd.  Note that ps_iattr
  update in sysfs_remove_one() is trivially updated for readability.

* Root sd's are now dynamically allocated using sysfs_new_dirent().
  Update sysfs_alloc_ino() so that it gives out ino from 1 so that the
  root sd still gets ino 1.

* While kernfs currently only points to the root sd, it'll soon grow
  fields which are specific to each hierarchy.  As determining a given
  sd's root will be necessary, sd->s_dir.root is added.  This backlink
  fits better as a separate field in sd; however, sd->s_dir is inside
  union with space to spare, so use it to save space and provide
  kernfs_root() accessor to determine the root sd.

* As hierarchies may be destroyed now, each mount needs to hold onto
  the hierarchy it's attached to.  Update sysfs_fill_super() and
  sysfs_kill_sb() so that they get and put the kernfs_root
  respectively.

* sysfs_root is replaced with kernfs_root which is dynamically created
  by invoking kernfs_create_root() from sysfs_init().

This patch doesn't introduce any visible behavior changes.

v2: kernfs_create_root() forgot to set @sd->priv.  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             | 71 +++++++++++++++++++++++++++++++++++++++------
 fs/kernfs/kernfs-internal.h | 20 +++++++++++++
 fs/sysfs/mount.c            | 29 +++++++++++-------
 include/linux/kernfs.h      | 13 +++++++++
 4 files changed, 113 insertions(+), 20 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index a4ca4de..246740a 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -211,7 +211,7 @@ static int sysfs_alloc_ino(unsigned int *pino)
 
  retry:
 	spin_lock(&sysfs_ino_lock);
-	rc = ida_get_new_above(&sysfs_ino_ida, 2, &ino);
+	rc = ida_get_new_above(&sysfs_ino_ida, 1, &ino);
 	spin_unlock(&sysfs_ino_lock);
 
 	if (rc == -EAGAIN) {
@@ -253,9 +253,11 @@ EXPORT_SYMBOL_GPL(kernfs_get);
 void kernfs_put(struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent *parent_sd;
+	struct kernfs_root *root;
 
 	if (!sd || !atomic_dec_and_test(&sd->s_count))
 		return;
+	root = kernfs_root(sd);
  repeat:
 	/* Moving/renaming is always done while holding reference.
 	 * sd->s_parent won't change beneath us.
@@ -278,8 +280,13 @@ void kernfs_put(struct sysfs_dirent *sd)
 	kmem_cache_free(sysfs_dir_cachep, sd);
 
 	sd = parent_sd;
-	if (sd && atomic_dec_and_test(&sd->s_count))
-		goto repeat;
+	if (sd) {
+		if (atomic_dec_and_test(&sd->s_count))
+			goto repeat;
+	} else {
+		/* just released the root sd, free @root too */
+		kfree(root);
+	}
 }
 EXPORT_SYMBOL_GPL(kernfs_put);
 
@@ -493,13 +500,15 @@ static void sysfs_remove_one(struct sysfs_addrm_cxt *acxt,
 	if (sd->s_flags & SYSFS_FLAG_REMOVED)
 		return;
 
-	sysfs_unlink_sibling(sd);
+	if (sd->s_parent) {
+		sysfs_unlink_sibling(sd);
 
-	/* Update timestamps on the parent */
-	ps_iattr = sd->s_parent->s_iattr;
-	if (ps_iattr) {
-		struct iattr *ps_iattrs = &ps_iattr->ia_iattr;
-		ps_iattrs->ia_ctime = ps_iattrs->ia_mtime = CURRENT_TIME;
+		/* Update timestamps on the parent */
+		ps_iattr = sd->s_parent->s_iattr;
+		if (ps_iattr) {
+			ps_iattr->ia_iattr.ia_ctime = CURRENT_TIME;
+			ps_iattr->ia_iattr.ia_mtime = CURRENT_TIME;
+		}
 	}
 
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
@@ -604,6 +613,49 @@ struct sysfs_dirent *kernfs_find_and_get_ns(struct sysfs_dirent *parent,
 EXPORT_SYMBOL_GPL(kernfs_find_and_get_ns);
 
 /**
+ * kernfs_create_root - create a new kernfs hierarchy
+ * @priv: opaque data associated with the new directory
+ *
+ * Returns the root of the new hierarchy on success, ERR_PTR() value on
+ * failure.
+ */
+struct kernfs_root *kernfs_create_root(void *priv)
+{
+	struct kernfs_root *root;
+	struct sysfs_dirent *sd;
+
+	root = kzalloc(sizeof(*root), GFP_KERNEL);
+	if (!root)
+		return ERR_PTR(-ENOMEM);
+
+	sd = sysfs_new_dirent("", S_IFDIR | S_IRUGO | S_IXUGO, SYSFS_DIR);
+	if (!sd) {
+		kfree(root);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	sd->s_flags &= ~SYSFS_FLAG_REMOVED;
+	sd->priv = priv;
+	sd->s_dir.root = root;
+
+	root->sd = sd;
+
+	return root;
+}
+
+/**
+ * kernfs_destroy_root - destroy a kernfs hierarchy
+ * @root: root of the hierarchy to destroy
+ *
+ * Destroy the hierarchy anchored at @root by removing all existing
+ * directories and destroying @root.
+ */
+void kernfs_destroy_root(struct kernfs_root *root)
+{
+	kernfs_remove(root->sd);	/* will also free @root */
+}
+
+/**
  * kernfs_create_dir_ns - create a directory
  * @parent: parent in which to create a new directory
  * @name: name of the new directory
@@ -626,6 +678,7 @@ struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
 	if (!sd)
 		return ERR_PTR(-ENOMEM);
 
+	sd->s_dir.root = parent->s_dir.root;
 	sd->s_ns = ns;
 	sd->priv = priv;
 
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 62ae35f..7dfe062 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -25,6 +25,12 @@ struct sysfs_elem_dir {
 	unsigned long		subdirs;
 	/* children rbtree starts here and goes through sd->s_rb */
 	struct rb_root		children;
+
+	/*
+	 * The kernfs hierarchy this directory belongs to.  This fits
+	 * better directly in sysfs_dirent but is here to save space.
+	 */
+	struct kernfs_root	*root;
 };
 
 struct sysfs_elem_symlink {
@@ -104,6 +110,20 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 	return sd->s_flags & SYSFS_TYPE_MASK;
 }
 
+/**
+ * kernfs_root - find out the kernfs_root a sysfs_dirent belongs to
+ * @sd: sysfs_dirent of interest
+ *
+ * Return the kernfs_root @sd belongs to.
+ */
+static inline struct kernfs_root *kernfs_root(struct sysfs_dirent *sd)
+{
+	/* if parent exists, it's always a dir; otherwise, @sd is a dir */
+	if (sd->s_parent)
+		sd = sd->s_parent;
+	return sd->s_dir.root;
+}
+
 /*
  * Context structure to be used while adding/removing nodes.
  */
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 7cbd1fc..0b5661b 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -32,15 +32,8 @@ static const struct super_operations sysfs_ops = {
 	.evict_inode	= sysfs_evict_inode,
 };
 
-static struct sysfs_dirent sysfs_root = {
-	.s_name		= "",
-	.s_count	= ATOMIC_INIT(1),
-	.s_flags	= SYSFS_DIR,
-	.s_mode		= S_IFDIR | S_IRUGO | S_IXUGO,
-	.s_ino		= 1,
-};
-
-struct sysfs_dirent *sysfs_root_sd = &sysfs_root;
+static struct kernfs_root *sysfs_root;
+struct sysfs_dirent *sysfs_root_sd;
 
 static int sysfs_fill_super(struct super_block *sb)
 {
@@ -68,6 +61,7 @@ static int sysfs_fill_super(struct super_block *sb)
 		pr_debug("%s: could not get root dentry!\n", __func__);
 		return -ENOMEM;
 	}
+	kernfs_get(sysfs_root_sd);
 	root->d_fsdata = sysfs_root_sd;
 	sb->s_root = root;
 	sb->s_d_op = &sysfs_dentry_ops;
@@ -138,11 +132,15 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 static void sysfs_kill_sb(struct super_block *sb)
 {
 	struct sysfs_super_info *info = sysfs_info(sb);
-	/* Remove the superblock from fs_supers/s_instances
+	struct sysfs_dirent *root_sd = sb->s_root->d_fsdata;
+
+	/*
+	 * Remove the superblock from fs_supers/s_instances
 	 * so we can't find it, before freeing sysfs_super_info.
 	 */
 	kill_anon_super(sb);
 	free_sysfs_super_info(info);
+	kernfs_put(root_sd);
 }
 
 static struct file_system_type sysfs_fs_type = {
@@ -166,12 +164,21 @@ int __init sysfs_init(void)
 	if (err)
 		goto out_err;
 
+	sysfs_root = kernfs_create_root(NULL);
+	if (IS_ERR(sysfs_root)) {
+		err = PTR_ERR(sysfs_root);
+		goto out_err;
+	}
+	sysfs_root_sd = sysfs_root->sd;
+
 	err = register_filesystem(&sysfs_fs_type);
 	if (err)
-		goto out_err;
+		goto out_destroy_root;
 
 	return 0;
 
+out_destroy_root:
+	kernfs_destroy_root(sysfs_root);
 out_err:
 	kmem_cache_destroy(sysfs_dir_cachep);
 	sysfs_dir_cachep = NULL;
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index fd8f574..f75548b 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -20,6 +20,11 @@ struct vm_area_struct;
 
 struct sysfs_dirent;
 
+struct kernfs_root {
+	/* published fields */
+	struct sysfs_dirent	*sd;
+};
+
 struct sysfs_open_file {
 	/* published fields */
 	struct sysfs_dirent	*sd;
@@ -76,6 +81,9 @@ struct sysfs_dirent *kernfs_find_and_get_ns(struct sysfs_dirent *parent,
 void kernfs_get(struct sysfs_dirent *sd);
 void kernfs_put(struct sysfs_dirent *sd);
 
+struct kernfs_root *kernfs_create_root(void *priv);
+void kernfs_destroy_root(struct kernfs_root *root);
+
 struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
 					  const char *name, void *priv,
 					  const void *ns);
@@ -107,6 +115,11 @@ kernfs_find_and_get_ns(struct sysfs_dirent *parent, const char *name,
 static inline void kernfs_get(struct sysfs_dirent *sd) { }
 static inline void kernfs_put(struct sysfs_dirent *sd) { }
 
+static inline struct kernfs_root *kernfs_create_root(void *priv)
+{ return ERR_PTR(-ENOSYS); }
+
+static inline void kernfs_destroy_root(struct kernfs_root *root) { }
+
 static inline struct sysfs_dirent *
 kernfs_create_dir_ns(struct sysfs_dirent *parent, const char *name, void *priv,
 		     const void *ns)
-- 
1.8.4.2

