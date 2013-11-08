Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3KHJDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:03:16 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43268 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3KHJDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:03:08 -0500
Date: Fri, 8 Nov 2013 18:03:03 +0900
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: drop kobj_ns_type handling, take #2
Message-ID: <20131108090303.GA30857@mtj.dyndns.org>
References: <20131106225139.GA8393@kroah.com>
 <CA+55aFyANE=tuor8ATzrW6xV7DBoo2CCSiS4ZF-XNCYNfoqd2g@mail.gmail.com>
 <CA+55aFyDq4qahA4FovWr0ogWE_iWNriMaFbaQd92k3JSE+_M9w@mail.gmail.com>
 <CA+55aFxTrtgoWpzqoNk6ntDRK2n-PNj1kkYodtytWnHO87XUtQ@mail.gmail.com>
 <20131107092949.GA32091@mtj.dyndns.org>
 <CA+55aFw4_-HWME5z2sf3cD57up3+U09z03FbHk3onwOzHmU7Hg@mail.gmail.com>
 <CA+55aFzamDk3HnfHcx-2diSnvGzw4VpOo3fmOxG2Z2YvLisMcw@mail.gmail.com>
 <20131108045339.GA18374@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108045339.GA18374@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, (Eric and lkml cc'd)

So, something like the following.  I'll queue it at the head of the
pending sysfs, kernfs patches.

Thanks.

------ 8< -------
The way namespace tags are implemented in sysfs is more complicated
than necessary.  As each tag is a pointer value and required to be
non-NULL under a namespace enabled parent, there's no need to record
separately what type each tag is.  If multiple namespace types are
needed, which currently aren't, we can simply compare the tag to a set
of allowed tags in the superblock assuming that the tags, being
pointers, won't have the same value across multiple types.

This patch rips out kobj_ns_type handling from sysfs.  sysfs now has
an enable switch to turn on namespace under a node.  If enabled, all
children are required to have non-NULL namespace tags and filtered
against the super_block's tag.

kobject namespace determination is now performed in
lib/kobject.c::create_dir() making sysfs_read_ns_type() unnecessary.
The sanity checks are also moved.  create_dir() is restructured to
ease such addition.  This removes most kobject namespace knowledge
from sysfs proper which will enable proper separation and layering of
sysfs.

This is the second try.  The first one was cb26a311578e ("sysfs: drop
kobj_ns_type handling") which tried to automatically enable namespace
if there are children with non-NULL namespace tags; however, it was
broken for symlinks as they should inherit the target's tag iff
namespace is enabled in the parent.  This led to namespace filtering
enabled incorrectly for wireless net class devices through phy80211
symlinks and thus network configuration failure.  a1212d278c05
("Revert "sysfs: drop kobj_ns_type handling"") reverted the commit.

This shouldn't introduce any behavior changes, for real.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/dir.c        |   92 +++++++++++++++++++-------------------------------
 fs/sysfs/mount.c      |   24 +++----------
 fs/sysfs/symlink.c    |   26 +++-----------
 fs/sysfs/sysfs.h      |   25 +++----------
 include/linux/sysfs.h |    2 +
 lib/kobject.c         |   27 +++++++++++---
 6 files changed, 79 insertions(+), 117 deletions(-)

--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -279,7 +279,6 @@ static int sysfs_dentry_delete(const str
 static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct sysfs_dirent *sd;
-	int type;
 
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
@@ -300,13 +299,9 @@ static int sysfs_dentry_revalidate(struc
 		goto out_bad;
 
 	/* The sysfs dirent has been moved to a different namespace */
-	type = KOBJ_NS_TYPE_NONE;
-	if (sd->s_parent) {
-		type = sysfs_ns_type(sd->s_parent);
-		if (type != KOBJ_NS_TYPE_NONE &&
-				sysfs_info(dentry->d_sb)->ns[type] != sd->s_ns)
-			goto out_bad;
-	}
+	if (sd->s_parent && (sd->s_parent->s_flags & SYSFS_FLAG_NS) &&
+	    sysfs_info(dentry->d_sb)->ns != sd->s_ns)
+		goto out_bad;
 
 	mutex_unlock(&sysfs_mutex);
 out_valid:
@@ -423,13 +418,14 @@ void sysfs_addrm_start(struct sysfs_addr
 int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		    struct sysfs_dirent *parent_sd)
 {
+	bool has_ns = parent_sd->s_flags & SYSFS_FLAG_NS;
 	struct sysfs_inode_attrs *ps_iattr;
 	int ret;
 
-	if (!!sysfs_ns_type(parent_sd) != !!sd->s_ns) {
+	if (has_ns != (bool)sd->s_ns) {
 		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
-			sysfs_ns_type(parent_sd) ? "required" : "invalid",
-			parent_sd->s_name, sd->s_name);
+		     has_ns ? "required" : "invalid",
+		     parent_sd->s_name, sd->s_name);
 		return -EINVAL;
 	}
 
@@ -610,12 +606,13 @@ struct sysfs_dirent *sysfs_find_dirent(s
 				       const void *ns)
 {
 	struct rb_node *node = parent_sd->s_dir.children.rb_node;
+	bool has_ns = parent_sd->s_flags & SYSFS_FLAG_NS;
 	unsigned int hash;
 
-	if (!!sysfs_ns_type(parent_sd) != !!ns) {
+	if (has_ns != (bool)ns) {
 		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
-			sysfs_ns_type(parent_sd) ? "required" : "invalid",
-			parent_sd->s_name, name);
+		     has_ns ? "required" : "invalid",
+		     parent_sd->s_name, name);
 		return NULL;
 	}
 
@@ -667,7 +664,6 @@ struct sysfs_dirent *sysfs_get_dirent_ns
 EXPORT_SYMBOL_GPL(sysfs_get_dirent_ns);
 
 static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
-		      enum kobj_ns_type type,
 		      const char *name, const void *ns,
 		      struct sysfs_dirent **p_sd)
 {
@@ -681,7 +677,6 @@ static int create_dir(struct kobject *ko
 	if (!sd)
 		return -ENOMEM;
 
-	sd->s_flags |= (type << SYSFS_NS_TYPE_SHIFT);
 	sd->s_ns = ns;
 	sd->s_dir.kobj = kobj;
 
@@ -701,33 +696,7 @@ static int create_dir(struct kobject *ko
 int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			struct sysfs_dirent **p_sd)
 {
-	return create_dir(kobj, kobj->sd,
-			  KOBJ_NS_TYPE_NONE, name, NULL, p_sd);
-}
-
-/**
- *	sysfs_read_ns_type: return associated ns_type
- *	@kobj: the kobject being queried
- *
- *	Each kobject can be tagged with exactly one namespace type
- *	(i.e. network or user).  Return the ns_type associated with
- *	this object if any
- */
-static enum kobj_ns_type sysfs_read_ns_type(struct kobject *kobj)
-{
-	const struct kobj_ns_type_operations *ops;
-	enum kobj_ns_type type;
-
-	ops = kobj_child_ns_ops(kobj);
-	if (!ops)
-		return KOBJ_NS_TYPE_NONE;
-
-	type = ops->type;
-	BUG_ON(type <= KOBJ_NS_TYPE_NONE);
-	BUG_ON(type >= KOBJ_NS_TYPES);
-	BUG_ON(!kobj_ns_type_registered(type));
-
-	return type;
+	return create_dir(kobj, kobj->sd, name, NULL, p_sd);
 }
 
 /**
@@ -737,7 +706,6 @@ static enum kobj_ns_type sysfs_read_ns_t
  */
 int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
 {
-	enum kobj_ns_type type;
 	struct sysfs_dirent *parent_sd, *sd;
 	int error = 0;
 
@@ -751,9 +719,7 @@ int sysfs_create_dir_ns(struct kobject *
 	if (!parent_sd)
 		return -ENOENT;
 
-	type = sysfs_read_ns_type(kobj);
-
-	error = create_dir(kobj, parent_sd, type, kobject_name(kobj), ns, &sd);
+	error = create_dir(kobj, parent_sd, kobject_name(kobj), ns, &sd);
 	if (!error)
 		kobj->sd = sd;
 	return error;
@@ -767,13 +733,12 @@ static struct dentry *sysfs_lookup(struc
 	struct sysfs_dirent *parent_sd = parent->d_fsdata;
 	struct sysfs_dirent *sd;
 	struct inode *inode;
-	enum kobj_ns_type type;
-	const void *ns;
+	const void *ns = NULL;
 
 	mutex_lock(&sysfs_mutex);
 
-	type = sysfs_ns_type(parent_sd);
-	ns = sysfs_info(dir->i_sb)->ns[type];
+	if (parent_sd->s_flags & SYSFS_FLAG_NS)
+		ns = sysfs_info(dir->i_sb)->ns;
 
 	sd = sysfs_find_dirent(parent_sd, dentry->d_name.name, ns);
 
@@ -1029,6 +994,21 @@ int sysfs_move_dir_ns(struct kobject *ko
 	return sysfs_rename(sd, new_parent_sd, sd->s_name, new_ns);
 }
 
+/**
+ * sysfs_enable_ns - enable namespace under a directory
+ * @sd: directory of interest, should be empty
+ *
+ * This is to be called right after @sd is created to enable namespace
+ * under it.  All children of @sd must have non-NULL namespace tags and
+ * only the ones which match the super_block's tag will be visible.
+ */
+void sysfs_enable_ns(struct sysfs_dirent *sd)
+{
+	WARN_ON_ONCE(sysfs_type(sd) != SYSFS_DIR);
+	WARN_ON_ONCE(!RB_EMPTY_ROOT(&sd->s_dir.children));
+	sd->s_flags |= SYSFS_FLAG_NS;
+}
+
 /* Relationship between s_mode and the DT_xxx types */
 static inline unsigned char dt_type(struct sysfs_dirent *sd)
 {
@@ -1096,15 +1076,15 @@ static int sysfs_readdir(struct file *fi
 	struct dentry *dentry = file->f_path.dentry;
 	struct sysfs_dirent *parent_sd = dentry->d_fsdata;
 	struct sysfs_dirent *pos = file->private_data;
-	enum kobj_ns_type type;
-	const void *ns;
-
-	type = sysfs_ns_type(parent_sd);
-	ns = sysfs_info(dentry->d_sb)->ns[type];
+	const void *ns = NULL;
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 	mutex_lock(&sysfs_mutex);
+
+	if (parent_sd->s_flags & SYSFS_FLAG_NS)
+		ns = sysfs_info(dentry->d_sb)->ns;
+
 	for (pos = sysfs_dir_pos(ns, parent_sd, ctx->pos, pos);
 	     pos;
 	     pos = sysfs_dir_next_pos(ns, parent_sd, ctx->pos, pos)) {
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -36,7 +36,7 @@ static const struct super_operations sys
 struct sysfs_dirent sysfs_root = {
 	.s_name		= "",
 	.s_count	= ATOMIC_INIT(1),
-	.s_flags	= SYSFS_DIR | (KOBJ_NS_TYPE_NONE << SYSFS_NS_TYPE_SHIFT),
+	.s_flags	= SYSFS_DIR,
 	.s_mode		= S_IFDIR | S_IRUGO | S_IXUGO,
 	.s_ino		= 1,
 };
@@ -77,14 +77,8 @@ static int sysfs_test_super(struct super
 {
 	struct sysfs_super_info *sb_info = sysfs_info(sb);
 	struct sysfs_super_info *info = data;
-	enum kobj_ns_type type;
-	int found = 1;
 
-	for (type = KOBJ_NS_TYPE_NONE; type < KOBJ_NS_TYPES; type++) {
-		if (sb_info->ns[type] != info->ns[type])
-			found = 0;
-	}
-	return found;
+	return sb_info->ns == info->ns;
 }
 
 static int sysfs_set_super(struct super_block *sb, void *data)
@@ -98,9 +92,7 @@ static int sysfs_set_super(struct super_
 
 static void free_sysfs_super_info(struct sysfs_super_info *info)
 {
-	int type;
-	for (type = KOBJ_NS_TYPE_NONE; type < KOBJ_NS_TYPES; type++)
-		kobj_ns_drop(type, info->ns[type]);
+	kobj_ns_drop(KOBJ_NS_TYPE_NET, info->ns);
 	kfree(info);
 }
 
@@ -108,7 +100,6 @@ static struct dentry *sysfs_mount(struct
 	int flags, const char *dev_name, void *data)
 {
 	struct sysfs_super_info *info;
-	enum kobj_ns_type type;
 	struct super_block *sb;
 	int error;
 
@@ -116,18 +107,15 @@ static struct dentry *sysfs_mount(struct
 		if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type))
 			return ERR_PTR(-EPERM);
 
-		for (type = KOBJ_NS_TYPE_NONE; type < KOBJ_NS_TYPES; type++) {
-			if (!kobj_ns_current_may_mount(type))
-				return ERR_PTR(-EPERM);
-		}
+		if (!kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET))
+			return ERR_PTR(-EPERM);
 	}
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return ERR_PTR(-ENOMEM);
 
-	for (type = KOBJ_NS_TYPE_NONE; type < KOBJ_NS_TYPES; type++)
-		info->ns[type] = kobj_ns_grab_current(type);
+	info->ns = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
 
 	sb = sget(fs_type, sysfs_test_super, sysfs_set_super, flags, info);
 	if (IS_ERR(sb) || sb->s_fs_info != info)
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -28,7 +28,6 @@ static int sysfs_do_create_link_sd(struc
 	struct sysfs_dirent *target_sd = NULL;
 	struct sysfs_dirent *sd = NULL;
 	struct sysfs_addrm_cxt acxt;
-	enum kobj_ns_type ns_type;
 	int error;
 
 	BUG_ON(!name || !parent_sd);
@@ -52,29 +51,16 @@ static int sysfs_do_create_link_sd(struc
 	if (!sd)
 		goto out_put;
 
-	ns_type = sysfs_ns_type(parent_sd);
-	if (ns_type)
+	if (parent_sd->s_flags & SYSFS_FLAG_NS)
 		sd->s_ns = target_sd->s_ns;
 	sd->s_symlink.target_sd = target_sd;
 	target_sd = NULL;	/* reference is now owned by the symlink */
 
 	sysfs_addrm_start(&acxt);
-	/* Symlinks must be between directories with the same ns_type */
-	if (!ns_type ||
-	    (ns_type == sysfs_ns_type(sd->s_symlink.target_sd->s_parent))) {
-		if (warn)
-			error = sysfs_add_one(&acxt, sd, parent_sd);
-		else
-			error = __sysfs_add_one(&acxt, sd, parent_sd);
-	} else {
-		error = -EINVAL;
-		WARN(1, KERN_WARNING
-			"sysfs: symlink across ns_types %s/%s -> %s/%s\n",
-			parent_sd->s_name,
-			sd->s_name,
-			sd->s_symlink.target_sd->s_parent->s_name,
-			sd->s_symlink.target_sd->s_name);
-	}
+	if (warn)
+		error = sysfs_add_one(&acxt, sd, parent_sd);
+	else
+		error = __sysfs_add_one(&acxt, sd, parent_sd);
 	sysfs_addrm_finish(&acxt);
 
 	if (error)
@@ -164,7 +150,7 @@ void sysfs_delete_link(struct kobject *k
 	 * sysfs_remove_dir() for details.
 	 */
 	spin_lock(&sysfs_symlink_target_lock);
-	if (targ->sd && sysfs_ns_type(kobj->sd))
+	if (targ->sd && (kobj->sd->s_flags & SYSFS_FLAG_NS))
 		ns = targ->sd->s_ns;
 	spin_unlock(&sysfs_symlink_target_lock);
 	sysfs_hash_and_remove(kobj->sd, name, ns);
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -90,11 +90,8 @@ struct sysfs_dirent {
 #define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
 #define SYSFS_ACTIVE_REF		(SYSFS_KOBJ_ATTR | SYSFS_KOBJ_BIN_ATTR)
 
-/* identify any namespace tag on sysfs_dirents */
-#define SYSFS_NS_TYPE_MASK		0xf00
-#define SYSFS_NS_TYPE_SHIFT		8
-
-#define SYSFS_FLAG_MASK			~(SYSFS_NS_TYPE_MASK|SYSFS_TYPE_MASK)
+#define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
+#define SYSFS_FLAG_NS			0x01000
 #define SYSFS_FLAG_REMOVED		0x02000
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
@@ -102,15 +99,6 @@ static inline unsigned int sysfs_type(st
 	return sd->s_flags & SYSFS_TYPE_MASK;
 }
 
-/*
- * Return any namespace tags on this dirent.
- * enum kobj_ns_type is defined in linux/kobject.h
- */
-static inline enum kobj_ns_type sysfs_ns_type(struct sysfs_dirent *sd)
-{
-	return (sd->s_flags & SYSFS_NS_TYPE_MASK) >> SYSFS_NS_TYPE_SHIFT;
-}
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 #define sysfs_dirent_init_lockdep(sd)				\
@@ -155,12 +143,13 @@ struct sysfs_addrm_cxt {
  */
 
 /*
- * Each sb is associated with a set of namespace tags (i.e.
- * the network namespace of the task which mounted this sysfs
- * instance).
+ * Each sb is associated with one namespace tag, currently the network
+ * namespace of the task which mounted this sysfs instance.  If multiple
+ * tags become necessary, make the following an array and compare
+ * sysfs_dirent tag against every entry.
  */
 struct sysfs_super_info {
-	void *ns[KOBJ_NS_TYPES];
+	void *ns;
 };
 #define sysfs_info(SB) ((struct sysfs_super_info *)(SB->s_fs_info))
 extern struct sysfs_dirent sysfs_root;
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -220,6 +220,8 @@ int sysfs_rename_link_ns(struct kobject
 void sysfs_delete_link(struct kobject *dir, struct kobject *targ,
 			const char *name);
 
+void sysfs_enable_ns(struct sysfs_dirent *sd);
+
 int __must_check sysfs_create_group(struct kobject *kobj,
 				    const struct attribute_group *grp);
 int __must_check sysfs_create_groups(struct kobject *kobj,
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -65,13 +65,17 @@ static int populate_dir(struct kobject *
 
 static int create_dir(struct kobject *kobj)
 {
+	const struct kobj_ns_type_operations *ops;
 	int error;
 
 	error = sysfs_create_dir_ns(kobj, kobject_namespace(kobj));
-	if (!error) {
-		error = populate_dir(kobj);
-		if (error)
-			sysfs_remove_dir(kobj);
+	if (error)
+		return error;
+
+	error = populate_dir(kobj);
+	if (error) {
+		sysfs_remove_dir(kobj);
+		return error;
 	}
 
 	/*
@@ -80,7 +84,20 @@ static int create_dir(struct kobject *ko
 	 */
 	sysfs_get(kobj->sd);
 
-	return error;
+	/*
+	 * If @kobj has ns_ops, its children need to be filtered based on
+	 * their namespace tags.  Enable namespace support on @kobj->sd.
+	 */
+	ops = kobj_child_ns_ops(kobj);
+	if (ops) {
+		BUG_ON(ops->type <= KOBJ_NS_TYPE_NONE);
+		BUG_ON(ops->type >= KOBJ_NS_TYPES);
+		BUG_ON(!kobj_ns_type_registered(ops->type));
+
+		sysfs_enable_ns(kobj->sd);
+	}
+
+	return 0;
 }
 
 static int get_kobj_path_length(struct kobject *kobj)
