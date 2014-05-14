Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbaENLiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:38:25 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:60294 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaENLiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:38:24 -0400
Date: Wed, 14 May 2014 13:38:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/3] irq_work: Implement remote queueing
Message-ID: <20140514113808.GA1278@localhost.localdomain>
References: <1400019956-25511-1-git-send-email-fweisbec@gmail.com>
 <1400019956-25511-2-git-send-email-fweisbec@gmail.com>
 <20140514090629.GC30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514090629.GC30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 11:06:29AM +0200, Peter Zijlstra wrote:
> On Wed, May 14, 2014 at 12:25:54AM +0200, Frederic Weisbecker wrote:
> > irq work currently only supports local callbacks. However its code
> > is mostly ready to run remote callbacks and we have some potential user.
> > 
> > The full nohz subsystem currently open codes its own remote irq work
> > on top of the scheduler ipi when it wants a CPU to reevaluate its next
> > tick. However this ad hoc solution bloats the scheduler IPI.
> > 
> > Lets just extend the irq work subsystem to support remote queuing on top
> > of the generic SMP IPI to handle this kind of user. This shouldn't add
> > noticeable overhead.
> > 
> > Suggested-by: Peter Zijlstra <peterz@infradead.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  include/linux/irq_work.h |  2 ++
> >  kernel/irq_work.c        | 19 ++++++++++++++++++-
> >  kernel/smp.c             |  4 ++++
> >  3 files changed, 24 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
> > index 19ae05d..ae44aa2 100644
> > --- a/include/linux/irq_work.h
> > +++ b/include/linux/irq_work.h
> > @@ -33,6 +33,8 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
> >  #define DEFINE_IRQ_WORK(name, _f) struct irq_work name = { .func = (_f), }
> >  
> >  bool irq_work_queue(struct irq_work *work);
> > +bool irq_work_queue_on(struct irq_work *work, int cpu);
> > +
> >  void irq_work_run(void);
> >  void irq_work_sync(struct irq_work *work);
> >  
> > diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> > index a82170e..9f9be55 100644
> > --- a/kernel/irq_work.c
> > +++ b/kernel/irq_work.c
> > @@ -56,11 +56,28 @@ void __weak arch_irq_work_raise(void)
> >  }
> >  
> >  /*
> > - * Enqueue the irq_work @entry unless it's already pending
> > + * Enqueue the irq_work @work on @cpu unless it's already pending
> >   * somewhere.
> >   *
> >   * Can be re-enqueued while the callback is still in progress.
> >   */
> > +bool irq_work_queue_on(struct irq_work *work, int cpu)
> > +{
> > +	/* Only queue if not already pending */
> > +	if (!irq_work_claim(work))
> > +		return false;
> > +
> > +	/* All work should have been flushed before going offline */
> > +	WARN_ON_ONCE(cpu_is_offline(cpu));
> 
> 	WARN_ON_ONCE(in_nmi());

Well... I think it's actually NMI-safe.

> 
> > +
> > +	llist_add(&work->llnode, &per_cpu(irq_work_list, cpu));
> > +	native_send_call_func_single_ipi(cpu);
> 
> At the very leastestest make that:
> 
> 	if (llist_add(&work->llnode, &per_cpu(irq_work_list, cpu)))
> 		native_send_call_func_single_ipi(cpu);

So yeah the issue is that we may have IRQ_WORK_LAZY in the queue. And
if we have only such work in the queue, nobody has raised before us.

So we can't just test with llist_add(). Or if we do, we must then
separate raised and lazy list.

Also note that nohz is the only user for now and irq_work_claim() thus
prevents from double IPI. Of course if more users come up the issue arise
again.

> 
> But ideally, also test the IRQ_WORK_LAZY support, its weird to have that
> only be supported for the other queue.

OTOH IRQ_WORK_LAZY don't make much sense in remote queueing. We can't safely
just *wait* for another CPU's tick. The IPI is necessary anyway.

> 
> Hmm, why do we need that LAZY crap, that completely wrecks a perfectly
> simple thing.
> 
> The changelog (bc6679aef673f), not the printk() usage make much sense,
> printk() can't cause an IPI storm... printk() isn't fast enough to storm
> anything.

Maybe I was paranoid but I was worried about the overhead of printk() wakeups
on boot if implemented with IPIs.

Of course if I can be proven that it won't bring much damage to use an IPI, I'd
be very happy to remove it.
