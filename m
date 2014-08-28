Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaH1TJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:09:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaH1Sfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:35:51 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 03/97] slab: correct pfmemalloc check
Date: Thu, 28 Aug 2014 19:34:11 +0100
Message-Id: <1409250945-30874-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

commit 73293c2f900d0adbb6a415b312cd57976d5ae242 upstream.

We checked pfmemalloc by slab unit, not page unit. You can see this
in is_slab_pfmemalloc(). So other pages don't need to be set/cleared
pfmemalloc.

And, therefore we should check pfmemalloc in page flag of first page,
but current implementation don't do that. virt_to_head_page(obj) just
return 'struct page' of that object, not one of first page, since the SLAB
don't use __GFP_COMP when CONFIG_MMU. To get 'struct page' of first page,
we first get a slab and try to get it via virt_to_head_page(slab->s_mem).

Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Pekka Enberg <penberg@iki.fi>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/slab.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

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
1.8.4.5

