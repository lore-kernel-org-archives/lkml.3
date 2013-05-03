Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205Ab3ECAGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:06:43 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49635 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838Ab3ECABt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:49 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 09/31] page_alloc: in move_freepages(), skip pages instead of VM_BUG on node differences.
Date: Thu,  2 May 2013 17:00:41 -0700
Message-Id: <1367539263-19999-10-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-2876-0000-0000-0000083EBE6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With dynamic numa, pages are going to be gradully moved from one node to
another, causing the page ranges that move_freepages() examines to
contain pages that actually belong to another node.

When dynamic numa is enabled, we skip these pages instead of VM_BUGing
out on them.

This additionally moves the VM_BUG_ON() (which detects a change in node)
so that it follows the pfn_valid_within() check.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 739b405..657f773 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -958,6 +958,7 @@ int move_freepages(struct zone *zone,
 	struct page *page;
 	unsigned long order;
 	int pages_moved = 0;
+	int zone_nid = zone_to_nid(zone);
 
 #ifndef CONFIG_HOLES_IN_ZONE
 	/*
@@ -971,14 +972,24 @@ int move_freepages(struct zone *zone,
 #endif
 
 	for (page = start_page; page <= end_page;) {
-		/* Make sure we are not inadvertently changing nodes */
-		VM_BUG_ON(page_to_nid(page) != zone_to_nid(zone));
-
 		if (!pfn_valid_within(page_to_pfn(page))) {
 			page++;
 			continue;
 		}
 
+		if (page_to_nid(page) != zone_nid) {
+#ifndef CONFIG_DYNAMIC_NUMA
+			/*
+			 * In the normal case (without Dynamic NUMA), all pages
+			 * in a pageblock should belong to the same zone (and
+			 * as a result all have the same nid).
+			 */
+			VM_BUG_ON(page_to_nid(page) != zone_nid);
+#endif
+			page++;
+			continue;
+		}
+
 		if (!PageBuddy(page)) {
 			page++;
 			continue;
-- 
1.8.2.2

