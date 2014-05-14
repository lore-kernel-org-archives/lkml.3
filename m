Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaENVfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:35:25 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:34381 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaENVfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:35:18 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 05/11] devtmpfs: Add support for mounting in user namespaces
Date: Wed, 14 May 2014 16:34:53 -0500
Message-Id: <1400103299-144589-6-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devtmpfs is arguably more useful within containers than outside
since containers will often lack the ability to run mknod. So far
this hasn't been permitted since it doesn't make sense to give
containers the same set of devices as the rest of the system.
devtmpfs needs to be aware of device ownership, creating device
nodes only for the namespaces in which a given device should be
accessible.

Add this support by creating multiple devtmpfs super blocks, one
for each user namespace which as devtmpfs mounted. A given super
block only contains device nodes for device owned by the
associated namespace as well as nodes for global devices. Upon
mount, if no super block already exists for the current user
namespace a new one is created and populated with the appropriate
device nodes.

Under this new structure devtmpfsd can no longer assume that all
files will be created relative to its current working directory,
so this code is also rewritten to create files relative to the
root of the super block.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/base/devtmpfs.c | 509 ++++++++++++++++++++++++++++++++++--------------
 include/linux/device.h  |   1 +
 2 files changed, 368 insertions(+), 142 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 25798db14553..1f77c419ef6a 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -24,10 +24,16 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/user_namespace.h>
 #include "base.h"
 
 static struct task_struct *thread;
 
+static LIST_HEAD(dev_list);
+static DEFINE_MUTEX(dev_list_mutex);
+
 #if defined CONFIG_DEVTMPFS_MOUNT
 static int mount_dev = 1;
 #else
@@ -36,17 +42,77 @@ static int mount_dev;
 
 static DEFINE_SPINLOCK(req_lock);
 
+enum req_type {
+	REQ_TYPE_CREATE,
+	REQ_TYPE_REMOVE,
+	REQ_TYPE_POPULATE,
+
+	NUM_REQ_TYPES
+};
+
 static struct req {
+	enum req_type type;
 	struct req *next;
 	struct completion done;
 	int err;
 	const char *name;
-	umode_t mode;	/* 0 => delete */
+	umode_t mode;
 	kuid_t uid;
 	kgid_t gid;
 	struct device *dev;
+	struct super_block *sb;
 } *requests;
 
+#ifdef CONFIG_BLOCK
+static inline int is_blockdev(struct device *dev)
+{
+	return dev->class == &block_class;
+}
+#else
+static inline int is_blockdev(struct device *dev) { return 0; }
+#endif
+
+/* Caller must free returned string */
+static char *dev_get_params(struct device *dev, umode_t *mode, kuid_t *uid,
+			    kgid_t *gid)
+{
+	const char *name, *tmp = NULL;
+
+	if (mode)
+		*mode = 0;
+	if (uid)
+		*uid = GLOBAL_ROOT_UID;
+	if (gid)
+		*gid = GLOBAL_ROOT_GID;
+
+	name = device_get_devnode(dev, mode, uid, gid, &tmp);
+	if (!name)
+		return ERR_PTR(-ENOMEM);
+
+	if (mode) {
+		if (*mode == 0)
+			*mode = 0600;
+		*mode |= is_blockdev(dev) ? S_IFBLK : S_IFCHR;
+	}
+
+	/*
+	 * If !tmp the name is static memory, so duplicate it for
+	 * returning to caller
+	 */
+	if (!tmp)
+		tmp = kstrdup(name, GFP_KERNEL);
+	return (char *)tmp;
+}
+
+struct user_namespace *dev_sb_ns(struct super_block *s)
+{
+#ifdef CONFIG_TMPFS
+	return ((struct shmem_sb_info *)s->s_fs_info)->sub_fs_data;
+#else
+	return ((struct ram_fs_info *)s->s_fs_info)->sub_fs_data;
+#endif
+}
+
 static int __init mount_param(char *str)
 {
 	mount_dev = simple_strtoul(str, NULL, 0);
@@ -54,53 +120,104 @@ static int __init mount_param(char *str)
 }
 __setup("devtmpfs.mount=", mount_param);
 
+static int dev_compare_sb(struct super_block *s, void *data)
+{
+	return dev_sb_ns(s) == data;
+}
+
+static int dev_fill_super(struct super_block *s, void *data, int silent)
+{
+#ifdef CONFIG_TMPFS
+	return shmem_fill_super(s, data, silent);
+#else
+	return ramfs_fill_super(s, data, silent);
+#endif
+
+}
+
 static struct dentry *dev_mount(struct file_system_type *fs_type, int flags,
-		      const char *dev_name, void *data)
+				const char *dev_name, void *data)
 {
+	struct super_block *s = NULL;
+	struct user_namespace *ns;
+	struct req req;
+	int err;
+
+	if (!thread)
+		return ERR_PTR(-ENODEV);
+
+	ns = get_user_ns(current_user_ns());
+
+	s = sget(fs_type, dev_compare_sb, set_anon_super, flags, ns);
+	if (IS_ERR(s)) {
+		err = PTR_ERR(s);
+		goto error;
+	}
+
+	if (!s->s_root) {
+		err = dev_fill_super(s, data, flags & MS_SILENT ? 1 : 0);
+		if (err)
+			goto error;
+		s->s_flags |= MS_ACTIVE;
+
 #ifdef CONFIG_TMPFS
-	return mount_single(fs_type, flags, data, shmem_fill_super);
+		((struct shmem_sb_info *)s->s_fs_info)->sub_fs_data = ns;
 #else
-	return mount_single(fs_type, flags, data, ramfs_fill_super);
+		((struct ram_fs_info *)s->s_fs_info)->sub_fs_data = ns;
 #endif
+
+		req.type = REQ_TYPE_POPULATE;
+		req.sb = s;
+		init_completion(&req.done);
+
+		spin_lock(&req_lock);
+		req.next = requests;
+		requests = &req;
+		spin_unlock(&req_lock);
+
+		wake_up_process(thread);
+		wait_for_completion(&req.done);
+	}
+
+	return dget(s->s_root);
+
+error:
+	if (s)
+		deactivate_locked_super(s);
+	put_user_ns(ns);
+	return ERR_PTR(err);
+}
+
+static void dev_kill_sb(struct super_block *s)
+{
+	struct user_namespace *ns = dev_sb_ns(s);
+
+	kill_litter_super(s);
+	put_user_ns(ns);
 }
 
 static struct file_system_type dev_fs_type = {
 	.name = "devtmpfs",
 	.mount = dev_mount,
-	.kill_sb = kill_litter_super,
+	.kill_sb = dev_kill_sb,
+	.fs_flags = FS_USERNS_MOUNT | FS_USERNS_DEV_MOUNT,
 };
 
-#ifdef CONFIG_BLOCK
-static inline int is_blockdev(struct device *dev)
-{
-	return dev->class == &block_class;
-}
-#else
-static inline int is_blockdev(struct device *dev) { return 0; }
-#endif
-
 int devtmpfs_create_node(struct device *dev)
 {
-	const char *tmp = NULL;
 	struct req req;
 
+	mutex_lock(&dev_list_mutex);
+	list_add(&dev->devtmpfs_list, &dev_list);
+	mutex_unlock(&dev_list_mutex);
+
 	if (!thread)
 		return 0;
 
-	req.mode = 0;
-	req.uid = GLOBAL_ROOT_UID;
-	req.gid = GLOBAL_ROOT_GID;
-	req.name = device_get_devnode(dev, &req.mode, &req.uid, &req.gid, &tmp);
-	if (!req.name)
-		return -ENOMEM;
-
-	if (req.mode == 0)
-		req.mode = 0600;
-	if (is_blockdev(dev))
-		req.mode |= S_IFBLK;
-	else
-		req.mode |= S_IFCHR;
-
+	req.type = REQ_TYPE_CREATE;
+	req.name = dev_get_params(dev, &req.mode, &req.uid, &req.gid);
+	if (IS_ERR(req.name))
+		return PTR_ERR(req.name);
 	req.dev = dev;
 
 	init_completion(&req.done);
@@ -113,22 +230,26 @@ int devtmpfs_create_node(struct device *dev)
 	wake_up_process(thread);
 	wait_for_completion(&req.done);
 
-	kfree(tmp);
+	kfree(req.name);
 
 	return req.err;
 }
 
 int devtmpfs_delete_node(struct device *dev)
 {
-	const char *tmp = NULL;
 	struct req req;
 
+	mutex_lock(&dev_list_mutex);
+	list_del(&dev->devtmpfs_list);
+	mutex_unlock(&dev_list_mutex);
+
 	if (!thread)
 		return 0;
 
-	req.name = device_get_devnode(dev, NULL, NULL, NULL, &tmp);
-	if (!req.name)
-		return -ENOMEM;
+	req.type = REQ_TYPE_REMOVE;
+	req.name = dev_get_params(dev, NULL, NULL, NULL);
+	if (IS_ERR(req.name))
+		return PTR_ERR(req.name);
 
 	req.mode = 0;
 	req.dev = dev;
@@ -143,113 +264,165 @@ int devtmpfs_delete_node(struct device *dev)
 	wake_up_process(thread);
 	wait_for_completion(&req.done);
 
-	kfree(tmp);
+	kfree(req.name);
 	return req.err;
 }
 
-static int dev_mkdir(const char *name, umode_t mode)
+/*
+ * Looks up the path specified in @nodepath and returns the corresponding
+ * dentry. If @create is true the path will be created if it does not
+ * exist.
+ *
+ * When @create is true: if @nodepath ends in '/', lookup_path() will
+ * create a directory for the last path component if it doesn't exist.
+ * If @nodepath does not end in '/', lookup_path() will create the
+ * dentry but not an inode. It is up to the caller to check d_inode in
+ * the returned dentry and act accordingly.
+ */
+static struct dentry *lookup_path(const char *nodepath, struct dentry *parent,
+				  bool create)
 {
-	struct dentry *dentry;
-	struct path path;
-	int err;
+	const char *p, *s;
+	struct dentry *next, *de = parent;
+	void *cookie = de->d_sb;
+	bool dir = true;
+	int err = 0;
 
-	dentry = kern_path_create(AT_FDCWD, name, &path, LOOKUP_DIRECTORY);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
+	dget(de);
+	for (s = p = nodepath; *s;) {
+		s = strchr(p, '/');
+		if (!s) {
+			if (*p) {
+				s = p + strlen(p);
+				dir = false;
+			} else {
+				break;
+			}
+		}
 
-	err = vfs_mkdir(path.dentry->d_inode, dentry, mode);
-	if (!err)
-		/* mark as kernel-created inode */
-		dentry->d_inode->i_private = &thread;
-	done_path_create(&path, dentry);
-	return err;
-}
+		mutex_lock(&de->d_inode->i_mutex);
+		next = lookup_one_len(p, de, s - p);
+		if (IS_ERR(next)) {
+			err = PTR_ERR(next);
+			break;
+		}
 
-static int create_path(const char *nodepath)
-{
-	char *path;
-	char *s;
-	int err = 0;
+		if (!next->d_inode) {
+			if (!create) {
+				err = -ENOENT;
+				dput(next);
+				break;
+			}
 
-	/* parent directories do not exist, create them */
-	path = kstrdup(nodepath, GFP_KERNEL);
-	if (!path)
-		return -ENOMEM;
+			if (dir) {
+				err = vfs_mkdir(de->d_inode, next, 0755);
+				if (err == -EEXIST) {
+					/* SAF: I'm not sure if this is right,
+					 * or even necessary. We definitely
+					 * should not overwrite i_private in
+					 * this case though. */
+					dput(next);
+					err = 0;
+					continue; /* try lookup again */
+				}
+				if (err) {
+					dput(next);
+					break;
+				}
+				next->d_inode->i_private = cookie;
+			}
+		}
 
-	s = path;
-	for (;;) {
-		s = strchr(s, '/');
-		if (!s)
-			break;
-		s[0] = '\0';
-		err = dev_mkdir(path, 0755);
-		if (err && err != -EEXIST)
-			break;
-		s[0] = '/';
-		s++;
+		mutex_unlock(&de->d_inode->i_mutex);
+		dput(de);
+		de = next;
+		p = s + 1;
 	}
-	kfree(path);
-	return err;
+
+	if (err) {
+		mutex_unlock(&de->d_inode->i_mutex);
+		dput(de);
+		de = ERR_PTR(err);
+	}
+
+	return de;
 }
 
-static int handle_create(const char *nodename, umode_t mode, kuid_t uid,
-			 kgid_t gid, struct device *dev)
+static void do_handle_create(struct super_block *s, void *arg)
 {
+	struct req *req = arg;
+	struct device *dev = req->dev;
 	struct dentry *dentry;
-	struct path path;
 	int err;
 
-	dentry = kern_path_create(AT_FDCWD, nodename, &path, 0);
-	if (dentry == ERR_PTR(-ENOENT)) {
-		create_path(nodename);
-		dentry = kern_path_create(AT_FDCWD, nodename, &path, 0);
+	if (!dev->ns_global && dev_sb_ns(s) != dev->ns)
+		return;
+
+	dentry = lookup_path(req->name, s->s_root, true);
+	if (IS_ERR(dentry)) {
+		req->err = PTR_ERR(dentry);
+		return;
 	}
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
 
-	err = vfs_mknod(path.dentry->d_inode, dentry, mode, dev->devt);
+	if (dentry->d_inode) {
+		dput(dentry);
+		req->err = -EEXIST;
+		return;
+	}
+
+	err = vfs_mknod(dentry->d_parent->d_inode, dentry, req->mode,
+			dev->devt);
 	if (!err) {
 		struct iattr newattrs;
 
-		newattrs.ia_mode = mode;
-		newattrs.ia_uid = uid;
-		newattrs.ia_gid = gid;
+		newattrs.ia_mode = req->mode;
+		/* SAF: Is this right? */
+		newattrs.ia_uid = make_kuid(dev_sb_ns(s), req->uid.val);
+		newattrs.ia_gid = make_kgid(dev_sb_ns(s), req->gid.val);
 		newattrs.ia_valid = ATTR_MODE|ATTR_UID|ATTR_GID;
 		mutex_lock(&dentry->d_inode->i_mutex);
 		notify_change(dentry, &newattrs, NULL);
 		mutex_unlock(&dentry->d_inode->i_mutex);
 
 		/* mark as kernel-created inode */
-		dentry->d_inode->i_private = &thread;
+		dentry->d_inode->i_private = s;
 	}
-	done_path_create(&path, dentry);
-	return err;
+
+	dput(dentry);
+
+	if (err)
+		req->err = err;
 }
 
-static int dev_rmdir(const char *name)
+static int handle_create(struct req *req)
+{
+	req->err = 0;
+	iterate_supers_type(&dev_fs_type, do_handle_create, req);
+	return req->err;
+}
+
+static int dev_rmdir(struct super_block *s, const char *name)
 {
-	struct path parent;
 	struct dentry *dentry;
 	int err;
 
-	dentry = kern_path_locked(name, &parent);
+	dentry = lookup_path(name, s->s_root, false);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 	if (dentry->d_inode) {
-		if (dentry->d_inode->i_private == &thread)
-			err = vfs_rmdir(parent.dentry->d_inode, dentry);
+		if (dentry->d_inode->i_private == s)
+			err = vfs_rmdir(dentry->d_parent->d_inode, dentry);
 		else
 			err = -EPERM;
 	} else {
 		err = -ENOENT;
 	}
+
 	dput(dentry);
-	mutex_unlock(&parent.dentry->d_inode->i_mutex);
-	path_put(&parent);
 	return err;
 }
 
-static int delete_path(const char *nodepath)
+static int delete_path(struct super_block *s, const char *nodepath)
 {
 	const char *path;
 	int err = 0;
@@ -265,7 +438,7 @@ static int delete_path(const char *nodepath)
 		if (!base)
 			break;
 		base[0] = '\0';
-		err = dev_rmdir(path);
+		err = dev_rmdir(s, path);
 		if (err)
 			break;
 	}
@@ -274,10 +447,11 @@ static int delete_path(const char *nodepath)
 	return err;
 }
 
-static int dev_mynode(struct device *dev, struct inode *inode, struct kstat *stat)
+static int dev_mynode(struct super_block *s, struct device *dev,
+		      struct inode *inode, struct kstat *stat)
 {
 	/* did we create it */
-	if (inode->i_private != &thread)
+	if (inode->i_private != s)
 		return 0;
 
 	/* does the dev_t match */
@@ -295,36 +469,50 @@ static int dev_mynode(struct device *dev, struct inode *inode, struct kstat *sta
 	return 1;
 }
 
-static int handle_remove(const char *nodename, struct device *dev)
+static void do_handle_remove(struct super_block *s, void *arg)
 {
-	struct path parent;
+	struct req *req = arg;
+	struct device *dev = req->dev;
 	struct dentry *dentry;
 	int deleted = 0;
-	int err;
+	int err = 0;
 
-	dentry = kern_path_locked(nodename, &parent);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
+	if (!dev->ns_global && dev_sb_ns(s) != dev->ns)
+		return;
+
+	dentry = lookup_path(req->name, s->s_root, false);
+	if (IS_ERR(dentry)) {
+		req->err = PTR_ERR(dentry);
+		return;
+	}
 
 	if (dentry->d_inode) {
 		struct kstat stat;
-		struct path p = {.mnt = parent.mnt, .dentry = dentry};
-		err = vfs_getattr(&p, &stat);
-		if (!err && dev_mynode(dev, dentry->d_inode, &stat)) {
+		/*
+		 * SAF: Should probably call vfs_getattr(), but there's no
+		 * obvious way to get a vfsmount. But for both tmpfs and
+		 * ramfs it's the same, since neither implement getattr().
+		 * So I could leave it like this, or else keep an internal
+		 * mount for each super block.
+		 */
+		generic_fillattr(dentry->d_inode, &stat);
+		/* SAF: What if !dev_mynode()? Error? */
+		if (dev_mynode(s, dev, dentry->d_inode, &stat)) {
 			struct iattr newattrs;
 			/*
 			 * before unlinking this node, reset permissions
 			 * of possible references like hardlinks
 			 */
-			newattrs.ia_uid = GLOBAL_ROOT_UID;
-			newattrs.ia_gid = GLOBAL_ROOT_GID;
+			newattrs.ia_uid = make_kuid(dev_sb_ns(s), 0);
+			newattrs.ia_gid = make_kgid(dev_sb_ns(s), 0);
 			newattrs.ia_mode = stat.mode & ~0777;
 			newattrs.ia_valid =
 				ATTR_UID|ATTR_GID|ATTR_MODE;
 			mutex_lock(&dentry->d_inode->i_mutex);
 			notify_change(dentry, &newattrs, NULL);
 			mutex_unlock(&dentry->d_inode->i_mutex);
-			err = vfs_unlink(parent.dentry->d_inode, dentry, NULL);
+			err = vfs_unlink(dentry->d_parent->d_inode,
+					 dentry, NULL);
 			if (!err || err == -ENOENT)
 				deleted = 1;
 		}
@@ -332,11 +520,43 @@ static int handle_remove(const char *nodename, struct device *dev)
 		err = -ENOENT;
 	}
 	dput(dentry);
-	mutex_unlock(&parent.dentry->d_inode->i_mutex);
 
-	path_put(&parent);
-	if (deleted && strchr(nodename, '/'))
-		delete_path(nodename);
+	if (deleted && strchr(req->name, '/'))
+		delete_path(s, req->name);
+
+	if (err)
+		req->err = err;
+}
+
+static int handle_remove(struct req *req)
+{
+	req->err = 0;
+	iterate_supers_type(&dev_fs_type, do_handle_remove, req);
+	return req->err;
+}
+
+static int handle_populate(struct req *req)
+{
+	struct device *dev;
+	int err = 0;
+
+	mutex_lock(&dev_list_mutex);
+	list_for_each_entry(dev, &dev_list, devtmpfs_list) {
+		if (!dev->ns_global && dev_sb_ns(req->sb) != dev->ns)
+			continue;
+
+		req->name = dev_get_params(dev, &req->mode, &req->uid,
+					   &req->gid);
+		if (IS_ERR(req->name)) {
+			err = -ENOMEM;
+			continue;
+		}
+
+		req->dev = dev;
+		do_handle_create(req->sb, req);
+	}
+	mutex_unlock(&dev_list_mutex);
+
 	return err;
 }
 
@@ -362,31 +582,30 @@ int devtmpfs_mount(const char *mntdir)
 	return err;
 }
 
-static DECLARE_COMPLETION(setup_done);
-
-static int handle(const char *name, umode_t mode, kuid_t uid, kgid_t gid,
-		  struct device *dev)
+static int handle(struct req *req)
 {
-	if (mode)
-		return handle_create(name, mode, uid, gid, dev);
-	else
-		return handle_remove(name, dev);
+	int err;
+
+	switch(req->type) {
+	case REQ_TYPE_CREATE:
+		err = handle_create(req);
+		break;
+	case REQ_TYPE_REMOVE:
+		err = handle_remove(req);
+		break;
+	case REQ_TYPE_POPULATE:
+		err = handle_populate(req);
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+	return err;
 }
 
 static int devtmpfsd(void *p)
 {
-	char options[] = "mode=0755";
-	int *err = p;
-	*err = sys_unshare(CLONE_NEWNS);
-	if (*err)
-		goto out;
-	*err = sys_mount("devtmpfs", "/", "devtmpfs", MS_SILENT, options);
-	if (*err)
-		goto out;
-	sys_chdir("/.."); /* will traverse into overmounted root */
-	sys_chroot(".");
-	complete(&setup_done);
-	while (1) {
+	while (!kthread_should_stop()) {
 		spin_lock(&req_lock);
 		while (requests) {
 			struct req *req = requests;
@@ -394,8 +613,7 @@ static int devtmpfsd(void *p)
 			spin_unlock(&req_lock);
 			while (req) {
 				struct req *next = req->next;
-				req->err = handle(req->name, req->mode,
-						  req->uid, req->gid, req->dev);
+				req->err = handle(req);
 				complete(&req->done);
 				req = next;
 			}
@@ -406,11 +624,10 @@ static int devtmpfsd(void *p)
 		schedule();
 	}
 	return 0;
-out:
-	complete(&setup_done);
-	return *err;
 }
 
+struct vfsmount *dev_mnt;
+
 /*
  * Create devtmpfs instance, driver-core devices will add their device
  * nodes here.
@@ -425,9 +642,7 @@ int __init devtmpfs_init(void)
 	}
 
 	thread = kthread_run(devtmpfsd, &err, "kdevtmpfs");
-	if (!IS_ERR(thread)) {
-		wait_for_completion(&setup_done);
-	} else {
+	if (IS_ERR(thread)) {
 		err = PTR_ERR(thread);
 		thread = NULL;
 	}
@@ -438,6 +653,16 @@ int __init devtmpfs_init(void)
 		return err;
 	}
 
+	/* Don't use kern_mount() because tmpfs will set MS_NOUSER */
+	dev_mnt = vfs_kern_mount(&dev_fs_type, 0, dev_fs_type.name, NULL);
+	if (IS_ERR(dev_mnt)) {
+		err = PTR_ERR(dev_mnt);
+		kthread_stop(thread);
+		thread = NULL;
+		unregister_filesystem(&dev_fs_type);
+		return err;
+	}
+
 	printk(KERN_INFO "devtmpfs: initialized\n");
 	return 0;
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index e2dbe19b5f46..55f0fca24df5 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -785,6 +785,7 @@ struct device {
 	struct iommu_group	*iommu_group;
 
 	struct user_namespace	*ns;
+	struct list_head	devtmpfs_list;
 
 	bool			offline_disabled:1;
 	bool			offline:1;
-- 
1.9.1

