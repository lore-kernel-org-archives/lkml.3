Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab3LKTMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:12:52 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:62308 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3LKTMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:12:44 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, linus.walleij@linaro.org,
        ashutosh.dixit@intel.com, Tejun Heo <tj@kernel.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH 1/6] kernfs: s/sysfs_dirent/kernfs_node/ and rename its friends accordingly
Date: Wed, 11 Dec 2013 14:11:53 -0500
Message-Id: <1386789118-24733-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386789118-24733-1-git-send-email-tj@kernel.org>
References: <1386789118-24733-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs has just been separated out from sysfs and we're already in
full conflict mode.  Nothing can make the situation any worse.  Let's
take the chance to name things properly.

This patch performs the following renames.

* s/sysfs_elem_dir/kernfs_elem_dir/
* s/sysfs_elem_symlink/kernfs_elem_symlink/
* s/sysfs_elem_attr/kernfs_elem_file/
* s/sysfs_dirent/kernfs_node/
* s/sd/kn/ in kernfs proper
* s/parent_sd/parent/
* s/target_sd/target/
* s/dir_sd/parent/
* s/to_sysfs_dirent()/rb_to_kn()/
* misc renames of local vars when they conflict with the above

Because md, mic and gpio dig into sysfs details, this patch ends up
modifying them.  All are sysfs_dirent renames and trivial.  While we
can avoid these by introducing a dummy wrapping struct sysfs_dirent
around kernfs_node, given the limited usage outside kernfs and sysfs
proper, I don't think such workaround is called for.

This patch is strictly rename only and doesn't introduce any
functional difference.

- mic / gpio renames were missing.  Spotted by kbuild test robot.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: kbuild test robot <fengguang.wu@intel.com>
---
 drivers/gpio/gpiolib.c             |   4 +-
 drivers/md/bitmap.c                |   2 +-
 drivers/md/bitmap.h                |   2 +-
 drivers/md/md.h                    |  10 +-
 drivers/misc/mic/host/mic_device.h |   2 +-
 fs/kernfs/dir.c                    | 542 ++++++++++++++++++-------------------
 fs/kernfs/file.c                   | 186 ++++++-------
 fs/kernfs/inode.c                  | 123 ++++-----
 fs/kernfs/kernfs-internal.h        |  40 +--
 fs/kernfs/mount.c                  |  12 +-
 fs/kernfs/symlink.c                |  64 ++---
 fs/sysfs/dir.c                     |  66 ++---
 fs/sysfs/file.c                    | 122 ++++-----
 fs/sysfs/group.c                   |  96 +++----
 fs/sysfs/mount.c                   |   4 +-
 fs/sysfs/symlink.c                 |  72 ++---
 fs/sysfs/sysfs.h                   |  10 +-
 include/linux/kernfs.h             | 166 ++++++------
 include/linux/kobject.h            |   2 +-
 include/linux/sysfs.h              |  20 +-
 lib/kobject.c                      |   2 +-
 21 files changed, 774 insertions(+), 773 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 85f772c..c8a7c81 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -393,7 +393,7 @@ static const DEVICE_ATTR(value, 0644,
 
 static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
 {
-	struct sysfs_dirent	*value_sd = priv;
+	struct kernfs_node	*value_sd = priv;
 
 	sysfs_notify_dirent(value_sd);
 	return IRQ_HANDLED;
@@ -402,7 +402,7 @@ static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
 static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 		unsigned long gpio_flags)
 {
-	struct sysfs_dirent	*value_sd;
+	struct kernfs_node	*value_sd;
 	unsigned long		irq_flags;
 	int			ret, irq, id;
 
diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 12dc29b..4195a01 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1635,7 +1635,7 @@ int bitmap_create(struct mddev *mddev)
 	sector_t blocks = mddev->resync_max_sectors;
 	struct file *file = mddev->bitmap_info.file;
 	int err;
-	struct sysfs_dirent *bm = NULL;
+	struct kernfs_node *bm = NULL;
 
 	BUILD_BUG_ON(sizeof(bitmap_super_t) != 256);
 
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index df4aeb6..30210b9 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -225,7 +225,7 @@ struct bitmap {
 	wait_queue_head_t overflow_wait;
 	wait_queue_head_t behind_wait;
 
-	struct sysfs_dirent *sysfs_can_clear;
+	struct kernfs_node *sysfs_can_clear;
 };
 
 /* the bitmap API */
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2f5cc8a..389a3c9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -106,7 +106,7 @@ struct md_rdev {
 					   */
 	struct work_struct del_work;	/* used for delayed sysfs removal */
 
-	struct sysfs_dirent *sysfs_state; /* handle for 'state'
+	struct kernfs_node *sysfs_state; /* handle for 'state'
 					   * sysfs entry */
 
 	struct badblocks {
@@ -376,10 +376,10 @@ struct mddev {
 	sector_t			resync_max;	/* resync should pause
 							 * when it gets here */
 
-	struct sysfs_dirent		*sysfs_state;	/* handle for 'array_state'
+	struct kernfs_node		*sysfs_state;	/* handle for 'array_state'
 							 * file in sysfs.
 							 */
-	struct sysfs_dirent		*sysfs_action;  /* handle for 'sync_action' */
+	struct kernfs_node		*sysfs_action;  /* handle for 'sync_action' */
 
 	struct work_struct del_work;	/* used for delayed sysfs removal */
 
@@ -498,13 +498,13 @@ struct md_sysfs_entry {
 };
 extern struct attribute_group md_bitmap_group;
 
-static inline struct sysfs_dirent *sysfs_get_dirent_safe(struct sysfs_dirent *sd, char *name)
+static inline struct kernfs_node *sysfs_get_dirent_safe(struct kernfs_node *sd, char *name)
 {
 	if (sd)
 		return sysfs_get_dirent(sd, name);
 	return sd;
 }
-static inline void sysfs_notify_dirent_safe(struct sysfs_dirent *sd)
+static inline void sysfs_notify_dirent_safe(struct kernfs_node *sd)
 {
 	if (sd)
 		sysfs_notify_dirent(sd);
diff --git a/drivers/misc/mic/host/mic_device.h b/drivers/misc/mic/host/mic_device.h
index 3574cc3..538e3d3 100644
--- a/drivers/misc/mic/host/mic_device.h
+++ b/drivers/misc/mic/host/mic_device.h
@@ -112,7 +112,7 @@ struct mic_device {
 	struct work_struct shutdown_work;
 	u8 state;
 	u8 shutdown_status;
-	struct sysfs_dirent *state_sysfs;
+	struct kernfs_node *state_sysfs;
 	struct completion reset_wait;
 	void *log_buf_addr;
 	int *log_buf_len;
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index a441e3b..800ebf5 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -19,7 +19,7 @@
 
 DEFINE_MUTEX(sysfs_mutex);
 
-#define to_sysfs_dirent(X) rb_entry((X), struct sysfs_dirent, s_rb)
+#define rb_to_kn(X) rb_entry((X), struct kernfs_node, s_rb)
 
 /**
  *	sysfs_name_hash
@@ -45,28 +45,28 @@ static unsigned int sysfs_name_hash(const char *name, const void *ns)
 }
 
 static int sysfs_name_compare(unsigned int hash, const char *name,
-			      const void *ns, const struct sysfs_dirent *sd)
+			      const void *ns, const struct kernfs_node *kn)
 {
-	if (hash != sd->s_hash)
-		return hash - sd->s_hash;
-	if (ns != sd->s_ns)
-		return ns - sd->s_ns;
-	return strcmp(name, sd->s_name);
+	if (hash != kn->s_hash)
+		return hash - kn->s_hash;
+	if (ns != kn->s_ns)
+		return ns - kn->s_ns;
+	return strcmp(name, kn->s_name);
 }
 
-static int sysfs_sd_compare(const struct sysfs_dirent *left,
-			    const struct sysfs_dirent *right)
+static int sysfs_sd_compare(const struct kernfs_node *left,
+			    const struct kernfs_node *right)
 {
 	return sysfs_name_compare(left->s_hash, left->s_name, left->s_ns,
 				  right);
 }
 
 /**
- *	sysfs_link_sibling - link sysfs_dirent into sibling rbtree
- *	@sd: sysfs_dirent of interest
+ *	sysfs_link_sibling - link kernfs_node into sibling rbtree
+ *	@kn: kernfs_node of interest
  *
- *	Link @sd into its sibling rbtree which starts from
- *	sd->s_parent->s_dir.children.
+ *	Link @kn into its sibling rbtree which starts from
+ *	@kn->s_parent->s_dir.children.
  *
  *	Locking:
  *	mutex_lock(sysfs_mutex)
@@ -74,21 +74,21 @@ static int sysfs_sd_compare(const struct sysfs_dirent *left,
  *	RETURNS:
  *	0 on susccess -EEXIST on failure.
  */
-static int sysfs_link_sibling(struct sysfs_dirent *sd)
+static int sysfs_link_sibling(struct kernfs_node *kn)
 {
-	struct rb_node **node = &sd->s_parent->s_dir.children.rb_node;
+	struct rb_node **node = &kn->s_parent->s_dir.children.rb_node;
 	struct rb_node *parent = NULL;
 
-	if (sysfs_type(sd) == SYSFS_DIR)
-		sd->s_parent->s_dir.subdirs++;
+	if (sysfs_type(kn) == SYSFS_DIR)
+		kn->s_parent->s_dir.subdirs++;
 
 	while (*node) {
-		struct sysfs_dirent *pos;
+		struct kernfs_node *pos;
 		int result;
 
-		pos = to_sysfs_dirent(*node);
+		pos = rb_to_kn(*node);
 		parent = *node;
-		result = sysfs_sd_compare(sd, pos);
+		result = sysfs_sd_compare(kn, pos);
 		if (result < 0)
 			node = &pos->s_rb.rb_left;
 		else if (result > 0)
@@ -97,168 +97,169 @@ static int sysfs_link_sibling(struct sysfs_dirent *sd)
 			return -EEXIST;
 	}
 	/* add new node and rebalance the tree */
-	rb_link_node(&sd->s_rb, parent, node);
-	rb_insert_color(&sd->s_rb, &sd->s_parent->s_dir.children);
+	rb_link_node(&kn->s_rb, parent, node);
+	rb_insert_color(&kn->s_rb, &kn->s_parent->s_dir.children);
 	return 0;
 }
 
 /**
- *	sysfs_unlink_sibling - unlink sysfs_dirent from sibling rbtree
- *	@sd: sysfs_dirent of interest
+ *	sysfs_unlink_sibling - unlink kernfs_node from sibling rbtree
+ *	@kn: kernfs_node of interest
  *
- *	Unlink @sd from its sibling rbtree which starts from
- *	sd->s_parent->s_dir.children.
+ *	Unlink @kn from its sibling rbtree which starts from
+ *	kn->s_parent->s_dir.children.
  *
  *	Locking:
  *	mutex_lock(sysfs_mutex)
  */
-static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
+static void sysfs_unlink_sibling(struct kernfs_node *kn)
 {
-	if (sysfs_type(sd) == SYSFS_DIR)
-		sd->s_parent->s_dir.subdirs--;
+	if (sysfs_type(kn) == SYSFS_DIR)
+		kn->s_parent->s_dir.subdirs--;
 
-	rb_erase(&sd->s_rb, &sd->s_parent->s_dir.children);
+	rb_erase(&kn->s_rb, &kn->s_parent->s_dir.children);
 }
 
 /**
- *	sysfs_get_active - get an active reference to sysfs_dirent
- *	@sd: sysfs_dirent to get an active reference to
+ *	sysfs_get_active - get an active reference to kernfs_node
+ *	@kn: kernfs_node to get an active reference to
  *
- *	Get an active reference of @sd.  This function is noop if @sd
+ *	Get an active reference of @kn.  This function is noop if @kn
  *	is NULL.
  *
  *	RETURNS:
- *	Pointer to @sd on success, NULL on failure.
+ *	Pointer to @kn on success, NULL on failure.
  */
-struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
+struct kernfs_node *sysfs_get_active(struct kernfs_node *kn)
 {
-	if (unlikely(!sd))
+	if (unlikely(!kn))
 		return NULL;
 
-	if (!atomic_inc_unless_negative(&sd->s_active))
+	if (!atomic_inc_unless_negative(&kn->s_active))
 		return NULL;
 
-	if (sd->s_flags & SYSFS_FLAG_LOCKDEP)
-		rwsem_acquire_read(&sd->dep_map, 0, 1, _RET_IP_);
-	return sd;
+	if (kn->s_flags & SYSFS_FLAG_LOCKDEP)
+		rwsem_acquire_read(&kn->dep_map, 0, 1, _RET_IP_);
+	return kn;
 }
 
 /**
- *	sysfs_put_active - put an active reference to sysfs_dirent
- *	@sd: sysfs_dirent to put an active reference to
+ *	sysfs_put_active - put an active reference to kernfs_node
+ *	@kn: kernfs_node to put an active reference to
  *
- *	Put an active reference to @sd.  This function is noop if @sd
+ *	Put an active reference to @kn.  This function is noop if @kn
  *	is NULL.
  */
-void sysfs_put_active(struct sysfs_dirent *sd)
+void sysfs_put_active(struct kernfs_node *kn)
 {
 	int v;
 
-	if (unlikely(!sd))
+	if (unlikely(!kn))
 		return;
 
-	if (sd->s_flags & SYSFS_FLAG_LOCKDEP)
-		rwsem_release(&sd->dep_map, 1, _RET_IP_);
-	v = atomic_dec_return(&sd->s_active);
+	if (kn->s_flags & SYSFS_FLAG_LOCKDEP)
+		rwsem_release(&kn->dep_map, 1, _RET_IP_);
+	v = atomic_dec_return(&kn->s_active);
 	if (likely(v != SD_DEACTIVATED_BIAS))
 		return;
 
-	/* atomic_dec_return() is a mb(), we'll always see the updated
-	 * sd->u.completion.
+	/*
+	 * atomic_dec_return() is a mb(), we'll always see the updated
+	 * kn->u.completion.
 	 */
-	complete(sd->u.completion);
+	complete(kn->u.completion);
 }
 
 /**
- *	sysfs_deactivate - deactivate sysfs_dirent
- *	@sd: sysfs_dirent to deactivate
+ *	sysfs_deactivate - deactivate kernfs_node
+ *	@kn: kernfs_node to deactivate
  *
  *	Deny new active references and drain existing ones.
  */
-static void sysfs_deactivate(struct sysfs_dirent *sd)
+static void sysfs_deactivate(struct kernfs_node *kn)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	int v;
 
-	BUG_ON(!(sd->s_flags & SYSFS_FLAG_REMOVED));
+	BUG_ON(!(kn->s_flags & SYSFS_FLAG_REMOVED));
 
-	if (!(sysfs_type(sd) & SYSFS_ACTIVE_REF))
+	if (!(sysfs_type(kn) & SYSFS_ACTIVE_REF))
 		return;
 
-	sd->u.completion = (void *)&wait;
+	kn->u.completion = (void *)&wait;
 
-	rwsem_acquire(&sd->dep_map, 0, 0, _RET_IP_);
+	rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
 	/* atomic_add_return() is a mb(), put_active() will always see
-	 * the updated sd->u.completion.
+	 * the updated kn->u.completion.
 	 */
-	v = atomic_add_return(SD_DEACTIVATED_BIAS, &sd->s_active);
+	v = atomic_add_return(SD_DEACTIVATED_BIAS, &kn->s_active);
 
 	if (v != SD_DEACTIVATED_BIAS) {
-		lock_contended(&sd->dep_map, _RET_IP_);
+		lock_contended(&kn->dep_map, _RET_IP_);
 		wait_for_completion(&wait);
 	}
 
-	lock_acquired(&sd->dep_map, _RET_IP_);
-	rwsem_release(&sd->dep_map, 1, _RET_IP_);
+	lock_acquired(&kn->dep_map, _RET_IP_);
+	rwsem_release(&kn->dep_map, 1, _RET_IP_);
 }
 
 /**
- * kernfs_get - get a reference count on a sysfs_dirent
- * @sd: the target sysfs_dirent
+ * kernfs_get - get a reference count on a kernfs_node
+ * @kn: the target kernfs_node
  */
-void kernfs_get(struct sysfs_dirent *sd)
+void kernfs_get(struct kernfs_node *kn)
 {
-	if (sd) {
-		WARN_ON(!atomic_read(&sd->s_count));
-		atomic_inc(&sd->s_count);
+	if (kn) {
+		WARN_ON(!atomic_read(&kn->s_count));
+		atomic_inc(&kn->s_count);
 	}
 }
 EXPORT_SYMBOL_GPL(kernfs_get);
 
 /**
- * kernfs_put - put a reference count on a sysfs_dirent
- * @sd: the target sysfs_dirent
+ * kernfs_put - put a reference count on a kernfs_node
+ * @kn: the target kernfs_node
  *
- * Put a reference count of @sd and destroy it if it reached zero.
+ * Put a reference count of @kn and destroy it if it reached zero.
  */
-void kernfs_put(struct sysfs_dirent *sd)
+void kernfs_put(struct kernfs_node *kn)
 {
-	struct sysfs_dirent *parent_sd;
+	struct kernfs_node *parent;
 	struct kernfs_root *root;
 
-	if (!sd || !atomic_dec_and_test(&sd->s_count))
+	if (!kn || !atomic_dec_and_test(&kn->s_count))
 		return;
-	root = kernfs_root(sd);
+	root = kernfs_root(kn);
  repeat:
 	/* Moving/renaming is always done while holding reference.
-	 * sd->s_parent won't change beneath us.
+	 * kn->s_parent won't change beneath us.
 	 */
-	parent_sd = sd->s_parent;
+	parent = kn->s_parent;
 
-	WARN(!(sd->s_flags & SYSFS_FLAG_REMOVED),
+	WARN(!(kn->s_flags & SYSFS_FLAG_REMOVED),
 		"sysfs: free using entry: %s/%s\n",
-		parent_sd ? parent_sd->s_name : "", sd->s_name);
-
-	if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
-		kernfs_put(sd->s_symlink.target_sd);
-	if (sysfs_type(sd) & SYSFS_COPY_NAME)
-		kfree(sd->s_name);
-	if (sd->s_iattr) {
-		if (sd->s_iattr->ia_secdata)
-			security_release_secctx(sd->s_iattr->ia_secdata,
-						sd->s_iattr->ia_secdata_len);
-		simple_xattrs_free(&sd->s_iattr->xattrs);
+		parent ? parent->s_name : "", kn->s_name);
+
+	if (sysfs_type(kn) == SYSFS_KOBJ_LINK)
+		kernfs_put(kn->s_symlink.target_kn);
+	if (sysfs_type(kn) & SYSFS_COPY_NAME)
+		kfree(kn->s_name);
+	if (kn->s_iattr) {
+		if (kn->s_iattr->ia_secdata)
+			security_release_secctx(kn->s_iattr->ia_secdata,
+						kn->s_iattr->ia_secdata_len);
+		simple_xattrs_free(&kn->s_iattr->xattrs);
 	}
-	kfree(sd->s_iattr);
-	ida_simple_remove(&root->ino_ida, sd->s_ino);
-	kmem_cache_free(sysfs_dir_cachep, sd);
+	kfree(kn->s_iattr);
+	ida_simple_remove(&root->ino_ida, kn->s_ino);
+	kmem_cache_free(sysfs_dir_cachep, kn);
 
-	sd = parent_sd;
-	if (sd) {
-		if (atomic_dec_and_test(&sd->s_count))
+	kn = parent;
+	if (kn) {
+		if (atomic_dec_and_test(&kn->s_count))
 			goto repeat;
 	} else {
-		/* just released the root sd, free @root too */
+		/* just released the root kn, free @root too */
 		ida_destroy(&root->ino_ida);
 		kfree(root);
 	}
@@ -267,35 +268,35 @@ EXPORT_SYMBOL_GPL(kernfs_put);
 
 static int sysfs_dentry_delete(const struct dentry *dentry)
 {
-	struct sysfs_dirent *sd = dentry->d_fsdata;
-	return !(sd && !(sd->s_flags & SYSFS_FLAG_REMOVED));
+	struct kernfs_node *kn = dentry->d_fsdata;
+	return !(kn && !(kn->s_flags & SYSFS_FLAG_REMOVED));
 }
 
 static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 {
-	struct sysfs_dirent *sd;
+	struct kernfs_node *kn;
 
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
-	sd = dentry->d_fsdata;
+	kn = dentry->d_fsdata;
 	mutex_lock(&sysfs_mutex);
 
 	/* The sysfs dirent has been deleted */
-	if (sd->s_flags & SYSFS_FLAG_REMOVED)
+	if (kn->s_flags & SYSFS_FLAG_REMOVED)
 		goto out_bad;
 
 	/* The sysfs dirent has been moved? */
-	if (dentry->d_parent->d_fsdata != sd->s_parent)
+	if (dentry->d_parent->d_fsdata != kn->s_parent)
 		goto out_bad;
 
 	/* The sysfs dirent has been renamed */
-	if (strcmp(dentry->d_name.name, sd->s_name) != 0)
+	if (strcmp(dentry->d_name.name, kn->s_name) != 0)
 		goto out_bad;
 
 	/* The sysfs dirent has been moved to a different namespace */
-	if (sd->s_parent && kernfs_ns_enabled(sd->s_parent) &&
-	    sysfs_info(dentry->d_sb)->ns != sd->s_ns)
+	if (kn->s_parent && kernfs_ns_enabled(kn->s_parent) &&
+	    sysfs_info(dentry->d_sb)->ns != kn->s_ns)
 		goto out_bad;
 
 	mutex_unlock(&sysfs_mutex);
@@ -335,11 +336,11 @@ const struct dentry_operations sysfs_dentry_ops = {
 	.d_release	= sysfs_dentry_release,
 };
 
-struct sysfs_dirent *sysfs_new_dirent(struct kernfs_root *root,
-				      const char *name, umode_t mode, int type)
+struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
+				     const char *name, umode_t mode, int type)
 {
 	char *dup_name = NULL;
-	struct sysfs_dirent *sd;
+	struct kernfs_node *kn;
 	int ret;
 
 	if (type & SYSFS_COPY_NAME) {
@@ -348,38 +349,38 @@ struct sysfs_dirent *sysfs_new_dirent(struct kernfs_root *root,
 			return NULL;
 	}
 
-	sd = kmem_cache_zalloc(sysfs_dir_cachep, GFP_KERNEL);
-	if (!sd)
+	kn = kmem_cache_zalloc(sysfs_dir_cachep, GFP_KERNEL);
+	if (!kn)
 		goto err_out1;
 
 	ret = ida_simple_get(&root->ino_ida, 1, 0, GFP_KERNEL);
 	if (ret < 0)
 		goto err_out2;
-	sd->s_ino = ret;
+	kn->s_ino = ret;
 
-	atomic_set(&sd->s_count, 1);
-	atomic_set(&sd->s_active, 0);
+	atomic_set(&kn->s_count, 1);
+	atomic_set(&kn->s_active, 0);
 
-	sd->s_name = name;
-	sd->s_mode = mode;
-	sd->s_flags = type | SYSFS_FLAG_REMOVED;
+	kn->s_name = name;
+	kn->s_mode = mode;
+	kn->s_flags = type | SYSFS_FLAG_REMOVED;
 
-	return sd;
+	return kn;
 
  err_out2:
-	kmem_cache_free(sysfs_dir_cachep, sd);
+	kmem_cache_free(sysfs_dir_cachep, kn);
  err_out1:
 	kfree(dup_name);
 	return NULL;
 }
 
 /**
- *	sysfs_addrm_start - prepare for sysfs_dirent add/remove
+ *	sysfs_addrm_start - prepare for kernfs_node add/remove
  *	@acxt: pointer to sysfs_addrm_cxt to be used
  *
  *	This function is called when the caller is about to add or remove
- *	sysfs_dirent.  This function acquires sysfs_mutex.  @acxt is used
- *	to keep and pass context to other addrm functions.
+ *	kernfs_node.  This function acquires sysfs_mutex.  @acxt is used to
+ *	keep and pass context to other addrm functions.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).  sysfs_mutex is locked on
@@ -394,13 +395,13 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt)
 }
 
 /**
- *	sysfs_add_one - add sysfs_dirent to parent without warning
+ *	sysfs_add_one - add kernfs_node to parent without warning
  *	@acxt: addrm context to use
- *	@sd: sysfs_dirent to be added
- *	@parent_sd: the parent sysfs_dirent to add @sd to
+ *	@kn: kernfs_node to be added
+ *	@parent: the parent kernfs_node to add @kn to
  *
- *	Get @parent_sd and set @sd->s_parent to it and increment nlink of
- *	the parent inode if @sd is a directory and link into the children
+ *	Get @parent and set @kn->s_parent to it and increment nlink of
+ *	the parent inode if @kn is a directory and link into the children
  *	list of the parent.
  *
  *	This function should be called between calls to
@@ -414,51 +415,51 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt)
  *	0 on success, -EEXIST if entry with the given name already
  *	exists.
  */
-int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
-		  struct sysfs_dirent *parent_sd)
+int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct kernfs_node *kn,
+		  struct kernfs_node *parent)
 {
-	bool has_ns = kernfs_ns_enabled(parent_sd);
+	bool has_ns = kernfs_ns_enabled(parent);
 	struct sysfs_inode_attrs *ps_iattr;
 	int ret;
 
-	if (has_ns != (bool)sd->s_ns) {
+	if (has_ns != (bool)kn->s_ns) {
 		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
 		     has_ns ? "required" : "invalid",
-		     parent_sd->s_name, sd->s_name);
+		     parent->s_name, kn->s_name);
 		return -EINVAL;
 	}
 
-	if (sysfs_type(parent_sd) != SYSFS_DIR)
+	if (sysfs_type(parent) != SYSFS_DIR)
 		return -EINVAL;
 
-	sd->s_hash = sysfs_name_hash(sd->s_name, sd->s_ns);
-	sd->s_parent = parent_sd;
-	kernfs_get(parent_sd);
+	kn->s_hash = sysfs_name_hash(kn->s_name, kn->s_ns);
+	kn->s_parent = parent;
+	kernfs_get(parent);
 
-	ret = sysfs_link_sibling(sd);
+	ret = sysfs_link_sibling(kn);
 	if (ret)
 		return ret;
 
 	/* Update timestamps on the parent */
-	ps_iattr = parent_sd->s_iattr;
+	ps_iattr = parent->s_iattr;
 	if (ps_iattr) {
 		struct iattr *ps_iattrs = &ps_iattr->ia_iattr;
 		ps_iattrs->ia_ctime = ps_iattrs->ia_mtime = CURRENT_TIME;
 	}
 
 	/* Mark the entry added into directory tree */
-	sd->s_flags &= ~SYSFS_FLAG_REMOVED;
+	kn->s_flags &= ~SYSFS_FLAG_REMOVED;
 
 	return 0;
 }
 
 /**
- *	sysfs_remove_one - remove sysfs_dirent from parent
+ *	sysfs_remove_one - remove kernfs_node from parent
  *	@acxt: addrm context to use
- *	@sd: sysfs_dirent to be removed
+ *	@kn: kernfs_node to be removed
  *
- *	Mark @sd removed and drop nlink of parent inode if @sd is a
- *	directory.  @sd is unlinked from the children list.
+ *	Mark @kn removed and drop nlink of parent inode if @kn is a
+ *	directory.  @kn is unlinked from the children list.
  *
  *	This function should be called between calls to
  *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
@@ -468,7 +469,7 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
  *	Determined by sysfs_addrm_start().
  */
 static void sysfs_remove_one(struct sysfs_addrm_cxt *acxt,
-			     struct sysfs_dirent *sd)
+			     struct kernfs_node *kn)
 {
 	struct sysfs_inode_attrs *ps_iattr;
 
@@ -476,31 +477,31 @@ static void sysfs_remove_one(struct sysfs_addrm_cxt *acxt,
 	 * Removal can be called multiple times on the same node.  Only the
 	 * first invocation is effective and puts the base ref.
 	 */
-	if (sd->s_flags & SYSFS_FLAG_REMOVED)
+	if (kn->s_flags & SYSFS_FLAG_REMOVED)
 		return;
 
-	if (sd->s_parent) {
-		sysfs_unlink_sibling(sd);
+	if (kn->s_parent) {
+		sysfs_unlink_sibling(kn);
 
 		/* Update timestamps on the parent */
-		ps_iattr = sd->s_parent->s_iattr;
+		ps_iattr = kn->s_parent->s_iattr;
 		if (ps_iattr) {
 			ps_iattr->ia_iattr.ia_ctime = CURRENT_TIME;
 			ps_iattr->ia_iattr.ia_mtime = CURRENT_TIME;
 		}
 	}
 
-	sd->s_flags |= SYSFS_FLAG_REMOVED;
-	sd->u.removed_list = acxt->removed;
-	acxt->removed = sd;
+	kn->s_flags |= SYSFS_FLAG_REMOVED;
+	kn->u.removed_list = acxt->removed;
+	acxt->removed = kn;
 }
 
 /**
- *	sysfs_addrm_finish - finish up sysfs_dirent add/remove
+ *	sysfs_addrm_finish - finish up kernfs_node add/remove
  *	@acxt: addrm context to finish up
  *
- *	Finish up sysfs_dirent add/remove.  Resources acquired by
- *	sysfs_addrm_start() are released and removed sysfs_dirents are
+ *	Finish up kernfs_node add/remove.  Resources acquired by
+ *	sysfs_addrm_start() are released and removed kernfs_nodes are
  *	cleaned up.
  *
  *	LOCKING:
@@ -512,30 +513,30 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 	/* release resources acquired by sysfs_addrm_start() */
 	mutex_unlock(&sysfs_mutex);
 
-	/* kill removed sysfs_dirents */
+	/* kill removed kernfs_nodes */
 	while (acxt->removed) {
-		struct sysfs_dirent *sd = acxt->removed;
+		struct kernfs_node *kn = acxt->removed;
 
-		acxt->removed = sd->u.removed_list;
+		acxt->removed = kn->u.removed_list;
 
-		sysfs_deactivate(sd);
-		sysfs_unmap_bin_file(sd);
-		kernfs_put(sd);
+		sysfs_deactivate(kn);
+		sysfs_unmap_bin_file(kn);
+		kernfs_put(kn);
 	}
 }
 
 /**
- * kernfs_find_ns - find sysfs_dirent with the given name
- * @parent: sysfs_dirent to search under
+ * kernfs_find_ns - find kernfs_node with the given name
+ * @parent: kernfs_node to search under
  * @name: name to look for
  * @ns: the namespace tag to use
  *
- * Look for sysfs_dirent with name @name under @parent.  Returns pointer to
- * the found sysfs_dirent on success, %NULL on failure.
+ * Look for kernfs_node with name @name under @parent.  Returns pointer to
+ * the found kernfs_node on success, %NULL on failure.
  */
-static struct sysfs_dirent *kernfs_find_ns(struct sysfs_dirent *parent,
-					   const unsigned char *name,
-					   const void *ns)
+static struct kernfs_node *kernfs_find_ns(struct kernfs_node *parent,
+					  const unsigned char *name,
+					  const void *ns)
 {
 	struct rb_node *node = parent->s_dir.children.rb_node;
 	bool has_ns = kernfs_ns_enabled(parent);
@@ -552,42 +553,42 @@ static struct sysfs_dirent *kernfs_find_ns(struct sysfs_dirent *parent,
 
 	hash = sysfs_name_hash(name, ns);
 	while (node) {
-		struct sysfs_dirent *sd;
+		struct kernfs_node *kn;
 		int result;
 
-		sd = to_sysfs_dirent(node);
-		result = sysfs_name_compare(hash, name, ns, sd);
+		kn = rb_to_kn(node);
+		result = sysfs_name_compare(hash, name, ns, kn);
 		if (result < 0)
 			node = node->rb_left;
 		else if (result > 0)
 			node = node->rb_right;
 		else
-			return sd;
+			return kn;
 	}
 	return NULL;
 }
 
 /**
- * kernfs_find_and_get_ns - find and get sysfs_dirent with the given name
- * @parent: sysfs_dirent to search under
+ * kernfs_find_and_get_ns - find and get kernfs_node with the given name
+ * @parent: kernfs_node to search under
  * @name: name to look for
  * @ns: the namespace tag to use
  *
- * Look for sysfs_dirent with name @name under @parent and get a reference
+ * Look for kernfs_node with name @name under @parent and get a reference
  * if found.  This function may sleep and returns pointer to the found
- * sysfs_dirent on success, %NULL on failure.
+ * kernfs_node on success, %NULL on failure.
  */
-struct sysfs_dirent *kernfs_find_and_get_ns(struct sysfs_dirent *parent,
-					    const char *name, const void *ns)
+struct kernfs_node *kernfs_find_and_get_ns(struct kernfs_node *parent,
+					   const char *name, const void *ns)
 {
-	struct sysfs_dirent *sd;
+	struct kernfs_node *kn;
 
 	mutex_lock(&sysfs_mutex);
-	sd = kernfs_find_ns(parent, name, ns);
-	kernfs_get(sd);
+	kn = kernfs_find_ns(parent, name, ns);
+	kernfs_get(kn);
 	mutex_unlock(&sysfs_mutex);
 
-	return sd;
+	return kn;
 }
 EXPORT_SYMBOL_GPL(kernfs_find_and_get_ns);
 
@@ -601,7 +602,7 @@ EXPORT_SYMBOL_GPL(kernfs_find_and_get_ns);
 struct kernfs_root *kernfs_create_root(void *priv)
 {
 	struct kernfs_root *root;
-	struct sysfs_dirent *sd;
+	struct kernfs_node *kn;
 
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!root)
@@ -609,18 +610,18 @@ struct kernfs_root *kernfs_create_root(void *priv)
 
 	ida_init(&root->ino_ida);
 
-	sd = sysfs_new_dirent(root, "", S_IFDIR | S_IRUGO | S_IXUGO, SYSFS_DIR);
-	if (!sd) {
+	kn = sysfs_new_dirent(root, "", S_IFDIR | S_IRUGO | S_IXUGO, SYSFS_DIR);
+	if (!kn) {
 		ida_destroy(&root->ino_ida);
 		kfree(root);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	sd->s_flags &= ~SYSFS_FLAG_REMOVED;
-	sd->priv = priv;
-	sd->s_dir.root = root;
+	kn->s_flags &= ~SYSFS_FLAG_REMOVED;
+	kn->priv = priv;
+	kn->s_dir.root = root;
 
-	root->sd = sd;
+	root->kn = kn;
 
 	return root;
 }
@@ -634,7 +635,7 @@ struct kernfs_root *kernfs_create_root(void *priv)
  */
 void kernfs_destroy_root(struct kernfs_root *root)
 {
-	kernfs_remove(root->sd);	/* will also free @root */
+	kernfs_remove(root->kn);	/* will also free @root */
 }
 
 /**
@@ -646,33 +647,33 @@ void kernfs_destroy_root(struct kernfs_root *root)
  *
  * Returns the created node on success, ERR_PTR() value on failure.
  */
-struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
-					  const char *name, void *priv,
-					  const void *ns)
+struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
+					 const char *name, void *priv,
+					 const void *ns)
 {
 	umode_t mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
 	struct sysfs_addrm_cxt acxt;
-	struct sysfs_dirent *sd;
+	struct kernfs_node *kn;
 	int rc;
 
 	/* allocate */
-	sd = sysfs_new_dirent(kernfs_root(parent), name, mode, SYSFS_DIR);
-	if (!sd)
+	kn = sysfs_new_dirent(kernfs_root(parent), name, mode, SYSFS_DIR);
+	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
-	sd->s_dir.root = parent->s_dir.root;
-	sd->s_ns = ns;
-	sd->priv = priv;
+	kn->s_dir.root = parent->s_dir.root;
+	kn->s_ns = ns;
+	kn->priv = priv;
 
 	/* link in */
 	sysfs_addrm_start(&acxt);
-	rc = sysfs_add_one(&acxt, sd, parent);
+	rc = sysfs_add_one(&acxt, kn, parent);
 	sysfs_addrm_finish(&acxt);
 
 	if (!rc)
-		return sd;
+		return kn;
 
-	kernfs_put(sd);
+	kernfs_put(kn);
 	return ERR_PTR(rc);
 }
 
@@ -680,29 +681,28 @@ static struct dentry *sysfs_lookup(struct inode *dir, struct dentry *dentry,
 				   unsigned int flags)
 {
 	struct dentry *ret = NULL;
-	struct dentry *parent = dentry->d_parent;
-	struct sysfs_dirent *parent_sd = parent->d_fsdata;
-	struct sysfs_dirent *sd;
+	struct kernfs_node *parent = dentry->d_parent->d_fsdata;
+	struct kernfs_node *kn;
 	struct inode *inode;
 	const void *ns = NULL;
 
 	mutex_lock(&sysfs_mutex);
 
-	if (kernfs_ns_enabled(parent_sd))
+	if (kernfs_ns_enabled(parent))
 		ns = sysfs_info(dir->i_sb)->ns;
 
-	sd = kernfs_find_ns(parent_sd, dentry->d_name.name, ns);
+	kn = kernfs_find_ns(parent, dentry->d_name.name, ns);
 
 	/* no such entry */
-	if (!sd) {
+	if (!kn) {
 		ret = ERR_PTR(-ENOENT);
 		goto out_unlock;
 	}
-	kernfs_get(sd);
-	dentry->d_fsdata = sd;
+	kernfs_get(kn);
+	dentry->d_fsdata = kn;
 
 	/* attach dentry and inode */
-	inode = sysfs_get_inode(dir->i_sb, sd);
+	inode = sysfs_get_inode(dir->i_sb, kn);
 	if (!inode) {
 		ret = ERR_PTR(-ENOMEM);
 		goto out_unlock;
@@ -726,9 +726,9 @@ const struct inode_operations sysfs_dir_inode_operations = {
 	.listxattr	= sysfs_listxattr,
 };
 
-static struct sysfs_dirent *sysfs_leftmost_descendant(struct sysfs_dirent *pos)
+static struct kernfs_node *sysfs_leftmost_descendant(struct kernfs_node *pos)
 {
-	struct sysfs_dirent *last;
+	struct kernfs_node *last;
 
 	while (true) {
 		struct rb_node *rbn;
@@ -742,7 +742,7 @@ static struct sysfs_dirent *sysfs_leftmost_descendant(struct sysfs_dirent *pos)
 		if (!rbn)
 			break;
 
-		pos = to_sysfs_dirent(rbn);
+		pos = rb_to_kn(rbn);
 	}
 
 	return last;
@@ -751,14 +751,14 @@ static struct sysfs_dirent *sysfs_leftmost_descendant(struct sysfs_dirent *pos)
 /**
  * sysfs_next_descendant_post - find the next descendant for post-order walk
  * @pos: the current position (%NULL to initiate traversal)
- * @root: sysfs_dirent whose descendants to walk
+ * @root: kernfs_node whose descendants to walk
  *
  * Find the next descendant to visit for post-order traversal of @root's
  * descendants.  @root is included in the iteration and the last node to be
  * visited.
  */
-static struct sysfs_dirent *sysfs_next_descendant_post(struct sysfs_dirent *pos,
-						       struct sysfs_dirent *root)
+static struct kernfs_node *sysfs_next_descendant_post(struct kernfs_node *pos,
+						      struct kernfs_node *root)
 {
 	struct rb_node *rbn;
 
@@ -775,62 +775,62 @@ static struct sysfs_dirent *sysfs_next_descendant_post(struct sysfs_dirent *pos,
 	/* if there's an unvisited sibling, visit its leftmost descendant */
 	rbn = rb_next(&pos->s_rb);
 	if (rbn)
-		return sysfs_leftmost_descendant(to_sysfs_dirent(rbn));
+		return sysfs_leftmost_descendant(rb_to_kn(rbn));
 
 	/* no sibling left, visit parent */
 	return pos->s_parent;
 }
 
 static void __kernfs_remove(struct sysfs_addrm_cxt *acxt,
-			    struct sysfs_dirent *sd)
+			    struct kernfs_node *kn)
 {
-	struct sysfs_dirent *pos, *next;
+	struct kernfs_node *pos, *next;
 
-	if (!sd)
+	if (!kn)
 		return;
 
-	pr_debug("sysfs %s: removing\n", sd->s_name);
+	pr_debug("sysfs %s: removing\n", kn->s_name);
 
 	next = NULL;
 	do {
 		pos = next;
-		next = sysfs_next_descendant_post(pos, sd);
+		next = sysfs_next_descendant_post(pos, kn);
 		if (pos)
 			sysfs_remove_one(acxt, pos);
 	} while (next);
 }
 
 /**
- * kernfs_remove - remove a sysfs_dirent recursively
- * @sd: the sysfs_dirent to remove
+ * kernfs_remove - remove a kernfs_node recursively
+ * @kn: the kernfs_node to remove
  *
- * Remove @sd along with all its subdirectories and files.
+ * Remove @kn along with all its subdirectories and files.
  */
-void kernfs_remove(struct sysfs_dirent *sd)
+void kernfs_remove(struct kernfs_node *kn)
 {
 	struct sysfs_addrm_cxt acxt;
 
 	sysfs_addrm_start(&acxt);
-	__kernfs_remove(&acxt, sd);
+	__kernfs_remove(&acxt, kn);
 	sysfs_addrm_finish(&acxt);
 }
 
 /**
- * kernfs_remove_by_name_ns - find a sysfs_dirent by name and remove it
- * @dir_sd: parent of the target
- * @name: name of the sysfs_dirent to remove
- * @ns: namespace tag of the sysfs_dirent to remove
+ * kernfs_remove_by_name_ns - find a kernfs_node by name and remove it
+ * @parent: parent of the target
+ * @name: name of the kernfs_node to remove
+ * @ns: namespace tag of the kernfs_node to remove
  *
- * Look for the sysfs_dirent with @name and @ns under @dir_sd and remove
- * it.  Returns 0 on success, -ENOENT if such entry doesn't exist.
+ * Look for the kernfs_node with @name and @ns under @parent and remove it.
+ * Returns 0 on success, -ENOENT if such entry doesn't exist.
  */
-int kernfs_remove_by_name_ns(struct sysfs_dirent *dir_sd, const char *name,
+int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 			     const void *ns)
 {
 	struct sysfs_addrm_cxt acxt;
-	struct sysfs_dirent *sd;
+	struct kernfs_node *kn;
 
-	if (!dir_sd) {
+	if (!parent) {
 		WARN(1, KERN_WARNING "sysfs: can not remove '%s', no directory\n",
 			name);
 		return -ENOENT;
@@ -838,13 +838,13 @@ int kernfs_remove_by_name_ns(struct sysfs_dirent *dir_sd, const char *name,
 
 	sysfs_addrm_start(&acxt);
 
-	sd = kernfs_find_ns(dir_sd, name, ns);
-	if (sd)
-		__kernfs_remove(&acxt, sd);
+	kn = kernfs_find_ns(parent, name, ns);
+	if (kn)
+		__kernfs_remove(&acxt, kn);
 
 	sysfs_addrm_finish(&acxt);
 
-	if (sd)
+	if (kn)
 		return 0;
 	else
 		return -ENOENT;
@@ -852,12 +852,12 @@ int kernfs_remove_by_name_ns(struct sysfs_dirent *dir_sd, const char *name,
 
 /**
  * kernfs_rename_ns - move and rename a kernfs_node
- * @sd: target node
+ * @kn: target node
  * @new_parent: new parent to put @sd under
  * @new_name: new name
  * @new_ns: new namespace tag
  */
-int kernfs_rename_ns(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
+int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 		     const char *new_name, const void *new_ns)
 {
 	int error;
@@ -865,35 +865,35 @@ int kernfs_rename_ns(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
 	mutex_lock(&sysfs_mutex);
 
 	error = 0;
-	if ((sd->s_parent == new_parent) && (sd->s_ns == new_ns) &&
-	    (strcmp(sd->s_name, new_name) == 0))
+	if ((kn->s_parent == new_parent) && (kn->s_ns == new_ns) &&
+	    (strcmp(kn->s_name, new_name) == 0))
 		goto out;	/* nothing to rename */
 
 	error = -EEXIST;
 	if (kernfs_find_ns(new_parent, new_name, new_ns))
 		goto out;
 
-	/* rename sysfs_dirent */
-	if (strcmp(sd->s_name, new_name) != 0) {
+	/* rename kernfs_node */
+	if (strcmp(kn->s_name, new_name) != 0) {
 		error = -ENOMEM;
 		new_name = kstrdup(new_name, GFP_KERNEL);
 		if (!new_name)
 			goto out;
 
-		kfree(sd->s_name);
-		sd->s_name = new_name;
+		kfree(kn->s_name);
+		kn->s_name = new_name;
 	}
 
 	/*
 	 * Move to the appropriate place in the appropriate directories rbtree.
 	 */
-	sysfs_unlink_sibling(sd);
+	sysfs_unlink_sibling(kn);
 	kernfs_get(new_parent);
-	kernfs_put(sd->s_parent);
-	sd->s_ns = new_ns;
-	sd->s_hash = sysfs_name_hash(sd->s_name, sd->s_ns);
-	sd->s_parent = new_parent;
-	sysfs_link_sibling(sd);
+	kernfs_put(kn->s_parent);
+	kn->s_ns = new_ns;
+	kn->s_hash = sysfs_name_hash(kn->s_name, kn->s_ns);
+	kn->s_parent = new_parent;
+	sysfs_link_sibling(kn);
 
 	error = 0;
  out:
@@ -902,9 +902,9 @@ int kernfs_rename_ns(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
 }
 
 /* Relationship between s_mode and the DT_xxx types */
-static inline unsigned char dt_type(struct sysfs_dirent *sd)
+static inline unsigned char dt_type(struct kernfs_node *kn)
 {
-	return (sd->s_mode >> 12) & 15;
+	return (kn->s_mode >> 12) & 15;
 }
 
 static int sysfs_dir_release(struct inode *inode, struct file *filp)
@@ -913,21 +913,21 @@ static int sysfs_dir_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static struct sysfs_dirent *sysfs_dir_pos(const void *ns,
-	struct sysfs_dirent *parent_sd,	loff_t hash, struct sysfs_dirent *pos)
+static struct kernfs_node *sysfs_dir_pos(const void *ns,
+	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos)
 {
 	if (pos) {
 		int valid = !(pos->s_flags & SYSFS_FLAG_REMOVED) &&
-			pos->s_parent == parent_sd &&
+			pos->s_parent == parent &&
 			hash == pos->s_hash;
 		kernfs_put(pos);
 		if (!valid)
 			pos = NULL;
 	}
 	if (!pos && (hash > 1) && (hash < INT_MAX)) {
-		struct rb_node *node = parent_sd->s_dir.children.rb_node;
+		struct rb_node *node = parent->s_dir.children.rb_node;
 		while (node) {
-			pos = to_sysfs_dirent(node);
+			pos = rb_to_kn(node);
 
 			if (hash < pos->s_hash)
 				node = node->rb_left;
@@ -943,22 +943,22 @@ static struct sysfs_dirent *sysfs_dir_pos(const void *ns,
 		if (!node)
 			pos = NULL;
 		else
-			pos = to_sysfs_dirent(node);
+			pos = rb_to_kn(node);
 	}
 	return pos;
 }
 
-static struct sysfs_dirent *sysfs_dir_next_pos(const void *ns,
-	struct sysfs_dirent *parent_sd,	ino_t ino, struct sysfs_dirent *pos)
+static struct kernfs_node *sysfs_dir_next_pos(const void *ns,
+	struct kernfs_node *parent, ino_t ino, struct kernfs_node *pos)
 {
-	pos = sysfs_dir_pos(ns, parent_sd, ino, pos);
+	pos = sysfs_dir_pos(ns, parent, ino, pos);
 	if (pos)
 		do {
 			struct rb_node *node = rb_next(&pos->s_rb);
 			if (!node)
 				pos = NULL;
 			else
-				pos = to_sysfs_dirent(node);
+				pos = rb_to_kn(node);
 		} while (pos && pos->s_ns != ns);
 	return pos;
 }
@@ -966,20 +966,20 @@ static struct sysfs_dirent *sysfs_dir_next_pos(const void *ns,
 static int sysfs_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct dentry *dentry = file->f_path.dentry;
-	struct sysfs_dirent *parent_sd = dentry->d_fsdata;
-	struct sysfs_dirent *pos = file->private_data;
+	struct kernfs_node *parent = dentry->d_fsdata;
+	struct kernfs_node *pos = file->private_data;
 	const void *ns = NULL;
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 	mutex_lock(&sysfs_mutex);
 
-	if (kernfs_ns_enabled(parent_sd))
+	if (kernfs_ns_enabled(parent))
 		ns = sysfs_info(dentry->d_sb)->ns;
 
-	for (pos = sysfs_dir_pos(ns, parent_sd, ctx->pos, pos);
+	for (pos = sysfs_dir_pos(ns, parent, ctx->pos, pos);
 	     pos;
-	     pos = sysfs_dir_next_pos(ns, parent_sd, ctx->pos, pos)) {
+	     pos = sysfs_dir_next_pos(ns, parent, ctx->pos, pos)) {
 		const char *name = pos->s_name;
 		unsigned int type = dt_type(pos);
 		int len = strlen(name);
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index fa05315..1bf07de 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -19,9 +19,9 @@
 
 /*
  * There's one sysfs_open_file for each open file and one sysfs_open_dirent
- * for each sysfs_dirent with one or more open files.
+ * for each kernfs_node with one or more open files.
  *
- * sysfs_dirent->s_attr.open points to sysfs_open_dirent.  s_attr.open is
+ * kernfs_node->s_attr.open points to sysfs_open_dirent.  s_attr.open is
  * protected by sysfs_open_dirent_lock.
  *
  * filp->private_data points to seq_file whose ->private points to
@@ -44,14 +44,14 @@ static struct sysfs_open_file *sysfs_of(struct file *file)
 }
 
 /*
- * Determine the kernfs_ops for the given sysfs_dirent.  This function must
+ * Determine the kernfs_ops for the given kernfs_node.  This function must
  * be called while holding an active reference.
  */
-static const struct kernfs_ops *kernfs_ops(struct sysfs_dirent *sd)
+static const struct kernfs_ops *kernfs_ops(struct kernfs_node *kn)
 {
-	if (sd->s_flags & SYSFS_FLAG_LOCKDEP)
-		lockdep_assert_held(sd);
-	return sd->s_attr.ops;
+	if (kn->s_flags & SYSFS_FLAG_LOCKDEP)
+		lockdep_assert_held(kn);
+	return kn->s_attr.ops;
 }
 
 static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
@@ -64,10 +64,10 @@ static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
 	 * the ops aren't called concurrently for the same open file.
 	 */
 	mutex_lock(&of->mutex);
-	if (!sysfs_get_active(of->sd))
+	if (!sysfs_get_active(of->kn))
 		return ERR_PTR(-ENODEV);
 
-	ops = kernfs_ops(of->sd);
+	ops = kernfs_ops(of->kn);
 	if (ops->seq_start) {
 		return ops->seq_start(sf, ppos);
 	} else {
@@ -82,7 +82,7 @@ static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
 static void *kernfs_seq_next(struct seq_file *sf, void *v, loff_t *ppos)
 {
 	struct sysfs_open_file *of = sf->private;
-	const struct kernfs_ops *ops = kernfs_ops(of->sd);
+	const struct kernfs_ops *ops = kernfs_ops(of->kn);
 
 	if (ops->seq_next) {
 		return ops->seq_next(sf, v, ppos);
@@ -99,12 +99,12 @@ static void *kernfs_seq_next(struct seq_file *sf, void *v, loff_t *ppos)
 static void kernfs_seq_stop(struct seq_file *sf, void *v)
 {
 	struct sysfs_open_file *of = sf->private;
-	const struct kernfs_ops *ops = kernfs_ops(of->sd);
+	const struct kernfs_ops *ops = kernfs_ops(of->kn);
 
 	if (ops->seq_stop)
 		ops->seq_stop(sf, v);
 
-	sysfs_put_active(of->sd);
+	sysfs_put_active(of->kn);
 	mutex_unlock(&of->mutex);
 }
 
@@ -112,9 +112,9 @@ static int kernfs_seq_show(struct seq_file *sf, void *v)
 {
 	struct sysfs_open_file *of = sf->private;
 
-	of->event = atomic_read(&of->sd->s_attr.open->event);
+	of->event = atomic_read(&of->kn->s_attr.open->event);
 
-	return of->sd->s_attr.ops->seq_show(sf, v);
+	return of->kn->s_attr.ops->seq_show(sf, v);
 }
 
 static const struct seq_operations kernfs_seq_ops = {
@@ -147,19 +147,19 @@ static ssize_t kernfs_file_direct_read(struct sysfs_open_file *of,
 	 * the ops aren't called concurrently for the same open file.
 	 */
 	mutex_lock(&of->mutex);
-	if (!sysfs_get_active(of->sd)) {
+	if (!sysfs_get_active(of->kn)) {
 		len = -ENODEV;
 		mutex_unlock(&of->mutex);
 		goto out_free;
 	}
 
-	ops = kernfs_ops(of->sd);
+	ops = kernfs_ops(of->kn);
 	if (ops->read)
 		len = ops->read(of, buf, len, *ppos);
 	else
 		len = -EINVAL;
 
-	sysfs_put_active(of->sd);
+	sysfs_put_active(of->kn);
 	mutex_unlock(&of->mutex);
 
 	if (len < 0)
@@ -189,7 +189,7 @@ static ssize_t kernfs_file_read(struct file *file, char __user *user_buf,
 {
 	struct sysfs_open_file *of = sysfs_of(file);
 
-	if (of->sd->s_flags & SYSFS_FLAG_HAS_SEQ_SHOW)
+	if (of->kn->s_flags & SYSFS_FLAG_HAS_SEQ_SHOW)
 		return seq_read(file, user_buf, count, ppos);
 	else
 		return kernfs_file_direct_read(of, user_buf, count, ppos);
@@ -234,19 +234,19 @@ static ssize_t kernfs_file_write(struct file *file, const char __user *user_buf,
 	 * the ops aren't called concurrently for the same open file.
 	 */
 	mutex_lock(&of->mutex);
-	if (!sysfs_get_active(of->sd)) {
+	if (!sysfs_get_active(of->kn)) {
 		mutex_unlock(&of->mutex);
 		len = -ENODEV;
 		goto out_free;
 	}
 
-	ops = kernfs_ops(of->sd);
+	ops = kernfs_ops(of->kn);
 	if (ops->write)
 		len = ops->write(of, buf, len, *ppos);
 	else
 		len = -EINVAL;
 
-	sysfs_put_active(of->sd);
+	sysfs_put_active(of->kn);
 	mutex_unlock(&of->mutex);
 
 	if (len > 0)
@@ -264,13 +264,13 @@ static void kernfs_vma_open(struct vm_area_struct *vma)
 	if (!of->vm_ops)
 		return;
 
-	if (!sysfs_get_active(of->sd))
+	if (!sysfs_get_active(of->kn))
 		return;
 
 	if (of->vm_ops->open)
 		of->vm_ops->open(vma);
 
-	sysfs_put_active(of->sd);
+	sysfs_put_active(of->kn);
 }
 
 static int kernfs_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
@@ -282,14 +282,14 @@ static int kernfs_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (!of->vm_ops)
 		return VM_FAULT_SIGBUS;
 
-	if (!sysfs_get_active(of->sd))
+	if (!sysfs_get_active(of->kn))
 		return VM_FAULT_SIGBUS;
 
 	ret = VM_FAULT_SIGBUS;
 	if (of->vm_ops->fault)
 		ret = of->vm_ops->fault(vma, vmf);
 
-	sysfs_put_active(of->sd);
+	sysfs_put_active(of->kn);
 	return ret;
 }
 
@@ -303,7 +303,7 @@ static int kernfs_vma_page_mkwrite(struct vm_area_struct *vma,
 	if (!of->vm_ops)
 		return VM_FAULT_SIGBUS;
 
-	if (!sysfs_get_active(of->sd))
+	if (!sysfs_get_active(of->kn))
 		return VM_FAULT_SIGBUS;
 
 	ret = 0;
@@ -312,7 +312,7 @@ static int kernfs_vma_page_mkwrite(struct vm_area_struct *vma,
 	else
 		file_update_time(file);
 
-	sysfs_put_active(of->sd);
+	sysfs_put_active(of->kn);
 	return ret;
 }
 
@@ -326,14 +326,14 @@ static int kernfs_vma_access(struct vm_area_struct *vma, unsigned long addr,
 	if (!of->vm_ops)
 		return -EINVAL;
 
-	if (!sysfs_get_active(of->sd))
+	if (!sysfs_get_active(of->kn))
 		return -EINVAL;
 
 	ret = -EINVAL;
 	if (of->vm_ops->access)
 		ret = of->vm_ops->access(vma, addr, buf, len, write);
 
-	sysfs_put_active(of->sd);
+	sysfs_put_active(of->kn);
 	return ret;
 }
 
@@ -348,14 +348,14 @@ static int kernfs_vma_set_policy(struct vm_area_struct *vma,
 	if (!of->vm_ops)
 		return 0;
 
-	if (!sysfs_get_active(of->sd))
+	if (!sysfs_get_active(of->kn))
 		return -EINVAL;
 
 	ret = 0;
 	if (of->vm_ops->set_policy)
 		ret = of->vm_ops->set_policy(vma, new);
 
-	sysfs_put_active(of->sd);
+	sysfs_put_active(of->kn);
 	return ret;
 }
 
@@ -369,14 +369,14 @@ static struct mempolicy *kernfs_vma_get_policy(struct vm_area_struct *vma,
 	if (!of->vm_ops)
 		return vma->vm_policy;
 
-	if (!sysfs_get_active(of->sd))
+	if (!sysfs_get_active(of->kn))
 		return vma->vm_policy;
 
 	pol = vma->vm_policy;
 	if (of->vm_ops->get_policy)
 		pol = of->vm_ops->get_policy(vma, addr);
 
-	sysfs_put_active(of->sd);
+	sysfs_put_active(of->kn);
 	return pol;
 }
 
@@ -391,14 +391,14 @@ static int kernfs_vma_migrate(struct vm_area_struct *vma,
 	if (!of->vm_ops)
 		return 0;
 
-	if (!sysfs_get_active(of->sd))
+	if (!sysfs_get_active(of->kn))
 		return 0;
 
 	ret = 0;
 	if (of->vm_ops->migrate)
 		ret = of->vm_ops->migrate(vma, from, to, flags);
 
-	sysfs_put_active(of->sd);
+	sysfs_put_active(of->kn);
 	return ret;
 }
 #endif
@@ -428,16 +428,16 @@ static int kernfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	 * without grabbing @of->mutex by testing HAS_MMAP flag.  See the
 	 * comment in kernfs_file_open() for more details.
 	 */
-	if (!(of->sd->s_flags & SYSFS_FLAG_HAS_MMAP))
+	if (!(of->kn->s_flags & SYSFS_FLAG_HAS_MMAP))
 		return -ENODEV;
 
 	mutex_lock(&of->mutex);
 
 	rc = -ENODEV;
-	if (!sysfs_get_active(of->sd))
+	if (!sysfs_get_active(of->kn))
 		goto out_unlock;
 
-	ops = kernfs_ops(of->sd);
+	ops = kernfs_ops(of->kn);
 	rc = ops->mmap(of, vma);
 
 	/*
@@ -465,7 +465,7 @@ static int kernfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	of->vm_ops = vma->vm_ops;
 	vma->vm_ops = &kernfs_vm_ops;
 out_put:
-	sysfs_put_active(of->sd);
+	sysfs_put_active(of->kn);
 out_unlock:
 	mutex_unlock(&of->mutex);
 
@@ -474,10 +474,10 @@ out_unlock:
 
 /**
  *	sysfs_get_open_dirent - get or create sysfs_open_dirent
- *	@sd: target sysfs_dirent
+ *	@kn: target kernfs_node
  *	@of: sysfs_open_file for this instance of open
  *
- *	If @sd->s_attr.open exists, increment its reference count;
+ *	If @kn->s_attr.open exists, increment its reference count;
  *	otherwise, create one.  @of is chained to the files list.
  *
  *	LOCKING:
@@ -486,7 +486,7 @@ out_unlock:
  *	RETURNS:
  *	0 on success, -errno on failure.
  */
-static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
+static int sysfs_get_open_dirent(struct kernfs_node *kn,
 				 struct sysfs_open_file *of)
 {
 	struct sysfs_open_dirent *od, *new_od = NULL;
@@ -495,12 +495,12 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 	mutex_lock(&sysfs_open_file_mutex);
 	spin_lock_irq(&sysfs_open_dirent_lock);
 
-	if (!sd->s_attr.open && new_od) {
-		sd->s_attr.open = new_od;
+	if (!kn->s_attr.open && new_od) {
+		kn->s_attr.open = new_od;
 		new_od = NULL;
 	}
 
-	od = sd->s_attr.open;
+	od = kn->s_attr.open;
 	if (od) {
 		atomic_inc(&od->refcnt);
 		list_add_tail(&of->list, &od->files);
@@ -528,19 +528,19 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 
 /**
  *	sysfs_put_open_dirent - put sysfs_open_dirent
- *	@sd: target sysfs_dirent
+ *	@kn: target kernfs_nodet
  *	@of: associated sysfs_open_file
  *
- *	Put @sd->s_attr.open and unlink @of from the files list.  If
+ *	Put @kn->s_attr.open and unlink @of from the files list.  If
  *	reference count reaches zero, disassociate and free it.
  *
  *	LOCKING:
  *	None.
  */
-static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
+static void sysfs_put_open_dirent(struct kernfs_node *kn,
 				  struct sysfs_open_file *of)
 {
-	struct sysfs_open_dirent *od = sd->s_attr.open;
+	struct sysfs_open_dirent *od = kn->s_attr.open;
 	unsigned long flags;
 
 	mutex_lock(&sysfs_open_file_mutex);
@@ -550,7 +550,7 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 		list_del(&of->list);
 
 	if (atomic_dec_and_test(&od->refcnt))
-		sd->s_attr.open = NULL;
+		kn->s_attr.open = NULL;
 	else
 		od = NULL;
 
@@ -562,16 +562,16 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 
 static int kernfs_file_open(struct inode *inode, struct file *file)
 {
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
+	struct kernfs_node *kn = file->f_path.dentry->d_fsdata;
 	const struct kernfs_ops *ops;
 	struct sysfs_open_file *of;
 	bool has_read, has_write, has_mmap;
 	int error = -EACCES;
 
-	if (!sysfs_get_active(attr_sd))
+	if (!sysfs_get_active(kn))
 		return -ENODEV;
 
-	ops = kernfs_ops(attr_sd);
+	ops = kernfs_ops(kn);
 
 	has_read = ops->seq_show || ops->read || ops->mmap;
 	has_write = ops->write || ops->mmap;
@@ -612,7 +612,7 @@ static int kernfs_file_open(struct inode *inode, struct file *file)
 	else
 		mutex_init(&of->mutex);
 
-	of->sd = attr_sd;
+	of->kn = kn;
 	of->file = file;
 
 	/*
@@ -634,12 +634,12 @@ static int kernfs_file_open(struct inode *inode, struct file *file)
 		file->f_mode |= FMODE_PWRITE;
 
 	/* make sure we have open dirent struct */
-	error = sysfs_get_open_dirent(attr_sd, of);
+	error = sysfs_get_open_dirent(kn, of);
 	if (error)
 		goto err_close;
 
 	/* open succeeded, put active references */
-	sysfs_put_active(attr_sd);
+	sysfs_put_active(kn);
 	return 0;
 
 err_close:
@@ -647,32 +647,32 @@ err_close:
 err_free:
 	kfree(of);
 err_out:
-	sysfs_put_active(attr_sd);
+	sysfs_put_active(kn);
 	return error;
 }
 
 static int kernfs_file_release(struct inode *inode, struct file *filp)
 {
-	struct sysfs_dirent *sd = filp->f_path.dentry->d_fsdata;
+	struct kernfs_node *kn = filp->f_path.dentry->d_fsdata;
 	struct sysfs_open_file *of = sysfs_of(filp);
 
-	sysfs_put_open_dirent(sd, of);
+	sysfs_put_open_dirent(kn, of);
 	seq_release(inode, filp);
 	kfree(of);
 
 	return 0;
 }
 
-void sysfs_unmap_bin_file(struct sysfs_dirent *sd)
+void sysfs_unmap_bin_file(struct kernfs_node *kn)
 {
 	struct sysfs_open_dirent *od;
 	struct sysfs_open_file *of;
 
-	if (!(sd->s_flags & SYSFS_FLAG_HAS_MMAP))
+	if (!(kn->s_flags & SYSFS_FLAG_HAS_MMAP))
 		return;
 
 	spin_lock_irq(&sysfs_open_dirent_lock);
-	od = sd->s_attr.open;
+	od = kn->s_attr.open;
 	if (od)
 		atomic_inc(&od->refcnt);
 	spin_unlock_irq(&sysfs_open_dirent_lock);
@@ -686,7 +686,7 @@ void sysfs_unmap_bin_file(struct sysfs_dirent *sd)
 	}
 	mutex_unlock(&sysfs_open_file_mutex);
 
-	sysfs_put_open_dirent(sd, NULL);
+	sysfs_put_open_dirent(kn, NULL);
 }
 
 /* Sysfs attribute files are pollable.  The idea is that you read
@@ -705,16 +705,16 @@ void sysfs_unmap_bin_file(struct sysfs_dirent *sd)
 static unsigned int kernfs_file_poll(struct file *filp, poll_table *wait)
 {
 	struct sysfs_open_file *of = sysfs_of(filp);
-	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
-	struct sysfs_open_dirent *od = attr_sd->s_attr.open;
+	struct kernfs_node *kn = filp->f_path.dentry->d_fsdata;
+	struct sysfs_open_dirent *od = kn->s_attr.open;
 
 	/* need parent for the kobj, grab both */
-	if (!sysfs_get_active(attr_sd))
+	if (!sysfs_get_active(kn))
 		goto trigger;
 
 	poll_wait(filp, &od->poll, wait);
 
-	sysfs_put_active(attr_sd);
+	sysfs_put_active(kn);
 
 	if (of->event != atomic_read(&od->event))
 		goto trigger;
@@ -727,19 +727,19 @@ static unsigned int kernfs_file_poll(struct file *filp, poll_table *wait)
 
 /**
  * kernfs_notify - notify a kernfs file
- * @sd: file to notify
+ * @kn: file to notify
  *
- * Notify @sd such that poll(2) on @sd wakes up.
+ * Notify @kn such that poll(2) on @kn wakes up.
  */
-void kernfs_notify(struct sysfs_dirent *sd)
+void kernfs_notify(struct kernfs_node *kn)
 {
 	struct sysfs_open_dirent *od;
 	unsigned long flags;
 
 	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
 
-	if (!WARN_ON(sysfs_type(sd) != SYSFS_KOBJ_ATTR)) {
-		od = sd->s_attr.open;
+	if (!WARN_ON(sysfs_type(kn) != SYSFS_KOBJ_ATTR)) {
+		od = kn->s_attr.open;
 		if (od) {
 			atomic_inc(&od->event);
 			wake_up_interruptible(&od->poll);
@@ -773,51 +773,51 @@ const struct file_operations kernfs_file_operations = {
  *
  * Returns the created node on success, ERR_PTR() value on error.
  */
-struct sysfs_dirent *kernfs_create_file_ns_key(struct sysfs_dirent *parent,
-					       const char *name,
-					       umode_t mode, loff_t size,
-					       const struct kernfs_ops *ops,
-					       void *priv, const void *ns,
-					       struct lock_class_key *key)
+struct kernfs_node *kernfs_create_file_ns_key(struct kernfs_node *parent,
+					      const char *name,
+					      umode_t mode, loff_t size,
+					      const struct kernfs_ops *ops,
+					      void *priv, const void *ns,
+					      struct lock_class_key *key)
 {
 	struct sysfs_addrm_cxt acxt;
-	struct sysfs_dirent *sd;
+	struct kernfs_node *kn;
 	int rc;
 
-	sd = sysfs_new_dirent(kernfs_root(parent), name,
+	kn = sysfs_new_dirent(kernfs_root(parent), name,
 			      (mode & S_IALLUGO) | S_IFREG, SYSFS_KOBJ_ATTR);
-	if (!sd)
+	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
-	sd->s_attr.ops = ops;
-	sd->s_attr.size = size;
-	sd->s_ns = ns;
-	sd->priv = priv;
+	kn->s_attr.ops = ops;
+	kn->s_attr.size = size;
+	kn->s_ns = ns;
+	kn->priv = priv;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	if (key) {
-		lockdep_init_map(&sd->dep_map, "s_active", key, 0);
-		sd->s_flags |= SYSFS_FLAG_LOCKDEP;
+		lockdep_init_map(&kn->dep_map, "s_active", key, 0);
+		kn->s_flags |= SYSFS_FLAG_LOCKDEP;
 	}
 #endif
 
 	/*
-	 * sd->s_attr.ops is accesible only while holding active ref.  We
+	 * kn->s_attr.ops is accesible only while holding active ref.  We
 	 * need to know whether some ops are implemented outside active
 	 * ref.  Cache their existence in flags.
 	 */
 	if (ops->seq_show)
-		sd->s_flags |= SYSFS_FLAG_HAS_SEQ_SHOW;
+		kn->s_flags |= SYSFS_FLAG_HAS_SEQ_SHOW;
 	if (ops->mmap)
-		sd->s_flags |= SYSFS_FLAG_HAS_MMAP;
+		kn->s_flags |= SYSFS_FLAG_HAS_MMAP;
 
 	sysfs_addrm_start(&acxt);
-	rc = sysfs_add_one(&acxt, sd, parent);
+	rc = sysfs_add_one(&acxt, kn, parent);
 	sysfs_addrm_finish(&acxt);
 
 	if (rc) {
-		kernfs_put(sd);
+		kernfs_put(kn);
 		return ERR_PTR(rc);
 	}
-	return sd;
+	return kn;
 }
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 18ad431..9e74eed 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -46,36 +46,36 @@ void __init sysfs_inode_init(void)
 		panic("failed to init sysfs_backing_dev_info");
 }
 
-static struct sysfs_inode_attrs *sysfs_inode_attrs(struct sysfs_dirent *sd)
+static struct sysfs_inode_attrs *sysfs_inode_attrs(struct kernfs_node *kn)
 {
 	struct iattr *iattrs;
 
-	if (sd->s_iattr)
-		return sd->s_iattr;
+	if (kn->s_iattr)
+		return kn->s_iattr;
 
-	sd->s_iattr = kzalloc(sizeof(struct sysfs_inode_attrs), GFP_KERNEL);
-	if (!sd->s_iattr)
+	kn->s_iattr = kzalloc(sizeof(struct sysfs_inode_attrs), GFP_KERNEL);
+	if (!kn->s_iattr)
 		return NULL;
-	iattrs = &sd->s_iattr->ia_iattr;
+	iattrs = &kn->s_iattr->ia_iattr;
 
 	/* assign default attributes */
-	iattrs->ia_mode = sd->s_mode;
+	iattrs->ia_mode = kn->s_mode;
 	iattrs->ia_uid = GLOBAL_ROOT_UID;
 	iattrs->ia_gid = GLOBAL_ROOT_GID;
 	iattrs->ia_atime = iattrs->ia_mtime = iattrs->ia_ctime = CURRENT_TIME;
 
-	simple_xattrs_init(&sd->s_iattr->xattrs);
+	simple_xattrs_init(&kn->s_iattr->xattrs);
 
-	return sd->s_iattr;
+	return kn->s_iattr;
 }
 
-static int __kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr)
+static int __kernfs_setattr(struct kernfs_node *kn, const struct iattr *iattr)
 {
 	struct sysfs_inode_attrs *attrs;
 	struct iattr *iattrs;
 	unsigned int ia_valid = iattr->ia_valid;
 
-	attrs = sysfs_inode_attrs(sd);
+	attrs = sysfs_inode_attrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
@@ -93,24 +93,24 @@ static int __kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr)
 		iattrs->ia_ctime = iattr->ia_ctime;
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = iattr->ia_mode;
-		iattrs->ia_mode = sd->s_mode = mode;
+		iattrs->ia_mode = kn->s_mode = mode;
 	}
 	return 0;
 }
 
 /**
  * kernfs_setattr - set iattr on a node
- * @sd: target node
+ * @kn: target node
  * @iattr: iattr to set
  *
  * Returns 0 on success, -errno on failure.
  */
-int kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr)
+int kernfs_setattr(struct kernfs_node *kn, const struct iattr *iattr)
 {
 	int ret;
 
 	mutex_lock(&sysfs_mutex);
-	ret = __kernfs_setattr(sd, iattr);
+	ret = __kernfs_setattr(kn, iattr);
 	mutex_unlock(&sysfs_mutex);
 	return ret;
 }
@@ -118,10 +118,10 @@ int kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr)
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr)
 {
 	struct inode *inode = dentry->d_inode;
-	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct kernfs_node *kn = dentry->d_fsdata;
 	int error;
 
-	if (!sd)
+	if (!kn)
 		return -EINVAL;
 
 	mutex_lock(&sysfs_mutex);
@@ -129,7 +129,7 @@ int sysfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	if (error)
 		goto out;
 
-	error = __kernfs_setattr(sd, iattr);
+	error = __kernfs_setattr(kn, iattr);
 	if (error)
 		goto out;
 
@@ -141,14 +141,14 @@ out:
 	return error;
 }
 
-static int sysfs_sd_setsecdata(struct sysfs_dirent *sd, void **secdata,
+static int sysfs_sd_setsecdata(struct kernfs_node *kn, void **secdata,
 			       u32 *secdata_len)
 {
 	struct sysfs_inode_attrs *attrs;
 	void *old_secdata;
 	size_t old_secdata_len;
 
-	attrs = sysfs_inode_attrs(sd);
+	attrs = sysfs_inode_attrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
@@ -166,13 +166,13 @@ static int sysfs_sd_setsecdata(struct sysfs_dirent *sd, void **secdata,
 int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags)
 {
-	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct kernfs_node *kn = dentry->d_fsdata;
 	struct sysfs_inode_attrs *attrs;
 	void *secdata;
 	int error;
 	u32 secdata_len = 0;
 
-	attrs = sysfs_inode_attrs(sd);
+	attrs = sysfs_inode_attrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
@@ -188,7 +188,7 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 			return error;
 
 		mutex_lock(&sysfs_mutex);
-		error = sysfs_sd_setsecdata(sd, &secdata, &secdata_len);
+		error = sysfs_sd_setsecdata(kn, &secdata, &secdata_len);
 		mutex_unlock(&sysfs_mutex);
 
 		if (secdata)
@@ -204,10 +204,10 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 
 int sysfs_removexattr(struct dentry *dentry, const char *name)
 {
-	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct kernfs_node *kn = dentry->d_fsdata;
 	struct sysfs_inode_attrs *attrs;
 
-	attrs = sysfs_inode_attrs(sd);
+	attrs = sysfs_inode_attrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
@@ -217,10 +217,10 @@ int sysfs_removexattr(struct dentry *dentry, const char *name)
 ssize_t sysfs_getxattr(struct dentry *dentry, const char *name, void *buf,
 		       size_t size)
 {
-	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct kernfs_node *kn = dentry->d_fsdata;
 	struct sysfs_inode_attrs *attrs;
 
-	attrs = sysfs_inode_attrs(sd);
+	attrs = sysfs_inode_attrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
@@ -229,10 +229,10 @@ ssize_t sysfs_getxattr(struct dentry *dentry, const char *name, void *buf,
 
 ssize_t sysfs_listxattr(struct dentry *dentry, char *buf, size_t size)
 {
-	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct kernfs_node *kn = dentry->d_fsdata;
 	struct sysfs_inode_attrs *attrs;
 
-	attrs = sysfs_inode_attrs(sd);
+	attrs = sysfs_inode_attrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
@@ -254,57 +254,58 @@ static inline void set_inode_attr(struct inode *inode, struct iattr *iattr)
 	inode->i_ctime = iattr->ia_ctime;
 }
 
-static void sysfs_refresh_inode(struct sysfs_dirent *sd, struct inode *inode)
+static void sysfs_refresh_inode(struct kernfs_node *kn, struct inode *inode)
 {
-	struct sysfs_inode_attrs *attrs = sd->s_iattr;
+	struct sysfs_inode_attrs *attrs = kn->s_iattr;
 
-	inode->i_mode = sd->s_mode;
+	inode->i_mode = kn->s_mode;
 	if (attrs) {
-		/* sysfs_dirent has non-default attributes
-		 * get them from persistent copy in sysfs_dirent
+		/*
+		 * kernfs_node has non-default attributes get them from
+		 * persistent copy in kernfs_node.
 		 */
 		set_inode_attr(inode, &attrs->ia_iattr);
 		security_inode_notifysecctx(inode, attrs->ia_secdata,
 					    attrs->ia_secdata_len);
 	}
 
-	if (sysfs_type(sd) == SYSFS_DIR)
-		set_nlink(inode, sd->s_dir.subdirs + 2);
+	if (sysfs_type(kn) == SYSFS_DIR)
+		set_nlink(inode, kn->s_dir.subdirs + 2);
 }
 
 int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat)
 {
-	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct kernfs_node *kn = dentry->d_fsdata;
 	struct inode *inode = dentry->d_inode;
 
 	mutex_lock(&sysfs_mutex);
-	sysfs_refresh_inode(sd, inode);
+	sysfs_refresh_inode(kn, inode);
 	mutex_unlock(&sysfs_mutex);
 
 	generic_fillattr(inode, stat);
 	return 0;
 }
 
-static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
+static void sysfs_init_inode(struct kernfs_node *kn, struct inode *inode)
 {
-	kernfs_get(sd);
-	inode->i_private = sd;
+	kernfs_get(kn);
+	inode->i_private = kn;
 	inode->i_mapping->a_ops = &sysfs_aops;
 	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 	inode->i_op = &sysfs_inode_operations;
 
-	set_default_inode_attr(inode, sd->s_mode);
-	sysfs_refresh_inode(sd, inode);
+	set_default_inode_attr(inode, kn->s_mode);
+	sysfs_refresh_inode(kn, inode);
 
 	/* initialize inode according to type */
-	switch (sysfs_type(sd)) {
+	switch (sysfs_type(kn)) {
 	case SYSFS_DIR:
 		inode->i_op = &sysfs_dir_inode_operations;
 		inode->i_fop = &sysfs_dir_operations;
 		break;
 	case SYSFS_KOBJ_ATTR:
-		inode->i_size = sd->s_attr.size;
+		inode->i_size = kn->s_attr.size;
 		inode->i_fop = &kernfs_file_operations;
 		break;
 	case SYSFS_KOBJ_LINK:
@@ -318,13 +319,13 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 }
 
 /**
- *	sysfs_get_inode - get inode for sysfs_dirent
+ *	sysfs_get_inode - get inode for kernfs_node
  *	@sb: super block
- *	@sd: sysfs_dirent to allocate inode for
+ *	@kn: kernfs_node to allocate inode for
  *
- *	Get inode for @sd.  If such inode doesn't exist, a new inode
- *	is allocated and basics are initialized.  New inode is
- *	returned locked.
+ *	Get inode for @kn.  If such inode doesn't exist, a new inode is
+ *	allocated and basics are initialized.  New inode is returned
+ *	locked.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).
@@ -332,44 +333,44 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
  *	RETURNS:
  *	Pointer to allocated inode on success, NULL on failure.
  */
-struct inode *sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd)
+struct inode *sysfs_get_inode(struct super_block *sb, struct kernfs_node *kn)
 {
 	struct inode *inode;
 
-	inode = iget_locked(sb, sd->s_ino);
+	inode = iget_locked(sb, kn->s_ino);
 	if (inode && (inode->i_state & I_NEW))
-		sysfs_init_inode(sd, inode);
+		sysfs_init_inode(kn, inode);
 
 	return inode;
 }
 
 /*
- * The sysfs_dirent serves as both an inode and a directory entry for sysfs.
- * To prevent the sysfs inode numbers from being freed prematurely we take a
- * reference to sysfs_dirent from the sysfs inode.  A
+ * The kernfs_node serves as both an inode and a directory entry for sysfs.
+ * To prevent the sysfs inode numbers from being freed prematurely we take
+ * a reference to kernfs_node from the sysfs inode.  A
  * super_operations.evict_inode() implementation is needed to drop that
  * reference upon inode destruction.
  */
 void sysfs_evict_inode(struct inode *inode)
 {
-	struct sysfs_dirent *sd  = inode->i_private;
+	struct kernfs_node *kn = inode->i_private;
 
 	truncate_inode_pages(&inode->i_data, 0);
 	clear_inode(inode);
-	kernfs_put(sd);
+	kernfs_put(kn);
 }
 
 int sysfs_permission(struct inode *inode, int mask)
 {
-	struct sysfs_dirent *sd;
+	struct kernfs_node *kn;
 
 	if (mask & MAY_NOT_BLOCK)
 		return -ECHILD;
 
-	sd = inode->i_private;
+	kn = inode->i_private;
 
 	mutex_lock(&sysfs_mutex);
-	sysfs_refresh_inode(sd, inode);
+	sysfs_refresh_inode(kn, inode);
 	mutex_unlock(&sysfs_mutex);
 
 	return generic_permission(inode, mask);
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 910e485..b7ea76c 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -31,24 +31,24 @@ struct sysfs_inode_attrs {
 /* SYSFS_TYPE_MASK and types are defined in include/linux/kernfs.h */
 
 /**
- * kernfs_root - find out the kernfs_root a sysfs_dirent belongs to
- * @sd: sysfs_dirent of interest
+ * kernfs_root - find out the kernfs_root a kernfs_node belongs to
+ * @kn: kernfs_node of interest
  *
- * Return the kernfs_root @sd belongs to.
+ * Return the kernfs_root @kn belongs to.
  */
-static inline struct kernfs_root *kernfs_root(struct sysfs_dirent *sd)
+static inline struct kernfs_root *kernfs_root(struct kernfs_node *kn)
 {
 	/* if parent exists, it's always a dir; otherwise, @sd is a dir */
-	if (sd->s_parent)
-		sd = sd->s_parent;
-	return sd->s_dir.root;
+	if (kn->s_parent)
+		kn = kn->s_parent;
+	return kn->s_dir.root;
 }
 
 /*
  * Context structure to be used while adding/removing nodes.
  */
 struct sysfs_addrm_cxt {
-	struct sysfs_dirent	*removed;
+	struct kernfs_node	*removed;
 };
 
 /*
@@ -62,10 +62,10 @@ struct sysfs_super_info {
 	struct kernfs_root	*root;
 
 	/*
-	 * Each sb is associated with one namespace tag, currently the network
-	 * namespace of the task which mounted this sysfs instance.  If multiple
-	 * tags become necessary, make the following an array and compare
-	 * sysfs_dirent tag against every entry.
+	 * Each sb is associated with one namespace tag, currently the
+	 * network namespace of the task which mounted this sysfs instance.
+	 * If multiple tags become necessary, make the following an array
+	 * and compare kernfs_node tag against every entry.
 	 */
 	const void		*ns;
 };
@@ -76,7 +76,7 @@ extern struct kmem_cache *sysfs_dir_cachep;
 /*
  * inode.c
  */
-struct inode *sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd);
+struct inode *sysfs_get_inode(struct super_block *sb, struct kernfs_node *kn);
 void sysfs_evict_inode(struct inode *inode);
 int sysfs_permission(struct inode *inode, int mask);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
@@ -98,21 +98,21 @@ extern const struct dentry_operations sysfs_dentry_ops;
 extern const struct file_operations sysfs_dir_operations;
 extern const struct inode_operations sysfs_dir_inode_operations;
 
-struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
-void sysfs_put_active(struct sysfs_dirent *sd);
+struct kernfs_node *sysfs_get_active(struct kernfs_node *kn);
+void sysfs_put_active(struct kernfs_node *kn);
 void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt);
-int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
-		  struct sysfs_dirent *parent_sd);
+int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct kernfs_node *kn,
+		  struct kernfs_node *parent);
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
-struct sysfs_dirent *sysfs_new_dirent(struct kernfs_root *root,
-				      const char *name, umode_t mode, int type);
+struct kernfs_node *sysfs_new_dirent(struct kernfs_root *root,
+				     const char *name, umode_t mode, int type);
 
 /*
  * file.c
  */
 extern const struct file_operations kernfs_file_operations;
 
-void sysfs_unmap_bin_file(struct sysfs_dirent *sd);
+void sysfs_unmap_bin_file(struct kernfs_node *kn);
 
 /*
  * symlink.c
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 84c83e2..9dbbf37 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -39,7 +39,7 @@ static int sysfs_fill_super(struct super_block *sb)
 
 	/* get root inode, initialize and unlock it */
 	mutex_lock(&sysfs_mutex);
-	inode = sysfs_get_inode(sb, info->root->sd);
+	inode = sysfs_get_inode(sb, info->root->kn);
 	mutex_unlock(&sysfs_mutex);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
@@ -52,8 +52,8 @@ static int sysfs_fill_super(struct super_block *sb)
 		pr_debug("%s: could not get root dentry!\n", __func__);
 		return -ENOMEM;
 	}
-	kernfs_get(info->root->sd);
-	root->d_fsdata = info->root->sd;
+	kernfs_get(info->root->kn);
+	root->d_fsdata = info->root->kn;
 	sb->s_root = root;
 	sb->s_d_op = &sysfs_dentry_ops;
 	return 0;
@@ -145,7 +145,7 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 void kernfs_kill_sb(struct super_block *sb)
 {
 	struct sysfs_super_info *info = sysfs_info(sb);
-	struct sysfs_dirent *root_sd = sb->s_root->d_fsdata;
+	struct kernfs_node *root_kn = sb->s_root->d_fsdata;
 
 	/*
 	 * Remove the superblock from fs_supers/s_instances
@@ -153,13 +153,13 @@ void kernfs_kill_sb(struct super_block *sb)
 	 */
 	kill_anon_super(sb);
 	kfree(info);
-	kernfs_put(root_sd);
+	kernfs_put(root_kn);
 }
 
 void __init kernfs_init(void)
 {
 	sysfs_dir_cachep = kmem_cache_create("sysfs_dir_cache",
-					      sizeof(struct sysfs_dirent),
+					      sizeof(struct kernfs_node),
 					      0, SLAB_PANIC, NULL);
 	sysfs_inode_init();
 }
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index adf2875..29dcf5e 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -22,50 +22,50 @@
  *
  * Returns the created node on success, ERR_PTR() value on error.
  */
-struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
-					const char *name,
-					struct sysfs_dirent *target)
+struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
+				       const char *name,
+				       struct kernfs_node *target)
 {
-	struct sysfs_dirent *sd;
+	struct kernfs_node *kn;
 	struct sysfs_addrm_cxt acxt;
 	int error;
 
-	sd = sysfs_new_dirent(kernfs_root(parent), name, S_IFLNK|S_IRWXUGO,
+	kn = sysfs_new_dirent(kernfs_root(parent), name, S_IFLNK|S_IRWXUGO,
 			      SYSFS_KOBJ_LINK);
-	if (!sd)
+	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
 	if (kernfs_ns_enabled(parent))
-		sd->s_ns = target->s_ns;
-	sd->s_symlink.target_sd = target;
+		kn->s_ns = target->s_ns;
+	kn->s_symlink.target_kn = target;
 	kernfs_get(target);	/* ref owned by symlink */
 
 	sysfs_addrm_start(&acxt);
-	error = sysfs_add_one(&acxt, sd, parent);
+	error = sysfs_add_one(&acxt, kn, parent);
 	sysfs_addrm_finish(&acxt);
 
 	if (!error)
-		return sd;
+		return kn;
 
-	kernfs_put(sd);
+	kernfs_put(kn);
 	return ERR_PTR(error);
 }
 
-static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
-				 struct sysfs_dirent *target_sd, char *path)
+static int sysfs_get_target_path(struct kernfs_node *parent,
+				 struct kernfs_node *target, char *path)
 {
-	struct sysfs_dirent *base, *sd;
+	struct kernfs_node *base, *kn;
 	char *s = path;
 	int len = 0;
 
 	/* go up to the root, stop at the base */
-	base = parent_sd;
+	base = parent;
 	while (base->s_parent) {
-		sd = target_sd->s_parent;
-		while (sd->s_parent && base != sd)
-			sd = sd->s_parent;
+		kn = target->s_parent;
+		while (kn->s_parent && base != kn)
+			kn = kn->s_parent;
 
-		if (base == sd)
+		if (base == kn)
 			break;
 
 		strcpy(s, "../");
@@ -74,10 +74,10 @@ static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
 	}
 
 	/* determine end of target string for reverse fillup */
-	sd = target_sd;
-	while (sd->s_parent && sd != base) {
-		len += strlen(sd->s_name) + 1;
-		sd = sd->s_parent;
+	kn = target;
+	while (kn->s_parent && kn != base) {
+		len += strlen(kn->s_name) + 1;
+		kn = kn->s_parent;
 	}
 
 	/* check limits */
@@ -88,16 +88,16 @@ static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
 		return -ENAMETOOLONG;
 
 	/* reverse fillup of target string from target to base */
-	sd = target_sd;
-	while (sd->s_parent && sd != base) {
-		int slen = strlen(sd->s_name);
+	kn = target;
+	while (kn->s_parent && kn != base) {
+		int slen = strlen(kn->s_name);
 
 		len -= slen;
-		strncpy(s + len, sd->s_name, slen);
+		strncpy(s + len, kn->s_name, slen);
 		if (len)
 			s[--len] = '/';
 
-		sd = sd->s_parent;
+		kn = kn->s_parent;
 	}
 
 	return 0;
@@ -105,13 +105,13 @@ static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
 
 static int sysfs_getlink(struct dentry *dentry, char *path)
 {
-	struct sysfs_dirent *sd = dentry->d_fsdata;
-	struct sysfs_dirent *parent_sd = sd->s_parent;
-	struct sysfs_dirent *target_sd = sd->s_symlink.target_sd;
+	struct kernfs_node *kn = dentry->d_fsdata;
+	struct kernfs_node *parent = kn->s_parent;
+	struct kernfs_node *target = kn->s_symlink.target_kn;
 	int error;
 
 	mutex_lock(&sysfs_mutex);
-	error = sysfs_get_target_path(parent_sd, target_sd, path);
+	error = sysfs_get_target_path(parent, target, path);
 	mutex_unlock(&sysfs_mutex);
 
 	return error;
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 2fea501..f1efe3d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -21,23 +21,23 @@ DEFINE_SPINLOCK(sysfs_symlink_target_lock);
 
 /**
  *	sysfs_pathname - return full path to sysfs dirent
- *	@sd: sysfs_dirent whose path we want
+ *	@kn: kernfs_node whose path we want
  *	@path: caller allocated buffer of size PATH_MAX
  *
  *	Gives the name "/" to the sysfs_root entry; any path returned
  *	is relative to wherever sysfs is mounted.
  */
-static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
+static char *sysfs_pathname(struct kernfs_node *kn, char *path)
 {
-	if (sd->s_parent) {
-		sysfs_pathname(sd->s_parent, path);
+	if (kn->s_parent) {
+		sysfs_pathname(kn->s_parent, path);
 		strlcat(path, "/", PATH_MAX);
 	}
-	strlcat(path, sd->s_name, PATH_MAX);
+	strlcat(path, kn->s_name, PATH_MAX);
 	return path;
 }
 
-void sysfs_warn_dup(struct sysfs_dirent *parent, const char *name)
+void sysfs_warn_dup(struct kernfs_node *parent, const char *name)
 {
 	char *path;
 
@@ -61,26 +61,26 @@ void sysfs_warn_dup(struct sysfs_dirent *parent, const char *name)
  */
 int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
 {
-	struct sysfs_dirent *parent_sd, *sd;
+	struct kernfs_node *parent, *kn;
 
 	BUG_ON(!kobj);
 
 	if (kobj->parent)
-		parent_sd = kobj->parent->sd;
+		parent = kobj->parent->sd;
 	else
-		parent_sd = sysfs_root_sd;
+		parent = sysfs_root_kn;
 
-	if (!parent_sd)
+	if (!parent)
 		return -ENOENT;
 
-	sd = kernfs_create_dir_ns(parent_sd, kobject_name(kobj), kobj, ns);
-	if (IS_ERR(sd)) {
-		if (PTR_ERR(sd) == -EEXIST)
-			sysfs_warn_dup(parent_sd, kobject_name(kobj));
-		return PTR_ERR(sd);
+	kn = kernfs_create_dir_ns(parent, kobject_name(kobj), kobj, ns);
+	if (IS_ERR(kn)) {
+		if (PTR_ERR(kn) == -EEXIST)
+			sysfs_warn_dup(parent, kobject_name(kobj));
+		return PTR_ERR(kn);
 	}
 
-	kobj->sd = sd;
+	kobj->sd = kn;
 	return 0;
 }
 
@@ -94,47 +94,47 @@ int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
  */
 void sysfs_remove_dir(struct kobject *kobj)
 {
-	struct sysfs_dirent *sd = kobj->sd;
+	struct kernfs_node *kn = kobj->sd;
 
 	/*
 	 * In general, kboject owner is responsible for ensuring removal
 	 * doesn't race with other operations and sysfs doesn't provide any
 	 * protection; however, when @kobj is used as a symlink target, the
 	 * symlinking entity usually doesn't own @kobj and thus has no
-	 * control over removal.  @kobj->sd may be removed anytime and
-	 * symlink code may end up dereferencing an already freed sd.
+	 * control over removal.  @kobj->sd may be removed anytime
+	 * and symlink code may end up dereferencing an already freed node.
 	 *
-	 * sysfs_symlink_target_lock synchronizes @kobj->sd disassociation
-	 * against symlink operations so that symlink code can safely
-	 * dereference @kobj->sd.
+	 * sysfs_symlink_target_lock synchronizes @kobj->sd
+	 * disassociation against symlink operations so that symlink code
+	 * can safely dereference @kobj->sd.
 	 */
 	spin_lock(&sysfs_symlink_target_lock);
 	kobj->sd = NULL;
 	spin_unlock(&sysfs_symlink_target_lock);
 
-	if (sd) {
-		WARN_ON_ONCE(sysfs_type(sd) != SYSFS_DIR);
-		kernfs_remove(sd);
+	if (kn) {
+		WARN_ON_ONCE(sysfs_type(kn) != SYSFS_DIR);
+		kernfs_remove(kn);
 	}
 }
 
 int sysfs_rename_dir_ns(struct kobject *kobj, const char *new_name,
 			const void *new_ns)
 {
-	struct sysfs_dirent *parent_sd = kobj->sd->s_parent;
+	struct kernfs_node *parent = kobj->sd->s_parent;
 
-	return kernfs_rename_ns(kobj->sd, parent_sd, new_name, new_ns);
+	return kernfs_rename_ns(kobj->sd, parent, new_name, new_ns);
 }
 
 int sysfs_move_dir_ns(struct kobject *kobj, struct kobject *new_parent_kobj,
 		      const void *new_ns)
 {
-	struct sysfs_dirent *sd = kobj->sd;
-	struct sysfs_dirent *new_parent_sd;
+	struct kernfs_node *kn = kobj->sd;
+	struct kernfs_node *new_parent;
 
-	BUG_ON(!sd->s_parent);
-	new_parent_sd = new_parent_kobj && new_parent_kobj->sd ?
-		new_parent_kobj->sd : sysfs_root_sd;
+	BUG_ON(!kn->s_parent);
+	new_parent = new_parent_kobj && new_parent_kobj->sd ?
+		new_parent_kobj->sd : sysfs_root_kn;
 
-	return kernfs_rename_ns(sd, new_parent_sd, sd->s_name, new_ns);
+	return kernfs_rename_ns(kn, new_parent, kn->s_name, new_ns);
 }
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index a67d1c6..be1cc39 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -22,15 +22,15 @@
 #include "../kernfs/kernfs-internal.h"
 
 /*
- * Determine ktype->sysfs_ops for the given sysfs_dirent.  This function
+ * Determine ktype->sysfs_ops for the given kernfs_node.  This function
  * must be called while holding an active reference.
  */
-static const struct sysfs_ops *sysfs_file_ops(struct sysfs_dirent *sd)
+static const struct sysfs_ops *sysfs_file_ops(struct kernfs_node *kn)
 {
-	struct kobject *kobj = sd->s_parent->priv;
+	struct kobject *kobj = kn->s_parent->priv;
 
-	if (sd->s_flags & SYSFS_FLAG_LOCKDEP)
-		lockdep_assert_held(sd);
+	if (kn->s_flags & SYSFS_FLAG_LOCKDEP)
+		lockdep_assert_held(kn);
 	return kobj->ktype ? kobj->ktype->sysfs_ops : NULL;
 }
 
@@ -42,8 +42,8 @@ static const struct sysfs_ops *sysfs_file_ops(struct sysfs_dirent *sd)
 static int sysfs_kf_seq_show(struct seq_file *sf, void *v)
 {
 	struct sysfs_open_file *of = sf->private;
-	struct kobject *kobj = of->sd->s_parent->priv;
-	const struct sysfs_ops *ops = sysfs_file_ops(of->sd);
+	struct kobject *kobj = of->kn->s_parent->priv;
+	const struct sysfs_ops *ops = sysfs_file_ops(of->kn);
 	ssize_t count;
 	char *buf;
 
@@ -59,7 +59,7 @@ static int sysfs_kf_seq_show(struct seq_file *sf, void *v)
 	 * if @ops->show() isn't implemented.
 	 */
 	if (ops->show) {
-		count = ops->show(kobj, of->sd->priv, buf);
+		count = ops->show(kobj, of->kn->priv, buf);
 		if (count < 0)
 			return count;
 	}
@@ -81,8 +81,8 @@ static int sysfs_kf_seq_show(struct seq_file *sf, void *v)
 static ssize_t sysfs_kf_bin_read(struct sysfs_open_file *of, char *buf,
 				 size_t count, loff_t pos)
 {
-	struct bin_attribute *battr = of->sd->priv;
-	struct kobject *kobj = of->sd->s_parent->priv;
+	struct bin_attribute *battr = of->kn->priv;
+	struct kobject *kobj = of->kn->s_parent->priv;
 	loff_t size = file_inode(of->file)->i_size;
 
 	if (!count)
@@ -105,21 +105,21 @@ static ssize_t sysfs_kf_bin_read(struct sysfs_open_file *of, char *buf,
 static ssize_t sysfs_kf_write(struct sysfs_open_file *of, char *buf,
 			      size_t count, loff_t pos)
 {
-	const struct sysfs_ops *ops = sysfs_file_ops(of->sd);
-	struct kobject *kobj = of->sd->s_parent->priv;
+	const struct sysfs_ops *ops = sysfs_file_ops(of->kn);
+	struct kobject *kobj = of->kn->s_parent->priv;
 
 	if (!count)
 		return 0;
 
-	return ops->store(kobj, of->sd->priv, buf, count);
+	return ops->store(kobj, of->kn->priv, buf, count);
 }
 
 /* kernfs write callback for bin sysfs files */
 static ssize_t sysfs_kf_bin_write(struct sysfs_open_file *of, char *buf,
 				  size_t count, loff_t pos)
 {
-	struct bin_attribute *battr = of->sd->priv;
-	struct kobject *kobj = of->sd->s_parent->priv;
+	struct bin_attribute *battr = of->kn->priv;
+	struct kobject *kobj = of->kn->s_parent->priv;
 	loff_t size = file_inode(of->file)->i_size;
 
 	if (size) {
@@ -139,30 +139,30 @@ static ssize_t sysfs_kf_bin_write(struct sysfs_open_file *of, char *buf,
 static int sysfs_kf_bin_mmap(struct sysfs_open_file *of,
 			     struct vm_area_struct *vma)
 {
-	struct bin_attribute *battr = of->sd->priv;
-	struct kobject *kobj = of->sd->s_parent->priv;
+	struct bin_attribute *battr = of->kn->priv;
+	struct kobject *kobj = of->kn->s_parent->priv;
 
 	return battr->mmap(of->file, kobj, battr, vma);
 }
 
-void sysfs_notify(struct kobject *k, const char *dir, const char *attr)
+void sysfs_notify(struct kobject *kobj, const char *dir, const char *attr)
 {
-	struct sysfs_dirent *sd = k->sd, *tmp;
+	struct kernfs_node *kn = kobj->sd, *tmp;
 
-	if (sd && dir)
-		sd = kernfs_find_and_get(sd, dir);
+	if (kn && dir)
+		kn = kernfs_find_and_get(kn, dir);
 	else
-		kernfs_get(sd);
+		kernfs_get(kn);
 
-	if (sd && attr) {
-		tmp = kernfs_find_and_get(sd, attr);
-		kernfs_put(sd);
-		sd = tmp;
+	if (kn && attr) {
+		tmp = kernfs_find_and_get(kn, attr);
+		kernfs_put(kn);
+		kn = tmp;
 	}
 
-	if (sd) {
-		kernfs_notify(sd);
-		kernfs_put(sd);
+	if (kn) {
+		kernfs_notify(kn);
+		kernfs_put(kn);
 	}
 }
 EXPORT_SYMBOL_GPL(sysfs_notify);
@@ -202,17 +202,17 @@ static const struct kernfs_ops sysfs_bin_kfops_mmap = {
 	.mmap		= sysfs_kf_bin_mmap,
 };
 
-int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
+int sysfs_add_file_mode_ns(struct kernfs_node *parent,
 			   const struct attribute *attr, bool is_bin,
 			   umode_t mode, const void *ns)
 {
 	struct lock_class_key *key = NULL;
 	const struct kernfs_ops *ops;
-	struct sysfs_dirent *sd;
+	struct kernfs_node *kn;
 	loff_t size;
 
 	if (!is_bin) {
-		struct kobject *kobj = dir_sd->priv;
+		struct kobject *kobj = parent->priv;
 		const struct sysfs_ops *sysfs_ops = kobj->ktype->sysfs_ops;
 
 		/* every kobject with an attribute needs a ktype assigned */
@@ -252,20 +252,20 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 	if (!attr->ignore_lockdep)
 		key = attr->key ?: (struct lock_class_key *)&attr->skey;
 #endif
-	sd = kernfs_create_file_ns_key(dir_sd, attr->name, mode, size,
+	kn = kernfs_create_file_ns_key(parent, attr->name, mode, size,
 				       ops, (void *)attr, ns, key);
-	if (IS_ERR(sd)) {
-		if (PTR_ERR(sd) == -EEXIST)
-			sysfs_warn_dup(dir_sd, attr->name);
-		return PTR_ERR(sd);
+	if (IS_ERR(kn)) {
+		if (PTR_ERR(kn) == -EEXIST)
+			sysfs_warn_dup(parent, attr->name);
+		return PTR_ERR(kn);
 	}
 	return 0;
 }
 
-int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
+int sysfs_add_file(struct kernfs_node *parent, const struct attribute *attr,
 		   bool is_bin)
 {
-	return sysfs_add_file_mode_ns(dir_sd, attr, is_bin, attr->mode, NULL);
+	return sysfs_add_file_mode_ns(parent, attr, is_bin, attr->mode, NULL);
 }
 
 /**
@@ -307,21 +307,21 @@ EXPORT_SYMBOL_GPL(sysfs_create_files);
 int sysfs_add_file_to_group(struct kobject *kobj,
 		const struct attribute *attr, const char *group)
 {
-	struct sysfs_dirent *dir_sd;
+	struct kernfs_node *parent;
 	int error;
 
 	if (group) {
-		dir_sd = kernfs_find_and_get(kobj->sd, group);
+		parent = kernfs_find_and_get(kobj->sd, group);
 	} else {
-		dir_sd = kobj->sd;
-		kernfs_get(dir_sd);
+		parent = kobj->sd;
+		kernfs_get(parent);
 	}
 
-	if (!dir_sd)
+	if (!parent)
 		return -ENOENT;
 
-	error = sysfs_add_file(dir_sd, attr, false);
-	kernfs_put(dir_sd);
+	error = sysfs_add_file(parent, attr, false);
+	kernfs_put(parent);
 
 	return error;
 }
@@ -337,20 +337,20 @@ EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
 int sysfs_chmod_file(struct kobject *kobj, const struct attribute *attr,
 		     umode_t mode)
 {
-	struct sysfs_dirent *sd;
+	struct kernfs_node *kn;
 	struct iattr newattrs;
 	int rc;
 
-	sd = kernfs_find_and_get(kobj->sd, attr->name);
-	if (!sd)
+	kn = kernfs_find_and_get(kobj->sd, attr->name);
+	if (!kn)
 		return -ENOENT;
 
-	newattrs.ia_mode = (mode & S_IALLUGO) | (sd->s_mode & ~S_IALLUGO);
+	newattrs.ia_mode = (mode & S_IALLUGO) | (kn->s_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE;
 
-	rc = kernfs_setattr(sd, &newattrs);
+	rc = kernfs_setattr(kn, &newattrs);
 
-	kernfs_put(sd);
+	kernfs_put(kn);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(sysfs_chmod_file);
@@ -366,9 +366,9 @@ EXPORT_SYMBOL_GPL(sysfs_chmod_file);
 void sysfs_remove_file_ns(struct kobject *kobj, const struct attribute *attr,
 			  const void *ns)
 {
-	struct sysfs_dirent *dir_sd = kobj->sd;
+	struct kernfs_node *parent = kobj->sd;
 
-	kernfs_remove_by_name_ns(dir_sd, attr->name, ns);
+	kernfs_remove_by_name_ns(parent, attr->name, ns);
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_file_ns);
 
@@ -389,18 +389,18 @@ EXPORT_SYMBOL_GPL(sysfs_remove_files);
 void sysfs_remove_file_from_group(struct kobject *kobj,
 		const struct attribute *attr, const char *group)
 {
-	struct sysfs_dirent *dir_sd;
+	struct kernfs_node *parent;
 
 	if (group) {
-		dir_sd = kernfs_find_and_get(kobj->sd, group);
+		parent = kernfs_find_and_get(kobj->sd, group);
 	} else {
-		dir_sd = kobj->sd;
-		kernfs_get(dir_sd);
+		parent = kobj->sd;
+		kernfs_get(parent);
 	}
 
-	if (dir_sd) {
-		kernfs_remove_by_name(dir_sd, attr->name);
-		kernfs_put(dir_sd);
+	if (parent) {
+		kernfs_remove_by_name(parent, attr->name);
+		kernfs_put(parent);
 	}
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_file_from_group);
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 7177532..4d00d399 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -18,7 +18,7 @@
 #include "sysfs.h"
 
 
-static void remove_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
+static void remove_files(struct kernfs_node *parent, struct kobject *kobj,
 			 const struct attribute_group *grp)
 {
 	struct attribute *const *attr;
@@ -26,13 +26,13 @@ static void remove_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 
 	if (grp->attrs)
 		for (attr = grp->attrs; *attr; attr++)
-			kernfs_remove_by_name(dir_sd, (*attr)->name);
+			kernfs_remove_by_name(parent, (*attr)->name);
 	if (grp->bin_attrs)
 		for (bin_attr = grp->bin_attrs; *bin_attr; bin_attr++)
 			sysfs_remove_bin_file(kobj, *bin_attr);
 }
 
-static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
+static int create_files(struct kernfs_node *parent, struct kobject *kobj,
 			const struct attribute_group *grp, int update)
 {
 	struct attribute *const *attr;
@@ -49,20 +49,20 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 			 * re-adding (if required) the file.
 			 */
 			if (update)
-				kernfs_remove_by_name(dir_sd, (*attr)->name);
+				kernfs_remove_by_name(parent, (*attr)->name);
 			if (grp->is_visible) {
 				mode = grp->is_visible(kobj, *attr, i);
 				if (!mode)
 					continue;
 			}
-			error = sysfs_add_file_mode_ns(dir_sd, *attr, false,
+			error = sysfs_add_file_mode_ns(parent, *attr, false,
 						       (*attr)->mode | mode,
 						       NULL);
 			if (unlikely(error))
 				break;
 		}
 		if (error) {
-			remove_files(dir_sd, kobj, grp);
+			remove_files(parent, kobj, grp);
 			goto exit;
 		}
 	}
@@ -76,7 +76,7 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 				break;
 		}
 		if (error)
-			remove_files(dir_sd, kobj, grp);
+			remove_files(parent, kobj, grp);
 	}
 exit:
 	return error;
@@ -86,7 +86,7 @@ exit:
 static int internal_create_group(struct kobject *kobj, int update,
 				 const struct attribute_group *grp)
 {
-	struct sysfs_dirent *sd;
+	struct kernfs_node *kn;
 	int error;
 
 	BUG_ON(!kobj || (!update && !kobj->sd));
@@ -100,21 +100,21 @@ static int internal_create_group(struct kobject *kobj, int update,
 		return -EINVAL;
 	}
 	if (grp->name) {
-		sd = kernfs_create_dir(kobj->sd, grp->name, kobj);
-		if (IS_ERR(sd)) {
-			if (PTR_ERR(sd) == -EEXIST)
+		kn = kernfs_create_dir(kobj->sd, grp->name, kobj);
+		if (IS_ERR(kn)) {
+			if (PTR_ERR(kn) == -EEXIST)
 				sysfs_warn_dup(kobj->sd, grp->name);
-			return PTR_ERR(sd);
+			return PTR_ERR(kn);
 		}
 	} else
-		sd = kobj->sd;
-	kernfs_get(sd);
-	error = create_files(sd, kobj, grp, update);
+		kn = kobj->sd;
+	kernfs_get(kn);
+	error = create_files(kn, kobj, grp, update);
 	if (error) {
 		if (grp->name)
-			kernfs_remove(sd);
+			kernfs_remove(kn);
 	}
-	kernfs_put(sd);
+	kernfs_put(kn);
 	return error;
 }
 
@@ -204,27 +204,27 @@ EXPORT_SYMBOL_GPL(sysfs_update_group);
 void sysfs_remove_group(struct kobject *kobj,
 			const struct attribute_group *grp)
 {
-	struct sysfs_dirent *dir_sd = kobj->sd;
-	struct sysfs_dirent *sd;
+	struct kernfs_node *parent = kobj->sd;
+	struct kernfs_node *kn;
 
 	if (grp->name) {
-		sd = kernfs_find_and_get(dir_sd, grp->name);
-		if (!sd) {
-			WARN(!sd, KERN_WARNING
+		kn = kernfs_find_and_get(parent, grp->name);
+		if (!kn) {
+			WARN(!kn, KERN_WARNING
 			     "sysfs group %p not found for kobject '%s'\n",
 			     grp, kobject_name(kobj));
 			return;
 		}
 	} else {
-		sd = dir_sd;
-		kernfs_get(sd);
+		kn = parent;
+		kernfs_get(kn);
 	}
 
-	remove_files(sd, kobj, grp);
+	remove_files(kn, kobj, grp);
 	if (grp->name)
-		kernfs_remove(sd);
+		kernfs_remove(kn);
 
-	kernfs_put(sd);
+	kernfs_put(kn);
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_group);
 
@@ -260,22 +260,22 @@ EXPORT_SYMBOL_GPL(sysfs_remove_groups);
 int sysfs_merge_group(struct kobject *kobj,
 		       const struct attribute_group *grp)
 {
-	struct sysfs_dirent *dir_sd;
+	struct kernfs_node *parent;
 	int error = 0;
 	struct attribute *const *attr;
 	int i;
 
-	dir_sd = kernfs_find_and_get(kobj->sd, grp->name);
-	if (!dir_sd)
+	parent = kernfs_find_and_get(kobj->sd, grp->name);
+	if (!parent)
 		return -ENOENT;
 
 	for ((i = 0, attr = grp->attrs); *attr && !error; (++i, ++attr))
-		error = sysfs_add_file(dir_sd, *attr, false);
+		error = sysfs_add_file(parent, *attr, false);
 	if (error) {
 		while (--i >= 0)
-			kernfs_remove_by_name(dir_sd, (*--attr)->name);
+			kernfs_remove_by_name(parent, (*--attr)->name);
 	}
-	kernfs_put(dir_sd);
+	kernfs_put(parent);
 
 	return error;
 }
@@ -289,14 +289,14 @@ EXPORT_SYMBOL_GPL(sysfs_merge_group);
 void sysfs_unmerge_group(struct kobject *kobj,
 		       const struct attribute_group *grp)
 {
-	struct sysfs_dirent *dir_sd;
+	struct kernfs_node *parent;
 	struct attribute *const *attr;
 
-	dir_sd = kernfs_find_and_get(kobj->sd, grp->name);
-	if (dir_sd) {
+	parent = kernfs_find_and_get(kobj->sd, grp->name);
+	if (parent) {
 		for (attr = grp->attrs; *attr; ++attr)
-			kernfs_remove_by_name(dir_sd, (*attr)->name);
-		kernfs_put(dir_sd);
+			kernfs_remove_by_name(parent, (*attr)->name);
+		kernfs_put(parent);
 	}
 }
 EXPORT_SYMBOL_GPL(sysfs_unmerge_group);
@@ -311,15 +311,15 @@ EXPORT_SYMBOL_GPL(sysfs_unmerge_group);
 int sysfs_add_link_to_group(struct kobject *kobj, const char *group_name,
 			    struct kobject *target, const char *link_name)
 {
-	struct sysfs_dirent *dir_sd;
+	struct kernfs_node *parent;
 	int error = 0;
 
-	dir_sd = kernfs_find_and_get(kobj->sd, group_name);
-	if (!dir_sd)
+	parent = kernfs_find_and_get(kobj->sd, group_name);
+	if (!parent)
 		return -ENOENT;
 
-	error = sysfs_create_link_sd(dir_sd, target, link_name);
-	kernfs_put(dir_sd);
+	error = sysfs_create_link_sd(parent, target, link_name);
+	kernfs_put(parent);
 
 	return error;
 }
@@ -334,12 +334,12 @@ EXPORT_SYMBOL_GPL(sysfs_add_link_to_group);
 void sysfs_remove_link_from_group(struct kobject *kobj, const char *group_name,
 				  const char *link_name)
 {
-	struct sysfs_dirent *dir_sd;
+	struct kernfs_node *parent;
 
-	dir_sd = kernfs_find_and_get(kobj->sd, group_name);
-	if (dir_sd) {
-		kernfs_remove_by_name(dir_sd, link_name);
-		kernfs_put(dir_sd);
+	parent = kernfs_find_and_get(kobj->sd, group_name);
+	if (parent) {
+		kernfs_remove_by_name(parent, link_name);
+		kernfs_put(parent);
 	}
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_link_from_group);
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 8d07527..701a56f 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -20,7 +20,7 @@
 #include "sysfs.h"
 
 static struct kernfs_root *sysfs_root;
-struct sysfs_dirent *sysfs_root_sd;
+struct kernfs_node *sysfs_root_kn;
 
 static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
@@ -66,7 +66,7 @@ int __init sysfs_init(void)
 	if (IS_ERR(sysfs_root))
 		return PTR_ERR(sysfs_root);
 
-	sysfs_root_sd = sysfs_root->sd;
+	sysfs_root_kn = sysfs_root->kn;
 
 	err = register_filesystem(&sysfs_fs_type);
 	if (err) {
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 1b8c9ed..4ed3d49 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -18,66 +18,66 @@
 
 #include "sysfs.h"
 
-static int sysfs_do_create_link_sd(struct sysfs_dirent *parent_sd,
-				   struct kobject *target,
+static int sysfs_do_create_link_sd(struct kernfs_node *parent,
+				   struct kobject *target_kobj,
 				   const char *name, int warn)
 {
-	struct sysfs_dirent *sd, *target_sd = NULL;
+	struct kernfs_node *kn, *target = NULL;
 
-	BUG_ON(!name || !parent_sd);
+	BUG_ON(!name || !parent);
 
 	/*
-	 * We don't own @target and it may be removed at any time.
+	 * We don't own @target_kobj and it may be removed at any time.
 	 * Synchronize using sysfs_symlink_target_lock.  See
 	 * sysfs_remove_dir() for details.
 	 */
 	spin_lock(&sysfs_symlink_target_lock);
-	if (target->sd) {
-		target_sd = target->sd;
-		kernfs_get(target_sd);
+	if (target_kobj->sd) {
+		target = target_kobj->sd;
+		kernfs_get(target);
 	}
 	spin_unlock(&sysfs_symlink_target_lock);
 
-	if (!target_sd)
+	if (!target)
 		return -ENOENT;
 
-	sd = kernfs_create_link(parent_sd, name, target_sd);
-	kernfs_put(target_sd);
+	kn = kernfs_create_link(parent, name, target);
+	kernfs_put(target);
 
-	if (!IS_ERR(sd))
+	if (!IS_ERR(kn))
 		return 0;
 
-	if (warn && PTR_ERR(sd) == -EEXIST)
-		sysfs_warn_dup(parent_sd, name);
-	return PTR_ERR(sd);
+	if (warn && PTR_ERR(kn) == -EEXIST)
+		sysfs_warn_dup(parent, name);
+	return PTR_ERR(kn);
 }
 
 /**
  *	sysfs_create_link_sd - create symlink to a given object.
- *	@sd:		directory we're creating the link in.
+ *	@kn:		directory we're creating the link in.
  *	@target:	object we're pointing to.
  *	@name:		name of the symlink.
  */
-int sysfs_create_link_sd(struct sysfs_dirent *sd, struct kobject *target,
+int sysfs_create_link_sd(struct kernfs_node *kn, struct kobject *target,
 			 const char *name)
 {
-	return sysfs_do_create_link_sd(sd, target, name, 1);
+	return sysfs_do_create_link_sd(kn, target, name, 1);
 }
 
 static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
 				const char *name, int warn)
 {
-	struct sysfs_dirent *parent_sd = NULL;
+	struct kernfs_node *parent = NULL;
 
 	if (!kobj)
-		parent_sd = sysfs_root_sd;
+		parent = sysfs_root_kn;
 	else
-		parent_sd = kobj->sd;
+		parent = kobj->sd;
 
-	if (!parent_sd)
+	if (!parent)
 		return -EFAULT;
 
-	return sysfs_do_create_link_sd(parent_sd, target, name, warn);
+	return sysfs_do_create_link_sd(parent, target, name, warn);
 }
 
 /**
@@ -141,14 +141,14 @@ void sysfs_delete_link(struct kobject *kobj, struct kobject *targ,
  */
 void sysfs_remove_link(struct kobject *kobj, const char *name)
 {
-	struct sysfs_dirent *parent_sd = NULL;
+	struct kernfs_node *parent = NULL;
 
 	if (!kobj)
-		parent_sd = sysfs_root_sd;
+		parent = sysfs_root_kn;
 	else
-		parent_sd = kobj->sd;
+		parent = kobj->sd;
 
-	kernfs_remove_by_name(parent_sd, name);
+	kernfs_remove_by_name(parent, name);
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_link);
 
@@ -165,33 +165,33 @@ EXPORT_SYMBOL_GPL(sysfs_remove_link);
 int sysfs_rename_link_ns(struct kobject *kobj, struct kobject *targ,
 			 const char *old, const char *new, const void *new_ns)
 {
-	struct sysfs_dirent *parent_sd, *sd = NULL;
+	struct kernfs_node *parent, *kn = NULL;
 	const void *old_ns = NULL;
 	int result;
 
 	if (!kobj)
-		parent_sd = sysfs_root_sd;
+		parent = sysfs_root_kn;
 	else
-		parent_sd = kobj->sd;
+		parent = kobj->sd;
 
 	if (targ->sd)
 		old_ns = targ->sd->s_ns;
 
 	result = -ENOENT;
-	sd = kernfs_find_and_get_ns(parent_sd, old, old_ns);
-	if (!sd)
+	kn = kernfs_find_and_get_ns(parent, old, old_ns);
+	if (!kn)
 		goto out;
 
 	result = -EINVAL;
-	if (sysfs_type(sd) != SYSFS_KOBJ_LINK)
+	if (sysfs_type(kn) != SYSFS_KOBJ_LINK)
 		goto out;
-	if (sd->s_symlink.target_sd->priv != targ)
+	if (kn->s_symlink.target_kn->priv != targ)
 		goto out;
 
-	result = kernfs_rename_ns(sd, parent_sd, new, new_ns);
+	result = kernfs_rename_ns(kn, parent, new, new_ns);
 
 out:
-	kernfs_put(sd);
+	kernfs_put(kn);
 	return result;
 }
 EXPORT_SYMBOL_GPL(sysfs_rename_link_ns);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index c8e395b..0e2f1cc 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -16,28 +16,28 @@
 /*
  * mount.c
  */
-extern struct sysfs_dirent *sysfs_root_sd;
+extern struct kernfs_node *sysfs_root_kn;
 
 /*
  * dir.c
  */
 extern spinlock_t sysfs_symlink_target_lock;
 
-void sysfs_warn_dup(struct sysfs_dirent *parent, const char *name);
+void sysfs_warn_dup(struct kernfs_node *parent, const char *name);
 
 /*
  * file.c
  */
-int sysfs_add_file(struct sysfs_dirent *dir_sd,
+int sysfs_add_file(struct kernfs_node *parent,
 		   const struct attribute *attr, bool is_bin);
-int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
+int sysfs_add_file_mode_ns(struct kernfs_node *parent,
 			   const struct attribute *attr, bool is_bin,
 			   umode_t amode, const void *ns);
 
 /*
  * symlink.c
  */
-int sysfs_create_link_sd(struct sysfs_dirent *sd, struct kobject *target,
+int sysfs_create_link_sd(struct kernfs_node *kn, struct kobject *target,
 			 const char *name);
 
 #endif	/* __SYSFS_INTERNAL_H */
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index d655413..195d1c6 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -46,61 +46,61 @@ enum kernfs_node_flag {
 	SYSFS_FLAG_LOCKDEP	= 0x0100,
 };
 
-/* type-specific structures for sysfs_dirent->s_* union members */
-struct sysfs_elem_dir {
+/* type-specific structures for kernfs_node union members */
+struct kernfs_elem_dir {
 	unsigned long		subdirs;
-	/* children rbtree starts here and goes through sd->s_rb */
+	/* children rbtree starts here and goes through kn->s_rb */
 	struct rb_root		children;
 
 	/*
 	 * The kernfs hierarchy this directory belongs to.  This fits
-	 * better directly in sysfs_dirent but is here to save space.
+	 * better directly in kernfs_node but is here to save space.
 	 */
 	struct kernfs_root	*root;
 };
 
-struct sysfs_elem_symlink {
-	struct sysfs_dirent	*target_sd;
+struct kernfs_elem_symlink {
+	struct kernfs_node	*target_kn;
 };
 
-struct sysfs_elem_attr {
+struct kernfs_elem_attr {
 	const struct kernfs_ops	*ops;
 	struct sysfs_open_dirent *open;
 	loff_t			size;
 };
 
 /*
- * sysfs_dirent - the building block of sysfs hierarchy.  Each and every
- * sysfs node is represented by single sysfs_dirent.  Most fields are
+ * kernfs_node - the building block of kernfs hierarchy.  Each and every
+ * kernfs node is represented by single kernfs_node.  Most fields are
  * private to kernfs and shouldn't be accessed directly by kernfs users.
  *
- * As long as s_count reference is held, the sysfs_dirent itself is
- * accessible.  Dereferencing s_elem or any other outer entity
- * requires s_active reference.
+ * As long as s_count reference is held, the kernfs_node itself is
+ * accessible.  Dereferencing elem or any other outer entity requires
+ * active reference.
  */
-struct sysfs_dirent {
+struct kernfs_node {
 	atomic_t		s_count;
 	atomic_t		s_active;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
 	/* the following two fields are published */
-	struct sysfs_dirent	*s_parent;
+	struct kernfs_node	*s_parent;
 	const char		*s_name;
 
 	struct rb_node		s_rb;
 
 	union {
 		struct completion	*completion;
-		struct sysfs_dirent	*removed_list;
+		struct kernfs_node	*removed_list;
 	} u;
 
 	const void		*s_ns; /* namespace tag */
 	unsigned int		s_hash; /* ns + name hash */
 	union {
-		struct sysfs_elem_dir		s_dir;
-		struct sysfs_elem_symlink	s_symlink;
-		struct sysfs_elem_attr		s_attr;
+		struct kernfs_elem_dir		s_dir;
+		struct kernfs_elem_symlink	s_symlink;
+		struct kernfs_elem_attr		s_attr;
 	};
 
 	void			*priv;
@@ -113,7 +113,7 @@ struct sysfs_dirent {
 
 struct kernfs_root {
 	/* published fields */
-	struct sysfs_dirent	*sd;
+	struct kernfs_node	*kn;
 
 	/* private fields, do not use outside kernfs proper */
 	struct ida		ino_ida;
@@ -121,7 +121,7 @@ struct kernfs_root {
 
 struct sysfs_open_file {
 	/* published fields */
-	struct sysfs_dirent	*sd;
+	struct kernfs_node	*kn;
 	struct file		*file;
 
 	/* private fields, do not use outside kernfs proper */
@@ -170,64 +170,64 @@ struct kernfs_ops {
 
 #ifdef CONFIG_SYSFS
 
-static inline enum kernfs_node_type sysfs_type(struct sysfs_dirent *sd)
+static inline enum kernfs_node_type sysfs_type(struct kernfs_node *kn)
 {
-	return sd->s_flags & SYSFS_TYPE_MASK;
+	return kn->s_flags & SYSFS_TYPE_MASK;
 }
 
 /**
  * kernfs_enable_ns - enable namespace under a directory
- * @sd: directory of interest, should be empty
+ * @kn: directory of interest, should be empty
  *
- * This is to be called right after @sd is created to enable namespace
- * under it.  All children of @sd must have non-NULL namespace tags and
+ * This is to be called right after @kn is created to enable namespace
+ * under it.  All children of @kn must have non-NULL namespace tags and
  * only the ones which match the super_block's tag will be visible.
  */
-static inline void kernfs_enable_ns(struct sysfs_dirent *sd)
+static inline void kernfs_enable_ns(struct kernfs_node *kn)
 {
-	WARN_ON_ONCE(sysfs_type(sd) != SYSFS_DIR);
-	WARN_ON_ONCE(!RB_EMPTY_ROOT(&sd->s_dir.children));
-	sd->s_flags |= SYSFS_FLAG_NS;
+	WARN_ON_ONCE(sysfs_type(kn) != SYSFS_DIR);
+	WARN_ON_ONCE(!RB_EMPTY_ROOT(&kn->s_dir.children));
+	kn->s_flags |= SYSFS_FLAG_NS;
 }
 
 /**
  * kernfs_ns_enabled - test whether namespace is enabled
- * @sd: the node to test
+ * @kn: the node to test
  *
  * Test whether namespace filtering is enabled for the children of @ns.
  */
-static inline bool kernfs_ns_enabled(struct sysfs_dirent *sd)
+static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
 {
-	return sd->s_flags & SYSFS_FLAG_NS;
+	return kn->s_flags & SYSFS_FLAG_NS;
 }
 
-struct sysfs_dirent *kernfs_find_and_get_ns(struct sysfs_dirent *parent,
-					    const char *name, const void *ns);
-void kernfs_get(struct sysfs_dirent *sd);
-void kernfs_put(struct sysfs_dirent *sd);
+struct kernfs_node *kernfs_find_and_get_ns(struct kernfs_node *parent,
+					   const char *name, const void *ns);
+void kernfs_get(struct kernfs_node *kn);
+void kernfs_put(struct kernfs_node *kn);
 
 struct kernfs_root *kernfs_create_root(void *priv);
 void kernfs_destroy_root(struct kernfs_root *root);
 
-struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
-					  const char *name, void *priv,
-					  const void *ns);
-struct sysfs_dirent *kernfs_create_file_ns_key(struct sysfs_dirent *parent,
-					       const char *name,
-					       umode_t mode, loff_t size,
-					       const struct kernfs_ops *ops,
-					       void *priv, const void *ns,
-					       struct lock_class_key *key);
-struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
-					const char *name,
-					struct sysfs_dirent *target);
-void kernfs_remove(struct sysfs_dirent *sd);
-int kernfs_remove_by_name_ns(struct sysfs_dirent *parent, const char *name,
+struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
+					 const char *name, void *priv,
+					 const void *ns);
+struct kernfs_node *kernfs_create_file_ns_key(struct kernfs_node *parent,
+					      const char *name,
+					      umode_t mode, loff_t size,
+					      const struct kernfs_ops *ops,
+					      void *priv, const void *ns,
+					      struct lock_class_key *key);
+struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
+				       const char *name,
+				       struct kernfs_node *target);
+void kernfs_remove(struct kernfs_node *kn);
+int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 			     const void *ns);
-int kernfs_rename_ns(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
+int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 		     const char *new_name, const void *new_ns);
-int kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr);
-void kernfs_notify(struct sysfs_dirent *sd);
+int kernfs_setattr(struct kernfs_node *kn, const struct iattr *iattr);
+void kernfs_notify(struct kernfs_node *kn);
 
 const void *kernfs_super_ns(struct super_block *sb);
 struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
@@ -238,60 +238,60 @@ void kernfs_init(void);
 
 #else	/* CONFIG_SYSFS */
 
-static inline enum kernfs_node_type sysfs_type(struct sysfs_dirent *sd)
+static inline enum kernfs_node_type sysfs_type(struct kernfs_node *kn)
 { return 0; }	/* whatever */
 
-static inline void kernfs_enable_ns(struct sysfs_dirent *sd) { }
+static inline void kernfs_enable_ns(struct kernfs_node *kn) { }
 
-static inline bool kernfs_ns_enabled(struct sysfs_dirent *sd)
+static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
 { return false; }
 
-static inline struct sysfs_dirent *
-kernfs_find_and_get_ns(struct sysfs_dirent *parent, const char *name,
+static inline struct kernfs_node *
+kernfs_find_and_get_ns(struct kernfs_node *parent, const char *name,
 		       const void *ns)
 { return NULL; }
 
-static inline void kernfs_get(struct sysfs_dirent *sd) { }
-static inline void kernfs_put(struct sysfs_dirent *sd) { }
+static inline void kernfs_get(struct kernfs_node *kn) { }
+static inline void kernfs_put(struct kernfs_node *kn) { }
 
 static inline struct kernfs_root *kernfs_create_root(void *priv)
 { return ERR_PTR(-ENOSYS); }
 
 static inline void kernfs_destroy_root(struct kernfs_root *root) { }
 
-static inline struct sysfs_dirent *
-kernfs_create_dir_ns(struct sysfs_dirent *parent, const char *name, void *priv,
+static inline struct kernfs_node *
+kernfs_create_dir_ns(struct kernfs_node *parent, const char *name, void *priv,
 		     const void *ns)
 { return ERR_PTR(-ENOSYS); }
 
-static inline struct sysfs_dirent *
-kernfs_create_file_ns_key(struct sysfs_dirent *parent, const char *name,
+static inline struct kernfs_node *
+kernfs_create_file_ns_key(struct kernfs_node *parent, const char *name,
 			  umode_t mode, loff_t size,
 			  const struct kernfs_ops *ops, void *priv,
 			  const void *ns, struct lock_class_key *key)
 { return ERR_PTR(-ENOSYS); }
 
-static inline struct sysfs_dirent *
-kernfs_create_link(struct sysfs_dirent *parent, const char *name,
-		   struct sysfs_dirent *target)
+static inline struct kernfs_node *
+kernfs_create_link(struct kernfs_node *parent, const char *name,
+		   struct kernfs_node *target)
 { return ERR_PTR(-ENOSYS); }
 
-static inline void kernfs_remove(struct sysfs_dirent *sd) { }
+static inline void kernfs_remove(struct kernfs_node *kn) { }
 
-static inline int kernfs_remove_by_name_ns(struct sysfs_dirent *parent,
+static inline int kernfs_remove_by_name_ns(struct kernfs_node *kn,
 					   const char *name, const void *ns)
 { return -ENOSYS; }
 
-static inline int kernfs_rename_ns(struct sysfs_dirent *sd,
-				   struct sysfs_dirent *new_parent,
+static inline int kernfs_rename_ns(struct kernfs_node *kn,
+				   struct kernfs_node *new_parent,
 				   const char *new_name, const void *new_ns)
 { return -ENOSYS; }
 
-static inline int kernfs_setattr(struct sysfs_dirent *sd,
+static inline int kernfs_setattr(struct kernfs_node *kn,
 				 const struct iattr *iattr)
 { return -ENOSYS; }
 
-static inline void kernfs_notify(struct sysfs_dirent *sd) { }
+static inline void kernfs_notify(struct kernfs_node *kn) { }
 
 static inline const void *kernfs_super_ns(struct super_block *sb)
 { return NULL; }
@@ -307,20 +307,20 @@ static inline void kernfs_init(void) { }
 
 #endif	/* CONFIG_SYSFS */
 
-static inline struct sysfs_dirent *
-kernfs_find_and_get(struct sysfs_dirent *sd, const char *name)
+static inline struct kernfs_node *
+kernfs_find_and_get(struct kernfs_node *kn, const char *name)
 {
-	return kernfs_find_and_get_ns(sd, name, NULL);
+	return kernfs_find_and_get_ns(kn, name, NULL);
 }
 
-static inline struct sysfs_dirent *
-kernfs_create_dir(struct sysfs_dirent *parent, const char *name, void *priv)
+static inline struct kernfs_node *
+kernfs_create_dir(struct kernfs_node *parent, const char *name, void *priv)
 {
 	return kernfs_create_dir_ns(parent, name, priv, NULL);
 }
 
-static inline struct sysfs_dirent *
-kernfs_create_file_ns(struct sysfs_dirent *parent, const char *name,
+static inline struct kernfs_node *
+kernfs_create_file_ns(struct kernfs_node *parent, const char *name,
 		      umode_t mode, loff_t size, const struct kernfs_ops *ops,
 		      void *priv, const void *ns)
 {
@@ -333,14 +333,14 @@ kernfs_create_file_ns(struct sysfs_dirent *parent, const char *name,
 					 ns, key);
 }
 
-static inline struct sysfs_dirent *
-kernfs_create_file(struct sysfs_dirent *parent, const char *name, umode_t mode,
+static inline struct kernfs_node *
+kernfs_create_file(struct kernfs_node *parent, const char *name, umode_t mode,
 		   loff_t size, const struct kernfs_ops *ops, void *priv)
 {
 	return kernfs_create_file_ns(parent, name, mode, size, ops, priv, NULL);
 }
 
-static inline int kernfs_remove_by_name(struct sysfs_dirent *parent,
+static inline int kernfs_remove_by_name(struct kernfs_node *parent,
 					const char *name)
 {
 	return kernfs_remove_by_name_ns(parent, name, NULL);
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index e7ba650..926afb6 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -64,7 +64,7 @@ struct kobject {
 	struct kobject		*parent;
 	struct kset		*kset;
 	struct kobj_type	*ktype;
-	struct sysfs_dirent	*sd;
+	struct kernfs_node	*sd;
 	struct kref		kref;
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
 	struct delayed_work	release;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index cd8f90b..30b2ebe 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -438,26 +438,26 @@ static inline int sysfs_rename_link(struct kobject *kobj, struct kobject *target
 	return sysfs_rename_link_ns(kobj, target, old_name, new_name, NULL);
 }
 
-static inline void sysfs_notify_dirent(struct sysfs_dirent *sd)
+static inline void sysfs_notify_dirent(struct kernfs_node *kn)
 {
-	kernfs_notify(sd);
+	kernfs_notify(kn);
 }
 
-static inline struct sysfs_dirent *
-sysfs_get_dirent(struct sysfs_dirent *parent_sd, const unsigned char *name)
+static inline struct kernfs_node *sysfs_get_dirent(struct kernfs_node *parent,
+						   const unsigned char *name)
 {
-	return kernfs_find_and_get(parent_sd, name);
+	return kernfs_find_and_get(parent, name);
 }
 
-static inline struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
+static inline struct kernfs_node *sysfs_get(struct kernfs_node *kn)
 {
-	kernfs_get(sd);
-	return sd;
+	kernfs_get(kn);
+	return kn;
 }
 
-static inline void sysfs_put(struct sysfs_dirent *sd)
+static inline void sysfs_put(struct kernfs_node *kn)
 {
-	kernfs_put(sd);
+	kernfs_put(kn);
 }
 
 #endif /* _SYSFS_H_ */
diff --git a/lib/kobject.c b/lib/kobject.c
index 94b321f..064451f 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -556,7 +556,7 @@ out:
  */
 void kobject_del(struct kobject *kobj)
 {
-	struct sysfs_dirent *sd;
+	struct kernfs_node *sd;
 
 	if (!kobj)
 		return;
-- 
1.8.4.2

