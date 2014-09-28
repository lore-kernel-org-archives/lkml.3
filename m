Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaI1Abx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 20:31:53 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:50044 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaI1Abw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 20:31:52 -0400
MIME-Version: 1.0
In-Reply-To: <5426CA0A.7000806@hurleysoftware.com>
References: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com>
	<5426CA0A.7000806@hurleysoftware.com>
Date: Sun, 28 Sep 2014 09:31:50 +0900
Message-ID: <CAC5umyhgs8---HZLa7_DOSbqW0uPbLgqTfBweScZSR9oWbG9xg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] enhance DMA CMA on x86
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-27 23:30 GMT+09:00 Peter Hurley <peter@hurleysoftware.com>:
> On 04/15/2014 09:08 AM, Akinobu Mita wrote:
>> This patch set enhances the DMA Contiguous Memory Allocator on x86.
>>
>> Currently the DMA CMA is only supported with pci-nommu dma_map_ops
>> and furthermore it can't be enabled on x86_64.  But I would like to
>> allocate big contiguous memory with dma_alloc_coherent() and tell it
>> to the device that requires it, regardless of which dma mapping
>> implementation is actually used in the system.
>>
>> So this makes it work with swiotlb and intel-iommu dma_map_ops, too.
>> And this also extends "cma=" kernel parameter to specify placement
>> constraint by the physical address range of memory allocations.  For
>> example, CMA allocates memory below 4GB by "cma=64M@0-4G", it is
>> required for the devices only supporting 32-bit addressing on 64-bit
>> systems without iommu.
>>
>> * Changes from v2
>> - Rebased on current Linus tree
>> - Add Acked-by line
>> - Fix gfp flags check for __GFP_ATOMIC, reported by Marek Szyprowski
>> - Avoid CMA area on highmem with cma= option, reported by Marek Szyprowski
>>
>> * Changes from v1
>> - fix dma_alloc_coherent() with __GFP_ZERO
>> - add placement specifier for "cma=" kernel parameter
>>
>> Akinobu Mita (5):
>>   x86: make dma_alloc_coherent() return zeroed memory if CMA is enabled
>>   x86: enable DMA CMA with swiotlb
>>   intel-iommu: integrate DMA CMA
>>   memblock: introduce memblock_alloc_range()
>>   cma: add placement specifier for "cma=" kernel parameter
>
> This patchset breaks every x86 iommu configuration when CONFIG_DMA_CMA is
> on, which is the base configuration for Ubuntu x86 and amd64 distro kernels.
>
> Granted, the patchset leveraged existing code from the nommu configuration,
> but that base (ie., calling dma_alloc_from_contiguous() in
> dma_generic_alloc_config()) was an ill-conceived test configuration designed
> to allow ARM developers to validate the CMA allocator on x86 boxen and
> KVM guests, not as a general-purpose replacement for the existing page
> allocator. The test code should have had a separate CONFIG_ knob.
>
> What this patchset does is restrict all iommu configurations which can
> map all of system memory to one _very_ small physical region, thus disabling
> the whole point of an iommu.
>
> Now I know why my GPU is causing paging to disk! And why my RAID controller
> stalls for ages when I do a git log at the same time as a kernel build!

The solution I have for this is that instead of trying to
dma_alloc_from_contiguous() firstly, call alloc_pages() in dma_alloc_coherent().
dma_alloc_from_contiguous() should be called only when alloc_pages() is failed
or DMA_ATTR_FORCE_CONTIGUOUS is specified in dma_attr.

> And the apparent goal of this patchset is to enable DMA allocation below
> 4GB, which is already supported in the existing page allocator with the
> GFP_DMA32 flag?!

The goal of this patchset is to enable huge DMA allocation which
alloc_pages() can't (> MAX_ORDER) for the devices that require it.

Thanks for the notification.  I'll prepare a patch described above.
