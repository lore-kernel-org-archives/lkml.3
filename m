Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbaK1Kzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:55:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaK1KyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:54:08 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andrew.cooper3@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V4 06/10] xen: Delay invalidating extra memory
Date: Fri, 28 Nov 2014 11:53:55 +0100
Message-Id: <1417172039-8627-7-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417172039-8627-1-git-send-email-jgross@suse.com>
References: <1417172039-8627-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the physical memory configuration is initialized the p2m entries
for not pouplated memory pages are set to "invalid". As those pages
are beyond the hypervisor built p2m list the p2m tree has to be
extended.

This patch delays processing the extra memory related p2m entries
during the boot process until some more basic memory management
functions are callable. This removes the need to create new p2m
entries until virtual memory management is available.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/include/asm/xen/page.h |   3 +
 arch/x86/xen/p2m.c              | 128 ++++++++--------------------------------
 arch/x86/xen/setup.c            |  98 ++++++++++++++++++++++--------
 arch/x86/xen/xen-ops.h          |   3 +-
 4 files changed, 103 insertions(+), 129 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index b475297..28fa795 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -41,6 +41,9 @@ typedef struct xpaddr {
 
 extern unsigned long *machine_to_phys_mapping;
 extern unsigned long  machine_to_phys_nr;
+extern unsigned long *xen_p2m_addr;
+extern unsigned long  xen_p2m_size;
+extern unsigned long  xen_max_p2m_pfn;
 
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern bool set_phys_to_machine(unsigned long pfn, unsigned long mfn);
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 8676f35..eddec40 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -181,7 +181,12 @@
 
 static void __init m2p_override_init(void);
 
+unsigned long *xen_p2m_addr __read_mostly;
+EXPORT_SYMBOL_GPL(xen_p2m_addr);
+unsigned long xen_p2m_size __read_mostly;
+EXPORT_SYMBOL_GPL(xen_p2m_size);
 unsigned long xen_max_p2m_pfn __read_mostly;
+EXPORT_SYMBOL_GPL(xen_max_p2m_pfn);
 
 static unsigned long *p2m_mid_missing_mfn;
 static unsigned long *p2m_top_mfn;
@@ -198,13 +203,6 @@ static RESERVE_BRK_ARRAY(unsigned long *, p2m_mid_identity, P2M_MID_PER_PAGE);
 
 RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
 
-/* For each I/O range remapped we may lose up to two leaf pages for the boundary
- * violations and three mid pages to cover up to 3GB. With
- * early_can_reuse_p2m_middle() most of the leaf pages will be reused by the
- * remapped region.
- */
-RESERVE_BRK(p2m_identity_remap, PAGE_SIZE * 2 * 3 * MAX_REMAP_RANGES);
-
 static int use_brk = 1;
 
 static inline unsigned p2m_top_index(unsigned long pfn)
@@ -381,9 +379,11 @@ void __init xen_build_dynamic_phys_to_machine(void)
 	 if (xen_feature(XENFEAT_auto_translated_physmap))
 		return;
 
+	xen_p2m_addr = (unsigned long *)xen_start_info->mfn_list;
 	mfn_list = (unsigned long *)xen_start_info->mfn_list;
 	max_pfn = min(MAX_DOMAIN_PAGES, xen_start_info->nr_pages);
 	xen_max_p2m_pfn = max_pfn;
+	xen_p2m_size = max_pfn;
 
 	p2m_missing = alloc_p2m_page();
 	p2m_init(p2m_missing);
@@ -499,6 +499,11 @@ unsigned long __init xen_revector_p2m_tree(void)
 		/* This should be the leafs allocated for identity from _brk. */
 	}
 
+	xen_p2m_size = xen_max_p2m_pfn;
+	xen_p2m_addr = mfn_list;
+
+	xen_inv_extra_mem();
+
 	m2p_override_init();
 	return (unsigned long)mfn_list;
 }
@@ -506,6 +511,8 @@ unsigned long __init xen_revector_p2m_tree(void)
 unsigned long __init xen_revector_p2m_tree(void)
 {
 	use_brk = 0;
+	xen_p2m_size = xen_max_p2m_pfn;
+	xen_inv_extra_mem();
 	m2p_override_init();
 	return 0;
 }
@@ -514,8 +521,12 @@ unsigned long get_phys_to_machine(unsigned long pfn)
 {
 	unsigned topidx, mididx, idx;
 
-	if (unlikely(pfn >= MAX_P2M_PFN))
+	if (unlikely(pfn >= xen_p2m_size)) {
+		if (pfn < xen_max_p2m_pfn)
+			return xen_chk_extra_mem(pfn);
+
 		return IDENTITY_FRAME(pfn);
+	}
 
 	topidx = p2m_top_index(pfn);
 	mididx = p2m_mid_index(pfn);
@@ -613,78 +624,12 @@ static bool alloc_p2m(unsigned long pfn)
 	return true;
 }
 
-static bool __init early_alloc_p2m(unsigned long pfn, bool check_boundary)
-{
-	unsigned topidx, mididx, idx;
-	unsigned long *p2m;
-
-	topidx = p2m_top_index(pfn);
-	mididx = p2m_mid_index(pfn);
-	idx = p2m_index(pfn);
-
-	/* Pfff.. No boundary cross-over, lets get out. */
-	if (!idx && check_boundary)
-		return false;
-
-	WARN(p2m_top[topidx][mididx] == p2m_identity,
-		"P2M[%d][%d] == IDENTITY, should be MISSING (or alloced)!\n",
-		topidx, mididx);
-
-	/*
-	 * Could be done by xen_build_dynamic_phys_to_machine..
-	 */
-	if (p2m_top[topidx][mididx] != p2m_missing)
-		return false;
-
-	/* Boundary cross-over for the edges: */
-	p2m = alloc_p2m_page();
-
-	p2m_init(p2m);
-
-	p2m_top[topidx][mididx] = p2m;
-
-	return true;
-}
-
-static bool __init early_alloc_p2m_middle(unsigned long pfn)
-{
-	unsigned topidx = p2m_top_index(pfn);
-	unsigned long **mid;
-
-	mid = p2m_top[topidx];
-	if (mid == p2m_mid_missing) {
-		mid = alloc_p2m_page();
-
-		p2m_mid_init(mid, p2m_missing);
-
-		p2m_top[topidx] = mid;
-	}
-	return true;
-}
-
-static void __init early_split_p2m(unsigned long pfn)
-{
-	unsigned long mididx, idx;
-
-	mididx = p2m_mid_index(pfn);
-	idx = p2m_index(pfn);
-
-	/*
-	 * Allocate new middle and leaf pages if this pfn lies in the
-	 * middle of one.
-	 */
-	if (mididx || idx)
-		early_alloc_p2m_middle(pfn);
-	if (idx)
-		early_alloc_p2m(pfn, false);
-}
-
 unsigned long __init set_phys_range_identity(unsigned long pfn_s,
 				      unsigned long pfn_e)
 {
 	unsigned long pfn;
 
-	if (unlikely(pfn_s >= MAX_P2M_PFN))
+	if (unlikely(pfn_s >= xen_p2m_size))
 		return 0;
 
 	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap)))
@@ -693,34 +638,11 @@ unsigned long __init set_phys_range_identity(unsigned long pfn_s,
 	if (pfn_s > pfn_e)
 		return 0;
 
-	if (pfn_e > MAX_P2M_PFN)
-		pfn_e = MAX_P2M_PFN;
-
-	early_split_p2m(pfn_s);
-	early_split_p2m(pfn_e);
-
-	for (pfn = pfn_s; pfn < pfn_e;) {
-		unsigned topidx = p2m_top_index(pfn);
-		unsigned mididx = p2m_mid_index(pfn);
-
-		if (!__set_phys_to_machine(pfn, IDENTITY_FRAME(pfn)))
-			break;
-		pfn++;
-
-		/*
-		 * If the PFN was set to a middle or leaf identity
-		 * page the remainder must also be identity, so skip
-		 * ahead to the next middle or leaf entry.
-		 */
-		if (p2m_top[topidx] == p2m_mid_identity)
-			pfn = ALIGN(pfn, P2M_MID_PER_PAGE * P2M_PER_PAGE);
-		else if (p2m_top[topidx][mididx] == p2m_identity)
-			pfn = ALIGN(pfn, P2M_PER_PAGE);
-	}
+	if (pfn_e > xen_p2m_size)
+		pfn_e = xen_p2m_size;
 
-	WARN((pfn - pfn_s) != (pfn_e - pfn_s),
-		"Identity mapping failed. We are %ld short of 1-1 mappings!\n",
-		(pfn_e - pfn_s) - (pfn - pfn_s));
+	for (pfn = pfn_s; pfn < pfn_e; pfn++)
+		xen_p2m_addr[pfn] = IDENTITY_FRAME(pfn);
 
 	return pfn - pfn_s;
 }
@@ -734,7 +656,7 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap)))
 		return true;
 
-	if (unlikely(pfn >= MAX_P2M_PFN)) {
+	if (unlikely(pfn >= xen_p2m_size)) {
 		BUG_ON(mfn != INVALID_P2M_ENTRY);
 		return true;
 	}
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index e0b6912f..12cd199 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -76,7 +76,6 @@ static unsigned long xen_remap_mfn __initdata = INVALID_P2M_ENTRY;
 
 static void __init xen_add_extra_mem(u64 start, u64 size)
 {
-	unsigned long pfn;
 	int i;
 
 	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
@@ -96,17 +95,75 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
 		printk(KERN_WARNING "Warning: not enough extra memory regions\n");
 
 	memblock_reserve(start, size);
+}
 
-	xen_max_p2m_pfn = PFN_DOWN(start + size);
-	for (pfn = PFN_DOWN(start); pfn < xen_max_p2m_pfn; pfn++) {
-		unsigned long mfn = pfn_to_mfn(pfn);
+static void __init xen_del_extra_mem(u64 start, u64 size)
+{
+	int i;
+	u64 start_r, size_r;
 
-		if (WARN_ONCE(mfn == pfn, "Trying to over-write 1-1 mapping (pfn: %lx)\n", pfn))
-			continue;
-		WARN_ONCE(mfn != INVALID_P2M_ENTRY, "Trying to remove %lx which has %lx mfn!\n",
-			  pfn, mfn);
+	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
+		start_r = xen_extra_mem[i].start;
+		size_r = xen_extra_mem[i].size;
+
+		/* Start of region. */
+		if (start_r == start) {
+			BUG_ON(size > size_r);
+			xen_extra_mem[i].start += size;
+			xen_extra_mem[i].size -= size;
+			break;
+		}
+		/* End of region. */
+		if (start_r + size_r == start + size) {
+			BUG_ON(size > size_r);
+			xen_extra_mem[i].size -= size;
+			break;
+		}
+		/* Mid of region. */
+		if (start > start_r && start < start_r + size_r) {
+			BUG_ON(start + size > start_r + size_r);
+			xen_extra_mem[i].size = start - start_r;
+			/* Calling memblock_reserve() again is okay. */
+			xen_add_extra_mem(start + size, start_r + size_r -
+					  (start + size));
+			break;
+		}
+	}
+	memblock_free(start, size);
+}
+
+/*
+ * Called during boot before the p2m list can take entries beyond the
+ * hypervisor supplied p2m list. Entries in extra mem are to be regarded as
+ * invalid.
+ */
+unsigned long __ref xen_chk_extra_mem(unsigned long pfn)
+{
+	int i;
+	unsigned long addr = PFN_PHYS(pfn);
 
-		__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
+		if (addr >= xen_extra_mem[i].start &&
+		    addr < xen_extra_mem[i].start + xen_extra_mem[i].size)
+			return INVALID_P2M_ENTRY;
+	}
+
+	return IDENTITY_FRAME(pfn);
+}
+
+/*
+ * Mark all pfns of extra mem as invalid in p2m list.
+ */
+void __init xen_inv_extra_mem(void)
+{
+	unsigned long pfn, pfn_s, pfn_e;
+	int i;
+
+	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
+		pfn_s = PFN_DOWN(xen_extra_mem[i].start);
+		pfn_e = PFN_UP(xen_extra_mem[i].start + xen_extra_mem[i].size);
+		for (pfn = pfn_s; pfn < pfn_e; pfn++)
+			set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
 	}
 }
 
@@ -268,9 +325,6 @@ static void __init xen_do_set_identity_and_remap_chunk(
 
 	BUG_ON(xen_feature(XENFEAT_auto_translated_physmap));
 
-	/* Don't use memory until remapped */
-	memblock_reserve(PFN_PHYS(remap_pfn), PFN_PHYS(size));
-
 	mfn_save = virt_to_mfn(buf);
 
 	for (ident_pfn_iter = start_pfn, remap_pfn_iter = remap_pfn;
@@ -314,7 +368,7 @@ static void __init xen_do_set_identity_and_remap_chunk(
  * pages. In the case of an error the underlying memory is simply released back
  * to Xen and not remapped.
  */
-static unsigned long __init xen_set_identity_and_remap_chunk(
+static unsigned long xen_set_identity_and_remap_chunk(
         const struct e820entry *list, size_t map_size, unsigned long start_pfn,
 	unsigned long end_pfn, unsigned long nr_pages, unsigned long remap_pfn,
 	unsigned long *identity, unsigned long *released)
@@ -371,7 +425,7 @@ static unsigned long __init xen_set_identity_and_remap_chunk(
 	return remap_pfn;
 }
 
-static unsigned long __init xen_set_identity_and_remap(
+static void __init xen_set_identity_and_remap(
 	const struct e820entry *list, size_t map_size, unsigned long nr_pages,
 	unsigned long *released)
 {
@@ -415,8 +469,6 @@ static unsigned long __init xen_set_identity_and_remap(
 
 	pr_info("Set %ld page(s) to 1-1 mapping\n", identity);
 	pr_info("Released %ld page(s)\n", num_released);
-
-	return last_pfn;
 }
 
 /*
@@ -456,7 +508,7 @@ void __init xen_remap_memory(void)
 		} else if (pfn_s + len == xen_remap_buf.target_pfn) {
 			len += xen_remap_buf.size;
 		} else {
-			memblock_free(PFN_PHYS(pfn_s), PFN_PHYS(len));
+			xen_del_extra_mem(PFN_PHYS(pfn_s), PFN_PHYS(len));
 			pfn_s = xen_remap_buf.target_pfn;
 			len = xen_remap_buf.size;
 		}
@@ -466,7 +518,7 @@ void __init xen_remap_memory(void)
 	}
 
 	if (pfn_s != ~0UL && len)
-		memblock_free(PFN_PHYS(pfn_s), PFN_PHYS(len));
+		xen_del_extra_mem(PFN_PHYS(pfn_s), PFN_PHYS(len));
 
 	set_pte_mfn(buf, mfn_save, PAGE_KERNEL);
 
@@ -533,7 +585,6 @@ char * __init xen_memory_setup(void)
 	int rc;
 	struct xen_memory_map memmap;
 	unsigned long max_pages;
-	unsigned long last_pfn = 0;
 	unsigned long extra_pages = 0;
 	int i;
 	int op;
@@ -583,15 +634,11 @@ char * __init xen_memory_setup(void)
 	 * Set identity map on non-RAM pages and prepare remapping the
 	 * underlying RAM.
 	 */
-	last_pfn = xen_set_identity_and_remap(map, memmap.nr_entries, max_pfn,
-					      &xen_released_pages);
+	xen_set_identity_and_remap(map, memmap.nr_entries, max_pfn,
+				   &xen_released_pages);
 
 	extra_pages += xen_released_pages;
 
-	if (last_pfn > max_pfn) {
-		max_pfn = min(MAX_DOMAIN_PAGES, last_pfn);
-		mem_end = PFN_PHYS(max_pfn);
-	}
 	/*
 	 * Clamp the amount of extra memory to a EXTRA_MEM_RATIO
 	 * factor the base size.  On non-highmem systems, the base
@@ -618,6 +665,7 @@ char * __init xen_memory_setup(void)
 				size = min(size, (u64)extra_pages * PAGE_SIZE);
 				extra_pages -= size / PAGE_SIZE;
 				xen_add_extra_mem(addr, size);
+				xen_max_p2m_pfn = PFN_DOWN(addr + size);
 			} else
 				type = E820_UNUSABLE;
 		}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 5b72a06..02b0b0f 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -29,12 +29,13 @@ void xen_build_mfn_list_list(void);
 void xen_setup_machphys_mapping(void);
 void xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn);
 void xen_reserve_top(void);
-extern unsigned long xen_max_p2m_pfn;
 
 void xen_mm_pin_all(void);
 void xen_mm_unpin_all(void);
 void xen_set_pat(u64);
 
+unsigned long __ref xen_chk_extra_mem(unsigned long pfn);
+void __init xen_inv_extra_mem(void);
 void __init xen_remap_memory(void);
 char * __init xen_memory_setup(void);
 char * xen_auto_xlated_memory_setup(void);
-- 
2.1.2

