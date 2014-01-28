Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaA1XUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:20:47 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:50882 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbaA1XUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:20:45 -0500
MIME-Version: 1.0
In-Reply-To: <20140127152342.GC20968@phenom.dumpdata.com>
References: <1389708830-5841-1-git-send-email-akinobu.mita@gmail.com>
	<1389708830-5841-2-git-send-email-akinobu.mita@gmail.com>
	<52E66527.8010000@samsung.com>
	<20140127152342.GC20968@phenom.dumpdata.com>
Date: Wed, 29 Jan 2014 08:20:45 +0900
Message-ID: <CAC5umyjJfO9UyAkoG-bEX-vdO+X0fM_YD2dwj2AHT6T7hKgv0A@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] x86: make dma_alloc_coherent() return zeroed
 memory if CMA is enabled
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-28 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>:
> On Mon, Jan 27, 2014 at 02:54:47PM +0100, Marek Szyprowski wrote:
>> Hello,
>>
>> On 2014-01-14 15:13, Akinobu Mita wrote:
>> >Calling dma_alloc_coherent() with __GFP_ZERO must return zeroed memory.
>> >
>> >But when the contiguous memory allocator (CMA) is enabled on x86 and
>> >the memory region is allocated by dma_alloc_from_contiguous(), it
>> >doesn't return zeroed memory.  Because dma_generic_alloc_coherent()
>> >forgot to fill the memory region with zero if it was allocated by
>> >dma_alloc_from_contiguous()
>>
>> I just wonder how it will work with high mem? I've didn't check the x86
>> dma mapping code yet, but page_address() works only for pages, which comes
>> from low memory. In other patches you have added an option to place CMA
>> area anywhere in the memory. Is the x86 pci dma code ready for the case
>> when cma area is put into high mem and direct mappings are not available?
>
> Yes and no. The swiotbl_bounce does have the code to take that into account.
> But that is it - nothing else does - so I think you would run in the
> possiblity of 'page_address' not providing an correct virtual address.

Thanks for spotting the issue.  I haven't much tested on x86_32.
I'll go through it and try to find the solution.

>>
>> >Most implementations of dma_alloc_coherent() return zeroed memory
>> >regardless of whether __GFP_ZERO is specified.  So this fixes it by
>> >unconditionally zeroing the allocated memory region.
>> >
>> >Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>> >Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> >Cc: David Woodhouse <dwmw2@infradead.org>
>> >Cc: Don Dutile <ddutile@redhat.com>
>> >Cc: Thomas Gleixner <tglx@linutronix.de>
>> >Cc: Ingo Molnar <mingo@redhat.com>
>> >Cc: "H. Peter Anvin" <hpa@zytor.com>
>> >Cc: Andi Kleen <andi@firstfloor.org>
>> >Cc: x86@kernel.org
>> >Cc: iommu@lists.linux-foundation.org
>> >Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> >---
>> >New patch from this version
>> >
>> >  arch/x86/kernel/pci-dma.c | 3 +--
>> >  1 file changed, 1 insertion(+), 2 deletions(-)
>> >
>> >diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
>> >index 872079a..9644405 100644
>> >--- a/arch/x86/kernel/pci-dma.c
>> >+++ b/arch/x86/kernel/pci-dma.c
>> >@@ -97,7 +97,6 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
>> >     dma_mask = dma_alloc_coherent_mask(dev, flag);
>> >-    flag |= __GFP_ZERO;
>> >  again:
>> >     page = NULL;
>> >     if (!(flag & GFP_ATOMIC))
>> >@@ -118,7 +117,7 @@ again:
>> >             return NULL;
>> >     }
>> >-
>> >+    memset(page_address(page), 0, size);
>> >     *dma_addr = addr;
>> >     return page_address(page);
>> >  }
>>
>> Best regards
>> --
>> Marek Szyprowski, PhD
>> Samsung R&D Institute Poland
>>
