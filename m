Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3HVIvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:51:19 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46116 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3HVIoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:44:23 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-56-5215cf623140
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 07/16] slab: overloading the RCU head over the LRU for RCU free
Date: Thu, 22 Aug 2013 17:44:16 +0900
Message-Id: <1377161065-30552-8-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With build-time size checking, we can overload the RCU head over the LRU
of struct page to free pages of a slab in rcu context. This really help to
implement to overload the struct slab over the struct page and this
eventually reduce memory usage and cache footprint of the SLAB.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 0c62175..b8d19b1 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -51,7 +51,14 @@
  *  }
  *  rcu_read_unlock();
  *
- * See also the comment on struct slab_rcu in mm/slab.c.
+ * This is useful if we need to approach a kernel structure obliquely,
+ * from its address obtained without the usual locking. We can lock
+ * the structure to stabilize it and check it's still at the given address,
+ * only if we can be sure that the memory has not been meanwhile reused
+ * for some other kind of object (which our subsystem's lock might corrupt).
+ *
+ * rcu_read_lock before reading the address, then rcu_read_unlock after
+ * taking the spinlock within the structure expected at that address.
  */
 #define SLAB_DESTROY_BY_RCU	0x00080000UL	/* Defer freeing slabs to RCU */
 #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
diff --git a/mm/slab.c b/mm/slab.c
index 607a9b8..9e98ee0 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -189,25 +189,6 @@ typedef unsigned int kmem_bufctl_t;
 #define	SLAB_LIMIT	(((kmem_bufctl_t)(~0U))-3)
 
 /*
- * struct slab_rcu
- *
- * slab_destroy on a SLAB_DESTROY_BY_RCU cache uses this structure to
- * arrange for kmem_freepages to be called via RCU.  This is useful if
- * we need to approach a kernel structure obliquely, from its address
- * obtained without the usual locking.  We can lock the structure to
- * stabilize it and check it's still at the given address, only if we
- * can be sure that the memory has not been meanwhile reused for some
- * other kind of object (which our subsystem's lock might corrupt).
- *
- * rcu_read_lock before reading the address, then rcu_read_unlock after
- * taking the spinlock within the structure expected at that address.
- */
-struct slab_rcu {
-	struct rcu_head head;
-	struct page *page;
-};
-
-/*
  * struct slab
  *
  * Manages the objs in a slab. Placed either at the beginning of mem allocated
@@ -215,14 +196,11 @@ struct slab_rcu {
  * Slabs are chained into three list: fully used, partial, fully free slabs.
  */
 struct slab {
-	union {
-		struct {
-			struct list_head list;
-			void *s_mem;		/* including colour offset */
-			unsigned int inuse;	/* num of objs active in slab */
-			kmem_bufctl_t free;
-		};
-		struct slab_rcu __slab_cover_slab_rcu;
+	struct {
+		struct list_head list;
+		void *s_mem;		/* including colour offset */
+		unsigned int inuse;	/* num of objs active in slab */
+		kmem_bufctl_t free;
 	};
 };
 
@@ -1503,6 +1481,8 @@ void __init kmem_cache_init(void)
 {
 	int i;
 
+	BUILD_BUG_ON(sizeof(((struct page *)NULL)->lru) <
+					sizeof(struct rcu_head));
 	kmem_cache = &kmem_cache_boot;
 	setup_node_pointer(kmem_cache);
 
@@ -1816,10 +1796,13 @@ static void kmem_freepages(struct kmem_cache *cachep, struct page *page)
 
 static void kmem_rcu_free(struct rcu_head *head)
 {
-	struct slab_rcu *slab_rcu = (struct slab_rcu *)head;
-	struct kmem_cache *cachep = slab_rcu->page->slab_cache;
+	struct kmem_cache *cachep;
+	struct page *page;
 
-	kmem_freepages(cachep, slab_rcu->page);
+	page = container_of((struct list_head *)head, struct page, lru);
+	cachep = page->slab_cache;
+
+	kmem_freepages(cachep, page);
 }
 
 #if DEBUG
@@ -2040,11 +2023,11 @@ static void slab_destroy(struct kmem_cache *cachep, struct slab *slabp)
 
 	slab_destroy_debugcheck(cachep, slabp);
 	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU)) {
-		struct slab_rcu *slab_rcu;
+		struct rcu_head *head;
 
-		slab_rcu = (struct slab_rcu *)slabp;
-		slab_rcu->page = page;
-		call_rcu(&slab_rcu->head, kmem_rcu_free);
+		/* RCU free overloads the RCU head over the LRU */
+		head = (void *)&page->lru;
+		call_rcu(head, kmem_rcu_free);
 
 	} else
 		kmem_freepages(cachep, page);
-- 
1.7.9.5

