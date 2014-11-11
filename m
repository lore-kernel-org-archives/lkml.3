Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaKKLJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:09:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57122 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbaKKLJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 011/170] mm: page_alloc: fix zone allocation fairness on UP
Date: Tue, 11 Nov 2014 11:06:10 +0000
Message-Id: <1415704129-12709-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit abe5f972912d086c080be4bde67750630b6fb38b upstream.

The zone allocation batches can easily underflow due to higher-order
allocations or spills to remote nodes.  On SMP that's fine, because
underflows are expected from concurrency and dealt with by returning 0.
But on UP, zone_page_state will just return a wrapped unsigned long,
which will get past the <= 0 check and then consider the zone eligible
until its watermarks are hit.

Commit 3a025760fc15 ("mm: page_alloc: spill to remote nodes before
waking kswapd") already made the counter-resetting use
atomic_long_read() to accomodate underflows from remote spills, but it
didn't go all the way with it.

Make it clear that these batches are expected to go negative regardless
of concurrency, and use atomic_long_read() everywhere.

Fixes: 81c0a2bb515f ("mm: page_alloc: fair zone allocator policy")
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Leon Romanovsky <leon@leon.nu>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: backported to 3.16 by Johannes Weiner ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/page_alloc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ef44ad736ca1..1cd18c7d2d20 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1965,7 +1965,7 @@ zonelist_scan:
 		if (alloc_flags & ALLOC_FAIR) {
 			if (!zone_local(preferred_zone, zone))
 				continue;
-			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
+			if (atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]) <= 0)
 				continue;
 		}
 		/*
@@ -5694,9 +5694,8 @@ static void __setup_per_zone_wmarks(void)
 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
 
 		__mod_zone_page_state(zone, NR_ALLOC_BATCH,
-				      high_wmark_pages(zone) -
-				      low_wmark_pages(zone) -
-				      zone_page_state(zone, NR_ALLOC_BATCH));
+			high_wmark_pages(zone) - low_wmark_pages(zone) -
+			atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));
 
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
-- 
2.1.0

