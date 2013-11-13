Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab3KMH0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 02:26:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:2088 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758570Ab3KMH0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 02:26:47 -0500
X-IronPort-AV: E=Sophos;i="4.93,690,1378828800"; 
   d="scan'208";a="9022494"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: containers@lists.linux-foundation.org
Cc: ebiederm@xmission.com, linux-fsdevel@vger.kernel.org, serge@hallyn.com,
        linux-kernel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] userns: allow privileged user to operate locked mount
Date: Wed, 13 Nov 2013 15:27:43 +0800
Message-Id: <1384327663-12032-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/13 15:24:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/13 15:24:58,
	Serialize complete at 2013/11/13 15:24:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Privileged user should have rights to mount/umount/move
these even locked mount.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 fs/namespace.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index da5c494..7097fc7 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1297,6 +1297,11 @@ static inline bool may_mount(void)
 	return ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN);
 }
 
+static inline bool may_mount_lock(struct mount *mnt)
+{
+	return !(mnt->mnt.mnt_flags & MNT_LOCKED) || capable(CAP_SYS_ADMIN);
+}
+
 /*
  * Now umount can handle mount points as well as block devices.
  * This is important for filesystems which use unnamed block devices.
@@ -1330,7 +1335,7 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
 		goto dput_and_out;
 	if (!check_mnt(mnt))
 		goto dput_and_out;
-	if (mnt->mnt.mnt_flags & MNT_LOCKED)
+	if (!may_mount_lock(mnt))
 		goto dput_and_out;
 
 	retval = do_umount(mnt, flags);
@@ -1768,7 +1773,8 @@ static int do_loopback(struct path *path, const char *old_name,
 	if (!check_mnt(parent) || !check_mnt(old))
 		goto out2;
 
-	if (!recurse && has_locked_children(old, old_path.dentry))
+	if (!recurse && has_locked_children(old, old_path.dentry) &&
+	    !capable(CAP_SYS_ADMIN))
 		goto out2;
 
 	if (recurse)
@@ -1895,7 +1901,7 @@ static int do_move_mount(struct path *path, const char *old_name)
 	if (!check_mnt(p) || !check_mnt(old))
 		goto out1;
 
-	if (old->mnt.mnt_flags & MNT_LOCKED)
+	if (!may_mount_lock(old))
 		goto out1;
 
 	err = -EINVAL;
@@ -2679,7 +2685,7 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
 		goto out4;
 	if (!check_mnt(root_mnt) || !check_mnt(new_mnt))
 		goto out4;
-	if (new_mnt->mnt.mnt_flags & MNT_LOCKED)
+	if (!may_mount_lock(new_mnt))
 		goto out4;
 	error = -ENOENT;
 	if (d_unlinked(new.dentry))
-- 
1.8.3.1

