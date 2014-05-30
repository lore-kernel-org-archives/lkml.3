Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506AbaE3Nvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:51:31 -0400
Received: from relay.parallels.com ([195.214.232.42]:41526 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbaE3NvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:51:19 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <cl@linux.com>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH -mm 6/8] slub: do not use cmpxchg for adding cpu partials when irqs disabled
Date: Fri, 30 May 2014 17:51:09 +0400
Message-ID: <620d4218dd5ea0d12e77396209c5108de6fd4634.1401457502.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1401457502.git.vdavydov@parallels.com>
References: <cover.1401457502.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We add slabs to per cpu partial lists on both objects allocation (see
get_partial_node) and free (see __slab_free). We use the same function,
put_cpu_partial, in both cases.

Since __slab_free can be executed with preempt/irqs enabled, we have to
use cmpxchg for adding a new element to a partial list in order to avoid
races in case we are moved to another cpu or an irq hits while we are in
the middle of put_cpu_partial.

However, get_partial_node is always called with irqs disabled, which
grants us exclusive access to the current cpu's partial list, so there
is no need in any synchronization and therefore cmpxchg is redundant
there.

Let's get rid of this redundancy and access/set per cpu partial list
from get_partial_node w/o cmpxchg-based synchronization.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slub.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2fc84853bffb..ac39cc9b6849 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1603,7 +1603,7 @@ static inline void *acquire_slab(struct kmem_cache *s,
 	return freelist;
 }
 
-static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain);
+static void prepare_cpu_partial(struct page *page, struct page *oldpage);
 static inline bool pfmemalloc_match(struct page *page, gfp_t gfpflags);
 
 /*
@@ -1643,7 +1643,8 @@ static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
 			stat(s, ALLOC_FROM_PARTIAL);
 			object = t;
 		} else {
-			put_cpu_partial(s, page, 0);
+			prepare_cpu_partial(page, c->partial);
+			c->partial = page;
 			stat(s, CPU_PARTIAL_NODE);
 		}
 		if (!kmem_cache_has_cpu_partial(s)
@@ -2015,6 +2016,26 @@ static void unfreeze_partials(struct kmem_cache *s,
 #endif
 }
 
+static void prepare_cpu_partial(struct page *page, struct page *oldpage)
+{
+#ifdef CONFIG_SLUB_CPU_PARTIAL
+	int pages = 0;
+	int pobjects = 0;
+
+	if (oldpage) {
+		pages = oldpage->pages;
+		pobjects = oldpage->pobjects;
+	}
+
+	pages++;
+	pobjects += page->objects - page->inuse;
+
+	page->pages = pages;
+	page->pobjects = pobjects;
+	page->next = oldpage;
+#endif
+}
+
 /*
  * Put a page that was just frozen (in __slab_free) into a partial page
  * slot if available. This is done without interrupts disabled and without
@@ -2024,22 +2045,16 @@ static void unfreeze_partials(struct kmem_cache *s,
  * If we did not find a slot then simply move all the partials to the
  * per node partial list.
  */
-static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
+static void put_cpu_partial(struct kmem_cache *s, struct page *page)
 {
 #ifdef CONFIG_SLUB_CPU_PARTIAL
 	struct page *oldpage;
-	int pages;
-	int pobjects;
 
 	do {
-		pages = 0;
-		pobjects = 0;
 		oldpage = this_cpu_read(s->cpu_slab->partial);
 
 		if (oldpage) {
-			pobjects = oldpage->pobjects;
-			pages = oldpage->pages;
-			if (drain && pobjects > s->cpu_partial) {
+			if (oldpage->pobjects > s->cpu_partial) {
 				unsigned long flags;
 				/*
 				 * partial array is full. Move the existing
@@ -2049,18 +2064,11 @@ static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 				unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
 				local_irq_restore(flags);
 				oldpage = NULL;
-				pobjects = 0;
-				pages = 0;
 				stat(s, CPU_PARTIAL_DRAIN);
 			}
 		}
 
-		pages++;
-		pobjects += page->objects - page->inuse;
-
-		page->pages = pages;
-		page->pobjects = pobjects;
-		page->next = oldpage;
+		prepare_cpu_partial(page, oldpage);
 
 	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page)
 								!= oldpage);
@@ -2608,7 +2616,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 		 * per cpu partial list.
 		 */
 		if (new.frozen && !was_frozen) {
-			put_cpu_partial(s, page, 1);
+			put_cpu_partial(s, page);
 			stat(s, CPU_PARTIAL_FREE);
 		}
 		/*
-- 
1.7.10.4

