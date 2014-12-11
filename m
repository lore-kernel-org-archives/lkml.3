Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847AbaLKGiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 01:38:17 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52126 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933824AbaLKGiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 01:38:15 -0500
Date: Thu, 11 Dec 2014 07:38:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] tracing/sched: Check preempt_count() for current when
 reading task->state
Message-ID: <20141211063811.GD5059@gmail.com>
References: <20141210174428.3cb7542a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210174428.3cb7542a@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> When recording the state of a task for the sched_switch tracepoint a check of
> task_preempt_count() is performed to see if PREEMPT_ACTIVE is set. This is
> because, technically, a task being preempted is really in the TASK_RUNNING
> state, and that is what should be recorded when tracing a sched_switch,
> even if the task put itself into another state (it hasn't scheduled out
> in that state yet).
> 
> But with the change to use per_cpu preempt counts, the
> task_thread_info(p)->preempt_count is no longer used, and instead
> task_preempt_count(p) is used.
> 
> The problem is that this does not use the current preempt count but a
> stale one from a previous sched_switch. The task_preempt_count(p) uses
> saved_preempt_count and not preempt_count(). But for tracing
> sched_switch, if p is current, we really want preempt_count().
> 
> I hit this bug when I was tracing sleep and the call from do_nanosleep()
> scheduled out in the "RUNNING" state.
> 
>            sleep-4290  [000] 537272.259992: sched_switch:         sleep:4290 [120] R ==> swapper/0:0 [120]
>            sleep-4290  [000] 537272.260015: kernel_stack:         <stack trace>
> => __schedule (ffffffff8150864a)
> => schedule (ffffffff815089f8)
> => do_nanosleep (ffffffff8150b76c)
> => hrtimer_nanosleep (ffffffff8108d66b)
> => SyS_nanosleep (ffffffff8108d750)
> => return_to_handler (ffffffff8150e8e5)
> => tracesys_phase2 (ffffffff8150c844)
> 
> After a bit of hair pulling, I found that the state was really
> TASK_INTERRUPTIBLE, but the saved_preempt_count had an old PREEMPT_ACTIVE
> set and caused the sched_switch tracepoint to show it as RUNNING.
> 
> Cc: stable@vger.kernel.org # 3.13+
> Fixes: 01028747559a "sched: Create more preempt_count accessors"
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/trace/events/sched.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index 0a68d5ae584e..13fbadcc172b 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -97,10 +97,14 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
>  	long state = p->state;
>  
>  #ifdef CONFIG_PREEMPT
> +	unsigned long pc;
> +
> +	pc = (p == current) ? preempt_count() : task_preempt_count(p);
> +
>  	/*
>  	 * For all intents and purposes a preempted task is a running task.
>  	 */
> -	if (task_preempt_count(p) & PREEMPT_ACTIVE)
> +	if (pc & PREEMPT_ACTIVE)
>  		state = TASK_RUNNING | TASK_STATE_MAX;

I really don't like the overhead around here.

Thanks,

	Ingo
