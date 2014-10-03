Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbaJCXaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:30:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757650AbaJCX36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:29:58 -0400
Date: Sat, 4 Oct 2014 01:26:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, dvlasenk@redhat.com, tglx@linutronix.de,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: Re: [tip:x86/asm] x86: Speed up ___preempt_schedule*() by using
	THUNK helpers
Message-ID: <20141003232631.GA3439@redhat.com>
References: <20140921184153.GA23727@redhat.com> <tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org> <542E2B05.5080607@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542E2B05.5080607@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Sasha Levin wrote:
>
> On 09/24/2014 11:02 AM, tip-bot for Oleg Nesterov wrote:
> > Commit-ID:  0ad6e3c5199be12c9745da8f8b9e3c9f8066c235
> > Gitweb:     http://git.kernel.org/tip/0ad6e3c5199be12c9745da8f8b9e3c9f8066c235
> > Author:     Oleg Nesterov <oleg@redhat.com>
> > AuthorDate: Sun, 21 Sep 2014 20:41:53 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Wed, 24 Sep 2014 15:15:38 +0200
> >
> > x86: Speed up ___preempt_schedule*() by using THUNK helpers
> >
> > ___preempt_schedule() does SAVE_ALL/RESTORE_ALL but this is
> > suboptimal, we do not need to save/restore the callee-saved
> > register. And we already have arch/x86/lib/thunk_*.S which
> > implements the similar asm wrappers, so it makes sense to
> > redefine ___preempt_schedule() as "THUNK ..." and remove
> > preempt.S altogether.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > Reviewed-by: Andy Lutomirski <luto@amacapital.net>
> > Cc: Denys Vlasenko <dvlasenk@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Link: http://lkml.kernel.org/r/20140921184153.GA23727@redhat.com
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > ---
>
> Hi Oleg,
>
> I *think* that this patch is causing the following trace (arch/x86/lib/thunk_64.S:44
> is new code introduced by this patch):

So far I still do not think (at least I do not understand how) this patch
could introduce the problem. I can be wrong of course...

Let's look at this trace again,

> [  921.908530] kernel BUG at kernel/sched/core.c:2702!

OK, let's assume this is BUG_ON(unlikely(task_stack_end_corrupted(prev)))
in schedule_debug().

> [  921.909159] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  921.910084] Dumping ftrace buffer:
> [  921.910626]    (ftrace buffer empty)
> [  921.911178] Modules linked in:
> [  921.915690] CPU: 18 PID: 9489 Comm: trinity-c195 Not tainted 3.17.0-rc7-next-20141002-sasha-00031-gbdb4244 #1273
> [  921.917016] task: ffff8802bd748000 ti: ffff8802bda3c000 task.ti: ffff8802bda3c000
> [  921.917752] RIP: __schedule (kernel/sched/core.c:2702 kernel/sched/core.c:2808)
> [  921.917752] RSP: 0018:ffff8802bda3c360  EFLAGS: 00010297
> [  921.917752] RAX: ffff8802bda3c000 RBX: ffff8808501e2a00 RCX: 0000000000000001
> [  921.917752] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000286
> [  921.917752] RBP: ffff8802bda3c3c0 R08: 000000000001aa50 R09: 0000000000000000
> [  921.917752] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000012
> [  921.917752] R13: ffff8808501e2a00 R14: 0000000000000002 R15: ffff8802bda3c428
> [  921.917752] FS:  00007f5475cc2700(0000) GS:ffff880850000000(0000) knlGS:0000000000000000
> [  921.917752] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  921.917752] CR2: 00007f5475abe60c CR3: 00000002bebab000 CR4: 00000000000006a0
> [  921.917752] DR0: 00000000006f0000 DR1: 0000000000000000 DR2: 0000000000000000
> [  921.917752] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [  921.917752] Stack:
> [  921.917752]  000000000001aa50 ffff8802bd748000 ffff8802bda3ffd8 00000000001e2a00
> [  921.917752]  00000000001e2a00 ffff8802bd748000 ffff8802bda3c3a0 00000000001e2a00
> [  921.917752]  ffff8802bd748000 000000000001a9ea 0000000000000002 ffff8802bda3c428
> [  921.917752] Call Trace:
> [  921.917752] schedule_user (kernel/sched/core.c:2894 include/linux/jump_label.h:114 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:20 kernel/sched/core.c:2909)
> [  921.917752] int_careful (arch/x86/kernel/entry_64.S:560)
> [  921.917752] ? retint_careful (arch/x86/kernel/entry_64.S:889)
> [  921.917752] ? preempt_schedule (./arch/x86/include/asm/preempt.h:80 (discriminator 1) kernel/sched/core.c:2943 (discriminator 1))

...

> [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)

...

A lOT of repeats of above, so we can run out of stack and in this case
task_stack_end_corrupted() is clear.

> [  921.917752] ? __schedule (kernel/sched/core.c:2900)
> [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> [  921.917752] ? ftrace_ops_control_func (kernel/trace/ftrace.c:4780)
> [  921.917752] ? ftrace_call (arch/x86/kernel/mcount_64.S:56)
> [  921.917752] ? retint_careful (arch/x86/kernel/entry_64.S:886)
> [  921.917752] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [  921.917752] ? schedule_user (kernel/sched/core.c:2900)
> [  921.917752] ? schedule_user (kernel/sched/core.c:2900)
> [  921.917752] ? retint_careful (arch/x86/kernel/entry_64.S:889)


And I _think_ that preempt_schedule_context() should be fixed anyway,
although I am not sure there is no something else. It does:


	preempt_disable_notrace();
	prev_ctx = exception_enter();
	preempt_enable_no_resched_notrace();

	preempt_schedule();

	preempt_disable_notrace();
	exception_exit(prev_ctx);
	preempt_enable_notrace();

but exception_exit() is heavy, it is quite possible that TIF_NEED_RESCHED
and thus set_preempt_need_resched() can be set again when we call
preempt_enable_notrace(). And in this case preempt_schedule_context()
will be called recursively.

Frederic, how about the patch below?

In _theory_ this can explain this OOPS unless I am totally confused.

Oleg.

--- x/kernel/context_tracking.c
+++ x/kernel/context_tracking.c
@@ -134,15 +134,17 @@ asmlinkage __visible void __sched notrac
 	 * and the tracer calls preempt_enable_notrace() causing
 	 * an infinite recursion.
 	 */
-	preempt_disable_notrace();
-	prev_ctx = exception_enter();
-	preempt_enable_no_resched_notrace();
-
-	preempt_schedule();
-
-	preempt_disable_notrace();
-	exception_exit(prev_ctx);
-	preempt_enable_notrace();
+	do {
+		preempt_disable_notrace();
+		prev_ctx = exception_enter();
+		preempt_enable_no_resched_notrace();
+
+		preempt_schedule();
+
+		preempt_disable_notrace();
+		exception_exit(prev_ctx);
+		preempt_enable_no_resched_notrace();
+	} while (need_resched());
 }
 EXPORT_SYMBOL_GPL(preempt_schedule_context);
 #endif /* CONFIG_PREEMPT */

