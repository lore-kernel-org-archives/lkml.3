Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbaGaBz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 21:55:56 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54639 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751277AbaGaBzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 21:55:55 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup interrupts
Date: Thu, 31 Jul 2014 04:14:28 +0200
Message-ID: <2084079.fEC1AulnFk@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1407310137510.4997@nanos>
References: <20140724212620.GO3935@laptop> <alpine.DEB.2.10.1407302350260.4170@nanos> <alpine.DEB.2.10.1407310137510.4997@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 31, 2014 02:12:11 AM Thomas Gleixner wrote:
> On Thu, 31 Jul 2014, Thomas Gleixner wrote:
> > On Wed, 30 Jul 2014, Rafael J. Wysocki wrote:
> > Before this code changes in any way I want to see:
> > 
> >  1) a description of the existing semantics and their background

On that one, the meaning of IRQF_NO_SUSPEND is quite simple to me.

If it is set (for the first irqaction in a given irq_desc)
suspend_device_irqs() will leave that IRQ alone (that is, will not
disable it and will not mark it as IRQS_SUSPENDED).

As a result, if an interrupt for that irq_desc happens after
suspend_device_irqs(), the interrupt handlers from all of its irqactions
will be invoked.

So this basically means "ignore that IRQ" to suspend_device_irqs() and
that's its *only* meaning.

It's primary users are timers, per-CPU IRQs, ACPI SCI, via-pmu, Xen.
There also is a bunch of drivers that use it for wakeup stuff, but they
shouldn't in my opinion.

The background I'm aware of was primarily timers (we wanted to be able
to msleep() during PCI PM transitions in the noirq phases of system suspend
and resume among other things), and we want per-CPU stuff to work all the
time too.  ACPI uses it for signaling various types of events (including
battery and thermal) that need to be handled all the time.  I'm not sure
why Xen needs it exactly, but that seems to be IPI-related.

The current handling of IRQF_NO_SUSPEND has a problem vs shared interrupts
which I've tried to address by https://patchwork.kernel.org/patch/4643871/
and which is described in the changelog of that patch.  Unfortunately, some
existing users pass IRQF_SHARED along with IRQF_NO_SUSPEND which is the main
motivation for that.  Many of them use it for wakeup purposes, but for one
example (that doesn't use it for wakeup only) the ACPI SCI is shareable by
design.

To be continued.


> >  2) a description of the short comings of the existing semantics w/o
> >     considering the new fangled (hardware) use cases
> > 
> >  3) a description how to mitigate the short comings described in #2
> >     w/o breaking the world and some more and introducing hard to
> >     decode regressions
> > 
> >  4) a description why the improvements introduced by #3 are not
> >     sufficient for the new fangled (hardware) use cases
> > 
> >  5) a description how to mitigate the short comings described in #4
> >     w/o breaking the world and some more and introducing hard to
> >     decode regressions
> 
> Aside of that I want to see a coherent explanation why a shared MSI
> interrupt makes any sense at all.
> 
> 25:  1 <....> 0   PCI-MSI-edge      aerdrv, PCIe PME
>
> AFAICT, that's the primary reason why you insist to support wakeup
> sources on shared irq lines. And to be honest, it's utter bullshit.

No, this isn't the primary reason.

Here's /proc/interrupts from my MSI Wind system and, as you can see,
PCIe PME are (a) not MSI and (b) shared with some interesting things
(USB, WiFi and the GPU).

           CPU0       CPU1       
  0:      26321          0   IO-APIC-edge      timer
  1:        379          0   IO-APIC-edge      i8042
  7:          6          0   IO-APIC-edge    
  9:         59          0   IO-APIC-fasteoi   acpi
 12:       2824          0   IO-APIC-edge      i8042
 14:       9074          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:       5217          0   IO-APIC-fasteoi   PCIe PME, uhci_hcd:usb4, i915
 17:      13964          0   IO-APIC-fasteoi   PCIe PME, rtl818x_pci
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
 23:       9402          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5
 40:         61          0   PCI-MSI-edge      eth0
 41:        102          0   PCI-MSI-edge      snd_hda_intel
NMI:          0          0   Non-maskable interrupts
LOC:      18538      30831   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
IWI:          6          0   IRQ work interrupts
RTR:          0          0   APIC ICR read retries
RES:       5277       6121   Rescheduling interrupts
CAL:         92        106   Function call interrupts
TLB:        317        302   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:          5          5   Machine check polls
ERR:          6
MIS:          0


> The whole purpose of MSI is to avoid interrupt sharing, but of course
> if that particular interrupt source has two potential causes, i.e. the
> AER and the PME one and the stupid hardware does not support different
> vectors or the drivers are not able to do so, it's conveniant to make
> them shared instead of thinking about them what they really are:
> 
>  Separate interrupts on a secondary interrupt controller connected to
>  the primary (MSI) one.
> 
> That's what is in fact. Simply because you can enable/disable them at
> the same IP block quite contrary to stuff which is physically shared
> by hard wired electrical connections.

I agree with the above.

Rafael

