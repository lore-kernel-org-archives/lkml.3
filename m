Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761865Ab3ECADG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:03:06 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40218 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759494Ab3ECADD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:03:03 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 20/31] page_alloc: use dnuma to transplant newly freed pages in __free_pages_ok()
Date: Thu,  2 May 2013 17:00:52 -0700
Message-Id: <1367539263-19999-21-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-7606-0000-0000-00000B0CBE70
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
index ea4fda8..f33f1bf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -60,6 +60,7 @@
 #include <linux/page-debug-flags.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
+#include <linux/dnuma.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -733,6 +734,13 @@ static void __free_pages_ok(struct page *page, unsigned int order)
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
@@ -741,7 +749,11 @@ static void __free_pages_ok(struct page *page, unsigned int order)
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
1.8.2.2

