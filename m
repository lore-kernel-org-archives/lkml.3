Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbaGULjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:39:22 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:48127 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932191AbaGULjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:39:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcBAIb6zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBSdSEFFXGYhCuCiGTBeOZ2QHFoQwBYpfqDxpgQM
X-IPAS-Result: AjcBAIb6zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBSdSEFFXGYhCuCiGTBeOZ2QHFoQwBYpfqDxpgQM
X-IronPort-AV: E=Sophos;i="5.01,700,1400014800"; 
   d="scan'208";a="116353324"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 4/7] KVM: vmx: set rflags.rf during fault injection
Date: Mon, 21 Jul 2014 14:37:27 +0300
Message-Id: <1405942650-22589-5-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMX does not automatically set rflags.rf during event injection. This patch
does partial job, setting rflags.rf upon fault injection.  It also marks that
injection of trap/interrupt during rep-string instruction is not properly
emulated. It is unclear how to do it efficiently without decoding the guest
instruction before interrupt injection.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/vmx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0c9569b..8edb785 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2006,6 +2006,7 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 				bool reinject)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long rflags;
 	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
 	if (!reinject && is_guest_mode(vcpu) &&
@@ -2017,6 +2018,12 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
 	}
 
+	rflags = vmx_get_rflags(vcpu);
+	if (kvm_exception_type(nr) == EXCPT_FAULT)
+		vmx_set_rflags(vcpu, rflags | X86_EFLAGS_RF);
+
+	/* TODO: Set rflags.rf on trap during rep-string */
+
 	if (vmx->rmode.vm86_active) {
 		int inc_eip = 0;
 		if (kvm_exception_is_soft(nr))
@@ -4631,8 +4638,10 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu)
 		intr |= INTR_TYPE_SOFT_INTR;
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
 			     vmx->vcpu.arch.event_exit_inst_len);
-	} else
+	} else {
+		/* TODO: Set rflags.rf during rep-string */
 		intr |= INTR_TYPE_EXT_INTR;
+	}
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr);
 }
 
-- 
1.9.1

