Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab3EMXOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 19:14:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47646 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518Ab3EMXNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 19:13:39 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v3 4/4] memory_hotplug: use pgdat_resize_lock() in __offline_pages()
Date: Mon, 13 May 2013 16:13:07 -0700
Message-Id: <1368486787-9511-5-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1368486787-9511-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1368486787-9511-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051323-5806-0000-0000-0000211E61BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmzone.h documents node_size_lock (which pgdat_resize_lock() locks) as
follows:

        * Must be held any time you expect node_start_pfn, node_present_pages
        * or node_spanned_pages stay constant.  [...]

So actually hold it when we update node_present_pages in __offline_pages().

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

