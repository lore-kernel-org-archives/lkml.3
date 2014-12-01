Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaLANyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:54:18 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:41390
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465AbaLANyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:54:17 -0500
From: Tim Sander <tim@krieglstein.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>
Subject: Re: [PATCH 3.18-rc3 v9 5/5] arm: smp: Handle ipi_cpu_backtrace() using FIQ (if available)
Date: Mon, 01 Dec 2014 14:54:10 +0100
Message-ID: <5910085.Y47hdorDAO@dabox>
Organization: Sander and Lightning
User-Agent: KMail/4.14.2 (Linux/3.16.3; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141201103832.GX3836@n2100.arm.linux.org.uk>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1633306.naE1qIcAOt@dabox> <20141201103832.GX3836@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell

Am Montag, 1. Dezember 2014, 10:38:32 schrieb Russell King - ARM Linux:
> On Mon, Dec 01, 2014 at 11:32:00AM +0100, Tim Sander wrote:
> > Hi Russel, Daniel
> > 
> > Am Freitag, 28. November 2014, 10:08:28 schrieb Russell King - ARM Linux:
> > > The two things are mutually exclusive.  You can either have FIQ being
> > > used
> > > for debug purposes, where we decode the FIQ reason and call some
> > > function
> > > (which means that we will only service one FIQ at a time) or you can use
> > > it in exclusive mode (provided by fiq.c) where your handler has sole
> > > usage
> > > of the vector, and benefits from fast and immediate servicing of the
> > > event.
> > 
> > As far as i am aware, die CONFIG_FIQ symbol is not pulled by all ARM
> > platforms. Since there are ARM platforms which don't use this symbol but
> > the hardware is fully capable of handling FIQ requests i would expect,
> > that adding CONFIG_FIQ to a plattform, that this platform honors the
> > set_fiq_handler functionality.
> 
> That whole paragraph doesn't make much sense to me.
> 
> Look, in my mind it is very simple.  If you are using CONFIG_FIQ on a
> SMP platform, your life will be very difficult.  The FIQ code enabled
> by that symbol is not designed to be used on SMP systems, *period*.
Well the only extra thing you had to do is set up the FIQ registers on every 
cpu, but i would not call that very difficult. Other than that i am not aware of 
any problems that are not also present on a uniprocessor system. So i have a 
hard time following your reasoning why SMP is different from UP in regard to 
the CONFIG_FIQ.

> If you decide to enable CONFIG_FIQ, and you use that code on a SMP
> platform, I'm going to say right now so it's totally clear: if you
> encounter a problem, I don't want to know about it.  The code is not
> designed for use on that situation.
Even with using the FIQ on a Linux SMP system you have not heard from me 
before, as i knew that this is not your problem (and that is not to say that 
there where none!). The only interface Linux has been making available is 
set_fiq_handler. So it was clear that the FIQ is its own domain otherwise 
untouched by the kernel. Now the line gets blurried with the linux kernel 
moving to use the FIQ. And with the descicions forthcoming its not only 
grabbing land it also claims a previous public path for its own. So it doesn't 
help that its planting some flowers along the way. So please be nice to the 
natural inhabitants...

And i really don't get it, that neither ARM nor the kernel community sees fast 
interrupts as a worthwhile usecase. Unfortunatly the interrupt latencies with 
Linux are at least a order of magnitude higher than the pure hardware even 
with longer pipelines can deliver. 

> Therefore, as far as I'm concerned, the two facilities are mututally
> exclusive.
Well can't have the cake and eat it too.

> I had thought about whether the IPI FIQ should be disabled when a
> replacement FIQ handler is installed, I deem it not to be a use case
> that the mainline kernel needs to be concerned about.
That would be nice.

> > Yes, but if the FIQ handler is also used for IPI, set_fiq_handler gets IPI
> > interrupts (with the patch starting this thread)? So i think that the
> > patch
> > needs to look like:
> > --- a/arch/arm/kernel/traps.c
> > +++ b/arch/arm/kernel/traps.c
> > @@ -483,6 +483,9 @@ asmlinkage void __exception_irq_entry
> > handle_fiq_as_nmi(struct pt_regs *regs)
> > +#ifndef CONFIG_FIQ
> > 
> >  #ifdef CONFIG_ARM_GIC
> >  
> >         gic_handle_fiq_ipi();
> >  
> >  #endif
> > 
> > +#endif
> 
> No.  With a single zImage kernel, you could very well have SMP and FIQ
> both enabled, but have a non-SMP platform using FIQ, but also support
> SMP platforms as well.  Your change prevents that happening.
Ah, well i have to get used to this "new" devicetree thingy, where one size 
fits all...

Still if you boot a single process system which has FIQ available and has a 
GIC with such a kernel, then you also reprogramm the IPI's as FIQs. But i 
guess thats not a problem as Linux does not self IPI the kernel as other os'es
do?

Best regards
Tim
