Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaANSBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:01:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:12798 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaANSA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:00:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,658,1384329600"; 
   d="scan'208";a="465049735"
Subject: [RFC][PATCH 1/9] mm: slab/slub: use page->list consistently instead of page->lru
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        penberg@kernel.org, cl@linux-foundation.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 14 Jan 2014 10:00:44 -0800
References: <20140114180042.C1C33F78@viggo.jf.intel.com>
In-Reply-To: <20140114180042.C1C33F78@viggo.jf.intel.com>
Message-Id: <20140114180044.1E401C47@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

'struct page' has two list_head fields: 'lru' and 'list'.
Conveniently, they are unioned together.  This means that code
can use them interchangably, which gets horribly confusing like
with this nugget from slab.c:

>	list_del(&page->lru);
>	if (page->active == cachep->num)
>		list_add(&page->list, &n->slabs_full);

This patch makes the slab and slub code use page->lru
universally instead of mixing ->list and ->lru.

So, the new rule is: page->lru is what the you use if you want to
keep your page on a list.  Don't like the fact that it's not
called ->list?  Too bad.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/include/linux/mm_types.h |    3 ++-
 b/mm/slab.c                |    4 ++--
 b/mm/slob.c                |   10 +++++-----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff -puN include/linux/mm_types.h~make-slab-use-page-lru-vs-list-consistently include/linux/mm_types.h
--- a/include/linux/mm_types.h~make-slab-use-page-lru-vs-list-consistently	2014-01-14 09:57:56.099621967 -0800
+++ b/include/linux/mm_types.h	2014-01-14 09:57:56.106622281 -0800
@@ -124,6 +124,8 @@ struct page {
 	union {
 		struct list_head lru;	/* Pageout list, eg. active_list
 					 * protected by zone->lru_lock !
+					 * Can be used as a generic list
+					 * by the page owner.
 					 */
 		struct {		/* slub per cpu partial pages */
 			struct page *next;	/* Next partial slab */
@@ -136,7 +138,6 @@ struct page {
 #endif
 		};
 
-		struct list_head list;	/* slobs list of pages */
 		struct slab *slab_page; /* slab fields */
 		struct rcu_head rcu_head;	/* Used by SLAB
 						 * when destroying via RCU
diff -puN mm/slab.c~make-slab-use-page-lru-vs-list-consistently mm/slab.c
--- a/mm/slab.c~make-slab-use-page-lru-vs-list-consistently	2014-01-14 09:57:56.101622056 -0800
+++ b/mm/slab.c	2014-01-14 09:57:56.108622370 -0800
@@ -2886,9 +2886,9 @@ retry:
 		/* move slabp to correct slabp list: */
 		list_del(&page->lru);
 		if (page->active == cachep->num)
-			list_add(&page->list, &n->slabs_full);
+			list_add(&page->lru, &n->slabs_full);
 		else
-			list_add(&page->list, &n->slabs_partial);
+			list_add(&page->lru, &n->slabs_partial);
 	}
 
 must_grow:
diff -puN mm/slob.c~make-slab-use-page-lru-vs-list-consistently mm/slob.c
--- a/mm/slob.c~make-slab-use-page-lru-vs-list-consistently	2014-01-14 09:57:56.103622146 -0800
+++ b/mm/slob.c	2014-01-14 09:57:56.109622415 -0800
@@ -111,13 +111,13 @@ static inline int slob_page_free(struct
 
 static void set_slob_page_free(struct page *sp, struct list_head *list)
 {
-	list_add(&sp->list, list);
+	list_add(&sp->lru, list);
 	__SetPageSlobFree(sp);
 }
 
 static inline void clear_slob_page_free(struct page *sp)
 {
-	list_del(&sp->list);
+	list_del(&sp->lru);
 	__ClearPageSlobFree(sp);
 }
 
@@ -282,7 +282,7 @@ static void *slob_alloc(size_t size, gfp
 
 	spin_lock_irqsave(&slob_lock, flags);
 	/* Iterate through each partially free page, try to find room */
-	list_for_each_entry(sp, slob_list, list) {
+	list_for_each_entry(sp, slob_list, lru) {
 #ifdef CONFIG_NUMA
 		/*
 		 * If there's a node specification, search for a partial
@@ -296,7 +296,7 @@ static void *slob_alloc(size_t size, gfp
 			continue;
 
 		/* Attempt to alloc */
-		prev = sp->list.prev;
+		prev = sp->lru.prev;
 		b = slob_page_alloc(sp, size, align);
 		if (!b)
 			continue;
@@ -322,7 +322,7 @@ static void *slob_alloc(size_t size, gfp
 		spin_lock_irqsave(&slob_lock, flags);
 		sp->units = SLOB_UNITS(PAGE_SIZE);
 		sp->freelist = b;
-		INIT_LIST_HEAD(&sp->list);
+		INIT_LIST_HEAD(&sp->lru);
 		set_slob(b, SLOB_UNITS(PAGE_SIZE), b + SLOB_UNITS(PAGE_SIZE));
 		set_slob_page_free(sp, slob_list);
 		b = slob_page_alloc(sp, size, align);
_
