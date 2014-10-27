Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaJ0Asu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 20:48:50 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44366 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaJ0Ast (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 20:48:49 -0400
X-Original-SENDERIP: 10.186.123.76
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <544D966D.9060700@lge.com>
Date: Mon, 27 Oct 2014 09:48:45 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>
CC: devel@driverdev.osuosl.org, gunho.lee@lge.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 3/3] staging: ion: limit pool size
References: <1414133248-639-1-git-send-email-gioh.kim@lge.com> <1414133248-639-4-git-send-email-gioh.kim@lge.com> <544ABC53.5030300@codeaurora.org>
In-Reply-To: <544ABC53.5030300@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-10-25 오전 5:53, Laura Abbott 쓴 글:
> Hi,
>
> On 10/23/2014 11:47 PM, Gioh Kim wrote:
>> This patch limits pool size by page unit.
>>
>
> This looks useful. Might be nice to add a debugfs option
> to change this at runtime as well.
>
>> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
>> ---
>>   drivers/staging/android/ion/Kconfig         |    4 ++++
>>   drivers/staging/android/ion/ion_page_pool.c |   26 ++++++++++++++++----------
>>   2 files changed, 20 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
>> index 3452346..e6b1a54 100644
>> --- a/drivers/staging/android/ion/Kconfig
>> +++ b/drivers/staging/android/ion/Kconfig
>> @@ -33,3 +33,7 @@ config ION_TEGRA
>>       help
>>         Choose this option if you wish to use ion on an nVidia Tegra.
>>
>> +config ION_POOL_LIMIT
>> +    int "Limit count of pages in pool"
>> +    depends on ION
>> +    default "0"
>
> Can you add help text here? It would be useful to clarify that the
> units are in pages and that 0 will allow unlimited growth of the
> pool. This should also clarify that this is a limit per
> individual pool and not a limit for all page pools in the system.
>
>> diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
>> index 165152f..d63e93f 100644
>> --- a/drivers/staging/android/ion/ion_page_pool.c
>> +++ b/drivers/staging/android/ion/ion_page_pool.c
>> @@ -22,8 +22,11 @@
>>   #include <linux/module.h>
>>   #include <linux/slab.h>
>>   #include <linux/swap.h>
>> +#include <linux/kconfig.h>
>>   #include "ion_priv.h"
>>
>> +#define POOL_LIMIT CONFIG_ION_POOL_LIMIT
>> +
>
> I don't think the extra #define helps anything here, was
> there something else intended here?

No, I just follow other codes.
If it isn't necessary, I will remove it at v2 patch.


>
>>   static void *ion_page_pool_alloc_pages(struct ion_page_pool *pool)
>>   {
>>       struct page *page = alloc_pages(pool->gfp_mask, pool->order);
>> @@ -41,8 +44,21 @@ static void ion_page_pool_free_pages(struct ion_page_pool *pool,
>>       __free_pages(page, pool->order);
>>   }
>>
>> +static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
>> +{
>> +    int count = pool->low_count;
>> +
>> +    if (high)
>> +        count += pool->high_count;
>> +
>> +    return count << pool->order;
>> +}
>> +
>>   static int ion_page_pool_add(struct ion_page_pool *pool, struct page *page)
>>   {
>> +    if (POOL_LIMIT && ion_page_pool_total(pool, 1) > POOL_LIMIT)
>> +        return 1;
>> +
>>       mutex_lock(&pool->mutex);
>>       if (PageHighMem(page)) {
>>           list_add_tail(&page->lru, &pool->high_items);
>> @@ -103,16 +119,6 @@ void ion_page_pool_free(struct ion_page_pool *pool, struct page *page)
>>           ion_page_pool_free_pages(pool, page);
>>   }
>>
>> -static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
>> -{
>> -    int count = pool->low_count;
>> -
>> -    if (high)
>> -        count += pool->high_count;
>> -
>> -    return count << pool->order;
>> -}
>> -
>>   int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
>>                   int nr_to_scan)
>>   {
>>
>
> Thanks,
> Laura
>
