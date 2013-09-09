Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab3IIQDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:03:49 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44099 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab3IIQDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:03:47 -0400
Date: Mon, 9 Sep 2013 18:03:43 +0200
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
Message-ID: <20130909160341.GI16280@somewhere>
References: <20130909121329.GA16280@somewhere>
 <20130909083926.3eceebef@gandalf.local.home>
 <20130909124547.GB16280@somewhere>
 <20130909085504.2ddd7e69@gandalf.local.home>
 <20130909130851.GC16280@somewhere>
 <20130909092142.05780991@gandalf.local.home>
 <20130909092917.0c99b71a@gandalf.local.home>
 <20130909144037.GH16280@somewhere>
 <20130909112057.35403440@gandalf.local.home>
 <20130909113905.0c7d65d7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909113905.0c7d65d7@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 11:39:05AM -0400, Steven Rostedt wrote:
> On Mon, 9 Sep 2013 11:20:57 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > It's a bit the same with spinlocks. spinlocks aren't a task synchronization
> > > but a CPU synchronization. It's low level. Of course a task can't sleep
> > > with a spinlock held (not talking about -rt) so it could be defined as a per
> > > task property. But it's just not relevant.
> > 
> > Again, this is where we get into trouble. No it is not a CPU
> > synchronization. We only disable preemption because of implementation
> > details. Not the concept. A spin lock is only used to protect critical
> > data, and not to disable preemption. Those that use it to disable
> > preemption has caused us issues in -rt.
> > 
> > This is again the problem with confusing implementation with concepts.
> > -rt proved that a spin lock has nothing to do with cpu state, nor
> > preemption.
> > 
> 
> Let me expand on this. Note, using a implementation detail from a item
> is known as a side effect, and is frowned on when doing so.
> 
> In fact, when spin_locks() were created, it was just to point out where
> critical sections are that prevent more than one task from accessing
> some data at the same time. This was needed for multiple CPUs. This was
> done before CONFIG_PREEMPT was even created.
> 
> Then Robert Love built on that concept where these same locations
> had a characteristic that showed where two tasks can not access the
> same data, and used that as preemption points. Points where we can not
> be preempted, and let the kernel become preemptible.
> 
> Then -rt built further on the concept, and made these locations able to
> sleep by removing the areas that could not sleep before (by threading
> IRQs).
> 
> Again, the concept of a spin lock is not about the CPU or even the
> task. It is about accessing some data in a safe way. When we stick to
> concepts, we can expand on them as we did with CONFIG_PREEMPT and
> CONFIG_PREEMPT_RT. It's when people use side effects (disabled
> preemption) that breaks this expansion (like those that use spin_locks
> and access per_cpu data).

Well, I was considering strict basic spinlocks, sticking to the name.
Of course sleeping spinlocks involve the scheduler and the concept of "tasks", and as such
complicate the debate :)
