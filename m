Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761686Ab3IDBvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:51:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761538Ab3IDBvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:51:54 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=6vL9NhcTi7YA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Lu4-lkDicUYA:10 a=VnNF1IyMAAAA:8 a=-ErlrlILWjhT9ab7BowA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 3 Sep 2013 21:51:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 01/18 v2] ftrace: Add hash list to save RCU unsafe
 functions
Message-ID: <20130903215152.1e91922b@gandalf.local.home>
In-Reply-To: <20130904012404.GI3871@linux.vnet.ibm.com>
References: <20130831051117.884125230@goodmis.org>
	<20130831051700.601365837@goodmis.org>
	<20130903171516.16290c47@gandalf.local.home>
	<20130903221808.GH3871@linux.vnet.ibm.com>
	<20130903195705.3ba3442f@gandalf.local.home>
	<20130904012404.GI3871@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013 18:24:04 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, Sep 03, 2013 at 07:57:05PM -0400, Steven Rostedt wrote:

> > Paul, can I still keep all your acks and reviewed-bys on this?
> 
> Yep, but some questions below.
> 
> 							Thanx, Paul
> 
> > -- Steve
> > 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 310b727..899c8c1 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -1373,7 +1373,7 @@ ftrace_hash_rec_enable(struct ftrace_ops *ops, int filter_hash);
> > 
> >  static int ftrace_convert_size_to_bits(int size)
> >  {
> > -	int bits;
> > +	int bits = 0;
> > 
> >  	/*
> >  	 * Make the hash size about 1/2 the # found
> > diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> > index f5a9031..0883069 100644
> > --- a/kernel/trace/trace_functions.c
> > +++ b/kernel/trace/trace_functions.c
> > @@ -561,16 +561,21 @@ static inline int init_func_cmd_traceon(void)
> > 
> >  #ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> > 
> > +static DEFINE_PER_CPU(int, ftrace_rcu_running);
> >  static atomic_t ftrace_unsafe_rcu_disabled;
> > 
> >  void ftrace_unsafe_rcu_checker_disable(void)
> >  {
> >  	atomic_inc(&ftrace_unsafe_rcu_disabled);
> > +	/* Make sure the update is seen immediately */
> > +	smp_wmb();
> 
> 	smp_mb__after_atomic_inc()?

Yep.

> 
> >  }
> > 
> >  void ftrace_unsafe_rcu_checker_enable(void)
> >  {
> >  	atomic_dec(&ftrace_unsafe_rcu_disabled);
> > +	/* Make sure the update is seen immediately */
> > +	smp_wmb();
> 
> 	smp_mb__after_atomic_dec()?

Yep.

> 
> >  }
> > 
> >  static DEFINE_PER_CPU(unsigned long, ftrace_rcu_func);
> > @@ -588,15 +593,14 @@ static void
> >  ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
> >  		       struct ftrace_ops *op, struct pt_regs *pt_regs)
> >  {
> > -	int bit;
> > -
> > +	/* Make sure we see disabled or not first */
> > +	smp_rmb();
> 
> 	smp_mb__before_atomic_inc()?

Yep.

I'll update it and restart my tests.

Thanks!

-- Steve

> 
> >  	if (atomic_read(&ftrace_unsafe_rcu_disabled))
> >  		return;
> > 
> >  	preempt_disable_notrace();
> > 
> > -	bit = trace_test_and_set_recursion(TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> > -	if (bit < 0)
> > +	if (this_cpu_read(ftrace_rcu_running))
> >  		goto out;
> > 
> >  	if (WARN_ONCE(ftrace_rcu_unsafe(ip),
> > @@ -604,13 +608,15 @@ ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
> >  		      (void *)ip))
> >  		goto out;
> > 
> > +	this_cpu_write(ftrace_rcu_running, 1);
> >  	this_cpu_write(ftrace_rcu_func, ip);
> > +
> >  	/* Should trigger a RCU splat if called from unsafe RCU function */
> >  	rcu_read_lock();
> >  	rcu_read_unlock();
> >  	this_cpu_write(ftrace_rcu_func, 0);
> > 
> > -	trace_clear_recursion(bit);
> > +	this_cpu_write(ftrace_rcu_running, 0);
> >   out:
> >  	preempt_enable_notrace();
> >  }
> > 

