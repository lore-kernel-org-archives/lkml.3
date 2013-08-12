Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab3HLUuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:50:20 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:62446 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3HLUuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:50:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130812200628.GG23006@n2100.arm.linux.org.uk>
References: <5207B3C3.9080508@roeck-us.net> <20130811220450.GY23006@n2100.arm.linux.org.uk>
 <52082EF8.10005@roeck-us.net> <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
 <20130812164548.GE23006@n2100.arm.linux.org.uk> <CAFEAcA97PuORg920f-A_8rvCgBq=k5Y=0W6m2Nv8nnzjY19Utg@mail.gmail.com>
 <20130812200628.GG23006@n2100.arm.linux.org.uk>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 12 Aug 2013 21:49:54 +0100
Message-ID: <CAFEAcA9BA7zfaO1J5zVaEcG-AgOo6dyiew08-o2eObuBe-KWig@mail.gmail.com>
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

On 12 August 2013 21:06, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Aug 12, 2013 at 06:33:28PM +0100, Peter Maydell wrote:
>>     /* Slot to IRQ mapping for RealView EB and PB1176 backplane
>>      *      name    slot    IntA    IntB    IntC    IntD
>>      *      A       31      IRQ50   IRQ51   IRQ48   IRQ49
>>      *      B       30      IRQ49   IRQ50   IRQ51   IRQ48
>>      *      C       29      IRQ48   IRQ49   IRQ50   IRQ51
>>      * Slot C is for the host bridge; A and B the peripherals.
>>      * Our output irqs 0..3 correspond to the baseboard's 48..51.
>>      */
>>
>> ie IRQ48 == board's PCI0 == slot C connector A6 (IntA) == PCI_nINTB
>>    == Slot B connector B8 (IntD) == Slot A connector A7 (IntC).
>>
>> and so on round.
>>
>> The 926's routing is one extra round of swizzling because the
>> board itself connects FPGA P_nINTA to its edge connector's
>> INTB (B7) pin rather than INTA (A6) as the EB/1176 do.
>> (This isn't even hinted at in the documentation, you need to
>> either experiment or look at the 926 board schematic.)
>
> Okay, so the above just adds to the confusion, because you appear to be
> mistaking "slot" for the AD signal which the IDSEL pin is connected to.

The board TRM:
http://infocenter.arm.com/help/topic/com.arm.doc.dui0411d/Cacdijji.html
says that "slot position" and "AD signal connected to IDSEL"
are the same thing:

"The slot positions for PCI cards are numbered from 11 to 31.
 The numbering is based on the address bit that is connected
 to the IDSEL line."

> As I'm seeing a report of a card appearing in slot 0x0d at the top of
> this thread, this doesn't match your numbering above.  So, is slot
> 0x0d slot A or slot B?

Slot 0xd is where the second PCI card QEMU emulates appears.
It doesn't correspond to either A or B in real hardware.
That trace output is the result of running the kernel on QEMU.

On QEMU we put the host at slot 11 (lowest possible) and
then cards at 12, 13, ... because generally people want to
be able to plug in more than two cards. It also improves our
backward-compatiliity with old kernels which assume old broken
QEMU behaviour. This is kind of like modelling a rather
extended (but admittedly fictitious) backplane.

On real hardware the physical "slot A" and "slot B" on
the backplane are 'slot' 31 and 30, and the host appears
at 29.

I don't currently have the h/w set up, but digging in my email
archives, when we were running the kernel on the real PB926
h/w and backplane it was indeed reporting the PCI core (ie
"slot C") as 29, and the other two as 30 and 31:
[  128.920150] PCI core found (slot 29)
[  128.920875] pci 0000:00:1f.0: reg 10: [io  0x0af0-0x0aff]
[  128.920958] pci 0000:00:1f.0: reg 14: [io  0x0a70-0x0a7f]
[  128.921032] pci 0000:00:1f.0: reg 18: [io  0x01f0-0x01ff]
[  128.921103] pci 0000:00:1f.0: reg 1c: [io  0x0170-0x017f]
[  128.921173] pci 0000:00:1f.0: reg 20: [io  0xcc00-0xcc1f]
[  128.921244] pci 0000:00:1f.0: reg 24: [io  0x8c00-0x8cff]
[  128.921320] pci 0000:00:1f.0: reg 30: [mem 0xffff0000-0xffffffff pref]

(that's from two years ago, a 2.6.35.6+ kernel with Arnd's
patchset applied, detecting a SATA card in slot 31).

-- PMM
