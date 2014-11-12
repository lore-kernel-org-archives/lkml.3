Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897AbaKLBje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:39:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934155AbaKLBj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:39:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.14 047/203] mnt: Prevent pivot_root from creating a loop in the mount tree
Date: Wed, 12 Nov 2014 10:15:17 +0900
Message-Id: <20141112011544.861607947@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2831,6 +2831,9 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	/* make sure we can reach put_old from new_root */
 	if (!is_path_reachable(old_mnt, old.dentry, &new))
 		goto out4;
+	/* make certain new is below the root */
+	if (!is_path_reachable(new_mnt, new.dentry, &root))
+		goto out4;
 	root_mp->m_count++; /* pin it so it won't go away */
 	lock_mount_hash();
 	detach_mnt(new_mnt, &parent_path);


