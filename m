Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360Ab3GOP4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:56:08 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:58945 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933292Ab3GOP4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:56:04 -0400
MIME-Version: 1.0
In-Reply-To: <00a701ce8155$be139240$3a3ab6c0$@samsung.com>
References: <002801ce797b$3d2fbc80$b78f3580$@samsung.com>
	<CANEJEGvajhgzUPG6ppbjwBb4-9TdU9em3T_SejBpz8NCjGHYTQ@mail.gmail.com>
	<00a701ce8155$be139240$3a3ab6c0$@samsung.com>
Date: Mon, 15 Jul 2013 08:56:02 -0700
X-Google-Sender-Auth: 57vdHEJCKkuCVoXKcnW-cIXCClw
Message-ID: <CANEJEGu0VJdFZmS800EKRSH0GXLGomC973BON7Vtr1qjjqi_nw@mail.gmail.com>
Subject: Re: [PATCH v7 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
From: Grant Grundler <grundler@chromium.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Grant Grundler <grundler@chromium.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Keyyoung Park <keyyoung.park@samsung.com>,
        Doug Anderson <dianders@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 5:20 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
...
>> > Cho,
>> > Of the above patches, nearly all have been applied to chromeos-3.8
>> > (kernel-next git tree) by Doug Anderson and others.
>> >
>> > AFAICT, the only ones not applied are:
>> >    [v7,3/9] iommu/exynos: fix page table maintenance
>> >    [v7,6/9] clk: exynos5250: add gate clock descriptions of System MMU
>> > (conflicts in this one)
>> >    [v7,7/9] ARM: dts: Add description of System MMU of Exynos SoCs
>> > (depends on 6/9)
>> >
>> > We also already have parts of:
>> >    [v7,9/9] iommu/exynos: add bus notifier for registering System MMU
>> >
>> > Some of those are being further discussed but I've lost track now
>> > exactly which ones.
>> >
>> > I'm telling you about chromeos-3.8 status since the adopted changes
>> > have been reviewed (by me and others) are being tested manually here
>> > on several different Samsung Exynos platforms (including 5250 which is
>> > our "snow" platform). Not sure how you should to mark those patches
>> > since they aren't identical to your changes (which apply to post 3.10
>> > kernels, not 3.8).  You might consider splitting those patches out
>> > from the 4 I've listed above to get that series accepted upstream
>> > since the additional review/testing should provide some confidence
>> > those patches are good.
>> >
>>
>> I understand what you are concerning about.
>> Have you applied v6 patchset?

I did not though it's possible some of the code that was applied to
chromeos-3.8 kernel came from v6 (or earlier) patches. I just compared
with v7. Since it's a "backport", the code I found in chromeos-3.8 is
the same if not identical to v7.

>>
>> I will try to split the patches and make the changes from v6
>> on top of the v6 patcheset.

Ok.

> Actually, as you know, the previous patches include setting a System MMU
> as the parent device of its master device in probe() of System MMU.
> I asked Greg KH about changing device hierarchy in probe() and he answered
> that it is not a good idea because it modifies sysfs even though probe() of
> System MMU driver is called before sysfs is constructed.

SysMMU primarily provides DMA API, right? Can sysfs be initialized
before DMA is available?
On some (many?) platforms the SysMMU is also responsible for "child"
bus controllers and MMIO resource routing, and on ARM platforms,
clocks for rest of the IO devices.

SysMMU might be needed for early gfx support (or something). Maybe the
right answer is to "discover" the SysMMU twice: once very early to get
the SysMMU operational and then again later in a "normal" probe
sequence to register with the sysfs. Any reason a driver couldn't
register two different module_init() routines in different parts of
the init call table?


> That's why I uses genpd_pm_ops.
> It results in big change in the patches after registering device tree.
>
> I want to ask your opinion about this change :)

I have no objection to large changes if they work well and are easy to
understand.

<rant>
I personally not happy with the direction the Linux IOMMU "subsystem"
has taken. I think the generic IOMMU subsystem should be discarded.
Strong words for someone who's not a key contributor but I'll explain.

I wrote the IOMMU support for PA-RISC (three different IOMMUs) 10+
years ago. I rewrote the HPUX implementations in the 90's and then
around 2000 wrote the implementation for PA-RISC (one of which Alex
Williamson used for IA64 IOMMU support - sba_iommu.c).  It's pretty
straight forward. There is "page allocation policy", code to do TLB
shoot down, and code to manage the IO Pdir. This is the same as for
CPU MMU.  The *efficiency* of the TLB depends on the page allocation
(SW) to work together with the HW TLB replacement policy. In other
words, the page allocation policy needs to avoid thrashing the IO TLB.
A generic IOTLB allocation policy can't do that for every platform.

Exynos 5250 has an 8-way associative TLB. That's likely very different
from the Intel and TI (omap) IOMMU the IOMMU subsystem code was
originally implemented for. The "optimal" size of page to allocate
will be different too.  Older Exynos products are likely different

The "2cd layer" of indirect function calls between the generic IOMMU
support and the platform specific code makes it harder to understand
the code.  While jump tables are good for some things, I don't think
this is a good use. We should "flip" this design around. Let the
platform specific code "own" the DMA ops API and it can decide which
services it should or should not use.

E.g. The IOTLB shoot down can be divorced from the "unmap" call. The
efficiency of shooting down one IOTLB entry at a time is horrible on
most platforms. One answer is to add a new API to shoot down an array
of IOVAs. But the tradeoffs in the size of the array and the events
that might trigger a TLB shoot down should be left up to the
platform/chipset specific code (e.g. "lazy TLB shootdown").

Sorry...this got rant got alot longer than it should have been. I hope
this helps people understand the design tradeoffs that linux IOMMU
subsystem never will be able to cleanly address. My hope is this rant
will help developers like you justify small steps to move away from
generic IOMMU code.
</rant>

cheers,
grant
