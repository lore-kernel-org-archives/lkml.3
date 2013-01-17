Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3AQWzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:55:11 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43634 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab3AQWyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:54:24 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 8/9] mm/memory_hotplug: use ensure_zone_is_initialized()
Date: Thu, 17 Jan 2013 14:53:00 -0800
Message-Id: <1358463181-17956-9-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011722-5806-0000-0000-00001E66B407
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove open coding of ensure_zone_is_initialzied().

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/memory_hotplug.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bede456..016944f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -271,12 +271,9 @@ static int __meminit move_pfn_range_left(struct zone *z1, struct zone *z2,
 	unsigned long flags;
 	unsigned long z1_start_pfn;
 
-	if (!z1->wait_table) {
-		ret = init_currently_empty_zone(z1, start_pfn,
-			end_pfn - start_pfn, MEMMAP_HOTPLUG);
-		if (ret)
-			return ret;
-	}
+	ret = ensure_zone_is_initialized(z1, start_pfn, end_pfn - start_pfn);
+	if (ret)
+		return ret;
 
 	pgdat_resize_lock(z1->zone_pgdat, &flags);
 
@@ -316,12 +313,9 @@ static int __meminit move_pfn_range_right(struct zone *z1, struct zone *z2,
 	unsigned long flags;
 	unsigned long z2_end_pfn;
 
-	if (!z2->wait_table) {
-		ret = init_currently_empty_zone(z2, start_pfn,
-			end_pfn - start_pfn, MEMMAP_HOTPLUG);
-		if (ret)
-			return ret;
-	}
+	ret = ensure_zone_is_initialized(z2, start_pfn, end_pfn - start_pfn);
+	if (ret)
+		return ret;
 
 	pgdat_resize_lock(z1->zone_pgdat, &flags);
 
@@ -374,16 +368,13 @@ static int __meminit __add_zone(struct zone *zone, unsigned long phys_start_pfn)
 	int nid = pgdat->node_id;
 	int zone_type;
 	unsigned long flags;
+	int ret;
 
 	zone_type = zone - pgdat->node_zones;
-	if (!zone->wait_table) {
-		int ret;
+	ret = ensure_zone_is_initialized(zone, phys_start_pfn, nr_pages);
+	if (ret)
+		return ret;
 
-		ret = init_currently_empty_zone(zone, phys_start_pfn,
-						nr_pages, MEMMAP_HOTPLUG);
-		if (ret)
-			return ret;
-	}
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	grow_zone_span(zone, phys_start_pfn, phys_start_pfn + nr_pages);
 	grow_pgdat_span(zone->zone_pgdat, phys_start_pfn,
-- 
1.8.0.3

