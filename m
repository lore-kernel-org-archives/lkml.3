Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab3HGUk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:40:57 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60710 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab3HGUkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:40:55 -0400
Message-ID: <201308072040.r77KetU3016117@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 7 Aug 2013 12:11:56 -0400
Subject: [PATCH] tile: improve illegal translation interrupt handling
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, don't re-enable interrupts blindly in the Linux trap handler.
We already handle page faults this way; synchronous interrupts like
ILL_TRANS will fire even when interrupts are disabled, and we don't
want to re-enable interrupts in that case.

For ILL_TRANS, we now pass the ILL_VA_PC reason into the trap handler
so we can report it properly; this is the address that caused the
illegal translation trap.  We print the address as part of the
pr_alert() message now if it's coming from the kernel.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_64.S |  2 +-
 arch/tile/kernel/traps.c     | 25 +++++++++++++++----------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 8e7d6b8..3c63fbd 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -485,7 +485,7 @@ intvec_\vecname:
 	mfspr   r3, SPR_SYSTEM_SAVE_K_2   /* info about page fault */
 	.else
 	.ifc \vecnum, INT_ILL_TRANS
-	mfspr   r2, ILL_TRANS_REASON
+	mfspr   r2, ILL_VA_PC
 	.else
 	.ifc \vecnum, INT_DOUBLE_FAULT
 	mfspr   r2, SPR_SYSTEM_SAVE_K_2   /* double fault info from HV */
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index 5b19a23..a1bbc5de 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -222,8 +222,9 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 	unsigned long address = 0;
 	bundle_bits instr;
 
-	/* Re-enable interrupts. */
-	local_irq_enable();
+	/* Re-enable interrupts, if they were previously enabled. */
+	if (!(regs->flags & PT_FLAGS_DISABLE_IRQ))
+		local_irq_enable();
 
 	/*
 	 * If it hits in kernel mode and we can't fix it up, just exit the
@@ -231,7 +232,8 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 	 */
 	if (!user_mode(regs)) {
 		const char *name;
-		if (fixup_exception(regs))  /* only UNALIGN_DATA in practice */
+		char buf[100];
+		if (fixup_exception(regs))  /* ILL_TRANS or UNALIGN_DATA */
 			return;
 		if (fault_num >= 0 &&
 		    fault_num < sizeof(int_name)/sizeof(int_name[0]) &&
@@ -239,10 +241,16 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 			name = int_name[fault_num];
 		else
 			name = "Unknown interrupt";
-		pr_alert("Kernel took bad trap %d (%s) at PC %#lx\n",
-			 fault_num, name, regs->pc);
 		if (fault_num == INT_GPV)
-			pr_alert("GPV_REASON is %#lx\n", reason);
+			snprintf(buf, sizeof(buf), "; GPV_REASON %#lx", reason);
+#ifdef __tilegx__
+		else if (fault_num == INT_ILL_TRANS)
+			snprintf(buf, sizeof(buf), "; address %#lx", reason);
+#endif
+		else
+			buf[0] = '\0';
+		pr_alert("Kernel took bad trap %d (%s) at PC %#lx%s\n",
+			 fault_num, name, regs->pc, buf);
 		show_regs(regs);
 		do_exit(SIGKILL);  /* FIXME: implement i386 die() */
 		return;
@@ -324,11 +332,8 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 		fill_ra_stack();
 
 		signo = SIGSEGV;
+		address = reason;
 		code = SEGV_MAPERR;
-		if (reason & SPR_ILL_TRANS_REASON__I_STREAM_VA_RMASK)
-			address = regs->pc;
-		else
-			address = 0;  /* FIXME: GX: single-step for address */
 		break;
 	}
 #endif
-- 
1.8.3.1

