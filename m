Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaFFNW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:22:57 -0400
Received: from relay.parallels.com ([195.214.232.42]:42652 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaFFNWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:22:52 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <cl@linux.com>, <iamjoonsoo.kim@lge.com>, <rientjes@google.com>,
        <penberg@kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH -mm v2 4/8] slub: don't fail kmem_cache_shrink if slab placement optimization fails
Date: Fri, 6 Jun 2014 17:22:41 +0400
Message-ID: <c9aafeecd0a16f81f78f0d4549a48d0ecf98402f.1402060096.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1402060096.git.vdavydov@parallels.com>
References: <cover.1402060096.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.3]
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
 mm/slub.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d96faa2464c3..35741592be8c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3404,12 +3404,20 @@ int __kmem_cache_shrink(struct kmem_cache *s)
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
+		 * Do not fail shrinking empty slabs if allocation of the
+		 * temporary array failed. Just skip the slab placement
+		 * optimization then.
+		 */
+		slabs_by_inuse = &empty_slabs;
+		objects = 1;
+	}
 
 	flush_all(s);
 	for_each_node_state(node, N_NORMAL_MEMORY) {
@@ -3430,7 +3438,9 @@ int __kmem_cache_shrink(struct kmem_cache *s)
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
@@ -3449,7 +3459,8 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 			discard_slab(s, page);
 	}
 
-	kfree(slabs_by_inuse);
+	if (slabs_by_inuse != &empty_slabs)
+		kfree(slabs_by_inuse);
 	return 0;
 }
 
-- 
1.7.10.4

