Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab3BLRMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:12:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933369Ab3BLRMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:12:20 -0500
Date: Tue, 12 Feb 2013 18:12:16 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v3 4/7] memcg: remove memcg from the reclaim iterators
Message-ID: <20130212171216.GA17663@dhcp22.suse.cz>
References: <20130211192929.GB29000@dhcp22.suse.cz>
 <20130211195824.GB15951@cmpxchg.org>
 <20130211212756.GC29000@dhcp22.suse.cz>
 <20130211223943.GC15951@cmpxchg.org>
 <20130212095419.GB4863@dhcp22.suse.cz>
 <20130212151002.GD15951@cmpxchg.org>
 <20130212154330.GG4863@dhcp22.suse.cz>
 <20130212161332.GI4863@dhcp22.suse.cz>
 <20130212162442.GJ4863@dhcp22.suse.cz>
 <63d3b5fa-dbc6-4bc9-8867-f9961e644305@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63d3b5fa-dbc6-4bc9-8867-f9961e644305@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 12-02-13 11:41:03, Johannes Weiner wrote:
> 
> 
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> >On Tue 12-02-13 17:13:32, Michal Hocko wrote:
> >> On Tue 12-02-13 16:43:30, Michal Hocko wrote:
> >> [...]
> >> The example was not complete:
> >> 
> >> > Wait a moment. But what prevents from the following race?
> >> > 
> >> > rcu_read_lock()
> >> 
> >> cgroup_next_descendant_pre
> >> css_tryget(css);
> >> memcg = mem_cgroup_from_css(css)		atomic_add(CSS_DEACT_BIAS,
> >&css->refcnt)
> >> 
> >> > 						mem_cgroup_css_offline(memcg)
> >> 
> >> We should be safe if we did synchronize_rcu() before
> >root->dead_count++,
> >> no?
> >> Because then we would have a guarantee that if css_tryget(memcg)
> >> suceeded then we wouldn't race with dead_count++ it triggered.
> >> 
> >> > 						root->dead_count++
> >> > iter->last_dead_count = root->dead_count
> >> > iter->last_visited = memcg
> >> > 						// final
> >> > 						css_put(memcg);
> >> > // last_visited is still valid
> >> > rcu_read_unlock()
> >> > [...]
> >> > // next iteration
> >> > rcu_read_lock()
> >> > iter->last_dead_count == root->dead_count
> >> > // KABOOM
> >
> >Ohh I have missed that we took a reference on the current memcg which
> >will be stored into last_visited. And then later, during the next
> >iteration it will be still alive until we are done because previous
> >patch moved css_put to the very end.
> >So this race is not possible. I still need to think about parallel
> >iteration and a race with removal.
> 
> I thought the whole point was to not have a reference in last_visited
> because have the iterator might be unused indefinitely :-)

OK, it seems that I managed to confuse ;)

> We only store a pointer and validate it before use the next time
> around.  So I think the race is still possible, but we can deal with
> it by not losing concurrent dead count changes, i.e. one atomic read
> in the iterator function.

All reads from root->dead_count are atomic already, so I am not sure
what you mean here. Anyway, I hope I won't make this even more confusing
if I post what I have right now:
---
>From 52121928be61282dc19e32179056615ffdf128a9 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 12 Feb 2013 18:08:26 +0100
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
css_tryget then makes sure that the last_visited is still alive.

Spotted-by: Ying Han <yinghan@google.com>
Original-idea-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 727ec39..31bb9b0 100644
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
 };
@@ -355,6 +360,7 @@ struct mem_cgroup {
 	struct mem_cgroup_stat_cpu nocpu_base;
 	spinlock_t pcp_counter_lock;
 
+	atomic_t	dead_count;
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
 	struct tcp_memcontrol tcp_mem;
 #endif
@@ -1156,17 +1162,36 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 			int nid = zone_to_nid(reclaim->zone);
 			int zid = zone_idx(reclaim->zone);
 			struct mem_cgroup_per_zone *mz;
+			unsigned int dead_count;
 
 			mz = mem_cgroup_zoneinfo(root, nid, zid);
 			iter = &mz->reclaim_iter[reclaim->priority];
-			last_visited = iter->last_visited;
 			if (prev && reclaim->generation != iter->generation) {
-				if (last_visited) {
-					css_put(&last_visited->css);
-					iter->last_visited = NULL;
-				}
+				iter->last_visited = NULL;
 				goto out_unlock;
 			}
+
+			/*
+                         * If the dead_count mismatches, a destruction
+                         * has happened or is happening concurrently.
+                         * If the dead_count matches, a destruction
+                         * might still happen concurrently, but since
+                         * we checked under RCU, that destruction
+                         * won't free the object until we release the
+                         * RCU reader lock.  Thus, the dead_count
+                         * check verifies the pointer is still valid,
+                         * css_tryget() verifies the cgroup pointed to
+                         * is alive.
+			 */
+			dead_count = atomic_read(&root->dead_count);
+			smp_rmb();
+			last_visited = iter->last_visited;
+			if (last_visited) {
+				if ((dead_count != iter->last_dead_count) ||
+					!css_tryget(&last_visited->css)) {
+					last_visited = NULL;
+				}
+			}
 		}
 
 		/*
@@ -1206,10 +1231,9 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
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
@@ -6366,10 +6390,37 @@ free_out:
 	return ERR_PTR(error);
 }
 
+/*
+ * Announce all parents that a group from their hierarchy is gone.
+ */
+static void mem_cgroup_invalidate_reclaim_iterators(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *parent = memcg;
+
+	/*
+	 * Make sure we are not racing with mem_cgroup_iter when it stores
+	 * a new iter->last_visited. Wait until that RCU finishes so that
+	 * it cannot see already incremented dead_count with memcg which
+	 * would be already dead next time but dead_count wouldn't tell
+	 * us about that.
+	 */
+	synchronize_rcu();
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
