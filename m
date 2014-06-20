Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934941AbaFTQeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:34:01 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:38227 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228AbaFTQeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:34:00 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 1/4] mm: vmscan: remove remains of kswapd-managed zone->all_unreclaimable
Date: Fri, 20 Jun 2014 12:33:47 -0400
Message-Id: <1403282030-29915-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shrink_zones() has a special branch to skip the all_unreclaimable()
check during hibernation, because a frozen kswapd can't mark a zone
unreclaimable.

But ever since 6e543d5780e3 ("mm: vmscan: fix do_try_to_free_pages()
livelock"), determining a zone to be unreclaimable is done by directly
looking at its scan history and no longer relies on kswapd setting the
per-zone flag.

Remove this branch and let shrink_zones() check the reclaimability of
the target zones regardless of hibernation state.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0f16ffe8eb67..19b5b8016209 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2534,14 +2534,6 @@ out:
 	if (sc->nr_reclaimed)
 		return sc->nr_reclaimed;
 
-	/*
-	 * As hibernation is going on, kswapd is freezed so that it can't mark
-	 * the zone into all_unreclaimable. Thus bypassing all_unreclaimable
-	 * check.
-	 */
-	if (oom_killer_disabled)
-		return 0;
-
 	/* Aborted reclaim to try compaction? don't OOM, then */
 	if (aborted_reclaim)
 		return 1;
-- 
2.0.0

