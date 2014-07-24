Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbaGXBQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 21:16:55 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:64703 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357AbaGXBQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 21:16:37 -0400
Date: Wed, 23 Jul 2014 18:16:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 3/3] mm, oom: rename zonelist locking functions
In-Reply-To: <alpine.DEB.2.02.1407231814110.22326@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407231815320.22326@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407231814110.22326@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_set_zonelist_oom() and clear_zonelist_oom() are not named properly to imply 
that they require locking semantics to avoid out_of_memory() being reordered.

zone_scan_lock is required for both functions to ensure that there is proper 
locking synchronization.

Rename try_set_zonelist_oom() to oom_zonelist_trylock() and rename 
clear_zonelist_oom() to oom_zonelist_unlock() to imply there is proper locking 
semantics.

At the same time, convert oom_zonelist_trylock() to return bool instead of int 
since only success and failure are tested.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/oom.h |  4 ++--
 mm/oom_kill.c       | 30 +++++++++++++-----------------
 mm/page_alloc.c     |  6 +++---
 3 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -55,8 +55,8 @@ extern void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			     struct mem_cgroup *memcg, nodemask_t *nodemask,
 			     const char *message);
 
-extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
-extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
+extern bool oom_zonelist_trylock(struct zonelist *zonelist, gfp_t gfp_flags);
+extern void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_flags);
 
 extern void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
 			       int order, const nodemask_t *nodemask);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -557,28 +557,25 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifier);
  * if a parallel OOM killing is already taking place that includes a zone in
  * the zonelist.  Otherwise, locks all zones in the zonelist and returns 1.
  */
-int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_mask)
+bool oom_zonelist_trylock(struct zonelist *zonelist, gfp_t gfp_mask)
 {
 	struct zoneref *z;
 	struct zone *zone;
-	int ret = 1;
+	bool ret = true;
 
 	spin_lock(&zone_scan_lock);
-	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
+	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
 		if (zone_is_oom_locked(zone)) {
-			ret = 0;
+			ret = false;
 			goto out;
 		}
-	}
 
-	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
-		/*
-		 * Lock each zone in the zonelist under zone_scan_lock so a
-		 * parallel invocation of try_set_zonelist_oom() doesn't succeed
-		 * when it shouldn't.
-		 */
+	/*
+	 * Lock each zone in the zonelist under zone_scan_lock so a parallel
+	 * call to oom_zonelist_trylock() doesn't succeed when it shouldn't.
+	 */
+	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
 		zone_set_flag(zone, ZONE_OOM_LOCKED);
-	}
 
 out:
 	spin_unlock(&zone_scan_lock);
@@ -590,15 +587,14 @@ out:
  * allocation attempts with zonelists containing them may now recall the OOM
  * killer, if necessary.
  */
-void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_mask)
+void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_mask)
 {
 	struct zoneref *z;
 	struct zone *zone;
 
 	spin_lock(&zone_scan_lock);
-	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
+	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
 		zone_clear_flag(zone, ZONE_OOM_LOCKED);
-	}
 	spin_unlock(&zone_scan_lock);
 }
 
@@ -693,8 +689,8 @@ void pagefault_out_of_memory(void)
 		return;
 
 	zonelist = node_zonelist(first_memory_node, GFP_KERNEL);
-	if (try_set_zonelist_oom(zonelist, GFP_KERNEL)) {
+	if (oom_zonelist_trylock(zonelist, GFP_KERNEL)) {
 		out_of_memory(zonelist, 0, 0, NULL, false);
-		clear_zonelist_oom(zonelist, GFP_KERNEL);
+		oom_zonelist_unlock(zonelist, GFP_KERNEL);
 	}
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2201,8 +2201,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 {
 	struct page *page;
 
-	/* Acquire the OOM killer lock for the zones in zonelist */
-	if (!try_set_zonelist_oom(zonelist, gfp_mask)) {
+	/* Acquire the per-zone oom lock for each zone */
+	if (!oom_zonelist_trylock(zonelist, gfp_mask)) {
 		schedule_timeout_uninterruptible(1);
 		return NULL;
 	}
@@ -2240,7 +2240,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	out_of_memory(zonelist, gfp_mask, order, nodemask, false);
 
 out:
-	clear_zonelist_oom(zonelist, gfp_mask);
+	oom_zonelist_unlock(zonelist, gfp_mask);
 	return page;
 }
 
