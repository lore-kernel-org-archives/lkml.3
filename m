Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3AQWyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:54:25 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:41390 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3AQWyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:54:22 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 6/9] mm/page_alloc: add informative debugging message in page_outside_zone_boundaries()
Date: Thu, 17 Jan 2013 14:52:58 -0800
Message-Id: <1358463181-17956-7-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011722-4834-0000-0000-000002B5BF13
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

