Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbaKROJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:09:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbaKROJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:44 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 079/206] mnt: Prevent pivot_root from creating a loop in the mount tree
Date: Tue, 18 Nov 2014 15:07:14 +0100
Message-Id: <365446fe1c7bf1b481cedfb9e50cfc8a86fdde89.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 4b14bfc4cfce..d00750d2f91e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2747,6 +2747,9 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
 	/* make sure we can reach put_old from new_root */
 	if (!is_path_reachable(old_mnt, old.dentry, &new))
 		goto out4;
+	/* make certain new is below the root */
+	if (!is_path_reachable(new_mnt, new.dentry, &root))
+		goto out4;
 	root_mp->m_count++; /* pin it so it won't go away */
 	br_write_lock(&vfsmount_lock);
 	detach_mnt(new_mnt, &parent_path);
-- 
2.1.3

