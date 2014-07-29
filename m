Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaG2HbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 03:31:18 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34772 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaG2HbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 03:31:16 -0400
Date: Tue, 29 Jul 2014 00:31:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Vlastimil Babka <vbabka@suse.cz>,
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
In-Reply-To: <20140729065327.GB1610@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.02.1407290024550.7998@chino.kir.corp.google.com>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-8-git-send-email-vbabka@suse.cz> <20140729065327.GB1610@js1304-P5Q-DELUXE>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014, Joonsoo Kim wrote:

> I have a silly question here.
> Why need_resched() is criteria to stop async compaction?
> need_resched() is flagged up when time slice runs out or other reasons.
> It means that we should stop async compaction at arbitrary timing
> because process can be on compaction code at arbitrary moment. I think
> that it isn't reasonable and it doesn't ensure anything. Instead of
> this approach, how about doing compaction on certain amounts of pageblock
> for async compaction?
> 

Not a silly question at all, I had the same feeling in 
https://lkml.org/lkml/2014/5/21/730 and proposed it to be a tunable that 
indicates how much work we are willing to do for thp in the pagefault 
path.  It suffers from the fact that past failure to isolate and/or 
migrate memory to free an entire pageblock doesn't indicate that the next 
pageblock will fail as well, but there has to be cutoff at some point or 
async compaction becomes unnecessarily expensive.  We can always rely on 
khugepaged later to do the collapse, assuming we're not faulting memory 
and then immediately pinning it.

I think there's two ways to go about it:

 - allow a single thp fault to be expensive and then rely on deferred
   compaction to avoid subsequent calls in the near future, or

 - try to make all thp faults be as least expensive as possible so that
   the cumulative effect of faulting large amounts of memory doesn't end
   up with lengthy stalls.

Both of these are complex because of the potential for concurrent calls to 
memory compaction when faulting thp on several cpus.

I also think the second point from that email still applies, that we 
should abort isolating pages within a pageblock for migration once it can 
no longer allow a cc->order allocation to succeed.
