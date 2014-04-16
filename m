Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbaDPQsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:48:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbaDPQqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:46:32 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 4/6] KVM: emulate: clean up initializations in init_decode_cache
Date: Wed, 16 Apr 2014 12:46:12 -0400
Message-Id: <1397666774-24713-5-git-send-email-bsd@redhat.com>
In-Reply-To: <1397666774-24713-1-git-send-email-bsd@redhat.com>
References: <1397666774-24713-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of initializations are unnecessary as they get set to
appropriate values before actually being used. Optimize
placement of fields in x86_emulate_ctxt

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h | 20 +++++++++++---------
 arch/x86/kvm/emulate.c             |  7 ++-----
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index ad4cca8..d2ec45d 100644
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
index e12ac87..e459c4f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4550,14 +4550,11 @@ static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
 
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

