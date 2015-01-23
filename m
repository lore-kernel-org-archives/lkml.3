Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbbAWQ0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:26:31 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:11023 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755562AbbAWQYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:24:16 -0500
Message-Id: <20150123162414.273572134@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 23 Jan 2015 10:55:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/5 v2] tracefs: Add new tracefs file system
References: <20150123155525.795129339@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-tracefs-Add-new-tracefs-file-system.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a separate file system to handle the tracing directory. Currently it
is part of debugfs, but that is starting to show its limits.

One thing is that in order to access the tracing infrastructure, you need
to mount debugfs. As that includes debugging from all sorts of sub systems
in the kernel, it is not considered advisable to mount such an all
encompassing debugging system.

Having the tracing system in its own file systems gives access to the
tracing sub system without needing to include all other systems.

Another problem with tracing using the debugfs system is that the
instances use mkdir to create sub buffers. debugfs does not support mkdir
from userspace so to implement it, special hacks were used. By controlling
the file system that the tracing infrastructure uses, this can be properly
done without hacks.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/Makefile                |   1 +
 fs/tracefs/Makefile        |   4 +
 fs/tracefs/inode.c         | 560 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/tracefs.h    |  41 ++++
 include/uapi/linux/magic.h |   2 +
 5 files changed, 608 insertions(+)
 create mode 100644 fs/tracefs/Makefile
 create mode 100644 fs/tracefs/inode.c
 create mode 100644 include/linux/tracefs.h

diff --git a/fs/Makefile b/fs/Makefile
index bedff48e8fdc..d244b8d973ac 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -118,6 +118,7 @@ obj-$(CONFIG_HOSTFS)		+= hostfs/
 obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_CACHEFILES)	+= cachefiles/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
+obj-$(CONFIG_TRACING)		+= tracefs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
diff --git a/fs/tracefs/Makefile b/fs/tracefs/Makefile
new file mode 100644
index 000000000000..82fa35b656c4
--- /dev/null
+++ b/fs/tracefs/Makefile
@@ -0,0 +1,4 @@
+tracefs-objs	:= inode.o
+
+obj-$(CONFIG_TRACING)	+= tracefs.o
+
diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
new file mode 100644
index 000000000000..c31997a303c7
--- /dev/null
+++ b/fs/tracefs/inode.c
@@ -0,0 +1,560 @@
+/*
+ *  inode.c - part of tracefs, a pseudo file system for activating tracing
+ *
+ * Based on debugfs by: Greg Kroah-Hartman <greg@kroah.com>
+ *
+ *  Copyright (C) 2014 Red Hat Inc, author: Steven Rostedt <srostedt@redhat.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License version
+ *	2 as published by the Free Software Foundation.
+ *
+ * tracefs is the file system that is used by the tracing infrastructure.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/tracefs.h>
+#include <linux/fsnotify.h>
+#include <linux/seq_file.h>
+#include <linux/parser.h>
+#include <linux/magic.h>
+#include <linux/slab.h>
+
+#define TRACEFS_DEFAULT_MODE	0700
+
+static struct vfsmount *tracefs_mount;
+static int tracefs_mount_count;
+static bool tracefs_registered;
+
+static ssize_t default_read_file(struct file *file, char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	return 0;
+}
+
+static ssize_t default_write_file(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	return count;
+}
+
+static const struct file_operations tracefs_file_operations = {
+	.read =		default_read_file,
+	.write =	default_write_file,
+	.open =		simple_open,
+	.llseek =	noop_llseek,
+};
+
+static struct inode *tracefs_get_inode(struct super_block *sb, umode_t mode, dev_t dev,
+				      void *data, const struct file_operations *fops)
+
+{
+	struct inode *inode = new_inode(sb);
+
+	if (inode) {
+		inode->i_ino = get_next_ino();
+		inode->i_mode = mode;
+		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		switch (mode & S_IFMT) {
+		default:
+			init_special_inode(inode, mode, dev);
+			break;
+		case S_IFREG:
+			inode->i_fop = fops ? fops : &tracefs_file_operations;
+			inode->i_private = data;
+			break;
+		case S_IFDIR:
+			inode->i_op = &simple_dir_inode_operations;
+			inode->i_fop = &simple_dir_operations;
+
+			/* directory inodes start off with i_nlink == 2
+			 * (for "." entry) */
+			inc_nlink(inode);
+			break;
+		}
+	}
+	return inode;
+}
+
+static int tracefs_mknod(struct inode *dir, struct dentry *dentry,
+			 umode_t mode, dev_t dev, void *data,
+			 const struct file_operations *fops)
+{
+	struct inode *inode;
+	int error = -EPERM;
+
+	if (dentry->d_inode)
+		return -EEXIST;
+
+	inode = tracefs_get_inode(dir->i_sb, mode, dev, data, fops);
+	if (inode) {
+		d_instantiate(dentry, inode);
+		dget(dentry);
+		error = 0;
+	}
+	return error;
+}
+
+static int tracefs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
+{
+	int res;
+
+	mode = (mode & (S_IRWXUGO | S_ISVTX)) | S_IFDIR;
+	res = tracefs_mknod(dir, dentry, mode, 0, NULL, NULL);
+	if (!res) {
+		inc_nlink(dir);
+		fsnotify_mkdir(dir, dentry);
+	}
+	return res;
+}
+
+static int tracefs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
+			  void *data, const struct file_operations *fops)
+{
+	int res;
+
+	mode = (mode & S_IALLUGO) | S_IFREG;
+	res = tracefs_mknod(dir, dentry, mode, 0, data, fops);
+	if (!res)
+		fsnotify_create(dir, dentry);
+	return res;
+}
+
+struct tracefs_mount_opts {
+	kuid_t uid;
+	kgid_t gid;
+	umode_t mode;
+};
+
+enum {
+	Opt_uid,
+	Opt_gid,
+	Opt_mode,
+	Opt_err
+};
+
+static const match_table_t tokens = {
+	{Opt_uid, "uid=%u"},
+	{Opt_gid, "gid=%u"},
+	{Opt_mode, "mode=%o"},
+	{Opt_err, NULL}
+};
+
+struct tracefs_fs_info {
+	struct tracefs_mount_opts mount_opts;
+};
+
+static int tracefs_parse_options(char *data, struct tracefs_mount_opts *opts)
+{
+	substring_t args[MAX_OPT_ARGS];
+	int option;
+	int token;
+	kuid_t uid;
+	kgid_t gid;
+	char *p;
+
+	opts->mode = TRACEFS_DEFAULT_MODE;
+
+	while ((p = strsep(&data, ",")) != NULL) {
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_uid:
+			if (match_int(&args[0], &option))
+				return -EINVAL;
+			uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(uid))
+				return -EINVAL;
+			opts->uid = uid;
+			break;
+		case Opt_gid:
+			if (match_int(&args[0], &option))
+				return -EINVAL;
+			gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(gid))
+				return -EINVAL;
+			opts->gid = gid;
+			break;
+		case Opt_mode:
+			if (match_octal(&args[0], &option))
+				return -EINVAL;
+			opts->mode = option & S_IALLUGO;
+			break;
+		/*
+		 * We might like to report bad mount options here;
+		 * but traditionally tracefs has ignored all mount options
+		 */
+		}
+	}
+
+	return 0;
+}
+
+static int tracefs_apply_options(struct super_block *sb)
+{
+	struct tracefs_fs_info *fsi = sb->s_fs_info;
+	struct inode *inode = sb->s_root->d_inode;
+	struct tracefs_mount_opts *opts = &fsi->mount_opts;
+
+	inode->i_mode &= ~S_IALLUGO;
+	inode->i_mode |= opts->mode;
+
+	inode->i_uid = opts->uid;
+	inode->i_gid = opts->gid;
+
+	return 0;
+}
+
+static int tracefs_remount(struct super_block *sb, int *flags, char *data)
+{
+	int err;
+	struct tracefs_fs_info *fsi = sb->s_fs_info;
+
+	sync_filesystem(sb);
+	err = tracefs_parse_options(data, &fsi->mount_opts);
+	if (err)
+		goto fail;
+
+	tracefs_apply_options(sb);
+
+fail:
+	return err;
+}
+
+static int tracefs_show_options(struct seq_file *m, struct dentry *root)
+{
+	struct tracefs_fs_info *fsi = root->d_sb->s_fs_info;
+	struct tracefs_mount_opts *opts = &fsi->mount_opts;
+
+	if (!uid_eq(opts->uid, GLOBAL_ROOT_UID))
+		seq_printf(m, ",uid=%u",
+			   from_kuid_munged(&init_user_ns, opts->uid));
+	if (!gid_eq(opts->gid, GLOBAL_ROOT_GID))
+		seq_printf(m, ",gid=%u",
+			   from_kgid_munged(&init_user_ns, opts->gid));
+	if (opts->mode != TRACEFS_DEFAULT_MODE)
+		seq_printf(m, ",mode=%o", opts->mode);
+
+	return 0;
+}
+
+static const struct super_operations tracefs_super_operations = {
+	.statfs		= simple_statfs,
+	.remount_fs	= tracefs_remount,
+	.show_options	= tracefs_show_options,
+};
+
+static int trace_fill_super(struct super_block *sb, void *data, int silent)
+{
+	static struct tree_descr trace_files[] = {{""}};
+	struct tracefs_fs_info *fsi;
+	int err;
+
+	save_mount_options(sb, data);
+
+	fsi = kzalloc(sizeof(struct tracefs_fs_info), GFP_KERNEL);
+	sb->s_fs_info = fsi;
+	if (!fsi) {
+		err = -ENOMEM;
+		goto fail;
+	}
+
+	err = tracefs_parse_options(data, &fsi->mount_opts);
+	if (err)
+		goto fail;
+
+	err  =  simple_fill_super(sb, TRACEFS_MAGIC, trace_files);
+	if (err)
+		goto fail;
+
+	sb->s_op = &tracefs_super_operations;
+
+	tracefs_apply_options(sb);
+
+	return 0;
+
+fail:
+	kfree(fsi);
+	sb->s_fs_info = NULL;
+	return err;
+}
+
+static struct dentry *trace_mount(struct file_system_type *fs_type,
+			int flags, const char *dev_name,
+			void *data)
+{
+	return mount_single(fs_type, flags, data, trace_fill_super);
+}
+
+static struct file_system_type trace_fs_type = {
+	.owner =	THIS_MODULE,
+	.name =		"tracefs",
+	.mount =	trace_mount,
+	.kill_sb =	kill_litter_super,
+};
+MODULE_ALIAS_FS("tracefs");
+
+static struct dentry *__create_file(const char *name, umode_t mode,
+				    struct dentry *parent, void *data,
+				    const struct file_operations *fops)
+{
+	struct dentry *dentry = NULL;
+	int error;
+
+	pr_debug("tracefs: creating file '%s'\n",name);
+
+	error = simple_pin_fs(&trace_fs_type, &tracefs_mount,
+			      &tracefs_mount_count);
+	if (error)
+		goto exit;
+
+	/* If the parent is not specified, we create it in the root.
+	 * We need the root dentry to do this, which is in the super
+	 * block. A pointer to that is in the struct vfsmount that we
+	 * have around.
+	 */
+	if (!parent)
+		parent = tracefs_mount->mnt_root;
+
+	mutex_lock(&parent->d_inode->i_mutex);
+	dentry = lookup_one_len(name, parent, strlen(name));
+	if (!IS_ERR(dentry)) {
+		switch (mode & S_IFMT) {
+		case S_IFDIR:
+			error = tracefs_mkdir(parent->d_inode, dentry, mode);
+
+			break;
+		default:
+			error = tracefs_create(parent->d_inode, dentry, mode,
+					       data, fops);
+			break;
+		}
+		dput(dentry);
+	} else
+		error = PTR_ERR(dentry);
+	mutex_unlock(&parent->d_inode->i_mutex);
+
+	if (error) {
+		dentry = NULL;
+		simple_release_fs(&tracefs_mount, &tracefs_mount_count);
+	}
+exit:
+	return dentry;
+}
+
+/**
+ * tracefs_create_file - create a file in the tracefs filesystem
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have.
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is NULL, then the
+ *          file will be created in the root of the tracefs filesystem.
+ * @data: a pointer to something that the caller will want to get to later
+ *        on.  The inode.i_private pointer will point to this value on
+ *        the open() call.
+ * @fops: a pointer to a struct file_operations that should be used for
+ *        this file.
+ *
+ * This is the basic "create a file" function for tracefs.  It allows for a
+ * wide range of flexibility in creating a file, or a directory (if you want
+ * to create a directory, the tracefs_create_dir() function is
+ * recommended to be used instead.)
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the tracefs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, %NULL will be returned.
+ *
+ * If tracefs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *tracefs_create_file(const char *name, umode_t mode,
+				   struct dentry *parent, void *data,
+				   const struct file_operations *fops)
+{
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+	case 0:
+		break;
+	default:
+		BUG();
+	}
+
+	return __create_file(name, mode, parent, data, fops);
+}
+
+/**
+ * tracefs_create_dir - create a directory in the tracefs filesystem
+ * @name: a pointer to a string containing the name of the directory to
+ *        create.
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is NULL, then the
+ *          directory will be created in the root of the tracefs filesystem.
+ *
+ * This function creates a directory in tracefs with the given name.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the tracefs_remove() function when the file is
+ * to be removed. If an error occurs, %NULL will be returned.
+ *
+ * If tracing is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *tracefs_create_dir(const char *name, struct dentry *parent)
+{
+	return __create_file(name, S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
+				   parent, NULL, NULL);
+}
+
+static inline int tracefs_positive(struct dentry *dentry)
+{
+	return dentry->d_inode && !d_unhashed(dentry);
+}
+
+static int __tracefs_remove(struct dentry *dentry, struct dentry *parent)
+{
+	int ret = 0;
+
+	if (tracefs_positive(dentry)) {
+		if (dentry->d_inode) {
+			dget(dentry);
+			switch (dentry->d_inode->i_mode & S_IFMT) {
+			case S_IFDIR:
+				ret = simple_rmdir(parent->d_inode, dentry);
+				break;
+			default:
+				simple_unlink(parent->d_inode, dentry);
+				break;
+			}
+			if (!ret)
+				d_delete(dentry);
+			dput(dentry);
+		}
+	}
+	return ret;
+}
+
+/**
+ * tracefs_remove - removes a file or directory from the tracefs filesystem
+ * @dentry: a pointer to a the dentry of the file or directory to be
+ *          removed.
+ *
+ * This function removes a file or directory in tracefs that was previously
+ * created with a call to another tracefs function (like
+ * tracefs_create_file() or variants thereof.)
+ */
+void tracefs_remove(struct dentry *dentry)
+{
+	struct dentry *parent;
+	int ret;
+
+	if (IS_ERR_OR_NULL(dentry))
+		return;
+
+	parent = dentry->d_parent;
+	if (!parent || !parent->d_inode)
+		return;
+
+	mutex_lock(&parent->d_inode->i_mutex);
+	ret = __tracefs_remove(dentry, parent);
+	mutex_unlock(&parent->d_inode->i_mutex);
+	if (!ret)
+		simple_release_fs(&tracefs_mount, &tracefs_mount_count);
+}
+
+/**
+ * tracefs_remove_recursive - recursively removes a directory
+ * @dentry: a pointer to a the dentry of the directory to be removed.
+ *
+ * This function recursively removes a directory tree in tracefs that
+ * was previously created with a call to another tracefs function
+ * (like tracefs_create_file() or variants thereof.)
+ */
+void tracefs_remove_recursive(struct dentry *dentry)
+{
+	struct dentry *child, *parent;
+
+	if (IS_ERR_OR_NULL(dentry))
+		return;
+
+	parent = dentry->d_parent;
+	if (!parent || !parent->d_inode)
+		return;
+
+	parent = dentry;
+ down:
+	mutex_lock(&parent->d_inode->i_mutex);
+ loop:
+	/*
+	 * The parent->d_subdirs is protected by the d_lock. Outside that
+	 * lock, the child can be unlinked and set to be freed which can
+	 * use the d_u.d_child as the rcu head and corrupt this list.
+	 */
+	spin_lock(&parent->d_lock);
+	list_for_each_entry(child, &parent->d_subdirs, d_child) {
+		if (!tracefs_positive(child))
+			continue;
+
+		/* perhaps simple_empty(child) makes more sense */
+		if (!list_empty(&child->d_subdirs)) {
+			spin_unlock(&parent->d_lock);
+			mutex_unlock(&parent->d_inode->i_mutex);
+			parent = child;
+			goto down;
+		}
+
+		spin_unlock(&parent->d_lock);
+
+		if (!__tracefs_remove(child, parent))
+			simple_release_fs(&tracefs_mount, &tracefs_mount_count);
+
+		/*
+		 * The parent->d_lock protects agaist child from unlinking
+		 * from d_subdirs. When releasing the parent->d_lock we can
+		 * no longer trust that the next pointer is valid.
+		 * Restart the loop. We'll skip this one with the
+		 * tracefs_positive() check.
+		 */
+		goto loop;
+	}
+	spin_unlock(&parent->d_lock);
+
+	mutex_unlock(&parent->d_inode->i_mutex);
+	child = parent;
+	parent = parent->d_parent;
+	mutex_lock(&parent->d_inode->i_mutex);
+
+	if (child != dentry)
+		/* go up */
+		goto loop;
+
+	if (!__tracefs_remove(child, parent))
+		simple_release_fs(&tracefs_mount, &tracefs_mount_count);
+	mutex_unlock(&parent->d_inode->i_mutex);
+}
+
+/**
+ * tracefs_initialized - Tells whether tracefs has been registered
+ */
+bool tracefs_initialized(void)
+{
+	return tracefs_registered;
+}
+
+static int __init tracefs_init(void)
+{
+	int retval;
+
+	retval = register_filesystem(&trace_fs_type);
+	if (!retval)
+		tracefs_registered = true;
+
+	return retval;
+}
+core_initcall(tracefs_init);
diff --git a/include/linux/tracefs.h b/include/linux/tracefs.h
new file mode 100644
index 000000000000..23e04ce21749
--- /dev/null
+++ b/include/linux/tracefs.h
@@ -0,0 +1,41 @@
+/*
+ *  tracefs.h - a pseudo file system for activating tracing
+ *
+ * Based on debugfs by: 2004 Greg Kroah-Hartman <greg@kroah.com>
+ *
+ *  Copyright (C) 2014 Red Hat Inc, author: Steven Rostedt <srostedt@redhat.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License version
+ *	2 as published by the Free Software Foundation.
+ *
+ * tracefs is the file system that is used by the tracing infrastructure.
+ *
+ */
+
+#ifndef _TRACEFS_H_
+#define _TRACEFS_H_
+
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+
+#include <linux/types.h>
+
+struct file_operations;
+
+#ifdef CONFIG_TRACING
+
+struct dentry *tracefs_create_file(const char *name, umode_t mode,
+				   struct dentry *parent, void *data,
+				   const struct file_operations *fops);
+
+struct dentry *tracefs_create_dir(const char *name, struct dentry *parent);
+
+void tracefs_remove(struct dentry *dentry);
+void tracefs_remove_recursive(struct dentry *dentry);
+
+bool tracefs_initialized(void);
+
+#endif /* CONFIG_TRACING */
+
+#endif
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 7d664ea85ebd..7b1425a6b370 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -58,6 +58,8 @@
 
 #define STACK_END_MAGIC		0x57AC6E9D
 
+#define TRACEFS_MAGIC          0x74726163
+
 #define V9FS_MAGIC		0x01021997
 
 #define BDEVFS_MAGIC            0x62646576
-- 
2.1.4


