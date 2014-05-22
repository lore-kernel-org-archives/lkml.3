Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaEVGRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 02:17:35 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31760 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaEVGRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 02:17:33 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-29-537d96718000
Message-id: <537D9671.6030505@samsung.com>
Date: Thu, 22 May 2014 08:17:21 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Gioh Kim <gioh.kim@lge.com>, mina86@mina86.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        heesub.shin@samsung.com, mgorman@suse.de, hannes@cmpxchg.org
Cc: gunho.lee@lge.com, chanho.min@lge.com, gurugio@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH] arm: dma-mapping: add checking cma area initialized
References: <1400733503-1302-1-git-send-email-gioh.kim@lge.com>
In-reply-to: <1400733503-1302-1-git-send-email-gioh.kim@lge.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xy7qF02qDDfbOlrD4eO0Cu8Wzpi+M
	FhemLWS2mHz4I5PF6k2+FgdnL2GyWNndzGax6fE1VovLu+awWdxb85/VYvK7Z4wWC463sDrw
	eBx+857ZY+esu+wemz5NYvfoenuFyWPzknqPdX9eMXn0bVnF6LH5dLXH501yAZxRXDYpqTmZ
	ZalF+nYJXBm/Z0QX3Bes6H3M08DYyNfFyMkhIWAiMf/gXUYIW0ziwr31bF2MXBxCAksZJWb/
	3gzlfGKUuHW3C6yKV0BLYua3S6wgNouAqsT/cx/A4mwChhJdb7vYQGxRgRiJ3Z8XQtULSvyY
	fI8FZJCIwBlGiXdNHWDNzAIpEv8OXQazhQU8JO7Ons0EYgsJ2EvsvrkNzOYUcJD4sHQPO0S9
	mcSjlnXMELa8xOY1b5knMArMQrJjFpKyWUjKFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P
	3cQIiZwvOxgXH7M6xCjAwajEwytwtTpYiDWxrLgy9xCjBAezkgjvtpraYCHelMTKqtSi/Pii
	0pzU4kOMTBycUg2MAve2vQn8Nk/X4dHGnx1nV4X6PBZymd+4M6g6S3qbMtO6hTozJjaJzPdS
	iLol2fV79vG9l86xbdnTs3K7Vke1s2B54HVmk01rp7+T4TqZ8PL5RNuI9KqC3D6XkOJraXEL
	HyrJ93/ZdEXXU/CuSVr7+/a40x2VkpKz3yj/XFuaNpPH+rWidM9NJZbijERDLeai4kQAY9J2
	2noCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-05-22 06:38, Gioh Kim wrote:
> If CMA is turned on and CMA size is set to zero, kernel should
> behave as if CMA was not enabled at compile time.
> Every dma allocation should check existence of cma area
> before requesting memory.
>
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

Thanks for this patch! The initial version was really ugly, but
this one really does what should be there from the begging.

I've applied this patch with redundant empty line add removed.

> ---
>   arch/arm/mm/dma-mapping.c |    7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 18e98df..9173a13 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -390,12 +390,13 @@ static int __init atomic_pool_init(void)
>   	if (!pages)
>   		goto no_pages;
>   
> -	if (IS_ENABLED(CONFIG_DMA_CMA))
> +	if (dev_get_cma_area(NULL))
>   		ptr = __alloc_from_contiguous(NULL, pool->size, prot, &page,
>   					      atomic_pool_init);
>   	else
>   		ptr = __alloc_remap_buffer(NULL, pool->size, gfp, prot, &page,
>   					   atomic_pool_init);
> +
>   	if (ptr) {
>   		int i;
>   
> @@ -701,7 +702,7 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
>   		addr = __alloc_simple_buffer(dev, size, gfp, &page);
>   	else if (!(gfp & __GFP_WAIT))
>   		addr = __alloc_from_pool(size, &page);
> -	else if (!IS_ENABLED(CONFIG_DMA_CMA))
> +	else if (!dev_get_cma_area(dev))
>   		addr = __alloc_remap_buffer(dev, size, gfp, prot, &page, caller);
>   	else
>   		addr = __alloc_from_contiguous(dev, size, prot, &page, caller);
> @@ -790,7 +791,7 @@ static void __arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
>   		__dma_free_buffer(page, size);
>   	} else if (__free_from_pool(cpu_addr, size)) {
>   		return;
> -	} else if (!IS_ENABLED(CONFIG_DMA_CMA)) {
> +	} else if (!dev_get_cma_area(dev)) {
>   		__dma_free_remap(cpu_addr, size);
>   		__dma_free_buffer(page, size);
>   	} else {

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

