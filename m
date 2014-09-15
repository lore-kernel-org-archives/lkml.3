Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbaIOWTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:19:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51153 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057AbaIOWTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 180/187] powerpc/thp: Don't recompute vsid and ssize in loop on invalidate
Date: Mon, 15 Sep 2014 15:09:50 -0700
Message-Id: <1410818997-9432-181-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit fa1f8ae80f8bb996594167ff4750a0b0a5a5bb5d upstream.

The segment identifier and segment size will remain the same in
the loop, So we can compute it outside. We also change the
hugepage_invalidate interface so that we can use it the later patch

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/include/asm/machdep.h    |  6 +++---
 arch/powerpc/mm/hash_native_64.c      | 19 +++++--------------
 arch/powerpc/mm/pgtable_64.c          | 24 ++++++++++++------------
 arch/powerpc/platforms/pseries/lpar.c | 20 ++++++--------------
 4 files changed, 26 insertions(+), 43 deletions(-)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index ad3025d..f207868 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -57,10 +57,10 @@ struct machdep_calls {
 	void            (*hpte_removebolted)(unsigned long ea,
 					     int psize, int ssize);
 	void		(*flush_hash_range)(unsigned long number, int local);
-	void		(*hugepage_invalidate)(struct mm_struct *mm,
+	void		(*hugepage_invalidate)(unsigned long vsid,
+					       unsigned long addr,
 					       unsigned char *hpte_slot_array,
-					       unsigned long addr, int psize);
-
+					       int psize, int ssize);
 	/* special for kexec, to be called in real mode, linear mapping is
 	 * destroyed as well */
 	void		(*hpte_clear_all)(void);
diff --git a/arch/powerpc/mm/hash_native_64.c b/arch/powerpc/mm/hash_native_64.c
index 3ea26c2..44886c2 100644
--- a/arch/powerpc/mm/hash_native_64.c
+++ b/arch/powerpc/mm/hash_native_64.c
@@ -418,18 +418,18 @@ static void native_hpte_invalidate(unsigned long slot, unsigned long vpn,
 	local_irq_restore(flags);
 }
 
-static void native_hugepage_invalidate(struct mm_struct *mm,
+static void native_hugepage_invalidate(unsigned long vsid,
+				       unsigned long addr,
 				       unsigned char *hpte_slot_array,
-				       unsigned long addr, int psize)
+				       int psize, int ssize)
 {
-	int ssize = 0, i;
-	int lock_tlbie;
+	int i, lock_tlbie;
 	struct hash_pte *hptep;
 	int actual_psize = MMU_PAGE_16M;
 	unsigned int max_hpte_count, valid;
 	unsigned long flags, s_addr = addr;
 	unsigned long hpte_v, want_v, shift;
-	unsigned long hidx, vpn = 0, vsid, hash, slot;
+	unsigned long hidx, vpn = 0, hash, slot;
 
 	shift = mmu_psize_defs[psize].shift;
 	max_hpte_count = 1U << (PMD_SHIFT - shift);
@@ -443,15 +443,6 @@ static void native_hugepage_invalidate(struct mm_struct *mm,
 
 		/* get the vpn */
 		addr = s_addr + (i * (1ul << shift));
-		if (!is_kernel_addr(addr)) {
-			ssize = user_segment_size(addr);
-			vsid = get_vsid(mm->context.id, addr, ssize);
-			WARN_ON(vsid == 0);
-		} else {
-			vsid = get_kernel_vsid(addr, mmu_kernel_ssize);
-			ssize = mmu_kernel_ssize;
-		}
-
 		vpn = hpt_vpn(addr, vsid, ssize);
 		hash = hpt_hash(vpn, shift, ssize);
 		if (hidx & _PTEIDX_SECONDARY)
diff --git a/arch/powerpc/mm/pgtable_64.c b/arch/powerpc/mm/pgtable_64.c
index 9d95786..5cd5182 100644
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -727,12 +727,21 @@ void hpte_do_hugepage_flush(struct mm_struct *mm, unsigned long addr,
 	if (!hpte_slot_array)
 		return;
 
-	/* get the base page size */
+	/* get the base page size,vsid and segment size */
 	psize = get_slice_psize(mm, s_addr);
+	if (!is_kernel_addr(s_addr)) {
+		ssize = user_segment_size(s_addr);
+		vsid = get_vsid(mm->context.id, s_addr, ssize);
+		WARN_ON(vsid == 0);
+	} else {
+		vsid = get_kernel_vsid(s_addr, mmu_kernel_ssize);
+		ssize = mmu_kernel_ssize;
+	}
 
 	if (ppc_md.hugepage_invalidate)
-		return ppc_md.hugepage_invalidate(mm, hpte_slot_array,
-						  s_addr, psize);
+		return ppc_md.hugepage_invalidate(vsid, s_addr,
+						  hpte_slot_array,
+						  psize, ssize);
 	/*
 	 * No bluk hpte removal support, invalidate each entry
 	 */
@@ -750,15 +759,6 @@ void hpte_do_hugepage_flush(struct mm_struct *mm, unsigned long addr,
 
 		/* get the vpn */
 		addr = s_addr + (i * (1ul << shift));
-		if (!is_kernel_addr(addr)) {
-			ssize = user_segment_size(addr);
-			vsid = get_vsid(mm->context.id, addr, ssize);
-			WARN_ON(vsid == 0);
-		} else {
-			vsid = get_kernel_vsid(addr, mmu_kernel_ssize);
-			ssize = mmu_kernel_ssize;
-		}
-
 		vpn = hpt_vpn(addr, vsid, ssize);
 		hash = hpt_hash(vpn, shift, ssize);
 		if (hidx & _PTEIDX_SECONDARY)
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 4fca3de..bf410d9 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -429,16 +429,17 @@ static void __pSeries_lpar_hugepage_invalidate(unsigned long *slot,
 		spin_unlock_irqrestore(&pSeries_lpar_tlbie_lock, flags);
 }
 
-static void pSeries_lpar_hugepage_invalidate(struct mm_struct *mm,
-				       unsigned char *hpte_slot_array,
-				       unsigned long addr, int psize)
+static void pSeries_lpar_hugepage_invalidate(unsigned long vsid,
+					     unsigned long addr,
+					     unsigned char *hpte_slot_array,
+					     int psize, int ssize)
 {
-	int ssize = 0, i, index = 0;
+	int i, index = 0;
 	unsigned long s_addr = addr;
 	unsigned int max_hpte_count, valid;
 	unsigned long vpn_array[PPC64_HUGE_HPTE_BATCH];
 	unsigned long slot_array[PPC64_HUGE_HPTE_BATCH];
-	unsigned long shift, hidx, vpn = 0, vsid, hash, slot;
+	unsigned long shift, hidx, vpn = 0, hash, slot;
 
 	shift = mmu_psize_defs[psize].shift;
 	max_hpte_count = 1U << (PMD_SHIFT - shift);
@@ -451,15 +452,6 @@ static void pSeries_lpar_hugepage_invalidate(struct mm_struct *mm,
 
 		/* get the vpn */
 		addr = s_addr + (i * (1ul << shift));
-		if (!is_kernel_addr(addr)) {
-			ssize = user_segment_size(addr);
-			vsid = get_vsid(mm->context.id, addr, ssize);
-			WARN_ON(vsid == 0);
-		} else {
-			vsid = get_kernel_vsid(addr, mmu_kernel_ssize);
-			ssize = mmu_kernel_ssize;
-		}
-
 		vpn = hpt_vpn(addr, vsid, ssize);
 		hash = hpt_hash(vpn, shift, ssize);
 		if (hidx & _PTEIDX_SECONDARY)
-- 
1.9.1

