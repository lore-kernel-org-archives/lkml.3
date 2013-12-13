Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3LMCLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:11:18 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:45932 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab3LMCKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:10:49 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        george.dunlap@eu.citrix.com, ian.jackson@eu.citrix.com,
        mukesh.rathor@oracle.com, tim@xen.org, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH V10 11/14] xen/pvh: remove code to map iomem from guest
Date: Thu, 12 Dec 2013 21:10:18 -0500
Message-Id: <1386900621-27528-12-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

It was decided during xen patch review that xen map the iomem
transparently, so remove xen_set_clr_mmio_pvh_pte() and the sub
hypercall PHYSDEVOP_map_iomem.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
[v1: Fixed up the comment]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c              |   14 --------------
 arch/x86/xen/setup.c            |   17 ++++++-----------
 include/xen/interface/physdev.h |   10 ----------
 3 files changed, 6 insertions(+), 35 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a31449f..108fb4a 100644
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
index e3dcd8c..94c9b49 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -244,20 +244,15 @@ static void __init xen_set_identity_and_release_chunk(
 	*identity += set_phys_range_identity(start_pfn, end_pfn);
 }
 
-/* For PVH, the pfns [0..MAX] are mapped to mfn's in the EPT/NPT. The mfns
- * are released as part of this 1:1 mapping hypercall back to the dom heap.
- * Also, we map the entire IO space, ie, beyond max_pfn_mapped.
+
+/*
+ * PVH: xen has already mapped the IO space in the EPT/NPT for us, so we
+ * just need to adjust the released and identity count.
  */
-static void __init xen_pvh_identity_map_chunk(unsigned long start_pfn,
+static void __init xen_pvh_adjust_stats(unsigned long start_pfn,
 		unsigned long end_pfn, unsigned long *released,
 		unsigned long *identity, unsigned long max_pfn)
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
@@ -297,7 +292,7 @@ static unsigned long __init xen_set_identity_and_release(
 
 			if (start_pfn < end_pfn) {
 				if (xlated_phys) {
-					xen_pvh_identity_map_chunk(start_pfn,
+					xen_pvh_adjust_stats(start_pfn,
 						end_pfn, &released, &identity,
 						nr_pages);
 				} else {
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index 19d30ad..42721d1 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -291,16 +291,6 @@ struct physdev_dbgp_op {
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
1.7.7.6

