Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3GHKAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 06:00:23 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53128 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751045Ab3GHKAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 06:00:21 -0400
Date: Mon, 8 Jul 2013 10:59:40 +0100
From: Dave P Martin <Dave.Martin@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Marek <mmarek@suse.cz>, Dave Martin <dave.martin@linaro.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: scripts/kallsyms: Avoid ARM veneer symbols
Message-ID: <20130708095940.GB2906@localhost.localdomain>
References: <2983817.Xe2505Drlj@wuerfel>
 <201307051842.44721.arnd@arndb.de>
 <20130705172659.GJ2932@localhost.localdomain>
 <201307060134.56933.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201307060134.56933.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 01:34:56AM +0200, Arnd Bergmann wrote:
> On Friday 05 July 2013, Dave P Martin wrote:
> > On Fri, Jul 05, 2013 at 05:42:44PM +0100, Arnd Bergmann wrote:
> > > On Friday 05 July 2013, Dave P Martin wrote:
> > > > On Wed, Jul 03, 2013 at 06:03:04PM +0200, Arnd Bergmann wrote:
> > 
> > I think there are a small number of patterns to check for.
> > 
> > __*_veneer, __*_from_arm and __*_from_thumb should cover most cases.
> 
> Ok.
> 
> > > * There are actually symbols without a name on ARM, which screws up the
> > >   kallsyms.c parser. These also seem to be veneers, but attached to some
> > >   random function:
> > 
> > Hmmm, I don't what those are.  By default, we should probably ignore those
> > too.  Maybe they have something to do with link-time relocation processing.
> 
> Definitely link-time. It only shows up after the final link, and only
> with ld.bfd not with ld.gold as I found out now.
> 
> > > $ nm obj-tmp/.tmp_vmlinux1 | head
> > > c09e8db1 t 
> > > c09e8db5 t 
> > > c09e8db9 t    # <==========
> > > c09e8dbd t 
> > > c0abfc29 t 
> > > c0008000 t $a
> > > c0f7b640 t $a
> > > 
> > > $ objdump -Dr obj-tmp/.tmp_vmlinux1 | grep -C 30 c09e8db.
> > > c0851fcc <wlc_phy_edcrs_lock>:
> > > c0851fcc:       b538            push    {r3, r4, r5, lr}
> > > c0851fce:       b500            push    {lr}
> > > c0851fd0:       f7bb d8dc       bl      c000d18c <__gnu_mcount_nc>
> > > c0851fd4:       f240 456b       movw    r5, #1131       ; 0x46b
> > > c0851fd8:       4604            mov     r4, r0
> > > c0851fda:       f880 14d5       strb.w  r1, [r0, #1237] ; 0x4d5
> > > c0851fde:       462a            mov     r2, r5
> > > c0851fe0:       f44f 710b       mov.w   r1, #556        ; 0x22c
> > > c0851fe4:       f7ff fe6d       bl      c0851cc2 <write_phy_reg>
> > > c0851fe8:       4620            mov     r0, r4
> > > c0851fea:       462a            mov     r2, r5
> > > c0851fec:       f240 212d       movw    r1, #557        ; 0x22d
> > > c0851ff0:       f7ff fe67       bl      c0851cc2 <write_phy_reg>
> > > c0851ff4:       4620            mov     r0, r4
> > > c0851ff6:       f240 212e       movw    r1, #558        ; 0x22e
> > > c0851ffa:       f44f 7270       mov.w   r2, #960        ; 0x3c0
> > > c0851ffe:       f196 fedb       bl      c09e8db8 <tpci200_free_irq+0x78>  # <===========
> > > c0852002:       4620            mov     r0, r4
> > > c0852004:       f240 212f       movw    r1, #559        ; 0x22f
> > > c0852008:       f44f 7270       mov.w   r2, #960        ; 0x3c0
> > > c085200c:       e8bd 4038       ldmia.w sp!, {r3, r4, r5, lr}
> > > c0852010:       f7ff be57       b.w     c0851cc2 <write_phy_reg>
> > > 
> > > 
> > > ... # in tpci200_free_irq:
> > > c09e8d9e:       e003            b.n     c09e8da8 <tpci200_free_irq+0x68>
> > > c09e8da0:       f06f 0415       mvn.w   r4, #21
> > > c09e8da4:       e000            b.n     c09e8da8 <tpci200_free_irq+0x68>
> > > c09e8da6:       4c01            ldr     r4, [pc, #4]    ; (c09e8dac <tpci200_free_irq+0x6c>)
> > > c09e8da8:       4620            mov     r0, r4
> > > c09e8daa:       bdf8            pop     {r3, r4, r5, r6, r7, pc}
> > > c09e8dac:       fffffe00                        ; <UNDEFINED> instruction: 0xfffffe00
> > > c09e8db0:       f4cf b814       b.w     c06b7ddc <bna_enet_sm_chld_stop_wait_entry>
> > > c09e8db4:       f53e bed8       b.w     c0727b68 <gem_do_stop>
> > > c09e8db8:       f668 bf83       b.w     c0851cc2 <write_phy_reg>           # <==========
> > > c09e8dbc:       d101            bne.n   c09e8dc2 <tpci200_free_irq+0x82>
> > > c09e8dbe:       f435 b920       b.w     c061e002 <twl_reset_sequence+0x34c>
> > > 
> > > It makes no sense to me at all that a function in one driver can just call
> > > write_phy_reg a couple of times, but need a veneer in the middle, and put
> > > that veneer in a totally unrelated function in another driver!
> > 
> > I think that if ld inserts a veneer for a function anywhere, branches
> > from any object in the link to that target symbol can reuse the same
> > veneer as a trampoline, effectively appearing to branch through an
> > unrelated location to reach the destination.
> 
> That part makes sense, but it doesn't explain why ld would do that just
> for the third out of four identical function calls in the example above.
> 
> > ld inserts veneers between individual input sections, but I don't
> > think they have to go next to the same section the branch originates
> > from.  In the above code, it looks like that series of unconditional
> > branches after the end of tpci200_free_irq might be a common veneer pool
> > for many different destinations.
> 
> Yes, exactly. In this build I had six of these nameless symbols, and five
> of them were in this one function.
> 
> > LTO may also make the expected compilation unit boundaries disappear
> > completely.  Anything could end up almost anywhere in that case.
> > Files could get intermingled, inlined and generally spread all over the
> > place.
> 
> I'm not sure we actually want to enable that in the kernel ;-)
> 
> In particular in combination with kallsyms, it would make the kallsyms
> information rather useless when we can no longer infer a function name
> from an address.

Well, indeed.  But that's a separate discussion -- I don't think we want
to block it needlessly just due to an obscure feature of the ARM toolchain.

Ignoring veneers and nameless symbols in kallsyms sounds like a reasonable
approach for now, even if it's not a perfect.

> > Even so, veneers shouldn't be needed in the common case where we're not
> > jumping across .rodata.
> > 
> > > 
> > > If this is a binutils bug or gcc bug, we should probably just fix it, but it
> > > might be easier to work around it by changing kallsyms.c some more.
> > 
> > I haven't found a trivial way to reproduce those nameless symbols.
> > I don't know whether they're a bug or not...
> > 
> > Making kallsyms robust against this might be a good idea anyway.
> 
> Maybe we can find a binutils expert next week at Linaro connect to take a
> look at the data. I can prepare a test case.

Sure, that could be worth a try.

Cheers
---Dave
