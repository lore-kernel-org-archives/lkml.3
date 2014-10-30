Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810AbaJ3VSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 17:18:37 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:56610 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934348AbaJ3VSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 17:18:36 -0400
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
Date: Thu, 30 Oct 2014 22:18:12 +0100
Message-ID: <3443381.DoMDV4maD8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJiQ=7C+r80Jt51NXLCk-0D2nRezBfMN9pGBVT9V8ncefGhBnQ@mail.gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <7275578.mKZ88H670E@wuerfel> <CAJiQ=7C+r80Jt51NXLCk-0D2nRezBfMN9pGBVT9V8ncefGhBnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zvp8qxCBfArEx0MbpebW/Xpac9wKQmsMXixnTR6gr8F
 cUqLxPnxYSMTn1TrhQvh+OQrVMBqkUNZXMVnIYHKltWYhiKOru
 HfPALf+mQeo9QUlPC/QCMtiwG0PlncPujZEx8KH5xOR1jn8rEb
 alxYlBbSzBF7qMV5DfmU01WMeGWCNdb/g5J5tDKZSeAcHLsyBm
 +5yDXMLoPAFwI8s2SUBTcAHuUYaPolsqXgM1JMYjC2OubkQfA3
 BFto7Mc9xp+WRjqoz2weyDrlqBnmBuRKjX76e+SO96EXlAojbH
 +AM1jrlHWuMediU6+WpxceyfANE1MgbYPRLnwhSAWCsRophsAU
 F5c+ru1VgL6fPtQyIjmc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 13:54:06 Kevin Cernekee wrote:
> On Thu, Oct 30, 2014 at 12:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > Ah, I think I understand what you mean now. So this strapping is done
> >> > for legacy operating systems that are not endian-aware and hardwired
> >> > to one or the other.
> >>
> >> Hmm, maybe, but this wasn't done for legacy reasons.  The system was
> >> designed to run in either endianness, with the understanding that all
> >> software would be built for either LE or BE and that the hardware
> >> would be strapped for one or the other.
> >>
> >> On dev boards this is a jumper on the board, but on production boards
> >> it is often immutable.
> >
> > But only legacy OSs would need the jumper or the pin. Any modern OS
> > like Linux should just work in either endianess independent of how
> > the registers are done.
> 
> I did some checking; AFAICT our hardware does not support the type of
> runtime endian switching that you describe.
> 
> MIPS CP0 register 12 bit 25 (Reverse Endian) "reverses the memory
> endian selection when operating in user mode. Kernel or debug mode
> references are not affected by the state of this bit."
> 
> MIPS CP0 register 16 bit 15 (Big Endian) "Indicates the endian mode in
> which the processor is running. Set via SI_Endian input pin."  This
> bit is read-only.
> 
> Based on the datasheets, the RE bit may be supported in BMIPS4380, but
> is not supported in BMIPS5000 or MIPS 34K.  In any event, it won't
> have an impact on kernel I/O accesses.

I see. Most importantly, changing the RE bit would be unsupportable by
Linux, because that would break our system call ABI: you can't have
kernel and user space running at different endianess.

Thanks for looking that up, that explains a lot!

> >> > In Linux, we don't care about that, we have the source and we can
> >> > just make it run on any hardware we care about. If you port a kernel
> >> > to such a platform, the best strategy is to ignore what the SoC
> >> > vendor tried to do for the other OSs and set the chip into "never
> >> > translate" in hardware so you can handle it correctly in the kernel.
> >>
> >> Right, the intention was to remain source-compatible between LE/BE,
> >> but not binary-compatible.
> >
> > Well, I guess they failed on the "source-compatible" part ;-)
> 
> We have kernel trees and bootloaders that build LE/BE images from the
> same source tree, just by changing CONFIG_CPU_*_ENDIAN.  They use the
> __raw_ macros or equivalent when talking to peripherals.

What I meant is that you can't use the normal driver API. The __raw_*
accessors are in no way guaranteed to do what you want across
architectures, they may be missing barriers and the compiler is free
to reorder accesses or split up word accesses into byte accesses
for any reason. It's basically just a 'volatile' pointer dereference
that is meant to access device memory through an __iomem pointer.

I don't doubt that these accessors do the right thing for you on
MIPS, but that is because either the hardware or the definition
in source code puts more into them than the API guarantees.

> >> Either the __raw_ accessors, or dynamically choosing between
> >> readl/ioread32be based on CONFIG_CPU_BIG_ENDIAN (or DT properties, if
> >> absolutely necessary), would work.
> >
> > No, this is just wrong. Don't ever assume that the endianess of the
> > kernel has anything to do with how the hardware is built. You can
> > make it a separate Kconfig option, and you can make it default
> > to CPU_BIG_ENDIAN, but the two things are fundamentally different,
> > whatever the hardware designers try to tell you.
> 
> But we have a situation where kernel endianness == hardware
> endianness, so can't we make simplifying assumptions?

Yes, based on your description above, that works. I'm just really
surprised about that kind of hardware design.

> >> > - Any MMIO access to device memory storing byte streams (network
> >> >   packets, audio, block, ...) will be swapped the same way that
> >> >   the registers do, which means you now have to do the expensive
> >> >   byte swaps (memcpy_fromio) in software instead of the cheap ones
> >> >   (writel)
> >>
> >> The various endianness settings also affect our CPU's "view" of DRAM.
> >> All current BCM7xxx SoCs have extra logic to make sure that packet
> >> data, disk sectors from SATA, and other "bulky" transfers all arrive
> >> in a suitable byte order.
> >
> > Wow, that seems like a lot of hardware effort to gain basically
> > nothing. If they managed to get this right, at least it won't
> > make it harder to support the hardware properly.
> 
> The hardware was built to guarantee that a byte access to skb->data[0]
> reads back byte 0 of the packet, not byte 3, regardless of whether
> we're in LE or BE mode.
> 
> It takes a surprising amount of effort to make sure this is done
> consistently and correctly across dozens of onchip peripherals.

Yes, I can imagine the horror this must mean for hardware designers.
On systems where the hardware doesn't do any byte swaps, this is
no problem at all, the kernel just does the swaps in either
readl()/ioread32() or in ioread32be(), but not in ioread32_rep(),
which is used for repeated FIFO accesses.
 
> >> One catch is that almost all BCM7xxx MIPS systems are actually LE, and
> >> BE gets less test coverage.  Some boards cannot even be configured for
> >> BE.  BE has mostly been kept around to accommodate a few customers
> >> with legacy code, not out of a burning desire to support both modes of
> >> operation...
> >
> > If all the boards can be configured for LE, then you can just make this
> > mode required when upstreaming the kernel port, independent of how the
> > kernel runs.
> 
> I was hoping to eventually come up with a multiplatform BE BMIPS image
> that boots on 3384, 6328, and 7346... (even though the common case for
> 7xxx is LE, it makes for a nice demo)

Yes, definitely.

	Arnd
