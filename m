Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3JDSws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:52:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53697 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3JDSwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:52:47 -0400
Date: Fri, 4 Oct 2013 20:52:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, peter@hurleysoftware.com
Subject: Re: tty^Wrcu/perf lockdep trace.
Message-ID: <20131004185239.GS15690@laptop.programming.kicks-ass.net>
References: <20131003190830.GA18672@redhat.com>
 <20131003194226.GO28601@twins.programming.kicks-ass.net>
 <20131003195832.GU5790@linux.vnet.ibm.com>
 <20131004065835.GP28601@twins.programming.kicks-ass.net>
 <20131004160352.GF5790@linux.vnet.ibm.com>
 <20131004165044.GV28601@twins.programming.kicks-ass.net>
 <20131004170954.GK5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004170954.GK5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 10:09:54AM -0700, Paul E. McKenney wrote:
> On Fri, Oct 04, 2013 at 06:50:44PM +0200, Peter Zijlstra wrote:
> > On Fri, Oct 04, 2013 at 09:03:52AM -0700, Paul E. McKenney wrote:
> > > The problem exists, but NOCB made it much more probable.  With non-NOCB
> > > kernels, an irq-disabled call_rcu() invocation does a wake_up() only if
> > > there are more than 10,000 callbacks stacked up on the CPU.  With a NOCB
> > > kernel, the wake_up() happens on the first callback.
> > 
> > Oh I see.. so I was hoping this was some NOCB crackbrained damage we
> > could still 'fix'.
> > 
> > And that wakeup is because we moved grace-period advancing into
> > kthreads, right?
> 
> Yep, in earlier kernels we would instead be doing raise_softirq().
> Which would instead wake up ksoftirqd, if I am reading the code
> correctly -- spin_lock_irq() does not affect preempt_count.

I suspect you got lost in the indirection fest; but have a look at
__raw_spin_lock_irqsave(). It does:

	local_irq_save();
	preempt_disable();

> > Probably; so the regular no-NOCB would be easy to work around by
> > providing me a call_rcu variant that never does the wakeup.
> 
> Well, if we can safely, sanely, and reliably defer the wakeup, there is
> no reason not to make plain old call_rcu() do what you need.

Agreed.

> If there
> is no such way to defer the wakeup, then I don't see how to make that
> variant.

Wouldn't it be a simple matter of making __call_rcu_core() return early,
just like it does for irqs_disabled_flags()?

> > NOCB might be a little more difficult; depending on the reason why it
> > needs to do this wakeup on every single invocation; that seems
> > particularly expensive.
> 
> Not on every single invocation, just on those invocations where the list
> is initially empty.  So the first call_rcu() on a CPU whose rcuo kthread
> is sleeping will do a wakeup, but subsequent call_rcu()s will just queue,
> at least until rcuo goes to sleep again.  Which takes awhile, since it
> has to wait for a grace period before invoking that first RCU callback.

So I've not kept up with RCU the last year or so due to circumstance, so
please bear with me ( http://www.youtube.com/watch?v=4sxtHODemi0 ). Why
do we still have a per-cpu kthread in nocb mode? The idea is that we do
not disturb the cpu, right? So I suppose these kthreads get to run on
another cpu.

Since its running on another cpu; we get into atomic and memory barriers
anyway; so why not keep the logic the same as no-nocb but have another
cpu check our nocb cpu's state.

That is; I'm fumbling to understand how all this works and needs to be
different.
