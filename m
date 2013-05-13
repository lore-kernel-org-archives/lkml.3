Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3EMTO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:14:26 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:32846 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab3EMTOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:14:23 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH RESEND v3 04/11] mm/page_alloc: protect pcp->batch accesses with ACCESS_ONCE
Date: Mon, 13 May 2013 12:08:16 -0700
Message-Id: <1368472103-3427-5-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051319-2876-0000-0000-000008909CB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcp->batch could change at any point, avoid relying on it being a stable value.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7e45b91..71d843d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1182,10 +1182,12 @@ void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
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
@@ -1353,8 +1355,9 @@ void free_hot_cold_page(struct page *page, int cold)
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
1.8.2.2

