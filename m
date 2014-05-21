Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaEUWH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:07:56 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37730 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbaEUWHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:07:20 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/3] x86_64: Merge most 64-bit asm entry macros
Date: Wed, 21 May 2014 15:07:08 -0700
Message-Id: <e7a6acfb130471700370e77af9e4b4b6ed46f5ef.1400709717.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1400709717.git.luto@amacapital.net>
References: <cover.1400709717.git.luto@amacapital.net>
In-Reply-To: <cover.1400709717.git.luto@amacapital.net>
References: <cover.1400709717.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't touched the device interrupt code, which is different
enough that it's probably not worth merging, and I haven't done
anything about paranoidzeroentry_ist yet.

This appears to produce an entry_64.o file that differs only in the
debug info line numbers.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/entry_64.S | 152 +++++++++++++++++++--------------------------
 1 file changed, 64 insertions(+), 88 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 39372ec..eac9b81 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -36,7 +36,7 @@
  * - FIXUP_TOP_OF_STACK/RESTORE_TOP_OF_STACK - Fix up the hardware stack
  * frame that is otherwise undefined after a SYSCALL
  * - TRACE_IRQ_* - Trace hard interrupt state for lock debugging.
- * - errorentry/paranoidentry/zeroentry - Define exception entry points.
+ * - idtentry - Define exception entry points.
  */
 
 #include <linux/linkage.h>
@@ -1203,39 +1203,53 @@ apicinterrupt IRQ_WORK_VECTOR \
 /*
  * Exception entry points.
  */
-.macro zeroentry sym do_sym
+.macro idtentry sym do_sym has_error_code:req paranoid=0
 ENTRY(\sym)
+	.if \has_error_code
+	XCPT_FRAME
+	.else
 	INTR_FRAME
-	ASM_CLAC
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
-	subq $ORIG_RAX-R15, %rsp
-	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
-	call error_entry
-	DEFAULT_FRAME 0
-	movq %rsp,%rdi		/* pt_regs pointer */
-	xorl %esi,%esi		/* no error code */
-	call \do_sym
-	jmp error_exit		/* %ebx: no swapgs flag */
-	CFI_ENDPROC
-END(\sym)
-.endm
+	.endif
 
-.macro paranoidzeroentry sym do_sym
-ENTRY(\sym)
-	INTR_FRAME
 	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
+
+	.ifeq \has_error_code
+	pushq_cfi $-1			/* ORIG_RAX: no syscall to restart */
+	.endif
+
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
+
+	.if \paranoid
 	call save_paranoid
+	.else
+	call error_entry
+	.endif
+
 	DEFAULT_FRAME 0
+
+	.if \paranoid
 	TRACE_IRQS_OFF
-	movq %rsp,%rdi		/* pt_regs pointer */
-	xorl %esi,%esi		/* no error code */
+	.endif
+
+	movq %rsp,%rdi			/* pt_regs pointer */
+
+	.if \has_error_code
+	movq ORIG_RAX(%rsp),%rsi	/* get error code */
+	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
+	.else
+	xorl %esi,%esi			/* no error code */
+	.endif
+
 	call \do_sym
-	jmp paranoid_exit	/* %ebx: no swapgs flag */
+
+	.if \paranoid
+	jmp paranoid_exit		/* %ebx: no swapgs flag */
+	.else
+	jmp error_exit			/* %ebx: no swapgs flag */
+	.endif
+
 	CFI_ENDPROC
 END(\sym)
 .endm
@@ -1262,68 +1276,30 @@ ENTRY(\sym)
 END(\sym)
 .endm
 
-.macro errorentry sym do_sym
-ENTRY(\sym)
-	XCPT_FRAME
-	ASM_CLAC
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	subq $ORIG_RAX-R15, %rsp
-	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
-	call error_entry
-	DEFAULT_FRAME 0
-	movq %rsp,%rdi			/* pt_regs pointer */
-	movq ORIG_RAX(%rsp),%rsi	/* get error code */
-	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
-	call \do_sym
-	jmp error_exit			/* %ebx: no swapgs flag */
-	CFI_ENDPROC
-END(\sym)
-.endm
-
 #ifdef CONFIG_TRACING
-.macro trace_errorentry sym do_sym
-errorentry trace(\sym) trace(\do_sym)
-errorentry \sym \do_sym
+.macro trace_idtentry sym do_sym has_error_code:req
+idtentry trace(\sym) trace(\do_sym) has_error_code=\has_error_code
+idtentry \sym \do_sym has_error_code=\has_error_code
 .endm
 #else
-.macro trace_errorentry sym do_sym
-errorentry \sym \do_sym
+.macro trace_idtentry sym do_sym has_error_code:req
+idtentry \sym \do_sym has_error_code=\has_error_code
 .endm
 #endif
 
-	/* error code is on the stack already */
-.macro paranoiderrorentry sym do_sym
-ENTRY(\sym)
-	XCPT_FRAME
-	ASM_CLAC
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	subq $ORIG_RAX-R15, %rsp
-	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
-	call save_paranoid
-	DEFAULT_FRAME 0
-	TRACE_IRQS_OFF
-	movq %rsp,%rdi			/* pt_regs pointer */
-	movq ORIG_RAX(%rsp),%rsi	/* get error code */
-	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
-	call \do_sym
-	jmp paranoid_exit		/* %ebx: no swapgs flag */
-	CFI_ENDPROC
-END(\sym)
-.endm
-
-zeroentry divide_error do_divide_error
-zeroentry overflow do_overflow
-zeroentry bounds do_bounds
-zeroentry invalid_op do_invalid_op
-zeroentry device_not_available do_device_not_available
-paranoiderrorentry double_fault do_double_fault
-zeroentry coprocessor_segment_overrun do_coprocessor_segment_overrun
-errorentry invalid_TSS do_invalid_TSS
-errorentry segment_not_present do_segment_not_present
-zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
-zeroentry coprocessor_error do_coprocessor_error
-errorentry alignment_check do_alignment_check
-zeroentry simd_coprocessor_error do_simd_coprocessor_error
+idtentry divide_error do_divide_error has_error_code=0
+idtentry overflow do_overflow has_error_code=0
+idtentry bounds do_bounds has_error_code=0
+idtentry invalid_op do_invalid_op has_error_code=0
+idtentry device_not_available do_device_not_available has_error_code=0
+idtentry double_fault do_double_fault has_error_code=1 paranoid=1
+idtentry coprocessor_segment_overrun do_coprocessor_segment_overrun has_error_code=0
+idtentry invalid_TSS do_invalid_TSS has_error_code=1
+idtentry segment_not_present do_segment_not_present has_error_code=1
+idtentry spurious_interrupt_bug do_spurious_interrupt_bug has_error_code=0
+idtentry coprocessor_error do_coprocessor_error has_error_code=0
+idtentry alignment_check do_alignment_check has_error_code=1
+idtentry simd_coprocessor_error do_simd_coprocessor_error has_error_code=0
 
 
 	/* Reload gs selector with exception handling */
@@ -1373,7 +1349,7 @@ ENTRY(do_softirq_own_stack)
 END(do_softirq_own_stack)
 
 #ifdef CONFIG_XEN
-zeroentry xen_hypervisor_callback xen_do_hypervisor_callback
+idtentry xen_hypervisor_callback xen_do_hypervisor_callback has_error_code=0
 
 /*
  * A note on the "critical region" in our callback handler.
@@ -1486,19 +1462,19 @@ apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
 
 paranoidzeroentry_ist debug do_debug DEBUG_STACK
 paranoidzeroentry_ist int3 do_int3 DEBUG_STACK
-paranoiderrorentry stack_segment do_stack_segment
+idtentry stack_segment do_stack_segment has_error_code=1 paranoid=1
 #ifdef CONFIG_XEN
-zeroentry xen_debug do_debug
-zeroentry xen_int3 do_int3
-errorentry xen_stack_segment do_stack_segment
+idtentry xen_debug do_debug has_error_code=0
+idtentry xen_int3 do_int3 has_error_code=0
+idtentry xen_stack_segment do_stack_segment has_error_code=1
 #endif
-errorentry general_protection do_general_protection
-trace_errorentry page_fault do_page_fault
+idtentry general_protection do_general_protection has_error_code=1
+trace_idtentry page_fault do_page_fault has_error_code=1
 #ifdef CONFIG_KVM_GUEST
-errorentry async_page_fault do_async_page_fault
+idtentry async_page_fault do_async_page_fault has_error_code=1
 #endif
 #ifdef CONFIG_X86_MCE
-paranoidzeroentry machine_check *machine_check_vector(%rip)
+idtentry machine_check has_error_code=0 paranoid=1 do_sym=*machine_check_vector(%rip)
 #endif
 
 	/*
-- 
1.9.0

