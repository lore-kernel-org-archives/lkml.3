Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbaLNSOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 13:14:51 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:49336 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaLNSOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 13:14:50 -0500
Date: Sun, 14 Dec 2014 10:14:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 2/3] tracing: Move enabling tracepoints to just after
 mm_init()
Message-ID: <20141214181444.GE5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141214164104.307127356@goodmis.org>
 <20141214164804.150181588@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141214164804.150181588@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121418-0005-0000-0000-000007235E63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 11:41:06AM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Enabling tracepoints at boot up can be very useful. The tracepoint
> can be initialized right after memory has been. There's no need to
> wait for the early_initcall() to be called. That's too late for some
> things that can use tracepoints for debugging. Move the logic to
> enable tracepoints out of the initcalls and into init/main.c to
> right after mm_init().
> 
> This also allows trace_printk() to be used early too.
> 
> Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1412121539300.16494@nanos
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace.h        |  6 ++++++
>  init/main.c                   |  3 +++
>  kernel/trace/trace.c          |  8 +++++++-
>  kernel/trace/trace.h          | 13 +++++++++++++
>  kernel/trace/trace_events.c   | 10 ++++++++--
>  kernel/trace/trace_syscalls.c |  7 ++-----
>  6 files changed, 39 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index ed501953f0b2..f4bc14b7d444 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -39,6 +39,12 @@
>  # define FTRACE_FORCE_LIST_FUNC 0
>  #endif
> 
> +/* Main tracing buffer and events set up */
> +#ifdef CONFIG_TRACING
> +void trace_init(void);
> +#else
> +static inline void trace_init(void) { }
> +#endif
> 
>  struct module;
>  struct ftrace_hash;
> diff --git a/init/main.c b/init/main.c
> index 800a0daede7e..060e60b6aa59 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -561,6 +561,9 @@ asmlinkage __visible void __init start_kernel(void)
>  	trap_init();
>  	mm_init();
> 
> +	/* trace_printk() and trace points may be used after this */
> +	trace_init();

Or if you aren't going to use call_rcu_sched() before this point, I could
move the call_rcu_sched()-relevant initialization to this point.  Or make
the compiler do it -- I am pretty sure that the per-CPU variables are in
place at this point.

							Thanx, Paul

> +
>  	/*
>  	 * Set up the scheduler prior starting any interrupts (such as the
>  	 * timer interrupt). Full topology setup happens at smp_init()
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 4ceb2546c7ef..ec3ca694665f 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -6876,6 +6876,13 @@ out:
>  	return ret;
>  }
> 
> +void __init trace_init(void)
> +{
> +	tracer_alloc_buffers();
> +	init_ftrace_syscalls();
> +	trace_event_init();	
> +}
> +
>  __init static int clear_boot_tracer(void)
>  {
>  	/*
> @@ -6895,6 +6902,5 @@ __init static int clear_boot_tracer(void)
>  	return 0;
>  }
> 
> -early_initcall(tracer_alloc_buffers);
>  fs_initcall(tracer_init_debugfs);
>  late_initcall(clear_boot_tracer);
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 3255dfb054a0..c138c149d6ef 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -1301,4 +1301,17 @@ int perf_ftrace_event_register(struct ftrace_event_call *call,
>  #define perf_ftrace_event_register NULL
>  #endif
> 
> +#ifdef CONFIG_FTRACE_SYSCALLS
> +void init_ftrace_syscalls(void);
> +#else
> +static inline void init_ftrace_syscalls(void) { }
> +#endif
> +
> +#ifdef CONFIG_EVENT_TRACING
> +void trace_event_init(void);
> +#else
> +static inline void __init trace_event_init(void) { }
> +#endif
> +
> +
>  #endif /* _LINUX_KERNEL_TRACE_H */
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index f9d0cbe014b7..fd9deb0e03f0 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -2477,8 +2477,14 @@ static __init int event_trace_init(void)
>  #endif
>  	return 0;
>  }
> -early_initcall(event_trace_memsetup);
> -core_initcall(event_trace_enable);
> +
> +void __init trace_event_init(void)
> +{
> +	event_trace_memsetup();
> +	init_ftrace_syscalls();
> +	event_trace_enable();
> +}
> +
>  fs_initcall(event_trace_init);
> 
>  #ifdef CONFIG_FTRACE_STARTUP_TEST
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index a72f3d8d813e..ec239771c175 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -514,7 +514,7 @@ unsigned long __init __weak arch_syscall_addr(int nr)
>  	return (unsigned long)sys_call_table[nr];
>  }
> 
> -static int __init init_ftrace_syscalls(void)
> +void __init init_ftrace_syscalls(void)
>  {
>  	struct syscall_metadata *meta;
>  	unsigned long addr;
> @@ -524,7 +524,7 @@ static int __init init_ftrace_syscalls(void)
>  				    GFP_KERNEL);
>  	if (!syscalls_metadata) {
>  		WARN_ON(1);
> -		return -ENOMEM;
> +		return;
>  	}
> 
>  	for (i = 0; i < NR_syscalls; i++) {
> @@ -536,10 +536,7 @@ static int __init init_ftrace_syscalls(void)
>  		meta->syscall_nr = i;
>  		syscalls_metadata[i] = meta;
>  	}
> -
> -	return 0;
>  }
> -early_initcall(init_ftrace_syscalls);
> 
>  #ifdef CONFIG_PERF_EVENTS
> 
> -- 
> 2.1.3
> 
> 

