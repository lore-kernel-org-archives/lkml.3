Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbaJ2TOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:14:19 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:64571 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaJ2TOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:14:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>, Jonas Gorski <jogo@openwrt.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Subject: Re: [PATCH 01/11] irqchip: Allow irq_reg_{readl,writel} to use __raw_{readl_writel}
Date: Wed, 29 Oct 2014 20:14:06 +0100
Message-ID: <5338153.4SY4TFtus9@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJiQ=7BcVH52-PCo40dSEoNHjT1Pg8X88uq-KZ6tQPKYWaM94A@mail.gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <11255905.1JsQYcArO7@wuerfel> <CAJiQ=7BcVH52-PCo40dSEoNHjT1Pg8X88uq-KZ6tQPKYWaM94A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ua4Cwi0S++JTe3kGKEuzHZ8sM09l93JoNa/T5HnpE2X
 0aS4HQAw2Sx4xDTb65kL8gCPv0w72fxqne/KMViAyabh3v/GqT
 FOAxzICTwdnTHEG1dYVUHNIDj/ns0Hcdxj9Vwq2bLfuLKd11jY
 LYAiWn45pSPizShN4CI/AQDEH4OFnjqSp3sb9RbBkdQgq4OV9B
 jqlWg2L/t5RysHSlCZMOcFvV383akmHzWyvVJh17MtaKa6u/iE
 VaGmr4xiXaJHkJBH59AW5NaJ+3M818RaJrmWbizT0AzxAILCiN
 ecEX4Qx1EYmM2fe/W2aMdrEoEBwhryghuZum6ul9ZlmfGydRX1
 +G7poFWTnK4IzHBAplQY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 11:48:39 Kevin Cernekee wrote:
> On Wed, Oct 29, 2014 at 12:43 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 28 October 2014 20:58:48 Kevin Cernekee wrote:
> >>
> >> +#ifdef CONFIG_RAW_IRQ_ACCESSORS
> >> +
> >> +#ifndef irq_reg_writel
> >> +# define irq_reg_writel(val, addr)     __raw_writel(val, addr)
> >> +#endif
> >> +#ifndef irq_reg_readl
> >> +# define irq_reg_readl(addr)           __raw_readl(addr)
> >> +#endif
> >> +
> >> +#else
> >> +
> >
> > No, this is just wrong: registers almost always have a fixed endianess
> > indenpent of CPU endianess, so if you use __raw_writel, it will be
> > broken on one or the other.
> >
> > If you have a machine that uses big-endian registers in the interrupt
> > controller, you need to find a way to use the correct accessors
> > (e.g. iowrite32be) and use them independent of what endianess the CPU
> > is running.
> >
> > As this code is being used on all sorts of platforms, you can't assume
> > that they all use the same endianess, which makes it rather tricky.
> >
> > As the first step, you can probably introduce a new Kconfig symbol
> > GENERIC_IRQ_CHIP_BE, and then make that mutually exclusive with the
> > existing users that all use little-endian registers:
> >
> > #if defined(CONFIG_GENERIC_IRQ_CHIP) && !defined(CONFIG_GENERIC_IRQ_CHIP_BE)
> > #define irq_reg_writel(val, addr)     writel(val, addr)
> > #else if defined(CONFIG_GENERIC_IRQ_CHIP_BE) && !defined(CONFIG_GENERIC_IRQ_CHIP)
> > #define irq_reg_writel(val, addr)     iowrite32be(val, addr)
> > #else
> > /* provoke a compile error when this is used */
> > #define irq_reg_writel(val, addr)       irq_reg_writel_unknown_endian(val, addr)
> > #endif
> 
> Thanks for the quick feedback, guys.  Let me try to fill in a little
> more background information.
> 
> The irqchip drivers in question can be used on a variety of different SoCs:
> 
> BCM7xxx STB chip with ARM host (always LE)
> BCM7xxx STB chip with MIPS host (user-selectable LE or BE via jumper)
> BCM33xx cable chip with MIPS host (always BE)
> BCM33xx cable chip with ARM host (always LE)
> BCM63xx[x] DSL chip with MIPS host (always BE)
> BCM63xx[x] DSL chip with ARM host (always LE, I think)
> BCM68xx PON chip with MIPS host (always BE)
>
> The host CPU is connected to the peripheral/register interface using a
> 32-bit wide data bus.  A simple 32-bit store originating from the host
> CPU, targeted to an onchip SoC peripheral, will never need endian
> swapping.  i.e. this code works equally well on all supported systems
> regardless of endianness:
> 
>     volatile u32 *foo = (void *)MY_REG_VA;
>     *foo = 0x12345678;
> 
> 8-bit and 16-bit accesses may be another story, but only appear in a
> few very special peripherals.

Sorry, but this makes no sense. If you run a little-endian kernel
on one of the MIPS systems that you marked as "always BE", or a
big-endian kernel on the systems that are marked "always LE",
then you have to byte swap.

Same for the BCM7xxx MIPS chip if the jumper sets the strapping
pin the opposite way from the running kernel, although I can see
the argument that you would hope nobody does that.
On the other hand, if you give hardware designers two ways to do
something, of course they will do both eventually, so I'm sure
someone has already done it (probably not supported using upstream
Linux)

> The problem we see here is that irq_reg_{readl,writel} use
> readl/writel to access a non-PCI peripheral, thus adding an unwanted
> endian swap.  And I can't avoid using the irq_reg_* accessors unless I
> skip using GENERIC_IRQ_CHIP.

That is probably the best way forward.

> So, a few possible solutions include:
> 
> 1) Implement your CONFIG_GENERIC_IRQ_CHIP_BE suggestion.  This could
> probably be made to work, but I would need to define
> CONFIG_GENERIC_IRQ_CHIP / CONFIG_GENERIC_IRQ_CHIP_BE conditionally
> based on whether the build was LE or BE.  It would be nicer if the
> driver didn't have to think about endianness because we know all of
> these register accesses are always "native."

If you want to support "native" you have three endianess settings
to support in your driver, not one, and a run-time selection
that looks at the "big-endian" property in DT as well as the
endianess that the kernel was built for.

> 2) Offer a common way for irqchips to force GENERIC_IRQ_CHIP to use
> the __raw_ variants.  Since there are already other irqchip drivers
> using __raw_*, this seems like it might be useful to others someday.

The drivers using __raw_ today (exynos, mxs, s3c24xx) are all broken
and should be fixed. This is all old code that was written without
taking endianess into consideration and breaks if you try to run a
big-endian kernel.
 
> 3) Stuff my __raw_ definitions into the mach-specific <irq.h>.

That would still break the use of secondary interrupt controllers
using generic irqchip.

> 4) Don't use GENERIC_IRQ_CHIP at all; just reimplement the helpers
> locally using __raw_* macros.

This would break the ARM machines, unless you make it depend on
the CPU architecture. You should still check for the "big-endian"
property to see if the strapping pin was actually set the way
you expect it.

> > registers almost always have a fixed endianess
> > indenpent of CPU endianess
> 
> Going back to this statement - in my own personal experience, SoCs are
> usually designed such that extra swaps are NOT necessary when
> accessing onchip peripherals.  Although I've seen a few cases where
> 1-2 peripherals, often third party IP cores, needed special treatment.

In my experience, the opposite is true: hardware designers will put
anything in the SoCs that they happen to need, and disregard the
specifications for endianess if they exist. If you are lucky, each
part gets used in only one form, but some people are crazy enough
to put the byte swaps into hardware and make life miserable for us.

> FWIW, several of the BCM7xxx peripherals default to "native" mode (no
> swap for either LE/BE), but can be optionally reconfigured as LE in
> order to preserve compatibility with the standard AHCI/SDHCI/...
> drivers that use the PCI accessors.

The reconfigurability is definitely the worst part.

> Not sure how easy it is to figure out which other SoCs do require the
> swap, as we'd need to exclude both PCI drivers and LE hosts whose
> drivers just used plain readl.  But a quick look around the drivers/
> tree shows quite a few users of the __raw_ accessors:
> 
> $ git grep -l __raw_readl drivers | wc -l
> 228

Most of these are bugs. About half of them are for Samsung SoCs,
and this is after we've spent a lot of time changing other drivers
for the same chips to use readl() in order to make them work with
big-endian kernels.

> By contrast, for BE-only registers:
> 
> $ git grep -lE "(ioread32be)|(readl_be)" drivers/ | wc -l
> 42

Most big-endian drivers come from powerpc, which uses in_be32:

git grep in_be32 | wc -l
    950

These drivers typically work just as well on little-endian kernels.

> The latter list seems to include a lot of FPGAs.  Maybe it costs them
> too many gates/LEs to support both endian orderings.

The FPGA developers are priviledged because they can fix their hardware
when they get it wrong ;-)

> Or, we could add IRQ_GC_NATIVE_IO and/or IRQ_GC_BE_IO to enum irq_gc_flags.
>
> Would either of these choices satisfy everyone's goals?

This is what I meant with doing extra work in the case where we want to
support both in the same kernel. We would only enable the runtime
logic if both GENERIC_IRQ_CHIP and GENERIC_IRQ_CHIP_BE are set, and
leave it up to the platform to select the right one. For MIPS BCM7xxx,
you could use

config BCM7xxx
	select GENERIC_IRQ_CHIP if CPU_LITTLE_ENDIAN
	select GENERIC_IRQ_CHIP_BE if CPU_BIG_ENDIAN

so you would default to the hardwired big-endian accessor unless
some other drivers selects GENERIC_IRQ_CHIP.

	Arnd
