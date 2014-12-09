Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaLIWVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:21:54 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:53125 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaLIWVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:21:53 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Kevin Cernekee <cernekee@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH] hexagon: Fix build failures in linux-next
Date: Tue,  9 Dec 2014 14:21:45 -0800
Message-Id: <1418163705-1816-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A010201.54877601.02A2,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hexagon:defconfig fails to build in linux-next since commit 332fd7c4fef5
("genirq: Generic chip: Change irq_reg_{readl,writel} arguments").

The primary build failure is

arch/hexagon/include/asm/cacheflush.h: In function 'copy_to_user_page':
arch/hexagon/include/asm/cacheflush.h:89:22: error: 'VM_EXEC' undeclared

This is the result of including of <linux/io.h> from <linux/irq.h>,
which is now necessary due to the use of readl and writel from irq.h.
This causes recursive inclusions in hexagon code; cacheflush.h is included
from mm.h prior to the definition of VM_EXEC.

Fix the problem by moving copy_to_user_page from the hexagon include file to
arch/hexagon/mm/cache.c, similar to other architectures. After this change,
several redefinitions of readl and writel are reported. Those are caused
by recursive inclusions of io.h and asm/cacheflush.h. Fix those problems by
reducing the number of files included from those files. Also, it was necessary
to stop including asm-generic/cacheflush.h from asm/cacheflush.h. Instead,
functionality originally provided by asm-generic/cacheflush.h is now coded
in asm/cacheflush.h directly.

Cc: Kevin Cernekee <cernekee@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Compile tested only. Applies to linux-next as well as mainline.

 arch/hexagon/include/asm/cacheflush.h | 36 ++++++++++++++++++-----------------
 arch/hexagon/include/asm/io.h         |  5 -----
 arch/hexagon/kernel/setup.c           |  1 +
 arch/hexagon/mm/cache.c               | 10 ++++++++++
 arch/hexagon/mm/ioremap.c             |  1 +
 5 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/arch/hexagon/include/asm/cacheflush.h b/arch/hexagon/include/asm/cacheflush.h
index 49e0896..b86f9f3 100644
--- a/arch/hexagon/include/asm/cacheflush.h
+++ b/arch/hexagon/include/asm/cacheflush.h
@@ -21,10 +21,7 @@
 #ifndef _ASM_CACHEFLUSH_H
 #define _ASM_CACHEFLUSH_H
 
-#include <linux/cache.h>
-#include <linux/mm.h>
-#include <asm/string.h>
-#include <asm-generic/cacheflush.h>
+#include <linux/mm_types.h>
 
 /* Cache flushing:
  *
@@ -41,6 +38,20 @@
 #define LINESIZE	32
 #define LINEBITS	5
 
+#define flush_cache_all()			do { } while (0)
+#define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
+#define flush_cache_range(vma, start, end)	do { } while (0)
+#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
+#define flush_dcache_page(page)			do { } while (0)
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
+#define flush_icache_page(vma, pg)		do { } while (0)
+#define flush_icache_user_range(vma, pg, adr, len)	do { } while (0)
+#define flush_cache_vmap(start, end)		do { } while (0)
+#define flush_cache_vunmap(start, end)		do { } while (0)
+
 /*
  * Flush Dcache range through current map.
  */
@@ -49,7 +60,6 @@ extern void flush_dcache_range(unsigned long start, unsigned long end);
 /*
  * Flush Icache range through current map.
  */
-#undef flush_icache_range
 extern void flush_icache_range(unsigned long start, unsigned long end);
 
 /*
@@ -79,19 +89,11 @@ static inline void update_mmu_cache(struct vm_area_struct *vma,
 	/*  generic_ptrace_pokedata doesn't wind up here, does it?  */
 }
 
-#undef copy_to_user_page
-static inline void copy_to_user_page(struct vm_area_struct *vma,
-					     struct page *page,
-					     unsigned long vaddr,
-					     void *dst, void *src, int len)
-{
-	memcpy(dst, src, len);
-	if (vma->vm_flags & VM_EXEC) {
-		flush_icache_range((unsigned long) dst,
-		(unsigned long) dst + len);
-	}
-}
+void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
+		       unsigned long vaddr, void *dst, void *src, int len);
 
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+	memcpy(dst, src, len)
 
 extern void hexagon_inv_dcache_range(unsigned long start, unsigned long end);
 extern void hexagon_clean_dcache_range(unsigned long start, unsigned long end);
diff --git a/arch/hexagon/include/asm/io.h b/arch/hexagon/include/asm/io.h
index 7029899..66f5e9a 100644
--- a/arch/hexagon/include/asm/io.h
+++ b/arch/hexagon/include/asm/io.h
@@ -24,14 +24,9 @@
 #ifdef __KERNEL__
 
 #include <linux/types.h>
-#include <linux/delay.h>
-#include <linux/vmalloc.h>
-#include <asm/string.h>
-#include <asm/mem-layout.h>
 #include <asm/iomap.h>
 #include <asm/page.h>
 #include <asm/cacheflush.h>
-#include <asm/tlbflush.h>
 
 /*
  * We don't have PCI yet.
diff --git a/arch/hexagon/kernel/setup.c b/arch/hexagon/kernel/setup.c
index 0e7c1db..6981949 100644
--- a/arch/hexagon/kernel/setup.c
+++ b/arch/hexagon/kernel/setup.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/delay.h>
 #include <linux/bootmem.h>
 #include <linux/mmzone.h>
 #include <linux/mm.h>
diff --git a/arch/hexagon/mm/cache.c b/arch/hexagon/mm/cache.c
index 0c76c80..a7c6d82 100644
--- a/arch/hexagon/mm/cache.c
+++ b/arch/hexagon/mm/cache.c
@@ -127,3 +127,13 @@ void flush_cache_all_hexagon(void)
 	local_irq_restore(flags);
 	mb();
 }
+
+void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
+		       unsigned long vaddr, void *dst, void *src, int len)
+{
+	memcpy(dst, src, len);
+	if (vma->vm_flags & VM_EXEC) {
+		flush_icache_range((unsigned long) dst,
+		(unsigned long) dst + len);
+	}
+}
diff --git a/arch/hexagon/mm/ioremap.c b/arch/hexagon/mm/ioremap.c
index 5905fd5..d27d672 100644
--- a/arch/hexagon/mm/ioremap.c
+++ b/arch/hexagon/mm/ioremap.c
@@ -20,6 +20,7 @@
 
 #include <linux/io.h>
 #include <linux/vmalloc.h>
+#include <linux/mm.h>
 
 void __iomem *ioremap_nocache(unsigned long phys_addr, unsigned long size)
 {
-- 
1.9.1

