Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaG3JIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:08:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaG3JIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:08:32 -0400
Message-ID: <53D8B60C.3020807@suse.cz>
Date: Wed, 30 Jul 2014 11:08:28 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 07/14] mm, compaction: khugepaged should not give up
 due to need_resched()
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-8-git-send-email-vbabka@suse.cz> <20140729065327.GB1610@js1304-P5Q-DELUXE> <alpine.DEB.2.02.1407290024550.7998@chino.kir.corp.google.com> <53D76E26.6040706@suse.cz> <alpine.DEB.2.02.1407291548430.20991@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407291548430.20991@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 12:53 AM, David Rientjes wrote:
> On Tue, 29 Jul 2014, Vlastimil Babka wrote:
>
>>> I think there's two ways to go about it:
>>>
>>>    - allow a single thp fault to be expensive and then rely on deferred
>>>      compaction to avoid subsequent calls in the near future, or
>>>
>>>    - try to make all thp faults be as least expensive as possible so that
>>>      the cumulative effect of faulting large amounts of memory doesn't end
>>>      up with lengthy stalls.
>>>
>>> Both of these are complex because of the potential for concurrent calls to
>>> memory compaction when faulting thp on several cpus.
>>>
>>> I also think the second point from that email still applies, that we
>>> should abort isolating pages within a pageblock for migration once it can
>>> no longer allow a cc->order allocation to succeed.
>>
>> That was the RFC patch 15, I hope to reintroduce it soon.
>
> Which of the points above are you planning on addressing in another patch?
> I think the approach would cause the above to be mutually exclusive
> options.

Oh I meant the quick abort of a pageblock that's not going to succeed. 
That was the RFC patch. As for the single expensive fault + defer vs 
lots of inexpensive faults, I would favor the latter. I'd rather avoid 
bug reports such as "It works fine for a while and then we get this 
weird few seconds of stall", which is exactly what you were dealing with 
IIRC?

>> You could still test
>> it meanwhile to see if you see the same extfrag regression as me. In my tests,
>> kswapd/khugepaged wasn't doing enough work to defragment the pageblocks that
>> the stress-highalloc benchmark (configured to behave like thp page fault) was
>> skipping.
>>
>
> The initial regression that I encountered was on a 128GB machine where
> async compaction would cause faulting 64MB of transparent hugepages to
> excessively stall and I don't see how kswapd can address this if there's
> no memory pressure and khugepaged can address it if it has the default
> settings which is very slow.

Hm I see. I have been thinking about somehow connecting compaction with 
the extfrag (page stealing) events. For example, if it's about to 
allocate UNMOVABLE/RECLAIMABLE page in a MOVABLE pageblock, then try to 
compact the pageblock first, which will hopefully free enough of it to 
have it remarked as UNMOVABLE/RECLAIMABLE and satisfy many such 
allocations without having to steal from another one.

> Another idea I had is to only do async memory compaction for thp on local
> zones and avoid defragmenting remotely since, in my experimentation,
> remote thp memory causes a performance degradation over regular pages.  If
> that solution were to involve zone_reclaim_mode and a test of
> node_distance() > RECLAIM_DISTANCE, I think that would be acceptable as
> well.

Yes, not compacting remote zones on page fault definitely makes sense. 
Maybe even without zone_reclaim_mode...

