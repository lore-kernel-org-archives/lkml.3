Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaEOQvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:51:53 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46262 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbaEOQvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:51:49 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jan.kiszka@siemens.com, kvm@vger.kernel.org, gleb@kernel.org,
        avi.kivity@gmail.com
Subject: [PATCH v2 3/4] KVM: x86: check CS.DPL against RPL during task switch
Date: Thu, 15 May 2014 18:51:30 +0200
Message-Id: <1400172691-27030-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400172691-27030-1-git-send-email-pbonzini@redhat.com>
References: <1400172691-27030-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Table 7-1 of the SDM mentions a check that the code segment's
DPL must match the selector's RPL.  This was not done by KVM,
fix it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 47e716ef46b7..2fa7ab069817 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1411,7 +1411,7 @@ static int write_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 
 /* Does not support long mode */
 static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
-				     u16 selector, int seg, u8 cpl)
+				     u16 selector, int seg, u8 cpl, bool in_task_switch)
 {
 	struct desc_struct seg_desc, old_desc;
 	u8 dpl, rpl;
@@ -1486,6 +1486,9 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 			goto exception;
 		break;
 	case VCPU_SREG_CS:
+		if (in_task_switch && rpl != dpl)
+			goto exception;
+
 		if (!(seg_desc.type & 8))
 			goto exception;
 
@@ -1547,7 +1550,7 @@ static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 				   u16 selector, int seg)
 {
 	u8 cpl = ctxt->ops->cpl(ctxt);
-	return __load_segment_descriptor(ctxt, selector, seg, cpl);
+	return __load_segment_descriptor(ctxt, selector, seg, cpl, false);
 }
 
 static void write_register_operand(struct operand *op)
@@ -2440,19 +2443,19 @@ static int load_state_from_tss16(struct x86_emulate_ctxt *ctxt,
 	 * Now load segment descriptors. If fault happens at this stage
 	 * it is handled in a context of new task
 	 */
-	ret = __load_segment_descriptor(ctxt, tss->ldt, VCPU_SREG_LDTR, cpl);
+	ret = __load_segment_descriptor(ctxt, tss->ldt, VCPU_SREG_LDTR, cpl, true);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = __load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES, cpl);
+	ret = __load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES, cpl, true);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = __load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS, cpl);
+	ret = __load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS, cpl, true);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = __load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS, cpl);
+	ret = __load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS, cpl, true);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = __load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS, cpl);
+	ret = __load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS, cpl, true);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
 
@@ -2577,25 +2580,25 @@ static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
 	 * Now load segment descriptors. If fault happenes at this stage
 	 * it is handled in a context of new task
 	 */
-	ret = __load_segment_descriptor(ctxt, tss->ldt_selector, VCPU_SREG_LDTR, cpl);
+	ret = __load_segment_descriptor(ctxt, tss->ldt_selector, VCPU_SREG_LDTR, cpl, true);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = __load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES, cpl);
+	ret = __load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES, cpl, true);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = __load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS, cpl);
+	ret = __load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS, cpl, true);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = __load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS, cpl);
+	ret = __load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS, cpl, true);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = __load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS, cpl);
+	ret = __load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS, cpl, true);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = __load_segment_descriptor(ctxt, tss->fs, VCPU_SREG_FS, cpl);
+	ret = __load_segment_descriptor(ctxt, tss->fs, VCPU_SREG_FS, cpl, true);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-	ret = __load_segment_descriptor(ctxt, tss->gs, VCPU_SREG_GS, cpl);
+	ret = __load_segment_descriptor(ctxt, tss->gs, VCPU_SREG_GS, cpl, true);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
 
-- 
1.8.3.1


