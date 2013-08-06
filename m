Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3HFKkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:40:55 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:47606 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755945Ab3HFKkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:40:53 -0400
Date: Tue, 6 Aug 2013 11:40:24 +0100
From: Dave P Martin <Dave.Martin@arm.com>
To: Roy Franz <roy.franz@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 6/7] Add EFI stub for ARM
Message-ID: <20130806104023.GE2791@e103592.cambridge.arm.com>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
 <1375478948-22562-7-git-send-email-roy.franz@linaro.org>
 <20130805141149.GB2755@localhost.localdomain>
 <20130805153318.GL18151@rocoto.smurfnet.nu>
 <CAFECyb-WciwMu0MBmZ8LzkaM=VxnaOH5e9V5f_AP3ZbLA9CW9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFECyb-WciwMu0MBmZ8LzkaM=VxnaOH5e9V5f_AP3ZbLA9CW9A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 01:06:17AM +0100, Roy Franz wrote:
> On Mon, Aug 5, 2013 at 8:33 AM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> > On Mon, Aug 05, 2013 at 03:11:49PM +0100, Dave Martin wrote:
> >> > diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> >> > index 75189f1..4c70b9e 100644
> >> > --- a/arch/arm/boot/compressed/head.S
> >> > +++ b/arch/arm/boot/compressed/head.S
> >> > @@ -122,19 +122,106 @@
> >> >             .arm                            @ Always enter in ARM state
> >> >  start:
> >> >             .type   start,#function
> >> > -           .rept   7
> >> > +#ifdef CONFIG_EFI_STUB
> >> > +           @ Magic MSDOS signature for PE/COFF + ADD opcode
> >> > +           .word   0x62805a4d

Is BE8 supported?  If so, this would put the bytes

	62 80 5A 4D

in the binary, which is not the right magic.

For this magic, you could use .byte instead.


To help future maintainers, I suggest noting in a comment that
executing through this magic relies on little-endian instruction byte
order (so, LE or BE8), and the ARM instruction set.

What about the endianness of the other PE/COFF header fields?  Are they
always little-endian, or are some fields native-endian (and if so, how
is the endianness of the header determined by the loader)?

> >>
> >> What about BE32?
> >
> > The ARM bindings for UEFI specify that the processor must be in
> > little-endian mode.
> >
> >> In that case, the instruction is a coprocessor load, that loads from a
> >> random address to a coprocessor that almost certainly doesn't exist.
> >> This will probably fault.
> >>
> >> Since BE32 is only for older platforms (<v6) and this is not easily
> >> solvable, it might be sensible to make the EFI stub support depend on
> >> !CPU_ENDIAN_BE32.
> >
> > Well, it would make more sense to make EFI_STUB depend on EFI and
> > EFI depend on !CPU_ENDIAN_BE32. Which is something I can add to
> > my next set of general ARM UEFI patches. Thanks.
> > /
> >     Leif
> 
> I had EFI_STUB depend on EFI at one point during my development, but took
> it out because there was no actual dependency (the stub will work fine without
> other EFI features.)  The features will most likely be used together,
> but I wasn't
> sure if we would want to enforce this with a config dependency.  I
> don't care one
> way or the other, I'd just like the dependencies to be correct and
> follow best practices.

I guess it's up to you, so long as the constraint is expressed in Kconfig
somehow.

Cheers
---Dave
