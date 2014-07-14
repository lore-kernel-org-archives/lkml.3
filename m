Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaGNLmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:42:09 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35278 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaGNLjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:39:14 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Bandan Das <bsd@redhat.com>
Subject: [PATCH 11/19] KVM: emulate: clean up initializations in init_decode_cache
Date: Mon, 14 Jul 2014 13:38:35 +0200
Message-Id: <1405337923-4776-12-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
References: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
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
index c22bd9af4311..d40a10a38a80 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -288,30 +288,32 @@ struct x86_emulate_ctxt {
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
index 94f5f8b94ce9..3e9bbdc4c76a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4534,14 +4534,11 @@ static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
 
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


