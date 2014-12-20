Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaLTR2i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 12:28:38 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:39093 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaLTR2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 12:28:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAOiHx=m9RzU5n2fjJcph6u=avUAEZJYw0-mBCSMRzDJvSD5CFA@mail.gmail.com>
References: <1418422034-17099-1-git-send-email-cernekee@gmail.com>
 <1418422034-17099-14-git-send-email-cernekee@gmail.com> <CAOiHx=nX9jJEFZmkA-1fWj47whq85wj-ZgUxnZBwpAYDUfAO4w@mail.gmail.com>
 <CAJiQ=7AZdwCX6bmLD1B4TzfmKriE3HVEEa5zP3WRnENZjGS-hA@mail.gmail.com> <CAOiHx=m9RzU5n2fjJcph6u=avUAEZJYw0-mBCSMRzDJvSD5CFA@mail.gmail.com>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Sat, 20 Dec 2014 09:28:15 -0800
Message-ID: <CAJiQ=7CjWMELO0fL+Zrx29Q-kRzkSZYpgEPRgJgULgwJ6KNN+g@mail.gmail.com>
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

On Sat, Dec 20, 2014 at 4:44 AM, Jonas Gorski <jogo@openwrt.org> wrote:
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

BTW, I forgot to mention earlier that the RAC is different from an
L2/L3 in two important ways:

 - In terms of prefetching you only need to worry about RAC blocks
(lines) on the "edges" on the DMA buffer.  It won't randomly fill
blocks in the middle, unlike the BMIPS5000 prefetching logic.

 - It typically isn't possible to invalidate just part of the RAC.
The hardware flushes the whole thing at once.

>> There may be a couple of old CPU versions (possibly 130nm) that don't
>> automatically perform the RAC flush on each CACHE instruction.  Also,
>> a fun bit of trivia: MVA based cache flushes on B15 do flush the RAC,
>> but index based instructions do not.
>
> Because I'm laz^W^Wstill need to do some christmas shopping, I'll ask
> a few dumb questions:
>
> Since a RAC flush won't flush the I/D-caches themselves, I assume
> there is no cache invalidate needed for BMIPS?

On unmap this is true.  The L1/L2 flush happens on map, pre-DMA.

> Also is it still needed
> if the RAC is setup to only prefetch instructions (which it seems to
> be on bcm963xx)?

Not sure.  Do we ever execute directly from memory that has been
freshly populated via DMA?  If so, anything executed in the vicinity
of that buffer could have prefetched stale data.  Keeping in mind that
the RAC won't prefetch across 4KB boundaries.

The most common RAC D$ coherency problems we've seen have involved DMA
buffers adjacent to other structs in kernel memory, e.g. a DMA buffer
that sits next to the wait_queue head used to sleep during the
transfer.  If the wait_queue struct is accessed at an unfortunate
time, the RAC could start prefetching from the DMA buffer.

RAC I$ problems are probably much more rare, and subtle.

> I also fail to find any RAC flushing on either bcm963xx or bcm947xx
> SDK kernels, that's why I'm a bit wondering whether they really need
> it. But maybe they always do explicit syncs, haven't checked that.
>
> Furthermore, I see code to enable data prefetching in setup on
> bcm963xx, so I wonder if it wouldn't make sense to add the RAC as an
> extra node in DT / register/enable/configure it from bmips setup code
> (because then we can also properly setup the address range in case the
> bootloader didn't).

Historically there has been a great deal of debate as to whether the
RAC should be set up in the bootloader or in the kernel:

 - If it is set up in the bootloader, it can be part of the library
that handles general cache/CPU initialization for the platform.  But
the RAC does require extra flushing, so non-RAC-aware OSes can be
caught off guard (especially if you're thinking about running a fairly
stock image, like the ARMv7 multiplatform kernel from upstream).

 - If it is set up in the kernel, the kernel will be able to decide
whether it can handle the extra flushes.  If problems are seen later,
it is easy to just change the kernel to leave RAC disabled, at the
expense of memcpy() performance.

On BCM7xxx MIPS, the RAC is always set up from the bootloader.  On
BCM7xxx ARM, it is currently left up to the kernel (last I heard).  On
BCM3384 Viper it is controlled by the CM firmware on TP0.  Not sure
about the other SoCs.
