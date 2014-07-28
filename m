Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaG1NPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:15:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbaG1NMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:12:06 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH v5 00/14] compaction: balancing overhead and success rates
Date: Mon, 28 Jul 2014 15:11:27 +0200
Message-Id: <1406553101-29326-1-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on next-20140728.

Here's v5 of the series. I declared v4 ready on friday, so obviously I had to
immediately realize there's bug in one of the patches. So here's a new posting
with these changes:

- Patch 14 had two issues in v4. The major issue was leaking captured pages
  when called from compact_pgdat() by kswapd. I thought that checking for
  cc->order is enough to recognize a direct compaction, but missed that kswapd
  also uses an order > 0 and does not consume any page. Fixed by adopting the
  approach in original capture commit 1fb3f8ca0e92: cc->capture_page is no
  longer a "struct page *", but "struct page **" and only when it's non-NULL
  (in direct compaction) it means the caller wants a captured page pointer
  filled there.

  The minor issue was that during changes from v3 and v4, a rebase snafu lead
  to removing the check whether to capture pages, based on matching pageblock
  migratetype. So it could e.g. capture a page for UNMOVABLE allocation inside
  a MOVABLE pageblock, which is undesired. So in v5 the check is back and
  slightly improved by observing that if we want the whole pageblock, it does
  not matter what its migratetype is.

- Patch 15 dropped for now (was always RFC), will appear in future series, as
  it was negatively affecting extfrag. The (theoretical so far) explanation is
  that by aggressively skipping a pageblock as soon as it cannot be completely
  compacted, we fail to create lower-than-9-order free pages that could still
  be  otherwise created. Since page stealing works by stealing the
  highest-order-available page and then satisfying potentially many allocations
  from that, lack of high-order pages means more stealing events in potentially
  more different pageblocks, so that many MOVABLE pageblocks are polluted, each
  by only a few UNMOVABLE pages, which is still enough to kill the pageblocks
  for the purposes of THP(-like) allocation.

- Patch 7 has benchmark data included.

- Checkpatch fixes applied, Acked-by's from Mel added.

David Rientjes (2):
  mm: rename allocflags_to_migratetype for clarity
  mm, compaction: pass gfp mask to compact_control

Vlastimil Babka (12):
  mm, THP: don't hold mmap_sem in khugepaged when allocating THP
  mm, compaction: defer each zone individually instead of preferred zone
  mm, compaction: do not count compact_stall if all zones skipped
    compaction
  mm, compaction: do not recheck suitable_migration_target under lock
  mm, compaction: move pageblock checks up from
    isolate_migratepages_range()
  mm, compaction: reduce zone checking frequency in the migration
    scanner
  mm, compaction: khugepaged should not give up due to need_resched()
  mm, compaction: periodically drop lock and restore IRQs in scanners
  mm, compaction: skip rechecks when lock was already held
  mm, compaction: remember position within pageblock in free pages
    scanner
  mm, compaction: skip buddy pages by their order in the migrate scanner
  mm, compaction: try to capture the just-created high-order freepage

 include/linux/compaction.h |  28 +-
 include/linux/gfp.h        |   2 +-
 mm/compaction.c            | 757 ++++++++++++++++++++++++++++++++-------------
 mm/huge_memory.c           |  20 +-
 mm/internal.h              |  28 +-
 mm/page_alloc.c            | 189 ++++++++---
 6 files changed, 733 insertions(+), 291 deletions(-)

-- 
1.8.4.5

