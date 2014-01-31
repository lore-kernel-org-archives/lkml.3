Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbaAaXUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 18:20:04 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36591 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552AbaAaXUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 18:20:00 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86: Remove hpet vclock support
Date: Fri, 31 Jan 2014 15:19:56 -0800
Message-Id: <d348afdb2f6acc41dde0381396226b69a0358f8b.1391210357.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HPET is so amazingly slow that this is barely a win.  It adds
complexity, and it scares me a tiny bit to map a piece of crappy
hardware where every userspace program can poke at it (even if said
poking is read-only).  Let's just remove it.

This is probably a tiny speedup on kvmclock systems.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/clocksource.h | 3 +--
 arch/x86/include/asm/fixmap.h      | 1 -
 arch/x86/kernel/hpet.c             | 7 -------
 arch/x86/kvm/trace.h               | 4 ++--
 arch/x86/vdso/vclock_gettime.c     | 8 --------
 5 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/clocksource.h b/arch/x86/include/asm/clocksource.h
index 16a57f4..00d2e6f 100644
--- a/arch/x86/include/asm/clocksource.h
+++ b/arch/x86/include/asm/clocksource.h
@@ -7,8 +7,7 @@
 
 #define VCLOCK_NONE 0  /* No vDSO clock available.	*/
 #define VCLOCK_TSC  1  /* vDSO should use vread_tsc.	*/
-#define VCLOCK_HPET 2  /* vDSO should use vread_hpet.	*/
-#define VCLOCK_PVCLOCK 3 /* vDSO should use vread_pvclock. */
+#define VCLOCK_PVCLOCK 2 /* vDSO should use vread_pvclock. */
 
 struct arch_clocksource_data {
 	int vclock_mode;
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 7252cd3..a1c741c 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -80,7 +80,6 @@ enum fixed_addresses {
 	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
 			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
 	VVAR_PAGE,
-	VSYSCALL_HPET,
 #ifdef CONFIG_PARAVIRT_CLOCK
 	PVCLOCK_FIXMAP_BEGIN,
 	PVCLOCK_FIXMAP_END = PVCLOCK_FIXMAP_BEGIN+PVCLOCK_VSYSCALL_NR_PAGES-1,
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index da85a8e..b578e07 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -12,7 +12,6 @@
 #include <linux/pm.h>
 #include <linux/io.h>
 
-#include <asm/fixmap.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
 
@@ -74,9 +73,6 @@ static inline void hpet_writel(unsigned int d, unsigned int a)
 static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
-#ifdef CONFIG_X86_64
-	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_NOCACHE);
-#endif
 }
 
 static inline void hpet_clear_mapping(void)
@@ -752,9 +748,6 @@ static struct clocksource clocksource_hpet = {
 	.mask		= HPET_MASK,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_resume_counter,
-#ifdef CONFIG_X86_64
-	.archdata	= { .vclock_mode = VCLOCK_HPET },
-#endif
 };
 
 static int hpet_clocksource_register(void)
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 545245d..02d1a84 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -781,8 +781,8 @@ TRACE_EVENT(kvm_write_tsc_offset,
 
 #define host_clocks					\
 	{VCLOCK_NONE, "none"},				\
-	{VCLOCK_TSC,  "tsc"},				\
-	{VCLOCK_HPET, "hpet"}				\
+	{VCLOCK_TSC,  "tsc"}
+
 
 TRACE_EVENT(kvm_update_master_clock,
 	TP_PROTO(bool use_master_clock, unsigned int host_clock, bool offset_matched),
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index eb5d7a5..3095446 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -19,7 +19,6 @@
 #include <asm/fixmap.h>
 #include <asm/vgtod.h>
 #include <asm/timex.h>
-#include <asm/hpet.h>
 #include <asm/unistd.h>
 #include <asm/io.h>
 #include <asm/pvclock.h>
@@ -58,11 +57,6 @@ notrace static cycle_t vread_tsc(void)
 	return last;
 }
 
-static notrace cycle_t vread_hpet(void)
-{
-	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
-}
-
 #ifdef CONFIG_PARAVIRT_CLOCK
 
 static notrace const struct pvclock_vsyscall_time_info *get_pvti(int cpu)
@@ -157,8 +151,6 @@ notrace static inline u64 vgetsns(int *mode)
 	cycles_t cycles;
 	if (gtod->clock.vclock_mode == VCLOCK_TSC)
 		cycles = vread_tsc();
-	else if (gtod->clock.vclock_mode == VCLOCK_HPET)
-		cycles = vread_hpet();
 #ifdef CONFIG_PARAVIRT_CLOCK
 	else if (gtod->clock.vclock_mode == VCLOCK_PVCLOCK)
 		cycles = vread_pvclock(mode);
-- 
1.8.5.3

