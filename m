Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaKYLJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:09:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58875 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaKYKmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nadav Amit <namit@cs.technion.ac.il>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 171/254] KVM: x86: Fix uninitialized op->type for some immediate values
Date: Tue, 25 Nov 2014 10:38:41 +0000
Message-Id: <1416912004-5928-172-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

commit d29b9d7ed76c0b961603ca692b8a562556a20212 upstream.

The emulator could reuse an op->type from a previous instruction for some
immediate values.  If it mistakenly considers the operands as memory
operands, it will performs a memory read and overwrite op->val.

Consider for instance the ROR instruction - src2 (the number of times)
would be read from memory instead of being used as immediate.

Mark every immediate operand as such to avoid this problem.

Fixes: c44b4c6ab80eef3a9c52c7b3f0c632942e6489aa
Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/emulate.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index bcb3134a8d4c..27362eceec9c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4220,6 +4220,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		fetch_register_operand(op);
 		break;
 	case OpCL:
+		op->type = OP_IMM;
 		op->bytes = 1;
 		op->val = reg_read(ctxt, VCPU_REGS_RCX) & 0xff;
 		break;
@@ -4227,6 +4228,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		rc = decode_imm(ctxt, op, 1, true);
 		break;
 	case OpOne:
+		op->type = OP_IMM;
 		op->bytes = 1;
 		op->val = 1;
 		break;
@@ -4285,21 +4287,27 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		ctxt->memop.bytes = ctxt->op_bytes + 2;
 		goto mem_common;
 	case OpES:
+		op->type = OP_IMM;
 		op->val = VCPU_SREG_ES;
 		break;
 	case OpCS:
+		op->type = OP_IMM;
 		op->val = VCPU_SREG_CS;
 		break;
 	case OpSS:
+		op->type = OP_IMM;
 		op->val = VCPU_SREG_SS;
 		break;
 	case OpDS:
+		op->type = OP_IMM;
 		op->val = VCPU_SREG_DS;
 		break;
 	case OpFS:
+		op->type = OP_IMM;
 		op->val = VCPU_SREG_FS;
 		break;
 	case OpGS:
+		op->type = OP_IMM;
 		op->val = VCPU_SREG_GS;
 		break;
 	case OpImplicit:
-- 
2.1.0

