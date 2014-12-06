Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaLFPTo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:19:44 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47674 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752213AbaLFPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 14/66] x86_64, traps: Stop using IST for #SS
Date: Sat,  6 Dec 2014 16:07:06 +0100
Message-Id: <e40598270a40040461c8b8d3a8656d54fb59b9cd.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6f442be2fb22be02cafa606f1769fa1e6f894441 upstream.

On a 32-bit kernel, this has no effect, since there are no IST stacks.

On a 64-bit kernel, #SS can only happen in user code, on a failed iret
to user space, a canonical violation on access via RSP or RBP, or a
genuine stack segment violation in 32-bit kernel code.  The first two
cases don't need IST, and the latter two cases are unlikely fatal bugs,
and promoting them to double faults would be fine.

This fixes a bug in which the espfix64 code mishandles a stack segment
violation.

This saves 4k of memory per CPU and a tiny bit of code.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/include/asm/page_32_types.h |  1 -
 arch/x86/include/asm/page_64_types.h | 11 +++++------
 arch/x86/kernel/dumpstack_64.c       |  1 -
 arch/x86/kernel/entry_64.S           |  2 +-
 arch/x86/kernel/traps.c              | 18 +-----------------
 5 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/page_32_types.h
index f48b17df4224..3a52ee0e726d 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
@@ -20,7 +20,6 @@
 #define THREAD_SIZE_ORDER	1
 #define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
 
-#define STACKFAULT_STACK 0
 #define DOUBLEFAULT_STACK 1
 #define NMI_STACK 0
 #define DEBUG_STACK 0
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 43dcd804ebd5..d1d2972a54db 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -14,12 +14,11 @@
 #define IRQ_STACK_ORDER 2
 #define IRQ_STACK_SIZE (PAGE_SIZE << IRQ_STACK_ORDER)
 
-#define STACKFAULT_STACK 1
-#define DOUBLEFAULT_STACK 2
-#define NMI_STACK 3
-#define DEBUG_STACK 4
-#define MCE_STACK 5
-#define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
+#define DOUBLEFAULT_STACK 1
+#define NMI_STACK 2
+#define DEBUG_STACK 3
+#define MCE_STACK 4
+#define N_EXCEPTION_STACKS 4  /* hw limit: 7 */
 
 #define PUD_PAGE_SIZE		(_AC(1, UL) << PUD_SHIFT)
 #define PUD_PAGE_MASK		(~(PUD_PAGE_SIZE-1))
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index addb207dab92..66e274a3d968 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -24,7 +24,6 @@ static char x86_stack_ids[][8] = {
 		[ DEBUG_STACK-1			]	= "#DB",
 		[ NMI_STACK-1			]	= "NMI",
 		[ DOUBLEFAULT_STACK-1		]	= "#DF",
-		[ STACKFAULT_STACK-1		]	= "#SS",
 		[ MCE_STACK-1			]	= "#MC",
 #if DEBUG_STKSZ > EXCEPTION_STKSZ
 		[ N_EXCEPTION_STACKS ...
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c2ab43484b5d..e310e82de5e6 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1510,7 +1510,7 @@ apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
 
 paranoidzeroentry_ist debug do_debug DEBUG_STACK
 paranoidzeroentry_ist int3 do_int3 DEBUG_STACK
-paranoiderrorentry stack_segment do_stack_segment
+errorentry stack_segment do_stack_segment
 #ifdef CONFIG_XEN
 zeroentry xen_debug do_debug
 zeroentry xen_int3 do_int3
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8a2684f938b9..b2d6c58b28b0 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -221,28 +221,12 @@ DO_ERROR(X86_TRAP_OLD_MF, SIGFPE, "coprocessor segment overrun",
 		coprocessor_segment_overrun)
 DO_ERROR(X86_TRAP_TS, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(X86_TRAP_NP, SIGBUS, "segment not present", segment_not_present)
-#ifdef CONFIG_X86_32
 DO_ERROR(X86_TRAP_SS, SIGBUS, "stack segment", stack_segment)
-#endif
 DO_ERROR_INFO(X86_TRAP_AC, SIGBUS, "alignment check", alignment_check,
 		BUS_ADRALN, 0)
 
 #ifdef CONFIG_X86_64
 /* Runs on IST stack */
-dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
-{
-	enum ctx_state prev_state;
-
-	prev_state = exception_enter();
-	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
-		       X86_TRAP_SS, SIGBUS) != NOTIFY_STOP) {
-		preempt_conditional_sti(regs);
-		do_trap(X86_TRAP_SS, SIGBUS, "stack segment", regs, error_code, NULL);
-		preempt_conditional_cli(regs);
-	}
-	exception_exit(prev_state);
-}
-
 dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 {
 	static const char str[] = "double fault";
@@ -776,7 +760,7 @@ void __init trap_init(void)
 	set_intr_gate(X86_TRAP_OLD_MF, &coprocessor_segment_overrun);
 	set_intr_gate(X86_TRAP_TS, &invalid_TSS);
 	set_intr_gate(X86_TRAP_NP, &segment_not_present);
-	set_intr_gate_ist(X86_TRAP_SS, &stack_segment, STACKFAULT_STACK);
+	set_intr_gate(X86_TRAP_SS, stack_segment);
 	set_intr_gate(X86_TRAP_GP, &general_protection);
 	set_intr_gate(X86_TRAP_SPURIOUS, &spurious_interrupt_bug);
 	set_intr_gate(X86_TRAP_MF, &coprocessor_error);
-- 
2.1.3

