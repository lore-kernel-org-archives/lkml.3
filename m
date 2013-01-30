Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab3A3Wzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 17:55:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30449 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3A3Wzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 17:55:40 -0500
Date: Wed, 30 Jan 2013 14:55:29 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: [PATCH] PVH: remove code to map iomem from guest
Message-ID: <20130130145529.3900dca1@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was decided during xen patch review that xen map the iomem
transparently, so remove xen_set_clr_mmio_pvh_pte() and the sub
hypercall PHYSDEVOP_map_iomem.

---
 arch/x86/xen/mmu.c              |   14 --------------
 arch/x86/xen/setup.c            |   16 ++++------------
 include/xen/interface/physdev.h |   10 ----------
 3 files changed, 4 insertions(+), 36 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b4be4c9..fbf6a63 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -333,20 +333,6 @@ static void xen_set_pte(pte_t *ptep, pte_t pteval)
 	__xen_set_pte(ptep, pteval);
 }
 
-void xen_set_clr_mmio_pvh_pte(unsigned long pfn, unsigned long mfn,
-			      int nr_mfns, int add_mapping)
-{
-	struct physdev_map_iomem iomem;
-
-	iomem.first_gfn = pfn;
-	iomem.first_mfn = mfn;
-	iomem.nr_mfns = nr_mfns;
-	iomem.add_mapping = add_mapping;
-
-	if (HYPERVISOR_physdev_op(PHYSDEVOP_map_iomem, &iomem))
-		BUG();
-}
-
 static void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval)
 {
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 7e93ec9..6532172 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -235,20 +235,12 @@ static void __init xen_set_identity_and_release_chunk(
 	*identity += set_phys_range_identity(start_pfn, end_pfn);
 }
 
-/* For PVH, the pfns [0..MAX] are mapped to mfn's in the EPT/NPT. The mfns
- * are released as part of this 1:1 mapping hypercall back to the dom heap.
- * Also, we map the entire IO space, ie, beyond max_pfn_mapped.
- */
-static void __init xen_pvh_identity_map_chunk(unsigned long start_pfn,
+/* PVH: xen has already mapped the IO space in the EPT/NPT for us, so we
+ * just need to adjust the released and identity count */
+static void __init xen_pvh_adjust_stats(unsigned long start_pfn,
 		unsigned long end_pfn, unsigned long max_pfn,
 		unsigned long *released, unsigned long *identity)
 {
-	unsigned long pfn;
-	int numpfns = 1, add_mapping = 1;
-
-	for (pfn = start_pfn; pfn < end_pfn; pfn++)
-		xen_set_clr_mmio_pvh_pte(pfn, pfn, numpfns, add_mapping);
-
 	if (start_pfn <= max_pfn) {
 		unsigned long end = min(max_pfn_mapped, end_pfn);
 		*released += end - start_pfn;
@@ -288,7 +280,7 @@ static unsigned long __init xen_set_identity_and_release(
 
 			if (start_pfn < end_pfn) {
 				if (xlated_phys) {
-					xen_pvh_identity_map_chunk(start_pfn,
+					xen_pvh_adjust_stats(start_pfn,
 						end_pfn, nr_pages, &released, 
 						&identity);
 				} else {
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index 83050d3..1844d31 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -274,16 +274,6 @@ struct physdev_dbgp_op {
     } u;
 };
 
-#define PHYSDEVOP_map_iomem        30
-struct physdev_map_iomem {
-    /* IN */
-    uint64_t first_gfn;
-    uint64_t first_mfn;
-    uint32_t nr_mfns;
-    uint32_t add_mapping; /* 1 == add mapping;  0 == unmap */
-
-};
-
 /*
  * Notify that some PIRQ-bound event channels have been unmasked.
  * ** This command is obsolete since interface version 0x00030202 and is **
-- 
1.7.2.3

