Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbaFEA2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:28:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaFDXWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 103/228] revert "mm: vmscan: do not swap anon pages just because free+file is low"
Date: Wed,  4 Jun 2014 16:22:12 -0700
Message-Id: <20140604232351.347803140@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1916,6 +1916,24 @@ static void get_scan_count(struct lruvec
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


