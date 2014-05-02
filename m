Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaEBXyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 19:54:08 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:42160 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaEBXyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 19:54:03 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2] x86: Return to kernel without IRET
Date: Fri,  2 May 2014 16:53:57 -0700
Message-Id: <6cfe29821979c42cd812878e05577f69f99fafaf.1399074748.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my box, this saves about 100ns on each interrupt and trap that
happens while running in kernel space.  This speeds up my kernel_pf
microbenchmark by about 17%.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Changes from v1:
 - Comment fix *facepalm*

Changes from the RFC:
 - Much better comments
 - Rewritten to use popq_cfi directly instead of RESTORE_ARGS
 - Uses sti to restore IF so we get the interrupt shadow

 arch/x86/kernel/entry_64.S | 49 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c36..504cec5 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1033,9 +1033,56 @@ retint_swapgs:		/* return to user-space */
 retint_restore_args:	/* return to kernel space */
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	/*
-	 * The iretq could re-enable interrupts:
+	 * The sti could re-enable interrupts:
 	 */
 	TRACE_IRQS_IRETQ
+
+	/*
+	 * Fast return to kernel.  The stack looks like:
+	 *
+	 * previous frame
+	 * possible 8 byte gap for alignment
+	 * SS RSP EFLAGS CS RIP
+	 * ORIG_RAX RDI ... R11
+	 *
+	 * We rewrite it to:
+	 *
+	 * previous frame
+	 * RIP (EFLAGS & ~IF) ...
+	 * pointer to the EFLAGS slot
+	 * RDI ... R11
+	 */
+	movq RSP-ARGOFFSET(%rsp), %rsi
+	subq $16, %rsi
+	movq EFLAGS-ARGOFFSET(%rsp), %rdi
+	movq RIP-ARGOFFSET(%rsp), %rcx
+	btr $9, %rdi
+	movq %rdi, (%rsi)
+	movq %rcx, 8(%rsi)
+	movq %rsi, ORIG_RAX-ARGOFFSET(%rsp)
+	popq_cfi %r11
+	popq_cfi %r10
+	popq_cfi %r9
+	popq_cfi %r8
+	popq_cfi %rax
+	popq_cfi %rcx
+	popq_cfi %rdx
+	popq_cfi %rsi
+	popq_cfi %rdi
+
+	popq %rsp
+	jc 1f
+	/* Interrupts were not enabled */
+	popfq_cfi
+	retq
+1:
+	CFI_ADJUST_CFA_OFFSET 8
+	/* Interrupts were enabled */
+	popfq_cfi
+	sti
+	/* Interrupts are still off because of the one-insn grace period. */
+	retq
+
 restore_args:
 	RESTORE_ARGS 1,8,1
 
-- 
1.9.0

