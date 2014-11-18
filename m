Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbaKRRVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:21:51 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34944 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbaKRRVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:21:49 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-72-546b802abcce
Subject: [PATCH RFC] ARM: option for loading modules into vmalloc area
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Date: Tue, 18 Nov 2014 20:21:46 +0400
Message-id: <20141118172146.3784.81151.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xK7paDdkhBhPXaVps+/WIzeLHzl5W
	i02Pr7FaXN41h83i9mVeB1aPluYeNo/NS+o9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+Pe
	rZNMBR0hFX+flDcwXnbuYuTkkBAwkZh+eQojhC0mceHeerYuRi4OIYGljBKf30xjgXAamST2
	3brLAlIlLOAmsXblEjCbTcBMYtu+22DdIgL5El8P7GEDsZkFdCQ2XmtlArFZBFQlZs/dxAxi
	8woYSRw8shAsLiogJ7HycgsrRFxQ4sfke0AzOYB61SWmTMmFGCMvsXnNW+YJjHyzkFTNQqia
	haRqASPzKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQcPyyg3HxMatDjAIcjEo8vA0bs0KE
	WBPLiitzDzFKcDArifCe6wYK8aYkVlalFuXHF5XmpBYfYmTi4JRqYAw4sy6/rrx5/Q33TXV5
	E1dMmr/p92tOM6+JIW8rjsedeZJyq2lKsMKC5Knnm6faxQpXaXDHLD55dYu0f4fbLlHBPzbd
	ogdlbrlLljPtEmx7Zna7pbVl3alkVatTQkz/r07WTtRjENu4I+atJWtVZvPNPZ4KW1zD3h9h
	2Hv+gNWyl/zHDtbdCFViKc5INNRiLipOBAAt0Eo5JQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually modules are loaded into small area prior to the kernel
text because they are linked with the kernel using short calls.
Compile-time instrumentation like GCOV or KASAN bloats code a lot,
and as a result huge modules no longer fit into reserved area.

This patch adds option CONFIG_MODULES_USE_VMALLOC which lifts
limitation on amount of loaded modules. It links modules using
long-calls (option -mlong-calls) and loads them into vmalloc area.

In few places exported symbols are called from inline assembly.
This patch adds macro for such call sites: __asmbl and __asmbl_clobber.
Call turns into single 'bl' or sequence 'movw; movt; blx' depending on
context and state of config option.

Unfortunately this option isn't compatible with CONFIG_FUNCTION_TRACER.
Compiler emits short calls to profiling function despite of -mlong-calls.
This is a bug in GCC, but ftrace anyway needs an update to handle this.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 arch/arm/Kconfig                |   20 ++++++++++++++++++++
 arch/arm/Makefile               |    4 ++++
 arch/arm/include/asm/compiler.h |   13 +++++++++++++
 arch/arm/include/asm/div64.h    |    2 +-
 arch/arm/include/asm/memory.h   |   11 +++++++++++
 arch/arm/include/asm/uaccess.h  |   16 ++++++++--------
 arch/arm/kernel/module.c        |    2 ++
 arch/arm/mm/dump.c              |   10 +++++++++-
 arch/arm/mm/init.c              |    2 ++
 arch/arm/mm/mmu.c               |    7 +++----
 arch/arm/mm/pgd.c               |    5 +++--
 11 files changed, 76 insertions(+), 16 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 89c4b5c..7fc4b22 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1686,6 +1686,26 @@ config HIGHPTE
 	bool "Allocate 2nd-level pagetables from highmem"
 	depends on HIGHMEM
 
+config MODULES_USE_LONG_CALLS
+	bool
+	help
+	  Use long calls for calling exported symbols.
+
+config MODULES_USE_VMALLOC
+	bool "Put modules into vmalloc area"
+	select MODULES_USE_LONG_CALLS
+	depends on MMU && MODULES
+	depends on !XIP_KERNEL
+	depends on !FUNCTION_TRACER
+	help
+	  Usually modules are loaded into small area prior to the kernel text
+	  because they are linked with the kernel using short calls.
+
+	  This option enables long calls and moves modules into vmalloc area.
+	  This allows to load more modules but adds some perfromance penalty.
+
+	  If unsure, say n.
+
 config HW_PERF_EVENTS
 	bool "Enable hardware performance counter support for perf events"
 	depends on PERF_EVENTS
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 034a949..64541db 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -117,6 +117,10 @@ CFLAGS_ISA	:=$(call cc-option,-marm,)
 AFLAGS_ISA	:=$(CFLAGS_ISA)
 endif
 
+ifeq ($(CONFIG_MODULES_USE_LONG_CALLS),y)
+CFLAGS_MODULE	+= -mlong-calls
+endif
+
 # Need -Uarm for gcc < 3.x
 KBUILD_CFLAGS	+=$(CFLAGS_ABI) $(CFLAGS_ISA) $(arch-y) $(tune-y) $(call cc-option,-mshort-load-bytes,$(call cc-option,-malignment-traps,)) -msoft-float -Uarm
 KBUILD_AFLAGS	+=$(CFLAGS_ABI) $(AFLAGS_ISA) $(arch-y) $(tune-y) -include asm/unified.h -msoft-float
diff --git a/arch/arm/include/asm/compiler.h b/arch/arm/include/asm/compiler.h
index 8155db2..d953067 100644
--- a/arch/arm/include/asm/compiler.h
+++ b/arch/arm/include/asm/compiler.h
@@ -11,5 +11,18 @@
  */
 #define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"
 
+/*
+ * This is used for calling exported symbols from inline assembly code.
+ */
+#if defined(MODULE) && defined(CONFIG_MODULES_USE_LONG_CALLS)
+#define __asmbl(cond, reg, target) \
+	"movw	" reg ", #:lower16:" target "\n\t" \
+	"movt	" reg ", #:upper16:" target "\n\t" \
+	"blx" cond "	" reg "\n\t"
+#define __asmbl_clobber(reg)	,reg
+#else
+#define __asmbl(cond, reg, target) "bl" cond "	" target"\n\t"
+#define __asmbl_clobber(reg)
+#endif
 
 #endif /* __ASM_ARM_COMPILER_H */
diff --git a/arch/arm/include/asm/div64.h b/arch/arm/include/asm/div64.h
index 662c7bd..fc7548d 100644
--- a/arch/arm/include/asm/div64.h
+++ b/arch/arm/include/asm/div64.h
@@ -38,7 +38,7 @@
 		__asmeq("%1", "r2")				\
 		__asmeq("%2", "r0")				\
 		__asmeq("%3", "r4")				\
-		"bl	__do_div64"				\
+		__asmbl("", "ip",  "__do_div64")		\
 		: "=r" (__rem), "=r" (__res)			\
 		: "r" (__n), "r" (__base)			\
 		: "ip", "lr", "cc");				\
diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index e731018..17745c2 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -47,6 +47,15 @@
  */
 #define TASK_SIZE_26		(UL(1) << 26)
 
+#ifdef CONFIG_MODULES_USE_VMALLOC
+/*
+ * Modules might be anywhere in the vmalloc area.
+ */
+#define MODULES_VADDR		VMALLOC_START
+#define MODULES_END		VMALLOC_END
+
+#else /* CONFIG_MODULES_USE_VMALLOC */
+
 /*
  * The module space lives between the addresses given by TASK_SIZE
  * and PAGE_OFFSET - it must be within 32MB of the kernel text.
@@ -71,6 +80,8 @@
 #define MODULES_END		(PAGE_OFFSET)
 #endif
 
+#endif /* CONFIG_MODULES_USE_VMALLOC */
+
 /*
  * The XIP kernel gets mapped at the bottom of the module vm area.
  * Since we use sections to map it, this macro replaces the physical address
diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 4767eb9..c4c8d26 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -113,21 +113,21 @@ extern int __get_user_64t_1(void *);
 extern int __get_user_64t_2(void *);
 extern int __get_user_64t_4(void *);
 
-#define __GUP_CLOBBER_1	"lr", "cc"
+#define __GUP_CLOBBER_1	"lr", "cc" __asmbl_clobber("ip")
 #ifdef CONFIG_CPU_USE_DOMAINS
 #define __GUP_CLOBBER_2	"ip", "lr", "cc"
 #else
-#define __GUP_CLOBBER_2 "lr", "cc"
+#define __GUP_CLOBBER_2 "lr", "cc" __asmbl_clobber("ip")
 #endif
-#define __GUP_CLOBBER_4	"lr", "cc"
-#define __GUP_CLOBBER_32t_8 "lr", "cc"
-#define __GUP_CLOBBER_8	"lr", "cc"
+#define __GUP_CLOBBER_4	"lr", "cc" __asmbl_clobber("ip")
+#define __GUP_CLOBBER_32t_8 "lr", "cc" __asmbl_clobber("ip")
+#define __GUP_CLOBBER_8	"lr", "cc" __asmbl_clobber("ip")
 
 #define __get_user_x(__r2,__p,__e,__l,__s)				\
 	   __asm__ __volatile__ (					\
 		__asmeq("%0", "r0") __asmeq("%1", "r2")			\
 		__asmeq("%3", "r1")					\
-		"bl	__get_user_" #__s				\
+		__asmbl("", "ip", "__get_user_" #__s)			\
 		: "=&r" (__e), "=r" (__r2)				\
 		: "0" (__p), "r" (__l)					\
 		: __GUP_CLOBBER_##__s)
@@ -149,7 +149,7 @@ extern int __get_user_64t_4(void *);
 	   __asm__ __volatile__ (					\
 		__asmeq("%0", "r0") __asmeq("%1", "r2")			\
 		__asmeq("%3", "r1")					\
-		"bl	__get_user_64t_" #__s				\
+		__asmbl("", "ip", "__get_user_64t_" #__s)		\
 		: "=&r" (__e), "=r" (__r2)				\
 		: "0" (__p), "r" (__l)					\
 		: __GUP_CLOBBER_##__s)
@@ -211,7 +211,7 @@ extern int __put_user_8(void *, unsigned long long);
 	   __asm__ __volatile__ (					\
 		__asmeq("%0", "r0") __asmeq("%2", "r2")			\
 		__asmeq("%3", "r1")					\
-		"bl	__put_user_" #__s				\
+		__asmbl("", "ip", "__put_user_" #__s)			\
 		: "=&r" (__e)						\
 		: "0" (__p), "r" (__r2), "r" (__l)			\
 		: "ip", "lr", "cc")
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index 6a4dffe..081da90 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -38,12 +38,14 @@
 #endif
 
 #ifdef CONFIG_MMU
+#ifndef CONFIG_MODULES_USE_VMALLOC
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
 				GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
+#endif /* CONFIG_MODULES_USE_VMALLOC */
 #endif
 
 int
diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
index 5942493..d4d4f75d 100644
--- a/arch/arm/mm/dump.c
+++ b/arch/arm/mm/dump.c
@@ -19,6 +19,7 @@
 
 #include <asm/fixmap.h>
 #include <asm/pgtable.h>
+#include <asm/highmem.h>
 
 struct addr_marker {
 	unsigned long start_address;
@@ -26,7 +27,12 @@ struct addr_marker {
 };
 
 static struct addr_marker address_markers[] = {
+#ifndef CONFIG_MODULES_USE_VMALLOC
 	{ MODULES_VADDR,	"Modules" },
+#endif
+#ifdef CONFIG_HIGHMEM
+	{ PKMAP_BASE,		"Page kmap" },
+#endif
 	{ PAGE_OFFSET,		"Kernel Mapping" },
 	{ 0,			"vmalloc() Area" },
 	{ VMALLOC_END,		"vmalloc() End" },
@@ -356,7 +362,9 @@ static int ptdump_init(void)
 			for (j = 0; j < pg_level[i].num; j++)
 				pg_level[i].mask |= pg_level[i].bits[j].mask;
 
-	address_markers[2].start_address = VMALLOC_START;
+	i = 1 + !IS_ENABLED(CONFIG_MODULES_USE_VMALLOC) +
+		!!IS_ENABLED(CONFIG_HIGHMEM);
+	address_markers[i].start_address = VMALLOC_START;
 
 	pe = debugfs_create_file("kernel_page_tables", 0400, NULL, NULL,
 				 &ptdump_fops);
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 9481f85..985aed8 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -595,7 +595,9 @@ void __init mem_init(void)
 	 * be detected at build time already.
 	 */
 #ifdef CONFIG_MMU
+#ifndef CONFIG_MODULES_USE_VMALLOC
 	BUILD_BUG_ON(TASK_SIZE				> MODULES_VADDR);
+#endif
 	BUG_ON(TASK_SIZE 				> MODULES_VADDR);
 #endif
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 9d2cdda..9e0c4f4 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1161,16 +1161,15 @@ void __init sanity_check_meminfo(void)
 
 static inline void prepare_page_table(void)
 {
-	unsigned long addr;
+	unsigned long addr = 0;
 	phys_addr_t end;
 
 	/*
 	 * Clear out all the mappings below the kernel image.
 	 */
-	for (addr = 0; addr < MODULES_VADDR; addr += PMD_SIZE)
-		pmd_clear(pmd_off_k(addr));
-
 #ifdef CONFIG_XIP_KERNEL
+	for ( ; addr < MODULES_VADDR; addr += PMD_SIZE)
+		pmd_clear(pmd_off_k(addr));
 	/* The XIP kernel is mapped in the module area -- skip over it */
 	addr = ((unsigned long)_etext + PMD_SIZE - 1) & PMD_MASK;
 #endif
diff --git a/arch/arm/mm/pgd.c b/arch/arm/mm/pgd.c
index 3fbcb5a..ce23923 100644
--- a/arch/arm/mm/pgd.c
+++ b/arch/arm/mm/pgd.c
@@ -57,11 +57,11 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	clean_dcache_area(new_pgd, TTBR0_PTRS_PER_PGD * sizeof(pgd_t));
 
 #ifdef CONFIG_ARM_LPAE
+#if defined(CONFIG_HIGHMEM) || !defined(CONFIG_MODULES_USE_VMALLOC)
 	/*
 	 * Allocate PMD table for modules and pkmap mappings.
 	 */
-	new_pud = pud_alloc(mm, new_pgd + pgd_index(MODULES_VADDR),
-			    MODULES_VADDR);
+	new_pud = pud_alloc(mm, new_pgd + pgd_index(PKMAP_BASE), PKMAP_BASE);
 	if (!new_pud)
 		goto no_pud;
 
@@ -69,6 +69,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	if (!new_pmd)
 		goto no_pmd;
 #endif
+#endif
 
 	if (!vectors_high()) {
 		/*

