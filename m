Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965174Ab3DJS17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:27:59 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58321 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936802Ab3DJSYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:24:18 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v3 04/11] mm/page_alloc: protect pcp->batch accesses with ACCESS_ONCE
Date: Wed, 10 Apr 2013 11:23:32 -0700
Message-Id: <1365618219-17154-5-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365618219-17154-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365618219-17154-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041018-9360-0000-0000-000011AF1256
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcp->batch could change at any point, avoid relying on it being a stable value.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f2929df..9dd0dc0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1181,10 +1181,12 @@ void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 {
 	unsigned long flags;
 	int to_drain;
+	unsigned long batch;
 
 	local_irq_save(flags);
-	if (pcp->count >= pcp->batch)
-		to_drain = pcp->batch;
+	batch = ACCESS_ONCE(pcp->batch);
+	if (pcp->count >= batch)
+		to_drain = batch;
 	else
 		to_drain = pcp->count;
 	if (to_drain > 0) {
@@ -1352,8 +1354,9 @@ void free_hot_cold_page(struct page *page, int cold)
 		list_add(&page->lru, &pcp->lists[migratetype]);
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
-		free_pcppages_bulk(zone, pcp->batch, pcp);
-		pcp->count -= pcp->batch;
+		unsigned long batch = ACCESS_ONCE(pcp->batch);
+		free_pcppages_bulk(zone, batch, pcp);
+		pcp->count -= batch;
 	}
 
 out:
-- 
1.8.2.1

