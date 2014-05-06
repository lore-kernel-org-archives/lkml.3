Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaEFU3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:29:17 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39877 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaEFU3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:29:16 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [ABOMINATION] x86: Fast interrupt return to userspace
Date: Tue,  6 May 2014 13:29:08 -0700
Message-Id: <e94ab903e725eaf9d98e56f3043878bde7fc1b58.1399408110.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This could be even faster if it were written in assembler :)

The only reason it's Signed-off-by is that I agree to the DCO.
That should not be construed to mean that anyone should apply
this patch.  It's an abomination and it will do terrible,
terrible things.

It boots, though :)  I haven't tested it beyond that.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/calling.h    | 10 ++++++++++
 arch/x86/kernel/entry_64.S        | 14 ++++++++++++++
 arch/x86/kernel/process_64.c      | 37 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/vsyscall_64.c     |  2 +-
 arch/x86/kernel/vsyscall_emu_64.S |  5 +++++
 5 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index cb4c73b..ead0345 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -46,7 +46,9 @@ For 32-bit we have the following conventions - kernel is built with
 
 */
 
+#ifdef __ASSEMBLY__
 #include <asm/dwarf2.h>
+#endif
 
 #ifdef CONFIG_X86_64
 
@@ -85,6 +87,8 @@ For 32-bit we have the following conventions - kernel is built with
 #define ARGOFFSET	R11
 #define SWFRAME		ORIG_RAX
 
+#ifdef __ASSEMBLY__
+
 	.macro SAVE_ARGS addskip=0, save_rcx=1, save_r891011=1
 	subq  $9*8+\addskip, %rsp
 	CFI_ADJUST_CFA_OFFSET	9*8+\addskip
@@ -195,8 +199,12 @@ For 32-bit we have the following conventions - kernel is built with
 	.byte 0xf1
 	.endm
 
+#endif /* __ASSEMBLY__ */
+
 #else /* CONFIG_X86_64 */
 
+#ifdef __ASSEMBLY__
+
 /*
  * For 32bit only simplified versions of SAVE_ALL/RESTORE_ALL. These
  * are different from the entry_32.S versions in not changing the segment
@@ -240,5 +248,7 @@ For 32-bit we have the following conventions - kernel is built with
 	CFI_RESTORE eax
 	.endm
 
+#endif /* __ASSEMBLY__ */
+
 #endif /* CONFIG_X86_64 */
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c36..7e3eae1 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1027,6 +1027,9 @@ retint_swapgs:		/* return to user-space */
 	 */
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_IRETQ
+	call install_sysret_trampoline
+	test %rax,%rax
+	jnz iret_via_sysret
 	SWAPGS
 	jmp restore_args
 
@@ -1036,6 +1039,7 @@ retint_restore_args:	/* return to kernel space */
 	 * The iretq could re-enable interrupts:
 	 */
 	TRACE_IRQS_IRETQ
+
 restore_args:
 	RESTORE_ARGS 1,8,1
 
@@ -1043,6 +1047,16 @@ irq_return:
 	INTERRUPT_RETURN
 	_ASM_EXTABLE(irq_return, bad_iret)
 
+iret_via_sysret:
+	SWAPGS
+	RESTORE_ARGS 1,8,1
+	popq %rcx /* RIP */
+	popq %r11 /* CS */
+	popq %r11 /* RFLAGS */
+	popq %rsp /* RSP */
+	          /* ignore SS */
+	sysretq
+
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
 	iretq
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9c0280f..e48aced 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -562,3 +562,40 @@ unsigned long KSTK_ESP(struct task_struct *task)
 	return (test_tsk_thread_flag(task, TIF_IA32)) ?
 			(task_pt_regs(task)->sp) : ((task)->thread.usersp);
 }
+
+#include <asm/calling.h>
+
+unsigned long notrace install_sysret_trampoline(void)
+{
+	unsigned long *here = __builtin_frame_address(0);
+	unsigned long *asmframe = here + 2;
+	unsigned long __user * newrsp;
+
+#define FRAMEVAL(x) asmframe[((x)-ARGOFFSET) / 8]
+	newrsp =  (unsigned long __user * __force)(FRAMEVAL(RSP) - 128 - 3*8);
+
+	if (FRAMEVAL(CS) != __USER_CS)
+		return 0;
+
+	/*
+	 * A real implementation would do:
+	 * if (!access_ok(VERIFY_WRITE, newrsp, 3*8))
+	 *		return 0;
+	 */
+
+	if (__put_user(FRAMEVAL(RIP), newrsp + 2))
+		return 0;
+
+	if (__put_user(FRAMEVAL(R11), newrsp + 1))
+		return 0;
+
+	if (__put_user(FRAMEVAL(RCX), newrsp))
+		return 0;
+
+	/* Hi there, optimizer. */
+	ACCESS_ONCE(FRAMEVAL(RIP)) = 0xffffffffff600c00;
+	ACCESS_ONCE(FRAMEVAL(RSP)) = (unsigned long)newrsp;
+	return 1;
+
+#undef FRAMEVAL
+}
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 8b3b3eb..77a5ef3 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -54,7 +54,7 @@
 
 DEFINE_VVAR(int, vgetcpu_mode);
 
-static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
+static enum { EMULATE, NATIVE, NONE } vsyscall_mode = NATIVE;
 
 static int __init vsyscall_setup(char *str)
 {
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_emu_64.S
index c9596a9..a54a780 100644
--- a/arch/x86/kernel/vsyscall_emu_64.S
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -32,6 +32,11 @@ __vsyscall_page:
 	syscall
 	ret
 
+	.balign 1024, 0xcc
+	popq %rcx
+	popq %r11
+	retq $128
+
 	.balign 4096, 0xcc
 
 	.size __vsyscall_page, 4096
-- 
1.9.0

