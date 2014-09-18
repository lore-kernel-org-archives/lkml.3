Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbaIRIcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:32:06 -0400
Received: from ozlabs.org ([103.22.144.67]:57551 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbaIRI1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:27:22 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH 08/15] powerpc/mm: Add new hash_page_mm()
Date: Thu, 18 Sep 2014 18:26:53 +1000
Message-Id: <1411028820-29933-9-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411028820-29933-1-git-send-email-mikey@neuling.org>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
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
 arch/powerpc/mm/hash_utils_64.c       | 20 +++++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu-hash64.h b/arch/powerpc/include/asm/mmu-hash64.h
index fd19a53..a3b85e9 100644
--- a/arch/powerpc/include/asm/mmu-hash64.h
+++ b/arch/powerpc/include/asm/mmu-hash64.h
@@ -319,6 +319,7 @@ extern int __hash_page_64K(unsigned long ea, unsigned long access,
 			   unsigned int local, int ssize);
 struct mm_struct;
 unsigned int hash_page_do_lazy_icache(unsigned int pp, pte_t pte, int trap);
+extern int hash_page_mm(struct mm_struct *mm, unsigned long ea, unsigned long access, unsigned long trap);
 extern int hash_page(unsigned long ea, unsigned long access, unsigned long trap);
 int __hash_page_huge(unsigned long ea, unsigned long access, unsigned long vsid,
 		     pte_t *ptep, unsigned long trap, int local, int ssize,
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 0f73367..66071af 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -991,26 +991,24 @@ static void check_paca_psize(unsigned long ea, struct mm_struct *mm,
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
@@ -1106,7 +1104,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 			WARN_ON(1);
 		}
 #endif
-		check_paca_psize(ea, mm, psize, user_region);
+		if (current->mm == mm)
+			check_paca_psize(ea, mm, psize, user_region);
 
 		goto bail;
 	}
@@ -1149,7 +1148,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 		}
 	}
 
-	check_paca_psize(ea, mm, psize, user_region);
+	if (current->mm == mm)
+		check_paca_psize(ea, mm, psize, user_region);
 #endif /* CONFIG_PPC_64K_PAGES */
 
 #ifdef CONFIG_PPC_HAS_HASH_64K
@@ -1184,6 +1184,12 @@ bail:
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

