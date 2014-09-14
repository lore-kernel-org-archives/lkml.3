Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaINNP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 09:15:28 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59692 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaINNP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 09:15:26 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        jlayton@poochiereds.net, bfields@fieldses.org,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] vfs: move getname() from callers to do_mount()
Date: Sun, 14 Sep 2014 22:15:10 +0900
Message-Id: <1410700510-15408-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410537212-3153-1-git-send-email-waydi1@gmail.com>
References: <1410537212-3153-1-git-send-email-waydi1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would make more sense to pass char __user * instead of
char * in callers of do_mount() and do getname() inside do_mount().

Suggested-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 arch/alpha/kernel/osf_sys.c | 23 ++++++++++-------------
 fs/compat.c                 | 20 ++++++--------------
 fs/namespace.c              | 29 ++++++++++++-----------------
 include/linux/fs.h          |  3 ++-
 4 files changed, 30 insertions(+), 45 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 1402fcc..f9c732e 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -446,7 +446,8 @@ struct procfs_args {
  * unhappy with OSF UFS. [CHECKME]
  */
 static int
-osf_ufs_mount(const char *dirname, struct ufs_args __user *args, int flags)
+osf_ufs_mount(const char __user *dirname,
+	      struct ufs_args __user *args, int flags)
 {
 	int retval;
 	struct cdfs_args tmp;
@@ -466,7 +467,8 @@ osf_ufs_mount(const char *dirname, struct ufs_args __user *args, int flags)
 }
 
 static int
-osf_cdfs_mount(const char *dirname, struct cdfs_args __user *args, int flags)
+osf_cdfs_mount(const char __user *dirname,
+	       struct cdfs_args __user *args, int flags)
 {
 	int retval;
 	struct cdfs_args tmp;
@@ -486,7 +488,8 @@ osf_cdfs_mount(const char *dirname, struct cdfs_args __user *args, int flags)
 }
 
 static int
-osf_procfs_mount(const char *dirname, struct procfs_args __user *args, int flags)
+osf_procfs_mount(const char __user *dirname,
+		 struct procfs_args __user *args, int flags)
 {
 	struct procfs_args tmp;
 
@@ -500,28 +503,22 @@ SYSCALL_DEFINE4(osf_mount, unsigned long, typenr, const char __user *, path,
 		int, flag, void __user *, data)
 {
 	int retval;
-	struct filename *name;
 
-	name = getname(path);
-	retval = PTR_ERR(name);
-	if (IS_ERR(name))
-		goto out;
 	switch (typenr) {
 	case 1:
-		retval = osf_ufs_mount(name->name, data, flag);
+		retval = osf_ufs_mount(path, data, flag);
 		break;
 	case 6:
-		retval = osf_cdfs_mount(name->name, data, flag);
+		retval = osf_cdfs_mount(path, data, flag);
 		break;
 	case 9:
-		retval = osf_procfs_mount(name->name, data, flag);
+		retval = osf_procfs_mount(path, data, flag);
 		break;
 	default:
 		retval = -EINVAL;
 		printk("osf_mount(%ld, %x)\n", typenr, flag);
 	}
-	putname(name);
- out:
+
 	return retval;
 }
 
diff --git a/fs/compat.c b/fs/compat.c
index 6205c24..b13df99 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -794,7 +794,6 @@ COMPAT_SYSCALL_DEFINE5(mount, const char __user *, dev_name,
 	char *kernel_type;
 	unsigned long data_page;
 	char *kernel_dev;
-	struct filename *dir;
 	int retval;
 
 	kernel_type = copy_mount_string(type);
@@ -802,19 +801,14 @@ COMPAT_SYSCALL_DEFINE5(mount, const char __user *, dev_name,
 	if (IS_ERR(kernel_type))
 		goto out;
 
-	dir = getname(dir_name);
-	retval = PTR_ERR(dir);
-	if (IS_ERR(dir))
-		goto out1;
-
 	kernel_dev = copy_mount_string(dev_name);
 	retval = PTR_ERR(kernel_dev);
 	if (IS_ERR(kernel_dev))
-		goto out2;
+		goto out1;
 
 	retval = copy_mount_options(data, &data_page);
 	if (retval < 0)
-		goto out3;
+		goto out2;
 
 	retval = -EINVAL;
 
@@ -823,19 +817,17 @@ COMPAT_SYSCALL_DEFINE5(mount, const char __user *, dev_name,
 			do_ncp_super_data_conv((void *)data_page);
 		} else if (!strcmp(kernel_type, NFS4_NAME)) {
 			if (do_nfs4_super_data_conv((void *) data_page))
-				goto out4;
+				goto out3;
 		}
 	}
 
-	retval = do_mount(kernel_dev, dir->name, kernel_type,
+	retval = do_mount(kernel_dev, dir_name, kernel_type,
 			flags, (void*)data_page);
 
- out4:
-	free_page(data_page);
  out3:
-	kfree(kernel_dev);
+	free_page(data_page);
  out2:
-	putname(dir);
+	kfree(kernel_dev);
  out1:
 	kfree(kernel_type);
  out:
diff --git a/fs/namespace.c b/fs/namespace.c
index bfd03c6..3e11e9e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2542,9 +2542,10 @@ char *copy_mount_string(const void __user *data)
  * Therefore, if this magic number is present, it carries no information
  * and must be discarded.
  */
-long do_mount(const char *dev_name, const char *dir_name,
+long do_mount(const char *dev_name, const char __user *dir_name,
 		const char *type_page, unsigned long flags, void *data_page)
 {
+	struct filename *kernel_dir;
 	struct path path;
 	int retval = 0;
 	int mnt_flags = 0;
@@ -2553,18 +2554,19 @@ long do_mount(const char *dev_name, const char *dir_name,
 	if ((flags & MS_MGC_MSK) == MS_MGC_VAL)
 		flags &= ~MS_MGC_MSK;
 
-	/* Basic sanity checks */
-
-	if (!dir_name || !*dir_name || !memchr(dir_name, 0, PAGE_SIZE))
-		return -EINVAL;
+	kernel_dir = getname(dir_name);
+	if (IS_ERR(kernel_dir)) {
+		retval = PTR_ERR(kernel_dir);
+		return retval;
+	}
 
 	if (data_page)
 		((char *)data_page)[PAGE_SIZE - 1] = 0;
 
 	/* ... and get the mountpoint */
-	retval = kern_path(dir_name, LOOKUP_FOLLOW, &path);
+	retval = kern_path(kernel_dir->name, LOOKUP_FOLLOW, &path);
 	if (retval)
-		return retval;
+		goto dir_out;
 
 	retval = security_sb_mount(dev_name, &path,
 				   type_page, flags, data_page);
@@ -2619,6 +2621,8 @@ long do_mount(const char *dev_name, const char *dir_name,
 				      dev_name, data_page);
 dput_out:
 	path_put(&path);
+dir_out:
+	putname(kernel_dir);
 	return retval;
 }
 
@@ -2787,7 +2791,6 @@ SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 {
 	int ret;
 	char *kernel_type;
-	struct filename *kernel_dir;
 	char *kernel_dev;
 	unsigned long data_page;
 
@@ -2796,12 +2799,6 @@ SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 	if (IS_ERR(kernel_type))
 		goto out_type;
 
-	kernel_dir = getname(dir_name);
-	if (IS_ERR(kernel_dir)) {
-		ret = PTR_ERR(kernel_dir);
-		goto out_dir;
-	}
-
 	kernel_dev = copy_mount_string(dev_name);
 	ret = PTR_ERR(kernel_dev);
 	if (IS_ERR(kernel_dev))
@@ -2811,15 +2808,13 @@ SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 	if (ret < 0)
 		goto out_data;
 
-	ret = do_mount(kernel_dev, kernel_dir->name, kernel_type, flags,
+	ret = do_mount(kernel_dev, dir_name, kernel_type, flags,
 		(void *) data_page);
 
 	free_page(data_page);
 out_data:
 	kfree(kernel_dev);
 out_dev:
-	putname(kernel_dir);
-out_dir:
 	kfree(kernel_type);
 out_type:
 	return ret;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bb2c58c..72cb93f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1839,7 +1839,8 @@ extern struct vfsmount *kern_mount_data(struct file_system_type *, void *data);
 extern void kern_unmount(struct vfsmount *mnt);
 extern int may_umount_tree(struct vfsmount *);
 extern int may_umount(struct vfsmount *);
-extern long do_mount(const char *, const char *, const char *, unsigned long, void *);
+extern long do_mount(const char *, const char __user *,
+		     const char *, unsigned long, void *);
 extern struct vfsmount *collect_mounts(struct path *);
 extern void drop_collected_mounts(struct vfsmount *);
 extern int iterate_mounts(int (*)(struct vfsmount *, void *), void *,
-- 
2.1.0

