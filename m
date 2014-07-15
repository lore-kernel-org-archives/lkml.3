Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbaGOTpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:45:45 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:38537 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367AbaGOTpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:45:34 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de, konrad.wilk@oracle.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stefan.bader@canonical.com, luto@amacapital.net, airlied@gmail.com,
        bp@alien8.de, Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 10/11] x86, xen: Cleanup PWT/PCD bit manipulation in Xen
Date: Tue, 15 Jul 2014 13:34:43 -0600
Message-Id: <1405452884-25688-11-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the PWT & PCD bit manipulation for the kernel
memory types in Xen, and uses _PAGE_CACHE_<type> macros, instead.
This keeps the Xen code independent from the PAT slot assignment.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/xen/enlighten.c |    2 +-
 arch/x86/xen/mmu.c       |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index ffb101e..1917bef 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1557,7 +1557,7 @@ asmlinkage __visible void __init xen_start_kernel(void)
 #if 0
 	if (!xen_initial_domain())
 #endif
-		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
+		__supported_pte_mask &= ~_PAGE_CACHE_MASK;
 
 	__supported_pte_mask |= _PAGE_IOMAP;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e8a1201..8ef154a 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -438,7 +438,7 @@ __visible pteval_t xen_pte_val(pte_t pte)
 	/* If this is a WC pte, convert back from Xen WC to Linux WC */
 	if ((pteval & (_PAGE_PAT | _PAGE_PCD | _PAGE_PWT)) == _PAGE_PAT) {
 		WARN_ON(!pat_enabled);
-		pteval = (pteval & ~_PAGE_PAT) | _PAGE_PWT;
+		pteval = (pteval & ~_PAGE_PAT) | _PAGE_CACHE_WC;
 	}
 #endif
 	if (xen_initial_domain() && (pteval & _PAGE_IOMAP))
@@ -465,11 +465,11 @@ PV_CALLEE_SAVE_REGS_THUNK(xen_pgd_val);
  * 0                     WB       WB     WB
  * 1            PWT      WC       WT     WT
  * 2        PCD          UC-      UC-    UC-
- * 3        PCD PWT      UC       UC     UC
+ * 3        PCD PWT      WT       UC     UC
  * 4    PAT              WB       WC     WB
  * 5    PAT     PWT      WC       WP     WT
  * 6    PAT PCD          UC-      rsv    UC-
- * 7    PAT PCD PWT      UC       rsv    UC
+ * 7    PAT PCD PWT      WT       rsv    UC
  */
 
 void xen_set_pat(u64 pat)
@@ -492,7 +492,7 @@ __visible pte_t xen_make_pte(pteval_t pte)
 	 * but we could see hugetlbfs mappings, I think.).
 	 */
 	if (pat_enabled && !WARN_ON(pte & _PAGE_PAT)) {
-		if ((pte & (_PAGE_PCD | _PAGE_PWT)) == _PAGE_PWT)
+		if ((pte & _PAGE_CACHE_MASK) == _PAGE_CACHE_WC)
 			pte = (pte & ~(_PAGE_PCD | _PAGE_PWT)) | _PAGE_PAT;
 	}
 #endif
