Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbaIOT4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:56:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbaIOTrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.10 42/71] mnt: Correct permission checks in do_remount
Date: Mon, 15 Sep 2014 12:26:40 -0700
Message-Id: <20140915192640.093925041@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192638.702282534@linuxfoundation.org>
References: <20140915192638.702282534@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 9566d6742852c527bf5af38af5cbb878dad75705 upstream.

While invesgiating the issue where in "mount --bind -oremount,ro ..."
would result in later "mount --bind -oremount,rw" succeeding even if
the mount started off locked I realized that there are several
additional mount flags that should be locked and are not.

In particular MNT_NOSUID, MNT_NODEV, MNT_NOEXEC, and the atime
flags in addition to MNT_READONLY should all be locked.  These
flags are all per superblock, can all be changed with MS_BIND,
and should not be changable if set by a more privileged user.

The following additions to the current logic are added in this patch.
- nosuid may not be clearable by a less privileged user.
- nodev  may not be clearable by a less privielged user.
- noexec may not be clearable by a less privileged user.
- atime flags may not be changeable by a less privileged user.

The logic with atime is that always setting atime on access is a
global policy and backup software and auditing software could break if
atime bits are not updated (when they are configured to be updated),
and serious performance degradation could result (DOS attack) if atime
updates happen when they have been explicitly disabled.  Therefore an
unprivileged user should not be able to mess with the atime bits set
by a more privileged user.

The additional restrictions are implemented with the addition of
MNT_LOCK_NOSUID, MNT_LOCK_NODEV, MNT_LOCK_NOEXEC, and MNT_LOCK_ATIME
mnt flags.

Taken together these changes and the fixes for MNT_LOCK_READONLY
should make it safe for an unprivileged user to create a user
namespace and to call "mount --bind -o remount,... ..." without
the danger of mount flags being changed maliciously.

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c        |   36 +++++++++++++++++++++++++++++++++---
 include/linux/mount.h |    5 +++++
 2 files changed, 38 insertions(+), 3 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -828,8 +828,21 @@ static struct mount *clone_mnt(struct mo
 
 	mnt->mnt.mnt_flags = old->mnt.mnt_flags & ~MNT_WRITE_HOLD;
 	/* Don't allow unprivileged users to change mount flags */
-	if ((flag & CL_UNPRIVILEGED) && (mnt->mnt.mnt_flags & MNT_READONLY))
-		mnt->mnt.mnt_flags |= MNT_LOCK_READONLY;
+	if (flag & CL_UNPRIVILEGED) {
+		mnt->mnt.mnt_flags |= MNT_LOCK_ATIME;
+
+		if (mnt->mnt.mnt_flags & MNT_READONLY)
+			mnt->mnt.mnt_flags |= MNT_LOCK_READONLY;
+
+		if (mnt->mnt.mnt_flags & MNT_NODEV)
+			mnt->mnt.mnt_flags |= MNT_LOCK_NODEV;
+
+		if (mnt->mnt.mnt_flags & MNT_NOSUID)
+			mnt->mnt.mnt_flags |= MNT_LOCK_NOSUID;
+
+		if (mnt->mnt.mnt_flags & MNT_NOEXEC)
+			mnt->mnt.mnt_flags |= MNT_LOCK_NOEXEC;
+	}
 
 	atomic_inc(&sb->s_active);
 	mnt->mnt.mnt_sb = sb;
@@ -1799,6 +1812,23 @@ static int do_remount(struct path *path,
 	    !(mnt_flags & MNT_READONLY)) {
 		return -EPERM;
 	}
+	if ((mnt->mnt.mnt_flags & MNT_LOCK_NODEV) &&
+	    !(mnt_flags & MNT_NODEV)) {
+		return -EPERM;
+	}
+	if ((mnt->mnt.mnt_flags & MNT_LOCK_NOSUID) &&
+	    !(mnt_flags & MNT_NOSUID)) {
+		return -EPERM;
+	}
+	if ((mnt->mnt.mnt_flags & MNT_LOCK_NOEXEC) &&
+	    !(mnt_flags & MNT_NOEXEC)) {
+		return -EPERM;
+	}
+	if ((mnt->mnt.mnt_flags & MNT_LOCK_ATIME) &&
+	    ((mnt->mnt.mnt_flags & MNT_ATIME_MASK) != (mnt_flags & MNT_ATIME_MASK))) {
+		return -EPERM;
+	}
+
 	err = security_sb_remount(sb, data);
 	if (err)
 		return err;
@@ -1998,7 +2028,7 @@ static int do_new_mount(struct path *pat
 		 */
 		if (!(type->fs_flags & FS_USERNS_DEV_MOUNT)) {
 			flags |= MS_NODEV;
-			mnt_flags |= MNT_NODEV;
+			mnt_flags |= MNT_NODEV | MNT_LOCK_NODEV;
 		}
 	}
 
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -46,9 +46,14 @@ struct mnt_namespace;
 				 | MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME \
 				 | MNT_READONLY)
 
+#define MNT_ATIME_MASK (MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME )
 
 #define MNT_INTERNAL	0x4000
 
+#define MNT_LOCK_ATIME		0x040000
+#define MNT_LOCK_NOEXEC		0x080000
+#define MNT_LOCK_NOSUID		0x100000
+#define MNT_LOCK_NODEV		0x200000
 #define MNT_LOCK_READONLY	0x400000
 
 struct vfsmount {


