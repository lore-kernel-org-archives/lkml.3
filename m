Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbaF3Vxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:53:48 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:44779 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbaF3Vxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:53:45 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, hpa@zytor.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 05/10] x86,vdso: Replace vgetcpu_mode with static_cpu_has
Date: Mon, 30 Jun 2014 14:53:16 -0700
Message-Id: <d4c30be7d7dc62a23371ef2a4398e1d1ea28bb9c.1404164803.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1404164803.git.luto@amacapital.net>
References: <cover.1404164803.git.luto@amacapital.net>
In-Reply-To: <cover.1404164803.git.luto@amacapital.net>
References: <cover.1404164803.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vdso has supported alternatives for a while; use them instead of
a vvar to select the vgetcpu mode.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/vgtod.h    | 21 +++++++++++++++++++++
 arch/x86/include/asm/vsyscall.h | 29 -----------------------------
 arch/x86/include/asm/vvar.h     |  1 -
 arch/x86/kernel/cpu/common.c    | 10 ----------
 arch/x86/kernel/vsyscall_64.c   |  2 --
 arch/x86/vdso/vclock_gettime.c  |  3 +++
 arch/x86/vdso/vgetcpu.c         |  4 +++-
 arch/x86/vdso/vma.c             |  1 +
 8 files changed, 28 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 3c3366c..44e0037 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -70,4 +70,25 @@ static inline void gtod_write_end(struct vsyscall_gtod_data *s)
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
+	if (static_cpu_has(X86_FEATURE_RDTSCP)) {
+		/* Load per CPU data from RDTSCP */
+		native_read_tscp(&p);
+	} else {
+		/* Load per CPU data from GDT */
+		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
+	}
+
+	return p;
+}
+
+#endif /* CONFIG_X86_64 */
+
 #endif /* _ASM_X86_VGTOD_H */
diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index 2a46ca7..34f7d88 100644
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
index 5f6d407..3f32dfc 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -44,7 +44,6 @@ extern char __vvar_page;
 
 /* DECLARE_VVAR(offset, type, name) */
 
-DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
 
 #undef DECLARE_VVAR
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ef1b93f..becea69 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -948,14 +948,6 @@ static void identify_cpu(struct cpuinfo_x86 *c)
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
@@ -996,8 +988,6 @@ void __init identify_boot_cpu(void)
 #ifdef CONFIG_X86_32
 	sysenter_setup();
 	enable_sep_cpu();
-#else
-	vgetcpu_set_mode();
 #endif
 	cpu_detect_tlb(&boot_cpu_data);
 }
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 6463f9e..dd1b322 100644
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
index 9793322..d14bb8f 100644
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
index add1d98..fd8470c 100644
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
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index e1513c4..67a8b6c 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -16,6 +16,7 @@
 #include <asm/vdso.h>
 #include <asm/page.h>
 #include <asm/hpet.h>
+#include <asm/vvar.h>
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
-- 
1.9.3

