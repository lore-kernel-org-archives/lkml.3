Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161020AbaJ3Uy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:54:29 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:41556 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933938AbaJ3Uy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:54:27 -0400
MIME-Version: 1.0
In-Reply-To: <7275578.mKZ88H670E@wuerfel>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com>
 <7309232.oJGU5dTioF@wuerfel> <CAJiQ=7DD_ivNyJpZnQFKfaFBM5nk0Gb-S-5wfXuF9fxZ_FWHvA@mail.gmail.com>
 <7275578.mKZ88H670E@wuerfel>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Thu, 30 Oct 2014 13:54:06 -0700
Message-ID: <CAJiQ=7C+r80Jt51NXLCk-0D2nRezBfMN9pGBVT9V8ncefGhBnQ@mail.gmail.com>
Subject: Re: [PATCH 01/11] irqchip: Allow irq_reg_{readl,writel} to use __raw_{readl_writel}
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>, Jonas Gorski <jogo@openwrt.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > Ah, I think I understand what you mean now. So this strapping is done
>> > for legacy operating systems that are not endian-aware and hardwired
>> > to one or the other.
>>
>> Hmm, maybe, but this wasn't done for legacy reasons.  The system was
>> designed to run in either endianness, with the understanding that all
>> software would be built for either LE or BE and that the hardware
>> would be strapped for one or the other.
>>
>> On dev boards this is a jumper on the board, but on production boards
>> it is often immutable.
>
> But only legacy OSs would need the jumper or the pin. Any modern OS
> like Linux should just work in either endianess independent of how
> the registers are done.

I did some checking; AFAICT our hardware does not support the type of
runtime endian switching that you describe.

MIPS CP0 register 12 bit 25 (Reverse Endian) "reverses the memory
endian selection when operating in user mode. Kernel or debug mode
references are not affected by the state of this bit."

MIPS CP0 register 16 bit 15 (Big Endian) "Indicates the endian mode in
which the processor is running. Set via SI_Endian input pin."  This
bit is read-only.

Based on the datasheets, the RE bit may be supported in BMIPS4380, but
is not supported in BMIPS5000 or MIPS 34K.  In any event, it won't
have an impact on kernel I/O accesses.

>> > In Linux, we don't care about that, we have the source and we can
>> > just make it run on any hardware we care about. If you port a kernel
>> > to such a platform, the best strategy is to ignore what the SoC
>> > vendor tried to do for the other OSs and set the chip into "never
>> > translate" in hardware so you can handle it correctly in the kernel.
>>
>> Right, the intention was to remain source-compatible between LE/BE,
>> but not binary-compatible.
>
> Well, I guess they failed on the "source-compatible" part ;-)

We have kernel trees and bootloaders that build LE/BE images from the
same source tree, just by changing CONFIG_CPU_*_ENDIAN.  They use the
__raw_ macros or equivalent when talking to peripherals.

>> Either the __raw_ accessors, or dynamically choosing between
>> readl/ioread32be based on CONFIG_CPU_BIG_ENDIAN (or DT properties, if
>> absolutely necessary), would work.
>
> No, this is just wrong. Don't ever assume that the endianess of the
> kernel has anything to do with how the hardware is built. You can
> make it a separate Kconfig option, and you can make it default
> to CPU_BIG_ENDIAN, but the two things are fundamentally different,
> whatever the hardware designers try to tell you.

But we have a situation where kernel endianness == hardware
endianness, so can't we make simplifying assumptions?

>> > - Any MMIO access to device memory storing byte streams (network
>> >   packets, audio, block, ...) will be swapped the same way that
>> >   the registers do, which means you now have to do the expensive
>> >   byte swaps (memcpy_fromio) in software instead of the cheap ones
>> >   (writel)
>>
>> The various endianness settings also affect our CPU's "view" of DRAM.
>> All current BCM7xxx SoCs have extra logic to make sure that packet
>> data, disk sectors from SATA, and other "bulky" transfers all arrive
>> in a suitable byte order.
>
> Wow, that seems like a lot of hardware effort to gain basically
> nothing. If they managed to get this right, at least it won't
> make it harder to support the hardware properly.

The hardware was built to guarantee that a byte access to skb->data[0]
reads back byte 0 of the packet, not byte 3, regardless of whether
we're in LE or BE mode.

It takes a surprising amount of effort to make sure this is done
consistently and correctly across dozens of onchip peripherals.

>> That depends somewhat on whether we're talking about binary-level
>> compatibility, or source-level compatibility.  For the latter case, we
>> can always redefine readl() to match the hardware at compile time.  On
>> MIPS this can be done through CONFIG_SWAP_IO_SPACE.
>
> That option seems to be incompatible with running one kernel across
> multiple SoC families, if each of them does it differently.

Agreed.  We have many such challenges on MIPS.  In the end, it is
possible that not every MIPS SoC will "fit the mold."

>> One catch is that almost all BCM7xxx MIPS systems are actually LE, and
>> BE gets less test coverage.  Some boards cannot even be configured for
>> BE.  BE has mostly been kept around to accommodate a few customers
>> with legacy code, not out of a burning desire to support both modes of
>> operation...
>
> If all the boards can be configured for LE, then you can just make this
> mode required when upstreaming the kernel port, independent of how the
> kernel runs.

I was hoping to eventually come up with a multiplatform BE BMIPS image
that boots on 3384, 6328, and 7346... (even though the common case for
7xxx is LE, it makes for a nice demo)
