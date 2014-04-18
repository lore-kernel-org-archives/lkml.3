Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaDRW7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 18:59:53 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48088 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaDRW7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 18:59:50 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        nasa4836@gmail.com
Subject: [PATCH 1/2] mm/memcontrol.c: remove meaningless while loop in mem_cgroup_iter()
Date: Sat, 19 Apr 2014 06:58:55 +0800
Message-Id: <1397861935-31595-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the iteration job in mem_cgroup_iter() all delegates
to __mem_cgroup_iter_next(), which will skip dead node.

Thus, the outer while loop in mem_cgroup_iter() is meaningless.
It could be proven by this:

1. memcg != NULL
    we are done, no loop needed.
2. memcg == NULL
   2.1 prev != NULL, a round-trip is done, break out, no loop.
   2.2 prev == NULL, this is impossible, since prev==NULL means
       the initial interation, it will returns memcg==root.

So, this patches remove this meaningless while loop.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/memcontrol.c | 49 ++++++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 29501f0..e0ce15c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1212,6 +1212,8 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 {
 	struct mem_cgroup *memcg = NULL;
 	struct mem_cgroup *last_visited = NULL;
+	struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
+	int uninitialized_var(seq);
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1229,40 +1231,33 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	}
 
 	rcu_read_lock();
-	while (!memcg) {
-		struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
-		int uninitialized_var(seq);
-
-		if (reclaim) {
-			int nid = zone_to_nid(reclaim->zone);
-			int zid = zone_idx(reclaim->zone);
-			struct mem_cgroup_per_zone *mz;
-
-			mz = mem_cgroup_zoneinfo(root, nid, zid);
-			iter = &mz->reclaim_iter[reclaim->priority];
-			if (prev && reclaim->generation != iter->generation) {
-				iter->last_visited = NULL;
-				goto out_unlock;
-			}
+	if (reclaim) {
+		int nid = zone_to_nid(reclaim->zone);
+		int zid = zone_idx(reclaim->zone);
+		struct mem_cgroup_per_zone *mz;
 
-			last_visited = mem_cgroup_iter_load(iter, root, &seq);
+		mz = mem_cgroup_zoneinfo(root, nid, zid);
+		iter = &mz->reclaim_iter[reclaim->priority];
+		if (prev && reclaim->generation != iter->generation) {
+			iter->last_visited = NULL;
+			goto out_unlock;
 		}
 
-		memcg = __mem_cgroup_iter_next(root, last_visited);
+		last_visited = mem_cgroup_iter_load(iter, root, &seq);
+	}
 
-		if (reclaim) {
-			mem_cgroup_iter_update(iter, last_visited, memcg, root,
-					seq);
+	memcg = __mem_cgroup_iter_next(root, last_visited);
 
-			if (!memcg)
-				iter->generation++;
-			else if (!prev && memcg)
-				reclaim->generation = iter->generation;
-		}
+	if (reclaim) {
+		mem_cgroup_iter_update(iter, last_visited, memcg, root,
+				seq);
 
-		if (prev && !memcg)
-			goto out_unlock;
+		if (!memcg)
+			iter->generation++;
+		else if (!prev && memcg)
+			reclaim->generation = iter->generation;
 	}
+
 out_unlock:
 	rcu_read_unlock();
 out_css_put:
-- 
1.9.0.GIT

