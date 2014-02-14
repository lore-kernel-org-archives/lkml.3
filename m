Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaBNG53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:57:29 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59402 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaBNG50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:57:26 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-dd-52fdbe54360c
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 2/9] slab: makes clear_obj_pfmemalloc() just return store masked value
Date: Fri, 14 Feb 2014 15:57:16 +0900
Message-Id: <1392361043-22420-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clear_obj_pfmemalloc() takes the pointer to the object pointer as argument
to store masked value back into this address.
But this is useless, since we don't use this stored value anymore.
All we need is just masked value. So makes clear_obj_pfmemalloc()
just return masked value.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 5906f8f..6d17cad 100644
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
@@ -810,7 +810,7 @@ static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
 		struct kmem_cache_node *n;
 
 		if (gfp_pfmemalloc_allowed(flags)) {
-			clear_obj_pfmemalloc(&objp);
+			objp = clear_obj_pfmemalloc(objp);
 			return objp;
 		}
 
@@ -833,7 +833,7 @@ static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
 		if (!list_empty(&n->slabs_free) && force_refill) {
 			struct page *page = virt_to_head_page(objp);
 			ClearPageSlabPfmemalloc(page);
-			clear_obj_pfmemalloc(&objp);
+			objp = clear_obj_pfmemalloc(objp);
 			recheck_pfmemalloc_active(cachep, ac);
 			return objp;
 		}
@@ -3365,8 +3365,7 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
 		void *objp;
 		struct page *page;
 
-		clear_obj_pfmemalloc(&objpp[i]);
-		objp = objpp[i];
+		objp = clear_obj_pfmemalloc(objpp[i]);
 
 		page = virt_to_head_page(objp);
 		n = cachep->node[node];
-- 
1.7.9.5

