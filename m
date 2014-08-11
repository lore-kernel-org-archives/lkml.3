Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaHKMeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:34:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbaHKMeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:34:07 -0400
Message-ID: <53E8B83D.1070004@suse.cz>
Date: Mon, 11 Aug 2014 14:34:05 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 6/6] mm: page_alloc: Reduce cost of the fair zone allocation
 policy
References: <1404893588-21371-1-git-send-email-mgorman@suse.de> <1404893588-21371-7-git-send-email-mgorman@suse.de> <53E4EC53.1050904@suse.cz> <20140811121241.GD7970@suse.de>
In-Reply-To: <20140811121241.GD7970@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 02:12 PM, Mel Gorman wrote:
> On Fri, Aug 08, 2014 at 05:27:15PM +0200, Vlastimil Babka wrote:
>> On 07/09/2014 10:13 AM, Mel Gorman wrote:
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -1604,6 +1604,9 @@ again:
>>>   	}
>>>
>>>   	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
>>
>> This can underflow zero, right?
>>
>
> Yes, because of per-cpu accounting drift.

I meant mainly because of order > 0.

>>> +	if (zone_page_state(zone, NR_ALLOC_BATCH) == 0 &&
>>
>> AFAICS, zone_page_state will correct negative values to zero only for
>> CONFIG_SMP. Won't this check be broken on !CONFIG_SMP?
>>
>
> On !CONFIG_SMP how can there be per-cpu accounting drift that would make
> that counter negative?

Well original code used "if (zone_page_state(zone, NR_ALLOC_BATCH) <= 
0)" elsewhere, that you are replacing with zone_is_fair_depleted check. 
I assumed it's because it can get negative due to order > 0. I might 
have not looked thoroughly enough but it seems to me there's nothing 
that would prevent it, such as skipping a zone because its remaining 
batch is lower than 1 << order.
So I think the check should be "<= 0" to be safe.

Vlastimil


