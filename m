Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3EAR5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:57:37 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42665 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3EAR53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:57:29 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 01 May 2013 23:20:12 +0530
Message-Id: <20130501175012.7229.24490.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20130501174950.7229.15267.sendpatchset@srdronam.in.ibm.com>
References: <20130501174950.7229.15267.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH 1/2] numa: Track last pid accessing a page.
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050117-7014-0000-0000-000002EF8E9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 30 Apr 2013 01:18:08 -0500
Subject: [PATCH 1/2] numa: Track last pid accessing a page.

This change is mostly extracted from ff2a9f9: numa, mm, sched: Implement
last-CPU+PID hash tracking from tip/numa/core.

We rely on the page::last_nid field (embedded in remaining bits of the
page flags field), to drive NUMA placement: the last_nid gives us
information about which tasks access memory on what node.

Lets consider a page is mostly a private page i.e accessed mostly by
one task. If such a task is being moved to a different node, then move
the page on the first access from the new node.

The cost is 8 more bits used from the page flags - this space
is still available on 64-bit systems.

There is the potential of false sharing if the PIDs of two tasks
are equal modulo 256 - this degrades the statistics somewhat but
does not completely eliminate it. Related tasks are typically
launched close to each other.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Originally-from: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/mm.h                |   72 ++++++++++++++++++++++++-------------
 include/linux/mm_types.h          |    4 +-
 include/linux/page-flags-layout.h |   25 ++++++++-----
 mm/huge_memory.c                  |    2 +-
 mm/memory.c                       |    4 +-
 mm/mempolicy.c                    |   20 ++++++++---
 mm/migrate.c                      |    4 +-
 mm/mm_init.c                      |   10 +++---
 mm/mmzone.c                       |   14 ++++----
 mm/page_alloc.c                   |    4 +-
 10 files changed, 99 insertions(+), 60 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e2091b8..2e3a3db 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -582,11 +582,11 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
  * sets it, so none of the operations on it need to be atomic.
  */
 
-/* Page flags: | [SECTION] | [NODE] | ZONE | [LAST_NID] | ... | FLAGS | */
+/* Page flags: | [SECTION] | [NODE] | ZONE | [LAST_NIDPID] | ... | FLAGS | */
 #define SECTIONS_PGOFF		((sizeof(unsigned long)*8) - SECTIONS_WIDTH)
 #define NODES_PGOFF		(SECTIONS_PGOFF - NODES_WIDTH)
 #define ZONES_PGOFF		(NODES_PGOFF - ZONES_WIDTH)
-#define LAST_NID_PGOFF		(ZONES_PGOFF - LAST_NID_WIDTH)
+#define LAST_NIDPID_PGOFF	(ZONES_PGOFF - LAST_NIDPID_WIDTH)
 
 /*
  * Define the bit shifts to access each section.  For non-existent
@@ -596,7 +596,7 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 #define SECTIONS_PGSHIFT	(SECTIONS_PGOFF * (SECTIONS_WIDTH != 0))
 #define NODES_PGSHIFT		(NODES_PGOFF * (NODES_WIDTH != 0))
 #define ZONES_PGSHIFT		(ZONES_PGOFF * (ZONES_WIDTH != 0))
-#define LAST_NID_PGSHIFT	(LAST_NID_PGOFF * (LAST_NID_WIDTH != 0))
+#define LAST_NIDPID_PGSHIFT	(LAST_NIDPID_PGOFF * (LAST_NIDPID_WIDTH != 0))
 
 /* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allocator */
 #ifdef NODE_NOT_IN_PAGE_FLAGS
@@ -618,7 +618,7 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 #define ZONES_MASK		((1UL << ZONES_WIDTH) - 1)
 #define NODES_MASK		((1UL << NODES_WIDTH) - 1)
 #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
-#define LAST_NID_MASK		((1UL << LAST_NID_WIDTH) - 1)
+#define LAST_NIDPID_MASK	((1UL << LAST_NIDPID_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
 static inline enum zone_type page_zonenum(const struct page *page)
@@ -662,51 +662,73 @@ static inline int page_to_nid(const struct page *page)
 #endif
 
 #ifdef CONFIG_NUMA_BALANCING
-#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
-static inline int page_nid_xchg_last(struct page *page, int nid)
+
+static inline int nidpid_to_nid(int nidpid)
 {
-	return xchg(&page->_last_nid, nid);
+	return (nidpid >> NIDPID_PID_BITS) & NIDPID_NID_MASK;
 }
 
-static inline int page_nid_last(struct page *page)
+static inline int nidpid_to_pid(int nidpid)
 {
-	return page->_last_nid;
+	return nidpid & NIDPID_PID_MASK;
 }
-static inline void page_nid_reset_last(struct page *page)
+
+static inline int nid_pid_to_nidpid(int nid, int pid)
 {
-	page->_last_nid = -1;
+	return ((nid & NIDPID_NID_MASK) << NIDPID_PID_BITS) | (pid & NIDPID_PID_MASK);
 }
-#else
-static inline int page_nid_last(struct page *page)
+
+#ifdef LAST_NIDPID_NOT_IN_PAGE_FLAGS
+static inline int page_xchg_last_nidpid(struct page *page, int nidpid)
 {
-	return (page->flags >> LAST_NID_PGSHIFT) & LAST_NID_MASK;
+	return xchg(&page->_last_nidpid, nidpid);
 }
 
-extern int page_nid_xchg_last(struct page *page, int nid);
-
-static inline void page_nid_reset_last(struct page *page)
+static inline int page_last_nidpid(struct page *page)
 {
-	int nid = (1 << LAST_NID_SHIFT) - 1;
+	return page->_last_nidpid;
+}
 
-	page->flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
-	page->flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
+static inline void reset_page_last_nidpid(struct page *page)
+{
+	page->_last_nidpid = -1;
 }
-#endif /* LAST_NID_NOT_IN_PAGE_FLAGS */
+
 #else
-static inline int page_nid_xchg_last(struct page *page, int nid)
+
+extern int page_xchg_last_nidpid(struct page *page, int nidpid);
+static inline int page_last_nidpid(struct page *page)
+{
+	return (page->flags >> LAST_NIDPID_PGSHIFT) & LAST_NIDPID_MASK;
+}
+
+static inline void reset_page_last_nidpid(struct page *page)
+{
+	page_xchg_last_nidpid(page, -1);
+}
+#endif /* LAST_NIDPID_NOT_IN_PAGE_FLAGS */
+
+static inline int page_last_pid(struct page *page)
+{
+	return nidpid_to_pid(page_last_nidpid(page));
+}
+
+#else /* !CONFIG_NUMA_BALANCING: */
+static inline int page_xchg_last_nidpid(struct page *page, int cpu)
 {
 	return page_to_nid(page);
 }
 
-static inline int page_nid_last(struct page *page)
+static inline int page_last_nidpid(struct page *page)
 {
 	return page_to_nid(page);
 }
 
-static inline void page_nid_reset_last(struct page *page)
+static inline void reset_page_last_nidpid(struct page *page)
 {
 }
-#endif
+
+#endif /* !CONFIG_NUMA_BALANCING */
 
 static inline struct zone *page_zone(const struct page *page)
 {
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index ace9a5f..ccb20b9 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -174,8 +174,8 @@ struct page {
 	void *shadow;
 #endif
 
-#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
-	int _last_nid;
+#ifdef LAST_NIDPID_NOT_IN_PAGE_FLAGS
+	int _last_nidpid;
 #endif
 }
 /*
diff --git a/include/linux/page-flags-layout.h b/include/linux/page-flags-layout.h
index 93506a1..c17279a 100644
--- a/include/linux/page-flags-layout.h
+++ b/include/linux/page-flags-layout.h
@@ -39,9 +39,9 @@
  * lookup is necessary.
  *
  * No sparsemem or sparsemem vmemmap: |       NODE     | ZONE |          ... | FLAGS |
- *         " plus space for last_nid: |       NODE     | ZONE | LAST_NID ... | FLAGS |
+ *         " plus space for last_nid: |       NODE     | ZONE | LAST_NIDPID ... | FLAGS |
  * classic sparse with space for node:| SECTION | NODE | ZONE |          ... | FLAGS |
- *         " plus space for last_nid: | SECTION | NODE | ZONE | LAST_NID ... | FLAGS |
+ *         " plus space for last_nid: | SECTION | NODE | ZONE | LAST_NIDPID ... | FLAGS |
  * classic sparse no space for node:  | SECTION |     ZONE    | ... | FLAGS |
  */
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
@@ -61,16 +61,23 @@
 #define NODES_WIDTH		0
 #endif
 
+/* Reduce false sharing: */
+#define NIDPID_PID_BITS		8
+#define NIDPID_PID_MASK		((1 << NIDPID_PID_BITS)-1)
+
+#define NIDPID_NID_BITS		NODES_SHIFT
+#define NIDPID_NID_MASK		((1 << NIDPID_NID_BITS)-1)
+
 #ifdef CONFIG_NUMA_BALANCING
-#define LAST_NID_SHIFT NODES_SHIFT
+# define LAST_NIDPID_SHIFT	(NIDPID_NID_BITS+NIDPID_PID_BITS)
 #else
-#define LAST_NID_SHIFT 0
+# define LAST_NIDPID_SHIFT	0
 #endif
 
-#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_NID_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
-#define LAST_NID_WIDTH LAST_NID_SHIFT
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_NIDPID_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
+# define LAST_NIDPID_WIDTH	LAST_NIDPID_SHIFT
 #else
-#define LAST_NID_WIDTH 0
+# define LAST_NIDPID_WIDTH	0
 #endif
 
 /*
@@ -81,8 +88,8 @@
 #define NODE_NOT_IN_PAGE_FLAGS
 #endif
 
-#if defined(CONFIG_NUMA_BALANCING) && LAST_NID_WIDTH == 0
-#define LAST_NID_NOT_IN_PAGE_FLAGS
+#if defined(CONFIG_NUMA_BALANCING) && LAST_NIDPID_WIDTH == 0
+# define LAST_NIDPID_NOT_IN_PAGE_FLAGS
 #endif
 
 #endif /* _LINUX_PAGE_FLAGS_LAYOUT */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e2f7f5a..798297a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1639,7 +1639,7 @@ static void __split_huge_page_refcount(struct page *page)
 		page_tail->mapping = page->mapping;
 
 		page_tail->index = page->index + i;
-		page_nid_xchg_last(page_tail, page_nid_last(page));
+		page_xchg_last_nidpid(page_tail, page_last_nidpid(page));
 
 		BUG_ON(!PageAnon(page_tail));
 		BUG_ON(!PageUptodate(page_tail));
diff --git a/mm/memory.c b/mm/memory.c
index ba94dec..e819b3e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -69,8 +69,8 @@
 
 #include "internal.h"
 
-#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
-#warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_nid.
+#ifdef LAST_NIDPID_NOT_IN_PAGE_FLAGS
+#warning Unfortunate NUMA config, growing page-frame for last_nidpid.
 #endif
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 7431001..4aa64dd 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2286,11 +2286,13 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long 
 		BUG();
 	}
 
+#ifdef CONFIG_NUMA_BALANCING
 	/* Migrate the page towards the node whose CPU is referencing it */
 	if (pol->flags & MPOL_F_MORON) {
-		int last_nid;
+		int last_nidpid, this_nidpid;
 
 		polnid = numa_node_id();
+		this_nidpid = nid_pid_to_nidpid(polnid, current->pid);
 
 		/*
 		 * Multi-stage node selection is used in conjunction
@@ -2313,11 +2315,19 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long 
 		 * it less likely we act on an unlikely task<->page
 		 * relation.
 		 */
-		last_nid = page_nid_xchg_last(page, polnid);
-		if (last_nid != polnid)
-			goto out;
+		last_nidpid = page_xchg_last_nidpid(page, this_nidpid);
+		if (curnid != polnid) {
+			int last_pid = nidpid_to_pid(last_nidpid);
+			int this_pid = current->pid & NIDPID_PID_MASK;
+
+			/* Freshly allocated pages not accessed by anyone else yet: */
+			if (last_pid == this_pid || last_pid == -1 ||
+					(nidpid_to_nid(last_nidpid) == polnid))
+				ret = polnid;
+		}
+		goto out;
 	}
-
+#endif
 	if (curnid != polnid)
 		ret = polnid;
 out:
diff --git a/mm/migrate.c b/mm/migrate.c
index 3bbaf5d..74fcd76 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1478,7 +1478,7 @@ static struct page *alloc_misplaced_dst_page(struct page *page,
 					  __GFP_NOWARN) &
 					 ~GFP_IOFS, 0);
 	if (newpage)
-		page_nid_xchg_last(newpage, page_nid_last(page));
+		page_xchg_last_nidpid(newpage, page_last_nidpid(page));
 
 	return newpage;
 }
@@ -1660,7 +1660,7 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	if (!new_page)
 		goto out_fail;
 
-	page_nid_xchg_last(new_page, page_nid_last(page));
+	page_xchg_last_nidpid(new_page, page_last_nidpid(page));
 
 	isolated = numamigrate_isolate_page(pgdat, page);
 	if (!isolated) {
diff --git a/mm/mm_init.c b/mm/mm_init.c
index c280a02..0a0c0d3 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -69,26 +69,26 @@ void __init mminit_verify_pageflags_layout(void)
 	unsigned long or_mask, add_mask;
 
 	shift = 8 * sizeof(unsigned long);
-	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH - LAST_NID_SHIFT;
+	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH - LAST_NIDPID_SHIFT;
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_widths",
 		"Section %d Node %d Zone %d Lastnid %d Flags %d\n",
 		SECTIONS_WIDTH,
 		NODES_WIDTH,
 		ZONES_WIDTH,
-		LAST_NID_WIDTH,
+		LAST_NIDPID_WIDTH,
 		NR_PAGEFLAGS);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_shifts",
 		"Section %d Node %d Zone %d Lastnid %d\n",
 		SECTIONS_SHIFT,
 		NODES_SHIFT,
 		ZONES_SHIFT,
-		LAST_NID_SHIFT);
+		LAST_NIDPID_SHIFT);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_pgshifts",
 		"Section %lu Node %lu Zone %lu Lastnid %lu\n",
 		(unsigned long)SECTIONS_PGSHIFT,
 		(unsigned long)NODES_PGSHIFT,
 		(unsigned long)ZONES_PGSHIFT,
-		(unsigned long)LAST_NID_PGSHIFT);
+		(unsigned long)LAST_NIDPID_PGSHIFT);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_nodezoneid",
 		"Node/Zone ID: %lu -> %lu\n",
 		(unsigned long)(ZONEID_PGOFF + ZONEID_SHIFT),
@@ -100,7 +100,7 @@ void __init mminit_verify_pageflags_layout(void)
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_nodeflags",
 		"Node not in page flags");
 #endif
-#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
+#ifdef LAST_NIDPID_NOT_IN_PAGE_FLAGS
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_nodeflags",
 		"Last nid not in page flags");
 #endif
diff --git a/mm/mmzone.c b/mm/mmzone.c
index 2ac0afb..a9958a1 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -97,20 +97,20 @@ void lruvec_init(struct lruvec *lruvec)
 		INIT_LIST_HEAD(&lruvec->lists[lru]);
 }
 
-#if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_NID_NOT_IN_PAGE_FLAGS)
-int page_nid_xchg_last(struct page *page, int nid)
+#if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_NIDPID_NOT_IN_PAGE_FLAGS)
+extern int page_xchg_last_nidpid(struct page *page, int nidpid)
 {
 	unsigned long old_flags, flags;
-	int last_nid;
+	int last_nidpid;
 
 	do {
 		old_flags = flags = page->flags;
-		last_nid = page_nid_last(page);
+		last_nidpid = (flags >> LAST_NIDPID_PGSHIFT) & LAST_NIDPID_MASK;
 
-		flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
-		flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
+		flags &= ~(LAST_NIDPID_MASK << LAST_NIDPID_PGSHIFT);
+		flags |= (nidpid & LAST_NIDPID_MASK) << LAST_NIDPID_PGSHIFT;
 	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
 
-	return last_nid;
+	return last_nidpid;
 }
 #endif
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8fcced7..d4d0540 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -613,7 +613,7 @@ static inline int free_pages_check(struct page *page)
 		bad_page(page);
 		return 1;
 	}
-	page_nid_reset_last(page);
+	reset_page_last_nidpid(page);
 	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
 		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	return 0;
@@ -3910,7 +3910,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		mminit_verify_page_links(page, zone, nid, pfn);
 		init_page_count(page);
 		page_mapcount_reset(page);
-		page_nid_reset_last(page);
+		reset_page_last_nidpid(page);
 		SetPageReserved(page);
 		/*
 		 * Mark the block movable so that blocks are reserved for
-- 
1.7.1


-- 
Thanks and Regards
Srikar Dronamraju

