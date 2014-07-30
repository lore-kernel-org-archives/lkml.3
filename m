Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaG3MPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:15:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36612 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbaG3MPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 01/94] Don't trigger congestion wait on dirty-but-not-writeout pages
Date: Wed, 30 Jul 2014 14:13:50 +0200
Message-Id: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b738d764652dc5aab1c8939f637112981fce9e0e upstream.

shrink_inactive_list() used to wait 0.1s to avoid congestion when all
the pages that were isolated from the inactive list were dirty but not
under active writeback.  That makes no real sense, and apparently causes
major interactivity issues under some loads since 3.11.

The ostensible reason for it was to wait for kswapd to start writing
pages, but that seems questionable as well, since the congestion wait
code seems to trigger for kswapd itself as well.  Also, the logic behind
delaying anything when we haven't actually started writeback is not
clear - it only delays actually starting that writeback.

We'll still trigger the congestion waiting if

 (a) the process is kswapd, and we hit pages flagged for immediate
     reclaim

 (b) the process is not kswapd, and the zone backing dev writeback is
     actually congested.

This probably needs to be revisited, but as it is this fixes a reported
regression.

[mhocko@suse.cz: backport to 3.12 stable tree]
Fixes: e2be15f6c3ee ('mm: vmscan: stall page reclaim and writeback pages based on dirty/writepage pages encountered')
Reported-by: Felipe Contreras <felipe.contreras@gmail.com>
Pinpointed-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/vmscan.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1d891f49587b..5ad29b2925a0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1522,19 +1522,18 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 		 * If dirty pages are scanned that are not queued for IO, it
 		 * implies that flushers are not keeping up. In this case, flag
 		 * the zone ZONE_TAIL_LRU_DIRTY and kswapd will start writing
-		 * pages from reclaim context. It will forcibly stall in the
-		 * next check.
+		 * pages from reclaim context.
 		 */
 		if (nr_unqueued_dirty == nr_taken)
 			zone_set_flag(zone, ZONE_TAIL_LRU_DIRTY);
 
 		/*
-		 * In addition, if kswapd scans pages marked marked for
-		 * immediate reclaim and under writeback (nr_immediate), it
-		 * implies that pages are cycling through the LRU faster than
+		 * If kswapd scans pages marked marked for immediate
+		 * reclaim and under writeback (nr_immediate), it implies
+		 * that pages are cycling through the LRU faster than
 		 * they are written so also forcibly stall.
 		 */
-		if (nr_unqueued_dirty == nr_taken || nr_immediate)
+		if (nr_immediate)
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 
-- 
2.0.1

