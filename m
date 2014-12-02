Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058AbaLBTzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:55:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46537 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbaLBTVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:21:20 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nadav Amit <namit@cs.technion.ac.il>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 058/121] KVM: x86: Fix uninitialized op->type for some immediate values
Date: Tue,  2 Dec 2014 11:18:57 -0800
Message-Id: <1417548000-1794-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/emulate.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4ae37e7..97e766b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4208,6 +4208,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		fetch_register_operand(op);
 		break;
 	case OpCL:
+		op->type = OP_IMM;
 		op->bytes = 1;
 		op->val = reg_read(ctxt, VCPU_REGS_RCX) & 0xff;
 		break;
@@ -4215,6 +4216,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		rc = decode_imm(ctxt, op, 1, true);
 		break;
 	case OpOne:
+		op->type = OP_IMM;
 		op->bytes = 1;
 		op->val = 1;
 		break;
@@ -4273,21 +4275,27 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
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
1.9.1

