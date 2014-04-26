Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaDZR34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 13:29:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbaDZR3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 13:29:48 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [RFC PATCH] uprobes: simplify rip-relative handling
Date: Sat, 26 Apr 2014 19:29:30 +0200
Message-Id: <1398533370-8865-2-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1398533370-8865-1-git-send-email-dvlasenk@redhat.com>
References: <1398533370-8865-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to replace rip-relative addressing mode
with addressing mode of the same length: [reg+disp32].
This eliminates the need to fix up immediate.

Only

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Jim Keniston <jkenisto@us.ibm.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/uprobes.h |  2 +-
 arch/x86/kernel/uprobes.c      | 30 +++++++++++++-----------------
 2 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 93bee7b..9197119 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -46,7 +46,7 @@ struct arch_uprobe {
 
 	union {
 #ifdef CONFIG_X86_64
-		unsigned long			rip_rela_target_address;
+		int				insn_length;
 #endif
 		struct {
 			s32	offs;
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 7021dbe..b461dda 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -349,7 +349,7 @@ static int validate_insn_32bits(struct arch_uprobe *auprobe, struct insn *insn)
  * If arch_uprobe->insn doesn't use rip-relative addressing, return
  * immediately.  Otherwise, rewrite the instruction so that it accesses
  * its memory operand indirectly through a scratch register.  Set
- * arch_uprobe->fixups and arch_uprobe->rip_rela_target_address
+ * arch_uprobe->fixups and arch_uprobe->insn_length
  * accordingly.  (The contents of the scratch register will be saved
  * before we single-step the modified instruction, and restored
  * afterward.)
@@ -395,9 +395,12 @@ handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
 	insn_get_length(insn);
 
 	/*
-	 * Convert from rip-relative addressing to indirect addressing
+	 * Convert from rip-relative addressing to register-relative addressing
 	 * via a scratch register.  Change the r/m field from 0x5 (%rip)
-	 * to 0x0 (%rax) or 0x1 (%rcx), and squeeze out the offset field.
+	 * to 0x0 (%rax) or 0x1 (%rcx), change mode field
+	 * from 00 to 10 (reg+disp32). Example:
+	 * 89 05 disp32  mov %eax,disp32(%rip) becomes
+	 * 89 81 disp32  mov %eax,disp32(%rcx)
 	 */
 	reg = MODRM_REG(insn);
 	if (reg == 0) {
@@ -409,23 +412,16 @@ handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
 		 * #1) for the scratch register.
 		 */
 		auprobe->fixups = UPROBE_FIX_RIP_CX;
-		/* Change modrm from 00 000 101 to 00 000 001. */
-		*cursor = 0x1;
+		/* Change modrm from 00 000 101 to 10 000 001. */
+		*cursor = 0x81;
 	} else {
 		/* Use %rax (register #0) for the scratch register. */
 		auprobe->fixups = UPROBE_FIX_RIP_AX;
-		/* Change modrm from 00 xxx 101 to 00 xxx 000 */
-		*cursor = (reg << 3);
+		/* Change modrm from 00 xxx 101 to 10 xxx 000 */
+		*cursor = (reg << 3) | 0x80;
 	}
 
-	/* Target address = address of next instruction + (signed) offset */
-	auprobe->rip_rela_target_address = (long)insn->length + insn->displacement.value;
-
-	/* Displacement field is gone; slide immediate field (if any) over. */
-	if (insn->immediate.nbytes) {
-		cursor++;
-		memmove(cursor, cursor + insn->displacement.nbytes, insn->immediate.nbytes);
-	}
+	auprobe->insn_length = insn->length;
 }
 
 /*
@@ -439,11 +435,11 @@ pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
 	if (auprobe->fixups & UPROBE_FIX_RIP_AX) {
 		autask->saved_scratch_register = regs->ax;
 		regs->ax = current->utask->vaddr;
-		regs->ax += auprobe->rip_rela_target_address;
+		regs->ax += auprobe->insn_length;
 	} else if (auprobe->fixups & UPROBE_FIX_RIP_CX) {
 		autask->saved_scratch_register = regs->cx;
 		regs->cx = current->utask->vaddr;
-		regs->cx += auprobe->rip_rela_target_address;
+		regs->cx += auprobe->insn_length;
 	}
 }
 
-- 
1.8.1.4

