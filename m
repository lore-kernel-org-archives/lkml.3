Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbaFIJGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:06:24 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:64178 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316AbaFIJGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:06:21 -0400
Date: Mon, 9 Jun 2014 02:06:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 6/6] mm, compaction: don't migrate in blocks that
 cannot be fully compacted in async direct compaction
In-Reply-To: <53916EE7.9000806@suse.cz>
Message-ID: <alpine.DEB.2.02.1406090156340.24247@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com> <1401898310-14525-1-git-send-email-vbabka@suse.cz> <1401898310-14525-6-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1406041705140.22536@chino.kir.corp.google.com> <53908F10.4020603@suse.cz>
 <alpine.DEB.2.02.1406051431030.18119@chino.kir.corp.google.com> <53916EE7.9000806@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014, Vlastimil Babka wrote:

> > Agreed.  I was thinking higher than 1GB would be possible once we have 
> > your series that does the pageblock skip for thp, I think the expense 
> > would be constant because we won't needlessly be migrating pages unless it 
> > has a good chance at succeeding.
> 
> Looks like a counter of iterations actually done in scanners, maintained in
> compact_control, would work better than any memory size based limit? It could
> better reflect the actual work done and thus latency. Maybe increase the counter
> also for migrations, with a higher cost than for a scanner iteration.
> 

I'm not sure we can expose that to be configurable by userspace in any 
meaningful way.  We'll want to be able to tune this depending on the size 
of the machine if we are to truly remove the need_resched() heuristic and 
give it a sane default.  I was thinking it would be similar to 
khugepaged's pages_to_scan value that it uses on each wakeup.

> > This does beg the question about parallel direct compactors, though, that 
> > will be contending on the same coarse zone->lru_lock locks and immediately 
> > aborting and falling back to PAGE_SIZE pages for thp faults that will be 
> > more likely if your patch to grab the high-order page and return it to the 
> > page allocator is merged.
> 
> Hm can you explain how the page capturing makes this worse? I don't see it.
> 

I was expecting that your patch to capture the high-order page made a 
difference because the zone watermark check doesn't imply the high-order 
page will be allocatable after we return to the page allocator to allocate 
it.  In that case, we terminated compaction prematurely.  If that's true, 
then it seems like no parallel thp allocator will be able to allocate 
memory that another direct compactor has freed without entering compaction 
itself on a fragmented machine, and thus an increase in zone->lru_lock 
contention if there's migratable memory.

Having 32 cpus fault thp memory and all entering compaction and contending 
(and aborting because of contention, currently) on zone->lru_lock is a 
really bad situation.
