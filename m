Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab3APA2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:28:17 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:39030 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab3APAZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:25:54 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <jmesmon@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 08/17] mm/page_alloc: use zone_spans_pfn() instead of open coded checks.
Date: Tue, 15 Jan 2013 16:24:45 -0800
Message-Id: <1358295894-24167-9-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011600-3620-0000-0000-000000E82EA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <jmesmon@gmail.com>

In 2 VM_BUG()s, avoid open coding zone ownership of pfns.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3911c1a..c5d70ce 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -242,9 +242,7 @@ static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 
 	do {
 		seq = zone_span_seqbegin(zone);
-		if (pfn >= zone->zone_start_pfn + zone->spanned_pages)
-			ret = 1;
-		else if (pfn < zone->zone_start_pfn)
+		if (!zone_spans_pfn(zone, pfn))
 			ret = 1;
 	} while (zone_span_seqretry(zone, seq));
 
@@ -5639,8 +5637,7 @@ void set_pageblock_flags_group(struct page *page, unsigned long flags,
 	pfn = page_to_pfn(page);
 	bitmap = get_pageblock_bitmap(zone, pfn);
 	bitidx = pfn_to_bitidx(zone, pfn);
-	VM_BUG_ON(pfn < zone->zone_start_pfn);
-	VM_BUG_ON(pfn >= zone->zone_start_pfn + zone->spanned_pages);
+	VM_BUG_ON(!zone_spans_pfn(zone, pfn));
 
 	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
 		if (flags & value)
-- 
1.8.0.3

