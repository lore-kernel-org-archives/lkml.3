Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3EIHW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 03:22:56 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58264 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3EIHVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 03:21:34 -0400
X-AuditID: 9c93016f-b7ba0ae000004cc2-71-518b4e7b8af0
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Minkyung Kim <minkyung88@lge.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v5 3/7] mm: make shrink_page_list with pages work from multiple zones
Date: Thu,  9 May 2013 16:21:25 +0900
Message-Id: <1368084089-24576-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368084089-24576-1-git-send-email-minchan@kernel.org>
References: <1368084089-24576-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shrink_page_list expects all pages come from a same zone
but it's too limited to use.

This patch removes the dependency so next patch can use
shrink_page_list with pages from multiple zones.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 93f3b79..d69bfce 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -706,7 +706,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 			goto keep;
 
 		VM_BUG_ON(PageActive(page));
-		VM_BUG_ON(page_zone(page) != zone);
+		if (zone)
+			VM_BUG_ON(page_zone(page) != zone);
 
 		sc->nr_scanned++;
 
@@ -952,7 +953,7 @@ keep:
 	 * back off and wait for congestion to clear because further reclaim
 	 * will encounter the same problem
 	 */
-	if (nr_dirty && nr_dirty == nr_congested && global_reclaim(sc))
+	if (nr_dirty && nr_dirty == nr_congested && global_reclaim(sc) && zone)
 		zone_set_flag(zone, ZONE_CONGESTED);
 
 	free_hot_cold_page_list(&free_pages, 1);
-- 
1.8.2.1

