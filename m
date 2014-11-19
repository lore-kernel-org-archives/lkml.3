Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaKSSWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:22:51 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:56875 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbaKSSWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:22:50 -0500
Date: Wed, 19 Nov 2014 13:22:46 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC] ARM: option for loading modules into vmalloc area
In-Reply-To: <CAKv+Gu-q7Vdd=Buaz2x=8HASCpeY5D-RsOm-120bkOqmgtUeTw@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1411191312110.11690@knanqh.ubzr>
References: <20141118173413.GB4042@n2100.arm.linux.org.uk> <546B8C64.3010904@samsung.com> <2041617.Kxhx5O4MMr@wuerfel> <CAKv+Gu-8qhHYOry+LsDzp+LDZqYxVZ5G7cj48E3G2Unp2+=_yg@mail.gmail.com> <CALYGNiMt2A3DP02cOtxqu4RrnmhojrDxkRG7bkHMByUnzG+PeA@mail.gmail.com>
 <CAKv+Gu-rYWutr-45MsZH6KOhhUyNCVLfkO9JQrqCm1L6ms_DUg@mail.gmail.com> <20141119160747.GH4042@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1411191130480.11690@knanqh.ubzr> <20141119164902.GK4042@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1411191152340.11690@knanqh.ubzr>
 <20141119165948.GM4042@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1411191205530.11690@knanqh.ubzr> <CAKv+Gu-q7Vdd=Buaz2x=8HASCpeY5D-RsOm-120bkOqmgtUeTw@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Ard Biesheuvel wrote:

> On 19 November 2014 18:12, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > On Wed, 19 Nov 2014, Russell King - ARM Linux wrote:
> >
> >> On Wed, Nov 19, 2014 at 11:57:15AM -0500, Nicolas Pitre wrote:
> >> > On Wed, 19 Nov 2014, Russell King - ARM Linux wrote:
> >> > > I don't think I ever did, because its pretty much impossible to do as I
> >> > > explained in a follow up to this thread.
> >> > >
> >> > > We _used_ to do this with the userspace insmod methods, but since we got
> >> > > this kernel-side linker, it's been pretty much impossible to do without
> >> > > rewriting the module code.  That's not going to happen on account of one
> >> > > quirky architecture which Linus doesn't particularly like.
> >> >
> >> > Still... We could try adding a hook in the generic module linker code
> >> > for a pre-relocation pass.  Maybe only ARM would use it, but if the need
> >> > to load big modules is real then I imagine Linus could be amenable to a
> >> > compromise.
> >>
> >> So, how big a table would you allocate for the trampolines, based upon
> >> not knowing anything about the module being loaded?  4K?  8K?  64K?
> >
> > The idea of a pre-relocation pass is to determine that.  That could be
> > something similar to calling apply_relocate() twice: once to determine
> > the number of trampoline entries, and a second time to perform the
> > actual relocation.
> >
> 
> Well, the veneers shouldn't take more than 3 words each, right?
> 
> ldr ip, [pc]
> bx ip
> .long symbol

You could possibly do:

 ldr pc, [pc, #-4]
 .long symbol

Or, as RMK suggested a while ago:

.rep 8
ldr pc, [pc, #(32 - 8)]
.endr
.long sym1, sym2, sym3, sym4, sym5, sym6, sym7, sym8

The later is much nicer on the i and d caches.

> and you would need at most one veneer per unique external symbol
> referenced by one or more R_ARM_CALL relocations. Is there no way to
> just add that to the static mem footprint as padding, and let the
> loader populate it as needed at module relocation time?

That's the actual question: how much padding do you need?  Everything 
converge to that very problem.  We need to determine it without too much 
impact on the generic module loader code.


Nicolas
