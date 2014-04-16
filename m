Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaDPQrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:47:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbaDPQqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:46:37 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 6/6] KVM: emulate: remove memopp and rip_relative
Date: Wed, 16 Apr 2014 12:46:14 -0400
Message-Id: <1397666774-24713-7-git-send-email-bsd@redhat.com>
In-Reply-To: <1397666774-24713-1-git-send-email-bsd@redhat.com>
References: <1397666774-24713-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move typecast on "out of range value" of mem.ea to
decode_modrm. rip_relative is only set in decode_modrm,
change it to a local var

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |  8 +++++---
 arch/x86/kvm/emulate.c             | 20 +++++++++-----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 08a7696..085d688 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -322,7 +322,11 @@ struct x86_emulate_ctxt {
 	struct operand dst;
 	int (*execute)(struct x86_emulate_ctxt *ctxt);
 	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
-	bool rip_relative;
+	/*
+	 * The following five fields are cleared together,
+	 * the rest are initialized unconditionally in x86_decode_insn
+	 * or elsewhere
+	 */
 	u8 rex_prefix;
 	u8 lock_prefix;
 	u8 rep_prefix;
@@ -340,9 +344,7 @@ struct x86_emulate_ctxt {
 	u64 d;
 	unsigned long _eip;
 	struct operand memop;
-	/* Fields above regs are cleared together. */
 	unsigned long _regs[NR_VCPU_REGS];
-	struct operand *memopp;
 	struct fetch_cache fetch;
 	struct read_cache io_read;
 	struct read_cache mem_read;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2b146b7..b9881e7 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1053,6 +1053,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 	int index_reg, base_reg, scale;
 	int rc = X86EMUL_CONTINUE;
 	ulong modrm_ea = 0;
+	bool rip_relative = false;
 
 	ctxt->modrm_reg = ((ctxt->rex_prefix << 1) & 8); /* REX.R */
 	index_reg = (ctxt->rex_prefix << 2) & 8; /* REX.X */
@@ -1155,7 +1156,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 				modrm_ea += reg_read(ctxt, index_reg) << scale;
 		} else if ((ctxt->modrm_rm & 7) == 5 && ctxt->modrm_mod == 0) {
 			if (ctxt->mode == X86EMUL_MODE_PROT64)
-				ctxt->rip_relative = 1;
+				rip_relative = true;
 		} else {
 			base_reg = ctxt->modrm_rm;
 			modrm_ea += reg_read(ctxt, base_reg);
@@ -1175,6 +1176,11 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 		}
 	}
 	op->addr.mem.ea = modrm_ea;
+	if (ctxt->ad_bytes != 8)
+		ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;
+	if (rip_relative)
+		ctxt->memop.addr.mem.ea += ctxt->_eip;
+
 done:
 	return rc;
 }
@@ -4088,7 +4094,6 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		ctxt->memop.bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
 	mem_common:
 		*op = ctxt->memop;
-		ctxt->memopp = op;
 		if (ctxt->d & BitOp)
 			fetch_bit_operand(ctxt);
 		op->orig_val = op->val;
@@ -4240,7 +4245,6 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	struct opcode opcode;
 
 	ctxt->memop.type = OP_NONE;
-	ctxt->memopp = NULL;
 	ctxt->_eip = ctxt->eip;
 	ctxt->fetch.start = ctxt->_eip;
 	ctxt->fetch.end = ctxt->fetch.start + insn_len;
@@ -4441,9 +4445,6 @@ done_prefixes:
 
 	ctxt->memop.addr.mem.seg = ctxt->seg_override;
 
-	if (ctxt->memop.type == OP_MEM && ctxt->ad_bytes != 8)
-		ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;
-
 	/*
 	 * Decode and fetch the source operand: register, memory
 	 * or immediate.
@@ -4464,9 +4465,6 @@ done_prefixes:
 	rc = decode_operand(ctxt, &ctxt->dst, (ctxt->d >> DstShift) & OpMask);
 
 done:
-	if (ctxt->memopp && ctxt->memopp->type == OP_MEM && ctxt->rip_relative)
-		ctxt->memopp->addr.mem.ea += ctxt->_eip;
-
 	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
 }
 
@@ -4541,8 +4539,8 @@ static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
 
 void init_decode_cache(struct x86_emulate_ctxt *ctxt)
 {
-	memset(&ctxt->rip_relative, 0,
-	       (void *)&ctxt->modrm - (void *)&ctxt->rip_relative);
+	memset(&ctxt->rex_prefix, 0,
+	       (void *)&ctxt->modrm - (void *)&ctxt->rex_prefix);
 
 	ctxt->io_read.pos = 0;
 	ctxt->io_read.end = 0;
-- 
1.8.3.1

