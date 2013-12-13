Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3LMX7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 18:59:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:12092 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3LMX7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,482,1384329600"; 
   d="scan'208";a="444049241"
Subject: [RFC][PATCH 2/7] mm: page->pfmemalloc only used by slab/skb
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Pravin B Shelar <pshelar@nicira.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 13 Dec 2013 15:59:06 -0800
References: <20131213235903.8236C539@viggo.jf.intel.com>
In-Reply-To: <20131213235903.8236C539@viggo.jf.intel.com>
Message-Id: <20131213235906.0838EB32@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

 linux.git-davehans/include/linux/mm.h       |   17 +++++++++++++++++
 linux.git-davehans/include/linux/mm_types.h |    9 ---------
 linux.git-davehans/include/linux/skbuff.h   |   10 +++++-----
 linux.git-davehans/mm/page_alloc.c          |    2 +-
 linux.git-davehans/mm/slab.c                |    4 ++--
 linux.git-davehans/mm/slub.c                |    2 +-
 6 files changed, 26 insertions(+), 18 deletions(-)

diff -puN include/linux/mm.h~page_pfmemalloc-only-used-by-slab include/linux/mm.h
--- linux.git/include/linux/mm.h~page_pfmemalloc-only-used-by-slab	2013-12-13 15:51:47.467218911 -0800
+++ linux.git-davehans/include/linux/mm.h	2013-12-13 15:51:47.475219263 -0800
@@ -2013,5 +2013,22 @@ void __init setup_nr_node_ids(void);
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
--- linux.git/include/linux/mm_types.h~page_pfmemalloc-only-used-by-slab	2013-12-13 15:51:47.468218955 -0800
+++ linux.git-davehans/include/linux/mm_types.h	2013-12-13 15:51:47.475219263 -0800
@@ -60,15 +60,6 @@ struct page {
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
--- linux.git/include/linux/skbuff.h~page_pfmemalloc-only-used-by-slab	2013-12-13 15:51:47.469218999 -0800
+++ linux.git-davehans/include/linux/skbuff.h	2013-12-13 15:51:47.475219263 -0800
@@ -1322,11 +1322,11 @@ static inline void __skb_fill_page_desc(
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
@@ -1335,7 +1335,7 @@ static inline void __skb_fill_page_desc(
 	skb_frag_size_set(frag, size);
 
 	page = compound_head(page);
-	if (page->pfmemalloc && !page->mapping)
+	if (page_pfmemalloc(page) && !page->mapping)
 		skb->pfmemalloc	= true;
 }
 
@@ -1917,7 +1917,7 @@ static inline struct page *__skb_alloc_p
 		gfp_mask |= __GFP_MEMALLOC;
 
 	page = alloc_pages_node(NUMA_NO_NODE, gfp_mask, order);
-	if (skb && page && page->pfmemalloc)
+	if (skb && page && page_pfmemalloc(page))
 		skb->pfmemalloc = true;
 
 	return page;
@@ -1946,7 +1946,7 @@ static inline struct page *__skb_alloc_p
 static inline void skb_propagate_pfmemalloc(struct page *page,
 					     struct sk_buff *skb)
 {
-	if (page && page->pfmemalloc)
+	if (page && page_pfmemalloc(page))
 		skb->pfmemalloc = true;
 }
 
diff -puN mm/page_alloc.c~page_pfmemalloc-only-used-by-slab mm/page_alloc.c
--- linux.git/mm/page_alloc.c~page_pfmemalloc-only-used-by-slab	2013-12-13 15:51:47.470219043 -0800
+++ linux.git-davehans/mm/page_alloc.c	2013-12-13 15:51:47.477219351 -0800
@@ -2066,7 +2066,7 @@ this_zone_full:
 		 * memory. The caller should avoid the page being used
 		 * for !PFMEMALLOC purposes.
 		 */
-		page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
+		set_page_pfmemalloc(page, alloc_flags & ALLOC_NO_WATERMARKS);
 
 	return page;
 }
diff -puN mm/slab.c~page_pfmemalloc-only-used-by-slab mm/slab.c
--- linux.git/mm/slab.c~page_pfmemalloc-only-used-by-slab	2013-12-13 15:51:47.471219087 -0800
+++ linux.git-davehans/mm/slab.c	2013-12-13 15:51:47.478219395 -0800
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
--- linux.git/mm/slub.c~page_pfmemalloc-only-used-by-slab	2013-12-13 15:51:47.472219131 -0800
+++ linux.git-davehans/mm/slub.c	2013-12-13 15:51:47.478219395 -0800
@@ -1403,7 +1403,7 @@ static struct page *new_slab(struct kmem
 	memcg_bind_pages(s, order);
 	page->slab_cache = s;
 	__SetPageSlab(page);
-	if (page->pfmemalloc)
+	if (page_pfmemalloc(page))
 		SetPageSlabPfmemalloc(page);
 
 	start = page_address(page);
_
