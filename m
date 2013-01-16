Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab3APA0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:26:23 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53881 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758283Ab3APA0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:26:19 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 15/17] mm/page_alloc: add informative debugging message in page_outside_zone_boundaries()
Date: Tue, 15 Jan 2013 16:24:52 -0800
Message-Id: <1358295894-24167-16-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011600-5806-0000-0000-00001E4CE7C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a debug message which prints when a page is found outside of the
boundaries of the zone it should belong to. Format is:
	"page $pfn outside zone [ $start_pfn - $end_pfn ]"

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f8ed277..f1783cf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -239,13 +239,20 @@ static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 	int ret = 0;
 	unsigned seq;
 	unsigned long pfn = page_to_pfn(page);
+	unsigned long sp, start_pfn;
 
 	do {
 		seq = zone_span_seqbegin(zone);
+		start_pfn = zone->zone_start_pfn;
+		sp = zone->spanned_pages;
 		if (!zone_spans_pfn(zone, pfn))
 			ret = 1;
 	} while (zone_span_seqretry(zone, seq));
 
+	if (ret)
+		pr_debug("page %lu outside zone [ %lu - %lu ]\n",
+			pfn, start_pfn, start_pfn + sp);
+
 	return ret;
 }
 
-- 
1.8.0.3

