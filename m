Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaBNG6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:58:06 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59402 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaBNG52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:57:28 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-f7-52fdbe548171
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 8/9] slab: destroy a slab without holding any alien cache lock
Date: Fri, 14 Feb 2014 15:57:22 +0900
Message-Id: <1392361043-22420-9-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't heard that this alien cache lock is contended, but to reduce
chance of contention would be better generally. And with this change,
we can simplify complex lockdep annotation in slab code.
In the following patch, it will be implemented.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index ec1df4c..9c9d4d4 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1000,9 +1000,9 @@ static void free_alien_cache(struct alien_cache **alc_ptr)
 }
 
 static void __drain_alien_cache(struct kmem_cache *cachep,
-				struct array_cache *ac, int node)
+				struct array_cache *ac, int node,
+				struct list_head *list)
 {
-	LIST_HEAD(list);
 	struct kmem_cache_node *n = cachep->node[node];
 
 	if (ac->avail) {
@@ -1015,10 +1015,9 @@ static void __drain_alien_cache(struct kmem_cache *cachep,
 		if (n->shared)
 			transfer_objects(n->shared, ac, ac->limit);
 
-		free_block(cachep, ac->entry, ac->avail, node, &list);
+		free_block(cachep, ac->entry, ac->avail, node, list);
 		ac->avail = 0;
 		spin_unlock(&n->list_lock);
-		slabs_destroy(cachep, &list);
 	}
 }
 
@@ -1036,8 +1035,11 @@ static void reap_alien(struct kmem_cache *cachep, struct kmem_cache_node *n)
 		if (alc) {
 			ac = &alc->ac;
 			if (ac->avail && spin_trylock_irq(&alc->lock)) {
-				__drain_alien_cache(cachep, ac, node);
+				LIST_HEAD(list);
+
+				__drain_alien_cache(cachep, ac, node, &list);
 				spin_unlock_irq(&alc->lock);
+				slabs_destroy(cachep, &list);
 			}
 		}
 	}
@@ -1054,10 +1056,13 @@ static void drain_alien_cache(struct kmem_cache *cachep,
 	for_each_online_node(i) {
 		alc = alien[i];
 		if (alc) {
+			LIST_HEAD(list);
+
 			ac = &alc->ac;
 			spin_lock_irqsave(&alc->lock, flags);
-			__drain_alien_cache(cachep, ac, i);
+			__drain_alien_cache(cachep, ac, i, &list);
 			spin_unlock_irqrestore(&alc->lock, flags);
+			slabs_destroy(cachep, &list);
 		}
 	}
 }
@@ -1088,10 +1093,11 @@ static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
 		spin_lock(&alien->lock);
 		if (unlikely(ac->avail == ac->limit)) {
 			STATS_INC_ACOVERFLOW(cachep);
-			__drain_alien_cache(cachep, ac, nodeid);
+			__drain_alien_cache(cachep, ac, nodeid, &list);
 		}
 		ac_put_obj(cachep, ac, objp);
 		spin_unlock(&alien->lock);
+		slabs_destroy(cachep, &list);
 	} else {
 		spin_lock(&(cachep->node[nodeid])->list_lock);
 		free_block(cachep, &objp, 1, nodeid, &list);
-- 
1.7.9.5

