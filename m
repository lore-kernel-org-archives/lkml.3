Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaJ0TC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:02:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52610 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaJ0TCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:02:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 096/105] mnt: Prevent pivot_root from creating a loop in the mount tree
Date: Mon, 27 Oct 2014 11:57:11 -0700
Message-Id: <1414436240-13879-97-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 0d0826019e529f21c84687521d03f60cd241ca7d upstream.

Andy Lutomirski recently demonstrated that when chroot is used to set
the root path below the path for the new ``root'' passed to pivot_root
the pivot_root system call succeeds and leaks mounts.

In examining the code I see that starting with a new root that is
below the current root in the mount tree will result in a loop in the
mount tree after the mounts are detached and then reattached to one
another.  Resulting in all kinds of ugliness including a leak of that
mounts involved in the leak of the mount loop.

Prevent this problem by ensuring that the new mount is reachable from
the current root of the mount tree.

[Added stable cc.  Fixes CVE-2014-7970.  --Andy]

Reported-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/87bnpmihks.fsf@x220.int.ebiederm.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index b1af425..fe2b527 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2812,6 +2812,9 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
 	/* make sure we can reach put_old from new_root */
 	if (!is_path_reachable(old_mnt, old.dentry, &new))
 		goto out4;
+	/* make certain new is below the root */
+	if (!is_path_reachable(new_mnt, new.dentry, &root))
+		goto out4;
 	root_mp->m_count++; /* pin it so it won't go away */
 	lock_mount_hash();
 	detach_mnt(new_mnt, &parent_path);
-- 
1.9.1

