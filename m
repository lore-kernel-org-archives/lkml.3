Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3IIOWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:22:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52193 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3IIOW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:22:29 -0400
Date: Mon, 9 Sep 2013 16:21:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu, cl@linux.com
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909142155.GC26785@twins.programming.kicks-ass.net>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
 <20130906105934.GF20519@somewhere>
 <20130906151851.GQ3966@linux.vnet.ibm.com>
 <1378488088.31445.39.camel@edumazet-glaptop>
 <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909132343.GN3966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909132343.GN3966@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 06:23:43AM -0700, Paul E. McKenney wrote:
> Peter, in the general case, you are quite correct.  But this is a special
> case where it really does work.
> 
> The key point here is that preemption and migration cannot move a task
> from a CPU to which RCU is paying attention to a CPU that RCU is ignoring.

But there's no constraint placed on the migration mask (aka
task_struct::cpus_allowed) and therefore it can move it thusly.

What you're trying to say is that by the time the task is running on
another cpu, that cpu's state will match the state of the previous cpu,
no?

> So yes, by the time the task sees the return value from rcu_is_cpu_idle(),
> that task might be running on some other CPU.  But that is OK, because
> if RCU was paying attention to the old CPU, then RCU must also be paying
> attention to the new CPU.

OK, fair enough.

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

Just a nit, we typically try to avoid using IPIs to wake idle CPUs,
doesn't change the story much though.

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

Right, worthy of comments though :-)
