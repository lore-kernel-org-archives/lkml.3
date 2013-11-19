Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab3KSIa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:30:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60005 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3KSIaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:30:24 -0500
Date: Tue, 19 Nov 2013 09:30:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] rtmutex: take the waiter lock with irqs off
Message-ID: <20131119083015.GF10022@twins.programming.kicks-ass.net>
References: <1383798668.5441.25.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
 <20131107125923.GB24644@localhost.localdomain>
 <alpine.DEB.2.02.1311071402380.23353@ionos.tec.linutronix.de>
 <1384243595.15180.63.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311121024590.30673@ionos.tec.linutronix.de>
 <20131115163008.GB12164@linutronix.de>
 <20131115201436.GC12164@linutronix.de>
 <20131118141021.GA10022@twins.programming.kicks-ass.net>
 <20131118235956.GA1810@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118235956.GA1810@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 12:59:59AM +0100, Frederic Weisbecker wrote:
> On Mon, Nov 18, 2013 at 03:10:21PM +0100, Peter Zijlstra wrote:
> > --- a/kernel/softirq.c
> > +++ b/kernel/softirq.c
> > @@ -746,13 +746,23 @@ void irq_exit(void)
> >  #endif
> >  
> >  	account_irq_exit_time(current);
> > -	trace_hardirq_exit();
> >  	sub_preempt_count(HARDIRQ_OFFSET);
> > -	if (!in_interrupt() && local_softirq_pending())
> > +	if (!in_interrupt() && local_softirq_pending()) {
> > +		/*
> > +		 * Temp. disable hardirq context so as not to confuse lockdep;
> > +		 * otherwise it might think we're running softirq handler from
> > +		 * hardirq context.
> > +		 *
> > +		 * Should probably sort this someplace else..
> > +		 */
> > +		trace_hardirq_exit();
> >  		invoke_softirq();
> > +		trace_hardirq_enter();
> > +	}
> >  
> >  	tick_irq_exit();
> >  	rcu_irq_exit();
> > +	trace_hardirq_exit();
> 
> Looks like a change we really want!

Yeah, let me stare at the softirq mess again to see if there's anything
better/prettier we can do.
