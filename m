Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbaGAIYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:24:01 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:32916 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbaGAIWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:22:33 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 6/9] slab: use the lock on alien_cache, instead of the lock on array_cache
Date: Tue,  1 Jul 2014 17:27:35 +0900
Message-Id: <1404203258-8923-7-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we have separate alien_cache structure, so it'd be better to hold
the lock on alien_cache while manipulating alien_cache. After that,
we don't need the lock on array_cache, so remove it.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index e1a473d..1c319ad 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -191,7 +191,6 @@ struct array_cache {
 	unsigned int limit;
 	unsigned int batchcount;
 	unsigned int touched;
-	spinlock_t lock;
 	void *entry[];	/*
 			 * Must have this definition in here for the proper
 			 * alignment of array_cache. Also simplifies accessing
@@ -512,7 +511,7 @@ static void slab_set_lock_classes(struct kmem_cache *cachep,
 		return;
 	for_each_node(r) {
 		if (alc[r])
-			lockdep_set_class(&(alc[r]->ac.lock), alc_key);
+			lockdep_set_class(&(alc[r]->lock), alc_key);
 	}
 }
 
@@ -811,7 +810,6 @@ static void init_arraycache(struct array_cache *ac, int limit, int batch)
 		ac->limit = limit;
 		ac->batchcount = batch;
 		ac->touched = 0;
-		spin_lock_init(&ac->lock);
 	}
 }
 
@@ -1010,6 +1008,7 @@ static struct alien_cache *__alloc_alien_cache(int node, int entries,
 
 	alc = kmalloc_node(memsize, gfp, node);
 	init_arraycache(&alc->ac, entries, batch);
+	spin_lock_init(&alc->lock);
 	return alc;
 }
 
@@ -1086,9 +1085,9 @@ static void reap_alien(struct kmem_cache *cachep, struct kmem_cache_node *n)
 
 		if (alc) {
 			ac = &alc->ac;
-			if (ac->avail && spin_trylock_irq(&ac->lock)) {
+			if (ac->avail && spin_trylock_irq(&alc->lock)) {
 				__drain_alien_cache(cachep, ac, node);
-				spin_unlock_irq(&ac->lock);
+				spin_unlock_irq(&alc->lock);
 			}
 		}
 	}
@@ -1106,9 +1105,9 @@ static void drain_alien_cache(struct kmem_cache *cachep,
 		alc = alien[i];
 		if (alc) {
 			ac = &alc->ac;
-			spin_lock_irqsave(&ac->lock, flags);
+			spin_lock_irqsave(&alc->lock, flags);
 			__drain_alien_cache(cachep, ac, i);
-			spin_unlock_irqrestore(&ac->lock, flags);
+			spin_unlock_irqrestore(&alc->lock, flags);
 		}
 	}
 }
@@ -1136,13 +1135,13 @@ static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
 	if (n->alien && n->alien[nodeid]) {
 		alien = n->alien[nodeid];
 		ac = &alien->ac;
-		spin_lock(&ac->lock);
+		spin_lock(&alien->lock);
 		if (unlikely(ac->avail == ac->limit)) {
 			STATS_INC_ACOVERFLOW(cachep);
 			__drain_alien_cache(cachep, ac, nodeid);
 		}
 		ac_put_obj(cachep, ac, objp);
-		spin_unlock(&ac->lock);
+		spin_unlock(&alien->lock);
 	} else {
 		n = get_node(cachep, nodeid);
 		spin_lock(&n->list_lock);
@@ -1619,10 +1618,6 @@ void __init kmem_cache_init(void)
 
 		memcpy(ptr, cpu_cache_get(kmem_cache),
 		       sizeof(struct arraycache_init));
-		/*
-		 * Do not assume that spinlocks can be initialized via memcpy:
-		 */
-		spin_lock_init(&ptr->lock);
 
 		kmem_cache->array[smp_processor_id()] = ptr;
 
@@ -1632,10 +1627,6 @@ void __init kmem_cache_init(void)
 		       != &initarray_generic.cache);
 		memcpy(ptr, cpu_cache_get(kmalloc_caches[INDEX_AC]),
 		       sizeof(struct arraycache_init));
-		/*
-		 * Do not assume that spinlocks can be initialized via memcpy:
-		 */
-		spin_lock_init(&ptr->lock);
 
 		kmalloc_caches[INDEX_AC]->array[smp_processor_id()] = ptr;
 	}
-- 
1.7.9.5

