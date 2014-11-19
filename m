Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934200AbaKSWYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:24:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbaKSUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.17 041/141] KVM: x86: Fix uninitialized op->type for some immediate values
Date: Wed, 19 Nov 2014 12:51:04 -0800
Message-Id: <20141119205152.016110326@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4272,6 +4272,7 @@ static int decode_operand(struct x86_emu
 		fetch_register_operand(op);
 		break;
 	case OpCL:
+		op->type = OP_IMM;
 		op->bytes = 1;
 		op->val = reg_read(ctxt, VCPU_REGS_RCX) & 0xff;
 		break;
@@ -4279,6 +4280,7 @@ static int decode_operand(struct x86_emu
 		rc = decode_imm(ctxt, op, 1, true);
 		break;
 	case OpOne:
+		op->type = OP_IMM;
 		op->bytes = 1;
 		op->val = 1;
 		break;
@@ -4337,21 +4339,27 @@ static int decode_operand(struct x86_emu
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


