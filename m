Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaEUWH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:07:29 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46192 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaEUWHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:07:22 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3/3] x86_64: Merge paranoidzeroentry_ist into idtentry
Date: Wed, 21 May 2014 15:07:09 -0700
Message-Id: <f54854f07ff3be8162b166124dbead23feeefe10.1400709717.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1400709717.git.luto@amacapital.net>
References: <cover.1400709717.git.luto@amacapital.net>
In-Reply-To: <cover.1400709717.git.luto@amacapital.net>
References: <cover.1400709717.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more specialized entry function is now gone.  Again, this seems
to only change line numbers in entry_64.o.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/entry_64.S | 47 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index eac9b81..be846d2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1203,8 +1203,15 @@ apicinterrupt IRQ_WORK_VECTOR \
 /*
  * Exception entry points.
  */
-.macro idtentry sym do_sym has_error_code:req paranoid=0
+#define INIT_TSS_IST(x) PER_CPU_VAR(init_tss) + (TSS_ist + ((x) - 1) * 8)
+
+.macro idtentry sym do_sym has_error_code:req paranoid=0 shift_ist=-1
 ENTRY(\sym)
+	/* Sanity check */
+	.if \shift_ist != -1 && \paranoid == 0
+	.error "using shift_ist requires paranoid=1"
+	.endif
+
 	.if \has_error_code
 	XCPT_FRAME
 	.else
@@ -1230,8 +1237,12 @@ ENTRY(\sym)
 	DEFAULT_FRAME 0
 
 	.if \paranoid
+	.if \shift_ist != -1
+	TRACE_IRQS_OFF_DEBUG		/* reload IDT in case of recursion */
+	.else
 	TRACE_IRQS_OFF
 	.endif
+	.endif
 
 	movq %rsp,%rdi			/* pt_regs pointer */
 
@@ -1242,8 +1253,16 @@ ENTRY(\sym)
 	xorl %esi,%esi			/* no error code */
 	.endif
 
+	.if \shift_ist != -1
+	subq $EXCEPTION_STKSZ, INIT_TSS_IST(\shift_ist)
+	.endif
+
 	call \do_sym
 
+	.if \shift_ist != -1
+	addq $EXCEPTION_STKSZ, INIT_TSS_IST(\shift_ist)
+	.endif
+
 	.if \paranoid
 	jmp paranoid_exit		/* %ebx: no swapgs flag */
 	.else
@@ -1254,28 +1273,6 @@ ENTRY(\sym)
 END(\sym)
 .endm
 
-#define INIT_TSS_IST(x) PER_CPU_VAR(init_tss) + (TSS_ist + ((x) - 1) * 8)
-.macro paranoidzeroentry_ist sym do_sym ist
-ENTRY(\sym)
-	INTR_FRAME
-	ASM_CLAC
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
-	subq $ORIG_RAX-R15, %rsp
-	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
-	call save_paranoid
-	DEFAULT_FRAME 0
-	TRACE_IRQS_OFF_DEBUG
-	movq %rsp,%rdi		/* pt_regs pointer */
-	xorl %esi,%esi		/* no error code */
-	subq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
-	call \do_sym
-	addq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
-	jmp paranoid_exit	/* %ebx: no swapgs flag */
-	CFI_ENDPROC
-END(\sym)
-.endm
-
 #ifdef CONFIG_TRACING
 .macro trace_idtentry sym do_sym has_error_code:req
 idtentry trace(\sym) trace(\do_sym) has_error_code=\has_error_code
@@ -1460,8 +1457,8 @@ apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
  */
 	.pushsection .kprobes.text, "ax"
 
-paranoidzeroentry_ist debug do_debug DEBUG_STACK
-paranoidzeroentry_ist int3 do_int3 DEBUG_STACK
+idtentry debug do_debug has_error_code=0 paranoid=1 shift_ist=DEBUG_STACK
+idtentry int3 do_int3 has_error_code=0 paranoid=1 shift_ist=DEBUG_STACK
 idtentry stack_segment do_stack_segment has_error_code=1 paranoid=1
 #ifdef CONFIG_XEN
 idtentry xen_debug do_debug has_error_code=0
-- 
1.9.0

