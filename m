Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbaIZKAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:00:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbaIZJqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:40 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 053/142] powerpc/thp: Don't recompute vsid and ssize in loop on invalidate
Date: Fri, 26 Sep 2014 11:44:24 +0200
Message-Id: <e828f5bc74b7950667f94cf1af488391ec43018d.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit fa1f8ae80f8bb996594167ff4750a0b0a5a5bb5d upstream.

The segment identifier and segment size will remain the same in
the loop, So we can compute it outside. We also change the
hugepage_invalidate interface so that we can use it the later patch

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/include/asm/machdep.h    |  6 +++---
 arch/powerpc/mm/hash_native_64.c      | 19 +++++--------------
 arch/powerpc/mm/pgtable_64.c          | 24 ++++++++++++------------
 arch/powerpc/platforms/pseries/lpar.c | 20 ++++++--------------
 4 files changed, 26 insertions(+), 43 deletions(-)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index 8b480901165a..3a52b9b01133 100644
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
index c33d939120c9..9197691fd5d5 100644
--- a/arch/powerpc/mm/hash_native_64.c
+++ b/arch/powerpc/mm/hash_native_64.c
@@ -413,18 +413,18 @@ static void native_hpte_invalidate(unsigned long slot, unsigned long vpn,
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
@@ -438,15 +438,6 @@ static void native_hugepage_invalidate(struct mm_struct *mm,
 
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
index 536eec72c0f7..48bda6700404 100644
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -726,12 +726,21 @@ void hpte_do_hugepage_flush(struct mm_struct *mm, unsigned long addr,
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
@@ -749,15 +758,6 @@ void hpte_do_hugepage_flush(struct mm_struct *mm, unsigned long addr,
 
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
index 356bc75ca74f..691a479f7d97 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -412,16 +412,17 @@ static void __pSeries_lpar_hugepage_invalidate(unsigned long *slot,
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
@@ -434,15 +435,6 @@ static void pSeries_lpar_hugepage_invalidate(struct mm_struct *mm,
 
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
2.1.0

