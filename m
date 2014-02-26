Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaBZQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:56:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbaBZQ4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:56:21 -0500
Date: Wed, 26 Feb 2014 17:56:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] wait: WSTOPPED|WCONTINUED doesn't work if a zombie
	leader is traced by another process
Message-ID: <20140226165607.GC22677@redhat.com>
References: <20140220173838.GA21825@redhat.com> <20140226165504.GA22677@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226165504.GA22677@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if the main thread is dead the process still can stop/continue.
However, if the leader is ptraced wait_consider_task(ptrace => false)
always skips wait_task_stopped/wait_task_continued, so WSTOPPED or
WCONTINUED can never work for the natural parent in this case.

Move the "A zombie ptracee is only visible to its ptracer" check into
the "if (!delay_group_leader(p))" block. ->notask_error is cleared by
the "fall through" code below.

This depends on the previous change, wait_task_stopped/continued must
be avoided if !delay_group_leader() and the tracer is ->real_parent.
Otherwise WSTOPPED|WEXITED could wrongly report "stopped" when the child
is already dead (single-threaded or not). If it is traced by another
task then the "stopped" state is fine until the debugger detaches and
reveals a zombie state.

Stupid test-case:

	void *tfunc(void *arg)
	{
		sleep(1);	// wait for zombie leader
		raise(SIGSTOP);
		exit(0x13);
		return NULL;
	}

	int run_child(void)
	{
		pthread_t thread;

		if (!fork()) {
			int tracee = getppid();

			assert(ptrace(PTRACE_ATTACH, tracee, 0,0) == 0);
			do
				ptrace(PTRACE_CONT, tracee, 0,0);
			while (wait(NULL) > 0);

			return 0;
		}

		sleep(1);	// wait for PTRACE_ATTACH
		assert(pthread_create(&thread, NULL, tfunc, NULL) == 0);
		pthread_exit(NULL);
	}

	int main(void)
	{
		int child, stat;

		child = fork();
		if (!child)
			return run_child();

		assert(child == waitpid(-1, &stat, WSTOPPED));
		assert(stat == 0x137f);

		kill(child, SIGCONT);

		assert(child == waitpid(-1, &stat, WCONTINUED));
		assert(stat == 0xffff);

		assert(child == waitpid(-1, &stat, 0));
		assert(stat == 0x1300);

		return 0;
	}

Without this patch it hangs in waitpid(WSTOPPED), wait_task_stopped()
is never called.

Note: this doesn't fix all problems with a zombie delay_group_leader(),
WCONTINUED | WEXITED check is not exactly right. debugger can't assume
it will be notified if another thread reaps the whole thread group.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 56c5ac3..790b73c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1382,20 +1382,16 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 
 	/* slay zombie? */
 	if (p->exit_state == EXIT_ZOMBIE) {
-		/*
-		 * A zombie ptracee is only visible to its ptracer.
-		 * Notification and reaping will be cascaded to the real
-		 * parent when the ptracer detaches.
-		 */
-		if (likely(!ptrace) && unlikely(p->ptrace)) {
-			/* it will become visible, clear notask_error */
-			wo->notask_error = 0;
-			return 0;
-		}
-
 		/* we don't reap group leaders with subthreads */
-		if (!delay_group_leader(p))
-			return wait_task_zombie(wo, p);
+		if (!delay_group_leader(p)) {
+			/*
+			 * A zombie ptracee is only visible to its ptracer.
+			 * Notification and reaping will be cascaded to the
+			 * real parent when the ptracer detaches.
+			 */
+			if (unlikely(ptrace) || likely(!p->ptrace))
+				return wait_task_zombie(wo, p);
+		}
 
 		/*
 		 * Allow access to stopped/continued state via zombie by
-- 
1.5.5.1


