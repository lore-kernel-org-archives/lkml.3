Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330Ab3HGUlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:41:10 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60714 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab3HGUlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:41:04 -0400
Message-ID: <201308072041.r77Kf3qg016130@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 7 Aug 2013 15:33:32 -0400
Subject: [PATCH] tile: implement gettimeofday() via vDSO
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change creates the framework for vDSO calls, makes the existing
rt_sigreturn() mechanism use it, and adds a fast gettimeofday().
Now that we need to expose the vDSO address to userspace, we add
AT_SYSINFO_EHDR to the set of aux entries provided to userspace.
(You can disable any extra vDSO support by booting with vdso=0,
but the rt_sigreturn vDSO page will still be provided.)

Note that glibc has supported the tile vDSO since release 2.17.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig                     |   3 +
 arch/tile/include/asm/elf.h           |   5 +
 arch/tile/include/asm/mmu.h           |   1 +
 arch/tile/include/asm/page.h          |   8 +-
 arch/tile/include/asm/processor.h     |   6 +-
 arch/tile/include/asm/sections.h      |   4 +
 arch/tile/include/asm/vdso.h          |  49 ++++++++
 arch/tile/include/uapi/asm/auxvec.h   |   3 +-
 arch/tile/kernel/Makefile             |   4 +-
 arch/tile/kernel/compat_signal.c      |   3 +-
 arch/tile/kernel/entry.S              |  16 ---
 arch/tile/kernel/signal.c             |   3 +-
 arch/tile/kernel/stack.c              |   5 +-
 arch/tile/kernel/time.c               |  31 +++++
 arch/tile/kernel/vdso.c               | 212 ++++++++++++++++++++++++++++++++++
 arch/tile/kernel/vdso/Makefile        | 118 +++++++++++++++++++
 arch/tile/kernel/vdso/vdso.S          |  28 +++++
 arch/tile/kernel/vdso/vdso.lds.S      |  87 ++++++++++++++
 arch/tile/kernel/vdso/vdso32.S        |  28 +++++
 arch/tile/kernel/vdso/vgettimeofday.c | 107 +++++++++++++++++
 arch/tile/kernel/vdso/vrt_sigreturn.S |  30 +++++
 arch/tile/mm/elf.c                    |  37 +-----
 22 files changed, 727 insertions(+), 61 deletions(-)
 create mode 100644 arch/tile/include/asm/vdso.h
 create mode 100644 arch/tile/kernel/vdso.c
 create mode 100644 arch/tile/kernel/vdso/Makefile
 create mode 100644 arch/tile/kernel/vdso/vdso.S
 create mode 100644 arch/tile/kernel/vdso/vdso.lds.S
 create mode 100644 arch/tile/kernel/vdso/vdso32.S
 create mode 100644 arch/tile/kernel/vdso/vgettimeofday.c
 create mode 100644 arch/tile/kernel/vdso/vrt_sigreturn.S

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 1126b9d..7b87318 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -64,6 +64,9 @@ config HUGETLB_SUPER_PAGES
 	depends on HUGETLB_PAGE && TILEGX
 	def_bool y
 
+config GENERIC_TIME_VSYSCALL
+	def_bool y
+
 # FIXME: tilegx can implement a more efficient rwsem.
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
index ff8a934..31d854f 100644
--- a/arch/tile/include/asm/elf.h
+++ b/arch/tile/include/asm/elf.h
@@ -132,6 +132,11 @@ extern int dump_task_regs(struct task_struct *, elf_gregset_t *);
 struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 				       int executable_stack);
+#define ARCH_DLINFO \
+do { \
+	NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_BASE); \
+} while (0)
+
 #ifdef CONFIG_COMPAT
 
 #define COMPAT_ELF_PLATFORM "tilegx-m32"
diff --git a/arch/tile/include/asm/mmu.h b/arch/tile/include/asm/mmu.h
index e2c7890..0cab118 100644
--- a/arch/tile/include/asm/mmu.h
+++ b/arch/tile/include/asm/mmu.h
@@ -22,6 +22,7 @@ struct mm_context {
 	 * semaphore but atomically, but it is conservatively set.
 	 */
 	unsigned long priority_cached;
+	unsigned long vdso_base;
 };
 
 typedef struct mm_context mm_context_t;
diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
index dd033a4..b4f96c0 100644
--- a/arch/tile/include/asm/page.h
+++ b/arch/tile/include/asm/page.h
@@ -39,6 +39,12 @@
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 
 /*
+ * We do define AT_SYSINFO_EHDR to support vDSO,
+ * but don't use the gate mechanism.
+ */
+#define __HAVE_ARCH_GATE_AREA		1
+
+/*
  * If the Kconfig doesn't specify, set a maximum zone order that
  * is enough so that we can create huge pages from small pages given
  * the respective sizes of the two page types.  See <linux/mmzone.h>.
@@ -246,7 +252,7 @@ static inline __attribute_const__ int get_order(unsigned long size)
 
 #endif /* __tilegx__ */
 
-#ifndef __ASSEMBLY__
+#if !defined(__ASSEMBLY__) && !defined(VDSO_BUILD)
 
 #ifdef CONFIG_HIGHMEM
 
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index fed1c04..461322b 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -180,10 +180,10 @@ struct thread_struct {
 #define TASK_SIZE		TASK_SIZE_MAX
 #endif
 
-/* We provide a minimal "vdso" a la x86; just the sigreturn code for now. */
-#define VDSO_BASE		(TASK_SIZE - PAGE_SIZE)
+#define VDSO_BASE	((unsigned long)current->active_mm->context.vdso_base)
+#define VDSO_SYM(x)	(VDSO_BASE + (unsigned long)(x))
 
-#define STACK_TOP		VDSO_BASE
+#define STACK_TOP		TASK_SIZE
 
 /* STACK_TOP_MAX is used temporarily in execve and should not check COMPAT. */
 #define STACK_TOP_MAX		TASK_SIZE_MAX
diff --git a/arch/tile/include/asm/sections.h b/arch/tile/include/asm/sections.h
index cc95276..5d5d3b7 100644
--- a/arch/tile/include/asm/sections.h
+++ b/arch/tile/include/asm/sections.h
@@ -25,6 +25,10 @@ extern char _sinitdata[], _einitdata[];
 /* Write-once data is writable only till the end of initialization. */
 extern char __w1data_begin[], __w1data_end[];
 
+extern char vdso_start[], vdso_end[];
+#ifdef CONFIG_COMPAT
+extern char vdso32_start[], vdso32_end[];
+#endif
 
 /* Not exactly sections, but PC comparison points in the code. */
 extern char __rt_sigreturn[], __rt_sigreturn_end[];
diff --git a/arch/tile/include/asm/vdso.h b/arch/tile/include/asm/vdso.h
new file mode 100644
index 0000000..9f6a78d
--- /dev/null
+++ b/arch/tile/include/asm/vdso.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef __TILE_VDSO_H__
+#define __TILE_VDSO_H__
+
+#include <linux/types.h>
+
+/*
+ * Note about the vdso_data structure:
+ *
+ * NEVER USE THEM IN USERSPACE CODE DIRECTLY. The layout of the
+ * structure is supposed to be known only to the function in the vdso
+ * itself and may change without notice.
+ */
+
+struct vdso_data {
+	__u64 tz_update_count;  /* Timezone atomicity ctr             */
+	__u64 tb_update_count;  /* Timebase atomicity ctr             */
+	__u64 xtime_tod_stamp;  /* TOD clock for xtime                */
+	__u64 xtime_clock_sec;  /* Kernel time second                 */
+	__u64 xtime_clock_nsec; /* Kernel time nanosecond             */
+	__u64 wtom_clock_sec;   /* Wall to monotonic clock second     */
+	__u64 wtom_clock_nsec;  /* Wall to monotonic clock nanosecond */
+	__u32 mult;             /* Cycle to nanosecond multiplier     */
+	__u32 shift;            /* Cycle to nanosecond divisor (power of two) */
+	__u32 tz_minuteswest;   /* Minutes west of Greenwich          */
+	__u32 tz_dsttime;       /* Type of dst correction             */
+};
+
+extern struct vdso_data *vdso_data;
+
+/* __vdso_rt_sigreturn is defined with the addresses in the vdso page. */
+extern void __vdso_rt_sigreturn(void);
+
+extern int setup_vdso_pages(void);
+
+#endif /* __TILE_VDSO_H__ */
diff --git a/arch/tile/include/uapi/asm/auxvec.h b/arch/tile/include/uapi/asm/auxvec.h
index 1d393ed..c93e927 100644
--- a/arch/tile/include/uapi/asm/auxvec.h
+++ b/arch/tile/include/uapi/asm/auxvec.h
@@ -15,6 +15,7 @@
 #ifndef _ASM_TILE_AUXVEC_H
 #define _ASM_TILE_AUXVEC_H
 
-/* No extensions to auxvec */
+/* The vDSO location. */
+#define AT_SYSINFO_EHDR         33
 
 #endif /* _ASM_TILE_AUXVEC_H */
diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
index 6846c4e..5157d1c 100644
--- a/arch/tile/kernel/Makefile
+++ b/arch/tile/kernel/Makefile
@@ -6,7 +6,7 @@ extra-y := vmlinux.lds head_$(BITS).o
 obj-y := backtrace.o entry.o irq.o messaging.o \
 	pci-dma.o proc.o process.o ptrace.o reboot.o \
 	setup.o signal.o single_step.o stack.o sys.o \
-	sysfs.o time.o traps.o unaligned.o \
+	sysfs.o time.o traps.o unaligned.o vdso.o \
 	intvec_$(BITS).o regs_$(BITS).o tile-desc_$(BITS).o
 
 obj-$(CONFIG_HARDWALL)		+= hardwall.o
@@ -21,3 +21,5 @@ else
 obj-$(CONFIG_PCI)		+= pci.o
 endif
 obj-$(CONFIG_TILE_USB)		+= usb.o
+
+obj-y				+= vdso/
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index d0a052e..85e00b2 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -32,6 +32,7 @@
 #include <asm/ucontext.h>
 #include <asm/sigframe.h>
 #include <asm/syscalls.h>
+#include <asm/vdso.h>
 #include <arch/interrupts.h>
 
 struct compat_ucontext {
@@ -227,7 +228,7 @@ int compat_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (err)
 		goto give_sigsegv;
 
-	restorer = VDSO_BASE;
+	restorer = VDSO_SYM(&__vdso_rt_sigreturn);
 	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = ptr_to_compat_reg(ka->sa.sa_restorer);
 
diff --git a/arch/tile/kernel/entry.S b/arch/tile/kernel/entry.S
index f116cb0..3d91759 100644
--- a/arch/tile/kernel/entry.S
+++ b/arch/tile/kernel/entry.S
@@ -27,22 +27,6 @@ STD_ENTRY(current_text_addr)
 	{ move r0, lr; jrp lr }
 	STD_ENDPROC(current_text_addr)
 
-/*
- * We don't run this function directly, but instead copy it to a page
- * we map into every user process.  See vdso_setup().
- *
- * Note that libc has a copy of this function that it uses to compare
- * against the PC when a stack backtrace ends, so if this code is
- * changed, the libc implementation(s) should also be updated.
- */
-	.pushsection .data
-ENTRY(__rt_sigreturn)
-	moveli TREG_SYSCALL_NR_NAME,__NR_rt_sigreturn
-	swint1
-	ENDPROC(__rt_sigreturn)
-	ENTRY(__rt_sigreturn_end)
-	.popsection
-
 STD_ENTRY(dump_stack)
 	{ move r2, lr; lnk r1 }
 	{ move r4, r52; addli r1, r1, dump_stack - . }
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 9531845b..2d1dbf3 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -33,6 +33,7 @@
 #include <asm/ucontext.h>
 #include <asm/sigframe.h>
 #include <asm/syscalls.h>
+#include <asm/vdso.h>
 #include <arch/interrupts.h>
 
 #define DEBUG_SIG 0
@@ -190,7 +191,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (err)
 		goto give_sigsegv;
 
-	restorer = VDSO_BASE;
+	restorer = VDSO_SYM(&__vdso_rt_sigreturn);
 	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = (unsigned long) ka->sa.sa_restorer;
 
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index 176ffe4..a9db923 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -29,6 +29,7 @@
 #include <asm/switch_to.h>
 #include <asm/sigframe.h>
 #include <asm/stack.h>
+#include <asm/vdso.h>
 #include <arch/abi.h>
 #include <arch/interrupts.h>
 
@@ -119,7 +120,7 @@ static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
 /* Is the pc pointing to a sigreturn trampoline? */
 static int is_sigreturn(unsigned long pc)
 {
-	return (pc == VDSO_BASE);
+	return current->mm && (pc == VDSO_SYM(&__vdso_rt_sigreturn));
 }
 
 /* Return a pt_regs pointer for a valid signal handler frame */
@@ -128,7 +129,7 @@ static struct pt_regs *valid_sigframe(struct KBacktraceIterator* kbt,
 {
 	BacktraceIterator *b = &kbt->it;
 
-	if (b->pc == VDSO_BASE && b->sp < PAGE_OFFSET &&
+	if (is_sigreturn(b->pc) && b->sp < PAGE_OFFSET &&
 	    b->sp % sizeof(long) == 0) {
 		int retval;
 		pagefault_disable();
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 5ac397e..cf3ef46 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <asm/irq_regs.h>
 #include <asm/traps.h>
+#include <asm/vdso.h>
 #include <hv/hypervisor.h>
 #include <arch/interrupts.h>
 #include <arch/spr_def.h>
@@ -110,6 +111,36 @@ void __init time_init(void)
 	setup_tile_timer();
 }
 
+void update_vsyscall_tz(void)
+{
+	/* Userspace gettimeofday will spin while this value is odd. */
+	++vdso_data->tz_update_count;
+	smp_wmb();
+	vdso_data->tz_minuteswest = sys_tz.tz_minuteswest;
+	vdso_data->tz_dsttime = sys_tz.tz_dsttime;
+	smp_wmb();
+	++vdso_data->tz_update_count;
+}
+
+void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
+		     struct clocksource *clock, u32 mult)
+{
+	if (clock != &cycle_counter_cs)
+		return;
+
+	/* Userspace gettimeofday will spin while this value is odd. */
+	++vdso_data->tb_update_count;
+	smp_wmb();
+	vdso_data->xtime_tod_stamp = clock->cycle_last;
+	vdso_data->xtime_clock_sec = wall_time->tv_sec;
+	vdso_data->xtime_clock_nsec = wall_time->tv_nsec;
+	vdso_data->wtom_clock_sec = wtm->tv_sec;
+	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
+	vdso_data->mult = clock->mult;
+	vdso_data->shift = clock->shift;
+	smp_wmb();
+	++vdso_data->tb_update_count;
+}
 
 /*
  * Define the tile timer clock event device.  The timer is driven by
diff --git a/arch/tile/kernel/vdso.c b/arch/tile/kernel/vdso.c
new file mode 100644
index 0000000..1533af2
--- /dev/null
+++ b/arch/tile/kernel/vdso.c
@@ -0,0 +1,212 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/binfmts.h>
+#include <linux/compat.h>
+#include <linux/elf.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+
+#include <asm/vdso.h>
+#include <asm/mman.h>
+#include <asm/sections.h>
+
+#include <arch/sim.h>
+
+/* The alignment of the vDSO. */
+#define VDSO_ALIGNMENT  PAGE_SIZE
+
+
+static unsigned int vdso_pages;
+static struct page **vdso_pagelist;
+
+#ifdef CONFIG_COMPAT
+static unsigned int vdso32_pages;
+static struct page **vdso32_pagelist;
+#endif
+static int vdso_ready;
+
+/*
+ * The vdso data page.
+ */
+static union {
+	struct vdso_data	data;
+	u8			page[PAGE_SIZE];
+} vdso_data_store __page_aligned_data;
+
+struct vdso_data *vdso_data = &vdso_data_store.data;
+
+static unsigned int __read_mostly vdso_enabled = 1;
+
+static struct page **vdso_setup(void *vdso_kbase, unsigned int pages)
+{
+	int i;
+	struct page **pagelist;
+
+	pagelist = kzalloc(sizeof(struct page *) * (pages + 1), GFP_KERNEL);
+	BUG_ON(pagelist == NULL);
+	for (i = 0; i < pages - 1; i++) {
+		struct page *pg = virt_to_page(vdso_kbase + i*PAGE_SIZE);
+		ClearPageReserved(pg);
+		pagelist[i] = pg;
+	}
+	pagelist[pages - 1] = virt_to_page(vdso_data);
+	pagelist[pages] = NULL;
+
+	return pagelist;
+}
+
+static int __init vdso_init(void)
+{
+	int data_pages = sizeof(vdso_data_store) >> PAGE_SHIFT;
+
+	/*
+	 * We can disable vDSO support generally, but we need to retain
+	 * one page to support the two-bundle (16-byte) rt_sigreturn path.
+	 */
+	if (!vdso_enabled) {
+		size_t offset = (unsigned long)&__vdso_rt_sigreturn;
+		static struct page *sigret_page;
+		sigret_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		BUG_ON(sigret_page == NULL);
+		vdso_pagelist = &sigret_page;
+		vdso_pages = 1;
+		BUG_ON(offset >= PAGE_SIZE);
+		memcpy(page_address(sigret_page) + offset,
+		       vdso_start + offset, 16);
+#ifdef CONFIG_COMPAT
+		vdso32_pages = vdso_pages;
+		vdso32_pagelist = vdso_pagelist;
+#endif
+		vdso_ready = 1;
+		return 0;
+	}
+
+	vdso_pages = (vdso_end - vdso_start) >> PAGE_SHIFT;
+	vdso_pages += data_pages;
+	vdso_pagelist = vdso_setup(vdso_start, vdso_pages);
+
+#ifdef CONFIG_COMPAT
+	vdso32_pages = (vdso32_end - vdso32_start) >> PAGE_SHIFT;
+	vdso32_pages += data_pages;
+	vdso32_pagelist = vdso_setup(vdso32_start, vdso32_pages);
+#endif
+
+	smp_wmb();
+	vdso_ready = 1;
+
+	return 0;
+}
+arch_initcall(vdso_init);
+
+const char *arch_vma_name(struct vm_area_struct *vma)
+{
+	if (vma->vm_mm && vma->vm_start == VDSO_BASE)
+		return "[vdso]";
+#ifndef __tilegx__
+	if (vma->vm_start == MEM_USER_INTRPT)
+		return "[intrpt]";
+#endif
+	return NULL;
+}
+
+struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
+{
+	return NULL;
+}
+
+int in_gate_area(struct mm_struct *mm, unsigned long address)
+{
+	return 0;
+}
+
+int in_gate_area_no_mm(unsigned long address)
+{
+	return 0;
+}
+
+int setup_vdso_pages(void)
+{
+	struct page **pagelist;
+	unsigned long pages;
+	struct mm_struct *mm = current->mm;
+	unsigned long vdso_base = 0;
+	int retval = 0;
+
+	if (!vdso_ready)
+		return 0;
+
+	mm->context.vdso_base = 0;
+
+	pagelist = vdso_pagelist;
+	pages = vdso_pages;
+#ifdef CONFIG_COMPAT
+	if (is_compat_task()) {
+		pagelist = vdso32_pagelist;
+		pages = vdso32_pages;
+	}
+#endif
+
+	/*
+	 * vDSO has a problem and was disabled, just don't "enable" it for the
+	 * process.
+	 */
+	if (pages == 0)
+		return 0;
+
+	vdso_base = get_unmapped_area(NULL, vdso_base,
+				      (pages << PAGE_SHIFT) +
+				      ((VDSO_ALIGNMENT - 1) & PAGE_MASK),
+				      0, 0);
+	if (IS_ERR_VALUE(vdso_base)) {
+		retval = vdso_base;
+		return retval;
+	}
+
+	/* Add required alignment. */
+	vdso_base = ALIGN(vdso_base, VDSO_ALIGNMENT);
+
+	/*
+	 * Put vDSO base into mm struct. We need to do this before calling
+	 * install_special_mapping or the perf counter mmap tracking code
+	 * will fail to recognise it as a vDSO (since arch_vma_name fails).
+	 */
+	mm->context.vdso_base = vdso_base;
+
+	/*
+	 * our vma flags don't have VM_WRITE so by default, the process isn't
+	 * allowed to write those pages.
+	 * gdb can break that with ptrace interface, and thus trigger COW on
+	 * those pages but it's then your responsibility to never do that on
+	 * the "data" page of the vDSO or you'll stop getting kernel updates
+	 * and your nice userland gettimeofday will be totally dead.
+	 * It's fine to use that for setting breakpoints in the vDSO code
+	 * pages though
+	 */
+	retval = install_special_mapping(mm, vdso_base,
+					 pages << PAGE_SHIFT,
+					 VM_READ|VM_EXEC |
+					 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC,
+					 pagelist);
+	if (retval)
+		mm->context.vdso_base = 0;
+
+	return retval;
+}
+
+static __init int vdso_func(char *s)
+{
+	return kstrtouint(s, 0, &vdso_enabled);
+}
+__setup("vdso=", vdso_func);
diff --git a/arch/tile/kernel/vdso/Makefile b/arch/tile/kernel/vdso/Makefile
new file mode 100644
index 0000000..e2b7a2f
--- /dev/null
+++ b/arch/tile/kernel/vdso/Makefile
@@ -0,0 +1,118 @@
+# Symbols present in the vdso
+vdso-syms = rt_sigreturn gettimeofday
+
+# Files to link into the vdso
+obj-vdso = $(patsubst %, v%.o, $(vdso-syms))
+
+# Build rules
+targets := $(obj-vdso) vdso.so vdso.so.dbg vdso.lds
+obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
+
+# vdso32 is only for tilegx -m32 compat task.
+VDSO32-$(CONFIG_COMPAT) := y
+
+obj-y += vdso.o
+obj-$(VDSO32-y) += vdso32.o
+extra-y += vdso.lds
+CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
+
+# vDSO code runs in userspace and -pg doesn't help with profiling anyway.
+CFLAGS_REMOVE_vdso.o = -pg
+CFLAGS_REMOVE_vdso32.o = -pg
+CFLAGS_REMOVE_vrt_sigreturn.o = -pg
+CFLAGS_REMOVE_vrt_sigreturn32.o = -pg
+CFLAGS_REMOVE_vgettimeofday.o = -pg
+CFLAGS_REMOVE_vgettimeofday32.o = -pg
+
+ifdef CONFIG_FEEDBACK_COLLECT
+# vDSO code runs in userspace, not collecting feedback data.
+CFLAGS_REMOVE_vdso.o = -ffeedback-generate
+CFLAGS_REMOVE_vdso32.o = -ffeedback-generate
+CFLAGS_REMOVE_vrt_sigreturn.o = -ffeedback-generate
+CFLAGS_REMOVE_vrt_sigreturn32.o = -ffeedback-generate
+CFLAGS_REMOVE_vgettimeofday.o = -ffeedback-generate
+CFLAGS_REMOVE_vgettimeofday32.o = -ffeedback-generate
+endif
+
+# Disable gcov profiling for VDSO code
+GCOV_PROFILE := n
+
+# Force dependency
+$(obj)/vdso.o: $(obj)/vdso.so
+
+# link rule for the .so file, .lds has to be first
+SYSCFLAGS_vdso.so.dbg = $(c_flags)
+$(obj)/vdso.so.dbg: $(src)/vdso.lds $(obj-vdso)
+	$(call if_changed,vdsold)
+
+
+# We also create a special relocatable object that should mirror the symbol
+# table and layout of the linked DSO.  With ld -R we can then refer to
+# these symbols in the kernel code rather than hand-coded addresses.
+extra-y += vdso-syms.o
+$(obj)/built-in.o: $(obj)/vdso-syms.o
+$(obj)/built-in.o: ld_flags += -R $(obj)/vdso-syms.o
+
+SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
+                            $(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
+SYSCFLAGS_vdso_syms.o = -r
+$(obj)/vdso-syms.o: $(src)/vdso.lds $(obj)/vrt_sigreturn.o FORCE
+	$(call if_changed,vdsold)
+
+
+# strip rule for the .so file
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+# actual build commands
+# The DSO images are built using a special linker script
+# Add -lgcc so tilepro gets static muldi3 and lshrdi3 definitions.
+# Make sure only to export the intended __vdso_xxx symbol offsets.
+quiet_cmd_vdsold = VDSOLD  $@
+      cmd_vdsold = $(CC) $(KCFLAGS) -nostdlib $(SYSCFLAGS_$(@F)) \
+                           -Wl,-T,$(filter-out FORCE,$^) -o $@.tmp -lgcc && \
+                   $(CROSS_COMPILE)objcopy \
+                           $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@
+
+# install commands for the unstripped file
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+
+vdso.so: $(obj)/vdso.so.dbg
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+vdso32.so: $(obj)/vdso32.so.dbg
+	$(call cmd,vdso_install)
+
+vdso_install: vdso.so
+vdso32_install: vdso32.so
+
+
+KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS))
+KBUILD_AFLAGS_32 += -m32 -s
+KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_32 += -m32 -fPIC -shared
+
+obj-vdso32 = $(patsubst %, v%32.o, $(vdso-syms))
+obj-vdso32 := $(addprefix $(obj)/, $(obj-vdso32))
+
+targets += $(obj-vdso32) vdso32.so vdso32.so.dbg
+
+$(obj-vdso32:%=%): KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
+$(obj-vdso32:%=%): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
+
+$(obj)/vgettimeofday32.o: $(obj)/vgettimeofday.c
+	$(call if_changed,cc_o_c)
+
+$(obj)/vrt_sigreturn32.o: $(obj)/vrt_sigreturn.S
+	$(call if_changed,as_o_S)
+
+# Force dependency
+$(obj)/vdso32.o: $(obj)/vdso32.so
+
+SYSCFLAGS_vdso32.so.dbg = -m32 -shared -s -Wl,-soname=linux-vdso32.so.1 \
+			    $(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
+$(obj)/vdso32.so.dbg: $(src)/vdso.lds $(obj-vdso32)
+	$(call if_changed,vdsold)
diff --git a/arch/tile/kernel/vdso/vdso.S b/arch/tile/kernel/vdso/vdso.S
new file mode 100644
index 0000000..3467adb
--- /dev/null
+++ b/arch/tile/kernel/vdso/vdso.S
@@ -0,0 +1,28 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <asm/page.h>
+
+	__PAGE_ALIGNED_DATA
+
+	.global vdso_start, vdso_end
+	.align PAGE_SIZE
+vdso_start:
+	.incbin "arch/tile/kernel/vdso/vdso.so"
+	.align PAGE_SIZE
+vdso_end:
+
+	.previous
diff --git a/arch/tile/kernel/vdso/vdso.lds.S b/arch/tile/kernel/vdso/vdso.lds.S
new file mode 100644
index 0000000..041cd6c
--- /dev/null
+++ b/arch/tile/kernel/vdso/vdso.lds.S
@@ -0,0 +1,87 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#define VDSO_VERSION_STRING	LINUX_2.6
+
+
+OUTPUT_ARCH(tile)
+
+/* The ELF entry point can be used to set the AT_SYSINFO value. */
+ENTRY(__vdso_rt_sigreturn);
+
+
+SECTIONS
+{
+	. = SIZEOF_HEADERS;
+
+	.hash		: { *(.hash) }			:text
+	.gnu.hash	: { *(.gnu.hash) }
+	.dynsym		: { *(.dynsym) }
+	.dynstr		: { *(.dynstr) }
+	.gnu.version	: { *(.gnu.version) }
+	.gnu.version_d	: { *(.gnu.version_d) }
+	.gnu.version_r	: { *(.gnu.version_r) }
+
+	.note		: { *(.note.*) }		:text	:note
+	.dynamic	: { *(.dynamic) }		:text	:dynamic
+
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+
+	.rodata	 : { *(.rodata .rodata.* .gnu.linkonce.r.*) }
+
+	/*
+	 * This linker script is used both with -r and with -shared.
+	 * For the layouts to match, we need to skip more than enough
+	 * space for the dynamic symbol table et al. If this amount
+	 * is insufficient, ld -shared will barf. Just increase it here.
+	 */
+	. = 0x1000;
+	.text		: { *(.text .text.*) }		:text
+
+	.data		: {
+		*(.got.plt) *(.got)
+		*(.data .data.* .gnu.linkonce.d.*)
+		*(.dynbss)
+		*(.bss .bss.* .gnu.linkonce.b.*)
+	}
+}
+
+
+/*
+ * We must supply the ELF program headers explicitly to get just one
+ * PT_LOAD segment, and set the flags explicitly to make segments read-only.
+ */
+PHDRS
+{
+	text		PT_LOAD		FLAGS(5) FILEHDR PHDRS;	/* PF_R|PF_X */
+	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
+	note		PT_NOTE		FLAGS(4);		/* PF_R */
+	eh_frame_hdr	PT_GNU_EH_FRAME;
+}
+
+
+/*
+ * This controls what userland symbols we export from the vDSO.
+ */
+VERSION
+{
+	VDSO_VERSION_STRING {
+	global:
+		__vdso_rt_sigreturn;
+		__vdso_gettimeofday;
+		gettimeofday;
+	local:*;
+	};
+}
diff --git a/arch/tile/kernel/vdso/vdso32.S b/arch/tile/kernel/vdso/vdso32.S
new file mode 100644
index 0000000..1d1ac32
--- /dev/null
+++ b/arch/tile/kernel/vdso/vdso32.S
@@ -0,0 +1,28 @@
+/*
+ * Copyright 2013 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <asm/page.h>
+
+	__PAGE_ALIGNED_DATA
+
+	.global vdso32_start, vdso32_end
+	.align PAGE_SIZE
+vdso32_start:
+	.incbin "arch/tile/kernel/vdso/vdso32.so"
+	.align PAGE_SIZE
+vdso32_end:
+
+	.previous
diff --git a/arch/tile/kernel/vdso/vgettimeofday.c b/arch/tile/kernel/vdso/vgettimeofday.c
new file mode 100644
index 0000000..51ec8e4
--- /dev/null
+++ b/arch/tile/kernel/vdso/vgettimeofday.c
@@ -0,0 +1,107 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#define VDSO_BUILD  /* avoid some shift warnings for -m32 in <asm/page.h> */
+#include <linux/time.h>
+#include <asm/timex.h>
+#include <asm/vdso.h>
+
+#if CHIP_HAS_SPLIT_CYCLE()
+static inline cycles_t get_cycles_inline(void)
+{
+	unsigned int high = __insn_mfspr(SPR_CYCLE_HIGH);
+	unsigned int low = __insn_mfspr(SPR_CYCLE_LOW);
+	unsigned int high2 = __insn_mfspr(SPR_CYCLE_HIGH);
+
+	while (unlikely(high != high2)) {
+		low = __insn_mfspr(SPR_CYCLE_LOW);
+		high = high2;
+		high2 = __insn_mfspr(SPR_CYCLE_HIGH);
+	}
+
+	return (((cycles_t)high) << 32) | low;
+}
+#define get_cycles get_cycles_inline
+#endif
+
+/*
+ * Find out the vDSO data page address in the process address space.
+ */
+inline unsigned long get_datapage(void)
+{
+	unsigned long ret;
+
+	/* vdso data page located in the 2nd vDSO page. */
+	asm volatile ("lnk %0" : "=r"(ret));
+	ret &= ~(PAGE_SIZE - 1);
+	ret += PAGE_SIZE;
+
+	return ret;
+}
+
+int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
+{
+	cycles_t cycles;
+	unsigned long count, sec, ns;
+	volatile struct vdso_data *vdso_data;
+
+	vdso_data = (struct vdso_data *)get_datapage();
+	/* The use of the timezone is obsolete, normally tz is NULL. */
+	if (unlikely(tz != NULL)) {
+		while (1) {
+			/* Spin until the update finish. */
+			count = vdso_data->tz_update_count;
+			if (count & 1)
+				continue;
+
+			tz->tz_minuteswest = vdso_data->tz_minuteswest;
+			tz->tz_dsttime = vdso_data->tz_dsttime;
+
+			/* Check whether updated, read again if so. */
+			if (count == vdso_data->tz_update_count)
+				break;
+		}
+	}
+
+	if (unlikely(tv == NULL))
+		return 0;
+
+	while (1) {
+		/* Spin until the update finish. */
+		count = vdso_data->tb_update_count;
+		if (count & 1)
+			continue;
+
+		cycles = (get_cycles() - vdso_data->xtime_tod_stamp);
+		ns = (cycles * vdso_data->mult) >> vdso_data->shift;
+		sec = vdso_data->xtime_clock_sec;
+		ns += vdso_data->xtime_clock_nsec;
+		if (ns >= NSEC_PER_SEC) {
+			ns -= NSEC_PER_SEC;
+			sec += 1;
+		}
+
+		/* Check whether updated, read again if so. */
+		if (count == vdso_data->tb_update_count)
+			break;
+	}
+
+	tv->tv_sec = sec;
+	tv->tv_usec = ns / 1000;
+
+	return 0;
+}
+
+int gettimeofday(struct timeval *tv, struct timezone *tz)
+	__attribute__((weak, alias("__vdso_gettimeofday")));
diff --git a/arch/tile/kernel/vdso/vrt_sigreturn.S b/arch/tile/kernel/vdso/vrt_sigreturn.S
new file mode 100644
index 0000000..6326caf
--- /dev/null
+++ b/arch/tile/kernel/vdso/vrt_sigreturn.S
@@ -0,0 +1,30 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/linkage.h>
+#include <arch/abi.h>
+#include <asm/unistd.h>
+
+/*
+ * Note that libc has a copy of this function that it uses to compare
+ * against the PC when a stack backtrace ends, so if this code is
+ * changed, the libc implementation(s) should also be updated.
+ */
+ENTRY(__vdso_rt_sigreturn)
+	moveli TREG_SYSCALL_NR_NAME, __NR_rt_sigreturn
+	swint1
+	/* We don't use ENDPROC to avoid tagging this symbol as FUNC,
+	 * which confuses the perf tool.
+	 */
+	END(__vdso_rt_sigreturn)
diff --git a/arch/tile/mm/elf.c b/arch/tile/mm/elf.c
index 1691b81..23f044e 100644
--- a/arch/tile/mm/elf.c
+++ b/arch/tile/mm/elf.c
@@ -21,6 +21,7 @@
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
+#include <asm/vdso.h>
 #include <arch/sim.h>
 
 /* Notify a running simulator, if any, that an exec just occurred. */
@@ -102,37 +103,10 @@ static void sim_notify_interp(unsigned long load_addr)
 }
 
 
-/* Kernel address of page used to map read-only kernel data into userspace. */
-static void *vdso_page;
-
-/* One-entry array used for install_special_mapping. */
-static struct page *vdso_pages[1];
-
-static int __init vdso_setup(void)
-{
-	vdso_page = (void *)get_zeroed_page(GFP_ATOMIC);
-	memcpy(vdso_page, __rt_sigreturn, __rt_sigreturn_end - __rt_sigreturn);
-	vdso_pages[0] = virt_to_page(vdso_page);
-	return 0;
-}
-device_initcall(vdso_setup);
-
-const char *arch_vma_name(struct vm_area_struct *vma)
-{
-	if (vma->vm_private_data == vdso_pages)
-		return "[vdso]";
-#ifndef __tilegx__
-	if (vma->vm_start == MEM_USER_INTRPT)
-		return "[intrpt]";
-#endif
-	return NULL;
-}
-
 int arch_setup_additional_pages(struct linux_binprm *bprm,
 				int executable_stack)
 {
 	struct mm_struct *mm = current->mm;
-	unsigned long vdso_base;
 	int retval = 0;
 
 	down_write(&mm->mmap_sem);
@@ -145,14 +119,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
 	if (!notify_exec(mm))
 		sim_notify_exec(bprm->filename);
 
-	/*
-	 * MAYWRITE to allow gdb to COW and set breakpoints
-	 */
-	vdso_base = VDSO_BASE;
-	retval = install_special_mapping(mm, vdso_base, PAGE_SIZE,
-					 VM_READ|VM_EXEC|
-					 VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-					 vdso_pages);
+	retval = setup_vdso_pages();
 
 #ifndef __tilegx__
 	/*
-- 
1.8.3.1

