Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3H3EGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:06:53 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50103 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3H3EGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:06:52 -0400
Message-ID: <52201A4F.9020808@gmail.com>
Date: Fri, 30 Aug 2013 12:06:39 +0800
From: Jin Xu <jinuxstyle@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] f2fs: optimize gc for better performance
References: <1377737323-11803-1-git-send-email-jinuxstyle@gmail.com> <1377777368.2354.46.camel@kjgkr>
In-Reply-To: <1377777368.2354.46.camel@kjgkr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

On 08/29/2013 07:56 PM, Jaegeuk Kim wrote:
> Hi,
>
> 2013-08-29 (목), 08:48 +0800, Jin Xu:
>> From: Jin Xu <jinuxstyle@gmail.com>
>>
>> This patch improves the foreground gc efficiency by optimizing the
>> victim selection policy. With this optimization, the random re-write
>> performance could increase up to 20%.
>>
[...]
>>
>> In this patch, it does not search a constant number of dirty segments
>> anymore, instead it calculates the number based on the total segments,
>> dirty segments and a threshold. Following is the pseudo formula.
>> 		,-- nr_dirty_segments, if total_segments < threshold
>> (# of search) = |
>> 		`-- (nr_dirty_segments * threshold) / total_segments,
>>                          Otherwise
>
> Nice catch, but,
> I don't understand why we search the # of segments in proportion to the
> # of dirty segments.
> How about the case where threshold = 10 and total_segments = 100000?
> Or threshold = 1000000 and total_segments = 100?
> For this, we need to define additional MIN/MAX thresholds and another
> handling codes as your proposal.
>

Firstly, calculating the # of search this way could constraint the
searching overhead in a certain level even when the total segments is
too many.
Secondly, when there are more dirty segments, the same # of garbage
blocks might be more  scattered than when there are less dirty segments.
So we search the # of the segments in proportion to the # of dirty
segments.

[...]
>
> It seems that we can obtain the performance gain just by setting the
> MAX_VICTIM_SEARCH to 4096, for example.
> So, how about just adding an ending criteria like below?
>

I agree that we could get the performance improvement by simply
enlarging the MAX_VICTIM_SEARCH to 4096, but I am concerning the
scalability a little bit. Because it might always searching the whole
bitmap in some cases, for example, when dirty segments is 4000 and
total segments is 409600.

> [snip]
[...]
>
> 	if (p->max_search > MAX_VICTIM_SEARCH)
> 		p->max_search = MAX_VICTIM_SEARCH;
>

The optimization does not apply to SSR mode. There has a reason.
As noticed in the test, when SSR selected the segments that have most
garbage blocks, then when gc is needed, all the dirty segments might
have very less garbage blocks, thus the gc overhead is high. This might
lead to performance degradation. So the patch does not change the
victim selection policy for SSR.

What do you think now?

> #define MAX_VICTIM_SEARCH 4096 /* covers 8GB */
>
>>   	p->offset = sbi->last_victim[p->gc_mode];
>> @@ -243,6 +245,8 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
>>   	struct victim_sel_policy p;
>>   	unsigned int secno, max_cost;
>>   	int nsearched = 0;
>> +	unsigned int max_search = MAX_VICTIM_SEARCH;
>> +	unsigned int nr_dirty;
>>
>>   	p.alloc_mode = alloc_mode;
>>   	select_policy(sbi, gc_type, type, &p);
>> @@ -258,6 +262,27 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
>>   			goto got_it;
>>   	}
>>
>> +	nr_dirty = dirty_i->nr_dirty[p.dirty_type];
>> +	if (p.gc_mode == GC_GREEDY && p.alloc_mode != SSR) {
>> +		if (TOTAL_SEGS(sbi) <= FULL_VICTIM_SEARCH_THRESH)
>> +			max_search = nr_dirty; /* search all the dirty segs */
>> +		else {
>> +			/*
>> +			 * With more dirty segments, garbage blocks are likely
>> +			 * more scattered, thus search harder for better
>> +			 * victim.
>> +			 */
>> +			max_search = div_u64 ((nr_dirty *
>> +				FULL_VICTIM_SEARCH_THRESH), TOTAL_SEGS(sbi));
>> +			if (max_search < MIN_VICTIM_SEARCH_GREEDY)
>> +				max_search = MIN_VICTIM_SEARCH_GREEDY;
>> +		}
>> +	}
>> +
>> +	/* no more than the total dirty segments */
>> +	if (max_search > nr_dirty)
>> +		max_search = nr_dirty;
>> +
>>   	while (1) {
>>   		unsigned long cost;
>>   		unsigned int segno;
>> @@ -290,7 +315,7 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
>>   		if (cost == max_cost)
>>   			continue;
>>
>> -		if (nsearched++ >= MAX_VICTIM_SEARCH) {
>> +		if (nsearched++ >= max_search) {
>
> 		if (nsearched++ >= p.max_search) {
>
>>   			sbi->last_victim[p.gc_mode] = segno;
>>   			break;
>>   		}
>> diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
>> index 2c6a6bd..2f525aa 100644
>> --- a/fs/f2fs/gc.h
>> +++ b/fs/f2fs/gc.h
>> @@ -20,7 +20,9 @@
>>   #define LIMIT_FREE_BLOCK	40 /* percentage over invalid + free space */
>>
>>   /* Search max. number of dirty segments to select a victim segment */
>> -#define MAX_VICTIM_SEARCH	20
>> +#define MAX_VICTIM_SEARCH		20
>> +#define MIN_VICTIM_SEARCH_GREEDY	20
>> +#define FULL_VICTIM_SEARCH_THRESH	4096
>>
>>   struct f2fs_gc_kthread {
>>   	struct task_struct *f2fs_gc_task;
>> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
>> index 062424a..cd33f96 100644
>> --- a/fs/f2fs/segment.h
>> +++ b/fs/f2fs/segment.h
>> @@ -142,6 +142,7 @@ struct victim_sel_policy {
>>   	int alloc_mode;			/* LFS or SSR */
>>   	int gc_mode;			/* GC_CB or GC_GREEDY */
>>   	unsigned long *dirty_segmap;	/* dirty segment bitmap */
>> +	int dirty_type;
>
> 	int max_search;		/* maximum # of segments to search */
>
>>   	unsigned int offset;		/* last scanned bitmap offset */
>>   	unsigned int ofs_unit;		/* bitmap search unit */
>>   	unsigned int min_cost;		/* minimum cost */
>

