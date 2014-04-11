Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbaDKAEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbaDKAE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:04:27 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 6/6] KVM: emulate: remove memopp and rip_relative
Date: Thu, 10 Apr 2014 20:03:32 -0400
Message-Id: <1397174612-17373-7-git-send-email-bsd@redhat.com>
In-Reply-To: <1397174612-17373-1-git-send-email-bsd@redhat.com>
References: <1397174612-17373-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move typecast on "out of range value" of mem.ea to
decode_modrm. rip_relative is only set in decode_modrm,
change it to a local var

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |  2 --
 arch/x86/kvm/emulate.c             | 18 +++++++-----------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 08a7696..813254b 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -322,7 +322,6 @@ struct x86_emulate_ctxt {
 	struct operand dst;
 	int (*execute)(struct x86_emulate_ctxt *ctxt);
 	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
-	bool rip_relative;
 	u8 rex_prefix;
 	u8 lock_prefix;
 	u8 rep_prefix;
@@ -342,7 +341,6 @@ struct x86_emulate_ctxt {
 	struct operand memop;
 	/* Fields above regs are cleared together. */
 	unsigned long _regs[NR_VCPU_REGS];
-	struct operand *memopp;
 	struct fetch_cache fetch;
 	struct read_cache io_read;
 	struct read_cache mem_read;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index b8affac..fcdf5b7 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1053,6 +1053,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 	int index_reg, base_reg, scale;
 	int rc = X86EMUL_CONTINUE;
 	ulong modrm_ea = 0;
+	bool rip_relative = false;
 
 	index_reg = (ctxt->rex_prefix << 2) & 8; /* REX.X */
 	base_reg = (ctxt->rex_prefix << 3) & 8; /* REG.B */
@@ -1155,7 +1156,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 				modrm_ea += reg_read(ctxt, index_reg) << scale;
 		} else if ((ctxt->modrm_rm & 7) == 5 && ctxt->modrm_mod == 0) {
 			if (ctxt->mode == X86EMUL_MODE_PROT64)
-				ctxt->rip_relative = 1;
+				rip_relative = true;
 		} else {
 			base_reg = ctxt->modrm_rm;
 			modrm_ea += reg_read(ctxt, base_reg);
@@ -1175,6 +1176,9 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 		}
 	}
 	op->addr.mem.ea = modrm_ea;
+	ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;
+	if (rip_relative)
+		ctxt->memop.addr.mem.ea += ctxt->_eip;
 done:
 	return rc;
 }
@@ -4088,7 +4092,6 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		ctxt->memop.bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
 	mem_common:
 		*op = ctxt->memop;
-		ctxt->memopp = op;
 		if (ctxt->d & BitOp)
 			fetch_bit_operand(ctxt);
 		op->orig_val = op->val;
@@ -4240,7 +4243,6 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	struct opcode opcode;
 
 	ctxt->memop.type = OP_NONE;
-	ctxt->memopp = NULL;
 	ctxt->_eip = ctxt->eip;
 	ctxt->fetch.start = ctxt->_eip;
 	ctxt->fetch.end = ctxt->fetch.start + insn_len;
@@ -4441,9 +4443,6 @@ done_prefixes:
 
 	ctxt->memop.addr.mem.seg = ctxt->seg_override;
 
-	if (ctxt->memop.type == OP_MEM && ctxt->ad_bytes != 8)
-		ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;
-
 	/*
 	 * Decode and fetch the source operand: register, memory
 	 * or immediate.
@@ -4464,9 +4463,6 @@ done_prefixes:
 	rc = decode_operand(ctxt, &ctxt->dst, (ctxt->d >> DstShift) & OpMask);
 
 done:
-	if (ctxt->memopp && ctxt->memopp->type == OP_MEM && ctxt->rip_relative)
-		ctxt->memopp->addr.mem.ea += ctxt->_eip;
-
 	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
 }
 
@@ -4541,8 +4537,8 @@ static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
 
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

