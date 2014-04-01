Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaDASyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:54:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34886 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaDASxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:53:39 -0400
Date: Tue, 1 Apr 2014 11:52:53 -0700
Message-Id: <201404011852.s31Iqrqw025229@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 vdso changes for v3.15
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        fengguang.wu@intel.com, hpa@linux.intel.com, hpa@zytor.com,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        luto@amacapital.net, mingo@kernel.org, stefani@seibold.net,
        tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the revamp of the 32-bit vdso and the associated cleanups.

This adds timekeeping support to the 32-bit vdso that we already have
in the 64-bit vdso.  Although 32-bit x86 is legacy, it is likely to
remain in the embedded space for a very long time to come.

This removes the traditional COMPAT_VDSO support; the configuration
variable is reused for simply removing the 32-bit vdso, which will
produce correct results but obviously suffer a performance penalty.
Only one beta version of glibc was affected, but that version was
unfortunately included in one OpenSUSE release.

This is not the end of the vdso cleanups.  Stefani and Andy have
agreed to continue work for the next kernel cycle; in fact Andy has
already produced another set of cleanups that came too late for this
cycle.

An incidental, but arguably important, change is that this ensures
that unused space in the VVAR page is properly zeroed.  It wasn't
before, and would contain whatever garbage was left in memory by BIOS
or the bootloader.  Since the VVAR page is accessible to user space
this had the potential of information leaks.

The following changes since commit fa389e220254c69ffae0d403eac4146171062d08:

  Linux 3.14-rc6 (2014-03-09 19:41:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-vdso-for-linus

for you to fetch changes up to 37c975545ec63320789962bf307f000f08fabd48:

  x86, vdso: Fix the symbol versions on the 32-bit vDSO (2014-03-30 10:08:38 -0700)

----------------------------------------------------------------
Andy Lutomirski (9):
      x86, vdso: Remove compat vdso support
      x86_32, mm: Remove user bit from identity map PDE
      x86, vdso: Patch alternatives in the 32-bit VDSO
      x86, vdso: Zero-pad the VVAR page
      x86: Load the 32-bit vdso in place, just like the 64-bit vdsos
      x86, vdso: Move more vdso definitions into vdso.h
      x86, vdso: Finish removing VDSO32_PRELINK
      x86, vdso, build: Don't rebuild 32-bit vdsos on every make
      x86, vdso: Fix the symbol versions on the 32-bit vDSO

H. Peter Anvin (3):
      x86, vdso, xen: Remove stray reference to FIX_VDSO
      x86, vdso32: Disable stack protector, adjust optimizations
      x86, vdso: Actually discard the .discard sections

Stefani Seibold (11):
      x86, vdso: Make vsyscall_gtod_data handling x86 generic
      mm: Add new func _install_special_mapping() to mmap.c
      x86, vdso: Revamp vclock_gettime.c
      x86, vdso: __vdso_clock_gettime() cleanup
      x86, vdso: Replace VVAR(vsyscall_gtod_data) by gtod macro
      x86, vdso: Cleanup __vdso_gettimeofday()
      x86, vdso: Introduce VVAR marco for vdso32
      x86, vdso: Add 32 bit VDSO time support for 32 bit kernel
      x86, vdso: Add 32 bit VDSO time support for 64 bit kernel
      x86, vdso32: handle 32 bit vDSO larger one page
      x86, vdso: Fix size of get_unmapped_area()

 Documentation/kernel-parameters.txt   |  22 ++-
 arch/x86/Kconfig                      |  30 +++-
 arch/x86/include/asm/clocksource.h    |   4 -
 arch/x86/include/asm/elf.h            |   4 -
 arch/x86/include/asm/fixmap.h         |   8 -
 arch/x86/include/asm/pgtable_types.h  |   7 +-
 arch/x86/include/asm/vdso.h           |  52 ++++--
 arch/x86/include/asm/vdso32.h         |  11 ++
 arch/x86/include/asm/vgtod.h          |  71 ++++++--
 arch/x86/include/asm/vvar.h           |  29 +++-
 arch/x86/kernel/Makefile              |   2 +-
 arch/x86/kernel/hpet.c                |   2 -
 arch/x86/kernel/tsc.c                 |   2 -
 arch/x86/kernel/vmlinux.lds.S         |   8 +-
 arch/x86/kernel/vsyscall_64.c         |  45 -----
 arch/x86/kernel/vsyscall_gtod.c       |  69 ++++++++
 arch/x86/tools/relocs.c               |   2 +-
 arch/x86/vdso/Makefile                |  16 +-
 arch/x86/vdso/vclock_gettime.c        | 256 ++++++++++++++++++-----------
 arch/x86/vdso/vdso-layout.lds.S       |  29 +++-
 arch/x86/vdso/vdso.S                  |  22 +--
 arch/x86/vdso/vdso32-setup.c          | 301 +++++++++-------------------------
 arch/x86/vdso/vdso32.S                |  21 +--
 arch/x86/vdso/vdso32/vclock_gettime.c |  30 ++++
 arch/x86/vdso/vdso32/vdso32.lds.S     |  15 +-
 arch/x86/vdso/vdsox32.S               |  22 +--
 arch/x86/vdso/vma.c                   |  20 ++-
 arch/x86/xen/mmu.c                    |   1 -
 include/linux/mm.h                    |   3 +
 mm/mmap.c                             |  20 ++-
 30 files changed, 617 insertions(+), 507 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda..8601975 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3409,14 +3409,24 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 					of CONFIG_HIGHPTE.
 
 	vdso=		[X86,SH]
-			vdso=2: enable compat VDSO (default with COMPAT_VDSO)
-			vdso=1: enable VDSO (default)
+			On X86_32, this is an alias for vdso32=.  Otherwise:
+
+			vdso=1: enable VDSO (the default)
 			vdso=0: disable VDSO mapping
 
-	vdso32=		[X86]
-			vdso32=2: enable compat VDSO (default with COMPAT_VDSO)
-			vdso32=1: enable 32-bit VDSO (default)
-			vdso32=0: disable 32-bit VDSO mapping
+	vdso32=		[X86] Control the 32-bit vDSO
+			vdso32=1: enable 32-bit VDSO
+			vdso32=0 or vdso32=2: disable 32-bit VDSO
+
+			See the help text for CONFIG_COMPAT_VDSO for more
+			details.  If CONFIG_COMPAT_VDSO is set, the default is
+			vdso32=0; otherwise, the default is vdso32=1.
+
+			For compatibility with older kernels, vdso32=2 is an
+			alias for vdso32=0.
+
+			Try vdso32=0 if you encounter an error that says:
+			dl_main: Assertion `(void *) ph->p_vaddr == _rtld_local._dl_sysinfo_dso' failed!
 
 	vector=		[IA-64,SMP]
 			vector=percpu: enable percpu vector domain
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..ab3ebc8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -107,9 +107,9 @@ config X86
 	select HAVE_ARCH_SOFT_DIRTY
 	select CLOCKSOURCE_WATCHDOG
 	select GENERIC_CLOCKEVENTS
-	select ARCH_CLOCKSOURCE_DATA if X86_64
+	select ARCH_CLOCKSOURCE_DATA
 	select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
-	select GENERIC_TIME_VSYSCALL if X86_64
+	select GENERIC_TIME_VSYSCALL
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
@@ -1836,17 +1836,29 @@ config DEBUG_HOTPLUG_CPU0
 	  If unsure, say N.
 
 config COMPAT_VDSO
-	def_bool y
-	prompt "Compat VDSO support"
+	def_bool n
+	prompt "Disable the 32-bit vDSO (needed for glibc 2.3.3)"
 	depends on X86_32 || IA32_EMULATION
 	---help---
-	  Map the 32-bit VDSO to the predictable old-style address too.
+	  Certain buggy versions of glibc will crash if they are
+	  presented with a 32-bit vDSO that is not mapped at the address
+	  indicated in its segment table.
 
-	  Say N here if you are running a sufficiently recent glibc
-	  version (2.3.3 or later), to remove the high-mapped
-	  VDSO mapping and to exclusively use the randomized VDSO.
+	  The bug was introduced by f866314b89d56845f55e6f365e18b31ec978ec3a
+	  and fixed by 3b3ddb4f7db98ec9e912ccdf54d35df4aa30e04a and
+	  49ad572a70b8aeb91e57483a11dd1b77e31c4468.  Glibc 2.3.3 is
+	  the only released version with the bug, but OpenSUSE 9
+	  contains a buggy "glibc 2.3.2".
 
-	  If unsure, say Y.
+	  The symptom of the bug is that everything crashes on startup, saying:
+	  dl_main: Assertion `(void *) ph->p_vaddr == _rtld_local._dl_sysinfo_dso' failed!
+
+	  Saying Y here changes the default value of the vdso32 boot
+	  option from 1 to 0, which turns off the 32-bit vDSO entirely.
+	  This works around the glibc bug but hurts performance.
+
+	  If unsure, say N: if you are compiling your own kernel, you
+	  are unlikely to be using a buggy version of glibc.
 
 config CMDLINE_BOOL
 	bool "Built-in kernel command line"
diff --git a/arch/x86/include/asm/clocksource.h b/arch/x86/include/asm/clocksource.h
index 16a57f4..eda81dc 100644
--- a/arch/x86/include/asm/clocksource.h
+++ b/arch/x86/include/asm/clocksource.h
@@ -3,8 +3,6 @@
 #ifndef _ASM_X86_CLOCKSOURCE_H
 #define _ASM_X86_CLOCKSOURCE_H
 
-#ifdef CONFIG_X86_64
-
 #define VCLOCK_NONE 0  /* No vDSO clock available.	*/
 #define VCLOCK_TSC  1  /* vDSO should use vread_tsc.	*/
 #define VCLOCK_HPET 2  /* vDSO should use vread_hpet.	*/
@@ -14,6 +12,4 @@ struct arch_clocksource_data {
 	int vclock_mode;
 };
 
-#endif /* CONFIG_X86_64 */
-
 #endif /* _ASM_X86_CLOCKSOURCE_H */
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 9c999c1..2c71182 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -281,16 +281,12 @@ do {									\
 
 #define STACK_RND_MASK (0x7ff)
 
-#define VDSO_HIGH_BASE		(__fix_to_virt(FIX_VDSO))
-
 #define ARCH_DLINFO		ARCH_DLINFO_IA32(vdso_enabled)
 
 /* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 
 #else /* CONFIG_X86_32 */
 
-#define VDSO_HIGH_BASE		0xffffe000U /* CONFIG_COMPAT_VDSO address */
-
 /* 1GB for 64bit, 8MB for 32bit */
 #define STACK_RND_MASK (test_thread_flag(TIF_ADDR32) ? 0x7ff : 0x3fffff)
 
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 7252cd3..2377f56 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -40,15 +40,8 @@
  */
 extern unsigned long __FIXADDR_TOP;
 #define FIXADDR_TOP	((unsigned long)__FIXADDR_TOP)
-
-#define FIXADDR_USER_START     __fix_to_virt(FIX_VDSO)
-#define FIXADDR_USER_END       __fix_to_virt(FIX_VDSO - 1)
 #else
 #define FIXADDR_TOP	(VSYSCALL_END-PAGE_SIZE)
-
-/* Only covers 32bit vsyscalls currently. Need another set for 64bit. */
-#define FIXADDR_USER_START	((unsigned long)VSYSCALL32_VSYSCALL)
-#define FIXADDR_USER_END	(FIXADDR_USER_START + PAGE_SIZE)
 #endif
 
 
@@ -74,7 +67,6 @@ extern unsigned long __FIXADDR_TOP;
 enum fixed_addresses {
 #ifdef CONFIG_X86_32
 	FIX_HOLE,
-	FIX_VDSO,
 #else
 	VSYSCALL_LAST_PAGE,
 	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 1aa9ccd..757f9c4 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -214,13 +214,8 @@
 #ifdef CONFIG_X86_64
 #define __PAGE_KERNEL_IDENT_LARGE_EXEC	__PAGE_KERNEL_LARGE_EXEC
 #else
-/*
- * For PDE_IDENT_ATTR include USER bit. As the PDE and PTE protection
- * bits are combined, this will alow user to access the high address mapped
- * VDSO in the presence of CONFIG_COMPAT_VDSO
- */
 #define PTE_IDENT_ATTR	 0x003		/* PRESENT+RW */
-#define PDE_IDENT_ATTR	 0x067		/* PRESENT+RW+USER+DIRTY+ACCESSED */
+#define PDE_IDENT_ATTR	 0x063		/* PRESENT+RW+DIRTY+ACCESSED */
 #define PGD_IDENT_ATTR	 0x001		/* PRESENT (no other attributes) */
 #endif
 
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index fddb53d..d1dc554 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -1,8 +1,45 @@
 #ifndef _ASM_X86_VDSO_H
 #define _ASM_X86_VDSO_H
 
+#include <asm/page_types.h>
+#include <linux/linkage.h>
+
+#ifdef __ASSEMBLER__
+
+#define DEFINE_VDSO_IMAGE(symname, filename)				\
+__PAGE_ALIGNED_DATA ;							\
+	.globl symname##_start, symname##_end ;				\
+	.align PAGE_SIZE ;						\
+	symname##_start: ;						\
+	.incbin filename ;						\
+	symname##_end: ;						\
+	.align PAGE_SIZE /* extra data here leaks to userspace. */ ;	\
+									\
+.previous ;								\
+									\
+	.globl symname##_pages ;					\
+	.bss ;								\
+	.align 8 ;							\
+	.type symname##_pages, @object ;				\
+	symname##_pages: ;						\
+	.zero (symname##_end - symname##_start + PAGE_SIZE - 1) / PAGE_SIZE * (BITS_PER_LONG / 8) ; \
+	.size symname##_pages, .-symname##_pages
+
+#else
+
+#define DECLARE_VDSO_IMAGE(symname)				\
+	extern char symname##_start[], symname##_end[];		\
+	extern struct page *symname##_pages[]
+
 #if defined CONFIG_X86_32 || defined CONFIG_COMPAT
-extern const char VDSO32_PRELINK[];
+
+#include <asm/vdso32.h>
+
+DECLARE_VDSO_IMAGE(vdso32_int80);
+#ifdef CONFIG_COMPAT
+DECLARE_VDSO_IMAGE(vdso32_syscall);
+#endif
+DECLARE_VDSO_IMAGE(vdso32_sysenter);
 
 /*
  * Given a pointer to the vDSO image, find the pointer to VDSO32_name
@@ -11,8 +48,7 @@ extern const char VDSO32_PRELINK[];
 #define VDSO32_SYMBOL(base, name)					\
 ({									\
 	extern const char VDSO32_##name[];				\
-	(void __user *)(VDSO32_##name - VDSO32_PRELINK +		\
-			(unsigned long)(base));				\
+	(void __user *)(VDSO32_##name + (unsigned long)(base));		\
 })
 #endif
 
@@ -23,12 +59,8 @@ extern const char VDSO32_PRELINK[];
 extern void __user __kernel_sigreturn;
 extern void __user __kernel_rt_sigreturn;
 
-/*
- * These symbols are defined by vdso32.S to mark the bounds
- * of the ELF DSO images included therein.
- */
-extern const char vdso32_int80_start, vdso32_int80_end;
-extern const char vdso32_syscall_start, vdso32_syscall_end;
-extern const char vdso32_sysenter_start, vdso32_sysenter_end;
+void __init patch_vdso32(void *vdso, size_t len);
+
+#endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_X86_VDSO_H */
diff --git a/arch/x86/include/asm/vdso32.h b/arch/x86/include/asm/vdso32.h
new file mode 100644
index 0000000..7efb701
--- /dev/null
+++ b/arch/x86/include/asm/vdso32.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_X86_VDSO32_H
+#define _ASM_X86_VDSO32_H
+
+#define VDSO_BASE_PAGE	0
+#define VDSO_VVAR_PAGE	1
+#define VDSO_HPET_PAGE	2
+#define VDSO_PAGES	3
+#define VDSO_PREV_PAGES	2
+#define VDSO_OFFSET(x)	((x) * PAGE_SIZE)
+
+#endif
diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 46e24d3..3c3366c 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -1,30 +1,73 @@
 #ifndef _ASM_X86_VGTOD_H
 #define _ASM_X86_VGTOD_H
 
-#include <asm/vsyscall.h>
+#include <linux/compiler.h>
 #include <linux/clocksource.h>
 
+#ifdef BUILD_VDSO32_64
+typedef u64 gtod_long_t;
+#else
+typedef unsigned long gtod_long_t;
+#endif
+/*
+ * vsyscall_gtod_data will be accessed by 32 and 64 bit code at the same time
+ * so be carefull by modifying this structure.
+ */
 struct vsyscall_gtod_data {
-	seqcount_t	seq;
+	unsigned seq;
 
-	struct { /* extract of a clocksource struct */
-		int vclock_mode;
-		cycle_t	cycle_last;
-		cycle_t	mask;
-		u32	mult;
-		u32	shift;
-	} clock;
+	int vclock_mode;
+	cycle_t	cycle_last;
+	cycle_t	mask;
+	u32	mult;
+	u32	shift;
 
 	/* open coded 'struct timespec' */
-	time_t		wall_time_sec;
 	u64		wall_time_snsec;
+	gtod_long_t	wall_time_sec;
+	gtod_long_t	monotonic_time_sec;
 	u64		monotonic_time_snsec;
-	time_t		monotonic_time_sec;
+	gtod_long_t	wall_time_coarse_sec;
+	gtod_long_t	wall_time_coarse_nsec;
+	gtod_long_t	monotonic_time_coarse_sec;
+	gtod_long_t	monotonic_time_coarse_nsec;
 
-	struct timezone sys_tz;
-	struct timespec wall_time_coarse;
-	struct timespec monotonic_time_coarse;
+	int		tz_minuteswest;
+	int		tz_dsttime;
 };
 extern struct vsyscall_gtod_data vsyscall_gtod_data;
 
+static inline unsigned gtod_read_begin(const struct vsyscall_gtod_data *s)
+{
+	unsigned ret;
+
+repeat:
+	ret = ACCESS_ONCE(s->seq);
+	if (unlikely(ret & 1)) {
+		cpu_relax();
+		goto repeat;
+	}
+	smp_rmb();
+	return ret;
+}
+
+static inline int gtod_read_retry(const struct vsyscall_gtod_data *s,
+					unsigned start)
+{
+	smp_rmb();
+	return unlikely(s->seq != start);
+}
+
+static inline void gtod_write_begin(struct vsyscall_gtod_data *s)
+{
+	++s->seq;
+	smp_wmb();
+}
+
+static inline void gtod_write_end(struct vsyscall_gtod_data *s)
+{
+	smp_wmb();
+	++s->seq;
+}
+
 #endif /* _ASM_X86_VGTOD_H */
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index d76ac40..081d909 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -16,8 +16,8 @@
  * you mess up, the linker will catch it.)
  */
 
-/* Base address of vvars.  This is not ABI. */
-#define VVAR_ADDRESS (-10*1024*1024 - 4096)
+#ifndef _ASM_X86_VVAR_H
+#define _ASM_X86_VVAR_H
 
 #if defined(__VVAR_KERNEL_LDS)
 
@@ -29,16 +29,35 @@
 
 #else
 
+#ifdef BUILD_VDSO32
+
+#define DECLARE_VVAR(offset, type, name)				\
+	extern type vvar_ ## name __attribute__((visibility("hidden")));
+
+#define VVAR(name) (vvar_ ## name)
+
+#else
+
+extern char __vvar_page;
+
+/* Base address of vvars.  This is not ABI. */
+#ifdef CONFIG_X86_64
+#define VVAR_ADDRESS (-10*1024*1024 - 4096)
+#else
+#define VVAR_ADDRESS (&__vvar_page)
+#endif
+
 #define DECLARE_VVAR(offset, type, name)				\
 	static type const * const vvaraddr_ ## name =			\
 		(void *)(VVAR_ADDRESS + (offset));
 
+#define VVAR(name) (*vvaraddr_ ## name)
+#endif
+
 #define DEFINE_VVAR(type, name)						\
 	type name							\
 	__attribute__((section(".vvar_" #name), aligned(16))) __visible
 
-#define VVAR(name) (*vvaraddr_ ## name)
-
 #endif
 
 /* DECLARE_VVAR(offset, type, name) */
@@ -48,3 +67,5 @@ DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
 
 #undef DECLARE_VVAR
+
+#endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index cb648c8..f4d9600 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -26,7 +26,7 @@ obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
-obj-y			+= syscall_$(BITS).o
+obj-y			+= syscall_$(BITS).o vsyscall_gtod.o
 obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
 obj-$(CONFIG_SYSFS)	+= ksysfs.o
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index da85a8e..e4b86ab 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -752,9 +752,7 @@ static struct clocksource clocksource_hpet = {
 	.mask		= HPET_MASK,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_resume_counter,
-#ifdef CONFIG_X86_64
 	.archdata	= { .vclock_mode = VCLOCK_HPET },
-#endif
 };
 
 static int hpet_clocksource_register(void)
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index cfbe99f..227dcfc 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -985,9 +985,7 @@ static struct clocksource clocksource_tsc = {
 	.mask                   = CLOCKSOURCE_MASK(64),
 	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
-#ifdef CONFIG_X86_64
 	.archdata               = { .vclock_mode = VCLOCK_TSC },
-#endif
 };
 
 void mark_tsc_unstable(char *reason)
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index da6b35a..49edf2d 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -147,7 +147,6 @@ SECTIONS
 		_edata = .;
 	} :data
 
-#ifdef CONFIG_X86_64
 
 	. = ALIGN(PAGE_SIZE);
 	__vvar_page = .;
@@ -165,12 +164,15 @@ SECTIONS
 #undef __VVAR_KERNEL_LDS
 #undef EMIT_VVAR
 
+		/*
+		 * Pad the rest of the page with zeros.  Otherwise the loader
+		 * can leave garbage here.
+		 */
+		. = __vvar_beginning_hack + PAGE_SIZE;
 	} :data
 
        . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
 
-#endif /* CONFIG_X86_64 */
-
 	/* Init code and data - will be freed after init */
 	. = ALIGN(PAGE_SIZE);
 	.init.begin : AT(ADDR(.init.begin) - LOAD_OFFSET) {
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 1f96f93..9ea2876 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -47,14 +47,12 @@
 #include <asm/segment.h>
 #include <asm/desc.h>
 #include <asm/topology.h>
-#include <asm/vgtod.h>
 #include <asm/traps.h>
 
 #define CREATE_TRACE_POINTS
 #include "vsyscall_trace.h"
 
 DEFINE_VVAR(int, vgetcpu_mode);
-DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
 
 static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
 
@@ -77,48 +75,6 @@ static int __init vsyscall_setup(char *str)
 }
 early_param("vsyscall", vsyscall_setup);
 
-void update_vsyscall_tz(void)
-{
-	vsyscall_gtod_data.sys_tz = sys_tz;
-}
-
-void update_vsyscall(struct timekeeper *tk)
-{
-	struct vsyscall_gtod_data *vdata = &vsyscall_gtod_data;
-
-	write_seqcount_begin(&vdata->seq);
-
-	/* copy vsyscall data */
-	vdata->clock.vclock_mode	= tk->clock->archdata.vclock_mode;
-	vdata->clock.cycle_last		= tk->clock->cycle_last;
-	vdata->clock.mask		= tk->clock->mask;
-	vdata->clock.mult		= tk->mult;
-	vdata->clock.shift		= tk->shift;
-
-	vdata->wall_time_sec		= tk->xtime_sec;
-	vdata->wall_time_snsec		= tk->xtime_nsec;
-
-	vdata->monotonic_time_sec	= tk->xtime_sec
-					+ tk->wall_to_monotonic.tv_sec;
-	vdata->monotonic_time_snsec	= tk->xtime_nsec
-					+ (tk->wall_to_monotonic.tv_nsec
-						<< tk->shift);
-	while (vdata->monotonic_time_snsec >=
-					(((u64)NSEC_PER_SEC) << tk->shift)) {
-		vdata->monotonic_time_snsec -=
-					((u64)NSEC_PER_SEC) << tk->shift;
-		vdata->monotonic_time_sec++;
-	}
-
-	vdata->wall_time_coarse.tv_sec	= tk->xtime_sec;
-	vdata->wall_time_coarse.tv_nsec	= (long)(tk->xtime_nsec >> tk->shift);
-
-	vdata->monotonic_time_coarse	= timespec_add(vdata->wall_time_coarse,
-							tk->wall_to_monotonic);
-
-	write_seqcount_end(&vdata->seq);
-}
-
 static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 			      const char *message)
 {
@@ -374,7 +330,6 @@ void __init map_vsyscall(void)
 {
 	extern char __vsyscall_page;
 	unsigned long physaddr_vsyscall = __pa_symbol(&__vsyscall_page);
-	extern char __vvar_page;
 	unsigned long physaddr_vvar_page = __pa_symbol(&__vvar_page);
 
 	__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_vsyscall,
diff --git a/arch/x86/kernel/vsyscall_gtod.c b/arch/x86/kernel/vsyscall_gtod.c
new file mode 100644
index 0000000..f9c6e56
--- /dev/null
+++ b/arch/x86/kernel/vsyscall_gtod.c
@@ -0,0 +1,69 @@
+/*
+ *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
+ *  Copyright 2003 Andi Kleen, SuSE Labs.
+ *
+ *  Modified for x86 32 bit architecture by
+ *  Stefani Seibold <stefani@seibold.net>
+ *  sponsored by Rohde & Schwarz GmbH & Co. KG Munich/Germany
+ *
+ *  Thanks to hpa@transmeta.com for some useful hint.
+ *  Special thanks to Ingo Molnar for his early experience with
+ *  a different vsyscall implementation for Linux/IA32 and for the name.
+ *
+ */
+
+#include <linux/timekeeper_internal.h>
+#include <asm/vgtod.h>
+#include <asm/vvar.h>
+
+DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
+
+void update_vsyscall_tz(void)
+{
+	vsyscall_gtod_data.tz_minuteswest = sys_tz.tz_minuteswest;
+	vsyscall_gtod_data.tz_dsttime = sys_tz.tz_dsttime;
+}
+
+void update_vsyscall(struct timekeeper *tk)
+{
+	struct vsyscall_gtod_data *vdata = &vsyscall_gtod_data;
+
+	gtod_write_begin(vdata);
+
+	/* copy vsyscall data */
+	vdata->vclock_mode	= tk->clock->archdata.vclock_mode;
+	vdata->cycle_last	= tk->clock->cycle_last;
+	vdata->mask		= tk->clock->mask;
+	vdata->mult		= tk->mult;
+	vdata->shift		= tk->shift;
+
+	vdata->wall_time_sec		= tk->xtime_sec;
+	vdata->wall_time_snsec		= tk->xtime_nsec;
+
+	vdata->monotonic_time_sec	= tk->xtime_sec
+					+ tk->wall_to_monotonic.tv_sec;
+	vdata->monotonic_time_snsec	= tk->xtime_nsec
+					+ (tk->wall_to_monotonic.tv_nsec
+						<< tk->shift);
+	while (vdata->monotonic_time_snsec >=
+					(((u64)NSEC_PER_SEC) << tk->shift)) {
+		vdata->monotonic_time_snsec -=
+					((u64)NSEC_PER_SEC) << tk->shift;
+		vdata->monotonic_time_sec++;
+	}
+
+	vdata->wall_time_coarse_sec	= tk->xtime_sec;
+	vdata->wall_time_coarse_nsec	= (long)(tk->xtime_nsec >> tk->shift);
+
+	vdata->monotonic_time_coarse_sec =
+		vdata->wall_time_coarse_sec + tk->wall_to_monotonic.tv_sec;
+	vdata->monotonic_time_coarse_nsec =
+		vdata->wall_time_coarse_nsec + tk->wall_to_monotonic.tv_nsec;
+
+	while (vdata->monotonic_time_coarse_nsec >= NSEC_PER_SEC) {
+		vdata->monotonic_time_coarse_nsec -= NSEC_PER_SEC;
+		vdata->monotonic_time_coarse_sec++;
+	}
+
+	gtod_write_end(vdata);
+}
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index cfbdbdb..bbb1d22 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -69,8 +69,8 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"__per_cpu_load|"
 	"init_per_cpu__.*|"
 	"__end_rodata_hpage_align|"
-	"__vvar_page|"
 #endif
+	"__vvar_page|"
 	"_end)$"
 };
 
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index fd14be1..6e6361a 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -21,7 +21,8 @@ vobjs-$(VDSOX32-y) += $(vobjx32s-compat)
 vobj64s := $(filter-out $(vobjx32s-compat),$(vobjs-y))
 
 # files to link into kernel
-obj-$(VDSO64-y)			+= vma.o vdso.o
+obj-y				+= vma.o
+obj-$(VDSO64-y)			+= vdso.o
 obj-$(VDSOX32-y)		+= vdsox32.o
 obj-$(VDSO32-y)			+= vdso32.o vdso32-setup.o
 
@@ -135,7 +136,7 @@ override obj-dirs = $(dir $(obj)) $(obj)/vdso32/
 
 targets += vdso32/vdso32.lds
 targets += $(vdso32-images) $(vdso32-images:=.dbg)
-targets += vdso32/note.o $(vdso32.so-y:%=vdso32/%.o)
+targets += vdso32/note.o vdso32/vclock_gettime.o $(vdso32.so-y:%=vdso32/%.o)
 
 extra-y	+= $(vdso32-images)
 
@@ -145,8 +146,19 @@ KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS))
 $(vdso32-images:%=$(obj)/%.dbg): KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
 $(vdso32-images:%=$(obj)/%.dbg): asflags-$(CONFIG_X86_64) += -m32
 
+KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_32 := $(filter-out -mcmodel=kernel,$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 := $(filter-out -mfentry,$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=0 -fpic
+KBUILD_CFLAGS_32 += $(call cc-option, -fno-stack-protector)
+KBUILD_CFLAGS_32 += $(call cc-option, -foptimize-sibling-calls)
+KBUILD_CFLAGS_32 += -fno-omit-frame-pointer
+$(vdso32-images:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
+
 $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
 				 $(obj)/vdso32/vdso32.lds \
+				 $(obj)/vdso32/vclock_gettime.o \
 				 $(obj)/vdso32/note.o \
 				 $(obj)/vdso32/%.o
 	$(call if_changed,vdso)
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index eb5d7a5..16d6861 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -4,6 +4,9 @@
  *
  * Fast user context implementation of clock_gettime, gettimeofday, and time.
  *
+ * 32 Bit compat layer by Stefani Seibold <stefani@seibold.net>
+ *  sponsored by Rohde & Schwarz GmbH & Co. KG Munich/Germany
+ *
  * The code should have no internal unresolved relocations.
  * Check with readelf after changing.
  */
@@ -11,56 +14,55 @@
 /* Disable profiling for userspace code: */
 #define DISABLE_BRANCH_PROFILING
 
-#include <linux/kernel.h>
-#include <linux/posix-timers.h>
-#include <linux/time.h>
-#include <linux/string.h>
-#include <asm/vsyscall.h>
-#include <asm/fixmap.h>
+#include <uapi/linux/time.h>
 #include <asm/vgtod.h>
-#include <asm/timex.h>
 #include <asm/hpet.h>
+#include <asm/vvar.h>
 #include <asm/unistd.h>
-#include <asm/io.h>
-#include <asm/pvclock.h>
+#include <asm/msr.h>
+#include <linux/math64.h>
+#include <linux/time.h>
 
 #define gtod (&VVAR(vsyscall_gtod_data))
 
-notrace static cycle_t vread_tsc(void)
+extern int __vdso_clock_gettime(clockid_t clock, struct timespec *ts);
+extern int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz);
+extern time_t __vdso_time(time_t *t);
+
+#ifdef CONFIG_HPET_TIMER
+static inline u32 read_hpet_counter(const volatile void *addr)
 {
-	cycle_t ret;
-	u64 last;
+	return *(const volatile u32 *) (addr + HPET_COUNTER);
+}
+#endif
 
-	/*
-	 * Empirically, a fence (of type that depends on the CPU)
-	 * before rdtsc is enough to ensure that rdtsc is ordered
-	 * with respect to loads.  The various CPU manuals are unclear
-	 * as to whether rdtsc can be reordered with later loads,
-	 * but no one has ever seen it happen.
-	 */
-	rdtsc_barrier();
-	ret = (cycle_t)vget_cycles();
+#ifndef BUILD_VDSO32
 
-	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
+#include <linux/kernel.h>
+#include <asm/vsyscall.h>
+#include <asm/fixmap.h>
+#include <asm/pvclock.h>
 
-	if (likely(ret >= last))
-		return ret;
+static notrace cycle_t vread_hpet(void)
+{
+	return read_hpet_counter((const void *)fix_to_virt(VSYSCALL_HPET));
+}
 
-	/*
-	 * GCC likes to generate cmov here, but this branch is extremely
-	 * predictable (it's just a funciton of time and the likely is
-	 * very likely) and there's a data dependence, so force GCC
-	 * to generate a branch instead.  I don't barrier() because
-	 * we don't actually need a barrier, and if this function
-	 * ever gets inlined it will generate worse code.
-	 */
-	asm volatile ("");
-	return last;
+notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
+{
+	long ret;
+	asm("syscall" : "=a" (ret) :
+	    "0" (__NR_clock_gettime), "D" (clock), "S" (ts) : "memory");
+	return ret;
 }
 
-static notrace cycle_t vread_hpet(void)
+notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
 {
-	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
+	long ret;
+
+	asm("syscall" : "=a" (ret) :
+	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+	return ret;
 }
 
 #ifdef CONFIG_PARAVIRT_CLOCK
@@ -124,7 +126,7 @@ static notrace cycle_t vread_pvclock(int *mode)
 		*mode = VCLOCK_NONE;
 
 	/* refer to tsc.c read_tsc() comment for rationale */
-	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
+	last = gtod->cycle_last;
 
 	if (likely(ret >= last))
 		return ret;
@@ -133,11 +135,30 @@ static notrace cycle_t vread_pvclock(int *mode)
 }
 #endif
 
+#else
+
+extern u8 hpet_page
+	__attribute__((visibility("hidden")));
+
+#ifdef CONFIG_HPET_TIMER
+static notrace cycle_t vread_hpet(void)
+{
+	return read_hpet_counter((const void *)(&hpet_page));
+}
+#endif
+
 notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
 	long ret;
-	asm("syscall" : "=a" (ret) :
-	    "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
+
+	asm(
+		"mov %%ebx, %%edx \n"
+		"mov %2, %%ebx \n"
+		"call VDSO32_vsyscall \n"
+		"mov %%edx, %%ebx \n"
+		: "=a" (ret)
+		: "0" (__NR_clock_gettime), "g" (clock), "c" (ts)
+		: "memory", "edx");
 	return ret;
 }
 
@@ -145,28 +166,79 @@ notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
 {
 	long ret;
 
-	asm("syscall" : "=a" (ret) :
-	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+	asm(
+		"mov %%ebx, %%edx \n"
+		"mov %2, %%ebx \n"
+		"call VDSO32_vsyscall \n"
+		"mov %%edx, %%ebx \n"
+		: "=a" (ret)
+		: "0" (__NR_gettimeofday), "g" (tv), "c" (tz)
+		: "memory", "edx");
 	return ret;
 }
 
+#ifdef CONFIG_PARAVIRT_CLOCK
+
+static notrace cycle_t vread_pvclock(int *mode)
+{
+	*mode = VCLOCK_NONE;
+	return 0;
+}
+#endif
+
+#endif
+
+notrace static cycle_t vread_tsc(void)
+{
+	cycle_t ret;
+	u64 last;
+
+	/*
+	 * Empirically, a fence (of type that depends on the CPU)
+	 * before rdtsc is enough to ensure that rdtsc is ordered
+	 * with respect to loads.  The various CPU manuals are unclear
+	 * as to whether rdtsc can be reordered with later loads,
+	 * but no one has ever seen it happen.
+	 */
+	rdtsc_barrier();
+	ret = (cycle_t)__native_read_tsc();
+
+	last = gtod->cycle_last;
+
+	if (likely(ret >= last))
+		return ret;
+
+	/*
+	 * GCC likes to generate cmov here, but this branch is extremely
+	 * predictable (it's just a funciton of time and the likely is
+	 * very likely) and there's a data dependence, so force GCC
+	 * to generate a branch instead.  I don't barrier() because
+	 * we don't actually need a barrier, and if this function
+	 * ever gets inlined it will generate worse code.
+	 */
+	asm volatile ("");
+	return last;
+}
 
 notrace static inline u64 vgetsns(int *mode)
 {
-	long v;
+	u64 v;
 	cycles_t cycles;
-	if (gtod->clock.vclock_mode == VCLOCK_TSC)
+
+	if (gtod->vclock_mode == VCLOCK_TSC)
 		cycles = vread_tsc();
-	else if (gtod->clock.vclock_mode == VCLOCK_HPET)
+#ifdef CONFIG_HPET_TIMER
+	else if (gtod->vclock_mode == VCLOCK_HPET)
 		cycles = vread_hpet();
+#endif
 #ifdef CONFIG_PARAVIRT_CLOCK
-	else if (gtod->clock.vclock_mode == VCLOCK_PVCLOCK)
+	else if (gtod->vclock_mode == VCLOCK_PVCLOCK)
 		cycles = vread_pvclock(mode);
 #endif
 	else
 		return 0;
-	v = (cycles - gtod->clock.cycle_last) & gtod->clock.mask;
-	return v * gtod->clock.mult;
+	v = (cycles - gtod->cycle_last) & gtod->mask;
+	return v * gtod->mult;
 }
 
 /* Code size doesn't matter (vdso is 4k anyway) and this is faster. */
@@ -176,106 +248,102 @@ notrace static int __always_inline do_realtime(struct timespec *ts)
 	u64 ns;
 	int mode;
 
-	ts->tv_nsec = 0;
 	do {
-		seq = raw_read_seqcount_begin(&gtod->seq);
-		mode = gtod->clock.vclock_mode;
+		seq = gtod_read_begin(gtod);
+		mode = gtod->vclock_mode;
 		ts->tv_sec = gtod->wall_time_sec;
 		ns = gtod->wall_time_snsec;
 		ns += vgetsns(&mode);
-		ns >>= gtod->clock.shift;
-	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
+		ns >>= gtod->shift;
+	} while (unlikely(gtod_read_retry(gtod, seq)));
+
+	ts->tv_sec += __iter_div_u64_rem(ns, NSEC_PER_SEC, &ns);
+	ts->tv_nsec = ns;
 
-	timespec_add_ns(ts, ns);
 	return mode;
 }
 
-notrace static int do_monotonic(struct timespec *ts)
+notrace static int __always_inline do_monotonic(struct timespec *ts)
 {
 	unsigned long seq;
 	u64 ns;
 	int mode;
 
-	ts->tv_nsec = 0;
 	do {
-		seq = raw_read_seqcount_begin(&gtod->seq);
-		mode = gtod->clock.vclock_mode;
+		seq = gtod_read_begin(gtod);
+		mode = gtod->vclock_mode;
 		ts->tv_sec = gtod->monotonic_time_sec;
 		ns = gtod->monotonic_time_snsec;
 		ns += vgetsns(&mode);
-		ns >>= gtod->clock.shift;
-	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
-	timespec_add_ns(ts, ns);
+		ns >>= gtod->shift;
+	} while (unlikely(gtod_read_retry(gtod, seq)));
+
+	ts->tv_sec += __iter_div_u64_rem(ns, NSEC_PER_SEC, &ns);
+	ts->tv_nsec = ns;
 
 	return mode;
 }
 
-notrace static int do_realtime_coarse(struct timespec *ts)
+notrace static void do_realtime_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
-		seq = raw_read_seqcount_begin(&gtod->seq);
-		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
-		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
-	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
-	return 0;
+		seq = gtod_read_begin(gtod);
+		ts->tv_sec = gtod->wall_time_coarse_sec;
+		ts->tv_nsec = gtod->wall_time_coarse_nsec;
+	} while (unlikely(gtod_read_retry(gtod, seq)));
 }
 
-notrace static int do_monotonic_coarse(struct timespec *ts)
+notrace static void do_monotonic_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
-		seq = raw_read_seqcount_begin(&gtod->seq);
-		ts->tv_sec = gtod->monotonic_time_coarse.tv_sec;
-		ts->tv_nsec = gtod->monotonic_time_coarse.tv_nsec;
-	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
-
-	return 0;
+		seq = gtod_read_begin(gtod);
+		ts->tv_sec = gtod->monotonic_time_coarse_sec;
+		ts->tv_nsec = gtod->monotonic_time_coarse_nsec;
+	} while (unlikely(gtod_read_retry(gtod, seq)));
 }
 
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
-	int ret = VCLOCK_NONE;
-
 	switch (clock) {
 	case CLOCK_REALTIME:
-		ret = do_realtime(ts);
+		if (do_realtime(ts) == VCLOCK_NONE)
+			goto fallback;
 		break;
 	case CLOCK_MONOTONIC:
-		ret = do_monotonic(ts);
+		if (do_monotonic(ts) == VCLOCK_NONE)
+			goto fallback;
 		break;
 	case CLOCK_REALTIME_COARSE:
-		return do_realtime_coarse(ts);
+		do_realtime_coarse(ts);
+		break;
 	case CLOCK_MONOTONIC_COARSE:
-		return do_monotonic_coarse(ts);
+		do_monotonic_coarse(ts);
+		break;
+	default:
+		goto fallback;
 	}
 
-	if (ret == VCLOCK_NONE)
-		return vdso_fallback_gettime(clock, ts);
 	return 0;
+fallback:
+	return vdso_fallback_gettime(clock, ts);
 }
 int clock_gettime(clockid_t, struct timespec *)
 	__attribute__((weak, alias("__vdso_clock_gettime")));
 
 notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
-	long ret = VCLOCK_NONE;
-
 	if (likely(tv != NULL)) {
-		BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
-			     offsetof(struct timespec, tv_nsec) ||
-			     sizeof(*tv) != sizeof(struct timespec));
-		ret = do_realtime((struct timespec *)tv);
+		if (unlikely(do_realtime((struct timespec *)tv) == VCLOCK_NONE))
+			return vdso_fallback_gtod(tv, tz);
 		tv->tv_usec /= 1000;
 	}
 	if (unlikely(tz != NULL)) {
-		/* Avoid memcpy. Some old compilers fail to inline it */
-		tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
-		tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
+		tz->tz_minuteswest = gtod->tz_minuteswest;
+		tz->tz_dsttime = gtod->tz_dsttime;
 	}
 
-	if (ret == VCLOCK_NONE)
-		return vdso_fallback_gtod(tv, tz);
 	return 0;
 }
 int gettimeofday(struct timeval *, struct timezone *)
@@ -287,8 +355,8 @@ int gettimeofday(struct timeval *, struct timezone *)
  */
 notrace time_t __vdso_time(time_t *t)
 {
-	/* This is atomic on x86_64 so we don't need any locks. */
-	time_t result = ACCESS_ONCE(VVAR(vsyscall_gtod_data).wall_time_sec);
+	/* This is atomic on x86 so we don't need any locks. */
+	time_t result = ACCESS_ONCE(gtod->wall_time_sec);
 
 	if (t)
 		*t = result;
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 634a2cf..2e263f3 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -6,7 +6,25 @@
 
 SECTIONS
 {
-	. = VDSO_PRELINK + SIZEOF_HEADERS;
+#ifdef BUILD_VDSO32
+#include <asm/vdso32.h>
+
+	.hpet_sect : {
+		hpet_page = . - VDSO_OFFSET(VDSO_HPET_PAGE);
+	} :text :hpet_sect
+
+	.vvar_sect : {
+		vvar = . - VDSO_OFFSET(VDSO_VVAR_PAGE);
+
+	/* Place all vvars at the offsets in asm/vvar.h. */
+#define EMIT_VVAR(name, offset) vvar_ ## name = vvar + offset;
+#define __VVAR_KERNEL_LDS
+#include <asm/vvar.h>
+#undef __VVAR_KERNEL_LDS
+#undef EMIT_VVAR
+	} :text :vvar_sect
+#endif
+	. = SIZEOF_HEADERS;
 
 	.hash		: { *(.hash) }			:text
 	.gnu.hash	: { *(.gnu.hash) }
@@ -44,6 +62,11 @@ SECTIONS
 	. = ALIGN(0x100);
 
 	.text		: { *(.text*) }			:text	=0x90909090
+
+	/DISCARD/ : {
+		*(.discard)
+		*(.discard.*)
+	}
 }
 
 /*
@@ -61,4 +84,8 @@ PHDRS
 	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
 	note		PT_NOTE		FLAGS(4);		/* PF_R */
 	eh_frame_hdr	PT_GNU_EH_FRAME;
+#ifdef BUILD_VDSO32
+	vvar_sect	PT_NULL		FLAGS(4);		/* PF_R */
+	hpet_sect	PT_NULL		FLAGS(4);		/* PF_R */
+#endif
 }
diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
index 1e13eb8..be3f23b 100644
--- a/arch/x86/vdso/vdso.S
+++ b/arch/x86/vdso/vdso.S
@@ -1,21 +1,3 @@
-#include <asm/page_types.h>
-#include <linux/linkage.h>
+#include <asm/vdso.h>
 
-__PAGE_ALIGNED_DATA
-
-	.globl vdso_start, vdso_end
-	.align PAGE_SIZE
-vdso_start:
-	.incbin "arch/x86/vdso/vdso.so"
-vdso_end:
-	.align PAGE_SIZE /* extra data here leaks to userspace. */
-
-.previous
-
-	.globl vdso_pages
-	.bss
-	.align 8
-	.type vdso_pages, @object
-vdso_pages:
-	.zero (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE * 8
-	.size vdso_pages, .-vdso_pages
+DEFINE_VDSO_IMAGE(vdso, "arch/x86/vdso/vdso.so")
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index d6bfb87..0034898 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #include <asm/cpufeature.h>
 #include <asm/msr.h>
@@ -25,17 +26,14 @@
 #include <asm/tlbflush.h>
 #include <asm/vdso.h>
 #include <asm/proto.h>
-
-enum {
-	VDSO_DISABLED = 0,
-	VDSO_ENABLED = 1,
-	VDSO_COMPAT = 2,
-};
+#include <asm/fixmap.h>
+#include <asm/hpet.h>
+#include <asm/vvar.h>
 
 #ifdef CONFIG_COMPAT_VDSO
-#define VDSO_DEFAULT	VDSO_COMPAT
+#define VDSO_DEFAULT	0
 #else
-#define VDSO_DEFAULT	VDSO_ENABLED
+#define VDSO_DEFAULT	1
 #endif
 
 #ifdef CONFIG_X86_64
@@ -44,13 +42,6 @@ enum {
 #endif
 
 /*
- * This is the difference between the prelinked addresses in the vDSO images
- * and the VDSO_HIGH_BASE address where CONFIG_COMPAT_VDSO places the vDSO
- * in the user address space.
- */
-#define VDSO_ADDR_ADJUST	(VDSO_HIGH_BASE - (unsigned long)VDSO32_PRELINK)
-
-/*
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
  */
@@ -60,6 +51,9 @@ static int __init vdso_setup(char *s)
 {
 	vdso_enabled = simple_strtoul(s, NULL, 0);
 
+	if (vdso_enabled > 1)
+		pr_warn("vdso32 values other than 0 and 1 are no longer allowed; vdso disabled\n");
+
 	return 1;
 }
 
@@ -76,124 +70,8 @@ __setup_param("vdso=", vdso32_setup, vdso_setup, 0);
 EXPORT_SYMBOL_GPL(vdso_enabled);
 #endif
 
-static __init void reloc_symtab(Elf32_Ehdr *ehdr,
-				unsigned offset, unsigned size)
-{
-	Elf32_Sym *sym = (void *)ehdr + offset;
-	unsigned nsym = size / sizeof(*sym);
-	unsigned i;
-
-	for(i = 0; i < nsym; i++, sym++) {
-		if (sym->st_shndx == SHN_UNDEF ||
-		    sym->st_shndx == SHN_ABS)
-			continue;  /* skip */
-
-		if (sym->st_shndx > SHN_LORESERVE) {
-			printk(KERN_INFO "VDSO: unexpected st_shndx %x\n",
-			       sym->st_shndx);
-			continue;
-		}
-
-		switch(ELF_ST_TYPE(sym->st_info)) {
-		case STT_OBJECT:
-		case STT_FUNC:
-		case STT_SECTION:
-		case STT_FILE:
-			sym->st_value += VDSO_ADDR_ADJUST;
-		}
-	}
-}
-
-static __init void reloc_dyn(Elf32_Ehdr *ehdr, unsigned offset)
-{
-	Elf32_Dyn *dyn = (void *)ehdr + offset;
-
-	for(; dyn->d_tag != DT_NULL; dyn++)
-		switch(dyn->d_tag) {
-		case DT_PLTGOT:
-		case DT_HASH:
-		case DT_STRTAB:
-		case DT_SYMTAB:
-		case DT_RELA:
-		case DT_INIT:
-		case DT_FINI:
-		case DT_REL:
-		case DT_DEBUG:
-		case DT_JMPREL:
-		case DT_VERSYM:
-		case DT_VERDEF:
-		case DT_VERNEED:
-		case DT_ADDRRNGLO ... DT_ADDRRNGHI:
-			/* definitely pointers needing relocation */
-			dyn->d_un.d_ptr += VDSO_ADDR_ADJUST;
-			break;
-
-		case DT_ENCODING ... OLD_DT_LOOS-1:
-		case DT_LOOS ... DT_HIOS-1:
-			/* Tags above DT_ENCODING are pointers if
-			   they're even */
-			if (dyn->d_tag >= DT_ENCODING &&
-			    (dyn->d_tag & 1) == 0)
-				dyn->d_un.d_ptr += VDSO_ADDR_ADJUST;
-			break;
-
-		case DT_VERDEFNUM:
-		case DT_VERNEEDNUM:
-		case DT_FLAGS_1:
-		case DT_RELACOUNT:
-		case DT_RELCOUNT:
-		case DT_VALRNGLO ... DT_VALRNGHI:
-			/* definitely not pointers */
-			break;
-
-		case OLD_DT_LOOS ... DT_LOOS-1:
-		case DT_HIOS ... DT_VALRNGLO-1:
-		default:
-			if (dyn->d_tag > DT_ENCODING)
-				printk(KERN_INFO "VDSO: unexpected DT_tag %x\n",
-				       dyn->d_tag);
-			break;
-		}
-}
-
-static __init void relocate_vdso(Elf32_Ehdr *ehdr)
-{
-	Elf32_Phdr *phdr;
-	Elf32_Shdr *shdr;
-	int i;
-
-	BUG_ON(memcmp(ehdr->e_ident, ELFMAG, SELFMAG) != 0 ||
-	       !elf_check_arch_ia32(ehdr) ||
-	       ehdr->e_type != ET_DYN);
-
-	ehdr->e_entry += VDSO_ADDR_ADJUST;
-
-	/* rebase phdrs */
-	phdr = (void *)ehdr + ehdr->e_phoff;
-	for (i = 0; i < ehdr->e_phnum; i++) {
-		phdr[i].p_vaddr += VDSO_ADDR_ADJUST;
-
-		/* relocate dynamic stuff */
-		if (phdr[i].p_type == PT_DYNAMIC)
-			reloc_dyn(ehdr, phdr[i].p_offset);
-	}
-
-	/* rebase sections */
-	shdr = (void *)ehdr + ehdr->e_shoff;
-	for(i = 0; i < ehdr->e_shnum; i++) {
-		if (!(shdr[i].sh_flags & SHF_ALLOC))
-			continue;
-
-		shdr[i].sh_addr += VDSO_ADDR_ADJUST;
-
-		if (shdr[i].sh_type == SHT_SYMTAB ||
-		    shdr[i].sh_type == SHT_DYNSYM)
-			reloc_symtab(ehdr, shdr[i].sh_offset,
-				     shdr[i].sh_size);
-	}
-}
-
-static struct page *vdso32_pages[1];
+static struct page **vdso32_pages;
+static unsigned vdso32_size;
 
 #ifdef CONFIG_X86_64
 
@@ -212,12 +90,6 @@ void syscall32_cpu_init(void)
 	wrmsrl(MSR_CSTAR, ia32_cstar_target);
 }
 
-#define compat_uses_vma		1
-
-static inline void map_compat_vdso(int map)
-{
-}
-
 #else  /* CONFIG_X86_32 */
 
 #define vdso32_sysenter()	(boot_cpu_has(X86_FEATURE_SEP))
@@ -241,64 +113,36 @@ void enable_sep_cpu(void)
 	put_cpu();	
 }
 
-static struct vm_area_struct gate_vma;
-
-static int __init gate_vma_init(void)
-{
-	gate_vma.vm_mm = NULL;
-	gate_vma.vm_start = FIXADDR_USER_START;
-	gate_vma.vm_end = FIXADDR_USER_END;
-	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
-	gate_vma.vm_page_prot = __P101;
-
-	return 0;
-}
-
-#define compat_uses_vma		0
-
-static void map_compat_vdso(int map)
-{
-	static int vdso_mapped;
-
-	if (map == vdso_mapped)
-		return;
-
-	vdso_mapped = map;
-
-	__set_fixmap(FIX_VDSO, page_to_pfn(vdso32_pages[0]) << PAGE_SHIFT,
-		     map ? PAGE_READONLY_EXEC : PAGE_NONE);
-
-	/* flush stray tlbs */
-	flush_tlb_all();
-}
-
 #endif	/* CONFIG_X86_64 */
 
 int __init sysenter_setup(void)
 {
-	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
-	const void *vsyscall;
-	size_t vsyscall_len;
-
-	vdso32_pages[0] = virt_to_page(syscall_page);
-
-#ifdef CONFIG_X86_32
-	gate_vma_init();
-#endif
+	char *vdso32_start, *vdso32_end;
+	int npages, i;
 
+#ifdef CONFIG_COMPAT
 	if (vdso32_syscall()) {
-		vsyscall = &vdso32_syscall_start;
-		vsyscall_len = &vdso32_syscall_end - &vdso32_syscall_start;
-	} else if (vdso32_sysenter()){
-		vsyscall = &vdso32_sysenter_start;
-		vsyscall_len = &vdso32_sysenter_end - &vdso32_sysenter_start;
+		vdso32_start = vdso32_syscall_start;
+		vdso32_end = vdso32_syscall_end;
+		vdso32_pages = vdso32_syscall_pages;
+	} else
+#endif
+	if (vdso32_sysenter()) {
+		vdso32_start = vdso32_sysenter_start;
+		vdso32_end = vdso32_sysenter_end;
+		vdso32_pages = vdso32_sysenter_pages;
 	} else {
-		vsyscall = &vdso32_int80_start;
-		vsyscall_len = &vdso32_int80_end - &vdso32_int80_start;
+		vdso32_start = vdso32_int80_start;
+		vdso32_end = vdso32_int80_end;
+		vdso32_pages = vdso32_int80_pages;
 	}
 
-	memcpy(syscall_page, vsyscall, vsyscall_len);
-	relocate_vdso(syscall_page);
+	npages = ((vdso32_end - vdso32_start) + PAGE_SIZE - 1) / PAGE_SIZE;
+	vdso32_size = npages << PAGE_SHIFT;
+	for (i = 0; i < npages; i++)
+		vdso32_pages[i] = virt_to_page(vdso32_start + i*PAGE_SIZE);
+
+	patch_vdso32(vdso32_start, vdso32_size);
 
 	return 0;
 }
@@ -309,48 +153,73 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
 	int ret = 0;
-	bool compat;
+	struct vm_area_struct *vma;
 
 #ifdef CONFIG_X86_X32_ABI
 	if (test_thread_flag(TIF_X32))
 		return x32_setup_additional_pages(bprm, uses_interp);
 #endif
 
-	if (vdso_enabled == VDSO_DISABLED)
+	if (vdso_enabled != 1)  /* Other values all mean "disabled" */
 		return 0;
 
 	down_write(&mm->mmap_sem);
 
-	/* Test compat mode once here, in case someone
-	   changes it via sysctl */
-	compat = (vdso_enabled == VDSO_COMPAT);
+	addr = get_unmapped_area(NULL, 0, vdso32_size + VDSO_OFFSET(VDSO_PREV_PAGES), 0, 0);
+	if (IS_ERR_VALUE(addr)) {
+		ret = addr;
+		goto up_fail;
+	}
+
+	addr += VDSO_OFFSET(VDSO_PREV_PAGES);
 
-	map_compat_vdso(compat);
+	current->mm->context.vdso = (void *)addr;
 
-	if (compat)
-		addr = VDSO_HIGH_BASE;
-	else {
-		addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
-		if (IS_ERR_VALUE(addr)) {
-			ret = addr;
-			goto up_fail;
-		}
+	/*
+	 * MAYWRITE to allow gdb to COW and set breakpoints
+	 */
+	ret = install_special_mapping(mm,
+			addr,
+			vdso32_size,
+			VM_READ|VM_EXEC|
+			VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
+			vdso32_pages);
+
+	if (ret)
+		goto up_fail;
+
+	vma = _install_special_mapping(mm,
+			addr -  VDSO_OFFSET(VDSO_PREV_PAGES),
+			VDSO_OFFSET(VDSO_PREV_PAGES),
+			VM_READ,
+			NULL);
+
+	if (IS_ERR(vma)) {
+		ret = PTR_ERR(vma);
+		goto up_fail;
 	}
 
-	current->mm->context.vdso = (void *)addr;
+	ret = remap_pfn_range(vma,
+		addr - VDSO_OFFSET(VDSO_VVAR_PAGE),
+		__pa_symbol(&__vvar_page) >> PAGE_SHIFT,
+		PAGE_SIZE,
+		PAGE_READONLY);
+
+	if (ret)
+		goto up_fail;
 
-	if (compat_uses_vma || !compat) {
-		/*
-		 * MAYWRITE to allow gdb to COW and set breakpoints
-		 */
-		ret = install_special_mapping(mm, addr, PAGE_SIZE,
-					      VM_READ|VM_EXEC|
-					      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-					      vdso32_pages);
+#ifdef CONFIG_HPET_TIMER
+	if (hpet_address) {
+		ret = io_remap_pfn_range(vma,
+			addr - VDSO_OFFSET(VDSO_HPET_PAGE),
+			hpet_address >> PAGE_SHIFT,
+			PAGE_SIZE,
+			pgprot_noncached(PAGE_READONLY));
 
 		if (ret)
 			goto up_fail;
 	}
+#endif
 
 	current_thread_info()->sysenter_return =
 		VDSO32_SYMBOL(addr, SYSENTER_RETURN);
@@ -411,20 +280,12 @@ const char *arch_vma_name(struct vm_area_struct *vma)
 
 struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 {
-	/*
-	 * Check to see if the corresponding task was created in compat vdso
-	 * mode.
-	 */
-	if (mm && mm->context.vdso == (void *)VDSO_HIGH_BASE)
-		return &gate_vma;
 	return NULL;
 }
 
 int in_gate_area(struct mm_struct *mm, unsigned long addr)
 {
-	const struct vm_area_struct *vma = get_gate_vma(mm);
-
-	return vma && addr >= vma->vm_start && addr < vma->vm_end;
+	return 0;
 }
 
 int in_gate_area_no_mm(unsigned long addr)
diff --git a/arch/x86/vdso/vdso32.S b/arch/x86/vdso/vdso32.S
index 2ce5f82..018bcd9 100644
--- a/arch/x86/vdso/vdso32.S
+++ b/arch/x86/vdso/vdso32.S
@@ -1,22 +1,9 @@
-#include <linux/init.h>
+#include <asm/vdso.h>
 
-__INITDATA
+DEFINE_VDSO_IMAGE(vdso32_int80, "arch/x86/vdso/vdso32-int80.so")
 
-	.globl vdso32_int80_start, vdso32_int80_end
-vdso32_int80_start:
-	.incbin "arch/x86/vdso/vdso32-int80.so"
-vdso32_int80_end:
-
-	.globl vdso32_syscall_start, vdso32_syscall_end
-vdso32_syscall_start:
 #ifdef CONFIG_COMPAT
-	.incbin "arch/x86/vdso/vdso32-syscall.so"
+DEFINE_VDSO_IMAGE(vdso32_syscall, "arch/x86/vdso/vdso32-syscall.so")
 #endif
-vdso32_syscall_end:
-
-	.globl vdso32_sysenter_start, vdso32_sysenter_end
-vdso32_sysenter_start:
-	.incbin "arch/x86/vdso/vdso32-sysenter.so"
-vdso32_sysenter_end:
 
-__FINIT
+DEFINE_VDSO_IMAGE(vdso32_sysenter, "arch/x86/vdso/vdso32-sysenter.so")
diff --git a/arch/x86/vdso/vdso32/vclock_gettime.c b/arch/x86/vdso/vdso32/vclock_gettime.c
new file mode 100644
index 0000000..175cc72
--- /dev/null
+++ b/arch/x86/vdso/vdso32/vclock_gettime.c
@@ -0,0 +1,30 @@
+#define BUILD_VDSO32
+
+#ifndef CONFIG_CC_OPTIMIZE_FOR_SIZE
+#undef CONFIG_OPTIMIZE_INLINING
+#endif
+
+#undef CONFIG_X86_PPRO_FENCE
+
+#ifdef CONFIG_X86_64
+
+/*
+ * in case of a 32 bit VDSO for a 64 bit kernel fake a 32 bit kernel
+ * configuration
+ */
+#undef CONFIG_64BIT
+#undef CONFIG_X86_64
+#undef CONFIG_ILLEGAL_POINTER_VALUE
+#undef CONFIG_SPARSEMEM_VMEMMAP
+#undef CONFIG_NR_CPUS
+
+#define CONFIG_X86_32 1
+#define CONFIG_PAGE_OFFSET 0
+#define CONFIG_ILLEGAL_POINTER_VALUE 0
+#define CONFIG_NR_CPUS 1
+
+#define BUILD_VDSO32_64
+
+#endif
+
+#include "../vclock_gettime.c"
diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S b/arch/x86/vdso/vdso32/vdso32.lds.S
index 976124b..aadb8b9 100644
--- a/arch/x86/vdso/vdso32/vdso32.lds.S
+++ b/arch/x86/vdso/vdso32/vdso32.lds.S
@@ -8,7 +8,11 @@
  * values visible using the asm-x86/vdso.h macros from the kernel proper.
  */
 
+#include <asm/page.h>
+
+#define BUILD_VDSO32
 #define VDSO_PRELINK 0
+
 #include "../vdso-layout.lds.S"
 
 /* The ELF entry point can be used to set the AT_SYSINFO value.  */
@@ -19,6 +23,13 @@ ENTRY(__kernel_vsyscall);
  */
 VERSION
 {
+	LINUX_2.6 {
+	global:
+		__vdso_clock_gettime;
+		__vdso_gettimeofday;
+		__vdso_time;
+	};
+
 	LINUX_2.5 {
 	global:
 		__kernel_vsyscall;
@@ -31,7 +42,9 @@ VERSION
 /*
  * Symbols we define here called VDSO* get their values into vdso32-syms.h.
  */
-VDSO32_PRELINK		= VDSO_PRELINK;
 VDSO32_vsyscall		= __kernel_vsyscall;
 VDSO32_sigreturn	= __kernel_sigreturn;
 VDSO32_rt_sigreturn	= __kernel_rt_sigreturn;
+VDSO32_clock_gettime	= clock_gettime;
+VDSO32_gettimeofday	= gettimeofday;
+VDSO32_time		= time;
diff --git a/arch/x86/vdso/vdsox32.S b/arch/x86/vdso/vdsox32.S
index 295f1c7..f4aa34e 100644
--- a/arch/x86/vdso/vdsox32.S
+++ b/arch/x86/vdso/vdsox32.S
@@ -1,21 +1,3 @@
-#include <asm/page_types.h>
-#include <linux/linkage.h>
+#include <asm/vdso.h>
 
-__PAGE_ALIGNED_DATA
-
-	.globl vdsox32_start, vdsox32_end
-	.align PAGE_SIZE
-vdsox32_start:
-	.incbin "arch/x86/vdso/vdsox32.so"
-vdsox32_end:
-	.align PAGE_SIZE /* extra data here leaks to userspace. */
-
-.previous
-
-	.globl vdsox32_pages
-	.bss
-	.align 8
-	.type vdsox32_pages, @object
-vdsox32_pages:
-	.zero (vdsox32_end - vdsox32_start + PAGE_SIZE - 1) / PAGE_SIZE * 8
-	.size vdsox32_pages, .-vdsox32_pages
+DEFINE_VDSO_IMAGE(vdsox32, "arch/x86/vdso/vdsox32.so")
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 431e875..1ad1026 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -16,20 +16,22 @@
 #include <asm/vdso.h>
 #include <asm/page.h>
 
+#if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso_enabled = 1;
 
-extern char vdso_start[], vdso_end[];
+DECLARE_VDSO_IMAGE(vdso);
 extern unsigned short vdso_sync_cpuid;
-
-extern struct page *vdso_pages[];
 static unsigned vdso_size;
 
 #ifdef CONFIG_X86_X32_ABI
-extern char vdsox32_start[], vdsox32_end[];
-extern struct page *vdsox32_pages[];
+DECLARE_VDSO_IMAGE(vdsox32);
 static unsigned vdsox32_size;
+#endif
+#endif
 
-static void __init patch_vdsox32(void *vdso, size_t len)
+#if defined(CONFIG_X86_32) || defined(CONFIG_X86_X32_ABI) || \
+	defined(CONFIG_COMPAT)
+void __init patch_vdso32(void *vdso, size_t len)
 {
 	Elf32_Ehdr *hdr = vdso;
 	Elf32_Shdr *sechdrs, *alt_sec = 0;
@@ -52,7 +54,7 @@ static void __init patch_vdsox32(void *vdso, size_t len)
 	}
 
 	/* If we get here, it's probably a bug. */
-	pr_warning("patch_vdsox32: .altinstructions not found\n");
+	pr_warning("patch_vdso32: .altinstructions not found\n");
 	return;  /* nothing to patch */
 
 found:
@@ -61,6 +63,7 @@ found:
 }
 #endif
 
+#if defined(CONFIG_X86_64)
 static void __init patch_vdso64(void *vdso, size_t len)
 {
 	Elf64_Ehdr *hdr = vdso;
@@ -104,7 +107,7 @@ static int __init init_vdso(void)
 		vdso_pages[i] = virt_to_page(vdso_start + i*PAGE_SIZE);
 
 #ifdef CONFIG_X86_X32_ABI
-	patch_vdsox32(vdsox32_start, vdsox32_end - vdsox32_start);
+	patch_vdso32(vdsox32_start, vdsox32_end - vdsox32_start);
 	npages = (vdsox32_end - vdsox32_start + PAGE_SIZE - 1) / PAGE_SIZE;
 	vdsox32_size = npages << PAGE_SHIFT;
 	for (i = 0; i < npages; i++)
@@ -204,3 +207,4 @@ static __init int vdso_setup(char *s)
 	return 0;
 }
 __setup("vdso=", vdso_setup);
+#endif
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 256282e..21c6a42 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2058,7 +2058,6 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 	case FIX_RO_IDT:
 #ifdef CONFIG_X86_32
 	case FIX_WP_TEST:
-	case FIX_VDSO:
 # ifdef CONFIG_HIGHMEM
 	case FIX_KMAP_BEGIN ... FIX_KMAP_END:
 # endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c1b7414..6c7fedf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1750,6 +1750,9 @@ extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
 extern struct file *get_mm_exe_file(struct mm_struct *mm);
 
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
+extern struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
+				   unsigned long addr, unsigned long len,
+				   unsigned long flags, struct page **pages);
 extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
 				   unsigned long flags, struct page **pages);
diff --git a/mm/mmap.c b/mm/mmap.c
index 20ff0c3..81ba54f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2918,7 +2918,7 @@ static const struct vm_operations_struct special_mapping_vmops = {
  * The array pointer and the pages it points to are assumed to stay alive
  * for as long as this mapping might exist.
  */
-int install_special_mapping(struct mm_struct *mm,
+struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
 			    unsigned long addr, unsigned long len,
 			    unsigned long vm_flags, struct page **pages)
 {
@@ -2927,7 +2927,7 @@ int install_special_mapping(struct mm_struct *mm,
 
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (unlikely(vma == NULL))
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	vma->vm_mm = mm;
@@ -2948,11 +2948,23 @@ int install_special_mapping(struct mm_struct *mm,
 
 	perf_event_mmap(vma);
 
-	return 0;
+	return vma;
 
 out:
 	kmem_cache_free(vm_area_cachep, vma);
-	return ret;
+	return ERR_PTR(ret);
+}
+
+int install_special_mapping(struct mm_struct *mm,
+			    unsigned long addr, unsigned long len,
+			    unsigned long vm_flags, struct page **pages)
+{
+	struct vm_area_struct *vma = _install_special_mapping(mm,
+			    addr, len, vm_flags, pages);
+
+	if (IS_ERR(vma))
+		return PTR_ERR(vma);
+	return 0;
 }
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
