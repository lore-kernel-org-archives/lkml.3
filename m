Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850AbaGYNZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:25:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:47667 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaGYNZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:25:43 -0400
Date: Fri, 25 Jul 2014 15:25:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Message-ID: <20140725132541.GT12054@laptop.lan>
References: <20140724212620.GO3935@laptop>
 <alpine.DEB.2.10.1407251135590.23352@nanos>
 <20140725124037.GL20603@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725124037.GL20603@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 02:40:37PM +0200, Peter Zijlstra wrote:
> On Fri, Jul 25, 2014 at 11:40:48AM +0200, Thomas Gleixner wrote:
> > On Thu, 24 Jul 2014, Peter Zijlstra wrote:
> > > @@ -29,14 +29,20 @@ void suspend_device_irqs(void)
> > >  	for_each_irq_desc(irq, desc) {
> > >  		unsigned long flags;
> > >  
> > > +		/*
> > > +		 * Ideally this would be a global state, but we cannot
> > > +		 * for the trainwreck that is IRQD_WAKEUP_STATE.
> > > +		 */
> > >  		raw_spin_lock_irqsave(&desc->lock, flags);
> > > -		__disable_irq(desc, irq, true);
> > > +		if (!irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
> > > +			desc->istate |= IRQS_SUSPENDED;
> > >  		raw_spin_unlock_irqrestore(&desc->lock, flags);
> > >  	}
> > >  
> > > -	for_each_irq_desc(irq, desc)
> > > +	for_each_irq_desc(irq, desc) {
> > >  		if (desc->istate & IRQS_SUSPENDED)
> > >  			synchronize_irq(irq);
> > > +	}
> > >  }
> > 
> > So, instead of disabling the interrupt you just mark it
> > suspended. Good luck with level triggered interrupt lines then.
> > 
> > Assume the interrupt fires after you marked it suspended. Then the
> > flow handler will call handle_irq_event() which will do nothing and
> > return handled. So the flow handler will reenable the interrupt line,
> > which will cause the interrupt to fire immediately again after the
> > RETI. Guess how much progress the system is going to make when that
> > happens.
> 
> Urgh, right. I knew it was too easy. Can we have do_irqhandler() ACK the
> interrupt and not call the handler?

OK, so Rafael said there's devices that keep on raising their interrupt
until they get attention. Ideally this won't happen because the device
is suspended etc.. But I'm sure there's some broken piece of hardware
out there that'll make it go boom.


