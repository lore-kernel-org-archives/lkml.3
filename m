Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3AQWzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:55:13 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43633 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab3AQWyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:54:24 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <jmesmon@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 7/9] mm: add helper ensure_zone_is_initialized()
Date: Thu, 17 Jan 2013 14:52:59 -0800
Message-Id: <1358463181-17956-8-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011722-5806-0000-0000-00001E66B3FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <jmesmon@gmail.com>

ensure_zone_is_initialized() checks if a zone is in a empty & not
initialized state (typically occuring after it is created in memory
hotplugging), and, if so, calls init_currently_empty_zone() to
initialize the zone.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/memory_hotplug.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c62bcca..bede456 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -253,6 +253,17 @@ static void fix_zone_id(struct zone *zone, unsigned long start_pfn,
 		set_page_links(pfn_to_page(pfn), zid, nid, pfn);
 }
 
+/* Can fail with -ENOMEM from allocating a wait table with vmalloc() or
+ * alloc_bootmem_node_nopanic() */
+static int __ref ensure_zone_is_initialized(struct zone *zone,
+			unsigned long start_pfn, unsigned long num_pages)
+{
+	if (!zone_is_initialized(zone))
+		return init_currently_empty_zone(zone, start_pfn, num_pages,
+						 MEMMAP_HOTPLUG);
+	return 0;
+}
+
 static int __meminit move_pfn_range_left(struct zone *z1, struct zone *z2,
 		unsigned long start_pfn, unsigned long end_pfn)
 {
-- 
1.8.0.3

