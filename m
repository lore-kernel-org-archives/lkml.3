Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaLTBjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 20:39:33 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:37895 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaLTBjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 20:39:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAOiHx=nX9jJEFZmkA-1fWj47whq85wj-ZgUxnZBwpAYDUfAO4w@mail.gmail.com>
References: <1418422034-17099-1-git-send-email-cernekee@gmail.com>
 <1418422034-17099-14-git-send-email-cernekee@gmail.com> <CAOiHx=nX9jJEFZmkA-1fWj47whq85wj-ZgUxnZBwpAYDUfAO4w@mail.gmail.com>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Fri, 19 Dec 2014 17:39:09 -0800
Message-ID: <CAJiQ=7AZdwCX6bmLD1B4TzfmKriE3HVEEa5zP3WRnENZjGS-hA@mail.gmail.com>
Subject: Re: [PATCH V5 13/23] MIPS: BMIPS: Flush the readahead cache after DMA
To: Jonas Gorski <jogo@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
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

On Mon, Dec 15, 2014 at 1:43 AM, Jonas Gorski <jogo@openwrt.org> wrote:
> On Fri, Dec 12, 2014 at 11:07 PM, Kevin Cernekee <cernekee@gmail.com> wrote:
>> BMIPS 3300/435x/438x CPUs have a readahead cache that is separate from
>> the L1/L2.  During a DMA operation, accesses adjacent to a DMA buffer
>> may cause parts of the DMA buffer to be prefetched into the RAC.  To
>> avoid possible coherency problems, flush the RAC upon DMA completion.
>
> According to what I have, any cpu [d-]cache invalidate operation
> should already flush the full RAC unless explicitly disabled in the
> RAC configuration - is this intended as an optimization/shortcut?

Correct - performing a RAC flush instead of blasting the entire range
again via CACHE instructions should be considerably faster in most
cases.  CACHE instructions are not pipelined on BMIPS3300/43xx.

There may be a couple of old CPU versions (possibly 130nm) that don't
automatically perform the RAC flush on each CACHE instruction.  Also,
a fun bit of trivia: MVA based cache flushes on B15 do flush the RAC,
but index based instructions do not.

>>  static inline int cpu_needs_post_dma_flush(struct device *dev)
>>  {
>
> The place for it seems a bit misplaced; I would not expect
> cpu_needs_post_dma_flush() to have any side effects.

Maybe we should rename the function?  To just cpu_post_dma_flush()?

(Or call a separate function from each site - but that seems unnecessary.)

>> +       if (boot_cpu_type() == CPU_BMIPS3300 ||
>> +           boot_cpu_type() == CPU_BMIPS4350 ||
>> +           boot_cpu_type() == CPU_BMIPS4380) {
>> +               void __iomem *cbr = BMIPS_GET_CBR();
>> +
>> +               /* Flush stale data out of the readahead cache */
>> +               __raw_writel(0x100, cbr + BMIPS_RAC_CONFIG);
>
> Hm, according to what I have, bits [6:0] of RAC_CONFIG are R/W
> configuration bits, and this will overwrite them:
>
> CFE> dm 0xff400000 4
> ff400000: 02a07015                                        ..p.
> CFE> sm 0xff400000 0x100 4
> ff400000: 02a00000                                        ....
>
> (As far as I can tell, RAC was previously enabled for instruction
> cache misses , and now isn't any more for anything, so effectively
> disabled?)
>
> Also for BMIPS4350 (and I guess 4380) there seems to be a second
> RAC_CONFIG register at 0x8, I guess for the second thread? Does it
> need flushing, too?

I'll defer to Florian for the final word since he has access to the
documentation, but going from memory:

RAC_CONFIG should probably be a read/modify/write.  I'm pretty sure
there are important RW configuration bits in there.  I may have
incorrectly translated the "set bit 8" code from here:

https://github.com/Broadcom/stblinux-3.3/blob/master/linux/arch/mips/mm/c-brcmstb.c#L374

There is only one RAC for all CPUs, and we've never had to flush
anything via CBR+0x08.

BCM7038 had a different flush register, located out in the regular
system bus (GISB) space, and it didn't require a R/M/W.  That might
have been what I was thinking of.

Thanks for catching that.
