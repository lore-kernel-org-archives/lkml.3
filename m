Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaGJLNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:13:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54397 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295AbaGJLN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:13:29 -0400
Date: Thu, 10 Jul 2014 12:12:59 +0100
From: Will Deacon <will.deacon@arm.com>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "andreas.herrmann@calxeda.com" <andreas.herrmann@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: mm: fix the boundary checking on bitmaps
Message-ID: <20140710111259.GL2449@arm.com>
References: <1404959313-15198-1-git-send-email-haojian.zhuang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404959313-15198-1-git-send-email-haojian.zhuang@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 03:28:33AM +0100, Haojian Zhuang wrote:
> The issue of boundary checking on bitmaps is introduced by this commit
> in below.
> 
> commit 4d852ef8c2544ce21ae41414099a7504c61164a0
> Author: Andreas Herrmann <andreas.herrmann@calxeda.com>
> Date:   Tue Feb 25 13:09:53 2014 +0100
> 
>     arm: dma-mapping: Add support to extend DMA IOMMU mappings
> 
> Multiple bitmaps were introduced as extension. If it needs to extend
> a bitmap, it still check whether the allocation exceeding the total
> size, not current bitmap size. So change the condition from
> mapping->bits to PAGE_SIZE.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
> ---
>  arch/arm/mm/dma-mapping.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 4c88935..d7da5c3 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -1089,9 +1089,9 @@ static inline dma_addr_t __alloc_iova(struct dma_iommu_mapping *mapping,
>  	spin_lock_irqsave(&mapping->lock, flags);
>  	for (i = 0; i < mapping->nr_bitmaps; i++) {
>  		start = bitmap_find_next_zero_area(mapping->bitmaps[i],
> -				mapping->bits, 0, count, align);
> +				PAGE_SIZE, 0, count, align);

I'm probably just missing something, but what guarantees that the bitmap is
PAGE_SIZE? It looks to me like we could easily go off the end of the bitmap
if arm_iommu_create_mapping is called with a small size parameter.

Will
