Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbaHFTgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:36:32 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36577 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105AbaHFTfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:35:44 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Liu hua <sdu.liu@huawei.com>,
        Mark Salter <msalter@redhat.com>, Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh@kernel.org>,
        Doug Anderson <dianders@google.com>, Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 7/7] ARM: mm: allow text and rodata sections to be read-only
Date: Wed,  6 Aug 2014 12:32:44 -0700
Message-Id: <1407353564-21478-8-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407353564-21478-1-git-send-email-keescook@chromium.org>
References: <1407353564-21478-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces CONFIG_DEBUG_RODATA, making kernel text and rodata
read-only. Additionally, this splits rodata from text so that rodata can
also be NX, which may lead to wasted memory when aligning to SECTION_SIZE.
The read-only areas are made writable during ftrace updates.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/cacheflush.h | 10 +++++++++
 arch/arm/kernel/ftrace.c          | 19 ++++++++++++++++
 arch/arm/kernel/vmlinux.lds.S     |  3 +++
 arch/arm/mm/Kconfig               | 12 ++++++++++
 arch/arm/mm/init.c                | 46 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 90 insertions(+)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index fd43f7f55b70..0cdf1e31df86 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -487,6 +487,16 @@ int set_memory_rw(unsigned long addr, int numpages);
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
 void flush_uprobe_xol_access(struct page *page, unsigned long uaddr,
 			     void *kaddr, unsigned long len);
+
 #endif
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index af9a8a927a4e..b8c75e45a950 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -15,6 +15,7 @@
 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
+#include <linux/stop_machine.h>
 
 #include <asm/cacheflush.h>
 #include <asm/opcodes.h>
@@ -35,6 +36,22 @@
 
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
@@ -73,6 +90,8 @@ int ftrace_arch_code_modify_prepare(void)
 int ftrace_arch_code_modify_post_process(void)
 {
 	set_all_modules_text_ro();
+	/* Make sure any TLB misses during machine stop are cleared. */
+	flush_tlb_all();
 	return 0;
 }
 
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
index 0ea121dbf940..3a98cf340344 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -1016,3 +1016,15 @@ config ARM_KERNMEM_PERMS
 	  padded to section-size (1MiB) boundaries (because their permissions
 	  are different and splitting the 1M pages into 4K ones causes TLB
 	  performance problems), wasting memory.
+
+config DEBUG_RODATA
+	bool "Make kernel text and rodata read-only"
+	depends on ARM_KERNMEM_PERMS
+	default y
+	help
+	  If this is set, kernel text and rodata will be made read-only. This
+	  is to help catch accidental or malicious attempts to change the
+	  kernel's executable code. Additionally splits rodata from kernel
+	  text so it can be made explicitly non-executable. This creates
+	  another section-size padded region, so it can waste more memory
+	  space while gaining the read-only protections.
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index ccf392ef40d4..1a0248a9cfdb 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -626,6 +626,7 @@ struct section_perm {
 	unsigned long end;
 	pmdval_t mask;
 	pmdval_t prot;
+	pmdval_t clear;
 };
 
 struct section_perm nx_perms[] = {
@@ -643,8 +644,35 @@ struct section_perm nx_perms[] = {
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
 };
 
+#ifdef CONFIG_DEBUG_RODATA
+struct section_perm ro_perms[] = {
+	/* Make kernel code and rodata RX (set RO). */
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
+};
+#endif
+
 /*
  * Updates section permissions only for the current mm (sections are
  * copied into each mm). During startup, this is the init_mm.
@@ -713,6 +741,24 @@ static inline void fix_kernmem_perms(void)
 {
 	set_section_perms(nx_perms, prot);
 }
+
+#ifdef CONFIG_DEBUG_RODATA
+void mark_rodata_ro(void)
+{
+	set_section_perms(ro_perms, prot);
+}
+
+void set_kernel_text_rw(void)
+{
+	set_section_perms(ro_perms, clear);
+}
+
+void set_kernel_text_ro(void)
+{
+	set_section_perms(ro_perms, prot);
+}
+#endif /* CONFIG_DEBUG_RODATA */
+
 #else
 static inline void fix_kernmem_perms(void) { }
 #endif /* CONFIG_ARM_KERNMEM_PERMS */
-- 
1.9.1

