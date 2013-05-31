Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab3EaNnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 09:43:32 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:40375 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3EaNnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 09:43:24 -0400
Date: Fri, 31 May 2013 15:43:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH][RFC] tracing/context-tracking: Add
 preempt_schedule_context() for tracing
Message-ID: <20130531134319.GE5932@somewhere>
References: <1369943981.26799.43.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369943981.26799.43.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 03:59:41PM -0400, Steven Rostedt wrote:
> [ Peter and Frederic, can you give me ACKs on this? Thanks ]
> 
> Dave Jones hit the following bug report:
> 
>  ===============================
>  [ INFO: suspicious RCU usage. ]
>  3.10.0-rc2+ #1 Not tainted
>  -------------------------------
>  include/linux/rcupdate.h:771 rcu_read_lock() used illegally while idle!
>  other info that might help us debug this:
>  RCU used illegally from idle CPU! rcu_scheduler_active = 1, debug_locks = 0
>  RCU used illegally from extended quiescent state!
>  2 locks held by cc1/63645:
>   #0:  (&rq->lock){-.-.-.}, at: [<ffffffff816b39fd>] __schedule+0xed/0x9b0
>   #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff8109d645>] cpuacct_charge+0x5/0x1f0
> 
>  CPU: 1 PID: 63645 Comm: cc1 Not tainted 3.10.0-rc2+ #1 [loadavg: 40.57 27.55 13.39 25/277 64369]
>  Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
>   0000000000000000 ffff88010f78fcf8 ffffffff816ae383 ffff88010f78fd28
>   ffffffff810b698d ffff88011c092548 000000000023d073 ffff88011c092500
>   0000000000000001 ffff88010f78fd60 ffffffff8109d7c5 ffffffff8109d645
>  Call Trace:
>   [<ffffffff816ae383>] dump_stack+0x19/0x1b
>   [<ffffffff810b698d>] lockdep_rcu_suspicious+0xfd/0x130
>   [<ffffffff8109d7c5>] cpuacct_charge+0x185/0x1f0
>   [<ffffffff8109d645>] ? cpuacct_charge+0x5/0x1f0
>   [<ffffffff8108dffc>] update_curr+0xec/0x240
>   [<ffffffff8108f528>] put_prev_task_fair+0x228/0x480
>   [<ffffffff816b3a71>] __schedule+0x161/0x9b0
>   [<ffffffff816b4721>] preempt_schedule+0x51/0x80
>   [<ffffffff816b4800>] ? __cond_resched_softirq+0x60/0x60
>   [<ffffffff816b6824>] ? retint_careful+0x12/0x2e
>   [<ffffffff810ff3cc>] ftrace_ops_control_func+0x1dc/0x210
>   [<ffffffff816be280>] ftrace_call+0x5/0x2f
>   [<ffffffff816b681d>] ? retint_careful+0xb/0x2e
>   [<ffffffff816b4805>] ? schedule_user+0x5/0x70
>   [<ffffffff816b4805>] ? schedule_user+0x5/0x70
>   [<ffffffff816b6824>] ? retint_careful+0x12/0x2e
>  ------------[ cut here ]------------
> 
> What happened was that the function tracer traced the schedule_user() code
> that tells RCU that the system is coming back from userspace, and to
> add the CPU back to the RCU monitoring.
> 
> Because the function tracer does a preempt_disable/enable_notrace() calls
> the preempt_enable_notrace() checks the NEED_RESCHED flag. If it is set,
> then preempt_schedule() is called. But this is called before the user_exit()
> function can inform the kernel that the CPU is no longer in user mode and
> needs to be accounted for by RCU.
> 
> The fix is to create a new preempt_schedule_context() that checks if
> the kernel is still in user mode and if so to switch it to kernel mode
> before calling schedule. It also switches back to user mode coming back
> from schedule in need be.
> 
> The only user of this currently is the preempt_enable_notrace(), which is
> only used by the tracing subsystem.
> 
> Link: http://lkml.kernel.org/r/1369423420.6828.226.camel@gandalf.local.home
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/preempt.h   |   18 +++++++++++++++++-
>  kernel/context_tracking.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 57 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/preempt.h b/include/linux/preempt.h
> index 87a03c7..f5d4723 100644
> --- a/include/linux/preempt.h
> +++ b/include/linux/preempt.h
> @@ -33,9 +33,25 @@ do { \
>  		preempt_schedule(); \
>  } while (0)
>  
> +#ifdef CONFIG_CONTEXT_TRACKING
> +
> +void preempt_schedule_context(void);
> +
> +#define preempt_check_resched_context() \
> +do { \
> +	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
> +		preempt_schedule_context(); \
> +} while (0)
> +#else
> +
> +#define preempt_check_resched_context() preempt_check_resched()
> +
> +#endif /* CONFIG_CONTEXT_TRACKING */
> +
>  #else /* !CONFIG_PREEMPT */
>  
>  #define preempt_check_resched()		do { } while (0)
> +#define preempt_check_resched_context()	do { } while (0)
>  
>  #endif /* CONFIG_PREEMPT */
>  
> @@ -88,7 +104,7 @@ do { \
>  do { \
>  	preempt_enable_no_resched_notrace(); \
>  	barrier(); \
> -	preempt_check_resched(); \
> +	preempt_check_resched_context(); \
>  } while (0)
>  
>  #else /* !CONFIG_PREEMPT_COUNT */
> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> index 65349f0..ac3a312 100644
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -71,6 +71,46 @@ void user_enter(void)
>  	local_irq_restore(flags);
>  }
>  
> +/**
> + * preempt_schedule_context - preempt_schedule called by tracing
> + *
> + * The tracing infrastructure uses preempt_enable_notrace to prevent
> + * recursion and tracing preempt enabling caused by the tracing
> + * infrastructure itself. But as tracing can happen in areas coming
> + * from userspace or just about to enter userspace, a preempt enable
> + * can occur before user_exit() is called. This will cause the scheduler
> + * to be called when the system is still in usermode.
> + *
> + * To prevent this, the preempt_enable_notrace will use this function
> + * instead of preempt_schedule() to exit user context if needed before
> + * calling the scheduler.
> + */
> +void __sched notrace preempt_schedule_context(void)
> +{
> +	struct thread_info *ti = current_thread_info();
> +	enum ctx_state prev_ctx;
> +
> +	if (likely(ti->preempt_count || irqs_disabled()))
> +		return;
> +
> +	/*
> +	 * Need to disable preemption in case user_exit() is traced
> +	 * and the tracer calls preempt_enable_notrace() causing
> +	 * an infinite recursion.
> +	 */
> +	preempt_disable_notrace();
> +	prev_ctx = this_cpu_read(context_tracking.state);
> +	user_exit();

You can reuse exception_enter()

> +	preempt_enable_no_resched_notrace();
> +
> +	preempt_schedule();
> +
> +	preempt_disable_notrace();
> +	if (prev_ctx == IN_USER)
> +		user_enter();

And then exception_exit() here.

I guess this replaces your fix with schedule_preempt_user(). I liked
it because it seems that:

   if (need_resched()) {
      user_exit();
      local_irq_enable();
      schedule();
      local_irq_enable();
      user_enter();
   }

is a common pattern of arch user resume preemption that we can consolidate.

But your new patch probably makes it more widely safe for the function tracer
for any function that can be called and traced in IN_USER mode. Not only user preemption.
Think about do_notify_resume() for example if it is called after syscall_trace_leave().

Independantly, schedule_preempt_user() is still interesting for consolidation.

Thanks.


> +	preempt_enable_notrace();
> +}
> +EXPORT_SYMBOL(preempt_schedule_context);
>  
>  /**
>   * user_exit - Inform the context tracking that the CPU is
> -- 
> 1.7.3.4
> 
> 
> 
