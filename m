Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaHTLuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:50:06 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59033 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752625AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 063/104] mnt: Only change user settable mount flags in remount
Date: Wed, 20 Aug 2014 13:43:26 +0200
Message-Id: <0cea279d6690fe30a628002907799566c9d4da1b.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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

Cc: stable@vger.kernel.org
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/namespace.c        | 2 +-
 include/linux/mount.h | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 84447dbcb650..34fa7a52f373 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1847,7 +1847,7 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 		err = do_remount_sb(sb, flags, data, 0);
 	if (!err) {
 		br_write_lock(&vfsmount_lock);
-		mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
+		mnt_flags |= mnt->mnt.mnt_flags & ~MNT_USER_SETTABLE_MASK;
 		mnt->mnt.mnt_flags = mnt_flags;
 		br_write_unlock(&vfsmount_lock);
 	}
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 38cd98f112a0..8707c9e9dbb9 100644
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
2.0.4

