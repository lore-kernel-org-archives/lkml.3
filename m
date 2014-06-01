Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbaFAT0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 15:26:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbaFAT0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 15:26:11 -0400
Date: Sun, 1 Jun 2014 21:25:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] uprobes/x86: Rename arch_uprobe->def into ->dflt, minor
	comment updates
Message-ID: <20140601192520.GA14539@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Purely cosmetic, no changes in .o,

1. As Jim pointed out arch_uprobe->def looks ambiguous, rename it to
   ->dflt.

2. Add the comment into default_post_xol_op() to explain "regs->sp +=".

3. Remove the stale part of the comment in arch_uprobe_analyze_insn().

Suggested-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/uprobes.h |    2 +-
 arch/x86/kernel/uprobes.c      |   37 ++++++++++++++++++-------------------
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 7be3c07..b3d9442 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -52,7 +52,7 @@ struct arch_uprobe {
 		struct {
 			u8	fixups;
 			u8	ilen;
-		} 			def;
+		} 			dflt;
 	};
 };
 
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index fcf6279..33e239f 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -254,7 +254,7 @@ static inline bool is_64bit_mm(struct mm_struct *mm)
  * If arch_uprobe->insn doesn't use rip-relative addressing, return
  * immediately.  Otherwise, rewrite the instruction so that it accesses
  * its memory operand indirectly through a scratch register.  Set
- * def->fixups accordingly. (The contents of the scratch register
+ * dflt->fixups accordingly. (The contents of the scratch register
  * will be saved before we single-step the modified instruction,
  * and restored afterward).
  *
@@ -372,14 +372,14 @@ static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
 	 */
 	if (reg != 6 && reg2 != 6) {
 		reg2 = 6;
-		auprobe->def.fixups |= UPROBE_FIX_RIP_SI;
+		auprobe->dflt.fixups |= UPROBE_FIX_RIP_SI;
 	} else if (reg != 7 && reg2 != 7) {
 		reg2 = 7;
-		auprobe->def.fixups |= UPROBE_FIX_RIP_DI;
+		auprobe->dflt.fixups |= UPROBE_FIX_RIP_DI;
 		/* TODO (paranoia): force maskmovq to not use di */
 	} else {
 		reg2 = 3;
-		auprobe->def.fixups |= UPROBE_FIX_RIP_BX;
+		auprobe->dflt.fixups |= UPROBE_FIX_RIP_BX;
 	}
 	/*
 	 * Point cursor at the modrm byte.  The next 4 bytes are the
@@ -398,9 +398,9 @@ static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
 static inline unsigned long *
 scratch_reg(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	if (auprobe->def.fixups & UPROBE_FIX_RIP_SI)
+	if (auprobe->dflt.fixups & UPROBE_FIX_RIP_SI)
 		return &regs->si;
-	if (auprobe->def.fixups & UPROBE_FIX_RIP_DI)
+	if (auprobe->dflt.fixups & UPROBE_FIX_RIP_DI)
 		return &regs->di;
 	return &regs->bx;
 }
@@ -411,18 +411,18 @@ scratch_reg(struct arch_uprobe *auprobe, struct pt_regs *regs)
  */
 static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	if (auprobe->def.fixups & UPROBE_FIX_RIP_MASK) {
+	if (auprobe->dflt.fixups & UPROBE_FIX_RIP_MASK) {
 		struct uprobe_task *utask = current->utask;
 		unsigned long *sr = scratch_reg(auprobe, regs);
 
 		utask->autask.saved_scratch_register = *sr;
-		*sr = utask->vaddr + auprobe->def.ilen;
+		*sr = utask->vaddr + auprobe->dflt.ilen;
 	}
 }
 
 static void riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	if (auprobe->def.fixups & UPROBE_FIX_RIP_MASK) {
+	if (auprobe->dflt.fixups & UPROBE_FIX_RIP_MASK) {
 		struct uprobe_task *utask = current->utask;
 		unsigned long *sr = scratch_reg(auprobe, regs);
 
@@ -499,16 +499,16 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 	struct uprobe_task *utask = current->utask;
 
 	riprel_post_xol(auprobe, regs);
-	if (auprobe->def.fixups & UPROBE_FIX_IP) {
+	if (auprobe->dflt.fixups & UPROBE_FIX_IP) {
 		long correction = utask->vaddr - utask->xol_vaddr;
 		regs->ip += correction;
-	} else if (auprobe->def.fixups & UPROBE_FIX_CALL) {
-		regs->sp += sizeof_long();
-		if (push_ret_address(regs, utask->vaddr + auprobe->def.ilen))
+	} else if (auprobe->dflt.fixups & UPROBE_FIX_CALL) {
+		regs->sp += sizeof_long(); /* Pop incorrect return address */
+		if (push_ret_address(regs, utask->vaddr + auprobe->dflt.ilen))
 			return -ERESTART;
 	}
 	/* popf; tell the caller to not touch TF */
-	if (auprobe->def.fixups & UPROBE_FIX_SETF)
+	if (auprobe->dflt.fixups & UPROBE_FIX_SETF)
 		utask->autask.saved_tf = true;
 
 	return 0;
@@ -711,12 +711,11 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 
 	/*
 	 * Figure out which fixups default_post_xol_op() will need to perform,
-	 * and annotate def->fixups accordingly. To start with, ->fixups is
-	 * either zero or it reflects rip-related fixups.
+	 * and annotate dflt->fixups accordingly.
 	 */
 	switch (OPCODE1(&insn)) {
 	case 0x9d:		/* popf */
-		auprobe->def.fixups |= UPROBE_FIX_SETF;
+		auprobe->dflt.fixups |= UPROBE_FIX_SETF;
 		break;
 	case 0xc3:		/* ret or lret -- ip is correct */
 	case 0xcb:
@@ -742,8 +741,8 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 		riprel_analyze(auprobe, &insn);
 	}
 
-	auprobe->def.ilen = insn.length;
-	auprobe->def.fixups |= fix_ip_or_call;
+	auprobe->dflt.ilen = insn.length;
+	auprobe->dflt.fixups |= fix_ip_or_call;
 
 	auprobe->ops = &default_xol_ops;
 	return 0;
-- 
1.5.5.1


