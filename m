Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261Ab3JPIoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:44:18 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46536 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab3JPIoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:44:14 -0400
X-AuditID: 9c930179-b7c78ae000003065-68-525e51db834a
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH v2 01/15] slab: correct pfmemalloc check
Date: Wed, 16 Oct 2013 17:43:58 +0900
Message-Id: <1381913052-23875-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We checked pfmemalloc by slab unit, not page unit. You can see this
in is_slab_pfmemalloc(). So other pages don't need to be set/cleared
pfmemalloc.

And, therefore we should check pfmemalloc in page flag of first page,
but current implementation don't do that. virt_to_head_page(obj) just
return 'struct page' of that object, not one of first page, since the SLAB
don't use __GFP_COMP when CONFIG_MMU. To get 'struct page' of first page,
we first get a slab and try to get it via virt_to_head_page(slab->s_mem).

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 2580db0..0b4ddaf 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -930,7 +930,8 @@ static void *__ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
 {
 	if (unlikely(pfmemalloc_active)) {
 		/* Some pfmemalloc slabs exist, check if this is one */
-		struct page *page = virt_to_head_page(objp);
+		struct slab *slabp = virt_to_slab(objp);
+		struct page *page = virt_to_head_page(slabp->s_mem);
 		if (PageSlabPfmemalloc(page))
 			set_obj_pfmemalloc(&objp);
 	}
@@ -1776,7 +1777,7 @@ static void *kmem_getpages(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 		__SetPageSlab(page + i);
 
 		if (page->pfmemalloc)
-			SetPageSlabPfmemalloc(page + i);
+			SetPageSlabPfmemalloc(page);
 	}
 	memcg_bind_pages(cachep, cachep->gfporder);
 
@@ -1809,9 +1810,10 @@ static void kmem_freepages(struct kmem_cache *cachep, void *addr)
 	else
 		sub_zone_page_state(page_zone(page),
 				NR_SLAB_UNRECLAIMABLE, nr_freed);
+
+	__ClearPageSlabPfmemalloc(page);
 	while (i--) {
 		BUG_ON(!PageSlab(page));
-		__ClearPageSlabPfmemalloc(page);
 		__ClearPageSlab(page);
 		page++;
 	}
-- 
1.7.9.5

