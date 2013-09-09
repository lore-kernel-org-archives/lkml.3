Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3IINhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:37:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2646 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab3IINhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:37:01 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=VnNF1IyMAAAA:8 a=TZq3ZMd33aatIrYAEFMA:9 a=CjuIK1q_8ugA:10 a=0xTnJXsW7RTiM7y9:21 a=LaQHmdEJtULKcCv0:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 09:36:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu, cl@linux.com
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909093658.56fde33f@gandalf.local.home>
In-Reply-To: <20130909132343.GN3966@linux.vnet.ibm.com>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
	<20130906105934.GF20519@somewhere>
	<20130906151851.GQ3966@linux.vnet.ibm.com>
	<1378488088.31445.39.camel@edumazet-glaptop>
	<20130906174117.GU3966@linux.vnet.ibm.com>
	<20130906185927.GE2706@somewhere>
	<20130909105347.GK31370@twins.programming.kicks-ass.net>
	<20130909132343.GN3966@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 06:23:43 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Mon, Sep 09, 2013 at 12:53:47PM +0200, Peter Zijlstra wrote:
> > On Fri, Sep 06, 2013 at 08:59:29PM +0200, Frederic Weisbecker wrote:
> > > Imagine that you're running on an rcu read side critical section on CPU 0, which
> > > is not in extended quiescent state. Now you get preempted in the middle of your
> > > RCU read side critical section (you called rcu_read_lock() but not yet rcu_read_unlock()).
> > > 
> > > Later on, the task is woken up to be scheduled in CPU 1. If CPU 1 is in extended
> > > quiescent state because it runs is userspace, it receives a scheduler IPI,
> > > then schedule_user() is called by the end of the interrupt and in turns calls rcu_user_exit()
> > > before the task is resumed to the code it was running on CPU 0, in the middle of
> > > the rcu read side extended quiescent state.
> > > 
> > > See, the key here is the rcu_user_exit() that restore the CPU on RCU's state machine.
> > > There are other possible scheduler entrypoints when a CPU runs in user extended quiescent
> > > state: exception and syscall entries or even preempt_schedule_irq() in case we receive an irq
> > > in the kernel while we haven't yet reached the call to rcu_user_exit()... All of these should
> > > be covered, otherwise you bet RCU would be prompt to warn.
> > > 
> > > That's why when we call rcu_is_cpu_idle() from an RCU read side critical section, it's legit even
> > > if we can be preempted anytime around it.
> > > And preempt_disable() is probably not even necessary, except perhaps if __get_cpu_var() itself
> > > relies on non-preemptibility for its own correctness on the address calculation.
> > 
> > I've tried reading that trice now, still not making much sense.
> 
> Sorry, Frederic really is describing what is going on here.
> 
> And it really does work.
> 
> > In any case rcu_is_cpu_idle() is complete bollocks, either use
> > __raw_get_cpu_var() and add a _coherent_ explanation for why its right,
> > or its broken.
> 
> Hmmmm...  Adding Christoph Lameter on CC, since he was the one pushing
> for the current formulation of that line of rcu_is_cpu_idle().
> 
> And guys, I have to say that the advice on which per-CPU primitive to use
> varies wildly and randomly.  For all I know, each of you individually
> might well be sticking to the same story, but taken together, your
> collective advice is strongly resembling white noise.
> 
> It is not that the primitives themselves are changing that quickly:
> __raw_get_cpu_var() has been around for three years.
> 
> > In any case the preempt_disable/enable pair there is just plain wrong as
> > Eric pointed out.
> 
> Peter, in the general case, you are quite correct.  But this is a special
> case where it really does work.
> 
> The key point here is that preemption and migration cannot move a task
> from a CPU to which RCU is paying attention to a CPU that RCU is ignoring.
> So yes, by the time the task sees the return value from rcu_is_cpu_idle(),
> that task might be running on some other CPU.  But that is OK, because
> if RCU was paying attention to the old CPU, then RCU must also be paying
> attention to the new CPU.
> 
> Frederic's description gives the details of how this is enforced.
> 
> Here is an example of how this works:
> 
> 1.	Some task running on a CPU 0 (which RCU is paying attention to)
> 	calls rcu_is_cpu_idle(), which disables preemption, checks the
> 	per-CPU variable, sets ret to zero, then enables preemption.
> 
> 	At this point, the task is preempted by some high-priority task.
> 
> 2.	CPU 1 is currently idle, so RCU is -not- paying attention to it.
> 	However, it is decided that our low-priority task should migrate
> 	to CPU 1.
> 
> 3.	CPU 1 is sent an IPI, which forces this CPU out of idle.  This
> 	causes rcu_idle_exit() to be called, which causes RCU to start
> 	paying attention to CPU 1.
> 
> 4.	CPU 1 switches to the low-priority task, which now sees the
> 	return value of rcu_is_cpu_idle().  Now, this return value did
> 	in fact reflect the old state of CPU 0, and the state of CPU 0
> 	might have changed.  (For example, the high-priority task might
> 	have blocked, so that CPU 0 is now idle, which in turn would
> 	mean that RCU is no longer paying attention to it, so that
> 	if rcu_is_cpu_idle() was called right now, it would return
> 	true rather than the false return computed in step 1 above.)
> 
> 5.	But that is OK.  Because of the way RCU and idle interact,
> 	if a call from a given task to rcu_is_cpu_idle() returned false
> 	some time in the past, a call from that same task will also
> 	return false right now.
> 
> So yes, in general it is wrong to disable preemption, grab the value
> of a per-CPU variable, re-enable preemption, and then return the result.
> But there are a number of special cases where it is OK, and this is
> one of them.

It should have been called rcu_is_task_idle() not is_cpu_idle(),
because as you just pointed out, we don't care about the state of the
CPU we are running on, we care about the state of the task.

A comment that said something to the fact of:

	/*
	 * We store the task idle state in a per cpu variable
	 * of the CPU the task is on.
	 */

	preempt_disable();
	ret = yada_yada();
	preempt_enable();

	return ret;

-- Steve
