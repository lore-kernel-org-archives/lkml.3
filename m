Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab3AWTVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 14:21:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3AWTVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 14:21:22 -0500
Date: Wed, 23 Jan 2013 20:19:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Yasunori Goto <y-goto@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Michael Davidson <md@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Julien Tinnes <jln@google.com>,
        Aaron Durbin <adurbin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@hack.frob.com>,
        Alexander Gordeev <agordeev@redhat.com>
Subject: TASK_DEAD && ttwu() again (Was: ensure arch_ptrace/ptrace_request
	can never race with SIGKILL)
Message-ID: <20130123191946.GA19101@redhat.com>
References: <20130118175224.GA520@redhat.com> <CA+55aFyEsU-pkX557A-m+xoGkA_v+fXEyA8z8HbJ5J8K1jObeg@mail.gmail.com> <20130118185559.GA3773@redhat.com> <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com> <20130120192448.GA6771@redhat.com> <20130120192527.GC6771@redhat.com> <CA+55aFx1+hFSCa4nX80C30BkEOugXRvBZ=7LA+u+KOq_qSaJsg@mail.gmail.com> <20130121172151.GA4691@redhat.com> <CA+55aFwRkvEP5YJy+a=TFgDX==YuU7CJ+D_U+B2s4e1LX-nz3g@mail.gmail.com> <20130121194723.GA18775@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121194723.GA18775@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid the confusion, this is not connected to ptrace_freeze_traced()
changes...

With or without these changes, there is another problem: a spurious
wakeup from try_to_wake_up(TASK_NORMAL) which doesn't necessarily see
the "right" task->state.

As for ptrace_stop() this is purely theoretical, but I thought that
perhaps it makes sense to extract the "mb + unlock_wait(pi_lock)" code
from do_exit() into the generic helper,
set_current_state_sync_because_we_cant_tolerate_a_wrong_wakeup().
But when I look at this code again I am not sure it is right.

Let me remind the problem. To oversimplify, we have

	try_to_wake_up(task, state)
	{
		lock(task->pi_lock);

		if (task->state & state)
			task->state = TASK_RUNNING;

		unlock(task->pi_lock);
	}

And this means that a task doing

	current->state = STATE_1;
	// no schedule() in between
	current->state = STATE_2;
	schedule();

can be actually woken up by try_to_wake_up(STATE_1) even if it already
sleeps in STATE_2.

Usually this is fine, any wait_event-like code should be careful. But
sometimes we can't afford the false wakeup, that is why do_wait() roughly
does

	do_exit()
	{
		// down_read(mmap_sem) can do this without schedule()
		current->state = TASK_UNINTERRUPTIBLE;
		current->state = TASK_RUNNING;

		mb();

		spin_unlock_wait(current->pi_lock);

		current->state = TASK_DEAD;
		schedule();
	}

This should ensure that any subsequent (after unlock_wait) try_to_wake_up()
can't see state == UNINTERRUPTIBLE and I think this works.

But. Somehow we missed the fact (I think) that we also need to serialize
unlock_wait() and "state = TASK_DEAD". The code above can be reordered,

	do_exit()
	{
		// down_read(mmap_sem) can do this without schedule()
		current->state = TASK_UNINTERRUPTIBLE;
		current->state = TASK_RUNNING;

		mb();

		current->state = TASK_DEAD;
		// !!! ttwu() can change ->state here !!!
		spin_unlock_wait(current->pi_lock);

		schedule();
	}

and we have the same problem again. So _I think_ that we we need another
mb() after unlock_wait() ?

And, afaics, in theory we can't simply move the current mb() down, after
unlock_wait().  (again, only in theory, if nothing else we should have
the implicit barrrers after we played with ->state in the past).

Or perhaps we should modify ttwu_do_wakeup() to not blindly set RUNNING,
say, cmpxchg(old_state, RUNNING). But this is not simple/nice.

Or I missed something?

Oleg.


--- x/kernel/exit.c
+++ x/kernel/exit.c
@@ -869,8 +869,15 @@ void do_exit(long code)
 	 * To avoid it, we have to wait for releasing tsk->pi_lock which
 	 * is held by try_to_wake_up()
 	 */
+
 	smp_mb();
 	raw_spin_unlock_wait(&tsk->pi_lock);
+	/*
+	 * The first mb() ensures that after that try_to_wake_up() must see
+	 * state == TASK_RUNNING. We need another one to ensure that we set
+	 * TASK_DEAD only after ->pi_lock is really unlocked.
+	 */
+	smp_mb();
 
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;

