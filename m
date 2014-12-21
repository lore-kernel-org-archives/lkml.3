Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaLUK5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 05:57:38 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:56735 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaLUK5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 05:57:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAOiHx=m9RzU5n2fjJcph6u=avUAEZJYw0-mBCSMRzDJvSD5CFA@mail.gmail.com>
References: <1418422034-17099-1-git-send-email-cernekee@gmail.com>
 <1418422034-17099-14-git-send-email-cernekee@gmail.com> <CAOiHx=nX9jJEFZmkA-1fWj47whq85wj-ZgUxnZBwpAYDUfAO4w@mail.gmail.com>
 <CAJiQ=7AZdwCX6bmLD1B4TzfmKriE3HVEEa5zP3WRnENZjGS-hA@mail.gmail.com> <CAOiHx=m9RzU5n2fjJcph6u=avUAEZJYw0-mBCSMRzDJvSD5CFA@mail.gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sun, 21 Dec 2014 02:56:53 -0800
Message-ID: <CAGVrzcYaF6Or5GmXyiY1kTi+4DzDGqB1kKnQxijKwrz8XybryQ@mail.gmail.com>
Subject: Re: [PATCH V5 13/23] MIPS: BMIPS: Flush the readahead cache after DMA
To: Jonas Gorski <jogo@openwrt.org>
Cc: Kevin Cernekee <cernekee@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
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

2014-12-20 4:44 GMT-08:00 Jonas Gorski <jogo@openwrt.org>:
> On Sat, Dec 20, 2014 at 2:39 AM, Kevin Cernekee <cernekee@gmail.com> wrote:
>> On Mon, Dec 15, 2014 at 1:43 AM, Jonas Gorski <jogo@openwrt.org> wrote:
>>> On Fri, Dec 12, 2014 at 11:07 PM, Kevin Cernekee <cernekee@gmail.com> wrote:
>>>> BMIPS 3300/435x/438x CPUs have a readahead cache that is separate from
>>>> the L1/L2.  During a DMA operation, accesses adjacent to a DMA buffer
>>>> may cause parts of the DMA buffer to be prefetched into the RAC.  To
>>>> avoid possible coherency problems, flush the RAC upon DMA completion.
>>>
>>> According to what I have, any cpu [d-]cache invalidate operation
>>> should already flush the full RAC unless explicitly disabled in the
>>> RAC configuration - is this intended as an optimization/shortcut?
>>
>> Correct - performing a RAC flush instead of blasting the entire range
>> again via CACHE instructions should be considerably faster in most
>> cases.  CACHE instructions are not pipelined on BMIPS3300/43xx.
>>
>> There may be a couple of old CPU versions (possibly 130nm) that don't
>> automatically perform the RAC flush on each CACHE instruction.  Also,
>> a fun bit of trivia: MVA based cache flushes on B15 do flush the RAC,
>> but index based instructions do not.
>
> Because I'm laz^W^Wstill need to do some christmas shopping, I'll ask
> a few dumb questions:
>
> Since a RAC flush won't flush the I/D-caches themselves, I assume
> there is no cache invalidate needed for BMIPS? Also is it still needed
> if the RAC is setup to only prefetch instructions (which it seems to
> be on bcm963xx)?
>
> I also fail to find any RAC flushing on either bcm963xx or bcm947xx
> SDK kernels, that's why I'm a bit wondering whether they really need
> it. But maybe they always do explicit syncs, haven't checked that.
>
> Furthermore, I see code to enable data prefetching in setup on
> bcm963xx, so I wonder if it wouldn't make sense to add the RAC as an
> extra node in DT / register/enable/configure it from bmips setup code
> (because then we can also properly setup the address range in case the
> bootloader didn't).
>
>>>>  static inline int cpu_needs_post_dma_flush(struct device *dev)
>>>>  {
>>>
>>> The place for it seems a bit misplaced; I would not expect
>>> cpu_needs_post_dma_flush() to have any side effects.
>>
>> Maybe we should rename the function?  To just cpu_post_dma_flush()?
>
> Hm, not sure. Add a feature flag for that, or a callback. It is
> essentially a second level cache I guess.
>
> Also while reading dma-default.c, I wonder why dma_unmap_page checks
> if cpu needs to flush, but dma_unmap_sg doesn't (disclamer: I don't
> know anything about sg).
>
>>
>> (Or call a separate function from each site - but that seems unnecessary.)
>>
>>>> +       if (boot_cpu_type() == CPU_BMIPS3300 ||
>>>> +           boot_cpu_type() == CPU_BMIPS4350 ||
>>>> +           boot_cpu_type() == CPU_BMIPS4380) {
>>>> +               void __iomem *cbr = BMIPS_GET_CBR();
>>>> +
>>>> +               /* Flush stale data out of the readahead cache */
>>>> +               __raw_writel(0x100, cbr + BMIPS_RAC_CONFIG);
>>>
>>> Hm, according to what I have, bits [6:0] of RAC_CONFIG are R/W
>>> configuration bits, and this will overwrite them:
>>>
>>> CFE> dm 0xff400000 4
>>> ff400000: 02a07015                                        ..p.
>>> CFE> sm 0xff400000 0x100 4
>>> ff400000: 02a00000                                        ....
>>>
>>> (As far as I can tell, RAC was previously enabled for instruction
>>> cache misses , and now isn't any more for anything, so effectively
>>> disabled?)
>>>
>>> Also for BMIPS4350 (and I guess 4380) there seems to be a second
>>> RAC_CONFIG register at 0x8, I guess for the second thread? Does it
>>> need flushing, too?
>>
>> I'll defer to Florian for the final word since he has access to the
>> documentation, but going from memory:
>>
>> RAC_CONFIG should probably be a read/modify/write.  I'm pretty sure
>> there are important RW configuration bits in there.  I may have
>> incorrectly translated the "set bit 8" code from here:
>>
>> https://github.com/Broadcom/stblinux-3.3/blob/master/linux/arch/mips/mm/c-brcmstb.c#L374
>>
>> There is only one RAC for all CPUs, and we've never had to flush
>> anything via CBR+0x08.
>
>
> What I see in recent bcm963xx SDKs is this:
>
> void __init plat_mem_setup(void)
> {
> ...
>         volatile unsigned long *cr;
>         uint32 mipsBaseAddr = MIPS_BASE;
>
>         cr = (void *)(mipsBaseAddr + MIPS_RAC_CR0);
>         *cr = *cr | RAC_D | RAC_PF_D;
>
> #if defined(MIPS_RAC_CR1)
>         cr = (void *)(mipsBaseAddr + MIPS_RAC_CR1);
>         *cr = *cr | RAC_D | RAC_PF_D;
> #endif
> }
>
> RAC_CR1 seems to be defined for BMIPS4350 based SoCs, while BMIPS3300
> ones don't (well, 6318 doesn't. The older SDKs named the address range
> register RAC_CR1, so for them this check is quite wrong :P)
>
> But no references to RAC_FLH anywhere.

RAC_CR (0x1FA0_0000) controls the RAC settings for TP0, while RAC_CR1
(0x1FA0_0008) controls the RAC settings for TP1, hence the reason why
BMIPS3300 does not have it.

Surprisingly (or not), FLH only exists in RAC_CR, because the RAC is
shared between TPs just like the L2.

In your previous dump, bit 4 is set, aka C_INV, which means that the
RAC will flush its I-cache blocks when we issue "cache" instructions,
effectively making the RAC transparent as far as I understand it, and
D-cache prefetching is indeed disabled.
-- 
Florian
