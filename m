Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaFBFyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 01:54:45 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:35312 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFBFyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 01:54:43 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <538C1196.9000608@lge.com>
Date: Mon, 02 Jun 2014 14:54:30 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joonsoo Kim <js1304@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [PATCH v2 2/3] CMA: aggressively allocate the pages on cma reserved
 memory when not used
References: <1401260672-28339-1-git-send-email-iamjoonsoo.kim@lge.com>	<1401260672-28339-3-git-send-email-iamjoonsoo.kim@lge.com>	<53883902.8020701@lge.com> <CAAmzW4Nyic0VC9W16ZbjsZtNGGBet4HBDomQfMi-OvMGMKv9iw@mail.gmail.com>
In-Reply-To: <CAAmzW4Nyic0VC9W16ZbjsZtNGGBet4HBDomQfMi-OvMGMKv9iw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found 2 problems at my platform.

1st is occured when I set CMA size 528MB and total memory is 960MB.
I print some values in adjust_managed_cma_page_count(),
the total value becomes 105439 and cma value 131072.
Finally movable value becomes negative value.

The total value 105439 means 411MB.
Is the zone->managed_pages value pages amount except the CMA?
I think zone->managed_pages value is including CMA size but it's value is strange.

2nd is a kernel panic at __netdev_alloc_skb().
I'm not sure it is caused by the CMA.
I'm checking it again and going to send you another report with detail call-stacks.



2014-05-30 오후 11:23, Joonsoo Kim 쓴 글:
> 2014-05-30 16:53 GMT+09:00 Gioh Kim <gioh.kim@lge.com>:
>> Joonsoo,
>>
>> I'm attaching a patch for combination of __rmqueue and __rmqueue_cma.
>> I didn't test fully but my board is turned on and working well if no frequent memory allocations.
>>
>> I'm sorry to send not-tested code.
>> I just want to report this during your working hour ;-)
>>
>> I'm testing this this evening and reporting next week.
>> Have a nice weekend!
>
> Thanks Gioh. :)
>
>> -------------------------------------- 8< -----------------------------------------
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 7f97767..9ced736 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -964,7 +964,7 @@ static int fallbacks[MIGRATE_TYPES][4] = {
>>          [MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,     MIGRATE_R
>>   #ifdef CONFIG_CMA
>>          [MIGRATE_MOVABLE]     = { MIGRATE_CMA,         MIGRATE_RECLAIMABLE, MIGRATE_U
>> -       [MIGRATE_CMA]         = { MIGRATE_RESERVE }, /* Never used */
>> +       [MIGRATE_CMA]         = { MIGRATE_MOVABLE,     MIGRATE_RECLAIMABLE, MIGRATE_U
>
> I don't want to use __rmqueue_fallback() for CMA.
> __rmqueue_fallback() takes big order page rather than small order page
> in order to steal large amount of pages and continue to use them in
> next allocation attempts.
> We can use CMA pages on limited cases, so stealing some pages from
> other migrate type
> to CMA type isn't good idea to me.
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
