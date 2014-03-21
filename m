Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaCUVSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:18:25 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43263 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaCUVSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:18:09 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 5/5] vmscan: Age anonymous memory even when swap is off.
Date: Fri, 21 Mar 2014 14:17:35 -0700
Message-Id: <1395436655-21670-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395436655-21670-1-git-send-email-john.stultz@linaro.org>
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we don't shrink/scan the anonymous lrus when swap is off.
This is problematic for volatile range purging on swapless systems/

This patch naievely changes the vmscan code to continue scanning
and shrinking the lrus even when there is no swap.

It obviously has performance issues.

Thoughts on how best to implement this would be appreciated.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Robert Love <rlove@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Hommey <mh@glandium.org>
Cc: Taras Glek <tglek@mozilla.com>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org <linux-mm@kvack.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 mm/vmscan.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 34f159a..07b0a8c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -155,9 +155,8 @@ static unsigned long zone_reclaimable_pages(struct zone *zone)
 	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
 	     zone_page_state(zone, NR_INACTIVE_FILE);
 
-	if (get_nr_swap_pages() > 0)
-		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
-		      zone_page_state(zone, NR_INACTIVE_ANON);
+	nr += zone_page_state(zone, NR_ACTIVE_ANON) +
+	      zone_page_state(zone, NR_INACTIVE_ANON);
 
 	return nr;
 }
@@ -1764,13 +1763,6 @@ static int inactive_anon_is_low_global(struct zone *zone)
  */
 static int inactive_anon_is_low(struct lruvec *lruvec)
 {
-	/*
-	 * If we don't have swap space, anonymous page deactivation
-	 * is pointless.
-	 */
-	if (!total_swap_pages)
-		return 0;
-
 	if (!mem_cgroup_disabled())
 		return mem_cgroup_inactive_anon_is_low(lruvec);
 
@@ -1880,12 +1872,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	if (!global_reclaim(sc))
 		force_scan = true;
 
-	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (get_nr_swap_pages() <= 0)) {
-		scan_balance = SCAN_FILE;
-		goto out;
-	}
-
 	/*
 	 * Global reclaim will swap to prevent OOM even with no
 	 * swappiness, but memcg users want to use this knob to
@@ -2048,7 +2034,6 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			if (nr[lru]) {
 				nr_to_scan = min(nr[lru], SWAP_CLUSTER_MAX);
 				nr[lru] -= nr_to_scan;
-
 				nr_reclaimed += shrink_list(lru, nr_to_scan,
 							    lruvec, sc);
 			}
@@ -2181,8 +2166,8 @@ static inline bool should_continue_reclaim(struct zone *zone,
 	 */
 	pages_for_compaction = (2UL << sc->order);
 	inactive_lru_pages = zone_page_state(zone, NR_INACTIVE_FILE);
-	if (get_nr_swap_pages() > 0)
-		inactive_lru_pages += zone_page_state(zone, NR_INACTIVE_ANON);
+	inactive_lru_pages += zone_page_state(zone, NR_INACTIVE_ANON);
+
 	if (sc->nr_reclaimed < pages_for_compaction &&
 			inactive_lru_pages > pages_for_compaction)
 		return true;
@@ -2726,9 +2711,6 @@ static void age_active_anon(struct zone *zone, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg;
 
-	if (!total_swap_pages)
-		return;
-
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
 		struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
-- 
1.8.3.2

