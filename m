Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab3APA2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:28:41 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59882 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758207Ab3APAZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:25:49 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 07/17] mm/page_alloc: use zone_spans_pfn() instead of open coding.
Date: Tue, 15 Jan 2013 16:24:44 -0800
Message-Id: <1358295894-24167-8-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011600-7182-0000-0000-000004762EEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use zone_spans_pfn() instead of open coding pfn ownership checks.

This is split from following patch as could slightly degrade the
generated code. Pre-patch, the code uses it's knowledge that start_pfn <
end_pfn to cut down on the number of comparisons. Post-patch, the
compiler has to figure it out.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index da5a5ec..3911c1a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -978,9 +978,9 @@ int move_freepages_block(struct zone *zone, struct page *page,
 	end_pfn = start_pfn + pageblock_nr_pages - 1;
 
 	/* Do not cross zone boundaries */
-	if (start_pfn < zone->zone_start_pfn)
+	if (!zone_spans_pfn(zone, start_pfn))
 		start_page = page;
-	if (end_pfn >= zone->zone_start_pfn + zone->spanned_pages)
+	if (!zone_spans_pfn(zone, end_pfn))
 		return 0;
 
 	return move_freepages(zone, start_page, end_page, migratetype);
-- 
1.8.0.3

