Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3GWCSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:18:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24683 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3GWCSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:18:44 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] mm: kill one if in loop of __free_pages_bootmem
Date: Mon, 22 Jul 2013 19:17:42 -0700
Message-Id: <1374545862-17741-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not check loop+1 with loop end in loop body.
Just duplicate two lines code to avoid it.

That will help a bit when we have huge amount of pages on
system with 16TiB memory.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>

---
 mm/page_alloc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -750,19 +750,19 @@ static void __free_pages_ok(struct page
 void __init __free_pages_bootmem(struct page *page, unsigned int order)
 {
 	unsigned int nr_pages = 1 << order;
+	struct page *p = page;
 	unsigned int loop;
 
-	prefetchw(page);
-	for (loop = 0; loop < nr_pages; loop++) {
-		struct page *p = &page[loop];
-
-		if (loop + 1 < nr_pages)
-			prefetchw(p + 1);
+	prefetchw(p);
+	for (loop = 0; loop < (nr_pages - 1); loop++, p++) {
+		prefetchw(p + 1);
 		__ClearPageReserved(p);
 		set_page_count(p, 0);
 	}
+	__ClearPageReserved(p);
+	set_page_count(p, 0);
 
-	page_zone(page)->managed_pages += 1 << order;
+	page_zone(page)->managed_pages += nr_pages;
 	set_page_refcounted(page);
 	__free_pages(page, order);
 }
