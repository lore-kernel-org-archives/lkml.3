Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaHAIvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:51:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbaHAIvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:51:11 -0400
Message-ID: <53DB54FB.6050100@suse.cz>
Date: Fri, 01 Aug 2014 10:51:07 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 02/14] mm, compaction: defer each zone individually
 instead of preferred zone
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-3-git-send-email-vbabka@suse.cz> <20140729063840.GA1610@js1304-P5Q-DELUXE> <53D76592.10105@suse.cz> <53D91BC9.7080506@suse.cz>
In-Reply-To: <53D91BC9.7080506@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 06:22 PM, Vlastimil Babka wrote:
> On 07/29/2014 11:12 AM, Vlastimil Babka wrote:
>> On 07/29/2014 08:38 AM, Joonsoo Kim wrote:
>>>
>>> I still don't understand why defer_compaction() is needed here.
>>> defer_compaction() is intended for not struggling doing compaction on
>>> the zone where we already have tried compaction and found that it
>>> isn't suitable for compaction. Allocation failure doesn't tell us
>>> that we have tried compaction for all the zone range so we shouldn't
>>> make a decision here to defer compaction on this zone carelessly.
>>
>> OK I can remove that, it should make the code nicer anyway.
>
> Weird, that removal of this defer_compaction() call seems ho have
> quadrupled compact_stall and compact_fail counts. The scanner pages
> counters however increased by only 10% so that could indicate the
> problem is occuring only in a small zone such as DMA. Could be another
> case of mismatch between watermark checking in compaction and
> allocation? Perhaps the lack of proper classzone_idx in the compaction
> check? Sigh.

Yep so it was the DMA zone returning COMPACT_PARTIAL from the 
compaction_suitable() check done at the very beginning of 
compact_zone(). The meaning of that is "the allocation should succeed 
without compaction", so compaction is not done at all. Yet the 
COMPACT_PARTIAL return value means it counts as a stall, even with the 
patch that doesn't count COMPACT_SKIPPED as stalls.
The watermark check in try_to_compact_pages() also apparently succeeds 
as the compaction is not being deferred. With deferral removed from 
__alloc_pages_direct_compact(), this zone will be attempted uselessly 
each time, and deferred_compaction is practically never reported back.

So for now I think it would be best to leave the defer_compaction() call 
in __alloc_pages_direct_compact() as it is. Fixing this in a better way 
would require more investigation (I guess the lack of classzone_idx in 
compaction makes the difference for the watermark checks here) and 
another patch(es), which I'll attempt, but I don't want to further grow 
this series with new patches right now.

>> I also agree
>> with the argument "for all the zone range" and I also realized that it's
>> not (both before and after this patch) really the case. I planned to fix
>> that in the future, but I can probably do it now.
>> The plan is to call defer_compaction() only when compaction returned
>> COMPACT_COMPLETE (and not COMPACT_PARTIAL) as it means the whole zone
>> was scanned. Otherwise there will be bias towards the beginning of the
>> zone in the migration scanner - compaction will be deferred half-way and
>> then cached pfn's might be reset when it restarts, and the rest of the
>> zone won't be scanned at all.
>
> Hm despite expectations, this didn't seem to make much difference. But
> maybe there will be once I have some idea what happened to those stalls.

Yeah, so it doesn't matter here if I call defer_compaction() with only 
COMPACT_COMPLETE returned from compact_zone(). The whole thing is only 
done when watermarks check fails, and it doesn't for the DMA zone.

>>> Thanks.
>>>
>>
>

