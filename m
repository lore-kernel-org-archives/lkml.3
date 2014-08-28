Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaH1THB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:07:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbaH1SgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:13 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 25/97] mm: vmscan: call NUMA-unaware shrinkers irrespective of nodemask
Date: Thu, 28 Aug 2014 19:34:33 +0100
Message-Id: <1409250945-30874-26-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir Davydov <vdavydov@parallels.com>

commit ec97097bca147d5718a5d2c024d1ec740b10096d upstream.

If a shrinker is not NUMA-aware, shrink_slab() should call it exactly
once with nid=0, but currently it is not true: if node 0 is not set in
the nodemask or if it is not online, we will not call such shrinkers at
all.  As a result some slabs will be left untouched under some
circumstances.  Let us fix it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Dave Chinner <dchinner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Glauber Costa <glommer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0506995..e36294b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -369,16 +369,17 @@ unsigned long shrink_slab(struct shrink_control *shrinkctl,
 	}
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
-		for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
-			if (!node_online(shrinkctl->nid))
-				continue;
-
-			if (!(shrinker->flags & SHRINKER_NUMA_AWARE) &&
-			    (shrinkctl->nid != 0))
-				break;
-
+		if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
+			shrinkctl->nid = 0;
 			freed += shrink_slab_node(shrinkctl, shrinker,
-				 nr_pages_scanned, lru_pages);
+					nr_pages_scanned, lru_pages);
+			continue;
+		}
+
+		for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
+			if (node_online(shrinkctl->nid))
+				freed += shrink_slab_node(shrinkctl, shrinker,
+						nr_pages_scanned, lru_pages);
 
 		}
 	}
-- 
1.8.4.5

