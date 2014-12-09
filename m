Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaLITfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:35:01 -0500
Received: from relay2.sgi.com ([192.48.180.65]:45565 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751378AbaLITfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:35:00 -0500
From: James Custer <jcuster@sgi.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com
Cc: rja@sgi.com, dfults@sgi.com, James Custer <jcuster@sgi.com>
Subject: [PATCH] mm: fix invalid use of pfn_valid_within in test_pages_in_a_zone
Date: Tue,  9 Dec 2014 13:34:56 -0600
Message-Id: <1418153696-167580-1-git-send-email-jcuster@sgi.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Offlining memory by 'echo 0 > /sys/devices/system/memory/memory#/online'
or reading valid_zones 'cat /sys/devices/system/memory/memory#/valid_zones'
causes BUG: unable to handle kernel paging request due to invalid use of
pfn_valid_within. This is due to a bug in test_pages_in_a_zone.

In order to use pfn_valid_within within a MAX_ORDER_NR_PAGES block of pages,
a valid pfn within the block must first be found. There only needs to be
one valid pfn found in test_pages_in_a_zone in the first place. So the
fix is to replace pfn_valid_within with pfn_valid such that the first
valid pfn within the pageblock is found (if it exists). This works
independently of CONFIG_HOLES_IN_ZONE.

Signed-off-by: James Custer <jcuster@sgi.com>
---
 mm/memory_hotplug.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1bf4807..304c187 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1331,7 +1331,7 @@ int is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
 }
 
 /*
- * Confirm all pages in a range [start, end) is belongs to the same zone.
+ * Confirm all pages in a range [start, end) belong to the same zone.
  */
 int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
 {
@@ -1342,10 +1342,11 @@ int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
 	for (pfn = start_pfn;
 	     pfn < end_pfn;
 	     pfn += MAX_ORDER_NR_PAGES) {
-		i = 0;
-		/* This is just a CONFIG_HOLES_IN_ZONE check.*/
-		while ((i < MAX_ORDER_NR_PAGES) && !pfn_valid_within(pfn + i))
-			i++;
+		/* Find the first valid pfn in this pageblock */
+		for (i = 0; i < MAX_ORDER_NR_PAGES; i++) {
+			if (pfn_valid(pfn + i))
+				break;
+		}
 		if (i == MAX_ORDER_NR_PAGES)
 			continue;
 		page = pfn_to_page(pfn + i);
-- 
1.8.2.1

