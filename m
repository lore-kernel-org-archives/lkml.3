Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbaGAIX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:23:56 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:32927 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517AbaGAIWd (ORCPT
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
Subject: [PATCH v3 7/9] slab: destroy a slab without holding any alien cache lock
Date: Tue,  1 Jul 2014 17:27:36 +0900
Message-Id: <1404203258-8923-8-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't heard that this alien cache lock is contended, but to reduce
chance of contention would be better generally. And with this change,
we can simplify complex lockdep annotation in slab code.
In the following patch, it will be implemented.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 1c319ad..854dfa0 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1050,10 +1050,10 @@ static void free_alien_cache(struct alien_cache **alc_ptr)
 }
 
 static void __drain_alien_cache(struct kmem_cache *cachep,
-				struct array_cache *ac, int node)
+				struct array_cache *ac, int node,
+				struct list_head *list)
 {
 	struct kmem_cache_node *n = get_node(cachep, node);
-	LIST_HEAD(list);
 
 	if (ac->avail) {
 		spin_lock(&n->list_lock);
@@ -1065,10 +1065,9 @@ static void __drain_alien_cache(struct kmem_cache *cachep,
 		if (n->shared)
 			transfer_objects(n->shared, ac, ac->limit);
 
-		free_block(cachep, ac->entry, ac->avail, node, &list);
+		free_block(cachep, ac->entry, ac->avail, node, list);
 		ac->avail = 0;
 		spin_unlock(&n->list_lock);
-		slabs_destroy(cachep, &list);
 	}
 }
 
@@ -1086,8 +1085,11 @@ static void reap_alien(struct kmem_cache *cachep, struct kmem_cache_node *n)
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
@@ -1104,10 +1106,13 @@ static void drain_alien_cache(struct kmem_cache *cachep,
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
@@ -1138,10 +1143,11 @@ static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
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
 		n = get_node(cachep, nodeid);
 		spin_lock(&n->list_lock);
-- 
1.7.9.5

