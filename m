Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaE0V7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:59:15 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:52966 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaE0V7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:59:10 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>, Marian Marinov <mm@1h.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael J Coss <michael.coss@alcatel-lucent.com>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 1/2] loop: Add loop filesystem
Date: Tue, 27 May 2014 23:58:55 +0200
Message-Id: <1401227936-15698-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
References: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add limited capability for use of loop devices in containers via
a loopfs psuedo fs. When mounted this filesystem will contain
only a loop-control device node. This can be used to request free
loop devices which will be "owned" by that mount. Device nodes
appear automatically for these devices, and the same device will
not be given to another loopfs mount. Privileged loop ioctls
(for encrypted loop) will be allowed within the namespace which
mounted the loopfs.

Privileged block ioctls are not permitted, so features such as
partitions are not supported for unprivileged users.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/block/loop.c       | 110 +++++++++++---
 drivers/block/loop.h       |   2 +
 fs/Makefile                |   1 +
 fs/loopfs/Makefile         |   6 +
 fs/loopfs/inode.c          | 349 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/loopfs.h     |  46 ++++++
 include/uapi/linux/magic.h |   1 +
 7 files changed, 495 insertions(+), 20 deletions(-)
 create mode 100644 fs/loopfs/Makefile
 create mode 100644 fs/loopfs/inode.c
 create mode 100644 include/linux/loopfs.h

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c83c535c0beb..b69e6e91af10 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -75,6 +75,7 @@
 #include <linux/sysfs.h>
 #include <linux/miscdevice.h>
 #include <linux/falloc.h>
+#include <linux/loopfs.h>
 #include "loop.h"
 
 #include <asm/uaccess.h>
@@ -1042,7 +1043,7 @@ static int loop_clr_fd(struct loop_device *lo)
 	}
 	set_capacity(lo->lo_disk, 0);
 	loop_sysfs_exit(lo);
-	if (bdev) {
+	if (bdev && bdev->bd_openers) {
 		bd_set_size(bdev, 0);
 		/* let user-space know about this change */
 		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
@@ -1051,7 +1052,7 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_state = Lo_unbound;
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	if (lo->lo_flags & LO_FLAGS_PARTSCAN && bdev)
+	if (lo->lo_flags & LO_FLAGS_PARTSCAN && bdev && bdev->bd_openers)
 		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	lo->lo_flags = 0;
 	if (!part_shift)
@@ -1605,7 +1606,7 @@ int loop_unregister_transfer(int number)
 EXPORT_SYMBOL(loop_register_transfer);
 EXPORT_SYMBOL(loop_unregister_transfer);
 
-static int loop_add(struct loop_device **l, int i)
+static int loop_add(struct loop_device **l, int i, struct inode *inode)
 {
 	struct loop_device *lo;
 	struct gendisk *disk;
@@ -1679,6 +1680,14 @@ static int loop_add(struct loop_device **l, int i)
 	disk->queue		= lo->lo_queue;
 	sprintf(disk->disk_name, "loop%d", i);
 	add_disk(disk);
+
+	lo->loopfs_inode = loopfs_new_dev(inode, disk_devt(disk),
+					  lo->lo_number);
+	if (IS_ERR(lo->loopfs_inode)) {
+		pr_warn("Unable to create loopfs inode\n");
+		lo->loopfs_inode = NULL;
+	}
+
 	*l = lo;
 	return lo->lo_number;
 
@@ -1694,33 +1703,88 @@ out:
 
 static void loop_remove(struct loop_device *lo)
 {
+	loopfs_kill_dev(lo->loopfs_inode);
+	lo->loopfs_inode = NULL;
 	del_gendisk(lo->lo_disk);
 	blk_cleanup_queue(lo->lo_queue);
 	put_disk(lo->lo_disk);
 	kfree(lo);
 }
 
-static int find_free_cb(int id, void *ptr, void *data)
+static int release_device_cb(int id, void *ptr, void *data)
 {
 	struct loop_device *lo = ptr;
-	struct loop_device **l = data;
+	struct super_block *sb = data;
 
-	if (lo->lo_state == Lo_unbound) {
-		*l = lo;
-		return 1;
+	if (loopfs_sb_from_inode(lo->loopfs_inode) == sb) {
+		mutex_lock(&lo->lo_ctl_mutex);
+
+		/*
+		 * Since this device was allocated to a loopfs mount
+		 * we assume that something outside the mount isn't
+		 * using it. There isn't actually anything to prevent
+		 * a sufficiently priveliged context from using the
+		 * device outside of loopfs, but that just isn't a
+		 * good idea.
+		 */
+		if (lo->lo_state != Lo_unbound)
+			loop_clr_fd(lo);
+
+		lo->lo_disk->private_data = NULL;
+		mutex_unlock(&lo->lo_ctl_mutex);
+
+		idr_remove(&loop_index_idr, lo->lo_number);
+		loop_remove(lo);
 	}
+
 	return 0;
 }
 
-static int loop_lookup(struct loop_device **l, int i)
+int loop_release_devices(struct super_block *sb)
+{
+	int err;
+
+	mutex_lock(&loop_index_mutex);
+	err = idr_for_each(&loop_index_idr, release_device_cb, sb);
+	mutex_unlock(&loop_index_mutex);
+
+	return err;
+}
+
+struct find_free_cb_data {
+	struct loop_device **l;
+	struct inode *inode;
+};
+
+static int find_free_cb(int id, void *ptr, void *data)
+{
+	struct loop_device *lo = ptr;
+	struct find_free_cb_data *cb_data = data;
+
+	if (lo->lo_state != Lo_unbound)
+		return 0;
+
+	/* Don't return a device added from a different loopfs mount */
+	if (loopfs_sb_from_inode(cb_data->inode) !=
+	    loopfs_sb_from_inode(lo->loopfs_inode))
+		return 0;
+
+	*cb_data->l = lo;
+	return 1;
+}
+
+static int loop_lookup(struct loop_device **l, int i, struct inode *inode)
 {
 	struct loop_device *lo;
 	int ret = -ENODEV;
 
 	if (i < 0) {
+		struct find_free_cb_data cb_data;
 		int err;
 
-		err = idr_for_each(&loop_index_idr, &find_free_cb, &lo);
+		cb_data.l = &lo;
+		cb_data.inode = inode;
+		err = idr_for_each(&loop_index_idr, &find_free_cb, &cb_data);
 		if (err == 1) {
 			*l = lo;
 			ret = lo->lo_number;
@@ -1731,8 +1795,13 @@ static int loop_lookup(struct loop_device **l, int i)
 	/* lookup and return a specific i */
 	lo = idr_find(&loop_index_idr, i);
 	if (lo) {
-		*l = lo;
-		ret = lo->lo_number;
+		if (loopfs_sb_from_inode(inode) !=
+		    loopfs_sb_from_inode(lo->loopfs_inode)) {
+			ret = -EACCES;
+		} else {
+			*l = lo;
+			ret = lo->lo_number;
+		}
 	}
 out:
 	return ret;
@@ -1745,9 +1814,9 @@ static struct kobject *loop_probe(dev_t dev, int *part, void *data)
 	int err;
 
 	mutex_lock(&loop_index_mutex);
-	err = loop_lookup(&lo, MINOR(dev) >> part_shift);
+	err = loop_lookup(&lo, MINOR(dev) >> part_shift, NULL);
 	if (err < 0)
-		err = loop_add(&lo, MINOR(dev) >> part_shift);
+		err = loop_add(&lo, MINOR(dev) >> part_shift, NULL);
 	if (err < 0)
 		kobj = NULL;
 	else
@@ -1761,21 +1830,22 @@ static struct kobject *loop_probe(dev_t dev, int *part, void *data)
 static long loop_control_ioctl(struct file *file, unsigned int cmd,
 			       unsigned long parm)
 {
+	struct inode *inode = file_inode(file);
 	struct loop_device *lo;
 	int ret = -ENOSYS;
 
 	mutex_lock(&loop_index_mutex);
 	switch (cmd) {
 	case LOOP_CTL_ADD:
-		ret = loop_lookup(&lo, parm);
+		ret = loop_lookup(&lo, parm, inode);
 		if (ret >= 0) {
 			ret = -EEXIST;
 			break;
 		}
-		ret = loop_add(&lo, parm);
+		ret = loop_add(&lo, parm, inode);
 		break;
 	case LOOP_CTL_REMOVE:
-		ret = loop_lookup(&lo, parm);
+		ret = loop_lookup(&lo, parm, inode);
 		if (ret < 0)
 			break;
 		mutex_lock(&lo->lo_ctl_mutex);
@@ -1795,10 +1865,10 @@ static long loop_control_ioctl(struct file *file, unsigned int cmd,
 		loop_remove(lo);
 		break;
 	case LOOP_CTL_GET_FREE:
-		ret = loop_lookup(&lo, -1);
+		ret = loop_lookup(&lo, -1, inode);
 		if (ret >= 0)
 			break;
-		ret = loop_add(&lo, -1);
+		ret = loop_add(&lo, -1, inode);
 	}
 	mutex_unlock(&loop_index_mutex);
 
@@ -1885,7 +1955,7 @@ static int __init loop_init(void)
 	/* pre-create number of devices given by config or max_loop */
 	mutex_lock(&loop_index_mutex);
 	for (i = 0; i < nr; i++)
-		loop_add(&lo, i);
+		loop_add(&lo, i, NULL);
 	mutex_unlock(&loop_index_mutex);
 
 	printk(KERN_INFO "loop: module loaded\n");
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index 90df5d6485b6..65237b01cc07 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -63,6 +63,8 @@ struct loop_device {
 
 	struct request_queue	*lo_queue;
 	struct gendisk		*lo_disk;
+
+	struct inode		*loopfs_inode;
 };
 
 /* Support for loadable transfer modules */
diff --git a/fs/Makefile b/fs/Makefile
index f9cb9876e466..14fbf21bb11c 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_KERNFS)		+= kernfs/
 obj-$(CONFIG_SYSFS)		+= sysfs/
 obj-$(CONFIG_CONFIGFS_FS)	+= configfs/
 obj-y				+= devpts/
+obj-y				+= loopfs/
 
 obj-$(CONFIG_PROFILING)		+= dcookies.o
 obj-$(CONFIG_DLM)		+= dlm/
diff --git a/fs/loopfs/Makefile b/fs/loopfs/Makefile
new file mode 100644
index 000000000000..01aedfb2f841
--- /dev/null
+++ b/fs/loopfs/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for the loopfs virtual filesystem
+#
+
+obj-$(CONFIG_BLK_DEV_LOOP)		+= loopfs.o
+loopfs-$(CONFIG_BLK_DEV_LOOP)		:= inode.o
diff --git a/fs/loopfs/inode.c b/fs/loopfs/inode.c
new file mode 100644
index 000000000000..78dbaf831d9b
--- /dev/null
+++ b/fs/loopfs/inode.c
@@ -0,0 +1,349 @@
+/*
+ * fs/loopfs/inode.c
+ *
+ * Copyright (C) 2014 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/mount.h>
+#include <linux/magic.h>
+#include <linux/major.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/parser.h>
+#include <linux/fsnotify.h>
+#include <linux/loopfs.h>
+
+static struct vfsmount *loopfs_mnt;
+
+struct loop_mount_opts {
+	bool host_mount;
+};
+
+struct loop_fs_info {
+	struct dentry *control_dentry;
+	struct loop_mount_opts opts;
+	kuid_t root_uid;
+	kgid_t root_gid;
+};
+
+enum {
+	opt_hostmount,
+	opt_err
+};
+
+static const match_table_t tokens = {
+	{opt_hostmount, "hostmount"},
+	{opt_err, NULL}
+};
+
+static inline struct loop_fs_info *LOOPFS_SB(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+struct super_block *loopfs_sb_from_inode(struct inode *inode)
+{
+	if (inode && inode->i_sb->s_magic == LOOPFS_SUPER_MAGIC)
+		return inode->i_sb;
+	return loopfs_mnt->mnt_sb;
+}
+
+static int mknod_loop_control(struct super_block *sb)
+{
+	int ret = 0;
+	struct loop_fs_info *fsi = LOOPFS_SB(sb);
+	struct dentry *root = sb->s_root;
+	struct dentry *dentry;
+	struct inode *inode;
+
+	mutex_lock(&root->d_inode->i_mutex);
+
+	if (fsi->control_dentry)
+		goto out;
+
+	dentry = d_alloc_name(root, "loop-control");
+	if (!dentry) {
+		pr_notice("Unable to allocate dentry for loop-control\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	inode = new_inode(sb);
+	if (!inode) {
+		pr_notice("Uname to allocate inode for loop-control\n");
+		dput(dentry);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	inode->i_ino = 2;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+	init_special_inode(inode, S_IFCHR | S_IRUSR | S_IWUSR,
+			   MKDEV(MISC_MAJOR, LOOP_CTRL_MINOR));
+	inode->i_uid = fsi->root_uid;
+	inode->i_gid = fsi->root_gid;
+
+	d_add(dentry, inode);
+	fsi->control_dentry = dentry;
+
+out:
+	mutex_unlock(&root->d_inode->i_mutex);
+	return ret;
+}
+
+static const struct super_operations loopfs_sops = {
+	.statfs = simple_statfs,
+};
+
+static int parse_mount_options(char *data, struct loop_mount_opts *opts)
+{
+	char *p;
+
+	opts->host_mount = false;
+
+	while ((p = strsep(&data, ",")) != NULL) {
+		substring_t args[MAX_OPT_ARGS];
+		int token;
+
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case opt_hostmount:
+			opts->host_mount = true;
+			break;
+		default:
+			pr_err("loopfs: invalid mount options\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int loopfs_fill_super(struct super_block *s, void *data, int silent)
+{
+	struct inode *inode = NULL;
+	struct loop_fs_info *fsi;
+
+	s->s_blocksize = 1024;
+	s->s_blocksize_bits = 10;
+	s->s_magic = LOOPFS_SUPER_MAGIC;
+	s->s_op = &loopfs_sops;
+	s->s_time_gran = 1;
+
+	fsi = kzalloc(sizeof(struct loop_fs_info), GFP_KERNEL);
+	if (!fsi)
+		return -ENOMEM;
+
+	s->s_fs_info = fsi;
+
+	fsi->root_uid = make_kuid(current_user_ns(), 0);
+	if (!uid_valid(fsi->root_uid))
+		fsi->root_uid = GLOBAL_ROOT_UID;
+	fsi->root_gid = make_kgid(current_user_ns(), 0);
+	if (!gid_valid(fsi->root_gid))
+		fsi->root_gid = GLOBAL_ROOT_GID;
+
+	inode = new_inode(s);
+	if (!inode)
+		goto cleanup;
+	inode->i_ino = 1;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+	inode->i_mode = S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO;
+	inode->i_op = &simple_dir_inode_operations;
+	inode->i_fop = &simple_dir_operations;
+	set_nlink(inode, 2);
+
+	s->s_root = d_make_root(inode);
+	if (s->s_root)
+		return 0;
+
+cleanup:
+	if (inode)
+		iput(inode);
+	if (fsi)
+		kfree(fsi);
+	return -ENOMEM;
+}
+
+static int compare_init_loop_sb(struct super_block *s, void *p)
+{
+	if (loopfs_mnt)
+		return loopfs_mnt->mnt_sb == s;
+	return 0;
+}
+
+static struct dentry *loopfs_mount(struct file_system_type *fs_type,
+				    int flags, const char *dev_name,
+				    void *data)
+{
+	int ret;
+	struct super_block *s;
+	struct loop_mount_opts opts;
+
+	ret = parse_mount_options(data, &opts);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/*
+	 * hostmount is only available for system-wide CAP_SYS_ADMIN;
+	 * drop it otherwise.
+	 */
+	if (opts.host_mount && !capable(CAP_SYS_ADMIN)) {
+		pr_notice("loopfs: dropping hostmount option for unprivileged user\n");
+		opts.host_mount = false;
+	}
+
+	if (opts.host_mount)
+		s = sget(fs_type, compare_init_loop_sb, set_anon_super,
+			 flags, NULL);
+	else
+		s = sget(fs_type, NULL, set_anon_super, flags, NULL);
+
+	if (IS_ERR(s))
+		return ERR_CAST(s);
+
+	if (!s->s_root) {
+		ret = loopfs_fill_super(s, data, (flags & MS_SILENT) != 0);
+		if (ret)
+			goto cleanup;
+		s->s_flags |= MS_ACTIVE;
+	}
+
+	LOOPFS_SB(s)->opts = opts;
+
+	ret = mknod_loop_control(s);
+	if (ret)
+		goto cleanup;
+
+	return dget(s->s_root);
+
+cleanup:
+	deactivate_locked_super(s);
+	return ERR_PTR(ret);
+}
+
+static void loopfs_kill_sb(struct super_block *sb)
+{
+	loop_release_devices(sb);
+	kfree(LOOPFS_SB(sb));
+	kill_litter_super(sb);
+}
+
+static struct file_system_type loopfs_fs_type = {
+	.name		= "loopfs",
+	.mount		= loopfs_mount,
+	.kill_sb	= loopfs_kill_sb,
+	.fs_flags	= FS_USERNS_MOUNT | FS_USERNS_DEV_MOUNT,
+};
+
+/**
+ * loopfs_new_dev -- create new loop device in /dev/loop/
+ * @ref_inode: inode in the superblock where the new node is to be
+ *	created. Usually this will be the loop-control inode but might
+ *	also be another loop device inode if the new device is a
+ *	partition.
+ * @device: major+minor of the node to be created
+ * @lo_number: index of new loop device
+ *
+ * Returns the created inode, which can be removed from /dev/loop by
+ * loopfs_kill_dev(). Returns NULL if @ref_inode is not in a loopfs
+ * superblock.
+ */
+struct inode *loopfs_new_dev(struct inode *ref_inode, dev_t device,
+			      int lo_number)
+{
+	struct super_block *sb = loopfs_sb_from_inode(ref_inode);
+	unsigned int major = MAJOR(device);
+	unsigned int minor = MINOR(device);
+	struct dentry *root, *dentry;
+	struct inode *inode;
+	char name[12];
+
+	if (major != LOOP_MAJOR)
+		return ERR_PTR(-EINVAL);
+
+	if (!sb)
+		return NULL;
+
+	if (snprintf(name, sizeof(name), "%d", lo_number) >= sizeof(name))
+		return ERR_PTR(-EINVAL);
+
+	root = sb->s_root;
+
+	inode = new_inode(sb);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	inode->i_ino = minor + 3;
+	inode->i_uid = LOOPFS_SB(sb)->root_uid;
+	inode->i_gid = LOOPFS_SB(sb)->root_gid;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+	init_special_inode(inode, S_IFBLK | 0660, device);
+
+	mutex_lock(&root->d_inode->i_mutex);
+	dentry = d_alloc_name(root, name);
+	if (dentry) {
+		d_add(dentry, inode);
+		fsnotify_create(root->d_inode, dentry);
+	} else {
+		iput(inode);
+		inode = ERR_PTR(-ENOMEM);
+	}
+	mutex_unlock(&root->d_inode->i_mutex);
+
+	return inode;
+}
+
+/**
+ * loopfs_kill_dev -- remove inode from /dev/loop/
+ * @inode: inode of loop device to be removed
+ *
+ * Kill an inode created by loopfs_new_dev().
+ */
+void loopfs_kill_dev(struct inode *inode)
+{
+	struct dentry *root, *dentry;
+
+	if (!inode)
+		return;
+
+	if (!S_ISBLK(inode->i_mode) || imajor(inode) != LOOP_MAJOR)
+		return;
+
+	root = loopfs_sb_from_inode(inode)->s_root;
+	mutex_lock(&root->d_inode->i_mutex);
+
+	dentry = d_find_alias(inode);
+	drop_nlink(inode);
+	d_delete(dentry);
+	dput(dentry);	/* for d_alloc_name() in loopfs_new_dev() */
+	dput(dentry);	/* for d_find_alias() above */
+
+	mutex_unlock(&root->d_inode->i_mutex);
+}
+
+static int __init init_loopfs_fs(void)
+{
+	int ret = register_filesystem(&loopfs_fs_type);
+	if (!ret) {
+		loopfs_mnt = kern_mount(&loopfs_fs_type);
+		if (IS_ERR(loopfs_mnt)) {
+			ret = PTR_ERR(loopfs_mnt);
+			unregister_filesystem(&loopfs_fs_type);
+		}
+	}
+	return ret;
+}
+module_init(init_loopfs_fs);
diff --git a/include/linux/loopfs.h b/include/linux/loopfs.h
new file mode 100644
index 000000000000..27deadd02364
--- /dev/null
+++ b/include/linux/loopfs.h
@@ -0,0 +1,46 @@
+/*
+ * include/linux/loopfs_fs.h
+ *
+ * Copyright (C) 2014 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_LOOPFS_FS_H
+#define _LINUX_LOOPFS_FS_H
+
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/magic.h>
+
+#ifdef CONFIG_BLK_DEV_LOOP
+
+struct super_block *loopfs_sb_from_inode(struct inode *inode);
+struct inode *loopfs_new_dev(struct inode *ref_inode, dev_t device,
+			     int lo_number);
+void loopfs_kill_dev(struct inode *inode);
+
+/* Callback into drivers/block/loop.c */
+int loop_release_devices(struct super_block *sb);
+
+#else
+
+static inline struct super_block *loopfs_sb_from_inode(struct inode *inode)
+{
+	return NULL;
+}
+
+static inline struct inode *loopfs_new_dev(struct inode *ref_inode,
+					   dev_t device, int lo_number)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline void loopfs_kill_dev(struct inode *inode) { }
+static inline int loop_release_devices(struct superblock *sb) { }
+
+#endif
+
+#endif /* _LINUX_LOOPFS_FS_H */
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 77c60311a6c6..e713aac3c6a6 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -63,6 +63,7 @@
 #define BDEVFS_MAGIC            0x62646576
 #define BINFMTFS_MAGIC          0x42494e4d
 #define DEVPTS_SUPER_MAGIC	0x1cd1
+#define LOOPFS_SUPER_MAGIC	0x6c6f6f70
 #define FUTEXFS_SUPER_MAGIC	0xBAD1DEA
 #define PIPEFS_MAGIC            0x50495045
 #define PROC_SUPER_MAGIC	0x9fa0
-- 
1.9.1

