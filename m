Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaEDTDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 15:03:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41994 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaEDTDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 15:03:45 -0400
Date: Sun, 4 May 2014 12:03:31 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-2179e94315ee3bcf406a682b8bbe2f27380bb7e9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <1398816946-3351-1-git-send-email-hpa@linux.intel.com>
References: <1398816946-3351-1-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/espfix] x86, espfix:
  Make it possible do disable 16-bit support
Git-Commit-ID: 2179e94315ee3bcf406a682b8bbe2f27380bb7e9
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

Commit-ID:  2179e94315ee3bcf406a682b8bbe2f27380bb7e9
Gitweb:     http://git.kernel.org/tip/2179e94315ee3bcf406a682b8bbe2f27380bb7e9
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Sun, 4 May 2014 10:36:22 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 4 May 2014 10:56:32 -0700

x86, espfix: Make it possible do disable 16-bit support

Embedded systems, which may be very memory-size-sensitive, are
extremely unlikely to ever encounter any 16-bit software, so make it
a CONFIG_EXPERT option to turn off support for any 16-bit software
whatsoever.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1398816946-3351-1-git-send-email-hpa@linux.intel.com
---
 arch/x86/Kconfig           | 23 ++++++++++++++++++-----
 arch/x86/kernel/entry_32.S | 12 ++++++++++++
 arch/x86/kernel/entry_64.S |  8 ++++++++
 arch/x86/kernel/ldt.c      |  5 +++++
 4 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9a952a5..956c770 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -909,14 +909,27 @@ config VM86
 	default y
 	depends on X86_32
 	---help---
-	  This option is required by programs like DOSEMU to run 16-bit legacy
-	  code on X86 processors. It also may be needed by software like
-	  XFree86 to initialize some video cards via BIOS. Disabling this
-	  option saves about 6k.
+	  This option is required by programs like DOSEMU to run
+	  16-bit real mode legacy code on x86 processors. It also may
+	  be needed by software like XFree86 to initialize some video
+	  cards via BIOS. Disabling this option saves about 6K.
+
+config X86_16BIT
+	bool "Enable support for 16-bit segments" if EXPERT
+	default y
+	---help---
+	  This option is required by programs like Wine to run 16-bit
+	  protected mode legacy code on x86 processors.  Disabling
+	  this option saves about 300 bytes on i386, or around 6K text
+	  plus 16K runtime memory on x86-64,
+
+config X86_ESPFIX32
+	def_bool y
+	depends on X86_16BIT && X86_32
 
 config X86_ESPFIX64
 	def_bool y
-	depends on X86_64
+	depends on X86_16BIT && X86_64
 
 config TOSHIBA
 	tristate "Toshiba Laptop support"
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 2780b8f..98313ff 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -527,6 +527,7 @@ syscall_exit:
 restore_all:
 	TRACE_IRQS_IRET
 restore_all_notrace:
+#ifdef CONFIG_X86_ESPFIX32
 	movl PT_EFLAGS(%esp), %eax	# mix EFLAGS, SS and CS
 	# Warning: PT_OLDSS(%esp) contains the wrong/random values if we
 	# are returning to the kernel.
@@ -537,6 +538,7 @@ restore_all_notrace:
 	cmpl $((SEGMENT_LDT << 8) | USER_RPL), %eax
 	CFI_REMEMBER_STATE
 	je ldt_ss			# returning to user-space with LDT SS
+#endif
 restore_nocheck:
 	RESTORE_REGS 4			# skip orig_eax/error_code
 irq_return:
@@ -549,6 +551,7 @@ ENTRY(iret_exc)
 .previous
 	_ASM_EXTABLE(irq_return,iret_exc)
 
+#ifdef CONFIG_X86_ESPFIX32
 	CFI_RESTORE_STATE
 ldt_ss:
 #ifdef CONFIG_PARAVIRT
@@ -592,6 +595,7 @@ ldt_ss:
 	lss (%esp), %esp		/* switch to espfix segment */
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp restore_nocheck
+#endif
 	CFI_ENDPROC
 ENDPROC(system_call)
 
@@ -699,6 +703,7 @@ END(syscall_badsys)
  * the high word of the segment base from the GDT and swiches to the
  * normal stack and adjusts ESP with the matching offset.
  */
+#ifdef CONFIG_X86_ESPFIX32
 	/* fixup the stack */
 	mov GDT_ESPFIX_SS + 4, %al /* bits 16..23 */
 	mov GDT_ESPFIX_SS + 7, %ah /* bits 24..31 */
@@ -708,8 +713,10 @@ END(syscall_badsys)
 	pushl_cfi %eax
 	lss (%esp), %esp		/* switch to the normal stack segment */
 	CFI_ADJUST_CFA_OFFSET -8
+#endif
 .endm
 .macro UNWIND_ESPFIX_STACK
+#ifdef CONFIG_X86_ESPFIX32
 	movl %ss, %eax
 	/* see if on espfix stack */
 	cmpw $__ESPFIX_SS, %ax
@@ -720,6 +727,7 @@ END(syscall_badsys)
 	/* switch to normal stack */
 	FIXUP_ESPFIX_STACK
 27:
+#endif
 .endm
 
 /*
@@ -1350,11 +1358,13 @@ END(debug)
 ENTRY(nmi)
 	RING0_INT_FRAME
 	ASM_CLAC
+#ifdef CONFIG_X86_ESPFIX32
 	pushl_cfi %eax
 	movl %ss, %eax
 	cmpw $__ESPFIX_SS, %ax
 	popl_cfi %eax
 	je nmi_espfix_stack
+#endif
 	cmpl $ia32_sysenter_target,(%esp)
 	je nmi_stack_fixup
 	pushl_cfi %eax
@@ -1394,6 +1404,7 @@ nmi_debug_stack_check:
 	FIX_STACK 24, nmi_stack_correct, 1
 	jmp nmi_stack_correct
 
+#ifdef CONFIG_X86_ESPFIX32
 nmi_espfix_stack:
 	/* We have a RING0_INT_FRAME here.
 	 *
@@ -1415,6 +1426,7 @@ nmi_espfix_stack:
 	lss 12+4(%esp), %esp		# back to espfix stack
 	CFI_ADJUST_CFA_OFFSET -24
 	jmp irq_return
+#endif
 	CFI_ENDPROC
 END(nmi)
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index bffaa98..da0b9bd 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1045,8 +1045,10 @@ irq_return:
 	 * Are we returning to a stack segment from the LDT?  Note: in
 	 * 64-bit mode SS:RSP on the exception stack is always valid.
 	 */
+#ifdef CONFIG_X86_ESPFIX64
 	testb $4,(SS-RIP)(%rsp)
 	jnz irq_return_ldt
+#endif
 
 irq_return_iret:
 	INTERRUPT_RETURN
@@ -1058,6 +1060,7 @@ ENTRY(native_iret)
 	_ASM_EXTABLE(native_iret, bad_iret)
 #endif
 
+#ifdef CONFIG_X86_ESPFIX64
 irq_return_ldt:
 	pushq_cfi %rax
 	pushq_cfi %rdi
@@ -1081,6 +1084,7 @@ irq_return_ldt:
 	movq %rax,%rsp
 	popq_cfi %rax
 	jmp irq_return_iret
+#endif
 
 	.section .fixup,"ax"
 bad_iret:
@@ -1152,6 +1156,7 @@ END(common_interrupt)
 	 * modify the stack to make it look like we just entered
 	 * the #GP handler from user space, similar to bad_iret.
 	 */
+#ifdef CONFIG_X86_ESPFIX64
 	ALIGN
 __do_double_fault:
 	XCPT_FRAME 1 RDI+8
@@ -1177,6 +1182,9 @@ __do_double_fault:
 	retq
 	CFI_ENDPROC
 END(__do_double_fault)
+#else
+# define __do_double_fault do_double_fault
+#endif
 
 /*
  * End of kprobes section
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index ebc9873..c37886d 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -229,6 +229,11 @@ static int write_ldt(void __user *ptr, unsigned long bytecount, int oldmode)
 		}
 	}
 
+	if (!IS_ENABLED(CONFIG_X86_16BIT) && !ldt_info.seg_32bit) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
 	fill_ldt(&ldt, &ldt_info);
 	if (oldmode)
 		ldt.avl = 0;
