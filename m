Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbaEEWZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:25:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57384 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbaEEWZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:25:52 -0400
Date: Mon, 5 May 2014 15:25:39 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-f40c330091c7aa9956ab66f97a3abc8a68b67240@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <8af87023f57f6bb96ec8d17fce3f88018195b49b.1399317206.git.luto@amacapital.net>
References: <8af87023f57f6bb96ec8d17fce3f88018195b49b.1399317206.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso:
  Move the vvar and hpet mappings next to the 64-bit vDSO
Git-Commit-ID: f40c330091c7aa9956ab66f97a3abc8a68b67240
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f40c330091c7aa9956ab66f97a3abc8a68b67240
Gitweb:     http://git.kernel.org/tip/f40c330091c7aa9956ab66f97a3abc8a68b67240
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon, 5 May 2014 12:19:36 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 5 May 2014 13:19:01 -0700

x86, vdso: Move the vvar and hpet mappings next to the 64-bit vDSO

This makes the 64-bit and x32 vdsos use the same mechanism as the
32-bit vdso.  Most of the churn is deleting all the old fixmap code.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/8af87023f57f6bb96ec8d17fce3f88018195b49b.1399317206.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/fixmap.h        | 11 ++++-------
 arch/x86/include/asm/vvar.h          | 20 +-------------------
 arch/x86/include/uapi/asm/vsyscall.h |  7 +------
 arch/x86/kernel/cpu/common.c         |  1 +
 arch/x86/kernel/hpet.c               |  3 ---
 arch/x86/kernel/vsyscall_64.c        | 15 ++++-----------
 arch/x86/mm/fault.c                  |  5 +++--
 arch/x86/mm/init_64.c                | 10 +++++-----
 arch/x86/vdso/vclock_gettime.c       | 22 +++++-----------------
 arch/x86/vdso/vdso-layout.lds.S      |  2 --
 arch/x86/xen/mmu.c                   |  8 +++-----
 11 files changed, 27 insertions(+), 77 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 43f482a..b0910f9 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -24,7 +24,7 @@
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
 #else
-#include <asm/vsyscall.h>
+#include <uapi/asm/vsyscall.h>
 #endif
 
 /*
@@ -41,7 +41,8 @@
 extern unsigned long __FIXADDR_TOP;
 #define FIXADDR_TOP	((unsigned long)__FIXADDR_TOP)
 #else
-#define FIXADDR_TOP	(VSYSCALL_END-PAGE_SIZE)
+#define FIXADDR_TOP	(round_up(VSYSCALL_ADDR + PAGE_SIZE, 1<<PMD_SHIFT) - \
+			 PAGE_SIZE)
 #endif
 
 
@@ -68,11 +69,7 @@ enum fixed_addresses {
 #ifdef CONFIG_X86_32
 	FIX_HOLE,
 #else
-	VSYSCALL_LAST_PAGE,
-	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
-			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
-	VVAR_PAGE,
-	VSYSCALL_HPET,
+	VSYSCALL_PAGE = (FIXADDR_TOP - VSYSCALL_ADDR) >> PAGE_SHIFT,
 #ifdef CONFIG_PARAVIRT_CLOCK
 	PVCLOCK_FIXMAP_BEGIN,
 	PVCLOCK_FIXMAP_END = PVCLOCK_FIXMAP_BEGIN+PVCLOCK_VSYSCALL_NR_PAGES-1,
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 081d909..5d2b9ad 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -29,31 +29,13 @@
 
 #else
 
-#ifdef BUILD_VDSO32
+extern char __vvar_page;
 
 #define DECLARE_VVAR(offset, type, name)				\
 	extern type vvar_ ## name __attribute__((visibility("hidden")));
 
 #define VVAR(name) (vvar_ ## name)
 
-#else
-
-extern char __vvar_page;
-
-/* Base address of vvars.  This is not ABI. */
-#ifdef CONFIG_X86_64
-#define VVAR_ADDRESS (-10*1024*1024 - 4096)
-#else
-#define VVAR_ADDRESS (&__vvar_page)
-#endif
-
-#define DECLARE_VVAR(offset, type, name)				\
-	static type const * const vvaraddr_ ## name =			\
-		(void *)(VVAR_ADDRESS + (offset));
-
-#define VVAR(name) (*vvaraddr_ ## name)
-#endif
-
 #define DEFINE_VVAR(type, name)						\
 	type name							\
 	__attribute__((section(".vvar_" #name), aligned(16))) __visible
diff --git a/arch/x86/include/uapi/asm/vsyscall.h b/arch/x86/include/uapi/asm/vsyscall.h
index 85dc1b3..b97dd6e 100644
--- a/arch/x86/include/uapi/asm/vsyscall.h
+++ b/arch/x86/include/uapi/asm/vsyscall.h
@@ -7,11 +7,6 @@ enum vsyscall_num {
 	__NR_vgetcpu,
 };
 
-#define VSYSCALL_START (-10UL << 20)
-#define VSYSCALL_SIZE 1024
-#define VSYSCALL_END (-2UL << 20)
-#define VSYSCALL_MAPPED_PAGES 1
-#define VSYSCALL_ADDR(vsyscall_nr) (VSYSCALL_START+VSYSCALL_SIZE*(vsyscall_nr))
-
+#define VSYSCALL_ADDR (-10UL << 20)
 
 #endif /* _UAPI_ASM_X86_VSYSCALL_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7c65b46..2cbbf88 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -20,6 +20,7 @@
 #include <asm/processor.h>
 #include <asm/debugreg.h>
 #include <asm/sections.h>
+#include <asm/vsyscall.h>
 #include <linux/topology.h>
 #include <linux/cpumask.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 8d80ae0..bbc15a0 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -74,9 +74,6 @@ static inline void hpet_writel(unsigned int d, unsigned int a)
 static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
-#ifdef CONFIG_X86_64
-	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_NOCACHE);
-#endif
 }
 
 static inline void hpet_clear_mapping(void)
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 8b3b3eb..ea5b570 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -91,7 +91,7 @@ static int addr_to_vsyscall_nr(unsigned long addr)
 {
 	int nr;
 
-	if ((addr & ~0xC00UL) != VSYSCALL_START)
+	if ((addr & ~0xC00UL) != VSYSCALL_ADDR)
 		return -EINVAL;
 
 	nr = (addr & 0xC00UL) >> 10;
@@ -330,24 +330,17 @@ void __init map_vsyscall(void)
 {
 	extern char __vsyscall_page;
 	unsigned long physaddr_vsyscall = __pa_symbol(&__vsyscall_page);
-	unsigned long physaddr_vvar_page = __pa_symbol(&__vvar_page);
 
-	__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_vsyscall,
+	__set_fixmap(VSYSCALL_PAGE, physaddr_vsyscall,
 		     vsyscall_mode == NATIVE
 		     ? PAGE_KERNEL_VSYSCALL
 		     : PAGE_KERNEL_VVAR);
-	BUILD_BUG_ON((unsigned long)__fix_to_virt(VSYSCALL_FIRST_PAGE) !=
-		     (unsigned long)VSYSCALL_START);
-
-	__set_fixmap(VVAR_PAGE, physaddr_vvar_page, PAGE_KERNEL_VVAR);
-	BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) !=
-		     (unsigned long)VVAR_ADDRESS);
+	BUILD_BUG_ON((unsigned long)__fix_to_virt(VSYSCALL_PAGE) !=
+		     (unsigned long)VSYSCALL_ADDR);
 }
 
 static int __init vsyscall_init(void)
 {
-	BUG_ON(VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE));
-
 	cpu_notifier_register_begin();
 
 	on_each_cpu(cpu_vsyscall_init, NULL, 1);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8e57229..858b47b 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -18,7 +18,8 @@
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
-#include <asm/fixmap.h>			/* VSYSCALL_START		*/
+#include <asm/fixmap.h>			/* VSYSCALL_ADDR		*/
+#include <asm/vsyscall.h>		/* emulate_vsyscall		*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -771,7 +772,7 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 		 * emulation.
 		 */
 		if (unlikely((error_code & PF_INSTR) &&
-			     ((address & ~0xfff) == VSYSCALL_START))) {
+			     ((address & ~0xfff) == VSYSCALL_ADDR))) {
 			if (emulate_vsyscall(regs, address))
 				return;
 		}
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 5638496..6f88184 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1055,8 +1055,8 @@ void __init mem_init(void)
 	after_bootmem = 1;
 
 	/* Register memory areas for /proc/kcore */
-	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START,
-			 VSYSCALL_END - VSYSCALL_START, KCORE_OTHER);
+	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_ADDR,
+			 PAGE_SIZE, KCORE_OTHER);
 
 	mem_init_print_info(NULL);
 }
@@ -1186,8 +1186,8 @@ int kern_addr_valid(unsigned long addr)
  * not need special handling anymore:
  */
 static struct vm_area_struct gate_vma = {
-	.vm_start	= VSYSCALL_START,
-	.vm_end		= VSYSCALL_START + (VSYSCALL_MAPPED_PAGES * PAGE_SIZE),
+	.vm_start	= VSYSCALL_ADDR,
+	.vm_end		= VSYSCALL_ADDR + PAGE_SIZE,
 	.vm_page_prot	= PAGE_READONLY_EXEC,
 	.vm_flags	= VM_READ | VM_EXEC
 };
@@ -1218,7 +1218,7 @@ int in_gate_area(struct mm_struct *mm, unsigned long addr)
  */
 int in_gate_area_no_mm(unsigned long addr)
 {
-	return (addr >= VSYSCALL_START) && (addr < VSYSCALL_END);
+	return (addr & PAGE_MASK) == VSYSCALL_ADDR;
 }
 
 const char *arch_vma_name(struct vm_area_struct *vma)
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 091554c..b2e4f49 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -30,9 +30,12 @@ extern int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz);
 extern time_t __vdso_time(time_t *t);
 
 #ifdef CONFIG_HPET_TIMER
-static inline u32 read_hpet_counter(const volatile void *addr)
+extern u8 hpet_page
+	__attribute__((visibility("hidden")));
+
+static notrace cycle_t vread_hpet(void)
 {
-	return *(const volatile u32 *) (addr + HPET_COUNTER);
+	return *(const volatile u32 *)(&hpet_page + HPET_COUNTER);
 }
 #endif
 
@@ -43,11 +46,6 @@ static inline u32 read_hpet_counter(const volatile void *addr)
 #include <asm/fixmap.h>
 #include <asm/pvclock.h>
 
-static notrace cycle_t vread_hpet(void)
-{
-	return read_hpet_counter((const void *)fix_to_virt(VSYSCALL_HPET));
-}
-
 notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
 	long ret;
@@ -137,16 +135,6 @@ static notrace cycle_t vread_pvclock(int *mode)
 
 #else
 
-extern u8 hpet_page
-	__attribute__((visibility("hidden")));
-
-#ifdef CONFIG_HPET_TIMER
-static notrace cycle_t vread_hpet(void)
-{
-	return read_hpet_counter((const void *)(&hpet_page));
-}
-#endif
-
 notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
 	long ret;
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index e177c08..2ec72f6 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -47,7 +47,6 @@ SECTIONS
 
 	.text		: { *(.text*) }			:text	=0x90909090,
 
-#ifdef BUILD_VDSO32
 	/*
 	 * The remainder of the vDSO consists of special pages that are
 	 * shared between the kernel and userspace.  It needs to be at the
@@ -69,7 +68,6 @@ SECTIONS
 
 	hpet_page = .;
 	. = . + PAGE_SIZE;
-#endif
 
 	. = ALIGN(PAGE_SIZE);
 	end_mapping = .;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 86e02ea..3060568 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1494,7 +1494,7 @@ static int xen_pgd_alloc(struct mm_struct *mm)
 		page->private = (unsigned long)user_pgd;
 
 		if (user_pgd != NULL) {
-			user_pgd[pgd_index(VSYSCALL_START)] =
+			user_pgd[pgd_index(VSYSCALL_ADDR)] =
 				__pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
 			ret = 0;
 		}
@@ -2062,8 +2062,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 	case FIX_KMAP_BEGIN ... FIX_KMAP_END:
 # endif
 #else
-	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
-	case VVAR_PAGE:
+	case VSYSCALL_PAGE:
 #endif
 	case FIX_TEXT_POKE0:
 	case FIX_TEXT_POKE1:
@@ -2104,8 +2103,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #ifdef CONFIG_X86_64
 	/* Replicate changes to map the vsyscall page into the user
 	   pagetable vsyscall mapping. */
-	if ((idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) ||
-	    idx == VVAR_PAGE) {
+	if (idx == VSYSCALL_PAGE) {
 		unsigned long vaddr = __fix_to_virt(idx);
 		set_pte_vaddr_pud(level3_user_vsyscall, vaddr, pte);
 	}
