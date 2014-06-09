Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbaFIM7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 08:59:54 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47008 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933471AbaFIM7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:44 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org, Bandan Das <bsd@redhat.com>
Subject: [PATCH 16/25] KVM: emulate: clean up initializations in init_decode_cache
Date: Mon,  9 Jun 2014 14:59:04 +0200
Message-Id: <1402318753-23362-17-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bandan Das <bsd@redhat.com>

A lot of initializations are unnecessary as they get set to
appropriate values before actually being used. Optimize
placement of fields in x86_emulate_ctxt

Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h | 20 +++++++++++---------
 arch/x86/kvm/emulate.c             |  7 ++-----
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index b8456835eddb..8f03e7158800 100644
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
-	u8 rex_prefix;
 	struct operand src;
 	struct operand src2;
 	struct operand dst;
-	bool has_seg_override;
-	u8 seg_override;
-	u64 d;
 	int (*execute)(struct x86_emulate_ctxt *ctxt);
 	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
+	bool has_seg_override;
+	bool rip_relative;
+	u8 rex_prefix;
+	u8 lock_prefix;
+	u8 rep_prefix;
+	u8 seg_override;
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
+	u64 d;
 	unsigned long _eip;
 	struct operand memop;
-	u32 regs_valid;  /* bitmaps of registers in _regs[] that can be read */
-	u32 regs_dirty;  /* bitmaps of registers in _regs[] that have been written */
 	/* Fields above regs are cleared together. */
 	unsigned long _regs[NR_VCPU_REGS];
 	struct operand *memopp;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c92b1cfbb430..cef069e17e2e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4608,14 +4608,11 @@ static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
 
 void init_decode_cache(struct x86_emulate_ctxt *ctxt)
 {
-	memset(&ctxt->opcode_len, 0,
-	       (void *)&ctxt->_regs - (void *)&ctxt->opcode_len);
+	memset(&ctxt->has_seg_override, 0,
+	       (void *)&ctxt->modrm - (void *)&ctxt->has_seg_override);
 
-	ctxt->fetch.start = 0;
-	ctxt->fetch.end = 0;
 	ctxt->io_read.pos = 0;
 	ctxt->io_read.end = 0;
-	ctxt->mem_read.pos = 0;
 	ctxt->mem_read.end = 0;
 }
 
-- 
1.8.3.1


