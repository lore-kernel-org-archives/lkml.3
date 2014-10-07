Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaJGT1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:27:47 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:42427 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbaJGT1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:27:44 -0400
From: minyard@acm.org
To: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 1/3] mips: Save all registers when saving the frame
Date: Tue,  7 Oct 2014 14:27:12 -0500
Message-Id: <1412710034-16908-2-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1412710034-16908-1-git-send-email-minyard@acm.org>
References: <1412710034-16908-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

The MIPS frame save code was just saving a few registers, enough to
do a backtrace if every function set up a frame.  However, this is
not working if you are using DWARF unwinding, because most of the
registers are wrong.  This was causing kdump backtraces to be short
or bogus.

So save all the registers.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 arch/mips/include/asm/stacktrace.h | 64 +++++++++++++++++++++++++++++---------
 1 file changed, 50 insertions(+), 14 deletions(-)

diff --git a/arch/mips/include/asm/stacktrace.h b/arch/mips/include/asm/stacktrace.h
index 780ee2c..10c4e9c 100644
--- a/arch/mips/include/asm/stacktrace.h
+++ b/arch/mips/include/asm/stacktrace.h
@@ -2,6 +2,8 @@
 #define _ASM_STACKTRACE_H
 
 #include <asm/ptrace.h>
+#include <asm/asm.h>
+#include <linux/stringify.h>
 
 #ifdef CONFIG_KALLSYMS
 extern int raw_show_trace;
@@ -20,6 +22,14 @@ static inline unsigned long unwind_stack(struct task_struct *task,
 }
 #endif
 
+#define STR_PTR_LA    __stringify(PTR_LA)
+#define STR_LONG_S    __stringify(LONG_S)
+#define STR_LONG_L    __stringify(LONG_L)
+#define STR_LONGSIZE  __stringify(LONGSIZE)
+
+#define STORE_ONE_REG(r) \
+    STR_LONG_S   " $" __stringify(r)",("STR_LONGSIZE"*"__stringify(r)")(%1)\n\t"
+
 static __always_inline void prepare_frametrace(struct pt_regs *regs)
 {
 #ifndef CONFIG_KALLSYMS
@@ -32,21 +42,47 @@ static __always_inline void prepare_frametrace(struct pt_regs *regs)
 	__asm__ __volatile__(
 		".set push\n\t"
 		".set noat\n\t"
-#ifdef CONFIG_64BIT
-		"1: dla $1, 1b\n\t"
-		"sd $1, %0\n\t"
-		"sd $29, %1\n\t"
-		"sd $31, %2\n\t"
-#else
-		"1: la $1, 1b\n\t"
-		"sw $1, %0\n\t"
-		"sw $29, %1\n\t"
-		"sw $31, %2\n\t"
-#endif
+		/* Store $1 so we can use it */
+		STR_LONG_S " $1,"STR_LONGSIZE"(%1)\n\t"
+		/* Store the PC */
+		"1: " STR_PTR_LA " $1, 1b\n\t"
+		STR_LONG_S " $1,%0\n\t"
+		STORE_ONE_REG(2)
+		STORE_ONE_REG(3)
+		STORE_ONE_REG(4)
+		STORE_ONE_REG(5)
+		STORE_ONE_REG(6)
+		STORE_ONE_REG(7)
+		STORE_ONE_REG(8)
+		STORE_ONE_REG(9)
+		STORE_ONE_REG(10)
+		STORE_ONE_REG(11)
+		STORE_ONE_REG(12)
+		STORE_ONE_REG(13)
+		STORE_ONE_REG(14)
+		STORE_ONE_REG(15)
+		STORE_ONE_REG(16)
+		STORE_ONE_REG(17)
+		STORE_ONE_REG(18)
+		STORE_ONE_REG(19)
+		STORE_ONE_REG(20)
+		STORE_ONE_REG(21)
+		STORE_ONE_REG(22)
+		STORE_ONE_REG(23)
+		STORE_ONE_REG(24)
+		STORE_ONE_REG(25)
+		STORE_ONE_REG(26)
+		STORE_ONE_REG(27)
+		STORE_ONE_REG(28)
+		STORE_ONE_REG(29)
+		STORE_ONE_REG(30)
+		STORE_ONE_REG(31)
+		/* Restore $1 */
+		STR_LONG_L " $1,"STR_LONGSIZE"(%1)\n\t"
 		".set pop\n\t"
-		: "=m" (regs->cp0_epc),
-		"=m" (regs->regs[29]), "=m" (regs->regs[31])
-		: : "memory");
+		: "=m" (regs->cp0_epc)
+		: "r" (regs->regs)
+		: "memory");
 }
 
 #endif /* _ASM_STACKTRACE_H */
-- 
1.8.3.1

