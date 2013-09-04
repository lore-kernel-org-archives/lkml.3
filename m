Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088Ab3IDBYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:24:12 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46561 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab3IDBYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:24:10 -0400
Date: Tue, 3 Sep 2013 18:24:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 01/18 v2] ftrace: Add hash list to save RCU unsafe
 functions
Message-ID: <20130904012404.GI3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051700.601365837@goodmis.org>
 <20130903171516.16290c47@gandalf.local.home>
 <20130903221808.GH3871@linux.vnet.ibm.com>
 <20130903195705.3ba3442f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903195705.3ba3442f@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090401-9332-0000-0000-0000014B2313
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 07:57:05PM -0400, Steven Rostedt wrote:
> On Tue, 3 Sep 2013 15:18:08 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> 
> > > Just found this bug. Strange that gcc never gave me a warning :-/
> > 
> > I can't give gcc too much trouble, as I also didn't give you an
> > uninitialized-variable warning.
> 
> I was also chasing down a nasty bug that looked to be a pointer
> corruption somewhere. Still never found exactly where it happened, but
> it always happened with the following conditions:
> 
> synchronize_sched() was in progress
> 
> The ftrace_unsafe_callback() was preempted by an interrupt
> 
> lockdep was processing a lock
> 
> 
> A crash would happen which had memory corruption involved. But the
> above seemed always to be in play.
> 
> Now, I changed the logic from disabling context level recursion to
> disabling recursion at all. That is, the original code had used a
> series of bits to test for recursion (via helper functions) that would
> allow for the callback to be preempted by an interrupt, and then be
> called again.
> 
> The new code sets a per_cpu flag, and will not allow the callback to
> recurse if it were preempted by an interrupt. No real need to allow for
> that anyway.
> 
> I can go and debug this further, because I'm nervous that lockdep may
> have some kind of bug that the function tracer can trigger. But I'm not
> too concerned about it.
> 
> Here's the diff of the new code against the previous code.
> 
> Paul, can I still keep all your acks and reviewed-bys on this?

Yep, but some questions below.

							Thanx, Paul

> -- Steve
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 310b727..899c8c1 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1373,7 +1373,7 @@ ftrace_hash_rec_enable(struct ftrace_ops *ops, int filter_hash);
> 
>  static int ftrace_convert_size_to_bits(int size)
>  {
> -	int bits;
> +	int bits = 0;
> 
>  	/*
>  	 * Make the hash size about 1/2 the # found
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index f5a9031..0883069 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -561,16 +561,21 @@ static inline int init_func_cmd_traceon(void)
> 
>  #ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> 
> +static DEFINE_PER_CPU(int, ftrace_rcu_running);
>  static atomic_t ftrace_unsafe_rcu_disabled;
> 
>  void ftrace_unsafe_rcu_checker_disable(void)
>  {
>  	atomic_inc(&ftrace_unsafe_rcu_disabled);
> +	/* Make sure the update is seen immediately */
> +	smp_wmb();

	smp_mb__after_atomic_inc()?

>  }
> 
>  void ftrace_unsafe_rcu_checker_enable(void)
>  {
>  	atomic_dec(&ftrace_unsafe_rcu_disabled);
> +	/* Make sure the update is seen immediately */
> +	smp_wmb();

	smp_mb__after_atomic_dec()?

>  }
> 
>  static DEFINE_PER_CPU(unsigned long, ftrace_rcu_func);
> @@ -588,15 +593,14 @@ static void
>  ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
>  		       struct ftrace_ops *op, struct pt_regs *pt_regs)
>  {
> -	int bit;
> -
> +	/* Make sure we see disabled or not first */
> +	smp_rmb();

	smp_mb__before_atomic_inc()?

>  	if (atomic_read(&ftrace_unsafe_rcu_disabled))
>  		return;
> 
>  	preempt_disable_notrace();
> 
> -	bit = trace_test_and_set_recursion(TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> -	if (bit < 0)
> +	if (this_cpu_read(ftrace_rcu_running))
>  		goto out;
> 
>  	if (WARN_ONCE(ftrace_rcu_unsafe(ip),
> @@ -604,13 +608,15 @@ ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
>  		      (void *)ip))
>  		goto out;
> 
> +	this_cpu_write(ftrace_rcu_running, 1);
>  	this_cpu_write(ftrace_rcu_func, ip);
> +
>  	/* Should trigger a RCU splat if called from unsafe RCU function */
>  	rcu_read_lock();
>  	rcu_read_unlock();
>  	this_cpu_write(ftrace_rcu_func, 0);
> 
> -	trace_clear_recursion(bit);
> +	this_cpu_write(ftrace_rcu_running, 0);
>   out:
>  	preempt_enable_notrace();
>  }
> 

