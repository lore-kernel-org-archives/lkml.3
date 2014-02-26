Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaBZQzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:55:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbaBZQzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:55:42 -0500
Date: Wed, 26 Feb 2014 17:55:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] wait: WSTOPPED|WCONTINUED hangs if a zombie child is
	traced by real_parent
Message-ID: <20140226165529.GB22677@redhat.com>
References: <20140220173838.GA21825@redhat.com> <20140226165504.GA22677@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226165504.GA22677@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"A zombie is only visible to its ptracer" logic in wait_consider_task()
is very wrong. Trivial test-case:

	#include <unistd.h>
	#include <sys/ptrace.h>
	#include <sys/wait.h>
	#include <assert.h>

	int main(void)
	{
		int child = fork();

		if (!child) {
			assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);
			return 0x23;
		}

		assert(waitid(P_ALL, child, NULL, WEXITED | WNOWAIT) == 0);
		assert(waitid(P_ALL, 0, NULL, WSTOPPED) == -1);
		return 0;
	}

it hangs in waitpid(WSTOPPED) despite the fact it has a single zombie
child. This is because wait_consider_task(ptrace => 0) sees p->ptrace
and cleares ->notask_error assuming that the debugger should detach and
notify us.

Change wait_consider_task(ptrace => 0) to pretend that ptrace == T if
the child is traced by us. This really simplifies the logic and allows
us to do more fixes, see the next changes. This also hides the unwanted
group stop state automatically, we can remove another ptrace_reparented()
check.

Unfortunately, this adds the following behavioural changes:

	1. Before this patch wait(WEXITED | __WNOTHREAD) does not reap
	   a natural child if it is traced by the caller's sub-thread.

	   Hopefully nobody will ever notice this change, and I think
	   that nobody should rely on this behaviour anyway.

	2. SIGNAL_STOP_CONTINUED is no longer hidden from debugger if
	   it is real parent.

	   While this change comes as a side effect, I think it is good
	   by itself. The group continued state can not be consumed by
	   another process in this case, it doesn't depend on ptrace,
	   it doesn't make sense to hide it from real parent.

	   Perhaps we should add the thread_group_leader() check before
	   wait_task_continued()? May be, but this shouldn't depend on
	   ptrace_reparented().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 3d6f247..56c5ac3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1364,6 +1364,22 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		return 0;
 	}
 
+	if (likely(!ptrace) && unlikely(p->ptrace)) {
+		/*
+		 * If it is traced by its real parent's group, just pretend
+		 * the caller is ptrace_do_wait() and reap this child if it
+		 * is zombie.
+		 *
+		 * This also hides group stop state from real parent; otherwise
+		 * a single stop can be reported twice as group and ptrace stop.
+		 * If a ptracer wants to distinguish these two events for its
+		 * own children it should create a separate process which takes
+		 * the role of real parent.
+		 */
+		if (!ptrace_reparented(p))
+			ptrace = 1;
+	}
+
 	/* slay zombie? */
 	if (p->exit_state == EXIT_ZOMBIE) {
 		/*
@@ -1405,19 +1421,6 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 			wo->notask_error = 0;
 	} else {
 		/*
-		 * If @p is ptraced by a task in its real parent's group,
-		 * hide group stop/continued state when looking at @p as
-		 * the real parent; otherwise, a single stop can be
-		 * reported twice as group and ptrace stops.
-		 *
-		 * If a ptracer wants to distinguish the two events for its
-		 * own children, it should create a separate process which
-		 * takes the role of real parent.
-		 */
-		if (likely(!ptrace) && p->ptrace && !ptrace_reparented(p))
-			return 0;
-
-		/*
 		 * @p is alive and it's gonna stop, continue or exit, so
 		 * there always is something to wait for.
 		 */
-- 
1.5.5.1


