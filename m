Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaEBTEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:04:23 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50584 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaEBTER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:04:17 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [RFC/HACK] x86: Fast return to kernel
Date: Fri,  2 May 2014 12:04:12 -0700
Message-Id: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This speeds up my kernel_pf microbenchmark by about 17%.  The cfi
annotations need some work.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

My test case is here:

https://gitorious.org/linux-test-utils/linux-clock-tests/source/kernel_pf.c

This could have some other interesting benefits.  For example, pages faults
that happen during an NMI might not re-enable NMIs.

 arch/x86/kernel/entry_64.S | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c36..922a057 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1033,9 +1033,24 @@ retint_swapgs:		/* return to user-space */
 retint_restore_args:	/* return to kernel space */
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	/*
-	 * The iretq could re-enable interrupts:
+	 * The popfq could re-enable interrupts:
 	 */
 	TRACE_IRQS_IRETQ
+
+	/* Fast return to kernel. */
+	movq RSP-ARGOFFSET(%rsp), %rsi
+	subq $16, %rsi
+	movq EFLAGS-ARGOFFSET(%rsp), %rdi
+	movq %rdi, (%rsi)
+	movq RIP-ARGOFFSET(%rsp), %rdi
+	movq %rdi, 8(%rsi)
+	movq %rsi, RIP-ARGOFFSET(%rsp)
+	RESTORE_ARGS 1,8,1
+	popq %rsp
+	popfq
+	/* Interrupts are still off because of the one-insn grace period. */
+	retq
+
 restore_args:
 	RESTORE_ARGS 1,8,1
 
-- 
1.9.0

