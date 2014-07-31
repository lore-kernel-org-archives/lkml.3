Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaGaWQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:16:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:37774 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaGaWQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:16:34 -0400
Date: Fri, 1 Aug 2014 00:16:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup
 interrupts
In-Reply-To: <2140085.bSS0bVjyxJ@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1407312103190.4997@nanos>
References: <20140724212620.GO3935@laptop> <2084079.fEC1AulnFk@vostro.rjw.lan> <alpine.DEB.2.10.1407311230420.4997@nanos> <2140085.bSS0bVjyxJ@vostro.rjw.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Rafael J. Wysocki wrote:
> On Thursday, July 31, 2014 12:44:24 PM Thomas Gleixner wrote:
> > What's this PCIe PME handler doing? Is it required functionality for
> > the suspend/resume path or is it a wakeup/abort mechanism.
> 
> It is a wakeup/abort mechanism.

So why is it using IRQF_NO_SUSPEND in the first place? Just because x86
does not have irq wake implemented or flagged it's irq chips with
IRQCHIP_SKIP_SET_WAKE. Right, so instead of thinking about a proper
solution driver folks just slap the next available thing on it w/o
thinking about the consequences. But, thats partly our own fault due
to lack of proper documentation.
 
> And before we enter the wakeup handling slippery slope, let me make a note
> that this problem is bothering me quite a bit at the moment.  In my opinion
> we need to address it somehow regardless of the wakeup issues and I'm not sure
> if failing __setup_irq() when there's a mismatch (that is, there are existing
> actions for the given irq_desc and their IRQF_NO_SUSPEND settings are not
> consistent with the new one) is the right way to do that, because it may make
> things behave a bit randomly (it will always fail the second guy, but that need
> not be the one who's requested IRQF_NO_SUSPEND and it depends on the ordering
> between them).

I totally agree that we want to fix it and I'm going to help. Though I
really wanted to have a clear picture of the stuff before making
decisions.
 
> I had a couple of ideas, but none of them was particularly clean.  Ideally,
> IRQF_NO_SUSPEND should always be requested without IRQF_SHARED, but I'm
> afraid that we can't really do that for the ACPI SCI, because that may
> cause problems to happen on some older systems where that interrupt is
> actually shared.  On all systems I have immediate access to it isn't shared,
> but I remember seeing some where it was.  On those systems the ACPI SCI itself
> would not be affected, because it is requested quite early during system init,
> but the other guys wanting to share the line with it would take a hit.
> 
> One thing I was thinking about was to return an error from suspend_device_irqs()
> if there was a mismatch between IRQF_NO_SUSPEND settings for different irqactions
> in the same irq_desc.  That would make system suspend fail on systems where it
> is potentially unsafe, but at least any other functionality would not be affected.
>

That's one possible solution. See below.

> > So many of them use it for wakeup purposes. Why so and how is that
> > supposed to work?
> 
> Quite frankly, I'm not sure why they use it.  These are mostly drivers I'm not
> familiar with on platforms I'm not familiar with.  My guess is that the lazy
> disable mechanism is not sufficient for them for some reason.

Looking at a few of them I fear the reason is that the developer did
not understand the wakeup mechanism at all. Again that's probably our
fault, because the whole business including the irq part lacks proper
in depth documentation.

> > The mechanism for wakeup sources is:
> > 
> >     1) Lazy disable the interrupt
> > 
> >     2) Do the transition into suspend with interrupts enabled
> > 
> >     3) Check whether one of the wakeup sources has triggered. If yes,
> >        abort. Otherwise suspend.
> > 
> > The ones marked IRQF_NO_SUSPEND are not part of the above scheme,
> > because they are not checked. So they use different mechanisms to
> > abort the suspend?
> 
> Well, if you look at the tegra_kbc driver, for example, it uses both
> enable_irq_wake() and IRQF_NO_SUSPEND.  Why it does that, I don't know.

That doesn't make sense at all.
 
> Other ones seem to be using pm_wakeup_event(), but that will only abort
> suspend when it is enabled upfront (it need not be).  Moreover, it wasn't
> intended to be used that way.

Right. We should kill that before more people copy it blindly.
 
> It generally looks like things are used not as intended in the wakeup
> area, sadly.  Perhaps that's my fault, because I wasn't looking carefully
> enough every time, but I wasn't directly involved in any of them IIRC.
> 
> I guess that's an opportunity to clean that up ...

Agreed. I'm not frightened to do a tree wide sweep. Seems to become a
habit :)
 
> And now there's one more piece of it which is suspend-to-idle (aka "freeze").
> That doesn't go all the way to syscore_suspend(), but basically stops after
> finishing the "noirq" phase of suspending devices.  Then, it idles the CPUs
> and waits for interrupts that will take them out of idle.  Only some of those
> interrupts are wakeup events, so it only resumes when __pm_wakeup_event() or
> __pm_relax() is called in the process of handling the interrupts.
>
> Of course, it could be implemented differently, but that was the simplest
> way to do that.  It still can be changed, but I'd really like it not to have
> to go through all of the disabling nonboot CPUs and sysfore_suspend(), because
> that simply isn't necessary (and it avoids a metric ton of problems with CPU
> offline/online).  And of course, it has to work on x86 too.

Right. So one thing which would make the situation more clear is that
the interrupt handler needs to tell the core code about this by
returning something like IRQ_HANDLED_PMWAKE and the core kicks the
suspend-to-idle logic back to life. I'm not sure whether the extra
return value is actually necessary, we might even map it to
IRQ_HANDLED in the core as we know that we are in the suspend
state.
 
> On x86, however, enable_irq_wake() always returns -ENXIO and nothing happens,
> because the chip doesn't have an ->irq_set_wake callback and doesn't flag
> itself as IRQCHIP_SKIP_SET_WAKE, so even if we found a way to do something
> equivalent to check_wakeup_irqs() for suspend-to-idle, it still wouldn't work
> on x86 for that reason.

There is no reason, why we can't flag the affected irq chips with
IRQCHIP_SKIP_SET_WAKE. That was introduced to handle irq controllers
which provide wakeup functionality but do not have this special extra
magic which is implemented in ->irq_set_wake, i.e. talking to some PM
controller directly.

> Also, I wouldn't like to make suspend-to-idle more special than it really has
> to be, so it would be ideal if it could use as much of the same mechanics as
> regular platform-supported suspend as reasonably possible.  The handling of
> wakeup events is crucial here, because it's needed to make suspend-to-idle
> really work and I'd like to make it as consistent as possible with the
> "regular" suspend.  Now, that can be done in a couple of ways and some of
> them may be better than others for reasons that aren't known to me.

Sure. From the recent discussion I can see the following things we
need to address:

1) IRQF_NO_SUSPEND:

    - Investigate the (ab)use
    - Fix the offending call sites 
    - Provide proper documentation when and why it is sane to use


2) check_wakeup_irqs()

   Call it in the suspend-to-idle case and deal with the detected
   suspend abort from there. If we don't do that, we basically force
   people to hack creative workarounds into their driver, be it
   abusing IRQF_NO_SUSPEND or other completely brainwrecked
   modifications.

   The approach of doing:

    1) lazy disable
    2) transition into suspend
    3) check abort conditions

   is the only sane way to keep the real suspend and the
   suspend-to-idle stuff in line.

   Any other approach will create major headache, simply because by
   avoiding the conditional call in the PM core you force the driver
   developers to work around it and have conditional handling for that
   case at the driver level without having proper information about
   the actual suspend target, i.e. idle vs. real. I can predict the
   mess caused by that halfways precisely without using a crystal
   ball: With the expected popularity of the suspend-to-idle approach
   this is going to approach infinite level rapidly.

   Seriously we cannot tell people to use A for real suspend and B for
   suspend-to-idle. It must be the same mechanism. If that costs the
   price of some core code restructuring, we better pay that than
   dealing with the fallout of the other variant.


3) IRQF_SHARED

   - The ideal solution for this would be to provide seperate virtual
     irq numbers for each device which sits on a shared interrupt line
     and have a pseudo interrupt chip handling the devices and the
     real interrupt line providing the "demux" function.

     That would make life way simpler as we'd always deal with a
     single interrupt number per device. So the whole chained action
     pain would simply go away and the wake/no suspend functionality
     would not have to care at all about this whole shared interrupt
     trainwreck. You'd get per device interrupt stats for free as a
     bonus.

     Unfortunately we can't pull that off w/o major surgery to a
     gazillion of device drivers, but I'm tempted to provide the
     infrastructure for this sooner than later.

     Though for the PCIe root hub thing which has a shared MSI handler
     !?! we really want to implement that at the device level
     today. Sharing a MSI interrupt is just ass backwards.


   - So we need to bite the bullet and handle the action chain as it
     is.

     And we need to support it for the IRQF_NO_SUSPEND and the wake
     functionality.

     For that we have two choices:

     1) Use the separate pointer in the irq desc which stores the
        actions which are either not flagged IRQF_NO_SUSPEND or not
        declared as actual wakeup sources.

     2) Have a separate handler function pointer in struct irqaction,
     	which is used to store the actual device handler and have a
     	core stub handler as the primary handler.

	That stub handler would basically do:

	if (!irqs_suspended)
	   return action->real_handler();
	return IRQ_NONE;

	The switch over of the handler can be done at
	setup/request_irq time when a shared non consistent flagged
	handler is detected or at enable_wake() time.

     There is an advantage to #2:

        The suspend/resume path does not care about any of this. It
	only penalizes the few shared handlers which are affected by
	this nonsense with the extra conditional in the hot handling
	path. Bad luck for the device which has to share the interrupt
	line: complain to the morons who still think that shared
	interrupt lines are a brilliant idea.

     Now for the enable/disable_wake() stuff we really need to have
     the mechanism which has the extra *dev_id argument to identify
     the proper handler. The existing interface should simply hand in
     NULL and if it's used on a shared interrupt line it should yell
     loudly and maybe even prevent suspend. Combined with the above we
     burden all the nonsense of handling shared interrupts in that
     context to the slow path.

     Of course we need handling for the stupid case where the non
     wakeup device decides to fire interrupts on the shared line.

     We certainly need a detection mechanism for this, but your
     current proposal of accelerating the spurious detection has a
     serious downside:

       If there is a spurious interrupt on a shared edge type
       interrupt, which is crap by definition, but unfortunately
       reality, we never trigger the spurious detector, but we might
       render the device useless in the following case:

         disk irq shares line with wakeup button irq

         suspend
		spurious interrupt caused by disk device

	 resume from a differnt wakeup source

	 Disk device interrupt is lost and therefor the disk is
	 disfunctional until someone presses the wakeup button.

       Admittedly a constructed scenario, but we had our share of
       pleasure to deal with lost edge type interrupts in the past and
       I can assure you it's not fun to debug.

       So we rather error out on the safe side and disable the
       interrupt line right away, mark it pending and resume or abort
       suspend and tell why. If we don't do that upfront we'll add
       that feature after a painful debug session which starts with
       this information: Sporadically after suspend I have to hard
       reset the machine by pressing the power button for 10 seconds
       or removing the battery....

       Note: This only applies to shared interrupt lines. We still
       have a sane spurious handling for proper designed systems which
       avoid the shared brainfarts.


4) Move the handling of resume/abort to the core

   We really want either an explicit return value from the device
   interrupt handler which indicates that we should resume or abort
   the suspend transition or handle IRQ_HANDLED automatically at the
   core level in case of suspend.

   If you let drivers do that, they will create a gazillion of
   solutions to abort/resume which will kill your ability to change
   any of the PM core internal mechanisms w/o doing a tree wide
   cleanup. Let's do it now before we get into the unavoidable
   exponential copy and paste phase.


5) Documentation
   
   Add a metric ton of it!

Thoughts?

Thanks,

	tglx
