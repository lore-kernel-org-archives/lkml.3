Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3JDQEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:04:10 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36723 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab3JDQEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:04:08 -0400
Date: Fri, 4 Oct 2013 09:03:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, peter@hurleysoftware.com
Subject: Re: tty^Wrcu/perf lockdep trace.
Message-ID: <20131004160352.GF5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131003190830.GA18672@redhat.com>
 <20131003194226.GO28601@twins.programming.kicks-ass.net>
 <20131003195832.GU5790@linux.vnet.ibm.com>
 <20131004065835.GP28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004065835.GP28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100416-5806-0000-0000-000022F51A89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 08:58:35AM +0200, Peter Zijlstra wrote:
> On Thu, Oct 03, 2013 at 12:58:32PM -0700, Paul E. McKenney wrote:
> > On Thu, Oct 03, 2013 at 09:42:26PM +0200, Peter Zijlstra wrote:
> > > 
> > > That's not tty; that's RCU..
> > > 
> > > On Thu, Oct 03, 2013 at 03:08:30PM -0400, Dave Jones wrote:
> > > >  ======================================================
> > > >  [ INFO: possible circular locking dependency detected ]
> > > >  3.12.0-rc3+ #92 Not tainted
> > > >  -------------------------------------------------------
> > > >  trinity-child2/15191 is trying to acquire lock:
> > > >   (&rdp->nocb_wq){......}, at: [<ffffffff8108ff43>] __wake_up+0x23/0x50
> > > >  
> > > > but task is already holding lock:
> > > >   (&ctx->lock){-.-...}, at: [<ffffffff81154c19>] perf_event_exit_task+0x109/0x230
> > > > 
> > > > which lock already depends on the new lock.
> > > > 
> > > > 
> > > > the existing dependency chain (in reverse order) is:
> > > > 
> > > > -> #3 (&ctx->lock){-.-...}:
> > > >  
> > > > -> #2 (&rq->lock){-.-.-.}:
> > > >  
> > > > -> #1 (&p->pi_lock){-.-.-.}:
> > > >  
> > > > -> #0 (&rdp->nocb_wq){......}:
> > 
> > I suppose I could defer the ->nocb_wq wakeup until the next context switch
> > or transition to idle/userspace, but it might be simpler for put_ctx()
> > to maintain a per-CPU chain of callbacks which are kfree_rcu()ed when
> > ctx->lock is dropped.  Also easier on the kernel/user and kernel/idle
> > transition overhead/latency...
> > 
> > Other thoughts?
> 
> What's caused this? We've had that kfree_rcu() in there for ages. I need
> to audit all the get/put_ctx calls anyway for an unrelated issue but I
> fear its going to be messy to defer that kfree_rcu() call, but I can
> try.

The problem exists, but NOCB made it much more probable.  With non-NOCB
kernels, an irq-disabled call_rcu() invocation does a wake_up() only if
there are more than 10,000 callbacks stacked up on the CPU.  With a NOCB
kernel, the wake_up() happens on the first callback.

So let's look at what is required to solve this within RCU.  Currently,
I cannot safely do any sort of wakeup or even a resched_cpu() from
within an call_rcu() that is called with interrupts disabled because of
this deadlock.  I could require that the rcu_nocb_poll sysfs parameter
always be set, but the energy-efficiency guys are not going to be happy
with the resulting wakeups on idle systems.

I could try defering the wake_up(), Lai Jiangshan style.  The question
is then "to where do I defer it?"  The straightforward answer is to
check on each context switch, each transition to RCU idle, and each
scheduling-clock interrupt from userspace execution.  The scenario that
defeats this is where the CPU has a single runnable task, but where that
task spends much of its time in the kernel, so that the scheduling-clock
interrupts always hit kernel-mode execution.  The callback is then
deferred forever.

We could keep Frederic Weisbecker's kernel/user transition hooks,
currently in place only for NO_HZ_FULL, and propagate these to all
architectures, and do the additional checking on those transitions.
This would work, but is not an immediate solution.  And adds overhead
that is not otherwise needed.

Another approach that just now occurred to me is to do a mod_timer()
each time the first callback is posted with irqs disabled, and to
cancel that timer if the wake_up() gets done later.  (I can safely and
unconditionally do a wake_up() from a timer handler, IIRC.)  So, does
perf ever want to invoke call_rcu() holding a timer lock?

I am not too happy about the complexity of deferring, but maybe it is
the right approach, at least assuming perf isn't going to whack me
with a timer lock.  ;-)

Any other approaches that I am missing?

							Thanx, Paul

