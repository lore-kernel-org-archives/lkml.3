Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaHAJlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:41:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:40140 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHAJlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:41:21 -0400
Date: Fri, 1 Aug 2014 11:40:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup
 interruptsn
In-Reply-To: <1624300.2IhdzCt5pu@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1408010217090.4997@nanos>
References: <20140724212620.GO3935@laptop> <2140085.bSS0bVjyxJ@vostro.rjw.lan> <alpine.DEB.2.10.1407312103190.4997@nanos> <1624300.2IhdzCt5pu@vostro.rjw.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2014, Rafael J. Wysocki wrote:
> On Friday, August 01, 2014 12:16:23 AM Thomas Gleixner wrote:
> > Right, so instead of thinking about a proper solution driver folks just slap
> > the next available thing on it w/o thinking about the consequences. But,
> > thats partly our own fault due to lack of proper documentation.
> 
> Prototyping with the next available thing is not generally wrong in my view
> as long as this doesn't get to the code base without consideration.

Prototyping is one thing, but we have real users which are simply wrong
AFAICT.
 
> > > And now there's one more piece of it which is suspend-to-idle (aka "freeze").
> > > That doesn't go all the way to syscore_suspend(), but basically stops after
> > > finishing the "noirq" phase of suspending devices.  Then, it idles the CPUs
> > > and waits for interrupts that will take them out of idle.  Only some of those
> > > interrupts are wakeup events, so it only resumes when __pm_wakeup_event() or
> > > __pm_relax() is called in the process of handling the interrupts.
> > >
> > > Of course, it could be implemented differently, but that was the simplest
> > > way to do that.  It still can be changed, but I'd really like it not to have
> > > to go through all of the disabling nonboot CPUs and sysfore_suspend(), because
> > > that simply isn't necessary (and it avoids a metric ton of problems with CPU
> > > offline/online).  And of course, it has to work on x86 too.
> > 
> > Right. So one thing which would make the situation more clear is that
> > the interrupt handler needs to tell the core code about this by
> > returning something like IRQ_HANDLED_PMWAKE and the core kicks the
> > suspend-to-idle logic back to life. I'm not sure whether the extra
> > return value is actually necessary, we might even map it to
> > IRQ_HANDLED in the core as we know that we are in the suspend
> > state.
> 
> I'm not sure I'm following you here.  Do you mean that upon receiving
> IRQ_HANDLED_PMWAKE from an interrupt handler the core will know that
> this was a wakeup event and will trigger a resume from suspend-to-idle?

Correct. Whether we need the extra return code is debatable. But yes,
we want to talk to the PM/suspend/resume thing at core level instead
of letting drivers use random interfaces which happen to be exported
for one reason or the other, but definitely not for the purpose of
random driver.

> > There is no reason, why we can't flag the affected irq chips with
> > IRQCHIP_SKIP_SET_WAKE. That was introduced to handle irq controllers
> > which provide wakeup functionality but do not have this special extra
> > magic which is implemented in ->irq_set_wake, i.e. talking to some PM
> > controller directly.
> 
> That may help, but then it won't prevent wakeup IRQs from being disabled by
> suspend_device_irqs().  Do I think correctly that we can re-enable them
> in the suspend-to-idle loop, before idling the CPUs?

Yes.
 
> > 2) check_wakeup_irqs()
> > 
> >    Call it in the suspend-to-idle case and deal with the detected
> >    suspend abort from there. If we don't do that, we basically force
> >    people to hack creative workarounds into their driver, be it
> >    abusing IRQF_NO_SUSPEND or other completely brainwrecked
> >    modifications.
> > 
> >    The approach of doing:
> > 
> >     1) lazy disable
> >     2) transition into suspend
> >     3) check abort conditions
> > 
> >    is the only sane way to keep the real suspend and the
> >    suspend-to-idle stuff in line.
> 
> Well, suspend-to-idle is a loop of the type
> 
>  (1) wait for an interrupt
>  (2) iterrupt happens -> if wakeup, resume; else goto (1)
> 
> so I'm not sure how to match that with lazy disable?  We basically would need to
> do something like:
> 
>  (1) enable all wakeup interrupts
>  (2) wait for an interrupt
>  (3) interrupt happens
>  (4) disable all interrupts enabled in (1)
>  (5) if wakeup, resume (we'll resume interrupts later); else goto (1)
> 
> Is that what you mean?

More or less, yes. Whether we do the explicit enable or the implicit
leave it enabled thing is an implementation detail. We just need to
chose one.

> >      Though for the PCIe root hub thing which has a shared MSI handler
> >      !?! we really want to implement that at the device level
> >      today. Sharing a MSI interrupt is just ass backwards.
> 
> There are more reasons for doing that.  A PCIe port is really one device
> with multiple things to handle and they really need more coordination with
> each other than we have in the current code.  In my opinion we should
> just use one PCIe port driver doing all of these things together instead of
> three separate drivers handling multiple artificially cut out devices on a
> virtual bus.
> 
> Problem is, people either have no time or are too scared to do that.

Well, if we don't want to end up with a complete unmaintainable mess,
we need to find the time and the people who have enough brains to do
so.
 
> >        If there is a spurious interrupt on a shared edge type
> >        interrupt, which is crap by definition, but unfortunately
> >        reality, we never trigger the spurious detector, but we might
> >        render the device useless in the following case:
> > 
> >          disk irq shares line with wakeup button irq
> > 
> >          suspend
> > 		spurious interrupt caused by disk device
> > 
> > 	 resume from a differnt wakeup source
> > 
> > 	 Disk device interrupt is lost and therefor the disk is
> > 	 disfunctional until someone presses the wakeup button.
> 
> But the disk was supposed to be suspended, right?  So its driver should
> not expect to receive any interrupts at that point anyway.  Or am I missing
> anything?

As I said it's a conctructed scenario, but we need to deal with that
kind of malfunction in devices. Right now if the driver disabled
interrupts at the device level and calls disable_irq() the spurious
edge from the broken IP block will be recorded and the interrupt
reinjected at enable_irq() time. I'm aware of at least two devices
which rely on that behaviour.
 
> I'm not sure about the ordering, though.  It would be good to have a working
> replacement for the IRQF_NO_SUSPEND things that we'll be removing in 1, for
> example.  So since we need to do 3) IRQF_SHARED for both IRQF_NO_SUSPEND and
> wakeup, as you said, would it be practical to start with that one?

The numbering was not meant as ordering, it was just to seperate the
various issues which we need to look at.

Thanks,

	tglx
