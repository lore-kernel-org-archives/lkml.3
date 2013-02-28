Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab3B1QkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:40:20 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57713 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab3B1QkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:40:18 -0500
Date: Thu, 28 Feb 2013 08:38:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] context_tracking/rcu: don't function trace before
 rcu_user_exit() finishes
Message-ID: <20130228163847.GA3566@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1362039970.18895.28.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362039970.18895.28.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022816-5806-0000-0000-00002024DE43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 04:26:10PM +0800, Li Zhong wrote:
> I saw some RCU illegal usage from idle complaints when function tracer
> is enabled with forced context tracking.
> 
> It seems that __schedule() might be called in function_trace_call() when
> it re-enables preemption(if preemption and irqs are both enabled). 
> 
> So at the places where we call rcu_user_exit(), we need make sure that
> no function tracer hooks could be called in preemption/irqs both enabled
> environment before rcu_user_exit() finishes, or we might cause illegal
> RCU usage in __schedule(). 
> 
> This patch tries to add notrace attribute to a couple of functions where
> the above could happen, including user_exit(), and a few callers of
> user_exit(). 

And I have to ask...

Do we really need the rcu_user_notrace?  Why not just label the functions
as notrace?

							Thanx, Paul

> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> --
>  arch/x86/kernel/ptrace.c  | 4 ++--
>  arch/x86/kernel/signal.c  | 2 +-
>  include/linux/rcupdate.h  | 2 ++
>  kernel/context_tracking.c | 2 +-
>  kernel/sched/core.c       | 2 +-
>  5 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index 29a8120..04659c2 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -1488,7 +1488,7 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
>   * We must return the syscall number to actually look up in the table.
>   * This can be -1L to skip running any syscall at all.
>   */
> -long syscall_trace_enter(struct pt_regs *regs)
> +long rcu_user_notrace syscall_trace_enter(struct pt_regs *regs)
>  {
>  	long ret = 0;
> 
> @@ -1538,7 +1538,7 @@ out:
>  	return ret ?: regs->orig_ax;
>  }
> 
> -void syscall_trace_leave(struct pt_regs *regs)
> +void rcu_user_notrace syscall_trace_leave(struct pt_regs *regs)
>  {
>  	bool step;
> 
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index 6956299..10a9e5a 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -732,7 +732,7 @@ static void do_signal(struct pt_regs *regs)
>   * notification of userspace execution resumption
>   * - triggered by the TIF_WORK_MASK flags
>   */
> -void
> +void rcu_user_notrace
>  do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
>  {
>  	user_exit();
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index b758ce1..ecf9872 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -229,6 +229,7 @@ extern void rcu_user_enter(void);
>  extern void rcu_user_exit(void);
>  extern void rcu_user_enter_after_irq(void);
>  extern void rcu_user_exit_after_irq(void);
> +#define rcu_user_notrace notrace
>  #else
>  static inline void rcu_user_enter(void) { }
>  static inline void rcu_user_exit(void) { }
> @@ -236,6 +237,7 @@ static inline void rcu_user_enter_after_irq(void) { }
>  static inline void rcu_user_exit_after_irq(void) { }
>  static inline void rcu_user_hooks_switch(struct task_struct *prev,
>  					 struct task_struct *next) { }
> +#define rcu_user_notrace
>  #endif /* CONFIG_RCU_USER_QS */
> 
>  extern void exit_rcu(void);
> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> index 65349f0..d3fc35f 100644
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -83,7 +83,7 @@ void user_enter(void)
>   * This call supports re-entrancy. This way it can be called from any exception
>   * handler without needing to know if we came from userspace or not.
>   */
> -void user_exit(void)
> +void rcu_user_notrace user_exit(void)
>  {
>  	unsigned long flags;
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 2b52431..c970e92 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2973,7 +2973,7 @@ asmlinkage void __sched schedule(void)
>  EXPORT_SYMBOL(schedule);
> 
>  #ifdef CONFIG_CONTEXT_TRACKING
> -asmlinkage void __sched schedule_user(void)
> +asmlinkage void __sched rcu_user_notrace schedule_user(void)
>  {
>  	/*
>  	 * If we come here after a random call to set_need_resched(),
> 
> 

