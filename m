Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaHTLuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:50:10 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59029 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 064/104] mnt: Move the test for MNT_LOCK_READONLY from change_mount_flags into do_remount
Date: Wed, 20 Aug 2014 13:43:27 +0200
Message-Id: <e9758bf424b09f5a262b7dd1d55e504e955b1c13.1408535000.git.jslaby@suse.cz>
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

commit 07b645589dcda8b7a5249e096fece2a67556f0f4 upstream.

There are no races as locked mount flags are guaranteed to never change.

Moving the test into do_remount makes it more visible, and ensures all
filesystem remounts pass the MNT_LOCK_READONLY permission check.  This
second case is not an issue today as filesystem remounts are guarded
by capable(CAP_DAC_ADMIN) and thus will always fail in less privileged
mount namespaces, but it could become an issue in the future.

Cc: stable@vger.kernel.org
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/namespace.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 34fa7a52f373..8e90b037b706 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1806,9 +1806,6 @@ static int change_mount_flags(struct vfsmount *mnt, int ms_flags)
 	if (readonly_request == __mnt_is_readonly(mnt))
 		return 0;
 
-	if (mnt->mnt_flags & MNT_LOCK_READONLY)
-		return -EPERM;
-
 	if (readonly_request)
 		error = mnt_make_readonly(real_mount(mnt));
 	else
@@ -1834,6 +1831,16 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
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
2.0.4

