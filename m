Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934762AbaGYQpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:45:25 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52949 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934611AbaGYQpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:45:21 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Date: Fri, 25 Jul 2014 19:03:38 +0200
Message-ID: <2870044.iEzUSaptji@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140725132541.GT12054@laptop.lan>
References: <20140724212620.GO3935@laptop> <20140725124037.GL20603@laptop.programming.kicks-ass.net> <20140725132541.GT12054@laptop.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 25, 2014 03:25:41 PM Peter Zijlstra wrote:
> On Fri, Jul 25, 2014 at 02:40:37PM +0200, Peter Zijlstra wrote:
> > On Fri, Jul 25, 2014 at 11:40:48AM +0200, Thomas Gleixner wrote:
> > > On Thu, 24 Jul 2014, Peter Zijlstra wrote:
> > > > @@ -29,14 +29,20 @@ void suspend_device_irqs(void)
> > > >  	for_each_irq_desc(irq, desc) {
> > > >  		unsigned long flags;
> > > >  
> > > > +		/*
> > > > +		 * Ideally this would be a global state, but we cannot
> > > > +		 * for the trainwreck that is IRQD_WAKEUP_STATE.
> > > > +		 */
> > > >  		raw_spin_lock_irqsave(&desc->lock, flags);
> > > > -		__disable_irq(desc, irq, true);
> > > > +		if (!irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
> > > > +			desc->istate |= IRQS_SUSPENDED;
> > > >  		raw_spin_unlock_irqrestore(&desc->lock, flags);
> > > >  	}
> > > >  
> > > > -	for_each_irq_desc(irq, desc)
> > > > +	for_each_irq_desc(irq, desc) {
> > > >  		if (desc->istate & IRQS_SUSPENDED)
> > > >  			synchronize_irq(irq);
> > > > +	}
> > > >  }
> > > 
> > > So, instead of disabling the interrupt you just mark it
> > > suspended. Good luck with level triggered interrupt lines then.
> > > 
> > > Assume the interrupt fires after you marked it suspended. Then the
> > > flow handler will call handle_irq_event() which will do nothing and
> > > return handled. So the flow handler will reenable the interrupt line,
> > > which will cause the interrupt to fire immediately again after the
> > > RETI. Guess how much progress the system is going to make when that
> > > happens.
> > 
> > Urgh, right. I knew it was too easy. Can we have do_irqhandler() ACK the
> > interrupt and not call the handler?
> 
> OK, so Rafael said there's devices that keep on raising their interrupt
> until they get attention. Ideally this won't happen because the device
> is suspended etc.. But I'm sure there's some broken piece of hardware
> out there that'll make it go boom.

So here's an idea.

What about returning IRQ_NONE rather than IRQ_HANDLED for "suspended"
interrupts (after all, that's what a sane driver would do for a
suspended device I suppose)?

If the line is really shared and the interrupt is taken care of by
the other guy sharing the line, we'll be all fine.

If that is not the case, on the other hand, and something's really
broken, we'll end up disabling the interrupt and marking it as
IRQS_SPURIOUS_DISABLED (if I understand things correctly).

But then, we can re-enable it and clear the IRQS_SPURIOUS_DISABLED
flag at the resume_device_irqs() time so the driver can use it again.
And we'll have a trace of the breakage in dmesg, so possibly we can
go forth and fix the bad guy.

Would that make sense?

Rafael

