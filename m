Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaKZJqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:46:09 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:39976 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaKZJqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:46:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAJiQ=7CvpFWxDY1uad2bZz8MBG0Mvg2Jx8WBp6gHi-kD4TDvXA@mail.gmail.com>
References: <1416796846-28149-1-git-send-email-cernekee@gmail.com>
 <1416796846-28149-7-git-send-email-cernekee@gmail.com> <CAOiHx=ntm7AO5BU2Ge0JDC5nDgXSZwQDm05s5VTM8mLqYmCZRw@mail.gmail.com>
 <CAJiQ=7CvpFWxDY1uad2bZz8MBG0Mvg2Jx8WBp6gHi-kD4TDvXA@mail.gmail.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Wed, 26 Nov 2014 10:45:35 +0100
Message-ID: <CAOiHx=m+At9u=eepphG89kcusOKbBi1qqxT8k-Qyx-OMdMAJKw@mail.gmail.com>
Subject: Re: [PATCH V3 06/11] irqchip: bcm7120-l2: Change DT binding to allow
 non-contiguous IRQEN/IRQSTAT
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Brian Norris <computersforpeace@gmail.com>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 6:18 AM, Kevin Cernekee <cernekee@gmail.com> wrote:
> On Mon, Nov 24, 2014 at 6:31 AM, Jonas Gorski <jogo@openwrt.org> wrote:
>> On Mon, Nov 24, 2014 at 3:40 AM, Kevin Cernekee <cernekee@gmail.com> wrote:
>>> To date, all supported controllers have had the IRQEN register at offset
>>> 0x00 and the IRQSTAT register at 0x04.  So in DT we would typically see
>>> something like:
>>>
>>>     reg = <0xf0406800 0x8>;
>>>
>>> We still want to support this format, but we also need to support cases
>>> where IRQEN and IRQSTAT aren't adjacent.  So, we will amend the driver to
>>> accept an alternate format that looks like this:
>>>
>>>     reg = <0xf0406800 0x4 0xf0406804 0x4>;
>>>
>>> i.e. if the first resource_size() == 4, assume that the first resource
>>> points to IRQEN and that the next resource points to IRQSTAT.  If the
>>> first resource_size() == 8, retain the current behavior.
>>>
>>> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
>>
>> Hmm ... the more I think about this, the less I like it.
>>
>> Using the amount and size of the reg-properties to infer a certain
>> layout seems rather hackish and dirty to me. Maybe we should just use
>> different compatible match ids for that? E.g. brcm,bm7120-l2-intc for
>> the 32-bit en/stat pairs, and e.g. brcm,bcm6368-l2-intc for the 64-bit
>> wide one. Or maybe make the bcm63xx one a separate driver and let it
>> share code with the bcm7120-l2-intc driver.
>
> In my current proposal, it is easy to specify an arbitrary number of
> enable/status pairs located in any order and spread across different
> parts of the register space.  Even register indices (0,2,4,...) are
> enable registers, and odd register indices are status registers.
>
> If I'm interpreting your post correctly, you don't agree that we need
> this level of flexibility.  But looking over the register listings,
> here are the cases we need to cover:
>
>
> 6828,6318: 4x mask(exthi,extlo,hi,lo),status(exthi,extlo,hi,lo)
>
> TP0ExtIrqMaskHi
> TP0ExtIrqMaskLo
> TP0IrqMaskHi
> TP0IrqMaskLo
> TP0ExtIrqStatusHi
> TP0ExtIrqStatusLo
> TP0IrqStatusHi
> TP0IrqStatusLo
>
> TP1ExtIrqMaskHi
> TP1ExtIrqMaskLo
> ...
>
>
> 6816,6362,6328: 2x extmask,mask,extstatus,status
>
> ExtraChipIrqMask
> ChipIrqMask
> ExtraChipIrqStatus
> ChipIrqStatus
> ExtraChipIrqMask1 [1=TP1]
> ChipIrqMask1
> ExtraChipIrqStatus1
> ChipIrqStatus1
>
>
> 6368: similar to above, but with yet another naming convention:
>
> IRQMASK_MIPS0_Hi
> IRQMASK_MIPS0_Lo
> IRQSTATUS_MIPS0_Hi
> IRQSTATUS_MIPS0_Lo
> IRQMASK_MIPS1_Hi
> IRQMASK_MIPS1_Lo
> IRQSTATUS_MIPS1_Hi
> IRQSTATUS_MIPS1_Lo
>
> 6838,3384: interleaved "mystery meat" mask/status (same IRQ source
> names, with the output of each bcm7120-l2 routed to several different
> processors/threads):
>
> PeriphIRQMASK0
> PeriphIRQSTATUS0
> PeriphIRQMASK1 <- mine, if running on Zephyr
> PeriphIRQSTATUS1 <- mine, if running on Zephyr
> PeriphIRQMASK2
> PeriphIRQSTATUS2
> PeriphIRQMASK3 <- mine, if running on Viper
> PeriphIRQSTATUS3 <- mine, if running on Viper
>
> But wait, there's more!  There wasn't enough space in this block for
>>32 IRQ bits, so the upper bits spilled over into a separate
> "INT_EXT_PER" block that lives elsewhere in the register space:
>
> PeriphIRQMASK0_2
> PeriphIRQSTATUS0_2
> PeriphIRQMASK1_2 <- mine, if running on Zephyr
> PeriphIRQSTATUS1_2 <- mine, if running on Zephyr
> PeriphIRQMASK2_2
> PeriphIRQSTATUS2_2
> PeriphIRQMASK3_2 <- mine, if running on Viper
> PeriphIRQSTATUS3_2 <- mine, if running on Viper
>
> The "INT_PER" and "INT_EXT_PER" outputs are ORed into the same MIPS
> IRQ lines, so we need to treat them as two sides of a single
> controller.  AFAICT, unlike a shared device IRQ, there is no way to
> share a MIPS IRQ line between two controller instances.
>
> Additionally, we have a few other random MASK/STATUS pairs scattered
> around (ZMIPS, CMIPS blocks), and then we also have DQM IRQs with
> multiple mask registers + single status register:
>
> CMIPS_NOT_EMPTY_IRQ_MSK
> CMIPS1_NOT_EMPTY_IRQ_MSK <- mine, if running on Viper
> ZMIPS_NOT_EMPTY_IRQ_MSK <- mine, if running on Zephyr
> PMC_NOT_EMPTY_IRQ_MSK
> DFAP_NOT_EMPTY_IRQ_MSK
> NOT_EMPTY_IRQ_STS

There are also 63268 and 6828, which follow the 6318/6328 layout;
6818, which follows the 6368 layout, as well as 6358 (Yes I know, very
unlikely to ever get SMP support due to its stupid shared TLB design):

IrqMask
IrqStatus
(several unrelated registers)
IrqMask1
IrqStatus1

and 63381:

IrqStatusHi
IrqStatusLo
ExtIrqStatusHi
ExtIrqStatusLo
IrqMask0Hi
IrqMask0Lo
ExtIrqMask0Hi
ExtIrqMask0Lo
IrqMask1Hi
IrqMask1Lo
ExtIrqMask1Hi
ExtIrqMask1Lo

I see also a 60333, which has three 32bit Mask/Status pairs per
thread, also none of the higher irqs seem to be used according to
_intr.h).

> I suppose another alternative is to ioremap() a range large enough to
> cover enable + status, and then specify the offset of each one in
> another property.  This does run the risk of overlapping mappings.
>
>> This would avoid having to specify a lot of regs (let's assume we also
>> add support for affinity)
>
> I concede that I have no idea how affinity should be handled here.
> AFAICT it is completely off limits on BCM3384 because we just don't
> have enough L2 outputs to offer proper masking for all of the
> threads/CPUs in the system.

Affinity support is "easy"; expect one set of registers for each
output irq specified, and if there is only one, then we don't support
it / fill the affinity pointers.

> Perhaps we could write a simple, SMP-capable driver for the
> saner/newer SoCs, and use the flexible-but-non-SMP version for the
> complicated ones.

As far as I can see, we have three distinct layouts here:

a) An arbitrary number of 32-bit Mask/Status-pairs (3384/6838). No per
thread support (well, not sure about 60333).

b) An arbitrary length (32 to 128 bit) Mask register, followed by a
same length Status register (63xx except 63381, 6818, 6828); repeated
for each thread.

c) A single arbitrary length (currently only 128 bit) Status register,
followed by per thread same length Mask registers (63381).

On a first glance this could translate to three distinct
drivers/compatible properties, where each expects different reg = <>;
contents.

For a), it should be enough to expand the current 7120-l2 driver to
accept/use more than one 0x8 length register, which should simplify
the register map setup.

For b) we could add a a new compatible name (maybe bcm6358-l2, because
that was AFAICT the first one with blocks) that will use the 8 to 32
byte length regs (one for each block). For now we could ignore the SMP
capability of it and make it a variant of the 7120-l2 driver, and when
we add SMP support, split it into a second different driver if we want
to avoid having all the spinlock for register accesses even for a).

We could then even easily document/add the extra block registers /
interrrupts in documentation / the dtsi files before actually
supporting them, because we only have a fixed amount of regs/irqs to
expect in the !SMP case and can easily ignore the extra
registers/interrupts.

For c) we could add a a third compatible name (bcm63381-l2), also with
its own setup routine. I would guess it doesn't matter if both
thread's irqstatus register pointers point to the same region.

>> and cause a lot of io(re)map calls
>
> Is the ioremap() call really that big of a deal?
>
> On MIPS it's basically computing CKSEG1ADDR(phys_addr).  On ARM, the
> top level (with 64 to 128+ IRQs) goes through the GIC.  On both,
> ioremap() is a one-time cost at startup.

For a single driver it probably doesn't hurt that much, but AFAIK
these are also stored in a table, so if all drivers did this, the
table easily becomes huge. This isn't a very strong argument, just
more a smaller nitpick.


Jonas
