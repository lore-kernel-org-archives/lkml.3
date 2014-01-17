Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaAQTZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:25:43 -0500
Received: from relay.parallels.com ([195.214.232.42]:54337 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaAQTZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:25:39 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@gmail.com>
Subject: [PATCH 3/3] mm: vmscan: shrink_slab: do not skip caches with < batch_size objects
Date: Fri, 17 Jan 2014 23:25:31 +0400
Message-ID: <461628a5763b31bb36cc3dd7f6b89b06a907234f.1389982079.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <4e2efebe688e06574f6495c634ac45d799e1518d.1389982079.git.vdavydov@parallels.com>
References: <4e2efebe688e06574f6495c634ac45d799e1518d.1389982079.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.24.241]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In its current implementation, shrink_slab() won't scan caches that have
less than batch_size objects. If there are only a few shrinkers
available, such a behavior won't cause any problems, because the
batch_size is usually small, but if we have a lot of slab shrinkers,
which is perfectly possible since FS shrinkers are now per-superblock,
we can end up with hundreds of megabytes of practically unreclaimable
kmem objects. For instance, mounting a thousand of ext2 FS images with a
hundred of files in each and iterating over all the files using du(1)
will result in about 200 Mb of FS caches that cannot be dropped even
with the aid of the vm.drop_caches sysctl! Fix this.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@gmail.com>
---
 mm/vmscan.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f6d716d..2e710d4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -275,7 +275,7 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
 	 * a large delta change is calculated directly.
 	 */
 	if (delta < freeable / 4)
-		total_scan = min(total_scan, freeable / 2);
+		total_scan = min(total_scan, max(freeable / 2, batch_size));
 
 	/*
 	 * Avoid risking looping forever due to too large nr value:
@@ -289,21 +289,34 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
 				nr_pages_scanned, lru_pages,
 				freeable, delta, total_scan);
 
-	while (total_scan >= batch_size) {
+	/*
+	 * To avoid CPU cache thrashing, we should not scan less than
+	 * batch_size objects in one pass, but if the cache has less
+	 * than batch_size objects in total, and we really want to
+	 * shrink them all, go ahead and scan what we have, otherwise
+	 * last batch_size objects will never get reclaimed.
+	 */
+	if (total_scan < batch_size &&
+	    !(freeable < batch_size && total_scan >= freeable))
+		goto out;
+
+	do {
 		unsigned long ret;
+		unsigned long nr_to_scan = min(total_scan, batch_size);
 
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
-	}
+	} while (total_scan >= batch_size);
 
+out:
 	/*
 	 * move the unused scan count back into the shrinker in a
 	 * manner that handles concurrent updates. If we exhausted the
-- 
1.7.10.4

