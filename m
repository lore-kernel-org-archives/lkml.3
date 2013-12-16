Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3LPMXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:23:04 -0500
Received: from relay.parallels.com ([195.214.232.42]:56279 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab3LPMRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:17:17 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <dchinner@redhat.com>, <mhocko@suse.cz>, <hannes@cmpxchg.org>,
        <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>, <glommer@openvz.org>,
        <glommer@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v14 11/18] vmscan: call NUMA-unaware shrinkers irrespective of nodemask
Date: Mon, 16 Dec 2013 16:17:00 +0400
Message-ID: <6a91ffd8e51650a1a608686a6b3bbc26775d95d5.1387193771.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1387193771.git.vdavydov@parallels.com>
References: <cover.1387193771.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a shrinker is not NUMA-aware, shrink_slab() should call it exactly
once with nid=0, but currently it is not true: if node 0 is not set in
the nodemask or if it is not online, we will not call such shrinkers at
all. As a result some slabs will be left untouched under some
circumstances. Let us fix it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33b356e..d98f272 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -352,16 +352,17 @@ unsigned long shrink_slab(struct shrink_control *shrinkctl,
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
1.7.10.4

