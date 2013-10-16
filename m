Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386Ab3JPIpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:45:24 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56697 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab3JPIoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:44:25 -0400
X-AuditID: 9c930179-b7c78ae000003065-9c-525e51dfbb76
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 14/15] slab: remove useless statement for checking pfmemalloc
Date: Wed, 16 Oct 2013 17:44:11 +0900
Message-Id: <1381913052-23875-15-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, virt_to_page(page->s_mem) is same as the page,
because slab use this structure for management.
So remove useless statement.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 0e7f2e7..fbb594f 100644
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

