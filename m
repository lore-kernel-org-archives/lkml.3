Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3HLVgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 17:36:41 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:51110 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3HLVgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 17:36:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130812212149.GH23006@n2100.arm.linux.org.uk>
References: <5207B3C3.9080508@roeck-us.net> <20130811220450.GY23006@n2100.arm.linux.org.uk>
 <52082EF8.10005@roeck-us.net> <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
 <20130812164548.GE23006@n2100.arm.linux.org.uk> <CAFEAcA97PuORg920f-A_8rvCgBq=k5Y=0W6m2Nv8nnzjY19Utg@mail.gmail.com>
 <20130812200628.GG23006@n2100.arm.linux.org.uk> <CAFEAcA9BA7zfaO1J5zVaEcG-AgOo6dyiew08-o2eObuBe-KWig@mail.gmail.com>
 <20130812212149.GH23006@n2100.arm.linux.org.uk>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 12 Aug 2013 22:36:17 +0100
Message-ID: <CAFEAcA_0kzS=Z5oTxrr=B74wjf1x=M6dXwH7Fcgf77Pca90Gjw@mail.gmail.com>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        qemu-devel@nongnu.org, Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2013 22:21, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Aug 12, 2013 at 09:49:54PM +0100, Peter Maydell wrote:
>> On 12 August 2013 21:06, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Mon, Aug 12, 2013 at 06:33:28PM +0100, Peter Maydell wrote:
>> >>     /* Slot to IRQ mapping for RealView EB and PB1176 backplane
>> >>      *      name    slot    IntA    IntB    IntC    IntD
>> >>      *      A       31      IRQ50   IRQ51   IRQ48   IRQ49
>> >>      *      B       30      IRQ49   IRQ50   IRQ51   IRQ48
>> >>      *      C       29      IRQ48   IRQ49   IRQ50   IRQ51
>> >>      * Slot C is for the host bridge; A and B the peripherals.
>> >>      * Our output irqs 0..3 correspond to the baseboard's 48..51.
>> >>      */
>> >>
>> >> ie IRQ48 == board's PCI0 == slot C connector A6 (IntA) == PCI_nINTB
>> >>    == Slot B connector B8 (IntD) == Slot A connector A7 (IntC).
>> >>
>> >> and so on round.
>> >>
>> >> The 926's routing is one extra round of swizzling because the
>> >> board itself connects FPGA P_nINTA to its edge connector's
>> >> INTB (B7) pin rather than INTA (A6) as the EB/1176 do.
>> >> (This isn't even hinted at in the documentation, you need to
>> >> either experiment or look at the 926 board schematic.)
>> >
>> > Okay, so the above just adds to the confusion, because you appear to be
>> > mistaking "slot" for the AD signal which the IDSEL pin is connected to.
>>
>> The board TRM:
>> http://infocenter.arm.com/help/topic/com.arm.doc.dui0411d/Cacdijji.html
>> says that "slot position" and "AD signal connected to IDSEL"
>> are the same thing:
>
> That's realview, not versatile.  Are you saying that both are exactly
> the same wrt this?

On this point, yes. Equivalent bit from the PB926 TRM:
http://infocenter.arm.com/help/topic/com.arm.doc.dui0224i/Cacdijji.html

(There are differences between the PCI controllers on
the different boards. Differences I know of are:
 * size of the three memory mapped regions
 * whether the top bits of the PCI address come from the top
   or bottom of the IMAP* registers
I believe (based on some experimentation and an educated guess)
that these both changed at the same point, but some of the board
TRMs claim to be part one way part the other, presumably due to
copy and paste error. In particular PB1176's TRM has a mangled
description of the IMAP* registers which didn't match what the
h/w actually did in my testing.)

>> I don't currently have the h/w set up, but digging in my email
>> archives, when we were running the kernel on the real PB926
>> h/w and backplane it was indeed reporting the PCI core (ie
>> "slot C") as 29, and the other two as 30 and 31:
>> [  128.920150] PCI core found (slot 29)
>> [  128.920875] pci 0000:00:1f.0: reg 10: [io  0x0af0-0x0aff]
>> [  128.920958] pci 0000:00:1f.0: reg 14: [io  0x0a70-0x0a7f]
>> [  128.921032] pci 0000:00:1f.0: reg 18: [io  0x01f0-0x01ff]
>> [  128.921103] pci 0000:00:1f.0: reg 1c: [io  0x0170-0x017f]
>> [  128.921173] pci 0000:00:1f.0: reg 20: [io  0xcc00-0xcc1f]
>> [  128.921244] pci 0000:00:1f.0: reg 24: [io  0x8c00-0x8cff]
>> [  128.921320] pci 0000:00:1f.0: reg 30: [mem 0xffff0000-0xffffffff pref]
>
> With realview or versatile?

Versatile (PB926).

This one's Realview (PB1176), card in slot B:

[   35.619169] PCI core found (slot 29)
[   35.620294] PCI: bus0: Fast back to back transfers enabled
[   35.621041] PCI new map irq: slot 30, pin 1, devslot 30, irq: 76
[   35.621173] pci 0000:00:1e.0: BAR 6: assigned [mem
0x68000000-0x6800ffff pref]
[   35.621251] pci 0000:00:1e.0: BAR 5: assigned [io  0x1000-0x10ff]
[   35.621329] pci 0000:00:1e.0: BAR 5: set to [io  0x1000-0x10ff]
(PCI address [0x1000-0x10ff]
[   35.621406] pci 0000:00:1e.0: BAR 4: assigned [io  0x1400-0x141f]
[   35.621479] pci 0000:00:1e.0: BAR 4: set to [io  0x1400-0x141f]
(PCI address [0x1400-0x141f]
[   35.621556] pci 0000:00:1e.0: BAR 0: assigned [io  0x1420-0x142f]
[   35.621628] pci 0000:00:1e.0: BAR 0: set to [io  0x1420-0x142f]
(PCI address [0x1420-0x142f]
[   35.621706] pci 0000:00:1e.0: BAR 1: assigned [io  0x1430-0x143f]
[   35.621779] pci 0000:00:1e.0: BAR 1: set to [io  0x1430-0x143f]
(PCI address [0x1430-0x143f]
[   35.621856] pci 0000:00:1e.0: BAR 2: assigned [io  0x1440-0x144f]
[   35.621929] pci 0000:00:1e.0: BAR 2: set to [io  0x1440-0x144f]
(PCI address [0x1440-0x144f]
[   35.622007] pci 0000:00:1e.0: BAR 3: assigned [io  0x1450-0x145f]
[   35.622079] pci 0000:00:1e.0: BAR 3: set to [io  0x1450-0x145f]
(PCI address [0x1450-0x145f]

[nb that this is from trace from a buggy kernel, the irq
is wrong and the card doesn't work.]

-- PMM
