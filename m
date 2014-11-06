Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaKFFrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:47:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaKFFrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:47:41 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V2 2/5] xen: Delay m2p_override initialization
Date: Thu,  6 Nov 2014 06:47:30 +0100
Message-Id: <1415252853-7106-3-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1415252853-7106-1-git-send-email-jgross@suse.com>
References: <1415252853-7106-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The m2p overrides are used to be able to find the local pfn for a
foreign mfn mapped into the domain. They are used by driver backends
having to access frontend data.

As this functionality isn't used in early boot it makes no sense to
initialize the m2p override functions very early. It can be done
later without doing any harm, removing the need for allocating memory
via extend_brk().

While at it make some m2p override functions static as they are only
used internally.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/xen/page.h |   6 --
 arch/x86/xen/p2m.c              | 198 ++++++++++++++++++++--------------------
 2 files changed, 101 insertions(+), 103 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index c29619c..b475297 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -51,15 +51,9 @@ extern unsigned long set_phys_range_identity(unsigned long pfn_s,
 extern int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 				   struct gnttab_map_grant_ref *kmap_ops,
 				   struct page **pages, unsigned int count);
-extern int m2p_add_override(unsigned long mfn, struct page *page,
-			    struct gnttab_map_grant_ref *kmap_op);
 extern int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
 				     struct gnttab_map_grant_ref *kmap_ops,
 				     struct page **pages, unsigned int count);
-extern int m2p_remove_override(struct page *page,
-			       struct gnttab_map_grant_ref *kmap_op,
-			       unsigned long mfn);
-extern struct page *m2p_find_override(unsigned long mfn);
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
 
 static inline unsigned long pfn_to_mfn(unsigned long pfn)
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 49316ac..2647a65 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -426,8 +426,6 @@ void __init xen_build_dynamic_phys_to_machine(void)
 		}
 		p2m_top[topidx][mididx] = &mfn_list[pfn];
 	}
-
-	m2p_override_init();
 }
 #ifdef CONFIG_X86_64
 unsigned long __init xen_revector_p2m_tree(void)
@@ -498,13 +496,15 @@ unsigned long __init xen_revector_p2m_tree(void)
 		}
 		/* This should be the leafs allocated for identity from _brk. */
 	}
-	return (unsigned long)mfn_list;
 
+	m2p_override_init();
+	return (unsigned long)mfn_list;
 }
 #else
 unsigned long __init xen_revector_p2m_tree(void)
 {
 	use_brk = 0;
+	m2p_override_init();
 	return 0;
 }
 #endif
@@ -794,15 +794,16 @@ bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 #define M2P_OVERRIDE_HASH_SHIFT	10
 #define M2P_OVERRIDE_HASH	(1 << M2P_OVERRIDE_HASH_SHIFT)
 
-static RESERVE_BRK_ARRAY(struct list_head, m2p_overrides, M2P_OVERRIDE_HASH);
+static struct list_head *m2p_overrides;
 static DEFINE_SPINLOCK(m2p_override_lock);
 
 static void __init m2p_override_init(void)
 {
 	unsigned i;
 
-	m2p_overrides = extend_brk(sizeof(*m2p_overrides) * M2P_OVERRIDE_HASH,
-				   sizeof(unsigned long));
+	m2p_overrides = alloc_bootmem_align(
+				sizeof(*m2p_overrides) * M2P_OVERRIDE_HASH,
+				sizeof(unsigned long));
 
 	for (i = 0; i < M2P_OVERRIDE_HASH; i++)
 		INIT_LIST_HEAD(&m2p_overrides[i]);
@@ -813,67 +814,8 @@ static unsigned long mfn_hash(unsigned long mfn)
 	return hash_long(mfn, M2P_OVERRIDE_HASH_SHIFT);
 }
 
-int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
-			    struct gnttab_map_grant_ref *kmap_ops,
-			    struct page **pages, unsigned int count)
-{
-	int i, ret = 0;
-	bool lazy = false;
-	pte_t *pte;
-
-	if (xen_feature(XENFEAT_auto_translated_physmap))
-		return 0;
-
-	if (kmap_ops &&
-	    !in_interrupt() &&
-	    paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
-		arch_enter_lazy_mmu_mode();
-		lazy = true;
-	}
-
-	for (i = 0; i < count; i++) {
-		unsigned long mfn, pfn;
-
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
-		pfn = page_to_pfn(pages[i]);
-
-		WARN_ON(PagePrivate(pages[i]));
-		SetPagePrivate(pages[i]);
-		set_page_private(pages[i], mfn);
-		pages[i]->index = pfn_to_mfn(pfn);
-
-		if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn)))) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		if (kmap_ops) {
-			ret = m2p_add_override(mfn, pages[i], &kmap_ops[i]);
-			if (ret)
-				goto out;
-		}
-	}
-
-out:
-	if (lazy)
-		arch_leave_lazy_mmu_mode();
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(set_foreign_p2m_mapping);
-
 /* Add an MFN override for a particular page */
-int m2p_add_override(unsigned long mfn, struct page *page,
+static int m2p_add_override(unsigned long mfn, struct page *page,
 		struct gnttab_map_grant_ref *kmap_op)
 {
 	unsigned long flags;
@@ -926,14 +868,14 @@ int m2p_add_override(unsigned long mfn, struct page *page,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(m2p_add_override);
 
-int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
-			      struct gnttab_map_grant_ref *kmap_ops,
-			      struct page **pages, unsigned int count)
+int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
+			    struct gnttab_map_grant_ref *kmap_ops,
+			    struct page **pages, unsigned int count)
 {
 	int i, ret = 0;
 	bool lazy = false;
+	pte_t *pte;
 
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return 0;
@@ -946,33 +888,74 @@ int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
 	}
 
 	for (i = 0; i < count; i++) {
-		unsigned long mfn = get_phys_to_machine(page_to_pfn(pages[i]));
-		unsigned long pfn = page_to_pfn(pages[i]);
+		unsigned long mfn, pfn;
 
-		if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT)) {
-			ret = -EINVAL;
-			goto out;
+		/* Do not add to override if the map failed. */
+		if (map_ops[i].status)
+			continue;
+
+		if (map_ops[i].flags & GNTMAP_contains_pte) {
+			mfn = PFN_DOWN(map_ops[i].host_addr);
+			pte = (pte_t *)(mfn_to_virt(mfn) +
+				(map_ops[i].host_addr & ~PAGE_MASK));
+			mfn = pte_mfn(*pte);
+		} else {
+			mfn = PFN_DOWN(map_ops[i].dev_bus_addr);
 		}
+		pfn = page_to_pfn(pages[i]);
 
-		set_page_private(pages[i], INVALID_P2M_ENTRY);
-		WARN_ON(!PagePrivate(pages[i]));
-		ClearPagePrivate(pages[i]);
-		set_phys_to_machine(pfn, pages[i]->index);
+		WARN_ON(PagePrivate(pages[i]));
+		SetPagePrivate(pages[i]);
+		set_page_private(pages[i], mfn);
+		pages[i]->index = pfn_to_mfn(pfn);
 
-		if (kmap_ops)
-			ret = m2p_remove_override(pages[i], &kmap_ops[i], mfn);
-		if (ret)
+		if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn)))) {
+			ret = -ENOMEM;
 			goto out;
+		}
+
+		if (kmap_ops) {
+			ret = m2p_add_override(mfn, pages[i], &kmap_ops[i]);
+			if (ret)
+				goto out;
+		}
 	}
 
 out:
 	if (lazy)
 		arch_leave_lazy_mmu_mode();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(set_foreign_p2m_mapping);
+
+static struct page *m2p_find_override(unsigned long mfn)
+{
+	unsigned long flags;
+	struct list_head *bucket;
+	struct page *p, *ret;
+
+	ret = NULL;
+
+	if (m2p_overrides) {
+		bucket = &m2p_overrides[mfn_hash(mfn)];
+
+		spin_lock_irqsave(&m2p_override_lock, flags);
+
+		list_for_each_entry(p, bucket, lru) {
+			if (page_private(p) == mfn) {
+				ret = p;
+				break;
+			}
+		}
+
+		spin_unlock_irqrestore(&m2p_override_lock, flags);
+	}
+
 	return ret;
 }
-EXPORT_SYMBOL_GPL(clear_foreign_p2m_mapping);
 
-int m2p_remove_override(struct page *page,
+static int m2p_remove_override(struct page *page,
 			struct gnttab_map_grant_ref *kmap_op,
 			unsigned long mfn)
 {
@@ -1068,29 +1051,50 @@ int m2p_remove_override(struct page *page,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(m2p_remove_override);
 
-struct page *m2p_find_override(unsigned long mfn)
+int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
+			      struct gnttab_map_grant_ref *kmap_ops,
+			      struct page **pages, unsigned int count)
 {
-	unsigned long flags;
-	struct list_head *bucket = &m2p_overrides[mfn_hash(mfn)];
-	struct page *p, *ret;
+	int i, ret = 0;
+	bool lazy = false;
 
-	ret = NULL;
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return 0;
 
-	spin_lock_irqsave(&m2p_override_lock, flags);
+	if (kmap_ops &&
+	    !in_interrupt() &&
+	    paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
+		arch_enter_lazy_mmu_mode();
+		lazy = true;
+	}
 
-	list_for_each_entry(p, bucket, lru) {
-		if (page_private(p) == mfn) {
-			ret = p;
-			break;
+	for (i = 0; i < count; i++) {
+		unsigned long mfn = get_phys_to_machine(page_to_pfn(pages[i]));
+		unsigned long pfn = page_to_pfn(pages[i]);
+
+		if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT)) {
+			ret = -EINVAL;
+			goto out;
 		}
-	}
 
-	spin_unlock_irqrestore(&m2p_override_lock, flags);
+		set_page_private(pages[i], INVALID_P2M_ENTRY);
+		WARN_ON(!PagePrivate(pages[i]));
+		ClearPagePrivate(pages[i]);
+		set_phys_to_machine(pfn, pages[i]->index);
 
+		if (kmap_ops)
+			ret = m2p_remove_override(pages[i], &kmap_ops[i], mfn);
+		if (ret)
+			goto out;
+	}
+
+out:
+	if (lazy)
+		arch_leave_lazy_mmu_mode();
 	return ret;
 }
+EXPORT_SYMBOL_GPL(clear_foreign_p2m_mapping);
 
 unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn)
 {
-- 
2.1.2

