Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3GEXfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 19:35:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60869 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3GEXfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 19:35:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave P Martin <Dave.Martin@arm.com>
Subject: Re: scripts/kallsyms: Avoid ARM veneer symbols
Date: Sat, 6 Jul 2013 01:34:56 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dave Martin <dave.martin@linaro.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
References: <2983817.Xe2505Drlj@wuerfel> <201307051842.44721.arnd@arndb.de> <20130705172659.GJ2932@localhost.localdomain>
In-Reply-To: <20130705172659.GJ2932@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307060134.56933.arnd@arndb.de>
X-Provags-ID: V02:K0:SXddoWDN3vx6ddhgH7Qqc1AtHFKc7qG0B1cmj2TCiuN
 PkVjOfAuohhzEKkF5SGp352KlX1+vfUJV+jwInO1TEodmtqfra
 cK4ViYQVWWPs9y0bCH8f7ydVPONpocM/5ZazgG631LaBBSci9A
 /hjVRKzYJt1qdiffbrz9U/lJkBQazQ7aS9TVcxsWvGLuLruUkp
 nGDHc3oqaxGs6IadX9XaAIGSu7G2VloXkn5BqNCR3YU0ZBXGuu
 5QBDRRqzarqdEvIxAIlPzBZson26qyNL4B2YbheM/2WQjStoWX
 GDBsz6C9dzRrZ7aVlqLtxzDtXYSQd9jU7Ew0ogkHAI017Zv+Xo
 XcDLCmA+4RmKCKRjKtcU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 July 2013, Dave P Martin wrote:
> On Fri, Jul 05, 2013 at 05:42:44PM +0100, Arnd Bergmann wrote:
> > On Friday 05 July 2013, Dave P Martin wrote:
> > > On Wed, Jul 03, 2013 at 06:03:04PM +0200, Arnd Bergmann wrote:
> 
> I think there are a small number of patterns to check for.
> 
> __*_veneer, __*_from_arm and __*_from_thumb should cover most cases.

Ok.

> > * There are actually symbols without a name on ARM, which screws up the
> >   kallsyms.c parser. These also seem to be veneers, but attached to some
> >   random function:
> 
> Hmmm, I don't what those are.  By default, we should probably ignore those
> too.  Maybe they have something to do with link-time relocation processing.

Definitely link-time. It only shows up after the final link, and only
with ld.bfd not with ld.gold as I found out now.

> > $ nm obj-tmp/.tmp_vmlinux1 | head
> > c09e8db1 t 
> > c09e8db5 t 
> > c09e8db9 t    # <==========
> > c09e8dbd t 
> > c0abfc29 t 
> > c0008000 t $a
> > c0f7b640 t $a
> > 
> > $ objdump -Dr obj-tmp/.tmp_vmlinux1 | grep -C 30 c09e8db.
> > c0851fcc <wlc_phy_edcrs_lock>:
> > c0851fcc:       b538            push    {r3, r4, r5, lr}
> > c0851fce:       b500            push    {lr}
> > c0851fd0:       f7bb d8dc       bl      c000d18c <__gnu_mcount_nc>
> > c0851fd4:       f240 456b       movw    r5, #1131       ; 0x46b
> > c0851fd8:       4604            mov     r4, r0
> > c0851fda:       f880 14d5       strb.w  r1, [r0, #1237] ; 0x4d5
> > c0851fde:       462a            mov     r2, r5
> > c0851fe0:       f44f 710b       mov.w   r1, #556        ; 0x22c
> > c0851fe4:       f7ff fe6d       bl      c0851cc2 <write_phy_reg>
> > c0851fe8:       4620            mov     r0, r4
> > c0851fea:       462a            mov     r2, r5
> > c0851fec:       f240 212d       movw    r1, #557        ; 0x22d
> > c0851ff0:       f7ff fe67       bl      c0851cc2 <write_phy_reg>
> > c0851ff4:       4620            mov     r0, r4
> > c0851ff6:       f240 212e       movw    r1, #558        ; 0x22e
> > c0851ffa:       f44f 7270       mov.w   r2, #960        ; 0x3c0
> > c0851ffe:       f196 fedb       bl      c09e8db8 <tpci200_free_irq+0x78>  # <===========
> > c0852002:       4620            mov     r0, r4
> > c0852004:       f240 212f       movw    r1, #559        ; 0x22f
> > c0852008:       f44f 7270       mov.w   r2, #960        ; 0x3c0
> > c085200c:       e8bd 4038       ldmia.w sp!, {r3, r4, r5, lr}
> > c0852010:       f7ff be57       b.w     c0851cc2 <write_phy_reg>
> > 
> > 
> > ... # in tpci200_free_irq:
> > c09e8d9e:       e003            b.n     c09e8da8 <tpci200_free_irq+0x68>
> > c09e8da0:       f06f 0415       mvn.w   r4, #21
> > c09e8da4:       e000            b.n     c09e8da8 <tpci200_free_irq+0x68>
> > c09e8da6:       4c01            ldr     r4, [pc, #4]    ; (c09e8dac <tpci200_free_irq+0x6c>)
> > c09e8da8:       4620            mov     r0, r4
> > c09e8daa:       bdf8            pop     {r3, r4, r5, r6, r7, pc}
> > c09e8dac:       fffffe00                        ; <UNDEFINED> instruction: 0xfffffe00
> > c09e8db0:       f4cf b814       b.w     c06b7ddc <bna_enet_sm_chld_stop_wait_entry>
> > c09e8db4:       f53e bed8       b.w     c0727b68 <gem_do_stop>
> > c09e8db8:       f668 bf83       b.w     c0851cc2 <write_phy_reg>           # <==========
> > c09e8dbc:       d101            bne.n   c09e8dc2 <tpci200_free_irq+0x82>
> > c09e8dbe:       f435 b920       b.w     c061e002 <twl_reset_sequence+0x34c>
> > 
> > It makes no sense to me at all that a function in one driver can just call
> > write_phy_reg a couple of times, but need a veneer in the middle, and put
> > that veneer in a totally unrelated function in another driver!
> 
> I think that if ld inserts a veneer for a function anywhere, branches
> from any object in the link to that target symbol can reuse the same
> veneer as a trampoline, effectively appearing to branch through an
> unrelated location to reach the destination.

That part makes sense, but it doesn't explain why ld would do that just
for the third out of four identical function calls in the example above.

> ld inserts veneers between individual input sections, but I don't
> think they have to go next to the same section the branch originates
> from.  In the above code, it looks like that series of unconditional
> branches after the end of tpci200_free_irq might be a common veneer pool
> for many different destinations.

Yes, exactly. In this build I had six of these nameless symbols, and five
of them were in this one function.

> LTO may also make the expected compilation unit boundaries disappear
> completely.  Anything could end up almost anywhere in that case.
> Files could get intermingled, inlined and generally spread all over the
> place.

I'm not sure we actually want to enable that in the kernel ;-)

In particular in combination with kallsyms, it would make the kallsyms
information rather useless when we can no longer infer a function name
from an address.

> Even so, veneers shouldn't be needed in the common case where we're not
> jumping across .rodata.
> 
> > 
> > If this is a binutils bug or gcc bug, we should probably just fix it, but it
> > might be easier to work around it by changing kallsyms.c some more.
> 
> I haven't found a trivial way to reproduce those nameless symbols.
> I don't know whether they're a bug or not...
> 
> Making kallsyms robust against this might be a good idea anyway.

Maybe we can find a binutils expert next week at Linaro connect to take a
look at the data. I can prepare a test case.

	Arnd
