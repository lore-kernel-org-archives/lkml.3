Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab3ITUPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:15:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41693 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab3ITUO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 89/93] pidns: fix vfork() after unshare(CLONE_NEWPID)
Date: Fri, 20 Sep 2013 13:09:24 -0700
Message-Id: <1379707768-1804-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit e79f525e99b04390ca4d2366309545a836c03bf1 upstream.

Commit 8382fcac1b81 ("pidns: Outlaw thread creation after
unshare(CLONE_NEWPID)") nacks CLONE_VM if the forking process unshared
pid_ns, this obviously breaks vfork:

	int main(void)
	{
		assert(unshare(CLONE_NEWUSER | CLONE_NEWPID) == 0);
		assert(vfork() >= 0);
		_exit(0);
		return 0;
	}

fails without this patch.

Change this check to use CLONE_SIGHAND instead.  This also forbids
CLONE_THREAD automatically, and this is what the comment implies.

We could probably even drop CLONE_SIGHAND and use CLONE_THREAD, but it
would be safer to not do this.  The current check denies CLONE_SIGHAND
implicitely and there is no reason to change this.

Eric said "CLONE_SIGHAND is fine.  CLONE_THREAD would be even better.
Having shared signal handling between two different pid namespaces is
the case that we are fundamentally guarding against."

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Colin Walters <walters@redhat.com>
Acked-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/fork.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1c53e38..5c992f8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1170,10 +1170,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		return ERR_PTR(-EINVAL);
 
 	/*
-	 * If the new process will be in a different pid namespace
-	 * don't allow the creation of threads.
+	 * If the new process will be in a different pid namespace don't
+	 * allow it to share a thread group or signal handlers with the
+	 * forking task.
 	 */
-	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
+	if ((clone_flags & (CLONE_SIGHAND | CLONE_NEWPID)) &&
 	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
 		return ERR_PTR(-EINVAL);
 
-- 
1.8.1.2

