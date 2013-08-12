Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab3HLRdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:33:52 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35646 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab3HLRdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:33:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130812164548.GE23006@n2100.arm.linux.org.uk>
References: <5207B3C3.9080508@roeck-us.net> <20130811220450.GY23006@n2100.arm.linux.org.uk>
 <52082EF8.10005@roeck-us.net> <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
 <20130812164548.GE23006@n2100.arm.linux.org.uk>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 12 Aug 2013 18:33:28 +0100
Message-ID: <CAFEAcA97PuORg920f-A_8rvCgBq=k5Y=0W6m2Nv8nnzjY19Utg@mail.gmail.com>
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

On 12 August 2013 17:45, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Aug 12, 2013 at 05:24:50PM +0100, Peter Maydell wrote:
>> On 12 August 2013 01:40, Guenter Roeck <linux@roeck-us.net> wrote:
>> > On 08/11/2013 03:04 PM, Russell King - ARM Linux wrote:
>> >> It could be that it's qemu's PCI routing is wrong - it's not the first
>> >> time that qemu has got something wrong.
>>
>> QEMU 1.5 has had its Versatile PCI routing code rewritten to
>> correspond with the hardware (cross-tested versus Arnd Bergmann's
>> patchset
>> http://marc.info/?l=linux-arm-kernel&m=128707282403376&w=2
>> which was run on real versatilePB backplane hardware and
>> could handle a PCI SATA card). I believe it to be correct,
>> and I spent a fairly long time wading through the various bits
>> of documentation and testing those kernel patches on h/w.
>
> The documentation is totally useless - I've been through it several times
> and it just doesn't give the necessary information to work out what the
> routing actually is.

I agree that the TRMs are rather unhelpful.

>  The only place that's documented is in the circuits,
> which are impossible to get hold of (even asking ARM for them doesn't get
> anywhere: basically, all information has been destroyed.)

The circuit diagrams are definitely not lost or destroyed; the
PDF is on my monitor as I type (and as I say I checked against
it when I was doing the QEMU patches and helping Arnd test his
patches.

> In other words, if you have the circuit diagrams or other documentation
> which definitively identifies the wiring, then please send it to me.

I may have been misremembering their confidential/non-confidential
status; I will check. In the meantime, Figure D2 in HBI-0140:
http://infocenter.arm.com/help/topic/com.arm.doc.dui0411d/Babddfca.html#BABHICAG
has labels which give an interrupt wiring of the backplane which
matches the schematics I have (though the wires that have been
drawn between them are obviously wrong). To interpret the diagram
you have to know that the four points on each slot that the PCI_nINT*
signals there attach to the slot correspond to the usual arrangement
of the INT pins on a PCI slot:
http://en.wikipedia.org/wiki/Conventional_PCI#Connector_pinout
ie the left side ones are B7 and B8, the right ones A6 and A7.
The board connects to slot C, which is enough to validate the
table I give in the QEMU code for the EB/1176:

    /* Slot to IRQ mapping for RealView EB and PB1176 backplane
     *      name    slot    IntA    IntB    IntC    IntD
     *      A       31      IRQ50   IRQ51   IRQ48   IRQ49
     *      B       30      IRQ49   IRQ50   IRQ51   IRQ48
     *      C       29      IRQ48   IRQ49   IRQ50   IRQ51
     * Slot C is for the host bridge; A and B the peripherals.
     * Our output irqs 0..3 correspond to the baseboard's 48..51.
     */

ie IRQ48 == board's PCI0 == slot C connector A6 (IntA) == PCI_nINTB
   == Slot B connector B8 (IntD) == Slot A connector A7 (IntC).

and so on round.

The 926's routing is one extra round of swizzling because the
board itself connects FPGA P_nINTA to its edge connector's
INTB (B7) pin rather than INTA (A6) as the EB/1176 do.
(This isn't even hinted at in the documentation, you need to
either experiment or look at the 926 board schematic.)

This is validated by the fact that if you make the kernel assume
the swizzling is like this then it can successfully drive
PCI cards on hardware, whereas if you don't then it won't.

-- PMM
