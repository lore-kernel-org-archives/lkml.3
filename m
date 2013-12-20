Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab3LTSX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:23:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:52607 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751039Ab3LTSX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:23:27 -0500
Date: Fri, 20 Dec 2013 13:23:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Subject: Re: [PATCH 09/13] sched: Add bandwidth management for sched_dl
Message-ID: <20131220132323.524cf2b1@gandalf.local.home>
In-Reply-To: <20131220174200.GX16438@laptop.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org>
	<20131217123353.180539582@infradead.org>
	<20131218165508.GB30183@twins.programming.kicks-ass.net>
	<20131220171343.GL2480@laptop.programming.kicks-ass.net>
	<20131220123707.44fb7192@gandalf.local.home>
	<20131220174200.GX16438@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013 18:42:00 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Dec 20, 2013 at 12:37:07PM -0500, Steven Rostedt wrote:
> > On Fri, 20 Dec 2013 18:13:43 +0100
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > 
> > > @@ -4985,6 +4942,23 @@ migration_call(struct notifier_block *nf
> > >  	unsigned long flags;
> > >  	struct rq *rq = cpu_rq(cpu);
> > >  
> > > +	switch (action) {
> > > +	case CPU_DOWN_PREPARE: /* explicitly allow suspend */
> > > +		{
> > > +			struct dl_bw *dl_b = dl_bw_of(cpu);
> > > +			int cpus = dl_bw_cpus(cpu);
> > > +			bool overflow;
> > > +
> > > +			raw_spin_lock_irqsave(&dl_b->lock, flags);
> > > +			overflow = __dl_overflow(dl_b, cpus-1, 0, 0);
> > > +			raw_spin_unlock_irqrestore(&dl_b->lock, flags);
> > > +
> > > +			if (overflow)
> > > +				return notifier_from_errno(-EBUSY);
> > 
> > Is it possible to have a race here to create a new deadline task that
> > may work with cpus but not cpus-1? That is, if a new deadline task is
> > currently being created as a CPU is going offline, this check happens
> > first while the creation is spinning on the dl_b->lock, and it sets
> > overflow to false, then once the lock is released, the new deadline
> > task makes the condition true.
> > 
> > Should the system call have a get_online_cpus() somewhere?
> 
> No, should be all good; the entire admission control is serialized by
> that dl_b->lock, and its a raw_spin_lock (as can be seen from the above)
> which already very much excludes hotplug.

I'm saying what stops this?


	CPU 0			CPU 1
	-----			-----
 sched_setattr()
 dl_overflow()
 cpus = __dl_span_weight()

			  cpu_down()
			  raw_spin_lock()
 raw_spin_lock() /* blocks */


			  overflow = __dl_overflow(cpus-1);
			  raw_spin_unlock();

 /* gets lock */
 __dl_overflow(cpus) /* all OK! */



			  /* cpus goes to cpus - 1 making
			     __dl_overflow() not OK anymore */


-- Steve

