Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbaLIC5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 21:57:53 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:55342 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaLIC5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 21:57:52 -0500
MIME-Version: 1.0
In-Reply-To: <10532762.PXKTQM8KjH@wuerfel>
References: <1418027967-12923-1-git-send-email-acourbot@nvidia.com> <10532762.PXKTQM8KjH@wuerfel>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 9 Dec 2014 11:57:22 +0900
Message-ID: <CAAVeFuKOaN5c2OkUDRWYQ_QVH8E1Q0JByRSSrbY_g13takWdAw@mail.gmail.com>
Subject: Re: [PATCH] ARM: DMA: Fix kzalloc flags in __iommu_alloc_buffer()
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 7:24 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 08 December 2014 17:39:27 Alexandre Courbot wrote:
>> There doesn't seem to be any valid reason to allocate the pages array
>> with the same flags as the buffer itself. Doing so can eventually lead
>> to the following safeguard in mm/slab.c to be hit:
>>
>> BUG_ON(flags & GFP_SLAB_BUG_MASK);
>>
>> This happens when buffers are allocated with __GFP_DMA32 or
>> __GFP_HIGHMEM.
>>
>> Fix this by allocating the pages array with GFP_KERNEL to follow what is
>> done elsewhere in this file. Using GFP_KERNEL in __iommu_alloc_buffer()
>> is safe because atomic allocations are handled by __iommu_alloc_atomic().
>>
>
> I think you need to carry over the GFP_ATOMIC flag if that is set by the
> caller, but not the GFP_HIGHMEM or GFP_DMA32. Not sure if it's better
> to mask out flags from the caller mask, or to start with GFP_KERNEL
> and adding in extra bits.

I thought the issue of atomicity is already handled by
__iommu_alloc_buffer's caller (arm_iommu_alloc_attrs):

    if (!(gfp & __GFP_WAIT))
        return __iommu_alloc_atomic(dev, size, handle);
    ....
    pages = __iommu_alloc_buffer(dev, size, gfp, attrs);

Isn't the interesting property about GFP_ATOMIC that it does not
include __GFP_WAIT? I may very well misunderstand the issue, sorry if
that's the case.
