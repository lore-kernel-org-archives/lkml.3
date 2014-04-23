Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbaDWOb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:31:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbaDWObS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:31:18 -0400
Message-ID: <5357CEB2.1070900@suse.cz>
Date: Wed, 23 Apr 2014 16:31:14 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Joonsoo Kim <js1304@gmail.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Heesub Shin <heesub.shin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Dongjun Shin <d.j.shin@samsung.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm/compaction: cleanup isolate_freepages()
References: <5342BA34.8050006@suse.cz>	<1397553507-15330-1-git-send-email-vbabka@suse.cz>	<1397553507-15330-2-git-send-email-vbabka@suse.cz>	<20140417000745.GF27534@bbox>	<20140421124146.c8beacf0d58aafff2085a461@linux-foundation.org>	<535590FC.10607@suse.cz>	<20140421235319.GD7178@bbox>	<53560D3F.2030002@suse.cz>	<20140422065224.GE24292@bbox>	<53566BEA.2060808@suse.cz>	<20140423025806.GA11184@js1304-P5Q-DELUXE>	<53576C08.2080003@suse.cz> <CAAmzW4OjKcrzXYNG6KN8acbOVfVtFmu-1COKpNQJrraBTmWGiA@mail.gmail.com>
In-Reply-To: <CAAmzW4OjKcrzXYNG6KN8acbOVfVtFmu-1COKpNQJrraBTmWGiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>
>>> Hello,
>>>
>>> How about doing more clean-up at this time?
>>>
>>> What I did is that taking end_pfn out of the loop and consider zone
>>> boundary once. After then, we just subtract pageblock_nr_pages on
>>> every iteration. With this change, we can remove local variable, z_end_pfn.
>>> Another things I did are removing max() operation and un-needed
>>> assignment to isolate variable.
>>>
>>> Thanks.
>>>
>>> --------->8------------
>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>> index 1c992dc..95a506d 100644
>>> --- a/mm/compaction.c
>>> +++ b/mm/compaction.c
>>> @@ -671,10 +671,10 @@ static void isolate_freepages(struct zone *zone,
>>>                               struct compact_control *cc)
>>>  {
>>>       struct page *page;
>>> -     unsigned long pfn;           /* scanning cursor */
>>> +     unsigned long pfn;           /* start of scanning window */
>>> +     unsigned long end_pfn;       /* end of scanning window */
>>>       unsigned long low_pfn;       /* lowest pfn scanner is able to scan */
>>>       unsigned long next_free_pfn; /* start pfn for scaning at next round */
>>> -     unsigned long z_end_pfn;     /* zone's end pfn */
>>>       int nr_freepages = cc->nr_freepages;
>>>       struct list_head *freelist = &cc->freepages;
>>>
>>> @@ -688,15 +688,16 @@ static void isolate_freepages(struct zone *zone,
>>>        * is using.
>>>        */
>>>       pfn = cc->free_pfn & ~(pageblock_nr_pages-1);
>>> -     low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
>>>
>>>       /*
>>> -      * Seed the value for max(next_free_pfn, pfn) updates. If no pages are
>>> -      * isolated, the pfn < low_pfn check will kick in.
>>> +      * Take care when isolating in last pageblock of a zone which
>>> +      * ends in the middle of a pageblock.
>>>        */
>>> -     next_free_pfn = 0;
>>> +     end_pfn = min(pfn + pageblock_nr_pages, zone_end_pfn(zone));
>>> +     low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
>>>
>>> -     z_end_pfn = zone_end_pfn(zone);
>>> +     /* If no pages are isolated, the pfn < low_pfn check will kick in. */
>>> +     next_free_pfn = 0;
>>>
>>>       /*
>>>        * Isolate free pages until enough are available to migrate the
>>> @@ -704,9 +705,8 @@ static void isolate_freepages(struct zone *zone,
>>>        * and free page scanners meet or enough free pages are isolated.
>>>        */
>>>       for (; pfn >= low_pfn && cc->nr_migratepages > nr_freepages;
>>> -                                     pfn -= pageblock_nr_pages) {
>>> +             pfn -= pageblock_nr_pages, end_pfn -= pageblock_nr_pages) {
>>
>> If zone_end_pfn was in the middle of a pageblock, then your end_pfn will
>> always be in the middle of a pageblock and you will not scan half of all
>> pageblocks.
>>
> 
> Okay. I think a way to fix it.
> By assigning pfn(start of scanning window) to
> end_pfn(end of scanning window) for the next loop, we can solve the problem
> you mentioned. How about below?
> 
> -             pfn -= pageblock_nr_pages, end_pfn -= pageblock_nr_pages) {
> +            end_pfn = pfn, pfn -= pageblock_nr_pages) {

Hm that's perhaps a bit subtle but it would work.
Maybe better names for pfn and end_pfn would be block_start_pfn and
block_end_pfn. And in those comments, s/scanning window/current pageblock/.
And please don't move the low_pfn assignment like you did. The comment
above the original location explains it, the comment above the new
location doesn't. It's use in the loop is also related to 'pfn', not
'end_pfn'.

> Thanks.
> 

