Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbaHHO2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:28:19 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53744 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaHHO2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:28:17 -0400
Date: Fri, 8 Aug 2014 07:28:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, bobby.prani@gmail.com,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140808142810.GV5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140807150031.GB5821@linux.vnet.ibm.com>
 <20140807152600.GW9918@twins.programming.kicks-ass.net>
 <20140807172753.GG3588@twins.programming.kicks-ass.net>
 <20140807184635.GI3588@twins.programming.kicks-ass.net>
 <20140807154907.6f59cf6e@gandalf.local.home>
 <20140807155326.18481e66@gandalf.local.home>
 <20140807200813.GB3935@laptop>
 <20140807171823.1a481290@gandalf.local.home>
 <20140808064020.GZ9918@twins.programming.kicks-ass.net>
 <20140808101221.21056900@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808101221.21056900@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080814-6688-0000-0000-000003DCCFFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 10:12:21AM -0400, Steven Rostedt wrote:
> On Fri, 8 Aug 2014 08:40:20 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, Aug 07, 2014 at 05:18:23PM -0400, Steven Rostedt wrote:
> > > On Thu, 7 Aug 2014 22:08:13 +0200
> > > Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > OK, you've got to start over and start at the beginning, because I'm
> > > > really not understanding this..
> > > > 
> > > > What is a 'trampoline' and what are you going to use them for.
> > > 
> > > Great question! :-)
> > > 
> > > The trampoline is some code that is used to jump to and then jump
> > > someplace else. Currently, we use this for kprobes and ftrace. For
> > > ftrace we have the ftrace_caller trampoline, which is static. When
> > > booting, most functions in the kernel call the mcount code which
> > > simply returns without doing anything. This too is a "trampoline". At
> > > boot, we convert these calls to nops (as you already know). When we
> > > enable callbacks from functions, we convert those calls to call
> > > "ftrace_caller" which is a small assembly trampoline that will call
> > > some function that registered with ftrace.
> > > 
> > > Now why do we need the call_rcu_task() routine?
> > > 
> > > Right now, if you register multiple callbacks to ftrace, even if they
> > > are not tracing the same routine, ftrace has to change ftrace_caller to
> > > call another trampoline (in C), that does a loop of all ops registered
> > > with ftrace, and compares the function to the ops hash tables to see if
> > > the ops function should be called for that function.
> > > 
> > > What we want to do is to create a dynamic trampoline that is a copy of
> > > the ftrace_caller code, but instead of calling this list trampoline, it
> > > calls the ops function directly. This way, each ops registered with
> > > ftrace can have its own custom trampoline that when called will only
> > > call the ops function and not have to iterate over a list. This only
> > > happens if the function being traced only has this one ops registered.
> > > For functions with multiple ops attached to it, we need to call the
> > > list anyway. But for the majority of the cases, this is not the case.
> > > 
> > > The one caveat for this is, how do we free this custom trampoline when
> > > the ops is done with it? Especially for users of ftrace that
> > > dynamically create their own ops (like perf, and ftrace instances).
> > > 
> > > We need to find a way to free it, but unfortunately, there's no way to
> > > know when it is safe to free it. There's no way to disable preemption
> > > or have some other notifier to let us know if a task has jumped to this
> > > trampoline and has been preempted (sleeping). The only safe way to know
> > > that no task is on the trampoline is to remove the calls to it,
> > > synchronize the CPUS (so the trampolines are not even in the caches),
> > > and then wait for all tasks to go through some quiescent state. This
> > > state happens to be either not running, in userspace, or when it
> > > voluntarily calls schedule. Because nothing that uses this trampoline
> > > should do that, and if the task voluntarily calls schedule, we know
> > > it's not on the trampoline.
> > > 
> > > Make sense?
> > 
> > Ok, so they're purely used in the function prologue/epilogue callchain.
> 
> No, they are also used by optimized kprobes. This is why optimized
> kprobes depend on !CONFIG_PREEMPT. [ added Masami to the discussion ].
> 
> Which reminds me. On !CONFIG_PREEMPT, call_rcu_task() should be
> equivalent to call_rcu_sched().

Almost.  One difference is that call_rcu_sched() won't wait for
idle-task execution.  So presumably you are currently prohibited from
putting kprobes in idle tasks.

Oleg slipped this one past me, and for more than a full hour,
(https://lkml.org/lkml/2014/8/2/18), but this time I remembered.  ;-)

							Thanx, Paul

> > And you don't want to use synchronize_tasks() because registering a trace
> > functions is atomic ?
> 
> No. Has nothing to do with registering the trace function. The issue is
> that we have no idea when a task happens to be on a trampoline after it
> is registered. For example:
> 
> ops adds a callback to sys_read:
> 
> sys_read() {
>  call trampoline ->
>     set up regs for function call.
>     <interrupt>
>       preempt_schedule();
> 
>       [ new task runs for long time ]
> 
> 
> While this new task is running, we remove the trampoline and want to
> free it. Say this new task keeps the other task from running for
> minutes! We call synchronize_sched() or any other rcu call, and all
> grace periods finish and we free the trampoline. The sys_read() no
> longer calls our trampoline. Doesn't matter, because that task is still
> on it. Now we schedule that task back. It's on a trampoline that has
> just been freed! BOOM. It's executing code that no longer exits.
> 
> > 
> > But why would you use dynamic memory allocation for these trampolines at
> > all? Why not use the one default trampoline for this?
> 
> That's what ftrace does today.
> 
> > 
> > Suppose that thing looks like:
> > 
> > ftrace_mcount_handler()
> > {
> > 	for_each_hlist_rcu(entry,..)
> > 		entry->func();
> > }
> > 
> > so why not make it look like:
> > 
> > ftrace_mcount_handler()
> > {
> > 	asm_volatile_goto("jmp %l[label]" ::: &do_list);
> > 	return;
> > 
> > do_list:
> > 	for_each_hlist_rcu(entry,...)
> > 		entry->func();
> > }
> > 
> > Then, for:
> > 	no entries -> NOP, 
> > 	one entry -> "CALL $func", 
> > 	more entries -> "JMP &do_list.
> 
> Except that we don't use jump labels for this, but just update the
> trampoline directly (we've been doing this before jump labels ever
> existed, and the trampoline is all in assembly anyway).
> 
> > 
> > No need for extra allocations and fancy means of getting rid of them,
> > and only a few bytes extra wrt the existing function.
> 
> This doesn't address the issue we want to solve.
> 
> Say we have 1000 functions we want to trace with 1000 different
> callbacks. Each of theses functions has one call back. How do you solve
> that with your solution? Today, we do the list for every function. That
> is, for each of these 1000 functions, we run through 1000 ops looking
> for the ops that registered for this function. Not very efficient is it?
> 
> 
> What we want to do today, is to create a dynamic trampoline for each of
> theses 1000 functions. Each function will call a separate trampoline
> that will only call the function that was registered to it. That way,
> we can have 1000 different ops registered to 1000 different functions
> and still have the same performance.
> 
> -- Steve
> 

