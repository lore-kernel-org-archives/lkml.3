Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbbALSTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:19:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57626 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbbALSGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 072/216] umount: Disallow unprivileged mount force
Date: Mon, 12 Jan 2015 18:03:09 +0000
Message-Id: <1421085933-32536-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit b2f5d4dc38e034eecb7987e513255265ff9aa1cf upstream.

Forced unmount affects not just the mount namespace but the underlying
superblock as well.  Restrict forced unmount to the global root user
for now.  Otherwise it becomes possible a user in a less privileged
mount namespace to force the shutdown of a superblock of a filesystem
in a more privileged mount namespace, allowing a DOS attack on root.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index e718c7a0437a..67645ea593f2 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1448,6 +1448,9 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
 		goto dput_and_out;
 	if (mnt->mnt.mnt_flags & MNT_LOCKED)
 		goto dput_and_out;
+	retval = -EPERM;
+	if (flags & MNT_FORCE && !capable(CAP_SYS_ADMIN))
+		goto dput_and_out;
 
 	retval = do_umount(mnt, flags);
 dput_and_out:
-- 
2.1.4

