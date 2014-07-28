Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaG1VCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:02:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:43766 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaG1VCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:02:18 -0400
Date: Mon, 28 Jul 2014 23:02:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Borislav Petkov <bp@alien8.de>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: rc7 + tip/master suspend fun
In-Reply-To: <3594983.eCXLqCqQ8T@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1407282255120.23352@nanos>
References: <20140728175326.GA7100@pd.tnic> <3594983.eCXLqCqQ8T@vostro.rjw.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Rafael J. Wysocki wrote:
> On Monday, July 28, 2014 07:53:26 PM Borislav Petkov wrote:
> > 
> > --Nq2Wo0NMKNjxTN9z
> > Content-Type: text/plain; charset=utf-8
> > Content-Disposition: inline
> > 
> > Hi guys,
> > 
> > so during my rc7 + tip/master testing today, I've hit the second WARN
> > in remove_proc_entry, see attached pic. This happens right before I
> > suspend to disk and I can't successfully suspend because sda gets choked
> > afterwards and floods dmesg with something-has-timeout messages which I
> > can't read - whizzing by too fast.
> > 
> > And this seems consistent with the warning because sda1 is behind AHCI
> > for which the warning is for.
> > 
> > Oh, and I'm saying it is tip/master-related because plain rc7 is fine.
> > 
> > Other strange things I was able to observe in dmesg between plain rc7
> > and rc7+tip/master are that something in the interrupts allocation is
> > different now (plenty of movement in that area recently) leading to the
> > following diffs between dmesg:
> > 
> > --- 16-rc7	2014-07-28 19:43:13.000000000 +0200
> > +++ 16-rc7+	2014-07-28 11:11:24.000000000 +0200
> > 
> > @@ -137,11 +138,9 @@ IOAPIC[1]: apic_id 10, version 33, addre
> >  ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> >  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> >  ACPI: IRQ0 used by override.
> > -ACPI: IRQ2 used by override.
> >  ACPI: IRQ9 used by override.
> >  Using ACPI (MADT) for SMP configuration information
> >  smpboot: Allowing 8 CPUs, 0 hotplug CPUs
> > -nr_irqs_gsi: 72
> >  PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
> >  PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> >  PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
> > 
> > that gsi thing went away, apparently.
> > 
> > -NR_IRQS:4352 nr_irqs:1288 16
> > +NR_IRQS:4352 nr_irqs:1032 0
> > 
> > fun.

Right, that's from Jiangs ioapic rework.
 
> > And then something lead to different interrupts being assigned:
> > 
> > -pci 0000:00:00.2: irq 72 for MSI/MSI-X
> > +pci 0000:00:00.2: irq 27 for MSI/MSI-X
> > 
> > -ahci 0000:04:00.0: irq 73 for MSI/MSI-X
> > +ahci 0000:04:00.0: irq 29 for MSI/MSI-X

Borislav, can you please upload a full bootlog with "apic=verbose" on
the commandline?

Jiang, can you please have a look?
 
> > and lookie lookie, it is ahci which changes IRQ lines.
> > 
> > Suggestions and ideas how to narrow down are appreciated.
> 
> Please try to revert this patch from Peter:
> 
> http://marc.info/?l=linux-kernel&m=140620918218199

How is that related to a leaked interrupt handler? That patch gives a
splat at request_irq() time. Completely unrelated to this problem.

Thanks,

	tglx
