Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbbA1ESl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:18:41 -0500
Received: from mail.kernel.org ([198.145.29.136]:38540 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761381AbbA1ESh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:18:37 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 054/177] mnt: Prevent pivot_root from creating a loop in the mount tree
Date: Wed, 28 Jan 2015 12:07:55 +0800
Message-Id: <1422418236-12852-108-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index f0f2e06..f7be8d9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2508,6 +2508,9 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
 	/* make sure we can reach put_old from new_root */
 	if (!is_path_reachable(real_mount(old.mnt), old.dentry, &new))
 		goto out4;
+	/* make certain new is below the root */
+	if (!is_path_reachable(new_mnt, new.dentry, &root))
+		goto out4;
 	br_write_lock(vfsmount_lock);
 	detach_mnt(new_mnt, &parent_path);
 	detach_mnt(root_mnt, &root_parent);
-- 
1.9.1

