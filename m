Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbaDGPiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:38:51 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:18095 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaDGPir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:38:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMFAODFQlOERM5e/2dsb2JhbABZgwYBvXGGHgGBHYElFnSCU1KBPxKHecVjhhQXjnGEPwSJVKFGgzM6
X-IPAS-Result: ArMFAODFQlOERM5e/2dsb2JhbABZgwYBvXGGHgGBHYElFnSCU1KBPxKHecVjhhQXjnGEPwSJVKFGgzM6
X-IronPort-AV: E=Sophos;i="4.97,810,1389736800"; 
   d="scan'208";a="101721722"
From: Nadav Amit <namit@cs.technion.ac.il>
To: gleb@kernel.org, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH] KVM: x86: Fix CR3 and LDT sel should not be saved in TSS
Date: Mon,  7 Apr 2014 18:37:47 +0300
Message-Id: <1396885067-6491-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Intel specifications, only general purpose registers and segment
selectors should are saved in the old TSS during 32-bit task-switch.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 205b17e..0dec502 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2496,7 +2496,7 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
 static void save_state_to_tss32(struct x86_emulate_ctxt *ctxt,
 				struct tss_segment_32 *tss)
 {
-	tss->cr3 = ctxt->ops->get_cr(ctxt, 3);
+	/* CR3 and ldt selector are not saved intentionally */
 	tss->eip = ctxt->_eip;
 	tss->eflags = ctxt->eflags;
 	tss->eax = reg_read(ctxt, VCPU_REGS_RAX);
@@ -2514,7 +2514,6 @@ static void save_state_to_tss32(struct x86_emulate_ctxt *ctxt,
 	tss->ds = get_segment_selector(ctxt, VCPU_SREG_DS);
 	tss->fs = get_segment_selector(ctxt, VCPU_SREG_FS);
 	tss->gs = get_segment_selector(ctxt, VCPU_SREG_GS);
-	tss->ldt_selector = get_segment_selector(ctxt, VCPU_SREG_LDTR);
 }
 
 static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
@@ -2604,6 +2603,8 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
 	struct tss_segment_32 tss_seg;
 	int ret;
 	u32 new_tss_base = get_desc_base(new_desc);
+	u32 eip_offset = offsetof(struct tss_segment_32, eip);
+	u32 ldt_sel_offset = offsetof(struct tss_segment_32, ldt_selector);
 
 	ret = ops->read_std(ctxt, old_tss_base, &tss_seg, sizeof tss_seg,
 			    &ctxt->exception);
@@ -2613,8 +2614,9 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
 
 	save_state_to_tss32(ctxt, &tss_seg);
 
-	ret = ops->write_std(ctxt, old_tss_base, &tss_seg, sizeof tss_seg,
-			     &ctxt->exception);
+	/* Only GP registers and segment selectors are saved */
+	ret = ops->write_std(ctxt, old_tss_base + eip_offset, &tss_seg.eip,
+			     ldt_sel_offset - eip_offset, &ctxt->exception);
 	if (ret != X86EMUL_CONTINUE)
 		/* FIXME: need to provide precise fault address */
 		return ret;
-- 
1.7.10.4

