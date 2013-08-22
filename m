Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3HVRQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:16:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab3HVRP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:15:59 -0400
Date: Thu, 22 Aug 2013 19:10:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Colin Walters <walters@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID
	checks
Message-ID: <20130822171004.GA20324@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822170939.GA20296@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_fork() denies CLONE_THREAD | CLONE_PARENT if NEWUSER | NEWPID.

Then later copy_process() denies CLONE_SIGHAND if the new process
will be in a different pid namespace (task_active_pid_ns() doesn't
match current->nsproxy->pid_ns).

This looks confusing and inconsistent. CLONE_NEWPID is very similar
to the case when ->pid_ns was already unshared, we want the same
restrictions so copy_process() should also nack CLONE_PARENT.

And it would be better to deny CLONE_NEWUSER && CLONE_SIGHAND as
well just for consistency.

Kill the "CLONE_NEWUSER | CLONE_NEWPID" check in do_fork() and
change copy_process() to the same check along with nsproxy->pid_ns
we already have.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8d56338..fae2ff7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1173,12 +1173,15 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		return ERR_PTR(-EINVAL);
 
 	/*
-	 * If the new process will be in a different pid namespace don't
-	 * allow the creation of threads, or share the signal handlers.
+	 * If the new process will be in a different pid or user namespace
+	 * don't allow the creation of threads, or share the signal handlers,
+	 * or share the parent.
 	 */
-	if ((clone_flags & CLONE_SIGHAND) &&
-	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
-		return ERR_PTR(-EINVAL);
+	if (clone_flags & (CLONE_SIGHAND | CLONE_PARENT)) {
+		if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
+		    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
+			return ERR_PTR(-EINVAL);
+	}
 
 	retval = security_task_create(clone_flags);
 	if (retval)
@@ -1575,15 +1578,6 @@ long do_fork(unsigned long clone_flags,
 	long nr;
 
 	/*
-	 * Do some preliminary argument and permissions checking before we
-	 * actually start allocating stuff
-	 */
-	if (clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) {
-		if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
-			return -EINVAL;
-	}
-
-	/*
 	 * Determine whether and which event to report to ptracer.  When
 	 * called from kernel_thread or CLONE_UNTRACED is explicitly
 	 * requested, no event is reported; otherwise, report if the event
-- 
1.5.5.1

