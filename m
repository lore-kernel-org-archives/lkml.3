Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab3HWSE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:04:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864Ab3HWSE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:04:57 -0400
Date: Fri, 23 Aug 2013 19:59:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Colin Walters <walters@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] pidns: fix vfork() after unshare(CLONE_NEWPID)
Message-ID: <20130823175903.GA30219@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823175846.GA30201@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8382fcac "pidns: Outlaw thread creation after unshare(CLONE_NEWPID)"
nacks CLONE_VM if the forking process unshared pid_ns, this obviously
breaks vfork:

	int main(void)
	{
		assert(unshare(CLONE_NEWUSER | CLONE_NEWPID) == 0);
		assert(vfork() >= 0);
		_exit(0);
		return 0;
	}

fails without this patch.

Change this check to use CLONE_SIGHAND instead. This also forbids
CLONE_THREAD automatically, and this is what the comment implies.

We could probably even drop CLONE_SIGHAND and use CLONE_THREAD,
but it would be safer to not do this. The current check denies
CLONE_SIGHAND implicitely and there is no reason to change this.

Reported-by: Colin Walters <walters@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/fork.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index e23bb19..29c9f6b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1173,10 +1173,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
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
1.5.5.1

