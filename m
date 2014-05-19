Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaESJOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:14:25 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58277 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaESJOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:14:21 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <5379CB66.7090607@lge.com>
Date: Mon, 19 May 2014 18:14:14 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Michal Nazarewicz <mina86@mina86.com>, Minchan Kim <minchan.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Laura Abbott <lauraa@codeaurora.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Heesub Shin <heesub.shin@samsung.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>, gurugio@gmail.com
Subject: Re: [RFC][PATCH] CMA: drivers/base/Kconfig: restrict CMA size to
 non-zero value
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com> <1399509144-8898-3-git-send-email-iamjoonsoo.kim@lge.com> <20140513030057.GC32092@bbox> <20140515015301.GA10116@js1304-P5Q-DELUXE> <5375C619.8010501@lge.com> <xa1tppjdfwif.fsf@mina86.com> <537962A0.4090600@lge.com> <20140519055527.GA24099@js1304-P5Q-DELUXE>
In-Reply-To: <20140519055527.GA24099@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __dma_alloc function, your patch can make __alloc_from_pool work.
But __alloc_from_contiguous doesn't work.
Therefore __dma_alloc sometimes works and sometimes not according to the gfp(__GFP_WAIT) flag.
Do I understand correctly?

I think __dma_alloc should work consistently.
Both of __alloc_from_contiguous and __alloc_from_pool should work together,
or both of them do not work.


2014-05-19 오후 2:55, Joonsoo Kim 쓴 글:
> On Mon, May 19, 2014 at 10:47:12AM +0900, Gioh Kim wrote:
>> Thank you for your advice. I didn't notice it.
>>
>> I'm adding followings according to your advice:
>>
>> - range restrict for CMA_SIZE_MBYTES and *CMA_SIZE_PERCENTAGE*
>> I think this can prevent the wrong kernel option.
>>
>> - change size_cmdline into default value SZ_16M
>> I am not sure this can prevent if cma=0 cmdline option is also with base and limit options.
>
> Hello,
>
> I think that this problem is originated from atomic_pool_init().
> If configured coherent_pool size is larger than default cma size,
> it can be failed even if this patch is applied.
>
> How about below patch?
> It uses fallback allocation if CMA is failed.
>
> Thanks.
>
> -----------------8<---------------------
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 6b00be1..2909ab9 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -379,7 +379,7 @@ static int __init atomic_pool_init(void)
>          unsigned long *bitmap;
>          struct page *page;
>          struct page **pages;
> -       void *ptr;
> +       void *ptr = NULL;
>          int bitmap_size = BITS_TO_LONGS(nr_pages) * sizeof(long);
>
>          bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> @@ -393,7 +393,7 @@ static int __init atomic_pool_init(void)
>          if (IS_ENABLED(CONFIG_DMA_CMA))
>                  ptr = __alloc_from_contiguous(NULL, pool->size, prot, &page,
>                                                atomic_pool_init);
> -       else
> +       if (!ptr)
>                  ptr = __alloc_remap_buffer(NULL, pool->size, gfp, prot, &page,
>                                             atomic_pool_init);
>          if (ptr) {
>
>
