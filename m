Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab3EQW00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:26:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab3EQVhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: [ 003/102] KVM: emulator: emulate XLAT
Date: Fri, 17 May 2013 14:35:18 -0700
Message-Id: <20130517213244.676132209@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 7fa57952d70f5737513d8319395e471d107e4e0d upstream.

This is used by SGABIOS, KVM breaks with emulate_invalid_guest_state=1.
It is just a MOV in disguise, with a funny source address.

Reported-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -60,6 +60,7 @@
 #define OpGS              25ull  /* GS */
 #define OpMem8            26ull  /* 8-bit zero extended memory operand */
 #define OpImm64           27ull  /* Sign extended 16/32/64-bit immediate */
+#define OpXLat            28ull  /* memory at BX/EBX/RBX + zero-extended AL */
 
 #define OpBits             5  /* Width of operand field */
 #define OpMask             ((1ull << OpBits) - 1)
@@ -99,6 +100,7 @@
 #define SrcImmUByte (OpImmUByte << SrcShift)
 #define SrcImmU     (OpImmU << SrcShift)
 #define SrcSI       (OpSI << SrcShift)
+#define SrcXLat     (OpXLat << SrcShift)
 #define SrcImmFAddr (OpImmFAddr << SrcShift)
 #define SrcMemFAddr (OpMemFAddr << SrcShift)
 #define SrcAcc      (OpAcc << SrcShift)
@@ -3949,7 +3951,8 @@ static const struct opcode opcode_table[
 	G(Src2One | ByteOp, group2), G(Src2One, group2),
 	G(Src2CL | ByteOp, group2), G(Src2CL, group2),
 	I(DstAcc | SrcImmUByte | No64, em_aam),
-	I(DstAcc | SrcImmUByte | No64, em_aad), N, N,
+	I(DstAcc | SrcImmUByte | No64, em_aad), N,
+	I(DstAcc | SrcXLat | ByteOp, em_mov),
 	/* 0xD8 - 0xDF */
 	N, E(0, &escape_d9), N, E(0, &escape_db), N, E(0, &escape_dd), N, N,
 	/* 0xE0 - 0xE7 */
@@ -4211,6 +4214,16 @@ static int decode_operand(struct x86_emu
 		op->val = 0;
 		op->count = 1;
 		break;
+	case OpXLat:
+		op->type = OP_MEM;
+		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
+		op->addr.mem.ea =
+			register_address(ctxt,
+				reg_read(ctxt, VCPU_REGS_RBX) +
+				(reg_read(ctxt, VCPU_REGS_RAX) & 0xff));
+		op->addr.mem.seg = seg_override(ctxt);
+		op->val = 0;
+		break;
 	case OpImmFAddr:
 		op->type = OP_IMM;
 		op->addr.mem.ea = ctxt->_eip;


