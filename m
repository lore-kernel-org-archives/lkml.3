Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab3HVIo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:44:26 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57101 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3HVIoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:44:21 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-53-5215cf62ba34
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 04/16] slab: remove nodeid in struct slab
Date: Thu, 22 Aug 2013 17:44:13 +0900
Message-Id: <1377161065-30552-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can get nodeid using address translation, so this field is not useful.
Therefore, remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index d9f81a0..69dc25a 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -222,7 +222,6 @@ struct slab {
 			void *s_mem;		/* including colour offset */
 			unsigned int inuse;	/* num of objs active in slab */
 			kmem_bufctl_t free;
-			unsigned short nodeid;
 		};
 		struct slab_rcu __slab_cover_slab_rcu;
 	};
@@ -1099,8 +1098,7 @@ static void drain_alien_cache(struct kmem_cache *cachep,
 
 static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
 {
-	struct slab *slabp = virt_to_slab(objp);
-	int nodeid = slabp->nodeid;
+	int nodeid = page_to_nid(virt_to_page(objp));
 	struct kmem_cache_node *n;
 	struct array_cache *alien = NULL;
 	int node;
@@ -1111,7 +1109,7 @@ static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
 	 * Make sure we are not freeing a object from another node to the array
 	 * cache on this cpu.
 	 */
-	if (likely(slabp->nodeid == node))
+	if (likely(nodeid == node))
 		return 0;
 
 	n = cachep->node[node];
@@ -2624,7 +2622,6 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep,
 	}
 	slabp->inuse = 0;
 	slabp->s_mem = addr + colour_off;
-	slabp->nodeid = nodeid;
 	slabp->free = 0;
 	return slabp;
 }
@@ -2701,7 +2698,7 @@ static void *slab_get_obj(struct kmem_cache *cachep, struct slab *slabp,
 	next = slab_bufctl(slabp)[slabp->free];
 #if DEBUG
 	slab_bufctl(slabp)[slabp->free] = BUFCTL_FREE;
-	WARN_ON(slabp->nodeid != nodeid);
+	WARN_ON(page_to_nid(virt_to_page(objp)) != nodeid);
 #endif
 	slabp->free = next;
 
@@ -2715,7 +2712,7 @@ static void slab_put_obj(struct kmem_cache *cachep, struct slab *slabp,
 
 #if DEBUG
 	/* Verify that the slab belongs to the intended node */
-	WARN_ON(slabp->nodeid != nodeid);
+	WARN_ON(page_to_nid(virt_to_page(objp)) != nodeid);
 
 	if (slab_bufctl(slabp)[objnr] + 1 <= SLAB_LIMIT + 1) {
 		printk(KERN_ERR "slab: double free detected in cache "
-- 
1.7.9.5

