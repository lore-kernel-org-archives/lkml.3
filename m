Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814Ab3DLBRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:17:33 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49742 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab3DLBOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:40 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 15/25] page_alloc: use dnuma to transplant newly freed pages in free_hot_cold_page()
Date: Thu, 11 Apr 2013 18:13:47 -0700
Message-Id: <1365729237-29711-16-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-9360-0000-0000-000011B4F8FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_hot_cold_page() is used for order == 0 pages, and is where the
page's zone is decided.

In the normal case, these pages are freed to the per-cpu lists. When a
page needs transplanting (ie: the actual node it belongs to has changed,
and it needs to be moved to another zone), the pcp lists are skipped &
the page is freed via free_one_page().

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f8ae178..98ac7c6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1357,6 +1357,7 @@ void mark_free_pages(struct zone *zone)
  */
 void free_hot_cold_page(struct page *page, int cold)
 {
+	int dest_nid;
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
@@ -1370,6 +1371,15 @@ void free_hot_cold_page(struct page *page, int cold)
 	local_irq_save(flags);
 	__count_vm_event(PGFREE);
 
+	dest_nid = dnuma_page_needs_move(page);
+	if (dest_nid != NUMA_NO_NODE) {
+		struct zone *dest_zone = nid_zone(dest_nid, page_zonenum(page));
+		dnuma_prior_free_to_new_zone(page, 0, dest_zone, dest_nid);
+		free_one_page(dest_zone, page, 0, migratetype);
+		dnuma_post_free_to_new_zone(0);
+		goto out;
+	}
+
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Free ISOLATE pages back to the allocator because they are being
-- 
1.8.2.1

