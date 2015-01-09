Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbbAIKk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:40:27 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44590 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757491AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 56/78] umount: Disallow unprivileged mount force
Date: Fri,  9 Jan 2015 11:32:05 +0100
Message-Id: <e3783a9e6f416ee140ac4ca7184f269c537593f1.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b2f5d4dc38e034eecb7987e513255265ff9aa1cf upstream.

Forced unmount affects not just the mount namespace but the underlying
superblock as well.  Restrict forced unmount to the global root user
for now.  Otherwise it becomes possible a user in a less privileged
mount namespace to force the shutdown of a superblock of a filesystem
in a more privileged mount namespace, allowing a DOS attack on root.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 6b42c6d1590e..7c3c0f6d2744 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1347,6 +1347,9 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
 		goto dput_and_out;
 	if (mnt->mnt.mnt_flags & MNT_LOCKED)
 		goto dput_and_out;
+	retval = -EPERM;
+	if (flags & MNT_FORCE && !capable(CAP_SYS_ADMIN))
+		goto dput_and_out;
 
 	retval = do_umount(mnt, flags);
 dput_and_out:
-- 
2.2.1

