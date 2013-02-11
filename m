Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633Ab3BKT3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:29:37 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:64588 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759331Ab3BKT3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:29:34 -0500
Date: Mon, 11 Feb 2013 20:29:29 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v3 4/7] memcg: remove memcg from the reclaim iterators
Message-ID: <20130211192929.GB29000@dhcp22.suse.cz>
References: <1357235661-29564-1-git-send-email-mhocko@suse.cz>
 <1357235661-29564-5-git-send-email-mhocko@suse.cz>
 <20130208193318.GA15951@cmpxchg.org>
 <20130211151649.GD19922@dhcp22.suse.cz>
 <20130211175619.GC13218@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211175619.GC13218@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11-02-13 12:56:19, Johannes Weiner wrote:
> On Mon, Feb 11, 2013 at 04:16:49PM +0100, Michal Hocko wrote:
> > On Fri 08-02-13 14:33:18, Johannes Weiner wrote:
> > [...]
> > > for each in hierarchy:
> > >   for each node:
> > >     for each zone:
> > >       for each reclaim priority:
> > > 
> > > every time a cgroup is destroyed.  I don't think such a hammer is
> > > justified in general, let alone for consolidating code a little.
> > > 
> > > Can we invalidate the position cache lazily?  Have a global "cgroup
> > > destruction" counter and store a snapshot of that counter whenever we
> > > put a cgroup pointer in the position cache.  We only use the cached
> > > pointer if that counter has not changed in the meantime, so we know
> > > that the cgroup still exists.
> > 
> > Currently we have:
> > rcu_read_lock()	// keeps cgroup links safe
> > 	iter->iter_lock	// keeps selection exclusive for a specific iterator
> > 	1) global_counter == iter_counter
> > 	2) css_tryget(cached_memcg)  // check it is still alive
> > rcu_read_unlock()
> > 
> > What would protect us from races when css would disappear between 1 and
> > 2?
> 
> rcu

That was my first attempt but then I convinced myself it might not be
sufficient. But now that I think about it more I guess you are right.
 
> > css is invalidated from worker context scheduled from __css_put and it
> > is using dentry locking which we surely do not want to pull here. We
> > could hook into css_offline which is called with cgroup_mutex but we
> > cannot use this one here because it is no longer exported and Tejun
> > would kill us for that.
> > So we can add a new global memcg internal lock to do this atomically.
> > Ohh, this is getting uglier...
> 
> A racing final css_put() means that the tryget fails, but our RCU read
> lock keeps the CSS allocated.  If the dead_count is uptodate, it means
> that the rcu read lock was acquired before the synchronize_rcu()
> before the css is freed.

yes.

> 
> > > It is pretty pretty imprecise and we invalidate the whole cache every
> > > time a cgroup is destroyed, but I think that should be okay. 
> > 
> > I am not sure this is OK because this gives an indirect way of
> > influencing reclaim in one hierarchy by another one which opens a door
> > for regressions (or malicious over-reclaim in the extreme case).
> > So I do not like this very much.
> > 
> > > If not, better ideas are welcome.
> > 
> > Maybe we could keep the counter per memcg but that would mean that we
> > would need to go up the hierarchy as well. We wouldn't have to go over
> > node-zone-priority cleanup so it would be much more lightweight.
> > 
> > I am not sure this is necessarily better than explicit cleanup because
> > it brings yet another kind of generation number to the game but I guess
> > I can live with it if people really thing the relaxed way is much
> > better.
> > What do you think about the patch below (untested yet)?
> 
> Better, but I think you can get rid of both locks:

What is the other lock you have in mind.

> mem_cgroup_iter:
> rcu_read_lock()
> if atomic_read(&root->dead_count) == iter->dead_count:
>   smp_rmb()
>   if tryget(iter->position):
>     position = iter->position
> memcg = find_next(postion)
> css_put(position)
> iter->position = memcg
> smp_wmb() /* Write position cache BEFORE marking it uptodate */
> iter->dead_count = atomic_read(&root->dead_count)
> rcu_read_unlock()

Updated patch bellow:
---
>From 756c4f0091d250bc5ff816f8e9d11840e8522b3a Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 11 Feb 2013 20:23:51 +0100
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

Locking rules are a bit complicated but we primarily rely on rcu which
protects css from disappearing while it is proved to be still valid. The
validity is checked in two steps. First the iter->last_dead_count has
to match root->dead_count and second css_tryget has to confirm the
that the group is still alive and it pins it until we get a next memcg.

Spotted-by: Ying Han <yinghan@google.com>
Original-idea-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 57 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e9f5c47..f9b5719 100644
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
@@ -1158,19 +1164,33 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
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
+			 * css ref count then makes sure that css won't
+			 * disappear while we iterate to the next memcg
+			 */
+			last_visited = iter->last_visited;
+			dead_count = atomic_read(&root->dead_count);
+			smp_rmb();
+			if (last_visited &&
+					((dead_count != iter->last_dead_count) ||
+					 !css_tryget(&last_visited->css))) {
+				last_visited = NULL;
+			}
 		}
 
 		/*
@@ -1210,10 +1230,12 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 			if (css && !memcg)
 				curr = mem_cgroup_from_css(css);
 
-			/* make sure that the cached memcg is not removed */
-			if (curr)
-				css_get(&curr->css);
+			/*
+			 * No memory barrier is needed here because we are
+			 * protected by iter_lock
+			 */
 			iter->last_visited = curr;
+			iter->last_dead_count = atomic_read(&root->dead_count);
 
 			if (!css)
 				iter->generation++;
@@ -6375,10 +6397,36 @@ free_out:
 	return ERR_PTR(error);
 }
 
+/*
+ * Announce all parents that a group from their hierarchy is gone.
+ */
+static void mem_cgroup_uncache_from_reclaim(struct mem_cgroup *memcg)
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
+		atomic_inc(&parent->dead_count);
+
+	/*
+	 * Make sure that dead_count updates are visible before other
+	 * cleanup from css_offline.
+	 * Pairs with smp_rmb in mem_cgroup_iter
+	 */
+	smp_wmb();
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
