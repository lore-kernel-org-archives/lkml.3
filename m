Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3C2Ka0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 06:30:26 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:46143 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3C2KaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 06:30:25 -0400
Message-ID: <51556CE9.9060000@huawei.com>
Date: Fri, 29 Mar 2013 18:28:57 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] memcg: take reference before releasing rcu_read_lock
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memcg is not referenced, so it can be destroyed at anytime right
after we exit rcu read section, so it's not safe to access it.

To fix this, we call css_tryget() to get a reference while we're still
in rcu read section.

This also removes a bogus comment above __memcg_create_cache_enqueue().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 mm/memcontrol.c | 63 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bbe0742..01fe340 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3456,7 +3456,6 @@ static void memcg_create_cache_work_func(struct work_struct *w)
 
 /*
  * Enqueue the creation of a per-memcg kmem_cache.
- * Called with rcu_read_lock.
  */
 static void __memcg_create_cache_enqueue(struct mem_cgroup *memcg,
 					 struct kmem_cache *cachep)
@@ -3464,12 +3463,8 @@ static void __memcg_create_cache_enqueue(struct mem_cgroup *memcg,
 	struct create_work *cw;
 
 	cw = kmalloc(sizeof(struct create_work), GFP_NOWAIT);
-	if (cw == NULL)
-		return;
-
-	/* The corresponding put will be done in the workqueue. */
-	if (!css_tryget(&memcg->css)) {
-		kfree(cw);
+	if (cw == NULL) {
+		css_put(&memcg->css);
 		return;
 	}
 
@@ -3525,10 +3520,9 @@ struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep,
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(current->mm->owner));
-	rcu_read_unlock();
 
 	if (!memcg_can_account_kmem(memcg))
-		return cachep;
+		goto out;
 
 	idx = memcg_cache_id(memcg);
 
@@ -3537,29 +3531,38 @@ struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep,
 	 * code updating memcg_caches will issue a write barrier to match this.
 	 */
 	read_barrier_depends();
-	if (unlikely(cachep->memcg_params->memcg_caches[idx] == NULL)) {
-		/*
-		 * If we are in a safe context (can wait, and not in interrupt
-		 * context), we could be be predictable and return right away.
-		 * This would guarantee that the allocation being performed
-		 * already belongs in the new cache.
-		 *
-		 * However, there are some clashes that can arrive from locking.
-		 * For instance, because we acquire the slab_mutex while doing
-		 * kmem_cache_dup, this means no further allocation could happen
-		 * with the slab_mutex held.
-		 *
-		 * Also, because cache creation issue get_online_cpus(), this
-		 * creates a lock chain: memcg_slab_mutex -> cpu_hotplug_mutex,
-		 * that ends up reversed during cpu hotplug. (cpuset allocates
-		 * a bunch of GFP_KERNEL memory during cpuup). Due to all that,
-		 * better to defer everything.
-		 */
-		memcg_create_cache_enqueue(memcg, cachep);
-		return cachep;
+	if (likely(cachep->memcg_params->memcg_caches[idx])) {
+		cachep = cachep->memcg_params->memcg_caches[idx];
+		goto out;
 	}
 
-	return cachep->memcg_params->memcg_caches[idx];
+	/* The corresponding put will be done in the workqueue. */
+	if (!css_tryget(&memcg->css))
+		goto out;
+	rcu_read_unlock();
+
+	/*
+	 * If we are in a safe context (can wait, and not in interrupt
+	 * context), we could be be predictable and return right away.
+	 * This would guarantee that the allocation being performed
+	 * already belongs in the new cache.
+	 *
+	 * However, there are some clashes that can arrive from locking.
+	 * For instance, because we acquire the slab_mutex while doing
+	 * kmem_cache_dup, this means no further allocation could happen
+	 * with the slab_mutex held.
+	 *
+	 * Also, because cache creation issue get_online_cpus(), this
+	 * creates a lock chain: memcg_slab_mutex -> cpu_hotplug_mutex,
+	 * that ends up reversed during cpu hotplug. (cpuset allocates
+	 * a bunch of GFP_KERNEL memory during cpuup). Due to all that,
+	 * better to defer everything.
+	 */
+	memcg_create_cache_enqueue(memcg, cachep);
+	return cachep;
+out:
+	rcu_read_unlock();
+	return cachep;
 }
 EXPORT_SYMBOL(__memcg_kmem_get_cache);
 
-- 
1.8.0.2
