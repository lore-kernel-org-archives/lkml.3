Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3EMIOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:14:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab3EMIMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:12:49 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Michal Hocko <mhocko@suse.cz>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 5/9] mm: vmscan: Do not allow kswapd to scan at maximum priority
Date: Mon, 13 May 2013 09:12:36 +0100
Message-Id: <1368432760-21573-6-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368432760-21573-1-git-send-email-mgorman@suse.de>
References: <1368432760-21573-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page reclaim at priority 0 will scan the entire LRU as priority 0 is
considered to be a near OOM condition. Kswapd can reach priority 0 quite
easily if it is encountering a large number of pages it cannot reclaim
such as pages under writeback. When this happens, kswapd reclaims very
aggressively even though there may be no real risk of allocation failure
or OOM.

This patch prevents kswapd reaching priority 0 and trying to reclaim
the world. Direct reclaimers will still reach priority 0 in the event
of an OOM situation.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index cd09803..1505c57 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2929,7 +2929,7 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
 		 */
 		if (raise_priority || !sc.nr_reclaimed)
 			sc.priority--;
-	} while (sc.priority >= 0 &&
+	} while (sc.priority >= 1 &&
 		 !pgdat_balanced(pgdat, order, *classzone_idx));
 
 out:
-- 
1.8.1.4

