Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbaCNGh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 02:37:57 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56012 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbaCNGha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 02:37:30 -0400
X-AuditID: 9c93017e-b7cf9ae000004b4b-e1-5322a3a61439
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jason Evans <je@fb.com>, Minchan Kim <minchan@kernel.org>
Subject: [RFC 5/6] mm: reclaim lazyfree pages in swapless system
Date: Fri, 14 Mar 2014 15:37:49 +0900
Message-Id: <1394779070-8545-6-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394779070-8545-1-git-send-email-minchan@kernel.org>
References: <1394779070-8545-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are lazyfree pages in system, shrink inactive anonymous
LRU to discard lazyfree pages regardless of existing avaialable
swap.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 98a1c3ffcaab..ad73e053c581 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1889,8 +1889,13 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	if (!global_reclaim(sc))
 		force_scan = true;
 
-	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (get_nr_swap_pages() <= 0)) {
+	/*
+	 * If we have no swap space and lazyfree pages,
+	 * do not bother scanning anon pages.
+	 */
+	if (!sc->may_swap ||
+		(get_nr_swap_pages() <= 0 &&
+			zone_page_state(zone, NR_LAZYFREE_PAGES) <= 0)) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
-- 
1.9.0

