Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3IIPWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:22:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32676 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab3IIPVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:21:00 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=pGLkceISAAAA:8 a=F7ZLs3jk69K1vge9GfwA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 11:20:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Message-ID: <20130909112057.35403440@gandalf.local.home>
In-Reply-To: <20130909144037.GH16280@somewhere>
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
	<20130909144037.GH16280@somewhere>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 16:40:38 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Sep 09, 2013 at 09:29:17AM -0400, Steven Rostedt wrote:
> > On Mon, 9 Sep 2013 09:21:42 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> >  
> > > Especially since the function name itself is "rcu_is_cpu_idle()" which
> > > tells you it's a cpu state, and not a task state. Why would you care in
> > > RCU if CPU 1 is idle if you are on CPU 2? The name should be changed.
> > 
> > > Actually, preempt_count is more a CPU state than a task state. When
> > > preempt_count is set, that CPU can not schedule out the current task.
> > > It really has nothing to do with the task itself. It's the CPU that
> > > can't do something. Preempt count should never traverse with a task
> > > from one CPU to another.
> > 
> > I'll take this a step further. Here's a simple rule to determine if
> > something is a task state or a CPU state.
> > 
> > If the state migrates with a task from one CPU to another, it's a task
> > state.
> 
> This applies to preempt_count as well.

No it does not, because the very definition of preempt_count means the
task can not migrate. And why would a task want preempt count activated?
Because it is dealing with per cpu data! Again, if we look at the
concept, it's not a task state, its a CPU state, because the reason to
disable preemption is that the task needs to look at stuff specific to
the CPU. There's a reason that we don't want the task to migrate, and
that reason has to do with data specific to the CPU not the task.

> 
> > 
> > If the state never leaves a CPU with a task, then it's a CPU state.
> 
> Per CPU and per task property aren't mutually exclusive.

No, but using my simple rules (and that's why I made them simple). They
can be. :-)

> Per task obviously implies per cpu. And per cpu doesn't imply per task.

I disagree. A state of a task can move with the task when it moves to
another CPU. That means the task state does not imply per cpu state.

For example, a task may be sleeping and not on any CPU, but it still
has that "state", where no CPU has it.

And I can say per cpu implies per task, as a state of the CPU implies
that it is also the current state of the task running on that CPU.

A CPU always has one task on it (idle if nothing is running), thus any
CPU state is also some task state. But a task may not be on any CPU,
thus a task state does not imply that any CPU has that state as well.

> 
> Taking that into account, when you're dealing with a per task property,
> the rest depends on the POV: you can zoom to the lower level and look at
> things from the CPU POV. Or you can zoom out and look at thing from the
> task POV.

But I just negated "that account", so this no longer applies.

> 
> RCU extended quiescent states can be viewed from both POV. RCU just
> only cares about the CPU POV.

No it does not!

What is a grace period? Some task has access to some data that is about
to change, but a synchronize_rcu() has been executed, and needs to wait
for the grace period to end before it can continue. If that task
sleeps, then there's no CPU that RCU cares about. It cares *only* about
the tasks that are preventing the grace period to finish. Why else do
we implement rcu boosting?

Please, lets focus on the concept of RCU not the implementation.

> 
> We don't even need a task to set/unset a CPU to/from extended quiescent state.
> It's only a matter of CPU running RCU code. The kernel just happens to use
> tasks to run code.

We are really confusing dynamic ticks and NO_HZ with RCU here. I hate
the term "extended quiescent state", when it really just means the CPU
is not using RCU anymore. Yes, that is a CPU state. But I think we are
getting things backwards. We are saying its a RCU state, when it really
is a CPU state, and this is due to our implementation and not about RCU
itself.

The CPU can not be in this state if the task does something that
requires accessing RCU critical data. Basically, there's a state that
says the task wont be doing any RCU work (going idle, or going into
userland), and thus, we have an implementation to optimize RCU not to
care about this CPU. The confusion here is that this is an optimization
implementation, and not a "concept" of RCU.

It's really a CPU and task state that say "we don't need RCU, so RCU go
do your business someplace else".

But this is implemented in the RCU system, and thus we are saying that
RCU is dictating what is going on here, when it really is the task and
CPU state that are doing the dictating.

This is why I liked "rcu_ignored()" as it really is the real state of
affairs. We are basically saying that the task, or tasks, running on
the CPU is not going to do any RCU work, so the RCU system can safely
ignore this CPU as an optimization implementation.

And this is where all POVs are getting confused :-)



> 
> It's a bit the same with spinlocks. spinlocks aren't a task synchronization
> but a CPU synchronization. It's low level. Of course a task can't sleep
> with a spinlock held (not talking about -rt) so it could be defined as a per
> task property. But it's just not relevant.

Again, this is where we get into trouble. No it is not a CPU
synchronization. We only disable preemption because of implementation
details. Not the concept. A spin lock is only used to protect critical
data, and not to disable preemption. Those that use it to disable
preemption has caused us issues in -rt.

This is again the problem with confusing implementation with concepts.
-rt proved that a spin lock has nothing to do with cpu state, nor
preemption.

> 
> Mutexes, OTOH, really are task synchronisation. They could be considered from
> the CPU view. That's just not relevant either.

Mutexes are just a different implementation of a lock. And yes, the
sleeping nature of a mutex makes it have a different concept, but
that's because we then can not use it for places that can not sleep.

> 
> 
> > 
> > According to the above rules, rcu_is_cpu_idle() is a task state, and
> > really should be in task_struct, and preempt_count is a CPU state, and
> > should be a per_cpu variable.
> 
> No, according to you description, preempt count is a task state.

No, I already stated that it is not a task state.

> Eventually it just happens to be both. But more relevant from the CPU POV.

No it is not.

> 
> And really the fact that a state can be viewed per task doesn't mean it's
> always right to store it in the task struct. The semantics also
> play a big role here.

I'll say that implementation can play a big role. If there's a fast way
to implement something, we need to do it that way, even if one looks at
it and says "hmm, that doesn't match the concept". But those need to be
commented.

I'm not saying that we must follow the concept in our implementation,
I'm saying that names of functions and comments need to be focused on
concept, where as the implementation can focus on optimizations, and
comment where they differ.

For example, preempt_count really is a per cpu state. But because of
issues accessing it in assembly, it was added to a task state. And when
things change like this, we have to add hacks when concept and
implementation differ. For example, when interrupts came in and used a
different stack, we now can not use the stack info to access preempt
count. This hack has changed over the years, but just points out how
things go apart when concept and implementation differ.


-- Steve
