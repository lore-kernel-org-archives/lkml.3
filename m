Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3DLBOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:14:51 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48139 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab3DLBOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:49 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 22/25] mm/page_alloc: in page_outside_zone_boundaries(), avoid premature decisions.
Date: Thu, 11 Apr 2013 18:13:54 -0700
Message-Id: <1365729237-29711-23-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-7182-0000-0000-000006338E9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With some code that expands the zone boundaries, VM_BUG_ON(bad_range()) was being triggered.

Previously, page_outside_zone_boundaries() decided that once it detected
a page outside the boundaries, it was certainly outside even if the
seqlock indicated the data was invalid & needed to be reread. This
methodology _almost_ works because zones are only ever grown. However,
becase the zone span is stored as a start and a length, some expantions
momentarily appear as shifts to the left (when the zone_start_pfn is
assigned prior to zone_spanned_pages).

If we want to remove the seqlock around zone_start_pfn & zone
spanned_pages, always writing the spanned_pages first, issuing a memory
barrier, and then writing the new zone_start_pfn _may_ work. The concern
there is that we could be seen as shrinking the span when zone_start_pfn
is written (the entire span would shift to the left). As there will be
no pages in the exsess span that actually belong to the zone being
manipulated, I don't expect there to be issues.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 97bdf6b..a54baa9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -238,12 +238,13 @@ bool oom_killer_disabled __read_mostly;
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
-	int ret = 0;
+	int ret;
 	unsigned seq;
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long sp, start_pfn;
 
 	do {
+		ret = 0;
 		seq = zone_span_seqbegin(zone);
 		start_pfn = zone->zone_start_pfn;
 		sp = zone->spanned_pages;
-- 
1.8.2.1

