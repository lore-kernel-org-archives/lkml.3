Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3JaK3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:29:53 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:51245 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3JaK3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:29:51 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gleb@redhat.com, stable@vger.kernel.org
Subject: [PATCH] KVM: x86: emulate SAHF instruction
Date: Thu, 31 Oct 2013 11:29:42 +0100
Message-Id: <1383215382-10072-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yet another instruction that we fail to emulate, this time found
in Windows 2008R2 32-bit.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Testcase on its way.  BTW, lahf/sahf is another candidate for
	#UD emulation.

 arch/x86/kvm/emulate.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8e2a07bd8eac..ef750e75c930 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3296,6 +3296,18 @@ static int em_cpuid(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
+static int em_sahf(struct x86_emulate_ctxt *ctxt)
+{
+	u32 flags;
+
+	flags = EFLG_CF | EFLG_PF | EFLG_AF | EFLG_ZF | EFLG_SF;
+	flags &= *reg_rmw(ctxt, VCPU_REGS_RAX) >> 8;
+
+	ctxt->eflags &= ~0xffUL;
+	ctxt->eflags |= flags | X86_EFLAGS_FIXED;
+	return X86EMUL_CONTINUE;
+}
+
 static int em_lahf(struct x86_emulate_ctxt *ctxt)
 {
 	*reg_rmw(ctxt, VCPU_REGS_RAX) &= ~0xff00UL;
@@ -3788,7 +3800,7 @@ static const struct opcode opcode_table[256] = {
 	DI(SrcAcc | DstReg, pause), X7(D(SrcAcc | DstReg)),
 	/* 0x98 - 0x9F */
 	D(DstAcc | SrcNone), I(ImplicitOps | SrcAcc, em_cwd),
-	I(SrcImmFAddr | No64, em_call_far), N,
+	I(SrcImmFAddr | No64, em_call_far), I(ImplicitOps, em_sahf),
 	II(ImplicitOps | Stack, em_pushf, pushf),
 	II(ImplicitOps | Stack, em_popf, popf), N, I(ImplicitOps, em_lahf),
 	/* 0xA0 - 0xA7 */
-- 
1.8.3.1

