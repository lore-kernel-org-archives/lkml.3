Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaACSCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:02:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:50775 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbaACSC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:02:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,599,1384329600"; 
   d="scan'208";a="459715621"
Subject: [PATCH 5/9] mm: rearrange struct page
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        penberg@kernel.org, cl@linux-foundation.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 03 Jan 2014 10:01:56 -0800
References: <20140103180147.6566F7C1@viggo.jf.intel.com>
In-Reply-To: <20140103180147.6566F7C1@viggo.jf.intel.com>
Message-Id: <20140103180156.684C95D6@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

To make the layout of 'struct page' look nicer, I broke
up a few of the unions.  But, this has a cost: things that
were guaranteed to line up before might not any more.  To make up
for that, some BUILD_BUG_ON()s are added to manually check for
the alignment dependencies.

This makes it *MUCH* more clear how the first few fields of
'struct page' get used by the slab allocators.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/include/linux/mm_types.h |  101 ++++++++++++++--------------
 linux.git-davehans/mm/slab.c                |    6 -
 linux.git-davehans/mm/slab_common.c         |   17 ++++
 linux.git-davehans/mm/slob.c                |   25 +++---
 4 files changed, 84 insertions(+), 65 deletions(-)

diff -puN include/linux/mm_types.h~rearrange-struct-page include/linux/mm_types.h
--- linux.git/include/linux/mm_types.h~rearrange-struct-page	2014-01-02 13:40:30.396315632 -0800
+++ linux.git-davehans/include/linux/mm_types.h	2014-01-02 13:40:30.405316037 -0800
@@ -46,27 +46,60 @@ struct page {
 	unsigned long flags;		/* Atomic flags, some possibly
 					 * updated asynchronously */
 	union {
-		struct address_space *mapping;	/* If low bit clear, points to
-						 * inode address_space, or NULL.
-						 * If page mapped as anonymous
-						 * memory, low bit is set, and
-						 * it points to anon_vma object:
-						 * see PAGE_MAPPING_ANON below.
-						 */
-		void *s_mem;			/* slab first object */
-	};
-
-	/* Second double word */
-	struct {
-		union {
+		struct /* the normal uses */ {
 			pgoff_t index;		/* Our offset within mapping. */
-			void *freelist;		/* sl[aou]b first free object */
+			/*
+			 * mapping: If low bit clear, points to
+			 * inode address_space, or NULL.  If page
+			 * mapped as anonymous memory, low bit is
+			 * set, and it points to anon_vma object:
+			 * see PAGE_MAPPING_ANON below.
+			 */
+			struct address_space *mapping;
+			/*
+			 * Count of ptes mapped in mms, to show when page
+			 * is mapped & limit reverse map searches.
+			 *
+			 * Used also for tail pages refcounting instead
+			 * of _count. Tail pages cannot be mapped and
+			 * keeping the tail page _count zero at all times
+			 * guarantees get_page_unless_zero() will never
+			 * succeed on tail pages.
+			 */
+			atomic_t _mapcount;
+			atomic_t _count;
+		}; /* end of the "normal" use */
+
+		struct { /* SLUB */
+			void *unused;
+			void *freelist;
+			unsigned inuse:16;
+			unsigned objects:15;
+			unsigned frozen:1;
+			atomic_t dontuse_slub_count;
 		};
-
-		union {
+		struct { /* SLAB */
+			void *s_mem;
+			void *slab_freelist;
+			unsigned int active;
+			atomic_t dontuse_slab_count;
+		};
+		struct { /* SLOB */
+			void *slob_unused;
+			void *slob_freelist;
+			unsigned int units;
+			atomic_t dontuse_slob_count;
+		};
+		/*
+		 * This is here to help the slub code deal with
+		 * its inuse/objects/frozen bitfields as a single
+		 * blob.
+		 */
+		struct { /* slub helpers */
+			void *slubhelp_unused;
+			void *slubhelp_freelist;
 #if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
-	defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
-			/* Used for cmpxchg_double in slub */
+    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 			unsigned long counters;
 #else
 			/*
@@ -76,38 +109,6 @@ struct page {
 			 */
 			unsigned counters;
 #endif
-
-			struct {
-
-				union {
-					/*
-					 * Count of ptes mapped in
-					 * mms, to show when page is
-					 * mapped & limit reverse map
-					 * searches.
-					 *
-					 * Used also for tail pages
-					 * refcounting instead of
-					 * _count. Tail pages cannot
-					 * be mapped and keeping the
-					 * tail page _count zero at
-					 * all times guarantees
-					 * get_page_unless_zero() will
-					 * never succeed on tail
-					 * pages.
-					 */
-					atomic_t _mapcount;
-
-					struct { /* SLUB */
-						unsigned inuse:16;
-						unsigned objects:15;
-						unsigned frozen:1;
-					};
-					int units;	/* SLOB */
-				};
-				atomic_t _count;		/* Usage count, see below. */
-			};
-			unsigned int active;	/* SLAB */
 		};
 	};
 
diff -puN mm/slab.c~rearrange-struct-page mm/slab.c
--- linux.git/mm/slab.c~rearrange-struct-page	2014-01-02 13:40:30.398315722 -0800
+++ linux.git-davehans/mm/slab.c	2014-01-02 13:40:30.407316127 -0800
@@ -1955,7 +1955,7 @@ static void slab_destroy(struct kmem_cac
 {
 	void *freelist;
 
-	freelist = page->freelist;
+	freelist = page->slab_freelist;
 	slab_destroy_debugcheck(cachep, page);
 	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU)) {
 		struct rcu_head *head;
@@ -2543,7 +2543,7 @@ static void *alloc_slabmgmt(struct kmem_
 
 static inline unsigned int *slab_freelist(struct page *page)
 {
-	return (unsigned int *)(page->freelist);
+	return (unsigned int *)(page->slab_freelist);
 }
 
 static void cache_init_objs(struct kmem_cache *cachep,
@@ -2648,7 +2648,7 @@ static void slab_map_pages(struct kmem_c
 			   void *freelist)
 {
 	page->slab_cache = cache;
-	page->freelist = freelist;
+	page->slab_freelist = freelist;
 }
 
 /*
diff -puN mm/slab_common.c~rearrange-struct-page mm/slab_common.c
--- linux.git/mm/slab_common.c~rearrange-struct-page	2014-01-02 13:40:30.400315812 -0800
+++ linux.git-davehans/mm/slab_common.c	2014-01-02 13:40:30.407316127 -0800
@@ -658,3 +658,20 @@ static int __init slab_proc_init(void)
 }
 module_init(slab_proc_init);
 #endif /* CONFIG_SLABINFO */
+#define SLAB_PAGE_CHECK(field1, field2)        \
+	BUILD_BUG_ON(offsetof(struct page, field1) !=   \
+		     offsetof(struct page, field2))
+/*
+ * To make the layout of 'struct page' look nicer, we've broken
+ * up a few of the unions.  Folks declaring their own use of the
+ * first few fields need to make sure that their use does not
+ * interfere with page->_count.  This ensures that the individual
+ * users' use actually lines up with the real ->_count.
+ */
+void slab_build_checks(void)
+{
+	SLAB_PAGE_CHECK(_count, dontuse_slab_count);
+	SLAB_PAGE_CHECK(_count, dontuse_slub_count);
+	SLAB_PAGE_CHECK(_count, dontuse_slob_count);
+}
+
diff -puN mm/slob.c~rearrange-struct-page mm/slob.c
--- linux.git/mm/slob.c~rearrange-struct-page	2014-01-02 13:40:30.402315902 -0800
+++ linux.git-davehans/mm/slob.c	2014-01-02 13:40:30.408316172 -0800
@@ -219,7 +219,8 @@ static void *slob_page_alloc(struct page
 	slob_t *prev, *cur, *aligned = NULL;
 	int delta = 0, units = SLOB_UNITS(size);
 
-	for (prev = NULL, cur = sp->freelist; ; prev = cur, cur = slob_next(cur)) {
+	for (prev = NULL, cur = sp->slob_freelist; ;
+	     prev = cur,  cur = slob_next(cur)) {
 		slobidx_t avail = slob_units(cur);
 
 		if (align) {
@@ -243,12 +244,12 @@ static void *slob_page_alloc(struct page
 				if (prev)
 					set_slob(prev, slob_units(prev), next);
 				else
-					sp->freelist = next;
+					sp->slob_freelist = next;
 			} else { /* fragment */
 				if (prev)
 					set_slob(prev, slob_units(prev), cur + units);
 				else
-					sp->freelist = cur + units;
+					sp->slob_freelist = cur + units;
 				set_slob(cur + units, avail - units, next);
 			}
 
@@ -321,7 +322,7 @@ static void *slob_alloc(size_t size, gfp
 
 		spin_lock_irqsave(&slob_lock, flags);
 		sp->units = SLOB_UNITS(PAGE_SIZE);
-		sp->freelist = b;
+		sp->slob_freelist = b;
 		INIT_LIST_HEAD(&sp->list);
 		set_slob(b, SLOB_UNITS(PAGE_SIZE), b + SLOB_UNITS(PAGE_SIZE));
 		set_slob_page_free(sp, slob_list);
@@ -368,7 +369,7 @@ static void slob_free(void *block, int s
 	if (!slob_page_free(sp)) {
 		/* This slob page is about to become partially free. Easy! */
 		sp->units = units;
-		sp->freelist = b;
+		sp->slob_freelist = b;
 		set_slob(b, units,
 			(void *)((unsigned long)(b +
 					SLOB_UNITS(PAGE_SIZE)) & PAGE_MASK));
@@ -388,15 +389,15 @@ static void slob_free(void *block, int s
 	 */
 	sp->units += units;
 
-	if (b < (slob_t *)sp->freelist) {
-		if (b + units == sp->freelist) {
-			units += slob_units(sp->freelist);
-			sp->freelist = slob_next(sp->freelist);
+	if (b < (slob_t *)sp->slob_freelist) {
+		if (b + units == sp->slob_freelist) {
+			units += slob_units(sp->slob_freelist);
+			sp->slob_freelist = slob_next(sp->slob_freelist);
 		}
-		set_slob(b, units, sp->freelist);
-		sp->freelist = b;
+		set_slob(b, units, sp->slob_freelist);
+		sp->slob_freelist = b;
 	} else {
-		prev = sp->freelist;
+		prev = sp->slob_freelist;
 		next = slob_next(prev);
 		while (b > next) {
 			prev = next;
_
