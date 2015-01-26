Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbbAZMzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:55:44 -0500
Received: from mx2.parallels.com ([199.115.105.18]:55935 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbbAZMzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:55:40 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 1/3] slub: don't fail kmem_cache_shrink if slab placement optimization fails
Date: Mon, 26 Jan 2015 15:55:27 +0300
Message-ID: <3804a429071f939e6b4f654b6c6426c1fdd95f7e.1422275084.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1422275084.git.vdavydov@parallels.com>
References: <cover.1422275084.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB's kmem_cache_shrink not only removes empty slabs from the cache,
but also sorts slabs by the number of objects in-use to cope with
fragmentation. To achieve that, it tries to allocate a temporary array.
If it fails, it will abort the whole procedure.

This is unacceptable for kmemcg, where we want to be sure that all empty
slabs are removed from the cache on memcg offline, so let's just skip
the slab placement optimization step if the allocation fails, but still
get rid of empty slabs.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
---
 mm/slub.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 5ed1a73e2ec8..770bea3ed445 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3376,12 +3376,19 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 	struct page *page;
 	struct page *t;
 	int objects = oo_objects(s->max);
+	struct list_head empty_slabs;
 	struct list_head *slabs_by_inuse =
 		kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
 	unsigned long flags;
 
-	if (!slabs_by_inuse)
-		return -ENOMEM;
+	if (!slabs_by_inuse) {
+		/*
+		 * Do not abort if we failed to allocate a temporary array.
+		 * Just skip the slab placement optimization then.
+		 */
+		slabs_by_inuse = &empty_slabs;
+		objects = 1;
+	}
 
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
@@ -3400,7 +3407,9 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 		 * list_lock. page->inuse here is the upper limit.
 		 */
 		list_for_each_entry_safe(page, t, &n->partial, lru) {
-			list_move(&page->lru, slabs_by_inuse + page->inuse);
+			if (page->inuse < objects)
+				list_move(&page->lru,
+					  slabs_by_inuse + page->inuse);
 			if (!page->inuse)
 				n->nr_partial--;
 		}
@@ -3419,7 +3428,8 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 			discard_slab(s, page);
 	}
 
-	kfree(slabs_by_inuse);
+	if (slabs_by_inuse != &empty_slabs)
+		kfree(slabs_by_inuse);
 	return 0;
 }
 
-- 
1.7.10.4

