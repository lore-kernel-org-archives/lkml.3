Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaAKMhh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 07:37:37 -0500
Received: from relay.parallels.com ([195.214.232.42]:40318 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaAKMgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 07:36:47 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@gmail.com>
Subject: [PATCH 1/5] mm: vmscan: shrink all slab objects if tight on memory
Date: Sat, 11 Jan 2014 16:36:31 +0400
Message-ID: <7d37542211678a637dc6b4d995fd6f1e89100538.1389443272.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.24.175]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reclaiming kmem, we currently don't scan slabs that have less than
batch_size objects (see shrink_slab_node()):

        while (total_scan >= batch_size) {
                shrinkctl->nr_to_scan = batch_size;
                shrinker->scan_objects(shrinker, shrinkctl);
                total_scan -= batch_size;
        }

If there are only a few shrinkers available, such a behavior won't cause
any problems, because the batch_size is usually small, but if we have a
lot of slab shrinkers, which is perfectly possible since FS shrinkers
are now per-superblock, we can end up with hundreds of megabytes of
practically unreclaimable kmem objects. For instance, mounting a
thousand of ext2 FS images with a hundred of files in each and iterating
over all the files using du(1) will result in about 200 Mb of FS caches
that cannot be dropped even with the aid of the vm.drop_caches sysctl!

This problem was initially pointed out by Glauber Costa [*]. Glauber
proposed to fix it by making the shrink_slab() always take at least one
pass, to put it simply, turning the scan loop above to a do{}while()
loop. However, this proposal was rejected, because it could result in
more aggressive and frequent slab shrinking even under low memory
pressure when total_scan is naturally very small.

This patch is a slightly modified version of Glauber's approach.
Similarly to Glauber's patch, it makes shrink_slab() scan less than
batch_size objects, but only if the total number of objects we want to
scan (total_scan) is greater than the total number of objects available
(max_pass). Since total_scan is biased as half max_pass if the current
delta change is small:

        if (delta < max_pass / 4)
                total_scan = min(total_scan, max_pass / 2);

this is only possible if we are scanning at high prio. That said, this
patch shouldn't change the vmscan behaviour if the memory pressure is
low, but if we are tight on memory, we will do our best by trying to
reclaim all available objects, which sounds reasonable.

[*] http://www.spinics.net/lists/cgroups/msg06913.html

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@gmail.com>
---
 mm/vmscan.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index eea668d..0b3fc0a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -281,17 +281,34 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
 				nr_pages_scanned, lru_pages,
 				max_pass, delta, total_scan);
 
-	while (total_scan >= batch_size) {
+	/*
+	 * Normally, we should not scan less than batch_size objects in one
+	 * pass to avoid too frequent shrinker calls, but if the slab has less
+	 * than batch_size objects in total and we are really tight on memory,
+	 * we will try to reclaim all available objects, otherwise we can end
+	 * up failing allocations although there are plenty of reclaimable
+	 * objects spread over several slabs with usage less than the
+	 * batch_size.
+	 *
+	 * We detect the "tight on memory" situations by looking at the total
+	 * number of objects we want to scan (total_scan). If it is greater
+	 * than the total number of objects on slab (max_pass), we must be
+	 * scanning at high prio and therefore should try to reclaim as much as
+	 * possible.
+	 */
+	while (total_scan >= batch_size ||
+	       total_scan >= max_pass) {
 		unsigned long ret;
+		unsigned long nr_to_scan = min(batch_size, total_scan);
 
-		shrinkctl->nr_to_scan = batch_size;
+		shrinkctl->nr_to_scan = nr_to_scan;
 		ret = shrinker->scan_objects(shrinker, shrinkctl);
 		if (ret == SHRINK_STOP)
 			break;
 		freed += ret;
 
-		count_vm_events(SLABS_SCANNED, batch_size);
-		total_scan -= batch_size;
+		count_vm_events(SLABS_SCANNED, nr_to_scan);
+		total_scan -= nr_to_scan;
 
 		cond_resched();
 	}
-- 
1.7.10.4

