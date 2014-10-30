Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbaJ3TxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:53:01 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:50288 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761027AbaJ3Tw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:52:58 -0400
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
Date: Thu, 30 Oct 2014 20:52:42 +0100
Message-ID: <7275578.mKZ88H670E@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJiQ=7DD_ivNyJpZnQFKfaFBM5nk0Gb-S-5wfXuF9fxZ_FWHvA@mail.gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <7309232.oJGU5dTioF@wuerfel> <CAJiQ=7DD_ivNyJpZnQFKfaFBM5nk0Gb-S-5wfXuF9fxZ_FWHvA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:YNq2CJwy3kvK6Ch3SJknx7Sanw2u2j5aHhnEqhr4YXY
 YGHQhhWqnvkz2Pggqg2AqUnX9PyJb5PBFpuEYg6AOzY4htO43/
 jJ75BXGbLa2MQpCmIXXba1Uv6Hu5XapNNGpyfscLKPntxk5zOk
 K/m2OxinKv2Q910Q39cY4Lt7qLZPEMfexnnaVK4ua8lmQBNMoV
 +xOvKQ86cdc64e640KaOt2t8ibcGMRr8ga9KWna+nUKChf674D
 ZVOmSwgAVNl1WPIRg7LFF0wzGSLmSmUwkiDTncQJiKvC+JF2Ki
 E7Hu/dW5t5lgu0grmF68O+f+B/Cqo2uVG8mbYdaPFdksPtl0M1
 O6MkrJy0UNF3JO2mrTkE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 12:03:38 Kevin Cernekee wrote:
> On Thu, Oct 30, 2014 at 2:58 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> On the MIPS BCM7xxx chips, LE/BE support was a design requirement.  So:
> >>
> >>  - The chips include a strap pin for LE/BE so it can be configured
> >> through board jumpers.  This is the only supported method of switching
> >> endianness.
> >>
> >>  - Endianness interactions and performance concerns have been analyzed
> >> for all peripherals, buses, and data flows.
> >>
> >>  - As Florian mentioned earlier, the LE/BE strap preconfigures several
> >> hardware blocks at boot time, e.g. telling the SPI controller how to
> >> arrange the incoming data such that the MSB of each instruction word
> >> read from flash shows up in the right place.
> >>
> >>  - The entire software stack (and even the cross toolchain) needs to
> >> be compiled for either LE or BE.
> >>
> >> So in this context a "BE system" is a BCM7xxx MIPS chip strapped for
> >> BE, or one of the BCM33xx/BCM63xx/BCM68xx MIPS chips that is hardwired
> >> and verified for BE only.
> >
> > Ah, I think I understand what you mean now. So this strapping is done
> > for legacy operating systems that are not endian-aware and hardwired
> > to one or the other.
> 
> Hmm, maybe, but this wasn't done for legacy reasons.  The system was
> designed to run in either endianness, with the understanding that all
> software would be built for either LE or BE and that the hardware
> would be strapped for one or the other.
> 
> On dev boards this is a jumper on the board, but on production boards
> it is often immutable.

But only legacy OSs would need the jumper or the pin. Any modern OS
like Linux should just work in either endianess independent of how
the registers are done.

> > In Linux, we don't care about that, we have the source and we can
> > just make it run on any hardware we care about. If you port a kernel
> > to such a platform, the best strategy is to ignore what the SoC
> > vendor tried to do for the other OSs and set the chip into "never
> > translate" in hardware so you can handle it correctly in the kernel.
> 
> Right, the intention was to remain source-compatible between LE/BE,
> but not binary-compatible.

Well, I guess they failed on the "source-compatible" part ;-)

> Either the __raw_ accessors, or dynamically choosing between
> readl/ioread32be based on CONFIG_CPU_BIG_ENDIAN (or DT properties, if
> absolutely necessary), would work. 

No, this is just wrong. Don't ever assume that the endianess of the
kernel has anything to do with how the hardware is built. You can
make it a separate Kconfig option, and you can make it default
to CPU_BIG_ENDIAN, but the two things are fundamentally different,
whatever the hardware designers try to tell you.

> > You have multiple problems if you rely on the byteswaps being
> > done in hardware:
> >
> > - You can't build a kernel that runs on all SoCs, not even all
> >   systems using the same SoC when that strapping pin gives you
> >   two incompatible versions
> 
> Correct.  It was never a requirement to use a single image for both LE and BE.

I didn't mean one kernel image that runs in both BE and LE mode, that
would be crazy. What I mean is one image that can run on the SoC
in either strapping mode but with the CPU endianess set the way that
matches how the kernel is built.

> > - Any MMIO access to device memory storing byte streams (network
> >   packets, audio, block, ...) will be swapped the same way that
> >   the registers do, which means you now have to do the expensive
> >   byte swaps (memcpy_fromio) in software instead of the cheap ones
> >   (writel)
> 
> The various endianness settings also affect our CPU's "view" of DRAM.
> All current BCM7xxx SoCs have extra logic to make sure that packet
> data, disk sectors from SATA, and other "bulky" transfers all arrive
> in a suitable byte order.

Wow, that seems like a lot of hardware effort to gain basically
nothing. If they managed to get this right, at least it won't
make it harder to support the hardware properly.

So the byte stream data is never swapped, or always swapped an even
number of times, regardless of the strapping pin, right?

> > - If the hardware swap was implemented wrong, all the addresses
> >   for 8 or 16 bit MMIO registers are wrong too and you have to
> >   fix them up in software, which is much worse than swapping the
> >   contents.
> 
> We have this mode available on some of the peripherals, but chose not to use it.
> 
> One situation where it can prove useful: for PCIe enable the HW
> byteswap, so readl() can be implemented as a straight 32-bit load with
> no swap.  The lesser-used 8-bit and 16-bit accessors would then
> implement address swizzling.  Other memory-mapped SoC peripherals that
> Linux wants to treat as PCIe devices (accessing via readl/writel) can
> then be configured for no HW byteswap.

This is the part where it gets really crazy and the only sane way to
deal with it is to turn off the entire swizzling in hardware.

> > - It's impossible to share device drivers with saner hardware
> >   platforms that let the CPU access MMIO registers in whichever
> >   way the device expects it.
> 
> That depends somewhat on whether we're talking about binary-level
> compatibility, or source-level compatibility.  For the latter case, we
> can always redefine readl() to match the hardware at compile time.  On
> MIPS this can be done through CONFIG_SWAP_IO_SPACE.

That option seems to be incompatible with running one kernel across
multiple SoC families, if each of them does it differently.

The comment in arch/mips/include/asm/mach-generic/mangle-port.h
suggests that it was originally meant only for PIO access, not
for MMIO, but asm/io.h uses it for both.

> >> Our problem becomes much simpler if we assume that the majority of
> >> systems have a fixed endianness, and only a few special cases need to
> >> accommodate the different kernel/register endianness permutations
> >> you've listed.
> >
> > Good point. It seems that there is currently no support for BCM7xxx
> > in upstream Linux, and that is the only one that has the crazy
> > strapping pin, so I guess you could avoid a lot of the problems by
> > changing the MIPS code to assume BE registers, and if anybody wants
> > to submit BCM7xxx MIPS support to mainline, they have to make sure
> > it's in the right mode.
> 
> One catch is that almost all BCM7xxx MIPS systems are actually LE, and
> BE gets less test coverage.  Some boards cannot even be configured for
> BE.  BE has mostly been kept around to accommodate a few customers
> with legacy code, not out of a burning desire to support both modes of
> operation...

If all the boards can be configured for LE, then you can just make this
mode required when upstreaming the kernel port, independent of how the
kernel runs.

	Arnd
