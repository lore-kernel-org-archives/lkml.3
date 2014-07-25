Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbaGYMkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:40:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaGYMko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:40:44 -0400
Date: Fri, 25 Jul 2014 14:40:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Message-ID: <20140725124037.GL20603@laptop.programming.kicks-ass.net>
References: <20140724212620.GO3935@laptop>
 <alpine.DEB.2.10.1407251135590.23352@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1407251135590.23352@nanos>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 11:40:48AM +0200, Thomas Gleixner wrote:
> On Thu, 24 Jul 2014, Peter Zijlstra wrote:
> > @@ -29,14 +29,20 @@ void suspend_device_irqs(void)
> >  	for_each_irq_desc(irq, desc) {
> >  		unsigned long flags;
> >  
> > +		/*
> > +		 * Ideally this would be a global state, but we cannot
> > +		 * for the trainwreck that is IRQD_WAKEUP_STATE.
> > +		 */
> >  		raw_spin_lock_irqsave(&desc->lock, flags);
> > -		__disable_irq(desc, irq, true);
> > +		if (!irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
> > +			desc->istate |= IRQS_SUSPENDED;
> >  		raw_spin_unlock_irqrestore(&desc->lock, flags);
> >  	}
> >  
> > -	for_each_irq_desc(irq, desc)
> > +	for_each_irq_desc(irq, desc) {
> >  		if (desc->istate & IRQS_SUSPENDED)
> >  			synchronize_irq(irq);
> > +	}
> >  }
> 
> So, instead of disabling the interrupt you just mark it
> suspended. Good luck with level triggered interrupt lines then.
> 
> Assume the interrupt fires after you marked it suspended. Then the
> flow handler will call handle_irq_event() which will do nothing and
> return handled. So the flow handler will reenable the interrupt line,
> which will cause the interrupt to fire immediately again after the
> RETI. Guess how much progress the system is going to make when that
> happens.

Urgh, right. I knew it was too easy. Can we have do_irqhandler() ACK the
interrupt and not call the handler?
