Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936962Ab3DJXhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:37:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:22880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762080Ab3DJXhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:37:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="317443106"
Subject: [PATCH 1/5] clean up checks against "high_memory" variable
To: bp@alien8.de
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 10 Apr 2013 16:32:50 -0700
References: <20130410233249.7FFCB63B@viggo.jf.intel.com>
In-Reply-To: <20130410233249.7FFCB63B@viggo.jf.intel.com>
Message-Id: <20130410233250.FF8E7E2D@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We have a new debugging check on x86 that has caught a number
of long-standing bugs.  However, there is a _bit_ of collateral
damage with things that call __pa(high_memory).

We are now checking that any addresses passed to __pa() are
*valid* and can be dereferenced.

"high_memory", however, is not valid.  It marks the start of
highmem, and isn't itself a valid pointer.  But, those users
are really just asking "is this vaddr mapped"?  So, give them
a helper that does that, plus is also kind to our new
debugging check.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/mm/pat.c     |    9 +++++----
 linux.git-davehans/drivers/char/mem.c    |    4 ++--
 linux.git-davehans/drivers/mtd/mtdchar.c |    2 +-
 linux.git-davehans/include/linux/mm.h    |   13 +++++++++++++
 4 files changed, 21 insertions(+), 7 deletions(-)

diff -puN arch/x86/mm/pat.c~clean-up-highmem-checks arch/x86/mm/pat.c
--- linux.git/arch/x86/mm/pat.c~clean-up-highmem-checks	2013-04-10 16:23:44.906086836 -0700
+++ linux.git-davehans/arch/x86/mm/pat.c	2013-04-10 16:23:44.914086844 -0700
@@ -542,7 +542,7 @@ int phys_mem_access_prot_allowed(struct
 	      boot_cpu_has(X86_FEATURE_K6_MTRR) ||
 	      boot_cpu_has(X86_FEATURE_CYRIX_ARR) ||
 	      boot_cpu_has(X86_FEATURE_CENTAUR_MCR)) &&
-	    (pfn << PAGE_SHIFT) >= __pa(high_memory)) {
+	    phys_addr_is_highmem(pfn << PAGE_SHIFT)) {
 		flags = _PAGE_CACHE_UC;
 	}
 #endif
@@ -570,9 +570,10 @@ int kernel_map_sync_memtype(u64 base, un
 	if (!page_is_ram(base >> PAGE_SHIFT))
 		return 0;
 
-	id_sz = (__pa(high_memory-1) <= base + size) ?
-				__pa(high_memory) - base :
-				size;
+	if (phys_addr_is_highmem(base + size - 1))
+		id_sz = last_lowmem_phys_addr() - base + 1;
+	else
+		id_sz = size;
 
 	if (ioremap_change_attr((unsigned long)__va(base), id_sz, flags) < 0) {
 		printk(KERN_INFO "%s:%d ioremap_change_attr failed %s "
diff -puN drivers/char/mem.c~clean-up-highmem-checks drivers/char/mem.c
--- linux.git/drivers/char/mem.c~clean-up-highmem-checks	2013-04-10 16:23:44.907086837 -0700
+++ linux.git-davehans/drivers/char/mem.c	2013-04-10 16:23:44.914086844 -0700
@@ -50,7 +50,7 @@ static inline unsigned long size_inside_
 #ifndef ARCH_HAS_VALID_PHYS_ADDR_RANGE
 static inline int valid_phys_addr_range(phys_addr_t addr, size_t count)
 {
-	return addr + count <= __pa(high_memory);
+	return !phys_addr_is_highmem(addr + count);
 }
 
 static inline int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
@@ -249,7 +249,7 @@ static int uncached_access(struct file *
 	 */
 	if (file->f_flags & O_DSYNC)
 		return 1;
-	return addr >= __pa(high_memory);
+	return phys_addr_is_highmem(addr);
 #endif
 }
 #endif
diff -puN drivers/mtd/mtdchar.c~clean-up-highmem-checks drivers/mtd/mtdchar.c
--- linux.git/drivers/mtd/mtdchar.c~clean-up-highmem-checks	2013-04-10 16:23:44.909086839 -0700
+++ linux.git-davehans/drivers/mtd/mtdchar.c	2013-04-10 16:23:44.915086845 -0700
@@ -1189,7 +1189,7 @@ static int mtdchar_mmap(struct file *fil
 		vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 
 #ifdef pgprot_noncached
-		if (file->f_flags & O_DSYNC || off >= __pa(high_memory))
+		if (file->f_flags & O_DSYNC || phys_addr_is_highmem(off))
 			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 #endif
 		if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
diff -puN include/linux/mm.h~clean-up-highmem-checks include/linux/mm.h
--- linux.git/include/linux/mm.h~clean-up-highmem-checks	2013-04-10 16:23:44.910086840 -0700
+++ linux.git-davehans/include/linux/mm.h	2013-04-10 16:23:44.916086846 -0700
@@ -1754,5 +1754,18 @@ static inline unsigned int debug_guardpa
 static inline bool page_is_guard(struct page *page) { return false; }
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
+static inline phys_addr_t last_lowmem_phys_addr(void)
+{
+	/*
+	 * 'high_memory' is not a pointer that can be dereferenced, so
+	 * avoid calling __pa() on it directly.
+	 */
+	return __pa(high_memory - 1);
+}
+static inline bool phys_addr_is_highmem(phys_addr_t addr)
+{
+	return addr > last_lowmem_phys_addr();
+}
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
_
