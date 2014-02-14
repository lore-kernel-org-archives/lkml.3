Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaBNG5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:57:47 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46386 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaBNG52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:57:28 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-fd-52fdbe546075
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 9/9] slab: remove a useless lockdep annotation
Date: Fri, 14 Feb 2014 15:57:23 +0900
Message-Id: <1392361043-22420-10-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, there is no code to hold two lock simultaneously, since
we don't call slab_destroy() with holding any lock. So, lockdep
annotation is useless now. Remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 9c9d4d4..f723a72 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -437,143 +437,6 @@ static struct kmem_cache kmem_cache_boot = {
 	.name = "kmem_cache",
 };
 
-#define BAD_ALIEN_MAGIC 0x01020304ul
-
-#ifdef CONFIG_LOCKDEP
-
-/*
- * Slab sometimes uses the kmalloc slabs to store the slab headers
- * for other slabs "off slab".
- * The locking for this is tricky in that it nests within the locks
- * of all other slabs in a few places; to deal with this special
- * locking we put on-slab caches into a separate lock-class.
- *
- * We set lock class for alien array caches which are up during init.
- * The lock annotation will be lost if all cpus of a node goes down and
- * then comes back up during hotplug
- */
-static struct lock_class_key on_slab_l3_key;
-static struct lock_class_key on_slab_alc_key;
-
-static struct lock_class_key debugobj_l3_key;
-static struct lock_class_key debugobj_alc_key;
-
-static void slab_set_lock_classes(struct kmem_cache *cachep,
-		struct lock_class_key *l3_key, struct lock_class_key *alc_key,
-		int q)
-{
-	struct alien_cache **alc;
-	struct kmem_cache_node *n;
-	int r;
-
-	n = cachep->node[q];
-	if (!n)
-		return;
-
-	lockdep_set_class(&n->list_lock, l3_key);
-	alc = n->alien;
-	/*
-	 * FIXME: This check for BAD_ALIEN_MAGIC
-	 * should go away when common slab code is taught to
-	 * work even without alien caches.
-	 * Currently, non NUMA code returns BAD_ALIEN_MAGIC
-	 * for alloc_alien_cache,
-	 */
-	if (!alc || (unsigned long)alc == BAD_ALIEN_MAGIC)
-		return;
-	for_each_node(r) {
-		if (alc[r])
-			lockdep_set_class(&(alc[r]->lock), alc_key);
-	}
-}
-
-static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep, int node)
-{
-	slab_set_lock_classes(cachep, &debugobj_l3_key, &debugobj_alc_key, node);
-}
-
-static void slab_set_debugobj_lock_classes(struct kmem_cache *cachep)
-{
-	int node;
-
-	for_each_online_node(node)
-		slab_set_debugobj_lock_classes_node(cachep, node);
-}
-
-static void init_node_lock_keys(int q)
-{
-	int i;
-
-	if (slab_state < UP)
-		return;
-
-	for (i = 1; i <= KMALLOC_SHIFT_HIGH; i++) {
-		struct kmem_cache_node *n;
-		struct kmem_cache *cache = kmalloc_caches[i];
-
-		if (!cache)
-			continue;
-
-		n = cache->node[q];
-		if (!n || OFF_SLAB(cache))
-			continue;
-
-		slab_set_lock_classes(cache, &on_slab_l3_key,
-				&on_slab_alc_key, q);
-	}
-}
-
-static void on_slab_lock_classes_node(struct kmem_cache *cachep, int q)
-{
-	if (!cachep->node[q])
-		return;
-
-	slab_set_lock_classes(cachep, &on_slab_l3_key,
-			&on_slab_alc_key, q);
-}
-
-static inline void on_slab_lock_classes(struct kmem_cache *cachep)
-{
-	int node;
-
-	VM_BUG_ON(OFF_SLAB(cachep));
-	for_each_node(node)
-		on_slab_lock_classes_node(cachep, node);
-}
-
-static inline void init_lock_keys(void)
-{
-	int node;
-
-	for_each_node(node)
-		init_node_lock_keys(node);
-}
-#else
-static void init_node_lock_keys(int q)
-{
-}
-
-static inline void init_lock_keys(void)
-{
-}
-
-static inline void on_slab_lock_classes(struct kmem_cache *cachep)
-{
-}
-
-static inline void on_slab_lock_classes_node(struct kmem_cache *cachep, int node)
-{
-}
-
-static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep, int node)
-{
-}
-
-static void slab_set_debugobj_lock_classes(struct kmem_cache *cachep)
-{
-}
-#endif
-
 static DEFINE_PER_CPU(struct delayed_work, slab_reap_work);
 
 static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
@@ -921,7 +784,7 @@ static int transfer_objects(struct array_cache *to,
 static inline struct alien_cache **alloc_alien_cache(int node,
 						int limit, gfp_t gfp)
 {
-	return (struct alien_cache **)BAD_ALIEN_MAGIC;
+	return NULL;
 }
 
 static inline void free_alien_cache(struct alien_cache **ac_ptr)
@@ -1296,13 +1159,7 @@ static int cpuup_prepare(long cpu)
 		spin_unlock_irq(&n->list_lock);
 		kfree(shared);
 		free_alien_cache(alien);
-		if (cachep->flags & SLAB_DEBUG_OBJECTS)
-			slab_set_debugobj_lock_classes_node(cachep, node);
-		else if (!OFF_SLAB(cachep) &&
-			 !(cachep->flags & SLAB_DESTROY_BY_RCU))
-			on_slab_lock_classes_node(cachep, node);
 	}
-	init_node_lock_keys(node);
 
 	return 0;
 bad:
@@ -1611,9 +1468,6 @@ void __init kmem_cache_init_late(void)
 			BUG();
 	mutex_unlock(&slab_mutex);
 
-	/* Annotate slab for lockdep -- annotate the malloc caches */
-	init_lock_keys();
-
 	/* Done! */
 	slab_state = FULL;
 
@@ -2386,17 +2240,6 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 		return err;
 	}
 
-	if (flags & SLAB_DEBUG_OBJECTS) {
-		/*
-		 * Would deadlock through slab_destroy()->call_rcu()->
-		 * debug_object_activate()->kmem_cache_alloc().
-		 */
-		WARN_ON_ONCE(flags & SLAB_DESTROY_BY_RCU);
-
-		slab_set_debugobj_lock_classes(cachep);
-	} else if (!OFF_SLAB(cachep) && !(flags & SLAB_DESTROY_BY_RCU))
-		on_slab_lock_classes(cachep);
-
 	return 0;
 }
 
-- 
1.7.9.5

