Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149Ab3DLBSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:18:14 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47051 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab3DLBOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:32 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 09/25] page_alloc: when dynamic numa is enabled, don't check that all pages in a block belong to the same zone
Date: Thu, 11 Apr 2013 18:13:41 -0700
Message-Id: <1365729237-29711-10-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-5518-0000-0000-00000D761D12
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
index 75192eb..95e4a23 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -959,13 +959,16 @@ int move_freepages(struct zone *zone,
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
1.8.2.1

