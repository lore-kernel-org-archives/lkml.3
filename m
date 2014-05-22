Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaEVDUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:20:35 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61070 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaEVDUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:20:34 -0400
Date: Wed, 21 May 2014 20:20:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: compaction is still too expensive for thp (was: [PATCH v2] mm,
 compaction: properly signal and act upon lock and need_sched() contention)
In-Reply-To: <1400233673-11477-1-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com>
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz> <1400233673-11477-1-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Vlastimil Babka wrote:

> Compaction uses compact_checklock_irqsave() function to periodically check for
> lock contention and need_resched() to either abort async compaction, or to
> free the lock, schedule and retake the lock. When aborting, cc->contended is
> set to signal the contended state to the caller. Two problems have been
> identified in this mechanism.
> 
> First, compaction also calls directly cond_resched() in both scanners when no
> lock is yet taken. This call either does not abort async compaction, or set
> cc->contended appropriately. This patch introduces a new compact_should_abort()
> function to achieve both. In isolate_freepages(), the check frequency is
> reduced to once by SWAP_CLUSTER_MAX pageblocks to match what the migration
> scanner does in the preliminary page checks. In case a pageblock is found
> suitable for calling isolate_freepages_block(), the checks within there are
> done on higher frequency.
> 
> Second, isolate_freepages() does not check if isolate_freepages_block()
> aborted due to contention, and advances to the next pageblock. This violates
> the principle of aborting on contention, and might result in pageblocks not
> being scanned completely, since the scanning cursor is advanced. This patch
> makes isolate_freepages_block() check the cc->contended flag and abort.
> 
> In case isolate_freepages() has already isolated some pages before aborting
> due to contention, page migration will proceed, which is OK since we do not
> want to waste the work that has been done, and page migration has own checks
> for contention. However, we do not want another isolation attempt by either
> of the scanners, so cc->contended flag check is added also to
> compaction_alloc() and compact_finished() to make sure compaction is aborted
> right after the migration.
> 

We have a pretty significant problem with async compaction related to thp 
faults and it's not limited to this patch but was intended to be addressed 
in my series as well.  Since this is the latest patch to be proposed for 
aborting async compaction when it's too expensive, it's probably a good 
idea to discuss it here.

With -mm, it turns out that while egregious thp fault latencies were 
reduced, faulting 64MB of memory backed by thp on a fragmented 128GB 
machine can result in latencies of 1-3s for the entire 64MB.  Collecting 
compaction stats from older kernels that give more insight into 
regressions, one such incident is as follows.

Baseline:
compact_blocks_moved 8181986
compact_pages_moved 6549560
compact_pagemigrate_failed 1612070
compact_stall 101959
compact_fail 100895
compact_success 1064

5s later:
compact_blocks_moved 8182447
compact_pages_moved 6550286
compact_pagemigrate_failed 1612092
compact_stall 102023
compact_fail 100959
compact_success 1064

This represents faulting two 64MB ranges of anonymous memory.  As you can 
see, it results in falling back to 4KB pages because all 64 faults of 
hugepages ends up triggering compaction and failing to allocate.  Over the 
64 async compactions, we scan on average 7.2 pageblocks per call, 
successfully migrate 11.3 pages per call, and fail migrating 0.34 pages 
per call.

If each async compaction scans 7.2 pageblocks per call, it would have to 
be called 9103 times to scan all memory on this 128GB machine.  We're 
simply not scanning enough memory as a result of ISOLATE_ABORT due to 
need_resched().

So the net result is that -mm is much better than Linus's tree, where such 
faulting of 64MB ranges could stall 8-9s, but we're still very expensive.  
We may need to consider scanning more memory on a single call to async 
compaction even when need_resched() and if we are unsuccessful in 
allocating a hugepage to defer async compaction in subsequent calls up to 
1 << COMPACT_MAX_DEFER_SHIFT.  Today, we defer on sync compaction but that 
is now never done for thp faults since it is reliant solely on async 
compaction.

I have a few improvements in mind, but thought it would be better to 
get feedback on it first because it's a substantial rewrite of the 
pageblock migration:

 - For all async compaction, avoid migrating memory unless enough 
   contiguous memory is migrated to allow a cc->order allocation.  This
   would remove the COMPACT_CLUSTER_MAX restriction on pageblock
   compaction and keep pages on the cc->migratepages list between
   calls to isolate_migratepages_range().

   When an unmigratable page is encountered or memory hole is found,
   put all pages on cc->migratepages back on the lru lists unless
   cc->nr_migratepages >= (1 << cc->order).  Otherwise, migrate when
   enough contiguous memory has been isolated.

 - Remove the need_resched() checks entirely from compaction and
   consider only doing a set amount of scanning for each call, such
   as 1GB per call.

   If there is contention on zone->lru_lock, then we can still abort
   to avoid excessive stalls, but need_resched() is a poor heuristic
   to determine when async compaction is taking too long.

   The expense of calling async compaction if this is done is easily
   quantified since we're not migrating any memory unless it is
   sufficient for the page allocation: it would simply be the iteration
   over 1GB of memory and avoiding contention on zone->lru_lock.

We may also need to consider deferring async compaction for subsequent 
faults in the near future even though scanning the previous 1GB does not 
decrease or have any impact whatsoever in the success of defragmenting the 
next 1GB.

Any other suggestions that may be helpful?  
