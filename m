Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbaJaPx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:53:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbaJaPxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:53:55 -0400
Message-ID: <5453B088.6080605@suse.cz>
Date: Fri, 31 Oct 2014 16:53:44 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 4/5] mm, compaction: always update cached scanner positions
References: <1412696019-21761-1-git-send-email-vbabka@suse.cz> <1412696019-21761-5-git-send-email-vbabka@suse.cz> <20141027073522.GB23379@js1304-P5Q-DELUXE> <544E12B5.5070008@suse.cz> <20141028070818.GA27813@js1304-P5Q-DELUXE>
In-Reply-To: <20141028070818.GA27813@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 08:08 AM, Joonsoo Kim wrote:
>>
>>> And, I guess that pageblock skip feature effectively disable pageblock
>>> rescanning if there is no freepage during rescan.
>>
>> If there's no freepage during rescan, then the cached free_pfn also
>> won't be pointed to the pageblock anymore. Regardless of pageblock skip
>> being set, there will not be second rescan. But there will still be the
>> first rescan to determine there are no freepages.
>
> Yes, What I'd like to say is that these would work well. Just decreasing
> few percent of scanning page doesn't look good to me to validate this
> patch, because there is some facilities to reduce rescan overhead and

The mechanisms have a tradeoff, while this patch didn't seem to have 
negative consequences.

> compaction is fundamentally time-consuming process. Moreover, failure of
> compaction could cause serious system crash in some cases.

Relying on successful high-order allocation for not crashing is 
dangerous, success is never guaranteed. Such critical allocation should 
try harder than fail due to a single compaction attempt. With this 
argument you could aim to remove all the overhead reducing heuristics.

>>> This patch would
>>> eliminate effect of pageblock skip feature.
>>
>> I don't think so (as explained above). Also if free pages were isolated
>> (and then returned and skipped over), the pageblock should remain
>> without skip bit, so after scanners meet and positions reset (which
>> doesn't go hand in hand with skip bit reset), the next round will skip
>> over the blocks without freepages and find quickly the blocks where free
>> pages were skipped in the previous round.
>>
>>> IIUC, compaction logic assume that there are many temporary failure
>>> conditions. Retrying from others would reduce effect of this temporary
>>> failure so implementation looks as is.
>>
>> The implementation of pfn caching was written at time when we did not
>> keep isolated free pages between migration attempts in a single
>> compaction run. And the idea of async compaction is to try with minimal
>> effort (thus latency), and if there's a failure, try somewhere else.
>> Making sure we don't skip anything doesn't seem productive.
>
> free_pfn is shared by async/sync compaction and unconditional updating
> causes sync compaction to stop prematurely, too.
>
> And, if this patch makes migrate/freepage scanner meet more frequently,
> there is one problematic scenario.

OK, so you don't find a problem with how this patch changes migration 
scanner caching, just the free scanner, right?
So how about making release_freepages() return the highest freepage pfn 
it encountered (could perhaps do without comparing individual pfn's, the 
list should be ordered so it could be just the pfn of first or last page 
in the list, but need to check that) and updating cached free pfn with 
that? That should ensure rescanning only when needed.

> compact_finished() doesn't check how many work we did. It just check
> if both scanners meet. Even if we failed to allocate high order page
> due to little work, compaction would be deffered for later user.
> This scenario wouldn't happen frequently if updating cached pfn is
> limited. But, this patch may enlarge the possibility of this problem.

I doubt it changes the possibility substantially, but nevermind.

> This is another problem of current logic, and, should be fixed, but,
> there is now.

If something needs the high-order allocation succeed that badly, then 
the proper GFP flags should result in further reclaim and compaction 
attempts (hopefully) and not give up after first sync compaction failure.

> Thanks.
>

