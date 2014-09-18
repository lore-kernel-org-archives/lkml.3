Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbaIRIae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:30:34 -0400
Received: from ozlabs.org ([103.22.144.67]:38027 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361AbaIRI1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:27:25 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH 10/15] powerpc/mm: Add hooks for cxl
Date: Thu, 18 Sep 2014 18:26:55 +1000
Message-Id: <1411028820-29933-11-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411028820-29933-1-git-send-email-mikey@neuling.org>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This add a hook into tlbie() so that we use global invalidations when there are
cxl contexts active.

Normally cxl snoops broadcast tlbie.  cxl can have TLB entries invalidated via
MMIO, but we aren't doing that yet.  So for now we are just disabling local
tlbies when cxl contexts are active.  In future we can make tlbie() local mode
smarter so that it invalidates cxl contexts explicitly when it needs to.

This also adds a hooks for when SLBs are invalidated to ensure any
corresponding SLBs in cxl are also invalidated at the same time.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/mm/hash_native_64.c | 6 +++++-
 arch/powerpc/mm/hash_utils_64.c  | 3 +++
 arch/powerpc/mm/slice.c          | 3 +++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/hash_native_64.c b/arch/powerpc/mm/hash_native_64.c
index afc0a82..ae4962a 100644
--- a/arch/powerpc/mm/hash_native_64.c
+++ b/arch/powerpc/mm/hash_native_64.c
@@ -29,6 +29,8 @@
 #include <asm/kexec.h>
 #include <asm/ppc-opcode.h>
 
+#include <misc/cxl.h>
+
 #ifdef DEBUG_LOW
 #define DBG_LOW(fmt...) udbg_printf(fmt)
 #else
@@ -149,9 +151,11 @@ static inline void __tlbiel(unsigned long vpn, int psize, int apsize, int ssize)
 static inline void tlbie(unsigned long vpn, int psize, int apsize,
 			 int ssize, int local)
 {
-	unsigned int use_local = local && mmu_has_feature(MMU_FTR_TLBIEL);
+	unsigned int use_local;
 	int lock_tlbie = !mmu_has_feature(MMU_FTR_LOCKLESS_TLBIE);
 
+	use_local = local && mmu_has_feature(MMU_FTR_TLBIEL) && !cxl_ctx_in_use();
+
 	if (use_local)
 		use_local = mmu_psize_defs[psize].tlbiel;
 	if (lock_tlbie && !use_local)
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 66071af..be40ff7 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -34,6 +34,7 @@
 #include <linux/signal.h>
 #include <linux/memblock.h>
 #include <linux/context_tracking.h>
+#include <misc/cxl.h>
 
 #include <asm/processor.h>
 #include <asm/pgtable.h>
@@ -906,6 +907,7 @@ void demote_segment_4k(struct mm_struct *mm, unsigned long addr)
 #ifdef CONFIG_SPU_BASE
 	spu_flush_all_slbs(mm);
 #endif
+	cxl_slbia(mm);
 	if (get_paca_psize(addr) != MMU_PAGE_4K) {
 		get_paca()->context = mm->context;
 		slb_flush_and_rebolt();
@@ -1145,6 +1147,7 @@ int hash_page_mm(struct mm_struct *mm, unsigned long ea, unsigned long access, u
 #ifdef CONFIG_SPU_BASE
 			spu_flush_all_slbs(mm);
 #endif
+			cxl_slbia(mm);
 		}
 	}
 
diff --git a/arch/powerpc/mm/slice.c b/arch/powerpc/mm/slice.c
index b0c75cc..4d3a34b 100644
--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -30,6 +30,7 @@
 #include <linux/err.h>
 #include <linux/spinlock.h>
 #include <linux/export.h>
+#include <misc/cxl.h>
 #include <asm/mman.h>
 #include <asm/mmu.h>
 #include <asm/spu.h>
@@ -235,6 +236,7 @@ static void slice_convert(struct mm_struct *mm, struct slice_mask mask, int psiz
 #ifdef CONFIG_SPU_BASE
 	spu_flush_all_slbs(mm);
 #endif
+	cxl_slbia(mm);
 }
 
 /*
@@ -674,6 +676,7 @@ void slice_set_psize(struct mm_struct *mm, unsigned long address,
 #ifdef CONFIG_SPU_BASE
 	spu_flush_all_slbs(mm);
 #endif
+	cxl_slbia(mm);
 }
 
 void slice_set_range_psize(struct mm_struct *mm, unsigned long start,
-- 
1.9.1

