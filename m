Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaGNLnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:43:03 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49972 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147AbaGNLjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:39:03 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 06/19] KVM: emulate: speed up emulated moves
Date: Mon, 14 Jul 2014 13:38:30 +0200
Message-Id: <1405337923-4776-7-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
References: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can just blindly move all 16 bytes of ctxt->src's value to ctxt->dst.
write_register_operand will take care of writing only the lower bytes.

Avoiding a call to memcpy (the compiler optimizes it out) gains about
200 cycles on kvm-unit-tests for register-to-register moves, and makes
them about as fast as arithmetic instructions.

We could perhaps get a larger speedup by moving all instructions _except_
moves out of x86_emulate_insn, removing opcode_len, and replacing the
switch statement with an inlined em_mov.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h | 2 +-
 arch/x86/kvm/emulate.c             | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 0e0151c13b2c..432447370044 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -233,7 +233,7 @@ struct operand {
 	union {
 		unsigned long val;
 		u64 val64;
-		char valptr[sizeof(unsigned long) + 2];
+		char valptr[sizeof(sse128_t)];
 		sse128_t vec_val;
 		u64 mm_val;
 		void *data;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index ea56dae3e67c..27f677ef703e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2990,7 +2990,7 @@ static int em_rdpmc(struct x86_emulate_ctxt *ctxt)
 
 static int em_mov(struct x86_emulate_ctxt *ctxt)
 {
-	memcpy(ctxt->dst.valptr, ctxt->src.valptr, ctxt->op_bytes);
+	memcpy(ctxt->dst.valptr, ctxt->src.valptr, sizeof(ctxt->src.valptr));
 	return X86EMUL_CONTINUE;
 }
 
-- 
1.8.3.1


