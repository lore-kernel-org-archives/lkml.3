Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaBTRjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:39:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786AbaBTRjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:39:11 -0500
Date: Thu, 20 Feb 2014 18:39:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] wait: use EXIT_TRACE only if
	thread_group_leader(zombie)
Message-ID: <20140220173905.GA21856@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220173838.GA21825@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_task_zombie() always uses EXIT_TRACE/ptrace_unlink() if
ptrace_reparented(). This is suboptimal and a bit confusing:
we do not need do_notify_parent(p) if !thread_group_leader(p)
and in this case we also do not need ptrace_unlink(), we can
rely on ptrace_release_task().

Change wait_task_zombie() to check thread_group_leader() along
with ptrace_reparented() and simplify the final p->exit_state
transition.

Tested-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index c702824..aaad08d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1042,7 +1042,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	/*
 	 * Move the task's state to DEAD/TRACE, only one thread can do this.
 	 */
-	state = traced ? EXIT_TRACE : EXIT_DEAD;
+	state = traced && thread_group_leader(p) ? EXIT_TRACE : EXIT_DEAD;
 	if (cmpxchg(&p->exit_state, EXIT_ZOMBIE, state) != EXIT_ZOMBIE)
 		return 0;
 	/*
@@ -1142,18 +1142,15 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	if (!retval)
 		retval = pid;
 
-	if (traced) {
+	if (state == EXIT_TRACE) {
 		write_lock_irq(&tasklist_lock);
 		/* We dropped tasklist, ptracer could die and untrace */
 		ptrace_unlink(p);
-		/*
-		 * If this is not a sub-thread, notify the parent.
-		 * If parent wants a zombie, don't release it now.
-		 */
-		state = EXIT_DEAD;
-		if (thread_group_leader(p) &&
-		    !do_notify_parent(p, p->exit_signal))
-			state = EXIT_ZOMBIE;
+
+		/* If parent wants a zombie, don't release it now */
+		state = EXIT_ZOMBIE;
+		if (do_notify_parent(p, p->exit_signal))
+			state = EXIT_DEAD;
 		p->exit_state = state;
 		write_unlock_irq(&tasklist_lock);
 	}
-- 
1.5.5.1

