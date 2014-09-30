Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaI3Khx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:37:53 -0400
Received: from ozlabs.org ([103.22.144.67]:60322 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbaI3Kfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:35:45 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2 10/17] powerpc/mm: Merge vsid calculation in hash_page() and copro_data_segment()
Date: Tue, 30 Sep 2014 20:34:59 +1000
Message-Id: <1412073306-13812-11-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412073306-13812-1-git-send-email-mikey@neuling.org>
References: <1412073306-13812-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

The vsid calculation between hash_page() and copro_data_segment() are very
similar.  This merges these two different versions.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/include/asm/mmu-hash64.h |  2 ++
 arch/powerpc/mm/copro_fault.c         | 45 ++++++--------------------
 arch/powerpc/mm/hash_utils_64.c       | 61 ++++++++++++++++++++++-------------
 3 files changed, 50 insertions(+), 58 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu-hash64.h b/arch/powerpc/include/asm/mmu-hash64.h
index f84e5a5..bf43fb0 100644
--- a/arch/powerpc/include/asm/mmu-hash64.h
+++ b/arch/powerpc/include/asm/mmu-hash64.h
@@ -322,6 +322,8 @@ extern int __hash_page_64K(unsigned long ea, unsigned long access,
 			   unsigned int local, int ssize);
 struct mm_struct;
 unsigned int hash_page_do_lazy_icache(unsigned int pp, pte_t pte, int trap);
+int calculate_vsid(struct mm_struct *mm, u64 ea,
+		   u64 *vsid, int *psize, int *ssize);
 extern int hash_page_mm(struct mm_struct *mm, unsigned long ea, unsigned long access, unsigned long trap);
 extern int hash_page(unsigned long ea, unsigned long access, unsigned long trap);
 int __hash_page_huge(unsigned long ea, unsigned long access, unsigned long vsid,
diff --git a/arch/powerpc/mm/copro_fault.c b/arch/powerpc/mm/copro_fault.c
index 939abdf..ba8bf8e 100644
--- a/arch/powerpc/mm/copro_fault.c
+++ b/arch/powerpc/mm/copro_fault.c
@@ -94,45 +94,18 @@ EXPORT_SYMBOL_GPL(copro_handle_mm_fault);
 
 int copro_data_segment(struct mm_struct *mm, u64 ea, u64 *esid, u64 *vsid)
 {
-	int psize, ssize;
+	int psize, ssize, rc;
 
 	*esid = (ea & ESID_MASK) | SLB_ESID_V;
 
-	switch (REGION_ID(ea)) {
-	case USER_REGION_ID:
-		pr_devel("copro_data_segment: 0x%llx -- USER_REGION_ID\n", ea);
-#ifdef CONFIG_PPC_MM_SLICES
-		psize = get_slice_psize(mm, ea);
-#else
-		psize = mm->context.user_psize;
-#endif
-		ssize = user_segment_size(ea);
-		*vsid = (get_vsid(mm->context.id, ea, ssize)
-			 << slb_vsid_shift(ssize)) | SLB_VSID_USER;
-		break;
-	case VMALLOC_REGION_ID:
-		pr_devel("copro_data_segment: 0x%llx -- VMALLOC_REGION_ID\n", ea);
-		if (ea < VMALLOC_END)
-			psize = mmu_vmalloc_psize;
-		else
-			psize = mmu_io_psize;
-		ssize = mmu_kernel_ssize;
-		*vsid = (get_kernel_vsid(ea, mmu_kernel_ssize)
-			 << SLB_VSID_SHIFT) | SLB_VSID_KERNEL;
-		break;
-	case KERNEL_REGION_ID:
-		pr_devel("copro_data_segment: 0x%llx -- KERNEL_REGION_ID\n", ea);
-		psize = mmu_linear_psize;
-		ssize = mmu_kernel_ssize;
-		*vsid = (get_kernel_vsid(ea, mmu_kernel_ssize)
-			 << SLB_VSID_SHIFT) | SLB_VSID_KERNEL;
-		break;
-	default:
-		/* Future: support kernel segments so that drivers can use the
-		 * CoProcessors */
-		pr_debug("invalid region access at %016llx\n", ea);
-		return 1;
-	}
+	rc = calculate_vsid(mm, ea, vsid, &psize, &ssize);
+	if (rc)
+		return rc;
+	if (REGION_ID(ea) == USER_REGION_ID)
+		*vsid = (*vsid << slb_vsid_shift(ssize)) | SLB_VSID_USER;
+	else
+		*vsid = (*vsid << SLB_VSID_SHIFT) | SLB_VSID_KERNEL;
+
 	*vsid |= mmu_psize_defs[psize].sllp |
 		((ssize == MMU_SEGSIZE_1T) ? SLB_VSID_B_1T : 0);
 
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 0a5c8c0..3fa81ca 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -983,6 +983,38 @@ static void check_paca_psize(unsigned long ea, struct mm_struct *mm,
 	}
 }
 
+int calculate_vsid(struct mm_struct *mm, u64 ea,
+		   u64 *vsid, int *psize, int *ssize)
+{
+	switch (REGION_ID(ea)) {
+	case USER_REGION_ID:
+		pr_devel("%s: 0x%llx -- USER_REGION_ID\n", __func__, ea);
+		*psize = get_slice_psize(mm, ea);
+		*ssize = user_segment_size(ea);
+		*vsid = get_vsid(mm->context.id, ea, *ssize);
+		return 0;
+	case VMALLOC_REGION_ID:
+		pr_devel("%s: 0x%llx -- VMALLOC_REGION_ID\n", __func__, ea);
+		if (ea < VMALLOC_END)
+			*psize = mmu_vmalloc_psize;
+		else
+			*psize = mmu_io_psize;
+		*ssize = mmu_kernel_ssize;
+		*vsid = get_kernel_vsid(ea, mmu_kernel_ssize);
+		return 0;
+	case KERNEL_REGION_ID:
+		pr_devel("%s: 0x%llx -- KERNEL_REGION_ID\n", __func__, ea);
+		*psize = mmu_linear_psize;
+		*ssize = mmu_kernel_ssize;
+		*vsid = get_kernel_vsid(ea, mmu_kernel_ssize);
+		return 0;
+	default:
+		pr_debug("%s: invalid region access at %016llx\n", __func__, ea);
+		return 1;
+	}
+}
+EXPORT_SYMBOL_GPL(calculate_vsid);
+
 /* Result code is:
  *  0 - handled
  *  1 - normal page fault
@@ -993,7 +1025,7 @@ int hash_page_mm(struct mm_struct *mm, unsigned long ea, unsigned long access, u
 {
 	enum ctx_state prev_state = exception_enter();
 	pgd_t *pgdir;
-	unsigned long vsid;
+	u64 vsid;
 	pte_t *ptep;
 	unsigned hugeshift;
 	const struct cpumask *tmp;
@@ -1003,35 +1035,20 @@ int hash_page_mm(struct mm_struct *mm, unsigned long ea, unsigned long access, u
 	DBG_LOW("%s(ea=%016lx, access=%lx, trap=%lx\n",
 		__func__, ea, access, trap);
 
-	/* Get region & vsid */
- 	switch (REGION_ID(ea)) {
-	case USER_REGION_ID:
+	/* Get region */
+	if (REGION_ID(ea) == USER_REGION_ID) {
 		user_region = 1;
 		if (! mm) {
 			DBG_LOW(" user region with no mm !\n");
 			rc = 1;
 			goto bail;
 		}
-		psize = get_slice_psize(mm, ea);
-		ssize = user_segment_size(ea);
-		vsid = get_vsid(mm->context.id, ea, ssize);
-		break;
-	case VMALLOC_REGION_ID:
+	} else
 		mm = &init_mm;
-		vsid = get_kernel_vsid(ea, mmu_kernel_ssize);
-		if (ea < VMALLOC_END)
-			psize = mmu_vmalloc_psize;
-		else
-			psize = mmu_io_psize;
-		ssize = mmu_kernel_ssize;
-		break;
-	default:
-		/* Not a valid range
-		 * Send the problem up to do_page_fault 
-		 */
-		rc = 1;
+	rc = calculate_vsid(mm, ea, &vsid, &psize, &ssize);
+	if (rc)
 		goto bail;
-	}
+
 	DBG_LOW(" mm=%p, mm->pgdir=%p, vsid=%016lx\n", mm, mm->pgd, vsid);
 
 	/* Bad address. */
-- 
1.9.1

