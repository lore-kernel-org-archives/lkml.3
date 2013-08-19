Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab3HSRbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:31:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab3HSRbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:31:10 -0400
Date: Mon, 19 Aug 2013 19:25:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Colin Walters <walters@redhat.com>, linux-kernel@vger.kernel.org
Subject: PATCH? fix unshare(NEWPID) && vfork()
Message-ID: <20130819172524.GA22268@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Colin reports that vfork() doesn't work after unshare(PIDNS). The
reason is trivial, copy_process() does:

	/*
	 * If the new process will be in a different pid namespace
	 * don't allow the creation of threads.
	 */
	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
		return ERR_PTR(-EINVAL);

and CLONE_VM obviously nacks vfork(). So perhaps we can relax
this check to CLONE_THREAD? Or should we really nack CLONE_VM
by security reasons?

OTOH. Perhaps we should also deny CLONE_PARENT in this case?

In short. So far I am thinking about the patch below but I got
lost and totally confused. Will try to think more tomorrow, but
I would like to see the fix from someone who still understands
this all.

Oleg.

--- x/kernel/fork.c	2013-08-14 18:34:06.000000000 +0200
+++ x/kernel/fork.c	2013-08-19 19:03:43.848823039 +0200
@@ -1172,14 +1172,6 @@ static struct task_struct *copy_process(
 				current->signal->flags & SIGNAL_UNKILLABLE)
 		return ERR_PTR(-EINVAL);
 
-	/*
-	 * If the new process will be in a different pid namespace
-	 * don't allow the creation of threads.
-	 */
-	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
-	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
-		return ERR_PTR(-EINVAL);
-
 	retval = security_task_create(clone_flags);
 	if (retval)
 		goto fork_out;
@@ -1578,8 +1570,9 @@ long do_fork(unsigned long clone_flags,
 	 * Do some preliminary argument and permissions checking before we
 	 * actually start allocating stuff
 	 */
-	if (clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) {
-		if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
+	if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
+	    (task_active_pid_ns(current) != current->nsproxy->pid_ns)) {
+		if (clone_flags & (CLONE_THREAD | CLONE_PARENT | CLONE_NEWPID))
 			return -EINVAL;
 	}
 

