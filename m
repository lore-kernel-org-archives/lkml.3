Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbaLIOVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:21:48 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52293 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaLIOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:21:46 -0500
Date: Tue, 9 Dec 2014 15:21:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/vdso tree changes for v3.19
Message-ID: <20141209142141.GA1346@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-vdso-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-vdso-for-linus

   # HEAD: 26893107aa717cd11010f0c278d02535defa1ac9 x86_64/vsyscall: Restore orig_ax after vsyscall seccomp

Various vDSO updates from Andy Lutomirski, mostly cleanups and 
reorganization to improve maintainability, but also some 
micro-optimizations and robustization changes.

 Thanks,

	Ingo

------------------>
Andrew Morton (1):
      x86: vdso: Fix build with older gcc

Andy Lutomirski (13):
      x86_64/vsyscall: Move all of the gate_area code to vsyscall_64.c
      x86_64/vdso: Move getcpu code from vsyscall_64.c to vdso/vma.c
      x86/vdso: Change the PER_CPU segment to use struct desc_struct
      x86/vdso: Make the PER_CPU segment start out accessed
      x86/vdso: Make the PER_CPU segment 32 bits
      x86_64/vdso: Remove jiffies from the vvar page
      x86_64/vdso: Clean up vgetcpu init and merge the vdso initcalls
      x86,vdso: Use LSL unconditionally for vgetcpu
      x86_64, vsyscall: Turn vsyscalls all the way off when vsyscall==none
      x86_64, vsyscall: Rewrite comment and clean up headers in vsyscall code
      x86_64,vsyscall: Make vsyscall emulation configurable
      x86_64: Add a comment explaining the TASK_SIZE_MAX guard page
      x86_64/vsyscall: Restore orig_ax after vsyscall seccomp


 arch/x86/Kconfig                 |  18 +++++
 arch/x86/include/asm/fixmap.h    |   2 +
 arch/x86/include/asm/page_64.h   |   4 +-
 arch/x86/include/asm/processor.h |   8 ++-
 arch/x86/include/asm/vgtod.h     |  19 +++++
 arch/x86/include/asm/vsyscall.h  |  33 ++-------
 arch/x86/include/asm/vvar.h      |   2 -
 arch/x86/kernel/Makefile         |   3 +-
 arch/x86/kernel/cpu/common.c     |  10 ---
 arch/x86/kernel/setup.c          |   2 -
 arch/x86/kernel/time.c           |   2 +-
 arch/x86/kernel/vsyscall_64.c    | 147 +++++++++++++++++----------------------
 arch/x86/mm/init_64.c            |  49 -------------
 arch/x86/vdso/vgetcpu.c          |   2 -
 arch/x86/vdso/vma.c              |  83 +++++++++++++++++-----
 arch/x86/xen/mmu.c               |   6 +-
 16 files changed, 190 insertions(+), 200 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f2327e88e07c..cd10436d7d1c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -984,6 +984,24 @@ config X86_ESPFIX64
 	def_bool y
 	depends on X86_16BIT && X86_64
 
+config X86_VSYSCALL_EMULATION
+       bool "Enable vsyscall emulation" if EXPERT
+       default y
+       depends on X86_64
+       ---help---
+	 This enables emulation of the legacy vsyscall page.  Disabling
+	 it is roughly equivalent to booting with vsyscall=none, except
+	 that it will also disable the helpful warning if a program
+	 tries to use a vsyscall.  With this option set to N, offending
+	 programs will just segfault, citing addresses of the form
+	 0xffffffffff600?00.
+
+	 This option is required by many programs built before 2013, and
+	 care should be used even with newer programs if set to N.
+
+	 Disabling this option saves about 7K of kernel size and
+	 possibly 4K of additional runtime pagetable memory.
+
 config TOSHIBA
 	tristate "Toshiba Laptop support"
 	depends on X86_32
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index ffb1733ac91f..d8d5bcb2a0b5 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -69,7 +69,9 @@ enum fixed_addresses {
 #ifdef CONFIG_X86_32
 	FIX_HOLE,
 #else
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
 	VSYSCALL_PAGE = (FIXADDR_TOP - VSYSCALL_ADDR) >> PAGE_SHIFT,
+#endif
 #ifdef CONFIG_PARAVIRT_CLOCK
 	PVCLOCK_FIXMAP_BEGIN,
 	PVCLOCK_FIXMAP_END = PVCLOCK_FIXMAP_BEGIN+PVCLOCK_VSYSCALL_NR_PAGES-1,
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index f408caf73430..b3bebf9e5746 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -39,6 +39,8 @@ void copy_page(void *to, void *from);
 
 #endif	/* !__ASSEMBLY__ */
 
-#define __HAVE_ARCH_GATE_AREA 1
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
+# define __HAVE_ARCH_GATE_AREA 1
+#endif
 
 #endif /* _ASM_X86_PAGE_64_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index eb71ec794732..82d93ea13c0c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -893,7 +893,13 @@ extern unsigned long thread_saved_pc(struct task_struct *tsk);
 
 #else
 /*
- * User space process size. 47bits minus one guard page.
+ * User space process size. 47bits minus one guard page.  The guard
+ * page is necessary on Intel CPUs: if a SYSCALL instruction is at
+ * the highest possible canonical userspace address, then that
+ * syscall will enter the kernel with a non-canonical return
+ * address, and SYSRET will explode dangerously.  We avoid this
+ * particular problem by preventing anything from being mapped
+ * at the maximum canonical address.
  */
 #define TASK_SIZE_MAX	((1UL << 47) - PAGE_SIZE)
 
diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 3c3366c2e37f..e7e9682a33e9 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -70,4 +70,23 @@ static inline void gtod_write_end(struct vsyscall_gtod_data *s)
 	++s->seq;
 }
 
+#ifdef CONFIG_X86_64
+
+#define VGETCPU_CPU_MASK 0xfff
+
+static inline unsigned int __getcpu(void)
+{
+	unsigned int p;
+
+	/*
+	 * Load per CPU data from GDT.  LSL is faster than RDTSCP and
+	 * works on all CPUs.
+	 */
+	asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
+
+	return p;
+}
+
+#endif /* CONFIG_X86_64 */
+
 #endif /* _ASM_X86_VGTOD_H */
diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index 2a46ca720afc..6ba66ee79710 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -4,15 +4,7 @@
 #include <linux/seqlock.h>
 #include <uapi/asm/vsyscall.h>
 
-#define VGETCPU_RDTSCP	1
-#define VGETCPU_LSL	2
-
-/* kernel space (writeable) */
-extern int vgetcpu_mode;
-extern struct timezone sys_tz;
-
-#include <asm/vvar.h>
-
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
 extern void map_vsyscall(void);
 
 /*
@@ -20,25 +12,12 @@ extern void map_vsyscall(void);
  * Returns true if handled.
  */
 extern bool emulate_vsyscall(struct pt_regs *regs, unsigned long address);
-
-#ifdef CONFIG_X86_64
-
-#define VGETCPU_CPU_MASK 0xfff
-
-static inline unsigned int __getcpu(void)
+#else
+static inline void map_vsyscall(void) {}
+static inline bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 {
-	unsigned int p;
-
-	if (VVAR(vgetcpu_mode) == VGETCPU_RDTSCP) {
-		/* Load per CPU data from RDTSCP */
-		native_read_tscp(&p);
-	} else {
-		/* Load per CPU data from GDT */
-		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
-	}
-
-	return p;
+	return false;
 }
-#endif /* CONFIG_X86_64 */
+#endif
 
 #endif /* _ASM_X86_VSYSCALL_H */
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 5d2b9ad2c6d2..3f32dfc2ab73 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -44,8 +44,6 @@ extern char __vvar_page;
 
 /* DECLARE_VVAR(offset, type, name) */
 
-DECLARE_VVAR(0, volatile unsigned long, jiffies)
-DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
 
 #undef DECLARE_VVAR
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8f1e77440b2b..5d4502c8b983 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -28,8 +28,7 @@ obj-$(CONFIG_X86_32)	+= i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= mcount_64.o
 obj-y			+= syscall_$(BITS).o vsyscall_gtod.o
-obj-$(CONFIG_X86_64)	+= vsyscall_64.o
-obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
+obj-$(CONFIG_X86_VSYSCALL_EMULATION)	+= vsyscall_64.o vsyscall_emu_64.o
 obj-$(CONFIG_X86_ESPFIX64)	+= espfix_64.o
 obj-$(CONFIG_SYSFS)	+= ksysfs.o
 obj-y			+= bootflag.o e820.o
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4b4f78c9ba19..175372b854be 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -956,14 +956,6 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 }
 
 #ifdef CONFIG_X86_64
-static void vgetcpu_set_mode(void)
-{
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
-		vgetcpu_mode = VGETCPU_RDTSCP;
-	else
-		vgetcpu_mode = VGETCPU_LSL;
-}
-
 #ifdef CONFIG_IA32_EMULATION
 /* May not be __init: called during resume */
 static void syscall32_cpu_init(void)
@@ -1006,8 +998,6 @@ void __init identify_boot_cpu(void)
 #ifdef CONFIG_X86_32
 	sysenter_setup();
 	enable_sep_cpu();
-#else
-	vgetcpu_set_mode();
 #endif
 	cpu_detect_tlb(&boot_cpu_data);
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 235cfd39e0d7..59a6f884fdad 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1190,9 +1190,7 @@ void __init setup_arch(char **cmdline_p)
 
 	tboot_probe();
 
-#ifdef CONFIG_X86_64
 	map_vsyscall();
-#endif
 
 	generic_apic_probe();
 
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 0fa29609b2c4..25adc0e16eaa 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -23,7 +23,7 @@
 #include <asm/time.h>
 
 #ifdef CONFIG_X86_64
-__visible DEFINE_VVAR(volatile unsigned long, jiffies) = INITIAL_JIFFIES;
+__visible volatile unsigned long jiffies __cacheline_aligned = INITIAL_JIFFIES;
 #endif
 
 unsigned long profile_pc(struct pt_regs *regs)
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 957779f4eb40..2dcc6ff6fdcc 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -1,59 +1,43 @@
 /*
+ * Copyright (c) 2012-2014 Andy Lutomirski <luto@amacapital.net>
+ *
+ * Based on the original implementation which is:
  *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
  *  Copyright 2003 Andi Kleen, SuSE Labs.
  *
- *  [ NOTE: this mechanism is now deprecated in favor of the vDSO. ]
+ *  Parts of the original code have been moved to arch/x86/vdso/vma.c
+ *
+ * This file implements vsyscall emulation.  vsyscalls are a legacy ABI:
+ * Userspace can request certain kernel services by calling fixed
+ * addresses.  This concept is problematic:
  *
- *  Thanks to hpa@transmeta.com for some useful hint.
- *  Special thanks to Ingo Molnar for his early experience with
- *  a different vsyscall implementation for Linux/IA32 and for the name.
+ * - It interferes with ASLR.
+ * - It's awkward to write code that lives in kernel addresses but is
+ *   callable by userspace at fixed addresses.
+ * - The whole concept is impossible for 32-bit compat userspace.
+ * - UML cannot easily virtualize a vsyscall.
  *
- *  vsyscall 1 is located at -10Mbyte, vsyscall 2 is located
- *  at virtual address -10Mbyte+1024bytes etc... There are at max 4
- *  vsyscalls. One vsyscall can reserve more than 1 slot to avoid
- *  jumping out of line if necessary. We cannot add more with this
- *  mechanism because older kernels won't return -ENOSYS.
+ * As of mid-2014, I believe that there is no new userspace code that
+ * will use a vsyscall if the vDSO is present.  I hope that there will
+ * soon be no new userspace code that will ever use a vsyscall.
  *
- *  Note: the concept clashes with user mode linux.  UML users should
- *  use the vDSO.
+ * The code in this file emulates vsyscalls when notified of a page
+ * fault to a vsyscall address.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/time.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/timer.h>
-#include <linux/seqlock.h>
-#include <linux/jiffies.h>
-#include <linux/sysctl.h>
-#include <linux/topology.h>
-#include <linux/timekeeper_internal.h>
-#include <linux/getcpu.h>
-#include <linux/cpu.h>
-#include <linux/smp.h>
-#include <linux/notifier.h>
 #include <linux/syscalls.h>
 #include <linux/ratelimit.h>
 
 #include <asm/vsyscall.h>
-#include <asm/pgtable.h>
-#include <asm/compat.h>
-#include <asm/page.h>
 #include <asm/unistd.h>
 #include <asm/fixmap.h>
-#include <asm/errno.h>
-#include <asm/io.h>
-#include <asm/segment.h>
-#include <asm/desc.h>
-#include <asm/topology.h>
 #include <asm/traps.h>
 
 #define CREATE_TRACE_POINTS
 #include "vsyscall_trace.h"
 
-DEFINE_VVAR(int, vgetcpu_mode);
-
 static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
 
 static int __init vsyscall_setup(char *str)
@@ -222,6 +206,7 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 				  "seccomp tried to change syscall nr or ip");
 		do_exit(SIGSYS);
 	}
+	regs->orig_ax = -1;
 	if (tmp)
 		goto do_ret;  /* skip requested */
 
@@ -284,46 +269,54 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 }
 
 /*
- * Assume __initcall executes before all user space. Hopefully kmod
- * doesn't violate that. We'll find out if it does.
+ * A pseudo VMA to allow ptrace access for the vsyscall page.  This only
+ * covers the 64bit vsyscall page now. 32bit has a real VMA now and does
+ * not need special handling anymore:
  */
-static void vsyscall_set_cpu(int cpu)
+static const char *gate_vma_name(struct vm_area_struct *vma)
 {
-	unsigned long d;
-	unsigned long node = 0;
-#ifdef CONFIG_NUMA
-	node = cpu_to_node(cpu);
-#endif
-	if (cpu_has(&cpu_data(cpu), X86_FEATURE_RDTSCP))
-		write_rdtscp_aux((node << 12) | cpu);
-
-	/*
-	 * Store cpu number in limit so that it can be loaded quickly
-	 * in user space in vgetcpu. (12 bits for the CPU and 8 bits for the node)
-	 */
-	d = 0x0f40000000000ULL;
-	d |= cpu;
-	d |= (node & 0xf) << 12;
-	d |= (node >> 4) << 48;
-
-	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
+	return "[vsyscall]";
 }
-
-static void cpu_vsyscall_init(void *arg)
+static struct vm_operations_struct gate_vma_ops = {
+	.name = gate_vma_name,
+};
+static struct vm_area_struct gate_vma = {
+	.vm_start	= VSYSCALL_ADDR,
+	.vm_end		= VSYSCALL_ADDR + PAGE_SIZE,
+	.vm_page_prot	= PAGE_READONLY_EXEC,
+	.vm_flags	= VM_READ | VM_EXEC,
+	.vm_ops		= &gate_vma_ops,
+};
+
+struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 {
-	/* preemption should be already off */
-	vsyscall_set_cpu(raw_smp_processor_id());
+#ifdef CONFIG_IA32_EMULATION
+	if (!mm || mm->context.ia32_compat)
+		return NULL;
+#endif
+	if (vsyscall_mode == NONE)
+		return NULL;
+	return &gate_vma;
 }
 
-static int
-cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
+int in_gate_area(struct mm_struct *mm, unsigned long addr)
 {
-	long cpu = (long)arg;
+	struct vm_area_struct *vma = get_gate_vma(mm);
+
+	if (!vma)
+		return 0;
 
-	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN)
-		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 1);
+	return (addr >= vma->vm_start) && (addr < vma->vm_end);
+}
 
-	return NOTIFY_DONE;
+/*
+ * Use this when you have no reliable mm, typically from interrupt
+ * context. It is less reliable than using a task's mm and may give
+ * false positives.
+ */
+int in_gate_area_no_mm(unsigned long addr)
+{
+	return vsyscall_mode != NONE && (addr & PAGE_MASK) == VSYSCALL_ADDR;
 }
 
 void __init map_vsyscall(void)
@@ -331,24 +324,12 @@ void __init map_vsyscall(void)
 	extern char __vsyscall_page;
 	unsigned long physaddr_vsyscall = __pa_symbol(&__vsyscall_page);
 
-	__set_fixmap(VSYSCALL_PAGE, physaddr_vsyscall,
-		     vsyscall_mode == NATIVE
-		     ? PAGE_KERNEL_VSYSCALL
-		     : PAGE_KERNEL_VVAR);
+	if (vsyscall_mode != NONE)
+		__set_fixmap(VSYSCALL_PAGE, physaddr_vsyscall,
+			     vsyscall_mode == NATIVE
+			     ? PAGE_KERNEL_VSYSCALL
+			     : PAGE_KERNEL_VVAR);
+
 	BUILD_BUG_ON((unsigned long)__fix_to_virt(VSYSCALL_PAGE) !=
 		     (unsigned long)VSYSCALL_ADDR);
 }
-
-static int __init vsyscall_init(void)
-{
-	cpu_notifier_register_begin();
-
-	on_each_cpu(cpu_vsyscall_init, NULL, 1);
-	/* notifier priority > KVM */
-	__hotcpu_notifier(cpu_vsyscall_notifier, 30);
-
-	cpu_notifier_register_done();
-
-	return 0;
-}
-__initcall(vsyscall_init);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4cb8763868fc..dd9ca9becc0f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1193,55 +1193,6 @@ int kern_addr_valid(unsigned long addr)
 	return pfn_valid(pte_pfn(*pte));
 }
 
-/*
- * A pseudo VMA to allow ptrace access for the vsyscall page.  This only
- * covers the 64bit vsyscall page now. 32bit has a real VMA now and does
- * not need special handling anymore:
- */
-static const char *gate_vma_name(struct vm_area_struct *vma)
-{
-	return "[vsyscall]";
-}
-static struct vm_operations_struct gate_vma_ops = {
-	.name = gate_vma_name,
-};
-static struct vm_area_struct gate_vma = {
-	.vm_start	= VSYSCALL_ADDR,
-	.vm_end		= VSYSCALL_ADDR + PAGE_SIZE,
-	.vm_page_prot	= PAGE_READONLY_EXEC,
-	.vm_flags	= VM_READ | VM_EXEC,
-	.vm_ops		= &gate_vma_ops,
-};
-
-struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
-{
-#ifdef CONFIG_IA32_EMULATION
-	if (!mm || mm->context.ia32_compat)
-		return NULL;
-#endif
-	return &gate_vma;
-}
-
-int in_gate_area(struct mm_struct *mm, unsigned long addr)
-{
-	struct vm_area_struct *vma = get_gate_vma(mm);
-
-	if (!vma)
-		return 0;
-
-	return (addr >= vma->vm_start) && (addr < vma->vm_end);
-}
-
-/*
- * Use this when you have no reliable mm, typically from interrupt
- * context. It is less reliable than using a task's mm and may give
- * false positives.
- */
-int in_gate_area_no_mm(unsigned long addr)
-{
-	return (addr & PAGE_MASK) == VSYSCALL_ADDR;
-}
-
 static unsigned long probe_memory_block_size(void)
 {
 	/* start from 2g */
diff --git a/arch/x86/vdso/vgetcpu.c b/arch/x86/vdso/vgetcpu.c
index 2f94b039e55b..8ec3d1f4ce9a 100644
--- a/arch/x86/vdso/vgetcpu.c
+++ b/arch/x86/vdso/vgetcpu.c
@@ -7,9 +7,7 @@
 
 #include <linux/kernel.h>
 #include <linux/getcpu.h>
-#include <linux/jiffies.h>
 #include <linux/time.h>
-#include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 
 notrace long
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 970463b566cf..009495b9ab4b 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -1,7 +1,8 @@
 /*
- * Set up the VMAs to tell the VM about the vDSO.
  * Copyright 2007 Andi Kleen, SUSE Labs.
  * Subject to the GPL, v.2
+ *
+ * This contains most of the x86 vDSO kernel-side code.
  */
 #include <linux/mm.h>
 #include <linux/err.h>
@@ -10,17 +11,17 @@
 #include <linux/init.h>
 #include <linux/random.h>
 #include <linux/elf.h>
-#include <asm/vsyscall.h>
+#include <linux/cpu.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
 #include <asm/vdso.h>
+#include <asm/vvar.h>
 #include <asm/page.h>
 #include <asm/hpet.h>
+#include <asm/desc.h>
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
-
-extern unsigned short vdso_sync_cpuid;
 #endif
 
 void __init init_vdso_image(const struct vdso_image *image)
@@ -38,20 +39,6 @@ void __init init_vdso_image(const struct vdso_image *image)
 						image->alt_len));
 }
 
-#if defined(CONFIG_X86_64)
-static int __init init_vdso(void)
-{
-	init_vdso_image(&vdso_image_64);
-
-#ifdef CONFIG_X86_X32_ABI
-	init_vdso_image(&vdso_image_x32);
-#endif
-
-	return 0;
-}
-subsys_initcall(init_vdso);
-#endif
-
 struct linux_binprm;
 
 /* Put the vdso above the (randomized) stack with another randomized offset.
@@ -238,3 +225,63 @@ static __init int vdso_setup(char *s)
 }
 __setup("vdso=", vdso_setup);
 #endif
+
+#ifdef CONFIG_X86_64
+static void vgetcpu_cpu_init(void *arg)
+{
+	int cpu = smp_processor_id();
+	struct desc_struct d = { };
+	unsigned long node = 0;
+#ifdef CONFIG_NUMA
+	node = cpu_to_node(cpu);
+#endif
+	if (cpu_has(&cpu_data(cpu), X86_FEATURE_RDTSCP))
+		write_rdtscp_aux((node << 12) | cpu);
+
+	/*
+	 * Store cpu number in limit so that it can be loaded
+	 * quickly in user space in vgetcpu. (12 bits for the CPU
+	 * and 8 bits for the node)
+	 */
+	d.limit0 = cpu | ((node & 0xf) << 12);
+	d.limit = node >> 4;
+	d.type = 5;		/* RO data, expand down, accessed */
+	d.dpl = 3;		/* Visible to user code */
+	d.s = 1;		/* Not a system segment */
+	d.p = 1;		/* Present */
+	d.d = 1;		/* 32-bit */
+
+	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
+}
+
+static int
+vgetcpu_cpu_notifier(struct notifier_block *n, unsigned long action, void *arg)
+{
+	long cpu = (long)arg;
+
+	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN)
+		smp_call_function_single(cpu, vgetcpu_cpu_init, NULL, 1);
+
+	return NOTIFY_DONE;
+}
+
+static int __init init_vdso(void)
+{
+	init_vdso_image(&vdso_image_64);
+
+#ifdef CONFIG_X86_X32_ABI
+	init_vdso_image(&vdso_image_x32);
+#endif
+
+	cpu_notifier_register_begin();
+
+	on_each_cpu(vgetcpu_cpu_init, NULL, 1);
+	/* notifier priority > KVM */
+	__hotcpu_notifier(vgetcpu_cpu_notifier, 30);
+
+	cpu_notifier_register_done();
+
+	return 0;
+}
+subsys_initcall(init_vdso);
+#endif /* CONFIG_X86_64 */
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a8a1a3d08d4d..8906cf0e536f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1457,8 +1457,10 @@ static int xen_pgd_alloc(struct mm_struct *mm)
 		page->private = (unsigned long)user_pgd;
 
 		if (user_pgd != NULL) {
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
 			user_pgd[pgd_index(VSYSCALL_ADDR)] =
 				__pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
+#endif
 			ret = 0;
 		}
 
@@ -2021,7 +2023,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 # ifdef CONFIG_HIGHMEM
 	case FIX_KMAP_BEGIN ... FIX_KMAP_END:
 # endif
-#else
+#elif defined(CONFIG_X86_VSYSCALL_EMULATION)
 	case VSYSCALL_PAGE:
 #endif
 	case FIX_TEXT_POKE0:
@@ -2060,7 +2062,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 
 	__native_set_fixmap(idx, pte);
 
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
 	/* Replicate changes to map the vsyscall page into the user
 	   pagetable vsyscall mapping. */
 	if (idx == VSYSCALL_PAGE) {
