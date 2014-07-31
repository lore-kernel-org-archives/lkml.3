Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbaGaKoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:44:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:60670 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbaGaKo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:44:28 -0400
Date: Thu, 31 Jul 2014 12:44:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup
 interrupts
In-Reply-To: <2084079.fEC1AulnFk@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1407311230420.4997@nanos>
References: <20140724212620.GO3935@laptop> <alpine.DEB.2.10.1407302350260.4170@nanos> <alpine.DEB.2.10.1407310137510.4997@nanos> <2084079.fEC1AulnFk@vostro.rjw.lan>
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

> On Thursday, July 31, 2014 02:12:11 AM Thomas Gleixner wrote:
> > On Thu, 31 Jul 2014, Thomas Gleixner wrote:
> > > On Wed, 30 Jul 2014, Rafael J. Wysocki wrote:
> > > Before this code changes in any way I want to see:
> > > 
> > >  1) a description of the existing semantics and their background
> 
> On that one, the meaning of IRQF_NO_SUSPEND is quite simple to me.
> 
> If it is set (for the first irqaction in a given irq_desc)
> suspend_device_irqs() will leave that IRQ alone (that is, will not
> disable it and will not mark it as IRQS_SUSPENDED).
> 
> As a result, if an interrupt for that irq_desc happens after
> suspend_device_irqs(), the interrupt handlers from all of its irqactions
> will be invoked.
> 
> So this basically means "ignore that IRQ" to suspend_device_irqs() and
> that's its *only* meaning.
> 
> It's primary users are timers, per-CPU IRQs, ACPI SCI, via-pmu, Xen.
> There also is a bunch of drivers that use it for wakeup stuff, but they
> shouldn't in my opinion.

Indeed.

> The background I'm aware of was primarily timers (we wanted to be able
> to msleep() during PCI PM transitions in the noirq phases of system suspend
> and resume among other things), and we want per-CPU stuff to work all the
> time too.  ACPI uses it for signaling various types of events (including
> battery and thermal) that need to be handled all the time.  I'm not sure
> why Xen needs it exactly, but that seems to be IPI-related.

So none of these interrupts is used to abort suspend or wakeup. They
are kept functional because they are required for the suspend/resume
transitions itself.

What's this PCIe PME handler doing? Is it required functionality for
the suspend/resume path or is it a wakeup/abort mechanism.

> The current handling of IRQF_NO_SUSPEND has a problem vs shared interrupts
> which I've tried to address by https://patchwork.kernel.org/patch/4643871/
> and which is described in the changelog of that patch.  Unfortunately, some
> existing users pass IRQF_SHARED along with IRQF_NO_SUSPEND which is the main
> motivation for that.  Many of them use it for wakeup purposes, but for one
> example (that doesn't use it for wakeup only) the ACPI SCI is shareable by
> design.

So many of them use it for wakeup purposes. Why so and how is that
supposed to work?

The mechanism for wakeup sources is:

    1) Lazy disable the interrupt

    2) Do the transition into suspend with interrupts enabled

    3) Check whether one of the wakeup sources has triggered. If yes,
       abort. Otherwise suspend.

The ones marked IRQF_NO_SUSPEND are not part of the above scheme,
because they are not checked. So they use different mechanisms to
abort the suspend?

> > Aside of that I want to see a coherent explanation why a shared MSI
> > interrupt makes any sense at all.
> > 
> > 25:  1 <....> 0   PCI-MSI-edge      aerdrv, PCIe PME
> >
> > AFAICT, that's the primary reason why you insist to support wakeup
> > sources on shared irq lines. And to be honest, it's utter bullshit.
> 
> No, this isn't the primary reason.
> 
> Here's /proc/interrupts from my MSI Wind system and, as you can see,
> PCIe PME are (a) not MSI and (b) shared with some interesting things
> (USB, WiFi and the GPU).

>  16:       5217          0   IO-APIC-fasteoi   PCIe PME, uhci_hcd:usb4, i915
>  17:      13964          0   IO-APIC-fasteoi   PCIe PME, rtl818x_pci

So the obvious question is: WHY are they not using MSI?

Just because MSI fucked up the MSI configuration of the device or is
there any sane explanation for it?
 
Thanks,

	tglx
