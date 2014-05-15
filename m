Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaEOQvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:51:47 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:65428 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbaEOQvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:51:44 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jan.kiszka@siemens.com, kvm@vger.kernel.org, gleb@kernel.org,
        avi.kivity@gmail.com
Subject: [PATCH v2 1/4] KVM: x86: use new CS.RPL as CPL during task switch
Date: Thu, 15 May 2014 18:51:28 +0200
Message-Id: <1400172691-27030-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400172691-27030-1-git-send-email-pbonzini@redhat.com>
References: <1400172691-27030-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During task switch, all of CS.DPL, CS.RPL, SS.DPL must match (in addition
to all the other requirements) and will be the new CPL.  So far this
worked by carefully setting the CS selector and flag before doing the
task switch; however, this will not work once we get the CPL from SS.DPL:
setting SS itself would fail if the task switch changes the privilege
level.

Temporarily assume that the CPL comes from CS.RPL during task switch
to a protected-mode task.  This is the same approach used in QEMU's
emulation code, which (until version 2.0) manually tracks the CPL.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 60 +++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e8a58409b5ac..47e716ef46b7 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1410,11 +1410,11 @@ static int write_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 }
 
 /* Does not support long mode */
-static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
-				   u16 selector, int seg)
+static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
+				     u16 selector, int seg, u8 cpl)
 {
 	struct desc_struct seg_desc, old_desc;
-	u8 dpl, rpl, cpl;
+	u8 dpl, rpl;
 	unsigned err_vec = GP_VECTOR;
 	u32 err_code = 0;
 	bool null_selector = !(selector & ~0x3); /* 0000-0003 are null */
@@ -1442,7 +1442,6 @@ static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 	}
 
 	rpl = selector & 3;
-	cpl = ctxt->ops->cpl(ctxt);
 
 	/* NULL selector is not valid for TR, CS and SS (except for long mode) */
 	if ((seg == VCPU_SREG_CS
@@ -1544,6 +1543,13 @@ exception:
 	return X86EMUL_PROPAGATE_FAULT;
 }
 
+static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
+				   u16 selector, int seg)
+{
+	u8 cpl = ctxt->ops->cpl(ctxt);
+	return __load_segment_descriptor(ctxt, selector, seg, cpl);
+}
+
 static void write_register_operand(struct operand *op)
 {
 	/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
@@ -2405,6 +2411,7 @@ static int load_state_from_tss16(struct x86_emulate_ctxt *ctxt,
 				 struct tss_segment_16 *tss)
 {
 	int ret;
+	u8 cpl;
 
 	ctxt->_eip = tss->ip;
 	ctxt->eflags = tss->flag | 2;
@@ -2427,23 +2434,25 @@ static int load_state_from_tss16(struct x86_emulate_ctxt *ctxt,
 	set_segment_selector(ctxt, tss->ss, VCPU_SREG_SS);
 	set_segment_selector(ctxt, tss->ds, VCPU_SREG_DS);
 
+	cpl = tss->cs & 3;
+
 	/*
 	 * Now load segment descriptors. If fault happens at this stage
 	 * it is handled in a context of new task
 	 */
-	ret = load_segment_descriptor(ctxt, tss->ldt, VCPU_SREG_LDTR);
+	ret = __load_segment_descriptor(ctxt, tss->ldt, VCPU_SREG_LDTR, cpl);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES);
+	ret = __load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES, cpl);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS);
+	ret = __load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS, cpl);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS);
+	ret = __load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS, cpl);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS);
+	ret = __load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS, cpl);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
 
@@ -2521,6 +2530,7 @@ static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
 				 struct tss_segment_32 *tss)
 {
 	int ret;
+	u8 cpl;
 
 	if (ctxt->ops->set_cr(ctxt, 3, tss->cr3))
 		return emulate_gp(ctxt, 0);
@@ -2539,7 +2549,8 @@ static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
 
 	/*
 	 * SDM says that segment selectors are loaded before segment
-	 * descriptors
+	 * descriptors.  This is important because CPL checks will
+	 * use CS.RPL.
 	 */
 	set_segment_selector(ctxt, tss->ldt_selector, VCPU_SREG_LDTR);
 	set_segment_selector(ctxt, tss->es, VCPU_SREG_ES);
@@ -2553,43 +2564,38 @@ static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
 	 * If we're switching between Protected Mode and VM86, we need to make
 	 * sure to update the mode before loading the segment descriptors so
 	 * that the selectors are interpreted correctly.
-	 *
-	 * Need to get rflags to the vcpu struct immediately because it
-	 * influences the CPL which is checked at least when loading the segment
-	 * descriptors and when pushing an error code to the new kernel stack.
-	 *
-	 * TODO Introduce a separate ctxt->ops->set_cpl callback
 	 */
-	if (ctxt->eflags & X86_EFLAGS_VM)
+	if (ctxt->eflags & X86_EFLAGS_VM) {
 		ctxt->mode = X86EMUL_MODE_VM86;
-	else
+		cpl = 3;
+	} else {
 		ctxt->mode = X86EMUL_MODE_PROT32;
-
-	ctxt->ops->set_rflags(ctxt, ctxt->eflags);
+		cpl = tss->cs & 3;
+	}
 
 	/*
 	 * Now load segment descriptors. If fault happenes at this stage
 	 * it is handled in a context of new task
 	 */
-	ret = load_segment_descriptor(ctxt, tss->ldt_selector, VCPU_SREG_LDTR);
+	ret = __load_segment_descriptor(ctxt, tss->ldt_selector, VCPU_SREG_LDTR, cpl);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES);
+	ret = __load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES, cpl);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS);
+	ret = __load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS, cpl);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS);
+	ret = __load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS, cpl);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS);
+	ret = __load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS, cpl);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = load_segment_descriptor(ctxt, tss->fs, VCPU_SREG_FS);
+	ret = __load_segment_descriptor(ctxt, tss->fs, VCPU_SREG_FS, cpl);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = load_segment_descriptor(ctxt, tss->gs, VCPU_SREG_GS);
+	ret = __load_segment_descriptor(ctxt, tss->gs, VCPU_SREG_GS, cpl);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
 
-- 
1.8.3.1


