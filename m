Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaI3Kfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:35:42 -0400
Received: from ozlabs.org ([103.22.144.67]:49609 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaI3Kfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:35:37 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2 02/17] powerpc/cell: Move data segment faulting code out of cell platform
Date: Tue, 30 Sep 2014 20:34:51 +1000
Message-Id: <1412073306-13812-3-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412073306-13812-1-git-send-email-mikey@neuling.org>
References: <1412073306-13812-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

__spu_trap_data_seg() currently contains code to determine the VSID and ESID
required for a particular EA and mm struct.

This code is generically useful for other co-processors.  This moves the code
of the cell platform so it can be used by other powerpc code.  It also adds 1TB
segment handling which Cell didn't have.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/include/asm/mmu-hash64.h  |  7 ++++-
 arch/powerpc/mm/copro_fault.c          | 48 ++++++++++++++++++++++++++++++++++
 arch/powerpc/mm/slb.c                  |  3 ---
 arch/powerpc/platforms/cell/spu_base.c | 41 +++--------------------------
 4 files changed, 58 insertions(+), 41 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu-hash64.h b/arch/powerpc/include/asm/mmu-hash64.h
index d765144..6d0b7a2 100644
--- a/arch/powerpc/include/asm/mmu-hash64.h
+++ b/arch/powerpc/include/asm/mmu-hash64.h
@@ -189,7 +189,12 @@ static inline unsigned int mmu_psize_to_shift(unsigned int mmu_psize)
 #define LP_MASK(i)	((0xFF >> (i)) << LP_SHIFT)
 
 #ifndef __ASSEMBLY__
-
+static inline int slb_vsid_shift(int ssize)
+{
+	if (ssize == MMU_SEGSIZE_256M)
+		return SLB_VSID_SHIFT;
+	return SLB_VSID_SHIFT_1T;
+}
 static inline int segment_shift(int ssize)
 {
 	if (ssize == MMU_SEGSIZE_256M)
diff --git a/arch/powerpc/mm/copro_fault.c b/arch/powerpc/mm/copro_fault.c
index ba7df14..b865697 100644
--- a/arch/powerpc/mm/copro_fault.c
+++ b/arch/powerpc/mm/copro_fault.c
@@ -90,3 +90,51 @@ out_unlock:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(copro_handle_mm_fault);
+
+int copro_data_segment(struct mm_struct *mm, u64 ea, u64 *esid, u64 *vsid)
+{
+	int psize, ssize;
+
+	*esid = (ea & ESID_MASK) | SLB_ESID_V;
+
+	switch (REGION_ID(ea)) {
+	case USER_REGION_ID:
+		pr_devel("copro_data_segment: 0x%llx -- USER_REGION_ID\n", ea);
+#ifdef CONFIG_PPC_MM_SLICES
+		psize = get_slice_psize(mm, ea);
+#else
+		psize = mm->context.user_psize;
+#endif
+		ssize = user_segment_size(ea);
+		*vsid = (get_vsid(mm->context.id, ea, ssize)
+			 << slb_vsid_shift(ssize)) | SLB_VSID_USER;
+		break;
+	case VMALLOC_REGION_ID:
+		pr_devel("copro_data_segment: 0x%llx -- VMALLOC_REGION_ID\n", ea);
+		if (ea < VMALLOC_END)
+			psize = mmu_vmalloc_psize;
+		else
+			psize = mmu_io_psize;
+		ssize = mmu_kernel_ssize;
+		*vsid = (get_kernel_vsid(ea, mmu_kernel_ssize)
+			 << SLB_VSID_SHIFT) | SLB_VSID_KERNEL;
+		break;
+	case KERNEL_REGION_ID:
+		pr_devel("copro_data_segment: 0x%llx -- KERNEL_REGION_ID\n", ea);
+		psize = mmu_linear_psize;
+		ssize = mmu_kernel_ssize;
+		*vsid = (get_kernel_vsid(ea, mmu_kernel_ssize)
+			 << SLB_VSID_SHIFT) | SLB_VSID_KERNEL;
+		break;
+	default:
+		/* Future: support kernel segments so that drivers can use the
+		 * CoProcessors */
+		pr_debug("invalid region access at %016llx\n", ea);
+		return 1;
+	}
+	*vsid |= mmu_psize_defs[psize].sllp |
+		((ssize == MMU_SEGSIZE_1T) ? SLB_VSID_B_1T : 0);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(copro_data_segment);
diff --git a/arch/powerpc/mm/slb.c b/arch/powerpc/mm/slb.c
index 0399a67..6e450ca 100644
--- a/arch/powerpc/mm/slb.c
+++ b/arch/powerpc/mm/slb.c
@@ -46,9 +46,6 @@ static inline unsigned long mk_esid_data(unsigned long ea, int ssize,
 	return (ea & slb_esid_mask(ssize)) | SLB_ESID_V | slot;
 }
 
-#define slb_vsid_shift(ssize)	\
-	((ssize) == MMU_SEGSIZE_256M? SLB_VSID_SHIFT: SLB_VSID_SHIFT_1T)
-
 static inline unsigned long mk_vsid_data(unsigned long ea, int ssize,
 					 unsigned long flags)
 {
diff --git a/arch/powerpc/platforms/cell/spu_base.c b/arch/powerpc/platforms/cell/spu_base.c
index 2930d1e..fe004b1 100644
--- a/arch/powerpc/platforms/cell/spu_base.c
+++ b/arch/powerpc/platforms/cell/spu_base.c
@@ -167,45 +167,12 @@ static inline void spu_load_slb(struct spu *spu, int slbe, struct spu_slb *slb)
 
 static int __spu_trap_data_seg(struct spu *spu, unsigned long ea)
 {
-	struct mm_struct *mm = spu->mm;
 	struct spu_slb slb;
-	int psize;
-
-	pr_debug("%s\n", __func__);
-
-	slb.esid = (ea & ESID_MASK) | SLB_ESID_V;
+	int ret;
 
-	switch(REGION_ID(ea)) {
-	case USER_REGION_ID:
-#ifdef CONFIG_PPC_MM_SLICES
-		psize = get_slice_psize(mm, ea);
-#else
-		psize = mm->context.user_psize;
-#endif
-		slb.vsid = (get_vsid(mm->context.id, ea, MMU_SEGSIZE_256M)
-				<< SLB_VSID_SHIFT) | SLB_VSID_USER;
-		break;
-	case VMALLOC_REGION_ID:
-		if (ea < VMALLOC_END)
-			psize = mmu_vmalloc_psize;
-		else
-			psize = mmu_io_psize;
-		slb.vsid = (get_kernel_vsid(ea, MMU_SEGSIZE_256M)
-				<< SLB_VSID_SHIFT) | SLB_VSID_KERNEL;
-		break;
-	case KERNEL_REGION_ID:
-		psize = mmu_linear_psize;
-		slb.vsid = (get_kernel_vsid(ea, MMU_SEGSIZE_256M)
-				<< SLB_VSID_SHIFT) | SLB_VSID_KERNEL;
-		break;
-	default:
-		/* Future: support kernel segments so that drivers
-		 * can use SPUs.
-		 */
-		pr_debug("invalid region access at %016lx\n", ea);
-		return 1;
-	}
-	slb.vsid |= mmu_psize_defs[psize].sllp;
+	ret = copro_data_segment(spu->mm, ea, &slb.esid, &slb.vsid);
+	if (ret)
+		return ret;
 
 	spu_load_slb(spu, spu->slb_replace, &slb);
 
-- 
1.9.1

