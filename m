Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaJQGS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 02:18:56 -0400
Received: from [42.62.48.242] ([42.62.48.242]:7204 "EHLO manager.mioffice.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750729AbaJQGSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 02:18:55 -0400
From: =?gb2312?B?1uy71A==?= <zhuhui@xiaomi.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/4] (CMA_AGGRESSIVE) Add argument hibernation to
 function shrink_all_memory
Thread-Topic: [PATCH 2/4] (CMA_AGGRESSIVE) Add argument hibernation to
 function shrink_all_memory
Thread-Index: AQHP6PJVzwc7eQGqjUqsqpyi3U8pHQ==
Date: Fri, 17 Oct 2014 06:18:39 +0000
Message-ID: <70d41b6fdea74d5fb88f314708879acc@cnbox4.mioffice.cn>
References: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
 <1413430551-22392-3-git-send-email-zhuhui@xiaomi.com>
 <1471435.6q4YYkTopF@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.37.216.50]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9H6J1lq009602



On 10/16/14 16:29, Rafael J. Wysocki wrote:
> [CC list trimmed]
>
> On Thursday, October 16, 2014 11:35:49 AM Hui Zhu wrote:
>> Function shrink_all_memory try to free `nr_to_reclaim' of memory.
>> CMA_AGGRESSIVE_SHRINK function will call this functon to free `nr_to_reclaim' of
>> memory.  It need different scan_control with current caller function
>> hibernate_preallocate_memory.
>>
>> If hibernation is true, the caller is hibernate_preallocate_memory.
>> if not, the caller is CMA alloc function.
>>
>> Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
>> ---
>>   include/linux/swap.h    |  3 ++-
>>   kernel/power/snapshot.c |  2 +-
>>   mm/vmscan.c             | 19 +++++++++++++------
>>   3 files changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 37a585b..9f2cb43 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -335,7 +335,8 @@ extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>>   						gfp_t gfp_mask, bool noswap,
>>   						struct zone *zone,
>>   						unsigned long *nr_scanned);
>> -extern unsigned long shrink_all_memory(unsigned long nr_pages);
>> +extern unsigned long shrink_all_memory(unsigned long nr_pages,
>> +				       bool hibernation);
>>   extern int vm_swappiness;
>>   extern int remove_mapping(struct address_space *mapping, struct page *page);
>>   extern unsigned long vm_total_pages;
>> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
>> index 791a618..a00fc35 100644
>> --- a/kernel/power/snapshot.c
>> +++ b/kernel/power/snapshot.c
>> @@ -1657,7 +1657,7 @@ int hibernate_preallocate_memory(void)
>>   	 * NOTE: If this is not done, performance will be hurt badly in some
>>   	 * test cases.
>>   	 */
>> -	shrink_all_memory(saveable - size);
>> +	shrink_all_memory(saveable - size, true);
>
> Instead of doing this, can you please define
>
> __shrink_all_memory()
>
> that will take the appropriate struct scan_control as an argument and
> then define two wrappers around that, one for hibernation and one for CMA?
>
> The way you did it opens a field for bugs caused by passing a wrong value
> as the second argument.

Thanks Rafael.
I will update patch according to your comments.

Best,
Hui

>
>>
>>   	/*
>>   	 * The number of saveable pages in memory was too high, so apply some
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index dcb4707..fdcfa30 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -3404,7 +3404,7 @@ void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx)
>>   	wake_up_interruptible(&pgdat->kswapd_wait);
>>   }
>>
>> -#ifdef CONFIG_HIBERNATION
>> +#if defined CONFIG_HIBERNATION || defined CONFIG_CMA_AGGRESSIVE
>>   /*
>>    * Try to free `nr_to_reclaim' of memory, system-wide, and return the number of
>>    * freed pages.
>> @@ -3413,22 +3413,29 @@ void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx)
>>    * LRU order by reclaiming preferentially
>>    * inactive > active > active referenced > active mapped
>>    */
>> -unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
>> +unsigned long shrink_all_memory(unsigned long nr_to_reclaim, bool hibernation)
>>   {
>>   	struct reclaim_state reclaim_state;
>>   	struct scan_control sc = {
>>   		.nr_to_reclaim = nr_to_reclaim,
>> -		.gfp_mask = GFP_HIGHUSER_MOVABLE,
>>   		.priority = DEF_PRIORITY,
>> -		.may_writepage = 1,
>>   		.may_unmap = 1,
>>   		.may_swap = 1,
>> -		.hibernation_mode = 1,
>>   	};
>>   	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
>>   	struct task_struct *p = current;
>>   	unsigned long nr_reclaimed;
>>
>> +	if (hibernation) {
>> +		sc.hibernation_mode = 1;
>> +		sc.may_writepage = 1;
>> +		sc.gfp_mask = GFP_HIGHUSER_MOVABLE;
>> +	} else {
>> +		sc.hibernation_mode = 0;
>> +		sc.may_writepage = !laptop_mode;
>> +		sc.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_HIGHMEM;
>> +	}
>> +
>>   	p->flags |= PF_MEMALLOC;
>>   	lockdep_set_current_reclaim_state(sc.gfp_mask);
>>   	reclaim_state.reclaimed_slab = 0;
>> @@ -3442,7 +3449,7 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
>>
>>   	return nr_reclaimed;
>>   }
>> -#endif /* CONFIG_HIBERNATION */
>> +#endif /* CONFIG_HIBERNATION || CONFIG_CMA_AGGRESSIVE */
>>
>>   /* It's optimal to keep kswapds on the same CPUs as their memory, but
>>      not required for correctness.  So if the last cpu in a node goes
>>
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
