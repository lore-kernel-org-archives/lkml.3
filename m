Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaDPQqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:46:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbaDPQqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:46:36 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 5/6] KVM: emulate: rework seg_override
Date: Wed, 16 Apr 2014 12:46:13 -0400
Message-Id: <1397666774-24713-6-git-send-email-bsd@redhat.com>
In-Reply-To: <1397666774-24713-1-git-send-email-bsd@redhat.com>
References: <1397666774-24713-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_decode_insn already sets a default for seg_override,
so remove it from the zeroed area. Also replace set/get functions
with direct access to the field.

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |  3 +--
 arch/x86/kvm/emulate.c             | 41 +++++++++++++++-----------------------
 2 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index d2ec45d..08a7696 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -322,12 +322,10 @@ struct x86_emulate_ctxt {
 	struct operand dst;
 	int (*execute)(struct x86_emulate_ctxt *ctxt);
 	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
-	bool has_seg_override;
 	bool rip_relative;
 	u8 rex_prefix;
 	u8 lock_prefix;
 	u8 rep_prefix;
-	u8 seg_override;
 	/* bitmaps of registers in _regs[] that can be read */
 	u32 regs_valid;
 	/* bitmaps of registers in _regs[] that have been written */
@@ -338,6 +336,7 @@ struct x86_emulate_ctxt {
 	u8 modrm_reg;
 	u8 modrm_rm;
 	u8 modrm_seg;
+	u8 seg_override;
 	u64 d;
 	unsigned long _eip;
 	struct operand memop;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e459c4f..2b146b7 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -512,12 +512,6 @@ static u32 desc_limit_scaled(struct desc_struct *desc)
 	return desc->g ? (limit << 12) | 0xfff : limit;
 }
 
-static void set_seg_override(struct x86_emulate_ctxt *ctxt, int seg)
-{
-	ctxt->has_seg_override = true;
-	ctxt->seg_override = seg;
-}
-
 static unsigned long seg_base(struct x86_emulate_ctxt *ctxt, int seg)
 {
 	if (ctxt->mode == X86EMUL_MODE_PROT64 && seg < VCPU_SREG_FS)
@@ -526,14 +520,6 @@ static unsigned long seg_base(struct x86_emulate_ctxt *ctxt, int seg)
 	return ctxt->ops->get_cached_segment_base(ctxt, seg);
 }
 
-static unsigned seg_override(struct x86_emulate_ctxt *ctxt)
-{
-	if (!ctxt->has_seg_override)
-		return 0;
-
-	return ctxt->seg_override;
-}
-
 static int emulate_exception(struct x86_emulate_ctxt *ctxt, int vec,
 			     u32 error, bool valid)
 {
@@ -4192,7 +4178,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
 		op->addr.mem.ea =
 			register_address(ctxt, reg_read(ctxt, VCPU_REGS_RSI));
-		op->addr.mem.seg = seg_override(ctxt);
+		op->addr.mem.seg = ctxt->seg_override;
 		op->val = 0;
 		op->count = 1;
 		break;
@@ -4203,7 +4189,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 			register_address(ctxt,
 				reg_read(ctxt, VCPU_REGS_RBX) +
 				(reg_read(ctxt, VCPU_REGS_RAX) & 0xff));
-		op->addr.mem.seg = seg_override(ctxt);
+		op->addr.mem.seg = ctxt->seg_override;
 		op->val = 0;
 		break;
 	case OpImmFAddr:
@@ -4250,6 +4236,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	int mode = ctxt->mode;
 	int def_op_bytes, def_ad_bytes, goffset, simd_prefix;
 	bool op_prefix = false;
+	bool has_seg_override = false;
 	struct opcode opcode;
 
 	ctxt->memop.type = OP_NONE;
@@ -4303,11 +4290,13 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 		case 0x2e:	/* CS override */
 		case 0x36:	/* SS override */
 		case 0x3e:	/* DS override */
-			set_seg_override(ctxt, (ctxt->b >> 3) & 3);
+			has_seg_override = true;
+			ctxt->seg_override = (ctxt->b >> 3) & 3;
 			break;
 		case 0x64:	/* FS override */
 		case 0x65:	/* GS override */
-			set_seg_override(ctxt, ctxt->b & 7);
+			has_seg_override = true;
+			ctxt->seg_override = ctxt->b & 7;
 			break;
 		case 0x40 ... 0x4f: /* REX */
 			if (mode != X86EMUL_MODE_PROT64)
@@ -4438,17 +4427,19 @@ done_prefixes:
 	/* ModRM and SIB bytes. */
 	if (ctxt->d & ModRM) {
 		rc = decode_modrm(ctxt, &ctxt->memop);
-		if (!ctxt->has_seg_override)
-			set_seg_override(ctxt, ctxt->modrm_seg);
+		if (!has_seg_override) {
+			has_seg_override = true;
+			ctxt->seg_override = ctxt->modrm_seg;
+		}
 	} else if (ctxt->d & MemAbs)
 		rc = decode_abs(ctxt, &ctxt->memop);
 	if (rc != X86EMUL_CONTINUE)
 		goto done;
 
-	if (!ctxt->has_seg_override)
-		set_seg_override(ctxt, VCPU_SREG_DS);
+	if (!has_seg_override)
+		ctxt->seg_override = VCPU_SREG_DS;
 
-	ctxt->memop.addr.mem.seg = seg_override(ctxt);
+	ctxt->memop.addr.mem.seg = ctxt->seg_override;
 
 	if (ctxt->memop.type == OP_MEM && ctxt->ad_bytes != 8)
 		ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;
@@ -4550,8 +4541,8 @@ static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
 
 void init_decode_cache(struct x86_emulate_ctxt *ctxt)
 {
-	memset(&ctxt->has_seg_override, 0,
-	       (void *)&ctxt->modrm - (void *)&ctxt->has_seg_override);
+	memset(&ctxt->rip_relative, 0,
+	       (void *)&ctxt->modrm - (void *)&ctxt->rip_relative);
 
 	ctxt->io_read.pos = 0;
 	ctxt->io_read.end = 0;
-- 
1.8.3.1

