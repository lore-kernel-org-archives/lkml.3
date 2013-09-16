Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3IPRmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 13:42:42 -0400
Received: from mail-yh0-f73.google.com ([209.85.213.73]:54873 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3IPRml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:42:41 -0400
From: Aditya Kali <adityakali@google.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: anatol@google.com, Aditya Kali <adityakali@google.com>
Subject: [RFC] vfs: avoid sb->s_umount lock while changing bind-mount flags
Date: Mon, 16 Sep 2013 10:42:30 -0700
Message-Id: <1379353350-11320-1-git-send-email-adityakali@google.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During remount of a bind mount (mount -o remount,bind,ro,... /mnt/mntpt),
we currently take down_write(&sb->s_umount). This causes the remount
operation to get blocked behind writes occuring on device (possibly
mounted somewhere else). We have observed that simply trying to change
the bind-mount from read-write to read-only can take several seconds
becuase writeback is in progress. Looking at the code it seems to me that
we need s_umount lock only around the do_remount_sb() call.
vfsmount_lock seems enough to protect the flag change on the mount.
So this patch fixes the locking so that changing of flags can happen
outside the down_write(&sb->s_umount).

I wanted to get comments if I am violating any assumption around this code.
Another thing that I was curious about was if we need the
{lock|unlock}_mount(path) around this code. Please advise.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 fs/namespace.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index da5c494..4b9c839 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1838,20 +1838,21 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	if (err)
 		return err;
 
-	down_write(&sb->s_umount);
 	if (flags & MS_BIND)
 		err = change_mount_flags(path->mnt, flags);
 	else if (!capable(CAP_SYS_ADMIN))
 		err = -EPERM;
-	else
+	else {
+		down_write(&sb->s_umount);
 		err = do_remount_sb(sb, flags, data, 0);
+		up_write(&sb->s_umount);
+	}
 	if (!err) {
 		br_write_lock(&vfsmount_lock);
 		mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
 		mnt->mnt.mnt_flags = mnt_flags;
 		br_write_unlock(&vfsmount_lock);
 	}
-	up_write(&sb->s_umount);
 	if (!err) {
 		br_write_lock(&vfsmount_lock);
 		touch_mnt_namespace(mnt->mnt_ns);
-- 
1.8.4

