Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaDAQJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:09:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44450 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbaDAQJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laura Abbott <lauraa@codeaurora.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 66/86] mm/compaction: break out of loop on !PageBuddy in isolate_freepages_block
Date: Tue,  1 Apr 2014 09:08:19 -0700
Message-Id: <1396368519-12728-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laura Abbott <lauraa@codeaurora.org>

commit 2af120bc040c5ebcda156df6be6a66610ab6957f upstream.

We received several reports of bad page state when freeing CMA pages
previously allocated with alloc_contig_range:

    BUG: Bad page state in process Binder_A  pfn:63202
    page:d21130b0 count:0 mapcount:1 mapping:  (null) index:0x7dfbf
    page flags: 0x40080068(uptodate|lru|active|swapbacked)

Based on the page state, it looks like the page was still in use.  The
page flags do not make sense for the use case though.  Further debugging
showed that despite alloc_contig_range returning success, at least one
page in the range still remained in the buddy allocator.

There is an issue with isolate_freepages_block.  In strict mode (which
CMA uses), if any pages in the range cannot be isolated,
isolate_freepages_block should return failure 0.  The current check
keeps track of the total number of isolated pages and compares against
the size of the range:

        if (strict && nr_strict_required > total_isolated)
                total_isolated = 0;

After taking the zone lock, if one of the pages in the range is not in
the buddy allocator, we continue through the loop and do not increment
total_isolated.  If in the last iteration of the loop we isolate more
than one page (e.g.  last page needed is a higher order page), the check
for total_isolated may pass and we fail to detect that a page was
skipped.  The fix is to bail out if the loop immediately if we are in
strict mode.  There's no benfit to continuing anyway since we need all
pages to be isolated.  Additionally, drop the error checking based on
nr_strict_required and just check the pfn ranges.  This matches with
what isolate_freepages_range does.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/compaction.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 2a17e96..3ddb08b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -248,7 +248,6 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 {
 	int nr_scanned = 0, total_isolated = 0;
 	struct page *cursor, *valid_page = NULL;
-	unsigned long nr_strict_required = end_pfn - blockpfn;
 	unsigned long flags;
 	bool locked = false;
 
@@ -261,11 +260,12 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 
 		nr_scanned++;
 		if (!pfn_valid_within(blockpfn))
-			continue;
+			goto isolate_fail;
+
 		if (!valid_page)
 			valid_page = page;
 		if (!PageBuddy(page))
-			continue;
+			goto isolate_fail;
 
 		/*
 		 * The zone lock must be held to isolate freepages.
@@ -286,12 +286,10 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 
 		/* Recheck this is a buddy page under lock */
 		if (!PageBuddy(page))
-			continue;
+			goto isolate_fail;
 
 		/* Found a free page, break it into order-0 pages */
 		isolated = split_free_page(page);
-		if (!isolated && strict)
-			break;
 		total_isolated += isolated;
 		for (i = 0; i < isolated; i++) {
 			list_add(&page->lru, freelist);
@@ -302,7 +300,15 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		if (isolated) {
 			blockpfn += isolated - 1;
 			cursor += isolated - 1;
+			continue;
 		}
+
+isolate_fail:
+		if (strict)
+			break;
+		else
+			continue;
+
 	}
 
 	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
@@ -312,7 +318,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 	 * pages requested were isolated. If there were any failures, 0 is
 	 * returned and CMA will fail.
 	 */
-	if (strict && nr_strict_required > total_isolated)
+	if (strict && blockpfn < end_pfn)
 		total_isolated = 0;
 
 	if (locked)
-- 
1.8.3.2

