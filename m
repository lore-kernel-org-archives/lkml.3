Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbaJGTyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:54:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbaJGTyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:54:06 -0400
Date: Tue, 7 Oct 2014 21:50:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] sched: fix the PREEMPT_ACTIVE check in
	__trace_sched_switch_state()
Message-ID: <20141007195046.GA28002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And note that another caller of task_preempt_count(), set_cpu(), is
fine but it doesn't really need this helper.

And afaics we do not need ->saved_preempt_count at all, the trivial
patch below makes it unnecessary, we can kill it and all its users.

Not only this will simplify the code, this will make (well, almost)
the per-cpu preempt counter arch-agnostic.

Or I missed something?

Do you think this makes sense? If yes, I'll try to make the patches.

Oleg.
---

OBVIOUSLY INCOMPLETE, BREAKS EVERYTHING EXCEPT x86. Just to explain what
I mean.

(this depends on !__ARCH_WANT_UNLOCKED_CTXSW, but it was already removed
 and x86 doesn't use it anyway).


--- x/kernel/sched/core.c
+++ x/kernel/sched/core.c
@@ -2279,6 +2279,7 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
 {
 	struct rq *rq = this_rq();
 
+	preempt_count_set(PREEMPT_DISABLED);
 	finish_task_switch(rq, prev);
 
 	/*
@@ -2304,6 +2305,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	       struct task_struct *next)
 {
 	struct mm_struct *mm, *oldmm;
+	int pc;
 
 	prepare_task_switch(rq, prev, next);
 
@@ -2338,10 +2340,13 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	context_tracking_task_switch(prev, next);
+
 	/* Here we just switch the register state and the stack. */
+	pc = this_cpu_read(__preempt_count);
 	switch_to(prev, next, prev);
-
 	barrier();
+	preempt_count_set(pc);
+
 	/*
 	 * this_rq must be evaluated again because prev may have moved
 	 * CPUs since it called schedule(), thus the 'rq' on its stack

