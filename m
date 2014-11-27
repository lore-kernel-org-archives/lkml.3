Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaK0IuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:50:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:42894 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbaK0IuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:50:02 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Francis Moreau <francis.moro@gmail.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 81/91] mnt: Only change user settable mount flags in remount
Date: Thu, 27 Nov 2014 16:43:04 +0800
Message-Id: <1417077794-9299-81-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit a6138db815df5ee542d848318e5dae681590fccd upstream.

Kenton Varda <kenton@sandstorm.io> discovered that by remounting a
read-only bind mount read-only in a user namespace the
MNT_LOCK_READONLY bit would be cleared, allowing an unprivileged user
to the remount a read-only mount read-write.

Correct this by replacing the mask of mount flags to preserve
with a mask of mount flags that may be changed, and preserve
all others.   This ensures that any future bugs with this mask and
remount will fail in an easy to detect way where new mount flags
simply won't change.

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Francis Moreau <francis.moro@gmail.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/namespace.c        | 2 +-
 include/linux/mount.h | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 2985879..f0f2e06 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1681,7 +1681,7 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 		err = do_remount_sb(sb, flags, data, 0);
 	if (!err) {
 		br_write_lock(vfsmount_lock);
-		mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
+		mnt_flags |= mnt->mnt.mnt_flags & ~MNT_USER_SETTABLE_MASK;
 		mnt->mnt.mnt_flags = mnt_flags;
 		br_write_unlock(vfsmount_lock);
 	}
diff --git a/include/linux/mount.h b/include/linux/mount.h
index d7029f4..2044aac 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -42,7 +42,9 @@ struct mnt_namespace;
  * flag, consider how it interacts with shared mounts.
  */
 #define MNT_SHARED_MASK	(MNT_UNBINDABLE)
-#define MNT_PROPAGATION_MASK	(MNT_SHARED | MNT_UNBINDABLE)
+#define MNT_USER_SETTABLE_MASK  (MNT_NOSUID | MNT_NODEV | MNT_NOEXEC \
+				 | MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME \
+				 | MNT_READONLY)
 
 
 #define MNT_INTERNAL	0x4000
-- 
1.9.1

