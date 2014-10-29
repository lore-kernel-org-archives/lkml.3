Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbaJ2UKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:10:14 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58978 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbaJ2UKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:10:09 -0400
MIME-Version: 1.0
In-Reply-To: <5338153.4SY4TFtus9@wuerfel>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com>
 <11255905.1JsQYcArO7@wuerfel> <CAJiQ=7BcVH52-PCo40dSEoNHjT1Pg8X88uq-KZ6tQPKYWaM94A@mail.gmail.com>
 <5338153.4SY4TFtus9@wuerfel>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Wed, 29 Oct 2014 13:09:47 -0700
Message-ID: <CAJiQ=7C7SzT2ngQzP=dQqdQz=+ShJ_Jf0z4kwFgvUKg1G3vrAw@mail.gmail.com>
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

On Wed, Oct 29, 2014 at 12:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> The host CPU is connected to the peripheral/register interface using a
>> 32-bit wide data bus.  A simple 32-bit store originating from the host
>> CPU, targeted to an onchip SoC peripheral, will never need endian
>> swapping.  i.e. this code works equally well on all supported systems
>> regardless of endianness:
>>
>>     volatile u32 *foo = (void *)MY_REG_VA;
>>     *foo = 0x12345678;
>>
>> 8-bit and 16-bit accesses may be another story, but only appear in a
>> few very special peripherals.
>
> Sorry, but this makes no sense. If you run a little-endian kernel
> on one of the MIPS systems that you marked as "always BE", or a
> big-endian kernel on the systems that are marked "always LE",
> then you have to byte swap.

If I ran an LE MIPS kernel on a BE system, it would hang on boot.  I
know this through experience. ;-)

Setting aside the problem that the instruction words, pointers, and
bitfields in the image are all in the wrong byte order, there are many
other endian-specific assumptions baked into the executable.

Does this actually work on other architectures like ARM?  I still see
compile-time checks for CONFIG_CPU_ENDIAN* in a couple of places under
arch/arm.

>> FWIW, several of the BCM7xxx peripherals default to "native" mode (no
>> swap for either LE/BE), but can be optionally reconfigured as LE in
>> order to preserve compatibility with the standard AHCI/SDHCI/...
>> drivers that use the PCI accessors.
>
> The reconfigurability is definitely the worst part.

That depends on who is doing the reconfiguring...

If the kernel has to support both options, then it's definitely a
hassle (and probably quite intrusive for some drivers).

In our case we just enable swapping unconditionally and then use the
stock driver code, with no changes to the I/O accessors.

>> Or, we could add IRQ_GC_NATIVE_IO and/or IRQ_GC_BE_IO to enum irq_gc_flags.
>>
>> Would either of these choices satisfy everyone's goals?
>
> This is what I meant with doing extra work in the case where we want to
> support both in the same kernel. We would only enable the runtime
> logic if both GENERIC_IRQ_CHIP and GENERIC_IRQ_CHIP_BE are set, and
> leave it up to the platform to select the right one. For MIPS BCM7xxx,
> you could use
>
> config BCM7xxx
>         select GENERIC_IRQ_CHIP if CPU_LITTLE_ENDIAN
>         select GENERIC_IRQ_CHIP_BE if CPU_BIG_ENDIAN
>
> so you would default to the hardwired big-endian accessor unless
> some other drivers selects GENERIC_IRQ_CHIP.

generic-chip.c already has a fair amount of indirection, with pointers
to saved masks, user-specified register offsets, and such.  Is there a
concern that introducing, say, a pair of readl/writel function
pointers, would cause an unacceptable performance drop?

Backing up a little bit, do we have a consensus that defining
irq_reg_{readl,writel} at compile time from include/linux/irq.h is a
bad idea for multiplatform images, and it should be removed one way or
another?
