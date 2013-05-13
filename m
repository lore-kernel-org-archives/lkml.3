Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3EMINc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:13:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab3EMIMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:12:53 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Michal Hocko <mhocko@suse.cz>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 8/9] mm: vmscan: Check if kswapd should writepage once per pgdat scan
Date: Mon, 13 May 2013 09:12:39 +0100
Message-Id: <1368432760-21573-9-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368432760-21573-1-git-send-email-mgorman@suse.de>
References: <1368432760-21573-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kswapd checks if it should start writepage as it shrinks
each zone without taking into consideration if the zone is balanced or
not. This is not wrong as such but it does not make much sense either.
This patch checks once per pgdat scan if kswapd should be writing pages.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 911c9cd..e65fe46 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2849,6 +2849,13 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
 		}
 
 		/*
+		 * If we're getting trouble reclaiming, start doing writepage
+		 * even in laptop mode.
+		 */
+		if (sc.priority < DEF_PRIORITY - 2)
+			sc.may_writepage = 1;
+
+		/*
 		 * Now scan the zone in the dma->highmem direction, stopping
 		 * at the last zone which needs scanning.
 		 *
@@ -2919,13 +2926,6 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
 					raise_priority = false;
 			}
 
-			/*
-			 * If we're getting trouble reclaiming, start doing
-			 * writepage even in laptop mode.
-			 */
-			if (sc.priority < DEF_PRIORITY - 2)
-				sc.may_writepage = 1;
-
 			if (zone->all_unreclaimable) {
 				if (end_zone && end_zone == i)
 					end_zone--;
-- 
1.8.1.4

