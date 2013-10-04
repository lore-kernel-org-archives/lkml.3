Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab3JDRKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:10:03 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51844 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3JDRKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:10:00 -0400
Date: Fri, 4 Oct 2013 10:09:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, peter@hurleysoftware.com
Subject: Re: tty^Wrcu/perf lockdep trace.
Message-ID: <20131004170954.GK5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131003190830.GA18672@redhat.com>
 <20131003194226.GO28601@twins.programming.kicks-ass.net>
 <20131003195832.GU5790@linux.vnet.ibm.com>
 <20131004065835.GP28601@twins.programming.kicks-ass.net>
 <20131004160352.GF5790@linux.vnet.ibm.com>
 <20131004165044.GV28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004165044.GV28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100417-6688-0000-0000-0000023D93B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 06:50:44PM +0200, Peter Zijlstra wrote:
> On Fri, Oct 04, 2013 at 09:03:52AM -0700, Paul E. McKenney wrote:
> > The problem exists, but NOCB made it much more probable.  With non-NOCB
> > kernels, an irq-disabled call_rcu() invocation does a wake_up() only if
> > there are more than 10,000 callbacks stacked up on the CPU.  With a NOCB
> > kernel, the wake_up() happens on the first callback.
> 
> Oh I see.. so I was hoping this was some NOCB crackbrained damage we
> could still 'fix'.
> 
> And that wakeup is because we moved grace-period advancing into
> kthreads, right?

Yep, in earlier kernels we would instead be doing raise_softirq().
Which would instead wake up ksoftirqd, if I am reading the code
correctly -- spin_lock_irq() does not affect preempt_count.

> > I am not too happy about the complexity of deferring, but maybe it is
> > the right approach, at least assuming perf isn't going to whack me
> > with a timer lock.  ;-)
> 
> I'm not too thrilled about trying to move the call_rcu() usage either.

Understood!

> > Any other approaches that I am missing?
> 
> Probably; so the regular no-NOCB would be easy to work around by
> providing me a call_rcu variant that never does the wakeup.

Well, if we can safely, sanely, and reliably defer the wakeup, there is
no reason not to make plain old call_rcu() do what you need.  If there
is no such way to defer the wakeup, then I don't see how to make that
variant.

> NOCB might be a little more difficult; depending on the reason why it
> needs to do this wakeup on every single invocation; that seems
> particularly expensive.

Not on every single invocation, just on those invocations where the list
is initially empty.  So the first call_rcu() on a CPU whose rcuo kthread
is sleeping will do a wakeup, but subsequent call_rcu()s will just queue,
at least until rcuo goes to sleep again.  Which takes awhile, since it
has to wait for a grace period before invoking that first RCU callback.

> Man, RCU was so much easier when all it was was a strict per-cpu state
> with timer-interrupt driven state machine; non of all this nonsense.

Tell me about it!  This bit about avoiding scheduling-clock interrupts
for all sorts of reasons has most definitely added to my collection of
gray hairs.  ;-)

							Thanx, Paul

