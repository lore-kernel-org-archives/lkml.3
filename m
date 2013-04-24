Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3DXBmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 21:42:14 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54798 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab3DXBlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 21:41:37 -0400
X-AuditID: 9c93016f-b7b70ae0000038d5-66-5177384ed600
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v2 2/6] mm: make shrink_page_list with pages work from multiple zones
Date: Wed, 24 Apr 2013 10:41:00 +0900
Message-Id: <1366767664-17541-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1366767664-17541-1-git-send-email-minchan@kernel.org>
References: <1366767664-17541-1-git-send-email-minchan@kernel.org>
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
index 6934f5b..82f4d6c 100644
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
1.8.2

