Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935152Ab3E2Nd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:33:28 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56151 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935126Ab3E2Nd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:33:27 -0400
Date: Wed, 29 May 2013 06:33:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH] ftrace: Use schedule_on_each_cpu() as a heavy
 synchronize_sched()
Message-ID: <20130529133315.GC6172@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1369785676.15552.55.camel@gandalf.local.home>
 <20130529075249.GC12193@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529075249.GC12193@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052913-3620-0000-0000-000002C30B8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 09:52:49AM +0200, Peter Zijlstra wrote:
> On Tue, May 28, 2013 at 08:01:16PM -0400, Steven Rostedt wrote:
> > The function tracer uses preempt_disable/enable_notrace() for
> > synchronization between reading registered ftrace_ops and unregistering
> > them.
> > 
> > Most of the ftrace_ops are global permanent structures that do not
> > require this synchronization. That is, ops may be added and removed from
> > the hlist but are never freed, and wont hurt if a synchronization is
> > missed.
> > 
> > But this is not true for dynamically created ftrace_ops or control_ops,
> > which are used by the perf function tracing.
> > 
> > The problem here is that the function tracer can be used to trace
> > kernel/user context switches as well as going to and from idle.
> > Basically, it can be used to trace blind spots of the RCU subsystem.
> > This means that even though preempt_disable() is done, a
> > synchronize_sched() will ignore CPUs that haven't made it out of user
> > space or idle. These can include functions that are being traced just
> > before entering or exiting the kernel sections.
> 
> Just to be clear, its the idle part that's a problem, right? Being stuck
> in userspace isn't a problem since if that CPU is in userspace its
> certainly not got a reference to whatever list entry we're removing.

You got it!  The problem is the exact definition of "idle".  The way that
it works now is that the idle loop tells RCU when idle starts and ends
by invoking rcu_idle_enter() and rcu_idle_exit(), respectively.  Right
now, these calls are in the top-level idle loop.  They could in principle
be moved down further, but last time I tried it, it got pretty ugly.

> Now when the CPU really is idle, its obviously not using tracing either;
> so only the gray area where RCU thinks we're idle but we're not actually
> idle is a problem?

Exactly.  And there always will be a grey area, just like the grey area
between being in an interrupt handler and in_irq() knowing about it.

> Is there something a little smarter we can do? Could we use
> on_each_cpu_cond() with a function that checks if the CPU really is
> fully idle?

One recent change that should help is making the _rcuidle variants of
the tracing functions callable from both idle and irq.  To make the
on_each_cpu_cond() approach work, event tracing would need to switch
from RCU (which might be preemptible RCU) to RCU-sched (whose read-side
critical sections can pair with on_each_cpu().  I have to defer to Steven
on whether this is a good approach.

> > To implement the RCU synchronization, instead of using
> > synchronize_sched() the use of schedule_on_each_cpu() is performed. This
> > means that when a dynamically allocated ftrace_ops, or a control ops is
> > being unregistered, all CPUs must be touched and execute a ftrace_sync()
> > stub function via the work queues. This will rip CPUs out from idle or
> > in dynamic tick mode. This only happens when a user disables perf
> > function tracing or other dynamically allocated function tracers, but it
> > allows us to continue to debug RCU and context tracking with function
> > tracing.
> 
> I don't suppose there's anything perf can do to about this right? Since
> its all on user demand we're kinda stuck with dynamic memory.

I believe that Steven's earlier patch using on_each_cpu() solves this
problem.

							Thanx, Paul

