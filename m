Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab3HWSFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:05:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab3HWSFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:05:02 -0400
Date: Fri, 23 Aug 2013 19:59:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Colin Walters <walters@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] fork: unify and tighten up
	CLONE_NEWUSER/CLONE_NEWPID checks
Message-ID: <20130823175909.GA30229@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823175846.GA30201@redhat.com>
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
change copy_process() to do the same check along with ->pid_ns
check we already have.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/fork.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 27b5918..4a23dc4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1173,13 +1173,15 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		return ERR_PTR(-EINVAL);
 
 	/*
-	 * If the new process will be in a different pid namespace don't
-	 * allow it to share a thread group or signal handlers with the
-	 * forking task.
+	 * If the new process will be in a different pid or user namespace
+	 * do not allow it to share a thread group or signal handlers or
+	 * parent with the forking task.
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
@@ -1576,15 +1578,6 @@ long do_fork(unsigned long clone_flags,
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

