Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaB0Pzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:55:41 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:43536 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaB0Pzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:55:40 -0500
X-IronPort-AV: E=Sophos;i="4.97,555,1389744000"; 
   d="scan'208";a="104687664"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Matt Wilson <msw@linux.com>,
        Anthony Liguori <aliguori@amazon.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH] xen/grant-table: Refactor gnttab_[un]map_refs to avoid m2p_override
Date: Thu, 27 Feb 2014 15:55:30 +0000
Message-ID: <1393516530-9145-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is a continuation of "[PATCH v9] xen/grant-table: Avoid m2p_override
during mapping")

The grant mapping API does m2p_override unnecessarily: only gntdev needs it,
for blkback and future netback patches it just cause a lock contention, as
those pages never go to userspace. Therefore this series does the following:
- the bulk of the original function (everything after the mapping hypercall)
  is moved to arch-dependent set/clear_foreign_p2m_mapping
- the "if (xen_feature(XENFEAT_auto_translated_physmap))" brach goes to ARM
- therefore the ARM function could be much smaller, the m2p_override stubs
  could be also removed
- on x86 the set_phys_to_machine calls were moved up to this new funcion
  from m2p_override functions
- and m2p_override functions are only called when there is a kmap_ops param

It also removes a stray space from arch/x86/include/asm/xen/page.h.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Suggested-by: Anthony Liguori <aliguori@amazon.com>
Suggested-by: David Vrabel <david.vrabel@citrix.com>
Suggested-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/xen/page.h |   15 ++---
 arch/arm/xen/p2m.c              |   32 +++++++++++
 arch/x86/include/asm/xen/page.h |   11 +++-
 arch/x86/xen/p2m.c              |  121 ++++++++++++++++++++++++++++++++++-----
 drivers/xen/grant-table.c       |   73 +----------------------
 5 files changed, 156 insertions(+), 96 deletions(-)

diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index e0965ab..cf4f3e8 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -97,16 +97,13 @@ static inline pte_t *lookup_address(unsigned long address, unsigned int *level)
 	return NULL;
 }
 
-static inline int m2p_add_override(unsigned long mfn, struct page *page,
-		struct gnttab_map_grant_ref *kmap_op)
-{
-	return 0;
-}
+extern int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
+				   struct gnttab_map_grant_ref *kmap_ops,
+				   struct page **pages, unsigned int count);
 
-static inline int m2p_remove_override(struct page *page, bool clear_pte)
-{
-	return 0;
-}
+extern int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
+				     struct gnttab_map_grant_ref *kmap_ops,
+				     struct page **pages, unsigned int count);
 
 bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 bool __set_phys_to_machine_multi(unsigned long pfn, unsigned long mfn,
diff --git a/arch/arm/xen/p2m.c b/arch/arm/xen/p2m.c
index b31ee1b2..9c48778 100644
--- a/arch/arm/xen/p2m.c
+++ b/arch/arm/xen/p2m.c
@@ -146,6 +146,38 @@ unsigned long __mfn_to_pfn(unsigned long mfn)
 }
 EXPORT_SYMBOL_GPL(__mfn_to_pfn);
 
+int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
+			    struct gnttab_map_grant_ref *kmap_ops,
+			    struct page **pages, unsigned int count);
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		if (map_ops[i].status)
+			continue;
+		set_phys_to_machine(map_ops[i].host_addr >> PAGE_SHIFT,
+				    map_ops[i].dev_bus_addr >> PAGE_SHIFT);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(set_foreign_p2m_mapping);
+
+int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
+			      struct gnttab_map_grant_ref *kmap_ops,
+			      struct page **pages, unsigned int count);
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		set_phys_to_machine(unmap_ops[i].host_addr >> PAGE_SHIFT,
+				    INVALID_P2M_ENTRY);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(clear_foreign_p2m_mapping);
+
 bool __set_phys_to_machine_multi(unsigned long pfn,
 		unsigned long mfn, unsigned long nr_pages)
 {
diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 3e276eb..c949923 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -49,10 +49,17 @@ extern bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 extern unsigned long set_phys_range_identity(unsigned long pfn_s,
 					     unsigned long pfn_e);
 
+extern int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
+				   struct gnttab_map_grant_ref *kmap_ops,
+				   struct page **pages, unsigned int count);
 extern int m2p_add_override(unsigned long mfn, struct page *page,
 			    struct gnttab_map_grant_ref *kmap_op);
+extern int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
+				     struct gnttab_map_grant_ref *kmap_ops,
+				     struct page **pages, unsigned int count);
 extern int m2p_remove_override(struct page *page,
-				struct gnttab_map_grant_ref *kmap_op);
+			       struct gnttab_map_grant_ref *kmap_op,
+			       unsigned long mfn);
 extern struct page *m2p_find_override(unsigned long mfn);
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
 
@@ -121,7 +128,7 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 		pfn = m2p_find_override_pfn(mfn, ~0);
 	}
 
-	/* 
+	/*
 	 * pfn is ~0 if there are no entries in the m2p for mfn or if the
 	 * entry doesn't map back to the mfn and m2p_override doesn't have a
 	 * valid entry for it.
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 696c694..85e5d78 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -881,6 +881,65 @@ static unsigned long mfn_hash(unsigned long mfn)
 	return hash_long(mfn, M2P_OVERRIDE_HASH_SHIFT);
 }
 
+int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
+			    struct gnttab_map_grant_ref *kmap_ops,
+			    struct page **pages, unsigned int count)
+{
+	int i, ret = 0;
+	bool lazy = false;
+	pte_t *pte;
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return 0;
+
+	if (kmap_ops &&
+	    !in_interrupt() &&
+	    paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
+		arch_enter_lazy_mmu_mode();
+		lazy = true;
+	}
+
+	for (i = 0; i < count; i++) {
+		unsigned long mfn, pfn;
+
+		/* Do not add to override if the map failed. */
+		if (map_ops[i].status)
+			continue;
+
+		if (map_ops[i].flags & GNTMAP_contains_pte) {
+			pte = (pte_t *) (mfn_to_virt(PFN_DOWN(map_ops[i].host_addr)) +
+				(map_ops[i].host_addr & ~PAGE_MASK));
+			mfn = pte_mfn(*pte);
+		} else {
+			mfn = PFN_DOWN(map_ops[i].dev_bus_addr);
+		}
+		pfn = page_to_pfn(pages[i]);
+
+		WARN_ON(PagePrivate(pages[i]));
+		SetPagePrivate(pages[i]);
+		set_page_private(pages[i], mfn);
+		pages[i]->index = pfn_to_mfn(pfn);
+
+		if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn)))) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		if (kmap_ops) {
+			ret = m2p_add_override(mfn, pages[i], &kmap_ops[i]);
+			if (ret)
+				goto out;
+		}
+	}
+
+out:
+	if (lazy)
+		arch_leave_lazy_mmu_mode();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(set_foreign_p2m_mapping);
+
 /* Add an MFN override for a particular page */
 int m2p_add_override(unsigned long mfn, struct page *page,
 		struct gnttab_map_grant_ref *kmap_op)
@@ -899,13 +958,6 @@ int m2p_add_override(unsigned long mfn, struct page *page,
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
@@ -943,20 +995,62 @@ int m2p_add_override(unsigned long mfn, struct page *page,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(m2p_add_override);
+
+int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
+			      struct gnttab_map_grant_ref *kmap_ops,
+			      struct page **pages, unsigned int count)
+{
+	int i, ret = 0;
+	bool lazy = false;
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return 0;
+
+	if (kmap_ops &&
+	    !in_interrupt() &&
+	    paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
+		arch_enter_lazy_mmu_mode();
+		lazy = true;
+	}
+
+	for (i = 0; i < count; i++) {
+		unsigned long mfn = get_phys_to_machine(page_to_pfn(pages[i]));
+		unsigned long pfn = page_to_pfn(pages[i]);
+
+		if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		set_page_private(pages[i], INVALID_P2M_ENTRY);
+		WARN_ON(!PagePrivate(pages[i]));
+		ClearPagePrivate(pages[i]);
+		set_phys_to_machine(pfn, pages[i]->index);
+
+		if (kmap_ops)
+			ret = m2p_remove_override(pages[i], &kmap_ops[i], mfn);
+		if (ret)
+			goto out;
+	}
+
+out:
+	if (lazy)
+		arch_leave_lazy_mmu_mode();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clear_foreign_p2m_mapping);
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
@@ -970,10 +1064,7 @@ int m2p_remove_override(struct page *page,
 	spin_lock_irqsave(&m2p_override_lock, flags);
 	list_del(&page->lru);
 	spin_unlock_irqrestore(&m2p_override_lock, flags);
-	WARN_ON(!PagePrivate(page));
-	ClearPagePrivate(page);
 
-	set_phys_to_machine(pfn, page->index);
 	if (kmap_op != NULL) {
 		if (!PageHighMem(page)) {
 			struct multicall_space mcs;
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index b84e3ab..6d325bd 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -933,9 +933,6 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		    struct page **pages, unsigned int count)
 {
 	int i, ret;
-	bool lazy = false;
-	pte_t *pte;
-	unsigned long mfn;
 
 	ret = HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, map_ops, count);
 	if (ret)
@@ -947,45 +944,7 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 			gnttab_retry_eagain_gop(GNTTABOP_map_grant_ref, map_ops + i,
 						&map_ops[i].status, __func__);
 
-	/* this is basically a nop on x86 */
-	if (xen_feature(XENFEAT_auto_translated_physmap)) {
-		for (i = 0; i < count; i++) {
-			if (map_ops[i].status)
-				continue;
-			set_phys_to_machine(map_ops[i].host_addr >> PAGE_SHIFT,
-					map_ops[i].dev_bus_addr >> PAGE_SHIFT);
-		}
-		return ret;
-	}
-
-	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
-		arch_enter_lazy_mmu_mode();
-		lazy = true;
-	}
-
-	for (i = 0; i < count; i++) {
-		/* Do not add to override if the map failed. */
-		if (map_ops[i].status)
-			continue;
-
-		if (map_ops[i].flags & GNTMAP_contains_pte) {
-			pte = (pte_t *) (mfn_to_virt(PFN_DOWN(map_ops[i].host_addr)) +
-				(map_ops[i].host_addr & ~PAGE_MASK));
-			mfn = pte_mfn(*pte);
-		} else {
-			mfn = PFN_DOWN(map_ops[i].dev_bus_addr);
-		}
-		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
-				       &kmap_ops[i] : NULL);
-		if (ret)
-			goto out;
-	}
-
- out:
-	if (lazy)
-		arch_leave_lazy_mmu_mode();
-
-	return ret;
+	return set_foreign_p2m_mapping(map_ops, kmap_ops, pages, count);
 }
 EXPORT_SYMBOL_GPL(gnttab_map_refs);
 
@@ -993,39 +952,13 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 		      struct gnttab_map_grant_ref *kmap_ops,
 		      struct page **pages, unsigned int count)
 {
-	int i, ret;
-	bool lazy = false;
+	int ret;
 
 	ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap_ops, count);
 	if (ret)
 		return ret;
 
-	/* this is basically a nop on x86 */
-	if (xen_feature(XENFEAT_auto_translated_physmap)) {
-		for (i = 0; i < count; i++) {
-			set_phys_to_machine(unmap_ops[i].host_addr >> PAGE_SHIFT,
-					INVALID_P2M_ENTRY);
-		}
-		return ret;
-	}
-
-	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
-		arch_enter_lazy_mmu_mode();
-		lazy = true;
-	}
-
-	for (i = 0; i < count; i++) {
-		ret = m2p_remove_override(pages[i], kmap_ops ?
-				       &kmap_ops[i] : NULL);
-		if (ret)
-			goto out;
-	}
-
- out:
-	if (lazy)
-		arch_leave_lazy_mmu_mode();
-
-	return ret;
+	return clear_foreign_p2m_mapping(unmap_ops, kmap_ops, pages, count);
 }
 EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
 
