Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaGNNC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:02:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36982 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaGNNCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:02:52 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-03-53c3d4f945c5
Message-id: <53C3D4F8.9060001@samsung.com>
Date: Mon, 14 Jul 2014 15:02:48 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Haojian Zhuang <haojian.zhuang@linaro.org>, linux@arm.linux.org.uk,
        will.deacon@arm.com, andreas.herrmann@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mm: fix the boundary checking on bitmaps
References: <1404959313-15198-1-git-send-email-haojian.zhuang@linaro.org>
In-reply-to: <1404959313-15198-1-git-send-email-haojian.zhuang@linaro.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xa7o/rxwONvi3WtZi8ZEYi8vnDjNa
	bHp8jdXi8q45bBa3L/NavPx4gsWBzWPNvDWMHi3NPWweCz5fYfe4c20Pm8fmJfUenzfJBbBF
	cdmkpOZklqUW6dslcGU8WLGWqWC5QMWWhmlsDYytvF2MnBwSAiYS+85+Y4SwxSQu3FvP1sXI
	xSEksJRRovPSGUYI5xOjxNJ9a5lBqngFtCSOPf7C0sXIwcEioCrRtw1sEJuAoUTX2y42EFtU
	IEbiTO9nqHJBiR+T77GAzBEROMgosXDjBrBtwgJOEqeb1oDZQgKeEvvW7WYFsTkFvCT+N9wC
	izMLmEk8alnHDGHLS2xe85Z5AiP/LCRzZyEpm4WkbAEj8ypG0dTS5ILipPRcQ73ixNzi0rx0
	veT83E2MkED+soNx8TGrQ4wCHIxKPLwVYoeDhVgTy4orcw8xSnAwK4nwnj4KFOJNSaysSi3K
	jy8qzUktPsTIxMEp1cC4UDbF5J+bVeHJy0FTvi3SnbUl+aBxUZ8xo1s/2//GCpcDgmsD1/90
	PpD2a43XEvvpMp0Vsx8Vi9290Ca06Z3Edrldy3ZJPp/x0lBq6a6yH2srTZprL28V5D6vMUlz
	sVQFc/XMO68Lv32aJPXW5ahYrn312f1W79KeuUVPXSjscP73U5lzvgKBSizFGYmGWsxFxYkA
	A0NzmEICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-07-10 04:28, Haojian Zhuang wrote:
> The issue of boundary checking on bitmaps is introduced by this commit
> in below.
>
> commit 4d852ef8c2544ce21ae41414099a7504c61164a0
> Author: Andreas Herrmann <andreas.herrmann@calxeda.com>
> Date:   Tue Feb 25 13:09:53 2014 +0100
>
>      arm: dma-mapping: Add support to extend DMA IOMMU mappings
>
> Multiple bitmaps were introduced as extension. If it needs to extend
> a bitmap, it still check whether the allocation exceeding the total
> size, not current bitmap size. So change the condition from
> mapping->bits to PAGE_SIZE.
>
> Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>

NACK, this patch is not correct. mapping->bits contains the correct size of
a single bitmap, see the beginning of arm_iommu_create_mapping() function.

> ---
>   arch/arm/mm/dma-mapping.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 4c88935..d7da5c3 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -1089,9 +1089,9 @@ static inline dma_addr_t __alloc_iova(struct dma_iommu_mapping *mapping,
>   	spin_lock_irqsave(&mapping->lock, flags);
>   	for (i = 0; i < mapping->nr_bitmaps; i++) {
>   		start = bitmap_find_next_zero_area(mapping->bitmaps[i],
> -				mapping->bits, 0, count, align);
> +				PAGE_SIZE, 0, count, align);
>   
> -		if (start > mapping->bits)
> +		if (start > PAGE_SIZE)
>   			continue;
>   
>   		bitmap_set(mapping->bitmaps[i], start, count);
> @@ -1110,9 +1110,9 @@ static inline dma_addr_t __alloc_iova(struct dma_iommu_mapping *mapping,
>   		}
>   
>   		start = bitmap_find_next_zero_area(mapping->bitmaps[i],
> -				mapping->bits, 0, count, align);
> +				PAGE_SIZE, 0, count, align);
>   
> -		if (start > mapping->bits) {
> +		if (start > PAGE_SIZE) {
>   			spin_unlock_irqrestore(&mapping->lock, flags);
>   			return DMA_ERROR_CODE;
>   		}

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

