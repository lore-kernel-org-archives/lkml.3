Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaIOThl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:37:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbaIOThQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.14 073/114] mnt: Only change user settable mount flags in remount
Date: Mon, 15 Sep 2014 12:26:13 -0700
Message-Id: <20140915192643.727645955@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c        |    2 +-
 include/linux/mount.h |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1928,7 +1928,7 @@ static int do_remount(struct path *path,
 		err = do_remount_sb(sb, flags, data, 0);
 	if (!err) {
 		lock_mount_hash();
-		mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
+		mnt_flags |= mnt->mnt.mnt_flags & ~MNT_USER_SETTABLE_MASK;
 		mnt->mnt.mnt_flags = mnt_flags;
 		touch_mnt_namespace(mnt->mnt_ns);
 		unlock_mount_hash();
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
 
 #define MNT_INTERNAL_FLAGS (MNT_SHARED | MNT_WRITE_HOLD | MNT_INTERNAL | \
 			    MNT_DOOMED | MNT_SYNC_UMOUNT | MNT_MARKED)


