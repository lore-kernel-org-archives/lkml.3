Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaDUVn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:43:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbaDUVnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:43:23 -0400
Message-ID: <535590FC.10607@suse.cz>
Date: Mon, 21 Apr 2014 23:43:24 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>
CC: Heesub Shin <heesub.shin@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dongjun Shin <d.j.shin@samsung.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm/compaction: cleanup isolate_freepages()
References: <5342BA34.8050006@suse.cz>	<1397553507-15330-1-git-send-email-vbabka@suse.cz>	<1397553507-15330-2-git-send-email-vbabka@suse.cz>	<20140417000745.GF27534@bbox> <20140421124146.c8beacf0d58aafff2085a461@linux-foundation.org>
In-Reply-To: <20140421124146.c8beacf0d58aafff2085a461@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.4.2014 21:41, Andrew Morton wrote:
> On Thu, 17 Apr 2014 09:07:45 +0900 Minchan Kim <minchan@kernel.org> wrote:
>
>> Hi Vlastimil,
>>
>> Below just nitpicks.
> It seems you were ignored ;)

Oops, I managed to miss your e-mail, sorry.

>>>   {
>>>   	struct page *page;
>>> -	unsigned long high_pfn, low_pfn, pfn, z_end_pfn;
>>> +	unsigned long pfn, low_pfn, next_free_pfn, z_end_pfn;
>> Could you add comment for each variable?
>>
>> unsigned long pfn; /* scanning cursor */
>> unsigned long low_pfn; /* lowest pfn free scanner is able to scan */
>> unsigned long next_free_pfn; /* start pfn for scaning at next truen */
>> unsigned long z_end_pfn; /* zone's end pfn */
>>
>>
>>> @@ -688,11 +688,10 @@ static void isolate_freepages(struct zone *zone,
>>>   	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
>>>   
>>>   	/*
>>> -	 * Take care that if the migration scanner is at the end of the zone
>>> -	 * that the free scanner does not accidentally move to the next zone
>>> -	 * in the next isolation cycle.
>>> +	 * Seed the value for max(next_free_pfn, pfn) updates. If there are
>>> +	 * none, the pfn < low_pfn check will kick in.
>>         "none" what? I'd like to clear more.

If there are no updates to next_free_pfn within the for cycle. Which 
matches Andrew's formulation below.

> I did this:

Thanks!

>
> --- a/mm/compaction.c~mm-compaction-cleanup-isolate_freepages-fix
> +++ a/mm/compaction.c
> @@ -662,7 +662,10 @@ static void isolate_freepages(struct zon
>   				struct compact_control *cc)
>   {
>   	struct page *page;
> -	unsigned long pfn, low_pfn, next_free_pfn, z_end_pfn;
> +	unsigned long pfn;	     /* scanning cursor */
> +	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
> +	unsigned long next_free_pfn; /* start pfn for scaning at next round */
> +	unsigned long z_end_pfn;     /* zone's end pfn */

Yes that works.

>   	int nr_freepages = cc->nr_freepages;
>   	struct list_head *freelist = &cc->freepages;
>   
> @@ -679,8 +682,8 @@ static void isolate_freepages(struct zon
>   	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
>   
>   	/*
> -	 * Seed the value for max(next_free_pfn, pfn) updates. If there are
> -	 * none, the pfn < low_pfn check will kick in.
> +	 * Seed the value for max(next_free_pfn, pfn) updates. If no pages are
> +	 * isolated, the pfn < low_pfn check will kick in.

OK.

>   	 */
>   	next_free_pfn = 0;
>   
>>> @@ -766,9 +765,9 @@ static void isolate_freepages(struct zone *zone,
>>>   	 * so that compact_finished() may detect this
>>>   	 */
>>>   	if (pfn < low_pfn)
>>> -		cc->free_pfn = max(pfn, zone->zone_start_pfn);
>>> -	else
>>> -		cc->free_pfn = high_pfn;
>>> +		next_free_pfn = max(pfn, zone->zone_start_pfn);
>> Why we need max operation?
>> IOW, what's the problem if we do (next_free_pfn = pfn)?
> An answer to this would be useful, thanks.

The idea (originally, not new here) is that the free scanner wants to 
remember the highest-pfn
block where it managed to isolate some pages. If the following page 
migration fails, these isolated
pages might be put back and would be skipped in further compaction 
attempt if we used just
"next_free_pfn = pfn", until the scanners get reset.

The question of course is if such situations are frequent and makes any 
difference to compaction
outcome. And the downsides are potentially useless rescans and code 
complexity. Maybe Mel
remembers how important this is? It should probably be profiled before 
changes are made.

