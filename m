Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbaCEWcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:32:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37609 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbaCEWc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:32:27 -0500
Date: Wed, 5 Mar 2014 14:32:05 -0800
From: tip-bot for Stefani Seibold <tipbot@zytor.com>
Message-ID: <tip-4dea8e4824b363c53f320d328040d7c6c5921419@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1393881143-3569-10-git-send-email-stefani@seibold.net>
References: <1393881143-3569-10-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso:
  Add 32 bit VDSO time support for 32 bit kernel
Git-Commit-ID: 4dea8e4824b363c53f320d328040d7c6c5921419
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

Commit-ID:  4dea8e4824b363c53f320d328040d7c6c5921419
Gitweb:     http://git.kernel.org/tip/4dea8e4824b363c53f320d328040d7c6c5921419
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Mon, 3 Mar 2014 22:12:20 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 5 Mar 2014 14:02:38 -0800

x86, vdso: Add 32 bit VDSO time support for 32 bit kernel

This patch add the time support for 32 bit a VDSO to a 32 bit kernel.

For 32 bit programs running on a 32 bit kernel, the same mechanism is
used as for 64 bit programs running on a 64 bit kernel.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1393881143-3569-10-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/vdso.h           |  3 ++
 arch/x86/include/asm/vdso32.h         | 11 +++++
 arch/x86/vdso/Makefile                |  8 ++++
 arch/x86/vdso/vclock_gettime.c        | 76 +++++++++++++++++++++++++++++++----
 arch/x86/vdso/vdso-layout.lds.S       | 22 ++++++++++
 arch/x86/vdso/vdso32-setup.c          | 53 +++++++++++++++++++++---
 arch/x86/vdso/vdso32/vclock_gettime.c |  3 ++
 arch/x86/vdso/vdso32/vdso32.lds.S     |  9 +++++
 8 files changed, 172 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 6e39eb8..0f363c1 100644
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
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 7a3d13e..6cef7a1 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -146,8 +146,16 @@ KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS))
 $(vdso32-images:%=$(obj)/%.dbg): KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
 $(vdso32-images:%=$(obj)/%.dbg): asflags-$(CONFIG_X86_64) += -m32
 
+KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_32 := $(filter-out -mcmodel=kernel,$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 := $(filter-out -mfentry,$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=0 -fpic
+$(vdso32-images:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
+
 $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
 				 $(obj)/vdso32/vdso32.lds \
+				 $(obj)/vdso32/vclock_gettime.o \
 				 $(obj)/vdso32/note.o \
 				 $(obj)/vdso32/%.o
 	$(call if_changed,vdso)
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 09dae4a..90bb5e8 100644
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
@@ -12,13 +15,11 @@
 #define DISABLE_BRANCH_PROFILING
 
 #include <linux/kernel.h>
-#include <linux/posix-timers.h>
-#include <linux/time.h>
+#include <uapi/linux/time.h>
 #include <linux/string.h>
 #include <asm/vsyscall.h>
 #include <asm/fixmap.h>
 #include <asm/vgtod.h>
-#include <asm/timex.h>
 #include <asm/hpet.h>
 #include <asm/unistd.h>
 #include <asm/io.h>
@@ -26,6 +27,12 @@
 
 #define gtod (&VVAR(vsyscall_gtod_data))
 
+extern int __vdso_clock_gettime(clockid_t clock, struct timespec *ts);
+extern int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz);
+extern time_t __vdso_time(time_t *t);
+
+#ifndef BUILD_VDSO32
+
 static notrace cycle_t vread_hpet(void)
 {
 	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
@@ -118,6 +125,59 @@ static notrace cycle_t vread_pvclock(int *mode)
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
+	return readl((const void __iomem *)(&hpet_page + HPET_COUNTER));
+}
+#endif
+
+notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
+{
+	long ret;
+
+	asm(
+		"mov %%ebx, %%edx \n"
+		"mov %2, %%ebx \n"
+		"call VDSO32_vsyscall \n"
+		"mov %%edx, %%ebx \n"
+		: "=a" (ret)
+		: "0" (__NR_clock_gettime), "g" (clock), "c" (ts)
+		: "memory", "edx");
+	return ret;
+}
+
+notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
+{
+	long ret;
+
+	asm(
+		"mov %%ebx, %%edx \n"
+		"mov %2, %%ebx \n"
+		"call VDSO32_vsyscall \n"
+		"mov %%edx, %%ebx \n"
+		: "=a" (ret)
+		: "0" (__NR_gettimeofday), "g" (tv), "c" (tz)
+		: "memory", "edx");
+	return ret;
+}
+
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
 notrace static cycle_t vread_tsc(void)
 {
 	cycle_t ret;
@@ -131,7 +191,7 @@ notrace static cycle_t vread_tsc(void)
 	 * but no one has ever seen it happen.
 	 */
 	rdtsc_barrier();
-	ret = (cycle_t)vget_cycles();
+	ret = (cycle_t)__native_read_tsc();
 
 	last = gtod->clock.cycle_last;
 
@@ -152,12 +212,14 @@ notrace static cycle_t vread_tsc(void)
 
 notrace static inline u64 vgetsns(int *mode)
 {
-	long v;
+	u64 v;
 	cycles_t cycles;
 	if (gtod->clock.vclock_mode == VCLOCK_TSC)
 		cycles = vread_tsc();
+#ifdef CONFIG_HPET_TIMER
 	else if (gtod->clock.vclock_mode == VCLOCK_HPET)
 		cycles = vread_hpet();
+#endif
 #ifdef CONFIG_PARAVIRT_CLOCK
 	else if (gtod->clock.vclock_mode == VCLOCK_PVCLOCK)
 		cycles = vread_pvclock(mode);
@@ -189,7 +251,7 @@ notrace static int __always_inline do_realtime(struct timespec *ts)
 	return mode;
 }
 
-notrace static int do_monotonic(struct timespec *ts)
+notrace static int __always_inline do_monotonic(struct timespec *ts)
 {
 	unsigned long seq;
 	u64 ns;
@@ -284,7 +346,7 @@ int gettimeofday(struct timeval *, struct timezone *)
  */
 notrace time_t __vdso_time(time_t *t)
 {
-	/* This is atomic on x86_64 so we don't need any locks. */
+	/* This is atomic on x86 so we don't need any locks. */
 	time_t result = ACCESS_ONCE(gtod->wall_time_sec);
 
 	if (t)
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 634a2cf..1261437 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -6,6 +6,24 @@
 
 SECTIONS
 {
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
 	. = VDSO_PRELINK + SIZEOF_HEADERS;
 
 	.hash		: { *(.hash) }			:text
@@ -61,4 +79,8 @@ PHDRS
 	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
 	note		PT_NOTE		FLAGS(4);		/* PF_R */
 	eh_frame_hdr	PT_GNU_EH_FRAME;
+#ifdef BUILD_VDSO32
+	vvar_sect	PT_NULL		FLAGS(4);		/* PF_R */
+	hpet_sect	PT_NULL		FLAGS(4);		/* PF_R */
+#endif
 }
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index bca2ffd..54db7e4 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -25,6 +25,9 @@
 #include <asm/tlbflush.h>
 #include <asm/vdso.h>
 #include <asm/proto.h>
+#include <asm/fixmap.h>
+#include <asm/hpet.h>
+#include <asm/vvar.h>
 
 enum {
 	VDSO_DISABLED = 0,
@@ -193,7 +196,7 @@ static __init void relocate_vdso(Elf32_Ehdr *ehdr)
 	}
 }
 
-static struct page *vdso32_pages[1];
+static struct page *vdso32_pages[VDSO_PAGES];
 
 #ifdef CONFIG_X86_64
 
@@ -311,6 +314,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	unsigned long addr;
 	int ret = 0;
 	bool compat;
+	struct vm_area_struct *vma;
 
 #ifdef CONFIG_X86_X32_ABI
 	if (test_thread_flag(TIF_X32))
@@ -331,11 +335,13 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	if (compat)
 		addr = VDSO_HIGH_BASE;
 	else {
-		addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
+		addr = get_unmapped_area(NULL, 0, VDSO_OFFSET(VDSO_PAGES), 0, 0);
 		if (IS_ERR_VALUE(addr)) {
 			ret = addr;
 			goto up_fail;
 		}
+
+		addr += VDSO_OFFSET(VDSO_PREV_PAGES);
 	}
 
 	current->mm->context.vdso = (void *)addr;
@@ -344,13 +350,48 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 		/*
 		 * MAYWRITE to allow gdb to COW and set breakpoints
 		 */
-		ret = install_special_mapping(mm, addr, PAGE_SIZE,
-					      VM_READ|VM_EXEC|
-					      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-					      vdso32_pages);
+		ret = install_special_mapping(mm,
+				addr,
+				VDSO_OFFSET(VDSO_PAGES - VDSO_PREV_PAGES),
+				VM_READ|VM_EXEC|
+				VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
+				vdso32_pages);
 
 		if (ret)
 			goto up_fail;
+
+		vma = _install_special_mapping(mm,
+				addr -  VDSO_OFFSET(VDSO_PREV_PAGES),
+				VDSO_OFFSET(VDSO_PREV_PAGES),
+				VM_READ,
+				NULL);
+
+		if (IS_ERR(vma)) {
+			ret = PTR_ERR(vma);
+			goto up_fail;
+		}
+
+		ret = remap_pfn_range(vma,
+			addr - VDSO_OFFSET(VDSO_VVAR_PAGE),
+			__pa_symbol(&__vvar_page) >> PAGE_SHIFT,
+			PAGE_SIZE,
+			PAGE_READONLY);
+
+		if (ret)
+			goto up_fail;
+
+#ifdef CONFIG_HPET_TIMER
+		if (hpet_address) {
+			ret = io_remap_pfn_range(vma,
+				addr - VDSO_OFFSET(VDSO_HPET_PAGE),
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
index 0000000..6de0b97
--- /dev/null
+++ b/arch/x86/vdso/vdso32/vclock_gettime.c
@@ -0,0 +1,3 @@
+#define BUILD_VDSO32
+
+#include "../vclock_gettime.c"
diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S b/arch/x86/vdso/vdso32/vdso32.lds.S
index 976124b..bc8bf6d 100644
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
 
@@ -24,6 +27,9 @@ VERSION
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
