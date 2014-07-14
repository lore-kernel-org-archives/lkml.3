Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaGNLl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:41:57 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62632 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbaGNLjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:39:16 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Bandan Das <bsd@redhat.com>
Subject: [PATCH 12/19] KVM: emulate: rework seg_override
Date: Mon, 14 Jul 2014 13:38:36 +0200
Message-Id: <1405337923-4776-13-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
References: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bandan Das <bsd@redhat.com>

x86_decode_insn already sets a default for seg_override,
so remove it from the zeroed area. Also replace set/get functions
with direct access to the field.

Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |  3 +--
 arch/x86/kvm/emulate.c             | 41 +++++++++++++++-----------------------
 2 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index d40a10a38a80..6c808408326f 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -295,12 +295,10 @@ struct x86_emulate_ctxt {
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
@@ -311,6 +309,7 @@ struct x86_emulate_ctxt {
 	u8 modrm_reg;
 	u8 modrm_rm;
 	u8 modrm_seg;
+	u8 seg_override;
 	u64 d;
 	unsigned long _eip;
 	struct operand memop;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 3e9bbdc4c76a..08badf638fb0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -514,12 +514,6 @@ static u32 desc_limit_scaled(struct desc_struct *desc)
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
@@ -528,14 +522,6 @@ static unsigned long seg_base(struct x86_emulate_ctxt *ctxt, int seg)
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
@@ -4169,7 +4155,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
 		op->addr.mem.ea =
 			register_address(ctxt, reg_read(ctxt, VCPU_REGS_RSI));
-		op->addr.mem.seg = seg_override(ctxt);
+		op->addr.mem.seg = ctxt->seg_override;
 		op->val = 0;
 		op->count = 1;
 		break;
@@ -4180,7 +4166,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 			register_address(ctxt,
 				reg_read(ctxt, VCPU_REGS_RBX) +
 				(reg_read(ctxt, VCPU_REGS_RAX) & 0xff));
-		op->addr.mem.seg = seg_override(ctxt);
+		op->addr.mem.seg = ctxt->seg_override;
 		op->val = 0;
 		break;
 	case OpImmFAddr:
@@ -4227,6 +4213,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	int mode = ctxt->mode;
 	int def_op_bytes, def_ad_bytes, goffset, simd_prefix;
 	bool op_prefix = false;
+	bool has_seg_override = false;
 	struct opcode opcode;
 
 	ctxt->memop.type = OP_NONE;
@@ -4280,11 +4267,13 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
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
@@ -4422,17 +4411,19 @@ done_prefixes:
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
@@ -4534,8 +4525,8 @@ static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
 
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


