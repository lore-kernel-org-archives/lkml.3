Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbaA0Nyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 08:54:52 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51552 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaA0Nyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 08:54:50 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-ca-52e66528b644
Message-id: <52E66527.8010000@samsung.com>
Date: Mon, 27 Jan 2014 14:54:47 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH v2 1/5] x86: make dma_alloc_coherent() return zeroed memory
 if CMA is enabled
References: <1389708830-5841-1-git-send-email-akinobu.mita@gmail.com>
 <1389708830-5841-2-git-send-email-akinobu.mita@gmail.com>
In-reply-to: <1389708830-5841-2-git-send-email-akinobu.mita@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xK7oaqc+CDLZe17R4daCD0WLO+jVs
	FkeufWe36J+xmtli4srJzBbTNopbLNhvbbFs8VNGi8u75rBZXDqwgMli86apzBY/NjxmdeDx
	mL/zI6PHzll32T02r9Dy2LSqk83j3blz7B4nZvxm8Zh8Yzmjx8ent1g83u+7yubxeZOcx4mW
	L6wB3FFcNimpOZllqUX6dglcGdfOnmEteC1YsfbLX7YGxh18XYycHBICJhL3PtxggrDFJC7c
	W8/WxcjFISSwlFGi8dtvFgjnE6PEs4YbLCBVvAJaEhOuXwfrYBFQlfg95SIziM0mYCjR9baL
	DcQWFQiV2PPxNCNEvaDEj8n3wHpFBFIk/j+ezQwylFlgH5PEyZst7CAJYYFkifOfFzFDbGtk
	lPg+awbYJE4BN4n3LVfBNjALmEk8alkHZctLbF7zlnkCo8AsJEtmISmbhaRsASPzKkbR1NLk
	guKk9FwjveLE3OLSvHS95PzcTYyQmPq6g3HpMatDjAIcjEo8vFOlnwUJsSaWFVfmHmKU4GBW
	EuE9GAEU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwJiQvKdx+9vrCvz7mo0446c9N1qXJv3TPavV
	s8m+qKjDu8PG487EoJarLdn2i6WfNOw/lKnwiM1ngefiplhTo+0iZ4Q/XMk4vtD1ds2MFW0K
	136cjIhX9z9y97F31cYmsx0qGlH/jE/Kvilby7Pz3aVdor/SBRov7OS52LKak7ljv/GW9Jmx
	U5VYijMSDbWYi4oTAcEDxE6HAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-01-14 15:13, Akinobu Mita wrote:
> Calling dma_alloc_coherent() with __GFP_ZERO must return zeroed memory.
>
> But when the contiguous memory allocator (CMA) is enabled on x86 and
> the memory region is allocated by dma_alloc_from_contiguous(), it
> doesn't return zeroed memory.  Because dma_generic_alloc_coherent()
> forgot to fill the memory region with zero if it was allocated by
> dma_alloc_from_contiguous()

I just wonder how it will work with high mem? I've didn't check the x86
dma mapping code yet, but page_address() works only for pages, which comes
from low memory. In other patches you have added an option to place CMA
area anywhere in the memory. Is the x86 pci dma code ready for the case
when cma area is put into high mem and direct mappings are not available?

> Most implementations of dma_alloc_coherent() return zeroed memory
> regardless of whether __GFP_ZERO is specified.  So this fixes it by
> unconditionally zeroing the allocated memory region.
>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Don Dutile <ddutile@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: x86@kernel.org
> Cc: iommu@lists.linux-foundation.org
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> New patch from this version
>
>   arch/x86/kernel/pci-dma.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 872079a..9644405 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -97,7 +97,6 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
>   
>   	dma_mask = dma_alloc_coherent_mask(dev, flag);
>   
> -	flag |= __GFP_ZERO;
>   again:
>   	page = NULL;
>   	if (!(flag & GFP_ATOMIC))
> @@ -118,7 +117,7 @@ again:
>   
>   		return NULL;
>   	}
> -
> +	memset(page_address(page), 0, size);
>   	*dma_addr = addr;
>   	return page_address(page);
>   }

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

