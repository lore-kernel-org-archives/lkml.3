Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbaDVPHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:07:13 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59462 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbaDVPHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:07:10 -0400
Date: Tue, 22 Apr 2014 11:06:56 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Suleiman Souhlal <suleiman@google.com>, stable@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: commit 0bf1457f0cfca7b  " mm: vmscan: do not swap anon pages
 just because free+file is low" causes heavy performance regression on paging
Message-ID: <20140422150656.GA29866@cmpxchg.org>
References: <53564AA9.3060905@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53564AA9.3060905@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

On Tue, Apr 22, 2014 at 12:55:37PM +0200, Christian Borntraeger wrote:
> While preparing/testing some KVM on s390 patches for the next merge window (target is kvm/next which is based on 3.15-rc1) I faced a very severe performance hickup on guest paging (all anonymous memory).
> 
> All memory bound guests are in "D" state now and the system is barely unusable.
> 
> Reverting commit 0bf1457f0cfca7bc026a82323ad34bcf58ad035d
> "mm: vmscan: do not swap anon pages just because free+file is low" makes the problem go away.
> 
> According to /proc/vmstat the system is now in direct reclaim almost all the time for every page fault (more than 10x more direct reclaims than kswap reclaims)
> With the patch being reverted everything is fine again.

Ouch.  Yes, I think we have to revert this for now.

How about this?

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] Revert "mm: vmscan: do not swap anon pages just because
 free+file is low"

This reverts commit 0bf1457f0cfc ("mm: vmscan: do not swap anon pages
just because free+file is low") because it introduced a regression in
mostly-anonymous workloads, where reclaim would become ineffective and
trap every allocating task in direct reclaim.

The problem is that there is a runaway feedback loop in the scan
balance between file and anon, where the balance tips heavily towards
a tiny thrashing file LRU and anonymous pages are no longer being
looked at.  The commit in question removed the safe guard that would
detect such situations and respond with forced anonymous reclaim.

This commit was part of a series to fix premature swapping in loads
with relatively little cache, and while it made a small difference,
the cure is obviously worse than the disease.  Revert it.

Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@kernel.org>		[3.12+]
---
 mm/vmscan.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9b6497eda806..169acb8e31c9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1916,6 +1916,24 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 		get_lru_size(lruvec, LRU_INACTIVE_FILE);
 
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
1.9.2

