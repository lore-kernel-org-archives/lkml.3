Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3HaTxM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 15:53:12 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60887 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3HaTxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 15:53:11 -0400
Date: Sat, 31 Aug 2013 12:52:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 11/18 v2] ftrace: Adde infrastructure to stop RCU
 unsafe checker from checking
Message-ID: <20130831195258.GQ3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051702.253028770@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051702.253028770@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083119-0928-0000-0000-00000128DC4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:28AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> This is a light weight way to keep the rcu checker from checking
> RCU safety. It adds a ftrace_unsafe_rcu_checker_disable/enable()
> that increments or decrements a counter respectively. When the
> counter is set, the RCU unsafe checker callback does not run the
> tests to see if RCU is safe or not.

Please add something saying what we do instead of testing RCU safety.
Looks to me like it skips not only the tests, but also invoking the
callback, but I could easily be wrong.

> This is required by the graph tracer because the checks can cause
> the graph tracer to live lock the system by its own calls.
> 
> It's also needed by the irqsoff tracer, because it may be called
> in RCU unsafe regions and if its internal functions get traced
> then the RCU unsafe checker may have some false positives.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

With the augmented commit log as noted above:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace.h           |   12 +++++++++---
>  kernel/trace/trace_functions.c |   15 +++++++++++++++
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index e551316..58e4c37 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -760,9 +760,6 @@ static inline int ftrace_graph_addr(unsigned long addr)
> 
>  	return 0;
>  }
> -#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> -extern bool ftrace_rcu_unsafe(unsigned long addr);
> -#endif
>  #else
>  static inline int ftrace_graph_addr(unsigned long addr)
>  {
> @@ -1061,4 +1058,13 @@ int perf_ftrace_event_register(struct ftrace_event_call *call,
>  #define perf_ftrace_event_register NULL
>  #endif
> 
> +#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> +extern bool ftrace_rcu_unsafe(unsigned long addr);
> +extern void ftrace_unsafe_rcu_checker_disable(void);
> +extern void ftrace_unsafe_rcu_checker_enable(void);
> +#else
> +static inline void ftrace_unsafe_rcu_checker_disable(void) { }
> +static inline void ftrace_unsafe_rcu_checker_enable(void) { }
> +#endif
> +
>  #endif /* _LINUX_KERNEL_TRACE_H */
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index 9dd4627..1d5f951 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -560,12 +560,27 @@ static inline int init_func_cmd_traceon(void)
>  #endif /* CONFIG_DYNAMIC_FTRACE */
> 
>  #ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> +static atomic_t ftrace_unsafe_rcu_disabled;
> +
> +void ftrace_unsafe_rcu_checker_disable(void)
> +{
> +	atomic_inc(&ftrace_unsafe_rcu_disabled);
> +}
> +
> +void ftrace_unsafe_rcu_checker_enable(void)
> +{
> +	atomic_dec(&ftrace_unsafe_rcu_disabled);
> +}
> +
>  static void
>  ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
>  		       struct ftrace_ops *op, struct pt_regs *pt_regs)
>  {
>  	int bit;
> 
> +	if (atomic_read(&ftrace_unsafe_rcu_disabled))
> +		return;
> +
>  	preempt_disable_notrace();
> 
>  	bit = trace_test_and_set_recursion(TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> -- 
> 1.7.10.4
> 
> 

