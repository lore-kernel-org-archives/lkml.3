Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3HLUGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:06:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41262 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3HLUGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:06:48 -0400
Date: Mon, 12 Aug 2013 21:06:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        qemu-devel@nongnu.org, Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
Message-ID: <20130812200628.GG23006@n2100.arm.linux.org.uk>
References: <5207B3C3.9080508@roeck-us.net> <20130811220450.GY23006@n2100.arm.linux.org.uk> <52082EF8.10005@roeck-us.net> <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com> <20130812164548.GE23006@n2100.arm.linux.org.uk> <CAFEAcA97PuORg920f-A_8rvCgBq=k5Y=0W6m2Nv8nnzjY19Utg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA97PuORg920f-A_8rvCgBq=k5Y=0W6m2Nv8nnzjY19Utg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 06:33:28PM +0100, Peter Maydell wrote:
>     /* Slot to IRQ mapping for RealView EB and PB1176 backplane
>      *      name    slot    IntA    IntB    IntC    IntD
>      *      A       31      IRQ50   IRQ51   IRQ48   IRQ49
>      *      B       30      IRQ49   IRQ50   IRQ51   IRQ48
>      *      C       29      IRQ48   IRQ49   IRQ50   IRQ51
>      * Slot C is for the host bridge; A and B the peripherals.
>      * Our output irqs 0..3 correspond to the baseboard's 48..51.
>      */
> 
> ie IRQ48 == board's PCI0 == slot C connector A6 (IntA) == PCI_nINTB
>    == Slot B connector B8 (IntD) == Slot A connector A7 (IntC).
> 
> and so on round.
> 
> The 926's routing is one extra round of swizzling because the
> board itself connects FPGA P_nINTA to its edge connector's
> INTB (B7) pin rather than INTA (A6) as the EB/1176 do.
> (This isn't even hinted at in the documentation, you need to
> either experiment or look at the 926 board schematic.)

Okay, so the above just adds to the confusion, because you appear to be
mistaking "slot" for the AD signal which the IDSEL pin is connected to.

As I'm seeing a report of a card appearing in slot 0x0d at the top of
this thread, this doesn't match your numbering above.  So, is slot
0x0d slot A or slot B?

If we assume that slot A is indeed has IDSEL connected to AD31, then
that surely makes it slot 20 (AD11 + 20 = 31) and slot B = 19.  So
why do we apparantly have a card in a non-existent slot at 13?

Now, it looks to me like we have the rotation in the right direction,
it's just a matter of ensuring that we have the right starting point.
That's where we need to know what slot number Linux believes slot A
and slot B actually are.
