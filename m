Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaAPO2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:28:12 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55468 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaAPO2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:28:08 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-59-52d7ec758900
Message-id: <52D7EC74.7030401@samsung.com>
Date: Thu, 16 Jan 2014 15:28:04 +0100
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
Subject: Re: [PATCH v2 3/5] intel-iommu: integrate DMA CMA
References: <1389708830-5841-1-git-send-email-akinobu.mita@gmail.com>
 <1389708830-5841-4-git-send-email-akinobu.mita@gmail.com>
In-reply-to: <1389708830-5841-4-git-send-email-akinobu.mita@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t/xy7qlb64HGdz/LWPx6kAHo8Wc9WvY
	LI5c+85u0T9jNbPFxJWTmS2mbRS3WLDf2mLZ4qeMFpd3zWGzuHRgAZPF5k1TmS1+bHjM6sDj
	MX/nR0aPnbPusntsXqHlsWlVJ5vHu3Pn2D1OzPjN4jH5xnJGj49Pb7F4vN93lc3j8yY5jxMt
	X1gDuKO4bFJSczLLUov07RK4Mu6cnMJc0CpTcfrbRPYGxjViXYycHBICJhKdr18zQ9hiEhfu
	rWfrYuTiEBJYyijx4dFNRgjnE6PExSu7WECqeAW0JH7sf8TaxcjBwSKgKjF1oh9ImE3AUKLr
	bRcbiC0qECqx5+NpRohyQYkfk++BtYoIpEj8fzybGWQms8A+JomTN1vYQRLCAlYSL7c0sUIs
	a2SUeHK+jxUkwSngJnGz7ReYzSxgJvGoZR0zhC0vsXnNW+YJjAKzkCyZhaRsFpKyBYzMqxhF
	U0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCIurLDsbFx6wOMQpwMCrx8O54eC1IiDWxrLgy9xCj
	BAezkgjv65fXg4R4UxIrq1KL8uOLSnNSiw8xMnFwSjUwxpXn2r5eXLKwj3dBn/06hweLfqna
	Lz7oYqrduc5m/7n2CwvF1A6LHkqUWCeRUrjp7lUd1Xrr2Dn+j5Uq/TkMox8fPHB37stXeTbb
	zjHECC07v+ib2oE/uX/0tB8XM4d6iv+tTOi7ka1qskvZbAZrYcG79Yuf8S9Sco+c47ifueXT
	J8+Owz+vKLEUZyQaajEXFScCAOb3XIGGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-01-14 15:13, Akinobu Mita wrote:
> This adds support for the DMA Contiguous Memory Allocator for intel-iommu.
> This change enables dma_alloc_coherent() to allocate big contiguous
> memory.
>
> It is achieved in the same way as nommu_dma_ops currently does, i.e.
> trying to allocate memory by dma_alloc_from_contiguous() and alloc_pages()
> is used as a fallback.
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
> No change from the previous version
>
>   drivers/iommu/intel-iommu.c | 32 ++++++++++++++++++++++++--------
>   1 file changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index fd426ca..172c2b0 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -3004,7 +3004,7 @@ static void *intel_alloc_coherent(struct device *hwdev, size_t size,
>   				  dma_addr_t *dma_handle, gfp_t flags,
>   				  struct dma_attrs *attrs)
>   {
> -	void *vaddr;
> +	struct page *page = NULL;
>   	int order;
>   
>   	size = PAGE_ALIGN(size);
> @@ -3019,17 +3019,31 @@ static void *intel_alloc_coherent(struct device *hwdev, size_t size,
>   			flags |= GFP_DMA32;
>   	}
>   
> -	vaddr = (void *)__get_free_pages(flags, order);
> -	if (!vaddr)
> +	if (!(flags & GFP_ATOMIC)) {

GFP_ATOMIC is not a flag, so please change the above check to:
            if (flags & __GFP_WAIT)

I will also fix the similar issue in arch/x86/kernel/pci-dma.c

> +		unsigned int count = size >> PAGE_SHIFT;
> +
> +		page = dma_alloc_from_contiguous(hwdev, count, order);
> +		if (page && iommu_no_mapping(hwdev) &&
> +		    page_to_phys(page) + size > hwdev->coherent_dma_mask) {
> +			dma_release_from_contiguous(hwdev, page, count);
> +			page = NULL;
> +		}
> +	}
> +
> +	if (!page)
> +		page = alloc_pages(flags, order);
> +	if (!page)
>   		return NULL;
> -	memset(vaddr, 0, size);
> +	memset(page_address(page), 0, size);
>   
> -	*dma_handle = __intel_map_single(hwdev, virt_to_bus(vaddr), size,
> +	*dma_handle = __intel_map_single(hwdev, page_to_phys(page), size,
>   					 DMA_BIDIRECTIONAL,
>   					 hwdev->coherent_dma_mask);
>   	if (*dma_handle)
> -		return vaddr;
> -	free_pages((unsigned long)vaddr, order);
> +		return page_address(page);
> +	if (!dma_release_from_contiguous(hwdev, page, size >> PAGE_SHIFT))
> +		__free_pages(page, order);
> +
>   	return NULL;
>   }
>   
> @@ -3037,12 +3051,14 @@ static void intel_free_coherent(struct device *hwdev, size_t size, void *vaddr,
>   				dma_addr_t dma_handle, struct dma_attrs *attrs)
>   {
>   	int order;
> +	struct page *page = virt_to_page(vaddr);
>   
>   	size = PAGE_ALIGN(size);
>   	order = get_order(size);
>   
>   	intel_unmap_page(hwdev, dma_handle, size, DMA_BIDIRECTIONAL, NULL);
> -	free_pages((unsigned long)vaddr, order);
> +	if (!dma_release_from_contiguous(hwdev, page, size >> PAGE_SHIFT))
> +		__free_pages(page, order);
>   }
>   
>   static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

