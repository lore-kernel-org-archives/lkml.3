Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbbAEBhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 20:37:46 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57272 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbbAEBhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 20:37:43 -0500
X-Original-SENDERIP: 10.177.220.158
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH 4/6] mm/slab: rearrange irq management
Date: Mon,  5 Jan 2015 10:37:29 +0900
Message-Id: <1420421851-3281-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420421851-3281-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1420421851-3281-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, irq is disabled at the very beginning phase of allocation
functions. In the following patch, some of allocation functions will
be changed to work without irq disabling so rearrange irq management
code as preparation step.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 62cd5c6..1246ac6 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2934,8 +2934,9 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 	void *objp;
 	struct array_cache *ac;
 	bool force_refill = false;
+	unsigned long save_flags;
 
-	check_irq_off();
+	local_irq_save(save_flags);
 
 	ac = cpu_cache_get(cachep);
 	if (likely(ac->avail)) {
@@ -2957,6 +2958,8 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 	objp = cache_alloc_refill(cachep, flags, force_refill);
 
 out:
+	local_irq_restore(save_flags);
+
 	return objp;
 }
 
@@ -3082,13 +3085,15 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 	struct kmem_cache_node *n;
 	void *obj;
 	int x;
+	unsigned long save_flags;
 
 	VM_BUG_ON(nodeid < 0 || nodeid >= MAX_NUMNODES);
 	n = get_node(cachep, nodeid);
 	BUG_ON(!n);
 
+	local_irq_save(save_flags);
+
 retry:
-	check_irq_off();
 	spin_lock(&n->list_lock);
 	entry = n->slabs_partial.next;
 	if (entry == &n->slabs_partial) {
@@ -3126,9 +3131,10 @@ must_grow:
 	if (x)
 		goto retry;
 
-	return fallback_alloc(cachep, flags);
+	obj = fallback_alloc(cachep, flags);
 
 done:
+	local_irq_restore(save_flags);
 	return obj;
 }
 
@@ -3150,14 +3156,15 @@ slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 	cachep = memcg_kmem_get_cache(cachep, flags);
 
 	cache_alloc_debugcheck_before(cachep, flags);
-	local_irq_save(save_flags);
 
 	if (nodeid == NUMA_NO_NODE)
 		nodeid = slab_node;
 
 	if (unlikely(!get_node(cachep, nodeid))) {
 		/* Node not bootstrapped yet */
+		local_irq_save(save_flags);
 		ptr = fallback_alloc(cachep, flags);
+		local_irq_restore(save_flags);
 		goto out;
 	}
 
@@ -3174,8 +3181,8 @@ slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 	}
 	/* ___cache_alloc_node can fall back to other nodes */
 	ptr = ____cache_alloc_node(cachep, flags, nodeid);
-  out:
-	local_irq_restore(save_flags);
+
+out:
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
 	kmemleak_alloc_recursive(ptr, cachep->object_size, 1, cachep->flags,
 				 flags);
@@ -3225,7 +3232,6 @@ __do_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 static __always_inline void *
 slab_alloc(struct kmem_cache *cachep, gfp_t flags, unsigned long caller)
 {
-	unsigned long save_flags;
 	void *objp;
 
 	flags &= gfp_allowed_mask;
@@ -3238,9 +3244,7 @@ slab_alloc(struct kmem_cache *cachep, gfp_t flags, unsigned long caller)
 	cachep = memcg_kmem_get_cache(cachep, flags);
 
 	cache_alloc_debugcheck_before(cachep, flags);
-	local_irq_save(save_flags);
 	objp = __do_cache_alloc(cachep, flags);
-	local_irq_restore(save_flags);
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
 	kmemleak_alloc_recursive(objp, cachep->object_size, 1, cachep->flags,
 				 flags);
-- 
1.7.9.5

