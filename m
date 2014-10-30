Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbaJ3J6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:58:51 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:64349 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaJ3J6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:58:48 -0400
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
Date: Thu, 30 Oct 2014 10:58:44 +0100
Message-ID: <7309232.oJGU5dTioF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJiQ=7DWEr9Oej6=+3vqKL_fJd2-wvQjx2Xw4dYwyE3AGDXOUA@mail.gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <22478002.kqKBdeLAKz@wuerfel> <CAJiQ=7DWEr9Oej6=+3vqKL_fJd2-wvQjx2Xw4dYwyE3AGDXOUA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Iug792cKnoGQFknf3yuji5nXersgjxtqw0uBMLaEjTI
 cKdjtDXTDPTOGFL71ZPdXQhqdhxCeKoR2PWT/vL/ce4thxxXwb
 kfYtGhuj45JKRd6NmuD5vHje7ufUA1cyrsvMYPHmJEcn5lpskt
 RvJRNbcmihINt5RkIc7EihHTN0d3cv5X3ecSrC6AEHZhSyXg6Y
 H9Kg2Qk84Ebs2u+0Wvso4WM/LqTnmc8QP0HrvBTPIRVEdrTl+o
 eY2g+jCY0/+pug9Rqu20IuL7J8BOeDov6kJMVq8WxY4oCjY2kQ
 eyCd0r2AAmQVO8MQ9qzpVb1i811fC/HIxuz9lLzhC2ItU4Bu8h
 9cW1YPqYuf4m3yjEHfZ8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 16:05:21 Kevin Cernekee wrote:
> On Wed, Oct 29, 2014 at 2:13 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 29 October 2014 13:09:47 Kevin Cernekee wrote:
> >> On Wed, Oct 29, 2014 at 12:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> >> The host CPU is connected to the peripheral/register interface using a
> >> >> 32-bit wide data bus.  A simple 32-bit store originating from the host
> >> >> CPU, targeted to an onchip SoC peripheral, will never need endian
> >> >> swapping.  i.e. this code works equally well on all supported systems
> >> >> regardless of endianness:
> >> >>
> >> >>     volatile u32 *foo = (void *)MY_REG_VA;
> >> >>     *foo = 0x12345678;
> >> >>
> >> >> 8-bit and 16-bit accesses may be another story, but only appear in a
> >> >> few very special peripherals.
> >> >
> >> > Sorry, but this makes no sense. If you run a little-endian kernel
> >> > on one of the MIPS systems that you marked as "always BE", or a
> >> > big-endian kernel on the systems that are marked "always LE",
> >> > then you have to byte swap.
> >>
> >> If I ran an LE MIPS kernel on a BE system, it would hang on boot.  I
> >> know this through experience.
> >
> > What is a "BE system" then? Is the CPU core not capable of running
> > code either way?
> 
> On the MIPS BCM7xxx chips, LE/BE support was a design requirement.  So:
> 
>  - The chips include a strap pin for LE/BE so it can be configured
> through board jumpers.  This is the only supported method of switching
> endianness.
> 
>  - Endianness interactions and performance concerns have been analyzed
> for all peripherals, buses, and data flows.
> 
>  - As Florian mentioned earlier, the LE/BE strap preconfigures several
> hardware blocks at boot time, e.g. telling the SPI controller how to
> arrange the incoming data such that the MSB of each instruction word
> read from flash shows up in the right place.
> 
>  - The entire software stack (and even the cross toolchain) needs to
> be compiled for either LE or BE.
> 
> So in this context a "BE system" is a BCM7xxx MIPS chip strapped for
> BE, or one of the BCM33xx/BCM63xx/BCM68xx MIPS chips that is hardwired
> and verified for BE only.

Ah, I think I understand what you mean now. So this strapping is done
for legacy operating systems that are not endian-aware and hardwired
to one or the other.

In Linux, we don't care about that, we have the source and we can
just make it run on any hardware we care about. If you port a kernel
to such a platform, the best strategy is to ignore what the SoC
vendor tried to do for the other OSs and set the chip into "never
translate" in hardware so you can handle it correctly in the kernel.

Presumably you want to keep the boot loader, so unfortunately
that can mean having to override the setting in early kernel code
before you touch any hardware. The nasty part is when the hardware
designers put a byteswap logic in front of the flash, because then
you have to create an image that stores the bootloader in opposite
endianess from the kernel, but I'd assume that's still better than
the hacks from the vendor BSP.

You have multiple problems if you rely on the byteswaps being
done in hardware:

- You can't build a kernel that runs on all SoCs, not even all
  systems using the same SoC when that strapping pin gives you
  two incompatible versions

- Any MMIO access to device memory storing byte streams (network
  packets, audio, block, ...) will be swapped the same way that
  the registers do, which means you now have to do the expensive
  byte swaps (memcpy_fromio) in software instead of the cheap ones
  (writel)

- If the hardware swap was implemented wrong, all the addresses
  for 8 or 16 bit MMIO registers are wrong too and you have to
  fix them up in software, which is much worse than swapping the
  contents.

- It's impossible to share device drivers with saner hardware
  platforms that let the CPU access MMIO registers in whichever
  way the device expects it.

> >> Does this actually work on other architectures like ARM?  I still see
> >> compile-time checks for CONFIG_CPU_ENDIAN* in a couple of places under
> >> arch/arm.
> >
> > Yes, it should work on any architecture that supports both modes. It
> > definitely works on all ARM cores I know, and on most PowerPC cores.
> > I always assumed that MIPS was bi-endian as well, but according to
> > what you say I guess it is not.
> >
> > ARM and PowerPC can actually switch endianess in the kernel, and this
> > is what they do in the first instruction when you run a different
> > endianess from what the boot loader runs as it calls into the kernel.
> > The ARM boot protocol requires entering the kernel in little-endian
> > mode, while I think on PowerPC the boot loader is supposed to detect
> > the format of the kernel binary and pick the right mode before calling
> > it.
> 
> Is it the intention to allow runtime endian switching on any
> ARM/PowerPC platform (even the Samsung products you mentioned)?  Or
> only on the boards that were designed to operate this way?

Any sane SoC will come without byteswapping on the buses, so that's
trivial to handle. You just have to build kernel and userspace in the
same endianess and have to ensure that all drivers use the correct
accessors that match what the hardware does.

The Samsung platforms get it wrong because they tried to optimize
out the barriers implied by writel, before we had writel_relaxed.
When nobody made a mistake like that, you can run a kernel of either
endianess on any hardware.

> Our problem becomes much simpler if we assume that the majority of
> systems have a fixed endianness, and only a few special cases need to
> accommodate the different kernel/register endianness permutations
> you've listed.

Good point. It seems that there is currently no support for BCM7xxx
in upstream Linux, and that is the only one that has the crazy
strapping pin, so I guess you could avoid a lot of the problems by
changing the MIPS code to assume BE registers, and if anybody wants
to submit BCM7xxx MIPS support to mainline, they have to make sure
it's in the right mode.

	Arnd
