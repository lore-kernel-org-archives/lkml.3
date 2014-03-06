Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbaCFC0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:26:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:34048 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826AbaCFC0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:26:45 -0500
From: Laura Abbott <lauraa@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Laura Abbott <lauraa@codeaurora.org>
Subject: [PATCH] mm/compaction: Break out of loop on !PageBuddy in isolate_freepages_block
Date: Wed,  5 Mar 2014 18:26:40 -0800
Message-Id: <1394072800-11776-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We received several reports of bad page state when freeing CMA pages
previously allocated with alloc_contig_range:

<1>[ 1258.084111] BUG: Bad page state in process Binder_A  pfn:63202
<1>[ 1258.089763] page:d21130b0 count:0 mapcount:1 mapping:  (null) index:0x7dfbf
<1>[ 1258.096109] page flags: 0x40080068(uptodate|lru|active|swapbacked)

Based on the page state, it looks like the page was still in use. The page
flags do not make sense for the use case though. Further debugging showed
that despite alloc_contig_range returning success, at least one page in the
range still remained in the buddy allocator.

There is an issue with isolate_freepages_block. In strict mode (which CMA
uses), if any pages in the range cannot be isolated, isolate_freepages_block
should return failure 0. The current check keeps track of the total number
of isolated pages and compares against the size of the range:

        if (strict && nr_strict_required > total_isolated)
                total_isolated = 0;

After taking the zone lock, if one of the pages in the range is not
in the buddy allocator, we continue through the loop and do not
increment total_isolated. If we end up over isolating by more than
one page (e.g. last since page needed is a higher order page), it
is not possible to detect that the page was skipped. The fix is to
bail out if the loop immediately if we are in strict mode. There's
no benfit to continuing anyway since we need all pages to be
isolated.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 mm/compaction.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index b48c525..3190cef 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -263,12 +263,21 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		struct page *page = cursor;
 
 		nr_scanned++;
-		if (!pfn_valid_within(blockpfn))
-			continue;
+		if (!pfn_valid_within(blockpfn)) {
+			if (strict)
+				break;
+			else
+				continue;
+		}
+
 		if (!valid_page)
 			valid_page = page;
-		if (!PageBuddy(page))
-			continue;
+		if (!PageBuddy(page)) {
+			if (strict)
+				break;
+			else
+				continue;
+		}
 
 		/*
 		 * The zone lock must be held to isolate freepages.
@@ -288,8 +297,12 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 			break;
 
 		/* Recheck this is a buddy page under lock */
-		if (!PageBuddy(page))
-			continue;
+		if (!PageBuddy(page)) {
+			if (strict)
+				break;
+			else
+				continue;
+		}
 
 		/* Found a free page, break it into order-0 pages */
 		isolated = split_free_page(page);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

