Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab3CYGWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:22:44 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49107 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab3CYGWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:22:03 -0400
X-AuditID: 9c93016f-b7cecae000004cf8-2e-514fed05e6f0
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Sangseok Lee <sangseok.lee@lge.com>, Minchan Kim <minchan@kernel.org>
Subject: [RFC 2/4] mm: make shrink_page_list with pages from multiple zones
Date: Mon, 25 Mar 2013 15:21:32 +0900
Message-Id: <1364192494-22185-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1364192494-22185-1-git-send-email-minchan@kernel.org>
References: <1364192494-22185-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now shrink_page_list expects all pages come from a same zone
but it's too limited to use it.

This patch removes the dependency so next patch can use
shrink_page_list with pages from multiple zones.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d3dc95f..9434ba2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -705,7 +705,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 			goto keep;
 
 		VM_BUG_ON(PageActive(page));
-		VM_BUG_ON(page_zone(page) != zone);
+		if (zone)
+			VM_BUG_ON(page_zone(page) != zone);
 
 		sc->nr_scanned++;
 
@@ -951,7 +952,7 @@ keep:
 	 * back off and wait for congestion to clear because further reclaim
 	 * will encounter the same problem
 	 */
-	if (nr_dirty && nr_dirty == nr_congested && global_reclaim(sc))
+	if (nr_dirty && nr_dirty == nr_congested && global_reclaim(sc) && zone)
 		zone_set_flag(zone, ZONE_CONGESTED);
 
 	free_hot_cold_page_list(&free_pages, 1);
-- 
1.8.2

