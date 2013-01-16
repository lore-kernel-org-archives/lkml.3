Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab3APA1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:27:40 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59938 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758258Ab3APAZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:25:57 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 14/17] mm/memory_hotplug: factor out zone+pgdat growth.
Date: Tue, 15 Jan 2013 16:24:51 -0800
Message-Id: <1358295894-24167-15-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011600-7182-0000-0000-000004762F1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new function grow_pgdat_and_zone() which handles locking +
growth of a zone & the pgdat which it is associated with.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/memory_hotplug.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0a74b86a..c6149a3 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -361,6 +361,16 @@ static void grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
 					pgdat->node_start_pfn;
 }
 
+static void grow_pgdat_and_zone(struct zone *zone, unsigned long start_pfn,
+		unsigned long end_pfn)
+{
+	unsigned long flags;
+	pgdat_resize_lock(zone->zone_pgdat, &flags);
+	grow_zone_span(zone, start_pfn, end_pfn);
+	grow_pgdat_span(zone->zone_pgdat, start_pfn, end_pfn);
+	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+}
+
 static int __meminit __add_zone(struct zone *zone, unsigned long phys_start_pfn)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
@@ -375,11 +385,7 @@ static int __meminit __add_zone(struct zone *zone, unsigned long phys_start_pfn)
 	if (ret)
 		return ret;
 
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
-	grow_zone_span(zone, phys_start_pfn, phys_start_pfn + nr_pages);
-	grow_pgdat_span(zone->zone_pgdat, phys_start_pfn,
-			phys_start_pfn + nr_pages);
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+	grow_pgdat_and_zone(zone, phys_start_pfn, phys_start_pfn + nr_pages);
 	memmap_init_zone(nr_pages, nid, zone_type,
 			 phys_start_pfn, MEMMAP_HOTPLUG);
 	return 0;
-- 
1.8.0.3

