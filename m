Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaEGGEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 02:04:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42205 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbaEGGEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 02:04:38 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 02/10] slab: makes clear_obj_pfmemalloc() just return masked value
Date: Wed,  7 May 2014 15:06:12 +0900
Message-Id: <1399442780-28748-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399442780-28748-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1399442780-28748-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clear_obj_pfmemalloc() takes the pointer to pointer to store masked value
back into this address. But this is useless, since we don't use this stored
value anymore. All we need is just masked value so makes clear_obj_pfmemalloc()
just return masked value.

v2: simplify commit description.
    directly return return value of clear_obj_pfmemalloc().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 1fede40..e2c80df 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -215,9 +215,9 @@ static inline void set_obj_pfmemalloc(void **objp)
 	return;
 }
 
-static inline void clear_obj_pfmemalloc(void **objp)
+static inline void *clear_obj_pfmemalloc(void *objp)
 {
-	*objp = (void *)((unsigned long)*objp & ~SLAB_OBJ_PFMEMALLOC);
+	return (void *)((unsigned long)objp & ~SLAB_OBJ_PFMEMALLOC);
 }
 
 /*
@@ -809,10 +809,8 @@ static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
 	if (unlikely(is_obj_pfmemalloc(objp))) {
 		struct kmem_cache_node *n;
 
-		if (gfp_pfmemalloc_allowed(flags)) {
-			clear_obj_pfmemalloc(&objp);
-			return objp;
-		}
+		if (gfp_pfmemalloc_allowed(flags))
+			return clear_obj_pfmemalloc(objp);
 
 		/* The caller cannot use PFMEMALLOC objects, find another one */
 		for (i = 0; i < ac->avail; i++) {
@@ -833,9 +831,8 @@ static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
 		if (!list_empty(&n->slabs_free) && force_refill) {
 			struct page *page = virt_to_head_page(objp);
 			ClearPageSlabPfmemalloc(page);
-			clear_obj_pfmemalloc(&objp);
 			recheck_pfmemalloc_active(cachep, ac);
-			return objp;
+			return clear_obj_pfmemalloc(objp);
 		}
 
 		/* No !PFMEMALLOC objects available */
@@ -3349,8 +3346,7 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
 		void *objp;
 		struct page *page;
 
-		clear_obj_pfmemalloc(&objpp[i]);
-		objp = objpp[i];
+		objp = clear_obj_pfmemalloc(objpp[i]);
 
 		page = virt_to_head_page(objp);
 		n = cachep->node[node];
-- 
1.7.9.5

