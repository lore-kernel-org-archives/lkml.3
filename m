Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab3BKWHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 17:07:49 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:33550 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab3BKWHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 17:07:47 -0500
Date: Mon, 11 Feb 2013 23:07:42 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v3 4/7] memcg: remove memcg from the reclaim iterators
Message-ID: <20130211220742.GD29000@dhcp22.suse.cz>
References: <1357235661-29564-1-git-send-email-mhocko@suse.cz>
 <1357235661-29564-5-git-send-email-mhocko@suse.cz>
 <20130208193318.GA15951@cmpxchg.org>
 <20130211151649.GD19922@dhcp22.suse.cz>
 <20130211175619.GC13218@cmpxchg.org>
 <20130211192929.GB29000@dhcp22.suse.cz>
 <20130211195824.GB15951@cmpxchg.org>
 <20130211212756.GC29000@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211212756.GC29000@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11-02-13 22:27:56, Michal Hocko wrote:
[...]
> I will get back to this tomorrow.

Maybe not a great idea as it is getting late here and brain turns into
cabbage but there we go:
---
>From f927358fe620837081d7a7ec6bf27af378deb35d Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 11 Feb 2013 23:02:00 +0100
Subject: [PATCH] memcg: relax memcg iter caching

Now that per-node-zone-priority iterator caches memory cgroups rather
than their css ids we have to be careful and remove them from the
iterator when they are on the way out otherwise they might hang for
unbounded amount of time (until the global/targeted reclaim triggers the
zone under priority to find out the group is dead and let it to find the
final rest).

We can fix this issue by relaxing rules for the last_visited memcg as
well.
Instead of taking reference to css before it is stored into
iter->last_visited we can just store its pointer and track the number of
removed groups for each memcg. This number would be stored into iterator
everytime when a memcg is cached. If the iter count doesn't match the
curent walker root's one we will start over from the root again. The
group counter is incremented upwards the hierarchy every time a group is
removed.

Locking rules got a bit complicated. We primarily rely on rcu read
lock which makes sure that once we see an up-to-date dead_count then
iter->last_visited is valid for RCU walk. smp_rmb makes sure that
dead_count is read before last_visited and last_dead_count while smp_wmb
makes sure that last_visited is updated before last_dead_count so the
up-to-date last_dead_count cannot point to an outdated last_visited.
Which also means that css reference counting is no longer needed because
RCU will keep last_visited alive.

Spotted-by: Ying Han <yinghan@google.com>
Original-idea-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   53 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e9f5c47..42f9d94 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -144,8 +144,13 @@ struct mem_cgroup_stat_cpu {
 };
 
 struct mem_cgroup_reclaim_iter {
-	/* last scanned hierarchy member with elevated css ref count */
+	/*
+	 * last scanned hierarchy member. Valid only if last_dead_count
+	 * matches memcg->dead_count of the hierarchy root group.
+	 */
 	struct mem_cgroup *last_visited;
+	unsigned int last_dead_count;
+
 	/* scan generation, increased every round-trip */
 	unsigned int generation;
 	/* lock to protect the position and generation */
@@ -357,6 +362,7 @@ struct mem_cgroup {
 	struct mem_cgroup_stat_cpu nocpu_base;
 	spinlock_t pcp_counter_lock;
 
+	atomic_t	dead_count;
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
 	struct tcp_memcontrol tcp_mem;
 #endif
@@ -1158,19 +1164,30 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 			int nid = zone_to_nid(reclaim->zone);
 			int zid = zone_idx(reclaim->zone);
 			struct mem_cgroup_per_zone *mz;
+			unsigned int dead_count;
 
 			mz = mem_cgroup_zoneinfo(root, nid, zid);
 			iter = &mz->reclaim_iter[reclaim->priority];
 			spin_lock(&iter->iter_lock);
-			last_visited = iter->last_visited;
 			if (prev && reclaim->generation != iter->generation) {
-				if (last_visited) {
-					css_put(&last_visited->css);
-					iter->last_visited = NULL;
-				}
+				iter->last_visited = NULL;
 				spin_unlock(&iter->iter_lock);
 				goto out_unlock;
 			}
+
+			/*
+			 * last_visited might be invalid if some of the group
+			 * downwards was removed. As we do not know which one
+			 * disappeared we have to start all over again from the
+			 * root.
+			 */
+			dead_count = atomic_read(&root->dead_count);
+			smp_rmb();
+			last_visited = iter->last_visited;
+			if (last_visited &&
+					((dead_count != iter->last_dead_count))) {
+				last_visited = NULL;
+			}
 		}
 
 		/*
@@ -1210,10 +1227,9 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 			if (css && !memcg)
 				curr = mem_cgroup_from_css(css);
 
-			/* make sure that the cached memcg is not removed */
-			if (curr)
-				css_get(&curr->css);
 			iter->last_visited = curr;
+			smp_wmb();
+			iter->last_dead_count = atomic_read(&root->dead_count);
 
 			if (!css)
 				iter->generation++;
@@ -6375,10 +6391,29 @@ free_out:
 	return ERR_PTR(error);
 }
 
+/*
+ * Announce all parents that a group from their hierarchy is gone.
+ */
+static void mem_cgroup_invalidate_reclaim_iterators(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *parent = memcg;
+
+	while ((parent = parent_mem_cgroup(parent)))
+		atomic_inc(&parent->dead_count);
+
+	/*
+	 * if the root memcg is not hierarchical we have to check it
+	 * explicitely.
+	 */
+	if (!root_mem_cgroup->use_hierarchy)
+		atomic_inc(&root_mem_cgroup->dead_count);
+}
+
 static void mem_cgroup_css_offline(struct cgroup *cont)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
+	mem_cgroup_invalidate_reclaim_iterators(memcg);
 	mem_cgroup_reparent_charges(memcg);
 	mem_cgroup_destroy_all_caches(memcg);
 }
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
