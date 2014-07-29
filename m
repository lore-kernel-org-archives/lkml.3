Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbaG2Wxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:53:39 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:57988 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaG2Wxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:53:37 -0400
Date: Tue, 29 Jul 2014 15:53:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
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
In-Reply-To: <53D76E26.6040706@suse.cz>
Message-ID: <alpine.DEB.2.02.1407291548430.20991@chino.kir.corp.google.com>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-8-git-send-email-vbabka@suse.cz> <20140729065327.GB1610@js1304-P5Q-DELUXE> <alpine.DEB.2.02.1407290024550.7998@chino.kir.corp.google.com> <53D76E26.6040706@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014, Vlastimil Babka wrote:

> > I think there's two ways to go about it:
> > 
> >   - allow a single thp fault to be expensive and then rely on deferred
> >     compaction to avoid subsequent calls in the near future, or
> > 
> >   - try to make all thp faults be as least expensive as possible so that
> >     the cumulative effect of faulting large amounts of memory doesn't end
> >     up with lengthy stalls.
> > 
> > Both of these are complex because of the potential for concurrent calls to
> > memory compaction when faulting thp on several cpus.
> > 
> > I also think the second point from that email still applies, that we
> > should abort isolating pages within a pageblock for migration once it can
> > no longer allow a cc->order allocation to succeed.
> 
> That was the RFC patch 15, I hope to reintroduce it soon.

Which of the points above are you planning on addressing in another patch?  
I think the approach would cause the above to be mutually exclusive 
options.

> You could still test
> it meanwhile to see if you see the same extfrag regression as me. In my tests,
> kswapd/khugepaged wasn't doing enough work to defragment the pageblocks that
> the stress-highalloc benchmark (configured to behave like thp page fault) was
> skipping.
> 

The initial regression that I encountered was on a 128GB machine where 
async compaction would cause faulting 64MB of transparent hugepages to 
excessively stall and I don't see how kswapd can address this if there's 
no memory pressure and khugepaged can address it if it has the default 
settings which is very slow.

Another idea I had is to only do async memory compaction for thp on local 
zones and avoid defragmenting remotely since, in my experimentation, 
remote thp memory causes a performance degradation over regular pages.  If 
that solution were to involve zone_reclaim_mode and a test of 
node_distance() > RECLAIM_DISTANCE, I think that would be acceptable as 
well.
