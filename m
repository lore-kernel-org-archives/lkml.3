Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbaHYQ6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:58:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59871 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbaHYQzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:55:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 09/13] mnt: Move the test for MNT_LOCK_READONLY from change_mount_flags into do_remount
Date: Mon, 25 Aug 2014 09:54:55 -0700
Message-Id: <1408985699-31838-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408985699-31838-1-git-send-email-kamal@canonical.com>
References: <1408985699-31838-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 07b645589dcda8b7a5249e096fece2a67556f0f4 upstream.

There are no races as locked mount flags are guaranteed to never change.

Moving the test into do_remount makes it more visible, and ensures all
filesystem remounts pass the MNT_LOCK_READONLY permission check.  This
second case is not an issue today as filesystem remounts are guarded
by capable(CAP_DAC_ADMIN) and thus will always fail in less privileged
mount namespaces, but it could become an issue in the future.

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/namespace.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ddbd5bc..9171ac3 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1740,9 +1740,6 @@ static int change_mount_flags(struct vfsmount *mnt, int ms_flags)
 	if (readonly_request == __mnt_is_readonly(mnt))
 		return 0;
 
-	if (mnt->mnt_flags & MNT_LOCK_READONLY)
-		return -EPERM;
-
 	if (readonly_request)
 		error = mnt_make_readonly(real_mount(mnt));
 	else
@@ -1771,6 +1768,16 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 
+	/* Don't allow changing of locked mnt flags.
+	 *
+	 * No locks need to be held here while testing the various
+	 * MNT_LOCK flags because those flags can never be cleared
+	 * once they are set.
+	 */
+	if ((mnt->mnt.mnt_flags & MNT_LOCK_READONLY) &&
+	    !(mnt_flags & MNT_READONLY)) {
+		return -EPERM;
+	}
 	err = security_sb_remount(sb, data);
 	if (err)
 		return err;
-- 
1.9.1

