Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaGNLjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:39:52 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53516 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbaGNLjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:39:17 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Bandan Das <bsd@redhat.com>
Subject: [PATCH 13/19] KVM: emulate: do not initialize memopp
Date: Mon, 14 Jul 2014 13:38:37 +0200
Message-Id: <1405337923-4776-14-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
References: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
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
index 6c808408326f..fcf58cd25ebd 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -295,6 +295,11 @@ struct x86_emulate_ctxt {
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
index 08badf638fb0..390400a54a9c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1177,6 +1177,9 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 		}
 	}
 	op->addr.mem.ea = modrm_ea;
+	if (ctxt->ad_bytes != 8)
+		ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;
+
 done:
 	return rc;
 }
@@ -4425,9 +4428,6 @@ done_prefixes:
 
 	ctxt->memop.addr.mem.seg = ctxt->seg_override;
 
-	if (ctxt->memop.type == OP_MEM && ctxt->ad_bytes != 8)
-		ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;
-
 	/*
 	 * Decode and fetch the source operand: register, memory
 	 * or immediate.
@@ -4448,7 +4448,7 @@ done_prefixes:
 	rc = decode_operand(ctxt, &ctxt->dst, (ctxt->d >> DstShift) & OpMask);
 
 done:
-	if (ctxt->memopp && ctxt->memopp->type == OP_MEM && ctxt->rip_relative)
+	if (ctxt->rip_relative)
 		ctxt->memopp->addr.mem.ea += ctxt->_eip;
 
 	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
-- 
1.8.3.1


