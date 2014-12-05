Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaLEQAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:00:25 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:35177
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903AbaLEQAX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:00:23 -0500
From: Tim Sander <tim@krieglstein.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>
Subject: Re: [PATCH 3.18-rc3 v9 5/5] arm: smp: Handle ipi_cpu_backtrace() using FIQ (if available)
Date: Fri, 05 Dec 2014 17:00:17 +0100
Message-ID: <10828625.vpMWUNiiRO@dabox>
Organization: Sander and Lightning
User-Agent: KMail/4.14.2 (Linux/3.17.4; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141201150240.GF3836@n2100.arm.linux.org.uk>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <5910085.Y47hdorDAO@dabox> <20141201150240.GF3836@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell, Thomas

I have some replys below, but i just post my most important question up here, 
which is my current takeaway from this discussion:
Would patches be accepted which -as Daniel Thompson pointed out- dynamically 
switch the FIQ IPI's off when set_fiq_handler is called (given that the FIQ IPI 
patches are to be merged proper beforhand).

Am Montag, 1. Dezember 2014, 15:02:40 schrieb Russell King - ARM Linux:
> On Mon, Dec 01, 2014 at 02:54:10PM +0100, Tim Sander wrote:
> > Hi Russell
> > 
> > Am Montag, 1. Dezember 2014, 10:38:32 schrieb Russell King - ARM Linux:
> > > That whole paragraph doesn't make much sense to me.
> > > 
> > > Look, in my mind it is very simple.  If you are using CONFIG_FIQ on a
> > > SMP platform, your life will be very difficult.  The FIQ code enabled
> > > by that symbol is not designed to be used on SMP systems, *period*.
> > 
> > Well the only extra thing you had to do is set up the FIQ registers on
> > every cpu, but i would not call that very difficult. Other than that i am
> > not aware of any problems that are not also present on a uniprocessor
> > system. So i have a hard time following your reasoning why SMP is
> > different from UP in regard to the CONFIG_FIQ.
> 
> One of the things which FIQ handlers can do is they have their own private
> registers which they can modify on each invocation of the FIQ handler -
> for example, as a software DMA pointer.
> 
> Each CPU has its own private set of FIQ registers, so merely copying the
> registers to each CPU will only set their initial state: updates by one
> CPU to the register set will not be seen by a different CPU.
> 
> > > If you decide to enable CONFIG_FIQ, and you use that code on a SMP
> > > platform, I'm going to say right now so it's totally clear: if you
> > > encounter a problem, I don't want to know about it.  The code is not
> > > designed for use on that situation.
> > 
> > Even with using the FIQ on a Linux SMP system you have not heard from me
> > before, as i knew that this is not your problem (and that is not to say
> > that there where none!). The only interface Linux has been making
> > available is set_fiq_handler. So it was clear that the FIQ is its own
> > domain otherwise untouched by the kernel.
> 
> Correct, because FIQs have very little use in Linux.  They have been used
> in the past to implement:
> - software DMA to floppy disk controllers (see arch/arm/lib/floppydma.S)
> - audio DMA (arch/arm/mach-imx/ssi-fiq.S)
> - s2c24xx SPI DMA (drivers/spi/spi-s3c24xx-fiq.S)
> - Keyboard (yes, how that qualifies for FIQ I don't know
>   (arch/arm/mach-omap1/ams-delta-fiq-handler.S)
> 
> The first three do exactly what I describe above, and none of these users
> are SMP platforms.  Hence, the FIQ code which we currently have does exactly
> what we need it to for the platforms we have.
> 
> Now, you're talking about using this in a SMP context - that's a totally
> new use for this code which - as I have said several times now - is not
> really something that this code is intended to support.
Yes but as i said the only additional problem is the seperate registers for 
each core. Given the quirks the current GIC version 1 this is really  a minor 
problem:
https://lkml.org/lkml/2014/7/15/550


> > And i really don't get it, that neither ARM nor the kernel community
> > sees fast interrupts as a worthwhile usecase. Unfortunatly the interrupt
> > latencies with Linux are at least a order of magnitude higher than the
> > pure hardware even with longer pipelines can deliver.
> 
> First point: fast interrupts won't be fast if you load them up with all
> the interrupt demux and locking that normal interrupts have; if you
> start doing that, then you end up having to make /all/ IRQ-safe locks
> in the kernel not only disable normal interrupts, but also disable the
> FIQs as well.
I just want to have an CPU context where IRQ's are not switched off by Linux.
It would be nice to use Linux infrastructure like printk but thats just not 
that important. And no, i don't wan't to use some IRQ demuxing, Thats why 
i would be nice to disable the FIQ IPI's dynamically if other uses are set.

> At that point, FIQs are no longer "fast" - they will be subject to
> exactly the same latencies as normal interrupts.
Well the main difference i am after, is to have one interrupt which is not 
masked in any way and which is as fast as the hardware can get (which on a 
cortex a9 is depending on implementation between 500ns to a couple of µs).

> Second point: we have embraced FIQs where it is appropriate to do so,
> but within the restrictions that FIQs present - that is, to keep them
> fast, we have to avoid the problem in the first point above, which
> means normal C code called from FIQs /can't/ take any kernel lock what
> so ever without potentially causing a deadlock.
Yes i am aware of that. I think thats one of the main reasons why the FIQ has 
been mainly unused by Linux. 

> Even if you think you can (why would UP have locks if it's not SMP)
> debugging facilities such as the lock validator will bite you if you
> try taking a lock in FIQ context which was already taken in the parent
> context.
Well no Linux context in FIQ at all. Thats why i was using a daisy chained 
normal interrupt to hand of the normal stuff in linux context.
 
> Third point: FIQs are not available on a lot of ARM platforms.  Hardware
> which routes interrupts to FIQs is very limited, normally it's only a
> few interrupts which appear there.  Moreover, with more modern platforms
> where the kernel runs in the non-secure side, FIQs are /totally/ and
> /completely/ unavailable there - FIQs are only available for the secure
> monitor to use.
I am fully aware that ARM started to mix up FIQ and SecureMode, confusing even 
some silicon vendors, which sadly have the FIQ missing. But aside from that i 
know that i.mx6, xilinx zynq, altera soc all have a FIQ available. The only 
one i know missing the FIQ is the Sitara which had the FIQ documented in first 
revisions of the spec (but has not anymore). So from my totally empirical 
unscientific view 3 of 4 cpus have FIQ functionality. 

Or do you mean that the platform is capable of delivering FIQ but have no 
CONFIG_FIQ set. In that case there is indeed only a small fraction which has 
this config option in use.

> > > No.  With a single zImage kernel, you could very well have SMP and FIQ
> > > both enabled, but have a non-SMP platform using FIQ, but also support
> > > SMP platforms as well.  Your change prevents that happening.
> > 
> > Ah, well i have to get used to this "new" devicetree thingy, where one
> > size
> > fits all...
> 
> No, you're conflating different things there.  It doesn't have much
> to do with DT vs non-DT, because this same problem existed before DT
> came along, since there were platforms which could be both UP and SMP.
D'accord.

> > Still if you boot a single process system which has FIQ available and has
> > a
> > GIC with such a kernel, then you also reprogramm the IPI's as FIQs. But i
> > guess thats not a problem as Linux does not self IPI the kernel as other
> > os'es do?
> 
> I'm really sorry, but your above paragraph doesn't make much sense to me.
> "single process system" - if there's only one process, there's no point
> having a scheduler (it has nothing to schedule) and so I guess you're
> not talking about Linux there.
> 
> Or do you mean "single processor system" (in other words, uniprocessor or
> UP).  In that case, the kernel doesn't use IPIs, because, by definition,
> there's no other processors for it to signal to.
I am sorry, mark that to beeing a non native english speaker, i indeed meant a 
single processor system as with a single process i would definetly not bother 
to run linux at all.

Best regards
Tim
