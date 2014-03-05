Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbaCEWbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:31:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37537 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaCEWbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:31:04 -0500
Date: Wed, 5 Mar 2014 14:30:34 -0800
From: tip-bot for Stefani Seibold <tipbot@zytor.com>
Message-ID: <tip-644641cf162515479f34db62145d2efe084cb60e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1393881143-3569-2-git-send-email-stefani@seibold.net>
References: <1393881143-3569-2-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso:
  Make vsyscall_gtod_data handling x86 generic
Git-Commit-ID: 644641cf162515479f34db62145d2efe084cb60e
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

Commit-ID:  644641cf162515479f34db62145d2efe084cb60e
Gitweb:     http://git.kernel.org/tip/644641cf162515479f34db62145d2efe084cb60e
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Mon, 3 Mar 2014 22:12:12 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 5 Mar 2014 14:02:37 -0800

x86, vdso: Make vsyscall_gtod_data handling x86 generic

This patch move the vsyscall_gtod_data handling out of vsyscall_64.c
into an additonal file vsyscall_gtod.c to make the functionality
available for x86 32 bit kernel.

It also adds a new vsyscall_32.c which setup the VVAR page.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1393881143-3569-2-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig                   |  4 +--
 arch/x86/include/asm/clocksource.h |  4 ---
 arch/x86/include/asm/fixmap.h      |  2 ++
 arch/x86/include/asm/vvar.h        | 12 ++++++--
 arch/x86/kernel/Makefile           |  3 +-
 arch/x86/kernel/hpet.c             |  4 ---
 arch/x86/kernel/setup.c            |  2 --
 arch/x86/kernel/tsc.c              |  2 --
 arch/x86/kernel/vmlinux.lds.S      |  3 --
 arch/x86/kernel/vsyscall_32.c      | 20 +++++++++++++
 arch/x86/kernel/vsyscall_64.c      | 45 -----------------------------
 arch/x86/kernel/vsyscall_gtod.c    | 59 ++++++++++++++++++++++++++++++++++++++
 arch/x86/tools/relocs.c            |  2 +-
 13 files changed, 95 insertions(+), 67 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..0da3b39 100644
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
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 7252cd3..094d0cc 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -75,6 +75,8 @@ enum fixed_addresses {
 #ifdef CONFIG_X86_32
 	FIX_HOLE,
 	FIX_VDSO,
+	VVAR_PAGE,
+	VSYSCALL_HPET,
 #else
 	VSYSCALL_LAST_PAGE,
 	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index d76ac40..0a534ea 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -16,9 +16,6 @@
  * you mess up, the linker will catch it.)
  */
 
-/* Base address of vvars.  This is not ABI. */
-#define VVAR_ADDRESS (-10*1024*1024 - 4096)
-
 #if defined(__VVAR_KERNEL_LDS)
 
 /* The kernel linker script defines its own magic to put vvars in the
@@ -29,6 +26,15 @@
 
 #else
 
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
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index cb648c8..3282eda 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -26,7 +26,8 @@ obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
-obj-y			+= syscall_$(BITS).o
+obj-y			+= syscall_$(BITS).o vsyscall_gtod.o
+obj-$(CONFIG_X86_32)	+= vsyscall_32.o
 obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
 obj-$(CONFIG_SYSFS)	+= ksysfs.o
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index da85a8e..54263f0 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -74,9 +74,7 @@ static inline void hpet_writel(unsigned int d, unsigned int a)
 static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
-#ifdef CONFIG_X86_64
 	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_NOCACHE);
-#endif
 }
 
 static inline void hpet_clear_mapping(void)
@@ -752,9 +750,7 @@ static struct clocksource clocksource_hpet = {
 	.mask		= HPET_MASK,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_resume_counter,
-#ifdef CONFIG_X86_64
 	.archdata	= { .vclock_mode = VCLOCK_HPET },
-#endif
 };
 
 static int hpet_clocksource_register(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 06853e6..56ff330 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1182,9 +1182,7 @@ void __init setup_arch(char **cmdline_p)
 
 	tboot_probe();
 
-#ifdef CONFIG_X86_64
 	map_vsyscall();
-#endif
 
 	generic_apic_probe();
 
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
index da6b35a..1d4897b 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -147,7 +147,6 @@ SECTIONS
 		_edata = .;
 	} :data
 
-#ifdef CONFIG_X86_64
 
 	. = ALIGN(PAGE_SIZE);
 	__vvar_page = .;
@@ -169,8 +168,6 @@ SECTIONS
 
        . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
 
-#endif /* CONFIG_X86_64 */
-
 	/* Init code and data - will be freed after init */
 	. = ALIGN(PAGE_SIZE);
 	.init.begin : AT(ADDR(.init.begin) - LOAD_OFFSET) {
diff --git a/arch/x86/kernel/vsyscall_32.c b/arch/x86/kernel/vsyscall_32.c
new file mode 100644
index 0000000..4b94c47
--- /dev/null
+++ b/arch/x86/kernel/vsyscall_32.c
@@ -0,0 +1,20 @@
+/*
+ *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
+ *  Copyright 2003 Andi Kleen, SuSE Labs.
+ *
+ *  Modified for x86 32 bit arch by Stefani Seibold <stefani@seibold.net>
+ *
+ *  Thanks to hpa@transmeta.com for some useful hint.
+ *  Special thanks to Ingo Molnar for his early experience with
+ *  a different vsyscall implementation for Linux/IA32 and for the name.
+ *
+ */
+
+#include <asm/vsyscall.h>
+#include <asm/pgtable.h>
+#include <asm/fixmap.h>
+
+void __init map_vsyscall(void)
+{
+	__set_fixmap(VVAR_PAGE, __pa_symbol(&__vvar_page), PAGE_KERNEL_VVAR);
+}
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
index 0000000..b5a943d
--- /dev/null
+++ b/arch/x86/kernel/vsyscall_gtod.c
@@ -0,0 +1,59 @@
+/*
+ *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
+ *  Copyright 2003 Andi Kleen, SuSE Labs.
+ *
+ *  Modified for x86 32 bit architecture by
+ *  Stefani Seibold <stefani@seibold.net>
+ *
+ *  Thanks to hpa@transmeta.com for some useful hint.
+ *  Special thanks to Ingo Molnar for his early experience with
+ *  a different vsyscall implementation for Linux/IA32 and for the name.
+ *
+ */
+
+#include <linux/timekeeper_internal.h>
+#include <asm/vgtod.h>
+
+DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
+
+void update_vsyscall_tz(void)
+{
+	vsyscall_gtod_data.sys_tz = sys_tz;
+}
+
+void update_vsyscall(struct timekeeper *tk)
+{
+	struct vsyscall_gtod_data *vdata = &vsyscall_gtod_data;
+
+	write_seqcount_begin(&vdata->seq);
+
+	/* copy vsyscall data */
+	vdata->clock.vclock_mode	= tk->clock->archdata.vclock_mode;
+	vdata->clock.cycle_last		= tk->clock->cycle_last;
+	vdata->clock.mask		= tk->clock->mask;
+	vdata->clock.mult		= tk->mult;
+	vdata->clock.shift		= tk->shift;
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
+	vdata->wall_time_coarse.tv_sec	= tk->xtime_sec;
+	vdata->wall_time_coarse.tv_nsec	= (long)(tk->xtime_nsec >> tk->shift);
+
+	vdata->monotonic_time_coarse	= timespec_add(vdata->wall_time_coarse,
+							tk->wall_to_monotonic);
+
+	write_seqcount_end(&vdata->seq);
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
 
