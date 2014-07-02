Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965178AbaGBAjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 20:39:17 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52947 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaGBAjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 20:39:16 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 2 Jul 2014 09:44:26 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3 3/9] slab: defer slab_destroy in free_block()
Message-ID: <20140702004426.GB9972@js1304-P5Q-DELUXE>
References: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1404203258-8923-4-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.DEB.2.02.1407011524210.4004@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407011524210.4004@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 03:25:04PM -0700, David Rientjes wrote:
> On Tue, 1 Jul 2014, Joonsoo Kim wrote:
> 
> > In free_block(), if freeing object makes new free slab and number of
> > free_objects exceeds free_limit, we start to destroy this new free slab
> > with holding the kmem_cache node lock. Holding the lock is useless and,
> > generally, holding a lock as least as possible is good thing. I never
> > measure performance effect of this, but we'd be better not to hold the lock
> > as much as possible.
> > 
> > Commented by Christoph:
> >   This is also good because kmem_cache_free is no longer called while
> >   holding the node lock. So we avoid one case of recursion.
> > 
> > Acked-by: Christoph Lameter <cl@linux.com>
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Not sure what happened to my
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> from http://marc.info/?l=linux-kernel&m=139951092124314, and for the 
> record, I still think the free_block() "list" formal should be commented.


Really sorry about that.
My mail client didn't have this mail due to unknow reason, so I missed it.

Here goes the new one with applying your comment.

--------->8------------
>From 39d0bd43b978583a3e735a4bc9896447f7873153 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Thu, 29 Aug 2013 15:25:36 +0900
Subject: [PATCH v4 3/9] slab: defer slab_destroy in free_block()

In free_block(), if freeing object makes new free slab and number of
free_objects exceeds free_limit, we start to destroy this new free slab
with holding the kmem_cache node lock. Holding the lock is useless and,
generally, holding a lock as least as possible is good thing. I never
measure performance effect of this, but we'd be better not to hold the lock
as much as possible.

Commented by Christoph:
  This is also good because kmem_cache_free is no longer called while
  holding the node lock. So we avoid one case of recursion.

Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab.c |   64 ++++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 20 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 19e2136..8f9e176 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -242,7 +242,8 @@ static struct kmem_cache_node __initdata init_kmem_cache_node[NUM_INIT_LISTS];
 static int drain_freelist(struct kmem_cache *cache,
 			struct kmem_cache_node *n, int tofree);
 static void free_block(struct kmem_cache *cachep, void **objpp, int len,
-			int node);
+			int node, struct list_head *list);
+static void slabs_destroy(struct kmem_cache *cachep, struct list_head *list);
 static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp);
 static void cache_reap(struct work_struct *unused);
 
@@ -1030,6 +1031,7 @@ static void __drain_alien_cache(struct kmem_cache *cachep,
 				struct array_cache *ac, int node)
 {
 	struct kmem_cache_node *n = get_node(cachep, node);
+	LIST_HEAD(list);
 
 	if (ac->avail) {
 		spin_lock(&n->list_lock);
@@ -1041,9 +1043,10 @@ static void __drain_alien_cache(struct kmem_cache *cachep,
 		if (n->shared)
 			transfer_objects(n->shared, ac, ac->limit);
 
-		free_block(cachep, ac->entry, ac->avail, node);
+		free_block(cachep, ac->entry, ac->avail, node, &list);
 		ac->avail = 0;
 		spin_unlock(&n->list_lock);
+		slabs_destroy(cachep, &list);
 	}
 }
 
@@ -1087,6 +1090,7 @@ static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
 	struct kmem_cache_node *n;
 	struct array_cache *alien = NULL;
 	int node;
+	LIST_HEAD(list);
 
 	node = numa_mem_id();
 
@@ -1111,8 +1115,9 @@ static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
 	} else {
 		n = get_node(cachep, nodeid);
 		spin_lock(&n->list_lock);
-		free_block(cachep, &objp, 1, nodeid);
+		free_block(cachep, &objp, 1, nodeid, &list);
 		spin_unlock(&n->list_lock);
+		slabs_destroy(cachep, &list);
 	}
 	return 1;
 }
@@ -1184,6 +1189,7 @@ static void cpuup_canceled(long cpu)
 		struct array_cache *nc;
 		struct array_cache *shared;
 		struct array_cache **alien;
+		LIST_HEAD(list);
 
 		/* cpu is dead; no one can alloc from it. */
 		nc = cachep->array[cpu];
@@ -1199,7 +1205,7 @@ static void cpuup_canceled(long cpu)
 		if (!memcg_cache_dead(cachep))
 			n->free_limit -= cachep->batchcount;
 		if (nc)
-			free_block(cachep, nc->entry, nc->avail, node);
+			free_block(cachep, nc->entry, nc->avail, node, &list);
 
 		if (!cpumask_empty(mask)) {
 			spin_unlock_irq(&n->list_lock);
@@ -1209,7 +1215,7 @@ static void cpuup_canceled(long cpu)
 		shared = n->shared;
 		if (shared) {
 			free_block(cachep, shared->entry,
-				   shared->avail, node);
+				   shared->avail, node, &list);
 			n->shared = NULL;
 		}
 
@@ -1224,6 +1230,7 @@ static void cpuup_canceled(long cpu)
 			free_alien_cache(alien);
 		}
 free_array_cache:
+		slabs_destroy(cachep, &list);
 		kfree(nc);
 	}
 	/*
@@ -2062,6 +2069,16 @@ static void slab_destroy(struct kmem_cache *cachep, struct page *page)
 		kmem_cache_free(cachep->freelist_cache, freelist);
 }
 
+static void slabs_destroy(struct kmem_cache *cachep, struct list_head *list)
+{
+	struct page *page, *n;
+
+	list_for_each_entry_safe(page, n, list, lru) {
+		list_del(&page->lru);
+		slab_destroy(cachep, page);
+	}
+}
+
 /**
  * calculate_slab_order - calculate size (page order) of slabs
  * @cachep: pointer to the cache that is being created
@@ -2465,6 +2482,7 @@ static void do_drain(void *arg)
 	struct array_cache *ac;
 	int node = numa_mem_id();
 	struct kmem_cache_node *n;
+	LIST_HEAD(list);
 
 	check_irq_off();
 	ac = cpu_cache_get(cachep);
@@ -2473,8 +2491,9 @@ static void do_drain(void *arg)
 
 	n = get_node(cachep, node);
 	spin_lock(&n->list_lock);
-	free_block(cachep, ac->entry, ac->avail, node);
+	free_block(cachep, ac->entry, ac->avail, node, &list);
 	spin_unlock(&n->list_lock);
+	slabs_destroy(cachep, &list);
 	ac->avail = 0;
 	if (memcg_cache_dead(cachep)) {
 		cachep->array[smp_processor_id()] = NULL;
@@ -3412,9 +3431,10 @@ slab_alloc(struct kmem_cache *cachep, gfp_t flags, unsigned long caller)
 
 /*
  * Caller needs to acquire correct kmem_cache_node's list_lock
+ * @list: List of detached free slabs should be freed by caller
  */
-static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
-		       int node)
+static void free_block(struct kmem_cache *cachep, void **objpp,
+			int nr_objects, int node, struct list_head *list)
 {
 	int i;
 	struct kmem_cache_node *n = get_node(cachep, node);
@@ -3437,13 +3457,7 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
 		if (page->active == 0) {
 			if (n->free_objects > n->free_limit) {
 				n->free_objects -= cachep->num;
-				/* No need to drop any previously held
-				 * lock here, even if we have a off-slab slab
-				 * descriptor it is guaranteed to come from
-				 * a different cache, refer to comments before
-				 * alloc_slabmgmt.
-				 */
-				slab_destroy(cachep, page);
+				list_add_tail(&page->lru, list);
 			} else {
 				list_add(&page->lru, &n->slabs_free);
 			}
@@ -3462,6 +3476,7 @@ static void cache_flusharray(struct kmem_cache *cachep, struct array_cache *ac)
 	int batchcount;
 	struct kmem_cache_node *n;
 	int node = numa_mem_id();
+	LIST_HEAD(list);
 
 	batchcount = ac->batchcount;
 #if DEBUG
@@ -3483,7 +3498,7 @@ static void cache_flusharray(struct kmem_cache *cachep, struct array_cache *ac)
 		}
 	}
 
-	free_block(cachep, ac->entry, batchcount, node);
+	free_block(cachep, ac->entry, batchcount, node, &list);
 free_done:
 #if STATS
 	{
@@ -3504,6 +3519,7 @@ free_done:
 	}
 #endif
 	spin_unlock(&n->list_lock);
+	slabs_destroy(cachep, &list);
 	ac->avail -= batchcount;
 	memmove(ac->entry, &(ac->entry[batchcount]), sizeof(void *)*ac->avail);
 }
@@ -3531,11 +3547,13 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp,
 
 #ifdef CONFIG_MEMCG_KMEM
 	if (unlikely(!ac)) {
+		LIST_HEAD(list);
 		int nodeid = page_to_nid(virt_to_page(objp));
 
 		spin_lock(&cachep->node[nodeid]->list_lock);
-		free_block(cachep, &objp, 1, nodeid);
+		free_block(cachep, &objp, 1, nodeid, &list);
 		spin_unlock(&cachep->node[nodeid]->list_lock);
+		slabs_destroy(cachep, &list);
 		return;
 	}
 #endif
@@ -3801,12 +3819,13 @@ static int alloc_kmem_cache_node(struct kmem_cache *cachep, gfp_t gfp)
 		n = get_node(cachep, node);
 		if (n) {
 			struct array_cache *shared = n->shared;
+			LIST_HEAD(list);
 
 			spin_lock_irq(&n->list_lock);
 
 			if (shared)
 				free_block(cachep, shared->entry,
-						shared->avail, node);
+						shared->avail, node, &list);
 
 			n->shared = new_shared;
 			if (!n->alien) {
@@ -3816,6 +3835,7 @@ static int alloc_kmem_cache_node(struct kmem_cache *cachep, gfp_t gfp)
 			n->free_limit = (1 + nr_cpus_node(node)) *
 					cachep->batchcount + cachep->num;
 			spin_unlock_irq(&n->list_lock);
+			slabs_destroy(cachep, &list);
 			kfree(shared);
 			free_alien_cache(new_alien);
 			continue;
@@ -3908,6 +3928,7 @@ static int __do_tune_cpucache(struct kmem_cache *cachep, int limit,
 	cachep->shared = shared;
 
 	for_each_online_cpu(i) {
+		LIST_HEAD(list);
 		struct array_cache *ccold = new->new[i];
 		int node;
 		struct kmem_cache_node *n;
@@ -3918,8 +3939,9 @@ static int __do_tune_cpucache(struct kmem_cache *cachep, int limit,
 		node = cpu_to_mem(i);
 		n = get_node(cachep, node);
 		spin_lock_irq(&n->list_lock);
-		free_block(cachep, ccold->entry, ccold->avail, node);
+		free_block(cachep, ccold->entry, ccold->avail, node, &list);
 		spin_unlock_irq(&n->list_lock);
+		slabs_destroy(cachep, &list);
 		kfree(ccold);
 	}
 	kfree(new);
@@ -4027,6 +4049,7 @@ skip_setup:
 static void drain_array(struct kmem_cache *cachep, struct kmem_cache_node *n,
 			 struct array_cache *ac, int force, int node)
 {
+	LIST_HEAD(list);
 	int tofree;
 
 	if (!ac || !ac->avail)
@@ -4039,12 +4062,13 @@ static void drain_array(struct kmem_cache *cachep, struct kmem_cache_node *n,
 			tofree = force ? ac->avail : (ac->limit + 4) / 5;
 			if (tofree > ac->avail)
 				tofree = (ac->avail + 1) / 2;
-			free_block(cachep, ac->entry, tofree, node);
+			free_block(cachep, ac->entry, tofree, node, &list);
 			ac->avail -= tofree;
 			memmove(ac->entry, &(ac->entry[tofree]),
 				sizeof(void *) * ac->avail);
 		}
 		spin_unlock_irq(&n->list_lock);
+		slabs_destroy(cachep, &list);
 	}
 }
 
-- 
1.7.9.5

