Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab3GJCGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 22:06:45 -0400
Received: from mail-gg0-f179.google.com ([209.85.161.179]:51898 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3GJCGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 22:06:44 -0400
Date: Tue, 09 Jul 2013 21:06:39 -0500
From: Rob Landley <rob@landley.net>
Subject: [RESEND] The initmpfs patches.
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
X-Mailer: Balsa 2.4.11
Message-Id: <1373421999.27613.37@driftwood>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-3QL8TFex1ly7egIY+Clk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-3QL8TFex1ly7egIY+Clk
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Attached, so you don't have to fish them out of:

   http://lkml.indiana.edu/hypermail/linux/kernel/1306.3/04204.html

Do they look worth applying, or should I wash it through linux-next for =20
a bit? (Which I'm not sure how to do if I don't host a git tree on a =20
server, or I'd have done it already.)

There was a previous post with a patch demonstrating the basic concept =20
a while ago (https://lwn.net/Articles/545740/). This is the cleaned up, =20
broken up, tested in as many ways as I could think of, does not have =20
section mismatches, allows you to disable it at runtime, passes =20
checkpatch.pl version. Still applies to a git pull from 3 minutes ago =20
(two patches have offsets, but no fuzz).

Thanks,

Rob=

--=-3QL8TFex1ly7egIY+Clk
Content-Type: text/x-patch; charset=us-ascii; name=00.patch
Content-Disposition: attachment; filename=00.patch
Content-Transfer-Encoding: quoted-printable

From: Rob Landley <rob@landley.net>
Subject: [PATCH 0/5] initmpfs: use tmpfs instead of ramfs for rootfs
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Warren <swarren@nvidia.com>

Use tmpfs for rootfs when CONFIG_TMPFS=3Dy and there's no root=3D.
Specify rootfstype=3Dramfs to get the old initramfs behavior.

The previous initramfs code provided a fairly crappy root filesystem:
didn't let you --bind mount directories out of it, reported zero
size/usage so it didn't show up in "df" and couldn't run things like
rpm that query available space before proceeding, would fill up all
available memory and panic the system if you wrote too much to it...

Using tmpfs instead provides a much better root filesystem.
=

--=-3QL8TFex1ly7egIY+Clk
Content-Type: text/x-patch; charset=us-ascii; name=01.patch
Content-Disposition: attachment; filename=01.patch
Content-Transfer-Encoding: quoted-printable

From: Rob Landley <rob@landley.net>
Subject: [PATCH 1/5] initmpfs: replace MS_NOUSER in initramfs
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>

From: Rob Landley <rob@landley.net>

Mounting MS_NOUSER prevents --bind mounts from rootfs. Prevent new rootfs
mounts with a different mechanism that doesn't affect bind mounts.

Signed-off-by: Rob Landley <rob@landley.net>
---

 fs/ramfs/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index c24f1e1..14b9c35 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -247,7 +247,14 @@ struct dentry *ramfs_mount(struct file_system_type *fs=
_type,
 static struct dentry *rootfs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
-	return mount_nodev(fs_type, flags|MS_NOUSER, data, ramfs_fill_super);
+	static int once;
+
+	if (once)
+		return ERR_PTR(-ENODEV);
+	else
+		once++;
+
+	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
 }
=20
 static void ramfs_kill_sb(struct super_block *sb)
=

--=-3QL8TFex1ly7egIY+Clk
Content-Type: text/x-patch; charset=us-ascii; name=02.patch
Content-Disposition: attachment; filename=02.patch
Content-Transfer-Encoding: quoted-printable

From: Rob Landley <rob@landley.net>
Subject: [PATCH 2/5] initmpfs: Move bdi setup from init_rootfs to init_ramf=
s
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>

From: Rob Landley <rob@landley.net>

Even though ramfs hasn't got a backing device, commit e0bf68ddec4f added on=
e
anyway, and put the initialization in init_rootfs() since that's the first
user, leaving it out of init_ramfs() to avoid duplication.

But initmpfs uses init_tmpfs() instead, so move the init into the filesyste=
m's
init function, add a "once" guard to prevent duplicate initialization, and
call the filesystem init from rootfs init.

This goes part of the way to allowing ramfs to be built as a module.

Signed-off-by: Rob Landley <rob@landley.net>
---

 fs/ramfs/inode.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- initold/fs/ramfs/inode.c	2013-06-28 15:12:03.205879730 -0500
+++ initold2/fs/ramfs/inode.c	2013-06-28 15:12:12.425880115 -0500
@@ -277,21 +277,36 @@
=20
 static int __init init_ramfs_fs(void)
 {
-	return register_filesystem(&ramfs_fs_type);
+	static int once;
+	int err;
+
+	if (once)
+		return 0;
+	else
+		once++;
+
+	err =3D bdi_init(&ramfs_backing_dev_info);
+	if (err)
+		return err;
+
+	err =3D register_filesystem(&ramfs_fs_type);
+	if (err)
+		bdi_destroy(&ramfs_backing_dev_info);
+
+	return err;
 }
 module_init(init_ramfs_fs)
=20
 int __init init_rootfs(void)
 {
-	int err;
+	int err =3D register_filesystem(&rootfs_fs_type);
=20
-	err =3D bdi_init(&ramfs_backing_dev_info);
 	if (err)
 		return err;
=20
-	err =3D register_filesystem(&rootfs_fs_type);
+	err =3D init_ramfs_fs();
 	if (err)
-		bdi_destroy(&ramfs_backing_dev_info);
+		unregister_filesystem(&rootfs_fs_type);
=20
 	return err;
 }
=

--=-3QL8TFex1ly7egIY+Clk
Content-Type: text/x-patch; charset=us-ascii; name=03.patch
Content-Disposition: attachment; filename=03.patch
Content-Transfer-Encoding: quoted-printable

From: Rob Landley <rob@landley.net>
Subject: [PATCH 3/5] initmpfs: Move rootfs code from fs/ramfs/ to init/
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>

From: Rob Landley <rob@landley.net>

When the rootfs code was a wrapper around ramfs, having them in the same
file made sense. Now that it can wrap another filesystem type, move it
in with the init code instead.

This also allows a subsequent patch to access rootfstype=3D command line ar=
g.

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
=20
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
 	.kill_sb	=3D ramfs_kill_sb,
 	.fs_flags	=3D FS_USERNS_MOUNT,
 };
-static struct file_system_type rootfs_fs_type =3D {
-	.name		=3D "rootfs",
-	.mount		=3D rootfs_mount,
-	.kill_sb	=3D kill_litter_super,
-};
=20
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
-	int err =3D register_filesystem(&rootfs_fs_type);
-
-	if (err)
-		return err;
-
-	err =3D init_ramfs_fs();
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
=20
 extern void (*late_time_init)(void);
=20
--- initold/include/linux/ramfs.h	2013-06-28 15:09:19.537872910 -0500
+++ initold2/include/linux/ramfs.h	2013-06-28 15:16:05.513889832 -0500
@@ -25,7 +25,7 @@
=20
 extern const struct file_operations ramfs_file_operations;
 extern const struct vm_operations_struct generic_file_vm_ops;
-extern int __init init_rootfs(void);
+extern int __init init_ramfs_fs(void);
=20
 int ramfs_fill_super(struct super_block *sb, void *data, int silent);
=20
--- initold/init/do_mounts.c	2013-06-28 15:09:19.585872913 -0500
+++ initold2/init/do_mounts.c	2013-06-28 15:16:05.561889831 -0500
@@ -26,6 +26,7 @@
 #include <linux/async.h>
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
+#include <linux/ramfs.h>
=20
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
+static struct file_system_type rootfs_fs_type =3D {
+	.name		=3D "rootfs",
+	.mount		=3D rootfs_mount,
+	.kill_sb	=3D kill_litter_super,
+};
+
+int __init init_rootfs(void)
+{
+	int err =3D register_filesystem(&rootfs_fs_type);
+
+	if (err)
+		return err;
+
+	err =3D init_ramfs_fs();
+	if (err)
+		unregister_filesystem(&rootfs_fs_type);
+
+	return err;
+}
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index c24f1e1..3b9f114 100644
=

--=-3QL8TFex1ly7egIY+Clk
Content-Type: text/x-patch; charset=us-ascii; name=04.patch
Content-Disposition: attachment; filename=04.patch
Content-Transfer-Encoding: quoted-printable

From: Rob Landley <rob@landley.net>
Subject: [PATCH 4/5] initmpfs: Make rootfs use tmpfs when CONFIG_TMPFS enab=
led.
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>

From: Rob Landley <rob@landley.net>

Conditionally call the appropriate fs_init function and fill_super function=
s.
Add a use once guard to shmem_init() to simply succeed on a second call.

(Note that IS_ENABLED() is a compile time constant so dead code elimination
removes unused function calls when CONFIG_TMPFS is disabled.)

Signed-off-by: Rob Landley <rob@landley.net>
---

 init/do_mounts.c |   10 ++++++++--
 mm/shmem.c       |    4 ++++
 2 files changed, 12 insertions(+), 2 deletions(-)

--- initold/init/do_mounts.c	2013-06-27 00:02:26.283442977 -0500
+++ initwork/init/do_mounts.c	2013-06-27 00:45:21.599550312 -0500
@@ -27,6 +27,7 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/ramfs.h>
+#include <linux/shmem_fs.h>
=20
 #include <linux/nfs_fs.h>
 #include <linux/nfs_fs_sb.h>
@@ -600,7 +599,8 @@
 	else
 		once++;
=20
-	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
+	return mount_nodev(fs_type, flags, data,
+		IS_ENABLED(CONFIG_TMPFS) ? shmem_fill_super : ramfs_fill_super);
 }
=20
 static struct file_system_type rootfs_fs_type =3D {
@@ -616,7 +616,11 @@
 	if (err)
 		return err;
=20
-	err =3D init_ramfs_fs();
+	if (IS_ENABLED(CONFIG_TMPFS))
+		err =3D shmem_init();
+	else
+		err =3D init_ramfs_fs();
+
 	if (err)
 		unregister_filesystem(&rootfs_fs_type);
=20
--- initold/mm/shmem.c	2013-06-25 13:09:22.215743137 -0500
+++ initwork/mm/shmem.c	2013-06-27 00:16:58.195479317 -0500
@@ -2787,6 +2787,10 @@
 {
 	int error;
=20
+	/* If rootfs called this, don't re-init */
+	if (shmem_inode_cachep)
+		return 0;
+
 	error =3D bdi_init(&shmem_backing_dev_info);
 	if (error)
 		goto out4;
=

--=-3QL8TFex1ly7egIY+Clk
Content-Type: text/x-patch; charset=us-ascii; name=05.patch
Content-Disposition: attachment; filename=05.patch
Content-Transfer-Encoding: quoted-printable

From: Rob Landley <rob@landley.net>
Subject: [PATCH 5/5] initmpfs: Use initramfs if rootfstype=3D or root=3D sp=
ecified.
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

From: Rob Landley <rob@landley.net>

Command line option rootfstype=3Dramfs to obtain old initramfs behavior,
and use ramfs instead of tmpfs for stub when root=3D defined (for cosmetic
reasons).

Signed-off-by: Rob Landley <rob@landley.net>
---

 init/do_mounts.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- initold/init/do_mounts.c	2013-06-29 13:27:00.485256840 -0500
+++ initwork/init/do_mounts.c	2013-06-29 13:34:17.925275072 -0500
@@ -591,18 +591,22 @@
 	sys_chroot(".");
 }
=20
+static bool is_tmpfs;
 static struct dentry *rootfs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
 	static int once;
+	void *fill =3D ramfs_fill_super;
=20
 	if (once)
 		return ERR_PTR(-ENODEV);
 	else
 		once++;
=20
-	return mount_nodev(fs_type, flags, data,
-		IS_ENABLED(CONFIG_TMPFS) ? shmem_fill_super : ramfs_fill_super);
+	if (IS_ENABLED(CONFIG_TMPFS) && is_tmpfs)
+		fill =3D shmem_fill_super;
+
+	return mount_nodev(fs_type, flags, data, fill);
 }
=20
 static struct file_system_type rootfs_fs_type =3D {
@@ -618,9 +622,12 @@
 	if (err)
 		return err;
=20
-	if (IS_ENABLED(CONFIG_TMPFS))
+	if (IS_ENABLED(CONFIG_TMPFS) && !saved_root_name[0] &&
+		(!root_fs_names || strstr(root_fs_names, "tmpfs")))
+	{
 		err =3D shmem_init();
-	else
+		is_tmpfs =3D true;
+	} else
 		err =3D init_ramfs_fs();
=20
 	if (err)
=

--=-3QL8TFex1ly7egIY+Clk--
