Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbaJ2VNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:13:17 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:60425 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbaJ2VNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:13:15 -0400
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
Date: Wed, 29 Oct 2014 22:13:10 +0100
Message-ID: <22478002.kqKBdeLAKz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJiQ=7C7SzT2ngQzP=dQqdQz=+ShJ_Jf0z4kwFgvUKg1G3vrAw@mail.gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <5338153.4SY4TFtus9@wuerfel> <CAJiQ=7C7SzT2ngQzP=dQqdQz=+ShJ_Jf0z4kwFgvUKg1G3vrAw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:00zS+aMm3FNAuo9gN54LRDrqHACVVPAdvqXkiBQxUJn
 TLVEaZ1rJro0umzBKSswIlWv69nsjlvA/jet5KPNQt2stM8BoD
 ipYL82T1BuyheU2JoAuShB1AJPOR4xLFklB9oUSrHzdai4h45T
 P8zgbBZTaevUoaeEm601YHjYQdhdVrGQHogE/6eayKo2D1uTzn
 YcuYEyBAJZEYMxA45HPFq1PCBWx1ux84yWGVGkSyLwwP120pOV
 aatKzaJtUDmKJKmonfDNCySbBcYStCpcZ1uVNVj6UTFMG4pYYi
 ZZIor5EtQMIYkCFr+O1hbaeZXbggzeipUa8mjjIEqjAvem4ocb
 X8pzuwzKH0C7nO6SvKpY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 13:09:47 Kevin Cernekee wrote:
> On Wed, Oct 29, 2014 at 12:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> The host CPU is connected to the peripheral/register interface using a
> >> 32-bit wide data bus.  A simple 32-bit store originating from the host
> >> CPU, targeted to an onchip SoC peripheral, will never need endian
> >> swapping.  i.e. this code works equally well on all supported systems
> >> regardless of endianness:
> >>
> >>     volatile u32 *foo = (void *)MY_REG_VA;
> >>     *foo = 0x12345678;
> >>
> >> 8-bit and 16-bit accesses may be another story, but only appear in a
> >> few very special peripherals.
> >
> > Sorry, but this makes no sense. If you run a little-endian kernel
> > on one of the MIPS systems that you marked as "always BE", or a
> > big-endian kernel on the systems that are marked "always LE",
> > then you have to byte swap.
> 
> If I ran an LE MIPS kernel on a BE system, it would hang on boot.  I
> know this through experience. 

What is a "BE system" then? Is the CPU core not capable of running
code either way?

> Setting aside the problem that the instruction words, pointers, and
> bitfields in the image are all in the wrong byte order, there are many
> other endian-specific assumptions baked into the executable.

Most of those are handled by the compiler. Bitfields are of course
a problem when they are accessed through DMA, but I would assume
that this is still a problem with the hardware byteswap hack that
the Broadcom SoCs have.

Of course, anything that uses __raw_readl on an MMIO register is
broken if you try to do this, which was my point the whole time.

> Does this actually work on other architectures like ARM?  I still see
> compile-time checks for CONFIG_CPU_ENDIAN* in a couple of places under
> arch/arm.

Yes, it should work on any architecture that supports both modes. It
definitely works on all ARM cores I know, and on most PowerPC cores.
I always assumed that MIPS was bi-endian as well, but according to
what you say I guess it is not.

ARM and PowerPC can actually switch endianess in the kernel, and this
is what they do in the first instruction when you run a different
endianess from what the boot loader runs as it calls into the kernel.
The ARM boot protocol requires entering the kernel in little-endian
mode, while I think on PowerPC the boot loader is supposed to detect
the format of the kernel binary and pick the right mode before calling
it.

> >> Or, we could add IRQ_GC_NATIVE_IO and/or IRQ_GC_BE_IO to enum irq_gc_flags.
> >>
> >> Would either of these choices satisfy everyone's goals?
> >
> > This is what I meant with doing extra work in the case where we want to
> > support both in the same kernel. We would only enable the runtime
> > logic if both GENERIC_IRQ_CHIP and GENERIC_IRQ_CHIP_BE are set, and
> > leave it up to the platform to select the right one. For MIPS BCM7xxx,
> > you could use
> >
> > config BCM7xxx
> >         select GENERIC_IRQ_CHIP if CPU_LITTLE_ENDIAN
> >         select GENERIC_IRQ_CHIP_BE if CPU_BIG_ENDIAN
> >
> > so you would default to the hardwired big-endian accessor unless
> > some other drivers selects GENERIC_IRQ_CHIP.
> 
> generic-chip.c already has a fair amount of indirection, with pointers
> to saved masks, user-specified register offsets, and such.  Is there a
> concern that introducing, say, a pair of readl/writel function
> pointers, would cause an unacceptable performance drop?

I don't know. Thomas' reply suggests that it isn't. Doing byteswap
in software at a register access is usually free in terms of CPU
cycles, but an indirect function call can be noticeable if we do
that a lot.
 
> Backing up a little bit, do we have a consensus that defining
> irq_reg_{readl,writel} at compile time from include/linux/irq.h is a
> bad idea for multiplatform images, and it should be removed one way or
> another?

If we can prove at compile-time that all users of irq_reg_{readl,writel}
are the same, then I think it's ok to hardcode it, but of course if
any driver we build needs the opposite of the others, or needs CPU-endian
access, then it definitely can't work.

	Arnd
