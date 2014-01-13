Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaAMQIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:08:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53852 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbaAMQFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 205/208] parisc: Ensure full cache coherency for kmap/kunmap
Date: Mon, 13 Jan 2014 16:00:46 +0000
Message-Id: <1389628849-1614-206-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit f8dae00684d678afa13041ef170cecfd1297ed40 upstream.

Helge Deller noted a few weeks ago problems with the AIO support on
parisc. This change is the result of numerous iterations on how best to
deal with this problem.

The solution adopted here is to provide full cache coherency in a
uniform manner on all parisc systems. This involves calling
flush_dcache_page() on kmap operations and flush_kernel_dcache_page() on
kunmap operations. As a result, the copy_user_page() and
clear_user_page() functions can be removed and the overall code is
simpler.

The change ensures that both userspace and kernel aliases to a mapped
page are invalidated and flushed. This is necessary for the correct
operation of PA8800 and PA8900 based systems which do not support
inequivalent aliases.

With this change, I have observed no cache related issues on c8000 and
rp3440. It is now possible for example to do kernel builds with "-j64"
on four way systems.

On systems using XFS file systems, the patch recently posted by Mikulas
Patocka to "fix crash using XFS on loopback" is needed to avoid a hang
caused by an uninitialized lock passed to flush_dcache_page() in the
page struct.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/parisc/include/asm/cacheflush.h | 12 ++++--------
 arch/parisc/include/asm/page.h       |  5 ++---
 arch/parisc/kernel/cache.c           | 35 -----------------------------------
 3 files changed, 6 insertions(+), 46 deletions(-)

diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/asm/cacheflush.h
index f0e2784..2f9b751 100644
--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -125,42 +125,38 @@ flush_anon_page(struct vm_area_struct *vma, struct page *page, unsigned long vma
 void mark_rodata_ro(void);
 #endif
 
-#ifdef CONFIG_PA8X00
-/* Only pa8800, pa8900 needs this */
-
 #include <asm/kmap_types.h>
 
 #define ARCH_HAS_KMAP
 
-void kunmap_parisc(void *addr);
-
 static inline void *kmap(struct page *page)
 {
 	might_sleep();
+	flush_dcache_page(page);
 	return page_address(page);
 }
 
 static inline void kunmap(struct page *page)
 {
-	kunmap_parisc(page_address(page));
+	flush_kernel_dcache_page_addr(page_address(page));
 }
 
 static inline void *kmap_atomic(struct page *page)
 {
 	pagefault_disable();
+	flush_dcache_page(page);
 	return page_address(page);
 }
 
 static inline void __kunmap_atomic(void *addr)
 {
-	kunmap_parisc(addr);
+	flush_kernel_dcache_page_addr(addr);
 	pagefault_enable();
 }
 
 #define kmap_atomic_prot(page, prot)	kmap_atomic(page)
 #define kmap_atomic_pfn(pfn)	kmap_atomic(pfn_to_page(pfn))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
-#endif
 
 #endif /* _PARISC_CACHEFLUSH_H */
 
diff --git a/arch/parisc/include/asm/page.h b/arch/parisc/include/asm/page.h
index b7adb2a..c53fc63 100644
--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -28,9 +28,8 @@ struct page;
 
 void clear_page_asm(void *page);
 void copy_page_asm(void *to, void *from);
-void clear_user_page(void *vto, unsigned long vaddr, struct page *pg);
-void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
-			   struct page *pg);
+#define clear_user_page(vto, vaddr, page) clear_page_asm(vto)
+#define copy_user_page(vto, vfrom, vaddr, page) copy_page_asm(vto, vfrom)
 
 /* #define CONFIG_PARISC_TMPALIAS */
 
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index c035673..a725455 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -388,41 +388,6 @@ void flush_kernel_dcache_page_addr(void *addr)
 }
 EXPORT_SYMBOL(flush_kernel_dcache_page_addr);
 
-void clear_user_page(void *vto, unsigned long vaddr, struct page *page)
-{
-	clear_page_asm(vto);
-	if (!parisc_requires_coherency())
-		flush_kernel_dcache_page_asm(vto);
-}
-EXPORT_SYMBOL(clear_user_page);
-
-void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
-	struct page *pg)
-{
-	/* Copy using kernel mapping.  No coherency is needed
-	   (all in kmap/kunmap) on machines that don't support
-	   non-equivalent aliasing.  However, the `from' page
-	   needs to be flushed before it can be accessed through
-	   the kernel mapping. */
-	preempt_disable();
-	flush_dcache_page_asm(__pa(vfrom), vaddr);
-	preempt_enable();
-	copy_page_asm(vto, vfrom);
-	if (!parisc_requires_coherency())
-		flush_kernel_dcache_page_asm(vto);
-}
-EXPORT_SYMBOL(copy_user_page);
-
-#ifdef CONFIG_PA8X00
-
-void kunmap_parisc(void *addr)
-{
-	if (parisc_requires_coherency())
-		flush_kernel_dcache_page_addr(addr);
-}
-EXPORT_SYMBOL(kunmap_parisc);
-#endif
-
 void purge_tlb_entries(struct mm_struct *mm, unsigned long addr)
 {
 	unsigned long flags;
-- 
1.8.3.2

