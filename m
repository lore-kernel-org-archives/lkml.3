Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaKCMs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:48:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaKCMsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:48:55 -0500
Date: Mon, 3 Nov 2014 04:48:29 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-e76b027e6408f5570dc940b731ec9ae870c6188a@git.kernel.org>
Cc: andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, luto@amacapital.net, mingo@kernel.org
Reply-To: andi@firstfloor.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, luto@amacapital.net, tglx@linutronix.de
In-Reply-To: <72f73d5ec4514e02bba345b9759177ef03742efb.1414706021.git.luto@amacapital.net>
References: <72f73d5ec4514e02bba345b9759177ef03742efb.1414706021.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86,vdso: Use LSL unconditionally for vgetcpu
Git-Commit-ID: e76b027e6408f5570dc940b731ec9ae870c6188a
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

Commit-ID:  e76b027e6408f5570dc940b731ec9ae870c6188a
Gitweb:     http://git.kernel.org/tip/e76b027e6408f5570dc940b731ec9ae870c6188a
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Thu, 30 Oct 2014 14:58:01 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 13:41:53 +0100

x86,vdso: Use LSL unconditionally for vgetcpu

LSL is faster than RDTSCP and works everywhere; there's no need to
switch between them depending on CPU.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>
Link: http://lkml.kernel.org/r/72f73d5ec4514e02bba345b9759177ef03742efb.1414706021.git.luto@amacapital.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/vgtod.h    | 19 +++++++++++++++++++
 arch/x86/include/asm/vsyscall.h | 29 -----------------------------
 arch/x86/include/asm/vvar.h     |  1 -
 arch/x86/kernel/cpu/common.c    | 10 ----------
 arch/x86/kernel/vsyscall_64.c   |  2 --
 arch/x86/vdso/vgetcpu.c         |  1 -
 6 files changed, 19 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 3c3366c..e7e9682 100644
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
index 4b4f78c..175372b8 100644
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
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 2f9ef0c..419e83b 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -52,8 +52,6 @@
 #define CREATE_TRACE_POINTS
 #include "vsyscall_trace.h"
 
-DEFINE_VVAR(int, vgetcpu_mode);
-
 static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
 
 static int __init vsyscall_setup(char *str)
diff --git a/arch/x86/vdso/vgetcpu.c b/arch/x86/vdso/vgetcpu.c
index add1d98..8ec3d1f 100644
--- a/arch/x86/vdso/vgetcpu.c
+++ b/arch/x86/vdso/vgetcpu.c
@@ -8,7 +8,6 @@
 #include <linux/kernel.h>
 #include <linux/getcpu.h>
 #include <linux/time.h>
-#include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 
 notrace long
