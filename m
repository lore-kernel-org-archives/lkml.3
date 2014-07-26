Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaGZTod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:44:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaGZTNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 86/87] Dont trigger congestion wait on dirty-but-not-writeout pages
Date: Sat, 26 Jul 2014 12:03:00 -0700
Message-Id: <20140726190217.401060535@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

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

Reported-by: Felipe Contreras <felipe.contreras@gmail.com>
Pinpointed-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[mhocko@suse.cz: backport to 3.12 stable tree]
Fixes: e2be15f6c3ee ('mm: vmscan: stall page reclaim and writeback pages based on dirty/writepage pages encountered')
Reported-by: Felipe Contreras <felipe.contreras@gmail.com>
Pinpointed-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1540,19 +1540,18 @@ shrink_inactive_list(unsigned long nr_to
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
 


