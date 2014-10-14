Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaJNQU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:20:58 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:41880 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612AbaJNQU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:20:56 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 5/5] mm: memcontrol: remove synchroneous stock draining code
Date: Tue, 14 Oct 2014 12:20:37 -0400
Message-Id: <1413303637-23862-6-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
References: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With charge reparenting, the last synchroneous stock drainer left.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 46 ++++++----------------------------------------
 1 file changed, 6 insertions(+), 40 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ce3ed7cc5c30..ac7d6cefcc63 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -634,8 +634,6 @@ static void disarm_static_keys(struct mem_cgroup *memcg)
 	disarm_kmem_keys(memcg);
 }
 
-static void drain_all_stock_async(struct mem_cgroup *memcg);
-
 static struct mem_cgroup_per_zone *
 mem_cgroup_zone_zoneinfo(struct mem_cgroup *memcg, struct zone *zone)
 {
@@ -2285,13 +2283,15 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
- * of the hierarchy under it. sync flag says whether we should block
- * until the work is done.
+ * of the hierarchy under it.
  */
-static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
+static void drain_all_stock(struct mem_cgroup *root_memcg)
 {
 	int cpu, curcpu;
 
+	/* If someone's already draining, avoid adding running more workers. */
+	if (!mutex_trylock(&percpu_charge_mutex))
+		return;
 	/* Notify other cpus that system-wide "drain" is running */
 	get_online_cpus();
 	curcpu = get_cpu();
@@ -2312,41 +2312,7 @@ static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 		}
 	}
 	put_cpu();
-
-	if (!sync)
-		goto out;
-
-	for_each_online_cpu(cpu) {
-		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
-		if (test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
-			flush_work(&stock->work);
-	}
-out:
 	put_online_cpus();
-}
-
-/*
- * Tries to drain stocked charges in other cpus. This function is asynchronous
- * and just put a work per cpu for draining localy on each cpu. Caller can
- * expects some charges will be back later but cannot wait for it.
- */
-static void drain_all_stock_async(struct mem_cgroup *root_memcg)
-{
-	/*
-	 * If someone calls draining, avoid adding more kworker runs.
-	 */
-	if (!mutex_trylock(&percpu_charge_mutex))
-		return;
-	drain_all_stock(root_memcg, false);
-	mutex_unlock(&percpu_charge_mutex);
-}
-
-/* This is a synchronous drain interface. */
-static void drain_all_stock_sync(struct mem_cgroup *root_memcg)
-{
-	/* called when force_empty is called */
-	mutex_lock(&percpu_charge_mutex);
-	drain_all_stock(root_memcg, true);
 	mutex_unlock(&percpu_charge_mutex);
 }
 
@@ -2455,7 +2421,7 @@ retry:
 		goto retry;
 
 	if (!drained) {
-		drain_all_stock_async(mem_over_limit);
+		drain_all_stock(mem_over_limit);
 		drained = true;
 		goto retry;
 	}
-- 
2.1.2

