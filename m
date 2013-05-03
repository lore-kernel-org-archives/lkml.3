Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019Ab3ECALa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:11:30 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:54713 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3ECAL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:11:29 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 10/31] page_alloc: when dynamic numa is enabled, don't check that all pages in a block belong to the same zone
Date: Thu,  2 May 2013 17:00:42 -0700
Message-Id: <1367539263-19999-11-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-7282-0000-0000-000016C5E574
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dynamic numa is enabled, the last or first page in a pageblock may
have been transplanted to a new zone (or may not yet be transplanted to
a new zone).

Disable a BUG_ON() which checks that the start_page and end_page are in
the same zone, if they are not in the proper zone they will simply be
skipped.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 657f773..9de55a2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -960,13 +960,16 @@ int move_freepages(struct zone *zone,
 	int pages_moved = 0;
 	int zone_nid = zone_to_nid(zone);
 
-#ifndef CONFIG_HOLES_IN_ZONE
+#if !defined(CONFIG_HOLES_IN_ZONE) && !defined(CONFIG_DYNAMIC_NUMA)
 	/*
-	 * page_zone is not safe to call in this context when
-	 * CONFIG_HOLES_IN_ZONE is set. This bug check is probably redundant
-	 * anyway as we check zone boundaries in move_freepages_block().
-	 * Remove at a later date when no bug reports exist related to
-	 * grouping pages by mobility
+	 * With CONFIG_HOLES_IN_ZONE set, this check is unsafe as start_page or
+	 * end_page may not be "valid".
+	 * With CONFIG_DYNAMIC_NUMA set, this condition is a valid occurence &
+	 * not a bug.
+	 *
+	 * This bug check is probably redundant anyway as we check zone
+	 * boundaries in move_freepages_block().  Remove at a later date when
+	 * no bug reports exist related to grouping pages by mobility
 	 */
 	BUG_ON(page_zone(start_page) != page_zone(end_page));
 #endif
-- 
1.8.2.2

