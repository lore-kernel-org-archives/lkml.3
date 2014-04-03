Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaDCW26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:28:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbaDCW22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:28:28 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC PATCH 2/2] KVM: emulate: clean up initializations in init_decode_cache
Date: Thu,  3 Apr 2014 18:27:50 -0400
Message-Id: <1396564070-5586-3-git-send-email-bsd@redhat.com>
In-Reply-To: <1396564070-5586-1-git-send-email-bsd@redhat.com>
References: <1396564070-5586-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of initializations are unnecessary as they get set to
appropriate values before actually being used. Remove some
of them and rework some others if the conditions that set
them are not true

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h | 16 +++++++------
 arch/x86/kvm/emulate.c             | 46 +++++++++++++++++++++++++++++++++-----
 2 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index ad4cca8..ccb7911 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -315,30 +315,32 @@ struct x86_emulate_ctxt {
 	u8 opcode_len;
 	u8 b;
 	u8 intercept;
-	u8 lock_prefix;
-	u8 rep_prefix;
 	u8 op_bytes;
 	u8 ad_bytes;
 	u8 rex_prefix;
 	struct operand src;
 	struct operand src2;
 	struct operand dst;
+	int (*execute)(struct x86_emulate_ctxt *ctxt);
+	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
+	u8 lock_prefix;
+	u8 rep_prefix;
 	bool has_seg_override;
 	u8 seg_override;
 	u64 d;
-	int (*execute)(struct x86_emulate_ctxt *ctxt);
-	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
+	bool rip_relative;
+	/* bitmaps of registers in _regs[] that can be read */
+	u32 regs_valid;
+	/* bitmaps of registers in _regs[] that have been written */
+	u32 regs_dirty;
 	/* modrm */
 	u8 modrm;
 	u8 modrm_mod;
 	u8 modrm_reg;
 	u8 modrm_rm;
 	u8 modrm_seg;
-	bool rip_relative;
 	unsigned long _eip;
 	struct operand memop;
-	u32 regs_valid;  /* bitmaps of registers in _regs[] that can be read */
-	u32 regs_dirty;  /* bitmaps of registers in _regs[] that have been written */
 	/* Fields above regs are cleared together. */
 	unsigned long _regs[NR_VCPU_REGS];
 	struct operand *memopp;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8e2b866..eac488b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1072,6 +1072,9 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 		ctxt->modrm_reg = (ctxt->rex_prefix & 4) << 1;	/* REX.R */
 		index_reg = (ctxt->rex_prefix & 2) << 2; /* REX.X */
 		ctxt->modrm_rm = base_reg = (ctxt->rex_prefix & 1) << 3; /* REG.B */
+	} else {
+		ctxt->modrm_reg = 0;
+		ctxt->modrm_rm = 0;
 	}
 
 	ctxt->modrm_mod |= (ctxt->modrm & 0xc0) >> 6;
@@ -4357,6 +4360,8 @@ done_prefixes:
 
 	if (ctxt->d & ModRM)
 		ctxt->modrm = insn_fetch(u8, ctxt);
+	else
+		ctxt->modrm = 0;
 
 	while (ctxt->d & GroupMask) {
 		switch (ctxt->d & GroupMask) {
@@ -4435,10 +4440,14 @@ done_prefixes:
 			ctxt->op_bytes = 16;
 		else if (ctxt->d & Mmx)
 			ctxt->op_bytes = 8;
+	} else {
+		ctxt->intercept = 0;
+		ctxt->check_perm = NULL;
 	}
 
 	/* ModRM and SIB bytes. */
 	if (ctxt->d & ModRM) {
+		ctxt->modrm_mod = 0;
 		rc = decode_modrm(ctxt, &ctxt->memop);
 		if (!ctxt->has_seg_override)
 			set_seg_override(ctxt, ctxt->modrm_seg);
@@ -4552,14 +4561,41 @@ static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
 
 void init_decode_cache(struct x86_emulate_ctxt *ctxt)
 {
-	memset(&ctxt->opcode_len, 0,
-	       (void *)&ctxt->_regs - (void *)&ctxt->opcode_len);
 
-	ctxt->fetch.start = 0;
-	ctxt->fetch.end = 0;
+	/*
+	 * Variables that don't require initializing to 0
+	 * opcode_len - set in x86_decode_insn
+	 * b - set in x86_decode_insn
+	 * intercept - conditionally set in x86_decode_insn, added
+	 *             else set to 0
+	 * op_bytes - initialized in x86_decode_insn
+	 * ad_bytes - initialized in x86_decode_insn
+	 * rex_prefix - conditionally set in x86_decode_isn
+	 * struct operands src,src2,dst - set by calling decode_operand
+	 *                                in x86_decode_insn,
+	 *                                default.type = OP_NONE
+	 * (*execute) - set in x86_decode_insn
+	 * (*check_perm) - conditionally set in x86_decode_insn, added
+	 *                 else set to 0
+	 * d - set in x86_decode_insn
+	 * modrm - conditionally set in x86_decode_insn, added else set to 0
+	 * modrm_mod - or'ed in decode_modrm which is conditionally called in
+	 *             in x86_decode_insn, added initialization to 0 before call
+	 * modrm_reg - set in decode_modrm or else decode_register_operand
+	 * modrm_rm - set in decode_modrm, added else set to 0
+	 * modrm_seg - set in decode_modrm
+	 * _eip - set in x86_decode_insn
+	 * memop - .type set to OP_NONE in x86_decode_insn
+	 * ctxt->fetch.start - set in x86_decode_insn
+	 * ctxt->fetch.end
+	 * ctxt->mem_read.pos - set in x86_emulate_insn
+	 */
+
+	memset(&ctxt->lock_prefix, 0,
+	       (void *)&ctxt->modrm - (void *)&ctxt->lock_prefix);
+
 	ctxt->io_read.pos = 0;
 	ctxt->io_read.end = 0;
-	ctxt->mem_read.pos = 0;
 	ctxt->mem_read.end = 0;
 }
 
-- 
1.8.3.1

