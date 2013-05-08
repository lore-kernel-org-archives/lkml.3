Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3EHXkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:40:01 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50591 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3EHXjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:39:15 -0400
X-AuditID: 9c930179-b7bb6ae000001131-d2-518ae2188759
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>
Subject: [PATCH v4 2/6] mm: make shrink_page_list with pages work from multiple zones
Date: Thu,  9 May 2013 08:38:58 +0900
Message-Id: <1368056342-30836-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368056342-30836-1-git-send-email-minchan@kernel.org>
References: <1368056342-30836-1-git-send-email-minchan@kernel.org>
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
index 6b7cba3..a1fb526 100644
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

