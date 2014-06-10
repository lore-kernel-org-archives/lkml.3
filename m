Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbaFJTyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:54:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaFJTyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:54:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 157/160] mm: compaction: detect when scanners meet in isolate_freepages
Date: Tue, 10 Jun 2014 12:46:37 -0700
Message-Id: <1402429600-20477-158-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

commit 7ed695e069c3cbea5e1fd08f84a04536da91f584 upstream.

Compaction of a zone is finished when the migrate scanner (which begins
at the zone's lowest pfn) meets the free page scanner (which begins at
the zone's highest pfn).  This is detected in compact_zone() and in the
case of direct compaction, the compact_blockskip_flush flag is set so
that kswapd later resets the cached scanner pfn's, and a new compaction
may again start at the zone's borders.

The meeting of the scanners can happen during either scanner's activity.
However, it may currently fail to be detected when it occurs in the free
page scanner, due to two problems.  First, isolate_freepages() keeps
free_pfn at the highest block where it isolated pages from, for the
purposes of not missing the pages that are returned back to allocator
when migration fails.  Second, failing to isolate enough free pages due
to scanners meeting results in -ENOMEM being returned by
migrate_pages(), which makes compact_zone() bail out immediately without
calling compact_finished() that would detect scanners meeting.

This failure to detect scanners meeting might result in repeated
attempts at compaction of a zone that keep starting from the cached
pfn's close to the meeting point, and quickly failing through the
-ENOMEM path, without the cached pfns being reset, over and over.  This
has been observed (through additional tracepoints) in the third phase of
the mmtests stress-highalloc benchmark, where the allocator runs on an
otherwise idle system.  The problem was observed in the DMA32 zone,
which was used as a fallback to the preferred Normal zone, but on the
4GB system it was actually the largest zone.  The problem is even
amplified for such fallback zone - the deferred compaction logic, which
could (after being fixed by a previous patch) reset the cached scanner
pfn's, is only applied to the preferred zone and not for the fallbacks.

The problem in the third phase of the benchmark was further amplified by
commit 81c0a2bb515f ("mm: page_alloc: fair zone allocator policy") which
resulted in a non-deterministic regression of the allocation success
rate from ~85% to ~65%.  This occurs in about half of benchmark runs,
making bisection problematic.  It is unlikely that the commit itself is
buggy, but it should put more pressure on the DMA32 zone during phases 1
and 2, which may leave it more fragmented in phase 3 and expose the bugs
that this patch fixes.

The fix is to make scanners meeting in isolate_freepage() stay that way,
and to check in compact_zone() for scanners meeting when migrate_pages()
returns -ENOMEM.  The result is that compact_finished() also detects
scanners meeting and sets the compact_blockskip_flush flag to make
kswapd reset the scanner pfn's.

The results in stress-highalloc benchmark show that the "regression" by
commit 81c0a2bb515f in phase 3 no longer occurs, and phase 1 and 2
allocation success rates are also significantly improved.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: 3.13-stable prereq for:
  49e068f mm/compaction: make isolate_freepages start at pageblock boundary ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/compaction.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index b74dc61..0d3ab2c 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -666,7 +666,7 @@ static void isolate_freepages(struct zone *zone,
 	 * is the end of the pageblock the migration scanner is using.
 	 */
 	pfn = cc->free_pfn;
-	low_pfn = cc->migrate_pfn + pageblock_nr_pages;
+	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
 
 	/*
 	 * Take care that if the migration scanner is at the end of the zone
@@ -682,7 +682,7 @@ static void isolate_freepages(struct zone *zone,
 	 * pages on cc->migratepages. We stop searching if the migrate
 	 * and free page scanners meet or enough free pages are isolated.
 	 */
-	for (; pfn > low_pfn && cc->nr_migratepages > nr_freepages;
+	for (; pfn >= low_pfn && cc->nr_migratepages > nr_freepages;
 					pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
 
@@ -744,7 +744,14 @@ static void isolate_freepages(struct zone *zone,
 	/* split_free_page does not map the pages */
 	map_pages(freelist);
 
-	cc->free_pfn = high_pfn;
+	/*
+	 * If we crossed the migrate scanner, we want to keep it that way
+	 * so that compact_finished() may detect this
+	 */
+	if (pfn < low_pfn)
+		cc->free_pfn = max(pfn, zone->zone_start_pfn);
+	else
+		cc->free_pfn = high_pfn;
 	cc->nr_freepages = nr_freepages;
 }
 
@@ -1009,7 +1016,11 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 		if (err) {
 			putback_movable_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
-			if (err == -ENOMEM) {
+			/*
+			 * migrate_pages() may return -ENOMEM when scanners meet
+			 * and we want compact_finished() to detect it
+			 */
+			if (err == -ENOMEM && cc->free_pfn > cc->migrate_pfn) {
 				ret = COMPACT_PARTIAL;
 				goto out;
 			}
-- 
1.9.1

