Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab3HaTtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 15:49:42 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44312 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3HaTtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 15:49:41 -0400
Date: Sat, 31 Aug 2013 12:49:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 10/18 v2] ftrace: Create a RCU unsafe checker
Message-ID: <20130831194928.GP3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051702.082937421@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051702.082937421@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083119-9332-0000-0000-000001448E85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:27AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Knowing what functions are not safe to be traced by callbacks that use
> RCU read locks, is not easy to figure out. By adding a function tracer
> callback that is set as a non RCU safe callback that also uses
> rcu_read_lock() and enables PROVE_RCU, it can be used to find locations
> in the kernel that need to be tagged with FTRACE_UNSAFE_RCU().
> 
> On boot up, this callback gets registered so that all functions are
> being traced, and there's no way to turn this off. In the future we
> can make this enabled or disabled at run time, but for now it's only
> used for debugging and should not be enabled by normal users.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/trace/Kconfig           |   22 +++++++++++++++++++
>  kernel/trace/ftrace.c          |   12 ++++++++++
>  kernel/trace/trace.h           |    3 +++
>  kernel/trace/trace_functions.c |   47 +++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 83 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 015f85a..907b497 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -489,6 +489,28 @@ config FTRACE_MCOUNT_RECORD
>  config FTRACE_SELFTEST
>  	bool
> 
> +config FTRACE_UNSAFE_RCU_CHECKER
> +        bool "Trace for unsafe RCU callers"
> +	depends on DYNAMIC_FTRACE
> +	depends on PROVE_LOCKING
> +	select PROVE_RCU
> +	help
> +	 Some function tracing callbacks use RCU read lock (namely perf).
> +	 There are some RCU critical functions that are called out
> +	 of scope for RCU. For example, when NO_HZ_FULL is enabled,
> +	 and coming out of user space. The CPU is not being tracked by
> +	 RCU and all rcu_read_lock()s will be ignored. These functions
> +	 need to be tagged as unsafe for RCU so that only function callbacks
> +	 that specify that they do not use RCU will be called by them.
> +
> +	 This option will enable PROVE_RCU and will enable on boot up
> +	 a function callback that traces all functions and uses an
> +	 rcu_read_lock(). If any function that is not tagged as unsafe
> +	 for RCU is called, a debug splat will be shown. This is used
> +	 for finding unsafe RCU callers that need to be tagged.
> +
> +	 If you don't understand any of this, then say N.
> +
>  config FTRACE_STARTUP_TEST
>  	bool "Perform a startup test on ftrace"
>  	depends on GENERIC_TRACER
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 33e4890..69b7f62 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1359,6 +1359,13 @@ alloc_and_copy_ftrace_hash(int size_bits, struct ftrace_hash *hash)
>  	return NULL;
>  }
> 
> +#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> +bool ftrace_rcu_unsafe(unsigned long addr)
> +{
> +	return ftrace_lookup_ip(ftrace_unsafe_rcu, addr) != NULL;
> +}
> +#endif
> +
>  static void
>  ftrace_hash_rec_disable(struct ftrace_ops *ops, int filter_hash);
>  static void
> @@ -4391,6 +4398,11 @@ static void __init create_unsafe_rcu_hash(void)
>  		if (WARN_ON_ONCE(strcmp(str, finder->name) != 0))
>  			continue;
> 
> +#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> +		/* When checker is enabled, show what was marked unsafe */
> +		pr_info("add ftrace rcu unsafe %p (%s)\n",
> +			(void *)ip, finder->name);
> +#endif
>  		add_hash_entry(ftrace_unsafe_rcu, ip);
>  	}
>  }
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 3578be6..e551316 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -760,6 +760,9 @@ static inline int ftrace_graph_addr(unsigned long addr)
> 
>  	return 0;
>  }
> +#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> +extern bool ftrace_rcu_unsafe(unsigned long addr);
> +#endif
>  #else
>  static inline int ftrace_graph_addr(unsigned long addr)
>  {
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index 38fe148..9dd4627 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -559,9 +559,54 @@ static inline int init_func_cmd_traceon(void)
>  }
>  #endif /* CONFIG_DYNAMIC_FTRACE */
> 
> +#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> +static void
> +ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
> +		       struct ftrace_ops *op, struct pt_regs *pt_regs)
> +{
> +	int bit;
> +
> +	preempt_disable_notrace();
> +
> +	bit = trace_test_and_set_recursion(TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> +	if (bit < 0)
> +		goto out;
> +
> +	if (WARN_ONCE(ftrace_rcu_unsafe(ip),
> +		      "UNSAFE RCU function called %pS",
> +		      (void *)ip))
> +		goto out;
> +
> +	/* Should trigger a RCU splat if called from unsafe RCU function */
> +	rcu_read_lock();
> +	rcu_read_unlock();
> +
> +	trace_clear_recursion(bit);
> + out:
> +	preempt_enable_notrace();
> +}
> +
> +static struct ftrace_ops ftrace_unsafe_ops = {
> +	.func			= ftrace_unsafe_callback,
> +	.flags			= FTRACE_OPS_FL_RECURSION_SAFE
> +};
> +
> +static __init void ftrace_start_unsafe_rcu(void)
> +{
> +	register_ftrace_function(&ftrace_unsafe_ops);
> +}
> +#else
> +static inline void ftrace_start_unsafe_rcu(void) { }
> +#endif
> +
>  static __init int init_function_trace(void)
>  {
> +	int ret;
> +
>  	init_func_cmd_traceon();
> -	return register_tracer(&function_trace);
> +	ret = register_tracer(&function_trace);
> +	if (!ret)
> +		ftrace_start_unsafe_rcu();
> +	return ret;
>  }
>  core_initcall(init_function_trace);
> -- 
> 1.7.10.4
> 
> 

