Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbaKSR3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:29:08 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44932 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbaKSR3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:29:04 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: namit@cs.technion.ac.il
Subject: [PATCH] KVM: emulator: remove code duplication in register_address{,_increment}
Date: Wed, 19 Nov 2014 18:28:55 +0100
Message-Id: <1416418135-11110-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

register_address has been a duplicate of address_mask ever since the
ancestor of __linearize was born in 90de84f50b42 (KVM: x86 emulator:
preserve an operand's segment identity, 2010-11-17).

However, we can put it to a better use by including the call to reg_read
in register_address.  Similarly, the call to reg_rmw can be moved to
register_address_increment.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 19a59f3f702c..43a5b432d06f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -488,9 +488,9 @@ address_mask(struct x86_emulate_ctxt *ctxt, unsigned long reg)
 }
 
 static inline unsigned long
-register_address(struct x86_emulate_ctxt *ctxt, unsigned long reg)
+register_address(struct x86_emulate_ctxt *ctxt, int reg)
 {
-	return address_mask(ctxt, reg);
+	return address_mask(ctxt, reg_read(ctxt, reg));
 }
 
 static void masked_increment(ulong *reg, ulong mask, int inc)
@@ -499,7 +499,7 @@ static void masked_increment(ulong *reg, ulong mask, int inc)
 }
 
 static inline void
-register_address_increment(struct x86_emulate_ctxt *ctxt, unsigned long *reg, int inc)
+register_address_increment(struct x86_emulate_ctxt *ctxt, int reg, int inc)
 {
 	ulong mask;
 
@@ -507,7 +507,7 @@ register_address_increment(struct x86_emulate_ctxt *ctxt, unsigned long *reg, in
 		mask = ~0UL;
 	else
 		mask = ad_mask(ctxt);
-	masked_increment(reg, mask, inc);
+	masked_increment(reg_rmw(ctxt, reg), mask, inc);
 }
 
 static void rsp_increment(struct x86_emulate_ctxt *ctxt, int inc)
@@ -2910,8 +2910,8 @@ static void string_addr_inc(struct x86_emulate_ctxt *ctxt, int reg,
 {
 	int df = (ctxt->eflags & EFLG_DF) ? -op->count : op->count;
 
-	register_address_increment(ctxt, reg_rmw(ctxt, reg), df * op->bytes);
-	op->addr.mem.ea = register_address(ctxt, reg_read(ctxt, reg));
+	register_address_increment(ctxt, reg, df * op->bytes);
+	op->addr.mem.ea = register_address(ctxt, reg);
 }
 
 static int em_das(struct x86_emulate_ctxt *ctxt)
@@ -3381,7 +3381,7 @@ static int em_loop(struct x86_emulate_ctxt *ctxt)
 {
 	int rc = X86EMUL_CONTINUE;
 
-	register_address_increment(ctxt, reg_rmw(ctxt, VCPU_REGS_RCX), -1);
+	register_address_increment(ctxt, VCPU_REGS_RCX, -1);
 	if ((address_mask(ctxt, reg_read(ctxt, VCPU_REGS_RCX)) != 0) &&
 	    (ctxt->b == 0xe2 || test_cc(ctxt->b ^ 0x5, ctxt->eflags)))
 		rc = jmp_rel(ctxt, ctxt->src.val);
@@ -4280,7 +4280,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		op->type = OP_MEM;
 		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
 		op->addr.mem.ea =
-			register_address(ctxt, reg_read(ctxt, VCPU_REGS_RDI));
+			register_address(ctxt, VCPU_REGS_RDI);
 		op->addr.mem.seg = VCPU_SREG_ES;
 		op->val = 0;
 		op->count = 1;
@@ -4332,7 +4332,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		op->type = OP_MEM;
 		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
 		op->addr.mem.ea =
-			register_address(ctxt, reg_read(ctxt, VCPU_REGS_RSI));
+			register_address(ctxt, VCPU_REGS_RSI);
 		op->addr.mem.seg = ctxt->seg_override;
 		op->val = 0;
 		op->count = 1;
@@ -4341,7 +4341,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		op->type = OP_MEM;
 		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
 		op->addr.mem.ea =
-			register_address(ctxt,
+			address_mask(ctxt,
 				reg_read(ctxt, VCPU_REGS_RBX) +
 				(reg_read(ctxt, VCPU_REGS_RAX) & 0xff));
 		op->addr.mem.seg = ctxt->seg_override;
@@ -4979,8 +4979,7 @@ writeback:
 			count = ctxt->src.count;
 		else
 			count = ctxt->dst.count;
-		register_address_increment(ctxt, reg_rmw(ctxt, VCPU_REGS_RCX),
-				-count);
+		register_address_increment(ctxt, VCPU_REGS_RCX, -count);
 
 		if (!string_insn_completed(ctxt)) {
 			/*
-- 
1.8.3.1

