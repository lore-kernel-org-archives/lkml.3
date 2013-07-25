Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3GYGvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 02:51:18 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:57534 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab3GYGvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 02:51:15 -0400
Message-ID: <51F0CACE.7040609@gmail.com>
Date: Thu, 25 Jul 2013 14:50:54 +0800
From: Paul Bolle <paul.bollee@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] mm: page_alloc: fair zone allocator policy
References: <1374267325-22865-1-git-send-email-hannes@cmpxchg.org> <1374267325-22865-4-git-send-email-hannes@cmpxchg.org> <51ED9433.60707@redhat.com>
In-Reply-To: <51ED9433.60707@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 04:21 AM, Rik van Riel wrote:
> On 07/19/2013 04:55 PM, Johannes Weiner wrote:
>
>> @@ -1984,7 +1992,8 @@ this_zone_full:
>>           goto zonelist_scan;
>>       }
>>
>> -    if (page)
>> +    if (page) {
>> +        atomic_sub(1U << order, &zone->alloc_batch);
>>           /*
>>            * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
>>            * necessary to allocate the page. The expectation is
>
> Could this be moved into the slow path in buffered_rmqueue and
> rmqueue_bulk, or would the effect of ignoring the pcp buffers be
> too detrimental to keeping the balance between zones?
>
> It would be kind of nice to not have this atomic operation on every
> page allocation...

atomic operation will lock cache line or memory bus? And cmpxchg will 
lock cache line or memory bus? ;-)

>
> As a side benefit, higher-order buffered_rmqueue and rmqueue_bulk
> both happen under the zone->lock, so moving this accounting down
> to that layer might allow you to get rid of the atomics alltogether.
>
> I like the overall approach though. This is something Linux has needed
> for a long time, and could be extremely useful to automatic NUMA
> balancing as well...
>

