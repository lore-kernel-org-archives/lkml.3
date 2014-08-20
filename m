Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaHTQ4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:56:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58134 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaHTQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:56:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 138/141] mnt: Only change user settable mount flags in remount
Date: Wed, 20 Aug 2014 17:56:29 +0100
Message-Id: <1408553792-25134-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/namespace.c        | 2 +-
 include/linux/mount.h | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ad8ea9bc2518..c98baa23e4d8 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1805,7 +1805,7 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 		err = do_remount_sb(sb, flags, data, 0);
 	if (!err) {
 		br_write_lock(&vfsmount_lock);
-		mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
+		mnt_flags |= mnt->mnt.mnt_flags & ~MNT_USER_SETTABLE_MASK;
 		mnt->mnt.mnt_flags = mnt_flags;
 		br_write_unlock(&vfsmount_lock);
 	}
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 73005f9957ea..16fc05d816d4 100644
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

