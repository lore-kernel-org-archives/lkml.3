Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbaJ2XFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:05:44 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:43837 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385AbaJ2XFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:05:42 -0400
MIME-Version: 1.0
In-Reply-To: <22478002.kqKBdeLAKz@wuerfel>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com>
 <5338153.4SY4TFtus9@wuerfel> <CAJiQ=7C7SzT2ngQzP=dQqdQz=+ShJ_Jf0z4kwFgvUKg1G3vrAw@mail.gmail.com>
 <22478002.kqKBdeLAKz@wuerfel>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Wed, 29 Oct 2014 16:05:21 -0700
Message-ID: <CAJiQ=7DWEr9Oej6=+3vqKL_fJd2-wvQjx2Xw4dYwyE3AGDXOUA@mail.gmail.com>
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

On Wed, Oct 29, 2014 at 2:13 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 29 October 2014 13:09:47 Kevin Cernekee wrote:
>> On Wed, Oct 29, 2014 at 12:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >> The host CPU is connected to the peripheral/register interface using a
>> >> 32-bit wide data bus.  A simple 32-bit store originating from the host
>> >> CPU, targeted to an onchip SoC peripheral, will never need endian
>> >> swapping.  i.e. this code works equally well on all supported systems
>> >> regardless of endianness:
>> >>
>> >>     volatile u32 *foo = (void *)MY_REG_VA;
>> >>     *foo = 0x12345678;
>> >>
>> >> 8-bit and 16-bit accesses may be another story, but only appear in a
>> >> few very special peripherals.
>> >
>> > Sorry, but this makes no sense. If you run a little-endian kernel
>> > on one of the MIPS systems that you marked as "always BE", or a
>> > big-endian kernel on the systems that are marked "always LE",
>> > then you have to byte swap.
>>
>> If I ran an LE MIPS kernel on a BE system, it would hang on boot.  I
>> know this through experience.
>
> What is a "BE system" then? Is the CPU core not capable of running
> code either way?

On the MIPS BCM7xxx chips, LE/BE support was a design requirement.  So:

 - The chips include a strap pin for LE/BE so it can be configured
through board jumpers.  This is the only supported method of switching
endianness.

 - Endianness interactions and performance concerns have been analyzed
for all peripherals, buses, and data flows.

 - As Florian mentioned earlier, the LE/BE strap preconfigures several
hardware blocks at boot time, e.g. telling the SPI controller how to
arrange the incoming data such that the MSB of each instruction word
read from flash shows up in the right place.

 - The entire software stack (and even the cross toolchain) needs to
be compiled for either LE or BE.

So in this context a "BE system" is a BCM7xxx MIPS chip strapped for
BE, or one of the BCM33xx/BCM63xx/BCM68xx MIPS chips that is hardwired
and verified for BE only.

>> Does this actually work on other architectures like ARM?  I still see
>> compile-time checks for CONFIG_CPU_ENDIAN* in a couple of places under
>> arch/arm.
>
> Yes, it should work on any architecture that supports both modes. It
> definitely works on all ARM cores I know, and on most PowerPC cores.
> I always assumed that MIPS was bi-endian as well, but according to
> what you say I guess it is not.
>
> ARM and PowerPC can actually switch endianess in the kernel, and this
> is what they do in the first instruction when you run a different
> endianess from what the boot loader runs as it calls into the kernel.
> The ARM boot protocol requires entering the kernel in little-endian
> mode, while I think on PowerPC the boot loader is supposed to detect
> the format of the kernel binary and pick the right mode before calling
> it.

Is it the intention to allow runtime endian switching on any
ARM/PowerPC platform (even the Samsung products you mentioned)?  Or
only on the boards that were designed to operate this way?

Our problem becomes much simpler if we assume that the majority of
systems have a fixed endianness, and only a few special cases need to
accommodate the different kernel/register endianness permutations
you've listed.
