Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3JaSNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:13:15 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49619 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3JaSNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:13:14 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH v2] mm: __rmqueue_fallback() should respect pageblock type
Date: Thu, 31 Oct 2013 14:13:07 -0400
Message-Id: <1383243188-30514-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

When __rmqueue_fallback() don't find out a free block with the same size
of required, it splits a larger page and puts back rest peiece of the page
to free list.

But it has one serious mistake. When putting back, __rmqueue_fallback()
always use start_migratetype if type is not CMA. However, __rmqueue_fallback()
is only called when all of start_migratetype queue are empty. That said,
__rmqueue_fallback always put back memory to wrong queue except
try_to_steal_freepages() changed pageblock type (i.e. requested size is
smaller than half of page block). Finally, antifragmentation framework
increase fragmenation instead of decrease.

Mel's original anti fragmentation do the right thing. But commit 47118af076
(mm: mmzone: MIGRATE_CMA migration type added) broke it.

This patch restores sane and old behavior. And also it remvoe an incorrect
comment which introduced at commit fef903efcf (mm/page_allo.c: restructure
free-page stealing code and fix a bug).

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_alloc.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dd886fa..d488514 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1027,6 +1027,10 @@ static int try_to_steal_freepages(struct zone *zone, struct page *page,
 {
 	int current_order = page_order(page);
 
+	/*
+	 * When borrowing from MIGRATE_CMA, we need to release the excess
+	 * buddy pages to CMA itself.
+	 */
 	if (is_migrate_cma(fallback_type))
 		return fallback_type;
 
@@ -1091,17 +1095,7 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 			list_del(&page->lru);
 			rmv_page_order(page);
 
-			/*
-			 * Borrow the excess buddy pages as well, irrespective
-			 * of whether we stole freepages, or took ownership of
-			 * the pageblock or not.
-			 *
-			 * Exception: When borrowing from MIGRATE_CMA, release
-			 * the excess buddy pages to CMA itself.
-			 */
-			expand(zone, page, order, current_order, area,
-			       is_migrate_cma(migratetype)
-			     ? migratetype : start_migratetype);
+			expand(zone, page, order, current_order, area, new_type);
 
 			trace_mm_page_alloc_extfrag(page, order,
 				current_order, start_migratetype, migratetype,
-- 
1.7.1

