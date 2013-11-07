Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab3KGTU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:20:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38574 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab3KGTUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:20:46 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
Date: Thu,  7 Nov 2013 11:20:42 -0800
Message-Id: <1383852042-10780-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc0.44.gf26f72d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we're running on a v7 ARM CPU, detect if the CPU supports the
sdiv/udiv instructions and replace the signed and unsigned
division library functions with an sdiv/udiv instruction.

Running the perf messaging benchmark in pipe mode

 $ perf bench sched messaging -p

shows a modest improvement on my v7 CPU.

before:
(5.060 + 5.960 + 5.971 + 5.643 + 6.029 + 5.665 + 6.050 + 5.870 + 6.117 + 5.683) / 10 = 5.805

after:
(4.884 + 5.549 + 5.749 + 6.001 + 5.460 + 5.103 + 5.956 + 6.112 + 5.468 + 5.093) / 10 = 5.538

(5.805 - 5.538) / 5.805 = 4.6%

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Should we add in the __div0() call if the denominator is 0?

 arch/arm/kernel/setup.c  | 10 +++++++++
 arch/arm/lib/Makefile    |  3 +++
 arch/arm/lib/div-v7.c    | 58 ++++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/lib/lib1funcs.S | 16 +++++++++++++
 4 files changed, 87 insertions(+)
 create mode 100644 arch/arm/lib/div-v7.c

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 0e1e2b3..7d519f4 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -30,6 +30,7 @@
 #include <linux/bug.h>
 #include <linux/compiler.h>
 #include <linux/sort.h>
+#include <linux/static_key.h>
 
 #include <asm/unified.h>
 #include <asm/cp15.h>
@@ -365,6 +366,8 @@ void __init early_print(const char *str, ...)
 	printk("%s", buf);
 }
 
+struct static_key cpu_has_idiv = STATIC_KEY_INIT_FALSE;
+
 static void __init cpuid_init_hwcaps(void)
 {
 	unsigned int divide_instrs, vmsa;
@@ -381,6 +384,13 @@ static void __init cpuid_init_hwcaps(void)
 		elf_hwcap |= HWCAP_IDIVT;
 	}
 
+#ifdef CONFIG_THUMB2_KERNEL
+	if (elf_hwcap & HWCAP_IDIVT)
+#else
+	if (elf_hwcap & HWCAP_IDIVA)
+#endif
+		static_key_slow_inc(&cpu_has_idiv);
+
 	/* LPAE implies atomic ldrd/strd instructions */
 	vmsa = (read_cpuid_ext(CPUID_EXT_MMFR0) & 0xf) >> 0;
 	if (vmsa >= 5)
diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
index bd454b0..6ed6496 100644
--- a/arch/arm/lib/Makefile
+++ b/arch/arm/lib/Makefile
@@ -15,6 +15,9 @@ lib-y		:= backtrace.o changebit.o csumipv6.o csumpartial.o   \
 		   io-readsb.o io-writesb.o io-readsl.o io-writesl.o  \
 		   call_with_stack.o
 
+lib-$(CONFIG_CPU_V7) += div-v7.o
+CFLAGS_div-v7.o := -march=armv7-a
+
 mmu-y	:= clear_user.o copy_page.o getuser.o putuser.o
 
 # the code in uaccess.S is not preemption safe and
diff --git a/arch/arm/lib/div-v7.c b/arch/arm/lib/div-v7.c
new file mode 100644
index 0000000..96ceb92
--- /dev/null
+++ b/arch/arm/lib/div-v7.c
@@ -0,0 +1,58 @@
+/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/static_key.h>
+
+extern int ___aeabi_idiv(int, int);
+extern unsigned ___aeabi_uidiv(int, int);
+
+extern struct static_key cpu_has_idiv;
+
+int __aeabi_idiv(int numerator, int denominator)
+{
+	if (static_key_false(&cpu_has_idiv)) {
+		int ret;
+
+		asm volatile (
+		".arch_extension idiv\n"
+		"sdiv %0, %1, %2"
+		: "=&r" (ret)
+		: "r" (numerator), "r" (denominator));
+
+		return ret;
+	}
+
+	return ___aeabi_idiv(numerator, denominator);
+}
+
+int __divsi3(int numerator, int denominator)
+	__attribute__((alias("__aeabi_idiv")));
+
+unsigned __aeabi_uidiv(int numerator, int denominator)
+{
+	if (static_key_false(&cpu_has_idiv)) {
+		int ret;
+
+		asm volatile (
+		".arch_extension idiv\n"
+		"udiv %0, %1, %2"
+		: "=&r" (ret)
+		: "r" (numerator), "r" (denominator));
+
+		return ret;
+	}
+
+	return ___aeabi_uidiv(numerator, denominator);
+}
+
+unsigned __udivsi3(int numerator, int denominator)
+	__attribute__((alias("__aeabi_uidiv")));
diff --git a/arch/arm/lib/lib1funcs.S b/arch/arm/lib/lib1funcs.S
index c562f64..adea088 100644
--- a/arch/arm/lib/lib1funcs.S
+++ b/arch/arm/lib/lib1funcs.S
@@ -205,8 +205,12 @@ Boston, MA 02111-1307, USA.  */
 .endm
 
 
+#if defined(ZIMAGE) || !defined(CONFIG_CPU_V7)
 ENTRY(__udivsi3)
 ENTRY(__aeabi_uidiv)
+#else
+ENTRY(___aeabi_uidiv)
+#endif
 UNWIND(.fnstart)
 
 	subs	r2, r1, #1
@@ -232,8 +236,12 @@ UNWIND(.fnstart)
 	mov	pc, lr
 
 UNWIND(.fnend)
+#if defined(ZIMAGE) || !defined(CONFIG_CPU_V7)
 ENDPROC(__udivsi3)
 ENDPROC(__aeabi_uidiv)
+#else
+ENDPROC(___aeabi_uidiv)
+#endif
 
 ENTRY(__umodsi3)
 UNWIND(.fnstart)
@@ -253,8 +261,12 @@ UNWIND(.fnstart)
 UNWIND(.fnend)
 ENDPROC(__umodsi3)
 
+#if defined(ZIMAGE) || !defined(CONFIG_CPU_V7)
 ENTRY(__divsi3)
 ENTRY(__aeabi_idiv)
+#else
+ENTRY(___aeabi_idiv)
+#endif
 UNWIND(.fnstart)
 
 	cmp	r1, #0
@@ -293,8 +305,12 @@ UNWIND(.fnstart)
 	mov	pc, lr
 
 UNWIND(.fnend)
+#if defined(ZIMAGE) || !defined(CONFIG_CPU_V7)
 ENDPROC(__divsi3)
 ENDPROC(__aeabi_idiv)
+#else
+ENDPROC(___aeabi_idiv)
+#endif
 
 ENTRY(__modsi3)
 UNWIND(.fnstart)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

