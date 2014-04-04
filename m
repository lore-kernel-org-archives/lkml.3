Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaDDCQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 22:16:52 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56947 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaDDCQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 22:16:33 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, Laura Abbott <lauraa@codeaurora.org>,
        Alexander Holler <holler@ahsoftware.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/2] ARM: mm: make text and rodata read-only
Date: Thu,  3 Apr 2014 19:15:19 -0700
Message-Id: <1396577719-14786-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396577719-14786-1-git-send-email-keescook@chromium.org>
References: <1396577719-14786-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces CONFIG_DEBUG_RODATA, making kernel text and rodata
read-only. It splits rodata from text so that rodata can also be NX.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/cacheflush.h |    9 ++++
 arch/arm/kernel/ftrace.c          |   17 +++++++
 arch/arm/kernel/vmlinux.lds.S     |    3 ++
 arch/arm/mm/Kconfig               |   11 +++++
 arch/arm/mm/init.c                |   97 +++++++++++++++++++++++++++++--------
 5 files changed, 117 insertions(+), 20 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 8b8b61685a34..b6fea0a1a88b 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -487,4 +487,13 @@ int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_x(unsigned long addr, int numpages);
 int set_memory_nx(unsigned long addr, int numpages);
 
+#ifdef CONFIG_DEBUG_RODATA
+void mark_rodata_ro(void);
+void set_kernel_text_rw(void);
+void set_kernel_text_ro(void);
+#else
+static inline void set_kernel_text_rw(void) { }
+static inline void set_kernel_text_ro(void) { }
+#endif
+
 #endif
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 34e56647dcee..4ae343c1e2a3 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -14,6 +14,7 @@
 
 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
+#include <linux/stop_machine.h>
 
 #include <asm/cacheflush.h>
 #include <asm/opcodes.h>
@@ -34,6 +35,22 @@
 
 #define	OLD_NOP		0xe1a00000	/* mov r0, r0 */
 
+static int __ftrace_modify_code(void *data)
+{
+	int *command = data;
+
+	set_kernel_text_rw();
+	ftrace_modify_all_code(*command);
+	set_kernel_text_ro();
+
+	return 0;
+}
+
+void arch_ftrace_update_code(int command)
+{
+	stop_machine(__ftrace_modify_code, &command, NULL);
+}
+
 static unsigned long ftrace_nop_replace(struct dyn_ftrace *rec)
 {
 	return rec->arch.old_mcount ? OLD_NOP : NOP;
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 08fa667ef2f1..ec79e7268e09 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -120,6 +120,9 @@ SECTIONS
 			ARM_CPU_KEEP(PROC_INFO)
 	}
 
+#ifdef CONFIG_DEBUG_RODATA
+	. = ALIGN(1<<SECTION_SHIFT);
+#endif
 	RO_DATA(PAGE_SIZE)
 
 	. = ALIGN(4);
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 8848d7b73e66..3c7adea7e2f6 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -967,3 +967,14 @@ config ARM_KERNMEM_PERMS
 	  padded to section-size (1MiB) boundaries (because their permissions
 	  are different and splitting the 1M pages into 4K ones causes TLB
 	  performance problems), wasting memory.
+
+config DEBUG_RODATA
+	bool "Make kernel text and rodata read-only"
+	depends on ARM_KERNMEM_PERMS && KEXEC=n && KPROBES=n
+	default y
+	help
+	  If this is set, kernel text and rodata will be made read-only.
+	  This additionally splits rodata from kernel text so it can be made
+	  non-executable. This creates another section-size padded region,
+	  so it can waste more memory space while gaining a pure read-only
+	  rodata region.
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 8539eb2a01ad..3baac4ad165f 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -632,9 +632,10 @@ struct section_perm {
 	unsigned long end;
 	pmdval_t mask;
 	pmdval_t prot;
+	pmdval_t clear;
 };
 
-struct section_perm section_perms[] = {
+struct section_perm nx_perms[] = {
 	/* Make pages tables, etc before _stext RW (set NX). */
 	{
 		.start	= PAGE_OFFSET,
@@ -649,12 +650,46 @@ struct section_perm section_perms[] = {
 		.mask	= ~PMD_SECT_XN,
 		.prot	= PMD_SECT_XN,
 	},
+#ifdef CONFIG_DEBUG_RODATA
+	/* Make rodata NX (set RO in ro_perms below). */
+	{
+		.start  = (unsigned long)__start_rodata,
+		.end    = (unsigned long)__init_begin,
+		.mask   = ~PMD_SECT_XN,
+		.prot   = PMD_SECT_XN,
+	},
+#endif
+};
+
+#ifdef CONFIG_DEBUG_RODATA
+struct section_perm ro_perms[] = {
+	/*
+	 * Make kernel code and rodata RX (set RO).
+	 * This entry must be first for set_kernel_text_rw() to find it.
+	 */
+	{
+		.start  = (unsigned long)_stext,
+		.end    = (unsigned long)__init_begin,
+#ifdef CONFIG_ARM_LPAE
+		.mask   = ~PMD_SECT_RDONLY,
+		.prot   = PMD_SECT_RDONLY,
+#else
+		.mask   = ~(PMD_SECT_APX | PMD_SECT_AP_WRITE),
+		.prot   = PMD_SECT_APX | PMD_SECT_AP_WRITE,
+		.clear  = PMD_SECT_AP_WRITE,
+#endif
+	},
 };
+#endif
 
 static inline void section_update(unsigned long addr, pmdval_t mask,
 				  pmdval_t prot)
 {
-	pmd_t *pmd = pmd_off_k(addr);
+	struct mm_struct *mm;
+	pmd_t *pmd;
+
+	mm = current->active_mm;
+	pmd = pmd_offset(pud_offset(pgd_offset(mm, addr), addr), addr);
 
 #ifdef CONFIG_ARM_LPAE
 	pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
@@ -681,30 +716,52 @@ static inline bool arch_has_strict_perms(void)
 	return true;
 }
 
+#define set_section_perms(perms, field)	{				\
+	size_t i;							\
+	unsigned long addr;						\
+									\
+	if (!arch_has_strict_perms())					\
+		return;							\
+									\
+	for (i = 0; i < ARRAY_SIZE(perms); i++) {			\
+		if (!IS_ALIGNED(perms[i].start, SECTION_SIZE) ||	\
+		    !IS_ALIGNED(perms[i].end, SECTION_SIZE)) {		\
+			pr_err("BUG: section %lx-%lx not aligned to %lx\n", \
+				perms[i].start, perms[i].end,		\
+				SECTION_SIZE);				\
+			continue;					\
+		}							\
+									\
+		for (addr = perms[i].start;				\
+		     addr < perms[i].end;				\
+		     addr += SECTION_SIZE)				\
+			section_update(addr, perms[i].mask,		\
+				       perms[i].field);			\
+	}								\
+}
+
 static inline void fix_kernmem_perms(void)
 {
-	unsigned long addr;
-	unsigned int i;
+	set_section_perms(nx_perms, prot);
+}
 
-	if (!arch_has_strict_perms())
-		return;
+#ifdef CONFIG_DEBUG_RODATA
+void mark_rodata_ro(void)
+{
+	set_section_perms(ro_perms, prot);
+}
 
-	for (i = 0; i < ARRAY_SIZE(section_perms); i++) {
-		if (!IS_ALIGNED(section_perms[i].start, SECTION_SIZE) ||
-		    !IS_ALIGNED(section_perms[i].end, SECTION_SIZE)) {
-			pr_err("BUG: section %lx-%lx not aligned to %lx\n",
-				section_perms[i].start, section_perms[i].end,
-				SECTION_SIZE);
-			continue;
-		}
+void set_kernel_text_rw(void)
+{
+	set_section_perms(ro_perms, clear);
+}
 
-		for (addr = section_perms[i].start;
-		     addr < section_perms[i].end;
-		     addr += SECTION_SIZE)
-			section_update(addr, section_perms[i].mask,
-				       section_perms[i].prot);
-	}
+void set_kernel_text_ro(void)
+{
+	set_section_perms(ro_perms, prot);
 }
+#endif /* CONFIG_DEBUG_RODATA */
+
 #else
 static inline void fix_kernmem_perms(void) { }
 #endif /* CONFIG_ARM_KERNMEM_PERMS */
-- 
1.7.9.5

