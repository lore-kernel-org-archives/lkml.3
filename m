Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaK1K5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:57:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaK1KyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:54:06 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andrew.cooper3@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V4 04/10] xen: Delay remapping memory of pv-domain
Date: Fri, 28 Nov 2014 11:53:53 +0100
Message-Id: <1417172039-8627-5-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417172039-8627-1-git-send-email-jgross@suse.com>
References: <1417172039-8627-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Early in the boot process the memory layout of a pv-domain is changed
to match the E820 map (either the host one for Dom0 or the Xen one)
regarding placement of RAM and PCI holes. This requires removing memory
pages initially located at positions not suitable for RAM and adding
them later at higher addresses where no restrictions apply.

To be able to operate on the hypervisor supported p2m list until a
virtual mapped linear p2m list can be constructed, remapping must
be delayed until virtual memory management is initialized, as the
initial p2m list can't be extended unlimited at physical memory
initialization time due to it's fixed structure.

A further advantage is the reduction in complexity and code volume as
we don't have to be careful regarding memory restrictions during p2m
updates.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/include/asm/xen/page.h |   1 -
 arch/x86/xen/mmu.c              |   4 +
 arch/x86/xen/p2m.c              |  94 ----------
 arch/x86/xen/setup.c            | 369 ++++++++++++++++++----------------------
 arch/x86/xen/xen-ops.h          |   1 +
 5 files changed, 172 insertions(+), 297 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 6c16451..b475297 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -44,7 +44,6 @@ extern unsigned long  machine_to_phys_nr;
 
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern bool set_phys_to_machine(unsigned long pfn, unsigned long mfn);
-extern bool __init early_set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 extern bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 extern unsigned long set_phys_range_identity(unsigned long pfn_s,
 					     unsigned long pfn_e);
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b995b871..601914d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1225,6 +1225,10 @@ static void __init xen_pagetable_init(void)
 	/* Allocate and initialize top and mid mfn levels for p2m structure */
 	xen_build_mfn_list_list();
 
+	/* Remap memory freed due to conflicts with E820 map */
+	if (!xen_feature(XENFEAT_auto_translated_physmap))
+		xen_remap_memory();
+
 	xen_setup_shared_info();
 	xen_post_allocator_init();
 }
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index fa53dc2..24cd9d1 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -662,100 +662,6 @@ static bool __init early_alloc_p2m_middle(unsigned long pfn)
 	return true;
 }
 
-/*
- * Skim over the P2M tree looking at pages that are either filled with
- * INVALID_P2M_ENTRY or with 1:1 PFNs. If found, re-use that page and
- * replace the P2M leaf with a p2m_missing or p2m_identity.
- * Stick the old page in the new P2M tree location.
- */
-static bool __init early_can_reuse_p2m_middle(unsigned long set_pfn)
-{
-	unsigned topidx;
-	unsigned mididx;
-	unsigned ident_pfns;
-	unsigned inv_pfns;
-	unsigned long *p2m;
-	unsigned idx;
-	unsigned long pfn;
-
-	/* We only look when this entails a P2M middle layer */
-	if (p2m_index(set_pfn))
-		return false;
-
-	for (pfn = 0; pfn < MAX_DOMAIN_PAGES; pfn += P2M_PER_PAGE) {
-		topidx = p2m_top_index(pfn);
-
-		if (!p2m_top[topidx])
-			continue;
-
-		if (p2m_top[topidx] == p2m_mid_missing)
-			continue;
-
-		mididx = p2m_mid_index(pfn);
-		p2m = p2m_top[topidx][mididx];
-		if (!p2m)
-			continue;
-
-		if ((p2m == p2m_missing) || (p2m == p2m_identity))
-			continue;
-
-		if ((unsigned long)p2m == INVALID_P2M_ENTRY)
-			continue;
-
-		ident_pfns = 0;
-		inv_pfns = 0;
-		for (idx = 0; idx < P2M_PER_PAGE; idx++) {
-			/* IDENTITY_PFNs are 1:1 */
-			if (p2m[idx] == IDENTITY_FRAME(pfn + idx))
-				ident_pfns++;
-			else if (p2m[idx] == INVALID_P2M_ENTRY)
-				inv_pfns++;
-			else
-				break;
-		}
-		if ((ident_pfns == P2M_PER_PAGE) || (inv_pfns == P2M_PER_PAGE))
-			goto found;
-	}
-	return false;
-found:
-	/* Found one, replace old with p2m_identity or p2m_missing */
-	p2m_top[topidx][mididx] = (ident_pfns ? p2m_identity : p2m_missing);
-
-	/* Reset where we want to stick the old page in. */
-	topidx = p2m_top_index(set_pfn);
-	mididx = p2m_mid_index(set_pfn);
-
-	/* This shouldn't happen */
-	if (WARN_ON(p2m_top[topidx] == p2m_mid_missing))
-		early_alloc_p2m_middle(set_pfn);
-
-	if (WARN_ON(p2m_top[topidx][mididx] != p2m_missing))
-		return false;
-
-	p2m_init(p2m);
-	p2m_top[topidx][mididx] = p2m;
-
-	return true;
-}
-bool __init early_set_phys_to_machine(unsigned long pfn, unsigned long mfn)
-{
-	if (unlikely(!__set_phys_to_machine(pfn, mfn)))  {
-		if (!early_alloc_p2m_middle(pfn))
-			return false;
-
-		if (early_can_reuse_p2m_middle(pfn))
-			return __set_phys_to_machine(pfn, mfn);
-
-		if (!early_alloc_p2m(pfn, false /* boundary crossover OK!*/))
-			return false;
-
-		if (!__set_phys_to_machine(pfn, mfn))
-			return false;
-	}
-
-	return true;
-}
-
 static void __init early_split_p2m(unsigned long pfn)
 {
 	unsigned long mididx, idx;
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 29834b3..e0b6912f 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -30,6 +30,7 @@
 #include "xen-ops.h"
 #include "vdso.h"
 #include "p2m.h"
+#include "mmu.h"
 
 /* These are code, but not functions.  Defined in entry.S */
 extern const char xen_hypervisor_callback[];
@@ -47,8 +48,19 @@ struct xen_memory_region xen_extra_mem[XEN_EXTRA_MEM_MAX_REGIONS] __initdata;
 /* Number of pages released from the initial allocation. */
 unsigned long xen_released_pages;
 
-/* Buffer used to remap identity mapped pages */
-unsigned long xen_remap_buf[P2M_PER_PAGE] __initdata;
+/*
+ * Buffer used to remap identity mapped pages. We only need the virtual space.
+ * The physical page behind this address is remapped as needed to different
+ * buffer pages.
+ */
+#define REMAP_SIZE	(P2M_PER_PAGE - 3)
+static struct {
+	unsigned long	next_area_mfn;
+	unsigned long	target_pfn;
+	unsigned long	size;
+	unsigned long	mfns[REMAP_SIZE];
+} xen_remap_buf __initdata __aligned(PAGE_SIZE);
+static unsigned long xen_remap_mfn __initdata = INVALID_P2M_ENTRY;
 
 /* 
  * The maximum amount of extra memory compared to the base size.  The
@@ -98,63 +110,6 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
 	}
 }
 
-static unsigned long __init xen_do_chunk(unsigned long start,
-					 unsigned long end, bool release)
-{
-	struct xen_memory_reservation reservation = {
-		.address_bits = 0,
-		.extent_order = 0,
-		.domid        = DOMID_SELF
-	};
-	unsigned long len = 0;
-	unsigned long pfn;
-	int ret;
-
-	for (pfn = start; pfn < end; pfn++) {
-		unsigned long frame;
-		unsigned long mfn = pfn_to_mfn(pfn);
-
-		if (release) {
-			/* Make sure pfn exists to start with */
-			if (mfn == INVALID_P2M_ENTRY || mfn_to_pfn(mfn) != pfn)
-				continue;
-			frame = mfn;
-		} else {
-			if (mfn != INVALID_P2M_ENTRY)
-				continue;
-			frame = pfn;
-		}
-		set_xen_guest_handle(reservation.extent_start, &frame);
-		reservation.nr_extents = 1;
-
-		ret = HYPERVISOR_memory_op(release ? XENMEM_decrease_reservation : XENMEM_populate_physmap,
-					   &reservation);
-		WARN(ret != 1, "Failed to %s pfn %lx err=%d\n",
-		     release ? "release" : "populate", pfn, ret);
-
-		if (ret == 1) {
-			if (!early_set_phys_to_machine(pfn, release ? INVALID_P2M_ENTRY : frame)) {
-				if (release)
-					break;
-				set_xen_guest_handle(reservation.extent_start, &frame);
-				reservation.nr_extents = 1;
-				ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
-							   &reservation);
-				break;
-			}
-			len++;
-		} else
-			break;
-	}
-	if (len)
-		printk(KERN_INFO "%s %lx-%lx pfn range: %lu pages %s\n",
-		       release ? "Freeing" : "Populating",
-		       start, end, len,
-		       release ? "freed" : "added");
-
-	return len;
-}
-
 /*
  * Finds the next RAM pfn available in the E820 map after min_pfn.
  * This function updates min_pfn with the pfn found and returns
@@ -198,26 +153,62 @@ static unsigned long __init xen_find_pfn_range(
 	return done;
 }
 
+static int __init xen_free_mfn(unsigned long mfn)
+{
+	struct xen_memory_reservation reservation = {
+		.address_bits = 0,
+		.extent_order = 0,
+		.domid        = DOMID_SELF
+	};
+
+	set_xen_guest_handle(reservation.extent_start, &mfn);
+	reservation.nr_extents = 1;
+
+	return HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
+}
+
 /*
- * This releases a chunk of memory and then does the identity map. It's used as
+ * This releases a chunk of memory and then does the identity map. It's used
  * as a fallback if the remapping fails.
  */
 static void __init xen_set_identity_and_release_chunk(unsigned long start_pfn,
 	unsigned long end_pfn, unsigned long nr_pages, unsigned long *identity,
 	unsigned long *released)
 {
+	unsigned long len = 0;
+	unsigned long pfn, end;
+	int ret;
+
 	WARN_ON(start_pfn > end_pfn);
 
+	end = min(end_pfn, nr_pages);
+	for (pfn = start_pfn; pfn < end; pfn++) {
+		unsigned long mfn = pfn_to_mfn(pfn);
+
+		/* Make sure pfn exists to start with */
+		if (mfn == INVALID_P2M_ENTRY || mfn_to_pfn(mfn) != pfn)
+			continue;
+
+		ret = xen_free_mfn(mfn);
+		WARN(ret != 1, "Failed to release pfn %lx err=%d\n", pfn, ret);
+
+		if (ret == 1) {
+			if (!__set_phys_to_machine(pfn, INVALID_P2M_ENTRY))
+				break;
+			len++;
+		} else
+			break;
+	}
+
 	/* Need to release pages first */
-	*released += xen_do_chunk(start_pfn, min(end_pfn, nr_pages), true);
+	*released += len;
 	*identity += set_phys_range_identity(start_pfn, end_pfn);
 }
 
 /*
- * Helper function to update both the p2m and m2p tables.
+ * Helper function to update the p2m and m2p tables and kernel mapping.
  */
-static unsigned long __init xen_update_mem_tables(unsigned long pfn,
-						  unsigned long mfn)
+static void __init xen_update_mem_tables(unsigned long pfn, unsigned long mfn)
 {
 	struct mmu_update update = {
 		.ptr = ((unsigned long long)mfn << PAGE_SHIFT) | MMU_MACHPHYS_UPDATE,
@@ -225,161 +216,91 @@ static unsigned long __init xen_update_mem_tables(unsigned long pfn,
 	};
 
 	/* Update p2m */
-	if (!early_set_phys_to_machine(pfn, mfn)) {
+	if (!set_phys_to_machine(pfn, mfn)) {
 		WARN(1, "Failed to set p2m mapping for pfn=%ld mfn=%ld\n",
 		     pfn, mfn);
-		return false;
+		BUG();
 	}
 
 	/* Update m2p */
 	if (HYPERVISOR_mmu_update(&update, 1, NULL, DOMID_SELF) < 0) {
 		WARN(1, "Failed to set m2p mapping for mfn=%ld pfn=%ld\n",
 		     mfn, pfn);
-		return false;
+		BUG();
 	}
 
-	return true;
+	/* Update kernel mapping, but not for highmem. */
+	if ((pfn << PAGE_SHIFT) >= __pa(high_memory))
+		return;
+
+	if (HYPERVISOR_update_va_mapping((unsigned long)__va(pfn << PAGE_SHIFT),
+					 mfn_pte(mfn, PAGE_KERNEL), 0)) {
+		WARN(1, "Failed to update kernel mapping for mfn=%ld pfn=%ld\n",
+		      mfn, pfn);
+		BUG();
+	}
 }
 
 /*
  * This function updates the p2m and m2p tables with an identity map from
- * start_pfn to start_pfn+size and remaps the underlying RAM of the original
- * allocation at remap_pfn. It must do so carefully in P2M_PER_PAGE sized blocks
- * to not exhaust the reserved brk space. Doing it in properly aligned blocks
- * ensures we only allocate the minimum required leaf pages in the p2m table. It
- * copies the existing mfns from the p2m table under the 1:1 map, overwrites
- * them with the identity map and then updates the p2m and m2p tables with the
- * remapped memory.
+ * start_pfn to start_pfn+size and prepares remapping the underlying RAM of the
+ * original allocation at remap_pfn. The information needed for remapping is
+ * saved in the memory itself to avoid the need for allocating buffers. The
+ * complete remap information is contained in a list of MFNs each containing
+ * up to REMAP_SIZE MFNs and the start target PFN for doing the remap.
+ * This enables us to preserve the original mfn sequence while doing the
+ * remapping at a time when the memory management is capable of allocating
+ * virtual and physical memory in arbitrary amounts, see 'xen_remap_memory' and
+ * its callers.
  */
-static unsigned long __init xen_do_set_identity_and_remap_chunk(
+static void __init xen_do_set_identity_and_remap_chunk(
         unsigned long start_pfn, unsigned long size, unsigned long remap_pfn)
 {
+	unsigned long buf = (unsigned long)&xen_remap_buf;
+	unsigned long mfn_save, mfn;
 	unsigned long ident_pfn_iter, remap_pfn_iter;
-	unsigned long ident_start_pfn_align, remap_start_pfn_align;
-	unsigned long ident_end_pfn_align, remap_end_pfn_align;
-	unsigned long ident_boundary_pfn, remap_boundary_pfn;
-	unsigned long ident_cnt = 0;
-	unsigned long remap_cnt = 0;
+	unsigned long ident_end_pfn = start_pfn + size;
 	unsigned long left = size;
-	unsigned long mod;
-	int i;
+	unsigned long ident_cnt = 0;
+	unsigned int i, chunk;
 
 	WARN_ON(size == 0);
 
 	BUG_ON(xen_feature(XENFEAT_auto_translated_physmap));
 
-	/*
-	 * Determine the proper alignment to remap memory in P2M_PER_PAGE sized
-	 * blocks. We need to keep track of both the existing pfn mapping and
-	 * the new pfn remapping.
-	 */
-	mod = start_pfn % P2M_PER_PAGE;
-	ident_start_pfn_align =
-		mod ? (start_pfn - mod + P2M_PER_PAGE) : start_pfn;
-	mod = remap_pfn % P2M_PER_PAGE;
-	remap_start_pfn_align =
-		mod ? (remap_pfn - mod + P2M_PER_PAGE) : remap_pfn;
-	mod = (start_pfn + size) % P2M_PER_PAGE;
-	ident_end_pfn_align = start_pfn + size - mod;
-	mod = (remap_pfn + size) % P2M_PER_PAGE;
-	remap_end_pfn_align = remap_pfn + size - mod;
-
-	/* Iterate over each p2m leaf node in each range */
-	for (ident_pfn_iter = ident_start_pfn_align, remap_pfn_iter = remap_start_pfn_align;
-	     ident_pfn_iter < ident_end_pfn_align && remap_pfn_iter < remap_end_pfn_align;
-	     ident_pfn_iter += P2M_PER_PAGE, remap_pfn_iter += P2M_PER_PAGE) {
-		/* Check we aren't past the end */
-		BUG_ON(ident_pfn_iter + P2M_PER_PAGE > start_pfn + size);
-		BUG_ON(remap_pfn_iter + P2M_PER_PAGE > remap_pfn + size);
-
-		/* Save p2m mappings */
-		for (i = 0; i < P2M_PER_PAGE; i++)
-			xen_remap_buf[i] = pfn_to_mfn(ident_pfn_iter + i);
-
-		/* Set identity map which will free a p2m leaf */
-		ident_cnt += set_phys_range_identity(ident_pfn_iter,
-			ident_pfn_iter + P2M_PER_PAGE);
-
-#ifdef DEBUG
-		/* Helps verify a p2m leaf has been freed */
-		for (i = 0; i < P2M_PER_PAGE; i++) {
-			unsigned int pfn = ident_pfn_iter + i;
-			BUG_ON(pfn_to_mfn(pfn) != pfn);
-		}
-#endif
-		/* Now remap memory */
-		for (i = 0; i < P2M_PER_PAGE; i++) {
-			unsigned long mfn = xen_remap_buf[i];
-
-			/* This will use the p2m leaf freed above */
-			if (!xen_update_mem_tables(remap_pfn_iter + i, mfn)) {
-				WARN(1, "Failed to update mem mapping for pfn=%ld mfn=%ld\n",
-					remap_pfn_iter + i, mfn);
-				return 0;
-			}
-
-			remap_cnt++;
-		}
+	/* Don't use memory until remapped */
+	memblock_reserve(PFN_PHYS(remap_pfn), PFN_PHYS(size));
 
-		left -= P2M_PER_PAGE;
-	}
-
-	/* Max boundary space possible */
-	BUG_ON(left > (P2M_PER_PAGE - 1) * 2);
+	mfn_save = virt_to_mfn(buf);
 
-	/* Now handle the boundary conditions */
-	ident_boundary_pfn = start_pfn;
-	remap_boundary_pfn = remap_pfn;
-	for (i = 0; i < left; i++) {
-		unsigned long mfn;
+	for (ident_pfn_iter = start_pfn, remap_pfn_iter = remap_pfn;
+	     ident_pfn_iter < ident_end_pfn;
+	     ident_pfn_iter += REMAP_SIZE, remap_pfn_iter += REMAP_SIZE) {
+		chunk = (left < REMAP_SIZE) ? left : REMAP_SIZE;
 
-		/* These two checks move from the start to end boundaries */
-		if (ident_boundary_pfn == ident_start_pfn_align)
-			ident_boundary_pfn = ident_pfn_iter;
-		if (remap_boundary_pfn == remap_start_pfn_align)
-			remap_boundary_pfn = remap_pfn_iter;
+		/* Map first pfn to xen_remap_buf */
+		mfn = pfn_to_mfn(ident_pfn_iter);
+		set_pte_mfn(buf, mfn, PAGE_KERNEL);
 
-		/* Check we aren't past the end */
-		BUG_ON(ident_boundary_pfn >= start_pfn + size);
-		BUG_ON(remap_boundary_pfn >= remap_pfn + size);
+		/* Save mapping information in page */
+		xen_remap_buf.next_area_mfn = xen_remap_mfn;
+		xen_remap_buf.target_pfn = remap_pfn_iter;
+		xen_remap_buf.size = chunk;
+		for (i = 0; i < chunk; i++)
+			xen_remap_buf.mfns[i] = pfn_to_mfn(ident_pfn_iter + i);
 
-		mfn = pfn_to_mfn(ident_boundary_pfn);
+		/* Put remap buf into list. */
+		xen_remap_mfn = mfn;
 
-		if (!xen_update_mem_tables(remap_boundary_pfn, mfn)) {
-			WARN(1, "Failed to update mem mapping for pfn=%ld mfn=%ld\n",
-				remap_pfn_iter + i, mfn);
-			return 0;
-		}
-		remap_cnt++;
-
-		ident_boundary_pfn++;
-		remap_boundary_pfn++;
-	}
+		/* Set identity map */
+		ident_cnt += set_phys_range_identity(ident_pfn_iter,
+			ident_pfn_iter + chunk);
 
-	/* Finish up the identity map */
-	if (ident_start_pfn_align >= ident_end_pfn_align) {
-		/*
-                 * In this case we have an identity range which does not span an
-                 * aligned block so everything needs to be identity mapped here.
-                 * If we didn't check this we might remap too many pages since
-                 * the align boundaries are not meaningful in this case.
-	         */
-		ident_cnt += set_phys_range_identity(start_pfn,
-			start_pfn + size);
-	} else {
-		/* Remapped above so check each end of the chunk */
-		if (start_pfn < ident_start_pfn_align)
-			ident_cnt += set_phys_range_identity(start_pfn,
-				ident_start_pfn_align);
-		if (start_pfn + size > ident_pfn_iter)
-			ident_cnt += set_phys_range_identity(ident_pfn_iter,
-				start_pfn + size);
+		left -= chunk;
 	}
 
-	BUG_ON(ident_cnt != size);
-	BUG_ON(remap_cnt != size);
-
-	return size;
+	/* Restore old xen_remap_buf mapping */
+	set_pte_mfn(buf, mfn_save, PAGE_KERNEL);
 }
 
 /*
@@ -396,8 +317,7 @@ static unsigned long __init xen_do_set_identity_and_remap_chunk(
 static unsigned long __init xen_set_identity_and_remap_chunk(
         const struct e820entry *list, size_t map_size, unsigned long start_pfn,
 	unsigned long end_pfn, unsigned long nr_pages, unsigned long remap_pfn,
-	unsigned long *identity, unsigned long *remapped,
-	unsigned long *released)
+	unsigned long *identity, unsigned long *released)
 {
 	unsigned long pfn;
 	unsigned long i = 0;
@@ -431,19 +351,12 @@ static unsigned long __init xen_set_identity_and_remap_chunk(
 		if (size > remap_range_size)
 			size = remap_range_size;
 
-		if (!xen_do_set_identity_and_remap_chunk(cur_pfn, size, remap_pfn)) {
-			WARN(1, "Failed to remap 1:1 memory cur_pfn=%ld size=%ld remap_pfn=%ld\n",
-				cur_pfn, size, remap_pfn);
-			xen_set_identity_and_release_chunk(cur_pfn,
-				cur_pfn + left, nr_pages, identity, released);
-			break;
-		}
+		xen_do_set_identity_and_remap_chunk(cur_pfn, size, remap_pfn);
 
 		/* Update variables to reflect new mappings. */
 		i += size;
 		remap_pfn += size;
 		*identity += size;
-		*remapped += size;
 	}
 
 	/*
@@ -464,7 +377,6 @@ static unsigned long __init xen_set_identity_and_remap(
 {
 	phys_addr_t start = 0;
 	unsigned long identity = 0;
-	unsigned long remapped = 0;
 	unsigned long last_pfn = nr_pages;
 	const struct e820entry *entry;
 	unsigned long num_released = 0;
@@ -494,8 +406,7 @@ static unsigned long __init xen_set_identity_and_remap(
 				last_pfn = xen_set_identity_and_remap_chunk(
 						list, map_size, start_pfn,
 						end_pfn, nr_pages, last_pfn,
-						&identity, &remapped,
-						&num_released);
+						&identity, &num_released);
 			start = end;
 		}
 	}
@@ -503,12 +414,65 @@ static unsigned long __init xen_set_identity_and_remap(
 	*released = num_released;
 
 	pr_info("Set %ld page(s) to 1-1 mapping\n", identity);
-	pr_info("Remapped %ld page(s), last_pfn=%ld\n", remapped,
-		last_pfn);
 	pr_info("Released %ld page(s)\n", num_released);
 
 	return last_pfn;
 }
+
+/*
+ * Remap the memory prepared in xen_do_set_identity_and_remap_chunk().
+ * The remap information (which mfn remap to which pfn) is contained in the
+ * to be remapped memory itself in a linked list anchored at xen_remap_mfn.
+ * This scheme allows to remap the different chunks in arbitrary order while
+ * the resulting mapping will be independant from the order.
+ */
+void __init xen_remap_memory(void)
+{
+	unsigned long buf = (unsigned long)&xen_remap_buf;
+	unsigned long mfn_save, mfn, pfn;
+	unsigned long remapped = 0;
+	unsigned int i;
+	unsigned long pfn_s = ~0UL;
+	unsigned long len = 0;
+
+	mfn_save = virt_to_mfn(buf);
+
+	while (xen_remap_mfn != INVALID_P2M_ENTRY) {
+		/* Map the remap information */
+		set_pte_mfn(buf, xen_remap_mfn, PAGE_KERNEL);
+
+		BUG_ON(xen_remap_mfn != xen_remap_buf.mfns[0]);
+
+		pfn = xen_remap_buf.target_pfn;
+		for (i = 0; i < xen_remap_buf.size; i++) {
+			mfn = xen_remap_buf.mfns[i];
+			xen_update_mem_tables(pfn, mfn);
+			remapped++;
+			pfn++;
+		}
+		if (pfn_s == ~0UL || pfn == pfn_s) {
+			pfn_s = xen_remap_buf.target_pfn;
+			len += xen_remap_buf.size;
+		} else if (pfn_s + len == xen_remap_buf.target_pfn) {
+			len += xen_remap_buf.size;
+		} else {
+			memblock_free(PFN_PHYS(pfn_s), PFN_PHYS(len));
+			pfn_s = xen_remap_buf.target_pfn;
+			len = xen_remap_buf.size;
+		}
+
+		mfn = xen_remap_mfn;
+		xen_remap_mfn = xen_remap_buf.next_area_mfn;
+	}
+
+	if (pfn_s != ~0UL && len)
+		memblock_free(PFN_PHYS(pfn_s), PFN_PHYS(len));
+
+	set_pte_mfn(buf, mfn_save, PAGE_KERNEL);
+
+	pr_info("Remapped %ld page(s)\n", remapped);
+}
+
 static unsigned long __init xen_get_max_pages(void)
 {
 	unsigned long max_pages = MAX_DOMAIN_PAGES;
@@ -616,7 +580,8 @@ char * __init xen_memory_setup(void)
 		extra_pages += max_pages - max_pfn;
 
 	/*
-	 * Set identity map on non-RAM pages and remap the underlying RAM.
+	 * Set identity map on non-RAM pages and prepare remapping the
+	 * underlying RAM.
 	 */
 	last_pfn = xen_set_identity_and_remap(map, memmap.nr_entries, max_pfn,
 					      &xen_released_pages);
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 28c7e0b..5b72a06 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -35,6 +35,7 @@ void xen_mm_pin_all(void);
 void xen_mm_unpin_all(void);
 void xen_set_pat(u64);
 
+void __init xen_remap_memory(void);
 char * __init xen_memory_setup(void);
 char * xen_auto_xlated_memory_setup(void);
 void __init xen_arch_setup(void);
-- 
2.1.2

