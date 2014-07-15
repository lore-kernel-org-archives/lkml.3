Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649AbaGOTpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:45:33 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:38536 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367AbaGOTp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:45:28 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de, konrad.wilk@oracle.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stefan.bader@canonical.com, luto@amacapital.net, airlied@gmail.com,
        bp@alien8.de, Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 1/11] x86, mm, pat: Redefine _PAGE_CACHE_UC as UC_MINUS
Date: Tue, 15 Jul 2014 13:34:34 -0600
Message-Id: <1405452884-25688-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioremap_nocache() and other interfaces that set the uncached memory
type use _PAGE_CACHE_UC_MINUS in order to support legacy graphics
drivers using MTRRs to overwrite it to WC.  _PAGE_CACHE_UC is defined,
but is unused on the systems with the PAT feature.

This patch redefines _PAGE_CACHE_UC to _PAGE_CACHE_UC_MINUS, and
and frees up the PA3/7 slot in the PAT MSR that was used for
_PAGE_CACHE_UC.  This keeps _PAGE_CACHE_UC defined in case out-of-tree
drivers refer it.

Note: The legacy code in phys_mem_access_prot_allowed() that sets
_PAGE_CACHE_UC for Pentiums and earlier processors is changed to
set the PCD & PWT bits in order to avoid any change.  They do not
support PAT and MTRRs.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/include/asm/pgtable_types.h |   10 +++++-----
 arch/x86/mm/ioremap.c                |   14 +++++---------
 arch/x86/mm/pat.c                    |    9 +--------
 arch/x86/mm/pat_internal.h           |    1 -
 4 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index f216963..03d40da 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -133,7 +133,7 @@
 #define _PAGE_CACHE_WB		(0)
 #define _PAGE_CACHE_WC		(_PAGE_PWT)
 #define _PAGE_CACHE_UC_MINUS	(_PAGE_PCD)
-#define _PAGE_CACHE_UC		(_PAGE_PCD | _PAGE_PWT)
+#define _PAGE_CACHE_UC		(_PAGE_CACHE_UC_MINUS)
 
 #define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
 #define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | \
@@ -157,13 +157,13 @@
 
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
-#define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_CACHE_UC)
 #define __PAGE_KERNEL_WC		(__PAGE_KERNEL | _PAGE_CACHE_WC)
-#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
-#define __PAGE_KERNEL_UC_MINUS		(__PAGE_KERNEL | _PAGE_PCD)
+#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_CACHE_UC)
+#define __PAGE_KERNEL_UC_MINUS		(__PAGE_KERNEL | _PAGE_CACHE_UC_MINUS)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
 #define __PAGE_KERNEL_VVAR		(__PAGE_KERNEL_RO | _PAGE_USER)
-#define __PAGE_KERNEL_VVAR_NOCACHE	(__PAGE_KERNEL_VVAR | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_VVAR_NOCACHE	(__PAGE_KERNEL_VVAR | _PAGE_CACHE_UC)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_NOCACHE	(__PAGE_KERNEL | _PAGE_CACHE_UC | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index baff1da..282829f 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -35,7 +35,7 @@ int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 	int err;
 
 	switch (prot_val) {
-	case _PAGE_CACHE_UC:
+	case _PAGE_CACHE_UC_MINUS:
 	default:
 		err = _set_memory_uc(vaddr, nrpages);
 		break;
@@ -142,11 +142,8 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	}
 
 	switch (prot_val) {
-	case _PAGE_CACHE_UC:
-	default:
-		prot = PAGE_KERNEL_IO_NOCACHE;
-		break;
 	case _PAGE_CACHE_UC_MINUS:
+	default:
 		prot = PAGE_KERNEL_IO_UC_MINUS;
 		break;
 	case _PAGE_CACHE_WC:
@@ -218,11 +215,10 @@ void __iomem *ioremap_nocache(resource_size_t phys_addr, unsigned long size)
 	 *	pat_enabled ? _PAGE_CACHE_UC : _PAGE_CACHE_UC_MINUS;
 	 *
 	 * Till we fix all X drivers to use ioremap_wc(), we will use
-	 * UC MINUS.
+	 * UC MINUS. _PAGE_CACHE_UC is also defined as _PAGE_CACHE_UC_MINUS
+	 * in pgtable_types.h.
 	 */
-	unsigned long val = _PAGE_CACHE_UC_MINUS;
-
-	return __ioremap_caller(phys_addr, size, val,
+	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_UC_MINUS,
 				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(ioremap_nocache);
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 6574388..c3567a5 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -213,12 +213,6 @@ static int reserve_ram_pages_type(u64 start, u64 end, unsigned long req_type,
 	struct page *page;
 	u64 pfn;
 
-	if (req_type == _PAGE_CACHE_UC) {
-		/* We do not support strong UC */
-		WARN_ON_ONCE(1);
-		req_type = _PAGE_CACHE_UC_MINUS;
-	}
-
 	for (pfn = (start >> PAGE_SHIFT); pfn < (end >> PAGE_SHIFT); ++pfn) {
 		unsigned long type;
 
@@ -261,7 +255,6 @@ static int free_ram_pages_type(u64 start, u64 end)
  * - _PAGE_CACHE_WB
  * - _PAGE_CACHE_WC
  * - _PAGE_CACHE_UC_MINUS
- * - _PAGE_CACHE_UC
  *
  * If new_type is NULL, function will return an error if it cannot reserve the
  * region with req_type. If new_type is non-NULL, function will return
@@ -543,7 +536,7 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 	      boot_cpu_has(X86_FEATURE_CYRIX_ARR) ||
 	      boot_cpu_has(X86_FEATURE_CENTAUR_MCR)) &&
 	    (pfn << PAGE_SHIFT) >= __pa(high_memory)) {
-		flags = _PAGE_CACHE_UC;
+		flags = _PAGE_PCD | _PAGE_PWT;	/* UC w/o PAT */
 	}
 #endif
 
diff --git a/arch/x86/mm/pat_internal.h b/arch/x86/mm/pat_internal.h
index 77e5ba1..2593d40 100644
--- a/arch/x86/mm/pat_internal.h
+++ b/arch/x86/mm/pat_internal.h
@@ -17,7 +17,6 @@ struct memtype {
 static inline char *cattr_name(unsigned long flags)
 {
 	switch (flags & _PAGE_CACHE_MASK) {
-	case _PAGE_CACHE_UC:		return "uncached";
 	case _PAGE_CACHE_UC_MINUS:	return "uncached-minus";
 	case _PAGE_CACHE_WB:		return "write-back";
 	case _PAGE_CACHE_WC:		return "write-combining";
