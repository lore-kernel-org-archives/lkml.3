Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaE0V7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:59:31 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40477 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbaE0V7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:59:12 -0400
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
Subject: [RFC PATCH 2/2] loop: Permit priveleged operations within user namespaces
Date: Tue, 27 May 2014 23:58:56 +0200
Message-Id: <1401227936-15698-3-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
References: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Priveleged operations should be allowed on loop devices within a
devloop mount by root within the user namespace which owns the
mount. Stash away the namespace at mount time and allow
CAP_SYS_ADMIN within this namespace to perform priveleged
operations on loop devices.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/block/loop.c   | 27 ++++++++++++++++++++++-----
 fs/loopfs/inode.c      | 11 +++++++++++
 include/linux/loopfs.h |  7 +++++++
 3 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index b69e6e91af10..34ade8193ca1 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -86,6 +86,19 @@ static DEFINE_MUTEX(loop_index_mutex);
 static int max_part;
 static int part_shift;
 
+static bool loop_capable(struct loop_device *lo, int cap)
+{
+	struct user_namespace *ns;
+
+	if (lo->loopfs_inode) {
+		ns = loopfs_user_ns(loopfs_sb_from_inode(lo->loopfs_inode));
+		if (ns)
+			return ns_capable(ns, cap);
+	}
+
+	return capable(cap);
+}
+
 /*
  * Transfer functions
  */
@@ -1077,7 +1090,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 
 	if (lo->lo_encrypt_key_size &&
 	    !uid_eq(lo->lo_key_owner, uid) &&
-	    !capable(CAP_SYS_ADMIN))
+	    !loop_capable(lo, CAP_SYS_ADMIN))
 		return -EPERM;
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
@@ -1167,7 +1180,8 @@ loop_get_status(struct loop_device *lo, struct loop_info64 *info)
 	memcpy(info->lo_crypt_name, lo->lo_crypt_name, LO_NAME_SIZE);
 	info->lo_encrypt_type =
 		lo->lo_encryption ? lo->lo_encryption->number : 0;
-	if (lo->lo_encrypt_key_size && capable(CAP_SYS_ADMIN)) {
+	if (lo->lo_encrypt_key_size &&
+	    loop_capable(lo, CAP_SYS_ADMIN)) {
 		info->lo_encrypt_key_size = lo->lo_encrypt_key_size;
 		memcpy(info->lo_encrypt_key, lo->lo_encrypt_key,
 		       lo->lo_encrypt_key_size);
@@ -1312,7 +1326,8 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	case LOOP_SET_STATUS:
 		err = -EPERM;
-		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+		if ((mode & FMODE_WRITE) ||
+		    loop_capable(lo, CAP_SYS_ADMIN))
 			err = loop_set_status_old(lo,
 					(struct loop_info __user *)arg);
 		break;
@@ -1321,7 +1336,8 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	case LOOP_SET_STATUS64:
 		err = -EPERM;
-		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+		if ((mode & FMODE_WRITE) ||
+		    loop_capable(lo, CAP_SYS_ADMIN))
 			err = loop_set_status64(lo,
 					(struct loop_info64 __user *) arg);
 		break;
@@ -1330,7 +1346,8 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	case LOOP_SET_CAPACITY:
 		err = -EPERM;
-		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+		if ((mode & FMODE_WRITE) ||
+		    loop_capable(lo, CAP_SYS_ADMIN))
 			err = loop_set_capacity(lo, bdev);
 		break;
 	default:
diff --git a/fs/loopfs/inode.c b/fs/loopfs/inode.c
index 78dbaf831d9b..6410af5700c4 100644
--- a/fs/loopfs/inode.c
+++ b/fs/loopfs/inode.c
@@ -20,6 +20,7 @@
 #include <linux/miscdevice.h>
 #include <linux/parser.h>
 #include <linux/fsnotify.h>
+#include <linux/user_namespace.h>
 #include <linux/loopfs.h>
 
 static struct vfsmount *loopfs_mnt;
@@ -31,6 +32,7 @@ struct loop_mount_opts {
 struct loop_fs_info {
 	struct dentry *control_dentry;
 	struct loop_mount_opts opts;
+	struct user_namespace *user_ns;
 	kuid_t root_uid;
 	kgid_t root_gid;
 };
@@ -57,6 +59,13 @@ struct super_block *loopfs_sb_from_inode(struct inode *inode)
 	return loopfs_mnt->mnt_sb;
 }
 
+struct user_namespace *loopfs_user_ns(struct super_block *sb)
+{
+	if (!sb)
+		return NULL;
+	return LOOPFS_SB(sb)->user_ns;
+}
+
 static int mknod_loop_control(struct super_block *sb)
 {
 	int ret = 0;
@@ -147,6 +156,7 @@ static int loopfs_fill_super(struct super_block *s, void *data, int silent)
 		return -ENOMEM;
 
 	s->s_fs_info = fsi;
+	fsi->user_ns = get_user_ns(current_user_ns());
 
 	fsi->root_uid = make_kuid(current_user_ns(), 0);
 	if (!uid_valid(fsi->root_uid))
@@ -237,6 +247,7 @@ cleanup:
 static void loopfs_kill_sb(struct super_block *sb)
 {
 	loop_release_devices(sb);
+	put_user_ns(LOOPFS_SB(sb)->user_ns);
 	kfree(LOOPFS_SB(sb));
 	kill_litter_super(sb);
 }
diff --git a/include/linux/loopfs.h b/include/linux/loopfs.h
index 27deadd02364..a4ff5094073e 100644
--- a/include/linux/loopfs.h
+++ b/include/linux/loopfs.h
@@ -14,10 +14,12 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/magic.h>
+#include <linux/user_namespace.h>
 
 #ifdef CONFIG_BLK_DEV_LOOP
 
 struct super_block *loopfs_sb_from_inode(struct inode *inode);
+struct user_namespace *loopfs_user_ns(struct super_block *sb);
 struct inode *loopfs_new_dev(struct inode *ref_inode, dev_t device,
 			     int lo_number);
 void loopfs_kill_dev(struct inode *inode);
@@ -32,6 +34,11 @@ static inline struct super_block *loopfs_sb_from_inode(struct inode *inode)
 	return NULL;
 }
 
+static inline struct user_namespace *loopfs_user_ns(struct super_block *sb)
+{
+	return NULL;
+}
+
 static inline struct inode *loopfs_new_dev(struct inode *ref_inode,
 					   dev_t device, int lo_number)
 {
-- 
1.9.1

