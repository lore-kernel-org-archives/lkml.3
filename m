Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161008Ab3FGXJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:09:41 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61402 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674Ab3FGXDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:52 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 17/31] MIPS: Quit exposing Kconfig symbols in uapi headers.
Date: Fri,  7 Jun 2013 16:03:21 -0700
Message-Id: <1370646215-6543-18-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The kernel's struct pt_regs has many fields conditional on various
Kconfig variables, we cannot be exporting this garbage to user-space.

Move the kernel's definition to asm/ptrace.h, and put a uapi only
version in uapi/asm/ptrace.h gated by #ifndef __KERNEL__

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/ptrace.h      | 32 ++++++++++++++++++++++++++++++++
 arch/mips/include/uapi/asm/ptrace.h | 17 ++---------------
 2 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
index a3186f2..5e6cd09 100644
--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -16,6 +16,38 @@
 #include <asm/isadep.h>
 #include <uapi/asm/ptrace.h>
 
+/*
+ * This struct defines the way the registers are stored on the stack during a
+ * system call/exception. As usual the registers k0/k1 aren't being saved.
+ */
+struct pt_regs {
+#ifdef CONFIG_32BIT
+	/* Pad bytes for argument save space on the stack. */
+	unsigned long pad0[6];
+#endif
+
+	/* Saved main processor registers. */
+	unsigned long regs[32];
+
+	/* Saved special registers. */
+	unsigned long cp0_status;
+	unsigned long hi;
+	unsigned long lo;
+#ifdef CONFIG_CPU_HAS_SMARTMIPS
+	unsigned long acx;
+#endif
+	unsigned long cp0_badvaddr;
+	unsigned long cp0_cause;
+	unsigned long cp0_epc;
+#ifdef CONFIG_MIPS_MT_SMTC
+	unsigned long cp0_tcstatus;
+#endif /* CONFIG_MIPS_MT_SMTC */
+#ifdef CONFIG_CPU_CAVIUM_OCTEON
+	unsigned long long mpl[3];	  /* MTM{0,1,2} */
+	unsigned long long mtp[3];	  /* MTP{0,1,2} */
+#endif
+} __aligned(8);
+
 struct task_struct;
 
 extern int ptrace_getregs(struct task_struct *child, __s64 __user *data);
diff --git a/arch/mips/include/uapi/asm/ptrace.h b/arch/mips/include/uapi/asm/ptrace.h
index 4d58d84..b26f7e3 100644
--- a/arch/mips/include/uapi/asm/ptrace.h
+++ b/arch/mips/include/uapi/asm/ptrace.h
@@ -22,16 +22,12 @@
 #define DSP_CONTROL	77
 #define ACX		78
 
+#ifndef __KERNEL__
 /*
  * This struct defines the way the registers are stored on the stack during a
  * system call/exception. As usual the registers k0/k1 aren't being saved.
  */
 struct pt_regs {
-#ifdef CONFIG_32BIT
-	/* Pad bytes for argument save space on the stack. */
-	unsigned long pad0[6];
-#endif
-
 	/* Saved main processor registers. */
 	unsigned long regs[32];
 
@@ -39,20 +35,11 @@ struct pt_regs {
 	unsigned long cp0_status;
 	unsigned long hi;
 	unsigned long lo;
-#ifdef CONFIG_CPU_HAS_SMARTMIPS
-	unsigned long acx;
-#endif
 	unsigned long cp0_badvaddr;
 	unsigned long cp0_cause;
 	unsigned long cp0_epc;
-#ifdef CONFIG_MIPS_MT_SMTC
-	unsigned long cp0_tcstatus;
-#endif /* CONFIG_MIPS_MT_SMTC */
-#ifdef CONFIG_CPU_CAVIUM_OCTEON
-	unsigned long long mpl[3];	  /* MTM{0,1,2} */
-	unsigned long long mtp[3];	  /* MTP{0,1,2} */
-#endif
 } __attribute__ ((aligned (8)));
+#endif /* __KERNEL__ */
 
 /* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
 #define PTRACE_GETREGS		12
-- 
1.7.11.7

