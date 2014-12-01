Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaLAPC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:02:56 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:42150 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbaLAPCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:02:54 -0500
Date: Mon, 1 Dec 2014 15:02:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tim Sander <tim@krieglstein.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>
Subject: Re: [PATCH 3.18-rc3 v9 5/5] arm: smp: Handle ipi_cpu_backtrace()
 using FIQ (if available)
Message-ID: <20141201150240.GF3836@n2100.arm.linux.org.uk>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
 <1633306.naE1qIcAOt@dabox>
 <20141201103832.GX3836@n2100.arm.linux.org.uk>
 <5910085.Y47hdorDAO@dabox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5910085.Y47hdorDAO@dabox>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 02:54:10PM +0100, Tim Sander wrote:
> Hi Russell
> 
> Am Montag, 1. Dezember 2014, 10:38:32 schrieb Russell King - ARM Linux:
> > That whole paragraph doesn't make much sense to me.
> > 
> > Look, in my mind it is very simple.  If you are using CONFIG_FIQ on a
> > SMP platform, your life will be very difficult.  The FIQ code enabled
> > by that symbol is not designed to be used on SMP systems, *period*.
>
> Well the only extra thing you had to do is set up the FIQ registers on every 
> cpu, but i would not call that very difficult. Other than that i am not
> aware of any problems that are not also present on a uniprocessor system.
> So i have a hard time following your reasoning why SMP is different from
> UP in regard to the CONFIG_FIQ.

One of the things which FIQ handlers can do is they have their own private
registers which they can modify on each invocation of the FIQ handler -
for example, as a software DMA pointer.

Each CPU has its own private set of FIQ registers, so merely copying the
registers to each CPU will only set their initial state: updates by one
CPU to the register set will not be seen by a different CPU.

> > If you decide to enable CONFIG_FIQ, and you use that code on a SMP
> > platform, I'm going to say right now so it's totally clear: if you
> > encounter a problem, I don't want to know about it.  The code is not
> > designed for use on that situation.
> Even with using the FIQ on a Linux SMP system you have not heard from me 
> before, as i knew that this is not your problem (and that is not to say that 
> there where none!). The only interface Linux has been making available is 
> set_fiq_handler. So it was clear that the FIQ is its own domain otherwise 
> untouched by the kernel.

Correct, because FIQs have very little use in Linux.  They have been used
in the past to implement:
- software DMA to floppy disk controllers (see arch/arm/lib/floppydma.S)
- audio DMA (arch/arm/mach-imx/ssi-fiq.S)
- s2c24xx SPI DMA (drivers/spi/spi-s3c24xx-fiq.S)
- Keyboard (yes, how that qualifies for FIQ I don't know
  (arch/arm/mach-omap1/ams-delta-fiq-handler.S)

The first three do exactly what I describe above, and none of these users
are SMP platforms.  Hence, the FIQ code which we currently have does exactly
what we need it to for the platforms we have.

Now, you're talking about using this in a SMP context - that's a totally
new use for this code which - as I have said several times now - is not
really something that this code is intended to support.

> And i really don't get it, that neither ARM nor the kernel community
> sees fast interrupts as a worthwhile usecase. Unfortunatly the interrupt
> latencies with Linux are at least a order of magnitude higher than the
> pure hardware even with longer pipelines can deliver. 

First point: fast interrupts won't be fast if you load them up with all
the interrupt demux and locking that normal interrupts have; if you
start doing that, then you end up having to make /all/ IRQ-safe locks
in the kernel not only disable normal interrupts, but also disable the
FIQs as well.

At that point, FIQs are no longer "fast" - they will be subject to
exactly the same latencies as normal interrupts.

Second point: we have embraced FIQs where it is appropriate to do so,
but within the restrictions that FIQs present - that is, to keep them
fast, we have to avoid the problem in the first point above, which
means normal C code called from FIQs /can't/ take any kernel lock what
so ever without potentially causing a deadlock.

Even if you think you can (why would UP have locks if it's not SMP)
debugging facilities such as the lock validator will bite you if you
try taking a lock in FIQ context which was already taken in the parent
context.

Third point: FIQs are not available on a lot of ARM platforms.  Hardware
which routes interrupts to FIQs is very limited, normally it's only a
few interrupts which appear there.  Moreover, with more modern platforms
where the kernel runs in the non-secure side, FIQs are /totally/ and
/completely/ unavailable there - FIQs are only available for the secure
monitor to use.

> > No.  With a single zImage kernel, you could very well have SMP and FIQ
> > both enabled, but have a non-SMP platform using FIQ, but also support
> > SMP platforms as well.  Your change prevents that happening.
> 
> Ah, well i have to get used to this "new" devicetree thingy, where one size 
> fits all...

No, you're conflating different things there.  It doesn't have much
to do with DT vs non-DT, because this same problem existed before DT
came along, since there were platforms which could be both UP and SMP.

> Still if you boot a single process system which has FIQ available and has a 
> GIC with such a kernel, then you also reprogramm the IPI's as FIQs. But i 
> guess thats not a problem as Linux does not self IPI the kernel as other os'es
> do?

I'm really sorry, but your above paragraph doesn't make much sense to me.
"single process system" - if there's only one process, there's no point
having a scheduler (it has nothing to schedule) and so I guess you're
not talking about Linux there.

Or do you mean "single processor system" (in other words, uniprocessor or
UP).  In that case, the kernel doesn't use IPIs, because, by definition,
there's no other processors for it to signal to.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
