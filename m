Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbaJ3TEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:04:01 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:58279 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaJ3TD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:03:59 -0400
MIME-Version: 1.0
In-Reply-To: <7309232.oJGU5dTioF@wuerfel>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com>
 <22478002.kqKBdeLAKz@wuerfel> <CAJiQ=7DWEr9Oej6=+3vqKL_fJd2-wvQjx2Xw4dYwyE3AGDXOUA@mail.gmail.com>
 <7309232.oJGU5dTioF@wuerfel>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Thu, 30 Oct 2014 12:03:38 -0700
Message-ID: <CAJiQ=7DD_ivNyJpZnQFKfaFBM5nk0Gb-S-5wfXuF9fxZ_FWHvA@mail.gmail.com>
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

On Thu, Oct 30, 2014 at 2:58 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On the MIPS BCM7xxx chips, LE/BE support was a design requirement.  So:
>>
>>  - The chips include a strap pin for LE/BE so it can be configured
>> through board jumpers.  This is the only supported method of switching
>> endianness.
>>
>>  - Endianness interactions and performance concerns have been analyzed
>> for all peripherals, buses, and data flows.
>>
>>  - As Florian mentioned earlier, the LE/BE strap preconfigures several
>> hardware blocks at boot time, e.g. telling the SPI controller how to
>> arrange the incoming data such that the MSB of each instruction word
>> read from flash shows up in the right place.
>>
>>  - The entire software stack (and even the cross toolchain) needs to
>> be compiled for either LE or BE.
>>
>> So in this context a "BE system" is a BCM7xxx MIPS chip strapped for
>> BE, or one of the BCM33xx/BCM63xx/BCM68xx MIPS chips that is hardwired
>> and verified for BE only.
>
> Ah, I think I understand what you mean now. So this strapping is done
> for legacy operating systems that are not endian-aware and hardwired
> to one or the other.

Hmm, maybe, but this wasn't done for legacy reasons.  The system was
designed to run in either endianness, with the understanding that all
software would be built for either LE or BE and that the hardware
would be strapped for one or the other.

On dev boards this is a jumper on the board, but on production boards
it is often immutable.

> In Linux, we don't care about that, we have the source and we can
> just make it run on any hardware we care about. If you port a kernel
> to such a platform, the best strategy is to ignore what the SoC
> vendor tried to do for the other OSs and set the chip into "never
> translate" in hardware so you can handle it correctly in the kernel.

Right, the intention was to remain source-compatible between LE/BE,
but not binary-compatible.

Either the __raw_ accessors, or dynamically choosing between
readl/ioread32be based on CONFIG_CPU_BIG_ENDIAN (or DT properties, if
absolutely necessary), would work.  We've usually chosen the __raw_
path as it simplifies the code; all we want is a simple "load word"
instruction with no swapping on either LE or BE.

The registers themselves are automatically accessed in native endian
order regardless of the CPU's configuration, due to the way the bus
interfaces were designed.

> Presumably you want to keep the boot loader, so unfortunately
> that can mean having to override the setting in early kernel code
> before you touch any hardware. The nasty part is when the hardware
> designers put a byteswap logic in front of the flash, because then
> you have to create an image that stores the bootloader in opposite
> endianess from the kernel, but I'd assume that's still better than
> the hacks from the vendor BSP.

FWIW, these platforms have 4 different flash controllers, and each one
has its own unique byteswap hardware.

Everything works OK today, but changing the endianness at runtime
could open a big can of worms.

> You have multiple problems if you rely on the byteswaps being
> done in hardware:
>
> - You can't build a kernel that runs on all SoCs, not even all
>   systems using the same SoC when that strapping pin gives you
>   two incompatible versions

Correct.  It was never a requirement to use a single image for both LE and BE.

> - Any MMIO access to device memory storing byte streams (network
>   packets, audio, block, ...) will be swapped the same way that
>   the registers do, which means you now have to do the expensive
>   byte swaps (memcpy_fromio) in software instead of the cheap ones
>   (writel)

The various endianness settings also affect our CPU's "view" of DRAM.
All current BCM7xxx SoCs have extra logic to make sure that packet
data, disk sectors from SATA, and other "bulky" transfers all arrive
in a suitable byte order.

> - If the hardware swap was implemented wrong, all the addresses
>   for 8 or 16 bit MMIO registers are wrong too and you have to
>   fix them up in software, which is much worse than swapping the
>   contents.

We have this mode available on some of the peripherals, but chose not to use it.

One situation where it can prove useful: for PCIe enable the HW
byteswap, so readl() can be implemented as a straight 32-bit load with
no swap.  The lesser-used 8-bit and 16-bit accessors would then
implement address swizzling.  Other memory-mapped SoC peripherals that
Linux wants to treat as PCIe devices (accessing via readl/writel) can
then be configured for no HW byteswap.

> - It's impossible to share device drivers with saner hardware
>   platforms that let the CPU access MMIO registers in whichever
>   way the device expects it.

That depends somewhat on whether we're talking about binary-level
compatibility, or source-level compatibility.  For the latter case, we
can always redefine readl() to match the hardware at compile time.  On
MIPS this can be done through CONFIG_SWAP_IO_SPACE.

>> Is it the intention to allow runtime endian switching on any
>> ARM/PowerPC platform (even the Samsung products you mentioned)?  Or
>> only on the boards that were designed to operate this way?
>
> Any sane SoC will come without byteswapping on the buses, so that's
> trivial to handle. You just have to build kernel and userspace in the
> same endianess and have to ensure that all drivers use the correct
> accessors that match what the hardware does.
>
> The Samsung platforms get it wrong because they tried to optimize
> out the barriers implied by writel, before we had writel_relaxed.
> When nobody made a mistake like that, you can run a kernel of either
> endianess on any hardware.

Hmm, OK.  So it sounds like Samsung used the __raw_ macros to avoid
the barriers, but inadvertently nuked the endian swap.  bcm7120-l2
used the __raw_ macros to avoid the endian swap, and barriers were a
"don't care."

>> Our problem becomes much simpler if we assume that the majority of
>> systems have a fixed endianness, and only a few special cases need to
>> accommodate the different kernel/register endianness permutations
>> you've listed.
>
> Good point. It seems that there is currently no support for BCM7xxx
> in upstream Linux, and that is the only one that has the crazy
> strapping pin, so I guess you could avoid a lot of the problems by
> changing the MIPS code to assume BE registers, and if anybody wants
> to submit BCM7xxx MIPS support to mainline, they have to make sure
> it's in the right mode.

One catch is that almost all BCM7xxx MIPS systems are actually LE, and
BE gets less test coverage.  Some boards cannot even be configured for
BE.  BE has mostly been kept around to accommodate a few customers
with legacy code, not out of a burning desire to support both modes of
operation...
