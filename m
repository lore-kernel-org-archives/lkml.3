Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaK1KyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:54:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbaK1KyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:54:10 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andrew.cooper3@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V4 09/10] xen: switch to linear virtual mapped sparse p2m list
Date: Fri, 28 Nov 2014 11:53:58 +0100
Message-Id: <1417172039-8627-10-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417172039-8627-1-git-send-email-jgross@suse.com>
References: <1417172039-8627-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At start of the day the Xen hypervisor presents a contiguous mfn list
to a pv-domain. In order to support sparse memory this mfn list is
accessed via a three level p2m tree built early in the boot process.
Whenever the system needs the mfn associated with a pfn this tree is
used to find the mfn.

Instead of using a software walked tree for accessing a specific mfn
list entry this patch is creating a virtual address area for the
entire possible mfn list including memory holes. The holes are
covered by mapping a pre-defined  page consisting only of "invalid
mfn" entries. Access to a mfn entry is possible by just using the
virtual base address of the mfn list and the pfn as index into that
list. This speeds up the (hot) path of determining the mfn of a
pfn.

Kernel build on a Dell Latitude E6440 (2 cores, HT) in 64 bit Dom0
showed following improvements:

Elapsed time: 32:50 ->  32:35
System:       18:07 ->  17:47
User:        104:00 -> 103:30

Tested with following configurations:
- 64 bit dom0, 8GB RAM
- 64 bit dom0, 128 GB RAM, PCI-area above 4 GB
- 32 bit domU, 512 MB, 8 GB, 43 GB (more wouldn't work even without
                                    the patch)
- 32 bit domU, ballooning up and down
- 32 bit domU, save and restore
- 32 bit domU with PCI passthrough
- 64 bit domU, 8 GB, 2049 MB, 5000 MB
- 64 bit domU, ballooning up and down
- 64 bit domU, save and restore
- 64 bit domU with PCI passthrough

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/xen/page.h |  20 +-
 arch/x86/xen/mmu.c              |  34 +-
 arch/x86/xen/p2m.c              | 735 +++++++++++++++++-----------------------
 arch/x86/xen/xen-ops.h          |   2 +-
 4 files changed, 347 insertions(+), 444 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 410a6ec..f5d5de4 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -65,13 +65,25 @@ extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn)
  *   bits (identity or foreign) are set.
  * - __pfn_to_mfn() returns the found entry of the p2m table. A possibly set
  *   identity or foreign indicator will be still set. __pfn_to_mfn() is
- *   encapsulating get_phys_to_machine().
- * - get_phys_to_machine() is to be called by __pfn_to_mfn() only to allow
- *   for future optimizations.
+ *   encapsulating get_phys_to_machine() which is called in special cases only.
+ * - get_phys_to_machine() is to be called by __pfn_to_mfn() only in special
+ *   cases needing an extended handling.
  */
 static inline unsigned long __pfn_to_mfn(unsigned long pfn)
 {
-	return get_phys_to_machine(pfn);
+	unsigned long mfn;
+
+	if (pfn < xen_p2m_size)
+		mfn = xen_p2m_addr[pfn];
+	else if (unlikely(pfn < xen_max_p2m_pfn))
+		return get_phys_to_machine(pfn);
+	else
+		return IDENTITY_FRAME(pfn);
+
+	if (unlikely(mfn == INVALID_P2M_ENTRY))
+		return get_phys_to_machine(pfn);
+
+	return mfn;
 }
 
 static inline unsigned long pfn_to_mfn(unsigned long pfn)
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 3e3f8f8..6ab6150 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1158,20 +1158,16 @@ static void __init xen_cleanhighmap(unsigned long vaddr,
 	 * instead of somewhere later and be confusing. */
 	xen_mc_flush();
 }
-static void __init xen_pagetable_p2m_copy(void)
+
+static void __init xen_pagetable_p2m_free(void)
 {
 	unsigned long size;
 	unsigned long addr;
-	unsigned long new_mfn_list;
-
-	if (xen_feature(XENFEAT_auto_translated_physmap))
-		return;
 
 	size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
 
-	new_mfn_list = xen_revector_p2m_tree();
 	/* No memory or already called. */
-	if (!new_mfn_list || new_mfn_list == xen_start_info->mfn_list)
+	if ((unsigned long)xen_p2m_addr == xen_start_info->mfn_list)
 		return;
 
 	/* using __ka address and sticking INVALID_P2M_ENTRY! */
@@ -1189,8 +1185,6 @@ static void __init xen_pagetable_p2m_copy(void)
 
 	size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
 	memblock_free(__pa(xen_start_info->mfn_list), size);
-	/* And revector! Bye bye old array */
-	xen_start_info->mfn_list = new_mfn_list;
 
 	/* At this stage, cleanup_highmap has already cleaned __ka space
 	 * from _brk_limit way up to the max_pfn_mapped (which is the end of
@@ -1214,14 +1208,26 @@ static void __init xen_pagetable_p2m_copy(void)
 }
 #endif
 
-static void __init xen_pagetable_init(void)
+static void __init xen_pagetable_p2m_setup(void)
 {
-	paging_init();
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
+	xen_vmalloc_p2m_tree();
+
 #ifdef CONFIG_X86_64
-	xen_pagetable_p2m_copy();
-#else
-	xen_revector_p2m_tree();
+	xen_pagetable_p2m_free();
 #endif
+	/* And revector! Bye bye old array */
+	xen_start_info->mfn_list = (unsigned long)xen_p2m_addr;
+}
+
+static void __init xen_pagetable_init(void)
+{
+	paging_init();
+
+	xen_pagetable_p2m_setup();
+
 	/* Allocate and initialize top and mid mfn levels for p2m structure */
 	xen_build_mfn_list_list();
 
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 8c3d8fb..7d84473 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -3,21 +3,22 @@
  * guests themselves, but it must also access and update the p2m array
  * during suspend/resume when all the pages are reallocated.
  *
- * The p2m table is logically a flat array, but we implement it as a
- * three-level tree to allow the address space to be sparse.
+ * The logical flat p2m table is mapped to a linear kernel memory area.
+ * For accesses by Xen a three-level tree linked via mfns only is set up to
+ * allow the address space to be sparse.
  *
- *                               Xen
- *                                |
- *     p2m_top              p2m_top_mfn
- *       /  \                   /   \
- * p2m_mid p2m_mid	p2m_mid_mfn p2m_mid_mfn
- *    / \      / \         /           /
- *  p2m p2m p2m p2m p2m p2m p2m ...
+ *               Xen
+ *                |
+ *          p2m_top_mfn
+ *              /   \
+ * p2m_mid_mfn p2m_mid_mfn
+ *         /           /
+ *  p2m p2m p2m ...
  *
  * The p2m_mid_mfn pages are mapped by p2m_top_mfn_p.
  *
- * The p2m_top and p2m_top_mfn levels are limited to 1 page, so the
- * maximum representable pseudo-physical address space is:
+ * The p2m_top_mfn level is limited to 1 page, so the maximum representable
+ * pseudo-physical address space is:
  *  P2M_TOP_PER_PAGE * P2M_MID_PER_PAGE * P2M_PER_PAGE pages
  *
  * P2M_PER_PAGE depends on the architecture, as a mfn is always
@@ -30,6 +31,9 @@
  * leaf entries, or for the top  root, or middle one, for which there is a void
  * entry, we assume it is  "missing". So (for example)
  *  pfn_to_mfn(0x90909090)=INVALID_P2M_ENTRY.
+ * We have a dedicated page p2m_missing with all entries being
+ * INVALID_P2M_ENTRY. This page may be referenced multiple times in the p2m
+ * list/tree in case there are multiple areas with P2M_PER_PAGE invalid pfns.
  *
  * We also have the possibility of setting 1-1 mappings on certain regions, so
  * that:
@@ -39,122 +43,20 @@
  * PCI BARs, or ACPI spaces), we can create mappings easily because we
  * get the PFN value to match the MFN.
  *
- * For this to work efficiently we have one new page p2m_identity and
- * allocate (via reserved_brk) any other pages we need to cover the sides
- * (1GB or 4MB boundary violations). All entries in p2m_identity are set to
- * INVALID_P2M_ENTRY type (Xen toolstack only recognizes that and MFNs,
- * no other fancy value).
+ * For this to work efficiently we have one new page p2m_identity. All entries
+ * in p2m_identity are set to INVALID_P2M_ENTRY type (Xen toolstack only
+ * recognizes that and MFNs, no other fancy value).
  *
  * On lookup we spot that the entry points to p2m_identity and return the
  * identity value instead of dereferencing and returning INVALID_P2M_ENTRY.
  * If the entry points to an allocated page, we just proceed as before and
- * return the PFN.  If the PFN has IDENTITY_FRAME_BIT set we unmask that in
+ * return the PFN. If the PFN has IDENTITY_FRAME_BIT set we unmask that in
  * appropriate functions (pfn_to_mfn).
  *
  * The reason for having the IDENTITY_FRAME_BIT instead of just returning the
  * PFN is that we could find ourselves where pfn_to_mfn(pfn)==pfn for a
  * non-identity pfn. To protect ourselves against we elect to set (and get) the
  * IDENTITY_FRAME_BIT on all identity mapped PFNs.
- *
- * This simplistic diagram is used to explain the more subtle piece of code.
- * There is also a digram of the P2M at the end that can help.
- * Imagine your E820 looking as so:
- *
- *                    1GB                                           2GB    4GB
- * /-------------------+---------\/----\         /----------\    /---+-----\
- * | System RAM        | Sys RAM ||ACPI|         | reserved |    | Sys RAM |
- * \-------------------+---------/\----/         \----------/    \---+-----/
- *                               ^- 1029MB                       ^- 2001MB
- *
- * [1029MB = 263424 (0x40500), 2001MB = 512256 (0x7D100),
- *  2048MB = 524288 (0x80000)]
- *
- * And dom0_mem=max:3GB,1GB is passed in to the guest, meaning memory past 1GB
- * is actually not present (would have to kick the balloon driver to put it in).
- *
- * When we are told to set the PFNs for identity mapping (see patch: "xen/setup:
- * Set identity mapping for non-RAM E820 and E820 gaps.") we pass in the start
- * of the PFN and the end PFN (263424 and 512256 respectively). The first step
- * is to reserve_brk a top leaf page if the p2m[1] is missing. The top leaf page
- * covers 512^2 of page estate (1GB) and in case the start or end PFN is not
- * aligned on 512^2*PAGE_SIZE (1GB) we reserve_brk new middle and leaf pages as
- * required to split any existing p2m_mid_missing middle pages.
- *
- * With the E820 example above, 263424 is not 1GB aligned so we allocate a
- * reserve_brk page which will cover the PFNs estate from 0x40000 to 0x80000.
- * Each entry in the allocate page is "missing" (points to p2m_missing).
- *
- * Next stage is to determine if we need to do a more granular boundary check
- * on the 4MB (or 2MB depending on architecture) off the start and end pfn's.
- * We check if the start pfn and end pfn violate that boundary check, and if
- * so reserve_brk a (p2m[x][y]) leaf page. This way we have a much finer
- * granularity of setting which PFNs are missing and which ones are identity.
- * In our example 263424 and 512256 both fail the check so we reserve_brk two
- * pages. Populate them with INVALID_P2M_ENTRY (so they both have "missing"
- * values) and assign them to p2m[1][2] and p2m[1][488] respectively.
- *
- * At this point we would at minimum reserve_brk one page, but could be up to
- * three. Each call to set_phys_range_identity has at maximum a three page
- * cost. If we were to query the P2M at this stage, all those entries from
- * start PFN through end PFN (so 1029MB -> 2001MB) would return
- * INVALID_P2M_ENTRY ("missing").
- *
- * The next step is to walk from the start pfn to the end pfn setting
- * the IDENTITY_FRAME_BIT on each PFN. This is done in set_phys_range_identity.
- * If we find that the middle entry is pointing to p2m_missing we can swap it
- * over to p2m_identity - this way covering 4MB (or 2MB) PFN space (and
- * similarly swapping p2m_mid_missing for p2m_mid_identity for larger regions).
- * At this point we do not need to worry about boundary aligment (so no need to
- * reserve_brk a middle page, figure out which PFNs are "missing" and which
- * ones are identity), as that has been done earlier.  If we find that the
- * middle leaf is not occupied by p2m_identity or p2m_missing, we dereference
- * that page (which covers 512 PFNs) and set the appropriate PFN with
- * IDENTITY_FRAME_BIT. In our example 263424 and 512256 end up there, and we
- * set from p2m[1][2][256->511] and p2m[1][488][0->256] with
- * IDENTITY_FRAME_BIT set.
- *
- * All other regions that are void (or not filled) either point to p2m_missing
- * (considered missing) or have the default value of INVALID_P2M_ENTRY (also
- * considered missing). In our case, p2m[1][2][0->255] and p2m[1][488][257->511]
- * contain the INVALID_P2M_ENTRY value and are considered "missing."
- *
- * Finally, the region beyond the end of of the E820 (4 GB in this example)
- * is set to be identity (in case there are MMIO regions placed here).
- *
- * This is what the p2m ends up looking (for the E820 above) with this
- * fabulous drawing:
- *
- *    p2m         /--------------\
- *  /-----\       | &mfn_list[0],|                           /-----------------\
- *  |  0  |------>| &mfn_list[1],|    /---------------\      | ~0, ~0, ..      |
- *  |-----|       |  ..., ~0, ~0 |    | ~0, ~0, [x]---+----->| IDENTITY [@256] |
- *  |  1  |---\   \--------------/    | [p2m_identity]+\     | IDENTITY [@257] |
- *  |-----|    \                      | [p2m_identity]+\\    | ....            |
- *  |  2  |--\  \-------------------->|  ...          | \\   \----------------/
- *  |-----|   \                       \---------------/  \\
- *  |  3  |-\  \                                          \\  p2m_identity [1]
- *  |-----|  \  \-------------------->/---------------\   /-----------------\
- *  | ..  |\  |                       | [p2m_identity]+-->| ~0, ~0, ~0, ... |
- *  \-----/ | |                       | [p2m_identity]+-->| ..., ~0         |
- *          | |                       | ....          |   \-----------------/
- *          | |                       +-[x], ~0, ~0.. +\
- *          | |                       \---------------/ \
- *          | |                                          \-> /---------------\
- *          | V  p2m_mid_missing       p2m_missing           | IDENTITY[@0]  |
- *          | /-----------------\     /------------\         | IDENTITY[@256]|
- *          | | [p2m_missing]   +---->| ~0, ~0, ...|         | ~0, ~0, ....  |
- *          | | [p2m_missing]   +---->| ..., ~0    |         \---------------/
- *          | | ...             |     \------------/
- *          | \-----------------/
- *          |
- *          |     p2m_mid_identity
- *          |   /-----------------\
- *          \-->| [p2m_identity]  +---->[1]
- *              | [p2m_identity]  +---->[1]
- *              | ...             |
- *              \-----------------/
- *
- * where ~0 is INVALID_P2M_ENTRY. IDENTITY is (PFN | IDENTITY_BIT)
  */
 
 #include <linux/init.h>
@@ -179,6 +81,8 @@
 #include "multicalls.h"
 #include "xen-ops.h"
 
+#define PMDS_PER_MID_PAGE	(P2M_MID_PER_PAGE / PTRS_PER_PTE)
+
 static void __init m2p_override_init(void);
 
 unsigned long *xen_p2m_addr __read_mostly;
@@ -188,22 +92,15 @@ EXPORT_SYMBOL_GPL(xen_p2m_size);
 unsigned long xen_max_p2m_pfn __read_mostly;
 EXPORT_SYMBOL_GPL(xen_max_p2m_pfn);
 
+static DEFINE_SPINLOCK(p2m_update_lock);
+
 static unsigned long *p2m_mid_missing_mfn;
 static unsigned long *p2m_top_mfn;
 static unsigned long **p2m_top_mfn_p;
-
-/* Placeholders for holes in the address space */
-static RESERVE_BRK_ARRAY(unsigned long, p2m_missing, P2M_PER_PAGE);
-static RESERVE_BRK_ARRAY(unsigned long *, p2m_mid_missing, P2M_MID_PER_PAGE);
-
-static RESERVE_BRK_ARRAY(unsigned long **, p2m_top, P2M_TOP_PER_PAGE);
-
-static RESERVE_BRK_ARRAY(unsigned long, p2m_identity, P2M_PER_PAGE);
-static RESERVE_BRK_ARRAY(unsigned long *, p2m_mid_identity, P2M_MID_PER_PAGE);
-
-RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
-
-static int use_brk = 1;
+static unsigned long *p2m_missing;
+static unsigned long *p2m_identity;
+static pte_t *p2m_missing_pte;
+static pte_t *p2m_identity_pte;
 
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
@@ -221,14 +118,6 @@ static inline unsigned p2m_index(unsigned long pfn)
 	return pfn % P2M_PER_PAGE;
 }
 
-static void p2m_top_init(unsigned long ***top)
-{
-	unsigned i;
-
-	for (i = 0; i < P2M_TOP_PER_PAGE; i++)
-		top[i] = p2m_mid_missing;
-}
-
 static void p2m_top_mfn_init(unsigned long *top)
 {
 	unsigned i;
@@ -245,35 +134,32 @@ static void p2m_top_mfn_p_init(unsigned long **top)
 		top[i] = p2m_mid_missing_mfn;
 }
 
-static void p2m_mid_init(unsigned long **mid, unsigned long *leaf)
+static void p2m_mid_mfn_init(unsigned long *mid, unsigned long *leaf)
 {
 	unsigned i;
 
 	for (i = 0; i < P2M_MID_PER_PAGE; i++)
-		mid[i] = leaf;
+		mid[i] = virt_to_mfn(leaf);
 }
 
-static void p2m_mid_mfn_init(unsigned long *mid, unsigned long *leaf)
+static void p2m_init(unsigned long *p2m)
 {
 	unsigned i;
 
-	for (i = 0; i < P2M_MID_PER_PAGE; i++)
-		mid[i] = virt_to_mfn(leaf);
+	for (i = 0; i < P2M_PER_PAGE; i++)
+		p2m[i] = INVALID_P2M_ENTRY;
 }
 
-static void p2m_init(unsigned long *p2m)
+static void p2m_init_identity(unsigned long *p2m, unsigned long pfn)
 {
 	unsigned i;
 
-	for (i = 0; i < P2M_MID_PER_PAGE; i++)
-		p2m[i] = INVALID_P2M_ENTRY;
+	for (i = 0; i < P2M_PER_PAGE; i++)
+		p2m[i] = IDENTITY_FRAME(pfn + i);
 }
 
 static void * __ref alloc_p2m_page(void)
 {
-	if (unlikely(use_brk))
-		return extend_brk(PAGE_SIZE, PAGE_SIZE);
-
 	if (unlikely(!slab_is_available()))
 		return alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
 
@@ -299,7 +185,10 @@ static void free_p2m_page(void *p)
  */
 void __ref xen_build_mfn_list_list(void)
 {
-	unsigned long pfn;
+	unsigned long pfn, mfn;
+	pte_t *ptep;
+	unsigned int level, topidx, mididx;
+	unsigned long *mid_mfn_p;
 
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return;
@@ -319,20 +208,23 @@ void __ref xen_build_mfn_list_list(void)
 		p2m_mid_mfn_init(p2m_mid_missing_mfn, p2m_missing);
 	}
 
-	for (pfn = 0; pfn < xen_max_p2m_pfn; pfn += P2M_PER_PAGE) {
-		unsigned topidx = p2m_top_index(pfn);
-		unsigned mididx = p2m_mid_index(pfn);
-		unsigned long **mid;
-		unsigned long *mid_mfn_p;
+	for (pfn = 0; pfn < xen_max_p2m_pfn && pfn < MAX_P2M_PFN;
+	     pfn += P2M_PER_PAGE) {
+		topidx = p2m_top_index(pfn);
+		mididx = p2m_mid_index(pfn);
 
-		mid = p2m_top[topidx];
 		mid_mfn_p = p2m_top_mfn_p[topidx];
+		ptep = lookup_address((unsigned long)(xen_p2m_addr + pfn),
+				      &level);
+		BUG_ON(!ptep || level != PG_LEVEL_4K);
+		mfn = pte_mfn(*ptep);
+		ptep = (pte_t *)((unsigned long)ptep & ~(PAGE_SIZE - 1));
 
 		/* Don't bother allocating any mfn mid levels if
 		 * they're just missing, just update the stored mfn,
 		 * since all could have changed over a migrate.
 		 */
-		if (mid == p2m_mid_missing) {
+		if (ptep == p2m_missing_pte || ptep == p2m_identity_pte) {
 			BUG_ON(mididx);
 			BUG_ON(mid_mfn_p != p2m_mid_missing_mfn);
 			p2m_top_mfn[topidx] = virt_to_mfn(p2m_mid_missing_mfn);
@@ -341,11 +233,6 @@ void __ref xen_build_mfn_list_list(void)
 		}
 
 		if (mid_mfn_p == p2m_mid_missing_mfn) {
-			/*
-			 * XXX boot-time only!  We should never find
-			 * missing parts of the mfn tree after
-			 * runtime.
-			 */
 			mid_mfn_p = alloc_p2m_page();
 			p2m_mid_mfn_init(mid_mfn_p, p2m_missing);
 
@@ -353,7 +240,7 @@ void __ref xen_build_mfn_list_list(void)
 		}
 
 		p2m_top_mfn[topidx] = virt_to_mfn(mid_mfn_p);
-		mid_mfn_p[mididx] = virt_to_mfn(mid[mididx]);
+		mid_mfn_p[mididx] = mfn;
 	}
 }
 
@@ -372,154 +259,153 @@ void xen_setup_mfn_list_list(void)
 /* Set up p2m_top to point to the domain-builder provided p2m pages */
 void __init xen_build_dynamic_phys_to_machine(void)
 {
-	unsigned long *mfn_list;
-	unsigned long max_pfn;
 	unsigned long pfn;
 
 	 if (xen_feature(XENFEAT_auto_translated_physmap))
 		return;
 
 	xen_p2m_addr = (unsigned long *)xen_start_info->mfn_list;
-	mfn_list = (unsigned long *)xen_start_info->mfn_list;
-	max_pfn = min(MAX_DOMAIN_PAGES, xen_start_info->nr_pages);
-	xen_max_p2m_pfn = max_pfn;
-	xen_p2m_size = max_pfn;
+	xen_p2m_size = ALIGN(xen_start_info->nr_pages, P2M_PER_PAGE);
 
-	p2m_missing = alloc_p2m_page();
-	p2m_init(p2m_missing);
-	p2m_identity = alloc_p2m_page();
-	p2m_init(p2m_identity);
+	for (pfn = xen_start_info->nr_pages; pfn < xen_p2m_size; pfn++)
+		xen_p2m_addr[pfn] = INVALID_P2M_ENTRY;
 
-	p2m_mid_missing = alloc_p2m_page();
-	p2m_mid_init(p2m_mid_missing, p2m_missing);
-	p2m_mid_identity = alloc_p2m_page();
-	p2m_mid_init(p2m_mid_identity, p2m_identity);
+	xen_max_p2m_pfn = xen_p2m_size;
+}
 
-	p2m_top = alloc_p2m_page();
-	p2m_top_init(p2m_top);
+#define P2M_TYPE_IDENTITY	0
+#define P2M_TYPE_MISSING	1
+#define P2M_TYPE_PFN		2
+#define P2M_TYPE_UNKNOWN	3
 
-	/*
-	 * The domain builder gives us a pre-constructed p2m array in
-	 * mfn_list for all the pages initially given to us, so we just
-	 * need to graft that into our tree structure.
-	 */
-	for (pfn = 0; pfn < max_pfn; pfn += P2M_PER_PAGE) {
-		unsigned topidx = p2m_top_index(pfn);
-		unsigned mididx = p2m_mid_index(pfn);
+static int xen_p2m_elem_type(unsigned long pfn)
+{
+	unsigned long mfn;
 
-		if (p2m_top[topidx] == p2m_mid_missing) {
-			unsigned long **mid = alloc_p2m_page();
-			p2m_mid_init(mid, p2m_missing);
+	if (pfn >= xen_p2m_size)
+		return P2M_TYPE_IDENTITY;
 
-			p2m_top[topidx] = mid;
-		}
+	mfn = xen_p2m_addr[pfn];
 
-		/*
-		 * As long as the mfn_list has enough entries to completely
-		 * fill a p2m page, pointing into the array is ok. But if
-		 * not the entries beyond the last pfn will be undefined.
-		 */
-		if (unlikely(pfn + P2M_PER_PAGE > max_pfn)) {
-			unsigned long p2midx;
+	if (mfn == INVALID_P2M_ENTRY)
+		return P2M_TYPE_MISSING;
 
-			p2midx = max_pfn % P2M_PER_PAGE;
-			for ( ; p2midx < P2M_PER_PAGE; p2midx++)
-				mfn_list[pfn + p2midx] = INVALID_P2M_ENTRY;
-		}
-		p2m_top[topidx][mididx] = &mfn_list[pfn];
-	}
+	if (mfn & IDENTITY_FRAME_BIT)
+		return P2M_TYPE_IDENTITY;
+
+	return P2M_TYPE_PFN;
 }
-#ifdef CONFIG_X86_64
-unsigned long __init xen_revector_p2m_tree(void)
+
+static void __init xen_rebuild_p2m_list(unsigned long *p2m)
 {
-	unsigned long va_start;
-	unsigned long va_end;
+	unsigned int i, chunk;
 	unsigned long pfn;
-	unsigned long pfn_free = 0;
-	unsigned long *mfn_list = NULL;
-	unsigned long size;
-
-	use_brk = 0;
-	va_start = xen_start_info->mfn_list;
-	/*We copy in increments of P2M_PER_PAGE * sizeof(unsigned long),
-	 * so make sure it is rounded up to that */
-	size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
-	va_end = va_start + size;
-
-	/* If we were revectored already, don't do it again. */
-	if (va_start <= __START_KERNEL_map && va_start >= __PAGE_OFFSET)
-		return 0;
-
-	mfn_list = alloc_bootmem_align(size, PAGE_SIZE);
-	if (!mfn_list) {
-		pr_warn("Could not allocate space for a new P2M tree!\n");
-		return xen_start_info->mfn_list;
-	}
-	/* Fill it out with INVALID_P2M_ENTRY value */
-	memset(mfn_list, 0xFF, size);
+	unsigned long *mfns;
+	pte_t *ptep;
+	pmd_t *pmdp;
+	int type;
 
-	for (pfn = 0; pfn < ALIGN(MAX_DOMAIN_PAGES, P2M_PER_PAGE); pfn += P2M_PER_PAGE) {
-		unsigned topidx = p2m_top_index(pfn);
-		unsigned mididx;
-		unsigned long *mid_p;
-
-		if (!p2m_top[topidx])
-			continue;
+	p2m_missing = alloc_p2m_page();
+	p2m_init(p2m_missing);
+	p2m_identity = alloc_p2m_page();
+	p2m_init(p2m_identity);
 
-		if (p2m_top[topidx] == p2m_mid_missing)
-			continue;
+	p2m_missing_pte = alloc_p2m_page();
+	paravirt_alloc_pte(&init_mm, __pa(p2m_missing_pte) >> PAGE_SHIFT);
+	p2m_identity_pte = alloc_p2m_page();
+	paravirt_alloc_pte(&init_mm, __pa(p2m_identity_pte) >> PAGE_SHIFT);
+	for (i = 0; i < PTRS_PER_PTE; i++) {
+		set_pte(p2m_missing_pte + i,
+			pfn_pte(PFN_DOWN(__pa(p2m_missing)), PAGE_KERNEL));
+		set_pte(p2m_identity_pte + i,
+			pfn_pte(PFN_DOWN(__pa(p2m_identity)), PAGE_KERNEL));
+	}
 
-		mididx = p2m_mid_index(pfn);
-		mid_p = p2m_top[topidx][mididx];
-		if (!mid_p)
-			continue;
-		if ((mid_p == p2m_missing) || (mid_p == p2m_identity))
+	for (pfn = 0; pfn < xen_max_p2m_pfn; pfn += chunk) {
+		/*
+		 * Try to map missing/identity PMDs or p2m-pages if possible.
+		 * We have to respect the structure of the mfn_list_list
+		 * which will be built just afterwards.
+		 * Chunk size to test is one p2m page if we are in the middle
+		 * of a mfn_list_list mid page and the complete mid page area
+		 * if we are at index 0 of the mid page. Please note that a
+		 * mid page might cover more than one PMD, e.g. on 32 bit PAE
+		 * kernels.
+		 */
+		chunk = (pfn & (P2M_PER_PAGE * P2M_MID_PER_PAGE - 1)) ?
+			P2M_PER_PAGE : P2M_PER_PAGE * P2M_MID_PER_PAGE;
+
+		type = xen_p2m_elem_type(pfn);
+		i = 0;
+		if (type != P2M_TYPE_PFN)
+			for (i = 1; i < chunk; i++)
+				if (xen_p2m_elem_type(pfn + i) != type)
+					break;
+		if (i < chunk)
+			/* Reset to minimal chunk size. */
+			chunk = P2M_PER_PAGE;
+
+		if (type == P2M_TYPE_PFN || i < chunk) {
+			/* Use initial p2m page contents. */
+#ifdef CONFIG_X86_64
+			mfns = alloc_p2m_page();
+			copy_page(mfns, xen_p2m_addr + pfn);
+#else
+			mfns = xen_p2m_addr + pfn;
+#endif
+			ptep = populate_extra_pte((unsigned long)(p2m + pfn));
+			set_pte(ptep,
+				pfn_pte(PFN_DOWN(__pa(mfns)), PAGE_KERNEL));
 			continue;
+		}
 
-		if ((unsigned long)mid_p == INVALID_P2M_ENTRY)
+		if (chunk == P2M_PER_PAGE) {
+			/* Map complete missing or identity p2m-page. */
+			mfns = (type == P2M_TYPE_MISSING) ?
+				p2m_missing : p2m_identity;
+			ptep = populate_extra_pte((unsigned long)(p2m + pfn));
+			set_pte(ptep,
+				pfn_pte(PFN_DOWN(__pa(mfns)), PAGE_KERNEL));
 			continue;
+		}
 
-		/* The old va. Rebase it on mfn_list */
-		if (mid_p >= (unsigned long *)va_start && mid_p <= (unsigned long *)va_end) {
-			unsigned long *new;
+		/* Complete missing or identity PMD(s) can be mapped. */
+		ptep = (type == P2M_TYPE_MISSING) ?
+			p2m_missing_pte : p2m_identity_pte;
+		for (i = 0; i < PMDS_PER_MID_PAGE; i++) {
+			pmdp = populate_extra_pmd(
+				(unsigned long)(p2m + pfn + i * PTRS_PER_PTE));
+			set_pmd(pmdp, __pmd(__pa(ptep) | _KERNPG_TABLE));
+		}
+	}
+}
 
-			if (pfn_free  > (size / sizeof(unsigned long))) {
-				WARN(1, "Only allocated for %ld pages, but we want %ld!\n",
-				     size / sizeof(unsigned long), pfn_free);
-				return 0;
-			}
-			new = &mfn_list[pfn_free];
+void __init xen_vmalloc_p2m_tree(void)
+{
+	static struct vm_struct vm;
 
-			copy_page(new, mid_p);
-			p2m_top[topidx][mididx] = &mfn_list[pfn_free];
+	vm.flags = VM_ALLOC;
+	vm.size = ALIGN(sizeof(unsigned long) * xen_max_p2m_pfn,
+			PMD_SIZE * PMDS_PER_MID_PAGE);
+	vm_area_register_early(&vm, PMD_SIZE * PMDS_PER_MID_PAGE);
+	pr_notice("p2m virtual area at %p, size is %lx\n", vm.addr, vm.size);
 
-			pfn_free += P2M_PER_PAGE;
+	xen_max_p2m_pfn = vm.size / sizeof(unsigned long);
 
-		}
-		/* This should be the leafs allocated for identity from _brk. */
-	}
+	xen_rebuild_p2m_list(vm.addr);
 
+	xen_p2m_addr = vm.addr;
 	xen_p2m_size = xen_max_p2m_pfn;
-	xen_p2m_addr = mfn_list;
 
 	xen_inv_extra_mem();
 
 	m2p_override_init();
-	return (unsigned long)mfn_list;
 }
-#else
-unsigned long __init xen_revector_p2m_tree(void)
-{
-	use_brk = 0;
-	xen_p2m_size = xen_max_p2m_pfn;
-	xen_inv_extra_mem();
-	m2p_override_init();
-	return 0;
-}
-#endif
+
 unsigned long get_phys_to_machine(unsigned long pfn)
 {
-	unsigned topidx, mididx, idx;
+	pte_t *ptep;
+	unsigned int level;
 
 	if (unlikely(pfn >= xen_p2m_size)) {
 		if (pfn < xen_max_p2m_pfn)
@@ -528,23 +414,83 @@ unsigned long get_phys_to_machine(unsigned long pfn)
 		return IDENTITY_FRAME(pfn);
 	}
 
-	topidx = p2m_top_index(pfn);
-	mididx = p2m_mid_index(pfn);
-	idx = p2m_index(pfn);
+	ptep = lookup_address((unsigned long)(xen_p2m_addr + pfn), &level);
+	BUG_ON(!ptep || level != PG_LEVEL_4K);
 
 	/*
 	 * The INVALID_P2M_ENTRY is filled in both p2m_*identity
 	 * and in p2m_*missing, so returning the INVALID_P2M_ENTRY
 	 * would be wrong.
 	 */
-	if (p2m_top[topidx][mididx] == p2m_identity)
+	if (pte_pfn(*ptep) == PFN_DOWN(__pa(p2m_identity)))
 		return IDENTITY_FRAME(pfn);
 
-	return p2m_top[topidx][mididx][idx];
+	return xen_p2m_addr[pfn];
 }
 EXPORT_SYMBOL_GPL(get_phys_to_machine);
 
 /*
+ * Allocate new pmd(s). It is checked whether the old pmd is still in place.
+ * If not, nothing is changed. This is okay as the only reason for allocating
+ * a new pmd is to replace p2m_missing_pte or p2m_identity_pte by a individual
+ * pmd. In case of PAE/x86-32 there are multiple pmds to allocate!
+ */
+static pte_t *alloc_p2m_pmd(unsigned long addr, pte_t *ptep, pte_t *pte_pg)
+{
+	pte_t *ptechk;
+	pte_t *pteret = ptep;
+	pte_t *pte_newpg[PMDS_PER_MID_PAGE];
+	pmd_t *pmdp;
+	unsigned int level;
+	unsigned long flags;
+	unsigned long vaddr;
+	int i;
+
+	/* Do all allocations first to bail out in error case. */
+	for (i = 0; i < PMDS_PER_MID_PAGE; i++) {
+		pte_newpg[i] = alloc_p2m_page();
+		if (!pte_newpg[i]) {
+			for (i--; i >= 0; i--)
+				free_p2m_page(pte_newpg[i]);
+
+			return NULL;
+		}
+	}
+
+	vaddr = addr & ~(PMD_SIZE * PMDS_PER_MID_PAGE - 1);
+
+	for (i = 0; i < PMDS_PER_MID_PAGE; i++) {
+		copy_page(pte_newpg[i], pte_pg);
+		paravirt_alloc_pte(&init_mm, __pa(pte_newpg[i]) >> PAGE_SHIFT);
+
+		pmdp = lookup_pmd_address(vaddr);
+		BUG_ON(!pmdp);
+
+		spin_lock_irqsave(&p2m_update_lock, flags);
+
+		ptechk = lookup_address(vaddr, &level);
+		if (ptechk == pte_pg) {
+			set_pmd(pmdp,
+				__pmd(__pa(pte_newpg[i]) | _KERNPG_TABLE));
+			if (vaddr == (addr & ~(PMD_SIZE - 1)))
+				pteret = pte_offset_kernel(pmdp, addr);
+			pte_newpg[i] = NULL;
+		}
+
+		spin_unlock_irqrestore(&p2m_update_lock, flags);
+
+		if (pte_newpg[i]) {
+			paravirt_release_pte(__pa(pte_newpg[i]) >> PAGE_SHIFT);
+			free_p2m_page(pte_newpg[i]);
+		}
+
+		vaddr += PMD_SIZE;
+	}
+
+	return pteret;
+}
+
+/*
  * Fully allocate the p2m structure for a given pfn.  We need to check
  * that both the top and mid levels are allocated, and make sure the
  * parallel mfn tree is kept in sync.  We may race with other cpus, so
@@ -554,58 +500,62 @@ EXPORT_SYMBOL_GPL(get_phys_to_machine);
 static bool alloc_p2m(unsigned long pfn)
 {
 	unsigned topidx, mididx;
-	unsigned long ***top_p, **mid;
 	unsigned long *top_mfn_p, *mid_mfn;
-	unsigned long *p2m_orig;
+	pte_t *ptep, *pte_pg;
+	unsigned int level;
+	unsigned long flags;
+	unsigned long addr = (unsigned long)(xen_p2m_addr + pfn);
+	unsigned long p2m_pfn;
 
 	topidx = p2m_top_index(pfn);
 	mididx = p2m_mid_index(pfn);
 
-	top_p = &p2m_top[topidx];
-	mid = ACCESS_ONCE(*top_p);
+	ptep = lookup_address(addr, &level);
+	BUG_ON(!ptep || level != PG_LEVEL_4K);
+	pte_pg = (pte_t *)((unsigned long)ptep & ~(PAGE_SIZE - 1));
 
-	if (mid == p2m_mid_missing) {
-		/* Mid level is missing, allocate a new one */
-		mid = alloc_p2m_page();
-		if (!mid)
+	if (pte_pg == p2m_missing_pte || pte_pg == p2m_identity_pte) {
+		/* PMD level is missing, allocate a new one */
+		ptep = alloc_p2m_pmd(addr, ptep, pte_pg);
+		if (!ptep)
 			return false;
-
-		p2m_mid_init(mid, p2m_missing);
-
-		if (cmpxchg(top_p, p2m_mid_missing, mid) != p2m_mid_missing)
-			free_p2m_page(mid);
 	}
 
-	top_mfn_p = &p2m_top_mfn[topidx];
-	mid_mfn = ACCESS_ONCE(p2m_top_mfn_p[topidx]);
+	if (p2m_top_mfn) {
+		top_mfn_p = &p2m_top_mfn[topidx];
+		mid_mfn = ACCESS_ONCE(p2m_top_mfn_p[topidx]);
 
-	BUG_ON(virt_to_mfn(mid_mfn) != *top_mfn_p);
+		BUG_ON(virt_to_mfn(mid_mfn) != *top_mfn_p);
 
-	if (mid_mfn == p2m_mid_missing_mfn) {
-		/* Separately check the mid mfn level */
-		unsigned long missing_mfn;
-		unsigned long mid_mfn_mfn;
-		unsigned long old_mfn;
+		if (mid_mfn == p2m_mid_missing_mfn) {
+			/* Separately check the mid mfn level */
+			unsigned long missing_mfn;
+			unsigned long mid_mfn_mfn;
+			unsigned long old_mfn;
 
-		mid_mfn = alloc_p2m_page();
-		if (!mid_mfn)
-			return false;
+			mid_mfn = alloc_p2m_page();
+			if (!mid_mfn)
+				return false;
 
-		p2m_mid_mfn_init(mid_mfn, p2m_missing);
+			p2m_mid_mfn_init(mid_mfn, p2m_missing);
 
-		missing_mfn = virt_to_mfn(p2m_mid_missing_mfn);
-		mid_mfn_mfn = virt_to_mfn(mid_mfn);
-		old_mfn = cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn);
-		if (old_mfn != missing_mfn) {
-			free_p2m_page(mid_mfn);
-			mid_mfn = mfn_to_virt(old_mfn);
-		} else {
-			p2m_top_mfn_p[topidx] = mid_mfn;
+			missing_mfn = virt_to_mfn(p2m_mid_missing_mfn);
+			mid_mfn_mfn = virt_to_mfn(mid_mfn);
+			old_mfn = cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn);
+			if (old_mfn != missing_mfn) {
+				free_p2m_page(mid_mfn);
+				mid_mfn = mfn_to_virt(old_mfn);
+			} else {
+				p2m_top_mfn_p[topidx] = mid_mfn;
+			}
 		}
+	} else {
+		mid_mfn = NULL;
 	}
 
-	p2m_orig = ACCESS_ONCE(p2m_top[topidx][mididx]);
-	if (p2m_orig == p2m_identity || p2m_orig == p2m_missing) {
+	p2m_pfn = pte_pfn(ACCESS_ONCE(*ptep));
+	if (p2m_pfn == PFN_DOWN(__pa(p2m_identity)) ||
+	    p2m_pfn == PFN_DOWN(__pa(p2m_missing))) {
 		/* p2m leaf page is missing */
 		unsigned long *p2m;
 
@@ -613,12 +563,25 @@ static bool alloc_p2m(unsigned long pfn)
 		if (!p2m)
 			return false;
 
-		p2m_init(p2m);
+		if (p2m_pfn == PFN_DOWN(__pa(p2m_missing)))
+			p2m_init(p2m);
+		else
+			p2m_init_identity(p2m, pfn);
+
+		spin_lock_irqsave(&p2m_update_lock, flags);
+
+		if (pte_pfn(*ptep) == p2m_pfn) {
+			set_pte(ptep,
+				pfn_pte(PFN_DOWN(__pa(p2m)), PAGE_KERNEL));
+			if (mid_mfn)
+				mid_mfn[mididx] = virt_to_mfn(p2m);
+			p2m = NULL;
+		}
+
+		spin_unlock_irqrestore(&p2m_update_lock, flags);
 
-		if (cmpxchg(&mid[mididx], p2m_orig, p2m) != p2m_orig)
+		if (p2m)
 			free_p2m_page(p2m);
-		else
-			mid_mfn[mididx] = virt_to_mfn(p2m);
 	}
 
 	return true;
@@ -647,10 +610,10 @@ unsigned long __init set_phys_range_identity(unsigned long pfn_s,
 	return pfn - pfn_s;
 }
 
-/* Try to install p2m mapping; fail if intermediate bits missing */
 bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
-	unsigned topidx, mididx, idx;
+	pte_t *ptep;
+	unsigned int level;
 
 	/* don't track P2M changes in autotranslate guests */
 	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap)))
@@ -661,55 +624,27 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 		return true;
 	}
 
-	topidx = p2m_top_index(pfn);
-	mididx = p2m_mid_index(pfn);
-	idx = p2m_index(pfn);
-
-	/* For sparse holes were the p2m leaf has real PFN along with
-	 * PCI holes, stick in the PFN as the MFN value.
-	 *
-	 * set_phys_range_identity() will have allocated new middle
-	 * and leaf pages as required so an existing p2m_mid_missing
-	 * or p2m_missing mean that whole range will be identity so
-	 * these can be switched to p2m_mid_identity or p2m_identity.
-	 */
-	if (mfn != INVALID_P2M_ENTRY && (mfn & IDENTITY_FRAME_BIT)) {
-		if (p2m_top[topidx] == p2m_mid_identity)
-			return true;
-
-		if (p2m_top[topidx] == p2m_mid_missing) {
-			WARN_ON(cmpxchg(&p2m_top[topidx], p2m_mid_missing,
-					p2m_mid_identity) != p2m_mid_missing);
-			return true;
-		}
-
-		if (p2m_top[topidx][mididx] == p2m_identity)
-			return true;
-
-		/* Swap over from MISSING to IDENTITY if needed. */
-		if (p2m_top[topidx][mididx] == p2m_missing) {
-			WARN_ON(cmpxchg(&p2m_top[topidx][mididx], p2m_missing,
-				p2m_identity) != p2m_missing);
-			return true;
-		}
-	}
+	ptep = lookup_address((unsigned long)(xen_p2m_addr + pfn), &level);
+	BUG_ON(!ptep || level != PG_LEVEL_4K);
 
-	if (p2m_top[topidx][mididx] == p2m_missing)
+	if (pte_pfn(*ptep) == PFN_DOWN(__pa(p2m_missing)))
 		return mfn == INVALID_P2M_ENTRY;
 
-	p2m_top[topidx][mididx][idx] = mfn;
+	if (pte_pfn(*ptep) == PFN_DOWN(__pa(p2m_identity)))
+		return mfn == IDENTITY_FRAME(pfn);
+
+	xen_p2m_addr[pfn] = mfn;
 
 	return true;
 }
 
 bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
-	if (unlikely(!__set_phys_to_machine(pfn, mfn)))  {
+	if (unlikely(!__set_phys_to_machine(pfn, mfn))) {
 		if (!alloc_p2m(pfn))
 			return false;
 
-		if (!__set_phys_to_machine(pfn, mfn))
-			return false;
+		return __set_phys_to_machine(pfn, mfn);
 	}
 
 	return true;
@@ -1035,79 +970,29 @@ EXPORT_SYMBOL_GPL(m2p_find_override_pfn);
 #include "debugfs.h"
 static int p2m_dump_show(struct seq_file *m, void *v)
 {
-	static const char * const level_name[] = { "top", "middle",
-						"entry", "abnormal", "error"};
-#define TYPE_IDENTITY 0
-#define TYPE_MISSING 1
-#define TYPE_PFN 2
-#define TYPE_UNKNOWN 3
 	static const char * const type_name[] = {
-				[TYPE_IDENTITY] = "identity",
-				[TYPE_MISSING] = "missing",
-				[TYPE_PFN] = "pfn",
-				[TYPE_UNKNOWN] = "abnormal"};
-	unsigned long pfn, prev_pfn_type = 0, prev_pfn_level = 0;
-	unsigned int uninitialized_var(prev_level);
-	unsigned int uninitialized_var(prev_type);
-
-	if (!p2m_top)
-		return 0;
-
-	for (pfn = 0; pfn < MAX_DOMAIN_PAGES; pfn++) {
-		unsigned topidx = p2m_top_index(pfn);
-		unsigned mididx = p2m_mid_index(pfn);
-		unsigned idx = p2m_index(pfn);
-		unsigned lvl, type;
-
-		lvl = 4;
-		type = TYPE_UNKNOWN;
-		if (p2m_top[topidx] == p2m_mid_missing) {
-			lvl = 0; type = TYPE_MISSING;
-		} else if (p2m_top[topidx] == NULL) {
-			lvl = 0; type = TYPE_UNKNOWN;
-		} else if (p2m_top[topidx][mididx] == NULL) {
-			lvl = 1; type = TYPE_UNKNOWN;
-		} else if (p2m_top[topidx][mididx] == p2m_identity) {
-			lvl = 1; type = TYPE_IDENTITY;
-		} else if (p2m_top[topidx][mididx] == p2m_missing) {
-			lvl = 1; type = TYPE_MISSING;
-		} else if (p2m_top[topidx][mididx][idx] == 0) {
-			lvl = 2; type = TYPE_UNKNOWN;
-		} else if (p2m_top[topidx][mididx][idx] == IDENTITY_FRAME(pfn)) {
-			lvl = 2; type = TYPE_IDENTITY;
-		} else if (p2m_top[topidx][mididx][idx] == INVALID_P2M_ENTRY) {
-			lvl = 2; type = TYPE_MISSING;
-		} else if (p2m_top[topidx][mididx][idx] == pfn) {
-			lvl = 2; type = TYPE_PFN;
-		} else if (p2m_top[topidx][mididx][idx] != pfn) {
-			lvl = 2; type = TYPE_PFN;
-		}
-		if (pfn == 0) {
-			prev_level = lvl;
+				[P2M_TYPE_IDENTITY] = "identity",
+				[P2M_TYPE_MISSING] = "missing",
+				[P2M_TYPE_PFN] = "pfn",
+				[P2M_TYPE_UNKNOWN] = "abnormal"};
+	unsigned long pfn, first_pfn;
+	int type, prev_type;
+
+	prev_type = xen_p2m_elem_type(0);
+	first_pfn = 0;
+
+	for (pfn = 0; pfn < xen_p2m_size; pfn++) {
+		type = xen_p2m_elem_type(pfn);
+		if (type != prev_type) {
+			seq_printf(m, " [0x%lx->0x%lx] %s\n", first_pfn, pfn,
+				   type_name[prev_type]);
 			prev_type = type;
-		}
-		if (pfn == MAX_DOMAIN_PAGES-1) {
-			lvl = 3;
-			type = TYPE_UNKNOWN;
-		}
-		if (prev_type != type) {
-			seq_printf(m, " [0x%lx->0x%lx] %s\n",
-				prev_pfn_type, pfn, type_name[prev_type]);
-			prev_pfn_type = pfn;
-			prev_type = type;
-		}
-		if (prev_level != lvl) {
-			seq_printf(m, " [0x%lx->0x%lx] level %s\n",
-				prev_pfn_level, pfn, level_name[prev_level]);
-			prev_pfn_level = pfn;
-			prev_level = lvl;
+			first_pfn = pfn;
 		}
 	}
+	seq_printf(m, " [0x%lx->0x%lx] %s\n", first_pfn, pfn,
+		   type_name[prev_type]);
 	return 0;
-#undef TYPE_IDENTITY
-#undef TYPE_MISSING
-#undef TYPE_PFN
-#undef TYPE_UNKNOWN
 }
 
 static int p2m_dump_open(struct inode *inode, struct file *filp)
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 02b0b0f..f92921f 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -49,7 +49,7 @@ void xen_hvm_init_shared_info(void);
 void xen_unplug_emulated_devices(void);
 
 void __init xen_build_dynamic_phys_to_machine(void);
-unsigned long __init xen_revector_p2m_tree(void);
+void __init xen_vmalloc_p2m_tree(void);
 
 void xen_init_irq_ops(void);
 void xen_setup_timer(int cpu);
-- 
2.1.2

