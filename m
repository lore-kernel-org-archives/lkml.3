Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab3HVIsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:48:10 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46116 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab3HVIo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:44:26 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-64-5215cf6351b0
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 15/16] slab: remove useless statement for checking pfmemalloc
Date: Thu, 22 Aug 2013 17:44:24 +0900
Message-Id: <1377161065-30552-16-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, virt_to_page(page->s_mem) is same as the page,
because slab use this structure for management.
So remove useless statement.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index cf39309..6abc069 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -750,9 +750,7 @@ static struct array_cache *alloc_arraycache(int node, int entries,
 
 static inline bool is_slab_pfmemalloc(struct page *page)
 {
-	struct page *mem_page = virt_to_page(page->s_mem);
-
-	return PageSlabPfmemalloc(mem_page);
+	return PageSlabPfmemalloc(page);
 }
 
 /* Clears pfmemalloc_active if no slabs have pfmalloc set */
@@ -817,7 +815,7 @@ static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
 		n = cachep->node[numa_mem_id()];
 		if (!list_empty(&n->slabs_free) && force_refill) {
 			struct page *page = virt_to_head_page(objp);
-			ClearPageSlabPfmemalloc(virt_to_head_page(page->s_mem));
+			ClearPageSlabPfmemalloc(page);
 			clear_obj_pfmemalloc(&objp);
 			recheck_pfmemalloc_active(cachep, ac);
 			return objp;
@@ -850,8 +848,7 @@ static void *__ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
 	if (unlikely(pfmemalloc_active)) {
 		/* Some pfmemalloc slabs exist, check if this is one */
 		struct page *page = virt_to_head_page(objp);
-		struct page *mem_page = virt_to_head_page(page->s_mem);
-		if (PageSlabPfmemalloc(mem_page))
+		if (PageSlabPfmemalloc(page))
 			set_obj_pfmemalloc(&objp);
 	}
 
-- 
1.7.9.5

