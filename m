Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355AbaBAPcf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 10:32:35 -0500
Received: from www84.your-server.de ([213.133.104.84]:56882 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242AbaBAPb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 10:31:56 -0500
From: stefani@seibold.net
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 3/4] Add 32 bit VDSO time support for 32 bit kernel
Date: Sat,  1 Feb 2014 16:32:35 +0100
Message-Id: <1391268756-10766-4-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391268756-10766-1-git-send-email-stefani@seibold.net>
References: <1391268756-10766-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch add the time support for 32 bit a VDSO to a 32 bit kernel.

For 32 bit programs running on a 32 bit kernel, the same mechanism is
used as for 64 bit programs running on a 64 bit kernel.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/include/asm/elf.h            |   2 +-
 arch/x86/include/asm/vdso.h           |   3 +
 arch/x86/include/asm/vdso32.h         |  10 +++
 arch/x86/vdso/Makefile                |   7 ++
 arch/x86/vdso/vclock_gettime.c        | 165 ++++++++++++++++++++++------------
 arch/x86/vdso/vdso-layout.lds.S       |  25 ++++++
 arch/x86/vdso/vdso32-setup.c          |  47 ++++++++--
 arch/x86/vdso/vdso32/vclock_gettime.c |  16 ++++
 arch/x86/vdso/vdso32/vdso32.lds.S     |  11 ++-
 9 files changed, 218 insertions(+), 68 deletions(-)
 create mode 100644 arch/x86/include/asm/vdso32.h
 create mode 100644 arch/x86/vdso/vdso32/vclock_gettime.c

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 9c999c1..21bae90 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -289,7 +289,7 @@ do {									\
 
 #else /* CONFIG_X86_32 */
 
-#define VDSO_HIGH_BASE		0xffffe000U /* CONFIG_COMPAT_VDSO address */
+#define VDSO_HIGH_BASE		0xffffc000U /* CONFIG_COMPAT_VDSO address */
 
 /* 1GB for 64bit, 8MB for 32bit */
 #define STACK_RND_MASK (test_thread_flag(TIF_ADDR32) ? 0x7ff : 0x3fffff)
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index fddb53d..fe3cef9 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -2,6 +2,9 @@
 #define _ASM_X86_VDSO_H
 
 #if defined CONFIG_X86_32 || defined CONFIG_COMPAT
+
+#include <asm/vdso32.h>
+
 extern const char VDSO32_PRELINK[];
 
 /*
diff --git a/arch/x86/include/asm/vdso32.h b/arch/x86/include/asm/vdso32.h
new file mode 100644
index 0000000..7dd2eb8
--- /dev/null
+++ b/arch/x86/include/asm/vdso32.h
@@ -0,0 +1,10 @@
+#ifndef _ASM_X86_VDSO32_H
+#define _ASM_X86_VDSO32_H
+
+#define VDSO_BASE_PAGE	0
+#define VDSO_VVAR_PAGE	1
+#define VDSO_HPET_PAGE	2
+#define	VDSO_PAGES	3
+#define	VDSO_OFFSET(x)	((x) * PAGE_SIZE)
+
+#endif
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index fd14be1..1ff5b0a 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -145,8 +145,15 @@ KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS))
 $(vdso32-images:%=$(obj)/%.dbg): KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
 $(vdso32-images:%=$(obj)/%.dbg): asflags-$(CONFIG_X86_64) += -m32
 
+KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_32 := $(filter-out -mcmodel=kernel,$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=3 -freg-struct-return -fpic
+$(vdso32-images:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
+
 $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
 				 $(obj)/vdso32/vdso32.lds \
+				 $(obj)/vdso32/vclock_gettime.o \
 				 $(obj)/vdso32/note.o \
 				 $(obj)/vdso32/%.o
 	$(call if_changed,vdso)
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index eb5d7a5..d163bb5 100644
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
@@ -24,45 +27,78 @@
 #include <asm/io.h>
 #include <asm/pvclock.h>
 
+#ifndef BUILD_VDSO32
+
 #define gtod (&VVAR(vsyscall_gtod_data))
 
-notrace static cycle_t vread_tsc(void)
+static notrace cycle_t vread_hpet(void)
 {
-	cycle_t ret;
-	u64 last;
-
-	/*
-	 * Empirically, a fence (of type that depends on the CPU)
-	 * before rdtsc is enough to ensure that rdtsc is ordered
-	 * with respect to loads.  The various CPU manuals are unclear
-	 * as to whether rdtsc can be reordered with later loads,
-	 * but no one has ever seen it happen.
-	 */
-	rdtsc_barrier();
-	ret = (cycle_t)vget_cycles();
+	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
+}
 
-	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
+notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
+{
+	long ret;
+	asm("syscall" : "=a" (ret) :
+	    "0" (__NR_clock_gettime), "D" (clock), "S" (ts) : "memory");
+	return ret;
+}
 
-	if (likely(ret >= last))
-		return ret;
+notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
+{
+	long ret;
 
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
+	asm("syscall" : "=a" (ret) :
+	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+	return ret;
 }
+#else
+
+struct vsyscall_gtod_data vvar_vsyscall_gtod_data
+	__attribute__((visibility("hidden")));
+
+u32 hpet_counter
+	__attribute__((visibility("hidden")));
+
+#define gtod (&vvar_vsyscall_gtod_data)
 
 static notrace cycle_t vread_hpet(void)
 {
-	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
+	return readl(&hpet_counter);
+}
+
+notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
+{
+	long ret;
+
+	asm(
+		"push %%ebx \n"
+		"mov %2,%%ebx \n"
+		"call VDSO32_vsyscall \n"
+		"pop %%ebx \n"
+		: "=a" (ret)
+		: "0" (__NR_clock_gettime), "d" (clock), "c" (ts)
+		: "memory");
+	return ret;
 }
 
+notrace static long vdso_fallback_gtod(struct timeval *tv,
+		struct timezone *tz)
+{
+	long ret;
+
+	asm(
+		"push %%ebx \n"
+		"mov %2,%%ebx \n"
+		"call VDSO32_vsyscall \n"
+		"pop %%ebx \n"
+		: "=a" (ret)
+		: "0" (__NR_gettimeofday), "d" (tv), "c" (tz)
+		: "memory");
+	return ret;
+}
+#endif
+
 #ifdef CONFIG_PARAVIRT_CLOCK
 
 static notrace const struct pvclock_vsyscall_time_info *get_pvti(int cpu)
@@ -124,7 +160,7 @@ static notrace cycle_t vread_pvclock(int *mode)
 		*mode = VCLOCK_NONE;
 
 	/* refer to tsc.c read_tsc() comment for rationale */
-	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
+	last = gtod->clock.cycle_last;
 
 	if (likely(ret >= last))
 		return ret;
@@ -133,27 +169,41 @@ static notrace cycle_t vread_pvclock(int *mode)
 }
 #endif
 
-notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
+notrace static cycle_t vread_tsc(void)
 {
-	long ret;
-	asm("syscall" : "=a" (ret) :
-	    "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
-	return ret;
-}
+	cycle_t ret;
+	u64 last;
 
-notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
-{
-	long ret;
+	/*
+	 * Empirically, a fence (of type that depends on the CPU)
+	 * before rdtsc is enough to ensure that rdtsc is ordered
+	 * with respect to loads.  The various CPU manuals are unclear
+	 * as to whether rdtsc can be reordered with later loads,
+	 * but no one has ever seen it happen.
+	 */
+	rdtsc_barrier();
+	ret = (cycle_t)vget_cycles();
 
-	asm("syscall" : "=a" (ret) :
-	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
-	return ret;
-}
+	last = gtod->clock.cycle_last;
 
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
 	if (gtod->clock.vclock_mode == VCLOCK_TSC)
 		cycles = vread_tsc();
@@ -210,7 +260,7 @@ notrace static int do_monotonic(struct timespec *ts)
 	return mode;
 }
 
-notrace static int do_realtime_coarse(struct timespec *ts)
+notrace static void do_realtime_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
@@ -218,10 +268,9 @@ notrace static int do_realtime_coarse(struct timespec *ts)
 		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
-	return 0;
 }
 
-notrace static int do_monotonic_coarse(struct timespec *ts)
+notrace static void do_monotonic_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
@@ -229,30 +278,32 @@ notrace static int do_monotonic_coarse(struct timespec *ts)
 		ts->tv_sec = gtod->monotonic_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->monotonic_time_coarse.tv_nsec;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
-
-	return 0;
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
@@ -287,8 +338,8 @@ int gettimeofday(struct timeval *, struct timezone *)
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
index 634a2cf..109a26b 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -44,6 +44,27 @@ SECTIONS
 	. = ALIGN(0x100);
 
 	.text		: { *(.text*) }			:text	=0x90909090
+
+#ifdef BUILD_VDSO32
+	. = ALIGN(PAGE_SIZE);
+
+	.vvar_sect : {
+		vvar = .;
+
+	/* Place all vvars at the offsets in asm/vvar.h. */
+#define EMIT_VVAR(name, offset) vvar_ ## name = vvar + offset;
+#define __VVAR_KERNEL_LDS
+#include <asm/vvar.h>
+#undef __VVAR_KERNEL_LDS
+#undef EMIT_VVAR
+	} :text :vvar_sect
+
+	. += PAGE_SIZE;
+
+	.hpet_sect : {
+		hpet_counter = . + 0xf0;
+	} :text :hpet_sect
+#endif
 }
 
 /*
@@ -61,4 +82,8 @@ PHDRS
 	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
 	note		PT_NOTE		FLAGS(4);		/* PF_R */
 	eh_frame_hdr	PT_GNU_EH_FRAME;
+#ifdef BUILD_VDSO32
+	vvar_sect	PT_NULL		FLAGS(4);		/* PF_R */
+	hpet_sect	PT_NULL		FLAGS(4);		/* PF_R */
+#endif
 }
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index d6bfb87..eb2050c 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -25,6 +25,7 @@
 #include <asm/tlbflush.h>
 #include <asm/vdso.h>
 #include <asm/proto.h>
+#include <asm/fixmap.h>
 
 enum {
 	VDSO_DISABLED = 0,
@@ -193,7 +194,7 @@ static __init void relocate_vdso(Elf32_Ehdr *ehdr)
 	}
 }
 
-static struct page *vdso32_pages[1];
+static struct page *vdso32_pages[VDSO_PAGES];
 
 #ifdef CONFIG_X86_64
 
@@ -310,6 +311,11 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	unsigned long addr;
 	int ret = 0;
 	bool compat;
+	struct vm_area_struct *vma;
+	extern char __vvar_page;
+#ifdef CONFIG_HPET_TIMER
+	extern unsigned long hpet_address;
+#endif
 
 #ifdef CONFIG_X86_X32_ABI
 	if (test_thread_flag(TIF_X32))
@@ -330,7 +336,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	if (compat)
 		addr = VDSO_HIGH_BASE;
 	else {
-		addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
+		addr = get_unmapped_area(NULL, 0, VDSO_OFFSET(VDSO_PAGES), 0, 0);
 		if (IS_ERR_VALUE(addr)) {
 			ret = addr;
 			goto up_fail;
@@ -340,16 +346,39 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	current->mm->context.vdso = (void *)addr;
 
 	if (compat_uses_vma || !compat) {
-		/*
-		 * MAYWRITE to allow gdb to COW and set breakpoints
-		 */
-		ret = install_special_mapping(mm, addr, PAGE_SIZE,
-					      VM_READ|VM_EXEC|
-					      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-					      vdso32_pages);
+
+		vma = _install_special_mapping(mm,
+			addr,
+			VDSO_OFFSET(VDSO_PAGES),
+			VM_READ|VM_EXEC,
+			vdso32_pages);
+
+		if (IS_ERR(vma)) {
+			ret = PTR_ERR(vma);
+			goto up_fail;
+		}
+
+		ret = remap_pfn_range(vma,
+			vma->vm_start + VDSO_OFFSET(VDSO_VVAR_PAGE),
+			__pa_symbol(&__vvar_page) >> PAGE_SHIFT,
+			PAGE_SIZE,
+			PAGE_READONLY);
 
 		if (ret)
 			goto up_fail;
+
+#ifdef CONFIG_HPET_TIMER
+		if (hpet_address) {
+			ret = io_remap_pfn_range(vma,
+				vma->vm_start + VDSO_OFFSET(VDSO_HPET_PAGE),
+				hpet_address >> PAGE_SHIFT,
+				PAGE_SIZE,
+				pgprot_noncached(PAGE_READONLY));
+
+			if (ret)
+				goto up_fail;
+		}
+#endif
 	}
 
 	current_thread_info()->sysenter_return =
diff --git a/arch/x86/vdso/vdso32/vclock_gettime.c b/arch/x86/vdso/vdso32/vclock_gettime.c
new file mode 100644
index 0000000..fab4ec6
--- /dev/null
+++ b/arch/x86/vdso/vdso32/vclock_gettime.c
@@ -0,0 +1,16 @@
+#define BUILD_VDSO32
+
+#ifdef CONFIG_X86_64
+
+#define _ASM_X86_PAGE_H
+
+#define __pa(x)                0
+#define __va(x)                0
+
+#undef CONFIG_ILLEGAL_POINTER_VALUE
+#define CONFIG_ILLEGAL_POINTER_VALUE   0
+
+#endif
+
+#include "../vclock_gettime.c"
+
diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S b/arch/x86/vdso/vdso32/vdso32.lds.S
index 976124b..66e73b2 100644
--- a/arch/x86/vdso/vdso32/vdso32.lds.S
+++ b/arch/x86/vdso/vdso32/vdso32.lds.S
@@ -8,6 +8,9 @@
  * values visible using the asm-x86/vdso.h macros from the kernel proper.
  */
 
+#include <asm/page.h>
+
+#define BUILD_VDSO32
 #define VDSO_PRELINK 0
 #include "../vdso-layout.lds.S"
 
@@ -19,11 +22,14 @@ ENTRY(__kernel_vsyscall);
  */
 VERSION
 {
-	LINUX_2.5 {
+	LINUX_2.6 {
 	global:
 		__kernel_vsyscall;
 		__kernel_sigreturn;
 		__kernel_rt_sigreturn;
+		__vdso_clock_gettime;
+		__vdso_gettimeofday;
+		__vdso_time;
 	local: *;
 	};
 }
@@ -35,3 +41,6 @@ VDSO32_PRELINK		= VDSO_PRELINK;
 VDSO32_vsyscall		= __kernel_vsyscall;
 VDSO32_sigreturn	= __kernel_sigreturn;
 VDSO32_rt_sigreturn	= __kernel_rt_sigreturn;
+VDSO32_clock_gettime	= clock_gettime;
+VDSO32_gettimeofday	= gettimeofday;
+VDSO32_time		= time;
-- 
1.8.5.3

