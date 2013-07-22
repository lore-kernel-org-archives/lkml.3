Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3GVWtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:49:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab3GVWtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:49:09 -0400
Message-ID: <51EDB6D9.30100@redhat.com>
Date: Mon, 22 Jul 2013 18:48:57 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] mm: page_alloc: fair zone allocator policy
References: <1374267325-22865-1-git-send-email-hannes@cmpxchg.org> <1374267325-22865-4-git-send-email-hannes@cmpxchg.org> <51ED9433.60707@redhat.com> <20130722210423.GG715@cmpxchg.org>
In-Reply-To: <20130722210423.GG715@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 05:04 PM, Johannes Weiner wrote:
> On Mon, Jul 22, 2013 at 04:21:07PM -0400, Rik van Riel wrote:
>> On 07/19/2013 04:55 PM, Johannes Weiner wrote:
>>
>>> @@ -1984,7 +1992,8 @@ this_zone_full:
>>>   		goto zonelist_scan;
>>>   	}
>>>
>>> -	if (page)
>>> +	if (page) {
>>> +		atomic_sub(1U << order, &zone->alloc_batch);
>>>   		/*
>>>   		 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
>>>   		 * necessary to allocate the page. The expectation is
>>
>> Could this be moved into the slow path in buffered_rmqueue and
>> rmqueue_bulk, or would the effect of ignoring the pcp buffers be
>> too detrimental to keeping the balance between zones?
>
> What I'm worried about is not the inaccury that comes from the buffer
> size but the fact that there are no guaranteed buffer empty+refill
> cycles.  The reclaimer could end up feeding the pcp list that the
> allocator is using indefinitely, which brings us back to the original
> problem.  If you have >= NR_CPU jobs running, the kswapds are bound to
> share CPUs with the allocating tasks, so the scenario is not unlikely.

You are absolutely right.  Thinking about it some more,
I cannot think of a better way to do this than your patch.

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
