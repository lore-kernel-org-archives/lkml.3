Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaEGVTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:19:25 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60148 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaEGVTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:19:23 -0400
Date: Wed, 7 May 2014 14:19:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch] mm, slab: suppress out of memory warning unless debug is
 enabled
Message-ID: <alpine.DEB.2.02.1405071418410.8389@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the slab or slub allocators cannot allocate additional slab pages, they 
emit diagnostic information to the kernel log such as current number of slabs, 
number of objects, active objects, etc.  This is always coupled with a page 
allocation failure warning since it is controlled by !__GFP_NOWARN.

Suppress this out of memory warning if the allocator is configured without debug 
supported.  The page allocation failure warning will indicate it is a failed 
slab allocation, so this is only useful to diagnose allocator bugs.

Since CONFIG_SLUB_DEBUG is already enabled by default for the slub allocator, 
there is no functional change with this patch.  If debug is disabled, however, 
the warnings are now suppressed.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slab.c | 10 ++++++++--
 mm/slub.c | 11 ++++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1621,11 +1621,17 @@ __initcall(cpucache_init);
 static noinline void
 slab_out_of_memory(struct kmem_cache *cachep, gfp_t gfpflags, int nodeid)
 {
+#if DEBUG
 	struct kmem_cache_node *n;
 	struct page *page;
 	unsigned long flags;
 	int node;
 
+	if (gfpflags & __GFP_NOWARN)
+		return;
+	if (!printk_ratelimit())
+		return;
+
 	printk(KERN_WARNING
 		"SLAB: Unable to allocate memory on node %d (gfp=0x%x)\n",
 		nodeid, gfpflags);
@@ -1662,6 +1668,7 @@ slab_out_of_memory(struct kmem_cache *cachep, gfp_t gfpflags, int nodeid)
 			node, active_slabs, num_slabs, active_objs, num_objs,
 			free_objects);
 	}
+#endif
 }
 
 /*
@@ -1683,8 +1690,7 @@ static struct page *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
 
 	page = alloc_pages_exact_node(nodeid, flags | __GFP_NOTRACK, cachep->gfporder);
 	if (!page) {
-		if (!(flags & __GFP_NOWARN) && printk_ratelimit())
-			slab_out_of_memory(cachep, flags, nodeid);
+		slab_out_of_memory(cachep, flags, nodeid);
 		return NULL;
 	}
 
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2152,8 +2152,14 @@ static inline unsigned long node_nr_objs(struct kmem_cache_node *n)
 static noinline void
 slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
 {
+#ifdef CONFIG_SLUB_DEBUG
 	int node;
 
+	if (gfpflags & __GFP_NOWARN)
+		return;
+	if (!printk_ratelimit())
+		return;
+
 	printk(KERN_WARNING
 		"SLUB: Unable to allocate memory on node %d (gfp=0x%x)\n",
 		nid, gfpflags);
@@ -2182,6 +2188,7 @@ slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
 			"  node %d: slabs: %ld, objs: %ld, free: %ld\n",
 			node, nr_slabs, nr_objs, nr_free);
 	}
+#endif
 }
 
 static inline void *new_slab_objects(struct kmem_cache *s, gfp_t flags,
@@ -2360,9 +2367,7 @@ new_slab:
 	freelist = new_slab_objects(s, gfpflags, node, &c);
 
 	if (unlikely(!freelist)) {
-		if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
-			slab_out_of_memory(s, gfpflags, node);
-
+		slab_out_of_memory(s, gfpflags, node);
 		local_irq_restore(flags);
 		return NULL;
 	}
