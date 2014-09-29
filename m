Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaI2NVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:21:20 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:59647 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaI2NVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:21:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140928154525.76cc5464@as>
References: <1411919524-3666-1-git-send-email-akinobu.mita@gmail.com>
	<20140928154525.76cc5464@as>
Date: Mon, 29 Sep 2014 22:21:18 +0900
Message-ID: <CAC5umygE3R6WwtG0P+LN7NV1Fn=DZ8+p41rG5hCJrWs64Yrr_A@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: don't unnecessarily call dma_alloc_from_contiguous()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-29 5:45 GMT+09:00 Chuck Ebbert <cebbert.lkml@gmail.com>:
> On Mon, 29 Sep 2014 00:52:03 +0900
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> If CONFIG_DMA_CMA is enabled, dma_generic_alloc_coherent() tries to
>> allocate memory region by dma_alloc_from_contiguous() before trying to
>> use alloc_pages().
>>
>> This wastes CMA region by small DMA-coherent buffers which can be
>> allocated by alloc_pages().  And it also causes performance degradation,
>> as this is trying to drive _all_ dma mapping allocations through a
>> _very_ small window, reported by Peter Hurley.
>>
>> This fixes it by trying to allocate by alloc_pages() first in
>> dma_generic_alloc_coherent() as dma_alloc_from_contiguous should be
>> called only for huge allocation.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Reported-by: Peter Hurley <peter@hurleysoftware.com>
>> Cc: Peter Hurley <peter@hurleysoftware.com>
>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Don Dutile <ddutile@redhat.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Andi Kleen <andi@firstfloor.org>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: x86@kernel.org
>> Cc: iommu@lists.linux-foundation.org
>> ---
>>  arch/x86/kernel/pci-dma.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
>> index a25e202..0402266 100644
>> --- a/arch/x86/kernel/pci-dma.c
>> +++ b/arch/x86/kernel/pci-dma.c
>> @@ -99,20 +99,20 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
>>
>>       flag &= ~__GFP_ZERO;
>>  again:
>> -     page = NULL;
>> +     page = alloc_pages_node(dev_to_node(dev), flag | __GFP_NOWARN,
>> +                             get_order(size));
>
> Only try small allocs here, like when order < PAGE_ALLOC_COSTLY_ORDER ?
>
>>       /* CMA can be used only in the context which permits sleeping */
>> -     if (flag & __GFP_WAIT) {
>> +     if (!page && (flag & __GFP_WAIT)) {
>>               page = dma_alloc_from_contiguous(dev, count, get_order(size));
>>               if (page && page_to_phys(page) + size > dma_mask) {
>>                       dma_release_from_contiguous(dev, page, count);
>>                       page = NULL;
>>               }
>>       }
>> -     /* fallback */
>> -     if (!page)
>> -             page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
>
> (I forgot to add this in my first reply). I think it should try for a
> small alloc without CMA first, then try CMA, and then this final
> fallback for larger allocs.

I'm concerned with the performance problem reported by Peter Hurley.
This could be a solution, but I would like to hear Peter's opinion.

For now, I prefer the solution by this patch because it gives less
impact on CONFIG_DMA_CMA enabled.  But it can be improved later on.
