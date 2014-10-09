Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaJIRAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:00:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaJIRAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:00:37 -0400
Date: Thu, 9 Oct 2014 18:57:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] sched: schedule_tail() should disable preemption
Message-ID: <20141009165713.GA13118@redhat.com>
References: <20141007195046.GA28002@redhat.com> <20141008080016.GB10832@worktop.programming.kicks-ass.net> <20141008183302.GA17495@redhat.com> <20141008183326.GB17495@redhat.com> <20141008193644.GA32055@redhat.com> <1412804248.24248.1.camel@yandex.ru> <20141009145726.GA5604@redhat.com> <20141009151730.GW10832@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009151730.GW10832@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

let me first say that I understand that cleanups are always subjective.
So if you do not like it - I won't argue at all.

On 10/09, Peter Zijlstra wrote:
>
> On Thu, Oct 09, 2014 at 04:57:26PM +0200, Oleg Nesterov wrote:
>
> > but first we need to remove ->saved_preempt_count.
>
> Why do you want to kill that?

Because imo this makes the code a bit simpler. But (perhaps) mostly because
personally I dislike any "special" member in task_struct/thread_info, and
it seems to me that ->saved_preempt_count buys nothing. We only need it
to record/restore the counter before/after switch_to(), a local variably
looks better to me.

But again, see above. If the maintainer doesn't like the cleanup - then
it should be counted as uglification ;)

> Your earlier proposal would penalize every
> !x86 arch by adding extra code to the scheduler core while they already
> automagically preserve their thread_info::preempt_count.

Sure, and it can't be even compiled on !x86.

But this is simple, just we need a new helper, preempt_count_restore(),
defined as nop in asm-generic/preempt.h. Well, perhaps another helper
makes sense, preempt_count_raw() which simply reads the counter, but
this is minor.

After the patch below we can remove ->saved_preempt_count. Including
init_task_preempt_count(), it is no longer needed after the change in
schedule_tail().

No?

Oleg.


diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index 8f32718..695307f 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -27,6 +27,11 @@ static __always_inline void preempt_count_set(int pc)
 	raw_cpu_write_4(__preempt_count, pc);
 }
 
+static __always_inline void preempt_count_restore(int pc)
+{
+	preempt_count_set(pc);
+}
+
 /*
  * must be macros to avoid header recursion hell
  */
diff --git a/include/asm-generic/preempt.h b/include/asm-generic/preempt.h
index eb6f9e6..14de30e 100644
--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -20,6 +20,10 @@ static __always_inline void preempt_count_set(int pc)
 	*preempt_count_ptr() = pc;
 }
 
+static __always_inline void preempt_count_restore(int pc)
+{
+}
+
 /*
  * must be macros to avoid header recursion hell
  */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index cfe9905..ad8ca02 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2279,6 +2279,8 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
 {
 	struct rq *rq;
 
+	preempt_count_set(PREEMPT_DISABLED);
+
 	/* finish_task_switch() drops rq->lock and enables preemtion */
 	preempt_disable();
 	rq = this_rq();
@@ -2299,6 +2301,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	       struct task_struct *next)
 {
 	struct mm_struct *mm, *oldmm;
+	int pc;
 
 	prepare_task_switch(rq, prev, next);
 
@@ -2333,10 +2336,12 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	context_tracking_task_switch(prev, next);
+
+	pc = preempt_count();
 	/* Here we just switch the register state and the stack. */
 	switch_to(prev, next, prev);
-
 	barrier();
+	preempt_count_restore(pc);
 	/*
 	 * this_rq must be evaluated again because prev may have moved
 	 * CPUs since it called schedule(), thus the 'rq' on its stack

