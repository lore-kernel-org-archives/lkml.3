Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaFDWCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:02:42 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33584 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaFDWCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:02:41 -0400
Date: Wed, 4 Jun 2014 15:02:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [patch -mm 3/3] mm, compaction: avoid compacting memory for thp
 if pageblock cannot become free
In-Reply-To: <20140604110411.GK10819@suse.de>
Message-ID: <alpine.DEB.2.02.1406041454070.13330@chino.kir.corp.google.com>
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz> <1400233673-11477-1-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com> <537DB0E5.40602@suse.cz> <alpine.DEB.2.02.1405220127320.13630@chino.kir.corp.google.com>
 <537DE799.3040400@suse.cz> <alpine.DEB.2.02.1406031728390.5312@chino.kir.corp.google.com> <alpine.DEB.2.02.1406031729410.5312@chino.kir.corp.google.com> <20140604110411.GK10819@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Mel Gorman wrote:

> > It's pointless to migrate pages within a pageblock if the entire pageblock will 
> > not become free for a thp allocation.
> > 
> > If we encounter a page that cannot be migrated and a direct compactor other than 
> > khugepaged is trying to allocate a hugepage for thp, then skip the entire 
> > pageblock and avoid migrating pages needlessly.
> > 
> 
> It's not completely pointless. A movable page may be placed within an
> unmovable pageblock due to insufficient free memory or a pageblock changed
> type. When this happens then partial migration moves the movable page
> of out of the unmovable block. Future unmovable allocations can then be
> placed with other unmovable pages instead of falling back to other blocks
> and degrading fragmentation over time.
> 

Sorry, this should say that it's pointless when doing a HPAGE_PMD_ORDER 
allocation and we're calling direct compaction for thp.  While the result 
may be that there will be less external fragmentation in the longrun, I 
don't think it's appropriate to do this at fault.

We keep a running tracker of how long it takes to fault 64MB of anonymous 
memory with thp enabled in one of our production cells.  For an instance 
that took 1.58225s in fault (not including the mmap() time or munmap() 
time), here are the compaction stats:

Before:
compact_blocks_moved 508932592
compact_pages_moved 93068626
compact_pagemigrate_failed 199708939
compact_stall 7014989
compact_fail 6977371
compact_success 37617

After:
compact_blocks_moved 508938635
compact_pages_moved 93068667
compact_pagemigrate_failed 199712677
compact_stall 7015029
compact_fail 6977411
compact_success 37617

Not one of the compaction stalls resulted in a thp page being allocated, 
probably because the number of pages actually migrated is very low.  The 
delta here is 6043 pageblocks scanned over 40 compaction calls, 41 pages 
_total_ being successfully migrated and 3738 pages total being isolated 
but unsuccessfully migrated.

Those statistics are horrible.  We scan approximately 151 pageblocks per 
compaction stall needlessly in this case and, on average, migrate a single 
page but isolate and fail to migrate 93 pages.

I believe my patch would reduce this pointless migration when an entire 
pageblock will not be freed in the thp fault path.  I do need to factor in 
Vlastimil's feedback concerning the PageBuddy order, but I think this is 
generally the right approach for thp fault.

Additionally, I need to figure out why those 3738 pages are isolated but 
fail to migrate and it doesn't seem to be because of any race.  Perhaps 
there will be a chance to do something similar to what I did in commit 
119d6d59dcc0 ("mm, compaction: avoid isolating pinned pages") to avoid 
even considering certain checks, but I'll have to identify the source(s) 
of these failures first.
