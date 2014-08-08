Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbaHHO7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:59:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:40600 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752570AbaHHO7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:59:02 -0400
Date: Fri, 8 Aug 2014 10:58:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140808105858.171da847@gandalf.local.home>
In-Reply-To: <20140808143413.GB9918@twins.programming.kicks-ass.net>
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
	<20140808143413.GB9918@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014 16:34:13 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Aug 08, 2014 at 10:12:21AM -0400, Steven Rostedt wrote:
> > > Ok, so they're purely used in the function prologue/epilogue callchain.
> > 
> > No, they are also used by optimized kprobes. This is why optimized
> > kprobes depend on !CONFIG_PREEMPT. [ added Masami to the discussion ].
> 
> How do those work? Is that one where the INT3 relocates the instruction
> stream into an alternative 'text' and that JMPs back into the original
> stream at the end?

No, it's where we replace the 'int3' with a jump to a trampoline that
simulates an INT3. Speeds things up quite a bit.

> 
> And what is there to make sure the kprobe itself doesn't do 'funny'?

Well, kprobes, like function callbacks are just restricted like
interrupt handlers are. If they break, they break. They should know
better ;-)

> 
> > Which reminds me. On !CONFIG_PREEMPT, call_rcu_task() should be
> > equivalent to call_rcu_sched().
> 
> Sure, as long as you make absolutely sure none of that code ends up
> calling cond_resched()/might_sleep() etc. Which I think you already said
> was true, so no worries there.

Right. There's no guarantees that someone wont do such a stupid thing.
But then, there's no guarantees that someone wont register an NMI
callback with the same code too.

> 
> > > And you don't want to use synchronize_tasks() because registering a trace
> > > functions is atomic ?
> > 
> > No. Has nothing to do with registering the trace function. The issue is
> > that we have no idea when a task happens to be on a trampoline after it
> > is registered. For example:
> > 
> > ops adds a callback to sys_read:
> > 
> > sys_read() {
> >  call trampoline ->
> >     set up regs for function call.
> >     <interrupt>
> >       preempt_schedule();
> > 
> >       [ new task runs for long time ]
> > 
> > 
> > While this new task is running, we remove the trampoline and want to
> > free it. Say this new task keeps the other task from running for
> > minutes! We call synchronize_sched() or any other rcu call, and all
> > grace periods finish and we free the trampoline. The sys_read() no
> > longer calls our trampoline. Doesn't matter, because that task is still
> > on it. Now we schedule that task back. It's on a trampoline that has
> > just been freed! BOOM. It's executing code that no longer exits.
> 
> Sure, I get that part. What I was getting as is _WHY_ you need
> call_rcu_task(), why isn't synchronize_tasks() good enough?

Oh, because that synchronize_tasks() may take minutes. And that means
we wont be able to return for a long time. The only thing I can really
see using call_rcu_task() is something that needs to free its data. Why
wait around when all you're going to do is call free? It's basically
just a garbage collector.

> 
> > > No need for extra allocations and fancy means of getting rid of them,
> > > and only a few bytes extra wrt the existing function.
> > 
> > This doesn't address the issue we want to solve.
> > 
> > Say we have 1000 functions we want to trace with 1000 different
> > callbacks. Each of theses functions has one call back. How do you solve
> > that with your solution? Today, we do the list for every function. That
> > is, for each of these 1000 functions, we run through 1000 ops looking
> > for the ops that registered for this function. Not very efficient is it?
> 
> Ah, but you didn't say that, didn't you :-)

I just thought it was implied ;-)

> 
> > What we want to do today, is to create a dynamic trampoline for each of
> > theses 1000 functions. Each function will call a separate trampoline
> > that will only call the function that was registered to it. That way,
> > we can have 1000 different ops registered to 1000 different functions
> > and still have the same performance.
> 
> And how will you limit the amount of memory tied up in this? This looks
> like a good way to tie up an immense amount of memory fast.

Well, these operations are currently only allowed by root. Thus, it's
the thing that root should be careful about. The trampolines are small,
and it will take a hell of a lot of callbacks to cause issues.

The thing I'm worried about is to make sure they get freed. Otherwise a
leak will cause more issues than anything else. Which also means we
need to have a way to expedite call_rcu_tasks() if need be.

-- Steve
