Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaEVEaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:30:35 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:33371 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEVEae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:30:34 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <537D7D68.4000700@lge.com>
Date: Thu, 22 May 2014 13:30:32 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>,
        "'Chanho Min'" <chanho.min@lge.com>
Subject: Re: [RFC PATCH] arm: dma-mapping: fallback allocation for cma failure
References: <537AEEDB.2000001@lge.com> <20140520065222.GB8315@js1304-P5Q-DELUXE> <xa1t1tvo1fas.fsf@mina86.com> <537C5EA3.20709@lge.com> <xa1td2f699j4.fsf@mina86.com> <537D4CBB.80305@lge.com> <xa1tmweajy4b.fsf@mina86.com>
In-Reply-To: <xa1tmweajy4b.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll resend the patch using git-send-email with your name.
I also hope some ARM-guys took a look at it.


2014-05-22 오후 12:22, Michal Nazarewicz 쓴 글:
> On Thu, May 22 2014, Gioh Kim <gioh.kim@lge.com> wrote:
>> I appreciate your comments.
>> The previous patch was ugly. But now it's beautiful! Just 3 lines!
>>
>> I'm not familiar with kernel patch process.
>> Can I have your name at Signed-off-by: line?
>> What tag do I have to write your name in?
>
> My Signed-off-by line does not apply in this case.
> Documentation/SubmittingPatches describes what Signed-off-by means.
>
> I've added Acked-by below.  You may want to resend this patch using
> “git-send-email”.
>
>> --------------------------------- 8< ----------------------------------------------
>>   From 135c986cfaa5a7291519308b3d47e58bf9f5af25 Mon Sep 17 00:00:00 2001
>> From: Gioh Kim <gioh.kim@lge.com>
>> Date: Tue, 20 May 2014 14:16:20 +0900
>> Subject: [PATCH] arm: dma-mapping: add checking cma area initialized
>>
>> If CMA is turned on and CMA size is set to zero, kernel should
>> behave as if CMA was not enabled at compile time.
>> Every dma allocation should check existence of cma area
>> before requesting memory.
>>
>> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
>
> But like before, if someone with more ARM knowledge could take a look at
> it, it would be awesome.
>
>> ---
>>    arch/arm/mm/dma-mapping.c |    7 ++++---
>>    1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
>> index 18e98df..9173a13 100644
>> --- a/arch/arm/mm/dma-mapping.c
>> +++ b/arch/arm/mm/dma-mapping.c
>> @@ -390,12 +390,13 @@ static int __init atomic_pool_init(void)
>>           if (!pages)
>>                   goto no_pages;
>>
>> -       if (IS_ENABLED(CONFIG_DMA_CMA))
>> +       if (dev_get_cma_area(NULL))
>>                   ptr = __alloc_from_contiguous(NULL, pool->size, prot, &page,
>>                                                 atomic_pool_init);
>>           else
>>                   ptr = __alloc_remap_buffer(NULL, pool->size, gfp, prot, &page,
>>                                              atomic_pool_init);
>> +
>>           if (ptr) {
>>                   int i;
>>
>> @@ -701,7 +702,7 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
>>                   addr = __alloc_simple_buffer(dev, size, gfp, &page);
>>           else if (!(gfp & __GFP_WAIT))
>>                   addr = __alloc_from_pool(size, &page);
>> -       else if (!IS_ENABLED(CONFIG_DMA_CMA))
>> +       else if (!dev_get_cma_area(dev))
>>                   addr = __alloc_remap_buffer(dev, size, gfp, prot, &page, caller);
>>           else
>>                   addr = __alloc_from_contiguous(dev, size, prot, &page, caller);
>> @@ -790,7 +791,7 @@ static void __arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
>>                   __dma_free_buffer(page, size);
>>           } else if (__free_from_pool(cpu_addr, size)) {
>>                   return;
>> -       } else if (!IS_ENABLED(CONFIG_DMA_CMA)) {
>> +       } else if (!dev_get_cma_area(dev)) {
>>                   __dma_free_remap(cpu_addr, size);
>>                   __dma_free_buffer(page, size);
>>           } else {
>> --
>> 1.7.9.5
>
