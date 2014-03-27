Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbaC0LcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:32:00 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47809 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbaC0Lax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:30:53 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [RFC PATCH 4/5] KVM: x86: protect checks on ctxt->d by a common "if (unlikely())"
Date: Thu, 27 Mar 2014 12:30:37 +0100
Message-Id: <1395919838-18466-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395919838-18466-1-git-send-email-pbonzini@redhat.com>
References: <1395919838-18466-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several checks for "peculiar" aspects of instructions in both
x86_decode_insn and x86_emulate_insn.  Group them together, and guard
them with a single "if" that lets the processor quickly skip them all.
To do this effectively, add two more flag bits that say whether the
.intercept and .check_perm fields are valid.

This skims about 10 cycles for each emulated instructions, which is
a 2 to 6% improvement.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	To review, use -b.

 arch/x86/kvm/emulate.c | 175 ++++++++++++++++++++++++++-----------------------
 1 file changed, 94 insertions(+), 81 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9e40fbf94dcd..94974055d906 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -161,6 +161,8 @@
 #define Fastop      ((u64)1 << 44)  /* Use opcode::u.fastop */
 #define NoWrite     ((u64)1 << 45)  /* No writeback */
 #define SrcWrite    ((u64)1 << 46)  /* Write back src operand */
+#define Intercept   ((u64)1 << 47)  /* Has intercept field */
+#define CheckPerm   ((u64)1 << 48)  /* Has intercept field */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -3514,9 +3516,9 @@ static int check_perm_out(struct x86_emulate_ctxt *ctxt)
 }
 
 #define D(_y) { .flags = (_y) }
-#define DI(_y, _i) { .flags = (_y), .intercept = x86_intercept_##_i }
-#define DIP(_y, _i, _p) { .flags = (_y), .intercept = x86_intercept_##_i, \
-		      .check_perm = (_p) }
+#define DI(_y, _i) { .flags = (_y)|Intercept, .intercept = x86_intercept_##_i }
+#define DIP(_y, _i, _p) { .flags = (_y)|Intercept|CheckPerm, \
+		      .intercept = x86_intercept_##_i, .check_perm = (_p) }
 #define N    D(NotImpl)
 #define EXT(_f, _e) { .flags = ((_f) | RMExt), .u.group = (_e) }
 #define G(_f, _g) { .flags = ((_f) | Group | ModRM), .u.group = (_g) }
@@ -3525,10 +3527,10 @@ static int check_perm_out(struct x86_emulate_ctxt *ctxt)
 #define I(_f, _e) { .flags = (_f), .u.execute = (_e) }
 #define F(_f, _e) { .flags = (_f) | Fastop, .u.fastop = (_e) }
 #define II(_f, _e, _i) \
-	{ .flags = (_f), .u.execute = (_e), .intercept = x86_intercept_##_i }
+	{ .flags = (_f)|Intercept, .u.execute = (_e), .intercept = x86_intercept_##_i }
 #define IIP(_f, _e, _i, _p) \
-	{ .flags = (_f), .u.execute = (_e), .intercept = x86_intercept_##_i, \
-	  .check_perm = (_p) }
+	{ .flags = (_f)|Intercept|CheckPerm, .u.execute = (_e), \
+	  .intercept = x86_intercept_##_i, .check_perm = (_p) }
 #define GP(_f, _g) { .flags = ((_f) | Prefix), .u.gprefix = (_g) }
 
 #define D2bv(_f)      D((_f) | ByteOp), D(_f)
@@ -4352,29 +4354,37 @@ done_prefixes:
 		return EMULATION_FAILED;
 
 	ctxt->execute = opcode.u.execute;
-	ctxt->check_perm = opcode.check_perm;
-	ctxt->intercept = opcode.intercept;
 
-	if (ctxt->d & NotImpl)
-		return EMULATION_FAILED;
+	if (unlikely(ctxt->d &
+		     (NotImpl|EmulateOnUD|Stack|Op3264|Sse|Mmx|Intercept|CheckPerm))) {
+		/*
+		 * These are copied unconditionally here, and checked unconditionally
+		 * in x86_emulate_insn.
+		 */
+		ctxt->check_perm = opcode.check_perm;
+		ctxt->intercept = opcode.intercept;
 
-	if (!(ctxt->d & EmulateOnUD) && ctxt->ud)
-		return EMULATION_FAILED;
+		if (ctxt->d & NotImpl)
+			return EMULATION_FAILED;
 
-	if (mode == X86EMUL_MODE_PROT64 && (ctxt->d & Stack))
-		ctxt->op_bytes = 8;
+		if (!(ctxt->d & EmulateOnUD) && ctxt->ud)
+			return EMULATION_FAILED;
 
-	if (ctxt->d & Op3264) {
-		if (mode == X86EMUL_MODE_PROT64)
+		if (mode == X86EMUL_MODE_PROT64 && (ctxt->d & Stack))
 			ctxt->op_bytes = 8;
-		else
-			ctxt->op_bytes = 4;
-	}
 
-	if (ctxt->d & Sse)
-		ctxt->op_bytes = 16;
-	else if (ctxt->d & Mmx)
-		ctxt->op_bytes = 8;
+		if (ctxt->d & Op3264) {
+			if (mode == X86EMUL_MODE_PROT64)
+				ctxt->op_bytes = 8;
+			else
+				ctxt->op_bytes = 4;
+		}
+
+		if (ctxt->d & Sse)
+			ctxt->op_bytes = 16;
+		else if (ctxt->d & Mmx)
+			ctxt->op_bytes = 8;
+	}
 
 	/* ModRM and SIB bytes. */
 	if (ctxt->d & ModRM) {
@@ -4508,75 +4518,78 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 		goto done;
 	}
 
-	if ((ctxt->mode == X86EMUL_MODE_PROT64 && (ctxt->d & No64)) ||
-			(ctxt->d & Undefined)) {
-		rc = emulate_ud(ctxt);
-		goto done;
-	}
-
-	if (((ctxt->d & (Sse|Mmx)) && ((ops->get_cr(ctxt, 0) & X86_CR0_EM)))
-	    || ((ctxt->d & Sse) && !(ops->get_cr(ctxt, 4) & X86_CR4_OSFXSR))) {
-		rc = emulate_ud(ctxt);
-		goto done;
-	}
-
-	if ((ctxt->d & (Sse|Mmx)) && (ops->get_cr(ctxt, 0) & X86_CR0_TS)) {
-		rc = emulate_nm(ctxt);
-		goto done;
-	}
+	if (unlikely(ctxt->d &
+		     (No64|Undefined|Sse|Mmx|Intercept|CheckPerm|Priv|Prot|String))) {
+		if ((ctxt->mode == X86EMUL_MODE_PROT64 && (ctxt->d & No64)) ||
+				(ctxt->d & Undefined)) {
+			rc = emulate_ud(ctxt);
+			goto done;
+		}
 
-	if (ctxt->d & Mmx) {
-		rc = flush_pending_x87_faults(ctxt);
-		if (rc != X86EMUL_CONTINUE)
+		if (((ctxt->d & (Sse|Mmx)) && ((ops->get_cr(ctxt, 0) & X86_CR0_EM)))
+		    || ((ctxt->d & Sse) && !(ops->get_cr(ctxt, 4) & X86_CR4_OSFXSR))) {
+			rc = emulate_ud(ctxt);
 			goto done;
-		/*
-		 * Now that we know the fpu is exception safe, we can fetch
-		 * operands from it.
-		 */
-		fetch_possible_mmx_operand(ctxt, &ctxt->src);
-		fetch_possible_mmx_operand(ctxt, &ctxt->src2);
-		if (!(ctxt->d & Mov))
-			fetch_possible_mmx_operand(ctxt, &ctxt->dst);
-	}
+		}
 
-	if (unlikely(ctxt->guest_mode) && ctxt->intercept) {
-		rc = emulator_check_intercept(ctxt, ctxt->intercept,
-					      X86_ICPT_PRE_EXCEPT);
-		if (rc != X86EMUL_CONTINUE)
+		if ((ctxt->d & (Sse|Mmx)) && (ops->get_cr(ctxt, 0) & X86_CR0_TS)) {
+			rc = emulate_nm(ctxt);
 			goto done;
-	}
+		}
 
-	/* Privileged instruction can be executed only in CPL=0 */
-	if ((ctxt->d & Priv) && ops->cpl(ctxt)) {
-		rc = emulate_gp(ctxt, 0);
-		goto done;
-	}
+		if (ctxt->d & Mmx) {
+			rc = flush_pending_x87_faults(ctxt);
+			if (rc != X86EMUL_CONTINUE)
+				goto done;
+			/*
+			 * Now that we know the fpu is exception safe, we can fetch
+			 * operands from it.
+			 */
+			fetch_possible_mmx_operand(ctxt, &ctxt->src);
+			fetch_possible_mmx_operand(ctxt, &ctxt->src2);
+			if (!(ctxt->d & Mov))
+				fetch_possible_mmx_operand(ctxt, &ctxt->dst);
+		}
 
-	/* Instruction can only be executed in protected mode */
-	if ((ctxt->d & Prot) && ctxt->mode < X86EMUL_MODE_PROT16) {
-		rc = emulate_ud(ctxt);
-		goto done;
-	}
+		if (unlikely(ctxt->guest_mode) && ctxt->intercept) {
+			rc = emulator_check_intercept(ctxt, ctxt->intercept,
+						      X86_ICPT_PRE_EXCEPT);
+			if (rc != X86EMUL_CONTINUE)
+				goto done;
+		}
 
-	/* Do instruction specific permission checks */
-	if (ctxt->check_perm) {
-		rc = ctxt->check_perm(ctxt);
-		if (rc != X86EMUL_CONTINUE)
+		/* Privileged instruction can be executed only in CPL=0 */
+		if ((ctxt->d & Priv) && ops->cpl(ctxt)) {
+			rc = emulate_gp(ctxt, 0);
 			goto done;
-	}
+		}
 
-	if (unlikely(ctxt->guest_mode) && ctxt->intercept) {
-		rc = emulator_check_intercept(ctxt, ctxt->intercept,
-					      X86_ICPT_POST_EXCEPT);
-		if (rc != X86EMUL_CONTINUE)
+		/* Instruction can only be executed in protected mode */
+		if ((ctxt->d & Prot) && ctxt->mode < X86EMUL_MODE_PROT16) {
+			rc = emulate_ud(ctxt);
 			goto done;
-	}
+		}
 
-	if (ctxt->rep_prefix && (ctxt->d & String)) {
-		/* All REP prefixes have the same first termination condition */
-		if (address_mask(ctxt, reg_read(ctxt, VCPU_REGS_RCX)) == 0) {
-			ctxt->eip = ctxt->_eip;
-			goto done;
+		/* Do instruction specific permission checks */
+		if (ctxt->check_perm) {
+			rc = ctxt->check_perm(ctxt);
+			if (rc != X86EMUL_CONTINUE)
+				goto done;
+		}
+
+		if (unlikely(ctxt->guest_mode) && ctxt->intercept) {
+			rc = emulator_check_intercept(ctxt, ctxt->intercept,
+						      X86_ICPT_POST_EXCEPT);
+			if (rc != X86EMUL_CONTINUE)
+				goto done;
+		}
+
+		if (ctxt->rep_prefix && (ctxt->d & String)) {
+			/* All REP prefixes have the same first termination condition */
+			if (address_mask(ctxt, reg_read(ctxt, VCPU_REGS_RCX)) == 0) {
+				ctxt->eip = ctxt->_eip;
+				goto done;
+			}
 		}
 	}
 
-- 
1.8.3.1


