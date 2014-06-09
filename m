Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaFIJFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:05:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58449 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 068/146] revert "mm: vmscan: do not swap anon pages just because free+file is low"
Date: Mon,  9 Jun 2014 10:50:03 +0200
Message-Id: <245fd39e32a9e849fab4120e09950bb073b8982e.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 623762517e2370be3b3f95f4fe08d6c063a49b06 upstream.

This reverts commit 0bf1457f0cfc ("mm: vmscan: do not swap anon pages
just because free+file is low") because it introduced a regression in
mostly-anonymous workloads, where reclaim would become ineffective and
trap every allocating task in direct reclaim.

The problem is that there is a runaway feedback loop in the scan balance
between file and anon, where the balance tips heavily towards a tiny
thrashing file LRU and anonymous pages are no longer being looked at.
The commit in question removed the safe guard that would detect such
situations and respond with forced anonymous reclaim.

This commit was part of a series to fix premature swapping in loads with
relatively little cache, and while it made a small difference, the cure
is obviously worse than the disease.  Revert it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/vmscan.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 05e6095159dc..09c730718e23 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1898,6 +1898,24 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	}
 
 	/*
+	 * Prevent the reclaimer from falling into the cache trap: as
+	 * cache pages start out inactive, every cache fault will tip
+	 * the scan balance towards the file LRU.  And as the file LRU
+	 * shrinks, so does the window for rotation from references.
+	 * This means we have a runaway feedback loop where a tiny
+	 * thrashing file LRU becomes infinitely more attractive than
+	 * anon pages.  Try to detect this based on file LRU size.
+	 */
+	if (global_reclaim(sc)) {
+		unsigned long free = zone_page_state(zone, NR_FREE_PAGES);
+
+		if (unlikely(file + free <= high_wmark_pages(zone))) {
+			scan_balance = SCAN_ANON;
+			goto out;
+		}
+	}
+
+	/*
 	 * There is enough inactive page cache, do not reclaim
 	 * anything from the anonymous working set right now.
 	 */
-- 
1.9.3

