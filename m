Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaEARJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 13:09:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaEARJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 13:09:14 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] uprobes: fix scratch register selection for rip-relative fixups
Date: Thu,  1 May 2014 19:09:01 +0200
Message-Id: <1398964141-25097-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch, instructions such as div, mul,
shifts with count in CL, cmpxchg are mishandled.

This patch adds vex prefix handling. In particular,
it avoids colliding with register operand encoded
in vex.vvvv field.

Since we need to avoid two possible register operands,
the selection of scratch register needs to be from at least
three registers.

After looking through a lot of CPU docs, it looks like
the safest choice is SI,DI,BX. Selecting BX needs care
to not collide with implicit use of BX by cmpxchg8b.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Jim Keniston <jkenisto@us.ibm.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c | 154 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 116 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index c41bb4b..6cb53d1 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -41,8 +41,10 @@
 /* Instruction will modify TF, don't change it */
 #define UPROBE_FIX_SETF		0x04
 
-#define UPROBE_FIX_RIP_AX	0x08
-#define UPROBE_FIX_RIP_CX	0x10
+#define UPROBE_FIX_RIP_SI	0x08
+#define UPROBE_FIX_RIP_DI	0x10
+#define UPROBE_FIX_RIP_BX	0x20
+#define UPROBE_FIX_RIP_ALL	0x38
 
 #define	UPROBE_TRAP_NR		UINT_MAX
 
@@ -51,6 +53,8 @@
 #define OPCODE2(insn)		((insn)->opcode.bytes[1])
 #define OPCODE3(insn)		((insn)->opcode.bytes[2])
 #define MODRM_REG(insn)		X86_MODRM_REG((insn)->modrm.value)
+#define VEX2_VVVV(insn)		X86_VEX_V((insn)->vex_prefix.bytes[1])
+#define VEX3_VVVV(insn)		X86_VEX_V((insn)->vex_prefix.bytes[2])
 
 #define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
 	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
@@ -274,63 +278,137 @@ static inline bool is_64bit_mm(struct mm_struct *mm)
 static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
 {
 	u8 *cursor;
+	u8 can_use_regs;
 	u8 reg;
+	int reg2;
 
 	if (!insn_rip_relative(insn))
 		return;
 
 	/*
-	 * insn_rip_relative() would have decoded rex_prefix, modrm.
+	 * insn_rip_relative() would have decoded rex_prefix,
+	 * vex_prefix, modrm.
 	 * Clear REX.b bit (extension of MODRM.rm field):
-	 * we want to encode rax/rcx, not r8/r9.
+	 * we want to encode low numbered reg, not r8+.
 	 */
 	if (insn->rex_prefix.nbytes) {
 		cursor = auprobe->insn + insn_offset_rex_prefix(insn);
-		*cursor &= 0xfe;	/* Clearing REX.B bit */
+		/* REX byte has 0100wrxb layout, clearing REX.b bit */
+		*cursor &= 0xfe;
+	}
+	/* Similar treatment for VEX3 prefix */
+	/* TODO: add XOP/EVEX treatment when insn decoder supports them */
+	if (insn->vex_prefix.nbytes == 3) {
+		/*
+		 * vex2:     c5    rvvvvLpp   (has no b bit)
+		 * vex3/xop: c4/8f rxbmmmmm wvvvvLpp
+		 * evex:     62    rxbR00mm.wvvvv1pp.zllBVaaa
+		 *   (evex will need setting of both b and x since
+		 *   in non-sib encoding evex.x is 4th bit of MODRM.rm)
+		 * Setting VEX3.b (setting because it has inverted meaning):
+		 */
+		cursor = auprobe->insn + insn_offset_vex_prefix(insn) + 1;
+		*cursor |= 0x20;
 	}
 
 	/*
+	 * Convert from rip-relative addressing
+	 * to register-relative addressing via a scratch register.
+	 *
+	 * This is tricky since there are insns with modrm byte
+	 * which also use registers not encoded in modrm byte:
+	 * [i]div/[i]mul: implicitly use dx:ax
+	 * shift ops: implicitly use cx
+	 * cmpxchg: implicitly uses ax
+	 * cmpxchg8/16b: implicitly uses dx:ax and bx:cx
+	 *   Encoding: 0f c7/1 modrm
+	 *   The code below thinks that reg=1 (cx), chooses si as scratch.
+	 * mulx: implicitly uses dx: mulx r/m,r1,r2: r1:r2 = dx * r/m
+	 *   First appeared in Haswell (BMI2 insn). It is vex-encoded.
+	 *   Example where none of bx,cx,dx can be used as scratch reg:
+	 *   c4 e2 63 f6 0d disp32   mulx disp32(%rip),%ebx,%ecx
+	 * [v]pcmpistri: implicitly uses cx, xmm0
+	 * [v]pcmpistrm: implicitly uses xmm0
+	 * [v]pcmpestri: implicitly uses ax, dx, cx, xmm0
+	 * [v]pcmpestrm: implicitly uses ax, dx, xmm0
+	 *   Evil SSE4.2 string comparison ops from hell.
+	 * maskmovq/[v]maskmovdqu: implicitly uses (ds:rdi) as destination.
+	 *   Encoding: 0f f7 modrm, 66 0f f7 modrm, vex-encoded: c5 f9 f7 modrm.
+	 *   Store op1, byte-masked by op2 msb's in each byte, to (ds:rdi).
+	 *   AMD says it has no 3-operand form (vex.vvvv must be 1111)
+	 *   and that it can have only register operands, not mem
+	 *   (its modrm byte must have mode=11).
+	 *   If these restrictions will ever be lifted,
+	 *   we'll need code to prevent selection of di as scratch reg!
+	 *
+	 * Summary: I don't know any insns with modrm byte which
+	 * use SI register implicitly. DI register is used only
+	 * by one insn (maskmovq) and BX register is used
+	 * only by one too (cmpxchg8b).
+	 * BP is stack-segment based (may be a problem?).
+	 * AX, DX, CX are off-limits (many implicit users).
+	 * SP is unusable (it's stack pointer - think about "pop mem";
+	 * also, rsp+disp32 needs sib encoding -> insn length change).
+	 */
+	reg = MODRM_REG(insn);
+	reg2 = -1;
+	if (insn->vex_prefix.nbytes == 2) {
+		reg2 = VEX2_VVVV(insn) ^ 0xf;
+	}
+	if (insn->vex_prefix.nbytes == 3) {
+		reg2 = VEX3_VVVV(insn) ^ 0xf;
+	}
+	/* TODO: add XOP, EXEV vvvv reading */
+
+	/* Register numbering is ax,cx,dx,bx, sp,bp,si,di, r8..r15 */
+	can_use_regs = UPROBE_FIX_RIP_SI | UPROBE_FIX_RIP_DI | UPROBE_FIX_RIP_BX;
+#if 0
+	/* In any case, one bit will remain.
+	 * Clearing bx bit is pointless. Its state does not affect
+	 * scratch reg selection: we always prefer si/di to bx.
+	 */
+	if (reg == 3 || reg2 == 3)
+		can_use_regs &= ~UPROBE_FIX_RIP_BX;
+#endif
+	if (reg == 6 || reg2 == 6)
+		can_use_regs &= ~UPROBE_FIX_RIP_SI;
+	if (reg == 7 || reg2 == 7)
+		can_use_regs &= ~UPROBE_FIX_RIP_DI;
+	/* TODO: force maskmovq to not use di */
+	auprobe->def.fixups = can_use_regs;
+
+	/*
+	 * Choose scratch reg. Order is important:
+	 * must not select bx if we can use si (cmpxchg8b case!)
+	 */
+	reg2 = 3; /* BX */
+	if (can_use_regs & UPROBE_FIX_RIP_DI)
+		reg2 = 7;
+	if (can_use_regs & UPROBE_FIX_RIP_SI)
+		reg2 = 6;
+	/*
 	 * Point cursor at the modrm byte.  The next 4 bytes are the
 	 * displacement.  Beyond the displacement, for some instructions,
 	 * is the immediate operand.
 	 */
 	cursor = auprobe->insn + insn_offset_modrm(insn);
 	/*
-	 * Convert from rip-relative addressing
-	 * to register-relative addressing via a scratch register.
+	 * Change modrm from "00 reg 101" to "10 reg reg2". Example:
+	 * 89 05 disp32  mov %eax,disp32(%rip) becomes
+	 * 89 86 disp32  mov %eax,disp32(%rsi)
 	 */
-	reg = MODRM_REG(insn);
-	if (reg == 0) {
-		/*
-		 * The register operand (if any) is either the A register
-		 * (%rax, %eax, etc.) or (if the 0x4 bit is set in the
-		 * REX prefix) %r8.  In any case, we know the C register
-		 * is NOT the register operand, so we use %rcx (register
-		 * #1) for the scratch register.
-		 */
-		auprobe->def.fixups |= UPROBE_FIX_RIP_CX;
-		/*
-		 * Change modrm from "00 000 101" to "10 000 001". Example:
-		 * 89 05 disp32  mov %eax,disp32(%rip) becomes
-		 * 89 81 disp32  mov %eax,disp32(%rcx)
-		 */
-		*cursor = 0x81;
-	} else {
-		/* Use %rax (register #0) for the scratch register. */
-		auprobe->def.fixups |= UPROBE_FIX_RIP_AX;
-		/*
-		 * Change modrm from "00 reg 101" to "10 reg 000". Example:
-		 * 89 1d disp32  mov %edx,disp32(%rip) becomes
-		 * 89 98 disp32  mov %edx,disp32(%rax)
-		 */
-		*cursor = (reg << 3) | 0x80;
-	}
+	*cursor = (reg << 3) | 0x80 | reg2;
 }
 
 static inline unsigned long *
 scratch_reg(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	return (auprobe->def.fixups & UPROBE_FIX_RIP_AX) ? &regs->ax : &regs->cx;
+	/* Order is important - more than one bit can be set! */
+	if (auprobe->def.fixups & UPROBE_FIX_RIP_SI)
+		return &regs->si;
+	if (auprobe->def.fixups & UPROBE_FIX_RIP_DI)
+		return &regs->di;
+	return &regs->bx;
 }
 
 /*
@@ -339,7 +417,7 @@ scratch_reg(struct arch_uprobe *auprobe, struct pt_regs *regs)
  */
 static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	if (auprobe->def.fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
+	if (auprobe->def.fixups & UPROBE_FIX_RIP_ALL) {
 		struct uprobe_task *utask = current->utask;
 		unsigned long *sr = scratch_reg(auprobe, regs);
 
@@ -350,7 +428,7 @@ static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 
 static void riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	if (auprobe->def.fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
+	if (auprobe->def.fixups & UPROBE_FIX_RIP_ALL) {
 		struct uprobe_task *utask = current->utask;
 		unsigned long *sr = scratch_reg(auprobe, regs);
 
@@ -724,9 +802,9 @@ bool arch_uprobe_xol_was_trapped(struct task_struct *t)
  *
  * If the original instruction was a rip-relative instruction such as
  * "movl %edx,0xnnnn(%rip)", we have instead executed an equivalent
- * instruction using a scratch register -- e.g., "movl %edx,0xnnnn(%rax)".
+ * instruction using a scratch register -- e.g., "movl %edx,0xnnnn(%rsi)".
  * We need to restore the contents of the scratch register
- * (FIX_RIP_AX or FIX_RIP_CX).
+ * (FIX_RIP_reg).
  */
 int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-- 
1.8.1.4

