Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaJTWo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:44:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36609 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbaJTWo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:44:58 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 8/8 only] x86,vdso: Use LSL unconditionally for vgetcpu
Date: Mon, 20 Oct 2014 15:44:46 -0700
Message-Id: <d2466423e1d88f24a52e746d4f5c6a7abce982ae.1413844952.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LSL is faster than RDTSCP and works everywhere; there's no need to
switch between them depending on CPU.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

This replaces patch 8 from v1.  Changes from v1:
 - Use LSL unconditionally (drop static_cpu_has).

 arch/x86/include/asm/vgtod.h    | 19 +++++++++++++++++++
 arch/x86/include/asm/vsyscall.h | 29 -----------------------------
 arch/x86/include/asm/vvar.h     |  1 -
 arch/x86/kernel/cpu/common.c    | 10 ----------
 arch/x86/kernel/vsyscall_64.c   |  2 --
 arch/x86/vdso/vclock_gettime.c  |  3 +++
 arch/x86/vdso/vgetcpu.c         |  4 +++-
 7 files changed, 25 insertions(+), 43 deletions(-)

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
index 2a46ca720afc..34f7d8857542 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -4,15 +4,6 @@
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
 extern void map_vsyscall(void);
 
 /*
@@ -21,24 +12,4 @@ extern void map_vsyscall(void);
  */
 extern bool emulate_vsyscall(struct pt_regs *regs, unsigned long address);
 
-#ifdef CONFIG_X86_64
-
-#define VGETCPU_CPU_MASK 0xfff
-
-static inline unsigned int __getcpu(void)
-{
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
-}
-#endif /* CONFIG_X86_64 */
-
 #endif /* _ASM_X86_VSYSCALL_H */
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 5f6d40734a3b..3f32dfc2ab73 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -44,7 +44,6 @@ extern char __vvar_page;
 
 /* DECLARE_VVAR(offset, type, name) */
 
-DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
 
 #undef DECLARE_VVAR
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e4ab2b42bd6f..c12b864c9d98 100644
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
 /* May not be __init: called during resume */
 static void syscall32_cpu_init(void)
 {
@@ -1004,8 +996,6 @@ void __init identify_boot_cpu(void)
 #ifdef CONFIG_X86_32
 	sysenter_setup();
 	enable_sep_cpu();
-#else
-	vgetcpu_set_mode();
 #endif
 	cpu_detect_tlb(&boot_cpu_data);
 }
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 31ce584981f3..9d2c660cfb70 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -52,8 +52,6 @@
 #define CREATE_TRACE_POINTS
 #include "vsyscall_trace.h"
 
-DEFINE_VVAR(int, vgetcpu_mode);
-
 static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
 
 static int __init vsyscall_setup(char *str)
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 9793322751e0..d14bb8faad16 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -11,6 +11,9 @@
  * Check with readelf after changing.
  */
 
+/* Disable static_cpu_has debugging; it doesn't work in the vDSO */
+#undef CONFIG_X86_DEBUG_STATIC_CPU_HAS
+
 #include <uapi/linux/time.h>
 #include <asm/vgtod.h>
 #include <asm/hpet.h>
diff --git a/arch/x86/vdso/vgetcpu.c b/arch/x86/vdso/vgetcpu.c
index add1d98d2477..fd8470c98ab5 100644
--- a/arch/x86/vdso/vgetcpu.c
+++ b/arch/x86/vdso/vgetcpu.c
@@ -5,10 +5,12 @@
  * Fast user context implementation of getcpu()
  */
 
+/* Disable static_cpu_has debugging; it doesn't work in the vDSO */
+#undef CONFIG_X86_DEBUG_STATIC_CPU_HAS
+
 #include <linux/kernel.h>
 #include <linux/getcpu.h>
 #include <linux/time.h>
-#include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 
 notrace long
-- 
1.9.3

