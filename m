Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3IIOko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:40:44 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:50315 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3IIOkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:40:43 -0400
Date: Mon, 9 Sep 2013 16:40:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909144037.GH16280@somewhere>
References: <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909121329.GA16280@somewhere>
 <20130909083926.3eceebef@gandalf.local.home>
 <20130909124547.GB16280@somewhere>
 <20130909085504.2ddd7e69@gandalf.local.home>
 <20130909130851.GC16280@somewhere>
 <20130909092142.05780991@gandalf.local.home>
 <20130909092917.0c99b71a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909092917.0c99b71a@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 09:29:17AM -0400, Steven Rostedt wrote:
> On Mon, 9 Sep 2013 09:21:42 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>  
> > Especially since the function name itself is "rcu_is_cpu_idle()" which
> > tells you it's a cpu state, and not a task state. Why would you care in
> > RCU if CPU 1 is idle if you are on CPU 2? The name should be changed.
> 
> > Actually, preempt_count is more a CPU state than a task state. When
> > preempt_count is set, that CPU can not schedule out the current task.
> > It really has nothing to do with the task itself. It's the CPU that
> > can't do something. Preempt count should never traverse with a task
> > from one CPU to another.
> 
> I'll take this a step further. Here's a simple rule to determine if
> something is a task state or a CPU state.
> 
> If the state migrates with a task from one CPU to another, it's a task
> state.

This applies to preempt_count as well.

> 
> If the state never leaves a CPU with a task, then it's a CPU state.

Per CPU and per task property aren't mutually exclusive.
Per task obviously implies per cpu. And per cpu doesn't imply per task.

Taking that into account, when you're dealing with a per task property,
the rest depends on the POV: you can zoom to the lower level and look at
things from the CPU POV. Or you can zoom out and look at thing from the
task POV.

RCU extended quiescent states can be viewed from both POV. RCU just
only cares about the CPU POV.

We don't even need a task to set/unset a CPU to/from extended quiescent state.
It's only a matter of CPU running RCU code. The kernel just happens to use
tasks to run code.

It's a bit the same with spinlocks. spinlocks aren't a task synchronization
but a CPU synchronization. It's low level. Of course a task can't sleep
with a spinlock held (not talking about -rt) so it could be defined as a per
task property. But it's just not relevant.

Mutexes, OTOH, really are task synchronisation. They could be considered from
the CPU view. That's just not relevant either.


> 
> According to the above rules, rcu_is_cpu_idle() is a task state, and
> really should be in task_struct, and preempt_count is a CPU state, and
> should be a per_cpu variable.

No, according to you description, preempt count is a task state.
Eventually it just happens to be both. But more relevant from the CPU POV.

And really the fact that a state can be viewed per task doesn't mean it's
always right to store it in the task struct. The semantics also
play a big role here.



> 
> I think the reason preempt_count never was a per cpu variable, is that
> having it in the stack (thread info) made it easier to test in assembly
> than having to grab the per cpu info. But I believe it's easier to grab
> per cpu info in assembly today than it once was, which is why there is
> a push to move preempt_count to per_cpu where it truly belongs.
> 
> -- Steve
