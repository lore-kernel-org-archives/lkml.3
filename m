Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaANSBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:01:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:59689 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbaANSBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:01:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,658,1384329600"; 
   d="scan'208";a="465049815"
Subject: [RFC][PATCH 3/9] mm: page->pfmemalloc only used by slab/skb
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        penberg@kernel.org, cl@linux-foundation.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 14 Jan 2014 10:00:51 -0800
References: <20140114180042.C1C33F78@viggo.jf.intel.com>
In-Reply-To: <20140114180042.C1C33F78@viggo.jf.intel.com>
Message-Id: <20140114180051.0181E467@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

page->pfmemalloc does not deserve a spot in 'struct page'.  It is
only used transiently _just_ after a page leaves the buddy
allocator.

Instead of declaring a union, we move its functionality behind a
few quick accessor functions.  This way we could also much more
easily audit that it is being used correctly in debugging
scenarios.  For instance, we could store a magic number in there
which could never get reused as a page->index and check that the
magic number exists in page_pfmemalloc().

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/include/linux/mm.h       |   17 +++++++++++++++++
 b/include/linux/mm_types.h |    9 ---------
 b/include/linux/skbuff.h   |   10 +++++-----
 b/mm/page_alloc.c          |    2 +-
 b/mm/slab.c                |    4 ++--
 b/mm/slub.c                |    2 +-
 6 files changed, 26 insertions(+), 18 deletions(-)

diff -puN include/linux/mm.h~page_pfmemalloc-only-used-by-slab include/linux/mm.h
--- a/include/linux/mm.h~page_pfmemalloc-only-used-by-slab	2014-01-14 09:57:56.726650082 -0800
+++ b/include/linux/mm.h	2014-01-14 09:57:56.740650710 -0800
@@ -2059,5 +2059,22 @@ void __init setup_nr_node_ids(void);
 static inline void setup_nr_node_ids(void) {}
 #endif
 
+/*
+ * If set by the page allocator, ALLOC_NO_WATERMARKS was set and the
+ * low watermark was not met implying that the system is under some
+ * pressure. The caller should try ensure this page is only used to
+ * free other pages.  Currently only used by sl[au]b.  Note that
+ * this is only valid for a short time after the page returns
+ * from the allocator.
+ */
+static inline int page_pfmemalloc(struct page *page)
+{
+	return !!page->index;
+}
+static inline void set_page_pfmemalloc(struct page *page, int pfmemalloc)
+{
+	page->index = pfmemalloc;
+}
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff -puN include/linux/mm_types.h~page_pfmemalloc-only-used-by-slab include/linux/mm_types.h
--- a/include/linux/mm_types.h~page_pfmemalloc-only-used-by-slab	2014-01-14 09:57:56.727650127 -0800
+++ b/include/linux/mm_types.h	2014-01-14 09:57:56.741650755 -0800
@@ -61,15 +61,6 @@ struct page {
 		union {
 			pgoff_t index;		/* Our offset within mapping. */
 			void *freelist;		/* sl[aou]b first free object */
-			bool pfmemalloc;	/* If set by the page allocator,
-						 * ALLOC_NO_WATERMARKS was set
-						 * and the low watermark was not
-						 * met implying that the system
-						 * is under some pressure. The
-						 * caller should try ensure
-						 * this page is only used to
-						 * free other pages.
-						 */
 		};
 
 		union {
diff -puN include/linux/skbuff.h~page_pfmemalloc-only-used-by-slab include/linux/skbuff.h
--- a/include/linux/skbuff.h~page_pfmemalloc-only-used-by-slab	2014-01-14 09:57:56.729650217 -0800
+++ b/include/linux/skbuff.h	2014-01-14 09:57:56.743650845 -0800
@@ -1399,11 +1399,11 @@ static inline void __skb_fill_page_desc(
 	skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 	/*
-	 * Propagate page->pfmemalloc to the skb if we can. The problem is
+	 * Propagate page_pfmemalloc() to the skb if we can. The problem is
 	 * that not all callers have unique ownership of the page. If
 	 * pfmemalloc is set, we check the mapping as a mapping implies
 	 * page->index is set (index and pfmemalloc share space).
-	 * If it's a valid mapping, we cannot use page->pfmemalloc but we
+	 * If it's a valid mapping, we cannot use page_pfmemalloc() but we
 	 * do not lose pfmemalloc information as the pages would not be
 	 * allocated using __GFP_MEMALLOC.
 	 */
@@ -1412,7 +1412,7 @@ static inline void __skb_fill_page_desc(
 	skb_frag_size_set(frag, size);
 
 	page = compound_head(page);
-	if (page->pfmemalloc && !page->mapping)
+	if (page_pfmemalloc(page) && !page->mapping)
 		skb->pfmemalloc	= true;
 }
 
@@ -1999,7 +1999,7 @@ static inline struct page *__skb_alloc_p
 		gfp_mask |= __GFP_MEMALLOC;
 
 	page = alloc_pages_node(NUMA_NO_NODE, gfp_mask, order);
-	if (skb && page && page->pfmemalloc)
+	if (skb && page && page_pfmemalloc(page))
 		skb->pfmemalloc = true;
 
 	return page;
@@ -2028,7 +2028,7 @@ static inline struct page *__skb_alloc_p
 static inline void skb_propagate_pfmemalloc(struct page *page,
 					     struct sk_buff *skb)
 {
-	if (page && page->pfmemalloc)
+	if (page && page_pfmemalloc(page))
 		skb->pfmemalloc = true;
 }
 
diff -puN mm/page_alloc.c~page_pfmemalloc-only-used-by-slab mm/page_alloc.c
--- a/mm/page_alloc.c~page_pfmemalloc-only-used-by-slab	2014-01-14 09:57:56.731650307 -0800
+++ b/mm/page_alloc.c	2014-01-14 09:57:56.745650934 -0800
@@ -2073,7 +2073,7 @@ this_zone_full:
 		 * memory. The caller should avoid the page being used
 		 * for !PFMEMALLOC purposes.
 		 */
-		page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
+		set_page_pfmemalloc(page, alloc_flags & ALLOC_NO_WATERMARKS);
 
 	return page;
 }
diff -puN mm/slab.c~page_pfmemalloc-only-used-by-slab mm/slab.c
--- a/mm/slab.c~page_pfmemalloc-only-used-by-slab	2014-01-14 09:57:56.733650396 -0800
+++ b/mm/slab.c	2014-01-14 09:57:56.747651024 -0800
@@ -1672,7 +1672,7 @@ static struct page *kmem_getpages(struct
 	}
 
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
-	if (unlikely(page->pfmemalloc))
+	if (unlikely(page_pfmemalloc(page)))
 		pfmemalloc_active = true;
 
 	nr_pages = (1 << cachep->gfporder);
@@ -1683,7 +1683,7 @@ static struct page *kmem_getpages(struct
 		add_zone_page_state(page_zone(page),
 			NR_SLAB_UNRECLAIMABLE, nr_pages);
 	__SetPageSlab(page);
-	if (page->pfmemalloc)
+	if (page_pfmemalloc(page))
 		SetPageSlabPfmemalloc(page);
 	memcg_bind_pages(cachep, cachep->gfporder);
 
diff -puN mm/slub.c~page_pfmemalloc-only-used-by-slab mm/slub.c
--- a/mm/slub.c~page_pfmemalloc-only-used-by-slab	2014-01-14 09:57:56.735650486 -0800
+++ b/mm/slub.c	2014-01-14 09:57:56.749651114 -0800
@@ -1401,7 +1401,7 @@ static struct page *new_slab(struct kmem
 	memcg_bind_pages(s, order);
 	page->slab_cache = s;
 	__SetPageSlab(page);
-	if (page->pfmemalloc)
+	if (page_pfmemalloc(page))
 		SetPageSlabPfmemalloc(page);
 
 	start = page_address(page);
_
