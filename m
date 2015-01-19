Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbbASCFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 21:05:24 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:50541 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbbASCFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 21:05:23 -0500
MIME-Version: 1.0
In-Reply-To: <54BB88CB.7080107@suse.cz>
References: <1421572634-3399-1-git-send-email-teawater@gmail.com> <54BB88CB.7080107@suse.cz>
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 19 Jan 2015 10:04:42 +0800
Message-ID: <CANFwon2XjhErx9uoZMJD1x=C4qEbrM6+2otnhNtQ-1duCebSFA@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: Fix race conditions on getting migratetype
 in buffered_rmqueue
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        hannes@cmpxchg.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        sasha.levin@oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Hui Zhu <zhuhui@xiaomi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 6:19 PM, Vlastimil Babka <vbabka@suse.cz> wrote:
> On 18.1.2015 10:17, Hui Zhu wrote:
>>
>> From: Hui Zhu <zhuhui@xiaomi.com>
>>
>> To test the patch [1], I use KGTP and a script [2] to show
>> NR_FREE_CMA_PAGES
>> and gross of cma_nr_free.  The values are always not same.
>> I check the code of pages alloc and free and found that race conditions
>> on getting migratetype in buffered_rmqueue.
>
>
> Can you elaborate? What does this races with, are you dynamically changing
> the size of CMA area, or what? The migratetype here is based on which free
> list the page was found on. Was it misplaced then? Wasn't Joonsoo's recent
> series supposed to eliminate this?

My bad.
I thought move_freepages has race condition with this part.  But I
missed it will check PageBuddy before set_freepage_migratetype.
Sorry for that.

I will do more work around this one and [1].

Thanks for your review.

Best,
Hui

>
>> Then I add move the code of getting migratetype inside the zone->lock
>> protection part.
>
>
> Not just that, you are also reading migratetype from pageblock bitmap
> instead of the one embedded in the free page. Which is more expensive
> and we already do that more often than we would like to because of CMA.
> And it appears to be a wrong fix for a possible misplacement bug. If there's
> such misplacement, the wrong stats are not the only problem.
>
>>
>> Because this issue will affect system even if the Linux kernel does't
>> have [1].  So I post this patch separately.
>
>
> But we can't test that without [1], right? Maybe the issue is introduced by
> [1]?
>
>
>>
>> This patchset is based on fc7f0dd381720ea5ee5818645f7d0e9dece41cb0.
>>
>> [1] https://lkml.org/lkml/2015/1/18/28
>> [2] https://github.com/teawater/kgtp/blob/dev/add-ons/cma_free.py
>>
>> Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
>> ---
>>   mm/page_alloc.c | 11 +++++++----
>>   1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 7633c50..f3d6922 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1694,11 +1694,12 @@ again:
>>                 }
>>                 spin_lock_irqsave(&zone->lock, flags);
>>                 page = __rmqueue(zone, order, migratetype);
>> +               if (page)
>> +                       migratetype = get_pageblock_migratetype(page);
>> +               else
>> +                       goto failed_unlock;
>>                 spin_unlock(&zone->lock);
>> -               if (!page)
>> -                       goto failed;
>> -               __mod_zone_freepage_state(zone, -(1 << order),
>> -                                         get_freepage_migratetype(page));
>> +               __mod_zone_freepage_state(zone, -(1 << order),
>> migratetype);
>>         }
>>         __mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
>> @@ -1715,6 +1716,8 @@ again:
>>                 goto again;
>>         return page;
>>   +failed_unlock:
>> +       spin_unlock(&zone->lock);
>>   failed:
>>         local_irq_restore(flags);
>>         return NULL;
>
>
