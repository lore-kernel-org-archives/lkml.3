Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab3ICNnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:43:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22657 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab3ICNny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:43:54 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=ZnFBpunljT8A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QYmdpx3kvKkA:10 a=VnNF1IyMAAAA:8 a=7uF5H17JL8JyZPnN_-gA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 3 Sep 2013 09:43:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 11/18 v2] ftrace: Adde infrastructure to stop RCU
 unsafe checker from checking
Message-ID: <20130903094352.3da850eb@gandalf.local.home>
In-Reply-To: <20130831195258.GQ3871@linux.vnet.ibm.com>
References: <20130831051117.884125230@goodmis.org>
	<20130831051702.253028770@goodmis.org>
	<20130831195258.GQ3871@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Aug 2013 12:52:58 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Sat, Aug 31, 2013 at 01:11:28AM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > This is a light weight way to keep the rcu checker from checking
> > RCU safety. It adds a ftrace_unsafe_rcu_checker_disable/enable()
> > that increments or decrements a counter respectively. When the
> > counter is set, the RCU unsafe checker callback does not run the
> > tests to see if RCU is safe or not.
> 
> Please add something saying what we do instead of testing RCU safety.
> Looks to me like it skips not only the tests, but also invoking the
> callback, but I could easily be wrong.

Now that I'm awake and also not on holiday, I can reply with a clear
mind.

When disabled, it forces the callback to return immediately. I may in
the future, have it disable the callback altogether.

Yes, we can miss checks, but it's better than the test live locking
the system :-)

> 
> > This is required by the graph tracer because the checks can cause
> > the graph tracer to live lock the system by its own calls.

I added this (I quoted the added text):

    This is a light weight way to keep the rcu checker from checking
    RCU safety. It adds a ftrace_unsafe_rcu_checker_disable/enable()
    that increments or decrements a counter respectively. When the
    counter is set, the RCU unsafe checker callback does not run the
    tests to see if RCU is safe or not. "But the callback still gets
    called. It just does not call rcu_read_(un)lock()."
    
    This is required by the graph tracer because the checks can cause
    the graph tracer to live lock the system by its own calls. "That is,
    the graph tracer will still trace rcu and the rcu debugging, and
    this will slow down the checker, which is still calling all other
    functions (in interrupts and faults), which can cause the timer
    interrupt to take oven a millisecond to complete, and it will then
    trigger once it finishes, live locking the system."


> > 
> > It's also needed by the irqsoff tracer, because it may be called
> > in RCU unsafe regions and if its internal functions get traced
> > then the RCU unsafe checker may have some false positives.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> With the augmented commit log as noted above:

Is the above OK?

-- Steve

> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> > ---
> >  kernel/trace/trace.h           |   12 +++++++++---
> >  kernel/trace/trace_functions.c |   15 +++++++++++++++
> >  2 files changed, 24 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index e551316..58e4c37 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -760,9 +760,6 @@ static inline int ftrace_graph_addr(unsigned long addr)
> > 
> >  	return 0;
> >  }
> > -#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> > -extern bool ftrace_rcu_unsafe(unsigned long addr);
> > -#endif
> >  #else
> >  static inline int ftrace_graph_addr(unsigned long addr)
> >  {
> > @@ -1061,4 +1058,13 @@ int perf_ftrace_event_register(struct ftrace_event_call *call,
> >  #define perf_ftrace_event_register NULL
> >  #endif
> > 
> > +#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> > +extern bool ftrace_rcu_unsafe(unsigned long addr);
> > +extern void ftrace_unsafe_rcu_checker_disable(void);
> > +extern void ftrace_unsafe_rcu_checker_enable(void);
> > +#else
> > +static inline void ftrace_unsafe_rcu_checker_disable(void) { }
> > +static inline void ftrace_unsafe_rcu_checker_enable(void) { }
> > +#endif
> > +
> >  #endif /* _LINUX_KERNEL_TRACE_H */
> > diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> > index 9dd4627..1d5f951 100644
> > --- a/kernel/trace/trace_functions.c
> > +++ b/kernel/trace/trace_functions.c
> > @@ -560,12 +560,27 @@ static inline int init_func_cmd_traceon(void)
> >  #endif /* CONFIG_DYNAMIC_FTRACE */
> > 
> >  #ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
> > +static atomic_t ftrace_unsafe_rcu_disabled;
> > +
> > +void ftrace_unsafe_rcu_checker_disable(void)
> > +{
> > +	atomic_inc(&ftrace_unsafe_rcu_disabled);
> > +}
> > +
> > +void ftrace_unsafe_rcu_checker_enable(void)
> > +{
> > +	atomic_dec(&ftrace_unsafe_rcu_disabled);
> > +}
> > +
> >  static void
> >  ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
> >  		       struct ftrace_ops *op, struct pt_regs *pt_regs)
> >  {
> >  	int bit;
> > 
> > +	if (atomic_read(&ftrace_unsafe_rcu_disabled))
> > +		return;
> > +
> >  	preempt_disable_notrace();
> > 
> >  	bit = trace_test_and_set_recursion(TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> > -- 
> > 1.7.10.4
> > 
> > 

