Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaDCW2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:28:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbaDCW2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:28:22 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC PATCH 1/2] KVM: emulate: move init_decode_cache to emulate.c
Date: Thu,  3 Apr 2014 18:27:49 -0400
Message-Id: <1396564070-5586-2-git-send-email-bsd@redhat.com>
In-Reply-To: <1396564070-5586-1-git-send-email-bsd@redhat.com>
References: <1396564070-5586-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Core emulator functions all belong in emulator.c,
x86 should have no knowledge of emulator internals

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |  1 +
 arch/x86/kvm/emulate.c             | 13 +++++++++++++
 arch/x86/kvm/x86.c                 | 13 -------------
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index d085f73..ad4cca8 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -436,6 +436,7 @@ bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
 #define EMULATION_OK 0
 #define EMULATION_RESTART 1
 #define EMULATION_INTERCEPTED 2
+void init_decode_cache(struct x86_emulate_ctxt *ctxt);
 int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
 int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
 			 u16 tss_selector, int idt_index, int reason,
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8ca292c..8e2b866 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4550,6 +4550,19 @@ static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
 	return X86EMUL_CONTINUE;
 }
 
+void init_decode_cache(struct x86_emulate_ctxt *ctxt)
+{
+	memset(&ctxt->opcode_len, 0,
+	       (void *)&ctxt->_regs - (void *)&ctxt->opcode_len);
+
+	ctxt->fetch.start = 0;
+	ctxt->fetch.end = 0;
+	ctxt->io_read.pos = 0;
+	ctxt->io_read.end = 0;
+	ctxt->mem_read.pos = 0;
+	ctxt->mem_read.end = 0;
+}
+
 int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 {
 	const struct x86_emulate_ops *ops = ctxt->ops;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4fad05d..122410d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4951,19 +4951,6 @@ static void inject_emulated_exception(struct kvm_vcpu *vcpu)
 		kvm_queue_exception(vcpu, ctxt->exception.vector);
 }
 
-static void init_decode_cache(struct x86_emulate_ctxt *ctxt)
-{
-	memset(&ctxt->opcode_len, 0,
-	       (void *)&ctxt->_regs - (void *)&ctxt->opcode_len);
-
-	ctxt->fetch.start = 0;
-	ctxt->fetch.end = 0;
-	ctxt->io_read.pos = 0;
-	ctxt->io_read.end = 0;
-	ctxt->mem_read.pos = 0;
-	ctxt->mem_read.end = 0;
-}
-
 static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 {
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
-- 
1.8.3.1

