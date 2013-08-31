Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab3HaT7z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 15:59:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50521 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab3HaT7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 15:59:54 -0400
Date: Sat, 31 Aug 2013 12:59:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 14/18 v2] ftrace/lockdep: Have the RCU lockdep splat
 show what function triggered
Message-ID: <20130831195941.GT3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051702.766697014@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051702.766697014@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083119-1542-0000-0000-000001071642
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:31AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> When the RCU lockdep splat hits because of the unsafe RCU checker,
> the backtrace does not always show the culprit. But the culprit was
> passed to the unsafe RCU checker.
> 
> Save the ip of the function being traced in a per_cpu variable, and
> when the RCU lockdep detects a problem, it can also print out what
> function was being traced if it was caused by the unsafe RCU checker.
> 
> Cc:  Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/linux/ftrace.h         |    6 ++++++
>  kernel/lockdep.c               |    2 ++
>  kernel/trace/trace_functions.c |   14 ++++++++++++++
>  3 files changed, 22 insertions(+)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 4752764..3dbb946 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -885,4 +885,10 @@ unsigned long arch_syscall_addr(int nr);
> 
>  #endif /* CONFIG_FTRACE_SYSCALLS */
> 
> +#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> +extern void print_ftrace_rcu_func(int cpu);
> +#else
> +static inline void print_ftrace_rcu_func(int cpu) { }
> +#endif
> +
>  #endif /* _LINUX_FTRACE_H */
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index e16c45b..74272ed 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -4229,6 +4229,8 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
>  				: "",
>  	       rcu_scheduler_active, debug_locks);
> 
> +	print_ftrace_rcu_func(raw_smp_processor_id());
> +
>  	/*
>  	 * If a CPU is in the RCU-free window in idle (ie: in the section
>  	 * between rcu_idle_enter() and rcu_idle_exit(), then RCU
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index 1d5f951..f5a9031 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -560,6 +560,7 @@ static inline int init_func_cmd_traceon(void)
>  #endif /* CONFIG_DYNAMIC_FTRACE */
> 
>  #ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> +
>  static atomic_t ftrace_unsafe_rcu_disabled;
> 
>  void ftrace_unsafe_rcu_checker_disable(void)
> @@ -572,6 +573,17 @@ void ftrace_unsafe_rcu_checker_enable(void)
>  	atomic_dec(&ftrace_unsafe_rcu_disabled);
>  }
> 
> +static DEFINE_PER_CPU(unsigned long, ftrace_rcu_func);
> +
> +void print_ftrace_rcu_func(int cpu)
> +{
> +	unsigned long ip = per_cpu(ftrace_rcu_func, cpu);
> +
> +	if (ip)
> +		printk("ftrace_rcu_func: %pS\n",
> +		       (void *)per_cpu(ftrace_rcu_func, cpu));
> +}
> +
>  static void
>  ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
>  		       struct ftrace_ops *op, struct pt_regs *pt_regs)
> @@ -592,9 +604,11 @@ ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
>  		      (void *)ip))
>  		goto out;
> 
> +	this_cpu_write(ftrace_rcu_func, ip);
>  	/* Should trigger a RCU splat if called from unsafe RCU function */
>  	rcu_read_lock();
>  	rcu_read_unlock();
> +	this_cpu_write(ftrace_rcu_func, 0);
> 
>  	trace_clear_recursion(bit);
>   out:
> -- 
> 1.7.10.4
> 
> 

