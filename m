Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3JYVBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 17:01:50 -0400
Received: from mail-pb0-f74.google.com ([209.85.160.74]:48038 "EHLO
	mail-pb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab3JYVBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 17:01:48 -0400
From: Aditya Kali <adityakali@google.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, tj@kernel.org,
        axboe@kernel.dk
Cc: Aditya Kali <adityakali@google.com>
Subject: [PATCH] vfs: avoid sb->s_umount write lock while changing bind-mount flags
Date: Fri, 25 Oct 2013 14:00:59 -0700
Message-Id: <1382734859-8115-1-git-send-email-adityakali@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During remount of a bind mount (mount -o remount,bind,ro,... /mnt/mntpt),
we currently take down_write(&sb->s_umount). This causes the remount
operation to get blocked behind writes occuring on device (possibly
mounted somewhere else). We have observed that simply trying to change
the bind-mount from read-write to read-only can take several seconds
becuase writeback is in progress (which takes read-lock on sb->s_umount).
Since we are not modifying the superblock during MS_BIND remount, it
should be enough to take a read-lock on sb->s_umount instead of the
write-lock to protect against parallel unmounts and (in conjunction with
vfsmount_lock) parallel remounts.
This patch fixes the locking so that the MS_BIND remount changes happen
only under down_read(&sb->s_umount).

Changes from RFC:
  Instead of completely removing the locking in MS_BIND case, take
  read-lock on sb->s_umount to protect against parallel unmount.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 fs/namespace.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index da5c494..cf74920 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -454,11 +454,13 @@ void mnt_drop_write_file(struct file *file)
 }
 EXPORT_SYMBOL(mnt_drop_write_file);
 
+/*
+ * Must be called under br_write_lock(&vfsmount_lock).
+ */
 static int mnt_make_readonly(struct mount *mnt)
 {
 	int ret = 0;
 
-	br_write_lock(&vfsmount_lock);
 	mnt->mnt.mnt_flags |= MNT_WRITE_HOLD;
 	/*
 	 * After storing MNT_WRITE_HOLD, we'll read the counters. This store
@@ -492,15 +494,15 @@ static int mnt_make_readonly(struct mount *mnt)
 	 */
 	smp_wmb();
 	mnt->mnt.mnt_flags &= ~MNT_WRITE_HOLD;
-	br_write_unlock(&vfsmount_lock);
 	return ret;
 }
 
+/*
+ * Must be called under br_write_lock(&vfsmount_lock).
+ */
 static void __mnt_unmake_readonly(struct mount *mnt)
 {
-	br_write_lock(&vfsmount_lock);
 	mnt->mnt.mnt_flags &= ~MNT_READONLY;
-	br_write_unlock(&vfsmount_lock);
 }
 
 int sb_prepare_remount_readonly(struct super_block *sb)
@@ -1796,6 +1798,9 @@ out:
 	return err;
 }
 
+/*
+ * Must be called under br_write_lock(&vfsmount_lock).
+ */
 static int change_mount_flags(struct vfsmount *mnt, int ms_flags)
 {
 	int error = 0;
@@ -1838,20 +1843,29 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	if (err)
 		return err;
 
-	down_write(&sb->s_umount);
-	if (flags & MS_BIND)
+	if (flags & MS_BIND) {
+		down_read(&sb->s_umount);
+		br_write_lock(&vfsmount_lock);
 		err = change_mount_flags(path->mnt, flags);
-	else if (!capable(CAP_SYS_ADMIN))
+		if (!err) {
+			mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
+			mnt->mnt.mnt_flags = mnt_flags;
+		}
+		br_write_unlock(&vfsmount_lock);
+		up_read(&sb->s_umount);
+	} else if (!capable(CAP_SYS_ADMIN))
 		err = -EPERM;
-	else
+	else {
+		down_write(&sb->s_umount);
 		err = do_remount_sb(sb, flags, data, 0);
-	if (!err) {
-		br_write_lock(&vfsmount_lock);
-		mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
-		mnt->mnt.mnt_flags = mnt_flags;
-		br_write_unlock(&vfsmount_lock);
+		if (!err) {
+			br_write_lock(&vfsmount_lock);
+			mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
+			mnt->mnt.mnt_flags = mnt_flags;
+			br_write_unlock(&vfsmount_lock);
+		}
+		up_write(&sb->s_umount);
 	}
-	up_write(&sb->s_umount);
 	if (!err) {
 		br_write_lock(&vfsmount_lock);
 		touch_mnt_namespace(mnt->mnt_ns);
-- 
1.8.4.1

