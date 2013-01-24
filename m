Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3AXK43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:56:29 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:47266 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3AXKyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:54:52 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v3 21/71] ARC: [Review] Preparing to fix incorrect syscall restarts due to signals
Date: Thu, 24 Jan 2013 16:20:23 +0530
Message-ID: <1359024639-21915-10-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid multiple syscall restarts (multiple signals) or no restart at
all (sigreturn), we need just an extra bit of state "literally 1 bit" in
struct pt_regs. orig_r8 is the best place to do this, however given the
way it is encoded currently, we can't add anything simplistically.

Current orig_r8:
* syscalls   -> 1 to NR_SYSCALLS
* Exceptions -> NR_SYSCALLS + 1
* Break-point-> NR_SYSCALLS + 2

In new scheme it is a bit-field
* lower short word contains the  exact event type (and a new bit to represent
   restart semantics : if syscall was already / can't be restarted)
* upper short word optionally containing the syscall num - needed by
  likes of tracehooks etc

This patch only changes how orig_r8 is organised and nothing should
change behaviourily.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 arch/arc/include/asm/entry.h  |   29 +++++++++++++++++------------
 arch/arc/include/asm/ptrace.h |   20 ++++++++++++++++----
 arch/arc/kernel/entry.S       |    4 ++--
 3 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/arch/arc/include/asm/entry.h b/arch/arc/include/asm/entry.h
index 6b42bf5..9eada5b 100644
--- a/arch/arc/include/asm/entry.h
+++ b/arch/arc/include/asm/entry.h
@@ -343,18 +343,12 @@
  *-------------------------------------------------------------*/
 .macro SAVE_ALL_EXCEPTION   marker
 
+	st      \marker, [sp, 8]
+	st      r0, [sp, 4]    /* orig_r0, needed only for sys calls */
+
 	/* Restore r9 used to code the early prologue */
 	EXCPN_PROLOG_RESTORE_REG  r9
 
-	/* Save the complete regfile now */
-
-	/* orig_r8 marker:
-	 * syscalls   -> 1 to NR_SYSCALLS
-	 * Exceptions -> NR_SYSCALLS + 1
-	 * Break-point-> NR_SYSCALLS + 2
-	 */
-	st      \marker, [sp, 8]
-	st      r0, [sp, 4]    /* orig_r0, needed only for sys calls */
 	SAVE_CALLER_SAVED
 	st.a    r26, [sp, -4]   /* gp */
 	st.a    fp, [sp, -4]
@@ -384,14 +378,25 @@
  * Save scratch regs for exceptions
  *-------------------------------------------------------------*/
 .macro SAVE_ALL_SYS
-	SAVE_ALL_EXCEPTION  (NR_syscalls + 1)
+	SAVE_ALL_EXCEPTION  orig_r8_IS_EXCPN
 .endm
 
 /*--------------------------------------------------------------
  * Save scratch regs for sys calls
  *-------------------------------------------------------------*/
 .macro SAVE_ALL_TRAP
-	SAVE_ALL_EXCEPTION  r8
+	/*
+	 * Setup pt_regs->orig_r8.
+	 * Encode syscall number (r8) in upper short word of event type (r9)
+	 * N.B. #1: This is already endian safe (see ptrace.h)
+	 *      #2: Only r9 can be used as scratch as it is already clobbered
+	 *          and it's contents are no longer needed by the latter part
+	 *          of exception prologue
+	 */
+	lsl  r9, r8, 16
+	or   r9, r9, orig_r8_IS_SCALL
+
+	SAVE_ALL_EXCEPTION  r9
 .endm
 
 /*--------------------------------------------------------------
@@ -442,7 +447,7 @@
 	ld  r9, [@int1_saved_reg]
 
 	/* now we are ready to save the remaining context :) */
-	st     -1, [sp, 8]    /* orig_r8, -1 for interuppt level one */
+	st      orig_r8_IS_IRQ1, [sp, 8]    /* Event Type */
 	st      0, [sp, 4]    /* orig_r0 , N/A for IRQ */
 	SAVE_CALLER_SAVED
 	st.a    r26, [sp, -4]   /* gp */
diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index 72754a2..1711d56 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -81,7 +81,13 @@ struct pt_regs {
 	long r0;
 	long sp;	/* user/kernel sp depending on where we came from  */
 	long orig_r0;
-	long orig_r8;	/*to distinguish bet excp, sys call, int1 or int2 */
+	/*to distinguish bet excp, syscall, irq */
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	/* so that assembly code is same for LE/BE */
+	unsigned long orig_r8:16, event:16;
+#else
+	unsigned long event:16, orig_r8:16;
+#endif
 };
 
 /* Callee saved registers - need to be saved only when you are scheduled out */
@@ -126,9 +132,8 @@ struct user_regs_struct {
 	sp;			\
 })
 
-/* return 1 if in syscall, 0 if Intr or Exception */
-#define in_syscall(regs) (((regs->orig_r8) >= 0 && \
-			   (regs->orig_r8 <= NR_syscalls)) ? 1 : 0)
+#define in_syscall(regs)    (regs->event & orig_r8_IS_SCALL)
+#define in_brkpt_trap(regs) (regs->event & orig_r8_IS_BRKPT)
 
 #define current_pt_regs()					\
 ({								\
@@ -140,6 +145,13 @@ struct user_regs_struct {
 
 #endif /* !__ASSEMBLY__ */
 
+#define orig_r8_IS_SCALL		0x0001
+#define orig_r8_IS_SCALL_RESTARTED	0x0002
+#define orig_r8_IS_BRKPT		0x0004
+#define orig_r8_IS_EXCPN		0x0004
+#define orig_r8_IS_IRQ1			0x0010
+#define orig_r8_IS_IRQ2			0x0020
+
 #endif /* __KERNEL__ */
 
 #endif /* __ASM_PTRACE_H */
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index d625b77..ce8670d 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -350,8 +350,8 @@ ARC_EXIT EV_Extension
 
 trap_with_param:
 
-	;make sure orig_r8 is a positive value
-	st  NR_syscalls + 2, [sp, PT_orig_r8]
+	; stop_pc info by gdb needs this info
+	st  orig_r8_IS_BRKPT, [sp, PT_orig_r8]
 
 	mov r0, r12
 	lr  r1, [efa]
-- 
1.7.4.1

