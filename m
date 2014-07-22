Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbaGVTD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:03:57 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:61149 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451AbaGVTBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:01:25 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        linux-kernel@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 1/8] xtensa: make fixmap region addressing grow with index
Date: Tue, 22 Jul 2014 23:01:06 +0400
Message-Id: <1406055673-10100-2-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
References: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's much easier to reason about alignment and coloring of regions
located in the fixmap when fixmap index is just a PFN within the fixmap
region. Change fixmap addressing so that index 0 corresponds to
FIXADDR_START instead of the FIXADDR_TOP.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/include/asm/fixmap.h | 27 ++++++++++++++++++++++++---
 arch/xtensa/mm/highmem.c         |  6 +++---
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/include/asm/fixmap.h b/arch/xtensa/include/asm/fixmap.h
index 9f6c33d0..a43cd52 100644
--- a/arch/xtensa/include/asm/fixmap.h
+++ b/arch/xtensa/include/asm/fixmap.h
@@ -23,8 +23,8 @@
  * Here we define all the compile-time 'special' virtual
  * addresses. The point is to have a constant address at
  * compile time, but to set the physical address only
- * in the boot process. We allocate these special  addresses
- * from the end of the consistent memory region backwards.
+ * in the boot process. We allocate these special addresses
+ * from the start of the consistent memory region upwards.
  * Also this lets us do fail-safe vmalloc(), we
  * can guarantee that these special addresses and
  * vmalloc()-ed addresses never overlap.
@@ -47,7 +47,28 @@ enum fixed_addresses {
 #define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START	((FIXADDR_TOP - FIXADDR_SIZE) & PMD_MASK)
 
-#include <asm-generic/fixmap.h>
+#define __fix_to_virt(x)	(FIXADDR_START + ((x) << PAGE_SHIFT))
+#define __virt_to_fix(x)	(((x) - FIXADDR_START) >> PAGE_SHIFT)
+
+#ifndef __ASSEMBLY__
+/*
+ * 'index to address' translation. If anyone tries to use the idx
+ * directly without translation, we catch the bug with a NULL-deference
+ * kernel oops. Illegal ranges of incoming indices are caught too.
+ */
+static __always_inline unsigned long fix_to_virt(const unsigned int idx)
+{
+	BUILD_BUG_ON(idx >= __end_of_fixed_addresses);
+	return __fix_to_virt(idx);
+}
+
+static inline unsigned long virt_to_fix(const unsigned long vaddr)
+{
+	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
+	return __virt_to_fix(vaddr);
+}
+
+#endif
 
 #define kmap_get_fixmap_pte(vaddr) \
 	pte_offset_kernel( \
diff --git a/arch/xtensa/mm/highmem.c b/arch/xtensa/mm/highmem.c
index 17a8c0d..2e95a76 100644
--- a/arch/xtensa/mm/highmem.c
+++ b/arch/xtensa/mm/highmem.c
@@ -28,9 +28,9 @@ void *kmap_atomic(struct page *page)
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
-	BUG_ON(!pte_none(*(kmap_pte - idx)));
+	BUG_ON(!pte_none(*(kmap_pte + idx)));
 #endif
-	set_pte(kmap_pte - idx, mk_pte(page, PAGE_KERNEL_EXEC));
+	set_pte(kmap_pte + idx, mk_pte(page, PAGE_KERNEL_EXEC));
 
 	return (void *)vaddr;
 }
@@ -51,7 +51,7 @@ void __kunmap_atomic(void *kvaddr)
 		 * is a bad idea also, in case the page changes cacheability
 		 * attributes or becomes a protected page in a hypervisor.
 		 */
-		pte_clear(&init_mm, kvaddr, kmap_pte - idx);
+		pte_clear(&init_mm, kvaddr, kmap_pte + idx);
 		local_flush_tlb_kernel_range((unsigned long)kvaddr,
 					     (unsigned long)kvaddr + PAGE_SIZE);
 
-- 
1.8.1.4

