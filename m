Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaFLXXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:23:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaFLXSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:18:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Heesub Shin <heesub.shin@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Dongjun Shin <d.j.shin@samsung.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 13/18] mm/compaction: make isolate_freepages start at pageblock boundary
Date: Thu, 12 Jun 2014 16:22:17 -0700
Message-Id: <20140612232213.530448958@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232212.960235342@linuxfoundation.org>
References: <20140612232212.960235342@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

commit 49e068f0b73dd042c186ffa9b420a9943e90389a upstream.

The compaction freepage scanner implementation in isolate_freepages()
starts by taking the current cc->free_pfn value as the first pfn.  In a
for loop, it scans from this first pfn to the end of the pageblock, and
then subtracts pageblock_nr_pages from the first pfn to obtain the first
pfn for the next for loop iteration.

This means that when cc->free_pfn starts at offset X rather than being
aligned on pageblock boundary, the scanner will start at offset X in all
scanned pageblock, ignoring potentially many free pages.  Currently this
can happen when

 a) zone's end pfn is not pageblock aligned, or

 b) through zone->compact_cached_free_pfn with CONFIG_HOLES_IN_ZONE
    enabled and a hole spanning the beginning of a pageblock

This patch fixes the problem by aligning the initial pfn in
isolate_freepages() to pageblock boundary.  This also permits replacing
the end-of-pageblock alignment within the for loop with a simple
pageblock_nr_pages increment.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Heesub Shin <heesub.shin@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -657,16 +657,20 @@ static void isolate_freepages(struct zon
 				struct compact_control *cc)
 {
 	struct page *page;
-	unsigned long high_pfn, low_pfn, pfn, z_end_pfn, end_pfn;
+	unsigned long high_pfn, low_pfn, pfn, z_end_pfn;
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
 	/*
 	 * Initialise the free scanner. The starting point is where we last
-	 * scanned from (or the end of the zone if starting). The low point
-	 * is the end of the pageblock the migration scanner is using.
+	 * successfully isolated from, zone-cached value, or the end of the
+	 * zone when isolating for the first time. We need this aligned to
+	 * the pageblock boundary, because we do pfn -= pageblock_nr_pages
+	 * in the for loop.
+	 * The low boundary is the end of the pageblock the migration scanner
+	 * is using.
 	 */
-	pfn = cc->free_pfn;
+	pfn = cc->free_pfn & ~(pageblock_nr_pages-1);
 	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
 
 	/*
@@ -686,6 +690,7 @@ static void isolate_freepages(struct zon
 	for (; pfn >= low_pfn && cc->nr_migratepages > nr_freepages;
 					pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
+		unsigned long end_pfn;
 
 		if (!pfn_valid(pfn))
 			continue;
@@ -713,13 +718,10 @@ static void isolate_freepages(struct zon
 		isolated = 0;
 
 		/*
-		 * As pfn may not start aligned, pfn+pageblock_nr_page
-		 * may cross a MAX_ORDER_NR_PAGES boundary and miss
-		 * a pfn_valid check. Ensure isolate_freepages_block()
-		 * only scans within a pageblock
+		 * Take care when isolating in last pageblock of a zone which
+		 * ends in the middle of a pageblock.
 		 */
-		end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
-		end_pfn = min(end_pfn, z_end_pfn);
+		end_pfn = min(pfn + pageblock_nr_pages, z_end_pfn);
 		isolated = isolate_freepages_block(cc, pfn, end_pfn,
 						   freelist, false);
 		nr_freepages += isolated;


