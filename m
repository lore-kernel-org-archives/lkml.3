Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab3K1Tzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:55:42 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:54495 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603Ab3K1TzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:18 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/34] sysfs, kernfs: introduce kernfs[_find_and]_get() and kernfs_put()
Date: Thu, 28 Nov 2013 14:54:30 -0500
Message-Id: <1385668487-10181-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kernfs interface for finding, getting and putting
sysfs_dirents.

* sysfs_find_dirent() is renamed to kernfs_find_ns() and lockdep
  assertion for sysfs_mutex is added.

* sysfs_get_dirent_ns() is renamed to kernfs_find_and_get().

* Macro inline dancing around __sysfs_get/put() are removed and
  kernfs_get/put() are made proper functions implemented in
  fs/sysfs/dir.c.

While the conversions are mostly equivalent, there's one difference -
kernfs_get() doesn't return the input param as its return value.  This
change is intentional.  While passing through the input increases
writability in some areas, it is unnecessary and has been shown to
cause confusion regarding how the last ref is handled.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c         | 117 ++++++++++++++++++++++++++++---------------------
 fs/sysfs/file.c        |  41 +++++++++--------
 fs/sysfs/group.c       |  30 +++++++------
 fs/sysfs/inode.c       |   5 ++-
 fs/sysfs/mount.c       |  14 ------
 fs/sysfs/symlink.c     |  16 ++++---
 fs/sysfs/sysfs.h       |  22 ----------
 include/linux/kernfs.h |  19 ++++++++
 include/linux/sysfs.h  |  35 ++++++---------
 9 files changed, 151 insertions(+), 148 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 8f2d577..0d806ef 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -240,10 +240,31 @@ static void sysfs_free_ino(unsigned int ino)
 	spin_unlock(&sysfs_ino_lock);
 }
 
-void release_sysfs_dirent(struct sysfs_dirent *sd)
+/**
+ * kernfs_get - get a reference count on a sysfs_dirent
+ * @sd: the target sysfs_dirent
+ */
+void kernfs_get(struct sysfs_dirent *sd)
+{
+	if (sd) {
+		WARN_ON(!atomic_read(&sd->s_count));
+		atomic_inc(&sd->s_count);
+	}
+}
+EXPORT_SYMBOL_GPL(kernfs_get);
+
+/**
+ * kernfs_put - put a reference count on a sysfs_dirent
+ * @sd: the target sysfs_dirent
+ *
+ * Put a reference count of @sd and destroy it if it reached zero.
+ */
+void kernfs_put(struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent *parent_sd;
 
+	if (!sd || !atomic_dec_and_test(&sd->s_count))
+		return;
  repeat:
 	/* Moving/renaming is always done while holding reference.
 	 * sd->s_parent won't change beneath us.
@@ -255,7 +276,7 @@ void release_sysfs_dirent(struct sysfs_dirent *sd)
 		parent_sd ? parent_sd->s_name : "", sd->s_name);
 
 	if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
-		sysfs_put(sd->s_symlink.target_sd);
+		kernfs_put(sd->s_symlink.target_sd);
 	if (sysfs_type(sd) & SYSFS_COPY_NAME)
 		kfree(sd->s_name);
 	if (sd->s_iattr && sd->s_iattr->ia_secdata)
@@ -269,6 +290,7 @@ void release_sysfs_dirent(struct sysfs_dirent *sd)
 	if (sd && atomic_dec_and_test(&sd->s_count))
 		goto repeat;
 }
+EXPORT_SYMBOL_GPL(kernfs_put);
 
 static int sysfs_dentry_delete(const struct dentry *dentry)
 {
@@ -331,7 +353,7 @@ out_bad:
 
 static void sysfs_dentry_release(struct dentry *dentry)
 {
-	sysfs_put(dentry->d_fsdata);
+	kernfs_put(dentry->d_fsdata);
 }
 
 const struct dentry_operations sysfs_dentry_ops = {
@@ -433,7 +455,8 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		return -EINVAL;
 
 	sd->s_hash = sysfs_name_hash(sd->s_name, sd->s_ns);
-	sd->s_parent = sysfs_get(parent_sd);
+	sd->s_parent = parent_sd;
+	kernfs_get(parent_sd);
 
 	ret = sysfs_link_sibling(sd);
 	if (ret)
@@ -553,36 +576,33 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 
 		sysfs_deactivate(sd);
 		sysfs_unmap_bin_file(sd);
-		sysfs_put(sd);
+		kernfs_put(sd);
 	}
 }
 
 /**
- *	sysfs_find_dirent - find sysfs_dirent with the given name
- *	@parent_sd: sysfs_dirent to search under
- *	@name: name to look for
- *	@ns: the namespace tag to use
- *
- *	Look for sysfs_dirent with name @name under @parent_sd.
- *
- *	LOCKING:
- *	mutex_lock(sysfs_mutex)
+ * kernfs_find_ns - find sysfs_dirent with the given name
+ * @parent: sysfs_dirent to search under
+ * @name: name to look for
+ * @ns: the namespace tag to use
  *
- *	RETURNS:
- *	Pointer to sysfs_dirent if found, NULL if not.
+ * Look for sysfs_dirent with name @name under @parent.  Returns pointer to
+ * the found sysfs_dirent on success, %NULL on failure.
  */
-struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
-				       const unsigned char *name,
-				       const void *ns)
+static struct sysfs_dirent *kernfs_find_ns(struct sysfs_dirent *parent,
+					   const unsigned char *name,
+					   const void *ns)
 {
-	struct rb_node *node = parent_sd->s_dir.children.rb_node;
-	bool has_ns = parent_sd->s_flags & SYSFS_FLAG_NS;
+	struct rb_node *node = parent->s_dir.children.rb_node;
+	bool has_ns = parent->s_flags & SYSFS_FLAG_NS;
 	unsigned int hash;
 
+	lockdep_assert_held(&sysfs_mutex);
+
 	if (has_ns != (bool)ns) {
 		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
 		     has_ns ? "required" : "invalid",
-		     parent_sd->s_name, name);
+		     parent->s_name, name);
 		return NULL;
 	}
 
@@ -604,34 +624,28 @@ struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 }
 
 /**
- *	sysfs_get_dirent_ns - find and get sysfs_dirent with the given name
- *	@parent_sd: sysfs_dirent to search under
- *	@name: name to look for
- *	@ns: the namespace tag to use
- *
- *	Look for sysfs_dirent with name @name under @parent_sd and get
- *	it if found.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).  Grabs sysfs_mutex.
+ * kernfs_find_and_get_ns - find and get sysfs_dirent with the given name
+ * @parent: sysfs_dirent to search under
+ * @name: name to look for
+ * @ns: the namespace tag to use
  *
- *	RETURNS:
- *	Pointer to sysfs_dirent if found, NULL if not.
+ * Look for sysfs_dirent with name @name under @parent and get a reference
+ * if found.  This function may sleep and returns pointer to the found
+ * sysfs_dirent on success, %NULL on failure.
  */
-struct sysfs_dirent *sysfs_get_dirent_ns(struct sysfs_dirent *parent_sd,
-					 const unsigned char *name,
-					 const void *ns)
+struct sysfs_dirent *kernfs_find_and_get_ns(struct sysfs_dirent *parent,
+					    const char *name, const void *ns)
 {
 	struct sysfs_dirent *sd;
 
 	mutex_lock(&sysfs_mutex);
-	sd = sysfs_find_dirent(parent_sd, name, ns);
-	sysfs_get(sd);
+	sd = kernfs_find_ns(parent, name, ns);
+	kernfs_get(sd);
 	mutex_unlock(&sysfs_mutex);
 
 	return sd;
 }
-EXPORT_SYMBOL_GPL(sysfs_get_dirent_ns);
+EXPORT_SYMBOL_GPL(kernfs_find_and_get_ns);
 
 /**
  * kernfs_create_dir_ns - create a directory
@@ -667,7 +681,7 @@ struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
 	if (!rc)
 		return sd;
 
-	sysfs_put(sd);
+	kernfs_put(sd);
 	return ERR_PTR(rc);
 }
 
@@ -716,14 +730,15 @@ static struct dentry *sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	if (parent_sd->s_flags & SYSFS_FLAG_NS)
 		ns = sysfs_info(dir->i_sb)->ns;
 
-	sd = sysfs_find_dirent(parent_sd, dentry->d_name.name, ns);
+	sd = kernfs_find_ns(parent_sd, dentry->d_name.name, ns);
 
 	/* no such entry */
 	if (!sd) {
 		ret = ERR_PTR(-ENOENT);
 		goto out_unlock;
 	}
-	dentry->d_fsdata = sysfs_get(sd);
+	kernfs_get(sd);
+	dentry->d_fsdata = sd;
 
 	/* attach dentry and inode */
 	inode = sysfs_get_inode(dir->i_sb, sd);
@@ -859,7 +874,7 @@ int kernfs_remove_by_name_ns(struct sysfs_dirent *dir_sd, const char *name,
 
 	sysfs_addrm_start(&acxt);
 
-	sd = sysfs_find_dirent(dir_sd, name, ns);
+	sd = kernfs_find_ns(dir_sd, name, ns);
 	if (sd)
 		__kernfs_remove(&acxt, sd);
 
@@ -925,7 +940,7 @@ int kernfs_rename_ns(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
 		goto out;	/* nothing to rename */
 
 	error = -EEXIST;
-	if (sysfs_find_dirent(new_parent, new_name, new_ns))
+	if (kernfs_find_ns(new_parent, new_name, new_ns))
 		goto out;
 
 	/* rename sysfs_dirent */
@@ -943,8 +958,8 @@ int kernfs_rename_ns(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
 	 * Move to the appropriate place in the appropriate directories rbtree.
 	 */
 	sysfs_unlink_sibling(sd);
-	sysfs_get(new_parent);
-	sysfs_put(sd->s_parent);
+	kernfs_get(new_parent);
+	kernfs_put(sd->s_parent);
 	sd->s_ns = new_ns;
 	sd->s_hash = sysfs_name_hash(sd->s_name, sd->s_ns);
 	sd->s_parent = new_parent;
@@ -1000,7 +1015,7 @@ static inline unsigned char dt_type(struct sysfs_dirent *sd)
 
 static int sysfs_dir_release(struct inode *inode, struct file *filp)
 {
-	sysfs_put(filp->private_data);
+	kernfs_put(filp->private_data);
 	return 0;
 }
 
@@ -1011,7 +1026,7 @@ static struct sysfs_dirent *sysfs_dir_pos(const void *ns,
 		int valid = !(pos->s_flags & SYSFS_FLAG_REMOVED) &&
 			pos->s_parent == parent_sd &&
 			hash == pos->s_hash;
-		sysfs_put(pos);
+		kernfs_put(pos);
 		if (!valid)
 			pos = NULL;
 	}
@@ -1075,8 +1090,10 @@ static int sysfs_readdir(struct file *file, struct dir_context *ctx)
 		unsigned int type = dt_type(pos);
 		int len = strlen(name);
 		ino_t ino = pos->s_ino;
+
 		ctx->pos = pos->s_hash;
-		file->private_data = sysfs_get(pos);
+		file->private_data = pos;
+		kernfs_get(pos);
 
 		mutex_unlock(&sysfs_mutex);
 		if (!dir_emit(ctx, name, len, ino, type))
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index e4eca28..7f0a79f 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -881,19 +881,19 @@ void sysfs_notify(struct kobject *k, const char *dir, const char *attr)
 	struct sysfs_dirent *sd = k->sd, *tmp;
 
 	if (sd && dir)
-		sd = sysfs_get_dirent(sd, dir);
+		sd = kernfs_find_and_get(sd, dir);
 	else
-		sysfs_get(sd);
+		kernfs_get(sd);
 
 	if (sd && attr) {
-		tmp = sysfs_get_dirent(sd, attr);
-		sysfs_put(sd);
+		tmp = kernfs_find_and_get(sd, attr);
+		kernfs_put(sd);
 		sd = tmp;
 	}
 
 	if (sd) {
 		kernfs_notify(sd);
-		sysfs_put(sd);
+		kernfs_put(sd);
 	}
 }
 EXPORT_SYMBOL_GPL(sysfs_notify);
@@ -1052,7 +1052,7 @@ struct sysfs_dirent *kernfs_create_file_ns_key(struct sysfs_dirent *parent,
 	sysfs_addrm_finish(&acxt);
 
 	if (rc) {
-		sysfs_put(sd);
+		kernfs_put(sd);
 		return ERR_PTR(rc);
 	}
 	return sd;
@@ -1106,16 +1106,18 @@ int sysfs_add_file_to_group(struct kobject *kobj,
 	struct sysfs_dirent *dir_sd;
 	int error;
 
-	if (group)
-		dir_sd = sysfs_get_dirent(kobj->sd, group);
-	else
-		dir_sd = sysfs_get(kobj->sd);
+	if (group) {
+		dir_sd = kernfs_find_and_get(kobj->sd, group);
+	} else {
+		dir_sd = kobj->sd;
+		kernfs_get(dir_sd);
+	}
 
 	if (!dir_sd)
 		return -ENOENT;
 
 	error = sysfs_add_file(dir_sd, attr, false);
-	sysfs_put(dir_sd);
+	kernfs_put(dir_sd);
 
 	return error;
 }
@@ -1135,7 +1137,7 @@ int sysfs_chmod_file(struct kobject *kobj, const struct attribute *attr,
 	struct iattr newattrs;
 	int rc;
 
-	sd = sysfs_get_dirent(kobj->sd, attr->name);
+	sd = kernfs_find_and_get(kobj->sd, attr->name);
 	if (!sd)
 		return -ENOENT;
 
@@ -1144,7 +1146,7 @@ int sysfs_chmod_file(struct kobject *kobj, const struct attribute *attr,
 
 	rc = kernfs_setattr(sd, &newattrs);
 
-	sysfs_put(sd);
+	kernfs_put(sd);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(sysfs_chmod_file);
@@ -1185,13 +1187,16 @@ void sysfs_remove_file_from_group(struct kobject *kobj,
 {
 	struct sysfs_dirent *dir_sd;
 
-	if (group)
-		dir_sd = sysfs_get_dirent(kobj->sd, group);
-	else
-		dir_sd = sysfs_get(kobj->sd);
+	if (group) {
+		dir_sd = kernfs_find_and_get(kobj->sd, group);
+	} else {
+		dir_sd = kobj->sd;
+		kernfs_get(dir_sd);
+	}
+
 	if (dir_sd) {
 		kernfs_remove_by_name(dir_sd, attr->name);
-		sysfs_put(dir_sd);
+		kernfs_put(dir_sd);
 	}
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_file_from_group);
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 9f65cd9..7177532 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -108,13 +108,13 @@ static int internal_create_group(struct kobject *kobj, int update,
 		}
 	} else
 		sd = kobj->sd;
-	sysfs_get(sd);
+	kernfs_get(sd);
 	error = create_files(sd, kobj, grp, update);
 	if (error) {
 		if (grp->name)
 			kernfs_remove(sd);
 	}
-	sysfs_put(sd);
+	kernfs_put(sd);
 	return error;
 }
 
@@ -208,21 +208,23 @@ void sysfs_remove_group(struct kobject *kobj,
 	struct sysfs_dirent *sd;
 
 	if (grp->name) {
-		sd = sysfs_get_dirent(dir_sd, grp->name);
+		sd = kernfs_find_and_get(dir_sd, grp->name);
 		if (!sd) {
 			WARN(!sd, KERN_WARNING
 			     "sysfs group %p not found for kobject '%s'\n",
 			     grp, kobject_name(kobj));
 			return;
 		}
-	} else
-		sd = sysfs_get(dir_sd);
+	} else {
+		sd = dir_sd;
+		kernfs_get(sd);
+	}
 
 	remove_files(sd, kobj, grp);
 	if (grp->name)
 		kernfs_remove(sd);
 
-	sysfs_put(sd);
+	kernfs_put(sd);
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_group);
 
@@ -263,7 +265,7 @@ int sysfs_merge_group(struct kobject *kobj,
 	struct attribute *const *attr;
 	int i;
 
-	dir_sd = sysfs_get_dirent(kobj->sd, grp->name);
+	dir_sd = kernfs_find_and_get(kobj->sd, grp->name);
 	if (!dir_sd)
 		return -ENOENT;
 
@@ -273,7 +275,7 @@ int sysfs_merge_group(struct kobject *kobj,
 		while (--i >= 0)
 			kernfs_remove_by_name(dir_sd, (*--attr)->name);
 	}
-	sysfs_put(dir_sd);
+	kernfs_put(dir_sd);
 
 	return error;
 }
@@ -290,11 +292,11 @@ void sysfs_unmerge_group(struct kobject *kobj,
 	struct sysfs_dirent *dir_sd;
 	struct attribute *const *attr;
 
-	dir_sd = sysfs_get_dirent(kobj->sd, grp->name);
+	dir_sd = kernfs_find_and_get(kobj->sd, grp->name);
 	if (dir_sd) {
 		for (attr = grp->attrs; *attr; ++attr)
 			kernfs_remove_by_name(dir_sd, (*attr)->name);
-		sysfs_put(dir_sd);
+		kernfs_put(dir_sd);
 	}
 }
 EXPORT_SYMBOL_GPL(sysfs_unmerge_group);
@@ -312,12 +314,12 @@ int sysfs_add_link_to_group(struct kobject *kobj, const char *group_name,
 	struct sysfs_dirent *dir_sd;
 	int error = 0;
 
-	dir_sd = sysfs_get_dirent(kobj->sd, group_name);
+	dir_sd = kernfs_find_and_get(kobj->sd, group_name);
 	if (!dir_sd)
 		return -ENOENT;
 
 	error = sysfs_create_link_sd(dir_sd, target, link_name);
-	sysfs_put(dir_sd);
+	kernfs_put(dir_sd);
 
 	return error;
 }
@@ -334,10 +336,10 @@ void sysfs_remove_link_from_group(struct kobject *kobj, const char *group_name,
 {
 	struct sysfs_dirent *dir_sd;
 
-	dir_sd = sysfs_get_dirent(kobj->sd, group_name);
+	dir_sd = kernfs_find_and_get(kobj->sd, group_name);
 	if (dir_sd) {
 		kernfs_remove_by_name(dir_sd, link_name);
-		sysfs_put(dir_sd);
+		kernfs_put(dir_sd);
 	}
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_link_from_group);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index b3c717a..bfe4478 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -254,7 +254,8 @@ int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 
 static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
-	inode->i_private = sysfs_get(sd);
+	kernfs_get(sd);
+	inode->i_private = sd;
 	inode->i_mapping->a_ops = &sysfs_aops;
 	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 	inode->i_op = &sysfs_inode_operations;
@@ -321,7 +322,7 @@ void sysfs_evict_inode(struct inode *inode)
 
 	truncate_inode_pages(&inode->i_data, 0);
 	clear_inode(inode);
-	sysfs_put(sd);
+	kernfs_put(sd);
 }
 
 int sysfs_permission(struct inode *inode, int mask)
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 8c24bce..852d115 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -184,17 +184,3 @@ out_err:
 	sysfs_dir_cachep = NULL;
 	goto out;
 }
-
-#undef sysfs_get
-struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
-{
-	return __sysfs_get(sd);
-}
-EXPORT_SYMBOL_GPL(sysfs_get);
-
-#undef sysfs_put
-void sysfs_put(struct sysfs_dirent *sd)
-{
-	__sysfs_put(sd);
-}
-EXPORT_SYMBOL_GPL(sysfs_put);
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 76efeab..b137aa3 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -44,7 +44,7 @@ struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
 	if (parent->s_flags & SYSFS_FLAG_NS)
 		sd->s_ns = target->s_ns;
 	sd->s_symlink.target_sd = target;
-	sysfs_get(target);	/* ref owned by symlink */
+	kernfs_get(target);	/* ref owned by symlink */
 
 	sysfs_addrm_start(&acxt);
 	error = sysfs_add_one(&acxt, sd, parent);
@@ -53,7 +53,7 @@ struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
 	if (!error)
 		return sd;
 
-	sysfs_put(sd);
+	kernfs_put(sd);
 	return ERR_PTR(error);
 }
 
@@ -72,15 +72,17 @@ static int sysfs_do_create_link_sd(struct sysfs_dirent *parent_sd,
 	 * sysfs_remove_dir() for details.
 	 */
 	spin_lock(&sysfs_symlink_target_lock);
-	if (target->sd)
-		target_sd = sysfs_get(target->sd);
+	if (target->sd) {
+		target_sd = target->sd;
+		kernfs_get(target_sd);
+	}
 	spin_unlock(&sysfs_symlink_target_lock);
 
 	if (!target_sd)
 		return -ENOENT;
 
 	sd = kernfs_create_link(parent_sd, name, target_sd);
-	sysfs_put(target_sd);
+	kernfs_put(target_sd);
 
 	if (!IS_ERR(sd))
 		return 0;
@@ -216,7 +218,7 @@ int sysfs_rename_link_ns(struct kobject *kobj, struct kobject *targ,
 		old_ns = targ->sd->s_ns;
 
 	result = -ENOENT;
-	sd = sysfs_get_dirent_ns(parent_sd, old, old_ns);
+	sd = kernfs_find_and_get_ns(parent_sd, old, old_ns);
 	if (!sd)
 		goto out;
 
@@ -229,7 +231,7 @@ int sysfs_rename_link_ns(struct kobject *kobj, struct kobject *targ,
 	result = kernfs_rename_ns(sd, parent_sd, new, new_ns);
 
 out:
-	sysfs_put(sd);
+	kernfs_put(sd);
 	return result;
 }
 EXPORT_SYMBOL_GPL(sysfs_rename_link_ns);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index e93f8b8..85315e2 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -141,30 +141,8 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		  struct sysfs_dirent *parent_sd);
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
 
-struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
-				       const unsigned char *name,
-				       const void *ns);
 struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type);
 
-void release_sysfs_dirent(struct sysfs_dirent *sd);
-
-static inline struct sysfs_dirent *__sysfs_get(struct sysfs_dirent *sd)
-{
-	if (sd) {
-		WARN_ON(!atomic_read(&sd->s_count));
-		atomic_inc(&sd->s_count);
-	}
-	return sd;
-}
-#define sysfs_get(sd) __sysfs_get(sd)
-
-static inline void __sysfs_put(struct sysfs_dirent *sd)
-{
-	if (sd && atomic_dec_and_test(&sd->s_count))
-		release_sysfs_dirent(sd);
-}
-#define sysfs_put(sd) __sysfs_put(sd)
-
 /*
  * inode.c
  */
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 105d09d..fd8f574 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -71,6 +71,11 @@ struct kernfs_ops {
 
 #ifdef CONFIG_SYSFS
 
+struct sysfs_dirent *kernfs_find_and_get_ns(struct sysfs_dirent *parent,
+					    const char *name, const void *ns);
+void kernfs_get(struct sysfs_dirent *sd);
+void kernfs_put(struct sysfs_dirent *sd);
+
 struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
 					  const char *name, void *priv,
 					  const void *ns);
@@ -95,6 +100,14 @@ void kernfs_notify(struct sysfs_dirent *sd);
 #else	/* CONFIG_SYSFS */
 
 static inline struct sysfs_dirent *
+kernfs_find_and_get_ns(struct sysfs_dirent *parent, const char *name,
+		       const void *ns)
+{ return NULL; }
+
+static inline void kernfs_get(struct sysfs_dirent *sd) { }
+static inline void kernfs_put(struct sysfs_dirent *sd) { }
+
+static inline struct sysfs_dirent *
 kernfs_create_dir_ns(struct sysfs_dirent *parent, const char *name, void *priv,
 		     const void *ns)
 { return ERR_PTR(-ENOSYS); }
@@ -133,6 +146,12 @@ static inline void kernfs_notify(struct sysfs_dirent *sd) { }
 #endif	/* CONFIG_SYSFS */
 
 static inline struct sysfs_dirent *
+kernfs_find_and_get(struct sysfs_dirent *sd, const char *name)
+{
+	return kernfs_find_and_get_ns(sd, name, NULL);
+}
+
+static inline struct sysfs_dirent *
 kernfs_create_dir(struct sysfs_dirent *parent, const char *name, void *priv)
 {
 	return kernfs_create_dir_ns(parent, name, priv, NULL);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 0ab2b02..cd8f90b 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -243,11 +243,6 @@ void sysfs_remove_link_from_group(struct kobject *kobj, const char *group_name,
 				  const char *link_name);
 
 void sysfs_notify(struct kobject *kobj, const char *dir, const char *attr);
-struct sysfs_dirent *sysfs_get_dirent_ns(struct sysfs_dirent *parent_sd,
-					 const unsigned char *name,
-					 const void *ns);
-struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd);
-void sysfs_put(struct sysfs_dirent *sd);
 
 int __must_check sysfs_init(void);
 
@@ -417,19 +412,6 @@ static inline void sysfs_notify(struct kobject *kobj, const char *dir,
 				const char *attr)
 {
 }
-static inline struct sysfs_dirent *
-sysfs_get_dirent_ns(struct sysfs_dirent *parent_sd, const unsigned char *name,
-		    const void *ns)
-{
-	return NULL;
-}
-static inline struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
-{
-	return NULL;
-}
-static inline void sysfs_put(struct sysfs_dirent *sd)
-{
-}
 
 static inline int __must_check sysfs_init(void)
 {
@@ -456,15 +438,26 @@ static inline int sysfs_rename_link(struct kobject *kobj, struct kobject *target
 	return sysfs_rename_link_ns(kobj, target, old_name, new_name, NULL);
 }
 
+static inline void sysfs_notify_dirent(struct sysfs_dirent *sd)
+{
+	kernfs_notify(sd);
+}
+
 static inline struct sysfs_dirent *
 sysfs_get_dirent(struct sysfs_dirent *parent_sd, const unsigned char *name)
 {
-	return sysfs_get_dirent_ns(parent_sd, name, NULL);
+	return kernfs_find_and_get(parent_sd, name);
 }
 
-static inline void sysfs_notify_dirent(struct sysfs_dirent *sd)
+static inline struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
 {
-	kernfs_notify(sd);
+	kernfs_get(sd);
+	return sd;
+}
+
+static inline void sysfs_put(struct sysfs_dirent *sd)
+{
+	kernfs_put(sd);
 }
 
 #endif /* _SYSFS_H_ */
-- 
1.8.4.2

