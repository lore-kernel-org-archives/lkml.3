Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030486AbaGCJ4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:56:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52035 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965004AbaGCJXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 100/198] powerpc/mm: Check paca psize is up to date for huge mappings
Date: Thu,  3 Jul 2014 10:19:03 +0100
Message-Id: <1404379241-8590-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

commit 09567e7fd44291bfc08accfdd67ad8f467842332 upstream.

We have a bug in our hugepage handling which exhibits as an infinite
loop of hash faults. If the fault is being taken in the kernel it will
typically trigger the softlockup detector, or the RCU stall detector.

The bug is as follows:

 1. mmap(0xa0000000, ..., MAP_FIXED | MAP_HUGE_TLB | MAP_ANONYMOUS ..)
 2. Slice code converts the slice psize to 16M.
 3. The code on lines 539-540 of slice.c in slice_get_unmapped_area()
    synchronises the mm->context with the paca->context. So the paca slice
    mask is updated to include the 16M slice.
 3. Either:
    * mmap() fails because there are no huge pages available.
    * mmap() succeeds and the mapping is then munmapped.
    In both cases the slice psize remains at 16M in both the paca & mm.
 4. mmap(0xa0000000, ..., MAP_FIXED | MAP_ANONYMOUS ..)
 5. The slice psize is converted back to 64K. Because of the check on line 539
    of slice.c we DO NOT update the paca->context. The paca slice mask is now
    out of sync with the mm slice mask.
 6. User/kernel accesses 0xa0000000.
 7. The SLB miss handler slb_allocate_realmode() **uses the paca slice mask**
    to create an SLB entry and inserts it in the SLB.
18. With the 16M SLB entry in place the hardware does a hash lookup, no entry
    is found so a data access exception is generated.
19. The data access handler calls do_page_fault() -> handle_mm_fault().
10. __handle_mm_fault() creates a THP mapping with do_huge_pmd_anonymous_page().
11. The hardware retries the access, there is still nothing in the hash table
    so once again a data access exception is generated.
12. hash_page() calls into __hash_page_thp() and inserts a mapping in the
    hash. Although the THP mapping maps 16M the hashing is done using 64K
    as the segment page size.
13. hash_page() returns immediately after calling __hash_page_thp(), skipping
    over the code at line 1125. Resulting in the mismatch between the
    paca->context and mm->context not being detected.
14. The hardware retries the access, the hash it generates using the 16M
    SLB entry does NOT match the hash we inserted.
15. We take another data access and go into __hash_page_thp().
16. We see a valid entry in the hpte_slot_array and so we call updatepp()
    which succeeds.
17. Goto 14.

We could fix this in two ways. The first would be to remove or modify
the check on line 539 of slice.c.

The second option is to cause the check of paca psize in hash_page() on
line 1125 to also be done for THP pages.

We prefer the latter, because the check & update of the paca psize is
not done until we know it's necessary. It's also done only on the
current cpu, so we don't need to IPI all other cpus.

Without further rearranging the code, the simplest fix is to pull out
the code that checks paca psize and call it in two places. Firstly for
THP/hugetlb, and secondly for other mappings as before.

Thanks to Dave Jones for trinity, which originally found this bug.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/mm/hash_utils_64.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 6ecc38bd5b24..bbda76731fed 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -947,6 +947,22 @@ void hash_failure_debug(unsigned long ea, unsigned long access,
 		trap, vsid, ssize, psize, lpsize, pte);
 }
 
+static void check_paca_psize(unsigned long ea, struct mm_struct *mm,
+			     int psize, bool user_region)
+{
+	if (user_region) {
+		if (psize != get_paca_psize(ea)) {
+			get_paca()->context = mm->context;
+			slb_flush_and_rebolt();
+		}
+	} else if (get_paca()->vmalloc_sllp !=
+		   mmu_psize_defs[mmu_vmalloc_psize].sllp) {
+		get_paca()->vmalloc_sllp =
+			mmu_psize_defs[mmu_vmalloc_psize].sllp;
+		slb_vmalloc_update();
+	}
+}
+
 /* Result code is:
  *  0 - handled
  *  1 - normal page fault
@@ -1068,6 +1084,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 			WARN_ON(1);
 		}
 #endif
+		check_paca_psize(ea, mm, psize, user_region);
+
 		goto bail;
 	}
 
@@ -1108,17 +1126,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 #endif
 		}
 	}
-	if (user_region) {
-		if (psize != get_paca_psize(ea)) {
-			get_paca()->context = mm->context;
-			slb_flush_and_rebolt();
-		}
-	} else if (get_paca()->vmalloc_sllp !=
-		   mmu_psize_defs[mmu_vmalloc_psize].sllp) {
-		get_paca()->vmalloc_sllp =
-			mmu_psize_defs[mmu_vmalloc_psize].sllp;
-		slb_vmalloc_update();
-	}
+
+	check_paca_psize(ea, mm, psize, user_region);
 #endif /* CONFIG_PPC_64K_PAGES */
 
 #ifdef CONFIG_PPC_HAS_HASH_64K
-- 
1.9.1

