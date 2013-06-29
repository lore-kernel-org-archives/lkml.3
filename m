Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3F2UMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 16:12:24 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54819 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab3F2UMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 16:12:19 -0400
Date: Sat, 29 Jun 2013 13:12:18 -0700 (PDT)
From: Rob Landley <rob@landley.net>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Stephen Warren <swarren@nvidia.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1372536729.850447@landley.net>
Message-Id: <1372536729.851190@landley.net>
Subject: [PATCH 3/5] initmpfs: Move rootfs code from fs/ramfs/ to init/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

When the rootfs code was a wrapper around ramfs, having them in the same
file made sense. Now that it can wrap another filesystem type, move it
in with the init code instead.

This also allows a subsequent patch to access rootfstype= command line arg.

Signed-off-by: Rob Landley <rob@landley.net>
---

 fs/namespace.c        |    2 +-
 fs/ramfs/inode.c      |   34 +---------------------------------
 include/linux/init.h  |    1 +
 include/linux/ramfs.h |    2 +-
 init/do_mounts.c      |   34 ++++++++++++++++++++++++++++++++++
 5 files changed, 38 insertions(+), 35 deletions(-)

--- initold/fs/namespace.c	2013-06-28 15:09:19.389872904 -0500
+++ initold2/fs/namespace.c	2013-06-28 15:16:05.261889820 -0500
@@ -17,7 +17,7 @@
 #include <linux/security.h>
 #include <linux/idr.h>
 #include <linux/acct.h>		/* acct_auto_close_mnt */
-#include <linux/ramfs.h>	/* init_rootfs */
+#include <linux/init.h>		/* init_rootfs */
 #include <linux/fs_struct.h>	/* get_fs_root et.al. */
 #include <linux/fsnotify.h>	/* fsnotify_vfsmount_delete */
 #include <linux/uaccess.h>
--- initold/fs/ramfs/inode.c	2013-06-28 15:15:37.549888666 -0500
+++ initold2/fs/ramfs/inode.c	2013-06-28 15:16:05.273889820 -0500
@@ -244,19 +244,6 @@
 	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
 }
 
-static struct dentry *rootfs_mount(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data)
-{
-	static int once;
-
-	if (once)
-		return ERR_PTR(-ENODEV);
-	else
-		once++;
-
-	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
-}
-
 static void ramfs_kill_sb(struct super_block *sb)
 {
 	kfree(sb->s_fs_info);
@@ -269,13 +256,8 @@
 	.kill_sb	= ramfs_kill_sb,
 	.fs_flags	= FS_USERNS_MOUNT,
 };
-static struct file_system_type rootfs_fs_type = {
-	.name		= "rootfs",
-	.mount		= rootfs_mount,
-	.kill_sb	= kill_litter_super,
-};
 
-static int __init init_ramfs_fs(void)
+int __init init_ramfs_fs(void)
 {
 	static int once;
 	int err;
@@ -296,17 +276,3 @@
 	return err;
 }
 module_init(init_ramfs_fs)
-
-int __init init_rootfs(void)
-{
-	int err = register_filesystem(&rootfs_fs_type);
-
-	if (err)
-		return err;
-
-	err = init_ramfs_fs();
-	if (err)
-		unregister_filesystem(&rootfs_fs_type);
-
-	return err;
-}
--- initold/include/linux/init.h	2013-06-28 15:09:19.517872909 -0500
+++ initold2/include/linux/init.h	2013-06-28 15:16:05.321889821 -0500
@@ -154,6 +154,7 @@
 void setup_arch(char **);
 void prepare_namespace(void);
 void __init load_default_modules(void);
+int __init init_rootfs(void);
 
 extern void (*late_time_init)(void);
 
--- initold/include/linux/ramfs.h	2013-06-28 15:09:19.537872910 -0500
+++ initold2/include/linux/ramfs.h	2013-06-28 15:16:05.513889832 -0500
@@ -25,7 +25,7 @@
 
 extern const struct file_operations ramfs_file_operations;
 extern const struct vm_operations_struct generic_file_vm_ops;
-extern int __init init_rootfs(void);
+extern int __init init_ramfs_fs(void);
 
 int ramfs_fill_super(struct super_block *sb, void *data, int silent);
 
--- initold/init/do_mounts.c	2013-06-28 15:09:19.585872913 -0500
+++ initold2/init/do_mounts.c	2013-06-28 15:16:05.561889831 -0500
@@ -26,6 +26,7 @@
 #include <linux/async.h>
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
+#include <linux/ramfs.h>
 
 #include <linux/nfs_fs.h>
 #include <linux/nfs_fs_sb.h>
@@ -588,3 +589,36 @@
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot(".");
 }
+
+static struct dentry *rootfs_mount(struct file_system_type *fs_type,
+	int flags, const char *dev_name, void *data)
+{
+	static int once;
+
+	if (once)
+		return ERR_PTR(-ENODEV);
+	else
+		once++;
+
+	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
+}
+
+static struct file_system_type rootfs_fs_type = {
+	.name		= "rootfs",
+	.mount		= rootfs_mount,
+	.kill_sb	= kill_litter_super,
+};
+
+int __init init_rootfs(void)
+{
+	int err = register_filesystem(&rootfs_fs_type);
+
+	if (err)
+		return err;
+
+	err = init_ramfs_fs();
+	if (err)
+		unregister_filesystem(&rootfs_fs_type);
+
+	return err;
+}
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index c24f1e1..3b9f114 100644
