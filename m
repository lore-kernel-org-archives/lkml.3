Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab3DLBOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:14:40 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48004 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab3DLBOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:36 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 14/25] page_alloc: use dnuma to transplant newly freed pages in __free_pages_ok()
Date: Thu, 11 Apr 2013 18:13:46 -0700
Message-Id: <1365729237-29711-15-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-7182-0000-0000-000006338E56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__free_pages_ok() handles higher order (order != 0) pages. Transplant
hook is added here as this is where the struct zone to free to is
decided.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4628443..f8ae178 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -59,6 +59,7 @@
 #include <linux/migrate.h>
 #include <linux/page-debug-flags.h>
 #include <linux/sched/rt.h>
+#include <linux/dnuma.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -732,6 +733,13 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 {
 	unsigned long flags;
 	int migratetype;
+	int dest_nid = dnuma_page_needs_move(page);
+	struct zone *zone;
+
+	if (dest_nid != NUMA_NO_NODE)
+		zone = nid_zone(dest_nid, page_zonenum(page));
+	else
+		zone = page_zone(page);
 
 	if (!free_pages_prepare(page, order))
 		return;
@@ -740,7 +748,11 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	__count_vm_events(PGFREE, 1 << order);
 	migratetype = get_pageblock_migratetype(page);
 	set_freepage_migratetype(page, migratetype);
-	free_one_page(page_zone(page), page, order, migratetype);
+	if (dest_nid != NUMA_NO_NODE)
+		dnuma_prior_free_to_new_zone(page, order, zone, dest_nid);
+	free_one_page(zone, page, order, migratetype);
+	if (dest_nid != NUMA_NO_NODE)
+		dnuma_post_free_to_new_zone(order);
 	local_irq_restore(flags);
 }
 
-- 
1.8.2.1

