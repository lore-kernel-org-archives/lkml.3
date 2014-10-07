Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaJGKyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:54:22 -0400
Received: from ozlabs.org ([103.22.144.67]:42386 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbaJGKta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:49:30 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v3 02/16] powerpc/cell: Move data segment faulting code out of cell platform
Date: Tue,  7 Oct 2014 21:48:08 +1100
Message-Id: <1412678902-18672-3-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412678902-18672-1-git-send-email-mikey@neuling.org>
References: <1412678902-18672-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

__spu_trap_data_seg() currently contains code to determine the VSID and ESID
required for a particular EA and mm struct.

This code is generically useful for other co-processors. This moves the code
of the cell platform so it can be used by other powerpc code. It also adds 1TB
segment handling which Cell didn't have.

This also moves the internal struct spu_slb to a generic struct copro_slb which
is now used in the spu and copro code.  We use this new struct instead of the
us passing around esid and vsid parameters.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/include/asm/copro.h       |  7 ++++-
 arch/powerpc/include/asm/mmu-hash64.h  |  7 ++++-
 arch/powerpc/mm/copro_fault.c          | 46 ++++++++++++++++++++++++++++
 arch/powerpc/mm/slb.c                  |  3 --
 arch/powerpc/platforms/cell/spu_base.c | 55 ++++++----------------------------
 5 files changed, 67 insertions(+), 51 deletions(-)

diff --git a/arch/powerpc/include/asm/copro.h b/arch/powerpc/include/asm/copro.h
index 2858108..9badb09 100644
--- a/arch/powerpc/include/asm/copro.h
+++ b/arch/powerpc/include/asm/copro.h
@@ -10,9 +10,14 @@
 #ifndef _ASM_POWERPC_COPRO_H
 #define _ASM_POWERPC_COPRO_H
 
+struct copro_slb
+{
+	u64 esid, vsid;
+};
+
 int copro_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
 			  unsigned long dsisr, unsigned *flt);
 
-int copro_data_segment(struct mm_struct *mm, u64 ea, u64 *esid, u64 *vsid);
+int copro_calc_slb(struct mm_struct *mm, u64 ea, struct copro_slb *slb);
 
 #endif /* _ASM_POWERPC_COPRO_H */
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
index ba7df14..367ea01 100644
--- a/arch/powerpc/mm/copro_fault.c
+++ b/arch/powerpc/mm/copro_fault.c
@@ -24,6 +24,7 @@
 #include <linux/mm.h>
 #include <linux/export.h>
 #include <asm/reg.h>
+#include <asm/copro.h>
 
 /*
  * This ought to be kept in sync with the powerpc specific do_page_fault
@@ -90,3 +91,48 @@ out_unlock:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(copro_handle_mm_fault);
+
+int copro_calc_slb(struct mm_struct *mm, u64 ea, struct copro_slb *slb)
+{
+	u64 vsid;
+	int psize, ssize;
+
+	slb->esid = (ea & ESID_MASK) | SLB_ESID_V;
+
+	switch (REGION_ID(ea)) {
+	case USER_REGION_ID:
+		pr_devel("%s: 0x%llx -- USER_REGION_ID\n", __func__, ea);
+		psize = get_slice_psize(mm, ea);
+		ssize = user_segment_size(ea);
+		vsid = get_vsid(mm->context.id, ea, ssize);
+		break;
+	case VMALLOC_REGION_ID:
+		pr_devel("%s: 0x%llx -- VMALLOC_REGION_ID\n", __func__, ea);
+		if (ea < VMALLOC_END)
+			psize = mmu_vmalloc_psize;
+		else
+			psize = mmu_io_psize;
+		ssize = mmu_kernel_ssize;
+		vsid = get_kernel_vsid(ea, mmu_kernel_ssize);
+		break;
+	case KERNEL_REGION_ID:
+		pr_devel("%s: 0x%llx -- KERNEL_REGION_ID\n", __func__, ea);
+		psize = mmu_linear_psize;
+		ssize = mmu_kernel_ssize;
+		vsid = get_kernel_vsid(ea, mmu_kernel_ssize);
+		break;
+	default:
+		pr_debug("%s: invalid region access at %016llx\n", __func__, ea);
+		return 1;
+	}
+
+	vsid = (vsid << slb_vsid_shift(ssize)) | SLB_VSID_USER;
+
+	vsid |= mmu_psize_defs[psize].sllp |
+		((ssize == MMU_SEGSIZE_1T) ? SLB_VSID_B_1T : 0);
+
+	slb->vsid = vsid;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(copro_calc_slb);
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
index 2930d1e..bdb24de 100644
--- a/arch/powerpc/platforms/cell/spu_base.c
+++ b/arch/powerpc/platforms/cell/spu_base.c
@@ -76,10 +76,6 @@ static LIST_HEAD(spu_full_list);
 static DEFINE_SPINLOCK(spu_full_list_lock);
 static DEFINE_MUTEX(spu_full_list_mutex);
 
-struct spu_slb {
-	u64 esid, vsid;
-};
-
 void spu_invalidate_slbs(struct spu *spu)
 {
 	struct spu_priv2 __iomem *priv2 = spu->priv2;
@@ -149,7 +145,7 @@ static void spu_restart_dma(struct spu *spu)
 	}
 }
 
-static inline void spu_load_slb(struct spu *spu, int slbe, struct spu_slb *slb)
+static inline void spu_load_slb(struct spu *spu, int slbe, struct copro_slb *slb)
 {
 	struct spu_priv2 __iomem *priv2 = spu->priv2;
 
@@ -167,45 +163,12 @@ static inline void spu_load_slb(struct spu *spu, int slbe, struct spu_slb *slb)
 
 static int __spu_trap_data_seg(struct spu *spu, unsigned long ea)
 {
-	struct mm_struct *mm = spu->mm;
-	struct spu_slb slb;
-	int psize;
-
-	pr_debug("%s\n", __func__);
-
-	slb.esid = (ea & ESID_MASK) | SLB_ESID_V;
+	struct copro_slb slb;
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
+	ret = copro_calc_slb(spu->mm, ea, &slb);
+	if (ret)
+		return ret;
 
 	spu_load_slb(spu, spu->slb_replace, &slb);
 
@@ -253,7 +216,7 @@ static int __spu_trap_data_map(struct spu *spu, unsigned long ea, u64 dsisr)
 	return 0;
 }
 
-static void __spu_kernel_slb(void *addr, struct spu_slb *slb)
+static void __spu_kernel_slb(void *addr, struct copro_slb *slb)
 {
 	unsigned long ea = (unsigned long)addr;
 	u64 llp;
@@ -272,7 +235,7 @@ static void __spu_kernel_slb(void *addr, struct spu_slb *slb)
  * Given an array of @nr_slbs SLB entries, @slbs, return non-zero if the
  * address @new_addr is present.
  */
-static inline int __slb_present(struct spu_slb *slbs, int nr_slbs,
+static inline int __slb_present(struct copro_slb *slbs, int nr_slbs,
 		void *new_addr)
 {
 	unsigned long ea = (unsigned long)new_addr;
@@ -297,7 +260,7 @@ static inline int __slb_present(struct spu_slb *slbs, int nr_slbs,
 void spu_setup_kernel_slbs(struct spu *spu, struct spu_lscsa *lscsa,
 		void *code, int code_size)
 {
-	struct spu_slb slbs[4];
+	struct copro_slb slbs[4];
 	int i, nr_slbs = 0;
 	/* start and end addresses of both mappings */
 	void *addrs[] = {
-- 
1.9.1

