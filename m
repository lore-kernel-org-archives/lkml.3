Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaG2Jtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:49:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaG2Jta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:49:30 -0400
Message-ID: <53D76E26.6040706@suse.cz>
Date: Tue, 29 Jul 2014 11:49:26 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 07/14] mm, compaction: khugepaged should not give up
 due to need_resched()
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-8-git-send-email-vbabka@suse.cz> <20140729065327.GB1610@js1304-P5Q-DELUXE> <alpine.DEB.2.02.1407290024550.7998@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407290024550.7998@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 09:31 AM, David Rientjes wrote:
> On Tue, 29 Jul 2014, Joonsoo Kim wrote:
>
>> I have a silly question here.
>> Why need_resched() is criteria to stop async compaction?
>> need_resched() is flagged up when time slice runs out or other reasons.
>> It means that we should stop async compaction at arbitrary timing
>> because process can be on compaction code at arbitrary moment. I think
>> that it isn't reasonable and it doesn't ensure anything. Instead of
>> this approach, how about doing compaction on certain amounts of pageblock
>> for async compaction?
>>
>
> Not a silly question at all, I had the same feeling in
> https://lkml.org/lkml/2014/5/21/730 and proposed it to be a tunable that
> indicates how much work we are willing to do for thp in the pagefault
> path.  It suffers from the fact that past failure to isolate and/or
> migrate memory to free an entire pageblock doesn't indicate that the next
> pageblock will fail as well, but there has to be cutoff at some point or
> async compaction becomes unnecessarily expensive.  We can always rely on
> khugepaged later to do the collapse, assuming we're not faulting memory
> and then immediately pinning it.
>
> I think there's two ways to go about it:
>
>   - allow a single thp fault to be expensive and then rely on deferred
>     compaction to avoid subsequent calls in the near future, or
>
>   - try to make all thp faults be as least expensive as possible so that
>     the cumulative effect of faulting large amounts of memory doesn't end
>     up with lengthy stalls.
>
> Both of these are complex because of the potential for concurrent calls to
> memory compaction when faulting thp on several cpus.
>
> I also think the second point from that email still applies, that we
> should abort isolating pages within a pageblock for migration once it can
> no longer allow a cc->order allocation to succeed.

That was the RFC patch 15, I hope to reintroduce it soon. You could 
still test it meanwhile to see if you see the same extfrag regression as 
me. In my tests, kswapd/khugepaged wasn't doing enough work to 
defragment the pageblocks that the stress-highalloc benchmark 
(configured to behave like thp page fault) was skipping.


