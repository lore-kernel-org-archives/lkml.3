Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaI3Kfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:35:47 -0400
Received: from ozlabs.org ([103.22.144.67]:59494 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbaI3Kfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:35:44 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2 09/17] powerpc/mm: Add new hash_page_mm()
Date: Tue, 30 Sep 2014 20:34:58 +1000
Message-Id: <1412073306-13812-10-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412073306-13812-1-git-send-email-mikey@neuling.org>
References: <1412073306-13812-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This adds a new function hash_page_mm() based on the existing hash_page().
This version allows any struct mm to be passed in, rather than assuming
current.  This is useful for servicing co-processor faults which are not in the
context of the current running process.

We need to be careful here as the current hash_page() assumes current in a few
places.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/include/asm/mmu-hash64.h |  1 +
 arch/powerpc/mm/hash_utils_64.c       | 22 ++++++++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu-hash64.h b/arch/powerpc/include/asm/mmu-hash64.h
index 6d0b7a2..f84e5a5 100644
--- a/arch/powerpc/include/asm/mmu-hash64.h
+++ b/arch/powerpc/include/asm/mmu-hash64.h
@@ -322,6 +322,7 @@ extern int __hash_page_64K(unsigned long ea, unsigned long access,
 			   unsigned int local, int ssize);
 struct mm_struct;
 unsigned int hash_page_do_lazy_icache(unsigned int pp, pte_t pte, int trap);
+extern int hash_page_mm(struct mm_struct *mm, unsigned long ea, unsigned long access, unsigned long trap);
 extern int hash_page(unsigned long ea, unsigned long access, unsigned long trap);
 int __hash_page_huge(unsigned long ea, unsigned long access, unsigned long vsid,
 		     pte_t *ptep, unsigned long trap, int local, int ssize,
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index bbdb054..0a5c8c0 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -904,7 +904,7 @@ void demote_segment_4k(struct mm_struct *mm, unsigned long addr)
 		return;
 	slice_set_range_psize(mm, addr, 1, MMU_PAGE_4K);
 	copro_flush_all_slbs(mm);
-	if (get_paca_psize(addr) != MMU_PAGE_4K) {
+	if ((get_paca_psize(addr) != MMU_PAGE_4K) && (current->mm == mm)) {
 		get_paca()->context = mm->context;
 		slb_flush_and_rebolt();
 	}
@@ -989,26 +989,24 @@ static void check_paca_psize(unsigned long ea, struct mm_struct *mm,
  * -1 - critical hash insertion error
  * -2 - access not permitted by subpage protection mechanism
  */
-int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
+int hash_page_mm(struct mm_struct *mm, unsigned long ea, unsigned long access, unsigned long trap)
 {
 	enum ctx_state prev_state = exception_enter();
 	pgd_t *pgdir;
 	unsigned long vsid;
-	struct mm_struct *mm;
 	pte_t *ptep;
 	unsigned hugeshift;
 	const struct cpumask *tmp;
 	int rc, user_region = 0, local = 0;
 	int psize, ssize;
 
-	DBG_LOW("hash_page(ea=%016lx, access=%lx, trap=%lx\n",
-		ea, access, trap);
+	DBG_LOW("%s(ea=%016lx, access=%lx, trap=%lx\n",
+		__func__, ea, access, trap);
 
 	/* Get region & vsid */
  	switch (REGION_ID(ea)) {
 	case USER_REGION_ID:
 		user_region = 1;
-		mm = current->mm;
 		if (! mm) {
 			DBG_LOW(" user region with no mm !\n");
 			rc = 1;
@@ -1104,7 +1102,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 			WARN_ON(1);
 		}
 #endif
-		check_paca_psize(ea, mm, psize, user_region);
+		if (current->mm == mm)
+			check_paca_psize(ea, mm, psize, user_region);
 
 		goto bail;
 	}
@@ -1145,7 +1144,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 		}
 	}
 
-	check_paca_psize(ea, mm, psize, user_region);
+	if (current->mm == mm)
+		check_paca_psize(ea, mm, psize, user_region);
 #endif /* CONFIG_PPC_64K_PAGES */
 
 #ifdef CONFIG_PPC_HAS_HASH_64K
@@ -1180,6 +1180,12 @@ bail:
 	exception_exit(prev_state);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(hash_page_mm);
+
+int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
+{
+	return hash_page_mm(current->mm, ea, access, trap);
+}
 EXPORT_SYMBOL_GPL(hash_page);
 
 void hash_preload(struct mm_struct *mm, unsigned long ea,
-- 
1.9.1

