Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaKFWmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:42:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58876 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaKFWma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 104/162] KVM: x86: use new CS.RPL as CPL during task switch
Date: Thu,  6 Nov 2014 14:36:08 -0800
Message-Id: <1415313426-9622-105-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 2356aaeb2f58f491679dc0c38bc3f6dbe54e7ded upstream.

During task switch, all of CS.DPL, CS.RPL, SS.DPL must match (in addition
to all the other requirements) and will be the new CPL.  So far this
worked by carefully setting the CS selector and flag before doing the
task switch; setting CS.selector will already change the CPL.

However, this will not work once we get the CPL from SS.DPL, because
then you will have to set the full segment descriptor cache to change
the CPL.  ctxt->ops->cpl(ctxt) will then return the old CPL during the
task switch, and the check that SS.DPL == CPL will fail.

Temporarily assume that the CPL comes from CS.RPL during task switch
to a protected-mode task.  This is the same approach used in QEMU's
emulation code, which (until version 2.0) manually tracks the CPL.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ kamal: 3.13-stable prereq for
  d1442d8 KVM: x86: Handle errors when RIP is set during far jumps ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/emulate.c | 60 +++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 38d3751..300c164 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1436,11 +1436,11 @@ static int write_segment_descriptor(struct x86_emulate_ctxt *ctxt,
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
@@ -1468,7 +1468,6 @@ static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 	}
 
 	rpl = selector & 3;
-	cpl = ctxt->ops->cpl(ctxt);
 
 	/* NULL selector is not valid for TR, CS and SS (except for long mode) */
 	if ((seg == VCPU_SREG_CS
@@ -1570,6 +1569,13 @@ exception:
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
@@ -2447,6 +2453,7 @@ static int load_state_from_tss16(struct x86_emulate_ctxt *ctxt,
 				 struct tss_segment_16 *tss)
 {
 	int ret;
+	u8 cpl;
 
 	ctxt->_eip = tss->ip;
 	ctxt->eflags = tss->flag | 2;
@@ -2469,23 +2476,25 @@ static int load_state_from_tss16(struct x86_emulate_ctxt *ctxt,
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
 
@@ -2564,6 +2573,7 @@ static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
 				 struct tss_segment_32 *tss)
 {
 	int ret;
+	u8 cpl;
 
 	if (ctxt->ops->set_cr(ctxt, 3, tss->cr3))
 		return emulate_gp(ctxt, 0);
@@ -2582,7 +2592,8 @@ static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
 
 	/*
 	 * SDM says that segment selectors are loaded before segment
-	 * descriptors
+	 * descriptors.  This is important because CPL checks will
+	 * use CS.RPL.
 	 */
 	set_segment_selector(ctxt, tss->ldt_selector, VCPU_SREG_LDTR);
 	set_segment_selector(ctxt, tss->es, VCPU_SREG_ES);
@@ -2596,43 +2607,38 @@ static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
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
1.9.1

