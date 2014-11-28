Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaK1K5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:57:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaK1KyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:54:05 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andrew.cooper3@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V4 2/9] xen: Make functions static
Date: Fri, 28 Nov 2014 11:53:51 +0100
Message-Id: <1417172039-8627-3-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417172039-8627-1-git-send-email-jgross@suse.com>
References: <1417172039-8627-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some functions in arch/x86/xen/p2m.c are used locally only. Make them
static. Rearrange the functions in p2m.c to avoid forward declarations.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/xen/page.h |   6 -
 arch/x86/xen/p2m.c              | 346 ++++++++++++++++++++--------------------
 2 files changed, 172 insertions(+), 180 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index c949923..6c16451 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -52,15 +52,9 @@ extern unsigned long set_phys_range_identity(unsigned long pfn_s,
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
index 73d354a..2d8b908 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -896,6 +896,61 @@ static unsigned long mfn_hash(unsigned long mfn)
 	return hash_long(mfn, M2P_OVERRIDE_HASH_SHIFT);
 }
 
+/* Add an MFN override for a particular page */
+static int m2p_add_override(unsigned long mfn, struct page *page,
+			    struct gnttab_map_grant_ref *kmap_op)
+{
+	unsigned long flags;
+	unsigned long pfn;
+	unsigned long uninitialized_var(address);
+	unsigned level;
+	pte_t *ptep = NULL;
+
+	pfn = page_to_pfn(page);
+	if (!PageHighMem(page)) {
+		address = (unsigned long)__va(pfn << PAGE_SHIFT);
+		ptep = lookup_address(address, &level);
+		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
+			 "m2p_add_override: pfn %lx not mapped", pfn))
+			return -EINVAL;
+	}
+
+	if (kmap_op != NULL) {
+		if (!PageHighMem(page)) {
+			struct multicall_space mcs =
+				xen_mc_entry(sizeof(*kmap_op));
+
+			MULTI_grant_table_op(mcs.mc,
+					GNTTABOP_map_grant_ref, kmap_op, 1);
+
+			xen_mc_issue(PARAVIRT_LAZY_MMU);
+		}
+	}
+	spin_lock_irqsave(&m2p_override_lock, flags);
+	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
+	spin_unlock_irqrestore(&m2p_override_lock, flags);
+
+	/* p2m(m2p(mfn)) == mfn: the mfn is already present somewhere in
+	 * this domain. Set the FOREIGN_FRAME_BIT in the p2m for the other
+	 * pfn so that the following mfn_to_pfn(mfn) calls will return the
+	 * pfn from the m2p_override (the backend pfn) instead.
+	 * We need to do this because the pages shared by the frontend
+	 * (xen-blkfront) can be already locked (lock_page, called by
+	 * do_read_cache_page); when the userspace backend tries to use them
+	 * with direct_IO, mfn_to_pfn returns the pfn of the frontend, so
+	 * do_blockdev_direct_IO is going to try to lock the same pages
+	 * again resulting in a deadlock.
+	 * As a side effect get_user_pages_fast might not be safe on the
+	 * frontend pages while they are being shared with the backend,
+	 * because mfn_to_pfn (that ends up being called by GUPF) will
+	 * return the backend pfn rather than the frontend pfn. */
+	pfn = mfn_to_pfn_no_overrides(mfn);
+	if (get_phys_to_machine(pfn) == mfn)
+		set_phys_to_machine(pfn, FOREIGN_FRAME(mfn));
+
+	return 0;
+}
+
 int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 			    struct gnttab_map_grant_ref *kmap_ops,
 			    struct page **pages, unsigned int count)
@@ -955,61 +1010,123 @@ out:
 }
 EXPORT_SYMBOL_GPL(set_foreign_p2m_mapping);
 
-/* Add an MFN override for a particular page */
-int m2p_add_override(unsigned long mfn, struct page *page,
-		struct gnttab_map_grant_ref *kmap_op)
-{
-	unsigned long flags;
-	unsigned long pfn;
-	unsigned long uninitialized_var(address);
-	unsigned level;
-	pte_t *ptep = NULL;
-
-	pfn = page_to_pfn(page);
-	if (!PageHighMem(page)) {
-		address = (unsigned long)__va(pfn << PAGE_SHIFT);
-		ptep = lookup_address(address, &level);
-		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
-			 "m2p_add_override: pfn %lx not mapped", pfn))
-			return -EINVAL;
-	}
-
-	if (kmap_op != NULL) {
-		if (!PageHighMem(page)) {
-			struct multicall_space mcs =
-				xen_mc_entry(sizeof(*kmap_op));
-
-			MULTI_grant_table_op(mcs.mc,
-					GNTTABOP_map_grant_ref, kmap_op, 1);
-
-			xen_mc_issue(PARAVIRT_LAZY_MMU);
-		}
-	}
-	spin_lock_irqsave(&m2p_override_lock, flags);
-	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
-	spin_unlock_irqrestore(&m2p_override_lock, flags);
-
-	/* p2m(m2p(mfn)) == mfn: the mfn is already present somewhere in
-	 * this domain. Set the FOREIGN_FRAME_BIT in the p2m for the other
-	 * pfn so that the following mfn_to_pfn(mfn) calls will return the
-	 * pfn from the m2p_override (the backend pfn) instead.
-	 * We need to do this because the pages shared by the frontend
-	 * (xen-blkfront) can be already locked (lock_page, called by
-	 * do_read_cache_page); when the userspace backend tries to use them
-	 * with direct_IO, mfn_to_pfn returns the pfn of the frontend, so
-	 * do_blockdev_direct_IO is going to try to lock the same pages
-	 * again resulting in a deadlock.
-	 * As a side effect get_user_pages_fast might not be safe on the
-	 * frontend pages while they are being shared with the backend,
-	 * because mfn_to_pfn (that ends up being called by GUPF) will
-	 * return the backend pfn rather than the frontend pfn. */
-	pfn = mfn_to_pfn_no_overrides(mfn);
-	if (get_phys_to_machine(pfn) == mfn)
-		set_phys_to_machine(pfn, FOREIGN_FRAME(mfn));
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(m2p_add_override);
+static struct page *m2p_find_override(unsigned long mfn)
+{
+	unsigned long flags;
+	struct list_head *bucket = &m2p_overrides[mfn_hash(mfn)];
+	struct page *p, *ret;
+
+	ret = NULL;
+
+	spin_lock_irqsave(&m2p_override_lock, flags);
+
+	list_for_each_entry(p, bucket, lru) {
+		if (page_private(p) == mfn) {
+			ret = p;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&m2p_override_lock, flags);
+
+	return ret;
+}
+
+static int m2p_remove_override(struct page *page,
+			       struct gnttab_map_grant_ref *kmap_op,
+			       unsigned long mfn)
+{
+	unsigned long flags;
+	unsigned long pfn;
+	unsigned long uninitialized_var(address);
+	unsigned level;
+	pte_t *ptep = NULL;
+
+	pfn = page_to_pfn(page);
+
+	if (!PageHighMem(page)) {
+		address = (unsigned long)__va(pfn << PAGE_SHIFT);
+		ptep = lookup_address(address, &level);
+
+		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
+			 "m2p_remove_override: pfn %lx not mapped", pfn))
+			return -EINVAL;
+	}
+
+	spin_lock_irqsave(&m2p_override_lock, flags);
+	list_del(&page->lru);
+	spin_unlock_irqrestore(&m2p_override_lock, flags);
+
+	if (kmap_op != NULL) {
+		if (!PageHighMem(page)) {
+			struct multicall_space mcs;
+			struct gnttab_unmap_and_replace *unmap_op;
+			struct page *scratch_page = get_balloon_scratch_page();
+			unsigned long scratch_page_address = (unsigned long)
+				__va(page_to_pfn(scratch_page) << PAGE_SHIFT);
+
+			/*
+			 * It might be that we queued all the m2p grant table
+			 * hypercalls in a multicall, then m2p_remove_override
+			 * get called before the multicall has actually been
+			 * issued. In this case handle is going to -1 because
+			 * it hasn't been modified yet.
+			 */
+			if (kmap_op->handle == -1)
+				xen_mc_flush();
+			/*
+			 * Now if kmap_op->handle is negative it means that the
+			 * hypercall actually returned an error.
+			 */
+			if (kmap_op->handle == GNTST_general_error) {
+				pr_warn("m2p_remove_override: pfn %lx mfn %lx, failed to modify kernel mappings",
+					pfn, mfn);
+				put_balloon_scratch_page();
+				return -1;
+			}
+
+			xen_mc_batch();
+
+			mcs = __xen_mc_entry(
+				sizeof(struct gnttab_unmap_and_replace));
+			unmap_op = mcs.args;
+			unmap_op->host_addr = kmap_op->host_addr;
+			unmap_op->new_addr = scratch_page_address;
+			unmap_op->handle = kmap_op->handle;
+
+			MULTI_grant_table_op(mcs.mc,
+				GNTTABOP_unmap_and_replace, unmap_op, 1);
+
+			mcs = __xen_mc_entry(0);
+			MULTI_update_va_mapping(mcs.mc, scratch_page_address,
+					pfn_pte(page_to_pfn(scratch_page),
+					PAGE_KERNEL_RO), 0);
+
+			xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+			kmap_op->host_addr = 0;
+			put_balloon_scratch_page();
+		}
+	}
+
+	/* p2m(m2p(mfn)) == FOREIGN_FRAME(mfn): the mfn is already present
+	 * somewhere in this domain, even before being added to the
+	 * m2p_override (see comment above in m2p_add_override).
+	 * If there are no other entries in the m2p_override corresponding
+	 * to this mfn, then remove the FOREIGN_FRAME_BIT from the p2m for
+	 * the original pfn (the one shared by the frontend): the backend
+	 * cannot do any IO on this page anymore because it has been
+	 * unshared. Removing the FOREIGN_FRAME_BIT from the p2m entry of
+	 * the original pfn causes mfn_to_pfn(mfn) to return the frontend
+	 * pfn again. */
+	mfn &= ~FOREIGN_FRAME_BIT;
+	pfn = mfn_to_pfn_no_overrides(mfn);
+	if (get_phys_to_machine(pfn) == FOREIGN_FRAME(mfn) &&
+			m2p_find_override(mfn) == NULL)
+		set_phys_to_machine(pfn, mfn);
+
+	return 0;
+}
 
 int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
 			      struct gnttab_map_grant_ref *kmap_ops,
@@ -1055,125 +1172,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(clear_foreign_p2m_mapping);
 
-int m2p_remove_override(struct page *page,
-			struct gnttab_map_grant_ref *kmap_op,
-			unsigned long mfn)
-{
-	unsigned long flags;
-	unsigned long pfn;
-	unsigned long uninitialized_var(address);
-	unsigned level;
-	pte_t *ptep = NULL;
-
-	pfn = page_to_pfn(page);
-
-	if (!PageHighMem(page)) {
-		address = (unsigned long)__va(pfn << PAGE_SHIFT);
-		ptep = lookup_address(address, &level);
-
-		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
-			 "m2p_remove_override: pfn %lx not mapped", pfn))
-			return -EINVAL;
-	}
-
-	spin_lock_irqsave(&m2p_override_lock, flags);
-	list_del(&page->lru);
-	spin_unlock_irqrestore(&m2p_override_lock, flags);
-
-	if (kmap_op != NULL) {
-		if (!PageHighMem(page)) {
-			struct multicall_space mcs;
-			struct gnttab_unmap_and_replace *unmap_op;
-			struct page *scratch_page = get_balloon_scratch_page();
-			unsigned long scratch_page_address = (unsigned long)
-				__va(page_to_pfn(scratch_page) << PAGE_SHIFT);
-
-			/*
-			 * It might be that we queued all the m2p grant table
-			 * hypercalls in a multicall, then m2p_remove_override
-			 * get called before the multicall has actually been
-			 * issued. In this case handle is going to -1 because
-			 * it hasn't been modified yet.
-			 */
-			if (kmap_op->handle == -1)
-				xen_mc_flush();
-			/*
-			 * Now if kmap_op->handle is negative it means that the
-			 * hypercall actually returned an error.
-			 */
-			if (kmap_op->handle == GNTST_general_error) {
-				pr_warn("m2p_remove_override: pfn %lx mfn %lx, failed to modify kernel mappings",
-					pfn, mfn);
-				put_balloon_scratch_page();
-				return -1;
-			}
-
-			xen_mc_batch();
-
-			mcs = __xen_mc_entry(
-				sizeof(struct gnttab_unmap_and_replace));
-			unmap_op = mcs.args;
-			unmap_op->host_addr = kmap_op->host_addr;
-			unmap_op->new_addr = scratch_page_address;
-			unmap_op->handle = kmap_op->handle;
-
-			MULTI_grant_table_op(mcs.mc,
-				GNTTABOP_unmap_and_replace, unmap_op, 1);
-
-			mcs = __xen_mc_entry(0);
-			MULTI_update_va_mapping(mcs.mc, scratch_page_address,
-					pfn_pte(page_to_pfn(scratch_page),
-					PAGE_KERNEL_RO), 0);
-
-			xen_mc_issue(PARAVIRT_LAZY_MMU);
-
-			kmap_op->host_addr = 0;
-			put_balloon_scratch_page();
-		}
-	}
-
-	/* p2m(m2p(mfn)) == FOREIGN_FRAME(mfn): the mfn is already present
-	 * somewhere in this domain, even before being added to the
-	 * m2p_override (see comment above in m2p_add_override).
-	 * If there are no other entries in the m2p_override corresponding
-	 * to this mfn, then remove the FOREIGN_FRAME_BIT from the p2m for
-	 * the original pfn (the one shared by the frontend): the backend
-	 * cannot do any IO on this page anymore because it has been
-	 * unshared. Removing the FOREIGN_FRAME_BIT from the p2m entry of
-	 * the original pfn causes mfn_to_pfn(mfn) to return the frontend
-	 * pfn again. */
-	mfn &= ~FOREIGN_FRAME_BIT;
-	pfn = mfn_to_pfn_no_overrides(mfn);
-	if (get_phys_to_machine(pfn) == FOREIGN_FRAME(mfn) &&
-			m2p_find_override(mfn) == NULL)
-		set_phys_to_machine(pfn, mfn);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(m2p_remove_override);
-
-struct page *m2p_find_override(unsigned long mfn)
-{
-	unsigned long flags;
-	struct list_head *bucket = &m2p_overrides[mfn_hash(mfn)];
-	struct page *p, *ret;
-
-	ret = NULL;
-
-	spin_lock_irqsave(&m2p_override_lock, flags);
-
-	list_for_each_entry(p, bucket, lru) {
-		if (page_private(p) == mfn) {
-			ret = p;
-			break;
-		}
-	}
-
-	spin_unlock_irqrestore(&m2p_override_lock, flags);
-
-	return ret;
-}
-
 unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn)
 {
 	struct page *p = m2p_find_override(mfn);
-- 
2.1.2

