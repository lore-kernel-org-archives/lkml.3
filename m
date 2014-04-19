Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161000AbaDSWTN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 18:19:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821AbaDSWSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 18:18:09 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] KVM: nVMX: Ack and write vector info to intr_info if L1 asks us to
Date: Sat, 19 Apr 2014 18:17:45 -0400
Message-Id: <1397945866-6961-3-git-send-email-bsd@redhat.com>
In-Reply-To: <1397945866-6961-1-git-send-email-bsd@redhat.com>
References: <1397945866-6961-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This feature emulates the "Acknowledge interrupt on exit" behavior.
We can safely emulate it for L1 to run L2 even if L0 itself has it
disabled (to run L1).

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/irq.c |  1 +
 arch/x86/kvm/vmx.c | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 484bc87..bd0da43 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -113,6 +113,7 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
 
 	return kvm_get_apic_interrupt(v);	/* APIC */
 }
+EXPORT_SYMBOL_GPL(kvm_cpu_get_interrupt);
 
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ce8f6c4..5c0b74d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4526,6 +4526,16 @@ static bool nested_exit_on_intr(struct kvm_vcpu *vcpu)
 		PIN_BASED_EXT_INTR_MASK;
 }
 
+/*
+ * In nested virtualization, check if L1 has set
+ * VM_EXIT_ACK_INTR_ON_EXIT
+ */
+static bool nested_exit_intr_ack_set(struct kvm_vcpu *vcpu)
+{
+	return get_vmcs12(vcpu)->vm_exit_controls &
+		VM_EXIT_ACK_INTR_ON_EXIT;
+}
+
 static bool nested_exit_on_nmi(struct kvm_vcpu *vcpu)
 {
 	return get_vmcs12(vcpu)->pin_based_vm_exec_control &
@@ -8556,6 +8566,14 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	prepare_vmcs12(vcpu, vmcs12, exit_reason, exit_intr_info,
 		       exit_qualification);
 
+	if ((exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+	    && nested_exit_intr_ack_set(vcpu)) {
+		int irq = kvm_cpu_get_interrupt(vcpu);
+		WARN_ON(irq < 0);
+		vmcs12->vm_exit_intr_info = irq |
+			INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
+	}
+
 	trace_kvm_nested_vmexit_inject(vmcs12->vm_exit_reason,
 				       vmcs12->exit_qualification,
 				       vmcs12->idt_vectoring_info_field,
-- 
1.8.3.1

