Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762638Ab3IDNRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 09:17:45 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34493 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762594Ab3IDNRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:17:42 -0400
Message-ID: <522732EB.4020103@gmail.com>
Date: Wed, 04 Sep 2013 21:17:31 +0800
From: Jin Xu <jinuxstyle@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] f2fs: optimize gc for better performance
References: <1377737323-11803-1-git-send-email-jinuxstyle@gmail.com> <1377777368.2354.46.camel@kjgkr> <52201A4F.9020808@gmail.com> <1378169118.2354.56.camel@kjgkr> <522677ED.8090203@gmail.com> <1378287635.2354.84.camel@kjgkr>
In-Reply-To: <1378287635.2354.84.camel@kjgkr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

On 04/09/2013 17:40, Jaegeuk Kim wrote:
> Hi Jin,
>
> 2013-09-04 (수), 07:59 +0800, Jin Xu:
>> Hi Jaegeuk,
>>
>> On 03/09/2013 08:45, Jaegeuk Kim wrote:
>>> Hi Jin,
>>>
>>>> [...]
>>>>>
>>>>> It seems that we can obtain the performance gain just by setting the
>>>>> MAX_VICTIM_SEARCH to 4096, for example.
>>>>> So, how about just adding an ending criteria like below?
>>>>>
>>>>
>>>> I agree that we could get the performance improvement by simply
>>>> enlarging the MAX_VICTIM_SEARCH to 4096, but I am concerning the
>>>> scalability a little bit. Because it might always searching the whole
>>>> bitmap in some cases, for example, when dirty segments is 4000 and
>>>> total segments is 409600.
>>>>> [snip]
>>>> [...]
>>>>>
>>>>> 	if (p->max_search > MAX_VICTIM_SEARCH)
>>>>> 		p->max_search = MAX_VICTIM_SEARCH;
>>>>>
>>>>
>>>> The optimization does not apply to SSR mode. There has a reason.
>>>> As noticed in the test, when SSR selected the segments that have most
>>>> garbage blocks, then when gc is needed, all the dirty segments might
>>>> have very less garbage blocks, thus the gc overhead is high. This might
>>>> lead to performance degradation. So the patch does not change the
>>>> victim selection policy for SSR.
>>>
>>> I think it doesn't care.
>>> GC is only triggered during the direct node block allocation.
>>> What it means that we need to consider the number of GC triggers where
>>> the GC triggers more frequently during the normal data allocation than
>>> the node block allocation.
>>> So, I think it would not degrade performance significatly.
>>>
>>> BTW, could you show some numbers for this?
>>> Or could you test what I suggested?
>>>
>>> Thanks,
>>>
>>
>> I re-ran the test and got the following result:
>>
>> ---------------------------------------
>> 2GB SDHC
>> create 52023 files of size 32768 bytes
>> random re-write 100000 records of 4KB
>> ---------------------------------------
>>
>> | file creation (s) | rewrite time (s) | gc count | gc garbage blocks |
>>
>> no patch       341         4227             1174          174840
>> patched        296         2995             634           109314
>> patched (KIM)  324         2958             645           106682
>>
>> In this test, it does not show the minor performance degradation caused
>> by applying the patch to SSR mode. Instead, the performance is a little
>> better with what you suggested.
>>
>> I agree that the performance degradation would not be significant even
>> it does degrade. I ever saw the minor degradation in some workloads, but
>> I didn't save the data.
>>
>> So, I agree that we can apply the patch to SSR mode as well.
>>
>> And do you still have concerns about the formula for calculating the #
>> of search?
>
> Thank you for the test. :)
> What I've concerned is that, if it is really important to get a victim
> more accurately for the performance as you described, it doesn't need to
> calculate the number of searches IMO. Just let's select nr_dirty. Why
> not?
> Only the thing that we should consider is to handle the case where the
> nr_dirty is too large.
> For this, we can just limit the # of searches to avoid performance
> degradation.
>
> Still actually, I'm not convincing the effectiveness of your formula.
> If possible, could you show it with numbers?

It's not easy to prove the effectiveness of the formula. It's just for
eliminating my concern on the scalability of searching. Since it does
not matter much for the performance improvement, we can put it aside
and choose the simpler method as you suggested.

So, should I revise the patch based on what you suggested or will
you take care of it?

--
Thanks,
Jin

>
> Thanks,
>
>>
>>>>
>>>> What do you think now?
>>>>
>>>>> #define MAX_VICTIM_SEARCH 4096 /* covers 8GB */
>>>>>
>>>>>>     	p->offset = sbi->last_victim[p->gc_mode];
>>>>>> @@ -243,6 +245,8 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
>>>>>>     	struct victim_sel_policy p;
>>>>>>     	unsigned int secno, max_cost;
>>>>>>     	int nsearched = 0;
>>>>>> +	unsigned int max_search = MAX_VICTIM_SEARCH;
>>>>>> +	unsigned int nr_dirty;
>>>>>>
>>>>>>     	p.alloc_mode = alloc_mode;
>>>>>>     	select_policy(sbi, gc_type, type, &p);
>>>>>> @@ -258,6 +262,27 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
>>>>>>     			goto got_it;
>>>>>>     	}
>>>>>>
>>>>>> +	nr_dirty = dirty_i->nr_dirty[p.dirty_type];
>>>>>> +	if (p.gc_mode == GC_GREEDY && p.alloc_mode != SSR) {
>>>>>> +		if (TOTAL_SEGS(sbi) <= FULL_VICTIM_SEARCH_THRESH)
>>>>>> +			max_search = nr_dirty; /* search all the dirty segs */
>>>>>> +		else {
>>>>>> +			/*
>>>>>> +			 * With more dirty segments, garbage blocks are likely
>>>>>> +			 * more scattered, thus search harder for better
>>>>>> +			 * victim.
>>>>>> +			 */
>>>>>> +			max_search = div_u64 ((nr_dirty *
>>>>>> +				FULL_VICTIM_SEARCH_THRESH), TOTAL_SEGS(sbi));
>>>>>> +			if (max_search < MIN_VICTIM_SEARCH_GREEDY)
>>>>>> +				max_search = MIN_VICTIM_SEARCH_GREEDY;
>>>>>> +		}
>>>>>> +	}
>>>>>> +
>>>>>> +	/* no more than the total dirty segments */
>>>>>> +	if (max_search > nr_dirty)
>>>>>> +		max_search = nr_dirty;
>>>>>> +
>>>>>>     	while (1) {
>>>>>>     		unsigned long cost;
>>>>>>     		unsigned int segno;
>>>>>> @@ -290,7 +315,7 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
>>>>>>     		if (cost == max_cost)
>>>>>>     			continue;
>>>>>>
>>>>>> -		if (nsearched++ >= MAX_VICTIM_SEARCH) {
>>>>>> +		if (nsearched++ >= max_search) {
>>>>>
>>>>> 		if (nsearched++ >= p.max_search) {
>>>>>
>>>>>>     			sbi->last_victim[p.gc_mode] = segno;
>>>>>>     			break;
>>>>>>     		}
>>>>>> diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
>>>>>> index 2c6a6bd..2f525aa 100644
>>>>>> --- a/fs/f2fs/gc.h
>>>>>> +++ b/fs/f2fs/gc.h
>>>>>> @@ -20,7 +20,9 @@
>>>>>>     #define LIMIT_FREE_BLOCK	40 /* percentage over invalid + free space */
>>>>>>
>>>>>>     /* Search max. number of dirty segments to select a victim segment */
>>>>>> -#define MAX_VICTIM_SEARCH	20
>>>>>> +#define MAX_VICTIM_SEARCH		20
>>>>>> +#define MIN_VICTIM_SEARCH_GREEDY	20
>>>>>> +#define FULL_VICTIM_SEARCH_THRESH	4096
>>>>>>
>>>>>>     struct f2fs_gc_kthread {
>>>>>>     	struct task_struct *f2fs_gc_task;
>>>>>> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
>>>>>> index 062424a..cd33f96 100644
>>>>>> --- a/fs/f2fs/segment.h
>>>>>> +++ b/fs/f2fs/segment.h
>>>>>> @@ -142,6 +142,7 @@ struct victim_sel_policy {
>>>>>>     	int alloc_mode;			/* LFS or SSR */
>>>>>>     	int gc_mode;			/* GC_CB or GC_GREEDY */
>>>>>>     	unsigned long *dirty_segmap;	/* dirty segment bitmap */
>>>>>> +	int dirty_type;
>>>>>
>>>>> 	int max_search;		/* maximum # of segments to search */
>>>>>
>>>>>>     	unsigned int offset;		/* last scanned bitmap offset */
>>>>>>     	unsigned int ofs_unit;		/* bitmap search unit */
>>>>>>     	unsigned int min_cost;		/* minimum cost */
>>>>>
>>>>
>>>
>>
>> --
>> Thanks,
>> Jin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

