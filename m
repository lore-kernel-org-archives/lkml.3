Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbaENMLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:11:36 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51049 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaENMLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:11:35 -0400
Date: Wed, 14 May 2014 14:11:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/3] irq_work: Implement remote queueing
Message-ID: <20140514121122.GC1278@localhost.localdomain>
References: <1400019956-25511-1-git-send-email-fweisbec@gmail.com>
 <1400019956-25511-2-git-send-email-fweisbec@gmail.com>
 <20140514090629.GC30445@twins.programming.kicks-ass.net>
 <20140514113808.GA1278@localhost.localdomain>
 <20140514115406.GA11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514115406.GA11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 01:54:06PM +0200, Peter Zijlstra wrote:
> On Wed, May 14, 2014 at 01:38:14PM +0200, Frederic Weisbecker wrote:
> > > > +bool irq_work_queue_on(struct irq_work *work, int cpu)
> > > > +{
> > > > +	/* Only queue if not already pending */
> > > > +	if (!irq_work_claim(work))
> > > > +		return false;
> > > > +
> > > > +	/* All work should have been flushed before going offline */
> > > > +	WARN_ON_ONCE(cpu_is_offline(cpu));
> > > 
> > > 	WARN_ON_ONCE(in_nmi());
> > 
> > Well... I think it's actually NMI-safe.
> 
> I don't think it is, most apic calls do apic_wait_icr_idle() then the
> apic op, if an NMI happens in between and writes to the APIC, the return
> context will see a !idle icr and fail.
> 
> This is why arch_irq_work_raise() again idles the icr after sending the
> IPI.
> 
> Also, I think, seeing what benh said earlier, its unsafe for other archs
> too.

Ah I don't know much these archs details, so I concede it.

> 
> > > > +	llist_add(&work->llnode, &per_cpu(irq_work_list, cpu));
> > > > +	native_send_call_func_single_ipi(cpu);
> > > 
> > > At the very leastestest make that:
> > > 
> > > 	if (llist_add(&work->llnode, &per_cpu(irq_work_list, cpu)))
> > > 		native_send_call_func_single_ipi(cpu);
> > 
> > So yeah the issue is that we may have IRQ_WORK_LAZY in the queue. And
> > if we have only such work in the queue, nobody has raised before us.
> > 
> > So we can't just test with llist_add(). Or if we do, we must then
> > separate raised and lazy list.
> 
> Then do the remote irq_work_raised thing. But it really stinks you broke
> this very nice and simple thing.

I tried not to break boot with printk overhead. That said I've considered having
a very simple "tick work" that can rely on irq work when the tick is stopped
and use it for printk. That would restore the initial simplicity.

> 
> > Also note that nohz is the only user for now and irq_work_claim() thus
> > prevents from double IPI. Of course if more users come up the issue arise
> > again.
> 
> DANGER, half arsed engineering at work, seriously? Just write proper
> code already.
> 
> There's no fucking way the next user will check the implementation to
> make sure its 'sane'.

Are you competing with tglx on grumpiness? You guys are free to treat us
like shit but don't be surprised if one day you'll be alone in kernel/*

> 
> > Maybe I was paranoid but I was worried about the overhead of printk() wakeups
> > on boot if implemented with IPIs.
> > 
> > Of course if I can be proven that it won't bring much damage to use an IPI, I'd
> > be very happy to remove it.
> 
> That's the wrong fucking way around, first proof its needed then do
> something about it. As is I think the LAZY thing is horrid.
