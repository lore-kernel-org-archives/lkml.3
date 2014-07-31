Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaGaSR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 14:17:56 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60146 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751350AbaGaSRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 14:17:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup interrupts
Date: Thu, 31 Jul 2014 20:36:19 +0200
Message-ID: <2140085.bSS0bVjyxJ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1407311230420.4997@nanos>
References: <20140724212620.GO3935@laptop> <2084079.fEC1AulnFk@vostro.rjw.lan> <alpine.DEB.2.10.1407311230420.4997@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 31, 2014 12:44:24 PM Thomas Gleixner wrote:
> On Thu, 31 Jul 2014, Rafael J. Wysocki wrote:
> 
> > On Thursday, July 31, 2014 02:12:11 AM Thomas Gleixner wrote:
> > > On Thu, 31 Jul 2014, Thomas Gleixner wrote:
> > > > On Wed, 30 Jul 2014, Rafael J. Wysocki wrote:
> > > > Before this code changes in any way I want to see:
> > > > 
> > > >  1) a description of the existing semantics and their background
> > 
> > On that one, the meaning of IRQF_NO_SUSPEND is quite simple to me.
> > 
> > If it is set (for the first irqaction in a given irq_desc)
> > suspend_device_irqs() will leave that IRQ alone (that is, will not
> > disable it and will not mark it as IRQS_SUSPENDED).
> > 
> > As a result, if an interrupt for that irq_desc happens after
> > suspend_device_irqs(), the interrupt handlers from all of its irqactions
> > will be invoked.
> > 
> > So this basically means "ignore that IRQ" to suspend_device_irqs() and
> > that's its *only* meaning.
> > 
> > It's primary users are timers, per-CPU IRQs, ACPI SCI, via-pmu, Xen.
> > There also is a bunch of drivers that use it for wakeup stuff, but they
> > shouldn't in my opinion.
> 
> Indeed.
> 
> > The background I'm aware of was primarily timers (we wanted to be able
> > to msleep() during PCI PM transitions in the noirq phases of system suspend
> > and resume among other things), and we want per-CPU stuff to work all the
> > time too.  ACPI uses it for signaling various types of events (including
> > battery and thermal) that need to be handled all the time.  I'm not sure
> > why Xen needs it exactly, but that seems to be IPI-related.
> 
> So none of these interrupts is used to abort suspend or wakeup.

ACPI can do that too, but it's just one of its functions.

> They are kept functional because they are required for the suspend/resume
> transitions itself.

They are for things that need to work throughout system suspend/resume and
which are not wakeup.

> What's this PCIe PME handler doing? Is it required functionality for
> the suspend/resume path or is it a wakeup/abort mechanism.

It is a wakeup/abort mechanism.

> > The current handling of IRQF_NO_SUSPEND has a problem vs shared interrupts
> > which I've tried to address by https://patchwork.kernel.org/patch/4643871/
> > and which is described in the changelog of that patch.

And before we enter the wakeup handling slippery slope, let me make a note
that this problem is bothering me quite a bit at the moment.  In my opinion
we need to address it somehow regardless of the wakeup issues and I'm not sure
if failing __setup_irq() when there's a mismatch (that is, there are existing
actions for the given irq_desc and their IRQF_NO_SUSPEND settings are not
consistent with the new one) is the right way to do that, because it may make
things behave a bit randomly (it will always fail the second guy, but that need
not be the one who's requested IRQF_NO_SUSPEND and it depends on the ordering
between them).

I had a couple of ideas, but none of them was particularly clean.  Ideally,
IRQF_NO_SUSPEND should always be requested without IRQF_SHARED, but I'm
afraid that we can't really do that for the ACPI SCI, because that may
cause problems to happen on some older systems where that interrupt is
actually shared.  On all systems I have immediate access to it isn't shared,
but I remember seeing some where it was.  On those systems the ACPI SCI itself
would not be affected, because it is requested quite early during system init,
but the other guys wanting to share the line with it would take a hit.

One thing I was thinking about was to return an error from suspend_device_irqs()
if there was a mismatch between IRQF_NO_SUSPEND settings for different irqactions
in the same irq_desc.  That would make system suspend fail on systems where it
is potentially unsafe, but at least any other functionality would not be affected.

> > Unfortunately, some
> > existing users pass IRQF_SHARED along with IRQF_NO_SUSPEND which is the main
> > motivation for that.  Many of them use it for wakeup purposes, but for one
> > example (that doesn't use it for wakeup only) the ACPI SCI is shareable by
> > design.
> 
> So many of them use it for wakeup purposes. Why so and how is that
> supposed to work?

Quite frankly, I'm not sure why they use it.  These are mostly drivers I'm not
familiar with on platforms I'm not familiar with.  My guess is that the lazy
disable mechanism is not sufficient for them for some reason.

> The mechanism for wakeup sources is:
> 
>     1) Lazy disable the interrupt
> 
>     2) Do the transition into suspend with interrupts enabled
> 
>     3) Check whether one of the wakeup sources has triggered. If yes,
>        abort. Otherwise suspend.
> 
> The ones marked IRQF_NO_SUSPEND are not part of the above scheme,
> because they are not checked. So they use different mechanisms to
> abort the suspend?

Well, if you look at the tegra_kbc driver, for example, it uses both
enable_irq_wake() and IRQF_NO_SUSPEND.  Why it does that, I don't know.

Other ones seem to be using pm_wakeup_event(), but that will only abort
suspend when it is enabled upfront (it need not be).  Moreover, it wasn't
intended to be used that way.

It generally looks like things are used not as intended in the wakeup
area, sadly.  Perhaps that's my fault, because I wasn't looking carefully
enough every time, but I wasn't directly involved in any of them IIRC.

I guess that's an opportunity to clean that up ...

And now there's one more piece of it which is suspend-to-idle (aka "freeze").
That doesn't go all the way to syscore_suspend(), but basically stops after
finishing the "noirq" phase of suspending devices.  Then, it idles the CPUs
and waits for interrupts that will take them out of idle.  Only some of those
interrupts are wakeup events, so it only resumes when __pm_wakeup_event() or
__pm_relax() is called in the process of handling the interrupts.

Of course, it could be implemented differently, but that was the simplest
way to do that.  It still can be changed, but I'd really like it not to have
to go through all of the disabling nonboot CPUs and sysfore_suspend(), because
that simply isn't necessary (and it avoids a metric ton of problems with CPU
offline/online).  And of course, it has to work on x86 too.

On x86, however, enable_irq_wake() always returns -ENXIO and nothing happens,
because the chip doesn't have an ->irq_set_wake callback and doesn't flag
itself as IRQCHIP_SKIP_SET_WAKE, so even if we found a way to do something
equivalent to check_wakeup_irqs() for suspend-to-idle, it still wouldn't work
on x86 for that reason.

Also, I wouldn't like to make suspend-to-idle more special than it really has
to be, so it would be ideal if it could use as much of the same mechanics as
regular platform-supported suspend as reasonably possible.  The handling of
wakeup events is crucial here, because it's needed to make suspend-to-idle
really work and I'd like to make it as consistent as possible with the
"regular" suspend.  Now, that can be done in a couple of ways and some of
them may be better than others for reasons that aren't known to me.

My current case at hand is to make PCIe MSI wake systems up from suspend-to-idle
(it actually works for the "regular" suspend most of the time), but that's part
of a bigger picture, of course.

> > > Aside of that I want to see a coherent explanation why a shared MSI
> > > interrupt makes any sense at all.
> > > 
> > > 25:  1 <....> 0   PCI-MSI-edge      aerdrv, PCIe PME
> > >
> > > AFAICT, that's the primary reason why you insist to support wakeup
> > > sources on shared irq lines. And to be honest, it's utter bullshit.
> > 
> > No, this isn't the primary reason.
> > 
> > Here's /proc/interrupts from my MSI Wind system and, as you can see,
> > PCIe PME are (a) not MSI and (b) shared with some interesting things
> > (USB, WiFi and the GPU).
> 
> >  16:       5217          0   IO-APIC-fasteoi   PCIe PME, uhci_hcd:usb4, i915
> >  17:      13964          0   IO-APIC-fasteoi   PCIe PME, rtl818x_pci
> 
> So the obvious question is: WHY are they not using MSI?
> 
> Just because MSI fucked up the MSI configuration of the device or is
> there any sane explanation for it?

It looks like they don't use MSI on that machine at all, so perhaps the chipset
is not capable of that or similar.  I'm not sure why it matters, though.  The
system shipped like that and with Linux on it, so we should be able to
handle it regardless.

Rafael

