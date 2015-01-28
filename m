Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934765AbbA1Eyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:54:37 -0500
Received: from mail.kernel.org ([198.145.29.136]:39566 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761645AbbA1EVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:21:30 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 082/177] KVM: x86: use new CS.RPL as CPL during task switch
Date: Wed, 28 Jan 2015 12:08:50 +0800
Message-Id: <1422418236-12852-163-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/x86/kvm/emulate.c | 60 +++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c3e1942..1089e43 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1251,11 +1251,11 @@ static int write_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 }
 
 /* Does not support long mode */
-static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
-				   u16 selector, int seg)
+static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
+				     u16 selector, int seg, u8 cpl)
 {
 	struct desc_struct seg_desc;
-	u8 dpl, rpl, cpl;
+	u8 dpl, rpl;
 	unsigned err_vec = GP_VECTOR;
 	u32 err_code = 0;
 	bool null_selector = !(selector & ~0x3); /* 0000-0003 are null */
@@ -1306,7 +1306,6 @@ static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 
 	rpl = selector & 3;
 	dpl = seg_desc.dpl;
-	cpl = ctxt->ops->cpl(ctxt);
 
 	switch (seg) {
 	case VCPU_SREG_SS:
@@ -1369,6 +1368,13 @@ exception:
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
@@ -2261,6 +2267,7 @@ static int load_state_from_tss16(struct x86_emulate_ctxt *ctxt,
 				 struct tss_segment_16 *tss)
 {
 	int ret;
+	u8 cpl;
 
 	ctxt->_eip = tss->ip;
 	ctxt->eflags = tss->flag | 2;
@@ -2283,23 +2290,25 @@ static int load_state_from_tss16(struct x86_emulate_ctxt *ctxt,
 	set_segment_selector(ctxt, tss->ss, VCPU_SREG_SS);
 	set_segment_selector(ctxt, tss->ds, VCPU_SREG_DS);
 
+	cpl = tss->cs & 3;
+
 	/*
 	 * Now load segment descriptors. If fault happenes at this stage
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
 
@@ -2378,6 +2387,7 @@ static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
 				 struct tss_segment_32 *tss)
 {
 	int ret;
+	u8 cpl;
 
 	if (ctxt->ops->set_cr(ctxt, 3, tss->cr3))
 		return emulate_gp(ctxt, 0);
@@ -2396,7 +2406,8 @@ static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
 
 	/*
 	 * SDM says that segment selectors are loaded before segment
-	 * descriptors
+	 * descriptors.  This is important because CPL checks will
+	 * use CS.RPL.
 	 */
 	set_segment_selector(ctxt, tss->ldt_selector, VCPU_SREG_LDTR);
 	set_segment_selector(ctxt, tss->es, VCPU_SREG_ES);
@@ -2410,43 +2421,38 @@ static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
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

