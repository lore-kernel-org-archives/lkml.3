Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaFINCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:02:24 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63085 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476AbaFIM7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:47 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org, Bandan Das <bsd@redhat.com>
Subject: [PATCH 18/25] KVM: emulate: do not initialize memopp
Date: Mon,  9 Jun 2014 14:59:06 +0200
Message-Id: <1402318753-23362-19-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bandan Das <bsd@redhat.com>

rip_relative is only set if decode_modrm runs, and if you have ModRM
you will also have a memopp.  We can then access memopp unconditionally.
Note that rip_relative cannot be hoisted up to decode_modrm, or you
break "mov $0, xyz(%rip)".

Also, move typecast on "out of range value" of mem.ea to decode_modrm.

Together, all these optimizations save about 50 cycles on each emulated
instructions (4-6%).

Signed-off-by: Bandan Das <bsd@redhat.com>
[Fix immediate operands with rip-relative addressing. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h | 5 +++++
 arch/x86/kvm/emulate.c             | 8 ++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 268bbd4aae99..692b0bfadf91 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -322,6 +322,11 @@ struct x86_emulate_ctxt {
 	struct operand dst;
 	int (*execute)(struct x86_emulate_ctxt *ctxt);
 	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
+	/*
+	 * The following six fields are cleared together,
+	 * the rest are initialized unconditionally in x86_decode_insn
+	 * or elsewhere
+	 */
 	bool rip_relative;
 	u8 rex_prefix;
 	u8 lock_prefix;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 05f7bb416fc2..32f38a3467a0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1176,6 +1176,9 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 		}
 	}
 	op->addr.mem.ea = modrm_ea;
+	if (ctxt->ad_bytes != 8)
+		ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;
+
 done:
 	return rc;
 }
@@ -4499,9 +4502,6 @@ done_prefixes:
 
 	ctxt->memop.addr.mem.seg = ctxt->seg_override;
 
-	if (ctxt->memop.type == OP_MEM && ctxt->ad_bytes != 8)
-		ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;
-
 	/*
 	 * Decode and fetch the source operand: register, memory
 	 * or immediate.
@@ -4522,7 +4522,7 @@ done_prefixes:
 	rc = decode_operand(ctxt, &ctxt->dst, (ctxt->d >> DstShift) & OpMask);
 
 done:
-	if (ctxt->memopp && ctxt->memopp->type == OP_MEM && ctxt->rip_relative)
+	if (ctxt->rip_relative)
 		ctxt->memopp->addr.mem.ea += ctxt->_eip;
 
 	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
-- 
1.8.3.1


