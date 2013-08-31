Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3HaTrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 15:47:37 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44896 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab3HaTrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 15:47:36 -0400
Date: Sat, 31 Aug 2013 12:47:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 07/18 v2] ftrace: Add selftest to check if RCU
 unsafe functions are filtered properly
Message-ID: <20130831194723.GO3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051701.613445493@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051701.613445493@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083119-9332-0000-0000-000001448E2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:24AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Add a boot time start up test that has a RCU safe ftrace_ops as well
> as an unsafe one. Make sure the RCU safe ops can trace RCU unsafe
> functions while the unsafe ftrace_ops can not.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace.h                  |    2 +
>  kernel/trace/trace_selftest.c         |   94 +++++++++++++++++++++++++++++++++
>  kernel/trace/trace_selftest_dynamic.c |    7 +++
>  3 files changed, 103 insertions(+)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 502fed7..3578be6 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -648,6 +648,8 @@ extern unsigned long ftrace_update_tot_cnt;
>  extern int DYN_FTRACE_TEST_NAME(void);
>  #define DYN_FTRACE_TEST_NAME2 trace_selftest_dynamic_test_func2
>  extern int DYN_FTRACE_TEST_NAME2(void);
> +#define DYN_FTRACE_TEST_RCU_UNSAFE trace_selftest_dynamic_test_rcu_unsafe
> +extern int DYN_FTRACE_TEST_RCU_UNSAFE(void);
> 
>  extern bool ring_buffer_expanded;
>  extern bool tracing_selftest_disabled;
> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index a7329b7..eeacb47 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -185,6 +185,97 @@ static void reset_counts(void)
>  	trace_selftest_test_dyn_cnt = 0;
>  }
> 
> +static struct ftrace_ops ftrace_rcu_safe_ops = {
> +	.func		= trace_selftest_test_probe1_func,
> +	.flags		= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_RCU_SAFE,
> +};
> +
> +static struct ftrace_ops ftrace_rcu_unsafe_ops = {
> +	.func		= trace_selftest_test_probe2_func,
> +	.flags		= FTRACE_OPS_FL_RECURSION_SAFE,
> +};
> +
> +static int test_rcu_safe_unsafe(void)
> +{
> +	int save_ftrace_enabled = ftrace_enabled;
> +	char *func_name;
> +	int len;
> +	int ret = 0;
> +
> +	printk(KERN_CONT "PASSED\n");
> +	pr_info("Testing ftrace rcu safe unsafe: ");
> +
> +	ftrace_enabled = 1;
> +
> +	trace_selftest_test_probe1_cnt = 0;
> +	trace_selftest_test_probe2_cnt = 0;
> +
> +	func_name = "*" __stringify(DYN_FTRACE_TEST_RCU_UNSAFE);
> +	len = strlen(func_name);
> +
> +	ftrace_set_filter(&ftrace_rcu_safe_ops, func_name, len, 1);
> +	ftrace_set_filter(&ftrace_rcu_unsafe_ops, func_name, len, 1);
> +
> +	/* Do single registrations first */
> +	register_ftrace_function(&ftrace_rcu_safe_ops);
> +
> +	DYN_FTRACE_TEST_RCU_UNSAFE();
> +
> +	unregister_ftrace_function(&ftrace_rcu_safe_ops);
> +
> +	if (trace_selftest_test_probe1_cnt != 1) {
> +		printk(KERN_CONT "rcu_safe expected 1 call but had %d ",
> +		       trace_selftest_test_probe1_cnt);
> +		goto out;
> +	}
> +
> +	register_ftrace_function(&ftrace_rcu_unsafe_ops);
> +
> +	DYN_FTRACE_TEST_RCU_UNSAFE();
> +
> +	unregister_ftrace_function(&ftrace_rcu_unsafe_ops);
> +
> +	if (trace_selftest_test_probe2_cnt != 0) {
> +		printk(KERN_CONT "rcu_safe expected 0 calls but had %d ",
> +		       trace_selftest_test_probe2_cnt);
> +		goto out;
> +	}
> +
> +	/* Run both together, which uses the list op */
> +
> +	trace_selftest_test_probe1_cnt = 0;
> +	trace_selftest_test_probe2_cnt = 0;
> +
> +	register_ftrace_function(&ftrace_rcu_safe_ops);
> +	register_ftrace_function(&ftrace_rcu_unsafe_ops);
> +
> +	DYN_FTRACE_TEST_RCU_UNSAFE();
> +	DYN_FTRACE_TEST_RCU_UNSAFE();
> +	DYN_FTRACE_TEST_RCU_UNSAFE();
> +
> +	unregister_ftrace_function(&ftrace_rcu_unsafe_ops);
> +	unregister_ftrace_function(&ftrace_rcu_safe_ops);
> +
> +
> +	if (trace_selftest_test_probe1_cnt != 3) {
> +		printk(KERN_CONT "rcu_safe expected 3 calls but had %d ",
> +		       trace_selftest_test_probe1_cnt);
> +		goto out;
> +	}
> +
> +	if (trace_selftest_test_probe2_cnt != 0) {
> +		printk(KERN_CONT "rcu_safe expected 0 calls but had %d ",
> +		       trace_selftest_test_probe2_cnt);
> +		goto out;
> +	}
> +
> +	ret = 0;
> + out:
> +	ftrace_enabled = save_ftrace_enabled;
> +
> +	return ret;
> +}
> +
>  static int trace_selftest_ops(int cnt)
>  {
>  	int save_ftrace_enabled = ftrace_enabled;
> @@ -401,6 +492,9 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
>  	if (!ret)
>  		ret = trace_selftest_ops(2);
> 
> +	if (!ret)
> +		ret = test_rcu_safe_unsafe();
> +
>  	return ret;
>  }
> 
> diff --git a/kernel/trace/trace_selftest_dynamic.c b/kernel/trace/trace_selftest_dynamic.c
> index b4c475a..5eefa56 100644
> --- a/kernel/trace/trace_selftest_dynamic.c
> +++ b/kernel/trace/trace_selftest_dynamic.c
> @@ -11,3 +11,10 @@ int DYN_FTRACE_TEST_NAME2(void)
>  	/* used to call mcount */
>  	return 0;
>  }
> +
> +int trace_selftest_dynamic_test_rcu_unsafe(void)
> +{
> +	/* used to call mcount */
> +	return 0;
> +}
> +FTRACE_UNSAFE_RCU(trace_selftest_dynamic_test_rcu_unsafe);
> -- 
> 1.7.10.4
> 
> 

