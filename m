Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaFLUjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:39:00 -0400
Received: from mx2.parallels.com ([199.115.105.18]:51748 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaFLUi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:38:58 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <cl@linux.com>, <iamjoonsoo.kim@lge.com>, <rientjes@google.com>,
        <penberg@kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH -mm v3 8/8] slab: do not keep free objects/slabs on dead memcg caches
Date: Fri, 13 Jun 2014 00:38:22 +0400
Message-ID: <a985aec824cd35df381692fca83f7a8debc80305.1402602126.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1402602126.git.vdavydov@parallels.com>
References: <cover.1402602126.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since a dead memcg cache is destroyed only after the last slab allocated
to it is freed, we must disable caching of free objects/slabs for such
caches, otherwise they will be hanging around forever.

For SLAB that means we must disable per cpu free object arrays and make
free_block always discard empty slabs irrespective of node's free_limit.

To disable per cpu arrays, we free them on kmem_cache_shrink (see
drain_cpu_caches -> do_drain) and make __cache_free fall back to
free_block if there is no per cpu array. Also, we have to disable
allocation of per cpu arrays on cpu hotplug for dead caches (see
cpuup_prepare, __do_tune_cpucache).

After we disabled free objects/slabs caching, there is no need to reap
those caches periodically. Moreover, it will only result in slowdown. So
we also make cache_reap skip then.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slab.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index b3af82419251..7e91f5f1341d 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1210,6 +1210,9 @@ static int cpuup_prepare(long cpu)
 		struct array_cache *shared = NULL;
 		struct array_cache **alien = NULL;
 
+		if (memcg_cache_dead(cachep))
+			continue;
+
 		nc = alloc_arraycache(node, cachep->limit,
 					cachep->batchcount, GFP_KERNEL);
 		if (!nc)
@@ -2411,10 +2414,18 @@ static void do_drain(void *arg)
 
 	check_irq_off();
 	ac = cpu_cache_get(cachep);
+	if (!ac)
+		return;
+
 	spin_lock(&cachep->node[node]->list_lock);
 	free_block(cachep, ac->entry, ac->avail, node);
 	spin_unlock(&cachep->node[node]->list_lock);
 	ac->avail = 0;
+
+	if (memcg_cache_dead(cachep)) {
+		cachep->array[smp_processor_id()] = NULL;
+		kfree(ac);
+	}
 }
 
 static void drain_cpu_caches(struct kmem_cache *cachep)
@@ -3368,7 +3379,8 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
 
 		/* fixup slab chains */
 		if (page->active == 0) {
-			if (n->free_objects > n->free_limit) {
+			if (n->free_objects > n->free_limit ||
+			    memcg_cache_dead(cachep)) {
 				n->free_objects -= cachep->num;
 				/* No need to drop any previously held
 				 * lock here, even if we have a off-slab slab
@@ -3462,6 +3474,17 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp,
 
 	kmemcheck_slab_free(cachep, objp, cachep->object_size);
 
+#ifdef CONFIG_MEMCG_KMEM
+	if (unlikely(!ac)) {
+		int nodeid = page_to_nid(virt_to_page(objp));
+
+		spin_lock(&cachep->node[nodeid]->list_lock);
+		free_block(cachep, &objp, 1, nodeid);
+		spin_unlock(&cachep->node[nodeid]->list_lock);
+		return;
+	}
+#endif
+
 	/*
 	 * Skip calling cache_free_alien() when the platform is not numa.
 	 * This will avoid cache misses that happen while accessing slabp (which
@@ -3803,6 +3826,9 @@ static int __do_tune_cpucache(struct kmem_cache *cachep, int limit,
 	struct ccupdate_struct *new;
 	int i;
 
+	if (memcg_cache_dead(cachep))
+		return 0;
+
 	new = kzalloc(sizeof(*new) + nr_cpu_ids * sizeof(struct array_cache *),
 		      gfp);
 	if (!new)
@@ -3988,6 +4014,9 @@ static void cache_reap(struct work_struct *w)
 	list_for_each_entry(searchp, &slab_caches, list) {
 		check_irq_on();
 
+		if (memcg_cache_dead(searchp))
+			continue;
+
 		/*
 		 * We only take the node lock if absolutely necessary and we
 		 * have established with reasonable certainty that
-- 
1.7.10.4

