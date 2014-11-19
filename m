Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaKSQhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:37:54 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:53645 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbaKSQhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:37:51 -0500
Date: Wed, 19 Nov 2014 11:37:47 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC] ARM: option for loading modules into vmalloc area
In-Reply-To: <20141119160747.GH4042@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.11.1411191130480.11690@knanqh.ubzr>
References: <20141118172146.3784.81151.stgit@buzz> <20141118173413.GB4042@n2100.arm.linux.org.uk> <546B8C64.3010904@samsung.com> <2041617.Kxhx5O4MMr@wuerfel> <CAKv+Gu-8qhHYOry+LsDzp+LDZqYxVZ5G7cj48E3G2Unp2+=_yg@mail.gmail.com>
 <CALYGNiMt2A3DP02cOtxqu4RrnmhojrDxkRG7bkHMByUnzG+PeA@mail.gmail.com> <CAKv+Gu-rYWutr-45MsZH6KOhhUyNCVLfkO9JQrqCm1L6ms_DUg@mail.gmail.com> <20141119160747.GH4042@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Russell King - ARM Linux wrote:

> On Wed, Nov 19, 2014 at 05:02:40PM +0100, Ard Biesheuvel wrote:
> > On 19 November 2014 16:52, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> > > Do you mean ldr pc, =symbol ?
> > >
> > > In this case I get this error:
> > >
> > > /tmp/ccAHtONU.s: Assembler messages:
> > > /tmp/ccAHtONU.s:220: Error: invalid literal constant: pool needs to be closer
> > >
> > > Probably constant pool doesn't work well in inline assembly.
> > >
> > >
> > > Something like this seems work:
> > >
> > > add     lr, pc, #4
> > > ldr       pc, [pc, #-4]
> > > .long symbol
> > >
> > 
> > You can add a '.ltorg' instruction which tells the assembler to dump
> > the literal pool, but you still need to jump over it, i.e.,
> > 
> > adr lr, 0f
> > ldr pc, =symbol
> > .ltorg
> > 0:
> 
> Which is not a good idea either, because the compiler needs to know how
> far away its own manually generated literal pool is from the instructions
> which reference it.  The .ltorg statement can end up emitting any number
> of literals at that point, which makes it indeterminant how many words
> are contained within the asm() statement.
> 
> Yes, it isn't desirable to waste an entire data cache line per indirect
> call like the original quote above, but I don't see a practical
> alternative.

Modules could be built without far calls by default, and then the module 
linker would only have to redirect those calls whose destination is too 
far away to a dynamically created trampoline table.

If I remember correctly you even posted some patches to that effect a 
couple years ago.  Maybe those could be salvaged?

I would largely recommend a solution where the link process could deal 
with it automatically and as needed rather than sprinkling yet more 
manually maintained macros into assembly code.


Nicolas
