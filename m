Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaGNLjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:39:24 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45722 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbaGNLjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:39:08 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Bandan Das <bsd@redhat.com>
Subject: [PATCH 08/19] KVM: emulate: move init_decode_cache to emulate.c
Date: Mon, 14 Jul 2014 13:38:32 +0200
Message-Id: <1405337923-4776-9-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
References: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bandan Das <bsd@redhat.com>

Core emulator functions all belong in emulator.c,
x86 should have no knowledge of emulator internals

Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |  1 +
 arch/x86/kvm/emulate.c             | 13 +++++++++++++
 arch/x86/kvm/x86.c                 | 13 -------------
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 432447370044..c22bd9af4311 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -409,6 +409,7 @@ bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
 #define EMULATION_OK 0
 #define EMULATION_RESTART 1
 #define EMULATION_INTERCEPTED 2
+void init_decode_cache(struct x86_emulate_ctxt *ctxt);
 int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
 int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
 			 u16 tss_selector, int idt_index, int reason,
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 32d3da82da2e..851315d93bf7 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4534,6 +4534,19 @@ static int fastop(struct x86_emulate_ctxt *ctxt, void (*fop)(struct fastop *))
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
index cd9316786dca..905edf8557e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4888,19 +4888,6 @@ static void inject_emulated_exception(struct kvm_vcpu *vcpu)
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


