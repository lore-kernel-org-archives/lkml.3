Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab3BKPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:16:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757255Ab3BKPQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:16:55 -0500
Date: Mon, 11 Feb 2013 16:16:49 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v3 4/7] memcg: remove memcg from the reclaim iterators
Message-ID: <20130211151649.GD19922@dhcp22.suse.cz>
References: <1357235661-29564-1-git-send-email-mhocko@suse.cz>
 <1357235661-29564-5-git-send-email-mhocko@suse.cz>
 <20130208193318.GA15951@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208193318.GA15951@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 08-02-13 14:33:18, Johannes Weiner wrote:
[...]
> for each in hierarchy:
>   for each node:
>     for each zone:
>       for each reclaim priority:
> 
> every time a cgroup is destroyed.  I don't think such a hammer is
> justified in general, let alone for consolidating code a little.
> 
> Can we invalidate the position cache lazily?  Have a global "cgroup
> destruction" counter and store a snapshot of that counter whenever we
> put a cgroup pointer in the position cache.  We only use the cached
> pointer if that counter has not changed in the meantime, so we know
> that the cgroup still exists.

Currently we have:
rcu_read_lock()	// keeps cgroup links safe
	iter->iter_lock	// keeps selection exclusive for a specific iterator
	1) global_counter == iter_counter
	2) css_tryget(cached_memcg)  // check it is still alive
rcu_read_unlock()

What would protect us from races when css would disappear between 1 and
2?

css is invalidated from worker context scheduled from __css_put and it
is using dentry locking which we surely do not want to pull here. We
could hook into css_offline which is called with cgroup_mutex but we
cannot use this one here because it is no longer exported and Tejun
would kill us for that.
So we can add a new global memcg internal lock to do this atomically.
Ohh, this is getting uglier...
	
> It is pretty pretty imprecise and we invalidate the whole cache every
> time a cgroup is destroyed, but I think that should be okay. 

I am not sure this is OK because this gives an indirect way of
influencing reclaim in one hierarchy by another one which opens a door
for regressions (or malicious over-reclaim in the extreme case).
So I do not like this very much.

> If not, better ideas are welcome.

Maybe we could keep the counter per memcg but that would mean that we
would need to go up the hierarchy as well. We wouldn't have to go over
node-zone-priority cleanup so it would be much more lightweight.

I am not sure this is necessarily better than explicit cleanup because
it brings yet another kind of generation number to the game but I guess
I can live with it if people really thing the relaxed way is much
better.
What do you think about the patch below (untested yet)?
---
>From 8169aa49649753822661b8fbbfba0852dcfedba6 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 11 Feb 2013 16:13:48 +0100
Subject: [PATCH] memcg: relax memcg iter caching

Now that per-node-zone-priority iterator caches memory cgroups rather
than their css ids we have to be careful and remove them from the
iterator when they are on the way out otherwise they might hang for
unbounded amount of time (until the global/targeted reclaim triggers the
zone under priority to find out the group is dead and let it to find the
final rest).

We can fix this issue by relaxing rules for the last_visited memcg as
well.
Instead of taking reference to css we can just use its pointer and
track the number of removed groups for each memcg. This number would be
stored into iterator everytime when a memcg is cached. If the iter count
doesn't match the curent walker root's one we will start over from the
root again. The group counter is incremented upwards the hierarchy every
time a group is removed.

dead_count_lock makes sure that we do not race with memcg removal.

Spotted-by: Ying Han <yinghan@google.com>
Original-idea-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e9f5c47..65bf2cb 100644
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
@@ -357,6 +362,8 @@ struct mem_cgroup {
 	struct mem_cgroup_stat_cpu nocpu_base;
 	spinlock_t pcp_counter_lock;
 
+	spinlock_t		dead_count_lock;
+	unsigned int		dead_count;
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
 	struct tcp_memcontrol tcp_mem;
 #endif
@@ -1162,15 +1169,24 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
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
+			spin_lock(&root->dead_count_lock);
+			last_visited = iter->last_visited;
+			if (last_visited && (root->dead_count !=
+						iter->last_dead_count)) {
+				last_visited = NULL;
+			}
 		}
 
 		/*
@@ -1204,16 +1220,21 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 		if (reclaim) {
 			struct mem_cgroup *curr = memcg;
 
-			if (last_visited)
-				css_put(&last_visited->css);
+			/*
+			 * last_visited is not longer used so we can let
+			 * other thread to run and update dead_count
+			 * because the current memcg would be valid
+			 * regardless other memcg was removed
+			 */
+			spin_unlock(&root->dead_count_lock);
 
 			if (css && !memcg)
 				curr = mem_cgroup_from_css(css);
 
-			/* make sure that the cached memcg is not removed */
-			if (curr)
-				css_get(&curr->css);
 			iter->last_visited = curr;
+			spin_lock(&root->dead_count_lock);
+			iter->last_dead_count = root->dead_count;
+			spin_unlock(&root->dead_count_lock);
 
 			if (!css)
 				iter->generation++;
@@ -6375,10 +6396,35 @@ free_out:
 	return ERR_PTR(error);
 }
 
+/*
+ * Announce all parents that a group from their hierarchy is gone.
+ */
+static void mem_cgroup_uncache_from_reclaim(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *parent = memcg;
+
+	while ((parent = parent_mem_cgroup(parent))) {
+		spin_lock(&parent->dead_count_lock);
+		parent->dead_count++;
+		spin_unlock(&parent->dead_count_lock);
+	}
+
+	/*
+	 * if the root memcg is not hierarchical we have to check it
+	 * explicitely.
+	 */
+	if (!root_mem_cgroup->use_hierarchy) {
+		spin_lock(&root_mem_cgroup->dead_count_lock);
+		parent->dead_count++;
+		spin_unlock(&root_mem_cgroup->dead_count_lock);
+	}
+}
+
 static void mem_cgroup_css_offline(struct cgroup *cont)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
+	mem_cgroup_uncache_from_reclaim(memcg);
 	mem_cgroup_reparent_charges(memcg);
 	mem_cgroup_destroy_all_caches(memcg);
 }
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
