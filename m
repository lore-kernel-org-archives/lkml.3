Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbaFSB4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:56:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:25080 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752726AbaFSB4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:56:30 -0400
Date: Wed, 18 Jun 2014 21:56:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH] ftrace: Use schedule_on_each_cpu() as a heavy
 synchronize_sched()
Message-ID: <20140618215626.3b109d31@gandalf.local.home>
In-Reply-To: <20130529075249.GC12193@twins.programming.kicks-ass.net>
References: <1369785676.15552.55.camel@gandalf.local.home>
	<20130529075249.GC12193@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another blast from the past (from the book of cleaning out inbox)

On Wed, 29 May 2013 09:52:49 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

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
> 
> Now when the CPU really is idle, its obviously not using tracing either;
> so only the gray area where RCU thinks we're idle but we're not actually
> idle is a problem?
> 
> Is there something a little smarter we can do? Could we use
> on_each_cpu_cond() with a function that checks if the CPU really is
> fully idle?
> 
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

If Paul finished his "synchronize_all_tasks_scheduled()" then we could
use that instead. Where "synchornize_all_tasks_scheduled()" would
return after all tasks have either scheduled, in userspace, or idle
(that is, not on the run queue). And scheduled means a non preempted
schedule, where the task itself actually called schedule.

Paul, how you doing on that? You said you could have something by 3.17.
That's coming up quick :-)

-- Steve
