Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaHTLYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:24:50 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:42538 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaHTLYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:24:48 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: bdas@redhat.com
Subject: [PATCH] KVM: emulate: warn on invalid or uninitialized exception numbers
Date: Wed, 20 Aug 2014 13:24:42 +0200
Message-Id: <1408533882-18304-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These were reported when running Jailhouse on AMD processors.

Initialize ctxt->exception.vector with an invalid exception number,
and warn if it remained invalid even though the emulator got
an X86EMUL_PROPAGATE_FAULT return code.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 5 ++++-
 arch/x86/kvm/x86.c     | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4fbf4b598f92..e5bf13003cd2 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -527,6 +527,7 @@ static unsigned long seg_base(struct x86_emulate_ctxt *ctxt, int seg)
 static int emulate_exception(struct x86_emulate_ctxt *ctxt, int vec,
 			     u32 error, bool valid)
 {
+	WARN_ON(vec > 0x1f);
 	ctxt->exception.vector = vec;
 	ctxt->exception.error_code = error;
 	ctxt->exception.error_code_valid = valid;
@@ -4827,8 +4828,10 @@ writeback:
 	ctxt->eip = ctxt->_eip;
 
 done:
-	if (rc == X86EMUL_PROPAGATE_FAULT)
+	if (rc == X86EMUL_PROPAGATE_FAULT) {
+		WARN_ON(ctxt->exception.vector > 0x1f);
 		ctxt->have_exception = true;
+	}
 	if (rc == X86EMUL_INTERCEPTED)
 		return EMULATION_INTERCEPTED;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 737b4bdac41c..cd718c01cdf1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5248,6 +5248,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 
 		ctxt->interruptibility = 0;
 		ctxt->have_exception = false;
+		ctxt->exception.vector = -1;
 		ctxt->perm_ok = false;
 
 		ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
-- 
1.8.3.1

