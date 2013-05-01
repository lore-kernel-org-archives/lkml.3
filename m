Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380Ab3EAXcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:32:43 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60174 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab3EAXcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:32:22 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 4/4] memory_hotplug: use pgdat_resize_lock() in __offline_pages()
Date: Wed,  1 May 2013 16:32:01 -0700
Message-Id: <1367451121-22725-5-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367451121-22725-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367451121-22725-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050123-7282-0000-0000-000016B5D518
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmzone.h documents node_size_lock (which pgdat_resize_lock() locks) as
guarding against changes to node_present_pages, so actually lock it when
we update node_present_pages to keep that promise.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/memory_hotplug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0bdca10..b59a695 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1582,7 +1582,11 @@ repeat:
 	/* removal success */
 	zone->managed_pages -= offlined_pages;
 	zone->present_pages -= offlined_pages;
+
+	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	zone->zone_pgdat->node_present_pages -= offlined_pages;
+	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+
 	totalram_pages -= offlined_pages;
 
 	init_per_zone_wmark_min();
-- 
1.8.2.2

