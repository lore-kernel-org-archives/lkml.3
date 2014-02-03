Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaBCNZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 08:25:11 -0500
Received: from smtp.citrix.com ([66.165.176.89]:55703 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbaBCNZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 08:25:09 -0500
X-IronPort-AV: E=Sophos;i="4.95,772,1384300800"; 
   d="scan'208";a="99198402"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        <stefano.stabellini@eu.citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH v7] xen/grant-table: Avoid m2p_override during mapping
Date: Mon, 3 Feb 2014 13:24:58 +0000
Message-ID: <1391433898-10533-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The grant mapping API does m2p_override unnecessarily: only gntdev needs it,
for blkback and future netback patches it just cause a lock contention, as
those pages never go to userspace. Therefore this series does the following:
- the original functions were renamed to __gnttab_[un]map_refs, with a new
  parameter m2p_override
- based on m2p_override either they follow the original behaviour, or just set
  the private flag and call set_phys_to_machine
- gnttab_[un]map_refs are now a wrapper to call __gnttab_[un]map_refs with
  m2p_override false
- a new function gnttab_[un]map_refs_userspace provides the old behaviour

It also removes a stray space from page.h and change ret to 0 if
XENFEAT_auto_translated_physmap, as that is the only possible return value
there.

v2:
- move the storing of the old mfn in page->index to gnttab_map_refs
- move the function header update to a separate patch

v3:
- a new approach to retain old behaviour where it needed
- squash the patches into one

v4:
- move out the common bits from m2p* functions, and pass pfn/mfn as parameter
- clear page->private before doing anything with the page, so m2p_find_override
  won't race with this

v5:
- change return value handling in __gnttab_[un]map_refs
- remove a stray space in page.h
- add detail why ret = 0 now at some places

v6:
- don't pass pfn to m2p* functions, just get it locally

v7:
- the previous version broke build on ARM, as there is no need for those p2m
  changes. I've put them into arch specific functions, which are stubs on arm

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Suggested-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/arm/include/asm/xen/page.h     |   15 ++++++-
 arch/x86/include/asm/xen/page.h     |    7 +++-
 arch/x86/xen/p2m.c                  |   49 ++++++++++++++++-------
 drivers/block/xen-blkback/blkback.c |   15 +++----
 drivers/xen/gntdev.c                |   13 +++---
 drivers/xen/grant-table.c           |   75 +++++++++++++++++++++++++++++------
 include/xen/grant_table.h           |    8 +++-
 7 files changed, 136 insertions(+), 46 deletions(-)

diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index 3759cac..97fa5f9 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -97,13 +97,26 @@ static inline pte_t *lookup_address(unsigned long address, unsigned int *level)
 	return NULL;
 }
 
+static inline int set_foreign_p2m_mapping(struct page *page, unsigned long mfn)
+{
+	return 0;
+}
+
 static inline int m2p_add_override(unsigned long mfn, struct page *page,
 		struct gnttab_map_grant_ref *kmap_op)
 {
 	return 0;
 }
 
-static inline int m2p_remove_override(struct page *page, bool clear_pte)
+static inline int restore_foreign_p2m_mapping(struct page *page,
+					      unsigned long mfn)
+{
+	return 0;
+}
+
+static inline int m2p_remove_override(struct page *page,
+				      struct gnttab_map_grant_ref *kmap_op,
+				      unsigned long mfn)
 {
 	return 0;
 }
diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index b913915..e3fa4b8 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -49,10 +49,13 @@ extern bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 extern unsigned long set_phys_range_identity(unsigned long pfn_s,
 					     unsigned long pfn_e);
 
+extern int set_foreign_p2m_mapping(struct page *page, unsigned long mfn);
 extern int m2p_add_override(unsigned long mfn, struct page *page,
 			    struct gnttab_map_grant_ref *kmap_op);
+extern int restore_foreign_p2m_mapping(struct page *page, unsigned long mfn);
 extern int m2p_remove_override(struct page *page,
-				struct gnttab_map_grant_ref *kmap_op);
+			       struct gnttab_map_grant_ref *kmap_op,
+			       unsigned long mfn);
 extern struct page *m2p_find_override(unsigned long mfn);
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
 
@@ -121,7 +124,7 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 		pfn = m2p_find_override_pfn(mfn, ~0);
 	}
 
-	/* 
+	/*
 	 * pfn is ~0 if there are no entries in the m2p for mfn or if the
 	 * entry doesn't map back to the mfn and m2p_override doesn't have a
 	 * valid entry for it.
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 2ae8699..524ace6 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -870,6 +870,22 @@ static unsigned long mfn_hash(unsigned long mfn)
 	return hash_long(mfn, M2P_OVERRIDE_HASH_SHIFT);
 }
 
+int set_foreign_p2m_mapping(struct page *page, unsigned long mfn)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	WARN_ON(PagePrivate(page));
+	SetPagePrivate(page);
+	set_page_private(page, mfn);
+
+	page->index = pfn_to_mfn(pfn);
+	if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))))
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(set_foreign_p2m_mapping);
+
 /* Add an MFN override for a particular page */
 int m2p_add_override(unsigned long mfn, struct page *page,
 		struct gnttab_map_grant_ref *kmap_op)
@@ -888,13 +904,6 @@ int m2p_add_override(unsigned long mfn, struct page *page,
 					"m2p_add_override: pfn %lx not mapped", pfn))
 			return -EINVAL;
 	}
-	WARN_ON(PagePrivate(page));
-	SetPagePrivate(page);
-	set_page_private(page, mfn);
-	page->index = pfn_to_mfn(pfn);
-
-	if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))))
-		return -ENOMEM;
 
 	if (kmap_op != NULL) {
 		if (!PageHighMem(page)) {
@@ -932,20 +941,33 @@ int m2p_add_override(unsigned long mfn, struct page *page,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(m2p_add_override);
+
+int restore_foreign_p2m_mapping(struct page *page, unsigned long mfn)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT))
+		return -EINVAL;
+
+	set_page_private(page, INVALID_P2M_ENTRY);
+	WARN_ON(!PagePrivate(page));
+	ClearPagePrivate(page);
+	set_phys_to_machine(pfn, page->index);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(restore_foreign_p2m_mapping);
+
 int m2p_remove_override(struct page *page,
-		struct gnttab_map_grant_ref *kmap_op)
+			struct gnttab_map_grant_ref *kmap_op,
+			unsigned long mfn)
 {
 	unsigned long flags;
-	unsigned long mfn;
 	unsigned long pfn;
 	unsigned long uninitialized_var(address);
 	unsigned level;
 	pte_t *ptep = NULL;
 
 	pfn = page_to_pfn(page);
-	mfn = get_phys_to_machine(pfn);
-	if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT))
-		return -EINVAL;
 
 	if (!PageHighMem(page)) {
 		address = (unsigned long)__va(pfn << PAGE_SHIFT);
@@ -959,10 +981,7 @@ int m2p_remove_override(struct page *page,
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_del(&page->lru);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
-	WARN_ON(!PagePrivate(page));
-	ClearPagePrivate(page);
 
-	set_phys_to_machine(pfn, page->index);
 	if (kmap_op != NULL) {
 		if (!PageHighMem(page)) {
 			struct multicall_space mcs;
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 6620b73..875025f 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -285,8 +285,7 @@ static void free_persistent_gnts(struct xen_blkif *blkif, struct rb_root *root,
 
 		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST ||
 			!rb_next(&persistent_gnt->node)) {
-			ret = gnttab_unmap_refs(unmap, NULL, pages,
-				segs_to_unmap);
+			ret = gnttab_unmap_refs(unmap, pages, segs_to_unmap);
 			BUG_ON(ret);
 			put_free_pages(blkif, pages, segs_to_unmap);
 			segs_to_unmap = 0;
@@ -321,8 +320,7 @@ static void unmap_purged_grants(struct work_struct *work)
 		pages[segs_to_unmap] = persistent_gnt->page;
 
 		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
-			ret = gnttab_unmap_refs(unmap, NULL, pages,
-				segs_to_unmap);
+			ret = gnttab_unmap_refs(unmap, pages, segs_to_unmap);
 			BUG_ON(ret);
 			put_free_pages(blkif, pages, segs_to_unmap);
 			segs_to_unmap = 0;
@@ -330,7 +328,7 @@ static void unmap_purged_grants(struct work_struct *work)
 		kfree(persistent_gnt);
 	}
 	if (segs_to_unmap > 0) {
-		ret = gnttab_unmap_refs(unmap, NULL, pages, segs_to_unmap);
+		ret = gnttab_unmap_refs(unmap, pages, segs_to_unmap);
 		BUG_ON(ret);
 		put_free_pages(blkif, pages, segs_to_unmap);
 	}
@@ -670,15 +668,14 @@ static void xen_blkbk_unmap(struct xen_blkif *blkif,
 				    GNTMAP_host_map, pages[i]->handle);
 		pages[i]->handle = BLKBACK_INVALID_HANDLE;
 		if (++invcount == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
-			ret = gnttab_unmap_refs(unmap, NULL, unmap_pages,
-			                        invcount);
+			ret = gnttab_unmap_refs(unmap, unmap_pages, invcount);
 			BUG_ON(ret);
 			put_free_pages(blkif, unmap_pages, invcount);
 			invcount = 0;
 		}
 	}
 	if (invcount) {
-		ret = gnttab_unmap_refs(unmap, NULL, unmap_pages, invcount);
+		ret = gnttab_unmap_refs(unmap, unmap_pages, invcount);
 		BUG_ON(ret);
 		put_free_pages(blkif, unmap_pages, invcount);
 	}
@@ -740,7 +737,7 @@ again:
 	}
 
 	if (segs_to_map) {
-		ret = gnttab_map_refs(map, NULL, pages_to_gnt, segs_to_map);
+		ret = gnttab_map_refs(map, pages_to_gnt, segs_to_map);
 		BUG_ON(ret);
 	}
 
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index e41c79c..e652c0e 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -284,8 +284,10 @@ static int map_grant_pages(struct grant_map *map)
 	}
 
 	pr_debug("map %d+%d\n", map->index, map->count);
-	err = gnttab_map_refs(map->map_ops, use_ptemod ? map->kmap_ops : NULL,
-			map->pages, map->count);
+	err = gnttab_map_refs_userspace(map->map_ops,
+					use_ptemod ? map->kmap_ops : NULL,
+					map->pages,
+					map->count);
 	if (err)
 		return err;
 
@@ -315,9 +317,10 @@ static int __unmap_grant_pages(struct grant_map *map, int offset, int pages)
 		}
 	}
 
-	err = gnttab_unmap_refs(map->unmap_ops + offset,
-			use_ptemod ? map->kmap_ops + offset : NULL, map->pages + offset,
-			pages);
+	err = gnttab_unmap_refs_userspace(map->unmap_ops + offset,
+					  use_ptemod ? map->kmap_ops + offset : NULL,
+					  map->pages + offset,
+					  pages);
 	if (err)
 		return err;
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index aa846a4..9a0be47 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -880,15 +880,17 @@ void gnttab_batch_copy(struct gnttab_copy *batch, unsigned count)
 }
 EXPORT_SYMBOL_GPL(gnttab_batch_copy);
 
-int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
+int __gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		    struct gnttab_map_grant_ref *kmap_ops,
-		    struct page **pages, unsigned int count)
+		    struct page **pages, unsigned int count,
+		    bool m2p_override)
 {
 	int i, ret;
 	bool lazy = false;
 	pte_t *pte;
 	unsigned long mfn;
 
+	BUG_ON(kmap_ops && !m2p_override);
 	ret = HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, map_ops, count);
 	if (ret)
 		return ret;
@@ -907,10 +909,12 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 			set_phys_to_machine(map_ops[i].host_addr >> PAGE_SHIFT,
 					map_ops[i].dev_bus_addr >> PAGE_SHIFT);
 		}
-		return ret;
+		return 0;
 	}
 
-	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
+	if (m2p_override &&
+	    !in_interrupt() &&
+	    paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
 		arch_enter_lazy_mmu_mode();
 		lazy = true;
 	}
@@ -927,8 +931,14 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		} else {
 			mfn = PFN_DOWN(map_ops[i].dev_bus_addr);
 		}
-		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
-				       &kmap_ops[i] : NULL);
+
+		ret = set_foreign_p2m_mapping(pages[i], mfn);
+		if (ret)
+			goto out;
+
+		if (m2p_override)
+			ret = m2p_add_override(mfn, pages[i], kmap_ops ?
+					       &kmap_ops[i] : NULL);
 		if (ret)
 			goto out;
 	}
@@ -939,15 +949,32 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 
 	return ret;
 }
+
+int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
+		    struct page **pages, unsigned int count)
+{
+	return __gnttab_map_refs(map_ops, NULL, pages, count, false);
+}
 EXPORT_SYMBOL_GPL(gnttab_map_refs);
 
-int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
+int gnttab_map_refs_userspace(struct gnttab_map_grant_ref *map_ops,
+			      struct gnttab_map_grant_ref *kmap_ops,
+			      struct page **pages, unsigned int count)
+{
+	return __gnttab_map_refs(map_ops, kmap_ops, pages, count, true);
+}
+EXPORT_SYMBOL_GPL(gnttab_map_refs_userspace);
+
+int __gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 		      struct gnttab_map_grant_ref *kmap_ops,
-		      struct page **pages, unsigned int count)
+		      struct page **pages, unsigned int count,
+		      bool m2p_override)
 {
 	int i, ret;
 	bool lazy = false;
+	unsigned long mfn;
 
+	BUG_ON(kmap_ops && !m2p_override);
 	ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap_ops, count);
 	if (ret)
 		return ret;
@@ -958,17 +985,27 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 			set_phys_to_machine(unmap_ops[i].host_addr >> PAGE_SHIFT,
 					INVALID_P2M_ENTRY);
 		}
-		return ret;
+		return 0;
 	}
 
-	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
+	if (m2p_override &&
+	    !in_interrupt() &&
+	    paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
 		arch_enter_lazy_mmu_mode();
 		lazy = true;
 	}
 
 	for (i = 0; i < count; i++) {
-		ret = m2p_remove_override(pages[i], kmap_ops ?
-				       &kmap_ops[i] : NULL);
+		mfn = get_phys_to_machine(page_to_pfn(pages[i]));
+		ret = restore_foreign_p2m_mapping(pages[i], mfn);
+		if (ret)
+			goto out;
+
+		if (m2p_override)
+			ret = m2p_remove_override(pages[i],
+						  kmap_ops ?
+						   &kmap_ops[i] : NULL,
+						  mfn);
 		if (ret)
 			goto out;
 	}
@@ -979,8 +1016,22 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 
 	return ret;
 }
+
+int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *map_ops,
+		    struct page **pages, unsigned int count)
+{
+	return __gnttab_unmap_refs(map_ops, NULL, pages, count, false);
+}
 EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
 
+int gnttab_unmap_refs_userspace(struct gnttab_unmap_grant_ref *map_ops,
+				struct gnttab_map_grant_ref *kmap_ops,
+				struct page **pages, unsigned int count)
+{
+	return __gnttab_unmap_refs(map_ops, kmap_ops, pages, count, true);
+}
+EXPORT_SYMBOL_GPL(gnttab_unmap_refs_userspace);
+
 static unsigned nr_status_frames(unsigned nr_grant_frames)
 {
 	BUG_ON(grefs_per_grant_frame == 0);
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 694dcaf..9a919b1 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -184,11 +184,15 @@ unsigned int gnttab_max_grant_frames(void);
 #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
 
 int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
-		    struct gnttab_map_grant_ref *kmap_ops,
 		    struct page **pages, unsigned int count);
+int gnttab_map_refs_userspace(struct gnttab_map_grant_ref *map_ops,
+			      struct gnttab_map_grant_ref *kmap_ops,
+			      struct page **pages, unsigned int count);
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
-		      struct gnttab_map_grant_ref *kunmap_ops,
 		      struct page **pages, unsigned int count);
+int gnttab_unmap_refs_userspace(struct gnttab_unmap_grant_ref *unmap_ops,
+				struct gnttab_map_grant_ref *kunmap_ops,
+				struct page **pages, unsigned int count);
 
 /* Perform a batch of grant map/copy operations. Retry every batch slot
  * for which the hypervisor returns GNTST_eagain. This is typically due
