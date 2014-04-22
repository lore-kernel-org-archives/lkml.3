Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbaDVOsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:48:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707AbaDVOsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:48:10 -0400
Date: Tue, 22 Apr 2014 16:47:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] uprobes/x86: Move default_xol_ops's data into
	arch_uprobe->def
Message-ID: <20140422144753.GA8062@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422144719.GA7456@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally we can move arch_uprobe->fixups/rip_rela_target_address
into the new "def" struct and place this struct in the union, they
are only used by default_xol_ops paths.

The patch also renames rip_rela_target_address to riprel_target just
to make this name shorter.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/uprobes.h |   12 ++++++----
 arch/x86/kernel/uprobes.c      |   41 +++++++++++++++++++--------------------
 2 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 93bee7b..72caff7 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -41,18 +41,20 @@ struct arch_uprobe {
 		u8			ixol[MAX_UINSN_BYTES];
 	};
 
-	u16				fixups;
 	const struct uprobe_xol_ops	*ops;
 
 	union {
-#ifdef CONFIG_X86_64
-		unsigned long			rip_rela_target_address;
-#endif
 		struct {
 			s32	offs;
 			u8	ilen;
 			u8	opc1;
-		}				branch;
+		}			branch;
+		struct {
+#ifdef CONFIG_X86_64
+			long	riprel_target;
+#endif
+			u16	fixups;
+		} 			def;
 	};
 };
 
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index e6314a2..69b2d61 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -251,10 +251,9 @@ static inline bool is_64bit_mm(struct mm_struct *mm)
  * If arch_uprobe->insn doesn't use rip-relative addressing, return
  * immediately.  Otherwise, rewrite the instruction so that it accesses
  * its memory operand indirectly through a scratch register.  Set
- * arch_uprobe->fixups and arch_uprobe->rip_rela_target_address
- * accordingly.  (The contents of the scratch register will be saved
- * before we single-step the modified instruction, and restored
- * afterward.)
+ * def->fixups and def->riprel_target accordingly. (The contents of the
+ * scratch register will be saved before we single-step the modified
+ * instruction, and restored afterward).
  *
  * We do this because a rip-relative instruction can access only a
  * relatively small area (+/- 2 GB from the instruction), and the XOL
@@ -308,18 +307,18 @@ handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
 		 * is NOT the register operand, so we use %rcx (register
 		 * #1) for the scratch register.
 		 */
-		auprobe->fixups = UPROBE_FIX_RIP_CX;
+		auprobe->def.fixups = UPROBE_FIX_RIP_CX;
 		/* Change modrm from 00 000 101 to 00 000 001. */
 		*cursor = 0x1;
 	} else {
 		/* Use %rax (register #0) for the scratch register. */
-		auprobe->fixups = UPROBE_FIX_RIP_AX;
+		auprobe->def.fixups = UPROBE_FIX_RIP_AX;
 		/* Change modrm from 00 xxx 101 to 00 xxx 000 */
 		*cursor = (reg << 3);
 	}
 
 	/* Target address = address of next instruction + (signed) offset */
-	auprobe->rip_rela_target_address = (long)insn->length + insn->displacement.value;
+	auprobe->def.riprel_target = (long)insn->length + insn->displacement.value;
 
 	/* Displacement field is gone; slide immediate field (if any) over. */
 	if (insn->immediate.nbytes) {
@@ -336,25 +335,25 @@ static void
 pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
 				struct arch_uprobe_task *autask)
 {
-	if (auprobe->fixups & UPROBE_FIX_RIP_AX) {
+	if (auprobe->def.fixups & UPROBE_FIX_RIP_AX) {
 		autask->saved_scratch_register = regs->ax;
 		regs->ax = current->utask->vaddr;
-		regs->ax += auprobe->rip_rela_target_address;
-	} else if (auprobe->fixups & UPROBE_FIX_RIP_CX) {
+		regs->ax += auprobe->def.riprel_target;
+	} else if (auprobe->def.fixups & UPROBE_FIX_RIP_CX) {
 		autask->saved_scratch_register = regs->cx;
 		regs->cx = current->utask->vaddr;
-		regs->cx += auprobe->rip_rela_target_address;
+		regs->cx += auprobe->def.riprel_target;
 	}
 }
 
 static void
 handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *correction)
 {
-	if (auprobe->fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
+	if (auprobe->def.fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
 		struct arch_uprobe_task *autask;
 
 		autask = &current->utask->autask;
-		if (auprobe->fixups & UPROBE_FIX_RIP_AX)
+		if (auprobe->def.fixups & UPROBE_FIX_RIP_AX)
 			regs->ax = autask->saved_scratch_register;
 		else
 			regs->cx = autask->saved_scratch_register;
@@ -432,17 +431,17 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 	long correction = (long)(utask->vaddr - utask->xol_vaddr);
 
 	handle_riprel_post_xol(auprobe, regs, &correction);
-	if (auprobe->fixups & UPROBE_FIX_IP)
+	if (auprobe->def.fixups & UPROBE_FIX_IP)
 		regs->ip += correction;
 
-	if (auprobe->fixups & UPROBE_FIX_CALL) {
+	if (auprobe->def.fixups & UPROBE_FIX_CALL) {
 		if (adjust_ret_addr(regs->sp, correction)) {
 			regs->sp += sizeof_long();
 			return -ERESTART;
 		}
 	}
 	/* popf; tell the caller to not touch TF */
-	if (auprobe->fixups & UPROBE_FIX_SETF)
+	if (auprobe->def.fixups & UPROBE_FIX_SETF)
 		utask->autask.saved_tf = true;
 
 	return 0;
@@ -636,12 +635,12 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 
 	/*
 	 * Figure out which fixups arch_uprobe_post_xol() will need to perform,
-	 * and annotate arch_uprobe->fixups accordingly. To start with, ->fixups
-	 * is either zero or it reflects rip-related fixups.
+	 * and annotate def->fixups accordingly. To start with, ->fixups is
+	 * either zero or it reflects rip-related fixups.
 	 */
 	switch (OPCODE1(&insn)) {
 	case 0x9d:		/* popf */
-		auprobe->fixups |= UPROBE_FIX_SETF;
+		auprobe->def.fixups |= UPROBE_FIX_SETF;
 		break;
 	case 0xc3:		/* ret or lret -- ip is correct */
 	case 0xcb:
@@ -669,9 +668,9 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	}
 
 	if (fix_ip)
-		auprobe->fixups |= UPROBE_FIX_IP;
+		auprobe->def.fixups |= UPROBE_FIX_IP;
 	if (fix_call)
-		auprobe->fixups |= UPROBE_FIX_CALL;
+		auprobe->def.fixups |= UPROBE_FIX_CALL;
 
 	auprobe->ops = &default_xol_ops;
 	return 0;
-- 
1.5.5.1

