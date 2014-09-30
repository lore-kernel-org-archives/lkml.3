Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaI3Kfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:35:40 -0400
Received: from ozlabs.org ([103.22.144.67]:55053 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaI3Kfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:35:38 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2 03/17] powerpc/cell: Make spu_flush_all_slbs() generic
Date: Tue, 30 Sep 2014 20:34:52 +1000
Message-Id: <1412073306-13812-4-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412073306-13812-1-git-send-email-mikey@neuling.org>
References: <1412073306-13812-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This moves spu_flush_all_slbs() into a generic call copro_flush_all_slbs().

This will be useful when we add cxl which also needs a similar SLB flush call.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/include/asm/copro.h |  6 ++++++
 arch/powerpc/mm/copro_fault.c    |  9 +++++++++
 arch/powerpc/mm/hash_utils_64.c  | 10 +++-------
 arch/powerpc/mm/slice.c          | 10 +++-------
 4 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/copro.h b/arch/powerpc/include/asm/copro.h
index 2858108..f3d338f 100644
--- a/arch/powerpc/include/asm/copro.h
+++ b/arch/powerpc/include/asm/copro.h
@@ -15,4 +15,10 @@ int copro_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
 
 int copro_data_segment(struct mm_struct *mm, u64 ea, u64 *esid, u64 *vsid);
 
+
+#ifdef CONFIG_PPC_COPRO_BASE
+void copro_flush_all_slbs(struct mm_struct *mm);
+#else
+#define copro_flush_all_slbs(mm) do {} while(0)
+#endif
 #endif /* _ASM_POWERPC_COPRO_H */
diff --git a/arch/powerpc/mm/copro_fault.c b/arch/powerpc/mm/copro_fault.c
index b865697..939abdf 100644
--- a/arch/powerpc/mm/copro_fault.c
+++ b/arch/powerpc/mm/copro_fault.c
@@ -24,6 +24,7 @@
 #include <linux/mm.h>
 #include <linux/export.h>
 #include <asm/reg.h>
+#include <asm/spu.h>
 
 /*
  * This ought to be kept in sync with the powerpc specific do_page_fault
@@ -138,3 +139,11 @@ int copro_data_segment(struct mm_struct *mm, u64 ea, u64 *esid, u64 *vsid)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(copro_data_segment);
+
+void copro_flush_all_slbs(struct mm_struct *mm)
+{
+#ifdef CONFIG_SPU_BASE
+	spu_flush_all_slbs(mm);
+#endif
+}
+EXPORT_SYMBOL_GPL(copro_flush_all_slbs);
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index daee7f4..5c0738d 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -51,7 +51,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cputable.h>
 #include <asm/sections.h>
-#include <asm/spu.h>
+#include <asm/copro.h>
 #include <asm/udbg.h>
 #include <asm/code-patching.h>
 #include <asm/fadump.h>
@@ -901,9 +901,7 @@ void demote_segment_4k(struct mm_struct *mm, unsigned long addr)
 	if (get_slice_psize(mm, addr) == MMU_PAGE_4K)
 		return;
 	slice_set_range_psize(mm, addr, 1, MMU_PAGE_4K);
-#ifdef CONFIG_SPU_BASE
-	spu_flush_all_slbs(mm);
-#endif
+	copro_flush_all_slbs(mm);
 	if (get_paca_psize(addr) != MMU_PAGE_4K) {
 		get_paca()->context = mm->context;
 		slb_flush_and_rebolt();
@@ -1141,9 +1139,7 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 			       "to 4kB pages because of "
 			       "non-cacheable mapping\n");
 			psize = mmu_vmalloc_psize = MMU_PAGE_4K;
-#ifdef CONFIG_SPU_BASE
-			spu_flush_all_slbs(mm);
-#endif
+			copro_flush_all_slbs(mm);
 		}
 	}
 
diff --git a/arch/powerpc/mm/slice.c b/arch/powerpc/mm/slice.c
index b0c75cc..a81791c 100644
--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -32,7 +32,7 @@
 #include <linux/export.h>
 #include <asm/mman.h>
 #include <asm/mmu.h>
-#include <asm/spu.h>
+#include <asm/copro.h>
 
 /* some sanity checks */
 #if (PGTABLE_RANGE >> 43) > SLICE_MASK_SIZE
@@ -232,9 +232,7 @@ static void slice_convert(struct mm_struct *mm, struct slice_mask mask, int psiz
 
 	spin_unlock_irqrestore(&slice_convert_lock, flags);
 
-#ifdef CONFIG_SPU_BASE
-	spu_flush_all_slbs(mm);
-#endif
+	copro_flush_all_slbs(mm);
 }
 
 /*
@@ -671,9 +669,7 @@ void slice_set_psize(struct mm_struct *mm, unsigned long address,
 
 	spin_unlock_irqrestore(&slice_convert_lock, flags);
 
-#ifdef CONFIG_SPU_BASE
-	spu_flush_all_slbs(mm);
-#endif
+	copro_flush_all_slbs(mm);
 }
 
 void slice_set_range_psize(struct mm_struct *mm, unsigned long start,
-- 
1.9.1

