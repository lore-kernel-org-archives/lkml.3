Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbaGaLus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbaGaLuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:50:46 -0400
From: "Jerome Marchand" <jmarchan@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 2/2] memcg, vmscan: Fix forced scan of anonymous pages
Date: Thu, 31 Jul 2014 13:49:45 +0200
Message-Id: <1406807385-5168-3-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1406807385-5168-1-git-send-email-jmarchan@redhat.com>
References: <1406807385-5168-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When memory cgoups are enabled, the code that decides to force to scan
anonymous pages in get_scan_count() compares global values (free,
high_watermark) to a value that is restricted to a memory cgroup
(file). It make the code over-eager to force anon scan.

For instance, it will force anon scan when scanning a memcg that is
mainly populated by anonymous page, even when there is plenty of file
pages to get rid of in others memcgs, even when swappiness == 0. It
breaks user's expectation about swappiness and hurts performance. 

This patch make sure that forced anon scan only happens when there not
enough file pages for the all zone, not just in one random memcg.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 mm/vmscan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 079918d..3ad2069 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1950,8 +1950,11 @@ static void get_scan_count(struct lruvec *lruvec, int swappiness,
 	 */
 	if (global_reclaim(sc)) {
 		unsigned long free = zone_page_state(zone, NR_FREE_PAGES);
+		unsigned long zonefile =
+			zone_page_state(zone, NR_LRU_BASE + LRU_ACTIVE_FILE) +
+			zone_page_state(zone, NR_LRU_BASE + LRU_INACTIVE_FILE);
 
-		if (unlikely(file + free <= high_wmark_pages(zone))) {
+		if (unlikely(zonefile + free <= high_wmark_pages(zone))) {
 			scan_balance = SCAN_ANON;
 			goto out;
 		}
-- 
1.9.3

